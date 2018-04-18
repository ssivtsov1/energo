//---------------------------------------------------------------------------

#ifndef ClientBillH
#define ClientBillH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include "TWTCompatable.h"
#include "ParamsForm.h"
#include "Query.h"
#include <Grids.hpp>
class TfCliSaldDoc : public TWTDoc
{
__published:	// IDE-managed Components
         void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        
protected:


public:

       __fastcall TfCliSaldDoc(TWinControl *owner, int fid_cl,TWTDBGrid * GrRef);
        __fastcall ~TfCliSaldDoc();
        void _fastcall  OnChange(TWTField *Sender);
        void _fastcall  OnChangeP(TWTField *Sender);
        void _fastcall InsPay(TWTDBGrid *Sender);
        void _fastcall InsBill(TWTDBGrid *Sender);
        void _fastcall  OnChangeHPay(TWTField *Sender);

       int fid_client;
       int fid_headpay;
       int fid_saldo;
       TWTDBGrid * GrRef;

};

class TfCliBill : public TWTDoc
{
__published:	// IDE-managed Components

        void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:

public:

       __fastcall TfCliBill(TWinControl* Owner, TWTQuery *query,int fid_cl);
        __fastcall ~TfCliBill();
        void __fastcall CalcExpr(TDataSet* Sender);
        void _fastcall ChangePayAccount(TWTField* Sender);
        void __fastcall ClientBillPrint(TObject *Sender);
        void __fastcall ClientBillTax(TObject *Sender);
        void __fastcall ClientBillPred(TObject *Sender);
        void __fastcall ClientClc(TObject *Sender);
        void __fastcall ClientBill2kr(TObject *Sender);
        void __fastcall ClientBillInfl(TObject *Sender);
        void __fastcall ClientBillPen(TObject *Sender);
        void _fastcall  ClientKontrPotr(TObject *Sender);
        void __fastcall ClientBillDet(TObject *Sender);
        void __fastcall ClientPret(TObject *Sender);
         void _fastcall ClientDelBill(TObject *Sender);
        void __fastcall BillDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
        void __fastcall PayDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);

        void __fastcall DelBill(TObject* Sender);
      float nds;
      int fid_client;
      TWTDBGrid* DBGrBill;
      TWTQuery * QuerBill;
      TWTQuery * QuerPay;

      TNotifyEvent OldDelBill; // Системная процедура удаления строки

};

class TfCliBillDetal : public TWTDoc
{
__published:	// IDE-managed Components
         void __fastcall FormClose(TObject *Sender, TCloseAction &Action);

protected:


public:

       __fastcall TfCliBillDetal(TWinControl *owner, int id_doc);
        __fastcall ~TfCliBillDetal();

       int fid_doc;

};



class TfCliBillDel : public TWTDoc
{
__published:	// IDE-managed Components
         void __fastcall FormClose(TObject *Sender, TCloseAction &Action);

protected:


public:

       __fastcall TfCliBillDel(TWinControl *owner, int id_client);
        __fastcall ~TfCliBillDel();

       int fid_client;

};

//-----------------------------
#endif