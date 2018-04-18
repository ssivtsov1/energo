//---------------------------------------------------------------------------

#ifndef CliPowerIndicH
#define CliPowerIndicH
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
#include "fEqpBase.h"
#include "fChange.h"
#include "AreaList.h"


class TfPowerInd : public TWTDoc
{
__published:	// IDE-managed Components
//  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:


public:
         _fastcall virtual TfPowerInd(TWinControl* Owner, TWTQuery *query,int fid_cl);
         void __fastcall BtnMeterClick(TWTField *Sender);
         void __fastcall NewHeaderInsert(TDataSet* DataSet);
         void __fastcall NewIndicInsert(TDataSet* DataSet);
         void _fastcall IndicPost(TWTDBGrid *Sender);
         void __fastcall tTreeEditDblClick(TObject *Sender);
         void _fastcall  OnChangeIndic(TWTField *Sender);
         void __fastcall ClientCalcPower(TObject *Sender);
//        void _fastcall IndicAddNew(TWTDBGrid *Sender);
//        void _fastcall IndicAddCl(TWTDBGrid *Sender);
//        void _fastcall CheckIndic(TWTDBGrid *Sender);
//        void __fastcall ClientCalcPotr(TObject *Sender);
//        void _fastcall  ClientKontrPotr(TObject *Sender);
          void _fastcall   ClientBillPrintP(TObject *Sender);
          void _fastcall   ClientAktPrintP(TObject *Sender);
//        void _fastcall  OnChangeIndic(TWTField *Sender);
        //void _fastcall  OnChangeKindRep(TWTField *Sender);
        //void _fastcall  OnChangeDateRep(TWTField *Sender);
        //void _fastcall  ClientDemandPrintP(TObject *Sender);
//        void _fastcall   ClientBillPrintT(TObject *Sender);
//        void _fastcall Losts(int  id_bill);
//        void _fastcall   Lost(TObject *Sender);
//        void _fastcall BtnDemF(TObject *Sender);
//        void _fastcall BtnDemLF(TObject *Sender);
//        void __fastcall IndicAccept(TObject *Sender);
       _fastcall ~TfPowerInd();
       void __fastcall PrintAct(int id_client, int id_head, int id_doc, int id_area, TDateTime mmgg_bill);

       int fid_cl;
       int fid_eqp;
       AnsiString name_cl;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;

       TWTQuery *QueryWork;

       int pid_client;
       //TWTQuery * QuerH;
       TWTQuery * QueryH;
       TWTDBGrid* DBGrHInd;
       //TWTQuery * QuerI;
       TWTQuery * QueryI;
       TWTDBGrid* DBGrInd;
       bool def_mode;
       bool ReadOnly;
       TfTreeForm* fSelectTree;  //Окно дерева для выбора элемента дерева-предка

       // Запрсы для печати акта
       TWTQuery* ZQuery;
       TWTQuery* ZQuery2;
       TWTQuery* ZQueryIndic;
       TWTQuery* ZQuerySum;       
};
//-----------------------------
// #endif

#endif