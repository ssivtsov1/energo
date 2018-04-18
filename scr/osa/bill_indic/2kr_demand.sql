insert into dck_document_tbl (id,name,ident)
values(600,'Лимит','limit');
       
insert into dck_document_tbl (id,name,ident)
values(700,'Контрольный замер','pwrind');

insert into dci_document_tbl (id,name,idk_document,ident)
values(600,'Лимит потребления',600,'limit_2krd');

insert into dci_document_tbl (id,name,idk_document,ident)
values(601,'Лимит мощности',600,'limit_2krp');

insert into dci_document_tbl (id,name,idk_document,ident)
values(700,'Замер мощности',700,'pwrind');

insert into dci_document_tbl (id,name,idk_document,ident)
values(210,'Счет за превышение потребления',200,'bill_2krd');

insert into dci_document_tbl (id,name,idk_document,ident)
values(211,'Счет за превышение лимита мощности',200,'bill_2krp');

insert into dci_document_tbl (id,name,idk_document,ident)
values(212,'Счет (новый) превышение потр.',200,'bill_2krn');


insert into syi_error_tbl (id,name) values(10,'Превышены лимиты потребления. Сформирован счет.');
insert into syi_error_tbl (id,name) values(11,'Не задан лимит потребления.');
insert into syi_error_tbl (id,name) values(12,'Лимит потребления не превышен.');

insert into syi_error_tbl (id,name) values(16,'Нет предоплаты заявленных объемов потребления.');
insert into syi_error_tbl (id,name) values(17,'Заявленные объемы потребления превышают допустимые для площадки.');




create or replace function crt_dem2krbill(int,int,date) Returns int As'
Declare
 pid_client Alias for $1;
 pid_bill Alias for $2;
 pmmgg Alias for $3;

 mfo_s int;
 acc_s numeric;
 nds numeric;
 r record;
 r1 record;
 kdoc int;
 iddc int;
 ch_val text;

 vlimit record;
 vfact record;
 d_bill date;
  vbill_dat date;
 
begin

-- delete from act_res_notice;
 delete from sys_error_tbl;

 select into kdoc id from dci_document_tbl where ident=''bill_2krd'';

 delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;
 select into vbill_dat dat_e from acm_bill_tbl where id_doc=pid_bill;


 ch_val:='''';
 iddc:=null;

 
 select into vlimit value_dem, hl.id_doc from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l
 on(hl.id_doc = l.id_doc and l.value_dem is not null)
 where hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= vbill_dat-''4 days''::interval and idk_document = 600
 order by hl.reg_date desc limit 1;   
   Raise Notice ''hl.id_doc % '',vlimit.id_doc;
   Raise Notice ''value_dem % '',vlimit.value_dem;


 if not found then
   Raise Notice ''Нет лимита потребления.'';
   insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd'',11);
   return 0;
 end if;
 ----есть лимит - будем сравнивать

-- select into vfact sum(demand_val) as dem, sum(value) as val, CASE WHEN sum(demand_val) <> 0 THEN round(sum(value)/sum(demand_val),4) ELSE 0 END as tariff,
 --if getsysvar(''kod_res'') = ''310'' then

  select into vfact coalesce(sum(bs.demand_val),0) as dem, 
 CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc = 200 and (b.id_doc = pid_bill or pid_bill is null)
  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8'';
   /*
 else

  select into vfact coalesce(sum(bs.demand_val),0) as dem, CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc = 200 and (b.id_doc = pid_bill or pid_bill is null);
--  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8'';

 end if;
     */
 if not found then
   return -1;
 end if;

 if vfact.dem <= vlimit.value_dem then

  Raise Notice ''Лимит потребления не превышен.'';
  insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd'',12);
  Return 0;

 end if;


 if pmmgg<(select (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||
      ''-''||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident=''mmgg'') then

  Raise Notice ''Period is closed!!!'';
  Return -1;

 end if;


 -- банк для реактивной енергии используется для 2х кр
 ch_val:=''act_ee'';

 for r1 in select * from cli_account_tbl as a inner join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
   -- acc_s:=to_number(r1.account,''99999999999999'');
      acc_s=r1.account;
 end loop;

 if mfo_s is null then
   Raise Notice ''Account not found'';
   --insert into act_res_notice values(''Account not found'');
   ---  Raise Exception ''(Account not found)'';
   Return -1;
 end if;

if pmmgg<''2014-01-01'' then
 select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident=''tax'' 
     and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
    where a.date_inst<=pmmgg and b.ident=''tax'');
else
 nds=0;
end if; 




-- select into kdoc id from dci_document_tbl where ident=''bill_2krd'';

-- delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;
select into d_bill reg_date  
  from acm_bill_tbl as b
  where b.id_doc = pid_bill ;


 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc,dat_b,dat_e,flag_priv) 
 values(
   524
   ,now()
   ,(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'') 
    ,d_bill
 -- ,now()::date 
   ,pid_client
   ,mfo_s ,acc_s 
   ,round((vfact.dem - vlimit.value_dem)*vfact.tariff,2)
   ,round((vfact.dem - vlimit.value_dem)*vfact.tariff*nds,2)
   ,vfact.dem - vlimit.value_dem
   ,vlimit.id_doc
   ,pmmgg
   ,pmmgg
   ,kdoc
   ,vfact.dat_b
   ,vfact.dat_e
   ,false);

 iddc:=currval(''dcm_doc_seq'');

----acd_billsum_tbl

 insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,demand_val,sum_val,id_doc,mmgg,dt)
 values(0,1,vfact.dat_b,vfact.dat_e,vfact.dem - vlimit.value_dem,
 round((vfact.dem - vlimit.value_dem)*vfact.tariff,2),iddc,pmmgg,now()::date);

 insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd_ok'',10);

Return iddc;
end;
' Language 'plpgsql'; 

----------------------------------------------------------------------------------
-- 2 кр за период по новому алгоритму
create or replace function crt_dem2krmmgg(int,date) Returns int As'
Declare
 pid_client Alias for $1;
 pmmgg Alias for $2;

 mfo_s int;
 acc_s numeric;
 nds numeric;
 r record;
 r1 record;
 kdoc int;
 iddc int;
 ch_val text;

 vlimit record;
 vfact record;
 v2kr record;
 d_bill date;
 vbill_dat date;

 vdemand_2kr int;
 vbill_num varchar;
 
begin


 if pmmgg<(select (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||
      ''-''||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident=''mmgg'') then

  Raise Notice ''Period is closed!!!'';
  Return -1;

 end if;


-- delete from act_res_notice;
 delete from sys_error_tbl;

 select into kdoc id from dci_document_tbl where ident=''bill_2krd'';

-- delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;

-- select into vbill_dat max(dat_e) from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;


 ch_val:='''';
 iddc:=null;

 
 select into vlimit value_dem, hl.id_doc from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l
 on(hl.id_doc = l.id_doc)
 where hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + ''1 month - 1 days''::interval and idk_document = 600
 order by hl.reg_date desc limit 1;   

   Raise Notice ''hl.id_doc % '',vlimit.id_doc;
   Raise Notice ''value_dem % '',vlimit.value_dem;


 if not found then
   Raise Notice ''Нет лимита потребления.'';
   insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd'',11);
   return 0;
 end if;
 ----есть лимит - будем сравнивать

-- select into vfact sum(demand_val) as dem, sum(value) as val, CASE WHEN sum(demand_val) <> 0 THEN round(sum(value)/sum(demand_val),4) ELSE 0 END as tariff,
-- if getsysvar(''kod_res'') = ''310'' then

  select into vfact coalesce(sum(bs.demand_val),0) as dem, 
 CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8'';
/*
 else

  select into vfact coalesce(sum(bs.demand_val),0) as dem, CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') or tgr.ident ~''tgr8_6'') ;

 end if;
  */
 if not found then
--   return -1;
  vdemand_2kr :=0;
 else

  if vfact.dem <= vlimit.value_dem then

   Raise Notice ''Лимит потребления не превышен.'';
   insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd'',12);
 --  Return 0;
   vdemand_2kr :=0;
  else
   vdemand_2kr :=(vfact.dem - vlimit.value_dem)::int;

   Raise Notice ''demand prev %'',vdemand_2kr;
  end if;

 end if;


 -- определить сколько уже выставлено 2 кр

 select into v2kr coalesce(sum(b.demand_val),0) as dem,
 coalesce(sum(CASE WHEN coalesce(b.flag_transmis,0) = 1 THEN b.demand_val ELSE 0 END),0) as dem_transmis,
 coalesce(sum(CASE WHEN coalesce(b.flag_transmis,0) = 1 THEN 1 ELSE 0 END),0) as cnt_transmis
 from acm_bill_tbl as b
 where b.mmgg = pmmgg 
 and b.id_client = pid_client 
 and b.id_pref = 524 and b.idk_doc = kdoc ;

 Raise Notice ''demand prev old %'',v2kr.dem;
 Raise Notice ''demand prev old transmis %'',v2kr.dem_transmis;

 if v2kr.dem = vdemand_2kr then 
   Raise Notice ''demand limit prev not changed! '';
  -- ни чего не изменилось
   return 0;
 end if;

 delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg and coalesce(flag_transmis,0) = 0;

 vdemand_2kr:= vdemand_2kr - v2kr.dem_transmis;

 if vdemand_2kr = 0 then 
   Raise Notice ''Nothing to do .. '';
  -- ни чего не изменилось
   return 0;
 end if;

 
 -- банк для реактивной енергии используется для 2х кр
 ch_val:=''act_ee'';

 for r1 in select * from cli_account_tbl as a inner join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
--    acc_s:=to_number(r1.account,''99999999999999'');
      acc_s=r1.account;
 end loop;

 if mfo_s is null then
   Raise Notice ''Account not found'';
   --insert into act_res_notice values(''Account not found'');
   ---  Raise Exception ''(Account not found)'';
   Return -1;
 end if;


if pmmgg<''2014-01-01'' then

 select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident=''tax'' 
     and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
    where a.date_inst<=pmmgg and b.ident=''tax'');

else
 nds=0;
end if; 




 select into d_bill max(reg_date) from acm_bill_tbl as b
  where b.id_client = pid_client and b.mmgg = pmmgg and b.mmgg_bill = pmmgg 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) ;


 if v2kr.cnt_transmis =0 then 

  vbill_num:=(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'');

 else

  vbill_num:=(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'')||''.''||text(v2kr.cnt_transmis+1);

 end if;

 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc,dat_b,dat_e,flag_priv) 
 values(
   524
   ,now()
   ,vbill_num 
   ,d_bill
   ,pid_client
   ,mfo_s ,acc_s 
   ,round(vdemand_2kr*vfact.tariff,2)
   ,round(vdemand_2kr*vfact.tariff*nds,2)
   ,vdemand_2kr
   ,vlimit.id_doc
   ,pmmgg
   ,pmmgg
   ,kdoc
   ,vfact.dat_b
   ,vfact.dat_e
   ,false);

 iddc:=currval(''dcm_doc_seq'');

----acd_billsum_tbl
                                                      	
 insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,demand_val,sum_val,id_doc,mmgg,dt)
 values(0,1,vfact.dat_b,vfact.dat_e,vdemand_2kr,
 round(vdemand_2kr*vfact.tariff,2),iddc,pmmgg,now()::date);

 insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd_ok'',10);

Return iddc;
end;
' Language 'plpgsql'; 

----------------------------------------------------------------------------------

-- 2 кр за период по совсем  новому алгоритму
create or replace function crt_dem2krmmgg_area_old(int,date) Returns int As'
Declare
 pid_client Alias for $1;
 pmmgg Alias for $2;
 mfo_s int;
 acc_s numeric;
 nds numeric;
 r record;
 r1 record;
 kdoc int;
 iddc int;
 ch_val text;
 cnt_transmis int;
vlimit record;
 vfact record;
 v2kr record;
 d_bill date;
 vbill_dat date;

 vdemand_2kr int;
 vbill_num varchar;
sbill numeric;
recpower record;   
begin
 if pmmgg<(select (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||
      ''-''||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident=''mmgg'') then

  Raise Notice ''Period is closed!!!'';
  Return -1;

 end if;


-- delete from act_res_notice;
 delete from sys_error_tbl;

 select into kdoc id from dci_document_tbl where ident=''bill_2krd'';

-- delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;

-- select into vbill_dat max(dat_e) from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;


 ch_val:='''';
 iddc:=null;

/* 
for vlimit in select value_dem, hl.id_area, hl.id_doc from acm_headdemandlimit_tbl as hl 
 join acd_demandlimit_tbl as l  on(hl.id_doc = l.id_doc)
 where hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + ''1 month - 1 days''::interval and idk_document = 600
 order by hl.reg_date desc limit loop   

   Raise Notice ''hl.id_doc % '',vlimit.id_doc;
   Raise Notice ''value_dem % '',vlimit.value_dem;


 if not found then
   Raise Notice ''Нет лимита потребления.'';
   insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd'',11);
  -- return 0;
 end if;
 ----есть лимит - будем сравнивать
*/
-- select into vfact sum(demand_val) as dem, sum(value) as val, CASE WHEN sum(demand_val) <> 0 THEN round(sum(value)/sum(demand_val),4) ELSE 0 END as tariff,
 --if getsysvar(''kod_res'') = ''310'' then

  insert into act_pwr_limit_over_tbl (id_area,night_day,power_fact,tarif,dat_b,dat_e)
  select  id_area,1,coalesce(sum(bs.demand_val),0) as dem, 
  CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8''   group by id_area,1;

  insert into  act_pwr_limit_pnt_tbl ( id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  id_area,id_point,coalesce(sum(bs.demand_val),0) as dem, 
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8''   group by id_area,id_point;
 /*
 else

  insert into act_pwr_limit_over_tbl (id_area,night_day,power_fact,tarif,dat_b,dat_e)
   select  id_area,1,coalesce(sum(bs.demand_val),0) as dem, 
  CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') or tgr.ident ~''tgr8_6'') group by id_area,1;

 insert into  act_pwr_limit_pnt_tbl ( id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  id_area,id_point,coalesce(sum(bs.demand_val),0) as dem, 
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') or tgr.ident ~''tgr8_6'') group by id_area,id_point;


 end if;
   */
for recpower in select  * from act_pwr_limit_over_tbl loop

update act_pwr_limit_over_tbl set  power_limit= a.value_dem from
 (select value_dem, l.id_area, hl.id_doc from acm_headdemandlimit_tbl as hl 
 join acd_demandlimit_tbl as l  on(hl.id_doc = l.id_doc)
 where l.id_area =recpower.id_area and  hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + ''1 month - 1 days''::interval and idk_document = 600
 order by hl.reg_date desc limit 1) a  where  act_pwr_limit_over_tbl.id_area=a.id_area;


end loop;



update act_pwr_limit_over_tbl set  power_limit= 0  where  power_limit is null;
update act_pwr_limit_over_tbl set  power_ower= power_fact-power_limit;


--delete from act_pwr_limit_over_tbl where power_over<=0;

/*
end loop;
*/
 -- определить сколько уже выставлено 2 кр
update act_pwr_limit_over_tbl set      power_trans=b.dem_transmis from
( select id_area,coalesce(sum(bp.power_bill),0) as dem, 
   coalesce(sum(CASE WHEN coalesce(b.flag_transmis,0) = 1 THEN bp.power_bill ELSE 0 END),0) as dem_transmis
 from acm_bill_tbl as b, acd_pwr_limit_over_tbl bp
 where b.mmgg = pmmgg and b.id_doc=bp.id_doc    and b.id_client = pid_client  and b.id_pref = 524 
   and b.idk_doc = kdoc group by id_area
) b  where act_pwr_limit_over_tbl.id_area=b.id_area;

update act_pwr_limit_over_tbl set  power_trans= 0  where  power_trans is null;
update act_pwr_limit_over_tbl set  power_bill= power_ower-power_trans;
update act_pwr_limit_over_tbl set  sum_value= round(power_bill*tarif,2);


 delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg 
    and coalesce(flag_transmis,0) = 0;

 
 -- банк для реактивной енергии используется для 2х кр
 ch_val:=''act_ee'';

 for r1 in select * from cli_account_tbl as a inner join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
   -- acc_s:=to_number(r1.account,''99999999999999'');
      acc_s=r1.account;
 end loop;

 if mfo_s is null then
   Raise Notice ''Account not found'';
   --insert into act_res_notice values(''Account not found'');
   ---  Raise Exception ''(Account not found)'';
   Return -1;
 end if;


if pmmgg<''2014-01-01'' then

 select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident=''tax'' 
     and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
    where a.date_inst<=pmmgg and b.ident=''tax'');

else
 nds=0;
end if; 





 select into d_bill coalesce(max(reg_date) , now()::date) from acm_bill_tbl as b
  where b.id_client = pid_client and b.mmgg = pmmgg and b.mmgg_bill = pmmgg 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) ;

select into cnt_transmis count(*)  from acm_bill_tbl as b
 where b.mmgg = pmmgg 
 and b.id_client = pid_client 
 and b.id_pref = 524 and b.idk_doc = kdoc and  coalesce(flag_transmis,0)=1;



 if coalesce(cnt_transmis,0) =0 then 

  vbill_num:=(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'');

 else

  vbill_num:=(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'')||''.''||text(cnt_transmis+1);

 end if;

delete from act_pwr_limit_over_tbl where power_bill<=0;
select  into sbill sum(power_bill)   from  act_pwr_limit_over_tbl;
if sbill<>0.00 then
 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,mmgg   ,mmgg_bill,
   idk_doc,dat_b,dat_e,flag_priv) 
 values(    524      ,now()     ,vbill_num    ,d_bill    ,pid_client
   ,mfo_s ,acc_s   ,pmmgg     ,pmmgg
   ,kdoc     ,pmmgg    ,pmmgg    ,false);
--end if;

 iddc:=currval(''dcm_doc_seq'');
 insert into acd_pwr_limit_over_tbl     (id_doc	, id_area ,    night_day,    
                                power_limit ,    power_fact  ,     power_ower  ,    power_trans ,    power_bill  ,
                                tarif      ,    sum_value ,    dat_b  ,    dat_e  ,    mmgg )
 select iddc,  id_area ,    night_day,    
          power_limit ,    power_fact  ,     power_ower  ,    power_trans ,    power_bill  ,
          tarif      ,    sum_value ,    dat_b  ,    dat_e  ,    pmmgg          
   from   act_pwr_limit_over_tbl ;


 insert into  acd_pwr_limit_pnt_tbl ( id_doc,id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  iddc,id_area,id_point,demand,  dat_b,dat_e  from  act_pwr_limit_pnt_tbl;

                                                      	
 insert into acd_billsum_tbl(id_point,id_area,kind_energy, dt_begin,dt_end,
                            demand_val,sum_val,id_doc,mmgg,dt)
                 select 0,id_area,1, dat_b,dat_e,power_bill,sum_value,iddc,pmmgg,now()::date 
                      from   act_pwr_limit_over_tbl;

 update acm_bill_tbl set  demand_val=dem,value=val,value_tax=round(val*nds,2) 
   from   (select  sum(power_bill) as dem, sum(sum_value) as val 
            from  act_pwr_limit_over_tbl) as d where id_doc=iddc;

 select into sbill value from acm_bill_tbl where id_doc=iddc;

 insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd_ok'',10);
end if;

Return iddc;
end;
' Language 'plpgsql'; 


-- 2 кр за период по совсем  новому алгоритму
create or replace function crt_dem2krmmgg_area(int,date) Returns int As'
Declare
 pid_client Alias for $1;
 pmmgg Alias for $2;
 mfo_s int;
 acc_s numeric;
 nds numeric;
 r record;
 r1 record;
 kdoc int;
 kdoc_old int;
 ptarif numeric;
 iddc int;
 ch_val text;
 cnt_transmis int;
vlimit record;
 vfact record;
 v2kr record;
 d_bill date;
 vbill_dat date;

 vdemand_2kr int;
 vbill_num varchar;
sbill numeric;
recpower record;   
begin
 if pmmgg<(select (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||
      ''-''||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident=''mmgg'') then

  Raise Notice ''Period is closed!!!'';
  Return -1;

 end if;


-- delete from act_res_notice;
 delete from sys_error_tbl;

 select into kdoc id from dci_document_tbl where ident=''bill_2krn'';
 select into kdoc_old id from dci_document_tbl where ident=''bill_2krd'';

-- delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;

-- select into vbill_dat max(dat_e) from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;


 ch_val:='''';
 iddc:=null;
  

 --if getsysvar(''kod_res'') = ''310'' then
   select into ptarif    
     CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END
      from acm_bill_tbl as b
      join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
      join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
      join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

     where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
     and b.id_client = pid_client 
     and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
     and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8''  ;


  insert into act_pwr_limit_over_tbl (id_area,night_day,power_fact,tarif,dat_b,dat_e)
  select  id_area,1,coalesce(sum(bs.demand_val),0) as dem, 
  --CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  ptarif as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8''   group by id_area,1;

  insert into  act_pwr_limit_pnt_tbl ( id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  id_area,id_point,coalesce(sum(bs.demand_val),0) as dem, 
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~''tgr7'' and tgr.ident !~''tgr8''   group by id_area,id_point;
 /*
 else
   select into ptarif    
     CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END
      from acm_bill_tbl as b
      join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
      join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
      join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

     where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
     and b.id_client = pid_client 
     and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') or tgr.ident ~''tgr8_6'') ;


  insert into act_pwr_limit_over_tbl (id_area,night_day,power_fact,tarif,dat_b,dat_e)
   select  id_area,1,coalesce(sum(bs.demand_val),0) as dem, 
   ptarif as tariff,
--  CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') or tgr.ident ~''tgr8_6'') group by id_area,1;

 insert into  act_pwr_limit_pnt_tbl ( id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  id_area,id_point,coalesce(sum(bs.demand_val),0) as dem, 
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') or tgr.ident ~''tgr8_6'') group by id_area,id_point;


 end if;
 */
for recpower in select  * from act_pwr_limit_over_tbl loop

update act_pwr_limit_over_tbl set  power_limit= a.value_dem from
 (select value_dem, l.id_area, hl.id_doc from acm_headdemandlimit_tbl as hl 
 join (select d.* from acd_demandlimit_tbl d 
                      left join eqm_ground_tbl g 
                      on d.id_area=g.code_eqp where d.id_area is null  or (d.id_area =code_eqp)
       )  as l  on(hl.id_doc = l.id_doc)
 where l.id_area =recpower.id_area and  hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + ''1 month - 1 days''::interval and idk_document = 600
 order by hl.reg_date desc limit 1) a  where  act_pwr_limit_over_tbl.id_area=a.id_area;


end loop;



update act_pwr_limit_over_tbl set  power_limit= 0  where  power_limit is null;
update act_pwr_limit_over_tbl set  power_ower= power_fact-power_limit;


--delete from act_pwr_limit_over_tbl where power_over<=0;

/*
end loop;
*/
 -- определить сколько уже выставлено 2 кр
update act_pwr_limit_over_tbl set      power_trans=b.dem_transmis from
( select id_area,coalesce(sum(bp.power_bill),0) as dem, 
   coalesce(sum(CASE WHEN coalesce(b.flag_transmis,0) = 1 THEN bp.power_bill ELSE 0 END),0) as dem_transmis
 from acm_bill_tbl as b, acd_pwr_limit_over_tbl bp
 where b.mmgg = pmmgg and b.id_doc=bp.id_doc    and b.id_client = pid_client  and b.id_pref = 524 
   and b.idk_doc = kdoc group by id_area
) b  where act_pwr_limit_over_tbl.id_area=b.id_area;

update act_pwr_limit_over_tbl set  power_trans= 0  where  power_trans is null;
update act_pwr_limit_over_tbl set  power_bill= power_ower-power_trans;
update act_pwr_limit_over_tbl set  sum_value= round(power_bill*tarif,2);


 delete from acm_bill_tbl where id_client = pid_client and (idk_doc = kdoc or idk_doc = kdoc_old) and mmgg = pmmgg 
    and coalesce(flag_transmis,0) = 0;

 
 -- банк для реактивной енергии используется для 2х кр
 ch_val:=''act_ee'';

 for r1 in select * from cli_account_tbl as a inner join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
    --acc_s:=to_number(r1.account,''99999999999999'');
      acc_s=r1.account;
 end loop;

 if mfo_s is null then
   Raise Notice ''Account not found'';
   --insert into act_res_notice values(''Account not found'');
   ---  Raise Exception ''(Account not found)'';
   Return -1;
 end if;

if pmmgg<''2014-01-01'' then

 select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident=''tax'' 
     and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
    where a.date_inst<=pmmgg and b.ident=''tax'');

else
 nds=0;
end if; 



 select into d_bill coalesce(max(reg_date) , now()::date) from acm_bill_tbl as b
  where b.id_client = pid_client and b.mmgg = pmmgg and b.mmgg_bill = pmmgg 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) ;

select into cnt_transmis count(*)  from acm_bill_tbl as b
 where b.mmgg = pmmgg 
 and b.id_client = pid_client 
 and b.id_pref = 524 and b.idk_doc = kdoc and  coalesce(flag_transmis,0)=1;



 if coalesce(cnt_transmis,0) =0 then 

  vbill_num:=(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'');

 else

  vbill_num:=(select ''2D''||code::text from clm_client_tbl where id=pid_client)||''_''
   ||to_char(pmmgg,''mm'')||''-''||to_char(pmmgg,''yyyy'')||''.''||text(cnt_transmis+1);

 end if;

--delete from act_pwr_limit_over_tbl where power_bill<=0;
select  into sbill sum(power_bill)   from  act_pwr_limit_over_tbl;
if sbill>0.00 then
 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,mmgg   ,mmgg_bill,
   idk_doc,dat_b,dat_e,flag_priv) 
 values(    524      ,now()     ,vbill_num    ,d_bill    ,pid_client
   ,mfo_s ,acc_s   ,pmmgg     ,pmmgg
   ,kdoc     ,pmmgg    ,pmmgg    ,false);
--end if;

 iddc:=currval(''dcm_doc_seq'');
 insert into acd_pwr_limit_over_tbl     (id_doc	, id_area ,    night_day,    
                                power_limit ,    power_fact  ,     power_ower  ,    power_trans ,    power_bill  ,
                                tarif      ,    sum_value ,    dat_b  ,    dat_e  ,    mmgg )
 select iddc,  id_area ,    night_day,    
          power_limit ,    power_fact  ,     power_ower  ,    power_trans ,    power_bill  ,
          tarif      ,    sum_value ,    dat_b  ,    dat_e  ,    pmmgg          
   from   act_pwr_limit_over_tbl ;


 insert into  acd_pwr_limit_pnt_tbl ( id_doc,id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  iddc,id_area,id_point,demand,  dat_b,dat_e  from  act_pwr_limit_pnt_tbl;

                                                      	
 insert into acd_billsum_tbl(id_point,id_area,kind_energy, dt_begin,dt_end,
                            demand_val,sum_val,id_doc,mmgg,dt)
                 select 0,id_area,1, dat_b,dat_e,power_bill,sum_value,iddc,pmmgg,now()::date 
                      from   act_pwr_limit_over_tbl;

 update acm_bill_tbl set  demand_val=dem,value=val,value_tax=round(val*nds,2) 
   from   (select  sum(power_bill) as dem, sum(sum_value) as val 
            from  act_pwr_limit_over_tbl) as d where id_doc=iddc;

 select into sbill value from acm_bill_tbl where id_doc=iddc;

 insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2krd_ok'',10);
