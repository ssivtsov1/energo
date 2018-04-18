//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fEqpTheMeterDet.h"
#include "ftree.h"
#include "Main.h"
#include "fChange.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "fDet"
#pragma resource "*.dfm"
//TfEqpCompensDet *fEqpCompensDet;
AnsiString retvalue;
TWTWinDBGrid *MeterGrid;
TWTWinDBGrid *WVoltageGrid;
TWTWinDBGrid *WEnergyGrid;
TWTWinDBGrid *WZoneGrid;
TWTDBGrid *WTarGrid;
int Compensator;
//---------------------------------------------------------------------------
__fastcall TfEqpMeterDet::TfEqpMeterDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  ZEnergyQuery = new TWTQuery(Application);
//  ZEnergyQuery->MacroCheck=true;
  ZEnergyQuery->Options.Clear();
  ZEnergyQuery->Options<< doQuickOpen;
  ZEnergyQuery->RequestLive=true;
  ZEnergyQuery->CachedUpdates=false;
  ZEnergyQuery->AfterInsert=CancelInsert;
  ZEnergyQuery->AfterDelete=CancelInsert;

  dsEnergyQuery=new TDataSource(Application);
  dsEnergyQuery->DataSet=ZEnergyQuery;

  ZZoneQuery = new TWTQuery(Application);
//  ZZoneQuery->MacroCheck=true;
  ZZoneQuery->Options.Clear();
  ZZoneQuery->Options<< doQuickOpen;
  ZZoneQuery->RequestLive=true;
  ZZoneQuery->CachedUpdates=true;
  //ZZoneQuery->CachedUpdates=false;
  ZZoneQuery->BeforePost=NewZone;
  ZZoneQuery->AfterPost=PostZone;
  ZZoneQuery->AfterScroll=ZonesScroll;
  ZZoneQuery->AfterInsert=CancelInsert;
 // ZZoneQuery->AfterDelete=CancelInsert;

  dsZoneQuery=new TDataSource(Application);
  dsZoneQuery->DataSet=ZZoneQuery;

  ZZoneProcQuery = new TWTQuery(Application);
  ZZoneProcQuery->Options.Clear();
  ZZoneProcQuery->Options<< doQuickOpen;
  ZZoneProcQuery->RequestLive=true;
  //ZZoneProcQuery->CachedUpdates=false;
  ZZoneProcQuery->CachedUpdates=true;
  ZZoneProcQuery->BeforePost=EditZoneProc;
  ZZoneProcQuery->AfterPost=PostZone;
  ZZoneProcQuery->AfterEdit = ZoneProcChanged;
  ZZoneProcQuery->AfterInsert=CancelInsert;

  dsZoneProcQuery=new TDataSource(Application);
  dsZoneProcQuery->DataSet=ZZoneProcQuery;


//  ZEnergyQuery->Transaction->AutoCommit=false;
//  ZZoneQuery->Transaction->AutoCommit=false;

  usr_id=1;     //       !!!!!!!!!!!!!!
//  CangeLogEnabled=false;
  operation=0;

  edit_enable = CheckLevel("����� 2 - ��������� ��������")!=0 ;  
  }
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
delete dsEnergyQuery;
delete dsZoneQuery;
delete dsZoneProcQuery;
delete ZEnergyQuery;
delete ZZoneQuery;
delete ZZoneProcQuery;

Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::FormShow(TObject *Sender)
{
// ��������� �����


 if(eqp_type!=1)
   {
     ShowMessage("������ ��� ������������ �� ��������������!");
     return;
    };

   // �������� ����� ������
   GetTableNames(Sender);
   
   sqlstr=" select value_ident::::int from syi_sysvars_tbl  where ident='flag_dneprbill';";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   int flag_dnepr;
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
     flag_dnepr=ZEqpQuery->FieldByName("value_ident")->AsInteger;
    }
   // ������� �� ���������� ������� ������
   lMeterType->Caption ="";
   if (mode==0) return;
   else
   {
     if (is_res)
      {  edControlData->ReadOnly =!edit_enable;}
     else
  { if (flag_dnepr!=1)
        edControlData->ReadOnly =true;
     else
         edControlData->ReadOnly=false;
     dgEnergy->ReadOnly =!edit_enable;
     edWarm_comment->ReadOnly =!edit_enable;
     mObjName->ReadOnly =!edit_enable;
     dgZones->ReadOnly =!edit_enable;
     edMet_comment->ReadOnly =!edit_enable;
     dgZoneProc->ReadOnly =!edit_enable;

     cbWarm->Enabled =edit_enable;
     cbMagnet->Enabled =edit_enable;
     bEqpTypeSel->Enabled =edit_enable;
     cbCount_met->Enabled =edit_enable;
   };
   };

   sbAddEnergy->Enabled =edit_enable;
//   sbDelEnergy->Enabled=true;
//   sbSaveEnergy->Enabled=true;
   sbAddZone->Enabled =edit_enable;
   sbAddZone2->Enabled=edit_enable;
//   sbDelZone->Enabled=true;
   sbSaveZone->Enabled=edit_enable;
   dgEnergy->Enabled=true;
   dgZones->Enabled=true;
   dgZoneProc->Enabled=true;

/*
   sqlstr=" select dt.id_type_eqp,dt.dt_control,dt.nm,dt.account,dt.main_duble, \
   dt.class,dt.code_group,dt.warm,dt.industry,p.name as indname,tr.name as tarifname, \
   it.type AS typename, v.voltage_min, v.voltage_max \
   from %name_table_id AS it, ((%name_table AS dt left join \
   eqk_voltage_tbl AS v on (dt.class=v.id)) left join \
   aci_tarif_tbl as tr on (tr.id=dt.code_group)) left join cla_param_tbl as p on (dt.industry=p.id) \
   where (dt.id_type_eqp=it.id)and(dt.code_eqp= :code_eqp);";
*/

   sqlstr=" select dt.id_type_eqp,dt.dt_control,dt.nm, \
   dt.warm, dt.count_met, dt.met_comment, dt.warm_comment, dt.magnet, it.type AS typename \
   from %name_table_id AS it, %name_table AS dt  \
   where (dt.id_type_eqp=it.id)and(dt.code_eqp= :code_eqp);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
   ZEqpQuery->MacroByName("name_table_id")->AsString=name_table_ind;

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

     edMeterTypeName->Text=ZEqpQuery->FieldByName("typename")->AsString;

     MeterId=ZEqpQuery->FieldByName("id_type_eqp")->AsInteger;
     lMeterType->Caption =IntToStr(MeterId);

//     edClassId->Text=ZEqpQuery->FieldByName("class")->AsString;
//     lMinVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString;
//     lMaxVal->Caption=ZEqpQuery->FieldByName("voltage_max")->AsString+" ��";
//     edEkvivalent->Text=ZEqpQuery->FieldByName("d")->AsString;
     mObjName->Text=ZEqpQuery->FieldByName("nm")->AsString;

//     edTarifName->Text=ZEqpQuery->FieldByName("tarifname")->AsString;
//     TarifId=ZEqpQuery->FieldByName("code_group")->AsInteger;

//     edIndustry->Text=ZEqpQuery->FieldByName("indname")->AsString;
//     IndustryId=ZEqpQuery->FieldByName("industry")->AsInteger;

 //    edBeginCount->Text=ZEqpQuery->FieldByName("begin_count")->AsString;

     if (!ZEqpQuery->FieldByName("dt_control")->IsNull)
        edControlData->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("dt_control")->AsDateTime);
     else edControlData->Text="  .  .    ";

//     edInclude->Text=ZEqpQuery->FieldByName("main_duble")->AsString;
/*
     if (ZEqpQuery->FieldByName("count_lost")->AsInteger==1)
       cbCounLost->Checked=true;
     else
       cbCounLost->Checked=false;
*/
     if (ZEqpQuery->FieldByName("magnet")->AsInteger==1)
       cbMagnet->Checked=true;
     else
       cbMagnet->Checked=false;

     if (ZEqpQuery->FieldByName("warm")->AsInteger==1)
       cbWarm->Checked=true;
     else
       cbWarm->Checked=false;

     if (ZEqpQuery->FieldByName("count_met")->AsInteger==1)
       cbCount_met->Checked=true;
     else
       cbCount_met->Checked=false;

     edMet_comment->Text=ZEqpQuery->FieldByName("met_comment")->AsString;
     edWarm_comment->Text=ZEqpQuery->FieldByName("warm_comment")->AsString;

   };
   ZEqpQuery->Close();
   IsModified=false;
   ShowEnergyGrid();
   ShowZonesGrid();
   ShowZonesProcGrid();
//   FindCompensator();
}
//---------------------------------------------------------------------------
 bool TfEqpMeterDet::SaveData(void)
 {
   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set id_type_eqp = :id_type_eqp, ");
   ZEqpQuery->Sql->Add("dt_control= :dt_control, nm= :nm, warm_comment = :warm_comment, ");
   ZEqpQuery->Sql->Add("warm = :warm , count_met= :count_met, met_comment= :met_comment, magnet = :magnet ");
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_type_eqp")->AsInteger=MeterId;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
//   if (edClassId->Text!="")
//     ZEqpQuery->ParamByName("class")->AsInteger=StrToInt(edClassId->Text);
//   if (edEkvivalent->Text!="")
//     ZEqpQuery->ParamByName("d")->AsFloat=StrToFloat(edEkvivalent->Text);
//   if (edBeginCount->Text!="")
//     ZEqpQuery->ParamByName("begin_count")->AsInteger=StrToInt(edBeginCount->Text);

   ZEqpQuery->ParamByName("nm")->AsString=mObjName->Text;
   if (edControlData->Text!="  .  .    ")
       ZEqpQuery->ParamByName("dt_control")->AsDateTime=StrToDate(edControlData->Text);
   else
       ZEqpQuery->ParamByName("dt_control")->Clear();

   ZEqpQuery->ParamByName("count_met")->AsInteger=cbCount_met->Checked?1:0;
   ZEqpQuery->ParamByName("magnet")->AsInteger=cbMagnet->Checked?1:0;

   if (edMet_comment->Text!="")
     ZEqpQuery->ParamByName("met_comment")->AsString=edMet_comment->Text;


   ZEqpQuery->ParamByName("warm")->AsInteger=cbWarm->Checked?1:0;

   if (edWarm_comment->Text!="")
     ZEqpQuery->ParamByName("warm_comment")->AsString=edWarm_comment->Text;

//   ZEqpQuery->ParamByName("code_group")->AsInteger=TarifId;
//   if (IndustryId!=0)
//     ZEqpQuery->ParamByName("industry")->AsInteger=IndustryId;



   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
    return false;
   }

  if(dgEnergy->Enabled==false)
  {
   sbAddEnergy->Enabled=edit_enable;
   sbDelEnergy->Enabled=edit_enable;
//   sbSaveEnergy->Enabled=true;
   dgEnergy->Enabled=true;
   ZEnergyQuery->Open();
  }
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
  bool TfEqpMeterDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,id_type_eqp,dt_control, nm, warm,count_met,met_comment,warm_comment,magnet ) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :id_type_eqp, :dt_control, :nm, :warm , :count_met, :met_comment, :warm_comment, :magnet);");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_type_eqp")->AsInteger=MeterId;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
   ZEqpQuery->ParamByName("nm")->AsString=mObjName->Text;
//   if (edClassId->Text!="")
//     ZEqpQuery->ParamByName("class")->AsInteger=StrToInt(edClassId->Text);
//   if (edEkvivalent->Text!="")
//     ZEqpQuery->ParamByName("d")->AsFloat=StrToFloat(edEkvivalent->Text);
//   if (edBeginCount->Text!="")
//     ZEqpQuery->ParamByName("begin_count")->AsInteger=StrToInt(edBeginCount->Text);


   if (edControlData->Text!="  .  .    ")
       ZEqpQuery->ParamByName("dt_control")->AsDateTime=StrToDate(edControlData->Text);
   else
       ZEqpQuery->ParamByName("dt_control")->Clear();

//   ZEqpQuery->ParamByName("count_lost")->AsInteger=cbCounLost->Checked?1:0;
   ZEqpQuery->ParamByName("warm")->AsInteger=cbWarm->Checked?1:0;
   if (edWarm_comment->Text!="")
     ZEqpQuery->ParamByName("warm_comment")->AsString=edWarm_comment->Text;


//   ZEqpQuery->ParamByName("code_group")->AsInteger=TarifId;
//   if (IndustryId!=0)
//     ZEqpQuery->ParamByName("industry")->AsInteger=IndustryId;

   ZEqpQuery->ParamByName("count_met")->AsInteger=cbCount_met->Checked?1:0;
   ZEqpQuery->ParamByName("magnet")->AsInteger=cbMagnet->Checked?1:0;

   if (edMet_comment->Text!="")
     ZEqpQuery->ParamByName("met_comment")->AsString=edMet_comment->Text;

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

   sbAddEnergy->Enabled=true;
   sbDelEnergy->Enabled=true;
//   sbSaveEnergy->Enabled=true;
   sbAddZone->Enabled=true;
   sbAddZone2->Enabled=true;
   sbDelZone->Enabled=true;
   sbSaveZone->Enabled=true;
   dgEnergy->Enabled=true;
   dgZones->Enabled=true;
   dgZoneProc->Enabled=true;

   ShowEnergyGrid();
   ShowZonesGrid();
   ShowZonesProcGrid();
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
void _fastcall TfEqpMeterDet::ShowMeter(AnsiString retvalue) {
  TWTWinDBGrid* Grid;
  //Grid->DBGrid->ReadOnly=true;
  Grid=MainForm->EqiAMeterSpr("�������������");
  if(Grid==NULL) return;
  else MeterGrid=Grid;

  MeterGrid->DBGrid->FieldSource = MeterGrid->DBGrid->Query->GetTField("id");
  if (retvalue!="0")
      MeterGrid->DBGrid->StringDest = retvalue;
  else
      MeterGrid->DBGrid->StringDest = -1;
  MeterGrid->DBGrid->OnAccept=MeterAccept;
      int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
     return;
   };
   if (ChLevel==1)
    MeterGrid->DBGrid->ReadOnly=true;
 // MeterGrid->DBGrid->Visible = true;
 // MeterGrid->DBGrid->ReadOnly=true;
 // MeterGrid->ShowAs("�������������");

};
//---------------------------------------------------------------------------
#define WinName "���� �������"
void _fastcall TfEqpMeterDet::ShowEnergy(AnsiString retvalue) {

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
  QueryAdr->Sql->Add("select me.kind_energy, me.id_type_eqp, en.name from eqi_meter_energy_tbl AS me, eqk_energy_tbl AS en " );
  QueryAdr->Sql->Add("where (en.id = me.kind_energy) and (me.id_type_eqp= :MeterId);");
  QueryAdr->ParamByName("MeterId")->AsInteger=MeterId;

  WEnergyGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WEnergyGrid->SetCaption(WinName);

  TWTQuery* Query = WEnergyGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("kind_energy");
  WList->Add("id_type_eqp");

  TStringList *NList=new TStringList();
  NList->Add("name");

  Query->SetSQLModify("eqi_meter_energy_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WEnergyGrid->AddColumn("name", "���� �������", "���� ����������� ������ ����� �������� �������");

  WEnergyGrid->DBGrid->FieldSource = WEnergyGrid->DBGrid->Query->GetTField("kind_energy");

  WEnergyGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WEnergyGrid->DBGrid->OnAccept=EnergyAccept;
  WEnergyGrid->DBGrid->Visible = true;
//  WEnergyGrid->DBGrid->ReadOnly=true;
  WEnergyGrid->ShowAs("������������");
};
#undef WinName
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::bEqpTypeSelClick(TObject *Sender)
{
  if (fReadOnly) return;
  ShowMeter(MeterId);
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::MeterAccept (TObject* Sender)
{
//   ShowMessage("������� :"+MeterGrid->DBGrid->StringDest);
 /* if (MeterId!=StrToInt(MeterGrid->DBGrid->StringDest))
  {
   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("delete from eqd_meter_energy_tbl ");
   ZEqpQuery->Sql->Add("where (code_eqp = :eqp);");

   ZEqpQuery->ParamByName("eqp")->AsInteger=eqp_id;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("������ SQL ");
    ZEqpQuery->Close();
    return ;
   }
   ShowEnergyGrid();
  };
  */
   if((MeterId!=StrToInt(MeterGrid->DBGrid->StringDest))&&(mode==1))
   {
    sbAddEnergy->Enabled=false;
    sbDelEnergy->Enabled=false;
//    sbSaveEnergy->Enabled=false;
    dgEnergy->Enabled=false;
    ZEnergyQuery->Close();
   }

   MeterId=StrToInt(MeterGrid->DBGrid->StringDest);
   lMeterType->Caption =MeterGrid->DBGrid->StringDest;
   edMeterTypeName->Text=MeterGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;

}
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::sbDelEnergyClick(TObject *Sender)
{
   if (fReadOnly) return;
   if (MessageDlg("������� ��� ������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;

   //!!!!!!!!!!!!!!!!! ��� ���������
   operation=MainForm->PrepareChange(ZEqpQuery,4,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)  return;


   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("delete from eqd_meter_energy_tbl ");
   ZEqpQuery->Sql->Add("where (code_eqp = :eqp) and (kind_energy= :kind);");

   ZEqpQuery->ParamByName("eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("kind")->AsInteger=
         ZEnergyQuery->FieldByName("kind_energy")->AsInteger;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    //��� ������ ���������� ���������� � ��������� ������ ���������
    // �������, ���������� ����. �����������
    MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
    operation=0;
//    ZEqpQuery->Transaction->Commit();
    return ;
   }
   MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
   operation=0;
//   ZEqpQuery->Transaction->Commit();
   ZEnergyQuery->Refresh();

   if(ZEnergyQuery->RecordCount==0)
     sbDelEnergy->Enabled=false;
 }
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::sbAddEnergyClick(TObject *Sender)
{
  if (fReadOnly) return;
  ShowEnergy("0");
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::EnergyAccept (TObject* Sender)
{
   TLocateOptions Opts;
   Opts.Clear();
   if (ZEnergyQuery->Locate("kind_energy", Variant(WEnergyGrid->DBGrid->StringDest), Opts))
      return;

   //������� ����
   TDate EnergyDate;

   if (CangeLogEnabled)
    {
     TfChangeDate* fChangeDate;
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     fChangeDate->Label1->Caption="���� ���������";
     //fChangeDate->DateTime->Date=
     if (fChangeDate->ShowModal()!= mrOk)
     {
        delete fChangeDate;
        return ; // ��������
     };
//     EnergyDate=fChangeDate->DateTime->Date;
     try
     {
      EnergyDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      return ;
     }

     delete fChangeDate;
    }
   else
    {
     ShortDateFormat="dd/mm/yyyy";
     EnergyDate=StrToDate(((TfEqpEdit*)(this->Parent->Parent))->edDt_install->Text);
    }

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into eqd_meter_energy_tbl(code_eqp,kind_energy,date_inst) ");
   ZEqpQuery->Sql->Add("values ( :typr_eqp, :kind, :date_inst);");

   ZEqpQuery->ParamByName("typr_eqp")->AsInteger=eqp_id;


   ZEqpQuery->ParamByName("date_inst")->AsDateTime=EnergyDate;

   ZEqpQuery->ParamByName("kind")->AsInteger=
         StrToInt(WEnergyGrid->DBGrid->StringDest);

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    return ;
   }
//   ZEqpQuery->Transaction->Commit();
   ZEnergyQuery->Refresh();
   sbDelEnergy->Enabled=edit_enable;

};
//---------------------------------------------------------------------------
void TfEqpMeterDet::ShowEnergyGrid(void)
{

   ZEnergyQuery->Close();
   ZEnergyQuery->Sql->Clear();
   ZEnergyQuery->Sql->Add("select me.code_eqp,me.kind_energy, en.name, me.date_inst from eqd_meter_energy_tbl AS me, eqk_energy_tbl AS en ");
   ZEnergyQuery->Sql->Add("where (en.id = me.kind_energy) and (me.code_eqp= :eqp);");
   ZEnergyQuery->ParamByName("eqp")->AsInteger=eqp_id;

   try
   {
    ZEnergyQuery->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL ");
    ZEnergyQuery->Close();
    return ;
   }

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("kind_energy");
   WList->Add("date_inst");

   TStringList *NList=new TStringList();
   NList->Add("name");
   ZEnergyQuery->SetSQLModify("eqd_meter_energy_tbl",WList,NList,true,true,true);

   dgEnergy->DataSource=dsEnergyQuery;
   ((TDateTimeField*)ZEnergyQuery->FieldByName("date_inst"))->DisplayFormat="dd.mm.yyyy";
   if (fReadOnly)dgEnergy->ReadOnly=true;
}
//---------------------------------------------------------------------------
void TfEqpMeterDet::FindCompensator(void)
{
/*   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("select find_eqm( :eqpid, :treeid, 2); ");

   ZEqpQuery->ParamByName("eqpid")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("treeid")->AsInteger=fTreeForm->tree_id;

   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL ");
    ZEqpQuery->Close();
    return ;
   }
   Compensator=ZEqpQuery->Fields->Fields[0]->AsInteger;
   if (Compensator!=0)
   {
     for(int n=0;n<=fTreeForm->tTreeEdit->Items->Count-1;n++)
     {
      if (fTreeForm->tTreeEdit->Items->Item[n]->StateIndex==Compensator)
       {
        lCompens->Caption=fTreeForm->tTreeEdit->Items->Item[n]->Text;
       }
     }
   }
   else
     lCompens->Caption="-���-";
  */
}
//----------------------------------------------------------------------
/*
void __fastcall TfEqpMeterDet::sbGotoCompClick(TObject *Sender)
{
 if (Compensator!=0)
 {
     for(int n=0;n<=fTreeForm->tTreeEdit->Items->Count-1;n++)
     {
      if (fTreeForm->tTreeEdit->Items->Item[n]->StateIndex==Compensator)
       {
        fTreeForm->tTreeEdit->Items->Item[n]->Selected=true;
       }
     }
 }

}
*/
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::CancelInsert(TDataSet* DataSet)
{
DataSet->Cancel();
}
//---------------------------------------------------------------------------
void TfEqpMeterDet::ShowZonesGrid(void)
{
   ZZoneQuery->Close();
   ZZoneQuery->Sql->Clear();
   ZZoneQuery->Sql->Add("select mz.code_eqp,mz.dt_zone_install,mz.zone, mz.kind_energy, mz.time_begin,mz.time_end,kz.name, en.name as enname ");
   ZZoneQuery->Sql->Add("from eqd_meter_zone_tbl as mz,eqk_zone_tbl as kz,eqk_energy_tbl as en");
   ZZoneQuery->Sql->Add("where mz.code_eqp= :eqp and kz.id = mz.zone and en.id = mz.kind_energy order by time_begin;");
   ZZoneQuery->ParamByName("eqp")->AsInteger=eqp_id;

   try
   {
    ZZoneQuery->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL ");
    ZZoneQuery->Close();
    return ;
   }

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("dt_zone_install");
   WList->Add("zone");
   WList->Add("kind_energy");

   TStringList *NList=new TStringList();
//   NList->Add("name");
   ZZoneQuery->SetSQLModify("eqd_meter_zone_tbl",WList,NList,true,true,true);

   dgZones->DataSource=dsZoneQuery;
   ((TDateTimeField*)ZZoneQuery->FieldByName("dt_zone_install"))->DisplayFormat="dd.mm.yyyy";
   if (fReadOnly)dgZones->ReadOnly=true;
}
//---------------------------------------------------------------------------
/*
void __fastcall TfEqpMeterDet::sbAddZoneClick(TObject *Sender)
{

//
  if (fReadOnly) return;
  TWTWinDBGrid* Grid;
  Grid=MainForm->EqkZoneSel(NULL);
  if(Grid==NULL) return;
  else WZoneGrid=Grid;

  WZoneGrid->DBGrid->FieldSource = WZoneGrid->DBGrid->Table->GetTField("id");
  WZoneGrid->DBGrid->StringDest = -1;
  WZoneGrid->DBGrid->OnAccept=ZoneAccept;

}
*/
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::sbDelZoneClick(TObject *Sender)
{
   if (fReadOnly) return;
   if (MessageDlg("������� ���� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;
   //!!!!!!!!!!!!!!!!! ��� ���������
   operation=MainForm->PrepareChange(ZEqpQuery,4,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)  return;

   try
   {
    ZZoneQuery->Delete();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ : "+e.Message.SubString(8,200));
//    ZEqpQuery->Transaction->Rollback();
    MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
    operation=0;
//    ZEqpQuery->Transaction->Commit();

    ZZoneQuery->Refresh();
    return ;
   }
   MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
   operation=0;
//   ZEqpQuery->Transaction->Commit();
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::ZoneAccept(TObject* Sender)
{
/*   TLocateOptions Opts;
   Opts.Clear();
   if (ZEnergyQuery->Locate("kind_energy", Variant(WEnergyGrid->DBGrid->StringDest), Opts))
      return;
  */
   //������� ����
   TDate ZoneDate;
   if (CangeLogEnabled)
    {
     TfChangeDate* fChangeDate;
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     fChangeDate->Label1->Caption="���� ��������� ����";
     if (fChangeDate->ShowModal()!= mrOk)
      {
        delete fChangeDate;
        return ; // ��������
      };
//     ZoneDate=fChangeDate->DateTime->Date;
     try
     {
      ZoneDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      return ;
     }

     delete fChangeDate;
    }
   else
    {
     ZoneDate=StrToDate(((TfEqpEdit*)(this->Parent->Parent))->edDt_install->Text);
    }

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into eqd_meter_zone_tbl(code_eqp,dt_zone_install,zone,kind_energy) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :dt_zone_install, :zone, :kind_energy);");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("zone")->AsInteger=WZoneGrid->DBGrid->Query->FieldByName("id_zone")->AsInteger;
   ZEqpQuery->ParamByName("kind_energy")->AsInteger=WZoneGrid->DBGrid->Query->FieldByName("kind_energy")->AsInteger;

   ZEqpQuery->ParamByName("dt_zone_install")->AsDateTime=ZoneDate;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    return ;
   }
//   ZEqpQuery->Transaction->Commit();
   ZZoneQuery->Refresh();
};
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::NewZone(TDataSet* DataSet)
{
if (ZZoneQuery->State==Db::dsInsert)
 {
 ZZoneQuery->FieldByName("code_eqp")->AsInteger=eqp_id;

 TfChangeDate* fChangeDate;
 Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
 fChangeDate->Label1->Caption="���� �������� ���������";
 if (fChangeDate->ShowModal()!= mrOk)
  {
    delete fChangeDate;
    Abort(); // ��������
   };


     try
     {
      ZZoneQuery->FieldByName("dt_zone_install")->AsDateTime=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      Abort();
     }

// ZZoneQuery->FieldByName("dt_zone_install")->AsDateTime=fChangeDate->DateTime->Date;
 delete fChangeDate;
 }
 if (ZZoneQuery->State==Db::dsEdit)
 {
   operation=MainForm->PrepareChange(ZEqpQuery,4,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)  Abort();
 }
}
//-----------------------------------------------------------------------

void __fastcall TfEqpMeterDet::dgZonesColEnter(TObject *Sender)
{
if (dgZones->SelectedField!=NULL)
 {
 if ((dgZones->SelectedField->FieldName=="time_begin")||(dgZones->SelectedField->FieldName=="time_end"))
  {
  if(ZZoneQuery->FieldByName("zone")->IsNull)
    dgZones->SelectedField->ReadOnly=false;
  else
    dgZones->SelectedField->ReadOnly=true;
  }
 }
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::ZonesScroll(TDataSet* DataSet)
{
 dgZonesColEnter(this);
}
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::sbSaveEnergyClick(TObject *Sender)
{
 ZEnergyQuery->First();
}
//---------------------------------------------------------------------------
bool TfEqpMeterDet::CheckData(void)
{
/*
  if (edClassId->Text=="")
   {
     ShowMessage("�� ������ ����� ����������");
     return false;
   }
*/
  if (MeterId==0)
   {
     ShowMessage("�� ������ ���.");
     return false;
   }
/*  if (edEkvivalent->Text=="")
   {
     ShowMessage("�� ������ ������. ���������� ���������� ��������");
     return false;
   }*/
/*  if (edBeginCount->Text=="")
   {
     ShowMessage("�� ������� ��������� ���������");
     return false;
   }
  */
/*
  if (AccountId==0)
   {
     ShowMessage("�� ������ ���� �������.");
     return false;
   }
   */
/*  if (TarifId==0)
   {
     ShowMessage("�� ������� ������ �������.");
     return false;
   }
  */

     return true;
}
//---------------------------------------------------------------------------


void __fastcall TfEqpMeterDet::dgEnergyEnter(TObject *Sender)
{
if(ZEnergyQuery->RecordCount>0)
   sbDelEnergy->Enabled=edit_enable;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::dgZonesEnter(TObject *Sender)
{
if(ZZoneQuery->RecordCount>0)
  sbDelZone->Enabled=edit_enable;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::PostZone(TDataSet* DataSet)
{
 if(operation!=0)
 {
    MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
    operation=0;
//    ZEqpQuery->Transaction->Commit();
 //   DataSet->Refresh();
  }
}
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::edDataChange(TObject *Sender)
{
  if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::cbCounLostClick(TObject *Sender)
{
 IsModified=true;
}
//---------------------------------------------------------------------------
#define WinName "����"
//void _fastcall TfEqpMeterDet::ShowEnergy(AnsiString retvalue) {
void __fastcall TfEqpMeterDet::sbAddZoneClick(TObject *Sender)
{
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
  QueryAdr->Sql->Add("select me.kind_energy, en.name as enname, kz.id as id_zone, kz.name as znname, (me.kind_energy*100+ kz.id ) as ez" );
  QueryAdr->Sql->Add("from  eqk_energy_tbl AS en, eqd_meter_energy_tbl as me,  eqk_zone_tbl as kz " );
  QueryAdr->Sql->Add("where (en.id = me.kind_energy) and me.code_eqp = :eqp; ");
  QueryAdr->ParamByName("eqp")->AsInteger=eqp_id;

  WZoneGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WZoneGrid->SetCaption(WinName);

  TWTQuery* Query = WZoneGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("ez");


  TStringList *NList=new TStringList();
  NList->Add("znname");
  NList->Add("enname");

  Query->SetSQLModify("eqi_meter_energy_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WZoneGrid->AddColumn("enname", "���� �������", "���� ����������� ������ ����� �������� �������");
  Field = WZoneGrid->AddColumn("znname", "����", "����");

  WZoneGrid->DBGrid->FieldSource = WZoneGrid->DBGrid->Query->GetTField("ez");

  WZoneGrid->DBGrid->StringDest = -1;

  WZoneGrid->DBGrid->OnAccept=ZoneAccept;

  WZoneGrid->DBGrid->Visible = true;
  WZoneGrid->ShowAs("���������");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::ZoneAccept2(TObject* Sender)
{
   //������� ����
   TDate ZoneDate;
   if (CangeLogEnabled)
    {
     TfChangeDate* fChangeDate;
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     fChangeDate->Label1->Caption="���� ��������� ����";
     if (fChangeDate->ShowModal()!= mrOk)
      {
        delete fChangeDate;
        return ; // ��������
      };

     try
     {
      ZoneDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      return ;
     }

     delete fChangeDate;
    }
   else
    {
     ZoneDate=StrToDate(((TfEqpEdit*)(this->Parent->Parent))->edDt_install->Text);
    }

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into eqd_difmetzone_tbl(code_eqp,zone,zone_p,kind_energy,dt_b) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :zone, :zone_p, :kind_energy, :dt_b);");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("zone")->AsInteger=WZoneGrid->DBGrid->Query->FieldByName("id_zone")->AsInteger;
   ZEqpQuery->ParamByName("zone_p")->AsInteger=WZoneGrid->DBGrid->Query->FieldByName("id_zonep")->AsInteger;
   ZEqpQuery->ParamByName("kind_energy")->AsInteger=WZoneGrid->DBGrid->Query->FieldByName("kind_energy")->AsInteger;

   ZEqpQuery->ParamByName("dt_b")->AsDateTime=ZoneDate;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    return ;
   }
//   ZEqpQuery->Transaction->Commit();
//   ZZoneProcQuery->Transaction->Commit();
   ZZoneProcQuery->Refresh();
};
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::sbDelZoneProcClick(TObject *Sender)
{
   if (fReadOnly) return;
   if (MessageDlg("������� ���� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;
   //!!!!!!!!!!!!!!!!! ��� ���������
   operation=MainForm->PrepareChange(ZEqpQuery,4,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)  return;

   try
   {
    ZZoneProcQuery->Delete();
   }
   catch(...)
   {
    ShowMessage("������ �������� ����.");
//    ZEqpQuery->Transaction->Rollback();
    MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
    operation=0;
//    ZEqpQuery->Transaction->Commit();

    ZZoneProcQuery->Refresh();
    return ;
   }

   MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
   operation=0;
//   ZZoneProcQuery->Transaction->Commit();
//   ZEqpQuery->Transaction->Commit();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::EditZoneProc(TDataSet* DataSet)
{
if ((ZZoneProcQuery->State!=Db::dsInsert)||(ZZoneProcQuery->State==Db::dsEdit))
 {
// ZZoneQuery->FieldByName("code_eqp")->AsInteger=eqp_id;
 /*
 TfChangeDate* fChangeDate;
 Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
 fChangeDate->Label1->Caption="���� �������� ���������";
 if (fChangeDate->ShowModal()!= mrOk)
  {
    delete fChangeDate;
    Abort(); // ��������
   };

     try
     {
      ZZoneProcQuery->FieldByName("dt_b")->AsDateTime=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      Abort();
     }

 delete fChangeDate;
*/
 operation=MainForm->PrepareChange(ZEqpQuery,4,0,eqp_id,usr_id,CangeLogEnabled);
 if (operation ==-1)  Abort();
 }
}
//-----------------------------------------------------------------------
void __fastcall TfEqpMeterDet::sbSaveZoneClick(TObject *Sender)
{
 if (fReadOnly) return;
 ZZoneProcQuery->First();
 sbSaveZone2->Enabled=false;
}
//-----------------------------------------------------------------------
void __fastcall TfEqpMeterDet::ZoneProcChanged(TDataSet* DataSet)
{
 if (fReadOnly) return;
 sbSaveZone2->Enabled = true;
}
//---------------------------------------------------------------------------
void TfEqpMeterDet::ShowZonesProcGrid(void)
{
   ZZoneProcQuery->Close();
   ZZoneProcQuery->Sql->Clear();
   ZZoneProcQuery->Sql->Add("select mz.id,mz.code_eqp,mz.dt_b,mz.zone, mz.zone_p, mz.kind_energy,mz.percent, kz.name, kz2.name as namep, en.name as enname ");
   ZZoneProcQuery->Sql->Add("from eqd_difmetzone_tbl as mz,eqk_zone_tbl as kz,eqk_energy_tbl as en, eqk_zone_tbl as kz2 ");
   ZZoneProcQuery->Sql->Add("where mz.code_eqp= :eqp and kz.id = mz.zone and kz2.id = mz.zone_p and en.id = mz.kind_energy order by zone;");
   ZZoneProcQuery->ParamByName("eqp")->AsInteger=eqp_id;

   try
   {
    ZZoneProcQuery->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL ");
    ZZoneProcQuery->Close();
    return ;
   }

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("dt_b");
   WList->Add("zone");
   WList->Add("zone_p");   
   WList->Add("kind_energy");

   TStringList *NList=new TStringList();
   NList->Add("name");
   NList->Add("namep");   
   NList->Add("enname");   

   ZZoneProcQuery->SetSQLModify("eqd_difmetzone_tbl",WList,NList,true,true,true);

   dgZoneProc->DataSource=dsZoneProcQuery;
   ((TDateTimeField*)ZZoneProcQuery->FieldByName("dt_b"))->DisplayFormat="dd.mm.yyyy";
   if (fReadOnly)dgZoneProc->ReadOnly=true;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpMeterDet::dgZoneProcEnter(TObject *Sender)
{
if(ZZoneProcQuery->RecordCount>0)
  sbDelZone2->Enabled=edit_enable;
}
//---------------------------------------------------------------------------
#define WinName "���� �����"
void __fastcall TfEqpMeterDet::sbAddZone2Click(TObject *Sender)
{
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
  QueryAdr->Sql->Add("select mz.kind_energy, en.name as enname, kz.id as id_zone, kz.name as znname, " );
  QueryAdr->Sql->Add("kz2.id as id_zonep, kz2.name as znnamep, " );
  QueryAdr->Sql->Add("(mz.kind_energy*10000+ kz.id*100 + kz2.id ) as ez" );
  QueryAdr->Sql->Add("from  eqk_energy_tbl AS en, eqk_zone_tbl as kz, " );
  QueryAdr->Sql->Add("eqd_meter_zone_tbl as mz, eqk_zone_tbl as kz2 " );
  QueryAdr->Sql->Add("where (en.id = mz.kind_energy) and mz.zone = kz.id ");
  QueryAdr->Sql->Add("and mz.code_eqp = :eqp order by mz.kind_energy, mz.zone, kz2.id ;");
  QueryAdr->ParamByName("eqp")->AsInteger=eqp_id;

  WZoneGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WZoneGrid->SetCaption(WinName);

  TWTQuery* Query = WZoneGrid->DBGrid->Query;

  Query->Open();
  WZoneGrid->DBGrid->SetReadOnly(true);
/*
  TStringList *WList=new TStringList();
  WList->Add("ez");

  TStringList *NList=new TStringList();
  NList->Add("znname");
  NList->Add("enname");

  Query->SetSQLModify("eqi_meter_energy_tbl",WList,NList,false,false,false);
  */
  TWTField *Field;

  Field = WZoneGrid->AddColumn("enname", "���� �������", "���� ����������� ������ ����� �������� �������");
  Field = WZoneGrid->AddColumn("znname", "���� ������� ��������", "���� ������� ��������");
  Field = WZoneGrid->AddColumn("znnamep", "���� �����������", "���� ����������� ��������");

  WZoneGrid->DBGrid->FieldSource = WZoneGrid->DBGrid->Query->GetTField("ez");

  WZoneGrid->DBGrid->StringDest = -1;

  WZoneGrid->DBGrid->OnAccept=ZoneAccept2;

  WZoneGrid->DBGrid->Visible = true;
  WZoneGrid->ShowAs("���������");
};
#undef WinName
//---------------------------------------------------------------------------

void __fastcall TfEqpMeterDet::sbGetControlDataClick(TObject *Sender)
{

   sqlstr=" select max(dt_control) as dt_control from ss_met where z_num = :num and met_type = :type;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("num")->AsString= ((TfEqpEdit*)(this->Parent->Parent))->edNum_eqp->Text;
   ZEqpQuery->ParamByName("type")->AsInteger=MeterId;


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

     if (!ZEqpQuery->FieldByName("dt_control")->IsNull)
     {
        edControlData->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("dt_control")->AsDateTime);
        IsModified=true;
     }
     else
        ShowMessage("��� ������ � ���� ������� ��� ������� ��������!");
   }
   else
      ShowMessage("��� ������ � ���� ������� ��� ������� ��������!");

   ZEqpQuery->Close();
}
//---------------------------------------------------------------------------

