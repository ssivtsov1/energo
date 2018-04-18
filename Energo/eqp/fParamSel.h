//---------------------------------------------------------------------------

#ifndef fParamSelH
#define fParamSelH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TfSelParam :public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel2;
        TPanel *Panel4Ins;
        TLabel *Label3;
        TLabel *Label4;
        TSpeedButton *SpeedButton6;
        TSpeedButton *SpeedButton7;
        TLabel *Label8;
        TLabel *Label9;
        TComboBox *ComboBox2;
        TMemo *Memo2;
        TRadioButton *RadioButton1;
        TRadioButton *RadioButton2;
        TListView *NextPar;
        TEdit *Edit2;
        TEdit *Edit3;
        TUpDown *UpDown1;
        TTreeView *Tree;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall TreeChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
private:	// User declarations
public:		// User declarations
        __fastcall TfSelParam(TComponent* Owner);
        void __fastcall MakeTree(int root);
        TTreeNode* __fastcall GetIndex(int id, TTreeView *Tree);
        TTreeNode* CurrNode;
        TWTQuery *ZQPar;
};
//---------------------------------------------------------------------------
extern PACKAGE TfSelParam *fSelParam;
//---------------------------------------------------------------------------
#endif
