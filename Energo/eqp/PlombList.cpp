//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "PlombList.h"

#include "Main.h"
#include "SysUser.h"
#include "xlcClasses.hpp"
#include "xlReport.hpp"
#include "PlombInsert.h"

#pragma package(smart_init)

__fastcall TfPlombList::TfPlombList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int client, int point):TWTWinDBGrid(owner,query,IsMDI)
{
  id_point = point;
  id_client = client;
  id_type = 0;

  DBGrid->ReadOnly= ( CheckLevel("������ �����")==0 );
  DBGrid->OnKeyPress = NULL;     //����������, ����� ������� ����� �� ������  Field->Column->PickList ...


  TWTQuery* Query = DBGrid->Query;

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  //NList->Add("id");

  TWTField *Field;

  TWTQuery* qPoint=new TWTQuery(this);
  qPoint->Sql->Add(" select distinct p.id, p.name_eqp , adr.adr::::varchar from eqm_tree_tbl as tr \
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
    join eqm_equipment_tbl as p on (ttr.code_eqp = p.id ) \
    join eqm_meter_point_h as pm on (pm.id_point = p.id ) \
    left join adv_address_tbl as adr on (adr.id = p.id_addres ) \
    left join    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1  where dt_e is null ) as use on (use.code_eqp = p.id) \
    where coalesce (use.id_client, tr.id_client) = :client and  type_eqp = 12 order by name_eqp; " );

  qPoint->ParamByName("client")->AsInteger = id_client;

  qPoint->Open();

  TWTQuery* qType=new TWTQuery(this);
  qType->Sql->Add("select * from cli_plomb_type_tbl order by ident " );
  qType->Open();

  qPosition=new TWTQuery(this);
  qPosition->Sql->Add("select id,represent_name from clm_position_tbl where id_client = syi_resid_fun() order by represent_name; " );
  qPosition->Open();
/*
  qPositionOff=new TWTQuery(this);
  qPositionOff->Sql->Add("select id,represent_name from clm_position_tbl where id_client = syi_resid_fun() order by represent_name; " );
  qPositionOff->Open();
*/

  Query->AddLookupField("POINT", "id_point", qPoint, "name_eqp","id");
  Query->AddLookupField("TYPE", "id_type", qType, "name","id");
//  Query->AddLookupField("TYPE", "id_type", "cli_works_tbl", "name","id");
  Query->AddLookupField("position", "id_position", qPosition, "represent_name","id");
  Query->AddLookupField("position_off", "id_position_off", qPosition, "represent_name","id");

//  if (point==0)
  Query->AddLookupField("ADRESS", "id_point", qPoint, "adr","id");

  Query->Open();

  Query->SetSQLModify("clm_plomb_tbl",WList,NList,true,true,true);

  Field = AddColumn("POINT", "����� �����", "����� �����");
  Field->Column->DropDownRows = 16;
  Field->SetWidth(130);

  if (point==0)
  {
   Field = AddColumn("ADRESS", "������ ��", "������ ����� �����");
   Field->SetWidth(160);
   Field->SetReadOnly();   
  }
  Field = AddColumn("object_name", "����� ���������", "����� ���������");
  Field->SetWidth(140);
  Field->Column->ButtonStyle= cbsAuto;
  Field->Column->PickList->Add("������ ������ ���������");
  Field->Column->PickList->Add("����� ���������");
  Field->Column->PickList->Add("������ ������ � ����� ���������");
  Field->Column->PickList->Add("������� ��������� ����������");
  Field->Column->PickList->Add("�������� ������� �������������� ������");
  Field->Column->PickList->Add("�������������� ������");
  Field->Column->PickList->Add("���� ���� �����");
  Field->Column->PickList->Add("������ ������ ���� �����");
  Field->Column->PickList->Add("������ ������ ���� �����");
  Field->Column->PickList->Add("���� ����� �������� ������ ���������");
  Field->Column->PickList->Add("������ ����� �������� ������ ���������");
  Field->Column->DropDownRows = 9;
  Field->IsFixedVariables = false;

  Field = AddColumn("TYPE", "��� ������", "��� ������");
  Field->Column->DropDownRows = 16;
  Field->SetWidth(140);

  Field = AddColumn("plomb_num", "����� ������", "����� ������");
  Field->SetWidth(140);

  Field = AddColumn("dt_b", "���� ���������", "���� ���������");
  Field = AddColumn("POSITION", "���������", "������ ���������");
  Field->SetWidth(140);
  Field->Field->OnSetText = ValidateDate;

  Field = AddColumn("plomb_owner", "������������ �������", "������������ �������");
  Field->SetWidth(150);
  Field->Column->ButtonStyle= cbsAuto;
  Field->Column->PickList->Add("���");
  Field->Column->PickList->Add("���");
  Field->Column->PickList->Add("���");
  Field->Column->PickList->Add("�����-�������� ���������");
  Field->Column->PickList->Add("���� �������");
  Field->IsFixedVariables = false;

  Field = AddColumn("dt_e", "���� ������", "���� ������");
  Field->Field->OnSetText = ValidateDate;
  Field->OnChange = OnPlombRemove;

  Field = AddColumn("POSITION_OFF", "����", "������ ����");
  Field->SetWidth(140);

  Field = AddColumn("comment", "����.", "����������");
  Field->SetWidth(200);


  DBGrid->OnAccept=EqpAccept;
//  DBGrid->AfterInsert=AfterIns;
  DBGrid->BeforeInsert=PlombNewGr;
  DBGrid->Visible = true;


  btAll=DBGrid->ToolBar->AddButton("AddCond", "������ ������", ShowAll);
  btNow=DBGrid->ToolBar->AddButton("RemCond", "������������� � ������ ������", ShowNow);

  TWTToolBar* tb=DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
//    if ( btn->ID=="Full")
//       tb->Buttons[i]->OnClick=SwitchEdit;
    if ( btn->ID=="NewRecord")
       {
//       if (IsInsert)
         tb->Buttons[i]->OnClick=PlombNew;
//       else
//         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
     {
//     if (IsInsert)
//       {
//        OldDelEqp=tb->Buttons[i]->OnClick;
        tb->Buttons[i]->OnClick=DelPlomb;
//       }
//     else
//       tb->Buttons[i]->OnClick=NULL;
     }
   }

  btAll->Visible=false;

  btn=DBGrid->ToolBar->AddButton("print", "������", PrintPlombList);
}
//---------------------------------------------------------------------------
__fastcall TfPlombList::~TfPlombList()
{
  DBGrid->Query->Close();
};

//--------------------------------------------------
void __fastcall TfPlombList::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};

//---------------------------------------------------------------------------
void _fastcall TfPlombList::AfterIns(TWTDBGrid *Sender)
{
//  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_client;
//  Sender->DataSource->DataSet->FieldByName("id_point")->AsInteger=id_point;
/*  if (id_type!=0 )
  {
    Sender->DataSource->DataSet->FieldByName("id_type")->AsInteger=id_type;
  }
*/
};
//---------------------------------------------------------------------------
void __fastcall TfPlombList::EqpAccept (TObject* Sender)
{
/*
  if (DBGrid->Query->FieldByName("id")->AsInteger ==0) return;

  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (((TWTMainForm*)MainForm)->ShowMDIChild("�������", Owner)) {
    return;
  }
  WHistoryEdit=new TfHistoryEdit(this,DBGrid->Query->FieldByName("id")->AsInteger,
  DBGrid->Query->FieldByName("type_eqp")->AsInteger,
  DBGrid->Query->FieldByName("name_table")->AsString,
  DBGrid->Query->FieldByName("name_table_ind")->AsString);

  WHistoryEdit->ShowAs("������� ���������");
  WHistoryEdit->SetCaption("������� ���������");

  WHistoryEdit->ID="�������";

  WHistoryEdit->ShowData();
*/
}
//--------------------------------------------------------------------

void __fastcall TfPlombList::DelPlomb(TObject* Sender)
{
  int current_point=DBGrid->Query->FieldByName("id_point")->AsInteger;
  int id_plomb=DBGrid->Query->FieldByName("id")->AsInteger;

  if (MessageDlg("��� ��������, ��� ������ �����, \n ����� ������� ���� ������, � �� ������� ������. \n ��� ��� ������ ������� ������ ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQWork = new TWTQuery(this);
  ZQWork->Options<< doQuickOpen;

  ZQWork->RequestLive=false;
  ZQWork->CachedUpdates=false;


   AnsiString sqlstr="delete from clm_plomb_tbl where id = :id_plomb ;";
   ZQWork->Sql->Clear();
   ZQWork->Sql->Add(sqlstr);

   ZQWork->ParamByName("id_plomb")->AsInteger=id_plomb;

   try
   {
    ZQWork->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQWork->Close();
    delete ZQWork;
    return;
   }

//   ShowMessage("��������� ��������� �������");
   delete ZQWork;

   DBGrid->Query->Refresh();
}
//---------------------------------------------------------------------------
void _fastcall TfPlombList::PlombNewGr(TWTDBGrid *Sender)
{
  DBGrid->Query->Cancel();
  PlombNew(Sender);
};
//---------------------------------------------------------------------------
void __fastcall TfPlombList::PlombNew(TObject* Sender)
{

  Application->CreateForm(__classid(TfPlombNew), &fPlombNew);
  fPlombNew->id_client = id_client;
  fPlombNew->id_point = id_point;
  fPlombNew->ShowNew();
  fPlombNew->qParent = DBGrid->Query;
}

//--------------------------------------------------------------------
void __fastcall TfPlombList::ShowAll(TObject* Sender)
{
//
 btNow->Visible=true;
 btAll->Visible=false;
 DBGrid->Query->Filtered=false;
 DBGrid->Query->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TfPlombList::ShowNow(TObject* Sender)
{
//
 btNow->Visible=false;
 btAll->Visible=true;

 if (DBGrid->Query->FindField("dt_e")!=NULL)
     {
      try
      {
       DBGrid->Query->Filter="dt_e is null ";
      }
      catch(...)
      {
       DBGrid->Query->Filter="dt_e is null ";
       DBGrid->Query->Filtered=true;
       DBGrid->Query->Filtered=false;
      };

      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     }
}
//---------------------------------------------------------------------------
void __fastcall TfPlombList::PrintPlombList(TObject *Sender)
{
 TxlReport* xlReport = new TxlReport(this);

  xlReport->XLSTemplate = "XL\\plomb_list.xls";

  TxlDataSource *Dsr;

  TxlReportParam *Param;
  xlReport->DataSources->Clear();
  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = DBGrid->Query;
  Dsr->Alias =  "ZQXLReps";
  Dsr->Range = "Range";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lnow";
  Param=xlReport->Params->Add();
  Param->Name="labon";
  Param=xlReport->Params->Add();
  Param->Name="linfo";



  TWTQuery* ZQuery = new TWTQuery(this);
  ZQuery->Options.Clear();
  ZQuery->Options<< doQuickOpen;
  ZQuery->RequestLive=false;

  AnsiString sqlstr="select id,name from clm_client_tbl where id = syi_resid_fun();";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  try
   {
    ZQuery->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }
   if (ZQuery->RecordCount>0)
   {
    ZQuery->First();
//    ResId=ZQBalans->FieldByName("id")->AsInteger;
    ResName=ZQuery->FieldByName("name")->AsString;

//    Caption="���������� ������ "+ResName;
   }
  ZQuery->Close();


  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReport->ParamByName["lres"]->Value = ResName;
  xlReport->ParamByName["labon"]->Value = Abon_name;

  AnsiString info = "";

  if (id_point!=0) info = "����� ����� "+ Point_name;

  if ( btAll->Visible )
  {
    info = info+ " (����������� �� ����� ������)";
  }

  xlReport->ParamByName["linfo"]->Value =info;


  xlReport->Report();

  delete xlReport;
}
//---------------------------------------------------------------------------
void _fastcall  TfPlombList::OnPlombRemove(TWTField  *Sender)
{
   TDateTime dt_e = Sender->Field->AsDateTime;
   if (dt_e == TDateTime(0) ) return;

   int current_point=DBGrid->Query->FieldByName("id_point")->AsInteger;
   int id_plomb=DBGrid->Query->FieldByName("id")->AsInteger;
   int id_type =DBGrid->Query->FieldByName("id_type")->AsInteger;

   if ((id_type ==10)||(id_type ==11)||(id_type ==16))
   {

    TWTQuery * ZQWork = new TWTQuery(this);
    ZQWork->Options.Clear();
    ZQWork->Options<< doQuickOpen;
    ZQWork->RequestLive=false;


    TWTQuery * ZMeterQuery = new TWTQuery(this);
    ZMeterQuery->Options.Clear();
    ZMeterQuery->Options<< doQuickOpen;
    ZMeterQuery->RequestLive=false;


    AnsiString sqlstr2="select count(*)::::int as cnt from clm_plomb_tbl where id_point = :id_point and id_type in (10,11,16) and (dt_e is not null) and id <> :id; ";

    ZQWork->Sql->Clear();
    ZQWork->Sql->Add(sqlstr2);
    ZQWork->ParamByName("id_point")->AsInteger=current_point;
    ZQWork->ParamByName("id")->AsInteger=id_plomb;

    try
    {
      ZQWork->Open();
    }
    catch(...)
    {
      ShowMessage("������ SQL :"+sqlstr2);
      ZQWork->Close();
      return;
    }
    ZQWork->First();
    int cnt = ZQWork->FieldByName("cnt")->AsInteger;
    ZQWork->Close();
    ZQWork->Fields->Clear();

    if (cnt>0) return;

    if(MessageDlg("� ����� ����� �������� �������� ������. \n ����� �������� �������� �� ����������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
    {

     AnsiString sqlstr3=" select id_meter from eqm_meter_point_h where id_point = :id_point and dt_e is null and dt_b <= :dt; ";
     ZMeterQuery->Sql->Clear();
     ZMeterQuery->Sql->Add(sqlstr3);
     ZMeterQuery->ParamByName("id_point")->AsInteger=current_point;
     ZMeterQuery->ParamByName("dt")->AsDateTime=dt_e;

     try
     {
       ZMeterQuery->Open();
     }
     catch(...)
     {
       ShowMessage("������ SQL :"+sqlstr2);
       ZMeterQuery->Close();
       return;
     }


     for(int i=1;i<=ZMeterQuery->RecordCount;i++)
     {
      int id_meter =  ZMeterQuery->FieldByName("id_meter")->AsInteger;

      int operation=((TMainForm*)(Application->MainForm))->PrepareChange(ZQWork,1,0,id_meter,0,1,dt_e);
      if (operation ==-1)  return;

      AnsiString sqlstr="update eqm_meter_tbl set magnet = 0 where code_eqp = :id_meter; ";
      ZQWork->Sql->Clear();
      ZQWork->Sql->Add(sqlstr);

      ZQWork->ParamByName("id_meter")->AsInteger=id_meter;

      try
      {
        ZQWork->ExecSql();
      }
      catch(...)
      {
        ShowMessage("������ SQL :"+sqlstr);
        ZQWork->Close();
        return;
      }

      ZMeterQuery->Next();
     }

     ZMeterQuery->Close();

    }
   } 

};
