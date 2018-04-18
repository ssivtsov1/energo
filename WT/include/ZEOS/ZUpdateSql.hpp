// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZUpdateSql.pas' rev: 5.00

#ifndef ZUpdateSqlHPP
#define ZUpdateSqlHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZSqlBuffer.hpp"	// Pascal unit
#include "ZSqlItems.hpp"	// Pascal unit
#include "ZSqlTypes.hpp"	// Pascal unit
#include "ZToken.hpp"	// Pascal unit
#include "ZExtra.hpp"	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zupdatesql
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZUpdateSql;
class PASCALIMPLEMENTATION TZUpdateSql : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	Classes::TStrings* FDeleteSql;
	Classes::TStrings* FInsertSql;
	Classes::TStrings* FModifySql;
	AnsiString FDeleteQuery;
	AnsiString FInsertQuery;
	AnsiString FModifyQuery;
	Db::TDataSet* FDataset;
	bool FParamCheck;
	Db::TParams* FParams;
	Classes::TStrings* __fastcall GetSql(Db::TUpdateKind UpdateKind);
	void __fastcall SetSql(Db::TUpdateKind UpdateKind, Classes::TStrings* Value);
	Word __fastcall GetParamsCount(void);
	AnsiString __fastcall GetParamValue(AnsiString Name);
	void __fastcall SetParamsList(Db::TParams* Value);
	void __fastcall SetParams(Db::TUpdateKind UpdateKind);
	void __fastcall SetParamCheck(bool Value);
	void __fastcall SetDeleteSql(Classes::TStrings* Value);
	void __fastcall SetInsertSql(Classes::TStrings* Value);
	void __fastcall SetModifySql(Classes::TStrings* Value);
	void __fastcall UpdateParams(void);
	
protected:
	virtual void __fastcall DefineProperties(Classes::TFiler* Filer);
	void __fastcall ReadParamData(Classes::TReader* Reader);
	void __fastcall WriteParamData(Classes::TWriter* Writer);
	
public:
	__fastcall virtual TZUpdateSql(Classes::TComponent* AOwner);
	__fastcall virtual ~TZUpdateSql(void);
	void __fastcall Apply(Db::TUpdateKind UpdateKind);
	void __fastcall ExecSql(Db::TUpdateKind UpdateKind);
	__property Db::TDataSet* DataSet = {read=FDataset, write=FDataset};
	__property Classes::TStrings* Sql[Db::TUpdateKind UpdateKind] = {read=GetSql, write=SetSql};
	__property Word ParamCount = {read=GetParamsCount, nodefault};
	
__published:
	__property Classes::TStrings* DeleteSql = {read=FDeleteSql, write=SetDeleteSql};
	__property Classes::TStrings* InsertSql = {read=FInsertSql, write=SetInsertSql};
	__property Classes::TStrings* ModifySql = {read=FModifySql, write=SetModifySql};
	__property Db::TParams* Params = {read=FParams, write=SetParamsList, stored=false};
	__property bool ParamCheck = {read=FParamCheck, write=SetParamCheck, default=0};
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

}	/* namespace Zupdatesql */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zupdatesql;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZUpdateSql
