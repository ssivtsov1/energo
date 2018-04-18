//---------------------------------------------------------------------------
#ifndef MyThreadH
#define MyThreadH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <quickrpt.hpp>
//---------------------------------------------------------------------------
class TWTReportThread : public TThread
{
private:
protected:
        void __fastcall Execute();
public:
        TQuickRep* Report;

        __fastcall TWTReportThread(TQuickRep* Rep,bool CreateSuspended);
        __fastcall ~TWTReportThread(void);
};
//---------------------------------------------------------------------------
#endif
