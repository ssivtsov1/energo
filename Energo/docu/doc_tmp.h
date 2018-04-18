//---------------------------------------------------------------------------

#ifndef doc_tmpH
#define doc_tmpH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include "CCALENDR.h"
#include <Grids.hpp>
#include <Buttons.hpp>
#include <ToolWin.hpp>
#include <DBCtrls.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TDoc_temp : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TTreeView *Doc;
        TSplitter *Splitter1;
        TDBImage *DBImage1;
        TControlBar *ControlBar1;
        TPageScroller *PageScroller1;
        TPageScroller *PageScroller2;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TSpeedButton *AlignLeft;
        TSpeedButton *AlignCenter;
        TSpeedButton *AlignRight;
        TSpeedButton *SpeedButton3;
        TSpeedButton *SpeedButton4;
        TScrollBox *ScrollBox1;
        TSpeedButton *SpeedButton5;
        TFontDialog *FontDialog1;
        TPanel *Panel1;
        TToolBar *ToolBar1;
        TSpeedButton *SpeedButton6;
        TSpeedButton *SpeedButton7;
        TSpeedButton *SpeedButton8;
        TSpeedButton *SpeedButton9;
        TPanel *Panel2;
        TEdit *Edit1;
        TSpeedButton *SpeedButton10;
        TSpeedButton *SpeedButton11;
        TSaveDialog *SaveFile;
        TMemo *Memo1;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall MakeTree();
        void __fastcall GetData();
        void __fastcall ResizeForm();
        int __fastcall GetIndex(AnsiString str, TTreeView *Tree);
        int __fastcall GetSubIndex(int parent);
        int __fastcall GetMaxRow(int id);
        int __fastcall GetNumCol(int id,int id_parent);
        int __fastcall GetTabRow(int id_tab);
        int __fastcall GetTabCol(int id_tab);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormResize(TObject *Sender);
        void __fastcall Splitter1Moved(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall DocChange(TObject *Sender, TTreeNode *Node);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall FontDialog1Apply(TObject *Sender, HWND Wnd);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall AlignLeftClick(TObject *Sender);
        void __fastcall AlignCenterClick(TObject *Sender);
        void __fastcall AlignRightClick(TObject *Sender);
        void __fastcall setAlign(TMemo *memo);
        void __fastcall MemoClk(TObject *Sender);
        void __fastcall AddTable(int id_table, int id);
        void __fastcall DrawTable(int id_tab, TPanel *pan);
        void __fastcall SortTable(int id_tab);
        void __fastcall ResizeTable(int id_tab,TPanel *cur_pan,int id_compl);
        void __fastcall Refresh();
        void __fastcall MakeDoc();
        void __fastcall MakeContext();
        void __fastcall DocSave(AnsiString name_d,AnsiString reg_d,int kind_docum,AnsiString descript);
        void __fastcall DocSave1();
        void __fastcall DocReg(AnsiString reg_date,AnsiString reg_num,int id_t,int id_d,int id_client);
        AnsiString __fastcall ParseTag(AnsiString teg);
        AnsiString __fastcall GetValue(AnsiString value,AnsiString test);
        AnsiString __fastcall Parse(AnsiString text,int num);
        AnsiString __fastcall Prep(AnsiString mem);
        AnsiString __fastcall InsertIntoStr(AnsiString str,int off,AnsiString cc);
        void __fastcall N7Click(TObject *Sender);
        void __fastcall SpeedButton3Click(TObject *Sender);
        void __fastcall SpeedButton4Click(TObject *Sender);
        void __fastcall SpeedButton5Click(TObject *Sender);
        void __fastcall Enter(TObject *Sender);
        void __fastcall Sizer(int id,int height);
        void __fastcall SpeedButton6Click(TObject *Sender);
        void __fastcall SpeedButton7Click(TObject *Sender);
        void __fastcall SpeedButton9Click(TObject *Sender);
        void __fastcall AddField(AnsiString string,AnsiString nm);
        void __fastcall GetById(int pos);
        void __fastcall SpeedButton11Click(TObject *Sender);
        void __fastcall SpeedButton10Click(TObject *Sender);
        int __fastcall Num_child(int parent);
        int __fastcall MaxCols(int parent);
        void __fastcall InsertFile(int iFileHandle, int offset, AnsiString text,AnsiString type);
private:	// User declarations
public:		// User declarations
        __fastcall TDoc_temp(TComponent* Owner);
        int id_doc,fffff,create,kind_doc,id_grp,save,view,id_document;
        AnsiString name_doc;
};
//---------------------------------------------------------------------------
extern PACKAGE TDoc_temp *Doc_temp;
//---------------------------------------------------------------------------
#endif
