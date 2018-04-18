//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ins_doc.h"
#include "doc_tmp.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TInsForm *InsForm;
int last_num,id_ins;
//---------------------------------------------------------------------------
__fastcall TInsForm::TInsForm(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
id_doc=Module2DB->id_doc;
if (Doc_temp->Doc->Items->Count==0) id_parent=0;
else id_parent=Module2DB->id_elem;
kind=Module2DB->kind;
}
//---------------------------------------------------------------------------
void __fastcall TInsForm::FormClose(TObject *Sender,
      TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
//Doc_temp->Enabled=true;
Doc_temp->Refresh();
}
//---------------------------------------------------------------------------
void __fastcall TInsForm::SpeedButton1Click(TObject *Sender)
{
InsForm->Close();
}
//---------------------------------------------------------------------------
void __fastcall TInsForm::FormActivate(TObject *Sender)
{
List->Items->Clear();
 if (kind==1)//Вставляемый элемент - таблица
 {
  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select * from dcm_template_tbl where id_format=5");
  Module2DB->QueryExec->ExecSql();
  Module2DB->QueryExec->Active=true;
TListItem  *ListItem;
  for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
  {
   ListItem = List->Items->Add();
   ListItem->Caption = Module2DB->QueryExec->FieldByName("name")->AsString;
   ListItem->StateIndex = Module2DB->QueryExec->FieldByName("id")->AsInteger;
  Module2DB->QueryExec->Next();
  }
 }


  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select * from dcm_template_tbl where id_parent="+IntToStr(id_parent));
  Module2DB->QueryExec->ExecSql();
  Module2DB->QueryExec->Active=true;
TListItem  *ListItem;
  for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
  {
   ListItem = List->Items->Add();
   ListItem->Caption = Module2DB->QueryExec->FieldByName("name")->AsString;
   ListItem->StateIndex = Module2DB->QueryExec->FieldByName("id")->AsInteger;
  Module2DB->QueryExec->Next();
  }

 if (Module2DB->QueryExec->RecordCount==0) {RadioButton1->Checked=true;}
 else {RadioButton2->Checked=true;}
}
//---------------------------------------------------------------------------
void __fastcall TInsForm::SpeedButton2Click(TObject *Sender)
{
int f=0;
if (Edit1->Text=="") {ShowMessage("Укажите имя элемента в документе");f=1;}
if (id_ins==0&&f==0) {ShowMessage("Укажите таблицу для вставки");f=1;}
if (f==0)
{
   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("select ins_elem("+IntToStr(id_parent)+","+IntToStr(id_ins)+","+IntToStr(last_num)+",1,"+IntToStr(id_doc)+",'"+Edit1->Text+"')");
   Module2DB->QueryExec->ExecSql();
}
}
//---------------------------------------------------------------------------

void __fastcall TInsForm::RadioButton1Click(TObject *Sender)
{
last_num=0;
ListElem->Enabled=false;
}
//---------------------------------------------------------------------------
void __fastcall TInsForm::RadioButton2Click(TObject *Sender)
{
last_num=0;
ListElem->Enabled=true;
}
//---------------------------------------------------------------------------


void __fastcall TInsForm::ListElemChanging(TObject *Sender,
      TListItem *Item, TItemChange Change, bool &AllowChange)
{
last_num=Item->StateIndex;
}
//---------------------------------------------------------------------------
void __fastcall TInsForm::ListChanging(TObject *Sender, TListItem *Item,
      TItemChange Change, bool &AllowChange)
{
id_ins=Item->StateIndex;
}
//---------------------------------------------------------------------------

