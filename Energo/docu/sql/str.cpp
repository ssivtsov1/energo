//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "str.h"
#include "doc_tmp.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma resource "*.dfm"
TMake_sql *Make_sql;

struct TableList
{
 AnsiString table_name;
 int id;
 TableList* next;
};

struct MainList
{
 AnsiString master_table;
 AnsiString master_field;
 AnsiString slave_table;
 AnsiString slave_field;
 MainList* next;
 bool done;
};

struct SelectList
{
 AnsiString master_table;
 AnsiString master_field;
 AnsiString slave_table;
 AnsiString slave_field;
 SelectList* next;
 SelectList* prev;
 bool done;
 bool from;
};

struct SelectFields
{
 AnsiString field_name;
 AnsiString where;
 bool key;
 SelectFields* next;
 SelectFields* prev;
 bool done;
 bool from;
};

TableList *Fst,*Lst;
MainList *MainFst,*MainLst;
SelectList *SelFst,*SelLst;
SelectFields *SelfFst,*SelfLst;
MainList *Record;
SelectList *RecordS;
int count=1;
int find=0;
TTreeNode *Nodd,*NoddS,*NodeMini;

AnsiString field="";
int field_id=0;
AnsiString fields="";
int field_ids=0;

AnsiString select_table="";

AnsiString arr_tab[50]={""};
int cnt_tab=0;

AnsiString from_glob="";
//---------------------------------------------------------------------------
__fastcall TMake_sql::TMake_sql(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::AddTable(AnsiString table_name)
{
//temp
TableList *Rec=Fst;
int f=0;
 while (Rec!=NULL)
 {
 if (Rec->table_name==table_name) {f=1;break;}
 Rec=Rec->next;
 }

 if (f==0)
 {
 TableList *Struct=Fst,*StructNew,*StructOld=Lst;
 StructNew = new TableList;
 StructNew->table_name=table_name;
 StructNew->id=count;
 count++;

 if (Struct==NULL) {StructNew->next=NULL;Fst=StructNew;}
 else {StructOld->next=StructNew;StructNew->next=NULL;}
 StructOld=StructNew;
 Lst=StructOld;
 }//if f==0

}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::AddLink(AnsiString string)
{
AnsiString master_table="",slave_table="",master_field="",slave_field="";
int cnt=0,c=0;
for (int i=1;i<string.Length();i++)
{
 if (string[i]=='\\') {cnt=1;c++;}

 if (cnt==4&&c==1) {slave_table+=string[i];}
 if (cnt==4&&c==2) {master_table+=string[i];}
 if (cnt==4&&c==4) {slave_field+=string[i];}
 if (cnt==4&&c==5) {master_field+=string[i];}

 if (string[i]=='0'&&cnt>0&&cnt!=4) cnt++;
}

 MainList *Struct=MainFst,*StructNew,*StructOld=MainLst;
 StructNew = new MainList;
 StructNew->master_table=master_table;
 StructNew->master_field=master_field;
 StructNew->slave_table=slave_table;
 StructNew->slave_field=slave_field;
 StructNew->done=false;

 if (Struct==NULL) {StructNew->next=NULL;MainFst=StructNew;}
 else {StructOld->next=StructNew;StructNew->next=NULL;}
 StructOld=StructNew;
 MainLst=StructOld;

}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::AddToTree(AnsiString parent,AnsiString child)
{
if (child!=parent)
{
//if (child=="eqm_equipment_tbl"&&Record->done==true) ShowMessage("PARENT="+parent+"; CHILD="+child+" record->parent_t=TRUE");
//if (child=="eqm_equipment_tbl"&&Record->done==false) ShowMessage("PARENT="+parent+"; CHILD="+child+" record->parent_t=FALSE");

MainList *Rec=MainFst;
int ptr=-1;
 for (int i=0;i<Tree->Items->Count;i++)
 {
  if (Tree->Items->Item[i]->Text==parent) ptr=i;
 }

 if (ptr>-1)//parent is present
 {
  Tree->Items->AddChild(Tree->Items->Item[ptr],child);
  Record->done=true;
 }//parent is present
 else//parent is not present
 {
  MainList *Rec=MainFst;
  int f=0;
   while (Rec!=NULL)
   {
   if (Rec->master_table==parent) {f=1;Record=Rec;break;}
   Rec=Rec->next;
   }
   if (f==1) AddToTree(Rec->slave_table,Rec->master_table);
   else {Tree->Items->Add(NULL,parent);
         int p=GetIndex(parent,Tree);
         Tree->Items->AddChild(Tree->Items->Item[p],child);
         Record->done=true;
        }
 }//parent is not present

Tree->FullExpand();
}//if child!=parent
}
//---------------------------------------------------------------------------
int __fastcall TMake_sql::GetIndex(AnsiString str, TTreeView *Tree)
{
int ii=-1,f=0;
for (int i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;ii=i;break;}
}
return(ii);
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::FormActivate(TObject *Sender)
{

MainFst=NULL;MainLst=NULL;

Query->First();
 for (int i=0;i<Query->RecordCount;i++)
 {
 AddTable(Query->FieldByName("relname_master")->AsString);
 AddTable(Query->FieldByName("relname_child")->AsString);
 AddLink(Query->FieldByName("tgargs")->AsString);
 Query->Next();
 }

}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::SpeedButton2Click(TObject *Sender)
{
int len=Find->Text.Length();
 for (int i=find;i<Tree->Items->Count;i++)
 {
 AnsiString tmp=Tree->Items->Item[i]->Text;
 if (tmp.SetLength(len)==Find->Text) {find=i+1;break;}
 }

 Tree->Focused();
 Tree->Items->Item[find-1]->Selected=true;
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::FindChange(TObject *Sender)
{
find=0;
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::TreeChanging(TObject *Sender, TTreeNode *Node,
      bool &AllowChange)
{
NoddS=Node;
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::BitBtn2Click(TObject *Sender)
{
TTreeNode *Node=Nodd;
ShowMessage(IntToStr(Node->Level));
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::ListFieldsClick(TObject *Sender)
{
 TListBox *List=(TListBox*) Sender;
// ShowMessage(List->Items->get);
field=List->Items->Strings[List->ItemIndex].c_str();
field_id=List->ItemIndex;

}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::SpeedButton3Click(TObject *Sender)
{
 if (field_id>-1)
 {
  ListFields->Items->Delete(field_id);
  ListSel->Items->Add(Nodd->Text+"."+field);

 SelectFields *Struct=SelfFst,*StructNew,*StructOld=SelfLst;

 StructNew = new SelectFields;
 StructNew->field_name=Nodd->Text+"."+field;
 StructNew->where="";
 StructNew->key=false;

 if (Struct==NULL) {StructNew->prev=NULL;StructNew->next=NULL;SelfFst=StructNew;}
 else {StructOld->next=StructNew;StructNew->next=NULL;StructNew->prev=StructOld;}
 StructOld=StructNew;
 SelfLst=StructOld;

 }
field="";
field_id=-1;

}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::ListSelClick(TObject *Sender)
{
 TListBox *List=(TListBox*) Sender;
// ShowMessage(List->Items->get);
fields=List->Items->Strings[List->ItemIndex].c_str();
field_ids=List->ItemIndex;

 SelectFields *Rec=SelfFst;
 int f=0;
  while (Rec!=NULL)
  {
   if (Rec->field_name==fields)
   {
   Where->Text=Rec->where;
   if (Rec->key==true) CheckBox1->Checked=true;
   else CheckBox1->Checked=false;
   }
  Rec=Rec->next;
  }

}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::SpeedButton5Click(TObject *Sender)
{
 if (field_ids>-1)
 {
  ListSel->Items->Delete(field_ids);
   int fl=0;
   AnsiString tbl="",fld="";
   for (int i=1;i<=fields.Length();i++)
   {
    if (fields[i]=='.') fl=1;
    if (fl==0) tbl+=fields[i];
    if (fl==1&&fields[i]!='.') fld+=fields[i];
   }
  if (Nodd->Text==tbl) ListFields->Items->Add(fld);
 }

//deleting from LIST
SelectFields *Rec=SelfFst;
 int f=0;
  while (Rec!=NULL)
  {
   if (Rec->field_name==fields)
   {
   int f=0;
   SelectFields *Next=Rec->next,*Prev=Rec->prev;
   if (Rec==SelfFst) {if (Next!=NULL) SelfFst=Next; else SelfFst=NULL;f=1;}
   if (Rec==SelfLst) {if (Prev!=NULL) SelfLst=Prev; else SelfLst=NULL;f=1;}

   if (Next!=NULL&&f==0) Prev->next=Next;
   if (Prev!=NULL&&f==0) Next->prev=Prev;

   break;
   }
  Rec=Rec->next;
  }
//deleting from LIST
if (ListSel->Items->Count==0) {SelfFst=NULL;SelfLst=NULL;}
fields="";
field_ids=-1;

}
//---------------------------------------------------------------------------


void __fastcall TMake_sql::MiniTreeChanging(TObject *Sender, TTreeNode *Node,
      bool &AllowChange)
{
Nodd=Node;
select_table=Node->Text;

ListFields->Clear();

Query1->Sql->Clear();
Query1->Sql->Add("select attname from pg_attribute where attrelid in (select oid from pg_class where relname ='"+Node->Text+"')");
Query1->ExecSql();
Query1->Active=true;

Query1->First();
 for (int i=0;i<Query1->RecordCount;i++)
 {
  AnsiString field_name=Query1->FieldByName("attname")->AsString;
  if (field_name!="ctid"&&field_name!="oid"&&field_name!="xmin"&&field_name!="cmin"&&field_name!="xmax"&&field_name!="cmax"&&field_name!="tableoid")
  {
  ListFields->Items->Add(Query1->FieldByName("attname")->AsString);
  }
 Query1->Next();
 }

}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::SpeedButton8Click(TObject *Sender)
{
 SelectList *Struct=SelFst,*StructNew,*StructOld=SelLst;
 AnsiString slave_table=NoddS->Text;
 AnsiString master_table="NOLL",master_field="NOLL",slave_field="";
 StructNew = new SelectList;

MainList *Rec=MainFst;
int f=0;
while (Rec!=NULL)
 {
 if (Rec->slave_table==slave_table&&f==0)
  {slave_field=Rec->slave_field;

        SelectList *RecS=SelFst;
        while (RecS!=NULL)
         {
          if (Rec->master_table==RecS->slave_table)
          {master_table=RecS->slave_table;master_field=RecS->slave_field;f=1;break;}
          if (Rec->master_table==RecS->master_table)
          {master_table=RecS->master_table;master_field=RecS->master_field;f=1;break;}
         RecS=RecS->next;
         }

  }
 Rec=Rec->next;
 }

if ((master_table!="NOLL")||(master_table=="NOLL"&&MiniTree->Items->Count==0))
{
 StructNew->slave_table=slave_table;
 StructNew->slave_field=slave_field;
 StructNew->master_table=master_table;
 StructNew->master_field=master_field;
 StructNew->done=false;
 StructNew->from=false;

 if (Struct==NULL) {StructNew->prev=NULL;StructNew->next=NULL;SelFst=StructNew;}
 else {StructOld->next=StructNew;StructNew->next=NULL;StructNew->prev=StructOld;}
 StructOld=StructNew;
 SelLst=StructOld;
}//of if
if (master_table=="NOLL"&&MiniTree->Items->Count>0)
{
master_table=NoddS->Text;master_field="NOLL";slave_table="NOLL";slave_field="NOLL";
Rec=MainFst;
f=0;
while (Rec!=NULL)
 {
 if (Rec->master_table==master_table&&f==0)
  {master_field=Rec->master_field;

        SelectList *RecS=SelFst;
        while (RecS!=NULL)
         {
          if (Rec->slave_table==RecS->master_table)
          {slave_table=RecS->master_table;slave_field=RecS->master_field;f=1;break;}
          if (Rec->slave_table==RecS->slave_table)
          {slave_table=RecS->slave_table;slave_field=RecS->slave_field;f=1;break;}
         RecS=RecS->next;
         }

  }
 Rec=Rec->next;
 }

 StructNew->slave_table=slave_table;
 StructNew->slave_field=slave_field;
 StructNew->master_table=master_table;
 StructNew->master_field=master_field;
 StructNew->done=false;
 StructNew->from=false;

 if (Struct==NULL) {StructNew->prev=NULL;StructNew->next=NULL;SelFst=StructNew;}
 else {StructOld->next=StructNew;StructNew->next=NULL;StructNew->prev=StructOld;}
 StructOld=StructNew;
 SelLst=StructOld;
}// else of if master_table!=NULL
 MiniTree->Items->Clear();

SelectList *RecS=SelFst;
 while (RecS!=NULL)
 {
 RecS->done=false;
//ShowMessage(RecS->slave_table+"->"+RecS->master_table);
 RecS=RecS->next;
 }

 DrawMiniTree();
}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::DrawMiniTree()
{
SelectList *Rec=SelFst;
int f=0;
 while (Rec!=NULL)
 {
 RecordS=Rec;
        SelectList *Rec1=SelFst;
        f=0;
         while (Rec1!=NULL)
         {
         if (Rec1->slave_table==Rec->slave_table&&Rec1->master_table==Rec->master_table&&Rec1->done==true) {f=1;break;}
         Rec1=Rec1->next;
         }
 if (Rec->done==false&&f==0) AddToMiniTree(Rec->slave_table,Rec->master_table);
 Rec=Rec->next;
 }

/*Rec=SelFst;
 while (Rec!=NULL)
 {
 RecordS=Rec;
        SelectList *Rec1=SelFst;
        f=0;
         while (Rec1!=NULL)
         {
         if (Rec1->slave_table==Rec->slave_table&&Rec1->master_table==Rec->master_table&&Rec1->done==true) {f=1;break;}
         Rec1=Rec1->next;
         }
 if (Rec->done==false&&f==0) AddToMiniTree(Rec->slave_table,Rec->master_table);
 Rec=Rec->next;
 }
*/
}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::AddToMiniTree(AnsiString parent,AnsiString child)
{
if (child!=parent)
{
//if (child=="eqm_equipment_tbl"&&Record->done==true) ShowMessage("PARENT="+parent+"; CHILD="+child+" record->parent_t=TRUE");
//if (child=="eqm_equipment_tbl"&&Record->done==false) ShowMessage("PARENT="+parent+"; CHILD="+child+" record->parent_t=FALSE");

SelectList *Rec=SelFst;
int ptr=-1;
 for (int i=0;i<MiniTree->Items->Count;i++)
 {
  if (MiniTree->Items->Item[i]->Text==parent) ptr=i;
 }

 if (ptr>-1)//parent is present
 {
  MiniTree->Items->AddChild(MiniTree->Items->Item[ptr],child);
  RecordS->done=true;
 }//parent is present
 else//parent is not present
 {
  SelectList *Rec=SelFst;
  int f=0;
   while (Rec!=NULL)
   {
   if (Rec->master_table==parent) {f=1;RecordS=Rec;break;}
   Rec=Rec->next;
   }
   if (parent=="NOLL") f=0;
   if (f==1) AddToMiniTree(Rec->slave_table,Rec->master_table);
   else {
if (parent!="NOLL") MiniTree->Items->Add(NULL,parent);
         int p=GetIndex(parent,MiniTree);
if (child!="NOLL"&&parent!="NOLL") MiniTree->Items->AddChild(MiniTree->Items->Item[p],child);
if (child!="NOLL"&&parent=="NOLL") MiniTree->Items->Add(NULL,child);

        }
 }//parent is not present

RecordS->done=true;
MiniTree->FullExpand();
}//if child!=parent
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::SpeedButton9Click(TObject *Sender)
{
MiniTree->Items->Clear();
ListFields->Items->Clear();
ListSel->Items->Clear();
SelFst=NULL;SelLst=NULL;
/*if (select_table!="")
{
MiniTree->Items->Clear();

SelectList *RecS=SelFst;
 while (RecS!=NULL)
 {
 RecS->done=false;
  if (RecS->slave_table==select_table)
  {
try {
   SelectList *Prev=RecS->prev,*Next=RecS->next;
   if (Next!=NULL) Prev->next=Next;
   if (Prev!=NULL) Next->prev=Prev;

   if (RecS==SelFst) {if (Next!=NULL) SelFst=Next; else SelFst=NULL;}
   if (RecS==SelLst) {if (Prev!=NULL) SelLst=Prev; else SelLst=NULL;}
   select_table="";
    }
__except(1) {}
  }
 RecS=RecS->next;
 }

DrawMiniTree();
}
*/
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::SpeedButton7Click(TObject *Sender)
{
from_glob="";
for (int i=0;i<50;i++) arr_tab[i]=0;
cnt_tab=0;

int count=MiniTree->Items->Count;
int level=-1;
AnsiString root="";
 for (int i=0;i<count;i++)
 {
  if (MiniTree->Items->Item[i]->Level>level) {level=MiniTree->Items->Item[i]->Level;root=MiniTree->Items->Item[i]->Text;}
 }

AnsiString select="",where="",from="";
int rez=0;
if (ListSel->Items->Count>0)
{
 rez=1;
//making SELECT
 for (int i=0;i<ListSel->Items->Count;i++)
 {
 AnsiString tmp=ListSel->Items->Strings[i].c_str();
 if (ListSel->Checked[i]==true) select=select+tmp+", ";
 }
//making SELECT

//making FROM (trivial)
if (MiniTree->Items->Count==1)
{from_glob+=MiniTree->Items->Item[0]->Text;}
//making FROM (trivial)
//making FROM (hard)
 if (MiniTree->Items->Count>1)
 {
 SelectList *Rec=SelFst;

 int f=0;

  while (Rec!=NULL)
  {if (f==0) {from=root;f=1;}
   if (Rec->master_table==root)
   {
   from_glob="("+Rec->slave_table+" INNER JOIN "+from+" ON "+Rec->slave_table+"."+Rec->slave_field+"="+Rec->master_table+"."+Rec->master_field+")";
   from="("+Rec->slave_table+" INNER JOIN "+from+" ON "+Rec->slave_table+"."+Rec->slave_field+"="+Rec->master_table+"."+Rec->master_field+")";
   AddToArr(Rec->master_table);
   AddToArr(Rec->slave_table);
   Rec->from=true;
   }
  Rec=Rec->next;
  }

  Rec=SelFst;
  while (Rec!=NULL)
  {
  if (Rec->from==false&&Rec->master_table!="NOLL"&&Rec->slave_table!="NOLL") from=AddToFrom(from,Rec->master_table,Rec->slave_table);
  Rec=Rec->next;
  }

 }
//making FROM (hard)
//making WHERE
 SelectFields *Rec=SelfFst;
 int f=0;
  while (Rec!=NULL)
  {
   if (Rec->where!="") where+=Rec->field_name+Rec->where+" and ";
   if (Rec->key==true) where+=Rec->field_name+"=% and ";
  Rec=Rec->next;
  }
//making WHERE
}
else {ShowMessage("Выберите поля для отбора");}

select.SetLength(select.Length()-2);
where.SetLength(where.Length()-4);
if (where!="") where=" WHERE "+where;

if (rez==1) {AnsiString tmp="SELECT "+select+" FROM "+from_glob+where;Memo1->Text=tmp;}
}
//---------------------------------------------------------------------------
AnsiString __fastcall TMake_sql::AddToFrom(AnsiString from,AnsiString master_table,AnsiString slave_table)
{
 int f=0;
 AnsiString from1=from;
 for (int i=0;i<cnt_tab;i++)
 {
  if (arr_tab[i]==master_table) f=1;
 }

 AnsiString master_field="",slave_field="";
 SelectList *Rec=SelFst;
  while (Rec!=NULL)
  {
   if (Rec->master_table==master_table&&Rec->slave_table==slave_table) {master_field=Rec->master_field;slave_field=Rec->slave_field;}
   Rec=Rec->next;
  }

   if (f==1)
     {
     from1="("+slave_table+" INNER JOIN "+from+" ON "+slave_table+"."+slave_field+"="+master_table+"."+master_field+")";
     }
   if (f==0)
   {
    AnsiString master_new="";
    SelectList *Rec=SelFst;
    while (Rec!=NULL)
     {
     if (Rec->slave_table==master_table) {if (master_new!="NOLL") master_new=Rec->master_table;}
     Rec=Rec->next;
     }
     if (master_new==""||master_new=="NOLL") {ShowMessage("Не все таблицы имеют связи");}
     else {AddToFrom(from1,master_new,master_table);}
   }


from_glob="("+slave_table+" INNER JOIN "+from_glob+" ON "+slave_table+"."+slave_field+"="+master_table+"."+master_field+")";
     AddToArr(master_table);
     AddToArr(slave_table);

 Rec=SelFst;
  while (Rec!=NULL)
  {
   if (Rec->master_table==master_table&&Rec->slave_table==slave_table) {Rec->from=true;}
   Rec=Rec->next;
  }

return from1;
}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::AddToArr(AnsiString table)
{
int f=0;
 for (int i=0;i<cnt_tab;i++)
 {
  if (arr_tab[i]==table) f=1;
 }

 if (f==0) {arr_tab[cnt_tab]=table;cnt_tab++;}
}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::SpeedButton10Click(TObject *Sender)
{
MainList *Rec=MainFst;
int f=0;
 while (Rec!=NULL)
 {
 Record=Rec;
        MainList *Rec1=MainFst;
        f=0;
         while (Rec1!=NULL)
         {
         if (Rec1->slave_table==Rec->slave_table&&Rec1->master_table==Rec->master_table&&Rec1->done==true) {f=1;break;}
         Rec1=Rec1->next;
         }
 if (Rec->done==false&&f==0) AddToTree(Rec->slave_table,Rec->master_table);
 Rec=Rec->next;
 }

Rec=MainFst;
 while (Rec!=NULL)
 {
 Record=Rec;
        MainList *Rec1=MainFst;
        f=0;
         while (Rec1!=NULL)
         {
         if (Rec1->slave_table==Rec->slave_table&&Rec1->master_table==Rec->master_table&&Rec1->done==true) {f=1;break;}
         Rec1=Rec1->next;
         }
 if (Rec->done==false&&f==0) AddToTree(Rec->slave_table,Rec->master_table);
 Rec=Rec->next;
 }


}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::Button1Click(TObject *Sender)
{
 SelectFields *Rec=SelfFst;
 int f=0;
  while (Rec!=NULL)
  {
   if (Rec->field_name==fields)
   {
   Rec->where=Where->Text;
   if (CheckBox1->Checked) Rec->key=true;
   else Rec->key=false;
   break;
   }
  Rec=Rec->next;
  }

}
//---------------------------------------------------------------------------
void __fastcall TMake_sql::SpeedButton11Click(TObject *Sender)
{
 SelectFields *Rec=SelfFst;
 int f=0;
  while (Rec!=NULL)
  {
  ShowMessage(Rec->field_name);
  Rec=Rec->next;
  }
}
//---------------------------------------------------------------------------



void __fastcall TMake_sql::FormClose(TObject *Sender, TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);        
}
//---------------------------------------------------------------------------

void __fastcall TMake_sql::SpeedButton4Click(TObject *Sender)
{
Doc_temp->AddField(Memo1->Text,Edit1->Text);
Make_sql->Close();        
}
//---------------------------------------------------------------------------

