//----------------------------------------------------------------------------
// Классы программы
//----------------------------------------------------------------------------
#ifndef Main1H
#define Main1H
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
#include "ftree.h"
#include "Log.h"

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

#include "Main_equip.h" 

  TWTQuery *InterQuery;
  TWTTable *InterTable;
  TDataSet *InterDataSet;
  TWTTable *InterCommAdrTable;
  TWTTable *InterAccCliTable;
  TDataSet *InterAccCliDataSet;
  TDataSet *InterReprCliDataSet;
  TWTTable *InterReprCliTable;
  TDataSet *InterReprAdrStreetDataSet;
  TWTTable *InterReprAdrStreetTable;


  int id_town;

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
  void _fastcall AdiRegionBtn(TObject *Sender);
  void _fastcall AdiRegionSpr(TWTField  *Sender);
  void _fastcall DoNot(TObject *Sender);
  void _fastcall AdiStreetBtn(TObject *Sender);
  void _fastcall AdiStreetSpr(TWTField  *Sender);
  void _fastcall AdkStreetBtn(TObject *Sender);
  void _fastcall AdkStreetSpr(TWTField  *Sender);
  void _fastcall InsStreet(TWTDBGrid *Sender);
  void _fastcall AdkBuildingSpr(TWTField  *Sender);
  void _fastcall AdkBuildingBtn(TObject *Sender);
  void _fastcall AdkOfficeSpr(TWTField  *Sender);
  void _fastcall AdkOfficeBtn(TObject *Sender);
   void _fastcall AdmAddressSpr(TWTField  *Sender);
  void _fastcall AdmAddressBtn(TObject *Sender);
  void _fastcall AdmAddressMBtn(TObject *Sender);
   void _fastcall AdmAddressMSpr(TWTField  *Sender);
   void _fastcall AdmCommAdrBtn(TObject *Sender);
  void _fastcall  AdmCommAdrSpr(TWTField  *Sender);
  void _fastcall AfterPostStreet(TWTDBGrid *Sender);
  void _fastcall AddIDCommAdr(TWTDBGrid *Sender);
  void _fastcall AfterEditAdr(TWTDBGrid *Sender);
  TWTDBGrid* _fastcall AdmAddressMSel(TWTField *Sender);
  void _fastcall BeforeInsertAdr(TWTDBGrid *Sender);
  void _fastcall CallDoc(TObject *Sender);


    //------------------------------------------------------------------
  void _fastcall DcdDocumentMBtn(TObject *Sender);
  void _fastcall DcdDocumentMSpr(TWTField  *Sender);
// -----------------------------------------------------------------
  void _fastcall CliStateSpr(TWTField *Sender);
  void _fastcall StiPositionBtn(TObject *Sender);          // sti_position_tbl s+g
  void _fastcall StiPositionSpr(TWTField  *Sender);
  void _fastcall StiPersonBtn(TObject *Sender);            // sti_person_tbl   s+g
  void _fastcall StiPersonSpr(TWTField  *Sender);
  void _fastcall StPositionBtn(TObject *Sender);           // st_position_tbl c
  void _fastcall StPositionSpr(TWTField  *Sender);
  void _fastcall StkPhoneBtn(TObject *Sender);             // stk_phone_tbl s+п
  void _fastcall StkPhoneSpr(TWTField  *Sender);
  void _fastcall StdPoneBtn(TObject *Sender);              // std_phone_tbl  c
  void _fastcall StdPoneSpr(TWTField  *Sender);

  void _fastcall DciGroupDocBtn(TObject *Sender);          // dci_group_tbl t
  void _fastcall DciGroupDocSpr(TWTField  *Sender);
  void _fastcall DciDirectionBtn(TObject *Sender);         // dci_direction_tbl s+g
  void _fastcall DciDirectionSpr(TWTField  *Sender);
  void _fastcall DcdReseptionBtn(TObject *Sender);         // dcd_reseption_tbl c
  void _fastcall DcdReseptionSpr(TWTField  *Sender);
  void _fastcall DckResolutionBtn(TObject *Sender);        // dck_resolution_tbl s+g
  void _fastcall DckResolutionSpr(TWTField  *Sender);
  void _fastcall DciTextResolutionBtn(TObject *Sender);    // dci_textresolution_tbl c
  void _fastcall DciTextResolutionSpr(TWTField  *Sender);
  void _fastcall DcdResolutionBtn(TObject *Sender);        // dcd_resolution_tbl  c
  void _fastcall DcdResolutionSpr(TWTField  *Sender);
   TWTDBGrid* _fastcall CliClientMSel(void) ;
  void _fastcall CliClientMBtn(TObject *Sender);
  void _fastcall CliClientMSpr(TWTField  *Sender);
  void _fastcall EnabledButton(TDataSet *DatSet,TWTPanel * MainPan);
  void __fastcall SetBtn(TWTDBGrid *Sender);

  //void _fastcall CliPositionBtn(TObject *Sender);              // cld_firm_tbl c
  //void _fastcall CliPositionSpr(TWTField  *Sender);
  //void _fastcall CliPersonBtn(TObject *Sender);              // cld_firm_tbl c
  //void _fastcall CliPersonSpr(TWTField  *Sender);
  void _fastcall CardClient(TObject *Sender);
  void _fastcall AccClient(TObject *Sender);
  void _fastcall AccClientBtn(TObject *Sender);
  void _fastcall AccClientSpr(TWTField *Sender);
  void _fastcall AfterInsAccount(TWTDBGrid *Sender);
  void _fastcall CmiBankBtn(TObject *Sender);
   void _fastcall CmiBankSpr(TWTField *Sender);

  void _fastcall ClientPositionBtn(TObject *Sender);
  void _fastcall ClientPositionSpr(TWTField  *Sender);
  void _fastcall AfterInsRepresent(TWTDBGrid *Sender);
  void _fastcall CliPersonBtn(TObject *Sender);
  void _fastcall CliPersonSpr(TWTField  *Sender);
  void _fastcall CliPositionBtn(TObject *Sender);
  void _fastcall CliPositionSpr(TWTField  *Sender);
  void __fastcall RepresentClient(TObject *Sender);



  void __fastcall PR1(TObject *Sender);
  void __fastcall ExitParamsGrid(TObject *Sender);
  AnsiString _fastcall CliInterClick(TWTParamItem *Sender);

   void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs);


  // Описание обязательно (можно использовать для настройки меню)
  void _fastcall virtual OnActiveMainFormChange() {};



  };
//----------------------------------------------------------------------------
extern PACKAGE TMainForm *MainForm;
#endif
