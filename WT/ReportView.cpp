//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ReportView.h"  
#include "MainForm.h"

TList *ReportsList=NULL;

__fastcall TWTReportView::TWTReportView (TComponent *Owner): TWTMDIWindow(Owner) {

  Visible=false;
  TForm::Width=Screen->Width-100;
  TForm::Height=Screen->Height-100;
  TForm::Position=poScreenCenter;
//  SelFields=Owner;
  //TForm::OnShow=OnShowWin;


  QRPreview= new TQRPreview(this);
  QRPreview->Align= alClient;
  QRPreview->Parent= this;

  StatusBar=new TStatusBar(this);
  StatusBar->Align=alBottom;
//  StatusBar->FlipChildren(false);
  StatusBar->Panels->Add();
  StatusBar->Panels->Items[0]->Width=100;
  StatusBar->Panels->Items[0]->Text="Страница 1";
  StatusBar->Panels->Add();
//  StatusBar->FlipChildren(false);
  StatusBar->Panels->Items[1]->Width=100;
  StatusBar->Parent=this;

//  FormStyle= fsMDIChild;

  AddButton("Print", "Печать", Print);
  AddButton("PrinterSetup", "Параметры печати", PrintSetup);

  AddButton("|", "", NULL);

  AddButton("Last", "Последняя страница", LastPage);
  AddButton("Next", "Следующая страница", NextPage);
  AddButton("Prev", "Предыдущая страница", PrevPage);
  AddButton("First", "Первая страница", FirstPage);

  AddButton("|", "", NULL);

  AddButton("ZoomToWidth", "По ширине", ZoomWidth);
  AddButton("ZoomToFull2", "Полный экран", ZoomFull);
  AddButton("ZoomToFit2", "По странице", ZoomFit);

  KeyPreview=true;

  OnKeyDown=OnUserKeyDown;



}

//---------------------------------------------------------------------------
__fastcall TWTReportView::~TWTReportView(){
//  Report->Tag=0;
//  Report->Cancel();
//  while ((!Report->Cancelled)/* && (!Thread->Suspended)*/) Report->Cancel();
//  delete Thread;
//  Delay(10);
//  ((TWTMainForm*)MainForm)->PreviewForm=NULL;
/*  QRPreview->QRPrinter=NULL;*/
//  QRPreview->QRPrinter=NULL;
//  Report->DataSet=NULL;
//  delete Report;
  delete QRPreview;
}

void __fastcall TWTReportView::NextPage(TObject* Sender){
  QRPreview->PageNumber++;
  StatusBar->Panels->Items[0]->Text="Страница "+IntToStr(QRPreview->PageNumber);
}

//---------------------------------------------------------------------------
void __fastcall TWTReportView::PrevPage(TObject* Sender){
//  Report->Cancel();
//  while ((!Report->Cancelled)/* && (!Thread->Suspended)*/);
  QRPreview->PageNumber--;
  StatusBar->Panels->Items[0]->Text="Страница "+IntToStr(QRPreview->PageNumber);
}

void __fastcall TWTReportView::FirstPage(TObject* Sender){
  QRPreview->PageNumber=1;
  StatusBar->Panels->Items[0]->Text="Страница "+IntToStr(QRPreview->PageNumber);
}

void __fastcall TWTReportView::LastPage(TObject* Sender){
/*  LockWindowUpdate(Handle);
  int PN=0;
  while (PN!=QRPreview->PageNumber) {
    PN=QRPreview->PageNumber;
    QRPreview->PageNumber++;
  }
  LockWindowUpdate(NULL);*/
  QRPreview-> PageNumber=QRPreview->QRPrinter->PageCount;
  StatusBar->Panels->Items[0]->Text="Страница "+IntToStr(QRPreview->PageNumber);
/*  QRPreview-> PageNumber=QRPreview->QRPrinter->LastPage;
  StatusBar->Panels->Items[0]->Text="Страница "+IntToStr(QRPreview->PageNumber);*/
}

void __fastcall TWTReportView::ZoomFit(TObject* Sender){
  QRPreview->ZoomToFit();
}

void __fastcall TWTReportView::ZoomFull(TObject* Sender){
  QRPreview->Zoom=100;
}

void __fastcall TWTReportView::ZoomWidth(TObject* Sender){
  QRPreview->ZoomToWidth();
}

void __fastcall TWTReportView::Print(TObject* Sender){
  QRPreview->QRPrinter->Print();
}

void __fastcall TWTReportView::PrintSetup(TObject* Sender){
  QRPreview->QRPrinter->PrintSetup();
}

void __fastcall TWTReportView::OnShowWin(TObject* Sender){
/*  Report->Prepare();
  QRPreview->QRPrinter=Report->Printer;*/
    //TWTMDIWindow::NoDeactivate = NoDeactivate;
  //TWTMDIWindow::SetNoDeactivate(false);
  // TWTMDIWindow::ShowAs("11");
  QRPreview->ZoomToWidth();
 SetCaption("Печать ("+Report->ReportTitle+")");
   //SetFocus();

  //Report->Preview();
//  Thread=new TWTReportThread(Report,false);
}


void __fastcall TWTReportView::OnUserKeyDown(TObject *Sender,Word &Key, Classes::TShiftState Shift){
  switch (Key) {
    case 33: {
      PrevPage(NULL);
      break;
    }
    case 34: {
      NextPage(NULL);
      break;
    }
    case 35: {
      if (Shift.Contains(ssCtrl)) LastPage(NULL);
      break;
    }
    case 36: {
      if (Shift.Contains(ssCtrl)) FirstPage(NULL);
      break;
    }
    case 32: {
      QRPreview->ScrollBy(0,-10);
      break;
    }
/*    case 37: {
      QRPreview->ScrollBy(5,0);
      break;
    }
    case 38: {
      QRPreview->ScrollBy(0,5);
      break;
    }
    case 39: {
      QRPreview->ScrollBy(-5,0);
      break;
    }
    case 40: {
      QRPreview->ScrollBy(0,-5);
      break;
    } */
  }
}


//---------------------------------------------------------------------------
#pragma package(smart_init)
