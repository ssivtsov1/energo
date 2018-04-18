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
  TWTQuery *QueryInterZap;

  TWTQuery *InterAccCliTable;
  TDataSet *InterAccCliDataSet;

  TDataSet *InterReprCliDataSet;
  TWTQuery *InterReprCliTable;





   TDataSet *InterTaxCliDataSet;
  TWTQuery *InterTaxCliTable;

  int save_pos;
  int MFid_base;
  AnsiString MFname_base;
  AnsiString MFPeriod;
  AnsiString MFHost;
  int id_town;
  int id_docheadPlat;

  HANDLE hInstanceMutex;
  void _fastcall DoNot(TObject *Sender);  // Заглушка
  void _fastcall CloseMonth(TObject *Sender);  // Заглушка
  void _fastcall On_Start_Programm(); 
  /* --------------------------------------------------------*/
  /*      Адрес                                               */

  void _fastcall AdiDomainBtn(TObject *Sender);  // Области
  void _fastcall AdiDomainSpr(TWTField  *Sender);

  void _fastcall AdiTownBtn(TObject *Sender);    // Нас. пункты
  void _fastcall AdiTownSpr(TWTField  *Sender);

  void _fastcall AdkTownBtn(TObject *Sender);
  void _fastcall AdkTownSpr(TWTField  *Sender);  // Типы нас пунктов

  void _fastcall AdiRegionBtn(TObject *Sender);  //  Районы
  void _fastcall AdiRegionSpr(TWTField  *Sender);


  void _fastcall AdiStreetBtn(TObject *Sender); // Улицы
  void _fastcall AdiStreetSpr(TWTField  *Sender);
  void _fastcall InsStreet(TWTDBGrid *Sender);
  void _fastcall AfterPostStreet(TWTDBGrid *Sender);
  void _fastcall  ClientDemandSpr(TWTField *Sender);

  void _fastcall AdkStreetBtn(TObject *Sender);    // Типы улиц
  void _fastcall AdkStreetSpr(TWTField  *Sender);

  void _fastcall AdkBuildingSpr(TWTField  *Sender); // Типы домов
  void _fastcall AdkBuildingBtn(TObject *Sender);

  void _fastcall AdkOfficeSpr(TWTField  *Sender);    // Типы офисов
  void _fastcall AdkOfficeBtn(TObject *Sender);

  void _fastcall AdmCommAdrBtn(TObject *Sender);  // Списки улиц
  void _fastcall  AdmCommAdrSpr(TWTField  *Sender);
  void _fastcall AddIDCommAdr(TWTDBGrid *Sender);

  void _fastcall AdmAddressMineBtn(TObject *Sender);
  void _fastcall AdmAddressMineSpr(TWTField  *Sender);
  void _fastcall AfterEditAdr(TWTDBGrid *Sender);
  TWTDBGrid* _fastcall AdmAddressMSel(TWTField *Sender);
  TWTDBGrid* _fastcall AdmAddressMSel(TWTField *Sender,int pid_address);
  void _fastcall BeforeInsertAdr(TWTDBGrid *Sender);
  void __fastcall SelBookAbon(TObject *Sender);
  void __fastcall EqmAbonFiz(TWTParamsForm *Sender, bool &flag);
  void _fastcall CmiGekBtn(TObject *Sender);
  void _fastcall CmiGekSpr(TWTField *Sender);
  //  void _fastcall EiGekSpr(TWTField *Sender);
  void _fastcall CallDoc(TObject *Sender);
// -----------------------------------------------------------------
  void _fastcall CliStateSpr(TWTField *Sender);
    void __fastcall  ClientAllList(TObject *Sender);
        void __fastcall  ClientRealList(TObject *Sender);
  void _fastcall AfterInsRepRes(TWTDBGrid *Sender);
 TWTDBGrid* _fastcall CliPositionSel(TWTField  *Sender,AnsiString Filt);
  void _fastcall  OnChangeCode(TWTField  *Sender);

  void _fastcall DckDocumentBtn(TObject *Sender);
  void _fastcall DckDocumentSpr(TWTField *Sender);
  void _fastcall DciDocumentBtn(TObject *Sender);
  void _fastcall DciDocumentSpr(TWTField *Sender);
  void _fastcall DciGroupSprT(TWTField *Sender);
  void _fastcall DciGroupSprG(TWTField *Sender);
  void _fastcall DciMDocBtn(TObject *Sender);

  void  _fastcall DciMDocSpr(TWTField *Sender);
  TWTDBGrid *_fastcall DciMDocSel(TWTField *Sender,int id_sel);
  void _fastcall AftBefPostDci(TWTDBGrid *Sender);
  void __fastcall ShowLimitList(TObject *Sender);

  void _fastcall AfterScrollGrParam(TWTDBGrid *Sender);
   void _fastcall PrevLevel(TObject *Sender);
  void _fastcall NextLevel(TObject *Sender);
  void __fastcall OnApplicationMessage(TMsg & Msg, bool & Handled);
 // void _fastcall RepSprBtn(TObject *Sender);
 // void _fastcall RepSpr(TWTField *Sender);
