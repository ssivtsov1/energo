//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "TWTCompatable.h"
#include "Main.h"
//#include "MainForm.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

//#pragma resource "*.dfm"

//---------------------------------------------------------------------------
__fastcall TfTWTCompForm::TfTWTCompForm(TComponent* Owner,bool regmenu)
        : TForm(Owner)
{ //TMainForm *MainForm;
  NoDeactivate=false;
  if (!regmenu) return;

  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
  }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem(Caption.c_str(), true, ActivateMenu));
}
//---------------------------------------------------------------------------
void __fastcall TfTWTCompForm::FormClose(TObject *Sender,TCloseAction &Action)
{
    TfTWTCompForm::NoDeactivate = false;
    // –азрешеаем/запрещаем активизацию окон
  bool MDIEnabled = true;
  // ¬ MDIChildren окна расположены в последовательности активизации
  // (первыми идут деактивизированные последними)
  for (int i = 0; i < MainForm->MDIChildCount; i++) {
    if (MDIEnabled) {
      MainForm->MDIChildren[i]->Enabled = true;
      if (CheckParent(MainForm->MDIChildren[i],"TWTMDIWindow"))
      {  if (((TWTMDIWindow *)MainForm->MDIChildren[i])->NoDeactivate) {
         MDIEnabled = false;
        }
      }
      if (CheckParent(MainForm->MDIChildren[i],"TfTWTCompForm")){
        if (((TfTWTCompForm *)MainForm->MDIChildren[i])->NoDeactivate) {
         MDIEnabled = false;
        }
      }
     }
      else {
       MainForm->MDIChildren[i]->Enabled = false;
      }
 }


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
  /////////////

  Action = caFree;
}
//---------------------------------------------------------------------------
void _fastcall TfTWTCompForm::ActivateMenu(TObject *Sender) {
  if (Enabled) Show();
}

void __fastcall TfTWTCompForm::ShowAs(AnsiString ID,int flag_modal){
  FormStyle=fsMDIChild;
  this->ID=ID;
  if (flag_modal<0)
      flag_modal=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadInteger("Variables","FlagModal",1);
       if (flag_modal) {
     TfTWTCompForm::NoDeactivate = true;
     // –азрешеаем/запрещаем активизацию окон
      bool MDIEnabled = true;
      // ¬ MDIChildren окна расположены в последовательности активизации
      // (первыми идут деактивизированные последними)
      for (int i = 0; i < MainForm->MDIChildCount; i++) {
        if (MDIEnabled) {
            MainForm->MDIChildren[i]->Enabled = true;
             if (CheckParent(MainForm->MDIChildren[i],"TWTMDIWindow"))
                   {  if (((TWTMDIWindow *)MainForm->MDIChildren[i])->NoDeactivate) {
                            MDIEnabled = false;
                       }
             }
             if (CheckParent(MainForm->MDIChildren[i],"TfTWTCompForm")){
                if (((TfTWTCompForm *)MainForm->MDIChildren[i])->NoDeactivate) {
                   MDIEnabled = false;
                 }
             }
        }
        else {
           MainForm->MDIChildren[i]->Enabled = false;
        }
      }
};

if (Screen->ActiveForm->WindowState!=wsMaximized)
 {
        WindowState=wsNormal;
 }
  else
 {
        WindowState=wsMaximized;
 };
}


//---------------------------------------------------------------------

