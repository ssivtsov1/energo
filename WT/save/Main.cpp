//---------------------------------------------------------------------
// ���������� ������������
//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
#include "Message.h"
#include "Query.h"
#include "DBGrid.h"
#include "SprGrid.h"
#include "Func.h"
#include "Form.h"
#include <math.h>
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
//---------------------------------------------------------------------
// ������� ������ TMainForm (�����������)
//---------------------------------------------------------------------

bool __fastcall TMainForm::OnParameters(TWTMDIWindow *Sender,TStringList *CaptionsList,bool *CheckedList){
  AnsiString A="";
  for (int x=0;x<CaptionsList->Count;x++)
     if (CheckedList[x]) A+=CaptionsList->Strings[x]+" ; ";
  ShowMessage(A);
  return 0;
}

//#define WinName "���������� ���������"
_fastcall TMainForm::TMainForm(TComponent *owner) : TWTMainForm(owner) {

  CountWindow = 0;

  // ��������� ������ ����
  // ��������� ���������
  InDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("����������", true, SprTranTable));
  InDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("���������� ����������", true, AccTran));
  InDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("����� ����������", true, ArhTranTable));

  // �������� ���������
  OutDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("��������� ��������", true, SalesArtP));
  OutDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("��������� �������� �� ������", true, SalesArtP));

  // �����������
  ServiseMenuItem->Add(CreateMenuItem("���������� ���������", true, SprArtTable));
  ServiseMenuItem->Add(CreateMenuItem("���������� ����", true, SprKassTable));
  ServiseMenuItem->Add(CreateMenuItem("���������� �������������", true, SprPodrTable));

  // ��������� ������ (����� ��� ���������� ����� � ������)
  QueryTmp = new  TWTQuery(this);


  TWTToolBar* TB=new TWTToolBar(this);
  TB->Parent=MainCoolBar;
  TB->ID="������� ������";

  // ��������� ������ � ������� ������
  TB->AddButton("Tranz", "����������", SprTranTable);
  TB->AddButton("SaveTranz", "���������� ����������", AccTran);
  TB->AddButton("PerTranz", "����� ����������", ArhTranTable);
  TB->AddButton("|", NULL, NULL);
  TB->AddButton("Articul", "��������� ��������", SalesArtP);
  TB->AddButton("PerArticul", "��������� �������� �� ������", SalesArtP);
  TB->AddButton("|", NULL, NULL);
  TB->AddButton("SprArt", "���������� ���������", SprArtTable);
  TB->AddButton("SprKass", "���������� ����", SprKassTable);
  TB->AddButton("SprPodr", "���������� �������������", SprPodrTable);
  TB->AddButton("Filter", "�������� ��������", ShowDoc);

  MainCoolBar->AddToolBar(TB);

/* */ // ��������� ������ � ������� ������
  /*AddButton("|", NULL, NULL,0);
  AddButton("Filter", "�������� ��������", ShowDoc,0);
  AddButton("SprPodr", "���������� �������������", SprPodrTable,0);
  AddButton("SprKass", "���������� ����", SprKassTable,0);
  AddButton("SprArt", "���������� ���������", SprArtTable,0);
  AddButton("|", NULL, NULL,0);
  Button2=AddButton("PerArticul", "��������� �������� �� ������", SalesArtP,0);
  Button1=AddButton("Articul", "��������� ��������", SalesArtP,0);
  AddButton("|", NULL, NULL,0);
  AddButton("PerTranz", "����� ����������", ArhTranTable,0);
  AddButton("SaveTranz", "���������� ����������", AccTran,0);
  AddButton("Tranz", "����������", SprTranTable,0);*/
    
  //������������ ����� � ����������� �������
      /*
  TWTBrowseRegItem *BRI=new TWTBrowseRegItem("SprArt","articles");

  BRI->AddLookupField("namegrp","plu_grp","sp_grtov","name");
  BRI->AddLookupField("nameizm","kod_izm","sp_izm","name");

  TWTRegCol *RC;

  RC=BRI->AddColumn("plu_cod","��� ���.","��� ��������");
  RC->SetUnique("����� ������������ ���", "articles");
  RC->SetRequired("��� �������� ������ ���� ��������");
  RC->SetFill(0,'0');

  BRI->AddColumn("plu_bar","�����-��� ���.","�����-��� ��������");
  RC=BRI->AddColumn("plu_ime","������. ���.","������������ ��������");
  RC->SetRequired("������������ �������� ������ ���� ���������");

  RC=BRI->AddColumn("plu_cen","����","����");
  RC->SetRequired("���� �������� ������ ���� ���������");

  BRI->AddColumn("plu_qty","����������","����������");
  RC = BRI->AddColumn("plu_stn","�����","�����");
  RC->SetRange(1,9,"��������� ������������ ���������");
  RC->SetRequired("����� ������ ���� ��������");

  RC = BRI->AddColumn("plu_grp","������. ���.","������ ���������");
  RC->SetOnHelp(GuideGrpTable);
  RC->SetRequired("������ ��������� ������ ���� ���������");

  RC=BRI->AddColumn("namegrp","������. ������","������������ ������ ���������");
  RC->SetOnHelp(GuideGrpTable);

  RC = BRI->AddColumn("plu_vat","�����. ������.","��������� ������");
  RC->SetRange(1,8);
  RC->SetRequired("��������� ������ ������ ���� ���������");

  RC = BRI->AddColumn("plu_edp","���. ������.","����������� ������");
  RC->AddFixedVariable("1","��");
  RC->AddFixedVariable("0","���");
  RC->SetDefValue(0);

  RC = BRI->AddColumn("point","�������/�������","�������/�������");
  RC->AddFixedVariable("True","�������");
  RC->AddFixedVariable("False","�������");
  RC->SetDefValue("False");

  RC = BRI->AddColumn("plu_nul","����. ������","������ ������ ��� ������������� ����������");
  RC->AddFixedVariable("1","��");
  RC->AddFixedVariable("0","���");
  RC->SetDefValue(0);

  RC = BRI->AddColumn("kod_izm","��. ���.","������a ���������");
  RC->SetOnHelp(GuideIzmTable);
  RC->SetRequired("������� ��������� ������ ���� ���������");

  RC=BRI->AddColumn("nameizm","������. ��.���.","������������ ������� ���������");
  RC->SetOnHelp(GuideIzmTable);

  BRI->AddColumn("name","������ ������. ���.","������ ������������ ������");
  BRI->AddColumn("kas_list","������ ����","������ ����");
  RC=BRI->AddColumn("unlocked","����. ������","���������� ������");
  RC->AddFixedVariable("True","��");
  RC->AddFixedVariable("False","���");
  RC->SetDefValue("True");

  BRI->Caption="WinName";
  Registry->AddItem(BRI);
  OnShowActiveWindows=ShowActiveWindows;*/

}

