// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZPgSqlQuery.pas' rev: 5.00

#ifndef ZPgSqlQueryHPP
#define ZPgSqlQueryHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZBlobStream.hpp>	// Pascal unit
#include <ZSqlBuffer.hpp>	// Pascal unit
#include <ZSqlParser.hpp>	// Pascal unit
#include <ZSqlItems.hpp>	// Pascal unit
#include <ZSqlTypes.hpp>	// Pascal unit
#include <ZQuery.hpp>	// Pascal unit
#include <ZSqlExtra.hpp>	// Pascal unit
#include <ZLibPgSql.hpp>	// Pascal unit
#include <ZToken.hpp>	// Pascal unit
#include <ZPgSqlTr.hpp>	// Pascal unit
#include <ZPgSqlCon.hpp>	// Pascal unit
#include <DBCommon.hpp>	// Pascal unit
#include <ZDirPgSql.hpp>	// Pascal unit
#include <ZDirSql.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zpgsqlquery
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TZPgSqlOption { poTextAsMemo, poOidAsBlob };
#pragma option pop

typedef Set<TZPgSqlOption, poTextAsMemo, poOidAsBlob>  TZPgSqlOptions;

class DELPHICLASS TZCustomPgSqlDataset;
class PASCALIMPLEMENTATION TZCustomPgSqlDataset : public Zquery::TZDataset 
{
	typedef Zquery::TZDataset inherited;
	
private:
	TZPgSqlOptions FExtraOptions;
	HIDESBASE void __fastcall SetDatabase(Zpgsqlcon::TZPgSqlDatabase* Value);
	HIDESBASE void __fastcall SetTransact(Zpgsqltr::TZPgSqlTransact* Value);
	Zpgsqlcon::TZPgSqlDatabase* __fastcall GetDatabase(void);
	Zpgsqltr::TZPgSqlTransact* __fastcall GetTransact(void);
	
protected:
	virtual void __fastcall FormSqlQuery(Zsqltypes::PRecordData OldData, Zsqltypes::PRecordData NewData
		);
	virtual void __fastcall QueryRecord(void);
	virtual void __fastcall UpdateAfterInit(Zsqltypes::PRecordData RecordData);
	virtual void __fastcall UpdateAfterPost(Zsqltypes::PRecordData OldData, Zsqltypes::PRecordData NewData
		);
	virtual void __fastcall UpdateFieldDef(Zsqlitems::PFieldDesc FieldDesc, Db::TFieldType &FieldType, 
		int &FieldSize);
	virtual Byte __fastcall ValueToRowId(AnsiString Value);
	virtual AnsiString __fastcall RowIdToValue(const Byte * Value);
	
public:
	__fastcall virtual TZCustomPgSqlDataset(Classes::TComponent* AOwner);
	virtual void __fastcall AddTableFields(AnsiString Table, Zsqlitems::TSqlFields* SqlFields);
	virtual void __fastcall AddTableIndices(AnsiString Table, Zsqlitems::TSqlFields* SqlFields, Zsqlitems::TSqlIndices* 
		SqlIndices);
	virtual bool __fastcall CheckTableExistence(AnsiString Table);
	
__published:
	__property TZPgSqlOptions ExtraOptions = {read=FExtraOptions, write=FExtraOptions, nodefault};
	__property Zpgsqlcon::TZPgSqlDatabase* Database = {read=GetDatabase, write=SetDatabase};
	__property Zpgsqltr::TZPgSqlTransact* Transaction = {read=GetTransact, write=SetTransact};
public:
	#pragma option push -w-inl
	/* TZDataset.Destroy */ inline __fastcall virtual ~TZCustomPgSqlDataset(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZPgSqlQuery;
class PASCALIMPLEMENTATION TZPgSqlQuery : public TZCustomPgSqlDataset 
{
	typedef TZCustomPgSqlDataset inherited;
	
public:
	__property MacroCount ;
	__property ParamCount ;
	
__published:
	__property MacroChar ;
	__property Macros ;
	__property MacroCheck ;
	__property Params ;
	__property ParamCheck ;
	__property DataSource ;
	__property Sql ;
	__property RequestLive ;
	__property Active ;
public:
	#pragma option push -w-inl
	/* TZCustomPgSqlDataset.Create */ inline __fastcall virtual TZPgSqlQuery(Classes::TComponent* AOwner
		) : TZCustomPgSqlDataset(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TZDataset.Destroy */ inline __fastcall virtual ~TZPgSqlQuery(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZPgSqlTable;
class PASCALIMPLEMENTATION TZPgSqlTable : public TZCustomPgSqlDataset 
{
	typedef TZCustomPgSqlDataset inherited;
	
public:
	__fastcall virtual TZPgSqlTable(Classes::TComponent* AOwner);
	
__published:
	__property TableName ;
	__property ReadOnly ;
	__property DefaultIndex ;
	__property Active ;
public:
	#pragma option push -w-inl
	/* TZDataset.Destroy */ inline __fastcall virtual ~TZPgSqlTable(void) { }
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
static const Shortint DEFAULT_STRING_SIZE = 0x32;
static const Word MAX_STRING_SIZE = 0x200;
static const char DEFAULT_MACRO_CHAR = '\x25';
#define ZEOS_PALETTE "Zeos Common"
#define ZEOS_DB_PALETTE "Zeos Access"
static const Word ZDBO_VERSION = 0xc47c;

}	/* namespace Zpgsqlquery */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zpgsqlquery;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZPgSqlQuery
