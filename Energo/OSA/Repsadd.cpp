void TfReports::PrognozPayAdd(TDateTime mmgg)
{
  AnsiString sqlstr;
    sqlstr=" select seb_progn5((date_trunc('month', :mmgg::::date))::::date)";

   ZQReps->Close();
   ZQReps->Sql->Clear();
   ZQReps->Sql->Add(sqlstr);
   ZQReps->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQReps->ExecSql();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    return;
   }

  AnsiString  sqlstr1=" \
   select s.id_section as link,c.code ,c.short_name as name, s.dt_indicat  , p.tar,  kr.sum_kredit, cp.represent_name,  \
   bill.demand,bill.value_all, \
    seb.dem as dem , \
    round(seb.dem*p.tar,2) as val , \
    pay.pay as pay_all, \
   s.pre_pay_day1 ,s.pre_pay_perc1 ,round(seb.dem*p.tar*s.pre_pay_perc1/100,2) as pre_pay_sum1, \
   pay10.pay as pay10, \
   s.pre_pay_day2 ,s.pre_pay_perc2 ,round(seb.dem*p.tar*s.pre_pay_perc2/100,2) as pre_pay_sum2, \
   pay20.pay as pay20, \
   s.pre_pay_day3 ,s.pre_pay_perc3 ,round(seb.dem*p.tar*s.pre_pay_perc3/100,2) as pre_pay_sum3, \
   pay30.pay as pay30 \
   from clm_client_tbl c \
   join clm_statecl_h s on (c.id=s.id_client) \
   left join clm_position_tbl as cp on (s.id_position=cp.id) \
    left join (select  id_client,  \
               case when demand_plan=0 then demand_calc else demand_plan end as dem  \
                from  seb_plan  where id_pref=10 and mmgg=:mmgg) seb \
       on (c.id=seb.id_client ) \
   left join (select id_client,sum(demand_val) as dem ,sum(value+value_tax) as val,\
   case when sum(demand_val)>0 then round((sum(value+value_tax)/ ( case when sum(demand_val)>0 then sum(demand_val) else -1 end ) ) ,5 ) else 0 end as tar  \
    from acm_bill_tbl where mmgg= (:mmgg ::::date- interval '1 month')::::date  \
     and id_pref=10 group by id_client) as p \
   on (p.id_client =c.id) \
 left join (select id_client,sum(demand_val) as demand ,sum(value+value_tax) as value_all \
    from acm_bill_tbl where mmgg= :mmgg  \
     and id_pref=10 group by id_client) as bill \
   on (bill.id_client =c.id) \
   left join (select  id_client,id_pref,mmgg,case when (b_val+b_valtax)<0 then -(b_val+b_valtax) else 0 end as sum_kredit  \
   from acm_saldo_tbl where id_pref=10 and mmgg=:mmgg) kr \
    on c.id=kr.id_client\
     left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where  id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay on pay.id_client=c.id \
   left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where (reg_date-bom(reg_date))<=11  and id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay10  on pay10.id_client=c.id \
   left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where (reg_date-bom(reg_date))>11 and (reg_date-bom(reg_date))<=21 \
                   and id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay20 on pay20.id_client=c.id \
    left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where (reg_date-bom(reg_date))>21 and (reg_date-bom(reg_date))<=32 \
                   and id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay30 on pay30.id_client=c.id \
   where ( :insp is null or s.id_position = :insp) \
   and s.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = s.id_client and scl2.mmgg_b <= date_trunc('month', :mmgg::::date ) ) \
   and coalesce(c.id_state,0) not in (50,99)\
   order by c.code;  ";


  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  if (InspectorId!=0)
     ZQXLReps->ParamByName("insp")->AsInteger=InspectorId;

