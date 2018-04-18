//---------------------------------------------------------------------------

#ifndef fChangeH
#define fChangeH
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
class TfChangeDate : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TBitBtn *btCancel;
        TBitBtn *btOk;
        TLabel *Label1;
        TMaskEdit *edDt_change;
        void __fastcall FormShow(TObject *Sender);
        void __fastcall edDt_changeClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfChangeDate(TComponent* Owner);
};
//---------------------------------------------------------------------------
//extern PACKAGE TfChangeData *fChangeData;
//---------------------------------------------------------------------------
#endif
