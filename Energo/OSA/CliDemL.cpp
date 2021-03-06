//---------------------------------------------------------------------------

//#include <vcl.h>
#include <vcl.h>
#pragma hdrstop

#include "CliDemL.h"
#include "Main.h"
#include "fDemandPrint.h"
#include "fBillPrint.h"
#include "fTaxPrint.h"
#include "fTaxCorPrint.h"
#include "CliPowerIndic.h"
#include "fBillAct.h"
#include "fEdTaxParam.h"
#include "SysUser.h"
#include "fLogin.h"

//#include "ftree.h"
//#include "fEqpBase.h"
#define WinName "������ �� �����������"
//__fastcall TfCliDem::TfCliDem(TComponent *Owner, TWTQuery *Client, int fid_clien ): TfTWTCompForm(Owner,false)
//_fastcall TfCliDem::TfCliDem(TWinControl *owner, TWTQuery *Client, int fid_clien)  : TfTWTCompForm(owner,false)
 _fastcall TfCliDem::TfCliDem(TWinControl *owner, TWTQuery *Client, int fid_clien)  : TWTDoc(owner)
{
  //TWinControl *Owner = Owner;
  /* if ( TMainForm->ShowMDIChild(WinName, Owner)) {
    return ;
  } */
    fid_cl=fid_clien;
    int lost=0;
    name_cl=Client->DataSource->DataSet->FieldByName("short_name")->AsString;

//  TZPgSqlQuery * QuerRes =new TWTQuery(Application);
  TWTQuery * QuerRes =new TWTQuery(this);
  QuerRes->Options<< doQuickOpen;
  QuerRes->RequestLive=false;
  QuerRes->CachedUpdates=false;

  QuerRes->Sql->Clear();
  QuerRes->Sql->Add("select getsysvar('kod_res') as res;");
  try
   {
    QuerRes->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL");
    QuerRes->Close();
    return;
   }
   if (QuerRes->FieldByName("res")->AsInteger ==310 )
   {
    mem_mode =true;

    boss_mode =false;
    if(CheckLevelStrong("����� ����� ����������� ��������� �� ��������������� �����������")!=0)
    {
      boss_mode=true;
    }
   }
   else
   {
    mem_mode = false;
   }
   user_changed = false;


  QuerRes->Sql->Clear();
  QuerRes->Sql->Add("select fun_mmgg() as mmgg ;");
  try
   {
    QuerRes->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL");
    QuerRes->Close();
    return;
   }

  QuerRes->First();
  mmgg = QuerRes->FieldByName("mmgg")->AsDateTime;
  QuerRes->Close();

  month_cnt = 12;
  mmgg_limit = IncMonth(mmgg,-month_cnt);


    TWTQuery* QuerC=new TWTQuery(this);
    QuerC->Sql->Add("select c.*,s.flag_hlosts, \
        CASE WHEN (coalesce(s.pre_pay_day1,0)<>0 ) THEN (s.pre_pay_day1::::varchar)||'-'||(s.pre_pay_perc1::::varchar)||'%' ELSE '' END || \
        CASE WHEN (coalesce(s.pre_pay_day2,0)<>0 ) THEN ';'||(s.pre_pay_day2::::varchar)||'-'||(s.pre_pay_perc2::::varchar)||'%' ELSE '' END || \
        CASE WHEN (coalesce(s.pre_pay_day3,0)<>0 ) THEN ';'||(s.pre_pay_day3::::varchar)||'-'||(s.pre_pay_perc3::::varchar)||'%' ELSE '' END::::varchar  as pre_pay_info \
     from clm_client_tbl c \
     left join clm_statecl_tbl  s on (c.id=s.id_client ) where c.id=:pid_client");
    QuerC->ParamByName("pid_client")->AsInteger=fid_cl;
    QuerC->Open();
    lost=QuerC->DataSource->DataSet->FieldByName("flag_hlosts")->AsInteger;
    name_cl=QuerC->DataSource->DataSet->FieldByName("short_name")->AsString;
    AnsiString pre_pay_info =QuerC->DataSource->DataSet->FieldByName("pre_pay_info")->AsString;
    TWTPanel* PHIndic=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PHIndic->Params->AddText("������ ������� "+ name_cl + "     ("+pre_pay_info+")",18,F,Classes::taCenter,false);
    QuerH=new TWTQuery(this);

    QuerH->Sql->Add("select distinct h.*,b.dt as dt_bill,('���.� '||b.reg_num::::varchar|| \
     ' �� '||b.reg_date::::varchar)::::varchar as nam_bill \
     from acm_headindication_tbl h \
     left join (select id_doc,id_client,id_ind,reg_num,reg_date,dt \
      from acm_bill_tbl where id_client=:pid_client and id_pref = 10 ) b  \
     on (b.id_ind=h.id_doc ) \
     where  h.id_client=:pid_client \
     order by h.date_end desc;");

    QuerH->ParamByName("pid_client")->AsInteger=fid_cl;
//    QuerH->ParamByName("mmgg_limit")->AsDateTime=mmgg_limit;

    QuerH->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",mmgg_limit)+"'";
    QuerH->Filtered=true;


    DBGrHInd=new TWTDBGrid(this, QuerH);
    PHIndic->Params->AddGrid(DBGrHInd, true)->ID="HIndic";
    TWTQuery* Query = DBGrHInd->Query;
    TWTQuery* QuerRep=new TWTQuery(this);
    QuerRep->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
    QuerRep->Sql->Add(" where  di.idk_document=dk.id and dk.ident='rep_dem' order by di.id " );
    QuerRep->Open();
    Query->AddLookupField("Namek_doc","idk_document",QuerRep,"name","id");
    Query->Open();

  /*
  TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc, b.reg_num||b.reg_date as nam_bil, \
   id_pref,p.name \
   from acm_bill_tbl as b,acm_headindication_tbl h,  aci_pref_tbl p \
   where p.id=b.id_pref and b.id_ind=h.id_doc \
   and h.id_client="+ToStrSQL(fid_cl));
  QuerBill->Open();
  */
  TStringList *WList=new TStringList();
  WList->Add("id_doc");

   DBGrHInd->ToolBar->AddButton("INSPECT", "����������� ������", ClientKontr);

  TStringList *NList=new TStringList();
   NList->Add("nam_bill");
   NList->Add("dt_bill");

  Query->SetSQLModify("acm_headindication_tbl",WList,NList,true,true,true);
  TWTField *Fieldh;
  Fieldh = DBGrHInd->AddColumn("Namek_doc", "��� ������", "���");
  //Field->OnChange=OnChangeKindRep;
  Fieldh->SetWidth(120);

  Fieldh = DBGrHInd->AddColumn("reg_num", "����� ������", "����� ������");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("reg_date", "���� ������", "���� ������");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("date_end", "�� ������ �����.", "���� �� ");
  //Field->OnChange=OnChangeDateRep;
  Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("nam_bill", "����", "����");
  Fieldh->SetWidth(180);

  Fieldh = DBGrHInd->AddColumn("dt_bill", "���� ������������", "���� ������������");
  Fieldh->SetWidth(120);

  Fieldh = DBGrHInd->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);

  Fieldh = DBGrHInd->AddColumn("flock", "���.", "������");
  Fieldh->AddFixedVariable("1", "^");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(20);

  Fieldh = DBGrHInd->AddColumn("id_doc", "� ", "�");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);


  DBGrHInd->BeforePost=CheckIndic;
  DBGrHInd->AfterPost=IndicAddNew;
  DBGrHInd->AfterInsert=IndicAddCl;

  TButton *BtnCalc=new TButton(this);
  BtnCalc->Caption="������";
  BtnCalc->OnClick=ClientCalcPotr;
  BtnCalc->Width=100;
  BtnCalc->Top=2;
  BtnCalc->Left=2;
   if (CheckLevel("����������� - ������ (������)")==0)
      BtnCalc->Enabled=false;
/*
  TButton *BtnKontr=new TButton(this);
  BtnKontr->Caption=" ";
  BtnKontr->OnClick=ClientKontrPotr;
  BtnKontr->Width=4;
  BtnKontr->Top=2;
  BtnKontr->Left=104;
  */

  TButton *BtnPrn=new TButton(this);
  BtnPrn->Caption="������ �����";
  BtnPrn->OnClick=ClientBillPrintP;
  BtnPrn->Width=100;
  BtnPrn->Top=2;
  BtnPrn->Left=102;
  if (CheckLevel("����������� - ������ ����� (������)")==0)
      BtnPrn->Enabled=false;
  TButton *BtnDemL=new TButton(this);
  BtnDemL->Caption="��������� ";
  BtnDemL->OnClick=BtnDemLF;
  BtnDemL->Width=100;
  BtnDemL->Top=2;
  BtnDemL->Left=204;
   if (CheckLevel("����������� - ��������� (������)")==0)
      BtnDemL->Enabled=false;



  TButton *BtnPrnTax=new TButton(this);
  BtnPrnTax->Caption="���������";
  BtnPrnTax->OnClick=ClientBillPrintT;
  BtnPrnTax->Width=100;
  BtnPrnTax->Top=2;
  BtnPrnTax->Left=308;
   if (CheckLevel("����������� - ��������� (������)")==0)
      BtnPrnTax->Enabled=false;

  TButton *BtnRCabin=new TButton(this);
  BtnRCabin->Caption="�����.�������";
  BtnRCabin->OnClick=BtnReadCabinet;
  BtnRCabin->Width=100;
  BtnRCabin->Top=2;
  BtnRCabin->Left=410;
  /* if (CheckLevel("����������� - �����. ������� (������)")==0)
      BtnRCabin->Enabled=false;
    */
    TButton *BtnCabin=new TButton(this);
  BtnCabin->Caption="�����. �������";
  BtnCabin->OnClick=BtnTrueCabinet;
  BtnCabin->Width=100;
  BtnCabin->Top=2;
  BtnCabin->Left=512;
   if (CheckLevel("����������� - �����. ������� (������)")==0)
      BtnCabin->Enabled=false;

  TButton *BtnLost=new TButton(this);
  BtnLost->Caption="������ ";
  BtnLost->OnClick=Lost;
  BtnLost->Width=100;
  BtnLost->Top=2;
  BtnLost->Left=614;
   if (CheckLevel("����������� - ������ (������)")==0)
      BtnLost->Enabled=false;


  TButton *BtnDem=new TButton(this);
  BtnDem->Caption="���.�������";
  BtnDem->OnClick=BtnDemF;
  BtnDem->Width=100;
  BtnDem->Top=2;
  BtnDem->Left=710;
   if (CheckLevel("����������� - ���.������� (������)")==0)
      BtnDem->Enabled=false;


  TButton *BtnPower=new TButton(this);
  BtnPower->Caption="�����.������.";
  BtnPower->OnClick=ClientPowerIndic;
  BtnPower->Width=100;
  BtnPower->Top=2;
  BtnPower->Left=800;
   if (CheckLevel("����������� - ����������� ������. (������)")==0)
     BtnPower->Enabled=false;

       TButton *BtnPrnDem=new TButton(this);
  BtnPrnDem->Caption="������ �����.";
  BtnPrnDem->OnClick=ClientDemandPrintP;
  BtnPrnDem->Width=100;
  BtnPrnDem->Top=2;
  BtnPrnDem->Left=900;
  if (CheckLevel("����������� - ������ �����. (������)")==0)
      BtnPrnDem->Enabled=false;

  /*TButton *BtnCheck=new TButton(this);
  BtnCheck->Caption="����������� ������.";
  BtnCheck->OnClick=ClientPowerIndic;
  BtnCheck->Width=140;
  BtnCheck->Top=2;
  BtnCheck->Left=614;
         */
  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=700;
  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  //TWTPanel* PBtnP=DocHInd->MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnCalc,false)->ID="BtnCalc";
  PBtnP->Params->AddButton(BtnDemL,false)->ID="BtnDemL";
  //PBtnP->Params->AddButton(BtnKontr,false)->ID="BtnKontr";
  PBtnP->Params->AddButton(BtnPrn,false)->ID="BtnPrn";
   PBtnP->Params->AddButton(BtnRCabin,false)->ID="BtnRCabin";
    PBtnP->Params->AddButton(BtnCabin,false)->ID="BtnCabin";
  PBtnP->Params->AddButton(BtnPrnDem,false)->ID="BtnPrnDem";
  PBtnP->Params->AddButton(BtnPrnTax,false)->ID="BtnPrnTax";
  PBtnP->Params->AddButton(BtnLost,false)->ID="BtnLost";

  PBtnP->Params->AddButton(BtnPower,false)->ID="BtnPower";
   PBtnP->Params->AddButton(BtnDem,false)->ID="BtnDem";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";

  TWTToolBar* tb=DBGrHInd->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="DelRecord")
     {
       tb->Buttons[i]->OnClick=DelIndic;
     }
   }

   

  //TWTPanel* PIndicGr=DocHInd->MainPanel->InsertPanel(200,true,200);
  TWTPanel* PIndicGr=MainPanel->InsertPanel(200,true,200);

//  TWTToolBar* tb=DBGrHInd->ToolBar;
  btn=tb->AddButton("dateinterval", "����� �������", PeriodSel);


  QuerI=new TWTQuery(this);


  QuerI->Sql->Add(" \
  select distinct i.*,e.name_eqp as name_met,mm.nm as nm,p.value as before_value, p.dat_ind as dat_prev, \
                cab.value_ind as cab_value, \
                case when cab.value_ind is not null then calc_ind_pr(cab.value_ind,p.value,i.carry) else null end as cab_dev, \
                case  when cab.value_ind is not null then calc_ind_pr(cab.value_ind,p.value,i.carry)*i.coef_comp else null end as cab_dem, \
                p_insp.value as kontrol_ind,p_insp.dt_insp, wi.value as work_ind, w.dt_work, wt.name as worktype \
     from (select  i.* from            \
           (select * from acm_headindication_tbl where id_client=:pid_client  order by id_doc ) as h  \
            join ( select  i.* from  acd_indication_tbl i where i.id_client=:pid_client order by id_doc ) \
                  as i on (h.id_doc=i.id_doc) ) as i   \
           left  join acd_indication_tbl as p  on (p.id=i.id_previndic )    \
            join eqm_equipment_h  e \
                  on (i.id_meter=e.id and i.num_eqp=e.num_eqp and i.dat_ind>=e.dt_b \
                         and (i.dat_ind<=e.dt_e or e.dt_e is null ) )      \
           left  join  eqm_meter_h  mm \
                on (i.id_meter=mm.code_eqp and \
                    ((( mm.dt_b < i.dat_ind ) and (mm.dt_e is null or mm.dt_e > i.dat_ind )) \
                     or \
                     (( mm.dt_b = i.dat_ind ) and i.id_previndic is null ) \
                     or \
                     (( mm.dt_e = i.dat_ind )and i.id_previndic is not null ) ) \
                   ) \
     left join acm_inspectstr_tbl as p_insp on (p_insp.id=i.id_inspect )    \
     left join acd_cabindication_tbl as cab on (cab.id=i.id_cabinet )    \
     left join clm_work_indications_tbl as wi on (wi.id = i.last_work_ind_id ) \
     left join clm_works_tbl as w on (w.id = wi.id_work) \
     left join cli_works_tbl as wt on (wt.id = w.id_type) \
   order by i.id_doc,i.num_eqp,i.kind_energy,i.id_zone");

  QuerI->ParamByName("pid_client")->AsInteger=fid_cl;
//  QuerI->ParamByName("mmgg_limit")->AsDateTime=mmgg_limit;

  QuerI->DefaultFilter=" i.mmgg >= '" +FormatDateTime("yyyy-mm-dd",mmgg_limit)+"'";
  QuerI->Filtered=true;


  DBGrInd=new TWTDBGrid(this, QuerI);

  PIndicGr->Params->AddText("��������� ������������ ",18,F,Classes::taCenter,false);
  PIndicGr->Params->AddGrid(DBGrInd, true)->ID="Indic";


  TWTQuery* QueryI = DBGrInd->Query;
  //QueryI->AddLookupField("name_met","id_meter","eqm_equipment_tbl","name_eqp","id");
  QueryI->AddLookupField("type_met","id_typemet","eqi_meter_tbl","type","id");
  QueryI->AddLookupField("name_energy","KIND_ENERGY","eqk_energy_tbl","name","id");
  QueryI->AddLookupField("Zone","ID_ZONE","eqk_zone_tbl","name","id"); // ����� Name
   QueryI->Open();

  TStringList *WListI=new TStringList();

  WListI->Add("id");

  TStringList *NListI=new TStringList();
  NListI->Add("before_value");
  NListI->Add("name_met");
  NListI->Add("nm");
  NListI->Add("kontrol_ind");
  NListI->Add("dt_insp");
  NListI->Add("work_ind");
  NListI->Add("dt_work");
  NListI->Add("worktype");
  NListI->Add("dat_prev");
  NListI->Add("cab_value");
  NListI->Add("cab_dev");
  NListI->Add("cab_dem");

  QueryI->SetSQLModify("acd_indication_tbl",WListI,NListI,true,true,true);
  //QueryI->IndexFieldNames = "id_doc;num_eqp";
  QueryI->IndexFieldNames = "id_doc;num_eqp;kind_energy;id_zone";
  QueryI->LinkFields = "id_doc=id_doc";
  QueryI->MasterSource = DBGrHInd->DataSource;

  TWTField *Field;


  Field = DBGrInd->AddColumn("name_met", "�������", "�������");
  Field->SetReadOnly();
  Field->SetWidth(80);

   Field = DBGrInd->AddColumn("type_met", "���", "���");
   Field->SetReadOnly();
   Field->SetWidth(100);

   Field = DBGrInd->AddColumn("carry", "����.", "�����������");
   Field->SetWidth(40);
   Field->SetReadOnly();

   Field = DBGrInd->AddColumn("num_eqp", "�����", "�����");
   Field->SetWidth(70);


  Field = DBGrInd->AddColumn("name_energy", "�������", "��� �������");
  Field->SetWidth(50);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("Zone", "����", "����");
    Field->SetWidth(50);
  Field->SetReadOnly();


  Field = DBGrInd->AddColumn("coef_comp", "�-�.��.", "����������� �������������");
  Field->SetWidth(40);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("before_value", "����������", "���������� ���������");
  Field->Column->ButtonStyle=cbsNone;
  //Field->Precision=4;
   Field->SetReadOnly();
 //
  Field = DBGrInd->AddColumn("value", "�������", "������� ���������");
  Field->OnChange=OnChangeIndic;
  //Field->Precision=4;



  Field = DBGrInd->AddColumn("value_dev", "��������", "��������");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("value_dem", "�����������", "�����������");
  Field->SetReadOnly();

 Field = DBGrInd->AddColumn("cab_value", "�� ��������", "�� ��������");
 Field->SetReadOnly();

 Field = DBGrInd->AddColumn("cab_dev", "���.����.", "���.����.");
 Field->SetReadOnly();

Field = DBGrInd->AddColumn("cab_dem", "���.����.", "���.����.");
 Field->SetReadOnly();

  //Field->Precision=4;
   Field = DBGrInd->AddColumn("kontrol_ind", "�����.�����.", "����������� ���������");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("dt_insp", "���� �����.", "���� ����� ����� ���������");
  Field->SetReadOnly();

   Field = DBGrInd->AddColumn("work_ind", "���.�����.", "������� ���������");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("dt_work", "���� ���.", "���� ������");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("worktype", "��� ���.", "��� ������");
  Field->SetWidth(100);
  Field->SetReadOnly();

 if (lost==1)  {
    Field = DBGrInd->AddColumn("hand_losts", "������", "������");
   // Field->SetReadOnly();
   };
  Field = DBGrInd->AddColumn("nm", "���. ��������", "���. ��������");
  Field->SetWidth(200);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("id_meter", "eqp", " ");
  Field->SetReadOnly();
  Field->SetWidth(80);
  DBGrInd->Visible = true;
  //QueryI->IndexFieldNames = "id_doc;num_eqp;kind_energy;id_zone";
  DBGrInd->Visible = true;
  DBGrInd->OnAccept=IndicAccept;
  DBGrInd->BeforeEdit=BefEdit;

  DBGrHInd->OnDrawColumnCell=HIndDrawColumnCell;
  DBGrInd->OnDrawColumnCell= HeadDrawColumnCell;
  SetCaption("������ �� ����������� "+name_cl+ "( "+FormatDateTime("mm.yyyy",mmgg_limit)+" - "+ FormatDateTime("mm.yyyy",mmgg)+")");
  ShowAs(WinName);
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
  MainPanel->ParamByID("Indic")->Control->SetFocus();
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
 }
#undef WinName
//----------------------------------------------------------------------------
__fastcall TfCliDem::~TfCliDem()
{
  if (user_changed)
  {
   TWTQuery * ZQuery =new TWTQuery(this);
   ZQuery->Options<< doQuickOpen;
   ZQuery->RequestLive=false;
   ZQuery->CachedUpdates=false;

   ZQuery->Sql->Clear();
   ZQuery->Sql->Add("delete from syi_sysvars_tmp where ident='id_person';");
   ZQuery->Sql->Add("update syi_sysvars_tmp  set value_ident = :user where ident='last_user';");
   ZQuery->Sql->Add("insert into syi_sysvars_tmp (id,ident,type_ident,value_ident) values (10000,'id_person','int', :person);");

   ZQuery->ParamByName("person")->AsInteger = GlobalPersonId;
   ZQuery->ParamByName("user")->AsInteger = GlobalUsrId;

   try
   {
    ZQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("������ SQL");
    ZQuery->Close();
    return;
   }

  }
  Close();
};

void __fastcall TfCliDem::PeriodSel(TObject *Sender)
{
 AnsiString new_month_cnt = InputBox("����� ������� ������", "������� ���������� ������� �� ������� ����� �������� ������ � ����������� ", IntToStr(month_cnt) );
 month_cnt =  StrToInt(new_month_cnt);
 mmgg_limit = IncMonth(mmgg,-month_cnt);

 QuerH->Filtered=false;
 QuerH->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",mmgg_limit)+"'";
 QuerH->Filtered=true;

 QuerI->Filtered=false;
 QuerI->DefaultFilter="i.mmgg >= '" +FormatDateTime("yyyy-mm-dd",mmgg_limit)+"'";
 QuerI->Filtered=true;

}
//----------------------------------------------------
void __fastcall TfCliDem::DelIndic(TObject* Sender)
{

  if (QuerH->FieldByName("flock")->AsInteger ==1)
  {
   ShowMessage("�������� ������. ���������� �������! ");
   return;
  }

  if (MessageDlg(" ������� ����� � ����������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * QDel = new TWTQuery(this);
  QDel->Options<< doQuickOpen;
  QDel->Sql->Add("delete from acm_headindication_tbl where id_doc = :id_doc; ");

  QDel->ParamByName("id_doc")->AsInteger=QuerH->FieldByName("id_doc")->AsInteger;

  try
  {
    QDel->ExecSql();
    QuerH->Refresh();
  }
 catch(EDatabaseError &e)
 {
  ShowMessage("������ ��������"+e.Message.SubString(8,200));
 }
}
//----------------------------------------------------

 void __fastcall TfCliDem::BefEdit(TWTDBGrid *Sender)
{
 TWTQuery *Table = (TWTQuery *)Sender->DataSource->DataSet;
  TWTQuery * QuerDat=new TWTQuery(this);
  QuerDat->Sql->Clear();
  int pind;
  int car,c_comp=1;
  bool c_ind=true;
  float prev_ind;
  prev_ind=0,00;
  TWTQuery* QuerTyp=new TWTQuery(this);
  QuerTyp->Sql->Add("select a.*,b.ident from acm_headindication_tbl as a left join\
           dci_document_tbl as b on a.idk_document=b.id where id_doc=:idind ");
  QuerTyp->ParamByName("idind")->AsInteger=Table->FieldByName("id_doc")->AsInteger;
  QuerTyp->Open();
  AnsiString typ=QuerTyp->DataSource->DataSet->FieldByName("ident")->AsString;


  if ( (typ=="chn_cnt") && (Table->FieldByName("id_previndic")->IsNull)&&
   ((Table->FieldByName("indic_edit_enabled")->AsInteger==0)||(Table->FieldByName("indic_edit_enabled")->IsNull))
  )
  { pind=Table->FieldByName("id")->AsInteger;
     QuerDat->Sql->Clear();
   //QuerDat->Sql->Add("delete from acd_indication_tbl where id="+ToStrSQL(pind));
   //QuerDat->ExecSql();
   //Table->CancelUpdates();
  // Table->Refresh();
  // ShowMessage("��������� ������������� ��������� � ��������������� ���������!  ");
     throw Exception("��������� ������������� ��������� � ��������������� ���������!");

  };
}
//----------------------------------------------------------------------------
#define WinName "����������� ����"
void __fastcall TfCliDem::IndicAccept(TObject *Sender)
{
//TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  /*if (ShowMDIChild(WinName, Owner)) {
    return;
  }
    */
    int id_meter=((TWTDBGrid*)Sender)->DataSource->DataSet->FieldByName("id_meter")->AsInteger;
        int id_doci=((TWTDBGrid*)Sender)->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
    TWTQuery *QuerDif=new TWTQuery(this);

    QuerDif->Sql->Clear();
     QuerDif->Sql->Add("select d.*,ke.name as name_energy, \
     kzp.name as zone_pred,kz.name as zone_n from acd_inddifzone_tbl d, \
      eqk_zone_tbl  kzp,eqk_zone_tbl  kz, eqk_energy_tbl ke \
     where id_doc=:id_doci and id_meter=:id_meteri \
      and kzp.id=d.zone_p and kz.id=d.zone and ke.id=d.kind_energy");
    QuerDif->ParamByName("id_doci")->AsInteger=id_doci;
    QuerDif->ParamByName("id_meteri")->AsInteger=id_meter;
     QuerDif->Open();
     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QuerDif);
     WGrid->SetCaption(WinName);
     TStringList *WList=new TStringList();
     WList->Add("id_doc");
     WList->Add("id_meter");
     WList->Add("kind_energy");
     WList->Add("zone_p");
     WList->Add("zone");
  TStringList *NList=new TStringList();
     NList->Add("name_energy");
     NList->Add("zone_pred");
     NList->Add("zone_n");

  QuerDif->SetSQLModify("acd_inddifzone_tbl",WList,NList,true,true,true);

  TWTField *Field;
  Field = WGrid->AddColumn("name_energy", "��� �������", "��� �������");
  Field = WGrid->AddColumn("zone_pred", "���� ��������", "���� ��������� ��������");
   Field = WGrid->AddColumn("zone_n", "���� �����", "���� �������� ������������ �����");
  Field = WGrid->AddColumn("percent", "�������", "�������");
  //Field = WGrid->AddColumn("dt_b", "���� �", "���� �");
   Field = WGrid->AddColumn("dt_e", "���� ���.����", "���� ���.����");

   WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};
#undef WinName
void _fastcall TfCliDem::IndicAddNew(TWTDBGrid *Sender) {
  int i=0;
  int id_clientp=0;
  Word yearr;
  Word yearp;
  Word monthr;
  Word monthp;
  Word dayr;
  Word dayp;
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndic= Sender;
  TWTDBGrid *GrDetIndic= DBGrInd;
  id_clientp =fid_cl;
   Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
  /// ��������� ���������
   int id_docp=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int idk_documentp=Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger;
   TDateTime reg_datep=Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime;
   TDateTime reg_date=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
  if (reg_date<reg_datep)
  { ShowMessage("���� ������ ������ ���� ����� ���������! ���������!");
     return;
  };
  DecodeDate(reg_date,yearr,monthr,dayr);
  DecodeDate(reg_datep,yearp,monthp,dayp);
  if (reg_date<reg_datep)
  { ShowMessage("���� ������ ������ ���� ����� ���������! ���������!");
     return;
  };

   if ((yearr>2099)||(yearr<2006))
  { ShowMessage("������������ ��� � ���� ������! ���������!");
     return;
  };
   if ((yearp>2099)||(yearp<2006))
  { ShowMessage("������������ ��� � ���� ����� ���������! ���������!");
     return;
  };
   int fid_doc=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int pid_client=Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger;
   reg_datep=Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime;

   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from clm_statecl_h where id_client=:pid_client \
   and mmgg_b<=:reg_datep and coalesce(mmgg_e,:reg_datep)>=:reg_datep ");
   QueryMet->ParamByName("pid_client")->AsInteger=pid_client;
   QueryMet->ParamByName("reg_datep")->AsDateTime=reg_datep;
   QueryMet->Open();
   if ((QueryMet->Eof))
   { ShowMessage ("��� ������������ �������� ������� �� ����:"+DateToStr(reg_datep));
     return;
    }
    else
    { //if (QueryMet->FieldByName("doc_dat")->AsDateTime>reg_datep)
//     {  ShowMessage (" ���� �������� ������ ���� ������:"+DateToStr(reg_datep));
//     return;
//     }
    };



   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select inp_ind("+ToStrSQL(id_docp)+") ");
   QueryMet->ExecSql();
   //GrDetIndic->DataSource->DataSet->FieldByName("before_value")->LookupDataSet->Refresh();
   GrDetIndic->DataSource->DataSet->Refresh();
   GrDetIndic->Refresh();

};

void _fastcall TfCliDem::CheckIndic(TWTDBGrid *Sender)
{
  int i=0;
  int fid_doc=0;
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndic= Sender;
  /// ��������� ���������
   fid_doc=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int idk_documentp=Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger;
   int pid_client=Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger;
   TDateTime reg_datep=Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime;
 /*
   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from clm_statecl_h where id_client=:pid_client \
   and mmgg_b<=:reg_datep and coalesce(mmgg_e,:reg_datep)>=:reg_datep ");
   QueryMet->ParamByName("pid_client")->AsInteger=pid_client;
   QueryMet->ParamByName("reg_datep")->AsDateTime=reg_datep;
   QueryMet->Open();
   if ((QueryMet->Eof))
   { ShowMessage ("��� ������������ �������� ������� �� ����:"+DateToStr(reg_datep));
     return;
    };
 */
   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from acm_headindication_tbl where id_main_ind=:pid_doc ");
   QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
   QueryMet->Open();
   if ( Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger!=370
       && Sender->DataSource->DataSet->FieldByName("id_main_ind")->AsInteger!=0
       ) Sender->DataSource->DataSet->FieldByName("id_main_ind")->Clear();

   if (!(QueryMet->Eof))
   {
      QueryMet->Sql->Clear();
      QueryMet->Sql->Add("Select * from acm_headindication_tbl where \
          id_doc=:pid_doc ");
      QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
      QueryMet->Open();
       if (!(QueryMet->Eof))
       {   if  (Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime!=
         QueryMet->FieldByName("date_end")->AsDateTime)
           { if (!Ask("�� �������� ���� ����� ���������. ��� ��������� ������ ����� �������. ���������� ?"))
                   Sender->DataSource->DataSet->Cancel();
             else
              QueryMet->Sql->Clear();
              QueryMet->Sql->Add("delete  from acm_headindication_tbl where \
                   id_main_ind=:pid_doc ");
               QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
               QueryMet->ExecSql();

           };
       };

   };
};
//------------------------------------------------------------------------------
/*
void _fastcall TfCliDem::CheckIndicStr(TWTDBGrid *Sender)
{
  int i=0;
  int fid_doc=0;
//  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndicStr= Sender;

};
*/
//-----------------------------------------------------------------------------
void _fastcall TfCliDem::IndicAddCl(TWTDBGrid *Sender) {
int i=0;
int id_clientp=0;
  if (Sender->DataSource->DataSet->Eof)
  {
    if (Sender->DataSource->DataSet->Bof!=true)
      Sender->DataSource->DataSet->Cancel();
  }

  TWTDBGrid *GrIndic= Sender;
  id_clientp =fid_cl;
  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
  Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime=Date();

    TDateTime db=((TMainForm*)(Application->MainForm))->PeriodDate(id_clientp,0);
    TDateTime de=((TMainForm*)(Application->MainForm))->PeriodDate(id_clientp,1);
    if(db==de)
      { db=BOM(db);
        de=EOM(de);
      }
     Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime=de;
}


void __fastcall TfCliDem::ClientCalcPotr(TObject *Sender)
{    TWTPanel *TDoc;
   int id_clientp=0;
   bool check=false;
   TWTDBGrid *HIndic= DBGrHInd;
   id_clientp =fid_cl;

  TWTQuery *QueryMet=new TWTQuery(this);
  TWTQuery *QueryErr=new TWTQuery(this);

  int id_docp=HIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  if (id_docp==0)  {
    ShowMessage("��� ��������� ��� �������");
    return;
    };
      QueryErr->Sql->Clear();
     QueryErr->Params->Clear();
     QueryErr->Options<<doQuickOpen;
   QueryErr->Sql->Add("select distinct i.*,  cab.value_ind as cab_value,    \
  p_insp.value as kontrol_ind,p_insp.dt_insp, wi.value as work_ind,w.dt_work  \
  from (select i.* from (select * from acm_headindication_tbl where id_doc=:pid_doc order by id_doc ) as h   \
  join ( select i.* from acd_indication_tbl i where i.id_doc=:pid_doc order by id_doc ) as i on (h.id_doc=i.id_doc) ) as i  \
  left join acm_inspectstr_tbl as p_insp on (p_insp.id=i.id_inspect )   \
  left join acd_cabindication_tbl as cab on (cab.id=i.id_cabinet )  \
  left join clm_work_indications_tbl as wi on (wi.id = i.last_work_ind_id )\
  left join clm_works_tbl as w on (w.id = wi.id_work) left join cli_works_tbl as wt on (wt.id = w.id_type)   \
 WHERE i.id_doc=:pid_doc  and (((i.value<coalesce(p_insp.value,0) and (p_insp.dt_insp+interval '1 month')::::date>=i.dat_ind) \
    or (i.value<coalesce( wi.value,0) and (w.dt_work+interval '1 month')::::date>=i.dat_ind ))) \
  order by i.id_doc,i.num_eqp,i.kind_energy,i.id_zone   ");

   QueryErr->ParamByName("pid_doc")->AsInteger=id_docp;
    // QueryErr->->ParamByName("pmmgg")->AsDateTime=mmgg;
     QueryErr->Open();
   if (!(QueryErr->Eof))
       {ShowMessage(" ������� �������� ! ��� ���������! ������  \
            � ����� <<���.�����.>> �� <<�����.�����>> ������ ����� ��� � ����� <<�������>>. \
             �� ������� ��������, ���� �������� ��� ��������, ��� ������� ������� ����� 0, \
              � ����� �������� ������� ��������� ������������ ������� ������ ���������! \
              � ������� ����������� ���� �������� ����� ��������!");
    /*{ShowMessage(" ����� �������� �������  �������� �.�. �� 29.09.2017 ������� ���� �� ����������� ��������� ������,\n  \
            �� �� ����� ��������� ������� � ���, ���� ��������� ����������������, \n \
            ������������ ��� ����������� ������� ��� ��������� ���������,\n \
            � ����� <<���.�����.>> �� <<�����.�����>> ������ ����� ��� � ����� <<�������>> ");
      QueryErr->Sql->Clear();
     QueryErr->Params->Clear();
     QueryErr->Options<<doQuickOpen;
     QueryErr->Sql->Add("delete from acm_bill_tbl where  id_client="+ToStrSQL(id_clientp)+" and  id_ind= "+ToStrSQL(id_docp));
     QueryErr->ExecSql();
        HIndic->DataSource->DataSet->Refresh();
     return;  */
    };
 try {
  if   ((DBGrInd->DataSource->DataSet->State==dsInsert) ||
        (DBGrInd->DataSource->DataSet->State==dsEdit))
   DBGrInd->DataSource->DataSet->Post();
   ShortDateFormat="yyyy-mm-dd";
   TDateTime d_e=HIndic->DataSource->DataSet->FieldByName("date_end")->AsDateTime;
   TDateTime d_b=HIndic->DataSource->DataSet->FieldByName("date_begin")->AsDateTime;
   TDateTime d_m=HIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;
    QueryMet->Sql->Clear();
     QueryMet->Params->Clear();
     QueryMet->Options<<doQuickOpen;
     QueryMet->Sql->Add("select start_calc("+ToStrSQL(id_clientp)+","+ToStrSQL(id_docp)+",");
     QueryMet->Sql->Add(ToStrSQL(DateToStr(d_m))+") as boolch");
     QueryMet->ExecSql();

    TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc,id_pref,p.name from acm_bill_tbl as b, \
   aci_pref_tbl p where p.id=b.id_pref and id_ind="+ToStrSQL(id_docp));
  QuerBill->Sql->Add(" and b.id_client="+ToStrSQL(id_clientp));
   QuerBill->Open();
   if (QuerBill->RecordCount<=0)
   {    ClientKontrPotr(Sender);
    };
     TWTQuery *QueryErr=new TWTQuery(this);
   QueryErr->Sql->Clear();
   QueryErr->Sql->Add("select id_error,ident from sys_error_tmp ");
   QueryErr->Open();
   if (!(QueryErr->Eof))
    {    ClientKontrPotr(Sender);
    };


 } catch (Exception &e)
   {
     Application->ShowException(&e);
     ShortDateFormat="dd.mm.yyyy";

  };

  ShortDateFormat="dd.mm.yyyy";
  QueryErr->Sql->Clear();
    QueryErr->Sql->Add("select id_error from sys_error_tbl where  ident ='2krd_ok'");
    QueryErr->Open();
    if(!(QueryErr->Eof))
    {   AnsiString err=" ";
        int id_err=QueryErr->Fields->Fields[0]->AsInteger;
        err=((TMainForm*)(Application->MainForm))->GetValueFromBase("select name from syi_error_tbl where id="+ToStrSQL(id_err));
        ShowMessage("���������: "+err);
        ShortDateFormat="dd.mm.yyyy";

    };


    ShortDateFormat="dd.mm.yyyy";
   HIndic->DataSource->DataSet->Refresh();
};

#define WinName  "������ ������"
void _fastcall  TfCliDem::ClientKontrPotr(TObject *Sender)
{
try {
  TWTPanel *TDoc;
   int id_clientp=0;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;

  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)(MPanel->Parent);
  // ���� ����� ���� ���� - ������������ � �������
  if (((TMainForm*)(Application->MainForm))->ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTDoc *DocEqp=new TWTDoc(this,"");
  TWTPanel* PEqp=DocEqp->MainPanel->InsertPanel(100,true,200);
  TWTDBGrid* DBGrEqp=new TWTDBGrid(DocEqp, "act_res_notice");
  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PEqp->Params->AddText("������ ����������� ������������",18,F,Classes::taCenter,false);
  PEqp->Params->AddGrid(DBGrEqp, true)->ID="Eqp";

   // TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,"act_res_eqp_err",false);
 // WGrid->SetCaption(Win ame);
  TWTTable* TableI = DBGrEqp->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
   DBGrEqp->SetReadOnly();
  TableI->Open();
  TableI->ReadOnly=true;
  TWTField *Field;
  Field = DBGrEqp->AddColumn("res", "�����������", "�����������");
  Field->SetWidth(500);
     DBGrEqp->Visible = true;

 DocEqp->SetCaption("�������� �������");
 DocEqp->ShowAs(WinName);

 DocEqp->MainPanel->ParamByID("Eqp")->Control->SetFocus();
}
catch ( ... ){
ShowMessage("���������� ���������� !!!");
}

};

#undef WinName



void _fastcall   TfCliDem::ClientBillPrintP(TObject *Sender)
{ TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;
  int id_bill=0;
  AnsiString nam_bill=" ";
  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int id_client=GrHIndic->DataSource->DataSet->FieldByName("id_client")->AsInteger;

  TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc,id_pref,p.name from acm_bill_tbl as b, \
   aci_pref_tbl p where p.id=b.id_pref and id_ind="+ToStrSQL(id_head));
  QuerBill->Sql->Add(" and b.id_client="+ToStrSQL(id_client));

  QuerBill->Open();
   if (QuerBill->RecordCount>0)
   {  while (!QuerBill->Eof)  {
        id_bill=QuerBill->FieldByName("id_doc")->AsInteger;

//        Application->CreateForm(__classid(TfPrintBill), &fPrintBill);
        fPrintBill->ShowBill(id_bill);
        if ((QuerBill->FieldByName("id_pref")->AsInteger == 10) ||(QuerBill->FieldByName("id_pref")->AsInteger == 20))// ������� ��� ���
         {
            Application->CreateForm(__classid(TfPrintBillAkt), &fPrintBillAkt);
            fPrintBillAkt->id_bill = id_bill;
            fPrintBillAkt->ShowModal();
            delete fPrintBillAkt;
         }

        QuerBill->Next();
        if  (!(QuerBill->Eof))

         {  nam_bill=QuerBill->FieldByName("name")->AsString;
              if (!Ask("�������� ����"+nam_bill) ) {
             QuerBill->Next();
         };
       }

      };
  //      AnsiString  LinkName1="https//chernigivoblenergo.com.ua/cabinet/sign/sign.php";
 // ShellExecute(Handle, NULL, LinkName1.c_str(), NULL, NULL, SW_SHOWNORMAL);
   }
   else    ShowMessage("�� ����������� ���� �� ������ ����������!");

};



