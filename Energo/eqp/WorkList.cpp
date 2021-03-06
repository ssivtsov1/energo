//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "WorkList.h"
//#include "ftree.h"
#include "Main.h"
#include "SysUser.h"
#include "xlcClasses.hpp"
#include "xlReport.hpp"

__fastcall TfWorkList::TfWorkList(TComponent* AOwner,int client, int point) : TWTDoc(AOwner)

//__fastcall TfWorkList::TfWorkList(TWinControl *owner, TWTQuery *query,bool IsMDI,
//           int client, int point):TWTWinDBGrid(owner,query,IsMDI)
{
  id_point = point;
  id_client = client;
  id_type = 0;

  TWTPanel* PWorks=MainPanel->InsertPanel(200,true,MainForm->Height/2);

   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;

   Query2->Sql->Clear();

   if (id_point==0)
   {
     Query2->Sql->Add("select * from clm_works_tbl where id_client = :client order by dt_work,id_point; " );
     Query2->ParamByName("client")->AsInteger=id_client;
   }
   else
   {
     Query2->Sql->Add("select * from clm_works_tbl where id_point = :point order by dt_work,id_point; " );
     Query2->ParamByName("point")->AsInteger=id_point;
   }

   DBGrWorks=new TWTDBGrid(PWorks, Query2);

   qWorkList = DBGrWorks->Query;
   DBGrWorks->OnKeyPress = NULL;

   //DBGrWorks->SetReadOnly(false);
   DBGrWorks->SetReadOnly(CheckLevel("������ �����")==0);
   PWorks->Params->AddGrid(DBGrWorks, true)->ID="Works";

//  qTaxList->ParamByName("all")->AsInteger=1;

//  qTaxList->AddLookupField("Name_pref","id_pref","aci_pref_tbl","name","id");

//  if(read_only)
//  {
//     DBGrTax->SetReadOnly(true);
//  }

//  qWorkList->Open();

//  DBGrid->ReadOnly= ( CheckLevel("������ �����")==0 );

//  TWTQuery* Query = qWorkList;

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
 // NList->Add("id");
//  NList->Add("link");

  TWTField *Field;

  TWTQuery* qPoint=new TWTQuery(this);
  qPoint->Sql->Add(" select distinct p.id, p.name_eqp , adr.adr::::varchar from eqm_tree_tbl as tr \
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
    join eqm_equipment_tbl as p on (ttr.code_eqp = p.id ) \
    join eqm_meter_point_h as pm on (pm.id_point = p.id ) \
    left join adv_address_tbl as adr on (adr.id = p.id_addres ) \
    left join    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 where dt_e is null ) as use on (use.code_eqp = p.id) \
    where coalesce (use.id_client, tr.id_client) = :client and  type_eqp = 12  order by name_eqp; " );

  qPoint->ParamByName("client")->AsInteger = id_client;

  qPoint->Open();

  TWTQuery* qType=new TWTQuery(this);
  qType->Sql->Add("select * from cli_works_tbl order by ident " );
  qType->Open();

  qPosition=new TWTQuery(this);
  qPosition->Sql->Add("select id,represent_name from clm_position_tbl where id_client = syi_resid_fun() order by represent_name; " );
  qPosition->Open();

  qWorkList->AddLookupField("POINT", "id_point", qPoint, "name_eqp","id");
  qWorkList->AddLookupField("TYPE", "id_type", qType, "name","id");
//  Query->AddLookupField("TYPE", "id_type", "cli_works_tbl", "name","id");
  qWorkList->AddLookupField("position", "id_position", qPosition, "represent_name","id");

//  if (point==0)
  qWorkList->AddLookupField("ADRESS", "id_point", qPoint, "adr","id");

  qWorkList->Open();

  qWorkList->SetSQLModify("clm_works_tbl",WList,NList,true,true,true);

  Field = DBGrWorks->AddColumn("POINT", "����� �����", "����� �����");
  Field->SetWidth(130);
  Field->Column->DropDownRows = 15;
  Field->Field->Required=true;

  if (point==0)
  {
   Field = DBGrWorks->AddColumn("ADRESS", "������ ��", "������ ����� �����");
   Field->SetWidth(160);
   Field->SetReadOnly();
  }

  Field = DBGrWorks->AddColumn("TYPE", "��� ������", "��� ������");
  Field->SetWidth(140);
  Field->Field->Required=true;
//  Field->SetReadOnly();
  Field = DBGrWorks->AddColumn("dt_work", "���� ������", "���� ������");
  Field->Field->Required=true;
  Field->Field->OnSetText = ValidateDate;
//  Field->SetReadOnly();
  Field = DBGrWorks->AddColumn("POSITION", "�����������", "�����������");
  Field->SetWidth(140);
//  Field->SetReadOnly();

  Field = DBGrWorks->AddColumn("act_num", "� ����", "� ����");
  //Field->Field->Required=true;
  Field->OnChange=OnChangeAct;
  Field->SetWidth(80);

  Field = DBGrWorks->AddColumn("requirement_text", "���������� ���������� ����", "���������� ���������� ����");
//   DBGrWorks->Columns->Items[5]->PickList->Add("�������� ���������� ��������� �����������㳿");
  Field->Column->ButtonStyle= cbsAuto;
  Field->Column->PickList->Add("�������� ���������� ��������� �����������㳿");
  Field->Column->PickList->Add("�������� ���������� �������������� ������");
  Field->Column->PickList->Add("���������� �������� �����������㳿 � �������� ����, ����������� �� ������������");
  Field->Column->PickList->Add("����������� �� ���������� �� ��� ����� ����� �� ���������� ����������");
  Field->Column->PickList->Add("ϳ��������� ���� ��� ������������");
  Field->Column->PickList->Add("������� �������� �����������㳿 � ��'���� � ������������ ������ ����������");
  Field->Column->PickList->Add("������� ������ �� ���������� ��");
  Field->Column->PickList->Add("���������� ������ ������������ ������� ����� ��������� ���������");
  Field->Column->PickList->Add("������� ������.������ ����� �� ������ ����� � ��.������� �� ����� 2.5");
  Field->IsFixedVariables = false;

  Field->SetWidth(200);
  Field->SetReadOnly(false);
  Field = DBGrWorks->AddColumn("requirement_date", "���� ����������", "���� ���������� ����������");
  Field->Field->OnSetText = ValidateDate;
  Field = DBGrWorks->AddColumn("requirement_ok_date", "���� ����������", "���� ���������� ����������");
  Field->Field->OnSetText = ValidateDate;
//  Field->SetReadOnly();
  Field = DBGrWorks->AddColumn("next_work_date", "���� ����.������", "���� ��������� ������");
  Field->Field->OnSetText = ValidateDate;  
  Field = DBGrWorks->AddColumn("comment", "����.", "����������");
  Field->SetWidth(200);
//  Field->SetReadOnly();

  TWTPanel* PName=MainPanel->InsertPanel(30,true,25); // (X,bool,Y) X,Y min size panel
  TFont* F=new TFont();
  F->Size=12;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
/*
  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption="�������� ���������";
//  BtnRebuild->OnClick=LastIndicRebuild;
  BtnRebuild->Width=100;
  BtnRebuild->Top=2;
//  BtnRebuild->Left=400;
//  BtnRebuild->Enabled= !read_only;

  PName->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
*/  
  PName->Params->AddText("����������� ���������",100,F,Classes::taCenter,true)->ID="NameGrp";
//========================================-===============------------------=-=-===-=-=-=--=

   PIndic=MainPanel->InsertPanel(200,true,200);

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options.Clear();

   Query3->Sql->Clear();
   /*
   Query3->Sql->Add("  select mp.id_point, mp.id_meter, eqm.num_eqp, im.type, e.name as energy, z.name as zone, im.carry, ind.value \
     from eqm_meter_point_h as mp \
     join eqm_equipment_h as eqm on (eqm.id =mp.id_meter) \
     join eqm_meter_h as m on (m.code_eqp=mp.id_meter ) \
     join eqi_meter_tbl as im on (im.id = m.id_type_eqp) \
     join eqd_meter_energy_h as me on (me.code_eqp = mp.id_meter) \
     join eqd_meter_zone_h as mz on (mz.code_eqp = mp.id_meter) \
     join eqk_energy_tbl as e on (e.id = me.kind_energy) \
     join eqk_zone_tbl as z on (z.id = mz.zone) \
     left join (select * from clm_work_indications_tbl where id_work = :id )as ind on (ind.id_meter = mp.id_meter and ind.kind_energy = me.kind_energy and ind.id_zone = mz.zone) \
     where eqm.dt_b <= :dt_work and (eqm.dt_e is null or eqm.dt_e>:dt_work)  \
     and m.dt_b <= :dt_work and (m.dt_e is null or m.dt_e>:dt_work)  \
     and me.dt_b <= :dt_work and (me.dt_e is null or me.dt_e>:dt_work)  \
     and mz.dt_b <= :dt_work and (mz.dt_e is null or mz.dt_e>:dt_work)  \
     and mp.dt_b <= :dt_work and (mp.dt_e is null or mp.dt_e>:dt_work)  \
     and mp.id_point = :id_point;   " );
*/
/*
   Query3->Sql->Add("  select i.id, w.id as link,  i.id_point, i.id_meter, i.num_eqp, im.type, e.name as energy, z.name as zone, im.carry, i.value, li.date_end, li.value as last_value \
     from clm_work_indications_tbl as i \
     join clm_works_tbl as w on (w.id = i.id_work) \
     join eqi_meter_tbl as im on (im.id = i.id_type) \
     join eqk_energy_tbl as e on (e.id = i.kind_energy) \
     join eqk_zone_tbl as z on (z.id = i.id_zone) \
     left join \
     ( select h.date_end, ind.id_meter, ind.id_zone, ind.kind_energy, ind.num_eqp, ind.value \
       from acm_headindication_tbl as h join acd_indication_tbl as ind on (ind.id_doc = h.id_doc) \
       where h.id_client = :client \
       and h.idk_document = 310 \
       order by ind.id_meter, ind.id_zone, ind.kind_energy, ind.num_eqp \
     ) as li on (li.id_meter = i.id_meter and li.id_zone = i.id_zone and li.kind_energy = i.kind_energy and li.num_eqp = i.num_eqp \
                        and li.date_end  = (select max(h2.date_end) from acm_headindication_tbl as h2 \
                        where h2.id_client = :client and h2.date_end <= w.dt_work and h2.idk_document = 310) \
      ) \
     where w.id_client = :client  \
     order by i.num_eqp " );


//       and h.idk_document = 310

//     ) as li on (li.id_meter = i.id_meter and li.id_zone = i.id_zone and li.kind_energy = i.kind_energy and li.num_eqp = i.num_eqp \
//                        and li.date_end  = (select max(h2.date_end) from acm_headindication_tbl as h2 join acd_indication_tbl as i2 on (i2.id_doc = h2.id_doc) \
//                        where h2.id_client = :client and h2.date_end <= w.dt_work and i2.id_meter = i.id_meter and i2.num_eqp = i.num_eqp) \
*/

   Query3->Sql->Add("  select i.id, w.id as link,  i.id_point, i.id_meter, i.num_eqp, im.type, e.name as energy, z.name as zone, im.carry, i.value, li.dat_ind as date_end, li.value as last_value, m.dt_control \
     from clm_work_indications_tbl as i \
     join clm_works_tbl as w on (w.id = i.id_work) \
     join eqi_meter_tbl as im on (im.id = i.id_type) \
     join eqk_energy_tbl as e on (e.id = i.kind_energy) \
     join eqk_zone_tbl as z on (z.id = i.id_zone) \
     left join acd_indication_tbl as li on (li.id = i.id_indic) \
     left join eqm_meter_tbl as m on (m.code_eqp = i.id_meter) \
     where w.id_client = :client  \
     order by i.num_eqp " );


   Query3->ParamByName("client")->AsInteger = id_client;

   DBGrIndic=new TWTDBGrid(PIndic, Query3);

   qIndications = DBGrIndic->Query;

//   DBGrIndic->SetReadOnly(false);
   DBGrIndic->SetReadOnly(CheckLevel("������ �����")==0);
   PIndic->Params->AddGrid(DBGrIndic, true)->ID="Indications";

//   if(read_only)
//   {
//     DBGrTaxLines->SetReadOnly(true);
//   }


  WList=new TStringList();
  WList->Add("id");

  NList=new TStringList();
  NList->Add("link");
  NList->Add("id_meter");
  NList->Add("id_point");
  NList->Add("num_eqp");
  NList->Add("type");
  NList->Add("energy");
  NList->Add("zone");
  NList->Add("carry");
  NList->Add("date_end");
  NList->Add("last_value");
  NList->Add("dt_control");

  qIndications->IndexFieldNames = "num_eqp";

  qIndications->LinkFields = "id=link";
  qIndications->MasterSource = DBGrWorks->DataSource;

//  qIndications->DataSource = DBGrWorks->DataSource;
//  qIndications->Prepare();
  qIndications->Open();

  qIndications->SetSQLModify("clm_work_indications_tbl",WList,NList,true,false,false);

   TWTField *Fieldh;
  Fieldh = DBGrIndic->AddColumn("num_eqp", "����� ��������", "����� ��������");
  Fieldh->SetReadOnly();
  Fieldh = DBGrIndic->AddColumn("type", "���", "���");
  Fieldh->SetReadOnly();

  Fieldh = DBGrIndic->AddColumn("carry", "�����������", "�����������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrIndic->AddColumn("energy", "��� �������", "��� �������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrIndic->AddColumn("zone", "����", "����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrIndic->AddColumn("dt_control", "���� �������", "���� �������");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(70);
  
  Fieldh = DBGrIndic->AddColumn("last_value", "���.���������", "���.���������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrIndic->AddColumn("date_end", "���� �����.", "���� �����.");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(70);

  Fieldh = DBGrIndic->AddColumn("value", "���������", "���������");
    DBGrIndic->Columns->Items[8]->Color=0x00aaffff;

//  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();

  DBGrIndic->Visible=true;

  TWTToolButton* btn=DBGrWorks->ToolBar->AddButton("print", "������", PrintWorkList);
  TWTToolButton* btn2=DBGrWorks->ToolBar->AddButton("history", "���������", WorkDelList);

//  DBGrWorks->DBGrid->OnAccept=EqpAccept;
  DBGrWorks->AfterInsert=AfterIns;
  DBGrWorks->AfterPost=WorkAfterPost;
  DBGrWorks->BeforePost=WorkBeforePost;

//   DBGrid->Query->BeforePost=AfterScroll;


  DBGrWorks->Visible = true;

  qIndications->AfterInsert=CancelInsert;
  ActiveControl = DBGrWorks;
//  WorksScroll(DBGrWorks);
}
//---------------------------------------------------------------------------
__fastcall TfWorkList::~TfWorkList()
{
  qWorkList->Close();
};
//---------------------------------------------------------------------------
void _fastcall  TfWorkList::OnChangeAct(TWTField *Sender)
{
  TWTQuery *Table = (TWTQuery *)Sender->Field->DataSet;

  if (( Table->FieldByName("act_num")->AsString =="")&&
  (( Table->FieldByName("id_type")->AsInteger ==1)||
   ( Table->FieldByName("id_type")->AsInteger ==2)||
   ( Table->FieldByName("id_type")->AsInteger ==3)||
   ( Table->FieldByName("id_type")->AsInteger ==4)))

  {
    ShowMessage("��������� ����� ���� !");
    Table->Cancel();
    return;
  }

}
//---------------------------------------------------------------------------
void _fastcall TfWorkList::AfterIns(TWTDBGrid *Sender)
{
  if (Sender->DataSource->DataSet->Eof)
  {
    if (Sender->DataSource->DataSet->Bof!=true)
      Sender->DataSource->DataSet->Cancel();
  }

  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_client;
  if (id_point!=0)
     Sender->DataSource->DataSet->FieldByName("id_point")->AsInteger=id_point;

  if (id_type!=0 )
  {
    Sender->DataSource->DataSet->FieldByName("id_type")->AsInteger=id_type;
  }

 // Sender->DataSource->DataSet->FieldByName("dt_work")->AsDateTime = Now();
};
//---------------------------------------------------------------------------
void _fastcall TfWorkList::WorksScroll(TWTDBGrid *Sender)
{
/*
  if (qWorkList->RecordCount==0) return;
  if (qWorkList->FieldByName("id_point")->AsInteger==0) return;

   qIndications->Close();
   if(DBGrIndic!=NULL ) delete DBGrIndic;

   DBGrIndic=new TWTDBGrid(PIndic, qIndications);

   qIndications = DBGrIndic->Query;

   DBGrIndic->SetReadOnly(false);
   PIndic->Params->AddGrid(DBGrIndic, true)->ID="Indications";


   qIndications->ParamByName("id_point")->AsInteger =  qWorkList->FieldByName("id_point")->AsInteger;
   qIndications->ParamByName("dt_work")->AsDateTime =  qWorkList->FieldByName("dt_work")->AsDateTime;
   qIndications->ParamByName("id")->AsInteger =  qWorkList->FieldByName("id")->AsInteger;
   qIndications->Open();
  // qIndications->Refresh();

   TWTField *Fieldh;
   Fieldh = DBGrIndic->AddColumn("num_eqp", "����� ��������", "����� ��������");
   Fieldh->SetReadOnly();
   Fieldh = DBGrIndic->AddColumn("type", "���", "���");
   Fieldh->SetReadOnly();
   Fieldh = DBGrIndic->AddColumn("carry", "�����������", "�����������");
   Fieldh->SetReadOnly();
   Fieldh = DBGrIndic->AddColumn("energy", "��� �������", "��� �������");
   Fieldh->SetReadOnly();
   Fieldh = DBGrIndic->AddColumn("zone", "����", "����");
   Fieldh->SetReadOnly();
   Fieldh = DBGrIndic->AddColumn("value", "���������", "���������");

   DBGrIndic->Visible=true;
   DBGrIndic->Parent =PIndic;
   PIndic->Refresh();
   qIndications->AfterInsert=CancelInsert;
*/
};

//---------------------------------------------------------------------------

void __fastcall TfWorkList::WorkAfterPost(TWTDBGrid *Sender)
{
// qIndications->Refresh();
   DBGrIndic->DataSource->DataSet->Refresh();
   DBGrIndic->Refresh();
}
//--------------------------------------------------------------------
void __fastcall TfWorkList::WorkBeforePost(TWTDBGrid *Sender)
{
  if (( qWorkList->FieldByName("act_num")->AsString =="")&&
  (( qWorkList->FieldByName("id_type")->AsInteger ==1)||
   ( qWorkList->FieldByName("id_type")->AsInteger ==2)||
   ( qWorkList->FieldByName("id_type")->AsInteger ==3)||
   ( qWorkList->FieldByName("id_type")->AsInteger ==4)))
  {
//    ShowMessage("��������� ����� ���� !");
    throw Exception("��������� ����� ���� !");
    //qWorkList->Cancel();
    return;
  }
}
//--------------------------------------------------------------------

void __fastcall TfWorkList::PrintWorkList(TObject *Sender)
{
 TxlReport* xlReport = new TxlReport(this);

  xlReport->XLSTemplate = "XL\\work_list.xls";

  TxlDataSource *Dsr;

  TxlReportParam *Param;
  xlReport->DataSources->Clear();
  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = qWorkList;
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

  xlReport->ParamByName["linfo"]->Value =info;

  xlReport->Report();

  delete xlReport;
}
//---------------------------------------------------------------------------
void __fastcall TfWorkList::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfWorkList::WorkDelList(TObject *Sender)
{
//
  TWinControl *Owner = this ;
  // ���� ����� ���� ���� - ������������ � �������
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild("������� ������� �����", Owner)) {
    return;
  }

  TfWorkHistory *fWorkHistory = new TfWorkHistory(this,id_client,id_point);
  fWorkHistory->Abon_name = Abon_name;
  fWorkHistory->Point_name = Point_name;

  fWorkHistory->SetCaption("������� ������� �����");
  fWorkHistory->ShowAs("������� ������� �����");

  fWorkHistory->MainPanel->ParamByID("Indications")->Control->SetFocus();
  fWorkHistory->MainPanel->ParamByID("Works")->Control->SetFocus();

}

//---------------------------------------------------------------------------
void __fastcall TfWorkList::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};


//---------------------------------------------------------------------------

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++ history +++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

__fastcall TfWorkHistory::TfWorkHistory(TComponent* AOwner,int client, int point) : TWTDoc(AOwner)
{
  id_point = point;
  id_client = client;
  id_type = 0;

  TWTPanel* PWorks=MainPanel->InsertPanel(200,true,MainForm->Height/2);

   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;

   Query2->Sql->Clear();

   if (id_point==0)
   {
     Query2->Sql->Add("select w.*, eq.name_eqp as POINT, adr.adr::::varchar as ADRESS, i.name as TYPE, p.represent_name as position " );
     Query2->Sql->Add("     from clm_works_del as w " );
     Query2->Sql->Add("     left join eqm_equipment_h as eq on (w.id_point = eq.id and eq.dt_b < w.dt_del and coalesce(eq.dt_e,w.dt_del )>= w.dt_del ) " );
     Query2->Sql->Add("     left join adv_address_tbl as adr on (adr.id = eq.id_addres ) " );
     Query2->Sql->Add("     left join clm_position_tbl as p on (p.id = w.id_position ) " );
     Query2->Sql->Add("     left join cli_works_tbl as i on (i.id = w.id_type) " );
     Query2->Sql->Add("   where w.id_client = :client order by w.dt_del,w.dt_work,w.id_point; " );
     Query2->ParamByName("client")->AsInteger=id_client;
   }
   else
   {
     Query2->Sql->Add("select w.*, eq.name_eqp as POINT, adr.adr::::varchar as ADRESS, i.name as TYPE, p.represent_name as position " );
     Query2->Sql->Add("     from clm_works_del as w " );
     Query2->Sql->Add("     left join eqm_equipment_h as eq on (w.id_point = eq.id and eq.dt_b < w.dt_del and coalesce(eq.dt_e,w.dt_del )>= w.dt_del ) " );
     Query2->Sql->Add("     left join adv_address_tbl as adr on (adr.id = eq.id_addres ) " );
     Query2->Sql->Add("     left join clm_position_tbl as p on (p.id = w.id_position ) " );
     Query2->Sql->Add("     left join cli_works_tbl as i on (i.id = w.id_type) " );
     Query2->Sql->Add("     where id_point = :point order by w.dt_del,w.dt_work,w.id_point; " );
     Query2->ParamByName("point")->AsInteger=id_point;
   }

   DBGrWorks=new TWTDBGrid(PWorks, Query2);

   qWorkList = DBGrWorks->Query;

   DBGrWorks->SetReadOnly(true);
   PWorks->Params->AddGrid(DBGrWorks, true)->ID="Works";

  TWTQuery* Query = qWorkList;
/*
  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
*/
  TWTField *Field;
/*
  Query->AddLookupField("POINT", "id_point", qPoint, "name_eqp","id");
  Query->AddLookupField("TYPE", "id_type", qType, "name","id");
//  Query->AddLookupField("TYPE", "id_type", "cli_works_tbl", "name","id");
  Query->AddLookupField("position", "id_position", qPosition, "represent_name","id");

//  if (point==0)
  Query->AddLookupField("ADRESS", "id_point", qPoint, "adr","id");
*/
  Query->Open();

//  Query->SetSQLModify("clm_works_tbl",WList,NList,true,true,true);

  Field = DBGrWorks->AddColumn("dt_del", "���� ����.", "���� ��������");
  Field = DBGrWorks->AddColumn("oper", "����.", "��������");
  Field->AddFixedVariable("1", "������");
  Field->AddFixedVariable("2","���.");

  Field = DBGrWorks->AddColumn("POINT", "����� �����", "����� �����");
  Field->SetWidth(130);

  if (point==0)
  {
   Field = DBGrWorks->AddColumn("ADRESS", "������ ��", "������ ����� �����");
   Field->SetWidth(160);
  }

  Field = DBGrWorks->AddColumn("TYPE", "��� ������", "��� ������");
  Field->SetWidth(140);

  Field = DBGrWorks->AddColumn("dt_work", "���� ������", "���� ������");

  Field = DBGrWorks->AddColumn("POSITION", "�����������", "�����������");
  Field->SetWidth(140);

  Field = DBGrWorks->AddColumn("act_num", "� ����", "� ����");
  Field->SetWidth(80);

  Field = DBGrWorks->AddColumn("requirement_text", "���������� ���������� ����", "���������� ���������� ����");
  Field->SetWidth(200);

  Field = DBGrWorks->AddColumn("requirement_date", "���� ����������", "���� ���������� ����������");
  Field = DBGrWorks->AddColumn("requirement_ok_date", "���� ����������", "���� ���������� ����������");

  Field = DBGrWorks->AddColumn("next_work_date", "���� ����.������", "���� ��������� ������");
  Field = DBGrWorks->AddColumn("comment", "����.", "����������");
  Field->SetWidth(200);


  TWTPanel* PName=MainPanel->InsertPanel(30,true,25); // (X,bool,Y) X,Y min size panel
  TFont* F=new TFont();
  F->Size=12;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PName->Params->AddText("����������� ���������",100,F,Classes::taCenter,true)->ID="NameGrp";

//========================================-===============------------------=-=-===-=-=-=--=

   PIndic=MainPanel->InsertPanel(200,true,200);

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options.Clear();

   Query3->Sql->Clear();

   Query3->Sql->Add("  select distinct i.id, w.id as link,  i.id_point, i.id_meter, i.num_eqp, im.type, e.name as energy, z.name as zone, im.carry, i.value , i.dt_del, i.oper \
     from clm_work_indications_del as i \
     join clm_works_del as w on (w.id = i.id_work) \
     join eqi_meter_tbl as im on (im.id = i.id_type) \
     join eqk_energy_tbl as e on (e.id = i.kind_energy) \
     join eqk_zone_tbl as z on (z.id = i.id_zone) \
     where w.id_client = :client order by i.num_eqp " );

   Query3->ParamByName("client")->AsInteger = id_client;

   DBGrIndic=new TWTDBGrid(PIndic, Query3);

   qIndications = DBGrIndic->Query;

   DBGrIndic->SetReadOnly(true);

   PIndic->Params->AddGrid(DBGrIndic, true)->ID="Indications";

/*
  WList=new TStringList();
  WList->Add("id");

  NList=new TStringList();
  NList->Add("link");
  NList->Add("id_meter");
  NList->Add("id_point");
  NList->Add("num_eqp");
  NList->Add("type");
  NList->Add("energy");
  NList->Add("zone");
  NList->Add("carry");
*/
  qIndications->IndexFieldNames = "num_eqp";
  qIndications->LinkFields = "id=link";

  qIndications->MasterSource = DBGrWorks->DataSource;


  qIndications->Open();

  //qIndications->SetSQLModify("clm_work_indications_tbl",WList,NList,true,false,false);

  TWTField *Fieldh;

  Fieldh = DBGrIndic->AddColumn("dt_del", "���� ����.", "���� ��������");
  Fieldh = DBGrIndic->AddColumn("oper", "����.", "��������");
  Fieldh->AddFixedVariable("1", "������");
  Fieldh->AddFixedVariable("2", "���."  );

  Fieldh = DBGrIndic->AddColumn("num_eqp", "����� ��������", "����� ��������");

  Fieldh = DBGrIndic->AddColumn("type", "���", "���");

  Fieldh = DBGrIndic->AddColumn("carry", "�����������", "�����������");

  Fieldh = DBGrIndic->AddColumn("energy", "��� �������", "��� �������");

  Fieldh = DBGrIndic->AddColumn("zone", "����", "����");

  Fieldh = DBGrIndic->AddColumn("value", "���������", "���������");

  DBGrIndic->Visible=true;

//  DBGrWorks->AfterInsert=AfterIns;
//  DBGrWorks->AfterPost=WorkAfterPost;

  DBGrWorks->Visible = true;

//  qIndications->AfterInsert=CancelInsert;
  ActiveControl = DBGrWorks;
//  WorksScroll(DBGrWorks);
}
//---------------------------------------------------------------------------
__fastcall TfWorkHistory::~TfWorkHistory()
{
  qWorkList->Close();
};
//---------------------------------------------------------------------------
