//---------------------------------------------------------------------------
#ifndef SelFieldsH
#define SelFieldsH

#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Grids.hpp>
#include "CSPIN.h"

class TWTFieldProperty;
class TGrpProperty;
class TWTSelFields;

#include "SetWFForm.h"
#include "SetGrp.h"
#include "Func.h"
#include "MainForm.h"
#include "Form.h"
#include "DBGrid.h"
#include "ReportView.h"

//---------------------------------------------------------------------------
class TWTSelFields: public TWTMDIWindow {
private:
  bool OpenGlobal;
  AnsiString DefaultTitle;
  TWTWaitForm *WaitForm;

  //¬озвращает индекс дл€ вставки полей обратно в GrpSource дл€ соблюдени€ пор€дка
  int __fastcall GetIndexToInsert(TWTFieldProperty *FieldDesc);

  void __fastcall FOnClick(TObject *Sender);
  void __fastcall SaveReport(TObject *Sender);
  void __fastcall LoadReport(AnsiString LoadName);
  void __fastcall DeleteReport(TObject *Sender);
  void __fastcall FAddGrpOnClick(TObject *Sender);
  void __fastcall FAddFieldOnClick(TObject *Sender);
  void __fastcall FDelGrpOnClick(TObject *Sender);
  void __fastcall FDelFieldOnClick(TObject *Sender);
  void __fastcall GrpDestDblClick(TObject *Sender);
  void __fastcall FLockOnClick(TObject *Sender);
  void __fastcall FUpOnClick(TObject *Sender);
  void __fastcall FDownOnClick(TObject *Sender);
  void __fastcall OnChangeGrp(TObject* Sender,TTreeNode* Node);
//функции дл€ работы с колонтилами
  void __fastcall CBDownDblClick(TObject *Sender);
  void __fastcall CBUpDblClick(TObject *Sender);
  void __fastcall CBDownCheck(TObject *Sender);
  void __fastcall CBUpCheck(TObject *Sender);
  void __fastcall FUpCOnClick(TObject *Sender);
  void __fastcall FDownCOnClick(TObject *Sender);
  void UpdateText(TCheckListBox* CLBox);
//конец
  void UpdateNames();

  void __fastcall RemoveField(TTreeNode* TN);
  void ReportPrint();

  AnsiString CurrentReport;
  Boolean Locked;
  Boolean AllFlag;
  Boolean IsTable;

  TListBox* GrpSource;
  TTreeView* GrpDest;
  TPanel* Panel1;
  TPageControl *PageControl1;
  TPageControl *PageControl2;
  TTabSheet *TSh1;
  TTabSheet *TSh2;
  TTabSheet *TSh3;
  TTabSheet *TSh4;
  TTabSheet *TSh5;
  TTabSheet *TSh6;
  TPanel* Panel2;
  TPanel* Panel3;
  TSpeedButton* SBOk;
  TCheckBox *CheckBox;
  TCheckBox *CBUp;
  TCheckBox *CBDown;
  TSpeedButton* SBFont;
  TSpeedButton* SBHFont;
  TSpeedButton* SBNFont;
  TSpeedButton* SBAddGrp;
  TSpeedButton* SBAddField;
  TSpeedButton* SBDelGrp;
  TSpeedButton* SBDelField;
  TSpeedButton* SBLock;
  TSpeedButton* SBUp;
  TSpeedButton* SBDown;
  TSpeedButton* SBProp;
  TSpeedButton* SBUpUp;
  TSpeedButton* SBDownUp;
  TSpeedButton* SBPropUp;
  TSpeedButton* SBUpDown;
  TSpeedButton* SBDownDown;
  TSpeedButton* SBPropDown;
  TBevel* Bevel;
  TGroupBox* GBox;
  TEdit* NEdit;
  TEdit* TextUp;
  TEdit* TextDown;
  TGroupBox *TGb;
  TRadioGroup *TRg1;
  TRadioGroup *TRg2;
  TLabel *Label;
  TComboBox *TCb;
  TComboBox *ComboUp;
  TComboBox *ComboDown;
  TCSpinEdit* SEOtst;
  TCSpinEdit* SEDistUp;
  TCSpinEdit* SEDistDown;
  TCSpinEdit* SEHeightUp;
  TCSpinEdit* SEHeightDown;
  TFont* DefaultFont;
  TFont* HeaderFont;
  TFont* NameFont;
  TFont* UpCFont;
  TFont* DownCFont;
  TColor DefaultBgColor;
  TColor HeaderBgColor;
  TCheckListBox* CBoxUp;
  TCheckListBox* CBoxDown;
  TWTDBGrid *FDBGrid;

public:

  TZPgSqlQuery* MainQuery;

  __fastcall TWTSelFields(TComponent* Owner,TWTDBGrid* DBGrid,AnsiString Name,AnsiString LoadName);
  __fastcall ~TWTSelFields();

};

//---------------------------------------------------------------------------
class TWTFieldProperty: public TObject {
public:
  TFont* Font;
  TColor BgColor;
  int FieldLength;
  int Align;
  TField* Field;
  AnsiString Name;
  bool ModFlag;
  __fastcall TWTFieldProperty(int FW,TField* Fld,AnsiString NM);
  __fastcall ~TWTFieldProperty();
};

class TGrpProperty: public TObject {
public:
  TFont* CaptFont;
  Graphics::TColor BgColor;
  int Otst;
  int Dist;
  AnsiString IName;
  boolean Enabled;
  boolean Kind;
  boolean IsName;
  boolean IsValue;
  TList* Fields;
  AnsiString Function;
  __fastcall TGrpProperty();
  __fastcall ~TGrpProperty();
};

class TWTString: public TObject {
public:
  __fastcall TWTString(AnsiString Text);
  AnsiString String;
};

class TWTColorButton : public TSpeedButton {
protected:
  void __fastcall OnClickButton(TObject* Sender);
  TColor* WorkColor;
public:
  _fastcall TWTColorButton(int LeftC,int TopC,TColor &ColorC,TWinControl* Owner);
};

class TWTFontButton : public TSpeedButton {
protected:
  void __fastcall OnClickButton(TObject* Sender);
  TFont* WorkFont;
public:
  _fastcall TWTFontButton(int LeftC,int TopC,TFont* FontC,TWinControl* Owner);
};
#endif
