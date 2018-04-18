//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ParamsForm.h"

__fastcall TWTParamsForm::TWTParamsForm(TComponent* Owner,AnsiString Caption): TWTMDIWindow(Owner) {

  OnAccept=NULL;
  TForm::Caption=Caption;
  TForm::OnShow=FOnShow;
  OnKeyPress=FOnUserKeyPress;
  KeyPreview=true;

  BorderStyle=bsDialog;
  Position=poScreenCenter;
  TForm::OnClose=FOnUserClose;

  Panel=new TWTPanel(this);
  Panel->Align=alClient;
  Panel->Caption="";
  Panel->BevelInner=bvNone;
  Panel->BevelOuter=bvLowered;
  Panel->Parent=this;

  Params=Panel->Params;

/*  Params=new TWTParamsList();
  Params->FParentPanel=Panel;*/

  TPanel* Panel1=new TPanel(this);
  Panel1->Height=40;
  Panel1->Align=alBottom;
  Panel1->Caption="";
  Panel1->Parent=Panel;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Ok");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Ok");
  SBOk->Caption="OK";
  SBOk->Width=70;
  SBOk->Height=25;
  SBOk->Top=8;
  SBOk->Left= (Width-SBOk->Width)/2;
  SBOk->Parent=Panel1;
  SBOk->OnClick= FOnClick;
}

void __fastcall TWTParamsForm::FOnShow(TObject *Sender){
//  Panel->ApplyParams();
  Width=Panel->RealWidth+12;
  Height=Panel->RealHeight+67;
  SBOk->Left=(Width-SBOk->Width)/2;
}

void __fastcall TWTParamsForm::FOnUserKeyPress(TObject* Sender, char &Key){
  if (Key==13) FOnClick(SBOk);
}

void __fastcall TWTParamsForm::FOnUserClose(TObject *Sender, TCloseAction &Action){
  Action=caFree;
}

__fastcall TWTParamsForm::~TWTParamsForm(){
//  delete Params;
}

void __fastcall TWTParamsForm::FOnClick(TObject *Sender){
  TWTParamItem* PI;
  for (int x=0;x<Params->Count;x++) {
    PI=Params->Get(x);
    if (PI->Kind==1) {
      try {
        StrToDate(((TMaskEdit*)PI->FControl)->Text);
      }
      catch (...) {
        throw Exception("Некорректная дата ("+((TMaskEdit*)PI->FControl)->Text+")");
      }
    }
    if (PI->Kind==4) {
      try {
        StrToTime(((TMaskEdit*)PI->FControl)->Text);
      }
      catch (...) {
        throw Exception("Некорректное время ("+((TMaskEdit*)PI->FControl)->Text+")");
      }
    }
    if (PI->Required) {
      TLocateOptions Options;
      if (!PI->DataSet->Locate(PI->SourceField,((TMaskEdit*)PI->FControl)->Text,Options))
        throw Exception(PI->Label->Caption+" ("+((TMaskEdit*)PI->FControl)->Text+") отсутствует в таблице");
    }
  }
  Hide();
  bool CloseFlag=true;
  if (OnAccept) OnAccept(this,CloseFlag);
  if (CloseFlag) ModalResult=mrYes;
  else Show();
}

#include <math.h>

//реализация класса TWTParamsList

__fastcall TWTParamsList::TWTParamsList(TWTPanel *Panel): TList(){
  FParentPanel=Panel;
  LabelFont=new TFont();
  DataFont=new TFont();
  LabelAlign=1;
  Dist=25;
  AutoBreak=false;
  LabelLen=0;
  CurY=5;
  MaxX=0;

  ButtonPic="Help";
}

__fastcall TWTParamsList::~TWTParamsList(){
  for (int x=0;x<Count;x++) delete Get(x);
}

TWTParamItem* TWTParamsList::AddDb(AnsiString Label,TDataSet* DataSet,AnsiString FieldName,int EditLen,bool Break){
  TWTParamItem* Prop=new TWTParamItem(NULL);
  if (Count) Prop->Break=Break;
  else Break=true;
  Prop->Label=new TLabel(Prop);
  Prop->Label->Font=DataFont;
  Prop->Label->Caption=Label;
  Prop->Label->AutoSize=false;
  TDBEdit *DbEdit=new TDBEdit(Prop);
  DbEdit->Font=DataFont;
  TDataSource* DS=new TDataSource(Prop);
  DS->DataSet=DataSet;
  DbEdit->DataSource=DS;
  DbEdit->DataField=FieldName;
  DbEdit->Width=EditLen;
  DbEdit->OnChange=Prop->OnDbEditChange;
  Prop->FControl=DbEdit;
  Prop->Kind=pkDb;
  InsertToPanel(Prop);
//  Add(Prop);
  Prop->FParamsList=this;
  return Prop;
}

TWTParamItem* TWTParamsList::AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break){
  TWTParamItem* Prop=new TWTParamItem(NULL);
  if (Count) Prop->Break=Break;
  else Break=true;
  Prop->Label=new TLabel(Prop);
  Prop->Label->Font=DataFont;
  Prop->Label->Caption=Label;
  Prop->Label->AutoSize=false;
  TMaskEdit* Edit=new TMaskEdit(Prop);
  Edit->Font=DataFont;
  Edit->Width=EditLen;
  Edit->Text=Text;
  Prop->FControl=Edit;
  Prop->FParamsList=this;
  return Prop;
}

TWTParamItem* TWTParamsList::AddSimple(AnsiString Label,int EditLen,AnsiString Text,bool Break){
  TWTParamItem* Prop=AddEditParam(Label,EditLen,Text,Break);
  Prop->Kind=pkSimple;
  InsertToPanel(Prop);
  return Prop;
}

TWTParamItem* TWTParamsList::AddMask(AnsiString Label,int EditLen,AnsiString Mask,bool Break){
  TWTParamItem* PI=AddEditParam(Label,EditLen,"",Break);
  ((TMaskEdit*)PI->FControl)->EditMask=Mask;
  PI->Kind=pkMask;
  InsertToPanel(PI);
  return PI;
}

TWTParamItem* TWTParamsList::AddDate(AnsiString Label,int EditLen,bool Break){
  TWTParamItem* PI=AddEditParam(Label,EditLen,"",Break);
  ((TMaskEdit*)PI->FControl)->EditMask="99.99.99";
  ((TMaskEdit*)PI->FControl)->Text=Date();
  PI->Kind=pkDate;
  InsertToPanel(PI);
  return PI;
}

TWTParamItem* TWTParamsList::AddText(AnsiString Text,int PanelLen,TFont *TextFont, TAlignment TextAlign, bool Break){
  TWTParamItem* Prop=new TWTParamItem(NULL);
  if (!Prop->Panel) Prop->Panel=new TPanel(Prop);
  if (TextFont) Prop->Panel->Font->Assign(TextFont);
  Prop->Panel->Caption=Text;
  Prop->Panel->Alignment=TextAlign;
  Prop->Kind=pkText;
  Prop->Panel->Width=PanelLen;
  InsertToPanel(Prop);
  return Prop;
}

TWTParamItem* TWTParamsList::AddTime(AnsiString Label,int EditLen,bool Break){
  TWTParamItem* PI=AddEditParam(Label,EditLen,"",Break);
  ((TMaskEdit*)PI->FControl)->EditMask="99:99";
  ((TMaskEdit*)PI->FControl)->Text=Time();
  PI->Kind=pkDate;
  InsertToPanel(PI);
  return PI;
}

TWTParamItem* TWTParamsList::AddGrid(TWTDBGrid* DBGrid, bool Break){
  TWTParamItem* Prop=new TWTParamItem(NULL);
  if (!Prop->Panel) Prop->Panel=new TPanel(Prop);
  DBGrid->Parent=Prop->Panel;
  DBGrid->Align=alClient;
  Prop->FControl=DBGrid;
  Prop->Kind=pkGrid;
  InsertToPanel(Prop);
  return Prop;
}

void __fastcall TWTParamsList::InsertToPanel(TWTParamItem *Param){
  TCustomEdit* CurEdit;
  TWTParamItem* P;
  int Sub=0;

  TPanel* BP;
  if (Param->Break) {
    if (Count) {
      BP=Get(Count-1)->BottomPanel;
      BP->Align=alTop;
    }
    if (!Param->BottomPanel) {
      Param->BottomPanel=new TPanel(FParentPanel);
    }
    Param->BottomPanel->Caption="";
    Param->BottomPanel->BevelInner=bvNone;
    Param->BottomPanel->BevelOuter=bvNone;
    Param->BottomPanel->Top=10000;
    Param->BottomPanel->Align=alClient;
    Param->BottomPanel->Height=Dist;
    Param->BottomPanel->Parent=FParentPanel;
  } else {
    Param->BottomPanel=Get(Count-1)->BottomPanel;
  }

  //создаем панель и устанавливаем ее параметры
  if (!Param->Panel) Param->Panel=new TPanel(Param);
  Param->Panel->BevelInner=bvNone;
  Param->Panel->BevelOuter=bvNone;
  Param->Panel->Parent=Param->BottomPanel;
//  Param->Panel->Height=Dist-5;
  Param->Panel->Align=alClient;
//  if (Param->Edit) CurEdit=Param->Edit;
//  if (Param->DbEdit) CurEdit=Param->DbEdit;
  if (Param->Break) {
//    Param->Panel->Left=5;
//    Param->Panel->Top=CurY;
    CurY=CurY+Dist;
    CurX=0;
  }
  else {
    BP=Get(Count-1)->Panel;
    BP->Align=alLeft;
//    Param->Panel->Left=CurX+10;
//    Param->Panel->Top=CurY-Dist;
  }

  //если лабел втавляемой панели оказался больше чем какой-либо из предыдущих
  //  корректируем параметры всех предыдущих параметров
  if (Param->Kind==pkSimple || Param->Kind==pkDate || Param->Kind==pkTime || Param->Kind==pkMask || Param->Kind==pkDb) {
    if (Param->Label->Width>LabelLen && Param->Break) {
      Sub=Param->Label->Width-LabelLen;
      LabelLen=Param->Label->Width;
      for (int x=0;x<Count;x++) {
        P=Get(x);
        if (!(P->Kind==pkSimple || P->Kind==pkDate || P->Kind==pkTime || P->Kind==pkMask || P->Kind==pkDb)) continue;
//        if (P->Edit) CurEdit=P->Edit;
//        if (P->DbEdit) CurEdit=P->DbEdit;
        if (P->Break) {
          P->FControl->Left+=Sub;
          if (P->Button) P->Button->Left+=Sub;
          if (LabelAlign) Param->Label->Left+=Sub;
        }
        P->Panel->Width+=Sub;
        if (P->Panel->Left+P->Panel->Width>MaxX) MaxX=P->Panel->Left+P->Panel->Width;
      }
    }

    //вставляем лабелы и эдиты
//    if (Param->Edit) CurEdit=Param->Edit;
//    if (Param->DbEdit) CurEdit=Param->DbEdit;
    if (Param->Break) {
      Param->Label->Width=LabelLen;
    }
    Param->FControl->Left=Param->Label->Width+10;

    Param->Panel->Width=Param->Label->Width+Param->FControl->Width+15;
    CurX=5+CurX+Param->Panel->Width;
    Param->Label->Top=8;
    Param->Label->Left=5;
    Param->Label->Parent=Param->Panel;
    if (LabelAlign) Param->Label->Alignment=taRightJustify;
    else Param->Label->Alignment=taLeftJustify;
//    if (Param->Edit) CurEdit=Param->Edit;
//    if (Param->DbEdit) CurEdit=Param->DbEdit;
    Param->FControl->Parent=Param->Panel;
    Param->FControl->Top=3;
  }

    //устанавливаем новую максимальную ширину если необходимо
  if ((Param->Panel->Left+Param->Panel->Width)>(MaxX)) MaxX=Param->Panel->Left+Param->Panel->Width;

  if (CurY>FParentPanel->RealHeight) FParentPanel->RealHeight=CurY;
  if (MaxX>FParentPanel->RealWidth) FParentPanel->RealWidth=MaxX;

  Add(Param);
}

//реализация класса TWTParamItem

__fastcall TWTParamItem::TWTParamItem(TComponent* Owner): TComponent(Owner){
  BottomPanel=NULL;
  DataSet=NULL;
  SourceField="";
  Required=false;
  Label=NULL;
//  DbEdit=NULL;
//  Edit=NULL;
  FControl=NULL;
  Button=NULL;
  Break=true;
  Kind=pkUnknown;
}

__fastcall TWTParamItem::~TWTParamItem(){
}

void TWTParamItem::SetReadOnly(bool Value){
/*  if (DbEdit) {
    DbEdit->ReadOnly=Value;
    DbEdit->Color=clBtnFace;
  }
  if (Edit) {
    Edit->ReadOnly=Value;
    Edit->Color=clBtnFace;
  }*/
  if (Kind==pkSimple || Kind==pkDate || Kind==pkTime || Kind==pkMask || Kind==pkDb) {
    ((TMaskEdit*)FControl)->ReadOnly=Value;
    ((TMaskEdit*)FControl)->Color=clBtnFace;
  }
  if (Kind==pkDb) {
    ((TDBEdit*)FControl)->ReadOnly=Value;
    ((TDBEdit*)FControl)->Color=clBtnFace;
  }
}

TSpeedButton *TWTParamItem::SetButton(TParamEvent OnClick){
  Button=new TSpeedButton(this);
  Button->OnClick=OnButtonClick;
  Button->Flat=true;
  Event=OnClick;

  Button->Glyph->LoadFromResourceName(0,ParamsList->ButtonPic);
  Button->Left=Panel->Width-5;
  Button->Top=3;
  Button->Parent=Panel;
  Panel->Width+=Button->Width;

  int CurP=ParamsList->IndexOf(this);
  CurP++;
  TWTParamItem* P=ParamsList->Get(CurP-1);
/*  while (CurP!=ParamsList->Count) {
    if (ParamsList->Get(CurP)->Break) break;
    P=ParamsList->Get(CurP);
    P->Panel->Left+=Button->Width;
    CurP++;
  }
  if (CurP==ParamsList->Count) {
    ParamsList->CurX+=Button->Width;
  }*/

  if (P->Panel->Left+P->Panel->Width>ParamsList->MaxX) ParamsList->MaxX=P->Panel->Left+P->Panel->Width;

  return Button;
}

void __fastcall TWTParamItem::OnButtonClick(TObject* Sender){
//  ParamsList->ParentForm->Enabled=false;
  if (Event) Value=Event(this);
//  ParamsList->ParentForm->Enabled=true;
}

void TWTParamItem::SetValue(AnsiString Text){
/*  if (Edit) Edit->Text=Text;
  if (DbEdit) DbEdit->Text=Text;*/
  if (Kind==pkSimple || Kind==pkDate || Kind==pkTime || Kind==pkMask) {
    ((TMaskEdit*)FControl)->Text=Text;
  }
  if (Kind==pkDb) {
    ((TDBEdit*)FControl)->Text=Text;
  }
  if (Kind==pkText) Panel->Caption=Text;
}

AnsiString TWTParamItem::GetValue(){
/*  if (Edit) return Edit->Text;
  if (DbEdit) return DbEdit->Text;*/
  if (Kind==pkSimple || Kind==pkDate || Kind==pkTime || Kind==pkMask) {
    return ((TMaskEdit*)FControl)->Text;
  }
  if (Kind==pkDb) {
    return ((TDBEdit*)FControl)->Text;
  }
  if (Kind==pkText) return Panel->Caption;
  return "";
}

AnsiString __fastcall TWTParamItem::GetID(){
/*  if (Edit) return Edit->Name;
  if (DbEdit) return DbEdit->Name;*/
  return Panel->Name;
}


void __fastcall TWTParamItem::OnDbEditChange(TObject* Sender){
}

void __fastcall TWTParamItem::OnEditChange(TObject* Sender){
  TLocateOptions Options;
  try {
    DataSet->Locate(SourceField,((TMaskEdit*)FControl)->Text,Options);
  }
  catch (...) {
  }
}

void __fastcall TWTParamItem::SetID(AnsiString ID){
/*  if (Edit) {
    Edit->Name=ID;
    Edit->Text="";
  }
  if (DbEdit) {
    DbEdit->Name=ID;
  }*/
  Panel->Name=ID;
  if (Kind==pkSimple || Kind==pkDate || Kind==pkTime || Kind==pkMask || Kind==pkDb) {
    Panel->Caption="";
  }
}

void TWTParamItem::SetRequired(TDBDataSet* DataSet,AnsiString FieldName){
  if (Kind==pkSimple || Kind==pkDate || Kind==pkTime || Kind==pkMask) {
    TWTParamItem::DataSet=DataSet;
    SourceField=FieldName;
    Required=true;
    ((TMaskEdit*)FControl)->OnChange=OnEditChange;
    ((TMaskEdit*)FControl)->Text=DataSet->Fields->Fields[0]->AsString;
  }
}

void __fastcall TWTParamItem::OnEditKeyPress(TObject* Sender,char& Key){
  TLocateOptions Options;
  if (Key == 13) {
    try {
      DataSet->Locate(SourceField,((TMaskEdit*)FControl)->Text,Options);
    }
    catch (...) {
    }
  }
}

//---------------------------------------------------------------------------


void __fastcall TWTCheckingForm::FOnClick(TObject *Sender){
  Close();
  TStringList* SL=new TStringList();
  GetAllCaptions(SL);
  bool Ch[100];
  for (int x=0;x<ItemsList->Count;x++) Ch[x]=((TCheckBox*)ItemsList->Items[x])->Checked;
  if (OnAccept) OnAccept(this,SL,Ch);
  ModalResult=mrOk;
}

void __fastcall TWTCheckingForm::FOnShow(TObject *Sender){
  int XX=10,YY=10,MaxX=0;
  TCheckBox *CB;
  for (int x=0;x<ItemsList->Count;x++) {
    CB=(TCheckBox*)ItemsList->Items[x];
//    if (x==0) ActiveControl=CB;
    CB->Top=XX;
    CB->Left=YY;
    CB->Width=StringSize(CB->Caption,CB->Font)+30;
    if (CB->Width>MaxX) MaxX=CB->Width;
    CB->Parent=Panel;
    XX+=20;
  }
  if (ItemsList->Count>0) Index=0;
  Width=MaxX+20;
  Height=XX+23+50;
  if (Width<150) Width=150;
  SBOk->Left=(Width-SBOk->Width-6)/2;
}

bool __fastcall TWTCheckingForm::IsCheck(AnsiString Caption){
  int x=0;
  while (((TCheckBox*)ItemsList->Items[x])->Caption!=Caption && x<ItemsList->Count) x++;
  if (((TCheckBox*)ItemsList->Items[x])->Caption==Caption) return ((TCheckBox*)ItemsList->Items[x])->Checked;
  return false;
}

int __fastcall TWTCheckingForm::AddItem(AnsiString Caption,bool Checked){
  TCheckBox *CBox=new TCheckBox(this);
  CBox->Caption=Caption;
  CBox->Checked=Checked;
  ItemsList->Add(CBox);
  return 0;
}

void __fastcall TWTCheckingForm::CheckItem(AnsiString Caption){
  int x=0;
  while (((TCheckBox*)ItemsList->Items[x])->Caption!=Caption && x<ItemsList->Count) x++;
  if (((TCheckBox*)ItemsList->Items[x])->Caption==Caption) ((TCheckBox*)ItemsList->Items[x])->Checked=true;
}

void __fastcall TWTCheckingForm::UnCheckItem(AnsiString Caption){
  int x=0;
  while (((TCheckBox*)ItemsList->Items[x])->Caption!=Caption && x<ItemsList->Count) x++;
  if (((TCheckBox*)ItemsList->Items[x])->Caption==Caption) ((TCheckBox*)ItemsList->Items[x])->Checked=false;
}

void __fastcall TWTCheckingForm::CheckItem(int Index){
  int x=0;
  while (x!=Index && x<ItemsList->Count) x++;
  if (x==Index) ((TCheckBox*)ItemsList->Items[x])->Checked=false;
}

void __fastcall TWTCheckingForm::UnCheckItem(int Index){
  int x=0;
  while (x!=Index && x<ItemsList->Count) x++;
  if (x==Index) ((TCheckBox*)ItemsList->Items[x])->Checked=false;
}

void TWTCheckingForm::GetAllCaptions(TStringList *CaptionsList){
  if (!CaptionsList) return;
  CaptionsList->Clear();
  for (int x=0;x<ItemsList->Count;x++) CaptionsList->Add(((TCheckBox*)ItemsList->Items[x])->Caption);
}

__fastcall TWTCheckingForm::TWTCheckingForm(TComponent* Owner,AnsiString Caption) :TWTMDIWindow(Owner) {

  OnAccept=NULL;
  TForm::Caption=Caption;
  TForm::OnShow=FOnShow;

  BorderStyle=bsDialog;
  Position=poScreenCenter;

  Panel=new TPanel(this);
  Panel->Align=alClient;
  Panel->Caption="";
  Panel->BevelInner=bvNone;
  Panel->BevelOuter=bvLowered;
  Panel->Parent=this;

  TPanel* Panel1=new TPanel(this);
  Panel1->Height=40;
  Panel1->Align=alBottom;
  Panel1->Caption="";
  Panel1->Parent=Panel;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Ok");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Ok");
  SBOk->Caption="OK";
  SBOk->Width=70;
  SBOk->Height=25;
  SBOk->Top=8;
  SBOk->Left= (Width-SBOk->Width)/2;
  SBOk->Parent=Panel1;
  SBOk->OnClick= FOnClick;

  ItemsList=new TList();
  Index=-1;
  OnKeyPress=FOnKeyPress;
  KeyPreview=true;
  TForm::OnClose=FOnClose;
}

__fastcall TWTCheckingForm::~TWTCheckingForm(){
  delete ItemsList;
}

void __fastcall TWTCheckingForm::FOnKeyPress(TObject* Sender, char &Key){
  switch (Key) {
    case 13: {
      FOnClick(NULL);
      break;
    }
    case 27: {
      Close();
      break;
    }
/*    case 32: {
      int x=ItemsList->IndexOf(ActiveControl);
      if (x!=-1) ((TCheckBox*)ItemsList->Items[x])->Checked=!((TCheckBox*)ItemsList->Items[x])->Checked;
      break;
    }*/
  };
}

void __fastcall TWTCheckingForm::FOnClose(System::TObject* Sender, TCloseAction &Action){
  Action=caFree;
}


//=============================================================================
//============= TWTDocuments ==================================================
//=============================================================================
//=============================================================================

__fastcall TWTDoc::TWTDoc(Classes::TComponent* AOwner,AnsiString FName) :TWTMDIWindow(AOwner) {
  DocFile=FName;
  Width=400;
  Height=400;


  PageControl=new TPageControl(this);
  PageControl->Align=alClient;
  PageControl->OnChange=ShowGridToolBar;
  PageControl->Parent=this;

  MainTabSheet=new TTabSheet(this);
  MainTabSheet->PageControl=PageControl;
  MainTabSheet->PageIndex=0;
  MainTabSheet->Parent=PageControl;
  MainTabSheet->Caption="Редактирование";

  GridTabSheet=new TTabSheet(this);
  GridTabSheet->PageControl=PageControl;
  GridTabSheet->PageIndex=1;
  GridTabSheet->Parent=PageControl;
  GridTabSheet->Caption="Печатная форма";

  TImageList* IL=new TImageList(this);
  IL->Height=16;
  IL->Width=16;

  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"BorderAll");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderOuter");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderInner");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderTop");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderLeft");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderRight");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderBottom");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BorderNone");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"Filling");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"Image");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"JoinCells");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"CancelJoin");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"LeftAlign");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"HCenterAlign");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"RightAlign");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"TopAlign");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"VCenterAlign");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"BottomAlign");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"FontProps");
  IL->Add(BM,NULL);
  BM->LoadFromResourceName(0,"ConstrMode");
  IL->Add(BM,NULL);

  DrawColorPanel();

  TCoolBar* CB=new TCoolBar(this);
  CB->AutoSize=true;
  CB->Align=alBottom;
  CB->Parent=GridTabSheet;

  TToolBar* TBar= new TToolBar(this);
  TBar->AutoSize=true;
  TBar->EdgeBorders=TBar->EdgeBorders >> ebLeft >> ebTop >> ebRight >> ebBottom;
  TBar->BorderWidth=1;
  TBar->Flat=true;
  TBar->Align=alClient;
  TBar->Width=10000;
  TBar->Parent=CB;
  TBar->Images=IL;

  CBox=new TComboBox(this);
  CBox->Width=35;
  CBox->Ctl3D=false;
  CBox->Parent=TBar;
  CBox->Items->Clear();
  CBox->Items->Add("0");
  CBox->Items->Add("1");
  CBox->Items->Add("2");
  CBox->Items->Add("3");
  CBox->Items->Add("4");
  CBox->Items->Add("5");
  CBox->ItemIndex=1;

  TToolButton* TB=new TToolButton(this);
  TB->ImageIndex=0;
  TB->Hint="Все границы";
  TB->ShowHint=true;
  TB->Left=10000;
  TB->OnClick=BorderAll;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=1;
  TB->Hint="Внешние границы";
  TB->ShowHint=true;
  TB->OnClick=BorderOuter;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=2;
  TB->Hint="Внутренние границы";
  TB->ShowHint=true;
  TB->OnClick=BorderInner;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=3;
  TB->Hint="Верхняя граница";
  TB->ShowHint=true;
  TB->OnClick=BorderTop;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=4;
  TB->Hint="Левая граница";
  TB->ShowHint=true;
  TB->OnClick=BorderLeft;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=5;
  TB->Hint="Правая граница";
  TB->ShowHint=true;
  TB->OnClick=BorderRight;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=6;
  TB->Hint="Нижняя граница";
  TB->ShowHint=true;
  TB->OnClick=BorderBottom;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=7;
  TB->Hint="Без границ";
  TB->ShowHint=true;
  TB->OnClick=BorderNone;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsSeparator;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=8;
  TB->Hint="Заливка";
  TB->ShowHint=true;
  TB->OnClick=Filling;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=9;
  TB->Hint="Картинка";
  TB->ShowHint=true;
  TB->OnClick=Image;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsSeparator;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=10;
  TB->Hint="Объединить ячейки";
  TB->ShowHint=true;
  TB->OnClick=JoinCells;
  TB->Parent=TBar;
  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=11;
  TB->Hint="Отменить объединение ячеек";
  TB->ShowHint=true;
  TB->OnClick=CancelJoin;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsSeparator;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=12;
  TB->Hint="Равнение по левому краю";
  TB->ShowHint=true;
  TB->OnClick=LeftAlign;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=13;
  TB->Hint="Равнение по центру";
  TB->ShowHint=true;
  TB->OnClick=HCenterAlign;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=14;
  TB->Hint="Равнение по правому краю";
  TB->ShowHint=true;
  TB->OnClick=RightAlign;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsSeparator;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=15;
  TB->Hint="Равнение по верхнему краю";
  TB->ShowHint=true;
  TB->OnClick=TopAlign;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=16;
  TB->Hint="Равнение по центру";
  TB->ShowHint=true;
  TB->OnClick=VCenterAlign;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=17;
  TB->Hint="Равнение по нижнему краю";
  TB->ShowHint=true;
  TB->OnClick=BottomAlign;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsSeparator;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->ImageIndex=18;
  TB->Hint="Свойства шрифта";
  TB->ShowHint=true;
  TB->OnClick=FontProps;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsSeparator;
  TB->Parent=TBar;

  TB=new TToolButton(this);
  TB->Left=10000;
  TB->Style=tbsCheck;
  TB->ImageIndex=19;
  TB->Hint="Режим конструктора";
  TB->ShowHint=true;
  TB->OnClick=GridMode;
  TB->Parent=TBar;

  ConstrMode=false;

  FMainPanel=new TWTPanel(this);
  FMainPanel->Align=alClient;
  FMainPanel->RealWidth=Width-10;
  FMainPanel->RealHeight=Height-26;
  FMainPanel->Parent=MainTabSheet;

  NamesMenu=new TPopupMenu(this);
  NamesMenu->OnPopup=ShowNamesList;

  TWTToolButton* Button;

  TWTToolBar* Bar=new TWTToolBar(this);
  Bar->Parent=CoolBar;
  Bar->ID="Главная панель";

  GridToolBar=new TWTToolBar(this);
  GridToolBar->Parent=this;
  GridToolBar->ID="Работа с документом";

  Bar->AddButton("Save", "Сохранить", SaveDoc)->ID="Save";
  Bar->AddButton("Print", "Печать", PrintDoc)->ID="Print";
  Bar->AddButton("|","",NULL);
  Bar->AddButton("PrevGrid", "Предыдущий отчет", PrevGrid)->ID="Prev";
  Button=Bar->AddButton("GridsList", "Список отчетов", ShowNamesList);
  Button->ID="List";
  Button->DropdownMenu=NamesMenu;
  Bar->AddButton("NextGrid", "Следующий отчет отчет", NextGrid)->ID="Next";


  GridToolBar->AddButton("New", "Новый отчет", AddGridToDoc)->ID="New";
  GridToolBar->AddButton("Delete", "Удалить", DelDoc)->ID="Del";
  GridToolBar->AddButton("|","",NULL);
  GridToolBar->AddButton("Import", "Импорт отчета", ImportDoc)->ID="Import";
  GridToolBar->AddButton("Export", "Экспорт отчета", ExportDoc)->ID="Export";
  GridToolBar->AddButton("|","",NULL);
  GridToolBar->AddButton("Refresh", "Обновить переменные", RefreshValues)->ID="Refresh";

  GridToolBar->Parent=NULL;

  CoolBar->AddToolBar(Bar);
  GridsList=new TList();

  PenColor=clBlack;
  FillingColor=clWhite;

  Constructor=false;
//  TForm::OnClose=FOnUserExit;
}

__fastcall TWTDoc::~TWTDoc(){
  delete GridsList;
}

void __fastcall TWTDoc::OnClose(TObject* Sender, TCloseAction &Action){
  TList* L=new TList();
  MainPanel->ParamsByType(pkGrid,L);
  for (int x=0;x<L->Count;x++) {
    TWTDBGrid* DBGrid=(TWTDBGrid*)((TWTParamItem*)L->Items[x])->Control;
    if (DBGrid->DataSource->State==dsInsert || DBGrid->DataSource->State==dsEdit) {
      ShowMessage("Перед закрытием сохраните данные в таблицах");
      Action=caNone;
      return;
    }
  }
}


void __fastcall TWTDoc::SetConstructor(bool Value){
  FConstructor=Value;
  GridTabSheet->TabVisible=Value;
  if (!Value) {
    PageControl->ActivePage=MainTabSheet;
  }
}

void __fastcall TWTDoc::FOnShow(TObject *Sender){
//  FMainPanel->ApplyParams();
  FMainPanel->AlignSize();
  FMainPanel->Width=FMainPanel->RealWidth+8;
  FMainPanel->Height=FMainPanel->RealHeight+26;
}

#include "reportview.h"

void __fastcall TWTDoc::PrintDoc(TObject* Sender){
  RefreshValues(NULL);
  Grid->PrintPrepare();
  TWTReportView *PF=new TWTReportView(Application);
  PF->QRPreview->QRPrinter= Grid->Printer;
  PF->SetCaption("Печать ["+Caption+"]");
  PF->FormStyle=fsMDIChild;
}

int GCount=0;

void __fastcall TWTDoc::RefreshValues(TObject* Sender){
  Grid->Adapter->ClearGridDec();
  GCount=10;
  RefreshPanelValues(FMainPanel,true);
  Grid->Repaint();
}

void __fastcall TWTDoc::RefreshPanelValues(TWTPanel* Panel,bool R){
  TWTPanel *P;
  if (R) {
    for (int x=0;x<Panel->ValuePanels->Count;x++) {
      RefreshPanelValues((TWTPanel*)Panel->ValuePanels->Items[x],R);
    }
  }
  for (int y=0;y<Panel->Params->Count;y++) {
    if (Panel->Params->Get(y)->Kind==pkGrid) {
     // Grid->Adapter->RemoveDeclaration(Panel->Params->Get(y)->ID);
      //Grid->Adapter->AddDeclaration(Panel->Params->Get(y)->ID,GCount,"TDBGrid",&Panel->Params->Get(y)->FControl);
      void* Pointer=((TWTDBGrid*)Panel->Params->Get(y)->FControl)->MethodAddress("Field");
      //Grid->Adapter->AddFunction("Field","TDBGrid",Pointer);
      GCount++;
    } else {
      Panel->Params->Get(y)->TempValue=Panel->Params->Get(y)->Value;
      Grid->Adapter->AddGridDec(Panel->Params->Get(y)->ID,"s    tring",&Panel->Params->Get(y)->TempValue);
    }
  }
}


void __fastcall TWTDoc::SetGridNum(int Value){
  if (Value>=GridsList->Count) return;
  ((TWTCellGrid*)GridsList->Items[Value])->BringToFront();
  AnsiString MP=Caption.SubString(1,Caption.LastDelimiter("[")-2);
  if (MP!="") SetCaption(MP+" ["+((TWTCellGrid*)GridsList->Items[Value])->GridName+"]");
  else SetCaption(Caption+" ["+((TWTCellGrid*)GridsList->Items[Value])->GridName+"]");
  FGridNum=Value;
}

TWTCellGrid* __fastcall TWTDoc::GetGrid(){
  if (!GridsList->Count) return NULL;
  return (TWTCellGrid*)GridsList->Items[FGridNum];
}

void __fastcall TWTDoc::ShowNamesList(TObject* Sender){
  while (NamesMenu->Items->Count) NamesMenu->Items->Delete(0);

  for (int x=0;x<GridsList->Count;x++) {
    TMenuItem *MI=new TMenuItem(NamesMenu);
    MI->Caption=((TWTCellGrid*)GridsList->Items[x])->GridName;
    MI->Bitmap->LoadFromResourceName(0,"Report");
    MI->OnClick=NamesMenuChoose;
    NamesMenu->Items->Add(MI);
  }
}

void __fastcall TWTDoc::NamesMenuChoose(TObject* Sender){
  TMenuItem *MI=(TMenuItem*)Sender;
  for (int x=0;x<GridsList->Count;x++) {
    if (((TWTCellGrid*)GridsList->Items[x])->GridName==MI->Caption) GridNum=x;
  }
}


void __fastcall TWTDoc::AddGridToDoc(TObject* Sender){
  TWTParamsForm *PF=new TWTParamsForm(Application,"Новый отчет");
  PF->Params->AddSimple("Имя",150,"",true);
  PF->Params->AddSimple("Рядов",50,"10",true);
  PF->Params->AddSimple("Столбцов",50,"10",true);
  PF->OnAccept=OnNewDoc;
  PF->TForm::ShowModal();
  delete PF;
}

void __fastcall TWTDoc::OnNewDoc(TWTParamsForm* Sender,bool &CloseFlag){
  TWTParamsForm *PF=(TWTParamsForm*)Sender;
  if (PF->Params->Get(0)->Value=="") {
    ShowMessage("Не указано имя");
    CloseFlag=false;
    return;
  }
  try {
    StrToInt(PF->Params->Get(1)->Value);
    StrToInt(PF->Params->Get(2)->Value);
  } catch (...) {
    ShowMessage("В размерах должны быть только целые числа");
    CloseFlag=false;
    return;
  }
  for (int x=0;x<GridsList->Count;x++) {
    if (PF->Params->Get(0)->Value==((TWTCellGrid*)GridsList->Items[x])->Name) {
      CloseFlag=false;
      ShowMessage("Отчет с таким именем уже существует");
      return;
    }
  }

  TWTCellGrid *CellGrid=new TWTCellGrid(this,StrToInt(PF->Params->Get(1)->Value),StrToInt(PF->Params->Get(2)->Value));
  CellGrid->Parent=GridTabSheet;
  CellGrid->GridName=PF->Params->Get(0)->Value;
  CellGrid->Align=alClient;
  CellGrid->OnFirstDupPrint->Clear();
  CellGrid->OnFirstDupPrint->Add("1;");
  CellGrid->OnNextDupPrint->Clear();
  CellGrid->OnNextDupPrint->Add("0;");
  if (ConstrMode) CellGrid->Mode=1;
  else CellGrid->Mode=0;
  FGridNum=GridsList->Count;
  GridsList->Add(CellGrid);
  RefreshValues(NULL);
}

void __fastcall TWTDoc::NextGrid(TObject* Sender){
  if (GridNum!=GridsList->Count-1) GridNum++;
}

void __fastcall TWTDoc::PrevGrid(TObject* Sender){
  if (GridNum!=0) GridNum--;
}

void __fastcall TWTDoc::SaveDoc(TObject* Sender){
//  if (!FileExists(DocFile)) return;
  SaveToFile(DocFile);
}

void __fastcall TWTDoc::ImportDoc(TObject* Sender){

  TWTCellGrid *CellGrid=new TWTCellGrid(this,1,1);
  TOpenDialog* OD=new TOpenDialog(this);
  OD->DefaultExt="*.cgf";
  OD->Options.Clear();
  OD->InitialDir="reports";
  OD->Options=OD->Options << ofHideReadOnly << ofPathMustExist << ofFileMustExist;
  OD->Filter="Файл Cells Grid|*.cgf";
  if (OD->Execute()) {
    CellGrid->Parent=GridTabSheet;
    CellGrid->Align=alClient;
    CellGrid->LoadFromFile(OD->Files->Strings[0]);
    if (ConstrMode) CellGrid->Mode=1;
    else CellGrid->Mode=0;
    GridsList->Add(CellGrid);
    GridNum=GridsList->Count-1;
    RefreshValues(NULL);
  }
  delete OD;

}

void __fastcall TWTDoc::ExportDoc(TObject* Sender){
  if (!Grid) return;
  TSaveDialog* SD=new TSaveDialog(this);
  SD->DefaultExt="*.cgf";
  SD->Options.Clear();
  SD->Options=SD->Options << ofHideReadOnly << ofOverwritePrompt;
  SD->InitialDir="reports";
  SD->Filter="Файл Cells Grid|*.cgf";
  if (SD->Execute()) {
    Grid->SaveToFile(SD->Files->Strings[0]);
  }
  delete SD;
}

bool __fastcall TWTDoc::LoadFromFile(AnsiString FileName){
  FILE *f=fopen(FileName.c_str(),"rb");
  if (f==NULL) return false;
  int FileID;
  fread(&FileID,4,1,f);
  if (FileID!=0xAABBCCDD) return false;
  int ReportCount;
  fread(&ReportCount,4,1,f);
  for (int x=0;x<ReportCount;x++) {
    TWTCellGrid *CellGrid=new TWTCellGrid(this,10,10);
    GridsList->Add(CellGrid);
    FGridNum=x;
    RefreshValues(NULL);
    CellGrid->Parent=GridTabSheet;
    CellGrid->LoadFromFile(f);
    CellGrid->Align=alClient;
    if (ConstrMode) CellGrid->Mode=1;
    else CellGrid->Mode=0;
  }
  GridNum=0;
  fclose(f);
  return true;
}

bool __fastcall TWTDoc::SaveToFile(AnsiString FileName){
  FILE *f=fopen(FileName.c_str(),"wb");
  if (f==NULL) return false;
  int FileID=0xAABBCCDD;
  fwrite(&FileID,4,1,f);
  int ReportCount=GridsList->Count;
  fwrite(&ReportCount,4,1,f);
  for (int x=0;x<ReportCount;x++) {
    ((TWTCellGrid*)GridsList->Items[x])->SaveToFile(f);
  }
  fclose(f);
  return true;
}

void __fastcall TWTDoc::DelDoc(TObject* Sender){
  if (!Grid) return;
  TMsgDlgButtons But;
  But.Clear();
  But=But << mbYes << mbNo;
  int MR=MessageDlg("Действительно удалить текущий отчет?",mtConfirmation,But,0);
  if (MR==mrYes) {
    delete Grid;
    GridsList->Delete(FGridNum);
    if (FGridNum>0) GridNum--;
  }
}

void __fastcall TWTDoc::BorderAll(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,Pen,Pen,Pen,Pen,Pen);
  delete Pen;
}

void __fastcall TWTDoc::BorderOuter(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,Pen,Pen,Pen,Pen,0);
  delete Pen;
}

void __fastcall TWTDoc::BorderInner(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,0,0,0,0,Pen);
  delete Pen;
}

void __fastcall TWTDoc::BorderTop(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,0,Pen,0,0,0);
  delete Pen;
}

void __fastcall TWTDoc::BorderLeft(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,Pen,0,0,0,0);
  delete Pen;
}

void __fastcall TWTDoc::BorderRight(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,0,0,Pen,0,0);
  delete Pen;
}

void __fastcall TWTDoc::BorderBottom(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=CBox->ItemIndex;
  Grid->SelCellsDraw(0,0,0,0,Pen,0);
  delete Pen;
}

void __fastcall TWTDoc::BorderNone(TObject* Sender){
  if (!Grid) return;
  TPen *Pen=new TPen();
  Pen->Color=PenColor;
  Pen->Width=0;
  Grid->SelCellsDraw(0,Pen,Pen,Pen,Pen,Pen);
  delete Pen;
}

void __fastcall TWTDoc::Filling(TObject* Sender){
  if (!Grid) return;
  Grid->SelCellsDraw(OldFill->Brush,0,0,0,0,0);
}

void __fastcall TWTDoc::Image(TObject* Sender){
  if (!Grid) return;
  TOpenDialog* OD=new TOpenDialog(this);
  OD->DefaultExt="*";
  OD->Options.Clear();
  OD->InitialDir="Images";
  OD->Options=OD->Options << ofHideReadOnly << ofPathMustExist << ofFileMustExist;
  OD->Filter="Файл Windows Bitmap (*.bmp)|*.bmp";
  if (OD->Execute()) {
    Grid->SetImages(OD->Files->Strings[0]);
  }
  delete OD;
}

void __fastcall TWTDoc::JoinCells(TObject* Sender){
  if (!Grid) return;
  Grid->JoinCells();
}

void __fastcall TWTDoc::CancelJoin(TObject* Sender){
  if (!Grid) return;
  Grid->CancelJoin();
}

void __fastcall TWTDoc::LeftAlign(TObject* Sender){
  if (!Grid) return;
  Grid->SetHAlign(taLeftJustify);
}

void __fastcall TWTDoc::HCenterAlign(TObject* Sender){
  if (!Grid) return;
  Grid->SetHAlign(Classes::taCenter);
}

void __fastcall TWTDoc::RightAlign(TObject* Sender){
  if (!Grid) return;
  Grid->SetHAlign(taRightJustify);
}

void __fastcall TWTDoc::TopAlign(TObject* Sender){
  if (!Grid) return;
  Grid->SetVAlign(taTopJustify);
}

void __fastcall TWTDoc::VCenterAlign(TObject* Sender){
  if (!Grid) return;
  Grid->SetVAlign(Classes::taCenter);
}

void __fastcall TWTDoc::BottomAlign(TObject* Sender){
  if (!Grid) return;
  Grid->SetVAlign(taBottomJustify);
}

void __fastcall TWTDoc::FontProps(TObject* Sender){
  if (!Grid) return;
  TFontDialog *FD=new TFontDialog(Application);
  FD->Font=Grid->Cells[Grid->Selection.Left][Grid->Selection.Top]->Font;
  if (FD->Execute()) {
    Grid->SetFont(FD->Font);
  }
}

void __fastcall TWTDoc::GridMode(TObject* Sender){
  if (ConstrMode) ConstrMode=0;
  else ConstrMode=1;
  if (!Grid) return;
  if (ConstrMode) Grid->Mode=1;
  else Grid->Mode=0;
}

void __fastcall TWTDoc::DrawColorPanel(){
  TToolBar* TBar= new TToolBar(this);
  TBar->AutoSize=true;
  TBar->EdgeBorders=TBar->EdgeBorders >> ebLeft >> ebTop >> ebRight >> ebBottom;
//  TBar->BorderWidth=1;
  TBar->Flat=true;
  TBar->Align=alBottom;
  TBar->Width=10000;
  TBar->Parent=GridTabSheet;
  TBar->ButtonHeight=12;

  TColor Colors[19];
  Colors[0]=clBlack;
  Colors[1]=clDkGray;
  Colors[2]=clGray;
  Colors[3]=clLtGray;
  Colors[4]=clAqua;
  Colors[5]=clBlue;
  Colors[6]=clFuchsia;
  Colors[7]=clGreen;
  Colors[8]=clLime;
  Colors[9]=clMaroon;
  Colors[10]=clNavy;
  Colors[11]=clOlive;
  Colors[12]=clPurple;
  Colors[13]=clRed;
  Colors[14]=clTeal;
  Colors[15]=clWhite;
  Colors[16]=clYellow;
  Colors[17]=clInfoBk;

  TShape* S;
  for (int x=0;x<18;x++) {
    S=new TShape(this);
    S->Width=15;
    S->Height=15;
    S->Left=10000;
    S->Brush->Color=Colors[x];
    S->OnMouseDown=ChooseColor;
    S->Pen->Width=2;
    if (x==0) {
      OldPen=S;
      OldFill=S;
      S->Pen->Color=clDkGray;
    }
    else S->Pen->Color=clBtnFace;
    S->Parent=TBar;
  }

}

void __fastcall TWTDoc::ChooseColor(System::TObject* Sender, TMouseButton Button, Classes::TShiftState Shift, int X, int Y){
  TShape* S=(TShape*)Sender;
  if (Button==mbLeft && S->Pen->Color!=clBlack && S->Pen->Color!=clDkGray) {
    if (S->Pen->Color==clWhite) S->Pen->Color=clDkGray;
    else S->Pen->Color=clBlack;
    if (OldPen->Pen->Color==clDkGray) OldPen->Pen->Color=clWhite;
    else OldPen->Pen->Color=clBtnFace;
    PenColor=S->Brush->Color;
    OldPen=S;
  }
  if (Button==mbRight && S->Pen->Color!=clWhite && S->Pen->Color!=clDkGray) {
    if (S->Pen->Color==clBlack) S->Pen->Color=clDkGray;
    else S->Pen->Color=clWhite;
    if (OldFill->Pen->Color==clDkGray) OldFill->Pen->Color=clBlack;
    else OldFill->Pen->Color=clBtnFace;
    FillingColor=S->Brush->Color;
    OldFill=S;
  }
}

void __fastcall TWTDoc::ShowGridToolBar(TObject* Sender){
  if (PageControl->ActivePage==GridTabSheet) {
    LockWindowUpdate(Handle);
    CoolBar->AddToolBar(GridToolBar);
    LockWindowUpdate(NULL);
  } else {
    CoolBar->RemoveToolBar(GridToolBar);
  }
}


//=============================================================================
//============= TWTPanel  =====================================================
//=============================================================================
//=============================================================================

__fastcall TWTPanel::TWTPanel(TComponent* AOwner) :TPanel(AOwner){
  Params=new TWTParamsList(this);
  LinePanels=new TList();
  ValuePanels=new TList();
  Caption="";
  OnExit=FDoExit;
  OnEnter=FDoEnter;
  RealHeight=0;
  RealWidth=0;
  Breaked=true;
  ActiveControl=NULL;
  FAlignByClient=false;
}

__fastcall TWTPanel::~TWTPanel(){
  delete LinePanels;
  delete ValuePanels;
  delete Params;
}

TWTPanel* __fastcall TWTPanel::InsertPanel(float W,bool Break,float H){
  if (!ValuePanels->Count) Break=true;

  TPanel* LPanel;
  if (Break==true || !LinePanels->Count) {
    if (Break==true && LinePanels->Count) {
      TPanel *P=(TPanel*)LinePanels->Items[LinePanels->Count-1];
      P->Align=alTop;
      TWTPanel *VP=(TWTPanel*)ValuePanels->Items[ValuePanels->Count-1];
      P->Height=VP->RealHeight;
    }
    if (!LinePanels->Count){
      SavedBevelInner=BevelInner;
      SavedBevelOuter=BevelOuter;
      BevelInner=bvNone;
      BevelOuter=bvNone;
    }
    LPanel=new TPanel(this);
    LPanel->Caption="";
    LPanel->BevelOuter=bvNone;
    LPanel->BevelInner=bvNone;
    LPanel->Align=alClient;
    LPanel->Parent=this;
    LinePanels->Add(LPanel);
  }
  if (!Break){
    TWTPanel *P=(TWTPanel*)ValuePanels->Items[ValuePanels->Count-1];
    P->Align=alLeft;
    P->Width=P->RealWidth;
    H=P->RealHeight;
  }
  TWTPanel* VPanel=new TWTPanel(this);
  VPanel->BevelOuter=SavedBevelOuter;
  VPanel->BevelInner=SavedBevelInner;
  if (H<1 && H>0) {
//    VPanel->SavedHeight=SavedHeight*H;
    VPanel->RealHeight=RealHeight*H;
  } else {
//    VPanel->SavedHeight=H;
    VPanel->RealHeight=H;
  }

  if (W<1 && W>0) {
//    VPanel->SavedWidth=SavedWidth*W;
    VPanel->RealWidth=RealWidth*W;
  } else {
//    VPanel->SavedWidth=W;
    VPanel->RealWidth=W;
  }
  VPanel->Align=alClient;
  VPanel->Parent=(TPanel*)LinePanels->Items[LinePanels->Count-1];
  VPanel->ParentPanel=this;
  VPanel->Breaked=Break;
  ValuePanels->Add(VPanel);
  return VPanel;
}

TSplitter* __fastcall TWTPanel::SetVResize(int MinSize){
  if (ValuePanels->Count) {
    TPanel* LP=(TPanel*)LinePanels->Items[LinePanels->Count-1];
    TSplitter *S=new TSplitter(this);
    S->Top=LP->Top+LP->Height+10;
    S->Align=alTop;
    S->Height=2;
    S->MinSize=MinSize;
    S->Parent=this;
    S->Beveled=false;
    return S;
  }
  return NULL;
}

TSplitter* __fastcall TWTPanel::SetHResize(int MinSize){
  TWTPanel *P;
  TPanel *LP;
  if (ValuePanels->Count) {
    P=(TWTPanel*)ValuePanels->Items[ValuePanels->Count-1];
    LP=(TPanel*)LinePanels->Items[LinePanels->Count-1];
    P->Align=alLeft;
    P->Width=P->RealWidth;
    TSplitter *S=new TSplitter(this);
    S->Left=P->Left+P->Width+10;
    S->Align=alLeft;
    S->Width=2;
    S->MinSize=MinSize;
    S->Parent=LP;
    S->Beveled=false;
    return S;
  }
  return NULL;
}

void __fastcall TWTPanel::FDoEnter(TObject* Sender){
  if (ValuePanels->Count) return;
  if (CheckParent(Screen->ActiveControl,"TWTDBGrid")) {
    TWTMDIWindow* MF;
    if (CheckParent(Screen->ActiveForm,"TWTMDIWindow")) {
      MF=(TWTMDIWindow*)Screen->ActiveForm;
//      MF->CoolBar->AutoSize=false;
      LockWindowUpdate(MF->Handle);
      MF->CoolBar->AddToolBar(((TWTDBGrid*)Screen->ActiveControl)->ToolBar);
      LockWindowUpdate(NULL);
//      MF->CoolBar->AutoSize=true;
    }
  } else {
    BevelInner=bvLowered;
  }
  ActiveControl=Screen->ActiveControl;
}

void __fastcall TWTPanel::FDoExit(TObject* Sender){
  if (!ValuePanels->Count) BevelInner=bvNone;
  if (!ActiveControl) return;
  if (CheckParent(ActiveControl,"TWTDBGrid")) {
    TWTMDIWindow* MF;
    if (CheckParent(Screen->ActiveForm,"TWTMDIWindow")) {
      MF=(TWTMDIWindow*)Screen->ActiveForm;
      MF->CoolBar->RemoveToolBar(((TWTDBGrid*)ActiveControl)->ToolBar);
    }
  }
  ActiveControl=NULL;
}

void __fastcall TWTPanel::AlignSize(){
  int CurX=0;
  int CurY=0;
  int BreakNum=0;
  if (ValuePanels->Count) {
    TWTPanel *P;
    for (int x=0;x<ValuePanels->Count;x++) {

      P=(TWTPanel*)ValuePanels->Items[x];

      bool Flag=false;
      if (x==ValuePanels->Count-1) Flag=true;
      else {
        if (((TWTPanel*)ValuePanels->Items[x+1])->Breaked) Flag=true;
      }
      P->AlignSize();
      if (P->Align!=alClient) P->Width=P->RealWidth;

      CurX+=P->RealWidth;

      if (P->RealHeight>CurY) CurY=P->RealHeight;

      if (Flag){
        if (CurX>RealWidth) RealWidth=CurX;
        CurX=0;

        RealHeight+=CurY;
        if (((TPanel*)LinePanels->Items[BreakNum])->Align!=alClient) ((TPanel*)LinePanels->Items[BreakNum])->Height=CurY;
        CurY=0;
        BreakNum++;
      } else {
//        if (P->RealHeight>CurY) CurY=P->RealHeight;
      }
    }
  } else {
    RealHeight+=2;
    RealWidth+=2;
  }
}

void __fastcall TWTPanel::SetAlignByClient(bool Value){
  FAlignByClient=Value;
  TPanel* BP;
  TWTPanel* P;
  TWTPanel* CP;
  if (Value) {
    if (Align!=alClient) {
      int StartP=ParentPanel->ValuePanels->IndexOf(this);
      for (int x=0;x<StartP;x++) {
        CP=(TWTPanel*)ParentPanel->ValuePanels->Items[x];
        CP->Align=alLeft;
        CP->Width=CP->RealWidth;
      }
      for (int x=StartP+1;x<ParentPanel->ValuePanels->Count;x++) {
        CP=(TWTPanel*)ParentPanel->ValuePanels->Items[x];
        CP->Align=alRight;
        CP->Width=CP->RealWidth;
      }
      Align=alClient;
    }
    if (CheckParent(Parent,"TPanel")) {
      if (CheckParent(Parent->Parent,"TWTPanel")) {
        P=(TWTPanel*)Parent->Parent;
        int StartP=P->LinePanels->IndexOf(Parent);
        for (int x=0;x<StartP;x++) {
          BP=(TPanel*)P->LinePanels->Items[x];
          BP->Align=alTop;
          BP->Height=((TWTPanel*)BP->Controls[0])->RealHeight;
        }
        for (int x=StartP+1;x<P->LinePanels->Count;x++) {
          BP=(TPanel*)P->LinePanels->Items[x];
          BP->Align=alBottom;
          BP->Height=((TWTPanel*)BP->Controls[0])->RealHeight;
        }
        Parent->Align=alClient;
      }
    }
  } else {
  }
}

TWTParamItem* __fastcall TWTPanel::ParamByID(AnsiString ID){
  for (int x=0;x<ValuePanels->Count;x++) {
    TWTParamItem* PI=((TWTPanel*)ValuePanels->Items[x])->ParamByID(ID);
    if (PI!=NULL) return PI;
  }

  for (int x=0;x<Params->Count;x++) {
    if (Params->Get(x)->ID==ID) return Params->Get(x);
  }

  return NULL;
}

void __fastcall TWTPanel::ParamsByType(int Type,TList* List){
  if (List==NULL) return;
  for (int x=0;x<ValuePanels->Count;x++) {
    ((TWTPanel*)ValuePanels->Items[x])->ParamsByType(Type,List);
  }
  for (int x=0;x<Params->Count;x++) {
    if (Params->Get(x)->Type==Type) List->Add(Params->Get(x));
  }
}


