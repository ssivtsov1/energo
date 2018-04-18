//---------------------------------------------------------------------------
//����� ����������� �������� � ������������� �����

#include <vcl.h>
#pragma hdrstop

#include "ftree.h"
#include "Main.h"
#include "fEqpBase.h"
#include "fEqpBorderDet.h"
#include <Printers.hpp>
#include "fChange.h"
#include "AbonConnect.h"
#include "DelEqpList.h"
#include "fHist.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma link "EasyPrint"
#pragma link "EasyPrint"
#pragma resource "*.dfm"
TfTreeForm *fTreeForm;
TTreeNode *Node1;
TTreeNode *Node2;
TWTWinDBGrid *WPointGrid;
TWTDBGrid* WAbonGrid;
PTreeListData TreeData;

static int Copy_tree =0;
static int Copy_node =0;
static int Move_node =0;
//typedef map<int,TTreeNode*> intmap;
//intmap TreeNodesMap;
//intmap TreeMap;
AnsiString SerchStr;

//---------------------------------------------------------------------------
__fastcall TfTreeForm::TfTreeForm(TComponent* Owner)
           : TfTWTCompForm(Owner)
{
  usr_id=1;      //       !!!!!!!!!!!!!!
  //CangeLogEnabled=true;   //!!!!!!!!!
 // tree_id=1;    //       !!!!!!!!!!!!!!

  treemode=0;  //����� ���������-��������
  operation=0;
  //Parent=MainForm;
  ZQTree = new TWTQuery(Application);
  ZQTree->MacroCheck=true;
  TZDatasetOptions Options;
  Options.Clear();
  Options << doQuickOpen;
  ZQTree->Options=Options;
  ZQTree->RequestLive=false;
  ZQTree->CachedUpdates=false;
//  ZQTree->Transaction->AutoCommit=false;
//  ZQTree->Transaction->TransactSafe=true;
//  ZQTree->Transaction->NewStyleTransactions=false;
  //ZQTree->Transaction->TransIsolation = ptDefault;   // OSA
  //TreeList = new TStringList();
  TreeList = new TList();
  NodeDataList = new TList;
//------------------------
  if (WindowState!=wsMaximized)
  {
   Left=1;
   Top=1;
   Height=MainForm->Height-100;
   Width=MainForm->Width-32;
  };
//--------------------------------------

  newtree_enable=CheckLevel("����� 1 - ����� �����")!=0 ;
  deltree_enable=CheckLevel("����� 1 - �������� �����")!=0 ;
  neweqp_enable= CheckLevel("����� 1 - ����� ������������")!=0 ;
  deleqp_enable= CheckLevel("����� 1 - �������� ������������")!=0 ;
  point_enable = CheckLevel("����� 1 - �������� ����� ���������")!=0 ;
  change_enable= CheckLevel("����� 1 - ������ ������������")!=0 ;
  copy_enable=   CheckLevel("����� 1 - ����������� ������������")!=0 ;
  movefiz_enable=CheckLevel("����� 1 - ������� ���.���")!=0 ;
  edtree_enable= CheckLevel("����� 1 - ��������� �����")!=0 ;

  tbNewTree->Enabled =newtree_enable;
  tbNewPoint->Enabled =point_enable;
  tbConnect->Enabled =point_enable;

  tTreeEdit->ReadOnly =!edtree_enable;
}
//---------------------------------------------------------------------------

//void _fastcall TfTreeForm::ActivateMenu(TObject *Sender) {
//  if (Enabled) Show();
//}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::FormClose(TObject *Sender,
      TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);

EqpEdit->Close();

 /*
ClearTemp();
delete ZQTree;
delete CoolBar1;
delete TreeList;

for (int i=0;i<NodeDataList->Count;i++)
{
 delete (NodeDataList->Items[i]);
} 
delete NodeDataList;
*/
Action = caFree;

}
//---------------------------------------------------------------------------
/*__fastcall TfTreeForm::~TfTreeForm(void)
{
 ClearTemp();
 delete ZQTree;
 delete CoolBar1;
 delete TreeList;

 for (int i=0;i<NodeDataList->Count;i++)
 {
 delete (NodeDataList->Items[i]);
 }
 delete NodeDataList;

}
*/
//---------------------------------------------------------------------------
void TfTreeForm::BuildTreeRoot(int code_eqp,TTreeNode* RootNode,int id_icon,int type_eqp,int line_no, AnsiString name,int id_tree)
{
// TTreeNode *Node1;
// for (int j=0;j<=tTreeEdit->Items->Count-1;j++)
//  {
//   if((tTreeEdit->Items->Item[j]->StateIndex==code_eqp_p)&&(tTreeEdit->Items->Item[j]->ImageIndex==0))
//       (PTreeNodeData(tTreeEdit->Items->Item[j]->Data)->line_no==0))
//    {
     Node1=tTreeEdit->Items->AddChild(RootNode,name);
     Node1->StateIndex=code_eqp;
     Node1->ImageIndex=id_icon;
     Node1->SelectedIndex=id_icon;

     if (line_no==0)
     {
        TreeNodesMap[code_eqp]=Node1;
        FullTreeNodesMap[code_eqp]=Node1;
     }

     PTreeNodeData NodeData= new TTreeNodeData;
     NodeData->type_eqp=type_eqp;
     NodeData->line_no=line_no;
     NodeData->id_tree=id_tree;
     Node1->Data=NodeData;
     NodeDataList->Add(NodeData);
//     break;
//    }
//  }
}
//---------------------------------------------------------------------------
void TfTreeForm::BuildTreeNode(int code_eqp,int code_eqp_p,int id_icon,int type_eqp,int line_no, AnsiString name,int id_tree)
{
// TTreeNode *Node1;
// for (int j=0;j<=tTreeEdit->Items->Count-1;j++)
//  {
//   if((tTreeEdit->Items->Item[j]->StateIndex==code_eqp_p)&&(tTreeEdit->Items->Item[j]->ImageIndex!=0)&&
//    (PTreeNodeData(tTreeEdit->Items->Item[j]->Data)->line_no==0))
//    {
     //int j= TreeNodesMap[code_eqp_p];

//     Node1=tTreeEdit->Items->AddChild(tTreeEdit->Items->Item[j],name);

     Node1=tTreeEdit->Items->AddChild(TreeNodesMap[code_eqp_p],name);
     Node1->StateIndex=code_eqp;
     Node1->ImageIndex=id_icon;
     Node1->SelectedIndex=id_icon;

     if (line_no==0)
     {
        TreeNodesMap[code_eqp]=Node1;
        FullTreeNodesMap[code_eqp]=Node1;
     }

     PTreeNodeData NodeData= new TTreeNodeData;
     NodeData->type_eqp=type_eqp;
     NodeData->line_no=line_no;
     NodeData->id_tree=id_tree;
     Node1->Data=NodeData;
     NodeDataList->Add(NodeData);


//     break;
//    }
//  }
}
//---------------------------------------------------------------------------
bool TfTreeForm::SelectTrees(void)
{
  bool status=true;
/*
  AnsiString sqlstr="select eq_sel_tree( :id, :usr );";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("id")->AsInteger=abonent_id;
  ZQTree->ParamByName("usr")->AsInteger=usr_id;

  try
   {
   ZQTree->Open();
   //ZRunProc->ExecSql();
   }
  catch(...)
   {
//    ShowMessage("������ SQL :"+sqlstr);
    ShowMessage("������ ���������� ��������� ������. ���� ����� �������.");
    ZQTree->Close();
    ZQTree->Transaction->Rollback();                 //<<<<
    Close();
    return false;
   }
  status =ZQTree->Fields->Fields[0]->AsBoolean;
  ZQTree->Close();
  ZQTree->Transaction->Commit();
  */
  return status;
}
//---------------------------------------------------------------------------
void TfTreeForm::BuildTree(int tree_id, AnsiString tree_name, bool refresh)
{
//  if (!EqpEdit->Visible) EqpEdit->Show();

//  tree_id=id;

  if (!Visible) Show();
  //-------------------------------
  //  ������ ���� - ���������
  //tTreeEdit->Items->BeginUpdate();
//  tTreeEdit->Items->Clear();
  TTreeNode *RootNode1;
//  bool status;
  RootNode1=tTreeEdit->Items->Add(NULL, tree_name);
  RootNode1->StateIndex=tree_id;
  RootNode1->ImageIndex=0;
  RootNode1->SelectedIndex=0;

  PTreeNodeData NodeData= new TTreeNodeData;
  NodeData->type_eqp=0;
  NodeData->line_no=0;
  NodeData->id_tree=tree_id;
  RootNode1->Data=NodeData;
  NodeDataList->Add(NodeData);

  //--------------------------------
  /*
  if (refresh) // ����������� ��������� �������
  {
  sqlstr="select eq_sel_tree( :id, :usr );";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("id")->AsInteger=tree_id;
  ZQTree->ParamByName("usr")->AsInteger=usr_id;

  try
   {
   ZQTree->Open();
   //ZRunProc->ExecSql();
   }
  catch(...)
   {
//    ShowMessage("������ SQL :"+sqlstr);
    ShowMessage("������ ���������� ��������� ������. ���� ����� �������.");
    ZQTree->Close();
    ZQTree->Transaction->Rollback();                 //<<<<
    Close();
    return;
   }
  status =ZQTree->Fields->Fields[0]->AsBoolean;
  ZQTree->Close();
  ZQTree->Transaction->Commit();
  }
  else status=true;
*/
//  if (status)
//  {
   //������ ������ � ���� �� ��������� �������
//   sqlstr="select code_eqp,code_eqp_p,name,id_icon,type_eqp,line_no from eqt_tree where (id_usr= :usr)and(id_tree= :tree) Order By lvl,line_no;";

   sqlstr=" Select tt.code_eqp,tt.code_eqp_e as code_eqp_p ,tt.name,eq.type_eqp,tt.line_no, dkp.id_icon \
   From eqm_eqp_tree_tbl AS tt JOIN eqm_equipment_tbl AS eq ON (tt.code_eqp=eq.id) \
   JOIN (eqi_device_kinds_tbl AS dk JOIN eqi_device_kinds_prop_tbl AS dkp ON (dk.id=dkp.type_eqp)) ON (eq.type_eqp=dk.id) \
   left join eqm_borders_tbl as b on (b.code_eqp=eq.id) \
   left join clm_client_tbl as cl on (cl.id=b.id_clientb) \
   WHERE (id_tree= :tree)  and coalesce(cl.book,-1)=-1 \
   Order By tt.lvl,tt.line_no; ";


   ZQTree->Sql->Clear();
   ZQTree->Sql->Add(sqlstr);
//   ZQTree->ParamByName("usr")->AsInteger=usr_id;
   ZQTree->ParamByName("tree")->AsInteger=tree_id;
   try
   {
    ZQTree->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }
   ZQTree->First();

   TreeNodesMap.erase(TreeNodesMap.begin(),TreeNodesMap.end());

   for(int i=1;i<=ZQTree->RecordCount;i++)
    {

     if (ZQTree->FieldByName("code_eqp_p")->IsNull)
      {
       BuildTreeRoot(ZQTree->FieldByName("code_eqp")->AsInteger,
                     RootNode1,
                     ZQTree->FieldByName("id_icon")->AsInteger,
                     ZQTree->FieldByName("type_eqp")->AsInteger,
                     ZQTree->FieldByName("line_no")->AsInteger,
                     ZQTree->FieldByName("name")->AsString,tree_id);
      }
     else
      {
       BuildTreeNode(ZQTree->FieldByName("code_eqp")->AsInteger,
                     ZQTree->FieldByName("code_eqp_p")->AsInteger,
                     ZQTree->FieldByName("id_icon")->AsInteger,
                     ZQTree->FieldByName("type_eqp")->AsInteger,
                     ZQTree->FieldByName("line_no")->AsInteger,
                     ZQTree->FieldByName("name")->AsString,tree_id);
      }
     ZQTree->Next();
    }
    ZQTree->Close();
    TreeNodesMap.erase(TreeNodesMap.begin(),TreeNodesMap.end());
   //
   //tTreeEdit->Items->EndUpdate();
   tTreeEdit->FullExpand();

  //}
  //else
//  {
//    ShowMessage("������ ���������� ��������� ������. ���� ����� �������.");
//    ZQTree->Transaction->Rollback();                 //<<<<
  //  Close();
//  }

}

