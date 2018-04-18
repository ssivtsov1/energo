//---------------------------------------------------------------------------

#ifndef ins_grpH
#define ins_grpH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TGrp_ins : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TSpeedButton *Butinsgrp;
        TSpeedButton *cancel;
        TLabel *Label1;
        TEdit *grp_text;
        TRadioButton *RadioButton1;
        TRadioButton *RadioButton2;
        TLabel *Label2;
        TListView *NextGrp;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall cancelClick(TObject *Sender);
        void __fastcall ButinsgrpClick(TObject *Sender);
        void __fastcall RadioButton1Click(TObject *Sender);
        void __fastcall RadioButton2Click(TObject *Sender);
        void __fastcall NextGrpChanging(TObject *Sender, TListItem *Item,
          TItemChange Change, bool &AllowChange);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall TGrp_ins(TComponent* Owner);
        int id_grp;
};
//---------------------------------------------------------------------------
extern PACKAGE TGrp_ins *Grp_ins;
//---------------------------------------------------------------------------
#endif
