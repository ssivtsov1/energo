//---------------------------------------------------------------------------
#ifndef fGroundDetH
#define fGroundDetH
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
class TfGroundDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TEdit *edPower;
        TLabel *Label4;
        TEdit *edWorkTime;
        TBitBtn *btEquipment;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall btEquipmentClick(TObject *Sender);
//        void __fastcall bEqpTypeSelClick(TObject *Sender);
private:	// User declarations
public:		// User declarations

        __fastcall TfGroundDet(TComponent* Owner);
        void __fastcall EqpAccept (TObject* Sender);        
        TWTWinDBGrid *WEqpGrid;
        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);

        bool edit_enable;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfSimpleEqpDet *fSimpleEqpDet;
//---------------------------------------------------------------------------
#endif
