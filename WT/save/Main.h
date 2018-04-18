//----------------------------------------------------------------------------
// Классы программы
//----------------------------------------------------------------------------
#ifndef MainH
#define MainH
//----------------------------------------------------------------------------
#include <vcl\Controls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Graphics.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Windows.hpp>
#include <vcl\System.hpp>

#include "Func.h"
#include "MainForm.h"
#include "WinGrid.h"
#include "SprGrid.h"
#include "ParamsForm.h"

//----------------------------------------------------------------------------
class TMainForm : public TWTMainForm {
public:
  bool __fastcall OnParameters(TWTMDIWindow *Sender,TStringList *CaptionsList,bool *CheckedList);
  TWTQuery* SprQuery;
  int CountWindow;
  TWTParamsForm* Form;

  TMenuItem *NewWindow;
  TMenuItem *NewWinDBGrid;
  TMenuItem *MessageItem;

  TMenuItem *Mission;
  TMenuItem *GetDateItem;

  TToolButton* Button1;
  TToolButton* Button2;

private:
  void _fastcall CreateMDIChild(const String name);
  void _fastcall ShowHint(TObject *Sender);

  //справочник подразделений для спр. касс
  void __fastcall GuidePodrKas(TWTField* Sender);
  void __fastcall GuidePodrKasTable(TWTField* Sender);
  // справочник ед. измерений для спр. артикулов
  void __fastcall GuideIzm(TWTField* Sender);
  void __fastcall GuideIzmTable(TWTField* Sender);
  // справочник групп товаров для спр. артикулов
  void __fastcall GuideGrp(TWTField* Sender);
  void __fastcall GuideGrpTable(TWTField* Sender);

  // очень нужная вещь
  void __fastcall Sales(AnsiString S);

  //для восстановления окон сохраненных при выходе из программы
  void __fastcall ShowActiveWindows(TStringList* WindowsIDs);

  TWTQuery *QueryTmp;
  TWTWinDBGrid *DBGridMission;
  TWTWinDBGrid *DBGridMission1;
  TWTWinDBGrid *DBGridMission2;
  TWTWinDBGrid *DBGridMission3;
  TWTWinDBGrid *DBGridMission4;
  TWTWinDBGrid *DBGridMissionS;

  TWTWinDBGrid *DBGridGuide1;
  TWTSprDBGrid *DBGridGuide2;
  TWTWinDBGrid *DBGridGuide6;
  TWTWinDBGrid *DBGrid;
   
  void _fastcall OnGetText123(TField* Sender, AnsiString
 &Text, bool DisplayText);

public:

  _fastcall virtual TMainForm(TComponent *owner);
  _fastcall ~TMainForm();

  void __fastcall ShowDoc(TObject *Sender);

  AnsiString _fastcall FOnClick(TWTParamItem *Sender);
  // функции вызываемые из меню
  // справочники по запросу
  void _fastcall SprArt(TObject *Sender);
  void _fastcall SprKass(TObject *Sender);
  void _fastcall SprPodr(TObject *Sender);
  void _fastcall OnOkClick(TWTParamsForm* Sender,bool &CloseFlag);

  // транзакции
  void _fastcall SprTran(TObject *Sender);
  void _fastcall SprTranTable(TObject *Sender);

  // накопление транзакций
  void _fastcall AccTran(TObject *Sender);

  // архив транзакций
  void _fastcall ArhTran(TObject *Sender);
  void _fastcall ArhTranTable(TObject *Sender);

  // проданные артикулы за период
  void _fastcall SalesArtP(TObject *Sender);
  // справочники по таблице
  void _fastcall SprPodrTable(TObject *Sender);
  void _fastcall SprKassTable(TObject *Sender);
  void _fastcall SprArtTable(TObject *Sender);
  void _fastcall SprArtTableF(TWTField *Sender);
  // Описание обязательно (можно использовать для настройки меню)
  void virtual __fastcall OnActiveMainFormChange() {};

};
//----------------------------------------------------------------------------
#endif
