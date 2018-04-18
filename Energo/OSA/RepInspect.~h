//---------------------------------------------------------------------------

#ifndef RepInspectH
#define RepInspectH
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
class TfRepInspect : public TForm
{
__published:	// IDE-managed Components
        TxlReport *xlReport;
        TButton *Button1;
        TZPgSqlQuery *ZQXLReps;
        TDataSource *DSRep;
        void __fastcall Button1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfRepInspect(TComponent* Owner);
        int id_head;
           int ResId;
       int AbonId;
       int FiderId;
       int PSId;
       int res_code;

       int InspectorId;
       AnsiString ResName;
       TZPgSqlQuery *ZQReps;
      

       int cur_user;
       AnsiString CurUserName;
       AnsiString CurUserPos;

       AnsiString BossName;
       AnsiString BossPos;

       AnsiString BuhName;
       AnsiString BuhPos;
};
//---------------------------------------------------------------------------
extern PACKAGE TfRepInspect *fRepInspect;
//---------------------------------------------------------------------------
#endif
