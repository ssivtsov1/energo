//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fBillAct.h"
#include "Query.h"
#include "Table.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPrintBillAkt *fPrintBillAkt;
//---------------------------------------------------------------------------
__fastcall TfPrintBillAkt::TfPrintBillAkt(TComponent* Owner)
        : TForm(Owner)
{
  ZQXLReps->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------

void TfPrintBillAkt::PrintAkt(int id_bill)
{

  AnsiString  sqlstr1=" select abon.name as abonname, substr_word(abon.name,0,53) as abonname1, substr(abon.name,length(substr_word(abon.name,0,53))+1,200) as abonname2, \
  users.represent_name as usrname, cla.name as grpname, users.phone as usrphone,\
  abon.short_name as abonsname, abon.code, res.name as resname,res.short_name as ressname, \
  abonpar.doc_num, abonpar.doc_dat,  b.dat_b,b.dat_e, b.demand_val, b.reg_date, b.value, b.value_tax, b.mmgg, b.mmgg_bill,b.id_pref, \
  CASE WHEN coalesce(abonpar.doc_num_tend,'')='' THEN 'Згідно договору про постачання електричної енергії від '||to_char(abonpar.doc_dat,'DD.MM.YYYY')||' р. № '||text(abonpar.doc_num) \
       ELSE 'Згідно договору про закупівлю товарів за державні кошти від '||to_char(abonpar.doc_dat_tend,'DD.MM.YYYY')||' р. № '||text(abonpar.doc_num_tend) END as docum_info, \
   to_char(abonpar.doc_dat,'DD.MM.YYYY')||' р. № '||text(abonpar.doc_num) as docum_short_info, \
  to_char(b.reg_date,'DD.MM.YYYY')||' р. № '||text(b.reg_num) as bill_info, \
  coalesce(kt.shot_name, 'м.')||t.name as town, boss.represent_name as bossname , abn_boss, \
  coalesce(bs1.demand_val1,0) as demand_val1, coalesce(bs2.demand_val2,0) as demand_val2, bs1.sum_val1, bs2.sum_val2 \
  from  clm_client_tbl as abon \
  join acm_bill_tbl as b on (b.id_client = abon.id) \
  left join (select bs.id_doc, sum(demand_val)::::numeric as demand_val1, sum(sum_val)::::numeric as sum_val1 \
  from acd_billsum_tbl as bs \
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) \
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) \
  where bs.id_doc = :bill and tcl.ident = 'tcl1' \
  group by bs.id_doc ) as bs1 on (bs1.id_doc = b.id_doc) \
  left join (select bs.id_doc, sum(demand_val)::::numeric as demand_val2, sum(sum_val)::::numeric as sum_val2 \
  from acd_billsum_tbl as bs \
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) \
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) \
  where bs.id_doc = :bill and tcl.ident = 'tcl2' \
  group by bs.id_doc ) as bs2 on (bs2.id_doc = b.id_doc) \
  left join clm_statecl_tbl as abonpar on (abonpar.id_client = abon.id) \
  left join cla_param_tbl as cla on ( abonpar.id_section = cla.id and cla.id_group = 200) \
  left join clm_position_tbl as users on (users.id = b.id_person) \
  left join ( select pos.id_client, pos.represent_name as abn_boss, p.name as position  \
            from clm_position_tbl as pos \
            join cli_position_tbl as p on (p.id = pos.id_position) \
            left join (select pos2.id_client,min(pos2.id) as minid  from clm_position_tbl as pos2 \
                  join cli_position_tbl as p2 on (p2.id = pos2.id_position and p2.ident ='boss') \
                  group by pos2.id_client order by minid ) as p_1 on (p_1.minid = pos.id ) \
            left join (select pos3.id_client,count(*) as cnt  from clm_position_tbl as pos3 \
                  group by pos3.id_client) as pc on (pc.id_client = pos.id_client ) \
    where ((p_1.minid is not null ) or (pc.cnt = 1))  \
    order by id_client  ) as ab on ( ab.id_client = abon.id)  , \
  ( select * from clm_client_tbl where id = syi_resid_fun() ) as res \
  left join adm_address_tbl as addr on (addr.id = res.id_addres) \
  left join adi_street_tbl as st on (addr.id_street = st.id) \
  left join adi_town_tbl as t on (st.id_town = t.id) \
  LEFT JOIN adk_town_tbl as kt ON (t.idk_town = kt.id ) \
  left join ( select * from clm_position_tbl as pos \
             join cli_position_tbl as p on (p.id = pos.id_position and p.ident ='boss') )as boss  on (boss.id_client = res.id) \
  where b.id_doc = :bill ;";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);

  ZQXLReps->ParamByName("bill")->AsInteger=id_bill;
 // ZQXLReps->ParamByName("client")->AsInteger=client;

  try
  {
    ZQXLReps->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

  switch ( ZQXLReps->FieldByName("id_pref")->AsInteger ) {
  case 20  : xlReport->XLSTemplate = "XL\\akt_bill_re.xls"; break;
  case 110 : xlReport->XLSTemplate = "XL\\akt_bill_transit.xls"; break;
  case 120 : xlReport->XLSTemplate = "XL\\akt_bill_info.xls"; break;
  default : xlReport->XLSTemplate = "XL\\akt_bill.xls";

}

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

  xlReport->MacroAfter = "FormatData";
  xlReport->Report();
  xlReport->MacroAfter = "";


 ZQXLReps->Close();

}
//---------------------------------------------------------------------------
void __fastcall TfPrintBillAkt::BitBtn1Click(TObject *Sender)
{
 //if (id_pref = 520)
 {
   PrintAkt(id_bill);
 }

}
//---------------------------------------------------------------------------

