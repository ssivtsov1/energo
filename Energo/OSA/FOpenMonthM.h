//---------------------------------------------------------------------------

#ifndef FOpenMonthMH
#define FOpenMonthMH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Mask.hpp>
#include "FOpenMonthM.h"

//---------------------------------------------------------------------------
class TFOpenMonth : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TMaskEdit *EdHash;
        TBitBtn *BitBtn1;
        TBitBtn *BitBtn2;
        TMemo *EdMemo;
        TLabel *Label2;
        TEdit *EdMMGG;
        //TEdit  *EdMMGGi;
        void __fastcall BitBtn1Click(TObject *Sender);
        void __fastcall BitBtn2Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFOpenMonth(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TFOpenMonth *FOpenMonth;
//---------------------------------------------------------------------------
#endif
