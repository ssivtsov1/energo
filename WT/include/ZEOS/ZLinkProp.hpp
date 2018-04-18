// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ZLinkProp.pas' rev: 5.00

#ifndef ZLinkPropHPP
#define ZLinkPropHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ZQuery.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <DsgnIntf.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Zlinkprop
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrmLinkFields;
class PASCALIMPLEMENTATION TfrmLinkFields : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Extctrls::TPanel* pnMain;
	Stdctrls::TButton* btnOk;
	Stdctrls::TButton* btnCancel;
	Stdctrls::TLabel* lblDetailFields;
	Stdctrls::TLabel* lblMasterFields;
	Stdctrls::TListBox* lbxDetail;
	Stdctrls::TListBox* lbxMaster;
	Stdctrls::TButton* btnAdd;
	Stdctrls::TButton* btnAuto;
	Stdctrls::TLabel* lblJoinedFields;
	Stdctrls::TListBox* lbxJoined;
	Stdctrls::TButton* btnDelete;
	Stdctrls::TButton* btnClear;
	Stdctrls::TCheckBox* cbxCascadeUpdates;
	Stdctrls::TCheckBox* cbxCascadeDeletes;
	Stdctrls::TCheckBox* cbxLinkRequery;
	Stdctrls::TCheckBox* cbxAlwaysResync;
	void __fastcall lbxDetailClick(System::TObject* Sender);
	void __fastcall lbxDetailKeyUp(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
	void __fastcall lbxJoinedClick(System::TObject* Sender);
	void __fastcall lbxJoinedKeyUp(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
	void __fastcall btnClearClick(System::TObject* Sender);
	void __fastcall btnDeleteClick(System::TObject* Sender);
	void __fastcall btnAddClick(System::TObject* Sender);
	void __fastcall btnAutoClick(System::TObject* Sender);
	
private:
	Classes::TStrings* FDetail;
	Classes::TStrings* FMaster;
	Classes::TStrings* FJDetail;
	Classes::TStrings* FJMaster;
	void __fastcall FillFieldList(Db::TDataSet* Dataset, Classes::TStrings* List);
	void __fastcall FillListBox(Classes::TStrings* List, Stdctrls::TListBox* ListBox);
	void __fastcall FillJoinListBox(Classes::TStrings* MasterList, Classes::TStrings* DetailList, Stdctrls::TListBox* 
		ListBox);
	AnsiString __fastcall GetLinkFields();
	void __fastcall SetLinkFields(AnsiString Value);
	void __fastcall RefreshListBoxes(void);
	Zquery::TZLinkOptions __fastcall GetLinkOptions(void);
	void __fastcall SetLinkOptions(Zquery::TZLinkOptions Value);
	
public:
	__fastcall virtual TfrmLinkFields(Classes::TComponent* AOwner);
	__fastcall virtual ~TfrmLinkFields(void);
	bool __fastcall Execute(Zquery::TZDataset* Dataset);
public:
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrmLinkFields(Classes::TComponent* AOwner, int 
		Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TfrmLinkFields(HWND ParentWindow) : Forms::TForm(
		ParentWindow) { }
	#pragma option pop
	
};


class DELPHICLASS TZLinkFieldsProperty;
class PASCALIMPLEMENTATION TZLinkFieldsProperty : public Dsgnintf::TStringProperty 
{
	typedef Dsgnintf::TStringProperty inherited;
	
public:
	virtual Dsgnintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall Edit(void);
protected:
	#pragma option push -w-inl
	/* TPropertyEditor.Create */ inline __fastcall virtual TZLinkFieldsProperty(const Dsgnintf::_di_IFormDesigner 
		ADesigner, int APropCount) : Dsgnintf::TStringProperty(ADesigner, APropCount) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TZLinkFieldsProperty(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Zlinkprop */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Zlinkprop;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ZLinkProp
