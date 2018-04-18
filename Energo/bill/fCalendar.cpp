//---------------------------------------------------------------------------


#include <vcl.h>
#pragma hdrstop

#include "fCalendar.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfCalend *fCalend;
AnsiString sqlstr;
//---------------------------------------------------------------------------
__fastcall TfCalend::TfCalend(TComponent* Owner)
        : TForm(Owner)
{
  ZQuery = new TWTQuery(Application);
  ZQuery->Options<< doQuickOpen;

  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

  sqlstr="select fun_mmgg() as mmgg ;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

  try
  {
   ZQuery->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Œ¯Ë·Í‡ "+e.Message.SubString(8,200));
   ZQuery->Close();
   delete ZQuery;
   return;
  }
  ZQuery->First();
  mmgg = ZQuery->FieldByName("mmgg")->AsDateTime;

  ZQuery->Close();

  CalendGrid->Cells[0][0]="œÌ";
  CalendGrid->Cells[1][0]="¬Ú";
  CalendGrid->Cells[2][0]="—";
  CalendGrid->Cells[3][0]="◊Ú";
  CalendGrid->Cells[4][0]="œÚ";
  CalendGrid->Cells[5][0]="—·";
  CalendGrid->Cells[6][0]="¬Ò";


 // Calendar->Date = mmgg;
  Word year1;
  Word month1;
  Word day1;

  DecodeDate(mmgg,year1,month1,day1);
  v_month = month1;
  v_year = year1;

  for (int i = 0; i < 7; i++)
  {
   for (int j = 0; j < 6; j++)
   {
    PDayInfo dinfo= new TDayInfo;
    DatTable[i][j] = dinfo;
   }
  }

  ShowMonth(v_month,v_year);
}
//---------------------------------------------------------------------------
void  TfCalend::ShowMonth(int Month, int Year)
{
//

  for (int i = 0; i < 7; i++)
  {
   for (int j = 0; j < 6; j++)
   {
     PDayInfo dinfo = DatTable[i][j] ;
     dinfo->c_day = 0;
     CalendGrid->Cells[i][j+1] ="";
   }
  }


  sqlstr="select * from calendar where date_trunc('month',c_date) = :dt order by c_date ;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("dt")->AsDateTime = EncodeDate(Year,Month,1);

  try
  {
   ZQuery->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Œ¯Ë·Í‡ "+e.Message.SubString(8,200));
   ZQuery->Close();
   delete ZQuery;
   return;
  }
  ZQuery->First();
  int col;
  int row;
  int c_day ;
  int first_day =0;

  for (int i = 0; i < ZQuery->RecordCount; i++)
  {

    if (ZQuery->FieldByName("c_day")->AsInteger ==1)
      c_day  = 7;
    else
      c_day  = ZQuery->FieldByName("c_day")->AsInteger-1;

    if (i == 0) first_day =c_day;

    col =c_day-1;
    row = floor((i + first_day -1)/7);

    PDayInfo dinfo = DatTable[col][row];
    dinfo->c_date = ZQuery->FieldByName("c_date")->AsDateTime;
    dinfo->c_day  = c_day;

    CalendGrid->Cells[col][row+1] = FormatDateTime("d",ZQuery->FieldByName("c_date")->AsDateTime);

    if (ZQuery->FieldByName("holiday")->AsBoolean)
      dinfo->holiday = 1;
    else
      dinfo->holiday = 0;


    //DatTable[col][row] = dinfo;
    //CalendGrid->Cells[col][row] = IntToStr();
    //mmgg = ZQuery->FieldByName("mmgg")->AsDateTime;
    ZQuery->Next();
  }
  ZQuery->Close();

  MonthYear->Caption=FormatDateTime("mmmm yyyy",EncodeDate(Year,Month,1));
 // Calendar->Date =

}
//---------------------------------------------------------------------------
void __fastcall TfCalend::sbNextMonthClick(TObject *Sender)
{
 if (v_month ==12)
 {
  v_month =1;
  v_year=v_year+1;
 }
 else
  v_month  = v_month+1;

 ShowMonth(v_month,v_year);
}
//---------------------------------------------------------------------------

void __fastcall TfCalend::sbPrevMonthClick(TObject *Sender)
{
 if (v_month ==1)
 {
  v_month =12;
  v_year=v_year-1;
 }
 else
  v_month  = v_month-1;
  
ShowMonth(v_month,v_year);
}
//---------------------------------------------------------------------------

void __fastcall TfCalend::sbNextYearClick(TObject *Sender)
{
v_year=v_year+1;
ShowMonth(v_month,v_year);
}
//---------------------------------------------------------------------------

void __fastcall TfCalend::sbPrevYearClick(TObject *Sender)
{
v_year=v_year-1;
ShowMonth(v_month,v_year);
}
//---------------------------------------------------------------------------

void __fastcall TfCalend::CalendGridDrawCell(TObject *Sender, int ACol,
      int ARow, TRect &Rect, TGridDrawState State)
{
   AnsiString  TheText;

  if (ARow!=0)
  {
//   if (DatTable[ACol][ARow-1]->c_day!=0)
//   {
//    TheText = FormatDateTime("d",DatTable[ACol][ARow-1]->c_date);
//   }
//   else
    TheText =CalendGrid->Cells[ACol][ARow];

//   CalendGrid->Cells[ACol][ARow] =TheText;
   if (DatTable[ACol][ARow-1]->holiday ==1)
     CalendGrid->Canvas->Font->Color = clRed;
   else
     CalendGrid->Canvas->Font->Color = clBlack;

   CalendGrid->Canvas->TextRect(
    Rect,
    Rect.Left + (Rect.Right - Rect.Left - CalendGrid->Canvas->TextWidth(TheText)) / 2,
    Rect.Top + (Rect.Bottom - Rect.Top - CalendGrid->Canvas->TextHeight(TheText)) / 2,
    TheText);
   }
}
//---------------------------------------------------------------------------

void __fastcall TfCalend::btAutoClick(TObject *Sender)
{
  sqlstr="select fill_calend( :dt );";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("dt")->AsDateTime = EncodeDate(v_year,v_month,1);

  try
  {
   ZQuery->ExecSql();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Œ¯Ë·Í‡ "+e.Message.SubString(8,200));
   delete ZQuery;
   return;
  }

  ShowMonth(v_month,v_year);
}
//---------------------------------------------------------------------------


void __fastcall TfCalend::CalendGridDblClick(TObject *Sender)
{
 if (CalendGrid->Row==0) return;
 if (DatTable[CalendGrid->Col][CalendGrid->Row-1]->c_day ==0) return;

 if (DatTable[CalendGrid->Col][CalendGrid->Row-1]->holiday ==1)
     sqlstr="update calendar set holiday = false where c_date = :dt ;";
 else
     sqlstr="update calendar set holiday = true where c_date = :dt ;";

  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("dt")->AsDateTime = DatTable[CalendGrid->Col][CalendGrid->Row-1]->c_date;

  try
  {
   ZQuery->ExecSql();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Œ¯Ë·Í‡ "+e.Message.SubString(8,200));
   delete ZQuery;
   return;
  }

  ShowMonth(v_month,v_year);

 }
//---------------------------------------------------------------------------

