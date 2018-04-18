//---------------------------------------------------------------------------

#ifndef InspectH
#define InspectH
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


class TfInspect : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:

public:
             _fastcall virtual TfInspect(TWinControl* Owner);

        void _fastcall IndicAddNew(TWTDBGrid *Sender);

        void _fastcall CheckIndic(TWTDBGrid *Sender);
     //   void __fastcall ClientCalcPotr(TObject *Sender);

        void _fastcall  ClientBillPrintP(TObject *Sender);
        void _fastcall  OnChangeIndic(TWTField *Sender);
        void _fastcall   ClientBillPrintT(TObject *Sender);
              void _fastcall ClientPowerIndic(TObject *Sender);

        void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
        void __fastcall HIndDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
        void __fastcall PeriodSel(TObject *Sender);
        void _fastcall  OnChangeFider(TWTField *Sender);
        void __fastcall DataSetBeforeUpdate(TDataSet *DataSet);
        void __fastcall DataSetBeforeInsert(TDataSet *DataSet);

        _fastcall ~TfInspect();
       int fid_cl;
       int fid_eqp;
       AnsiString name_cl;
       TWTQuery* ZQUpdate;
       TWTQuery *QuerFid;
       TWTDBGrid * WAddrGrid;
       int pid_client;
       TWTQuery * QuerH;
       TWTDBGrid* DBGrHInd;
       TWTQuery * QuerI;
       TWTDBGrid* DBGrInd;
       bool def_mode;
       bool ReadOnly;
       int old_fider;
       TDateTime mmgg;
};
//-----------------------------
#endif
