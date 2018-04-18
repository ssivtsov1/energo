//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fDet.h"
#include "ftree.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfEqpDet *fEqpDet;
//---------------------------------------------------------------------------
__fastcall TfEqpDet::TfEqpDet(TComponent* Owner)
        : TForm(Owner)
{
 IsModified=false;
}
//---------------------------------------------------------------------------
 bool TfEqpDet::GetTableNames(TObject *Sender)
{
//   Получить имена таблиц
   sqlstr=" select syt1.name AS name_table, syt2.name AS name_table_ind \
 from (eqi_device_kinds_tbl AS dk LEFT OUTER JOIN syi_table_tbl AS syt1 ON (dk.id_table=syt1.id))\
 LEFT OUTER JOIN syi_table_tbl AS syt2 ON (dk.id_table_ind=syt2.id)\
 where (dk.id= :eqp_type);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   //ZEqpQuery->ParamByName("eqp_type")->AsInteger=fTreeForm->EqpEdit->EqpType;
   ZEqpQuery->ParamByName("eqp_type")->AsInteger=eqp_type;
   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return false;
   }
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
     name_table_ind=ZEqpQuery->FieldByName("name_table_ind")->AsString;
     name_table=ZEqpQuery->FieldByName("name_table")->AsString;
   };
   ZEqpQuery->Close();
   return true;

}
//---------------------------------------------------------------------------

/*void __fastcall TfEqpDet::edDataChange(TObject *Sender)
{
if (((TEdit*)Sender)->Modified) IsModified=true;
} */


