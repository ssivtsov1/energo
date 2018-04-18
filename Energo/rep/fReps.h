//---------------------------------------------------------------------------

#ifndef fRepsH
#define fRepsH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "TWTCompatable.h"
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <OleCtrls.hpp>
#include "xlcClasses.hpp"
#include "xlReport.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
//---------------------------------------------------------------------------
typedef struct
{
  int id;
  AnsiString ident;
  AnsiString full_name;
  AnsiString file_name;
  AnsiString proc_name;
  int params;
} TRepData;

typedef  TRepData* PTRepData;

class TfReports :  public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TPanel *pButtons;
        TBitBtn *btGo;
        TPanel *pReps;
        TTreeView *tReps;
        TBitBtn *btPrint;
        TPanel *Panel2;
        TPanel *pPeriod;
        TLabel *Label1;
        TLabel *Label2;
        TSpeedButton *sbDec;
        TSpeedButton *sbInc;
        TDateTimePicker *dtBegin;
        TDateTimePicker *dtEnd;
        TEdit *edMonth;
        TPanel *pCaption;
        TLabel *lFullName;
        TPanel *pDate;
        TLabel *Label3;
        TDateTimePicker *dtRDate;
        TxlReport *xlReport;
        TZPgSqlQuery *ZQXLReps;
        TZPgSqlQuery *ZQXLRepsSum;
        TPanel *pAbon;
        TLabel *Label4;
        TEdit *edAbonName;
        TSpeedButton *sbAbon;
        TDataSource *DSRep;
        TZPgSqlQuery *ZQXLReps2;
        TLabel *Label5;
        TPanel *pKindEn;
        TLabel *Label6;
        TComboBox *cbKindEnergy;
        TPanel *pValue;
        TLabel *Label7;
        TEdit *edValue;
        TPanel *pFiders;
        TLabel *Label8;
        TSpeedButton *sbFider;
        TEdit *edFiderName;
        TSpeedButton *sbFiderCl;
        TZPgSqlQuery *ZQXLRepsSum2;
        TDataSource *DSRep2;
        TBitBtn *btFile;
        TSpeedButton *SpeedButton1;
        TPanel *pUrFiz;
        TCheckBox *cbFiz;
        TCheckBox *cbUr;
        TPanel *pKey;
        TCheckBox *cbNoKey;
        TPanel *pPS;
        TLabel *Label9;
        TSpeedButton *sbPS;
        TSpeedButton *sbPSCl;
        TEdit *edPSName;
        TPanel *pTarif;
        TLabel *Label10;
        TSpeedButton *sbTarif;
        TSpeedButton *sbTarifCl;
        TEdit *edTarifName;
        TPanel *pInspector;
        TLabel *Label11;
        TSpeedButton *sbInspector;
        TSpeedButton *sbInspectorCl;
        TEdit *edInspector;
        TEdit *edAbonCode;
        TPanel *pPeriod_2;
        TLabel *Label12;
        TLabel *Label13;
        TSpeedButton *sbDec_2;
        TSpeedButton *sbInc_2;
        TDateTimePicker *dtBegin_2;
        TDateTimePicker *dtEnd_2;
        TEdit *edMonth_2;
        TPanel *pAll;
        TCheckBox *cbAll;
        TZPgSqlQuery *ZQXLReps3;
        TZPgSqlQuery *ZQXLRepsSum3;
        TPanel *pLostNolost;
        TCheckBox *cbLNLAll;
        TCheckBox *cbLNLNasNP;
        TDataSource *DSRep3;
        TPanel *pExecutor;
        TLabel *Label14;
        TSpeedButton *sbExecutor;
        TSpeedButton *sbExecutorCl;
        TEdit *edExecutor;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall tRepsChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
        void __fastcall btGoClick(TObject *Sender);
        void __fastcall sbDecClick(TObject *Sender);
        void __fastcall sbIncClick(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall sbAbonClick(TObject *Sender);
        void __fastcall AbonAccept (TObject* Sender);
        void __fastcall sbFiderClick(TObject *Sender);
        void __fastcall sbFiderClClick(TObject *Sender);
        void __fastcall btFileClick(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall sbPSClClick(TObject *Sender);
        void __fastcall sbPSClick(TObject *Sender);
        void __fastcall xlReportBeforeWorkbookSave(TxlReport *Report,
          AnsiString &WorkbookName, AnsiString &WorkbookPath, bool Save);
        void __fastcall sbTarifClick(TObject *Sender);
        void __fastcall sbTarifClClick(TObject *Sender);
        void __fastcall sbInspectorClClick(TObject *Sender);
        void __fastcall sbInspectorClick(TObject *Sender);
        void __fastcall PosAccept (TObject* Sender);
        void __fastcall PosAcceptExecutor (TObject* Sender);        
        void __fastcall edAbonCodeKeyPress(TObject *Sender, char &Key);
        void __fastcall sbDec_2Click(TObject *Sender);
        void __fastcall sbInc_2Click(TObject *Sender);
        void __fastcall cbLNLAllClick(TObject *Sender);
        void __fastcall cbLNLNasNPClick(TObject *Sender);
        void __fastcall sbExecutorClClick(TObject *Sender);
        void __fastcall sbExecutorClick(TObject *Sender);

private:	// User declarations
public:		// User declarations
        __fastcall TfReports(TComponent* Owner);

       void ObSaldo(boolean Build, int kind_energy);
       void Sales(boolean Build,int kind_energy);
       void SalesAbon(boolean Build,int kind_energy);       
       void IndicToDate(void);
       void F32 (TDateTime mmgg, boolean Build);
       void R3Zone_meters (TDateTime mmgg, boolean Build);
       void R3Zone_tar (TDateTime mmgg, boolean Build);
       void PrintTaxBook (TDateTime dt_b, TDateTime dt_e);
       void PrintBillist(TDateTime dtb,TDateTime dte,int kind_energy);
       void PrintPaylist(TDateTime dtb,TDateTime dte,int kind_energy);
       void PrintDebetList(boolean Build,TDateTime dt,TDateTime mmgg,int kind_energy,float val,int d_k);
       void PrintOborotShort(TDateTime mmgg,int kind_energy); 
       void PrintF24(TDateTime mmgg,int kind_energy);
       void PrintAbonTarif(TDateTime mmgg1,TDateTime mmgg2,int kind_energy);
       void PrintAbonVolt(TDateTime mmgg,int kind_energy);
       void PrintAbonDep(TDateTime mmgg,int kind_energy);
       void PrintTaxList(TDateTime mmgg,int kind_energy);
       void PrintNDS(TDateTime mmgg,int kind_energy,boolean Build);
       void PrintNDS2011(TDateTime mmgg,int kind_energy,boolean Build);

       void PrintAbonGrp(TDateTime dtb,TDateTime dte,int kind_energy);
       void PrintAkt1(TDateTime dt,int kind_energy,int client);
       void PrintAkt2(TDateTime dt,int kind_energy,int client);
       void PrintAbonFiders(boolean Build);
       void PrintAbonNoFiders(boolean Build);
        void PrintAbonConnect(boolean Build);
       void PrintTaxBookNew (TDateTime dt_b);
       void PrintTaxBookNew2011 (TDateTime dt_b);
       void PrintTaxBookNew2011_Fast(TDateTime dt_b);       
       void PrintTaxListGrp(TDateTime mmgg,int kind_energy);
       void ObSaldoNDS(boolean Build,int kind_energy);
       void ObSaldoTransit(boolean Build,int kind_energy);       
       void PrintAbonNoDemand( TDateTime mmgg);
       void PrintFor4Nkre(TDateTime mmgg);
       void Print2Zone( TDateTime mmgg);
       void PrintLost_NoLost(TDateTime mmgg);
       void PrintReact_F32(TDateTime mmgg);
       void PrintF49(TDateTime mmgg);
       void PrintRCompens(TDateTime mmgg);
       void ObSaldo_5kr(boolean Build,int kind_energy);
       void PrintAbonLost(TDateTime mmgg1,TDateTime mmgg2,int kind_energy);
       void MetersLighting(TDateTime mmgg);
       void RepAbonCount (TDateTime dt, boolean Build);
       void PrintPayAbonGrp(TDateTime dtb,TDateTime dte,int kind_energy);
       void ObSaldoAbon(TDateTime mmgg,int kind_energy,int client, boolean Build);
       void BillSaldo(TDateTime dat_b,TDateTime dat_e,int kind_energy,int client, boolean Build);
       void ObSaldoAkt( boolean Build);
       void PrintAkt3(TDateTime mmgg,int client);
       void PrintAkt_2zon(TDateTime mmgg,int client);
       void __fastcall PlaceAccept (TObject* Sender);
       void PointsAbon(TDateTime dt,int client);
       void ShowIndicDates(TDateTime mmgg);
       void CountRep2(void);
       void CountRep2_1(void);
       void ObSaldoErr(boolean Build,int kind_energy);
       void Print4NKRE(TDateTime mmgg,boolean Build);
       void ShowSwitching( int mode );
       void PrintMeterNoDemand( TDateTime dtb,TDateTime dte);
       void PrintMeterNoIndication( TDateTime dtb,TDateTime dte);
       void PrintMetersList(void);
       void MetersControlNow( TDateTime dtb,TDateTime dte);
       void MetersControlLate( TDateTime dt);
       void Prognoz(TDateTime mmgg);
       void Prognoz2(TDateTime mmgg);
       void PrintPSAbons(boolean Build);
       void __fastcall PSAccept (TObject* Sender);
       void PrintAkt4(TDateTime mmgg,int kind_energy,int client);
       void __fastcall TarAccept(TObject *Sender);
       void AllPointTarif(TDateTime mmgg,TDateTime dt);
       void PrognozPay(TDateTime mmgg);
       void PrintPointHistErr(TDateTime mmgg,int kind_energy);
       void PrognozPayAdd(TDateTime mmgg);
       void PrognozPayAdd5(TDateTime mmgg);
       void PrintFizAbonFidersDem(TDateTime mmgg, boolean Build );
       void Print9NKRE_d1(TDateTime mmgg);
       void Print9NKRE_d2(TDateTime mmgg);
       void Print9NKRE_d3(TDateTime mmgg);
       void Print8NKRE(TDateTime mmgg);
       void PrintLimitList(TDateTime mmgg);
       void PrintLimitYear(TDateTime mmgg);
       void PrintLimitGroundYear(TDateTime mmgg);             
       void PrintEmptyIndication(TDateTime mmgg);
       void PrintAreaDemand6(TDateTime mmgg);
       void PrintAreaDemand12(TDateTime mmgg);       
       void __fastcall ShowIndicDebtor(TDateTime mmgg, TDateTime rdate);
       void ShowBillDebtor(TDateTime rdate,int kind_energy);
       void PrintBorderRes(void);
       void PrintWormMeters(TDateTime mmgg,int kind_energy);
       void PrintFreeTaxNums(TDateTime mmgg);
       void PrintTaxCheck(TDateTime mmgg,int kind_energy,boolean Build);
       void PrintAbon2Month( TDateTime mmgg1, TDateTime mmgg2);
       void PrintCompens5(TDateTime mmgg1, TDateTime mmgg2, boolean Build);
         void PrintConnAbon(TDateTime mmgg);
         void PrintDocRevis(TDateTime mmgg);
       void PrintPoints10k(TDateTime dtb,TDateTime dte);
       void PrintPointsAll(TDateTime dtb,TDateTime dte);
       void PrintBorderA(void);
       //------------ спец отчет для черниговскоих городских
       void PrintLetterForGor(int client);
       void ShowRentDates(TDateTime mmgg);
       void PointsForCuriers(TDateTime rdate);
       void KurMeter(TDateTime mmgg);
       void PrintNoMeter();
       void PrognozPayDem5(TDateTime mmgg);
       void ShowTableFields(void);
       void PrintTT(TDateTime mmgg,boolean Build);
       void PrintAbonList(void);
       void RepForEN(TDateTime mmgg1, TDateTime mmgg2, boolean Build);
       void RepForENReact(TDateTime mmgg1, TDateTime mmgg2, boolean Build);
       void PrintAbonPointUn(TDateTime dt, boolean Build);
       void PrintAbonsExt(void);
       void Check2KRBills (TDateTime mmgg, boolean Build);
       void Check2KRBillsNoLimit (TDateTime mmgg, boolean Build);

       void PrintAbonFiders_mem(TDateTime mmgg, boolean Build);
       void PrintPsFiders_mem(TDateTime mmgg, boolean Build);
       void PrintAbonFidersInfo(TDateTime mmgg, boolean Build);             

       void PrintAkt5(TDateTime dtb,TDateTime dte,int kind_energy,int client, boolean Build);

       void Monitor_A2(TDateTime dtb,TDateTime dte);
       void Monitor_A3(TDateTime dtb,TDateTime dte);
       void Monitor_A4(boolean Build,TDateTime dtb);


       void Monitor_A2_mem(TDateTime dtb,TDateTime dte);
       void Monitor_A3_mem(TDateTime dtb,TDateTime dte);
       void Monitor_A4_mem(boolean Build,TDateTime dtb);
       void PrintPoints10k_mem(TDateTime dtb,TDateTime dte);
       void Monitor_MSVoltage(TDateTime dtb);


       void PrintAkt_Trans(TDateTime mmgg,int client);
       void PrintAkt_Him(TDateTime mmgg,int client);
       void PrintAkt_Osv(TDateTime mmgg,int client);

       void AbonWithSubAbon(void);

       void WorkRequirementCheck (TDateTime dt);
       void WorkTechCheck (TDateTime dt);
       void WorkControlCheck (TDateTime dt);
       void PlombListAll (TDateTime dt,int client, int inspector);
       void PlombInstall (TDateTime dtb,TDateTime dte,int client, int inspector);       
       void PlombDelete (TDateTime dtb,TDateTime dte,int client, int inspector);
       void WorkListAll (TDateTime dtb,TDateTime dte,int client, int inspector);
       void WarningDebet (boolean Build, TDateTime dt,TDateTime mmgg,int client, int inspector, int list);
       void WarningAvans (boolean Build, TDateTime dt,TDateTime mmgg,int client, int inspector, int list);
       void PrintNasPTarifAbons(TDateTime dtb,TDateTime dte);
       void PrintEqpChanges(TDateTime dtb,TDateTime dte,int id_client, boolean Build);

       void PrintCompens5_2month_fider(TDateTime mmgg, boolean Build);
       void InspectControlReport(TDateTime dtb,TDateTime dte, int inspector );
       void PrintUncheckedMeters(TDateTime dtb,TDateTime dte);

       void ObSaldoDemandYear(boolean Build,int kind_energy);
       void HomeNetsDemand(TDateTime mmgg);
       void PointsNoPlombNoWork(void);
       void PrintPrognozFiders(TDateTime mmgg, boolean Build);
       void PrintPrognozFactFiders(TDateTime mmgg, boolean Build);
       void PrintPrognozFiders_WithFact(TDateTime mmgg, boolean Build);
       void PrintPrognozFidersInsp_WithFact(TDateTime mmgg);       
       void PrintMeterChanges(TDateTime dtb,TDateTime dte, int id_client);

       void PrintAbonFidersDemand(TDateTime dtb,TDateTime dte, int client,  boolean Build);

       void GraficWork_fiders(TDateTime mmgg, int work_type, boolean Build);
       void GraficWork_fiders_fact(TDateTime mmgg, int work_type,boolean Build);
       void PrintAbonFiders_grafic_fact(TDateTime mmgg, boolean Build);

       void Print_Indic_History(TDateTime dtb,TDateTime dte, int id_client, boolean Build);
       void PrintAbonCountMonitor(TDateTime mmgg, boolean Build);
       void Monitor_PS_2010(TDateTime dtb, boolean Build);
       void Monitor_A4_2010(boolean Build,TDateTime dtb);
       void Monitor_A2_2010(TDateTime dtb,TDateTime dte);
       void Monitor_A3_2010(TDateTime dtb,TDateTime dte);

       void PrintAbonFiders_grafic_mem(TDateTime mmgg, boolean Build);
       void DemandLimit_AvansCalc (boolean Build, TDateTime dt,TDateTime pmmgg);
       void BadIndicList(TDateTime mmgg);

       void Print3NKRE(boolean Build,TDateTime dtb,TDateTime dte);

       void PrintAbonPower(TDateTime dt);
       void PrintMeterCheckChanges(TDateTime dtb,TDateTime dte, int id_client);
       void Fider_monitoring(TDateTime dtb,TDateTime dte, boolean Build);
       void Fider_monitoring_2periods(TDateTime dtb,TDateTime dte, TDateTime dtb2,TDateTime dte2, boolean Build);
       void MeterIndicationList(TDateTime dt,int client, int fider, int inspector );
       void PrintTaxList_Abon(TDateTime dtb,TDateTime dte, int client);
       void ShowRentDatesAll(void);

       void MastersPowerDemand (TDateTime dtb,TDateTime dte, boolean Build);
       void Reactiv_2010(TDateTime mmgg1,TDateTime mmgg2);
       void MastersDemandAktList (TDateTime dtb, boolean Build);
       void MastersDemandAkt (TDateTime dtb, int id_client,boolean Build);

       void PrintTaxNDSErrList(TDateTime mmgg);
       void NDS2011_info(TDateTime mmgg,int kind_energy);
       void DublMetersList(void);
       void PrintMeterNoDemandManyMonth(TDateTime mmgg);
       void RentHist (TDateTime mmgg, boolean Build);
       void GraficWork_symmary(TDateTime mmgg, boolean Build);
       void PrintAbonPointDemandYear(TDateTime mmgg,int kind_energy);
       void PrintAkt4List(TDateTime mmgg,int kind_energy);

       void PrintFizAndUnif(TDateTime dtb,TDateTime dte);
       void WorkListDt(TDateTime dtb,TDateTime dte, int inspector);
       void PrintPoinPowerChanges(TDateTime dtb,TDateTime dte, boolean Build);
       void RepPointCount(TDateTime dt, boolean Build);

       void PrintAbonPointProcent(TDateTime mmgg);
       void PrintAbon10k(TDateTime dtb,TDateTime dte);
       void PS10_AbonLoad(TDateTime mmgg);
       void PS35_AbonLoad(TDateTime mmgg);
       void PS35_AbonSummary(TDateTime mmgg);     
       void PrintAreaDemand_mem(TDateTime mmgg, int id_client);
       void PrintAreaDemand_meters(TDateTime mmgg);
       void PrintCommonAccInfo(TDateTime mmgg1, TDateTime mmgg2);

       void PrintAbonTarYear(TDateTime mmgg, int abon);
       void PrintSwitchList(boolean Build);   //07.12.2012
       void CheckAreaParams(void);     // 11.01.2013

       void Check2KRBillsArea (TDateTime mmgg, boolean Build);    // 22.01.2013
       void CheckLimitPowerArea (TDateTime mmgg);  //07.02.2013
       void HomenetLines (void); //08.02.2013
       void PrintAbonCompensList(void); //21.02.2013
       void AbonAreaSummary(); //14.03.2013
       void PS10_Rezerv(TDateTime mmgg); //09.04.2013
       void PS35_Rezerv(void); //29.04.2013
       void Zone_meters_all (TDateTime mmgg, boolean Build); // 21.05.2013
       void Saldo_AllEnergy(TDateTime mmgg,boolean Build); //04.06.2013
       void PrintMetersAvgDemand( TDateTime dtb,TDateTime dte); //06.06.2013
       void AvansAnializ (TDateTime pmmgg,boolean Build ); //18.06.2013  отчет для проверки абонентов, у которых дата аванса -2/-3
       void WorkListNone (TDateTime dtb,TDateTime dte,int client); //07.10.2013 Богдан
       void PrintTTControlList(TDateTime dt, int show_all); //08.10.2013 Прилуки
       void Meters2_5List( TDateTime dt); //24.10.2013 - Служебка Тарараки от 23.10.2013
       void MetersAndTTControlWarning( TDateTime dt); //25.10.2013 - Служебка Тарараки от 23.10.2013, новая форма для печати требований выполнить поверку
       void PS10_AbonDemand (TDateTime dtb,TDateTime dte); //17.01.2014 - Просьба из Корюковки
       void PrintAbonPointDemandYear_Magnet(TDateTime mmgg);  //27.01.2014 -
       void Reactiv_2014(TDateTime mmgg1, TDateTime mmgg2); //29.01.2014 - РЕС просили
       void Print2kr2014(TDateTime mmgg) ; //псевдо-оборотка для 2кр без ПДВ (фактически сумма оплаты)
       void PrintLimitAreaChange(TDateTime dtb,TDateTime dte); //18.02.2014 - РЕС просили
       void PrintAbonOwnNeeds(TDateTime mmgg1,TDateTime mmgg2,int kind_energy); //23.03.2014 - служебка МЕМ
       void AbonDebetPay(TDateTime mmgg,boolean Build,int kind_energy);//23.03.2014 - служебка МЕМ
       void PrintAbonExtra(TDateTime mmgg,int kind_energy);//23.03.2014 - служебка МЕМ
       void ObSaldoAbonForAll(TDateTime mmgg,int kind_energy, boolean Build); //10.04.2014 для разбора кредита прошлых лет
       void PrintOldKt(TDateTime dt,int kind_energy); //10.04.2014 для разбора кредита прошлых лет
       void MastersDemandAktListDetail (TDateTime dtb, boolean Build); //03.06.2014 - в ходе отладки основного отчета почувствовал необходимость
       void MastersDemandLostsDetail (TDateTime dtb, boolean Build); //12.06.2014 - запрос от городских
       void PrintTaxCheckDecade(TDateTime mmgg,int kind_energy); //14.01.2015 - новый порядок выписки НН, нужен отчет для контроля
       void PrintTaxCorList(TDateTime mmgg); //05.02.2015 - перечень корректировок НН для загрузки в 1С
       void PrintTaxCheckStr(TDateTime mmgg); //10.02.2015 - контроль многострочной части в НН
       void PrintTaxCheckNoPay(TDateTime mmgg); //13.02.2015 - контроль сводной корректировки по неплатникам
       void PrintSlavComon(TDateTime mmgg);
       void R3Zone_fiz_meters (TDateTime mmgg, boolean Build); //02.04.2015 - 3 зонные исп. тарифы населения (просит сбыт)
       void Print2ZoneFiz( TDateTime mmgg);  //02.04.2015 - 2 зонные исп. тарифы населения (просит сбыт)
       void PrintPlombFastChange(TDateTime dtb,TDateTime dte); // 28.05.2014 - по просьбе МЕМ
       void PrintTTSummary(TDateTime dt); // 01.09.2015 - служебка
       void PrintNDS2016(TDateTime mmgg,int kind_energy,boolean Build); //03.02.2016 - новая форма на 2016 год
       void PrintOborotF1(TDateTime mmgg,int kind_energy); // 30.03.2016 проверка разбиения по периодам в форме 1

       void PrintAbonFiders_04(TDateTime mmgg, boolean Build); // 29.06.2016 - для контроля ввода линий 0.4 кВ
       void PrintAbonPointPower(TDateTime dt); // 15.08.2016 - служебка от сбыта
       void PrintPsFidersNew(TDateTime mmgg, boolean Build); // 23.11.2016 - служебка от сбыта (Патрис Иванович)
       void PrintPsFidersNewDem(TDateTime mmgg1,TDateTime mmgg2, boolean Build);  // 23.11.2016 - служебка от сбыта (Патрис Иванович)
       void AbonLines (void); //19.12.2016 пожелание МЕМ
       void AbonPoints (void); //20.12.2016 пожелание МЕМ
       void PrintMeterChangesAvgDem(TDateTime dtb,TDateTime dte );  //15.05.2017 служебка, Палий
       void PrintAbonSummaryFiders_04(TDateTime mmgg, boolean Build);//18.07.2017 Просьба от РЕС

       void BillDeleted(TDateTime mmgg,int kind_energy); //23.10.2017 Просьба Иванова

       void ShowSwitchingNew( int mode );  //20.11.2017 Новая структура таблицы предупреждений/отключений
       //------------
       int ResId;
       int AbonId;
       int FiderId;
       int PSId;
       float PSVolt;
       int res_code;
       int TarifId;
       int InspectorId;
       int ExecutorId;
       AnsiString ResName;
       AnsiString ResFullName;
       AnsiString ResAddr;
       AnsiString ResPhone;
       AnsiString AbonFullName;
       TZPgSqlQuery *ZQReps;
       TList* NodeDataList;
       TTreeNode *CurReport;

       int cur_user;
       AnsiString CurUserName;
       AnsiString CurUserPos;
       AnsiString CurUserPhone;       

       AnsiString BossName;
       AnsiString BossPos;
       AnsiString BossPhone;

       AnsiString BuhName;
       AnsiString BuhPos;

};
//---------------------------------------------------------------------------
//extern PACKAGE TfReports *fReports;
//---------------------------------------------------------------------------
#endif
