// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZPgSqlCon.pas' rev: 5.00

#ifndef ZPgSqlConHPP
#define ZPgSqlConHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZConvert.hpp"	// Pascal unit
#include "ZDirPgSql.hpp"	// Pascal unit
#include "ZConnect.hpp"	// Pascal unit
#include "Classes.hpp"	// Pascal unit
#include "SysInit.hpp"	// Pascal unit
#include "System.hpp"	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zpgsqlcon
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZPgSqlDatabase;
class PASCALIMPLEMENTATION TZPgSqlDatabase : public Zconnect::TZDatabase 
{
	typedef Zconnect::TZDatabase inherited;
	
public:
	__fastcall virtual TZPgSqlDatabase(Classes::TComponent* AOwner);
	
__published:
	__property Host ;
	__property Port ;
	__property Database ;
	__property Encoding ;
	__property Login ;
	__property Password ;
	__property LoginPrompt ;
	__property Connected ;
public:
	#pragma option push -w-inl
	/* TZDatabase.Destroy */ inline __fastcall virtual ~TZPgSqlDatabase(void) { }
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

}	/* namespace Zpgsqlcon */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zpgsqlcon;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZPgSqlCon
