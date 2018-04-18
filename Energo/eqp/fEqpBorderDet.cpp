//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "fEqpBorderDet.h"
#include "fEqpBase.h"
#include "ftree.h"
#include "CliSald.h"
#include "Main.h"
#include "equipment.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfALineDet *fALineDet;
//AnsiString AddDataName;
AnsiString retvalue;
TWTDBGrid *WDocGrid;
//---------------------------------------------------------------------------
__fastcall TfBorderDet::TfBorderDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
  edit_enable = CheckLevel("Схема 2 - Параметры границы раздела")!=0 ;
}
//---------------------------------------------------------------------------
void __fastcall TfBorderDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfBorderDet::FormShow(TObject *Sender)
{
// Настройка формы
// if(fTreeForm->EqpEdit->EqpType!=7)
 if(eqp_type!=9)
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
     mInf->ReadOnly =!edit_enable;
     bDocSel->Enabled =edit_enable;
   }


   sqlstr=" select dt.id_clientA,dt.id_clientB,dt.inf,id_doc,cl1.short_name as nameA,cl2.short_name as nameB\
   from %name_table AS dt, clm_client_tbl as cl1, clm_client_tbl as cl2 \
   where (dt.code_eqp= :code_eqp) and (cl1.id = dt.id_clientA)and (cl2.id = dt.id_clientB);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
//   ZEqpQuery->ParamByName("name_table")->AsString=name_table;
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
     edClientA->Text=ZEqpQuery->FieldByName("nameA")->AsString;
     ClientAId=ZEqpQuery->FieldByName("id_clientA")->AsInteger;

     edClientB->Text=ZEqpQuery->FieldByName("nameB")->AsString;
     ClientBId=ZEqpQuery->FieldByName("id_clientB")->AsInteger;
     DocId=ZEqpQuery->FieldByName("id_doc")->AsInteger;
     mInf->Text=ZEqpQuery->FieldByName("inf")->AsString;
     TWTQuery *qdoc=new TWTQuery(this);
     qdoc->Sql->Add("select * from clm_docconnect_tbl where id=:pid_doc");
     qdoc->ParamByName("pid_doc")->AsInteger=DocId;
     qdoc->Open();
     if (qdoc->RecordCount!=0)
     { edDoc->Text=qdoc->FieldByName("name")->AsString;
     }
     IsModified=false;
   };
   ZEqpQuery->Close();

}
//---------------------------------------------------------------------------
 bool TfBorderDet::SaveNewData(int id)
 {
   eqp_id=id;
    if (DocId>0)
  {

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,id_clientA,id_clientB,inf,id_doc) ");
   ZEqpQuery->Sql->Add("values ( :code_eqp, :id_clientA, :id_clientB, :inf,:id_doc);");

   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
//   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_clientA")->AsInteger=ClientAId;
   ZEqpQuery->ParamByName("id_clientB")->AsInteger=ClientBId;
     ZEqpQuery->ParamByName("id_doc")->AsInteger=DocId;
   ZEqpQuery->ParamByName("inf")->AsString=mInf->Text;

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
  else
  { ShowMessage("Введите документ основание подключения!");

  };
 }
//---------------------------------------------------------------------------
 bool TfBorderDet::SaveData(void)
 {
    ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set id_clientA = :id_clientA, ");
   ZEqpQuery->Sql->Add("id_clientB= :id_clientB,inf= :inf ,id_doc= :id_doc");
   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_clientA")->AsInteger=ClientAId;
   ZEqpQuery->ParamByName("id_clientB")->AsInteger=ClientBId;
   ZEqpQuery->ParamByName("inf")->AsString=mInf->Text;
        ZEqpQuery->ParamByName("id_doc")->AsInteger=DocId;

   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

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










void __fastcall TfBorderDet::edClientAChange(TObject *Sender)
{
/*try
{
 ClientAId=StrToInt(edClientA->Text);
}
catch(...) {};  */
}
//---------------------------------------------------------------------------

void __fastcall TfBorderDet::edClientBChange(TObject *Sender)
{
/*try
{
ClientBId=StrToInt(edClientB->Text);
}
catch(...) {};*/

}
//---------------------------------------------------------------------------

void __fastcall TfBorderDet::edDataChange(TObject *Sender)
{
 if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------



void __fastcall TfBorderDet::sbCliDocClick(TObject *Sender)
{
   if (fReadOnly) return;

   //TfCliCDocs* Grid;
   TWTQuery *qcl=new TWTQuery(this);
   qcl->Sql->Add("select * from clm_client_tbl where id=:pid_client");
   qcl->ParamByName("pid_client")->AsInteger=ClientBId;
   qcl->Open();
   Grid=new TfCliCDocs(NULL,qcl,qcl->FieldByName("id")->AsInteger );
   if(Grid==NULL) return;
   else WDocGrid=Grid->DBGrSald;

   WDocGrid->StringDest = edDoc->Text;
   WDocGrid->OnAccept=DocAccept;
}
//---------------------------------------------------------------------------

void __fastcall TfBorderDet::DocAccept(TObject *Sender)
{
 DocId= WDocGrid->Query->FieldByName("id")->AsInteger;
 edDoc->Text=WDocGrid->Query->FieldByName("name")->AsString;
 IsModified=true;
 Grid->Close();
}


bool TfBorderDet::CheckData(void)
{
  if (edDoc->Text=="")
   {
     ShowMessage("Не указан документ на подключение");
     return false;
   }
     return true;
}
