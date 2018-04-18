//---------------------------------------------------------------------------

#ifndef moveH
#define moveH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TMv : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TButton *MoveBut;
        TButton *Button2;
        TLabel *Label1;
        TLabel *Label3;
        TTreeView *GroupTree;
        TEdit *Doc_name;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall MakeTree();
        int __fastcall GetIndex(AnsiString str, TTreeView *Tree);
        int __fastcall GetIndexById(int id, TTreeView *Tree);
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall MoveButClick(TObject *Sender);
        void __fastcall GroupTreeChanging(TObject *Sender, TTreeNode *Node,
          bool &AllowChange);
private:	// User declarations
public:		// User declarations
        __fastcall TMv(TComponent* Owner);
        int id_grp,id_doc;
};
//---------------------------------------------------------------------------
extern PACKAGE TMv *Mv;
//---------------------------------------------------------------------------
#endif
