//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "move.h"
#include "docu_mod.h"
#include "docu.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMv *Mv;
TList *GrpList;
int new_grp;

typedef struct MList
{
int id;
int id_parent;
AnsiString name;
int level;
} MaList;

typedef MaList* Grp;

//---------------------------------------------------------------------------
__fastcall TMv::TMv(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TMv::FormClose(TObject *Sender, TCloseAction &Action)
{
// Main_doc->Enabled=true;
 TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
void __fastcall TMv::Button2Click(TObject *Sender)
{
Mv->Close();
}
//---------------------------------------------------------------------------
void __fastcall TMv::FormCreate(TObject *Sender)
{
GrpList = Main_doc->GrpList;

}
//---------------------------------------------------------------------------
// процедура создания дерева групп документа
void __fastcall TMv::MakeTree()
{
GroupTree->Items->Clear();

GroupTree->Items->Add(NULL,"Группы документов");
int ptr=GetIndex("Группы документов",GroupTree);
GroupTree->Items->Item[ptr]->StateIndex=0;
GroupTree->Items->Item[ptr]->ImageIndex=1;

Grp Struct;
for (int i=0;i<GrpList->Count;i++)
{
 Struct = (Grp) GrpList->Items[i];
 if (Struct->id_parent==0) {
  ptr=GetIndex("Группы документов",GroupTree);
  if (ptr!=-1) GroupTree->Items->AddChild(GroupTree->Items->Item[ptr],IntToStr(Struct->id));
  ptr=GetIndex(IntToStr(Struct->id),GroupTree);
  GroupTree->Items->Item[ptr]->StateIndex=Struct->id;
  GroupTree->Items->Item[i]->ImageIndex=1;
  }
 else
 {
  ptr=GetIndex(IntToStr(Struct->id_parent),GroupTree);
  if (ptr!=-1) GroupTree->Items->AddChild(GroupTree->Items->Item[ptr],IntToStr(Struct->id));
  int ptr1=ptr;
  ptr=GetIndex(IntToStr(Struct->id),GroupTree);
  GroupTree->Items->Item[ptr]->StateIndex=Struct->id;
  if (ptr!=-1) GroupTree->Items->Item[ptr]->ImageIndex=1;
 }
}

//Именование элементов дерева
for (int i=1;i<GroupTree->Items->Count;i++)
  for (int j=0;j<GrpList->Count;j++)
   {
    Struct = (Grp) GrpList->Items[j];
    if (GroupTree->Items->Item[i]->Text==IntToStr(Struct->id)) GroupTree->Items->Item[i]->Text=Struct->name;
   }

GroupTree->FullExpand();
}
//-----------------------------------------------------------------------------------------------------
int __fastcall TMv::GetIndex(AnsiString str, TTreeView *Tree)
{
int i=-1,f=0;
for (i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;break;}
}
return(i);
}
//---------------------------------------------------------------------------

void __fastcall TMv::FormActivate(TObject *Sender)
{
MakeTree();

int ptr=GetIndexById(id_grp,GroupTree);
if (ptr>0) GroupTree->Items->Item[ptr]->Selected=true;

 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select * from dci_document_tbl where id="+IntToStr(id_doc));
 Module2DB->QueryExec->ExecSql();
 Module2DB->QueryExec->Active=true;

 Doc_name->Text=Module2DB->QueryExec->FieldByName("name")->AsString;
}
//---------------------------------------------------------------------------
int __fastcall TMv::GetIndexById(int id, TTreeView *Tree)
{
int j=-1,f=0;
for (int i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->StateIndex==id) {j=i;f=1;break;}
}
return(j);
}
//---------------------------------------------------------------------------

void __fastcall TMv::MoveButClick(TObject *Sender)
{
 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("update dci_document_tbl set id_grp="+IntToStr(new_grp)+" where id="+IntToStr(id_doc));
 Module2DB->QueryExec->ExecSql();
 ShowMessage("Документ перенесен");
 Main_doc->Enabled=true;
 Mv->Close();
}
//---------------------------------------------------------------------------

void __fastcall TMv::GroupTreeChanging(TObject *Sender, TTreeNode *Node,
      bool &AllowChange)
{
 new_grp=Node->StateIndex;
}
//---------------------------------------------------------------------------

