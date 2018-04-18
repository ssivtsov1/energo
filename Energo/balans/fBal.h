//---------------------------------------------------------------------------

#ifndef fBalH
#define fBalH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "TWTCompatable.h"
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ImgList.hpp>
#include "fEqpBase.h"
#include "fBalRep.h"
#include "EasyPrint.h"
#include <ToolWin.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
//---------------------------------------------------------------------------
typedef struct
{
  int type_eqp;
  int id_voltage;
//  int line_no;
} TBalTreeNodeData;

typedef  TBalTreeNodeData* PBalTreeNodeData;

class TfBalans :  public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TPanel *pButtons;
        TPanel *PEquipment;
        TPanel *pReps;
        TPanel *Panel2;
        TSplitter *Splitter1;
        TImageList *TreeImageList;
        TLabel *Label1;
        TBitBtn *btGo;
        TBitBtn *btRebyild;
        TBitBtn *btRep3;
        TBitBtn *btRep2;
        TBitBtn *btBalans;
        TDateTimePicker *DateTimePicker;
        TBitBtn *btCheck;
        TEasyPrint *EasyPrint;
        TCoolBar *CoolBar1;
        TToolBar *ToolBar1;
        TToolButton *tbExpand;
        TToolButton *tbCollapse;
        TToolButton *tbPrint;
        TImageList *ImageList1;
        TBitBtn *btRep4;
        TButton *btNoBill;
        TBitBtn *btBalansM;
        TToolButton *ToolButton1;
        TToolButton *tbSwitch;
        TToolButton *tbReconnect;
        TBitBtn *btIndicRebuild;
        TButton *btBalansPS;
        TFindDialog *FindDialog1;
        TToolButton *tbFind;
        TToolButton *ToolButton5;
        TPopupMenu *TreePopupMenu;
        TMenuItem *miUp;
        TMenuItem *miIndication;
        TToolButton *ToolButton4;
        TToolButton *ToolButton6;
        TMenuItem *N1;
        TMenuItem *N2;
        TMenuItem *N3;
        TMenuItem *N4;
        TMenuItem *N5;
        TMenuItem *N6;
        TToolButton *ToolButton2;
        TToolButton *ToolButton7;
        TMenuItem *Excell1;
        TBitBtn *btSwitchRebuild;
        TToolButton *ToolButton3;
        TMenuItem *N7;
        TToolButton *ToolButton8;
        TToolButton *tbFizAbon;
        TToolButton *ToolButton9;
        TMenuItem *N8;
        TToolButton *ToolButton10;
        TToolButton *ToolButton11;
        TToolButton *ToolButton12;
        TToolButton *ToolButton13;
        TToolButton *ToolButton14;
        TToolButton *ToolButton15;
        TPanel *pAbon;
        TLabel *Label4;
        TSpeedButton *sbAbon;
        TEdit *edAbonName;
        TEdit *edAbonCode;
        TToolButton *ToolButton16;
        TToolButton *ToolButton17;
        TMenuItem *LostsExcel1;
        TPanel *Panel3;
        TComboBox *cbTreeSelect;
        TPanel *Panel4;
        TTreeView *tGroupTree;
        TPanel *Panel5;
        TButton *btExcell;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall tGroupTreeChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
        void __fastcall btGoClick(TObject *Sender);
        void __fastcall DateTimePickerChange(TObject *Sender);
        void __fastcall btRebyildClick(TObject *Sender);
        void __fastcall btBalansClick(TObject *Sender);
        void __fastcall btRep2Click(TObject *Sender);
        void __fastcall btRep3Click(TObject *Sender);
        void __fastcall btCheckClick(TObject *Sender);
        void __fastcall tbCollapseClick(TObject *Sender);
        void __fastcall tbExpandClick(TObject *Sender);
        void __fastcall tbPrintClick(TObject *Sender);
//        void __fastcall FormCreate(TObject *Sender);
        void __fastcall btRep4Click(TObject *Sender);
        void __fastcall btNoBillClick(TObject *Sender);
        void __fastcall btExcellClick(TObject *Sender);
        void __fastcall btConectedClick(TObject *Sender);
        void __fastcall btBalansMClick(TObject *Sender);
        void __fastcall tbSwitchClick(TObject *Sender);
        void __fastcall tbReconnectClick(TObject *Sender);
        void __fastcall btIndicRebuildClick(TObject *Sender);
        void __fastcall btBalansPSClick(TObject *Sender);
        void __fastcall tbFindClick(TObject *Sender);
        void __fastcall FindDialog1Close(TObject *Sender);
        void __fastcall FindDialog1Find(TObject *Sender);
        void __fastcall miUpClick(TObject *Sender);
        void __fastcall miIndicationClick(TObject *Sender);
        void __fastcall ToolButton6Click(TObject *Sender);
        void __fastcall TreePopupMenuPopup(TObject *Sender);
        void __fastcall ToolButton7Click(TObject *Sender);
        void __fastcall Excell1Click(TObject *Sender);
        void __fastcall btSwitchRebuildClick(TObject *Sender);
        void __fastcall ToolButton3Click(TObject *Sender);
        void __fastcall tbFizAbonClick(TObject *Sender);
        void __fastcall ToolButton9Click(TObject *Sender);
        void __fastcall N8Click(TObject *Sender);
        void __fastcall ToolButton11Click(TObject *Sender);
        void __fastcall ToolButton13Click(TObject *Sender);
        void __fastcall ToolButton15Click(TObject *Sender);
        void __fastcall sbAbonClick(TObject *Sender);
        void __fastcall AbonAccept (TObject* Sender);
        void __fastcall ToolButton17Click(TObject *Sender);
        void __fastcall N5Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfBalans(TComponent* Owner);
       void __fastcall ShowData(void);

       int ResId;
       AnsiString ResName;
       TZPgSqlQuery *ZQBalans;
       TZPgSqlQuery *ZQBalans2;
       TTreeNode *CurrNode;
       TfEqpEdit *EqpEdit;
   //    TfBalansRep * BalansReports;
       AnsiString sqlstr;
       TList* NodeDataList;
       TDateTime mmgg;
       TWTWinDBGrid *WErrGrid;
       TWTWinDBGrid *WNoBillGrid;

       int slav_mode;

       void ShowTrees(void);
       void BuildTreeNode(int code_eqp,int code_eqp_p,int id_icon,int type_eqp,int id_voltage,AnsiString name);
       void BuildTreeRoot(int code_eqp,int code_eqp_p,int id_icon,int type_eqp,int id_voltage,AnsiString name);
       void BuildTree(int tree_id, AnsiString tree_name, bool refresh);
       void __fastcall ErrAccept (TObject* Sender);
       void __fastcall NoBillAccept (TObject* Sender);
       void __fastcall NoBillToXL(TObject *Sender);
       void __fastcall ShowErrGrid(void);

      typedef map<int,int> iimap;
       iimap TreesMap;

      typedef map<int,TTreeNode*> intmap;
       intmap FullTreeNodesMap; // —труктура дл€ ускорени€ поиска узла дерева 
};
//---------------------------------------------------------------------------
//extern PACKAGE TfBalans *fBalans;
//---------------------------------------------------------------------------
#endif
