//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "main.h"
#include "RepSaldo.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TPrintSald *PrintSald;
extern PACKAGE TMainForm *MainForm;

//---------------------------------------------------------------------------
__fastcall TPrintSald::TPrintSald(TComponent* Owner)
        : TForm(Owner)
{

  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
  }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("????  ", true, ActivateMenu));



}
//---------------------------------------------------------------------------

void _fastcall TPrintSald::ActivateMenu(TObject *Sender) {
  if (Enabled) Show();
}

void __fastcall TPrintSald::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 int i = 7;

  while (i < MainForm->WindowMenuItem->Count &&
    MainForm->WindowMenuItem->Items[i] != WindowMenu) {
    i++;
  }
  if (MainForm->WindowMenuItem->Count && MainForm->WindowMenuItem->Items[i] == WindowMenu)
    MainForm->WindowMenuItem->Delete(i);
  // ≈сли окон больше нет - удал€ем разделитель
  if (MainForm->WindowMenuItem->Count == 8){
    MainForm->WindowMenuItem->Delete(7);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->RemoveToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
  };
/////////////////////
Action = caFree;


}
//---------------------------------------------------------------------------






void __fastcall TPrintSald::QRDBText1Print(TObject *sender,
      AnsiString &Value)
{
int i=0;        
}
//---------------------------------------------------------------------------


void __fastcall TPrintSald::FormActivate(TObject *Sender)
{
 int i=1;        
}
//---------------------------------------------------------------------------

void __fastcall TPrintSald::RepDocAfterPreview(TObject *Sender)
{
   PrintSald->Query1->Active=false;
}
//---------------------------------------------------------------------------




