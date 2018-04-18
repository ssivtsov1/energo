//---------------------------------------------------------------------------

#ifndef SysBaseH
#define SysBaseH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
 #include <DBGrids.hpp>
#include <WinGrid.h>
#include "TWTCompatable.h"
#include "Query.h"

//---------------------------------------------------------------------------
class TfBaseLogin : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TBitBtn *btOk;
        TBitBtn *btCancel;
        TLabel *lUser;
        TLabel *Label1;
        TEdit *EdHost;
        TEdit *EdAlias;
        TSpeedButton *SbAlias;
        TLabel *LabAlias;
        TEdit *EdEncod;

        void __fastcall FormCreate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall btOkClick(TObject *Sender);
        void __fastcall SbAliasClick(TObject *Sender);
        void __fastcall EdAliasExit(TObject *Sender);
       TWTDBGrid* __fastcall SbAliasSel(TObject *Sender);
        void __fastcall btCancelClick(TObject *Sender);
        void __fastcall EdAliasChange(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfBaseLogin(TComponent* Owner);
        void __fastcall BazaAccept(TObject *Sender);
        AnsiString AliasE;
         AnsiString EncodE;
        AnsiString HostE;
        TWTQuery * ZQuery;
        int Check;
        TWTDBGrid* GrBas;
       /* typedef map<AnsiString,int> strmap;
        strmap UserMap; */
};

extern PACKAGE TfBaseLogin *fBaseLogin;
//---------------------------------------------------------------------------
 extern AnsiString Alias_;
 extern AnsiString Host_;


//---------------------------------------------------------------------------
//extern PACKAGE TfBaseTable *fBaseTable;
//---------------------------------------------------------------------------

class TfBaseTable : public TWTForm
{
__published:	// IDE-managed Components

private:	// User declarations
public:		// User declarations
       TWTWinDBGrid *WGrid;
        TWTQuery *QTabl;
      __fastcall TfBaseTable(TComponent* Owner);
      void __fastcall DelTable(TObject *Sender);
       void _fastcall OnAcceptTable(TObject *Sender);
       void __fastcall AllTable(TObject *Sender);
};

extern PACKAGE TfBaseTable *fBaseTable;


class TfBaseField : public TWTForm
{
__published:	// IDE-managed Components

private:	// User declarations

public:		// User declarations
        int id_tabl;
         TWTWinDBGrid *WGrid;
        TWTQuery *QTabl;
      __fastcall TfBaseField(TComponent* Owner);
      __fastcall BaseFieldShow(TWTDBGrid *TablGrid);
};

extern PACKAGE TfBaseField *fBaseField;
//__fastcall TfBaseField::TfBaseFieldShow(TWTDBGrid *TablGrid)


class TfBaseTableA : public TWTForm
{
__published:	// IDE-managed Components

private:	// User declarations

public:		// User declarations
         TWTWinDBGrid *WGrid;
        TWTQuery *QTabl;
      __fastcall TfBaseTableA(TComponent* Owner);

};

extern PACKAGE TfBaseTableA *fBaseTableA;
#endif
