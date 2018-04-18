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

create or replace function rep_mmggpay_fun(int,date) returns int
AS                                                                                              
'
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


 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select p.id_client,2001,
 coalesce(sum(CASE WHEN (d.ident <>''wr_off_act'') and (d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident =''writeoff'') or (d.ident =''wr_off_act'') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''wr_off_act'') and (d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident =''writeoff'') or (d.ident =''wr_off_act'') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
-- join clm_client_tbl as c on (p.id_client=c.id)
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and ((date_part(''year'',p.mmgg_pay) > 2000 and p.id_pref <> 520 ) or (date_part(''year'',p.mmgg_pay) > 2000 and date_part(''year'',p.mmgg_pay) <= 2013 and p.id_pref = 520 ))
 and mmgg = pmmgg
-- and c.idk_work <> 10
 group by p.id_client;

 -- население до 01.08.2001
-- insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
--     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
-- select p.id_client,20018,
-- coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_pay  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
-- coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_pay  ELSE 0 END),0) ,  
-- coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_pay  ELSE 0 END),0) ,  
-- coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_tax  ELSE 0 END),0) , 
-- coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
-- from acm_pay_tbl as p 
-- join clm_client_tbl as c on (p.id_client=c.id)
---- join cla_param_tbl as clp on (clp.id = sc.id_section)
-- join dci_document_tbl as d on (d.id = p.idk_doc)
---- where clp.kod in (101,102,103,104)
-- and p.sign_pay = 1
-- and p.id_pref = ppref
-- and date_part(''year'',p.mmgg_pay) > 2000
-- and mmgg = pmmgg
-- and c.idk_work = 10
-- group by p.id_client;


 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,
     pay_tax,writeoff_tax,trush_tax,depozit1_tax,depozit2_tax,mmgg,id_pref)
 select p.id_client,2000,
 coalesce(sum(CASE WHEN (d.ident <>''wr_off_act'') and (d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident =''writeoff'') or (d.ident =''wr_off_act'') THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''wr_off_act'') and (d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN (d.ident =''writeoff'') or (d.ident =''wr_off_act'') THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 

 from acm_pay_tbl as p 
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 2000
 and mmgg = pmmgg
 group by p.id_client;




 insert into rep_ndspay_tbl(id_client,period_pay,pay,writeoff,trush,depozit1,depozit2,mmgg,id_pref)
 select p.id_client ,1999,
 coalesce(sum(CASE WHEN (d.ident <>''wr_off_act'') and(d.ident <>''writeoff'') and (d.ident <>''trush'') and (d.ident <>''depozit_1'') and (d.ident <>''depozit_2'') THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN (d.ident =''writeoff'') or (d.ident =''wr_off_act'') THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) as trush,
 coalesce(sum(CASE WHEN d.ident =''depozit_1'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN d.ident =''depozit_2'' THEN p.value_pay  ELSE 0 END),0) ,  pmmgg , ppref

 from acm_pay_tbl as p 
-- join clm_statecl_tbl as sc using (id_client)
-- join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
-- where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 1999
 and mmgg = pmmgg
 group by p.id_client;


/*

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 1,2001,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 

 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) > 2000
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 2,2001,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (11)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) > 2000
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 3,2001,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (12)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) > 2000
 and mmgg = pmmgg;


 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 4,2001,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (9,13)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) > 2000
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 5,2001,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (2,3,6,8)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) > 2000
 and mmgg = pmmgg;



 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 1,2000,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 2000
 and mmgg = pmmgg;


 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 2,2000,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (11)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 2000
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 3,2000,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (12)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) =2000
 and mmgg = pmmgg;


 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 4,2000,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (9,13)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 2000
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,pay_tax,writeoff_tax,trush_tax,mmgg,id_pref)
 select 5,2000,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) ,  
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_tax  ELSE 0 END),0) , 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_tax  ELSE 0 END),0) , pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (2,3,6,8)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 2000
 and mmgg = pmmgg;


 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,mmgg,id_pref)
 select 1,1999,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) as trush,pmmgg , ppref
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (101,102,103,104)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 1999
 and mmgg = pmmgg;


 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,mmgg,id_pref)
 select 2,1999,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) as trush,pmmgg , ppref
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (11)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 1999
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,mmgg,id_pref)
 select 3,1999,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) as trush,pmmgg , ppref
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (12)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) =1999
 and mmgg = pmmgg;


 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,mmgg,id_pref)
 select 4,1999,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) as trush,pmmgg, ppref 
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (9,13)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 1999
 and mmgg = pmmgg;

 insert into rep_ndspay_tbl(grp,period_pay,pay,writeoff,trush,mmgg,id_pref)
 select 5,1999,
 coalesce(sum(CASE WHEN (d.ident <>''writeoff'') and (d.ident <>''trush'')  THEN p.value_pay  ELSE 0 END),0) as pay, 
 coalesce(sum(CASE WHEN d.ident =''writeoff'' THEN p.value_pay  ELSE 0 END),0) as writeoff, 
 coalesce(sum(CASE WHEN d.ident =''trush'' THEN p.value_pay  ELSE 0 END),0) as trush,pmmgg, ppref  
 from acm_pay_tbl as p 
 join clm_statecl_tbl as sc using (id_client)
 join cla_param_tbl as clp on (clp.id = sc.id_section)
 join dci_document_tbl as d on (d.id = p.idk_doc)
 where clp.kod in (2,3,6,8)
 and p.sign_pay = 1
 and p.id_pref = ppref
 and date_part(''year'',p.mmgg_pay) = 1999
 and mmgg = pmmgg;
*/
RETURN 0;                      
end;'                                                                                               
LANGUAGE 'plpgsql';          
