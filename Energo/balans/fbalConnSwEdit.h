//---------------------------------------------------------------------------

#ifndef fbalConnSwEditH
#define fbalConnSwEditH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
#include "ZPgSqlQuery.hpp"
#include "TWTCompatable.h"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <Db.hpp>
#include "ZUpdateSql.hpp"
//---------------------------------------------------------------------------
class TfbalConnSwitchEdit : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TBitBtn *btOk;
        TBitBtn *btCancel;
        TPanel *Panel2;
        TPanel *pFiders;
        TLabel *Label3;
        TMaskEdit *edDataB;
        TLabel *Label1;
        TMaskEdit *edDataE;
        TLabel *Label8;
        TEdit *edFiderName;
        TSpeedButton *sbFider;
        TLabel *Label2;
        TMemo *mComment;
        TPanel *Panel3;
        TPanel *Panel4;
        TLabel *Label4;
        TEdit *edFiderName2;
        TSpeedButton *sbFider2;
        TSpeedButton *sbFider2Cl;
        TDBGrid *DBGrid1;
        TZPgSqlQuery *ZQSelect;
        TDataSource *dsSelect;
        TZUpdateSql *ZUpdateSql1;
        TSpeedButton *edDataEClear;
        void __fastcall sbFiderClick(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall btCancelClick(TObject *Sender);
        void __fastcall sbFider2ClClick(TObject *Sender);
        void __fastcall DBGrid1DrawColumnCell(TObject *Sender,
          const TRect &Rect, int DataCol, TColumn *Column,
          TGridDrawState State);
        void __fastcall DBGrid1DblClick(TObject *Sender);
        void __fastcall btOkClick(TObject *Sender);
        void __fastcall edDataEClearClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfbalConnSwitchEdit(TComponent* Owner);
        void __fastcall PlaceAccept (TObject* Sender);
        void __fastcall FiderFilterAccept (TObject* Sender);
        void ShowNew(void);
        void ShowData( int sw_id);

        int FiderFilterId;
        int FiderId;
        int mode;
        int Id;
        TZPgSqlQuery *ZQBalans;
        TWTQuery*  qParent;
};
//---------------------------------------------------------------------------
extern PACKAGE TfbalConnSwitchEdit *fbalConnSwitchEdit;
//---------------------------------------------------------------------------
#endif
