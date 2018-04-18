//---------------------------------------------------------------------------

#ifndef SysVarMH
#define SysVarMH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Mask.hpp>
#include <Dialogs.hpp>
//---------------------------------------------------------------------------
class TFShowSys : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TMaskEdit *EdMMGG;
        TCheckBox *ChNext;
        TBitBtn *BtnSave;
        TLabel *Label1;
        TLabel *Label2;
        TMaskEdit *EdMMGGN;
        TCheckBox *ChChangeName;
        TBitBtn *BitBtn1;
        TLabel *Label3;
        TMaskEdit *EdKodRes;
        TCheckBox *ChHistory;
        TLabel *LabRes;
        TLabel *LabIdRes;
        TLabel *Label4;
        TMaskEdit *EdPrefTax;
        TLabel *Label5;
        TMaskEdit *EdLastTax;
        TCheckBox *ChFider;
        TCheckBox *ChTaxList;
        TLabel *Label6;
        TOpenDialog *OpenDBF;
        TSpeedButton *SpeedButton1;
        TEdit *EdPathBank;
        void __fastcall ChNextClick(TObject *Sender);
        void __fastcall BtnSaveClick(TObject *Sender);
        void __fastcall BitBtn1Click(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFShowSys(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TFShowSys *FShowSys;
//---------------------------------------------------------------------------
#endif