end if;

Return iddc;
end;
' Language 'plpgsql'; 

--update acm_bill_tbl set value_tax=0 where mmgg>='2014-01-01' and flock=0 and (id_pref=510 or id_pref=524);


CREATE  or replace FUNCTION recalc_2kr_all(date)                                                  
  RETURNS bool                                                                                     
  AS    
$BODY$

  declare
  pmg alias for $1;
recfile record;
ret int;
begin
for  recfile in select * from acm_headpowerindication_tbl where mmgg=pmg and flock<>1 loop
ret=crt_pwr2krbill(recfile.id_client, recfile.id_doc, recfile.mmgg);
end loop;
return true;
end;
$BODY$                                                                                          
LANGUAGE 'plpgsql';  


CREATE OR REPLACE FUNCTION crt_dem2krmmgg_area(integer, date)
  RETURNS integer AS
$BODY$
Declare
 pid_client Alias for $1;
 pmmgg Alias for $2;
 mfo_s int;
 acc_s numeric;
 nds numeric;
 r record;
 r1 record;
 kdoc int;
 kdoc_old int;
 ptarif numeric;
 iddc int;
 ch_val text;
 cnt_transmis int;
vlimit record;
 vfact record;
 v2kr record;
 d_bill date;
 vbill_dat date;

 vdemand_2kr int;
 vbill_num varchar;
sbill numeric;
recpower record;   
begin
 if pmmgg<(select (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||
      '-'||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident='mmgg') then

  Raise Notice 'Period is closed!!!';
  Return -1;

 end if;


-- delete from act_res_notice;
 delete from sys_error_tbl;

 select into kdoc id from dci_document_tbl where ident='bill_2krn';
 select into kdoc_old id from dci_document_tbl where ident='bill_2krd';

-- delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;

-- select into vbill_dat max(dat_e) from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and mmgg = pmmgg;


 ch_val:='';
 iddc:=null;
  

 --if getsysvar('kod_res') = '310' then
   select into ptarif    
     CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END
      from acm_bill_tbl as b
      join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
      join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
      join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

     where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
     and b.id_client = pid_client 
     and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
     and tgr.ident !~'tgr7' and tgr.ident !~'tgr8'  ;


  insert into act_pwr_limit_over_tbl (id_area,night_day,power_fact,tarif,dat_b,dat_e)
  select  id_area,1,coalesce(sum(bs.demand_val),0) as dem, 
  --CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  ptarif as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~'tgr7' and tgr.ident !~'tgr8'   group by id_area,1;

  insert into  act_pwr_limit_pnt_tbl ( id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  id_area,id_point,coalesce(sum(bs.demand_val),0) as dem, 
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and tgr.ident !~'tgr7' and tgr.ident !~'tgr8'   group by id_area,id_point;
 /*
 else
   select into ptarif    
     CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END
      from acm_bill_tbl as b
      join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
      join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
      join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)

     where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
     and b.id_client = pid_client 
     and b.id_pref = 10 and b.idk_doc in ( 200 , 204 ) 
  and (( tgr.ident !~'tgr8' and tgr.ident !~'tgr7') or tgr.ident ~'tgr8_6') ;


  insert into act_pwr_limit_over_tbl (id_area,night_day,power_fact,tarif,dat_b,dat_e)
   select  id_area,1,coalesce(sum(bs.demand_val),0) as dem, 
   ptarif as tariff,
--  CASE WHEN sum(bs.demand_val) <> 0 THEN round(sum(bs.sum_val)/sum(bs.demand_val),4) ELSE 0 END as tariff,
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~'tgr8' and tgr.ident !~'tgr7') or tgr.ident ~'tgr8_6') group by id_area,1;

 insert into  act_pwr_limit_pnt_tbl ( id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  id_area,id_point,coalesce(sum(bs.demand_val),0) as dem, 
  min(b.dat_b) as dat_b, max(b.dat_e) as dat_e  
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg = pmmgg -- and b.mmgg_bill = pmmgg 
  and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~'tgr8' and tgr.ident !~'tgr7') or tgr.ident ~'tgr8_6') group by id_area,id_point;


 end if;
 */
for recpower in select  * from act_pwr_limit_over_tbl loop

update act_pwr_limit_over_tbl set  power_limit= a.value_dem from
 (select value_dem, l.id_area, hl.id_doc from acm_headdemandlimit_tbl as hl 
 join (select d.* from acd_demandlimit_tbl d 
--                      left join eqm_ground_tbl g on (d.id_area=g.code_eqp) 
                      left join ( select distinct g.code_eqp from eqm_ground_tbl as g join eqm_compens_station_inst_tbl as csi on (csi.code_eqp_inst = g.code_eqp) ) as g on (d.id_area=g.code_eqp) 
                      where (d.id_area is null  or (d.id_area =code_eqp))
       )  as l  on(hl.id_doc = l.id_doc)
 where l.id_area =recpower.id_area and  hl.id_client = pid_client and date_trunc('month',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + '1 month - 1 days'::interval and idk_document = 600
 order by hl.reg_date desc limit 1) a  where  act_pwr_limit_over_tbl.id_area=a.id_area;


end loop;



update act_pwr_limit_over_tbl set  power_limit= 0  where  power_limit is null;
update act_pwr_limit_over_tbl set  power_ower= power_fact-power_limit;


--delete from act_pwr_limit_over_tbl where power_over<=0;

/*
end loop;
*/
 -- НОПЕДЕКХРЭ ЯЙНКЭЙН СФЕ БШЯРЮБКЕМН 2 ЙП
update act_pwr_limit_over_tbl set      power_trans=b.dem_transmis from
( select id_area,coalesce(sum(bp.power_bill),0) as dem, 
   coalesce(sum(CASE WHEN coalesce(b.flag_transmis,0) = 1 THEN bp.power_bill ELSE 0 END),0) as dem_transmis
 from acm_bill_tbl as b, acd_pwr_limit_over_tbl bp
 where b.mmgg = pmmgg and b.id_doc=bp.id_doc    and b.id_client = pid_client  and b.id_pref = 524 
   and b.idk_doc = kdoc group by id_area
) b  where act_pwr_limit_over_tbl.id_area=b.id_area;

update act_pwr_limit_over_tbl set  power_trans= 0  where  power_trans is null;
update act_pwr_limit_over_tbl set  power_bill= power_ower-power_trans;
update act_pwr_limit_over_tbl set  sum_value= round(power_bill*tarif,2);


 delete from acm_bill_tbl where id_client = pid_client and (idk_doc = kdoc or idk_doc = kdoc_old) and mmgg = pmmgg 
    and coalesce(flag_transmis,0) = 0;

 
 -- АЮМЙ ДКЪ ПЕЮЙРХБМНИ ЕМЕПЦХХ ХЯОНКЭГСЕРЯЪ ДКЪ 2У ЙП
 ch_val:='act_ee';

 for r1 in select * from cli_account_tbl as a inner join (select int4('0'||value_ident) as val from 
          syi_sysvars_tbl where ident='id_res') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
   -- acc_s:=to_number(r1.account,'99999999999999'::varchar);
   acc_s=r1.account;
 end loop;

 if mfo_s is null then
   Raise Notice 'Account not found';
   --insert into act_res_notice values('Account not found');
   ---  Raise Exception '(Account not found)';
   Return -1;
 end if;

if pmmgg<'2014-01-01' then

 select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident='tax' 
     and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
    where a.date_inst<=pmmgg and b.ident='tax');

else
 nds=0;
end if; 



 select into d_bill coalesce(max(reg_date) , now()::date) from acm_bill_tbl as b
  where b.id_client = pid_client and b.mmgg = pmmgg and b.mmgg_bill = pmmgg 
  and b.id_pref = 10 and b.idk_doc in (200,204 ) ;

select into cnt_transmis count(*)  from acm_bill_tbl as b
 where b.mmgg = pmmgg 
 and b.id_client = pid_client 
 and b.id_pref = 524 and b.idk_doc = kdoc and  coalesce(flag_transmis,0)=1;



 if coalesce(cnt_transmis,0) =0 then 

  vbill_num:=(select '2D'||code::text from clm_client_tbl where id=pid_client)||'_'
   ||to_char(pmmgg,'mm')||'-'||to_char(pmmgg,'yyyy');

 else

  vbill_num:=(select '2D'||code::text from clm_client_tbl where id=pid_client)||'_'
   ||to_char(pmmgg,'mm')||'-'||to_char(pmmgg,'yyyy')||'.'||text(cnt_transmis+1);

 end if;

--delete from act_pwr_limit_over_tbl where power_bill<=0;
select  into sbill sum(power_bill)   from  act_pwr_limit_over_tbl;
if sbill>0.00 then
 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,mmgg   ,mmgg_bill,
   idk_doc,dat_b,dat_e,flag_priv) 
 values(    524      ,now()     ,vbill_num    ,d_bill    ,pid_client
   ,mfo_s ,acc_s   ,pmmgg     ,pmmgg
   ,kdoc     ,pmmgg    ,pmmgg    ,false);
--end if;

 iddc:=currval('dcm_doc_seq');
 insert into acd_pwr_limit_over_tbl     (id_doc	, id_area ,    night_day,    
                                power_limit ,    power_fact  ,     power_ower  ,    power_trans ,    power_bill  ,
                                tarif      ,    sum_value ,    dat_b  ,    dat_e  ,    mmgg )
 select iddc,  id_area ,    night_day,    
          power_limit ,    power_fact  ,     power_ower  ,    power_trans ,    power_bill  ,
          tarif      ,    sum_value ,    dat_b  ,    dat_e  ,    pmmgg          
   from   act_pwr_limit_over_tbl ;


 insert into  acd_pwr_limit_pnt_tbl ( id_doc,id_area ,  id_point ,  demand ,  dat_b ,  dat_e) 
  select  iddc,id_area,id_point,demand,  dat_b,dat_e  from  act_pwr_limit_pnt_tbl;

                                                      	
 insert into acd_billsum_tbl(id_point,id_area,kind_energy, dt_begin,dt_end,
                            demand_val,sum_val,id_doc,mmgg,dt)
                 select 0,id_area,1, dat_b,dat_e,power_bill,sum_value,iddc,pmmgg,now()::date 
                      from   act_pwr_limit_over_tbl;

 update acm_bill_tbl set  demand_val=dem,value=val,value_tax=round(val*nds,2) 
   from   (select  sum(power_bill) as dem, sum(sum_value) as val 
            from  act_pwr_limit_over_tbl) as d where id_doc=iddc;

 select into sbill value from acm_bill_tbl where id_doc=iddc;

 insert into sys_error_tbl(nam,ident,id_error) values ('2kr','2krd_ok',10);
end if;

Return iddc;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION crt_dem2krmmgg_area(integer, date)
  OWNER TO local;

