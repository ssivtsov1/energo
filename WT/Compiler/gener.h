#if !defined(__GENER_H)
#define __GENER_H

#include <stdio.h>
#include <classes.hpp>
#include "lexem.h"
#include "ustack.h"
#include "tstack.h"
#include "vstack.h"
#include "sstack.h"
#include "gramm.h"
#include "pascal.h"
//#include "MainForm.h"

class TWTVarsList;
class TWTFuncList;
class TWTTPC;
class TWTValue;
//class TTMainForm;

typedef TCustomStack<TWTValue*> TWTValueStack;
typedef TWTValue* __fastcall (__closure *TWTMultiVarsEvent)(TStringList *MultiVars);
typedef int __fastcall (__closure *TWTSetMultiVarsEvent)(TStringList *MultiVars,TWTValue *Value);
typedef TWTValue* __fastcall (__closure *TWTFuncEvent)(AnsiString FuncName,int ParamCount,TWTValue *Param[100]);
typedef TWTValue* __fastcall (__closure *TWTMultiFuncEvent)(TStringList *MultiVars,int ParamCount,TWTValue *Param[100]);
typedef int __fastcall (__closure *TWTCheckParamsEvent)(TStringList *MultiVars,int ParamCount,TWTValueStack *Param);

class TWTGenerator
{
 public:
  int ErrorCode;
//  TTMainForm *MainForm;
  FILE *f;
  bool RepFlag;
  char FName[20];
  int BEBalance;
  int BEStop;
  bool StopFlag;
  TWTGenerator(char *);
  void Init();
  TWTTPC *TPComp;
  ~TWTGenerator();
  int Generate(int, TCustomStack<TWTLexema> *);
  TTypeStack * TypeStack;
  TVarStack * VarStack;
  TIntStack * OperStack;
  TCustomStack<AnsiString> * IDStack;
  TCustomStack<TWTValue*> *ValueStack;
  TCustomStack<Variant> * ParamStack;
  TStringList *MultiVars;
  TWTValue *ReturnValue;  //значение последнего вычесленного выражения
  TIntStack * PCountStack;
  TWTVarsList *VarsList;
  TWTFuncList *FuncList;
  int LabelCount;
  int VarCount;
  int RecCount;
  AnsiString ResultVar;
  TWTMultiVarsEvent OnMultiVars;
  TWTSetMultiVarsEvent OnSetMultiVars;
  TWTFuncEvent OnDoFunction;
  TWTMultiFuncEvent OnDoMultiFunction;
  TWTCheckParamsEvent OnCheckParams;
};

class TWTValue {
public:
  __fastcall ~TWTValue(void);
  __fastcall TWTValue(AnsiString Name,Variant *Val,int X,int Y);
  AnsiString VarName;
  Variant *Value;
  int XDim;
  int YDim;
};

class TWTVarsList: public TList {
public:
  __fastcall ~TWTVarsList(void);
  void AddVar(AnsiString Name,Variant *Value,int X,int Y);
  void AddVar(TWTValue *Var){Add(Var);};
  TWTValue *ValByName(AnsiString Name);
  TWTValue *VarByName(AnsiString Name);
  TWTValue* GetVar(int Index);
  int ErrorCode;
};

TWTValue *SimpleVal(Variant& Value);

class TWTFunc {
public:
  int ErrorCode;
  AnsiString FuncName;
  int ParamCount;  //количество параметров (255 без проверки количества -
  //все параметры однотипные, тип определяется первым параметром)
  int ParamType[100];  //типы параметров функции
  void AddParam(int Type) {
    ParamType[ParamCount]=Type;
    ParamCount++;
  }
};

class TWTFuncList: public TList {
public:
  TWTGenerator *Generator;
  int ErrorCode;
  __fastcall virtual ~TWTFuncList(void);
  __fastcall virtual TWTFuncList(TWTGenerator *Gnt);
  void __fastcall ReadFromFile(AnsiString FName);
  void __fastcall SaveToFile(AnsiString FName);
  TWTFunc *FuncByName(AnsiString Name);
  TWTFunc *AddFunc(AnsiString Name,int PCount);
  void DelFunc(AnsiString Name);
  TWTFunc *GetFunc(int Index);
  TWTValue *DoFunction(AnsiString Name,TCustomStack<TWTValue*> *Param);
};
#endif
