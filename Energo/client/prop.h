//---------------------------------------------------------------------------

#ifndef propH
#define propH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Menus.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TClient_par : public  TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TTreeView *Tree;
        TSplitter *Splitter1;
        TPanel *Panel2;
        TPanel *Panel3;
        TSpeedButton *AddBut;
        TSpeedButton *InsBut;
        TSpeedButton *DelBut;
        TPanel *Panel4Add;
        TComboBox *ComboBox1;
        TLabel *Label1;
        TLabel *Label2;
        TMemo *Memo1;
        TSpeedButton *SpeedButton4;
        TSpeedButton *SpeedButton5;
        TPanel *Panel4Ins;
        TLabel *Label3;
        TComboBox *ComboBox2;
        TLabel *Label4;
        TMemo *Memo2;
        TRadioButton *RadioButton1;
        TRadioButton *RadioButton2;
        TListView *NextPar;
        TSpeedButton *SpeedButton6;
        TSpeedButton *SpeedButton7;
        TPanel *Panel4Prop;
        TComboBox *ComboBox3;
        TLabel *Label5;
        TSpeedButton *SpeedButton8;
        TLabel *Label6;
        TMemo *Memo3;
        TSpeedButton *SpeedButton9;
        TLabel *Label7;
        TEdit *Edit1;
        TEdit *Edit2;
        TLabel *Label8;
        TControlBar *ControlBar1;
        TCheckBox *Direction;
        TCheckBox *Simple;
        TCheckBox *DataCheck;
        TLabel *Label9;
        TEdit *Edit3;
        TUpDown *UpDown1;
        TLabel *Label10;
        TEdit *Edit4;
        TUpDown *UpDown2;
        TSpeedButton *SpeedButton1;
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
        void __fastcall DirectionClick(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TClient_par(TComponent* Owner);
        int simp;
};
//---------------------------------------------------------------------------
extern PACKAGE TClient_par *Client_par;
//---------------------------------------------------------------------------
#endif
