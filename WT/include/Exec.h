//---------------------------------------------------------------------------
#ifndef ExecH
#define ExecH

#include "VMachine.h"
#include "pascal.h"
//---------------------------------------------------------------------------

class TWTExec: public TObject {
protected:
  TWTTPC* FCompiler;
  TWTVMachine* FVM;
  void* FCode;
  int FSize;
public:
  __property TWTTPC* Compiler = {read=FCompiler};
  __property TWTVMachine* VM = {read=FVM};

  virtual __fastcall TWTExec();
  virtual __fastcall ~TWTExec();

  //��������� ������
  int __fastcall Execute(TStrings* Text);
  void __fastcall Execute();
  void __fastcall Execute(void* Code,int Size);
  //��������������� ������
  int __fastcall Compile(TStrings* Text);
  //���������� ������� ���� ��������� ������������������ �������
  void* __fastcall GetCode(int& Size);
  //������������ ������� ����
  void __fastcall Include(int Offset,void* Code);
  int __fastcall Include(int Offset,TStrings* Text);
  //������� include
  void __fastcall RemoveInclude(int Offset);
  //�������� ������ ������� �� �������� ��������������� �������
  void __fastcall GetFNames(TStringList* Names,AnsiString Match="");
  //������� ������ ������
  int __fastcall GetDataSize();

  //��������� � ������������� ���������� � ������ Name � ����� Type
  //   � ������� ���������� �������������. ��a����� ���������� ���������� �� ��������� Value
  //   (��������� �������� ������ ������ �����). �������� ���� x ���������� ���� int, �� �
  //   value ���������� ���������� &x.
  //   ���� Offset ����� -1 ��������� ���������� �� ������� ���������� ������ ���
  //   ���� ������������ �������� �������� ����������
  int __fastcall AddDeclaration(AnsiString Name,AnsiString Type,void* Value,int Offset=-1);
  void __fastcall RemDeclaration(AnsiString Name);
  //������ � ������� ���������� VM ��������� �� ������� ������ �������������� ���������
  //  � ��������� �� ����� *.cch
  void __fastcall AddFunction(AnsiString Name,AnsiString Type,void* Pointer);

};


#endif
 