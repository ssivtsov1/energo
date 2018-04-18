//---------------------------------------------------------------------------

#ifndef fBillActH
#define fBillActH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "xlcClasses.hpp"
#include "xlReport.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Buttons.hpp>
#include <Db.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TfPrintBillAkt : public TForm
{
__published:	// IDE-managed Components
        TZPgSqlQuery *ZQXLReps;
        TxlReport *xlReport;
        TPanel *Panel1;
        TBitBtn *BitBtn1;
        TBitBtn *BitBtn2;
        TLabel *Label1;
        void __fastcall BitBtn1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfPrintBillAkt(TComponent* Owner);
        void PrintAkt(int id_bill);

        TDateTime mmgg;
        int id_bill;
        int id_client;
        int id_pref;
};
//---------------------------------------------------------------------------
extern PACKAGE TfPrintBillAkt *fPrintBillAkt;
//---------------------------------------------------------------------------
#endif
