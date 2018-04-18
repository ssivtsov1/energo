//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "SetWFForm.h"

//---------------------------------------------------------------------
// функции класса TWTFilterForm
//---------------------------------------------------------------------
__fastcall TWTSetWFForm::TWTSetWFForm(TWTFieldProperty* FP,TComponent *Owner): TWTMDIWindow(Owner) {

  DataFont=new TFont();
  DataFont->Assign(FP->Font);
  BgColor=FP->BgColor;

  Width = 340;
  Height = 190;
  Caption = "Параметры поля";
  BorderStyle=bsDialog;
  Position=poScreenCenter;
  FieldProperty=FP;

  Panel1= new TPanel(this);
  Panel1->Top=0;
  Panel1->Left=0;
  Panel1->Width=Width-6;
  Panel1->Height=Height-25;
  Panel1->Anchors=Panel1->Anchors >> akLeft >> akTop >> akRight >> akBottom;
  Panel1->Caption="";
  Panel1->BevelInner=bvNone;
  Panel1->BevelOuter=bvLowered;
  Panel1->Parent=this;

  Panel2= new TPanel(this);
  Panel2->Align=alBottom;
  Panel2->Height=35;
  Panel2->BorderWidth=4;
  Panel2->Caption="";
  Panel2->Parent= Panel1;

  ProgressBar=new TProgressBar(this);
  ProgressBar->Align=alClient;
  ProgressBar->Visible=false;
  ProgressBar->Parent=Panel2;
//  ProgressBar->Smooth=true;

  Label= new TLabel(this);
  Label->Left=8+43;
  Label->Top=13;
  Label->Width= 108;
  Label->Caption = "Ширина поля ";
  Label->Parent= Panel1;

  Edit= new TEdit(this);
  Edit->Left = 120;
  Edit->Top = 8;
  Edit->Width = 113+10;
  Edit->Parent= Panel1;
  //Edit->Text=IntToStr(((TWTFieldProperty*)((TWTSelFields*)Owner)->LBDest->Items->Objects[((TWTSelFields*)Owner)->LBDest->ItemIndex])->FieldLength);
  Edit->Text=IntToStr(FieldProperty->FieldLength);

  AlignBox=new TComboBox(this);
  AlignBox->Left = 120;
  AlignBox->Top = 8+30;
  AlignBox->Width = 113+88;
  AlignBox->Parent= Panel1;
  AlignBox->Items->Add("По левому краю");
  AlignBox->Items->Add("По правому краю");
  AlignBox->Items->Add("По середине");
  AlignBox->Style=csOwnerDrawFixed;
  AlignBox->ItemIndex=FieldProperty->Align;

  Label= new TLabel(this);
  Label->AutoSize=true;
  Label->Top=13+30;
//  Label->Width= 108;
  Label->Caption = "Выравнивание текста ";
  Label->Left=120-Label->Width;
  Label->Parent= Panel1;

  LName= new TLabel(this);
  LName->Left=15;
  LName->Top=43+30;
  LName->Width= 108;
  LName->Caption = "Наименование поля ";
  LName->Parent= Panel1;

  EName= new TEdit(this);
  EName->Left = 120;
  EName->Top = 38+30;
  EName->Width = 113+88;
  EName->Parent= Panel1;
  EName->Text= FP->Name;


  // TWTFontButton* FontButton =
  new TWTFontButton(248,68+30,DataFont,Panel1);
  TWTColorButton* ColorButton=new TWTColorButton(170,68+30,BgColor,Panel1);

  LName= new TLabel(this);
  LName->AutoSize=true;
  LName->Top=73+30;
  LName->Width= 108;
  LName->Caption = "Параметры для данных";
  LName->Parent= Panel1;
  LName->Left=ColorButton->Left-LName->Width-10;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Ok");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Ok");
  SBOk->Caption="OK";
  SBOk->Width=73;
  SBOk->Height=22;
  SBOk->Top=8;
  SBOk->Left=130;
  SBOk->Parent=Panel2;
  SBOk->OnClick= SBOkClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Auto");*/

  SBAuto=new TSpeedButton(this);
  SBAuto->Glyph->LoadFromResourceName(0,"Auto");
  SBAuto->Caption="Авто";
  SBAuto->Width=73;
  SBAuto->Height=22;
  SBAuto->Top=8;
  SBAuto->Left= 248;
  SBAuto->Parent=Panel1;
  SBAuto->OnClick=SBAutoClick;

  SelFields=(TWTSelFields*)Owner;

//  FormStyle= fsMDIChild;
}

__fastcall TWTSetWFForm::~TWTSetWFForm() {
  delete DataFont;
}
//---------------------------------------------------------------------
void __fastcall TWTSetWFForm::SBAutoClick(TObject *Sender) {
  if (!SelFields->MainQuery->Active) {
    SelFields->MainQuery->Open();
  }
  int i;
  AnsiString FieldName, Max;
  FieldName=FieldProperty->Field->Name;
  Max="";

  SelFields->MainQuery->Last();
  int RN=SelFields->MainQuery->RecNo;
  SelFields->MainQuery->First();
  ProgressBar->Position=0;
  ProgressBar->Visible=true;
  ProgressBar->Max=RN;
  for (i=0; i<RN; i++) {
    if (FieldProperty->Field->DisplayText.Length()> Max.Length())
        Max= FieldProperty->Field->DisplayText;
    SelFields->MainQuery->Next();
    ProgressBar->StepBy(1);
  }
  ProgressBar->Visible=false;
  Edit->Text=IntToStr(StringSize(Max,FieldProperty->Font)+5);
  if (StrToInt(Edit->Text)< 15) Edit->Text= "15";
}

//---------------------------------------------------------------------
void __fastcall TWTSetWFForm::SBOkClick(TObject *Sender) {
  FieldProperty->FieldLength=StrToInt(Edit->Text);
  FieldProperty->Name=EName->Text;
  FieldProperty->ModFlag=true;
  FieldProperty->Font->Assign(DataFont);
  FieldProperty->BgColor=BgColor;
  FieldProperty->Align=AlignBox->ItemIndex;
  ModalResult= 1;
}
//---------------------------------------------------------------------------
#pragma package(smart_init)
