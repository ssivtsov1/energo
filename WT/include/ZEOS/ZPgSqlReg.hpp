// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZPgSqlReg.pas' rev: 5.00

#ifndef ZPgSqlRegHPP
#define ZPgSqlRegHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zpgsqlreg
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
extern PACKAGE void __fastcall Register(void);

}	/* namespace Zpgsqlreg */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zpgsqlreg;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZPgSqlReg
