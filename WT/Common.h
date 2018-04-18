//---------------------------------------------------------------------------
#ifndef CommonH
#define CommonH
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
#include "ComCtrls.hpp"
#include <ToolWin.hpp>

//---------------------------------------------------------------------------

class TWTToolButton;
class TWTToolBar;

class TWTToolBar: public TToolBar {
protected:
  TImageList* ImageList;
public:
  AnsiString ID;
  bool Active;
  void __fastcall DisableButton(AnsiString ID);
  void __fastcall HideButton(AnsiString ID);
  void __fastcall ShowButton(AnsiString ID);
  void __fastcall EnableButton(AnsiString ID);
  //TCoolBand* __fastcall GetCoolBand();
  TWTToolButton* _fastcall AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick);
  virtual __fastcall TWTToolBar(TComponent* AOwner);
  virtual __fastcall ~TWTToolBar();
};

class TWTToolButton: public TToolButton {
public:
  AnsiString ID;
  virtual __fastcall TWTToolButton(TComponent* AOwner);
  virtual __fastcall ~TWTToolButton();
};


class TWTCoolBar: public TCoolBar {
protected:
  TList* BarsList;
  void __fastcall ShowBarsList(TObject *Sender);
  void __fastcall UpdateToolBar(TObject* Sender);
  //void __fastcall PaintWindow();
public:

  //�������� ������� TCoolBand � ������������ � �������� �� ToolBar ����������
  void __fastcall AlignSize(TWTToolBar* ToolBar);
  //��������� ToolBar
  void __fastcall AddToolBar(TWTToolBar* ToolBar);

  void __fastcall RemoveToolBar(TWTToolBar* ToolBar);
  virtual __fastcall TWTCoolBar(TComponent* AOwner);
  virtual __fastcall ~TWTCoolBar();
};

#endif