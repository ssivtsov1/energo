//---------------------------------------------------------------------------

#ifndef CliDemH
#define CliDemH
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


class TfCliDem : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:


public:
      // __fastcall TfCliDem(TWinControl *owner, TWTQuery *query,int fid_cl);
        //        void __fastcall FormClose(TObject *Sender, bool &CanClose);
              // TComponent* Owner
        //__fastcall TfCliDem(TComponent* Owner, TWTQuery *query,int fid_cl);
          _fastcall virtual TfCliDem(TWinControl* Owner, TWTQuery *query,int fid_cl);

        void _fastcall IndicAddNew(TWTDBGrid *Sender);
        void _fastcall IndicAddCl(TWTDBGrid *Sender);
        void _fastcall CheckIndic(TWTDBGrid *Sender);
        void __fastcall ClientCalcPotr(TObject *Sender);
        void _fastcall  ClientKontrPotr(TObject *Sender);
        void _fastcall  ClientKontr(TObject *Sender);
        void _fastcall  ClientBillPrintP(TObject *Sender);
        void _fastcall  OnChangeIndic(TWTField *Sender);
        //void _fastcall  OnChangeKindRep(TWTField *Sender);
        //void _fastcall  OnChangeDateRep(TWTField *Sender);
        void _fastcall  ClientDemandPrintP(TObject *Sender);
        void _fastcall   ClientBillPrintT(TObject *Sender);
        void _fastcall Losts(int  id_bill);
        void _fastcall   Lost(TObject *Sender);
        void _fastcall BtnDemF(TObject *Sender);
        void _fastcall BtnDemLF(TObject *Sender);
        void _fastcall ClientPowerIndic(TObject *Sender);
        void __fastcall BefEdit(TWTDBGrid *Sender);
        void _fastcall BtnTrueCabinet(TObject *Sender);
        void _fastcall BtnReadCabinet(TObject *Sender);
        void __fastcall IndicAccept(TObject *Sender);
        void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
        void __fastcall HIndDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);

   //     void _fastcall CheckIndicStr(TWTDBGrid *Sender);
        void __fastcall PeriodSel(TObject *Sender);
        void __fastcall DelIndic(TObject* Sender);        
        _fastcall ~TfCliDem();
       int fid_cl;
       int fid_eqp;
       AnsiString name_cl;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;


       int pid_client;
       TWTQuery * QuerH;
       TWTDBGrid* DBGrHInd;
       TWTQuery * QuerI;
       TWTDBGrid* DBGrInd;
       TWTQuery * QuerSum;
       TDateTime mmgg;
       TDateTime mmgg_limit;
       int month_cnt ;
       bool def_mode;
       bool boss_mode; //разрешать вводить показания меньше, чем последние контрольные
       bool ReadOnly;
       bool mem_mode;
       bool user_changed;
};
//-----------------------------

class TfCliAddDem : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:


public:
      // __fastcall TfCliDem(TWinControl *owner, TWTQuery *query,int fid_cl);
        //        void __fastcall FormClose(TObject *Sender, bool &CanClose);
              // TComponent* Owner
        //__fastcall TfCliDem(TComponent* Owner, TWTQuery *query,int fid_cl);
          _fastcall virtual TfCliAddDem(TWinControl* Owner, TWTQuery *query,int fid_cl);


        void _fastcall IndicAddCl(TWTDBGrid *Sender);
        void __fastcall ClientCalcPotr(TObject *Sender);

        void _fastcall  ClientBillPrintP(TObject *Sender);
          void _fastcall IndicAddNew(TWTDBGrid *Sender);
        void _fastcall   ClientBillPrintT(TObject *Sender);
        void __fastcall BtnPointClick(TWTField *Sender);
        void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
        void __fastcall tTreeEditDblClick(TObject *Sender);
        void _fastcall  OnChange(TWTField *Sender);
        _fastcall ~TfCliAddDem();
        int fid_cl;
        int fid_eqp;
       AnsiString name_cl;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;


       int pid_client;
       TWTQuery * QuerH;
        TWTQuery * QuerSum;
       TWTDBGrid* DBGrHInd;
       TWTQuery * QuerI;
       TWTDBGrid* DBGrInd;
       bool def_mode;
       bool ReadOnly;
       TfTreeForm* fSelectTree;  //Окно дерева для выбора элемента дерева-предка

};
//-----------------------------

class TfCliLinkDem : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:
public:
        _fastcall virtual TfCliLinkDem(TWinControl* Owner,  int fid_headmain,int fid_clientmain);

        void __fastcall Reform(TObject *Sender);
       void _fastcall  OnChangeIndic(TWTField *Sender);
        void _fastcall  ClientDemandPrintP(TObject *Sender);
        void __fastcall IndicAccept(TObject *Sender);
                void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
        _fastcall ~TfCliLinkDem();
       int fid_main;
       AnsiString name_cl;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;
       int pid_client;
       TWTQuery * QuerH;
       TWTDBGrid* DBGrHInd;
       TWTQuery * QuerI;
       TWTDBGrid* DBGrInd;
};

class TfLost : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:
public:
        _fastcall virtual TfLost(TWinControl* Owner,  int fid_headmain,int fid_clientmain);
        _fastcall ~TfLost();
       int fid_main;
       AnsiString name_cl;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;
       int pid_client;
       TWTQuery * QuerLost1;
       TWTDBGrid* DBGrLost1;
       TWTQuery * QuerL2;
       TWTDBGrid* DBGrLost2;
};

#endif