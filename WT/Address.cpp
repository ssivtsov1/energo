//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------
#define WinName "���������� ��������"
void _fastcall TMainForm::AdiDomainBtn(TObject *Sender) {
  AdiDomainSpr(NULL);
}

void _fastcall TMainForm::AdiDomainSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adi_domain_tbl"),true);
  //WGrid->SetNoDeactivate(true);
  //WGrid->ShowModal();
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;
 
  Field = WGrid->AddColumn("id", "�������", "������������ �������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("name", "�������", "������������ �������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->IncrField="id";
  WGrid->DBGrid->IncrExpr="SELECT currval('adi_domain_seq') as GEN_ID";

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  //WGrid->ShowModal();
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("AdiDomain");

};
#undef WinName

#define WinName "���������� ����� ���������� �������"
void _fastcall TMainForm::AdkTownBtn(TObject *Sender) {
  AdkTownSpr(NULL);
}

void _fastcall TMainForm::AdkTownSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adk_town_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������  ����");
  Field->SetRequired("������������  ������ ���� ���������");


  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  Field->SetRequired("������������  ������ ���� ���������");


  Field = WGrid->AddColumn("flag_type", "���", "�����/����");
  Field->AddFixedVariable("True", "�����");
  Field->AddFixedVariable("False","���� ");
  Field->SetDefValue("false");


   //Field = WGrid->AddColumn("id", "���", "���");
   // Field->SetOnHelp(AdiDomainSpr);
   //Field->Visible=false;



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("AdkTown");

};
#undef WinName


#define WinName "���������� ����� ���������� �������111"
void _fastcall TMainForm::AdkTownBtn1(TObject *Sender) {
  AdkTownSpr1(NULL);
}

void _fastcall TMainForm::AdkTownSpr1(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTQuery *Querk=new TWTQuery(this);
  Querk->Sql->Add("select * from adk_town_tbl");
  //Querk->Open();


  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, Querk,false);
  WGrid->SetCaption(WinName);

 /* TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();
   */
  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  //NList->Add("flag_type");

  Query->SetSQLModify("adk_town_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������  ����");
  Field->SetRequired("������������  ������ ���� ���������");


  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  Field->SetRequired("������������  ������ ���� ���������");


  Field = WGrid->AddColumn("flag_type", "���", "�����/����");
  Field->AddFixedVariable("True", "�����");
  Field->AddFixedVariable("False","���� ");
  Field->SetDefValue("false");


   //Field = WGrid->AddColumn("id", "���", "���");
   // Field->SetOnHelp(AdiDomainSpr);
   //Field->Visible=false;



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("AdkTown");

};
#undef WinName


#define WinName "���������� ���������� �������"
void _fastcall TMainForm::AdiTownBtn(TObject *Sender) {
  AdiTownSpr(NULL);
}

void _fastcall TMainForm::AdiTownSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adi_town_tbl"),false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_KTOWN", "IDK_TOWN", CreateFullTableName("adk_town_tbl"), "NAME","id");
  Table->AddLookupField("NAME_REGION", "ID_REGION", CreateFullTableName("adi_region_tbl"), "NAME","id");

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("NAME_KTOWN", "���", "��� ���.������");
  Field->SetOnHelp(AdkTownSpr);
  Field->SetRequired("��� ���.������ ������ ���� ��������");

  Field = WGrid->AddColumn("NAME_REGION", "�����", "����� ���.������");
  Field->SetOnHelp(AdiRegionSpr);
  Field->SetRequired("����� ���.������ ������ ���� ��������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;

   WGrid->ShowAs("AdiTown");

};
#undef WinName

#define WinName "���������� �������"
void _fastcall TMainForm::AdiRegionBtn(TObject *Sender) {
  AdiRegionSpr(NULL);
}

void _fastcall TMainForm::AdiRegionSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adi_region_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������

  Table->AddLookupField("NAME_DOM", "ID_DOMAIN", CreateFullTableName("adi_domain_tbl"), "NAME","id");
  Table->Options  << doQuickOpen;
  Table->Options  <<   doSqlFilter;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "�����", "������������ ������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("id_domain", "�������", "������������ �������");
  Field->SetOnHelp(AdiDomainSpr);
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("NAME_DOM", "�������", "�������");
  Field->SetOnHelp(AdiDomainSpr);
  Field->SetRequired("������� ������ ���� ���������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("AdiRegion");

};
#undef WinName


#define WinName "���������� ����"
void _fastcall TMainForm::AdiStreetBtn(TObject *Sender) {
  AdiStreetSpr(NULL);
}

void _fastcall TMainForm::AdiStreetSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adi_street_tbl"),false);
  WGrid->SetCaption(WinName);
  AnsiString Proba;


  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_TOWN", "ID_TOWN", CreateFullTableName("adi_town_tbl"), "NAME","id");
  Table->AddLookupField("NAME_KIND", "IDK_STREET", CreateFullTableName("adk_street_tbl"), "NAME","id");
  if (Sender!=NULL)
   {
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);

       Table->Filtered=true;
      };
    };
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������ �����");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("NAME_TOWN", "���.�����", "���������� �����");
  Field->SetOnHelp(AdiTownSpr);
  Field->SetRequired("���.����� ������� ���� ��������");


  Field = WGrid->AddColumn("NAME_KIND", "���", "��� �����");
  Field->SetOnHelp(AdkStreetSpr);
  Field->SetRequired("��� ����� ������� ���� ��������");



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs("Adistreet");

};
#undef WinName


#define WinName "���������� ����� ����"
void _fastcall TMainForm::AdkStreetBtn(TObject *Sender) {
  AdkStreetSpr(NULL);
}

void _fastcall TMainForm::AdkStreetSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adk_street_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������  ���� �����");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  Field->SetRequired("������������  ������ ���� ���������");

   //Field = WGrid->AddColumn("id", "���", "���");
   // Field->SetOnHelp(AdiDomainSpr);
   //Field->Visible=false;



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs("AdkStreet");

};
#undef WinName


#define WinName "���������� ������"
void _fastcall TMainForm::AdkOfficeBtn(TObject *Sender) {
  AdkOfficeSpr(NULL);
}

void _fastcall TMainForm::AdkOfficeSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adk_office_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������  ���� �����");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  Field->SetRequired("������������  ������ ���� ���������");



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs("AdkOffice");

};
#undef WinName


#define WinName "���������� ������"
void _fastcall TMainForm::AdkBuildingBtn(TObject *Sender) {
  AdkBuildingSpr(NULL);
}

void _fastcall TMainForm::AdkBuildingSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("adk_building_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  Field->SetRequired("������������  ������ ���� ���������");



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs("AdkBuilding");

};
#undef WinName

#define WinName "���������� �������"
void _fastcall TMainForm::AdmAddressBtn(TObject *Sender) {
  AdmAddressSpr(NULL);
}

void _fastcall TMainForm::AdmAddressSpr(TWTField *Sender) {
  // ���������� ���������
    TWTQuery *QueryAdr;
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
    string qqq;
    QueryAdr = new  TWTQuery(this);
    QueryAdr->Sql->Clear();
    QueryAdr->Sql->Add("select adi_domain_tbl.name||' '||adi_region_tbl.name" );
    QueryAdr->Sql->Add("||' '||adi_town_tbl.name as namereg,adm_address_tbl.id_street,adm_address_tbl.building,");
    QueryAdr->Sql->Add("adm_address_tbl.idk_building,adm_address_tbl.building_add,adm_address_tbl.post_index,");
    QueryAdr->Sql->Add("adm_address_tbl.idk_office,adm_address_tbl.office,adm_address_tbl.id  ");
    QueryAdr->Sql->Add("  from "+ FullTableName("adi_domain_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_region_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_town_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_street_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adm_address_tbl"));
    QueryAdr->Sql->Add(" where adm_address_tbl.id_street=adi_street_tbl.id and ");
    QueryAdr->Sql->Add(" adi_street_tbl.id_town=adi_town_tbl.id and adi_town_tbl.id_region=adi_region_tbl.id ");
    QueryAdr->Sql->Add( " and  adi_region_tbl.id_domain=adi_domain_tbl.id");
 /*
 QueryAdr->Sql->Add("select adi_domain_tbl.id as id_domain,adi_region_tbl.id as id_region," );
    QueryAdr->Sql->Add("adi_town_tbl.id as id_town,adm_address_tbl.id_street,adm_address_tbl.building,");
    QueryAdr->Sql->Add("adm_address_tbl.idk_building,adm_address_tbl.building_add,adm_address_tbl.post_index,");
    QueryAdr->Sql->Add("adm_address_tbl.idk_office,adm_address_tbl.office,adm_address_tbl.id  ");
    QueryAdr->Sql->Add("  from "+ FullTableName("adi_domain_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_region_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_town_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_street_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adm_address_tbl"));
    QueryAdr->Sql->Add(" where adm_address_tbl.id_street=adi_street_tbl.id and ");
    QueryAdr->Sql->Add(" adi_street_tbl.id_town=adi_town_tbl.id and adi_town_tbl.id_region=adi_region_tbl.id ");
    QueryAdr->Sql->Add( " and  adi_region_tbl.id_domain=adi_domain_tbl.id");

 */

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->AddLookupField("NAME_STREET", "ID_STREET", CreateFullTableName("adi_street_tbl"), "NAME","id");
/*  Query->AddLookupField("NAME_TOWN", "ID_TOWN", CreateFullTableName("adi_town_tbl"), "NAME","id");
  Query->AddLookupField("NAME_REGION", "ID_REGION", CreateFullTableName("adi_region_tbl"), "NAME","id");
  Query->AddLookupField("NAME_DOMAIN", "ID_DOMAIN", CreateFullTableName("adi_domain_tbl"), "NAME","id");
  */
  Query->Open();
  TStringList *WList=new TStringList();
  WList->Add("id");
  TStringList *NList=new TStringList();
  NList->Add("namereg");
  /*NList->Add("NAME_TOWN");
  NList->Add("NAME_REGION");
  NList->Add("NAME_DOMAIN");
    */
 /* NList->Add("id_domain");
  NList->Add("id_region");
  NList->Add("id_town");
   */
  QueryAdr->SetSQLModify("adm_address_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("NAMEREG", "������", "������");

  Field = WGrid->AddColumn("NAME_Street", "�����", "�����");
  Field->SetOnHelp(AdiStreetSpr);
  Field->SetRequired("����� ������ ���� ���������");
 /*
  Field = WGrid->AddColumn("NAME_TOWN", "���.�����", "���������� �����");
  Field->SetOnHelp(AdiTownSpr);
  Field->SetRequired("���.����� ������� ���� ��������");

  Field = WGrid->AddColumn("NAME_Region", "�����", "�����");
  Field->SetOnHelp(AdiRegionSpr);
  Field->SetRequired("����� ������� ���� ��������");



  Field = WGrid->AddColumn("NAME_DOMAIN", "�������", "�������");
  Field->SetOnHelp(AdiDomainSpr);
  Field->SetRequired("������� ������ ���� ���������");

  Field = WGrid->AddColumn("id", "������������", "������������  ���� �����");
  Field->SetRequired("������������  ������ ���� ���������");
   */
       /*
  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  Field->SetRequired("������������  ������ ���� ���������");


         */
     /*
  TWTToolBar *ToolBar = new TWTToolBar(this);
  ToolBar->Parent = this;
  ToolBar->ID = "������� ������";

  ToolBar->AddButton("SprArt", "�����1", NULL);
  ToolBar->AddButton("SprKass", "�����2", NULL);
  ToolBar->AddButton("SprPodr", "�����3", NULL);
  WGrid->CoolBar->AddToolBar(ToolBar);
       */

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs("AdmAddress");

};
#undef WinName



