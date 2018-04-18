//---------------------------------------------------------------------
//
//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "About.h"
//---------------------------------------------------------------------
// функции класса TWTAboutBox
//---------------------------------------------------------------------
_fastcall TWTAboutBox::TWTAboutBox(TWinControl *owner) : TWTForm(owner) {
  ActiveControl = OKButton;
  BorderStyle = bsDialog;
  Caption = "О программе";
  ClientHeight = 218;
  ClientWidth = 298;
  Position = poScreenCenter;

  Panel = new TPanel(this);
  Panel->Left = 8;
  Panel->Top = 8;
  Panel->Width = 281;
  Panel->Height = 161;
  Panel->BevelOuter = bvLowered;
  Panel->TabOrder = 0;
  Panel->Parent = this;

  ProgramIcon = new TImage(this);
  ProgramIcon->Left = 8;
  ProgramIcon->Top = 8;
  ProgramIcon->Width = 113;
  ProgramIcon->Height = 81;
  ProgramIcon->Parent = Panel;
//  ProgramIcon->Picture->LoadFromResourceName(0,"TXO_WIN2");

  ProductName = new TLabel(this);
  ProductName->Left = 120;
  ProductName->Top = 16;
  ProductName->Width = 68;
  ProductName->Height = 13;
  ProductName->Caption = "Product Name";
  ProductName->Parent = Panel;

  Version = new TLabel(this);
  Version->Left = 120;
  Version->Top = 40;
  Version->Width = 35;
  Version->Height = 13;
  Version->Caption = "Version";
  Version->Parent = Panel;

  Copyright = new TLabel(this);
  Copyright->Left = 8;
  Copyright->Top = 90;
  Copyright->Width = 44;
  Copyright->Height = 13;
  Copyright->Caption = "Copyright";
  Copyright->Parent = Panel;

  Comments = new TLabel(this);
  Comments->Left = 8;
  Comments->Top = 120;
  Comments->Width = 49;
  Comments->Height = 13;
  Comments->Caption = "Comments";
  Comments->WordWrap = True;
  Comments->Parent = Panel;

  OKButton = new TButton(this);
  OKButton->Left = 120;
  OKButton->Top = 178;
  OKButton->Width = 65;
  OKButton->Height = 33;
  OKButton->Caption = "OK";
  OKButton->Default = True;
  OKButton->ModalResult = 1;
  OKButton->TabOrder = 1;
  OKButton->Parent = this;
  OKButton->OnClick = Close;
}
//---------------------------------------------------------------------
_fastcall TWTAboutBox::~TWTAboutBox() {
}
//---------------------------------------------------------------------


