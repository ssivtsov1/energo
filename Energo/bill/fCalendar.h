//---------------------------------------------------------------------------

#ifndef fCalendarH
#define fCalendarH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include "Main.h"
#include <Grids.hpp>
//---------------------------------------------------------------------------
typedef struct
{
  TDateTime c_date;
  int c_day;
  int holiday;
} TDayInfo;

typedef  TDayInfo* PDayInfo;

class TfCalend : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TPanel *Panel2;
        TBitBtn *BitBtn2;
        TPanel *Panel3;
        TBitBtn *btSetHDay;
        TBitBtn *btAuto;
        TStringGrid *CalendGrid;
        TStaticText *MonthYear;
        TSpeedButton *sbPrevYear;
        TSpeedButton *sbPrevMonth;
        TSpeedButton *sbNextYear;
        TSpeedButton *sbNextMonth;

        void __fastcall sbNextMonthClick(TObject *Sender);
        void __fastcall sbPrevMonthClick(TObject *Sender);
        void __fastcall sbNextYearClick(TObject *Sender);
        void __fastcall sbPrevYearClick(TObject *Sender);
        void __fastcall CalendGridDrawCell(TObject *Sender, int ACol,
          int ARow, TRect &Rect, TGridDrawState State);
        void __fastcall btAutoClick(TObject *Sender);
        void __fastcall CalendGridDblClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfCalend(TComponent* Owner);
        void ShowMonth(int Month, int Year);        
        TWTQuery * ZQuery;
        int v_year;
        int v_month;
        TDateTime mmgg;
        PDayInfo DatTable[7][6];

};
//---------------------------------------------------------------------------
extern PACKAGE TfCalend *fCalend;
//---------------------------------------------------------------------------
#endif
