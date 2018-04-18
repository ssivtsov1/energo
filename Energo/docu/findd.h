//---------------------------------------------------------------------------

#ifndef finddH
#define finddH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ImgList.hpp>
#include <Buttons.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TFind : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TButton *FindBut;
        TButton *CloseBut;
        TPageControl *PageControl1;
        TTabSheet *TabSheet1;
        TTabSheet *TabSheet2;
        TEdit *TextFind;
        TLabel *Label2;
        TImageList *ImageList1;
        TListView *FindResult;
        TCheckBox *CheckBox1;
        TCheckBox *CheckBox2;
        TDateTimePicker *DateTimePicker1;
        TLabel *Label3;
        TRadioButton *RadioButton1;
        TLabel *Label4;
        TDateTimePicker *DateTimePicker2;
        TRadioButton *RadioButton2;
        TRadioButton *RadioButton4;
        TEdit *Edit1;
        TUpDown *UpDown1;
        TEdit *Edit2;
        TUpDown *UpDown2;
        TLabel *Label5;
        TLabel *Label6;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TCheckBox *CheckBox3;
        TRadioButton *RadioButton3;
        TDateTimePicker *DateTimePicker3;
        void __fastcall CloseButClick(TObject *Sender);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FindButClick(TObject *Sender);
        void __fastcall FindResultChanging(TObject *Sender,
          TListItem *Item, TItemChange Change, bool &AllowChange);
        void __fastcall FindResultDblClick(TObject *Sender);
        void __fastcall CheckBox1Click(TObject *Sender);
        void __fastcall CheckBox2Click(TObject *Sender);
        void __fastcall RadioButton1Click(TObject *Sender);
        void __fastcall RadioButton2Click(TObject *Sender);
        void __fastcall RadioButton4Click(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall RadioButton3Click(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TFind(TComponent* Owner);
        int id_form, id_view;
};
//---------------------------------------------------------------------------
extern PACKAGE TFind *Find;
//---------------------------------------------------------------------------
#endif
