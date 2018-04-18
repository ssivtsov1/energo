//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fEqpThePointDet.h"
#include "ftree.h"
#include "Main.h"
#include "fChange.h"
#include "SysUser.h"
#include "point_card.h"
#include "point_blank.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "fDet"
#pragma resource "*.dfm"
//TfEqpCompensDet *fEqpCompensDet;
AnsiString   retvalue;
TWTWinDBGrid *WEnergyGrid;
TWTWinDBGrid *WTgGrid;
TWTDBGrid    *WTarGrid;
TWTWinDBGrid *WZoneGrid;
TWTWinDBGrid *WVoltageGrid;
TWTDBGrid    *WKwedGrid;
TWTDBGrid    *WDepGrid;
TWTDBGrid    *WExtraGrid;
TWTDBGrid    *WPosGrid;
int Compensator;
int voltdest;
//---------------------------------------------------------------------------
__fastcall TfEqpPointDet::TfEqpPointDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  ZEnergyQuery = new TWTQuery(Application);
  ZEnergyQuery->Options.Clear();
  ZEnergyQuery->Options<< doQuickOpen;
  ZEnergyQuery->RequestLive=true;
  ZEnergyQuery->CachedUpdates=false;
  ZEnergyQuery->AfterInsert=CancelInsert;
  ZEnergyQuery->AfterDelete=CancelInsert;

  dsEnergyQuery=new TDataSource(Application);
  dsEnergyQuery->DataSet=ZEnergyQuery;

  usr_id=1;     //       !!!!!!!!!!!!!!
//  CangeLogEnabled=false;
  operation=0;

  edit_enable = CheckLevel("Схема 2 - Параметры точки учета")!=0 ;
  }
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
delete dsEnergyQuery;
delete ZEnergyQuery;

Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::FormShow(TObject *Sender)
{
// Настройка формы
 if(eqp_type!=12)
   {
     ShowMessage("Данный тип оборудования не поддерживается!");
     return;
    };

   // Получить имена таблиц
   GetTableNames(Sender);
   // Выбрать из полученной таблици данные

//   lTarifReq->Visible=!is_res;
   lPowerReq->Visible=!is_res;
//   lWtimeReq->Visible=!is_res;
//   lTgReq->Visible=!is_res;

   if (mode==0) return;
   else
   {
     edPower->ReadOnly =!edit_enable;
     edConnect->ReadOnly =!edit_enable;
     edTarifName->ReadOnly =!edit_enable;
     edWorkTime->ReadOnly =!edit_enable;
     edTgName->ReadOnly =!edit_enable;
     edClassId->ReadOnly =!edit_enable;
     edEkvivalent->ReadOnly =!edit_enable;
     dgEnergy->ReadOnly =!edit_enable;
     edCmp->ReadOnly =!edit_enable;
     edShare->ReadOnly =!edit_enable;
     edLdemand->ReadOnly =!edit_enable;
     edLdemandr->ReadOnly =!edit_enable;
     edLdemandg->ReadOnly =!edit_enable;
     edPdays->ReadOnly =!edit_enable;
     edItr_comment->ReadOnly =!edit_enable;
     edControlDay->ReadOnly =!edit_enable;

     sbTarifSel->Enabled =edit_enable;
     sbTgSel->Enabled =edit_enable;
     sbClassSel->Enabled =edit_enable;
     cbLost_Nolost->Enabled =edit_enable;
     cbCounLost->Enabled =edit_enable;
     cbMainLosts->Enabled =edit_enable;
     cbReserv->Enabled =edit_enable;
     cbInLost->Enabled =edit_enable;
     sbSelZone->Enabled =edit_enable;
     cbHlosts->Enabled =edit_enable;
     cbCount_itr->Enabled =edit_enable;
     sbUnSel->Enabled =edit_enable;
     sbDepart->Enabled =edit_enable;
     sbExtra->Enabled =edit_enable;
     spExtraClean->Enabled =edit_enable;
     sbSelIndustry->Enabled =edit_enable;
     cbDisabled->Enabled =edit_enable;

     EdPosition->ReadOnly =!edit_enable;
     sbPosition->Enabled =edit_enable;
     spPositionClear->Enabled =edit_enable;

   }


   sbAddEnergy->Enabled=edit_enable;
   dgEnergy->Enabled=true;

   sqlstr="select dt.power,dt.connect_power, dt.id_tarif, dt.industry,dt.count_lost, dt.in_lost,dt.d, dt.wtm,dt.share,dt.id_position,  \
   dt.id_tg, p.val as kwedname,p.kod as kwedcode,tr.name as tarifname , tg.name as tgname, \
   dt.id_voltage, dt.ldemand, dt.pdays, dt.count_itr, dt.itr_comment, dt.cmp, dt.day_control, v.voltage_min, v.voltage_max,  \
   dt.zone, z.name as zname, dt.flag_hlosts, dt.id_depart, cla.name as department,dt.main_losts, \
   dt.ldemandr,dt.ldemandg,dt.id_un, dt.lost_nolost, dt.id_extra,dt.reserv,cla2.name as extra,vun.voltage_min as un, cp.represent_name,  \
   dt.con_power_kva, dt.safe_category, dt.disabled  \
   from %name_table AS dt \
   left join aci_tarif_tbl as tr on (tr.id=dt.id_tarif) \
   left join cla_param_tbl as p on (dt.industry=p.id) \
   left join eqk_tg_tbl as tg on (dt.id_tg=tg.id) \
   left join  eqk_voltage_tbl AS v on (dt.id_voltage=v.id) \
   left join  eqk_voltage_tbl AS vun on (dt.id_un=vun.id) \
   left join  eqk_zone_tbl AS z on (dt.zone=z.id) \
   left join  cla_param_tbl AS cla on (dt.id_depart=cla.id) \
   left join  cla_param_tbl AS cla2 on (dt.id_extra=cla2.id) \
   left join  clm_position_tbl as cp on (cp.id = dt.id_position) \
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
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return;
   }
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
     edPower->Text=ZEqpQuery->FieldByName("power")->AsString;
     edConnect->Text=ZEqpQuery->FieldByName("connect_power")->AsString;
     edEkvivalent->Text=ZEqpQuery->FieldByName("d")->AsString;
     edWorkTime->Text=ZEqpQuery->FieldByName("wtm")->AsString;

     edTarifName->Text=ZEqpQuery->FieldByName("tarifname")->AsString;
     TarifId=ZEqpQuery->FieldByName("id_tarif")->AsInteger;

     edDepart->Text=ZEqpQuery->FieldByName("department")->AsString;
     DepartId=ZEqpQuery->FieldByName("id_depart")->AsInteger;

     edExtra->Text=ZEqpQuery->FieldByName("extra")->AsString;
     ExtraId=ZEqpQuery->FieldByName("id_extra")->AsInteger;


//     edIndustry->Text=ZEqpQuery->FieldByName("indname")->AsString;
     EdKwed->Text=ZEqpQuery->FieldByName("kwedcode")->AsString;
     LabKwed->Caption=ZEqpQuery->FieldByName("kwedname")->AsString;
     IndustryId=ZEqpQuery->FieldByName("industry")->AsInteger;
     edShare->Text=ZEqpQuery->FieldByName("share")->AsString;

     edTgName->Text=ZEqpQuery->FieldByName("tgname")->AsString;
     TgId=ZEqpQuery->FieldByName("id_tg")->AsInteger;

     edClassId->Text=ZEqpQuery->FieldByName("id_voltage")->AsString;
     if (ZEqpQuery->FieldByName("voltage_min")->AsInteger==ZEqpQuery->FieldByName("voltage_max")->AsInteger)
     {
      lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" кВ";
     }
     else
     {
      lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" - "+
      ZEqpQuery->FieldByName("voltage_max")->AsString +" кВ";
     }

     if (ZEqpQuery->FieldByName("count_lost")->AsInteger==1)
       cbCounLost->Checked=true;
     else
       cbCounLost->Checked=false;

     if (ZEqpQuery->FieldByName("in_lost")->AsInteger==1)
       cbInLost->Checked=true;
     else
       cbInLost->Checked=false;
     if (ZEqpQuery->FieldByName("reserv")->AsInteger==1)
       cbReserv->Checked=true;
     else
       cbReserv->Checked=false;

     if (ZEqpQuery->FieldByName("lost_nolost")->AsInteger==1)
       cbLost_Nolost->Checked=true;
     else
       cbLost_Nolost->Checked=false;


     if (ZEqpQuery->FieldByName("flag_hlosts")->AsInteger==1)
       cbHlosts->Checked=true;
     else
       cbHlosts->Checked=false;

     if (ZEqpQuery->FieldByName("con_power_kva")->AsInteger==1)
       cbKVA->Checked=true;
     else
       cbKVA->Checked=false;

     if (ZEqpQuery->FieldByName("disabled")->AsInteger==1)
       cbDisabled->Checked=true;
     else
       cbDisabled->Checked=false;

     edCmp->Text=ZEqpQuery->FieldByName("cmp")->AsString;

     edLdemand->Text=ZEqpQuery->FieldByName("ldemand")->AsString;
     edLdemandr->Text=ZEqpQuery->FieldByName("ldemandr")->AsString;
     edLdemandg->Text=ZEqpQuery->FieldByName("ldemandg")->AsString;

     edPdays->Text=ZEqpQuery->FieldByName("pdays")->AsString;

     if (ZEqpQuery->FieldByName("count_itr")->AsInteger==1)
       cbCount_itr->Checked=true;
     else
       cbCount_itr->Checked=false;

     if (ZEqpQuery->FieldByName("main_losts")->AsInteger==1)
       cbMainLosts->Checked=true;
     else
       cbMainLosts->Checked=false;

     edItr_comment->Text=ZEqpQuery->FieldByName("itr_comment")->AsString;

     ZoneId=ZEqpQuery->FieldByName("zone")->AsInteger;
     edZone->Text=ZEqpQuery->FieldByName("zname")->AsString;

     edUn->Text=ZEqpQuery->FieldByName("id_un")->AsString;
     lUnName->Caption=ZEqpQuery->FieldByName("un")->AsString+" кВ";

     edControlDay->Text=ZEqpQuery->FieldByName("day_control")->AsString;

     id_position = ZEqpQuery->FieldByName("id_position")->AsInteger;
     EdPosition->Text=ZEqpQuery->FieldByName("represent_name")->AsString;

     edSafeCategory->Text=ZEqpQuery->FieldByName("safe_category")->AsString;


   };
   ZEqpQuery->Close();

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("select flag_hlosts from clm_statecl_tbl where id_client = :client");
   ZEqpQuery->ParamByName("client")->AsInteger=abonent_id;

   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return;
   }
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
     if (ZEqpQuery->FieldByName("flag_hlosts")->AsInteger==1)
       cbHlosts->Enabled=true;
     else
       cbHlosts->Enabled=false;

   };
   ZEqpQuery->Close();


   IsModified=false;
   ShowEnergyGrid();


}
//---------------------------------------------------------------------------
 bool TfEqpPointDet::SaveData(void)
 {
   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set power = :power, connect_power=:connect_power, industry= :industry, id_tarif = :id_tarif,  count_lost= :count_lost, in_lost= :inlost," );
   ZEqpQuery->Sql->Add("d = :d, wtm= :wtm, id_tg = :id_tg , id_voltage= :id_voltage, share = :share, zone = :zone, id_depart = :id_depart, " );
   ZEqpQuery->Sql->Add(" ldemand = :ldemand, pdays= :pdays, count_itr= :count_itr, itr_comment= :itr_comment, ");
   ZEqpQuery->Sql->Add(" cmp = :cmp, flag_hlosts = :flag_hlosts , main_losts = :main_losts, ldemandr = :ldemandr, ldemandg = :ldemandg, id_un = :id_un , \
    reserv=:reserv, lost_nolost  = :lost_nolost, id_extra = :id_extra, day_control = :day_control, id_position = :id_position, con_power_kva = :con_power_kva, safe_category = :safe_category, disabled = :disabled  " );
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if (edEkvivalent->Text!="")
     ZEqpQuery->ParamByName("d")->AsFloat=StrToFloat(edEkvivalent->Text);
   if (edPower->Text!="")
     ZEqpQuery->ParamByName("power")->AsFloat=StrToFloat(edPower->Text);
    if (edConnect->Text!="")
     ZEqpQuery->ParamByName("connect_power")->AsFloat=StrToFloat(edConnect->Text);
   if (edWorkTime->Text!="")
     ZEqpQuery->ParamByName("wtm")->AsFloat=StrToFloat(edWorkTime->Text);

   if (TarifId!=0)
     ZEqpQuery->ParamByName("id_tarif")->AsInteger=TarifId;
   if (IndustryId!=0)
     ZEqpQuery->ParamByName("industry")->AsInteger=IndustryId;
   if (TgId!=0)
     ZEqpQuery->ParamByName("id_tg")->AsInteger=TgId;
   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

   if (ExtraId!=0)
     ZEqpQuery->ParamByName("id_extra")->AsInteger=ExtraId;

   if (edUn->Text!="")
    ZEqpQuery->ParamByName("id_un")->AsInteger=StrToInt(edUn->Text);

   if (edShare->Text!="")
     ZEqpQuery->ParamByName("share")->AsFloat=StrToFloat(edShare->Text);

   ZEqpQuery->ParamByName("count_lost")->AsInteger=cbCounLost->Checked?1:0;
      ZEqpQuery->ParamByName("inlost")->AsInteger=cbInLost->Checked?1:0;

   ZEqpQuery->ParamByName("lost_nolost")->AsInteger=cbLost_Nolost->Checked?1:0;

   ZEqpQuery->ParamByName("count_itr")->AsInteger=cbCount_itr->Checked?1:0;

   ZEqpQuery->ParamByName("flag_hlosts")->AsInteger=cbHlosts->Checked?1:0;

   ZEqpQuery->ParamByName("main_losts")->AsInteger=cbMainLosts->Checked?1:0;
   ZEqpQuery->ParamByName("reserv")->AsInteger=cbReserv->Checked?1:0;
   ZEqpQuery->ParamByName("con_power_kva")->AsInteger=cbKVA->Checked?1:0;

   ZEqpQuery->ParamByName("disabled")->AsInteger=cbDisabled->Checked?1:0;

   if (edCmp->Text!="")
     ZEqpQuery->ParamByName("cmp")->AsFloat=StrToFloat(edCmp->Text);
   if (edLdemand->Text!="")
     ZEqpQuery->ParamByName("ldemand")->AsFloat=StrToFloat(edLdemand->Text);

   if (edLdemandr->Text!="")
     ZEqpQuery->ParamByName("ldemandr")->AsFloat=StrToFloat(edLdemandr->Text);
   if (edLdemandg->Text!="")
     ZEqpQuery->ParamByName("ldemandg")->AsFloat=StrToFloat(edLdemandg->Text);

   if (edPdays->Text!="")
    ZEqpQuery->ParamByName("pdays")->AsInteger=StrToInt(edPdays->Text);

   if (edItr_comment->Text!="")
    ZEqpQuery->ParamByName("itr_comment")->AsString=edItr_comment->Text;

   ZEqpQuery->ParamByName("zone")->AsInteger=ZoneId;

   if (DepartId!=0)
     ZEqpQuery->ParamByName("id_depart")->AsInteger=DepartId;

   if (edControlDay->Text!="")
    ZEqpQuery->ParamByName("day_control")->AsInteger=StrToInt(edControlDay->Text);

   if (id_position!=0 )
     ZEqpQuery->ParamByName("id_position")->AsInteger=id_position;

   if (edSafeCategory->Text!="")
    ZEqpQuery->ParamByName("safe_category")->AsInteger=StrToInt(edSafeCategory->Text);


   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
    return false;
   }

  if(dgEnergy->Enabled==false)
  {
   sbAddEnergy->Enabled=edit_enable;
   sbDelEnergy->Enabled=edit_enable;

   dgEnergy->Enabled=true;
   ZEnergyQuery->Open();
  }
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
  bool TfEqpPointDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,power,connect_power,id_tarif,industry,count_lost,in_lost,d,wtm, \
    id_tg,id_voltage,share,ldemand,pdays,count_itr,itr_comment,cmp,zone, flag_hlosts,id_depart,main_losts, \
     ldemandr,ldemandg, id_un, lost_nolost,id_extra,day_control,reserv,id_position,con_power_kva,safe_category, disabled) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :power, :connect_power,:id_tarif, :industry, :count_lost, :inlost,:d, :wtm,  \
    :id_tg, :id_voltage, :share, :ldemand, :pdays, :count_itr, :itr_comment, :cmp, :zone, :flag_hlosts, \
    :id_depart, :main_losts , :ldemandr, :ldemandg, :id_un, :lost_nolost, :id_extra, :day_control,:reserv, :id_position, :con_power_kva, :safe_category, :disabled );");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if (edEkvivalent->Text!="")
     ZEqpQuery->ParamByName("d")->AsFloat=StrToFloat(edEkvivalent->Text);
   if (edPower->Text!="")
     ZEqpQuery->ParamByName("power")->AsFloat=StrToFloat(edPower->Text);
        if (edConnect->Text!="")
     ZEqpQuery->ParamByName("connect_power")->AsFloat=StrToFloat(edConnect->Text);
   if (edWorkTime->Text!="")
     ZEqpQuery->ParamByName("wtm")->AsFloat=StrToFloat(edWorkTime->Text);

   if (TarifId!=0)
     ZEqpQuery->ParamByName("id_tarif")->AsInteger=TarifId;
   if (IndustryId!=0)
     ZEqpQuery->ParamByName("industry")->AsInteger=IndustryId;
   if (TgId!=0)
     ZEqpQuery->ParamByName("id_tg")->AsInteger=TgId;
   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

   if (ExtraId!=0)
     ZEqpQuery->ParamByName("id_extra")->AsInteger=ExtraId;

   if (edUn->Text!="")
    ZEqpQuery->ParamByName("id_un")->AsInteger=StrToInt(edUn->Text);

   if (edShare->Text!="")
     ZEqpQuery->ParamByName("share")->AsFloat=StrToFloat(edShare->Text);

   ZEqpQuery->ParamByName("count_lost")->AsInteger=cbCounLost->Checked?1:0;
   ZEqpQuery->ParamByName("inlost")->AsInteger=cbInLost->Checked?1:0;
   ZEqpQuery->ParamByName("lost_nolost")->AsInteger=cbLost_Nolost->Checked?1:0;

   ZEqpQuery->ParamByName("count_itr")->AsInteger=cbCount_itr->Checked?1:0;

   ZEqpQuery->ParamByName("flag_hlosts")->AsInteger=cbHlosts->Checked?1:0;

   ZEqpQuery->ParamByName("main_losts")->AsInteger=cbMainLosts->Checked?1:0;
   ZEqpQuery->ParamByName("reserv")->AsInteger=cbReserv->Checked?1:0;

   ZEqpQuery->ParamByName("con_power_kva")->AsInteger=cbKVA->Checked?1:0;
   ZEqpQuery->ParamByName("disabled")->AsInteger=cbDisabled->Checked?1:0;

   if (edCmp->Text!="")
     ZEqpQuery->ParamByName("cmp")->AsFloat=StrToFloat(edCmp->Text);
   if (edLdemand->Text!="")
     ZEqpQuery->ParamByName("ldemand")->AsFloat=StrToFloat(edLdemand->Text);
   if (edLdemandr->Text!="")
     ZEqpQuery->ParamByName("ldemandr")->AsFloat=StrToFloat(edLdemandr->Text);
   if (edLdemandg->Text!="")
     ZEqpQuery->ParamByName("ldemandg")->AsFloat=StrToFloat(edLdemandg->Text);

   if (edPdays->Text!="")
    ZEqpQuery->ParamByName("pdays")->AsInteger=StrToInt(edPdays->Text);

   if (edItr_comment->Text!="")
    ZEqpQuery->ParamByName("itr_comment")->AsString=edItr_comment->Text;

   ZEqpQuery->ParamByName("zone")->AsInteger=ZoneId;

   if (DepartId!=0)
     ZEqpQuery->ParamByName("id_depart")->AsInteger=DepartId;

   if (edControlDay->Text!="")
    ZEqpQuery->ParamByName("day_control")->AsInteger=StrToInt(edControlDay->Text);

   if (edSafeCategory->Text!="")
    ZEqpQuery->ParamByName("safe_category")->AsInteger=StrToInt(edSafeCategory->Text);

   if (id_position!=0 )
     ZEqpQuery->ParamByName("id_position")->AsInteger=id_position;

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL ");
    ZEqpQuery->Close();
    return false;
   }

   sbAddEnergy->Enabled=edit_enable;
   sbDelEnergy->Enabled=edit_enable;
   dgEnergy->Enabled=true;

   ShowEnergyGrid();

   IsModified=false;
   return true;
 }
//---------------------------------------------------------------------------
#define WinName "Виды энергии"
void _fastcall TfEqpPointDet::ShowEnergy(AnsiString retvalue) {

  // Определяем владельца
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // Если такое окно есть - активизируем и выходим
  if (MainForm->ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select en.id, en.name from eqk_energy_tbl AS en ;" );

  WEnergyGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WEnergyGrid->SetCaption(WinName);

  TWTQuery* Query = WEnergyGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");
//  WList->Add("id_type_eqp");

  TStringList *NList=new TStringList();
  NList->Add("name");

  Query->SetSQLModify("eqi_meter_energy_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WEnergyGrid->AddColumn("name", "Виды энергии", "Виды учитываемой данным видом счетчика энергии");

  WEnergyGrid->DBGrid->FieldSource = WEnergyGrid->DBGrid->Query->GetTField("id");

  WEnergyGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WEnergyGrid->DBGrid->OnAccept=EnergyAccept;
  WEnergyGrid->DBGrid->Visible = true;
//  WEnergyGrid->DBGrid->ReadOnly=true;
  WEnergyGrid->ShowAs("ВыборЭнергии");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::sbDelEnergyClick(TObject *Sender)
{
   if (fReadOnly) return;
   if (MessageDlg("Удалить тип энергии ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;

   //!!!!!!!!!!!!!!!!! Для протокола
   operation=MainForm->PrepareChange(ZEqpQuery,4,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)  return;


   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("delete from eqd_point_energy_tbl ");
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
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    //При ошибке отменяется транзакция и удалаются данные временной
    // таблици, занесенные пред. транзакцией
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

void __fastcall TfEqpPointDet::sbAddEnergyClick(TObject *Sender)
{
  if (fReadOnly) return;
  ShowEnergy("0");
}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::EnergyAccept (TObject* Sender)
{
   TLocateOptions Opts;
   Opts.Clear();
   if (ZEnergyQuery->Locate("kind_energy", Variant(WEnergyGrid->DBGrid->StringDest), Opts))
      return;

   //Спросим дату
   TDate EnergyDate;

   if (CangeLogEnabled)
    {
     TfChangeDate* fChangeDate;
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     fChangeDate->Label1->Caption="Дата установки";
     //fChangeDate->DateTime->Date=
     if (fChangeDate->ShowModal()!= mrOk)
     {
        delete fChangeDate;
        return ; // Отменить
     };
//     EnergyDate=fChangeDate->DateTime->Date;
     try
     {
      EnergyDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("Неверная дата");
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
   ZEqpQuery->Sql->Add("insert into eqd_point_energy_tbl(code_eqp,kind_energy,dt_instal) ");
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
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    return ;
   }
//   ZEqpQuery->Transaction->Commit();
   ZEnergyQuery->Refresh();
   sbDelEnergy->Enabled=edit_enable;

};
//---------------------------------------------------------------------------
void TfEqpPointDet::ShowEnergyGrid(void)
{

   ZEnergyQuery->Close();
   ZEnergyQuery->Sql->Clear();
   ZEnergyQuery->Sql->Add("select me.code_eqp,me.kind_energy, en.name, me.dt_instal from eqd_point_energy_tbl AS me, eqk_energy_tbl AS en ");
   ZEnergyQuery->Sql->Add("where (en.id = me.kind_energy) and (me.code_eqp= :eqp);");
   ZEnergyQuery->ParamByName("eqp")->AsInteger=eqp_id;

   try
   {
    ZEnergyQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL ");
    ZEnergyQuery->Close();
    return ;
   }

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("kind_energy");
   WList->Add("dt_instal");

   TStringList *NList=new TStringList();
   NList->Add("name");
   ZEnergyQuery->SetSQLModify("eqd_point_energy_tbl",WList,NList,true,true,true);

   dgEnergy->DataSource=dsEnergyQuery;
   ((TDateTimeField*)ZEnergyQuery->FieldByName("dt_instal"))->DisplayFormat="dd.mm.yyyy";
   if (fReadOnly)dgEnergy->ReadOnly=true;
}
//----------------------------------------------------------------------
void __fastcall TfEqpPointDet::CancelInsert(TDataSet* DataSet)
{
DataSet->Cancel();
}
//---------------------------------------------------------------------------
bool TfEqpPointDet::CheckData(void)
{

  if ((edPower->Text=="")&&(!is_res))
   {
     ShowMessage("Не указана разрешенная мощность");
     return false;
   }

  if ((edConnect->Text=="")&&(!is_res))
   {
     ShowMessage("Не указана присоединенная мощность");
     return false;
   }

  if ((TarifId==0)&&(!is_res))
   {
     ShowMessage("Не указана группа тарифов.");
     return false;
   }
/*
  if ((edWorkTime->Text=="")&&(!is_res))
   {
     ShowMessage("Не указано время работы");
     return false;
   }
*/   
/*
  if ((TgId==0)&&(!is_res))
   {
     ShowMessage("Не указан Tg f.");
     return false;
   }
*/
     return true;
}
//---------------------------------------------------------------------------


void __fastcall TfEqpPointDet::dgEnergyEnter(TObject *Sender)
{
if(ZEnergyQuery->RecordCount>0)
   sbDelEnergy->Enabled=edit_enable;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::edDataChange(TObject *Sender)
{
  if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::sbTarifSelClick(TObject *Sender)
{
   if (fReadOnly) return;

   TWTDBGrid* Grid;
   Grid=MainForm->AciTarifSel(NULL);
   if(Grid==NULL) return;
   else WTarGrid=Grid;

   WTarGrid->StringDest = "1";
   WTarGrid->OnAccept=TarAccept;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::TarAccept(TObject *Sender)
{
 TarifId= WTarGrid->Table->FieldByName("id")->AsInteger;
 edTarifName->Text=WTarGrid->Table->FieldByName("name")->AsString;
 IsModified=true;


 ZEqpQuery->Close();

 ZEqpQuery->Sql->Clear();
 ZEqpQuery->Sql->Add("select CASE WHEN gr.ident like 'tgr7_3%' THEN 1 ELSE 0 END as f1, \
                             CASE WHEN gr.ident like 'tgr8_3%' THEN 1 ELSE 0 END as f2 \
       from eqi_grouptarif_tbl as gr \
       join aci_tarif_tbl as t on (t.id_grouptarif = gr.id) \
       where t.id = :tar ;");

 ZEqpQuery->ParamByName("tar")->AsInteger=TarifId;

 try
 {
  ZEqpQuery->Open();
 }
 catch(...)
 {
  ShowMessage("Ошибка SQL :"+sqlstr);
  ZEqpQuery->Close();
  return;
 }
 if (ZEqpQuery->RecordCount!=0)
 {
   ZEqpQuery->First();

   if (ZEqpQuery->FieldByName("f1")->AsInteger==1)
   {
     if (ExtraId==0)
     {
       ShowMessage("Для выбранного тарифа необходимо указать \n 'Населення електроплити-мiсто' или 'Населення електроплити-село' \n в дополнительных параметрах точки учета!");
     }
   }

   if (ZEqpQuery->FieldByName("f2")->AsInteger==1)
   {
     if (ExtraId==0)
     {
       ShowMessage("Для выбранного тарифа необходимо указать \n 'Населенi пункти електроплити-мiсто' или 'Населенi пункти електроплити-село' \n в дополнительных параметрах точки учета!");
     }
   }

 };
 ZEqpQuery->Close();

}
//-------------------------------------------------------
void __fastcall TfEqpPointDet::sbSelIndustryClick(TObject *Sender)
{
 if (fReadOnly) return;
 /*
 Application->CreateForm(__classid(TfSelParam), &fSelParam);
 fSelParam->Caption="Отрасли экономики";
 fSelParam->ShowAs("Отрасли");
 fSelParam->MakeTree(10);
 fSelParam->Tree->OnDblClick=TreeDblClick;
 */
  AnsiString EmpS="  ";
   TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_kwed");
   if(Grid==NULL) return;
    else WKwedGrid=Grid;
   WKwedGrid->FieldSource= WKwedGrid->Table->GetTField("kod");
   if (!EdKwed->Text.IsEmpty())
    WKwedGrid->StringDest = EdKwed->Text;
   else
     WKwedGrid->StringDest = EmpS;
   WKwedGrid->OnAccept=KwedAccept;
}
//---------------------------------------------------------------------------
/*
void __fastcall TfEqpPointDet::TreeDblClick(TObject *Sender)
{
 IndustryId=fSelParam->CurrNode->StateIndex;
 edIndustry->Text=fSelParam->CurrNode->Text;
 fSelParam->Close();
 IsModified=true;
}
*/
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::KwedAccept (TObject* Sender)
{
     IndustryId=WKwedGrid->Table->FieldByName("id")->AsInteger;

     TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select kod,name,val from cla_param_tbl where id = :pid_kwed");
     QuerFld->ParamByName("pid_kwed")->AsInteger=IndustryId;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdKwed->Text=QuerFld->Fields->Fields[0]->AsString;
     LabKwed->Caption=QuerFld->Fields->Fields[2]->AsString;
     QuerFld->Close();
     delete QuerFld;
     IsModified=true;

 };

//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::cbCounLostClick(TObject *Sender)
{
 IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::sbTgSelClick(TObject *Sender)
{
 if (fReadOnly) return;

 TWTWinDBGrid* Grid;
 Grid=MainForm->EqkTgSpr("Выбор");
 if(Grid==NULL) return;
 else WTgGrid=Grid;
 WTgGrid->DBGrid->FieldSource = WTgGrid->DBGrid->Query->GetTField("id");
 WTgGrid->DBGrid->StringDest = TgId!=0?IntToStr(TgId):AnsiString("-1");
 WTgGrid->DBGrid->OnAccept=TgAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::TgAccept (TObject* Sender)
{
   TgId=StrToInt(WTgGrid->DBGrid->StringDest);

   edTgName->Text=WTgGrid->DBGrid->Query->FieldByName("name")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
#define WinName "Классы напряжения"
void _fastcall TfEqpPointDet::ShowVoltage(AnsiString retvalue) {

  // Определяем владельца
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // Если такое окно есть - активизируем и выходим
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

  Field = WVoltageGrid->AddColumn("id", "Класс", "Класс напражения");
  Field = WVoltageGrid->AddColumn("voltage_min", "U min", "Минимальное напряжение");
  Field = WVoltageGrid->AddColumn("voltage_max", "U max", "Максимальное напряжение");

  WVoltageGrid->DBGrid->FieldSource = WVoltageGrid->DBGrid->Query->GetTField("id");

  WVoltageGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WVoltageGrid->DBGrid->OnAccept=VoltageAccept;
  WVoltageGrid->DBGrid->Visible = true;
 // WVoltageGrid->DBGrid->ReadOnly=true;
  WVoltageGrid->ShowAs("ВыборКласса");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::VoltageAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+MeterGrid->DBGrid->StringDest);

  if (voltdest==1)
  {
   edClassId->Text=StrToInt(WVoltageGrid->DBGrid->StringDest);

   if (WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsInteger==WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsInteger)
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString +" кВ";
   }
   else
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" - "+
    WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsString +" кВ";
   }
  }

  if (voltdest==2)
  {
   edUn->Text=StrToInt(WVoltageGrid->DBGrid->StringDest);
   lUnName->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString +" кВ";
  }

  IsModified=true;
}
//----------------------------------------------------------

void __fastcall TfEqpPointDet::sbClassSelClick(TObject *Sender)
{
 if (fReadOnly) return;

 voltdest = 1;

 if (edClassId->Text=="")
  ShowVoltage("0");
 else
  ShowVoltage(edClassId->Text);

}
//---------------------------------------------------------------------------


void __fastcall TfEqpPointDet::sbSelZoneClick(TObject *Sender)
{
 if (fReadOnly) return;

  TWTWinDBGrid* Grid;
  Grid=MainForm->EqkZoneSel(NULL);
  if(Grid==NULL) return;
  else WZoneGrid=Grid;

  WZoneGrid->DBGrid->FieldSource = WZoneGrid->DBGrid->Table->GetTField("id");
  WZoneGrid->DBGrid->StringDest = -1;
  WZoneGrid->DBGrid->OnAccept=ZoneAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::ZoneAccept (TObject* Sender)
{
   ZoneId=StrToInt(WZoneGrid->DBGrid->StringDest);

   edZone->Text=WZoneGrid->DBGrid->Table->FieldByName("name")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::sbDepartClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_min");
   if(Grid==NULL) return;
   else WDepGrid=Grid;

   WDepGrid->FieldSource= WDepGrid->Table->GetTField("id");
   WDepGrid->StringDest = -1;

   WDepGrid->OnAccept=DepAccept;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::DepAccept (TObject* Sender)
{
    DepartId=WDepGrid->Table->FieldByName("id")->AsInteger;
    edDepart->Text=WDepGrid->Table->FieldByName("name")->AsString;
    IsModified=true;
};
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::sbUnSelClick(TObject *Sender)
{
 if (fReadOnly) return;

 voltdest = 2;

 if (edUn->Text=="")
  ShowVoltage("0");
 else
  ShowVoltage(edUn->Text);

}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::sbExtraClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_extra");
   if(Grid==NULL) return;
    else WExtraGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WExtraGrid->FieldSource= WExtraGrid->Table->GetTField("name");

   if (!edExtra->Text.IsEmpty())
    WExtraGrid->StringDest = edExtra->Text;
   else
    WExtraGrid->StringDest = EmpS;

   WExtraGrid->OnAccept=ExtraAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::ExtraAccept(TObject* Sender)
{
    ExtraId=WExtraGrid->Table->FieldByName("id")->AsInteger;
    edExtra->Text=WExtraGrid->Table->FieldByName("name")->AsString;
 /*
     TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=ExtraId;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     edExtra->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
*/
};
//---------------------------------------------------------------------------
void __fastcall TfEqpPointDet::spExtraCleanClick(TObject *Sender)
{
    ExtraId=0;
    edExtra->Text="";
}
//---------------------------------------------------------------------------


void __fastcall TfEqpPointDet::spPositionClearClick(TObject *Sender)
{
    id_position=0;
    EdPosition->Text="";
    IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::sbPositionClick(TObject *Sender)
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
void __fastcall TfEqpPointDet::PosAccept (TObject* Sender)
{
     id_position=WPosGrid->Table->FieldByName("id")->AsInteger;
     EdPosition->Text=WPosGrid->Table->FieldByName("represent_name")->AsString;
     IsModified=true;
};
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::sbPassportClick(TObject *Sender)
{
  Application->CreateForm(__classid(TfPointCard), &fPointCard);
  fPointCard->id_client = abonent_id;
  fPointCard->AbonName = fTreeForm->abonent_name;
  fPointCard->ShowData(eqp_id);
}
//---------------------------------------------------------------------------

void __fastcall TfEqpPointDet::btAktMEMClick(TObject *Sender)
{
 fPointAct->PrintData(eqp_id);
}
//---------------------------------------------------------------------------


