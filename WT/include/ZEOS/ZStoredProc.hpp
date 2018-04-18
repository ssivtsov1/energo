// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZStoredProc.pas' rev: 5.00

#ifndef ZStoredProcHPP
#define ZStoredProcHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZSqlBuffer.hpp>	// Pascal unit
#include <ZSqlParser.hpp>	// Pascal unit
#include <ZSqlItems.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <ZSqlTypes.hpp>	// Pascal unit
#include <ZDirSql.hpp>	// Pascal unit
#include <ZQuery.hpp>	// Pascal unit
#include <ZTransact.hpp>	// Pascal unit
#include <ZConnect.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zstoredproc
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TZParamBindMode { zpbByName, zpbByNumber };
#pragma option pop

class DELPHICLASS TZStoredProc;
class PASCALIMPLEMENTATION TZStoredProc : public Zquery::TZDataset 
{
	typedef Zquery::TZDataset inherited;
	
private:
	Zdirsql::TDirStoredProc* FStoredProc;
	bool FPrepared;
	AnsiString FStoredProcName;
	TZParamBindMode FParamBindMode;
	Zconnect::TZDatabase* FDatabase;
	Ztransact::TZTransact* FTransact;
	HIDESBASE void __fastcall QueryRecords(bool Force);
	bool __fastcall GetPrepared(void);
	void __fastcall SetPrepared(const bool Value);
	void __fastcall SetStoredProcName(const AnsiString Value);
	
protected:
	HIDESBASE void __fastcall SetDatabase(Zconnect::TZDatabase* Value);
	HIDESBASE void __fastcall SetTransact(Ztransact::TZTransact* Value);
	HIDESBASE void __fastcall AutoFillObjects(void);
	virtual void __fastcall CreateConnections(void);
	virtual void __fastcall InternalOpen(void);
	virtual void __fastcall InternalClose(void);
	virtual void __fastcall InternalInitFieldDefs(void);
	virtual void __fastcall InternalLast(void);
	virtual void __fastcall InternalRefresh(void);
	HIDESBASE void __fastcall InternalSort(AnsiString Fields, Zsqlitems::TSortType SortType);
	virtual void __fastcall SetRecNo(int Value);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation
		);
	HIDESBASE void __fastcall DoProgress(Zquery::TZProgressStage Stage, Zquery::TZProgressProc Proc, int 
		Position);
	virtual void __fastcall QueryParams(void);
	virtual void __fastcall GetAllRecords(void);
	virtual void __fastcall GetAllParams(const AnsiString spName) = 0 ;
	virtual int __fastcall GetRecordCount(void);
	virtual Db::TGetResult __fastcall GetRecord(char * Buffer, Db::TGetMode GetMode, bool DoCheck);
	virtual bool __fastcall FindRecord(bool Restart, bool GoForward);
	virtual bool __fastcall IsCursorOpen(void);
	__property Zconnect::TZDatabase* DatabaseObj = {read=FDatabase, write=FDatabase};
	__property Ztransact::TZTransact* TransactObj = {read=FTransact, write=FTransact};
	__property Zdirsql::TDirStoredProc* StoredProc = {read=FStoredProc, write=FStoredProc};
	
public:
	__fastcall virtual TZStoredProc(Classes::TComponent* AOwner);
	__fastcall virtual ~TZStoredProc(void);
	virtual void __fastcall Prepare(void);
	virtual void __fastcall UnPrepare(void);
	virtual void __fastcall ExecProc(void);
	__property bool Prepared = {read=GetPrepared, write=SetPrepared, nodefault};
	__property AnsiString StoredProcName = {read=FStoredProcName, write=SetStoredProcName};
	__property TZParamBindMode ParamBindMode = {read=FParamBindMode, write=FParamBindMode, nodefault};
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
static const Byte DEFAULT_STRING_SIZE = 0xfe;
static const Word MAX_STRING_SIZE = 0x200;
static const char DEFAULT_MACRO_CHAR = '\x25';
#define ZEOS_PALETTE "Zeos Common"
#define ZEOS_DB_PALETTE "Zeos Access"
static const Word ZDBO_VERSION = 0xc4e0;

}	/* namespace Zstoredproc */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zstoredproc;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZStoredProc
