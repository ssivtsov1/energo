// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlScript.pas' rev: 5.00

#ifndef ZSqlScriptHPP
#define ZSqlScriptHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZSqlTypes.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqlscript
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern PACKAGE AnsiString __fastcall ShowTables(bool System, Zsqltypes::TDatabaseType DatabaseType);
	
extern PACKAGE AnsiString __fastcall ShowColumns(AnsiString TableName, Zsqltypes::TDatabaseType DatabaseType
	);
extern PACKAGE AnsiString __fastcall ShowIndex(AnsiString TableName, Zsqltypes::TDatabaseType DatabaseType
	);
extern PACKAGE bool __fastcall SkipSpaces(AnsiString &Buffer);
extern PACKAGE bool __fastcall SkipWhite(AnsiString &Buffer);
extern PACKAGE bool __fastcall SkipLine(AnsiString &Buffer);
extern PACKAGE bool __fastcall SkipRest(AnsiString &Buffer, AnsiString Delim);
extern PACKAGE bool __fastcall SkipComment(AnsiString &Buffer, Zsqltypes::TDatabaseType DatabaseType
	);
extern PACKAGE bool __fastcall SkipTerm(AnsiString &Buffer, AnsiString Term, Zsqltypes::TDatabaseType 
	DatabaseType);
extern PACKAGE AnsiString __fastcall SqlToken(AnsiString &Buffer, AnsiString Term, Zsqltypes::TDatabaseType 
	DatabaseType);
extern PACKAGE AnsiString __fastcall SqlTokenEx(AnsiString &Buffer, AnsiString Term, Zsqltypes::TDatabaseType 
	DatabaseType);
extern PACKAGE bool __fastcall SqlStartWith(AnsiString Buffer, AnsiString Value, AnsiString Term, Zsqltypes::TDatabaseType 
	DatabaseType);
extern PACKAGE bool __fastcall CmdStartWith(AnsiString Buffer, AnsiString Value);
extern PACKAGE AnsiString __fastcall ExtractSqlQuery(AnsiString &Buffer, AnsiString Term, Zsqltypes::TDatabaseType 
	DatabaseType);
extern PACKAGE bool __fastcall CheckKeyword(Zsqltypes::TDatabaseType DatabaseType, AnsiString Value)
	;
extern PACKAGE bool __fastcall SplitSelect(AnsiString Sql, Zsqltypes::TDatabaseType DatabaseType, AnsiString 
	&Select, AnsiString &From);
extern PACKAGE bool __fastcall DefineSqlPos(AnsiString Sql, Zsqltypes::TDatabaseType DatabaseType, int 
	&SelectStartPos, int &WhereStartPos, int &WherePos, int &OrderPos);
extern PACKAGE AnsiString __fastcall ComposeSelect(AnsiString Sql, AnsiString WhereAdd, AnsiString OrderAdd
	, int WhereStartPos, int WherePos, int OrderPos);
extern PACKAGE void __fastcall ExtractTables(AnsiString From, Classes::TStrings* Tables, Classes::TStrings* 
	Aliases);

}	/* namespace Zsqlscript */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqlscript;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlScript
