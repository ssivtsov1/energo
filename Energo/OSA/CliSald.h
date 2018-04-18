//---------------------------------------------------------------------------

#ifndef CliSaldH
#define CliSaldH
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


class TfCliSald : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:


public:
          _fastcall virtual TfCliSald(TWinControl* Owner, TWTQuery *query,int fid_cl);

           _fastcall ~TfCliSald();
           void __fastcall ClientSalDoc(TObject *Sender);
       int fid_client;
       AnsiString name_cl;
       
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;


       TWTQuery * QuerSald;
       TWTDBGrid* DBGrSald;
       bool ReadOnly;
};
//---------------------------



class TfSaldAkt : public TWTDoc
{
__published:	// IDE-managed Components
  //void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:


public:
       _fastcall virtual TfSaldAkt(TWinControl* Owner);
   
        _fastcall ~TfSaldAkt();
             
       TWTQuery * QuerH;
       TWTDBGrid* DBGrH;
       TWTQuery * QuerSal;
       TWTDBGrid* DBGrSald;
       float nds;
       bool def_mode;
       bool ReadOnly;
        void __fastcall DrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
        void __fastcall OnChangeVal(TWTField *Sender);
       void  __fastcall OnChangeValTax(TWTField *Sender);
        void __fastcall OnChangeMG(TWTField *Sender);
         void __fastcall Calc_Saldoakt(TObject *Sender);
};



class TfCliCDocs : public TWTDoc
{
__published:	// IDE-managed Components
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:


public:
          _fastcall virtual TfCliCDocs(TWinControl* Owner, TWTQuery *query,int fid_cl);

           _fastcall ~TfCliCDocs();
          // void __fastcall ClientSalDoc(TObject *Sender);
       int fid_client;
       AnsiString name_cl;
       
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;


       TWTQuery * QuerSald;
       TWTDBGrid* DBGrSald;
       bool ReadOnly;
       void _fastcall AddCl(TWTDBGrid *Sender);
};

#endif

