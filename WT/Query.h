//----------------------------------------------------------------------------
#ifndef FieldsH
#define FieldsH
//----------------------------------------------------------------------------
#include <vcl\DBTables.hpp>
#include <vcl\DBGrids.hpp>
#include "include\ZEOS\ZPgSqlCon.hpp"
#include "include\ZEOS\ZPgSqlQuery.hpp"
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"
#pragma link "ZUpdateSql"
class TWTFixedVariables;
class TWTFixedVariable;
class TWTField;
class TWTQuery;
//class TWTTable;
#include "Func.h"
#include "List.h"

// ������� ������������ ��� ��������� �������
typedef void __fastcall (__closure *TTEvent)();
typedef void __fastcall (__closure *TWTDSEvent)(TDataSet* Sender);
typedef void __fastcall (__closure *TTEventField)(TWTField *Field);
typedef TTEvent* __fastcall (__closure *TTEventEvent)(TTEvent *Event);
//----------------------------------------------------------------------------
// ������
//----------------------------------------------------------------------------
class TWTList;

class TWTQuery : public TZPgSqlQuery {
protected:
  AnsiString FDefaultFilter;
  void __fastcall SetDefaultFilter(AnsiString Value);
public:
  __property AnsiString DefaultFilter  = {read=FDefaultFilter, write=SetDefaultFilter};
  TDataSource *DataSource;
  static TZPgSqlDatabase *Database;
  static TZPgSqlTransact *Transaction;
  TZUpdateSql *UpdateSQL;
  // ��������� ����� � ������� � � DBGrid �� ������
  TWTList *ListField;

  //������� ��� ������ � ������
  TWTField *AddField(AnsiString FName);
  TWTField *AddLookupField(AnsiString FName,AnsiString KeyField,AnsiString LookupTableName,AnsiString LookupFName,AnsiString LookupKeyFields="ID",AnsiString LookFilt=" ");
  TWTField *AddLookupField(AnsiString FName,AnsiString KeyField,TZDataset* LookupDataSet,AnsiString LookupFName,AnsiString LookupKeyFields="ID",AnsiString LookFilt=" ");

  _fastcall virtual TWTQuery(TComponent* owner, TStringList *SQL = NULL);
  _fastcall virtual ~TWTQuery();

  // ���������� ��� ������������� ������ BDE
  void _fastcall UpdateErrorHandler(TZCustomPgSqlDataset *DataSet,
    EDatabaseError *E, TUpdateKind UpdateKind,
    Db::TUpdateAction &UpdateAction) { return; };
  // ��������� ��������� ������� ������
  bool isModified();
  bool isInserted();

  // ���������� ��������� �� ���� � ������� Index � �������
  TField *GetField(int Index);
  // ���������� ��������� �� ���� � ������ FieldName � �������
  // ��� ���������� ���� ���������� NULL
  TField *GetField(AnsiString FieldName);

  void __fastcall FOnUserPostError(TDataSet* DataSet, EDatabaseError* E, TDataAction &Action);

  // ���������� ��������� �� ���� � ������� Index � �������
  TWTField *GetTField(int Index);
  // ���������� ��������� �� ���� � ������ FieldName � �������
  // ��� ���������� ���� ���������� NULL
  TWTField *GetTField(AnsiString FieldName);

  // ������ ������ SQL �������
  void SetSQLSelect(TStringList *SQL = NULL);
  void SetSQLUpdate(TStringList *SQL = NULL);
  void SetSQLInsert(TStringList *SQL = NULL);
  void SetSQLDelete(TStringList *SQL = NULL);

  // ������� SQL ������� ��� �����������
  // ���� FieldWhere == NULL - ������������ ������ ���� � �������
  // (��� ������ ���� ����������)
  void SetSQLModify(AnsiString BaseName, TStringList *FieldWhere = NULL,
        TStringList *FieldNotModify = NULL,
        bool isUpdate = true, bool isInsert = true, bool isDelete = true);

  // ���������� ������ (��� ���������� ������� ������)
  void SetFilter(AnsiString Filter);

  // ��������� ���������
 // void virtual ApplyUpdates();
   void  ApplyUpdates();
  // �������� ���������
  void virtual CancelUpdates();
  // ������� / ����������� ������
  // ������������ ������� ������������ ������ � ������ ��������� ����������
  // (��� ��������� ������ �������)
  void virtual Open();
  // ������� ������
  void virtual Close();

  // ����������� ������� ������������ �������������
  TWTDSEvent AfterCancel;
  TWTDSEvent AfterClose;
  TWTDSEvent AfterDelete;
  TWTDSEvent AfterEdit;
  TWTDSEvent AfterInsert;
  TWTDSEvent AfterOpen;
  TWTDSEvent AfterPost;
  TWTDSEvent AfterScroll;
  TWTDSEvent BeforeCancel;
  TWTDSEvent BeforeClose;
  TWTDSEvent BeforeDelete;
  TWTDSEvent BeforeEdit;
  TWTDSEvent BeforeInsert;
  TWTDSEvent BeforeOpen;
  TWTDSEvent BeforePost;
  TWTDSEvent BeforeScroll;

private:
  TBookmark BMark;
  bool OpenFirst;

  int isApplyUpdates;

  // ������ ������ SQL �������
  void SetSQL(AnsiString *Operator, TStringList *SQL = NULL);
  // ������� ��������� �������
  void _fastcall FAfterCancel(TDataSet *DataSet);
  void _fastcall FAfterPost(TDataSet *DataSet);
  void _fastcall FAfterClose(TDataSet *DataSet);
  void _fastcall FAfterDelete(TDataSet *DataSet);
  void _fastcall FAfterEdit(TDataSet *DataSet);
  void _fastcall FAfterInsert(TDataSet *DataSet);
  void _fastcall FAfterOpen(TDataSet *DataSet);
  void _fastcall FAfterScroll(TDataSet *DataSet);
  void _fastcall FBeforeCancel(TDataSet *DataSet);
  void _fastcall FBeforePost(TDataSet *DataSet);
  void _fastcall FBeforeClose(TDataSet *DataSet);
  void _fastcall FBeforeDelete(TDataSet *DataSet);
  void _fastcall FBeforeEdit(TDataSet *DataSet);
  void _fastcall FBeforeInsert(TDataSet *DataSet);
  void _fastcall FBeforeOpen(TDataSet *DataSet);
  void _fastcall FBeforeScroll(TDataSet *DataSet);

  void _fastcall FOnChange(TField* Sender);
};

//----------------------------------------------------------------------------
// ����
// ������������� ��������� ����
// ��������� �� ���� � TWTQuery
// ��������� �� ������� � TWTDBGrid (���� ����)
// ��������� ��� �������� �������
//----------------------------------------------------------------------------
class TWTField : public TComponent {
private:
  int FPrecision;
  void __fastcall SetPrecision(int Value);

  bool SelectedColumn;
  TTEventField OnHelp;
  TTEvent OnEdit;
  void _fastcall OnValidateData(TField* Sender);
  void _fastcall IntOnSetText(TField* Sender, AnsiString Text);
  void _fastcall IntOnGetText(TField* Sender, AnsiString &Text,bool DisplayText);
  TFieldNotifyEvent OnValidate;
  TFieldNotifyEvent SaveOnValidate;
  TFieldGetTextEvent OnGetText;
  TFieldGetTextEvent SaveOnGetText;
  TFieldSetTextEvent OnSetText;
  TFieldSetTextEvent SaveOnSetText;
  AnsiString Constraint;
  AnsiString ConstraintErrorMessage;
  AnsiString DisplayLabel;
  AnsiString DefaultExpression;
  bool ReadOnly;
  int Width;
  TStringList *PickList;

public:
  TDataSet* LookupDS;
  TWTField *LookField;
  __property int Precision = {read=FPrecision, write=SetPrecision};

  bool IsUnique;
  AnsiString UniqueError;
  AnsiString TableName;
  bool IsRange;
  Variant MinValue;
  Variant MaxValue;
  AnsiString RangeError;
  bool IsFixedVariables;
  TWTFixedVariables* FixedVariables;
  bool IsValue;
  Variant Value;
  bool IsRequired;
  AnsiString RequiredError;
  bool IsFill;
  char FillChar;
  int FillSize;
  TWTField *ExpFieldLookUpFilter;
  AnsiString FieldLookUpFilter;
  AnsiString Name;
  TField *Field;
  // ��������� �� ������� � DBGrid
  TColumn *Column;
  // ���������� ������
  void SetOnHelp(TTEventField FOnHelp = NULL);
  // ����������� �� �������������� ����
  void SetOnEdit(TTEvent FOnEdit = NULL);
  // ����������� �� �������������� ����
  void SetOnValidate(TFieldNotifyEvent FOnValidate = NULL);
  //����������(�����) ������������ ���� (���������� ��� ������)
  int SetUnique(AnsiString ErrorString,AnsiString TableName = "", AnsiString FieldName = "");
  void UnsetUnique();
  //����������(�����) ����������� � ������������ �������� ���� (���������� ��� ������)
  int SetRange(Variant& Min,Variant& Max,AnsiString ErrorString);
  void UnsetRange();
  //����������(�����) ����� ������������� �������� ��� ���� (���������� ��� ������)
  int AddFixedVariable(AnsiString DBValue,AnsiString RealValue);
  void UnsetFixedVariables();
  //����������(�����) �������� �� ���������
  int SetDefValue(Variant& Value);
  void UnsetDefValue();
  //����������(�����) ������������� ����
  int SetRequired(AnsiString ErrorString);
  void UnsetRequired();
  //����������(�����) ���������� ����
  int SetFill(int FillSize,char FillChar);
  void UnsetFill();

  void SetOnGetText (TFieldGetTextEvent FOnGetText = NULL);

  void SetOnSetText (TFieldSetTextEvent FOnSetText = NULL);
  // �������� ���� �� ���������
  void SetDefault(AnsiString Default);
  // ������� ������������ ����
  void SetDisplayLabel(AnsiString DisplayLabel);
  // ����������� �� �������� ����
  void SetConstraint(AnsiString Constraint, AnsiString ErrorMessage);
  // ���������� ReadOnly ��� ������������ (��� ���� �� ��������� ����� ��������,
  // ��� ��������� Query->Fields->ReadOnly �������������� ������ �� ��������)
  void SetReadOnly(bool ReadOnly = true);
  void SetWidth(int Width);
  void SetDefaultExpression(AnsiString DefaultExpression);

  void SaveProperty();
  void SetProperty(TField *Field = NULL);

  AnsiString GetFieldName() { return Name; };
  TTEventField GetOnHelp() { return OnHelp; };
  TTEvent GetOnEdit() { return OnEdit; };
  TFieldNotifyEvent GetOnValidate() { return OnValidate; };
  AnsiString GetConstraint() { return Constraint; };
  AnsiString GetConstraintErrorMessage() { return ConstraintErrorMessage; };
  AnsiString GetDisplayLabel() { return DisplayLabel; };
  AnsiString GetDefaultExpression() { return DefaultExpression; };
  bool GetReadOnly() { return ReadOnly; };
  int GetWidth() { return Width; };

  _fastcall virtual TWTField(TComponent* Owner, TField *Field);
  _fastcall virtual ~TWTField();

  TTEventField OnChange;
};
//----------------------------------------------------------------------------
//����� ��� ������������� ������������� �������� ��� ������ TWTField

class TWTFixedVariable: public TObject {
public:
  AnsiString DBValue;
  AnsiString RealValue;
};

class TWTFixedVariables: public TList {
public:
  TWTFixedVariable* GetVariable(int Index);
  int __fastcall Add(AnsiString DBValue,AnsiString RealValue);
  __fastcall ~TWTFixedVariables();
};



#endif
