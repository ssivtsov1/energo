//---------------------------------------------------------------------------
#ifndef TableH
#define TableH
//---------------------------------------------------------------------------
#include "include\ZEOS\ZPgSqlCon.hpp"
#include "include\ZEOS\ZPgSqlTr.hpp"


#include <vcl\DBTables.hpp>
#include <vcl\DBGrids.hpp>

#include "Func.h"
//#include "Fields.h"
#include "List.h"
//----------------------------------------------------------------------------
class TWTTable : public TZPgSqlTable {
protected:
  AnsiString FDefaultFilter;
  void __fastcall SetDefaultFilter(AnsiString Value);
public:
  TDataSource *DataSource;
  static TZPgSqlDatabase *Database;
  static TZPgSqlTransact *Transaction;

  __property AnsiString DefaultFilter  = {read=FDefaultFilter, write=SetDefaultFilter};

//  TUpdateSQL *UpdateSQL;
  // ��������� ����� � ������� � � DBGrid �� ������
 // TWTField **ListField;
  TWTList* ListField;

  _fastcall virtual TWTTable(TComponent* owner, AnsiString Name);
  _fastcall virtual ~TWTTable();

  //������� ��� ������ � ������
  TWTField *AddField(AnsiString FName);
  TWTField *AddLookupField(AnsiString FName,AnsiString KeyField,AnsiString LookupTableName,AnsiString LookupFName,AnsiString LookupKeyFields="ID",AnsiString LookFilt=" ");
  TWTField *AddLookupField(AnsiString FName,AnsiString KeyField,TZDataset* LookupDataSet,AnsiString LookupFName,AnsiString LookupKeyFields="ID",AnsiString LookFilt=" ");
  TWTField* AddCalcField(AnsiString FName,TWTDSEvent TCalcExpr);
  // ���������� ��� ������������� ������ BDE
  void _fastcall UpdateErrorHandler(TZDataset *DataSet,
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

  // ���������� ��������� �� ���� � ������� Index � �������
  TWTField *GetTField(int Index);
  // ���������� ��������� �� ���� � ������ FieldName � �������
  // ��� ���������� ���� ���������� NULL
  TWTField *GetTField(AnsiString FieldName);

  void _fastcall FOnChange(TField* Sender);

  // ���������� ������ (��� ���������� ������� ������)
  void SetFilter(AnsiString Filter);

  // ��������� ���������
  void virtual ApplyUpdates();

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

  int isApplyUpdates;

  void __fastcall FOnUserPostError(TDataSet* DataSet, EDatabaseError* E, TDataAction &Action);

  // ������� ��������� �������
 // TField* AddSimpleField(TWTTable* Table,AnsiString FName);
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

};
//----------------------------------------------------------------------------
#endif
