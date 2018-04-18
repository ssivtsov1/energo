//---------------------------------------------------------------------------

#ifndef cr_elemH
#define cr_elemH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "TWTCompatable.h"
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TCreateForm : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TPanel *Panel1;
        TLabel *Label1;
        TComboBox *TypeList;
        TPanel *Panel2;
        TLabel *Label2;
        TEdit *Edit1;
        TLabel *Label4;
        TComboBox *ComboBox1;
        TPanel *Panel3;
        TLabel *Label3;
        TEdit *Edit2;
        TPanel *Panel4;
        TComboBox *ComboBox2;
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall TypeListChange(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall ComboBox2Change(TObject *Sender);
        void __fastcall ComboBox1Change(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TCreateForm(TComponent* Owner);
        int id_doc,id_parent,num;
};
//---------------------------------------------------------------------------
extern PACKAGE TCreateForm *CreateForm;
//---------------------------------------------------------------------------
#endif
