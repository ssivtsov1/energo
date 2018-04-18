//---------------------------------------------------------------------------

#ifndef fTaxPrintParentH
#define fTaxPrintParentH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TfTaxPrintPrnt : public TForm
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
        __fastcall TfTaxPrintPrnt(TComponent* Owner);

         virtual void ShowTaxNal(int id_doc, int print = 0 );
};
//---------------------------------------------------------------------------
extern PACKAGE TfTaxPrintPrnt *fRepTaxN;
//---------------------------------------------------------------------------
#endif
