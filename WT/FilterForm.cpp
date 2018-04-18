//--------------------re-------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "FilterForm.h"

//---------------------------------------------------------------------
// функции класса TWTFilterForm
//---------------------------------------------------------------------
__fastcall TWTFilterForm::TWTFilterForm(TWinControl *Owner,AnsiString LoadName): TWTMDIWindow(Owner) {
  Filter=true;
  CurrentFilter=LoadName;
  Initialize();
}


__fastcall TWTFilterForm::TWTFilterForm(TWinControl *Owner): TWTMDIWindow(Owner) {
  Filter=false;
  CurrentFilter="";
  Initialize();
}


void __fastcall TWTFilterForm::Initialize(){

  SearchParams=new TWTSearchParams();

  Width = 430;

  Height = 402;
  BorderStyle=bsDialog;
  Position=poScreenCenter;
  if (CurrentFilter=="Default") Caption="Параметры фильтра";
  else Caption="Параметры фильтра <"+CurrentFilter+">";
  if (!Filter) Caption="Поиск";

  Panel1=new TPanel(this);
  Panel1->Top=40;
  Panel1->Left=0;
  Panel1->Width=Width-6;
  Panel1->Height=Height-25-40;
  Panel1->Anchors=Panel1->Anchors >> akLeft >> akTop >> akRight >> akBottom;
  Panel1->Caption="";
  Panel1->BevelInner=bvNone;
  Panel1->BevelOuter=bvLowered;
  Panel1->Parent=this;

  Panel2=new TPanel(this);
  Panel2->Top=250;
  Panel2->Align=alBottom;
  Panel2->Height=40;
  Panel2->Caption="";
  Panel2->Parent= Panel1;
  Panel2->BorderWidth=2;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Ok");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Ok");
  SBOk->Caption="OK";
  SBOk->Width=70;
  SBOk->Height=25;
  SBOk->Top=8;
  SBOk->Left= 175;
  SBOk->Parent=Panel2;
  SBOk->OnClick= ApplyFilter;

  Panel4=new TPanel(this);
  Panel4->Align=alClient;
  Panel4->Caption="";
  Panel4->Parent= Panel1;
  Panel4->BorderWidth=0;

  LBSource= new TListBox(this);
  LBSource->Align= alLeft;
  LBSource->Width= 180;
  LBSource->MultiSelect= false;
  LBSource->Parent= Panel4;
  LBSource->OnClick=FOnDblClick;
  LBSource->Font->Style= LBSource->Font->Style << fsBold;
