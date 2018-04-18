//---------------------------------------------------------------------------

#ifndef SysVarMH
#define SysVarMH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TFShowSys : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TMaskEdit *EdMMGG;
        TCheckBox *ChNext;
        TBitBtn *BtnSave;
        TLabel *Label1;
        TLabel *Label2;
        TMaskEdit *EdMMGGN;
        void __fastcall ChNextClick(TObject *Sender);
        void __fastcall BtnSaveClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFShowSys(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TFShowSys *FShowSys;
//---------------------------------------------------------------------------
#endif
