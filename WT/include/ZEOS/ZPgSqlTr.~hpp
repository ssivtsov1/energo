// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZPgSqlTr.pas' rev: 5.00

#ifndef ZPgSqlTrHPP
#define ZPgSqlTrHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZDBaseConst.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <ZSqlTypes.hpp>	// Pascal unit
#include <ZLibPgSql.hpp>	// Pascal unit
#include <ZTransact.hpp>	// Pascal unit
#include <ZPgSqlCon.hpp>	// Pascal unit
#include <ZDirPgSql.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zpgsqltr
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZPgSqlTransact;
class PASCALIMPLEMENTATION TZPgSqlTransact : public Ztransact::TZTransact 
{
	typedef Ztransact::TZTransact inherited;
	
private:
	AnsiString FNotice;
	Zpgsqlcon::TZPgSqlDatabase* __fastcall GetDatabase(void);
	int __fastcall GetPID(void);
	HIDESBASE void __fastcall SetDatabase(Zpgsqlcon::TZPgSqlDatabase* Value);
	int __fastcall GetLastInsertOid(void);
	Zdirpgsql::TZPgSqlTransIsolation __fastcall GetTransIsolation(void);
	void __fastcall SetTransIsolation(const Zdirpgsql::TZPgSqlTransIsolation Value);
	bool __fastcall GetNewStyleTransactions(void);
	void __fastcall SetNewStyleTransactions(const bool Value);
	
public:
	__fastcall virtual TZPgSqlTransact(Classes::TComponent* AOwner);
	virtual void __fastcall Connect(void);
	virtual void __fastcall Recovery(bool Force);
	void __fastcall Reset(void);
	virtual int __fastcall ExecSql(WideString Sql);
	virtual void __fastcall AddMonitor(Ztransact::TZMonitor* Monitor);
	virtual void __fastcall DeleteMonitor(Ztransact::TZMonitor* Monitor);
	__property int PID = {read=GetPID, nodefault};
	__property int LastInsertOid = {read=GetLastInsertOid, nodefault};
	__property AnsiString Notice = {read=FNotice};
	
__published:
	__property Zpgsqlcon::TZPgSqlDatabase* Database = {read=GetDatabase, write=SetDatabase};
	__property AutoRecovery ;
	__property TransactSafe ;
	__property Zdirpgsql::TZPgSqlTransIsolation TransIsolation = {read=GetTransIsolation, write=SetTransIsolation
		, nodefault};
	__property bool NewStyleTransactions = {read=GetNewStyleTransactions, write=SetNewStyleTransactions
		, default=0};
public:
	#pragma option push -w-inl
	/* TZTransact.Destroy */ inline __fastcall virtual ~TZPgSqlTransact(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZPgSqlNotify;
class PASCALIMPLEMENTATION TZPgSqlNotify : public Ztransact::TZNotify 
{
	typedef Ztransact::TZNotify inherited;
	
private:
	Zpgsqlcon::TZPgSqlDatabase* FDatabase;
	
protected:
	virtual void __fastcall Disconnect(System::TObject* Sender);
	virtual void __fastcall SetDatabase(Zpgsqlcon::TZPgSqlDatabase* Value);
	
public:
	__fastcall virtual TZPgSqlNotify(Classes::TComponent* AOwner);
	__fastcall virtual ~TZPgSqlNotify(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation
		);
	
__published:
	__property Zpgsqlcon::TZPgSqlDatabase* Database = {read=FDatabase, write=SetDatabase};
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

}	/* namespace Zpgsqltr */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zpgsqltr;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZPgSqlTr
