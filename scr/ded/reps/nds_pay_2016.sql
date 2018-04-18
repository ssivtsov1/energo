  /*
  drop table rep_ndspay_tbl;

  create table rep_ndspay_tbl (
  id_client int,
--  grp           int,
  period_pay    int,
  pay           numeric(12,2) default 0,
  pay_tax       numeric(12,2) default 0,
  writeoff      numeric(12,2) default 0,
  writeoff_tax  numeric(12,2) default 0,
  trush         numeric(12,2) default 0,
  trush_tax     numeric(12,2) default 0,
  depozit1      numeric(12,2) default 0,
  depozit1_tax  numeric(12,2) default 0,
  depozit2      numeric(12,2) default 0,
  depozit2_tax  numeric(12,2) default 0,
  mmgg          date,
  id_pref       int
  );
    */
--drop function rep_mmggpay_fun(date);

create or replace function rep_mmggpay_2016_fun(int,date) returns int
AS                                                                                              
$BODY$
declare 
  ppref alias for $1; 
  pmmgg alias for $2; 

  v int;
  r record;
  vid_pref int;

  id_rep int;
  param_mode int;
  key_name0120 varchar; 
  id_jkh int;

BEGIN


 delete from rep_ndspay_tbl where mmgg=pmmgg ;

/*

 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select p.id_client,2001,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN bp.value+bp.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN bp.value+bp.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN bp.value+bp.value_tax  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN bp.value+bp.value_tax  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN bp.value+bp.value_tax  ELSE 0 END),0) ,  

 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN bp.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN bp.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN bp.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN bp.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN bp.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join acm_billpay_tbl as bp on (p.id_doc=bp.id_pay)
 join acm_bill_tbl as b on (b.id_doc=bp.id_bill)

 join clm_client_tbl as c on (p.id_client=c.id)
 join clm_statecl_tbl as sc on (sc.id_client = p.id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and c.order_pay =0
 and sc.id_section not in (205,206,207,208)
-- and (date_part('year',b.mmgg) >= 2016  )  
 and (date_part('year',b.mmgg) > 2000  )  and (date_part('year',b.mmgg) < 2016  ) 

 and p.mmgg = pmmgg
-- and c.idk_work <> 10
 group by p.id_client;

*/




 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select ss.id_client, 2001, (coalesce(ss.b_dt,0)-coalesce(ss.e_dt,0)+coalesce(ss.b_dttax,0)-coalesce(ss.e_dttax,0)) - coalesce(pp.writeoff,0)-coalesce(pp.trush,0) -coalesce(pp.depozit1,0)-coalesce(pp.depozit1,0),
 pp.writeoff,pp.trush,pp.depozit1,pp.depozit2,
 (coalesce(ss.b_dttax,0)-coalesce(ss.e_dttax,0)) - coalesce(pp.writeoff_tax,0)-coalesce(pp.trush_tax,0) -coalesce(pp.depozit1_tax,0)-coalesce(pp.depozit1_tax,0),
 pp.writeoff_tax,pp.trush_tax,pp.depozit1_tax,pp.depozit2_tax, pmmgg, ppref 
 from
 (
 select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,  sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax
   from seb_obrs_tmp 
     where  id_client is not null and id_pref = ppref  
     and date_part('year',hmmgg) in (2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015) 
 group by id_client
 ) as ss 
 join clm_client_tbl as c on (ss.id_client=c.id)
 join clm_statecl_tbl as sc on (sc.id_client = ss.id_client)
 left join 
 (
 select p.id_client,2001,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) as trush,  
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) as depozit1,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) as depozit2,  
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_tax  ELSE 0 END),0) as pay_tax, 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_tax  ELSE 0 END),0) as writeoff_tax, 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END),0) as trush_tax, 
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_tax  ELSE 0 END),0) as depozit1_tax, 
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_tax  ELSE 0 END),0) as depozit2_tax 
 from acm_pay_tbl as p 
 join dci_document_tbl as d on (d.id = p.idk_doc)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and (date_part('year',p.mmgg_pay) > 2000  )  and (date_part('year',p.mmgg_pay) < 2016  ) 
 and p.mmgg = pmmgg
 group by p.id_client
 ) as pp
 on (ss.id_client = pp.id_client)
 where 
 c.order_pay = 0 and
 sc.id_section not in (205,206,207,208);



 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select p.id_client,2001,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
-- join acm_billpay_tbl as bp on (p.id_doc=bp.id_pay)
-- join acm_bill_tbl as b on (b.id_doc=bp.id_bill)

 join clm_client_tbl as c on (p.id_client=c.id)
 join clm_statecl_tbl as sc on (sc.id_client = p.id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and ((c.order_pay =1) or (sc.id_section in (205,206,207,208)))
-- and (date_part('year',b.mmgg) >= 2016  )  
 and (date_part('year',p.mmgg_pay) > 2000  )  and (date_part('year',p.mmgg_pay) < 2016  ) 
 and p.mmgg = pmmgg
-- and c.idk_work <> 10
 group by p.id_client;


/*
 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select p.id_client,2001,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
-- join clm_client_tbl as c on (p.id_client=c.id)
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and (date_part('year',p.mmgg_pay) > 2000  )  and (date_part('year',p.mmgg_pay) < 2016  ) 
 and mmgg = pmmgg
-- and c.idk_work <> 10
 group by p.id_client;
*/


-- insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
--     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
-- select p.id_client,20018,
-- coalesce(sum(CASE WHEN (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident ='writeoff' THEN p.value_pay  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) ,  
-- coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) ,  
-- coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) ,  
-- coalesce(sum(CASE WHEN (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
-- from acm_pay_tbl as p 
-- join clm_client_tbl as c on (p.id_client=c.id)
---- join cla_param_tbl as clp on (clp.id = sc.id_section)
-- join dci_document_tbl as d on (d.id = p.idk_doc)
---- where clp.kod in (101,102,103,104)
-- and p.sign_pay = 1
-- and p.id_pref = ppref
-- and date_part('year',p.mmgg_pay) > 2000
-- and mmgg = pmmgg
-- and c.idk_work = 10
-- group by p.id_client;


 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select p.id_client,2000,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 

 from acm_pay_tbl as p 
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part('year',p.mmgg_pay) = 2000
 and mmgg = pmmgg
 group by p.id_client;




 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,mmgg,id_pref)
 select p.id_client ,1999,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and(d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) as trush,
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) ,  pmmgg , ppref

 from acm_pay_tbl as p 
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part('year',p.mmgg_pay) = 1999
 and mmgg = pmmgg
 group by p.id_client;




 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)

 select p.id_client,2016,
 coalesce(p.pay,0) - coalesce(pp.pay,0),
 coalesce(p.writeoff,0)-coalesce(pp.writeoff,0),
 coalesce(p.trush,0)-coalesce(pp.trush,0),
 coalesce(p.depozit1,0)-coalesce(pp.depozit1,0),
 coalesce(p.depozit2,0)-coalesce(pp.depozit2,0),
 coalesce(p.pay_tax,0)-coalesce(pp.pay_tax,0),
 coalesce(p.writeoff_tax,0)-coalesce(pp.writeoff_tax,0),
 coalesce(p.trush_tax,0)-coalesce(pp.trush_tax,0),
 coalesce(p.depozit1_tax,0)-coalesce(pp.depozit1_tax,0),
 coalesce(p.depozit2_tax,0)-coalesce(pp.depozit2_tax,0),
 pmmgg, ppref
 from
 ( select s.id_client,
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END),0) as trush,  
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_pay  ELSE 0 END),0) as depozit1,  
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_pay  ELSE 0 END),0) as depozit2,  
 coalesce(sum(CASE WHEN (d.ident <>'wr_off_act') and (d.ident <>'writeoff') and (d.ident <>'trush') and (d.ident <>'depozit_1') and (d.ident <>'depozit_2') THEN p.value_tax  ELSE 0 END),0) as pay_tax, 
 coalesce(sum(CASE WHEN (d.ident ='writeoff') or (d.ident ='wr_off_act') THEN p.value_tax  ELSE 0 END),0) as writeoff_tax, 
 coalesce(sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END),0) as trush_tax, 
 coalesce(sum(CASE WHEN d.ident ='depozit_1' THEN p.value_tax  ELSE 0 END),0) as depozit1_tax, 
 coalesce(sum(CASE WHEN d.ident ='depozit_2' THEN p.value_tax  ELSE 0 END),0) as depozit2_tax  
 from 
  seb_obr_all_tmp as s 
  left join acm_pay_tbl as p on (p.id_client = s.id_client and p.sign_pay = 1 and p.mmgg = pmmgg  and p.id_pref = ppref )

-- join clm_client_tbl as c on (p.id_client=c.id)
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
  left join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
-- and p.sign_pay = 1
-- and p.id_pref = ppref
-- and (date_part('year',b.mmgg) >= 2016  )  
-- and p.mmgg = pmmgg

 and s.mmgg = pmmgg
 and s.id_pref = ppref
-- and c.idk_work <> 10
 group by s.id_client
 ) as p
 left join (select id_client, sum(pay) as pay, sum(writeoff) as writeoff , sum(trush) as trush,
                         sum(depozit1) as depozit1 ,sum(depozit2) as depozit2 ,sum(pay_tax) as pay_tax ,
                         sum(writeoff_tax) as writeoff_tax ,sum(trush_tax) as trush_tax ,sum(depozit1_tax) as depozit1_tax ,sum (depozit2_tax) as depozit2_tax
       from rep_ndspay_tbl where id_pref = ppref and mmgg = pmmgg 
       and period_pay in (2001,2000,1999)
       group by id_client
 ) as pp on (pp.id_client = p.id_client);



RETURN 0;                      
end;
$BODY$                                                                                               
LANGUAGE 'plpgsql';          
