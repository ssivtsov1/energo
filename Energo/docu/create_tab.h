//---------------------------------------------------------------------------

#ifndef create_tabH
#define create_tabH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TCreateTab : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TEdit *Rows;
        TEdit *Cols;
        TLabel *Label1;
        TLabel *Label2;
        TSpeedButton *SpeedButton1;
        TPanel *Parent;
        TPanel *Panel3;
        TSpeedButton *SpeedButton2;
        TSpeedButton *JoinBut;
        TLabel *Label3;
        TEdit *TableName;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall Clk(TObject *Sender);
        void __fastcall JoinButClick(TObject *Sender);
        int __fastcall GetMinRow();
        int __fastcall GetMinCol(int minrow);
        int __fastcall GetMaxRow();
        int __fastcall GetMaxCol(int maxrow);
        int __fastcall GetNumCol(int row);
        int __fastcall GetNumRow();
        AnsiString __fastcall GetProp(int row,int col);
private:	// User declarations
public:		// User declarations
        __fastcall TCreateTab(TComponent* Owner);
        int form;
};
//---------------------------------------------------------------------------
extern PACKAGE TCreateTab *CreateTab;
//---------------------------------------------------------------------------
#endif
