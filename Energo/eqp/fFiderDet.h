//---------------------------------------------------------------------------
#ifndef fFiderDetH
#define fFiderDetH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "Main.h"
#include "fDet.h"
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TfFiderDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label3;
        TLabel *Label15;
        TEdit *edClassId;
        TLabel *lClassVal;
        TSpeedButton *sbClassSel;
        TLabel *lLengthCaption;
        TLabel *lLength;
        TLabel *Label2;
        TEdit *EdPosition;
        TSpeedButton *sbPosition;
        TSpeedButton *spPositionClear;
        TGroupBox *GroupBox1;
        TLabel *Label4;
        TEdit *edLostsCoef;
        TBevel *Bevel1;
        TLabel *Label1;
        TEdit *edL04_count;
        TLabel *Label5;
        TEdit *edL04_length;
        TEdit *edL04f1_length;
        TLabel *Label6;
        TLabel *Label7;
        TEdit *edL04f3_length;
        TLabel *Label8;
        TEdit *edFgcp;
        TCheckBox *cbBalansOnly;
        TSpeedButton *sbWorks;
        TSpeedButton *sbPlanWorks;
        TLabel *Label9;
        TEdit *edPSName;
        TSpeedButton *sbPS;
        TSpeedButton *sbPSCl;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall sbClassSelClick(TObject *Sender);
        void __fastcall sbPositionClick(TObject *Sender);
        void __fastcall spPositionClearClick(TObject *Sender);
        void __fastcall sbWorksClick(TObject *Sender);
        void __fastcall sbPlanWorksClick(TObject *Sender);
        void __fastcall sbPSClick(TObject *Sender);
        void __fastcall sbPSClClick(TObject *Sender);
//        void __fastcall bEqpTypeSelClick(TObject *Sender);
private:	// User declarations
public:		// User declarations

        __fastcall TfFiderDet(TComponent* Owner);

        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);
        void _fastcall ShowVoltage(AnsiString retvalue);
        void __fastcall VoltageAccept(TObject* Sender);
        void __fastcall PosAccept (TObject* Sender);
        void __fastcall PSAccept (TObject* Sender);
      
        bool edit_enable;
        int id_position;
        int PSId;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfSimpleEqpDet *fSimpleEqpDet;
//---------------------------------------------------------------------------
#endif
