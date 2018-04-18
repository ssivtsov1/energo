//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "DBGrid.h"

#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Db.hpp>
#include <DBTables.hpp>
#include <ExtCtrls.hpp>
#include <Qrctrls.hpp>
#include <Quickrpt.hpp>
#include <quickrpt.hpp>

#include "WinGrid.h"
#include "FastSForm.h"


#define MinEditWidth 300
AnsiString SearchValue;
int RecNum, SelIndex, OldState= 1;
TWTReportView *TRv;
TWTQuery *QSearch;
//---------------------------------------------------------------------
// функции класса TWTDBGrid
//---------------------------------------------------------------------
_fastcall TWTDBGrid::TWTDBGrid(TWinControl *owner, TStringList *SQL) : TDBGrid(owner) {
     
  Parent=owner;
  // Создаем запрос
  Query = new TWTQuery(this, SQL);
  DataSource = Query->DataSource;
  FlagCloseQuery = false;

  Initialize();

}
//---------------------------------------------------------------------
_fastcall TWTDBGrid::TWTDBGrid(TWinControl *owner, TWTQuery *query) : TDBGrid(owner) {

  Parent=owner;
  // Запрос
  Query = query;
  DataSource = Query->DataSource;
  FlagCloseQuery = false;

  Initialize();

}

_fastcall TWTDBGrid::TWTDBGrid(TWinControl *owner, AnsiString Name) : TDBGrid(owner) {

  Parent=owner;
  // Создаем запрос
  Table = new TWTTable(this, Name);
  DataSource = Table->DataSource;

  Initialize();

}

void __fastcall TWTDBGrid::Initialize(){

  ShortCutList=new TList();
  WinEdit=NULL;
  FieldSource=NULL;
  FieldDest=NULL;
   FieldLook=NULL;
  StringDest=NULL;
  IncrField=NULL;
  IncrExpr=NULL;

  SearchParams=new TWTSearchParams();
  SearchFParams=new TWTSearchParams();

   CreateMenu();
  Align=alClient;

  DataSource->OnStateChange= DSUpdateData;
  DataSource->OnDataChange= DSDataChange;

  Timer= new TTimer(this);
  Timer->Interval= 3000;
  Timer->Enabled= true;

  TimerOn= true;

  Summa=0;
  CntRecord=0;
  FlSumma=0;
  FromRecord=0;
  ToRecord=0;
  Flag=false;
  ListComment=new TStringList();

  PutHandles();



  StateFilter= false;
  LastFilter= " ";
  Options=Options << dgAlwaysShowSelection;


  FToolBar=new TWTToolBar(this);
  FToolBar->Parent=this;

  TWTToolButton* TB;
  TPopupMenu* PM;
  FToolBar->AddButton("Insert", "Новая запись", NewRecordMenu)->ID="NewRecord";
  FToolBar->AddButton("Delete", "Удалить запись", DelRecordMenu)->ID="DelRecord";
  FToolBar->AddButton("|", NULL, NULL);
   FToolBar->AddButton("SortAsc", "Сортировка ", SortAscMenu)->ID="SortAsc";
  FToolBar->AddButton("Find", "Поиск", SearchMenu)->ID="Find";
  FToolBar->AddButton("FindNext", "Продолжить", ReSearchMenu)->ID="Refind";
  FToolBar->AddButton("FilterOff", "Снять фильтр", RemoveFilterMenu)->ID="DelFilter";

  //FToolBar->AddButton("SortDesk", "Сортировка по убыванию", SortDeskMenu)->ID="SortDesk";
  TB=FToolBar->AddButton("Filter", "Установить фильтр", NULL);
  TB->ID="SetFilter";
  PM=new TPopupMenu(this->Parent);
  PM->OnPopup=FOnPopupFilter;

  TB->DropdownMenu=PM;

  TMenuItem *MI=new TMenuItem(PM);
  MI->Caption="Новый фильтр";
  MI->OnClick=SetFilterMenu;
  PM->Items->Add(MI);

  MI=new TMenuItem(PM);
  MI->Caption="-";
  PM->Items->Add(MI);
  //TB->DropdownMenu=PM;

  FToolBar->AddButton("|", NULL, NULL);
  FToolBar->AddButton("Save", "Сохранить изменения", ApplyUpdatesMenu)->ID="Save";
  FToolBar->AddButton("Cancel", "Отменить изменения", CancelUpdatesMenu)->ID="Cancel";
  FToolBar->AddButton("Refresh", "Обновить данные", RefreshUpdatesMenu)->ID="Refresh";
  FToolBar->AddButton("FullScr", "Полноэкранный просмотр", WinEditMenu)->ID="Full";
  TB=FToolBar->AddButton("Print", "Отчеты", NULL);
  TB->ID="Report";
  PM=new TPopupMenu(this->Parent);
  PM->OnPopup=FOnPopupReport;
  TB->DropdownMenu=PM;

  FToolBar->AddButton("|", NULL, NULL);
  FToolBar->AddButton("savefile", "Копировать данные в...", CopyDataToFile)->ID="Copy";

  FToolBar->ID="Таблица";
  //FToolBar->Parent=NULL;   //OSA

  OnKeyUp=FUserKeyUp;
  OnKeyDown=FUserKeyDown;
  DataSource->OnStateChange=FOnDSStateChange;
  TBookmark SavePlace;


  // -- Юра Дедовец  
  //if (Table)
  //  SavePlace= Table->GetBookmark();
  //if (Query)
  //  SavePlace= Table->GetBookmark();



  InitButtons();     //OSA temp cc
  InitPopupMenu();
  InitButtons();
}

//---------------------------------------------------------------------
_fastcall TWTDBGrid::~TWTDBGrid() {
  // Закрываем запрос
  if (FlagCloseQuery) DEL(Query);
  delete ListComment;
  delete SearchParams;
  for (int x=0;x<ShortCutList->Count;x++) {
    delete (TWTShortCutItem*)ShortCutList->Items[x];
  }
  delete ShortCutList;
 // FToolBar=NULL;
 // delete FToolBar; // OSA

  //delete Table;
  //delete Report;
  //delete Timer;
  //delete DBGrid
  //int i=1;
}

//Установить горячую клавишу
void __fastcall TWTDBGrid::SetShortCut(AnsiString ShortCutText,TNotifyEvent Event){
  for (int x=0;x<ShortCutList->Count;x++) {
    if (((TWTShortCutItem*)ShortCutList->Items[x])->Text==ShortCutText) return;
  }
  TWTShortCutItem* SCI=new TWTShortCutItem();
  SCI->Text=ShortCutText;
  SCI->Event=Event;
  TShortCut SC=TextToShortCut(ShortCutText);
  Word K;
  ShortCutToKey(SC,K,SCI->Shift);
  SCI->Key=K;
  ShortCutList->Add(SCI);
}

//Удалить горячую клавишу
void __fastcall TWTDBGrid::RemoveShortCut(AnsiString ShortCutText){
  for (int x=0;x<ShortCutList->Count;x++) {
    if (((TWTShortCutItem*)ShortCutList->Items[x])->Text==ShortCutText) {
      delete (TWTShortCutItem*)ShortCutList->Items[x];
      ShortCutList->Delete(x);
      return;
    }
  }
}



//---------------------------------------------------------------------
void __fastcall TWTDBGrid::CreateMenu() {
  // Создаем всплывающие меню для DBGrid и поля
  TMenuItem * Items[] = {
    CreateMenuItem("Новая запись", true, NewRecordMenu),
    CreateMenuItem("Удалить запись", true, DelRecordMenu),
    CreateSeparator(),
    CreateMenuItem("Поиск", true, SearchMenu),
    CreateMenuItem("Продолжить", true, ReSearchMenu),
    CreateSeparator(),
    CreateMenuItem("Установить фильтр", true, SetFilterMenu),
    CreateMenuItem("Снять фильтр", true, RemoveFilterMenu),
    CreateSeparator(),
    CreateMenuItem("Сумма по всей колонке",true, SumAllColumn),
    CreateMenuItem("Сумма по нескольким записям", true, SumAnyRecord),
    CreateMenuItem("Очистка сумматора", true, ClearSum),
    CreateSeparator(),
    CreateMenuItem("Сохранить изменения", true, ApplyUpdatesMenu),
    CreateMenuItem("Отменить изменения", true, CancelUpdatesMenu),
    CreateMenuItem("Полноэкранный просмотр", true, WinEditMenu),
    CreateMenuItem("Обновить данные", true, RefreshUpdatesMenu),
    CreateSeparator(),
    CreateMenuItem("Справочник ", false, FOnEditButtonClick),
    CreateSeparator(),
    CreateMenuItem("Печать ", true, PrintRep)
  };

  Items[0]->ShortCut = TextToShortCut("Ins");
  Items[1]->ShortCut = TextToShortCut("Ctrl+Del");
  Items[3]->ShortCut = TextToShortCut("Shift+F6");
  Items[4]->ShortCut = TextToShortCut("F6");
  Items[6]->ShortCut = TextToShortCut("Shift+F7");
  Items[7]->ShortCut = TextToShortCut("Ctrl+F7");
  Items[9]->ShortCut = TextToShortCut("Shift+F5");
  Items[10]->ShortCut = TextToShortCut("Ctrl+F5");
  Items[11]->ShortCut = TextToShortCut("Alt+F5");
  Items[13]->ShortCut = TextToShortCut("Ctrl+S");
  Items[14]->ShortCut = TextToShortCut("Esc");
  Items[15]->ShortCut = TextToShortCut("Ctrl+Enter");
  Items[15]->ShortCut = TextToShortCut("Ctrl+R");
  Items[18]->ShortCut = TextToShortCut("F4");
  Items[20]->ShortCut = TextToShortCut("Ctrl+P");

  PopupMenu = CreatePopup(Parent, Items, ARRAYSIZE(Items) - 1, "PopupMenuDBGrid");
  PopupMenu->OnPopup=FOnPopupUserMenu;
}

void __fastcall TWTDBGrid::FOnPopupUserMenu(TObject *Sender){
//  InitPopupMenu();
}

//---------------------------------------------------------------------
/*TToolBar* __fastcall TWTDBGrid::FindToolBar(){
  return ((TWTWinDBGrid*)Parent)->ToolBar;
} */

