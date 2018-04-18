//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "fEqpAirLineDet.h"
#include "fEqpBase.h"
#include "ftree.h"
#include "Main.h"
#include "equipment.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfALineDet *fALineDet;
//AnsiString AddDataName;
AnsiString retvalue;
TWTWinDBGrid *WCordeGrid;    
TWTWinDBGrid *WPillarGrid;
TWTWinDBGrid *WPendantGrid;
TWTWinDBGrid *WEarthGrid;
TWTWinDBGrid *WVoltageGrid;
#define WinName "Справочник проводов"
void _fastcall TfALineDet::ShowCorde(AnsiString retvalue) {

  TWTWinDBGrid* Grid;
  Grid=MainForm->EqiCordeSpr("ВыборПровода");
  if(Grid==NULL) return;
  else WCordeGrid=Grid;

  WCordeGrid->DBGrid->FieldSource = WCordeGrid->DBGrid->Query->GetTField("id");
  WCordeGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WCordeGrid->DBGrid->OnAccept=CordeAccept;

 // WCordeGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
 // WCordeGrid->ShowAs("ВыборПровода");

};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "Справочник опор"
void _fastcall TfALineDet::ShowPillar(AnsiString retvalue) {

  TWTWinDBGrid* Grid;
  Grid=MainForm->EqiPillarSpr("ВыборОпоры");
  if(Grid==NULL) return;
  else WPillarGrid=Grid;

  WPillarGrid->DBGrid->FieldSource = WPillarGrid->DBGrid->Query->GetTField("id");
  WPillarGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WPillarGrid->DBGrid->OnAccept=PillarAccept;
  //WPillarGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
 // WPillarGrid->ShowAs("ВыборОпоры");

};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "Справочник заземлений"
void _fastcall TfALineDet::ShowEarth(AnsiString retvalue) {

  TWTWinDBGrid* Grid;
  Grid=MainForm->EqiEarthSpr("ВыборЗаземления");
  if(Grid==NULL) return;
  else WEarthGrid=Grid;

  WEarthGrid->DBGrid->FieldSource = WEarthGrid->DBGrid->Query->GetTField("id");

  WEarthGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WEarthGrid->DBGrid->OnAccept=EarthAccept;
//  WEarthGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
//  WEarthGrid->ShowAs("ВыборЗаземления");
};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "Справочник расстояний подвески"
void _fastcall TfALineDet::ShowPendant(AnsiString retvalue) {

  TWTWinDBGrid* Grid;
  Grid=MainForm->EqiPendantSpr("ВыборПодвески");
  if(Grid==NULL) return;
  else WPendantGrid=Grid;

  WPendantGrid->DBGrid->FieldSource = WPendantGrid->DBGrid->Query->GetTField("id");
  WPendantGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WPendantGrid->DBGrid->OnAccept=PendantAccept;
 // WPendantGrid->DBGrid->Visible = true;
 /// WCordeGrid->DBGrid->ReadOnly=true;
 // WPendantGrid->ShowAs("ВыборПодвески");

};
#undef WinName
//---------------------------------------------------------------------------
__fastcall TfALineDet::TfALineDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  edit_enable = CheckLevel("Схема 2 - Параметры линий")!=0 ;
}
//---------------------------------------------------------------------------
void __fastcall TfALineDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfALineDet::FormShow(TObject *Sender)
{
// Настройка формы
// if(fTreeForm->EqpEdit->EqpType!=7)
 if(eqp_type!=7)
   {
     ShowMessage("Данный тип оборудования не поддерживается!");
     return;
    };

   // Получить имена таблиц
   GetTableNames(Sender);
   // Выбрать из полученной таблици данные

   if (mode==0) return;
   else
   {
     edCordeName->ReadOnly =!edit_enable;
     edLength->ReadOnly =!edit_enable;
     edClassId->ReadOnly =!edit_enable;
     bEqpTypeSel->Enabled =edit_enable;
     sbClassSel->Enabled =edit_enable;     
   }

   sqlstr=" select dt.id_type_eqp,dt.length,dt.pillar,dt.pillar_step,dt.pendant,dt.earth,dt.id_voltage, \
   cr.type AS cordename, pl.type AS pillarname, pd.type as pendantname,er.type AS earthname ,v.voltage_min, v.voltage_max \
   from eqi_corde_tbl AS cr, \
   ((%name_table AS dt left outer join eqi_pillar_tbl AS pl on (dt.pillar=pl.id)) \
   left outer join eqi_pendant_tbl AS pd on (dt.pendant=pd.id)) \
   left outer join eqi_earth_tbl  AS er on (dt.earth=er.id) \
   left join  eqk_voltage_tbl AS v on (dt.id_voltage=v.id) \
   where (dt.id_type_eqp=cr.id) and(dt.code_eqp= :code_eqp);";

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

     edCordeName->Text=ZEqpQuery->FieldByName("cordename")->AsString;
     CordeId=ZEqpQuery->FieldByName("id_type_eqp")->AsInteger;

     edPillarName->Text=ZEqpQuery->FieldByName("pillarname")->AsString;
     PillarId=ZEqpQuery->FieldByName("pillar")->AsInteger;

     edPendantName->Text=ZEqpQuery->FieldByName("pendantname")->AsString;
     PendantId=ZEqpQuery->FieldByName("pendant")->AsInteger;

     edEarthName->Text=ZEqpQuery->FieldByName("earthname")->AsString;
     EarthId=ZEqpQuery->FieldByName("earth")->AsInteger;

     edLength->Text=ZEqpQuery->FieldByName("length")->AsString;
     edStep->Text=ZEqpQuery->FieldByName("pillar_step")->AsString;

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

   };

   ZEqpQuery->Close();
   IsModified=false;

}
//---------------------------------------------------------------------------


void __fastcall TfALineDet::bEqpTypeSelClick(TObject *Sender)
{
if (fReadOnly) return;
//MainForm->EqiCordeSpr(CordeId);
ShowCorde(CordeId);
}
//---------------------------------------------------------------------------

void __fastcall TfALineDet::CordeAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+WGrid->DBGrid->StringDest);
   CordeId=StrToInt(WCordeGrid->DBGrid->StringDest);

   edCordeName->Text=WCordeGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;
/*
   sqlstr=" select type from %name_table_id where (id= :code_eqp);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->MacroByName("name_table_id")->AsString=name_table_ind;
   ZEqpQuery->ParamByName("code_eqp")->AsInteger=TypeId;
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
     edTypeName->Text=ZEqpQuery->FieldByName("type")->AsString;
   };
   ZEqpQuery->Close();
   */
}
//---------------------------------------------------------------------------
void __fastcall TfALineDet::PillarAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+WPillarGrid->DBGrid->StringDest);
   PillarId=StrToInt(WPillarGrid->DBGrid->StringDest);

   edPillarName->Text=WPillarGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------
void __fastcall TfALineDet::PendantAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+WPendantGrid->DBGrid->StringDest);
   PendantId=StrToInt(WPendantGrid->DBGrid->StringDest);

   edPendantName->Text=WPendantGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------
void __fastcall TfALineDet::EarthAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+WPendantGrid->DBGrid->StringDest);
   EarthId=StrToInt(WEarthGrid->DBGrid->StringDest);

   edEarthName->Text=WEarthGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------

 bool TfALineDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,id_type_eqp,length,pillar,pillar_step,pendant,earth,id_voltage) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :id_type_eqp, :length, :pillar, :pillar_step, :pendant, :earth, :id_voltage );");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_type_eqp")->AsInteger=CordeId;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
   if (PillarId!=0)
     ZEqpQuery->ParamByName("pillar")->AsInteger=PillarId;
   if (PendantId!=0)
     ZEqpQuery->ParamByName("pendant")->AsInteger=PendantId;
   if (EarthId!=0)
     ZEqpQuery->ParamByName("earth")->AsInteger=EarthId;

   if (edStep->Text!="")
     ZEqpQuery->ParamByName("pillar_step")->AsInteger=StrToInt(edStep->Text);
   if (edLength->Text!="")
     ZEqpQuery->ParamByName("length")->AsInteger=StrToInt(edLength->Text);

   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

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
 bool TfALineDet::SaveData(void)
 {

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set id_type_eqp = :id_type_eqp, ");
   ZEqpQuery->Sql->Add("length= :length,pillar= :pillar,pillar_step= :pillar_step,pendant= :pendant,earth= :earth ,id_voltage= :id_voltage ");
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_type_eqp")->AsInteger=CordeId;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
   if (PillarId!=0)
     ZEqpQuery->ParamByName("pillar")->AsInteger=PillarId;
   if (PendantId!=0)
     ZEqpQuery->ParamByName("pendant")->AsInteger=PendantId;
   if (EarthId!=0)
     ZEqpQuery->ParamByName("earth")->AsInteger=EarthId;

   if (edStep->Text!="")
     ZEqpQuery->ParamByName("pillar_step")->AsInteger=StrToInt(edStep->Text);
   if (edLength->Text!="")
     ZEqpQuery->ParamByName("length")->AsInteger=StrToInt(edLength->Text);
   if (edClassId->Text!="")
    ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);

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
  IsModified=false;
  return true;
 }

//---------------------------------------------------------------------------
void __fastcall TfALineDet::bPillarSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 ShowPillar(PillarId);
}
//---------------------------------------------------------------------------

void __fastcall TfALineDet::bPendantSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 ShowPendant(PendantId);
}
//---------------------------------------------------------------------------

void __fastcall TfALineDet::bEarthSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 ShowEarth(EarthId);
}
//---------------------------------------------------------------------------
bool TfALineDet::CheckData(void)
{
  if (edLength->Text=="")
   {
     ShowMessage("Не указана длина.");
     return false;
   }

  if (CordeId==0)
   {
     ShowMessage("Не указан тип провода.");
     return false;
   }

  if (edClassId->Text=="")
   {
     ShowMessage("Не указан уровень напряжения");
     return false;
   }
   
     return true;
}
//---------------------------------------------------------------------------
void __fastcall TfALineDet::edDataChange(TObject *Sender)
{
if (((TEdit*)Sender)->Modified) IsModified=true;        
}
//---------------------------------------------------------------------------

void __fastcall TfALineDet::sbClassSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 if (edClassId->Text=="")
  ShowVoltage("0");
 else
  ShowVoltage(edClassId->Text);
}
//---------------------------------------------------------------------------

#define WinName "Классы напряжения"
void _fastcall TfALineDet::ShowVoltage(AnsiString retvalue) {

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
void __fastcall TfALineDet::VoltageAccept (TObject* Sender)
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

