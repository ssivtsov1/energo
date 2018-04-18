//---------------------------------------------------------------------------

#ifndef BankPScrH
#define BankPScrH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZConnect.hpp"
#include "ZPgSqlCon.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZPgSqlTr.hpp"
#include "ZQuery.hpp"
#include "ZTransact.hpp"
#include <Db.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Mask.hpp>
#include "Main.h"
#include <ComCtrls.hpp>
#include <ImgList.hpp>
#include <ToolWin.hpp>
#include <DBTables.hpp>
#include <DBGrids.hpp>
#include <WinGrid.h>
#include "TWTCompatable.h"
#include "ParamsForm.h"
#include "Query.h"
#include <Grids.hpp>
class TFBankPScribe : public TWTDoc
{
__published:
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:
public:
 void _fastcall AciHeadPayBtn(TObject *Sender);
 _fastcall virtual TFBankPScribe(TWinControl* Owner,int pid_head);
  _fastcall ~TFBankPScribe();
void _fastcall  OnChDate(TWTField  *Sender);
void _fastcall  OnChMFOself(TWTField  *Sender);
void _fastcall BeforeInsertHead(TWTDBGrid *Sender);
void _fastcall BeforePostHead(TWTDBGrid *Sender);
void _fastcall BeforeInsertPay(TWTDBGrid *Sender);
 void _fastcall Calculate(TObject *Sender);
 void _fastcall Migration(TObject *Sender);

 void __fastcall OnChangePay(TWTField *Sender);
  void __fastcall ChMMGG(TWTField *Sender);
 void __fastcall OnChangeTax(TWTField *Sender);
  void _fastcall ExitParamsGrid(TObject *Sender);
bool __fastcall CheckSum(float s1,float s2);
void _fastcall PostPay(TWTDBGrid *Sender);
void __fastcall PayDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
 void __fastcall EnterPay(TObject *Sender);
 void _fastcall AfterPostPay(TWTDBGrid *Sender);
 void _fastcall  Chnom(TWTField  *Sender);
int MAIN_RES;
TWTDBGrid* DBGrHPay;
TWTQuery * QuerHPay;
TWTDBGrid* DBGrHSPay;
TWTQuery * QuerHSPay;

 TWTQuery *QuerPay;
 TWTDBGrid* DBGrPay;
 float nds;
 int nom;
 int fid_head;
 TDateTime dat;
  TDateTime dat_mmggpay;
  TDateTime dat_mmgg;
  };
extern PACKAGE TFBankPScribe *FBankPScribe;

// ----------------------------------
#endif


