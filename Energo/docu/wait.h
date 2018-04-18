//---------------------------------------------------------------------------

#ifndef waitH
#define waitH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class Twt : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TAnimate *Animate1;
private:	// User declarations
public:		// User declarations
        __fastcall Twt(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE Twt *wt;
//---------------------------------------------------------------------------
#endif
