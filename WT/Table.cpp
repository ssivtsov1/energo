//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//#include "Fields.h"
#include "Table.h"

TZPgSqlDatabase *TWTTable::Database = NULL;
TZPgSqlTransact *TWTTable::Transaction = NULL;
//---------------------------------------------------------------------
// функции класса TWTTable
//---------------------------------------------------------------------
_fastcall TWTTable::TWTTable(TComponent *owner, AnsiString Name) : TZPgSqlTable(owner) {

  Database=Database;
  Transaction= Transaction;
  TableName= Name;

  DataSource = new TDataSource(this);
  DataSource->DataSet = this;

  isApplyUpdates = 0;
//  CachedUpdates = true;
//  Cnt= true;
  DefaultFilter = "";
  ListField=NULL;

  TZDataset::SetDatabase(Database);
  TZDataset::SetTransact(Transaction);

  // Проверяем только модифицированные поля
//  UpdateMode = upWhereChanged;

  // Функции обработки событии в TTable
  TZPgSqlTable::AfterCancel = FAfterCancel;
  TZPgSqlTable::AfterClose = FAfterClose;
  TZPgSqlTable::AfterDelete = FAfterDelete;
  TZPgSqlTable::AfterEdit = FAfterEdit;
  TZPgSqlTable::AfterInsert = FAfterInsert;
  TZPgSqlTable::AfterOpen = FAfterOpen;
  TZPgSqlTable::AfterPost = FAfterPost;
  TZPgSqlTable::AfterScroll = FAfterScroll;
  TZPgSqlTable::BeforeCancel = FBeforeCancel;
  TZPgSqlTable::BeforeClose = FBeforeClose;
  TZPgSqlTable::BeforeDelete = FBeforeDelete;
  TZPgSqlTable::BeforeEdit = FBeforeEdit;
  TZPgSqlTable::BeforeInsert = FBeforeInsert;
  TZPgSqlTable::BeforeOpen = FBeforeOpen;
  TZPgSqlTable::BeforePost = FBeforePost;
  TZPgSqlTable::BeforeScroll = FBeforeScroll;
  TZPgSqlTable::OnPostError=FOnUserPostError;
  TZPgSqlTable::Options << doQuickOpen;
  TZPgSqlTable::Options << doSqlFilter;
  Options  << doQuickOpen;
  Options  <<   doSqlFilter;
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
 if (Name != "") {
    FieldDefs->Update();
    for (int x=0;x<FieldDefs->Count;x++) {
      AddField(FieldDefs->Items[x]->Name);
    }
  }
}
//---------------------------------------------------------------------
_fastcall TWTTable::~TWTTable() {
  Close();
}
//---------------------------------------------------------------------
// Состояние базы
//---------------------------------------------------------------------
bool TWTTable::isModified() {
  return State == dsEdit;//Modified;
}
//---------------------------------------------------------------------
bool TWTTable::isInserted() {
  return State == dsInsert;
}
//---------------------------------------------------------------------
// Текущие параметры запроса
//---------------------------------------------------------------------
TField *TWTTable::GetField(int Index) {
  return Fields->Fields[Index];
}
//---------------------------------------------------------------------
TField *TWTTable::GetField(AnsiString FieldName) {
  return FindField(FieldName.UpperCase());
}
//---------------------------------------------------------------------
TWTField *TWTTable::GetTField(int Index) {
  return (TWTField*)ListField->Items[Index];
}
//---------------------------------------------------------------------
TWTField *TWTTable::GetTField(AnsiString FieldName) {
  for (int i = 0; i < ListField->Count; i++)
    if (((TWTField*)ListField->Items[i])->GetFieldName() == FieldName.UpperCase())
      return (TWTField*)ListField->Items[i];
  return NULL;
}
//---------------------------------------------------------------------
// Функции обработки событии
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterCancel(TDataSet *DataSet) {
  if (AfterCancel) AfterCancel(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterPost(TDataSet *DataSet) {
  if (AfterPost) AfterPost(this);
   //ApplyUpdates();
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterClose(TDataSet *DataSet) {
  if (AfterClose) AfterClose(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterDelete(TDataSet *DataSet) {
    //ApplyUpdates();
    if (AfterDelete) AfterDelete(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterEdit(TDataSet *DataSet) {
  if (AfterEdit) AfterEdit(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterInsert(TDataSet *DataSet) {
  if (AfterInsert) AfterInsert(this);
  TWTField* Field;
  for (int x=0;x<ListField->Count;x++) {
    Field=(TWTField*)ListField->Items[x];
    if (Field->IsValue && Field->Field->IsNull) {
      Field->Field->AsVariant=Field->Value;
     }
  }
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterOpen(TDataSet *DataSet) {
  if (AfterOpen)
  {  AfterOpen(this);
     First();
  }
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FAfterScroll(TDataSet *DataSet) {
  if (AfterScroll) AfterScroll(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeCancel(TDataSet *DataSet) {
  if (BeforeCancel) BeforeCancel(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforePost(TDataSet *DataSet) {
  if (BeforePost) BeforePost(this);
  TWTField* Field;
  for (int x=0;x<ListField->Count;x++) {
    Field=(TWTField*)ListField->Items[x];
    if (Field->IsRequired && Field->Field->IsNull) {
      throw Exception(Field->RequiredError);
    }
  }
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeClose(TDataSet *DataSet) {
  if (BeforeClose) BeforeClose(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeDelete(TDataSet *DataSet) {
  if (BeforeDelete) BeforeDelete(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeEdit(TDataSet *DataSet) {
  if (BeforeEdit) BeforeEdit(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeInsert(TDataSet *DataSet) {
  if (BeforeInsert) BeforeInsert(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeOpen(TDataSet *DataSet) {
  if (BeforeOpen) BeforeOpen(this);
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FBeforeScroll(TDataSet *DataSet) {
  if (BeforeScroll) BeforeScroll(this);
}
//---------------------------------------------------------------------
// Модификация базы
//---------------------------------------------------------------------
void TWTTable::ApplyUpdates() {
//Post();
if (!isApplyUpdates) {
    // Флаг старта транзакции
    isApplyUpdates = 1;
    try {
      TZPgSqlTable::ApplyUpdates(); // try to write the updates to the database
       Transaction->Commit();    // on success, commit the changes;
    }
    catch (...) {
      Transaction->Rollback();  // on failure, undo the changes
      // Отменим последние изменения (переходим в режим редактирования ???)
      CancelUpdates();
      if (AfterCancel) AfterCancel(this);
      isApplyUpdates = 0;
      throw Exception("Ошибка заполнения записи");
    }
    CommitUpdates();  // on success, clear the cache
    isApplyUpdates = 0;
};

}
//---------------------------------------------------------------------
void TWTTable::CancelUpdates() {
  Cancel();
 // TTable::CancelUpdates();
}
//---------------------------------------------------------------------
// Управление базой
//---------------------------------------------------------------------
void TWTTable::SetFilter(AnsiString Fil) {
  if (Fil=="") Fil=DefaultFilter;
  else if (DefaultFilter != "") Fil= DefaultFilter + " and " + Fil;
  TFilterOptions Opts;
    Opts.Clear();

    Opts= Opts <<  foCaseInsensitive;
    Opts=Opts << foNoPartialCompare;
    FilterOptions=Opts;

  Options  << doQuickOpen;
  Options  <<   doSqlFilter;
  Filter = Fil;
   if (!((Filter==NULL)||(Filter=="")))
   Filtered=true;
  else
   Filtered=false;
//  Filtered = Filter != "";
}

void __fastcall TWTTable::SetDefaultFilter(AnsiString Value){
  FDefaultFilter=Value;
  Filter=Value;
  if (!((Filter==NULL)))
   Filtered=true;
  else
   Filtered=false;
}

//---------------------------------------------------------------------
void TWTTable::Open() {
//int OldCount = FieldCount;
int i, OldState = State;
//bool St= false;

  if (ListField!=NULL) {
    for (int i=0;i<ListField->Count;i++) {
      ((TWTField*)ListField->Items[i])->Field->DataSet=this;
    }

    if (State != dsInactive) {
      for (int i = 0; i < ListField->Count; i++) {
        ((TWTField*)ListField->Items[i])->SaveProperty();
      }
      Close();
    }
  }

  try {
   // Active= true;
  TZPgSqlTable::Options  << doQuickOpen;
  TZPgSqlTable::Options  <<   doSqlFilter;
    TZPgSqlTable::Open();
   Options  << doQuickOpen;
  Options  <<   doSqlFilter;
  Filtered=true;
  }
  catch (...) {
//    St= true;
  Filtered=false;
  // Timer->Enabled= false;
  //TimerOn=false;
  //StateFilter= !StateFilter;

  
  //   StateFilter= !StateFilter;
   SetFilter("");
  }
  // Создаем массив указателей на дополнительные пареметрыы полей
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
  /*   if (Fields->Fields[i]->DataType == ftFloat) {
      Fields->Fields[i]->EditMask = "999999,99";
    } */
    Fields->Fields[i]->OnChange = FOnChange;
    // Восстанавливаем Validate условия
    if (OldState != dsInactive) {
      ((TWTField*)ListField->Items[i])->SetProperty(((TWTField*)ListField->Items[i])->Field);
    }
  }
//  if (St) SetFilter();
}
//---------------------------------------------------------------------
void _fastcall TWTTable::FOnChange(TField* Sender) {
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
void TWTTable::Close() {
  TZPgSqlTable::Close();
}
//---------------------------------------------------------------------
//Функции для работы с полями
TWTField *TWTTable::AddField(AnsiString FName) {
  TField *FField=AddSimpleField(this,FName);
  if (ListField==NULL) ListField = new TWTList();
  FField->FieldName=FName.UpperCase();
  ListField->Add(new TWTField(this, FField));
  FField->DataSet=this;
//  FField->DataSet=this;
  return (TWTField*)ListField->Items[ListField->Count-1];
}

TWTField *TWTTable::AddLookupField(AnsiString FName,AnsiString KeyField,AnsiString LookupTableName,AnsiString LookupFName,AnsiString LookupKeyFields,AnsiString LookFilt) {
/*
 try {
    FieldByName(KeyField);
  } catch (...) {
    ShowMessage("Поле <"+KeyField+"> "+"не существует");
    return NULL;
  }
  */
  TWTTable *Table;
  Table= new TWTTable(this,LookupTableName);
  Table->TableName=LookupTableName;
  Table->Database = Database;
  Table->Transaction = Transaction;
  Table->SetFilter(LookFilt);
  Table->Active = true;

  return AddLookupField(FName,KeyField,Table,LookupFName,LookupKeyFields);

}

TWTField* TWTTable::AddLookupField(AnsiString FName,AnsiString KeyField,TZDataset* LookupDataSet,AnsiString LookupFName,AnsiString LookupKeyFields,AnsiString LookFilt){
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

TWTField* TWTTable::AddCalcField(AnsiString FName,TWTDSEvent TCalcExpr){
  TField *FField=new TFloatField(this);;
  if (ListField==NULL) ListField = new TWTList();
//  Table->Active = false;
  FField->FieldName=FName.UpperCase();
  FField->Calculated=true;
  FField->FieldKind=fkCalculated;
   //FField->FieldType=ftInteger;
  OnCalcFields=TCalcExpr;
  ListField->Add(new TWTField(this, FField));
  FField->DataSet=this;
//  ((TWTField*)ListField->Items[ListField->Count-1])->LookupTable=((TWTTable*)LookupDataSet;
  return (TWTField*)ListField->Items[ListField->Count-1];
}


void __fastcall TWTTable::FOnUserPostError(TDataSet* DataSet, EDatabaseError* E, TDataAction &Action){
  if (E->Message=="Key violation.") {
    ShowMessage("Нарушена уникальность первичного ключа");
  } else {
    ShowMessage("Запись не может быть сохранена");
  }
    Action=daAbort;
}

#pragma package(smart_init)
