//---------------------------------------------------------------------------
#ifndef fEqpAirLineDetH
#define fEqpAirLineDetH
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
class TfALineDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TSpeedButton *bEqpTypeSel;
        TLabel *Label2;
        TSpeedButton *bPillarSel;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TSpeedButton *bPendantSel;
        TLabel *Label6;
        TSpeedButton *bEarthSel;
        TEdit *edCordeName;
        TEdit *edLength;
        TEdit *edPillarName;
        TEdit *edStep;
        TEdit *edPendantName;
        TEdit *edEarthName;
        TLabel *Label14;
        TLabel *Label7;
        TLabel *Label8;
        TLabel *lClassVal;
        TSpeedButton *sbClassSel;
        TEdit *edClassId;
        TLabel *Label9;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall bEqpTypeSelClick(TObject *Sender);
        void __fastcall bPillarSelClick(TObject *Sender);
        void __fastcall bPendantSelClick(TObject *Sender);
        void __fastcall bEarthSelClick(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall sbClassSelClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
//        AnsiString name_table_ind;
//        AnsiString name_table;
//        int TypeId;

//        AnsiString sqlstr;
        // коды loockup полей
        int CordeId;
        int PillarId;
        int PendantId;
        int EarthId;

        __fastcall TfALineDet(TComponent* Owner);

        void _fastcall ShowCorde(AnsiString retvalue);
        void __fastcall CordeAccept(TObject* Sender);
        void _fastcall ShowPillar(AnsiString retvalue);
        void __fastcall PillarAccept(TObject* Sender);
        void _fastcall ShowPendant(AnsiString retvalue);
        void __fastcall PendantAccept(TObject* Sender);
        void _fastcall ShowEarth(AnsiString retvalue);
        void __fastcall EarthAccept(TObject* Sender);
        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);
        void _fastcall ShowVoltage(AnsiString retvalue);
        void __fastcall VoltageAccept(TObject* Sender);

       bool edit_enable;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfSimpleEqpDet *fSimpleEqpDet;
//---------------------------------------------------------------------------
#endif
