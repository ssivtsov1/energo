//---------------------------------------------------------------------------

#ifndef f2kActH
#define f2kActH
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
class TfPrint2krAct : public TForm
{
__published:	// IDE-managed Components
        TZPgSqlQuery *ZQXLReps;
        TxlReport *xlReport;
        TPanel *Panel1;
        TBitBtn *BitBtn1;
        TBitBtn *BitBtn2;
        TLabel *Label1;
        TZPgSqlQuery *ZQXLReps2;
        void __fastcall BitBtn1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfPrint2krAct(TComponent* Owner);
        void PrintAktDem(TDateTime mmgg,int client,int bill);
        void PrintAktDemArea(TDateTime mmgg,int client, int bill);
        void PrintAktDemAreaSum(TDateTime mmgg,int client, int bill);        

        TZPgSqlQuery *ZQuery;
        TDateTime mmgg;
        int id_client;
        int id_pref;
        int idk_doc;
        int id_doc;        
};
//---------------------------------------------------------------------------
extern PACKAGE TfPrint2krAct *fPrint2krAct;
//---------------------------------------------------------------------------
#endif
