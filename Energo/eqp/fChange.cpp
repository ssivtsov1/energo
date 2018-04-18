//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fChange.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfChangeDate *fChangeDate;
//---------------------------------------------------------------------------
__fastcall TfChangeDate::TfChangeDate(TComponent* Owner)
        : TForm(Owner)
{

}
//---------------------------------------------------------------------------
void __fastcall TfChangeDate::FormShow(TObject *Sender)
{
//DateTime->Date=Now();
ActiveControl = edDt_change;
}
//---------------------------------------------------------------------------

void __fastcall TfChangeDate::edDt_changeClick(TObject *Sender)
{
if (edDt_change->Text=="  .  .    ") edDt_change->SelStart=0;
}
//---------------------------------------------------------------------------