//  LBSource->OnKeyPress= LBSourceKeyPress;
//  LBSource->OnMouseDown= LBSourceMouseDown;

  Panel3=new TPanel(this);
  Panel3->Align=alLeft;
  Panel3->Width=50;
  Panel3->BevelInner=bvNone;
  Panel3->BevelOuter=bvLowered;
  Panel3->Caption="";
  Panel3->Parent=Panel4;

  TPanel *Panel=new TPanel(this);
  Panel->Align=alClient;
  Panel->BevelInner=bvNone;
  Panel->BevelOuter=bvNone;
  Panel->Caption="";
  Panel->Parent=Panel4;

  TPanel *BPanel=new TPanel(this);
  BPanel->Align=alBottom;
  BPanel->Height=35;
  BPanel->BevelInner=bvNone;
  BPanel->BevelOuter=bvLowered;
  BPanel->Caption="";
  BPanel->Parent=Panel;

  SGDest=new TStringGrid(this);
  SGDest->Align = alClient;
  SGDest->ColCount = 1;
  SGDest->DefaultColWidth = 165;
  SGDest->DefaultRowHeight = 15;
  SGDest->FixedCols = 0;
  SGDest->FixedRows = 0;
  SGDest->TabOrder = 4;
  SGDest->RowCount = 1;
  SGDest->Parent= Panel;
  SGDest->OnDblClick=FOnDblClick;
  SGDest->Font->Style=SGDest->Font->Style << fsBold;
  SGDest->Options=SGDest->Options >> goRangeSelect << goEditing << goDrawFocusSelected;
  SGDest->Font->Color=clRed;

  Panel5=new TPanel(this);
  Panel5->Top=1;
  Panel5->Left=16;
  Panel5->Width=153;
  Panel5->BevelInner=bvNone;
  Panel5->BevelOuter=bvNone;
  Panel5->Height=33;
  Panel5->Caption="";
  Panel5->Parent=BPanel;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"AddCond");*/

  SBAdd=new TSpeedButton(this);
  SBAdd->Flat=true;
  SBAdd->Glyph->LoadFromResourceName(0,"AddCond");
  SBAdd->Width=24;
  SBAdd->Height=24;
  SBAdd->Top=5;
  SBAdd->Left=100;
  SBAdd->OnClick=AddLine;
  SBAdd->Parent=Panel5;

  //  SBAdd->OnClick= FAddOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"RemCond");*/

  SBRem=new TSpeedButton(this);
  SBRem->Flat=true;
  SBRem->Glyph->LoadFromResourceName(0,"RemCond");
  SBRem->Width=24;
  SBRem->Height=24;
  SBRem->Top=5;
  SBRem->Left=124;
  SBRem->OnClick=RemoveLine;
  SBRem->Parent=Panel5;

  TLabel* Label1=new TLabel(this);
  Label1->Left = 58;
  Label1->Top = 10;
  Label1->Width = 28;
  Label1->Height = 13;
  Label1->Caption = "ИЛИ";
  Label1->OnClick=FOnDblClick;
  Label1->Font->Style = Label1->Font->Style << fsBold;
  if (Filter) Label1->Parent=Panel5;

  TLabel* Label2=new TLabel(this);
  Label2->Left = 6;
  Label2->Top = 10;
  Label2->Width = 10;
  Label2->Height = 13;
  Label2->Caption = "И";
  Label2->OnClick=FOnDblClick;
  Label2->Font->Style = Label2->Font->Style << fsBold;
  if (Filter) Label2->Parent=Panel5;

  TrackBar1=new TTrackBar(this);
  TrackBar1->Left = 16;
  TrackBar1->Top = 8;
  TrackBar1->Width = 41;
  TrackBar1->Height = 21;
  TrackBar1->Max = 1;
  TrackBar1->Orientation = trHorizontal;
  TrackBar1->Frequency = 1;
  TrackBar1->Position = 0;
  TrackBar1->SelEnd = 0;
  TrackBar1->SelStart = 0;
  TrackBar1->TabOrder = 0;
  TrackBar1->ThumbLength = 15;
  TrackBar1->TickMarks = tmBottomRight;
  TrackBar1->TickStyle = tsManual;
  if (Filter) TrackBar1->Parent=Panel5;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Equal");*/

  SBEqual=new TSpeedButton(this);
  SBEqual->Flat=true;
  SBEqual->Glyph->LoadFromResourceName(0,"Equal");
  SBEqual->Width=24;
  SBEqual->Height=24;
  SBEqual->Top=10;
  SBEqual->Left=13;
  SBEqual->GroupIndex=1;
  SBEqual->Down=true;
  SBEqual->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"GreatEqual");*/

  SBGreatEqual=new TSpeedButton(this);
  SBGreatEqual->Flat=true;
  SBGreatEqual->Glyph->LoadFromResourceName(0,"GreatEqual");
  SBGreatEqual->Width=24;
  SBGreatEqual->Height=24;
  SBGreatEqual->Top=SBEqual->Top+24*1;
  SBGreatEqual->Left=13;
  SBGreatEqual->GroupIndex=1;
  SBGreatEqual->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"LessEqual");*/

  SBLessEqual=new TSpeedButton(this);
  SBLessEqual->Flat=true;
  SBLessEqual->Glyph->LoadFromResourceName(0,"LessEqual");
  SBLessEqual->Width=24;
  SBLessEqual->Height=24;
  SBLessEqual->Top=SBEqual->Top+24*2;
  SBLessEqual->Left=13;
  SBLessEqual->GroupIndex=1;
  SBLessEqual->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Great");*/

  SBGreat=new TSpeedButton(this);
  SBGreat->Flat=true;
  SBGreat->Glyph->LoadFromResourceName(0,"Great");
  SBGreat->Width=24;
  SBGreat->Height=24;
  SBGreat->Top=SBEqual->Top+24*3;
  SBGreat->Left=13;
  SBGreat->GroupIndex=1;
  SBGreat->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Less");*/

  SBLess=new TSpeedButton(this);
  SBLess->Flat=true;
  SBLess->Glyph->LoadFromResourceName(0,"Less");
  SBLess->Width=24;
  SBLess->Height=24;
  SBLess->Top=SBEqual->Top+24*4;
  SBLess->Left=13;
  SBLess->GroupIndex=1;
  SBLess->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"NotEqual");*/

  SBNotEqual=new TSpeedButton(this);
  SBNotEqual->Flat=true;
  SBNotEqual->Glyph->LoadFromResourceName(0,"NotEqual");
  SBNotEqual->Width=24;
  SBNotEqual->Height=24;
  SBNotEqual->Top=SBEqual->Top+24*5;
  SBNotEqual->Left=13;
  SBNotEqual->GroupIndex=1;
  SBNotEqual->Parent=Panel3;

 // if (!Filter) { // для фильтров
    TPanel *SPanel=new TPanel(this);
    SPanel->Top=200;
    SPanel->Height=70;
    SPanel->Align=alBottom;
    SPanel->Caption="";
    SPanel->Parent=Panel1;
  if (!Filter) {
    RGroup=new TRadioGroup(this);
    RGroup->Top=4;
    RGroup->Left=8;
    RGroup->Width=210-12;
    RGroup->Height=61;
    RGroup->Parent=SPanel;
    RGroup->Items->Add("Вверх");
    RGroup->Items->Add("Вниз");
    RGroup->Caption="Направление поиска";
    RGroup->ItemIndex=1;
  };
    TGroupBox *GB=new TGroupBox(this);
    GB->Top=4;
    GB->Left=210+4;
    GB->Width=210-12;
    GB->Height=61;
    GB->Parent=SPanel;
    GB->Caption="Строковые поля";

    CBox1=new TCheckBox(this);
    CBox1->Top=20;
    CBox1->Left=210+12;
    CBox1->Width=150;
    CBox1->Caption="Учитывать регистр";
    CBox1->Parent=SPanel;

    CBox2=new TCheckBox(this);

    CBox2->Top=40;
    CBox2->Left=210+12;

    CBox2->Width=150;
    CBox2->Checked=false;
    CBox2->Caption="Искать подстроку";
    CBox2->Parent=SPanel;
  //}

  Memo1= new TMemo(this);
  Memo1->Top=0;
  Memo1->Height = 70;
  Memo1->Align = alBottom;
  Memo1->TabOrder = 1;
  Memo1->Parent=Panel4;
  Memo1->ReadOnly=True;
  Memo1->Font->Height=-11;

  DBGrid=(TWTDBGrid*)Owner;

  for(int i=0; i<DBGrid->FieldCount; i++)
    LBSource->Items->Add(DBGrid->Columns->Items[i]->Title->Caption);

  AddButton("CancelFilter", "Очистить", ClearFilter);
  if (Filter) {
    AddButton("DeleteSh", "Удалить шаблон", DeleteFilter);
    AddButton("Filter", "Применить фильтр", SimpleApply);
    AddButton("SaveFilter", "Сохранить в шаблон", SaveFilter);
  } else {
    AddButton("Find", "Найти", DBGrid->ReSearchMenu);
  }

  if (LBSource->Items->Count) {
    LBSource->ItemIndex=DBGrid->SelectedIndex;
    FOnDblClick(LBSource);
    AnsiString SS;
    try {
      SS=DBGrid->Fields[DBGrid->SelectedIndex]->Text;
    } catch (...) {};
    bool Flag=false;
    for (int x=0;x<SGDest->RowCount;x++) {
      if (SGDest->Cells[0][x]==SS) {
        SGDest->Row=x;
        Flag=true;
        break;
      }
    }
    if (!Flag) SGDest->Cells[0][0]=SS;

//    LBSource->Selected[0]=true;
  }
