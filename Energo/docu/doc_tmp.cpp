//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "doc_tmp.h"
#include "docu_mod.h"
#include "docu.h"
#include "wait.h"
#include "prop.h"
#include "create_tab.h"
#include "ins_doc.h"
#include "save_doc.h"
#include "cr_elem.h"
#include "add_field.h"
#include "sql.h"
#include "filnm.h"
#include "field.h"
#include "sys\stat.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//#pragma link "CCALENDR"
#pragma resource "*.dfm"
TDoc_temp *Doc_temp;
AnsiString tmp;
int arr_pan[100][4],arr_pan1[100][3];
int res=0,flag=1,cnt_row=1,cnt_col=1,count=0,count1;
TImage *img;
TList *MyList,*MainList,*TabList,*MemoList;
TImage *picturen;
TPanel *ppp;


struct MList
{
int id;
int id_parent;
int id_elem;
int id_compl;
int id_parent_shadow;
int id_group;
AnsiString teg;
AnsiString value;
AnsiString id_type;
TImage *image;
int level;
int num;
int idk_template;
AnsiString name;
AnsiString prop;
MList *next;
MList *parent;
 MList* GetNextByParent(int parent,MList* Struct)
 {
  MList *Lnew=Struct;
  MList *Temp=NULL;
  int f=0;
   while (Lnew!=NULL)
   {
   if (Lnew->id_parent==parent) {Temp=Lnew;break;}
   Lnew=Lnew->next;
   }
  return Temp;
 }

};

//typedef MaList* StrList;
struct PanelList
{
 TPanel *panel;
 TPanel *root;
 TPanel *subroot;
 TPanel *realroot;
 int f;
 int fl;
 int id;
 int left;
 int top;
 PanelList* next;

 PanelList* GetPanelById(int pos,PanelList* Struct)
 {
  PanelList *Lnew=Struct;
  PanelList *Temp=NULL;
  int f=0;
   while (Lnew!=NULL)
   {
   if (Lnew->id==pos) {Temp=Lnew;break;}
   Lnew=Lnew->next;
   }
  return Temp;
 }
};


typedef struct AList
{
 TPanel *pan;
 int id_elem;
 bool newline;
 int row;
 int col;
 int id_table;
} TAList;

typedef TAList* PAList;

typedef struct TabList
{
 int id_table;
 int id;
 int id_parent;
 AnsiString teg;
 AnsiString prop;
 int row;
 int col;
} TTList;

typedef TTList* TTTList;

typedef struct MeList
{
 int id;
 TMemo* memo;
 int type;
} MMList;

typedef MMList* MMMList;

struct OffsetList
{
 int id;
 int id_parent;
 int offset;
 int num;
 int level;
 OffsetList* next;
};

MList* Fst;
PanelList* PanelFst;
OffsetList* OffsetFst,*OffsetLst;
int id_elem=0,num=0;

MList* GetByIdStruct=NULL,*GetByIdRez=NULL;
//---------------------------------------------------------------------------
__fastcall TDoc_temp::TDoc_temp(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
/* Application->CreateForm(__classid(TCreateForm), &CreateForm);
 CreateForm->Visible=false;
 Application->CreateForm(__classid(TInsForm), &InsForm);
 InsForm->Visible=false;
 Application->CreateForm(__classid(TAddField), &AddField);
 AddField->Visible=false;
 Application->CreateForm(__classid(TGenerator), &Generator);
 Generator->Visible=false;
*/
//id_doc=Module2DB->id_doc;
//kind_doc=Module2DB->kind_doc;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::GetById(int pos)
{
  MList *Lnew=GetByIdStruct;
  MList *Temp=NULL;
  int f=0;
   while (Lnew!=NULL)
   {
   if (Lnew->id==pos) {Temp=Lnew;break;}
   Lnew=Lnew->next;
   }
 GetByIdRez=Temp;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::FormActivate(TObject *Sender)
{
Panel2->Visible=false;
if (fffff==0) {
MyList = new TList;
MemoList = new TList;
fffff=1;
}                             
// if (Doc_temp->view==1)
 {SpeedButton2->Enabled=true;SpeedButton2->Enabled=true;}
// else
// {SpeedButton2->Enabled=false;SpeedButton3->Enabled=false;}
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::DocSave(AnsiString name_d,AnsiString reg_d,int kind_docum,AnsiString descript)
{
AnsiString kind_docu="";

//проверяем, установлена ли переменная или нет
if (kind_docum==0)
{kind_docu="null";}
else
{kind_docu=IntToStr(kind_docum);}

 TDateTime dt=StrToDate(reg_d);

 Module2DB->Query_doc->Sql->Clear();
//                    ShowMessage("select sav_doc("+IntToStr(id_grp)+","+IntToStr(id_doc)+","+kind_docu+",'"+name_d+"','"+descript+"','"+reg_d+"');");
 Module2DB->Query_doc->Sql->Add("select sav_doc("+IntToStr(id_grp)+","+IntToStr(id_doc)+","+kind_docu+",'"+name_d+"','"+descript+"',");
 Module2DB->Query_doc->Sql->Add(ToStrSQL(DateToStr(dt))+");");
 Module2DB->Query_doc->ExecSql();

/* Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dcm_template_tbl set new_rec=false where usr='"+Module2DB->MainDB->Login+"' and new_rec=true");
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_template_tbl set new_rec=false where usr='"+Module2DB->MainDB->Login+"' and new_rec=true");
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_document_tbl set id_grp="+IntToStr(id_grp)+" where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_document_tbl set name='"+name_doc+"' where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_document_tbl set reg_date=CURRENT_DATE  where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();
*/

 save=0;
// ShowMessage("Документ сохранен");
//Doc_temp->Close();
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::DocSave1()
{
 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dcm_template_tbl set new_rec=false where usr='"+Module2DB->MainDB->Login+"' and new_rec=true");
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_template_tbl set new_rec=false where usr='"+Module2DB->MainDB->Login+"' and new_rec=true");
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_document_tbl set id_grp="+IntToStr(id_grp)+" where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_document_tbl set name='"+name_doc+"' where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dci_document_tbl set dt=CURRENT_DATE  where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();

 save=0;
//Doc_temp->Close();
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::Refresh()
{
TabList = new TList;
MyList = new TList;
MemoList = new TList;

//wt->Visible=true;
//ShowMessage("0");
GetData();
//ShowMessage("1");
MakeTree();
//ShowMessage("2");
MakeDoc();
//ShowMessage("3");
//wt->Visible=false;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::MakeDoc()
{
delete ScrollBox1;
        TScrollBox *scroll = new TScrollBox(Doc_temp);
try {
        scroll->Parent=Doc_temp;
        scroll->Align=alClient;
        scroll->Name="ScrollBox1";
}
__except(1) {}

 MList *Lnew=Fst;
 PanelList *Struct=NULL,*StructNew,*StructOld;

 TPanel *temp;
 int top=0,left=0,f=1;
  while (Lnew!=NULL)
  {

   if (Lnew->parent==NULL)
   {
     if (Lnew->id_type!="Перевод строки")
     {
      if (f==1)
      {
      TPanel* pan = new TPanel(ScrollBox1);
      pan->Parent=ScrollBox1;
      pan->Top+=top+20;
      pan->Align=alTop;
      pan->Caption=IntToStr(Lnew->id);
      pan->BevelOuter=bvNone;
//      pan->BevelOuter=bvRaised;
      top+=pan->Height;
//      pan->Height=top;
      temp=pan;
      }
      MList *Tmp=Lnew->GetNextByParent(Lnew->id_parent,Lnew->next);
      int in_tmp=0;
       if (Tmp==NULL) { TPanel* pan1 = new TPanel(temp);
                        pan1->Parent=temp;
                        pan1->Left+=left+20;
                        pan1->Align=alClient;
//                        pan1->BevelOuter=bvNone;
                        pan1->BevelOuter=bvRaised;
                        pan1->Caption=IntToStr(Lnew->id);
                        left=0;
                        f=0;

                        //Сохраняю созданные панели в список, будут использоваться как родителя (начало)
                        StructNew = new PanelList;
                        StructNew->id=Lnew->id;
                        StructNew->panel=pan1;
                        StructNew->root=temp;
                        StructNew->realroot=temp;
                        StructNew->f=1;
                        StructNew->fl=0;
                        StructNew->left=0;
                        StructNew->top=0;
                        if (Struct==NULL) {Struct=StructNew;PanelFst=StructNew;}
                        else StructOld->next=StructNew;
                        StructOld=StructNew;
                        in_tmp=1;
                        }
     if (in_tmp==0)
       if (Tmp->id_type!="Перевод строки")
       {
        TPanel* pan1 = new TPanel(temp);
        pan1->Parent=temp;
        pan1->Left+=left+20;
//        pan1->Align=alLeft;
        pan1->BevelOuter=bvRaised;
        pan1->Caption=IntToStr(Lnew->id);
        left+=pan1->Width;
        f=0;
//        pan1->BevelOuter=bvNone;
//Сохраняю созданные панели в список, будут использоваться как родителя (начало)
        StructNew = new PanelList;
        StructNew->id=Lnew->id;
        StructNew->panel=pan1;
        StructNew->root=temp;
        StructNew->subroot=temp;
        StructNew->realroot=temp;
        StructNew->f=1;
        StructNew->fl=0;
        StructNew->left=0;
        StructNew->top=0;
        if (Struct==NULL) {Struct=StructNew;PanelFst=StructNew;}
        else StructOld->next=StructNew;
        StructOld=StructNew;
//Сохраняю созданные панели в список, будут использоваться как родителя (конец)
       }
       else
       {
        TPanel* pan1 = new TPanel(temp);
        pan1->Parent=temp;
        pan1->Left+=left+20;
        pan1->Align=alClient;
        pan1->BevelOuter=bvRaised;
        pan1->Caption=IntToStr(Lnew->id);
        left=0;
        f=0;
//        pan1->BevelOuter=bvNone;
//Сохраняю созданные панели в список, будут использоваться как родителя (начало)
        StructNew = new PanelList;
        StructNew->id=Lnew->id;
        StructNew->panel=pan1;
        StructNew->root=temp;
        StructNew->subroot=temp;
        StructNew->realroot=temp;
        StructNew->f=1;
        StructNew->fl=0;
        StructNew->left=0;
        StructNew->top=0;
        if (Struct==NULL) {Struct=StructNew;PanelFst=StructNew;}
        else StructOld->next=StructNew;
        StructOld=StructNew;
//Сохраняю созданные панели в список, будут использоваться как родителя (конец)
       }
     }
     else
     {
     f=1;
     }
//    ShowMessage("ok");
   }//конец ифа, если элементы имеют родителя НУЛЛ
   else
   {//начало, если элементы имеют родителя не НУЛЛ
    PanelList *PPP=PanelFst->GetPanelById(Lnew->id_parent,PanelFst);
    if (Lnew->id_type!="Перевод строки")
     {
      if (PPP->f==1)
      {
      TPanel* pan = new TPanel(PPP->panel);
      pan->Parent=PPP->panel;
      pan->Top+=PPP->top+20;
      pan->Align=alTop;
      pan->Caption=IntToStr(Lnew->id);
      pan->BevelOuter=bvNone;
      PPP->top+=pan->Height;
      PPP->realroot->Height=PPP->top;
      PPP->panel->BevelOuter=bvNone;
      if (PPP->fl==1) Sizer(Lnew->id_parent,pan->Height);
      else PPP->fl=1;
      PPP->f=0;
      temp=pan;
      }
      else
      {
      temp=PPP->subroot;
      }
      MList *Tmp=Lnew->GetNextByParent(Lnew->id_parent,Lnew->next);
      int in_tmp=0;
      if (Tmp==NULL) { TPanel* pan1 = new TPanel(temp);
                        pan1->Parent=temp;
                        pan1->Left+=PPP->left+20;
                        pan1->Align=alClient;
                        pan1->BevelOuter=bvRaised;
                        pan1->Caption=IntToStr(Lnew->id);
                        PPP->left=0;
                        f=0;
//        pan1->BevelOuter=bvNone;
                        //Сохраняю созданные панели в список, будут использоваться как родителя (начало)
                        StructNew = new PanelList;
                        StructNew->id=Lnew->id;
                        StructNew->panel=pan1;
                        StructNew->root=PPP->root;
                        StructNew->realroot=temp;
                        StructNew->f=1;
                        StructNew->left=0;
                        StructNew->top=0;
                        if (Struct==NULL) {Struct=StructNew;PanelFst=StructNew;}
                        else StructOld->next=StructNew;
                        StructOld=StructNew;
                        in_tmp=1;
                        }
    if (in_tmp==0)
       if (Tmp->id_type!="Перевод строки")
       {
        TPanel* pan1 = new TPanel(temp);
        pan1->Parent=temp;
        pan1->Left+=PPP->left+20;
        pan1->Align=alLeft;
        pan1->Caption=IntToStr(Lnew->id);
        PPP->left+=pan1->Width;
        f=0;
        pan1->BevelOuter=bvRaised;
//Сохраняю созданные панели в список, будут использоваться как родителя (начало)
        StructNew = new PanelList;
        StructNew->id=Lnew->id;
        StructNew->panel=pan1;
        StructNew->root=PPP->root;
        StructNew->realroot=temp;
        PPP->subroot=temp;
        StructNew->f=1;
        StructNew->left=0;
        StructNew->top=0;
        if (Struct==NULL) {Struct=StructNew;PanelFst=StructNew;}
        else StructOld->next=StructNew;
        StructOld=StructNew;
//Сохраняю созданные панели в список, будут использоваться как родителя (конец)
       }
       else
       {
        TPanel* pan1 = new TPanel(temp);
        pan1->Parent=temp;
        pan1->Left+=PPP->left+20;
        pan1->Align=alClient;
        pan1->Caption=IntToStr(Lnew->id);
        PPP->left=0;
        f=0;
        pan1->BevelOuter=bvRaised;
//Сохраняю созданные панели в список, будут использоваться как родителя (начало)
        StructNew = new PanelList;
        StructNew->id=Lnew->id;
        StructNew->panel=pan1;
        StructNew->root=PPP->root;
        StructNew->realroot=temp;
//        Sizer(Lnew->id_parent);
        StructNew->f=1;
        StructNew->left=0;
        StructNew->top=0;
        if (Struct==NULL) {Struct=StructNew;PanelFst=StructNew;}
        else StructOld->next=StructNew;
        StructOld=StructNew;
//Сохраняю созданные панели в список, будут использоваться как родителя (конец)
       }
     }
     else
     {
     PPP->f=1;
     }
//    ShowMessage("ok");
   }//конец, если элементы имеют родителя не НУЛЛ

  Lnew=Lnew->next;
  }

 MakeContext();
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::MakeContext()
{
//ShowMessage(IntToStr(view));
//if (Main_doc-)
PanelList *Struct;
 Struct=PanelFst;
 while (Struct!=NULL)
 {
  if (Struct->panel->BevelOuter==bvRaised)
  {//if list-element
  GetByIdStruct=Fst;
  GetById(Struct->id);
  MList* Record=GetByIdRez;
   if (Record->idk_template==3)
   {//if static text
   TMemo *text = new TMemo(Struct->panel);
   text->Parent = Struct->panel;
   text->Text=Record->value;
   text->Align=alClient;
   text->BorderStyle=Memo1->BorderStyle;
   text->OnEnter=Enter;
   text->WordWrap=true;
   text->OnClick=MemoClk;
   AnsiString prp=Record->prop;

   AnsiString align = GetValue(prp,"align");
   if (align=="0") text->Alignment=taLeftJustify;
   if (align=="1") text->Alignment=taRightJustify;
   if (align=="2") text->Alignment=taCenter;

  MMMList MemStruct;

  MemStruct = new MMList;
  MemStruct->id=Record->id;
  MemStruct->memo=text;
  MemStruct->type=Record->idk_template;
  MemoList->Add(MemStruct);

   Memo1->Clear();
   Memo1->Width=text->Width;
   Memo1->Text=Record->value;
   int lines=Memo1->Lines->Count;

   int old_height=Struct->realroot->Height;
   int n=1;
   if (lines==2) n=2;

int d=(lines*16-(lines-n)*6);
int num_c=Num_child(Struct->id);
if (num_c==1) Struct->realroot->Align=alClient;

   if (lines!=0&&d>Struct->panel->Height&&num_c>1)
   {
   Struct->realroot->Height=lines*17-(lines-n)*6;
   Struct->panel->Height=lines*17-(lines-n)*6;
   Sizer(Record->id,(lines*16-(lines-n)*6)-old_height);
   int delta=(lines*16-(lines-n)*6);
   delta-=old_height;
   }
//   ShowMessage("id_parent="+IntToStr(Record->id_parent)+", height="+IntToStr(Struct->realroot->Height)+", old_height="+IntToStr(old_height)+" delta="+IntToStr(delta));
   }//if static text

   if (Record->idk_template==9)
   {//tables field
   TMemo *text = new TMemo(Struct->panel);
   text->Parent = Struct->panel;
   text->Align=alClient;
   text->BorderStyle=Memo1->BorderStyle;
   text->OnEnter=Enter;
   text->OnClick=MemoClk;
   AnsiString align = GetValue(Record->prop,"align");
   if (align=="0") text->Alignment=taLeftJustify;
   if (align=="1") text->Alignment=taRightJustify;
   if (align=="2") text->Alignment=taCenter;


    if (view==1)
    {//if template
    text->Text=Record->value;
    }//if template

    if (view==2)
    {//if document
        Module2DB->QueryExec->Sql->Clear();
        ShowMessage("select value from dcd_doc_tbl where id_elem="+IntToStr(Record->id)+" and id_doc="+IntToStr(id_document));
        Module2DB->QueryExec->Sql->Add("select value from dcd_doc_tbl where id_elem="+IntToStr(Record->id)+" and id_doc="+IntToStr(id_document));
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;
        AnsiString val=Module2DB->QueryExec->FieldByName("value")->AsString;
//        ShowMessage();
//        ShowMessage(val);
if (val!="")
{
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add("select lst_pr("+val+")");
        Module2DB->QueryExec->ExecSql();
}
AnsiString val1="",tmp="";
int f=0;
for (int i=1;i<Record->value.Length();i++)
{
if (f==0&&Record->value[i]!='%') {val1+=Record->value[i];}
if (f==1&&Record->value[i]!='%') {tmp+=Record->value[i];}
if (Record->value[i]=='%') f=1;
}
val1+=val+tmp;
        Module2DB->QueryExec->Sql->Clear();
//        ShowMessage(val1);
//        Module2DB->QueryExec->Sql->Add(Record->value+"'"+val+"'");
        Module2DB->QueryExec->Sql->Add(val1);
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;

    text->Text=Module2DB->QueryExec->FieldByName("value")->AsString;
    }//if document

  MMMList MemStruct;
  MemStruct = new MMList;
  MemStruct->id=Record->id;
  MemStruct->memo=text;
  MemStruct->type=Record->idk_template;
  MemoList->Add(MemStruct);

   Memo1->Clear();
   Memo1->Width=text->Width;
   Memo1->Text=Record->value;
   int lines=Memo1->Lines->Count;

   int old_height=Struct->realroot->Height;
   int n=1;
   if (lines==2) n=2;
   Struct->realroot->Height=lines*17-(lines-n)*6;
   Struct->panel->Height=lines*17-(lines-n)*6;
   Sizer(Record->id,(lines*16-(lines-n)*6)-old_height);
   int delta=(lines*16-(lines-n)*6);
   delta-=old_height;

   }//tables field

   if (Record->idk_template==10)
   {//input field
   TMemo *text = new TMemo(Struct->panel);
   text->Parent = Struct->panel;
   text->Align=alClient;
   text->BorderStyle=Memo1->BorderStyle;
   text->OnEnter=Enter;
   text->OnClick=MemoClk;
    if (view==1)
    {//if template
    text->Text=Record->value;
    }//if template
    if (view==2)
    {//if document
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add("select value from dcd_doc_tbl where id_elem="+IntToStr(Record->id)+" and id_doc="+IntToStr(id_document));
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;
        AnsiString val=Module2DB->QueryExec->FieldByName("value")->AsString;
    text->Text=val;
    }//if document
  MMMList MemStruct;
  MemStruct = new MMList;
  MemStruct->id=Record->id;
  MemStruct->memo=text;
  MemStruct->type=Record->idk_template;
  MemoList->Add(MemStruct);

   AnsiString align = GetValue(Record->prop,"align");
   if (align=="0") text->Alignment=taLeftJustify;
   if (align=="1") text->Alignment=taRightJustify;
   if (align=="2") text->Alignment=taCenter;
   }//tables field
   if (Record->idk_template==11)
   {//if otchet

    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add(Record->value);
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;
    int cnt_otchr=Module2DB->QueryExec->RecordCount;
    int cnt_otchc=Module2DB->QueryExec->FieldCount;

   TStringGrid *grid= new TStringGrid(Struct->panel);
   grid->Parent=Struct->panel;
   grid->FixedCols=0;
   grid->FixedRows=0;
   grid->RowCount=cnt_otchr;
   grid->ColCount=cnt_otchc;
   grid->DefaultRowHeight=20;
   grid->Height=21*(cnt_otchr+1)+5;
   Struct->realroot->Height=grid->Height+5;
   grid->Align=alClient;
for (int i=0;i<cnt_otchc;i++)
   grid->ColWidths[i]=(Struct->realroot->Width-20)/cnt_otchc;

   Module2DB->QueryExec->First();
    for (int i=1;i<=Module2DB->QueryExec->RecordCount;i++)
    {//begim po ryadam
      for (int j=0;j<cnt_otchc;j++)
      {
      grid->Cells[j][i]=Module2DB->QueryExec->Fields->Fields[j]->AsString;
      }
    Module2DB->QueryExec->Next();
    }//begim po ryadam
   }//if otchet

  }//if list-element
 Struct=Struct->next;
 }

}
//---------------------------------------------------------------------------
int __fastcall TDoc_temp::Num_child(int parent)
{
 MList *Lnew=Fst;
 int id_parent=0;

  while (Lnew!=NULL)
  {
   if (Lnew->id==parent) {id_parent=Lnew->id_parent;break;}
   Lnew=Lnew->next;
  }

 Lnew=Fst;
 int num=0;

  while (Lnew!=NULL)
  {
   if (Lnew->id_parent==id_parent) {num++;}
   Lnew=Lnew->next;
  }

return num;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::Sizer(int id,int height)
{
// PanelList *PPP=PanelFst->GetPanelById(id,PanelFst);
// PPP->root->Height=height;
try
{

// MList *Struct=GetById(id,Fst);
  GetByIdStruct=Fst;
  GetById(id);
  MList* Struct=GetByIdRez;

 int id_parent=Struct->id_parent;
  GetByIdStruct=Fst;
  GetById(id_parent);
  Struct=GetByIdRez;

// Struct=GetById(id_parent,Fst);
if (Struct!=NULL)
{
 while (Struct!=NULL)
  {
  id_parent=Struct->id_parent;
  PanelList *PPP=PanelFst->GetPanelById(Struct->id,PanelFst);
  PPP=PanelFst->GetPanelById(Struct->id,PanelFst);
  PPP->realroot->Height+=height;
//  Struct=GetById(id_parent,Fst);

  GetByIdStruct=Fst;
  GetById(id_parent);
  Struct=GetByIdRez;

  }
}

}
__except(1) {}
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::GetData()
{
//ShowMessage(IntToStr(id_doc)+"=="+IntToStr(kind_doc));
if (kind_doc==1)
{

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select lstdcm_pr("+IntToStr(id_doc)+",NULL);");
Module2DB->QueryExec->ExecSql();

}
if (kind_doc==3)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("delete from dcm_tmp_tbl where usrnm='"+Module2DB->MainDB->Login+"'");
Module2DB->QueryExec->ExecSql();


Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("insert into dcm_tmp_tbl(id,id_compl,teg,usrnm,level,num) values(2000,"+IntToStr(id_doc)+",'<table/>','"+Module2DB->MainDB->Login+"',2,1)");
Module2DB->QueryExec->ExecSql();
}

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dcm_tmp_tbl where usrnm='"+Module2DB->MainDB->Login+"' order by level,num ASC");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

MList *Struct=NULL,*Tmp=NULL,*StructNew,*StructOld;
MainList = new TList;

Module2DB->QueryExec->First();
int level=2;
for (int i=0;i<Module2DB->QueryExec->RecordCount;i++) {
StructNew = new MList;
StructNew->id=Module2DB->QueryExec->FieldByName("id")->AsInteger;
StructNew->id_parent=Module2DB->QueryExec->FieldByName("id_parent")->AsInteger;
StructNew->id_elem=Module2DB->QueryExec->FieldByName("id_elem")->AsInteger;
StructNew->id_compl=Module2DB->QueryExec->FieldByName("id_compl")->AsInteger;
StructNew->id_parent_shadow=Module2DB->QueryExec->FieldByName("id_parent_shadow")->AsInteger;
StructNew->id_group=Module2DB->QueryExec->FieldByName("id_group")->AsInteger;
StructNew->teg=Module2DB->QueryExec->FieldByName("teg")->AsString;
StructNew->value=Module2DB->QueryExec->FieldByName("value")->AsString;
StructNew->id_type=Module2DB->QueryExec->FieldByName("id_type")->AsString;
StructNew->level=Module2DB->QueryExec->FieldByName("level")->AsInteger;
StructNew->idk_template=Module2DB->QueryExec->FieldByName("idk_template")->AsInteger;
StructNew->num=Module2DB->QueryExec->FieldByName("num")->AsInteger;
StructNew->prop=Module2DB->QueryExec->FieldByName("prop")->AsString;
StructNew->name=Module2DB->QueryExec->FieldByName("name")->AsString;

DBImage1->DataSource=Module2DB->Data4exec;
DBImage1->DataField="image";
StructNew->image=new TImage(this);
StructNew->image->Parent=this;
StructNew->image->Picture=DBImage1->Picture;
StructNew->image->Visible=false;
//**ShowMessage("test");
//MainList->Add(Struct);


  GetByIdStruct=Fst;
  GetById(Module2DB->QueryExec->FieldByName("id_parent")->AsInteger);
  StructNew->parent=GetByIdRez;

if (Struct==NULL) {Struct=StructNew;Fst=StructNew;StructNew->next=NULL;}
else {StructOld->next=StructNew;StructNew->next=NULL;}
StructOld=StructNew;

DBImage1->DataField="";
Module2DB->QueryExec->Next();
}

}
//---------------------------------------------------------------------------
// процедура создания дерева клмпонентов документа
void __fastcall TDoc_temp::MakeTree()
{
Doc->Items->Clear();

 MList *Struct=Fst;
  while (Struct!=NULL)
  {
 if (Struct->id_parent==0) {
  Doc->Items->Add(NULL,IntToStr(Struct->id));
  int ptr=GetIndex(IntToStr(Struct->id),Doc);
  Doc->Items->Item[ptr]->StateIndex=Struct->id;
  Doc->Items->Item[ptr]->OverlayIndex=Struct->num;
  Doc->Items->Item[ptr]->ImageIndex=1;
  }
 else
 {
  int ptr=GetIndex(IntToStr(Struct->id_parent),Doc);
  if (ptr==-1) {int par=GetSubIndex(Struct->id_parent);
                ptr=GetIndex(IntToStr(par),Doc);}
  if (ptr!=-1) {Canvas->Font->Color=clRed;
                Doc->Font->Color=clRed;
                Doc->Items->AddChild(Doc->Items->Item[ptr],IntToStr(Struct->id));
                int ptr1=ptr;
                ptr=GetIndex(IntToStr(Struct->id),Doc);
                Doc->Items->Item[ptr]->StateIndex=Struct->id;
                Doc->Items->Item[ptr]->OverlayIndex=Struct->num;}
  if (ptr!=-1) Doc->Items->Item[ptr]->ImageIndex=1;
 }
Struct=Struct->next;
}

//Именование элементов дерева
for (int i=0;i<Doc->Items->Count;i++)
   {
    GetByIdStruct=Fst;
    GetById(Doc->Items->Item[i]->StateIndex);
    Struct=GetByIdRez;
    Doc->Items->Item[i]->Text=Struct->name;
   }

}
//-----------------------------------------------------------------------------------------------------
int __fastcall TDoc_temp::GetSubIndex(int parent)
{
int ii=-1,f=0;

/*CHange of STRUCT
StrList Struct;
for (int i=0;i<MainList->Count;i++)
{
 Struct = (StrList) MainList->Items[i];
 if (Struct->id_compl==parent) {f=1;ii=Struct->id;break;}
}
*/
return(ii);
}
//-----------------------------------------------------------------------------------------------------
int __fastcall TDoc_temp::GetIndex(AnsiString str, TTreeView *Tree)
{
int ii=-1,f=0;
for (int i=0;i<Tree->Items->Count;i++){
if (Tree->Items->Item[i]->Text==str) {f=1;ii=i;break;}
}
return(ii);
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::FormClose(TObject *Sender, TCloseAction &Action)
{
//ShowMessage("Hello");

save=0;
fffff=0;
//Main_doc->Enabled=true;

Doc->Items->Clear();
Doc->Visible=true;

try {
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("delete from dcm_template_tbl where usr='"+Module2DB->MainDB->Login+"' and new_rec=true");
Module2DB->QueryExec->ExecSql();

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("delete from dci_template_tbl where usr='"+Module2DB->MainDB->Login+"' and new_rec=true");
Module2DB->QueryExec->ExecSql();
delete ScrollBox1;
}
__except(1){}

TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
AnsiString __fastcall TDoc_temp::ParseTag(AnsiString teg)
{
  AnsiString temp="";
       int fl=0;
       for (int s=1;s<teg.Length();s++)
       {
        if (teg[s]=='/'&&fl==1) fl=2;
        if (teg[s]==' '&&fl==1) fl=2;
        if (fl==1) temp+=teg[s];
        if (teg[s]=='<') fl=1;
        if (fl==2) break;
       }
  return temp;
}
//---------------------------------------------------------------------------
AnsiString __fastcall TDoc_temp::Parse(AnsiString text,int num)
{
//sdfsdg
  AnsiString temp="";
  int cnt=1;
       int fl=0;
       for (int i=2;i<text.Length();i++)
       {fl=2;
        if (text[i]==':')
                {
                if (cnt==num) break;
                else {cnt++;temp="";fl=0;}
                }
        if (fl==2) temp+=text[i];
       }
  return temp;

}
//-----------------------------------------------------------------------------
void __fastcall TDoc_temp::DrawTable(int id_tab, TPanel *pan)
{
//ShowMessage("Rows="+IntToStr(GetTabRow(id_tab))+" Cols="+IntToStr(GetTabCol(id_tab)));
TTTList TabStruct;
PAList TStruct;
     int num_col=GetTabRow(id_tab);
     int num_row=GetTabCol(id_tab);
     TPanel *par4td;
    for (int i=0;i<TabList->Count;i++)
     {
       TabStruct = (TTTList) TabList->Items[i];
       TPanel *parent;
       if (TabStruct->id_parent==0) parent=pan;//temp
       else {
             for (int ii=0;ii<MyList->Count;ii++)
             {
             TStruct = (PAList) MyList->Items[ii];
             if (TStruct->id_elem==TabStruct->id_parent) {parent=TStruct->pan;break;}
             }
            }
//       ShowMessage("test");
       int defwidth,defheight,left,top;
       int fl=0;
       AnsiString teg=ParseTag(TabStruct->teg);
   if (teg=="tr"){
       defwidth=parent->Width;
       defheight=parent->Height/num_row;
       left=0;
       top=(TabStruct->col-1)*defheight;
       par4td=parent;
       fl=2;
       }
   if (teg=="td"){
       defwidth=parent->Width/num_col;
       defheight=parent->Height;
       left=(TabStruct->col-1)*defwidth;
       top=(TabStruct->row-1)*defheight;
       parent=par4td;
       fl=1;
       }
   if (teg=="table"){
       defwidth=parent->Width/num_col;
       defheight=parent->Height/num_row;
       left=0;
       top=0;
       fl=1;
       }
   if (fl==0){
       defwidth=parent->Width;
       defheight=parent->Height;
       left=0;
       top=0;
       fl=3;
       }

       TPanel *panel = new TPanel(parent);
       panel->Parent=parent;
   if (TabStruct->id_parent==0)
   {
       panel->Height=parent->Height;
       panel->Width=parent->Width;
       panel->Left=0;
       panel->Top=0;
   }
   else
   {
if (fl==3) panel->Align=alClient;
else {
       panel->Height=defheight;
       panel->Width=defwidth;

       panel->Left=left;
       panel->Top=top;
      }
   }



       panel->BevelOuter=bvRaised;
       panel->Caption=IntToStr(TabStruct->id);
       panel->Visible=true;


        TStruct = new TAList;
        TStruct->id_elem = TabStruct->id;
        TStruct->row = TabStruct->row;
        TStruct->col = TabStruct->col;
        TStruct->id_table=TabStruct->id_table;
        TStruct->pan=panel;
        MyList->Add(TStruct);
//        ShowMessage("test");
if (fl==2)
{//****
panel->Visible=false;
}//****
     }
//ShowMessage("test");
SortTable(id_tab);
}
//-----------------------------------------------------------------------------
void __fastcall TDoc_temp::SortTable(int id_tab)
{
//процедура, производящая обьединение ячеек таблиці и перемещение других ячеек, в зависимости
//от новых параметров
TTTList TabStruct;
PAList TStruct,TStruct1;
int onlycol=0;
TPanel *parent;
int rows,cols;
int h=0,w=0;
    for (int i=0;i<TabList->Count;i++)
     {
     w=0;
       TabStruct = (TTTList) TabList->Items[i];
       if (TabStruct->prop!="")
       {
       try {rows=StrToInt(GetValue(TabStruct->prop,"rowspan"));}
       __except(1) {rows=1;}
       try {cols=StrToInt(GetValue(TabStruct->prop,"colspan"));}
       __except(1) {cols=1;}
       int row=TabStruct->row;
       int col=TabStruct->col;
       if (rows!=1)
       {
             for (int ii=0;ii<MyList->Count;ii++)
             {
             TStruct = (PAList) MyList->Items[ii];
             if (TStruct->id_elem==TabStruct->id) {parent=TStruct->pan;parent->Height*=rows;}
             //Сдвигаем элементы, находящиеся ниже на одну колонку вправо
             if (TStruct->id_table==id_tab&&TStruct->col>=col&&TStruct->row<=(row+rows-1)&&TStruct->row>row) {TStruct->pan->Left+=parent->Width;TStruct->col++;}
             }
       }//есть обьедтнение рядов
       if (cols!=1)
       {
             for (int ii=0;ii<MyList->Count;ii++)
             {
             TStruct = (PAList) MyList->Items[ii];
             //Сдвигаем элементы, находящиеся ниже на одну колонку вправо
             if (TStruct->id_elem==TabStruct->id) {parent=TStruct->pan;w=parent->Width;parent->Width*=cols;}
             if (TStruct->id_table==id_tab&&TStruct->col>col&&TStruct->row<=(row+rows-1)&&TStruct->row>=row) {TStruct->pan->Left+=(parent->Width-w);TStruct->col++;}
             }
       }//есть обьедтнение рядов

      }//if prop!=""
     }//of for
}
//-----------------------------------------------------------------------------
AnsiString __fastcall TDoc_temp::GetValue(AnsiString value, AnsiString test)
{
  AnsiString temp="",ret="";
       int fl=0;
       for (int s=1;s<=value.Length();s++)
       {
        if (fl==1&&value[s]==' ') break;
        if (fl==1) ret+=value[s];
        if (value[s]=='='&&temp==test) fl=1;
        if (value[s]=='='&&temp!=test) fl=3;
        if (fl==0) temp+=value[s];
        if (fl==3&&value[s]==' ') {fl=0;temp="";}
       }
  return ret;
}
//-----------------------------------------------------------------------------
void __fastcall TDoc_temp::AddTable(int id_table, int id)
{
if (kind_doc==1) {
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select lstdcm_pr("+IntToStr(id_doc)+","+IntToStr(id_table)+");");
Module2DB->QueryExec->ExecSql();
}

if (kind_doc==3) {
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select lstdcm_pr(NULL,"+IntToStr(id_table)+");");
Module2DB->QueryExec->ExecSql();
}

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dcm_tmp_tbl where usrnm='"+Module2DB->MainDB->Login+"' order by level,num ASC");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

TTTList TabStruct;
//TabList = new TList;

Module2DB->QueryExec->First();
 for (int i=0;i<Module2DB->QueryExec->RecordCount;i++) {
  TabStruct = new TTList;
  TabStruct->id_table=id;
  TabStruct->id=Module2DB->QueryExec->FieldByName("id")->AsInteger;
  TabStruct->id_parent=Module2DB->QueryExec->FieldByName("id_parent")->AsInteger;
  TabStruct->teg=Module2DB->QueryExec->FieldByName("teg")->AsString;
  TabStruct->prop=Module2DB->QueryExec->FieldByName("prop")->AsString;
  TabStruct->col=Module2DB->QueryExec->FieldByName("num")->AsInteger;

if (Module2DB->QueryExec->FieldByName("id_parent")->AsInteger>0)
{//**&&
 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("select * from dcm_tmp_tbl where usrnm='"+Module2DB->MainDB->Login+"' and id="+Module2DB->QueryExec->FieldByName("id_parent")->AsString);
 Module2DB->Query_doc->ExecSql();
 Module2DB->Query_doc->Active=true;
  TabStruct->row=Module2DB->Query_doc->FieldByName("num")->AsInteger;
}//**&&
  TabList->Add(TabStruct);

  Module2DB->QueryExec->Next();
 }

}
//-----------------------------------------------------------------------------
int __fastcall TDoc_temp::GetTabRow(int id_tab)
{
//Идея - для каждого !тр - считаем количество детей
TTTList TabStruct,TabStruct1;
int count=0,max=0;
  for (int i=0;i<TabList->Count;i++)
  {//пробег по таблице и нахождение элементов tr
   TabStruct = (TTTList) TabList->Items[i];
   if (ParseTag(TabStruct->teg)=="tr"&&TabStruct->id_table==id_tab)
    {//нашли элемент tr, будем искать для него количество детей
    count=0;
          for (int ii=0;ii<TabList->Count;ii++)
          {
           TabStruct1 = (TTTList) TabList->Items[ii];
           if (TabStruct1->id_parent==TabStruct->id) count++;
          }
    if (count>max) max=count;
    }//нашли элемент tr
  }//пробег по таблице и нахождение элементов tr
return max;
}
//-----------------------------------------------------------------------------
int __fastcall TDoc_temp::GetTabCol(int id_tab)
{//а здесь смотрим просто количество тр.
TTTList TabStruct;
int count=0;
  for (int i=0;i<TabList->Count;i++)
  {//пробег по таблице и нахождение элементов tr
   TabStruct = (TTTList) TabList->Items[i];
   if (ParseTag(TabStruct->teg)=="tr"&&TabStruct->id_table==id_tab) count++;
  }//пробег по таблице и нахождение элементов tr
return count;
}
//-----------------------------------------------------------------------------
int __fastcall TDoc_temp::GetMaxRow(int id)
{
int max=1;
 for (int i=0;i<count;i++)
  if (arr_pan[i][0]==id&&arr_pan[i][1]>max) max=arr_pan[i][1];
return max;
}
//-----------------------------------------------------------------------------
int __fastcall TDoc_temp::GetNumCol(int id,int id_parent)
{
int row=0;
//узнаем в каком ряду находится элемент
for (int i=0;i<count1;i++)
 {
  if (arr_pan1[i][2]==id) row=arr_pan1[i][1];
 }
//узнаем сколько колонок в ряду
for (int i=0;i<count;i++)
 {
  if (arr_pan[i][0]==id_parent&&arr_pan[i][1]==row) {return arr_pan[i][2];break;}
 }
}
//-----------------------------------------------------------------------------
void __fastcall TDoc_temp::ResizeForm()
{
PAList PStruct,TStruct;
TPanel *parent;
int test=1, test1=1;
int left=0,temp_parent=0;
 for (int i=0;i<MyList->Count;i++)
 {
 int id_parent=-1;
 int row=0;
 PStruct = (PAList) MyList->Items[i];
   for (int ii=0;ii<count1;ii++)
   {
    if (PStruct->id_elem==arr_pan1[ii][2]) {id_parent=arr_pan1[ii][0];row=arr_pan1[ii][1];break;}
   }
if (id_parent>=0)
{
  if (temp_parent!=id_parent) left=0;
  int num_row=GetMaxRow(id_parent);
  int num_col=GetNumCol(PStruct->id_elem,id_parent);
  if (id_parent==0)
  {
  int par_width=PStruct->pan->Width;
  int par_height=PStruct->pan->Height;
  PStruct->pan->Height=ScrollBox1->Height/num_row;
  PStruct->pan->Width=ScrollBox1->Width/num_col;
  test1=row;
  if (test!=test1) left=0;
  PStruct->pan->Left=left;left+=PStruct->pan->Width;
  PStruct->pan->Top=row*ScrollBox1->Height/num_row-ScrollBox1->Height/num_row;
  }//temp
  else {
       for (int iii=0;iii<MyList->Count;iii++)
       {
       TStruct = (PAList) MyList->Items[iii];
       if (TStruct->id_elem==id_parent)
         {
         parent=TStruct->pan;
         int par_width=PStruct->pan->Width;
         int par_height=PStruct->pan->Height;
          PStruct->pan->Height=parent->Height/num_row;
          PStruct->pan->Width=parent->Width/num_col;
          test1=row;
          if (test!=test1) left=0;
          PStruct->pan->Left=left;left+=PStruct->pan->Width;
          PStruct->pan->Top=row*parent->Height/num_row-parent->Height/num_row;
         }
       }
      }
  test=test1;
  temp_parent=id_parent;


  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select * from dcm_template_tbl where id="+IntToStr(PStruct->id_elem));
  Module2DB->QueryExec->ExecSql();
  Module2DB->QueryExec->Active=true;
  if (Module2DB->QueryExec->FieldByName("idk_template")->AsInteger==5&&Module2DB->QueryExec->FieldByName("id_compl")->AsInteger>0)
  ResizeTable(PStruct->id_elem,PStruct->pan,Module2DB->QueryExec->FieldByName("id_compl")->AsInteger);
 }

}//if id_parent>=0
}
//-----------------------------------------------------------------------------
void __fastcall TDoc_temp::ResizeTable(int id_tab,TPanel *cur_pan,int id_compl)
{

PAList TStruct;
TTTList TabStruct;
int par_height;
int par_width;

TPanel *par;

for (int iii=0;iii<MyList->Count;iii++)
 {

  TStruct = (PAList) MyList->Items[iii];
  if (TStruct->id_elem==id_compl)
  {
  par_height=TStruct->pan->Height;
  par_width=TStruct->pan->Width;
  TStruct->pan->Width=cur_pan->Width;
  TStruct->pan->Height=cur_pan->Height;
  TStruct->pan->Top=0;
  TStruct->pan->Left=0;
  par=TStruct->pan;
  break;
  }
 }//проходим по циклу панелек
     int num_col=GetTabRow(id_tab);
     int num_row=GetTabCol(id_tab);
     int rows,cols;

for (int iii=0;iii<MyList->Count;iii++)
 {
  TStruct = (PAList) MyList->Items[iii];
  if (TStruct->id_table==id_tab&&TStruct->id_elem!=id_compl)
  {
    for (int i=0;i<TabList->Count;i++)
     {
       cols=1;rows=1;
       TabStruct = (TTTList) TabList->Items[i];
       if (TabStruct->prop!=""&&TabStruct->id==TStruct->id_elem)
       {
       try {rows=StrToInt(GetValue(TabStruct->prop,"rowspan"));}
       __except(1) {rows=1;}
       try {cols=StrToInt(GetValue(TabStruct->prop,"colspan"));}
       __except(1) {cols=1;}
       break;
       }
     }
   TStruct->pan->Height=(par->Height/num_row)*rows;
   TStruct->pan->Top=(TStruct->row-1)*TStruct->pan->Height;

   TStruct->pan->Width=(par->Width/num_col)*cols;
   TStruct->pan->Left=(TStruct->col-1)*TStruct->pan->Width;

   TStruct->pan->BringToFront();
  }
 }//проходим по циклу панелек

}
//-----------------------------------------------------------------------------
void __fastcall TDoc_temp::FormResize(TObject *Sender)
{
ResizeForm();
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::Splitter1Moved(TObject *Sender)
{
ResizeForm();
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::SpeedButton1Click(TObject *Sender)
{
FontDialog1->Options << fdApplyButton;
FontDialog1->Execute();
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::DocChange(TObject *Sender, TTreeNode *Node)
{
/*Properties->MainList=MainList;
Properties->id_elem=Node->StateIndex;

InsForm->id_parent=Node->StateIndex;

CreateForm->id_parent=Node->StateIndex;
CreateForm->num=Node->OverlayIndex;

AddField->id_parent=Node->StateIndex;
AddField->num=Node->OverlayIndex;

Generator->id_parent=Node->StateIndex;
Generator->num=Node->OverlayIndex;
*/
Module2DB->id_elem=Node->StateIndex;
Module2DB->num_elem=Node->OverlayIndex;
Module2DB->MainList=MainList;

id_elem=Node->StateIndex;
num=Node->OverlayIndex;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::FormCreate(TObject *Sender)
{
MyList = new TList;
MemoList = new TList;
fffff=0;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::FontDialog1Apply(TObject *Sender, HWND Wnd)
{
  if (ActiveControl->ClassNameIs("TMemo"))
  ((TMemo *)ActiveControl)->Font->Assign(FontDialog1->Font);
//    ((TMemo *)ActiveControl)->SelAttributes->Assign(FontDialog1->Font);
  else
    MessageBeep(0);
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::SpeedButton2Click(TObject *Sender)
{
 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("select * from dci_document_tbl where id="+IntToStr(id_doc));
 Module2DB->Query_doc->ExecSql();
 Module2DB->Query_doc->Active=true;

 if (Module2DB->Query_doc->FieldByName("id_grp")->AsInteger>0)
 {
 id_grp=Module2DB->Query_doc->FieldByName("id_grp")->AsInteger;
 name_doc=Module2DB->Query_doc->FieldByName("name")->AsString;
 DocSave1();
 }
 else
 {
 Application->CreateForm(__classid(TSaveDoc), &SaveDoc);
 SaveDoc->Caption="Сохранение шаблона";
 SaveDoc->SpeedButton1->Caption="Сохранить";
 SaveDoc->Label3->Caption="сохранения";

 SaveDoc->Panel_doc->Visible=false;
 SaveDoc->Panel_tmp->Visible=true;

 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select * from dck_document_tbl");
 Module2DB->QueryExec->ExecSql();
 Module2DB->QueryExec->Active=true;

  Module2DB->QueryExec->First();
  for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
  {
  SaveDoc->ComboBox2->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
  Module2DB->QueryExec->Next();
  }

 }

 MMMList Struct;
 for (int i=0;i<MemoList->Count;i++)
 {Struct = (MMMList) MemoList->Items[i];

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("select prop from dcm_template_tbl where id="+IntToStr(Struct->id));
 Module2DB->Query_doc->ExecSql();
 Module2DB->Query_doc->Active=true;

 AnsiString length=GetValue(Module2DB->Query_doc->FieldByName("prop")->AsString,"length");
 AnsiString align="align=" + (AnsiString) Struct->memo->Alignment;
 if (length!="") align+=" length="+length+" ";
// ShowMessage(align+"  :"+IntToStr(Struct->id));
// if (Struct->memo->Align==taCenter) align="taCenter";
// if (Struct->memo->Align==taLeftJustify) align="taLeftJustify";
// if (Struct->memo->Align==taRightJustify) align="taRightJustify";


 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dcm_template_tbl set prop='"+align+"' where id="+IntToStr(Struct->id));
 Module2DB->Query_doc->ExecSql();

        if (Struct->type==3)
        {
         AnsiString mem=Prep(Struct->memo->Text);

         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("update dci_template_tbl set value='"+mem+"' where id in (select id_elem from dcm_template_tbl where id="+IntToStr(Struct->id)+")");
         Module2DB->Query_doc->ExecSql();

        }

        if (Struct->type==9)
        {
         AnsiString mem=Prep(Struct->memo->Text);
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("update dci_template_tbl set value='"+mem+"' where id in (select id_elem from dcm_template_tbl where id="+IntToStr(Struct->id)+")");
         Module2DB->Query_doc->ExecSql();
        }

 }
ShowMessage("Документ сохранен");
}
//---------------------------------------------------------------------------
AnsiString __fastcall TDoc_temp::Prep(AnsiString mem)
{
  AnsiString temp="";

       for (int s=1;s<=mem.Length();s++)
       {
        if (mem[s]=='\'') temp+="\\'";
        else temp+=mem[s];
       }
  return temp;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::AlignLeftClick(TObject *Sender)
{
 if (ActiveControl->ClassNameIs("TMemo"))
 {
//  AnsiString tmp=((Memo *)ActiveControl)->Text;
  ((TMemo *)ActiveControl)->Alignment=taLeftJustify;
  AlignLeft->Down=true;
 }
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::AlignCenterClick(TObject *Sender)
{
 if (ActiveControl->ClassNameIs("TMemo"))
 {
//   AnsiString tmp=((TMemo *)ActiveControl)->Text;
  ((TMemo *)ActiveControl)->Alignment=taCenter;
//  ((TRichEdit *)ActiveControl)->Text=tmp;
  AlignCenter->Down=true;
 }

}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::AlignRightClick(TObject *Sender)
{
 if (ActiveControl->ClassNameIs("TMemo"))
 {
  ((TMemo *) ActiveControl)->Alignment=taRightJustify;
//    ((TRichEdit *)ActiveControl)->SelAttributes->Assign();
  AlignRight->Down=true;
 }
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::setAlign(TMemo *memo)
{
if (memo->Alignment==taCenter) AlignCenter->Down=true;
if (memo->Alignment==taLeftJustify) AlignLeft->Down=true;
if (memo->Alignment==taRightJustify) AlignRight->Down=true;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::MemoClk(TObject *Sender)
{
setAlign((TMemo *) Sender);
}
//---------------------------------------------------------------------------


void __fastcall TDoc_temp::N7Click(TObject *Sender)
{
if (Doc->Visible==true) Doc->SetFocus();
Doc_temp->Close();
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::SpeedButton3Click(TObject *Sender)
{
 Application->CreateForm(__classid(TSaveDoc), &SaveDoc);
 SaveDoc->Caption="Регистрация документа";
 SaveDoc->SpeedButton1->Caption="Регистрировать";
 SaveDoc->Label3->Caption="регистрации";

 SaveDoc->Panel_doc->Visible=true;
 SaveDoc->Panel_tmp->Visible=false;

 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select * from dci_transm_tbl");
 Module2DB->QueryExec->ExecSql();
 Module2DB->QueryExec->Active=true;

  Module2DB->QueryExec->First();
  for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
  {
  SaveDoc->ComboBox1->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
  Module2DB->QueryExec->Next();
  }

 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("select * from dci_direction_tbl");
 Module2DB->QueryExec->ExecSql();
 Module2DB->QueryExec->Active=true;

  Module2DB->QueryExec->First();
  for (int i=0;i<Module2DB->QueryExec->RecordCount;i++)
  {
  SaveDoc->ComboBox3->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
  Module2DB->QueryExec->Next();
  }

 SaveDoc->id_doc=id_doc;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::DocReg(AnsiString reg_date,AnsiString reg_num,int id_t,int id_d,int id_client)
{
int fl=0;
AnsiString transm="",direct="";

if (id_t==0)
{transm="null";}
else
{transm=IntToStr(id_t);}

if (id_d==0)
{direct="null";}
else
{direct=IntToStr(id_d);}

 TDateTime dt=StrToDate(reg_date);

 Module2DB->Query_doc->Sql->Clear();
// ShowMessage("select reg_doch("+IntToStr(id_doc)+",'osa','"+reg_date+"',"+reg_num+","+transm+","+direct+")");
// ShowMessage("select reg_doch("+IntToStr(id_doc)+",'osa','2003-01-01',"+reg_num+","+transm+","+direct+")");
 Module2DB->Query_doc->Sql->Add("select reg_doch("+IntToStr(id_doc)+",'osa',");
 Module2DB->Query_doc->Sql->Add(ToStrSQL(DateToStr(dt))+","+reg_num+","+transm+","+direct+")");
 Module2DB->Query_doc->ExecSql();

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("select id from dcm_doc_tbl where name='osa'");
 Module2DB->Query_doc->ExecSql();
 Module2DB->Query_doc->Active=true;

 id_document=Module2DB->Query_doc->FieldByName("id")->AsInteger;

 Module2DB->Query_doc->Sql->Clear();
 Module2DB->Query_doc->Sql->Add("update dcm_doc_tbl set name='"+name_doc+"' where id="+IntToStr(id_document));
 Module2DB->Query_doc->ExecSql();

//Добавление связки с номером док и датой

 MMMList Struct;
 for (int i=0;i<MemoList->Count;i++)
 {Struct = (MMMList) MemoList->Items[i];
//  ShowMessage(IntToStr(Struct->type));
        if (Struct->type==3)
        {
//         Module2DB->Query_doc->Sql->Clear();
//         Module2DB->Query_doc->Sql->Add("select reg_doc("+IntToStr(id_document)+","+IntToStr(Struct->id)+",'"+Struct->memo->Text+"')");
//         Module2DB->Query_doc->ExecSql();

        /*
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("select id_elem from dcm_template_tbl where id="+IntToStr(Struct->id));
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;

         int id_elem=Module2DB->Query_doc->FieldByName("id_elem")->AsInteger;

         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("select * from dcd_doc_tbl where id_elem="+IntToStr(id_elem));
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;

         if (Module2DB->Query_doc->RecordCount>0)
         {
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("update dcd_doc_tbl set value='"+Struct->memo->Text+"' where id_elem="+IntToStr(id_elem));
         Module2DB->Query_doc->ExecSql();
         }
         else
         {
         Module2DB->Query_doc->Sql->Clear();
         ShowMessage("insert into dcd_doc_tbl(id_elem,value) ("+IntToStr(id_elem)+",'"+Struct->memo->Text+"')");
         Module2DB->Query_doc->Sql->Add("insert into dcd_doc_tbl(id_elem,value) values("+IntToStr(id_elem)+",'"+Struct->memo->Text+"')");
         Module2DB->Query_doc->ExecSql();
         }*/

        }
        if (Struct->type==9)
        {
         fl=0;
        //Добавление связки с номером док и датой
         Module2DB->Query_doc->Sql->Clear();
         ShowMessage("select id,id_head from dcm_template_tbl where id_document="+IntToStr(id_doc)+" and id="+IntToStr(Struct->id)+" and id_head is not NULL");
         Module2DB->Query_doc->Sql->Add("select id,id_head from dcm_template_tbl where id_document="+IntToStr(id_doc)+" and id="+IntToStr(Struct->id)+" and id_head is not NULL");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;

         int id_elem=-1,id_head=-1;
         id_elem=Module2DB->Query_doc->FieldByName("id")->AsInteger;
         id_head=Module2DB->Query_doc->FieldByName("id_head")->AsInteger;
         if (id_head==3)
         {
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("insert into dcd_doc_tbl(id_elem,value,id_doc) values("+IntToStr(id_elem)+",'"+IntToStr(id_document)+"',"+IntToStr(id_document)+")");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;
         }
         if (id_head==4)
         {
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("insert into dcd_doc_tbl(id_elem,value,id_doc) values("+IntToStr(id_elem)+",'"+IntToStr(id_document)+"',"+IntToStr(id_document)+")");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;
         }
         if (id_head==8||id_head==1||id_head==9)
         {
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("insert into dcd_doc_tbl(id_elem,value,id_doc) values("+IntToStr(id_elem)+",'"+IntToStr(id_client)+"',"+IntToStr(id_document)+")");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;
         }

         if (id_head==5||id_head==6||id_head==7)
         {
         AnsiString id_department="NULL";
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("select id_department from clm_client_tbl where id='"+IntToStr(id_client)+"'");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;

         if (Module2DB->Query_doc->RecordCount>0) id_department=Module2DB->Query_doc->FieldByName("id_department")->AsString;

         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("insert into dcd_doc_tbl(id_elem,value,id_doc) values("+IntToStr(id_elem)+",'"+id_department+"',"+IntToStr(id_document)+")");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;
         }


/*         if (Struct->id!=id_elem&&Struct->id!=id_elem1)
         {
         Application->CreateForm(__classid(TSetFieldName), &SetFieldName);
         SetFieldName->Refresh(id_document,Struct->id);
         }
*/
        }
        if (Struct->type==10)
        {
         Module2DB->Query_doc->Sql->Clear();
         Module2DB->Query_doc->Sql->Add("insert into dcd_doc_tbl(id_elem,value,id_doc) values("+IntToStr(Struct->id)+",'"+Struct->memo->Text+"',"+IntToStr(id_document)+")");
         Module2DB->Query_doc->ExecSql();
         Module2DB->Query_doc->Active=true;
        }
 }

 if (fl==0) ShowMessage("Документ зарегистрирован");
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::SpeedButton4Click(TObject *Sender)
{
Application->CreateForm(__classid(TCreateTab), &CreateTab);
//CreateTab->Width=375;
//CreateTab->Height=486;
//CreateTab->form=2;
}
//---------------------------------------------------------------------------


void __fastcall TDoc_temp::SpeedButton5Click(TObject *Sender)
{
 MList *Lnew=Fst;
  while (Lnew!=NULL)
  {
  ShowMessage(IntToStr(Lnew->id_parent)+":"+IntToStr(Lnew->id));
  Lnew=Lnew->next;
  }

}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::Enter(TObject *Sender)
{
TRichEdit* text = (TRichEdit*) Sender;
ppp = (TPanel*) text->Parent;
//ShowMessage(ppp->Caption);
}
//---------------------------------------------------------------------------


void __fastcall TDoc_temp::SpeedButton6Click(TObject *Sender)
{
try
{

  GetByIdStruct=Fst;
  GetById(StrToInt(ppp->Caption));
  MList *Lnew=GetByIdRez;

//MList *Lnew=GetById(,Fst);
    PanelList *PPP=PanelFst->GetPanelById(Lnew->id,PanelFst);
    PPP->realroot->Height+=5;
    Sizer(Lnew->id_parent,5);

ppp->Height+=5;
}
__except(1) {ShowMessage("Выберите элемент для расширения");}
}
//---------------------------------------------------------------------------

void __fastcall TDoc_temp::SpeedButton7Click(TObject *Sender)
{
try
{
  GetByIdStruct=Fst;
  GetById(StrToInt(ppp->Caption));
  MList *Lnew=GetByIdRez;

//MList *Lnew=GetById(StrToInt(ppp->Caption),Fst);
    PanelList *PPP=PanelFst->GetPanelById(Lnew->id,PanelFst);
    PPP->realroot->Height-=5;
    Sizer(Lnew->id_parent,-5);

ppp->Height-=5;
}
__except(1) {ShowMessage("Выберите элемент для уменьшения");}
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::SpeedButton9Click(TObject *Sender)
{
 MMMList Struct;
 for (int i=0;i<MemoList->Count;i++)
 {//of for
 Struct = (MMMList) MemoList->Items[i];
   if (Struct->type==9)
   {//if field of table
    AnsiString parse=Struct->memo->Text;
    AnsiString arr_sel[20]={""};int cnt_sel=0;
    AnsiString new_sel="",new_id="";
    int f=0,sel=0,cnt=0;
    AnsiString tmp="";
     for (int i=1;i<=parse.Length();i++)
     {
     if (parse[i]=='%') {new_id+=tmp+",";tmp="";}
     if (parse[i]==' ') {f=1;cnt++;}
     if (parse[i]!=' '&&f==1) f=0;

     if (f==1&&tmp!="") {int fl=0;
                        if (sel==2) if (tmp.UpperCase()=="AND"||tmp.UpperCase()=="WHERE") {fl=1;tmp+=" ";} else {new_sel+=tmp+" ";fl=1;tmp="";}
                        if (fl==0) new_sel+=tmp+" ";
                        if (tmp.UpperCase()=="SELECT"||tmp.UpperCase()=="AS"||tmp.UpperCase()=="VALUE"&&sel==1) tmp="";

                        }

     if (f==0&&parse[i]!=' ') {tmp+=parse[i];f=0;}
     if (sel==1&&tmp.UpperCase()!="SELECT"&&tmp.UpperCase()!="AS"&&tmp.UpperCase()!="VALUE"&&f==1&&tmp!="")
        {arr_sel[cnt_sel]=tmp;cnt_sel++;f=0;tmp="";}
     if (tmp.UpperCase()=="SELECT"||tmp.UpperCase()=="AS"||tmp.UpperCase()=="VALUE") {sel=1;f=0;}
     if (tmp.UpperCase()=="FROM") sel=2;
     }
     if (cnt_sel==1)
     {//вызываю форму для определения значения параметра
      AnsiString tmp="",rez="";
      int f=0;
       for (int i=1;i<new_id.Length()-1;i++)
       {
       if (f==1) tmp+=new_id[i];
       if (new_id[i]==' ') f=1;
       }
//      ShowMessage(new_sel+" --- "+new_id);
      if (tmp!="")
      {//добавляю в селект ключевое поле
       int fl=0;
       AnsiString temp="";
       for (int i=1;i<=new_sel.Length();i++)
       {
        temp+=new_sel[i];
        if (temp.UpperCase()=="SELECT ") {rez=temp+tmp+",";temp="";}
       }
       rez+=temp;
      }//добавляю в селект ключевое поле
//     if (rez!="") ShowMessage(rez+" || id="+tmp);
     Application->CreateForm(__classid(TField_val), &Field_val);
     Field_val->Edit1->Text=rez;

     Module2DB->Query_doc->Sql->Clear();
     Module2DB->Query_doc->Sql->Add(rez);
     Module2DB->Query_doc->ExecSql();
     Module2DB->Query_doc->Active=true;

      for (int i=0;i<Module2DB->Query_doc->RecordCount;i++)
      {
     TListItem  *ListItem;
       ListItem = Field_val->ListView1->Items->Add();
       ListItem->Caption = Module2DB->Query_doc->FieldByName("value")->AsString;
//       ListItem->StateIndex = Module2DB->Query_doc->FieldByName(tmp)->AsInteger;;

      Module2DB->Query_doc->Next();
      }
     }//вызываю форму для определения значения параметра {end of if}
   }//if field of table
 }//of for
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::AddField(AnsiString string,AnsiString nm)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select create_field("+IntToStr(id_elem)+","+IntToStr(id_doc)+",9,0,'"+string+"','"+nm+"',null)");
//Module2DB->QueryExec->Sql->Add("select create_field("+IntToStr(id_elem)+","+IntToStr(id_doc)+",9,"+IntToStr(num)+",'"+string+"','"+nm+"',null)");
Module2DB->QueryExec->ExecSql();

Doc_temp->Refresh();
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::SpeedButton11Click(TObject *Sender)
{
int main_offset=0,offset=0;
int offsets[20]={0},offset_cnt=0;


 if (SaveFile->Execute())
 {
  int iFileHandle;
   if (FileExists(SaveFile->FileName))
   {
    if ( Application->MessageBox("Файл уже существует\nВы уверены что хотите перезаписать файл:", NULL, MB_OKCANCEL) != IDOK)
    {} // throw to abort if user selects cancel
    else {DeleteFile(SaveFile->FileName);}
   }
  iFileHandle = FileCreate(SaveFile->FileName);

  AnsiString result="<HTML>\n<TITLE>TEST</TITLE>\n<BODY bgcolor=#FFFFFF>\n<TABLE border=0 cellspacing=0 cellpadding=0 width=650>\n <tr>\n";
  FileWrite(iFileHandle,result.c_str(),result.Length());
  main_offset=result.Length();

  int maxcols=MaxCols(NULL);
  AnsiString result1="";

OffsetList *Struct=NULL,*StructNew,*StructOld;
MList *Lnew=Fst;
  while (Lnew!=NULL)
  {
result="";
result1="";
AnsiString mem=Lnew->value,temp="";

if (view==2&&Lnew->idk_template==9)
{//if document
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add("select value from dcd_doc_tbl where id_elem="+IntToStr(Lnew->id)+" and id_doc="+IntToStr(id_document));
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;
        AnsiString val=Module2DB->QueryExec->FieldByName("value")->AsString;

 if (val!="")
 {
// ShowMessage("=="+val+"==");
  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select lst_pr("+val+")");
  Module2DB->QueryExec->ExecSql();
 }
AnsiString val1="",tmp="";
int f=0;
for (int i=1;i<mem.Length();i++)
{
if (f==0&&mem[i]!='%') {val1+=mem[i];}
if (f==1&&mem[i]!='%') {tmp+=mem[i];}
if (mem[i]=='%') f=1;
}
val1+=val+tmp;
if (val1!="")
{
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add(val1);
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;
mem=Module2DB->QueryExec->FieldByName("value")->AsString;
}
}//if document

      for (int s=1;s<=mem.Length();s++)
       {
        if (mem[s]=='\n') temp+="<br>";
        else temp+=mem[s];
       }
int cnt=0;
//ShowMessage("level="+IntToStr(Lnew->level)+" num="+IntToStr(Lnew->num));
if (Lnew->id_parent==NULL)
{
  if (Lnew->id_type=="Перевод строки")
       {
       result=" </tr>\n <tr>\n";
       cnt=0;
//       offset_cnt--;
       int colspan1=maxcols/offset_cnt;
       AnsiString CCC="";
        for (int i=0;i<offset_cnt;i++)
        {
         if ((i+1)<offset_cnt) CCC=IntToStr(colspan1);
         if ((i+1)==offset_cnt) CCC=IntToStr(maxcols-(offset_cnt-1)*colspan1);
         InsertFile(iFileHandle,offsets[i]-1,CCC,"Over");
        }
       offset_cnt=0;
       FileSeek(iFileHandle,0,2);
       }
  else {
        result="  <td valign=top colspan=1";
        offsets[offset_cnt]=main_offset+result.Length();

        int nnn=3;
        AnsiString al=GetValue(Lnew->prop,"align");
        AnsiString align="";
        if (al=="0") {align="Left";nnn=11;}
        if (al=="1") {align="Right";nnn=12;}
        if (al=="2") {align="Center";nnn=13;}

        StructNew = new OffsetList;
        StructNew->id=Lnew->id;
        StructNew->id_parent=Lnew->id_parent;
        StructNew->offset=main_offset+result.Length()+nnn;
        StructNew->level=Lnew->level;
        StructNew->num=Lnew->num;
        if (Struct==NULL) {Struct=StructNew;OffsetFst=StructNew;}
        else StructOld->next=StructNew;
        StructOld=StructNew;
        StructOld->next=NULL;
        OffsetLst=StructOld;

if (Lnew->idk_template==11)
{//if otchet
temp="";
    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add(Lnew->value);
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;
    int cnt_otchr=Module2DB->QueryExec->RecordCount;
    int cnt_otchc=Module2DB->QueryExec->FieldCount;

   Module2DB->QueryExec->First();
   temp="<TABLE border=1>";
    for (int i=1;i<=Module2DB->QueryExec->RecordCount;i++)
    {//begim po ryadam
    temp+="<TR>";
      for (int j=0;j<cnt_otchc;j++)
      {
      temp+="<TD valign=top>"+Module2DB->QueryExec->Fields->Fields[j]->AsString+"</TD>";
      }
    Module2DB->QueryExec->Next();
    temp+="</TR>";
    }//begim po ryadam
   temp+="</TABLE>";
}//if otchet

        result1="";
        if (align!="") result1=" align="+align;
        result1+=">\n "+temp+"\n  </td>\n";
        offset_cnt++;
        cnt++;
       }
}
else
{//of else

}//of else
  AnsiString rez=result+result1;
  if (result!="") FileWrite(iFileHandle,rez.c_str(),rez.Length());
  main_offset+=rez.Length();
  Lnew=Lnew->next;
  }
  result=" </tr>\n</TABLE>\n</BODY>\n</HTML>";
  FileWrite(iFileHandle,result.c_str(),result.Length());

Struct=OffsetLst;
StructOld=OffsetLst;
OffsetList *Onew=OffsetFst;
 while (Onew!=NULL)
 {
 AnsiString rrrez="",result="",result1="";
 Lnew=Fst;
 main_offset=Onew->offset;
 int offsets[20]={0},offset_cnt=0;
 int maxcols=MaxCols(Onew->id);
  while (Lnew!=NULL)
  {
  if (Lnew->id_parent==Onew->id)
   {
//  ShowMessage(IntToStr(Onew->id)+"->"+IntToStr(maxcols));
  AnsiString mem=Lnew->value,temp="";
if (view==2&&Lnew->idk_template==9)
{//if document
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add("select value from dcd_doc_tbl where id_elem="+IntToStr(Lnew->id)+" and id_doc="+IntToStr(id_document));
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;
        AnsiString val=Module2DB->QueryExec->FieldByName("value")->AsString;

 if (val!="")
 {

  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select lst_pr("+val+")");
  Module2DB->QueryExec->ExecSql();
 }
AnsiString val1="",tmp="";
int f=0;
for (int i=1;i<mem.Length();i++)
{
if (f==0&&mem[i]!='%') {val1+=mem[i];}
if (f==1&&mem[i]!='%') {tmp+=mem[i];}
if (mem[i]=='%') f=1;
}
val1+=val+tmp;
if (val1!="")
{
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add(val1);
        Module2DB->QueryExec->ExecSql();
        Module2DB->QueryExec->Active=true;
mem=Module2DB->QueryExec->FieldByName("value")->AsString;
}
}//if document

      for (int s=1;s<=mem.Length();s++)
       {
        if (mem[s]=='\n') temp+="<br>";
        else temp+=mem[s];
       }

  if (Lnew->id_type=="Перевод строки")
       {
       rrrez+="</tr>\n<tr>\n";
       int colspan1=maxcols/offset_cnt;
       AnsiString CCC="";
        for (int i=0;i<offset_cnt;i++)
        {
         if ((i+1)<offset_cnt) CCC=IntToStr(colspan1);
         if ((i+1)==offset_cnt) CCC=IntToStr(maxcols-(offset_cnt-1)*colspan1);
         rrrez=InsertIntoStr(rrrez,offsets[i],CCC);
        }
       offset_cnt=0;
       }
  else {
        result="  <td valign=top colspan=1";
        offsets[offset_cnt]=rrrez.Length()+result.Length()+2;

        StructNew = new OffsetList;
        StructNew->id=Lnew->id;
        StructNew->id_parent=Lnew->id_parent;
        int nnn=3;
        AnsiString al=GetValue(Lnew->prop,"align");
        AnsiString align="";
        if (al=="0") {align="Left";nnn=11;}
        if (al=="1") {align="Right";nnn=12;}
        if (al=="2") {align="Center";nnn=13;}

        StructNew->offset=Onew->offset+rrrez.Length()+result.Length()+nnn+52+8;
        StructNew->level=Lnew->level;
        StructNew->num=Lnew->num;
        if (Struct==NULL) {Struct=StructNew;OffsetFst=StructNew;}
        else StructOld->next=StructNew;
        StructOld=StructNew;
        StructOld->next=NULL;
        OffsetLst=StructOld;

        result1="";
        if (align!="") result1=" align="+align;

if (Lnew->idk_template==11)
{//if otchet
temp="";
    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add(Lnew->value);
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;
    int cnt_otchr=Module2DB->QueryExec->RecordCount;
    int cnt_otchc=Module2DB->QueryExec->FieldCount;

   Module2DB->QueryExec->First();
   temp="<TABLE>";
    for (int i=1;i<=Module2DB->QueryExec->RecordCount;i++)
    {//begim po ryadam
    temp+="<TR>";
      for (int j=0;j<cnt_otchc;j++)
      {
      temp+="<TD>"+Module2DB->QueryExec->Fields->Fields[j]->AsString+"</TD>";
      }
    Module2DB->QueryExec->Next();
    temp+="</TR>";
    }//begim po ryadam
   temp+="</TABLE>";
}//if otchet

        result1+=">\n "+temp+"\n  </td>\n";
        offset_cnt++;
        rrrez+=result+result1;
       }
   }
  Lnew=Lnew->next;
  }

if (rrrez!="")
{
  AnsiString r="<TABLE border=0 cellspacing=0 cellpadding=0 width=650>\n <tr>\n"+rrrez+"\n</tr>\n</TABLE>\n";
  InsertFile(iFileHandle,Onew->offset,r,"Ins");


int parent=Onew->id;
int lev=Onew->level;
int number=Onew->num;
OffsetList *OOnew=OffsetFst;

 while (OOnew!=NULL)
 {
  if (OOnew->level==lev)
   {
   OOnew->offset+=r.Length();
   }
  OOnew=OOnew->next;
 }

// OOnew=OffsetFst;
// while (OOnew!=NULL)
// {
//  if (OOnew->id==parent) {parent=OOnew->id_parent;lev=OOnew->level;number=OOnew->num;break;}
//  OOnew=OOnew->next;
// }

}//if rrrez!=""
  Onew=Onew->next;
 }

 FileClose(iFileHandle);
 }

}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::InsertFile(int iFileHandle, int offset, AnsiString text,AnsiString type)
{
  char *pszBuffer;
  AnsiString result="";
  int off=0;

  if (type=="Over") off=offset+1;
  if (type=="Ins") off=offset;
  int iFileLength=FileSeek(iFileHandle,0,2);
  FileSeek(iFileHandle,off,0);

  pszBuffer = new char[iFileLength+1];
  int iBytesRead = FileRead(iFileHandle, pszBuffer, iFileLength);

  FileSeek(iFileHandle,offset,0);
  result=text;
  FileWrite(iFileHandle,result.c_str(),result.Length());

  result="";
    for (int i=0;i<iBytesRead;i++)
      {
        AnsiString tmp = pszBuffer[i];
        result+=tmp;
      }

  FileWrite(iFileHandle,result.c_str(),result.Length());

}
//---------------------------------------------------------------------------
int __fastcall TDoc_temp::MaxCols(int parent)
{
 MList *Lnew=Fst;
 int max=0,tmp_max=0,f=0;
 int lev;
  while (Lnew!=NULL)
  {
   lev=Lnew->level;
   if (Lnew->id_parent==parent)
   {
    if (Lnew->id_type=="Перевод строки") {if (max<tmp_max) max=tmp_max;tmp_max=0;f=1;}
    else {tmp_max++;}
   }
  Lnew=Lnew->next;
  }

 if (f==1) return max;
 else return tmp_max;
}
//---------------------------------------------------------------------------
void __fastcall TDoc_temp::SpeedButton10Click(TObject *Sender)
{
 if (ActiveControl->ClassNameIs("TStringGrid"))
 {
 TStringGrid *grid=(TStringGrid*) ActiveControl;
 if (grid->Row==0) grid->Cells[grid->Col][grid->Row]=Edit1->Text;
 }
}
//---------------------------------------------------------------------------
AnsiString __fastcall TDoc_temp::InsertIntoStr(AnsiString str,int off,AnsiString cc)
{
  AnsiString temp="";
  for (int s=1;s<=str.Length();s++)
  {
   if (s<off) temp+=str[s];
   if (s==off) temp+=cc;
   if (s>off) temp+=str[s];
  }
  return temp;
}
//---------------------------------------------------------------------------

/*   int handle;
   char string[256];
   int length, res;

   if ((handle = open(SaveFile->FileName.c_str(), O_WRONLY | O_CREAT | O_TRUNC , S_IREAD | S_IWRITE)) == -1)
   {
      ShowMessage("Error opening file");
   }

   strcpy(string, "<HTML>\n<TITLE>TEST</TITLE>\n<BODY>\n");
   length = strlen(string);

   if ((res = write(handle, string, length)) != length)
   {
      ShowMessage("Error writing to the file.\n");
   }

   strcpy(string, "</BODY>\n</HTML>");
   length = strlen(string);

   if ((res = write(handle, string, length)) != length)
   {
      ShowMessage("Error writing to the file.\n");
   }

   close(handle);
   ShowMessage("File saved at PATH:"+SaveFile->FileName);
*/

