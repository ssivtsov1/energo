//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "data.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma resource "*.dfm"
TBase *Base;
//---------------------------------------------------------------------------
__fastcall TBase::TBase(TComponent* Owner)
        : TDataModule(Owner)
{
}
//---------------------------------------------------------------------------
