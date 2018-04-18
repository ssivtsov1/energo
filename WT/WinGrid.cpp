//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "WinGrid.h"

int F=0;
//---------------------------------------------------------------------
// функции класса TWTWinDBGrid
//---------------------------------------------------------------------
_fastcall TWTWinDBGrid::TWTWinDBGrid(TWinControl *owner, TStringList *SQL,bool IsMDI) : TWTMDIWindow(owner) {
  DBGrid = new TWTDBGrid(this, SQL);
  Initialize(IsMDI);

}
//---------------------------------------------------------------------
_fastcall TWTWinDBGrid::TWTWinDBGrid(TWinControl *owner, TWTQuery *query,bool IsMDI) : TWTMDIWindow(owner) {
  DBGrid = new TWTDBGrid(this, query);

  Initialize(IsMDI);

}

//---------------------------------------------------------------------
_fastcall TWTWinDBGrid::TWTWinDBGrid(TWinControl *owner, AnsiString Name,bool IsMDI) : TWTMDIWindow(owner) {
  DBGrid = new TWTDBGrid(this, Name);
  //delete DBGrid;
  //int i;
  //ShowMessage("IIIIII") ;
  Initialize(IsMDI);
   // ShowMessage("IIIIII") ;
 // delete DBGrid;
  //ShowMessage("IIIIII") ;
}

void __fastcall TWTWinDBGrid::Initialize(bool IsMDI){
  RegItem=NULL;
  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;

  TStatusPanel* SP=StatusBar->Panels->Add();
  SP->Width=350;

  SP=StatusBar->Panels->Add();
  SP->Width=100;

  SP=StatusBar->Panels->Add();

  List = new TListBox(this);
  List->Parent= this;
  List->Visible= false;

  //это вставляем чтобы исправить глюк объяснения которому мы не нашли!!!!!!!!
  Edit=new TEdit(this);
  Edit->Width=0;
  Edit->Height=0;
  Edit->Parent=this;

  DBGrid->ControlStyle << csOpaque;
  DBGrid->Left = 1;
  DBGrid->Top = 2;
  DBGrid->Width = Width - 10;
  DBGrid->Height = Height - 50;
  DBGrid->Align=alClient;
  DBGrid->TabOrder = 0;
  DBGrid->TitleFont->Charset = DEFAULT_CHARSET;
  DBGrid->TitleFont->Color = clWindowText;
  DBGrid->TitleFont->Height = -13;
  DBGrid->TitleFont->Name = "System";

  //добавляем все поля в таблицу
/*  if (DBGrid->Table) {
    DBGrid->Table->TTable::Open();
    int x;
//    TWTField* Field;
    for (x=0;x<DBGrid->Table->FieldDefs->Count;x++) {
      DBGrid->Table->AddField(DBGrid->Table->FieldDefs->Items[x]->Name);
    }
    DBGrid->Table->TTable::Close();
  }*/

  DBGrid->Enabled = true;
  DBGrid->Parent = this; // OSA


  // Функции обработки событии в TWTDBGrid
  DBGrid->AfterCancel = FAfterCancel;
  DBGrid->AfterClose = FAfterClose;
  DBGrid->AfterDelete = FAfterDelete;
  DBGrid->AfterEdit = FAfterEdit;
  DBGrid->AfterInsert = FAfterInsert;
  DBGrid->AfterOpen = FAfterOpen;
  DBGrid->AfterPost = FAfterPost;
  DBGrid->AfterScroll = FAfterScroll;
  DBGrid->BeforeCancel = FBeforeCancel;
  DBGrid->BeforeClose = FBeforeClose;
  DBGrid->BeforeDelete = FBeforeDelete;
  DBGrid->BeforeEdit = FBeforeEdit;
  DBGrid->BeforeInsert = FBeforeInsert;
  DBGrid->BeforeOpen = FBeforeOpen;
  DBGrid->BeforePost = FBeforePost;
  DBGrid->BeforeScroll = FBeforeScroll;

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

  DBGrid->OnColEnter= FOnColEnter;
  DBGrid->Timer->OnTimer= FOnTimer;
  //ToolBar=DBGrid->ToolBar;
  PopupMenu = DBGrid->PopupMenu; // Не работает закрытие объекта, если DBGrid->PopupMenu->Parent == DBGrid

  //DBGrid->ToolBar->Parent=this;
  // создаем панель кнопок

/*
 TToolButton *TB=AddButton("save", "Копировать данные в...", DBGrid->CopyDataToFile);
  AddButton("|", NULL, NULL);


  TB=AddButton("Print", "Отчеты", NULL);
  TPopupMenu *PM=new TPopupMenu(this);
  PM->OnPopup=DBGrid->FOnPopupReport;
  TB->DropdownMenu=PM;

  AddButton("FullScr", "Полноэкранный просмотр", DBGrid->WinEditMenu);
  AddButton("Cancel", "Отменить изменения", DBGrid->CancelUpdatesMenu);
  AddButton("Save", "Сохранить изменения", DBGrid->ApplyUpdatesMenu);
  AddButton("|", NULL, NULL);
  AddButton("FilterOff", "Снять фильтр", DBGrid->RemoveFilterMenu);

  TB=AddButton("Filter", "Установить фильтр", NULL);
  PM=new TPopupMenu(this);
  PM->OnPopup=DBGrid->FOnPopupFilter;
  TB->DropdownMenu=PM;

  TMenuItem *MI=new TMenuItem(PM);
  MI->Caption="Новый фильтр";
  MI->OnClick=DBGrid->SetFilterMenu;
  PM->Items->Add(MI);

  MI=new TMenuItem(PM);
  MI->Caption="-";
  PM->Items->Add(MI);

  AddButton("FindNext", "Продолжить", DBGrid->ReSearchMenu);
  AddButton("Find", "Поиск", DBGrid->SearchMenu);
  AddButton("|", NULL, NULL);
  AddButton("Delete", "Удалить запись", DBGrid->DelRecordMenu);
  AddButton("Insert", "Новая запись", DBGrid->NewRecordMenu);

   // */      //     osa tool

  if (IsMDI) {
    FormStyle = fsMDIChild;
    //FormState = fsModal;
    DBGrid->SetFocus();
  }

  CoolBar->AddToolBar(DBGrid->ToolBar);
  ActiveControl=DBGrid;
  DBGrid->Visible=false;
}


       /*
void __fastcall TWTWinDBGrid::FOnPopupReport(TObject *Sender){
  TPopupMenu *PM=(TPopupMenu*)Sender;

  TMenuItem *MI;

  while (PM->Items->Count!=0) PM->Items->Remove(PM->Items->Items[0]);

  if (((TWTMainForm*)Application->MainForm)->TableMenuItem->Items[4]->Checked) {
    MI=new TMenuItem(PM);
    MI->Caption="Новый отчет";
    MI->OnClick=DBGrid->PrintRep;
    PM->Items->Add(MI);

    MI=new TMenuItem(PM);
    MI->Caption="-";
    PM->Items->Add(MI);
  }

  TStrings* Names=new TStringList();
  DBGrid->GetGlobalReportsNames(Names);

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
  if (((TWTMainForm*)Application->MainForm)->IniFile!=((TWTMainForm*)Application->MainForm)->GlobalIniFile) DBGrid->GetReportsNames(Names);
  if (Names->Count && CC) {
    MI=new TMenuItem(PM);
    MI->Caption="-";
    PM->Items->Add(MI);
  }

  for (int x=0;x<Names->Count;x++) {
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


void __fastcall TWTWinDBGrid::FOnPopupFilter(TObject *Sender){
  TPopupMenu *PM=(TPopupMenu*)Sender;

  while (PM->Items->Count!=2) PM->Items->Remove(PM->Items->Items[2]);

  TMenuItem *MI;

  TStrings* Names=new TStringList();
  DBGrid->GetFiltersNames(Names);


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
} // */

