//----------------------------------------------------------------------------
// ������� ����������
//----------------------------------------------------------------------------
#ifndef EditH
#define EditH
//----------------------------------------------------------------------------
#include "Mask.hpp"
//----------------------------------------------------------------------------
// ������� ������������ ��� ��������� �������
typedef void __fastcall (__closure *TTEvent)();
//----------------------------------------------------------------------------
class TWTEditDate : public TMaskEdit {
private:
  void _fastcall FOnExit(TObject *Sender);
  TDateTime *DateTime;

public:
  // DateTime - ������������� ����������
  virtual _fastcall TWTEditDate(TWinControl* AOwner, TDateTime *DateTime = NULL);
  virtual _fastcall ~TWTEditDate() {};
  TTEvent OnExit;
};
#endif
