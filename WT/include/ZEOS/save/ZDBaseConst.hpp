// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZDBaseConst.pas' rev: 5.00

#ifndef ZDBaseConstHPP
#define ZDBaseConstHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zdbaseconst
{
//-- type declarations -------------------------------------------------------
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
extern PACKAGE System::ResourceString _SLibraryNotFound;
#define Zdbaseconst_SLibraryNotFound System::LoadResourceString(&Zdbaseconst::_SLibraryNotFound)
extern PACKAGE System::ResourceString _SConnectError;
#define Zdbaseconst_SConnectError System::LoadResourceString(&Zdbaseconst::_SConnectError)
extern PACKAGE System::ResourceString _SConnectTransactError;
#define Zdbaseconst_SConnectTransactError System::LoadResourceString(&Zdbaseconst::_SConnectTransactError)
	
extern PACKAGE System::ResourceString _SDbCreateError;
#define Zdbaseconst_SDbCreateError System::LoadResourceString(&Zdbaseconst::_SDbCreateError)
extern PACKAGE System::ResourceString _SNotConnected;
#define Zdbaseconst_SNotConnected System::LoadResourceString(&Zdbaseconst::_SNotConnected)
extern PACKAGE System::ResourceString _SFieldNumberError;
#define Zdbaseconst_SFieldNumberError System::LoadResourceString(&Zdbaseconst::_SFieldNumberError)
extern PACKAGE System::ResourceString _SFieldNameError;
#define Zdbaseconst_SFieldNameError System::LoadResourceString(&Zdbaseconst::_SFieldNameError)
extern PACKAGE System::ResourceString _SFieldAliasError;
#define Zdbaseconst_SFieldAliasError System::LoadResourceString(&Zdbaseconst::_SFieldAliasError)
extern PACKAGE System::ResourceString _SFieldValuesError;
#define Zdbaseconst_SFieldValuesError System::LoadResourceString(&Zdbaseconst::_SFieldValuesError)
extern PACKAGE System::ResourceString _SQueryExecError;
#define Zdbaseconst_SQueryExecError System::LoadResourceString(&Zdbaseconst::_SQueryExecError)
extern PACKAGE System::ResourceString _SConnectNotDefined;
#define Zdbaseconst_SConnectNotDefined System::LoadResourceString(&Zdbaseconst::_SConnectNotDefined)
	
extern PACKAGE System::ResourceString _SUnknownType;
#define Zdbaseconst_SUnknownType System::LoadResourceString(&Zdbaseconst::_SUnknownType)
extern PACKAGE System::ResourceString _SBookmarkNotFound;
#define Zdbaseconst_SBookmarkNotFound System::LoadResourceString(&Zdbaseconst::_SBookmarkNotFound)
extern PACKAGE System::ResourceString _SNoMoreRec;
#define Zdbaseconst_SNoMoreRec System::LoadResourceString(&Zdbaseconst::_SNoMoreRec)
extern PACKAGE System::ResourceString _SIncorrectField;
#define Zdbaseconst_SIncorrectField System::LoadResourceString(&Zdbaseconst::_SIncorrectField)
extern PACKAGE System::ResourceString _SIntFuncError;
#define Zdbaseconst_SIntFuncError System::LoadResourceString(&Zdbaseconst::_SIntFuncError)
extern PACKAGE System::ResourceString _SIncorrectArgs;
#define Zdbaseconst_SIncorrectArgs System::LoadResourceString(&Zdbaseconst::_SIncorrectArgs)
extern PACKAGE System::ResourceString _SRefreshError;
#define Zdbaseconst_SRefreshError System::LoadResourceString(&Zdbaseconst::_SRefreshError)
extern PACKAGE System::ResourceString _STransactNotDefined;
#define Zdbaseconst_STransactNotDefined System::LoadResourceString(&Zdbaseconst::_STransactNotDefined)
	
extern PACKAGE System::ResourceString _SAllocError;
#define Zdbaseconst_SAllocError System::LoadResourceString(&Zdbaseconst::_SAllocError)
extern PACKAGE System::ResourceString _SNotInsertMode;
#define Zdbaseconst_SNotInsertMode System::LoadResourceString(&Zdbaseconst::_SNotInsertMode)
extern PACKAGE System::ResourceString _SIntBufferError;
#define Zdbaseconst_SIntBufferError System::LoadResourceString(&Zdbaseconst::_SIntBufferError)
extern PACKAGE System::ResourceString _SROCmdError;
#define Zdbaseconst_SROCmdError System::LoadResourceString(&Zdbaseconst::_SROCmdError)
extern PACKAGE System::ResourceString _SIncorrectLinks;
#define Zdbaseconst_SIncorrectLinks System::LoadResourceString(&Zdbaseconst::_SIncorrectLinks)
extern PACKAGE System::ResourceString _SCyclicLinkError;
#define Zdbaseconst_SCyclicLinkError System::LoadResourceString(&Zdbaseconst::_SCyclicLinkError)
extern PACKAGE System::ResourceString _SDetailQueryError;
#define Zdbaseconst_SDetailQueryError System::LoadResourceString(&Zdbaseconst::_SDetailQueryError)
extern PACKAGE System::ResourceString _SUnableListProp;
#define Zdbaseconst_SUnableListProp System::LoadResourceString(&Zdbaseconst::_SUnableListProp)
extern PACKAGE System::ResourceString _SReadBlobError;
#define Zdbaseconst_SReadBlobError System::LoadResourceString(&Zdbaseconst::_SReadBlobError)
extern PACKAGE System::ResourceString _SCreateBlobError;
#define Zdbaseconst_SCreateBlobError System::LoadResourceString(&Zdbaseconst::_SCreateBlobError)
extern PACKAGE System::ResourceString _SDropBlobError;
#define Zdbaseconst_SDropBlobError System::LoadResourceString(&Zdbaseconst::_SDropBlobError)
extern PACKAGE System::ResourceString _SDatasetNotDefined;
#define Zdbaseconst_SDatasetNotDefined System::LoadResourceString(&Zdbaseconst::_SDatasetNotDefined)
	
extern PACKAGE System::ResourceString _SUpdateSqlIsEmpty;
#define Zdbaseconst_SUpdateSqlIsEmpty System::LoadResourceString(&Zdbaseconst::_SUpdateSqlIsEmpty)
extern PACKAGE System::ResourceString _SFailAddNull;
#define Zdbaseconst_SFailAddNull System::LoadResourceString(&Zdbaseconst::_SFailAddNull)
extern PACKAGE System::ResourceString _SPostError;
#define Zdbaseconst_SPostError System::LoadResourceString(&Zdbaseconst::_SPostError)
extern PACKAGE System::ResourceString _SNotifyRegister;
#define Zdbaseconst_SNotifyRegister System::LoadResourceString(&Zdbaseconst::_SNotifyRegister)
extern PACKAGE System::ResourceString _SEventLength;
#define Zdbaseconst_SEventLength System::LoadResourceString(&Zdbaseconst::_SEventLength)
extern PACKAGE System::ResourceString _SConstraintFailed;
#define Zdbaseconst_SConstraintFailed System::LoadResourceString(&Zdbaseconst::_SConstraintFailed)

}	/* namespace Zdbaseconst */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zdbaseconst;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZDBaseConst
