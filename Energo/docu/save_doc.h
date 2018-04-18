//---------------------------------------------------------------------------

#ifndef save_docH
#define save_docH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
#include <Mask.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TSaveDoc : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TLabel *Label2;
        TTreeView *GroupTree;
        TSpeedButton *SpeedButton1;
        TSpeedButton *SpeedButton2;
        TLabel *Label3;
        TPanel *Panel1;
        TLabel *Label1;
        TEdit *Edit;
        TPanel *Panel_tmp;
        TLabel *Label6;
        TMaskEdit *MaskEdit2;
        TLabel *Label4;
        TComboBox *ComboBox2;
        TPanel *Panel_doc;
        TLabel *Label5;
        TLabel *Label7;
        TLabel *Label8;
        TEdit *Edit1;
        TComboBox *ComboBox1;
        TComboBox *ComboBox3;
        TLabel *Label9;
        TMemo *Memo1;
        TLabel *Label10;
        TTreeView *Cli;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall MakeTree();
        void __fastcall MakeTreeCli();
        int __fastcall GetIndex(AnsiString str, TTreeView *Tree);
        AnsiString __fastcall GetCode(AnsiString str);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall GroupTreeChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall ComboBox2Change(TObject *Sender);
        void __fastcall ComboBox1Change(TObject *Sender);
        void __fastcall ComboBox3Change(TObject *Sender);
        void __fastcall CliChange(TObject *Sender, TTreeNode *Node);
private:	// User declarations
public:		// User declarations
        __fastcall TSaveDoc(TComponent* Owner);
        int id_doc;
};
//---------------------------------------------------------------------------
extern PACKAGE TSaveDoc *SaveDoc;
//---------------------------------------------------------------------------
#endif
