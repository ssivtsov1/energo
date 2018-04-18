//---------------------------------------------------------------------------

#ifndef fTaxCorPrint2016H
#define fTaxCorPrint2016H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Qrctrls.hpp>
#include <QuickRpt.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
#include <QRCtrls.hpp>
#include <Graphics.hpp>
#include "IcXMLParser.hpp"
#include "fTaxCorPrintParent.h"
//---------------------------------------------------------------------------
class TfRepTaxCor2016 : public TfTaxCorPrintPrnt
{
__published:	// IDE-managed Components
        TQuickRep *PrintTax;
        TQRBand *QRBand1;
        TQRShape *QRShape2;
        TQRLabel *QRLabel2;
        TQRMemo *QRMemo1;
        TQRLabel *QRLabel4;
        TQRLabel *QRLabel5;
        TQRLabel *QRLabel8;
        TQRLabel *QRLabel9;
        TQRLabel *QRLabel10;
        TQRShape *QRShape5;
        TQRShape *QRShape6;
        TQRShape *QRShape7;
        TQRShape *QRShape8;
        TQRShape *QRShape9;
        TQRShape *QRShape10;
        TQRShape *QRShape11;
        TQRShape *QRShape12;
        TQRShape *QRShape13;
        TQRShape *QRShape14;
        TQRShape *QRShape15;
        TQRShape *QRShape16;
        TQRShape *QRShape17;
        TQRShape *QRShape18;
        TQRShape *QRShape19;
        TQRShape *QRShape20;
        TQRShape *QRShape21;
        TQRShape *QRShape22;
        TQRShape *QRShape23;
        TQRShape *QRShape24;
        TQRShape *QRShape25;
        TQRShape *QRShape26;
        TQRShape *QRShape27;
        TQRShape *QRShape28;
        TQRShape *QRShape29;
        TQRShape *QRShape30;
        TQRLabel *QRLabel11;
        TQRLabel *QRLabel12;
        TQRShape *QRShape33;
        TQRShape *QRShape35;
        TQRShape *QRShape36;
        TQRShape *QRShape37;
        TQRShape *QRShape38;
        TQRShape *QRShape41;
        TQRShape *QRShape42;
        TQRShape *QRShape44;
        TQRLabel *QRLabel23;
        TQRLabel *QRLabel25;
        TQRLabel *QRLabel26;
        TQRLabel *QRLabel27;
        TQRLabel *QRLabel28;
        TQRLabel *QRLabel35;
        TQRLabel *lResName;
        TQRLabel *lAbonName;
        TQRLabel *QRLabel77;
        TQRLabel *QRLabel78;
        TQRLabel *QRLabel79;
        TQRLabel *QRLabel80;
        TQRLabel *QRLabel81;
        TQRLabel *QRLabel82;
        TQRLabel *QRLabel83;
        TQRLabel *QRLabel84;
        TQRLabel *QRLabel85;
        TQRLabel *QRLabel86;
        TQRLabel *QRLabel87;
        TQRLabel *QRLabel88;
        TQRLabel *QRLabel89;
        TQRLabel *QRLabel90;
        TQRLabel *QRLabel91;
        TQRLabel *QRLabel92;
        TQRLabel *QRLabel93;
        TQRLabel *QRLabel94;
        TQRLabel *QRLabel95;
        TQRLabel *QRLabel96;
        TQRLabel *QRLabel97;
        TQRLabel *QRLabel98;
        TQRLabel *QRLabel99;
        TQRLabel *QRLabel100;
        TQRBand *QRBand2;
        TQRLabel *QRLabel62;
        TQRLabel *QRLabel63;
        TQRLabel *QRLabel64;
        TQRLabel *QRLabel66;
        TQRLabel *QRLabel76;
        TZPgSqlQuery *ZQTax;
        TZPgSqlQuery *ZQTaxSumm;
        TQRChildBand *ChildBand1;
        TQRShape *QRShape165;
        TQRShape *QRShape166;
        TQRShape *QRShape168;
        TQRLabel *QRLabel67;
        TQRLabel *QRLabel104;
        TQRLabel *QRLabel105;
        TQRLabel *QRLabel106;
        TQRLabel *QRLabel107;
        TQRLabel *QRLabel108;
        TQRLabel *QRLabel109;
        TQRShape *QRShape180;
        TQRShape *QRShape181;
        TQRShape *QRShape182;
        TQRShape *QRShape183;
        TQRShape *QRShape185;
        TQRLabel *QRLabel111;
        TQRLabel *lCode;
        TQRCompositeReport *crTwoPages;
        TQRBand *bSimple;
        TQRShape *QRShape134;
        TQRShape *QRShape135;
        TQRShape *QRShape144;
        TQRShape *QRShape145;
        TQRShape *QRShape156;
        TQRShape *QRShape186;
        TQRDBText *QRDBText12;
        TQRDBText *QRDBText13;
        TQRDBText *QRDBText14;
        TQRDBText *QRDBText16;
        TQRDBText *QRDBText20;
        TQRLabel *QRLabel116;
        TQRShape *QRShape193;
        TQRShape *QRShape194;
        TQRShape *QRShape195;
        TQRShape *QRShape196;
        TQRShape *QRShape197;
        TQRShape *QRShape198;
        TQRShape *QRShape199;
        TQRShape *QRShape200;
        TQRShape *QRShape201;
        TQRShape *QRShape202;
        TQRShape *QRShape203;
        TQRLabel *lTaxDate1;
        TQRLabel *lTaxDate2;
        TQRLabel *lTaxDate3;
        TQRLabel *lTaxDate4;
        TQRLabel *lTaxDate5;
        TQRLabel *lTaxDate6;
        TQRLabel *lTaxDate7;
        TQRLabel *lTaxDate8;
        TQRShape *QRShape204;
        TQRShape *QRShape205;
        TQRShape *QRShape206;
        TQRShape *QRShape207;
        TQRShape *QRShape208;
        TQRShape *QRShape209;
        TQRShape *QRShape210;
        TQRLabel *lTaxNum1;
        TQRLabel *lTaxNum2;
        TQRLabel *lTaxNum3;
        TQRLabel *lTaxNum4;
        TQRLabel *lTaxNum5;
        TQRLabel *lTaxNum6;
        TQRLabel *lTaxNum7;
        TQRShape *QRShape211;
        TQRShape *QRShape212;
        TQRShape *QRShape213;
        TQRShape *QRShape214;
        TQRLabel *lCorNum8;
        TQRLabel *lCorNum9;
        TQRLabel *lCorNum10;
        TQRLabel *lCorNum11;
        TQRLabel *QRLabel117;
        TQRLabel *QRLabel139;
        TQRShape *QRShape89;
        TQRLabel *QRLabel33;
        TQRLabel *QRLabel49;
        TQRLabel *lNoGive;
        TQRLabel *lNoGive1;
        TQRLabel *lNoGive2;
        TQRLabel *QRLabel70;
        TQRLabel *QRLabel47;
        TQRShape *QRShape67;
        TQRLabel *QRLabel71;
        TQRShape *QRShape69;
        TQRLabel *QRLabel72;
        TQRShape *QRShape71;
        TQRLabel *QRLabel115;
        TQRLabel *QRLabel132;
        TQRLabel *QRLabel133;
        TQRShape *QRShape68;
        TQRLabel *QRLabel121;
        TQRShape *QRShape77;
        TQRShape *QRShape99;
        TQRLabel *QRLabel136;
        TQRShape *QRShape1;
        TQRShape *QRShape4;
        TQRDBText *QRDBText4;
        TQRShape *QRShape114;
        TQRShape *QRShape115;
        TQRLabel *QRLabel146;
        TQRLabel *QRLabel147;
        TQRDBText *QRDBText21;
        TQRShape *QRShape116;
        TQRShape *QRShape117;
        TQRLabel *QRLabel149;
        TQRLabel *QRLabel3;
        TQRShape *QRShape118;
        TQRShape *QRShape119;
        TQRShape *QRShape120;
        TQRShape *QRShape121;
        TQRShape *QRShape122;
        TQRLabel *QRLabel137;
        TQRLabel *QRLabel150;
        TQRShape *QRShape123;
        TQRLabel *QRLabel6;
        TQRLabel *QRLabel7;
        TQRLabel *QRLabel1;
        TQRLabel *QRLabel13;
        TQRShape *QRShape31;
        TQRLabel *QRLabel16;
        TQRShape *QRShape51;
        TQRLabel *QRLabel21;
        TQRLabel *QRLabel22;
        TQRShape *QRShape53;
        TQRShape *QRShape54;
        TQRShape *QRShape56;
        TQRLabel *QRLabel24;
        TQRLabel *QRLabel29;
        TQRShape *QRShape57;
        TQRShape *QRShape58;
        TQRShape *QRShape59;
        TQRLabel *QRLabel30;
        TQRLabel *QRLabel31;
        TQRShape *QRShape60;
        TQRShape *QRShape61;
        TQRShape *QRShape62;
        TQRLabel *QRLabel32;
        TQRLabel *QRLabel34;
        TQRShape *QRShape63;
        TQRShape *QRShape64;
        TQRShape *QRShape65;
        TQRLabel *QRLabel36;
        TQRLabel *QRLabel37;
        TQRShape *QRShape66;
        TQRShape *QRShape70;
        TQRShape *QRShape101;
        TQRLabel *QRLabel38;
        TQRLabel *QRLabel39;
        TQRShape *QRShape102;
        TQRShape *QRShape103;
        TQRShape *QRShape111;
        TQRLabel *QRLabel40;
        TQRLabel *QRLabel41;
        TQRShape *QRShape124;
        TQRShape *QRShape125;
        TQRShape *QRShape126;
        TQRLabel *QRLabel42;
        TQRLabel *QRLabel43;
        TQRShape *QRShape127;
        TQRShape *QRShape128;
        TQRShape *QRShape129;
        TQRLabel *QRLabel44;
        TQRLabel *qrlNDS;
        TQRLabel *qrlSum;
        TQRLabel *QRLabel19;
        TQRShape *QRShape45;
        TQRShape *QRShape73;
        TQRShape *QRShape74;
        TQRShape *QRShape75;
        TQRShape *QRShape76;
        TQRShape *QRShape78;
        TQRShape *QRShape79;
        TQRShape *QRShape81;
        TQRShape *QRShape82;
        TQRShape *QRShape83;
        TQRLabel *QRLINN10;
        TQRLabel *QRLINN9;
        TQRLabel *QRLINN8;
        TQRLabel *QRLINN7;
        TQRLabel *QRLINN6;
        TQRLabel *QRLINN5;
        TQRLabel *QRLINN4;
        TQRLabel *QRLINN3;
        TQRLabel *QRLINN2;
        TQRLabel *QRLINN1;
        TQRLabel *QRLabel57;
        TQRLabel *QRLabel59;
        TQRLabel *QRLabel60;
        TQRLabel *QRLabel45;
        TQRShape *QRShape84;
        TQRShape *QRShape85;
        TQRLabel *QRLabel46;
        TQRLabel *QRLFbnFil1;
        TQRLabel *QRLFbnFil2;
        TQRLabel *QRLFbnFil3;
        TQRLabel *QRLFbnFil4;
        TQRLabel *QRLabel48;
        TQRLabel *QRLabel15;
        TQRLabel *QRLabel17;
        TQRLabel *QRLabel18;
        TQRShape *QRShape3;
        TQRShape *QRShape34;
        TQRShape *QRShape39;
        TQRShape *QRShape40;
        TQRShape *QRShape43;
        TQRShape *QRShape46;
        TQRShape *QRShape86;
        TQRShape *QRShape87;
        TQRLabel *lCorDate1;
        TQRLabel *lCorDate2;
        TQRLabel *lCorDate3;
        TQRLabel *lCorDate4;
        TQRLabel *lCorDate5;
        TQRLabel *lCorDate6;
        TQRLabel *lCorDate7;
        TQRLabel *lCorDate8;
        TQRShape *QRShape88;
        TQRShape *QRShape90;
        TQRShape *QRShape91;
        TQRShape *QRShape92;
        TQRShape *QRShape93;
        TQRShape *QRShape94;
        TQRShape *QRShape95;
        TQRLabel *lCorNum1;
        TQRLabel *lCorNum2;
        TQRLabel *lCorNum3;
        TQRLabel *lCorNum4;
        TQRLabel *lCorNum5;
        TQRLabel *lCorNum6;
        TQRLabel *lCorNum7;
        TQRLabel *QRLabel102;
        TQRShape *QRShape96;
        TQRLabel *QRLabel103;
        TQRShape *QRShape97;
        TQRShape *QRShape98;
        TQRShape *QRShape100;
        TQRShape *QRShape105;
        TQRLabel *lTaxNum8;
        TQRLabel *lTaxNum9;
        TQRLabel *lTaxNum10;
        TQRLabel *lTaxNum11;
        TQRLabel *QRLabel118;
        TQRShape *QRShape106;
        TQRLabel *QRLabel119;
        TQRLabel *QRLabel120;
        TQRShape *QRShape107;
        TQRLabel *QRLabel122;
        TQRLabel *QRLabel123;
        TQRShape *QRShape108;
        TQRShape *QRShape109;
        TQRShape *QRShape110;
        TQRLabel *QRLabel124;
        TQRShape *QRShape112;
        TQRLabel *QRLabel126;
        TQRShape *QRShape113;
        TQRShape *QRShape130;
        TQRLabel *QRLabel127;
        TQRLabel *QRLabel128;
        TQRShape *QRShape32;
        TQRShape *QRShape47;
        TQRLabel *QRLabel14;
        TQRLabel *QRLabel125;
        TQRShape *QRShape48;
        TQRShape *QRShape49;
        TQRShape *QRShape50;
        TQRShape *QRShape52;
        TQRShape *QRShape55;
        TQRLabel *QRLabel20;
        TQRDBText *QRDBText1;
        TQRDBText *QRDBText2;
        TQRLabel *lHERPN;
        TQRLabel *lHERPN0;
        TQRLabel *qrlNDS2;
        TQRDBText *QRDBText3;
        TQRMemo *QRMemo2;
        TQRLabel *QRLabel68;
        TQRLabel *QRLabel69;
        TQRShape *QRShape72;
        TQRLabel *QRLabel56;
        TQRShape *QRShape80;
        TQRShape *QRShape104;
        TQRLabel *QRLabel50;
        TQRLabel *QRLabel51;
        TQRShape *QRShape132;
        TQRLabel *QRLabel52;
        TQRLabel *QRLabel53;
        TQRShape *QRShape133;
        TQRLabel *QRLabel55;
        TQRShape *QRShape131;
        TQRShape *QRShape136;
        TQRLabel *QRLabel54;
        TQRLabel *QRLabel58;
        TQRShape *QRShape137;
        TQRShape *QRShape138;
        TQRDBText *QRDBText5;
        void __fastcall crTwoPagesAddReports(TObject *Sender);
        void __fastcall PrintTaxBeforePrint(TCustomQuickRep *Sender,
          bool &PrintReport);
        void __fastcall QRBand1BeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall bSimpleBeforePrint(TQRCustomBand *Sender,
          bool &PrintBand);
        void __fastcall QRBand2AfterPrint(TQRCustomBand *Sender,
          bool BandPrinted);
private:	// User declarations
public:		// User declarations
        __fastcall TfRepTaxCor2016(TComponent* Owner);
        virtual void ShowTaxCor(int id_doc, int print =0);        
        int flag_taxpay;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfRepTaxN *fRepTaxN;
//---------------------------------------------------------------------------
#endif
