//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ins_grp.h"
#include "docu.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TGrp_ins *Grp_ins;
int id_grpc=-1;
//---------------------------------------------------------------------------
__fastcall TGrp_ins::TGrp_ins(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TGrp_ins::FormActivate(TObject *Sender)
{
NextGrp->Enabled=false;
NextGrp->Items->Clear();
if (id_grp==0)
{
 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select * from dci_group_tbl where id_parent=NULL");
 Module2DB->QueryExec->ExecSql();
 Module2DB->QueryExec->Active=true;
}
else
{
 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select * from dci_group_tbl where id_parent="+IntToStr(id_grp));
 Module2DB->QueryExec->ExecSql();
 Module2DB->QueryExec->Active=true;
}
TListItem  *ListItem;
 for (int i=0;i<Module2DB->QueryExec->RecordCount;i++) {
   ListItem = NextGrp->Items->Add();
   ListItem->Caption = Module2DB->QueryExec->FieldByName("name")->AsString;
   ListItem->StateIndex = Module2DB->QueryExec->FieldByName("id")->AsInteger;
   ListItem->ImageIndex = 1;
 Module2DB->QueryExec->Next();
 }
id_grpc=-10;
}
//---------------------------------------------------------------------------
void __fastcall TGrp_ins::cancelClick(TObject *Sender)
{
Grp_ins->Close();
}
//---------------------------------------------------------------------------
void __fastcall TGrp_ins::ButinsgrpClick(TObject *Sender)
{
int fl=0;
if (grp_text->Text=="") {fl=1;ShowMessage("Не определено имя группы");}
if (id_grpc==-1&&fl==0) {fl=1;ShowMessage("Не определен последующий элемент");}
if (fl==0)
{
 if (id_grpc==-10) {
 Module2DB->QueryExec->Sql->Clear();
//ShowMessage("select ins_grp("+IntToStr(id_grp)+",'"+grp_text->Text+"')");
 if (id_grp==0)
 {
 Module2DB->QueryExec->Sql->Add("select ins_grp(null,'"+grp_text->Text+"')");
 }
 else
 {
 Module2DB->QueryExec->Sql->Add("select ins_grp("+IntToStr(id_grp)+",'"+grp_text->Text+"')");
 }
 Module2DB->QueryExec->ExecSql();
 }
 else {Module2DB->QueryExec->Sql->Clear();
//ShowMessage("select ins_grp("+IntToStr(id_grp)+","+IntToStr(id_grpc)+",'"+grp_text->Text+"')");
 if (id_grp==0)
 {
 Module2DB->QueryExec->Sql->Add("select ins_grp(null,"+IntToStr(id_grpc)+",'"+grp_text->Text+"')");
 }
 else
 {
 Module2DB->QueryExec->Sql->Add("select ins_grp("+IntToStr(id_grp)+","+IntToStr(id_grpc)+",'"+grp_text->Text+"')");
 }
 Module2DB->QueryExec->ExecSql();
}

 Grp_ins->Close();
 Main_doc->Refresh();
}

}
//---------------------------------------------------------------------------
void __fastcall TGrp_ins::RadioButton1Click(TObject *Sender)
{
NextGrp->Enabled=false;
id_grpc=-10;
}
//---------------------------------------------------------------------------

void __fastcall TGrp_ins::RadioButton2Click(TObject *Sender)
{
NextGrp->Enabled=true;
id_grpc=-1;
}
//---------------------------------------------------------------------------

void __fastcall TGrp_ins::NextGrpChanging(TObject *Sender, TListItem *Item,
      TItemChange Change, bool &AllowChange)
{
id_grpc=Item->StateIndex;
}
//---------------------------------------------------------------------------

void __fastcall TGrp_ins::FormClose(TObject *Sender, TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);        
}
//---------------------------------------------------------------------------

