//---------------------------------------------------------------------------
#ifndef fPeriodSelH
#define fPeriodSelH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TfPeriodSelect : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TRadioButton *rbDay;
        TRadioButton *rbQuarter;
        TRadioButton *rbMonth;
        TPanel *InfoPanel;
        TComboBox *cbQuarter;
        TCheckBox *cbWithBeginYear;
        TCheckBox *cbWithBeginQuarter;
        TCheckBox *cbWithBeginMonth;
        TComboBox *cbMonth;
        TDateTimePicker *DateEdit;
        TDateTimePicker *StDateEdit;
        TDateTimePicker *EdDateEdit;
        TRadioButton *rbInterval;
        TButton *Button1;
        TButton *Button2;
        TButton *Button3;
        TMaskEdit *edYear1;
        TMaskEdit *edYear2;
        void __fastcall cbQuarterChange(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfPeriodSelect(TComponent* Owner);
        void __fastcall FormShow(TDateTime SelDate1 , TDateTime SelDate2);
        TDateTime DateFrom;
        TDateTime DateTo;
        int init;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfPeriodSelect *fPeriodSelect;
//---------------------------------------------------------------------------
#endif
