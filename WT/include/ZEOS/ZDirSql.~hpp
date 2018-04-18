// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZDirSql.pas' rev: 5.00

#ifndef ZDirSqlHPP
#define ZDirSqlHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZSqlTypes.hpp>	// Pascal unit
#include <ZToken.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zdirsql
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TDirStatus { csNone, csOk, csFail, csNotImplemented };
#pragma option pop

class DELPHICLASS TDirConnect;
class PASCALIMPLEMENTATION TDirConnect : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	System::ShortString FHost;
	System::ShortString FPort;
	System::ShortString FDatabase;
	System::ShortString FLogin;
	System::ShortString FPasswd;
	bool FActive;
	TDirStatus FStatus;
	
protected:
	virtual System::ShortString __fastcall GetErrorMsg();
	void __fastcall SetActive(bool Value);
	void __fastcall SetStatus(TDirStatus Value);
	
public:
	__fastcall TDirConnect(void);
	__fastcall virtual ~TDirConnect(void);
	virtual void __fastcall Connect(void);
	virtual void __fastcall Disconnect(void);
	virtual void __fastcall CreateDatabase(AnsiString Params);
	virtual void __fastcall DropDatabase(void);
	__property System::ShortString HostName = {read=FHost, write=FHost};
	__property System::ShortString Port = {read=FPort, write=FPort};
	__property System::ShortString Database = {read=FDatabase, write=FDatabase};
	__property System::ShortString Login = {read=FLogin, write=FLogin};
	__property System::ShortString Passwd = {read=FPasswd, write=FPasswd};
	__property bool Active = {read=FActive, nodefault};
	__property System::ShortString Error = {read=GetErrorMsg};
	__property TDirStatus Status = {read=FStatus, nodefault};
};


class DELPHICLASS TDirTransact;
class PASCALIMPLEMENTATION TDirTransact : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	TDirStatus FStatus;
	TDirConnect* FConnect;
	bool FActive;
	bool FTransactSafe;
	
protected:
	virtual System::ShortString __fastcall GetErrorMsg();
	virtual TDirStatus __fastcall GetStatus(void);
	virtual void __fastcall SetStatus(TDirStatus Value);
	void __fastcall SetActive(bool Value);
	
public:
	__fastcall TDirTransact(void);
	__fastcall virtual ~TDirTransact(void);
	virtual void __fastcall Open(void);
	virtual void __fastcall Close(void);
	virtual void __fastcall StartTransaction(void);
	virtual void __fastcall EndTransaction(void);
	virtual void __fastcall Commit(void);
	virtual void __fastcall Rollback(void);
	__property TDirConnect* Connect = {read=FConnect, write=FConnect};
	__property bool TransactSafe = {read=FTransactSafe, write=FTransactSafe, nodefault};
	__property bool Active = {read=FActive, nodefault};
	__property System::ShortString Error = {read=GetErrorMsg};
	__property TDirStatus Status = {read=GetStatus, nodefault};
};


#pragma option push -b-
enum TDirQueryStatus { qsNone, qsTuplesOk, qsCommandOk, qsFail, qsNotImplemented };
#pragma option pop

class DELPHICLASS TDirQuery;
class DELPHICLASS TDirBlob;
class PASCALIMPLEMENTATION TDirQuery : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	Classes::TStringList* FLocFields;
	Classes::TStringList* FLocValues;
	bool FUseCursor;
	TDirConnect* FConnect;
	TDirTransact* FTransact;
	TDirQueryStatus FStatus;
	bool FActive;
	int FRecno;
	int FAffectedRows;
	bool FBof;
	bool FEof;
	AnsiString FSql;
	
protected:
	virtual bool __fastcall GetBof(void);
	void __fastcall SetBof(bool Value);
	virtual bool __fastcall GetEof(void);
	void __fastcall SetEof(bool Value);
	void __fastcall SetRecNo(int Value);
	void __fastcall SetActive(bool Value);
	void __fastcall SetStatus(TDirQueryStatus Value);
	void __fastcall SetAffectedRows(int Value);
	virtual System::ShortString __fastcall GetErrorMsg();
	
public:
	__fastcall TDirQuery(void);
	__fastcall virtual ~TDirQuery(void);
	virtual int __fastcall ExecuteParams(const System::TVarRec * Params, int ParamCount);
	virtual int __fastcall Execute(void);
	virtual void __fastcall Open(void);
	virtual void __fastcall Close(void);
	virtual TDirBlob* __fastcall CreateBlobObject(void);
	virtual void __fastcall ShowDatabases( System::ShortString &DatabaseName);
	virtual void __fastcall ShowTables( System::ShortString &TableName);
	virtual void __fastcall ShowColumns( System::ShortString &TableName,  System::ShortString &ColumnName
		);
	virtual void __fastcall ShowIndexes( System::ShortString &TableName);
	virtual void __fastcall First(void);
	virtual void __fastcall Last(void);
	virtual void __fastcall Prev(void);
	virtual void __fastcall Next(void);
	virtual void __fastcall Go(int Num);
	bool __fastcall Locate(AnsiString Params);
	bool __fastcall FindNext(void);
	virtual int __fastcall FieldCount(void);
	virtual int __fastcall RecordCount(void);
	virtual System::ShortString __fastcall FieldName(int FieldNum);
	virtual System::ShortString __fastcall FieldAlias(int FieldNum);
	virtual int __fastcall FieldIndex( System::ShortString &FieldName);
	virtual int __fastcall FieldSize(int FieldNum);
	virtual int __fastcall FieldMaxSize(int FieldNum);
	virtual int __fastcall FieldPrecision(int FieldNum);
	virtual int __fastcall FieldDecimals(int FieldNum);
	virtual int __fastcall FieldType(int FieldNum);
	virtual Db::TFieldType __fastcall FieldDataType(int FieldNum);
	virtual bool __fastcall FieldIsNull(int FieldNum);
	virtual bool __fastcall FieldReadOnly(int FieldNum);
	virtual AnsiString __fastcall Field(int FieldNum);
	virtual char * __fastcall FieldBuffer(int FieldNum);
	AnsiString __fastcall FieldByName( System::ShortString &FieldName);
	virtual AnsiString __fastcall StringToSql(AnsiString Value);
	__property TDirConnect* Connect = {read=FConnect, write=FConnect};
	__property TDirTransact* Transact = {read=FTransact, write=FTransact};
	__property AnsiString Sql = {read=FSql, write=FSql};
	__property bool Active = {read=FActive, nodefault};
	__property TDirQueryStatus Status = {read=FStatus, nodefault};
	__property System::ShortString Error = {read=GetErrorMsg};
	__property bool UseCursor = {read=FUseCursor, write=FUseCursor, nodefault};
	__property bool Bof = {read=GetBof, nodefault};
	__property bool Eof = {read=GetEof, nodefault};
	__property int RecNo = {read=FRecno, nodefault};
	__property int AffectedRows = {read=FAffectedRows, nodefault};
};


#pragma option push -b-
enum TDirBlobStatus { bsNone, bsOk, bsFail, bsNotImplemented };
#pragma option pop

class PASCALIMPLEMENTATION TDirBlob : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	TDirBlobStatus FStatus;
	bool FActive;
	#pragma pack(push, 1)
	Zsqltypes::TBlobHandle FHandle;
	#pragma pack(pop)
	
	TDirConnect* FConnect;
	TDirTransact* FTransact;
	void __fastcall SetStatus(TDirBlobStatus Value);
	void __fastcall SetActive(bool Value);
	void __fastcall SetHandle(const Zsqltypes::TBlobHandle &Value);
	virtual System::ShortString __fastcall GetErrorMsg();
	virtual int __fastcall GetPosition(void);
	AnsiString __fastcall GetValue();
	void __fastcall SetValue(AnsiString Value);
	
public:
	__fastcall TDirBlob(TDirConnect* AConnect, TDirTransact* ATransact, const Zsqltypes::TBlobHandle &AHandle
		);
	__fastcall virtual ~TDirBlob(void);
	virtual void __fastcall Open(int Mode);
	virtual void __fastcall Close(void);
	virtual void __fastcall CreateBlob(void);
	virtual void __fastcall DropBlob(void);
	virtual int __fastcall Read(char * Buffer, int Length);
	virtual int __fastcall Write(char * Buffer, int Length);
	virtual void __fastcall Seek(int Offset, int Origin);
	virtual void __fastcall ImportFile( System::ShortString &FileName);
	virtual void __fastcall ExportFile( System::ShortString &FileName);
	__property TDirConnect* Connect = {read=FConnect, write=FConnect};
	__property TDirTransact* Transact = {read=FTransact, write=FTransact};
	__property TDirBlobStatus Status = {read=FStatus, nodefault};
	__property bool Active = {read=FActive, nodefault};
	__property System::ShortString Error = {read=GetErrorMsg};
	__property Zsqltypes::TBlobHandle Handle = {read=FHandle, write=FHandle};
	__property int Position = {read=GetPosition, nodefault};
	__property AnsiString Value = {read=GetValue, write=SetValue};
};


#pragma option push -b-
enum TDirNotifyStatus { nsNone, nsOk, nsFail, nsNotImplemented };
#pragma option pop

class DELPHICLASS TDirNotify;
class PASCALIMPLEMENTATION TDirNotify : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	bool FActive;
	TDirConnect* FConnect;
	TDirTransact* FTransact;
	TDirNotifyStatus FStatus;
	void __fastcall SetStatus(TDirNotifyStatus Value);
	void __fastcall SetActive(bool Value);
	virtual System::ShortString __fastcall GetErrorMsg();
	
public:
	virtual void __fastcall ListenTo(AnsiString Event);
	virtual void __fastcall UnlistenTo(AnsiString Event);
	virtual void __fastcall DoNotify(AnsiString Event);
	virtual AnsiString __fastcall CheckEvents();
	__property TDirConnect* Connect = {read=FConnect, write=FConnect};
	__property TDirTransact* Transact = {read=FTransact, write=FTransact};
	__property bool Active = {read=FActive, nodefault};
	__property TDirNotifyStatus Status = {read=FStatus, nodefault};
	__property System::ShortString Error = {read=GetErrorMsg};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDirNotify(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDirNotify(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDirStoredProc;
class PASCALIMPLEMENTATION TDirStoredProc : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	Classes::TStringList* FLocFields;
	Classes::TStringList* FLocValues;
	TDirConnect* FConnect;
	TDirTransact* FTransact;
	TDirQueryStatus FStatus;
	bool FActive;
	int FRecno;
	int FAffectedRows;
	bool FBof;
	bool FEof;
	bool FPrepared;
	AnsiString FStoredProcName;
	
protected:
	virtual bool __fastcall GetBof(void);
	void __fastcall SetBof(bool Value);
	virtual bool __fastcall GetEof(void);
	void __fastcall SetEof(bool Value);
	void __fastcall SetRecNo(int Value);
	void __fastcall SetActive(bool Value);
	void __fastcall SetStatus(TDirQueryStatus Value);
	void __fastcall SetAffectedRows(int Value);
	virtual System::ShortString __fastcall GetErrorMsg();
	virtual bool __fastcall GetPrepared(void);
	virtual void __fastcall SetPrepared(const bool Value);
	
public:
	__fastcall TDirStoredProc(void);
	__fastcall virtual ~TDirStoredProc(void);
	virtual void __fastcall ExecProc(void);
	virtual void __fastcall Open(void);
	virtual void __fastcall Close(void);
	virtual TDirBlob* __fastcall CreateBlobObject(void);
	virtual void __fastcall Prepare(Db::TParams* Params);
	virtual void __fastcall UnPrepare(void);
	virtual AnsiString __fastcall GetReturnValue();
	virtual void __fastcall ShowStoredProcs(void);
	virtual void __fastcall ShowParams( System::ShortString &StoredProcedureName);
	virtual void __fastcall First(void);
	virtual void __fastcall Last(void);
	virtual void __fastcall Prev(void);
	virtual void __fastcall Next(void);
	virtual void __fastcall Go(int Num);
	bool __fastcall Locate(AnsiString Params);
	bool __fastcall FindNext(void);
	virtual int __fastcall FieldCount(void);
	virtual int __fastcall RecordCount(void);
	virtual int __fastcall ParamCount(void);
	virtual System::ShortString __fastcall FieldName(int FieldNum);
	virtual System::ShortString __fastcall FieldAlias(int FieldNum);
	virtual int __fastcall FieldIndex( System::ShortString &FieldName);
	virtual int __fastcall FieldSize(int FieldNum);
	virtual int __fastcall FieldMaxSize(int FieldNum);
	virtual int __fastcall FieldDecimals(int FieldNum);
	virtual int __fastcall FieldType(int FieldNum);
	virtual Db::TFieldType __fastcall FieldDataType(int FieldNum);
	virtual bool __fastcall FieldIsNull(int FieldNum);
	virtual AnsiString __fastcall Field(int FieldNum);
	virtual char * __fastcall FieldBuffer(int FieldNum);
	AnsiString __fastcall FieldByName( System::ShortString &FieldName);
	virtual System::ShortString __fastcall ParamName(int ParamNum);
	virtual int __fastcall ParamSize(int ParamNum);
	virtual System::ShortString __fastcall ParamAlias(int ParamNum);
	virtual int __fastcall ParamMaxSize(int ParamNum);
	virtual int __fastcall ParamDecimals(int ParamNum);
	virtual int __fastcall ParamIndex( System::ShortString &ParamName);
	virtual int __fastcall ParamType(int ParamNum);
	virtual Db::TFieldType __fastcall ParamDataType(int ParamNum);
	virtual bool __fastcall ParamIsNull(int ParamNum);
	virtual AnsiString __fastcall Param(int ParamNum);
	virtual char * __fastcall ParamBuffer(int ParamNum);
	AnsiString __fastcall ParamByName( System::ShortString &ParamName);
	virtual AnsiString __fastcall StringToSql(AnsiString Value);
	__property TDirConnect* Connect = {read=FConnect, write=FConnect};
	__property TDirTransact* Transact = {read=FTransact, write=FTransact};
	__property bool Active = {read=FActive, nodefault};
	__property TDirQueryStatus Status = {read=FStatus, nodefault};
	__property System::ShortString Error = {read=GetErrorMsg};
	__property bool Bof = {read=GetBof, nodefault};
	__property bool Eof = {read=GetEof, nodefault};
	__property int RecNo = {read=FRecno, nodefault};
	__property int AffectedRows = {read=FAffectedRows, nodefault};
	__property bool Prepared = {read=GetPrepared, write=SetPrepared, nodefault};
	__property AnsiString StoredProcName = {read=FStoredProcName, write=FStoredProcName};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Zdirsql */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zdirsql;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZDirSql
