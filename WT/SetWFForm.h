//---------------------------------------------------------------------------
#ifndef SetWFFormH
#define SetWFFormH

#include "Form.h"
#include "SelFields.h"
//---------------------------------------------------------------------------
class TWTSetWFForm: public TWTMDIWindow {
private:
  TComboBox* AlignBox;
public:
  TPanel *Panel1;
  TPanel *Panel2;
  TLabel *Label;
  TEdit *Edit;
  TLabel *LName;
  TEdit *EName;
  TSpeedButton *SBFont;
  TSpeedButton *SBOk;
  TSpeedButton *SBCancel;
  TSpeedButton *SBAuto;
  TProgressBar* ProgressBar;
  TWTFieldProperty* FieldProperty;
  TWTSelFields* SelFields;

  TColor BgColor;
  TFont* DataFont;

public:
   __fastcall TWTSetWFForm(TWTFieldProperty *FP,TComponent *Owner);
   __fastcall ~TWTSetWFForm();
   void __fastcall SBAutoClick(TObject *Sender);
   void __fastcall SBOkClick(TObject *Sender);

};
//---------------------------------------------------------------------------
#endif