//   round((sum(value+value_tax)/sum(demand_val) ) ,5 ) as tar  \
  // по категориям
  AnsiString  sqlstr2=" select ss.*, cla.name from \
  ( select s.id_section as link,     sum(kr.sum_kredit) as sum_kredit,    \
     sum(bill.demand) as demand,sum(bill.value_all) as value_all, \
     sum(seb.dem) as dem ,\
     sum(pay.pay) as pay_all, \
    sum(round(seb.dem*p.tar,2)) as val , \
   sum(round(seb.dem*p.tar*s.pre_pay_perc1/100,2))  as pre_pay_sum1, \
    sum(pay10.pay) as pay10, \
    sum(round(seb.dem*p.tar*s.pre_pay_perc2/100,2))  as pre_pay_sum2,\
    sum(pay20.pay) as pay20, \
    sum(round(seb.dem*p.tar*s.pre_pay_perc3/100,2))  as pre_pay_sum3,\
   sum(pay30.pay) as pay30 \
   from clm_client_tbl c \
   join clm_statecl_h s on (c.id=s.id_client) \
    left join (select  id_client,  \
               case when demand_plan=0 then demand_calc else demand_plan end as dem  \
                from  seb_plan  where id_pref=10 and mmgg=:mmgg) seb \
       on (c.id=seb.id_client ) \
   left join (select id_client,sum(demand_val) as dem ,sum(value+value_tax) as val,\
    case when sum(demand_val)>0 then round((sum(value+value_tax)/ ( case when sum(demand_val)>0 then sum(demand_val)else -1 end ) ) ,5 ) else 0 end as tar  \
    from acm_bill_tbl where mmgg= (:mmgg::::date- interval '1 month')::::date  \
     and id_pref=10 group by id_client) as p \
   on (p.id_client =c.id) \
 left join (select id_client,sum(demand_val) as demand ,sum(value+value_tax) as value_all \
    from acm_bill_tbl where mmgg= :mmgg  \
     and id_pref=10 group by id_client) as bill \
   on (bill.id_client =c.id) \
   left join (select  id_client,id_pref,mmgg,case when (b_val+b_valtax)<0 then -(b_val+b_valtax) else 0 end as sum_kredit  \
   from acm_saldo_tbl where id_pref=10 and mmgg=:mmgg) kr \
    on c.id=kr.id_client\
    left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where  id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay on pay.id_client=c.id \
   left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where (reg_date-bom(reg_date))<=11  and id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay10  on pay10.id_client=c.id \
   left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where (reg_date-bom(reg_date))>11 and (reg_date-bom(reg_date))<=21 \
                   and id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay20 on pay20.id_client=c.id \
    left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  \
                 where (reg_date-bom(reg_date))>21 and (reg_date-bom(reg_date))<=32 \
                   and id_pref=10 and mmgg=:mmgg \
                  and date_trunc('year',mmgg_pay)=date_trunc('year',:mmgg::::date) \
                group by id_client,id_pref \
           ) as pay30 on pay30.id_client=c.id \
    where ( :insp is null or s.id_position = :insp) \
    and s.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = s.id_client and scl2.mmgg_b <= date_trunc('month', :mmgg::::date ) ) \
    group by s.id_section \
   ) as ss \
  join cla_param_tbl as cla on (ss.link = cla.id and cla.id_group = 200) \
  order by cla.sort; ";



  ZQXLRepsSum->Sql->Clear();
  ZQXLRepsSum->Sql->Add(sqlstr2);
  ZQXLRepsSum->ParamByName("mmgg")->AsDateTime=mmgg;

  if (InspectorId!=0)
     ZQXLRepsSum->ParamByName("insp")->AsInteger=InspectorId;


  ZQXLReps->MasterSource=DSRep;
  ZQXLReps->LinkFields="link = link";

  try
  { ZQXLReps->Open();
    ZQXLRepsSum->Open();

  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

  xlReport->XLSTemplate = "XL\\"+(PTRepData(CurReport->Data))->file_name;;
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReport->DataSources->Clear();

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepsSum;
  Dsr->Alias =  "ZQXLRepsSum";
  Dsr->Range = "GroupRange";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Alias = "ZQXLReps";
  Dsr->Range = "Range";
  Dsr->MasterSourceName="ZQXLRepsSum";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lmmgg";
  Param=xlReport->Params->Add();
  Param->Name="lnow";

  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReport->ParamByName["lres"]->Value = ResName;
  xlReport->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);

  Param=xlReport->Params->Add();
  Param->Name="linsp";
  if (InspectorId!=0)
    xlReport->ParamByName["linsp"]->Value = "Iнспектор "+edInspector->Text;
  else
    xlReport->ParamByName["linsp"]->Value = " ";

  xlReport->Report();

 ZQXLReps->Close();
 ZQXLRepsSum->Close();

 ZQXLReps->MasterSource=NULL;
 ZQXLReps->LinkFields="";

}

void TfReports::PrognozPayAdd5(TDateTime mmgg)
{
  AnsiString sqlstr;
        sqlstr=" select progn_5((date_trunc('month', :mmgg::::date))::::date)";

   ZQReps->Close();
   ZQReps->Sql->Clear();
   ZQReps->Sql->Add(sqlstr);
   ZQReps->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQReps->ExecSql();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    return;
   }
    AnsiString sqlstr1;
      sqlstr1=" select t.id_section as link, t.* from rep_prognoz5_tmp t \
                left join cla_param_tbl as cla on (t.id_section = cla.id and cla.id_group = 200),    \
                clm_statecl_h s  \
               where (t.id_client=s.id_client) and ( :insp is null or s.id_position = :insp) and \
      s.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = s.id_client and scl2.mmgg_b <= date_trunc('month', :mmgg::::date ) ) \
      order by t.code";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  if (InspectorId!=0)
     ZQXLReps->ParamByName("insp")->AsInteger=InspectorId;

       AnsiString sqlstr2;
      sqlstr2="select t.id_section as link, cla.name,  \
      sum(sum_credit) as sum_credit,    \
     sum(demand) as demand,sum( value_all) as value_all, \
     sum(dem) as dem ,\
     sum(pay_all) as pay_all, \
    sum(t.val) as val , \
    sum(pre_pay_sum5) as pre_pay_sum5, \
   sum(pay5) as pay5, \
   sum( pre_pay_sum10) as pre_pay_sum10, \
   sum(pay10) as pay10, \
   sum(pre_pay_sum15) as pre_pay_sum15, \
   sum(pay15) as pay15, \
   sum(pre_pay_sum20) as pre_pay_sum20, \
   sum(pay20) as pay20, \
   sum(pre_pay_sum25) as pre_pay_sum25, \
   sum(pay25) as pay25, \
   sum(pre_pay_sum30) as pre_pay_sum30, \
   sum(pay30) as pay30 \
      from rep_prognoz5_tmp t \
      left join cla_param_tbl as cla on (t.id_section = cla.id and cla.id_group = 200)    \
      ,clm_statecl_h s\
            where (t.id_client=s.id_client) and ( :insp is null or s.id_position = :insp) and \
      s.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = s.id_client and scl2.mmgg_b <= date_trunc('month', :mmgg::::date ) ) \
        group by t.id_section,cla.name,cla.sort order by cla.sort; ";

//   round((sum(value+value_tax)/sum(demand_val) ) ,5 ) as tar  \
  // по категориям


  ZQXLRepsSum->Sql->Clear();
  ZQXLRepsSum->Sql->Add(sqlstr2);
  ZQXLRepsSum->ParamByName("mmgg")->AsDateTime=mmgg;

  if (InspectorId!=0)
     ZQXLRepsSum->ParamByName("insp")->AsInteger=InspectorId;


  ZQXLReps->MasterSource=DSRep;
  ZQXLReps->LinkFields="link = link";

  try
  { ZQXLReps->Open();
    ZQXLRepsSum->Open();

  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

  xlReport->XLSTemplate = "XL\\"+(PTRepData(CurReport->Data))->file_name;;
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReport->DataSources->Clear();

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLRepsSum;
  Dsr->Alias =  "ZQXLRepsSum";
  Dsr->Range = "GroupRange";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Alias = "ZQXLReps";
  Dsr->Range = "Range";
  Dsr->MasterSourceName="ZQXLRepsSum";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lmmgg";
  Param=xlReport->Params->Add();
  Param->Name="lnow";
  Param=xlReport->Params->Add();
  Param->Name="bossname";
  Param=xlReport->Params->Add();
  Param->Name="bosspos";
   Param=xlReport->Params->Add();
  Param->Name="bossphone";

  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReport->ParamByName["lres"]->Value = ResName;
  xlReport->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  xlReport->ParamByName["bossname"]->Value = BossName;
  xlReport->ParamByName["bosspos"]->Value = BossPos;
  xlReport->ParamByName["bossphone"]->Value = BossPhone;

  Param=xlReport->Params->Add();
  Param->Name="linsp";
  if (InspectorId!=0)
    xlReport->ParamByName["linsp"]->Value = "Iнспектор "+edInspector->Text;
  else
    xlReport->ParamByName["linsp"]->Value = " ";

  xlReport->Report();

 ZQXLReps->Close();
 ZQXLRepsSum->Close();

 ZQXLReps->MasterSource=NULL;
 ZQXLReps->LinkFields="";

}
