//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "add_grp.h"
#include "doc_tmp.h"
#include "docu.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TGrp_add *Grp_add;
//---------------------------------------------------------------------------
__fastcall TGrp_add::TGrp_add(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TGrp_add::ButaddgrpClick(TObject *Sender)
{
 if (grp_text!="") {
// ShowMessage("select add_grp("+IntToStr(id_grp)+",'"+grp_text->Text+"')");
if (id_grp==0)
{
 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select add_grp(NULL,'"+grp_text->Text+"')");
 Module2DB->QueryExec->ExecSql();
}
else
{
 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select add_grp("+IntToStr(id_grp)+",'"+grp_text->Text+"')");
 Module2DB->QueryExec->ExecSql();
}
 Grp_add->Close();
 Main_doc->Refresh();
 }

}
//---------------------------------------------------------------------------

void __fastcall TGrp_add::ButcangrpClick(TObject *Sender)
{
 Grp_add->Close();
}
//---------------------------------------------------------------------------

void __fastcall TGrp_add::FormClose(TObject *Sender, TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);        
}
//---------------------------------------------------------------------------

