//---------------------------------------------------------------------------

#ifndef fieldH
#define fieldH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TField_val : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TListView *ListView1;
        TSpeedButton *SpeedButton1;
        TEdit *Edit1;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall TField_val(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TField_val *Field_val;
//---------------------------------------------------------------------------
#endif
