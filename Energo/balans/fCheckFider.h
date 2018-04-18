//---------------------------------------------------------------------------

#ifndef fCheckFiderH
#define fCheckFiderH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include "ZPgSqlQuery.hpp"
#include "TWTCompatable.h"
#include "ZQuery.hpp"
#include <Db.hpp>
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <Buttons.hpp>
#include "ZUpdateSql.hpp"
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TfFiderCheck : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TPanel *Panel2;
        TLabel *Label1;
        TCheckBox *cbAll;
        TCheckBox *cbSelected;
        TPanel *Panel3;
        TDBGrid *DBGrid1;
        TZPgSqlQuery *ZQSelect;
        TDataSource *dsSelect;
        TBitBtn *btOk;
        TBitBtn *btCancel;
        TZUpdateSql *ZUpdateSql1;
        TPopupMenu *PopupMenu1;
        TMenuItem *nAll;
        TMenuItem *nNo;
        TBitBtn *BitBtn1;
        TBitBtn *btKey;
        void __fastcall FormShow(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall DBGrid1DrawColumnCell(TObject *Sender,
          const TRect &Rect, int DataCol, TColumn *Column,
          TGridDrawState State);
        void __fastcall DBGrid1DblClick(TObject *Sender);
        void __fastcall btOkClick(TObject *Sender);
        void __fastcall cbAllClick(TObject *Sender);
        void __fastcall cbSelectedClick(TObject *Sender);
        void __fastcall nAllClick(TObject *Sender);
        void __fastcall nNoClick(TObject *Sender);
        void __fastcall btCancelClick(TObject *Sender);
        void __fastcall BitBtn1Click(TObject *Sender);
        void __fastcall btKeyClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfFiderCheck(TComponent* Owner);
       TZPgSqlQuery *ZQBalans;
       TDateTime mmgg;        
};
//---------------------------------------------------------------------------
extern PACKAGE TfFiderCheck *fFiderCheck;
//---------------------------------------------------------------------------
#endif
