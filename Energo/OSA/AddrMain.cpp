//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------


#define WinName "���������� ������� "

void _fastcall TMainForm::AdmAddressMineBtn(TObject *Sender)
 {
  AdmAddressMineSpr(NULL);
}

void _fastcall TMainForm::AdmAddressMineSpr(TWTField *Sender)
{
 AdmAddressMSel(Sender);
}

TWTDBGrid* _fastcall TMainForm::AdmAddressMSel(TWTField *Sender)
{
 AdmAddressMSel(Sender,NULL);
}

TWTDBGrid* _fastcall TMainForm::AdmAddressMSel(TWTField *Sender,int pid_address) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTDoc *DocAdr=new TWTDoc(this,"Reports\\AdmAddr.dof");

  TWTDBGrid* DBGrDomain=new TWTDBGrid(DocAdr,  ("adi_domain_tbl"));
  TWTPanel* PDomain=DocAdr->MainPanel->InsertPanel(400,true,200);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PDomain->Params->AddText("������� (+����,�����������)",10,F,Classes::taCenter,true)->ID="NameDom";
  PDomain->Params->AddGrid(DBGrDomain,true)->ID="Domain";
  DBGrDomain->Table->Open();
  DBGrDomain->Table->IndexFieldNames="NAME";
//  TDataSource *DataSource=DBGrDomain->DataSource;
    DBGrDomain->OnExit=ExitParamsGrid;
  //DBGrDomain->ReadOnly=true;
  TWTField *Field;
  Field = DBGrDomain->AddColumn("NAME", "�������", "������������ �������");
   Field->SetUnique("������ ������������ � �����������","adi_domain_tbl","name");
 // Field->SetRequired("������������  ������ ���� ���������");
   Field = DBGrDomain->AddColumn("koatu", "�����", "");

  TWTPanel* PRegion=DocAdr->MainPanel->InsertPanel(400,false,200);
  TWTDBGrid* DBGrRegion = new TWTDBGrid(DocAdr,  ("adi_region_tbl"));
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PRegion->Params->AddText("������+ ������ ���.����������",18,F,Classes::taCenter,false);
  PRegion->Params->AddGrid(DBGrRegion, true)->ID="Region";
  DBGrRegion->Table->Open();
  //DBGrRegion->ReadOnly=true;
  DBGrRegion->Table->IndexFieldNames = "name";
  DBGrRegion->Table->LinkFields = "id=id_domain";
  DBGrRegion->Table->MasterSource = DBGrDomain->DataSource;
  DBGrRegion->OnExit=ExitParamsGrid;
  TWTField *Fields;
  Fields = DBGrRegion->AddColumn("Name", "������������", "������������");
  Fields->SetUnique("������ ������������ � �����������","adi_region_tbl","name");
   Fields = DBGrRegion->AddColumn("koatu", "�����", "");
  //  Field->SetRequired("������������  ������ ���� ���������");
  /// ��������� ������

  TWTPanel* PTown=DocAdr->MainPanel->InsertPanel(400,true,250);
  TWTDBGrid* DBGrTown = new TWTDBGrid(DocAdr,  ("adi_town_tbl"));
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PTown->Params->AddText("���������� ������ +�-�� ������",18,F,Classes::taCenter,false);
  PTown->Params->AddGrid(DBGrTown, true)->ID="Town";
  DBGrTown->Table->AddLookupField("NAME_KTOWN", "IDK_TOWN",  ("adk_town_tbl"), "NAME","id");
  DBGrTown->Table->Open();
   DBGrTown->Table->IndexFieldNames = "name";
  DBGrTown->Table->LinkFields = "id=id_region";
  DBGrTown->Table->MasterSource = DBGrRegion->DataSource;
  TWTField *Fieldt;
  Fieldt = DBGrTown->AddColumn("NAME", "���. �����", "������������ ���.������");
  Fieldt = DBGrTown->AddColumn("koatu", "�����", "");
  Fieldt->SetWidth(200);
 // Fieldt->SetRequired("���.����� ������ ���� ��������");
  Fieldt = DBGrTown->AddColumn("NAME_KTOWN", "���", "��� ���.������");
  Fieldt->SetOnHelp(AdkTownSpr);
    Fieldt->SetWidth(100);
 // Fieldt->SetRequired("��� ���.������ ������ ���� ��������");
     DBGrTown->OnExit=ExitParamsGrid;

  TWTPanel* PStreet=DocAdr->MainPanel->InsertPanel(400,false,250);
  TWTDBGrid* DBGrStreet = new TWTDBGrid(DocAdr,  ("adi_street_tbl"));
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PStreet->Params->AddText("�����",18,F,Classes::taCenter,false);
  PStreet->Params->AddGrid(DBGrStreet, true)->ID="Street";
  DBGrStreet->Table->AddLookupField("NAME_KSTREET", "IDK_STREET",  ("adk_street_tbl"), "NAME","id");

  //PStreet->Params->AddGrid(DBGrStreet, true)->ID="";
  TWTTable *TblStreet=DBGrStreet->Table;

  TblStreet->IndexFieldNames = "name";
  TblStreet->LinkFields = "id=id_town";
  TblStreet->MasterSource = DBGrTown->DataSource;
  TblStreet->Open();
    DBGrStreet->OnExit=ExitParamsGrid;
   TWTField *Fieldss;

  Fieldss = DBGrStreet->AddColumn("Name", "������������", "������������ �����");
//  Fieldss->SetRequired("������������  ������ ���� ���������");
     Fieldss->SetWidth(200);
      Fieldss = DBGrStreet->AddColumn("koatu", "�����", "");

  Fieldss =DBGrStreet->AddColumn("NAME_KSTREET", "���", "��� �����");
  Fieldss->SetOnHelp(AdkStreetSpr);
       Fieldss->SetWidth(100);
 // Fieldss->SetRequired("��� ����� ������� ���� ��������");
     Fieldss = DBGrStreet->AddColumn("id", "���", "���");

     /// ���������� ������
  TWTPanel *PAdr=DocAdr->MainPanel->InsertPanel(200,true,300);
  TWTDBGrid* DBGrAdr = new TWTDBGrid(DocAdr,  ("adm_address_tbl"));
  F ->Size=10;
  F->Style=F->Style << fsBold;
 // F->Color=clBlue;
   F->Color=clFuchsia	;
  PAdr->Params->AddText("������",18,F,Classes::taCenter,false);
  PAdr->Params->AddGrid(DBGrAdr, true)->ID="Adr";

  DBGrAdr->Table->AddLookupField("NAME_STREET", "id_street", "adi_street_tbl", "name","id");
  DBGrAdr->Table->AddLookupField("id_town", "id_street","adi_street_tbl", "id_town","id");

   DBGrAdr->Table->Open();

  DBGrAdr->Table->IndexFieldNames = "id;building";
  DBGrAdr->Table->LinkFields = "id=id_street";
  DBGrAdr->Table->MasterSource = TblStreet->DataSource;
   DBGrAdr->OnExit=ExitParamsGrid;
  TWTField *Fieldq;
  Fieldq =  DBGrAdr->AddColumn("post_index", "������", "������");
  Fieldq->Field->EditMask = "99999";
    
    Fieldq =  DBGrAdr->AddColumn("NAME_STREET", "�����", "�����");
       Fieldq->SetWidth(200);
  Fieldq->FieldLookUpFilter="id_town";
  Fieldq->ExpFieldLookUpFilter=(TWTField*)DBGrTown->Table->FieldByName("id");
  //Fieldq->SetOnHelp(AdiStreetSpr);
  Fieldq->SetReadOnly();
 // Fieldq->SetRequired("����� ������ ���� ���������");

  Fieldq =  DBGrAdr->AddColumn("BUILDING", "���", "���");
  Fieldq =  DBGrAdr->AddColumn("BUILDING_ADD", "������", "������");
  Fieldq = DBGrAdr->AddColumn("Office", "����", "����");

  DBGrAdr->AfterEdit=AfterEditAdr;
  DBGrAdr->AfterInsert=AfterEditAdr;
  DBGrAdr->FieldSource = DBGrAdr->Table->GetTField("id");
  DBGrAdr->FieldDest = Sender;

   DBGrAdr->AfterInsert=BeforeInsertAdr;
   DocAdr->MainPanel->SetVResize(100);
      DocAdr->ShowAs(WinName);
   DocAdr->SetCaption("���������� ������� "); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  //DocAdr->ID="AdmAdrM";
  DocAdr->LoadFromFile(DocAdr->DocFile);
  DocAdr->Constructor=true;
     DBGrTown->Table->IndexFieldNames = "name";
  DocAdr->MainPanel->ParamByID("Region")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Town")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Adr")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Domain")->Control->SetFocus();
   DocAdr->MainPanel->ParamByID("Street")->Control->SetFocus();
     TWTQuery *AdrQuery=new TWTQuery(this);
   int edidAdr;
   int edidDom;
   int edidReg;
   int edidTown;
   int edidStreet;
   //int edidStreet;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();
  int addr=0;
   bool try_field=false;
    if (Sender!=NULL)
    try {
       int val_field= Sender->Field->AsVariant;
       addr= Sender->Field->AsVariant;
       try_field=true;
     } catch (...){};
    if (pid_address!=0)
     {
       int val_field= pid_address;
       try_field=true;
       addr=pid_address;
     }
     if ((Sender!=NULL && try_field) || (DBGrAdr->StringDest!=NULL)|| (addr!=0))
    {  AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("Select * from adm_address_tbl where id="+ToStrSQL(addr));
      AdrQuery->Open();
      edidStreet=AdrQuery->FieldByName("id_street")->AsInteger;
      edidAdr=AdrQuery->FieldByName("id")->AsInteger;
      AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("Select * from adm_commadr_tbl where id_street="+ToStrSQL(edidStreet));
      AdrQuery->Open();

      edidDom=AdrQuery->FieldByName("id_domain")->AsInteger;
      edidReg=AdrQuery->FieldByName("id_region")->AsInteger;
      edidTown=AdrQuery->FieldByName("id_town")->AsInteger;
      edidStreet=AdrQuery->FieldByName("id_street")->AsInteger;

      bool t1=DBGrDomain->DataSource->DataSet->Locate("id",edidDom ,SearchOptions);
      bool t2=DBGrRegion->DataSource->DataSet->Locate("id",edidReg ,SearchOptions);
      bool t3=DBGrTown->DataSource->DataSet->Locate("id",edidTown ,SearchOptions);
      bool t4=DBGrStreet->DataSource->DataSet->Locate("id",edidStreet ,SearchOptions);
      bool t5=DBGrAdr->DataSource->DataSet->Locate("id",edidAdr ,SearchOptions);
    }
    else
    {
      AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("select ident,type_ident,value_ident,sql_ident from syi_sysvars_tbl where ident='id_domain'");
      AdrQuery->Open();
      edidDom=AdrQuery->FieldByName("value_ident")->AsVariant;
      DBGrDomain->DataSource->DataSet->Locate("id",edidDom ,SearchOptions);

      AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("select * from syi_sysvars_tbl where ident='id_region'");
      AdrQuery->Open();
      edidReg=AdrQuery->FieldByName("value_ident")->AsInteger;
      DBGrRegion->DataSource->DataSet->Locate("id",edidReg ,SearchOptions);

    };
    //TSplitter* Spp=PP->SetVResize(50);
   return DBGrAdr;
};