_fastcall TMainForm::~TMainForm(){
}

void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs){
  if (WindowsIDs->IndexOf("SprArt")!=-1) SprArtTable(NULL);
  if (WindowsIDs->IndexOf("SprKass")!=-1) SprKassTable(NULL);
  if (WindowsIDs->IndexOf("SprPodr")!=-1) SprPodrTable(NULL);
  AnsiString aa=StartupIniFile->ReadString("Data","ActiveWindow","");
  ShowMDIChild(aa);
}

void __fastcall TMainForm::ShowDoc(TObject *Sender){


/*  TStringList* SL=new TStringList();
  SL->Add("select plu_cod,plu_cen from articles");
  TWTWinDBGrid* DD=new TWTWinDBGrid(this,SL);
  DD->DBGrid->Query->Open();
  DD->DBGrid->Visible=true;

  SL->Clear();
  SL->Add("select plu_ime,plu_cen,plu_bar from articles");
  DD->DBGrid->Query->SetSQLSelect(SL);
  DD->DBGrid->Query->Open();

  return;*/
  TWTDoc *Doc=new TWTDoc(Application,"Reports\\TestDoc.dof");

  TWTDBGrid* Grid=new TWTDBGrid(Doc,"articles.db");
  Grid->Table->Open();

  TWTPanel* P=Doc->MainPanel->InsertPanel(100,true,20);
  TWTPanel* PP;
  TFont* F=new TFont();
  F->Size=16;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  P->Params->AddText("EXAMPLE",100,F,Classes::taCenter,true)->ID="NAME";

  PP=Doc->MainPanel->InsertPanel(100,true,0.5);
  PP->Params->AddGrid(Grid,true)->ID="GRID";

  Grid=new TWTDBGrid(Doc,"articles.db");
  Grid->Table->Open();
  PP=Doc->MainPanel->InsertPanel(100,true,0.5);
  PP->Params->AddText("EXAMPLE2",100,NULL,Classes::taCenter,true)->ID="NAME";
  PP->Params->AddGrid(Grid,true)->ID="GRID2";

  delete F;

  P=Doc->MainPanel->InsertPanel(100,true,10);
  P->Params->AddSimple("��� 1",40,"")->ID="KOD1";
  P->Params->AddSimple("������������ 1",150,"")->ID="NAME1";
  P=Doc->MainPanel->InsertPanel(100);
  P->Params->AddSimple("��� 2",40,"")->ID="KOD2";
  P->Params->AddSimple("������������ 2",150,"")->ID="NAME2";
  P=Doc->MainPanel->InsertPanel(100,true,10);
  P->Params->AddSimple("��� 3",40,"")->ID="KOD3";
  P->Params->AddSimple("������������ 3",150,"")->ID="NAME3";
  P=Doc->MainPanel->InsertPanel(100);
  P->Params->AddSimple("��� 4",40,"")->ID="KOD4";
  P->Params->AddSimple("������������ 4",150,"")->ID="NAME4";
  Doc->ShowAs("TestDoc");
//  Doc->FormStyle=fsMDIChild;
  Doc->SetCaption("�������� ��������"); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  Doc->LoadFromFile(Doc->DocFile);
  Doc->Constructor=true;

//  PP->AlignByClient=true;
}


void _fastcall TMainForm::OnGetText123(TField* Sender, AnsiString
 &Text, bool DisplayText) {

 TStringList *SL=new TStringList();
 SL->Add("ProcessValue('It is true','It is false')");

 Value = Sender->AsString;

// TWTTPC *TP=new TWTTPC(this);
// TPComp->Process(SL);

 Text = Result;
 delete SL;
// delete TP;
}
//---------------------------------------------------------------------
#define WinName "���������� ���������"
void _fastcall TMainForm::SprArtTable(TObject *Sender) {
  SprArtTableF(NULL);
}

void _fastcall TMainForm::SprArtTableF(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

   // TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  // ���� ����� ���� ���� - ������������ � �������

  if (ShowMDIChild(WinName)) {
    return;
  }
   TWTWinDBGrid *DBGrid = new TWTWinDBGrid(this, CreateFullTableName("ARTICLES"),false);

   //DBGrid=ShowBrowse("SprArt");
 // TWTWinDBGrid *DBGrid = new TWTWinDBGrid(this, CreateFullTableName("ARTICLES"),false);

  //DBGrid->SetCaption(WinName);

  //TWTTable* Table = DBGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������

  DBGrid->DBGrid->Table->Open();

  TWTField *Field;



  Field = DBGrid->AddColumn("PLU_COD", "���", "��� ��������");
  Field->SetUnique("����� ��� ������������ � �����������", FullTableName("ARTICLES"));
  Field->SetRequired("��� ������ ���� ��������");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "099999";

  Field = DBGrid->AddColumn("PLU_BAR", "�����-���", "�����-��� ��������");
  Field->Field->EditMask = "9999999999999";

  Field = DBGrid->AddColumn("PLU_IME", "�������", "������������ ��������");
  Field->SetRequired("������������ �������� ������ ���� ���������");

  Field = DBGrid->AddColumn("PLU_CEN", "����", "����");
  Field->SetRequired("���� �������� ������ ���� ���������");
  Field->Precision = 2;

  Field = DBGrid->AddColumn("PLU_QTY", "����������", "���������� ������ ������ ��� �������");
  Field->Precision = 3;

  Field = DBGrid->AddColumn("PLU_STN", "�����", "�����");
  Field->SetRange(1,9, "�������� ������ ���� � ��������� �� 1 �� 9");
  Field->SetRequired("����� ������ ���� ��������");
  Field->Field->EditMask = "0";

  Field = DBGrid->AddColumn("PLU_GRP", "���", "��� ������ ���������");
  //Field->SetOnHelp(SprGrpArt);
  Field->SetRequired("������ ��������� ������ ���� ���������");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "09";
    /*
  Field = DBGrid->AddColumn("NAME_GRTOV", "������ ���������", "������������ ������ ���������");
  //Field->SetOnHelp(SprGrpArt);

  Field = DBGrid->AddColumn("PLU_VAT", "�����", "��������� ������");
  Field->SetRange(1,8, "�������� ������ ���� � ��������� �� 1 �� 8");
  Field->SetRequired("��������� ������ ������ ���� ���������");
  Field->SetDefValue(1);
  Field->Field->EditMask = "0";

  Field = DBGrid->AddColumn("PLU_EDP", "���. ������", "����������� ������");
  Field->AddFixedVariable("0", "���");
  Field->AddFixedVariable("1", "��");
  Field->SetDefValue("0");

  Field = DBGrid->AddColumn("POINT", "�����", "�������/�������");
  Field->AddFixedVariable("False", "�������");
  Field->AddFixedVariable("True", "�������");
  Field->SetDefValue(false);

  Field = DBGrid->AddColumn("PLU_NUL", "��������", "������ ������ ��� ������������� ����������");
  Field->AddFixedVariable("0", "����");
  Field->AddFixedVariable("1", "���");
  Field->SetDefValue("0");

  Field = DBGrid->AddColumn("KOD_GRP", "�����.��", "������� ������ ������");
  //Field->SetOnHelp(SprGrpCalc);
  Field->SetRequired("������� ������ ������ ���� ���������");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "09";

  Field = DBGrid->AddColumn("NAME_GRP_R", "������", "������������ ������� ������ ������");
  //Field->SetOnHelp(SprGrpCalc);

  Field = DBGrid->AddColumn("KOD_IZM", "���", "��� ������� ���������");
// Field ->SetOnHelp(SprIzm);
  Field->SetRequired("������� ��������� ������ ���� ���������");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "09";

  Field = DBGrid->AddColumn("NAME_IZM", "��.���", "������������ ������� ���������");
  //Field->SetOnHelp(SprIzm);
   */
  DBGrid->AddColumn("NAME", "������������ ������", "������ ������������ ������");
  DBGrid->AddColumn("KAS_LIST", "������ ����", "������ �������� ���������");
     /*
  Field = DBGrid->AddColumn("UNLOCKED", "�������", "���������� ������� �������� ���������");
  Field->AddFixedVariable("True", "���������");
  Field->AddFixedVariable("False", "���������");
  Field->SetDefValue(true);
       */
  DBGrid->DBGrid->FieldSource = DBGrid->DBGrid->Table->GetTField("PLU_COD");
  DBGrid->DBGrid->FieldDest = Sender;
  /*DBGrid->DBGrid->Visible = true;
  //DBGrid->FormStyle = fsMDIChild;
   DBGrid->ShowAs("SPR_ART");      */
     DBGrid->SetCaption(WinName);
//  DBGridMission2->StatusBar->SimplePanel= true;
//  DBGridMission2->StatusBar->Panels->Items[0]->Text= DBGridMission2->List->Items->Strings[0];
  DBGrid->DBGrid->Visible = true;
  //ShowBrowse("SprArt");
  //DBGrid->DBGrid->Visible = true;
  DBGrid->DBGrid->SetFocus();


};

//---------------------------------------------------------------------------
#define WinName "���������� ������ ���������" //��� ����������� ���������
void __fastcall TMainForm::GuideIzmTable(TWTField* Sender) {
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName)) {
    return;
  }
  // ������� �����
  DBGridGuide1 = new TWTWinDBGrid(this,"sp_izm");

  DBGridGuide1->DBGrid->Visible= false;
  DBGridGuide1->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridGuide1->AddColumn("kod","��� ��. ���.","");
  Field->SetUnique("������ ��. ��������� ��� ������������ � �����������", "sp_izm");
  Field->SetRequired("��� ������� ��������� ������ ���� ��������");
  Field=DBGridGuide1->AddColumn("name","������������","");

  DBGridGuide1->DBGrid->FieldSource = DBGridGuide1->DBGrid->Table->GetTField("kod");
  DBGridGuide1->DBGrid->FieldDest = DBGridMission1->DBGrid->Table->GetTField("kod_izm");
  DBGridGuide1->SetCaption(WinName);
//  DBGridGuide1->DBGridd= DBGridMission1->DBGrid;
  DBGridGuide1->DBGrid->Visible = true;
  DBGridGuide1->DBGrid->SetFocus();
}

//---------------------------------------------------------------------------
#define WinName "���������� ����� ���������" //��� ����������� ���������
void __fastcall TMainForm::GuideGrpTable(TWTField* Sender) {
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName)) {
    return;
  }
  // ������� �����
  DBGridGuide2 = new TWTSprDBGrid(DBGridMission1, "sp_grtov");

  DBGridGuide2->DBGrid->Visible= false;
  DBGridGuide2->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridGuide2->AddColumn("kod","��� ������","");
  Field->SetUnique("������ ������ ��� ������������ � �����������", "sp_izm");
  Field->SetRequired("��� ������ ������ ���� ��������");
  DBGridGuide2->AddColumn("name","������������","");

  DBGridGuide2->FieldSource = DBGridGuide2->DBGrid->Table->GetTField("kod");
  DBGridGuide2->FieldDest = DBGridMission1->DBGrid->Table->GetTField("plu_grp");

  DBGridGuide2->DBGridd= DBGridMission1->DBGrid;
  DBGridGuide2->DBGrid->Visible = true;
  DBGridGuide2->SetCaption(WinName);
  DBGridGuide2->DBGrid->SetFocus();
}

//---------------------------------------------------------------------------
#define WinName "���������� ����"
void _fastcall TMainForm::SprKassTable(TObject *Sender) {
  // ���� ����� ���� ���� - ������������ � �������
/*  if (ShowMDIChild(WinName)) {
    return;
  }*/

/*  TWTParamsForm *PF=new TWTParamsForm(Application,"sfghfgh");
  PF->Params->AutoBreak=true;
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"")->SetButton(NULL);
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",500,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->ShowModal();
  return;

/*  TWTCheckingForm *CF=new TWTCheckingForm(Application,"Parameters");
  CF->AddItem("aaaaaaaaaaaaaaaaaa",true);
  CF->AddItem("bbbbbbbbbbb",false);
  CF->AddItem("ccccccccccccc",false);
  CF->AddItem("ddddddddddddddddd",true);
  CF->AddItem("eeeeeeeeeeeee",false);
  CF->AddItem("ffffffffffffffffffff",true);
  CF->FormStyle=fsMDIChild;
  CF->OnAccept=OnParameters;
//  CF->TForm::ShowMod();*/

/*  TStringList *SL=new TStringList();
  SL->Add("Select plu_cod,plu_grp from articles");

  DBGridMission2=new TWTWinDBGrid(this,SL);
  DBGridMission2->DBGrid->Query->AddLookupField("namegrp","plu_grp","sp_grtov","name");

  DBGridMission2->DBGrid->Query->Open();

  DBGridMission2->AddColumn("plu_cod","Kod art");
  DBGridMission2->AddColumn("plu_grp","Gruppa");
  TWTField *Field;
  Field=DBGridMission2->AddColumn("namegrp","Imya gruppi");*/


//  return;
//################################################################################
/*  TStringList *SS=new TStringList();
  SS->Add("select plu_cod,plu_ime from articles");*/
/*  DBGridMission2=new TWTWinDBGrid(this,"articles");
  DBGridMission2->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridMission2->AddColumn("plu_cod","Kod","Kod articula");
  Field->AddFixedVariable("001001","ffffff");
  Field->AddFixedVariable("001002","aaaaaa");
  Field=DBGridMission2->AddColumn("plu_ime","Name","Name articula");
  Field=DBGridMission2->AddColumn("unlocked","����. ������","���������� ������");
  Field->AddFixedVariable("True","��");
  Field->AddFixedVariable("False","���");
  Field->SetReadOnly();
  DBGridMission2->AlignWidth();*/
//################################################################################


  DBGridMission2 = new TWTWinDBGrid(this, "sp_cash",false);
  DBGridMission2->DBGrid->Visible= false;

  TWTTable* Table=DBGridMission2->DBGrid->Table;
  Table->AddLookupField("NameKodPodr","kod_podr","sp_podr","name");

  DBGridMission2->DBGrid->Table->Open();

//  TWTField *Field;
  TWTField* Field=DBGridMission2->AddColumn("s_num","�����","��������� ����� �����");
  Field->SetRequired("��������� ����� ����� ������ ���� ��������");
  Field=DBGridMission2->AddColumn("num","�����","����� �����");
  Field->SetUnique("������ ����� ����� ��� ������������ � �����������", "sp_cash");
  Field->SetRequired("����� ����� ������ ���� ��������");

  Field=DBGridMission2->AddColumn("port","����","");
  Field->SetRequired("���� ������ ���� ��������");
  Field=DBGridMission2->AddColumn("kod_podr","���","��� ������");
  Field->SetOnHelp(GuidePodrKasTable);
  Field->SetRequired("��� ������ ������ ���� ��������");

  DBGridMission2->AddColumn("NameKodPodr","������. ������","������������ ������");

  Field=DBGridMission2->AddColumn("cash_type","���","��� �����");
  Field->SetRequired("��� ����� ������ ���� ��������");
  Field->AddFixedVariable("0", "Samsung On-Line");
  Field->AddFixedVariable("1", "Samsung � ����������");
  Field->AddFixedVariable("2", "Samsung On-Line");
  Field->AddFixedVariable("3", "Datesc On-Line");
  Field->AddFixedVariable("4", "Samsung ���������� �������");
  Field->AddFixedVariable("5", "Samsung � CashDrive");
  Field->AddFixedVariable("6", "Datecs � CashDrive");
  Field->AddFixedVariable("7", "Datesc On-Line � ����������");
  Field->AddFixedVariable("8", "Datesc ���������� �������");
  Field->AddFixedVariable("A", "��� 101.10 On-Line");
  Field->AddFixedVariable("B", "��� 101.10 On-Line ��������");
  Field->AddFixedVariable("C", "��� 101.10 ���������� �������");
  Field->AddFixedVariable("D", "��� 101.10 � CashDrive");
  Field->AddFixedVariable("E", "��� 101.10 � ����������");
  Field->AddFixedVariable("S", "Silex On-Line");
  Field->AddFixedVariable("T", "Silex ���������� �������");
  Field->AddFixedVariable("M", "Mini");
  Field->AddFixedVariable("N", "Mini � CashDrive");

  DBGridMission2->AddColumn("anal_table","��� �������","��� ������� ���������");
  DBGridMission2->AddColumn("anal_name","������. ���������","������������ ���������");
  DBGridMission2->AddColumn("key_field","���� ���� ���������","");
  DBGridMission2->AddColumn("info_field","������. ���������","������������ ���������");
  DBGridMission2->AddColumn("init_text","�������. ���������","������������� ���������");
  DBGridMission2->AddColumn("final_text","����� ���������","");
  DBGridMission2->AddColumn("key_len","����� ����. ����","����� ��������� ����");

  DBGridMission2->SetCaption(WinName);
//  DBGridMission2->StatusBar->SimplePanel= true;
//  DBGridMission2->StatusBar->Panels->Items[0]->Text= DBGridMission2->List->Items->Strings[0];
  DBGridMission2->ShowAs("SprKass");
  DBGridMission2->DBGrid->Visible = true;
  DBGridMission2->DBGrid->SetFocus();
}

