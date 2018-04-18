//---------------------------------------------------------------------------

#ifndef dataH
#define dataH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZConnect.hpp"
#include "ZPgSqlCon.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZPgSqlTr.hpp"
#include "ZQuery.hpp"
#include "ZTransact.hpp"
#include <Db.hpp>
//---------------------------------------------------------------------------
class TBase : public TDataModule
{
__published:	// IDE-managed Components
        TZPgSqlDatabase *DataBase;
        TZPgSqlTransact *Transact;
        TZPgSqlQuery *Query;
        TDataSource *DataSource;
        TZPgSqlQuery *Query1;
        TZPgSqlQuery *Query2;
        TZPgSqlQuery *Query3;
private:	// User declarations
public:		// User declarations
        __fastcall TBase(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TBase *Base;
//---------------------------------------------------------------------------
#endif
