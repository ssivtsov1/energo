//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "f2kAct.h"
#include "Query.h"
#include "Table.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPrint2krAct *fPrint2krAct;
//---------------------------------------------------------------------------
__fastcall TfPrint2krAct::TfPrint2krAct(TComponent* Owner)
        : TForm(Owner)
{
  ZQXLReps->Database=TWTTable::Database;
  ZQXLReps2->Database=TWTTable::Database;

  ZQuery = new TWTQuery(Application);
  ZQuery->MacroCheck=true;
  ZQuery->Options<< doQuickOpen;
  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

}
//---------------------------------------------------------------------------

void TfPrint2krAct::PrintAktDem(TDateTime mmgg,int client, int bill)
{
/*
  AnsiString  sqlstr1=" select abon.name as abonname, \
  abon.short_name as abonname, abon.code, res.name as resname,res.short_name as ressname, \
  addr.full_adr as abonaddr, abonpar.doc_num, abonpar.doc_dat, \
  text(lim.limit_demand::::int)||' к¬тг.' as limit_demands, text(bill.fact_demand)||' к¬тг.' as fact_demands, \
  (case when   to_char( over.mmgg,'mm')<>'01' then \
  date(to_char( over.mmgg,'yyyy')||'-'||to_char( over.mmgg-'1 month'::::interval,'mm')||'-'||text(abonpar.dt_start)) \
  else \
   date(to_char( over.mmgg-'1 year'::::interval,'yyyy')||'-'||to_char( over.mmgg-'1 month'::::interval,'mm')||'-'||text(abonpar.dt_start)) \
   end ) as dt_b, \
  date(to_char( over.mmgg,'yyyy')||'-'||to_char( over.mmgg,'mm')||'-'||text(abonpar.dt_indicat)) as dt_e, \
  over.reg_date, text(over.over_demand)||' к¬тг.' as over_demands,\
  lim.limit_demand,bill.fact_demand,over.over_demand, \
  'A2D'||abon.code||'_'||to_char( :mmgg::::date,'mm')||'-'||to_char( :mmgg::::date,'yyyy') as act_num, \
  indic.reg_date as indic_date, over.value, over.value_tax, \
  'є '||text(abonpar.doc_num)||' в≥д '|| to_char(abonpar.doc_dat,'DD.MM.YYYY')||' р.' as docum_info, \
  boss.name as bospos,boss.represent_name as bossname \
  from \
  clm_client_tbl as abon \
  left join adv_address_tbl as addr on (addr.id = abon.id_addres) \
  left join clm_statecl_tbl as abonpar on (abonpar.id_client = abon.id) , \
  (select value_dem as limit_demand from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l \
  on (hl.id_doc = l.id_doc) \
  where hl.id_client = :client and date_trunc('month',l.month_limit)  = :mmgg \
  and hl.reg_date <= :mmgg \
  order by hl.reg_date desc limit 1) as lim , \
  (select sum(demand_val) as fact_demand, min(b.dat_b) as dt_b, max(b.dat_e) as dt_e  \
  from acm_bill_tbl as b \
  where b.mmgg = :mmgg and b.mmgg_bill = :mmgg \
  and b.id_client = :client \
  and b.id_pref = 10 and b.idk_doc = 200  ) as bill, \
  (select demand_val as over_demand, reg_date, value, value_tax,mmgg  \
  from acm_bill_tbl  \
  where mmgg = :mmgg and  id_client = :client \
  and id_pref = 520 and idk_doc = 210 limit 1 ) as over, \
  (select reg_date from acm_headindication_tbl where mmgg = :mmgg and idk_document =310 and id_client = :client limit 1) as indic, \
  clm_client_tbl as res \
   left join ( select * from clm_position_tbl as pos \
             join cli_position_tbl as p on (p.id = pos.id_position and p.ident ='boss') )as boss  on (boss.id_client = res.id) \
  where abon.id = :client \
  and res.id = syi_resid_fun();";
*/

  AnsiString sqlstr="select getsysvar('kod_res') as res;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

  try
  {
   ZQuery->Open();
  }
  catch(...)
  {
   ShowMessage("ќшибка SQL :"+sqlstr);
   return;
  }
   int kod_res = ZQuery->FieldByName("res")->AsInteger;
   ZQuery->Close();



  AnsiString  sqlstr1=" select abon.name as abonname, \
  abon.short_name as abonname, abon.code, res.name as resname,res.short_name as ressname, \
  addr.full_adr as abonaddr, abonpar.doc_num, abonpar.doc_dat, \
  over.reg_date, lim.limit_demand, bill.fact_demand,over.over_demand, \
  indic.reg_date as indic_date, over.value, over.value_tax, \
  'є '||text(abonpar.doc_num)||' в≥д '|| to_char(abonpar.doc_dat,'DD.MM.YYYY')||' р.' as docum_info, \
  boss.name as bospos,boss.represent_name as bossname , old_over.old_over_demand , over.mmgg \
  from \
  clm_client_tbl as abon \
  left join adv_address_tbl as addr on (addr.id = abon.id_addres) \
  left join clm_statecl_tbl as abonpar on (abonpar.id_client = abon.id) , \
  (select value_dem as limit_demand from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l \
   on (hl.id_doc = l.id_doc) \
   where hl.id_client = :client and date_trunc('month',l.month_limit)  = :mmgg \
   and hl.reg_date <= :mmgg::::date + '1 month - 1 days'::::interval \
   and idk_document = 600 \
   order by hl.reg_date desc limit 1 \
  ) as lim , \
  (select coalesce(sum(bs.demand_val),0) as fact_demand, min(b.dat_b) as dat_b, max(b.dat_e) as dat_e \
   from acm_bill_tbl as b \
   join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc) \
   join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) \
   join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) \
   where b.mmgg = :mmgg \
   and b.id_client = :client \
   and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) \
   and ((tgr.ident !~'tgr7' and tgr.ident !~'tgr8') or ( :kod_res <>310 )) \
  ) as bill, \
  (select demand_val as over_demand, reg_date, value, value_tax,mmgg  \
   from acm_bill_tbl  \
   where mmgg = :mmgg and  id_client = :client \
   and id_pref in ( 520,524)  and idk_doc = 210 and id_doc = :id_doc \
  ) as over, \
  (select sum(demand_val) as old_over_demand    \
   from acm_bill_tbl  \
   where mmgg = :mmgg and  id_client = :client \
   and id_pref in (520,524) and idk_doc = 210 and id_doc <> :id_doc \
  ) as old_over, \
  (select reg_date from acm_headindication_tbl where mmgg = :mmgg and idk_document =310 and id_client = :client limit 1) as indic, \
  clm_client_tbl as res \
   left join ( select * from clm_position_tbl as pos \
             join cli_position_tbl as p on (p.id = pos.id_position and p.ident ='boss') )as boss  on (boss.id_client = res.id) \
  where abon.id = :client \
  and res.id = syi_resid_fun();";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);

  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->ParamByName("client")->AsInteger=client;
  ZQXLReps->ParamByName("id_doc")->AsInteger=bill;
  ZQXLReps->ParamByName("kod_res")->AsInteger=kod_res;

  try
  {
    ZQXLReps->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("ќшибка : "+e.Message.SubString(8,200));
    return;
  }

  xlReport->XLSTemplate = "XL\\akt_2kdnew.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReport->DataSources->Clear();


  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Alias = "ZQXLReps";
