//----------------------------------------------------------------------------
// Функции библиотеки
//----------------------------------------------------------------------------
#ifndef EditH
#define EditH
//----------------------------------------------------------------------------
#include "Mask.hpp"
//----------------------------------------------------------------------------
// Функции пользователя для обработки событии
typedef void __fastcall (__closure *TTEvent)();
//----------------------------------------------------------------------------
class TWTEditDate : public TMaskEdit {
private:
  void _fastcall FOnExit(TObject *Sender);
  TDateTime *DateTime;

public:
  // DateTime - редактируемая переменная
  virtual _fastcall TWTEditDate(TWinControl* AOwner, TDateTime *DateTime = NULL);
  virtual _fastcall ~TWTEditDate() {};
  TTEvent OnExit;
};
#endif
