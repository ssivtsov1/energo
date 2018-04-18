//---------------------------------------------------------------------------
#ifndef ScriptFormH
#define ScriptFormH

//#include "Form.h"
//#include "MainForm.h"
//#include "pascal.h"
#include "exec.h"
#include <comctrls.hpp>
#include "..\\editor\\richedit.h"
//---------------------------------------------------------------------------
//class TWTMainForm;
class TWTTPC;

class TWTScriptForm : public TForm
{
public:
  TWTScriptForm* TestField;
__published:
  void __fastcall SetSize(int x,int y);
  AnsiString __fastcall Sum(int x,int y);
  void __fastcall ShowStr(AnsiString Str);
  void __fastcall ShowInt(int Value);
  void __fastcall ShowFloat(float Value);

  AnsiString __fastcall IntToStrI(int Value);
  AnsiString __fastcall FloatToStrI(float Value);
  int __fastcall StrToIntI(AnsiString Value);
  float __fastcall StrToFloatI(AnsiString Value);
private:
  void __fastcall FShowCurrentLine();
public:
//  TWTMainForm *MainForm;
  TWTExec* Exec;
  void *CodeData;
  int AllSize;
  int CSize;
  TWTVMachine *VM;
  TWTTPC *TPComp;
  TWTRichEdit *SrcText;
  TRichEdit *DText;
  TMemo *ResultText;
  TStatusBar *StatusBar;
  bool IsChange;
  AnsiString CurrentFile;
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
