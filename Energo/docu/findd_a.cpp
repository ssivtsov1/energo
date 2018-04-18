//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "findd_a.h"
#include "docu.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFindAdv *FindAdv;
int count,id_doc;
//---------------------------------------------------------------------------
__fastcall TFindAdv::TFindAdv(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TFindAdv::FormActivate(TObject *Sender)
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

               //col//row
StringGrid1->Cells[0][0]="Параметр";
StringGrid1->Cells[1][0]="Значение";
StringGrid1->Cells[2][0]="Точность";
count=1;
StringGrid1->RowCount=2;
}
//---------------------------------------------------------------------------
void __fastcall TFindAdv::FormClose(TObject *Sender, TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
void __fastcall TFindAdv::AddButClick(TObject *Sender)
{
int flag=0;
AnsiString table_name="",field="";
AnsiString one="",two="";

SpeedButton1->Enabled=false;
SpeedButton2->Enabled=false;
if (SpeedButton1->Down==true) table_name="dci_document_tbl";
else table_name="dcm_doc_tbl";

AnsiString where="",param="",value="",exec="включает";
if (PageControl1->ActivePage->Name=="TabSheet1")
{
if (CheckBox1->Checked) {field="name";param="Имя";value=TextFind->Text;flag=1;}
if (CheckBox2->Checked) {field="reg_num";param="Рег. номер";value=TextFind->Text;flag=1;}
if (CheckBox3->Checked) {one="'";two="'";exec="точно";}
else {one="'%";two="%'";}

if (TextFind->Text!=""&&field!="") {

where=" "+field+" like "+one+TextFind->Text+two;
}

}
if (PageControl1->ActivePage->Name=="TabSheet2")
{
     if (RadioButton3->Checked) {param="Дата";value=DateToStr(DateTimePicker3->Date);flag=1;
     where=" reg_date > '%"+DateToStr(DateTimePicker3->Date-1)+"%' and reg_date < '%"+DateToStr(DateTimePicker3->Date+1)+"%'";
        }

     if (RadioButton1->Checked) {param="Дата за период";value="с "+DateToStr(DateTimePicker1->Date)+" по "+DateToStr(DateTimePicker2->Date);flag=1;
     where=" reg_date > '%"+DateToStr(DateTimePicker1->Date-1)+"%' and reg_date < '%"+DateToStr(DateTimePicker2->Date+1)+"%'";
     }

     if (RadioButton2->Checked) {param="За количество месяцев";value=Edit1->Text;flag=1;
     where=" reg_date > '%"+DateToStr(Date()-StrToInt(Edit1->Text)*31+1)+"%'";
     }

     if (RadioButton4->Checked) {param="За количество дней";value=Edit2->Text;flag=1;
     where=" reg_date > '%"+DateToStr(Date()-StrToInt(Edit2->Text)+1)+"%'";
     }

}

if (flag==1)
 {
  StringGrid1->Cells[0][count]=param;
  StringGrid1->Cells[1][count]=value;
  StringGrid1->Cells[2][count]=exec;
  StringGrid1->Cells[3][count]=table_name;
  StringGrid1->Cells[4][count]=where;
  count++;
  StringGrid1->RowCount=count;
 }
if (StringGrid1->RowCount>1) StringGrid1->FixedRows=1;
}
//---------------------------------------------------------------------------
void __fastcall TFindAdv::DelButClick(TObject *Sender)
{
 if (StringGrid1->RowCount>1)
 {
  int row=StringGrid1->Row;
  RemoveRow(row);
        if (StringGrid1->RowCount==1)
        {
         SpeedButton1->Enabled=true;
         SpeedButton2->Enabled=true;
        }
 }
 else
 {
  SpeedButton1->Enabled=true;
  SpeedButton2->Enabled=true;
 }

}
//---------------------------------------------------------------------------
void __fastcall TFindAdv::RemoveRow(int row)
{
 for (int i=1;i<StringGrid1->RowCount;i++)
 {
  if (i>=row)
  {
   for (int j=0;j<StringGrid1->ColCount;j++)
   StringGrid1->Cells[j][i]=StringGrid1->Cells[j][i+1];
  }
 }
 StringGrid1->RowCount--;
 count--;
}
//---------------------------------------------------------------------------
void __fastcall TFindAdv::CheckBox1Click(TObject *Sender)
{
Label2->Caption="Наименование";
CheckBox2->Checked=false;

}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::CheckBox2Click(TObject *Sender)
{
Label2->Caption="Рег. номер";
CheckBox1->Checked=false;

}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::RadioButton3Click(TObject *Sender)
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

void __fastcall TFindAdv::RadioButton1Click(TObject *Sender)
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

void __fastcall TFindAdv::RadioButton2Click(TObject *Sender)
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

void __fastcall TFindAdv::RadioButton4Click(TObject *Sender)
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

void __fastcall TFindAdv::CloseButClick(TObject *Sender)
{
FindAdv->Close();
}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::SpeedButton1Click(TObject *Sender)
{
CheckBox2->Checked=false;
CheckBox2->Enabled=false;
CheckBox1->Checked=true;
}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::SpeedButton2Click(TObject *Sender)
{
CheckBox2->Enabled=true;
}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::FindButClick(TObject *Sender)
{
FindResult->Items->Clear();

AnsiString table_name=StringGrid1->Cells[3][1],where="";
 for (int i=1;i<StringGrid1->RowCount;i++)
 {
  where+=StringGrid1->Cells[4][i];
  if (i+1<StringGrid1->RowCount) where+=" and";
 }
// ShowMessage(table_name);
// ShowMessage("--"+where+"--");

Module2DB->Query_grp->Sql->Clear();
//ShowMessage("select * from "+table_name+" where "+where);
Module2DB->Query_grp->Sql->Add("select * from "+table_name+" where "+where);
Module2DB->Query_grp->ExecSql();
Module2DB->Query_grp->Active=true;

TListItem  *ListItem;
Module2DB->Query_grp->First();
  for (int i=0;i<Module2DB->Query_grp->RecordCount;i++)
  {
   if (Module2DB->Query_grp->FieldByName("name")->AsString!="")
   {
   ListItem = FindResult->Items->Add();
   ListItem->Caption = Module2DB->Query_grp->FieldByName("name")->AsString;
   ListItem->StateIndex = Module2DB->Query_grp->FieldByName("id_grp")->AsInteger;
    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("select name from dci_group_tbl where id="+Module2DB->Query_grp->FieldByName("id_grp")->AsString);
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;

    ListItem->SubItems->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
    ListItem->SubItems->Add(Module2DB->Query_grp->FieldByName("reg_date")->AsString);
   Module2DB->Query_grp->Next();
   }
  }//of for

}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::FindResultChanging(TObject *Sender,
      TListItem *Item, TItemChange Change, bool &AllowChange)
{
id_doc=Item->StateIndex;
}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::FindResultDblClick(TObject *Sender)
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
  FindAdv->Close();
}
//---------------------------------------------------------------------------

void __fastcall TFindAdv::FormCreate(TObject *Sender)
{
  TListColumn  *NewColumn;
  NewColumn = FindResult->Columns->Add();
  NewColumn->Caption = "Имя документа";
  NewColumn->AutoSize=true;
  NewColumn->Width=150;

  NewColumn = FindResult->Columns->Add();
  NewColumn->Caption = "Группа документов";
  NewColumn->AutoSize=true;
  NewColumn->Width=220;

  NewColumn = FindResult->Columns->Add();
  NewColumn->Caption = "Дата";
  NewColumn->AutoSize=true;
  NewColumn->Width=100;

}
//---------------------------------------------------------------------------

