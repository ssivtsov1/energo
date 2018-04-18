// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZExtra.pas' rev: 5.00

#ifndef ZExtraHPP
#define ZExtraHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Math.hpp>	// Pascal unit
#include <ZToken.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zextra
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
extern PACKAGE System::TDateTime __fastcall MyTimestampToDateTime(AnsiString Value);
extern PACKAGE AnsiString __fastcall MyTimestampToSqlDate(AnsiString Value);
extern PACKAGE AnsiString __fastcall MemPas(char * Buffer, int Length);
extern PACKAGE System::TDateTime __fastcall SqlDateToDateTime(AnsiString Value);
extern PACKAGE System::TDateTime __fastcall SqlDateToDateTimeEx(AnsiString Value);
extern PACKAGE AnsiString __fastcall FormatSqlDate(System::TDateTime Value);
extern PACKAGE AnsiString __fastcall FormatSqlTime(System::TDateTime Value);
extern PACKAGE AnsiString __fastcall DateTimeToSqlDate(System::TDateTime Value);
extern PACKAGE AnsiString __fastcall DateTimeToSqlDateEx(System::TDateTime Value);
extern PACKAGE bool __fastcall StrCmpEnd(AnsiString Str1, AnsiString Str2);
extern PACKAGE bool __fastcall StrCmpBegin(AnsiString Str1, AnsiString Str2);
extern PACKAGE bool __fastcall StrCaseCmp(AnsiString Str1, AnsiString Str2);
extern PACKAGE double __fastcall StrToFloatEx(AnsiString Value);
extern PACKAGE double __fastcall StrToFloatCom(AnsiString Value);
extern PACKAGE double __fastcall StrToFloatDefEx(AnsiString Value, double Default);
extern PACKAGE AnsiString __fastcall FloatToStrEx(double Value);
extern PACKAGE AnsiString __fastcall MoneyToString(double Total, AnsiString Currency, AnsiString Coin
	);
extern PACKAGE AnsiString __fastcall EncodeSqlDate(Word Year, Word Month, Word Day);
extern PACKAGE void __fastcall DecodeSqlDate(AnsiString Date, Word &Year, Word &Month, Word &Day);
extern PACKAGE AnsiString __fastcall BeginMonth(AnsiString Date);
extern PACKAGE Word __fastcall LastDay(Word Month, Word Year);
extern PACKAGE AnsiString __fastcall EndMonth(AnsiString Date);
extern PACKAGE AnsiString __fastcall PriorMonth(AnsiString Date);
extern PACKAGE AnsiString __fastcall NextMonth(AnsiString Date);
extern PACKAGE AnsiString __fastcall PriorDay(AnsiString Date);
extern PACKAGE AnsiString __fastcall NextDay(AnsiString Date);
extern PACKAGE int __fastcall Max(int A, int B);
extern PACKAGE int __fastcall Min(int A, int B);
extern PACKAGE int __fastcall Sgn(double Value);
extern PACKAGE System::Currency __fastcall StrToCurrDefEx(const AnsiString S, const System::Currency 
	Default);

}	/* namespace Zextra */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zextra;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZExtra
