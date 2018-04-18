// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlTypes.pas' rev: 5.00

#ifndef ZSqlTypesHPP
#define ZSqlTypesHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Db.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqltypes
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TZRecordType { ztModified, ztInserted, ztDeleted, ztUnmodified };
#pragma option pop

typedef Set<TZRecordType, ztModified, ztUnmodified>  TZUpdateRecordTypes;

#pragma option push -b-
enum TDatabaseType { dtMySql, dtPostgreSql, dtInterbase, dtMsSql, dtOracle, dtDb2, dtUnknown };
#pragma option pop

typedef int TFieldList[256];

typedef Byte TRowId[9];

typedef int TIntArray[1];

typedef int *PIntArray;

typedef Byte TByteArray[1];

typedef Byte *PByteArray;

typedef Byte TBytes[1000001];

typedef Byte *PBytes;

typedef System::TDateTime *PDateTime;

typedef Sysutils::TTimeStamp *PTimeStamp;

typedef bool *PBoolean;

typedef Word *PWordBool;

typedef void * *PVoid;

typedef char * *PPChar;

typedef System::Comp *PComp;

#pragma pack(push, 1)
struct TInt64
{
	int Data;
	int Pad;
} ;
#pragma pack(pop)

typedef __int64 *PInt64;

typedef Byte TBool;

typedef System::TVarRec TVarRecArray[255];

#pragma option push -b-
enum TBlobType { btInternal, btExternal };
#pragma option pop

#pragma pack(push, 1)
struct TBlobHandle
{
	int Ptr;
	unsigned PtrEx;
} ;
#pragma pack(pop)

typedef TBlobHandle *PBlobHandle;

#pragma pack(push, 1)
struct TRecordBlob
{
	TBlobType BlobType;
	TBlobHandle Handle;
	Byte *Data;
	int Size;
} ;
#pragma pack(pop)

typedef TRecordBlob *PRecordBlob;

#pragma pack(push, 1)
struct TRecordData
{
	Byte Signature;
	int Index;
	TZRecordType RecordType;
	Byte RowId[9];
	Db::TBookmarkFlag BookmarkFlag;
	Byte Bytes[1];
} ;
#pragma pack(pop)

typedef TRecordData *PRecordData;

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
extern PACKAGE AnsiString __fastcall StringToSql(AnsiString Value);
extern PACKAGE AnsiString __fastcall BytesToSql(AnsiString Value);
extern PACKAGE AnsiString __fastcall SqlToString(AnsiString Value);
extern PACKAGE AnsiString __fastcall SqlDateToIbDate(AnsiString Value);
extern PACKAGE AnsiString __fastcall DateTimeToIbDate(System::TDateTime Value);
extern PACKAGE AnsiString __fastcall DateToSqlIbDate(System::TDateTime Value);
extern PACKAGE Variant __fastcall SqlValueToVariant(AnsiString Value, Db::TFieldType FieldType, TDatabaseType 
	DatabaseType);
extern PACKAGE AnsiString __fastcall VariantToSqlValue(const Variant &Value, Db::TFieldType FieldType
	, TDatabaseType DatabaseType);
extern PACKAGE double __fastcall MoneyToFloat(AnsiString Value);
extern PACKAGE AnsiString __fastcall FloatToMoney(double Value);

}	/* namespace Zsqltypes */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqltypes;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlTypes
