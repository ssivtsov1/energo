// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZConnect.pas' rev: 5.00

#ifndef ZConnectHPP
#define ZConnectHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include "ZConvert.hpp"	// Pascal unit
#include "ZDirSql.hpp"	// Pascal unit
#include "ZToken.hpp"	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zconnect
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TZDatabaseOption { coHourGlass };
#pragma option pop

typedef Set<TZDatabaseOption, coHourGlass, coHourGlass>  TZDatabaseOptions;

class DELPHICLASS TZDatabase;
class PASCALIMPLEMENTATION TZDatabase : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
protected:
	AnsiString FDatabase;
	AnsiString FLogin;
	AnsiString FPasswd;
	AnsiString FHost;
	AnsiString FPort;
	Classes::TList* FDatasets;
	Classes::TList* FTransacts;
	bool FConnected;
	bool FLoginPrompt;
	Zconvert::TEncodingType FEncoding;
	Zdirsql::TDirConnect* FHandle;
	TZDatabaseOptions FOptions;
	int FVersion;
	Classes::TNotifyEvent FBeforeConnect;
	Classes::TNotifyEvent FBeforeDisconnect;
	Classes::TNotifyEvent FBeforeCreate;
	Classes::TNotifyEvent FBeforeDrop;
	Classes::TNotifyEvent FAfterDisconnect;
	Classes::TNotifyEvent FAfterConnect;
	Classes::TNotifyEvent FAfterCreate;
	Classes::TNotifyEvent FAfterDrop;
	void __fastcall SetConnected(bool Value);
	void __fastcall SetHost(AnsiString Value);
	void __fastcall SetDatabase(AnsiString Value);
	System::TObject* __fastcall GetTransacts(int Index);
	int __fastcall GetTransactCount(void);
	Classes::TComponent* __fastcall GetDefaultTransact(void);
	System::TObject* __fastcall GetDatasets(int Index);
	int __fastcall GetDatasetCount(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall DoBeforeConnect(void);
	virtual void __fastcall DoAfterConnect(void);
	virtual void __fastcall DoBeforeDisconnect(void);
	virtual void __fastcall DoAfterDisconnect(void);
	virtual void __fastcall DoBeforeCreate(void);
	virtual void __fastcall DoAfterCreate(void);
	virtual void __fastcall DoBeforeDrop(void);
	virtual void __fastcall DoAfterDrop(void);
	__property AnsiString Port = {read=FPort, write=FPort};
	
public:
	__fastcall virtual TZDatabase(Classes::TComponent* AOwner);
	__fastcall virtual ~TZDatabase(void);
	virtual void __fastcall Connect(void);
	virtual void __fastcall Disconnect(void);
	virtual void __fastcall CreateDatabase(AnsiString Params);
	virtual void __fastcall DropDatabase(void);
	virtual void __fastcall GetTableNames(AnsiString Pattern, bool SystemTables, Classes::TStrings* List
		);
	virtual void __fastcall GetFieldNames(const AnsiString TableName, Classes::TStrings* List);
	void __fastcall AddTransaction(System::TObject* Transact);
	void __fastcall RemoveTransaction(System::TObject* Transact);
	void __fastcall OpenTransactions(void);
	void __fastcall CloseTransactions(void);
	void __fastcall AddDataset(System::TObject* Dataset);
	void __fastcall RemoveDataset(System::TObject* Dataset);
	void __fastcall OpenActiveDatasets(void);
	void __fastcall CloseDatasets(void);
	__property Zdirsql::TDirConnect* Handle = {read=FHandle};
	__property AnsiString Host = {read=FHost, write=SetHost};
	__property AnsiString Database = {read=FDatabase, write=SetDatabase};
	__property AnsiString Login = {read=FLogin, write=FLogin};
	__property AnsiString Password = {read=FPasswd, write=FPasswd};
	__property bool LoginPrompt = {read=FLoginPrompt, write=FLoginPrompt, nodefault};
	__property TZDatabaseOptions Options = {read=FOptions, write=FOptions, nodefault};
	__property bool Connected = {read=FConnected, write=SetConnected, nodefault};
	__property Zconvert::TEncodingType Encoding = {read=FEncoding, write=FEncoding, nodefault};
	__property System::TObject* Transactions[int Index] = {read=GetTransacts};
	__property int TransactionCount = {read=GetTransactCount, nodefault};
	__property Classes::TComponent* DefaultTransaction = {read=GetDefaultTransact};
	__property System::TObject* Datasets[int Index] = {read=GetDatasets};
	__property int DatasetCount = {read=GetDatasetCount, nodefault};
	
__published:
	__property int Version = {read=FVersion, nodefault};
	__property Classes::TNotifyEvent BeforeConnect = {read=FBeforeConnect, write=FBeforeConnect};
	__property Classes::TNotifyEvent AfterConnect = {read=FAfterConnect, write=FAfterConnect};
	__property Classes::TNotifyEvent BeforeDisconnect = {read=FBeforeDisconnect, write=FBeforeDisconnect
		};
	__property Classes::TNotifyEvent AfterDisconnect = {read=FAfterDisconnect, write=FAfterDisconnect};
		
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

}	/* namespace Zconnect */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zconnect;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZConnect
