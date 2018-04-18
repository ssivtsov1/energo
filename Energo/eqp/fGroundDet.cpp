//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "fGroundDet.h"
#include "fEqpBase.h"
#include "ftree.h"
#include "Main.h"
#include "equipment.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfGroundDet *fGroundDet;
//AnsiString AddDataName;
AnsiString retvalue;

//---------------------------------------------------------------------------
__fastcall TfGroundDet::TfGroundDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  edit_enable = CheckLevel("Схема 2 - Параметры площадки")!=0 ;
}
//---------------------------------------------------------------------------
void __fastcall TfGroundDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfGroundDet::FormShow(TObject *Sender)
{
// Настройка формы

 if(eqp_type!=11)
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
     edPower->ReadOnly =!edit_enable;
     edWorkTime->Enabled =edit_enable;
   }


   sqlstr=" select *  from %name_table AS dt where dt.code_eqp= :code_eqp;";

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
     edWorkTime->Text=ZEqpQuery->FieldByName("wtm")->AsString;

   };
   ZEqpQuery->Close();
   IsModified=false;
}
//---------------------------------------------------------------------------

 bool TfGroundDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,power,wtm) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :power, :wtm );");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if (edPower->Text!="")
     ZEqpQuery->ParamByName("power")->AsFloat=StrToFloat(edPower->Text);

   if (edWorkTime->Text!="")
     ZEqpQuery->ParamByName("wtm")->AsFloat=StrToFloat(edWorkTime->Text);

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
 bool TfGroundDet::SaveData(void)
 {

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set ");
   ZEqpQuery->Sql->Add("power= :power,wtm= :wtm ");
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if (edPower->Text!="")
     ZEqpQuery->ParamByName("power")->AsFloat=StrToFloat(edPower->Text);

   if (edWorkTime->Text!="")
     ZEqpQuery->ParamByName("wtm")->AsFloat=StrToFloat(edWorkTime->Text);

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

void __fastcall TfGroundDet::edDataChange(TObject *Sender)
{
  if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------

bool TfGroundDet::CheckData(void)
{
 // if (edClassId->Text=="")
 //  {
 //    ShowMessage("Не указан уровень напряжения");
 //    return false;
 //  }
     return true;
}

void __fastcall TfGroundDet::btEquipmentClick(TObject *Sender)
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
void __fastcall TfGroundDet::EqpAccept (TObject* Sender)
{
 Application->CreateForm(__classid(TfTreeForm), &fTreeForm);
 fTreeForm->ShowAs("treeform");
 fTreeForm->ShowTrees(WEqpGrid->DBGrid->Query->FieldByName("id_client")->AsInteger,
                false,WEqpGrid->DBGrid->Query->FieldByName("id")->AsInteger);
 }
//--------------------------------------------------------------------

