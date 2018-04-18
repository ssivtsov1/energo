//---------------------------------------------------------------------------

#include <vcl.h>
#include <math.h>
#pragma hdrstop
#include "fPeriodSel.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//#pragma link "ToolEdit"
#pragma resource "*.dfm"
//TfPeriodSelect *fPeriodSelect;
//---------------------------------------------------------------------------
__fastcall TfPeriodSelect::TfPeriodSelect(TComponent* Owner)
        : TForm(Owner)
{

}
//---------------------------------------------------------------------------

void __fastcall TfPeriodSelect::FormShow(TDateTime SelDate1 , TDateTime SelDate2)
{
  init = 1;

  StDateEdit->Date = SelDate1;
  EdDateEdit->Date = SelDate2;
  DateEdit->Date = SelDate1;

  Word year1=0;
  Word month1=0;
  Word day1=0;

  Word year2=0;
  Word month2=0;
  Word day2=0;

  DecodeDate(SelDate1,year1,month1,day1);
  DecodeDate(SelDate2,year2,month2,day2);

  edYear1->Text = IntToStr(year1);
  edYear2->Text = IntToStr(year1);

  cbMonth->ItemIndex = month1-1;
  cbQuarter->ItemIndex = floor(month1/3)+1 ;
  init = 0;
  cbQuarterChange(this);

}
//---------------------------------------------------------------------------
void __fastcall TfPeriodSelect::cbQuarterChange(TObject *Sender)
{
 if (init ==1 ) return;

 try
 {
  if (rbQuarter->Checked)
  {
    StDateEdit->Date = EncodeDate(StrToInt(edYear1->Text),cbQuarter->ItemIndex*3+1,1);
    EdDateEdit->Date = IncMonth(StDateEdit->Date,3)-1;
  }

  if (rbMonth->Checked)
  {
    StDateEdit->Date = EncodeDate(StrToInt(edYear2->Text),cbMonth->ItemIndex+1,1);
    EdDateEdit->Date = IncMonth(StDateEdit->Date,1)-1;
  }

  if (rbDay->Checked)
  {
   StDateEdit->Date=DateEdit->Date;
   EdDateEdit->Date=DateEdit->Date;
  }

  //rbInterval
 }
 catch (...){};

 DateFrom = StDateEdit->Date;
 DateTo = EdDateEdit->Date;

 InfoPanel->Caption = "Выбран период с " +FormatDateTime("dd.mm.yy ",DateFrom)
   +" по "+FormatDateTime("dd.mm.yy ",DateTo);

}
//---------------------------------------------------------------------------

