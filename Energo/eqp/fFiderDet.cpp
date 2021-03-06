//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "fFiderDet.h"
#include "fEqpBase.h"
#include "ftree.h"
#include "Main.h"
#include "equipment.h"
#include "fBal.h"
#include "SysUser.h"
#include "fmonFiderWorks.h"
#include "fWorkPlan.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfFiderDet *fFiderDet;
//AnsiString AddDataName;
AnsiString retvalue;
TWTWinDBGrid *WVoltageGrid;
TWTWinDBGrid *WPSGrid;
TWTDBGrid *WPosGrid;
//---------------------------------------------------------------------------
__fastcall TfFiderDet::TfFiderDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  edit_enable = CheckLevel("����� 2 - ��������� ������")!=0 ;
}
//---------------------------------------------------------------------------
void __fastcall TfFiderDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfFiderDet::FormShow(TObject *Sender)
{
// ��������� �����
// if(fTreeForm->EqpEdit->EqpType!=7)
 if(eqp_type!=15)
   {
     ShowMessage("������ ��� ������������ �� ��������������!");
     Close();
     return;
    };

   // �������� ����� ������
   GetTableNames(Sender);
   // ������� �� ���������� ������� ������

   if (mode==0) return;
   else
   {
     edClassId->ReadOnly =!edit_enable;
     edLostsCoef->ReadOnly =!edit_enable;
     sbClassSel->Enabled =edit_enable;
   }


   sqlstr=" select dt.id_voltage ,dt.losts_coef, dt.id_position, dt.l04_count, dt.l04_length, dt.l04f1_length,dt.l04f3_length, dt.Fgcp, dt.balans_only, \
   v.voltage_min, v.voltage_max, cp.represent_name, dt.id_station, ps.name_eqp as name_station \
   from %name_table AS dt left join  eqk_voltage_tbl AS v on (dt.id_voltage=v.id) \
   left join clm_position_tbl as cp on (cp.id = dt.id_position) \
   left join eqm_equipment_tbl as ps on (ps.id = dt.id_station) \
   where (dt.code_eqp= :code_eqp);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

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
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
     edClassId->Text=ZEqpQuery->FieldByName("id_voltage")->AsString;
     edLostsCoef->Text=ZEqpQuery->FieldByName("losts_coef")->AsString;
     id_position = ZEqpQuery->FieldByName("id_position")->AsInteger;
     EdPosition->Text=ZEqpQuery->FieldByName("represent_name")->AsString;

     edL04_count->Text=ZEqpQuery->FieldByName("l04_count")->AsString;
     edL04_length->Text=ZEqpQuery->FieldByName("l04_length")->AsString;
     edL04f1_length->Text=ZEqpQuery->FieldByName("l04f1_length")->AsString;
     edL04f3_length->Text=ZEqpQuery->FieldByName("l04f3_length")->AsString;
     edFgcp->Text=ZEqpQuery->FieldByName("Fgcp")->AsString;
     PSId =ZEqpQuery->FieldByName("id_station")->AsInteger;
     edPSName->Text=ZEqpQuery->FieldByName("name_station")->AsString;

     if (ZEqpQuery->FieldByName("voltage_min")->AsInteger==ZEqpQuery->FieldByName("voltage_max")->AsInteger)
     {
      lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" ��";
     }
     else
     {
      lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" - "+
      ZEqpQuery->FieldByName("voltage_max")->AsString +" ��";
     }

     if(ZEqpQuery->FieldByName("balans_only")->AsInteger==1)
     {
      cbBalansOnly->Checked = true;
     }
     else
     {
      cbBalansOnly->Checked = false;
     }


   };
   ZEqpQuery->Close();
   IsModified=false;

   // ���� ������� �� ����������� �������, ��������� ����� ������
   if (this->Parent->Parent->Parent!=NULL)
   {

     sqlstr="select sum(sn_len) as slen from bal_eqp_tbl as eq \
     join eqm_compens_station_inst_tbl as csi on (eq.code_eqp=csi.code_eqp) \
     where (eq.type_eqp = 6 or eq.type_eqp = 7) and csi.code_eqp_inst = :code_eqp \
     and mmgg =  :mmgg";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);

     ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
     ZEqpQuery->ParamByName("mmgg")->AsDateTime=((TfBalans* )(this->Parent->Parent->Parent->Parent->Parent))->mmgg;

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
     if (ZEqpQuery->RecordCount!=0)
     {
       ZEqpQuery->First();
       lLength->Caption=ZEqpQuery->FieldByName("slen")->AsString;

       lLengthCaption->Visible = true;
       lLength->Visible = true;
     };
     ZEqpQuery->Close();
   }
}
//---------------------------------------------------------------------------

 bool TfFiderDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,id_voltage,losts_coef,id_position,l04_count,l04_length,l04f1_length,l04f3_length,Fgcp,balans_only,id_station) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :id_voltage, :losts_coef, :id_position, :l04_count, :l04_length, :l04f1_length, :l04f3_length, :Fgcp, :balans_only, :id_station );");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);
   if (edLostsCoef->Text!="")
     ZEqpQuery->ParamByName("losts_coef")->AsFloat=StrToFloat(edLostsCoef->Text);

   if (edL04_count->Text!="")
     ZEqpQuery->ParamByName("l04_count")->AsInteger=StrToInt(edL04_count->Text);

   if (edL04_length->Text!="")
     ZEqpQuery->ParamByName("l04_length")->AsInteger=StrToInt(edL04_length->Text);

   if (edL04f1_length->Text!="")
     ZEqpQuery->ParamByName("l04f1_length")->AsInteger=StrToInt(edL04f1_length->Text);

   if (edL04f3_length->Text!="")
     ZEqpQuery->ParamByName("l04f3_length")->AsInteger=StrToInt(edL04f3_length->Text);

   if (edFgcp->Text!="")
     ZEqpQuery->ParamByName("Fgcp")->AsFloat=StrToFloat(edFgcp->Text);

   if (id_position!=0 )
     ZEqpQuery->ParamByName("id_position")->AsInteger=id_position;

   if (PSId!=0 )
     ZEqpQuery->ParamByName("id_station")->AsInteger=PSId;

   if(cbBalansOnly->Checked)
     ZEqpQuery->ParamByName("balans_only")->AsInteger=1;
   else
     ZEqpQuery->ParamByName("balans_only")->AsInteger=0;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("������ SQL");
    ZEqpQuery->Close();
    return false;
   }
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
 bool TfFiderDet::SaveData(void)
 {

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set ");
   ZEqpQuery->Sql->Add("id_voltage= :id_voltage, losts_coef= :losts_coef, id_position = :id_position, id_station = :id_station, ");
   ZEqpQuery->Sql->Add("l04_count = :l04_count, l04_length= :l04_length,l04f1_length= :l04f1_length,l04f3_length= :l04f3_length,Fgcp = :Fgcp, balans_only = :balans_only ");
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

   if (edLostsCoef->Text!="")
     ZEqpQuery->ParamByName("losts_coef")->AsFloat=StrToFloat(edLostsCoef->Text);

   if (edL04_count->Text!="")
     ZEqpQuery->ParamByName("l04_count")->AsInteger=StrToInt(edL04_count->Text);

   if (edL04_length->Text!="")
     ZEqpQuery->ParamByName("l04_length")->AsInteger=StrToInt(edL04_length->Text);

   if (edL04f1_length->Text!="")
     ZEqpQuery->ParamByName("l04f1_length")->AsInteger=StrToInt(edL04f1_length->Text);

   if (edL04f3_length->Text!="")
     ZEqpQuery->ParamByName("l04f3_length")->AsInteger=StrToInt(edL04f3_length->Text);

   if (edFgcp->Text!="")
     ZEqpQuery->ParamByName("Fgcp")->AsFloat=StrToFloat(edFgcp->Text);

   if (id_position!=0 )
     ZEqpQuery->ParamByName("id_position")->AsInteger=id_position;

   if (PSId!=0 )
     ZEqpQuery->ParamByName("id_station")->AsInteger=PSId;
   else
     ZEqpQuery->ParamByName("id_station")->Clear();   

   if(cbBalansOnly->Checked)
     ZEqpQuery->ParamByName("balans_only")->AsInteger=1;
   else
     ZEqpQuery->ParamByName("balans_only")->AsInteger=0;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("������ SQL ");
    ZEqpQuery->Close();
    return false;
   }
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------


void __fastcall TfFiderDet::edDataChange(TObject *Sender)
{
  if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfFiderDet::sbClassSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 if (edClassId->Text=="")
  ShowVoltage("0");
 else
  ShowVoltage(edClassId->Text);

}
//---------------------------------------------------------------------------
#define WinName "������ ����������"
void _fastcall TfFiderDet::ShowVoltage(AnsiString retvalue) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
  if (MainForm->ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,voltage_min ,voltage_max from eqk_voltage_tbl;" );

  WVoltageGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WVoltageGrid->SetCaption(WinName);

  TWTQuery* Query = WVoltageGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqk_voltage_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WVoltageGrid->AddColumn("id", "�����", "����� ����������");
  Field = WVoltageGrid->AddColumn("voltage_min", "U min", "����������� ����������");
  Field = WVoltageGrid->AddColumn("voltage_max", "U max", "������������ ����������");

  WVoltageGrid->DBGrid->FieldSource = WVoltageGrid->DBGrid->Query->GetTField("id");

  WVoltageGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WVoltageGrid->DBGrid->OnAccept=VoltageAccept;
  WVoltageGrid->DBGrid->Visible = true;
 // WVoltageGrid->DBGrid->ReadOnly=true;
  WVoltageGrid->ShowAs("�����������");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfFiderDet::VoltageAccept (TObject* Sender)
{
//   ShowMessage("������� :"+MeterGrid->DBGrid->StringDest);
   edClassId->Text=StrToInt(WVoltageGrid->DBGrid->StringDest);

   if (WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsInteger==WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsInteger)
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" ��";
   }
   else
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" - "+
    WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsString +" ��";
   }
   IsModified=true;
}
//----------------------------------------------------------
bool TfFiderDet::CheckData(void)
{
  if (edClassId->Text=="")
   {
     ShowMessage("�� ������ ������� ����������");
     return false;
   }

     return true;
}
//---------------------------------------------------------------------------

void __fastcall TfFiderDet::sbPositionClick(TObject *Sender)
{
  AnsiString EmpS="-1";
  TWTDBGrid* Grid;
  int id_res=0;
  AnsiString filt="";

  TWTQuery *QuerRes=new TWTQuery(this);
  QuerRes->Sql->Add("select syi_resid_fun() as idres");
  QuerRes->Open();

  id_res=QuerRes->FieldByName("idres")->AsInteger;
  filt="id_client="+ToStrSQL(id_res);
  Grid=MainForm->CliPositionSel(NULL,filt);

   if(Grid==NULL) return;
    else WPosGrid=Grid;

   WPosGrid->FieldSource= WPosGrid->Table->GetTField("id");

//   if (!EdPosition->Text.IsEmpty())
//     WPosGrid->StringDest = EdPosition->Text;
//   else
     WPosGrid->StringDest = EmpS;

   WPosGrid->OnAccept=PosAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfFiderDet::PosAccept (TObject* Sender)
{
     id_position=WPosGrid->Table->FieldByName("id")->AsInteger;
     EdPosition->Text=WPosGrid->Table->FieldByName("represent_name")->AsString;    

};
//---------------------------------------------------------------------------

void __fastcall TfFiderDet::spPositionClearClick(TObject *Sender)
{
    id_position=0;
    EdPosition->Text="";
}
//---------------------------------------------------------------------------

void __fastcall TfFiderDet::sbWorksClick(TObject *Sender)
{
  TfMonitorFiderWorks * fMonitorFiderWorks=new TfMonitorFiderWorks(this,eqp_id);

  fMonitorFiderWorks->ShowAs("������ ���. ����� ������");

  fMonitorFiderWorks->ID="������ ���. ����� ������";

  fMonitorFiderWorks->ShowData();

}
//---------------------------------------------------------------------------

void __fastcall TfFiderDet::sbPlanWorksClick(TObject *Sender)
{
  TfWorkPlan * fWorkPlan=new TfWorkPlan(this,eqp_id);

  fWorkPlan->ShowAs("���� ����� ������");

  fWorkPlan->ID="���� ����� ������";

  fWorkPlan->ShowData();
        
}
//---------------------------------------------------------------------------


void __fastcall TfFiderDet::sbPSClick(TObject *Sender)
{
  TWTQuery *QueryAdr;
  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp, eqk.voltage_min from eqm_equipment_tbl as eq ");
  QueryAdr->Sql->Add("join eqm_compens_station_tbl as cs on (eq.id = cs.code_eqp) ");
  QueryAdr->Sql->Add("join eqk_voltage_tbl as eqk on (eqk.id = cs.id_voltage) ");
  QueryAdr->Sql->Add("where eq.type_eqp = 8 and eqk.voltage_min > 10 order by eq.name_eqp; ");

  WPSGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WPSGrid->SetCaption("����������");

  TWTQuery* Query = WPSGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  QueryAdr->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

//  Field = WFiderGrid->AddColumn("kindname", "���", "���");
  Field = WPSGrid->AddColumn("name_eqp", "������������", "������������");
  Field = WPSGrid->AddColumn("voltage_min", "����������", "����������");

  WPSGrid->DBGrid->FieldSource = WPSGrid->DBGrid->Query->GetTField("id");

  WPSGrid->DBGrid->StringDest = "-1";
  WPSGrid->DBGrid->OnAccept=PSAccept;
  WPSGrid->DBGrid->Visible = true;
  WPSGrid->DBGrid->ReadOnly=true;
  WPSGrid->ShowAs("����� ��");

}
//---------------------------------------------------------------------------
void __fastcall TfFiderDet::PSAccept (TObject* Sender)
{
   PSId =WPSGrid->DBGrid->Query->FieldByName("id")->AsInteger;
   edPSName->Text =WPSGrid->DBGrid->Query->FieldByName("name_eqp")->AsString;
}
//---------------------------------------------------------------------------

void __fastcall TfFiderDet::sbPSClClick(TObject *Sender)
{
 PSId = 0;
 edPSName->Text ="";
}
//---------------------------------------------------------------------------

