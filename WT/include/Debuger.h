//---------------------------------------------------------------------------
#ifndef DebugerH
#define DebugerH

#define FUNC_DESC_POINT 7
#define START_POINT FUNC_DESC_POINT+4


//---------------------------------------------------------------------------
//����� ��� ������� �������� ���� ������������� ��������������� � �������������
//  ��� � ������������� ��� ������������ ����

class TWTCommand;

class TWTVMDebuger: public TObject {
protected:
  TList* Commands;
public:
  int StopCommand;
  bool ShowComment;
  virtual __fastcall TWTVMDebuger();
  virtual __fastcall ~TWTVMDebuger();
  TWTCommand* __fastcall AddCommand(int Cod,AnsiString Name,AnsiString Comment,AnsiString P1="",AnsiString P2="",AnsiString P3="",AnsiString P4="",AnsiString P5="");
  //� CommandList ���������� ����������� Code
  void __fastcall Process(TStringList* CommandList,void* Code);
  //�������� ��� ������� �� ������� ��������, ��������������� �������
  //  �������� ������� - int;string;char - ����� ������� ���� int � �����
  //  ����������� - string � char
  void __fastcall GetFNames(AnsiString Stamp,TStringList* FuncList,void* Code);
  //�������� ��� ������� �� ������� ��������
  void __fastcall GetAllFNames(TStringList* FuncList,void* Code);
  //��������� �������� ������� �� ������� �������� �� �������
  void __fastcall ProcessFNames(int Num,TStringList* FuncList,void* Code);
  //�������� �������� ������� �� �� ����� ������� �� ������� ��������
  int __fastcall FOffsetByName(AnsiString Name,void* Code);
  //���-�� ������� � �������
  int __fastcall GetFCount(void* Code);

  TWTCommand* __fastcall CommandByCod(int Cod);
};


class TWTCommand: public TObject {
public:
  virtual __fastcall TWTCommand();
  void __fastcall SetParam(AnsiString Type);
  int Cod;
  AnsiString CommandName;
  AnsiString Comment;
  AnsiString Params[10];
  int ParamsCount;
  bool ShowAddress;
};

#endif
