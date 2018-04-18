//----------------------------------------------------------------------------
#ifndef MessageH
#define MessageH
//----------------------------------------------------------------------------
#include <vcl\ExtCtrls.hpp>
#include <vcl\Controls.hpp>

#include "Func.h"
#include "Form.h"
#include "List.h"
//----------------------------------------------------------------------------
// Выводит на экран сообщение
//----------------------------------------------------------------------------
class TWTMessage : public TWTMDIWindow {
private:
  TPanel *Panel;
  TButton **ListButton;
  TLabel **ListLabel;
  TWTList *Button;
  TWTList *Label;

  int Choice;

  void _fastcall virtual CloseMessage(TObject *Sender);

public:
  virtual _fastcall TWTMessage(TWinControl *owner);
  virtual _fastcall ~TWTMessage();
  void _fastcall FOnResize(TObject *Sender);

  // Добавить строку к сообщению
  void AddLabel(AnsiString Text, TAlignment Alignment = taCenter);
  // Добавить управляющий элемент
  void AddButton(AnsiString Caption);
  // Отобразить сообщение
  int Show(AnsiString Caption = "", int Left=-1, int Top=-1, int Width=-1, int Height=-1);
};
//----------------------------------------------------------------------------
#endif
