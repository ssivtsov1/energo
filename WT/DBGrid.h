//----------------------------------------------------------------------------

// Класс TTDbGrid
//----------------------------------------------------------------------------
#ifndef DBGridH
#define DBGridH
//----------------------------------------------------------------------------
#include <vcl\DBGrids.hpp>
#include <quickrpt.hpp>

class TWTDBGrid;
class TWTWaitForm;
class TWTWinEdit;
class TWTFastSForm;
#include "Query.h"
//#include "Fields.h"
#include "SetQuery.h"
//#include "WinGrid.h"
#include "Message.h"
#include "Func.h"
#include "SelFields.h"
#include "FilterForm.h"
#include "FastSForm.h"
//#include "MyThread.h"
//#include "Form.h"
#include "Table.h"
#include "Common.h"
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
typedef void __fastcall (__closure *TWTDBGridEvent)(TWTDBGrid* Sender);

class TWTWaitForm: public TForm {
friend class TWTWaitThread;
private:
  TSpeedButton *SBOk;
  TTimer *Timer;
  int TickCount;
  TImage *Image;
  void __fastcall FOnTimer(TObject *Sender);
  void __fastcall FOnUserKeyPress(TObject* Sender,char &Key);
  bool FStopEnabled;
  void __fastcall SetStopEnabled(bool Value);
public:
  bool Stop;
  __property bool StopEnabled = {read=FStopEnabled, write=SetStopEnabled};
  __fastcall TWTWaitForm(TComponent* AOwner,AnsiString Label,AnsiString ImageName);
  __fastcall ~TWTWaitForm();
  void _fastcall OnStopClick(TObject *Sender);
};


class TWTSearchParams {
public:
  bool Down;
  bool Case;
  bool Part;
  TStringList *Fields;
  TStringList *Relations;
  TStringList *Values;
  __fastcall TWTSearchParams();
  __fastcall ~TWTSearchParams();
  void __fastcall Clear();
  void __fastcall AddLine(AnsiString Field,AnsiString Relation,AnsiString Value);
  void __fastcall RemoveLine();
  void __fastcall Assign(TWTSearchParams *SP);
};

struct TWTShortCutItem {
  AnsiString Text;
  char Key;
  TShiftState Shift;
  TNotifyEvent Event;
};

class TWTDBGrid : public TDBGrid {
__published:
  //функции для применения во встроенном интерпретаторе
  AnsiString __fastcall Field(AnsiString FieldName);

protected:
  TWTField* FFieldSource;
  TWTField* FFieldDest;
  TWTField* FFieldLook;
  AnsiString FStringDest;
//  TColor FColor;
  double Summa;
  int CntRecord;
  int FlSumma;
  void *FromBM;
  void *ToBM;
  int FromRecord;
  int ToRecord;
  TWTToolBar* FToolBar;
  bool Flag;
  bool FlagCloseQuery;
  bool InsertFlag;
  TNotifyEvent FOnAccept;
  void _fastcall FOnColExit(TObject *Sender);
  void _fastcall FOnColEnter(TObject *Sender);
  void __fastcall FOnPopupUserMenu(TObject *Sender);
  void __fastcall Initialize();
  void __fastcall FSetFieldSource(TWTField* Value);
  void __fastcall FSetFieldDest(TWTField* Value);
  void __fastcall FSetStringDest(AnsiString Value);
  void __fastcall FSetFieldLook(TWTField* Value);
//  void __fastcall FSetColor(TColor Col);
  void __fastcall AcceptEnter();
  void __fastcall InitButtons();
  void __fastcall FUserKeyUp(TObject* Sender, Word &Key, TShiftState Shift);
  void __fastcall FUserKeyDown(TObject* Sender, Word &Key, TShiftState Shift);
  void __fastcall FOnDSStateChange(TObject *Sender);
public:
  __property TWTToolBar* ToolBar = {read=FToolBar, nodefault};
  __property TWTField* FieldSource = {read=FFieldSource, write=FSetFieldSource};
  __property TWTField* FieldDest = {read=FFieldDest, write=FSetFieldDest};
  __property TWTField* FieldLook = {read=FFieldLook, write=FSetFieldLook};

  __property AnsiString StringDest = {read=FStringDest, write=FSetStringDest};
 // __property TColor Color = {read=FColor, write=FSetColor,stored=IsColorStored, default=-2147483643 };

  AnsiString IncrField;
  AnsiString IncrExpr;

  void __fastcall FOnPopupReport(TObject *Sender);
  void __fastcall FOnPopupFilter(TObject *Sender);

  //Получает ID из GlobalIniFile, если не существует возвращает NULL
  AnsiString __fastcall GetID();
  AnsiString __fastcall GetAlias();

  //Копировать данные в файл
  void __fastcall CopyDataToFile(TObject *Sender);

  TWTSearchParams *SearchParams;
  TWTSearchParams *SearchFParams;
  //читаем имена локальных отчетов текущей таблицы
  void __fastcall GetReportsNames(TStrings *Names);

  //читаем имена глобальных отчетов текущей таблицы
  void __fastcall GetGlobalReportsNames(TStrings *Names);

  //Суммирование от записи From по запись To
  void __fastcall SumFromTo(int From,int To);

  //читаем имена всех фильтров текущей таблицы
  void __fastcall GetFiltersNames(TStrings *Names);

  // Список комментариев
  TStrings *ListComment;

  TToolBar* __fastcall FindToolBar();
  // Пока делаем доступным, но временно
  TWTQuery *Query;
  TWTTable *Table;
  TQuickRep *Report;
  TTimer *Timer;
  bool TimerOn;
  bool StateFilter;
  AnsiString LastFilter;
  TListBox *List;

  _fastcall virtual TWTDBGrid(TWinControl *owner, TStringList *SQL = NULL);
  _fastcall virtual TWTDBGrid(TWinControl *owner, TWTQuery *query);
  _fastcall virtual TWTDBGrid(TWinControl *owner, AnsiString Name);
  _fastcall virtual ~TWTDBGrid();

  void __fastcall SetQuery(TWTQuery *Query);

//  void _fastcall OnPreview(TObject *Sender);
  void _fastcall DSUpdateData(TObject *Sender);
  void _fastcall DSDataChange(TObject *Sender, TField *Field);

  // Добавить колонку к описанию Grid
  TWTField* __fastcall AddColumn(AnsiString Name,AnsiString Label,AnsiString FullLabel);
  TWTField* __fastcall AddColumn(AnsiString Name);
  // Добавить колонку к описанию Grid
  // Index - номер колонки в запросе
  TWTField* __fastcall AddColumn(int Index);
  // Добавить все колонки к описанию Grid
  void __fastcall AddColumn();

  // Вставка записи
  void __fastcall InsertRecord();
  // Удаление записи
  void __fastcall DeleteRecord();
  // установка фильтра
  void __fastcall SetFilter(AnsiString Filter);
  void __fastcall SetReadOnly(bool ReadOnly = true);
  void __fastcall Search(AnsiString Value);
  void __fastcall SearchTable(AnsiString Value, int Num);
  void __fastcall SearchQuery(AnsiString Value, int Num);
  // Сохранение изменений в базе данных
  void __fastcall ApplyUpdates();
  // Отмена всех не сохраненных изменений
  void __fastcall CancelUpdates();

  // Обработчики событии определяемые пользователем
  TWTDBGridEvent __fastcall AfterCancel;
  TWTDBGridEvent __fastcall AfterClose;
  TWTDBGridEvent __fastcall AfterDelete;
  TWTDBGridEvent __fastcall AfterEdit;
  TWTDBGridEvent __fastcall AfterInsert;
  TWTDBGridEvent __fastcall AfterOpen;
  TWTDBGridEvent __fastcall AfterPost;
  TWTDBGridEvent __fastcall AfterScroll;
  TWTDBGridEvent __fastcall BeforeCancel;
  TWTDBGridEvent __fastcall BeforeClose;
  TWTDBGridEvent __fastcall BeforeDelete;
  TWTDBGridEvent __fastcall BeforeEdit;
  TWTDBGridEvent __fastcall BeforeInsert;
  TWTDBGridEvent __fastcall BeforeOpen;
  TWTDBGridEvent __fastcall BeforePost;
  TWTDBGridEvent __fastcall BeforeScroll;
  TWTDBGridEvent __fastcall OnNewRecord;
  //TEvent __fastcall OnEnter;
  //TEvent __fastcall OnExit;
  __property  TNotifyEvent OnAccept = {read = FOnAccept, write = FOnAccept};

  // Установка пунктов меню
  void __fastcall InitPopupMenu();

  // функции вызываемые из меню
  // Ввод новой записи
  void _fastcall NewRecordMenu(TObject *Sender);
  // Удаление текущей записи
  void _fastcall DelRecordMenu(TObject *Sender);
  // Поиск
  void _fastcall SearchMenu(TObject *Sender);
  // Продолжение поиска
  void _fastcall ReSearchMenu(TObject *Sender);
  // Установка фильтра
  void _fastcall SetFilterMenu(TObject *Sender);
  // Сортировка по возрастанию
   void _fastcall SortAscMenu(TObject *Sender);
   // Сортировка по убыванию
   void _fastcall SortDeskMenu(TObject *Sender);
  // Снять фильтр
  void _fastcall RemoveFilterMenu(TObject *Sender);
  // Сохранение изменений в базе данных
  void _fastcall ApplyUpdatesMenu(TObject *Sender);
  // Отмена всех не сохраненных изменений
  void _fastcall CancelUpdatesMenu(TObject *Sender);
   // Обновить данные
  void _fastcall RefreshUpdatesMenu(TObject *Sender);
  // Полноэкранное редактирование
  void _fastcall WinEditMenu(TObject *Sender);
  // суммирование по колонке
  void _fastcall SumAllColumn(TObject *Sender);
  // суммирование по выбранным записям
  void _fastcall SumAnyRecord(TObject *Sender);
  // очистка сумматора
  void _fastcall ClearSum(TObject *Sender);

  //Печать
  void _fastcall PrintRep(TObject *Sender);

  // Массив указателей на функции-справочники
  TTEventField *OnEditButtonClick;
  TWTList *ListField;

  // Установить указатель на функцию печати
  TTEvent __fastcall SetReport(TTEvent Event = NULL);

  void __fastcall ReportPrint(AnsiString LoadName);

  void __fastcall FilterPrint(AnsiString LoadName);

  //активизировать DBGrid
  void __fastcall Activate();
 // void __fastcall DeActivate();
  TList* ShortCutList;

  //Установить горячую клавишу
  void __fastcall SetShortCut(AnsiString ShortCutText,TNotifyEvent Event);

  //Удалить горячую клавишу
  void __fastcall RemoveShortCut(AnsiString ShortCutText);

  //полноэкранный просмотр
  TWTWinEdit* WinEdit;

private:

  int isApplyUpdates;

  TTEvent EventReport;

  // Задать строку SQL запроса
  void __fastcall SetSQL(AnsiString *Operator, TStringList *SQL = NULL);

  void __fastcall CreateMenu();
  // Установить обработчики событий
  void __fastcall PutHandles();
  // Обработчик события нажатия клавиш
  void _fastcall FKeyPress(TObject *Sender, char &Key);

  // Полноекранное редактирование
  void __fastcall FullEdit();

  // Функции обработки событии TWTQuery
  void __fastcall FAfterCancel(TDataSet* Sender);
  void __fastcall FAfterPost(TDataSet* Sender);
  void __fastcall FAfterClose(TDataSet* Sender);
  void __fastcall FAfterDelete(TDataSet* Sender);
  void __fastcall FAfterEdit(TDataSet* Sender);
  void __fastcall FAfterInsert(TDataSet* Sender);
  void __fastcall FAfterOpen(TDataSet* Sender);
  void __fastcall FAfterScroll(TDataSet* Sender);
  void __fastcall FBeforeCancel(TDataSet* Sender);
  void __fastcall FBeforePost(TDataSet* Sender);
  void __fastcall FBeforeClose(TDataSet* Sender);
  void __fastcall FBeforeDelete(TDataSet* Sender);
  void __fastcall FBeforeEdit(TDataSet* Sender);
  void __fastcall FBeforeInsert(TDataSet* Sender);
  void __fastcall FBeforeOpen(TDataSet* Sender);
  void __fastcall FBeforeScroll(TDataSet* Sender);
  void __fastcall FOnNewRecord(TDataSet* Sender);
  void __fastcall FOnEnter(TObject* Sender);
  void __fastcall FOnExit(TObject* Sender);

  // Функция вывода справочника
  void _fastcall FOnEditButtonClick(TObject* Sender);
  // двойное нажатие на ячейку
  void _fastcall FOnDblClick(TObject* Sender);
  // обработчик таймера
//  void _fastcall FOnTimer(TObject *Sender);
};
//----------------------------------------------------------------------------
// Окно полноэкранного редактирования (только на основе TWTDBGrid)
//----------------------------------------------------------------------------
class TWTWinEdit : public TWTMDIWindow {
public:

  TPanel *Panel;
  int ToolTag;
  TStatusBar* StatusBar;

  // Список наименовании
  TList *FieldName;
  // Список полей ввода
  TList *ListEdit;
  // Список кнопочек по вызову помощи
  TList *ListButton;

  TWTDBGrid *DBGrid;
  void __fastcall SetComment(AnsiString Comment);
  virtual _fastcall TWTWinEdit(TWTDBGrid *owner);
  virtual _fastcall ~TWTWinEdit();
  TToolBar* __fastcall FindToolBar(int Tag);
  void virtual __fastcall OnClose(TObject *Sender);

  // функции вызываемые из меню
  void _fastcall PriorRecordMenu(TObject *Sender);
  void _fastcall NextRecordMenu(TObject *Sender);
  void _fastcall LastRecordMenu(TObject *Sender);
  void _fastcall FirstRecordMenu(TObject *Sender);

private:

  // Для отслеживания изменения размера окна
  void __fastcall OnResize(TObject *Sender);

  void _fastcall FKeyDown(TObject *Sender, Word &Key, TShiftState Shift);
  void _fastcall FOnExit(TObject *Sender);
  void _fastcall FOnHelpClick(TObject *Sender);
  void _fastcall SetF(TObject *Sender);
};
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
class TMyWindow : public TForm {
public:
  TLabel *LField;
  TComboBox *CBox;
  TLabel *Label;
  TEdit *Edit;
  TBitBtn *Button;
  TPanel *Panel;

private:
  int CountWindow;
public:
  // функции
  _fastcall virtual TMyWindow(TWinControl *owner, AnsiString Str);
  _fastcall virtual ~TMyWindow();

  void _fastcall FKeyPress(TObject *Sender, char &Key);
  void _fastcall ButtonClick(TObject *Sender);
  void virtual OnClose(TObject *Sender, TCloseAction &Action);
};


#endif


