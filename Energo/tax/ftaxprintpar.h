//---------------------------------------------------------------------------

#ifndef ftaxprintparH
#define ftaxprintparH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfTaxPrintParams : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TBitBtn *btCancel;
        TBitBtn *btOk;
        TLabel *Label1;
        TMaskEdit *edStart;
        TDateTimePicker *dtPeriod;
        TEdit *edStop;
        TLabel *Label2;
        TLabel *Label3;
        TCheckBox *cbPrintAll;

        void __fastcall FormShow(TObject *Sender);
        void __fastcall edStartClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfTaxPrintParams(TComponent* Owner);
};
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
#endif
