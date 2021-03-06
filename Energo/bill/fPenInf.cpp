//---------------------------------------------------------------------------


#include <vcl.h>
#pragma hdrstop

#include "fPenInf.h"
#include "Query.h"
#include "Table.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPenaInflPrint *fPenaInflPrint;
TDateTime WorkDate;
//---------------------------------------------------------------------------
__fastcall TfPenaInflPrint::TfPenaInflPrint(TComponent* Owner)
        : TForm(Owner)
{
  ZQXLRepMain->Database=TWTTable::Database;
  ZQXLRepPen_a->Database=TWTTable::Database;
  ZQXLRepPen_r->Database=TWTTable::Database;
  ZQXLRep3Proc_a->Database=TWTTable::Database;
  ZQXLRep3Proc_r->Database=TWTTable::Database;
  ZQXLRepInf_a->Database=TWTTable::Database;
  ZQXLRepInfDoc_a->Database=TWTTable::Database;
  ZQXLRepInf_r->Database=TWTTable::Database;
  ZQXLRepInfDoc_r->Database=TWTTable::Database;

  ZQReps = new TWTQuery(Application);
  ZQReps->MacroCheck=true;
  ZQReps->Options<< doQuickOpen;
  ZQReps->RequestLive=false;
  ZQReps->CachedUpdates=false;
//  ZQReps->Transaction->AutoCommit=true;


  Word year1;
  Word month1;
  Word day1;

  DecodeDate(Now(),year1,month1,day1);


  WorkDate = EncodeDate(year1,month1,1);
  dtBegin->Date=WorkDate;
  dtEnd->Date=IncMonth(dtBegin->Date,1)-1;
  dtBegin->Time=0;
  dtEnd->Time=0;
  edMonth->Text=FormatDateTime("mmmm yyyy",WorkDate);


}
//---------------------------------------------------------------------------

