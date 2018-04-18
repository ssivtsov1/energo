//---------------------------------------------------------------------------
#ifndef VMachineH
#define VMachineH

#include <forms.hpp>
#include "debuger.h"

//---------------------------------------------------------------------------
int vtoi(int Adr);
int VoidToInt(void *p);
void *IntToVoid(void *s);

struct VMFHeader {
  int ID;
  char Info[50];
  int CodeSize;
  int DataSize;
  int CRC;
};

class TMyForm;

class TWTVMachine: public TComponent {
private:
  void *ComTable[256];
  void *Code;
  void *Data;
  void *IP;
  VMFHeader Header;
  int State;
  int StepMode;
  int SavedData[256];
  int Index;
  void Init();
  void CallAllFunction();
  TMyForm *FF;
  int Example;
public:
  TWTVMDebuger* Debuger;
  void* Result;
  AnsiString ResultType;
  float ResAsFloat;
  int ResAsInt;
  char ResAsChar;
  AnsiString ResAsString;
  int ProgramOver;
  int LineNumber;
  int StopLine;
  void *GetForm();
  void *FTable[100];
  virtual __fastcall TWTVMachine(TComponent *AOwner);
  __fastcall ~TWTVMachine();
  void Init(AnsiString File);
  void Init(void *UserCode,void *UserData);
  void Init(void *UserCode,int CodeSize);
  void Execute();
  void Run();
  void Next();
  void RunTo(int Line);
};

class TMyForm: public TForm {
public:
  __fastcall TMyForm(Classes::TComponent* AOwner);
  void __fastcall SetSize(int x,int y);
};



#endif
