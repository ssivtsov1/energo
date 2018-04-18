//---------------------------------------------------------------------------
#ifndef EasyPrintH
#define EasyPrintH
//---------------------------------------------------------------------------
#include <comctrls.hpp>
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
#include "PrintUtilMargins.h"
#include "printers.hpp"
#include "printconf.h"
#include "tflogo.h"
#include "tpreview.h"
#include "framelines.h"
#include "TeasyPrintOptions.h"
//---------------------------------------------------------------------------


typedef void __fastcall (__closure *TDBEvent) (TObject *Sender,AnsiString &as);


class PACKAGE TEasyPrint : public TComponent
{
protected:
   TPrintUtilMargins *FMargins;
   TFrameLines *FFrameLines;
   TEasyPrintOptions *FOptions;
   TPrintDialog *tprint;
   void __fastcall PrintDemoString ();
   TDBEvent FOnPrintItem;
   TNotifyEvent FBeforePrintKopf;
   TNotifyEvent FAfterPrintKopf;
   TNotifyEvent FBeforeNeueSeite;
   TNotifyEvent FBeforeDruckEnde;
   AnsiString FTitle;
   AnsiString FHeader1;
   AnsiString FHeader2;
   AnsiString FHeadLine;
   TFont *FHeader1Font;
   TFont *FHeader2Font;
   TFont *FHeadLineFont;
   TFont *FNormalFont;
   TFont *FFettFont;
   AnsiString FCfgFileName;
   float Fza;
   AnsiString FRHeader1;
   AnsiString FRHeader2;
   int y;
   bool DruckBeginn;
   bool FVLine;
   bool FHLine;
   TPrinter *prn;
   int PrinterIndex;
   int col;
   int row;
   bool PrintInitial;
   int pagenum;
   TFLogo *FLogo;
   TCanvas *FCanvas;
   int Alignment;
   int modus;
   Graphics::TBitmap *bitmap;
   AnsiString __fastcall EvalHeaderString (AnsiString h, AnsiString &rh);
   void __fastcall IncreaseY ();
   void __fastcall IncreaseY (double);

   void __fastcall PrintHeader (bool np);
   void __fastcall DruckUber (AnsiString);
   int __fastcall CheckBeginn (bool *);
   bool __fastcall PrintList (void *t,AnsiString uber,short was);
   bool __fastcall PrintInit (bool);
   bool __fastcall Print (void *c,short was,int,int);
   bool __fastcall ReadConfig ();
   void __fastcall SetPrintConf (struct PrintConf *);
   void __fastcall SetDefaultWerte ();
   void __fastcall SetNewFont (TFont *f,struct FontData *fd);
   int __fastcall GetTopMargin (int PageHeight);
   int __fastcall GetBottomMargin (int PageHeight);
   int __fastcall GetLeftMargin (int PageWidth);
   int __fastcall GetRightMargin (int PageWidth);
   AnsiString __fastcall GetHeader1 ();
   AnsiString __fastcall GetHeader2 ();
   void __fastcall SetHeader1 (AnsiString h1);
   void __fastcall SetHeader2 (AnsiString h2);
   void __fastcall SetHeadLine (AnsiString h);
   AnsiString __fastcall GetItem (AnsiString);
   virtual void __fastcall PrintItem (TObject *,AnsiString &);
   virtual void __fastcall BeforePrintKopf (TObject *);
   virtual void __fastcall AfterPrintKopf (TObject *);
   virtual void __fastcall BeforeNeueSeite (TObject *);
   virtual void __fastcall BeforeDruckEnde (TObject *);
   bool __fastcall PrintText (int,AnsiString,bool);
   int __fastcall DrawTreeViewBitmap (TCustomImageList *,int index,int,Graphics::TBitmap *btm);
   AnsiString __fastcall EvalString (AnsiString);
// The following functions are for Delphi support
   virtual void _stdcall CB_Title (AnsiString s);
   virtual void _stdcall CB_NormalFont (TFont *);
   virtual void _stdcall CB_Header1Font (TFont *);
   virtual void _stdcall CB_Header2Font (TFont *);
   virtual void _stdcall CB_BoldFont (TFont *);
   virtual void _stdcall CB_HeadLineFont (TFont *);
   virtual void _stdcall CB_PrintMargins (TPrintUtilMargins *);
   virtual void _stdcall CB_FrameLines (TFrameLines *);
   virtual void _stdcall CB_LineSpacing (float);
   virtual void _stdcall CB_ConfFileName (AnsiString);
   virtual void _stdcall CB_PrintLogo (TFLogo *);
   virtual void _stdcall CB_Header1 (AnsiString);
   virtual void _stdcall CB_Header2 (AnsiString);
   virtual bool _stdcall CB_Print (TListView *tl);
   virtual bool _stdcall CB_Print (TTreeView *tv);
   virtual bool _stdcall CB_Print (TListView *tl,int von,int bis);
   virtual bool _stdcall CB_Print (TTreeView *tv,int von,int bis);
public:
        virtual __fastcall TEasyPrint(TComponent* Owner);
        virtual __fastcall TEasyPrint(TComponent* Owner,void *);
        virtual __fastcall ~TEasyPrint();
        void __fastcall AbortPrinting ();
        virtual void * __fastcall GetDataSet ();
        bool __fastcall PrintBitmap (AnsiString,AnsiString,float,float);
        bool __fastcall PrintBitmap (AnsiString,AnsiString);
        bool __fastcall PrintBitmap (AnsiString);
        bool __fastcall PrintText (AnsiString);
        bool __fastcall PrintText (int,AnsiString);
        bool __fastcall PrintMemo (TMemo *m,AnsiString uber);
        bool __fastcall PrintMemo (TMemo *m);
        bool __fastcall PrintTable (AnsiString s [],int x_count,int y_count,AnsiString uber);
        bool __fastcall PrintTable (AnsiString s [],int x_count,int y_count);
        bool __fastcall PrintList (TListView *t);         // Do not use this function
        bool __fastcall PrintList (TListView *t,AnsiString uber);  // Do not use this function
        bool __fastcall PrintList (TListBox *t);
        bool __fastcall PrintList (TListBox *t,AnsiString uber);
        void __fastcall SetPrinterIndex (short index);
        int __fastcall GetPrinterIndex ();
        void __fastcall PrintEnd ();
        bool __fastcall Print (TListView *tl);
        bool __fastcall Print (TTreeView *tv);
        bool __fastcall Print (TListView *tl,int von,int bis);
        bool __fastcall Print (TTreeView *tv,int von,int bis);
        bool __fastcall PreviewInit ();        // Do not use this function
        int __fastcall GetPageHeight ();
        int __fastcall GetPageWidth ();
        void __fastcall NewPage ();
        bool __fastcall PrintInit ();
        void __fastcall ShowPreview ();         // Do not use this function
        void __fastcall SetFont (TFont *f);
        void __fastcall GetFont (TFont *f);
        int __fastcall GetColumn ();
        int __fastcall GetRow ();
        void __fastcall NewLine ();
        void __fastcall NewLine (double t);
        bool __fastcall SetAlignment (int a);
 __published:
   __property AnsiString Title = {read = FTitle,write = FTitle};
   __property TEasyPrintOptions *Options = {read = FOptions,write = FOptions};
   __property AnsiString Header1 = {read = GetHeader1, write=SetHeader1};
   __property TFont *Header1Font = { read = FHeader1Font, write = FHeader1Font};
   __property AnsiString Header2 = {read = GetHeader2, write=SetHeader2};
   __property TFont *Header2Font = { read = FHeader2Font, write = FHeader2Font};
   __property TFont *HeadLineFont = { read = FHeadLineFont, write = FHeadLineFont};
   __property TFont *NormalFont = { read = FNormalFont, write = FNormalFont};
   __property TFont *BoldFont = { read = FFettFont, write = FFettFont};
   __property TPrintUtilMargins *Margins = { read = FMargins,write=FMargins};
   __property TFrameLines *FrameLines = { read = FFrameLines,write=FFrameLines};
   __property float LineSpacing = {read = Fza, write=Fza};
   __property AnsiString ConfFileName = {read = FCfgFileName, write=FCfgFileName};
   __property TFLogo *PrintLogo = {read = FLogo,write = FLogo};
   __property TDBEvent OnPrintItem ={read = FOnPrintItem, write = FOnPrintItem};
   __property TNotifyEvent BeforePrintHeader = {read = FBeforePrintKopf, write = FBeforePrintKopf};
   __property TNotifyEvent AfterPrintHeader ={read = FAfterPrintKopf, write = FAfterPrintKopf};
   __property TNotifyEvent BeforeNewPage ={read = FBeforeNeueSeite, write = FBeforeNeueSeite};
   __property TNotifyEvent OnPrintEnd ={read = FBeforeDruckEnde, write = FBeforeDruckEnde};

};
//---------------------------------------------------------------------------



#endif