void _fastcall TMainForm::AfterEditAdr(TWTDBGrid *Sender) {
 Sender->Table->FieldByName("Name_street")->LookupDataSet->Refresh();
};

void _fastcall TMainForm::BeforeInsertAdr(TWTDBGrid *Sender) {
 TWTPanel *MPanel= ((TWTDoc*)(Sender->Owner))->MainPanel;
 TWTDBGrid *GrStr= ((TWTDBGrid *)MPanel->ParamByID("Street")->Control);

 Sender->Table->FieldByName("id_street")->AsInteger=GrStr->Table->FieldByName("id")->AsInteger;
  if (Sender->SelectedField->Name=="NAME_STREET")
   Sender->SelectedField->AsString=GrStr->Table->FieldByName("name")->AsString;
  Sender->Table->FieldByName("Name_street")->AsString=GrStr->Table->FieldByName("name")->AsString;
  Sender->Table->FieldByName("Name_street")->LookupDataSet->Refresh();

};

#undef WinName


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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adi_domain_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;
  /*Field = WGrid->AddColumn("id", "���", "��� �������");
  Field->SetUnique("������ ������������ � �����������","adi_domain_tbl","id");
 // Field->SetRequired("��� ������ ���� ��������");
    */
  Field = WGrid->AddColumn("Name", "�������", "������������ �������");
  Field->SetUnique("������ ������������ � �����������","adi_domain_tbl","name");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("name");
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs(WinName);

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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adk_town_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;
      /*
  Field = WGrid->AddColumn("id", "���", "���  ����");
 // Field->SetRequired("��� ������ ���� ��������");
  Field->SetUnique("������ ������������ � �����������","adk_town_tbl","id");
        */
  Field = WGrid->AddColumn("Name", "������������", "������������  ����");
  Field->SetRequired("������������  ������ ���� ���������");
  Field->SetUnique("������ ������������ � �����������","adk_town_tbl","name");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
  //Field->SetRequired("������������  ������ ���� ���������");


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
  WGrid->ShowAs(WinName);

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
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adi_town_tbl"),false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_KTOWN", "IDK_TOWN",  ("adk_town_tbl"), "NAME","id");
  Table->AddLookupField("NAME_REGION", "ID_REGION",  ("adi_region_tbl"), "NAME","id");
   if (Sender!=NULL)
   {   AnsiString Proba;
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);

       Table->Filtered=true;
      };
    };
  Table->Open();

  TWTField *Field;
          /*
  Field = WGrid->AddColumn("id", "���", "��� ����������� ������");
  Field->SetUnique("������ ������������ � �����������","adi_town_tbl","id");
 // Field->SetRequired("��� ������ ���� ��������");
            */
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetWidth(200);
  Field->SetRequired("������������  ������ ���� ���������");
  Field->SetUnique("������ ������������ � �����������","adi_town_tbl","name");
              /*
  Field = WGrid->AddColumn("idk_TOWN", "���", "��� ���.������");
  Field->SetOnHelp(AdkTownSpr);
 // Field->SetRequired("��� ���.������ ������ ���� ��������");
  Field->SetWidth(20);
                */
  Field = WGrid->AddColumn("NAME_KTOWN", "���", "��� ���.������");
  Field->SetOnHelp(AdkTownSpr);
  Field->SetWidth(100);
 // Field->SetRequired("��� ���.������ ������ ���� ��������");
  Field->SetWidth(100);
                  /*
  Field = WGrid->AddColumn("id_REGION", "�����", "����� ���.������");
  Field->SetOnHelp(AdiRegionSpr);
 // Field->SetRequired("����� ���.������ ������ ���� ��������");
                    */
  Field = WGrid->AddColumn("NAME_REGION", "�����", "����� ���.������");
  Field->SetOnHelp(AdiRegionSpr);
  //Field->SetRequired("����� ���.������ ������ ���� ��������");
  Field->SetWidth(150);

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;

   WGrid->ShowAs(WinName);

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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adi_region_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_DOM", "ID_DOMAIN",  ("adi_domain_tbl"), "NAME","id");
  //Table->AutoCalcFields=true;
   Table->Open();

  TWTField *Field;
  /*
  Field = WGrid->AddColumn("id", "���", "��� ������");
  Field->SetUnique("������ ������������ � �����������","adi_region_tbl","id");
 // Field->SetRequired("��� ������ ���� ��������");
    */
  Field = WGrid->AddColumn("Name", "�����", "������������ ������");
  Field->SetUnique("������ ������������ � �����������","adi_region_tbl","name");
  Field->SetWidth(200);
  Field->SetRequired("������������  ������ ���� ���������");
      /*
   Field = WGrid->AddColumn("id_domain", "�������", "�������");
  Field->SetOnHelp(AdiDomainSpr);
//  Field->SetRequired("������� ������ ���� ���������");
        */

  Field = WGrid->AddColumn("NAME_DOM", "�������", "�������");
  Field->SetOnHelp(AdiDomainSpr);
  Field->SetWidth(150);
 // Field->SetRequired("������� ������ ���� ���������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adi_street_tbl"),false);
  WGrid->SetCaption(WinName);
  AnsiString Proba;


  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_TOWN", "ID_TOWN",  ("adi_town_tbl"), "NAME","id");
  Table->AddLookupField("NAME_KIND", "IDK_STREET",  ("adk_street_tbl"), "NAME","id");
  if (Sender!=NULL)
   {
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);
       WGrid->DBGrid->AfterInsert=InsStreet;
       Table->Filtered=true;

      };
    };
  Table->Open();

  TWTField *Field;
  /*
  Field = WGrid->AddColumn("id", "���", "��� �����");
  Field->SetUnique("������ ������������ � �����������","adi_street_tbl","id");
 // Field->SetRequired("��� ������ ���� ��������");
    */
  Field = WGrid->AddColumn("Name", "������������", "������������ �����");
  Field->SetRequired("������������  ������ ���� ���������");
  Field->SetWidth(200);
      /*
  Field = WGrid->AddColumn("id_TOWN", "���.�����", "���������� �����");
  Field->SetOnHelp(AdiTownSpr);
  //Field->SetRequired("���.����� ������� ���� ��������");
        */
  Field = WGrid->AddColumn("NAME_TOWN", "���.�����", "���������� �����");
  Field->SetOnHelp(AdiTownSpr);
  Field->SetWidth(200);
  //Field->SetRequired("���.����� ������� ���� ��������");
          /*
  Field = WGrid->AddColumn("idk_street", "���", "��� �����");
  Field->SetOnHelp(AdkStreetSpr);
 // Field->SetRequired("��� ����� ������� ���� ��������");
            */

  Field = WGrid->AddColumn("NAME_KIND", "���", "��� �����");
  Field->SetOnHelp(AdkStreetSpr);
  Field->SetWidth(100);
 // Field->SetRequired("��� ����� ������� ���� ��������");



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs(WinName);

};
#undef WinName
void _fastcall TMainForm::InsStreet(TWTDBGrid *Sender) {
 TWTField* FieldIns;
 if (Sender->FieldDest!=NULL)
 { FieldIns=Sender->FieldDest;
   if (FieldIns->ExpFieldLookUpFilter!=NULL )
       {  AnsiString NamF=FieldIns->FieldLookUpFilter;
          int ExprField=((TField*)(FieldIns->ExpFieldLookUpFilter))->AsInteger;
          Sender->DataSource->DataSet->FieldByName(NamF)->AsInteger=ExprField;
    };
};
};

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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adk_street_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();

  TWTField *Field;
  /*
    Field = WGrid->AddColumn("id", "���", "��� ���� �����");
  Field->SetUnique("������ ������������ � �����������","adk_street_tbl","id");
//  Field->SetRequired("��� ������ ���� ��������");
    */
  Field = WGrid->AddColumn("Name", "������������", "������������  ���� �����");
   Field->SetUnique("������ ������������ � �����������","adk_street_tbl","name");
   Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
 // Field->SetRequired("������������  ������ ���� ���������");

   //Field = WGrid->AddColumn("id", "���", "���");
   // Field->SetOnHelp(AdiDomainSpr);
   //Field->Visible=false;



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs(WinName);

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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adk_office_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();

  TWTField *Field;
      /*
     Field = WGrid->AddColumn("id", "���", "��� �����");
  Field->SetUnique("������ ������������ � �����������","adk_office_tbl","id");
 // Field->SetRequired("��� ������ ���� ��������");
        */
  Field = WGrid->AddColumn("Name", "������������", "������������  �����");
  Field->SetUnique("������ ������������ � �����������","adk_office_tbl","name");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
 // Field->SetRequired("������������  ������ ���� ���������");



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs(WinName);

};
#undef WinName


#define WinName "���������� ����� ��������"
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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  ("adk_building_tbl"),false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();

  TWTField *Field;
          /*
     Field = WGrid->AddColumn("id", "���", "��� �����");
  Field->SetUnique("������ ������������ � �����������","adk_building_tbl","id");
 // Field->SetRequired("��� ������ ���� ��������");
            */
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetUnique("������ ������������ � �����������","adk_building_tbl","name");
  Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
//  Field->SetRequired("������������  ������ ���� ���������");



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs(WinName);

};
#undef WinName


/*
#define WinName "���������� �������"
void _fastcall TMainForm::AdmAddressBtn(TObject *Sender) {
  AdmAddressSpr(NULL);
}
  */
  /*
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

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->AddLookupField("NAME_STREET", "ID_STREET",  ("adi_street_tbl"), "NAME","id");
//  Query->AddLookupField("NAME_TOWN", "ID_TOWN",  ("adi_town_tbl"), "NAME","id");
//  Query->AddLookupField("NAME_REGION", "ID_REGION",  ("adi_region_tbl"), "NAME","id");
 // Query->AddLookupField("NAME_DOMAIN", "ID_DOMAIN",  ("adi_domain_tbl"), "NAME","id");

  Query->Open();
  TStringList *WList=new TStringList();
  WList->Add("id");
  TStringList *NList=new TStringList();
  NList->Add("namereg");
  //NList->Add("NAME_TOWN");
 // NList->Add("NAME_REGION");
  //NList->Add("NAME_DOMAIN");

 // NList->Add("id_domain");
  //NList->Add("id_region");
 // NList->Add("id_town");

  QueryAdr->SetSQLModify("adm_address_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("NAMEREG", "������", "������");

  Field = WGrid->AddColumn("NAME_Street", "�����", "�����");
  Field->SetOnHelp(AdiStreetSpr);
 // Field->SetRequired("����� ������ ���� ���������");
 //
 // Field = WGrid->AddColumn("NAME_TOWN", "���.�����", "���������� �����");
 // Field->SetOnHelp(AdiTownSpr);
 // Field->SetRequired("���.����� ������� ���� ��������");

  //Field = WGrid->AddColumn("NAME_Region", "�����", "�����");
 // Field->SetOnHelp(AdiRegionSpr);
 // Field->SetRequired("����� ������� ���� ��������");



 // Field = WGrid->AddColumn("NAME_DOMAIN", "�������", "�������");
 // Field->SetOnHelp(AdiDomainSpr);
 // Field->SetRequired("������� ������ ���� ���������");

 // Field = WGrid->AddColumn("id", "������������", "������������  ���� �����");
 // Field->SetRequired("������������  ������ ���� ���������");
//  Field = WGrid->AddColumn("shot_name", "��.������������", "������� ������������");
 // Field->SetRequired("������������  ������ ���� ���������");

//  TWTToolBar *ToolBar = new TWTToolBar(this);
//  ToolBar->Parent = this;
//  ToolBar->ID = "������� ������";

//  ToolBar->AddButton("SprArt", "�����1", NULL);
//  ToolBar->AddButton("SprKass", "�����2", NULL);
//  ToolBar->AddButton("SprPodr", "�����3", NULL);
//  WGrid->CoolBar->AddToolBar(ToolBar);


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  //*DBGrid->FormStyle = fsMDIChild;
   WGrid->ShowAs(WinName);

};
#undef WinName
                                    */
 #define WinName "���������� ���������� ������� "
