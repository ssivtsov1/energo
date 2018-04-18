//---------------------------------------------------------------------------

#ifndef client_mainH
#define client_mainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
#include "TWTCompatable.h"
#include "main.h"
#include <Db.hpp>
#include <DBCtrls.hpp>
#include <DBGrids.hpp>
#include <Grids.hpp>

//---------------------------------------------------------------------------
class TClient : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TScrollBox *ScrollBox1;
        TSplitter *Splitter1;
        TPanel *Panel1;
        TSpeedButton *PropBut;
        TButton *Button1;
        TPanel *Panel2;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TMaskEdit *MaskEdit1;
        TBevel *Bevel1;
        TButton *Button2;
        TLabel *Label1;
        TBevel *Bevel2;
        TLabel *Label2;
        TLabel *Label3;
        TEdit *Name;
        TEdit *ShortName;
        TSpeedButton *SpeedButton3;
        TSpeedButton *SpeedButton4;
        TSpeedButton *SpeedButton5;
        TSpeedButton *SpeedButton9;
        TComboBox *Department;
        TDBNavigator *DBNavigator1;
        TDataSource *Data;
        TButton *Kateg;
        void __fastcall PropButClick(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall Clk(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall DrawParam(int id_param, int direction);
        void __fastcall DrawParams();
        void __fastcall Static();
        int __fastcall CreateParam(int id_param, AnsiString value);
        int __fastcall CreateParamN(int id_param);
        void __fastcall FormResize(TObject *Sender);
        void __fastcall Splitter1Moved(TObject *Sender);
        void __fastcall SaveClick(TObject *Sender);
        void __fastcall SpeedClick(TObject *Sender);
        void __fastcall SpClick(TObject *Sender);
        void __fastcall NewClick(TObject *Sender);
        void __fastcall SvClick(TObject *Sender);
        void __fastcall DelClick(TObject *Sender);
        void __fastcall Change(TObject *Sender);
        void __fastcall AddLgot(int id_lgot,AnsiString p_name,AnsiString p_num,AnsiString p_dt,int norm,AnsiString dt,int id_k,int num);
        void __fastcall DestroyAll();
        void __fastcall DBNavigator1Click(TObject *Sender,
          TNavigateBtn Button);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall DBNavigator1BeforeAction(TObject *Sender,
          TNavigateBtn Button);
        void __fastcall KategClick(TObject *Sender);
        //void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall TClient(TComponent* Owner);
        __fastcall ~TClient();
        TWTQuery *Query;
        TWTQuery *Query1;
        TWTQuery *Query2;
        TWTQuery *Query3;
};
//---------------------------------------------------------------------------
extern PACKAGE TClient *Client;
//---------------------------------------------------------------------------
#endif
