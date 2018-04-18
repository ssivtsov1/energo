//---------------------------------------------------------------------------

#ifndef Client_parH
#define Client_parH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TClientPar : public  TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TSplitter *Splitter1;
        TTreeView *Tree;
        TPanel *Panel2;
        TPanel *Panel3;
        TSpeedButton *AddBut;
        TSpeedButton *InsBut;
        TSpeedButton *DelBut;
        TPanel *Panel4Add;
        TLabel *Label1;
        TLabel *Label2;
        TSpeedButton *SpeedButton4;
        TSpeedButton *SpeedButton5;
        TLabel *Label7;
        TLabel *Label10;
        TComboBox *ComboBox1;
        TMemo *Memo1;
        TEdit *Edit1;
        TEdit *Edit4;
        TUpDown *UpDown2;
        TPanel *Panel4Prop;
        TLabel *Label5;
        TSpeedButton *SpeedButton8;
        TLabel *Label6;
        TSpeedButton *SpeedButton9;
        TComboBox *ComboBox3;
        TMemo *Memo3;
        TPanel *Panel4Ins;
        TLabel *Label3;
        TLabel *Label4;
        TSpeedButton *SpeedButton6;
        TSpeedButton *SpeedButton7;
        TLabel *Label8;
        TLabel *Label9;
        TComboBox *ComboBox2;
        TMemo *Memo2;
        TRadioButton *RadioButton1;
        TRadioButton *RadioButton2;
        TListView *NextPar;
        TEdit *Edit2;
        TEdit *Edit3;
        TUpDown *UpDown1;
        TControlBar *ControlBar1;
        TSpeedButton *SpeedButton1;
        TCheckBox *Direction;
        TCheckBox *Simple;
        TCheckBox *DataCheck;
        TCheckBox *CheckBox1;
         void __fastcall TreeChange(TObject *Sender, TTreeNode *Node);
        void __fastcall AddButClick(TObject *Sender);
        void __fastcall InsButClick(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall MakeTree();
        int __fastcall GetIndex(AnsiString str, TTreeView *Tree);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall SpeedButton5Click(TObject *Sender);
        void __fastcall SpeedButton4Click(TObject *Sender);
        void __fastcall DelButClick(TObject *Sender);
        void __fastcall RadioButton1Click(TObject *Sender);
        void __fastcall RadioButton2Click(TObject *Sender);
        void __fastcall NextParChange(TObject *Sender, TListItem *Item,
          TItemChange Change);
        void __fastcall SpeedButton7Click(TObject *Sender);
        void __fastcall SpeedButton9Click(TObject *Sender);
        void __fastcall SpeedButton8Click(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall N2Click(TObject *Sender);
        void __fastcall Edit3Change(TObject *Sender);
        void __fastcall Memo2Change(TObject *Sender);
        int __fastcall Count(AnsiString tmp);
        void __fastcall Edit4Change(TObject *Sender);
        void __fastcall Memo1Change(TObject *Sender);
        void __fastcall Memo3Change(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);

private:	// User declarations
public:		// User declarations
        __fastcall TClientPar(TComponent* Owner);
        int simp;
};
//---------------------------------------------------------------------------
extern PACKAGE TClientPar *ClientPar;
//---------------------------------------------------------------------------
#endif
