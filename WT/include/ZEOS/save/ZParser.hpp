// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZParser.pas' rev: 5.00

#ifndef ZParserHPP
#define ZParserHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Math.hpp>	// Pascal unit
#include <ZMatch.hpp>	// Pascal unit
#include <ZToken.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zparser
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TParseItemType { ptFunction, ptVariable, ptDelim, ptString, ptInteger, ptFloat, ptBoolean };
#pragma option pop

struct TParseItem
{
	Variant ItemValue;
	TParseItemType ItemType;
} ;

typedef Variant TParseStack[101];

struct TParseVar
{
	AnsiString VarName;
	Variant VarValue;
} ;

class DELPHICLASS TZParser;
typedef Variant __fastcall (*TParseFunc)(TZParser* Sender);

struct TParseFuncRec
{
	AnsiString FuncName;
	TParseFunc FuncPtr;
} ;

class DELPHICLASS EParseException;
class PASCALIMPLEMENTATION EParseException : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EParseException(const AnsiString Msg) : Sysutils::Exception(
		Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EParseException(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EParseException(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EParseException(int Ident, const System::TVarRec * Args
		, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EParseException(const AnsiString Msg, int AHelpContext
		) : Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EParseException(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EParseException(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EParseException(System::PResStringRec ResStringRec
		, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EParseException(void) { }
	#pragma option pop
	
};


typedef TParseItem ZParser__3[101];

typedef TParseVar ZParser__4[21];

typedef TParseFuncRec ZParser__5[21];

class PASCALIMPLEMENTATION TZParser : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	TParseItem FParseItems[101];
	int FParseCount;
	int FErrCheck;
	AnsiString FEquation;
	Variant FParseStack[101];
	int FStackCount;
	TParseVar FVars[21];
	int FVarCount;
	TParseFuncRec FFuncs[21];
	int FFuncCount;
	TParseItemType __fastcall ExtractTokenEx(AnsiString &Buffer, AnsiString &Token);
	int __fastcall OpLevel(AnsiString Operat);
	int __fastcall Parse(int Level, AnsiString &Buffer);
	void __fastcall SetEquation(AnsiString Value);
	Variant __fastcall GetVar(AnsiString VarName);
	void __fastcall SetVar(AnsiString VarName, const Variant &VarValue);
	AnsiString __fastcall GetVarName(int VarIndex);
	TParseFunc __fastcall GetFunc(AnsiString FuncName);
	void __fastcall SetFunc(AnsiString FuncName, TParseFunc FuncPtr);
	AnsiString __fastcall GetFuncName(int FuncIndex);
	void __fastcall CheckTypes(const Variant &Value1, Variant &Value2);
	Variant __fastcall ConvType(const Variant &Value);
	bool __fastcall CheckFunc(AnsiString &Buffer);
	
public:
	__fastcall virtual TZParser(Classes::TComponent* AOwner);
	__fastcall virtual ~TZParser(void);
	Variant __fastcall Evalute();
	void __fastcall Clear(void);
	void __fastcall Push(const Variant &Value);
	Variant __fastcall Pop();
	__property Variant Variables[AnsiString Index] = {read=GetVar, write=SetVar};
	__property int VarCount = {read=FVarCount, nodefault};
	__property AnsiString VarNames[int Index] = {read=GetVarName};
	__property TParseFunc Functions[AnsiString Index] = {read=GetFunc, write=SetFunc};
	__property int FuncCount = {read=FFuncCount, nodefault};
	__property AnsiString FuncNames[int Index] = {read=GetFuncName};
	
__published:
	__property AnsiString Equation = {read=FEquation, write=SetEquation};
};


//-- var, const, procedure ---------------------------------------------------
static const Shortint MAX_PARSE_ITEMS = 0x64;
static const Shortint MAX_PARSE_STACK = 0x64;
static const Shortint MAX_PARSE_VARS = 0x14;
static const Shortint MAX_PARSE_FUNCS = 0x14;

}	/* namespace Zparser */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zparser;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZParser
