//---------------------------------------------------------------------------
#ifndef ReportViewH
#define ReportViewH

#include <QRPrntr.hpp>
#include "Form.h"
#include "MyThread.h"

extern TList *ReportsList;

#define MAX_REPORTS 10;

class TWTReportView: public TWTMDIWindow {
private:
  TWTReportThread* Thread;
public:
  TStatusBar* StatusBar;
  TQuickRep* Report;
  TQuery* MainQuery;
  TQRPreview *QRPreview;
  __fastcall TWTReportView(TComponent *Owner);
  __fastcall ~TWTReportView();
  void __fastcall NextPage(TObject* Sender);
  void __fastcall PrevPage(TObject* Sender);
  void __fastcall FirstPage(TObject* Sender);
  void __fastcall LastPage(TObject* Sender);
  void __fastcall ZoomFit(TObject* Sender);
  void __fastcall ZoomFull(TObject* Sender);
  void __fastcall ZoomWidth(TObject* Sender);
  void __fastcall Print(TObject* Sender);
  void __fastcall PrintSetup(TObject* Sender);
  void __fastcall OnShowWin(TObject* Sender);
  void __fastcall OnUserKeyDown(TObject *Sender,Word &Key, Classes::TShiftState Shift);
};
//---------------------------------------------------------------------------
#endif
