//---------------------------------------------------------------------------
#ifndef ScriptFormH
#define ScriptFormH

//#include "Form.h"
//#include "MainForm.h"
//#include "pascal.h"
#include <comctrls.hpp>
#include "form.h"
//---------------------------------------------------------------------------
//class TWTMainForm;
class TWTTPC;

class TWTScriptForm : public TWTMDIWindow
{
__published:
  void __fastcall SetSize(int x,int y);
private:
  void __fastcall FShowCurrentLine();
public:
//  TWTMainForm *MainForm;
  TWTTPC *TPComp;
  TMemo *SrcText;
  TMemo *ResultText;
  TStatusBar *StatusBar;
  bool IsChange;
  AnsiString CurrentFile;
  void *FTable[100];
  void __fastcall Test(int& s,int a);
  void __fastcall RunProcess(TObject *Sender);
  void __fastcall Save(TObject *Sender);
  void __fastcall SaveFile(AnsiString Path);
  void __fastcall Step(TObject *Sender);
  void __fastcall Compile(TObject *Sender);
  void __fastcall RunTo(TObject *Sender);
  void __fastcall New(TObject *Sender);
  void __fastcall Open(TObject *Sender);
  void __fastcall Inspect(TObject *Sender);
  int __fastcall OpenFile(AnsiString Path);
  void __fastcall KeyDown(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
  __fastcall TWTScriptForm(TComponent* Owner);
  __fastcall ~TWTScriptForm();
};
#endif
