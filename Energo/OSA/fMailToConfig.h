//---------------------------------------------------------------------------

#ifndef fMailToConfigH
#define fMailToConfigH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <CheckLst.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TMailToConfig : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TBitBtn *btCancel;
        TBitBtn *btOk;
        TListBox *lbMails;
        TEdit *edCommand;
        void __fastcall FormShow(TObject *Sender);
        void __fastcall lbMailsClick(TObject *Sender);
        void __fastcall btCancelClick(TObject *Sender);
        void __fastcall btOkClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TMailToConfig(TComponent* Owner);

        TStringList *command_list;
};
//---------------------------------------------------------------------------
extern PACKAGE TMailToConfig *MailToConfig;
//---------------------------------------------------------------------------
#endif
