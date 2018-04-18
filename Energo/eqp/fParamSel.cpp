//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fParamSel.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfSelParam *fSelParam;
//---------------------------------------------------------------------------
__fastcall TfSelParam::TfSelParam(TComponent* Owner)
         : TfTWTCompForm(Owner)
{
  ZQPar = new TWTQuery(Application);
  ZQPar->Options<< doQuickOpen;
  ZQPar->RequestLive=false;
  ZQPar->CachedUpdates=false;

}
//---------------------------------------------------------------------------
// процедура создания дерева клмпонентов документа
void __fastcall TfSelParam::MakeTree(int root)
{
Tree->Items->Clear();
  ZQPar->Sql->Clear();
  ZQPar->Sql->Add("select id,id_parent,name from cla_param_tbl where eqi_ischild_fun( :root, id) order by lev;");
  ZQPar->ParamByName("root")->AsInteger=root;
  ZQPar->Open();

for (int i=0;i<ZQPar->RecordCount;i++)
{
 int id=ZQPar->FieldByName("id")->AsInteger;
 int id_parent=ZQPar->FieldByName("id_parent")->AsInteger;
 AnsiString name =ZQPar->FieldByName("name")->AsString;

 TTreeNode* Node, *Node2;

 if (id_parent==0) {
  Node=Tree->Items->Add(NULL,name);
  Node->StateIndex=id;
  }
 else
 {
  Node=GetIndex(id_parent,Tree);
  if (Node!=NULL)
   {
    Node2=Tree->Items->AddChild(Node,name);
    Node2->StateIndex=id;
   }
 }
 ZQPar->Next();
}

//Tree->FullExpand();
}
//---------------------------------------------------------------------------
TTreeNode* __fastcall TfSelParam::GetIndex(int id, TTreeView *Tree)
{
 for (int i=0;i<Tree->Items->Count;i++)
 {
  if (Tree->Items->Item[i]->StateIndex==id) return Tree->Items->Item[i];
 }
 return NULL;
}
//----------------------------------------------------------------------------

void __fastcall TfSelParam::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);
 Action = caFree;
}
//---------------------------------------------------------------------------

void __fastcall TfSelParam::TreeChanging(TObject *Sender, TTreeNode *Node,
      bool &AllowChange)
{
  CurrNode=Node;
}
//---------------------------------------------------------------------------