//  Dsr->Range = "Range";

  xlReport->Params->Clear();
//  Param=xlReport->Params->Add();
//  Param->Name="lres";
//  Param=xlReport->Params->Add();
//  Param->Name="lmmgg";

//  Param=xlReport->Params->Add();
//  Param->Name="lnow";
//  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());


//  xlReport->ParamByName["lres"]->Value = ResName;
//  xlReport->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);

//  xlReport->ParamByName["workdt"]->Value = dt;

 xlReport->Report();

 ZQXLReps->Close();

}
//------------------------------------------------------------------------------
void TfPrint2krAct::PrintAktDemArea(TDateTime mmgg,int client, int bill)
{

  AnsiString sqlstr="select getsysvar('kod_res') as res;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

  try
  {
   ZQuery->Open();
  }
  catch(...)
  {
   ShowMessage("ќшибка SQL :"+sqlstr);
   return;
  }
   int kod_res = ZQuery->FieldByName("res")->AsInteger;
   ZQuery->Close();


  AnsiString  sqlstr1=" select abon.name as abonname, \
  abon.short_name as abonname, abon.code, res.name as resname,res.short_name as ressname, \
  addr.full_adr as abonaddr, abonpar.doc_num, abonpar.doc_dat, \
  indic.reg_date as indic_date,  \
  'є '||text(abonpar.doc_num)||' в≥д '|| to_char(abonpar.doc_dat,'DD.MM.YYYY')||' р.' as docum_info, \
  boss.name as bospos,boss.represent_name as bossname, b.value, b.value_tax, b.mmgg   \
  from \
  clm_client_tbl as abon \
  left join adv_address_tbl as addr on (addr.id = abon.id_addres) \
  left join clm_statecl_tbl as abonpar on (abonpar.id_client = abon.id) , \
  (select reg_date from acm_headindication_tbl where mmgg = :mmgg and idk_document =310 and id_client = :client limit 1) as indic, \
  clm_client_tbl as res \
   left join ( select * from clm_position_tbl as pos \
             join cli_position_tbl as p on (p.id = pos.id_position and p.ident ='boss') )as boss  on (boss.id_client = res.id), \
  ( select value, value_tax, mmgg from acm_bill_tbl where id_doc = :doc ) as b   \
  where abon.id = :client \
  and res.id = syi_resid_fun();";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);

  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->ParamByName("client")->AsInteger=client;
  ZQXLReps->ParamByName("doc")->AsInteger=bill;
//  ZQXLReps->ParamByName("kod_res")->AsInteger=kod_res;


  AnsiString  sqlstr2="  select a.name_eqp||coalesce('   /'||adr.adr||'/','') as area_adr, a.name_eqp as area, \
  bs.id_area,bs.power_limit,bs.power_fact,bs.power_ower,bs.power_bill,bs.power_trans, bs.tarif,bs.sum_value \
  from acd_pwr_limit_over_tbl as bs \
  left join \
  (select eq.id, eq.name_eqp,eq.id_addres from eqm_equipment_h as eq \
    join (select id, max(dt_b) as dt from eqm_equipment_h  where dt_b <= :mmgg and coalesce(dt_e, :mmgg) >= :mmgg  and type_eqp = 11 group by id) as eq2 \
    on (eq.id = eq2.id and eq2.dt = eq.dt_b) \
  )as a on (bs.id_area = a.id) \
  left join adv_address_tbl as adr on (adr.id = a.id_addres) \
  where (bs.id_doc = :doc) \
  order by area ;";

  ZQXLReps2->Sql->Clear();
  ZQXLReps2->Sql->Add(sqlstr2);

  ZQXLReps2->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps2->ParamByName("doc")->AsInteger=bill;

  try
  {
    ZQXLReps->Open();
    ZQXLReps2->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("ќшибка : "+e.Message.SubString(8,200));
    return;
  }

  xlReport->XLSTemplate = "XL\\akt_2kdarea.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReport->DataSources->Clear();

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Alias = "ZQXLReps";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps2;
  Dsr->Alias = "ZQXLReps2";
  Dsr->Range = "Range";

  xlReport->Params->Clear();


 xlReport->Report();

 ZQXLReps->Close();
 ZQXLReps2->Close();

}

