//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fEdTaxParam.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfTaxParam *fTaxParam;
//---------------------------------------------------------------------------
__fastcall TfTaxParam::TfTaxParam(TComponent* Owner)
        : TForm(Owner)
{
 lRegWarning->Visible = false;
}
//---------------------------------------------------------------------------
 void __fastcall TfTaxParam::CheckSum( float taxval )
 {
   if (taxval>=10000)  lRegWarning->Visible = true;
   else  lRegWarning->Visible = false;

 }
//---------------------------------------------------------------------------
