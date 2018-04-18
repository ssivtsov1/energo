// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZQuery.pas' rev: 5.00

#ifndef ZQueryHPP
#define ZQueryHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZSqlItems.hpp>	// Pascal unit
#include <ZSqlBuffer.hpp>	// Pascal unit
#include <ZSqlParser.hpp>	// Pascal unit
#include <ZSqlTypes.hpp>	// Pascal unit
#include <ZParser.hpp>	// Pascal unit
#include <ZUpdateSql.hpp>	// Pascal unit
#include <ZTransact.hpp>	// Pascal unit
#include <ZConnect.hpp>	// Pascal unit
#include <ZBlobStream.hpp>	// Pascal unit
#include <ZSqlExtra.hpp>	// Pascal unit
#include <ZToken.hpp>	// Pascal unit
#include <DBCommon.hpp>	// Pascal unit
#include <ZDirSql.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zquery
{
//-- type declarations -------------------------------------------------------
typedef Zsqltypes::TDatabaseType TZDatabaseType;

#pragma option push -b-
enum TZLinkOption { loLinkRequery, loCascadeUpdate, loCascadeDelete, loAlwaysResync };
#pragma option pop

typedef Set<TZLinkOption, loLinkRequery, loAlwaysResync>  TZLinkOptions;

#pragma option push -b-
enum TZDatasetOption { doParamsAsIs, doHourGlass, doQueryAllRecords, doAutoFillDefs, doCalcDefault, 
	doQuickOpen, doEnableAutoInc, doUseRowId, doCursorFetch, doSqlFilter, doRefreshAfterPost, doRefreshBeforeEdit 
	};
#pragma option pop

typedef Set<TZDatasetOption, doParamsAsIs, doRefreshBeforeEdit>  TZDatasetOptions;

typedef void __fastcall (__closure *TUpdateRecordEvent)(Db::TDataSet* DataSet, Db::TUpdateKind UpdateKind
	, Db::TUpdateAction &UpdateAction);

typedef TZUpdateRecordTypes TZUpdateRecordTypes;
;

#pragma option push -b-
enum TZProgressStage { psStarting, psRunning, psEnding };
#pragma option pop

#pragma option push -b-
enum TZProgressProc { ppFetching, ppClosing };
#pragma option pop

typedef void __fastcall (__closure *TZProgressEvent)(System::TObject* Sender, TZProgressStage Stage, 
	TZProgressProc Proc, int Position, int Max, bool &Cancel);

class DELPHICLASS TZQueryDataLink;
class DELPHICLASS TZDataset;
typedef AnsiString ZQuery__3[256];

class PASCALIMPLEMENTATION TZDataset : public Db::TDataSet 
{
	typedef Db::TDataSet inherited;
	
private:
	bool FAutoOpen;
	bool FAutoStart;
	bool FNewValueState;
	Zsqltypes::TDatabaseType FDatabaseType;
	int FVersion;
	Zsqlparser::TSqlParser* FSqlParser;
	Zsqlbuffer::TSqlBuffer* FSqlBuffer;
	Zsqlbuffer::TSqlBuffer* FCacheBuffer;
	AnsiString FTableName;
	bool FDefaultIndex;
	int FRowsAffected;
	bool FRequestLive;
	Db::TParams* FParams;
	bool FParamCheck;
	char FMacroChar;
	Db::TParams* FMacros;
	bool FMacroCheck;
	Zconnect::TZDatabase* FDatabase;
	Ztransact::TZTransact* FTransact;
	Zdirsql::TDirQuery* FQuery;
	Db::TIndexDefs* FIndexDefs;
	AnsiString FIndexName;
	bool FFieldsIndex;
	int FCurRec;
	TZDatasetOptions FOptions;
	Zparser::TZParser* FParser;
	Zparser::TZParser* FCCParser;
	bool FFiltered;
	bool FFetchAll;
	bool FCachedUpdates;
	Db::TDataSetErrorEvent FOnApplyUpdateError;
	TUpdateRecordEvent FOnUpdateRecord;
	Zupdatesql::TZUpdateSql* FUpdateObject;
	bool FLinkCheck;
	AnsiString FLinkFields;
	TZLinkOptions FLinkOptions;
	int FMasterIndex;
	int FMasterFields[256];
	int FMasterFieldCount;
	Db::TMasterDataLink* FMasterLink;
	AnsiString FDetailFields[256];
	TZQueryDataLink* FDataLink;
	TZProgressEvent FOnProgress;
	void __fastcall SetIndexDefs(Db::TIndexDefs* Value);
	AnsiString __fastcall GetIndexName();
	void __fastcall SetIndexName(const AnsiString Value);
	AnsiString __fastcall GetIndexFieldNames();
	void __fastcall SetIndexFieldNames(const AnsiString Value);
	int __fastcall GetIndexFieldCount(void);
	Db::TField* __fastcall GetIndexField(int Index);
	void __fastcall SetIndexField(int Index, Db::TField* Value);
	void __fastcall SetIndex(const AnsiString Value, bool FieldsIndex);
	Word __fastcall GetParamsCount(void);
	Word __fastcall GetMacroCount(void);
	bool __fastcall GetUpdatesPending(void);
	Classes::TStrings* __fastcall GetSql(void);
	bool __fastcall GetReadOnly(void);
	void __fastcall SetParamsList(Db::TParams* Value);
	void __fastcall SetMacroChar(char Value);
	void __fastcall SetMacros(Db::TParams* Value);
	void __fastcall SetSql(Classes::TStrings* Value);
	void __fastcall SetTableName(AnsiString Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetUpdateObject(Zupdatesql::TZUpdateSql* Value);
	Zsqltypes::TZUpdateRecordTypes __fastcall GetUpdateRecord(void);
	void __fastcall SetUpdateRecord(Zsqltypes::TZUpdateRecordTypes Value);
	void __fastcall SetOptions(TZDatasetOptions Value);
	
protected:
	AnsiString __fastcall GetLinkFields();
	Db::TDataSource* __fastcall GetMasterDataSource(void);
	void __fastcall SetLinkFields(AnsiString Value);
	void __fastcall SetMasterDataSource(Db::TDataSource* Value);
	void __fastcall UpdateLinkFields(void);
	void __fastcall MasterChanged(System::TObject* Sender);
	void __fastcall MasterDisabled(System::TObject* Sender);
	void __fastcall MasterCascade(void);
	void __fastcall MasterRequery(void);
	bool __fastcall MasterStateCheck(Db::TDataSet* Dataset);
	void __fastcall MasterDefine(void);
	Db::TDataSource* __fastcall GetDataLinkSource(void);
	void __fastcall SetDataLinkSource(Db::TDataSource* Value);
	void __fastcall ParamsRequery(void);
	void __fastcall RefreshParams(void);
	bool __fastcall CheckRecordByFilter(int RecNo);
	void __fastcall QueryRecords(bool Force);
	void __fastcall QueryOneRecord(void);
	void __fastcall ShortRefresh(void);
	bool __fastcall RefreshCurrentRow(Zsqltypes::PRecordData RecordData);
	virtual void __fastcall ResetAggField(Db::TField* Field);
	virtual Variant __fastcall GetAggregateValue(Db::TField* Field);
	void __fastcall SqlFilterRefresh(void);
	__property Zconnect::TZDatabase* DatabaseObj = {read=FDatabase, write=FDatabase};
	__property Ztransact::TZTransact* TransactObj = {read=FTransact, write=FTransact};
	__property Zdirsql::TDirQuery* Query = {read=FQuery, write=FQuery};
	__property bool FetchAll = {read=FFetchAll, write=FFetchAll, nodefault};
	__property bool FilterMark = {read=FFiltered, write=FFiltered, nodefault};
	void __fastcall SetDatabase(Zconnect::TZDatabase* Value);
	void __fastcall SetTransact(Ztransact::TZTransact* Value);
	virtual void __fastcall ChangeAddBuffer(Zsqltypes::PRecordData AddRecord);
	virtual void __fastcall CreateConnections(void);
	virtual void __fastcall FormSqlQuery(Zsqltypes::PRecordData OldData, Zsqltypes::PRecordData NewData
		);
	AnsiString __fastcall FormatFieldsList(AnsiString Value);
	AnsiString __fastcall FormTableSqlOrder();
	virtual void __fastcall QueryRecord(void) = 0 ;
	void __fastcall DefineTableKeys(AnsiString Table, bool Unique, int * FieldList, int &FieldCount);
	AnsiString __fastcall FormSqlWhere(AnsiString Table, Zsqltypes::PRecordData RecordData);
	AnsiString __fastcall EvaluteDef(AnsiString Value);
	virtual Db::TGetResult __fastcall GetRecord(char * Buffer, Db::TGetMode GetMode, bool DoCheck);
	virtual Word __fastcall GetRecordSize(void);
	virtual void __fastcall SetFieldData(Db::TField* Field, void * Buffer)/* overload */;
	virtual TMetaClass* __fastcall GetFieldClass(Db::TFieldType FieldType);
	virtual char * __fastcall AllocRecordBuffer(void);
	virtual void __fastcall CloseBlob(Db::TField* Field);
	virtual void __fastcall FreeRecordBuffer(char * &Buffer);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall InternalOpen(void);
	virtual void __fastcall InternalClose(void);
	virtual void __fastcall InternalFirst(void);
	virtual void __fastcall InternalLast(void);
	virtual void __fastcall InternalEdit(void);
	virtual void __fastcall InternalAddRecord(void * Buffer, bool Append);
	virtual void __fastcall InternalPost(void);
	virtual void __fastcall InternalDelete(void);
	virtual void __fastcall InternalInitRecord(char * Buffer);
	void __fastcall InternalUpdate(void);
	virtual void __fastcall InternalGotoBookmark(void * Bookmark);
	virtual void __fastcall InternalRefresh(void);
	virtual void __fastcall InternalHandleException(void);
	virtual void __fastcall InternalSetToRecord(char * Buffer);
	int __fastcall InternalLocate(AnsiString KeyFields, const Variant &KeyValues, Db::TLocateOptions Options
		);
	void __fastcall InternalFormKeyValues(Zsqltypes::PRecordData RecordData, bool Unique, AnsiString &KeyFields
		, Variant &KeyValues);
	void __fastcall InternalSort(AnsiString Fields, Zsqlitems::TSortType SortType);
	virtual void __fastcall GetBookmarkData(char * Buffer, void * Data);
	virtual Db::TBookmarkFlag __fastcall GetBookmarkFlag(char * Buffer);
	virtual void __fastcall SetBookmarkFlag(char * Buffer, Db::TBookmarkFlag Value);
	virtual void __fastcall SetBookmarkData(char * Buffer, void * Data);
	virtual bool __fastcall FindRecord(bool Restart, bool GoForward);
	virtual void __fastcall SetFiltered(bool Value);
	virtual void __fastcall SetFilterText(const AnsiString Value);
	virtual bool __fastcall GetCanModify(void);
	virtual int __fastcall GetRecNo(void);
	virtual int __fastcall GetRecordCount(void);
	virtual void __fastcall SetRecNo(int Value);
	virtual bool __fastcall IsCursorOpen(void);
	void __fastcall ClearBuffer(void);
	virtual void __fastcall FlushBuffer(void);
	void __fastcall CheckContraints(void);
	virtual void __fastcall UpdateAfterPost(Zsqltypes::PRecordData OldData, Zsqltypes::PRecordData NewData
		);
	virtual void __fastcall UpdateAfterInit(Zsqltypes::PRecordData RecordData);
	void __fastcall Flush(void);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation
		);
	void __fastcall DoProgress(TZProgressStage Stage, TZProgressProc Proc, int Position);
	virtual void __fastcall DefineProperties(Classes::TFiler* Filer);
	void __fastcall ReadParamData(Classes::TReader* Reader);
	void __fastcall WriteParamData(Classes::TWriter* Writer);
	void __fastcall AutoFillObjects(void);
	virtual void __fastcall InternalInitFieldDefs(void);
	virtual void __fastcall UpdateIndexDefs(void);
	virtual void __fastcall UpdateFieldDef(Zsqlitems::PFieldDesc FieldDesc, Db::TFieldType &FieldType, 
		int &FieldSize);
	AnsiString __fastcall ConvertToSqlEnc(AnsiString Value);
	AnsiString __fastcall ConvertFromSqlEnc(AnsiString Value);
	virtual Byte __fastcall ValueToRowId(AnsiString Value);
	virtual AnsiString __fastcall RowIdToValue(const Byte * Value);
	__property AnsiString TableName = {read=FTableName, write=SetTableName};
	__property bool RequestLive = {read=FRequestLive, write=FRequestLive, nodefault};
	__property bool DefaultIndex = {read=FDefaultIndex, write=FDefaultIndex, nodefault};
	__property Db::TDataSource* DataSource = {read=GetDataLinkSource, write=SetDataLinkSource};
	
public:
	__fastcall virtual TZDataset(Classes::TComponent* AOwner);
	__fastcall virtual ~TZDataset(void);
	__property Zsqlparser::TSqlParser* SqlParser = {read=FSqlParser};
	__property Zsqlbuffer::TSqlBuffer* SqlBuffer = {read=FSqlBuffer};
	__property Zsqlbuffer::TSqlBuffer* CacheBuffer = {read=FCacheBuffer};
	__property int CurRec = {read=FCurRec, write=FCurRec, nodefault};
	void __fastcall SqlFilterRefreshEx(bool bForce);
	bool __fastcall RefreshCurrRow(void);
	virtual void __fastcall AddTableFields(AnsiString Table, Zsqlitems::TSqlFields* SqlFields) = 0 ;
	virtual void __fastcall AddTableIndices(AnsiString Table, Zsqlitems::TSqlFields* SqlFields, Zsqlitems::TSqlIndices* 
		SqlIndices) = 0 ;
	virtual bool __fastcall CheckTableExistence(AnsiString Table);
	AnsiString __fastcall StringToSql(AnsiString Value);
	AnsiString __fastcall ParamToSql(const Variant &Value);
	AnsiString __fastcall ValueToSql(const Variant &Value);
	virtual AnsiString __fastcall ProcessIdent(AnsiString Value);
	virtual AnsiString __fastcall FieldValueToSql(AnsiString Value, Zsqlitems::PFieldDesc FieldDesc);
	virtual void __fastcall CopyRecord(Zsqlbuffer::TSqlBuffer* SqlBuffer, Zsqltypes::PRecordData Source
		, Zsqltypes::PRecordData Dest);
	virtual void __fastcall FreeRecord(Zsqlbuffer::TSqlBuffer* SqlBuffer, Zsqltypes::PRecordData Value)
		;
	virtual void __fastcall ExecSql(void);
	int __fastcall RowsAffected(void);
	void __fastcall SortInverse(void);
	void __fastcall SortClear(void);
	void __fastcall SortByField(AnsiString Fields);
	void __fastcall SortDescByField(AnsiString Fields);
	virtual bool __fastcall Locate(const AnsiString KeyFields, const Variant &KeyValues, Db::TLocateOptions 
		Options);
	virtual Variant __fastcall Lookup(const AnsiString KeyFields, const Variant &KeyValues, const AnsiString 
		ResultFields);
	virtual bool __fastcall IsSequenced(void);
	virtual int __fastcall CompareBookmarks(void * Bookmark1, void * Bookmark2);
	virtual bool __fastcall BookmarkValid(void * Bookmark);
	void __fastcall ApplyUpdates(void);
	void __fastcall CommitUpdates(void);
	void __fastcall CancelUpdates(void);
	void __fastcall RevertRecord(void);
	virtual Db::TUpdateStatus __fastcall UpdateStatus(void);
	Db::TParam* __fastcall ParamByName(const AnsiString Value);
	Db::TParam* __fastcall MacroByName(const AnsiString Value);
	virtual Classes::TStream* __fastcall CreateBlobStream(Db::TField* Field, Db::TBlobStreamMode Mode);
		
	bool __fastcall GetActiveRecBuf(Zsqltypes::PRecordData &Value);
	virtual bool __fastcall GetFieldData(Db::TField* Field, void * Buffer)/* overload */;
	virtual void __fastcall DataEvent(Db::TDataEvent Event, int Info);
	void __fastcall SaveToStream(Classes::TStream* Stream);
	void __fastcall LoadFromStream(Classes::TStream* Stream);
	void __fastcall SaveToFile(AnsiString FileName);
	void __fastcall LoadFromFile(AnsiString FileName);
	void __fastcall GetIndexNames(Classes::TStrings* List);
	virtual void __fastcall FormKeyValues(AnsiString &KeyFields, Variant &KeyValues);
	__property bool UpdatesPending = {read=GetUpdatesPending, nodefault};
	__property Active ;
	__property Classes::TStrings* Sql = {read=GetSql, write=SetSql};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property Zsqltypes::TDatabaseType DatabaseType = {read=FDatabaseType, write=FDatabaseType, nodefault
		};
	__property bool AutoOpen = {read=FAutoOpen, nodefault};
	__property Db::TParams* Params = {read=FParams, write=SetParamsList, stored=false};
	__property bool ParamCheck = {read=FParamCheck, write=FParamCheck, default=1};
	__property Word ParamCount = {read=GetParamsCount, nodefault};
	__property Db::TParams* Macros = {read=FMacros, write=SetMacros};
	__property bool MacroCheck = {read=FMacroCheck, write=FMacroCheck, default=1};
	__property Word MacroCount = {read=GetMacroCount, nodefault};
	__property char MacroChar = {read=FMacroChar, write=SetMacroChar, default=37};
	__property int IndexFieldCount = {read=GetIndexFieldCount, nodefault};
	__property Db::TField* IndexFields[int Index] = {read=GetIndexField, write=SetIndexField};
	
__published:
	__property Zconnect::TZDatabase* Database = {read=FDatabase, write=SetDatabase};
	__property Ztransact::TZTransact* Transaction = {read=FTransact, write=SetTransact};
	__property Zupdatesql::TZUpdateSql* UpdateObject = {read=FUpdateObject, write=SetUpdateObject};
	__property int Version = {read=FVersion, nodefault};
	__property bool CachedUpdates = {read=FCachedUpdates, write=FCachedUpdates, nodefault};
	__property Zsqltypes::TZUpdateRecordTypes ShowRecordTypes = {read=GetUpdateRecord, write=SetUpdateRecord
		, nodefault};
	__property TZDatasetOptions Options = {read=FOptions, write=SetOptions, nodefault};
	__property AnsiString LinkFields = {read=GetLinkFields, write=SetLinkFields};
	__property TZLinkOptions LinkOptions = {read=FLinkOptions, write=FLinkOptions, nodefault};
	__property Db::TDataSource* MasterSource = {read=GetMasterDataSource, write=SetMasterDataSource};
	__property FieldDefs  = {stored=false};
	__property Constraints ;
	__property Db::TIndexDefs* IndexDefs = {read=FIndexDefs, write=SetIndexDefs, stored=false};
	__property AnsiString IndexName = {read=GetIndexName, write=SetIndexName};
	__property AnsiString IndexFieldNames = {read=GetIndexFieldNames, write=SetIndexFieldNames};
	__property Db::TDataSetErrorEvent OnApplyUpdateError = {read=FOnApplyUpdateError, write=FOnApplyUpdateError
		};
	__property TUpdateRecordEvent OnUpdateRecord = {read=FOnUpdateRecord, write=FOnUpdateRecord};
	__property TZProgressEvent OnProgress = {read=FOnProgress, write=FOnProgress};
	__property AutoCalcFields ;
	__property BeforeOpen ;
	__property AfterOpen ;
	__property BeforeClose ;
	__property AfterClose ;
	__property BeforeInsert ;
	__property AfterInsert ;
	__property BeforeEdit ;
	__property AfterEdit ;
	__property BeforePost ;
	__property AfterPost ;
	__property BeforeCancel ;
	__property AfterCancel ;
	__property BeforeDelete ;
	__property AfterDelete ;
	__property BeforeScroll ;
	__property AfterScroll ;
	__property OnCalcFields ;
	__property OnDeleteError ;
	__property OnEditError ;
	__property OnPostError ;
	__property OnFilterRecord ;
	__property OnNewRecord ;
	__property Filter ;
	__property Filtered ;
	__property FilterOptions ;
};


class PASCALIMPLEMENTATION TZQueryDataLink : public Db::TDataLink 
{
	typedef Db::TDataLink inherited;
	
private:
	TZDataset* FQuery;
	
protected:
	virtual void __fastcall ActiveChanged(void);
	virtual void __fastcall RecordChanged(Db::TField* Field);
	
public:
	__fastcall TZQueryDataLink(TZDataset* AQuery);
public:
	#pragma option push -w-inl
	/* TDataLink.Destroy */ inline __fastcall virtual ~TZQueryDataLink(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZBCDField;
class PASCALIMPLEMENTATION TZBCDField : public Db::TBCDField 
{
	typedef Db::TBCDField inherited;
	
protected:
	#pragma option push -w-inl
	/* virtual class method */ virtual void __fastcall CheckTypeSize(int Value) { CheckTypeSize(__classid(TZBCDField)
		, Value); }
	#pragma option pop
	/*         class method */ static void __fastcall CheckTypeSize(TMetaClass* vmt, int Value);
	virtual System::Currency __fastcall GetAsCurrency(void);
	virtual AnsiString __fastcall GetAsString();
	virtual Variant __fastcall GetAsVariant();
	virtual int __fastcall GetDataSize(void);
	
public:
	__fastcall virtual TZBCDField(Classes::TComponent* AOwner);
	
__published:
	__property Size ;
public:
	#pragma option push -w-inl
	/* TField.Destroy */ inline __fastcall virtual ~TZBCDField(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
static const Word LIST_BLOCK_SIZE = 0x1f4;
static const Shortint MIN_FETCH_ROWS = 0x0;
static const Shortint MAX_NAME_LENGTH = 0x32;
static const Shortint MAX_LINKS_COUNT = 0x5;
static const Shortint MAX_SORT_COUNT = 0x5;
static const Byte MAX_FIELD_COUNT = 0xff;
static const Shortint MAX_INDEX_COUNT = 0x19;
static const Shortint MAX_INDEX_FIELDS = 0x19;
static const Byte DEFAULT_STRING_SIZE = 0xfe;
static const Word MAX_STRING_SIZE = 0x200;
static const char DEFAULT_MACRO_CHAR = '\x25';
#define ZEOS_PALETTE "Zeos Common"
#define ZEOS_DB_PALETTE "Zeos Access"
static const Word ZDBO_VERSION = 0xc4e0;

}	/* namespace Zquery */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zquery;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZQuery
