//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "main.h"
#include "data_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TDoc_temp *Doc_temp;
int id_doc=5;
//---------------------------------------------------------------------------
__fastcall TDoc_temp::TDoc_temp(TComponent* Owner)
        : TForm(Owner)
{
}
//-----------------------------------------------------------------------------------------------------
int __fastcall TDoc_temp::GetIndex(AnsiString str, TTreeView *Tree)
{
int i=-1,f=0;
for (i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;break;}
}
return(i);
}
//----------------------------------------------------------------------------
void __fastcall TDoc_temp::Button1Click(TObject *Sender)
{
MakeTree();
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::MakeTree()
{
Module2DB->Query->Sql->Clear();
Module2DB->Query->Sql->Add("select id_elem from doc_tree_tbl where id_elem_parent=NULL and kind_doc="+IntToStr(id_doc));
Module2DB->Query->ExecSql();
Module2DB->Query->Active=true;

}
//---------------------------------------------------------------------------
