//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include <quickrpt.hpp>
#include <Qrctrls.hpp>
#include "SelFields.h"
#include "Defines.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TWTSelFields::TWTSelFields(TComponent* Owner,TWTDBGrid* DBGrid,AnsiString Name,AnsiString LoadName): TWTMDIWindow(Application) {

 if (!TableMenuItem->Items[4]->Checked) {
    WaitForm=new TWTWaitForm(this,"Формируется отчет","Images//QRMemo");
    WaitForm->StopEnabled=true;
    Application->MainForm->Enabled=false;
    WaitForm->Show();
  }

  OpenGlobal=false;
  /*if (LoadName[LoadName.Length()]=='0') {OpenGlobal=true;LoadName=LoadName.SubString(1,LoadName.Length()-1);}
  if (LoadName[LoadName.Length()]=='1') {OpenGlobal=false;LoadName=LoadName.SubString(1,LoadName.Length()-1);}
    */
      OpenGlobal=false;
  if (LoadName[LoadName.Length()]=='0')
  { OpenGlobal=true;
    LoadName=LoadName.SubString(1,LoadName.Length()-1);
     if (int p=LoadName.Pos("&")!=0)
   { AnsiString L1=LoadName.SubString(1,p-1);
     AnsiString L2=LoadName.SubString(p+1,LoadName.Length());
     LoadName=L1+L2;
   }
  }
  if (LoadName[LoadName.Length()]=='1')
   {OpenGlobal=false;
    LoadName=LoadName.SubString(1,LoadName.Length()-1);
    }
   if (int p=LoadName.Pos("&")!=0)
   { AnsiString L1=LoadName.SubString(1,p-1);
     AnsiString L2=LoadName.SubString(p+1,LoadName.Length());
     LoadName=L1+L2;
   }
  DefaultTitle=Name;

  DefaultTitle=Name;

  Application->ProcessMessages();
  FDBGrid=DBGrid;

  DefaultBgColor=clWhite;
  HeaderBgColor=clWhite;
  UpCFont=new TFont();
  DownCFont=new TFont();
  CurrentReport=LoadName;
  Width=430;
  Height=356;
  if (LoadName=="Default") SetCaption("Выбор полей для нового отчета");
  else SetCaption("Выбор полей для отчета <"+LoadName+">");
  BorderStyle=bsDialog;
  Position=poScreenCenter;
  Visible=false;
//  TGrpProperty* GP;
//  TWTFieldProperty* FP;
  MainQuery=new TZPgSqlQuery(this);
  TZDataset* DataSet;

  if (DBGrid->Table) {
    IsTable=true;
    DataSet=DBGrid->Table;
    MainQuery->Sql->Add("select * from " + DBGrid->Table->TableName);
  } else {
    IsTable=false;
    DataSet=DBGrid->Query;
    MainQuery->Sql->Assign(DBGrid->Query->Sql);
    MainQuery->Params->AssignValues(DBGrid->Query->Params);
  }
  for (int x=0;x<DataSet->FieldCount;x++) DuplicateField(DataSet->Fields->Fields[x],MainQuery);
  MainQuery->Database=(TZPgSqlDatabase *)DataSet->Database;
  MainQuery->Filter=DataSet->Filter;
  MainQuery->Filtered=DataSet->Filtered;
//  MainQuery->Open();

  Panel1=new TPanel(this);
  Panel1->Top=32;
  Panel1->Left=0;
  Panel1->Width=Width-6;
  Panel1->Height=Height-25-Panel1->Top;
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
  TSh3= new TTabSheet(this);
  TSh4= new TTabSheet(this);
  TSh5= new TTabSheet(this);
  TSh6= new TTabSheet(this);

  PageControl1= new TPageControl(this);
  PageControl1->Align=alClient;
  PageControl1->Parent= Panel1;

  TSh4->PageControl=PageControl1;
  TSh4->Caption="Поля";
  TSh1->PageControl=PageControl1;
  TSh1->Caption="Колонтитулы";
  TSh2->PageControl=PageControl1;
  TSh2->Caption="Дополнительно";
  TSh3->PageControl=PageControl1;
  TSh3->Caption="Внешний вид";

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Ok");*/

  SBOk=new TSpeedButton(this);
  SBOk->Glyph->LoadFromResourceName(0,"Ok");;
  SBOk->Caption="OK";
  SBOk->Width=70;
  SBOk->Height=25;
  SBOk->Top=8;
  SBOk->Left= 175;
  SBOk->Parent=Panel2;
  SBOk->OnClick= FOnClick;

//Создание колонтитулов
  PageControl2=new TPageControl(this);
  PageControl2->ActivePage = TSh5;
  PageControl2->Align = alClient;
  PageControl2->TabPosition = tpBottom;
  PageControl2->Parent=TSh1;

  TSh5->PageControl=PageControl2;
  TSh5->Caption="Верхний колонтитул";
  TSh6->PageControl=PageControl2;
  TSh6->Caption="Нижний колонтитул";

  Label=new TLabel(this);
  Label->Left = 258;
  Label->Top = 59;
  Label->Width = 49;
  Label->Height = 13;
  Label->Caption = "Интервал";
  Label->Parent=TSh5;

  Label=new TLabel(this);
  Label->Left = 202;
  Label->Top = 83;
  Label->Width = 105;
  Label->Height = 13;
  Label->Caption = "Ширина колонтитула";
  Label->Parent=TSh5;

  Label=new TLabel(this);
  Label->Left = 178;
  Label->Top = 107;
  Label->Width = 75;
  Label->Height = 13;
  Label->Caption = "Выравнивание";
  Label->Parent=TSh5;

  Bevel=new TBevel(this);
  Bevel->Left = 168;
  Bevel->Top = 46;
  Bevel->Width = 233;
  Bevel->Height = 107;
  Bevel->Shape = bsFrame;
  Bevel->Parent=TSh5;

  //TWTFontButton* UpCFontButton=
  new TWTFontButton(322,125,UpCFont,TSh5);

  Label=new TLabel(this);
  Label->Left = 243;
  Label->Top = 131;
  Label->Width = 71;
  Label->Height = 13;
  Label->Caption = "Шрифт текста";
  Label->Parent=TSh5;

  CBoxUp=new TCheckListBox(this);
  CBoxUp->Left = 0;
  CBoxUp->Top = 0;
  CBoxUp->Width = 115;
  CBoxUp->Height = 153;
  CBoxUp->ItemHeight = 13;
  CBoxUp->Parent=TSh5;
  CBoxUp->Items->Add("Дата");
  CBoxUp->Items->Objects[0]=new TWTString("");
  CBoxUp->Checked[0]=PAGEHEADER_ISDATA;
  CBoxUp->Items->Add("Время");
  CBoxUp->Items->Objects[1]=new TWTString("");
  CBoxUp->Checked[1]=PAGEHEADER_ISTIME;
  CBoxUp->Items->Add("Номер страницы");
  CBoxUp->Items->Objects[2]=new TWTString("");
  CBoxUp->Checked[2]=PAGEHEADER_ISPAGE;
  CBoxUp->Items->Add("Заголовок отчета");
  CBoxUp->Items->Objects[3]=new TWTString("");
  CBoxUp->Checked[3]=PAGEHEADER_ISTITLE;
  CBoxUp->Items->Add("Просто текст");
  CBoxUp->Items->Objects[4]=new TWTString("");
  CBoxUp->Checked[4]=PAGEHEADER_ISTEXT;
  CBoxUp->TabOrder = 0;
  CBoxUp->OnClickCheck=CBUpCheck;
  CBoxUp->OnDblClick=CBUpDblClick;

  Panel2=new TPanel(this);
  Panel2->Left=115;
  Panel2->Top=0;
  Panel2->Width=50;
  Panel2->Height=153;
  Panel2->Caption="";
  Panel2->Parent= TSh5;
  Panel2->BorderWidth=2;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Up");*/

  SBUpUp=new TSpeedButton(this);
  SBUpUp->Flat=true;
  SBUpUp->Glyph->LoadFromResourceName(0,"Up");
  SBUpUp->ShowHint=true;
  SBUpUp->Hint="Передвинуть поле вверх";
  SBUpUp->Width=24;
  SBUpUp->Height=24;
  SBUpUp->Top=10;
  SBUpUp->Enabled= true;
  SBUpUp->Left=13;
  SBUpUp->Parent=Panel2;
  SBUpUp->OnClick= FUpCOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Filter");*/

  SBPropUp=new TSpeedButton(this);
  SBPropUp->Flat=true;
  SBPropUp->Glyph->LoadFromResourceName(0,"RepProp");
  SBPropUp->ShowHint=true;
  SBPropUp->Hint="Подпись поля";
  SBPropUp->Width=24;
  SBPropUp->Height=24;
  SBPropUp->Top=34;
  SBPropUp->Enabled= true;
  SBPropUp->Left=13;
  SBPropUp->Parent=Panel2;
  SBPropUp->OnClick= CBUpDblClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Down");*/

  SBDownUp=new TSpeedButton(this);
  SBDownUp->Flat=true;
  SBDownUp->Glyph->LoadFromResourceName(0,"Down");
  SBDownUp->ShowHint=true;
  SBDownUp->Hint="Передвинуть поле вниз";
  SBDownUp->Width=24;
  SBDownUp->Height=24;
  SBDownUp->Top=58;
  SBDownUp->Enabled= true;
  SBDownUp->Left=13;
  SBDownUp->Parent=Panel2;
  SBDownUp->OnClick= FDownCOnClick;

  TextUp=new TEdit(this);
  TextUp->Left = 168;
  TextUp->Top = 22;
  TextUp->Width = 233;
  TextUp->Height = 21;
  TextUp->Color = clBtnFace;
  TextUp->ReadOnly = True;
  TextUp->TabOrder = 1;
  TextUp->Parent=TSh5;

  SEDistUp=new TCSpinEdit(this);
  SEDistUp->Left = 314;
  SEDistUp->Top = 51;
  SEDistUp->Width = 81;
  SEDistUp->Height = 22;
  SEDistUp->TabStop = True;
  SEDistUp->MaxValue = 1000;
  SEDistUp->ParentColor = False;
  SEDistUp->EditorEnabled = false;
  SEDistUp->TabOrder = 2;
  SEDistUp->Value = 10;
  SEDistUp->Parent=TSh5;

  SEHeightUp=new TCSpinEdit(this);
  SEHeightUp->Left = 314;
  SEHeightUp->Top = 75;
  SEHeightUp->Width = 81;
  SEHeightUp->Height = 22;
  SEHeightUp->TabStop = True;
  SEHeightUp->MaxValue = 1000;
  SEHeightUp->ParentColor = False;
  SEHeightUp->EditorEnabled = false;
  SEHeightUp->TabOrder = 3;
  SEHeightUp->Value = 0;
  SEHeightUp->Parent=TSh5;

  ComboUp=new TComboBox(this);
  ComboUp->Left = 256;
  ComboUp->Top = 99;
  ComboUp->Width = 139;
  ComboUp->Height = 21;
  ComboUp->ItemHeight = 13;
  ComboUp->Parent=TSh5;
  ComboUp->Items->Add("По левому краю");
  ComboUp->Items->Add("По правому краю");
  ComboUp->Items->Add("По центру");
  ComboUp->TabOrder = 4;
  ComboUp->ItemIndex=PAGEHEADER_ALIGN;

  CBUp=new TCheckBox(this);
  CBUp->Left = 168;
  CBUp->Top = 0;
  CBUp->Width = 209;
  CBUp->Height = 17;
  CBUp->Caption = "отображать колонтитул";
  CBUp->TabOrder = 5;
  CBUp->Parent=TSh5;
  CBUp->Checked=PAGEHEADER_ENABLED;

//Создание нижнего колонтитула
  Label=new TLabel(this);
  Label->Left = 258;
  Label->Top = 59;
  Label->Width = 49;
  Label->Height = 13;
  Label->Caption = "Интервал";
  Label->Parent=TSh6;

  Label=new TLabel(this);
  Label->Left = 202;
  Label->Top = 83;
  Label->Width = 105;
  Label->Height = 13;
  Label->Caption = "Ширина колонтитула";
  Label->Parent=TSh6;

  Label=new TLabel(this);
  Label->Left = 178;
  Label->Top = 107;
  Label->Width = 75;
  Label->Height = 13;
  Label->Caption = "Выравнивание";
  Label->Parent=TSh6;

  Bevel=new TBevel(this);
  Bevel->Left = 168;
  Bevel->Top = 46;
  Bevel->Width = 233;
  Bevel->Height = 107;
  Bevel->Shape = bsFrame;
  Bevel->Parent=TSh6;

  //TWTFontButton* DownCFontButton=
  new TWTFontButton(322,125,DownCFont,TSh6);

  Label=new TLabel(this);
  Label->Left = 243;
  Label->Top = 131;
  Label->Width = 71;
  Label->Height = 13;
  Label->Caption = "Шрифт текста";
  Label->Parent=TSh6;

  CBoxDown=new TCheckListBox(this);
  CBoxDown->Left = 0;
  CBoxDown->Top = 0;
  CBoxDown->Width = 115;
  CBoxDown->Height = 153;
  CBoxDown->ItemHeight = 13;
  CBoxDown->Parent=TSh6;
  CBoxDown->Items->Add("Дата");
  CBoxDown->Items->Objects[0]=new TWTString("");
  CBoxDown->Checked[0]=PAGEFOOTER_ISDATA;
  CBoxDown->Items->Add("Время");
  CBoxDown->Items->Objects[1]=new TWTString("");
  CBoxDown->Checked[1]=PAGEFOOTER_ISTIME;
  CBoxDown->Items->Add("Номер страницы");
  CBoxDown->Items->Objects[2]=new TWTString("");
  CBoxDown->Checked[2]=PAGEFOOTER_ISPAGE;
  CBoxDown->Items->Add("Заголовок отчета");
  CBoxDown->Items->Objects[3]=new TWTString("");
  CBoxDown->Checked[3]=PAGEFOOTER_ISTITLE;
  CBoxDown->Items->Add("Просто текст");
  CBoxDown->Items->Objects[4]=new TWTString("");
  CBoxDown->Checked[4]=PAGEFOOTER_ISTEXT;
  CBoxDown->TabOrder = 0;
  CBoxDown->OnClickCheck=CBDownCheck;
  CBoxDown->OnDblClick=CBDownDblClick;

  Panel2=new TPanel(this);
  Panel2->Left=115;
  Panel2->Top=0;
  Panel2->Width=50;
  Panel2->Height=153;
  Panel2->Caption="";
  Panel2->Parent= TSh6;
  Panel2->BorderWidth=2;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Up");*/

  SBUpDown=new TSpeedButton(this);
  SBUpDown->Flat=true;
  SBUpDown->Glyph->LoadFromResourceName(0,"Up");
  SBUpDown->ShowHint=true;
  SBUpDown->Hint="Передвинуть поле вверх";
  SBUpDown->Width=24;
  SBUpDown->Height=24;
  SBUpDown->Top=10;
  SBUpDown->Enabled= true;
  SBUpDown->Left=13;
  SBUpDown->Parent=Panel2;
  SBUpDown->OnClick= FUpCOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Filter");*/

  SBPropDown=new TSpeedButton(this);
  SBPropDown->Flat=true;
  SBPropDown->Glyph->LoadFromResourceName(0,"RepProp");
  SBPropDown->ShowHint=true;
  SBPropDown->Hint="Подпись поля";
  SBPropDown->Width=24;
  SBPropDown->Height=24;
  SBPropDown->Top=34;
  SBPropDown->Enabled= true;
  SBPropDown->Left=13;
  SBPropDown->Parent=Panel2;
  SBPropDown->OnClick= CBDownDblClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Down");*/

  SBDownDown=new TSpeedButton(this);
  SBDownDown->Flat=true;
  SBDownDown->Glyph->LoadFromResourceName(0,"Down");
  SBDownDown->ShowHint=true;
  SBDownDown->Hint="Передвинуть поле вниз";
  SBDownDown->Width=24;
  SBDownDown->Height=24;
  SBDownDown->Top=58;
  SBDownDown->Enabled= true;
  SBDownDown->Left=13;
  SBDownDown->Parent=Panel2;
  SBDownDown->OnClick= FDownCOnClick;

  TextDown=new TEdit(this);
  TextDown->Left = 168;
  TextDown->Top = 22;
  TextDown->Width = 233;
  TextDown->Height = 21;
  TextDown->Color = clBtnFace;
  TextDown->ReadOnly = True;
  TextDown->TabOrder = 1;
  TextDown->Parent=TSh6;

  SEDistDown=new TCSpinEdit(this);
  SEDistDown->Left = 314;
  SEDistDown->Top = 51;
  SEDistDown->Width = 81;
  SEDistDown->Height = 22;
  SEDistDown->TabStop = True;
  SEDistDown->MaxValue = 1000;
  SEDistDown->ParentColor = False;
  SEDistDown->EditorEnabled = false;
  SEDistDown->TabOrder = 2;
  SEDistDown->Value = 10;
  SEDistDown->Parent=TSh6;

  SEHeightDown=new TCSpinEdit(this);
  SEHeightDown->Left = 314;
  SEHeightDown->Top = 75;
  SEHeightDown->Width = 81;
  SEHeightDown->Height = 22;
  SEHeightDown->TabStop = True;
  SEHeightDown->MaxValue = 1000;
  SEHeightDown->ParentColor = False;
  SEHeightDown->EditorEnabled = false;
  SEHeightDown->TabOrder = 3;
  SEHeightDown->Value = 0;
  SEHeightDown->Parent=TSh6;

  ComboDown=new TComboBox(this);
  ComboDown->Left = 256;
  ComboDown->Top = 99;
  ComboDown->Width = 139;
  ComboDown->Height = 21;
  ComboDown->ItemHeight = 13;
  ComboDown->Parent=TSh5;
  ComboDown->Items->Add("По левому краю");
  ComboDown->Items->Add("По правому краю");
  ComboDown->Items->Add("По центру");
  ComboDown->TabOrder = 4;
  ComboDown->ItemIndex=PAGEFOOTER_ALIGN;
  ComboDown->Parent=TSh6;

  CBDown=new TCheckBox(this);
  CBDown->Left = 168;
  CBDown->Top = 0;
  CBDown->Width = 209;
  CBDown->Height = 17;
  CBDown->Caption = "отображать колонтитул";
  CBDown->TabOrder = 5;
  CBDown->Parent=TSh6;
  CBDown->Checked=PAGEFOOTER_ENABLED;
//Создание редактора полей
  TGb= new TGroupBox(this);
  TGb->Left = 5;
  TGb->Top = 5;
  TGb->Width = 217;
  TGb->Height = 65;
  TGb->Caption = "Бумага";
  TGb->Parent= TSh2;

  Label= new TLabel(this);
  Label->Left= 11;
  Label->Top= 24;
  Label->Width= 45;
  Label->Height= 13;
  Label->Caption= "Размер: ";
  Label->Parent= TGb;

  TCb= new TComboBox(this);
  TCb->Left = 70;
  TCb->Top = 28;
  TCb->Width = 142;
  TCb->Height = 21;
  TCb->Parent= TSh2;
  TCb->Items->Add("А4 210 х 297 мм");
  TCb->Items->Add("А3 297 х 420 мм");
  TCb->Text= "А4 210 х 297 мм";

  TRg1= new TRadioGroup(this);
  TRg1->Left = 230;
  TRg1->Top = 5;
  TRg1->Width = 178;
  TRg1->Height = 65;
  TRg1->Caption = "Ориентация";
  TRg1->Parent= TSh2;
  TRg1->Items->Add("Книжная");
  TRg1->Items->Add("Альбомная");
  TRg1->ItemIndex= 0;

  TRg2= new TRadioGroup(this);
  TRg2->Left = 5;
  TRg2->Top = 75;
  TRg2->Width = 403;
  TRg2->Height = 85;
  TRg2->Caption = "Размещение полей на листе";
  TRg2->Parent= TSh2;
  TRg2->Items->Add("Игнорировать, если не помещаются");
  TRg2->Items->Add("Не отоброжать лишние поля");
  TRg2->Items->Add("Выровнять по ширине");
  TRg2->ItemIndex = COLUMNS_VIEW_STYLE;

  Bevel=new TBevel(this);
  Bevel->Left=5;
  Bevel->Top=168;
  Bevel->Width=403;
  Bevel->Height=57;
  Bevel->Shape=bsFrame;
  Bevel->Parent=TSh2;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Font");*/

  CheckBox=new TCheckBox(this);
  CheckBox->Top=178;
  CheckBox->Left=13;
  CheckBox->Width=200;
  CheckBox->Caption="Автоопределение ширины полей";
  CheckBox->Parent=TSh2;

  Label= new TLabel(this);
  Label->AutoSize=true;
  Label->Top= 200;
  Label->Caption= "Отступ для колонок отчета";
  Label->Left= 13;
  Label->Parent= TSh2;

  SEOtst=new TCSpinEdit(this);
  SEOtst->Left = Label->Left+Label->Width+5;
  SEOtst->Top = 197;
  SEOtst->Width = 74;
  SEOtst->Height = 22;
  SEOtst->TabStop = True;
  SEOtst->EditorEnabled = False;
  SEOtst->MaxValue = 1000;
  SEOtst->MinValue = 0;
  SEOtst->TabOrder = 2;
  SEOtst->Value=0;
  SEOtst->Parent=TSh2;

  GBox= new TGroupBox(this);
  GBox->Left = 5;
  GBox->Top = 5;
  GBox->Width = 403;
  GBox->Height = 96;
  GBox->Caption = "Общее";
  GBox->Parent= TSh3;

  DefaultFont=new TFont();
  HeaderFont=new TFont();
  HeaderFont->Size=12;
  HeaderFont->Style=HeaderFont->Style << fsBold;

  NameFont=new TFont();
  NameFont->Size=16;
  NameFont->Style=HeaderFont->Style << fsBold;

  //TWTFontButton* DefFontButton=
  new TWTFontButton(320,67,DefaultFont,GBox);
  //TWTColorButton* DefBgColorButton=
  new TWTColorButton(242,67,DefaultBgColor,GBox);

  //TWTFontButton* HeaderFontButton=
  new TWTFontButton(320,40,HeaderFont,GBox);
  //TWTColorButton* HeaderBgColorButton=
  new TWTColorButton(242,40,HeaderBgColor,GBox);

  TWTFontButton* TitleFontButton=new TWTFontButton(320,13,NameFont,GBox);

  NEdit=new TEdit(this);
  NEdit->Top=13;
  NEdit->Width=250;
  NEdit->Height=22;
  NEdit->Parent=GBox;
  NEdit->Text="";
  NEdit->Left=TitleFontButton->Left-5-NEdit->Width;

  TLabel* LL=new TLabel(this);
  LL->AutoSize=true;
  LL->Top=70;
  LL->Parent=GBox;
  LL->Caption="Стандартные параметры для данных";
  LL->Left=TitleFontButton->Left-LL->Width-5-78;

  LL=new TLabel(this);
  LL->AutoSize=true;
  LL->Top=43;
  LL->Parent=GBox;
  LL->Caption="Стандартные параметры для заголовков";
  LL->Left=TitleFontButton->Left-LL->Width-5-78;

  LL=new TLabel(this);
  LL->AutoSize=true;
  LL->Top=16;
  LL->Parent=GBox;
  LL->Caption="Заголовок";
  LL->Left=NEdit->Left-LL->Width-5;

  GrpSource= new TListBox(this);
  GrpSource->Align= alLeft;
  GrpSource->Width= 180;
  GrpSource->MultiSelect= true;
  GrpSource->Parent= TSh4;
  GrpSource->Font->Style= GrpSource->Font->Style << fsBold;

  for(int i=0; i<DBGrid->FieldCount; i++) {
    TWTFieldProperty* FP=new TWTFieldProperty(DBGrid->Columns->Items[i]->Width,MainQuery->FieldByName(DBGrid->Columns->Items[i]->FieldName),DBGrid->Columns->Items[i]->Title->Caption);
    FP->Field->Tag=i;
    if ((FP->Field->DataType==ftString || FP->Field->DataType==ftFixedChar || FP->Field->DataType==ftWideString) && FP->Field->DataSize<10) FP->Align=2;
    if (FP->Field->FieldKind==fkLookup) FP->Align=1;
    if (CheckParent(FP->Field,"TNumericField")) FP->Align=1;
    if (IsTable)
        GrpSource->Items->AddObject(DBGrid->ListComment->Strings[i],FP);
    else
        GrpSource->Items->AddObject(DBGrid->ListComment->Strings[i],FP);
  }

  Panel3=new TPanel(this);
  Panel3->Left=400;
  Panel3->Align=alLeft;
  Panel3->Width=50;
  Panel3->BevelInner=bvNone;
  Panel3->BevelOuter=bvLowered;
  Panel3->Caption="";
  Panel3->Parent=TSh4;

  Bevel=new TBevel(this);
  Bevel->Width=100;
  Bevel->Height=82;
  Bevel->Top=87;
  Bevel->Left=8;
  Bevel->Shape=bsFrame;
  Bevel->Parent=Panel3;

  GrpDest= new TTreeView(this);
  GrpDest->Align= alClient;
  GrpDest->Parent= TSh4;
  GrpDest->HideSelection=false;
  GrpDest->Font->Style=GrpDest->Font->Style << fsBold;
  GrpDest->Font->Color=clRed;
  GrpDest->OnDblClick= GrpDestDblClick;
  GrpDest->OnChange=OnChangeGrp;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Lock");*/

  SBLock=new TSpeedButton(this);
  SBLock->Flat=true;
  SBLock->Glyph->LoadFromResourceName(0,"Lock");
  SBLock->ShowHint=true;
  SBLock->Hint="Добавлять поля в группу если разомкнуто";
  SBLock->Width=24;
  SBLock->Height=24;
  SBLock->Top=10;
  SBLock->Enabled= false;
  SBLock->Left=13;
  SBLock->Parent=Panel3;
  SBLock->OnClick= FLockOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Up");*/

  SBUp=new TSpeedButton(this);
  SBUp->Flat=true;
  SBUp->Glyph->LoadFromResourceName(0,"Up");
  SBUp->ShowHint=true;
  SBUp->Hint="Передвинуть поле (группу) вверх";
  SBUp->Width=24;
  SBUp->Height=24;
  SBUp->Top=92;
  SBUp->Enabled= false;
  SBUp->Left=18;
  SBUp->Parent=Panel3;
  SBUp->OnClick= FUpOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Filter");*/

  SBProp=new TSpeedButton(this);
  SBProp->Flat=true;
  SBProp->Glyph->LoadFromResourceName(0,"RepProp");
  SBProp->ShowHint=true;
  SBProp->Hint="Свойства поля (группы)";
  SBProp->Width=24;
  SBProp->Height=24;
  SBProp->Top=116;
  SBProp->Enabled= false;
  SBProp->Left=18;
  SBProp->Parent=Panel3;
  SBProp->OnClick= GrpDestDblClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Down");*/

  SBDown=new TSpeedButton(this);
  SBDown->Flat=true;
  SBDown->Glyph->LoadFromResourceName(0,"Down");
  SBDown->ShowHint=true;
  SBDown->Hint="Передвинуть поле (группу) вниз";
  SBDown->Width=24;
  SBDown->Height=24;
  SBDown->Top=140;
  SBDown->Enabled= false;
  SBDown->Left=18;
  SBDown->Parent=Panel3;
  SBDown->OnClick= FDownOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Add");*/

  SBAddGrp=new TSpeedButton(this);
  SBAddGrp->Flat=true;
  SBAddGrp->Glyph->LoadFromResourceName(0,"Add");
  SBAddGrp->ShowHint=true;
  SBAddGrp->Hint="Добавить все поля в группу (в новую группу)";
  SBAddGrp->Width=24;
  SBAddGrp->Height=24;
  SBAddGrp->Top=34;
  SBAddGrp->Enabled= true;
  SBAddGrp->Left=13;
  SBAddGrp->Parent=Panel3;
  SBAddGrp->OnClick= FAddGrpOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"AddAll");*/

  SBAddField=new TSpeedButton(this);
  SBAddField->Flat=true;
  SBAddField->Glyph->LoadFromResourceName(0,"AddAll");
  SBAddField->ShowHint=true;
  SBAddField->Hint="Добавить выделенные поля в группу (в новую группу)";
  SBAddField->Width=24;
  SBAddField->Height=24;
  SBAddField->Top=58;
  SBAddField->Left=13;
  SBAddField->Enabled= true;
  SBAddField->Parent=Panel3;
  SBAddField->OnClick= FAddFieldOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Rem");*/

  SBDelGrp=new TSpeedButton(this);
  SBDelGrp->Flat=true;
  SBDelGrp->Glyph->LoadFromResourceName(0,"Rem");
  SBDelGrp->ShowHint=true;
  SBDelGrp->Hint="Удалить поле (группу)";
  SBDelGrp->Width=24;
  SBDelGrp->Height=24;
  SBDelGrp->Top=174;
  SBDelGrp->Left=13;
  SBDelGrp->Parent=Panel3;
  SBDelGrp->Enabled= false;
  SBDelGrp->OnClick= FDelGrpOnClick;

/*  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"RemAll");*/

  SBDelField=new TSpeedButton(this);
  SBDelField->Flat=true;
  SBDelField->Glyph->LoadFromResourceName(0,"RemAll");
  SBDelField->ShowHint=true;
  SBDelField->Hint="Удалить все группы";
  SBDelField->Width=24;
  SBDelField->Height=24;
  SBDelField->Top=198;
  SBDelField->Left=13;
  SBDelField->Parent=Panel3;
  SBDelField->Enabled= false;
  SBDelField->OnClick= FDelFieldOnClick;

  if (!GrpSource->Items->Count) {
    SBAddGrp->Enabled=false;
    SBAddField->Enabled=false;
  }

  AddButton("DeleteSh", "Удалить текущий отчет", DeleteReport);
  AddButton("SaveFilter", "Сохранить текущий отчет", SaveReport);

  Locked=true;
  AllFlag=true;
//  if (LoadName!="Default") {
    LoadReport(LoadName);
  if (LoadName!="Default")
    if (!TableMenuItem->Items[4]->Checked) ReportPrint();
//  }
//  FormStyle=fsMDIChild;
}

//---------------------------------------------------------------------------
__fastcall TWTSelFields::~TWTSelFields() {
//  return;
  for (int i=0;i<GrpDest->Items->Count;i++) {
    if (GrpDest->Items->Item[i]->Level==0) delete GrpDest->Items->Item[i]->Data;
  }
  for ( int i=0;i<GrpSource->Items->Count;i++) {
    delete GrpSource->Items->Objects[i];
  }
  for ( int i=0;i<CBoxUp->Items->Count;i++) {
     delete CBoxUp->Items->Objects[i];
     delete CBoxDown->Items->Objects[i];
  }
  delete DefaultFont;
  delete HeaderFont;
  delete UpCFont;
  delete DownCFont;
  if (ReportMenuItem->Count>0) ReportMenuItem->Enabled=true;

}
//---------------------------------------------------------------------------

//Возвращает индекс для вставки полей обратно в SrcSource для соблюдения порядка
int __fastcall TWTSelFields::GetIndexToInsert(TWTFieldProperty *FieldDesc){
  int x=0;
  if (!GrpSource->Items->Count) return 0;
  while (((TWTFieldProperty*)GrpSource->Items->Objects[x])->Field->Tag<FieldDesc->Field->Tag) {
    x++;
    if (x==GrpSource->Items->Count) break;
  }
  return x;
}


//Функции для работы с колонтитулами
void __fastcall TWTSelFields::CBDownDblClick(TObject *Sender){
  if (CBoxDown->ItemIndex==-1) {
    CBoxDown->ItemIndex=0;
    return;
  }
  TWTString* String=((TWTString*)CBoxDown->Items->Objects[CBoxDown->ItemIndex]);
  String->String=InputBox("Изменение текста","Новое значение",String->String);
  UpdateText(CBoxDown);
}

void __fastcall TWTSelFields::CBUpDblClick(TObject *Sender){
  if (CBoxUp->ItemIndex==-1) {
    CBoxUp->ItemIndex=0;
    return;
  }
  TWTString* String=((TWTString*)CBoxUp->Items->Objects[CBoxUp->ItemIndex]);
  String->String=InputBox("Изменение текста","Новое значение",String->String);
  UpdateText(CBoxUp);
}

void __fastcall TWTSelFields::CBDownCheck(TObject *Sender){
  TCheckListBox* CLB=(TCheckListBox*)Sender;
  bool Flag=false;
  UpdateText(CLB);
  for (int x=0;x<CLB->Items->Count;x++) if (CLB->Checked[x]) Flag=true;
  if (Flag && CLB->Checked[CLB->ItemIndex]) CBDown->Checked=true;
  if (!Flag) CBDown->Checked=false;
}

void __fastcall TWTSelFields::CBUpCheck(TObject *Sender){
  TCheckListBox* CLB=(TCheckListBox*)Sender;
  bool Flag=false;
  UpdateText(CLB);
  for (int x=0;x<CLB->Items->Count;x++) if (CLB->Checked[x]) Flag=true;
  if (Flag && CLB->Checked[CLB->ItemIndex]) CBUp->Checked=true;
  if (!Flag) CBUp->Checked=false;
}

void TWTSelFields::UpdateText(TCheckListBox* CLBox){
  AnsiString Text="";
  for (int x=0;x<CLBox->Items->Count;x++) {
    if (CLBox->Checked[x]) {
      if (CLBox->Items->Strings[x]=="Просто текст") Text=Text+((TWTString*)CLBox->Items->Objects[x])->String+" ";
      else Text=Text+((TWTString*)CLBox->Items->Objects[x])->String+" <"+CLBox->Items->Strings[x]+"> ";
    }
  }
  if (CLBox==CBoxUp) {
    TextUp->Text=Text;
  }
  else {
    TextDown->Text=Text;
  }
}

void __fastcall TWTSelFields::FUpCOnClick(TObject *Sender){
  TCheckListBox* CBBox;
  TObject* String;
  AnsiString AString;
  bool Checked;
  if (Sender==SBUpUp) CBBox=CBoxUp;
  else CBBox=CBoxDown;
  if (CBBox->ItemIndex<1) {
    CBBox->ItemIndex=0;
    return;
  }
  AString=CBBox->Items->Strings[CBBox->ItemIndex];
  String=CBBox->Items->Objects[CBBox->ItemIndex];
  Checked=CBBox->Checked[CBBox->ItemIndex];
  CBBox->Items->Strings[CBBox->ItemIndex]=CBBox->Items->Strings[CBBox->ItemIndex-1];
  CBBox->Items->Objects[CBBox->ItemIndex]=CBBox->Items->Objects[CBBox->ItemIndex-1];
  CBBox->Checked[CBBox->ItemIndex]=CBBox->Checked[CBBox->ItemIndex-1];
  CBBox->Items->Strings[CBBox->ItemIndex-1]=AString;
  CBBox->Items->Objects[CBBox->ItemIndex-1]=String;
  CBBox->Checked[CBBox->ItemIndex-1]=Checked;
  CBBox->ItemIndex--;
  UpdateText(CBBox);
}

void __fastcall TWTSelFields::FDownCOnClick(TObject *Sender){
  TCheckListBox* CBBox;
  TObject* String;
  AnsiString AString;
  bool Checked;
  if (Sender==SBDownUp) CBBox=CBoxUp;
  else CBBox=CBoxDown;
  if (CBBox->ItemIndex==-1) {
    CBBox->ItemIndex=0;
    return;
  }
  if (CBBox->ItemIndex==CBBox->Items->Count-1) {
    return;
  }
  AString=CBBox->Items->Strings[CBBox->ItemIndex];
  String=CBBox->Items->Objects[CBBox->ItemIndex];
  Checked=CBBox->Checked[CBBox->ItemIndex];
  CBBox->Items->Strings[CBBox->ItemIndex]=CBBox->Items->Strings[CBBox->ItemIndex+1];
  CBBox->Items->Objects[CBBox->ItemIndex]=CBBox->Items->Objects[CBBox->ItemIndex+1];
  CBBox->Checked[CBBox->ItemIndex]=CBBox->Checked[CBBox->ItemIndex+1];
  CBBox->Items->Strings[CBBox->ItemIndex+1]=AString;
  CBBox->Items->Objects[CBBox->ItemIndex+1]=String;
  CBBox->Checked[CBBox->ItemIndex+1]=Checked;
  CBBox->ItemIndex++;
  UpdateText(CBBox);
}

//конец функций для работы с колонтитулами

void __fastcall TWTSelFields::FLockOnClick(TObject *Sender){
  if (Locked) SBLock->Glyph->LoadFromResourceName(0,"Unlock");
  else SBLock->Glyph->LoadFromResourceName(0,"Lock");
  Locked=!Locked;
}

//---------------------------------------------------------------------------
void __fastcall TWTSelFields::FOnClick(TObject *Sender) {
//  Hide();
  ReportPrint();
//  Close();
}

//---------------------------------------------------------------------------
void __fastcall TWTSelFields::SaveReport(TObject *Sender) {

  TModalResult MR;
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbOK << mbIgnore << mbCancel;

  AnsiString ss=CurrentReport;
  TWTFieldProperty* FP;
  TGrpProperty* GP;
  int y=0;
//  int x;
  int z;
  AnsiString ReportID;
  TMemIniFile *IF=((TWTMainForm*)Application->MainForm)->IniFile;

  int NumID;
  ReportID=FDBGrid->GetID();

  TStringList* SL=new TStringList();
  do {
    MR=mrCancel;
    if (!InputQuery("Сохранение отчета","Введите имя отчета",ss)) return;
    IF->ReadSection("ReportsID\\"+ReportID,SL);
    if (SL->IndexOf(ss)!=-1) {
      if (CurrentReport!=ss)
         MR=MessageDlg("Отчет с таким именем уже существует.", mtWarning,DB, 0);
      else
         MR=mrIgnore;
      if (MR==mrCancel) return;
    }
  } while (MR==mrOk);
  delete SL;

  CurrentReport=ss;
  if (ss=="Default")  SetCaption("Выбор полей для нового отчета");
  else SetCaption("Выбор полей для отчета <"+ss+">");

  if (ReportID=="") {
    NumID=((TWTMainForm*)Application->MainForm)->GlobalIniFile->ReadInteger("Variables","NextTable",0);
    NumID++;
    ((TWTMainForm*)Application->MainForm)->GlobalIniFile->WriteInteger("Variables","NextTable",NumID);
    ReportID="Table["+IntToStr(NumID)+"]";
    ((TWTMainForm*)Application->MainForm)->GlobalIniFile->WriteString("Tables",FDBGrid->GetAlias(),ReportID);
  }

  ((TWTMainForm*)Application->MainForm)->IniFile->WriteString("ReportsID\\"+ReportID,ss,"");
//  UpdateIniFile(IF);

  AnsiString sss=ss;
  ss="Отчеты\\"+ReportID+"\\"+ss;
  IF->EraseSection(ss);
  IF->WriteString(ss,"Name",NEdit->Text);
  FontToIni(NameFont,IF,ss,"NameFont");
  FontToIni(DefaultFont,IF,ss,"DefaultFont");
  FontToIni(HeaderFont,IF,ss,"HeaderFont");
  IF->WriteString(ss,"Paper.Size",TCb->Text);
  IF->WriteInteger(ss,"Paper.Orientation",TRg1->ItemIndex);
  IF->WriteInteger(ss,"Fields.Place",TRg2->ItemIndex);
  IF->WriteInteger(ss,"AutoWide",CheckBox->Checked);
  IF->WriteInteger(ss,"DefaultBgColor",DefaultBgColor);
  IF->WriteInteger(ss,"HeaderBgColor",HeaderBgColor);
  IF->WriteInteger(ss,"DataOtst",SEOtst->Value);

  IF->WriteInteger(ss,"Up.IsUp",CBUp->Checked);
  IF->WriteInteger(ss,"Up.Dist",SEDistUp->Value);
  IF->WriteInteger(ss,"Up.Height",SEHeightUp->Value);
  IF->WriteInteger(ss,"Up.Align",ComboUp->ItemIndex);
  FontToIni(UpCFont,IF,ss,"Up.Font");
  IF->WriteInteger(ss,"Down.IsUp",CBDown->Checked);
  IF->WriteInteger(ss,"Down.Dist",SEDistDown->Value);
  IF->WriteInteger(ss,"Down.Height",SEHeightDown->Value);
  IF->WriteInteger(ss,"Down.Align",ComboDown->ItemIndex);
  FontToIni(DownCFont,IF,ss,"Down.Font");

  for (int i=0;i<CBoxUp->Items->Count;i++) {
    IF->WriteInteger(ss,"Up["+IntToStr(i)+"].Checked",CBoxUp->Checked[i]);
    IF->WriteString(ss,"Up["+IntToStr(i)+"].Name",CBoxUp->Items->Strings[i]);
    IF->WriteString(ss,"Up["+IntToStr(i)+"].Value",((TWTString*)CBoxUp->Items->Objects[i])->String);
    IF->WriteInteger(ss,"Down["+IntToStr(i)+"].Checked",CBoxDown->Checked[i]);
    IF->WriteString(ss,"Down["+IntToStr(i)+"].Name",CBoxDown->Items->Strings[i]);
    IF->WriteString(ss,"Down["+IntToStr(i)+"].Value",((TWTString*)CBoxDown->Items->Objects[i])->String);
  }
  for (z=0;z<GrpDest->Items->Count;z++) {
    if (GrpDest->Items->Item[z]->Level==0) {
      y++;
      GP=(TGrpProperty*)GrpDest->Items->Item[z]->Data;
      FontToIni(GP->CaptFont,IF,ss,"Group["+IntToStr(y-1)+"].CaptFont");
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].BgColor",GP->BgColor);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].Otst",GP->Otst);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].Dist",GP->Dist);
      IF->WriteString(ss,"Group["+IntToStr(y-1)+"].IName",GP->IName);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].Enabled",GP->Enabled);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].Kind",GP->Kind);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].IsName",GP->IsName);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].IsValue",GP->IsValue);
      IF->WriteString(ss,"Group["+IntToStr(y-1)+"].Function",GP->Function);
      IF->WriteInteger(ss,"Group["+IntToStr(y-1)+"].ResultsCount",GP->Fields->Count);
      for (int num=0;num<GP->Fields->Count;num++) {
        IF->WriteString(ss,"Group["+IntToStr(y-1)+"].Results["+IntToStr(num)+"].Field",((TField*)GP->Fields->Items[num])->FieldName);
      }
    }
    else {
      FP=(TWTFieldProperty*)GrpDest->Items->Item[z]->Data;
      IF->WriteInteger(ss,"Field["+IntToStr(z-y)+"].Level",y-1);
      IF->WriteString(ss,"Field["+IntToStr(z-y)+"]",((TWTFieldProperty*)GrpDest->Items->Item[z]->Data)->Field->FieldName);
      IF->WriteString(ss,"Field["+IntToStr(z-y)+"].Name",FP->Name);
      IF->WriteInteger(ss,"Field["+IntToStr(z-y)+"].Wide",FP->FieldLength);
      IF->WriteInteger(ss,"Field["+IntToStr(z-y)+"].BgColor",FP->BgColor);
      IF->WriteInteger(ss,"Field["+IntToStr(z-y)+"].Modification",FP->ModFlag);
      IF->WriteInteger(ss,"Field["+IntToStr(z-y)+"].Align",FP->Align);
      FontToIni(FP->Font,IF,ss,"Field["+IntToStr(z-y)+"].Font");
    }
  }
  IF->WriteInteger(ss,"FieldsCount",z-y);
  ((TWTMainForm*)Application->MainForm)->IniFile->UpdateFile();
  ((TWTMainForm*)Application->MainForm)->GlobalIniFile->UpdateFile();
/*  if (MR!=mrIgnore) {
    Graphics::TBitmap* BM=new Graphics::TBitmap();
    BM->LoadFromResourceName(0,"Report");

    TMenuItem* MI=CreateMenuItem(sss.c_str(),true,((TWTMainForm*)MainForm)->LoadReport,"");
    MI->Bitmap=BM;
    ReportMenuItem->Insert(ReportMenuItem->Count-1,MI);
  } */
}

void __fastcall TWTSelFields::LoadReport(AnsiString LoadName) {
  AnsiString ReportID="";

//  int NumID;
  ReportID=FDBGrid->GetID();

  LoadName="Отчеты\\"+ReportID+"\\"+LoadName;
  TMemIniFile *IF;
  if (!OpenGlobal) IF=((TWTMainForm*)Application->MainForm)->IniFile;
  else IF=((TWTMainForm*)Application->MainForm)->GlobalIniFile;
  AnsiString Result;
  TWTFieldProperty* FP;
  TGrpProperty* GP;
  TField* Field=NULL;
  int Level;
  int PrevLevel=-1;
  int i;
  int ResultsCount;
  int FieldsCount=IF->ReadInteger(LoadName,"FieldsCount",0);
  if (FieldsCount==0) return;
  IniToFont(DefaultFont,IF,LoadName,"DefaultFont");
  IniToFont(HeaderFont,IF,LoadName,"HeaderFont");
  NEdit->Text=IF->ReadString(LoadName,"Name","");
  IniToFont(NameFont,IF,LoadName,"NameFont");
  TCb->Text=IF->ReadString(LoadName,"Paper.Size","");
  TRg1->ItemIndex=IF->ReadInteger(LoadName,"Paper.Orientation",0);
  TRg2->ItemIndex=IF->ReadInteger(LoadName,"Fields.Place",0);
  CheckBox->Checked=IF->ReadInteger(LoadName,"AutoWide",0);
  DefaultBgColor = TColor(IF->ReadInteger(LoadName,"DefaultBgColor",0));
  HeaderBgColor = TColor(IF->ReadInteger(LoadName,"HeaderBgColor",0));
  SEOtst->Value=IF->ReadInteger(LoadName,"DataOtst",0);

  CBUp->Checked=IF->ReadInteger(LoadName,"Up.IsUp",0);
  SEDistUp->Value=IF->ReadInteger(LoadName,"Up.Dist",10);
  SEHeightUp->Value=IF->ReadInteger(LoadName,"Up.Height",10);
  ComboUp->ItemIndex=IF->ReadInteger(LoadName,"Up.Align",0);
  IniToFont(UpCFont,IF,LoadName,"Up.Font");
  CBDown->Checked=IF->ReadInteger(LoadName,"Down.IsUp",0);
  SEDistDown->Value=IF->ReadInteger(LoadName,"Down.Dist",10);
  SEHeightDown->Value=IF->ReadInteger(LoadName,"Down.Height",10);
  ComboDown->ItemIndex=IF->ReadInteger(LoadName,"Down.Align",0);
  IniToFont(DownCFont,IF,LoadName,"Down.Font");

  for (i=0;i<CBoxUp->Items->Count;i++) {
    CBoxUp->Items->Strings[i]=IF->ReadString(LoadName,"Up["+IntToStr(i)+"].Name",CBoxUp->Items->Strings[i]);
    CBoxUp->Checked[i]=IF->ReadInteger(LoadName,"Up["+IntToStr(i)+"].Checked",0);
    ((TWTString*)CBoxUp->Items->Objects[i])->String=IF->ReadString(LoadName,"Up["+IntToStr(i)+"].Value","");
    CBoxDown->Items->Strings[i]=IF->ReadString(LoadName,"Down["+IntToStr(i)+"].Name",CBoxUp->Items->Strings[i]);
    CBoxDown->Checked[i]=IF->ReadInteger(LoadName,"Down["+IntToStr(i)+"].Checked",0);
    ((TWTString*)CBoxDown->Items->Objects[i])->String=IF->ReadString(LoadName,"Down["+IntToStr(i)+"].Value","");
  }
  for (int x=0;x<FieldsCount;x++) {
    Level=IF->ReadInteger(LoadName,"Field["+IntToStr(x)+"].Level",0);
    Result=IF->ReadString(LoadName,"Field["+IntToStr(x)+"]","");
    for (i=0;((TWTFieldProperty*)GrpSource->Items->Objects[i])->Field->FieldName!=Result;i++);
    GrpSource->Selected[GrpSource->ItemIndex]=false;
    GrpSource->ItemIndex=i;
    GrpSource->Selected[i]=true;
    FP=(TWTFieldProperty*)GrpSource->Items->Objects[i];
    FP->Name=IF->ReadString(LoadName,"Field["+IntToStr(x)+"].Name","");
    FP->FieldLength=IF->ReadInteger(LoadName,"Field["+IntToStr(x)+"].Wide",0);
    FP->BgColor= TColor(IF->ReadInteger(LoadName,"Field["+IntToStr(x)+"].BgColor",0));
    FP->ModFlag=IF->ReadInteger(LoadName,"Field["+IntToStr(x)+"].Modification",0);
    FP->Align=IF->ReadInteger(LoadName,"Field["+IntToStr(x)+"].Align",0);
    IniToFont(FP->Font,IF,LoadName,"Field["+IntToStr(x)+"].Font");
      if (Level!=PrevLevel) {
        FAddGrpOnClick(NULL);
        GP=(TGrpProperty*)GrpDest->Selected->Data;
        IniToFont(GP->CaptFont,IF,LoadName,"Group["+IntToStr(Level)+"].CaptFont");
        GP->BgColor= TColor(IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].BgColor",0));
        GP->Otst=IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].Otst",0);
        GP->Dist=IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].Dist",0);
        GP->IName=IF->ReadString(LoadName,"Group["+IntToStr(Level)+"].IName","");
        GP->Enabled=bool(IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].Enabled",0));
        GP->Kind=bool(IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].Kind",0));
        GP->IsName=bool(IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].IsName",0));
        GP->IsValue=bool(IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].IsValue",0));
        GP->Function=IF->ReadString(LoadName,"Group["+IntToStr(Level)+"].Function","");
        ResultsCount=IF->ReadInteger(LoadName,"Group["+IntToStr(Level)+"].ResultsCount",0);
        for (int num=0;num<ResultsCount;num++) {
          Result=IF->ReadString(LoadName,"Group["+IntToStr(Level)+"].Results["+IntToStr(num)+"].Field","");
          for (i=0;i<GrpSource->Items->Count;i++) {
            if (((TWTFieldProperty*)GrpSource->Items->Objects[i])->Field->FieldName==Result) Field=((TWTFieldProperty*)GrpSource->Items->Objects[i])->Field;
          }
          for (i=0;i<GrpDest->Items->Item[0]->Count;i++) {
            if (((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->Field->FieldName==Result) Field=((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->Field;
          }
          GP->Fields->Add(Field);
        }
      }
      else {
        FLockOnClick(NULL);
        FAddGrpOnClick(NULL);
        FLockOnClick(NULL);
      }
//    }
    PrevLevel=Level;
  }
  UpdateText(CBoxUp);
  UpdateText(CBoxDown);
}

void __fastcall TWTSelFields::DeleteReport(TObject* Sender) {

/*  TListForm *LF=new TListForm(Application);
  LF->QuickRep->Preview();
  delete LF;
  ModalResult=mrOk;
  return;          */
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbOK;
  if (CurrentReport=="") {
    MessageDlg("Не могу удалить несохраненный отчет", mtConfirmation,DB, 0);
    return;
  }
  AnsiString ReportID="";

//  int NumID;
  ReportID=FDBGrid->GetID();

  if (!((TWTMainForm*)Application->MainForm)->IniFile->SectionExists("Отчеты\\"+ReportID+"\\"+CurrentReport)) {
    ShowMessage("Не могу удалить глобальный отчет");
    return;
  }

  TMemIniFile *IF=((TWTMainForm*)Application->MainForm)->IniFile;
  DB=DB << mbCancel;
  if (MessageDlg("Вы действительно хотите удалить текущий отчет?", mtConfirmation,DB, 0)==mrOk) {
    ((TWTMainForm*)Application->MainForm)->IniFile->DeleteKey("ReportsID\\"+ReportID,CurrentReport);
    IF->EraseSection("Отчеты\\"+ReportID+"\\"+CurrentReport);
/*    for (int x=0;x<ReportMenuItem->Count;x++) {
      if (ReportMenuItem->Items[x]->Caption==CurrentReport) ReportMenuItem->Delete(x);
    }*/
//    UpdateIniFile(IF);
    IF->UpdateFile();
    Close();
  }
}

//---------------------------------------------------------------------------
void __fastcall TWTSelFields::FAddGrpOnClick(TObject *Sender) {
//  TModalResult MR;
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbYes << mbNo << mbAll;
  TTreeNode* TN;
  int x=0;
  int y=0;

  if (Locked) {
    if (GrpSource->SelCount==0) GrpSource->Selected[GrpSource->ItemIndex]=true;
    for (int i=0;i<GrpDest->Items->Count;i++) {
      if (GrpDest->Items->Item[i]->Level==0) x++;
    }
    AnsiString Name;
    if (GrpDest->Items->Count) Name="Группа "+IntToStr(x);
    else Name="Колонки отчета";
    TN=GrpDest->Items->AddObject(NULL,Name,new TGrpProperty());
    ((TGrpProperty*)TN->Data)->Otst=10*x;
    for (x=0;x<GrpSource->Items->Count;x++) {
      if (GrpSource->Selected[x]) {
        GrpDest->Items->AddChildObject(TN,GrpSource->Items->Strings[x],GrpSource->Items->Objects[x]);
        GrpSource->Items->Delete(x);
        x--;
        y=x;
      }
    }
    GrpSource->ItemIndex=y+1;
    if (GrpSource->Items->Count!=0) GrpSource->Selected[GrpSource->ItemIndex]=true;
    SBDelGrp->Enabled=true;
    SBDelField->Enabled=true;
    SBUp->Enabled=true;
    SBDown->Enabled=true;
    SBLock->Enabled=true;
    GrpDest->Selected=TN;
  }
  else {
    if (GrpSource->SelCount==0) GrpSource->Selected[GrpSource->ItemIndex]=true;
    if (GrpDest->Selected->Level==0) TN=GrpDest->Selected;
       else TN=GrpDest->Selected->Parent;
    for (x=0;x<GrpSource->Items->Count;x++) {
      if (GrpSource->Selected[x]) {
        if ((((TWTFieldProperty*)GrpSource->Items->Objects[x])->Field->FieldKind==fkCalculated) || (((TWTFieldProperty*)GrpSource->Items->Objects[x])->Field->FieldKind==fkInternalCalc)) {
          MessageDlg("Вычисляемое поле <"+GrpSource->Items->Strings[x]+"> не может быть включено в группу.",mtWarning,DB,0);
        }
        else {
          GrpDest->Items->AddChildObject(TN,GrpSource->Items->Strings[x],GrpSource->Items->Objects[x]);
          GrpSource->Items->Delete(x);
          x--;
          y=x;
        }
      }
    }
    GrpSource->ItemIndex=y+1;
    if (GrpSource->Items->Count!=0) GrpSource->Selected[GrpSource->ItemIndex]=true;
    GrpDest->Selected=TN;
  }
  if (!GrpSource->Items->Count) {
    SBAddGrp->Enabled=false;
    SBAddField->Enabled=false;
  }
}
//---------------------------------------------------------------------------
void __fastcall TWTSelFields::FAddFieldOnClick(TObject *Sender) {
  GrpSource->Selected[-1]=true;
  FAddGrpOnClick(Sender);
}

void __fastcall TWTSelFields::RemoveField(TTreeNode* TN) {
  Boolean IsBusy=false;
  TModalResult MR;
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbYes << mbNo << mbAll;
  for (int i=0;i<GrpDest->Items->Count;i++)
    if (GrpDest->Items->Item[i]->Level==0)
      if (((TGrpProperty*)GrpDest->Items->Item[i]->Data)->Fields->IndexOf(((TWTFieldProperty*)TN->Data)->Field)!=-1) {
        IsBusy=true;
        break;
      }
  AnsiString AS="Удаляемое поле <"+TN->Text+"> включено в итоги одной из групп. Удалять данное поле?";
  if (IsBusy && (!AllFlag)) {
    MR=MessageDlg(AS, mtWarning,DB, 0);
    switch (MR) {
      case mrYes: {
           IsBusy=false;
           break;
      }
      case mrAll: {
           AllFlag=true;
           break;
      }
      default: {
           IsBusy=true;
      }
    }
  }
  TTreeNode* Parent=TN->Parent;
  if ((!IsBusy) || (AllFlag)) {
    GrpSource->Items->AddObject(TN->Text,(TObject*)TN->Data);
    for (int i=0;i<GrpDest->Items->Count;i++)
      if (GrpDest->Items->Item[i]->Level==0)
        ((TGrpProperty*)GrpDest->Items->Item[i]->Data)->Fields->Remove(((TWTFieldProperty*)TN->Data)->Field);
    TN->Delete();
    if (Parent->Count==0) Parent->Delete();
  }
}

//---------------------------------------------------------------------------
void __fastcall TWTSelFields::FDelGrpOnClick(TObject *Sender) {
  TModalResult MR;
  TMsgDlgButtons DB;
  DB.Clear();
  DB=DB << mbYes << mbNo;
  TTreeNode* TN=GrpDest->Selected;
  if (GrpDest->Selected->Level==1) {
    TTreeNode* Parent=TN->Parent;
    if (GrpDest->Selected->Parent->Index==0)
      for (int i=0;i<GrpDest->Items->Count;i++)
        if (GrpDest->Items->Item[i]->Level==0)
          if (((TGrpProperty*)GrpDest->Items->Item[i]->Data)->Fields->IndexOf(((TWTFieldProperty*)TN->Data)->Field)!=-1) {
            AnsiString AS="Удаляемое поле <"+TN->Text+"> включено в итоги одной из групп. Продолжить?";
            MR=MessageDlg(AS, mtWarning,DB, 0);
            if (MR==mrYes) break;
            else return;
          }
    int x=GetIndexToInsert((TWTFieldProperty*)GrpDest->Selected->Data);
/*    if (x!=GrpSource->Items->Count) */GrpSource->Items->InsertObject(x,GrpDest->Selected->Text,(TObject*)GrpDest->Selected->Data);
//    else GrpSource->Items->AddObject(GrpDest->Selected->Text,(TObject*)GrpDest->Selected->Data);

    TN->Delete();
    if (Parent->Count==0) delete Parent;
  }
  else {
    if (GrpDest->Selected->Index==0)
      for (int x=0;x<GrpDest->Items->Item[0]->Count;x++) {
        for (int i=0;i<GrpDest->Items->Count;i++)
          if (GrpDest->Items->Item[i]->Level==0)
            if (((TGrpProperty*)GrpDest->Items->Item[i]->Data)->Fields->IndexOf(((TWTFieldProperty*)TN->Item[x]->Data)->Field)!=-1) {
              AnsiString AS="В удаляемой группе <"+TN->Text+"> находится поле, которое включено в итоги одной из групп. Продолжить?";
              MR=MessageDlg(AS, mtWarning,DB, 0);
              if (MR==mrYes) break;
              else {
                AllFlag=false;
                return;
              }
            }
        if (MR==mrYes) break;
      }
      for (int i=0;i<TN->Count;i++) {
        int InsIndex=GetIndexToInsert((TWTFieldProperty*)TN->Item[i]->Data);
       /* if (InsIndex!=GrpSource->Items->Count) */GrpSource->Items->InsertObject(InsIndex,TN->Item[i]->Text,(TObject*)TN->Item[i]->Data);
//        else GrpSource->Items->AddObject(GrpDest->Selected->Text,(TObject*)GrpDest->Selected->Data);
      }
      delete TN;
  }
  UpdateNames();
  if (!GrpDest->Items->Count) {
    SBDelGrp->Enabled=false;
    SBDelField->Enabled=false;
    SBUp->Enabled=false;
    SBDown->Enabled=false;
    if (!Locked) FLockOnClick(Sender);
    SBLock->Enabled=false;
    SBProp->Enabled=false;
  }
  if (GrpSource->Items->Count) {
    SBAddGrp->Enabled=true;
    SBAddField->Enabled=true;
  }
}

void __fastcall TWTSelFields::FDelFieldOnClick(TObject *Sender) {
  int i=0;
  while (!GrpDest->Items->Count==0) {
    while (!GrpDest->Items->Item[i]->Level==0) i++;
    GrpDest->Selected=GrpDest->Items->Item[i];
    FDelGrpOnClick(NULL);
    if (!AllFlag) return;
  }
}

//---------------------------------------------------------------------------
void TWTSelFields::UpdateNames(){
  int x=0;
  AnsiString Name="Колонки отчета";
  for (int i=0;i<GrpDest->Items->Count;i++) {
    if (GrpDest->Items->Item[i]->Level==0) {
      if (i>0) Name="Группа "+IntToStr(x);
      GrpDest->Items->Item[i]->Text=Name;
      x++;
    }
  }
}

void __fastcall TWTSelFields::OnChangeGrp(TObject* Sender,TTreeNode* Node) {
  if ((Node->Level==0) && (Node->Index==0)) {
    SBUp->Enabled=false;
    SBDown->Enabled=false;
  }
  else {
    SBUp->Enabled=true;
    SBDown->Enabled=true;
  }
  SBProp->Enabled=true;
}

void __fastcall TWTSelFields::FUpOnClick(TObject *Sender){
  int x=0;
  int Prev=0;
  TTreeNode* TN;
  AnsiString Name;
  void* Data;
  if (GrpDest->Selected->Level==0) {
    while (GrpDest->Items->Item[x]!=GrpDest->Selected) {
      if (GrpDest->Items->Item[x]->Level==0) Prev=x;
      x++;
    }
    if (GrpDest->Items->Item[Prev]->Index) {
      TN=GrpDest->Items->InsertObject(GrpDest->Items->Item[Prev],GrpDest->Selected->Text,GrpDest->Selected->Data);
      for (x=0;x<GrpDest->Selected->Count;x++)
        GrpDest->Items->AddChildObject(TN,GrpDest->Selected->Item[x]->Text,GrpDest->Selected->Item[x]->Data);
      TN->Expanded=GrpDest->Selected->Expanded;
      delete GrpDest->Selected;
      GrpDest->Selected=TN;
    }
    UpdateNames();
  }
  else {
    if (GrpDest->Selected->Index) {
      TN=GrpDest->Selected->Parent->Item[GrpDest->Selected->Index-1];
      Name=GrpDest->Selected->Text;
      Data=GrpDest->Selected->Data;
      GrpDest->Selected->Text=TN->Text;
      GrpDest->Selected->Data=TN->Data;
      TN->Text=Name;
      TN->Data=Data;
      GrpDest->Selected=TN;
    }
  }
}

void __fastcall TWTSelFields::FDownOnClick(TObject *Sender){
  int x=0;
  int Next=0;
  TTreeNode* TN;
  AnsiString Name;
  void* Data;
  if (GrpDest->Selected->Level==0) {
    Next=GrpDest->Selected->AbsoluteIndex+1;
    while (Next<GrpDest->Items->Count) {
      if (!GrpDest->Items->Item[Next]->Level) break;
      Next++;
    }
    Next++;
    while (Next<GrpDest->Items->Count) {
      if (!GrpDest->Items->Item[Next]->Level) break;
      Next++;
    }
    if (Next<GrpDest->Items->Count) {
      TN=GrpDest->Items->InsertObject(GrpDest->Items->Item[Next],GrpDest->Selected->Text,GrpDest->Selected->Data);
      for (x=0;x<GrpDest->Selected->Count;x++)
        GrpDest->Items->AddChildObject(TN,GrpDest->Selected->Item[x]->Text,GrpDest->Selected->Item[x]->Data);
    }
    else {
      TN=GrpDest->Items->AddObject(GrpDest->Items->Item[0],GrpDest->Selected->Text,GrpDest->Selected->Data);
      for (x=0;x<GrpDest->Selected->Count;x++)
        GrpDest->Items->AddChildObject(TN,GrpDest->Selected->Item[x]->Text,GrpDest->Selected->Item[x]->Data);
    }
    TN->Expanded=GrpDest->Selected->Expanded;
    delete GrpDest->Selected;
    GrpDest->Selected=TN;
    UpdateNames();
  }
  else {
    if ((GrpDest->Selected->Index+1)<GrpDest->Selected->Parent->Count) {
      TN=GrpDest->Selected->Parent->Item[GrpDest->Selected->Index+1];
      Name=GrpDest->Selected->Text;
      Data=GrpDest->Selected->Data;
      GrpDest->Selected->Text=TN->Text;
      GrpDest->Selected->Data=TN->Data;
      TN->Text=Name;
      TN->Data=Data;
      GrpDest->Selected=TN;
    }
  }
}

//---------------------------------------------------------------------------
void __fastcall TWTSelFields::GrpDestDblClick(TObject *Sender) {
  if (GrpDest->Selected->Level==1) {
    TWTSetWFForm * SWF= new TWTSetWFForm((TWTFieldProperty*)GrpDest->Selected->Data,this);
    SWF->BgColor=DefaultBgColor;
    SWF->DataFont->Assign(DefaultFont);
/*    if (SWF->ShowModal()==-1) {
      SWF->Close();
      return;
    }
    SWF->Close();*/
    SWF->TForm::ShowModal();
    delete SWF;
  }
  else {
    GrpDest->Selected->Expand(false);
    TWTSetGrp* SG= new TWTSetGrp((TGrpProperty*)GrpDest->Selected->Data,GrpDest,this);
//    if (GrpDest->Selected->Index==0) SG->TSh1->PageControl=NULL;
/*    if (SG->ShowModal()==-1) {
      SG->Close();
      return;
    }
    SG->Close();*/
    SG->TForm::ShowModal();
    delete SG;
  }
}

#include "MainForm.h"

void TWTSelFields::ReportPrint() {
  int i;

/*  if (((TWTMainForm*)MainForm)->PreviewForm) delete ((TWTMainForm*)MainForm)->PreviewForm;

  ((TWTMainForm*)MainForm)->PreviewForm= new TWTReportView(Application);

  TWTReportView* PreviewForm=((TWTMainForm*)MainForm)->PreviewForm;*/

  if (GrpDest->Items->Count== 0) {
    if (!TableMenuItem->Items[4]->Checked) {
      delete WaitForm;
      Application->MainForm->Enabled=true;
    }
    ModalResult=mrOk;
    return;
  }

  if (ReportsList==NULL) ReportsList=new TList();
  int RepNum=ReportsList->Count;

  if (ReportsList->Count==10) {
    for (RepNum=0;RepNum<ReportsList->Count;RepNum++)
      if (((TComponent*)ReportsList->Items[RepNum])->Tag==0) break;
    if (RepNum==ReportsList->Count) {
      ShowMessage("Не могу создать еще один отчет");
      return;
    }
  }

//  Application->ProcessMessages();

  WaitForm=new TWTWaitForm(this,"Формируется отчет","Images//Inspect");
  WaitForm->StopEnabled=true;
  Application->MainForm->Enabled=false;
  WaitForm->Show();

  Application->ProcessMessages();

  TWTReportView *PF=new TWTReportView(Application);
//  TQuickRep *Report = new TQuickRep(Application);
//  PF->Report=Report;
  TQuickRep *Report;

  if (RepNum==ReportsList->Count) {
    PF->Report = new TQuickRep(Application);
    ReportsList->Add(PF->Report);
    PF->Report->Tag=1;
  } else {
    TQuickRep* TempRep=(TQuickRep*)ReportsList->Items[RepNum];
    while (TempRep->ControlCount!=0) {
      delete TempRep->Controls[0];
    }
    TempRep->Tag=1;
    PF->Report=TempRep;
  }
  Report=PF->Report;

  int Count;
  int Left = 4;
  TField *Field;
  TQRShape* QRSp;

  TQRGroup* GroupHeader;
  TQRBand* GroupFooter;
  TQRExpr* QRExpr;
  TGrpProperty* GP;
  AnsiString IndexFields="";
  TWTFieldProperty* FP;
  AnsiString Expression="";
  int MinOtst;

/*  PreviewForm->MainQuery=new TQuery(PreviewForm);

  PreviewForm->MainQuery->Filter=MainQuery->Filter;
  PreviewForm->MainQuery->Filtered=MainQuery->Filtered;
  for (int x=0;x<MainQuery->FieldCount;x++) DuplicateField(MainQuery->Fields->Fields[x],PreviewForm->MainQuery);
  PreviewForm->MainQuery->DatabaseName=MainQuery->DatabaseName;
  PreviewForm->MainQuery->SQL->Assign(MainQuery->SQL);*/

  boolean IsGroup=0;

  for (int x=GrpDest->Items->Item[0]->Count+1;x<GrpDest->Items->Count;x++) {
    if (GrpDest->Items->Item[x]->Level==0) {
      GP=(TGrpProperty*)GrpDest->Items->Item[x]->Data;
      if (!IsGroup) MinOtst=GP->Otst;
      IsGroup++;
      if (GP->Otst<MinOtst) MinOtst=GP->Otst;
    }
    if (GrpDest->Items->Item[x]->Level) {
      FP=(TWTFieldProperty*)GrpDest->Items->Item[x]->Data;
      if (IndexFields!="") IndexFields=IndexFields+",";
      if (FP->Field->FieldKind==fkLookup) IndexFields=IndexFields+FP->Field->KeyFields;
      else IndexFields=IndexFields+FP->Field->FieldName;
    }
  }
  if (IsTable) {
    TWTTable *CT=FDBGrid->Table;
    if (FDBGrid->Table->MasterSource) {
      CT->IndexDefs->Update();
      TIndexDef* CurIndex=NULL;
      char ifields[100];
      ifields[0]=0;
      if (CT->IndexFieldNames!="") strcpy(ifields,CT->IndexFieldNames.c_str());
      else {
        try {
          CurIndex=CT->IndexDefs->FindIndexForFields(CT->IndexFieldNames);
          strcpy(ifields,CurIndex->Fields.c_str());
        } catch (...) {
        }
      }
      if (ifields[0]) {
        AnsiString WhereStr="where ";
        char mfields[100];
        strcpy(mfields,CT->LinkFields.c_str());
        char *ifield;
        ifield = strtok(ifields,"; \t");

        TStringList* IFN=new TStringList();
        TStringList* MFN=new TStringList();

        while (ifield) {
          IFN->Add(ifield);
          ifield = strtok(NULL,"; \t");
        }

        char *mfield;
        mfield = strtok(mfields,"; \t");

        while (mfield) {
          MFN->Add(mfield);
          mfield = strtok(NULL,"; \t");
        }

        int CC=IFN->Count;
        if (MFN->Count<CC) CC=MFN->Count;

        for (int x=0;x<CC;x++) {
          if (x!=0) WhereStr += " and ";
          WhereStr += MFN->Strings[x] + " = " + ToStrSQL(CT->GetTField(IFN->Strings[x]));
        }

        MainQuery->Sql->Add(WhereStr);
      }
    }
    if (IndexFields!="") MainQuery->Sql->Add("order by " + IndexFields);
  }
  else {
    AnsiString AS;
    int Pos;
    int x;
    int PosGroup;
    int PosHaving;
    int PosWhere;
    int EndPos;


    AS=MainQuery->Sql->Strings[0].LowerCase();
    if (AS.Pos("select")==0) {
      ShowMessage("Не могу отсортировать текущую таблицу");
      return;
    }
    for (x=MainQuery->Sql->Count-1;x>=0;x--) {
      AS=MainQuery->Sql->Strings[x].LowerCase();
      Pos=AS.Pos("order by");
      if (Pos) {
        int y=x;
        while (y!=MainQuery->Sql->Count) {
          AS=MainQuery->Sql->Strings[x];
          AS.LowerCase();
          PosGroup=AS.Pos("group by");
          PosHaving=AS.Pos("having");
          PosWhere=AS.Pos("where");
          EndPos=AS.Length()+1;

          if (PosGroup!=0 && PosGroup>Pos) EndPos=PosGroup;
          if (PosHaving!=0 && PosHaving>Pos && PosHaving<PosGroup) EndPos=PosHaving;
          if (PosWhere!=0 && PosWhere>Pos && PosWhere<EndPos) EndPos=PosWhere;

          AS.Delete(Pos,EndPos-Pos);
          MainQuery->Sql->Delete(y);
          if (AS!="") {
            MainQuery->Sql->Insert(y,AS);
            y++;
          }

          if (PosGroup || PosHaving || PosWhere) break;
          Pos=1;
        }

        MainQuery->Sql->Add("order by "+IndexFields+" ");
        break;
      }
    }
    if (x==-1) MainQuery->Sql->Add("order by "+IndexFields);
    MainQuery->Params->AssignValues(MainQuery->Params);
  }
 try {
  MainQuery->Open();

  int H, W;
  Report->Left = 2;
  Report->Top = 6;
  if (TCb->Text.SubString(1,2)== "А4") {
    Report->Page->PaperSize = A4;
    W= 794;
    H= 1123;
  }
  else {
    Report->Page->PaperSize = A3;
    W= 1123;
    H= 1587;
  }

  if (TRg1->ItemIndex== 0) {
    Report->Page->Orientation = poPortrait;
    Report->Width = W;
    Report->Height = H;
  }
  else {
    Report->Page->Orientation = poLandscape;
    Report->Width = H;
    Report->Height = W;
  }

  Report->DataSet=MainQuery;
  Report->PrinterSettings->Copies = 1;
  Report->PrinterSettings->Duplex = False;
  Report->PrinterSettings->FirstPage = 0;
  Report->PrinterSettings->LastPage = 0;
  Report->PrinterSettings->OutputBin = First;

  TQRBand *DetailBand1= new TQRBand(Report);
  DetailBand1->Left = 38;
  DetailBand1->Top = 145;
  DetailBand1->Width = 1511;
  DetailBand1->AlignToBottom = False;
  DetailBand1->Color = clWhite;
  DetailBand1->BandType = rbDetail;
  DetailBand1->Parent= Report;

  TQRBand *QRBand1= new TQRBand(Report);
  QRBand1->Left = 38;
  QRBand1->Top = 38;
  QRBand1->Height = 40;
  QRBand1->BandType = rbTitle;
  QRBand1->Parent= Report;

  TQRLabel *QRLabel1 = new TQRLabel(Report);
  QRLabel1->Top = 8;
  QRLabel1->Alignment = taCenter;
  QRLabel1->AutoSize = true;
  if (NEdit->Text=="") QRLabel1->Caption = DefaultTitle;
  else QRLabel1->Caption = NEdit->Text;
  if (NEdit->Text!="") Report->ReportTitle=NEdit->Text;
  else Report->ReportTitle=DefaultTitle;
  QRLabel1->Font->Assign(NameFont);
  QRLabel1->Parent= QRBand1;
  QRLabel1->Left = QRBand1->Width/2- QRLabel1->Width/2;

  TQRBand *QRBand2 = new TQRBand(Report);
  QRBand2->Left = 38;
  QRBand2->Top = 78;
  QRBand2->BandType = rbColumnHeader;
  QRBand2->Parent = Report;

  TQRLabel *QRLabel;
  TQRDBText *QRDBText;

  Count = GrpDest->Items->Item[0]->Count;
  Left = 4;
  int MHeight= 0;

  for (i=0; i< Count; i++) {
    Left+= ((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->FieldLength;
//    Left+=7;
    if (((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->Font->Size>MHeight)
      MHeight= ((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->Font->Size;
  }
  if (DefaultFont->Size>MHeight) MHeight=DefaultFont->Size;

  float coef=1;
  if (TRg2->ItemIndex==2)
      coef=float(DetailBand1->Width-i*7)/float(Left);

  Left = 4+SEOtst->Value;
//  TWTFieldProperty* FProp;

  TQRShape* QRSp1=new TQRShape(Report);

  if (IsGroup && (Left+2>MinOtst)) {
    QRSp1->Shape=qrsRectangle;
    QRSp1->Pen->Width=2;
    QRSp1->Top=0;
    QRSp1->Left=MinOtst+2;
    QRSp1->Width=Left-MinOtst-2;
    QRSp1->Brush->Color=HeaderBgColor;
    QRSp1->Parent=QRBand2;
    QRSp1->SendToBack();
  }

  AnsiString Max_Array[100];
  TProgressBar *PrBar;
  int x;

  if (CheckBox->Checked) {
    PrBar=new TProgressBar(this);
    PrBar->Align=alClient;
    PrBar->Visible=false;
    PrBar->Parent=Panel2;
    PrBar->Position=0;
    PrBar->Visible=true;

    MainQuery->Last();
    int RN= MainQuery->RecNo;
    PrBar->Max= RN;

    MainQuery->First();
    for (i=0; i< RN; i++) {
      for (x=0; x< GrpDest->Items->Item[0]->Count; x++)
        if (MainQuery->FieldByName(((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[x]->Data)->Field->FieldName)->DisplayText.Length()> Max_Array[x].Length())
          Max_Array[x]= MainQuery->FieldByName(((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[x]->Data)->Field->FieldName)->DisplayText;
      MainQuery->Next();
      PrBar->StepBy(1);
    }
    delete PrBar;
    for (i=0; i<GrpDest->Items->Item[0]->Count; i++) {
      if (((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->ModFlag)
        ((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->FieldLength= StringSize(Max_Array[i], ((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->Font)+5;
      else
        ((TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data)->FieldLength= StringSize(Max_Array[i], DefaultFont)+ 5;
    }
  }                      

  for (i = 0; i < Count; i++) {

    FP=(TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data;
    Field=FP->Field;

    if (((Left+ FP->FieldLength+6) > (DetailBand1->Width)) &&
         TRg2->ItemIndex==1 ) {
       break;
    }
    QRLabel = new TQRLabel(Report);
    QRLabel->WordWrap=false;
    QRLabel->AutoSize=false;
    QRLabel->Parent = QRBand2;

    TAlignment Align;
    switch (FP->Align) {
      case 0: {
        Align=taLeftJustify;
      }
      break;
      case 1: {
        Align=taRightJustify;
      }
      break;
      case 2: {
        Align=taCenter;
      }
      break;
    }
    QRLabel->Alignment = Align;
    QRLabel->Left = Left;
    QRLabel->Caption=FP->Name;
    QRLabel->Font->Assign(HeaderFont);
    QRLabel->Transparent=true;
    QRLabel->Top=5;

    QRDBText = new TQRDBText(Report);
    QRDBText->WordWrap=false;
    QRDBText->Top = 3;
    QRDBText->Left= Left;
    QRDBText->Alignment = Align;
    if (FP->ModFlag)
      QRDBText->Font->Assign(FP->Font);
    else
      QRDBText->Font->Assign(DefaultFont);
    QRDBText->Top=(MHeight)/2-QRDBText->Font->Size/2;
    QRDBText->AutoSize=false;
    QRDBText->Width= int((FP->FieldLength)*coef)+4;

    QRDBText->Transparent=true;

    QRDBText->DataSet = MainQuery;
    QRDBText->DataField = Field->FieldName;
    QRDBText->Parent = DetailBand1;

    QRLabel->Width= QRDBText->Width;
    Left+=QRDBText->Width+2;

    QRSp=new TQRShape(Report);
    QRSp->Shape=qrsRectangle;
    QRSp->Top=-2;
    QRSp->Left=QRDBText->Left-2;
    QRSp->Width=QRDBText->Width+3;
    QRSp->Height=MHeight+12;
    if (FP->ModFlag) QRSp->Brush->Color=FP->BgColor;
    else QRSp->Brush->Color=DefaultBgColor;
    QRSp->Parent=DetailBand1;
    QRSp->SendToBack();

    QRSp=new TQRShape(Report);
    QRSp->Shape=qrsRectangle;
    QRSp->Pen->Width=2;
    QRSp->Top=0;
    QRSp->Left=QRDBText->Left-2;
    QRSp->Width=QRDBText->Width+3;
    QRSp->Height=QRLabel->Height+9;
    QRSp->Brush->Color=HeaderBgColor;
    QRSp->Parent=QRBand2;
    QRSp->SendToBack();
  }

  QRSp1->Height=QRLabel->Height+9;
  DetailBand1->Height= MHeight+ 10;
  QRBand2->Height= QRLabel->Height+ 10;

  int MaxHeight=0;
  int CurPos=0;

  for ( x=0;x<GrpDest->Items->Count;x++) {
    if (GrpDest->Items->Item[x]->Level==0) {
      GP=(TGrpProperty*)GrpDest->Items->Item[x]->Data;
      if (GP->CaptFont->Size>MaxHeight) MaxHeight=GP->CaptFont->Size;
      for (int i=0;i<GrpDest->Items->Item[x]->Count;i++) {
        FP=(TWTFieldProperty*)GrpDest->Items->Item[x]->Item[i]->Data;
        if (FP->Font->Size>MaxHeight) MaxHeight=FP->Font->Size;
      }
      if (x) {
        GroupHeader=new TQRGroup(Report);
        GroupHeader->Parent=Report;
        for (int i=0;i<GrpDest->Items->Item[x]->Count;i++) {
          FP=(TWTFieldProperty*)GrpDest->Items->Item[x]->Item[i]->Data;
          if (GroupHeader->Expression!="") GroupHeader->Expression=GroupHeader->Expression+"+";
          if (FP->Field->DataType==ftString) GroupHeader->Expression=GroupHeader->Expression+FP->Field->FieldName;
          else GroupHeader->Expression=GroupHeader->Expression+"str("+FP->Field->FieldName+")";
        }
        GroupHeader->Height=MaxHeight+10;
        QRSp=new TQRShape(Report);
        QRSp->Shape=qrsRectangle;
        QRSp->Pen->Width=1;
        QRSp->Top=-1;
        QRSp->Left=GP->Otst+2;
        QRSp->Width=Left-GP->Otst-3;
        QRSp->Height=MaxHeight+10;
        QRSp->Brush->Color=GP->BgColor;
        QRSp->Pen->Width=2;
        QRSp->Parent=GroupHeader;
        QRSp->SendToBack();
        CurPos=GP->Otst+4;
        for ( i=0;i<GrpDest->Items->Item[x]->Count;i++) {
          FP=(TWTFieldProperty*)GrpDest->Items->Item[x]->Item[i]->Data;
          if (GP->IsName) {
            QRLabel = new TQRLabel(Report);
            QRLabel->WordWrap=false;
            QRLabel->AutoSize=true;
            QRLabel->Parent = GroupHeader;
            QRLabel->Alignment = taLeftJustify;
            QRLabel->Left = CurPos;
            QRLabel->Caption=FP->Name;
            QRLabel->Font->Assign(GP->CaptFont);
            QRLabel->Transparent=true;
            QRLabel->Top=(MaxHeight-QRLabel->Font->Size)/2;
            if ((CurPos+QRLabel->Width+3)>Left) {
              QRLabel->AutoSize=false;
              QRLabel->Width=Left-3-CurPos;
              break;
            }
            CurPos=CurPos+QRLabel->Width;
          }
          if (GP->IsValue) {
            QRDBText = new TQRDBText(Report);
            QRDBText->WordWrap=false;
            QRDBText->Left= CurPos+5;
            QRDBText->Alignment = taLeftJustify;
            if (FP->ModFlag)
              QRDBText->Font->Assign(FP->Font);
            else
              QRDBText->Font->Assign(DefaultFont);
            QRDBText->Top = (MaxHeight-QRDBText->Font->Size)/2;
            QRDBText->AutoSize=false;
            QRDBText->Width= FP->FieldLength+4;
            QRDBText->Transparent=true;
            QRDBText->DataSet = MainQuery;
            QRDBText->DataField = FP->Field->FieldName;
            QRDBText->Parent = GroupHeader;
            if ((CurPos+QRDBText->Width+3)>Left) {
              QRDBText->Width=Left-3-CurPos;
              break;
            }
            CurPos=CurPos+QRDBText->Width;
          }
          CurPos=CurPos+GP->Dist;
        }
      }
      if ((GP->Fields->Count!=0) && (GP->Enabled)) {
        CurPos=SEOtst->Value+4;
        GroupFooter=new TQRBand(Report);
        GroupFooter->Parent=Report;
        if (x) {
          GroupFooter->BandType=rbGroupFooter;
          GroupHeader->FooterBand=GroupFooter;
        }
        else GroupFooter->BandType=rbSummary;
        GroupFooter->Height=MaxHeight+10;
        QRSp=new TQRShape(Report);
        QRSp->Shape=qrsRectangle;
        QRSp->Pen->Width=1;
        QRSp->Top=-1;
        QRSp->Left=GP->Otst+2;
        QRSp->Width=Left-GP->Otst-3;
        QRSp->Height=MaxHeight+11;
        QRSp->Brush->Color=GP->BgColor;
        QRSp->Pen->Width=2;
        QRSp->Parent=GroupFooter;
        QRSp->SendToBack();
        QRLabel = new TQRLabel(Report);
        QRLabel->WordWrap=false;
        QRLabel->AutoSize=true;
        QRLabel->Parent = GroupFooter;
        QRLabel->Alignment = taLeftJustify;
        QRLabel->Left = GP->Otst+5;
        QRLabel->Caption=GP->IName;
        QRLabel->Font->Assign(GP->CaptFont);
        QRLabel->Transparent=true;
        QRLabel->Top=(MaxHeight-QRLabel->Font->Size)/2;
        if ((CurPos+QRLabel->Width+3)>Left) {
          QRLabel->AutoSize=false;
          QRLabel->Width=Left-3-CurPos;
          break;
        }
        for (int i=0;i<GrpDest->Items->Item[0]->Count;i++) {
          FP=(TWTFieldProperty*)GrpDest->Items->Item[0]->Item[i]->Data;
          if ((CurPos+int(FP->FieldLength*coef)+6)>GroupFooter->Width) break;
          if (GP->Fields->IndexOf(FP->Field)!=-1) {
            QRExpr = new TQRExpr(Report);
            QRExpr->Width= int(FP->FieldLength*coef)+4;
            QRExpr->WordWrap=false;
            QRExpr->AutoSize=false;
            QRExpr->Parent = GroupFooter;
            QRExpr->Mask=((TNumericField*)FP->Field)->DisplayFormat;
            switch (FP->Align) {
              case 0: {
                QRExpr->Alignment=taLeftJustify;
                break;
              }
              case 1: {
                QRExpr->Alignment=taRightJustify;
                break;
              }
              case 2: {
                QRExpr->Alignment=taCenter;
                break;
              }
            }
            QRExpr->Left = CurPos;
            QRExpr->Expression=GP->Function+"("+FP->Field->FieldName+")";;
            if (FP->ModFlag)
              QRExpr->Font->Assign(FP->Font);
            else
              QRExpr->Font->Assign(DefaultFont);
            QRExpr->Transparent=true;
            QRExpr->Master=Report;
            QRExpr->ResetAfterPrint=true;
            if (!GP->Kind) QRExpr->Top=(MaxHeight-QRExpr->Font->Size)/2+MaxHeight+10;
            else QRExpr->Top=(MaxHeight-QRLabel->Font->Size)/2;
          }
          CurPos=CurPos+int(FP->FieldLength*coef)+6;
        }
        if (!GP->Kind) {
          GroupFooter->Height=GroupFooter->Height*2;
          QRSp->Height=QRSp->Height*2;
        }

      }
    }
  }

//Вставка колонтитулов
//  TQRBand* PageFooter;
  TQRBand* PageHeader;

  TQRSysData* DateData=NULL;
  TQRSysData* TimeData=NULL;
  TQRSysData* PageData=NULL;
  TQRSysData* TitleData=NULL;
  TQRLabel* SimpleLabel=NULL;
  TQRSysData* TempData=NULL;

  CurPos=0;
  if (CBUp->Checked) {
    PageHeader=new TQRBand(Report);
    PageHeader->Parent=Report;
    PageHeader->BandType=rbPageHeader;

    if (SEHeightUp->Value>0) PageHeader->Height=SEHeightUp->Value;
    else PageHeader->Height=UpCFont->Size+10;
    for (int i=0;i<CBoxUp->Items->Count;i++) {
      if (CBoxUp->Checked[i]) {
        if (CBoxUp->Items->Strings[i]!="Просто текст") {
          TempData=new TQRSysData(Report);
          TempData->Font->Assign(UpCFont);
          TempData->AutoSize=true;
          TempData->Parent=PageHeader;
          TempData->Text=((TWTString*)CBoxUp->Items->Objects[i])->String+" ";
          TempData->Top=(PageHeader->Height-TempData->Height)/2;
          TempData->Left=CurPos;
        }
        if (CBoxUp->Items->Strings[i]=="Дата"){
          TempData->Data=qrsDate;
          DateData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Date)",TempData->Font,0)+StringSize("00.00.00",TempData->Font,0)+SEDistUp->Value;
        }
        if (CBoxUp->Items->Strings[i]=="Время"){
          TempData->Data=qrsTime;
          TimeData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Time)",TempData->Font,0)+StringSize("00.00.00",TempData->Font,0)+SEDistUp->Value;
        }
        if (CBoxUp->Items->Strings[i]=="Номер страницы"){
          TempData->Data=qrsPageNumber;
          PageData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Page#)",TempData->Font,0)+StringSize("000",TempData->Font,0)+SEDistUp->Value;
        }
        if (CBoxUp->Items->Strings[i]=="Заголовок отчета"){
          TempData->Data=qrsReportTitle;
          TitleData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Report Title)",TempData->Font,0)+StringSize(Report->ReportTitle,TempData->Font,0)*1.1+SEDistUp->Value;
        }
        if (CBoxUp->Items->Strings[i]=="Просто текст"){
          SimpleLabel=new TQRLabel(PageHeader);
          SimpleLabel->Font->Assign(UpCFont);
          SimpleLabel->AutoSize=true;
          SimpleLabel->Caption=((TWTString*)CBoxUp->Items->Objects[i])->String;
          SimpleLabel->Parent=PageHeader;
          SimpleLabel->Top=(PageHeader->Height-SimpleLabel->Height)/2;
          SimpleLabel->Left=CurPos;
          CurPos=CurPos+SimpleLabel->Width+SEDistUp->Value;
        }
      }
    }
    int Sub;
    CurPos=CurPos-SEDistUp->Value;
    if (ComboUp->ItemIndex==0) {
      Sub=0;
    }
    if (ComboUp->ItemIndex==1) {
      Sub=PageHeader->Width-CurPos;
    }
    if (ComboUp->ItemIndex==2) {
      Sub=(PageHeader->Width-CurPos)/2;
    }
    if (DateData) DateData->Left=DateData->Left+Sub;
    if (TimeData) TimeData->Left=TimeData->Left+Sub;
    if (PageData) PageData->Left=PageData->Left+Sub;
    if (TitleData) TitleData->Left=TitleData->Left+Sub;
    if (SimpleLabel) SimpleLabel->Left=SimpleLabel->Left+Sub;
  }

  DateData=NULL;
  TimeData=NULL;
  PageData=NULL;
  TitleData=NULL;
  SimpleLabel=NULL;
  TempData=NULL;

  CurPos=0;
  if (CBDown->Checked) {
    PageHeader=new TQRBand(Report);
    PageHeader->Parent=Report;
    PageHeader->BandType=rbPageFooter;
    if (SEHeightDown->Value>0) PageHeader->Height=SEHeightDown->Value;
    else PageHeader->Height=DownCFont->Size+10;
    for (int i=0;i<CBoxDown->Items->Count;i++) {
      if (CBoxDown->Checked[i]) {
        if (CBoxDown->Items->Strings[i]!="Просто текст") {
          TempData=new TQRSysData(Report);
          TempData->Font->Assign(DownCFont);
          TempData->AutoSize=true;
          TempData->Parent=PageHeader;
          TempData->Text=((TWTString*)CBoxDown->Items->Objects[i])->String+" ";
          TempData->Top=(PageHeader->Height-TempData->Height)/2;
          TempData->Left=CurPos;
        }
        if (CBoxDown->Items->Strings[i]=="Дата"){
          TempData->Data=qrsDate;
          DateData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Date)",TempData->Font,0)+StringSize("00.00.00",TempData->Font,0)+SEDistDown->Value;
        }
        if (CBoxDown->Items->Strings[i]=="Время"){
          TempData->Data=qrsTime;
          TimeData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Time)",TempData->Font,0)+StringSize("00.00.00",TempData->Font,0)+SEDistDown->Value;
        }
        if (CBoxDown->Items->Strings[i]=="Номер страницы"){
          TempData->Data=qrsPageNumber;
          PageData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Page#)",TempData->Font,0)+StringSize("000",TempData->Font,0)+SEDistDown->Value;
        }
        if (CBoxDown->Items->Strings[i]=="Заголовок отчета"){
          TempData->Data=qrsReportTitle;
          TitleData=TempData;
          CurPos=CurPos+TempData->Width-StringSize(" (Report Title)",TempData->Font,0)+StringSize(Report->ReportTitle,TempData->Font,0)*1.1+SEDistDown->Value;
        }
        if (CBoxDown->Items->Strings[i]=="Просто текст"){
          SimpleLabel=new TQRLabel(Report);
          SimpleLabel->Font->Assign(DownCFont);
          SimpleLabel->AutoSize=true;
          SimpleLabel->Caption=((TWTString*)CBoxDown->Items->Objects[i])->String;
          SimpleLabel->Top=(PageHeader->Height-TempData->Height)/2;
          SimpleLabel->Left=CurPos;
          SimpleLabel->Parent=PageHeader;
          CurPos=CurPos+SimpleLabel->Width+SEDistDown->Value;
        }
      }
    }
    int Sub;
    CurPos=CurPos-SEDistDown->Value;
    if (ComboDown->ItemIndex==0) {
      Sub=0;
    }
    if (ComboDown->ItemIndex==1) {
      Sub=PageHeader->Width-CurPos;
    }
    if (ComboDown->ItemIndex==2) {
      Sub=(PageHeader->Width-CurPos)/2;
    }
    if (DateData) DateData->Left=DateData->Left+Sub;
    if (TimeData) TimeData->Left=TimeData->Left+Sub;
    if (PageData) PageData->Left=PageData->Left+Sub;
    if (TitleData) TitleData->Left=TitleData->Left+Sub;
    if (SimpleLabel) SimpleLabel->Left=SimpleLabel->Left+Sub;
  }

//  if (!TableMenuItem->Items[4]->Checked) {
//  }
  Report->Prepare();
  PF->QRPreview->QRPrinter=Report->QRPrinter;
  //PF->FormStyle=fsMDIChild;
 } catch (...) {
   ShowMessage("Не могу сформировать отчет");
   delete PF;
   delete WaitForm;
//  Report->PreviewModal();
  }

   Application->MainForm->Enabled=true;
   Application->MainForm->Enabled=true;
    Application->MainForm->Enabled=true;

   /* PF->SetFocus();
    Screen->ActiveForm->SetFocus();
     */
     PF->TForm::ShowModal();
   /// ((((((((((((
  ModalResult=mrOk;
   // PF->QRPreview->ZoomToWidth();
//  MainQuery->Close();
//  delete Report;
//  delete PreviewForm;
//  PreviewForm->FormStyle=fsMDIChild;
/*  while (!PreviewForm->Report->QRPrinter);
  PreviewForm->QRPreview->QRPrinter= PreviewForm->Report->QRPrinter;*/
}
// функции класса  TWTFieldProperty
//---------------------------------------------------------------------------
__fastcall TWTFieldProperty::TWTFieldProperty(int FW,TField* Fld,AnsiString NM):TObject() {
  FieldLength=FW;
  Font=new TFont();
  Field=Fld;
  Align=0;
  ModFlag=false;
  Name=NM;
}

//---------------------------------------------------------------------------
__fastcall TWTFieldProperty::~TWTFieldProperty(){
  delete Font;
}

__fastcall TGrpProperty::TGrpProperty():TObject() {
  Otst=0;
  Dist=10;
  IName="ИТОГО";
  Enabled=false;
  Kind=true;
  IsName=true;
  IsValue=true;
  BgColor=clWhite;
  CaptFont=new TFont();
  Fields=new TList();
  Function="sum";
}

__fastcall TGrpProperty::~TGrpProperty() {
  delete CaptFont;
  delete Fields;
}

__fastcall TWTString::TWTString(AnsiString Text) :TObject(){
  String=Text;
}

__fastcall TWTColorButton::TWTColorButton(int LeftC,int TopC,TColor &ColorC,TWinControl* Owner) : TSpeedButton(Owner) {

  WorkColor=&ColorC;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Color");*/

  Width = 73;
  Height = 22;
  Top = TopC;
  Left = LeftC;
  Caption = "Фон";
  Font->Style = Font->Style << fsBold;
  Glyph->LoadFromResourceName(0,"Color");;
  Spacing = 10;
  Parent=Owner;
  OnClick= OnClickButton;
}

void __fastcall TWTColorButton::OnClickButton(TObject* Sender){
  TColorDialog* CD=new TColorDialog(this);
  CD->Color=*WorkColor;
  if (CD->Execute()) *WorkColor=CD->Color;
  delete CD;
}


__fastcall TWTFontButton::TWTFontButton(int LeftC,int TopC,TFont* FontC,TWinControl* Owner) : TSpeedButton(Owner) {

  WorkFont=FontC;

/*  Graphics::TBitmap* BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Font");*/

  Width = 73;
  Height = 22;
  Top = TopC;
  Left = LeftC;
  Caption = "Шрифт";
  Font->Style = Font->Style << fsBold;
  Glyph->LoadFromResourceName(0,"Font");
  Spacing = 10;
  Parent=Owner;
  OnClick= OnClickButton;
}

void __fastcall TWTFontButton::OnClickButton(TObject* Sender){
  TFontDialog* FD=new TFontDialog(this);
  FD->Font->Assign(WorkFont);
  if (FD->Execute()) WorkFont->Assign(FD->Font);
  delete FD;
}
