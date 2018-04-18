// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZDirPgSql.pas' rev: 5.00

#ifndef ZDirPgSqlHPP
#define ZDirPgSqlHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZToken.hpp>	// Pascal unit
#include <ZSqlExtra.hpp>	// Pascal unit
#include <ZSqlTypes.hpp>	// Pascal unit
#include <ZTransact.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <ZLibPgSql.hpp>	// Pascal unit
#include <ZDirSql.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zdirpgsql
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TDirPgSqlConnect;
class PASCALIMPLEMENTATION TDirPgSqlConnect : public Zdirsql::TDirConnect 
{
	typedef Zdirsql::TDirConnect inherited;
	
private:
	AnsiString FError;
	
protected:
	virtual System::ShortString __fastcall GetErrorMsg();
	
public:
	__fastcall TDirPgSqlConnect(void);
	__fastcall virtual ~TDirPgSqlConnect(void);
	virtual void __fastcall Connect(void);
	virtual void __fastcall Disconnect(void);
	virtual void __fastcall CreateDatabase(AnsiString Params);
	virtual void __fastcall DropDatabase(void);
	AnsiString __fastcall GetConnectStr(AnsiString Db);
};


#pragma option push -b-
enum TZPgSqlTransIsolation { ptDefault, ptReadCommitted, ptRepeatableRead };
#pragma option pop

class DELPHICLASS TDirPgSqlTransact;
class PASCALIMPLEMENTATION TDirPgSqlTransact : public Zdirsql::TDirTransact 
{
	typedef Zdirsql::TDirTransact inherited;
	
private:
	void *FHandle;
	AnsiString FError;
	Classes::TStringList* FTypeList;
	AnsiString FNotice;
	TZPgSqlTransIsolation FTransIsolation;
	bool FNewStyleTransactions;
	
protected:
	virtual System::ShortString __fastcall GetErrorMsg();
	System::ShortString __fastcall GetTypeName(int TypeNum);
	int __fastcall GetPid(void);
	virtual Zdirsql::TDirStatus __fastcall GetStatus(void);
	
public:
	__fastcall TDirPgSqlTransact(TDirPgSqlConnect* AConnect);
	__fastcall virtual ~TDirPgSqlTransact(void);
	virtual void __fastcall Open(void);
	virtual void __fastcall Close(void);
	virtual void __fastcall StartTransaction(void);
	virtual void __fastcall EndTransaction(void);
	virtual void __fastcall Commit(void);
	virtual void __fastcall Rollback(void);
	void __fastcall Reset(void);
	__property void * Handle = {read=FHandle};
	__property int Pid = {read=GetPid, nodefault};
	__property AnsiString Notice = {read=FNotice, write=FNotice};
	__property TZPgSqlTransIsolation TransIsolation = {read=FTransIsolation, write=FTransIsolation, nodefault
		};
	__property bool NewStyleTransactions = {read=FNewStyleTransactions, write=FNewStyleTransactions, nodefault
		};
};


class DELPHICLASS TDirPgSqlQuery;
class PASCALIMPLEMENTATION TDirPgSqlQuery : public Zdirsql::TDirQuery 
{
	typedef Zdirsql::TDirQuery inherited;
	
protected:
	void *FHandle;
	int FLastInsertOid;
	AnsiString FCursorName;
	virtual System::ShortString __fastcall GetErrorMsg();
	
public:
	__fastcall TDirPgSqlQuery(TDirPgSqlConnect* AConnect, TDirPgSqlTransact* ATransact);
	virtual int __fastcall Execute(void);
	virtual void __fastcall Open(void);
	virtual void __fastcall Close(void);
	virtual Zdirsql::TDirBlob* __fastcall CreateBlobObject(void);
	virtual void __fastcall First(void);
	virtual void __fastcall Last(void);
	virtual void __fastcall Prev(void);
	virtual void __fastcall Next(void);
	virtual void __fastcall Go(int Num);
	virtual void __fastcall ShowDatabases( System::ShortString &DatabaseName);
	virtual void __fastcall ShowTables( System::ShortString &TableName);
	virtual void __fastcall ShowColumns( System::ShortString &TableName,  System::ShortString &ColumnName
		);
	virtual void __fastcall ShowIndexes( System::ShortString &TableName);
	virtual int __fastcall FieldCount(void);
	virtual int __fastcall RecordCount(void);
	virtual System::ShortString __fastcall FieldName(int FieldNum);
	virtual int __fastcall FieldSize(int FieldNum);
	virtual int __fastcall FieldMaxSize(int FieldNum);
	virtual int __fastcall FieldType(int FieldNum);
	virtual Db::TFieldType __fastcall FieldDataType(int FieldNum);
	virtual bool __fastcall FieldIsNull(int FieldNum);
	virtual AnsiString __fastcall Field(int FieldNum);
	virtual char * __fastcall FieldBuffer(int FieldNum);
	int __fastcall FieldMinSize(int FieldNum);
	System::ShortString __fastcall FieldTypeName(int FieldNum);
	virtual AnsiString __fastcall StringToSql(AnsiString Value);
	__property void * Handle = {read=FHandle};
	__property int LastInsertOid = {read=FLastInsertOid, nodefault};
	__property AnsiString CursorName = {read=FCursorName, write=FCursorName};
public:
	#pragma option push -w-inl
	/* TDirQuery.Destroy */ inline __fastcall virtual ~TDirPgSqlQuery(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDirPgSqlBlob;
class PASCALIMPLEMENTATION TDirPgSqlBlob : public Zdirsql::TDirBlob 
{
	typedef Zdirsql::TDirBlob inherited;
	
private:
	int FBlobHandle;
	
protected:
	virtual int __fastcall GetPosition(void);
	
public:
	__fastcall TDirPgSqlBlob(TDirPgSqlConnect* AConnect, TDirPgSqlTransact* ATransact, const Zsqltypes::TBlobHandle 
		&AHandle);
	virtual void __fastcall Open(int Mode);
	virtual void __fastcall Close(void);
	virtual void __fastcall CreateBlob(void);
	virtual void __fastcall DropBlob(void);
	virtual int __fastcall Read(char * Buffer, int Length);
	virtual int __fastcall Write(char * Buffer, int Length);
	virtual void __fastcall Seek(int Offset, int Origin);
	virtual void __fastcall ImportFile( System::ShortString &FileName);
	virtual void __fastcall ExportFile( System::ShortString &FileName);
	__property int BlobHandle = {read=FBlobHandle, nodefault};
public:
	#pragma option push -w-inl
	/* TDirBlob.Destroy */ inline __fastcall virtual ~TDirPgSqlBlob(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDirPgSqlNotify;
class PASCALIMPLEMENTATION TDirPgSqlNotify : public Zdirsql::TDirNotify 
{
	typedef Zdirsql::TDirNotify inherited;
	
protected:
	Zlibpgsql::PGnotify *FHandle;
	TDirPgSqlQuery* FQuery;
	void __fastcall InternalExec(AnsiString Sql);
	
public:
	__fastcall TDirPgSqlNotify(TDirPgSqlConnect* AConnect, TDirPgSqlTransact* ATransact);
	__fastcall virtual ~TDirPgSqlNotify(void);
	virtual void __fastcall ListenTo(AnsiString Event);
	virtual void __fastcall UnlistenTo(AnsiString Event);
	virtual void __fastcall DoNotify(AnsiString Event);
	virtual AnsiString __fastcall CheckEvents();
	__property Zlibpgsql::PPGnotify Handle = {read=FHandle};
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
extern PACKAGE Ztransact::TZMonitorList* MonitorList;
extern PACKAGE Db::TFieldType __fastcall PgSqlToDelphiType(AnsiString Value, int &Size, Db::TFieldType 
	&ArraySubType, Zsqltypes::TBlobType &BlobType);

}	/* namespace Zdirpgsql */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zdirpgsql;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZDirPgSql
