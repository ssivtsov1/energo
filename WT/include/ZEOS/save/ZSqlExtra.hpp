// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlExtra.pas' rev: 5.00

#ifndef ZSqlExtraHPP
#define ZSqlExtraHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Db.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqlextra
{
//-- type declarations -------------------------------------------------------
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
extern PACKAGE AnsiString __fastcall ExtractField(AnsiString Value);
extern PACKAGE int __fastcall ExtractPrecision(AnsiString Value);
extern PACKAGE AnsiString __fastcall ClearSpaces(AnsiString Value);
extern PACKAGE int __fastcall CaseIndexOf(Classes::TStrings* List, AnsiString Value);
extern PACKAGE int __fastcall FieldIndexOf(AnsiString List, AnsiString Field);
extern PACKAGE AnsiString __fastcall InvertList(AnsiString List);

}	/* namespace Zsqlextra */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqlextra;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlExtra
