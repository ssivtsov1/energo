// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZBlobStream.pas' rev: 5.00

#ifndef ZBlobStreamHPP
#define ZBlobStreamHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZSqlItems.hpp"	// Pascal unit
#include "ZDirSql.hpp"	// Pascal unit
#include "ZSqlTypes.hpp"	// Pascal unit
#include <DBCommon.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zblobstream
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZMemoStream;
class PASCALIMPLEMENTATION TZMemoStream : public Classes::TStream
{
	typedef Classes::TStream inherited;

protected:
	Zsqlitems::TFieldDesc *FFieldDesc;
	Db::TDataSet* FDataSet;
	Zsqltypes::TRecordData *FRecordData;
	Zsqltypes::TRecordBlob *FRecordBlob;
	Db::TBlobStreamMode FMode;
	bool FOpened;
	bool FModified;
	int FPosition;
	virtual int __fastcall GetBlobSize(void);
	
public:
	__fastcall TZMemoStream(Db::TBlobField* Field, Db::TBlobStreamMode Mode);
	__fastcall virtual ~TZMemoStream(void);
	virtual int __fastcall Read(void *Buffer, int Count);
	virtual int __fastcall Write(const void *Buffer, int Count);
	virtual int __fastcall Seek(int Offset, Word Origin);
	virtual void __fastcall Truncate(void);
};


class DELPHICLASS TZBlobStream;
class PASCALIMPLEMENTATION TZBlobStream : public TZMemoStream 
{
	typedef TZMemoStream inherited;
	
protected:
	Zdirsql::TDirBlob* FBlob;
	void __fastcall CopyBlob(void);
	void __fastcall DuplicateBlob(Zsqltypes::PRecordData CopyRecordData);
	
public:
	__fastcall TZBlobStream(Db::TBlobField* Field, Db::TBlobStreamMode Mode, Zdirsql::TDirBlob* Blob);
	__fastcall virtual ~TZBlobStream(void);
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
extern PACKAGE void __fastcall ReadBlob(Zdirsql::TDirBlob* Blob, char * &Buffer, int &Size);
extern PACKAGE void __fastcall CreateBlob(Zdirsql::TDirBlob* Blob, char * Buffer, int Size);
extern PACKAGE void __fastcall DeleteBlob(Zdirsql::TDirBlob* Blob);
extern PACKAGE void __fastcall WriteBlob(Zdirsql::TDirBlob* Blob, char * Buffer, int Size);

}	/* namespace Zblobstream */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zblobstream;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZBlobStream
