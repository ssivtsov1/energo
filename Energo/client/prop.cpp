//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "prop.h"
//#include "data.h"
#include "client_main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TClient_par *Client_par;
int id_param,id_next,flag;
int len3,len1,len33;
AnsiString tmp13,tmp23,text3,tmp11,tmp21,text1,tmp133,tmp233,text33;
//---------------------------------------------------------------------------
__fastcall TClient_par::TClient_par(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TClient_par::TreeChange(TObject *Sender,
      TTreeNode *Node)
{
Panel4Prop->Visible=true;
Panel4Add->Visible=false;
Panel4Ins->Visible=false;

 if (Node->StateIndex>0)
 {
  id_param=Node->StateIndex;
  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select c.val, c.term, c.len, s.name from cla_param_tbl c, syi_type_tbl s where c.id="+IntToStr(Node->StateIndex)+" and c.id_type=s.id");
  Client->Query->ExecSql();
  Client->Query->Active=true;

  Memo3->Clear();
  Memo3->Font->Color=clBlack;

//  if (Client->Query->FieldByName("term")->AsInteger!=2)
//  {
   AnsiString ttt=Client->Query->FieldByName("val")->AsString;
   Memo3->MaxLength=Client->Query->FieldByName("len")->AsInteger+1;
   len33=Memo3->MaxLength-1;

   text33="";
   for (int i=0;i<len33-ttt.Length();i++)
   {
   text33+="_";
   }

   tmp133=ttt+text33;
   tmp233=ttt+text33;

   Memo3->Clear();
   Memo3->Text=ttt+text33;
//  }

  ComboBox3->Text=Client->Query->FieldByName("name")->AsString;
 }
 else
 {
  id_param=0;
 }
}
//---------------------------------------------------------------------------
void __fastcall TClient_par::AddButClick(TObject *Sender)
{
Memo1->Clear();
Edit1->Text="";
Edit4->Text="0";

if (Tree->Items->Count<=0) id_param=0;
Panel4Prop->Visible=false;
Panel4Add->Visible=true;
Panel4Ins->Visible=false;

}
//---------------------------------------------------------------------------
void __fastcall TClient_par::InsButClick(TObject *Sender)
{
flag=0;
NextPar->Items->Clear();
Memo2->Clear();
Edit2->Text="";
Edit3->Text="0";
Memo2->MaxLength=0;

if (Tree->Items->Count<=0) id_param=0;
Panel4Prop->Visible=false;
Panel4Add->Visible=false;
Panel4Ins->Visible=true;
  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select * from cla_param_tbl where id_parent="+IntToStr(id_param));
  Client->Query->ExecSql();
  Client->Query->Active=true;

if (Client->Query->RecordCount>0)
{
  TListItem  *ListItem;
   for (int i=0;i<Client->Query->RecordCount;i++)
   {
    ListItem = NextPar->Items->Add();
    ListItem->Caption = Client->Query->FieldByName("id")->AsString;
    ListItem->StateIndex = Client->Query->FieldByName("id")->AsInteger;
    Client->Query->Next();
 RadioButton1->Checked=true;
 RadioButton2->Enabled=true;
 NextPar->Enabled=true;

   }
}
else
{
 RadioButton1->Checked=true;
 RadioButton2->Enabled=false;
 NextPar->Enabled=false;
}

}
//---------------------------------------------------------------------------
void __fastcall TClient_par::FormCreate(TObject *Sender)
{
Panel4Prop->Align=alClient;
Panel4Add->Align=alClient;
Panel4Ins->Align=alClient;
Panel4Prop->Visible=false;
Panel4Add->Visible=false;
Panel4Ins->Visible=false;

}
//---------------------------------------------------------------------------
int __fastcall TClient_par::GetIndex(AnsiString str, TTreeView *Tree)
{
int i=-1,f=0;
for (i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;break;}
}
return(i);
}
//----------------------------------------------------------------------------
// процедура создания дерева клмпонентов документа
void __fastcall TClient_par::MakeTree()
{
Tree->Items->Clear();
  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select * from cla_param_tbl order by lev");
  Client->Query->ExecSql();
  Client->Query->Active=true;

for (int i=0;i<Client->Query->RecordCount;i++)
{
int id=Client->Query->FieldByName("id")->AsInteger;
int id_parent=Client->Query->FieldByName("id_parent")->AsInteger;

 if (id_parent==0) {
  Tree->Items->Add(NULL,id);
  int ptr=GetIndex(IntToStr(id),Tree);
  Tree->Items->Item[ptr]->StateIndex=id;
  }
 else
 {
  int ptr=GetIndex(IntToStr(id_parent),Tree);
  if (ptr!=-1) {Tree->Items->AddChild(Tree->Items->Item[ptr],IntToStr(id));
                ptr=GetIndex(IntToStr(id),Tree);
                Tree->Items->Item[ptr]->StateIndex=id;
               }
 }
Client->Query->Next();
}

//Именование элементов дерева
for (int i=0;i<Tree->Items->Count;i++)
   {
    Client->Query->Sql->Clear();
    Client->Query->Sql->Add("select name from cla_param_tbl where id="+Tree->Items->Item[i]->Text);
    Client->Query->ExecSql();
    Client->Query->Active=true;
    Tree->Items->Item[i]->Text=Client->Query->FieldByName("name")->AsString;
   }

Tree->FullExpand();
}
//-----------------------------------------------------------------------------------------------------

void __fastcall TClient_par::FormActivate(TObject *Sender)
{
ComboBox1->Clear();
ComboBox2->Clear();
ComboBox3->Clear();

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select * from syi_type_tbl where not name=null");
  Client->Query->ExecSql();
  Client->Query->Active=true;

  for (int i=0;i<Client->Query->RecordCount;i++)
   {
    ComboBox1->Items->Add(Client->Query->FieldByName("name")->AsString);
    ComboBox2->Items->Add(Client->Query->FieldByName("name")->AsString);
    ComboBox3->Items->Add(Client->Query->FieldByName("name")->AsString);
    Client->Query->Next();
   }

MakeTree();
id_param=0;
flag=0;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::SpeedButton5Click(TObject *Sender)
{
Tree->SetFocus();
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::SpeedButton4Click(TObject *Sender)
{

AnsiString parent="";
if (id_param==0) parent="NULL";
else parent=IntToStr(id_param);
int id_type=0;

if (Simple->Checked) parent="NULL";
Simple->Checked=false;

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select id from syi_type_tbl where name='"+ComboBox1->Text+"'");
  Client->Query->ExecSql();
  Client->Query->Active=true;
  id_type=Client->Query->FieldByName("id")->AsInteger;

AnsiString ttt1=Memo1->Text,ttt="";
for (int i=1;i<=ttt1.Length();i++)
{
if (ttt1[i]!='_') ttt+=ttt1[i];
}

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("insert into cla_param_tbl(id_parent,id_type,val,name,len) values("+parent+","+IntToStr(id_type)+",'"+ttt+"','"+Edit1->Text+"',"+IntToStr(Memo1->MaxLength-1)+")");
  Client->Query->ExecSql();

Memo1->Clear();
MakeTree();
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::DelButClick(TObject *Sender)
{
if (id_param!=0)
  {
  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select uninc_lev("+IntToStr(id_param)+")");
  Client->Query->ExecSql();

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select del_param("+IntToStr(id_param)+")");
  Client->Query->ExecSql();
  }

MakeTree();

 if (Tree->Items->Count<=0)
 {
  Panel4Prop->Visible=false;
  Panel4Add->Visible=false;
  Panel4Ins->Visible=false;
 }
}
//---------------------------------------------------------------------------


void __fastcall TClient_par::RadioButton1Click(TObject *Sender)
{
 flag=1;
 id_next=0;
 NextPar->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::RadioButton2Click(TObject *Sender)
{
 flag=0;
 NextPar->Enabled=true;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::NextParChange(TObject *Sender,
      TListItem *Item, TItemChange Change)
{
flag=1;
id_next=Item->StateIndex;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::SpeedButton7Click(TObject *Sender)
{
int id_type=0;

if (flag==1)
{
if (id_param!=0)
  {
  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select id from syi_type_tbl where name='"+ComboBox2->Text+"'");
  Client->Query->ExecSql();
  Client->Query->Active=true;
  id_type=Client->Query->FieldByName("id")->AsInteger;

AnsiString ttt1=Memo2->Text,ttt="";
for (int i=1;i<=ttt1.Length();i++)
{
if (ttt1[i]!='_') ttt+=ttt1[i];
}

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select ins_param("+IntToStr(id_param)+","+IntToStr(id_type)+","+IntToStr(id_next)+",'"+ttt+"','"+Edit2->Text+"',"+Memo2->MaxLength+")");
  Client->Query->ExecSql();
  }

MakeTree();
}

 if (Tree->Items->Count<=0)
 {
  Panel4Prop->Visible=false;
  Panel4Add->Visible=false;
  Panel4Ins->Visible=false;
 }
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::SpeedButton9Click(TObject *Sender)
{
  int id=id_param;

AnsiString ttt1=Memo3->Text,ttt="";
for (int i=1;i<=ttt1.Length();i++)
{
if (ttt1[i]!='_') ttt+=ttt1[i];
}

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("update cla_param_tbl set val='"+ttt+"' where id="+IntToStr(id_param));
  Client->Query->ExecSql();

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("update cla_param_tbl set term=1 where id="+IntToStr(id_param));
  Client->Query->ExecSql();

  MakeTree();

//  Tree->Items->Item[0]->Selected=true;
  for (int i=0;i<Tree->Items->Count;i++)
  {
   if (Tree->Items->Item[i]->StateIndex==id) {Tree->Items->Item[i]->Selected=true;Tree->Items->Item[i]->Focused=true;break;}
  }

}
//---------------------------------------------------------------------------

void __fastcall TClient_par::SpeedButton8Click(TObject *Sender)
{
  int id=id_param;

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("select id from syi_type_tbl where name='"+ComboBox3->Text+"'");
  Client->Query->ExecSql();
  Client->Query->Active=true;
  int id_type=Client->Query->FieldByName("id")->AsInteger;

  Client->Query->Sql->Clear();
  Client->Query->Sql->Add("update cla_param_tbl set id_type="+IntToStr(id_type)+" where id="+IntToStr(id_param));
  Client->Query->ExecSql();


  MakeTree();

  for (int i=0;i<Tree->Items->Count;i++)
  {
   if (Tree->Items->Item[i]->StateIndex==id) {Tree->Items->Item[i]->Selected=true;Tree->Items->Item[i]->Focused=true;break;}
  }

}
//---------------------------------------------------------------------------

void __fastcall TClient_par::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);


}
//---------------------------------------------------------------------------


void __fastcall TClient_par::N2Click(TObject *Sender)
{
Client_par->Close();
}
//---------------------------------------------------------------------------
void __fastcall TClient_par::Edit3Change(TObject *Sender)
{
AnsiString ttt="";
Memo2->MaxLength=StrToInt(Edit3->Text)+1;
len3=Memo2->MaxLength-1;

text3="";
for (int i=0;i<len3;i++)
{
text3+="_";
}
ttt=Memo2->Text;
tmp13=text3;
tmp23=text3;

Memo2->Clear();
Memo2->Text=ttt+text3;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::Memo2Change(TObject *Sender)
{
AnsiString tmp3=Memo2->Text;
int l3=tmp3.Length();
int cnt3=Count(tmp3);
int pos3=Memo2->SelStart+1;

if (tmp23.Length()<=tmp3.Length())
{
 if (l3>len3&&cnt3>0)
 {
  tmp3=tmp3.SubString(1,l3-1);
  tmp13=tmp3;
//  int pos=GetPos(tmp);
  Memo2->Text=tmp3;
  Memo2->SelStart=pos3-1;
 }
 else
 {
  Memo2->Text=tmp13;
 }
tmp23=Memo2->Text;
}
else
{
tmp3+="_";
tmp13=tmp3;
Memo2->Text=tmp3;
//int pos=GetPos(tmp);
Memo2->SelStart=pos3-1;
}

}
//---------------------------------------------------------------------------
int __fastcall TClient_par::Count(AnsiString tmp)
{
int cnt=0;
 for (int i=1;i<=tmp.Length();i++)
 {
  if (tmp[i]=='_') cnt++;
 }
return cnt;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::Edit4Change(TObject *Sender)
{
AnsiString ttt="";
Memo1->MaxLength=StrToInt(Edit4->Text)+1;
len1=Memo1->MaxLength-1;

text1="";
for (int i=0;i<len1;i++)
{
text1+="_";
}
ttt=Memo1->Text;
tmp11=text1;
tmp21=text1;

Memo1->Clear();
Memo1->Text=ttt+text1;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::Memo1Change(TObject *Sender)
{
AnsiString tmp1=Memo1->Text;
int l1=tmp1.Length();
int cnt1=Count(tmp1);
int pos1=Memo1->SelStart+1;

if (tmp21.Length()<=tmp1.Length())
{
 if (l1>len1&&cnt1>0)
 {
  tmp1=tmp1.SubString(1,l1-1);
  tmp11=tmp1;
//  int pos=GetPos(tmp);
  Memo1->Text=tmp1;
  Memo1->SelStart=pos1-1;
 }
 else
 {
  Memo1->Text=tmp11;
 }
tmp21=Memo1->Text;
}
else
{
tmp1+="_";
tmp11=tmp1;
Memo1->Text=tmp1;
//int pos=GetPos(tmp);
Memo1->SelStart=pos1-1;
}

}
//---------------------------------------------------------------------------

void __fastcall TClient_par::Memo3Change(TObject *Sender)
{

AnsiString tmp33=Memo3->Text;
int l33=tmp33.Length();
int cnt33=Count(tmp33);
int pos33=Memo3->SelStart+1;

if (tmp233.Length()<=tmp33.Length())
{
 if (l33>len33&&cnt33>0)
 {
  tmp33=tmp33.SubString(1,l33-1);
  tmp133=tmp33;
//  int pos=GetPos(tmp);
  Memo3->Text=tmp33;
  Memo3->SelStart=pos33-1;
 }
 else
 {
  Memo3->Text=tmp133;
 }
tmp233=Memo3->Text;
}
else
{
tmp33+="_";
tmp133=tmp33;
Memo3->Text=tmp33;
//int pos=GetPos(tmp);
Memo3->SelStart=pos33-1;
}


}
//---------------------------------------------------------------------------

void __fastcall TClient_par::DirectionClick(TObject *Sender)
{
DataCheck->Checked=true;
}
//---------------------------------------------------------------------------

void __fastcall TClient_par::SpeedButton1Click(TObject *Sender)
{
Client_par->Close();

AnsiString ttt1=Memo3->Text,ttt="";
for (int i=1;i<=ttt1.Length();i++)
{
if (ttt1[i]!='_') ttt+=ttt1[i];
}

int rez=Client->CreateParam(id_param,ttt);

 if (Direction->Checked)
 {
  if (rez==1) Client->DrawParam(id_param,2);
 }
 else
 {
  if (rez==1) Client->DrawParam(id_param,1);
 }

}
//---------------------------------------------------------------------------

