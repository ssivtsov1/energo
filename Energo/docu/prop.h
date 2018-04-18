//---------------------------------------------------------------------------

#ifndef propH
#define propH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TProperties : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TEdit *Text_name;
        TLabel *Label2;
        TLabel *Text_type;
        TLabel *Label4;
        TMemo *Memo1;
        TButton *Button1;
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormActivate(TObject *Sender);
        AnsiString __fastcall GetType(AnsiString teg);
private:	// User declarations
public:		// User declarations
        __fastcall TProperties(TComponent* Owner);
        TList *MainList;
        int id_elem;
};
//---------------------------------------------------------------------------
extern PACKAGE TProperties *Properties;
//---------------------------------------------------------------------------
#endif
