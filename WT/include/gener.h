#if !defined(__GENER_H)
#define __GENER_H

#include <stdio.h>
#include <classes.hpp>
#include <dir.h>
#include <dos.h>
#include "lexem.h"
#include "ustack.h"
#include "tstack.h"
#include "vstack.h"
#include "sstack.h"
#include "gramm.h"
#include "VMachine.h"
#include "Debuger.h"
//#include "pascal.h"
//#include "MainForm.h"

class TWTVarsList;
class TWTValue;
class TWTTypesList;
//class TTMainForm;

class TWTGenerator
{
 protected:
  int RecursionCount;  //сигнализирует в функции определяется переменная или в теле программы
  int StackSpace;   //место которое необходимо отвести для локальных данных функции в стеке
  int CurFTable;
  int FLineNumber;
  int Stay;
  int __fastcall LoadClass(AnsiString FileName);
  void __fastcall ChangeFTable(int Value);
  TWTVarsList* VarsList;
  //в зависимости от RecursionCount резервирует место для переменной в стеке или
  //   в локальной памяти. Возвращает смещение переменной.
  int __fastcall ReservData(int Length=4);
 public:
  AnsiString ThisVar;
  AnsiString ResultType;
  TWTTypesList *TypesList;
  TWTVarsList* ExtVarsList;
  void *Code;
  void *Data;
  void *Init;
  void *DataIP;
  void *CodeIP;
  void *InitIP;
  int CodeSize;
  int DataSize;
  int ErrorCode;
  int LineNumber;
  AnsiString Line;
  bool Debug;
  FILE *f;
  bool RepFlag;
  char FName[20];
  TWTGenerator(char *);
  void InitGen();
  ~TWTGenerator();
  int Generate(int, TCustomStack<TWTLexema> *);
  void *GetCodeData(int& Point,int& CodeSize); //возвращает объедененный сегмент кода и данных в Point, и размер
    //   части кода - CodeSize. Код расположен Point + 0, а данные Point + CodeSize. Вызывающий функцию сам
    //   заботится о разрушении этого указателя. Функция возрвращает общий размер выделенной памяти в AllSize
  void* GetCode(int& Size);
  //вернуть размер данных
  int __fastcall GetDataSize();
  TTypeStack * TypeStack;
  TVarStack * VarStack;
  TCustomStack<int> * OperStack;
  TCustomStack<TWTValue*> * TempStack;
  int LabelCount;
  int VarCount;
  int RecCount;
  int BEBalance;
  int NewMemory(int CSize,int DSize);
  void WriteByte(char Val);
  void WriteInt(int Val);
  void WriteFloat(float Val);
  void WriteStr(AnsiString Val);
  void WriteByteToInit(char Val);
  void WriteIntToInit(int Val);
  void SaveToFile(AnsiString FileName);
  int ConvertType(AnsiString From,AnsiString To);
  AnsiString __fastcall InspectValue(AnsiString Name);
  TWTValue * AddExternalVar(AnsiString Name,int Offset,AnsiString Type);
  //включить в интерпретатор функции, описанные в другом сегменте кода
  void __fastcall Include(int Offset,void* Code);
  //исключить из интерпретатора функции, описанные в указанном сегменте кода
  void __fastcall RemoveInclude(int Offset,void* Code);
};

struct TWTPROPERTY {
  int SetType;
  int GetType;
  int SetOffs;
  int GetOffs;
};

class TWTValue: public TObject {
public:
  __fastcall TWTValue(AnsiString Name,int Offset,AnsiString Type);
  void __fastcall AddDim(int Size);
  AnsiString ValName;
  int Offset; //смещение функции или переменной

  //для массивов переменных
  int Dims[255];
  int DimsCount;
  //-----------------------

  TWTVarsList *Params;
  bool IsFastCall; //не используется
  int MethodType; // 2 - локальная или глобальная функция, 0 - переменная

  //указатель на смещение структуры используемой в конструкторе, считывается из
  //  cch файла (подробности у разработчика), для глобальных функций - указатель на
  //  смещение присоединенных сегментов кода в FTable
  int ClassPoint;

  AnsiString Type;
  int AddressType; //тип адресации (см. мануал)
  int BEBalance;
  TWTPROPERTY Property;
};

class TWTVarsList: public TList {
public:
  __fastcall ~TWTVarsList(void);
  void AddVar(AnsiString Name,int Offset,AnsiString Type);
  void AddVarToEnd(AnsiString Name,int Offset,AnsiString Type);
  void AddVar(TWTValue *Var){Add(Var);};
  void DelVar(AnsiString Name);
  void DelVar(int Offset);
  TWTValue *VarByName(AnsiString Name);
  TWTValue* GetVar(int Index);
  int ErrorCode;
};

class TWTType: public TObject {
public:
  __fastcall TWTType(AnsiString Name,int Size);
  __fastcall ~TWTType();
  void AddField(TWTValue *Field);
  void AddFunc(TWTValue *Func);
  int FTable;
  AnsiString Name;
  int Size;
  TWTVarsList* Fields;
  TWTVarsList* Funcs;
  AnsiString Parent;
};

class TWTTypesList: public TList {
public:
  __fastcall ~TWTTypesList(void);
  void AddType(AnsiString Name,int Size);
  void AddType(TWTType *Var){Add(Var);};
  TWTType *TypeByName(AnsiString Name);
  TWTType* GetType(int Index);
};
#endif