void _fastcall TWTWinDBGrid::FOnReportClick(TObject *Sender){
//  ((TToolButton*)Sender)->PopupMenu->Popup(GetMouse);
}

//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FOnTimer(TObject *Sender) {
  if (!DBGrid->TimerOn) return;
 // return;
  /*
  TBookmark SavePlace;
  //SavePlace= new TBookmark();
  if (!Active)
    return;
  if (!DBGrid->TimerOn) return;
  if (F) return;
  if (DBGrid->Query) {
    F= 1;
    SavePlace = DBGrid->Query->GetBookmark();

    if (DBGrid->Query->State != dsInactive)
      for (int i = 0; i < DBGrid->Query->FieldCount; i++)
        ((TWTField*)DBGrid->Query->ListField->Items[i])->SaveProperty();

    DBGrid->Query->Active= false;
    DBGrid->Query->Active= true;

    if (DBGrid->Query->State != dsInactive)
      for (int i = 0; i < DBGrid->Query->FieldCount; i++)
       ((TWTField*)DBGrid->Query->ListField->Items[i])->SetProperty(DBGrid->Query->Fields->Fields[i]);


    DBGrid->Query->GotoBookmark(SavePlace);
    DBGrid->Query->FreeBookmark(SavePlace);
    F= 0;
  }
  else {
    F= 1;
    SavePlace = DBGrid->Table->GetBookmark();

    DBGrid->Table->Active= false;
    DBGrid->Table->Active= true;

    DBGrid->Table->GotoBookmark(SavePlace);
    DBGrid->Table->FreeBookmark(SavePlace);
    F= 0;
  }

  DBGrid->InitPopupMenu();
    */
}
//---------------------------------------------------------------------
_fastcall TWTWinDBGrid::~TWTWinDBGrid() {
  if (RegItem) {
    try {
      RegItem->Browses->Delete(RegItem->Browses->IndexOf(this));
    } catch (...) {
    }
  }
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::OnResize(TObject *Sender) {
  if (DBGrid != NULL) {
    DBGrid->Left = 1;
    DBGrid->Top = 2;
//    DBGrid->Width = Width - 10;
//    DBGrid->Height = Height - 50;
  }
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::InitButtons() {

 bool St=false;
  if (!DBGrid) return;
  if (DBGrid->Table) {
      if (DBGrid->Table->isModified() ||
         DBGrid->Table->isInserted()) St= true;
  }
  else
      if (DBGrid->Query->isModified() ||
         DBGrid->Query->isInserted()) St= true;

  if (DBGrid->ReadOnly) St= false;
  /*if (St) {
    if (DBGrid->WinEdit) {
      DBGrid->WinEdit->ToolBar->Buttons[0]->Enabled= false;
      DBGrid->WinEdit->ToolBar->Buttons[1]->Enabled= false;
      DBGrid->WinEdit->ToolBar->Buttons[3]->Enabled= false;
      DBGrid->WinEdit->ToolBar->Buttons[4]->Enabled= false;
      DBGrid->WinEdit->ToolBar->Buttons[5]->Enabled= false;
      DBGrid->WinEdit->ToolBar->Buttons[6]->Enabled= false;
      DBGrid->WinEdit->ToolBar->Buttons[8]->Enabled= true;
      DBGrid->WinEdit->ToolBar->Buttons[9]->Enabled= true;
    }

    ToolBar->Buttons[0]->Enabled= false;
    ToolBar->Buttons[1]->Enabled= false;
    ToolBar->Buttons[3]->Enabled= false;
    ToolBar->Buttons[4]->Enabled= false;
    ToolBar->Buttons[5]->Enabled= false;
    ToolBar->Buttons[6]->Enabled= false;
    ToolBar->Buttons[8]->Enabled= true;
    ToolBar->Buttons[9]->Enabled= true;
    ToolBar->Buttons[10]->Enabled= false;
    ToolBar->Buttons[11]->Enabled= false;
    ToolBar->Buttons[12]->Enabled= false;
    ToolBar->Buttons[13]->Enabled= false;
  }
  else {
     if (DBGrid->ReadOnly) {// || (TWTDBGrid::ReadOnly)) {
       if (DBGrid->WinEdit) {
         DBGrid->WinEdit->ToolBar->Buttons[0]->Enabled= false;
         DBGrid->WinEdit->ToolBar->Buttons[1]->Enabled= false;
       }
       ToolBar->Buttons[0]->Enabled= false;
       ToolBar->Buttons[1]->Enabled= false;
     }
     else {
       if (DBGrid->WinEdit) {
         DBGrid->WinEdit->ToolBar->Buttons[0]->Enabled= true;
         DBGrid->WinEdit->ToolBar->Buttons[1]->Enabled= true;
       }
       ToolBar->Buttons[0]->Enabled= true;
       ToolBar->Buttons[1]->Enabled= true;
     }
      if (DBGrid->WinEdit) {
        DBGrid->WinEdit->ToolBar->Buttons[3]->Enabled= true;
        DBGrid->WinEdit->ToolBar->Buttons[4]->Enabled= true;
        DBGrid->WinEdit->ToolBar->Buttons[5]->Enabled= true;
        DBGrid->WinEdit->ToolBar->Buttons[6]->Enabled= true;
        DBGrid->WinEdit->ToolBar->Buttons[8]->Enabled= false;
        DBGrid->WinEdit->ToolBar->Buttons[9]->Enabled= false;
      }

     ToolBar->Buttons[3]->Enabled= true;
     ToolBar->Buttons[4]->Enabled= true;
     ToolBar->Buttons[5]->Enabled= true;
     ToolBar->Buttons[6]->Enabled= true;
     ToolBar->Buttons[8]->Enabled= false;
     ToolBar->Buttons[9]->Enabled= false;
     ToolBar->Buttons[10]->Enabled= true;
     ToolBar->Buttons[11]->Enabled= true;
     ToolBar->Buttons[12]->Enabled= true;
     ToolBar->Buttons[13]->Enabled= true;
   }*/
}
//---------------------------------------------------------------------
// Функции обработки событии запроса
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterCancel(TWTDBGrid* Sender) {
  if (AfterCancel) AfterCancel(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterPost(TWTDBGrid* Sender) {
  if (AfterPost) AfterPost(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterClose(TWTDBGrid* Sender) {
  if (AfterClose) AfterClose(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterDelete(TWTDBGrid* Sender) {
  if (AfterDelete) AfterDelete(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterEdit(TWTDBGrid* Sender) {
  if (AfterEdit) AfterEdit(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterInsert(TWTDBGrid* Sender) {
  if (AfterInsert) AfterInsert(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterOpen(TWTDBGrid* Sender) {
  if (AfterOpen) AfterOpen(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FAfterScroll(TWTDBGrid* Sender) {
  if (AfterScroll) AfterScroll(this);
  InitButtons();
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeCancel(TWTDBGrid* Sender) {
  if (BeforeCancel) BeforeCancel(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforePost(TWTDBGrid* Sender) {
  if (BeforePost) BeforePost(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeClose(TWTDBGrid* Sender) {
  if (BeforeClose) BeforeClose(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeDelete(TWTDBGrid* Sender) {
  if (BeforeDelete) BeforeDelete(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeEdit(TWTDBGrid* Sender) {
  if (BeforeEdit) BeforeEdit(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeInsert(TWTDBGrid* Sender) {
  if (BeforeInsert) BeforeInsert(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeOpen(TWTDBGrid* Sender) {
  if (BeforeOpen) BeforeOpen(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FBeforeScroll(TWTDBGrid* Sender) {
  if (BeforeScroll) BeforeScroll(this);
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::FOnColEnter(TObject *Sender) {
  DBGrid->TimerOn= false;
  DBGrid->Timer->Enabled=false;
  if (List->Items->Count >0) {
/*    StatusBar->SimplePanel= true;
    StatusBar->SimpleText= List->Items->Strings[DBGrid->SelectedIndex];*/
    StatusBar->Panels->Items[0]->Text=List->Items->Strings[DBGrid->SelectedIndex];

  }
  TWTField *Field;
  if (DBGrid->Query)
     Field = DBGrid->Query->GetTField(DBGrid->Columns->Items[DBGrid->SelectedIndex]->FieldName);
  else
     Field = DBGrid->Table->GetTField(DBGrid->Columns->Items[DBGrid->SelectedIndex]->FieldName);

  if (Field->GetOnHelp())
    DBGrid->PopupMenu->Items->Items[17]->Enabled = true;
  else
    if (DBGrid->PopupMenu->Items->Items[17]->Caption != "Выбор")
      DBGrid->PopupMenu->Items->Items[17]->Enabled = false;

  if (Field->Field->DataType== ftSmallint || Field->Field->DataType== ftInteger ||
      Field->Field->DataType== ftWord || Field->Field->DataType== ftFloat) {
    DBGrid->PopupMenu->Items->Items[9]->Enabled = true;
    DBGrid->PopupMenu->Items->Items[10]->Enabled = true;
    DBGrid->PopupMenu->Items->Items[11]->Enabled = true;
  }
  if (DBGrid->ReadOnly) return;

  if (DBGrid->Query) {
    if (DBGrid->Query->State== dsBrowse) {
      DBGrid->TimerOn= true;
      DBGrid->Timer->Enabled=true;
    }}
  else
    if (DBGrid->Table->State== dsBrowse) {
      DBGrid->TimerOn= true;
      DBGrid->Timer->Enabled=true;
    }
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::OnClose(TObject *Sender) {
  // Если текущая запись изменена
  if (DBGrid->Query->isModified()) {
    TWTMessage *Mes = new TWTMessage(this);
    Mes->AddLabel("Текущая запись была модифицирована.");
    Mes->AddLabel("Сохранить изменения?");
    Mes->AddButton("   Да   ");
    Mes->AddButton("   Нет   ");
    if (!Mes->Show(" Внимание! "))
      DBGrid->Query->ApplyUpdates();
    else
      DBGrid->Query->CancelUpdates();
    DEL(Mes);
  }
}
//---------------------------------------------------------------------
void __fastcall TWTWinDBGrid::InitMenu() {
  UserMenuItem->Enabled = true;
//  if (DBGrid) DBGrid->InitPopupMenu();
}

//---------------------------------------------------------------------
TToolBar* __fastcall TWTWinDBGrid::FindToolBar(int Tag){
  for (int x=0;x<MainCoolBar->Bands->Count;x++)
    if (MainCoolBar->Bands->Items[x]->Control->Tag==Tag)
      return (TToolBar*)MainCoolBar->Bands->Items[x]->Control;
  return NULL;
}

TWTField* __fastcall TWTWinDBGrid::AddColumn(AnsiString Name,AnsiString Label,AnsiString FullLabel) {
   List->Items->Add(FullLabel);
   return DBGrid->AddColumn(Name,Label,FullLabel);

}
TWTField* __fastcall TWTWinDBGrid::AddColumn(AnsiString Name) {
  return DBGrid->AddColumn(Name);
}
TWTField* __fastcall TWTWinDBGrid::AddColumn(int Index) {
  return DBGrid->AddColumn(Index);
}
void __fastcall TWTWinDBGrid::AddColumn() {
  DBGrid->AddColumn();
}

void __fastcall TWTWinDBGrid::AlignWidth(){
  if (WindowState==wsMaximized) return;
  int XX=45;
  for (int x=0;x<DBGrid->Columns->Count;x++) XX+=DBGrid->Columns->Items[x]->Width;
  if (XX>Application->MainForm->Width-30) XX=Application->MainForm->Width-30;
  if (XX<300) XX=300;
  Width=XX;
}

//---------------------------------------------------------------------

