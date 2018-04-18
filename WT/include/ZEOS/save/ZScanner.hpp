// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZScanner.pas' rev: 5.00

#ifndef ZScannerHPP
#define ZScannerHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zscanner
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TZScanner;
class PASCALIMPLEMENTATION TZScanner : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	AnsiString FBuffer;
	int FBufferPos;
	int FBufferLine;
	int FBufferLen;
	int FTokenType;
	int FNextTokenType;
	AnsiString FToken;
	AnsiString FNextToken;
	int FLineNo;
	int FNextLineNo;
	int FPosition;
	int FNextPosition;
	bool FShowComment;
	bool FShowString;
	bool FShowEol;
	bool FShowKeyword;
	bool FShowType;
	void __fastcall SetBuffer(AnsiString Value);
	int __fastcall GetNextLineNo(void);
	AnsiString __fastcall GetNextToken();
	int __fastcall GetNextPosition(void);
	int __fastcall GetNextTokenType(void);
	virtual int __fastcall LowRunLex(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	virtual int __fastcall RunLex(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	void __fastcall ExtractToken(void);
	void __fastcall ExtractNextToken(void);
	int __fastcall InnerStartLex(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	int __fastcall InnerProcLineComment(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	int __fastcall InnerProcCComment(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	int __fastcall InnerProcIdent(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	int __fastcall InnerProcCString(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	int __fastcall InnerProcPasString(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	__fastcall virtual TZScanner(void);
	__fastcall virtual ~TZScanner(void);
	void __fastcall Restart(void);
	virtual AnsiString __fastcall WrapString(AnsiString Value);
	virtual AnsiString __fastcall UnwrapString(AnsiString Value);
	#pragma option push -w-inl
	/* virtual class method */ virtual bool __fastcall IsAlpha(char Value) { return IsAlpha(__classid(TZScanner)
		, Value); }
	#pragma option pop
	/*         class method */ static bool __fastcall IsAlpha(TMetaClass* vmt, char Value);
	#pragma option push -w-inl
	/* virtual class method */ virtual bool __fastcall IsDigit(char Value) { return IsDigit(__classid(TZScanner)
		, Value); }
	#pragma option pop
	/*         class method */ static bool __fastcall IsDigit(TMetaClass* vmt, char Value);
	#pragma option push -w-inl
	/* virtual class method */ virtual bool __fastcall IsDelim(char Value) { return IsDelim(__classid(TZScanner)
		, Value); }
	#pragma option pop
	/*         class method */ static bool __fastcall IsDelim(TMetaClass* vmt, char Value);
	#pragma option push -w-inl
	/* virtual class method */ virtual bool __fastcall IsWhite(char Value) { return IsWhite(__classid(TZScanner)
		, Value); }
	#pragma option pop
	/*         class method */ static bool __fastcall IsWhite(TMetaClass* vmt, char Value);
	#pragma option push -w-inl
	/* virtual class method */ virtual bool __fastcall IsEol(char Value) { return IsEol(__classid(TZScanner)
		, Value); }
	#pragma option pop
	/*         class method */ static bool __fastcall IsEol(TMetaClass* vmt, char Value);
	#pragma option push -w-inl
	/* virtual class method */ virtual bool __fastcall IsQuote(char Value) { return IsQuote(__classid(TZScanner)
		, Value); }
	#pragma option pop
	/*         class method */ static bool __fastcall IsQuote(TMetaClass* vmt, char Value);
	int __fastcall Lex(void);
	int __fastcall GotoNextToken(void);
	__property bool ShowComment = {read=FShowComment, write=FShowComment, nodefault};
	__property bool ShowEol = {read=FShowEol, write=FShowEol, nodefault};
	__property bool ShowString = {read=FShowString, write=FShowString, nodefault};
	__property bool ShowKeyword = {read=FShowKeyword, write=FShowKeyword, nodefault};
	__property bool ShowType = {read=FShowType, write=FShowType, nodefault};
	__property AnsiString Buffer = {read=FBuffer, write=SetBuffer};
	__property int BufferPos = {read=FBufferPos, nodefault};
	__property int Position = {read=FPosition, nodefault};
	__property int LineNo = {read=FLineNo, nodefault};
	__property AnsiString Token = {read=FToken};
	__property int TokenType = {read=FTokenType, nodefault};
	__property int NextPosition = {read=GetNextPosition, nodefault};
	__property int NextLineNo = {read=GetNextLineNo, nodefault};
	__property AnsiString NextToken = {read=GetNextToken};
	__property int NextTokenType = {read=GetNextTokenType, nodefault};
};


class DELPHICLASS TZPasScanner;
class PASCALIMPLEMENTATION TZPasScanner : public TZScanner 
{
	typedef TZScanner inherited;
	
protected:
	virtual int __fastcall LowRunLex(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	virtual AnsiString __fastcall WrapString(AnsiString Value);
	virtual AnsiString __fastcall UnwrapString(AnsiString Value);
public:
	#pragma option push -w-inl
	/* TZScanner.Create */ inline __fastcall virtual TZPasScanner(void) : TZScanner() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZPasScanner(void) { }
	#pragma option pop
	
};


class DELPHICLASS TZCScanner;
class PASCALIMPLEMENTATION TZCScanner : public TZScanner 
{
	typedef TZScanner inherited;
	
protected:
	virtual int __fastcall LowRunLex(int &CurrPos, int &CurrLineNo, AnsiString &CurrToken);
	
public:
	virtual AnsiString __fastcall WrapString(AnsiString Value);
	virtual AnsiString __fastcall UnwrapString(AnsiString Value);
public:
	#pragma option push -w-inl
	/* TZScanner.Create */ inline __fastcall virtual TZCScanner(void) : TZScanner() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TZScanner.Destroy */ inline __fastcall virtual ~TZCScanner(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
static const Shortint tokUnknown = 0x0;
static const Shortint tokComment = 0x1;
static const Shortint tokKeyword = 0x2;
static const Shortint tokType = 0x4;
static const Shortint tokIdent = 0x8;
static const Shortint tokAlpha = 0xe;
static const Shortint tokOperator = 0x10;
static const Shortint tokBrace = 0x20;
static const Shortint tokSeparator = 0x40;
static const Byte tokEol = 0x80;
static const Byte tokLF = 0xe0;
static const Byte tokDelim = 0xf0;
static const Word tokInt = 0x100;
static const Word tokFloat = 0x200;
static const Word tokString = 0x400;
static const Word tokBool = 0x800;
static const Word tokConst = 0xf00;
static const Word tokEof = 0x8000;

}	/* namespace Zscanner */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zscanner;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZScanner
