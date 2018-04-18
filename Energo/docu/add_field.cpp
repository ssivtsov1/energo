//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "add_field.h"
#include "docu_mod.h"
#include "doc_tmp.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TAddField *AddField;
AnsiString base,table,field;
int id_f,id_head=0;
//---------------------------------------------------------------------------
__fastcall TAddField::TAddField(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TAddField::FormActivate(TObject *Sender)
{
ListField->Items->Clear();

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select id_field from syi_using_tbl where id=1");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
 {
//ShowMessage(Module2DB->QueryExec->FieldByName("id_field")->AsString);
Module2DB->Query_doc->Sql->Clear();
Module2DB->Query_doc->Sql->Add("select f.note, f.id from syi_field_tbl f, syi_using_tbl u where u.id_field=f.id and f.id="+Module2DB->QueryExec->FieldByName("id_field")->AsString);
Module2DB->Query_doc->ExecSql();
Module2DB->Query_doc->Active=true;

   TListItem  *ListItem;
   ListItem = ListField->Items->Add();
   ListItem->Caption = Module2DB->Query_doc->FieldByName("note")->AsString;
   ListItem->StateIndex = Module2DB->Query_doc->FieldByName("id")->AsInteger;

Module2DB->QueryExec->Next();
 }
}
//---------------------------------------------------------------------------
void __fastcall TAddField::FormClose(TObject *Sender, TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

void __fastcall TAddField::SpeedButton2Click(TObject *Sender)
{
AddField->Close();
}
//---------------------------------------------------------------------------

void __fastcall TAddField::ListFieldChange(TObject *Sender,
      TListItem *Item, TItemChange Change)
{
if (Item->StateIndex>0)
{

//ShowMessage(IntToStr(Item->StateIndex));
Module2DB->Query_doc->Sql->Clear();
Module2DB->Query_doc->Sql->Add("select f.name as field, t.name as table, b.name as base from syi_field_tbl f, syi_table_tbl t, syi_base_tbl b where b.id=t.id_base and t.id=f.id_table and f.id="+IntToStr(Item->StateIndex));
Module2DB->Query_doc->ExecSql();
Module2DB->Query_doc->Active=true;

id_f=Item->StateIndex;

base=Module2DB->Query_doc->FieldByName("base")->AsString;
table=Module2DB->Query_doc->FieldByName("table")->AsString;
field=Module2DB->Query_doc->FieldByName("field")->AsString;
}//if stateindex>0

}
//---------------------------------------------------------------------------

void __fastcall TAddField::SpeedButton1Click(TObject *Sender)
{
AnsiString head="";

if (id_head==0)
{head="null";}
else
{head=IntToStr(id_head);}

AnsiString string="";
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select f.name from syi_field_tbl f, syi_using_tbl u where u.id_key=f.id and u.id=1 and u.id_field="+IntToStr(id_f));
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

AnsiString key=Module2DB->QueryExec->FieldByName("name")->AsString;
string+=base+":"+table+":"+field+":"+key+":";

//ShowMessage(string);
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select create_field("+IntToStr(id_parent)+","+IntToStr(id_doc)+",9,"+IntToStr(num)+",'"+string+"','"+Edit1->Text+"',"+head+")");
Module2DB->QueryExec->ExecSql();

ShowMessage("Ёлемент создан");
Doc_temp->Refresh();
AddField->Close();

}
//---------------------------------------------------------------------------

void __fastcall TAddField::ComboChange(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dci_head_tbl where name='"+Combo->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

id_head=Module2DB->QueryExec->FieldByName("id")->AsInteger;
}
//---------------------------------------------------------------------------