//---------------------------------------------------------------------
void  __fastcall TWTDBGrid::InitPopupMenu() {
  bool St= false, Flag= false;
  if (Columns->Count) {
    TField* Field=Columns->Items[SelectedIndex]->Field;
  if (Field) {
    if (Query) {
      if (Query->isModified() || Query->isInserted()) St= true;
      if (Field->DataType== ftSmallint ||
          Field->DataType== ftInteger ||
          Field->DataType== ftWord ||
          Field->DataType== ftFloat)
        Flag= true;
    }
    else {
      if (Table->isModified() || Table->isInserted()) St= true;
      if (Field->DataType== ftSmallint ||
          Field->DataType== ftInteger ||
          Field->DataType== ftWord ||
          Field->DataType== ftFloat)
        Flag= true;
    }
  }
 };
  if (TWTDBGrid::ReadOnly) St= false;
  if (St) {
    PopupMenu->Items->Items[0]->Enabled = false;
    PopupMenu->Items->Items[1]->Enabled = false;
    PopupMenu->Items->Items[3]->Enabled = false;
    PopupMenu->Items->Items[4]->Enabled = false;
    PopupMenu->Items->Items[6]->Enabled = false;
    PopupMenu->Items->Items[7]->Enabled = false;
    PopupMenu->Items->Items[9]->Enabled = false;
    PopupMenu->Items->Items[10]->Enabled = false;
    PopupMenu->Items->Items[11]->Enabled = false;
    PopupMenu->Items->Items[13]->Enabled = true;
    PopupMenu->Items->Items[14]->Enabled = true;
    PopupMenu->Items->Items[15]->Enabled = false;
    PopupMenu->Items->Items[16]->Enabled = false;

    bool Flag=false;
    if (Columns->Count) {
      if (Table) {
        if (Table->GetTField(Columns->Items[SelectedIndex]->Field->FieldName)->GetOnHelp()) {
          Flag=true;
        } else {
          Flag=false;
        }
      } else {
        if (Query->GetTField(Columns->Items[SelectedIndex]->Field->FieldName)->GetOnHelp()) {
          Flag=true;
        } else {
          Flag=false;
        }
      }
    }


/*    if (PopupMenu->Items->Items[17]->ShortCut == TextToShortCut("Enter"))*/
     PopupMenu->Items->Items[18]->Enabled = Flag;

  }
  else {
     if ((ReadOnly) || (TWTDBGrid::ReadOnly)) {
         PopupMenu->Items->Items[0]->Enabled = false;
         PopupMenu->Items->Items[1]->Enabled = false; }
     else {
         PopupMenu->Items->Items[0]->Enabled = true;
         PopupMenu->Items->Items[1]->Enabled = true; }
    PopupMenu->Items->Items[3]->Enabled = true;
    PopupMenu->Items->Items[4]->Enabled = true;
    PopupMenu->Items->Items[6]->Enabled = true;
    PopupMenu->Items->Items[7]->Enabled = true;
    if (Flag) {
      PopupMenu->Items->Items[9]->Enabled = true;
      PopupMenu->Items->Items[10]->Enabled = true;
//      PopupMenu->Items->Items[11]->Enabled = true;
    }
    else {
      PopupMenu->Items->Items[9]->Enabled = false;
      PopupMenu->Items->Items[10]->Enabled = false;
//      PopupMenu->Items->Items[11]->Enabled = false;
    }
    PopupMenu->Items->Items[13]->Enabled = false;
    PopupMenu->Items->Items[14]->Enabled = false;
    PopupMenu->Items->Items[15]->Enabled = true;
    PopupMenu->Items->Items[16]->Enabled = true;

    bool Flag=false;
    if (Columns->Count) {
    TField* Fieldd=Columns->Items[SelectedIndex]->Field;
    if (Fieldd) {
      if (Table) {
        if (Table->GetTField(Columns->Items[SelectedIndex]->Field->FieldName)->GetOnHelp()) {
          Flag=true;
        } else {
          Flag=false;
        }
      } else {
        if (Query->GetTField(Columns->Items[SelectedIndex]->Field->FieldName)->GetOnHelp()) {
          Flag=true;
        } else {
          Flag=false;
        }
      }
    }
    };

/*    if (PopupMenu->Items->Items[17]->ShortCut == TextToShortCut("Enter"))*/
     PopupMenu->Items->Items[18]->Enabled = Flag;
  }
  PopupMenu->Items->Items[11]->Enabled = true;
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::PutHandles() {
  // Для переопределения нажатых клавиш
  OnKeyPress = FKeyPress;

  // Функции обработки событии в TWTQuery
  if (Query) {
     Query->AfterCancel = FAfterCancel;
     Query->AfterClose = FAfterClose;
     Query->AfterDelete = FAfterDelete;
     Query->AfterEdit = FAfterEdit;
     Query->AfterInsert = FAfterInsert;
     Query->AfterOpen = FAfterOpen;
     Query->AfterPost = FAfterPost;
     Query->AfterScroll = FAfterScroll;
     Query->BeforeCancel = FBeforeCancel;
     Query->BeforeClose = FBeforeClose;
     Query->BeforeDelete = FBeforeDelete;
     Query->BeforeEdit = FBeforeEdit;
     Query->BeforeInsert = FBeforeInsert;
     Query->BeforeOpen = FBeforeOpen;
     Query->BeforePost = FBeforePost;
     Query->BeforeScroll = FBeforeScroll;
     Query->OnNewRecord = FOnNewRecord;
  }
  else {
     Table->AfterCancel = FAfterCancel;
     Table->AfterClose = FAfterClose;
     Table->AfterDelete = FAfterDelete;
     Table->AfterEdit = FAfterEdit;
     Table->AfterInsert = FAfterInsert;
     Table->AfterOpen = FAfterOpen;
     Table->AfterPost = FAfterPost;
     Table->AfterScroll = FAfterScroll;
     Table->BeforeCancel = FBeforeCancel;
     Table->BeforeClose = FBeforeClose;
     Table->BeforeDelete = FBeforeDelete;
     Table->BeforeEdit = FBeforeEdit;
     Table->BeforeInsert = FBeforeInsert;
     Table->BeforeOpen = FBeforeOpen;
     Table->BeforePost = FBeforePost;
     Table->BeforeScroll = FBeforeScroll;
     Table->OnNewRecord = FOnNewRecord;
  }
  // Обработчики событии определяемые пользователем
  AfterCancel = NULL;
  AfterClose = NULL;
  AfterDelete = NULL;
  AfterEdit = NULL;
  AfterInsert = NULL;
  AfterOpen = NULL;
  AfterPost = NULL;
  AfterScroll = NULL;
  BeforeCancel = NULL;
  BeforeClose = NULL;
  BeforeDelete = NULL;
  BeforeEdit = NULL;
  BeforeInsert = NULL;
  BeforeOpen = NULL;
  BeforePost = NULL;
  BeforeScroll = NULL;
  OnNewRecord = NULL;

  OnColEnter = FOnColEnter;
  OnColExit = FOnColExit;

  //OnEnter = FOnEnter;
  //OnExit = FOnExit;

  // Вызов справочника
  TDBGrid::OnEditButtonClick = FOnEditButtonClick;
  TDBGrid::OnDblClick= FOnDblClick;
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::DSUpdateData(TObject *Sender) {
  bool St= false;
  if (!TimerOn) return;
  if (TWTDBGrid::ReadOnly) return;
  if (Table) {
    if (Table->State != dsBrowse || Table->State != dsInactive) St= true;
  }
  else
     if (Query->State != dsBrowse || Query->State != dsInactive) St= true;

  if (St)
    Timer->Enabled =false;
  else Timer->Enabled= true;
  InitButtons();     //OSA temp cc
  InitPopupMenu();

}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::DSDataChange(TObject *Sender, TField *Field) {
  bool St= false;
  if (!TimerOn) return;
  if (TWTDBGrid::ReadOnly) return;
  if (Table) {
    if (Table->State == dsBrowse) St= true;
  }
  else
    if (Query->State == dsBrowse) St= true;

  if (St) {
    Timer->Enabled= false;
    Timer->Enabled= true;
  }
  InitButtons();
  InitPopupMenu();
  
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::FOnDblClick(TObject *Sender) {
  AcceptEnter();
  Timer->Enabled = false;
}

//---------------------------------------------------------------------
void _fastcall TWTDBGrid::PrintRep(TObject * Sender) {
 ReportPrint("Default");
}
//--------------------------------------------------------------
void __fastcall TWTDBGrid::ReportPrint(AnsiString LoadName) {
  TWTSelFields *SF=new TWTSelFields(NULL,this,((TWTWinDBGrid *)Parent)->Caption,LoadName);
  if ((LoadName=="Default") || (SF->TableMenuItem->Items[4]->Checked)) {
    //SF->Visible=true;
    //SF->TForm::ShowModal();
    SF->ShowModal();
    int i=1;
    //SF->ShowAs("12");
  }
  SF->Close();
}

void __fastcall TWTDBGrid::FUserKeyUp(TObject* Sender, Word &Key, TShiftState Shift){
  if (Key==40 && InsertFlag && DataSource->State==dsInsert) {
//    DataSource->DataSet->Cancel();
    InsertFlag=false;
  }
  if (Key==13) {
    if (Shift.Contains(ssShift)) Shift=Shift >> ssShift;
  }
}

void __fastcall TWTDBGrid::FUserKeyDown(TObject* Sender, Word &Key, TShiftState Shift){
   if (Key==13) {
     if (!Shift.Contains(ssShift)) AcceptEnter();
   }
  if ((Shift.Contains(ssAlt))& (Key==32))
  {
     TWTFastSForm *FastForm= new TWTFastSForm(this);


  if (FastForm->TForm::ShowModal()==2) {
    delete FastForm;
    return;
  }
  };
   /*((TDBGrid *)this)->Columns->Column[]->ButtonStyle->cbsAuto;
    this->DataSource->DataSet->DisableControls();
   ((TTable *)(this->DataSource->DataSet))->SetKey();

  try
  {
       TLocateOptions SearchOptions;
      SearchOptions.Clear();
      AnsiString fname=this->SelectedField->Name;
      AnsiString ffind=this->SelectedField->AsString;
       bool t5=this->DataSource->DataSet->Locate(fname,ffind ,SearchOptions);

  }
  __finally
  {
   this->DataSource->DataSet->EnableControls();    */


   if (Key==40) InsertFlag=true;
   for (int x=0;x<ShortCutList->Count;x++) {
     TWTShortCutItem *SCI=(TWTShortCutItem*)ShortCutList->Items[x];
     if (Key==SCI->Key && Shift==SCI->Shift)
       SCI->Event(this);
   }
}

void __fastcall TWTDBGrid::FOnDSStateChange(TObject *Sender){
  if (DataSource->State==dsInsert && InsertFlag) {
//    DataSource->DataSet->Cancel();
//    InsertFlag=true;
  } else {
    InsertFlag=false;
  }
}


//---------------------------------------------------------------------
void __fastcall TWTDBGrid::SetQuery(TWTQuery *Query) {
  TWTDBGrid::Query = Query;
  DataSource = Query->DataSource;
}

//---------------------------------------------------------------------
void _fastcall TWTDBGrid::FKeyPress(TObject *Sender, char &Key) {
  int Next = SelectedIndex + 1;
  // в режиме редактирования и вставки
  // по Enter переходим на следующую колонку
  //  для логических полей
  Timer->Enabled= false;
  if ((Key==' ') && (Columns->Items[SelectedIndex]->PickList->Count) && !ReadOnly) {
    bool RO=false;
    if (Table) RO=((TWTField*)Table->ListField->Items[Table->Fields->IndexOf(SelectedField)])->GetReadOnly();
    if (Query) RO=((TWTField*)Query->ListField->Items[Query->Fields->IndexOf(SelectedField)])->GetReadOnly();
    if (!RO) {
      AnsiString TT=SelectedField->DisplayText;
      TStrings *SS=Columns->Items[SelectedIndex]->PickList;
      int XX=SS->IndexOf(TT);
      if (XX==-1) XX=0;
      if (XX==SS->Count-1) TT=SS->Strings[0];
      else  TT=SS->Strings[XX+1];
      if (Table) Table->Edit();
      SelectedField->OnSetText(SelectedField,TT);
      Key=NULL;
      return;
    }
  }
  if ((Key == ' ') && (Fields[SelectedIndex]->DataType == ftBoolean) &&
       (!Columns->Items[SelectedIndex]->ReadOnly) && (!TWTDBGrid::ReadOnly) ) {
     if (Query) {
       Query->Edit();
       if (Fields[SelectedIndex]->AsString == "True")
         Query->Fields->Fields[SelectedIndex]->Value = false;
       else
         Query->Fields->Fields[SelectedIndex]->Value = true;
     }
     else {
       Table->Edit();
       if (Fields[SelectedIndex]->AsString == "True")
         Table->Fields->Fields[SelectedIndex]->Value = false;
       else
         Table->Fields->Fields[SelectedIndex]->Value = true;
     }
   }
  // для цифровых полей
//  if ((Key == ' ') && (Fields[SelectedIndex]->DataType == ftFloat)&&
  if ((Key == ' ') && (Fields[SelectedIndex]->DataType == ftSmallint ||
                       Fields[SelectedIndex]->DataType == ftFloat)&&
       (!Columns->Items[SelectedIndex]->ReadOnly) && (!TWTDBGrid::ReadOnly) ) {
     if (Query) {
       Query->Edit();
       if (Fields[SelectedIndex]->AsString == "1")
          Query->Fields->Fields[SelectedIndex]->Value = 0;
       else
        if ((Fields[SelectedIndex]->AsString == "0") ||
            (Fields[SelectedIndex]->AsString == ""))
          Query->Fields->Fields[SelectedIndex]->Value = 1;
     }
     else  {
       Table->Edit();
       if (Fields[SelectedIndex]->AsString == "1")
          Table->Fields->Fields[SelectedIndex]->Value = 0;
       else
        if ((Fields[SelectedIndex]->AsString == "0") ||
            (Fields[SelectedIndex]->AsString == ""))
          Table->Fields->Fields[SelectedIndex]->Value = 1;
     }
   }
 if (Key == '\r' && Next < FieldCount && EditorMode) {
    // Нельзя переходить в поле ReadOnly (появляются поля ReadOnly?)
    while (Next < FieldCount && Columns->Items[Next]->ReadOnly)
      Next++;
    if (Next < FieldCount) {
      SelectedIndex = Next;
      ShowEditor();
    }
  }

  // и разрешаем полноэкранное редактирование
  PopupMenu->Items->Items[11]->Enabled = !EditorMode || Key == '\r' || Key == '\t';
}

void __fastcall TWTDBGrid::AcceptEnter(){
    TBookmark SavePlace;
   // SavePlace= new TBookmark();
  if (DataSource->State==dsInsert || DataSource->State==dsEdit) return;
  if (DataSource->State==dsInactive) {
    Screen->ActiveForm->Close();
  }

  if (FieldSource && FieldDest) {
    try {
      FieldDest->Field->DataSet->Edit();
      //FieldDest->LookupDS->Refresh();
      FieldDest->Field->AsVariant = FieldSource->Field->AsVariant;
      if ((FieldDest->LookField!=NULL) && (FieldLook!=NULL))
       FieldDest->LookField->Field->Text=FieldLook->Field->Text;
      if (FieldDest->LookupDS!=NULL)
        FieldDest->LookupDS->Refresh();
          // ((TWTDBGrid*)(FieldDest->Owner))->Refresh();
   /* if (FieldDest->Field->DataSet != dsInactive)
      SavePlace=FieldDest->Field->DataSet->GetBookmark();
       SavePlace=FieldDest->Field->DataSet->GetBookmark();
        SavePlace=FieldDest->Field->DataSet->GetBookmark();
         SavePlace=FieldDest->Field->DataSet->GetBookmark();
       if (FieldDest->Field->DataSet->BookmarkValid(SavePlace))
         int rr=0;


      if (FieldDest->Field->DataSet->BookmarkValid(SavePlace))
        {        FieldDest->Field->DataSet->Refresh();
       try {
       // FieldDest->Field->DataSet->Bookmark="SavePlace";
          FieldDest->Field->DataSet->GotoBookmark(SavePlace);
                FieldDest->Field->DataSet->FreeBookmark(SavePlace);
           }
       catch (...) {
       ;
       };
       };  */
      if (FOnAccept!=NULL)  FOnAccept(this);
      Screen->ActiveForm->Close();
    } catch (Exception &e) {
          Application->ShowException(&e);
    }
   }
    else
  {

  if (FieldSource && (StringDest!="0" )) {
    try {
      //*StringDest=FieldSource->Field->Text;
      StringDest=FieldSource->Field->Text;
      if (FOnAccept!=NULL)  FOnAccept(this);
      Screen->ActiveForm->Close();
    } catch (Exception &e) {
          Application->ShowException(&e);
    }
  }
  else
     if (FOnAccept!=NULL)  FOnAccept(this);
  }
}
                                 /*
void __fastcall TWTDBGrid::AcceptEnter(){
  if (DataSource->State==dsInsert || DataSource->State==dsEdit) return;
  if (DataSource->State==dsInactive) {
    Screen->ActiveForm->Close();
  }

  if (FieldSource && FieldDest) {
    try {
      FieldDest->Field->DataSet->Edit();
      FieldDest->Field->AsVariant = FieldSource->Field->AsVariant;
      if (FOnAccept!=NULL)  FOnAccept(this);
      Screen->ActiveForm->Close();
    } catch (Exception &e) {
          Application->ShowException(&e);
    }
  }
  else
  {
  if (FieldSource && (StringDest!="0" )) {
    try {
      //*StringDest=FieldSource->Field->Text;
      StringDest=FieldSource->Field->Text;
      if (FOnAccept!=NULL)  FOnAccept(this);
      Screen->ActiveForm->Close();
    } catch (Exception &e) {
          Application->ShowException(&e);
    }
  }
  else
     if (FOnAccept!=NULL)  FOnAccept(this);
  }
}

                                   */

//---------------------------------------------------------------------
TWTField* __fastcall TWTDBGrid::AddColumn(AnsiString Name) {
  bool St= false;
  TWTField *Field;

  if (Query) {
    if (Query->GetField(Name) != NULL) St= true;
  }
  else
    if (Table->GetField(Name) != NULL) St= true;

  if (St) {
    TColumn *Column=Columns->Add();
    Column->FieldName = Name.UpperCase();
    if (Query)
      Field = Query->GetTField(Name);
    else
      Field = Table->GetTField(Name);
    Field->Column = Column;
    Column->Field=Field->Field;
    Field->SetProperty();
    if (Field->Column->Width > 400)
      Field->Column->Width = 400;
    Field->SetWidth(Field->Column->Width);
  }
  else {
    ShowMessage("Поле " +Name+ " отсутствует в запросе.");
    return NULL;
  }

  return Field;
}
//---------------------------------------------------------------------
TWTField* __fastcall TWTDBGrid::AddColumn(int Index) {
  TWTField *Field;
  if (Index < Query->FieldCount) {
    Columns->Add();
    TColumn *Column = Columns->Items[Columns->Count - 1];
    Field = Query->GetTField(Index);
    Column->FieldName = Field->Field->Name;
    Field->Column = Column;
    Field->SetProperty();
    return Field;
  }
  else {
    ShowMessage("Поле с номером "+IntToStr(Index)+" отсутствует в запросе.");
    return NULL;
  }
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::AddColumn() {
  for(int i = 0; i < FieldCount; i++) {
    AddColumn(i);
  }
}

TWTField* __fastcall TWTDBGrid::AddColumn(AnsiString Name,AnsiString Label,AnsiString FullLabel) {
  TWTField *Field;
  TWTTable *Tabl;
  TWTDBGrid *Gr;
  if (FullLabel=="") FullLabel=Label;
  if (Table) Field = Table->GetTField(Name);
  else Field = Query->GetTField(Name);
  Field->SetDisplayLabel(Label);
  if (AddColumn(Name)==NULL) return NULL;
  if (Columns->Count==1) {
    if (CheckParent(Parent,"TWTWinDBGrid")) ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[0]->Text=FullLabel;
    if (ListComment->Count) ListComment->Clear();
  }
  ListComment->Add(FullLabel);
      Gr= ((TWTDBGrid *)(Field->Owner));
      Tabl=((TWTDBGrid *)(Field->Owner))->Table;
    if (LowerCase(Field->Name)=="name")
      if (Table)
        Table->IndexFieldNames="name";
  return Field;
};

//---------------------------------------------------------------------
void __fastcall TWTDBGrid::SetReadOnly(bool ReadOnly) {
  TWTDBGrid::ReadOnly = ReadOnly;
}

//---------------------------------------------------------------------
// Функции обработки событии запроса
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterCancel(TDataSet* Sender) {
  if (AfterCancel) AfterCancel(this);
  InitButtons();
  InitPopupMenu();
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterPost(TDataSet* Sender) {
  if (AfterPost) AfterPost(this);
   InitButtons();
  InitPopupMenu();

}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterClose(TDataSet* Sender) {
  if (AfterClose) AfterClose(this);
}

void __fastcall TWTDBGrid::FOnEnter(TObject* Sender) {
  if (OnEnter)
   { Color=14869167;
   //OnEnter(this);
   }
   //AfterClose(this);
}
void __fastcall TWTDBGrid::FOnExit(TObject* Sender) {
  if (OnExit)
   {Color=clWhite;
     //OnExit(this);
   }
   //AfterClose(this);
}

//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterDelete(TDataSet* Sender) {
  if (AfterDelete) AfterDelete(this);
  InitButtons();
  InitPopupMenu();
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterEdit(TDataSet* Sender) {
  Timer->Enabled= false;
  TimerOn= false;
  if (Query)
    OldState= Query->State;
  else
    OldState= Table->State;



  if (AfterEdit) AfterEdit(this);
  InitButtons();
  InitPopupMenu();

}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterInsert(TDataSet* Sender) {
  if (AfterInsert) AfterInsert(this);
   if (this->IncrField!=NULL)
   {
      int n_id;
      TStringList *str=new TStringList();
      TWTQuery *NewId;
      str->Add(this->IncrExpr);
   NewId = new TWTQuery(this);
  // NewId->DatabaseName="DatabaseName";
   NewId->Sql=str;
   NewId->Open();
   n_id = NewId->FieldByName("GEN_ID")->AsVariant;
   this->Table->FieldByName(this->IncrField)->AsVariant=n_id;

   };

  InitButtons();
  InitPopupMenu();
 // SelectedField=this->Table->FieldByName(this->IncrField);
  SelectedField=Fields[0];
/*  if (!InsertFlag) SelectedField=Fields[0];
  else InsertFlag=false;*/
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterOpen(TDataSet* Sender) {
  ListComment->Clear();
  if (!ListComment->Count && Columns->Count) {
    for (int x=0;x<Columns->Count;x++) {
      ListComment->Add(Columns->Items[x]->Title->Caption);
    }
  }
  if (AfterOpen) AfterOpen(this);
  InitButtons();
  InitPopupMenu();
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FAfterScroll(TDataSet* Sender) {
  if (OldState != dsBrowse) {
    Timer->Enabled= true;
    TimerOn= true;
  }
 /* if (Columns->Count) {
    for (int x=0;x<Columns->Count;x++) {
         if (LowerCase(Columns->Items[x]->Field->Name)=="name")
      if (Table)
        Table->IndexFieldNames="name";
    }
  };
      */
  if (AfterScroll) AfterScroll(this);
  if (OldState!= dsBrowse)
  /*    if (Columns->Count) {
    for (int x=0;x<Columns->Count;x++) {
         if (LowerCase(Columns->Items[x]->Field->Name)=="name")
      if (Table)
        Table->IndexFieldNames="name";
    }
  };
    */
  InitButtons();
  InitPopupMenu();

  if (WinEdit) {
    AnsiString Capt= ((TForm *)Parent)->Caption+". Запись №";
    WinEdit->Caption= Capt+ IntToStr(DataSource->DataSet->RecNo);
  }

}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeCancel(TDataSet* Sender) {
  if (BeforeCancel) BeforeCancel(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforePost(TDataSet* Sender) {
  if (BeforePost) BeforePost(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeClose(TDataSet* Sender) {
  if (BeforeClose) BeforeClose(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeDelete(TDataSet* Sender) {
  TimerOn= false;
  Timer->Enabled= false;
  if (Query)
    OldState= Query->State;
  else
    OldState= Table->State;
  if (BeforeDelete) BeforeDelete(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeEdit(TDataSet* Sender) {
  if (BeforeEdit) BeforeEdit(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeInsert(TDataSet* Sender) {
  TimerOn= false;
  Timer->Enabled= false;
  if (Query)
    OldState= Query->State;
  else
    OldState= Table->State;
  if (BeforeInsert) BeforeInsert(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeOpen(TDataSet* Sender) {
  if (BeforeOpen) BeforeOpen(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FBeforeScroll(TDataSet* Sender) {
  if (BeforeScroll) BeforeScroll(this);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FOnNewRecord(TDataSet* Sender) {
  if (OnNewRecord) OnNewRecord(this);
}
//---------------------------------------------------------------------
// Функции обработки событии DBGrid
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::FOnColEnter(TObject *Sender) {
//  ShowMessage("Enter"+DBGrid->SelectedField->Name+IntToStr(DBGrid->SelectedIndex));
  InitPopupMenu();
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::FOnColExit(TObject *Sender) {
  InitPopupMenu();
//  ShowMessage("Exit"+DBGrid->SelectedField->Name+IntToStr(DBGrid->SelectedIndex));
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::InsertRecord() {
 if (Query) Query->Insert();
 else Table->Insert();
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::DeleteRecord() {
  if (Query) Query->Delete();
  else Table->Delete();
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::SetFilter(AnsiString Filter) {
  if (Query) Query->SetFilter(Filter);
  else Table->SetFilter(Filter);
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::Search(AnsiString Value) {
  RecNum =1;

  Query->First();
  while (RecNum <= Query->RecordCount) {
    AnsiString S= Query->Fields->Fields[SelectedIndex]->AsString;
    if ((S == Value) || (S.AnsiPos(Value))) break;
    RecNum++;
    Query->Next();
  }
  // нет записей
  if (RecNum > Query->RecordCount) {
    TWTMessage *Mes = new TWTMessage(this);
    Mes->AddLabel("   No records! ");
    Mes->AddButton("   OK   ");
    if (!Mes->Show("Увага"))
      Mes->Close();
  }
}
//---------------------------------------------------------------------
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::ApplyUpdates() {
 if (Query) Query->ApplyUpdates();
 else Table->ApplyUpdates();
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::CancelUpdates() {
  if (Query) Query->CancelUpdates();
  else Table->CancelUpdates();
}
//---------------------------------------------------------------------
// Вызов справочника
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::FOnEditButtonClick(TObject* Sender) {
  // Поле в запросе находим по имени
  TWTField *Field;
  TWTField *KeyField;
  if (Query)
     Field = Query->GetTField(Columns->Items[SelectedIndex]->Field->FieldName);
  else
     Field = Table->GetTField(Columns->Items[SelectedIndex]->FieldName);
  if (Field && Field->GetOnHelp()) {
    if (Field->Field->FieldKind!=fkLookup) Field->GetOnHelp()(Field);
    else {
      if (Query)
       {
        KeyField = Query->GetTField(Field->Field->KeyFields);
        KeyField->FieldLookUpFilter=Field->FieldLookUpFilter;
        KeyField->ExpFieldLookUpFilter=Field->ExpFieldLookUpFilter;
        KeyField->LookupDS=Field->Field->LookupDataSet;
        KeyField->LookField=Field;
        }
      else  {
              KeyField = Table->GetTField(Field->Field->KeyFields);
              KeyField->FieldLookUpFilter=Field->FieldLookUpFilter;
              KeyField->ExpFieldLookUpFilter=Field->ExpFieldLookUpFilter;
              KeyField->LookupDS=Field->Field->LookupDataSet;
              KeyField->LookField=Field;
             };
      Field->GetOnHelp()(KeyField);
    }
  }
}
//---------------------------------------------------------------------
// Функции меню
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::NewRecordMenu(TObject *Sender) {
  Timer->Enabled= false;
  TimerOn= false;
  InsertRecord();
  Timer->Enabled= false;
  TimerOn= false;
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::DelRecordMenu(TObject *Sender) {
  TimerOn= false;
  Timer->Enabled= false;

  int button= Application->MessageBox(" Вы уверены, что хотите удалить текущую запись? ","Внимание", MB_YESNO);
  if (button== IDYES) DeleteRecord();

  TimerOn= true;
  Timer->Enabled= true;
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::SearchMenu(TObject *Sender) {

  Timer->Enabled= false;
  TimerOn= false;

  TWTFilterForm *FilterForm= new TWTFilterForm(this);

  if (FilterForm->TForm::ShowModal()==2) {
    delete FilterForm;
    return;
  }
  SearchParams->Assign(FilterForm->SearchParams);
  SearchParams->Down=FilterForm->RGroup->ItemIndex;
  SearchParams->Case=FilterForm->CBox1->Checked;
  SearchParams->Part=FilterForm->CBox2->Checked;
  ReSearchMenu(NULL);
}

//---------------------------------------------------------------------
void _fastcall TWTDBGrid::ReSearchMenu(TObject *Sender) {

  if (SearchParams->Fields->Count==NULL) return;

  TWTWaitForm *WF=new TWTWaitForm(this, "Идет поиск...","Inspect");

  Application->MainForm->Enabled=false;

  TZDataset *DataSet;
  if (Table) DataSet=Table;
  else DataSet=Query;

  Visible=false;
//  LockWindowUpdate(Handle);
  WF->Show();

  if (SearchParams->Down) DataSet->Next();
  else DataSet->Prior();

  TField *Field;

  Variant TableValue;
  Variant FindValue;

  void* BM=DataSet->GetBookmark();

  bool Find=false;
  while ((!DataSet->Eof) && (!Find) && (!WF->Stop) && (!DataSet->Bof)) {
    Find=true;
    for (int x=0;x<SearchParams->Fields->Count;x++) {
      Field=DataSet->FieldByName(SearchParams->Fields->Strings[x]);
      try {
      switch (Field->DataType) {
        case ftSmallint :
        case ftInteger :
        case ftWord : {
          TableValue=StrToInt(Field->Text);
          FindValue=StrToInt(SearchParams->Values->Strings[x]);
          break;
        }
        case ftFloat : {
          TableValue=float(StrToFloat(Field->Text));
          FindValue=float(StrToFloat(SearchParams->Values->Strings[x]));
          break;
        }
        case ftCurrency : {
          TableValue=StrToCurr(Field->Text);
          FindValue=StrToCurr(SearchParams->Values->Strings[x]);
          break;
        }
        case ftDate : {
          TableValue=StrToDate(Field->Text);
          FindValue=StrToDate(SearchParams->Values->Strings[x]);
          break;
        }
        case ftTime : {
          TableValue=StrToTime(Field->Text);
          FindValue=StrToTime(SearchParams->Values->Strings[x]);
          break;
        }
        default : {
          TableValue=Field->Text;
          FindValue=SearchParams->Values->Strings[x];
          break;
        }
      };
      } catch (...) {
        TableValue=Field->Text;
        FindValue=SearchParams->Values->Strings[x];
      }
      if (SearchParams->Relations->Strings[x]=="=") {
        if (SearchParams->Part && (Field->DataType==ftMemo || Field->DataType==ftFmtMemo || Field->DataType==ftWideString || Field->DataType==ftString)) {
          if (!SearchParams->Case) {
            if (!AnsiUpperCase(TableValue).AnsiPos(AnsiString(FindValue).UpperCase())) {
              Find=false;
              break;
            }
          } else {
            if (!AnsiString(TableValue).AnsiPos(FindValue)) {
              Find=false;
              break;
            }
          }
        } else {
          if (Field->DataType==ftMemo || Field->DataType==ftFmtMemo || Field->DataType==ftWideString || Field->DataType==ftString) {
            if (!SearchParams->Case) {
              if (AnsiString(TableValue).UpperCase()!=AnsiString(FindValue).UpperCase()) {
                Find=false;
                break;
              }
            } else {
              if (AnsiString(TableValue)!=AnsiString(FindValue)) {
                Find=false;
                break;
              }
            }
          } else {
            if (TableValue!=FindValue) {
              Find=false;
              break;
            }
          }
        }
      }


      if (SearchParams->Relations->Strings[x]==">") {
        if (TableValue<=FindValue) {
          Find=false;
          break;
        }
      }


      if (SearchParams->Relations->Strings[x]=="<") {
        if (TableValue>=FindValue) {
          Find=false;
          break;
        }
      }


      if (SearchParams->Relations->Strings[x]==">=") {
        if (TableValue<FindValue) {
          Find=false;
          break;
        }
      }


      if (SearchParams->Relations->Strings[x]=="<=") {
        if (TableValue>FindValue) {
          Find=false;
          break;
        }
      }


      if (SearchParams->Relations->Strings[x]=="<>") {
        if (TableValue==FindValue) {
          Find=false;
          break;
        }
      }

    }
    if (!Find) {
      if (SearchParams->Down) DataSet->Next();
      else DataSet->Prior();
    }
    Application->ProcessMessages();
  }

  if (!Find) DataSet->GotoBookmark(BM);

  delete WF;
  Visible=true;
  SetFocus();
//  LockWindowUpdate(NULL);
  Application->MainForm->Enabled=true;
  if (!Find) ShowMessage("Запись не найдена");
  else {
    Field=DataSet->FieldByName(SearchParams->Fields->Strings[0]);
    int x=0;
    while (Field!=Fields[x]) x++;
    SelectedIndex=x;
  }

}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::SetFilterMenu(TObject *Sender) {
//  Table->Filter="PLU_GRP = '03'";
//  Table->Filtered=true;
  FilterPrint("Default");
}
//---------------------------------------------------------------------
void __fastcall TWTDBGrid::FilterPrint(AnsiString LoadName) {
  // Запрос фильтра
  Timer->Enabled= false;
  TimerOn= false;
  if (Query) AnsiString SQL = Query->Sql->Text;
  if (int p=LoadName.Pos("&")!=0)
   { AnsiString L1=LoadName.SubString(1,p-1);
     AnsiString L2=LoadName.SubString(p+1,LoadName.Length());
     LoadName=L1+L2;
   }
  TWTFilterForm *FilterForm= new TWTFilterForm(this,LoadName);
  if ((LoadName=="Default") || (FilterForm->TableMenuItem->Items[5]->Checked)) {
    if (FilterForm->TForm::ShowModal()==2) {
      delete FilterForm;
      return;
    } 
  }
  AnsiString Filter="";
  AnsiString OldFilter=LastFilter;
  for (int x=0;x<FilterForm->Memo1->Lines->Count;x++) Filter+= FilterForm->Memo1->Lines->Strings[x]+" ";
  LastFilter= FilterForm->Memo1->Lines->Text;
  StateFilter= false;
  FilterForm->Close();
  SetFilter(Filter);
  //((TWTForm*)Parent)->
  ToolBar->EnableButton("DelFilter");
  if (!TWTDBGrid::ReadOnly) {
    TimerOn= true;
    Timer->Enabled= true;
  }
  delete FilterForm;
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::RemoveFilterMenu(TObject *Sender) {
//  Table->Filtered=false;
//  Table->Filter="";
//  return;

  TBookmark  SavePlace;

  Timer->Enabled= false;
  TimerOn=false;
  StateFilter= !StateFilter;
//  if (StateFilter) {
  try {
    if (Table) {
      SavePlace = Table->GetBookmark();
      //Table->Filtered=false;
      //Table->Filter="";
      Table->SetFilter("");
    }
    else {
      SavePlace = Query->GetBookmark();
//      Query->Filtered=false;
//      Table->Filter="";
      Query->SetFilter("");
    }
//    SetFilter();
    if (Table) {
      Table->GotoBookmark(SavePlace);
      Table->FreeBookmark(SavePlace);
    }
    else  {
      Query->GotoBookmark(SavePlace);
      Query->FreeBookmark(SavePlace);
    }
  } catch (...) {};
/*  }
  else
    SetFilter(LastFilter);
*/
//  ((TWTMDIWindow*)Parent)->FilterTable->Active=false;
  if (!TWTDBGrid::ReadOnly) {
    TimerOn= true;
    Timer->Enabled= true;
  }
 // ToolBar->DisableButton("DelFilter");


//  ((TWTMDIWindow*)Parent)->FilterTable->Active=true;
//  ((TWTMDIWindow*)Parent)->FilterBox->Repaint();
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::ApplyUpdatesMenu(TObject *Sender) {
  Timer->Enabled= false;
//  ApplyUpdates();;
  if (Table) {
    try {
      Table->Post();
    } catch(Exception &e) {
      if (e.Message=="Key violation.") e.Message="Нарушение уникальности поля";
      Application->ShowException(&e);
      Table->Cancel();
    }
  }
  else Query->ApplyUpdates();
  TimerOn= true;
  Timer->Enabled= true;
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::CancelUpdatesMenu(TObject *Sender) {
  Timer->Enabled= false;
  CancelUpdates();
  TimerOn= true;
  Timer->Enabled= true;
}

void _fastcall TWTDBGrid::RefreshUpdatesMenu(TObject *Sender) {
  Timer->Enabled= false;
  TDataSet *Gds=DataSource->DataSet;
  bool flag=true;

  if ( (Gds->State == dsEdit) || (Gds->State == dsInsert)  )
  { flag=false;
    ShowMessage("Перед обновлением сохраните данные в таблицах");
  };
  if (flag)
  {
   TBookmark  SavePlace;
   if (Table)
   {
    SavePlace = Table->GetBookmark();
   };
   if (Query)
   {
    SavePlace = Query->GetBookmark();
   };
    DataSource->DataSet->Refresh();
   for (int k=0; k < DataSource->DataSet->FieldCount; k++)
   { if (DataSource->DataSet->Fields->Fields[k]->LookupDataSet!=NULL)
    {  DataSource->DataSet->Fields->Fields[k]->LookupDataSet->Refresh();
    };
    }
    DataSource->DataSet->Refresh();
    //Refresh();

    if (Table) {
     if (Table->BookmarkValid(SavePlace))
         { Table->GotoBookmark(SavePlace);
          Table->FreeBookmark(SavePlace);
         };
      };
    if (Query) {
      if  (Table->BookmarkValid(SavePlace))
      { Query->GotoBookmark(SavePlace);
       Query->FreeBookmark(SavePlace);
      };
      };
   };
  TimerOn= true;
  Timer->Enabled= true;
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::WinEditMenu(TObject *Sender) {
  if (!WinEdit) {
    WinEdit = new TWTWinEdit(this);
    if (CheckParent(Screen->ActiveForm,"TWTMDIWindow")) WinEdit->ShowAs
    ("FullScreenEdit_"+((TWTMDIWindow*)Screen->ActiveForm)->ID);
  }
  else {
    // Активизируем
    WinEdit->Show();
    //WinEdit->SetFocus();
  }
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::SumAllColumn(TObject *Sender) {
  Flag=true;
  if (Table) {
    SumFromTo(1,Table->RecordCount);
  }
  else {
    SumFromTo(1,Query->RecordCount);
  }
  Flag=false;
}

void _fastcall TWTDBGrid:: SortAscMenu(TObject *Sender) {
  TBookmark  SavePlace;
  if (SelectedField!=NULL)
  { if (Table) {
      SavePlace = Table->GetBookmark();
      Table->IndexFieldNames=SelectedField->Name;
      Table->GotoBookmark(SavePlace);
      Table->FreeBookmark(SavePlace);
   }
   else {
     SavePlace = Query->GetBookmark();
      Query->IndexFieldNames=SelectedField->Name;
      Query->GotoBookmark(SavePlace);
      Query->FreeBookmark(SavePlace);

   }

 };
}
void _fastcall TWTDBGrid::SortDeskMenu(TObject *Sender) {
TBookmark  SavePlace;
  if (SelectedField!=NULL)
  { if (Table) {
      SavePlace = Table->GetBookmark();

      Table->IndexFieldNames=SelectedField->Name;
      Table->GotoBookmark(SavePlace);
      Table->FreeBookmark(SavePlace);
   }
   else {
     ;
   }

 };
}
//---------------------------------------------------------------------
void _fastcall TWTDBGrid::SumAnyRecord(TObject *Sender) {
//  int Fr, To;
  FlSumma++;
  if (FlSumma== 1) {
    if (Table) FromRecord= Table->RecNo;
    else FromRecord= Query->RecNo;
    if (CheckParent(Parent,"TWTWinDBGrid")) ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[1]->Text="Начало: "+IntToStr(FromRecord);
  }
  if (FlSumma== 2) {
    FlSumma=0;
    if (Table) ToRecord= Table->RecNo;
    else ToRecord= Query->RecNo;
    SumFromTo(FromRecord,ToRecord);
  }
}

#include "ParamsForm.h";

void __fastcall TWTDBGrid::SumFromTo(int From,int To){
  int Temp;
  bool DirFlag=false;
  double Sum=0;
  int RealCount=0;
  if (To< From) {
    DirFlag=true;
    Temp=To;
    To=From;
    From=Temp;
  }

  TWTWaitForm *WF=new TWTWaitForm(this, "Идет подсчет...","Inspect");
  Application->MainForm->Enabled=false;
  WF->Show();
  Visible=false;
  TZDataset* DS;
  if (Table) DS=Table;
  else DS=Query;
  void* BM=DS->GetBookmark();
  if (Flag) DS->Last();

//  for(int x= From;x<= To;x++) {
  while ((DS->RecNo!=To && DirFlag) || (DS->RecNo!=From && !DirFlag)) {
    if (WF->Stop) {
      DS->GotoBookmark(BM);
      Visible=true;
      delete WF;
      Application->MainForm->Enabled=true;
      SetFocus();
      return;
    }
    RealCount++;
    try {
      Sum+= Columns->Items[SelectedIndex]->Field->AsFloat;
    } catch (...) {}
    if (DirFlag) DS->Next();
    else DS->Prior();
    if (DS->Bof) break;
    Application->ProcessMessages();
  }
  Sum+= Columns->Items[SelectedIndex]->Field->AsFloat;
  RealCount++;

  DS->GotoBookmark(BM);
  Visible=true;
  delete WF;
  Application->MainForm->Enabled=true;
  SetFocus();
  Summa+= Sum;
  CntRecord+= RealCount;
  FlSumma= 0;
  AnsiString S;

  TWTParamsForm* PF=new TWTParamsForm(Application,"Результат суммирования");
  PF->Params->AddSimple("Сумма по "+IntToStr(RealCount)+ " записям",100,FloatToStrF(Sum, ffFixed, 12, 2))->SetReadOnly(true);
  PF->Params->AddSimple("Сумма по "+IntToStr(CntRecord)+ " записям (c учетом предыдущего значения)",100,FloatToStrF(Summa, ffFixed, 12, 2))->SetReadOnly(true);

  PF->TForm::ShowModal();
  delete PF;
  if (CheckParent(Parent,"TWTWinDBGrid")) {
    ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[1]->Text="";
    ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[2]->Text=Columns->Items[SelectedIndex]->Title->Caption +" (Записей: "+IntToStr(RealCount)+" Сумма: "+FloatToStrF(Sum, ffFixed, 12, 2)+")";
  }
}

//Получает ID из GlobalIniFile, если не существует возвращает ""
AnsiString __fastcall TWTDBGrid::GetID(){
  return ((TWTMainForm*)Application->MainForm)->GlobalIniFile->ReadString("Tables",GetAlias(),"");
}

AnsiString __fastcall TWTDBGrid::GetAlias(){
  AnsiString Alias="";
  AnsiString ReportID="";
  TZDataset* DS;
  if (Table) DS=Table;
  else DS=Query;
  for (int x=0;x<DS->FieldCount;x++) {
    Alias=Alias+DS->Fields->Fields[x]->FieldName+IntToStr(DS->Fields->Fields[x]->DataType)+";";
  }
//  if (Table) Alias+=Table->TableName;
  return Alias;
}


//---------------------------------------------------------------------
void _fastcall TWTDBGrid::ClearSum(TObject *Sender) {
  AnsiString STmp;
  STmp= " Сумма " +FloatToStrF(Summa, ffFixed, 9,2)+ ".   По ";
  STmp+= IntToStr(CntRecord)+ " записям.";
  STmp+= "\n\n            Обнулить сумматор?";
  if (Application->MessageBox(STmp.c_str(), "Обнуление сумматора", MB_YESNO)== ID_YES) {
    Summa= 0; CntRecord= 0;
    FlSumma=0;
    if (CheckParent(Parent,"TWTWinDBGrid")) {
      ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[1]->Text="";
      ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[2]->Text="";
    }
  };
}


void __fastcall TWTDBGrid::GetReportsNames(TStrings *Names){
  if (Names==NULL) return;
  AnsiString ReportsID;
  Names->Clear();
  TMemIniFile *IF=((TWTMainForm*)Application->MainForm)->IniFile;
  if (!IF) return;
  ReportsID=GetID();
  IF->ReadSection("ReportsID\\"+ReportsID,Names);
  if (Names->IndexOf("Default")!=-1) Names->Delete(Names->IndexOf("Default"));
}

void __fastcall TWTDBGrid::GetGlobalReportsNames(TStrings *Names){
  if (Names==NULL) return;
  AnsiString ReportsID;
  Names->Clear();
  TMemIniFile *IF=((TWTMainForm*)Application->MainForm)->GlobalIniFile;
  if (!IF) return;
  ReportsID=GetID();
  IF->ReadSection("ReportsID\\"+ReportsID,Names);
  if (Names->IndexOf("Default")!=-1) Names->Delete(Names->IndexOf("Default"));
}

void __fastcall TWTDBGrid::GetFiltersNames(TStrings *Names){
  if (Names==NULL) return;
  AnsiString FiltersID;
  Names->Clear();
  //TMemIniFile *IF=((TWTMainForm*)Application->MainForm)->IniFile;
  TMemIniFile *IF=((TWTMainForm*)Application->MainForm)->GlobalIniFile;
  if (!IF) return;
  /*
  TDataSet* DataSet;
  if (Table) DataSet=Table;
  else DataSet=Query;
  */
  FiltersID=GetID();
  IF->ReadSection("FiltersID\\"+FiltersID,Names);
  if (Names->IndexOf("Default")!=-1) Names->Delete(Names->IndexOf("Default"));
}

#include <stdio.h>

//Копировать данные в файл
void __fastcall TWTDBGrid::CopyDataToFile(TObject *Sender){
  AnsiString TableName=InputBox("Копирование", "Имя файла назначения","");
  if (TableName!="") {
    TSearchRec sr;
    int iAttributes = faAnyFile;
    if (!FindFirst(TableName, iAttributes, sr)) {
      TMsgDlgButtons But;
      But.Clear();
      But=But << mbOK << mbCancel;
      if (MessageDlg("Файл существует. Заменить?", mtConfirmation,But,0)==mrOk) DeleteFile(TableName);
      else return;
    }

    Visible=false;
    TZDataset *DSet;
    if (Table) DSet=Table;
    else DSet=Query;
    void *BM=DSet->GetBookmark();
    DSet->First();
    TWTWaitForm *WF=new TWTWaitForm(this,"Выполняется копирование","inspect");
    Application->MainForm->Enabled=false;
    WF->Show();
    if (TableName.SubString(TableName.Length()-2,3).LowerCase()=="dbf" || TableName.SubString(TableName.Length()-1,2).LowerCase()=="db") {
      AnsiString AS=GetCreateSQL(this,TableName);
      TZPgSqlQuery *TempQ=new TZPgSqlQuery(this);
      TempQ->Sql->Add(AS);
      TempQ->ExecSql();
      delete TempQ;
      TZPgSqlTable *TempT=new TZPgSqlTable(this);
      TempT->TableName=TableName;
      TempT->Open();
      while (!DSet->Eof && !WF->Stop) {
        TempT->Insert();
        for (int x=0;x<Columns->Count;x++){
          TempT->FieldByName(Columns->Items[x]->Field->FieldName)->Assign(Columns->Items[x]->Field);
        }
        TempT->Post();
        DSet->Next();
        Application->ProcessMessages();
      }
      delete TempT;
    } else {
      FILE *f=fopen(TableName.c_str(),"w");
//      int FL=0;
      if (f) {
        for (int x=0;x<Columns->Count;x++) {
          fputc('+',f);
          for (int y=0;y<int(Columns->Items[x]->Width/8);y++) fputc('-',f);
        }
        fputs("+\n",f);
        for ( int x=0;x<Columns->Count;x++) {
          AnsiString FieldText=Columns->Items[x]->Title->Caption.SubString(1,Columns->Items[x]->Width/8);
          FieldText+=FieldText.StringOfChar(' ',int(Columns->Items[x]->Width/8)-FieldText.Length());
          fputc(166,f);
          fputs(FieldText.c_str(),f);
        }
        fputc(166,f);
        fputc('\n',f);
        for (int x=0;x<Columns->Count;x++) {
          fputc(134,f);
          for (int y=0;y<int(Columns->Items[x]->Width/8);y++) fputc('-',f);
        }
        fputc(134,f);
        fputc('\n',f);
        AnsiString FieldText;
        while (!DSet->Eof && !WF->Stop) {
          for (int x=0;x<Columns->Count;x++){
            fputc(166,f);
            FieldText=Columns->Items[x]->Field->DisplayText.SubString(1,Columns->Items[x]->Width/8);
            FieldText+=FieldText.StringOfChar(' ',int(Columns->Items[x]->Width/8)-FieldText.Length());
            fputs(FieldText.c_str(),f);
          }
          fputc(166,f);
          fputc('\n',f);
          DSet->Next();
          Application->ProcessMessages();
        }
      fclose(f);
      }
    }
    DSet->GotoBookmark(BM);
    Application->MainForm->Enabled=true;
    Visible=true;
    delete WF;
  }
}

void __fastcall TWTDBGrid::FSetFieldSource(TWTField* Value){
  FFieldSource=Value;
  TZDataset *DS;
  try {
    if (FFieldDest && FFieldSource) {
      if (Table) DS=Table;
      else DS=Query;
      TLocateOptions LO;
      LO.Clear();
      DS->Locate(FFieldSource->Field->FieldName,FFieldDest->Field->AsVariant,LO);
    }
    if (FFieldSource && FStringDest!="") {
      if (Table) DS=Table;
      else DS=Query;
      TLocateOptions LO;
      LO.Clear();
     // DS->Locate(FFieldSource->Field->FieldName,Variant(*FStringDest),LO);
     DS->Locate(FFieldSource->Field->FieldName,Variant(FStringDest),LO);
    }
  } catch (Exception &e) {
          Application->ShowException(&e);
    }
}

void __fastcall TWTDBGrid::FSetFieldDest(TWTField* Value){
  FFieldDest=Value;
  TZDataset *DS;
  try {
    if (FFieldSource && FFieldDest) {
      if (Table) DS=Table;
      else DS=Query;
      TLocateOptions LO;
      LO.Clear();
      DS->Locate(FFieldSource->Field->FieldName,FFieldDest->Field->AsVariant,LO);
    }
  } catch (...){}
}
void __fastcall TWTDBGrid::FSetFieldLook(TWTField* Value){
  FFieldLook=Value;
}

/*void __fastcall TWTDBGrid::FSetColor(TColor Col)
{ Color=Col;
};
  */
void __fastcall TWTDBGrid::FSetStringDest(AnsiString Value){
  
  FStringDest=Value;
  TZDataset *DS;
  try {
    if (FFieldSource && FStringDest!="") {
      if (Table) DS=Table;
      else DS=Query;
      TLocateOptions LO;
      LO.Clear();
    //  DS->Locate(FFieldSource->Field->FieldName,Variant(*FStringDest),LO);
          DS->Locate(FFieldSource->Field->FieldName,Variant(FStringDest),LO);
    }
  } catch (...) {}
}

void __fastcall TWTDBGrid::Activate(){
  Visible=true;
  Refresh();
  SetFocus();
}
   /*
void __fastcall TWTDBGrid::DeActivate(){
  Visible=false;
 // SetFocus();
}
     */
AnsiString __fastcall TWTDBGrid::Field(AnsiString FieldName){
  try {
    if (!DataSource->DataSet->Fields->FieldByName(FieldName)) return "";
  } catch (...) {
    return "";
  }
  return DataSource->DataSet->Fields->FieldByName(FieldName)->Text;
}


void __fastcall TWTDBGrid::FOnPopupReport(TObject *Sender){
  TPopupMenu *PM=(TPopupMenu*)Sender;

  TMenuItem *MI;

  while (PM->Items->Count!=0) PM->Items->Remove(PM->Items->Items[0]);

  if (((TWTMainForm*)Application->MainForm)->TableMenuItem->Items[4]->Checked) {
    MI=new TMenuItem(PM);
    MI->Caption="Новый отчет";
    MI->OnClick=PrintRep;
    PM->Items->Add(MI);

    MI=new TMenuItem(PM);
    MI->Caption="-";
    PM->Items->Add(MI);
  }

  TStrings* Names=new TStringList();
  GetGlobalReportsNames(Names);

  for (int x=0;x<Names->Count;x++) {
    MI=new TMenuItem(PM);
    MI->Tag=0;
    MI->Caption=Names->Strings[x];
    MI->OnClick=((TWTMainForm*)Application->MainForm)->LoadReport;
    MI->Bitmap->LoadFromResourceName(0,"GReport");;
    PM->Items->Add(MI);
  }
  int CC=Names->Count;
  Names->Clear();
  if (((TWTMainForm*)Application->MainForm)->IniFile!=((TWTMainForm*)Application->MainForm)->GlobalIniFile) GetReportsNames(Names);
  if (Names->Count && CC) {
    MI=new TMenuItem(PM);
    MI->Caption="-";
    PM->Items->Add(MI);
  }

  for ( int x=0;x<Names->Count;x++) {
    MI=new TMenuItem(PM);
    MI->Tag=1;
    MI->Caption=Names->Strings[x];
    MI->OnClick=((TWTMainForm*)Application->MainForm)->LoadReport;
    MI->Bitmap->LoadFromResourceName(0,"Report");;
    PM->Items->Add(MI);
  }

  if (!(Names->Count || CC)) {
    TMenuItem *MI=new TMenuItem(PM);
    MI->Caption="Нет отчетов";
    MI->Enabled=false;
    PM->Items->Add(MI);
  }

  delete Names;
}


void __fastcall TWTDBGrid::FOnPopupFilter(TObject *Sender){
  TPopupMenu *PM=(TPopupMenu*)Sender;

  while (PM->Items->Count!=2) PM->Items->Remove(PM->Items->Items[2]);

  TMenuItem *MI;

  TStrings* Names=new TStringList();
  GetFiltersNames(Names);

  for (int x=0;x<Names->Count;x++) {
    MI=new TMenuItem(PM);
    MI->Caption=Names->Strings[x];
    MI->OnClick=((TWTMainForm*)Application->MainForm)->LoadFilter;
    MI->Bitmap->LoadFromResourceName(0,"Filter");
    PM->Items->Add(MI);
  }

  if (!Names->Count) {
    TMenuItem *MI=new TMenuItem(PM);
    MI->Caption="Нет фильтров";
    MI->Enabled=false;
    PM->Items->Add(MI);
  }

  delete Names;
}

void __fastcall TWTDBGrid::InitButtons() {
 bool St=false;
  if (Table) {
      if (Table->isModified() ||
         Table->isInserted()) St= true;
  }
  else
      if (Query->isModified() ||
         Query->isInserted()) St= true;

  if (ReadOnly) St= false;
  if (St) {
    if (WinEdit) {
      WinEdit->ToolBar->Buttons[0]->Enabled= false;
      WinEdit->ToolBar->Buttons[1]->Enabled= false;
      WinEdit->ToolBar->Buttons[3]->Enabled= false;
      WinEdit->ToolBar->Buttons[4]->Enabled= false;
      WinEdit->ToolBar->Buttons[5]->Enabled= false;
      WinEdit->ToolBar->Buttons[6]->Enabled= false;
      WinEdit->ToolBar->Buttons[8]->Enabled= true;
      WinEdit->ToolBar->Buttons[9]->Enabled= true;
    }

    ToolBar->DisableButton("NewRecord");
    ToolBar->DisableButton("DelRecord");
    ToolBar->DisableButton("Find");
    ToolBar->DisableButton("Refind");
    ToolBar->DisableButton("DelFilter");
    ToolBar->DisableButton("SetFilter");
    ToolBar->EnableButton("Save");
    ToolBar->EnableButton("Cancel");
    ToolBar->DisableButton("Full");
    ToolBar->DisableButton("Report");
    ToolBar->DisableButton("Copy");
    ToolBar->DisableButton("Refresh");
  }
  else {
     if (ReadOnly) {// || (TWTDBGrid::ReadOnly)) {
       if (WinEdit) {
         WinEdit->ToolBar->Buttons[0]->Enabled= false;
         WinEdit->ToolBar->Buttons[1]->Enabled= false;
       }
       ToolBar->DisableButton("NewRecord");
       ToolBar->DisableButton("DelRecord");
     }
     else {
       if (WinEdit) {
         WinEdit->ToolBar->Buttons[0]->Enabled= true;
         WinEdit->ToolBar->Buttons[1]->Enabled= true;
       }
       ToolBar->EnableButton("NewRecord");
       ToolBar->EnableButton("DelRecord");
     }
      if (WinEdit) {
        WinEdit->ToolBar->Buttons[3]->Enabled= true;
        WinEdit->ToolBar->Buttons[4]->Enabled= true;
        WinEdit->ToolBar->Buttons[5]->Enabled= true;
        WinEdit->ToolBar->Buttons[6]->Enabled= true;
        WinEdit->ToolBar->Buttons[8]->Enabled= false;
        WinEdit->ToolBar->Buttons[9]->Enabled= false;
      }

     ToolBar->EnableButton("Find");
     ToolBar->EnableButton("Refind");
     bool Flag=false;
     if (Table) {
       if (Table->Filter!=Table->DefaultFilter) Flag=true;
     } else {
       if (Query->Filter!=Query->DefaultFilter) Flag=true;
     }

     if (Flag) ToolBar->EnableButton("DelFilter");
     else ToolBar->DisableButton("DelFilter");

     ToolBar->EnableButton("SetFilter");
     ToolBar->DisableButton("Save");
     ToolBar->DisableButton("Cancel");
     ToolBar->EnableButton("Full");
     ToolBar->EnableButton("Report");
     ToolBar->EnableButton("Copy");
     ToolBar->EnableButton("Refresh");
   }//*/  // tool OSA
}


//---------------------------------------------------------------------
// функции класса TWTWinEdit
//---------------------------------------------------------------------
AnsiString Capt="";

_fastcall TWTWinEdit::TWTWinEdit(TWTDBGrid *owner) : TWTMDIWindow(owner) {

  DBGrid = owner;
  AutoScroll= true;
  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=true;
  TForm::OnActivate=FormActivate;
  TForm::OnCreate=FormActivate;
//  Graphics::TBitmap *BM;

  //Добавляем батоны для работы с полноэкранным просмотром
  AddButton("Cancel", "Отменить изменения", DBGrid->CancelUpdatesMenu);
  AddButton("Save", "Сохранить изменения", DBGrid->ApplyUpdatesMenu);
  AddButton("|", NULL, NULL);
  AddButton("Last", "Последняя запись", LastRecordMenu);
  AddButton("Next", "Следующая запись", NextRecordMenu);
  AddButton("Prev", "Предыдущая запись", PriorRecordMenu);
  AddButton("First", "Первая запись", FirstRecordMenu);
  AddButton("|", NULL, NULL);
  AddButton("Delete", "Удалить запись", DBGrid->DelRecordMenu);
  AddButton("Insert", "Новая запись", DBGrid->NewRecordMenu);
  AddButton("Refresh", "Обновить", DBGrid->RefreshUpdatesMenu);


  ToolBar->Buttons[0]->Enabled=!DBGrid->ReadOnly;
  ToolBar->Buttons[1]->Enabled=!DBGrid->ReadOnly;
  ToolBar->Buttons[8]->Enabled=false;
  ToolBar->Buttons[9]->Enabled=false;

  ToolBar->Height= 29;

  // Создаем всплывающие меню
  TMenuItem * Items[] = {
    CreateMenuItem("Новая запись", !DBGrid->ReadOnly, DBGrid->NewRecordMenu, "", "Ins"),
    CreateMenuItem("Удалить запись", !DBGrid->ReadOnly, DBGrid->DelRecordMenu, "", "Ctrl+Del"),
    CreateMenuItem("Предыдущая запись", true, PriorRecordMenu, "", "PgUp"),
    CreateMenuItem("Следующая запись", true, NextRecordMenu, "", "PgDn"),
    CreateSeparator(),
    CreateMenuItem("Сохранить изменения", !DBGrid->ReadOnly, DBGrid->ApplyUpdatesMenu, "", "Alt+Enter"),
    CreateMenuItem("Отменить изменения", !DBGrid->ReadOnly, DBGrid->CancelUpdatesMenu, "", "Esc"),
    CreateMenuItem("Обновить данные", true, DBGrid->RefreshUpdatesMenu, "", "Ctrl+R"),
  };
//CreateMenuItem("Обновить данные", true, DBGrid->RefreshUpdatesMenu, "", "Ctrl+R"),
  PopupMenu = CreatePopup(this, Items, ARRAYSIZE(Items) - 1, "PopupMenuWinEdit");

  TZDataset* DataSet;
  if (DBGrid->Table) DataSet=DBGrid->Table;
  else DataSet=DBGrid->Query;

  if (CheckParent(DBGrid->Parent,"TForm")) Capt= ((TForm *)DBGrid->Parent)->Caption+". Запись №";
  else Capt= "Запись №";
  Caption= Capt+ IntToStr(DataSet->RecNo);
  if (WindowMenu)
    if (CheckParent(DBGrid->Parent,"TForm")) WindowMenu->Caption = ((TForm *)DBGrid->Parent)->Caption+". Просмотр записи таблицы";
    else WindowMenu->Caption = "Просмотр записи таблицы";


  Panel = new TPanel(this);
  Panel->Left = 0;
  Panel->Top = 32;
//  Panel->Align= alClient;
  Panel->BevelInner = bvNone;
  Panel->BevelOuter = bvLowered;
  Panel->BorderStyle = bsSingle;
  Panel->BorderWidth = 0;
  Panel->BevelWidth = 0;
  Panel->TabOrder = 0;
//  Panel->Parent = this;
  Panel->ParentFont = true;
  Panel->Parent=this;

  FieldName = new TList();
  ListEdit = new TList();

  // Количество полей
  int Count = DBGrid->Columns->Count;
  int MaxLabelWidth = 0;
  int MaxEditWidth = 0;
  int i, j = 0;

  // Максимальный размер строки заголовка поля в пикселах
  // и список надписей
  // Список полей редактирования
  TLabel *Label;
  TDBEdit *DBEdit;
  TDBComboBox* CBox;
  TDBMemo *DBMemo;
  TEdit *Edit;
  TSpeedButton *Button;
  TWTField *Field;
  TStrings *SS;

  // Список
  ListButton = new TList();

  for (i = 0; i < Count; i++) {
   SS=DBGrid->Columns->Items[i]->PickList;
   if (DBGrid->Query)
     Field = DBGrid->Query->GetTField(DBGrid->Columns->Items[i]->FieldName);
   else
     Field = DBGrid->Table->GetTField(DBGrid->Columns->Items[i]->FieldName);

    Field->Column=DBGrid->Columns->Items[i];

    Label = new TLabel(this);
    Label->Parent = Panel;
    Label->Left = 9;
    Label->Font->Style=Label->Font->Style << fsBold;
    Label->AutoSize= true;
    Label->Caption = Field->Column->Title->Caption;
    Label->Caption = DBGrid->Columns->Items[i]->Title->Caption;
    if (MaxLabelWidth < Label->Width)
      MaxLabelWidth = Label->Width + 20;
    FieldName->Add(Label);

    // Иначе это не поле в запросе ???
    if (Field->Field != NULL) {
      TFieldType DataType = Field->Field->DataType;
      switch (DataType) {
        case ftString:
        case ftSmallint:
        case ftInteger:
        case ftWord:
        case ftFloat:
        case ftCurrency:
        case ftBCD:
        case ftDate:
        case ftTime:
        case ftDateTime:
        case ftAutoInc:
         if (SS->Count && !Field->GetReadOnly() && !DBGrid->ReadOnly) {
          CBox = new TDBComboBox(this);
          CBox->Parent = Panel;
          CBox->DataSource = DBGrid->DataSource;
          CBox->DataField = Field->GetFieldName();
          CBox->Width = Field->Column->Width+20;
          CBox->ReadOnly = Field->GetReadOnly() || DBGrid->ReadOnly;
//          CBox->Style=csDropDownList;
          CBox->OnEnter=FOnExit;
          // Обработчик клавиатуры
          CBox->OnKeyDown = FKeyDown;
          if (CBox->Width > MaxEditWidth)
            MaxEditWidth = CBox->Width;
          for (int x=0;x<SS->Count;x++) CBox->Items->Add(SS->Strings[x]);
          ListEdit->Add(CBox);
          ListButton->Add(NULL);
//          CBox->ItemIndex=0;
         } else {
          DBEdit = new TDBEdit(this);
          DBEdit->Parent = Panel;
          DBEdit->DataSource = DBGrid->DataSource;
          DBEdit->DataField = Field->GetFieldName();
          DBEdit->Width = Field->Column->Width;
          DBEdit->ReadOnly = Field->GetReadOnly() || DBGrid->ReadOnly;
          // Обработчик клавиатуры
          DBEdit->OnKeyDown = FKeyDown;
          DBEdit->OnEnter=FOnExit;
          if (DBEdit->Width > MaxEditWidth)
            MaxEditWidth = DBEdit->Width;
          ListEdit->Add(DBEdit);
          // Поле требует наличия справочника
          if (Field->GetOnHelp() && (!DBGrid->ReadOnly)) {

            /*BM=new Graphics::TBitmap();
            BM->LoadFromResourceName(0,"Spr");*/

            Button = new TSpeedButton(this);
            Button->Width = 20;
            Button->Glyph->LoadFromResourceName(0,"Spr");
            Button->Flat=true;
            Button->ParentFont = true;
            Button->Parent = Panel;
            Button->OnClick = FOnHelpClick;

            ListButton->Add(Button);
            if (DBEdit->Width + 20 > MaxEditWidth)
              MaxEditWidth = DBEdit->Width + 20;
          }
          else {
            ListButton->Add(NULL);
            j++;
          }
         }
         break;

        case ftMemo:
        case ftFmtMemo:
          DBMemo = new TDBMemo(this);
          DBMemo->Parent = Panel;
          DBMemo->DataSource = DBGrid->DataSource;
          DBMemo->DataField = Field->GetFieldName();
          DBMemo->ClientWidth = 0;
          DBMemo->ReadOnly = Field->GetReadOnly() || DBGrid->ReadOnly;
          // Размер три строки
          DBMemo->ClientHeight = StringSize("A", DBMemo->Font, 1) * 3 + 3;

          if (MaxEditWidth < MinEditWidth)
            MaxEditWidth = MinEditWidth;
          // Обработчик клавиатуры
          DBMemo->OnKeyDown = FKeyDown;
          DBMemo->OnEnter=FOnExit;
          ListEdit->Add(DBMemo);
          ListButton->Add(NULL);
          break;

        case ftBoolean:
          // Должен быть свой обработчик отображения и переключения по нажатию
         if (SS->Count && !Field->GetReadOnly() && !DBGrid->ReadOnly) {
          CBox = new TDBComboBox(this);
          CBox->Parent = Panel;
          CBox->DataSource = DBGrid->DataSource;
          CBox->DataField = Field->GetFieldName();
          CBox->Width = Field->Column->Width+20;
          CBox->ReadOnly = Field->GetReadOnly() || DBGrid->ReadOnly;
//          CBox->Style=csDropDownList;
          // Обработчик клавиатуры
          CBox->OnKeyDown = FKeyDown;
          CBox->OnEnter=FOnExit;
          if (CBox->Width > MaxEditWidth)
            MaxEditWidth = CBox->Width;
          for (int x=0;x<SS->Count;x++) CBox->Items->Add(SS->Strings[x]);
//          CBox->ItemIndex=0;
          ListEdit->Add(CBox);
          ListButton->Add(NULL);
         } else {
          DBEdit = new TDBEdit(this);
          DBEdit->Parent = Panel;
          DBEdit->DataSource = DBGrid->DataSource;
          DBEdit->DataField = Field->GetFieldName();
          // Обработчик клавиатуры
          DBEdit->OnKeyDown = FKeyDown;
          DBEdit->OnEnter=FOnExit;
          DBEdit->ReadOnly = Field->GetReadOnly() || DBGrid->ReadOnly;
          ListEdit->Add(DBEdit);
          ListButton->Add(NULL);
         }
         break;
        case ftUnknown:
        case ftBytes:
        case ftVarBytes:
        case ftBlob:
        case ftGraphic:
        case ftParadoxOle:
        case ftDBaseOle:
        case ftTypedBinary:
        case ftCursor:
          DBEdit = new TDBEdit(this);
          DBEdit->Parent = Panel;
          DBEdit->DataSource = DBGrid->DataSource;
          DBEdit->DataField = Field->GetFieldName();
          DBEdit->ReadOnly = true;
          // Обработчик клавиатуры
          DBEdit->OnKeyDown = FKeyDown;
          DBEdit->OnEnter=FOnExit;
          DBEdit->ReadOnly = Field->GetReadOnly() || DBGrid->ReadOnly;
          ListEdit->Add(DBEdit);
          break;
      }
    }
    else {
      // Не поле в запросе
      Edit = new TEdit(this);
      Edit->Parent = Panel;
      Edit->Text = "";
      Edit->ReadOnly = true;
      // Обработчик клавиатуры
      Edit->OnKeyDown = FKeyDown;
      Edit->OnEnter=FOnExit;
      ListEdit->Add(DBEdit);
    }
  }

  // Задаем координаты
//  Panel->Parent = this;
  int CurrTop = 5;
  j=0;
  TControl *Control;
  for (i = 0; i < Count; i++) {
   if (DBGrid->Query)
     Field = DBGrid->Query->GetTField(DBGrid->Columns->Items[i]->FieldName);
   else
     Field = DBGrid->Table->GetTField(DBGrid->Columns->Items[i]->FieldName);

    Label = (TLabel *)FieldName->Items[i];
    Control = (TControl *)ListEdit->Items[i];
//    Label->AutoSize = true;
    Label->Width = MaxLabelWidth+ 10;
    Label->Top = CurrTop;
    Label->Alignment = taLeftJustify;
    Control->Left = Label->Left + MaxLabelWidth + 20;
    Control->Top = CurrTop;

    if (Field->Field != NULL) {
      TFieldType DataType = Field->Field->DataType;
      switch (DataType) {
        case ftString:
        case ftSmallint:
        case ftInteger:
        case ftWord:
        case ftFloat:
        case ftCurrency:
        case ftBCD:
        case ftDate:
        case ftTime:
        case ftDateTime:
        case ftAutoInc:
        case ftBoolean:
            Button = (TSpeedButton *)ListButton->Items[j];
            if (Button) {
               Button->Left = Control->Left + Control->Width + 5;
               Button->Top = Control->Top;
            };
            j++;
        break;
        default: break;
      };
    };
    if (Control->ClientWidth == 0)
      Control->ClientWidth = MaxEditWidth;
    CurrTop += (Label->Height > Control->Height ? Label->Height : Control->Height) + 5;
  }

  // Добавляем кнопки ОК и Отменить ?????????

  // Корректируем координаты окна и панели
  Panel->Width = MaxLabelWidth + MaxEditWidth + 42;
  Panel->Height = CurrTop + 9;

//  FormStyle= fsMDIChild;

/*  if (WindowState != wsMaximized) {
    ClientWidth = Panel->Width + 5;
    ClientHeight = Panel->Height + 5;
  }
  else {
    if (Panel->Width < ClientWidth - 2)
      Panel->Width = ClientWidth - 2;
    if (Panel->Height < ClientHeight - 2)
      Panel->Height = ClientHeight - 2;
  } */

  ActiveControl=((TDBEdit *)ListEdit->Items[0]);

//  Width-=2;
//  BorderStyle=bsDialog;
  Width=Panel->Width+6+3;
  Height=Panel->Height+57+3+StatusBar->Height;
//  Height-=2;

  SetComment(DBGrid->ListComment->Strings[0]);
}
//---------------------------------------------------------------------
_fastcall TWTWinEdit::~TWTWinEdit() {
  DBGrid->WinEdit = NULL;
  DEL(FieldName);
  DEL(ListEdit);
}

void __fastcall TWTWinEdit::SetComment(AnsiString Comment){
  StatusBar->SimpleText=Comment;
}

//---------------------------------------------------------------------
void _fastcall TWTWinEdit::FKeyDown(TObject *Sender, Word &Key, TShiftState Shift) {
  // По Enter переходим на следующее поле
  if (Key==' ') {
    int XX=ListEdit->IndexOf(Sender);
    if ((XX!=-1) && (AnsiString(Sender->ClassName())=="TDBComboBox")) {
      TDBComboBox* CB=(TDBComboBox*)Sender;
//      CB->DataSource->DataSet->Edit();
      if (CB->ItemIndex==CB->Items->Count-1) CB->ItemIndex=0;
      else CB->ItemIndex+=1;
//      if (CB->DataSource->DataSet->FieldByName(CB->FieldName)->OnSetText) CB->DataSource->DataSet->FieldByName(CB->FieldName)->OnSetText(CB->DataSource->DataSet->FieldByName(CB->FieldName),TT);
      Key=NULL;
      return;
    }
  }
  if (Key==115) {
    int XX=ListEdit->IndexOf(Sender);
    if (XX==-1) return;
    if (ListButton->Items[XX]!=NULL) {
      if (((TSpeedButton*)ListButton->Items[XX])->OnClick) ((TSpeedButton*)ListButton->Items[XX])->OnClick((TSpeedButton*)ListButton->Items[XX]);
    }
  }
  if (Key == '\r') {
    // Находим следующий
    try {
      TWinControl *tmp = FindNextControl(((TWinControl *)Sender), true, true, false);
      tmp->SetFocus();
    }
    catch ( ... ) {
    }
  }
}
//---------------------------------------------------------------------
void __fastcall TWTWinEdit::OnResize(TObject *Sender) {
  if (Active && Panel) {
    if (WindowState != wsMaximized) {
      if (ClientWidth > Panel->Width + 2)
        ClientWidth = Panel->Width + 2;
      if (ClientHeight > Panel->Height + 2)
        ClientHeight = Panel->Height + 2;
    }
    else {
      if (Panel->Width < ClientWidth - 2)
        Panel->Width = ClientWidth - 2;
      if (Panel->Height < ClientHeight - 2)
        Panel->Height = ClientHeight - 2;
    }
  }
}
//---------------------------------------------------------------------
void _fastcall TWTWinEdit::FOnExit(TObject *Sender) {
   int XX=ListEdit->IndexOf(Sender);
   SetComment(DBGrid->ListComment->Strings[XX]);
}
//---------------------------------------------------------------------
// Обработчик вызова справочника
//---------------------------------------------------------------------
void _fastcall TWTWinEdit::FOnHelpClick(TObject *Sender) {
int i = 0;
  // Номер поля запроса
  while ((TSpeedButton *)ListButton->Items[i] != Sender) i++;
  // Имя колонки в запросе
  TColumn *Column = DBGrid->Columns->Items[i];
  TWTField *Field;
  if (DBGrid->Query)
    Field = DBGrid->Query->GetTField(Column->FieldName);
  else
    Field = DBGrid->Table->GetTField(Column->FieldName);

  TTEventField Event = Field->GetOnHelp();
  Event(Field);
}
//---------------------------------------------------------------------
void _fastcall TWTWinEdit::PriorRecordMenu(TObject *Sender) {
  TZDataset* DataSet;
  if (DBGrid->Table) DataSet=DBGrid->Table;
  else DataSet=DBGrid->Query;
  DataSet->Prior();
  Caption= Capt +IntToStr(DataSet->RecNo);
}
//---------------------------------------------------------------------
void _fastcall TWTWinEdit::NextRecordMenu(TObject *Sender) {
  TZDataset* DataSet;
  if (DBGrid->Table) DataSet=DBGrid->Table;
  else DataSet=DBGrid->Query;
  DataSet->Next();
  Caption= Capt +IntToStr(DataSet->RecNo);
}

//---------------------------------------------------------------------
TToolBar* __fastcall TWTWinEdit::FindToolBar(int Tag){
  for (int x=0;x<MainCoolBar->Bands->Count;x++)
    if (MainCoolBar->Bands->Items[x]->Control->Tag==Tag)
      return (TToolBar*)(MainCoolBar->Bands->Items[x]->Control);
  return NULL;
}

//---------------------------------------------------------------------
void __fastcall TWTWinEdit::OnClose(TObject *Sender){

}

void _fastcall TWTWinEdit::LastRecordMenu(TObject *Sender){
  TZDataset *DataSet;
  if (DBGrid->Table) DataSet=DBGrid->Table;
  else DataSet=DBGrid->Query;
  DataSet->Last();
}

void _fastcall TWTWinEdit::FirstRecordMenu(TObject *Sender){
  TZDataset *DataSet;
  if (DBGrid->Table) DataSet=DBGrid->Table;
  else DataSet=DBGrid->Query;
  DataSet->First();
}



//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Функции класса TMyWindow
//---------------------------------------------------------------------
_fastcall TMyWindow::TMyWindow(TWinControl *owner, AnsiString Str) : TForm(owner,1) {

  AutoScroll= false;
  BorderStyle= bsSingle;

  Panel= new TPanel(this);
  Panel->BevelInner=bvLowered;
  Panel->BevelOuter=bvNone;
  Panel->Top=0;
  Panel->Left=0;
  Panel->Anchors= Panel->Anchors>> akTop>> akLeft>> akRight>> akBottom;
  Panel->Parent=this;
  Panel->Width=300;
  Panel->Height=143;

  Width=Panel->Width+6;
  Height=Panel->Height+25;

  LField= new TLabel(this);
  LField->Left= 10;
  LField->Top= 15;
  LField->Font->Style= LField->Font->Style<< fsBold;
  LField->Width = StringSize(Str, LField->Font);
  LField->Height = StringSize('A', LField->Font, 1);;
  LField->Caption = "Поле: ";
  LField->Parent = Panel;

  CBox= new TComboBox(this);
  CBox->Top= 12;
  CBox->Left= 80;
  CBox->Parent= Panel;

  Label = new TLabel(this);
  Label->Left = 10;
  Label->Top = LField->Top+ LField->Height+ 23;
  Label->Font->Style= Label->Font->Style<< fsBold;
  Label->Width = StringSize(Str, Label->Font);
  Label->Height = StringSize('A', Label->Font, 1);;
  Label->Caption = Str;
  Label->Parent = Panel;

  Edit = new TEdit(this);
  Edit->Left = 80;
  Edit->Top = Label->Top- 3;
  Edit->Width= 200;
  Edit->Parent = Panel;
  Edit->OnKeyPress = FKeyPress;

/*  Graphics::TBitmap *BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Yes");*/

  Button = new TBitBtn(this);
  Button->Caption = "OK";
  Button->Default = false;
  Button->Kind= Buttons::bkCustom;
  Button->Glyph->LoadFromResourceName(0,"Yes");
  Button->Left= ClientWidth/2- Button->Width/2;
  Button->Top= Edit->Top+ Edit->Height+ 15;
  Button->ParentFont = true;
  Button->ModalResult = mrNone;
  Button->Parent = Panel;
  Button->OnClick = ButtonClick;

  Position = poScreenCenter;
//  FormStyle= fsMDIChild;
//  Edit->SetFocus();
  ActiveControl=Edit;

}

//----------------------------------------------------------------------------
void _fastcall TMyWindow::ButtonClick(TObject *Sender) {
  ModalResult= 1;
}

//----------------------------------------------------------------------------
void _fastcall TMyWindow::FKeyPress(TObject *Sender, char &Key) {
  // По Enter выходим
  if (Key == '\r')
    ModalResult = 1;
  if (Key == 27)
    ModalResult = -1;
}
//---------------------------------------------------------------------
_fastcall TMyWindow::~TMyWindow() {
}
//----------------------------------------------------------------------------
void TMyWindow::OnClose(TObject *Sender, TCloseAction &Action) {
  if (!ModalResult) {
    // Форму не закрываем - она модальная
    Action = caNone;
    ModalResult = -1;
    return;
  }
//  TWTMDIWindow::OnClose(Sender, Action);
}
//---------------------------------------------------------------------



__fastcall TWTSearchParams::TWTSearchParams() {
  Down=true;
  Case=false;
  Part=false;
  Fields=new TStringList();
  Relations=new TStringList();
  Values=new TStringList();
}

__fastcall TWTSearchParams::~TWTSearchParams() {
  delete Fields;
  delete Relations;
  delete Values;
}

void __fastcall TWTSearchParams::Clear() {
  Fields->Clear();
  Relations->Clear();
  Values->Clear();
}

void __fastcall TWTSearchParams::AddLine(AnsiString Field,AnsiString Relation,AnsiString Value){
  Fields->Add(Field);
  Relations->Add(Relation);
  Values->Add(Value);
}

void __fastcall TWTSearchParams::RemoveLine(){
  Fields->Delete(Fields->Count-1);
  Relations->Delete(Relations->Count-1);
  Values->Delete(Values->Count-1);
}

void __fastcall TWTSearchParams::Assign(TWTSearchParams *SP){
  Down=SP->Down;
  Case=SP->Case;
  Part=SP->Part;
  Fields->Assign(SP->Fields);
  Relations->Assign(SP->Relations);
  Values->Assign(SP->Values);
}

__fastcall TWTWaitForm::TWTWaitForm(TComponent* AOwner,AnsiString Label,AnsiString ImageName) : TForm(AOwner,1) {

  Timer=new TTimer(this);
  Timer->Interval=250;
  Timer->Enabled=true;
  Timer->OnTimer=FOnTimer;
  TickCount=0;

  Stop=false;
  BorderStyle=bsDialog;
  Height=100;
  Position=poScreenCenter;
  Caption="Ждите...";

  TLabel *L=new TLabel(this);
  L->Caption=Label;
  L->Top=10;
  L->Left=10;
  L->Parent=this;

  Image=new TImage(this);
//  Image->Picture->LoadFromResourceName(0,ImageName);
  Image->AutoSize=true;
  Image->Top=5;
  Image->Left=L->Left+StringSize(L->Caption,L->Font)+10;
  Image->Parent=this;

  Width=Image->Left+30;

  TPanel *P=new TPanel(this);
  P->Height=40;
  P->Align=alBottom;
  P->Caption="";
  P->Parent=this;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Cancel");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Cancel");
  SBOk->Caption="Стоп";
  SBOk->Width=70;
  SBOk->Height=25;
  SBOk->Top=8;
  SBOk->Left= (Width-SBOk->Width)/2-3;
  SBOk->Parent=P;
  SBOk->OnClick= OnStopClick;

  StopEnabled=true;

  KeyPreview=true;
  OnKeyPress=FOnUserKeyPress;
}

__fastcall TWTWaitForm::~TWTWaitForm(){
//delete Timer;
  delete Image;
}

void __fastcall TWTWaitForm::SetStopEnabled(bool Value){
  SBOk->Enabled=Value;
  FStopEnabled=Value;
}


void __fastcall TWTWaitForm::FOnUserKeyPress(TObject* Sender,char &Key){
  if (Key==13) OnStopClick(NULL);
}


void _fastcall TWTWaitForm::OnStopClick(TObject *Sender){
  Stop=true;
}

void __fastcall TWTWaitForm::FOnTimer(TObject *Sender){
  if (TickCount==0) {
    Image->Top+=5;
    Image->Left+=5;
    TickCount++;
    return;
  }
  if (TickCount==1) {
    Image->Top+=5;
    Image->Left-=5;
    TickCount++;
    return;
  }
  if (TickCount==2) {
    Image->Top-=5;
    Image->Left-=5;
    TickCount++;
    return;
  }
  if (TickCount==3) {
    Image->Top-=5;
    Image->Left+=5;
    TickCount=0;
    return;
  }
  Application->ProcessMessages();
}

void __fastcall TWTDBGrid::SearchTable(AnsiString Value, int Num) {
  TBookmark SavePlace;
  if(Table)
    SavePlace = Table->GetBookmark();
  else
    SavePlace = Query->GetBookmark();

  Visible= false;
  Screen->Cursor= crHourGlass   ;
  TStringList *SQL= new TStringList();
  AnsiString S;
  TWTField *CurrField;
  AnsiString A;
  Variant ATabl;
  if (Table) CurrField=Table->GetTField((Fields[SelectedIndex]->FieldName));
    else CurrField=Query->GetTField((Fields[SelectedIndex]->FieldName));
  if ( CurrField->IsFixedVariables)
  {   A=Value;
      if(A.IsEmpty()) A=" ";
      int y=0;
      if ( (CurrField->Field->DataType==ftInteger) || (CurrField->Field->DataType==ftFloat))
      ATabl=0;
      if ((CurrField->Field->DataType==ftBoolean))
      ATabl="False";
      if ((CurrField->Field->DataType==ftString)||(CurrField->Field->DataType==ftUnknown)||
       (CurrField->Field->DataType==ftWideString))
      ATabl=" ";
      int len=A.Length();
      //SubString
      while (y<CurrField->FixedVariables->Count) {
        AnsiString EnterString=CurrField->FixedVariables->GetVariable(y)->RealValue.SubString(1,len);
          EnterString=EnterString.UpperCase();
         if (EnterString==A.UpperCase()) {
          ATabl=CurrField->FixedVariables->GetVariable(y)->DBValue;
        break;
       };
       y++;
      };
     if (Table){
      S="select * from ";
      S+= Table->TableName+ " where ";
      S+= Fields[SelectedIndex]->FieldName+" = "+ATabl;
     };
  }
  else
  {
     TZDataset* LT;
     bool Flag=true;
     AnsiString FilterField=Fields[SelectedIndex]->FieldName;
     if (CurrField->Field->FieldKind==fkLookup ) {
       LT=(TZDataset *)CurrField->Field->LookupDataSet;
       TLocateOptions Opts;
       Opts.Clear();
       Opts=Opts << loPartialKey;
       Opts=Opts << loCaseInsensitive;
       //Variant Val=Variant(SGDest->Cells[0][SGDest->Row]);
       Flag=LT->Locate(CurrField->Field->LookupResultField,Value,Opts);
       FilterField=CurrField->Field->KeyFields;
       A=LT->FieldByName(CurrField->Field->LookupKeyFields)->AsString;
       if (Table) {
         S="select * from ";
         S+= Table->TableName+ " where ";
         S+= FilterField+ " =" +A ;
       };
     }
     else
     { if (Table)
      {  S="select * from ";
         S+= Table->TableName+ " where w_upper(";
         S+= Fields[SelectedIndex]->FieldName+ ") like '";
         if (SearchFParams->Part)
          S+="%";
          if (SearchFParams->Case)
              S+=Value+ "%'";
          else
           S+=Value.UpperCase()+ "%'";

         if (!(Table->Filter.IsEmpty()))
               S+=" and "+Table->Filter;
         {
          int posnull;

          while ((posnull=S.Pos("=NULL"))!=0  )
          {
           AnsiString S1=S.SubString(1,posnull-1)+" is NULL "+S.SubString(posnull+5,S.Length());
           S=S1;
          };
           while ((posnull=S.Pos("=null"))!=0 )
          {
           AnsiString S1=S.SubString(1,posnull-1)+" is NULL "+S.SubString(posnull+5,S.Length());
           S=S1;
          };
         };
      }
      else {
       TWTQuery *QuerTabl=Query;
       //S="select * from ";
       //S+= Table->TableName+ " where w_upper(";
       // Fields->Fields[SelectedIndex]->Value
      // S+= Fields[SelectedIndex]->FieldName+ ") like '" +Value.UpperCase()+ "%'";

      };
     };
  }

  SQL->Add(S);
  QSearch= new TWTQuery(this, SQL);
  QSearch->Open();

  // нет записей
  if (!QSearch->RecordCount) {
    Table->GotoBookmark(SavePlace);
    Visible= true;
    if (Num!=0)
     Application->MessageBox("Запись не найдена", "Сообщение", MB_OK);
  }
  else {
    QSearch->First();
    TLocateOptions SearchOptions;
    SearchOptions = SearchOptions << loPartialKey;
    Table->Locate(Table->Fields->Fields[SelIndex]->FieldName, QSearch->Fields->Fields[SelIndex]->AsString, SearchOptions);
  }

  if (!QSearch->Eof) QSearch->Next();
  Table->FreeBookmark(SavePlace);
  Visible= true;
  SetFocus();
  Screen->Cursor= crArrow;
  delete SQL;
  delete QSearch;
}


void __fastcall TWTDBGrid::SearchQuery(AnsiString Value, int Num) {
  TBookmark SavePlace;
  TDataSet* DataSet;
  if(Table)
  {     SavePlace = Table->GetBookmark();
        DataSet=Table;
  }
  else
  {   SavePlace = Query->GetBookmark();
      DataSet=Query;
  }
   Variant TableValue;
   Variant FindValue;


  Visible= false;
  Screen->Cursor= crHourGlass   ;
  TStringList *SQL= new TStringList();
  AnsiString S;
  TWTField *CurrField;
  AnsiString A;
  Variant ATabl;

  if (Table) CurrField=Table->GetTField((Fields[SelectedIndex]->FieldName));
    else CurrField=Query->GetTField((Fields[SelectedIndex]->FieldName));
  if ( CurrField->IsFixedVariables)
  {   A=Value;
      if(A.IsEmpty()) A=" ";
      int y=0;
      if ( (CurrField->Field->DataType==ftInteger) || (CurrField->Field->DataType==ftFloat))
      ATabl=0;
      if ((CurrField->Field->DataType==ftBoolean))
      ATabl="False";
      if ((CurrField->Field->DataType==ftString)||(CurrField->Field->DataType==ftUnknown)||
       (CurrField->Field->DataType==ftWideString))
      ATabl=" ";
      int len=A.Length();
      //SubString
      while (y<CurrField->FixedVariables->Count) {
        AnsiString EnterString=CurrField->FixedVariables->GetVariable(y)->RealValue.SubString(1,len);
          EnterString=EnterString.UpperCase();
         if (EnterString==A.UpperCase()) {
          ATabl=CurrField->FixedVariables->GetVariable(y)->DBValue;
        break;
       };
       y++;
      };
    if (Table){
      S="select * from ";
      S+= Table->TableName+ " where ";
      S+= Fields[SelectedIndex]->FieldName+" = "+ATabl;
     };
  }
  else
  {
     TZDataset* LT;
     bool Flag=true;
     AnsiString FilterField=Fields[SelectedIndex]->FieldName;
     if (CurrField->Field->FieldKind==fkLookup ) {
       LT=(TZDataset *)CurrField->Field->LookupDataSet;
       TLocateOptions Opts;
       Opts.Clear();
       Opts=Opts << loPartialKey;
       Opts=Opts << loCaseInsensitive;
       //Variant Val=Variant(SGDest->Cells[0][SGDest->Row]);
       Flag=LT->Locate(CurrField->Field->LookupResultField,Value,Opts);
       FilterField=CurrField->Field->KeyFields;
       A=LT->FieldByName(CurrField->Field->LookupKeyFields)->AsString;
       if (Table) {
         S="select * from ";
         S+= Table->TableName+ " where ";
         S+= FilterField+ " =" +A ;
       };
     }
     else
     { if (Table)
      {  S="select * from ";
         S+= Table->TableName+ " where w_upper(";
         S+= Fields[SelectedIndex]->FieldName+ ") like '" +Value.UpperCase()+ "%'";
         if (!(Table->Filter.IsEmpty()))
            S+=" and "+Table->Filter;
      }
      else {
       TWTQuery *QuerTabl=Query;
       //S="select * from ";
       //S+= Table->TableName+ " where w_upper(";
       // Fields->Fields[SelectedIndex]->Value
      // S+= Fields[SelectedIndex]->FieldName+ ") like '" +Value.UpperCase()+ "%'";

      };
     };
  }

 if (Table)
 {
  SQL->Add(S);
  QSearch= new TWTQuery(this, SQL);
  QSearch->Open();
    // нет записей
  if (!QSearch->RecordCount) {
    Table->GotoBookmark(SavePlace);
    Visible= true;
    if (Num!=0)
     Application->MessageBox("Запись не найдена", "Сообщение", MB_OK);
  }
  else {
    QSearch->First();
    TLocateOptions SearchOptions;
    SearchOptions = SearchOptions << loPartialKey;
    Table->Locate(Table->Fields->Fields[SelIndex]->FieldName, QSearch->Fields->Fields[SelIndex]->AsString, SearchOptions);
  }

  if (!QSearch->Eof) QSearch->Next();
  Table->FreeBookmark(SavePlace);
 }
 else{
  bool Find=false;
  DataSet->First();
  TField *Field;                     //&& (!DataSet->Bof)
  while ((!DataSet->Eof) && (!Find) ) {
    Find=true;
    for (int x=0;x<SearchFParams->Fields->Count;x++) {
      Field=DataSet->FieldByName(SearchFParams->Fields->Strings[x]);
      try {
      switch (Field->DataType) {
        case ftSmallint :
        case ftInteger :
        case ftWord : {
          TableValue=StrToInt(Field->Text);
          FindValue=StrToInt(SearchFParams->Values->Strings[x]);
          break;
        }
        case ftFloat : {
          TableValue=float(StrToFloat(Field->Text));
          FindValue=float(StrToFloat(SearchFParams->Values->Strings[x]));
          break;
        }
        case ftCurrency : {
          TableValue=StrToCurr(Field->Text);
          FindValue=StrToCurr(SearchFParams->Values->Strings[x]);
          break;
        }
        case ftDate : {
          TableValue=StrToDate(Field->Text);
          FindValue=StrToDate(SearchFParams->Values->Strings[x]);
          break;
        }
        case ftTime : {
          TableValue=StrToTime(Field->Text);
          FindValue=StrToTime(SearchFParams->Values->Strings[x]);
          break;
        }
        default : {
          TableValue=Field->Text;
          FindValue=SearchFParams->Values->Strings[x];
          break;
        }
      };
      } catch (...) {
        TableValue=Field->Text;
        FindValue=SearchFParams->Values->Strings[x];
      }


      if (SearchFParams->Relations->Strings[x]=="=") {
        if (SearchFParams->Part && (Field->DataType==ftMemo || Field->DataType==ftFmtMemo || Field->DataType==ftWideString || Field->DataType==ftString)) {
          if (!SearchFParams->Case) {
            if (!AnsiUpperCase(TableValue).AnsiPos(AnsiString(FindValue).UpperCase())) {
              Find=false;
              break;
            }
          } else {
            if (!AnsiString(TableValue).AnsiPos(FindValue)) {
              Find=false;
              break;
            }
          }
        } else {
          if (Field->DataType==ftMemo || Field->DataType==ftFmtMemo || Field->DataType==ftWideString || Field->DataType==ftString) {
            if (!SearchFParams->Case) {
              if (AnsiString(TableValue).UpperCase()!=AnsiString(FindValue).UpperCase()) {
                Find=false;
                break;
              }
            } else {
              if (AnsiString(TableValue)!=AnsiString(FindValue)) {
                Find=false;
                break;
              }
            }
          } else {
            if (TableValue!=FindValue) {
              Find=false;
              break;
            }
          }
        }
      }
    }
    if (!Find) {
      if (SearchFParams->Down) DataSet->Next();
       else DataSet->Prior();
    }
    Application->ProcessMessages();
  }

  if (!Find) DataSet->GotoBookmark(SavePlace);

  //delete WF;
  Visible=true;
  SetFocus();
//  LockWindowUpdate(NULL);
  Application->MainForm->Enabled=true;
  if (!Find)
      if (Num!=0)
//     Application->MessageBox("Запись не найдена", "Сообщение", MB_OK);
        ShowMessage("Запись не найдена");
  else {
    Field=DataSet->FieldByName(SearchFParams->Fields->Strings[0]);
    int x=0;
    while (Field!=Fields[x]) x++;
    SelectedIndex=x;
  }



 };
  Visible= true;
  SetFocus();
  Screen->Cursor= crArrow;
  delete SQL;
  delete QSearch;

}

 /*
  TWTField *Field;
  AnsiString A=SGDest->Cells[0][SGDest->Row];
  if (DBGrid->Table) Field=DBGrid->Table->GetTField(DBGrid->Columns->Items[x]->FieldName);
  else Field=DBGrid->Query->GetTField(DBGrid->Columns->Items[x]->FieldName);
  if (Field->IsFixedVariables) {
    int y=0;
    while (y<Field->FixedVariables->Count) {
      if (Field->FixedVariables->GetVariable(y)->RealValue==A) {
        A=Field->FixedVariables->GetVariable(y)->DBValue;
        break;
      }
      y++;
    }
  }
  TZDataset* LT;
  bool Flag=true;
  AnsiString FilterField=DBGrid->Columns->Items[x]->FieldName;

  if (Field->Field->FieldKind==fkLookup && Filter) {
    LT=(TZDataset *)Field->Field->LookupDataSet;
    TLocateOptions Opts;
    Opts.Clear();
    Opts=Opts << loPartialKey;
    Variant Value=Variant(SGDest->Cells[0][SGDest->Row]);
    Flag=LT->Locate(Field->Field->LookupResultField,Value,Opts);
    FilterField=Field->Field->KeyFields;
    A=LT->FieldByName(Field->Field->LookupKeyFields)->AsString;
  }
  if (Flag) {
    if (Memo1->Lines->Capacity==0)
       Memo1->Lines->Add(FilterField + " " + Str + " '"+A+"'");
    else
       Memo1->Lines->Add(Cond+" "+FilterField + " " + Str + " '"+A+"'");
  } else {
    ShowMessage("Добавляемое значение отсутствует в справочной таблице");
  }

  SearchParams->AddLine(DBGrid->Columns->Items[x]->FieldName,Str,SGDest->Cells[0][SGDest->Row]);



void _fastcall TWTDBGrid::FastSearchMenu(TObject *Sender) {


  Application->MainForm->Enabled=false;

  TZDataset *DataSet;
  if (Table) DataSet=Table;
  else DataSet=Query;

  Visible=false;
  TField *Field;

  Variant TableValue;
  Variant FindValue;

  void* BM=DataSet->GetBookmark();


          */

