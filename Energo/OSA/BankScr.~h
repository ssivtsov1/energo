//---------------------------------------------------------------------------

#ifndef BankScrH
#define BankScrH
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
#include <ADODB.hpp>
#include <Db.hpp>



#include <ToolWin.hpp>
#include <DBGrids.hpp>
#include <WinGrid.h>
#include "TWTCompatable.h"
#include "ParamsForm.h"
#include "Query.h"
#include <Grids.hpp>
//---------------------------------------------------------------------------
class TFBankScr : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TPageControl *PageControl1;
        TTabSheet *TabSheet2;
        TPanel *Panel2;
        TGroupBox *GroupBox1;
        TLabel *Label2;
        TLabel *LabNClient;
        TLabel *Label4;
        TLabel *LabNBank;
        TSpeedButton *SBtnBank;
        TLabel *Label6;
        TSpeedButton *SBtnAccount;
        TMaskEdit *EdCodeClient;
        TMaskEdit *EdBank;
        TMaskEdit *EdAccount;
        TTabSheet *TabSheet1;
        TTabSheet *TabSheet3;
        TEdit *EdRegNum;
        TLabel *Label1;
        TMaskEdit *EdRegDate;
        TLabel *Label7;
        TRadioGroup *RadGrPay;
        TLabel *Label8;
        TMaskEdit *EdPayDate;
        TMaskEdit *EdValuePay;
        TMaskEdit *EdValueTax;
        TLabel *Label9;
        TLabel *Label10;
        TComboBox *CBoxPay;
        TLabel *Label12;
        TLabel *Label13;
        TMaskEdit *EdValue;
        TLabel *Label3;
        TSpeedButton *SBtnClient;
        TLabel *Label5;
        TEdit *EdComment;
        TMaskEdit *EdBillPay;
        TImageList *ImageClientBtn;
        TTabControl *TabControl1;
        TCoolBar *TCBarClient;
        TToolBar *ToolBar1;
        TToolButton *ToolButton3;
        TToolButton *TBtnFirst;
        TToolButton *TBtnPrev;
        TToolButton *TBtnNext;
        TToolButton *TBtnLast;
        TToolButton *ToolButton8;
        TToolButton *TBtnCansel;
        TToolButton *TBtnSave;
        TToolButton *TBtnRefresh;
        TToolButton *TBtnFind;
        TToolButton *TButtonNew;
        TToolButton *TButtonDel;
        TQuery *QuerBil;

         TBitBtn *BtnSav;
        TSpeedButton *SpeedButton1;
        TDBGrid *DBGrBill;
        TLabel *Label11;
        TLabel *Label14;
        TLabel *LabRest;
        TLabel *LabRestTax;
        TLabel *LabEdrpou;
        TLabel *Label16;
        TLabel *Label15;
        TComboBox *CBoxType;

        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall EdFloatKeyPress(TObject *Sender, char &Key);
        void __fastcall EdIntKeyPress(TObject *Sender, char &Key);
        void __fastcall EdCodeClientChange(TObject *Sender);

        void __fastcall EdValuePayExit(TObject *Sender);

        void __fastcall EdValueTaxExit(TObject *Sender);
        bool __fastcall BtnOkClick(TObject *Sender);
        void __fastcall SBtnClientClick(TObject *Sender);
        void __fastcall SBtnBankClick(TObject *Sender);
        void __fastcall AbonAcceptAcc (TObject* Sender);
        void __fastcall EdBillPayExit(TObject *Sender);
        void __fastcall RadGrPayExit(TObject *Sender);
        void __fastcall BtnSavClick(TObject *Sender);
        void __fastcall EdValuePayChange(TObject *Sender);
        void __fastcall ShowBill1(TObject *Sender);
        bool __fastcall CheckSum(float s1,float s2);
        //void __fastcall FormShow(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFBankScr(TComponent* Owner);
        void __fastcall ShowFBank(int id_hpay,int id_pay);
         void __fastcall ShowFBankPay(int id_hpay,int id_pay);
        void __fastcall AbonAccept (TObject* Sender);

        //void __fastcall SBtnClientClick(TObject *Sender);
        TDataSet *SetHeadPay;
        TDataSet *SetPay;
        TWTQuery *QuerHead;
        TWTQuery* QuerHeadPay;
        TWTQuery* QuerPay;
        TWTQuery *QuerBill;
         TWTQuery *QuerRest;
        int fid_headpay;
        int fid_pay;
        int fid_pref;
        int fid_sign;
        int fid_client;
        int fid_tdoc;

        AnsiString fid_account;
        AnsiString  fid_mfobank;
};
//---------------------------------------------------------------------------
extern PACKAGE TFBankScr *FBankScr;




//---------------------------------------------------------------------------
class TFBankCheck : public TWTDoc
{
 __published:
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
 protected:
 public:
  void _fastcall AciHeadPayBtn(TObject *Sender);
  _fastcall virtual TFBankCheck(TWinControl* Owner);
  _fastcall ~TFBankCheck();
  TWTDBGrid* DBGrHPay;
  TWTQuery * QuerHPay;
};
extern PACKAGE TFBankCheck *FBankCheck;


//---------------------------------------------------------------------------
class TFBankLoad : public TWTDoc
{
 __published:
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
 protected:
 public:
 int pnum_file;
 TWTPanel* PBar;
//  void _fastcall AciHeadPayBtn(TObject *Sender);
  _fastcall virtual TFBankLoad(TWinControl* Owner,int pid_doc);
  _fastcall ~TFBankLoad();
  TWTDBGrid* DBGrHPay;
  TWTQuery * QuerHPay;
  void __fastcall BankLoad(TObject *Sender);
    void __fastcall BankLoadScr(TObject *Sender);
  void __fastcall  LoadFromFile(int num_file);
 
};
extern PACKAGE TFBankLoad *FBankLoad;

// --------------
class TFBankScribe : public TWTDoc
{
__published:
  void __fastcall  FormClose(TObject *Sender,      TCloseAction &Action);
protected:
public:
 void _fastcall AciHeadPayBtn(TObject *Sender);
 _fastcall virtual TFBankScribe(TWinControl* Owner);
  _fastcall ~TFBankScribe();
void _fastcall  BankPrintP(TObject *Sender);
void _fastcall ChClientAccount(TWTField* Sender);
void _fastcall  OnChangeAccount(TWTField  *Sender);
void _fastcall  OnChDate(TWTField  *Sender);
void _fastcall  OnChMFOself(TWTField  *Sender);
void _fastcall  OnChAccountSelf(TWTField  *Sender);
void _fastcall BeforePostHead(TWTDBGrid *Sender);
void __fastcall ClientPayIns(TObject *Sender);
void __fastcall PayAccept(TObject *Sender);
void __fastcall OnChangePay(TWTField *Sender);
void __fastcall OnChangeTax(TWTField *Sender);
void __fastcall BankCheck(TObject *Sender);
void __fastcall BankLoad(TObject *Sender);
void __fastcall InsPayFiz(TObject *Sender);
bool __fastcall CheckSum(float s1,float s2);
void _fastcall PostPay(TWTDBGrid *Sender);
void __fastcall PayDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
void __fastcall ShowPrivatePay(TObject *Sender);
int MAIN_RES;
TWTDBGrid* DBGrHPay;
TWTQuery * QuerHPay;
 TWTQuery *QuerPay;
 TWTDBGrid* DBGrPay;
 float nds;
};
extern PACKAGE TFBankScribe *FBankScribe;

// ----------------------------------
#endif


