//---------------------------------------------------------------------------

#ifndef sqlH
#define sqlH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Grids.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include "ZConnect.hpp"
#include "ZPgSqlCon.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZPgSqlTr.hpp"
#include "ZQuery.hpp"
#include "ZTransact.hpp"
#include <Db.hpp>
#include <DBGrids.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TGenerator : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TStringGrid *Grid;
        TComboBox *ComboBox1;
        TEdit *Edit5;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TCheckBox *CheckBox1;
        TCheckBox *CheckBox2;
        TCheckBox *CheckBox3;
        TCheckBox *CheckBox4;
        TCheckBox *CheckBox5;
        TCheckBox *CheckBox6;
        TSpeedButton *SpeedButton3;
        TMemo *Memo1;
        TSpeedButton *SpeedButton4;
        TCheckBox *CheckBox7;
        TPanel *Panel1;
        TComboBox *ComboDB;
        TLabel *Label1;
        TComboBox *ComboBox3;
        TCheckBox *CheckBox8;
        TEdit *Edit6;
        TCheckBox *CheckBox9;
        TComboBox *ComboBox4;
        TCheckBox *CheckBox10;
        TZPgSqlDatabase *DB;
        TZPgSqlTransact *T;
        TZPgSqlQuery *Query;
        TZPgSqlQuery *Query1;
        TComboBox *ListTB;
        TZPgSqlDatabase *DB2Connect;
        TZPgSqlTransact *T1;
        TComboBox *ListF;
        TComboBox *ListF1;
        TComboBox *ListTM;
        TComboBox *ListFM;
        TDataSource *DataSource1;
        TDBGrid *DBGrid1;
        TLabel *Label2;
        TPanel *Panel2;
        TSpeedButton *SpeedButton5;
        TLabel *Label3;
        TSpeedButton *SpeedButton6;
        TLabel *Label4;
        TEdit *Edit1;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall Ch(TObject *Sender);
        void __fastcall RemoveRow(int row);
        void __fastcall ComboBox1Change(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton3Click(TObject *Sender);
        void __fastcall SpeedButton4Click(TObject *Sender);
        void __fastcall GridDblClick(TObject *Sender);
        void __fastcall CheckBox1Click(TObject *Sender);
        void __fastcall ComboBox3Change(TObject *Sender);
        void __fastcall ComboBox4Change(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall ComboDBChange(TObject *Sender);
        void __fastcall ListTBChange(TObject *Sender);
        void __fastcall ListFChange(TObject *Sender);
        void __fastcall ListF1Change(TObject *Sender);
        void __fastcall ListTMChange(TObject *Sender);
        void __fastcall ListFMChange(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall SpeedButton5Click(TObject *Sender);
        void __fastcall SpeedButton6Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TGenerator(TComponent* Owner);
        int id_doc,id_parent,num;
};
//---------------------------------------------------------------------------
extern PACKAGE TGenerator *Generator;
//---------------------------------------------------------------------------
#endif
