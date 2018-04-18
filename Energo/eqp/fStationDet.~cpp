//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "fStationDet.h"
#include "fEqpBase.h"
#include "ftree.h"
#include "Main.h"
#include "equipment.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfStationDet *fStationDet;
//AnsiString AddDataName;
AnsiString retvalue;
TWTWinDBGrid *WVoltageGrid;
TWTWinDBGrid *WGrid;
//---------------------------------------------------------------------------
__fastcall TfStationDet::TfStationDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  edit_enable = CheckLevel("Схема 2 - Параметры подстанции")!=0 ;
}
//---------------------------------------------------------------------------
void __fastcall TfStationDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Action = caFree;
}
//---------------------------------------------------------------------------
void _fastcall TfStationDet::ShowDict(int* comp_id, TEdit* comp_edit) {

  TWTWinDBGrid* Grid;

  Grid=MainForm->EqiCompSpr("ВыборТрансформаторы");

  if(Grid==NULL) return;
  else WGrid=Grid;

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");
  WGrid->DBGrid->StringDest = (*comp_id)!=0?AnsiString(*comp_id):AnsiString("-1");
  WGrid->DBGrid->OnAccept=CompAccept;
  current_id = comp_id;
  current_edit = comp_edit;


};
//---------------------------------------------------------------------------
void __fastcall TfStationDet::CompAccept (TObject* Sender)
{
   (*current_id)=StrToInt(WGrid->DBGrid->StringDest);
   current_edit->Text=WGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------


void __fastcall TfStationDet::FormShow(TObject *Sender)
{
// Настройка формы
// if(fTreeForm->EqpEdit->EqpType!=7)
 if(eqp_type!=8)
   {
     ShowMessage("Данный тип оборудования не поддерживается!");
     Close();
     return;
    };

   // Получить имена таблиц
   GetTableNames(Sender);
   // Выбрать из полученной таблици данные

   if (mode==0) return;
   else
   {
     edClassId->ReadOnly =!edit_enable;
     sbClassSel->Enabled =edit_enable;
   }


   sqlstr=" select dt.power,dt.comp_cnt,dt.id_type1,dt.id_type2,dt.id_type3,dt.id_type4, \
   c1.type as type1,c2.type as type2,c3.type as type3,c4.type as type4, p_regday, date_regday,\
   dt.id_voltage ,dt.abon_ps, v.voltage_min, v.voltage_max \
   from %name_table AS dt left join  eqk_voltage_tbl AS v on (dt.id_voltage=v.id) \
   left join eqi_compensator_tbl AS c1 on (c1.id = dt.id_type1) \
   left join eqi_compensator_tbl AS c2 on (c2.id = dt.id_type2) \
   left join eqi_compensator_tbl AS c3 on (c2.id = dt.id_type3) \
   left join eqi_compensator_tbl AS c4 on (c2.id = dt.id_type4) \
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

     //edH_boxes->Text=ZEqpQuery->FieldByName("H_boxes")->AsString;
     //edL_boxes->Text=ZEqpQuery->FieldByName("L_boxes")->AsString;
     //edH_points->Text=ZEqpQuery->FieldByName("H_points")->AsString;
     //edL_points->Text=ZEqpQuery->FieldByName("L_points")->AsString;

     edCount->Text=ZEqpQuery->FieldByName("comp_cnt")->AsString;
     edPower->Text=ZEqpQuery->FieldByName("power")->AsString;

     compTypeId1=ZEqpQuery->FieldByName("id_type1")->AsInteger;
     compTypeId2=ZEqpQuery->FieldByName("id_type2")->AsInteger;
     compTypeId3=ZEqpQuery->FieldByName("id_type3")->AsInteger;
     compTypeId4=ZEqpQuery->FieldByName("id_type4")->AsInteger;

     edTypeName1->Text=ZEqpQuery->FieldByName("type1")->AsString;
     edTypeName2->Text=ZEqpQuery->FieldByName("type2")->AsString;
     edTypeName3->Text=ZEqpQuery->FieldByName("type3")->AsString;
     edTypeName4->Text=ZEqpQuery->FieldByName("type4")->AsString;

//     if (!(ZEqpQuery->FieldByName("id_type1")->isNull))

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

     if (ZEqpQuery->FieldByName("abon_ps")->AsInteger==1)
     {
      cbAbonPS->Checked =true;
     }
     else
     {
      cbAbonPS->Checked =false;
     }

     edPregDay->Text=ZEqpQuery->FieldByName("p_regday")->AsString;

     if (!ZEqpQuery->FieldByName("date_regday")->IsNull)
        edPregDayData->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("date_regday")->AsDateTime);
     else edPregDayData->Text="  .  .    ";



   };
   ZEqpQuery->Close();
   IsModified=false;
}
//---------------------------------------------------------------------------

 bool TfStationDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,power,comp_cnt,id_type1,id_type2,id_type3,id_type4,id_voltage,abon_ps,p_regday,date_regday) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :power, :comp_cnt, :id_type1, :id_type2, :id_type3, :id_type4, :id_voltage, :abon_ps, :p_regday, :date_regday );");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
/*
   if (edH_boxes->Text!="")
    ZEqpQuery->ParamByName("H_boxes")->AsInteger=StrToInt(edH_boxes->Text);
   if (edL_boxes->Text!="")
    ZEqpQuery->ParamByName("L_boxes")->AsInteger=StrToInt(edL_boxes->Text);
   if (edH_points->Text!="")
    ZEqpQuery->ParamByName("H_points")->AsInteger=StrToInt(edH_points->Text);
   if (edL_points->Text!="")
    ZEqpQuery->ParamByName("L_points")->AsInteger=StrToInt(edL_points->Text);
*/
   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

   if(cbAbonPS->Checked)
    ZEqpQuery->ParamByName("abon_ps")->AsInteger=1;
   else
    ZEqpQuery->ParamByName("abon_ps")->AsInteger=0;

   if (edCount->Text!="")
    ZEqpQuery->ParamByName("comp_cnt")->AsInteger=StrToInt(edCount->Text);

   if (edPower->Text!="")
    ZEqpQuery->ParamByName("power")->AsFloat=StrToFloat(edPower->Text);

   if (compTypeId1!=0)
    ZEqpQuery->ParamByName("id_type1")->AsInteger=compTypeId1;
   else
    ZEqpQuery->ParamByName("id_type1")->Clear();

   if (compTypeId2!=0)
    ZEqpQuery->ParamByName("id_type2")->AsInteger=compTypeId2;
   else
    ZEqpQuery->ParamByName("id_type2")->Clear();

   if (compTypeId3!=0)
    ZEqpQuery->ParamByName("id_type3")->AsInteger=compTypeId3;
   else
    ZEqpQuery->ParamByName("id_type3")->Clear();

   if (compTypeId4!=0)
    ZEqpQuery->ParamByName("id_type4")->AsInteger=compTypeId4;
   else
    ZEqpQuery->ParamByName("id_type4")->Clear();

   if (edPregDay->Text!="")
    ZEqpQuery->ParamByName("p_regday")->AsFloat=StrToFloat(edPregDay->Text);

   if (edPregDayData->Text!="  .  .    ")
       ZEqpQuery->ParamByName("date_regday")->AsDateTime=StrToDate(edPregDayData->Text);
   else
       ZEqpQuery->ParamByName("date_regday")->Clear();


   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL");
    ZEqpQuery->Close();
    return false;
   }
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
 bool TfStationDet::SaveData(void)
 {

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set ");
   ZEqpQuery->Sql->Add("comp_cnt= :comp_cnt,power= :power,id_type1= :id_type1,id_type2= :id_type2, id_type3= :id_type3,id_type4= :id_type4, id_voltage = :id_voltage, abon_ps = :abon_ps, p_regday= :p_regday, date_regday = :date_regday ");
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
/*
   if (edH_boxes->Text!="")
    ZEqpQuery->ParamByName("H_boxes")->AsInteger=StrToInt(edH_boxes->Text);
   if (edL_boxes->Text!="")
    ZEqpQuery->ParamByName("L_boxes")->AsInteger=StrToInt(edL_boxes->Text);
   if (edH_points->Text!="")
    ZEqpQuery->ParamByName("H_points")->AsInteger=StrToInt(edH_points->Text);
   if (edL_points->Text!="")
    ZEqpQuery->ParamByName("L_points")->AsInteger=StrToInt(edL_points->Text);
*/
   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

   if(cbAbonPS->Checked)
    ZEqpQuery->ParamByName("abon_ps")->AsInteger=1;
   else
    ZEqpQuery->ParamByName("abon_ps")->AsInteger=0;


   if (edCount->Text!="")
    ZEqpQuery->ParamByName("comp_cnt")->AsInteger=StrToInt(edCount->Text);

   if (edPower->Text!="")
    ZEqpQuery->ParamByName("power")->AsFloat=StrToFloat(edPower->Text);

   if (compTypeId1!=0)
    ZEqpQuery->ParamByName("id_type1")->AsInteger=compTypeId1;
   else
    ZEqpQuery->ParamByName("id_type1")->Clear();

   if (compTypeId2!=0)
    ZEqpQuery->ParamByName("id_type2")->AsInteger=compTypeId2;
   else
    ZEqpQuery->ParamByName("id_type2")->Clear();

   if (compTypeId3!=0)
    ZEqpQuery->ParamByName("id_type3")->AsInteger=compTypeId3;
   else
    ZEqpQuery->ParamByName("id_type3")->Clear();

   if (compTypeId4!=0)
    ZEqpQuery->ParamByName("id_type4")->AsInteger=compTypeId4;
   else
    ZEqpQuery->ParamByName("id_type4")->Clear();

   if (edPregDay->Text!="")
    ZEqpQuery->ParamByName("p_regday")->AsFloat=StrToFloat(edPregDay->Text);

   if (edPregDayData->Text!="  .  .    ")
       ZEqpQuery->ParamByName("date_regday")->AsDateTime=StrToDate(edPregDayData->Text);
   else
       ZEqpQuery->ParamByName("date_regday")->Clear();

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
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------


void __fastcall TfStationDet::edPregDayDataChange(TObject *Sender)
{
  if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::sbClassSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 if (edClassId->Text=="")
  ShowVoltage("0");
 else
  ShowVoltage(edClassId->Text);

}
//---------------------------------------------------------------------------
#define WinName "Классы напряжения"
void _fastcall TfStationDet::ShowVoltage(AnsiString retvalue) {

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
void __fastcall TfStationDet::VoltageAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+MeterGrid->DBGrid->StringDest);
   edClassId->Text=StrToInt(WVoltageGrid->DBGrid->StringDest);

   if (WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsInteger==WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsInteger)
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" кВ";
   }
   else
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" - "+
    WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsString +" кВ";
   }
   IsModified=true;
}
//----------------------------------------------------------

bool TfStationDet::CheckData(void)
{
  if (edClassId->Text=="")
   {
     ShowMessage("Не указан уровень напряжения");
     return false;
   }
     return true;
}

//---------------------------------------------------------------------------
void __fastcall TfStationDet::bEqpTypeSel1Click(TObject *Sender)
{
 if (fReadOnly) return;
 ShowDict(&compTypeId1,edTypeName1);
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeSel2Click(TObject *Sender)
{
 if (fReadOnly) return;
 ShowDict(&compTypeId2,edTypeName2);
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeSel3Click(TObject *Sender)
{
 if (fReadOnly) return;
 ShowDict(&compTypeId3,edTypeName3);
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeSel4Click(TObject *Sender)
{
 if (fReadOnly) return;
 ShowDict(&compTypeId4,edTypeName4);
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeClear1Click(TObject *Sender)
{
 compTypeId1 = 0;
 edTypeName1->Text = "";
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeClear2Click(TObject *Sender)
{
 compTypeId2 = 0;
 edTypeName2->Text = "";
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeClear3Click(TObject *Sender)
{
 compTypeId3 = 0;
 edTypeName3->Text = "";
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::bEqpTypeClear4Click(TObject *Sender)
{
 compTypeId4 = 0;
 edTypeName4->Text = "";
}
//---------------------------------------------------------------------------

void __fastcall TfStationDet::btEquipmentClick(TObject *Sender)
{
   TWTQuery *QueryEqp;

   QueryEqp = new  TWTQuery(this);
   QueryEqp->Options<< doQuickOpen;
   QueryEqp->Sql->Clear();

   QueryEqp->Sql->Add("  select c.id as id_client, c.code, c.short_name, eq.id, eq.name_eqp \
    from eqm_tree_tbl as tr \
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
    join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) \
    join eqm_compens_station_inst_tbl as si on (eq.id = si.code_eqp) \
    left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id) \
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client)) \
    where si.code_eqp_inst = :id order by c.code, eq.name_eqp;  ");


   QueryEqp->ParamByName("id")->AsInteger = eqp_id;

   WEqpGrid = new TWTWinDBGrid(this, QueryEqp,false);
   WEqpGrid->SetCaption("Оборудование подстанций");

   TWTQuery* Query = WEqpGrid->DBGrid->Query;

   Query->Open();

  TStringList *WList=new TStringList();
 // WList->Add("id");
  TStringList *NList=new TStringList();
 // NList->Add("id");

 // QueryEqp->SetSQLModify("bal_fider_errors_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WEqpGrid->AddColumn("code", "Код", "Код");
  Field->SetWidth(60);
  Field->SetReadOnly();

  Field = WEqpGrid->AddColumn("short_name", "Абонент", "Абонент");
  Field->SetWidth(250);
  Field->SetReadOnly();

  Field = WEqpGrid->AddColumn("name_eqp", "Оборудование", "Оборудование");
  Field->SetWidth(150);
  Field->SetReadOnly();

  WEqpGrid->DBGrid->Visible = true;
  WEqpGrid->DBGrid->ReadOnly=true;


  WEqpGrid->DBGrid->OnAccept=EqpAccept;

  WEqpGrid->ShowAs("StEqp");

}
//---------------------------------------------------------------------------
void __fastcall TfStationDet::EqpAccept (TObject* Sender)
{
 Application->CreateForm(__classid(TfTreeForm), &fTreeForm);
 fTreeForm->ShowAs("treeform");
 fTreeForm->ShowTrees(WEqpGrid->DBGrid->Query->FieldByName("id_client")->AsInteger,
                false,WEqpGrid->DBGrid->Query->FieldByName("id")->AsInteger);
 }
//--------------------------------------------------------------------

