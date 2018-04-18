//----------------------------------------------------------------------------
#ifndef SprDBGridH
#define SprDBGridH
//----------------------------------------------------------------------------
#include "WinGrid.h"
//----------------------------------------------------------------------------
// TTDbGrid в окне
//----------------------------------------------------------------------------
class TWTSprDBGrid : public TWTWinDBGrid {
public:
  TTEvent AfterClose;

private:
  TWTField* FFieldDest;
  void __fastcall FAfterClose(TWTWinDBGrid* Sender);
  TWTField* __fastcall GetFieldDest();
  void __fastcall SetFieldDest(TWTField* Field);

public:

  _fastcall virtual TWTSprDBGrid(TWinControl *owner, TTEvent FEnter = NULL,bool IsMDI=true);
  _fastcall virtual TWTSprDBGrid(TWinControl *owner, TTEvent FEnter, TStringList *SQL = NULL,bool IsMDI=true);
  _fastcall virtual TWTSprDBGrid(TWinControl *owner, TTEvent FEnter, TWTQuery *query = NULL,bool IsMDI=true);
  _fastcall virtual TWTSprDBGrid(TWinControl *owner, AnsiString Name,bool IsMDI=true);
  _fastcall virtual ~TWTSprDBGrid();

  void virtual _fastcall FOnClose(TObject *Sender, TCloseAction &Action);

  void __fastcall CreateMenu();
  void _fastcall EnterMenu(TObject *Sender);
  TTEvent FEnter;
  TWTField *FieldSource;
  __property TWTField *FieldDest = {read=GetFieldDest, write=SetFieldDest};
  TEdit *EditDestKod;
  TEdit *EditDestName;
  TWTDBGrid * DBGridd;
};
//----------------------------------------------------------------------------
#endif