void _fastcall   TfCliDem::ClientBillPrintT(TObject *Sender)
{ TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;

  ShowMessage("�� �������� � �������� ������ ������� ������� ��������� ��������� � ������ 2015 ���� ������� ��������� ��������� ����������!");
   return;

  int id_tax=0;
  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int id_client=GrHIndic->DataSource->DataSet->FieldByName("id_client")->AsInteger;
  int id_bill=0;
  TWTQuery *QuerTax=new TWTQuery(this);
  TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc from acd_met_kndzn_tbl as kn,acm_bill_tbl as b where kn.id_parent_doc="+ToStrSQL(id_head));
  QuerBill->Sql->Add(" and b.id_doc=kn.id_doc ");
  QuerBill->Sql->Add(" and b.id_client="+ToStrSQL(id_client));
  QuerBill->Open();

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;
  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  if (QuerBill->RecordCount>0)
  {  id_bill=QuerBill->FieldByName("id_doc")->AsInteger;
     QuerTax->Sql->Clear();
     QuerTax->Sql->Add("select t.id_doc from acm_tax_tbl  as t where t.id_bill="+ToStrSQL(id_bill));
     QuerTax->Open();
     if (QuerTax->RecordCount==0)
     {   if (MessageDlg(" ������������ ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
        {
        return;
        }

      ZQTax->Transaction->NewStyleTransactions=false;
      ZQTax->Transaction->TransactSafe=true;
      ZQTax->Transaction->AutoCommit=false;
      ZQTax->Transaction->Commit();
      ZQTax->Transaction->StartTransaction();

      AnsiString sqlstr="select acm_createTaxBill( :bill );";
      ZQTax->Sql->Clear();
      ZQTax->Sql->Add(sqlstr);
      ZQTax->ParamByName("bill")->AsInteger=id_bill;
      //ZQTax->ExecSql();

      try
      {
        ZQTax->ExecSql();
      }
      catch(EDatabaseError &e)
      {   ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
          ZQTax->Transaction->Rollback();
          ZQTax->Close();
          ZQTax->Transaction->AutoCommit=true;
          ZQTax->Transaction->TransactSafe=false;
          delete ZQTax;
          return;
      }
//------------------------------------------------------------------------------
    ZQTax->Sql->Clear();
    ZQTax->Sql->Add("select id_error from sys_error_tbl where  ident ='tax'");
    ZQTax->Open();
    int tax_ok = true;
    while(!(ZQTax->Eof))
    {   AnsiString err=" ";
        int id_err=ZQTax->Fields->Fields[0]->AsInteger;
        err=((TMainForm*)(Application->MainForm))->GetValueFromBase("select name from syi_error_tbl where id="+ToStrSQL(id_err));
        ShowMessage("���������: "+err);

        if (id_err == 20) tax_ok = false;
        ZQTax->Next();
    };
    ZQTax->Close();

    if (!tax_ok)
     {
      ZQTax->Transaction->Commit();
      ZQTax->Transaction->AutoCommit=true;
      ZQTax->Transaction->TransactSafe=false;
      delete ZQTax;
      return;
     }
//------------------------------------------------------------------------------

      sqlstr="select int_num,reg_date,id_doc,value_tax from acm_tax_tbl where id_doc=currval('dcm_doc_seq')";
      ZQTax->Sql->Clear();
      ZQTax->Sql->Add(sqlstr);
      try
      {   ZQTax->Open();
      }
      catch(...)
      { ShowMessage("������.");
        ZQTax->Close();
        ZQTax->Transaction->Rollback();
        ZQTax->Transaction->AutoCommit=true;
        ZQTax->Transaction->TransactSafe=false;
        delete ZQTax;
        return;
      }

      int TaxNum =ZQTax->FieldByName("int_num")->AsInteger;
      TDateTime TaxDate =ZQTax->FieldByName("reg_date")->AsDateTime;
      id_tax = ZQTax->FieldByName("id_doc")->AsInteger;
      float value_tax = ZQTax->FieldByName("value_tax")->AsFloat;

      ZQTax->Close();
      if (TaxNum > 0)
      {

      Application->CreateForm(__classid(TfTaxParam), &fTaxParam);
      fTaxParam->edNum->Text =IntToStr(TaxNum);
      fTaxParam->edDt->Text  = FormatDateTime("dd.mm.yyyy",TaxDate);
      fTaxParam->CheckSum(value_tax);
      if (fTaxParam->ShowModal()!= mrOk)
       {
        delete fTaxParam;
        ZQTax->Transaction->Rollback();
        ZQTax->Transaction->AutoCommit=true;
        ZQTax->Transaction->TransactSafe=false;
        delete ZQTax;
        return ;
       };
       AnsiString NewTaxNum = fTaxParam->edNum->Text;
       TDateTime NewTaxDate = StrToDate(fTaxParam->edDt->Text);
       delete fTaxParam;

       if (NewTaxDate > Date())
       {
        if (MessageDlg(" ���� ��������� ������ ������� ����. ���������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
        {
         ZQTax->Close();
         ZQTax->Transaction->Rollback();
         ZQTax->Transaction->AutoCommit=true;
         ZQTax->Transaction->TransactSafe=false;
         delete ZQTax;
         return;
        }
       }

        //AnsiString NewTaxNum=InputBox("����� ��������� ���������", "������� ��������� ��������� � �������", IntToStr(TaxNum));
        if (StrToInt(NewTaxNum)!=TaxNum)
          { sqlstr="select acm_SetTaxNum(:num , currval('dcm_doc_seq')::::int );";
            ZQTax->Sql->Clear();
            ZQTax->Sql->Add(sqlstr);
            ZQTax->ParamByName("num")->AsInteger=StrToInt(NewTaxNum);
            try
            {     ZQTax->ExecSql();
            }
            catch(EDatabaseError &e)
            {  ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
               ZQTax->Transaction->Rollback();
               ZQTax->Transaction->AutoCommit=true;
               ZQTax->Transaction->TransactSafe=false;
               delete ZQTax;
               return;
            }
          }

        if (NewTaxDate!=TaxDate)
          { sqlstr="update acm_tax_tbl set reg_date = :rdate where id_doc=currval('dcm_doc_seq');";
            ZQTax->Sql->Clear();
            ZQTax->Sql->Add(sqlstr);
            ZQTax->ParamByName("rdate")->AsDateTime=NewTaxDate;
            try
            {     ZQTax->ExecSql();
            }
            catch(EDatabaseError &e)
            {  ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
               ZQTax->Transaction->Rollback();
               ZQTax->Transaction->AutoCommit=true;
               ZQTax->Transaction->TransactSafe=false;
               delete ZQTax;
               return;
            }
          }

      }
      ZQTax->Transaction->Commit();
      ZQTax->Transaction->AutoCommit=true;
      ZQTax->Transaction->TransactSafe=false;
    }
    else
    {
      id_tax=QuerTax->Fields->Fields[0]->AsInteger;
    };


    if (mmgg_bill < TDateTime(2014,3,1))
       Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
    else
    {
       if (mmgg_bill < TDateTime(2014,12,1))
         Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxN);
       else
      {
       if (mmgg_bill < TDateTime(2015,1,1))
         Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxN);
       else
         Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxN);

      }
    }


    fRepTaxN->ShowTaxNal(id_tax);
    delete fRepTaxN;

    ZQTax->Close();
    ZQTax->Sql->Clear();
    ZQTax->Sql->Add("select id_doc from acm_taxcorrection_tbl where  id_bill = :bill");
    ZQTax->ParamByName("bill")->AsInteger=id_bill;
    ZQTax->Open();

    if (mmgg_bill < TDateTime(2014,3,1))
       Application->CreateForm(__classid(TfRepTaxCor), &fRepTaxCor);
    else
    {
      if (mmgg_bill < TDateTime(2014,12,1))
       Application->CreateForm(__classid(TfRepTaxCor2014), &fRepTaxCor);
      else
     {
      if (mmgg_bill < TDateTime(2015,1,1))
       Application->CreateForm(__classid(TfRepTaxCor2014_12), &fRepTaxCor);
      else
       Application->CreateForm(__classid(TfRepTaxCor2015), &fRepTaxCor);
     }
    }


    while(!(ZQTax->Eof))
    {
     fRepTaxCor->ShowTaxCor(ZQTax->Fields->Fields[0]->AsInteger,0);

     ZQTax->Next();
   };

   ZQTax->Close();
   delete fRepTaxCor;

  //ShowMessage("��������� ��������� ������� ������������");
  }
   else
   {    ShowMessage("�� ����������� ���� �� ������ ����������!");};

  delete ZQTax;
};

void _fastcall  TfCliDem::OnChangeIndic(TWTField *Sender)
{
  TWTQuery *Table = (TWTQuery *)Sender->Field->DataSet;
  TWTQuery * QuerDat=new TWTQuery(this);
  QuerDat->Sql->Clear();
  int pind;
  int car,c_comp=1;
  bool c_ind=true;
   double prev_ind,curr_ind,calc_ind;
  prev_ind=0,00;
  TWTQuery* QuerTyp=new TWTQuery(this);
  QuerTyp->Sql->Add("select a.*,b.ident from acm_headindication_tbl as a left join\
           dci_document_tbl as b on a.idk_document=b.id where id_doc=:idind ");
  QuerTyp->ParamByName("idind")->AsInteger=Table->FieldByName("id_doc")->AsInteger;
  QuerTyp->Open();
  AnsiString typ=QuerTyp->DataSource->DataSet->FieldByName("ident")->AsString;


  if ( (typ=="chn_cnt") && (Table->FieldByName("id_previndic")->IsNull)&&
     ((Table->FieldByName("indic_edit_enabled")->AsInteger==0)||(Table->FieldByName("indic_edit_enabled")->IsNull)) )
  { pind=Table->FieldByName("id")->AsInteger;
     QuerDat->Sql->Clear();
   QuerDat->Sql->Add("delete from acd_indication_tbl where id="+ToStrSQL(pind));
   QuerDat->ExecSql();
   Table->Refresh();
   ShowMessage("��������� ������������� ��������� � ��������������� ���������! ������ �������! ");
   return;
  };
  try
  {
   pind=Table->FieldByName("id_previndic")->AsInteger;
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select value from acd_indication_tbl where id="+ToStrSQL(pind));
   QuerDat->Open();
   prev_ind=Round(QuerDat->Fields->Fields[0]->AsFloat,4);
   AnsiString prev_char= QuerDat->Fields->Fields[0]->AsString;
   AnsiString next_char=Sender->Field->AsString;
   if (prev_char==next_char)  c_ind=false;
  }
  catch (...)
  {
    c_ind=false;
  };


  try
  {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry,coef_comp from acd_indication_tbl where id="+ToStrSQL(Table->FieldByName("id")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=QuerDat->Fields->Fields[1]->AsFloat;
   if (car==0){
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("id_typemet")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   };
  }
  catch (...)
  {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("id_typemet")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=1;
  };

  TWTQuery *QuerDev=new TWTQuery(this);

  if (c_ind)
  {
   QuerDev->Sql->Add("select calc_ind_pr(:eind,:bind,:car)");
   curr_ind=Round(Sender->Field->AsFloat,4);
   QuerDev->ParamByName("eind")->AsFloat=Round(curr_ind,4);
   QuerDev->ParamByName("bind")->AsFloat=Round(prev_ind,4);
   QuerDev->ParamByName("car")->AsInteger=car;
   QuerDev->Open();
   if (!QuerDev->Fields->Fields[0]->AsString.IsEmpty())
   {
    calc_ind= Round(QuerDev->Fields->Fields[0]->AsFloat,4);
    Table->FieldByName("value_dev")->AsFloat=Round(calc_ind,4);

    if ( c_comp!=0)
     Table->FieldByName("value_dem")->AsFloat=Round(Round(calc_ind,4)*c_comp,0);
    else
     Table->FieldByName("value_dem")->AsFloat=Round(calc_ind,0);
     
    QuerDev->Close();
   }
   else
   {
    ShowMessage("������ ���������� �����������! �������� �����������!");
    return;
   };
  }
  else
  { Table->FieldByName("value_dem")->AsFloat=0;
    Table->FieldByName("value_dev")->AsFloat=0;
  };

   //-------------------------------------------------------------------------
   if((mem_mode)&& (QuerH->FieldByName("idk_document")->AsInteger ==310 ))
   { // �� ������ �������� ������ �������� �������� ��������� (������ ���)

     double res_ind = 0;
     TDateTime res_dat;
     TDateTime res1_dat;

     if(!(Table->FieldByName("kontrol_ind")->IsNull)&& (Table->FieldByName("work_ind")->IsNull))
     {
       res_ind =Table->FieldByName("kontrol_ind")->AsFloat;
       res_dat =Table->FieldByName("dt_insp")->AsDateTime;
     }

     if((Table->FieldByName("kontrol_ind")->IsNull)&& !(Table->FieldByName("work_ind")->IsNull))
     {
       res_ind =Table->FieldByName("work_ind")->AsFloat;
       res_dat =Table->FieldByName("dt_work")->AsDateTime;
     }

     if(!(Table->FieldByName("kontrol_ind")->IsNull)&& !(Table->FieldByName("work_ind")->IsNull)&&
        (Table->FieldByName("dt_insp")->AsDateTime >=Table->FieldByName("dt_work")->AsDateTime) )
     {
      res_ind =Table->FieldByName("kontrol_ind")->AsFloat;
      res_dat =Table->FieldByName("dt_insp")->AsDateTime;
     }

     if(!(Table->FieldByName("kontrol_ind")->IsNull)&& !(Table->FieldByName("work_ind")->IsNull)&&
        (Table->FieldByName("dt_insp")->AsDateTime < Table->FieldByName("dt_work")->AsDateTime) )
     {
      res_ind =Table->FieldByName("work_ind")->AsFloat;
      res_dat =Table->FieldByName("dt_work")->AsDateTime;
     }

     res1_dat= Table->FieldByName("dat_prev")->AsDateTime;
     if((res_ind!=0)&&(res_ind > Round(Sender->Field->AsFloat,4))&&(res_dat>=Table->FieldByName("dat_prev")->AsDateTime)&&(res_ind>prev_ind))     {
      //�� ������ �������� ����� 0 ��������� ��� � �����������
      QuerDev->Sql->Clear();
      QuerDev->Sql->Add("select calc_ind_pr(:eind,:bind,:car)");
      QuerDev->ParamByName("eind")->AsFloat=Round(res_ind,4);
      QuerDev->ParamByName("bind")->AsFloat=Round(prev_ind,4);
      QuerDev->ParamByName("car")->AsInteger=car;
      QuerDev->Open();

      if (!QuerDev->Fields->Fields[0]->AsString.IsEmpty())
      {
        if (Table->FieldByName("value_dev")->AsFloat < Round(QuerDev->Fields->Fields[0]->AsFloat,4))
        {
         if(boss_mode)
         {
          if (MessageDlg("��������� ��������� ������ �����������. ��������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
          {
           //Sender->Field->AsFloat = prev_ind;
           Table->Cancel();
           return;
          }
         }
         else
         {
          if (MessageDlg("��������� ��������� ������ �����������. ����������? (���������� ������ ������!)", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
          {
           Application->CreateForm(__classid(TfUserLogin), &fUserLogin);
           fUserLogin->mode = 2;

           TModalResult result = fUserLogin->ShowModal();
           if (result!=mrCancel)
           {
             user_changed  =true;

             if(CheckLevelStrong("����� ����� ����������� ��������� �� ��������������� �����������")!=0)
             {
              boss_mode=true;
             }
             else
             {
              ShowMessage("� ���������� ������������ ��� ����������� ����!");
              Table->Cancel();
              return;
             }
           }
           else
           {
            Table->Cancel();
            return;
           }
          }
          else
          {
           Table->Cancel();
           return;
          }
         }
        }
      }
      else
      {
       ShowMessage("������ ���������� �����������!");
       return;
      };
      QuerDev->Close();

     }

   }

   //-------------------------------------------------------------------------

  return;
}
//------------------------------------------------------------------------------
void _fastcall  TfCliDem::ClientDemandPrintP(TObject *Sender)
{
  TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;

  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  //TfPrintDemand::ShowBill(int id_doc)
    Application->CreateForm(__classid(TfPrintDemand), &fPrintDemand);
    fPrintDemand->ShowBill(id_head);

};

void __fastcall  TfCliDem::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

#define WinName  "������ ������"
void _fastcall  TfCliDem::ClientKontr(TObject *Sender)
{
try {
  TWTPanel *TDoc;
   int id_clientp=0;
   int id_err;
   AnsiString str_err;
      TWTQuery *QueryErr1=new TWTQuery(this);
   TWTQuery *QueryErr=new TWTQuery(this);
   QueryErr1->Sql->Clear();
   QueryErr1->Sql->Add("select distinct id_error,ident from sys_error_tmp order by id_error");
   QueryErr1->Open();
   if (!(QueryErr1->Eof))
   {   id_err=QueryErr1->Fields->Fields[0]->AsInteger;
       str_err=QueryErr1->Fields->Fields[1]->AsString;
       TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

    TWTDoc *DocEqp=new TWTDoc(this,"");
    TWTPanel* PEqp=DocEqp->MainPanel->InsertPanel(100,true,200);
    QueryErr->Sql->Clear();
    QueryErr->Sql->Add(" select * from act_res_notice;" );
  if (str_err=="d_pnt_knd")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add(" \
          select '����� �����'::::varchar(20) as Type,d.id_point,e.name_eqp,d.kind_energy,d.dat_b, \
           count(d.*):::: int  as doubl \
          from act_pnt_knd d \
           left join  \
           (select * from eqm_equipment_h where dt_e is null ) as e \
           on e.id=d.id_point \
            \ group by \
  '����� �����'::::varchar(20), d.id_point,e.name_eqp,d.kind_energy,d.dat_b        \
  having count(*) >1      ");
    };

      if (str_err=="d_metkndzn")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add(" \
          select d.id_meter,e.name_eqp,d.num_eqp,d.kind_energy,d.id_zone,d.dat_b ,count(*) :::: int as doubl \
           from act_met_kndzn_tbl d \
          left join  \
           (select * from eqm_equipment_h where dt_e is null ) as e \
           on e.id=d.id_meter \
         group by d.id_meter,e.name_eqp,d.num_eqp,d.kind_energy,d.id_zone ,d.dat_b \
   having count(*) >1   ");
    };

        if (str_err=="d_met_pnt")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add("  select id_point,id_meter,dat_b,count(*) :::: int as doubl   \
         from act_meter_pnt_tbl group by id_point,id_meter,dat_b  \
           having count(*) >1  ");
    };

       if (str_err=="d_metknd")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add(" \
          select d.id_meter,e.name_eqp,d.kind_energy,d.dat_b ,count(*) :::: int as doubl \
           from act_met_knd d \
          left join  \
           (select * from eqm_equipment_h where dt_e is null ) as e \
           on e.id=d.id_meter \
         group by d.id_meter,e.name_eqp,d.kind_energy,d.dat_b \
   having count(*) >1   ");
    };
        if (str_err=="d_lostse")
    {    QueryErr->Sql->Clear();
            QueryErr->Sql->Add(" select d.id_point,e.name_eqp,d.id_eqp,d.dat_b ,count(*) :::: int as doubl \
                from act_losts_eqm_tbl d  \
                    left join  \
                     (select * from eqm_equipment_h where dt_e is null ) as e \
                       on e.id=d.id_point \
                     group by d.id_point,e.name_eqp,d.id_eqp,d.dat_b                   \
                     having count(*) >1 "  );

    };



         if (str_err=="d_pwrdem")
    {    QueryErr->Sql->Clear();
            QueryErr->Sql->Add("select id_point,kind_energy,dat_b,id_zone,count(*)::::int as count \
                 from act_pwr_demand_tbl group by id_point,kind_energy,dat_b,id_zone \
                having count(*) >1 ");
     };

         if (str_err=="d_metkndzn")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add("select a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.id_zone,a.dat_b,count(a.*)::::int as count \
            from act_met_kndzn_tbl as a \
            right join     (select distinct id_point from act_point_branch_tbl) as b                                                                          \
               on a.id_point=b.id_point where a.id_point is not null \
              group by a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.id_zone,a.dat_b   \
            having count(*) >1 ");
     };
             if (str_err=="d_branch")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add(" select d.name,b.code_eqp, \
          e.name_eqp,t.name as tname,b.id_tree,b.line_no, \
            b.dat_b,b.dat_e,count(b.*)::::int as doubl from \
         act_eqp_branch_tbl b left join \
          (select * from eqm_equipment_h where dt_e is null) e  \
             on e.id=b.code_eqp \
         left join  \
         (select * from eqm_tree_h where dt_e is null) t  \
            on t.id=b.id_tree, \
          eqi_device_kinds_tbl d  where b.type_eqp=d.id \
         group by b.code_eqp,t.name,d.name,e.name_eqp,b.id_tree, \
     b.line_no,b.dat_b,b.dat_e \
 having count(*)>1   ");
    };

     if (str_err=="d_difmet")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add(" select id_point_p,zone_p,id_point,zone,kind_energy,dt_e,count(*)::::int as count \
  from act_difmetzone_tbl group by id_point_p,zone_p,id_point,zone,kind_energy,dt_e   \
  having count(*) >1 ");
    };

    if (str_err=="d_clclost")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add(" select id_point,id_eqp,dat_b,kind_energy,count(*)::::int as count \
  from act_calc_losts_tbl group by id_point,id_eqp,dat_b,kind_energy         \
  having count(*) >1 ");
    };

    if (str_err=="d_loste")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add("select id_point,id_eqp,id_p_eqp,dat_b,dat_e,count(*)::::int as count  \
  from act_losts_eqm_tbl group by id_point,id_eqp,id_p_eqp,dat_b,dat_e         \
  having count(*) >1    ");
    };

      if (str_err=="dubl>m")
    {    QueryErr->Sql->Clear();
         QueryErr->Sql->Add("  Select  d.id_point,e.name_eqp,p.id_point as doubl_point, \
           d.kind_energy,d.id_zone,d.sum_demand,d.fact_demand,d.sum_losts,d.fact_losts, \
            d.dat_b,d.dat_e\
            from act_pwr_demand_tbl d   \
            left join                 \
            (select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point \
               from act_point_branch_tbl as a          \
               inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point) \
             ) as p \
            on (p.id_p_point=d.id_point) \
            left join  \
           (select * from eqm_equipment_h where dt_e is null ) as e \
           on e.id=d.id_point   ");                                                                                         \
    };

     QueryErr->Open();
    TWTDBGrid* DBGrEqp=new TWTDBGrid(DocEqp, QueryErr);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PEqp->Params->AddText("������ ����������� ������������",18,F,Classes::taCenter,false);
    PEqp->Params->AddGrid(DBGrEqp, true)->ID="Eqp";
    TWTQuery* TableI = DBGrEqp->Query;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
    DBGrEqp->SetReadOnly();
    //TableI->Open();
   TableI->ReadOnly=true;
    TWTField *Field;
   DBGrEqp->Visible = true;

 DocEqp->SetCaption("�������� �������");
 DocEqp->ShowAs(WinName);
   QueryErr1->Next();
 DocEqp->MainPanel->ParamByID("Eqp")->Control->SetFocus();
  };

 }
