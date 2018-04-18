//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "SysUser.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------
#define WinName "���������� ������"
void _fastcall TMainForm::CmiBankBtn(TObject *Sender) {
  CmiBankSpr(NULL);
}

void _fastcall TMainForm::CmiBankSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cmi_bank_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Filter="show_def=1";
  Table->Filtered=true;
      int ChLevel =CheckLevelRead("���������� ������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
      WGrid->DBGrid->ReadOnly=true;
  Table->Open();
  TWTField *Field;
  Field = WGrid->AddColumn("id", "MFO", "MFO �����");
  Field->SetRequired("MFO ����� ������ ���� ���������");
  Field = WGrid->AddColumn("Name", "����", "����");

  Field = WGrid->AddColumn("code_OKPO", "������ �����", "������ �����");

  Field = WGrid->AddColumn("show_def", "��������", "�������� �����");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("1");

  WGrid->DBGrid->ToolBar->AddButton("InsForm", "������ ������ ������", CmiBankSprA);

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("name");
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName

#define WinName "������ ���������� ������ "
void _fastcall TMainForm::CmiBankSprA(TObject *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cmi_bank_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Filter="show_def=0 or show_def=NULL";
  Table->Filtered=true;

//  WGrid->DBGrid->Table->AddLookupField("NAME_ADR", "ID_ADDRES", "adv_address_tbl", "Full_adr","id");
     int ChLevel =CheckLevelRead("���������� ������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
      WGrid->DBGrid->ReadOnly=true;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("id", "MFO", "MFO �����");
  Field->SetRequired("MFO ����� ������ ���� ���������");

  Field = WGrid->AddColumn("Name", "����", "����");

  Field = WGrid->AddColumn("show_def", "��������", "�������� �����");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("0");

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName

#define WinName "���������� ��������� �����"
void _fastcall TMainForm::CmiKategBtn(TObject *Sender) {
  CmiKategSpr(NULL);
}

void _fastcall TMainForm::CmiKategSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,"cla_kateg_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

  Table->Open();
  TWTField *Field;
  Field = WGrid->AddColumn("id", "���", "���");
  Field->SetRequired("������ ���� ���������");
  Field = WGrid->AddColumn("Name", "������������", "������������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("name");
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName

#define WinName "���������� �����"
void _fastcall TMainForm::CmiCurrencyBtn(TObject *Sender) {
  CmiCurrencySpr(NULL);
}

void _fastcall TMainForm::CmiCurrencySpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cmi_currency_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
     int ChLevel =CheckLevelRead("���������� �����");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
      WGrid->DBGrid->ReadOnly=true;
  Table->Open();
  TWTField *Field;
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������ ������ ���� ���������");
  Field = WGrid->AddColumn("Short_Name", "�����������", "�����������");
  Field = WGrid->AddColumn("code", "���", "���");
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName


#define WinName "���������� ������� "
void _fastcall TMainForm::AciTarifBtn(TObject *Sender)
 {
  AciTarifSpr(NULL);
}
void  _fastcall TMainForm::AciTarifSpr(TWTField *Sender) {
AciTarifSel(Sender);
}

TWTDBGrid*  _fastcall TMainForm::AciTarifSel(TWTField *Sender,int id_tar) {
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTDoc *DocTar=new TWTDoc(this,"");

  TWTDBGrid* DBGrGrTar=new TWTDBGrid(DocTar, "eqi_grouptarif_tbl");

  TWTPanel* PGrTar=DocTar->MainPanel->InsertPanel(400,false,300);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PGrTar->Params->AddText("������ �������",10,F,Classes::taCenter,true)->ID="NameGrTar";
  PGrTar->Params->AddGrid(DBGrGrTar,true)->ID="GroupTarif";
  //DBGrGrTar->Table->AddLookupField("Doc","id_doc","dcm_doc_tbl","reg_num","id");
     int ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
       DBGrGrTar->ReadOnly=true;

   DBGrGrTar->Table->Filter="(old_tarif=0) ";
   DBGrGrTar->Table->Filtered=true;

  DBGrGrTar->Table->Open();
  TDataSource *DataSource=DBGrGrTar->DataSource;
  DBGrGrTar->OnExit=ExitParamsGrid;
  //DBGrDomain->ReadOnly=true;

  TWTField *Fieldg;

  Fieldg = DBGrGrTar->AddColumn("SHORT_NAME", "������������", "������������ ������");
  Fieldg->SetRequired("������������ ������ ���� ��������");
  Fieldg->SetWidth(280);

  Fieldg = DBGrGrTar->AddColumn("id", "ID", "ID");
  Fieldg->SetReadOnly();
  Fieldg->SetWidth(80);

  /*Fieldg = DBGrGrTar->AddColumn("CODE", "���", "��� ������");
   Fieldg->SetWidth(30);
    */
  Fieldg = DBGrGrTar->AddColumn("Flag_priv", "��./���.", "��� ��. ��� ���.���");
  Fieldg->AddFixedVariable("False", "��. ");
  Fieldg->AddFixedVariable("True","���. ");
  Fieldg->SetDefValue("False");
  Fieldg->SetWidth(40);

  Fieldg = DBGrGrTar->AddColumn("NAME", "������ ������������", "������ ������������ ������");
  Fieldg->SetRequired("������������ ������ ���� ��������");
  Fieldg->SetWidth(280);

    Fieldg = DBGrGrTar->AddColumn("dt_end", "���� �����", "");

  Fieldg->SetWidth(100);
     DBGrGrTar->OnDrawColumnCell=TarifDrawColumnCell;

  //DBGrGrTar->Table->IndexFieldNames="dt_end,id";
  DBGrGrTar->Table->IndexFieldNames="flag_priv;id";
  TWTDBGrid* DBGrTar=new TWTDBGrid(DocTar, "aci_tarif_tbl");
  TWTPanel* PTar=DocTar->MainPanel->InsertPanel(300,false,300);
  //TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
   F->Color=clFuchsia	;
  PTar->Params->AddText("�a����",10,F,Classes::taCenter,true)->ID="NameTar";
  PTar->Params->AddGrid(DBGrTar,true)->ID="Tarif";
  DBGrTar->Table->AddLookupField("class_tarif","id_classtarif","eqi_classtarif_tbl","name","id");
      ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
       DBGrTar->ReadOnly=true;

  DBGrTar->Table->Open();
  DBGrTar->Table->IndexFieldNames = "id";
  DBGrTar->Table->LinkFields = "id=id_grouptarif";
  DBGrTar->Table->MasterSource = DataSource;
  DBGrTar->OnExit=ExitParamsGrid;
  TWTField *Field;
  DBGrTar->AfterPost=AfterPostGrT;
  DBGrTar->ToolBar->AddButton("InsForm", "������ ������", AciTarifAll);

  Field = DBGrTar->AddColumn("class_tarif", "�����", "������������ ������ ������");
  Field->SetOnHelp(EqiClassTarifSpr);
  Field->SetWidth(100);

  Field = DBGrTar->AddColumn("NAME", "������������", "������������ ������");
  Field->SetWidth(200);

  Field = DBGrTar->AddColumn("SHORT_NAME", "����.", "����������� ������������ ������");
  Field->SetWidth(120);

  Field = DBGrTar->AddColumn("dt_begin", "���� ���������", "���� ��������� ������");
  Field = DBGrTar->AddColumn("value", "�����", "������");

  DocTar->MainPanel->SetVResize(300);
  TWTPanel* PDTar=DocTar->MainPanel->InsertPanel(400,true,200);
  TWTDBGrid* DBGrDTar = new TWTDBGrid(DocTar, "acd_tarif_tbl");
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
   DocTar->MainPanel->SetVResize(200);
  PDTar->Params->AddText("������� �������",18,F,Classes::taCenter,false);
  PDTar->Params->AddGrid(DBGrDTar, true)->ID="DTarif";
  DBGrDTar->Table->AddLookupField("currency", "IDk_currency", "cmi_currency_tbl", "short_name","id");
 // DBGrDTar->Table->AddLookupField("Doc","id_doc","dcm_doc_tbl","reg_num","id");

  /*DBGrDTar->Table->DataSet->AddIndex("DT", "id_tarif;dt_begin;idk_currency", TIndexOptions() << ixUnique << ixCaseInsensitive);
  DBGrDTar->Table->IndexDefs->Items[DBGrDTar->Table->IndexDefs->Count-1]->DescFields = "TransDate;Company";
    */
         ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
       DBGrDTar->ReadOnly=true;
  DBGrDTar->Table->Open();
  //DBGrRegion->ReadOnly=true;
  DBGrDTar->Table->IndexFieldNames = "id_tarif,dt_begin";
  DBGrDTar->Table->LinkFields = "id=id_tarif";
  DBGrDTar->Table->MasterSource = DBGrTar->DataSource;
  DBGrDTar->OnExit=ExitParamsGrid;
  TWTField *Fields;
  Fields = DBGrDTar->AddColumn("dt_begin", "���� ���������", "���� ��������� ������");
 // Fields->SetRequired("���� ������ ���� ��������");


  Fields = DBGrDTar->AddColumn("value", "�����", "������");

  Fields = DBGrDTar->AddColumn("currency", "������", "������");

  DBGrTar->FieldSource = DBGrTar->Table->GetTField("id");
  DBGrTar->FieldDest = Sender;

  DBGrDTar->Table->IndexDefs->Add("Dt_Begin","id_tarif;dt_begin",
  TIndexOptions() << ixDescending	);
  DBGrDTar->Table->IndexDefs->Items[DBGrDTar->Table->IndexDefs->Count-1]->DescFields = "id_tarif;dt_begin";
  DBGrDTar->Table->IndexName="Dt_Begin";

  DBGrDTar->FieldSource = DBGrTar->Table->GetTField("id");
  DBGrDTar->FieldDest = Sender;
  DBGrDTar->AfterPost=AfterPostGrD;
   DocTar->ShowAs(WinName);
   DocTar->SetCaption("���������� ������� "); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  DocTar->LoadFromFile(DocTar->DocFile);
  DocTar->Constructor=true;
  // ---------------------------------------------
      TWTQuery *AdrTar=new TWTQuery(this);
   int edidGr;
   int edidTar;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();
  int tar=0;
   bool try_field=false;
   if (Sender!=NULL)
    try {
       int val_field= Sender->Field->AsVariant;
       tar= Sender->Field->AsVariant;
       try_field=true;
     } catch (...){};
    if (id_tar!=0)
     {
       int val_field= id_tar;
       try_field=true;
       tar=id_tar;
     }
     if ((Sender!=NULL && try_field) || (DBGrTar->StringDest!=NULL)|| (tar!=0))
    {  AdrTar->Sql->Clear();
      AdrTar->Sql->Add("Select * from aci_tarif_tbl where id="+ToStrSQL(tar));
      AdrTar->Open();
      edidTar=AdrTar->FieldByName("id_grouptarif")->AsInteger;

      bool t1=DBGrGrTar->DataSource->DataSet->Locate("id",edidTar ,SearchOptions);
    }
//-----------------------------------------------------

  DocTar->MainPanel->ParamByID("DTarif")->Control->SetFocus();
  DocTar->MainPanel->ParamByID("Tarif")->Control->SetFocus();
  DocTar->MainPanel->ParamByID("GroupTarif")->Control->SetFocus();

  return DBGrTar;
};



void  _fastcall TMainForm::TarifDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   TDateTime dat_end;
 TDBGrid* t=(TDBGrid*)Sender;
 dat_end =t->DataSource->DataSet->FieldByName("dt_end")->AsDateTime;
     if (!(t->DataSource->DataSet->FieldByName("dt_end")->IsNull) )
     {    t->Canvas->Brush->Color=0x00e3bede;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };
}


void _fastcall TMainForm::AfterPostGrT(TWTDBGrid *Sender) {
 TWTPanel *MPanel= ((TWTDoc*)(Sender->Owner))->MainPanel;
 TWTDBGrid *GrStr= ((TWTDBGrid *)MPanel->ParamByID("DTarif")->Control);
  GrStr->Table->Refresh();
};

void _fastcall TMainForm::AfterPostGrD(TWTDBGrid *Sender) {
 TWTPanel *MPanel= ((TWTDoc*)(Sender->Owner))->MainPanel;
 TWTDBGrid *GrStr= ((TWTDBGrid *)MPanel->ParamByID("Tarif")->Control);
  GrStr->Table->Refresh();
};

void  _fastcall TMainForm::AciTarifAll(TObject *Sender) {

 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender)->Parent;
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

 TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,"aci_tarif_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
   TWTDBGrid* DBGrTar= WGrid->DBGrid;
  DBGrTar->Table->AddLookupField("class_tarif","id_classtarif","eqi_classtarif_tbl","name","id");
  DBGrTar->Table->AddLookupField("group_tarif","id_grouptarif","eqi_grouptarif_tbl","name","id");
  DBGrTar->Table->AddLookupField("f_priv","id_grouptarif","eqi_grouptarif_tbl","name","id");
  Table->Open();

  TWTField *Field;

  Field = DBGrTar->AddColumn("group_tarif", "������ ������", "������ ������");
  Field->SetOnHelp(EqiGroupTarifSpr);
  Field->SetWidth(120);


  Field = DBGrTar->AddColumn("class_tarif", "�����", "������������ ������ ������");
  Field->SetOnHelp(EqiClassTarifSpr);
  Field->SetWidth(120);

  Field = DBGrTar->AddColumn("id", "���", "��� ������");
  Field->SetWidth(100);

  Field = DBGrTar->AddColumn("NAME", "������������", "������������ ������");
  Field->SetWidth(200);

  Field = DBGrTar->AddColumn("SHORT_NAME", "����.", "����������� ������������ ������");
  Field->SetWidth(120);

  Field = WGrid->AddColumn("value", "��������", "��������");

  Field = WGrid->AddColumn("dt_begin", "���� ����.", "���� ���������� ������");
 //if Sender-
  DBGrTar->Table->IndexFieldNames="id_grouptarif";
  DBGrTar->FieldSource = DBGrTar->Table->GetTField("id");
  if (Sender->ClassNameIs("TWTField"))
    DBGrTar->FieldDest = ((TWTField *)Sender);

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

  return ;
};
#undef WinName

#define WinName "���������� ����� �������"
void  _fastcall TMainForm::EqiGroupTarifBtn(TObject *Sender) {
 EqiGroupTarifSpr(NULL);
};
void  _fastcall TMainForm::EqiGroupTarifSpr(TWTField *Sender) {
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }

 TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqi_grouptarif_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
   TWTDBGrid* DBGrTar= WGrid->DBGrid;
  int  ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
       WGrid->DBGrid->ReadOnly=true;

  Table->Open();
 TWTField *Fieldg;

  Fieldg = DBGrTar->AddColumn("NAME", "������������", "������������ ������");
  Fieldg->SetRequired("������������ ������ ���� ��������");
  Fieldg->SetWidth(280);

  Fieldg = DBGrTar->AddColumn("Flag_priv", "��./���.", "��� ��. ��� ���.���");
  Fieldg->AddFixedVariable("False", "_��. ");
  Fieldg->AddFixedVariable("True","���. ");
  Fieldg->SetDefValue("False");
  Fieldg->SetWidth(40);

  Fieldg = DBGrTar->AddColumn("id", "ID", "ID");
  Fieldg->SetReadOnly();
  Fieldg->SetWidth(80);

  DBGrTar->Table->IndexFieldNames="flag_priv;ident";

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

  return;
};


#undef WinName
#define WinName "���������� ���"
void _fastcall TMainForm::EqkZoneBtn(TObject *Sender) {
  EqkZoneSpr(NULL);
}

void _fastcall TMainForm::EqkZoneSpr(TWTField *Sender) {
 EqkZoneSel(Sender);
};

TWTWinDBGrid* _fastcall TMainForm::EqkZoneSel(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_zone_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
   int  ChLevel =CheckLevelRead("���������� ���");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
       WGrid->DBGrid->ReadOnly=true;
  Table->Open();

  TWTField *Field;
  Field = WGrid->AddColumn("name", "������������", "������������");
  Field = WGrid->AddColumn("comment", "����������", "����������");
  Field->SetWidth(200);
  Field = WGrid->AddColumn("koef", "�����������", "������ ����������");
    Field = WGrid->AddColumn("hours", "������������", "������������");
  Field = WGrid->AddColumn("dt_begin", "���� ���������", "���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
  return WGrid;
};

#undef WinName

#define WinName "���������� ������� �������"
void _fastcall TMainForm::EqiClassTarifBtn(TObject *Sender) {
  EqiClassTarifSpr(NULL);
}

void _fastcall TMainForm::EqiClassTarifSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqi_classtarif_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;

   int  ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
       WGrid->DBGrid->ReadOnly=true;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("name", "������������ ������", "������������ ������");
  Field = WGrid->AddColumn("short_name", "����.������������", "����������� ������������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("Eqi_classtarif");

};

#undef WinName

#define WinName "���������� ������ �����"
void _fastcall TMainForm::CmmCurrencyBtn(TObject *Sender)
 {
  CmmCurrencySpr(NULL);
}


void  _fastcall TMainForm::CmmCurrencySpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }
  TWTDoc *DocCur=new TWTDoc(this,"");

  TWTDBGrid* DBGrCur=new TWTDBGrid(DocCur, "cmi_currency_tbl");
  TWTPanel* PCur=DocCur->MainPanel->InsertPanel(500,false,200);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PCur->Params->AddText("������",10,F,Classes::taCenter,true)->ID="NameVal";
  PCur->Params->AddGrid(DBGrCur,true)->ID="Currency";
  //DBGr->Table->AddLookupField("Doc","id_doc","dcm_doc_tbl","reg_num","id");
   int  ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
       DBGrCur->ReadOnly=true;
  DBGrCur->Table->Open();
  DBGrCur->Table->IndexFieldNames="short_name";
  TDataSource *DataSource=DBGrCur->DataSource;
  DBGrCur->OnExit=ExitParamsGrid;
  //DBGrDomain->ReadOnly=true;
  TWTField *Field;

  Field = DBGrCur->AddColumn("Name", "������������", "������������");
  //Field->SetRequired("������������ ������ ���� ���������");

  Field = DBGrCur->AddColumn("Short_Name", "�����������", "�����������");
  Field = DBGrCur->AddColumn("code", "���", "���");




 TWTPanel* PMCur=DocCur->MainPanel->InsertPanel(300,false,200);
  TWTDBGrid* DBGrMCur = new TWTDBGrid(DocCur, "cmm_currency_tbl");
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PMCur->Params->AddText("����� �����",18,F,Classes::taCenter,false);
  PMCur->Params->AddGrid(DBGrMCur, true)->ID="MCurrency";

  DBGrMCur->Table->Open();
  //DBGrRegion->ReadOnly=true;
  DBGrMCur->Table->IndexFieldNames = "date_currency";
  DBGrMCur->Table->LinkFields = "id=id_currency";
  DBGrMCur->Table->MasterSource = DataSource;
  DBGrMCur->OnExit=ExitParamsGrid;
  TWTField *Fields;
  Fields = DBGrMCur->AddColumn("date_currency", "���� ", "����");
 // Fields->SetRequired("���� ������ ���� ��������");


  Fields = DBGrMCur->AddColumn("value", "������", "������");
 // Fields->SetRequired("������ ������ ���� ��������");

  DBGrCur->FieldSource = DBGrCur->Table->GetTField("id");
  DBGrCur->FieldDest = Sender;



   DocCur->MainPanel->SetHResize(100);
   DocCur->ShowAs("Tarif");
   DocCur->SetCaption("���������� ������ ����� "); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  //DocAdr->ID="AdmAdrM";
  DocCur->LoadFromFile(DocCur->DocFile);
  DocCur->Constructor=true;


  DocCur->MainPanel->ParamByID("MCurrency")->Control->SetFocus();
  DocCur->MainPanel->ParamByID("Currency")->Control->SetFocus();
  //DocTar->MainPanel->ParamByID("Tarif")->Control->SetFocus();
};

/* Table->SetFilter("term=0")
  Teble->Filtered=true;
  */




#define WinName "���������� ������� "
void _fastcall TMainForm::CmiTaxBtn(TObject *Sender)
 {
  CmiTaxSpr(NULL);
}

void  _fastcall TMainForm::CmiTaxSpr(TWTField *Sender) {
CmiTaxSel(Sender);
}

TWTDBGrid*  _fastcall TMainForm::CmiTaxSel(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTDoc *DocTax=new TWTDoc(this,"");
   TWTDBGrid* DBGrTax=new TWTDBGrid(DocTax, "cmi_tax_tbl");

  TWTPanel* PGrTax=DocTax->MainPanel->InsertPanel(400,false,150);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PGrTax->Params->AddText("���������� �������",10,F,Classes::taCenter,true)->ID="NameTax";
  PGrTax->Params->AddGrid(DBGrTax,true)->ID="Tax";
   int  ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
       DBGrTax->ReadOnly=true;

  DBGrTax->Table->Open();
  DBGrTax->Table->IndexFieldNames="name";
  TDataSource *DataSource=DBGrTax->DataSource;
  DBGrTax->OnExit=ExitParamsGrid;
  //DBGrDomain->ReadOnly=true;
  TWTField *Fieldg;


  Fieldg = DBGrTax->AddColumn("NAME", "������������", "������������");
  Fieldg->SetRequired("������������  ������ ���� ���������");
  Fieldg->SetWidth(200);
  Fieldg = DBGrTax->AddColumn("SHORT_NAME", "����������", "����������");
 // Fieldg->SetRequired("������������  ������ ���� ���������");
  Fieldg->SetWidth(100);

  Fieldg = DBGrTax->AddColumn("ident", "��������", "��������");
  Fieldg->AddFixedVariable("tax", "���      ");
  Fieldg->AddFixedVariable("nbu","������ ���");
  Fieldg->AddFixedVariable("inf","% ��������");
  Fieldg->SetDefValue("         ");
  Fieldg->SetWidth(100);


  TWTDBGrid* DBGrTaxD=new TWTDBGrid(DocTax, "cmd_tax_tbl");
  TWTPanel* PTaxD=DocTax->MainPanel->InsertPanel(300,false,150);
  //TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PTaxD->Params->AddText("������ �������",10,F,Classes::taCenter,true)->ID="NameDTax";
  PTaxD->Params->AddGrid(DBGrTaxD,true)->ID="TaxRate";
    ChLevel =CheckLevelRead("���������� �������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
       DBGrTaxD->ReadOnly=true;
  DBGrTaxD->Table->Open();
 // DBGrTar->Table->IndexFieldNames="name";
  DBGrTaxD->Table->IndexFieldNames = "id";
  DBGrTaxD->Table->LinkFields = "id=id_tax";
  DBGrTaxD->Table->MasterSource = DataSource;

  DBGrTaxD->OnExit=ExitParamsGrid;
  TWTField *Field;

  Field = DBGrTaxD->AddColumn("date_inst", "���� ���������", "����");
  Field->SetRequired("���� ������ ���� ���������");
  Field->SetWidth(120);

  Field = DBGrTaxD->AddColumn("value", "������", "������ ������");
  Field->SetWidth(100);

  Field = DBGrTaxD->AddColumn("val_begin", "���.������", "������ ������");
  Field->SetWidth(100);

  Field = DBGrTaxD->AddColumn("val_end", "����.������", "������� ������");
  Field->SetWidth(100);


  DBGrTax->FieldSource = DBGrTax->Table->GetTField("id");
  DBGrTax->FieldDest = Sender;
   DocTax->ShowAs(WinName);
   DocTax->SetCaption("���������� ������� "); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  //DocAdr->ID="AdmAdrM";
  DocTax->LoadFromFile(DocTax->DocFile);
  DocTax->Constructor=true;


  DocTax->MainPanel->ParamByID("TaxRate")->Control->SetFocus();
  DocTax->MainPanel->ParamByID("Tax")->Control->SetFocus();
  return DBGrTax;
};
#define WinName "���������� ���������"
void _fastcall TMainForm::EqiTMeterSpr(TWTField * Sender) {

  // ���������� ���������
  TWTQuery *QueryAdr;
    TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  //TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max, " );
  QueryAdr->Sql->Add("kind_meter,kind_count,phase,carry,schema_inst,hook_up,amperage_nom_s,voltage_nom_s,");
  QueryAdr->Sql->Add("zones,zone_time_min,term_control,show_def ");
  QueryAdr->Sql->Add("from eqi_meter_tbl order by type;");

  TWTWinDBGrid *WMeterGrid =  new TWTWinDBGrid(this, QueryAdr,false);
 //   WMeterGrid = new TfEqpSpr(this, QueryAdr,false,true);
  WMeterGrid->SetCaption(WinName);
  TWTQuery* Query = WMeterGrid->DBGrid->Query;
  Query->AddLookupField("PHASENAME", "phase", "eqk_phase_tbl", "name","id");
  Query->AddLookupField("KINDMETER", "kind_meter", "eqk_meter_tbl", "name","id");
   int  ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
       WMeterGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");
  NList->Add("type");
  NList->Add("normative");
  NList->Add("voltage_nom");
  NList->Add("amperage_nom");
  NList->Add("voltage_max");
  NList->Add("amperage_max");
  NList->Add("kind_meter");
  NList->Add("kind_count");
  NList->Add("phase");
  NList->Add("carry");
  NList->Add("schema_inst");
  NList->Add("hook_up");
  NList->Add("amperage_nom_s");
  NList->Add("voltage_nom_s");
  NList->Add("zones");
  NList->Add("zone_time_min");
  NList->Add("term_control");

  Query->SetSQLModify("eqi_meter_tbl",WList,NList,true,false,true);
  TWTField *Field;

  Field = WMeterGrid->AddColumn("id", "���", "���");
  Field->SetReadOnly();


  Field = WMeterGrid->AddColumn("type", "���", "���");
  Field->SetReadOnly();
//  Field = WMeterGrid->AddColumn("normative", "����", "����, ��");
//  Field->SetReadOnly();

//  Field = WMeterGrid->AddColumn("KINDMETER", "���", "������������/�����������");
//  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("PHASENAME", "��������", "����������/����������");
  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("zones", "����", "������������ ���������� ���");
  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("carry", "�����������", "�����������");
  Field->SetReadOnly();

  Field = WMeterGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field->SetReadOnly();

  Field = WMeterGrid->AddColumn("show_def", "*", "����� ������������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("1");

  //WMeterGrid->DBGrid->OnAccept=MeterAccept;
  //WMeterGrid->DBGrid->BeforeInsert=NewMeterGr;
  WMeterGrid->DBGrid->ReadOnly=true;
  WMeterGrid->DBGrid->Visible = true;
  WMeterGrid->DBGrid->Options>>dgEditing;
   WMeterGrid->DBGrid->FieldSource = WMeterGrid->DBGrid->Query->GetTField("id");
  WMeterGrid->DBGrid->FieldDest = Sender;
  WMeterGrid->DBGrid->FieldLook=WMeterGrid->DBGrid->Query->GetTField("type");

  TWTToolBar* tb=WMeterGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
   
    btn=(TWTToolButton*)(tb->Buttons[i]);
 /*   if ( btn->ID=="Full")
     //  tb->Buttons[i]->OnClick=MeterAccept;
    if ( btn->ID=="NewRecord")
      // tb->Buttons[i]->OnClick=NewMeter;
   */
   };
  WMeterGrid->ShowAs(WinName);
  WMeterGrid->OnCloseQuery=MeterGridClose;
  return ;
};
#undef WinName

#define WinName "���� ��������"
void _fastcall TMainForm::AciPrefSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "aci_pref_tbl",false);
  WGrid->SetCaption(WinName);

 // WGrid->DBGrid->IncrField="id";
  //WGrid->DBGrid->IncrExpr="SELECT currval('clm_state_seq') as GEN_ID";

  TWTTable* Table = WGrid->DBGrid->Table;
    int  ChLevel =CheckLevelRead("����������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
       WGrid->DBGrid->ReadOnly=true;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ���� ��������");
 // Field->SetRequired("��� ������ ���� ��������");

  Field = WGrid->AddColumn("Name", "��� ��������", "��� ��������");
 // Field->SetRequired("��� ������ ���� ��������");

  Field = WGrid->AddColumn("Comment", "��������", "��������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName




#define WinName "���������� �����������"

void _fastcall TMainForm::ClmOrgBtn(TObject *Sender) {
 ClmOrgSpr(NULL);
}

void _fastcall TMainForm::ClmOrgSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "clm_org_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
     int  ChLevel =CheckLevelRead("���������� �����������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
       WGrid->DBGrid->ReadOnly=true;
  Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("name", "�����������", "�����������");
  Field = WGrid->AddColumn("short_name", "������� ������������", "������� ������������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("name");
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName

void _fastcall TMainForm::SelBookAbon(TObject *Sender)
{
  Form = new TWTParamsForm(this, "������� ����� ");
  Form->OnAccept =EqmAbonFiz;
  TStringList *SQL = new TStringList();
                // AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break){
  Form->Params->AddSimple("����� ",90,"",true);
  Form->Params->Get(0)->Value = "";

  Form->TForm::ShowModal();
  Form->Close();
};

#define WinName " ������ ���. ��������� �� ������"
void __fastcall  TMainForm::EqmAbonFiz(TWTParamsForm *Sender, bool &flag)
{
  // ���������� ���������
  Form->Hide();
   AnsiString books=Form->Params->Get(0)->Value;
  int pbook = StrToInt(books);
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }
  TWTQuery *QueryP;
  QueryP = new  TWTQuery(this);
  QueryP->Options.Clear();
  QueryP->Options << doQuickOpen;

  QueryP->Sql->Clear();

  QueryP->Sql->Add("select * from  clm_pclient_tbl where book=:pbook order by  book, code  " );
  QueryP->ParamByName("pbook")->AsInteger=pbook;
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryP,true);

  WGrid->SetCaption(WinName);

    TWTQuery *QueryAdr;
 /* QueryAdr = new  TWTQuery(this);
  QueryAdr->Options.Clear();
  QueryAdr->Options << doQuickOpen;
  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select * from adv_commadr_tbl");
  QueryAdr->Open();    */
  // QueryP->AddLookupField("town_street", "id_street", "adv_commadr_tbl", "town_street","id_street");
  //WGrid->Query->IndexDefs->Add("reg_date","reg_date" , TIndexOptions() << ixDescending	);

  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->Options << doQuickOpen;
 //int ChLevel =CheckLevelRead("����� ����������� ���.���");
 int ChLevel =CheckLevel("����� ����������� ���.���");
  if  (ChLevel==0) {
     return ;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id_eqpborder");
  NList->Add("book");
  NList->Add("code");
  //NList->Add("adr");

  Query->SetSQLModify("clm_pclient_tbl",WList,NList,true,true,true);

  TWTField *Field;
  Field = WGrid->AddColumn("book", "�����", "�����");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("code", "����", "������� ����");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("name", "�������", "�������");
  Field->SetWidth(300);
//  Field = WGrid->AddColumn("town_street", "�����", "�����");
//  Field->SetOnHelp(AdmCommAdrSpr);
  Field = WGrid->AddColumn("Build", "���", "���");
  Field = WGrid->AddColumn("Build_add", "������", "������");
  Field = WGrid->AddColumn("office", "��������", "��������");
  Field = WGrid->AddColumn("address", "����� �������", "����� �������");
  Field = WGrid->AddColumn("id_eqpborder", "��� ������������", "��� ������������");
  Field->SetReadOnly();

  Query->IndexFieldNames="book;code";
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
#undef WinName

/*    askue  */

  void _fastcall TMainForm::SelAskueDay(TObject *Sender)
{
  Form = new TWTParamsForm(this, "������� ���� ");
  Form->OnAccept =AskueDay;
  TStringList *SQL = new TStringList();
                // AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break){

  Form->Params->AddDate("����",90,true);
  Form->Params->Get(0)->Value = Date();

  Form->TForm::ShowModal();
  Form->Close();
};

#define WinName " ���������� ����� �� 0:00 ����� "
void __fastcall  TMainForm::AskueDay(TWTParamsForm *Sender, bool &flag)
{
  // ���������� ���������
  Form->Hide();
  TDateTime pdate = Form->Params->Get(0)->Value;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }
  TWTQuery *QueryP;
  QueryP = new  TWTQuery(this);
  QueryP->Options.Clear();
  QueryP->Options << doQuickOpen;

  QueryP->Sql->Clear();

  QueryP->Sql->Add("select  id_file ,  id_meter ,   id_client ,  \
    code as code_client, c.name as name_client,  num_meter ,  \
    kind_energy , ke.name as name_energy , id_zone,kz.name as name_zone, date_ind , \
     stime ,  indic ,  id_area , name_eqp as name_area \
   from  ask_indic_tbl d left join  clm_client_tbl c  on c.id=d.id_client  \
    left join ( select * from eqm_equipment_tbl where type_eqp=11 order by id ) a on a.id=d.id_area    \
    left join eqk_energy_tbl ke on d.kind_energy=ke.id \
   left join eqk_zone_tbl kz on d.id_zone=kz.id   \
     where date_ind=:pdate order by   code,name_area, num_meter,kind_energy,id_zone,stime " );
  QueryP->ParamByName("pdate")->AsDate=pdate;
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryP,true);

  WGrid->SetCaption(WinName);

    TWTQuery *QueryAdr;


  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->Options << doQuickOpen;
 int ChLevel =CheckLevel("������� �����");
  if  (ChLevel==0) {
     return ;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("code_client");
  NList->Add("name_client");
  NList->Add("name_energy");
  NList->Add("name_area");
    NList->Add("name_zone");
  //NList->Add("adr");

  Query->SetSQLModify("ask_demand_tbl",WList,NList,false,false,false);

  TWTField *Field;

  Field = WGrid->AddColumn("code_client", "����", "������� ����");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("name_client", "�������", "�������");
  Field->SetWidth(200);
  Field = WGrid->AddColumn("name_area", "��������", "��������");
    Field->SetWidth(200);
  Field = WGrid->AddColumn("id_meter", "id �������� ", "id ��������");
   Field->SetWidth(100);
  Field = WGrid->AddColumn("num_meter", "����� �������� ", "����� ��������");
   Field->SetWidth(200);
  Field = WGrid->AddColumn("name_energy", "��� �������", "��� �������");
    Field->SetWidth(100);
    Field = WGrid->AddColumn("name_zone", "����", "����");
        Field->SetWidth(100);
  Field = WGrid->AddColumn("date_ind", "����", "����");
      Field->SetWidth(100);
  //Field = WGrid->AddColumn("stime", "�����", "�����");
  Field = WGrid->AddColumn("indic", "���������", "���������");
  Field->SetReadOnly();
    Field = WGrid->AddColumn("id_file", "����", "����");
  Field->SetReadOnly();

 // Query->IndexFieldNames="code_client,name_area, num_meter,stime";
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
#undef WinName

/*    askue  */

  void _fastcall TMainForm::SelAskueHour(TObject *Sender)
{
  Form = new TWTParamsForm(this, "������� ���� ");
  Form->OnAccept =AskueHour;
  TStringList *SQL = new TStringList();
                // AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break){

  Form->Params->AddDate("����",90,true);
  Form->Params->Get(0)->Value = Date();

  Form->TForm::ShowModal();
  Form->Close();
};

#define WinName " ���������� ����� ��������� "
void __fastcall  TMainForm::AskueHour(TWTParamsForm *Sender, bool &flag)
{
  // ���������� ���������
  Form->Hide();
  TDateTime pdate = Form->Params->Get(0)->Value;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }
  TWTQuery *QueryP;
  QueryP = new  TWTQuery(this);
  QueryP->Options.Clear();
  QueryP->Options << doQuickOpen;

  QueryP->Sql->Clear();

  QueryP->Sql->Add("select  id_file ,  id_meter ,   id_client ,\
    code as code_client, c.short_name as name_client,  num_meter ,   \
    kind_energy , ke.name as name_energy ,  date_ind ,  stime ,  demand ,  id_area , name_eqp as name_area \
   from  ask_demand_tbl d left join  clm_client_tbl c  on c.id=d.id_client   \
    left join ( select * from eqm_equipment_tbl where type_eqp=11 order by id ) a on a.id=d.id_area \
    left join eqk_energy_tbl ke on d.kind_energy=ke.id   \
     where date_ind=:pdate order by   code,name_area, num_meter,kind_energy,stime  " );
  QueryP->ParamByName("pdate")->AsDate=pdate;
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryP,true);

  WGrid->SetCaption(WinName);

    TWTQuery *QueryAdr;


  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->Options << doQuickOpen;
 int ChLevel =CheckLevel("��������� �����");
  if  (ChLevel==0) {
     return ;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("code_client");
  NList->Add("name_client");
  NList->Add("name_energy");
  NList->Add("name_area");
  //NList->Add("adr");

  Query->SetSQLModify("ask_demand_tbl",WList,NList,false,false,false);

  TWTField *Field;

  Field = WGrid->AddColumn("code_client", "����", "������� ����");
  Field->SetReadOnly();
    Field->SetWidth(100);
  Field = WGrid->AddColumn("name_client", "�������", "�������");
  Field->SetWidth(200);
  Field = WGrid->AddColumn("name_area", "��������", "��������");
    Field->SetWidth(200);
  Field = WGrid->AddColumn("id_meter", "id �������� ", "id ��������");
  Field = WGrid->AddColumn("num_meter", "����� �������� ", "����� ��������");
    Field->SetWidth(100);
  Field = WGrid->AddColumn("name_energy", "��� �������", "��� �������");
    Field->SetWidth(100);
  Field = WGrid->AddColumn("date_ind", "����", "����");
    Field->SetWidth(100);
  Field = WGrid->AddColumn("stime", "�����", "�����");
    Field->SetWidth(100);
  Field = WGrid->AddColumn("demand", "������", "������");
  Field->SetReadOnly();
    Field = WGrid->AddColumn("id_file", "����", "����");
  Field->SetReadOnly();

 // Query->IndexFieldNames="code_client,name_area, num_meter,stime";
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
#undef WinName


  void _fastcall TMainForm::SelAskueLimit(TObject *Sender)
{
  Form = new TWTParamsForm(this, "������� ���� ");
  Form->OnAccept =AskueLimit;
  TStringList *SQL = new TStringList();
                // AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break){

  Form->Params->AddDate("����",90,true);
  Form->Params->Get(0)->Value = Date();

  Form->TForm::ShowModal();
  Form->Close();
};

#define WinName " ���������� ����� �� 0:00 ����� "
void __fastcall  TMainForm::AskueLimit(TWTParamsForm *Sender, bool &flag)
{

  // ���������� ���������
  Form->Hide();
  TDateTime pdate = Form->Params->Get(0)->Value;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }
  TWTQuery *QueryP;
  QueryP = new  TWTQuery(this);
  QueryP->Options.Clear();
  QueryP->Options << doQuickOpen;

  QueryP->Sql->Clear();
  /*
  select cl.id,cl.mmgg,c.code,c.short_name,e.name_eqp,cl.hours, \
   cl.limit1,cl.limit2,cl.dt_ind1,cl.dt_ind2, day1,day2,clc_pwr1,clc_pwr2, \
  rd.avg_demand,rd.max_demand as max_day,rd.koef as koef_day,             \
 rn.max_demand as max_night,rn.koef as koef_night,              \
 clc_lim_day,clc_lim_night,bron,fin_lim_day,fin_lim_night       \
  from ask_calclimit_tbl cl,clm_client_tbl c, eqm_equipment_h e,  \
ask_regim_tbl rd,ask_regim_tbl rn                               \
where c.id=cl.id_client and e.id=cl.id_area                      \
and rd.id_client=cl.id_client and rd.id_area=cl.id_area and rd.night_day=1 \
 and ((cl.dt_doc>=rn.dt_b and cl.dt_doc<=rn.dt_e) or  ((cl.dt_doc-interval '1 year')::date>= rd.dt_b) and ((cl.dt_doc-interval '1 year')::date<= rd.dt_e)  ) \
and rn.id_client=cl.id_client and rn.id_area=cl.id_area  and rn.night_day=2 \
 and ((cl.dt_doc>=rn.dt_b and cl.dt_doc<=rn.dt_e) or  ((cl.dt_doc-interval '1 year')::date>= rn.dt_b) and ((cl.dt_doc-interval '1 year')::date<= rn.dt_e)  ) \
 and bom(cl.dt_doc)=bom(:pdate)  \
 */

  QueryP->Sql->Add("  select cl.id,cl.mmgg,c.code,c.short_name,e.name_eqp,cl.hours, \
   cl.limit1,cl.limit2,cl.dt_ind1,cl.dt_ind2, day1,day2,clc_pwr1,clc_pwr2, \
  rd.avg_demand,rd.max_demand as max_day,rd.koef as koef_day,             \
 rn.max_demand as max_night,rn.koef as koef_night,              \
 clc_lim_day,clc_lim_night,bron,fin_lim_day,fin_lim_night       \
  from ask_calclimit_tbl cl,clm_client_tbl c, eqm_equipment_h e,  \
ask_regim_tbl rd,ask_regim_tbl rn                               \
where c.id=cl.id_client and e.id=cl.id_area                      \
and rd.id_client=cl.id_client and rd.id_area=cl.id_area and rd.night_day=1 \
 and ((cl.dt_doc>=rn.dt_b and cl.dt_doc<=rn.dt_e) or  ((cl.dt_doc-interval '1 year')::::date>= rd.dt_b) and ((cl.dt_doc-interval '1 year')::::date<= rd.dt_e)  ) \
and rn.id_client=cl.id_client and rn.id_area=cl.id_area  and rn.night_day=2 \
 and ((cl.dt_doc>=rn.dt_b and cl.dt_doc<=rn.dt_e) or  ((cl.dt_doc-interval '1 year')::::date>= rn.dt_b) and ((cl.dt_doc-interval '1 year')::::date<= rn.dt_e)  ) \
 and bom(cl.dt_doc)=bom(:pdat)   " );


  QueryP->ParamByName("pdat")->AsDate=pdate;
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryP,true);

  WGrid->SetCaption(WinName);

    TWTQuery *QueryAdr;


  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->Options << doQuickOpen;
 int ChLevel =CheckLevel("������ ������");
  if  (ChLevel==0) {
     return ;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("code");
  NList->Add("short_name");
  NList->Add("name_eqp");

  NList->Add("avg_demand");
  NList->Add("max_day");
  NList->Add("koef_day");
  NList->Add("max_night");
  NList->Add("koef_night");
   
  //NList->Add("adr");

  Query->SetSQLModify("ask_calclimit_tbl",WList,NList,false,false,false);

  TWTField *Field;

  Field = WGrid->AddColumn("code", "����", "������� ����");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("short_name", "�������", "�������");
  Field->SetWidth(200);
  Field = WGrid->AddColumn("name_eqp", "��������", "��������");
    Field->SetWidth(200);
  Field = WGrid->AddColumn("hours", "�.�����", "�.�����");
   Field->SetWidth(100);
  Field = WGrid->AddColumn("limit1", "���.�����", "����� �������� ������");
   Field->SetWidth(200);
  Field = WGrid->AddColumn("limit2", "����.�����", "����� ���������� ������");
  Field->SetWidth(100);
  Field = WGrid->AddColumn("dt_ind1", "���� ���.���", "���� �������� ������");
  Field = WGrid->AddColumn("dt_ind2","���� ����.���", "���� ���������� ������");
   Field = WGrid->AddColumn("day1", "���� ���.���", "���� �������� ������");
    Field = WGrid->AddColumn("day2","���� ����.���", "���� ���������� ������");
   Field = WGrid->AddColumn("avg_demand","��.���.����", "�������������� ��� ���");
   Field = WGrid->AddColumn("max_day", "����.����", "�������� ��������� ��� ����");
  Field = WGrid->AddColumn("max_night","����.����", "�������� ��������� ��� �����");
  Field = WGrid->AddColumn("koef_day", "����.����", "����. ��������� ��� ����");
  Field = WGrid->AddColumn("koef_night","����.����", "����. ��������� ��� �����");

  Field = WGrid->AddColumn("clc_lim_day", "����.����", "����. ����� ��������� ��� ����");
  Field = WGrid->AddColumn("clc_lim_night","����.����", "����.����� ��������� ��� �����");
  Field = WGrid->AddColumn("bron","�����", "�����");
  Field = WGrid->AddColumn("fin_lim_day", "����.����", "����. ����� ��������� ��� ����");
  Field = WGrid->AddColumn("fin_lim_night","����.����", "����.����� ��������� ��� �����");



 // Query->IndexFieldNames="code_client,name_area, num_meter,stime";
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
#undef WinName

/*    end askue  */



#define WinName "���������� ����� ����� "
void _fastcall TMainForm::CmiGekBtn(TObject *Sender) {
  CmiGekSpr (NULL);
}

void _fastcall TMainForm::CmiGekSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,"adi_build_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
      int ChLevel =CheckLevelRead("���������� ����� �����");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
      WGrid->DBGrid->ReadOnly=true;
  Table->Open();
  TWTField *Field;
  Field = WGrid->AddColumn("num_gek", "����� ���", "����� ���");
  Field->SetRequired("������ ���� ���������");
  Field = WGrid->AddColumn("Name", "����� ����", "����� ����");
    Field = WGrid->AddColumn("code_eqp", "��� ������������ ", "��� ������������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("name");
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName


#define WinName "���������� ����� ��� �����"
void _fastcall TMainForm::CmiTimeBtn(TObject *Sender) {
  CmiTimeSpr(NULL);
}

void _fastcall TMainForm::CmiTimeSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cmi_time_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  WGrid->DBGrid->ReadOnly=true;
  Table->IndexFieldNames="id";
  Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("strtime", "�����", "�����");
  Field = WGrid->AddColumn("night_day", "����:����", "����:����");
  Field->AddFixedVariable("1", "����");
  Field->AddFixedVariable("2","����");
  Field->SetDefValue("1");
  Table->IndexFieldNames="id";
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("strtime");
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName

  void _fastcall TMainForm::SelAskueMG(TObject *Sender)
{
  Form = new TWTParamsForm(this, "������� ���� ");
  Form->OnAccept =PickHour;
  TStringList *SQL = new TStringList();
                // AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break){

  Form->Params->AddDate("����",90,true);
  Form->Params->Get(0)->Value = BOM(Date());

  Form->TForm::ShowModal();
  Form->Close();
};

#define WinName "���������� ����� �����"
void __fastcall  TMainForm::PickHour(TWTParamsForm *Sender, bool &flag)
{
  // ���������� ���������
  Form->Hide();
  TDateTime pdate = Form->Params->Get(0)->Value;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }
  TWTQuery *QueryP;
  QueryP = new  TWTQuery(this);
  QueryP->Options.Clear();
  QueryP->Options << doQuickOpen;

  QueryP->Sql->Clear();

  QueryP->Sql->Add("select * from ask_picktime_tbl where mmgg=:pmmgg order by mmgg desc,id_time  " );
  QueryP->ParamByName("pmmgg")->AsDate=BOM(pdate);
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryP,true);

  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
  Query->Options << doQuickOpen;
  int  ChLevel =CheckLevel("���������� ����� �����");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
      WGrid->DBGrid->ReadOnly=true;
      Query->AddLookupField("str_time","id_time","cmi_time_tbl","strtime","id");

  Query->Open();


  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();


  Query->SetSQLModify("ask_picktime_tbl",WList,NList,true,true,true);

  TWTField *Field;

  Field = WGrid->AddColumn("mmgg", "������ ()", "������");

    Field->SetWidth(100);
  Field = WGrid->AddColumn("str_time", "�����", "����� ������� ��������");
   Field->SetOnHelp(CmiTimeSpr);
  Field->SetWidth(200);
 // Query->IndexFieldNames="code_client,name_area, num_meter,stime";
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
#undef WinName



