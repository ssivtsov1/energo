//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "field.h"
#include "docu_mod.h"
#include "doc_tmp.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TField_val *Field_val;
//---------------------------------------------------------------------------
__fastcall TField_val::TField_val(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TField_val::FormClose(TObject *Sender,
      TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

