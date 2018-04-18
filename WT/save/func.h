//----------------------------------------------------------------------------
// ������� ����������
//----------------------------------------------------------------------------
#ifndef FunctionH
#define FunctionH
#include <vcl\Dialogs.hpp>
#include <inifiles.hpp>
#include <registry.hpp>
#include <fcntl.h>
#include<io.h>                            

#include "Query.h"
//----------------------------------------------------------------------------
// delete �������������� ��������� � NULL
//----------------------------------------------------------------------------
#define DEL(x) {x != NULL ? delete x : ShowMessage("������ ������������! ������� �������� ������� ���������."); x = 0;}
//----------------------------------------------------------------------------
//class TWTValue;

//���������� ������ SQL �������� ��� �������� ����� ������� (�������) Source
void __fastcall GetCreateSQL(TDBDataSet* Source, AnsiString TableName,TStringList *SQLList);

//���������� SQL ������ ��� �������� ����� ������� (�������) ���������� � Source
//� ��������� �� ������� ��������������� ������������� � Source
AnsiString __fastcall GetCreateSQL(TDBGrid* Source, AnsiString TableName);

//��������� ���� �� � ������ Class ������ � ������ ClassName
bool CheckParent(TClass Class,AnsiString ClassName);
bool CheckParent(TObject *Class,AnsiString ClassName);

// ���������� ������ � ���� �����������
// ���� ���� �� ������ ���������� 0
// ����� ��� ���������� ��������� ������ ����� � ���� �� ������ 500��
// ��������������� ��� (��� ����������� �� ������ �����)
int SaveMessage(AnsiString Str = "", AnsiString Str1 = "", AnsiString Str2 = "", AnsiString Str3 = "",
    AnsiString Str4 = "", AnsiString Str5 = "", AnsiString Str6 = "", AnsiString Str7 = "");


TField* AddSimpleField(TDataSet* DataSet,AnsiString FName);

void Delay(int Value);
//�������� ������ ����� �� ini-�����
void UpdateIniFile(TMemIniFile* IniFile);
//���������� ���������� ������ � ini ����
Boolean FontToIni(TFont* Font,TMemIniFile* IniFile,AnsiString Section,AnsiString Ident);
//������ ���������� ������ �� ini �����
Boolean IniToFont(TFont* &Font,TMemIniFile* IniFile,AnsiString Section,AnsiString Ident);
// �������� �������� ����
TMenuItem *CreateMenuItem(char *caption, bool enabled = true,
    TNotifyEvent click = NULL, char *ID = "", char *ShortCut = "");
// �������� �������������� ������ � ����
TMenuItem *CreateSeparator();
// �������� ���������� ����
void ClearMenuItem(TMenuItem *MenuItem);
// ������� ����������� ���� ����
TPopupMenu* CreatePopup(TWinControl* owner, TMenuItem **Items, int Items_Size,
    AnsiString Name); //"PopupMenu");
//������������ �����
TField* DuplicateField(TField* Source,TDataSet* DataSet);

// ����� ���������
void Message(TStringList *mes);
void Message(AnsiString *mes);
void Message(AnsiString mes);
void Message(int mes);

// �������� ������� (������� ������������ ������ ���������� ���������)
void _fastcall ClassName(TObject *Sender);

//---------------------------------------------------------------------
// ���������� ������ ������ � ��������
// type
//   0 - Width
//   1 - Height
// ��� ������ ���������� -1
//---------------------------------------------------------------------
int StringSize(AnsiString String, TFont *Font, int type = 0);

//---------------------------------------------------------------------
// ������� ������ � ������
//---------------------------------------------------------------------
TDateTime _fastcall BOM(TDateTime Date);
TDateTime _fastcall EOM(TDateTime Date);
TDateTime _fastcall BOY(TDateTime Date);
TDateTime _fastcall EOY(TDateTime Date);

// �������������� ������ � ���� � ��������� �� ������������
// Mes - ��������� � ������
//  "" - ��������� �� ��������� (���������� -1)
//  NULL - "������������ ����: ..."
//  "..." - ��������� ������������
TDateTime _fastcall StrToDate(AnsiString DateTime, AnsiString Mes);

// ������� ���� � ������� YY � ������ 2000
TDateTime _fastcall SetCentury(TDateTime *DateTime);
TDateTime _fastcall SetCentury(TDateTime DateTime);
TDateTime _fastcall SetCentury(AnsiString DateTime);
void _fastcall SetCentury(TField* Sender);
//---------------------------------------------------------------------
// ����, ������, �����, ���������� �������� � ������� ��� SQL �������
//---------------------------------------------------------------------
AnsiString ToStrSQL(TDateTime Date);
AnsiString ToStrSQL(AnsiString Str);
AnsiString ToStrSQL(float Float);
AnsiString ToStrSQL(double Float);
AnsiString ToStrSQL(int Float);
AnsiString ToStrSQL(unsigned int Float);
AnsiString ToStrSQL(bool Bool);
AnsiString ToStrSQL(TWTField *Field);

//----------------------------------------------------------------------------
// �������������� ������/������� � boolean �� ������� ������� ("T", "t", �� 0 - 1)
//----------------------------------------------------------------------------
int atob(char Ch);
int atob(char *Str);
int atob(AnsiString Str);

//----------------------------------------------------------------------------
// ���������� ������ ����������� ������� / ����� ��������� Chr ��
// ���������� �������. ���� ������ ������ ��� ��������� ������
// ���������� �������� ������ (�� ��������).
// ���� ������ Chr �� ������ ��������� ���������.
AnsiString PadL(AnsiString Str, int Length, char Chr = ' ');
// ��������� ������ ������ �������
AnsiString PadL0(AnsiString Str, int Length);
// ���������� ����� ����������� ������� ��������� Chr
AnsiString PadL(int Num, int Length, char Chr = ' ');
// ���������� ����� ����������� ������� ������
AnsiString PadL0(int Num, int Length);
AnsiString PadL0(long int Num, int Length);
AnsiString PadL0(double Num, int Length);
AnsiString PadR(AnsiString Str, int Length, char Chr = ' ');

// ����������
// ndec - ���������� ������ ����� �������
double Round(double value, int ndec = 2);

//----------------------------------------------------------------------------
// ������ ����
// ��� ����� ���������� true, ��� ������ false
// Str - ������ ���������
// DateTime - �������� �� ��������� (��� ����� �������� ��������� ����)
// ��� ������� Esc ���������� false
//----------------------------------------------------------------------------
bool GetDate(AnsiString Str, TDateTime* DateTime);

// �������� �������� �� ������� ����
int MkDirPath(AnsiString Path);

//����������� ���� � �������� "��" / "���"
int Ask(AnsiString Label);


//������� ��� ���������� �� ���������� ��������������

/*TWTValue *Array(int X,int Y);
TWTValue *CopyArray(TWTValue *Dest,TWTValue *Src);
TWTValue *ArrayOfStr(int X,int Y);
TWTValue *ArrayOfNum(int X,int Y);
TWTValue *AADD(TWTValue *Src,Variant& Elem);  //��������� ����� ������� � ����� �������
TWTValue *ACLONE(TWTValue* Src);       //��������� ��������� ��� ����������� ������
TWTValue* ACOPY(TWTValue* Src,TWTValue* Dest);        //�������� �������� ������ ������� � ������
TWTValue *ADEL(TWTValue* Src,int Index);         //������� ������� �������
TWTValue *AFILL(TWTValue* Src,Variant& Value);        //��������� ������ �������� ���������
TWTValue* AINS(TWTValue* Src,int Index,Variant& Elem);         //������� ������� �� ��������� NIL � ������
int ASCAN(TWTValue* Src,Variant& Elem);        //������������� ������ �� ���������� � �������� ���������
TWTValue *ASIZE(TWTValue* Src,int X,int Y);        //����������� ��� ��������� ������ �������
TWTValue* ASORT(TWTValue* Src);        //��������� ������
int AT(AnsiString Src,AnsiString SubStr);          //���������� ������� ������� ��������� ���������
Variant ATAIL(TWTValue* Src);        //���������� ������� ������� � ���������� �������
AnsiString CDOW(AnsiString Date);         //����������� �������� ���� � ���������� �������� ��� ������
AnsiString CHR(int Value);          //����������� ��� ASCII � ��� ���������� ��������
AnsiString CMONTH(AnsiString Date);       //����������� ���� � ���������� �������� ������
int DAY(AnsiString Date);          //���������� ����� ��� � ���� �����
int DOW(AnsiString Date);          //����������� �������� ���� � �������� �������� ��� ������
AnsiString DTOS(AnsiString Date);         //����������� �������� ���� � ������ �������� ������� ��������
int ISALPHA(AnsiString Value);      //����������, �������� �� ����� ����� ������ � ������ ������
int ISDIGIT(AnsiString Value);      //����������, �������� �� ������ ������ � ������ ������
int ISLOWER(AnsiString Value);      //����������, �������� �� ������ ������ �������� ������
int ISUPPER(AnsiString Value);      //����������, �������� �� ������ ������ ��������� ������
AnsiString LEFT(AnsiString Src,int Size);         //���������� ���������, ������� � ������� ������� � ������
AnsiString LTRIM(AnsiString Src);        //������� ��������� ������� �� ���������� ������
int MONTH(AnsiString Date);        //���������� �� �������� ���� ����� ������
int RAT(AnsiString Src,AnsiString SubStr);          //���������� ������� ������� ��������� ���������
AnsiString RIGHT(AnsiString Src,int Size);        //���������� ���������, ������� � ������ ������� �������
AnsiString RTRIM(AnsiString Src);        //������� �������� ������� �� ���������� ������.
AnsiString SPACE(int Number);        //���������� ������ ��������
AnsiString STRTRAN(AnsiString Src,AnsiString Find,AnsiString Replace);      //���� � �������� ������� � ���������� ������ ��� memo-����
int YEAR(AnsiString Date);         //����������� �������� ���� � ����� ���� � �������� ����
AnsiString ALLTRIM(AnsiString Src);       //������� ������� � ���������� ������� � ������ ��������
AnsiString SUBSTR(AnsiString Src,int Start,int End);       //�������� ��������� �� ���������� ������
int Ask(AnsiString Label);             //����������� ���� � �������� "��" / "���"
TWTValue *ArrayOfUnique(int X,int Y);         //��������� ������� �� ���������� ���������
TWTValue *DelimLine(AnsiString Src,AnsiString Delims);       //��������� ������ �� ������ �������� �������� �����
  */
#endif

