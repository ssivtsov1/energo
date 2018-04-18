//---------------------------------------------------------------------------

#ifndef findd_aH
#define findd_aH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <Grids.hpp>
#include <Buttons.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TFindAdv : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPageControl *PageControl1;
        TTabSheet *TabSheet1;
        TLabel *Label2;
        TEdit *TextFind;
        TCheckBox *CheckBox1;
        TCheckBox *CheckBox2;
        TCheckBox *CheckBox3;
        TTabSheet *TabSheet2;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TLabel *Label6;
        TRadioButton *RadioButton1;
        TDateTimePicker *DateTimePicker1;
        TDateTimePicker *DateTimePicker2;
        TRadioButton *RadioButton2;
        TRadioButton *RadioButton4;
        TEdit *Edit1;
        TUpDown *UpDown1;
        TEdit *Edit2;
        TUpDown *UpDown2;
        TRadioButton *RadioButton3;
        TDateTimePicker *DateTimePicker3;
        TButton *AddBut;
        TStringGrid *StringGrid1;
        TButton *DelBut;
        TButton *FindBut;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TButton *CloseBut;
        TListView *FindResult;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall AddButClick(TObject *Sender);
        void __fastcall DelButClick(TObject *Sender);
        void __fastcall RemoveRow(int row);
        void __fastcall CheckBox1Click(TObject *Sender);
        void __fastcall CheckBox2Click(TObject *Sender);
        void __fastcall RadioButton3Click(TObject *Sender);
        void __fastcall RadioButton1Click(TObject *Sender);
        void __fastcall RadioButton2Click(TObject *Sender);
        void __fastcall RadioButton4Click(TObject *Sender);
        void __fastcall CloseButClick(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall FindButClick(TObject *Sender);
        void __fastcall FindResultChanging(TObject *Sender,
          TListItem *Item, TItemChange Change, bool &AllowChange);
        void __fastcall FindResultDblClick(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFindAdv(TComponent* Owner);
        int id_view;
};
//---------------------------------------------------------------------------
extern PACKAGE TFindAdv *FindAdv;
//---------------------------------------------------------------------------
#endif
