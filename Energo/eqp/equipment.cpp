//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "equipment.h"
#include "fEqpAirLineDet.h"
#include "fComp.h"
#include "fCompI.h"
#include "fCable.h"
#include "fMeter.h"
#include "EqpList.h"
#include "EqpSpr.h"
#include "fChange.h"
#include "AreaList.h"
#include "AbonConnect.h"
#include "fPeriodSel.h"
#include "SysUser.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------
//TWTWinDBGrid *WEqpGrid;
TWTWinDBGrid *WCompGrid;
TWTWinDBGrid *WCompIGrid;
TWTWinDBGrid *WCableGrid;
TWTWinDBGrid *WMeterGrid;
TWTWinDBGrid *WTreeGrid;
TfMeterSpr *WMeterEdit;
TfCableSpr *WCableEdit;
TWTWinDBGrid *WF1Grid;
TDateTime mmgg_sel;

void _fastcall TMainForm::ShowEqpTree(TObject *Sender) {
     // �������� ����� �� ������, ������� �� ����� ������ ���������
     TWTPanel *TDoc;
     TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
     TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
     TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);

     Application->CreateForm(__classid(TfTreeForm), &fTreeForm);
     int abon_id=GrClient->Query->FieldByName("id")->AsInteger;
     fTreeForm->ShowAs("treeform");
     //fTreeForm->Caption=GrClient->Table->FieldByName("name")->AsString;
     fTreeForm->ShowTrees(abon_id);
}
//---------------------------------------------------------------------
void _fastcall TMainForm::ShowLog(TObject *Sender) {

  fLog=new TfLog(this);
  fLog->ShowAs("Log");
}
#define WinName "���������"
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiMatBtn(TObject *Sender) {
  EqiMatSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiMatSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
//   TWinControl *Owner=NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_materals_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


   int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
     Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("Name", "��������", "������������ ���������");
 // Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("ro", "r, ��*��2/�", "�������� �������������");
  Field = WGrid->AddColumn("ro_mantis", "*10", "�������� ��������� �������������");
//  Field->SetOnHelp(EqiMatSpr);
//  Field->SetRequired("������� ������ ���� ���������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
//  WGrid->DBGrid->OnAccept=WGrid->DBGrid->WinEditMenu;
  WGrid->ShowAs("eqk_materals_tbl");

};
#undef WinName

#define WinName "���� ��������"
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiCoverBtn(TObject *Sender) {
  EqiCoverSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiCoverSpr(TWTField *Sender) {
 EqiCoverGrid(Sender);
}
//--------------------------------------------------------------------
TWTWinDBGrid* TMainForm::EqiCoverGrid(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
//   TWinControl *Owner=NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_cover_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


   int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
   Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "��� ��������");
  Field->SetRequired("������������  ������ ���� ���������");

//  Field = WGrid->AddColumn("ro", "ro", "ro");
  Field = WGrid->AddColumn("ro", "r, ���*�", "�������� c������������ ��������");
  Field = WGrid->AddColumn("mu", "m", "��������� ������������� ��������");
//  Field->SetOnHelp(EqiMatSpr);
//  Field->SetRequired("������� ������ ���� ���������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
//  WGrid->DBGrid->OnAccept=WGrid->DBGrid->WinEditMenu;
  WGrid->ShowAs("eqk_cover_tbl");
  return WGrid;

};
#undef WinName
//-------------------------------------------------------------
#define WinName "��������"
void _fastcall TMainForm::EqiPhaseBtn(TObject *Sender) {
  EqiPhaseSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiPhaseSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_phase_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
    Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");


//  Field->SetOnHelp(EqiMatSpr);
//  Field->SetRequired("������� ������ ���� ���������");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_phase_tbl");

};
#undef WinName
#define WinName "���� �������"
void _fastcall TMainForm::EqiEnergyBtn(TObject *Sender) {
  EqiEnergySpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiEnergySpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_energy_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
    Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_energy_tbl");

};
#undef WinName
#define WinName "������ ����������"
void _fastcall TMainForm::EqiVoltageBtn(TObject *Sender) {
  EqiVoltageSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiVoltageSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_voltage_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������



    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
    Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("id", "�����", "����� ����������");
  Field->SetRequired("��� ������ ������ ���� ��������");
  Field = WGrid->AddColumn("voltage_min", "Umin, �", "���������� �����������");
  Field = WGrid->AddColumn("voltage_max", "Umax, �", "���������� ������������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_voltage_tbl");
};
#undef WinName
#define WinName "���� ��������"
//--------------------------------------------------------------------

void _fastcall TMainForm::EqiZoneBtn(TObject *Sender)
{
 EqiZoneSpr("���� ��������");
};
//==================
TWTWinDBGrid* TMainForm::EqiZoneSpr(AnsiString name) {
/*
  // ���������� ���������
  TWinControl *Owner = NULL;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_zone_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("id", "�����", "����� ����");
  Field->SetRequired("����� ������ ���� ��������");
  Field = WGrid->AddColumn("time_begin", "������", "����� ������ ����");
  Field = WGrid->AddColumn("time_end", "���������", "����� ��������� ����");

  WGrid->DBGrid->Visible = true;
//  WGrid->ShowAs("eqk_voltage_tbl");
  WGrid->ShowAs(name);
  return WGrid;
  */
};
#undef WinName

//------------------------------------------------------------
#define WinName "����� �����������"
void _fastcall TMainForm::EqiSchemainsBtn(TObject *Sender) {
  EqiSchemainsSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiSchemainsSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_schemains_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
   Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_schemains_tbl");

};
#undef WinName
#define WinName "������ ���������"
void _fastcall TMainForm::EqiHookupBtn(TObject *Sender) {
  EqiHookupSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiHookupSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_hookup_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
   Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_hookup_tbl");

};
#undef WinName
#define WinName "���� ������������"
void _fastcall TMainForm::EqiSyncBtn(TObject *Sender) {
  EqiSyncSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiSyncSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_sync_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
     Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_sync_tbl");

};
#undef WinName
#define WinName "������ ��������������� ������������"
void _fastcall TMainForm::EqiSwitchsGrBtn(TObject *Sender) {
  EqiSwitchsGrSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiSwitchsGrSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_switchs_gr_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������


    int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
   Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("shot_name", "��. ������������", "������� ������������");
  Field->SetRequired("������� ������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_switchs_gr_tbl");

};
#undef WinName
#define WinName "��� ���������"
void _fastcall TMainForm::EqiMeterBtn(TObject *Sender) {
  EqiMeterSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiMeterSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_meter_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
     int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Table->Open();


  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_meter_tbl");

};
#undef WinName
#define WinName "������� �����"
void _fastcall TMainForm::EqiKindCountBtn(TObject *Sender) {
  EqiKindCountSpr(NULL);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::EqiKindCountSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "eqk_kind_count_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("id", "���", "��� ����");
  Field->SetRequired("��� ������ ���� ��������");
  Field = WGrid->AddColumn("Name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("eqk_kind_count_tbl");

};
#undef WinName
//--------------------------------------------------------------------
#define WinName "���������� ��������"
void _fastcall TMainForm::EqiCordeBtn(TObject *Sender)
{
 EqiCordeSpr("������");
};
//==================
TWTWinDBGrid* TMainForm::EqiCordeSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,materal,calc_diam,cord_diam,cord_qn,S_nom,ro,xo,dpo,show_def " );
  QueryAdr->Sql->Add("  from eqi_corde_tbl order by type;");
  TWTWinDBGrid *WGrid = new TfEqpSpr(this, QueryAdr,false,true);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

  Query->AddLookupField("MATNAME", "materal", "eqk_materals_tbl", "name","id");

  int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;


  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  //NList->Add("id");

  Query->SetSQLModify("eqi_corde_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("S_nom", "S,��2", "����������� �������");
  Field = WGrid->AddColumn("MATNAME", "��������", "��������");
  Field->SetOnHelp(EqiMatSpr);
  Field = WGrid->AddColumn("ro", "Ro,��/��", "�������� ������������� �������");
  Field = WGrid->AddColumn("xo", "Xo,��/��", "���������� ������������� �������");
  Field = WGrid->AddColumn("dpo", "Po,���/��", "�������� ������ ��������");

  Field = WGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field = WGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field = WGrid->AddColumn("voltage_max", "U max, �", "������������ ���������� (���������)");
  Field = WGrid->AddColumn("amperage_max", "I max, �", "������������ ��� (���������)");

  Field = WGrid->AddColumn("cord_diam", "D,��", "������� ������");
  Field = WGrid->AddColumn("cord_qn", "��������", "���������� ��������");
  Field = WGrid->AddColumn("calc_diam", "D ����.,��", "������� ������� ���������");

 // Field = WGrid->AddColumn("normative", "����", "����, ��");
 // Field->SetWidth(100);
  Field = WGrid->AddColumn("show_def", "*", "����� ������������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("1");


  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WGrid->ShowAs("������");
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� ����"
void _fastcall TMainForm::EqiPillarBtn(TObject *Sender)
{
 EqiPillarSpr("�����");
};
//==================
TWTWinDBGrid* TMainForm::EqiPillarSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,materal,name" );
  QueryAdr->Sql->Add("  from eqi_pillar_tbl order by type;");

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

  Query->AddLookupField("MATNAME", "materal", "eqk_materals_tbl", "name","id");

       int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqi_pillar_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("normative", "����", "����, ��");
  Field = WGrid->AddColumn("MATNAME", "��������", "��������");
  Field->SetOnHelp(EqiMatSpr);
  Field = WGrid->AddColumn("name", "��������", "��������");

  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
 // WGrid->ShowAs("�����");
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� ����������"

void _fastcall TMainForm::EqiEarthBtn(TObject *Sender)
{
 EqiEarthSpr("����������");
};
//==================
TWTWinDBGrid* TMainForm::EqiEarthSpr(AnsiString name) {
  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,name" );
  QueryAdr->Sql->Add("  from eqi_earth_tbl order by type;");

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
       int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqi_earth_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("name", "��������", "��������");

  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WGrid->ShowAs("����������");
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� ���������� ��������"
void _fastcall TMainForm::EqiPendantBtn(TObject *Sender)
{
 EqiPendantSpr("��������");
};
//==================

TWTWinDBGrid* TMainForm::EqiPendantSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,length" );
  QueryAdr->Sql->Add("  from eqi_pendant_tbl order by type;");

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

       int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqi_pendant_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("normative", "����", "����, ��");
  Field = WGrid->AddColumn("length", "����������, ��", "����������, ��");

  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WGrid->ShowAs("��������");
    WGrid->ShowAs(name);
    return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� ��������������� ������������"
void _fastcall TMainForm::EqiSwitchBtn(TObject *Sender)
{
 EqiSwitchSpr("���������� ��������������� ������������");
};
//==================
TWTWinDBGrid* TMainForm::EqiSwitchSpr(AnsiString name) {
  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,id_gr,power_nom,lost_nom" );
  QueryAdr->Sql->Add("  from eqi_switch_tbl order by type;");
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

  Query->AddLookupField("GROUP", "id_gr", "eqk_switchs_gr_tbl", "name","id");

       int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
    return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  Query->SetSQLModify("eqi_switch_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("normative", "����", "����, ��");

  Field = WGrid->AddColumn("GROUP", "������", "������ ��������������� ������������");
  Field->SetOnHelp(EqiSwitchsGrSpr);

  Field = WGrid->AddColumn("power_nom", "���.��������, ���", "����������� ��������, ��� ����������� ����, ���");
  Field = WGrid->AddColumn("lost_nom", "������, ���", "������ ��� ����������� ������");

  Field = WGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field = WGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field = WGrid->AddColumn("voltage_max", "U max, �", "������������ ���������� (���������)");
  Field = WGrid->AddColumn("amperage_max", "I max, �", "������������ ��� (���������)");

  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WGrid->ShowAs("�������������");
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� ����� ���������������"
void _fastcall TMainForm::EqiFuseBtn(TObject *Sender)
{
 EqiFuseSpr("���������� ����� ���������������");
};
//==================
TWTWinDBGrid* TMainForm::EqiFuseSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,power_nom" );
  QueryAdr->Sql->Add("  from eqi_fuse_tbl order by type;");
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

       int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  Query->SetSQLModify("eqi_fuse_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("normative", "����", "����, ��");

  Field = WGrid->AddColumn("power_nom", "���.��������", "����������� ��������, ��� ����������� ����, ���");

  Field = WGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field = WGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field = WGrid->AddColumn("voltage_max", "U max, �", "������������ ���������� (���������)");
  Field = WGrid->AddColumn("amperage_max", "I max, �", "������������ ��� (���������)");

  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WGrid->ShowAs("��������������");
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� �������������"
void _fastcall TMainForm::EqiJackBtn(TObject *Sender)
{
 EqiJackSpr("���������� �������������");
};
//==================
TWTWinDBGrid* TMainForm::EqiJackSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,sync,power_nom,lost_nom" );
  QueryAdr->Sql->Add("  from eqi_jack_tbl order by type;");
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

  Query->AddLookupField("SYNCNAME", "sync", "eqk_sync_tbl", "name","id");

       int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  Query->SetSQLModify("eqi_jack_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("normative", "����", "����, ��");

  Field = WGrid->AddColumn("SYNCNAME", "������������", "����������/�����������");
  Field->SetOnHelp(EqiSyncSpr);

  Field = WGrid->AddColumn("power_nom", "���.��������,���", "����������� ��������, ��� ����������� ����");
  Field = WGrid->AddColumn("lost_nom", "������,���", "������ ��� ����������� ������");

  Field = WGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field = WGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field = WGrid->AddColumn("voltage_max", "U max, �", "������������ ���������� (���������)");
  Field = WGrid->AddColumn("amperage_max", "I max, �", "������������ ��� (���������)");

  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
 // WGrid->ShowAs("������������");

  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "���������� ����� ���"

void _fastcall TMainForm::EqiDESBtn(TObject *Sender)
{
 EqiDESSpr("���");
};
//==================
TWTWinDBGrid* TMainForm::EqiDESSpr(AnsiString name) {
  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type , normative " );
  QueryAdr->Sql->Add("  from eqi_des_tbl order by type;");

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
        int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqi_des_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("type", "���", "���");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("normative", "����", "����, ��");
  Field->SetWidth(100);

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//----------------------------------------------------------------
//#define WinName "������������"
void _fastcall TMainForm::ShowEqpList(int kind,AnsiString AddFilds[],AnsiString AddFildsName[],int FildsCount,AnsiString WinName, bool IsInsert) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this ;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  //------------------------------------------------------------------
  //   �������� ����� ������

  AnsiString name_table_ind="";
  AnsiString name_table="";

  TWTQuery *ZEqpQuery = new TWTQuery(this);
  ZEqpQuery->MacroCheck=true;
  Options.Clear();
  Options << doQuickOpen;
  ZEqpQuery->Options=Options;
  ZEqpQuery->RequestLive=false;
  ZEqpQuery->CachedUpdates=false;

   AnsiString sqlstr=" select syt1.name AS name_table, syt2.name AS name_table_ind,dk.calc_lost  \
 from (eqi_device_kinds_tbl AS dk LEFT OUTER JOIN syi_table_tbl AS syt1 ON (dk.id_table=syt1.id))\
 LEFT OUTER JOIN syi_table_tbl AS syt2 ON (dk.id_table_ind=syt2.id)\
 where (dk.id= :eqp_type);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("eqp_type")->AsInteger=kind;
   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZEqpQuery->Close();
    return;
   }
   int loss_power;
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
     name_table_ind=ZEqpQuery->FieldByName("name_table_ind")->AsString;
     name_table=ZEqpQuery->FieldByName("name_table")->AsString;
     loss_power=ZEqpQuery->FieldByName("calc_lost")->AsInteger;
   };
   ZEqpQuery->Close();
   delete ZEqpQuery;
   //----------------------------------------------------------------


  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp,eq.num_eqp,eq.dt_change as dt_install, eq.id_addres,eq.loss_power,tr.id_client, cl1.short_name as NAME_CL, coalesce(cl2.short_name,cl1.short_name) as NAME_USE, cl1.code as CODE_CL, coalesce(cl2.code,cl1.code) as CODE_USE, adr.adr::::varchar as NAME_ADR  ");
  if (name_table!="")
     {
       for (int k=0;k<=FildsCount-1;k++)
       {
        QueryAdr->Sql->Add(",eqd."+AddFilds[k]+" ");
       }
     }
  if (name_table_ind!="")
     {
        QueryAdr->Sql->Add(",eqk.type ");
     }

  if (kind==1)
     {
        QueryAdr->Sql->Add(",ph.name as meterphase,km.name as metkind,eqd.warm ");
     }


  QueryAdr->Sql->Add("from eqm_equipment_tbl AS eq left join eqm_eqp_use_tbl as use on (use.code_eqp=eq.id) ");
  QueryAdr->Sql->Add("left join clm_client_tbl as cl2 on (use.id_client=cl2.id) ");
  QueryAdr->Sql->Add("left join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp =eq.id ) ");
  QueryAdr->Sql->Add("left join eqm_tree_tbl as tr on (eqt.id_tree = tr.id) ");
  QueryAdr->Sql->Add("left join clm_client_tbl as cl1 on (cl1.id=tr.id_client) ");
  QueryAdr->Sql->Add("left join adv_address_tbl as adr on (adr.id=eq.id_addres) ");

  if (name_table!="")
     {
      QueryAdr->Sql->Add(" left join "+name_table+" AS eqd on (eqd.code_eqp=eq.id) " );
     }
  if (name_table_ind!="")
     {
      QueryAdr->Sql->Add(" left join "+name_table_ind+" AS eqk on (eqd.id_type_eqp=eqk.id) " );
     }
  if (kind==1)
     {
      QueryAdr->Sql->Add(" left join eqk_phase_tbl AS ph on (eqk.phase=ph.id) " );
      QueryAdr->Sql->Add(" left join eqk_meter_tbl AS km on (eqk.kind_meter=km.id) " );
     }

  QueryAdr->Sql->Add("where (eq.type_eqp = :type_eqp) and cl1.book = -1 ");

//  if (name_table!="")
//     {
//      QueryAdr->Sql->Add(" and (eqd.code_eqp=eq.id) " );
//     }
//  if (name_table_ind!="")
//     {
//      QueryAdr->Sql->Add(" and (eqd.id_type_eqp=eqk.id) " );
//     }

  if (kind==1)
     {
//      QueryAdr->Sql->Add(" and (eqk.phase=ph.id) " );

      FildsCount=3;
      AddFilds[0]="meterphase";
      AddFildsName[0]="��������";

      AddFilds[1]="metkind";
      AddFildsName[1]="���";

      AddFilds[2]="warm";
      AddFildsName[2]="�������.";

     }

  if (loss_power ==1)
  {
      AddFilds[FildsCount]="loss_power";
      AddFildsName[FildsCount]="������� ������";
      FildsCount++;
  }

  QueryAdr->Sql->Add(" order by eq.name_eqp;");
  QueryAdr->ParamByName("type_eqp")->AsInteger=kind;


  TfEqpList *WEqpGrid = new TfEqpList(this, QueryAdr,false,
        kind,AddFilds,AddFildsName,FildsCount,WinName, IsInsert);
  WEqpGrid->SetCaption(WinName);
//  WEqpGrid->name_table_ind=name_table_ind;
        int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WEqpGrid->DBGrid->ReadOnly=true;
  WEqpGrid->ShowAs("������������");

};
#undef WinName
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmMeterBtn(TObject *Sender) {

 AnsiString fields[]={"","",""};
 AnsiString fieldnames[]={"","",""};
 ShowEqpList(1,fields,fieldnames,0,"��������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmCompBtn(TObject *Sender) {

 AnsiString fields[]={""};
 AnsiString fieldnames[]={""};
 ShowEqpList(2,fields,fieldnames,0,"��������������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmSwitchBtn(TObject *Sender) {

 AnsiString fields[]={"amperage_nom"};
 AnsiString fieldnames[]={"���.���,�"};
 ShowEqpList(3,fields,fieldnames,1,"�������������� ������������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmJackBtn(TObject *Sender) {

 AnsiString fields[]={"quantity"};
 AnsiString fieldnames[]={"����������"};
 ShowEqpList(4,fields,fieldnames,1,"������������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmFuseBtn(TObject *Sender) {

 AnsiString fields[]={""};
 AnsiString fieldnames[]={""};
 ShowEqpList(5,fields,fieldnames,0,"��������������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmLineCBtn(TObject *Sender) {

 AnsiString fields[]={"length",""};
 AnsiString fieldnames[]={"�������������",""};
 ShowEqpList(6,fields,fieldnames,1,"����� ���������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmLineABtn(TObject *Sender) {

 AnsiString fields[]={"length",""};
 AnsiString fieldnames[]={"�������������",""};
 ShowEqpList(7,fields,fieldnames,1,"����� ���������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmCompIBtn(TObject *Sender) {

 AnsiString fields[]={""};
 AnsiString fieldnames[]={""};
 ShowEqpList(10,fields,fieldnames,0,"�������������� �������������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmDESBtn(TObject *Sender) {

 AnsiString fields[]={"power"};
 AnsiString fieldnames[]={"��������"};
 ShowEqpList(16,fields,fieldnames,1,"��������� ��������������");
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmPointBtn(TObject *Sender) {

 AnsiString fields[]={""};
 AnsiString fieldnames[]={""};
 ShowEqpList(12,fields,fieldnames,0,"����� �����");
}
//---------------------------------------------------------------------------

void _fastcall TMainForm::EqmCompStBtn(TObject *Sender) {

// AnsiString fields[]={"h_boxes","l_boxes","h_points","l_points"};
// AnsiString fieldnames[]={"�-�� ����� ������� �������","�-�� ����� ������ �������","�-�� ����������� ������� �������","�-�� ����������� ������ �������"};
// ShowEqpList(8,fields,fieldnames,4,"���������������� ����������",true);
 ShowAreasList(0,8,"���������������� ����������",false);
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmLandingBtn(TObject *Sender) {

// AnsiString fields[]={""};
// AnsiString fieldnames[]={""};
// ShowEqpList(11,fields,fieldnames,0,"��������",true);
 ShowAreasList(0,11,"��������",false);
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::EqmConnectBtn(TObject *Sender) {

// AnsiString fields[]={""};
// AnsiString fieldnames[]={""};
// ShowEqpList(14,fields,fieldnames,0,"����� �����",true);
 ShowAreasList(0,14,"����� �����",false);
}
//---------------------------------------------------------------------------
#define WinName "���������� ���������������"
void _fastcall TMainForm::EqiCompBtn(TObject *Sender)
{
 EqiCompSpr("���������� ���������������");
};
//==================
TWTWinDBGrid* TMainForm::EqiCompSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage2_nom,amperage2_nom,voltage_max,amperage_max,phase,swathe,power_nom,hook_up,amperage_no_load,show_def " );
  QueryAdr->Sql->Add("from eqi_compensator_tbl order by type;");
//  WCompGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WCompGrid = new TfEqpSpr(this, QueryAdr,false,true);
  WCompGrid->SetCaption(WinName);

  TWTQuery* Query = WCompGrid->DBGrid->Query;

  Query->AddLookupField("PHASENAME", "phase", "eqk_phase_tbl", "name","id");
         int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WCompGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");
  NList->Add("type");
  NList->Add("normative");
  NList->Add("voltage_nom");
  NList->Add("amperage_nom");
  NList->Add("voltage2_nom");
  NList->Add("amperage2_nom");
  NList->Add("voltage_max");
  NList->Add("amperage_max");
  NList->Add("phase");
  NList->Add("swathe");
  NList->Add("power_nom");
  NList->Add("hook_up");
  NList->Add("amperage_no_load");

  Query->SetSQLModify("eqi_compensator_tbl",WList,NList,true,false,true);
  TWTField *Field;

  Field = WCompGrid->AddColumn("type", "���", "���");
  Field->SetReadOnly();
//  Field = WCompGrid->AddColumn("normative", "����", "����, ��");
//  Field->SetReadOnly();

  Field = WCompGrid->AddColumn("PHASENAME", "��������", "����������/����������");
  Field->SetReadOnly();
//  Field->SetOnHelp(EqiMatSpr);

  Field = WCompGrid->AddColumn("swathe", "�������", "���������� �������");
  Field->SetReadOnly();
  Field = WCompGrid->AddColumn("power_nom", "�n, ���", "����������� ��������");
  Field->SetReadOnly();

  Field = WCompGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field->SetReadOnly();
  Field = WCompGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field->SetReadOnly();

  Field = WCompGrid->AddColumn("show_def", "*", "����� ������������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("1");

//  WCompGrid->DBGrid->ToolBar->AddButton("InsForm", "������ ������", CmiBankSprA);

  WCompGrid->DBGrid->BeforeInsert=NewCompGr;
  WCompGrid->DBGrid->OnAccept=CompAccept;
//  WCompGrid->DBGrid->ReadOnly=true;
  WCompGrid->DBGrid->Visible = true;
  WCompGrid->DBGrid->Options>>dgEditing;
//  WCompGrid->KeyPreview=true;
//  WCompGrid->OnKeyDown=CompKeyDown;

  TWTToolBar* tb=WCompGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=CompAccept;
    if ( btn->ID=="NewRecord")
       tb->Buttons[i]->OnClick=NewComp;
   }

//  WCompGrid->ShowAs("��������������");
  WCompGrid->ShowAs(name);
  WCompGrid->OnCloseQuery=CompGridClose;
  return WCompGrid;
};
#undef WinName
//--------------------------------------------------------------------
void __fastcall TMainForm::CompAccept (TObject* Sender)
{
 TfCompSpr *CompSpr;

 Application->CreateForm(__classid(TfCompSpr), &CompSpr);
 CompSpr->ParentDataSet=WCompGrid->DBGrid->Query;
// CompSpr->id=WCompGrid->DBGrid->Query->FieldByName("id")->AsInteger;
 CompSpr->mode=1;
 CompSpr->ShowAs("CompSpr");
 CompSpr->ShowData(WCompGrid->DBGrid->Query->FieldByName("id")->AsInteger);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::NewCompGr(TWTDBGrid *Sender) {

  NewComp(Sender);
  WCompGrid->DBGrid->Query->Refresh();
};
//--------------------------------------------------------------------
void __fastcall TMainForm::NewComp(TObject* Sender)
{
 TfCompSpr *CompSpr;

 Application->CreateForm(__classid(TfCompSpr), &CompSpr);
 CompSpr->ParentDataSet=WCompGrid->DBGrid->Query;
// CompSpr->id=WCompGrid->DBGrid->Query->FieldByName("id")->AsInteger;
 CompSpr->mode=0;
 CompSpr->ShowAs("CompNewSpr");
 CompSpr->ShowData(0);
}
//--------------------------------------------------------------------
void __fastcall TMainForm::CompKeyDown(TObject* Sender, Word &Key, TShiftState Shift)
{
// if (Key==VK_INSERT) ShowMessage("///");
}
//--------------------------------------------------------------------
#define WinName "���������� �������"
void _fastcall TMainForm::EqiCableBtn(TObject *Sender)
{
 EqiCableSpr("���������� �������");
};
//==================
TWTWinDBGrid* TMainForm::EqiCableSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select ca.id,ca.type,ca.normative,ca.voltage_nom,ca.amperage_nom,ca.voltage_max,ca.amperage_max,ca.cords,ca.cover,cv.name as covername,ca.S_nom,ca.ro,ca.dpo,ca.show_def " );
  QueryAdr->Sql->Add("from eqi_cable_tbl as ca LEFT JOIN eqk_cover_tbl as cv ON (ca.cover = cv.id) order by type;");
  WCableGrid = new TfEqpSpr(this, QueryAdr,false,true);
  WCableGrid->SetCaption(WinName);

  TWTQuery* Query = WCableGrid->DBGrid->Query;
  int ChLevel =CheckLevelRead("���������� ������������");
   if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WCableGrid->DBGrid->ReadOnly=true;

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
  NList->Add("cords");
  NList->Add("cover");
  NList->Add("covername");
  NList->Add("s_nom");
  NList->Add("ro");
  NList->Add("dpo");

  Query->SetSQLModify("eqi_cable_tbl",WList,NList,true,false,true);
  TWTField *Field;

  Field = WCableGrid->AddColumn("type", "���", "���");
  Field->SetReadOnly();
//  Field = WCableGrid->AddColumn("normative", "����", "����, ��");
//  Field->SetReadOnly();
//  Field = WCableGrid->AddColumn("cords", "���", "���������� ���");
//  Field->SetReadOnly();
  Field = WCableGrid->AddColumn("S_nom", "S,��2", "����������� �������");
  Field->SetReadOnly();

//  Field = WCableGrid->AddColumn("cover", "��������", "��� ��������");

  Field = WCableGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field->SetReadOnly();
  Field = WCableGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field->SetReadOnly();

  Field = WCableGrid->AddColumn("show_def", "*", "����� ������������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("1");

  WCableGrid->DBGrid->OnAccept=CableAccept;
  WCableGrid->DBGrid->BeforeInsert=NewCableGr;
//  WCableGrid->DBGrid->ReadOnly=true;
  WCableGrid->DBGrid->Visible = true;
  WCableGrid->DBGrid->Options>>dgEditing;
//  WCableGrid->KeyPreview=true;
//  WCableGrid->OnKeyDown=CompKeyDown;

  TWTToolBar* tb=WCableGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=CableAccept;
    if ( btn->ID=="NewRecord")
       tb->Buttons[i]->OnClick=NewCable;
   }

  //WCableGrid->ShowAs("������");
  WCableGrid->ShowAs(name);
  WCableGrid->OnCloseQuery=CableGridClose;
  return WCableGrid;
};
#undef WinName
//--------------------------------------------------------------------
void __fastcall TMainForm::CableAccept (TObject* Sender)
{

  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������", Owner)) {
    return;
  }
  WCableEdit=new TfCableSpr(this,"");
  WCableEdit->ShowAs(WCableGrid->DBGrid->Query->FieldByName("Type")->AsString);
  WCableEdit->SetCaption("������ "+WCableGrid->DBGrid->Query->FieldByName("Type")->AsString);
  WCableEdit->mode=1;
  WCableEdit->ID="������";
  WCableEdit->ParentDataSet=WCableGrid->DBGrid->Query;
  WCableEdit->ShowData(WCableGrid->DBGrid->Query->FieldByName("id")->AsInteger);

 }
//--------------------------------------------------------------------
void __fastcall TMainForm::NewCable(TObject* Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������", Owner)) {
    return;
  }
  WCableEdit=new TfCableSpr(this,"");
  WCableEdit->ShowAs("����� ������");
  WCableEdit->SetCaption("����� ������");
  WCableEdit->mode=0;
  WCableEdit->ID="������";
  WCableEdit->ParentDataSet=WCableGrid->DBGrid->Query;
  WCableEdit->ShowData(0);
}
//--------------------------------------------------------------------
void _fastcall TMainForm::NewCableGr(TWTDBGrid *Sender) {

  NewCable(Sender);
  WCableGrid->DBGrid->Query->Refresh();
};
//---------------------------------------------------------------------------
#define WinName "���������� ���������"
void _fastcall TMainForm::EqiAMeterBtn(TObject *Sender)
{
// TWTWinDBGrid* Grid;
 EqiAMeterSpr("���������� ���������");
// if(Grid==NULL) return;
// else WMeterGrid=Grid;
 };
//==================
TWTWinDBGrid* TMainForm::EqiAMeterSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max, " );
  QueryAdr->Sql->Add("kind_meter,kind_count,phase,carry,schema_inst,hook_up,amperage_nom_s,voltage_nom_s,");
  QueryAdr->Sql->Add("zones,zone_time_min,term_control,buffle,show_def ");
  QueryAdr->Sql->Add("from eqi_meter_tbl order by type;");
  WMeterGrid = new TfEqpSpr(this, QueryAdr,false,true);
  WMeterGrid->SetCaption(WinName);

     int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
      WMeterGrid->DBGrid->ReadOnly=true;

  TWTQuery* Query = WMeterGrid->DBGrid->Query;
  Query->AddLookupField("PHASENAME", "phase", "eqk_phase_tbl", "name","id");
  Query->AddLookupField("KINDMETER", "kind_meter", "eqk_meter_tbl", "name","id");



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


    if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    {WMeterGrid->DBGrid->ReadOnly=true;
       Query->SetSQLModify("eqi_meter_tbl",WList,NList,false,false,false);}
       
   else
   Query->SetSQLModify("eqi_meter_tbl",WList,NList,true,false,true);

  TWTField *Field;

  Field = WMeterGrid->AddColumn("type", "���", "���");
  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("carry", "�����������", "�����������");
  Field->SetReadOnly();

  //  Field = WMeterGrid->AddColumn("normative", "����", "����, ��");
//  Field->SetReadOnly();

//  Field = WMeterGrid->AddColumn("KINDMETER", "���", "������������/�����������");
//  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("PHASENAME", "��������", "����������/����������");
  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("zones", "����", "������������ ���������� ���");
  Field->SetReadOnly();
//  Field = WMeterGrid->AddColumn("carry", "�����������", "�����������");
//  Field->SetReadOnly();

  Field = WMeterGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field->SetReadOnly();
  Field = WMeterGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field->SetReadOnly();

  Field = WMeterGrid->AddColumn("show_def", "*", "����� ������������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("1");

  Field = WMeterGrid->AddColumn("id", "Id", "Id");
  Field->SetReadOnly();


  WMeterGrid->DBGrid->OnAccept=MeterAccept;
  WMeterGrid->DBGrid->BeforeInsert=NewMeterGr;
//  WMeterGrid->DBGrid->ReadOnly=true;
  WMeterGrid->DBGrid->Visible = true;
 // WMeterGrid->DBGrid->Options>>dgEditing;
//  WMeterGrid->KeyPreview=true;
//  WMeterGrid->OnKeyDown=CompKeyDown;

  TWTToolBar* tb=WMeterGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=MeterAccept;
    if ( btn->ID=="NewRecord")
       tb->Buttons[i]->OnClick=NewMeter;
   }
  WMeterGrid->ShowAs(name);
  WMeterGrid->OnCloseQuery=MeterGridClose;
  return WMeterGrid;
};
#undef WinName
//--------------------------------------------------------------------
void __fastcall TMainForm::MeterAccept (TObject* Sender)
{
  TWinControl *Owner = NULL;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("�������", Owner)) {
    return;
  }
  WMeterEdit=new TfMeterSpr(this,"");
  WMeterEdit->ShowAs(WMeterGrid->DBGrid->Query->FieldByName("Type")->AsString);
  WMeterEdit->SetCaption("������� "+WMeterGrid->DBGrid->Query->FieldByName("Type")->AsString);
  WMeterEdit->mode=1;
  WMeterEdit->ID="�������";
  WMeterEdit->ParentDataSet=WMeterGrid->DBGrid->Query;
  WMeterEdit->ShowData(WMeterGrid->DBGrid->Query->FieldByName("id")->AsInteger);
}
//--------------------------------------------------------------------
void __fastcall TMainForm::NewMeter(TObject* Sender)
{
  TWinControl *Owner = NULL;

  // ���� ����� ���� ���� - ������������ � �������
  // ����� ��������� ������ ���� ���� ������
  if (ShowMDIChild("�������", Owner)) {
    return;
  }

  WMeterEdit=new TfMeterSpr(this,"");
  WMeterEdit->ShowAs("����� �������");
  WMeterEdit->SetCaption("����� �������");
  WMeterEdit->mode=0;
  WMeterEdit->ID="�������";
  WMeterEdit->ParentDataSet=WMeterGrid->DBGrid->Query;
  WMeterEdit->ShowData(0);
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::NewMeterGr(TWTDBGrid *Sender) {

  NewMeter(Sender);
  WMeterGrid->DBGrid->Query->Refresh();
};
//--------------------------------------------------------------------
void __fastcall TMainForm::MeterGridClose(TObject *Sender, bool &CanClose)
{
 WMeterGrid=NULL;
}
//--------------------------------------------------------------------
void __fastcall TMainForm::CableGridClose(TObject *Sender, bool &CanClose)
{
 WCableGrid=NULL;
}
//--------------------------------------------------------------------
void __fastcall TMainForm::CompGridClose(TObject *Sender, bool &CanClose)
{
 WCompGrid=NULL;
}
//--------------------------------------------------------------------
#define WinName "���������� ��������������� �������������"
void _fastcall TMainForm::EqiCompIBtn(TObject *Sender)
{
 EqiCompISpr("���������� ��������������� �������������");
};
//==================
TWTWinDBGrid* TMainForm::EqiCompISpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,phase,swathe,power_nom,hook_up,amperage_no_load,conversion,voltage2_nom,amperage2_nom,accuracy " );
  QueryAdr->Sql->Add("from eqi_compensator_i_tbl order by type;");
  WCompIGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WCompIGrid->SetCaption(WinName);

  TWTQuery* Query = WCompIGrid->DBGrid->Query;

  Query->AddLookupField("PHASENAME", "phase", "eqk_phase_tbl", "name","id");
  Query->AddLookupField("CONVNAME", "conversion", "eqk_conversion_tbl", "name","id");

  int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WCompIGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  Query->SetSQLModify("eqi_compensator_i_tbl",WList,NList,false,false,true);
  TWTField *Field;

  Field = WCompIGrid->AddColumn("type", "���", "���");
  Field->SetReadOnly();
 // Field = WCompIGrid->AddColumn("normative", "����", "����, ��");
//  Field->SetReadOnly();
  Field = WCompIGrid->AddColumn("CONVNAME", "I/U", "���/����������");
  Field->SetReadOnly();
  Field = WCompIGrid->AddColumn("PHASENAME", "��������", "����������/����������");
  Field->SetReadOnly();
//  Field->SetOnHelp(EqiMatSpr);

  Field = WCompIGrid->AddColumn("swathe", "�������", "���������� �������");
  Field->SetReadOnly();
  Field = WCompIGrid->AddColumn("power_nom", "�n,���", "����������� ��������");
  Field->SetReadOnly();

  Field = WCompIGrid->AddColumn("voltage_nom", "Un, �", "����������� ���������� (���������)");
  Field->SetReadOnly();
  Field = WCompIGrid->AddColumn("amperage_nom", "In, �", "����������� ��� (���������)");
  Field->SetReadOnly();

  WCompIGrid->DBGrid->OnAccept=CompIAccept;
  WCompIGrid->DBGrid->BeforeInsert=NewCompIGr;
//  WCompGrid->DBGrid->ReadOnly=true;
  WCompIGrid->DBGrid->Visible = true;
  WCompIGrid->DBGrid->Options>>dgEditing;
//  WCompGrid->KeyPreview=true;
//  WCompGrid->OnKeyDown=CompKeyDown;

  TWTToolBar* tb=WCompIGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=CompIAccept;
    if ( btn->ID=="NewRecord")
       tb->Buttons[i]->OnClick=NewCompI;

   }

  WCompIGrid->ShowAs(name);
  WCompIGrid->OnCloseQuery=CompIGridClose;
  return WCompIGrid;
};
#undef WinName
//--------------------------------------------------------------------
void __fastcall TMainForm::CompIAccept (TObject* Sender)
{
 TfCompISpr *CompISpr;

 Application->CreateForm(__classid(TfCompISpr), &CompISpr);
 CompISpr->ParentDataSet=WCompIGrid->DBGrid->Query;
// CompSpr->id=WCompGrid->DBGrid->Query->FieldByName("id")->AsInteger;
 CompISpr->mode=1;
 CompISpr->ShowAs("CompISpr");
 CompISpr->ShowData(WCompIGrid->DBGrid->Query->FieldByName("id")->AsInteger);
}
//--------------------------------------------------------------------
void __fastcall TMainForm::NewCompI(TObject* Sender)
{
 TfCompISpr *CompISpr;

 Application->CreateForm(__classid(TfCompISpr), &CompISpr);
 CompISpr->ParentDataSet=WCompIGrid->DBGrid->Query;
// CompSpr->id=WCompGrid->DBGrid->Query->FieldByName("id")->AsInteger;
 CompISpr->mode=0;
 CompISpr->ShowAs("CompINewSpr");
 CompISpr->ShowData(0);
}
//---------------------------------------------------------------------------
void _fastcall TMainForm::NewCompIGr(TWTDBGrid *Sender) {

  NewCompI(Sender);
  WCompIGrid->DBGrid->Query->Refresh();
};

//--------------------------------------------------------------------
void __fastcall TMainForm::CompIGridClose(TObject *Sender, bool &CanClose)
{
 WCompIGrid=NULL;
}
//--------------------------------------------------------------------
#define WinName "���������� ������� ��"
void _fastcall TMainForm::EqkTgBtn(TObject *Sender)
{
 EqkTgSpr(" ");
};
//==================
TWTWinDBGrid* TMainForm::EqkTgSpr(AnsiString name) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(name, Owner)) {
    return NULL;
  }
  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,name,value,value_r " );
  QueryAdr->Sql->Add("from eqk_tg_tbl order by name;");

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
  int ChLevel =CheckLevelRead("���������� ������������");
    if  (ChLevel==0) {
     return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqk_tg_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WGrid->AddColumn("name", "������������", "������������");
  Field->SetRequired("������������  ������ ���� ���������");
  Field = WGrid->AddColumn("value", "��������", "��������");
  Field->SetRequired("��������  ������ ���� ���������");
  Field = WGrid->AddColumn("value_r", "���. �����", "��������");
  Field->SetRequired("��������  ������ ���� ���������");


  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
 // WGrid->ShowAs("�����");
  WGrid->ShowAs(name);
  return WGrid;
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "������ ���� �����������"
//void _fastcall TMainForm::EqmTreesBtn(TObject *Sender) {
/*
  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  // ���� ����� ������� ��� �������� ������� � �� ���� �������������

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select tr.id,tr.name,tr.code_eqp,tr.tranzit,tr.id_client AS client,eq.name_eqp" );
  QueryAdr->Sql->Add("  from eqm_tree_tbl AS tr, eqm_equipment_tbl AS eq " );
  QueryAdr->Sql->Add("  where (eq.id=tr.code_eqp) order by client;");
  WTreeGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WTreeGrid->SetCaption(WinName);

  TWTQuery* Query = WTreeGrid->DBGrid->Query;
//  Query->AddLookupField("GROUP", "id_gr", "eqk_switchs_gr_tbl", "name","id");

  Query->Open();
  TWTField *Field;

  Field = WTreeGrid->AddColumn("client", "�������", "�������");
  Field = WTreeGrid->AddColumn("name", "�����", "������������ �����");
  Field = WTreeGrid->AddColumn("name_eqp", "������", "�������� ������������");

  WTreeGrid->DBGrid->OnAccept=ShowEqpTree;
  WTreeGrid->DBGrid->Visible = true;
  WTreeGrid->DBGrid->ReadOnly=true;

  TWTToolBar* tb=WTreeGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=ShowEqpTree;
    if ( btn->ID=="NewRecord")
       tb->Buttons[i]->OnClick=NULL;
    if ( btn->ID=="DelRecord")
       tb->Buttons[i]->OnClick=NULL;
   }

  WTreeGrid->ShowAs("�����");
  */
//};
#undef WinName
//-----------------------------------------------------------------------
//������� ��� ���������� ��������� ������� ����� ������� ������������
int _fastcall TMainForm::PrepareChange(TZPgSqlQuery* Query,int mode, int treeid,int eqpid,int usrid,bool enabled,TDateTime ChangeDate)
{
    TDateTime ChDate;

//    if(!enabled) return 0;  //������ ��� ������
   if(enabled)
   {
    if (int(ChangeDate)==0)
    {
    TfChangeDate* fChangeDate;
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
    if (fChangeDate->ShowModal()!= mrOk)
     {
      delete fChangeDate;
      return -1; // �������� ������
     };

     try
     {
      ChDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      return -1;
     }

     delete fChangeDate;
    }
    else ChDate=ChangeDate;
   }
   else ChDate=Now();

    AnsiString sqlstr="select eqt_change_fun( :mode, :tree, :dt, :usr, :eqp, :enable);";
    Query->Sql->Clear();
    Query->Sql->Add(sqlstr);
    Query->ParamByName("mode")->AsInteger=mode;
    if (treeid!=0)
      Query->ParamByName("tree")->AsInteger=treeid;
    if (eqpid!=0)
      Query->ParamByName("eqp")->AsInteger=eqpid;
    Query->ParamByName("usr")->AsInteger=usrid;
    Query->ParamByName("dt")->AsDateTime=ChDate;
    Query->ParamByName("enable")->AsInteger=(enabled?1:0);

    try
    {
     Query->Open();
    }
    catch(...)
    {
     ShowMessage("������ SQL :"+sqlstr);
     Query->Close();
     Query->Transaction->Rollback();                 //<<<<
     return -1;
    }

    int id = Query->Fields->Fields[0]->AsInteger;
    Query->Close();
    Query->Transaction->Commit();                 //<<<<
    return id;
}

//-----------------------------------------------------------------------
//������� ��� ������� ��������� �������
void _fastcall TMainForm::AfterChange(TZPgSqlQuery* Query,int operation,bool enabled)
{
//    if(!enabled) return;  //������ ��� ������

    AnsiString sqlstr="Delete from eqt_change_tbl where  id_operation = :operation;";
    Query->Sql->Clear();
    Query->Sql->Add(sqlstr);
    Query->ParamByName("operation")->AsInteger=operation;

    try
    {
     Query->ExecSql();
    }
    catch(...)
    {
     ShowMessage("������ SQL :"+sqlstr);
     Query->Transaction->Rollback();                 //<<<<
    }
    Query->Close();
}
//-----------------------------------------------------------------------
void _fastcall TMainForm::ShowAreasList(int client, int kind,AnsiString WinName, bool IsInsert) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this ;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options<< doQuickOpen;

  //------------------------------------------------------------------

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp,eq.num_eqp,eq.dt_install, eq.id_addres ,eqa.id_client, a.adr::::varchar, u.eqp_cnt ");

  if(kind==11)
    QueryAdr->Sql->Add(", g.power, g.wtm ");

  if(kind==15)
    QueryAdr->Sql->Add(", vv.voltage_min ");

  if(kind==8)
    QueryAdr->Sql->Add(", s.power, s.comp_cnt, s.p_regday,s.date_regday ");


  QueryAdr->Sql->Add("from eqm_equipment_tbl AS eq join  eqm_area_tbl as eqa on (eqa.code_eqp=eq.id) ");
  QueryAdr->Sql->Add("left join adv_address_tbl as a on (eq.id_addres=a.id) ");

  if(kind==11)
    QueryAdr->Sql->Add("join eqm_ground_tbl as g on (eq.id=g.code_eqp) ");

  if(kind==15)
  {
    QueryAdr->Sql->Add("join eqm_fider_tbl as f on (eq.id=f.code_eqp) ");
    QueryAdr->Sql->Add("join eqk_voltage_tbl as vv on (vv.id=f.id_voltage) ");
  }

  if(kind==8)
    QueryAdr->Sql->Add("join eqm_compens_station_tbl as s on (eq.id=s.code_eqp) ");

    QueryAdr->Sql->Add("left join ( select code_eqp_inst, count(*)::::integer as eqp_cnt from eqm_compens_station_inst_tbl group by code_eqp_inst order by code_eqp_inst) as u on (eq.id=u.code_eqp_inst) ");

  QueryAdr->Sql->Add("where (eq.type_eqp = :type_eqp) ");

  if (client!=0)
   QueryAdr->Sql->Add(" and (eqa.id_client = :client) ");

  QueryAdr->Sql->Add(" order by eq.name_eqp;");

  QueryAdr->ParamByName("type_eqp")->AsInteger=kind;
  if (client!=0)
   QueryAdr->ParamByName("client")->AsInteger=client;

  TfAreaList *WEqpGrid = new TfAreaList(this, QueryAdr,false,
        kind,client,WinName, IsInsert);
  WEqpGrid->SetCaption(WinName);
//  WEqpGrid->name_table_ind=name_table_ind;
  WEqpGrid->ShowAs("WinName");

};
#undef WinName

//--------------------------------------------------------------------
#define WinName "����������� ���. ���������"
TWTWinDBGrid*  TMainForm::EqmAbonConnect(int CodeEqp)
{
  // ���������� ���������
  TWTQuery *QueryAdr;


  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options.Clear();
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select * from ( select cl.id ,cl.name,cl.code,cl.book,cl.ccode,cl.cbook,cl.id_state,cl.dom_gek, cl.address,(t.name||' ���.'||st.name||' '||coalesce(cl.build,'')||' '||coalesce(cl.office,''))::::varchar as adr, cl.id_eqpborder,CASE WHEN cl.id_eqpborder is NULL THEN 0 ELSE 1 END as connected,CASE WHEN cl.id_eqpborder is NULL THEN 0 ELSE 1 END as oldconnected " );
  QueryAdr->Sql->Add("from clm_pclient_tbl as cl " );
  QueryAdr->Sql->Add("left join adi_street_tbl as st on (st.id=cl.id_street) " );
  QueryAdr->Sql->Add("left join adi_town_tbl as t on (st.id_town=t.id) " );
  QueryAdr->Sql->Add("where ( id_eqpborder = :eqp or id_eqpborder is NULL ) and coalesce(cl.id_state,0)<>50 order by  cl.book, cl.code ) as s " );
/*
  QueryAdr->Sql->Add(" select cl.id ,cl.name,cl.code,cl.book, t.name||' ���.'||st.name||' '||coalesce(cl.build,'')||' '||coalesce(cl.office,'') as adr, cl.id_eqpborder,CASE WHEN cl.id_eqpborder is NULL THEN 0 ELSE 1 END as connected,CASE WHEN cl.id_eqpborder is NULL THEN 0 ELSE 1 END as oldconnected " );
  QueryAdr->Sql->Add("from clm_pclient_tbl as cl " );
  QueryAdr->Sql->Add("left join adi_street_tbl as st on (st.id=cl.id_street) " );
  QueryAdr->Sql->Add("left join adi_town_tbl as t on (st.id_town=t.id) " );
  QueryAdr->Sql->Add("where id_eqpborder = :eqp or id_eqpborder is NULL order by  cl.book, cl.code " );
*/



 //QueryAdr->Sql->Add("where id_eqmborder = :eqp or id_eqmborder is NULL order by connected desc, cl.book, cl.code, cl.name; " );

  QueryAdr->ParamByName("eqp")->AsInteger=CodeEqp;

  TWTWinDBGrid *WGrid = new TfAbonConnect(this, QueryAdr,false,CodeEqp,true);
  WGrid->SetCaption(WinName);
  WGrid->DBGrid->Query->AddLookupField("name_dom_gek", "dom_gek", "adi_build_tbl", "name","id");
  TWTQuery* Query = WGrid->DBGrid->Query;

//  Query->Options << doQuickOpen;
 int ChLevel =CheckLevelRead("����� ����������� ���.���");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id_client");
  NList->Add("id_eqpborder");
  NList->Add("connected");
  NList->Add("oldconnected");
  NList->Add("id_state");
  NList->Add("book");
  NList->Add("code");
  NList->Add("cbook");
  NList->Add("ccode");
  NList->Add("adr");

  Query->SetSQLModify("clm_pclient_tbl",WList,NList,true,false,false);
  TWTField *Field;

  Field = WGrid->AddColumn("connected", "*", "���������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("0");

  Field = WGrid->AddColumn("book", "�����", "�����");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("code", "����", "������� ����");
  Field->SetReadOnly();

  Field = WGrid->AddColumn("cbook", "����� ����", "�����");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("ccode", "���� ����", "������� ����");
  Field->SetReadOnly();

  Field = WGrid->AddColumn("name", "�������", "�������");
  Field->SetWidth(200);
  Field = WGrid->AddColumn("adr", "�����", "�����");
  Field->SetWidth(100);
  Field->SetReadOnly();
  Field = WGrid->AddColumn("address", "����� �������", "����� �������");
  Field->SetWidth(250);
  Field->SetReadOnly();
  Field = WGrid->AddColumn("name_dom_gek", "���  ����", "���  ����");
  Field->SetWidth(100);
  Field->SetReadOnly();
  Field = WGrid->AddColumn("id_state", "������", "������");
  Field->SetReadOnly();  
  Field->AddFixedVariable(50, "�����");
  Field->AddFixedVariable(0," ");


  Query->IndexFieldNames="book;code";
  WGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WGrid->ShowAs("������");

  //WGrid->OnClose=&(TfAbonConnect::GridClose);
  WGrid->ShowAs(WinName);
  return WGrid;
};
#undef WinName


//--------------------------------------------------------------------
#define WinName "����������� �������������� �����������  �����"
TWTWinDBGrid*  TMainForm::EqmGekConnect(int CodeEqp)
{
  TWTQuery *QueryAdr;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options.Clear();
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select a.*, \
   CASE WHEN a.code_eqp is NULL THEN 0 ELSE 1 END as connected, \
   CASE WHEN a.code_eqp is NULL THEN 0 ELSE 1 END as oldconnected  \
    from adi_build_tbl as a  \
    where code_eqp = :eqp or code_eqp is NULL order by  a.num_gek  " );
  QueryAdr->ParamByName("eqp")->AsInteger=CodeEqp;

  TWTWinDBGrid *WGrid = new TfGekConnect(this, QueryAdr,false,CodeEqp,true);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;
//  Query->Options << doQuickOpen;
int ChLevel =CheckLevelRead("����� ����������� �����");
  if  (ChLevel==0) {
      return NULL;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("code_eqp");
  NList->Add("connected");
  NList->Add("oldconnected");

  Query->SetSQLModify("adi_build_tbl",WList,NList,true,false,false);
  TWTField *Field;

  Field = WGrid->AddColumn("connected", "*", "���������");
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("0");
    Field = WGrid->AddColumn("num_gek", "����� ���", "����� ���");
      Field->SetReadOnly();
  Field = WGrid->AddColumn("Name", "����� ����", "����� ����");
    Field->SetReadOnly();
    Query->IndexFieldNames="num_gek,name";
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
  return WGrid;
};
#undef WinName
//--------------------------------------------------------------------
#define WinName "�������� ����������"
void _fastcall TMainForm::EqmPrognozBasiks(TObject *Sender)
{
  TWTQuery *QueryAdr;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "bal_prognoz_basics_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������

/*
  int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
*/

  Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("mmgg", "������", "������");
 // Field->SetRequired("������������  ������ ���� ���������");

  Field = WGrid->AddColumn("res_demand", "�����������, ���.�", "����������� ����");
  Field = WGrid->AddColumn("losts_1kl", "����� 1��, ���.�", "����� 1 ����� ����");
  Field = WGrid->AddColumn("losts_2kl", "����� 2��, ���.�", "����� 2 ����� ����");

  Field = WGrid->AddColumn("res_demand_fact", "���� �����������, ���.�", "����������� ����");
  Field = WGrid->AddColumn("losts_1kl_fact", " ���� ����� 1��, ���.�", "����� 1 ����� ����");
  Field = WGrid->AddColumn("losts_2kl_fact", "���� ����� 2��, ���.�", "����� 2 ����� ����");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
//  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("bal_prognoz_basics_tbl");

  };
#undef WinName
//------------------------------------------------------------
#define WinName "��������� ��� ����� 1 �� ���"
void _fastcall TMainForm::RepNDSFizManual(TObject *Sender)
{

  TDateTime mmgg;
  TWTQuery * ZQMmgg = new TWTQuery(Application);
  ZQMmgg->Options.Clear();
  ZQMmgg->Options<< doQuickOpen;
  ZQMmgg->RequestLive=false;
  ZQMmgg->CachedUpdates=false;


  TWTQuery *QueryData;
  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }

  AnsiString sqlstr="select fun_mmgg() as mmgg;";

  ZQMmgg->Sql->Clear();
  ZQMmgg->Sql->Add(sqlstr);
  try
  {
   ZQMmgg->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQMmgg->Close();
    delete ZQMmgg;
    return;
  }
  mmgg =ZQMmgg->Fields->Fields[0]->AsDateTime;

  ZQMmgg->Close();


  QueryData = new  TWTQuery(this);
  QueryData->Options << doQuickOpen;

  QueryData->Sql->Clear();
/*
  QueryData->Sql->Add(" select r.*, (deb_b_01-kr_b_01 +dem_01 - opl_01 - sp1_01 - sp2_01 - deb_e_01+kr_e_01) as csum , \
                                    (dpdv_b_01-kpdv_b_01 +dempdv_01 - oplpdv_01 - sp1pdv_01 - sp2pdv_01 - dpdv_e_01+kpdv_e_01) as csum_pdv  \
    from rep_nds2011_fiz_tbl as r where mmgg = :pmmgg order by mmgg, id_pref, id_section, id_grp" );
  QueryData->ParamByName("pmmgg")->AsDateTime=mmgg;
*/

  QueryData->Sql->Add(" select r.*, (deb_b_01-kr_b_01 +dem_01 - opl_01 - sp1_01 - sp2_01 - deb_e_01+kr_e_01) as csum , \
                                    (dpdv_b_01-kpdv_b_01 +dempdv_01 - oplpdv_01 - sp1pdv_01 - sp2pdv_01 - dpdv_e_01+kpdv_e_01) as csum_pdv  \
    from rep_nds2011_fiz_tbl as r order by mmgg, id_pref, id_section, id_grp" );

  QueryData->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
  QueryData->Filtered=true;
  mmgg_sel= mmgg;

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryData,false);
  WF1Grid = WGrid;

  WGrid->SetCaption("��������� ��� ����� 1 �� ��� " +FormatDateTime("dd.mm.yy ",mmgg_sel));

  TWTQuery* Query = WGrid->DBGrid->Query;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������

/*
  int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    WGrid->DBGrid->ReadOnly=true;
*/

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("csum");
  NList->Add("csum_pdv");

  Query->SetSQLModify("rep_nds2011_fiz_tbl",WList,NList,true,true,true);

  TWTField *Field;

  Field = WGrid->AddColumn("mmgg", "�����", "�����");
  Field = WGrid->AddColumn("id_grp", "�����", "�����");
  Field->AddFixedVariable("2", "������");
  Field->AddFixedVariable("3","��������");
  Field->AddFixedVariable("4","���������");
  Field->SetRequired("����� ������ ���� ���������");

  Field = WGrid->AddColumn("id_section", "������ ������", "������ ������");
  Field->AddFixedVariable("1999","1999 ���");
  Field->AddFixedVariable("2000","2000 ���");
  Field->AddFixedVariable("2001","�� 1 ������� 2001");
  Field->AddFixedVariable("2002","�� 1 ������ 2011");
  Field->AddFixedVariable("2011","�� 1 ������ 2016");
  Field->SetRequired("������ ������ ���� ��������");

  Field = WGrid->AddColumn("fixed", "����", "����");
  Field->AddFixedVariable("0","-");
  Field->AddFixedVariable("1","����");

  Field = WGrid->AddColumn("csum", "�����.", "��������");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("csum_pdv", "�����.���", "�������� ���");
  Field->SetReadOnly();

  Field = WGrid->AddColumn("deb_b_01", "��.���.", "����� �� ������");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("dpdv_b_01", "��.���. ���", "����� �� ������ ���");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("kr_b_01", "��.���.", "������ �� ������");
  Field->SetReadOnly();
  Field = WGrid->AddColumn("kpdv_b_01", "��.���.���", "������ �� ������ ���");
  Field->SetReadOnly();

  Field = WGrid->AddColumn("kvt_01", "����,����", "�����������, ����");
  Field = WGrid->AddColumn("dem_01", "����,���", "�����������, ���");
  Field = WGrid->AddColumn("dempdv_01", "���� ���,���", "����������� ���, ���");

  Field = WGrid->AddColumn("billkt_01_1", "�� �����.�-�", "� �.�.�� �����.�-�");
  Field = WGrid->AddColumn("billktpdv_01_1", "�� �����.�-� ���", "� �.�.�� �����.�-� ���");

  Field = WGrid->AddColumn("opl_01", "������", "������");
  Field = WGrid->AddColumn("oplpdv_01", "������ ���", "������ ���");

  Field = WGrid->AddColumn("sp1_01", "����.�.�.", "������� �������� ���������");
  Field = WGrid->AddColumn("sp1pdv_01", "����.�.�.���", "������� �������� ��������� ���");

  Field = WGrid->AddColumn("sp2_01", "����.���.���.", "������� �� �����������");
  Field = WGrid->AddColumn("sp2pdv_01", "����.���.���.���", "������� �� ����������� ���");

  Field = WGrid->AddColumn("deb_e_01", "��.���.", "����� �� �����");
  Field = WGrid->AddColumn("dpdv_e_01", "��.���. ���", "����� �� ����� ���");
  Field = WGrid->AddColumn("kr_e_01", "��.���.", "������ �� �����");
  Field = WGrid->AddColumn("kpdv_e_01", "��.���. ���", "������ �� ����� ���");

//  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
//  WGrid->DBGrid->FieldDest = Sender;

  TWTToolBar* tb=WF1Grid->DBGrid->ToolBar;
  TWTToolButton* btPeriod=tb->AddButton("dateinterval", "����� �������", PeriodSel);

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("rep_nds2011_fiz_tbl");

  };
#undef WinName
void __fastcall TMainForm::PeriodSel(TObject *Sender)
{
    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    fPeriodSelect->FormShow(mmgg_sel,mmgg_sel);

    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };

   if (rez == mrOk)
   {

     AnsiString filter = "mmgg = '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"'";
     mmgg_sel =fPeriodSelect->DateFrom;

     WF1Grid->DBGrid->Query->DefaultFilter= filter;
     WF1Grid->DBGrid->Query->Filtered=true;

     WF1Grid->SetCaption("��������� ��� ����� 1 �� ��� " +FormatDateTime("dd.mm.yy ",mmgg_sel));
   }
};

