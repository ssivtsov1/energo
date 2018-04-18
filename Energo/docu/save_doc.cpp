//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "save_doc.h"
#include "docu.h"
#include "doc_tmp.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TSaveDoc *SaveDoc;
TList *GrpList;

typedef struct MList
{
int id;
int id_parent;
AnsiString name;
int level;
} MaList;

typedef MaList* Grp;

int kind_docum,id_transm,id_dir,id_client;
//---------------------------------------------------------------------------
__fastcall TSaveDoc::TSaveDoc(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TSaveDoc::FormActivate(TObject *Sender)
{
kind_docum=0;
id_transm=0;
id_dir=0;
Edit->Text="";
GrpList = Main_doc->GrpList;
MakeTree();
MakeTreeCli();
}
//---------------------------------------------------------------------------
// процедура создания дерева клиентов
void __fastcall TSaveDoc::MakeTreeCli()
{
Cli->Items->Clear();

//добавление РЕСов
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from clm_client_tbl where id_department is NULL");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

int ptr_res;
Module2DB->QueryExec->First();
for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
{
 if (Module2DB->QueryExec->FieldByName("id_department")->AsInteger==0) {
  Cli->Items->Add(NULL,Module2DB->QueryExec->FieldByName("id")->AsString);
  ptr_res=GetIndex(Module2DB->QueryExec->FieldByName("id")->AsString,Cli);
  Cli->Items->Item[ptr_res]->StateIndex=Module2DB->QueryExec->FieldByName("id")->AsInteger;
  Cli->Items->Item[i]->ImageIndex=1;
  }
 else
 {
/*  ptr=GetIndex(Module2DB->QueryExec->FieldByName("id_department")->AsString,Cli);
  if (ptr!=-1) Cli->Items->AddChild(Cli->Items->Item[ptr],Module2DB->QueryExec->FieldByName("id")->AsString);
  int ptr1=ptr;
  ptr=GetIndex(Module2DB->QueryExec->FieldByName("id")->AsString,Cli);
  Cli->Items->Item[ptr]->StateIndex=Module2DB->QueryExec->FieldByName("id")->AsInteger;
  if (ptr!=-1) Cli->Items->Item[ptr]->ImageIndex=1;
*/
 }
Module2DB->QueryExec->Next();
}
//добавление РЕСов

//добавление клиентов
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from clm_client_tbl where id_department is not NULL order by code");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

int ptr=1;
Module2DB->QueryExec->First();
for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
{
/*
  if (Module2DB->QueryExec->FieldByName("id_department")->AsInteger==0) {
  Cli->Items->Add(NULL,Module2DB->QueryExec->FieldByName("id")->AsString);
  ptr=GetIndex
  (Module2DB->QueryExec->FieldByName("id")->AsString,Cli);
  Cli->Items->Item[ptr]->StateIndex=Module2DB->QueryExec->FieldByName("id")->AsInteger;
  Cli->Items->Item[i]->ImageIndex=1;

  }
 else
 {
*/
//  ptr=GetIndex(Module2DB->QueryExec->FieldByName("id_department")->AsString,Cli);
  if (ptr!=-1) Cli->Items->AddChild(Cli->Items->Item[ptr_res],"("+Module2DB->QueryExec->FieldByName("code")->AsString+")"+Module2DB->QueryExec->FieldByName("name")->AsString);
//  ptr=GetIndex(Module2DB->QueryExec->FieldByName("id")->AsString,Cli);
//  Cli->Items->Item[ptr]->StateIndex=Module2DB->QueryExec->FieldByName("id")->AsInteger;
//  Cli->Items->Item[ptr]->Text=Module2DB->QueryExec->FieldByName("name")->AsString;
//  if (ptr!=-1) Cli->Items->Item[ptr]->ImageIndex=1;
  ptr++;
// }
Module2DB->QueryExec->Next();
}
//добавление клиентов

//Именование элементов дерева
/*for (int i=0;i<Cli->Items->Count;i++)
{
Module2DB->QueryExec->First();
   for (int j=0;j<Module2DB->QueryExec->RecordCount;j++)
   {
    if (Cli->Items->Item[i]->Text==Module2DB->QueryExec->FieldByName("id")->AsString)
    Cli->Items->Item[i]->Text=Module2DB->QueryExec->FieldByName("name")->AsString;
    Module2DB->QueryExec->Next();
   }
}
*/
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from clm_client_tbl where id_department is NULL");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;
//Именование элементов дерева
/*for (int i=0;i<Cli->Items->Count;i++)
{
Module2DB->QueryExec->First();
   for (int j=0;j<Module2DB->QueryExec->RecordCount;j++)
   {
    if (Cli->Items->Item[i]->Text==Module2DB->QueryExec->FieldByName("id")->AsString)
*/
    Cli->Items->Item[0]->Text=Module2DB->QueryExec->FieldByName("name")->AsString;
//    Module2DB->QueryExec->Next();
//   }
//}

//GroupTree->FullExpand();
}
//---------------------------------------------------------------------------
// процедура создания дерева групп документа
void __fastcall TSaveDoc::MakeTree()
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
int __fastcall TSaveDoc::GetIndex(AnsiString str, TTreeView *Tree)
{
int i=-1,f=0;
for (i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;break;}
}
return(i);
}
//---------------------------------------------------------------------------

void __fastcall TSaveDoc::SpeedButton2Click(TObject *Sender)
{
SaveDoc->Close();
Doc_temp->save=0;
}
//---------------------------------------------------------------------------
void __fastcall TSaveDoc::GroupTreeChanging(TObject *Sender,
      TTreeNode *Node, bool &AllowChange)
{
Doc_temp->id_grp=Node->StateIndex;
}
//---------------------------------------------------------------------------
void __fastcall TSaveDoc::SpeedButton1Click(TObject *Sender)
{
int rezz=1;
 if (Edit->Text=="")
  {
   ShowMessage("Задайте имя документа");rezz=0;
  }

 if (MaskEdit2->Text=="  .  .  ")
  {
   ShowMessage("Задайте дату регистрации");rezz=0;
  }

if (rezz==1)
{
if (SpeedButton1->Caption=="Сохранить")
   {
    Doc_temp->name_doc=Edit->Text;
    Doc_temp->DocSave(Edit->Text,MaskEdit2->Text,kind_docum,Memo1->Text);
    SaveDoc->Close();
   }
if (SpeedButton1->Caption=="Регистрировать")
   {
    Doc_temp->name_doc=Edit->Text;
    Doc_temp->DocReg(MaskEdit2->Text,Edit1->Text,id_transm,id_dir,id_client);
    SaveDoc->Close();
   }
}
}
//---------------------------------------------------------------------------
void __fastcall TSaveDoc::FormClose(TObject *Sender, TCloseAction &Action)
{
Doc_temp->Enabled=true;
}
//---------------------------------------------------------------------------
void __fastcall TSaveDoc::ComboBox2Change(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dck_document_tbl where name='"+ComboBox2->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

kind_docum=Module2DB->QueryExec->FieldByName("id")->AsInteger;
}
//---------------------------------------------------------------------------

void __fastcall TSaveDoc::ComboBox1Change(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dci_transm_tbl where name='"+ComboBox1->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

id_transm=Module2DB->QueryExec->FieldByName("id")->AsInteger;
}
//---------------------------------------------------------------------------

void __fastcall TSaveDoc::ComboBox3Change(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dci_direction_tbl where name='"+ComboBox3->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

id_dir=Module2DB->QueryExec->FieldByName("id")->AsInteger;
}
//---------------------------------------------------------------------------
AnsiString __fastcall TSaveDoc::GetCode(AnsiString str)
{
  AnsiString temp="";
       int fl=0,i=0,write=0;
       for (int s=1;s<str.Length();s++)
       {
        if (write==1) i=1;
        if (str[s]=='('&&fl==0) {write=1;i=0;fl=1;}
        if (str[s]==')'&&fl==1) {write=0;fl=2;}

        if (write==1&&i==1) temp+=str[s];
       }
  return temp;
}
//---------------------------------------------------------------------------
void __fastcall TSaveDoc::CliChange(TObject *Sender, TTreeNode *Node)
{
//id_client=Node->StateIndex;

AnsiString code=GetCode(Node->Text);
if (code!="")
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from clm_client_tbl where code='"+code+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;
id_client=Module2DB->QueryExec->FieldByName("id")->AsInteger;

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from clm_statecl_tbl where id_client='"+IntToStr(id_client)+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

Edit1->Text=Module2DB->QueryExec->FieldByName("doc_num")->AsString;
MaskEdit2->Text=Module2DB->QueryExec->FieldByName("doc_dat")->AsString;
}
}
//---------------------------------------------------------------------------

