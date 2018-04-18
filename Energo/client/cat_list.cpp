//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "cat_list.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma resource "*.dfm"
TKateg *Kateg;
int id_k=0;
int ok=1;
//---------------------------------------------------------------------------
__fastcall TKateg::TKateg(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  Query = new TWTQuery(Application);
  Query->MacroCheck=true;
  Query->Options<< doQuickOpen;
  Query->RequestLive=false;
  Query->CachedUpdates=false;
}
//---------------------------------------------------------------------------
void __fastcall TKateg::FormClose(TObject *Sender, TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);

}
//---------------------------------------------------------------------------


void __fastcall TKateg::DataAfterInsert(TDataSet *DataSet)
{
Data->Fields->Fields[1]->AsInteger=id_k;
Data->Post();

//Data->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TKateg::DataAfterPost(TDataSet *DataSet)
{
//Query->Sql->Clear();
//Query->Sql->Add("delete from cld_kateg_tbl where id_t is null");
//Query->ExecSql();
}
//---------------------------------------------------------------------------

void __fastcall TKateg::FormCreate(TObject *Sender)
{
MakeTree();
}
//---------------------------------------------------------------------------
void __fastcall TKateg::MakeTree()
{
Tree->Items->Clear();

Query->Sql->Clear();
Query->Sql->Add("select * from cla_kateg_tbl where id_parent is null order by num ASC");
Query->ExecSql();
Query->Active=true;

 for (int i=0;i<Query->RecordCount;i++)
  {
   Tree->Items->Add(NULL,Query->FieldByName("id")->AsString);
   int ptr=GetIndex(Query->FieldByName("id")->AsString,Tree);
   Tree->Items->Item[ptr]->StateIndex=Query->FieldByName("id")->AsInteger;
   Tree->Items->Item[ptr]->OverlayIndex=0;
   Query->Next();
  }

Query->Sql->Clear();
Query->Sql->Add("select * from cla_kateg_tbl where id_parent is not null order by num ASC");
Query->ExecSql();
Query->Active=true;

 for (int i=0;i<Query->RecordCount;i++)
  {
   int ptr=GetIndex(Query->FieldByName("id_parent")->AsString,Tree);
   if (ptr!=-1) Tree->Items->AddChild(Tree->Items->Item[ptr],Query->FieldByName("id")->AsString);
   ptr=GetIndex(Query->FieldByName("id")->AsString,Tree);
   if (ptr!=-1) Tree->Items->Item[ptr]->StateIndex=Query->FieldByName("id")->AsInteger;
   Tree->Items->Item[ptr]->OverlayIndex=1;
   Query->Next();
  }

Query->Sql->Clear();
Query->Sql->Add("select * from cla_kateg_tbl");
Query->ExecSql();
Query->Active=true;

Query->First();
 for (int i=0;i<Query->RecordCount;i++)
 {
  int ptr=GetIndex(Query->FieldByName("id")->AsString,Tree);
  Tree->Items->Item[ptr]->Text=Query->FieldByName("name")->AsString;
  Query->Next();
 }

 Tree->FullExpand();
}
//---------------------------------------------------------------------------
int __fastcall TKateg::GetIndex(AnsiString ind, TTreeView *Tree)
{
int f=-1;
for (int i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==ind) {f=i;break;}
}
return(f);
}
//---------------------------------------------------------------------------
void __fastcall TKateg::TreeChange(TObject *Sender, TTreeNode *Node)
{
id_k=Node->StateIndex;
ok=Node->OverlayIndex;
Data->Sql->Clear();
Data->Sql->Add("select * from cld_kateg_tbl where id_k="+IntToStr(id_k));
Data->ExecSql();
Data->Active=true;
 Edit3->Visible=true;
 Label1->Visible=true;
 DBGrid1->Visible=true;
Hide();
New_k->Visible=true;
New_k->Align=alClient;

Query->Sql->Clear();
Query->Sql->Add("select * from cla_kateg_tbl where id="+IntToStr(id_k));
Query->ExecSql();
Query->Active=true;
Edit2->Text=Query->FieldByName("name")->AsString;
Edit3->Text=Query->FieldByName("persent")->AsString;
Edit4->Text=Query->FieldByName("num")->AsString;

 if (ok==0)
 {
 Edit3->Text="0";
 Edit3->Visible=false;
 Label1->Visible=false;
 DBGrid1->Visible=false;
 }

}
//---------------------------------------------------------------------------
void __fastcall TKateg::Hide()
{
 New_k->Visible=false;
 New_b->Visible=false;
}
//---------------------------------------------------------------------------

void __fastcall TKateg::SpeedButton1Click(TObject *Sender)
{
if (ok==1) {ShowMessage("Низя");}
else {
Query->Sql->Clear();
Query->Sql->Add("insert into cla_kateg_tbl(name,id_parent) values('Новая категория',"+IntToStr(id_k)+")");
Query->ExecSql();
MakeTree();
}
}
//---------------------------------------------------------------------------

void __fastcall TKateg::SpeedButton3Click(TObject *Sender)
{
Query->Sql->Clear();
Query->Sql->Add("delete from cla_kateg_tbl where id="+IntToStr(id_k));
Query->ExecSql();
MakeTree();
}
//---------------------------------------------------------------------------

void __fastcall TKateg::SpeedButton6Click(TObject *Sender)
{
int f=1;
int pers=0,num=0;
try
{
pers=StrToInt(Edit3->Text);
}
__except(1) {f=0;ShowMessage("Проценты в числовом виде");}

try
{
num=StrToInt(Edit4->Text);
}
__except(1) {f=0;ShowMessage("Порядок в чмсловом виде");}

if (f==1)
{
Query->Sql->Clear();
Query->Sql->Add("update cla_kateg_tbl set name='"+Edit2->Text+"',persent="+pers+",num="+num+" where id="+IntToStr(id_k));
Query->ExecSql();
MakeTree();
}
}
//---------------------------------------------------------------------------

void __fastcall TKateg::SpeedButton2Click(TObject *Sender)
{
Query->Sql->Clear();
Query->Sql->Add("insert into cla_kateg_tbl(name,id_parent) values('Новый бюджет',NULL)");
Query->ExecSql();
MakeTree();
}
//---------------------------------------------------------------------------

