//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "filnm.h"
#include "docu_mod.h"
#include "doc_tmp.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TSetFieldName *SetFieldName;
int id_document=0,id_temp=0;
int key_val=0;
//---------------------------------------------------------------------------
__fastcall TSetFieldName::TSetFieldName(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TSetFieldName::SpeedButton1Click(TObject *Sender)
{
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("select reg_doc("+IntToStr(id_document)+","+IntToStr(id_temp)+",'"+IntToStr(key_val)+"')");
         Module2DB->Query_doc->ExecSql();

         ShowMessage("Документ зарегистрирован");
         SetFieldName->Close();
}
//---------------------------------------------------------------------------
void __fastcall TSetFieldName::Refresh(int id_docum,int id)
{
id_document=id_docum;
id_temp=id;

ListView1->Items->Clear();

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("select name from dcm_template_tbl where id="+IntToStr(id));
   Module2DB->QueryExec->ExecSql();
   Module2DB->QueryExec->Active=true;

   Label2->Caption=Module2DB->QueryExec->FieldByName("name")->AsString;

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("select value from dci_template_tbl where id in (select id_elem from dcm_template_tbl where id="+IntToStr(id)+")");
   Module2DB->QueryExec->ExecSql();
   Module2DB->QueryExec->Active=true;

 AnsiString value=Module2DB->QueryExec->FieldByName("value")->AsString;
 AnsiString base,table,field,key;
 base=Doc_temp->Parse(value,1);
 table=Doc_temp->Parse(value,2);
 field=Doc_temp->Parse(value,3);
 key=Doc_temp->Parse(value,4);

   Module2DB->QueryExec->Sql->Clear();
  ShowMessage("select "+field+" from "+table);
   Module2DB->QueryExec->Sql->Add("select * from "+table);
   Module2DB->QueryExec->ExecSql();
   Module2DB->QueryExec->Active=true;

 Module2DB->Query_grp->First();
 TListItem  *ListItem;
  for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
  {
   ListItem = ListView1->Items->Add();
   ListItem->Caption = Module2DB->QueryExec->FieldByName(field)->AsString;
   ListItem->StateIndex = Module2DB->QueryExec->FieldByName("id")->AsInteger;

   Module2DB->QueryExec->Next();
  }//of for

}
//---------------------------------------------------------------------------
void __fastcall TSetFieldName::FormClose(TObject *Sender,
      TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

void __fastcall TSetFieldName::ListView1Change(TObject *Sender,
      TListItem *Item, TItemChange Change)
{
key_val=Item->StateIndex;
}
//---------------------------------------------------------------------------

