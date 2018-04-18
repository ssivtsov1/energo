//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"

#define WinName "���� ����������"

void _fastcall TMainForm::DciMDocBtn(TObject *Sender)
{
  DciMDocSpr(NULL);
}

void  _fastcall TMainForm::DciMDocSpr(TWTField *Sender) {

 DciMDocSel(Sender,NULL);

 }

TWTDBGrid *_fastcall TMainForm::DciMDocSel(TWTField *Sender,int id_sel)
{

  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL ;
  }
  TWTDoc *DocK=new TWTDoc(this,"");
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  TWTDBGrid* DBGrKind=new TWTDBGrid(DocK, "dck_document_tbl");
  TWTPanel* PGrKind=DocK->MainPanel->InsertPanel(350,false,150);

  PGrKind->Params->AddText("���� ����������",10,F,Classes::taCenter,true)->ID="NKind";
  PGrKind->Params->AddGrid(DBGrKind,true)->ID="DocKind";
  DBGrKind->Table->Open();

  DBGrKind->Table->IndexFieldNames="name";
  TDataSource *DataSource=DBGrKind->DataSource;
  DBGrKind->OnExit=ExitParamsGrid;

  TWTTable* TableKind = DBGrKind->Table;
  TableKind->Open();
  TWTField *Field;
  Field = DBGrKind->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = DBGrKind->AddColumn("ident", "���", "���");
  Field->AddFixedVariable("bill", "����� ");
  Field->AddFixedVariable("pay","������� ");
  Field->AddFixedVariable("rep_dem","���.����.");
  Field->AddFixedVariable("saldo", "������");
  Field->SetDefValue("pay");


  TWTDBGrid* DBGrDci=new TWTDBGrid(DocK, "dci_document_tbl");
  TWTPanel* PDci=DocK->MainPanel->InsertPanel(300,false,150);
  PDci->Params->AddText("���������",10,F,Classes::taCenter,true)->ID="NameDci";
  PDci->Params->AddGrid(DBGrDci,true)->ID="DocDci";

  TWTTable* Table = DBGrDci->Table;

  //Table->AddLookupField("NAME_GRP", "ID_grp", "dci_group_tbl", "name","id");
  //Table->AddLookupField("NAME_KIND", "idk_document", "dck_document_tbl","name" ,"id");
  Table->Open();
  Table->IndexFieldNames = "id";
  Table->LinkFields = "id=idk_document";
  Table->MasterSource = DataSource;

  TWTField *Fieldd;

  Fieldd = DBGrDci->AddColumn("Name", "������������", "������������");
  Fieldd->SetRequired("������������  ������ ���� ���������");
  Fieldd->SetWidth(200);
 // Field = WGrid->AddColumn("Name_grp", "������ ����������", "������ ����������");
 // Field->SetOnHelp(DciGroupSprG);

  Fieldd = DBGrDci->AddColumn("ident", "���", "���");
  Fieldd->AddFixedVariable("chn_cnt", "������ ��������            ");
  Fieldd->AddFixedVariable("set_cnt", "��������� ��������         ");
  Fieldd->AddFixedVariable("act_start","��� �������,����� ���������� ������� � ����������� ");
  Fieldd->AddFixedVariable("beg_ind", "���� ��������� ��������� (������ ������ � �����");
  Fieldd->AddFixedVariable("rep_pwr","����� � �����������         ");
  Fieldd->AddFixedVariable("kor_ind","�������������� ��������� ");
  Fieldd->AddFixedVariable("act_chn", "��� ������� (������������� �� �� ���� �����������)");
  Fieldd->AddFixedVariable("act_pwr","��� ������� ������������, ��� ��������� ������");
  Fieldd->AddFixedVariable("act_check","��� �������� ������������ ��� ���������");
  Fieldd->AddFixedVariable("rep_avg","����������� �� �������� �����������");
  Fieldd->AddFixedVariable("saldo","������");
  Fieldd->AddFixedVariable("kord_sal","����.������ �����");
  Fieldd->AddFixedVariable("pay","��������");
  Fieldd->AddFixedVariable("aquit","���������");
  Fieldd->AddFixedVariable("avizo","�����");
  Fieldd->AddFixedVariable("trush","�����");
  Fieldd->AddFixedVariable("comp_categ","������");
  Fieldd->AddFixedVariable("kork_sal","����.������ ������");
  Fieldd->AddFixedVariable("subsid","��������");
  Fieldd->AddFixedVariable("bill","����");
  Fieldd->AddFixedVariable("accord","�������");
  Fieldd->SetDefValue("                               ");
   DBGrDci->AfterPost=AftBefPostDci;
   DBGrDci->BeforePost=AftBefPostDci;

   DocK->ShowAs(WinName);
   DocK->SetCaption("���� ���������� "); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  //DocAdr->ID="AdmAdrM";
  DocK->LoadFromFile(DocK->DocFile);
  DocK->Constructor=true;

  DBGrDci->FieldSource = DBGrDci->Table->GetTField("id");
  DBGrDci->FieldDest = Sender;

  DocK->MainPanel->ParamByID("DocDci")->Control->SetFocus();
  DocK->MainPanel->ParamByID("DocKind")->Control->SetFocus();
  return DBGrDci;

};

