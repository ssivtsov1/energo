// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlItems.pas' rev: 5.00

#ifndef ZSqlItemsHPP
#define ZSqlItemsHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZSqlTypes.hpp"	// Pascal unit
#include "ZList.hpp"	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqlitems
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TKeyType { ktNone, ktIndex, ktUnique, ktPrimary };
#pragma option pop

#pragma option push -b-
enum TSortType { stNone, stAscending, stDescending };
#pragma option pop

#pragma option push -b-
enum TAutoType { atNone, atAutoInc, atTimestamp, atIdentity, atGenerated };
#pragma option pop

typedef SmallString<50>  TFieldName;

#pragma pack(push, 1)
struct TFieldDesc
{
	TFieldName Table;
	TFieldName Field;
	TFieldName Alias;
	System::ShortString TypeName;
	int Index;
	int Length;
	int Decimals;
	TAutoType AutoType;
	bool IsNull;
	System::ShortString Default;
	Zsqltypes::TBlobType BlobType;
	bool ReadOnly;
	Db::TField* FieldObj;
	int DataSize;
	int Offset;
	int BlobNo;
	Db::TFieldType FieldType;
	int FieldNo;
} ;
#pragma pack(pop)

typedef TFieldDesc *PFieldDesc;

class DELPHICLASS TSqlFields;
class PASCALIMPLEMENTATION TSqlFields : public Zlist::TZItemList 
{
	typedef Zlist::TZItemList inherited;
	
private:
	PFieldDesc __fastcall GetItem(int Index);
	
public:
	__fastcall TSqlFields(void);
	HIDESBASE PFieldDesc __fastcall Add(AnsiString Table, AnsiString Field, AnsiString Alias, AnsiString 
		TypeName, Db::TFieldType FieldType, int Length, int Decimals, TAutoType AutoType, bool IsNull, bool 
		ReadOnly, AnsiString Default, Zsqltypes::TBlobType BlobType);
	PFieldDesc __fastcall AddDesc(PFieldDesc FieldDesc);
	PFieldDesc __fastcall AddField(Db::TField* Field);
	PFieldDesc __fastcall FindByName(AnsiString Table, AnsiString Field);
	PFieldDesc __fastcall FindByAlias(AnsiString Alias);
	PFieldDesc __fastcall FindByField(Db::TField* Field);
	__property PFieldDesc Items[int Index] = {read=GetItem/*, default*/};
public:
	#pragma option push -w-inl
	/* TZItemList.Destroy */ inline __fastcall virtual ~TSqlFields(void) { }
	#pragma option pop
	
};


#pragma pack(push, 1)
struct TIndexDesc
{
	TFieldName Table;
	TFieldName Name;
	TFieldName Fields[25];
	int FieldCount;
	TKeyType KeyType;
	TSortType SortType;
} ;
#pragma pack(pop)

typedef TIndexDesc *PIndexDesc;

class DELPHICLASS TSqlIndices;
class PASCALIMPLEMENTATION TSqlIndices : public Zlist::TZItemList 
{
	typedef Zlist::TZItemList inherited;
	
private:
	PIndexDesc __fastcall GetItem(int Index);
	
public:
	__fastcall TSqlIndices(void);
	void __fastcall AddIndex(AnsiString Name, AnsiString Table, AnsiString Fields, TKeyType KeyType, TSortType 
		SortType);
	PIndexDesc __fastcall FindByField(AnsiString Table, AnsiString Field);
	PIndexDesc __fastcall FindByName(AnsiString Name);
	__property PIndexDesc Items[int Index] = {read=GetItem/*, default*/};
public:
	#pragma option push -w-inl
	/* TZItemList.Destroy */ inline __fastcall virtual ~TSqlIndices(void) { }
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

}	/* namespace Zsqlitems */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqlitems;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlItems
