//---------------------------------------------------------------------------

#ifndef fPenInfH
#define fPenInfH
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
#include <ComCtrls.hpp>

//---------------------------------------------------------------------------
class TfPenaInflPrint : public TForm
{
__published:	// IDE-managed Components
        TZPgSqlQuery *ZQXLRepMain;
       // TxlReport *xlReport;
        TPanel *Panel1;
        TBitBtn *BitBtn1;
        TBitBtn *BitBtn2;
        TLabel *Label1;
        TLabel *Label2;
        TSpeedButton *sbDec;
        TEdit *edMonth;
        TSpeedButton *sbInc;
        TDateTimePicker *dtEnd;
        TDateTimePicker *dtBegin;
        TLabel *Label3;
        TZPgSqlQuery *ZQXLRepPen_a;
        TZPgSqlQuery *ZQXLRepPen_r;
        TZPgSqlQuery *ZQXLRepInf_a;
        TZPgSqlQuery *ZQXLRepInfDoc_a;
        TDataSource *dsRepInf_a;
        TZPgSqlQuery *ZQXLRepInf_r;
        TZPgSqlQuery *ZQXLRepInfDoc_r;
        TDataSource *dsRepInf_r;
        TZPgSqlQuery *ZQXLRep3Proc_r;
        TZPgSqlQuery *ZQXLRep3Proc_a;
        TxlReport *xlReport;
        void __fastcall BitBtn1Click(TObject *Sender);
        void __fastcall sbDecClick(TObject *Sender);
        void __fastcall sbIncClick(TObject *Sender);        
private:	// User declarations
public:		// User declarations
        __fastcall TfPenaInflPrint(TComponent* Owner);
        void PrintAkt(int client);

        TDateTime mmgg;
        int id_client;
        TZPgSqlQuery *ZQReps;
        //int id_pref;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfPrint2krAct *fPrint2krAct;
//---------------------------------------------------------------------------
#endif                        
