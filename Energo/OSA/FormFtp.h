//---------------------------------------------------------------------------

#ifndef FormFtpH
#define FormFtpH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <NMFtp.hpp>
#include <Psock.hpp>
#include <Dialogs.hpp>
#include <ComCtrls.hpp>
#include <NMFngr.hpp>
#include <NMSTRM.hpp>
//#include "NntpCli.h"
#include <ScktComp.hpp>
//---------------------------------------------------------------------------
class TftpForm : public TForm
{
__published:	// IDE-managed Components
        TNMFTP *MyFtp;
        TButton *BOutSpr;
        TButton *BInSpr;
        TSaveDialog *SaveDialog;
        TEdit *EdHost;
        TLabel *LHost;
        TOpenDialog *OpenDialog1;
        TLabel *Label1;
        TEdit *EdPath;
        TSpeedButton *SpeedButton1;
        TLabel *Lab2;
        TLabel *Lab4;
        TEdit *EdAlias;
        TLabel *Label2;
        TButton *BSaveDMP;
        TMemo *MemState;
        TButton *BAskue;
        TButton *btLoadL04;
        TButton *btLoadFiz;
        TButton *btFiderFiz;
        TEdit *EdPwd;
        TEdit *EdUser;
        TLabel *Label3;
        TSpeedButton *SpeedButton2;
        void __fastcall BOutSprClick(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall BInSprClick(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall DumpClick(TObject *Sender);
        void __fastcall LoadAckue(TObject *Sender);
        void __fastcall btLoadL04Click(TObject *Sender);
        void __fastcall btLoadFizClick(TObject *Sender);
       // void __fastcall btLoadFizFider(TObject *Sender);
        void __fastcall btFiderFizClick(TObject *Sender);
        void __fastcall EdUserExit(TObject *Sender);
        void __fastcall EdPwdExit(TObject *Sender);
        void __fastcall SpeedButton2DblClick(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
  private:	// User declarations
public:		// User declarations
        __fastcall TftpForm(TComponent* Owner);
        __fastcall ~TftpForm();
         void __fastcall Show(int mode);
         AnsiString HostE;
         AnsiString AliasE;
         AnsiString Fname;
};
//---------------------------------------------------------------------------
extern PACKAGE TftpForm *ftpForm;
//---------------------------------------------------------------------------
#endif
