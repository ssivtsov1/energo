//---------------------------------------------------------------------------

#ifndef add_fieldH
#define add_fieldH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TAddField : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TListView *ListField;
        TComboBox *Combo;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TEdit *Edit1;
        TLabel *Label1;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall ListFieldChange(TObject *Sender, TListItem *Item,
          TItemChange Change);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall ComboChange(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TAddField(TComponent* Owner);
        int id_parent,num,id_doc;
};
//---------------------------------------------------------------------------
extern PACKAGE TAddField *AddField;
//---------------------------------------------------------------------------
#endif
