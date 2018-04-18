//---------------------------------------------------------------------------

#ifndef docuH
#define docuH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <ComCtrls.hpp>
#include <Buttons.hpp>
#include <ToolWin.hpp>
#include <Menus.hpp>
#include <ExtCtrls.hpp>
#include <ImgList.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TMain_doc : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TTreeView *GroupTree;
        TStatusBar *StatusBar1;
        TListView *TypeDoc;
        TSplitter *Splitter1;
        TControlBar *ControlBar1;
        TPageScroller *PageScroller1;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TSpeedButton *SpeedButton3;
        TSpeedButton *SpeedButton4;
        TSpeedButton *SpeedButton5;
        TSpeedButton *SpeedButton6;
        TSplitter *Splitter3;
        TPageScroller *PageScroller2;
        TLabel *Label1;
        TSpeedButton *ViewStyle1;
        TSpeedButton *ViewStyle2;
        TSpeedButton *SpeedButton7;
        TSpeedButton *SpeedButton8;
        TBevel *Bevel1;
        TPageScroller *PageScroller3;
        TSpeedButton *SpeedButton9;
        TSpeedButton *SpeedButton10;
        TPageScroller *PageScroller4;
        TSpeedButton *SpeedButton11;
        TPageScroller *PageScroller5;
        TSpeedButton *SpeedButton15;
        TSpeedButton *SpeedButton16;
        TPopupMenu *PopupMenu1;
        TMenuItem *N15;
        TMenuItem *N16;
        TMenuItem *N17;
        TMenuItem *N18;
        void __fastcall N2Click(TObject *Sender);
        void __fastcall GroupTreeChange(TObject *Sender, TTreeNode *Node);
        void __fastcall ViewCheck(TMenuItem *N);
        void __fastcall FormCreate(TObject *Sender);
        int __fastcall  GetIndex(AnsiString str,  TTreeView *Tree);
        int __fastcall  GetIndex1(AnsiString str,  TTreeView *Tree, int index);
        int __fastcall  GetIndexDB();
        void __fastcall Refresh();
        void __fastcall GetData();
        void __fastcall MakeTree();
        void __fastcall Prepare();
        void __fastcall TypeDocDblClick(TObject *Sender);
        void __fastcall N11Click(TObject *Sender);
        void __fastcall ViewStyle1Click(TObject *Sender);
        void __fastcall ViewStyle2Click(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall SpeedButton5Click(TObject *Sender);
        void __fastcall SpeedButton7Click(TObject *Sender);
        void __fastcall SpeedButton8Click(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall SpeedButton9Click(TObject *Sender);
        void __fastcall SpeedButton10Click(TObject *Sender);
        void __fastcall SpeedButton15Click(TObject *Sender);
        void __fastcall SpeedButton16Click(TObject *Sender);
        void __fastcall N15Click(TObject *Sender);
        void __fastcall N16Click(TObject *Sender);
        void __fastcall N17Click(TObject *Sender);
        void __fastcall N18Click(TObject *Sender);
        void __fastcall TypeDocColumnClick(TObject *Sender,
          TListColumn *Column);
        void __fastcall TypeDocChange(TObject *Sender, TListItem *Item,
          TItemChange Change);
private:	// User declarations
public:		// User declarations
        __fastcall TMain_doc(TComponent* Owner);
        TList *GrpList;
        AnsiString filt_str;
};
//---------------------------------------------------------------------------
extern PACKAGE TMain_doc *Main_doc;
//---------------------------------------------------------------------------
#endif
