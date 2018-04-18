//---------------------------------------------------------------------------

#ifndef fBankPrintH
#define fBankPrintH
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
class TfPrintBank : public TForm
{
__published:	// IDE-managed Components
        TQuickRep *PrintPay;
        TQRBand *TitleBand1;
        TQRLabel *QRLabel1;
        TQRLabel *lBillNo;
        TQRLabel *lResName;
        TQRBand *DetailBand1;
        TQRCompositeReport *PrintBill;
        TZPgSqlQuery *ZQHead;
        TZPgSqlQuery *ZQPay;
        TDataSource *dsDemand;
        TQRLabel *lResAddr;
        TQRLabel *lData;
        TQRLabel *QRLabel3;
        TQRDBText *DBTNum;
        TQRDBText *pay;
        TQRDBText *val;
        TQRDBText *tax;
        TQRDBText *nam_eqp;
        TQRDBText *QRDBText9;
        TQRDBText *QRDBText10;
        TQRShape *QRShape2;
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
        TQRShape *QRShape3;
        TQRLabel *QRLabel23;
        TQRShape *QRShape9;
        TQRLabel *QRLabel6;
        TQRLabel *QRLabel9;
        TQRLabel *QRLabel4;
        TQRLabel *lAccount;
        TQRLabel *lBank;
        TQRLabel *QRLabel17;
        TQRLabel *lMFO;
        TQRGroup *QRGroup1;
        TQRBand *QRBand44;
        TQRLabel *QRLabel10;
        TQRLabel *lTax;
        TQRLabel *lVal;
        TQRLabel *lPay;
        TQRExpr *QRExpr1;
        TQRDBText *QRDBText1;
        TQRBand *QRBand1;
        TQRLabel *QRLabel5;

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
        void __fastcall PrintPayBeforePrint(TCustomQuickRep *Sender,
          bool &PrintReport);
        void __fastcall QRGroup1BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall DetailBand1BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRBand44BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
private:	// User declarations
public:		// User declarations
        __fastcall TfPrintBank(TComponent* Owner);
        void __fastcall ShowBill(int id_doc);
        int id_bill;
        int id_client;
        int ssign;
         float all_val1;
        float all_tax1;
        float  all_pay1;
        int QRLabel43_Left;
        int QRDBText14_Left;
        int QRLabel11_Left;
        int QRDBText15_Left;
        int QRDBText10_Left;
        int QRLabel32_Left;
        int QRDBText13_Left;

};
//---------------------------------------------------------------------------
extern PACKAGE TfPrintBank *fPrintBank;
//---------------------------------------------------------------------------
#endif
