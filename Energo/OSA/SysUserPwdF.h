//---------------------------------------------------------------------------

#ifndef SysUserPwdFH
#define SysUserPwdFH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include "Main.h"
#include "Query.h"
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
//---------------------------------------------------------------------------
class TFUserPwd : public TForm
{
__published:	// IDE-managed Components
        TEdit *EdPwd1;
        TEdit *EdPwd2;
        TBitBtn *BitBtnOK;
        TBitBtn *BitBtn2;
        TLabel *Label1;
        TLabel *Label2;
        TLabel *LabName;
        TLabel *LabOldPwd;
        TEdit *EdOldPwd;
         void __fastcall EdPwd2Exit(TObject *Sender);
           void __fastcall EdOldPwdExit(TObject *Sender);

        void __fastcall EdPwd2Change(TObject *Sender);
        void __fastcall BitBtnOKClick(TObject *Sender);
        void __fastcall EdOldPwdChange(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);


private:
       AnsiString OldPwd;
        TWTQuery *QUser;
        int fid_user;

	// User declarations
public:		// User declarations
        __fastcall TFUserPwd(TComponent* Owner);
         __fastcall ~TFUserPwd();
        void __fastcall Show(TObject *Sender,int id_user);

};
//---------------------------------------------------------------------------
extern PACKAGE TFUserPwd *FUserPwd;
//---------------------------------------------------------------------------
#endif
