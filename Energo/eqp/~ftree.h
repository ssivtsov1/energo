//---------------------------------------------------------------------------

#ifndef ftreeH
#define ftreeH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ToolWin.hpp>
#include <ExtCtrls.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
#include "fEqpBase.h"
//---------------------------------------------------------------------------

typedef struct
{
  int type_eqp;
} TTreeNodeData;

typedef  TTreeNodeData* PTreeNodeData;

class TfTreeForm : public TForm
{
__published:	// IDE-managed Components
        TCoolBar *CoolBar1;
        TToolBar *ToolBar1;
        TStatusBar *StatusBar1;
        TPanel *PTree;
        TSplitter *TreeSplitter;
        TPanel *PEquipment;
        TTreeView *tTreeEdit;
        TImageList *TreeImageList;
        TPopupMenu *TreePopupMenu;
        TMenuItem *miDel;
        TMenuItem *miNew;
        TToolButton *tbNew;
        TToolButton *tbDelete;
        TToolButton *tbCancel;
        TToolButton *tbApply;
        TToolButton *tbChange;
        TToolButton *tbNewTree;
        TToolButton *tbDelTree;
        TMenuItem *N1;
        TMenuItem *miDown;
        TMenuItem *miUp;
        TMenuItem *N2;
        TMenuItem *miAddTranzit;
        TMenuItem *miDelTranzit;
        TMenuItem *N3;
        TMenuItem *miDelTree;
        TToolButton *ToolButton3;
        TToolButton *ToolButton4;
        TToolButton *tbNewPoint;
        TToolButton *tbPointConnect;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall ToolButton1Click(TObject *Sender);
        void __fastcall ToolButton2Click(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall tTreeEditChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall tbNewClick(TObject *Sender);
        void __fastcall tbApplyClick(TObject *Sender);
        void __fastcall tbCancelClick(TObject *Sender);
        void __fastcall tbDeleteClick(TObject *Sender);
        void __fastcall tTreeEditDragOver(TObject *Sender, TObject *Source,
          int X, int Y, TDragState State, bool &Accept);
        void __fastcall tTreeEditStartDrag(TObject *Sender,
          TDragObject *&DragObject);
        void __fastcall tTreeEditDragDrop(TObject *Sender, TObject *Source,
          int X, int Y);
        void __fastcall tbChangeClick(TObject *Sender);
        void __fastcall tTreeEditEdited(TObject *Sender, TTreeNode *Node,
          AnsiString &S);
        void __fastcall tbDelTreeClick(TObject *Sender);
        void __fastcall tbNewTreeClick(TObject *Sender);
        void __fastcall tTreeEditDblClick(TObject *Sender);
        void __fastcall miUpClick(TObject *Sender);
        void __fastcall miDownClick(TObject *Sender);
        void __fastcall miAddTranzitClick(TObject *Sender);
        void __fastcall miDelTranzitClick(TObject *Sender);
        void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
        void __fastcall tbNewPointClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
       void BuildTreeRoot(int code_eqp,int code_eqp_p,int id_icon,int type_eqp,AnsiString name);
       void BuildTreeNode(int code_eqp,int code_eqp_p,int id_icon,int type_eqp, AnsiString name);
       void BuildTree(int tree_id, AnsiString tree_name, bool refresh);
       void ShowTrees(int abonent,bool readonly = false);
       void __fastcall ClearTemp(void);

       void _fastcall ActivateMenu(TObject *Sender);
       TMenuItem *WindowMenu;
       AnsiString ID;

       TZPgSqlQuery *ZQTree;
       TfEqpEdit *EqpEdit;
//       int tree_id;
//       AnsiString tree_name;
       int usr_id;
       int abonent_id; //Обонент, для которого строятся схемы
       int parent_abonent; //Обонент верхнего уровня
       AnsiString sqlstr;

       int tree_id; //Временно, пока не доделаю

       int CurrTreeId;  //Дерево, которое только что поредактировали
       int NewTreeId;  //Дерево - получатель в операциях переноса
       int EqpType;    // Тип текущего узла
       TfTreeForm* fSelectTree;  //Окно дерева для выбора элемента дерева-предка
       int BorderParent; // идент. узла в дереве верхнего уровня, к которому подкл. граница
       int ParentTree;  //Дерево -предок (принадлежит другому обоненту)

       TTreeNode *CurrNode;
       TTreeNode *NewNode;
       TTreeNode *DragNode;
       TTreeNode *NewTree;

       TList* NodeDataList;

       int NewParentId;
       int WorkNodeId;

       int treemode;  //Текущая операция с деревом
       // 0 - нейтрльное
       // 1 - вставка
       // 2 - перемещение
       // 3 - удаление
       // 4 - новое дерево
       // 41- новое дерево - субобонент
       // 5 - удаление дерева
       // 6 - Подключение существующего дерева как субобонента
       TStringList* TreeList;

        __fastcall TfTreeForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfTreeForm *fTreeForm;
//---------------------------------------------------------------------------
#endif
