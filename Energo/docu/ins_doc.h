//---------------------------------------------------------------------------

#ifndef ins_docH
#define ins_docH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TInsForm : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TListView *List;
        TRadioButton *RadioButton1;
        TRadioButton *RadioButton2;
        TListView *ListElem;
        TEdit *Edit1;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall RadioButton1Click(TObject *Sender);
        void __fastcall RadioButton2Click(TObject *Sender);
        void __fastcall ListElemChanging(TObject *Sender, TListItem *Item,
          TItemChange Change, bool &AllowChange);
        void __fastcall ListChanging(TObject *Sender, TListItem *Item,
          TItemChange Change, bool &AllowChange);
private:	// User declarations
public:		// User declarations
        __fastcall TInsForm(TComponent* Owner);
        int kind,id_parent,id_doc;
};
//---------------------------------------------------------------------------
extern PACKAGE TInsForm *InsForm;
//---------------------------------------------------------------------------
#endif