#define WinName "���������� ������������� (��� ����������� ����)" //��� ����������� ����
void __fastcall TMainForm::GuidePodrKasTable(TWTField* Sender) {
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName)) {
    return;
  }
  // ������� �����
  DBGridGuide6 = new TWTSprDBGrid(DBGridMission2, "sp_podr");
  DBGridGuide6->DBGrid->Visible= false;
  DBGridGuide6->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridGuide6->AddColumn("kod","��� �������������","");
  Field->SetUnique("������������� ��� ������������ � �����������", "sp_podr");
  Field->SetRequired("��� �������������  ������ ���� ��������");
  DBGridGuide6->AddColumn("name","������������","");

  AnsiString Value;
  DBGridGuide6->SetCaption(WinName);
  DBGridGuide6->DBGrid->FieldSource = DBGridGuide6->DBGrid->Table->GetTField("kod");
  DBGridGuide6->DBGrid->FieldDest = DBGridMission2->DBGrid->Table->GetTField("kod_podr");
  Value=DBGridMission2->DBGrid->Table->GetField("kod_podr")->AsString;
//  DBGridGuide6->DBGridd= DBGridMission2->DBGrid;
  DBGridGuide6->DBGrid->Visible = true;
  DBGridGuide6->DBGrid->SetFocus();
}

//---------------------------------------------------------------------
#define WinName "���������� �������������"
void _fastcall TMainForm::SprPodrTable(TObject *Sender) {
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName)) {
    return;
  }
  // ������� �����
  DBGridMission3 = new TWTWinDBGrid(this, "sp_podr",false);
  DBGridMission3->DBGrid->Visible= false;
  DBGridMission3->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridMission3->AddColumn("kod","���","��� �������������");
  Field->SetUnique("������������� ��� ������������ � �����������", "sp_podr");
  Field->SetRequired("��� �������������  ������ ���� ��������");
  DBGridMission3->AddColumn("name","������������","������������ �������������");

  Field=DBGridMission3->AddColumn("priz","��� ������","������� ������/ ���������");
  Field->AddFixedVariable("0","�������");
  Field->AddFixedVariable("1","�������");
  Field->AddFixedVariable("2","�����");
  Field->AddFixedVariable("3","������ �������");

  DBGridMission3->ShowAs("SprPodr");
  DBGridMission3->SetCaption(WinName);
  DBGridMission3->DBGrid->Visible = true;
//  DBGridMission3->StatusBar->SimplePanel= true;
//  DBGridMission3->StatusBar->Panels->Items[0]->Text= DBGridMission3->List->Items->Strings[0];
  DBGridMission3->DBGrid->SetFocus();
}

//---------------------------------------------------------------------
#define WinName "T���������"
void _fastcall TMainForm::SprTranTable(TObject *Sender) {

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName)) {
    return;
  }

  // ������� �����
  DBGridMission4 = new TWTWinDBGrid(this, "trans");
  DBGridMission4->DBGrid->Visible= false;

  TWTTable* Table=DBGridMission4->DBGrid->Table;
  Table->AddLookupField("nkod","kod_podr","sp_podr","name");
  Table->AddLookupField("namek","kod","sp_tran","name");
  TField* FField=Table->AddLookupField("ncod","article","articles","name")->Field;
  FField->LookupKeyFields = "plu_cod";
  Table->AddLookupField("nerror","error_code","sp_error","name");

  DBGridMission4->DBGrid->SetReadOnly();
  DBGridMission4->DBGrid->TimerOn= false;
  DBGridMission4->DBGrid->Timer->Enabled= false;
  DBGridMission4->DBGrid->Table->Open();

  TWTField* Field;
  DBGridMission4->AddColumn("kassa","�����","����� �����");
  DBGridMission4->AddColumn("kasa_sn","�����","��������� ����� �����");
  DBGridMission4->AddColumn("kod_podr","���","��� ������");
  DBGridMission4->AddColumn("nkod","������. ������","������������ ������");
  DBGridMission4->AddColumn("counter","�������","");
  DBGridMission4->AddColumn("kod","���","��� ����������");
  DBGridMission4->AddColumn("namek","������. �����.","������������ ����������");
  DBGridMission4->AddColumn("article","���","��� ������");
  DBGridMission4->AddColumn("ncod","������. ������","������������ ������");
  DBGridMission4->AddColumn("plu_cen","����","���� ������");
  DBGridMission4->AddColumn("plu_qty","���-��","��������� ����������");
  DBGridMission4->AddColumn("d_otchet","����","���� �������");
  DBGridMission4->AddColumn("t_otchet","�����","����� �������");
  Field=DBGridMission4->AddColumn("valid","������������","������� ������������");
  Field->AddFixedVariable("True","��");
  Field->AddFixedVariable("False","���");

  Field=DBGridMission4->AddColumn("error_code","���","��� ������");
  Field->SetReadOnly();

  DBGridMission4->AddColumn("nerror","������. ������","������������ ������");
  DBGridMission4->AddColumn("analit","��� ���������","");
  DBGridMission4->AddColumn("count_acc","�������","������� ����������");

  DBGridMission4->SetCaption(WinName);
  DBGridMission4->DBGrid->Visible = true;
//  DBGridMission4->StatusBar->SimplePanel= true;
//  DBGridMission4->StatusBar->Panels->Items[0]->Text= DBGridMission4->List->Items->Strings[0];
  DBGridMission4->DBGrid->SetFocus();
}

//---------------------------------------------------------------------------
// ���������� ����������
void _fastcall TMainForm::AccTran(TObject *Sender) {

  TForm * MF = new TForm(this);
  MF->Width= 300;
  MF->Height = 100;
  MF->Position= poScreenCenter;
  MF->Visible= true;
  TLabel *Label = new TLabel(this);
  Label->Left = 20;
  Label->Top= 30;
  Label->Font->Size= -13;
  Label->Caption= "���� ������� ���������� ����������";
  Label->Parent= MF;
  Application->ProcessMessages();

  Screen->Cursor= crSQLWait;
  TStringList *SQL= new TStringList();
  SQL->Add("UPDATE TRANS SET COUNT_ACC=0 WHERE COUNT_ACC is Null");
  TWTQuery *QueryAcc = new TWTQuery(this, SQL);
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add("UPDATE TRANS SET COUNT_ACC= COUNT_ACC + 1");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" INSERT INTO 'DE_TRANS.DB' (KASSA, KOD_PODR, KASA_SN, COUNTER, KOD, ");
  QueryAcc->SQL->Add(" ARTICLE, PLU_CEN, PLU_QTY, SUMMA, ");
  QueryAcc->SQL->Add(" D_OTCHET, T_OTCHET, VALID, ERROR_CODE, ANALIT, COUNT_ACC) ");
  QueryAcc->SQL->Add("  SELECT  KASSA, KOD_PODR, KASA_SN, COUNTER, KOD, ");
  QueryAcc->SQL->Add("  ARTICLE, PLU_CEN, PLU_QTY, SUMMA, ");
  QueryAcc->SQL->Add("  D_OTCHET, T_OTCHET, VALID, ERROR_CODE, ANALIT, COUNT_ACC ");
  QueryAcc->SQL->Add("  FROM 'TRANS.DB' Tr WHERE Tr.COUNT_ACC > 0");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" DELETE FROM ART_OTC WHERE ART_OTC.'DATE' IN ");
  QueryAcc->SQL->Add(" (SELECT DISTINCT D_OTCHET FROM TRANS)");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" INSERT INTO 'ART_OTC.DB' ('ART_OTC.DB'.'DATE', KOD_PODR, KASSA, ");
  QueryAcc->SQL->Add(" ART_COD, SUMMA, KOLVO, PRICE) ");
  QueryAcc->SQL->Add(" SELECT D_OTCHET, KOD_PODR, KASSA, ARTICLE, ");
  QueryAcc->SQL->Add(" SUM(SUMMA) as SUM1 , SUM(PLU_QTY) as SUM2, PLU_CEN ");
  QueryAcc->SQL->Add(" FROM 'DE_TRANS.DB' ");
  QueryAcc->SQL->Add(" WHERE (KOD=1 OR KOD= 7) AND VALID= True ");
  QueryAcc->SQL->Add(" GROUP BY D_OTCHET, KOD_PODR, KASSA, ARTICLE, PLU_CEN ");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" DELETE FROM TRANS WHERE TRANS.COUNT_ACC > 0");
  QueryAcc->ExecSQL();

  Screen->Cursor= crArrow;
  MF->Close();
  DEL(SQL);
  ShowMessage("���������� ���������� ���������");
}

//---------------------------------------------------------------------
#define WinName "����� ����������"
void _fastcall TMainForm::ArhTranTable(TObject *Sender) {

  TDateTime DateTime;
  DateTime = StrToDate(DateToStr(Date()), NULL);
  if (!GetDate("������� ����", &DateTime)) {
    return;
  }

  AnsiString S= "����� ���������� �� ������� �� " +DateTime;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(S)) {
    return;
  }

  // ������� �����
  DBGridMission4 = new TWTWinDBGrid(this, "de_trans");
  DBGridMission4->DBGrid->Visible= false;

  TWTTable* Table=DBGridMission4->DBGrid->Table;
  Table->AddLookupField("nkod","kod_podr","sp_podr","name");
  Table->AddLookupField("namek","kod","sp_tran","name");
  TField* FField=Table->AddLookupField("ncod","article","articles","name")->Field;
  FField->LookupKeyFields = "plu_cod";
  Table->AddLookupField("nerror","error_code","sp_error","name");

  DBGridMission4->DBGrid->SetReadOnly();
  DBGridMission4->DBGrid->TimerOn= false;
  DBGridMission4->DBGrid->Timer->Enabled= false;
  DBGridMission4->DBGrid->Table->Filter= "d_otchet= " + DateToStr(DateTime);
  DBGridMission4->DBGrid->Table->Filtered= true;
  DBGridMission4->DBGrid->Table->Open();

  TWTField* Field;
  DBGridMission4->AddColumn("kassa","�����","����� �����");
  DBGridMission4->AddColumn("kasa_sn","�����","��������� ����� �����");
  DBGridMission4->AddColumn("kod_podr","���","��� ������");
  DBGridMission4->AddColumn("nkod","������. ������","������������ ������");
  DBGridMission4->AddColumn("counter","�������","�������");
  DBGridMission4->AddColumn("kod","���","��� ����������");
  DBGridMission4->AddColumn("namek","������. �����.","������������ ����������");
  DBGridMission4->AddColumn("article","���","��� ������");
  DBGridMission4->AddColumn("ncod","������. ������","������������ ������");
  DBGridMission4->AddColumn("plu_cen","����","���� ������");
  DBGridMission4->AddColumn("plu_qty","���-��","��������� ����������");
  DBGridMission4->AddColumn("summa","�����","");
  DBGridMission4->AddColumn("d_otchet","����","���� �������");
  DBGridMission4->AddColumn("t_otchet","�����","����� �������");
  Field=DBGridMission4->AddColumn("valid","������������","������� ������������");
  Field->AddFixedVariable("True","��");
  Field->AddFixedVariable("False","���");

  Field=DBGridMission4->AddColumn("error_code","���","��� ������");
  Field->SetReadOnly();

  DBGridMission4->AddColumn("nerror","������. ������","������������ ������");
  DBGridMission4->AddColumn("analit","��� ���������","��� ���������");
  DBGridMission4->AddColumn("count_acc","�������","������� ����������");

  DBGridMission4->SetCaption(S);
  DBGridMission4->DBGrid->Visible = true;
//  DBGridMission4->StatusBar->SimplePanel= true;
//  if (DBGridMission4->List) DBGridMission4->StatusBar->Panels->Items[0]->Text= DBGridMission4->List->Items->Strings[0];
  DBGridMission4->DBGrid->SetFocus();

}

//---------------------------------------------------------------------
void __fastcall TMainForm::Sales(AnsiString S) {

  DBGridMissionS->AddColumn("KOD_PODR","���","��� �������������");
  DBGridMissionS->AddColumn("NKOD","������. ����.","������������ �������������");
  DBGridMissionS->AddColumn("KASSA","�����","����� �����");
  DBGridMissionS->AddColumn("ART_COD","���","��� ��������");
  DBGridMissionS->AddColumn("NCOD","������. ���.","������������ ��������");
  DBGridMissionS->AddColumn("PRICE","����","���� ��������");
  DBGridMissionS->AddColumn("KOLVO","���-��","��������� ����������");
  DBGridMissionS->AddColumn("SUMMA","�����","");
  DBGridMissionS->SetCaption(S);
  DBGridMissionS->DBGrid->Visible = true;
//  DBGridMissionS->StatusBar->SimplePanel= true;
//  DBGridMissionS->StatusBar->Panels->Items[0]->Text= DBGridMissionS->List->Items->Strings[0];
  DBGridMissionS->DBGrid->SetFocus();
}

//---------------------------------------------------------------------
#define WinName= ��������� �������� �� ������.
void _fastcall TMainForm::SalesArtP(TObject *Sender) {
  Form=new TWTParamsForm(this,"����� ����������");
  Form->OnAccept=OnOkClick;

  TStringList *SQL = new TStringList();
  SQL->Add("SELECT KOD, NAME FROM SP_PODR ORDER BY KOD");
  SprQuery=new TWTQuery(Form,SQL);
  SprQuery->Open();

  TWTParamItem* PI=Form->Params->AddSimple("��� ��������",50,"",true);
  PI->SetRequired(SprQuery,"kod");
  PI->SetButton(FOnClick);
  Form->Params->AddDb("�������",SprQuery,"name",200,true)->SetReadOnly(true);
  Form->Params->AddDate("���� �",50,true);
  if (Sender==Button2) Form->Params->AddDate("��",50,false);
  if (Form->TForm::ShowModal()!=5) {
    delete Form;
    return;
  }
}

void _fastcall TMainForm::OnOkClick(TWTParamsForm* Sender,bool &CloseFlag){
  AnsiString S1= Form->Params->Get(0)->Value;
  AnsiString S2= Form->Params->Get(2)->Value;
  AnsiString S3;
  if (Form->Params->Count==4) S3= Form->Params->Get(3)->Value;
  else S3=S2;

  TStringList *SQL = new TStringList();
  SQL->Add("SELECT * FROM  SP_PODR ");
  SQL->Add("WHERE KOD = " + ToStrSQL(S1));
  QueryTmp->SetSQLSelect(SQL);
  QueryTmp->Open();

  AnsiString S;
  if (Form->Params->Count==4) S= "��������� �������� c " +S2+ " �� " +S3+ " �� �������� "+ QueryTmp->Fields->Fields[1]->AsString;
  else S= "��������� �������� �� " +S2+ " �� �������� "+ QueryTmp->Fields->Fields[1]->AsString;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(S)) {
    return;
  }

  // ������� �����
  DBGridMissionS = new TWTWinDBGrid(this);

  // ��������� ������� �� ����
  SQL->Clear();
  SQL->Add(" SELECT ART_OTC.KOD_PODR, SP_PODR.NAME as NKOD, KASSA, ");
  SQL->Add(" ART_COD, ARTICLES.NAME as NCOD, PRICE,");
  SQL->Add(" KOLVO, SUMMA ");
  SQL->Add(" FROM (ART_OTC LEFT JOIN  SP_PODR ");
  SQL->Add(" ON ART_OTC.KOD_PODR = SP_PODR.KOD) ");
  SQL->Add(" LEFT JOIN ARTICLES ON ART_OTC.ART_COD = ARTICLES.PLU_COD ");
  SQL->Add(" WHERE ART_OTC.'DATE' >= :dates  AND ART_OTC.'DATE' <= :datepo ");
  SQL->Add(" AND KOD_PODR LIKE :Ch ");

  DBGridMissionS->DBGrid->Query->SetSQLSelect(SQL);
  DBGridMissionS->DBGrid->Timer->Enabled= false;
  DBGridMissionS->DBGrid->TimerOn= false;
  DBGridMissionS->DBGrid->SetReadOnly();
  DBGridMissionS->DBGrid->Query->ParamByName("dates")->AsDate= SetCentury(StrToDate(S2));
  DBGridMissionS->DBGrid->Query->ParamByName("datepo")->AsDate= SetCentury(StrToDate(S3));
  S1.Delete(2,2);
  S1.Insert("__",2);
  DBGridMissionS->DBGrid->Query->ParamByName("Ch")->AsString= S1;
  DBGridMissionS->DBGrid->Query->Open();
  DBGridMissionS->DBGrid->Visible = false;

  Sales(S);
  DEL(SQL);
}
//----------------------------------------------------------------------------
AnsiString _fastcall TMainForm::FOnClick(TWTParamItem *Sender) {
  // ������� ���������� �������������
  // ��������� ������� �� ����
  TStringList *SQL = new TStringList();
  SQL->Add("SELECT KOD, NAME FROM SP_PODR ORDER BY KOD");
//  DBGridGuide6->DBGrid->Query->SetSQLSelect(SQL);

  DBGridGuide6 = new TWTWinDBGrid(this,SQL,false);
//  DBGridGuide6->FEnter=NULL;

  // ��������� ������� �� ����
  DBGridGuide6->DBGrid->SetReadOnly();
  DBGridGuide6->DBGrid->Query->Open();
//  DBGridGuide6->DBGrid->Visible = false;

  DBGridGuide6->DBGrid->FieldSource=DBGridGuide6->AddColumn("kod","��� �������������","");
  DBGridGuide6->AddColumn("name","������������","");
  DBGridGuide6->SetCaption("���������� �������������");
//  DBGridGuide6->DBGrid->Visible = true;
//  DBGridGuide6->DBGrid->SetFocus();
//  DBGridGuide6->FormStyle=wsNormal;
//  DBGridGuide6->Visible=false;
//  MainForm->MainMenuEnabled(true);
  AnsiString DDD="rrr";
  DBGridGuide6->DBGrid->StringDest=&DDD;
//  DBGridGuide6->DBGrid->FieldSource=DBGridGuide6->DBGrid->Query->GetTField("kod");

  DBGridGuide6->TForm::ShowModal();

  return DBGridGuide6->DBGrid->Query->Fields->Fields[0]->AsString;
}
