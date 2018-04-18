//----------------------------------------------------------------------------
#ifndef QueryH
#define QueryH
//----------------------------------------------------------------------------
#include <vcl\DBTables.hpp>
#include <vcl\DBGrids.hpp>
#include "include\ZEOS\ZPgSqlCon.hpp"
#include "include\ZEOS\ZPgSqlQuery.hpp"
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
//class TWTQuery;
//class TWTTable;
class TWTField;
#include "Func.h"
#include "List.h"
// Функции пользователя для обработки событии
typedef void __fastcall (__closure *TTEvent)();
//typedef void __fastcall (__closure *TWTDSEvent)(TDataSet* Sender);
typedef void __fastcall (__closure *TTEventField)(TWTField *Field);
//typedef TTEvent* __fastcall (__closure *TTEventEvent)(TTEvent *Event);



 
