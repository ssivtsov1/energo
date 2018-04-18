//----------------------------------------------------------------------------
#ifndef WinDBGridH
#define WinDBGridH
//----------------------------------------------------------------------------
#include "Func.h"
#include "Form.h"
#include "DBGrid.h"
#include "Message.h"
//----------------------------------------------------------------------------
// TTDbGrid в окне
//----------------------------------------------------------------------------
class TWTBrowseRegItem;

typedef void __fastcall (__closure *TWTWinDBGridEvent)(TWTWinDBGrid* Sender);

class TWTWinDBGrid : public TWTMDIWindow {
public:
  TWTBrowseRegItem *RegItem;
  TWTDBGrid *DBGrid;
  TListBox *List;
  TStatusBar *StatusBar;

  // Обработчики событии определяемые пользователем
  TWTWinDBGridEvent AfterCancel;
  TWTWinDBGridEvent AfterClose;
  TWTWinDBGridEvent AfterDelete;
  TWTWinDBGridEvent AfterEdit;
  TWTWinDBGridEvent AfterInsert;
  TWTWinDBGridEvent AfterOpen;
  TWTWinDBGridEvent AfterPost;
  TWTWinDBGridEvent AfterScroll;
  TWTWinDBGridEvent BeforeCancel;
  TWTWinDBGridEvent BeforeClose;
  TWTWinDBGridEvent BeforeDelete;
  TWTWinDBGridEvent BeforeEdit;
  TWTWinDBGridEvent BeforeInsert;
  TWTWinDBGridEvent BeforeOpen;
  TWTWinDBGridEvent BeforePost;
  TWTWinDBGridEvent BeforeScroll;

protected:

private:

  void __fastcall Initialize(bool IsMDI);

  // Для отслеживания изменения размера окна
  void virtual __fastcall OnResize(TObject *Sender);

  void __fastcall FOnColEnter(TObject *Sender);

  void __fastcall FOnReportClick(TObject *Sender);

  void __fastcall FOnTimer(TObject *Sender);
    /*
  void __fastcall FOnPopupReport(TObject *Sender);
  void __fastcall FOnPopupFilter(TObject *Sender);
  */
  // Функции обработки событии TWTDBGrid от TWTQuery
  void __fastcall FAfterCancel(TWTDBGrid* Sender);
  void __fastcall FAfterPost(TWTDBGrid* Sender);
  void __fastcall FAfterClose(TWTDBGrid* Sender);
  void __fastcall FAfterDelete(TWTDBGrid* Sender);
  void __fastcall FAfterEdit(TWTDBGrid* Sender);
  void __fastcall FAfterInsert(TWTDBGrid* Sender);
  void __fastcall FAfterOpen(TWTDBGrid* Sender);
  void __fastcall FAfterScroll(TWTDBGrid* Sender);
  void __fastcall FBeforeCancel(TWTDBGrid* Sender);
  void __fastcall FBeforePost(TWTDBGrid* Sender);
  void __fastcall FBeforeClose(TWTDBGrid* Sender);
  void __fastcall FBeforeDelete(TWTDBGrid* Sender);
  void __fastcall FBeforeEdit(TWTDBGrid* Sender);
  void __fastcall FBeforeInsert(TWTDBGrid* Sender);
  void __fastcall FBeforeOpen(TWTDBGrid* Sender);
  void __fastcall FBeforeScroll(TWTDBGrid* Sender);

public:
  TEdit *Edit;
  _fastcall virtual TWTWinDBGrid(TWinControl *owner, TStringList *SQL=NULL,bool IsMDI=true);
  _fastcall virtual TWTWinDBGrid(TWinControl *owner, TWTQuery *query,bool IsMDI=true);
  _fastcall virtual TWTWinDBGrid(TWinControl *owner, AnsiString Name,bool IsMDI=true);
  _fastcall virtual ~TWTWinDBGrid();

  void virtual __fastcall OnClose(TObject *Sender);

  TToolBar* __fastcall FindToolBar(int Tag);
  void __fastcall InitButtons();

//  void __fastcall FormActivate(TObject *Sender);
//  void __fastcall FormDeActivate(TObject *Sender);
  void virtual __fastcall InitMenu();

  // Добавить колонку к описанию Grid
  TWTField* __fastcall AddColumn(AnsiString Name,AnsiString Label,AnsiString FullLabel=NULL);
  TWTField* __fastcall AddColumn(AnsiString Name);
  // Добавить колонку к описанию Grid
  TWTField* __fastcall AddColumn(int Index);
  // Добавить все колонки к описанию Grid
  void __fastcall AddColumn();
  void __fastcall AlignWidth();

};
//----------------------------------------------------------------------------
#endif
