//---------------------------------------------------------------------------

#ifndef fTaxCorPrintParentH
#define fTaxCorPrintParentH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TfTaxCorPrintPrnt : public TForm
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
        __fastcall TfTaxCorPrintPrnt(TComponent* Owner);

         virtual void ShowTaxCor(int id_doc, int print = 0 );
};
//---------------------------------------------------------------------------
extern PACKAGE TfTaxCorPrintPrnt *fRepTaxCor;
//---------------------------------------------------------------------------
#endif