//  if (LoadName!="Default") {
    if (Filter) LoadFilter(CurrentFilter);
//    Close();
//    ModalResult=1;
//    Close();
//    ModalResult=-1;
//  }
//  FormStyle=fsMDIChild;
}

__fastcall TWTFilterForm::~TWTFilterForm(){
  delete SearchParams;
}


void __fastcall TWTFilterForm::FindRecord(TObject *Sender){
  DBGrid->SearchParams->Assign(SearchParams);
  SearchParams->Down=RGroup->ItemIndex;
  SearchParams->Case=CBox1->Checked;
  SearchParams->Part=CBox2->Checked;
  DBGrid->ReSearchMenu(NULL);
}

//---------------------------------------------------------------------
void _fastcall TWTFilterForm::FOnKeyPress(TObject *Sender, char &Key) {
  // По Enter выходим
  if (Key == 27)
    ModalResult = -1;
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::AddLine(TObject *Sender) {
  int x=0;
  AnsiString Str,Cond;
  while (!LBSource->Selected[x]) x++;
   if (SBEqual->Down)
    if (Filter)
      if  (CBox2->Checked)  Str="like"; else   Str="=";
    else  Str="=";
  if (SBGreatEqual->Down) Str=">=";
  if (SBLessEqual->Down) Str="<=";
  if (SBGreat->Down) Str=">";
  if (SBLess->Down) Str="<";
  if (SBNotEqual->Down) Str="<>";
  if (TrackBar1->Position) Cond="or";
  else Cond="and";

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
   if  (CBox2->Checked)
    Opts=Opts << loPartialKey;

    Variant Value=Variant(SGDest->Cells[0][SGDest->Row]);
    Flag=LT->Locate(Field->Field->LookupResultField,Value,Opts);
    FilterField=Field->Field->KeyFields;
    A=LT->FieldByName(Field->Field->LookupKeyFields)->AsString;
  }
  if (Flag) {
   // if (SBEqual->Down)  Str="=";
    if (Memo1->Lines->Capacity==0)
       Memo1->Lines->Add(FilterField + " " + Str + " '"+A+"'");
    else
       Memo1->Lines->Add(Cond+" "+FilterField + " " + Str + " '"+A+"'");
  } else {
    ShowMessage("Добавляемое значение отсутствует в справочной таблице");
  }

  SearchParams->AddLine(DBGrid->Columns->Items[x]->FieldName,Str,SGDest->Cells[0][SGDest->Row]);
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::RemoveLine(TObject *Sender) {
  if (Memo1->Lines->Count) {
    Memo1->Lines->Delete(Memo1->Lines->Count-1);
    SearchParams->RemoveLine();
  }

}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::ApplyFilter(TObject *Sender) {
  if (Memo1->Lines->Capacity==0) AddLine(Sender);
  ModalResult= 1;
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::OnClose(TObject *Sender, TCloseAction &Action) {
  if (!ModalResult) {
    // Форму не закрываем - она модальная
    Action = caNone;
    ModalResult = -1;
    return;
  }
  TWTMDIWindow::OnClose(Sender, Action);
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::ClearFilter(TObject *Sender){
   Memo1->Clear();
   SearchParams->Clear();
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::SimpleApply(TObject *Sender){
   if (DBGrid->Table)
     DBGrid->Table->SetFilter(Memo1->Lines->Text);
   else
     DBGrid->Query->SetFilter(Memo1->Lines->Text);

}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::SaveFilter(TObject *Sender){
  TModalResult MR;
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbOK << mbIgnore << mbCancel;

  AnsiString ss=CurrentFilter;
  /*
  int y=0;
  int x;
  int z;
  */
  AnsiString FilterID=DBGrid->GetID();

  TStringList* SL=new TStringList();
  do {
    MR=mrCancel;
    if (!InputQuery("Сохранение фильтра","Введите имя фильтра",ss)) return;
    ((TWTMainForm*)Application->MainForm)->IniFile->ReadSection("FiltersID\\"+FilterID,SL);
    if (SL->IndexOf(ss)!=-1) {
      if (CurrentFilter!=ss)
         MR=MessageDlg("Фильтр с таким именем уже существует.", mtWarning,DB, 0);
      else
         MR=mrIgnore;
      if (MR==mrCancel) return;
    }
  } while (MR==mrOk);
  delete SL;

  CurrentFilter=ss;
  if (ss=="Default") Caption="Параметры фильтра";
  else Caption="Параметры фильтра <"+ss+">";

  /*
  TDBDataSet* DataSet;
  if (DBGrid->Table) DataSet=DBGrid->Table;
  else DataSet=DBGrid->Query;
  */

  int NumID;
  if (FilterID=="") {
    NumID=((TWTMainForm*)Application->MainForm)->GlobalIniFile->ReadInteger("Variables","NextTable",0);
    NumID++;
    ((TWTMainForm*)Application->MainForm)->GlobalIniFile->WriteInteger("Variables","NextTable",NumID);
    FilterID="Filter["+IntToStr(NumID)+"]";
    ((TWTMainForm*)Application->MainForm)->GlobalIniFile->WriteString("Tables",DBGrid->GetAlias(),FilterID);
  }

  ((TWTMainForm*)Application->MainForm)->IniFile->WriteString("FiltersID\\"+FilterID,ss,"");
  //UpdateIniFile(((TWTMainForm*)Application->MainForm)->IniFile);

  AnsiString sss=ss;
  ss="Фильтры\\"+FilterID+"\\"+ss;
  ((TWTMainForm*)Application->MainForm)->IniFile->EraseSection(ss);

  for (int x=0;x<Memo1->Lines->Count;x++) {
    ((TWTMainForm*)Application->MainForm)->IniFile->WriteString(ss,"Parameters.Lines["+IntToStr(x)+"]",Memo1->Lines->Strings[x]);
  }
  ((TWTMainForm*)Application->MainForm)->IniFile->WriteInteger(ss,"LinesCount",Memo1->Lines->Count);
  ((TWTMainForm*)Application->MainForm)->IniFile->UpdateFile();
  ((TWTMainForm*)Application->MainForm)->GlobalIniFile->UpdateFile();

/*  if (MR!=mrIgnore) {
    Graphics::TBitmap* BM=new Graphics::TBitmap();
    BM->LoadFromResourceName(0,"FilterM");

    TMenuItem* MI=CreateMenuItem(sss.c_str(),true,((TWTMainForm*)MainForm)->LoadFilter,"");
    MI->Bitmap=BM;
    FilterMenuItem->Insert(FilterMenuItem->Count-1,MI);
  }*/
}

void __fastcall TWTFilterForm::LoadFilter(AnsiString LoadName) {
  AnsiString FilterID=DBGrid->GetID();

  LoadName="Фильтры\\"+FilterID+"\\"+LoadName;
  int LinesCount=((TWTMainForm*)Application->MainForm)->IniFile->ReadInteger(LoadName,"LinesCount",0);
  if (LinesCount==0) return;
  for (int x=0;x<LinesCount;x++) {
    Memo1->Lines->Add(((TWTMainForm*)Application->MainForm)->IniFile->ReadString(LoadName,"Parameters.Lines["+IntToStr(x)+"]",""));
  }
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::DeleteFilter(TObject *Sender) {
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbOK;
  AnsiString FilterID=DBGrid->GetID();
  if (CurrentFilter=="Default") {
    MessageDlg("Не могу удалить несохраненный фильтр", mtConfirmation,DB, 0);
    return;
  }
  DB=DB << mbCancel;
  if (MessageDlg("Вы действительно хотите удалить текущий фильтр?", mtConfirmation,DB, 0)==mrOk) {
    ((TWTMainForm*)Application->MainForm)->IniFile->DeleteKey("FiltersID\\"+FilterID,CurrentFilter);
    ((TWTMainForm*)Application->MainForm)->IniFile->EraseSection("Фильтры\\"+FilterID+"\\"+CurrentFilter);
/*    for (int x=0;x<FilterMenuItem->Count;x++) {
      if (FilterMenuItem->Items[x]->Caption==CurrentFilter) FilterMenuItem->Delete(x);
    }*/
//    UpdateIniFile(((TWTMainForm*)Application->MainForm)->IniFile);
//    UpdateIniFile(((TWTMainForm*)Application->MainForm)->GlobalIniFile);
    ((TWTMainForm*)Application->MainForm)->IniFile->UpdateFile();
    ((TWTMainForm*)Application->MainForm)->GlobalIniFile->UpdateFile();
    ModalResult=2;
  }
}

//---------------------------------------------------------------------
void __fastcall TWTFilterForm::FOnDblClick(TObject *Sender) {
 try {
  if (Sender==LBSource) {
    TStrings *SS=DBGrid->Columns->Items[LBSource->ItemIndex]->PickList;
    if (SS->Count>0) {
      SGDest->RowCount=SS->Count;
      for (int x=0;x<SS->Count;x++) SGDest->Cells[0][x]=SS->Strings[x];
    } else {
      SGDest->RowCount=1;
      SGDest->Cells[0][0]="";
    }
    return;
  }
  if (Sender==SGDest) {
    AddLine(NULL);
    return;
  }
  if (AnsiString(Sender->ClassName())=="TLabel") {
    TLabel *Label=(TLabel*)Sender;
    if (Label->Caption=="ИЛИ") TrackBar1->Position=1;
    else TrackBar1->Position=0;
  }
 } catch (...) {};
}
//---------------------------------------------------------------------------
#pragma package(smart_init)
