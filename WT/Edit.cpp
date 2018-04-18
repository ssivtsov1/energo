#include <vcl.h>
#pragma hdrstop
//----------------------------------------------------------------------------
// Функции редактирования переменных
//----------------------------------------------------------------------------
#include "Edit.h"
#include "Func.h"
//----------------------------------------------------------------------------
// Редактирование даты (с коррекцией века)
//----------------------------------------------------------------------------
_fastcall TWTEditDate::TWTEditDate(TWinControl *owner, TDateTime *DateTime) : TMaskEdit(owner) {
  TWTEditDate::DateTime = DateTime;
  Parent = owner;
  TMaskEdit::OnExit = FOnExit;
  OnExit = NULL;
  Width = StringSize("99.99.9999", Font) + 10;
  Height = StringSize('A', Font, 1) + 4;
  MaxLength = 12;
  EditMask = "99.99.9999";
  Text = DateToStr(*DateTime);
}
//----------------------------------------------------------------------------
void _fastcall TWTEditDate::FOnExit(TObject *Sender) {
  *DateTime = StrToDate(Text);
  if (Text.Length() == 8) {
    // Коррректируем дату с учетом века
    *DateTime = SetCentury(*DateTime);
  }
  if (OnExit) OnExit();
}
//----------------------------------------------------------------------------

