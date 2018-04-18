//---------------------------------------------------------------------
// ядро пакета (базы SETUP, FILTER и др. должны находитьс€ в каталоге запуска)
//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "SetQuery.h"
TZPgSqlDatabase *TWTSetupQuery::Database = NULL;
TZPgSqlTransact *TWTSetupQuery::Transaction = NULL;
//---------------------------------------------------------------------
// функции класса TWTSetupQuery
//---------------------------------------------------------------------
_fastcall TWTSetupQuery::TWTSetupQuery(TComponent *owner, TStringList *SQL) : TWTQuery(owner) {
  DataSource->DataSet = this;

  Database->Database = "Setup";
 // Database->Transaction = Transaction;

  CachedUpdates = false;
  RequestLive = true;
  UpdateObject = NULL;

  // «адаем запрос
  SetSQLSelect(SQL);
}
//---------------------------------------------------------------------
_fastcall TWTSetupQuery::~TWTSetupQuery() {
}
//---------------------------------------------------------------------
void TWTSetupQuery::ApplyUpdates() {
}
//---------------------------------------------------------------------