void __fastcall TfTreeForm::ToolButton1Click(TObject *Sender)
{
//���������� ���������
 // ZQTree->Transaction->Rollback();
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::ToolButton2Click(TObject *Sender)
{
//���������� ���������
 //ZQTree->Transaction->Commit();
}
//---------------------------------------------------------------------------


void __fastcall TfTreeForm::FormCreate(TObject *Sender)
{

// EqpEdit = new TfEqpEdit(Application);
 Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
// EqpEdit->usr_id=usr_id;
 EqpEdit->abonent_id=abonent_id;
 EqpEdit->is_res=(abonent_id==ResId);
 EqpEdit->HostDockSite=PEquipment;
 EqpEdit->ParentTreeForm=this;
 EqpEdit->Visible=false;
 tbCancel->Enabled=false;
 tbApply->Enabled=false;

 ////EqpEdit->Parent=PEquipment;

  sqlstr="select id,name from clm_client_tbl where id = (select value_ident::::int from syi_sysvars_tbl where ident='id_res');";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  try
   {
    ZQTree->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }
   if (ZQTree->RecordCount>0)
   {
    ZQTree->First();
    ResId=ZQTree->FieldByName("id")->AsInteger;
    ResName=ZQTree->FieldByName("name")->AsString;
   }
  ZQTree->Close();

  sqlstr="select GetSysVar('tree_border_req') as border_req, GetSysVar('eqpnamecopy') as eqpnamecopy;";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  try
   {
    ZQTree->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }

   BorderRequired=false;

   if (ZQTree->RecordCount>0)
   {
    ZQTree->First();
    if (ZQTree->FieldByName("border_req")->AsInteger!=0)
       BorderRequired=true;
    if (ZQTree->FieldByName("eqpnamecopy")->AsInteger!=0)
       eqpnamecopy=true;

   }
  ZQTree->Close();
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditChanging(TObject *Sender,
      TTreeNode *Node, bool &AllowChange)
{
  if ((treemode==1)||(treemode==4)||(treemode==41)||(treemode==6)||(treemode==61)||(treemode==7)||(treemode==8)) //����� ������� - �� ������ ����� � ����� �������
  {
    AllowChange=false;
    return;
  }

  CurrNode=Node;
  EqpType=0;

//   StatusBar1->Panels->Items[0]->Text=IntToStr((PTreeNodeData(Node->Data))->id_tree);

  tbNew->Enabled=neweqp_enable;
  tbNewTree->Enabled=newtree_enable;
  miNew->Visible=true;
  tbNewPoint->Enabled=point_enable;
  tbConnect->Enabled=point_enable;
  miChange->Visible=true;
  tbChange->Enabled=change_enable;
  miAddDoc->Visible=false;
  miOpenDoc->Visible=false;
  miRename->Visible=true;
  miCivilian->Visible=false;

  if ((Node->StateIndex<=0)||(Node->ImageIndex==0))
    {
     if (EqpEdit->Visible) EqpEdit->Hide();

     if (Node->ImageIndex==0)
      CurrTreeId=Node->StateIndex;

     miDel->Visible=false;
     miUp->Visible=false;
     miDown->Visible=false;
     miChange->Visible=false;
     tbChange->Enabled=false;
     miAddDoc->Visible=true;
     miOpenDoc->Visible=true;


     //������ ������� - �������
     if ((Node->Count>0)&&((PTreeNodeData(Node->Item[0]->Data))->type_eqp==9))
      {
       miAddTranzit->Visible=false;
       miDelTranzit->Visible=true;
      }
     else
      {
       miAddTranzit->Visible=true;
       miDelTranzit->Visible=false;
      }
     miDelTree->Visible=true;

     tbDelete->Enabled=false;
     tbChange->Enabled=false;
     tbDelTree->Enabled=deltree_enable;
     tbNewPoint->Enabled=false;
     tbConnect->Enabled=false;
     tbFullView->Enabled=false;

     tbCopyTree->Enabled=false;
     if(Copy_node!=0) tbPasteTree->Enabled=true;
     if(Move_node!=0)
     {
       tbMove->Enabled=true;
       tbMoveAbons->Enabled=movefiz_enable;
     }

    }
  else
   {
   tbCopyTree->Enabled=copy_enable;
   miCivilian->Visible=true;
   if(Copy_node!=0) tbPasteTree->Enabled=true;
    else tbPasteTree->Enabled=false;
   if(Move_node!=0) { tbMove->Enabled=true; tbMoveAbons->Enabled=movefiz_enable; }
    else { tbMove->Enabled=false; tbMoveAbons->Enabled=false; }


    EqpEdit->CangeLogEnabled=CangeLogEnabled;
    if (!EqpEdit->Visible) EqpEdit->Show();
    //EqpEdit->ShowData(Node->StateIndex);

    if (EqpEdit->ShowData(Node->StateIndex,fReadOnly))  //<<
     {
      miAddTranzit->Visible=false;
      miDelTranzit->Visible=false;
      miDelTree->Visible=false;

      miDel->Visible=true;
      miUp->Visible=false;
      miDown->Visible=false;
      tbDelete->Enabled=deleqp_enable;
      tbChange->Enabled=change_enable;
      tbDelTree->Enabled=false;
      tbFullView->Enabled=true;
//      EqpType=EqpEdit->EqpType;

      if(Node->Data!=NULL)
         EqpType=(PTreeNodeData(Node->Data))->type_eqp;
      //�������
      if (EqpType==1)
      {
       tbNew->Enabled=false;
       miNew->Visible=false;
       miCivilian->Visible=false;
       tbNewPoint->Enabled=false;
       tbConnect->Enabled=false;
       tbPasteTree->Enabled=false;
       tbMove->Enabled=false;
       tbMoveAbons->Enabled=false; 
      }
      //�������
      if (EqpType==9)
      {
       miChange->Visible=false;
       miCivilian->Visible=false;
       tbChange->Enabled=false;
       tbCopyTree->Enabled=false;
       tbPasteTree->Enabled=false;
       tbMove->Enabled=false;
       tbMoveAbons->Enabled=false;

       if ( ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientBId == abonent_id)
//       if(CurrNode->Parent->ImageIndex==0)
          {
          miUp->Visible=true;
          miDel->Visible=false;
          tbDelete->Enabled=false;

          tbPasteTree->Enabled=true;
          tbMove->Enabled=true;

          }
       if ( ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientAId == abonent_id)
         {
          miDown->Visible=true;
          tbNew->Enabled=false;
          miNew->Visible=false;
          miDel->Visible=false;
          tbDelete->Enabled=false;

          tbPasteTree->Enabled=false;
          tbMove->Enabled=false;

         }
      }
      if(EqpType==13)
      {
        tbNewPoint->Enabled=false;
        tbConnect->Enabled=false;
        miChange->Visible=false;
        tbChange->Enabled=false;

        if ((PTreeNodeData(Node->Data))->line_no!=0)
         {
          tbNew->Enabled=false;
          miNew->Visible=false;
          tbCopyTree->Enabled=false;
          tbPasteTree->Enabled=false;
          tbMove->Enabled=false;
          tbMoveAbons->Enabled=false; 
         }
      }
     }
    }
    // ������� ��� �������� ������
    /*
    TTreeNode *Node1;
    Node1=CurrNode;
    while(Node1->ImageIndex!=0){
          Node1=Node1->Parent; }

    CurrTreeId=Node1->StateIndex; //tree_id;
   */
   if (Node->Data!=NULL)  CurrTreeId=(PTreeNodeData(Node->Data))->id_tree;

//  if ((treemode==3)||(treemode==4)||(treemode==31)) //����� ��������
 if (treemode!=0)
  {
/*     miDel->Visible=false;
     miNew->Visible=false;
     miAddTranzit->Visible=false;
     miDelTranzit->Visible=false;
     miDelTree->Visible=false;
     miChange->Enabled=false;

     tbDelete->Enabled=false;
     tbChange->Enabled=false;
     tbDelTree->Enabled=false;
     tbNew->Enabled=false;
     tbNewTree->Enabled=false;
     tbNewPoint->Enabled=false;
     tbConnect->Enabled=false;
     */
   LockControls();

  }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::FormShow(TObject *Sender)
{
//EqpEdit->Show();
//BuildTree (1);
// miChange->Visible=false;
 miDel->Visible=false;
 miAddTranzit->Visible=false;
 miDelTranzit->Visible=false;
 miDelTree->Visible=false;
 miDel->Visible=false;
 miUp->Visible=false;
 miDown->Visible=false;

 tbDelete->Enabled=false;
 tbChange->Enabled=false;
 tbDelTree->Enabled=false;
 tbNew->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbNewClick(TObject *Sender)
{
//
 if (fReadOnly) return;

 StatusBar1->Panels->Items[0]->Text="�������";

 if ((CurrNode->ImageIndex==0)&&(CurrNode->Count>0)) //������� ������ �����
 {
  Node1=CurrNode->getFirstChild();


  if ((PTreeNodeData(Node1->Data))->type_eqp==9)
  {
   // ������ ������� - �������, ����� ������������ ���� ������� ����� ���

   NewNode=tTreeEdit->Items->AddChildFirst(Node1,"�����");

/*
   for(int i =0; i<Node1->Count;i++)
   {
    Node1->Item[i]->MoveTo(NewNode, naAddChild);
   }
*/
//   NewNode->MoveTo(Node1, naAddChildFirst);

  }
  else
  {
   NewNode=tTreeEdit->Items->AddChildFirst(CurrNode,"�����");
   Node1->MoveTo(NewNode, naAddChildFirst);
  }
 }
 else
 {
  NewNode=tTreeEdit->Items->AddChild(CurrNode,"�����");
 }

 NewNode->StateIndex=-1;
 NewNode->ImageIndex=1;
 NewNode->SelectedIndex=1;
 NewNode->Selected=true;

 PTreeNodeData NodeData= new TTreeNodeData;
 NodeData->line_no=0;
 NodeData->id_tree=CurrTreeId;
 NewNode->Data=NodeData;
 NodeDataList->Add(NodeData);

////////////------------------- tTreeEdit->FullExpand();
/* tbNew->Enabled=false;
 tbDelete->Enabled=false;
 tbDelTree->Enabled=false;
 tbNewTree->Enabled=false;
 tbCancel->Enabled=true;
 tbApply->Enabled=true;*/
 LockControls();
 miRename->Visible=true;
 EqpEdit->CreateNewEquipment(0);
 treemode=1;  //�������
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbApplyClick(TObject *Sender)
{
   if (fReadOnly) return;

   ZQTree->Transaction->NewStyleTransactions=false;
   ZQTree->Transaction->TransactSafe=true;
   ZQTree->Transaction->AutoCommit=false;
   ZQTree->Transaction->Commit();
   ZQTree->Transaction->StartTransaction();


   operation=0; //��� �������� ������
   PTreeNodeData NodeData;

   ZQTree->Close();
   ZQTree->Sql->Clear();

   switch (treemode){

        case 1:  //�������

          //  �������� �� ���������� ������ �����
          if (!(EqpEdit->CheckData())) return;

          NewNode->Text=EqpEdit->edName_eqp->Text;

          TTreeNode *Node1;
          Node1=NewNode;
          while(Node1->ImageIndex!=0){
            Node1=Node1->Parent;
          }

          if (NewNode->Parent->ImageIndex==0)
           {
            // ������ ���������� ��������� ������ (����� ������)

            operation=MainForm->PrepareChange(ZQTree,2,CurrTreeId,0,usr_id,CangeLogEnabled,StrToDate(EqpEdit->edDt_install->Text));
            if (operation ==-1)
            {
              tbCancelClick(Sender);
              return;
            };
           }

          WorkNodeId= EqpEdit->SaveNewEquipment();
          if (WorkNodeId==0)
          {
            //ShowMessage("������ SQL :"+sqlstr);
            //ZQTree->Close();
            tbCancelClick(Sender);
            return;
          }


          sqlstr="insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)\
          values ( :id_tree, :code_eqp, :code_eqp_e, :name, :parents);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_tree")->AsInteger=Node1->StateIndex; //tree_id;

          ZQTree->ParamByName("code_eqp")->AsInteger=WorkNodeId;
          if (NewNode->Parent->ImageIndex!=0)
           {
              ZQTree->ParamByName("code_eqp_e")->AsInteger=NewNode->Parent->StateIndex;
              ZQTree->ParamByName("parents")->AsInteger=1;
           }
          else
           {
              ZQTree->ParamByName("code_eqp_e")->Clear();
              ZQTree->ParamByName("parents")->AsInteger=0;
           }
          ZQTree->ParamByName("name")->AsString=NewNode->Text;

          try
          {
           //ZQTree->Open();
           ZQTree->ExecSql();
          }
          catch(EDatabaseError &e)
          {
            ShowMessage("������ : "+e.Message.SubString(8,200));
            ZQTree->Transaction->Rollback();                 //<<<<
            //ZQTree->Close();
            tbCancelClick(Sender);
            return;
          }

          NewNode->StateIndex=WorkNodeId;
          NewNode->SelectedIndex= NewNode->ImageIndex;

          break;
        case 2:  //�����������

          operation=MainForm->PrepareChange(ZQTree,2,CurrTreeId,WorkNodeId,usr_id,CangeLogEnabled);
          if (operation ==-1)
          {
            tbCancelClick(Sender);
            return;
          };

          sqlstr="update eqm_eqp_tree_tbl set code_eqp_e = :code_eqp_e, id_tree= :id_tree\
          where ( code_eqp= :code_eqp ) and (id_tree= :id_tree_old) and (line_no= :line);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);
          if (NewParentId!=0)
              ZQTree->ParamByName("code_eqp_e")->AsInteger=NewParentId;
          else
              ZQTree->ParamByName("code_eqp_e")->Clear();
          ZQTree->ParamByName("code_eqp")->AsInteger=WorkNodeId;

          ZQTree->ParamByName("id_tree")->AsInteger=NewTreeId;
          ZQTree->ParamByName("line")->AsInteger=WorkNodeLine;
          ZQTree->ParamByName("id_tree_old")->AsInteger=OldTreeId;

          try
          {
           //ZQTree->Open();
           ZQTree->ExecSql();
          }
          catch(EDatabaseError &e)
          {
            ShowMessage("������ : "+e.Message.SubString(8,200));
            ZQTree->Transaction->Rollback();                 //<<<<
            //ZQTree->Close();
            tbCancelClick(Sender);

            return;
          };
          break;

        case 3:  //��������

          operation=MainForm->PrepareChange(ZQTree,2,0,WorkNodeId,usr_id,CangeLogEnabled);
          if (operation ==-1)
          {
            tbCancelClick(Sender);
            return;
          };

          if(!EqpEdit->DelEquipment(WorkNodeId))
            {
             ZQTree->Transaction->Rollback();                 //<<<<
             tbCancelClick(Sender);
             return;
            }
        break;
        case 31:  //�������� �����

          operation=MainForm->PrepareChange(ZQTree,2,PointTreeId,WorkNodeId,usr_id,CangeLogEnabled);
          if (operation ==-1)
          {
            tbCancelClick(Sender);
            return;
          };

          sqlstr="delete from eqm_eqp_tree_tbl where id_tree= :id_tree and code_eqp= :code_eqp and line_no= :line;\
          update eqm_eqp_tree_tbl set parents = parents-1 where code_eqp= :code_eqp;";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_tree")->AsInteger=PointTreeId;
          ZQTree->ParamByName("code_eqp")->AsInteger=WorkNodeId;
//          ZQTree->ParamByName("code_eqp_e")->AsInteger=PointParentId;
          ZQTree->ParamByName("line")->AsInteger=WorkNodeLine;
          try
          {
           //ZQTree->Open();
           ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            //ZQTree->Close();
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }
        break;
        case 4:  //������� ������ ������

          sqlstr="select eqi_newtree_fun( :name, :code_eqp, :id_client);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_client")->AsInteger=abonent_id;
          ZQTree->ParamByName("code_eqp")->Clear();
          ZQTree->ParamByName("name")->AsString=NewTree->Text;

          try
          {
           ZQTree->Open();
           //ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            ZQTree->Close();
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

/*
          //�������� ������� �������
          WorkNodeId= EqpEdit->SaveNewEquipment();

          if (WorkNodeId==0)
          {
            ZQTree->Transaction->Rollback();           //<<<<
            tbCancelClick(Sender);
            return;
          }
          NewNode->StateIndex=WorkNodeId;
          NewNode->SelectedIndex= NewNode->ImageIndex;

          sqlstr="select eqi_newtree_border_fun( :name, :code_eqp, :name_eqp, :id_client, :name_client);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_client")->AsInteger=abonent_id;
          ZQTree->ParamByName("name_client")->AsString=abonent_name;
          ZQTree->ParamByName("name_eqp")->AsString=NewNode->Text;
          ZQTree->ParamByName("code_eqp")->AsInteger=WorkNodeId;
          ZQTree->ParamByName("name")->AsString=NewTree->Text;
//          ZQTree->ParamByName("name1")->AsString=abonent_name;

          try
          {
           ZQTree->Open();
          // ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            ZQTree->Close();
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }
       */

          NewTree->StateIndex= ZQTree->Fields->Fields[0]->AsInteger;
          NewTree->SelectedIndex=NewTree->ImageIndex;
          CurrTreeId=ZQTree->Fields->Fields[0]->AsInteger;

          NodeData= new TTreeNodeData;
          NodeData->type_eqp=0;
          NodeData->line_no=0;
          NodeData->id_tree=CurrTreeId;
          NewTree->Data=NodeData;
          NodeDataList->Add(NodeData);

          TreeData= new TTreeListData;
          TreeData->TreeName=NewTree->Text;
          TreeData->id_tree=ZQTree->Fields->Fields[0]->AsInteger;
          TreeList->Add(TreeData);
          cbTreeSelect->Items->Add(NewTree->Text);

//          TreeList->Add(NewTree->Text+"="+ZQTree->Fields->Fields[0]->AsString);

          ZQTree->Close();

          break;
        case 41:  //������� ������ ������ -�����������

          //������� ������
          sqlstr="select eqi_newtree_fun( :name, :code_eqp, :id_client);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_client")->AsInteger=abonent_id;
          ZQTree->ParamByName("code_eqp")->Clear();
          ZQTree->ParamByName("name")->AsString=NewTree->Text;

          try
          {
           ZQTree->Open();
           //ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            ZQTree->Close();
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

          NewTree->StateIndex= ZQTree->Fields->Fields[0]->AsInteger;
          NewTree->SelectedIndex=NewTree->ImageIndex;
          CurrTreeId=ZQTree->Fields->Fields[0]->AsInteger;

          TreeData= new TTreeListData;
          TreeData->TreeName=NewTree->Text;
          TreeData->id_tree=ZQTree->Fields->Fields[0]->AsInteger;
          TreeList->Add(TreeData);
          cbTreeSelect->Items->Add(NewTree->Text);

          NodeData= new TTreeNodeData;
          NodeData->type_eqp=0;
          NodeData->line_no=0;
          NodeData->id_tree=CurrTreeId;
          NewTree->Data=NodeData;
          NodeDataList->Add(NodeData);

//          TreeList->Add(NewTree->Text+"="+ZQTree->Fields->Fields[0]->AsString);

         case 6:  //����������� ������������� ������ ��� �����������
          //
          //  �������� �� ���������� ������ �����
          if (!(EqpEdit->CheckData()))
          {
           ZQTree->Transaction->Rollback();                 //<<<<
           return;
          };

          if( treemode==6)
          {
           //���������� ��������� � ��������� (����� ������)
           operation=MainForm->PrepareChange(ZQTree,2,NewTree->StateIndex,0,usr_id,CangeLogEnabled,StrToDate(EqpEdit->edDt_install->Text));
          }
          else
           // ������ �����  - ��������� �� �����
           operation=MainForm->PrepareChange(ZQTree,2,NewTree->StateIndex,0,usr_id,false,Now());

          if (operation ==-1)
          {
            tbCancelClick(Sender);
            return;
          };


          ZQTree->Close();

          //������� ������
          //����� ������������
          WorkNodeId= EqpEdit->SaveNewEquipment();

          if (WorkNodeId==0)
          {
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

          NewNode->Text=EqpEdit->edName_eqp->Text;

          // �������� � ������
          // ���...
          sqlstr="insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)\
          values ( :id_tree, :code_eqp, :code_eqp_e, :name, 0);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);
          // � ������������...
          sqlstr="insert  into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)\
          values ( :id_tree2, :code_eqp, :code_eqp_e2, :name,1);";
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_tree")->AsInteger=NewTree->StateIndex; //tree_id;
          ZQTree->ParamByName("id_tree2")->AsInteger=ParentTree; //tree_id;

          ZQTree->ParamByName("code_eqp")->AsInteger=WorkNodeId;
          ZQTree->ParamByName("code_eqp_e")->Clear();
          ZQTree->ParamByName("code_eqp_e2")->AsInteger=BorderParent;
          ZQTree->ParamByName("name")->AsString=NewNode->Text;
          ParentTree=0;
          BorderParent=0;

          try
          {
           ZQTree->ExecSql();
          }
          catch(EDatabaseError &e)
          {
            ShowMessage("������ : "+e.Message.SubString(8,200));
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

          NewNode->StateIndex=WorkNodeId;
          NewNode->SelectedIndex= NewNode->ImageIndex;
          (PTreeNodeData(NewNode->Data))->id_tree=CurrTreeId;

        break;
        // ������ �� ������ ������ !!!!!!!!!!!!!!!!!
         case 61:  //��������������� ������������� ������

          //  �������� �� ���������� ������ �����
          if (!(EqpEdit->CheckData()))
          {
           return;
          };

          //���������� ��������� � ��������� (����� ������)
          operation=MainForm->PrepareChange(ZQTree,2,0,CurrNode->StateIndex,usr_id,CangeLogEnabled,StrToDate(EqpEdit->edDt_install->Text));

          if (operation ==-1)
           {
             tbCancelClick(Sender);
             return;
           };

          ZQTree->Close();
          //������� ������ �������

          if(!EqpEdit->DelEquipment(CurrNode->StateIndex))
            {
             ZQTree->Transaction->Rollback();                 //<<<<
             tbCancelClick(Sender);
             return;
            }

          //�����
          WorkNodeId= EqpEdit->SaveNewEquipment();

          if (WorkNodeId==0)
          {
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

          // �������� � ������
          // ���...
          sqlstr="insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)\
          values ( :id_tree, :code_eqp, :code_eqp_e, :name, 0);";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);
          // � ������������...
          sqlstr="insert  into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)\
          values ( :id_tree2, :code_eqp, :code_eqp_e2, :name,1);";
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_tree")->AsInteger=CurrTreeId; //tree_id;
          ZQTree->ParamByName("id_tree2")->AsInteger=ParentTree; //tree_id;

          ZQTree->ParamByName("code_eqp")->AsInteger=WorkNodeId;
          ZQTree->ParamByName("code_eqp_e")->Clear();
          ZQTree->ParamByName("code_eqp_e2")->AsInteger=BorderParent;
          ZQTree->ParamByName("name")->AsString=CurrNode->Text;
          ParentTree=0;
          BorderParent=0;

          try
          {
           ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

          CurrNode->StateIndex=WorkNodeId;
      //    NewNode->SelectedIndex= NewNode->ImageIndex;

        break;
        case 5:  //�������� ������

          operation=MainForm->PrepareChange(ZQTree,3,WorkNodeId,0,usr_id,CangeLogEnabled);
          if (operation ==-1)
          {
            tbCancelClick(Sender);
            return;
          };

          sqlstr="delete from eqm_tree_tbl where id = :tree_id;";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("tree_id")->AsInteger=WorkNodeId;

          try
          {
           ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          };
          // ������� �� ������ ��������
          for(int i=0;i<=TreeList->Count-1;i++)
          {
           if (WorkNodeId==(PTreeListData(TreeList->Items[i]))->id_tree)
            {
             TreeList->Delete(i);
             cbTreeSelect->Items->Delete(i+1);
             break;
            }
          }

          break;
       case 8: //������ ������������
               // ������� � ������� ��� ������ �� EqpEdit->ChangeEquipment

          //  �������� �� ���������� ������ �����
          if (!(EqpEdit->CheckData())) return;

          if (!(EqpEdit->ChangeEquipment()))
          {
            ShowMessage("������ ������ ������������");
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }
          CurrNode->SelectedIndex=CurrNode->ImageIndex;
//          ZQTree->Transaction->Commit();                 //<<<<

        break;
        case 7:  //����������� � ����� ���������

           // ����� ���������� �������� ����� (���������)
           operation=MainForm->PrepareChange(ZQTree,1,0,NewNode->StateIndex,usr_id,CangeLogEnabled);
           if (operation ==-1)
           {
             tbCancelClick(Sender);
             return;
           };

          // �������� ������������ ����� ����� ��� ������ �����
          sqlstr="select max(line_no) AS max_no from eqm_eqp_tree_tbl where code_eqp= :code_eqp;";
          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);
          ZQTree->ParamByName("code_eqp")->AsInteger=NewNode->StateIndex;
          try
          {
           ZQTree->Open();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            tbCancelClick(Sender);
            return;
          }
          int max_no=ZQTree->Fields->Fields[0]->AsInteger;
          ZQTree->Close();


          sqlstr="insert  into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents,line_no)\
          values ( :id_tree, :code_eqp, :code_eqp_e, :name, :parents, :line_no);\
          update eqm_eqp_tree_tbl set parents= :parents where code_eqp= :code_eqp;";

          ZQTree->Sql->Clear();
          ZQTree->Sql->Add(sqlstr);

          ZQTree->ParamByName("id_tree")->AsInteger=CurrTreeId; //tree_id;

          ZQTree->ParamByName("code_eqp")->AsInteger=NewNode->StateIndex;

          ZQTree->ParamByName("code_eqp_e")->AsInteger=NewNode->Parent->StateIndex;

          ZQTree->ParamByName("line_no")->AsInteger=max_no+1;
          ZQTree->ParamByName("parents")->AsInteger=CurParents+1;      //**************
          ZQTree->ParamByName("name")->AsString=NewNode->Text;

          try
          {
           ZQTree->ExecSql();
          }
           catch(...)
          {
            ShowMessage("������ SQL :"+sqlstr);
            ZQTree->Transaction->Rollback();                 //<<<<
            tbCancelClick(Sender);
            return;
          }

//          NewNode->StateIndex=WorkNodeId;
          NewNode->SelectedIndex= NewNode->ImageIndex;
          break;
   };
   if (operation!=0)
   MainForm->AfterChange(ZQTree,operation,CangeLogEnabled);

   ZQTree->Transaction->Commit();           //!!!!!!!!!!!!!!
   ZQTree->Transaction->AutoCommit=true;
   ZQTree->Transaction->TransactSafe=false;


  SelectTrees();   //�������� ��������� �������


  treemode=0;  //��������
//  tbNew->Enabled=true;
//  tbDelete->Enabled=true;

  tbCancel->Enabled=false;
  tbApply->Enabled=false;
  cbTreeSelect->Enabled=true;
//  Node1=tTreeEdit->Selected;
//  tTreeEdit->Selected=Node1;
  bool AllowChange;

  if (tTreeEdit->Selected!=NULL)
    tTreeEditChanging(Sender,tTreeEdit->Selected,AllowChange);
  StatusBar1->Panels->Items[0]->Text="";

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbCancelClick(TObject *Sender)
{
 if (fReadOnly) return;

 if (operation!=0) //������� �������� ������ (����������)
 {                 // ���� �������� ��������� �������
  MainForm->AfterChange(ZQTree,operation,CangeLogEnabled);
//  ZQTree->Transaction->Commit();
 }

 tTreeEdit->Items->BeginUpdate();
 tTreeEdit->Items->GetFirstNode()->Selected=true;

/// if ((treemode==1)||(treemode==7))
/// {
///  if (NewNode->HasChildren)
///  {
///     Node1=NewNode->getFirstChild();
///     Node1->MoveTo(NewNode->Parent, naAddChildFirst);
///  }
///  NewNode->Delete();
/// }
/// else
/// {

   if (treemode==1) WorkNodeId=NewNode->Parent->StateIndex;  //��� ����, ����� ����� ����������� ������ ������� �����

   tTreeEdit->Items->Clear();
/*   for(int i=0;i<=TreeList->Count-1;i++)
   {
     BuildTree((PTreeListData(TreeList->Items[i]))->id_tree,(PTreeListData(TreeList->Items[i]))->TreeName,false);
   }
*/
//   tTreeEdit->Items->BeginUpdate();
   FullTreeNodesMap.erase(FullTreeNodesMap.begin(),FullTreeNodesMap.end());
   if(cbTreeSelect->ItemIndex==0)
   {
    for(int i=0;i<=TreeList->Count-1;i++)
    {
      BuildTree((PTreeListData(TreeList->Items[i]))->id_tree,(PTreeListData(TreeList->Items[i]))->TreeName,false);
    }
   }
   if(cbTreeSelect->ItemIndex>0)
   {
      BuildTree((PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->id_tree,(PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->TreeName,false);
   }
   tTreeEdit->Items->EndUpdate();

/// }

 /////////////-------------- tTreeEdit->FullExpand();
 /// tTreeEdit->Items->EndUpdate();
   TTreeNode *NNNN;
   int oldmode=treemode;
   treemode=0;  //��������
   switch (oldmode){

        case 1:
        case 2:
        case 3:
        case 31:
          NNNN=NULL;
          NNNN=FullTreeNodesMap[WorkNodeId];
//          FullTreeNodesMap[WorkNodeId]->Selected=true;
          if (NNNN!=NULL) NNNN->Selected=true;
          break;
        default :
          {
           if (tTreeEdit->Items->Count!=0)
            tTreeEdit->Items->GetFirstNode()->Selected=true;
           else
            EqpEdit->Hide();
          };
   };

//  tbNew->Enabled=true;
//  tbDelete->Enabled=true;
  tbCancel->Enabled=false;
  tbApply->Enabled=false;
  cbTreeSelect->Enabled=true;
//  Node1=tTreeEdit->Selected;
//  tTreeEdit->Selected=Node1;
  StatusBar1->Panels->Items[0]->Text="";
  EqpEdit->IsModified=false;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbDeleteClick(TObject *Sender)
{
 if (fReadOnly) return;
 //��� ������
 if (CurrNode->ImageIndex==0) return;
 // ������� ������ - ���� ��������, ������� � ���� ��������
 if ((CurrNode->Parent->ImageIndex==0)&&(CurrNode->Count>1))
    {
     ShowMessage("������ ������� ������ ���� ����� - � ���� ���������� >1 ����");
     return;
    }

 if(MessageDlg("������� ������������ "+CurrNode->Text, mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    return;

  // �������� ������� ������������ ������
  sqlstr="select count(*) as cnt from clm_pclient_tbl where id_eqpborder = :code_eqp;";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);

  ZQTree->ParamByName("code_eqp")->AsInteger=CurrNode->StateIndex;

  try
  {
     ZQTree->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQTree->Close();
    return;
  };

  if (ZQTree->FieldByName("cnt")->AsInteger > 0 )
  {
   if(MessageDlg("� ���������� ������������ ���������� ���������. \n����� �������� ������������ ��� ����� ��������� �� �����. \n����������? ", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;

  }
  ZQTree->Close();
 //---------------------------------------------------------------------------
 // ���� ��� ����� �����������
 if (PTreeNodeData(CurrNode->Data)->type_eqp==13)
 {
  //  ���� ������� ��������
  if (PTreeNodeData(CurrNode->Data)->line_no==0)
  {
   //������� ��� �����
   treemode=3;  //�������� �����
   for (int k=0;k<tTreeEdit->Items->Count;k++)
   { // ����� �� ����� ��������
    if((tTreeEdit->Items->Item[k]->StateIndex==CurrNode->StateIndex)&&
      (tTreeEdit->Items->Item[k]!=CurrNode)){
       tTreeEdit->Items->Item[k]->Delete();
      }
   }
  }
  else //�����, �� ���� ������� �� ������� ������������
  {     //�������� �� ����� �� �����������
     treemode=31;  //�������� �����
     //PointParentId=CurrNode->Parent->StateIndex;
//     WorkNodeLine=PTreeNodeData(CurrNode->Data)->line_no;
     PointTreeId=CurrTreeId;
  }
 }
 else  treemode=3;  //�������� �����

  if (CurrNode->HasChildren)
   {
     int Count=CurrNode->Count;
     for(int i=0;i<Count;i++)
     {
      Node1=CurrNode->Item[0];
      Node1->MoveTo(CurrNode->Parent, naAddChild);
     }
   }

  WorkNodeId=CurrNode->StateIndex;
  WorkNodeLine=PTreeNodeData(CurrNode->Data)->line_no;

  TTreeNode *CurParent=CurrNode->Parent;
  CurrNode->Delete();
  CurParent->Selected=true;
 ////////////////---------------- tTreeEdit->FullExpand();
 ////////////////---------------- tTreeEdit->Items->GetFirstNode()->Selected=true;

/*  tbNew->Enabled=false;
  tbDelete->Enabled=false;
  tbDelTree->Enabled=false;
  tbNewTree->Enabled=false;

  tbCancel->Enabled=true;
  tbApply->Enabled=true;
*/
  LockControls();
//  treemode=3;  //�������� �����
  StatusBar1->Panels->Items[0]->Text="��������";

 }
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditDragOver(TObject *Sender,
      TObject *Source, int X, int Y, TDragState State, bool &Accept)
{
 if (edtree_enable)
 {

    Node1=tTreeEdit->GetNodeAt(X,Y);
    if (Node1==NULL) Accept =false;
    else
    {
    if ((DragNode->ImageIndex==0)||(treemode>0)||
    (Node1->HasAsParent(DragNode))||(Node1->StateIndex==0)||((EqpType==9)&&(DragNode->Parent->ImageIndex==0))||
    (EqpType==0)||((PTreeNodeData(Node1->Data))->line_no!=0)||((PTreeNodeData(Node1->Data))->type_eqp==1)||
    (((PTreeNodeData(Node1->Data))->type_eqp==9)&&(Node1->Parent->ImageIndex!=0)) ||
    ((Node1->ImageIndex==0)&&(Node1->Count>0)) )
    Accept =false;
    //  ����� ����� �� �� ������������ ������ ;)
    // �� ���. ��. ����������� ������ �������� � ���. ��.
    if (((PTreeNodeData(Node1->Data))->type_eqp==10)&&((PTreeNodeData(DragNode->Data))->type_eqp!=10)
       &&((PTreeNodeData(DragNode->Data))->type_eqp!=1) )
    Accept =false;
    }
 }
 else Accept=false;
// ���������
 NONCLIENTMETRICS * SystemParameters;
 SystemParameters =new(NONCLIENTMETRICS);
 SystemParameters->cbSize=sizeof(NONCLIENTMETRICS);

 SystemParametersInfo(
    SPI_GETNONCLIENTMETRICS,  //UINT uiAction,	// system parameter to query or set
    sizeof(NONCLIENTMETRICS), //UINT uiParam,	// depends on action to be taken
    SystemParameters,         //PVOID pvParam,	// depends on action to be taken
    0                         //UINT fWinIni 	// user profile update flag
   );

 if ((Y > 0) && (Y < 30))
  SendMessage(tTreeEdit->Handle, WM_VSCROLL, SB_LINEUP, 0);
 if ((Y > tTreeEdit->Height - SystemParameters->iScrollHeight - 30) &&
  (Y < tTreeEdit->Height - SystemParameters->iScrollHeight))
  SendMessage(tTreeEdit->Handle, WM_VSCROLL, SB_LINEDOWN, 0);

 if ((X > 0) && (X < 30))
  SendMessage(tTreeEdit->Handle, WM_HSCROLL, SB_LINELEFT, 0);
 if ((X > tTreeEdit->Width - SystemParameters->iScrollWidth - 30) &&
  (X < tTreeEdit->Width - SystemParameters->iScrollWidth))
  SendMessage(tTreeEdit->Handle, WM_HSCROLL, SB_LINERIGHT, 0);

 delete SystemParameters;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditStartDrag(TObject *Sender,
      TDragObject *&DragObject)
{
 DragNode=CurrNode;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditDragDrop(TObject *Sender,
      TObject *Source, int X, int Y)
{
   if (!edtree_enable) return;
   Node1=tTreeEdit->GetNodeAt(X,Y);
   if ((Node1!=NULL)&&(Node1!=DragNode)&&(Node1!=DragNode->Parent))
   {
    DragNode->MoveTo(Node1, naAddChild);
/*    if (Node1->StateIndex=0)
    {
      Node1->getFirstChild()->MoveTo(Node1, naAddChild);
    }
*/
/////////////////-------------------    tTreeEdit->FullExpand();

    tbNew->Enabled=false;
    tbDelete->Enabled=false;
    tbCancel->Enabled=true;
    tbApply->Enabled=true;
    tbNewTree->Enabled=false;

    treemode=2;  //����������� �����
    StatusBar1->Panels->Items[0]->Text="�����������";
    WorkNodeId = DragNode->StateIndex;
    WorkNodeLine=PTreeNodeData(DragNode->Data)->line_no;
    if (Node1->ImageIndex!=0)
      NewParentId = Node1->StateIndex;
    else
      NewParentId =0;
/*
    TTreeNode *Node2;
    Node2=Node1;
    while(Node2->ImageIndex!=0){
          Node2=Node2->Parent; }

    NewTreeId=Node2->StateIndex; //tree_id;
*/
    NewTreeId=(PTreeNodeData(Node1->Data))->id_tree;
    OldTreeId=(PTreeNodeData(DragNode->Data))->id_tree;
 //   (PTreeNodeData(DragNode->Data))->id_tree=NewTreeId;

    GhangeTreeRec(DragNode,NewTreeId);

   }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbChangeClick(TObject *Sender)
{

  //
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditEdited(TObject *Sender,
      TTreeNode *Node, AnsiString &S)
{
   // ��������� ����� ����
   if ((treemode==1)||(treemode==4)||(treemode==61)||(treemode==41)||(treemode==6)) return;
   // ������� ������ - ��� ������� ������ �� ����
   if (Node->ImageIndex==0)
//    sqlstr="update pg_trigger set tgenabled = false where tgname='eqc_edtree_trg';\
//    update eqm_tree_tbl set name = :name where id= :code;\
//    update pg_trigger set tgenabled = false where tgname='eqc_edtree_trg';";
    sqlstr="update eqm_tree_tbl set name = :name where id= :code;";

   else
    sqlstr="update eqm_eqp_tree_tbl set name = :name where code_eqp= :code and line_no= :line;";

   ZQTree->Close();
   ZQTree->Sql->Clear();
   ZQTree->Sql->Add(sqlstr);
   ZQTree->ParamByName("name")->AsString=S;
   ZQTree->ParamByName("code")->AsInteger=Node->StateIndex;

   if (Node->ImageIndex!=0)
   {
//    if(Node->Parent->ImageIndex!=0)
      ZQTree->ParamByName("line")->AsInteger=PTreeNodeData(Node->Data)->line_no;
   }

   try
    {
      ZQTree->ExecSql();
    }
   catch(...)
    {
      ShowMessage("������ SQL :"+sqlstr);
//      ZQTree->Transaction->Rollback();
      return;
    };

//    ZQTree->Transaction->Commit();
}
//---------------------------------------------------------------------------
void TfTreeForm::ShowTrees(int abonent,bool readonly,int node)
{
  abonent_id=abonent;

  DocFolder=MainForm->StartupIniFile->ReadString("Path","DocFolder","");

  EqpEdit->usr_id=usr_id;
  EqpEdit->abonent_id=abonent_id;
  EqpEdit->is_res=(abonent_id==ResId);
  EqpEdit->LastDate=TDate(0);
 /*
  //----------------����������, �� �������� �� ��� ������ � ���� ���������
//   sqlstr="select code_eqp from eqt_tree where (client= :client) and (id_usr<> :usr_id) limit 1;";
   sqlstr="select code_eqp from eqt_tree where (client= :client) limit 1;";
   ZQTree->Sql->Clear();
   ZQTree->Sql->Add(sqlstr);
   ZQTree->ParamByName("client")->AsInteger=abonent_id;
//   ZQTree->ParamByName("usr_id")->AsInteger=usr_id;
   try
   {
    ZQTree->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }
   if (ZQTree->RecordCount>0)
   {
    ShowMessage("����� ������� �������� ������� ������ �������������. ������ ���������!");
    //fReadOnly=true;
   }
   //else
   */
    fReadOnly=readonly;
  //----------------����� ���� ����������, ����� �� ������ �������� ������

  last_indic_date=TDateTime(0);
  if (abonent_id!=ResId)
  {
   sqlstr="select reg_date from acm_headindication_tbl where id_client = :client order by reg_date desc LIMIT 1 OFFSET 0;";
   ZQTree->Sql->Clear();
   ZQTree->Sql->Add(sqlstr);
   ZQTree->ParamByName("client")->AsInteger=abonent_id;

   try
    {
    ZQTree->Open();
    }
   catch(...)
    {
     ShowMessage("������ SQL :"+sqlstr);
     ZQTree->Close();
     return;
    }
    if (ZQTree->RecordCount!=0)
        last_indic_date=ZQTree->FieldByName("reg_date")->AsDateTime;
    else
        last_indic_date=TDateTime(0);
  }

  CangeLogEnabled=true;
  //---------------------------------------------------------------

  sqlstr=" select cl.short_name, code, scl.id_section, scl.dt_indicat from clm_client_tbl as cl \
           join clm_statecl_tbl as scl on (cl.id = scl.id_client) \
           where cl.id = :client";

  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("client")->AsInteger=abonent_id;

  try
   {
   ZQTree->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }

  ZQTree->First();
  Caption="����� "+ZQTree->FieldByName("short_name")->AsString + "(" +ZQTree->FieldByName("code")->AsString +")";
  abonent_name=ZQTree->FieldByName("short_name")->AsString;
  dt_indicat = ZQTree->FieldByName("dt_indicat")->AsInteger;

  if ((ZQTree->FieldByName("id_section")->AsInteger == 205 )||
      (ZQTree->FieldByName("id_section")->AsInteger == 206 )||
      (ZQTree->FieldByName("id_section")->AsInteger == 207 )||
      (ZQTree->FieldByName("id_section")->AsInteger == 208 ))
  {
    BorderRequired = false;
  }

  ZQTree->Close();

  ////
  //   ���� ����� node � ��� ����� ���, ������� �� �����, � ������� ���� �������

  int node_tree=0;

  if ((abonent_id!=ResId)||(node!=0))
   {
   sqlstr=" select tt.id_tree from eqm_eqp_tree_tbl as tt join eqm_tree_tbl as t on (tt.id_tree=t.id) \
   where t.id_client = :client and tt.code_eqp = :eqp limit 1; ";

   ZQTree->Sql->Clear();
   ZQTree->Sql->Add(sqlstr);
   ZQTree->ParamByName("client")->AsInteger=abonent_id;
   ZQTree->ParamByName("eqp")->AsInteger=node;

   try
    {
    ZQTree->Open();
    }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }

   ZQTree->First();

   node_tree=ZQTree->FieldByName("id_tree")->AsInteger;

   ZQTree->Close();
   }
  /////

  sqlstr=" select tr.id,tr.name,tr.code_eqp from eqm_tree_tbl AS tr \
  where tr.id_client = :client order by name";

  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("client")->AsInteger=abonent_id;

   try
   {
   ZQTree->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }

   TreeList->Clear();
   AnsiString OneTree;
   for(int i=1;i<=ZQTree->RecordCount;i++)
   {
//    OneTree=ZQTree->FieldByName("name")->AsString+"="+ZQTree->FieldByName("id")->AsString;
//    TreeList->Add(OneTree);

     TreeData= new TTreeListData;
     TreeData->TreeName=ZQTree->FieldByName("name")->AsString;
     TreeData->id_tree=ZQTree->FieldByName("id")->AsInteger;
     TreeList->Add(TreeData);

//    BuildTree(ZQTree->FieldByName("id")->AsInteger,ZQTree->FieldByName("name")->AsString,true);
    ZQTree->Next();
   }

   ZQTree->Close();

   tTreeEdit->Items->BeginUpdate();
//   tTreeEdit->Items->GetFirstNode()->Selected=true;
   tTreeEdit->Items->Clear();

   cbTreeSelect->Items->Clear();
   cbTreeSelect->Items->Add("���");

   if ((abonent_id!=ResId)||(node!=0))
   {
    cbTreeSelect->ItemIndex=0;
   }
   else
   {
    cbTreeSelect->Font->Color = clBlue;
    cbTreeSelect->Text = "�������� �����!!!";
   };

   int tree_no;

   if (SelectTrees())
   {
    FullTreeNodesMap.erase(FullTreeNodesMap.begin(),FullTreeNodesMap.end());

     for(int i=0;i<=TreeList->Count-1;i++)
     {
      cbTreeSelect->Items->Add((PTreeListData(TreeList->Items[i]))->TreeName);

      if ((abonent_id!=ResId)||(node_tree==(PTreeListData(TreeList->Items[i]))->id_tree))
      {
        BuildTree((PTreeListData(TreeList->Items[i]))->id_tree,(PTreeListData(TreeList->Items[i]))->TreeName,true);
        tree_no = i;
      }
     //  BuildTree(StrToInt(TreeList->Values[TreeList->Names[i]]),TreeList->Names[i],true);
     }
   }

   if (node_tree!=0) cbTreeSelect->ItemIndex=tree_no+1;

   tTreeEdit->Items->EndUpdate();

   if (fReadOnly)
   {
   Caption=Caption+" (������ ��������)";
//   ToolBar1->Enabled=false;
   tTreeEdit->ReadOnly=true;
   miDelTree->Enabled=false;
   miNew->Enabled=false;
   miDel->Enabled=false;
   miChange->Enabled=false;
   miAddTranzit->Enabled=false;
   miDelTranzit->Enabled=false;
//   miDown->Enabled=false;
//   miUp->Enabled=false;
   };

   tbCopyTree->Enabled=false;
   tbPasteTree->Enabled=false;
   Move_node=0;
   tbMove->Enabled=false;
   tbMoveAbons->Enabled=false; 

   if(node!=0)
   {
    FullTreeNodesMap[node]->Selected=true;

   }

}

//---------------------------------------------------------------------------
void __fastcall TfTreeForm::tbDelTreeClick(TObject *Sender)
{

 if (fReadOnly) return;
 if (CurrNode->ImageIndex!=0) return;

 //���� �������� ��������  ��������� ������, � ��� ����� �����
 if(CurrNode->Count>0)
  {
   ShowMessage("������ ������� �������� �����.");
   return;
  }
 // � ������ �������������� ������ �� �����,
 // ����������� �� ������ ���� �������� ������� ������
 // ����� ���������
 /*
  sqlstr="select tranzit from eqm_tree_tbl where id = :id;";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("id")->AsInteger=CurrTreeId;

   try
   {
   ZQTree->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }
  if (ZQTree->Fields->Fields[0]->AsInteger>0)
   {
   ShowMessage("������ ������� �����,� ������� ���������� �����������.");
   return;
   }
  ZQTree->Close();
  */

 if(MessageDlg("������� ����� ����� "+CurrNode->Text, mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
  {

  WorkNodeId=CurrNode->StateIndex;
  CurrNode->Delete();
/////------------------------  tTreeEdit->FullExpand();
  if (tTreeEdit->Items->Count!=0)
    tTreeEdit->Items->GetFirstNode()->Selected=true;
/*
  tbNew->Enabled=false;
  tbDelete->Enabled=false;
  tbCancel->Enabled=true;
  tbApply->Enabled=true;
  tbDelTree->Enabled=false;
  tbNewTree->Enabled=false;
*/
  LockControls();
  treemode=5;  //�������� �����
  StatusBar1->Panels->Items[0]->Text="�������� �����";
  }

//treemode=5;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbNewTreeClick(TObject *Sender)
{
 if (fReadOnly) return;

 Refresh();
 NewTree=tTreeEdit->Items->Add(NULL, "����� ����� "+IntToStr(TreeList->Count+1));
 NewTree->StateIndex=-1;
 NewTree->ImageIndex=0;
 NewTree->SelectedIndex=0;

 bool answer=true;

 if ((!BorderRequired)||(abonent_id==ResId))
 {
  answer=(MessageDlg("���������� ��� �����������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes);
 }

if (answer)
 {

  NewNode=tTreeEdit->Items->AddChild(NewTree,"�������");

  NewNode->StateIndex=-1;
  NewNode->ImageIndex=1;
  NewNode->SelectedIndex=1;
  NewNode->Selected=true;

  PTreeNodeData NodeData= new TTreeNodeData;
  NodeData->type_eqp=9;
  NodeData->line_no=0;
  NewNode->Data=NodeData;
  NodeDataList->Add(NodeData);

  EqpEdit->CreateNewByType(9,"������� �������"); //������� ������

  treemode=41;
  // ������� �������� �������� ������       111111111111111
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

//  WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
   WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;
  ((TWTDoc *)(WAbonGrid->Owner))-> OnCloseQuery=AbonClose;

 }

else
 {
  NewTree->Selected=true;
  treemode=4;
 }


/*  NewTree=tTreeEdit->Items->Add(NULL, "����� �����");
  NewTree->StateIndex=-1;
  NewTree->ImageIndex=0;
  NewTree->SelectedIndex=0;

  NewNode=tTreeEdit->Items->AddChild(NewTree,"�������");

  NewNode->StateIndex=-1;
  NewNode->ImageIndex=1;
  NewNode->SelectedIndex=1;
  NewNode->Selected=true;

  PTreeNodeData NodeData= new TTreeNodeData;
  NodeData->type_eqp=9;
  NodeData->line_no=0;
  NewNode->Data=NodeData;
  NodeDataList->Add(NodeData);

  EqpEdit->CreateNewByType(9,"������� �������"); //������� ������

  if (MessageDlg("���������� ��� �����������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
  {

    treemode=41;
    // ������� �������� �������� ������       111111111111111
    TWTDBGrid* Grid;
    Grid=MainForm->CliClientMSel();
    if(Grid==NULL) return;
    else WAbonGrid=Grid;

   // WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
    WAbonGrid->StringDest = "1";
    WAbonGrid->OnAccept=AbonAccept;
    ((TWTDoc *)(WAbonGrid->Owner))-> OnCloseQuery=AbonClose;

 }

else
 {
//  NewTree->Selected=true;
  treemode=4;

  ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientAId=ResId;
  ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientBId=abonent_id;

  ((TfBorderDet*)(EqpEdit->DetEditForm))->edClientA->Text=ResName;
  ((TfBorderDet*)(EqpEdit->DetEditForm))->edClientB->Text=abonent_name;

 }
  */
/* tbNew->Enabled=false;
 tbDelete->Enabled=false;
 tbCancel->Enabled=true;
 tbApply->Enabled=true;
 tbDelTree->Enabled=false;
 tbNewTree->Enabled=false;
 */

LockControls();
StatusBar1->Panels->Items[0]->Text="�������� ������";
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditDblClick(TObject *Sender)
{
if ((fSelectTree->CurrNode!=NULL)&&(fSelectTree->CurrNode->ImageIndex!=0))
 {
 BorderParent=fSelectTree->CurrNode->StateIndex;

 TTreeNode *Node1;
 Node1=fSelectTree->CurrNode;
 while(Node1->ImageIndex!=0){
    Node1=Node1->Parent;
 }

 ParentTree=Node1->StateIndex;
 fSelectTree->Close();
 }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miUpClick(TObject *Sender)
{
int node= CurrNode->StateIndex;
//if (!fReadOnly)  ClearTemp();
abonent_id= ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientAId;
tTreeEdit->Items->GetFirstNode()->Selected=true;
ShowTrees(abonent_id,fReadOnly,node);
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miDownClick(TObject *Sender)
{
int node= CurrNode->StateIndex;
//if (!fReadOnly)  ClearTemp();
abonent_id= ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientBId;
tTreeEdit->Items->GetFirstNode()->Selected=true;
ShowTrees(abonent_id,fReadOnly,node);
}
//---------------------------------------------------------------------------


void __fastcall TfTreeForm::miAddTranzitClick(TObject *Sender)
{
//  ������� ����������� �� �������� ������
if (MessageDlg("���������� � �����������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrNo)
 return;

 parent_abonent=0;

 NewTree=CurrNode;
 if (CurrNode->Count>0) //������� ������ �����
 {
  Node1=CurrNode->getFirstChild();
  NewNode=tTreeEdit->Items->AddChildFirst(CurrNode,"�������");
  Node1->MoveTo(NewNode, naAddChildFirst);
 }
 else
 {
  NewNode=tTreeEdit->Items->AddChild(CurrNode,"�������");
 }

  NewNode->StateIndex=-1;
  NewNode->ImageIndex=1;
  NewNode->SelectedIndex=1;
  NewNode->Selected=true;

  PTreeNodeData NodeData= new TTreeNodeData;
  NodeData->line_no=0;
  NodeData->type_eqp=9;
  NewNode->Data=NodeData;
  NodeDataList->Add(NodeData);
  tTreeEdit->FullExpand();
  EqpEdit->CreateNewByType(9,"������� �������"); //������� ������

  treemode=6;

  // ������� �������� �������� ������       111111111111111
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

  //WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
  WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;
  ((TWTDoc *)(WAbonGrid->Owner))-> OnCloseQuery=AbonClose;

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miDelTranzitClick(TObject *Sender)
{
//���������� �� ����������� ������
if (MessageDlg("��������� �� �����������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrNo)
 return;

  CurrNode=CurrNode->getFirstChild();
  if (CurrNode->HasChildren)
   {
     int Count=CurrNode->Count;
     for(int i=0;i<Count;i++)
     {
      Node1=CurrNode->Item[0];
      Node1->MoveTo(CurrNode->Parent, naAddChild);
     }
   }

  WorkNodeId=CurrNode->StateIndex;
  CurrNode->Delete();
  tTreeEdit->FullExpand();
  tTreeEdit->Items->GetFirstNode()->Selected=true;

  tbNew->Enabled=false;
  tbDelete->Enabled=false;
  tbCancel->Enabled=true;
  tbApply->Enabled=true;

  treemode=3;  //�������� �����
  StatusBar1->Panels->Items[0]->Text="���������� �� �����������";

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::FormCloseQuery(TObject *Sender, bool &CanClose)
{
// �� ������� ����� ��� ����������� ����������� - �������� ����������
 fSelectTree->ClearTemp();
 if(BorderParent==0)
   tbCancelClick(Sender);
}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::ClearTemp(void)
{
//
}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::tbNewPointClick(TObject *Sender)
{
 if (fReadOnly) return;

 StatusBar1->Panels->Items[0]->Text="������� ����� ���������";

 if ((CurrNode->ImageIndex==0)&&(CurrNode->Count>0)) //������� ������ �����
 {
  Node1=CurrNode->getFirstChild();
  NewNode=tTreeEdit->Items->AddChildFirst(CurrNode,"�����");
  Node1->MoveTo(NewNode, naAddChildFirst);
 }
 else
 {
  NewNode=tTreeEdit->Items->AddChild(CurrNode,"�����");
 }

 NewNode->StateIndex=-1;
 NewNode->ImageIndex=1;
 NewNode->SelectedIndex=1;
 NewNode->Selected=true;

 PTreeNodeData NodeData= new TTreeNodeData;
 NodeData->type_eqp=13;
 NodeData->line_no=0;
 NewNode->Data=NodeData;
 NodeDataList->Add(NodeData);

//////------------------ tTreeEdit->FullExpand();
/*
 tbNew->Enabled=false;
 tbDelete->Enabled=false;
 tbDelTree->Enabled=false;
 tbNewTree->Enabled=false;
 tbCancel->Enabled=true;
 tbApply->Enabled=true;
 */
 LockControls();
 EqpEdit->CreateNewByType(13,"����� ���������"); //������� ������
 treemode=1;  //�������
}
//---------------------------------------------------------------------------

#define WinName "����� ���������"
void _fastcall TfTreeForm::ShowPoints(void) {

  // ���������� ���������
  TWTQuery *QueryAdr;
/*
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
*/
  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp,tt.parents,p.id_icon ");
  QueryAdr->Sql->Add("from eqm_equipment_tbl AS eq JOIN eqm_eqp_tree_tbl AS tt ON (eq.id=tt.code_eqp and eq.type_eqp = 13 and tt.line_no = 0) ");
  QueryAdr->Sql->Add("JOIN eqm_tree_tbl AS t ON (t.id=tt.id_tree) join eqi_device_kinds_prop_tbl as p on (p.type_eqp = eq.type_eqp) ");
  QueryAdr->Sql->Add("where (t.id_client= :client) order by eq.name_eqp;");

  WPointGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WPointGrid->SetCaption(WinName);

  TWTQuery* Query = WPointGrid->DBGrid->Query;
  Query->ParamByName("client")->AsInteger=abonent_id;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");
  TStringList *NList=new TStringList();
//  NList->Add("id");

  QueryAdr->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WPointGrid->AddColumn("name_eqp", "������������", "������������");

  WPointGrid->DBGrid->FieldSource = WPointGrid->DBGrid->Query->GetTField("id");

  WPointGrid->DBGrid->StringDest = "-1";

  WPointGrid->DBGrid->OnAccept=PointAccept;
  WPointGrid->OnCloseQuery=PointClose;

  WPointGrid->DBGrid->Visible = true;
  WPointGrid->DBGrid->ReadOnly=true;
  WPointGrid->ShowAs("����� �����");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::PointAccept (TObject* Sender)
{
//
 int PointId=WPointGrid->DBGrid->Query->FieldByName("id")->AsInteger;
 AnsiString name =WPointGrid->DBGrid->Query->FieldByName("name_eqp")->AsString;
 int icon =WPointGrid->DBGrid->Query->FieldByName("id_icon")->AsInteger;
 // ������� � ����� ��� �����
 CurParents=WPointGrid->DBGrid->Query->FieldByName("parents")->AsInteger;

 NewNode=tTreeEdit->Items->AddChild(CurrNode,name+"("+IntToStr(CurParents)+")");

 NewNode->StateIndex=PointId;
 NewNode->ImageIndex=icon;
 NewNode->SelectedIndex=1;
 NewNode->Selected=true;

 PTreeNodeData NodeData= new TTreeNodeData;
 NodeData->type_eqp=13;
 NodeData->line_no=CurParents;
 NewNode->Data=NodeData;
 NodeDataList->Add(NodeData);

 tTreeEdit->FullExpand();
/*
 tbNew->Enabled=false;
 tbDelete->Enabled=false;
 tbDelTree->Enabled=false;
 tbNewTree->Enabled=false;
 tbCancel->Enabled=true;
 tbApply->Enabled=true;
*/
 LockControls();
// EqpEdit->CreateNewByType(13,"����� ���������"); //������� ������
 treemode=7;  //����������� � ����� ���������
 StatusBar1->Panels->Items[0]->Text="����������� � ����� ���������";
}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::PointClose(TObject* Sender, bool &CanClose)
{
//if (treemode!=7) tbCancelClick(Sender);
}

//---------------------------------------------------------------------------
void __fastcall TfTreeForm::tbConnectClick(TObject *Sender)
{
 if (fReadOnly) return;
 
 ShowPoints();
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miChangeClick(TObject *Sender)
{
 if (fReadOnly) return;
/*
 StatusBar1->Panels->Items[0]->Text="������";

// CurrNode->StateIndex=-1;
 CurrNode->ImageIndex=1;
 CurrNode->SelectedIndex=1;
 CurrNode->Selected=true;
 NewNode=CurrNode;

 tTreeEdit->FullExpand();

 LockControls();
 EqpEdit->CreateNewEquipment(CurrNode->StateIndex);
 treemode=8;  //������
 */
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::AbonAccept (TObject* Sender)
{
  parent_abonent=WAbonGrid->Query->FieldByName("id")->AsInteger;
  //������ ����������� � ������ ����
  if (parent_abonent==abonent_id)
  {
   ShowMessage("������� � ���������� �� ����� ���� ����� �����.");
   parent_abonent=0;
  }

  ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientAId=parent_abonent;
  ((TfBorderDet*)(EqpEdit->DetEditForm))->ClientBId=abonent_id;

  ((TfBorderDet*)(EqpEdit->DetEditForm))->edClientA->Text=WAbonGrid->Query->FieldByName("short_name")->AsString;
  ((TfBorderDet*)(EqpEdit->DetEditForm))->edClientB->Text=abonent_name;

};
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::AbonClose(System::TObject* Sender, bool &CanClose)
{
 if (parent_abonent==0)
   tbCancelClick(Sender); // �� ������� �������� - �������� ����������
 else
 {
  // ������� �������� - ������� ������
  Application->CreateForm(__classid(TfTreeForm), &fSelectTree);
  fSelectTree->tTreeEdit->OnDblClick=tTreeEditDblClick;
  fSelectTree->OnCloseQuery=FormCloseQuery;
  BorderParent=0;

  fSelectTree->ShowTrees(parent_abonent,true);

  tbNew->Enabled=false;
  tbDelete->Enabled=false;
  tbCancel->Enabled=true;
  tbApply->Enabled=true;

  StatusBar1->Panels->Items[0]->Text="����������� ��� �����������";
 }
}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::FormDestroy(TObject *Sender)
{
 if (!fReadOnly)  ClearTemp();

// ZQTree->Transaction->AutoCommit=true;
// ZQTree->Transaction->TransactSafe=false;
 delete ZQTree;
 delete CoolBar1;
 TreeList->Clear();
 delete TreeList;

 for (int i=0;i<NodeDataList->Count;i++)
 {
 delete (NodeDataList->Items[i]);
 }
 NodeDataList->Clear();
 delete NodeDataList;
 fTreeForm=NULL;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miChangeTranzitClick(TObject *Sender)
{
// ������ �� ������ ������ !!!!!!!!!!!!!!!!!
if (MessageDlg("���������� � ������� �����������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrNo)
 return;

 parent_abonent=0;

 NewNode=NULL;
 CurrNode=CurrNode->getFirstChild();
 CurrNode->Selected=true;
 treemode=61;
 EqpEdit->CreateNewByType(9,"������� �������"); //������� ������
 // ������� �������� �������� ������       111111111111111
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

  //WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
  WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;
  ((TWTDoc *)(WAbonGrid->Owner))-> OnCloseQuery=AbonClose;

}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::LockControls(void)
{
     miDel->Visible=false;
     miNew->Visible=false;
     miAddTranzit->Visible=false;
     miDelTranzit->Visible=false;
     miDelTree->Visible=false;
     miChange->Visible=false;
     miAddDoc->Visible=false;
     miOpenDoc->Visible=false;
     miCivilian->Visible=false;
     miDown->Visible=false;
     miUp->Visible=false;

     tbDelete->Enabled=false;
     tbChange->Enabled=false;
     tbDelTree->Enabled=false;
     tbNew->Enabled=false;
     tbNewTree->Enabled=false;
     tbNewPoint->Enabled=false;
     tbConnect->Enabled=false;
     miRename->Visible=false;
     cbTreeSelect->Enabled=false;
     tbCopyTree->Enabled=false;
     tbPasteTree->Enabled=false;
     tbMove->Enabled=false;
     tbMoveAbons->Enabled=false; 

     tbCancel->Enabled=true;
     tbApply->Enabled=true;

}
//---------------------------------------------------------------------------


void __fastcall TfTreeForm::miAddDocClick(TObject *Sender)
{
OpenDialog->InitialDir=DocFolder;
  if (OpenDialog->Execute())
  {
     sqlstr="update eqm_tree_tbl set file_path = :filename where id = :id_tree; ";
     ZQTree->Sql->Clear();
     ZQTree->Sql->Add(sqlstr);

     ZQTree->ParamByName("id_tree")->AsInteger=CurrTreeId;
     int L=DocFolder.Length()+1;
     ZQTree->ParamByName("filename")->AsString=OpenDialog->FileName.SubString(L,255);
//     DocFolder.Length
     try
     {
      ZQTree->ExecSql();
     }
     catch(...)
     {
      ShowMessage("������ SQL :"+sqlstr);
//      ZQTree->Transaction->Rollback();
      return;
     }
//     ZQTree->Transaction->Commit();     
  }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miOpenDocClick(TObject *Sender)
{
  sqlstr="select file_path from eqm_tree_tbl where id = :id_tree; ";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);

  ZQTree->ParamByName("id_tree")->AsInteger=CurrTreeId;
  try
  {
   ZQTree->Open();
  }
  catch(...)
  {
   ShowMessage("������ SQL :"+sqlstr);
   return;
  }
  if (ZQTree->FieldByName("file_path")->IsNull)
  {
    ShowMessage("���� �� ������.");
  }
  else
  {
    AnsiString FileName=DocFolder+ZQTree->FieldByName("file_path")->AsString;
    try
    {
     ShellExecute(Handle,NULL,FileName.c_str(),NULL,NULL,SW_RESTORE);
    }
    catch (...)
    {
     int i=GetLastError();
     if (i<=32)
     ShowMessage("��������� �� �������");
    }
  }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miRenameClick(TObject *Sender)
{
CurrNode->EditText();
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbAreasClick(TObject *Sender)
{
 if (fReadOnly) return;

 MainForm->ShowAreasList(abonent_id,11,"��������",CheckLevel("����� 3 - ��������/�������� ��������")!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbStationsClick(TObject *Sender)
{
 if (fReadOnly) return;
 MainForm->ShowAreasList(abonent_id,8,"���������������� ����������",CheckLevel("����� 3 - ��������/�������� ����������")!=0);
}
//---------------------------------------------------------------------------


void __fastcall TfTreeForm::tbFidersClick(TObject *Sender)
{
 if (fReadOnly) return;
 MainForm->ShowAreasList(abonent_id,15,"������",CheckLevel("����� 3 - ��������/�������� �������")!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbExpandClick(TObject *Sender)
{
   tTreeEdit->FullExpand();

    // determine the range the user wants to print
    // now, print the pages
//    Printer()->BeginDoc();
//    tTreeEdit->PaintTo(Printer()->Handle, 10, 10);
//    Printer()->EndDoc();
//Print();

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbCollapseClick(TObject *Sender)
{
//   tTreeEdit->FullCollapse();

  for(int i=0;i<=TreeList->Count-1;i++)
   {

    for(int j=0;j<=tTreeEdit->Items->Count-1;j++)
    {
     if ((tTreeEdit->Items->Item[j]->StateIndex==(PTreeListData(TreeList->Items[i])->id_tree))&&(tTreeEdit->Items->Item[j]->ImageIndex==0))
      {
       tTreeEdit->Items->Item[j]->Collapse(false);
       break;
      }
    }
   }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tTreeEditExpanded(TObject *Sender,
      TTreeNode *Node)
{
// if (Node->Level==0) Node->Expand(true);
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbPrintClick(TObject *Sender)
{
//  ������ ������
 EasyPrint->Options->TreeView->PrintLines = true;
 EasyPrint->Options->TreeView->PrintImages = true;
 EasyPrint->Options->TreeView->Numbering = false;

 EasyPrint->Header2 = fTreeForm->Caption;
 EasyPrint->Print (tTreeEdit);

}
//---------------------------------------------------------------------------


void TfTreeForm::ShowViewTrees(int abonent,int node)
{
  abonent_id=abonent;

//  EqpEdit->usr_id=usr_id;
//  EqpEdit->abonent_id=abonent_id;
//  EqpEdit->is_res=(abonent_id==ResId);
//  EqpEdit->LastDate=TDate(0);

  fReadOnly=true;

  sqlstr=" select cl.short_name from clm_client_tbl as cl where cl.id = :client";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("client")->AsInteger=abonent_id;

  try
   {
   ZQTree->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }

  ZQTree->First();
  Caption="����� ����� "+ZQTree->FieldByName("short_name")->AsString+ " � �������������";
  abonent_name=ZQTree->FieldByName("short_name")->AsString;

  ZQTree->Close();


  sqlstr="select eq_sel_viewtree( :eqp_id, :eqp_id, :usr, 0, 0);";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("eqp_id")->AsInteger=node;
  ZQTree->ParamByName("usr")->AsInteger=usr_id;

  try
   {
   //ZQTree->Open();
   ZQTree->ExecSql();
   }
  catch(...)
   {
//    ShowMessage("������ SQL :"+sqlstr);
    ShowMessage("������ ���������� ��������� ������. ���� ����� �������.");
    ZQTree->Close();
//    ZQTree->Transaction->Rollback();                 //<<<<
    Close();
    return;
   }
//  status =ZQTree->Fields->Fields[0]->AsBoolean;
  ZQTree->Close();
//  ZQTree->Transaction->Commit();


   tTreeEdit->Items->BeginUpdate();
//   tTreeEdit->Items->GetFirstNode()->Selected=true;
   tTreeEdit->Items->Clear();

  if (!Visible) Show();

  //-------------------------------
  TreeList->Clear();

  TreeData= new TTreeListData;
  TreeData->TreeName="";
  TreeData->id_tree=0;
  TreeList->Add(TreeData);

  TTreeNode *Node1;
  bool status;
  Node1=tTreeEdit->Items->Add(NULL, "");
  Node1->StateIndex=0;
  Node1->ImageIndex=0;
  Node1->SelectedIndex=0;

  PTreeNodeData NodeData= new TTreeNodeData;
  NodeData->type_eqp=0;
  NodeData->line_no=0;
  Node1->Data=NodeData;
  NodeDataList->Add(NodeData);
  //--------------------------------

   //������ ������ � ���� �� ��������� �������
   sqlstr="select code_eqp,code_eqp_p,name,id_icon,type_eqp,line_no from eqt_viewtree where (id_usr= :usr)and(root_eqp= :root) Order By lvl,line_no;";
   ZQTree->Sql->Clear();
   ZQTree->Sql->Add(sqlstr);
   ZQTree->ParamByName("usr")->AsInteger=usr_id;
   ZQTree->ParamByName("root")->AsInteger=node;
   try
   {
    ZQTree->Open();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQTree->Close();
    return;
   }
   ZQTree->First();

   FullTreeNodesMap.erase(FullTreeNodesMap.begin(),FullTreeNodesMap.end());
   TreeNodesMap.erase(TreeNodesMap.begin(),TreeNodesMap.end());

   for(int i=1;i<=ZQTree->RecordCount;i++)
    {
     if (ZQTree->FieldByName("code_eqp")->AsInteger==node)
      {
       BuildTreeRoot(ZQTree->FieldByName("code_eqp")->AsInteger,
                     0,
                     ZQTree->FieldByName("id_icon")->AsInteger,
                     ZQTree->FieldByName("type_eqp")->AsInteger,
                     ZQTree->FieldByName("line_no")->AsInteger,
                     ZQTree->FieldByName("name")->AsString,0);
      }
     else
      {
       BuildTreeNode(ZQTree->FieldByName("code_eqp")->AsInteger,
                     ZQTree->FieldByName("code_eqp_p")->AsInteger,
                     ZQTree->FieldByName("id_icon")->AsInteger,
                     ZQTree->FieldByName("type_eqp")->AsInteger,
                     ZQTree->FieldByName("line_no")->AsInteger,
                     ZQTree->FieldByName("name")->AsString,0);
      }
     ZQTree->Next();
    }
    ZQTree->Close();
    TreeNodesMap.erase(TreeNodesMap.begin(),TreeNodesMap.end());
   //
   //tTreeEdit->Items->EndUpdate();
   tTreeEdit->FullExpand();

//  }
  //else
//  {
//    ShowMessage("������ ���������� ��������� ������. ���� ����� �������.");
//    ZQTree->Transaction->Rollback();                 //<<<<
  //  Close();
//  }


   //**********************************

   tTreeEdit->Items->EndUpdate();

   Caption=Caption+" (������ ��������)";
   tTreeEdit->ReadOnly=true;
   miDelTree->Enabled=false;
   miNew->Enabled=false;
   miDel->Enabled=false;
   miChange->Enabled=false;
   miAddTranzit->Enabled=false;
   miDelTranzit->Enabled=false;
   miDown->Enabled=false;
   miUp->Enabled=false;
   tbFullView->Visible=false;
   miCivilian->Enabled=false;

}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::tbFullViewClick(TObject *Sender)
{
 if (fReadOnly) return;

  Application->CreateForm(__classid(TfTreeForm), &fTreeForm);
  fTreeForm->ShowAs("viewtreeform");
  fTreeForm->ShowViewTrees(abonent_id,CurrNode->StateIndex);

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::cbTreeSelectChange(TObject *Sender)
{
   tTreeEdit->Items->BeginUpdate();
   if (tTreeEdit->Items->Count >0)
      tTreeEdit->Items->GetFirstNode()->Selected=true;
   tTreeEdit->Items->Clear();
   cbTreeSelect->Font->Color = clWindowText;
   FullTreeNodesMap.erase(FullTreeNodesMap.begin(),FullTreeNodesMap.end());
   if(cbTreeSelect->ItemIndex==0)
   {
    for(int i=0;i<=TreeList->Count-1;i++)
    {
      BuildTree((PTreeListData(TreeList->Items[i]))->id_tree,(PTreeListData(TreeList->Items[i]))->TreeName,false);
    }
   }

   if(cbTreeSelect->ItemIndex>0)
   {
      BuildTree((PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->id_tree,(PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->TreeName,false);
      tTreeEdit->Items->Item[0]->Selected=true;
   }

   tTreeEdit->Items->EndUpdate();

   ActiveControl = tTreeEdit;
   if (tTreeEdit->Items->Count >0)
      tTreeEdit->Items->GetFirstNode()->Selected=true;

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbCopyTreeClick(TObject *Sender)
{
 if (fReadOnly) return;
 Copy_tree= CurrTreeId;
 Move_node=Copy_node=CurrNode->StateIndex;
 tbPasteTree->Enabled=true;
 tbMove->Enabled=true;
 tbMoveAbons->Enabled=movefiz_enable; 
 //��� ��������
// DragNodeId=CurrNode->;
// tbCopyTree->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbPasteTreeClick(TObject *Sender)
{
 if (fReadOnly) return;
 TDateTime ChDate;

 if(MessageDlg("�������� �������� ����� ����� "+CurrNode->Text, mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    return;

 // ������� ���� ��������� ��� �����
 TfChangeDate* fChangeDate;
 Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
 if (fChangeDate->ShowModal()!= mrOk)
   {
    delete fChangeDate;
    return ; // ��������
   };
//  ChDate=fChangeDate->DateTime->Date;
     try
     {
      ChDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      return;
     }

  delete fChangeDate;
  operation=0;

  if (CurrNode->ImageIndex==0)
     {
     // ������ ���������� ��������� ������ (����� ������)
     operation=MainForm->PrepareChange(ZQTree,2,CurrTreeId,Copy_node,usr_id,CangeLogEnabled,ChDate);
      if (operation ==-1)   return;

     }
     sqlstr="select eqm_copy_tree_fun(:stree, :snode, :dtree, :dnode, :newdate);";
     ZQTree->Sql->Clear();
     ZQTree->Sql->Add(sqlstr);

     ZQTree->ParamByName("stree")->AsInteger=Copy_tree;
     ZQTree->ParamByName("snode")->AsInteger=Copy_node;
     ZQTree->ParamByName("dtree")->AsInteger=CurrTreeId;
//     ZQTree->ParamByName("dnode")->AsInteger=CurrNode->StateIndex;
     ZQTree->ParamByName("newdate")->AsDateTime=ChDate;

     if (CurrNode->ImageIndex!=0)
      {
       ZQTree->ParamByName("dnode")->AsInteger=CurrNode->StateIndex;
      }
     else
      {
       ZQTree->ParamByName("dnode")->Clear();
      }

     try
      {
       //ZQTree->Open();
       ZQTree->ExecSql();
      }
     catch(...)
     {
       ShowMessage("������ SQL :"+sqlstr);
//       ZQTree->Transaction->Rollback();                 //<<<<
       //ZQTree->Close();
       return;
     }

   if (operation!=0)
   MainForm->AfterChange(ZQTree,operation,CangeLogEnabled);

//   ZQTree->Transaction->Commit();           //!!!!!!!!!!!!!!

   int _parentnode;
   if (CurrNode->ImageIndex!=0)
     _parentnode= CurrNode->StateIndex;
   else _parentnode=0;

   tTreeEdit->Items->BeginUpdate();
   tTreeEdit->Items->GetFirstNode()->Selected=true;
   tTreeEdit->Items->Clear();
   // ���������� ��������� ������� � ���������� ������
   if (SelectTrees())
   {
    if(cbTreeSelect->ItemIndex==0)
    {
     for(int i=0;i<=TreeList->Count-1;i++)
     {
       BuildTree((PTreeListData(TreeList->Items[i]))->id_tree,(PTreeListData(TreeList->Items[i]))->TreeName,false);
     }
    }
    if(cbTreeSelect->ItemIndex>0)
    {
       BuildTree((PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->id_tree,(PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->TreeName,false);
    }
   }
   tTreeEdit->Items->EndUpdate();
    // ������� �������
   if (_parentnode!=0)
    FullTreeNodesMap[_parentnode]->Selected=true;
/*
    for(int i=0;i<=tTreeEdit->Items->Count-1;i++)
    {
     if (tTreeEdit->Items->Item[i]->StateIndex==_parentnode)
      {
       tTreeEdit->Items->Item[i]->Selected=true;
       break;
      }
    }
*/
   tbCopyTree->Enabled=copy_enable;
   tbPasteTree->Enabled=false;
   tbMove->Enabled=false;
   tbMoveAbons->Enabled=false; 
   Copy_tree= 0;
   Copy_node=Move_node=0;
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbSearchClick(TObject *Sender)
{
FindDialog1->Tag=0; //������ ������

FindDialog1->Execute();
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::FormKeyDown(TObject *Sender, WORD &Key,
      TShiftState Shift)
{
  TShiftState ss;
  ss << ssAlt;
 if (Key == VK_SPACE && Shift == ss)
  {
   Key=0;
   tbSearchClick(Sender);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::FindDialog1Find(TObject *Sender)
{
  TTreeNode *FindNode;
  AnsiString regular;

  // FindDialog1->Tag ��� ������� �������
  if ((FindDialog1->Tag==0)||(SerchStr!=FindDialog1->FindText))  //������ ������
  {
    SerchStr=FindDialog1->FindText;

    if (FindDialog1->Options.Contains(frMatchCase)) regular = "~'";
    else regular = "~*'";

    sqlstr="select eqm.code_eqp from eqm_eqp_tree_tbl as eqm left join eqm_tree_tbl as eqt on (eqm.id_tree=eqt.id) \
    join eqm_equipment_tbl as eq on (eq.id = eqm.code_eqp ) where eqm.name "+regular+FindDialog1->FindText+"'";

    if(cbTreeSelect->ItemIndex!=0)
    {
     sqlstr=sqlstr+" and eqm.id_tree = :tree ";
    }

    sqlstr=sqlstr+" and id_client = :client and eq.type_eqp <> 9  order by eqm.code_eqp;";

    ZQTree->Close();
    ZQTree->Sql->Clear();
    ZQTree->Sql->Add(sqlstr);
    ZQTree->ParamByName("client")->AsInteger=abonent_id;

    if(cbTreeSelect->ItemIndex>0)
    {
      ZQTree->ParamByName("tree")->AsInteger=(PTreeListData(TreeList->Items[cbTreeSelect->ItemIndex-1]))->id_tree;
    }

    try
     {
      ZQTree->Open();
     }
    catch(...)
    {
      ShowMessage("������ SQL :"+sqlstr);
      ZQTree->Close();
      return;
    }

    if (ZQTree->RecordCount>0)
     {
      ZQTree->First();
//      ((TTreeNode*)TreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger])->Selected=true;
      FindNode=FullTreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger];
      FindNode->Selected=true;
      FindDialog1->Tag=1;
     }
    else
      ShowMessage("�������� �� �������!");
    //ZQTree->Close();
  }
  else //�����������
  {
   if (FindDialog1->Tag < ZQTree->RecordCount) // �� ��������� ������
   {
     ZQTree->Next();
     FindNode=FullTreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger];
     FindNode->Selected=true;
     FindDialog1->Tag++;
   }
   else
      ShowMessage("������ ��� ��������!");
  }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::FindDialog1Close(TObject *Sender)
{
  ZQTree->Close();
  FindDialog1->Tag=0;
  SerchStr="";
}
//---------------------------------------------------------------------------



//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbMoveClick(TObject *Sender)
{
//
 TTreeNode *NewParentNode;

 if (fReadOnly) return;
 if (CurrNode==NULL) return;

 if(MessageDlg("��������� �������� ����� �� "+CurrNode->Text, mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    return;

   DragNode =NULL;
   DragNode = FullTreeNodesMap[Move_node];

   NewTreeId=(PTreeNodeData(CurrNode->Data))->id_tree;

   if (CurrNode->ImageIndex!=0)
   {
     NewParentId = CurrNode->StateIndex;
     NewParentNode = CurrNode;
   }  
   else
   {

    sqlstr=" select eq.id from eqm_tree_tbl as t join eqm_equipment_tbl as eq on (t.code_eqp = eq.id) \
     where t.id = :tree and eq.type_eqp = 9 ; ";

    ZQTree->Sql->Clear();
    ZQTree->Sql->Add(sqlstr);
    ZQTree->ParamByName("tree")->AsInteger=NewTreeId;
    try
    {
     ZQTree->Open();
    }
    catch(...)
    {
     ShowMessage("������ SQL :"+sqlstr);
     ZQTree->Close();
     return;
    }
    if (ZQTree->RecordCount !=0)
    {
     ZQTree->First();
     NewParentId= ZQTree->FieldByName("id")->AsInteger;
     NewParentNode =  FullTreeNodesMap[NewParentId];
    }
    else
    {
     NewParentId =0;
     NewParentNode = CurrNode;
    } 

    ZQTree->Close();

   }
   //���� �� ������ DragNode, ������ ����������� ����� �� ���������� � ������ ������
   if (DragNode!=NULL)
   {
    if ((NewParentNode!=DragNode)&&(NewParentNode!=DragNode->Parent))
    {
     DragNode->MoveTo(NewParentNode, naAddChild);
     /////////////////-------------------    tTreeEdit->FullExpand();

     WorkNodeLine=PTreeNodeData(DragNode->Data)->line_no;

     GhangeTreeRec(DragNode,NewTreeId);
    }
   }
   else
   {
    // ���������� �����, �������� ��� ������,  �� �������� ���� �������,
    // ���� ����������� ������������ � ��� ��������

    sqlstr=" Select tt.code_eqp,tt.code_eqp_e as code_eqp_p ,tt.name,eq.type_eqp,tt.line_no, dkp.id_icon \
    From eqm_eqp_tree_tbl AS tt JOIN eqm_equipment_tbl AS eq ON (tt.code_eqp=eq.id) \
    JOIN (eqi_device_kinds_tbl AS dk JOIN eqi_device_kinds_prop_tbl AS dkp ON (dk.id=dkp.type_eqp)) ON (eq.type_eqp=dk.id) \
    left join eqm_borders_tbl as b on (b.code_eqp=eq.id) \
    left join clm_client_tbl as cl on (cl.id=b.id_clientb) \
    WHERE (id_tree= :tree)  and coalesce(cl.book,-1)=-1 \
    Order By tt.lvl,tt.line_no; ";

    ZQTree->Sql->Clear();
    ZQTree->Sql->Add(sqlstr);
    ZQTree->ParamByName("tree")->AsInteger=Copy_tree;
    try
    {
     ZQTree->Open();
    }
    catch(...)
    {
     ShowMessage("������ SQL :"+sqlstr);
     ZQTree->Close();
     return;
    }
    ZQTree->First();

    TreeNodesMap.erase(TreeNodesMap.begin(),TreeNodesMap.end());

    int find_first = 0;

    for(int i=1;i<=ZQTree->RecordCount;i++)
     {

      if (ZQTree->FieldByName("code_eqp")->AsInteger == Move_node)
       {

        Node1=tTreeEdit->Items->AddChild(NewParentNode,ZQTree->FieldByName("name")->AsString);
        Node1->StateIndex=ZQTree->FieldByName("code_eqp")->AsInteger;
        Node1->ImageIndex=ZQTree->FieldByName("id_icon")->AsInteger;
        Node1->SelectedIndex=ZQTree->FieldByName("id_icon")->AsInteger;

        if (ZQTree->FieldByName("line_no")->AsInteger==0)
        {
         TreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger]=Node1;
         FullTreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger]=Node1;
        }

        PTreeNodeData NodeData= new TTreeNodeData;
        NodeData->type_eqp=ZQTree->FieldByName("type_eqp")->AsInteger;
        NodeData->line_no=ZQTree->FieldByName("line_no")->AsInteger;
        NodeData->id_tree=NewTreeId;
        Node1->Data=NodeData;
        NodeDataList->Add(NodeData);

        find_first = 1;
       }
      else
       {
       if (find_first ==1)
        {

         Node2=NULL;

         Node2=TreeNodesMap[ZQTree->FieldByName("code_eqp_p")->AsInteger];
         if (Node2!=NULL)
         {
          Node1=tTreeEdit->Items->AddChild(Node2,ZQTree->FieldByName("name")->AsString);
          Node1->StateIndex=ZQTree->FieldByName("code_eqp")->AsInteger;
          Node1->ImageIndex=ZQTree->FieldByName("id_icon")->AsInteger;
          Node1->SelectedIndex=ZQTree->FieldByName("id_icon")->AsInteger;

          if (ZQTree->FieldByName("line_no")->AsInteger==0)
          {
           TreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger]=Node1;
           FullTreeNodesMap[ZQTree->FieldByName("code_eqp")->AsInteger]=Node1;
          }

          PTreeNodeData NodeData= new TTreeNodeData;
          NodeData->type_eqp=ZQTree->FieldByName("type_eqp")->AsInteger;
          NodeData->line_no=ZQTree->FieldByName("line_no")->AsInteger;
          NodeData->id_tree=NewTreeId;
          Node1->Data=NodeData;
          NodeDataList->Add(NodeData);
         }
        }
       }
      ZQTree->Next();
     }
     ZQTree->Close();
     TreeNodesMap.erase(TreeNodesMap.begin(),TreeNodesMap.end());
    // tTreeEdit->FullExpand();

     WorkNodeLine=0;     
   }


   tbNew->Enabled=false;
   tbDelete->Enabled=false;
   tbCancel->Enabled=true;
   tbApply->Enabled=true;
   tbNewTree->Enabled=false;

   treemode=2;  //����������� �����
   StatusBar1->Panels->Items[0]->Text="�����������";
   WorkNodeId = Move_node;
   OldTreeId=Copy_tree;

   tbCopyTree->Enabled=copy_enable;
   tbPasteTree->Enabled=false;
   tbMove->Enabled=false;
   tbMoveAbons->Enabled=false; 
   Copy_tree= 0;
   Copy_node=Move_node=0;

 }
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::GhangeTreeRec(TTreeNode *VNode, int tree_id)
{

    (PTreeNodeData(VNode->Data))->id_tree=tree_id;

    if(VNode->HasChildren)
    {
     for (int i = 0; i < VNode->Count; i++)

      //(PTreeNodeData(VNode->Item[i]->Data))->id_tree=tree_id;
      GhangeTreeRec(VNode->Item[i],tree_id);

    }
}
//---------------------------------------------------------------------------
void __fastcall TfTreeForm::tbDeletedEqpClick(TObject *Sender)
{
  TWTQuery *ZQDeletedEqp;

  TWinControl *Owner = this ;
  // ���� ����� ���� ���� - ������������ � �������
  if (MainForm->ShowMDIChild("��������� ������������", Owner)) {
    return;
  }

  ZQDeletedEqp = new  TWTQuery(this);
  ZQDeletedEqp->Options << doQuickOpen;

  ZQDeletedEqp->Sql->Clear();

  ZQDeletedEqp->Sql->Add(" select eq.id, eq.name_eqp,eq.num_eqp,eq.dt_install, eq.id_addres,eq.loss_power, ");
  ZQDeletedEqp->Sql->Add(" d.name,eq.dt_e,eq.type_eqp,syt1.name AS name_table, syt2.name AS name_table_ind ");
  ZQDeletedEqp->Sql->Add(" from eqm_equipment_h as eq join ( ");
  ZQDeletedEqp->Sql->Add(" select eq2.id, max(eq2.dt_b)as dt_b from eqm_equipment_h as eq2 ");
  ZQDeletedEqp->Sql->Add(" join (select distinct tt2.code_eqp from ");
  ZQDeletedEqp->Sql->Add(" eqm_eqp_tree_h as tt2 join eqm_tree_h as t2 on (t2.id = tt2.id_tree) ");
  ZQDeletedEqp->Sql->Add(" where tt2.line_no = 0 and  t2.id_client = :client ) as tr ");
  ZQDeletedEqp->Sql->Add(" on (tr.code_eqp = eq2.id ) where eq2.dt_e is not null ");
  ZQDeletedEqp->Sql->Add(" group by  eq2.id ) as s on  (eq.id = s.id and eq.dt_b = s.dt_b) ");
  ZQDeletedEqp->Sql->Add(" left join eqm_equipment_tbl as eq3 on (eq3.id = eq.id) ");
  ZQDeletedEqp->Sql->Add(" left join eqi_device_kinds_tbl as d on (d.id = eq.type_eqp) ");
  ZQDeletedEqp->Sql->Add(" LEFT JOIN syi_table_tbl AS syt1 ON (d.id_table=syt1.id) ");
  ZQDeletedEqp->Sql->Add(" LEFT JOIN syi_table_tbl AS syt2 ON (d.id_table_ind=syt2.id) ");
  ZQDeletedEqp->Sql->Add(" where eq3.name_eqp is null and eq.type_eqp<>13; ");

  ZQDeletedEqp->ParamByName("client")->AsInteger=abonent_id;

  TfDelEqpList *WDelEqpGrid = new TfDelEqpList(this, ZQDeletedEqp,false, abonent_id,abonent_name);
  WDelEqpGrid->SetCaption("��������� ������������");
  WDelEqpGrid->ShowAs("��������� ������������");

}
//---------------------------------------------------------------------------


void __fastcall TfTreeForm::tbMoveAbonsClick(TObject *Sender)
{
 if (fReadOnly) return;
 if (CurrNode==NULL) return;

 if(MessageDlg("�������������� ������������ ���.��� ��  "+CurrNode->Text, mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    return;

 // ������� ����
 TfChangeDate* fChangeDate;
 TDateTime ChDate;
 Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
 if (fChangeDate->ShowModal()!= mrOk)
   {
    delete fChangeDate;
    return ; // ��������
   };
     try
     {
      ChDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("�������� ����");
      delete fChangeDate;
      return;
     }

  delete fChangeDate;

  AnsiString sqlstr=" update eqm_privmeter_tbl set id_eqmborder = :neweqmborder, dt_change = :dt where id_eqmborder = :oldeqmborder;";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);

  ZQTree->ParamByName("neweqmborder")->AsInteger=CurrNode->StateIndex;
  ZQTree->ParamByName("oldeqmborder")->AsInteger=Move_node;
  ZQTree->ParamByName("dt")->AsDateTime=ChDate;

  try
   {
    ZQTree->ExecSql();
   }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
//    ZQTree->Transaction->Rollback();                 //<<<<
    //ZQTree->Close();
    return;
  }

  sqlstr=" update clm_pclient_tbl set id_eqpborder = :neweqmborder  where id_eqpborder = :oldeqmborder;";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);

  ZQTree->ParamByName("neweqmborder")->AsInteger=CurrNode->StateIndex;
  ZQTree->ParamByName("oldeqmborder")->AsInteger=Move_node;

  try
   {
    ZQTree->ExecSql();
   }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
//    ZQTree->Transaction->Rollback();                 //<<<<
    //ZQTree->Close();
    return;
  }

// ZQTree->Transaction->Commit();
 Copy_node=Move_node=0;
 ShowMessage("������������ ���������.");
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbSerchIdClick(TObject *Sender)
{
 FindIdDialog->Execute();
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::FindIdDialogFind(TObject *Sender)
{
//
  int find_id;

  try {
   find_id = StrToInt(FindIdDialog->FindText);
  } catch(...)
  {
   return;
  }

  AnsiString sqlstr=" select t.id_client from eqm_tree_tbl as t join eqm_eqp_tree_tbl as tt on (t.id = tt.id_tree) where tt.code_eqp = :eqp limit 1;";
  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);

  ZQTree->ParamByName("eqp")->AsInteger=find_id;

  try
   {
    ZQTree->Open();
   }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    return;
  }

 if (ZQTree->RecordCount >0)
 {
  fTreeForm->ShowTrees(ZQTree->FieldByName("id_client")->AsInteger,false,find_id);
 }
 else
 {

  sqlstr=" select eq.type_eqp, syt1.name AS name_table, syt2.name AS name_table_ind \
  from eqm_equipment_h as eq \
  left join eqi_device_kinds_tbl as d on (d.id = eq.type_eqp) \
  LEFT JOIN syi_table_tbl AS syt1 ON (d.id_table=syt1.id) \
  LEFT JOIN syi_table_tbl AS syt2 ON (d.id_table_ind=syt2.id) \
  where eq.id = :eqp limit 1;";

  ZQTree->Sql->Clear();
  ZQTree->Sql->Add(sqlstr);
  ZQTree->ParamByName("eqp")->AsInteger=find_id;

  try
   {
    ZQTree->Open();
   }
  catch(EDatabaseError &e)
  {                                                  
    ShowMessage("������ : "+e.Message.SubString(8,200));
    return;
  }

  if (ZQTree->RecordCount >0)
  {
   TfHistoryEdit *WHistoryEdit=new TfHistoryEdit(this,find_id,
    ZQTree->FieldByName("type_eqp")->AsInteger,
    ZQTree->FieldByName("name_table")->AsString,
    ZQTree->FieldByName("name_table_ind")->AsString);

   WHistoryEdit->ShowAs("������� ��������� ���������� ������������");
   WHistoryEdit->SetCaption("������� ��������� ���������� ������������");

   WHistoryEdit->ID="�������";

   WHistoryEdit->ShowData();
  }
  else
  {
    ShowMessage("������������ � ����� "+IntToStr(find_id)+" �� �������.");
  }
 }
}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miCivilianClick(TObject *Sender)
{
//

  TWTWinDBGrid* Grid;
//  ZQTree->Transaction->AutoCommit=true;
//  ZQTree->Transaction->TransactSafe=false;

  Grid=MainForm->EqmAbonConnect(CurrNode->StateIndex);
  if(Grid==NULL) return;

//  ZQTree->Transaction->AutoCommit=true;
//  ZQTree->Transaction->TransactSafe=false;

  //else WAbonGrid=Grid;

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::miGekClick(TObject *Sender)
{
  TWTWinDBGrid* Grid;
//  ZQTree->Transaction->AutoCommit=true;
//  ZQTree->Transaction->TransactSafe=false;
  Grid=MainForm->EqmGekConnect(CurrNode->StateIndex);
  if(Grid==NULL) return;

}
//---------------------------------------------------------------------------

void __fastcall TfTreeForm::tbOpenAbonClick(TObject *Sender)
{
  MainForm->CliClientMBtn(this);
  TWTDoc *DocClient;
  TWTDBGrid* DBGrClient;

  TLocateOptions SearchOptions;
  SearchOptions.Clear();

  int f =0;

  for(int i = MainForm->MDIChildCount-1; i >= 0; i--)
  {
   //            DocClient
   // ShowMessage("���� :"+MainForm->MDIChildren[i]->Name);
   if ( MainForm->MDIChildren[i]->Name == "DocClient")
   {
     try{
       DocClient =(TWTDoc*)(MainForm->MDIChildren[i]);

       DBGrClient = (TWTDBGrid*)(DocClient->Tag);

       DBGrClient->Query->Locate("id",abonent_id ,SearchOptions);

     } catch(...) {};

       //MDIChildren[i]->WindowState=wsNormal;
   }
  }

}
//---------------------------------------------------------------------------

