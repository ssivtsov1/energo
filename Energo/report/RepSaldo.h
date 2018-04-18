//---------------------------------------------------------------------------

#ifndef RepSaldoH
#define RepSaldoH
//---------------------------------------------------------------------------
#include "main.h"
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <QuickRpt.hpp>
#include <Qrctrls.hpp>
#include <Db.hpp>
#include <DBTables.hpp>
//---------------------------------------------------------------------------
class TPrintSald : public TForm
{
__published:	// IDE-managed Components
        TQuery *Query1;
        TDatabase *Database1;
        TDataSource *DataSource1;
        TUpdateSQL *UpdateSQL1;
        TTable *Table1;
        TDataSource *DataSource2;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall QRDBText1Print(TObject *sender, AnsiString &Value);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall RepDocAfterPreview(TObject *Sender);
private:	// User declarations
public:		// User declarations
       void _fastcall ActivateMenu(TObject *Sender);
       TMenuItem *WindowMenu;
       AnsiString id;

        __fastcall TPrintSald(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TPrintSald *PrintSald;
//---------------------------------------------------------------------------
#endif
