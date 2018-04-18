//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------


void __fastcall TForm1::FormCreate(TObject *Sender)
{
ListDB->Clear();

Query->Sql->Clear();
Query->Sql->Add("select datname from pg_database");
Query->ExecSql();
Query->Active=true;

Query->First();
 for (int i=0;i<Query->RecordCount;i++)
  {
   ListDB->Items->Add(Query->FieldByName("datname")->AsString);
   Query->Next();
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ListDBClick(TObject *Sender)
{
ListTB->Clear();
ListF->Clear();

int id=ListDB->ItemIndex;
AnsiString str=ListDB->Items->Strings[id];

DB2Connect->Database=str;
DB2Connect->Connected=true;

try
{
 Query1->Sql->Clear();
 Query1->Sql->Add("select description from pg_description where objoid in (select oid from pg_class where relname in (select relname from pg_class where not relname like 'pg%' and not relname like '%seq' and not relname like '%key'))");
 Query1->ExecSql();
 Query1->Active=true;

Query1->First();
 for (int i=0;i<Query1->RecordCount;i++)
  {
   ListTB->Items->Add(Query1->FieldByName("description")->AsString);
 Query1->Next();
  }
}
__except(1){ShowMessage("Невозможно соединиться с базой");}

}
//---------------------------------------------------------------------------
void __fastcall TForm1::ListTBClick(TObject *Sender)
{
ListF->Clear();
int id=ListTB->ItemIndex;
AnsiString str=ListTB->Items->Strings[id];

try
{
/* Query1->Sql->Clear();
 Query1->Sql->Add("");
 Query1->ExecSql();
 Query1->Active=true;
 str=Query1->FieldByName("relname")->AsString;*/

 Query1->Sql->Clear();
//ShowMessage("select description from pg_description where objoid in (select oid from pg_attribute where attrelid in (select oid from pg_class where relname ))");
 Query1->Sql->Add("select description from pg_description where objoid in (select oid from pg_attribute where attrelid in (select oid from pg_class where relname in (select relname from pg_class where oid in (select objoid from pg_description where description='"+str+"'))))");
 Query1->ExecSql();
 Query1->Active=true;

Query1->First();
 for (int i=0;i<Query1->RecordCount;i++)
  {
   ListF->Items->Add(Query1->FieldByName("description")->AsString);
 Query1->Next();
  }
}
__except(1){ShowMessage("Невозможно получить поля");}

}
//---------------------------------------------------------------------------