catch ( ... ){
ShowMessage("���������� ���������� !!!");
}




};

#undef WinName


void __fastcall TfCliDem::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{     float t_ind;
    float p_ind;
    float kon_ind;
    float work_ind;
    TDateTime d_kontr, d_work,dt_ind ;



 TDBGrid* t=(TDBGrid*)Sender;
 dt_ind=t->DataSource->DataSet->FieldByName("dat_ind")->AsDateTime;
 t_ind =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 p_ind =t->DataSource->DataSet->FieldByName("before_value")->AsFloat;
  kon_ind=t->DataSource->DataSet->FieldByName("kontrol_ind")->AsFloat;
  d_kontr=t->DataSource->DataSet->FieldByName("dt_insp")->AsDateTime;
 work_ind= t->DataSource->DataSet->FieldByName("work_ind")->AsFloat;
 d_work=t->DataSource->DataSet->FieldByName("dt_work")->AsDateTime;

  if ( (p_ind>t_ind)  )
   {  if (t_ind!=0)
      { t->Canvas->Brush->Color=0x00caffff;
   // t->Canvas->Brush->Color=0x000affff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
       };
   };
       if ( ((kon_ind>t_ind)&& (d_kontr+31>=dt_ind)) || ((work_ind>t_ind) && d_work+31>=dt_ind) )
    if (t_ind!=0)
      {
   {    t->Canvas->Brush->Color=0x00dadaff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
   }; };



}

void __fastcall TfCliDem::HIndDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{  TDateTime reg_date;
   TDateTime date_end;


 TDBGrid* t=(TDBGrid*)Sender;
 reg_date =t->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
 date_end =t->DataSource->DataSet->FieldByName("Date_End")->AsDateTime;

  if ( (reg_date<date_end)  )
   {        { t->Canvas->Brush->Color=0x00baffff;
        t->Canvas->Font->Size=8;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
       };
   };

}

// *********************************************
_fastcall TfCliAddDem::TfCliAddDem(TWinControl *owner, TWTQuery *Client, int fid_clien)  : TWTDoc(owner)


{
   fid_cl=fid_clien;
   fid_eqp=0;
    int lost=0;
    TWTPanel* PHIndic=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PHIndic->Params->AddText("������ ������� "+ name_cl,18,F,Classes::taCenter,false);
    QuerH=new TWTQuery(this);
    QuerSum=new TWTQuery(this);
    QuerH->Sql->Add("select distinct h.*,('���.� '||b.reg_num||' �� '||b.reg_date::::varchar)::::varchar as nam_bill \
     from acm_headdem_tbl h left join (select id_doc,id_client,id_ind,reg_num,reg_date \
      from acm_bill_tbl where id_client=:pid_client) b  \
     on (b.id_ind=h.id_doc ) \
     where  h.id_client=:pid_client");
    QuerH->Sql->Add(" order by mmgg desc");
    QuerH->ParamByName("pid_client")->AsInteger=fid_cl;

    DBGrHInd=new TWTDBGrid(this, QuerH);
    PHIndic->Params->AddGrid(DBGrHInd, true)->ID="HIndic";
    TWTQuery* Query = DBGrHInd->Query;
    TWTQuery* QuerRep=new TWTQuery(this);
    QuerRep->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
    QuerRep->Sql->Add(" where  di.idk_document=dk.id and dk.ident='adddem' order by di.id " );
    QuerRep->Open();
    Query->AddLookupField("Namek_doc","idk_doc",QuerRep,"name","id");
    Query->AddLookupField("kind_en","kind_energy","eqk_energy_tbl","name","id");
    Query->AddLookupField("pref","id_pref","aci_pref_tbl","name","id");

    Query->Open();


  TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
   NList->Add("nam_bill");
  Query->SetSQLModify("acm_headdem_tbl",WList,NList,true,true,true);
  TWTField *Fieldh;
  Fieldh = DBGrHInd->AddColumn("Namek_doc", "��� ������", "���");
  Fieldh->SetWidth(120);

   Fieldh = DBGrHInd->AddColumn("pref", "��� ����������", "��� ����������");
   Fieldh->SetWidth(100);

   Fieldh = DBGrHInd->AddColumn("kind_en", "��� �������", "��� �������");
   Fieldh->SetWidth(100);


  Fieldh = DBGrHInd->AddColumn("reg_num", "����� ������", "����� ������");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("reg_date", "���� ������", "���� ������");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("comment", "����������", "����������");
  Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("nam_bill", "����", "����");
  Fieldh->SetWidth(180);

  Fieldh = DBGrHInd->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);

  Fieldh = DBGrHInd->AddColumn("flock", "���.", "������");
  Fieldh->AddFixedVariable("1", "^");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(20);

  DBGrHInd->AfterInsert=IndicAddCl;
    DBGrHInd->AfterPost=IndicAddNew;

  TButton *BtnCalc=new TButton(this);
  BtnCalc->Caption="������ �����������";
  BtnCalc->OnClick=ClientCalcPotr;
  BtnCalc->Width=180;
  BtnCalc->Top=2;
  BtnCalc->Left=2;

   TButton *BtnPrn=new TButton(this);
  BtnPrn->Caption="������ �����";
  BtnPrn->OnClick=ClientBillPrintP;
  BtnPrn->Width=180;
  BtnPrn->Top=2;
  BtnPrn->Left=184;


  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=466;
  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnCalc,false)->ID="BtnCalc";
  PBtnP->Params->AddButton(BtnPrn,false)->ID="BtnPrn";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";


  TWTPanel* PIndicGr=MainPanel->InsertPanel(200,true,200);

  QuerI=new TWTQuery(this);
  QuerI->Sql->Add("  select d.*,ph.name_eqp as histname  from  acm_demand_tbl d  \
         left join  eqm_equipment_h ph            on (ph.id=d.id_point and (( ph.dt_b < d.dt_b ) and (ph.dt_e is null or ph.dt_e > d.dt_e ))) ,\
          acm_headdem_tbl h      where h.id_doc=d.id_doc and h.id_client=:pid_client ");
  QuerI->ParamByName("pid_client")->AsInteger=fid_cl;

  DBGrInd=new TWTDBGrid(this, QuerI);

  PIndicGr->Params->AddText("��������� ������������ ",18,F,Classes::taCenter,false);
  PIndicGr->Params->AddGrid(DBGrInd, true)->ID="Indic";
  TWTQuery* QueryI = DBGrInd->Query;

  QueryI->AddLookupField("tariff","id_tariff","aci_tarif_tbl","name","id");
  QueryI->AddLookupField("zone","id_zone","eqk_zone_tbl","name","id");
 // QueryI->AddLookupField("name_energy","KIND_ENERGY","eqk_energy_tbl","name","id");
   TWTQuery * QEqp=new TWTQuery(this);
   QEqp->Sql->Add("select distinct id ,name_eqp from (Select * from eqm_equipment_h order by id,dt_b  desc) a where type_eqp=12 ");
   QEqp->Open();
   QueryI->AddLookupField("point","id_point",QEqp,"name_eqp","id");

   QueryI->Open();
   DBGrInd->Query->IndexFieldNames = "id_doc";
  DBGrInd->Query->LinkFields = "id_doc=id_doc";
  DBGrInd->Query->MasterSource = DBGrHInd->DataSource;
  TStringList *WListI=new TStringList();

  WListI->Add("id");

  TStringList *NListI=new TStringList();
   NListI->Add("histname");
  QueryI->SetSQLModify("acm_demand_tbl",WListI,NListI,true,true,true);


  TWTField *Field;


  Field = DBGrInd->AddColumn("tariff", "�����", "�����");
  Field->SetOnHelp( ((TMainForm*)MainForm)->AciTarifSpr);
  Field->SetWidth(200);

    Field = DBGrInd->AddColumn("zone", "����", "����");
  //Field->SetOnHelp( ((TMainForm*)MainForm)->AciTarifSpr);
  Field->SetWidth(120);

  Field = DBGrInd->AddColumn("point", "����", "����");
  Field->SetOnHelp(BtnPointClick);
  Field->SetWidth(200);
  /*
  Field = DBGrInd->AddColumn("histname", "����", "����");
  Field->SetOnHelp(BtnPointClick);
  Field->SetWidth(200);
   */

  Field = DBGrInd->AddColumn("dt_b", "���� �", "���� ������");
  Field->SetWidth(100);

  Field = DBGrInd->AddColumn("dt_e", "���� ��", "���� ���������");
  Field->SetWidth(100);
  Field = DBGrInd->AddColumn("wtm", "�����", "�����");
  Field->SetWidth(80);

  Field = DBGrInd->AddColumn("power", "��������", "��������");
  Field->SetWidth(80);

  Field = DBGrInd->AddColumn("demand", "�����������", "�����������");
  Field->OnChange=OnChange;
  Field->SetWidth(100);

  Field = DBGrInd->AddColumn("sum_demand", "����� �/���", "����� ��� ���");
  Field->OnChange=OnChange;
  Field->Precision=2;

  Field->SetWidth(120);
  Field = DBGrInd->AddColumn("sum_tax", "���", "�����");
  Field->OnChange=OnChange;
  Field->Precision=2;
  Field->SetWidth(120);


  Field = DBGrInd->AddColumn("comment", "����������", "����������");
  Field->SetWidth(50);

   Field = DBGrInd->AddColumn("mmgg", "�����", "�����");
   Field->SetWidth(100);
   Field->SetReadOnly();

  DBGrInd->Visible = true;
 // QueryI->IndexFieldNames = "id_doc";
 // DBGrInd->Visible = true;

  SetCaption("�������������� �������  ");
  ShowAs("�������������� �������  ");
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
  MainPanel->ParamByID("Indic")->Control->SetFocus();
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
 }
#undef WinName
__fastcall TfCliAddDem::~TfCliAddDem()
{
  Close();
};


void _fastcall TfCliAddDem::IndicAddNew(TWTDBGrid *Sender) {
  int i=0;
  int id_clientp=0;
  Word yearr;
  Word yearp;
  Word monthr;
  Word monthp;
  Word dayr;
  Word dayp;
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndic= Sender;
  TWTDBGrid *GrDetIndic= DBGrInd;
  id_clientp =fid_cl;
   Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
  /// ��������� ���������
   int id_docp=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int idk_documentp=Sender->DataSource->DataSet->FieldByName("idk_doc")->AsInteger;
    int idk_pref=Sender->DataSource->DataSet->FieldByName("id_pref")->AsInteger;
   TDateTime reg_date=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
  DecodeDate(reg_date,yearr,monthr,dayr);

   if ((yearr>2099)||(yearr<2006))
  { ShowMessage("������������ ��� � ���� ������! ���������!");
     return;
  };
   int fid_doc=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int pid_client=Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger;
   TDateTime reg_datep=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;

   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from clm_statecl_h where id_client=:pid_client \
   and mmgg_b<=:reg_datep and coalesce(mmgg_e,:reg_datep)>=:reg_datep ");
   QueryMet->ParamByName("pid_client")->AsInteger=pid_client;
   QueryMet->ParamByName("reg_datep")->AsDateTime=reg_datep;
   QueryMet->Open();
   if ((QueryMet->Eof))
   { ShowMessage ("��� ������������ �������� ������� �� ����:"+DateToStr(reg_datep));
     return;
    }
    else
    { if (QueryMet->FieldByName("doc_dat")->AsDateTime>reg_datep)
     {  ShowMessage (" ���� �������� ������ ���� ������:"+DateToStr(reg_datep));
     return;
     }
    };
   if ((idk_documentp==512) &&(idk_pref=120))
   { QueryMet->Sql->Clear();
     QueryMet->Sql->Add("Select inp_ind_add("+ToStrSQL(id_docp)+") ");
     QueryMet->ExecSql();
   };
   //GrDetIndic->DataSource->DataSet->FieldByName("before_value")->LookupDataSet->Refresh();
   GrDetIndic->DataSource->DataSet->Refresh();
   GrDetIndic->Refresh();

};



void _fastcall  TfCliAddDem::OnChange(TWTField *Sender)
{ TWTQuery *Query = (TWTQuery *)Sender->Field->DataSet;
  TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  float nds=Round(QuerTax->Fields->Fields[0]->AsFloat,2);
  DEL(QuerTax);
   if (Sender->Field->Name=="demand")
   { if (!(Query->FieldByName("dt_b")->AsString.IsEmpty()) && !(Query->FieldByName("dt_e")->AsString.IsEmpty()))

      { QuerSum->Sql->Clear();
         QuerSum->Sql->Add("select Calc_Sum_AddDem(:pid_tarif,:pdt_b,:pdt_e,:pdemand)::::numeric as booch ");
         QuerSum->ParamByName("pid_tarif")->AsInteger=Query->FieldByName("id_tariff")->AsInteger;
         QuerSum->ParamByName("pdt_b")->AsDateTime=Query->FieldByName("dt_b")->AsDateTime;
         QuerSum->ParamByName("pdt_e")->AsDateTime=Query->FieldByName("dt_e")->AsDateTime;
         QuerSum->ParamByName("pdemand")->AsInteger=Sender->Field->AsInteger;
          try
          {  QuerSum->Open();
             if (!(QuerSum->Eof))
              { float sum=QuerSum->Fields->Fields[0]->AsFloat;
                Query->FieldByName("sum_demand")->AsFloat=Round(sum,2);
              };
          }
          catch (Exception &exception)
          { Application->ShowException(&exception);
          };
      };
      }
      else
        if (Sender->Field->Name=="sum_demand")
         { Query->FieldByName("sum_tax")->AsFloat= Round(Sender->Field->AsFloat*nds/100,2);
         } else
         { if (Sender->Field->Name=="sum_tax")
           {    if  (Round(Query->FieldByName("sum_demand")->AsFloat*nds/100,2)!=Sender->Field->AsFloat)
                 ShowMessage("����������� ����� ��� �� ���������� 20 %.���������. " );
           };
       };

 return;
};


void _fastcall TfCliAddDem::IndicAddCl(TWTDBGrid *Sender) {
int i=0;
int id_clientp=0;
  TWTDBGrid *GrIndic= Sender;
  id_clientp =fid_cl;
  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
}


void __fastcall TfCliAddDem::ClientCalcPotr(TObject *Sender)
{    TWTPanel *TDoc;
   int id_clientp=0;
   bool check=false;
   TWTDBGrid *HIndic= DBGrHInd;
   id_clientp =fid_cl;

  TWTQuery *QueryMet=new TWTQuery(this);
  TWTQuery *QueryErr=new TWTQuery(this);

  int id_docp=HIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  if (id_docp==0)  {
    ShowMessage("��� ��������� ��� �������");
    return;
    };
 //try {
  if   ((DBGrInd->DataSource->DataSet->State==dsInsert) ||
        (DBGrInd->DataSource->DataSet->State==dsEdit))
   DBGrInd->DataSource->DataSet->Post();
   ShortDateFormat="yyyy-mm-dd";
    QueryMet->Sql->Clear();
     QueryMet->Params->Clear();
     QueryMet->Options<<doQuickOpen;
     QueryMet->Sql->Add("select crt_addbill("+ToStrSQL(id_docp)+") as boolch");
     QueryMet->ExecSql();
    // QueryMet->Open();
     //check=QueryMet->FieldByName("boolch")->AsBoolean;

/* } catch (...)
   { ShortDateFormat="dd.mm.yyyy"; };
  */
  //check=QueryMet->FieldByName("boolch")->AsBoolean;


  ShortDateFormat="dd.mm.yyyy";
  QueryErr->Sql->Clear();
    QueryErr->Sql->Add("select id_error from sys_error_tbl where  ident ='2krd_ok'");
    QueryErr->Open();
    if(!(QueryErr->Eof))
    {   AnsiString err=" ";
        int id_err=QueryErr->Fields->Fields[0]->AsInteger;
        err=((TMainForm*)(Application->MainForm))->GetValueFromBase("select name from syi_error_tbl where id="+ToStrSQL(id_err));
        ShowMessage("���������: "+err);
        ShortDateFormat="dd.mm.yyyy";

    };

  ShortDateFormat="dd.mm.yyyy";
   HIndic->DataSource->DataSet->Refresh();
};




void _fastcall   TfCliAddDem::ClientBillPrintP(TObject *Sender)
{ TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;
  int id_bill=0;
  AnsiString nam_bill=" ";
  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int id_client=GrHIndic->DataSource->DataSet->FieldByName("id_client")->AsInteger;

  TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc, b.idk_doc, id_pref,p.name from acm_bill_tbl as b, \
   aci_pref_tbl p where p.id=b.id_pref and id_ind="+ToStrSQL(id_head));
  QuerBill->Sql->Add(" and b.id_client="+ToStrSQL(id_client));

  QuerBill->Open();
   if (QuerBill->RecordCount>0)
   {  while (!QuerBill->Eof)  {
        id_bill=QuerBill->FieldByName("id_doc")->AsInteger;

//        Application->CreateForm(__classid(TfPrintBill), &fPrintBill);
        fPrintBill->ShowBill(id_bill);
        if ((QuerBill->FieldByName("id_pref")->AsInteger == 10)&&(QuerBill->FieldByName("idk_doc")->AsInteger != 209)) // ������� ��� ���
         {
            Application->CreateForm(__classid(TfPrintBillAkt), &fPrintBillAkt);
            fPrintBillAkt->id_bill = id_bill;
            fPrintBillAkt->ShowModal();
            delete fPrintBillAkt;
         }

        if ((QuerBill->FieldByName("id_pref")->AsInteger == 110)||(QuerBill->FieldByName("id_pref")->AsInteger == 120)) // ������� ��� ���
         {
            Application->CreateForm(__classid(TfPrintBillAkt), &fPrintBillAkt);
            fPrintBillAkt->id_bill = id_bill;
            fPrintBillAkt->ShowModal();
            delete fPrintBillAkt;
         }

        QuerBill->Next();
        if  (!(QuerBill->Eof))

         {  nam_bill=QuerBill->FieldByName("name")->AsString;
              if (!Ask("�������� ����"+nam_bill) ) {
             QuerBill->Next();
         };
       }

      };
   }
   else    ShowMessage("�� ����������� ���� �� ������ ����������!");

};



void _fastcall   TfCliAddDem::ClientBillPrintT(TObject *Sender)
{ TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;
  int id_tax=0;
  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int id_client=GrHIndic->DataSource->DataSet->FieldByName("id_client")->AsInteger;
  int id_bill=0;
  TWTQuery *QuerTax=new TWTQuery(this);
  TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc from acd_met_kndzn_tbl as kn,acm_bill_tbl as b where kn.id_parent_doc="+ToStrSQL(id_head));
  QuerBill->Sql->Add(" and b.id_doc=kn.id_doc ");
  QuerBill->Sql->Add(" and b.id_client="+ToStrSQL(id_client));
  QuerBill->Open();
  if (QuerBill->RecordCount>0)
  {  id_bill=QuerBill->FieldByName("id_doc")->AsInteger;
     QuerTax->Sql->Clear();
     QuerTax->Sql->Add("select t.id_doc from acm_tax_tbl  as t where t.id_bill="+ToStrSQL(id_bill));
     QuerTax->Open();
     if (QuerTax->RecordCount<0)
     {   if (MessageDlg(" ������������ ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
        {
        return;
        }
      TWTQuery * ZQTax = new TWTQuery(Application);
      ZQTax->Options<< doQuickOpen;
      ZQTax->RequestLive=false;
      ZQTax->CachedUpdates=false;

      ZQTax->Transaction->NewStyleTransactions=false;
      ZQTax->Transaction->TransactSafe=true;
      ZQTax->Transaction->AutoCommit=false;
      ZQTax->Transaction->Commit();
      ZQTax->Transaction->StartTransaction();

      AnsiString sqlstr="select acm_createTaxBill( :bill );";
      ZQTax->Sql->Clear();
      ZQTax->Sql->Add(sqlstr);
      ZQTax->ParamByName("bill")->AsInteger=id_bill;
//      ZQTax->ExecSql();
      try
      {
        ZQTax->ExecSql();
      }
      catch(EDatabaseError &e)
      {   ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
          ZQTax->Transaction->Rollback();
          ZQTax->Close();
          ZQTax->Transaction->AutoCommit=true;
          ZQTax->Transaction->TransactSafe=false;
          delete ZQTax;
          return;
      }
      sqlstr="select int_num, reg_date, id_doc, value_tax  from acm_tax_tbl where id_doc=currval('dcm_doc_seq')";
      ZQTax->Sql->Clear();
      ZQTax->Sql->Add(sqlstr);
      try
      {   ZQTax->Open();
      }
      catch(...)
      { ShowMessage("������.");
        ZQTax->Close();
        ZQTax->Transaction->Rollback();
        ZQTax->Transaction->AutoCommit=true;
        ZQTax->Transaction->TransactSafe=false;
        delete ZQTax;
        return;
      }
//      int TaxNum =StrToInt(ZQTax->Fields->Fields[0]->AsString);
      int TaxNum =ZQTax->FieldByName("int_num")->AsInteger;
      TDateTime TaxDate =ZQTax->FieldByName("reg_date")->AsDateTime;
      id_tax = ZQTax->FieldByName("id_doc")->AsInteger;
      float value_tax = ZQTax->FieldByName("value_tax")->AsFloat;


      ZQTax->Close();
      if (TaxNum > 0)
      {
        Application->CreateForm(__classid(TfTaxParam), &fTaxParam);
        fTaxParam->edNum->Text =IntToStr(TaxNum);
        fTaxParam->edDt->Text  = FormatDateTime("dd.mm.yyyy",TaxDate);
        fTaxParam->CheckSum(value_tax);
        if (fTaxParam->ShowModal()!= mrOk)
         {
          delete fTaxParam;
          ZQTax->Transaction->Rollback();
          ZQTax->Transaction->AutoCommit=true;
          ZQTax->Transaction->TransactSafe=false;
          delete ZQTax;
          return ;
         };
        AnsiString NewTaxNum = fTaxParam->edNum->Text;
        TDateTime NewTaxDate = StrToDate(fTaxParam->edDt->Text);
        delete fTaxParam;

        //AnsiString NewTaxNum=InputBox("����� ��������� ���������", "������� ��������� ��������� � �������", IntToStr(TaxNum));
        if (StrToInt(NewTaxNum)!=TaxNum)
          { sqlstr="select acm_SetTaxNum(:num , currval('dcm_doc_seq')::::int );";
            ZQTax->Sql->Clear();
            ZQTax->Sql->Add(sqlstr);
            ZQTax->ParamByName("num")->AsInteger=StrToInt(NewTaxNum);
            try
            {     ZQTax->ExecSql();
            }
            catch(EDatabaseError &e)
            {  ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
               ZQTax->Transaction->Rollback();
               ZQTax->Transaction->AutoCommit=true;
               ZQTax->Transaction->TransactSafe=false;
               delete ZQTax;
               return;
            }
          }
        if (NewTaxDate!=TaxDate)
          { sqlstr="update acm_tax_tbl set reg_date = :rdate where id_doc=currval('dcm_doc_seq');";
            ZQTax->Sql->Clear();
            ZQTax->Sql->Add(sqlstr);
            ZQTax->ParamByName("rdate")->AsDateTime=NewTaxDate;
            try
            {     ZQTax->ExecSql();
            }
            catch(EDatabaseError &e)
            {  ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
               ZQTax->Transaction->Rollback();
               ZQTax->Transaction->AutoCommit=true;
               ZQTax->Transaction->TransactSafe=false;
               delete ZQTax;
               return;
            }
          }

      }
      ZQTax->Transaction->Commit();
      ZQTax->Transaction->AutoCommit=true;
      ZQTax->Transaction->TransactSafe=false;
      delete ZQTax;
  }
  else
    {  id_tax=QuerTax->Fields->Fields[0]->AsInteger;
    };

    if (mmgg_bill < TDateTime(2014,3,1))
       Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
    else
    {
      if (mmgg_bill < TDateTime(2014,12,1))
        Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxN);
      else
        {
         if (mmgg_bill < TDateTime(2015,1,1))
           Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxN);
         else
           Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxN);

        }
    }

   fRepTaxN->ShowTaxNal(id_tax);
   delete fRepTaxN;
  //ShowMessage("��������� ��������� ������� ������������");
  }
   else
   {    ShowMessage("�� ����������� ���� �� ������ ����������!");};

};


void __fastcall  TfCliAddDem::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

void _fastcall TfCliDem::BtnDemF(TObject *Sender)
{    TWTPanel *TDoc;
    // ���������� ���������
  TWTQuery *QueryInd;



  QueryInd = new  TWTQuery(this);
  QueryInd->Options << doQuickOpen;
  QueryInd->Sql->Clear();
  QueryInd->Sql->Add("select c.id as id_cl,c.short_name from clm_client_tbl c where " );
  QueryInd->Sql->Add("c.id=:pid_client " );
  QueryInd->ParamByName("pid_client")->AsInteger=fid_cl;
  QueryInd->Open();
  TfCliAddDem *WGridD;
  WGridD = new TfCliAddDem(Application->MainForm, QueryInd,fid_cl);

};


void __fastcall TfCliAddDem::BtnPointClick(TWTField *Sender)
{

  Application->CreateForm(__classid(TfTreeForm), &fSelectTree);
  fSelectTree->tTreeEdit->OnDblClick=tTreeEditDblClick;
  fSelectTree->OnCloseQuery=FormCloseQuery;
  int fid_eqp=Sender->Field->AsInteger;
  fSelectTree->ShowTrees(fid_cl,true,fid_eqp);

 };



void __fastcall TfCliAddDem::FormCloseQuery(TObject *Sender, bool &CanClose)
{

 fSelectTree->ClearTemp();

 }


void __fastcall TfCliAddDem::tTreeEditDblClick(TObject *Sender)
{
if ((fSelectTree->CurrNode!=NULL)&&(fSelectTree->CurrNode->ImageIndex!=0))
 {
 fid_eqp=fSelectTree->CurrNode->StateIndex;
 if (!((DBGrInd->DataSource->DataSet->State==dsInsert) ||
        (DBGrInd->DataSource->DataSet->State==dsEdit)) )

 //((DBGrInd->DataSource->DataSet->State!=dsEdit) || (DBGrInd->DataSource->DataSet!=dsInsert))
          DBGrInd->DataSource->DataSet->Edit();

 if (PTreeNodeData(fSelectTree->CurrNode->Data)->type_eqp!=12)
   { ShowMessage("�������� ����� ����� !!");
     return;
   };
 DBGrInd->DataSource->DataSet->FieldByName("id_point")->AsInteger=fid_eqp;

 TTreeNode *Node1;
 Node1=fSelectTree->CurrNode;
 /*while(Node1->ImageIndex!=0){
    Node1=Node1->Parent;
 }; */
// fid_treeparent=Node1->StateIndex;
 fSelectTree->Close();
 };

}


// ****************************************************************


void _fastcall TfCliDem::BtnDemLF(TObject *Sender)
{    TWTPanel *TDoc;
    // ���������� ���������
  TfCliLinkDem *WGridL;
  int doc=DBGrHInd->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int cl=DBGrHInd->DataSource->DataSet->FieldByName("id_client")->AsInteger;
  WGridL = new TfCliLinkDem(Application->MainForm, doc,cl);

};

void _fastcall TfCliDem::BtnTrueCabinet(TObject *Sender)
{    TWTPanel *TDoc;
    // ���������� ���������
  TfCliLinkDem *WGridL;
    TWTQuery* QuerCabin=new TWTQuery(this);
  int doc=DBGrHInd->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
     AnsiString sqlstr="select clc_cabinet_upd( :doc,:pr );";
      QuerCabin->Sql->Clear();
      QuerCabin->Sql->Add(sqlstr);

      QuerCabin->ParamByName("doc")->AsInteger=doc;
       if (MessageDlg(" ���������� ������������ ������ ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
         QuerCabin->ParamByName("pr")->AsInteger=1;
       else
           QuerCabin->ParamByName("pr")->AsInteger=0;
      //      ZQTax->ExecSql();
      try
      {
       QuerCabin->ExecSql();
      }
       catch (Exception &e)
   {
     Application->ShowException(&e);
    // ShortDateFormat="dd.mm.yyyy";

  };
     DBGrInd->DataSource->DataSet->Refresh();
  DBGrInd->Refresh();
};


void _fastcall TfCliDem::BtnReadCabinet(TObject *Sender)
{    TWTPanel *TDoc;
    // ���������� ���������
  TfCliLinkDem *WGridL;
    TWTQuery* QuerCabin=new TWTQuery(this);
  int doc=DBGrHInd->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
     AnsiString sqlstr="update acd_indication_tbl set id_cabinet=c.id from acd_cabindication_tbl c   \
 where acd_indication_tbl.mmgg=c.mmgg and acd_indication_tbl.id_client=c.id_client     \
       and acd_indication_tbl.id_meter=c.id_meter and acd_indication_tbl.id_zone=c.id_zone  \
 and acd_indication_tbl.id_doc=:doc \
   and (acd_indication_tbl.dat_ind=c.dat_ind or c.dat_ind is null)";

      QuerCabin->Sql->Clear();
      QuerCabin->Sql->Add(sqlstr);

      QuerCabin->ParamByName("doc")->AsInteger=doc;

      try
      {
       QuerCabin->ExecSql();
      }
       catch (Exception &e)
   {
     Application->ShowException(&e);
    // ShortDateFormat="dd.mm.yyyy";

  };
     DBGrInd->DataSource->DataSet->Refresh();
  DBGrInd->Refresh();
};

#define WinName "������ �� �����������"
_fastcall TfCliLinkDem::TfCliLinkDem(TWinControl *owner,  int fid_headmain,int fid_clientmain)  : TWTDoc(owner)
{
   fid_main=fid_headmain;
   TWTQuery* QuerC=new TWTQuery(this);
   QuerC->Sql->Add("select c.* from clm_client_tbl c \
     where c.id=:pid_client");
   QuerC->ParamByName("pid_client")->AsInteger=fid_clientmain;
   QuerC->Open();
   name_cl=QuerC->DataSource->DataSet->FieldByName("short_name")->AsString;

    TWTPanel* PHIndic=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;

    PHIndic->Params->AddText("������ ��������� ������� ��� "+ name_cl,18,F,Classes::taCenter,false);

    QuerH=new TWTQuery(this);
    QuerH->Sql->Add("select distinct h.*, \
     cast(c.code||'  '||c.short_name as varchar(150)) as client\
     from acm_headindication_tbl h, clm_client_tbl c   \
     where  h.id_main_ind=:pid_headmain and  c.id=h.id_client");
    QuerH->Sql->Add(" order by id_doc");
    QuerH->ParamByName("pid_headmain")->AsInteger=fid_headmain;

    DBGrHInd=new TWTDBGrid(this, QuerH);
    PHIndic->Params->AddGrid(DBGrHInd, true)->ID="HIndic";
    TWTQuery* Query = DBGrHInd->Query;
     Query->Open();


 TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
   NList->Add("client");

  Query->SetSQLModify("acm_headindication_tbl",WList,NList,true,true,true);
   TWTField *Fieldh;
  Fieldh = DBGrHInd->AddColumn("reg_num", "����� ������", "����� ������");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("reg_date", "���� ������", "���� ������");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("date_end", "�� ������ �����.", "���� �� ");
  Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("client", "������", "������");
  Fieldh->SetWidth(180);

  Fieldh = DBGrHInd->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);

  Fieldh = DBGrHInd->AddColumn("flock", "���.", "������");
  Fieldh->AddFixedVariable("1", "^");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(20);


  TButton *BtnCalc=new TButton(this);
  BtnCalc->Caption="������������";
  BtnCalc->OnClick=Reform;
  BtnCalc->Width=100;
  BtnCalc->Top=2;
  BtnCalc->Left=2;



  TButton *BtnPrnDem=new TButton(this);
  BtnPrnDem->Caption="������ ���������";
  BtnPrnDem->OnClick=ClientDemandPrintP;
  BtnPrnDem->Width=100;
  BtnPrnDem->Top=2;
  BtnPrnDem->Left=200;


  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=300;

  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnCalc,false)->ID="BtnCalc";
  PBtnP->Params->AddButton(BtnPrnDem,false)->ID="BtnPrnDem";
 // PBtnP->Params->AddButton(BtnDem,false)->ID="BtnDem";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";

  TWTPanel* PIndicGr=MainPanel->InsertPanel(200,true,200);

  QuerI=new TWTQuery(this);

  QuerI->Sql->Add(" \
    select distinct i.*,e.name_eqp as name_met,p.value as before_value  \
     from (select  i.* from \
          (select * from acm_headindication_tbl where id_main_ind=:pid_doc) as h \
             left join ( select  i.* from  acd_indication_tbl i where i.id_main_ind=:pid_doc) \
              as i on (h.id_doc=i.id_doc) ) as i \
              left join acd_indication_tbl as p on (p.id=i.id_previndic ) \
              join  eqm_equipment_h e \
                    on (i.id_meter=e.id and i.num_eqp=e.num_eqp and (i.dat_ind between e.dt_b \
                   and coalesce(e.dt_e,i.dat_ind) ) ) \
     order by i.id_doc,i.num_eqp,i.kind_energy,i.id_zone");

  QuerI->ParamByName("pid_doc")->AsInteger=fid_headmain;

  DBGrInd=new TWTDBGrid(this, QuerI);

  PIndicGr->Params->AddText("��������� ������������ ",18,F,Classes::taCenter,false);
  PIndicGr->Params->AddGrid(DBGrInd, true)->ID="Indic";


  TWTQuery* QueryI = DBGrInd->Query;
  //QueryI->AddLookupField("name_met","id_meter","eqm_equipment_tbl","name_eqp","id");

  QueryI->AddLookupField("type_met","id_typemet","eqi_meter_tbl","type","id");
  QueryI->AddLookupField("name_energy","KIND_ENERGY","eqk_energy_tbl","name","id");
  QueryI->AddLookupField("Zone","ID_ZONE","eqk_zone_tbl","name","id"); // ����� Name
  QueryI->Open();

  TStringList *WListI=new TStringList();

  WListI->Add("id");

  TStringList *NListI=new TStringList();
  NListI->Add("before_value");
  NListI->Add("name_met");

  QueryI->SetSQLModify("acd_indication_tbl",WListI,NListI,true,true,true);
  QueryI->IndexFieldNames = "id_doc;num_eqp";
  QueryI->LinkFields = "id_doc=id_doc";
  QueryI->MasterSource = DBGrHInd->DataSource;

  DBGrInd->OnAccept=IndicAccept;
  TWTField *Field;
  Field = DBGrInd->AddColumn("name_met", "�������", "�������");
  Field->SetReadOnly();
  Field->SetWidth(120);

   Field = DBGrInd->AddColumn("type_met", "���", "���");
   Field->SetReadOnly();
   Field->SetWidth(120);

   Field = DBGrInd->AddColumn("carry", "����.", "�����������");
   Field->SetWidth(50);
   Field->SetReadOnly();

   Field = DBGrInd->AddColumn("num_eqp", "�����", "�����");
   Field->SetWidth(80);


  Field = DBGrInd->AddColumn("name_energy", "�������", "��� �������");
  Field->SetWidth(50);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("Zone", "����", "����");
    Field->SetWidth(50);
  Field->SetReadOnly();


  Field = DBGrInd->AddColumn("coef_comp", "�-�.��.", "����������� �������������");
  Field->SetWidth(50);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("before_value", "����������", "���������� ���������");
  Field->Column->ButtonStyle=cbsNone;
   Field->SetReadOnly();

  Field = DBGrInd->AddColumn("value", "�������", "������� ���������");
  Field->OnChange=OnChangeIndic;
 // Field->Precision=4;

  Field = DBGrInd->AddColumn("value_dev", "��������", "��������");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("value_dem", "�����������", "�����������");
  Field->SetReadOnly();


  DBGrInd->Visible = true;
  QueryI->IndexFieldNames = "id_doc;num_eqp;kind_energy;id_zone";
  DBGrInd->Visible = true;
  DBGrInd->OnDrawColumnCell = HeadDrawColumnCell;
  SetCaption("��������� ������ ��� "+name_cl);
  ShowAs(WinName);
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
  MainPanel->ParamByID("Indic")->Control->SetFocus();
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
 }
#undef WinName
#define WinName "����������� ����"
void __fastcall TfCliLinkDem::IndicAccept(TObject *Sender)
{
//TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  /*if (ShowMDIChild(WinName, Owner)) {
    return;
  }
    */
    int id_meter=((TWTDBGrid*)Sender)->DataSource->DataSet->FieldByName("id_meter")->AsInteger;
        int id_doci=((TWTDBGrid*)Sender)->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
    TWTQuery *QuerDif=new TWTQuery(this);
    QuerDif->Sql->Clear();
    QuerDif->Sql->Add("select d.*,ke.name as name_energy, \
     kzp.name as zone_pred,kz.name as zone_n from acd_inddifzone_tbl d, \
      eqk_zone_tbl  kzp,eqk_zone_tbl  kz, eqk_energy_tbl ke \
     where id_doc=:id_doci and id_meter=:id_meteri \
      and kzp.id=d.zone_p and kz.id=d.zone and ke.id=d.kind_energy");
    QuerDif->ParamByName("id_doci")->AsInteger=id_doci;
    QuerDif->ParamByName("id_meteri")->AsInteger=id_meter;
     QuerDif->Open();
     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QuerDif);
     WGrid->SetCaption(WinName);
     TStringList *WList=new TStringList();
     WList->Add("id_doc");
     WList->Add("id_meter");
     WList->Add("kind_energy");
     WList->Add("zone_p");
     WList->Add("zone");
  TStringList *NList=new TStringList();
     NList->Add("name_energy");
     NList->Add("zone_pred");
     NList->Add("zone_n");

  QuerDif->SetSQLModify("acd_inddifzone_tbl",WList,NList,true,true,true);

  TWTField *Field;
  Field = WGrid->AddColumn("name_energy", "��� �������", "��� �������");
  Field = WGrid->AddColumn("zone_pred", "���� ��������", "���� ��������� ��������");
   Field = WGrid->AddColumn("zone_n", "���� �����", "���� �������� ������������ �����");
  Field = WGrid->AddColumn("percent", "�������", "�������");
  //Field = WGrid->AddColumn("dt_b", "���� �", "���� �");
   Field = WGrid->AddColumn("dt_e", "���� ���.����", "���� ���.����");
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};
#undef WinName


__fastcall TfCliLinkDem::~TfCliLinkDem()
{
//   GrDetIndic->DataSource->DataSet->Refresh();
//   GrDetIndic->Refresh();

  Close();
};


void __fastcall TfCliLinkDem::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   float t_ind;
    float p_ind;
    float kon_ind;
      float work_ind;

 TDBGrid* t=(TDBGrid*)Sender;
 t_ind =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 p_ind =t->DataSource->DataSet->FieldByName("before_value")->AsFloat;
 //kon_ind=t->DataSource->DataSet->FieldByName("kontrol_ind")->AsFloat;
 //work_ind= t->DataSource->DataSet->FieldByName("work_ind")->AsFloat;
    if ( (p_ind>t_ind)  )
    if (t_ind!=0)
      {
   {    t->Canvas->Brush->Color=0x00caffff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
   }; };
  /*   if ( (kon_ind>t_ind) || (work_ind>t_ind) )
    if (t_ind!=0)
      {
   {    t->Canvas->Brush->Color=0x00daffff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
   }; };
     */

}



void __fastcall TfCliLinkDem::Reform(TObject *Sender)
{  TWTPanel *TDoc;

   bool check=false;
   TWTDBGrid *HIndic= DBGrHInd;
   TWTDBGrid *Indic= DBGrInd;
try {
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTQuery *QueryErr=new TWTQuery(this);
  QueryMet->Sql->Clear();
  QueryMet->Params->Clear();
  QueryMet->Sql->Add("select conn_tree("+ToStrSQL(fid_main)+ ")");
  QueryMet->ExecSql();
  //check=QueryMet->FieldByName("boolch")->AsBoolean;

  } catch (Exception &e)
   {
     Application->ShowException(&e);
     ShortDateFormat="dd.mm.yyyy";

  };

   HIndic->DataSource->DataSet->Refresh();
   Indic->DataSource->DataSet->Refresh();
};





void _fastcall  TfCliLinkDem::OnChangeIndic(TWTField *Sender)
{
  TWTTable *Table = (TWTTable *)Sender->Field->DataSet;
  TWTQuery * QuerDat=new TWTQuery(this);
  QuerDat->Sql->Clear();
  int pind;
  int car,c_comp=1;
  bool c_ind=true;
  float prev_ind;
  prev_ind=0,00;
  try {
   pind=Table->FieldByName("id_previndic")->AsInteger;
    QuerDat->Sql->Add("select value from acd_indication_tbl where id="+ToStrSQL(pind));
    QuerDat->Open();
    prev_ind=Round(QuerDat->Fields->Fields[0]->AsFloat,4);
    AnsiString prev_char= QuerDat->Fields->Fields[0]->AsString;
    AnsiString next_char=Sender->Field->AsString;
    if (prev_char==next_char)  c_ind=false;
    }
    catch (...) {
       c_ind=false;
    };
    try {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry,coef_comp from acd_indication_tbl where id="+ToStrSQL(Table->FieldByName("id")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=QuerDat->Fields->Fields[1]->AsFloat;
   if (car==0){
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("id_typemet")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   };
     }
  catch (...) {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("id_typemet")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=1;
  };

  if (c_ind){
   TWTQuery *QuerDev=new TWTQuery(this);
   QuerDev->Sql->Add("select calc_ind_pr(:eind,:bind,:car)");
   QuerDev->ParamByName("eind")->AsFloat=Round(Sender->Field->AsFloat,4);
   QuerDev->ParamByName("bind")->AsFloat=Round(prev_ind,4);
   QuerDev->ParamByName("car")->AsInteger=car;
   QuerDev->Open();
   if (!QuerDev->Fields->Fields[0]->AsString.IsEmpty())
   {     Table->FieldByName("value_dev")->AsFloat=Round(QuerDev->Fields->Fields[0]->AsFloat,4);
    if ( c_comp!=0)
    Table->FieldByName("value_dem")->AsFloat=Round(QuerDev->Fields->Fields[0]->AsFloat*c_comp,0);
    else
    Table->FieldByName("value_dem")->AsFloat=Round(QuerDev->Fields->Fields[0]->AsFloat,0);
   }
   else
   {  ShowMessage("������ ���������� �����������! �������� �����������!");
     return;
   };
  }
  else
  { Table->FieldByName("value_dem")->AsFloat=0;
    Table->FieldByName("value_dev")->AsFloat=0;
  };

   return;

}
void _fastcall  TfCliLinkDem::ClientDemandPrintP(TObject *Sender)
{
  TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;

  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  //TfPrintDemand::ShowBill(int id_doc)
    Application->CreateForm(__classid(TfPrintDemand), &fPrintDemand);
    fPrintDemand->ShowBill(id_head);

};

void __fastcall  TfCliLinkDem::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}
//------------------------------------------------------------------------------

void _fastcall TfCliDem::ClientPowerIndic(TObject *Sender)
{    TWTPanel *TDoc;
    // ���������� ���������
  TWTQuery *QueryInd;
  QueryInd = new  TWTQuery(this);
  QueryInd->Options << doQuickOpen;
  QueryInd->Sql->Clear();
  QueryInd->Sql->Add("select c.id as id_cl,c.short_name from clm_client_tbl c where " );
  QueryInd->Sql->Add("c.id=:pid_client " );
  QueryInd->ParamByName("pid_client")->AsInteger=fid_cl;
  QueryInd->Open();

  TfPowerInd *WGridPI;
  WGridPI = new TfPowerInd(Application->MainForm, QueryInd,fid_cl);

};

      /*


void _fastcall TfCliDem::BtnDemLF(TObject *Sender)
{    TWTPanel *TDoc;
    // ���������� ���������
  TfLost *WGridLost;
  int doc=DBGrHInd->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int cl=DBGrHInd->DataSource->DataSet->FieldByName("id_client")->AsInteger;
  WGridLost = new TfCliLinkDem(Application->MainForm, doc,cl);

};

        */
void _fastcall   TfCliDem::Lost(TObject *Sender)
{ TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;
  int id_bill=0;
   AnsiString nam_bill=" ";
    TfLost *WGridLost;
  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  int id_client=GrHIndic->DataSource->DataSet->FieldByName("id_client")->AsInteger;
   int doc=DBGrHInd->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
     TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc,id_pref,p.name from acm_bill_tbl as b, \
   aci_pref_tbl p where p.id=b.id_pref and id_ind="+ToStrSQL(id_head));
  QuerBill->Sql->Add(" and b.id_client="+ToStrSQL(id_client));
  QuerBill->Open();
  try {
   if (QuerBill->RecordCount>0)
   {  while (!QuerBill->Eof)  {
         id_bill=QuerBill->FieldByName("id_doc")->AsInteger;
         // Losts(id_bill);
          WGridLost = new TfLost(Application->MainForm, id_bill,id_client);
         QuerBill->Next();
        if  (!(QuerBill->Eof))

         {  nam_bill=QuerBill->FieldByName("name")->AsString;
              if (!Ask("������ �� "+nam_bill) ) {
             QuerBill->Next();
         };
       }

      };
   }
   else    ShowMessage("�� ����������� ���� �� ������ ����������!");
   }
   catch (...) {};

};


#define WinName "������ �� �����"
_fastcall TfLost::TfLost(TWinControl *owner,  int fid_headmain,int fid_clientmain)  : TWTDoc(owner)
{
   int id_bill=fid_headmain;
   TWTPanel* PHIndic=MainPanel->InsertPanel(19,true,40);
   TFont *F;
   F=new TFont();
   F ->Size=10;
   F->Style=F->Style << fsBold;
   F->Color=clBlue;
   PHIndic->Params->AddText("������ �� ������������ ",18,F,Classes::taCenter,false);
   TWTQuery  *QuerLost1=new TWTQuery (this);
   QuerLost1->Sql->Clear();
   QuerLost1->Sql->Add(" select distinct cl.code,cl.short_name,cl.num_eqp,ob.* from  \
 ( select * from (  \
   select l.id_doc,l.id_point,l.num,ep.name_eqp as point_name,\
     ee.name_eqp as eqp_name,                               \
     l.dat_b,l.dat_e,l.type_eqm,l.id_type_eqp,              \
     tp.type as eqp_type,l.dat_b,l.dat_e,                   \
     l.sn_len,l.tt,l.tw,l.pxx_r0,l.pkz_x0,l.ixx,l.ukz_un,            \
     l.wp, l.wq,l.wp1,l.s_xx_addwp,l.s_kz_addwq,            \
     en.name as energy,l.dw,l.res_l,l.in_demand                                 \
    from (select *  from acd_calc_losts_tbl  where id_doc = :pid_doc and type_eqm=2) as l, \
      eqm_equipment_tbl ep,                                           \
      eqk_energy_tbl en,                                               \
      eqm_equipment_tbl ee,                                             \
      eqi_compensator_tbl tp                                         \
    where l.id_point=ep.id and l.id_eqp=ee.id                        \
        and en.id=l.kind_energy  and l.id_type_eqp=tp.id             \
 union                                                                  \
select l.id_doc,l.id_point,l.num,ep.name_eqp as point_name,            \
 ee.name_eqp as eqp_name,                                             \
 l.dat_b,l.dat_e,l.type_eqm,l.id_type_eqp,                           \
 tp.type as eqp_type,l.dat_b,l.dat_e,                                 \
 l.sn_len,l.tt,l.tw,l.pxx_r0,l.pkz_x0,l.ixx,l.ukz_un,                           \
 l.wp, l.wq,l.wp1,l.s_xx_addwp,l.s_kz_addwq,                           \
 en.name as energy,l.dw,l.res_l,l.in_demand                                                 \
from (select *  from acd_calc_losts_tbl  where  id_doc = :pid_doc and type_eqm=6) as l,       \
   eqm_equipment_tbl ep,                                               \
   eqk_energy_tbl en,                                                  \
     eqm_equipment_tbl ee, eqi_cable_tbl tp                            \
  where l.id_point=ep.id and l.id_eqp=ee.id and en.id=l.kind_energy    \
   and l.id_type_eqp=tp.id                                             \
union                                                                   \
select l.id_doc,l.id_point,l.num,ep.name_eqp as point_name,             \
 ee.name_eqp as eqp_name,                                               \
 l.dat_b,l.dat_e,l.type_eqm,l.id_type_eqp,                              \
 tp.type as eqp_type,l.dat_b,l.dat_e,                                   \
 l.sn_len,l.tt,l.tw,l.pxx_r0,l.pkz_x0,l.ixx,l.ukz_un,                            \
 l.wp, l.wq,l.wp1,l.s_xx_addwp,l.s_kz_addwq,                            \
 en.name as energy,l.dw,l.res_l ,l.in_demand                                                 \
from (select *  from acd_calc_losts_tbl  where  id_doc = :pid_doc and type_eqm=7) as l,        \
   eqm_equipment_tbl ep,                                                \
   eqk_energy_tbl en,                                                   \
     eqm_equipment_tbl ee, eqi_corde_tbl tp                             \
  where l.id_point=ep.id and l.id_eqp=ee.id and en.id=l.kind_energy     \
   and l.id_type_eqp=tp.id                                              \
) as a order by id_doc,id_point,num                                     \
) ob, \
(select id_client,id_point,c.code,c.short_name,num_eqp \
              from eqv_pnt_met e ,clm_client_tbl c where e.id_client=c.id) cl \
where cl.id_point=ob.id_point order by cl.code,id_doc,num_eqp,num \
");

 QuerLost1->ParamByName("pid_doc")->AsInteger=id_bill;
  DBGrLost1=new TWTDBGrid(this, QuerLost1);
  TWTPanel* PLost1=MainPanel->InsertPanel(19,true,300);
  PLost1->Params->AddGrid(DBGrLost1, true)->ID="HLost1";
  TWTQuery* Query = DBGrLost1->Query;
  Query->Open();
     TStringList *WList=new TStringList();
    //WList->Add("id_doc");
    TStringList *NList=new TStringList();
    //NList->Add("client");
    Query->SetSQLModify("acd_calc_losts_tbl",WList,NList,false,false,false);

  TWTField *Field;
  Field = DBGrLost1->AddColumn("code", "�������", "�������");
  Field = DBGrLost1->AddColumn("short_name", "����.��� �����", "�������, �������� ����������� ����� �����");
  Field = DBGrLost1->AddColumn("point_name", "����� �����", "����� �����");  //!!!
  Field = DBGrLost1->AddColumn("eqp_name", "������������", "������������");
    Field = DBGrLost1->AddColumn("num_eqp", "� ��������", "� ��������");
  Field = DBGrLost1->AddColumn("num", "�������", "������������������ � �������");
   Field = DBGrLost1->AddColumn("in_demand", "���-��", "���-��");
  Field = DBGrLost1->AddColumn("res_l", "���", "��� �������");
     Field->AddFixedVariable("0", "�� ��������       ");
     Field->AddFixedVariable("1",  "���������� �������");
     Field->AddFixedVariable("2",  "������� �������");
     Field->AddFixedVariable("3",  "������ ��. �� ��� ");

  Field = DBGrLost1->AddColumn("dw", "������", "������");
  Field = DBGrLost1->AddColumn("wp", "���.����", "�������� �����������");
  Field = DBGrLost1->AddColumn("wq", "�����.����", "���������� �����������");
  Field = DBGrLost1->AddColumn("wp1", "������", "������ ����������� �� ������������� (��� ���������)");

  Field = DBGrLost1->AddColumn("s_xx_addwp", "������ ��/ ���.����. �����", "������ �� ������. ��� ���������� ����.�����");
  Field = DBGrLost1->AddColumn("s_kz_addwq", "������ ��", "������ ��������� ���������");

  Field = DBGrLost1->AddColumn("dat_b", "���", "� ����");
  Field = DBGrLost1->AddColumn("dat_e", "���.", "�� ����");
  Field = DBGrLost1->AddColumn("eqp_type", "��� ������������", "��� ������������");
  Field = DBGrLost1->AddColumn("sn_len", "���.��� / ����� �����", "����������� �������� ������������� ��� ����� ��� �����");
  Field = DBGrLost1->AddColumn("tt", "����� (�)", "����� ������ ������������");
  Field = DBGrLost1->AddColumn("tw", "�����.����� (�)", "����� ������ �� ����� �����");
  Field = DBGrLost1->AddColumn("pxx_r0", "��� ��/ ���.����", "������ �� �����. ��� ���.����  ��� �����");  //!!!
  Field = DBGrLost1->AddColumn("pkz_x0", "��� ��/ �����.����", "������ �� �����. ��� �����.���� ��� �����");  //!!!
  Field = DBGrLost1->AddColumn("ixx", "��� ��", "��� ��������� ���� ������.");
  Field = DBGrLost1->AddColumn("ukz_un", "����. ��/ ������� ����.","���� �� �����. ��� ������� ����������  ��� �����");
  Field = DBGrLost1->AddColumn("energy", "��� �������", "��� �������");


  TWTPanel* PLost2=MainPanel->InsertPanel(200,true,200);

  QuerL2=new TWTQuery(this);

  QuerL2->Sql->Add(" \
  select cl.code,cl.short_name,cl.num_eqp,ob.* from \
 (                                                   \
   select l.*,ep.name_eqp                             \
    from (select *  from acd_pwr_demand_tbl where id_doc=:pid_doc ) as l, \
      eqm_equipment_tbl ep,                                               \
      eqk_energy_tbl en                                                    \
    where l.id_point=ep.id         and en.id=l.kind_energy                 \
 ) ob,                                                                     \
(select id_client,id_point,c.code,c.short_name,num_eqp                     \
              from eqv_pnt_met e ,clm_client_tbl c where e.id_client=c.id) cl  \
where cl.id_point=ob.id_point order by cl.code,id_doc,num_eqp ");

  QuerL2->ParamByName("pid_doc")->AsInteger=id_bill;

  DBGrLost2=new TWTDBGrid(this, QuerL2);

  PLost2->Params->AddText("������ �� ������  ",18,F,Classes::taCenter,false);
  PLost2->Params->AddGrid(DBGrLost2, true)->ID="HLost2";


  TWTQuery* QueryL2 = DBGrLost2->Query;
  QueryL2->AddLookupField("name_energy","KIND_ENERGY","eqk_energy_tbl","name","id");
  QueryL2->AddLookupField("Zone","ID_ZONE","eqk_zone_tbl","name","id"); // ����� Name

  QueryL2->Open();

  TStringList *WListI=new TStringList();
    WListI->Add("id");
  TStringList *NListI=new TStringList();

  QueryL2->SetSQLModify("acd_pwr_demand_tbl",WListI,NListI,false,false,false);
  TWTField *Field2;

  Field2 = DBGrLost2->AddColumn("code", "�������", "�������");
  Field2 = DBGrLost2->AddColumn("short_name", "����.��� �����", "�������, �������� ����������� ����� �����");
  Field2 = DBGrLost2->AddColumn("name_eqp", "����� �����", "����� �����");  //!!!
  Field2 = DBGrLost2->AddColumn("num_eqp", "� ��������", "� ��������");
  Field2 = DBGrLost2->AddColumn("name_energy", "�������", "��� �������");
  Field2->SetWidth(50);
  Field2 = DBGrLost2->AddColumn("Zone", "����", "����");
  Field2->SetWidth(50);

  Field2 = DBGrLost2->AddColumn("dat_b", "C", "�");
  Field2->SetWidth(120);
  Field2 = DBGrLost2->AddColumn("dat_e", "��", "��");
  Field2->SetWidth(120);

  Field2 = DBGrLost2->AddColumn("sum_demand", "���.����.", "�����������");
  Field2->SetReadOnly();
  Field2 = DBGrLost2->AddColumn("fact_demand", "����.����.", "");
  Field2->SetWidth(80);
  Field2 = DBGrLost2->AddColumn("sum_losts", "���.������.", "");
  Field2->SetReadOnly();
  Field2 = DBGrLost2->AddColumn("fact_losts", "����.������", "");
  Field2->SetWidth(80);
  Field2 = DBGrLost2->AddColumn("ident", "�������������", "");
  Field2->SetReadOnly();
 /*
  Field2 = DBGrLost2->AddColumn("doubl2_demand", "2 ������", "");
  Field2->SetReadOnly();
  */

  Field2 = DBGrLost2->AddColumn("in_res_losts", "�����.�� ���", "");
  Field2->SetReadOnly();

  Field2 = DBGrLost2->AddColumn("out_res_losts", "����.�� ���", "");
  Field2->SetReadOnly();


  Field2 = DBGrLost2->AddColumn("abn_losts", "����.", "");
  Field2->SetReadOnly();



  DBGrLost2->Visible = true;

  DBGrLost1->Visible = true;
  SetCaption("������  ");
  ShowAs(WinName);
  MainPanel->ParamByID("HLost1")->Control->SetFocus();
  MainPanel->ParamByID("HLost2")->Control->SetFocus();

 }
#undef WinName

void __fastcall  TfLost::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}


__fastcall TfLost::~TfLost()
{
//   GrDetIndic->DataSource->DataSet->Refresh();
//   GrDetIndic->Refresh();

  Close();
};




