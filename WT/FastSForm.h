//---------------------------------------------------------------------------
#ifndef FastSFormH
#define FastSFormH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Grids.hpp>

//#include "Form.h"
#include "DBGrid.h"
//---------------------------------------------------------------------------
class TWTSearchParams;

class TWTFastSForm : public TWTMDIWindow {
private:
   TWTDBGrid *DBGrid;
   AnsiString CurrentFilter;
   public:
   TWTSearchParams *SearchParams;

   TPanel *Panel1;
   TPanel *Panel2;
   TListBox *LBSource;
   TStringGrid *SGDest;
   TCheckBox  *ChPart;
   TCheckBox  *ChCase;

public:
    __fastcall TWTFastSForm(TWinControl *Owner);
    __fastcall ~TWTFastSForm();
   // void virtual __fastcall OnClose(TObject *Sender, TCloseAction &Action);
    void __fastcall OnChSeekStr(TObject *Sender);
    void _fastcall FOnKeyPress(TObject *Sender, char &Key);
  //  void _fastcall FOnDblClick(TObject *Sender);
};
//---------------------------------------------------------------------------
#endif
