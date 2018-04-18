//---------------------------------------------------------------------------

#ifndef cat_listH
#define cat_listH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "TWTCompatable.h"
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <DBGrids.hpp>
#include <Grids.hpp>
#include "ZConnect.hpp"
#include "ZPgSqlCon.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZPgSqlTr.hpp"
#include "ZQuery.hpp"
#include "ZTransact.hpp"
#include <Db.hpp>
#include <DBTables.hpp>
#include <DBCtrls.hpp>
//---------------------------------------------------------------------------
class TKateg : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TTreeView *Tree;
        TSplitter *Splitter1;
        TPanel *Panel1;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TSpeedButton *SpeedButton3;
        TPanel *Panel2;
        TPanel *New_b;
        TLabel *Label2;
        TLabel *Label3;
        TEdit *Edit1;
        TSpeedButton *SpeedButton5;
        TPanel *New_k;
        TLabel *Label4;
        TLabel *Label5;
        TEdit *Edit2;
        TDBGrid *DBGrid1;
        TDataSource *Data_s;
        TDataSource *Tarifs_s;
        TZPgSqlDatabase *ZPgSqlDatabase1;
        TZPgSqlTransact *ZPgSqlTransact1;
        TZPgSqlTable *Tarifs;
        TZPgSqlQuery *Data;
        TIntegerField *Dataid_t;
        TIntegerField *Dataid_k;
        TDateField *Datadt;
        TIntegerField *Datamin;
        TIntegerField *Dataone;
        TIntegerField *Datamax;
        TStringField *Datatarif;
        TLabel *Label1;
        TEdit *Edit3;
        TSpeedButton *SpeedButton6;
        TDBNavigator *DBNavigator1;
        TLabel *Label6;
        TEdit *Edit4;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall DataAfterInsert(TDataSet *DataSet);
        void __fastcall DataAfterPost(TDataSet *DataSet);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall MakeTree();
        int __fastcall GetIndex(AnsiString ind, TTreeView *Tree);
        void __fastcall TreeChange(TObject *Sender, TTreeNode *Node);
        void __fastcall Hide();
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton3Click(TObject *Sender);
        void __fastcall SpeedButton6Click(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TKateg(TComponent* Owner);
        TWTQuery *Query;
};
//---------------------------------------------------------------------------
extern PACKAGE TKateg *Kateg;
//---------------------------------------------------------------------------
#endif
