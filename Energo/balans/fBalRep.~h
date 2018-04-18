//---------------------------------------------------------------------------

#ifndef fBalRepH
#define fBalRepH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Qrctrls.hpp>
#include <QuickRpt.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
#include <QRCtrls.hpp>
#include <QRExport.hpp>
#include "xlcClasses.hpp"
#include "xlReport.hpp"
//---------------------------------------------------------------------------
class TfBalansRep : public TForm
{
__published:	// IDE-managed Components
        TQuickRep *qrStationBalans;
        TQRBand *ColumnHeaderBand1;
        TQRShape *QRShape2;
        TQRShape *QRShape3;
        TQRShape *QRShape4;
        TQRShape *QRShape5;
        TQRShape *QRShape7;
        TQRShape *QRShape11;
        TQRShape *QRShape13;
        TQRLabel *QRLabel12;
        TQRLabel *QRLabel14;
        TQRLabel *QRLabel15;
        TQRLabel *QRLabel20;
        TQRLabel *QRLabel22;
        TQRLabel *QRLabel23;
        TQRLabel *QRLabel31;
        TQRBand *TitleBand1;
        TQRBand *PageFooterBand1;
        TQRBand *qrEntryFooter;
        TQRShape *QRShape1;
        TQRShape *QRShape6;
        TQRShape *QRShape14;
        TQRLabel *QRLabel1;
        TQRLabel *QRLabel2;
        TQRLabel *QRLabel3;
        TQRShape *QRShape8;
        TQRShape *QRShape9;
        TQRShape *QRShape10;
        TQRLabel *QRLabel4;
        TQRLabel *QRLabel5;
        TQRLabel *QRLabel6;
        TQRExpr *QRExpr1;
        TQRSysData *QRSysData1;
        TZPgSqlQuery *ZQPrepare;
        TQRBand *SummaryBand1;
        TQRExpr *QRExpr3;
        TQRExpr *QRExpr4;
        TQRLabel *QRLabel9;
        TQRLabel *qrlStation;
        TQRLabel *qrlMMGG;
        TQuickRep *qrTreeDemand;
        TQRBand *QRBand1;
        TQRShape *QRShape15;
        TQRLabel *QRLabel10;
        TQRLabel *QRLabel16;
        TQRLabel *QRLabel24;
        TQRShape *QRShape23;
        TQRShape *QRShape24;
        TQRShape *QRShape25;
        TQRLabel *QRLabel26;
        TQRLabel *QRLabel27;
        TQRBand *QRBand2;
        TQRLabel *QRLabel32;
        TQRLabel *qrlStation2;
        TQRLabel *qrlMMGG2;
        TQRBand *QRBand3;
        TQRSysData *QRSysData2;
        TQRBand *QRBand4;
        TQRExpr *QRExpr21;
        TQRExpr *QRExpr22;
        TQRShape *QRShape16;
        TQRShape *QRShape17;
        TQRLabel *QRLabel11;
        TQRLabel *QRLabel13;
        TQRExpr *QRExpr17;
        TQRExpr *QRExpr14;
        TQRExpr *QRExpr15;
        TQRExpr *QRExpr19;
        TQRGroup *QRGroup_f04;
        TQRGroup *QRGroup_f110;
        TQRGroup *QRGroup_s110;
        TQRGroup *QRGroup_e110;
        TQRGroup *QRGroup_f35;
        TQRGroup *QRGroup_s35;
        TQRGroup *QRGroup_e35;
        TQRGroup *QRGroup_f10;
        TQRGroup *QRGroup_s10;
        TQRGroup *QRGroup_e10;
        TZPgSqlQuery *ZQTreeDemand;
        TQRExpr *QRExpr16;
        TQRExpr *QRExpr20;
        TQRExpr *QRExpr24;
        TQRExpr *QRExpr25;
        TQRExpr *QRExpr26;
        TQRExpr *QRExpr27;
        TQRExpr *QRExpr28;
        TQRExpr *QRExpr29;
        TQRExpr *QRExpr30;
        TQRExpr *QRExpr31;
        TQRExpr *QRExpr32;
        TQuickRep *qrTreeLosts;
        TQRBand *QRBand5;
        TQRShape *QRShape20;
        TQRLabel *QRLabel42;
        TQRShape *QRShape32;
        TQRLabel *QRLabel48;
        TQRBand *QRBand7;
        TQRLabel *QRLabel53;
        TQRLabel *qrlStation3;
        TQRLabel *qrlMMGG3;
        TQRBand *QRBand8;
        TQRSysData *QRSysData3;
        TQRGroup *QRGroup2_f110;
        TQRGroup *QRGroup2_s110;
        TQRGroup *QRGroup2_e110;
        TQRGroup *QRGroup2_f35;
        TQRGroup *QRGroup2_s35;
        TQRGroup *QRGroup2_e35;
        TQRGroup *QRGroup2_f10;
        TQRGroup *QRGroup2_s10;
        TQRGroup *QRGroup2_e10;
        TQRGroup *QRGroup2_f04;
        TQRExpr *QRExpr52;
        TQRExpr *QRExpr53;
        TZPgSqlQuery *ZQTreeLosts;
        TQRBand *QRBand9;
        TQRExpr *QRExpr33;
        TQRExpr *QRExpr38;
        TQRExpr *QRExpr34;
        TQRExpr *QRExpr35;
        TQRExpr *QRExpr36;
        TQRExpr *QRExpr37;
        TQRExpr *QRExpr39;
        TQRExpr *QRExpr40;
        TQRExpr *QRExpr56;
        TQRExpr *QRExpr57;
        TQRExpr *QRExpr58;
        TQRExpr *QRExpr54;
        TQRExpr *QRExpr59;
        TQRExpr *QRExpr61;
        TQRExpr *QRExpr62;
        TQRExpr *QRExpr64;
        TQRExpr *QRExpr65;
        TQRExpr *QRExpr67;
        TQRExpr *QRExpr72;
        TQRExpr *QRExpr73;
        TQRExpr *QRExpr74;
        TQRExpr *QRExpr41;
        TQRExpr *QRExpr42;
        TQRExpr *QRExpr5;
        TQRExpr *QRExpr6;
        TQRExpr *QRExpr7;
        TQRExpr *QRExpr43;
        TQRExpr *QRExpr44;
        TQRExpr *QRExpr45;
        TQRExpr *QRExpr47;
        TQRExpr *QRExpr48;
        TQRExpr *QRExpr49;
        TQRExpr *QRExpr46;
        TQRSysData *QRSysData4;
        TQRShape *QRShape18;
        TQRLabel *QRLabel43;
        TZPgSqlQuery *ZQFiderBal;
        TQRChildBand *ChildBand1;
        TQRLabel *QRLabel17;
        TQRExpr *QRExpr50;
        TQRExpr *QRExpr51;
        TQRLabel *QRLabel19;
        TQRExpr *QRExpr55;
        TQRLabel *QRLabel25;
        TZPgSqlQuery *ZQSummBal;
        TQuickRep *qrSummBal;
        TQRBand *QRBand6;
        TQRShape *QRShape34;
        TQRShape *QRShape36;
        TQRLabel *QRLabel38;
        TQRLabel *QRLabel40;
        TQRShape *QRShape37;
        TQRShape *QRShape38;
        TQRShape *QRShape39;
        TQRLabel *QRLabel45;
        TQRLabel *QRLabel46;
        TQRLabel *QRLabel47;
        TQRShape *QRShape40;
        TQRShape *QRShape41;
        TQRShape *QRShape42;
        TQRLabel *QRLabel49;
        TQRLabel *QRLabel50;
        TQRLabel *QRLabel51;
        TQRBand *QRBand10;
        TQRLabel *QRLabel52;
        TQRLabel *qrlResName4;
        TQRLabel *qrlMMGG4;
        TQRBand *QRBand11;
        TQRBand *QRBand12;
        TQRExpr *QRExpr89;
        TQRExpr *QRExpr90;
        TQRExpr *QRExpr91;
        TQRExpr *QRExpr92;
        TQRExpr *QRExpr96;
        TQRExpr *QRExpr97;
        TQRShape *QRShape21;
        TQRLabel *QRLabel35;
        TQRExpr *QRExpr87;
        TQRShape *QRShape12;
        TQRLabel *QRLabel21;
        TQRExpr *QRExpr94;
        TQRLabel *qrlResName;
        TQRLabel *qrlResName3;
        TQRLabel *qrlResName2;
        TQRExcelFilter *QRExcelFilter1;
        TQRRTFFilter *QRRTFFilter1;
        TZPgSqlQuery *ZQBalLev1_e;
        TZPgSqlQuery *ZQBalLev2;
        TZPgSqlQuery *ZQBalRoot;
        TDataSource *dsBalRoot;
        TQRExpr *QRDBText8;
        TQRExpr *QRDBText3;
        TQRExpr *QRDBText4;
        TQRExpr *QRDBText5;
        TQRExpr *QRExpr12;
        TQRExpr *QRDBText6;
        TQRExpr *QRExpr13;
        TQRExpr *QRExpr93;
        TQRExpr *QRExpr18;
        TQRExpr *QRExpr23;
        TQRExpr *QRExpr60;
        TQRExpr *QRExpr63;
        TQRExpr *QRExpr66;
        TQRGroup *QRGroup1;
        TQRLabel *QRLabel18;
        TQRSubDetail *QRSubDetail2;
        TQRSubDetail *QRSubDetail1;
        TQRGroup *QRGroup2;
        TQRLabel *QRLabel28;
        TQRBand *QRStBalSum;
        TQRLabel *QRLabel33;
        TQRLabel *QRLabel34;
        TQRLabel *qrBalPS;
        TQRLabel *qrBalPSpr;
        TQRBand *QRMain;
        TQRExpr *QRExpr2;
        TQRExpr *QRExpr11;
        TQRExpr *QRExpr68;
        TQRExpr *QRExpr69;
        TQRExpr *QRExpr70;
        TQRExpr *QRExpr71;
        TQRExpr *QRExpr75;
        TQRExpr *QRExpr76;
        TZPgSqlQuery *ZQBalLev1_f;
        TxlReport *xlReportFiders;
        TQRSubDetail *QRsdMeters;
        TQRExpr *QRExpr77;
        TQRExpr *QRExpr78;
        TQRExpr *QRExpr79;
        TQRExpr *QRExpr80;
        TQRExpr *QRExpr81;
        TZPgSqlQuery *ZQBalMeters;
        TDataSource *dsMetersSrc;
        TQRLabel *qrlAbonDem;
        TQRLabel *QRLabel7;
        TZPgSqlQuery *ZQFiderBalXL;
        TZPgSqlQuery *ZQPSMeters;
        TZPgSqlQuery *ZQPSDemand;
        TZPgSqlQuery *ZQPSBal;
        TDataSource *dsPSBal;
        TZPgSqlQuery *ZQXLReps;
        TQRExpr *QRExpr8;
        TQRShape *QRShape19;
        TQRLabel *QRLabel8;
        TQRShape *QRShape22;
        TQRBand *SummaryBand2;
        TQRExpr *QRExpr9;
        TQRExpr *QRExpr10;
        TQRExpr *QRExpr82;
        TQRExpr *QRExpr83;
        TQRExpr *QRExpr84;
        TQRLabel *QRLabel29;
        TQRShape *QRShape26;
        TQRExpr *QRExpr_datb;
        TQRExpr *QRExpr_date;
        TDataSource *DSRep;
        TZPgSqlQuery *ZQXLRepsSum;
        TZPgSqlQuery *ZQDemandNew;
        TZPgSqlQuery *ZQDemandNewSum;
        TDataSource *dsDemandNewSum;
        TZPgSqlQuery *ZQMidPointBal;
        TZPgSqlQuery *ZQMidPointDemand;
        TZPgSqlQuery *ZQMidPointMeters;
        TDataSource *dsMidPointBal;
        TZPgSqlQuery *ZQXLReps2;
        TZPgSqlQuery *ZQXLReps3;
        TZPgSqlQuery *ZQXLReps4;

        void __fastcall QRGroup_BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRGroup2_f110BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRF10ChildBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRGroup2BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRGroup1BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRSubDetail1BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRSubDetail2BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRStBalSumBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRGroup2_s10BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall xlReportFidersBeforeWorkbookSave(TxlReport *Report,
          AnsiString &WorkbookName, AnsiString &WorkbookPath, bool Save);
private:	// User declarations
public:		// User declarations
        int ResId;
        AnsiString ResName;
        AnsiString ReportName;
        __fastcall TfBalansRep(TComponent* Owner);
        void __fastcall ShowBalansStation(int id_station,TDateTime mmgg,AnsiString name_station,int type_eqp,int show_meters);
        void __fastcall ShowTreeDemand(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage);
        void __fastcall ShowTreeLosts(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage);
        void __fastcall ShowBalansSumm(TDateTime mmgg);
        void __fastcall FidersToXL(int selected,TDateTime mmgg);
        void __fastcall FidersToXLYear(int selected,TDateTime mmgg);        
        void __fastcall BalansPS_XL(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage);
        void __fastcall NoBillToXL(TDateTime mmgg);
        void  ReconnectDemandXL(TDateTime mmgg );
        void  ShowDemandXL(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage,int showpoints);
        void  ShowLostsXL(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage, int showpoints);
        void __fastcall BalansMidPoint_XL(int id_eqp,TDateTime mmgg,AnsiString name_eqp);
        void __fastcall FizAbonInfo(TDateTime mmgg);
        void __fastcall StationReconnectInfo(int id_eqp,TDateTime mmgg);
        void __fastcall ConnectedToRoot(TDateTime mmgg);
        void __fastcall FidersToXL_key(int selected,TDateTime mmgg);
        void __fastcall Losts04(TDateTime mmgg);
        void __fastcall LostSummary(TDateTime mmgg);

     //   TZPgSqlQuery *ZQBal;
};
//---------------------------------------------------------------------------
extern PACKAGE TfBalansRep *BalansReports;
//---------------------------------------------------------------------------
#endif
