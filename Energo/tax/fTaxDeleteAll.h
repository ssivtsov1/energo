//---------------------------------------------------------------------------

#ifndef fTaxDeleteAllH
#define fTaxDeleteAllH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TfDelTaxAll : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TBitBtn *btCancel;
        TBitBtn *btOk;
        TDateTimePicker *dtPeriod;
        TLabel *Label3;
        TComboBox *cbDecade;
        TLabel *Label2;
private:	// User declarations
public:		// User declarations
        __fastcall TfDelTaxAll(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfDelTaxAll *fDelTaxAll;
//---------------------------------------------------------------------------
#endif
