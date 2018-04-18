//----------------------------------------------------------------------------
// Классы программы
//----------------------------------------------------------------------------
#ifndef MainH
#define MainH
//----------------------------------------------------------------------------
#include <vcl.h>
#include "Func.h"
#include "MainForm.h"
#include "WinGrid.h"
#include "SprGrid.h"
#include "ParamsForm.h"
#include "Message.h"
#include "Query.h"
#include "DBGrid.h"
#include "SprGrid.h"
#include "Form.h"

//----------------------------------------------------------------------------
class TMainForm : public TWTMainForm {
public:
  TWTParamsForm* Form;
  AnsiString IDUser;

private:

  TWTQuery *QueryTmp;

public:

  _fastcall virtual TMainForm(TComponent *owner);
  _fastcall ~TMainForm();

  //Первичные Документы
    // void _fastcall AdmAddress(TObject *Sender);
  // справочники по запросу
   //AnsiString _fastcall SprPodrClick(TWTParamItem *Sender);
   //void _fastcall AdiTownBtn(TObject *Sender);
   //void _fastcall AdiTownSpr(TWTField  *Sender);
  void _fastcall AdiDomainBtn(TObject *Sender);
  void _fastcall AdiDomainSpr(TWTField  *Sender);
  void _fastcall AdiTownBtn(TObject *Sender);
  void _fastcall AdiTownSpr(TWTField  *Sender);
  void _fastcall AdkTownBtn(TObject *Sender);
  void _fastcall AdkTownSpr(TWTField  *Sender);
  void _fastcall AdkTownBtn1(TObject *Sender);
  void _fastcall AdkTownSpr1(TWTField  *Sender);

  void _fastcall AdiRegionBtn(TObject *Sender);

  void _fastcall AdiRegionSpr(TWTField  *Sender);
  void _fastcall DoNot(TObject *Sender);
  void _fastcall AdiStreetBtn(TObject *Sender);
  void _fastcall AdiStreetSpr(TWTField  *Sender);
  void _fastcall AdkStreetBtn(TObject *Sender);
  void _fastcall AdkStreetSpr(TWTField  *Sender);
  void _fastcall AdkBuildingSpr(TWTField  *Sender);
  void _fastcall AdkBuildingBtn(TObject *Sender);
  void _fastcall AdkOfficeSpr(TWTField  *Sender);
  void _fastcall AdkOfficeBtn(TObject *Sender);
   void _fastcall AdmAddressSpr(TWTField  *Sender);
  void _fastcall AdmAddressBtn(TObject *Sender);
  void _fastcall AdmAddressMBtn(TObject *Sender);
   void _fastcall AdmAddressMSpr(TWTField  *Sender);
   void _fastcall PR1(TObject *Sender);




  //void _fastcall AdiRegionBtn(TObject *Sender);
  //void _fastcall AdiRegionSpr(TWTField  *Sender);


   void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs);


  // Описание обязательно (можно использовать для настройки меню)
  void _fastcall virtual OnActiveMainFormChange() {};

  };
extern PACKAGE TMainForm *MainForm;
//----------------------------------------------------------------------------
#endif
