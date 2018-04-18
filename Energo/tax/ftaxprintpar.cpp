//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ftaxprintpar.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfChangeDate *fChangeDate;
//---------------------------------------------------------------------------
__fastcall TfTaxPrintParams::TfTaxPrintParams(TComponent* Owner)
        : TForm(Owner)
{

}
//---------------------------------------------------------------------------
void __fastcall TfTaxPrintParams::FormShow(TObject *Sender)
{
//DateTime->Date=Now();
ActiveControl = edStop;
}
//---------------------------------------------------------------------------

void __fastcall TfTaxPrintParams::edStartClick(TObject *Sender)
{
if (edStart->Text=="") edStart->SelStart=0;        
}
//---------------------------------------------------------------------------



