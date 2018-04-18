//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "docu.h"
#include "docu_mod.h"
#include "doc_tmp.h"
#include "add_grp.h"
#include "ins_grp.h"
#include "move.h"
#include "findd.h"
#include "create_tab.h"
#include "findd_a.h"
#include "filt.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMain_doc *Main_doc;
int sel_grp=0;
int id_grp=0;
int fresh=1;
AnsiString tmp;

typedef struct MList
{
int id;
int id_parent;
AnsiString name;
int level;
} MaList;

typedef MaList* Grp;

//---------------------------------------------------------------------------
__fastcall TMain_doc::TMain_doc(TComponent* Owner)
        : TfTWTCompForm(Owner)
{

// Module2DB->Visible=false;

/* Application->CreateForm(__classid(TGrp_ins), &Grp_ins);
 Grp_ins->Visible=false;
 Application->CreateForm(__classid(TGrp_add), &Grp_add);
 Grp_add->Visible=false;
 Application->CreateForm(__classid(TMv), &Mv);
 Mv->Visible=false;
 Application->CreateForm(__classid(TFind), &Find);
 Find->Visible=false;
 Application->CreateForm(__classid(TFindAdv), &FindAdv);
 FindAdv->Visible=false;
 Application->CreateForm(__classid(TFilter), &Filter);
 Filter->Visible=false;
 Application->CreateForm(__classid(TDoc_temp), &Doc_temp);
 Doc_temp->Visible=false;
 Application->CreateForm(__classid(TCreateTab), &CreateTab);
 CreateTab->Visible=false;
  */
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::N2Click(TObject *Sender)
{
Main_doc->Close();
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::GroupTreeChange(TObject *Sender, TTreeNode *Node)
{
TypeDoc->Items->Clear();

if (Node->Text=="Группы документов") {

//Grp_add->id_grp=Node->StateIndex;
//Grp_ins->id_grp=Node->StateIndex;
id_grp=Node->StateIndex;
}


if (Node->Text!="Группы документов"&&Node->OverlayIndex==1) {

if (ViewStyle1->Down==true)
{
Module2DB->Query_grp->Sql->Clear();
//ShowMessage("select * from dci_document_tbl where id_grp="+IntToStr(Node->StateIndex)+filt_str);
Module2DB->Query_grp->Sql->Add("select * from dci_document_tbl where id_grp="+IntToStr(Node->StateIndex)+filt_str);
Module2DB->Query_grp->ExecSql();
Module2DB->Query_grp->Active=true;

Module2DB->Query_grp->First();
TListItem  *ListItem;
  for (int i=0;i<Module2DB->Query_grp->RecordCount;i++)
  {
   ListItem = TypeDoc->Items->Add();
   ListItem->Caption = Module2DB->Query_grp->FieldByName("name")->AsString;
   ListItem->StateIndex = Module2DB->Query_grp->FieldByName("id")->AsInteger;
   ListItem->OverlayIndex= Node->OverlayIndex;
    ListItem->SubItems->Add(Module2DB->Query_grp->FieldByName("discription")->AsString);
    ListItem->SubItems->Add(Module2DB->Query_grp->FieldByName("reg_date")->AsString);

   Module2DB->Query_grp->Next();
  }//of for

}//если смотрим шаблоны
else
{
Module2DB->Query_grp->Sql->Clear();
//ShowMessage("select * from dcm_document_tbl where id_grp="+IntToStr(Node->StateIndex)+filt_str);
Module2DB->Query_grp->Sql->Add("select * from dcm_doc_tbl where id_document in (select id from dci_document_tbl where id_grp="+IntToStr(Node->StateIndex)+")"+filt_str);
//Module2DB->Query_grp->Sql->Add("select * from dcm_doc_tbl where id_grp="+IntToStr(Node->StateIndex)+filt_str);
Module2DB->Query_grp->ExecSql();
Module2DB->Query_grp->Active=true;

Module2DB->Query_grp->First();
TListItem  *ListItem;
  for (int i=0;i<Module2DB->Query_grp->RecordCount;i++)
  {
   ListItem = TypeDoc->Items->Add();
   ListItem->Caption = Module2DB->Query_grp->FieldByName("name")->AsString;
   ListItem->StateIndex = Module2DB->Query_grp->FieldByName("id")->AsInteger;
   ListItem->OverlayIndex= Node->OverlayIndex;
    ListItem->SubItems->Add("");
    ListItem->SubItems->Add(Module2DB->Query_grp->FieldByName("reg_date")->AsString);
   Module2DB->Query_grp->Next();
  }//of for

}




//Grp_add->id_grp=Node->StateIndex;
//Grp_ins->id_grp=Node->StateIndex;
id_grp=Node->StateIndex;

//Mv->id_grp=Node->StateIndex;
}//if Node->Text==группы документов
else
{
//Grp_add->id_grp=Node->StateIndex;
}

//если выбранный элемент - таблица
if (Node->OverlayIndex==3)
{
   TListItem  *ListItem;
   ListItem = TypeDoc->Items->Add();
   ListItem->Caption = Node->Text;
   ListItem->StateIndex = Node->StateIndex;
   ListItem->OverlayIndex= Node->OverlayIndex;
}
Module2DB->id_grp=Node->StateIndex;
}
//---------------------------------------------------------------------------





void __fastcall TMain_doc::ViewCheck(TMenuItem *N)
{
N15->Checked=false;N16->Checked=false;N17->Checked=false;N18->Checked=false;
N->Checked=true;
}
//---------------------------------------------------------------------------
void __fastcall TMain_doc::GetData()
{

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dci_group_tbl order by level ASC");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

Grp Struct;
GrpList = new TList;

Module2DB->QueryExec->First();
 for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
 {
  Struct = new MaList;
  Struct->id=Module2DB->QueryExec->FieldByName("id")->AsInteger;
  Struct->id_parent=Module2DB->QueryExec->FieldByName("id_parent")->AsInteger;
  Struct->level=Module2DB->QueryExec->FieldByName("level")->AsInteger;
  Struct->name=Module2DB->QueryExec->FieldByName("name")->AsString;

 GrpList->Add(Struct);
 Module2DB->QueryExec->Next();
 }


}
//---------------------------------------------------------------------------
void __fastcall TMain_doc::FormCreate(TObject *Sender)
{
Refresh();
filt_str="";
}
//---------------------------------------------------------------------------
void __fastcall TMain_doc::Refresh()
{
GetData();
MakeTree();
Prepare();
}
//---------------------------------------------------------------------------
// процедура создания дерева клмпонентов документа
void __fastcall TMain_doc::MakeTree()
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
  GroupTree->Items->Item[ptr]->ImageIndex=1;
  GroupTree->Items->Item[ptr]->OverlayIndex=1;
  }
 else
 {
  ptr=GetIndex(IntToStr(Struct->id_parent),GroupTree);
  if (ptr!=-1) GroupTree->Items->AddChild(GroupTree->Items->Item[ptr],IntToStr(Struct->id));
  int ptr1=ptr;
  ptr=GetIndex(IntToStr(Struct->id),GroupTree);
  GroupTree->Items->Item[ptr]->StateIndex=Struct->id;
  if (ptr!=-1) {GroupTree->Items->Item[ptr]->ImageIndex=1;GroupTree->Items->Item[ptr]->OverlayIndex=1;}
 }
}

//Именование элементов дерева
for (int i=1;i<GroupTree->Items->Count;i++)
  for (int j=0;j<GrpList->Count;j++)
   {
    Struct = (Grp) GrpList->Items[j];
    if (GroupTree->Items->Item[i]->Text==IntToStr(Struct->id)) GroupTree->Items->Item[i]->Text=Struct->name;
   }

 GroupTree->Items->Add(NULL,"Сложные элементы");
 ptr=GetIndex("Сложные элементы",GroupTree);
 GroupTree->Items->Item[ptr]->StateIndex=0;
 GroupTree->Items->Item[ptr]->ImageIndex=1;

  GroupTree->Items->AddChild(GroupTree->Items->Item[ptr],"Элементы документа");
  ptr=GetIndex("Элементы документа",GroupTree);
  GroupTree->Items->Item[ptr]->StateIndex=0;
  GroupTree->Items->Item[ptr]->ImageIndex=1;

  ptr=GetIndex("Сложные элементы",GroupTree);
  GroupTree->Items->AddChild(GroupTree->Items->Item[ptr],"Таблицы");
  ptr=GetIndex("Таблицы",GroupTree);
  GroupTree->Items->Item[ptr]->StateIndex=0;
  GroupTree->Items->Item[ptr]->ImageIndex=1;

//Выбираем элементы - таблица
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dcm_template_tbl where idk_template=5 and id_compl=null");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;
int ptr1=ptr;
Module2DB->QueryExec->First();
 for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
 {
  GroupTree->Items->AddChild(GroupTree->Items->Item[ptr1],Module2DB->QueryExec->FieldByName("name")->AsString);
  ptr=GetIndex(Module2DB->QueryExec->FieldByName("name")->AsString,GroupTree);
  GroupTree->Items->Item[ptr]->StateIndex=Module2DB->QueryExec->FieldByName("id")->AsInteger;
  GroupTree->Items->Item[ptr]->ImageIndex=3;
  GroupTree->Items->Item[ptr]->OverlayIndex=3;
  Module2DB->QueryExec->Next();
 }
GroupTree->Items->Item[ptr]->ImageIndex=3;


}
//-----------------------------------------------------------------------------------------------------
void __fastcall TMain_doc::Prepare()
{
//создание колонок в правом окне
/*  TListColumn  *NewColumn;
  NewColumn = TypeDoc->Columns->Add();
  NewColumn->Caption = "Наименование";
  NewColumn->AutoSize=true;
  NewColumn->Width=100;

  NewColumn = TypeDoc->Columns->Add();
  NewColumn->Caption = "Описание";
  NewColumn->AutoSize=true;
  NewColumn->Width=100;

  NewColumn = TypeDoc->Columns->Add();
  NewColumn->Caption = "Дата Создания";
  NewColumn->AutoSize=true;
*/
}
//---------------------------------------------------------------------------
int __fastcall TMain_doc::GetIndex(AnsiString str, TTreeView *Tree)
{
int i=-1,f=0;
for (i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;break;}
}
return(i);
}
//---------------------------------------------------------------------------
int __fastcall TMain_doc::GetIndex1(AnsiString str, TTreeView *Tree, int index)
{
int i=-1,f=0;
for (i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str&&Tree->Items->Item[i]->StateIndex==index) {f=1;break;}
}
return(i);
}

//---------------------------------------------------------------------------
// функция возвращает идентификатор документа
int __fastcall  TMain_doc::GetIndexDB()
{
int id_doc=-1;

if (tmp!="") {
 Module2DB->Query_grp->Sql->Clear();
 Module2DB->Query_grp->Sql->Add("select kind_doc from dci_document_tbl where name='"+tmp+"' and id_grp="+IntToStr(sel_grp));
 Module2DB->Query_grp->ExecSql();
 Module2DB->Query_grp->Active=true;

 if (Module2DB->Query_grp->RecordCount>1)
  {ShowMessage("Error\nнесколько одинаковых шаблонов в пределах группы");}
 else id_doc=Module2DB->Query_grp->FieldByName("kind_doc")->AsInteger;
}

return(id_doc);
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::TypeDocDblClick(TObject *Sender)
{
if (ViewStyle1->Down==true) Module2DB->view=1;
if (ViewStyle2->Down==true) Module2DB->view=2;
Module2DB->N5Click(Sender);
if (ViewStyle1->Down==true) Doc_temp->view=1;
else Doc_temp->view=2;
Doc_temp->Refresh();
}
//---------------------------------------------------------------------------




void __fastcall TMain_doc::N11Click(TObject *Sender)
{
Module2DB->id_doc=0;
Module2DB->kind_doc=1;
Doc_temp->create=2;//Создается сложный элемент
Module2DB->N5Click(Sender);
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::ViewStyle1Click(TObject *Sender)
{
int ptr=GetIndex("Группы документов",GroupTree);
GroupTree->Items->Item[ptr]->Selected=true;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::ViewStyle2Click(TObject *Sender)
{
int ptr=GetIndex("Группы документов",GroupTree);
GroupTree->Items->Item[ptr]->Selected=true;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton1Click(TObject *Sender)
{
Module2DB->N1Click(Sender);
//TypeDoc->SortType=stData;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton2Click(TObject *Sender)
{
Module2DB->N2Click(Sender);
//TypeDoc->SortType=stText;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton5Click(TObject *Sender)
{
Module2DB->N3Click(Sender);
//TypeDoc->SortType=stBoth;
}
//---------------------------------------------------------------------------



void __fastcall TMain_doc::SpeedButton7Click(TObject *Sender)
{
Application->CreateForm(__classid(TFilter), &Filter);
 Main_doc->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton8Click(TObject *Sender)
{
Main_doc->Caption="Документооборот";
filt_str="";
int ptr=GetIndex("Группы документов",GroupTree);
GroupTree->Items->Item[ptr]->Selected=true;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::FormClose(TObject *Sender, TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);        
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton9Click(TObject *Sender)
{
 Module2DB->Query_grp->Sql->Clear();
 Module2DB->Query_grp->Sql->Add("insert into dci_document_tbl(discription) values('"+Module2DB->MainDB->Login+"')");
 Module2DB->Query_grp->ExecSql();

 Module2DB->Query_grp->Sql->Clear();
 Module2DB->Query_grp->Sql->Add("select id from dci_document_tbl where discription='"+Module2DB->MainDB->Login+"'");
 Module2DB->Query_grp->ExecSql();
 Module2DB->Query_grp->Active=true;
 int id_doc=Module2DB->Query_grp->FieldByName("id")->AsInteger;

 Module2DB->Query_grp->Sql->Clear();
 Module2DB->Query_grp->Sql->Add("update dci_document_tbl set discription=NULL where id="+IntToStr(id_doc));
 Module2DB->Query_grp->ExecSql();

 Module2DB->id_doc=id_doc;
 Module2DB->kind_doc=1;
 Module2DB->N5Click(Sender);
 Doc_temp->create=1;//Создается новый документ
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton10Click(TObject *Sender)
{
Application->CreateForm(__classid(TCreateTab), &CreateTab);
CreateTab->Width=375;
CreateTab->Height=486;
CreateTab->form=1;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton15Click(TObject *Sender)
{

Application->CreateForm(__classid(TFind), &Find);
 Find->Height=367;
 Find->Width=497;
 if (ViewStyle1->Down==true) Find->id_view=1;
 else Find->id_view=2;
 Find->id_form=1;

}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::SpeedButton16Click(TObject *Sender)
{
Application->CreateForm(__classid(TFindAdv), &FindAdv);
 FindAdv->Top=75;
 FindAdv->Height=526;
 FindAdv->Width=487;
 if (ViewStyle1->Down==true) FindAdv->id_view=1;
 else FindAdv->id_view=2;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::N15Click(TObject *Sender)
{
ViewCheck(N15);
TypeDoc->ViewStyle=vsIcon;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::N16Click(TObject *Sender)
{
ViewCheck(N16);
TypeDoc->ViewStyle=vsSmallIcon;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::N17Click(TObject *Sender)
{
ViewCheck(N17);
TypeDoc->ViewStyle=vsList;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::N18Click(TObject *Sender)
{
ViewCheck(N18);
TypeDoc->ViewStyle=vsReport;
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::TypeDocColumnClick(TObject *Sender,
      TListColumn *Column)
{
if (Column->Caption=="Наименование") {TypeDoc->SortType=stText;}
//if (Column->Caption=="Описание") ShowMessage("OK2");
//if (Column->Caption=="Дата создания") ShowMessage("OK3");
}
//---------------------------------------------------------------------------

void __fastcall TMain_doc::TypeDocChange(TObject *Sender, TListItem *Item,
      TItemChange Change)
{
try{
 if (ViewStyle2->Down==true)
  {

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("select id_document from dcm_doc_tbl where id="+IntToStr(Item->StateIndex));
   Module2DB->QueryExec->ExecSql();
   Module2DB->QueryExec->Active=true;

   Module2DB->id_doc=Module2DB->QueryExec->FieldByName("id_document")->AsInteger;
   Module2DB->id_document=Item->StateIndex;
  }
 else
  {
   Module2DB->id_doc=Item->StateIndex;
  }

 Module2DB->kind_doc=Item->OverlayIndex;
 Module2DB->name=Item->Caption;
// Mv->id_doc=Item->StateIndex;
 }
__except(1){}
}

//---------------------------------------------------------------------------


