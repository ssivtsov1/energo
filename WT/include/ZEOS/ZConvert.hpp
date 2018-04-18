// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZConvert.pas' rev: 5.00

#ifndef ZConvertHPP
#define ZConvertHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zconvert
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TEncodingType { etNone, et866, etKoi8r, etKoi8u, etCp1251, etIso88592, etCp1250 };
#pragma option pop

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE AnsiString __fastcall Convert(const AnsiString Value, TEncodingType SrcEnc, TEncodingType 
	DestEnc);

}	/* namespace Zconvert */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zconvert;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZConvert
