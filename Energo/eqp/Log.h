//---------------------------------------------------------------------------

#ifndef LogH
#define LogH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZTransact.hpp"
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TfLog : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TMemo *Memo1;
        TZMonitor *ZMonitor1;
        void __fastcall ZMonitor1MonitorEvent(AnsiString Sql,
          AnsiString Result);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
//        TMenuItem *WindowMenu;
//        AnsiString id;
//        void _fastcall ActivateMenu(TObject *Sender);
        __fastcall TfLog(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfLog *fLog;
//---------------------------------------------------------------------------
#endif
