//---------------------------------------------------------------------------

#ifndef TWTCompatableH
#define TWTCompatableH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "Form.h"
//---------------------------------------------------------------------------
class TfTWTCompForm : public TForm
{
__published:	// IDE-managed Components
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall TfTWTCompForm(TComponent* Owner,bool regmenu=true);
       void __fastcall ShowAs(AnsiString ID,int flag_modal=-1);
       bool NoDeactivate;
       void _fastcall ActivateMenu(TObject *Sender);
       TMenuItem *WindowMenu;
       AnsiString ID;
};
//---------------------------------------------------------------------------
#endif
