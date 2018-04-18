// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlBuffer.pas' rev: 5.00

#ifndef ZSqlBufferHPP
#define ZSqlBufferHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZList.hpp"	// Pascal unit
#include "ZSqlItems.hpp"	// Pascal unit
#include "ZSqlTypes.hpp"	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqlbuffer
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TSqlBuffer;
class PASCALIMPLEMENTATION TSqlBuffer : public Zlist::TZItemList 
{
	typedef Zlist::TZItemList inherited;
	
private:
	bool FIsCache;
	int FBlobCount;
	int FRecBufSize;
	int FLastIndex;
	Zsqlitems::TSqlFields* FSqlFields;
	Zsqlitems::TSqlIndices* FSqlIndices;
	Db::TDataSet* FDataset;
	int FSortFields[256];
	int FSortFieldCount;
	Zsqlitems::TSortType FSortType;
	bool FIsSortInverse;
	int FFilterFields[256];
	int FFilterFieldCount;
	Zsqltypes::TZUpdateRecordTypes FFilterTypes;
	Zsqltypes::TRecordData *FFilterBuffer;
	Zsqltypes::PRecordData __fastcall GetItem(int Index);
	int __fastcall GetRecordSize(void);
	int __fastcall GetRecBufSize(void);
	int __fastcall GetFilterFields(int Index);
	void __fastcall SetFilterFields(int Index, int Value);
	int __fastcall GetSortFields(int Index);
	void __fastcall SetSortFields(int Index, int Value);
	
protected:
	void __fastcall DoProgress(int Stage, int Proc, int Position, int Max);
	void __fastcall UpdateBufferSize(void);
	int __fastcall SortRecord(void * Item1, void * Item2);
	bool __fastcall FilterRecord(void * Item);
	
public:
	__fastcall TSqlBuffer(Db::TDataSet* Dataset);
	__fastcall TSqlBuffer(TSqlBuffer* SqlBuffer);
	__fastcall virtual ~TSqlBuffer(void);
	void __fastcall SetCache(TSqlBuffer* SqlBuffer);
	void __fastcall SetSort(AnsiString Fields, Zsqlitems::TSortType SortType);
	void __fastcall SortInverse(void);
	void __fastcall SortRestore(void);
	void __fastcall ClearBuffer(bool Force);
	HIDESBASE Zsqltypes::PRecordData __fastcall Add(void);
	HIDESBASE Zsqltypes::PRecordData __fastcall Insert(int Index);
	HIDESBASE Zsqltypes::PRecordData __fastcall Delete(int Index);
	int __fastcall IndexOfIndex(int Index);
	int __fastcall SafeIndexOfIndex(int Index);
	bool __fastcall GetFieldData(Zsqlitems::PFieldDesc FieldDesc, void * Buffer, Zsqltypes::PRecordData 
		RecordData);
	void __fastcall SetFieldData(Zsqlitems::PFieldDesc FieldDesc, void * Buffer, Zsqltypes::PRecordData 
		RecordData);
	void __fastcall SetFieldDataLen(Zsqlitems::PFieldDesc FieldDesc, void * Buffer, Zsqltypes::PRecordData 
		RecordData, int Length);
	Variant __fastcall GetFieldValue(Zsqlitems::PFieldDesc FieldDesc, Zsqltypes::PRecordData RecordData
		);
	void __fastcall SetFieldValue(Zsqlitems::PFieldDesc FieldDesc, const Variant &Value, Zsqltypes::PRecordData 
		RecordData);
	AnsiString __fastcall GetField(Zsqlitems::PFieldDesc FieldDesc, Zsqltypes::PRecordData RecordData);
		
	void __fastcall SetField(Zsqlitems::PFieldDesc FieldDesc, AnsiString Value, Zsqltypes::PRecordData 
		RecordData);
	bool __fastcall GetFieldNull(Zsqlitems::PFieldDesc FieldDesc, Zsqltypes::PRecordData RecordData);
	void __fastcall SetFieldNull(Zsqlitems::PFieldDesc FieldDesc, bool Value, Zsqltypes::PRecordData RecordData
		);
	void __fastcall InitRecord(Zsqltypes::PRecordData Value);
	void __fastcall CopyRecord(Zsqltypes::PRecordData Source, Zsqltypes::PRecordData Dest, bool Force);
		
	void __fastcall FreeRecord(Zsqltypes::PRecordData Value, bool Clear);
	void __fastcall BindFields(Zsqlitems::TSqlFields* SqlFields);
	void __fastcall BindIndices(Db::TIndexDefs* Indices, Zsqlitems::TSqlIndices* SqlIndices);
	void __fastcall ProcessFieldList(AnsiString Fields, int * FieldList, int &FieldCount);
	int __fastcall CompareRecord(Zsqltypes::PRecordData Item1, Zsqltypes::PRecordData Item2, int * FieldList
		, int &FieldCount);
	__property Db::TDataSet* Dataset = {read=FDataset, write=FDataset};
	__property Zsqltypes::PRecordData Items[int Index] = {read=GetItem/*, default*/};
	__property Zsqlitems::TSqlFields* SqlFields = {read=FSqlFields};
	__property Zsqlitems::TSqlIndices* SqlIndices = {read=FSqlIndices};
	__property int BlobCount = {read=FBlobCount, nodefault};
	__property int RecBufSize = {read=GetRecBufSize, nodefault};
	__property int RecordSize = {read=GetRecordSize, nodefault};
	__property int SortFields[int Index] = {read=GetSortFields, write=SetSortFields};
	__property int SortFieldCount = {read=FSortFieldCount, write=FSortFieldCount, nodefault};
	__property Zsqlitems::TSortType SortType = {read=FSortType, write=FSortType, nodefault};
	__property bool IsSortInverse = {read=FIsSortInverse, write=FIsSortInverse, nodefault};
	__property int FilterFields[int Index] = {read=GetFilterFields, write=SetFilterFields};
	__property int FilterFieldCount = {read=FFilterFieldCount, write=FFilterFieldCount, nodefault};
	__property Zsqltypes::PRecordData FilterBuffer = {read=FFilterBuffer, write=FFilterBuffer};
	__property Zsqltypes::TZUpdateRecordTypes FilterTypes = {read=FFilterTypes, write=FFilterTypes, nodefault
		};
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
static const Shortint RecInfoSize = 0x10;

}	/* namespace Zsqlbuffer */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqlbuffer;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlBuffer
