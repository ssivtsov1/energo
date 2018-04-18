//---------------------------------------------------------------------------

#ifndef MainH
#define MainH
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
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TZPgSqlDatabase *DB;
        TZPgSqlTransact *Transact;
        TZPgSqlQuery *Query;
        TListBox *ListDB;
        TListBox *ListTB;
        TZPgSqlDatabase *DB2Connect;
        TZPgSqlTransact *T;
        TZPgSqlQuery *Query1;
        TZPgSqlQuery *Query2;
        TListBox *ListF;
        TSplitter *Splitter1;
        TSplitter *Splitter2;
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall ListDBClick(TObject *Sender);
        void __fastcall ListTBClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
