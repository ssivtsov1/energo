// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZSqlParser.pas' rev: 5.00

#ifndef ZSqlParserHPP
#define ZSqlParserHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZSqlItems.hpp>	// Pascal unit
#include <ZSqlTypes.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zsqlparser
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TSqlParser;
class PASCALIMPLEMENTATION TSqlParser : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	Db::TDataSet* FDataset;
	Classes::TStrings* FSql;
	Classes::TStrings* FTables;
	Classes::TStrings* FAliases;
	Zsqlitems::TSqlFields* FSqlFields;
	Zsqlitems::TSqlIndices* FSqlIndices;
	bool FIsSelect;
	AnsiString FText;
	AnsiString FExtraWhere;
	int FSelectStartPos;
	int FWhereStartPos;
	int FWherePos;
	AnsiString FExtraOrderBy;
	int FOrderPos;
	bool FUsedRowId;
	void __fastcall SetSql(Classes::TStrings* Value);
	void __fastcall SetDataset(Db::TDataSet* Value);
	AnsiString __fastcall GetText();
	void __fastcall QueryChanged(System::TObject* Sender);
	AnsiString __fastcall ProcessAttribute(AnsiString Value);
	void __fastcall DefineField(AnsiString Table, AnsiString Field, AnsiString Alias);
	void __fastcall DefineTableFields(AnsiString Table);
	
protected:
	void __fastcall ProcessParams(Db::TParams* Params, AnsiString EscapeChar, bool ProcessAsIs);
	
public:
	__fastcall TSqlParser(Db::TDataSet* Dataset);
	__fastcall virtual ~TSqlParser(void);
	AnsiString __fastcall ExtraFilter();
	void __fastcall UpdateText(void);
	void __fastcall DefineTableDefs(void);
	void __fastcall UpdateIndexDefs(Db::TIndexDefs* IndexDefs);
	void __fastcall Clear(void);
	__property Db::TDataSet* Dataset = {read=FDataset, write=SetDataset};
	__property Zsqlitems::TSqlFields* SqlFields = {read=FSqlFields};
	__property Zsqlitems::TSqlIndices* SqlIndices = {read=FSqlIndices};
	__property Classes::TStrings* Tables = {read=FTables};
	__property Classes::TStrings* Aliases = {read=FAliases};
	__property Classes::TStrings* Sql = {read=FSql, write=SetSql};
	__property AnsiString ExtraWhere = {read=FExtraWhere, write=FExtraWhere};
	__property AnsiString ExtraOrderBy = {read=FExtraOrderBy, write=FExtraOrderBy};
	__property bool UsedRowId = {read=FUsedRowId, nodefault};
	__property AnsiString Text = {read=GetText};
	__property bool IsSelect = {read=FIsSelect, nodefault};
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
extern PACKAGE void __fastcall CreateParams(Db::TParams* List, AnsiString Value, char EscapeChar);

}	/* namespace Zsqlparser */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zsqlparser;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZSqlParser
