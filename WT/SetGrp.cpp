//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "SetGrp.h"

//---------------------------------------------------------------------------
__fastcall TWTSetGrp::TWTSetGrp(TGrpProperty* GP,TTreeView* TW,TWinControl* Owner): TWTMDIWindow(Owner) {

  TreeView=TW;
  GrpProperty=GP;
//  SF=(TWTSelFields*)Owner;

  Font=new TFont();
  Font->Assign(GrpProperty->CaptFont);
  Color=GrpProperty->BgColor;

  Top=Owner->Top-100;
  Left=Owner->Left-100;
  Width=426;
  Height=214;
  Caption="Свойства группы";
  BorderStyle=bsDialog;
//  BorderIcons = BorderIcons << biSystemMenu >> biMinimize >> biMaximize;
//  Position=poScreenCenter;

  Panel1=new TPanel(this);
  Panel1->Top=0;
  Panel1->Left=0;
  Panel1->Width=Width-6;
  Panel1->Height=Height-25;
  Panel1->Anchors=Panel1->Anchors >> akLeft >> akTop >> akRight >> akBottom;
  Panel1->Caption="";
  Panel1->BevelInner=bvNone;
  Panel1->BevelOuter=bvLowered;
  Panel1->Parent=this;

  Panel2=new TPanel(this);
  Panel2->Align=alBottom;
  Panel2->Height=40;
  Panel2->Caption="";
  Panel2->Parent= Panel1;
  Panel2->BorderWidth=2;

  TSh1= new TTabSheet(this);
  TSh2= new TTabSheet(this);

  PageControl1= new TPageControl(this);
  PageControl1->Align=alClient;
  PageControl1->ActivePage = TSh1;
  PageControl1->Parent= Panel1;

  if (TW->Selected->Index) TSh1->PageControl=PageControl1;
  TSh1->Caption="Внешний вид";
  TSh2->PageControl=PageControl1;
  TSh2->Caption="Итоги";

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Ok");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Ok");
  SBOk->Caption="OK";
  SBOk->Width=70;
  SBOk->Height=25;
  SBOk->Top=8;
  SBOk->Left= Panel2->Width/2-35;
  SBOk->Parent=Panel2;
  SBOk->OnClick= SBOkClick;

 // FormStyle=fsMDIChild;

  Bevel3=new TBevel(this);
  Bevel3->Align = alClient;
  Bevel3->Shape = bsFrame;
  Bevel3->Parent=TSh1;

  Label1=new TLabel(this);
  Label1->Left = 30;
  Label1->Top = 10;
  Label1->Width = 162;
  Label1->Height = 13;
  Label1->Caption = "Включать в содержание группы";
  Label1->Parent=TSh1;

  Label2=new TLabel(this);
  Label2->Left = 5;
  Label2->Top = 37;
  Label2->Width = 102;
  Label2->Height = 13;
  Label2->Caption = "Содержание группы";
  Label2->Parent=TSh1;

  //TWTFontButton* FontButton=
  new TWTFontButton(330,60,Font,TSh1);
  //TWTColorButton* CButton=
  new TWTColorButton(101,61,Color,TSh1);

  Label3=new TLabel(this);
  Label3->Left = 41;
  Label3->Top = 65;
  Label3->Width = 54;
  Label3->Height = 13;
  Label3->Caption = "Цвет фона";
  Label3->Parent=TSh1;

  Label4=new TLabel(this);
  Label4->Left = 191;
  Label4->Top = 65;
  Label4->Width = 135;
  Label4->Height = 13;
  Label4->Caption = "Шрифт подписей значений";
  Label4->Parent=TSh1;

  Label5=new TLabel(this);
  Label5->Left = 185;
  Label5->Top = 93;
  Label5->Width = 141;
  Label5->Height = 13;
  Label5->Caption = "Промежуток между полями";
  Label5->Parent=TSh1;

  Label6=new TLabel(this);
  Label6->Left = 60;
  Label6->Top = 93;
  Label6->Width = 35;
  Label6->Height = 13;
  Label6->Caption = "Отступ";
  Label6->Parent=TSh1;

  EName=new TEdit(this);
  EName->Left = 115;
  EName->Top = 33;
  EName->Width = 288;
  EName->Height = 21;
  EName->Color = clBtnFace;
  EName->ReadOnly = True;
  EName->TabOrder = 0;
  EName->Parent=TSh1;

  SEDist=new TCSpinEdit(this);
  SEDist->Left = 329;
  SEDist->Top = 88;
  SEDist->Width = 74;
  SEDist->Height = 22;
  SEDist->TabStop = True;
  SEDist->EditorEnabled = true;
  SEDist->MaxValue = 1000;
  SEDist->MinValue = 10;
  SEDist->TabOrder = 1;
  SEDist->Text=GrpProperty->Dist;
  SEDist->Parent=TSh1;

  SEOtst=new TCSpinEdit(this);
  SEOtst->Left = 101;
  SEOtst->Top = 88;
  SEOtst->Width = 74;
  SEOtst->Height = 22;
  SEOtst->TabStop = True;
  SEOtst->EditorEnabled = true;
  SEOtst->MaxValue = 1000;
  SEOtst->MinValue = 0;
  SEOtst->TabOrder = 2;
  SEOtst->Value=GrpProperty->Otst;
  SEOtst->Parent=TSh1;

  CBCapt=new TCheckBox(this);
  CBCapt->Left = 203;
  CBCapt->Top = 8;
  CBCapt->Width = 116;
  CBCapt->Height = 17;
  CBCapt->Caption = "Подписи значений";
  CBCapt->Checked=GrpProperty->IsName;
  CBCapt->TabOrder = 3;
  CBCapt->OnClick=CBClick;
  CBCapt->Parent=TSh1;

  CBVal=new TCheckBox(this);
  CBVal->Left = 326;
  CBVal->Top = 8;
  CBVal->Checked=GrpProperty->IsValue;
  CBVal->Width = 73;
  CBVal->Height = 17;
  CBVal->Caption = "Значения";
  CBVal->TabOrder = 4;
  CBVal->OnClick=CBClick;
  CBVal->Parent=TSh1;

  CBClick(NULL);

  Bevel2=new TBevel(this);
  Bevel2->Left = 232;
  Bevel2->Top = 90;
  Bevel2->Width = 176;
  Bevel2->Height = 26;
  Bevel2->Shape = bsFrame;
  Bevel2->Parent=TSh2;

  CLFields=new TCheckListBox(this);
  CLFields->Width = 180;
  CLFields->Align = alLeft;
  CLFields->ItemHeight = 13;
  CLFields->TabOrder = 0;
  CLFields->Parent=TSh2;
  CLFields->OnClickCheck=OnCheckCLFields;

  TField* FF;
  int y=0;
  for (int i=0;i<TW->Items->Item[0]->Count;i++) {
       FF=((TWTFieldProperty*)TW->Items->Item[0]->Item[i]->Data)->Field;
       if ((FF->DataType==ftInteger) || (FF->DataType==ftFloat)) {
          CLFields->Items->AddObject(TW->Items->Item[0]->Item[i]->Text,(TObject*)TW->Items->Item[0]->Item[i]->Data);
          if (GrpProperty->Fields->IndexOf(FF)>-1) CLFields->Checked[y]=true;
          y++;
       }
  }

  Panel3=new TPanel(this);
  Panel3->Left=300;
  Panel3->Width = 50;
  Panel3->Align = alLeft;
  Panel3->TabOrder = 1;
  Panel3->Parent=TSh2;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Sum");*/

  SBSum=new TSpeedButton(this);
  SBSum->Left = 13;
  SBSum->Top = 12;
  SBSum->Width = 24;
  SBSum->Height = 24;
  SBSum->GroupIndex = 1;
//  SBSum->Caption = "Sum";
  SBSum->ShowHint=true;
  SBSum->Hint="Функция \"Cуммирование\"";
  SBSum->Glyph->LoadFromResourceName(0,"Sum");
  SBSum->Flat = True;
  SBSum->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Avg");*/

  SBAvg=new TSpeedButton(this);
  SBAvg->Left = 13;
  SBAvg->Top = 36;
  SBAvg->Width = 24;
  SBAvg->Height = 24;
  SBAvg->GroupIndex = 1;
  SBAvg->Glyph->LoadFromResourceName(0,"Avg");
  SBAvg->ShowHint=true;
  SBAvg->Hint="Функция \"Среднее\"";
//  SBAvg->Caption = "Avg";
  SBAvg->Flat = True;
  SBAvg->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Max");*/

  SBMax=new TSpeedButton(this);
  SBMax->Left = 13;
  SBMax->Top = 60;
  SBMax->Width = 24;
  SBMax->Height = 24;
  SBMax->GroupIndex = 1;
  SBMax->Glyph->LoadFromResourceName(0,"Max");
  SBMax->ShowHint=true;
  SBMax->Hint="Функция \"Максимум\"";
//  SBMax->Caption = "Max";
  SBMax->Flat = True;
  SBMax->Parent=Panel3;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Min");*/

  SBMin=new TSpeedButton(this);
  SBMin->Left = 13;
  SBMin->Top = 84;
  SBMin->Width = 24;
  SBMin->Height = 24;
  SBMin->GroupIndex = 1;
  SBMin->Glyph->LoadFromResourceName(0,"Min");
  SBMin->ShowHint=true;
  SBMin->Hint="Функция \"Минимум\"";
//  SBMin->Caption = "Min";
  SBMin->Flat = True;
  SBMin->Parent=Panel3;

  if (GrpProperty->Function=="sum") SBSum->Down=true;
  if (GrpProperty->Function=="average") SBAvg->Down=true;
  if (GrpProperty->Function=="min") SBMin->Down=true;
  if (GrpProperty->Function=="max") SBMax->Down=true;

  RGKind=new TRadioGroup(this);
  RGKind->Left = 232;
  RGKind->Top = 3;
  RGKind->Width = 176;
  RGKind->Height = 57;
  RGKind->Caption = "Отображение";
  RGKind->TabOrder = 2;
  RGKind->Parent=TSh2;
  RGKind->Items->Add("экономное");
  RGKind->Items->Add("полное");
  if (GrpProperty->Kind) RGKind->ItemIndex=0;
  else RGKind->ItemIndex=1;

  ECapt=new TEdit(this);
  ECapt->Left = 232;
  ECapt->Top = 64;
  ECapt->Width = 175;
  ECapt->Height = 21;
  ECapt->TabOrder = 3;
  ECapt->Text = GrpProperty->IName;
  ECapt->Parent=TSh2;

  CBEnabled=new TCheckBox(this);
  CBEnabled->Left = 240;
  CBEnabled->Top = 96;
  CBEnabled->Width = 153;
  CBEnabled->Height = 17;
  CBEnabled->Caption = "Скрыть итоги для группы";
  CBEnabled->TabOrder = 4;
  CBEnabled->Parent=TSh2;
  CBEnabled->Checked=!GrpProperty->Enabled;
}

void __fastcall TWTSetGrp::SBOkClick(TObject* Sender){
  GrpProperty->Otst=SEOtst->Value;
  GrpProperty->Dist=SEDist->Value;
  GrpProperty->Enabled=!CBEnabled->Checked;
  if (RGKind->ItemIndex==1) GrpProperty->Kind=false;
  else GrpProperty->Kind=true;
  GrpProperty->IsName=CBCapt->Checked;
  GrpProperty->IsValue=CBVal->Checked;
  GrpProperty->IName=ECapt->Text;
  GrpProperty->Fields->Clear();
  GrpProperty->CaptFont->Assign(Font);
  GrpProperty->BgColor=Color;
  if (SBSum->Down) GrpProperty->Function="sum";
  if (SBAvg->Down) GrpProperty->Function="average";
  if (SBMin->Down) GrpProperty->Function="min";
  if (SBMax->Down) GrpProperty->Function="max";

  for (int x=0;x<CLFields->Items->Count;x++) {
    if (CLFields->Checked[x]) GrpProperty->Fields->Add(((TWTFieldProperty*)CLFields->Items->Objects[x])->Field);
  }
  ModalResult=1;
}

void __fastcall TWTSetGrp::CBClick(TObject* Sender){
  TTreeNode* TN;
  if ((!CBCapt->Checked) && (!CBVal->Checked)) {
    EName->Text="";
    return;
  }
  EName->Text="";
  TN=TreeView->Selected->getFirstChild();
  if (CBCapt->Checked) EName->Text=EName->Text+((TWTFieldProperty*)TN->Data)->Name;
  if (CBVal->Checked) EName->Text=EName->Text+" <"+((TField*)((TWTFieldProperty*)TN->Data)->Field)->FieldName+">";
  TN=TreeView->Selected->GetNextChild(TN);
  while (TN!=NULL) {
    EName->Text=EName->Text+"; ";
    if (CBCapt->Checked) EName->Text=EName->Text+((TWTFieldProperty*)TN->Data)->Name;
    if (CBVal->Checked) EName->Text=EName->Text+" <"+((TField*)((TWTFieldProperty*)TN->Data)->Field)->FieldName+">";
    TN=TreeView->Selected->GetNextChild(TN);
  }
}

void __fastcall TWTSetGrp::OnCheckCLFields(TObject *Sender){
  bool Flag=false;
  for (int x=0;x<CLFields->Items->Count;x++) if (CLFields->Checked[x]) Flag=true;
  if (Flag && CLFields->Checked[CLFields->ItemIndex]) CBEnabled->Checked=false;
  if (!Flag) CBEnabled->Checked=true;
}

#pragma package(smart_init)
