// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZPgSqlProp.pas' rev: 5.00

#ifndef ZPgSqlPropHPP
#define ZPgSqlPropHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <DsgnIntf.hpp>	// Pascal unit
#include <ZProperty.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zpgsqlprop
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZPgSqlTableNameProperty;
class PASCALIMPLEMENTATION TZPgSqlTableNameProperty : public Zproperty::TDbPropertyEditor 
{
	typedef Zproperty::TDbPropertyEditor inherited;
	
public:
	virtual void __fastcall GetValueList(Classes::TStringList* Values);
public:
	#pragma option push -w-inl
	/* TDbPropertyEditor.Destory */ inline __fastcall ~TZPgSqlTableNameProperty(void) { }
	#pragma option pop
	
protected:
	#pragma option push -w-inl
	/* TPropertyEditor.Create */ inline __fastcall virtual TZPgSqlTableNameProperty(const Dsgnintf::_di_IFormDesigner 
		ADesigner, int APropCount) : Zproperty::TDbPropertyEditor(ADesigner, APropCount) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TZPgSqlTableNameProperty(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZPgSqlDatabaseNameProperty;
class PASCALIMPLEMENTATION TZPgSqlDatabaseNameProperty : public Zproperty::TDbPropertyEditor 
{
	typedef Zproperty::TDbPropertyEditor inherited;
	
public:
	virtual void __fastcall GetValueList(Classes::TStringList* Values);
public:
	#pragma option push -w-inl
	/* TDbPropertyEditor.Destory */ inline __fastcall ~TZPgSqlDatabaseNameProperty(void) { }
	#pragma option pop
	
protected:
	#pragma option push -w-inl
	/* TPropertyEditor.Create */ inline __fastcall virtual TZPgSqlDatabaseNameProperty(const Dsgnintf::_di_IFormDesigner 
		ADesigner, int APropCount) : Zproperty::TDbPropertyEditor(ADesigner, APropCount) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TZPgSqlDatabaseNameProperty(void) { }
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

}	/* namespace Zpgsqlprop */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zpgsqlprop;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZPgSqlProp
