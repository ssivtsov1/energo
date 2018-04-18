//---------------------------------------------------------------------------

#ifndef fEdTaxParamH
#define fEdTaxParamH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfTaxParam : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TBitBtn *btCancel;
        TBitBtn *btOk;
        TMaskEdit *edDt;
        TEdit *edNum;
        TLabel *Label2;
        TLabel *Label3;
        TLabel *lRegWarning;
private:	// User declarations
public:		// User declarations
        __fastcall TfTaxParam(TComponent* Owner);
        void __fastcall CheckSum( float taxval );
};
//---------------------------------------------------------------------------
extern PACKAGE TfTaxParam *fTaxParam;
//---------------------------------------------------------------------------
#endif
