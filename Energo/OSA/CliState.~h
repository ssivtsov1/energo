//---------------------------------------------------------------------------

#ifndef CliStateH
#define CliStateH
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
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <Menus.hpp>

//---------------------------------------------------------------------------
class TFCliState : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPageControl *PContrlPay;
        TTabSheet *TShGeneral;
        TLabel *Label19;
        TTabSheet *TShPay;
        TTabControl *TContrGeneral;
        TGroupBox *GroupBox2;
        TLabel *Label16;
        TLabel *Label17;
        TLabel *Label1;
        TLabel *Label7;
        TLabel *Label20;
        TLabel *Label9;
        TEdit *EdNumDoc;
        
        TMaskEdit *EdDateDoc;
        TCheckBox *ChBoxTaxPay;
        TComboBox *EdPerIndic;
        TMaskEdit *EdDtIndicat;
        TMaskEdit *EdMonthIndicat;
        TMaskEdit *EdPayDay;
        TLabel *Label13;
        TMaskEdit *EdCodeClient;
        TSpeedButton *SBtnClient;
        TLabel *Label11;
        TEdit *EdAddres;
        TSpeedButton *BtnAdr;
        TLabel *Label15;
        TMaskEdit *EdOKPO;
        TLabel *Label14;
        TMaskEdit *EdLicNum;
        TLabel *Label4;
        TMaskEdit *EdTaxNum;
        TGroupBox *GroupBox1;
        TLabel *Lab;
        TEdit *EdPrePayDay1;
        TLabel *Label2;
        TEdit *EdPrePayDay2;
        TLabel *Label23;
        TEdit *EdPrePayDay3;
        TLabel *Label22;
        TEdit *EdPrePayGrn;
        TEdit *EdPrePayPerc1;
        TLabel *Label21;
        TLabel *Label24;
        TEdit *EdPrePayPerc2;
        TLabel *Label25;
        TEdit *EdPrePayPerc3;
        TTabSheet *TShFin;
        TLabel *LabPClient;
        TLabel *LabIdClient;
        TImageList *ImageClientBtn;
        TCoolBar *TCBarClient;
        TToolBar *ToolBar1;
        TToolButton *TBtnNew;
        TToolButton *TBtnDel;
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
        TPanel *Panel3;
        TToolButton *TButtonCard;
        TGroupBox *GroupBox3;
        TSpeedButton *BtnKwed;
        TLabel *Label6;
        TLabel *Label8;
        TSpeedButton *BtnGrp;
        TLabel *Label10;
        TSpeedButton *BtnBudjet;
        TEdit *EdGrp;
        TEdit *EdBudjet;
        TGroupBox *GroupBox4;
        TDBGrid *DBGrSald;
        TCheckBox *ChBoxBudjet;
        TEdit *EdNName;
        TEdit *EdLName;
        TLabel *Label27;
        TEdit *EdComment;
        TLabel *LabKwed;
        TMaskEdit *EdKwed;
        TLabel *Label3;
        TEdit *EdPosition;
        TSpeedButton *BtnPosition;
        TLabel *Label5;
        TEdit *EdPhone;
        TLabel *Label12;
        TEdit *EdDocGround;
        TLabel *Label26;
        TMaskEdit *EdDtStart;
        TLabel *Label28;
        TGroupBox *GroupBox5;
        TDBGrid *DBGrDayPay;
        TSpeedButton *sbAddDayPay;
        TSpeedButton *sbDelDayPay;
        TLabel *Label30;
        TEdit *EdFld;
        TLabel *Label31;
        TEdit *EdDep;
        TSpeedButton *BtnDep;
        TLabel *Label32;
        TEdit *EdRoz;
        TSpeedButton *BtnRoz;
        TCheckBox *ChLost;
        TPanel *Panel1;
        TEdit *EdAddresM;
        TLabel *Label29;
        TLabel *Label33;
        TEdit *EdAddresT;
        TTabSheet *TShBill;
        TGroupBox *GroupBill;
        TDBGrid *DBGrBill;
        TCheckBox *ChBoxReactiv;
        TCheckBox *ChBoxKey;
        TCheckBox *Ch2krDel;        
        TSpeedButton *SBRent;
        TLabel *Label35;
        TEdit *EdKontrol;
        TSpeedButton *BtnKontrol;
        TPopupMenu *SalMenu;
        TMenuItem *N1;
        TMenuItem *N2;
        TMenuItem *N21;
        TMenuItem *N22;
        TMenuItem *N3;
        TMenuItem *N4;
        TMenuItem *N5;
        TSpeedButton *SBtnProt;
        TSpeedButton *SBHistory;
        TLabel *Label36;
        TEdit *EdAddresLocal;
        TSpeedButton *sbInspectorHistory;
        TCheckBox *ChBankDay;
        TMaskEdit *EdMonthControl;
        TLabel *Label37;
        TTabSheet *TShTransit;
        TGroupBox *GroupBox6;
        TLabel *Label38;
        TEdit *edTrDocNum;
        TLabel *Label39;
        TMaskEdit *edTrDocDate;
        TLabel *Label40;
        TEdit *edTrYearPrice;
        TLabel *Label41;
        TComboBox *cbTrDocType;
        TSpeedButton *sbTrDocClear;
        TLabel *Label34;
        TEdit *EdNumDocTend;
        TLabel *Label42;
        TMaskEdit *EdDatDocTend;
        TRadioGroup *RadGrPay;
        TRadioGroup *RadGrJur;
        TCheckBox *ChBoxEd;
        TMaskEdit *EdCountPeni;
        TLabel *Label18;
        TCheckBox *ChBoxPeni;
        TLabel *Label43;
        TEdit *EdAddName;
        TLabel *Label44;
        TEdit *EdMail;
        TButton *btSendEMail;
        TButton *btMailSetup;
        TComboBox *cbTrPayPeriod;
        TLabel *Label45;
        TDBGrid *DBGrid1;
        TCheckBox *ChBoxCabinet;
        TLabel *Label46;
        TMaskEdit *EdDateDigital;
        TSpeedButton *sbDigitalClear;
        TLabel *Label47;
        TMaskEdit *EdDtClose;
        TEdit *EdState;
        TLabel *Label48;
        TSpeedButton *SpeedButton1;
        TMaskEdit *edKoshtDateB;
        TMaskEdit *edKoshtDateE;
        TLabel *Label49;
        TLabel *Label50;
        TCheckBox *ChBox3PercYear;
       // TSpeedButton *sbAddDayPay;
      //  TSpeedButton *sbDelDayPay;
       // TDBGrid *DBGrDayPay;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall EdFloatKeyPress(TObject *Sender, char &Key);
        void __fastcall EdIntKeyPress(TObject *Sender, char &Key);
        void __fastcall EdCodeClientChange(TObject *Sender);
       // void __fastcall BtnOkClick(TObject *Sender);
        void __fastcall SBtnClientClick(TObject *Sender);
        void __fastcall SBtnBankClick(TObject *Sender);
        void __fastcall BtnAdrClick(TObject *Sender);
        void __fastcall MainAddrAccept (TObject* Sender);
        //  void __fastcall BtnAdrClickM(TObject *Sender);
       // void __fastcall MainAddrAcceptM (TObject* Sender);
        void __fastcall ChBoxTaxPayClick(TObject *Sender);
        void __fastcall ChBoxReactivClick(TObject *Sender);
        void __fastcall RadGrPayExit(TObject *Sender);
        void __fastcall ChBoxPeniClick(TObject *Sender);
        void __fastcall BtnKwedClick(TObject *Sender);
        void __fastcall KwedAccept (TObject* Sender);
        void __fastcall EdKwedChange(TObject *Sender);

        void __fastcall BtnBudjetClick(TObject *Sender);
        void __fastcall BudAccept (TObject* Sender);
        void __fastcall BtnGrpClick(TObject *Sender);
        void __fastcall GrpAccept (TObject* Sender);
        void __fastcall BtnFldClick(TObject *Sender);
        void __fastcall FldAccept (TObject* Sender);
        void __fastcall BtnRozClick(TObject *Sender);
        void __fastcall RozAccept (TObject* Sender);
        void __fastcall BtnDepClick(TObject *Sender);
        void __fastcall DepAccept (TObject* Sender);

        void __fastcall TBtnSaveClick(TObject *Sender);
        void __fastcall ChBoxBudjetClick(TObject *Sender);
        void __fastcall EdPerIndicChange(TObject *Sender);

        void __fastcall BtnPosClick(TObject *Sender);
        void __fastcall PosAccept (TObject* Sender);

        void __fastcall BtnKontClick(TObject *Sender);
        void __fastcall KontAccept (TObject* Sender);


        void __fastcall TBtnPrevClick(TObject *Sender);
        void __fastcall TBtnNextClick(TObject *Sender);
        void __fastcall TBtnLastClick(TObject *Sender);
        void __fastcall TBtnFirstClick(TObject *Sender);
        void __fastcall TBtnCanselClick(TObject *Sender);
        void __fastcall BtnRentClick(TObject *Sender);
        void __fastcall BtnPointClick(TWTField *Sender);

        void __fastcall sbDelDayPayClick(TObject *Sender);
        void __fastcall sbAddDayPayClick(TObject *Sender);

        void __fastcall ChLostClick(TObject *Sender);
        void __fastcall EdTaxNumExit(TObject *Sender);
        void __fastcall ChBoxKeyClick(TObject *Sender);
        void __fastcall N1Click(TObject *Sender);
        void __fastcall N2Click(TObject *Sender);
        void __fastcall N3Click(TObject *Sender);
        void __fastcall N4Click(TObject *Sender);
        void __fastcall N5Click(TObject *Sender);
        void __fastcall N6Click(TObject *Sender);
        void __fastcall N7Click(TObject *Sender);
        void __fastcall BtnProtClick(TObject *Sender);
        void __fastcall SBHistoryClick(TObject *Sender);
        void __fastcall sbInspectorHistoryClick(TObject *Sender);
        void __fastcall ChBankDayClick(TObject *Sender);
        void __fastcall Ch2krDelClick(TObject *Sender);
        void __fastcall sbTrDocClearClick(TObject *Sender);
        void __fastcall cbTrDocTypeChange(TObject *Sender);
        void __fastcall RadGrJurClick(TObject *Sender);
        void __fastcall ChBoxEdClick(TObject *Sender);
        void __fastcall btSendEMailClick(TObject *Sender);
        void __fastcall btMailSetupClick(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall DBGrDayPayDblClick(TObject *Sender);
        void __fastcall ChBoxCabinetClick(TObject *Sender);
        void __fastcall sbDigitalClearClick(TObject *Sender);
        void __fastcall ChBox3PercYearClick(TObject *Sender);
          
        //void __fastcall FormShow(TObject *Sender);

 private:	// User declarations
public:		// User declarations
        __fastcall TFCliState(TComponent* Owner);
        void __fastcall ShowData(int id_client);
        void __fastcall SaveData();
         void ShowDayPayGrid(void);
         void _fastcall BefInsDayPay(TDataSet *Sender);

        //void __fastcall ShowFBank(int id_hpay,int id_pay);
        void __fastcall AbonAccept (TObject* Sender);
        int __fastcall StrToIntI(AnsiString Send);
       float __fastcall StrToFloatI(AnsiString Send);
       int __fastcall CheckState(TObject *Sender);
       void __fastcall CheckDoState(TObject *Sender);
       void _fastcall AfterInsGrParam(TWTDBGrid *Sender);
       void __fastcall tTreeEditDblClick(TObject *Sender);
       void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
       void _fastcall BefInsPay(TWTDBGrid *Sender);
       void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
       void _fastcall BefClosePay(TWTDBGrid *Sender);
       void _fastcall BefClosePayQ(TWTQuery *Sender);
       TWTQuery * QuerSal;
       TWTDBGrid * GrSal;
        TWTQuery * QuerBill;
       TWTDBGrid * GrBill;
        //void __fastcall SBtnClientClick(TObject *Sender);
        TDataSet *SetHeadPay;
        TDataSet *SetPay;
        TWTQuery* QuerHeadPay;
        TWTQuery* QuerPay;
        TWTQuery* DayPayQuery;
        TDataSource* dsDayPayQuery;
           TWTDBGrid* DBGrEnv;

        void __fastcall ShowBlank();
        int fid_client;
        int fins;
        int fperind;
        int fid_addres;
        int fid_addresM;
        int fch_peni;
        int fch_3perc_year;
        int fch_cabinet;
        int fch_bankday;
        int fch_budjet;
        int fch_tax;
        int fch_reactiv;
        int fch_key;
        int fch_lost;
        int fid_kwed;
        int frad_pay;
        int frad_jur;
        int fch_ed;
        int fid_budjet;
        int fid_position;
        int fid_kontrol;
        int fid_taxprop;
        int fid_department;
        int fid_roz;
        int fid_grp;
        int fid_fld;
        int fid_dep;
        int fid_mfobank;
        int fch_del2kr;
        TWTQuery *ParentDataSet;
                int fid_cl;
        int fid_eqp;
              TfTreeForm* fSelectTree;  //Окно дерева для выбора элемента дерева-предка

};
//---------------------------------------------------------------------------
extern PACKAGE TFCliState *FCliState;
//---------------------------------------------------------------------------
#endif
