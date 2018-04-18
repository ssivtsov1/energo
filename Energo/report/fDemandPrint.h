//---------------------------------------------------------------------------

#ifndef fDemandPrintH
#define fDemandPrintH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
#include <ExtCtrls.hpp>
#include <Qrctrls.hpp>
#include <QuickRpt.hpp>
#include <QRCtrls.hpp>
//---------------------------------------------------------------------------
class TfPrintDemand : public TForm
{
__published:	// IDE-managed Components
        TQuickRep *PrintBill_p1;
        TQRBand *TitleBand1;
        TQRLabel *QRLabel1;
        TQRLabel *QRLabel5;
        TQRLabel *lBillNo;
        TQRLabel *lContractNo;
        TQRLabel *lContractDate;
        TQRLabel *lResName;
        TQRLabel *lAbonName;
        TQRLabel *lAbonAddr;
        TQRBand *DetailBand1;
        TQRCompositeReport *PrintBill;
        TZPgSqlQuery *ZQBill;
        TZPgSqlQuery *ZQBillMeter;
        TDataSource *dsDemand;
        TQRLabel *lResAddr;
        TQRDBText *DBTNum;
        TQRDBText *DBTKtrDemand;
        TQRDBText *DBTVal_b;
        TQRDBText *DBTVal_e;
        TQRDBText *DBTZone;
        TQRDBText *DBTKtr;
        TQRDBText *nam_eqp;
        TQRDBText *QRDBText9;
        TQRDBText *QRDBText10;
        TQRShape *QRShape2;
        TQRLabel *QRLabel15;
        TQRLabel *QRLabel12;
        TQRShape *QRShape11;
        TQRLabel *QRLabel8;
        TQRShape *QRShape10;
        TQRLabel *QRLabel7;
        TQRShape *QRShape1;
        TQRLabel *QRLabel13;
        TQRShape *QRShape8;
        TQRLabel *QRLabel2;
        TQRShape *QRShape7;
        TQRLabel *QRLabel31;
        TQRLabel *QRLabel16;
        TQRShape *QRShape4;
        TQRLabel *QRLabel14;
        TQRShape *QRShape3;
        TQRLabel *QRLabel23;
        TQRShape *QRShape5;
        TQRShape *QRShape9;
        TQRLabel *QRLabel6;
        TQRBand *QRBand3;
        TQRDBText *DBTDate;
        TQRShape *QRShape6;
        TQRShape *QRShape12;
        TQRShape *QRShape15;
        TQRShape *QRShape16;
        TQRShape *QRShape17;
        TQRShape *QRShape18;
        TQRShape *QRShape13;
        TQRShape *QRShape19;
        TQRShape *QRShape20;
        TQRLabel *QRLabel9;
        TQRLabel *QRLab3;
        TQRLabel *QRLabDate;
        TQRLabel *QRLabInsp;
        TQRLabel *QRLabPers;
        TQRLabel *LInspect;
        TQRLabel *QRLabel4;
        void __fastcall PrintBillAddReports(TObject *Sender);
        void __fastcall ChildBand_AbonBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall GroupMeterBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRSDMeterBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRSDPointBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRBand2BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall PrintBill_p1BeforePrint(TCustomQuickRep *Sender,
          bool &PrintReport);
private:	// User declarations
public:		// User declarations
        __fastcall TfPrintDemand(TComponent* Owner);
        void __fastcall ShowBill(int id_doc);
        int id_bill;
        int id_client;

        int QRLabel43_Left;
        int QRDBText14_Left;
        int QRLabel11_Left;
        int QRDBText15_Left;
        int QRDBText10_Left;
        int QRLabel32_Left;
        int QRDBText13_Left;

};
//---------------------------------------------------------------------------
extern PACKAGE TfPrintDemand *fPrintDemand;
//---------------------------------------------------------------------------
#endif
