//---------------------------------------------------------------------------

#ifndef strH
#define strH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZConnect.hpp"
#include "ZPgSqlCon.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZPgSqlTr.hpp"
#include "ZQuery.hpp"
#include "ZTransact.hpp"
#include <Db.hpp>
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <CheckLst.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TMake_sql : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TZPgSqlDatabase *Database;
        TZPgSqlTransact *Transact;
        TZPgSqlQuery *Query;
        TTreeView *Tree;
        TSplitter *Splitter1;
        TSpeedButton *SpeedButton1;
        TPanel *Panel1;
        TPanel *Panel2;
        TEdit *Find;
        TSpeedButton *SpeedButton2;
        TPanel *Panel3;
        TListBox *ListFields;
        TZPgSqlQuery *Query1;
        TSpeedButton *SpeedButton3;
        TSpeedButton *SpeedButton5;
        TCheckListBox *ListSel;
        TSpeedButton *SpeedButton7;
        TTreeView *MiniTree;
        TSpeedButton *SpeedButton8;
        TSpeedButton *SpeedButton9;
        TMemo *Memo1;
        TEdit *Where;
        TCheckBox *CheckBox1;
        TBevel *Bevel1;
        TButton *Button1;
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TSpeedButton *SpeedButton10;
        TEdit *Edit1;
        TSpeedButton *SpeedButton4;
        TLabel *Label6;
        void __fastcall AddTable(AnsiString table_name);
        void __fastcall AddLink(AnsiString string);
        void __fastcall AddToTree(AnsiString parent,AnsiString child);
        int __fastcall GetIndex(AnsiString str, TTreeView *Tree);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall FindChange(TObject *Sender);
        void __fastcall TreeChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
        void __fastcall BitBtn2Click(TObject *Sender);
        void __fastcall ListFieldsClick(TObject *Sender);
        void __fastcall SpeedButton3Click(TObject *Sender);
        void __fastcall ListSelClick(TObject *Sender);
        void __fastcall SpeedButton5Click(TObject *Sender);
        void __fastcall MiniTreeChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
        void __fastcall SpeedButton8Click(TObject *Sender);
        void __fastcall DrawMiniTree();
        void __fastcall AddToMiniTree(AnsiString parent,AnsiString child);
        AnsiString __fastcall AddToFrom(AnsiString from,AnsiString master_table,AnsiString slave_table);
        void __fastcall SpeedButton9Click(TObject *Sender);
        void __fastcall SpeedButton7Click(TObject *Sender);
        void __fastcall AddToArr(AnsiString table);
        void __fastcall SpeedButton10Click(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall SpeedButton11Click(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall SpeedButton4Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TMake_sql(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TMake_sql *Make_sql;
//---------------------------------------------------------------------------
#endif
