//----------------------------------------------------------------------------
// ���� ������ (���� SETUP, FILTER � ��. ������ ���������� � �������� �������)
//----------------------------------------------------------------------------
#ifndef SetQueryH
#define SetQueryH
//----------------------------------------------------------------------------
#include <vcl\Controls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Graphics.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Windows.hpp>
#include <vcl\System.hpp>
#include <vcl\DBTables.hpp>

#include "Func.h"
//#include "Fields.h"
#include "Query.h"

//----------------------------------------------------------------------------
// ������ � ��������� ���� ������
//----------------------------------------------------------------------------
class TWTSetupQuery : public TWTQuery {
public:
  static TZPgSqlDatabase *Database;
  static TZPgSqlTransact *Transaction;

  _fastcall virtual TWTSetupQuery(TComponent* owner, TStringList *SQL = NULL);
  _fastcall virtual ~TWTSetupQuery();
  void virtual ApplyUpdates();
};
//----------------------------------------------------------------------------
#endif