void _fastcall TMainForm::AdmCommAdrBtn(TObject *Sender)
 {
  AdmCommAdrSpr(NULL);
}

void _fastcall TMainForm::AdmCommAdrSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTDoc *DocAdr=new TWTDoc(this,"Reports\\AdmAddr.dof");

  TWTDBGrid* DBGrDomain=new TWTDBGrid(DocAdr,  ("adi_domain_tbl"));
  TWTPanel* PDomain=DocAdr->MainPanel->InsertPanel(350,true,85);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PDomain->Params->AddText("�������",10,F,Classes::taCenter,true)->ID="NameDom";
  PDomain->Params->AddGrid(DBGrDomain,true)->ID="Domain";
  DBGrDomain->Table->Open();
  DBGrDomain->Table->IndexFieldNames="NAME";
  TDataSource *DataSource=DBGrDomain->DataSource;

  TWTField *Field;
  Field = DBGrDomain->AddColumn("NAME", "�������", "������������ �������");
  //Field->SetRequired("������������  ������ ���� ���������");
  DBGrDomain->OnExit=ExitParamsGrid;
  TWTPanel* PRegion=DocAdr->MainPanel->InsertPanel(100,false,85);
  TWTDBGrid* DBGrRegion = new TWTDBGrid(DocAdr,  ("adi_region_tbl"));


  //F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PRegion->Params->AddText("������",10,F,Classes::taCenter,false);
  PRegion->Params->AddGrid(DBGrRegion, true)->ID="Region";
  DBGrRegion->Table->AddLookupField("id_dom", "ID_domain",  ("adi_domain_tbl"), "id","id");
  DBGrRegion->OnExit=ExitParamsGrid;

  DBGrRegion->Table->Open();

  DBGrRegion->Table->IndexFieldNames = "name";
  DBGrRegion->Table->LinkFields = "id=id_domain";
  DBGrRegion->Table->MasterSource = DataSource;

  TWTField *Fields;
  Fields = DBGrRegion->AddColumn("Name", "������������", "������������");

  /// ��������� ������
  TWTPanel* PTown=DocAdr->MainPanel->InsertPanel(100,true,130);
  TWTDBGrid* DBGrTown = new TWTDBGrid(DocAdr,  ("adi_town_tbl"));

  //F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PTown->Params->AddText("���������� ������",10,F,Classes::taCenter,false);
  PTown->Params->AddGrid(DBGrTown, true)->ID="Town";

  DBGrTown->Table->AddLookupField("NAME_KTOWN", "IDK_TOWN",  ("adk_town_tbl"), "NAME","id");
  //DBGrTown->Table->AddLookupField("id_reg", "ID_region",  ("adi_region_tbl"), "id","id");
  DBGrTown->Table->AddLookupField("id_dom", "ID_dom", (TZDataset*)DBGrRegion->DataSource->DataSet, "id","id");
  DBGrTown->OnExit=ExitParamsGrid;
  DBGrTown->Table->Open();


  TWTField *Fieldt;

  Fieldt = DBGrTown->AddColumn("Name", "������������", "������������");
  Fieldt = DBGrTown->AddColumn("NAME_KTOWN", "���", "��� ���.������");
  Fieldt->SetOnHelp(AdkTownSpr);
  Fieldt->SetWidth(100);
 // Fieldt->SetRequired("��� ���.������ ������ ���� ��������");


 DBGrTown->Table->IndexFieldNames = "name";
 DBGrTown->Table->LinkFields = "id=id_region";
 DBGrTown->Table->MasterSource = DBGrRegion->DataSource;

    /// ���������� ������
  TWTPanel* PStreet=DocAdr->MainPanel->InsertPanel(100,true,130);

  TWTDBGrid* DBGrStreet = new TWTDBGrid(DocAdr,  ("adi_street_tbl"));

  //F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PStreet->Params->AddText("�����",10,F,Classes::taCenter,false);
  PStreet->Params->AddGrid(DBGrStreet, true)->ID="Street";



  //DBGrStreet->Table->AddLookupField("NAME_STREET", "ID_STREET",  ("adi_street_tbl"), "NAME","id", "id_town="+DBGrTown->Table->FieldByName("id")->AsString);
   DBGrStreet->Table->AddLookupField("NAME_KIND", "IDK_STREET",  ("adk_street_tbl"), "NAME","id");
   DBGrStreet->OnExit=ExitParamsGrid;
   DBGrStreet->Table->Open();

  DBGrStreet->Table->IndexFieldNames = "name";
  DBGrStreet->Table->LinkFields = "id=id_town";
  DBGrStreet->Table->MasterSource = DBGrTown->DataSource;
  DBGrStreet->AfterPost=AfterPostStreet;
  TWTField *Fieldq;
  Fieldq =  DBGrStreet->AddColumn("NAME", "�����", "�����");
  //Fieldq->SetRequired("����� ������ ���� ���������");


  Fieldq = DBGrStreet->AddColumn("NAME_KIND", "���", "��� �����");
  Fieldq->SetOnHelp(AdkStreetSpr);
  Fieldq->SetWidth(100);
 // Fieldq->SetRequired("��� ����� ������� ���� ��������");

  DBGrStreet->FieldSource = DBGrStreet->Table->GetTField("id_STREET");
  DBGrStreet->FieldDest = Sender;

   DocAdr->MainPanel->SetVResize(100);
   TWTQuery *AdrQuery=new TWTQuery(this);
   int edidDom;
   int edidReg;
   int edidTown;
   int edidStreet;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();
    bool try_field=false;
    if (Sender!=NULL)
    try {
       int val_field= ((TField*)Sender)->AsVariant;
       try_field=true;
     } catch (...){};

     if (Sender!=NULL && try_field )
    {  AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("Select * from adm_commadr_tbl where id_street="+ToStrSQL(((TField*)Sender)->AsString));
      AdrQuery->Open();
      edidDom=AdrQuery->FieldByName("id_domain")->AsInteger;
      edidReg=AdrQuery->FieldByName("id_region")->AsInteger;
      edidTown=AdrQuery->FieldByName("id_town")->AsInteger;
      edidStreet=AdrQuery->FieldByName("id_street")->AsInteger;

      DBGrDomain->DataSource->DataSet->Locate("id",edidDom ,SearchOptions);
      DBGrRegion->DataSource->DataSet->Locate("id",edidReg ,SearchOptions);
      DBGrTown->DataSource->DataSet->Locate("id",edidTown ,SearchOptions);
      DBGrStreet->DataSource->DataSet->Locate("id",edidStreet ,SearchOptions);
    }
    else
    {
      AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("select ident,type_ident,value_ident,sql_ident from syi_sysvars_tbl where ident='id_domain'");
      AdrQuery->Open();
      edidDom=AdrQuery->FieldByName("value_ident")->AsVariant;
      DBGrDomain->DataSource->DataSet->Locate("id",edidDom ,SearchOptions);

      AdrQuery->Sql->Clear();
      AdrQuery->Sql->Add("select * from syi_sysvars_tbl where ident='id_region'");
      AdrQuery->Open();
      edidReg=AdrQuery->FieldByName("value_ident")->AsInteger;
      DBGrRegion->DataSource->DataSet->Locate("id",edidReg ,SearchOptions);

    };

    //TSplitter* Spp=PP->SetVResize(50);

   DocAdr->ShowAs(WinName);
   DocAdr->SetCaption("���������� ������� ��� ������"); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  //DocAdr->ID="AdmAdrM";
  //DocAdr->LoadFromFile(DocAdr->DocFile);
  //DocAdr->Constructor=true;

  DocAdr->MainPanel->ParamByID("Region")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Town")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Street")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Domain")->Control->SetFocus();

};



#undef WinName



void _fastcall TMainForm::AfterPostStreet(TWTDBGrid *Sender)
{
};

  /* TWTPanel *MPanel= ((TWTDoc*)(Sender->Owner))->MainPanel;
     TWTDBGrid *GrCom= ((TWTDBGrid *)MPanel->ParamByID("CommAdr")->Control);
     GrCom->DataSource->DataSet->Refresh();
     GrCom->Table->FieldByName("full_commadr")->LookupDataSet->Refresh();
     GrCom->Table->Active=true;*/











