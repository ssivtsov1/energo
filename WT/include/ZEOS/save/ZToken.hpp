// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZToken.pas' rev: 5.00

#ifndef ZTokenHPP
#define ZTokenHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Ztoken
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TTokenType { ttUnknown, ttDelim, ttDigit, ttAlpha, ttString, ttCommand };
#pragma option pop

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
static const char tokTAB = '\x9';
static const char tokCR = '\xd';
static const char tokNL = '\xa';
#define tokDELIM " .:;,+-<>/*%^=()[]|&~@#$\\`{}!?\n\r\t"
static const char tokSPACE = '\x20';
extern PACKAGE bool __fastcall IsDelim(char Value);
extern PACKAGE bool __fastcall IsWhite(char Value);
extern PACKAGE bool __fastcall IsDigit(char Value);
extern PACKAGE bool __fastcall IsAlpha(char Value);
extern PACKAGE bool __fastcall IsEOL(char Value);
extern PACKAGE AnsiString __fastcall ConvStr(AnsiString Value);
extern PACKAGE AnsiString __fastcall UnconvStr(AnsiString Value);
extern PACKAGE TTokenType __fastcall ExtractLowToken(AnsiString &Buffer, AnsiString &Token);
extern PACKAGE TTokenType __fastcall ExtractToken(AnsiString &Buffer, AnsiString &Token);
extern PACKAGE void __fastcall PutbackToken(AnsiString &Buffer, AnsiString Value);
extern PACKAGE AnsiString __fastcall DeleteQuotes(AnsiString &Buffer);
extern PACKAGE AnsiString __fastcall DeleteQuotesEx(AnsiString &Buffer);
extern PACKAGE AnsiString __fastcall ExtractParamByNo(AnsiString Buffer, int KeyNo);
extern PACKAGE AnsiString __fastcall ExtractParam(AnsiString Buffer, AnsiString Key);
extern PACKAGE void __fastcall SplitParams(AnsiString Buffer, Classes::TStringList* ParamNames, Classes::TStringList* 
	ParamValues);
extern PACKAGE TTokenType __fastcall ExtractHighToken(AnsiString &Buffer, Classes::TStringList* Cmds
	, AnsiString &Token, int &CmdNo);
extern PACKAGE TTokenType __fastcall ExtractTokenEx(AnsiString &Buffer, AnsiString &Token);
extern PACKAGE AnsiString __fastcall StrTok(AnsiString &Buffer, AnsiString Delim);
extern PACKAGE AnsiString __fastcall StrTokEx(AnsiString &Buffer, AnsiString Delim);

}	/* namespace Ztoken */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Ztoken;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZToken
