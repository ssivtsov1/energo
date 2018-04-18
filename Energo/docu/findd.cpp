//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "findd.h"
#include "docu.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFind *Find;
int id_doc=0;
//---------------------------------------------------------------------------
__fastcall TFind::TFind(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TFind::CloseButClick(TObject *Sender)
{
Find->Close();
}
//---------------------------------------------------------------------------
void __fastcall TFind::FormActivate(TObject *Sender)
{
PageControl1->ActivePageIndex=0;
if (id_view==1) {SpeedButton1->Down=true;CheckBox2->Checked=false;CheckBox2->Enabled=false;}
if (id_view==2) {SpeedButton2->Down=true;CheckBox2->Enabled=true;}

Edit1->Enabled=false;
Edit2->Enabled=false;
UpDown1->Enabled=false;
UpDown2->Enabled=false;
DateTimePicker1->Enabled=false;
DateTimePicker2->Enabled=false;
RadioButton3->Checked=true;

FindResult->Items->Clear();
TextFind->Text="";
//FindResult->Columns->Clear();

}
//---------------------------------------------------------------------------
void __fastcall TFind::FormClose(TObject *Sender, TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
void __fastcall TFind::FindButClick(TObject *Sender)
{
FindResult->Items->Clear();

AnsiString table_name="",field="";
AnsiString one="",two="";

if (SpeedButton1->Down==true) table_name="dci_document_tbl";
else table_name="dcm_doc_tbl";

if (PageControl1->ActivePage->Name=="TabSheet1")
{
if (CheckBox1->Checked) {field="name";}
if (CheckBox2->Checked) {field="reg_num";}
if (CheckBox3->Checked) {one="'";two="'";}
else {one="'%";two="%'";}

if (TextFind->Text!=""&&field!="") {
Module2DB->Query_grp->Sql->Clear();
Module2DB->Query_grp->Sql->Add("select * from "+table_name+" where "+field+" like "+one+TextFind->Text+two);
Module2DB->Query_grp->ExecSql();
Module2DB->Query_grp->Active=true;
}

}

if (PageControl1->ActivePage->Name=="TabSheet2")
{
        if (RadioButton3->Checked) {
        Module2DB->Query_grp->Sql->Clear();
        Module2DB->Query_grp->Sql->Add("select * from "+table_name+" where reg_date > '%"+DateToStr(DateTimePicker3->Date-1)+"%' and reg_date < '%"+DateToStr(DateTimePicker3->Date+1)+"%'");
        Module2DB->Query_grp->ExecSql();
        Module2DB->Query_grp->Active=true;
        }

     if (RadioButton1->Checked) {
     Module2DB->Query_grp->Sql->Clear();
     Module2DB->Query_grp->Sql->Add("select * from "+table_name+" where reg_date > '%"+DateToStr(DateTimePicker1->Date-1)+"%' and reg_date < '%"+DateToStr(DateTimePicker2->Date+1)+"%'");
     Module2DB->Query_grp->ExecSql();
     Module2DB->Query_grp->Active=true;
     }

     if (RadioButton2->Checked) {
     Module2DB->Query_grp->Sql->Clear();
     Module2DB->Query_grp->Sql->Add("select * from "+table_name+" where reg_date > '%"+DateToStr(Date()-StrToInt(Edit1->Text)*31+1)+"%'");
     Module2DB->Query_grp->ExecSql();
     Module2DB->Query_grp->Active=true;
     }

     if (RadioButton4->Checked) {
     Module2DB->Query_grp->Sql->Clear();
     Module2DB->Query_grp->Sql->Add("select * from "+table_name+" where reg_date > '%"+DateToStr(Date()-StrToInt(Edit2->Text)+1)+"%'");
     Module2DB->Query_grp->ExecSql();
     Module2DB->Query_grp->Active=true;
     }

}

//ShowMessage("select * from "+table_name+" where "+field+" like "+one+TextFind->Text+two);


TListItem  *ListItem;
Module2DB->Query_grp->First();
  for (int i=0;i<Module2DB->Query_grp->RecordCount;i++)
  {
   if (Module2DB->Query_grp->FieldByName("name")->AsString!="")
   {
   ListItem = FindResult->Items->Add();
   ListItem->Caption = Module2DB->Query_grp->FieldByName("name")->AsString;
AnsiString id_grp="";


if (SpeedButton1->Down==true)
{
   id_grp=Module2DB->Query_grp->FieldByName("id_grp")->AsString;
}
else
{
    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("select id_grp from dci_document_tbl where id="+Module2DB->Query_grp->FieldByName("id_document")->AsString);
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;
   id_grp=Module2DB->QueryExec->FieldByName("id_grp")->AsString;
}
   ListItem->StateIndex = StrToInt(id_grp);

    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("select name from dci_group_tbl where id="+id_grp);
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;

    ListItem->SubItems->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
    ListItem->SubItems->Add(Module2DB->Query_grp->FieldByName("reg_date")->AsString);
   Module2DB->Query_grp->Next();
   }
  }//of for

//FindResult->ViewStyle=vsReport;

}
//---------------------------------------------------------------------------
void __fastcall TFind::FindResultChanging(TObject *Sender, TListItem *Item,
      TItemChange Change, bool &AllowChange)
{
id_doc=Item->StateIndex;
}
//---------------------------------------------------------------------------

void __fastcall TFind::FindResultDblClick(TObject *Sender)
{
 if (id_form==1)
 {
if (SpeedButton1->Down==true) {Main_doc->ViewStyle1->Down=true;}
else {Main_doc->ViewStyle2->Down=true;}

  Main_doc->GroupTree->FullExpand();
  int id=0;
  for (int i=0;i<Main_doc->GroupTree->Items->Count;i++)
   {
    if (Main_doc->GroupTree->Items->Item[i]->StateIndex==id_doc) {id=i;break;}
   }
  Main_doc->GroupTree->Items->Item[id]->Focused=true;
  Main_doc->GroupTree->Items->Item[id]->Selected=true;
  Find->Close();
 }
}
//---------------------------------------------------------------------------
void __fastcall TFind::CheckBox1Click(TObject *Sender)
{
Label2->Caption="Наименование";
CheckBox2->Checked=false;
}
//---------------------------------------------------------------------------
void __fastcall TFind::CheckBox2Click(TObject *Sender)
{
Label2->Caption="Рег. номер";
CheckBox1->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TFind::RadioButton1Click(TObject *Sender)
{
Edit1->Enabled=false;
Edit2->Enabled=false;
DateTimePicker3->Enabled=false;

DateTimePicker1->Enabled=true;
DateTimePicker2->Enabled=true;

UpDown1->Enabled=false;
UpDown2->Enabled=false;

}
//---------------------------------------------------------------------------

void __fastcall TFind::RadioButton2Click(TObject *Sender)
{
Edit1->Enabled=true;
Edit2->Enabled=false;
DateTimePicker3->Enabled=false;

DateTimePicker1->Enabled=false;
DateTimePicker2->Enabled=false;

UpDown1->Enabled=true;
UpDown2->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TFind::RadioButton4Click(TObject *Sender)
{
Edit1->Enabled=false;
Edit2->Enabled=true;

DateTimePicker3->Enabled=false;
DateTimePicker1->Enabled=false;
DateTimePicker2->Enabled=false;

UpDown1->Enabled=false;
UpDown2->Enabled=true;
}
//---------------------------------------------------------------------------
void __fastcall TFind::SpeedButton1Click(TObject *Sender)
{
CheckBox2->Checked=false;
CheckBox2->Enabled=false;
CheckBox1->Checked=true;
}
//---------------------------------------------------------------------------

void __fastcall TFind::SpeedButton2Click(TObject *Sender)
{
CheckBox2->Enabled=true;
}
//---------------------------------------------------------------------------

void __fastcall TFind::RadioButton3Click(TObject *Sender)
{
Edit1->Enabled=false;
Edit2->Enabled=false;

DateTimePicker3->Enabled=true;
DateTimePicker1->Enabled=false;
DateTimePicker2->Enabled=false;

UpDown1->Enabled=false;
UpDown2->Enabled=false;

}
//---------------------------------------------------------------------------


void __fastcall TFind::FormCreate(TObject *Sender)
{
id_form=1;
if (id_form==1)
  {
  Find->Caption+="документа";
  TListColumn  *NewColumn;
  NewColumn = FindResult->Columns->Add();
  NewColumn->Caption = "Имя документа";
  NewColumn->AutoSize=true;
  NewColumn->Width=150;

  NewColumn = FindResult->Columns->Add();
  NewColumn->Caption = "Группа документов";
  NewColumn->AutoSize=true;
  NewColumn->Width=235;

  NewColumn = FindResult->Columns->Add();
  NewColumn->Caption = "Дата";
  NewColumn->AutoSize=true;
  NewColumn->Width=100;

 }
}
//---------------------------------------------------------------------------

