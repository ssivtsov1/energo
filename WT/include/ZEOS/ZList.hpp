// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZList.pas' rev: 5.00

#ifndef ZListHPP
#define ZListHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Math.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zlist
{
//-- type declarations -------------------------------------------------------
typedef char *TPointerList[134217727];

typedef char * *PPointerList;

typedef Byte *PByte;

typedef int __fastcall (__closure *TZItemListSortEvent)(void * Item1, void * Item2);

typedef bool __fastcall (__closure *TZItemListFilterEvent)(void * Item);

#pragma option push -b-
enum TZItemListNotification { lnAdded, lnExtracted, lnDeleted };
#pragma option pop

class DELPHICLASS TZItemList;
class PASCALIMPLEMENTATION TZItemList : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	char *FBuffer;
	char * *FList;
	char * *FFillList;
	int FItemSize;
	int FCount;
	int FFillCount;
	int FCapacity;
	bool FSorted;
	bool FFiltered;
	Byte FFillValue;
	TZItemListSortEvent FOnSort;
	TZItemListFilterEvent FOnFilter;
	
protected:
	void * __fastcall Get(int Index);
	virtual void __fastcall Grow(void);
	void __fastcall Put(int Index, void * Item);
	void __fastcall SetCapacity(int NewCapacity);
	void __fastcall SetCount(int NewCount);
	__property PPointerList FillList = {read=FFillList, write=FFillList};
	__property PPointerList List = {read=FList, write=FList};
	__property int ItemSize = {read=FItemSize, write=FItemSize, nodefault};
	
public:
	__fastcall TZItemList(int ItemSize);
	__fastcall virtual ~TZItemList(void);
	#pragma option push -w-inl
	/* virtual class method */ virtual void __fastcall Error(const AnsiString Msg, int Data) { Error(__classid(TZItemList)
		, Msg, Data); }
	#pragma option pop
	/*         class method */ static void __fastcall Error(TMetaClass* vmt, const AnsiString Msg, int 
		Data);
	void * __fastcall First(void);
	void * __fastcall Last(void);
	int __fastcall IndexOf(void * Item);
	TZItemList* __fastcall Expand(void);
	virtual void __fastcall Clear(void);
	void * __fastcall Add(void);
	void * __fastcall Delete(int Index);
	void * __fastcall Exchange(int Index1, int Index2);
	void * __fastcall Insert(int Index);
	void * __fastcall Move(int CurIndex, int NewIndex);
	int __fastcall Remove(void * Item);
	int __fastcall GetRealIndex(void * Item);
	void * __fastcall GetRealItem(int Index);
	void __fastcall Sort(void);
	void __fastcall ClearSort(void);
	void __fastcall Filter(void);
	bool __fastcall FilterItem(int Index);
	void __fastcall ClearFilter(void);
	__property int Capacity = {read=FCapacity, write=SetCapacity, nodefault};
	__property int Count = {read=FCount, write=FCount, nodefault};
	__property int FillCount = {read=FFillCount, nodefault};
	__property void * Items[int Index] = {read=Get, write=Put/*, default*/};
	__property bool Sorted = {read=FSorted, nodefault};
	__property bool Filtered = {read=FFiltered, nodefault};
	__property Byte FillValue = {read=FFillValue, write=FFillValue, nodefault};
	__property TZItemListSortEvent OnSort = {read=FOnSort, write=FOnSort};
	__property TZItemListFilterEvent OnFilter = {read=FOnFilter, write=FOnFilter};
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
static const Shortint ITEM_CLEAR = 0x0;
static const Shortint ITEM_ENABLED = 0x1;
static const Shortint ITEM_FILTERED = 0x2;
static const Shortint ITEM_DELETED = 0x3;

}	/* namespace Zlist */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zlist;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZList
