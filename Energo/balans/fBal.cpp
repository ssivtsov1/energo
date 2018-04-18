//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fBal.h"
#include "fbalConnSw.h"
#include "Main.h"
#include "ftree.h"
#include "ClientBill.h"
#include "ResDemL.h"
#include "fCheckFider.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "EasyPrint"
#pragma resource "*.dfm"
TfBalans *fBalans;
TTreeNode *Node1;
TfTreeForm *fTreeForm;
AnsiString SerchStr;
TWTDBGrid* WAbonGrid;
//---------------------------------------------------------------------------

void _fastcall TMainForm::ShowBalansForm(TObject *Sender) {
     Application->CreateForm(__classid(TfBalans), &fBalans);
     fBalans->ShowAs("Fider_Balans");
     fBalans->ShowData();     
}
//================--------------------------=========================

__fastcall TfBalans::TfBalans(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  ZQBalans = new TWTQuery(Application);
  ZQBalans->MacroCheck=true;
  ZQBalans->Options<< doQuickOpen;
  ZQBalans->RequestLive=false;
  ZQBalans->CachedUpdates=false;
//  ZQBalans->Transaction->AutoCommit=true;
  ZQBalans2 = new TWTQuery(Application);
  ZQBalans2->MacroCheck=true;
  ZQBalans2->Options<< doQuickOpen;
  ZQBalans2->RequestLive=false;
  ZQBalans2->CachedUpdates=false;
//  ZQBalans2->Transaction->AutoCommit=true;

  NodeDataList = new TList;
  CurrNode = NULL;

  Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
  Application->CreateForm(__classid(TfBalansRep), &BalansReports);

  EqpEdit->HostDockSite=PEquipment;
  EqpEdit->Visible=false;

  DateTimePicker->Date=Now();
  Word Year, Month,Day;
  DecodeDate(Now(), Year, Month, Day);
  mmgg=EncodeDate(Year, Month,1);

  AnsiString sqlstr="select getsysvar('kod_res') as res;";
  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);
  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }
   if (ZQBalans->FieldByName("res")->AsInteger ==330 )
   {
    slav_mode =1;
    pAbon->Visible=true;
   }
   else
   {
    slav_mode =0;
    pAbon->Visible=false;
   }

  ZQBalans->Close();    

  sqlstr="select id,name,code from clm_client_tbl where id = getsysvar('id_bal') ;";
  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);
  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }
   if (ZQBalans->RecordCount>0)
   {
    ZQBalans->First();
    ResId=ZQBalans->FieldByName("id")->AsInteger;
    ResName=ZQBalans->FieldByName("name")->AsString;
    BalansReports->ResName=ResName;
    BalansReports->ResId=ResId;
    Caption="Пофидерный анализ "+ResName;

    edAbonName->Text=ResName;
    edAbonCode->Text=ZQBalans->FieldByName("code")->AsString;

   }
  ZQBalans->Close();

}
//---------------------------------------------------------------------------
void __fastcall TfBalans::FormClose(TObject *Sender, TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);

 for (int i=0;i<NodeDataList->Count;i++)
 {
 delete (NodeDataList->Items[i]);
 }
 delete NodeDataList;

 Action = caFree;
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tGroupTreeChanging(TObject *Sender, TTreeNode *Node,
      bool &AllowChange)
{
  CurrNode=Node;

  if ((Node->StateIndex<=0)||(Node->ImageIndex==0))
    {
     if (EqpEdit->Visible) EqpEdit->Hide();
     btBalans->Enabled=false;
     btBalansM->Enabled=false;
     btRep2->Enabled=false;
     btRep3->Enabled=false;
    }
  else
  {
    if (!EqpEdit->Visible) EqpEdit->Show();

    EqpEdit->ShowData(Node->StateIndex,false);  //!!!!!!!!!!!!
    EqpEdit->CangeLogEnabled=false;

    btRep2->Enabled=true;
    btRep3->Enabled=true;
  }
  if ((PBalTreeNodeData(CurrNode->Data))->type_eqp==8)
  {
   if((PBalTreeNodeData(CurrNode->Data))->id_voltage==3)
   {
     btBalans->Enabled=false;
     btBalansM->Enabled=false;     
     btRep3->Enabled=false;
   }
   else
   { btBalans->Enabled=true;
     btBalansM->Enabled=true;
   }
  }
  else
  {
   if ((PBalTreeNodeData(CurrNode->Data))->type_eqp==15)
   {
    btBalans->Enabled=true;
    btBalansM->Enabled=true;
   }
   else
   {
    btBalans->Enabled=false;
    btBalansM->Enabled=false;    
   }
  }
}
//---------------------------------------------------------------------------

void TfBalans::BuildTree(int tree_id, AnsiString tree_name, bool refresh)
{
   TTreeNode *Node1;
   bool status;
   Node1=tGroupTree->Items->Add(NULL, tree_name);
   Node1->StateIndex=tree_id;
   Node1->ImageIndex=0;
   Node1->SelectedIndex=0;

   PBalTreeNodeData NodeData= new TBalTreeNodeData;
   NodeData->type_eqp=0;
   NodeData->id_voltage=0;
  // NodeData->line_no=0;
   Node1->Data=NodeData;
   NodeDataList->Add(NodeData);

/*
   sqlstr="select id_tree,code_eqp,name,id_p_eqp,type_eqp,lvl,id_voltage,id_icon from bal_grp_tree_tbl \
   left join eqi_device_kinds_prop_tbl using (type_eqp)  \
   where id_client = :res and id_tree= :tree and mmgg = :mmgg order by lvl,name;";
   ZQBalans->Sql->Clear();
   ZQBalans->Sql->Add(sqlstr);
   ZQBalans->ParamByName("res")->AsInteger=ResId;  // не берем точки учета абонентов
   ZQBalans->ParamByName("tree")->AsInteger=tree_id;
   ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;
*/

   sqlstr="select id_tree,code_eqp,name,id_p_eqp,type_eqp,lvl,id_voltage,id_icon ,is_recon \
   from bal_grp_tree_conn_tmp as bt \
   left join eqi_device_kinds_prop_tbl using (type_eqp)  \
   where (id_client = :res or type_eqp = 8 ) and id_tree= :tree and mmgg = :mmgg \
   and bt.dat_b<= date_trunc('day', :dt::::date) and bt.dat_e>= date_trunc('day', :dt::::date) \
   order by lvl,name;";

   ZQBalans->Sql->Clear();
   ZQBalans->Sql->Add(sqlstr);
   ZQBalans->ParamByName("res")->AsInteger=ResId;  // не берем точки учета абонентов
   ZQBalans->ParamByName("tree")->AsInteger=tree_id;
   ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;
   ZQBalans->ParamByName("dt")->AsDateTime=DateTimePicker->Date;

   try
   {
    ZQBalans->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }
   ZQBalans->First();
   for(int i=1;i<=ZQBalans->RecordCount;i++)
    {
     if (ZQBalans->FieldByName("id_p_eqp")->IsNull)
      {
       BuildTreeRoot(ZQBalans->FieldByName("code_eqp")->AsInteger,
                     tree_id,
                     ZQBalans->FieldByName("id_icon")->AsInteger,
                     ZQBalans->FieldByName("type_eqp")->AsInteger,
                     ZQBalans->FieldByName("id_voltage")->AsInteger,
                     ZQBalans->FieldByName("name")->AsString);
      }
     else
      {
       int icon;

       if((ZQBalans->FieldByName("is_recon")->AsInteger==1)&&(ZQBalans->FieldByName("id_icon")->AsInteger==2))
       {
        icon = 13;
       }
       else
       {
        icon =ZQBalans->FieldByName("id_icon")->AsInteger;
       }


       BuildTreeNode(ZQBalans->FieldByName("code_eqp")->AsInteger,
                     ZQBalans->FieldByName("id_p_eqp")->AsInteger,
                     icon,
                     ZQBalans->FieldByName("type_eqp")->AsInteger,
                     ZQBalans->FieldByName("id_voltage")->AsInteger,
                     ZQBalans->FieldByName("name")->AsString);
      }
     ZQBalans->Next();
    }
    ZQBalans->Close();
   //
   //tGroupTree->Items->EndUpdate();
   tGroupTree->FullExpand();
}
//---------------------------------------------------------------------------
void TfBalans::BuildTreeRoot(int code_eqp,int code_eqp_p,int id_icon,int type_eqp,int id_voltage,AnsiString name)
{
// TTreeNode *Node1;
 for (int j=0;j<=tGroupTree->Items->Count-1;j++)
  {
   if((tGroupTree->Items->Item[j]->StateIndex==code_eqp_p)&&(tGroupTree->Items->Item[j]->ImageIndex==0))
//       (PTreeNodeData(tGroupTree->Items->Item[j]->Data)->line_no==0))
    {
     Node1=tGroupTree->Items->AddChild(tGroupTree->Items->Item[j],name);
     Node1->StateIndex=code_eqp;
     Node1->ImageIndex=id_icon;
     Node1->SelectedIndex=id_icon;

     FullTreeNodesMap[code_eqp]=Node1;

     PBalTreeNodeData NodeData= new TBalTreeNodeData;
     NodeData->type_eqp=type_eqp;
     NodeData->id_voltage=id_voltage;
     Node1->Data=NodeData;
     NodeDataList->Add(NodeData);
     break;
    }
  }
}
//---------------------------------------------------------------------------
void TfBalans::BuildTreeNode(int code_eqp,int code_eqp_p,int id_icon,int type_eqp,int id_voltage,AnsiString name)
{
// TTreeNode *Node1;
 for (int j=0;j<=tGroupTree->Items->Count-1;j++)
  {
   if((tGroupTree->Items->Item[j]->StateIndex==code_eqp_p)&&(tGroupTree->Items->Item[j]->ImageIndex!=0))

    {
     Node1=tGroupTree->Items->AddChild(tGroupTree->Items->Item[j],name);
     Node1->StateIndex=code_eqp;
     Node1->ImageIndex=id_icon;
     Node1->SelectedIndex=id_icon;

     FullTreeNodesMap[code_eqp]=Node1;

     PBalTreeNodeData NodeData= new TBalTreeNodeData;
     NodeData->type_eqp=type_eqp;
     NodeData->id_voltage=id_voltage;
     Node1->Data=NodeData;
     NodeDataList->Add(NodeData);
     break;
    }
  }
}

//---------------------------------------------------------------------------
void TfBalans::ShowTrees(void)
{
  EqpEdit->abonent_id=ResId;
  EqpEdit->is_res=true;
  EqpEdit->LastDate=TDate(0);

//  sqlstr=" select gt.id_tree,tr.name,gt.code_eqp from eqm_tree_tbl AS tr,bal_grp_tree_tbl as gt \
//  where tr.id = gt.id_tree and gt.lvl=1 and gt.mmgg = :mmgg order by name";

  sqlstr=" select distinct gt.id_tree,tr.name from eqm_tree_tbl AS tr join bal_grp_tree_tmp as gt \
  on(tr.id = gt.id_tree) and gt.lvl=1 and gt.mmgg = :mmgg and tr.id_client = :res %seltree order by name";

  ZQBalans2->Sql->Clear();
  ZQBalans2->Sql->Add(sqlstr);
  ZQBalans2->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQBalans2->ParamByName("res")->AsInteger=ResId;  // не берем точки учета абонентов  

 if (cbTreeSelect->ItemIndex >0)
    ZQBalans2->MacroByName("seltree")->AsString = " and gt.id_tree = "+IntToStr(TreesMap[cbTreeSelect->ItemIndex]);
 else
    ZQBalans2->MacroByName("seltree")->AsString ="";


   try
   {
   ZQBalans2->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans2->Close();
    return;
   }

   tGroupTree->Items->BeginUpdate();
   tGroupTree->Items->Clear();

   FullTreeNodesMap.erase(FullTreeNodesMap.begin(),FullTreeNodesMap.end());

   for(int i=1;i<=ZQBalans2->RecordCount;i++)
   {

    BuildTree(ZQBalans2->FieldByName("id_tree")->AsInteger,ZQBalans2->FieldByName("name")->AsString,true);
    ZQBalans2->Next();
   }
   ZQBalans2->Close();
   tGroupTree->Items->EndUpdate();


}
//---------------------------------------------------------------
void __fastcall TfBalans::btGoClick(TObject *Sender)
{

 tGroupTree->Items->Clear();
 for (int i=0;i<NodeDataList->Count;i++)
 {
 delete (NodeDataList->Items[i]);
 }
 NodeDataList->Clear();
 FullTreeNodesMap.erase(FullTreeNodesMap.begin(),FullTreeNodesMap.end());

 AnsiString sqlstr="select code_eqp from bal_grp_tree_tbl where  mmgg = :mmgg and id_bal = :res limit 1;";
 ZQBalans->Close();
 ZQBalans->Sql->Clear();
 ZQBalans->Sql->Add(sqlstr);
 ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;
 ZQBalans->ParamByName("res")->AsInteger=ResId;

 try
  {
   ZQBalans->Open();
  }
 catch(...)
  {
   ShowMessage("Ошибка SQL :"+sqlstr);
   ZQBalans->Close();
   return;
  }
  if (ZQBalans->RecordCount==0)
  {
   ShowMessage("Данные за указанный период отсудствуют.");
   ZQBalans->Close();
   return;
  }
 ZQBalans->Close();


  sqlstr="select bal_setabon_fun(:res, :mmgg);";
  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQBalans->ParamByName("res")->AsInteger =ResId;

  try
  {
   ZQBalans->ExecSql();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка. "+e.Message.SubString(8,200));
   return;
  }


 ShowTrees();

 btBalans->Enabled=false;
 btBalansM->Enabled=false; 
 btRep2->Enabled=false;
 btRep3->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::DateTimePickerChange(TObject *Sender)
{
  Word Year, Month,Day;
  DecodeDate(DateTimePicker->Date, Year, Month, Day);
  mmgg=EncodeDate(Year, Month,1);

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btRebyildClick(TObject *Sender)
{
 if (MessageDlg("Переформировать ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
 return;


  AnsiString sqlstr="select bal_check_sw_fun ( :mmgg::::date, (:mmgg::::date +'1 month'::::interval)::::date ) as rr;";

  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;

  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

   if (ZQBalans->FieldByName("rr")->AsInteger !=0 )
   {
    ShowMessage("Найдены ошибки в журнале подключений! Строки с ошибками выделены.");


    TWinControl *Owner = NULL;
    // Если такое окно есть - активизируем и выходим
    TfConnSwitch* fConnSwitch;

    fConnSwitch=new TfConnSwitch(this);
    fConnSwitch->ShowAs("Переключения");
    fConnSwitch->ID="Переключения";

    fConnSwitch->check_mode=1;
    fConnSwitch->ShowData(mmgg,IncMonth( mmgg,1));
    return;

   }


 sqlstr="select bal_start_fun(:tree, :mmgg);";
 ZQBalans->Close();
 ZQBalans->Sql->Clear();
 ZQBalans->Sql->Add(sqlstr);
 ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;

 if (cbTreeSelect->ItemIndex >0)
    ZQBalans->ParamByName("tree")->AsInteger =TreesMap[cbTreeSelect->ItemIndex];
 else
    ZQBalans->ParamByName("tree")->Clear();


 try
  {
//   ZQBalans->ExecSql();
   ZQBalans->Open();
  }
/*
 catch(...)
  {
   ShowMessage("Ошибка при формировании данных пофидерного анализа");
   ZQBalans->Transaction->Rollback();
   return;
  }
*/
 catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка при формировании данных пофидерного анализа. "+e.Message.SubString(8,200));
//   ZQBalans->Transaction->Rollback();
   return;
  }

  if (ZQBalans->Fields->Fields[0]->AsInteger ==-1)
  {
   ShowMessage("Обнаружены ошибки в структуре схемы.");
   ShowErrGrid();
   return;
  }
  else
  {
    if (ZQBalans->Fields->Fields[0]->AsInteger ==1)
       ShowMessage("Обработка завершена. Обнаружены абоненты без счетов.");
    else
       ShowMessage("Обработка успешно завершена. ");       
  }


//  ZQBalans->Transaction->Commit();
  ShowTrees();


}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btBalansClick(TObject *Sender)
{
//
BalansReports->ShowBalansStation(CurrNode->StateIndex,mmgg,CurrNode->Text,(PBalTreeNodeData(CurrNode->Data))->type_eqp, 0);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btRep2Click(TObject *Sender)
{
BalansReports->ShowTreeDemand(CurrNode->StateIndex,mmgg,CurrNode->Text,
(PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btRep3Click(TObject *Sender)
{
 if (slav_mode==1)
  ToolButton17Click(Sender);
 else
  BalansReports->ShowTreeLosts(CurrNode->StateIndex,mmgg,CurrNode->Text,
  (PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btCheckClick(TObject *Sender)
{

 AnsiString sqlstr="select bal_fider_check_fun( :tree);";
 ZQBalans->Close();
 ZQBalans->Sql->Clear();
 ZQBalans->Sql->Add(sqlstr);

 if (cbTreeSelect->ItemIndex >0)
    ZQBalans->ParamByName("tree")->AsInteger =TreesMap[cbTreeSelect->ItemIndex];
 else
    ZQBalans->ParamByName("tree")->Clear();

 try
  {
   ZQBalans->Open();
  }
 catch(...)
  {
   ShowMessage("Ошибка при проверке данных пофидерного анализа");
//   ZQBalans->Transaction->Rollback();
   return;
  }
  if (ZQBalans->Fields->Fields[0]->AsInteger==0)
  {ShowMessage("Проверка данных успешно выполнена");}
  else
  {
   ShowErrGrid();
  }
//  ZQBalans->Transaction->Commit();
}
//---------------------------------------------------------------------------
void __fastcall TfBalans::ErrAccept (TObject* Sender)
{
 Application->CreateForm(__classid(TfTreeForm), &fTreeForm);
 fTreeForm->ShowAs("treeform");
 fTreeForm->ShowTrees(ResId,false,WErrGrid->DBGrid->Query->FieldByName("id_p_eqp")->AsInteger);
//fTreeForm->ShowTrees(ResId,false);
 }
//--------------------------------------------------------------------


void __fastcall TfBalans::tbCollapseClick(TObject *Sender)
{
    for(int j=0;j<=tGroupTree->Items->Count-1;j++)
    {
     if (tGroupTree->Items->Item[j]->ImageIndex==0)
      {
       tGroupTree->Items->Item[j]->Collapse(false);
       //break;
      }
    }
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tbExpandClick(TObject *Sender)
{
   tGroupTree->FullExpand();
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tbPrintClick(TObject *Sender)
{
 EasyPrint->Options->TreeView->PrintLines = true;
 EasyPrint->Options->TreeView->PrintImages = true;
 EasyPrint->Options->TreeView->Numbering = false;

 EasyPrint->Header2 = fBalans->Caption;
 EasyPrint->Print (tGroupTree);

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ShowErrGrid(void)
{

   TWTQuery *QueryErr;

   QueryErr = new  TWTQuery(this);
   QueryErr->Options<< doQuickOpen;
   QueryErr->Sql->Clear();

   QueryErr->Sql->Add("select id_area,name_area,roots,code_eqp_root,name_eqp_root,id_p_eqp,name_p_eqp ");
   QueryErr->Sql->Add("from bal_fider_errors_tbl ;");
//   QueryErr->Sql->Add("where inst_station = 0 and id<>9 order by name;");

   WErrGrid = new TWTWinDBGrid(this, QueryErr,false);
   WErrGrid->SetCaption("Ошибки определения оборудования фидеров/подстанций");

   TWTQuery* Query = WErrGrid->DBGrid->Query;

   Query->Open();

  TStringList *WList=new TStringList();
 // WList->Add("id");
  TStringList *NList=new TStringList();
 // NList->Add("id");

  QueryErr->SetSQLModify("bal_fider_errors_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WErrGrid->AddColumn("name_area", "Фидер/ПС", "Фидер/Подстанция");
  Field->SetWidth(150);
  Field->SetReadOnly();
  Field = WErrGrid->AddColumn("name_eqp_root", "Оборудование", "Оборудование");
  Field->SetWidth(150);
  Field->SetReadOnly();
  Field = WErrGrid->AddColumn("name_p_eqp", "Оборудование2", "Оборудование2");
  Field->SetWidth(150);
  Field->SetReadOnly();

//  WErrGrid->DBGrid->FieldSource = WErrGrid->DBGrid->Query->GetTField("id_p_eqp");

 // WErrGrid->DBGrid->StringDest = "-1";
  WErrGrid->DBGrid->Visible = true;
  WErrGrid->DBGrid->ReadOnly=true;

//  WErrGrid->OnCloseQuery=KindClose;
  WErrGrid->DBGrid->OnAccept=ErrAccept;

  WErrGrid->ShowAs("BalErr");
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ShowData(void)
{

  AnsiString sqlstr="select bal_setabon_fun(:res, :mmgg);";
  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQBalans->ParamByName("res")->AsInteger =ResId;

  try
  {
   ZQBalans->ExecSql();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка. "+e.Message.SubString(8,200));
   return;
  }

  cbTreeSelect->Items->Clear();
  cbTreeSelect->Items->Add("Все");
  cbTreeSelect->ItemIndex=0;

  sqlstr="select id,name from eqm_tree_tbl where id_client = :res order by name;";
  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("res")->AsInteger =ResId;
  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }
  ZQBalans->First();
  for(int i=0;i<=ZQBalans->RecordCount-1;i++)
   {
    cbTreeSelect->Items->Add(ZQBalans->FieldByName("name")->AsString);
    TreesMap[i+1]=ZQBalans->FieldByName("id")->AsInteger;
    ZQBalans->Next();
   }
  ZQBalans->Close();

//  btGoClick(Sender);
  }
//---------------------------------------------------------------------------

void __fastcall TfBalans::btRep4Click(TObject *Sender)
{
BalansReports->ShowBalansSumm(mmgg);
}
//---------------------------------------------------------------------------


void __fastcall TfBalans::btNoBillClick(TObject *Sender)
{
//
  TWTQuery *QueryErr = new  TWTQuery(this);
  QueryErr->Options << doQuickOpen;

  QueryErr->Sql->Clear();
  QueryErr->Sql->Add(" \
  select distinct err.id_client, err.id_tree, err.id_parent_eqp, err.id_grp,\
  t.name, cl.id , cl.code, cl.short_name, cl.name as abon_name, eq.name_eqp as fider_name, \
  CASE WHEN cl.book = -1 THEN NULL ELSE cl.book END AS book \
  from bal_client_errors_tbl as err \
  join eqm_tree_tbl as t on (t.id=err.id_tree) \
  join clm_client_tbl as cl on (cl.id= err.id_client) \
  join clm_statecl_tbl as stcl on (stcl.id_client=cl.id ) \
  left join eqm_equipment_tbl as eq on (eq.id = err.id_grp) \
  where err.mmgg = :mmgg \
  and cl.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and cl.idk_work not in (0,99) and coalesce(cl.id_state,0) not in (50,99) \
  order by t.name, cl.code  ;" );

  QueryErr->ParamByName("mmgg")->AsDateTime=mmgg;

  WNoBillGrid = new TWTWinDBGrid(this, QueryErr,false);
  WNoBillGrid->SetCaption("Абоненты без счетов");

  TWTQuery* Query = WNoBillGrid->DBGrid->Query;
  Query->Open();

  TStringList *WList=new TStringList();
//  WList->Add("id");
  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("bal_client_errors_tbl",WList,NList,false,false,false);
  TWTField *Field;

//  Field = WGrid->AddColumn("book", "Книга", "Книга");
  Field = WNoBillGrid->AddColumn("code", "Код", "Код");
  Field = WNoBillGrid->AddColumn("abon_name", "Абонент", "Абонент");
  Field = WNoBillGrid->AddColumn("name", "Ветка", "Ветка схемы РЕС");
  Field = WNoBillGrid->AddColumn("fider_name", "Фидер/ПС", "Фидер или ПС, к которой подключен абонент");

  WNoBillGrid->DBGrid->Visible = true;
  WNoBillGrid->DBGrid->ReadOnly=true;

  TWTToolBar* tb=WNoBillGrid->DBGrid->ToolBar;
  TWTToolButton* btn=tb->AddButton("print", "Печать", NoBillToXL);


  WNoBillGrid->DBGrid->OnAccept=NoBillAccept;
  WNoBillGrid->ShowAs("Нет счетов");
}
//---------------------------------------------------------------------------
void __fastcall TfBalans::NoBillAccept (TObject* Sender)
{
  TfCliBill *WGrid;
  WGrid = new TfCliBill(Application->MainForm, WNoBillGrid->DBGrid->Query,WNoBillGrid->DBGrid->Query->FieldByName("id")->AsInteger);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::NoBillToXL(TObject *Sender)
{
 BalansReports->NoBillToXL(mmgg);
}
//---------------------------------------------------------------------------
void __fastcall TfBalans::btExcellClick(TObject *Sender)
{
// BalansReports->FidersToXL(0,mmgg);
  Application->CreateForm(__classid(TfFiderCheck), &fFiderCheck);
  fFiderCheck->mmgg = mmgg;
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btConectedClick(TObject *Sender)
{
//        
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btBalansMClick(TObject *Sender)
{
 BalansReports->ShowBalansStation(CurrNode->StateIndex,mmgg,CurrNode->Text,(PBalTreeNodeData(CurrNode->Data))->type_eqp, 1);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tbSwitchClick(TObject *Sender)
{
/*
  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild("Переключатели", Owner)) {
    return;
  }

  TWTQuery *QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select * from bal_connector_tbl order by name; ");

  TfConnectorList *ConnectorList = new TfConnectorList(this, QueryAdr,false,"Переключатели", true);
  ConnectorList->SetCaption("Переключатели");

  ConnectorList->ShowAs("Переключатели");
*/
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tbReconnectClick(TObject *Sender)
{

  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild("Переключения", Owner)) {
    return;
  }

  TfConnSwitch* fConnSwitch=new TfConnSwitch(this);

  fConnSwitch->ShowAs("Переключения");

  fConnSwitch->ID="Переключения";

  fConnSwitch->ShowData();

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btIndicRebuildClick(TObject *Sender)
{
 if (MessageDlg("Пересчитать потребление на учетах РЕС ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
 return;

 AnsiString sqlstr="select bal_demand_start_fun(:tree, :mmgg);";
 ZQBalans->Close();
 ZQBalans->Sql->Clear();
 ZQBalans->Sql->Add(sqlstr);
 ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;

 if (cbTreeSelect->ItemIndex >0)
    ZQBalans->ParamByName("tree")->AsInteger =TreesMap[cbTreeSelect->ItemIndex];
 else
    ZQBalans->ParamByName("tree")->Clear();


 try
  {
   ZQBalans->Open();
  }
 catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка при формировании данных пофидерного анализа. "+e.Message.SubString(8,200));
//   ZQBalans->Transaction->Rollback();
   return;
  }

  ShowTrees();  
//  ZQBalans->Transaction->Commit();

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btBalansPSClick(TObject *Sender)
{
 if(CurrNode!=NULL)
   if (CurrNode->ImageIndex!=0)
     BalansReports->BalansPS_XL(CurrNode->StateIndex,mmgg,CurrNode->Text,
     (PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage);
   else
     BalansReports->BalansPS_XL(0,mmgg,"", 0,0);
 else
   BalansReports->BalansPS_XL(0,mmgg,"", 0,0);

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tbFindClick(TObject *Sender)
{
FindDialog1->Tag=0; //Начало поиска
FindDialog1->Execute();
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::FindDialog1Close(TObject *Sender)
{
  FindDialog1->Tag=0;
  SerchStr="";
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::FindDialog1Find(TObject *Sender)
{
  TTreeNode *FindNode;
  AnsiString regular;

  // FindDialog1->Tag как счетчик поисков
  if ((FindDialog1->Tag==0)||(SerchStr!=FindDialog1->FindText))  //Начало поиска
  {
    SerchStr=FindDialog1->FindText;

    if (FindDialog1->Options.Contains(frMatchCase)) regular = "~'";
    else regular = "~*'";

    sqlstr="select code_eqp as id from bal_grp_tree_tmp as eq  \
    where type_eqp in (8, 15) and name "+regular+FindDialog1->FindText+"'";

    sqlstr=sqlstr+"  order by name;";

    ZQBalans->Close();
    ZQBalans->Sql->Clear();
    ZQBalans->Sql->Add(sqlstr);

    try
     {
      ZQBalans->Open();
     }
    catch(...)
    {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZQBalans->Close();
      return;
    }

    if (ZQBalans->RecordCount>0)
     {
      ZQBalans->First();

      FindNode=FullTreeNodesMap[ZQBalans->FieldByName("id")->AsInteger];
      if (FindNode!=NULL)
      {
       FindNode->Selected=true;
       FindDialog1->Tag=1;
      }
     }
    else
      ShowMessage("Значение не найдено!");
    //ZQTree->Close();
  }
  else //Продолжение
  {
   if (FindDialog1->Tag < ZQBalans->RecordCount) // не последняя запись
   {
     ZQBalans->Next();
     FindNode=FullTreeNodesMap[ZQBalans->FieldByName("id")->AsInteger];

     if (FindNode!=NULL)
     {
      FindNode->Selected=true;
      FindDialog1->Tag++;
     }
   }
   else
      ShowMessage("Больше нет значений!");
  }

}
//---------------------------------------------------------------------------


void __fastcall TfBalans::miUpClick(TObject *Sender)
{
  int eqp =0;
  int abon = ResId;
  if( (PBalTreeNodeData(CurrNode->Data))->type_eqp!=3)
  {
    sqlstr="select tt.code_eqp, a.id_client from eqm_compens_station_inst_tbl as i join eqm_eqp_tree_tbl as tt on (tt.code_eqp = i.code_eqp)  \
    join eqm_area_tbl as a on (a.code_eqp = i.code_eqp_inst) \
    where  i.code_eqp_inst = :code order by tt.lvl limit 1 ;";

    ZQBalans->Close();
    ZQBalans->Sql->Clear();
    ZQBalans->Sql->Add(sqlstr);

    ZQBalans->ParamByName("code")->AsInteger=CurrNode->StateIndex;

    try
     {
      ZQBalans->Open();
     }
    catch(...)
    {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZQBalans->Close();
      return;
    }

    if (ZQBalans->RecordCount>0)
    {
      ZQBalans->First();
      eqp =ZQBalans->FieldByName("code_eqp")->AsInteger;
      abon = ZQBalans->FieldByName("id_client")->AsInteger;
    }
  }
  else
  {
   eqp = CurrNode->StateIndex;
  }

  Application->CreateForm(__classid(TfTreeForm), &fTreeForm);
  fTreeForm->ShowAs("treeform");
  fTreeForm->ShowTrees(abon,false,eqp);

}
//---------------------------------------------------------------------------
#define WinName "Показания"
void __fastcall TfBalans::miIndicationClick(TObject *Sender)
{
  TWinControl *Owner = this;
  TWTQuery *QueryInd;

  if (MainForm->ShowMDIChild(WinName, Owner)) {
    return ;
  }
  QueryInd = new  TWTQuery(this);
  QueryInd->Options << doQuickOpen;
  QueryInd->Sql->Clear();
  QueryInd->Sql->Add("select a.*,c.id as id_cl,c.short_name from acm_headindication_tbl a,clm_client_tbl c where " );
  QueryInd->Sql->Add("c.id=a.id_client and a.id_client=:pid_client order by id_doc" );
  QueryInd->ParamByName("pid_client")->AsInteger=ResId;
  QueryInd->Open();

   TfResDem *WGrid;
   WGrid = new TfResDem(Application->MainForm, QueryInd,ResId);

   if(CurrNode==NULL) return;

   if (((PBalTreeNodeData(CurrNode->Data))->type_eqp==15) || ((PBalTreeNodeData(CurrNode->Data))->type_eqp==8))
   {
    WGrid->NewIndication(CurrNode->StateIndex,DateTimePicker->Date);
   }
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton6Click(TObject *Sender)
{
  TWinControl *Owner = this;
  TWTQuery *QueryInd;

  if (MainForm->ShowMDIChild(WinName, Owner)) {
    //return NULL;
  }
  QueryInd = new  TWTQuery(this);
  QueryInd->Options << doQuickOpen;
  QueryInd->Sql->Clear();
  QueryInd->Sql->Add("select a.*,c.id as id_cl,c.short_name from acm_headindication_tbl a,clm_client_tbl c where " );
  QueryInd->Sql->Add("c.id=a.id_client and a.id_client=:pid_client order by id_doc" );
  QueryInd->ParamByName("pid_client")->AsInteger=ResId;
  QueryInd->Open();

   TfResDem *WGrid;
   WGrid = new TfResDem(Application->MainForm, QueryInd,ResId);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::TreePopupMenuPopup(TObject *Sender)
{
     N2->Enabled = btBalans->Enabled;
     N3->Enabled = btBalansM->Enabled;
     N4->Enabled =btRep2->Enabled;
     N5->Enabled =btRep3->Enabled;
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton7Click(TObject *Sender)
{
  BalansReports->ReconnectDemandXL(mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::Excell1Click(TObject *Sender)
{
BalansReports->ShowDemandXL(CurrNode->StateIndex,mmgg,CurrNode->Text,
(PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage,0);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::btSwitchRebuildClick(TObject *Sender)
{
 if (MessageDlg("Пересчитать информацию о переключениях ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
 return;


  AnsiString sqlstr="select bal_check_sw_fun ( :mmgg::::date, (:mmgg::::date +'1 month'::::interval)::::date ) as rr;";

  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;

  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

   if (ZQBalans->FieldByName("rr")->AsInteger !=0 )
   {
    ShowMessage("Найдены ошибки в журнале подключений! Строки с ошибками выделены.");


    TWinControl *Owner = NULL;
    // Если такое окно есть - активизируем и выходим
    TfConnSwitch* fConnSwitch;

    fConnSwitch=new TfConnSwitch(this);
    fConnSwitch->ShowAs("Переключения");
    fConnSwitch->ID="Переключения";

    fConnSwitch->check_mode=1;
    fConnSwitch->ShowData(mmgg,IncMonth( mmgg,1));
    return;

   }

 sqlstr="select bal_grp_tree_connect_fun(:res, :mmgg);";
 ZQBalans->Close();
 ZQBalans->Sql->Clear();
 ZQBalans->Sql->Add(sqlstr);
 ZQBalans->ParamByName("mmgg")->AsDateTime=mmgg;

 ZQBalans->ParamByName("res")->AsInteger =ResId;

 try
  {
   ZQBalans->Open();
  }
 catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка при формировании данных пофидерного анализа. "+e.Message.SubString(8,200));
//   ZQBalans->Transaction->Rollback();
   return;
  }

//  ZQBalans->Transaction->Commit();
  ShowTrees();

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton3Click(TObject *Sender)
{
 if(CurrNode!=NULL)
 {
   if ((PBalTreeNodeData(CurrNode->Data))->type_eqp == 15)
      BalansReports->BalansMidPoint_XL(CurrNode->StateIndex,mmgg,CurrNode->Text);
   else
      BalansReports->BalansMidPoint_XL(0,mmgg,"");
 }
 else
   BalansReports->BalansMidPoint_XL(0,mmgg,"");

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::tbFizAbonClick(TObject *Sender)
{
  BalansReports->FizAbonInfo(mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton9Click(TObject *Sender)
{
  BalansReports->StationReconnectInfo(0,mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::N8Click(TObject *Sender)
{
BalansReports->ShowDemandXL(CurrNode->StateIndex,mmgg,CurrNode->Text,
(PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage,1);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton11Click(TObject *Sender)
{
  BalansReports->ConnectedToRoot(mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton13Click(TObject *Sender)
{
  BalansReports->Losts04(mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton15Click(TObject *Sender)
{
  BalansReports->LostSummary(mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::sbAbonClick(TObject *Sender)
{
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

  //WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
  WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;
  WAbonGrid->Query->Filter = "flag_balance = 1";
  WAbonGrid->Query->Filtered=true;
}
//---------------------------------------------------------------------------
void __fastcall TfBalans::AbonAccept (TObject* Sender)
{
  if (ResId!=WAbonGrid->Query->FieldByName("id")->AsInteger)
  {
   ResId=WAbonGrid->Query->FieldByName("id")->AsInteger;
   edAbonName->Text=WAbonGrid->Query->FieldByName("short_name")->AsString;
   edAbonCode->Text=WAbonGrid->Query->FieldByName("code")->AsString;
   ResName=WAbonGrid->Query->FieldByName("name")->AsString;

   BalansReports->ResId=ResId;
   BalansReports->ResName=ResName;
   Caption="Пофидерный анализ "+ResName;

   ShowData();
  }
}
//---------------------------------------------------------------------------

void __fastcall TfBalans::ToolButton17Click(TObject *Sender)
{
 if(CurrNode!=NULL)

  if (CurrNode->ImageIndex!=0)
   BalansReports->ShowLostsXL(CurrNode->StateIndex,mmgg,CurrNode->Text,
   (PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage,0);
  else
   BalansReports->ShowLostsXL(0,mmgg,"Загальный",0,0,0);  
 else
  BalansReports->ShowLostsXL(0,mmgg,"Загальный",0,0,0);

}
//---------------------------------------------------------------------------

void __fastcall TfBalans::N5Click(TObject *Sender)
{
  BalansReports->ShowTreeLosts(CurrNode->StateIndex,mmgg,CurrNode->Text,
  (PBalTreeNodeData(CurrNode->Data))->type_eqp,(PBalTreeNodeData(CurrNode->Data))->id_voltage);
}
//---------------------------------------------------------------------------

