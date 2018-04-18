//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Query.h"
#include "MainForm.h"
//---------------------------------------------------------------------

// К базе подключаться будем только один раз
TZPgSqlDatabase *TWTQuery::Database =NULL;
TZPgSqlTransact *TWTQuery::Transaction =  NULL;


//---------------------------------------------------------------------
// функции класса TWTQuery
//---------------------------------------------------------------------
_fastcall TWTQuery::TWTQuery(TComponent *owner, TStringList *SQL) : TZPgSqlQuery(owner) {
  // Создаем элементы (обязательно сначала все создаем, а потом меняем свойства)
  OpenFirst=true;
  //SetDatabase(Database);
  //setTransact(Transaction);

   Database=Database;
   Transaction=Transaction;
   DataSource = new TDataSource(this);
   UpdateSQL = new TZUpdateSql(this);
   DataSource->DataSet = this;
   isApplyUpdates = 0;
   CachedUpdates = true;
   RequestLive = true;
   UpdateObject = UpdateSQL;
   TZDataset::SetDatabase(Database);
   TZDataset::SetTransact(Transaction);

   //Transaction=Transaction;
   // Проверяем только модифицированные поля
  //UpdateMode = upWhereChanged;

  // Функции обработки событии в TQuery
  TZPgSqlQuery::AfterCancel = FAfterCancel;
  TZPgSqlQuery::AfterClose = FAfterClose;
  TZPgSqlQuery::AfterDelete = FAfterDelete;
  TZPgSqlQuery::AfterEdit = FAfterEdit;
  TZPgSqlQuery::AfterInsert = FAfterInsert;
  TZPgSqlQuery::AfterOpen = FAfterOpen;
  TZPgSqlQuery::AfterPost = FAfterPost;
  TZPgSqlQuery::AfterScroll = FAfterScroll;
  TZPgSqlQuery::BeforeCancel = FBeforeCancel;
  TZPgSqlQuery::BeforeClose = FBeforeClose;
  TZPgSqlQuery::BeforeDelete = FBeforeDelete;
  TZPgSqlQuery::BeforeEdit = FBeforeEdit;
  TZPgSqlQuery::BeforeInsert = FBeforeInsert;
  TZPgSqlQuery::BeforeOpen = FBeforeOpen;
  TZPgSqlQuery::BeforePost = FBeforePost;
  TZPgSqlQuery::BeforeScroll = FBeforeScroll;
  TZPgSqlQuery::OnPostError=FOnUserPostError;
  //TZPgSqlQuery::Options << doQuickOpen;

  TZPgSqlQuery::Options <<doSqlFilter;
 // TZPgSqlQuery::Options >>doRefreshAfterPost;
 // TZPgSqlQuery::Options >>doRefreshBeforeEdit;
  // Обработчики событии определяемые пользователем
  // (на всякий случай инициализируем NULL)
  AfterCancel = NULL;
  AfterClose = NULL;
  AfterDelete = NULL;
  AfterEdit = NULL;
  AfterInsert = NULL;
  AfterOpen = NULL;
  AfterPost = NULL;
  AfterScroll = NULL;
  BeforeCancel = NULL;
  BeforeClose = NULL;
  BeforeDelete = NULL;
  BeforeEdit = NULL;
  BeforeInsert = NULL;
  BeforeOpen = NULL;
  BeforePost = NULL;
  BeforeScroll = NULL;

  // Задаем запрос
  SetSQLSelect(SQL);
  ListField=NULL;
 //Timer->Enabled= false;
 //TimerOn=false;
}
//---------------------------------------------------------------------
_fastcall TWTQuery::~TWTQuery() {
  Close();
}
//---------------------------------------------------------------------
// Состояние базы
//---------------------------------------------------------------------
bool TWTQuery::isModified() {
  return State == dsEdit; //Modified;
}
//---------------------------------------------------------------------
bool TWTQuery::isInserted() {
  return State == dsInsert;
}
//---------------------------------------------------------------------
// Установить строку SQL запроса
//---------------------------------------------------------------------
void TWTQuery::SetSQL(AnsiString *Operator, TStringList *SQL) {
  TStrings *QuerySQL;
  if (Operator->UpperCase() == "SELECT") {
    QuerySQL = TZPgSqlQuery::Sql;
  }
  else {
    if (Operator->UpperCase() == "UPDATE") {
      QuerySQL = UpdateSQL->ModifySql;
    }
    else {
      if (Operator->UpperCase() == "INSERT") {
        QuerySQL = UpdateSQL->InsertSql;
      }
      else {
        if (Operator->UpperCase() == "DELETE") {
          QuerySQL = UpdateSQL->DeleteSql;
        }
        else {
          ShowMessage("Ошибка программиста! " + *Operator + " не определен.");
          return;
        }
      }
    }
  }
  if (QuerySQL) {
    QuerySQL->Clear();
    if (SQL != NULL) {
      for (int i = 0; i < SQL->Count; i++)
        QuerySQL->Add(SQL->Strings[i]);
    }
  }
}
//---------------------------------------------------------------------
void TWTQuery::SetSQLSelect(TStringList *SQL) {
  AnsiString Operator = "Select";
  SetSQL(&Operator, SQL);
}
//---------------------------------------------------------------------
void TWTQuery::SetSQLUpdate(TStringList *SQL) {
  AnsiString Operator = "Update";
  SetSQL(&Operator, SQL);
}
//---------------------------------------------------------------------
void TWTQuery::SetSQLInsert(TStringList *SQL) {
  AnsiString Operator = "Insert";
  SetSQL(&Operator, SQL);
}
//---------------------------------------------------------------------
void TWTQuery::SetSQLDelete(TStringList *SQL) {
  AnsiString Operator = "Delete";
  SetSQL(&Operator, SQL);
}
//---------------------------------------------------------------------
void TWTQuery::SetSQLModify(AnsiString BaseName, TStringList *FieldWhere, TStringList *FieldNotModify,
  bool isUpdate, bool isInsert, bool isDelete) {
int i, j;
  if (State == dsInactive) {
    ShowMessage("Невозможно создать запросы для не открытого запроса");
    return;
  }
  if (FieldWhere == NULL) {
    FieldWhere = new TStringList();
    FieldWhere->Add(GetField(1)->FieldName);
  }
  TStringList *FieldList = new TStringList();
  for(i = 0; i < FieldCount; i++)
    if (GetField(i)->FieldKind!=fkLookup)
     FieldList->Add(GetField(i)->FieldName);
  if (FieldNotModify != NULL) {
    for(i = 0; i < FieldNotModify->Count; i++) {
      j = 0;
      while(j < FieldList->Count &&
        FieldList->Strings[j] != FieldNotModify->Strings[i]) j++;
      if (j < FieldList->Count) {
        FieldList->Delete(j);
      }
      else {
        ShowMessage("Поля " + FieldNotModify->Strings[i] + " нет в запросе.");
      }
    }
  }
  // Формируем запросы
  // Обновление
  TStringList *SQL = new TStringList();
  if (isUpdate) {
    SQL->Clear();
    SQL->Add("update " + BaseName + " ");
    SQL->Add("set");
    for (i = 0; i < FieldList->Count - 1; i++) {
      SQL->Add("  " + FieldList->Strings[i] + " = :" + FieldList->Strings[i] + ",");
    }
    SQL->Add("  " + FieldList->Strings[FieldList->Count - 1] + " = :" +
      FieldList->Strings[FieldList->Count - 1] + " ");
    // Условие Where
    SQL->Add("where ");
    for (i = 0; i < FieldWhere->Count - 1; i++) {
      if (GetField(FieldWhere->Strings[i]))
        SQL->Add("  "+FieldWhere->Strings[i] + " = :OLD_" + FieldWhere->Strings[i] + " AND ");
      else
        ShowMessage("Поле " + FieldWhere->Strings[i] + " отсутствует в запросе");
    }
    if (GetField(FieldWhere->Strings[FieldWhere->Count - 1]))
      SQL->Add("  " + FieldWhere->Strings[FieldWhere->Count - 1] + " = :OLD_" +
        FieldWhere->Strings[FieldWhere->Count - 1]);
    else
      ShowMessage("Поле " + FieldWhere->Strings[FieldWhere->Count - 1] + " отсутствует в запросе");
    SetSQLUpdate(SQL);
  }

  // Вставка
  if (isInsert) {
    SQL->Clear();
    SQL->Add("insert into " + BaseName + " ");
    SQL->Add("(");
    for (i = 0; i < FieldList->Count - 1; i++) {
      SQL->Add("  " + FieldList->Strings[i] + ",");
    }
    SQL->Add("  " + FieldList->Strings[FieldList->Count - 1] + " ");
    SQL->Add(") values (");
    // Значения
    for (i = 0; i < FieldList->Count - 1; i++) {
      SQL->Add("  :"+FieldList->Strings[i] + ",");
    }
    SQL->Add("  :" + FieldList->Strings[FieldList->Count - 1] + " ");
    SQL->Add(")");
    SetSQLInsert(SQL);
  }

  // Удаление
  if (isDelete) {
    SQL->Clear();
    SQL->Add("delete from " + BaseName + " ");
    // Условие Where
    SQL->Add("where ");
    for (i = 0; i < FieldWhere->Count - 1; i++) {
      if (GetField(FieldWhere->Strings[i]))
        SQL->Add("  "+FieldWhere->Strings[i] + " = :OLD_" + FieldWhere->Strings[i] + " AND ");
    }
    if (GetField(FieldWhere->Strings[FieldWhere->Count - 1]))
      SQL->Add("  " + FieldWhere->Strings[FieldWhere->Count - 1] + " = :OLD_" +
        FieldWhere->Strings[FieldWhere->Count - 1]);
    SetSQLDelete(SQL);
  }                    

  DEL(SQL);
  DEL(FieldList);
}
//---------------------------------------------------------------------
// Текущие параметры запроса
//---------------------------------------------------------------------
TField *TWTQuery::GetField(int Index) {
  return Fields->Fields[Index];
}
//---------------------------------------------------------------------
TField *TWTQuery::GetField(AnsiString FieldName) {
  return FindField(FieldName);
}
//---------------------------------------------------------------------
TWTField *TWTQuery::GetTField(int Index) {
  return (TWTField*)ListField->Items[Index];
}
//---------------------------------------------------------------------
TWTField *TWTQuery::GetTField(AnsiString FieldName) {
  for (int i = 0; i < FieldCount; i++)
    if (((TWTField*)ListField->Items[i])->GetFieldName().UpperCase() == FieldName.UpperCase())
      return (TWTField*)ListField->Items[i];
  return NULL;
}
//---------------------------------------------------------------------
// Функции обработки событии
//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterCancel(TDataSet *DataSet) {
  if (AfterCancel) AfterCancel(this);
}
//---------------------------------------------------------------------

//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterClose(TDataSet *DataSet) {
  if (AfterClose)    {   AfterClose(this);};
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterDelete(TDataSet *DataSet) {
     ApplyUpdates();
   if (AfterDelete) AfterDelete(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterEdit(TDataSet *DataSet) {
  if (AfterEdit) AfterEdit(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterInsert(TDataSet *DataSet) {

  if (AfterInsert) AfterInsert(this);

}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterOpen(TDataSet *DataSet) {
  if (AfterOpen)
  { AfterOpen(this);
    First();
  }
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FAfterScroll(TDataSet *DataSet) {
  if (AfterScroll)
  {    AfterScroll(this);
  };
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeCancel(TDataSet *DataSet) {
  if (BeforeCancel) BeforeCancel(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforePost(TDataSet *DataSet) {
if ((State != dsInactive) & (State != dsInsert)){
    BMark = GetBookmark();
  };
    if (BeforePost) BeforePost(this);
     //ApplyUpdates();
    }
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeClose(TDataSet *DataSet) {
  if (BeforeClose) BeforeClose(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeDelete(TDataSet *DataSet) {
  if (BeforeDelete) BeforeDelete(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeEdit(TDataSet *DataSet) {
  if (BeforeEdit) BeforeEdit(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeInsert(TDataSet *DataSet) {
    BMark = GetBookmark();
  if (BeforeInsert) BeforeInsert(this);
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeOpen(TDataSet *DataSet) {
  if (BeforeOpen) { BeforeOpen(this);     };
}
//---------------------------------------------------------------------
void _fastcall TWTQuery::FBeforeScroll(TDataSet *DataSet) {
  if (BeforeScroll)
  { //ApplyUpdates();
      BeforeScroll(this);
  };
}
void _fastcall TWTQuery::FAfterPost(TDataSet *DataSet) {

if (AfterPost)

    { ApplyUpdates();
        AfterPost(this);
      //  ApplyUpdates();

    };
 if (State != dsInactive) {
     GotoBookmark(BMark);
  };

}
//---------------------------------------------------------------------
// Модификация базы
//---------------------------------------------------------------------
void TWTQuery::ApplyUpdates() {
  // Проверим не вызвали ли нас повторно
  // Иначе возникает Exception
  if (!isApplyUpdates) {
    // Флаг старта транзакции
    isApplyUpdates = 1;
    Transaction->StartTransaction();
    try {
           TZPgSqlQuery::ApplyUpdates();
            Transaction->Commit();    // on success, commit the changes;
    }
    catch (...) {
     Transaction->Rollback();  // on failure, undo the changes
      // Отменим последние изменения (переходим в режим редактирования ???)
      CancelUpdates();
     if (AfterCancel) AfterCancel(this);
      isApplyUpdates = 0;
      throw Exception("Ошибка изменения базы данных");
    }
    CommitUpdates();  // on success, clear the cache
    isApplyUpdates = 0;
  }
  else
  {int pr=1;}
}
//---------------------------------------------------------------------
void TWTQuery::CancelUpdates() {
  TZPgSqlQuery::CancelUpdates();
}
//---------------------------------------------------------------------
// Управление базой
//---------------------------------------------------------------------
void TWTQuery::SetFilter(AnsiString Fil) {
  // Устанавливаем закладку (установка/снятие фильтра
  // переводит указатель на начало запроса)
  TBookmark SavePlace;
  if (State != dsInactive) {
    SavePlace = GetBookmark();
  }

  try {
    if (Fil=="") Fil=DefaultFilter;
    else if (DefaultFilter != "") Fil= DefaultFilter + " and " + Fil;

    Filter = Fil;
    Filtered = Filter != NULL;
  } catch (...){};

  // Переходим на запись и удаляем закладку
  if (State != dsInactive) {

//    Open();
   try {
      if (BookmarkValid(SavePlace))
      GotoBookmark(SavePlace);
    }
    catch (...) {
      // Нет записи в запросе остаемся на первой
    }
    FreeBookmark(SavePlace);
  }
}

void __fastcall TWTQuery::SetDefaultFilter(AnsiString Value){
  FDefaultFilter=Value;
  Filter=Value;
  Filtered=true;
}


//---------------------------------------------------------------------
void TWTQuery::Open() {
// int OldCount = FieldCount;
int i, OldState = State;
 TBookmark SavePlace = NULL;

  if (State != dsInactive) {
    SavePlace = GetBookmark();
    for (int i = 0; i < FieldCount; i++) {
      ((TWTField*)ListField->Items[i])->SaveProperty();
    }
    Close();
  }

  if (!Sql)
    return;
  
  if (!OpenFirst) {
    if (FieldCount) Fields->Clear();
    while (ListField->Count) {
      ListField->Delete(0);
    }
  }
  if (ListField==NULL) ListField=new TWTList();
  FieldDefs->Update();
  OpenFirst=false;

  TField* FField;
  for (int x=0;x<FieldDefList->Count;x++) {
    FField=AddSimpleField(this,FieldDefList->FieldDefs[x]->Name);
    FField->FieldName=FieldDefList->FieldDefs[x]->Name;
    ListField->Add(new TWTField(this, FField));
  }

  for ( int x=0;x<ListField->Count;x++) {
    ((TWTField*)ListField->Items[x])->Field->DataSet=this;
  }
  
/*  if (!ListField) {
    while (FieldCount) Fields->Remove(Fields->Items[0]);
  } */
//  bool OpenFirst=false;
//  if (FieldCount==0) OpenFirst=true;

//  TQuery::Open();

/*  int x;
  TField* Field;
  if (ListField=NULL) ListField=new TWTList();
  for (x=0;x<ListField->Count;x++) {
    delete (TWTField*)ListField->Items[x];
  }

  ListField->Clear();*/

/*  if (ListField==NULL) ListField=new TWTList();
  if (OpenFirst) {
    for (x=0;x<FieldCount;x++) {
      ListField->Add(new TWTField(this,Fields->Fields[x]));
    }
  }*/

/*  TQuery::Close();

  for (x=0;x<ListField->Count;x++) {
    ((TWTField*)ListField->Items[x])->Field->DataSet=this;
  }    */

  try {
   Options  << doQuickOpen;
  Options  <<   doSqlFilter;
  TZPgSqlQuery::Options  << doQuickOpen; ////!!!!
  TZPgSqlQuery::Open();
    // TZPgSqlQuery::Options  << doQuickOpen;
  TZPgSqlQuery::Options  <<   doSqlFilter;
  Filtered=true;
  }
  catch (...) {
    Filtered=false;
  }
  // Переходим на запись и удаляем закладку
/*  if (SavePlace) {
    try {
      GotoBookmark(SavePlace);
    }
    catch (...) {
      // Нет записи в запросе остаемся на первой
    }
    FreeBookmark(SavePlace);
  }
  FreeBookmark(SavePlace);
*/
  // Создаем массив указателей на дополнительные пареметрыы полей
  /*if (OldState == dsInactive) {
    ListField = new TWTField*[FieldCount];
    for (i = 0; i < FieldCount; i++) {
      ListField[i] = new TWTField(Owner, Fields->Fields[i]);
    }
  }*/
    if (ListField==NULL) {
    ListField = new TWTList();
    for (i = 0; i < FieldCount; i++) {
      ListField->Add(new TWTField(Owner, Fields->Fields[i]));
    }
  }


  for (i = 0; i < FieldCount; i++) {
    if (Fields->Fields[i]->DataType == ftDate || Fields->Fields[i]->DataType == ftDateTime) {
      Fields->Fields[i]->EditMask = "90.90.0000";
    }
    //
    Fields->Fields[i]->OnChange = FOnChange;
    // Восстанавливаем Validate условия
    if (OldState != dsInactive) {
      ((TWTField*)ListField->Items[i])->SetProperty(Fields->Fields[i]);
    }
  }
}
#include "Table.h"
//---------------------------------------------------------------------
void _fastcall TWTQuery::FOnChange(TField* Sender) {
  if (Sender->DataType == ftDate || Sender->DataType == ftDateTime) {
    SetCentury(Sender);
  }
  if (Sender->DataSet) {
    if (CheckParent(Sender->DataSet,"TWTQuery")) {
      TWTField* Field=((TWTQuery*)Sender->DataSet)->GetTField(Sender->FieldName);
      if (Field->OnChange) Field->OnChange(Field);
    }
    if (CheckParent(Sender->DataSet,"TWTTable")) {
      TWTField* Field=((TWTTable*)Sender->DataSet)->GetTField(Sender->FieldName);
      if (Field->OnChange) Field->OnChange(Field);
    }
  }
}
//---------------------------------------------------------------------
void TWTQuery::Close() {
  // ApplyUpdates();
   TZPgSqlQuery::Close();
}

//Функции для работы с полями
TWTField *TWTQuery::AddField(AnsiString FName) {
//  if (FieldByName(FName)==NULL) {
    TField *FField=AddSimpleField(this,FName);
    if (ListField==NULL) ListField = new TWTList();
    FField->FieldName=FName.UpperCase();
    ListField->Add(new TWTField(this, FField));
//    FField->DataSet=this;
    return (TWTField*)ListField->Items[ListField->Count-1];
/*  }
  return NULL;*/
}

#include "Table.h"

TWTField *TWTQuery::AddLookupField(AnsiString FName,AnsiString KeyField,AnsiString LookupTableName,AnsiString LookupFName,AnsiString LookupKeyFields,AnsiString LookFilt){

   /*
  if (FieldByName(KeyField)==NULL) {
    ShowMessage("Поле <"+KeyField+"> "+"не существует");
    return NULL;
  }
     */
  TWTTable *Table;
  Table= new TWTTable(this,LookupTableName);
  Table->Database = Database;
  Table->SetFilter(LookFilt);
  Table->Active = true;

  TField *FField=AddSimpleField(Table,LookupFName);
  if (ListField==NULL) {
    ListField = new TWTList();
//    OpenFirst=true;
  }
  FField->FieldKind=fkLookup;
  FField->FieldName=FName.UpperCase();
  FField->LookupDataSet = Table;
  FField->LookupKeyFields =LookupKeyFields; //"id";
  FField->LookupResultField = LookupFName.UpperCase();
 // FField->LookUpFilter = LookFilt;
  FField->KeyFields = KeyField.UpperCase();
  FField->Lookup = true;
  ListField->Add(new TWTField(this, FField));
//  ((TWTField*)ListField->Items[ListField->Count-1])->LookupTable=Table;
//  FField->DataSet=this;
  return (TWTField*)ListField->Items[ListField->Count-1];
}


TWTField *TWTQuery::AddLookupField(AnsiString FName,AnsiString KeyField,TZDataset* LookupDataSet,AnsiString LookupFName,AnsiString LookupKeyFields,AnsiString LookFilt){
  TField *FField=AddSimpleField(LookupDataSet,LookupFName);
//  TField *FField=new TStringField(this);
//  FField->Size=256;
  if (ListField==NULL) ListField = new TWTList();
//  Table->Active = false;
  FField->FieldName=FName.UpperCase();
  FField->LookupDataSet = LookupDataSet;
  FField->LookupKeyFields = LookupKeyFields;
  FField->LookupResultField = LookupFName.UpperCase();
  FField->KeyFields = KeyField.UpperCase();
  FField->Lookup = true;
  FField->LookupCache=false;
  FField->FieldKind=fkLookup;
  ListField->Add(new TWTField(this, FField));
  FField->DataSet=this;
//  ((TWTField*)ListField->Items[ListField->Count-1])->LookupTable=((TWTTable*)LookupDataSet;
  return (TWTField*)ListField->Items[ListField->Count-1];
}

//---------------------------------------------------------------------
//класс для представления фиксированных значений для класса TWTField
int __fastcall TWTFixedVariables::Add(AnsiString DBValue,AnsiString RealValue){
  TWTFixedVariable *TV=new TWTFixedVariable();
  TV->DBValue=DBValue;
  TV->RealValue=RealValue;
  TList::Add(TV);
  return Count-1;
}

TWTFixedVariable* TWTFixedVariables::GetVariable(int Index){
  if ((Index>Count-1) || (Index<0)) return NULL;
  return (TWTFixedVariable*)Items[Index];
}

__fastcall TWTFixedVariables::~TWTFixedVariables(){
  for (int x=0;x<Count;x++) {
    delete Items[x];
  }
}

//---------------------------------------------------------------------
// функции класса TWTField
//---------------------------------------------------------------------
_fastcall TWTField::TWTField(TComponent* Owner, TField *Field) : TComponent (Owner) {
  OnChange=NULL;
  FPrecision=-100;
  TWTField::Field = Field;
  if (Field) Name = Field->FieldName;
  OnHelp = NULL;
  OnEdit = NULL;
  OnValidate=NULL;
  Width = 0;
  FixedVariables=NULL;
  ExpFieldLookUpFilter=NULL;
  FieldLookUpFilter=NULL;
  LookField=NULL;
  IsUnique=false;
  IsRange=false;
  IsFixedVariables=false;
  SelectedColumn = false;    // uncomment osa
 /*if (Field) TWTField::Field->OnValidate=OnValidateData;
  //SaveOnValidate=OnValidateData;

  //if (Field) TWTField::Field->OnGetText=IntOnGetText;
  //SaveOnGetText=IntOnGetText;
  //if (Field) TWTField::Field->OnSetText=IntOnSetText;
  //SaveOnSetText=IntOnSetText;*/

}
//---------------------------------------------------------------------
_fastcall TWTField::~TWTField() {
  if (FixedVariables) delete FixedVariables;
}

//---------------------------------------------------------------------
void TWTField::SetOnHelp(TTEventField FOnHelp) {
  OnHelp = FOnHelp;
  if (Column) {
    Column->ButtonStyle = OnHelp ? cbsEllipsis : cbsAuto;
    // Вычисляем размер строки с учетом [...] и корректируем ширину колонки
    // (только для текстовых полей)
    if (OnHelp && Field->DataType == ftString &&
        Column->Width < StringSize(Field->AsString, Column->Font) + 20) {
      Column->Width = StringSize(Field->AsString, Column->Font) + 20;
    }
  }
}
//---------------------------------------------------------------------
void TWTField::SetOnEdit(TTEvent FOnEdit) {
  OnEdit = FOnEdit;
}
//---------------------------------------------------------------------
void TWTField::SetOnValidate(TFieldNotifyEvent FOnValidate) {
  OnValidate = FOnValidate;
  // Устанавливаем и на поле в запросе
//  if (Field)
//    Field->OnValidate = OnValidate;
}

//---------------------------------------------------------------------
void _fastcall TWTField::OnValidateData(TField* Sender) {
  // В OnValidate значение менять нельзя, повторно вызывается OnValidate

  if ((Field->DataSet->State!=dsInsert) && (Field->DataSet->State!=dsEdit)) return;

   TZPgSqlQuery* QueryTmp;
   //TZPgSqlDatabase *Database;
   //TZPgSqlTransact *Transaction;
   //TZPgSqlTransact *Transact;
  TLocateOptions Options;
  AnsiString S=Sender->DisplayText;
  TZDataset* DataSet;
  AnsiString FName;
  QueryTmp=new TWTQuery(this);
  //QueryTmp=new TZPgSqlQuery(this);
  //QueryTmp->Database=Database;
  //QueryTmp->Transaction=Transaction;

  if (OnValidate)
    OnValidate(Sender);

  if (Field->Lookup) {
//  if (Field->AsInteger!=0)
    if (!Field->LookupDataSet->Locate(Field->LookupResultField,Field->AsVariant,Options))
      throw Exception("Значение введенное в поле ("+Field->DisplayLabel +") отсутствует в справочнике");
  }
  else {
    for (int x=0;x<Field->DataSet->Fields->Count;x++) {
      if (Field->DataSet->Fields->Fields[x]->KeyFields==Field->FieldName) {
        DataSet=(TZDataset*)Field->DataSet->Fields->Fields[x]->LookupDataSet;
        FName=Field->DataSet->Fields->Fields[x]->LookupKeyFields;
         //DataSet->Refresh();
        if (!DataSet->Locate(FName,Field->AsVariant,Options))
         throw Exception("Значение введенное в поле ("+Field->DisplayLabel +") отсутствует в справочнике");
      }
    }
  }

  if (IsUnique) {
    QueryTmp->Sql->Add(AnsiString(" SELECT COUNT(*) FROM ") + TableName);
    QueryTmp->Sql->Add(AnsiString(" WHERE ")+Field->FieldName+" =" + ToStrSQL(S));/* + " and " + Field->FieldName+" <> " + ToStrSQL(AnsiString(Field->Value)))*/;
    QueryTmp->Open();
    int NR=0;
//    if (Sender->DataSet->State==dsInsert) NR=0;
    if (QueryTmp->Fields->Fields[0]->AsInteger>NR)
      throw Exception(UniqueError);
    delete QueryTmp;
  }

  if (IsRange) {
    if ((Sender->AsInteger < MinValue )||(Sender->AsInteger > MaxValue)) {
       if (RangeError=="")
         throw Exception("Значение \""+Sender->FieldName+"\" должно быть между "+MinValue+" и "+MaxValue);
       else throw Exception(RangeError);
    }
  }

}

void __fastcall TWTQuery::FOnUserPostError(TDataSet* DataSet, EDatabaseError* E, TDataAction &Action){
  if (E->Message=="Key violation.") {
    ShowMessage("Нарушена уникальность первичного ключа");
  } else {
    ShowMessage("Запись не может быть сохранена");
  }
    Action=daAbort;
}


void TWTField::SetOnGetText(TFieldGetTextEvent FOnGetText) {
  OnGetText = FOnGetText;
  // Устанавливаем и на поле в запросе
 if (Field)
    Field->OnGetText = OnGetText;
}

void _fastcall TWTField::IntOnGetText(TField* Sender, AnsiString &Text,
         bool DisplayText) {
  if (OnGetText) OnGetText(Sender,Text,DisplayText);
  if (IsFixedVariables) {
    for (int x=0;x<FixedVariables->Count;x++) {
      if (Sender->AsString == FixedVariables->GetVariable(x)->DBValue) Text =FixedVariables->GetVariable(x)->RealValue;
    }
  } else Text=Sender->AsString;
}

//---------------------------------------------------------------------
void TWTField::SetOnSetText(TFieldSetTextEvent FOnSetText) {
  OnSetText = FOnSetText;
  // Устанавливаем и на поле в запросе
  if (Field)
    Field->OnSetText = OnSetText;
}

void _fastcall TWTField::IntOnSetText(TField* Sender, AnsiString Text) {

  if (IsFixedVariables) {
    for (int x = 0; x < FixedVariables->Count; x++)
      if (Text == FixedVariables->GetVariable(x)->RealValue) {
        Sender->AsString = FixedVariables->GetVariable(x)->DBValue;
        return;
      }
  }

  if (IsFill) {
    int FSize = FillSize < 1 ? FSize = Sender->DataSize - 1 : FillSize;
    AnsiString S = "";
    if ((Text.TrimLeft().TrimRight().Length() < FSize) && (Text.Length() != 0)) {
      for (int i = 0; i < FSize - Text.TrimLeft().TrimRight().Length(); i++)
        S = S + FillChar;
      Text = S + Text.TrimLeft().TrimRight();
    }
  }

  if (FPrecision != -100) {
    Text = AnsiString(Round(Text.ToDouble(), Precision));
  }

  if (OnSetText)
    OnSetText(Sender, Text);
  else
    Sender->AsString = Text;
}

//---------------------------------------------------------------------
void TWTField::SetDefault(AnsiString Default) {
  TWTField::DefaultExpression = Default;
  if (Field)
    Field->DefaultExpression = DefaultExpression;
}
//---------------------------------------------------------------------
void TWTField::SetDisplayLabel(AnsiString DisplayLabel) {
  TWTField::DisplayLabel = DisplayLabel;
  if (Field)
    Field->DisplayLabel = DisplayLabel;
}
//---------------------------------------------------------------------
void TWTField::SetConstraint(AnsiString Constraint, AnsiString ErrorMessage) {
  TWTField::Constraint = Constraint;
  if (ErrorMessage != NULL)
    ConstraintErrorMessage = ErrorMessage;
  else 
    ConstraintErrorMessage = "Поле заполнено не верно";

  // Устанавливаем и на поле в запросе
  if (Field) {
    Field->CustomConstraint = Constraint;
    Field->ConstraintErrorMessage = ErrorMessage;
  }
}
//---------------------------------------------------------------------
void TWTField::SetReadOnly(bool ReadOnly) {
  TWTField::ReadOnly = ReadOnly;
  if (Column)
    Column->ReadOnly = ReadOnly;
}
//---------------------------------------------------------------------
void TWTField::SetWidth(int Width) {
  TWTField::Width = Width;
  if (Column)
    Column->Width = Width;
}
//---------------------------------------------------------------------
void TWTField::SaveProperty() {
  if (Field) {
    SaveOnValidate = Field->OnValidate;
    SaveOnGetText=Field->OnGetText;
    SaveOnSetText=Field->OnSetText;
    Constraint = Field->CustomConstraint;
    ConstraintErrorMessage = Field->ConstraintErrorMessage;
    DisplayLabel = Field->DisplayLabel;
    DefaultExpression = Field->DefaultExpression;

  }
  if (Column) {
    ReadOnly = Column->ReadOnly;
    Width = Column->Width;
    if (Column->PickList->Count!= 0)
     { PickList=new TStringList();
       for (int i=0; i<Column->PickList->Count; i++)
         PickList->Add(Column->PickList->Strings[i]);
     }
  }
}
//---------------------------------------------------------------------
void TWTField::SetProperty(TField *Field) {

  if (Field != NULL) {
    TWTField::Field = Field;
  }
  else {
    Field = TWTField::Field;
  }
  if (Field) {
    Field->OnValidate = SaveOnValidate;
    Field->OnGetText= SaveOnGetText;
    Field->OnSetText= SaveOnSetText;
    Field->CustomConstraint = Constraint;
    Field->ConstraintErrorMessage = ConstraintErrorMessage;
    Field->DisplayLabel = DisplayLabel;
    Field->DefaultExpression = DefaultExpression;
    Field->Name=Name;

  }
  if (Column) {
    Column->ReadOnly = ReadOnly;
    if (Width)
      Column->Width = Width;
    if (PickList)
      for (int i=0; i<PickList->Count;i++)
       Column->PickList->Strings[i]= PickList->Strings[i];
  }
  // Устанавливаем помощь для отображения
  SetOnHelp(OnHelp);
}
//---------------------------------------------------------------------
void TWTField::SetDefaultExpression(AnsiString DefaultExpression) {
  TWTField::DefaultExpression = DefaultExpression;
  if (Field) {
    Field->DefaultExpression = DefaultExpression;
  }
}

//установить(снять) уникальность поля (возвращает код ошибки)
int TWTField::SetUnique(AnsiString ErrorString,AnsiString TableName,AnsiString FieldName){
  if (CheckParent(Field->DataSet,"TQuery") && TableName=="") {
    ShowMessage("Необходимо указать имя таблицы по которой выполняется проверка уникальности");
    return 1;
  }
  IsUnique=true;
  if (TableName!="") TWTField::TableName=TableName;
  else TWTField::TableName=((TTable*)Field->DataSet)->TableName;
  UniqueError=ErrorString;
  if (Field) TWTField::Field->OnValidate=OnValidateData;
  SaveOnValidate=OnValidateData;
  return 0;
}

void TWTField::UnsetUnique(){
  IsUnique=false;
}

//установить(снять) минимальное и максимальное значение поля (возвращает код ошибки)
int TWTField::SetRange(Variant& Min,Variant& Max,AnsiString ErrorString){
  RangeError=ErrorString;
  IsRange=true;
  MinValue=Min;
  MaxValue=Max;


  if (Field) TWTField::Field->OnValidate=OnValidateData;
  SaveOnValidate=OnValidateData;
  
    return 0;
}

void TWTField::UnsetRange(){
  IsRange=false;
}

//установить(снять) набор фиксированных значений для поля (возвращает код ошибки)
int TWTField::AddFixedVariable(AnsiString DBValue,AnsiString RealValue){
  if (FixedVariables==NULL) {
    FixedVariables=new TWTFixedVariables();
    if (Field) TWTField::Field->OnGetText=IntOnGetText;
    SaveOnGetText=IntOnGetText;
    if (Field) TWTField::Field->OnSetText=IntOnSetText;
    SaveOnSetText=IntOnSetText;
  }
  if (!IsFixedVariables) Column->Width=0;
  IsFixedVariables=true;
  if (Column) {
    if (StringSize(RealValue,Column->Font)+10>Column->Width) Column->Width=StringSize(RealValue,Column->Font)+25;
    Column->ButtonStyle= cbsAuto;
    Column->PickList->Add(RealValue);
  }
  return FixedVariables->Add(DBValue,RealValue);
}

void TWTField::UnsetFixedVariables(){
  delete FixedVariables;
  IsFixedVariables=false;
}

//установить(снять) значение по умолчанию
int TWTField::SetDefValue(Variant& Value){
  TWTField::Value=Value;
  IsValue=true;
  return 0;
}

void TWTField::UnsetDefValue(){
  IsValue=false;
}

//установить(снять) необходимость поля
int TWTField::SetRequired(AnsiString ErrorString){
  IsRequired=true;
  RequiredError=ErrorString;
  //if (Field) TWTField::Field->OnValidate=OnValidateData;
  SaveOnValidate=OnValidateData;
  return 0;
}

void TWTField::UnsetRequired(){
  IsRequired=false;
}

//установить(снять) заполнение поля
int TWTField::SetFill(int FillSize,char FillChar){
  if (Field->DataType!=ftString) {
    throw Exception("Заполнение можно применять только к полям типа String");
  }
  IsFill=true;
  TWTField::FillSize=FillSize;
  TWTField::FillChar=FillChar;
  if (Field) TWTField::Field->OnSetText=IntOnSetText;
  SaveOnSetText=IntOnSetText;
  return 0;
}

void TWTField::UnsetFill(){
  IsFill=false;
}

void __fastcall TWTField::SetPrecision(int Value) {
  if (!CheckParent(Field,"TNumericField")) {
    TWTField::Field->OnSetText=NULL;
    return;
  }
  FPrecision=Value;
  if (Value<0) return;
  AnsiString Mask="0.";
  if (Value!=-1) {
    for (int x=0;x<Value;x++) Mask+="0";
      ((TNumericField*)Field)->DisplayFormat=Mask;
  } else {
    ((TNumericField*)Field)->DisplayFormat="";
  }
  TWTField::Field->OnSetText=IntOnSetText;
  SaveOnSetText=IntOnSetText;
}





































