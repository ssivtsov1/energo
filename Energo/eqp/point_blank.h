//---------------------------------------------------------------------------

#ifndef point_blankH
#define point_blankH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "xlcClasses.hpp"
#include "xlReport.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
//---------------------------------------------------------------------------
class TfPointAct : public TForm
{
__published:	// IDE-managed Components
        TDataSource *dsPlombs;
        TZPgSqlQuery *ZQPlombs;
        TZPgSqlQuery *ZQPoint;
        TDataSource *dsCompI;
        TDataSource *dsMeterA;
        TZPgSqlQuery *ZQCompI;
        TZPgSqlQuery *ZQMeterA;
        TxlReport *xlReport;
        TZPgSqlQuery *ZQCompU;
        TDataSource *dsMeterR;
        TZPgSqlQuery *ZQMeterR;
        TDataSource *dsMeterG;
        TZPgSqlQuery *ZQMeterG;
private:	// User declarations
public:		// User declarations
        void __fastcall PrintData(int id);
        __fastcall TfPointAct(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfPointAct *fPointAct;
//---------------------------------------------------------------------------
#endif
