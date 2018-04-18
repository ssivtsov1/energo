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

  //выполнить скрипт
  int __fastcall Execute(TStrings* Text);
  void __fastcall Execute();
  void __fastcall Execute(void* Code,int Size);
  //откомпилировать скрипт
  int __fastcall Compile(TStrings* Text);
  //возвращает сегмент кода последего откомпилированного скрипта
  void* __fastcall GetCode(int& Size);
  //присоединяет сегмент кода
  void __fastcall Include(int Offset,void* Code);
  int __fastcall Include(int Offset,TStrings* Text);
  //удалить include
  void __fastcall RemoveInclude(int Offset);
  //получить список функций из инклудов удовлетворяющий условию
  void __fastcall GetFNames(TStringList* Names,AnsiString Match="");
  //вернуть размер данных
  int __fastcall GetDataSize();

  //добавляет в интерпретатор переменную с именем Name и типом Type
  //   в таблицу переменных интепретатора. Знaчение переменной содержится по указателю Value
  //   (значимыми являются первые четыре байта). Например если x переменная типа int, то в
  //   value необходимо передавать &x.
  //   Если Offset равно -1 добаление происходит по первому свободному адресу при
  //   этом возвращается реальное смещение переменной
  int __fastcall AddDeclaration(AnsiString Name,AnsiString Type,void* Value,int Offset=-1);
  void __fastcall RemDeclaration(AnsiString Name);
  //Запись в таблицу указателей VM указателя на функцию класса предварительно описанную
  //  и считанную из файла *.cch
  void __fastcall AddFunction(AnsiString Name,AnsiString Type,void* Pointer);

};


#endif
 