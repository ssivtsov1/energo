//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MyThread.h"
#pragma package(smart_init)

__fastcall TWTReportThread::TWTReportThread(TQuickRep* Rep,bool CreateSuspended)
        : TThread(CreateSuspended)
{
  Report=Rep;
  FreeOnTerminate=true;
}

__fastcall TWTReportThread::~TWTReportThread(void)
{
//  delete Report;
//  Suspend();
}

//---------------------------------------------------------------------------
void __fastcall TWTReportThread::Execute()
{
  Report->Prepare();
//  Suspend();
}
//---------------------------------------------------------------------------






