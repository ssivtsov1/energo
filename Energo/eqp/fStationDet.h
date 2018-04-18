//---------------------------------------------------------------------------
#ifndef fStationDetH
#define fStationDetH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "Main.h"
#include "fDet.h"
#include <ExtCtrls.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfStationDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TLabel *Label3;
        TEdit *edCount;
        TEdit *edPower;
        TLabel *Label5;
        TLabel *Label15;
        TLabel *lClassVal;
        TSpeedButton *sbClassSel;
        TEdit *edClassId;
        TCheckBox *cbAbonPS;
        TLabel *Label2;
        TEdit *edTypeName1;
        TSpeedButton *bEqpTypeSel1;
        TLabel *Label4;
        TEdit *edTypeName2;
        TSpeedButton *bEqpTypeSel2;
        TLabel *Label6;
        TEdit *edTypeName3;
        TSpeedButton *bEqpTypeSel3;
        TLabel *Label7;
        TEdit *edTypeName4;
        TSpeedButton *bEqpTypeSel4;
        TSpeedButton *bEqpTypeClear1;
        TSpeedButton *bEqpTypeClear2;
        TSpeedButton *bEqpTypeClear3;
        TSpeedButton *bEqpTypeClear4;
        TLabel *Label8;
        TEdit *edPregDay;
        TLabel *Label11;
        TMaskEdit *edPregDayData;
        TBitBtn *btEquipment;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall edPregDayDataChange(TObject *Sender);
        void __fastcall sbClassSelClick(TObject *Sender);
        void __fastcall bEqpTypeSel1Click(TObject *Sender);
        void __fastcall bEqpTypeSel2Click(TObject *Sender);
        void __fastcall bEqpTypeSel3Click(TObject *Sender);
        void __fastcall bEqpTypeSel4Click(TObject *Sender);
        void __fastcall bEqpTypeClear1Click(TObject *Sender);
        void __fastcall bEqpTypeClear2Click(TObject *Sender);
        void __fastcall bEqpTypeClear3Click(TObject *Sender);
        void __fastcall bEqpTypeClear4Click(TObject *Sender);
        void __fastcall btEquipmentClick(TObject *Sender);
//        void __fastcall bEqpTypeSelClick(TObject *Sender);
private:	// User declarations
public:		// User declarations

        __fastcall TfStationDet(TComponent* Owner);

        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);
        void _fastcall ShowVoltage(AnsiString retvalue);
        void __fastcall VoltageAccept(TObject* Sender);

        void _fastcall ShowDict(int* comp_id, TEdit* comp_edit);
        void __fastcall CompAccept (TObject* Sender);
        void __fastcall EqpAccept (TObject* Sender);
        
        bool edit_enable;
        int* current_id;
        TEdit* current_edit;
        TWTWinDBGrid *WEqpGrid;
        int compTypeId1;
        int compTypeId2;
        int compTypeId3;
        int compTypeId4;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfSimpleEqpDet *fSimpleEqpDet;
//---------------------------------------------------------------------------
#endif