//------------------------------------------------------------------------------
void TfPrint2krAct::PrintAktDemAreaSum(TDateTime mmgg,int client, int bill)
{

  AnsiString sqlstr="select getsysvar('kod_res') as res;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

  try
  {
   ZQuery->Open();
  }
  catch(...)
  {
   ShowMessage("ќшибка SQL :"+sqlstr);
   return;
  }
   int kod_res = ZQuery->FieldByName("res")->AsInteger;
   ZQuery->Close();


  AnsiString  sqlstr1=" select abon.name as abonname, \
  abon.short_name as abonname, abon.code, res.name as resname,res.short_name as ressname, \
  addr.full_adr as abonaddr, abonpar.doc_num, abonpar.doc_dat, \
  indic.reg_date as indic_date,  \
  'є '||text(abonpar.doc_num)||' в≥д '|| to_char(abonpar.doc_dat,'DD.MM.YYYY')||' р.' as docum_info, \
  boss.name as bospos,boss.represent_name as bossname, b.value, b.value_tax, b.mmgg, bl.*   \
  from \
  clm_client_tbl as abon \
  left join adv_address_tbl as addr on (addr.id = abon.id_addres) \
  left join clm_statecl_tbl as abonpar on (abonpar.id_client = abon.id) , \
  (select reg_date from acm_headindication_tbl where mmgg = :mmgg and idk_document =310 and id_client = :client limit 1) as indic, \
  clm_client_tbl as res \
   left join ( select * from clm_position_tbl as pos \
             join cli_position_tbl as p on (p.id = pos.id_position and p.ident ='boss') )as boss  on (boss.id_client = res.id), \
  ( select value, value_tax, mmgg from acm_bill_tbl where id_doc = :doc ) as b ,  \
  ( select sum(power_limit) as power_limit, sum(power_fact) as power_fact,  sum(power_ower) as power_ower, \
    sum(power_trans) as power_trans, sum(power_bill) as power_bill, max(tarif) as tarif \
    from acd_pwr_limit_over_tbl where id_doc = :doc ) as bl   \
  where abon.id = :client \
  and res.id = syi_resid_fun();";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);

  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->ParamByName("client")->AsInteger=client;
  ZQXLReps->ParamByName("doc")->AsInteger=bill;
//  ZQXLReps->ParamByName("kod_res")->AsInteger=kod_res;


  AnsiString  sqlstr2="  select a.name_eqp||coalesce('   /'||adr.adr||'/','') as area_adr, a.name_eqp as area, \
  bs.id_area,bs.power_limit,bs.power_fact,bs.power_ower,bs.power_bill,bs.power_trans, bs.tarif,bs.sum_value \
  from acd_pwr_limit_over_tbl as bs \
  left join \
  (select eq.id, eq.name_eqp,eq.id_addres from eqm_equipment_h as eq \
    join (select id, max(dt_b) as dt from eqm_equipment_h  where dt_b <= :mmgg and coalesce(dt_e, :mmgg) >= :mmgg  and type_eqp = 11 group by id) as eq2 \
    on (eq.id = eq2.id and eq2.dt = eq.dt_b) \
  )as a on (bs.id_area = a.id) \
  left join adv_address_tbl as adr on (adr.id = a.id_addres) \
  where (bs.id_doc = :doc) \
  order by area ;";

  ZQXLReps2->Sql->Clear();
  ZQXLReps2->Sql->Add(sqlstr2);

  ZQXLReps2->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps2->ParamByName("doc")->AsInteger=bill;

  try
  {
    ZQXLReps->Open();
    ZQXLReps2->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("ќшибка : "+e.Message.SubString(8,200));
    return;
  }

  xlReport->XLSTemplate = "XL\\akt_2kdarea_sum.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReport->DataSources->Clear();

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Alias = "ZQXLReps";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps2;
  Dsr->Alias = "ZQXLReps2";
  Dsr->Range = "Range";

  xlReport->Params->Clear();


 xlReport->Report();

 ZQXLReps->Close();
 ZQXLReps2->Close();

}



//---------------------------------------------------------------------------
void __fastcall TfPrint2krAct::BitBtn1Click(TObject *Sender)
{

  AnsiString sqlstr="select id_pref, idk_doc from acm_bill_tbl where id_doc = :doc ;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("doc")->AsInteger=id_doc;

  try
  {
   ZQuery->Open();
  }
  catch(...)
  {
   ShowMessage("ќшибка SQL :"+sqlstr);
   return;
  }

  idk_doc =ZQuery->FieldByName("idk_doc")->AsInteger;
  ZQuery->Close();

 if ((id_pref == 520)||(id_pref == 524))
 {
  if (idk_doc==210)
  {
   if (mmgg >= TDateTime(2013,1,1))
   {
    PrintAktDemArea(mmgg,id_client,id_doc);
   }
   else
   {
    PrintAktDem(mmgg,id_client,id_doc);
   }
  }

  if (idk_doc==212) //лимит по площадкам, превышение по общей сумме
  {
    PrintAktDemAreaSum(mmgg,id_client,id_doc);
  }

 }

}
//---------------------------------------------------------------------------

