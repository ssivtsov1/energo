//---------------------------------------------------------------------------

#ifndef fLoginH
#define fLoginH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include "Query.h"
#include <map.h>

//---------------------------------------------------------------------------
class TfUserLogin : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TComboBox *cbUser;
        TBitBtn *btOk;
        TBitBtn *btCancel;
        TLabel *lUser;
        TEdit *edPassword;
        TLabel *Label1;
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall btOkClick(TObject *Sender);
        void __fastcall btCancelClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfUserLogin(TComponent* Owner);

        TWTQuery * ZQuery;
        typedef map<AnsiString,int> strmap;
        strmap UserMap;
        strmap PersonMap;
        int mode;
};

extern AnsiString GlobalUsrName;
extern int GlobalUsrId;
extern int GlobalPersonId;
//---------------------------------------------------------------------------
extern PACKAGE TfUserLogin *fUserLogin;
//---------------------------------------------------------------------------
#endif
