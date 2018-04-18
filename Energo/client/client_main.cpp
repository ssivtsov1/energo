//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "client_main.h"
//#include "prop.h"
#include "Client_par.h"
#include "cat_list_par.h"
#include "docu_mod.h"
#include "doc_tmp.h"
#include "Table.h"
//#include "data.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TClient *Client;
TPanel *panel;
int y,id_client;
int create_flag;

TList *EditList,*ComboList,*ButtonList,*PanelList;

typedef struct List
{
int id;
TMemo *memo;
} EdList;

typedef EdList* EList;

typedef struct CList
{
int id;
int id_param;
TComboBox *combo;
} CoList;

typedef CoList* ComList;

typedef struct BList
{
int id;
TSpeedButton *but;
} BuList;

typedef BuList* ButList;

typedef struct PList
{
int id;
TPanel *pan;
} PaList;

typedef PaList* PanList;

struct LgotList
{
int id_person;
TEdit* edit1;
TEdit* edit2;
TEdit* edit3;
TEdit* edit4;
TEdit* edit5;
TEdit* edit6;
TComboBox* combo;
LgotList* next;
};


LgotList *Fst=NULL,*Lst=NULL;
int kind_doc,id_grp,id_doc,id_document;
TWTTable* Table;
TPanel *Lgot_pan;
TPanel *Subs_pan;
//---------------------------------------------------------------------------
__fastcall TClient::TClient(TComponent* Owner)
        : TfTWTCompForm(Owner)
{

   create_flag=1;
 EditList = new TList;
 ComboList = new TList;
 ButtonList = new TList;
  //TfTWTCompForm::TfTWTCompForm(this);
  Query = new TWTQuery(Application);
  Query->MacroCheck=true;
  Query->Options<< doQuickOpen;
  Query->RequestLive=false;
  Query->CachedUpdates=false;

  Query1 = new TWTQuery(Application);
  Query1->MacroCheck=true;
  Query1->Options<< doQuickOpen;
  Query1->RequestLive=false;
  Query1->CachedUpdates=false;
  Query2 = new TWTQuery(Application);
  Query2->MacroCheck=true;
  Query2->Options<< doQuickOpen;
  Query2->RequestLive=false;
  Query2->CachedUpdates=false;
  Query3 = new TWTQuery(Application);
  Query3->MacroCheck=true;
  Query3->Options<< doQuickOpen;
  Query3->RequestLive=false;
  Query3->CachedUpdates=false;
  //OnClose=TfTWTCompForm::FormClose();
}
//---------------------------------------------------------------------------
void __fastcall TClient::PropButClick(TObject *Sender)
{
  Query1->Sql->Clear();
  Query1->Sql->Add("SELECT dci_document_tbl.id_grp, dcm_doc_tbl.id_document, dcd_doc_tbl.id_doc FROM (dcm_doc_tbl INNER JOIN dci_document_tbl ON dcm_doc_tbl.id_document = dci_document_tbl.id) INNER JOIN (dcd_doc_tbl INNER JOIN (dcm_template_tbl INNER JOIN dci_head_tbl ON dcm_template_tbl.id_head = dci_head_tbl.id) ON dcd_doc_tbl.id_elem = dcm_template_tbl.id) ON dcm_doc_tbl.id = dcd_doc_tbl.id_doc WHERE (((dcm_template_tbl.id_head)='1') AND ((dcd_doc_tbl.value)='"+IntToStr(id_client)+"'));");
  Query1->ExecSql();
  Query1->Active=true;

  kind_doc=1;
  id_grp=Query1->FieldByName("id_grp")->AsInteger;
  id_doc=Query1->FieldByName("id_doc")->AsInteger;
  id_document=Query1->FieldByName("id_document")->AsInteger;

if (id_grp!=0&&id_document!=0&&id_doc!=0)
{
  Module2DB->kind_doc=kind_doc;
  Module2DB->id_grp=id_grp;
  Module2DB->id_doc=id_document;
  Module2DB->id_document=id_doc;
Module2DB->N5Click(Sender);
Doc_temp->view=2;
Doc_temp->Refresh();
}
else
{ShowMessage("На данного клиента не создан договор");}

}
//---------------------------------------------------------------------------
void __fastcall TClient::Button1Click(TObject *Sender)
{
 Application->CreateForm(__classid(TClientPar), &ClientPar);
 ClientPar->Visible=true;
 Client->Enabled=false;
}
//---------------------------------------------------------------------------
void __fastcall TClient::Clk(TObject *Sender)
{

try {
//panel->BevelInner=bvNone;
panel->Color=clBtnFace;
}
__except(1){}

TPanel *ppp= (TPanel*) Sender;
ppp->Color=clGrayText;
//ppp->BevelInner=bvLowered;
panel=ppp;

}
//---------------------------------------------------------------------------
void __fastcall TClient::FormActivate(TObject *Sender)
{
id_client=((TMainForm*)(Application->MainForm))->InterTable->FieldByName("id")->AsInteger;

Splitter1Moved(Sender);
y=0;

Data->DataSet=((TMainForm*)(Application->MainForm))->InterDataSet;
Table=((TMainForm*)(Application->MainForm))->InterTable;
 if (create_flag==1)
  {
   PanelList = new TList;
   Static();
   DrawParams();
   create_flag=0;
  }
}
//---------------------------------------------------------------------------
void __fastcall TClient::Static()
{
  Query1->Sql->Clear();
  Query1->Sql->Add("select * from clm_client_tbl where id_department is null");
  Query1->ExecSql();
  Query1->Active=true;
 for (int i=0;i<Query1->RecordCount;i++)
 {
  Department->Items->Add(Query1->FieldByName("name")->AsString);
  Query1->Next();
 }

  Query1->Sql->Clear();
  Query1->Sql->Add("select * from clm_client_tbl where id="+IntToStr(id_client));
  Query1->ExecSql();
  Query1->Active=true;
  int id_dep=Query1->FieldByName("id_department")->AsInteger;

  Name->Text=Query1->FieldByName("name")->AsString;
  ShortName->Text=Query1->FieldByName("short_name")->AsString;

//  Fax->Text=Query1->FieldByName("fax")->AsString;

  Query1->Sql->Clear();
  Query1->Sql->Add("select * from clm_client_tbl where id="+IntToStr(id_dep));
  Query1->ExecSql();
  Query1->Active=true;

  Department->Text=Query1->FieldByName("name")->AsString;
}
//---------------------------------------------------------------------------
void __fastcall TClient::SpeedButton1Click(TObject *Sender)
{
panel->Height+=StrToInt(MaskEdit1->Text);
//panel->Height+=2;
}
//---------------------------------------------------------------------------
void __fastcall TClient::SpeedButton2Click(TObject *Sender)
{
panel->Height-=StrToInt(MaskEdit1->Text);
//panel->Height-=2;
}
//---------------------------------------------------------------------------

void __fastcall TClient::Button2Click(TObject *Sender)
{

 try
 {
  TPanel* parent=(TPanel*) panel->Parent;
  if (panel->Tag>0)
  {
  Query1->Sql->Clear();
  Query1->Sql->Add("delete from clm_param_tbl where id_param="+IntToStr(panel->Tag));
  Query1->ExecSql();

  delete panel;
  panel=NULL;
  }

 }
 __except(1)
 {}
}
//---------------------------------------------------------------------------
void __fastcall TClient::DrawParams()
{
  Query3->Sql->Clear();
  Query3->Sql->Add("select * from clm_param_tbl where key=true and id_client="+IntToStr(id_client));
  Query3->ExecSql();
  Query3->Active=true;

for (int i=0;i<Query3->RecordCount;i++)
 {
  int dir=0;
  if (Query3->FieldByName("id_val")->AsInteger==1) dir=3;
  else dir=Query3->FieldByName("direction")->AsInteger;

  DrawParam(Query3->FieldByName("id_param")->AsInteger,dir);
//  ShowMessage(Query2->FieldByName("id_param")->AsString);
  Query3->Next();
 }
}
//---------------------------------------------------------------------------
void __fastcall TClient::DrawParam(int id_param, int direction)
{
  Query->Sql->Clear();
  Query->Sql->Add("select * from cla_param_tbl where id="+IntToStr(id_param));
  Query->ExecSql();
  Query->Active=true;
int lev=Query->FieldByName("lev")->AsInteger;
int term=Query->FieldByName("term")->AsInteger;
int parent=Query->FieldByName("id_parent")->AsInteger;
int len=Query->FieldByName("len")->AsInteger;
AnsiString name=Query->FieldByName("name")->AsString;
AnsiString val=Query->FieldByName("val")->AsString;

if (direction==3)
{
TPanel* pan= new TPanel(ScrollBox1);
pan->Parent=ScrollBox1;
pan->Height=40;

pan->Align=alTop;
pan->OnClick=Clk;
pan->Tag=id_param;

        PanList PStruct;
        PStruct = new PaList;
        PStruct->id = id_param;
        PStruct->pan=pan;
        PanelList->Add(PStruct);

AnsiString param=StrToInt(id_param),str="",name="";
for (int i=lev;i>0;i--)
{
  Query->Sql->Clear();
  Query->Sql->Add("select * from cla_param_tbl where id='"+param+"'");
  Query->ExecSql();
  Query->Active=true;

  param=Query->FieldByName("id_parent")->AsString;
  if (i>1) str+=Query->FieldByName("name")->AsString+" ";
  if (Query->FieldByName("lev")->AsInteger==1) {name=Query->FieldByName("name")->AsString+" ";break;}
}

 TLabel *label= new TLabel(pan);
 label->Parent=pan;
 label->Left=5;
 label->Caption=name;
 label->Top=5;

 TComboBox *combo= new TComboBox(pan);
 combo->Parent=pan;
 combo->Width=(Client->Width/3)*2-50;
 combo->Height=50;
 combo->Left=Client->Width/3;
 combo->Top=5;
 combo->Text=str;

  Query->Sql->Clear();
  Query->Sql->Add("select * from cla_param_tbl where id_parent in (select id_parent from cla_param_tbl where id="+IntToStr(id_param)+")");
  Query->ExecSql();
  Query->Active=true;
   for (int i=0;i<Query->RecordCount;i++)
   {
   combo->Items->Add(Query->FieldByName("name")->AsString);
   Query->Next();
   }

  TSpeedButton *butt= new TSpeedButton(pan);
  butt->Parent=pan;
  butt->Glyph=SpeedButton3->Glyph;
  butt->Flat=true;
  butt->Top=5;
  butt->Left=Client->Width/3+(Client->Width/3)*2-50;
  butt->Tag=id_param;
  butt->OnClick=SpClick;

 ComList Struct1;
 Struct1 = new CoList;
 Struct1->id = StrToInt(parent);
 Struct1->id_param = id_param;
 Struct1->combo=combo;
 ComboList->Add(Struct1);

}

if (direction!=3)
{
int plus=0;
if (direction==2)
{
  Query->Sql->Clear();
  Query->Sql->Add("select count(id_param) from clm_param_tbl where id_parent="+IntToStr(id_param)+" and id_client="+IntToStr(id_client));
  Query->ExecSql();
  Query->Active=true;
plus=Query->FieldByName("count")->AsInteger;
}

TPanel* pan= new TPanel(ScrollBox1);
pan->Parent=ScrollBox1;
//pan->Caption=IntToStr(id_param);
if (direction==2) pan->Height=60+plus*60;
else pan->Height=40*lev+20;

pan->Align=alTop;
pan->OnClick=Clk;
pan->Tag=id_param;

        PanList PStruct;
        PStruct = new PaList;
        PStruct->id = id_param;
        PStruct->pan=pan;
        PanelList->Add(PStruct);

TMemo *edit;
TSpeedButton* butt;
if (direction!=2)
{
 edit= new TMemo(pan);
 edit->Parent=pan;
 edit->Width=(Client->Width/3)*2-50;
 edit->Height=50;
 edit->Left=Client->Width/3;
 edit->Top=5+((lev-1)*40);
 edit->ScrollBars=ssVertical;
 edit->MaxLength=len;

  butt= new TSpeedButton(pan);
  butt->Parent=pan;
  butt->Glyph=SpeedButton3->Glyph;
  butt->Flat=true;
  butt->Top=5+((lev-1)*40);
  butt->Left=Client->Width/3+(Client->Width/3)*2-50;
  butt->Tag=id_param;
  butt->OnClick=SpeedClick;

 TLabel *label= new TLabel(pan);
 label->Parent=pan;
 label->Left=5;
 label->Caption=name;
 label->Top=5+((lev-1)*40);
}
else
{
 edit= new TMemo(pan);
 edit->Parent=pan;
 edit->Width=(Client->Width/3)*2-50;
 edit->Height=50;
 edit->Left=Client->Width/3;
 edit->Top=5;
 edit->ScrollBars=ssVertical;
 edit->MaxLength=len;

   butt= new TSpeedButton(pan);
   butt->Parent=pan;
   butt->Glyph=SpeedButton3->Glyph;
   butt->Flat=true;
   butt->Top=5;
   butt->Left=Client->Width/3+(Client->Width/3)*2-50;
   butt->Tag=id_param;
   butt->OnClick=SpeedClick;

 TLabel *label= new TLabel(pan);
 label->Parent=pan;
 label->Left=5;
 label->Caption=name;
 label->Top=5;

  Query->Sql->Clear();
  Query->Sql->Add("select * from clm_param_tbl where id_parent="+IntToStr(id_param)+" and id_client="+IntToStr(id_client));
  Query->ExecSql();
  Query->Active=true;

  for (int i=0;i<Query->RecordCount;i++)
   {
    TMemo *memo= new TMemo(pan);
    memo->Parent=pan;
    memo->Width=(Client->Width/3)*2-50;
    memo->Height=50;
    memo->Left=Client->Width/3;
    memo->Top=(i+1)*60;
    memo->ScrollBars=ssVertical;
    memo->Text=Query->FieldByName("val")->AsString;

  TSpeedButton* but= new TSpeedButton(pan);
  but->Parent=pan;
  but->Glyph=SpeedButton3->Glyph;
  but->Flat=true;
  but->Top=(i+1)*60;
  but->Left=Client->Width/3+(Client->Width/3)*2-50;
  but->Tag=Query->FieldByName("id_param")->AsInteger;
  but->OnClick=SpeedClick;

        ButList BStruct;
        BStruct = new BuList;
        BStruct->id = Query->FieldByName("id_param")->AsInteger;
        BStruct->but=but;
        ButtonList->Add(BStruct);

        EList Struct;
        Struct = new EdList;
        Struct->id = Query->FieldByName("id_param")->AsInteger;
        Struct->memo=memo;
        EditList->Add(Struct);

  Query2->Sql->Clear();
  Query2->Sql->Add("select name,len from cla_param_tbl where id="+Query->FieldByName("id_param")->AsString);
  Query2->ExecSql();
  Query2->Active=true;

    TLabel *lab= new TLabel(pan);
    lab->Parent=pan;
    lab->Left=5;
    lab->Caption=Query2->FieldByName("name")->AsString;
    lab->Top=(i+1)*60;

    memo->MaxLength=Query2->FieldByName("len")->AsInteger;
    Query->Next();
    }
}
        ButList BStruct;
        BStruct = new BuList;
        BStruct->id = id_param;
        BStruct->but=butt;
        ButtonList->Add(BStruct);

        EList Struct;
        Struct = new EdList;
        Struct->id = id_param;
        Struct->memo=edit;
        EditList->Add(Struct);

if (term==2)
{
  Query->Sql->Clear();
  Query->Sql->Add("select * from clm_param_tbl where id_param="+IntToStr(id_param)+" and id_client="+IntToStr(id_client));
  Query->ExecSql();
  Query->Active=true;
edit->Text=Query->FieldByName("val")->AsString;
}
else
{
edit->Text=val;
}

//создаем и заполняем комбобокс текстом
//*****************************************************************************
if (direction!=2)
{
AnsiString parent1=IntToStr(parent);
for (int i=lev-1;i>0;i--)
{
AnsiString id_parent="";
name="";

AnsiString val1="",val2="";
  Query->Sql->Clear();
  Query->Sql->Add("select a.id_parent, a.val as val1, m.val as val2, a.name from cla_param_tbl a, clm_param_tbl m where a.id="+parent1+" and a.id=m.id_param");
  Query->ExecSql();
  Query->Active=true;

 if (Query->RecordCount==0)
 {
  Query->Sql->Clear();
  Query->Sql->Add("select id_parent, val, name from cla_param_tbl where id="+parent1);
  Query->ExecSql();
  Query->Active=true;
  id_parent=Query->FieldByName("id_parent")->AsString;
  val1=Query->FieldByName("val")->AsString;
  val2="";
 }
 else
 {
  id_parent=Query->FieldByName("id_parent")->AsString;
  val1=Query->FieldByName("val1")->AsString;
  val2=Query->FieldByName("val2")->AsString;
 }
 name=Query->FieldByName("name")->AsString;
 if (id_parent=="") id_parent="NULL";

 TComboBox *combo= new TComboBox(pan);
 combo->Parent=pan;
 combo->Width=(Client->Width/3)*2-50;
 combo->Height=50;
 combo->Left=Client->Width/3;
 combo->Top=((i-1)*40)+5;

        ComList Struct1;
        Struct1 = new CoList;
        Struct1->id = StrToInt(parent);
        Struct1->combo=combo;
        ComboList->Add(Struct1);

 TLabel *label= new TLabel(pan);
 label->Parent=pan;
 label->Left=5;
 label->Caption=name;
 label->Top=5+((i-1)*40);

  Query->Sql->Clear();
  Query->Sql->Add("select id, val from cla_param_tbl where id_parent="+id_parent);
  Query->ExecSql();
  Query->Active=true;

 for (int j=0;j<Query->RecordCount;j++)
 {
 AnsiString val33="";
 val33=Query->FieldByName("val")->AsString;
 if (val33=="")
 {
  Query2->Sql->Clear();
  Query2->Sql->Add("select val from clm_param_tbl where id_param="+Query->FieldByName("id")->AsString);
  Query2->ExecSql();
  Query2->Active=true;
 val33=Query2->FieldByName("val")->AsString;
 }
 combo->Items->Add(val33);
 Query->Next();
 }

if (val1!="") combo->Text=val1;
else combo->Text=val2;

parent1=id_parent;
}

}//if direction!=2


}//if direction!=3
}
//---------------------------------------------------------------------------
int __fastcall TClient::CreateParamN(int id_param)
{
try
{
  Query->Sql->Clear();
  Query->Sql->Add("insert into clm_param_tbl(id_client,id_param,key,id_val) values("+IntToStr(id_client)+","+IntToStr(id_param)+",'true',1)");
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("update cla_param_tbl set term=1 where id="+IntToStr(id_param));
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("select get_tree("+IntToStr(id_param)+","+IntToStr(id_client)+");");
  Query->ExecSql();


 return 2;
}//of try
__except(1){ShowMessage("Параметр уже существует на карточке этого клиента");return 0;}

}
//---------------------------------------------------------------------------
int __fastcall TClient::CreateParam(int id_param, AnsiString value)
{
try
{
if (ClientPar->DataCheck->Checked)
 {
  if (ClientPar->Direction->Checked)
  {
  Query->Sql->Clear();
  Query->Sql->Add("insert into clm_param_tbl(id_client,id_param,val,key,direction) values("+IntToStr(id_client)+","+IntToStr(id_param)+",'"+value+"','true',2)");
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("update cla_param_tbl set term=2 where id="+IntToStr(id_param));
  Query->ExecSql();
  Query->Sql->Clear();
  Query->Sql->Add("update cla_param_tbl set val=null where id="+IntToStr(id_param));
  Query->ExecSql();

    Query1->Sql->Clear();
    Query1->Sql->Add("delete from clm_tmp_tbl where usrnm='osa'");
    Query1->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("select lstclm_pr("+IntToStr(id_param)+")");
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("select * from clm_tmp_tbl where usrnm='osa'");
  Query->ExecSql();
  Query->Active=true;

  for (int i=0;i<Query->RecordCount;i++)
   {
    Query1->Sql->Clear();
    Query1->Sql->Add("insert into clm_param_tbl(id_client,id_param,val,key,id_parent) values("+IntToStr(id_client)+","+Query->FieldByName("id")->AsString+",'"+Query->FieldByName("val")->AsString+"','false',"+IntToStr(id_param)+")");
    Query1->ExecSql();

    Query1->Sql->Clear();
    Query1->Sql->Add("update cla_param_tbl set term=2 where id="+Query->FieldByName("id")->AsString);
    Query1->ExecSql();
    Query1->Sql->Clear();
    Query1->Sql->Add("update cla_param_tbl set val=null where id="+Query->FieldByName("id")->AsString);
    Query1->ExecSql();
   Query->Next();
   }
  }
  else
  {
  Query->Sql->Clear();
  Query->Sql->Add("insert into clm_param_tbl(id_client,id_param,val,key) values("+IntToStr(id_client)+","+IntToStr(id_param)+",'"+value+"','true')");
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("update cla_param_tbl set term=2 where id="+IntToStr(id_param));
  Query->ExecSql();
  Query->Sql->Clear();
  Query->Sql->Add("update cla_param_tbl set val=null where id="+IntToStr(id_param));
  Query->ExecSql();
  }
 }
else
 {
  if (ClientPar->Direction->Checked)
  {
  }
  else
  {
  Query->Sql->Clear();
  Query->Sql->Add("insert into clm_param_tbl(id_client,id_param,key) values("+IntToStr(id_client)+","+IntToStr(id_param)+",'true')");
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("update cla_param_tbl set term=1 where id="+IntToStr(id_param));
  Query->ExecSql();
  }
 }

  Query->Sql->Clear();
  Query->Sql->Add("select get_tree("+IntToStr(id_param)+","+IntToStr(id_client)+");");
  Query->ExecSql();

 return 1;
}//of try
__except(1){ShowMessage("Параметр уже существует на карточке этого клиента");return 0;}
}
//---------------------------------------------------------------------------
/*void __fastcall TClient::FormCreate(TObject *Sender)
{
 create_flag=1;
 EditList = new TList;
 ComboList = new TList;
 ButtonList = new TList;
  //TfTWTCompForm::TfTWTCompForm(this);

} */
//---------------------------------------------------------------------------

void __fastcall TClient::FormResize(TObject *Sender)
{
 EList Struct;
 for (int i=0;i<EditList->Count;i++)
  {
   Struct = (EList) EditList->Items[i];
   Struct->memo->Width=(Client->Width/3)*2-50;
   Struct->memo->Left=Client->Width/3;
  }

 ComList Struct1;
 for (int i=0;i<ComboList->Count;i++)
 {
 Struct1 = (ComList) ComboList->Items[i];
 Struct1->combo->Width=(Client->Width/3)*2-50;
 Struct1->combo->Left=Client->Width/3;
 }

 ButList BStruct;
 for (int i=0;i<ButtonList->Count;i++)
 {
 BStruct = (ButList) ButtonList->Items[i];
 BStruct->but->Left=Client->Width/3+(Client->Width/3)*2-50;
 }

if (ScrollBox1->Height>(Client->Height-290)) ScrollBox1->Height=(Client->Height-290);
}
//---------------------------------------------------------------------------


void __fastcall TClient::Splitter1Moved(TObject *Sender)
{
//if (ScrollBox1->Height>(Client->Height-290))
ScrollBox1->Height=(Client->Height-160);
}
//---------------------------------------------------------------------------


void __fastcall TClient::SaveClick(TObject *Sender)
{
TButton *but=(TButton*) Sender;
int fff=0;
int tag7=0;
int id_dep=0;
int work=0;

if (but->Tag==7) {
   but->Tag=1;tag7=1;
  }

if (but->Tag==1) {
//  Query->Sql->Clear();
//  Query->Sql->Add("select id from clm_client_tbl where name='"+Department->Text+"'");
//  Query->ExecSql();
//  Query->Active=true;
//  id_dep=Query->FieldByName("id")->AsInteger;

  Query->Sql->Clear();
  Query->Sql->Add("select getsysvar('id_res') as id");
  Query->ExecSql();
  Query->Active=true;
  id_dep=Query->FieldByName("id")->AsInteger;

  Query->Sql->Clear();
  Query->Sql->Add("update clm_client_tbl set id_department="+IntToStr(id_dep)+" where id="+IntToStr(id_client));
  Query->ExecSql();
  fff=1;
  }

if (tag7==1) but->Tag=2;

if (but->Tag==2) {
  Query->Sql->Clear();
  Query->Sql->Add("update clm_client_tbl set name='"+Name->Text+"' where id="+IntToStr(id_client));
  Query->ExecSql();
  fff=1;
  }

if (tag7==1) but->Tag=3;
if (but->Tag==3) {
  Query->Sql->Clear();
  Query->Sql->Add("update clm_client_tbl set short_name='"+ShortName->Text+"' where id="+IntToStr(id_client));
  Query->ExecSql();
  fff=1;
  }

if (tag7==1) but->Tag=8;
if (but->Tag==8) {
  Query->Sql->Clear();
//  Query->Sql->Add("update clm_client_tbl set fax="+Fax->Text+" where id="+IntToStr(id_client));
//  Query->ExecSql();
  fff=1;
  }

 if (tag7==1) but->Tag=7;
        if (fff==1)
        {
        Table->FieldByName("name")->AsString=Name->Text;
        Table->FieldByName("short_name")->AsString=ShortName->Text;
        Table->FieldByName("id_department")->AsInteger=id_dep;
//        Table->FieldByName("fax")->AsString=Fax->Text;
        Table->Refresh();
        DestroyAll();
        DrawParams();
//        Data->DataSet->Refresh();}
        ShowMessage("Изменения сохранены");
        }
}
//---------------------------------------------------------------------------
void __fastcall TClient::SpeedClick(TObject *Sender)
{
TSpeedButton* but = (TSpeedButton*) Sender;
IntToStr(but->Tag);
 TMemo* mem;
 int id=0;
 EList Struct;
 for (int i=0;i<EditList->Count;i++)
  {
   Struct = (EList) EditList->Items[i];
   if (Struct->id==but->Tag) {mem=Struct->memo;id=Struct->id;}
  }

  Query->Sql->Clear();
//  ShowMessage("update clm_param_tbl set val='"+mem->Text+"' where id_param="+IntToStr(id)+" and id_client="+IntToStr(id_client));
  Query->Sql->Add("update clm_param_tbl set val='"+mem->Text+"' where id_param="+IntToStr(id)+" and id_client="+IntToStr(id_client));
  Query->ExecSql();

 ShowMessage("Изменения сохранены");
}
//---------------------------------------------------------------------------

__fastcall TClient::~TClient()
{
delete Query;
delete Query1;
delete Query2;
delete Query3;
}
//---------------------------------------------------------------------------
void __fastcall TClient::DBNavigator1Click(TObject *Sender,
      TNavigateBtn Button)
{
if (Button==nbInsert)
{
id_client=((TMainForm*)(Application->MainForm))->InterTable->FieldByName("id")->AsInteger;
//ShowMessage(IntToStr(id_client));
}
id_client=((TMainForm*)(Application->MainForm))->InterTable->FieldByName("id")->AsInteger;
   PanelList = new TList;
   Static();
   DrawParams();
   create_flag=0;

}
//---------------------------------------------------------------------------
void __fastcall TClient::DestroyAll()
{
 PanList PStruct;
 int cnt=PanelList->Count;
for (int i=0;i<cnt;i++)
 {
 PStruct = (PanList) PanelList->Items[0];
 delete PStruct->pan;
 PanelList->Delete(0);
 }

 cnt=EditList->Count;
 for (int i=0;i<cnt;i++)
  {
  EditList->Delete(0);
  }

 cnt=ComboList->Count;
 for (int i=0;i<cnt;i++)
  {
  ComboList->Delete(0);
  }

 cnt=ButtonList->Count;
 for (int i=0;i<cnt;i++)
  {
  ButtonList->Delete(0);
  }

}
//---------------------------------------------------------------------------
/*void __fastcall TClient::FormClose(TObject *Sender, TCloseAction &Action)
{
 TfTWTCompForm::Close(Sender,Action);
}  */
//---------------------------------------------------------------------------


void __fastcall TClient::FormClose(TObject *Sender, TCloseAction &Action)
{
    TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

void __fastcall TClient::DBNavigator1BeforeAction(TObject *Sender,
      TNavigateBtn Button)
{
DestroyAll();
}
//---------------------------------------------------------------------------


void __fastcall TClient::NewClick(TObject *Sender)
{
  Query->Sql->Clear();
  Query->Sql->Add("insert into clm_addon_tbl(id_client) values("+IntToStr(id_client)+")");
  Query->ExecSql();

  Query->Sql->Clear();
  Query->Sql->Add("select max(id) as id from clm_addon_tbl where id_client="+IntToStr(id_client));
  Query->ExecSql();
  Query->Active=true;
  int id=Query->FieldByName("id")->AsInteger;

  AddLgot(id,"","","",0,"",0,0);
}
//---------------------------------------------------------------------------
void __fastcall TClient::SvClick(TObject *Sender)
{
 TButton* but=(TButton*) Sender;

  LgotList *Lnew=Fst;
  int f=0;
   while (Lnew!=NULL)
   {
   if (Lnew->id_person==but->Tag)
    {
    TDateTime p_dt=StrToDate(Lnew->edit3->Text);
    TDateTime dt=StrToDate(Lnew->edit4->Text);
    Query->Sql->Clear();
    Query->Sql->Add("update clm_addon_tbl set p_person='"+Lnew->edit1->Text+"'");
    Query->Sql->Add(", p_number="+Lnew->edit2->Text);
    Query->Sql->Add(", p_date="+ToStrSQL(DateToStr(p_dt)));
    Query->Sql->Add(", dt="+ToStrSQL(DateToStr(dt)));
    Query->Sql->Add(", norm="+Lnew->edit5->Text);
    Query->Sql->Add(", num="+Lnew->edit6->Text);
    Query->Sql->Add(", id_k="+IntToStr(Lnew->combo->Tag));
    Query->Sql->Add(" where id="+IntToStr(Lnew->id_person));
    Query->ExecSql();
    break;
    }
   Lnew=Lnew->next;
   }

}
//---------------------------------------------------------------------------
//void __fastcall TClient::AddLgot(AnsiString name, AnsiString lgot,int id_person)
void __fastcall TClient::AddLgot(int id_lgot,AnsiString p_name,AnsiString p_num,AnsiString p_dt,int norm,AnsiString dt,int id_k,int num)
{
        Lgot_pan->Height+=140;
        TPanel* pan1= new TPanel(Lgot_pan);
        pan1->Parent=Lgot_pan;
        pan1->Height=140;
        pan1->Caption="";
        pan1->Align=alTop;
        pan1->Tag=id_lgot;
        pan1->OnClick=Clk;

        TButton *but=new TButton(pan1);
        but->Parent=pan1;
        but->Caption="Сохранить";
        but->Width=100;
        but->Top=5;
        but->Left=5;
        but->Tag=id_lgot;
        but->OnClick=SvClick;

        TLabel* label1=new TLabel(pan1);
        label1->Parent=pan1;
        label1->Caption="ФИО";
        label1->Top=5;
        label1->Left=125;
        TEdit* edit1=new TEdit(pan1);
        edit1->Parent=pan1;
        edit1->Top=5;
        edit1->Left=180;
        edit1->Text=p_name;
        edit1->Width=170;
        TLabel* label2=new TLabel(pan1);
        label2->Parent=pan1;
        label2->Caption="№ уд.";
        label2->Top=5;
        label2->Left=360;
        TEdit* edit2=new TEdit(pan1);
        edit2->Parent=pan1;
        edit2->Top=5;
        edit2->Left=390;
        edit2->Text=p_num;
        edit2->Width=50;
        TLabel* label3=new TLabel(pan1);
        label3->Parent=pan1;
        label3->Caption="Дата выдачи:";
        label3->Top=5;
        label3->Left=450;
        TEdit* edit3=new TEdit(pan1);
        edit3->Parent=pan1;
        edit3->Top=5;
        edit3->Left=480;
        edit3->Text=p_dt;


        TLabel* label4=new TLabel(pan1);
        label4->Parent=pan1;
        label4->Caption="Дата установки льготы:";
        label4->Top=40;
        label4->Left=125;
        TEdit* edit4=new TEdit(pan1);
        edit4->Parent=pan1;
        edit4->Top=40;
        edit4->Left=250;
        edit4->Text=dt;
        edit4->Width=50;
        TLabel* label5=new TLabel(pan1);
        label5->Parent=pan1;
        label5->Caption="Норма:";
        label5->Top=40;
        label5->Left=320;
        TEdit* edit5=new TEdit(pan1);
        edit5->Parent=pan1;
        edit5->Top=40;
        edit5->Left=340;
        edit5->Text=norm;

        TLabel* label6=new TLabel(pan1);
        label6->Parent=pan1;
        label6->Caption="количество человек:";
        label6->Top=75;
        label6->Left=125;
        TEdit* edit6=new TEdit(pan1);
        edit6->Parent=pan1;
        edit6->Top=75;
        edit6->Left=250;
        edit6->Text=num;

        TLabel* label7=new TLabel(pan1);
        label7->Parent=pan1;
        label7->Caption="Категория";
        label7->Top=110;
        label7->Left=125;
        TComboBox* edit7=new TComboBox(pan1);
        edit7->Parent=pan1;
        edit7->Top=110;
        edit7->Left=180;
        edit7->Style=Stdctrls::csDropDownList;
        edit7->OnChange=Change;
        int index=0;

  Query1->Sql->Clear();
  Query1->Sql->Add("select name,id_parent,id from cla_kateg_tbl where id_parent is not NULL order by id");
  Query1->ExecSql();
  Query1->Active=true;

  Query1->First();
  for (int i=0;i<Query1->RecordCount;i++)
  {
  Query2->Sql->Clear();
  Query2->Sql->Add("select name from cla_kateg_tbl where id="+Query1->FieldByName("id_parent")->AsString);
  Query2->ExecSql();
  Query2->Active=true;
   if (Query1->FieldByName("id")->AsInteger==id_k) {index=i;}

   edit7->Items->Add(Query1->FieldByName("name")->AsString+"::"+Query2->FieldByName("name")->AsString);
   Query1->Next();
  }
         edit7->ItemIndex=index;

LgotList *Struct=Fst,*Tmp=NULL,*StructNew,*StructOld=Lst;

StructNew = new LgotList;
StructNew->id_person=id_lgot;
StructNew->edit1=edit1;
StructNew->edit2=edit2;
StructNew->edit3=edit3;
StructNew->edit4=edit4;
StructNew->edit5=edit5;
StructNew->edit6=edit6;
StructNew->combo=edit7;

if (Struct==NULL) {Struct=StructNew;Fst=StructNew;StructNew->next=NULL;}
else {StructOld->next=StructNew;StructNew->next=NULL;}
StructOld=StructNew;
Lst=StructNew;
}
//---------------------------------------------------------------------------
void __fastcall TClient::Change(TObject *Sender)
{
TComboBox* combo=(TComboBox*) Sender;

 if (combo->Text!="")
 {
  AnsiString text=combo->Text;
  AnsiString kat="",budg="";
  int f=0;
  for (int s=1;s<=text.Length();s++)
  {
   if (text[s]==':'&&text[s]==':') {f=1;s+=2;}
   if (f==0) {kat+=text[s];}
   if (f==1) {budg+=text[s];}
  }

  Query2->Sql->Clear();
  Query2->Sql->Add("select id from cla_kateg_tbl where name='"+budg+"'");
  Query2->ExecSql();
  Query2->Active=true;
  int id_parent=Query2->FieldByName("id")->AsInteger;

  Query2->Sql->Clear();
  Query2->Sql->Add("select id from cla_kateg_tbl where name='"+kat+"' and id_parent="+IntToStr(id_parent));
  Query2->ExecSql();
  Query2->Active=true;
  int id_k=Query2->FieldByName("id")->AsInteger;

  LgotList *Lnew=Fst;
   while (Lnew!=NULL)
   {
   if (Lnew->combo==combo)
    {
    Lnew->combo->Tag=id_k;
    break;
    }
   Lnew=Lnew->next;
   }

//  ShowMessage(IntToStr(id_k));
 }

}
//---------------------------------------------------------------------------
void __fastcall TClient::DelClick(TObject *Sender)
{
 TPanel* parent=(TPanel*) panel->Parent;

  Query->Sql->Clear();
  Query->Sql->Add("delete from clm_addon_tbl where id="+IntToStr(panel->Tag));
  Query->ExecSql();

  LgotList *Lnew=Fst,*Prev=NULL;
   while (Lnew!=NULL)
   {
   if (Lnew->id_person==panel->Tag)
    {
    int f=0;
    if (Lnew==Fst) {Fst=Lnew->next;Lnew=NULL;f=1;}
    if (Lnew==Lst&&f==0) {Lst=Prev;Prev->next=NULL;f=1;}
    if (f==0) {Prev->next=Lnew->next;Lnew=NULL;}
    break;
    }
   Prev=Lnew;
   Lnew=Lnew->next;
   }

 try
 {
  delete panel;
  panel=NULL;
 }
 __except(1)
 {}

  parent->Height-=140;
}
//---------------------------------------------------------------------------
void __fastcall TClient::KategClick(TObject *Sender)
{
/* Application->CreateForm(__classid(TKateg), &Kateg);
 Kateg->Visible=true;
 Client->Enabled=false;
 */
 }
//---------------------------------------------------------------------------
void __fastcall TClient::SpClick(TObject *Sender)
{
TSpeedButton* but = (TSpeedButton*) Sender;
IntToStr(but->Tag);
 TComboBox* combo;
 int id=0;
 ComList Struct;
 for (int i=0;i<ComboList->Count;i++)
  {
   Struct = (ComList) ComboList->Items[i];
   if (Struct->id_param==but->Tag)
    {
    Query->Sql->Clear();
    Query->Sql->Add("select id from cla_param_tbl where id_parent="+IntToStr(Struct->id)+" and name='"+Struct->combo->Text+"'");
    Query->ExecSql();
    Query->Active=true;
    int new_par=Query->FieldByName("id")->AsInteger;

    Query->Sql->Clear();
    Query->Sql->Add("update clm_param_tbl set id_param="+IntToStr(new_par)+" where id_param="+IntToStr(Struct->id_param)+" and id_client="+IntToStr(id_client));
    Query->ExecSql();

    Struct->id_param=new_par;
    break;
    }
  }
}
//---------------------------------------------------------------------------


