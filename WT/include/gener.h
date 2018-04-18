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
  int RecursionCount;  //������������� � ������� ������������ ���������� ��� � ���� ���������
  int StackSpace;   //����� ������� ���������� ������� ��� ��������� ������ ������� � �����
  int CurFTable;
  int FLineNumber;
  int Stay;
  int __fastcall LoadClass(AnsiString FileName);
  void __fastcall ChangeFTable(int Value);
  TWTVarsList* VarsList;
  //� ����������� �� RecursionCount ����������� ����� ��� ���������� � ����� ���
  //   � ��������� ������. ���������� �������� ����������.
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
  void *GetCodeData(int& Point,int& CodeSize); //���������� ������������ ������� ���� � ������ � Point, � ������
    //   ����� ���� - CodeSize. ��� ���������� Point + 0, � ������ Point + CodeSize. ���������� ������� ���
    //   ��������� � ���������� ����� ���������. ������� ����������� ����� ������ ���������� ������ � AllSize
  void* GetCode(int& Size);
  //������� ������ ������
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
  //�������� � ������������� �������, ��������� � ������ �������� ����
  void __fastcall Include(int Offset,void* Code);
  //��������� �� �������������� �������, ��������� � ��������� �������� ����
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
  int Offset; //�������� ������� ��� ����������

  //��� �������� ����������
  int Dims[255];
  int DimsCount;
  //-----------------------

  TWTVarsList *Params;
  bool IsFastCall; //�� ������������
  int MethodType; // 2 - ��������� ��� ���������� �������, 0 - ����������

  //��������� �� �������� ��������� ������������ � ������������, ����������� ��
  //  cch ����� (����������� � ������������), ��� ���������� ������� - ��������� ��
  //  �������� �������������� ��������� ���� � FTable
  int ClassPoint;

  AnsiString Type;
  int AddressType; //��� ��������� (��. ������)
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
