//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "sql.h"
#include "doc_tmp.h"
#include "docu.h"
#include "docu_mod.h"
#include "add_field.h"
#include "../main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma resource "*.dfm"
TGenerator *Generator;
TCheckBox *Che;
//---------------------------------------------------------------------------
__fastcall TGenerator::TGenerator(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::FormActivate(TObject *Sender)
{
Grid->Cells[0][0]="Таблица";
Grid->Cells[1][0]="Функция";
Grid->Cells[2][0]="Поле";
Grid->Cells[3][0]="Фильтр";
Grid->Cells[4][0]="Поле для связи";
Grid->Cells[5][0]="Условие";
Grid->Cells[6][0]="Главная таблица";
Grid->Cells[7][0]="Функция";
Grid->Cells[8][0]="Главное поле";
Grid->Cells[9][0]="Фильтр";
}
//---------------------------------------------------------------------------
void __fastcall TGenerator::SpeedButton2Click(TObject *Sender)
{
 if (Grid->RowCount>1)
 {
  int row=Grid->Row;
  RemoveRow(row);
 }
}
//---------------------------------------------------------------------------
void __fastcall TGenerator::RemoveRow(int row)
{
 for (int i=1;i<Grid->RowCount;i++)
 {
  if (i>=row)
  {
   for (int j=0;j<Grid->ColCount;j++)
   Grid->Cells[j][i]=Grid->Cells[j][i+1];
  }
 }
 Grid->RowCount--;
}
//---------------------------------------------------------------------------
void __fastcall TGenerator::Ch(TObject *Sender)
{
TEdit *eee = (TEdit*) Sender;
 if (eee->Text!="")
  {
  if (eee->Tag==2) CheckBox2->Checked=true;
  if (eee->Tag==4) CheckBox4->Checked=true;
  if (eee->Tag==5) CheckBox5->Checked=true;
  if (eee->Tag==6) CheckBox6->Checked=true;
  if (eee->Tag==7) CheckBox7->Checked=true;
  if (eee->Tag==8) CheckBox9->Checked=true;
  }
 else
  {
  if (eee->Tag==2) CheckBox2->Checked=false;
  if (eee->Tag==4) CheckBox4->Checked=false;
  if (eee->Tag==5) CheckBox5->Checked=false;
  if (eee->Tag==6) CheckBox6->Checked=false;
  if (eee->Tag==7) CheckBox7->Checked=false;
  if (eee->Tag==8) CheckBox9->Checked=false;
  }

}
//---------------------------------------------------------------------------
void __fastcall TGenerator::ComboBox1Change(TObject *Sender)
{
 if (ComboBox1->Text!="") CheckBox3->Checked=true;
 else CheckBox3->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::SpeedButton1Click(TObject *Sender)
{
 if (CheckBox1->Checked||CheckBox2->Checked||CheckBox3->Checked||CheckBox4->Checked||CheckBox5->Checked||CheckBox6->Checked)
  {
int cnt=Grid->RowCount-1;

if (CheckBox1->Checked)        Grid->Cells[0][cnt]=ListTB->Text;
if (CheckBox8->Checked)        Grid->Cells[1][cnt]=ComboBox3->Text;
if (CheckBox2->Checked)        Grid->Cells[2][cnt]=ListF->Text;
if (CheckBox9->Checked)        Grid->Cells[3][cnt]=Edit6->Text;
if (CheckBox4->Checked)        Grid->Cells[4][cnt]=ListF1->Text;
if (CheckBox3->Checked)        Grid->Cells[5][cnt]=ComboBox1->Text;
if (CheckBox5->Checked)        Grid->Cells[6][cnt]=ListTM->Text;
if (CheckBox10->Checked)       Grid->Cells[7][cnt]=ComboBox4->Text;
if (CheckBox7->Checked)        Grid->Cells[8][cnt]=ListFM->Text;
if (CheckBox6->Checked)        Grid->Cells[9][cnt]=Edit5->Text;

Grid->RowCount++;
Grid->FixedRows=1;
  }
 else
  {
   ShowMessage("Не выбран ни один параметр");
  }

}
//---------------------------------------------------------------------------


void __fastcall TGenerator::SpeedButton3Click(TObject *Sender)
{
  int row=Grid->Row;

 if (row!=0)
  {
   if (CheckBox1->Checked||CheckBox2->Checked||CheckBox3->Checked||CheckBox4->Checked||CheckBox5->Checked||CheckBox6->Checked||CheckBox7->Checked||CheckBox8->Checked||CheckBox9->Checked)
    {
if (CheckBox1->Checked)        Grid->Cells[0][row]=ListTB->Text;
if (CheckBox8->Checked)        Grid->Cells[1][row]=ComboBox3->Text;
if (CheckBox2->Checked)        Grid->Cells[2][row]=ListF->Text;
if (CheckBox9->Checked)        Grid->Cells[3][row]=Edit6->Text;
if (CheckBox4->Checked)        Grid->Cells[4][row]=ListF1->Text;
if (CheckBox3->Checked)        Grid->Cells[5][row]=ComboBox1->Text;
if (CheckBox5->Checked)        Grid->Cells[6][row]=ListTM->Text;
if (CheckBox10->Checked)       Grid->Cells[7][row]=ComboBox4->Text;
if (CheckBox7->Checked)        Grid->Cells[8][row]=ListFM->Text;
if (CheckBox6->Checked)        Grid->Cells[9][row]=Edit5->Text;
    }
   else
    {
        ShowMessage("Не выбран ни один параметр");
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TGenerator::SpeedButton4Click(TObject *Sender)
{
Memo1->Text="";
if (Grid->RowCount-2>0)
{
AnsiString query="select",from=" from", where=" where";

 for (int i=1;i<Grid->RowCount-1;i++)
  {
   if (Grid->Cells[1][i]!="") query+=" "+Grid->Cells[1][i]+"("+Grid->Cells[0][i]+"."+Grid->Cells[2][i]+"),";
   else query+=" "+Grid->Cells[0][i]+"."+Grid->Cells[2][i]+",";
   from+=" "+Grid->Cells[0][i]+",";

   AnsiString bonus="";
   if (Grid->Cells[6][i]!=""&&Grid->Cells[8][i]!="")
   {
   AnsiString query1="select",from1=" from",where1=" where";
         if (Grid->Cells[7][i]!="") query1+=" "+Grid->Cells[7][i]+"("+Grid->Cells[8][i]+")";
         else query1+=" "+Grid->Cells[8][i];

         from1+=" "+Grid->Cells[6][i];
         if (Grid->Cells[9][i]!="") where1+=" "+Grid->Cells[9][i];
         else where1="";
         bonus="("+query1+from1+where1+")";
   }

   if (Grid->Cells[3][i]!="") where+=" "+Grid->Cells[0][i]+"."+Grid->Cells[4][i]+Grid->Cells[3][i]+" and";

   if (Grid->Cells[5][i]=="<>")
    {
     where+=" not "+Grid->Cells[0][i]+"."+Grid->Cells[4][i]+" = "+bonus+" and";
    }
   if (Grid->Cells[5][i]!="<>"&&Grid->Cells[5][i]!="")
    {
     where+=" "+Grid->Cells[0][i]+"."+Grid->Cells[4][i]+"="+bonus+" and";
//     if (Grid->Cells[3][i]=="") where+=" "+Grid->Cells[0][i]+"."+Grid->Cells[2][i]+Grid->Cells[3][i]+" and";
    }

  }
  if (where!=" where") where.SetLength(where.Length()-3);
  else where="";
  query.SetLength(query.Length()-1);
  from.SetLength(from.Length()-1);
AnsiString m=Memo1->Text;
Memo1->Text="";
Memo1->Text=m+query+from+where;
}
}
//---------------------------------------------------------------------------


void __fastcall TGenerator::GridDblClick(TObject *Sender)
{
AnsiString ast=Grid->Cells[Grid->Col][Grid->Row];
if (Che==CheckBox1)        ListTB->Text=ast;
if (Che==CheckBox2)        ListF->Text=ast;
if (Che==CheckBox4)        ListF1->Text=ast;
if (Che==CheckBox3)        ComboBox1->Text=ast;
if (Che==CheckBox5)        ListTM->Text=ast;
if (Che==CheckBox7)        ListFM->Text=ast;
if (Che==CheckBox6)        Edit5->Text=ast;
if (Che==CheckBox9)        Edit6->Text=ast;

}
//---------------------------------------------------------------------------

void __fastcall TGenerator::CheckBox1Click(TObject *Sender)
{
Che = (TCheckBox*) Sender;
}
//---------------------------------------------------------------------------


void __fastcall TGenerator::ComboBox3Change(TObject *Sender)
{
 if (ComboBox3->Text!="") CheckBox8->Checked=true;
 else CheckBox8->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::ComboBox4Change(TObject *Sender)
{
 if (ComboBox4->Text!="") CheckBox10->Checked=true;
 else CheckBox10->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::FormCreate(TObject *Sender)
{
DB->Database=((TMainForm *)Application->MainForm)->InterDatabase->Database;
DB->Login=((TMainForm *)Application->MainForm)->InterDatabase->Login;
DB->Password=((TMainForm *)Application->MainForm)->InterDatabase->Password;
DB->Host=((TMainForm *)Application->MainForm)->InterDatabase->Host;
DB->Connected=true;
DB2Connect->Database=((TMainForm *)Application->MainForm)->InterDatabase->Database;
DB2Connect->Login=((TMainForm *)Application->MainForm)->InterDatabase->Login;
DB2Connect->Password=((TMainForm *)Application->MainForm)->InterDatabase->Password;
DB2Connect->Host=((TMainForm *)Application->MainForm)->InterDatabase->Host;
DB2Connect->Connected=true;

ComboDB->Clear();

Query->Sql->Clear();
Query->Sql->Add("select datname from pg_database");
Query->ExecSql();
Query->Active=true;

Query->First();
 for (int i=0;i<Query->RecordCount;i++)
  {
   ComboDB->Items->Add(Query->FieldByName("datname")->AsString);
   Query->Next();
  }
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::ComboDBChange(TObject *Sender)
{
ListTB->Clear();
ListTM->Clear();
ListFM->Clear();
ListF->Clear();
ListF1->Clear();

AnsiString str=ComboDB->Text;

DB2Connect->Database=str;
DB2Connect->Connected=true;

try
{
 Query1->Sql->Clear();
 Query1->Sql->Add("select relname from pg_class where not relname like 'pg%' and not relname like '%seq' and not relname like '%key'");
 Query1->ExecSql();
 Query1->Active=true;

Query1->First();
 for (int i=0;i<Query1->RecordCount;i++)
  {
   ListTB->Items->Add(Query1->FieldByName("relname")->AsString);
   ListTM->Items->Add(Query1->FieldByName("relname")->AsString);
 Query1->Next();
  }
}
__except(1){ShowMessage("Невозможно соединиться с базой");}


}
//---------------------------------------------------------------------------


void __fastcall TGenerator::ListTBChange(TObject *Sender)
{
 if (ListTB->Text!="")
 {CheckBox1->Checked=true;
 ListF->Clear();
 ListF1->Clear();
AnsiString str=ListTB->Text;

try
{

 Query1->Sql->Clear();
 Query1->Sql->Add("select attname from pg_attribute where attrelid in (select oid from pg_class where relname ='"+str+"')");
 Query1->ExecSql();
 Query1->Active=true;

Query1->First();
 for (int i=0;i<Query1->RecordCount;i++)
  {
   ListF->Items->Add(Query1->FieldByName("attname")->AsString);
   ListF1->Items->Add(Query1->FieldByName("attname")->AsString);
 Query1->Next();
  }
}
__except(1){ShowMessage("Невозможно получить поля");}



 }
 else CheckBox1->Checked=false;

}
//---------------------------------------------------------------------------

void __fastcall TGenerator::ListFChange(TObject *Sender)
{
 if (ListF->Text!="")
 {CheckBox2->Checked=true;}
 else CheckBox2->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::ListF1Change(TObject *Sender)
{
 if (ListF1->Text!="")
 {CheckBox4->Checked=true;}
 else CheckBox4->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::ListTMChange(TObject *Sender)
{
 if (ListTM->Text!="")
 {CheckBox5->Checked=true;
 ListFM->Clear();
AnsiString str=ListTM->Text;

try
{

 Query1->Sql->Clear();
 Query1->Sql->Add("select attname from pg_attribute where attrelid in (select oid from pg_class where relname ='"+str+"')");
 Query1->ExecSql();
 Query1->Active=true;

Query1->First();
 for (int i=0;i<Query1->RecordCount;i++)
  {
   ListFM->Items->Add(Query1->FieldByName("attname")->AsString);
 Query1->Next();
  }
}
__except(1){ShowMessage("Невозможно получить поля");}

 }
 else CheckBox5->Checked=false;
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::ListFMChange(TObject *Sender)
{
 if (ListFM->Text!="")
 {CheckBox7->Checked=true;}
 else CheckBox7->Checked=false;

}
//---------------------------------------------------------------------------

void __fastcall TGenerator::FormClose(TObject *Sender,
      TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

void __fastcall TGenerator::SpeedButton5Click(TObject *Sender)
{
try
{

 Query1->Sql->Clear();
 Query1->Sql->Add(Memo1->Text);
 Query1->ExecSql();
 Query1->Active=true;

 DBGrid1->DataSource=DataSource1;
}
__except(1)
{ShowMessage("Некорректный запрос");}

}
//---------------------------------------------------------------------------

void __fastcall TGenerator::SpeedButton6Click(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
ShowMessage("select create_field("+IntToStr(id_parent)+","+IntToStr(id_doc)+",11,"+IntToStr(num)+",'"+Memo1->Text+"','"+Edit1->Text+"',NULL)");
Module2DB->QueryExec->Sql->Add("select create_field("+IntToStr(id_parent)+","+IntToStr(id_doc)+",11,"+IntToStr(num)+",'"+Memo1->Text+"','"+Edit1->Text+"',NULL)");
Module2DB->QueryExec->ExecSql();

Doc_temp->Refresh();
Generator->Close();
}
//---------------------------------------------------------------------------

