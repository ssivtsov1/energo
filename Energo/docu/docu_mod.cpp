//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "docu_mod.h"
#include "docu.h"
#include "doc_tmp.h"
#include "add_grp.h"
#include "ins_grp.h"
#include "prop.h"
#include "move.h"
#include "ins_doc.h"
#include "cr_elem.h"
#include "add_field.h"
#include "sql.h"
#include "main.h"
#include "str.h"
#include "client_main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma resource "*.dfm"
TModule2DB *Module2DB;

//---------------------------------------------------------------------------
__fastcall TModule2DB::TModule2DB(TComponent* Owner)
        : TDataModule(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TModule2DB::NotifyNotify(TObject *Sender, AnsiString Event)
{
ShowMessage("Update");
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::DataModuleCreate(TObject *Sender)
{
MainDB->Database=((TMainForm *)Application->MainForm)->InterDatabase->Database;
MainDB->Login=((TMainForm *)Application->MainForm)->InterDatabase->Login;
MainDB->Password=((TMainForm *)Application->MainForm)->InterDatabase->Password;
MainDB->Host=((TMainForm *)Application->MainForm)->InterDatabase->Host;
MainDB->Connected=true;
//Notify->Active=true;
//Notify->ListenTo("ff");
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N5Click(TObject *Sender)
{
Application->CreateForm(__classid(TDoc_temp), &Doc_temp);
if (kind_doc==1) {
try {
if (Module2DB->view==1)  {Doc_temp->SpeedButton2->Enabled=true;Doc_temp->SpeedButton3->Enabled=true;}
if (Module2DB->view==2)  {Doc_temp->SpeedButton2->Enabled=false;Doc_temp->SpeedButton3->Enabled=false;}
}
__except(1) {}

Doc_temp->id_grp=id_grp;//ссылка на шаблон
Doc_temp->id_doc=id_doc;//ссылка на шаблон
Doc_temp->id_document=id_document;//ссылка на конкретный документ
Doc_temp->kind_doc=1;
}
if (kind_doc==3) {
Doc_temp->Doc->Visible=false;
Doc_temp->id_doc=id_doc;
Doc_temp->kind_doc=3;
}

}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N1Click(TObject *Sender)
{
//Grp_add->Visible=true;
Application->CreateForm(__classid(TGrp_add), &Grp_add);
Grp_add->Width=258;
Grp_add->Height=108;
Grp_add->id_grp=id_grp;
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N2Click(TObject *Sender)
{
//Grp_ins->Visible=true;
Application->CreateForm(__classid(TGrp_ins), &Grp_ins);
Grp_ins->Width=259;
Grp_ins->Height=256;
Grp_ins->id_grp=id_grp;
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N3Click(TObject *Sender)
{
if ( Application->MessageBox("Вы уверены что хотите удалить элемент:", NULL, MB_OKCANCEL) != IDOK)
     {} // throw to abort if user selects cancel
else {

QueryExec->Sql->Clear();
QueryExec->Sql->Add("select del_grp("+IntToStr(Module2DB->id_grp)+")");
QueryExec->ExecSql();
ShowMessage("Группа удалена");
Main_doc->Refresh();
}

}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N7Click(TObject *Sender)
{
Application->CreateForm(__classid(TProperties), &Properties);
//Grp_add->Width=258;
//Grp_add->Height=108;
Properties->MainList=MainList;
Properties->id_elem=id_elem;
}
//---------------------------------------------------------------------------
void __fastcall TModule2DB::N8Click(TObject *Sender)
{
Application->CreateForm(__classid(TMv), &Mv);
Mv->Width=330;
Mv->Height=384;
Mv->id_grp=id_grp;
Mv->id_doc=id_doc;
}
//---------------------------------------------------------------------------


void __fastcall TModule2DB::N11Click(TObject *Sender)
{
kind=1;
Application->CreateForm(__classid(TInsForm), &InsForm);
//Grp_add->Width=258;
//Grp_add->Height=108;

}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N13Click(TObject *Sender)
{
Application->CreateForm(__classid(TCreateForm), &CreateForm);
QueryExec->Sql->Clear();
ShowMessage("select is_head("+IntToStr(id_elem)+");");
QueryExec->Sql->Add("select is_head("+IntToStr(id_elem)+");");
QueryExec->ExecSql();

QueryExec->Sql->Clear();
QueryExec->Sql->Add("select * from tmp where usrnm='osa'");
QueryExec->ExecSql();
QueryExec->Active=true;

   if (QueryExec->FieldByName("value")->AsString=="1")
   {
   CreateForm->Panel4->Visible=true;
   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("select * from dci_head_tbl");
   QueryExec->ExecSql();
   QueryExec->Active=true;

   CreateForm->ComboBox2->Clear();
   QueryExec->First();
   for (int i=0;i<QueryExec->RecordCount;i++) {
   CreateForm->ComboBox2->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
   QueryExec->Next();
   }

}
else
{CreateForm->Panel4->Visible=false;}

//Grp_add->Width=258;
//Grp_add->Height=108;
CreateForm->id_parent=Module2DB->id_elem;
CreateForm->id_doc=Module2DB->id_doc;
CreateForm->num=Module2DB->num_elem;
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N14Click(TObject *Sender)
{
Application->CreateForm(__classid(TCreateForm), &CreateForm);
QueryExec->Sql->Clear();
//ShowMessage("select is_head("+IntToStr(Module2DB->id_elem)+");");
QueryExec->Sql->Add("select is_head("+IntToStr(Module2DB->id_elem)+");");
QueryExec->ExecSql();

QueryExec->Sql->Clear();
QueryExec->Sql->Add("select * from tmp where usrnm='osa'");
QueryExec->ExecSql();
QueryExec->Active=true;
if (QueryExec->FieldByName("value")->AsString=="1")
{CreateForm->Panel4->Visible=true;
   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("select * from dci_head_tbl");
   QueryExec->ExecSql();
   QueryExec->Active=true;

   CreateForm->ComboBox2->Clear();
   QueryExec->First();
   for (int i=0;i<QueryExec->RecordCount;i++) {
   CreateForm->ComboBox2->Items->Add(QueryExec->FieldByName("name")->AsString);
   QueryExec->Next();
   }
}
else
{CreateForm->Panel4->Visible=false;}


//Grp_add->Width=258;
//Grp_add->Height=108;
CreateForm->id_parent=Module2DB->id_elem;
CreateForm->id_doc=Module2DB->id_doc;
CreateForm->num=0;
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N15Click(TObject *Sender)
{
Application->CreateForm(__classid(TMake_sql), &Make_sql);
//Grp_add->Width=258;
//Grp_add->Height=108;
/*AddField->id_doc=Doc_temp->id_doc;
AddField->id_parent=id_elem;
AddField->num=0;

   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("select * from dci_head_tbl");
   QueryExec->ExecSql();
   QueryExec->Active=true;

   AddField->Combo->Clear();
   QueryExec->First();
   for (int i=0;i<QueryExec->RecordCount;i++) {
   AddField->Combo->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
   QueryExec->Next();
   }
*/
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::DataModuleDestroy(TObject *Sender)
{
//Module2DB->BaseField->Connected=false;
//Module2DB->BaseField->Database="";
}
//---------------------------------------------------------------------------
void __fastcall TModule2DB::N16Click(TObject *Sender)
{
QueryExec->Sql->Clear();
QueryExec->Sql->Add("select uninc_level1("+IntToStr(Module2DB->id_elem)+")");
QueryExec->ExecSql();

QueryExec->Sql->Clear();
QueryExec->Sql->Add("delete from dcd_doc_tbl where id_elem in (select id_elem from dcm_template_tbl where id="+IntToStr(Module2DB->id_elem)+")");
QueryExec->ExecSql();

QueryExec->Sql->Clear();
QueryExec->Sql->Add("delete from dcm_template_tbl where id="+IntToStr(Module2DB->id_elem));
QueryExec->ExecSql();

ShowMessage("Элемент удален");
Doc_temp->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N17Click(TObject *Sender)
{

if (kind_doc==1) {

 if (Main_doc->ViewStyle1->Down)
  {
   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dcd_doc_tbl where id_doc="+IntToStr(id_doc));
   QueryExec->ExecSql();

   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dcm_doc_tbl where id="+IntToStr(id_doc));
   QueryExec->ExecSql();

   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dcm_template_tbl where id_doc="+IntToStr(id_doc));
   QueryExec->ExecSql();

   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dci_template_tbl where id in (select id_elem from dcm_template_tbl where id_doc="+IntToStr(id_doc)+")");
   QueryExec->ExecSql();

   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dci_document_tbl where id="+IntToStr(id_doc));
   QueryExec->ExecSql();
  }
 else
  {
   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dcd_doc_tbl where id_doc="+IntToStr(id_document));
   QueryExec->ExecSql();

   QueryExec->Sql->Clear();
   QueryExec->Sql->Add("delete from dcm_doc_tbl where id="+IntToStr(id_document));
   QueryExec->ExecSql();
  }
Main_doc->Refresh();
}

}
//---------------------------------------------------------------------------

void __fastcall TModule2DB::N18Click(TObject *Sender)
{
Application->CreateForm(__classid(TGenerator), &Generator);
//Grp_add->Width=258;
//Grp_add->Height=108;
Generator->id_doc=Module2DB->id_doc;
Generator->id_parent=Module2DB->id_elem;
Generator->num=Module2DB->num_elem;

/*Generator->id_doc=Doc_temp->id_doc;
Generator->num=0;
Generator->Visible=true;
Doc_temp->Enabled=false;*/
}
//---------------------------------------------------------------------------