void _fastcall TMainForm::AftBefPostDci(TWTDBGrid *Sender)
{
 int id_k;
 id_k= Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger;
 Sender->DataSource->DataSet->FieldByName("id_grp")->AsInteger=id_k;
};


void _fastcall TMainForm::DciDocumentBtn(TObject *Sender)
 {
  DciDocumentSpr(NULL);
}


#define WinName "���� ����������"
void _fastcall TMainForm::DciDocumentSpr(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dci_document_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  Table->AddLookupField("NAME_GRP", "ID_grp", "dci_group_tbl", "name","id");
  Table->AddLookupField("NAME_KIND", "idk_document", "dck_document_tbl","name" ,"id");
  Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("Name_grp", "������ ����������", "������ ����������");
  Field->SetOnHelp(DciGroupSprG);
  //Field->SetRequired("������  ������ ���� ���������");
  //Field->SetWidth(150);

  Field = WGrid->AddColumn("NAME_KIND", "���� �����", "���� ����� ����������");
  Field->SetOnHelp(DckDocumentSpr);
  //Field->SetRequired("���  ������ ���� ��������");
  //Field->SetWidth(150);

  Field = WGrid->AddColumn("ident", "���", "���");
  Field->AddFixedVariable("CHN_CNT", "������ ��������            ");
  Field->AddFixedVariable("SET_CNT","��������� ��������           ");
  Field->AddFixedVariable("ACT_START","��� �������,����� ���������� ������� � ����������� ");

  Field->AddFixedVariable("BEG_IND", "���� ��������� ��������� (������ ������ � �����");
  Field->AddFixedVariable("REP_PWR","����� � �����������         ");
  Field->AddFixedVariable("KOR_IND","�������������� ��������� ");

  Field->AddFixedVariable("ACT_CHN", "��� ������� (������������� �� �� ���� �����������)");
  Field->AddFixedVariable("ACT_PWR","��� ������� ������������, ��� ��������� ������");
  Field->AddFixedVariable("ACT_CHECK","��� �������� ������������ ��� ���������");
  Field->AddFixedVariable("REP_AVG","����������� �� �������� �����������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DciDocument",1);

};

void _fastcall TMainForm::DckDocumentBtn(TObject *Sender)
 {
  DckDocumentSpr(NULL);
}
#define WinName "���� ����� ����������"
void _fastcall TMainForm::DckDocumentSpr(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dck_document_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;


  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("ident", "���", "���");
  Field->AddFixedVariable("bill", "����� ");
  Field->AddFixedVariable("pay","������� ");
  Field->AddFixedVariable("rep_dem","���.����.");
  Field->SetDefValue("pay");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DckDocument",1);

};

#define WinName "������ ����������"
void _fastcall TMainForm::DciGroupSprT(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dci_group_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->AddLookupField("NAME_par", "ID_parent", "dci_group_tbl", "name","id");
  Table->SetFilter("level=0");
  Table->Filtered=true;
  Table->Open();

  TWTField *Field;


  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("Name_par", "��������������", "��������������");
  Field->SetOnHelp(DciGroupSprG);



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DciGroup",1);

};
#undef WinName
#define WinName "�������������� ����� ����������"
void _fastcall TMainForm::DciGroupSprG(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dci_group_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->AddLookupField("NAME_par", "ID_parent", "dci_group_tbl", "name","id");
  Table->SetFilter("level>0");
  Table->Filtered=true;
  Table->Open();

  TWTField *Field;


  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");
                           /*
  Field = WGrid->AddColumn("Name_par", "��������������", "��������������");
  Field->SetOnHelp(DciGroupSprG);

                             */

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DciGroup",1);

};
#undef WinName



