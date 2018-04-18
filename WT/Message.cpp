//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Message.h"
int MaxWidthButton = 0;
//----------------------------------------------------------------------------
// Структура для элемента сообщения на экране
typedef struct ListCaption {
  AnsiString Caption;
  TAlignment Alignment;
} TListCaption;

//---------------------------------------------------------------------
// функции класса TWTMessage
//---------------------------------------------------------------------
_fastcall TWTMessage::TWTMessage(TWinControl *owner) : TWTMDIWindow(owner) {

  BorderStyle = bsDialog;
  TForm::OnResize= FOnResize;

  // При отсутствии выбора возвращаем -1
  Choice = -1;

  Panel = new TPanel(this);
  Panel->BevelInner = bvLowered;
  Panel->BevelOuter = bvLowered;
  Panel->BorderStyle = bsSingle;
	Panel->BorderWidth = 1;
	Panel->BevelWidth = 0;
  Panel->TabOrder = 0;
  Panel->Parent = this;
  Panel->ParentFont = true;

  Label = new TWTList;
  Button = new TWTList;
}
//---------------------------------------------------------------------
_fastcall TWTMessage::~TWTMessage() {
  DEL(Label);
  DEL(Button);
}
//---------------------------------------------------------------------
void TWTMessage::AddLabel(AnsiString Caption, TAlignment Alignment) {
  ListCaption *AStruct;
  AStruct = new ListCaption;
  AStruct->Caption = Caption;
  AStruct->Alignment = Alignment;
  Label->Add(AStruct);
}
//---------------------------------------------------------------------
void TWTMessage::AddButton(AnsiString Caption) {
  ListCaption *AStruct;
  AStruct = new ListCaption;
  AStruct->Caption = Caption;
  Button->Add(AStruct);
}
//---------------------------------------------------------------------
int TWTMessage::Show(AnsiString Caption, int Left, int Top, int Width, int Height) {
  int CountLabel = Label->Count;
  int CountButton = Button->Count;

  // Максимальный размер строки в пикселах
  int MaxWidthLabel = 0;
  // Максимальный размер надписи на кнопке в пикселах
  // (кнопки все одинаковые)

  // Высота кнопки
  int ButtonHeight = StringSize("A", Font, 1) + 8;
  int i, Length;

  ListCaption *AStruct;

  // Если нет управляющих элементов добавляем "OK"
  if (CountButton == 0) {
    CountButton = 1;
    AddButton("OK");
  }

  // Создаем описание всех элемнтов
  ListLabel = new TLabel *[CountLabel];
  for (i = 0;  i < CountLabel; i++) {
    AStruct = (ListCaption *) Label->Items[i];
    ListLabel[i] = new TLabel(this);
    ListLabel[i]->Caption = AStruct->Caption;
    ListLabel[i]->Alignment = AStruct->Alignment;
    ListLabel[i]->Parent = Panel;
    ListLabel[i]->ParentFont = true;

    if (MaxWidthLabel < ListLabel[i]->Width)
      MaxWidthLabel = ListLabel[i]->Width;
  }

  ListButton = new TButton *[CountButton];
  for (i = 0;  i < CountButton; i++) {
    AStruct = (ListCaption *) Button->Items[i];
    ListButton[i] = new TButton(this);
    ListButton[i]->Caption = AStruct->Caption;
    ListButton[i]->Default = True;
    ListButton[i]->ParentFont = true;
    ListButton[i]->ModalResult = 1;
    ListButton[i]->TabOrder = 1;
    ListButton[i]->Parent = this;
    ListButton[i]->OnClick = CloseMessage;
    Length = StringSize(ListButton[i]->Caption, Font);
    if (MaxWidthButton < Length)
      MaxWidthButton = Length;
  }

  // Отступы 20 пикселов от края
  MaxWidthLabel += 10;
  MaxWidthButton += 40;
  if (MaxWidthButton < 90)
    MaxWidthButton = 90;

  // Требуемая ширина окна
  // 20 - расстояние между кнопками
  int MaxWidth = (MaxWidthButton + 20) * CountButton;
  if (MaxWidth < MaxWidthLabel)
    MaxWidth = MaxWidthLabel;
  if (MaxWidth < Width)
    MaxWidth = Width;

  TWTMessage::Caption = Caption;

  // Построим панель в соответсвии с окном
  Panel->Left = 1;
  Panel->Top = 2;
  Panel->ClientWidth = MaxWidth + 10;

  // Корректируем размер надписей
  int CurrTop = 5;
  for (i = 0;  i < CountLabel; i++) {
    ListLabel[i]->Left = 5;
    ListLabel[i]->Top = CurrTop;
    ListLabel[i]->Width = MaxWidth;
    CurrTop += ListLabel[i]->Height;
  }
  Panel->ClientHeight = CurrTop + 5;
  CurrTop = Panel->Height + 5;

  // Размеры окна
  if (Width == -1)
    ClientWidth = Panel->Width + 2;
  else
    TWTMessage::Width = Width;

  // Отступ для кнопок
  int CurrLeft = (ClientWidth - (MaxWidthButton + 20) * CountButton) / 2 + 10;

  // Позииции кнопок
  for (i = 0;  i < CountButton; i++) {
    AStruct = (ListCaption *) Button->Items[i];
    ListButton[i]->Left = CurrLeft;
    ListButton[i]->Top = CurrTop;
    ListButton[i]->Width = MaxWidthButton;
    ListButton[i]->Height = ButtonHeight;

    CurrLeft += MaxWidthButton + 20;
  }
  CurrTop += ButtonHeight;

  if (Height == -1)
    ClientHeight = CurrTop + 2;
  else
    TWTMessage::Height = Height;

  Position = poScreenCenter;
  FormStyle= fsMDIChild;

  // Ожидаем выбор
  ShowModal();

  DEL(ListLabel);
  DEL(ListButton);
  return Choice;
}
//---------------------------------------------------------------------
void _fastcall TWTMessage::FOnResize(TObject *Sender) {
  if (!Button) return;
  if (WindowState== wsMaximized) {
    Panel->Left= ClientWidth/2- Panel->Width/2;
    Panel->Top= ClientHeight/2- (Panel->Height+ StringSize("A", Font, 1) + 8)/2;

    int CurrLeft =(ClientWidth - (MaxWidthButton + 20) * Button->Count)/ 2 + 10;

    for (int i = 0;  i < Button->Count; i++) {
      ListButton[i]->Left = CurrLeft;
      ListButton[i]->Top = Panel->Top+ Panel->Height+ 5;
      CurrLeft +=MaxWidthButton  + 20;
    }
  }
/*  if (WindowState== wsNormal) {
    Panel->Left= 1;
    Panel->Top= 2;

    int CurrLeft =(ClientWidth - (MaxWidthButton + 20) * Button->Count)/ 2 + 10;
    for (int i = 0;  i < Button->Count; i++) {
      ListButton[i]->Left = CurrLeft;
      ListButton[i]->Top = Panel->Top+ Panel->Height+ 5;
      CurrLeft +=MaxWidthButton  + 20;
    }
  }
*/}
//---------------------------------------------------------------------
void _fastcall TWTMessage::CloseMessage(TObject *Sender) {
  for (int i = 0;  i < Button->Count; i++) {
    if (ListButton[i] == Sender) Choice = i;
  }
}
//---------------------------------------------------------------------
