//---------------------------------------------------------------------------
#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "WTGrids.h"
#include <Grids.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
//#include "DCColorCombo.hpp"
//#include "dcedit.hpp"
#include ".\\include\\Exec.h"
#include <QRPrntr.hpp>
#include <ComCtrls.hpp>
#include <ToolWin.hpp>
#include <Mask.hpp>
#include <ImgList.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TSpeedButton *SpeedButton3;
        TSpeedButton *SpeedButton4;
        TSpeedButton *SpeedButton5;
        TSpeedButton *SpeedButton6;
        TBevel *Bevel1;
        TBevel *Bevel2;
        TComboBox *ComboBox1;
        TSpeedButton *SpeedButton7;
        TSpeedButton *SpeedButton8;
        TSpeedButton *SpeedButton9;
        TSpeedButton *SpeedButton10;
        TSpeedButton *SpeedButton11;
        TSpeedButton *SpeedButton12;
        TSpeedButton *SpeedButton13;
        TSpeedButton *SpeedButton14;
        TSpeedButton *SpeedButton15;
        TSpeedButton *SpeedButton16;
        TSpeedButton *SpeedButton17;
        TCheckBox *CheckBox1;
        TSpeedButton *SpeedButton18;
        TSpeedButton *SpeedButton19;
        TSplitter *Splitter1;
        TCoolBar *CoolBar1;
        TToolBar *ToolBar1;
        TToolButton *ToolButton1;
        TToolButton *ToolButton2;
        TToolButton *ToolButton3;
        TToolButton *ToolButton4;
        TComboBox *ComboBox2;
        TComboBox *ComboBox3;
        TBevel *Bevel3;
        TBevel *Bevel4;
        TSpeedButton *SpeedButton20;
        TEdit *Edit1;
        TEdit *Edit2;
        TMemo *Memo1;
        TSpeedButton *SpeedButton21;
        TSpeedButton *SpeedButton22;
        TSpeedButton *SpeedButton23;
        TSpeedButton *SpeedButton24;
        TEdit *Edit3;
        TEdit *Edit4;
        TSpeedButton *SpeedButton25;
        TSpeedButton *SpeedButton26;
  TPanel *Panel2;
  TQRPreview *QRPreview1;
  TSplitter *Splitter2;
  TMemo *Memo2;
  TToolButton *ToolButton5;
  TToolButton *ToolButton6;
  TImageList *ImageList1;
        void __fastcall SpeedButton6Click(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall SpeedButton5Click(TObject *Sender);
        void __fastcall SpeedButton4Click(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton3Click(TObject *Sender);
        void __fastcall SpeedButton7Click(TObject *Sender);
        void __fastcall SpeedButton8Click(TObject *Sender);
        void __fastcall SpeedButton9Click(TObject *Sender);
        void __fastcall SpeedButton10Click(TObject *Sender);
        void __fastcall SpeedButton11Click(TObject *Sender);
        void __fastcall SpeedButton12Click(TObject *Sender);
        void __fastcall SpeedButton13Click(TObject *Sender);
        void __fastcall SpeedButton14Click(TObject *Sender);
        void __fastcall SpeedButton15Click(TObject *Sender);
        void __fastcall SpeedButton16Click(TObject *Sender);
        void __fastcall SpeedButton17Click(TObject *Sender);
        void __fastcall CheckBox1Click(TObject *Sender);
        void __fastcall SpeedButton18Click(TObject *Sender);
        void __fastcall SpeedButton19Click(TObject *Sender);
        void __fastcall ToolButton1Click(TObject *Sender);
        void __fastcall ToolButton2Click(TObject *Sender);
        void __fastcall ToolButton4Click(TObject *Sender);
        void __fastcall SpeedButton20Click(TObject *Sender);
        void __fastcall SpeedButton21Click(TObject *Sender);
        void __fastcall SpeedButton22Click(TObject *Sender);
        void __fastcall SpeedButton23Click(TObject *Sender);
        void __fastcall SpeedButton24Click(TObject *Sender);
        void __fastcall SpeedButton25Click(TObject *Sender);
        void __fastcall SpeedButton26Click(TObject *Sender);
  void __fastcall ToolButton5Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
  TWTExec* Exec;
        __fastcall TForm1(TComponent* Owner);
        __fastcall ~TForm1();
  void __fastcall FFKeyPress(TObject* Sender, char &Key);
        TWTCellGrid *CC;
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------

class My: public TCustomControl {
  public:
    virtual __fastcall My(TComponent *AOwner);
    virtual void __fastcall Paint();
};


#endif
 