//  TWTDBGrid* _fastcall RepSprSel(TWTField *Sender);
//  void _fastcall AfterPostRep(TWTDBGrid* Sender);
 // void _fastcall AfterInsRep(TWTDBGrid* Sender);
  //void _fastcall AftScrollRep(TWTDBGrid* Sender);

 /* --------------------------------------------------- */
 /*        Клиент                                       */

  TWTDBGrid* _fastcall CliClientMSel(void) ;         // Клиент для выбора
  void _fastcall CliClientMBtn(TObject *Sender);     // Список клиентов
  void _fastcall CliClientMSpr(TWTField  *Sender);
  void _fastcall OnChNameClient(TWTField *Sender);
  void __fastcall  ClientNew(TObject* Sender);
  void __fastcall  ClientAccept (TObject* Sender);
                                                     // Доступ к кнопочкам
  void _fastcall EnabledButton(TDataSet *DatSet,TWTPanel * MainPan);
  void __fastcall SetBtn(TWTDBGrid *Sender);
  void __fastcall SetBtnO(TObject *Sender);
  void _fastcall CardClient(TObject *Sender);        // Карточка клиента
  void _fastcall AccClient(TObject *Sender);         // Счета клиента
  void _fastcall AccClientBtn(TObject *Sender);
  void _fastcall AccClientSpr(TWTField *Sender);
  void _fastcall BeforeInsertClient(TWTDBGrid *Sender);
  void _fastcall AfterInsAccount(TWTDBGrid *Sender);
  void __fastcall ClientNewRec(TDataSet* Sender);

  void _fastcall  OnChangeAccount(TWTField  *Sender);
  TWTDBGrid* _fastcall AccClientSel(int cl,int mfo);
  void _fastcall AfterInsSelAccount(TWTDBGrid *Sender);
  void _fastcall  OnChangeSelAccount(TWTField  *Sender);

  void _fastcall ClientPositionBtn(TObject *Sender);  //Должностные лица клиента
  void _fastcall ClientPositionSpr(TWTField  *Sender);
  void _fastcall ClientPositionResSpr(TWTField  *Sender);
  void __fastcall RepresentClient(TObject *Sender);   // Вызов долж.лиц из списка
  void _fastcall AfterInsRepresent(TWTDBGrid *Sender);
  void _fastcall EqiTMeterSpr(TWTField * Sender);


  void _fastcall CliPersonBtn(TObject *Sender);       // Работники клиента
  void _fastcall CliPersonSpr(TWTField  *Sender);

  void _fastcall CliPositionBtn(TObject *Sender);      // Должности клиента
  void _fastcall CliPositionSpr(TWTField  *Sender);

   void _fastcall ClmOrgBtn(TObject *Sender);      // Должности клиента
  void _fastcall ClmOrgSpr(TWTField  *Sender);

  void _fastcall SaldoClient(TObject *Sender);      // Должности клиента

  AnsiString _fastcall CliInterClick(TWTParamItem *Sender);

  void _fastcall IndicationClient(TObject *Sender);  //Показания клиента
   void _fastcall    ClientIndicationSpr(TWTField  *Sender);
  void _fastcall IndicNew(TObject *Sender);
  void _fastcall IndicGrNew(TWTDBGrid *Sender);
  void _fastcall  OnChangeIndic(TWTField *Sender);
  void _fastcall IndicAccept(TObject *Sender);
  void _fastcall IndicAddNew(TWTDBGrid *Sender);
  void _fastcall IndicAddCl(TWTDBGrid *Sender);
  void  _fastcall BillClient(TObject *Sender);

  void __fastcall ClientBillPred(TObject *Sender);

  void _fastcall CalcPotr(TDataSet *Sender);
  void _fastcall AcmBillBtn(TObject *Sender);
  void  _fastcall AcmBillSpr(TWTField *Sender);
  void _fastcall  ClientKontrPotr(TObject *Sender);
  void _fastcall  ClientBillPrintP(TObject *Sender);
  void _fastcall  ClientDemandPrintP(TObject *Sender);
  void _fastcall  CliSaldRep(TObject *Sender);
  void __fastcall ClientSalDoc(TObject *Sender);

  void _fastcall SebReport(TWTParamsForm *Sender, bool &flag);
 // void _fastcall SebRep(TObject *Sender);
   void _fastcall SebRepDay(TObject *Sender);
    void _fastcall SebRepMonth(TObject *Sender);

  AnsiString _fastcall SprClientClick(TWTParamItem *Sender);
  void _fastcall CliSaldFRep(TWTParamsForm *Sender, bool &flag);
  void _fastcall CliSaldRRep(int pid_client, TDateTime DBeg,TDateTime DEnd);

  void _fastcall CloseRep (TWTDBGrid *Sender);
  void _fastcall PrintSaldo(TObject *Sender);

  AnsiString  _fastcall GetNameFromBase(AnsiString Tablez,AnsiString Fieldz,int idz,AnsiString Wherez=NULL);
  AnsiString _fastcall GetValueFromBase(AnsiString QueryBas);
  TDateTime _fastcall PeriodDate(int id_client,int flag);
  void __fastcall CalcStrafAll(TObject *Sender);
  void _fastcall  OnCangeRegDat(TWTField *Sender);

  /* ----------------------------------------------------------*/
  /*    Общие справочники                                      */

   void _fastcall CmiBankBtn(TObject *Sender);   // Банки
   void _fastcall CmiBankSprA(TObject *Sender);
   void _fastcall CmiBankSpr(TWTField *Sender);
   void _fastcall CmiCurrencyBtn(TObject *Sender);   // Валюты
   void _fastcall CmiCurrencySpr(TWTField *Sender);

    void _fastcall CmmCurrencyBtn(TObject *Sender);   // Валюты
   void _fastcall CmmCurrencySpr(TWTField *Sender);
   void _fastcall CmiKategBtn(TObject *Sender);
   void _fastcall CmiKategSpr(TWTField *Sender);


   void _fastcall AciTarifBtn(TObject *Sender);   // Тарифы
   void _fastcall AciTarifSpr(TWTField *Sender);
//   TWTDBGrid*  _fastcall AciTarifSel(TWTField *Sender);
   TWTDBGrid*  _fastcall AciTarifSel(TWTField *Sender,int id_tar=0);
   void  _fastcall AciTarifAll(TObject *Sender);
   void  _fastcall EqiGroupTarifBtn(TObject *Sender);
   void  _fastcall EqiGroupTarifSpr(TWTField *Sender);
   
void  _fastcall TarifDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);


  
void _fastcall AfterPostGrT(TWTDBGrid *Sender);

void _fastcall AfterPostGrD(TWTDBGrid *Sender);


   void _fastcall EqkZoneBtn(TObject *Sender);   // Типы зон
   void _fastcall EqkZoneSpr(TWTField *Sender);
   TWTWinDBGrid* _fastcall EqkZoneSel(TWTField *Sender);
   void _fastcall AciPrefSpr(TWTField *Sender);
   void _fastcall SelBillPay(TWTField *Sender);
    void _fastcall ChangePayAccount(TWTField* Sender);  
   void _fastcall EqiClassTarifBtn(TObject *Sender);   // Типы зон
   void _fastcall EqiClassTarifSpr(TWTField *Sender);
   void __fastcall ClientCalcPotr(TObject *Sender);
   void __fastcall ClientBillPrint(TObject *Sender);
   void __fastcall CalcExpr(TDataSet *Sender);
   void __fastcall AciHeadPayBtn(TObject *Sender);
   void __fastcall AciHeadPaySpr(TWTField *Sender);
    void __fastcall HeadDrawColumnCell(TObject *Sender,const TRect &Rect,int DataCol,TColumn *Column,TGridDrawState State);
  // void _fastcall BeforeInsertPay(TWTDBGrid* Sender);
   void __fastcall ExitParamsGrid(TObject *Sender);
   void __fastcall EnterParamsGrid(TObject *Sender);
   int _fastcall GetIdFromBase(AnsiString QueryBas,AnsiString Nfield="id");
   void _fastcall ClientMeterChangeSpr(int id_cl, TDateTime date_change,int id_eqp,int num_old, int num_new);
   void  _fastcall TaxClient(TObject *Sender);
   void __fastcall ShowTaxCors(TObject *Sender);  

     void _fastcall  ClientTaxPrint(TObject *Sender);
  void _fastcall  ClientTaxList(TWTField *Sender);
  void __fastcall ClientTaxCorPrint(TObject *Sender);

  void __fastcall TaxDecade1(TObject *Sender);
  void __fastcall TaxDecade2(TObject *Sender);
  void __fastcall TaxDecade3(TObject *Sender);
  void TaxDecadeAll(int decade);

    void __fastcall TaxRebuild1(TObject *Sender);
  void __fastcall TaxRebuild2(TObject *Sender);
  void __fastcall TaxRebuild3(TObject *Sender);
  void __fastcall TaxRebuildAbon(int client, int decade,TObject *Sender);
  void __fastcall TaxCopyToNoPay(TObject *Sender);


  void __fastcall ShowAbonSwitch(TObject *Sender);
  void __fastcall ShowAbonSwitchAll(TObject *Sender);
  void __fastcall ShowAbonAction(TObject *Sender);
  void __fastcall ShowAbonActionAll(TObject *Sender);
  void __fastcall ShowSwitch(TObject *Sender);
  void __fastcall ClientBillTax(TObject *Sender);
  void __fastcall TaxNumNotify(TObject *Sender);
  void __fastcall TaxCorNumNotify(TObject *Sender);
  void __fastcall TaxAvansNumNotify(TObject *Sender);
  void __fastcall TaxRebuild(TObject *Sender);
  void __fastcall TaxDelete(TObject *Sender);
  void __fastcall TaxBuildAvans(TObject *Sender);   
  void __fastcall ShowTaxList(TObject *Sender); 
   void _fastcall ClmSprParMBtn(TObject *Sender);
   void _fastcall ClmSprParMSpr(TWTField *Sender);
   TWTDBGrid* _fastcall ClmSprParMSel(TWTField *Sender,AnsiString StringSel,AnsiString par);
   void _fastcall AfterInsGrParam(TWTDBGrid *Sender);

   void _fastcall ClmSprParSMBtn(TObject *Sender);
   void _fastcall ClmSprParSMSpr(TWTField *Sender);
   TWTDBGrid* _fastcall ClmSprParSMSel(TWTField *Sender,AnsiString StringSel,AnsiString par);
   void _fastcall AfterInsSParam(TWTDBGrid *Sender);
      void _fastcall AfterInsS2Param(TWTDBGrid *Sender);
   void _fastcall PostParam(TWTDBGrid *Sender);
   void _fastcall OnChangeKey(TWTField *Sender);
   void _fastcall CmiTaxBtn(TObject *Sender);


   void  _fastcall CmiTaxSpr(TWTField *Sender);
   //void _fastcall BankPrintP(TObject *Sender);
   void  _fastcall ShowSys(TObject *Sender);
   void __fastcall ShowVers(TObject *Sender);
   TWTDBGrid*  _fastcall CmiTaxSel(TWTField *Sender);
   void __fastcall TMainForm::HeadKwedColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
   void _fastcall SysRelatBtn(TObject *Sender);
   void _fastcall RelAcsept(TObject *Sender);
   void _fastcall SysRelat(TWTField *Sender);
   void _fastcall RelKtpSpr(TWTField *Sender);
   void _fastcall RelLineSpr(TWTField *Sender);
   void __fastcall NonJump(TDataSet *Sender);
   void __fastcall NonJumpSave(TDataSet *Sender);
   void _fastcall RunSkriptRel(TObject *Sender);

   void __fastcall ShowBillList(TObject *Sender);
      void __fastcall ShowInspect(TObject *Sender);
   void __fastcall SprIn(TObject *Sender);
   void __fastcall SprOut(TObject *Sender);
      void __fastcall AskueIn(TObject *Sender);
   void __fastcall OpenMonth(TObject *Sender);
   void _fastcall SelAskueDay(TObject *Sender);
   void __fastcall AskueDay(TWTParamsForm *Sender, bool &flag);
      void _fastcall SelAskueHour(TObject *Sender);
   void __fastcall AskueHour(TWTParamsForm *Sender, bool &flag);
         void _fastcall SelAskueLimit(TObject *Sender);
   void __fastcall AskueLimit(TWTParamsForm *Sender, bool &flag);
   void __fastcall  PickHour(TWTParamsForm *Sender, bool &flag);
   void _fastcall CmiTimeBtn(TObject *Sender);
   void _fastcall CmiTimeSpr(TWTField *Sender);
   void __fastcall Calendar(TObject *Sender);
     void _fastcall SelAskueMG(TObject *Sender);
   void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs);
   void _fastcall TMainForm::ShowRepsForm(TObject *Sender);
   void __fastcall CalcBillAll(TObject *Sender);
   void _fastcall ReLogin(TObject *Sender);
    bool _fastcall BaseReLogin(TObject *Sender);
   void __fastcall ShowSebList(TObject *Sender);
   void __fastcall ShowNKRE4(TObject *Sender);
   void __fastcall ShowiNKRE4(TObject *Sender);
   void __fastcall Users(TObject *Sender);
    void _fastcall ReBasa(TObject *Sender);
     void _fastcall BasaTable(TObject *Sender);
   void __fastcall CancelInsert(TDataSet* DataSet);
    
  void __fastcall ShowFiderWorksList(TObject *Sender);  
   void _fastcall ChangePwd(TObject *Sender);
   void __fastcall Enviroment(TObject *Sender);
   void __fastcall CheckEnv(TObject *Sender);
   void __fastcall Monitor(TObject *Sender);
   void __fastcall ShowSaldoAkt(TObject *Sender);
   void __fastcall ShowConnectDocs(TObject *Sender);
   void __fastcall ShowWorks(TObject *Sender);
   void __fastcall ShowPlombs(TObject *Sender);
   void __fastcall LoadFiz(TObject *Sender);
   void __fastcall ShowWorkPlan(TObject *Sender);
   void __fastcall ShowSSMet(TObject *Sender);
   void _fastcall ExportCall(TObject *Sender);
  // Описание обязательно (можно использовать для настройки меню)
  void _fastcall virtual OnActiveMainFormChange() {};



  };



//----------------------------------------------------------------------------
extern PACKAGE TMainForm *MainForm;
#endif
