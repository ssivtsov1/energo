// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlScanner.pas' rev: 5.00

#ifndef ZSqlScannerHPP
#define ZSqlScannerHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZSqlTypes.hpp"	// Pascal unit
#include "ZScanner.hpp"	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqlscanner
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZSqlScanner;
class PASCALIMPLEMENTATION TZSqlScanner : public Zscanner::TZScanner 
{
	typedef Zscanner::TZScanner inherited;
	
protected:
	Zsqltypes::TDatabaseType FDatabaseType;
	virtual int __fastcall LowRunLex(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall InnerProcSqlComment(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall InnerProcSqlString(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall InnerProcSqlIdent(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall InnerProcSqlDelim(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	__fastcall virtual TZSqlScanner(void);
	virtual AnsiString __fastcall WrapString(AnsiString Value);
	virtual AnsiString __fastcall UnwrapString(AnsiString Value);
	AnsiString __fastcall ExtractSpaces();
	AnsiString __fastcall ExtractStatement(int &CurrPos, int &CurrLen, int &CurrLineNo);
	__property Zsqltypes::TDatabaseType DatabaseType = {read=FDatabaseType, nodefault};
public:
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZSqlScanner(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZIbSqlScanner;
class PASCALIMPLEMENTATION TZIbSqlScanner : public TZSqlScanner 
{
	typedef TZSqlScanner inherited;
	
public:
	__fastcall virtual TZIbSqlScanner(void);
public:
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZIbSqlScanner(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZMsSqlScanner;
class PASCALIMPLEMENTATION TZMsSqlScanner : public TZSqlScanner 
{
	typedef TZSqlScanner inherited;
	
protected:
	virtual int __fastcall InnerProcSqlComment(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	__fastcall virtual TZMsSqlScanner(void);
public:
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZMsSqlScanner(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZOraSqlScanner;
class PASCALIMPLEMENTATION TZOraSqlScanner : public TZSqlScanner 
{
	typedef TZSqlScanner inherited;
	
public:
	__fastcall virtual TZOraSqlScanner(void);
public:
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZOraSqlScanner(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZPgSqlScanner;
class PASCALIMPLEMENTATION TZPgSqlScanner : public TZSqlScanner 
{
	typedef TZSqlScanner inherited;
	
protected:
	virtual int __fastcall InnerProcSqlComment(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall InnerProcSqlString(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	__fastcall virtual TZPgSqlScanner(void);
	virtual AnsiString __fastcall WrapString(AnsiString Value);
	virtual AnsiString __fastcall UnwrapString(AnsiString Value);
public:
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZPgSqlScanner(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZMySqlScanner;
class PASCALIMPLEMENTATION TZMySqlScanner : public TZSqlScanner 
{
	typedef TZSqlScanner inherited;
	
protected:
	virtual int __fastcall InnerProcSqlComment(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall InnerProcSqlString(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	__fastcall virtual TZMySqlScanner(void);
	virtual AnsiString __fastcall WrapString(AnsiString Value);
	virtual AnsiString __fastcall UnwrapString(AnsiString Value);
public:
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZMySqlScanner(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TZSqlScanner* __fastcall CreateSqlScanner(Zsqltypes::TDatabaseType DatabaseType);

}	/* namespace Zsqlscanner */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqlscanner;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlScanner
