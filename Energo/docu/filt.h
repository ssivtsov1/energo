//---------------------------------------------------------------------------

#ifndef filtH
#define filtH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TFilter : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TButton *Button1;
        TButton *Button2;
        TListBox *ListParam;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TSpeedButton *SpeedButton3;
        TSpeedButton *SpeedButton4;
        TSpeedButton *SpeedButton5;
        TSpeedButton *SpeedButton6;
        TSpeedButton *SpeedButton7;
        TSpeedButton *SpeedButton8;
        TSpeedButton *SpeedButton9;
        TSpeedButton *SpeedButton10;
        TSpeedButton *SpeedButton11;
        TSpeedButton *SpeedButton12;
        TSpeedButton *SpeedButton13;
        TMemo *Memo1;
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall Click(TObject *Sender);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall SpeedButton11Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFilter(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TFilter *Filter;
//---------------------------------------------------------------------------
#endif
