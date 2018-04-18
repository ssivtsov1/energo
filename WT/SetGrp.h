//---------------------------------------------------------------------------
#ifndef SetGrpH
#define SetGrpH
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Grids.hpp>
#include <ComCtrls.hpp>
#include "CSPIN.h"
#include <CheckLst.hpp>

#include "Form.h"
#include "SelFields.h"

//---------------------------------------------------------------------------
class TWTSetGrp: public TWTMDIWindow {
private:
  TPanel* Panel1;
  TPanel* Panel2;
  TPanel* Panel3;
  TPageControl *PageControl1;
  TTabSheet *TSh1;
  TTabSheet *TSh2;
  TSpeedButton* SBOk;
  TSpeedButton* SBFont;
  TSpeedButton* SBColor;
  TSpeedButton* SBSum;
  TSpeedButton* SBAvg;
  TSpeedButton* SBMax;
  TSpeedButton* SBMin;
  TBevel* Bevel2;
  TBevel* Bevel3;
  TLabel* Label1;
  TLabel* Label2;
  TLabel* Label3;
  TLabel* Label4;
  TLabel* Label5;
  TLabel* Label6;
  TCheckBox* CBEnabled;
  TCheckBox* CBCapt;
  TCheckBox* CBVal;
  TCSpinEdit* SEOtst;
  TCSpinEdit* SEDist;
  TCheckListBox* CLFields;
  TRadioGroup* RGKind;
  TEdit* EName;
  TEdit* ECapt;
  TGrpProperty* GrpProperty;
  Graphics::TColor Color;
  TFont* Font;
//  TWTSelFields* SF;
  TTreeView* TreeView;

  void __fastcall SBOkClick(TObject* Sender);
  void __fastcall CBClick(TObject* Sender);
  void __fastcall OnCheckCLFields(TObject *Sender);

public:

  __fastcall TWTSetGrp(TGrpProperty* GP,TTreeView* TW,TWinControl* Owner);
};
//---------------------------------------------------------------------------
#endif
