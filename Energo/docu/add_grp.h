//---------------------------------------------------------------------------

#ifndef add_grpH
#define add_grpH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TGrp_add : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TSpeedButton *Butaddgrp;
        TSpeedButton *Butcangrp;
        TEdit *grp_text;
        TLabel *Label1;
        void __fastcall ButaddgrpClick(TObject *Sender);
        void __fastcall ButcangrpClick(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall TGrp_add(TComponent* Owner);
        int id_grp;
};
//---------------------------------------------------------------------------
extern PACKAGE TGrp_add *Grp_add;
//---------------------------------------------------------------------------
#endif
