//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Log.h"
#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZTransact"
#pragma resource "*.dfm"
TfLog *fLog;
//---------------------------------------------------------------------------
__fastcall TfLog::TfLog(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
/*  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
  }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("SQL лог", true, ActivateMenu));
  */
  ZMonitor1->Transaction=TWTTable::Transaction;
  NoDeactivate=true;
}
//---------------------------------------------------------------------------
void __fastcall TfLog::ZMonitor1MonitorEvent(AnsiString Sql,
      AnsiString Result)
{
if(Memo1!=NULL)  Memo1->Lines->Add(Sql);
}
//---------------------------------------------------------------------------
void __fastcall TfLog::FormClose(TObject *Sender, TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);       
/*  int i = 7;
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
  */
  /////////////
  ZMonitor1->OnMonitorEvent=NULL;
  Action = caFree;

}
//---------------------------------------------------------------------------
/*
void _fastcall TfLog::ActivateMenu(TObject *Sender) {
  if (Enabled) Show();
}
  */
//---------------------------------------------------------------------------