void TfPenaInflPrint::PrintAkt(int client)
{
/*
   AnsiString sqlstr=" select seb_obr( (date_trunc('month', :mmgg::::date))::::date )";

   ZQReps->Close();
   ZQReps->Sql->Clear();
   ZQReps->Sql->Add(sqlstr);
   ZQReps->ParamByName("mmgg")->AsDateTime=dtBegin->Date;

   try
   {
    ZQReps->ExecSql();
   }
   catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    return;
   }

//  left join seb_obr on (seb_obr.id_client = abon.id and seb_obr.period = date_trunc('month',:dte::::date) ) \
//  left join seb_obrr on (seb_obrr.id_client = abon.id and seb_obrr.period = date_trunc('month',:dte::::date)), \

// -seb_obr.deb_kmv as deb_ae, -seb_obrr.deb_kmv as deb_re, \

 */

  AnsiString  sqlstr1=" select abon.name as abonname, \
  abon.short_name as abonsname, abon.code, res.name as resname,res.short_name as ressname, \
  'PI'||Text(abon.code)||'_'||to_char(:dtb::::date,'mm')||'-'||to_char(:dtb::::date,'yyyy') as newbill_num, \
  addr.full_adr ||', ���. '||abonpar.phone as abonaddrph ,  addr.full_adr as abonaddr, \
  abonpar.doc_num, abonpar.doc_dat, abonpar.dt_indicat, text(abonpar.day_pay_bill)||' ����������� ���' as day_pay_bill ,abonpar.okpo_num as abon_okpo_num, \
  respar.okpo_num,respar.phone as resphone, raddr.full_adr as resaddr, \
  respar.tax_num,respar.licens_num, \
  racc.mfo as amfo,racc.account as aaccount,abank.name as abankname, \
  rrcc.mfo as rmfo,rrcc.account as raccount,rbank.name as rbankname, \
  pen_sb.sb_a,pen_sb.sb_r, \
  saldop.e_val  as deb_p, saldoi.e_val  as deb_i, saldoproc.e_val  as deb_proc, \
  bill_infl.sum_infl_a,bill_infl.sum_infl_r, bill_infl.sum_infl_i, \
  bill_infl.sum_infl_a+bill_infl.sum_infl_r+bill_infl.sum_infl_i as sum_infl, \
  bill_infl.sum_infl_a+bill_infl.sum_infl_i as sum_infl_ai, \
  bill_pen.sum_pen_a,bill_pen.sum_pen_r, bill_pen.sum_pen_a+bill_pen.sum_pen_r as sum_pen, \
  bill_3_proc.sum_3_proc_a,bill_3_proc.sum_3_proc_r, bill_3_proc.sum_3_proc_a+bill_3_proc.sum_3_proc_r as sum_3_proc, \
  '��������� '||cp.represent_name as inspector, \
  :dtb::::date as dt_from, ( :dte::::date + 1 )::::date as dt_to, to_char( :dtb::::date,'DD.MM.YYYY')||' - '||to_char( ( :dte::::date + 1 )::::date,'DD.MM.YYYY')||' ��.' as doc_interval, \
  usr.represent_name, usr.name as posname, boss.name as bospos,boss.represent_name as bossname \
  from \
  clm_client_tbl as abon \
  left join adv_address_tbl as addr on (addr.id = abon.id_addres) \
  left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id) \
  left join clm_position_tbl as cp on (abonpar.id_position=cp.id) \
  left join acm_saldo_tbl as saldop on (saldop.id_client = abon.id and saldop.mmgg = date_trunc('month',:dtb::::date) and saldop.id_pref = 901) \
  left join acm_saldo_tbl as saldoi on (saldoi.id_client = abon.id and saldoi.mmgg = date_trunc('month',:dtb::::date) and saldoi.id_pref = 902) \
  left join acm_saldo_tbl as saldoproc on (saldoproc.id_client = abon.id and saldoproc.mmgg = date_trunc('month',:dtb::::date) and saldoproc.id_pref = 903), \
  clm_client_tbl as res \
  left join clm_statecl_tbl as respar on (respar.id_client = res.id) \
  left join adv_address_tbl as raddr on (raddr.id = res.id_addres) \
  left join cli_account_tbl as racc on (racc.id_client = res.id and racc.ident='act_ee') \
  left join cli_account_tbl as rrcc on (rrcc.id_client = res.id and rrcc.ident='react_ee') \
  left join cmi_bank_tbl as abank on (abank.id = racc.mfo) \
  left join cmi_bank_tbl as rbank on (rbank.id = rrcc.mfo) \
  left join ( select id_client, name , represent_name from clm_position_tbl as pos \
             join cli_position_tbl as p on (p.id = pos.id_position and p.ident ='boss') )as boss  on (boss.id_client = res.id) \
  left join (select users.represent_name,ip.name from  clm_position_tbl as users left join cli_position_tbl as ip  on (ip.id = users.id_position) \
  where users.id = GetSysVar('id_person') ) as usr on (1=1), \
  (select \
   coalesce(sum(case when clc.ident1 = 'act_ee' then clc.sum_inf else 0 end),0) as sum_infl_a, \
   coalesce(sum(case when clc.ident1 = 'react_ee' then clc.sum_inf else 0 end),0) as sum_infl_r, \
   coalesce(sum(case when clc.ident1 = 'inf' then clc.sum_inf else 0 end),0) as sum_infl_i \
   from acm_bill_tbl as b \
   join acd_clc_inf as clc on (clc.id_doc = b.id_doc) \
   where b.mmgg_bill >= date_trunc('month',:dtb::::date) and b.mmgg_bill <= date_trunc('month',:dte::::date) \
   and b.id_client = :client  and b.id_pref = 902 \
  ) as bill_infl, \
  (select \
   coalesce(sum(case when clc.ident1 = 'act_ee' then clc.sum_inf else 0 end),0) as sum_pen_a, \
   coalesce(sum(case when clc.ident1 = 'react_ee' then clc.sum_inf else 0 end),0) as sum_pen_r \
   from acm_bill_tbl as b \
   join acd_clc_inf as clc on (clc.id_doc = b.id_doc) \
   where b.mmgg_bill >= date_trunc('month',:dtb::::date) and b.mmgg_bill <= date_trunc('month',:dte::::date) \
   and b.id_client = :client  and b.id_pref = 901 \
  ) as bill_pen, \
  (select \
   coalesce(sum(case when sv.ident1 = 'act_ee' and sv.ident = 'sb' then sv.summ else 0 end),0) as sb_a, \
   coalesce(sum(case when sv.ident1 = 'react_ee' and sv.ident = 'sb' then sv.summ else 0 end),0) as sb_r \
   from acm_bill_tbl as b \
   join acd_summ_val as sv on (sv.id_doc = b.id_doc) \
   where b.mmgg_bill = date_trunc('month',:dtb::::date) \
   and b.id_client = :client  and b.id_pref = 901 \
  ) as pen_sb, \
      (select \
   coalesce(sum(case when clc.ident1 = 'act_ee' then clc.sum_inf else 0 end),0) as sum_3_proc_a, \
   coalesce(sum(case when clc.ident1 = 'react_ee' then clc.sum_inf else 0 end),0) as sum_3_proc_r \
   from acm_bill_tbl as b \
   join acd_clc_inf as clc on (clc.id_doc = b.id_doc) \
   where b.mmgg_bill >= date_trunc('month',:dtb::::date) and b.mmgg_bill <= date_trunc('month',:dte::::date) \
   and b.id_client = :client  and b.id_pref = 903 \
  ) as bill_3_proc \
  where abon.id = :client \
  and (res.id = syi_resid_fun() ) \
  and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <= :dte  )  ;";

  ZQXLRepMain->Close();
  ZQXLRepMain->Sql->Clear();
  ZQXLRepMain->Sql->Add(sqlstr1);

  ZQXLRepMain->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepMain->ParamByName("dte")->AsDateTime=dtEnd->Date;
  ZQXLRepMain->ParamByName("client")->AsInteger=client;

  ZQXLRepPen_a->ParamByName("client")->AsInteger=client;
  ZQXLRepPen_r->ParamByName("client")->AsInteger=client;
  ZQXLRep3Proc_a->ParamByName("client")->AsInteger=client;    //from yana
  ZQXLRep3Proc_r->ParamByName("client")->AsInteger=client;     //from yana
  ZQXLRepInf_a->ParamByName("client")->AsInteger=client;
  ZQXLRepInfDoc_a->ParamByName("client")->AsInteger=client;
  ZQXLRepInf_r->ParamByName("client")->AsInteger=client;
  ZQXLRepInfDoc_r->ParamByName("client")->AsInteger=client;

  ZQXLRepPen_a->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepPen_a->ParamByName("dte")->AsDateTime=dtEnd->Date;
  ZQXLRepPen_r->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepPen_r->ParamByName("dte")->AsDateTime=dtEnd->Date;

  ZQXLRep3Proc_a->ParamByName("dtb")->AsDateTime=dtBegin->Date;     //from yana
  ZQXLRep3Proc_a->ParamByName("dte")->AsDateTime=dtEnd->Date;       //from yana
  ZQXLRep3Proc_r->ParamByName("dtb")->AsDateTime=dtBegin->Date;     //from yana
  ZQXLRep3Proc_r->ParamByName("dte")->AsDateTime=dtEnd->Date;       //from yana

  ZQXLRepInf_a->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepInf_a->ParamByName("dte")->AsDateTime=dtEnd->Date;
  ZQXLRepInfDoc_a->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepInfDoc_a->ParamByName("dte")->AsDateTime=dtEnd->Date;

  ZQXLRepInf_r->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepInf_r->ParamByName("dte")->AsDateTime=dtEnd->Date;
  ZQXLRepInfDoc_r->ParamByName("dtb")->AsDateTime=dtBegin->Date;
  ZQXLRepInfDoc_r->ParamByName("dte")->AsDateTime=dtEnd->Date;

  ZQXLRepInfDoc_a->MasterSource=dsRepInf_a;
  ZQXLRepInfDoc_a->LinkFields="mmgg_bill = mmgg_bill";

  ZQXLRepInfDoc_r->MasterSource=dsRepInf_r;
  ZQXLRepInfDoc_r->LinkFields="mmgg_bill = mmgg_bill";

  try
  {
    ZQXLRepMain->Open();
    ZQXLRepPen_a->Open();
    ZQXLRepPen_r->Open();
    ZQXLRep3Proc_a->Open();   //from yana
    ZQXLRep3Proc_r->Open();    //from yana
    ZQXLRepInf_a->Open();
    ZQXLRepInfDoc_a->Open();
    ZQXLRepInf_r->Open();
    ZQXLRepInfDoc_r->Open();

  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQXLRepMain->Close();
    ZQXLRepPen_a->Close();
    ZQXLRepPen_r->Close();
    ZQXLRep3Proc_a->Close();   //from yana
    ZQXLRep3Proc_r->Close();   //from yana
    ZQXLRepInf_a->Close();
    ZQXLRepInfDoc_a->Close();
    ZQXLRepInf_r->Close();
    ZQXLRepInfDoc_r->Close();

    return;
  }

  xlReport->XLSTemplate = "XL\\pena_infl.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReport->DataSources->Clear();


  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepMain;
  Dsr->Alias = "ZQXLReps";
//  Dsr->Range = "Range";
  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepPen_a;
  Dsr->Alias = "ZQXLRepsPena";
  Dsr->Range = "Range_pa";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepPen_r;
  Dsr->Alias = "ZQXLRepsPenr";
  Dsr->Range = "Range_pr";

  Dsr = xlReport->DataSources->Add();       // from yana
  Dsr->DataSet = ZQXLRep3Proc_a;              // from yana
  Dsr->Alias = "ZQXLRepsProca";              // from yana
  Dsr->Range = "Range_proca";                  // from yana

  //Dsr = xlReport->DataSources->Add();       // from yana
  //Dsr->DataSet = ZQXLRep3Proc_r;              // from yana
  //Dsr->Alias = "ZQXLRepsProcr";              // from yana
  //Dsr->Range = "Range_procr";                  // from yana


  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepInf_a;
  Dsr->Alias = "ZQXLRepsInfA";
  Dsr->Range = "range_ia";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepInfDoc_a;
  Dsr->Alias = "ZQXLRepsInfADoc";
  Dsr->Range = "range_ia_docs";
  Dsr->MasterSourceName="ZQXLRepsInfA";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepInf_r;
  Dsr->Alias = "ZQXLRepsInfR";
  Dsr->Range = "range_ir";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepInfDoc_r;
  Dsr->Alias = "ZQXLRepsInfRDoc";
  Dsr->Range = "range_ir_docs";
  Dsr->MasterSourceName="ZQXLRepsInfR";

  
  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="pgp_count";
  Param=xlReport->Params->Add();
  Param->Name="pgi_count";
  Param=xlReport->Params->Add();
  Param->Name="pgproc_count";
  Param=xlReport->Params->Add();
  Param->Name="pen_add";
  Param=xlReport->Params->Add();
  Param->Name="inf_add";
  Param=xlReport->Params->Add();
  Param->Name="3_proc_add";
  Param=xlReport->Params->Add();
  Param->Name="add11";
  Param=xlReport->Params->Add();
  Param->Name="add12";
  Param=xlReport->Params->Add();
  Param->Name="add21";
  Param=xlReport->Params->Add();
  Param->Name="add22";
  Param=xlReport->Params->Add();

  Param=xlReport->Params->Add();     // from yana
  Param->Name="add31";               // from yana
  Param=xlReport->Params->Add();      // from yana
  Param->Name="add32";                // from yana
  Param=xlReport->Params->Add();
  Param->Name="lperiodstr";


  Param=xlReport->Params->Add();
  Param->Name="billdt";

  Word year1;
  Word month1;
  Word day1;

  Word year2;
  Word month2;
  Word day2;

  DecodeDate(dtBegin->Date,year1,month1,day1);
  DecodeDate(dtEnd->Date,year2,month2,day2);

  if(month1 == month2)
  {
    xlReport->ParamByName["lperiodstr"]->Value = FormatDateTime("mmmm yyyy",dtBegin->Date)+"�.";
  }
  else
  {
    xlReport->ParamByName["lperiodstr"]->Value = FormatDateTime("mmmm.yyyy",dtBegin->Date)+"�.-"+
     FormatDateTime("mmmm.yyyy",dtEnd->Date)+"�.";
  }



//  Param=xlReport->Params->Add();
//  Param->Name="lnow";

  if ((ZQXLRepMain->FieldByName("sum_pen_a")->AsFloat!=0)&&
       (ZQXLRepMain->FieldByName("sum_pen_r")->AsFloat!=0))
     {
      xlReport->ParamByName["pgp_count"]->Value = "(2 ���.)";
      xlReport->ParamByName["pen_add"]->Value = "(������� 1.1, 1.2)";
      xlReport->ParamByName["add11"]->Value = "������� 1.1";
      xlReport->ParamByName["add12"]->Value = "������� 1.2";
     }
  else
     {
      xlReport->ParamByName["pgp_count"]->Value = "(1 ���.)";
      xlReport->ParamByName["pen_add"]->Value = "(������� 1)";

      if (ZQXLRepMain->FieldByName("sum_pen_a")->AsFloat!=0)
        {
          xlReport->ParamByName["add11"]->Value = "������� 1";
          xlReport->ParamByName["add12"]->Value = " - - - - - ";
        }

      if (ZQXLRepMain->FieldByName("sum_pen_r")->AsFloat!=0)
        {
          xlReport->ParamByName["add12"]->Value = "������� 1";
          xlReport->ParamByName["add11"]->Value = " - - - - - ";
        }

     };

  if ((ZQXLRepMain->FieldByName("sum_infl_a")->AsFloat!=0)&&
       (ZQXLRepMain->FieldByName("sum_infl_r")->AsFloat!=0))
     {
      xlReport->ParamByName["pgi_count"]->Value = "(2 ���.)";
      xlReport->ParamByName["inf_add"]->Value = "(������� 2.1, 2.2)";
      xlReport->ParamByName["add21"]->Value = "������� 2.1";
      xlReport->ParamByName["add22"]->Value = "������� 2.2";

     }
  else
     {
      xlReport->ParamByName["pgi_count"]->Value = "(1 ���.)";
      xlReport->ParamByName["inf_add"]->Value = "(������� 2)";

      if (ZQXLRepMain->FieldByName("sum_infl_a")->AsFloat!=0)
        {
          xlReport->ParamByName["add21"]->Value = "������� 2";
          xlReport->ParamByName["add22"]->Value = " - - - - - ";
        }

      if (ZQXLRepMain->FieldByName("sum_infl_r")->AsFloat!=0)
        {
          xlReport->ParamByName["add22"]->Value = "������� 2";
          xlReport->ParamByName["add21"]->Value = " - - - - - ";
        }

                                  
     };


   if ((ZQXLRepMain->FieldByName("sum_3_proc_a")->AsFloat!=0)&&             //from yana
       (ZQXLRepMain->FieldByName("sum_3_proc_r")->AsFloat!=0))
     {
      xlReport->ParamByName["pgi_count"]->Value = "(2 ���.)";
      xlReport->ParamByName["3_proc_add"]->Value = "(������� 3.1, 3.2)";
      xlReport->ParamByName["add31"]->Value = "������� 3.1";
      xlReport->ParamByName["add32"]->Value = "������� 3.2";

     }
  else
     {
      xlReport->ParamByName["pgi_count"]->Value = "(1 ���.)";
      xlReport->ParamByName["3_proc_add"]->Value = "(������� 3)";

      if (ZQXLRepMain->FieldByName("sum_3_proc_a")->AsFloat!=0)
        {
          xlReport->ParamByName["add31"]->Value = "������� 3";
          xlReport->ParamByName["add32"]->Value = " - - - - - ";
        }

      if (ZQXLRepMain->FieldByName("sum_3_proc_r")->AsFloat!=0)
        {
          xlReport->ParamByName["add32"]->Value = "������� 3";
          xlReport->ParamByName["add31"]->Value = " - - - - - ";
        }

                                  
     };


  xlReport->ParamByName["billdt"]->Value = FormatDateTime("dd.mm.yyyy",Now());

//  xlReport->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);

//  xlReport->ParamByName["workdt"]->Value = dt;

 xlReport->Report();

 ZQXLRepMain->Close();
 ZQXLRepPen_a->Close();
 ZQXLRepPen_r->Close();
 ZQXLRep3Proc_a->Close();   //from yana
 //ZQXLRep3Proc_r->Close();    //from yana
 ZQXLRepInf_a->Close();
 ZQXLRepInfDoc_a->Close();
 ZQXLRepInf_r->Close();
 ZQXLRepInfDoc_r->Close();
                                    
}
//---------------------------------------------------------------------------
void __fastcall TfPenaInflPrint::BitBtn1Click(TObject *Sender)
{
   PrintAkt(id_client);
}
//---------------------------------------------------------------------------

void __fastcall TfPenaInflPrint::sbDecClick(TObject *Sender)
{
  WorkDate=IncMonth(WorkDate,-1);
  dtBegin->Date=WorkDate;
  dtEnd->Date=IncMonth(dtBegin->Date,1)-1;
  dtBegin->Time=0;
  dtEnd->Time=0;
  edMonth->Text=FormatDateTime("mmmm yyyy",WorkDate);
}
//---------------------------------------------------------------------------

void __fastcall TfPenaInflPrint::sbIncClick(TObject *Sender)
{
  WorkDate=IncMonth(WorkDate,1);
  dtBegin->Date=WorkDate;
  dtEnd->Date=IncMonth(dtBegin->Date,1)-1;
  dtBegin->Time=0;
  dtEnd->Time=0;
  edMonth->Text=FormatDateTime("mmmm yyyy",WorkDate);
}
//---------------------------------------------------------------------------

