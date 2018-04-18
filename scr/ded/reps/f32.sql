;
set client_encoding='win';

--update eqi_grouptarif_tbl set name = 'Мiськi населеннi пункти (крiм гуртожиткiв)' where id = 21;
--update eqi_grouptarif_tbl set name = 'Сiльськi населенi пункти (крiм гуртожиткiв)' where id = 25;
--update eqi_grouptarif_tbl set name = 'Населенi пункти з ел. плитами та ел. опаленням (крiм гуртожиткiв)' where id = 26;
--update eqi_grouptarif_tbl set ident = 'tgr7_4' where id = 78;

--update eqi_grouptarif_tbl set ident = 'tgr7_15' where id = 86;
--update eqi_grouptarif_tbl set ident = 'tgr7_25' where id = 87;
--update eqi_grouptarif_tbl set ident = 'tgr7_35' where id = 99;

--update eqi_grouptarif_tbl set name = 'Електроенергiя, яка витр. на технiчнi цiлi в мiстах' where id = 96;
--update eqi_grouptarif_tbl set name = 'Електроенергiя, яка витр. на технiчнi цiлi в сiльс. мiсцевостi' where id = 104;
--update eqi_grouptarif_tbl set name = 'Заклади пенiтенцiарної системи (в частинi спож. на комун.-побут.потреби)' where id = 100;


--update eqi_grouptarif_tbl set ident = 'tgr8_61' where id = 94;
--update eqi_grouptarif_tbl set ident = 'tgr8_62' where id = 100;
--update eqi_grouptarif_tbl set ident = 'tgr8_63' where id = 101;

--update eqi_grouptarif_tbl set ident = 'tgr8_10' where id = 21;
--update eqi_grouptarif_tbl set ident = 'tgr8_20' where id = 25;
--update eqi_grouptarif_tbl set ident = 'tgr8_30' where id = 26;

--update eqi_grouptarif_tbl set ident = 'tgr8_10' where id = 144;
--update eqi_grouptarif_tbl set ident = 'tgr8_43' where id = 146;
--update eqi_grouptarif_tbl set ident = 'tgr8_45' where id = 147;

--update eqi_grouptarif_tbl set ident = 'tgr8_30' where id = 145;


--update eqi_grouptarif_tbl set name = 'Гуртожитки, якi знаходяться в мiстах' where id = 107;
--update eqi_grouptarif_tbl set name = 'Гуртожитки, якi знаходяться в сiльськiй мiсцевостi' where id = 108;
--update eqi_grouptarif_tbl set name = 'Гуртожитки, обладнанi електроплитами або опаленням' where id = 109;

--UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'aci_tarif_tbl';
--UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqi_grouptarif_tbl';

--delete from acd_tarif_tbl where id_tarif in (select id from aci_tarif_tbl where id_grouptarif in (146,147,148));
--delete from aci_tarif_tbl where id_grouptarif in (146,147,148);
--delete from eqi_grouptarif_tbl where id in (146,147,148);

--UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
--WHERE relname = 'aci_tarif_tbl';
--UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
--WHERE relname = 'eqi_grouptarif_tbl';

--update eqi_grouptarif_tbl set ident = 'tgr8_101' where id = 163;

--update eqi_grouptarif_tbl set ident = 'tgr7_11' where id = 178;
--update eqi_grouptarif_tbl set ident = 'tgr7_21' where id = 23;

--update eqi_grouptarif_tbl set dt_end = '2015-03-31' where id = 104;
--update eqi_grouptarif_tbl set dt_end = '2012-04-30' where id = 84;

--alter table rep_f32_tbl alter column caption TYPE character varying(250);

update eqi_grouptarif_tbl set name = 'Мiське населення понад 100 кВтг' where ident = 'tgr7_123';
update eqi_grouptarif_tbl set name = 'Сiльське населення до 100 кВтг' where ident = 'tgr7_211';
update eqi_grouptarif_tbl set name = 'Сiльське населення понад 100 кВтг' where ident = 'tgr7_223';

create or replace function rep_f32_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;

  id_rep int;
  param_mode int;
  key_name0120 varchar; 
  vdepartment int;
  id_jkh int;
  vmmgg date;

BEGIN

 id_rep=32; -- код отчета в rep_kinds_tbl
 vdepartment = getsysvar(''kod_res'');
 vmmgg = date_trunc(''month'',pmmgg);

 if vmmgg>=''2017-03-01'' then
   return rep_f32_2017_fun(vmmgg);
 end if;

 if vmmgg>=''2015-04-01'' then
   return rep_f32_2015_fun(vmmgg);
 end if;

 delete from rep_f32_tbl where mmgg=pmmgg ;
             
 -- часть 1 -- по тарифам
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,1,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident not like ''tgr9%'' and ident<> ''tgr_pwr''
  and ident <> ''tgr8_63'' and ident <> ''tgr8_11'' and ident <> ''tgr8_21'' and ident <> ''tgr8_31'' and ident <> ''tgr7_4'' 
  and ((dt_begin is null) or (dt_begin <=pmmgg))
  and ((pmmgg >= ''2012-05-01'') or (ident not in (''tgr7_121'',''tgr7_221'',''tgr7_321'',''tgr8_10'',''tgr8_101'',''tgr8_30'',''tgr8_62'',''tgr8_63'') and ident not like ''tgr7_5%'' and ident not like ''tgr7_6%''  ) )
  --where coalesce(flag_priv,false)<> ''true''  
--  union
--  select addgroupname as name,ident from rep_tarifaddgr_tbl
--    select ''Населення-всього'',''tgr7'',2
--  union
--    select ''Населенi пункти-всього'',''tgr8'',2
 )as tgr

 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join (select id, CASE WHEN ident = ''tgr8_62'' and (pmmgg < ''2012-05-01'') THEN ''tgr8_1'' 
                        WHEN ident = ''tgr8_63'' THEN ''tgr8_3'' ELSE ident END as ident 
        from eqi_grouptarif_tbl ) as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
  --and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by tgr.ident
 ) as tcl1
-- on(strpos(tcl1.ident::text,tgr.ident::text)<>0)
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join (select id, CASE WHEN ident = ''tgr8_62'' and (pmmgg < ''2012-05-01'') THEN ''tgr8_1'' 
                        WHEN ident = ''tgr8_63'' THEN ''tgr8_3'' ELSE ident END as ident 
        from eqi_grouptarif_tbl ) as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char( pmmgg,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by tgr.ident
 ) as tcl2
 --on(strpos(tcl2.ident::text,tgr.ident::text)<>0)
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 -- Населення-всього

 if pmmgg >=''2012-05-01'' then

 insert into rep_f32_tbl 
 select vdepartment,''tgr7'',''Населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident~''tgr7'' or ident~''tgr8'') 
   and (ident <> ''tgr8_62'') and (ident <> ''tgr8_63'');

 else

 insert into rep_f32_tbl 
 select vdepartment,''tgr7'',''Населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7'';

 end if;

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_1s'',''Мiське населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ((ident~''tgr7_1'') or (ident = ''tgr8_61'') or (ident = ''tgr8_101''));

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_2s'',''Сiльське населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_2'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_3s'',''Населення з ел. плитами-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_3'';

 if pmmgg >=''2012-05-01'' then

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_51'',''Населення з ел. опаленням з 1 травня по 30 вересня'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_51'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_52'',''Населення з ел. опаленням з 1 жовтня по 30 квiтня'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_52'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_5s'',''Населення з ел. опаленням-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_5'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_61'',''Населення в негазиф. буд. з 1 травня по 30 вересня'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_61'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_62'',''Населення в негазиф. буд. з 1 жовтня по 30 квiтня'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_62'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_6s'',''Населення в негазиф.буд.-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_6'';

  if pmmgg >=''2013-01-01'' then

   update rep_f32_tbl set ident = ''tgr8_6'',
   caption = ''Електроенергiя,що вiдпускається споживачам, прирiвняним до населення (Заклади пенiтенцiарноє системи в частинi спож. на комун.-побут.потреби)'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr8_62'');

   -- убрать населенные пункты из отчета, эти тарифы больше не используются
   delete from rep_f32_tbl 
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ((ident=''tgr8_1'') or (ident=''tgr8_2'') or (ident=''tgr8_3''));


  else

   insert into rep_f32_tbl 
   select vdepartment,''tgr8_6'',''Електроенергiя,що вiдпускається споживачам, прирiвняним до населення у т.ч.'','''',sum(demand_tcl1),sum(sum_tcl1),
   sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
   from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ((ident=''tgr8_62'') or (ident=''tgr8_63''));

  end if;

 end if;

 if pmmgg <''2012-05-01'' then
 -- Населенi пункти-всього
 insert into rep_f32_tbl 
 select vdepartment,''tgr8'',''Населенi пункти-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr8'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr8_1s'',''Мiськi населенi пункти-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr8_1'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr8_2s'',''Сiльськi населенi пункти-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr8_2'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr8_3s'',''Нас.пункти з ел.плитами та ел.опаленням-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr8_3'';

 end if;

 --Итог по тарифам
 insert into rep_f32_tbl 
 select vdepartment,''s1'',''Всього по РЕМ'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,2,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and part_code=1 and ( gr_lvl=1 or (ident=''tgr8_6'' and pmmgg >=''2013-01-01'' ));
 --транзит и тяга - пока по 0
 --insert into rep_f32_tbl select vdepartment,''tr'',''Транзит'','''',0,0,0,0,2,3,pmmgg;
 --insert into rep_f32_tbl select vdepartment,''tve'',''ТВЕ - тяга'','''',0,0,0,0,2,3,pmmgg;


 insert into rep_f32_tbl 
 select vdepartment,''tr'',''Транзит'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,0,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,0,
 2,3,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 209
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 209
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl2
 using (id_section);


 insert into rep_f32_tbl 
 select vdepartment,''tve'',''ТВЕ - тяга'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,0,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,0,
 2,3,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.id_section = 217
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 217
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl2
 using (id_section);

 -- если нет тяги и транзита, добавим пустые строки
 select into v id_department 
 from rep_f32_tbl where ident = ''tve''and mmgg=pmmgg;

 if not found then 
  insert into rep_f32_tbl select vdepartment,''tve'',''ТВЕ - тяга'','''',0,0,0,0,2,3,pmmgg;
 end if;

 select into v id_department 
 from rep_f32_tbl where ident = ''tr'' and mmgg=pmmgg;

 if not found then 
  insert into rep_f32_tbl select vdepartment,''tr'',''Транзит'','''',0,0,0,0,2,3,pmmgg;
 end if;

 -- еще один итог
 insert into rep_f32_tbl 
 select vdepartment,''s2'',''ВСЬОГО'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,4,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and (ident=''s1'' or ident=''tr'' or ident=''tve'');
 -- опять итог - копия s1
 insert into rep_f32_tbl 
 select vdepartment,''s3'',''Всього власнi споживачi'','''',demand_tcl1,sum_tcl1,
 demand_tcl2,sum_tcl2,3,5,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and ident=''s1'';
 --По бюджетам

 insert into rep_f32_tbl 
 select vdepartment,bdg.kod,bdg.name,'''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 1,6,pmmgg
 from
 (
  select   CASE WHEN p.lev=3 THEN p.id  ELSE p.id_parent END AS budjet,
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join cla_param_tbl as p on (stcl.id_section=p.id)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101) and (bm.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and p.id in (211,213,214,215)
  group by budjet
 ) as tcl1
 Full outer join
 (
  select   CASE WHEN p.lev=3 THEN p.id  ELSE p.id_parent END AS budjet,
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join cla_param_tbl as p on (stcl.id_section=p.id)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101) and (bm.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and p.id in (211,213,214,215)
  group by budjet
 ) as tcl2
 using (budjet)
 right join
 (
  select ''в тому числi: установи та орган. держ. бюджету''::varchar as name, ''211''::varchar as kod,211 as budjet
  union
  select ''              установи та орган. мiсцевого бюджету'' as name, ''212'' as kod,212 as budjet
 ) as bdg
  using (budjet);
  
 --Итог по бюджету (будет отображен перед детализацией)
 insert into rep_f32_tbl 
 select vdepartment,''210'',''Бюджет - всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,6,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=6;
 --по уровням напряжения
 -- заголовочек
 insert into rep_f32_tbl 
 select vdepartment,''0'',''Iз власних споживачiв:'','''',null,null, null,null,2,8,pmmgg;
 -- и данные 

 insert into rep_f32_tbl 
 select vdepartment,vlt.kod,vlt.name,'''',
 sum(coalesce(demand_tcl1,0)::numeric) as demand_tcl1,sum(coalesce(sum_tcl1,0)) as sum_tcl1,
 sum(coalesce(demand_tcl2,0)::numeric) as demand_tcl2,sum(coalesce(sum_tcl2,0)) as sum_tcl2,
-- coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
-- coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 1,8,pmmgg
 from
 (
  select vv.voltage_min,  
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_client_tbl as cl on (cl.id = b.id_client) 
--  join (select code_eqp, max(id_voltage) as id_voltage from eqm_point_h group by code_eqp ) as ph on (bs.id_point = ph.code_eqp)
--  join (select p2.code_eqp, p2.id_voltage from eqm_point_h as p2 where p2.dt_b = (select max(p3.dt_b) from eqm_point_h as p3 where p3.code_eqp = p2.code_eqp ) ) as ph
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  --and bs.demand_val<>0
  and coalesce(ph.id_extra,0) <> 1011
  and coalesce(ph.id_extra,0) <> 1014
  and cl.idk_work <> 0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and tgr.ident not like ''%tgr7%'' and tgr.ident not like ''%tgr8%'' and tgr.ident not like ''%tgr9%'' 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by vv.voltage_min
 ) as tcl1
 Full outer join
 (
  select vv.voltage_min,  
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_client_tbl as cl on (cl.id = b.id_client)
--  join (select code_eqp, max(id_voltage) as id_voltage from eqm_point_h group by code_eqp ) as ph on (bs.id_point = ph.code_eqp)
--  join (select p2.code_eqp, p2.id_voltage from eqm_point_h as p2 where p2.dt_b = (select max(p3.dt_b) from eqm_point_h as p3 where p3.code_eqp = p2.code_eqp ) ) as ph
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and coalesce(ph.id_extra,0) <> 1011
  and coalesce(ph.id_extra,0) <> 1014
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and tgr.ident not like ''%tgr7%'' and tgr.ident not like ''%tgr8%'' and tgr.ident not like ''%tgr9%'' 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by vv.voltage_min
 ) as tcl2
 using (voltage_min)
 right join
 (
  select ''по 10 кВ (крiм населення)''::varchar as name, 10::int as v_max,3::int as v_min,''010''::varchar as kod
  union
  select ''по 0,4 кВ (крiм населення)'',0.4,0.2 ,''004''
  union
  select ''по 35 кВ (крiм населення)'',35 ,27, ''035''
  union
  select ''по 110 кВ (крiм населення)'',160 ,110,''110''
 ) as vlt
-- on (voltage_min=vlt.voltage);
 on (voltage_min<=vlt.v_max and voltage_min>=vlt.v_min) 
group by vlt.kod,vlt.name order by kod;

--житлово - комунальне господарство

  key_name0120:=''gr_jkh'';  --ключевое имя параметра "Житлово-комун.госп"
-- необходимо отметить им нужный элемент в cla_param_tbl


  select into id_jkh id from cla_param_tbl where key_name=key_name0120 and id_group = 200;

  Raise Notice '' id_jkh % '',id_jkh;

  -- выбрать параметры в развернутом виде
--  delete from rep_param_trace_tbl where id_group = id_jkh;

--  v:=rep_param_trace_fun(id_jkh,id_jkh);


 insert into rep_f32_tbl 
 select vdepartment,''203'',jkh.name,'''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 2,7,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
--  join rep_setrepa_tbl as sra on (stcl.id_kwed = sra.id_statecl)
--  join rep_setrep_tbl as  sr on (sr.id_report=id_rep and sr.id=sra.id_setrep)
--  join rep_param_trace_tbl as pt on (pt.id_group=id_jkh and pt.id_param=sra.id_param and pt.id_parent=pt.id_group)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  --and bs.demand_val<>0 
  and stcl.id_section = id_jkh
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and cl.idk_work <> 0
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
--  join rep_setrepa_tbl as sra on (stcl.id_kwed = sra.id_statecl)
--  join rep_setrep_tbl as  sr on (sr.id_report=id_rep and sr.id=sra.id_setrep)
--  join rep_param_trace_tbl as pt on (pt.id_group=id_jkh and pt.id_param=sra.id_param and pt.id_parent=pt.id_group)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  --and bs.demand_val<>0 
  and stcl.id_section = id_jkh
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and cl.idk_work <> 0
  group by stcl.id_section
 ) as tcl2
 using (id_section)
 right join
 (
  select ''Житлово - комунальне господарство''::varchar as name,id_jkh as kod
 ) as jkh
 on (jkh.kod=id_section);

 -------------------------------------------------------------------
 -- юр.лица -- по тарифам населения
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,11,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where (ident like ''tgr7_1%'') or (ident like ''tgr7_2%'') 
 and ((dt_begin is null) or (dt_begin <=pmmgg)) ) as tgr

 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char( pmmgg,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 --Итог по тарифам
 insert into rep_f32_tbl 
 select vdepartment,''s11'',''Всього по юридичним споживачам'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,10,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=11;


 -- акты по тарифам населения
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,13,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where (ident like ''tgr7%'') and ((dt_begin is null) or (dt_begin <=pmmgg))  ) as tgr

 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section = 208
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char( pmmgg,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section  =208
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 --Итог по актам
 insert into rep_f32_tbl 
 select vdepartment,''s12'',''Виставленi рахунки за порушення ПКЕЕ'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,12,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=13;

 --для нежина персонально!
 --прямо указываю абонента и его точку учета
 insert into rep_f32_tbl 
 select vdepartment,''ees'',''З шин ПС ЕЕС'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 2,15,pmmgg
 from
 (
  select 1 as id_section,  
  sum(bs.demand_val) as demand_tcl1,round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
--  join clm_statecl_tbl as stcl on (stcl.id_client=bm.id_client)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and coalesce(ph.id_extra,0) = 1011
--  and bm.id_client = 2154 and bs.id_point = 265559 
--  and  (select value_ident from syi_sysvars_tbl where ident=''kod_res'') in (''210'',''211'')
--  and stcl.id_section = 217
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by 1
 ) as tcl1
 Full outer join
 (
  select 1 as id_section,  
  sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
--  join clm_statecl_tbl as stcl on (stcl.id_client=bm.id_client)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and coalesce(ph.id_extra,0) = 1011
--  and bm.id_client = 2154 and bs.id_point = 265559 
--  and  (select value_ident from syi_sysvars_tbl where ident=''kod_res'') in (''210'',''211'')
--  and stcl.id_section = 217
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by 1
 ) as tcl2
 using (id_section);

 --для городских персонально!
 --прямо указываю абонента и его точку учета
 insert into rep_f32_tbl 
 select vdepartment,''tec'',''З шин ТЕЦ'','''',
 (coalesce(demand_tcl1,0))::numeric as demand_tcl1,(coalesce(sum_tcl1,0)) as sum_tcl1,
 (coalesce(demand_tcl2,0))::numeric as demand_tcl2,(coalesce(sum_tcl2,0)) as sum_tcl2,
 2,15,pmmgg
 from
 ( select  sum(demand_tcl1) as demand_tcl1, sum(sum_tcl1) as sum_tcl1,
   sum(demand_tcl2) as demand_tcl2, sum(sum_tcl2) as sum_tcl2 from 
   (select 1 as id_section, 
    sum(bs.demand_val) as demand_tcl1,round(sum(bs.sum_val),2) as sum_tcl1
    from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
    join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
    join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
--    join clm_statecl_tbl as stcl on (stcl.id_client=bm.id_client)
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
    where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
    and coalesce(ph.id_extra,0) = 1014
--   and bm.id_client = 2154 and bs.id_point = 265559 
--   and  (select value_ident from syi_sysvars_tbl where ident=''kod_res'') in (''210'',''211'')
--   and stcl.id_section = 217
--    and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
    and bs.mmgg=vmmgg 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point
    and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
    group by 1
   ) as tcl1
   Full outer join
  (
   select 1 as id_section,  
    sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
    from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
    join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
    join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
--    join clm_statecl_tbl as stcl on (stcl.id_client=bm.id_client)
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
    where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
    and coalesce(ph.id_extra,0) = 1014
--    and bm.id_client = 2154 and bs.id_point = 265559 
--    and  (select value_ident from syi_sysvars_tbl where ident=''kod_res'') in (''210'',''211'')
--    and stcl.id_section = 217
--    and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
    and bs.mmgg=vmmgg 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
    group by 1
  ) as tcl2
  using (id_section) ) as fff--group by id_section 
-- group by vdepartment,''tec'',''З шин ТЕЦ'','''',2,15,pmmgg
;
 

 -- юр.лица -- по тарифам населения з електроплитами
 insert into rep_f32_tbl 
 select vdepartment,text(tgr.id_extra),tgr.name,'''', 0::numeric as demand_tcl1,0 as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 tgr.lvl,11,pmmgg
 from
 (select 1007 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3'' 
   union
  select 1008 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3''
  )as tgr
 left join
 (
  select ph.id_extra, sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_tbl as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  and ph.id_extra in (1007,1008) and tgr.ident like ''tgr7_3%''
  and cl.idk_work <> 0
  group by ph.id_extra
 ) as tcl2 on (tgr.id_extra=tcl2.id_extra);

 -- акти -- по тарифам населения з електроплитами
 insert into rep_f32_tbl 
 select vdepartment,text(tgr.id_extra),tgr.name,'''', 0::numeric as demand_tcl1,0 as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 tgr.lvl,13,pmmgg
 from
 (select 1007 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3'' 
   union
  select 1008 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3''
  )as tgr
 left join
 (
  select ph.id_extra, sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section = 208
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  and ph.id_extra in (1007,1008) and tgr.ident like ''tgr7_3%''
  and cl.idk_work <> 0
  group by ph.id_extra
 ) as tcl2 on (tgr.id_extra=tcl2.id_extra);


 if pmmgg >=''2014-11-01'' then

   delete from  rep_f32_tbl  where mmgg=pmmgg and ident in (''tgr7_521'',''tgr7_522'', ''tgr7_621'', ''tgr7_622'') ;

   update  rep_f32_tbl set ident = ''tgr7_521'' where ident = ''tgr7_5211'' and mmgg=pmmgg ;  
   update  rep_f32_tbl set ident = ''tgr7_522'' where ident = ''tgr7_5221'' and mmgg=pmmgg ;  

   update  rep_f32_tbl set ident = ''tgr7_621'' where ident = ''tgr7_6211'' and mmgg=pmmgg ;  
   update  rep_f32_tbl set ident = ''tgr7_622'' where ident = ''tgr7_6221'' and mmgg=pmmgg ;  

 else
   delete from  rep_f32_tbl  where mmgg=pmmgg and ident in (''tgr7_5211'',''tgr7_5221'', ''tgr7_6211'', ''tgr7_6221'') ;
 end if; 

 update  rep_f32_tbl set num = ident where mmgg=pmmgg ;
 update  rep_f32_tbl set num = ''tgr7_140'' where ident = ''tgr8_101'' and mmgg=pmmgg ;  
 update  rep_f32_tbl set num = ''tgr7_141'' where ident = ''tgr8_61'' and mmgg=pmmgg ;  
 
RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

create or replace function rep_f32_2015_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;

  id_rep int;
  param_mode int;
  key_name0120 varchar; 
  vdepartment int;
  id_jkh int;
  vmmgg date;

BEGIN

 id_rep=32; -- код отчета в rep_kinds_tbl
 vdepartment = getsysvar(''kod_res'');
 vmmgg = date_trunc(''month'',pmmgg);

 delete from rep_f32_tbl where mmgg=pmmgg ;
             
 -- часть 1 -- по тарифам
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,1,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident not like ''tgr9%'' and ident<> ''tgr_pwr''
  and ((dt_begin is null) or (dt_begin <=pmmgg))
  and ((dt_end is null) or (dt_end > pmmgg))
 )as tgr

 left join
 (
  select ident, sum(demand_val) as demand_tcl1, round(sum(sum_val),2) as sum_tcl1
  from
  ( select CASE WHEN tgr.ident = ''tgr8_30'' THEN ''tgr8_10''   -- населення за загальним учетом
         WHEN tgr.ident in (''tgr8_62'',''tgr8_63'') THEN ''tgr5''   -- тюрьмы
         WHEN tgr.ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'') THEN ''tgr8_4''  -- гуртожитки
         WHEN tgr.ident = ''tgr7_23'' THEN ''tgr7_13''   -- тех цели с села перенести на город
         ELSE tgr.ident END as ident,   bs.demand_val, bs.sum_val
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join (select id, ident  from eqi_grouptarif_tbl order by id) as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and cl.idk_work <> 0
  and bs.mmgg=vmmgg 
  ) as sss  group by ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select ident, sum(demand_val) as demand_tcl2, round(sum(sum_val),2) as sum_tcl2
  from
  ( select CASE WHEN tgr.ident = ''tgr8_30'' THEN ''tgr8_10''   -- населення за загальним учетом
         WHEN tgr.ident in (''tgr8_62'',''tgr8_63'') THEN ''tgr5''   -- тюрьмы
         WHEN tgr.ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'') THEN ''tgr8_4''  -- гуртожитки
         WHEN tgr.ident = ''tgr7_23'' THEN ''tgr7_13''   -- тех цели с села перенести на город
         ELSE tgr.ident END as ident,   bs.demand_val, bs.sum_val
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join (select id, ident from eqi_grouptarif_tbl order by id) as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and cl.idk_work <> 0
  and bs.mmgg=vmmgg 
  ) as sss  group by ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 -- Населення-всього

 insert into rep_f32_tbl 
 select vdepartment,''tgr7'',''Населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident~''tgr7'' or ident~''tgr8'') ;

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_1'',''1.1.Мiське населення-всього (в т.ч. електроплити мiсто)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ((ident~''tgr7_1'') or (ident = ''tgr8_61'') or (ident = ''tgr8_101''));

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_2'',''1.2.Сiльське населення-всього (в т.ч. електроплити село)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_2'' and ident <> ''tgr7_23'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_5'',''1.3.Населення з ел. опаленням-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_5'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_52'',''1.3.1.Населення з ел. опаленням (з 1 жовтня по 30 квiтня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_52'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_51'',''1.3.2.Населення з ел. опаленням (з 1 травня по 30 вересня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_51'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_6'',''1.4.Населення в негазиф.буд.-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_6'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_62'',''1.4.1.Населення в негазиф. буд. (з 1 жовтня по 30 квiтня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_62'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_61'',''1.4.2.Населення в негазиф. буд. (з 1 травня по 30 вересня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_61'';



 update rep_f32_tbl set ident = ''tgr7_7'',
   caption = ''1.5.Багатодiтнi, прийомнi сiм''''ї, дит.будинки сiмейного типу незалежно вiд обсягiв спож. електроенергiї'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr7_7'');

 update rep_f32_tbl set ident = ''tgr8_1'',
   caption = ''1.6.Населення, яке розраховується з енергопостачальною органiзацiєю за загальним 
    розрахунковим засобом облiку та об''''єднане шляхом створення юридичної особи, житлово-експлуатацiйним органiзацiям, крiм гуртожиткiв'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr8_10'');


 update rep_f32_tbl set ident = ''tgr8_4'',
   caption = ''1.7.Гуртожитки (якi пiдпадають пiд визначення "населення, яке розраховується з енергопостачальною органiзацiєю за загальним розрахунковим засобом облiку")'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr8_4'');



 --Итог по тарифам
 insert into rep_f32_tbl 
 select vdepartment,''s1'',''Всього по РЕМ'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,2,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and part_code=1 and ( gr_lvl=1 or (ident in (''tgr7_7'',''tgr8_1'',''tgr8_4'' )));
 --транзит и тяга - пока по 0
 --insert into rep_f32_tbl select vdepartment,''tr'',''Транзит'','''',0,0,0,0,2,3,pmmgg;
 --insert into rep_f32_tbl select vdepartment,''tve'',''ТВЕ - тяга'','''',0,0,0,0,2,3,pmmgg;


 insert into rep_f32_tbl 
 select vdepartment,''tr'',''Транзит'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,0,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,0,
 2,3,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 209
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 209
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl2
 using (id_section);


 insert into rep_f32_tbl 
 select vdepartment,''tve'',''ТВЕ - тяга'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,0,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,0,
 2,3,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.id_section = 217
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 217
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl2
 using (id_section);

 -- если нет тяги и транзита, добавим пустые строки
 select into v id_department 
 from rep_f32_tbl where ident = ''tve''and mmgg=pmmgg;

 if not found then 
  insert into rep_f32_tbl select vdepartment,''tve'',''ТВЕ - тяга'','''',0,0,0,0,2,3,pmmgg;
 end if;

 select into v id_department 
 from rep_f32_tbl where ident = ''tr'' and mmgg=pmmgg;

 if not found then 
  insert into rep_f32_tbl select vdepartment,''tr'',''Транзит'','''',0,0,0,0,2,3,pmmgg;
 end if;

 -- еще один итог
 insert into rep_f32_tbl 
 select vdepartment,''s2'',''ВСЬОГО'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,4,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and (ident=''s1'' or ident=''tr'' or ident=''tve'');
 -- опять итог - копия s1
 insert into rep_f32_tbl 
 select vdepartment,''s3'',''Всього власнi споживачi'','''',demand_tcl1,sum_tcl1,
 demand_tcl2,sum_tcl2,3,5,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and ident=''s1'';
 --По бюджетам

 insert into rep_f32_tbl 
 select vdepartment,bdg.kod,bdg.name,'''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 1,6,pmmgg
 from
 (
  select   CASE WHEN p.lev=3 THEN p.id  ELSE p.id_parent END AS budjet,
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join cla_param_tbl as p on (stcl.id_section=p.id)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101) and (bm.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and p.id in (211,213,214,215)
  group by budjet
 ) as tcl1
 Full outer join
 (
  select   CASE WHEN p.lev=3 THEN p.id  ELSE p.id_parent END AS budjet,
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join cla_param_tbl as p on (stcl.id_section=p.id)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101) and (bm.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and p.id in (211,213,214,215)
  group by budjet
 ) as tcl2
 using (budjet)
 right join
 (
  select ''в тому числi: установи та орган. держ. бюджету''::varchar as name, ''211''::varchar as kod,211 as budjet
  union
  select ''              установи та орган. мiсцевого бюджету'' as name, ''212'' as kod,212 as budjet
 ) as bdg
  using (budjet);
  
 --Итог по бюджету (будет отображен перед детализацией)
 insert into rep_f32_tbl 
 select vdepartment,''210'',''Бюджет - всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,6,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=6;
 --по уровням напряжения
 -- заголовочек
 insert into rep_f32_tbl 
 select vdepartment,''0'',''Iз власних споживачiв:'','''',null,null, null,null,2,8,pmmgg;
 -- и данные 

 insert into rep_f32_tbl 
 select vdepartment,vlt.kod,vlt.name,'''',
 sum(coalesce(demand_tcl1,0)::numeric) as demand_tcl1,sum(coalesce(sum_tcl1,0)) as sum_tcl1,
 sum(coalesce(demand_tcl2,0)::numeric) as demand_tcl2,sum(coalesce(sum_tcl2,0)) as sum_tcl2,
-- coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
-- coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 1,8,pmmgg
 from
 (
  select vv.voltage_min,  
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_client_tbl as cl on (cl.id = b.id_client) 
--  join (select code_eqp, max(id_voltage) as id_voltage from eqm_point_h group by code_eqp ) as ph on (bs.id_point = ph.code_eqp)
--  join (select p2.code_eqp, p2.id_voltage from eqm_point_h as p2 where p2.dt_b = (select max(p3.dt_b) from eqm_point_h as p3 where p3.code_eqp = p2.code_eqp ) ) as ph
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  --and bs.demand_val<>0
  and coalesce(ph.id_extra,0) <> 1011
  and coalesce(ph.id_extra,0) <> 1014
  and cl.idk_work <> 0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and ((tgr.ident not like ''%tgr7%'' and tgr.ident not like ''%tgr8%'' and tgr.ident not like ''%tgr9%'') or ( tgr.ident in (''tgr8_62'',''tgr8_63'')))
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by vv.voltage_min
 ) as tcl1
 Full outer join
 (
  select vv.voltage_min,  
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_client_tbl as cl on (cl.id = b.id_client)
--  join (select code_eqp, max(id_voltage) as id_voltage from eqm_point_h group by code_eqp ) as ph on (bs.id_point = ph.code_eqp)
--  join (select p2.code_eqp, p2.id_voltage from eqm_point_h as p2 where p2.dt_b = (select max(p3.dt_b) from eqm_point_h as p3 where p3.code_eqp = p2.code_eqp ) ) as ph
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and coalesce(ph.id_extra,0) <> 1011
  and coalesce(ph.id_extra,0) <> 1014
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and ((tgr.ident not like ''%tgr7%'' and tgr.ident not like ''%tgr8%'' and tgr.ident not like ''%tgr9%'') or ( tgr.ident in (''tgr8_62'',''tgr8_63'')))
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by vv.voltage_min
 ) as tcl2
 using (voltage_min)
 right join
 (
  select ''по 10 кВ (крiм населення)''::varchar as name, 10::int as v_max,3::int as v_min,''010''::varchar as kod
  union
  select ''по 0,4 кВ (крiм населення)'',0.4,0.2 ,''004''
  union
  select ''по 35 кВ (крiм населення)'',35 ,27, ''035''
  union
  select ''по 110 кВ (крiм населення)'',160 ,110,''110''
 ) as vlt
-- on (voltage_min=vlt.voltage);
 on (voltage_min<=vlt.v_max and voltage_min>=vlt.v_min) 
group by vlt.kod,vlt.name order by kod;

--житлово - комунальне господарство

  key_name0120:=''gr_jkh'';  --ключевое имя параметра "Житлово-комун.госп"
-- необходимо отметить им нужный элемент в cla_param_tbl


  select into id_jkh id from cla_param_tbl where key_name=key_name0120 and id_group = 200;

  Raise Notice '' id_jkh % '',id_jkh;

  -- выбрать параметры в развернутом виде
--  delete from rep_param_trace_tbl where id_group = id_jkh;

--  v:=rep_param_trace_fun(id_jkh,id_jkh);


 insert into rep_f32_tbl 
 select vdepartment,''203'',jkh.name,'''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 2,7,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
--  join rep_setrepa_tbl as sra on (stcl.id_kwed = sra.id_statecl)
--  join rep_setrep_tbl as  sr on (sr.id_report=id_rep and sr.id=sra.id_setrep)
--  join rep_param_trace_tbl as pt on (pt.id_group=id_jkh and pt.id_param=sra.id_param and pt.id_parent=pt.id_group)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  --and bs.demand_val<>0 
  and stcl.id_section = id_jkh
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and cl.idk_work <> 0
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
--  join rep_setrepa_tbl as sra on (stcl.id_kwed = sra.id_statecl)
--  join rep_setrep_tbl as  sr on (sr.id_report=id_rep and sr.id=sra.id_setrep)
--  join rep_param_trace_tbl as pt on (pt.id_group=id_jkh and pt.id_param=sra.id_param and pt.id_parent=pt.id_group)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  --and bs.demand_val<>0 
  and stcl.id_section = id_jkh
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and cl.idk_work <> 0
  group by stcl.id_section
 ) as tcl2
 using (id_section)
 right join
 (
  select ''Житлово - комунальне господарство''::varchar as name,id_jkh as kod
 ) as jkh
 on (jkh.kod=id_section);

 -------------------------------------------------------------------
 -- юр.лица -- по тарифам населения
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,11,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where (ident like ''tgr7_1%'') or (ident like ''tgr7_2%'') 
 and ((dt_begin is null) or (dt_begin <=pmmgg)) 
 and ((dt_end is null)   or (dt_end > pmmgg))  ) as tgr

 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char( pmmgg,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 --Итог по тарифам
 insert into rep_f32_tbl 
 select vdepartment,''s11'',''Всього по юридичним споживачам'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,10,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=11;


 -- акты по тарифам населения
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,13,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where (ident like ''tgr7%'') 
  and ((dt_begin is null) or (dt_begin <=pmmgg)) 
  and ((dt_end is null)   or (dt_end > pmmgg)) ) as tgr
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
  and bs.mmgg=vmmgg 
  and scl.id_section = 208
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
  and bs.mmgg=vmmgg 
  and scl.id_section  =208
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 --Итог по актам
 insert into rep_f32_tbl 
 select vdepartment,''s12'',''Виставленi рахунки за порушення ПКЕЕ'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,12,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=13;

 --для нежина персонально!
 --прямо указываю абонента и его точку учета
 insert into rep_f32_tbl 
 select vdepartment,''ees'',''З шин ПС ЕЕС'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 2,15,pmmgg
 from
 (
  select 1 as id_section,  
  sum(bs.demand_val) as demand_tcl1,round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and coalesce(ph.id_extra,0) = 1011
  and bs.mmgg=vmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by 1
 ) as tcl1
 Full outer join
 (
  select 1 as id_section,  
  sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and coalesce(ph.id_extra,0) = 1011
  and bs.mmgg=vmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by 1
 ) as tcl2
 using (id_section);

 --для городских персонально!
 --прямо указываю абонента и его точку учета
 insert into rep_f32_tbl 
 select vdepartment,''tec'',''З шин ТЕЦ'','''',
 (coalesce(demand_tcl1,0))::numeric as demand_tcl1,(coalesce(sum_tcl1,0)) as sum_tcl1,
 (coalesce(demand_tcl2,0))::numeric as demand_tcl2,(coalesce(sum_tcl2,0)) as sum_tcl2,
 2,15,pmmgg
 from
 ( select  sum(demand_tcl1) as demand_tcl1, sum(sum_tcl1) as sum_tcl1,
   sum(demand_tcl2) as demand_tcl2, sum(sum_tcl2) as sum_tcl2 from 
   (select 1 as id_section, 
    sum(bs.demand_val) as demand_tcl1,round(sum(bs.sum_val),2) as sum_tcl1
    from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
    join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
    join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
    where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
    and coalesce(ph.id_extra,0) = 1014
    and bs.mmgg=vmmgg 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point
    and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
    group by 1
   ) as tcl1
   Full outer join
  (
   select 1 as id_section,  
    sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
    from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
    join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
    join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
    where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
    and coalesce(ph.id_extra,0) = 1014
    and bs.mmgg=vmmgg 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
    group by 1
  ) as tcl2
  using (id_section) ) as fff--group by id_section 
-- group by vdepartment,''tec'',''З шин ТЕЦ'','''',2,15,pmmgg
;
 
/*
 -- юр.лица -- по тарифам населения з електроплитами
 insert into rep_f32_tbl 
 select vdepartment,text(tgr.id_extra),tgr.name,'''', 0::numeric as demand_tcl1,0 as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 tgr.lvl,11,pmmgg
 from
 (select 1007 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3'' 
   union
  select 1008 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3''
  )as tgr
 left join
 (
  select ph.id_extra, sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_tbl as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  and ph.id_extra in (1007,1008) and tgr.ident like ''tgr7_3%''
  and cl.idk_work <> 0
  group by ph.id_extra
 ) as tcl2 on (tgr.id_extra=tcl2.id_extra);

 -- акти -- по тарифам населения з електроплитами
 insert into rep_f32_tbl 
 select vdepartment,text(tgr.id_extra),tgr.name,'''', 0::numeric as demand_tcl1,0 as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 tgr.lvl,13,pmmgg
 from
 (select 1007 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3'' 
   union
  select 1008 as id_extra, name ,ident, 1 as lvl from eqi_grouptarif_tbl where ident = ''tgr7_3''
  )as tgr
 left join
 (
  select ph.id_extra, sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section = 208
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  and ph.id_extra in (1007,1008) and tgr.ident like ''tgr7_3%''
  and cl.idk_work <> 0
  group by ph.id_extra
 ) as tcl2 on (tgr.id_extra=tcl2.id_extra);
*/
/*
 if pmmgg >=''2014-11-01'' then

   delete from  rep_f32_tbl  where mmgg=pmmgg and ident in (''tgr7_521'',''tgr7_522'', ''tgr7_621'', ''tgr7_622'') ;

   update  rep_f32_tbl set ident = ''tgr7_521'' where ident = ''tgr7_5211'' and mmgg=pmmgg ;  
   update  rep_f32_tbl set ident = ''tgr7_522'' where ident = ''tgr7_5221'' and mmgg=pmmgg ;  

   update  rep_f32_tbl set ident = ''tgr7_621'' where ident = ''tgr7_6211'' and mmgg=pmmgg ;  
   update  rep_f32_tbl set ident = ''tgr7_622'' where ident = ''tgr7_6221'' and mmgg=pmmgg ;  

 else
   delete from  rep_f32_tbl  where mmgg=pmmgg and ident in (''tgr7_5211'',''tgr7_5221'', ''tgr7_6211'', ''tgr7_6221'') ;
 end if; 
*/
 update  rep_f32_tbl set num = ident where mmgg=pmmgg ;
 update  rep_f32_tbl set num = ''tgr7_140'' where ident = ''tgr8_101'' and mmgg=pmmgg ;  
 update  rep_f32_tbl set num = ''tgr7_141'' where ident = ''tgr8_61'' and mmgg=pmmgg ;  
 
RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

------------------------------------------------------------------------------------------------------------------------------

create or replace function rep_f32_2017_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;

  id_rep int;
  param_mode int;
  key_name0120 varchar; 
  vdepartment int;
  id_jkh int;
  vmmgg date;

BEGIN

 id_rep=32; -- код отчета в rep_kinds_tbl
 vdepartment = getsysvar(''kod_res'');
 vmmgg = date_trunc(''month'',pmmgg);

 delete from rep_f32_tbl where mmgg=pmmgg ;
             
 -- часть 1 -- по тарифам
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,1,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where 
  (ident not like ''tgr9%'' and ident not in (''tgr_pwr'',''tgr7_5141'',''tgr7_5151'',''tgr7_6141'',''tgr7_6151''))
  and ((dt_begin is null) or (dt_begin <=pmmgg))
  and ((dt_end is null) or (dt_end > pmmgg))
 )as tgr

 left join
 (
  select ident, sum(demand_val) as demand_tcl1, round(sum(sum_val),2) as sum_tcl1
  from
  ( select CASE WHEN tgr.ident = ''tgr8_30'' THEN ''tgr8_10''   -- населення за загальним учетом
         WHEN tgr.ident in (''tgr8_62'',''tgr8_63'') THEN ''tgr5''   -- тюрьмы
         WHEN tgr.ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'') THEN ''tgr8_4''  -- гуртожитки
         WHEN tgr.ident = ''tgr7_23'' THEN ''tgr7_13''   -- тех цели с села перенести на город

         WHEN tgr.ident in (''tgr7_1'',''tgr7_11'') THEN ''tgr7_11''  
         WHEN tgr.ident ~ ''tgr7_12'' THEN ''tgr7_123''

         WHEN tgr.ident in (''tgr7_21'',''tgr7_211'') THEN ''tgr7_211''  
         WHEN tgr.ident ~ ''tgr7_22'' THEN ''tgr7_223''


         WHEN tgr.ident in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN ''tgr7_511''  
         WHEN (tgr.ident ~ ''tgr7_51'') and tgr.ident not in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN ''tgr7_5121''  

         WHEN (tgr.ident ~ ''tgr7_521'') THEN ''tgr7_5212''  
         WHEN (tgr.ident ~ ''tgr7_522'') THEN ''tgr7_5222''  


         WHEN tgr.ident in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN ''tgr7_611''  
         WHEN (tgr.ident ~ ''tgr7_61'') and tgr.ident not in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN ''tgr7_6121''  

         WHEN (tgr.ident ~ ''tgr7_621'') THEN ''tgr7_6212''  
         WHEN (tgr.ident ~ ''tgr7_622'') THEN ''tgr7_6222''  

         ELSE tgr.ident END as ident,   bs.demand_val, bs.sum_val
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join (select id, ident  from eqi_grouptarif_tbl order by id) as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and cl.idk_work <> 0
  and bs.mmgg=vmmgg 
  ) as sss  group by ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select ident, sum(demand_val) as demand_tcl2, round(sum(sum_val),2) as sum_tcl2
  from
  ( select CASE WHEN tgr.ident = ''tgr8_30'' THEN ''tgr8_10''   -- населення за загальним учетом
         WHEN tgr.ident in (''tgr8_62'',''tgr8_63'') THEN ''tgr5''   -- тюрьмы
         WHEN tgr.ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'') THEN ''tgr8_4''  -- гуртожитки
         WHEN tgr.ident = ''tgr7_23'' THEN ''tgr7_13''   -- тех цели с села перенести на город


         WHEN tgr.ident in (''tgr7_1'',''tgr7_11'') THEN ''tgr7_11''  
         WHEN tgr.ident ~ ''tgr7_12'' THEN ''tgr7_123''

         WHEN tgr.ident in (''tgr7_21'',''tgr7_211'') THEN ''tgr7_211''  
         WHEN tgr.ident ~ ''tgr7_22'' THEN ''tgr7_223''


         WHEN tgr.ident in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN ''tgr7_511''  
         WHEN (tgr.ident ~ ''tgr7_51'') and tgr.ident not in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN ''tgr7_5121''  

         WHEN (tgr.ident ~ ''tgr7_521'') THEN ''tgr7_5212''  
         WHEN (tgr.ident ~ ''tgr7_522'') THEN ''tgr7_5222''  


         WHEN tgr.ident in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN ''tgr7_611''  
         WHEN (tgr.ident ~ ''tgr7_61'') and tgr.ident not in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN ''tgr7_6121''  

         WHEN (tgr.ident ~ ''tgr7_621'') THEN ''tgr7_6212''  
         WHEN (tgr.ident ~ ''tgr7_622'') THEN ''tgr7_6222''  

         ELSE tgr.ident END as ident,   bs.demand_val, bs.sum_val
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join (select id, ident from eqi_grouptarif_tbl order by id) as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and cl.idk_work <> 0
  and bs.mmgg=vmmgg 
  ) as sss  group by ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 -- Населення-всього

 insert into rep_f32_tbl 
 select vdepartment,''tgr7'',''Населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident~''tgr7'' or ident~''tgr8'') ;

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_1'',''1.1.Мiське населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ((ident~''tgr7_1'') or (ident = ''tgr8_61'') or (ident = ''tgr8_101''));

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_2'',''1.2.Сiльське населення-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_2'' and ident <> ''tgr7_23'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_5'',''1.3.Населення з ел. опаленням-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_5'';

 insert into rep_f32_tbl 
 select vdepartment,''tgr7_52'',''1.3.1.Населення з ел. опаленням (з 1 жовтня по 30 квiтня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_52'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_51'',''1.3.2.Населення з ел. опаленням (з 1 травня по 30 вересня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_51'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_6'',''1.4.Населення в негазиф.буд.-всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_6'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_62'',''1.4.1.Населення в негазиф. буд. (з 1 жовтня по 30 квiтня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_62'';


 insert into rep_f32_tbl 
 select vdepartment,''tgr7_61'',''1.4.2.Населення в негазиф. буд. (з 1 травня по 30 вересня)'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,1,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=1 and ident~''tgr7_61'';



 update rep_f32_tbl set ident = ''tgr7_7'',
   caption = ''1.5.Багатодiтнi, прийомнi сiм''''ї, дит.будинки сiмейного типу незалежно вiд обсягiв спож. електроенергiї'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr7_7'');

 update rep_f32_tbl set ident = ''tgr8_1'',
   caption = ''1.6.Населення, яке розраховується з енергопостачальною органiзацiєю за загальним 
    розрахунковим засобом облiку та об''''єднане шляхом створення юридичної особи, житлово-експлуатацiйним органiзацiям, крiм гуртожиткiв'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr8_10'');


 update rep_f32_tbl set ident = ''tgr8_4'',
   caption = ''1.7.Гуртожитки (якi пiдпадають пiд визначення "населення, яке розраховується з енергопостачальною органiзацiєю за загальним розрахунковим засобом облiку")'',
   gr_lvl=2
   where mmgg = pmmgg and gr_lvl=1 and part_code=1 and (ident=''tgr8_4'');



 update rep_f32_tbl set 
   caption = ''Насел. з ел.опаленням до 100 кВтг''  where mmgg = pmmgg and part_code=1 and ident=''tgr7_511'';

 update rep_f32_tbl set 
   caption = ''Насел. з ел.опаленням понад 100 кВтг''  where mmgg = pmmgg and part_code=1 and ident=''tgr7_5121'';

 update rep_f32_tbl set 
   caption = ''Насел. з ел.опаленням до 3000 кВтг''  where mmgg = pmmgg and part_code=1 and ident=''tgr7_5212'';

 update rep_f32_tbl set 
   caption = ''Насел. з ел.опаленням понад 3000 кВтг''  where mmgg = pmmgg and part_code=1 and ident=''tgr7_5222'';


 update rep_f32_tbl set 
   caption = ''Насел. в багатокв. будинках, не газифiкованих прир.газом i в яких вiдсутнє центр. теплопостачання до 100 кВтг''  
  where mmgg = pmmgg and part_code=1 and ident=''tgr7_611'';

 update rep_f32_tbl set 
   caption = ''Насел. в багатокв. будинках, не газифiкованих прир.газом i в яких вiдсутнє центр. теплопостачання понад 100 кВтг''  
  where mmgg = pmmgg and part_code=1 and ident=''tgr7_6121'';

 update rep_f32_tbl set 
   caption = ''Насел. в багатокв. будинках, не газифiкованих прир.газом i в яких вiдсутнє центр. теплопостачання до 3000 кВтг''  
  where mmgg = pmmgg and part_code=1 and ident=''tgr7_6212'';

 update rep_f32_tbl set 
   caption = ''Насел. в багатокв. будинках, не газифiкованих прир.газом i в яких вiдсутнє центр. теплопостачання понад 3000 кВтг''  
  where mmgg = pmmgg and part_code=1 and ident=''tgr7_6222'';



 --Итог по тарифам
 insert into rep_f32_tbl 
 select vdepartment,''s1'',''Всього по РЕМ'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,2,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and part_code=1 and ( gr_lvl=1 or (ident in (''tgr7_7'',''tgr8_1'',''tgr8_4'' )));
 --транзит и тяга - пока по 0
 --insert into rep_f32_tbl select vdepartment,''tr'',''Транзит'','''',0,0,0,0,2,3,pmmgg;
 --insert into rep_f32_tbl select vdepartment,''tve'',''ТВЕ - тяга'','''',0,0,0,0,2,3,pmmgg;


 insert into rep_f32_tbl 
 select vdepartment,''tr'',''Транзит'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,0,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,0,
 2,3,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 209
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 209
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl2
 using (id_section);


 insert into rep_f32_tbl 
 select vdepartment,''tve'',''ТВЕ - тяга'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,0,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,0,
 2,3,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.id_section = 217
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and stcl.id_section = 217
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  group by stcl.id_section
 ) as tcl2
 using (id_section);

 -- если нет тяги и транзита, добавим пустые строки
 select into v id_department 
 from rep_f32_tbl where ident = ''tve''and mmgg=pmmgg;

 if not found then 
  insert into rep_f32_tbl select vdepartment,''tve'',''ТВЕ - тяга'','''',0,0,0,0,2,3,pmmgg;
 end if;

 select into v id_department 
 from rep_f32_tbl where ident = ''tr'' and mmgg=pmmgg;

 if not found then 
  insert into rep_f32_tbl select vdepartment,''tr'',''Транзит'','''',0,0,0,0,2,3,pmmgg;
 end if;

 -- еще один итог
 insert into rep_f32_tbl 
 select vdepartment,''s2'',''ВСЬОГО'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,4,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and (ident=''s1'' or ident=''tr'' or ident=''tve'');
 -- опять итог - копия s1
 insert into rep_f32_tbl 
 select vdepartment,''s3'',''Всього власнi споживачi'','''',demand_tcl1,sum_tcl1,
 demand_tcl2,sum_tcl2,3,5,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and ident=''s1'';
 --По бюджетам

 insert into rep_f32_tbl 
 select vdepartment,bdg.kod,bdg.name,'''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 1,6,pmmgg
 from
 (
  select   CASE WHEN p.lev=3 THEN p.id  ELSE p.id_parent END AS budjet,
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join cla_param_tbl as p on (stcl.id_section=p.id)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101) and (bm.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and p.id in (211,213,214,215)
  group by budjet
 ) as tcl1
 Full outer join
 (
  select   CASE WHEN p.lev=3 THEN p.id  ELSE p.id_parent END AS budjet,
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join cla_param_tbl as p on (stcl.id_section=p.id)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101) and (bm.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and p.id in (211,213,214,215)
  group by budjet
 ) as tcl2
 using (budjet)
 right join
 (
  select ''в тому числi: установи та орган. держ. бюджету''::varchar as name, ''211''::varchar as kod,211 as budjet
  union
  select ''              установи та орган. мiсцевого бюджету'' as name, ''212'' as kod,212 as budjet
 ) as bdg
  using (budjet);
  
 --Итог по бюджету (будет отображен перед детализацией)
 insert into rep_f32_tbl 
 select vdepartment,''210'',''Бюджет - всього'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),2,6,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=6;
 --по уровням напряжения
 -- заголовочек
 insert into rep_f32_tbl 
 select vdepartment,''0'',''Iз власних споживачiв:'','''',null,null, null,null,2,8,pmmgg;
 -- и данные 

 insert into rep_f32_tbl 
 select vdepartment,vlt.kod,vlt.name,'''',
 sum(coalesce(demand_tcl1,0)::numeric) as demand_tcl1,sum(coalesce(sum_tcl1,0)) as sum_tcl1,
 sum(coalesce(demand_tcl2,0)::numeric) as demand_tcl2,sum(coalesce(sum_tcl2,0)) as sum_tcl2,
-- coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
-- coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 1,8,pmmgg
 from
 (
  select vv.voltage_min,  
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_client_tbl as cl on (cl.id = b.id_client) 
--  join (select code_eqp, max(id_voltage) as id_voltage from eqm_point_h group by code_eqp ) as ph on (bs.id_point = ph.code_eqp)
--  join (select p2.code_eqp, p2.id_voltage from eqm_point_h as p2 where p2.dt_b = (select max(p3.dt_b) from eqm_point_h as p3 where p3.code_eqp = p2.code_eqp ) ) as ph
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  --and bs.demand_val<>0
  and coalesce(ph.id_extra,0) <> 1011
  and coalesce(ph.id_extra,0) <> 1014
  and cl.idk_work <> 0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and ((tgr.ident not like ''%tgr7%'' and tgr.ident not like ''%tgr8%'' and tgr.ident not like ''%tgr9%'') or ( tgr.ident in (''tgr8_62'',''tgr8_63'')))
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by vv.voltage_min
 ) as tcl1
 Full outer join
 (
  select vv.voltage_min,  
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_client_tbl as cl on (cl.id = b.id_client)
--  join (select code_eqp, max(id_voltage) as id_voltage from eqm_point_h group by code_eqp ) as ph on (bs.id_point = ph.code_eqp)
--  join (select p2.code_eqp, p2.id_voltage from eqm_point_h as p2 where p2.dt_b = (select max(p3.dt_b) from eqm_point_h as p3 where p3.code_eqp = p2.code_eqp ) ) as ph
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and coalesce(ph.id_extra,0) <> 1011
  and coalesce(ph.id_extra,0) <> 1014
  and cl.idk_work <> 0
  --and bs.demand_val<>0
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and ((tgr.ident not like ''%tgr7%'' and tgr.ident not like ''%tgr8%'' and tgr.ident not like ''%tgr9%'') or ( tgr.ident in (''tgr8_62'',''tgr8_63'')))
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by vv.voltage_min
 ) as tcl2
 using (voltage_min)
 right join
 (
  select ''по 10 кВ (крiм населення)''::varchar as name, 10::int as v_max,3::int as v_min,''010''::varchar as kod
  union
  select ''по 0,4 кВ (крiм населення)'',0.4,0.2 ,''004''
  union
  select ''по 35 кВ (крiм населення)'',35 ,27, ''035''
  union
  select ''по 110 кВ (крiм населення)'',160 ,110,''110''
 ) as vlt
-- on (voltage_min=vlt.voltage);
 on (voltage_min<=vlt.v_max and voltage_min>=vlt.v_min) 
group by vlt.kod,vlt.name order by kod;

--житлово - комунальне господарство

  key_name0120:=''gr_jkh'';  --ключевое имя параметра "Житлово-комун.госп"
-- необходимо отметить им нужный элемент в cla_param_tbl


  select into id_jkh id from cla_param_tbl where key_name=key_name0120 and id_group = 200;

  Raise Notice '' id_jkh % '',id_jkh;

  -- выбрать параметры в развернутом виде
--  delete from rep_param_trace_tbl where id_group = id_jkh;

--  v:=rep_param_trace_fun(id_jkh,id_jkh);


 insert into rep_f32_tbl 
 select vdepartment,''203'',jkh.name,'''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 2,7,pmmgg
 from
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
--  join rep_setrepa_tbl as sra on (stcl.id_kwed = sra.id_statecl)
--  join rep_setrep_tbl as  sr on (sr.id_report=id_rep and sr.id=sra.id_setrep)
--  join rep_param_trace_tbl as pt on (pt.id_group=id_jkh and pt.id_param=sra.id_param and pt.id_parent=pt.id_group)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  --and bs.demand_val<>0 
  and stcl.id_section = id_jkh
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and cl.idk_work <> 0
  group by stcl.id_section
 ) as tcl1
 Full outer join
 (
  select stcl.id_section,  
  sum(bs.demand_val) as demand_tcl2, round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join clm_statecl_h as stcl on (stcl.id_client=bm.id_client)
  join clm_client_tbl as cl on (cl.id = bm.id_client)
--  join rep_setrepa_tbl as sra on (stcl.id_kwed = sra.id_statecl)
--  join rep_setrep_tbl as  sr on (sr.id_report=id_rep and sr.id=sra.id_setrep)
--  join rep_param_trace_tbl as pt on (pt.id_group=id_jkh and pt.id_param=sra.id_param and pt.id_parent=pt.id_group)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101) and (b.idk_doc <> 280)  
  and stcl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as stcl2 where stcl2.id_client = stcl.id_client and stcl2.mmgg_b <= vmmgg ) 
  --and bs.demand_val<>0 
  and stcl.id_section = id_jkh
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and cl.idk_work <> 0
  group by stcl.id_section
 ) as tcl2
 using (id_section)
 right join
 (
  select ''Житлово - комунальне господарство''::varchar as name,id_jkh as kod
 ) as jkh
 on (jkh.kod=id_section);

 -------------------------------------------------------------------
 -- юр.лица -- по тарифам населения
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,11,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where (ident like ''tgr7_1%'') or (ident like ''tgr7_2%'') 
 and ((dt_begin is null) or (dt_begin <=pmmgg)) 
 and ((dt_end is null)   or (dt_end > pmmgg))  ) as tgr

 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char(pmmgg ,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
--  and to_char(bs.mmgg,''YYYY-MM'')=to_char( pmmgg,''YYYY-MM'')
  and bs.mmgg=vmmgg 
  and scl.id_section not in (205,206,207,208)
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 --Итог по тарифам
 insert into rep_f32_tbl 
 select vdepartment,''s11'',''Всього по юридичним споживачам'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,10,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=11;


 -- акты по тарифам населения
 insert into rep_f32_tbl 
 select vdepartment,tgr.ident,tgr.name,'''',
 coalesce(sum(demand_tcl1),0)::numeric as demand_tcl1,coalesce(sum(sum_tcl1),0) as sum_tcl1,
 coalesce(sum(demand_tcl2),0)::numeric as demand_tcl2,coalesce(sum(sum_tcl2),0) as sum_tcl2,
 tgr.lvl,13,pmmgg
 from
 (select name ,ident, 1 as lvl from eqi_grouptarif_tbl where (ident like ''tgr7%'') 
  and ((dt_begin is null) or (dt_begin <=pmmgg)) 
  and ((dt_end is null)   or (dt_end > pmmgg)) ) as tgr
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
  and bs.mmgg=vmmgg 
  and scl.id_section = 208
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl1
 on(tcl1.ident=tgr.ident)
 left join
 (
  select tgr.ident, sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_h as scl on (cl.id = scl.id_client)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and scl.mmgg_b = (select max(mmgg_b) from clm_statecl_h as scl2 where scl2.id_client = scl.id_client and scl2.mmgg_b <= vmmgg ) 
  and bs.mmgg=vmmgg 
  and scl.id_section  =208
  and cl.idk_work <> 0
  group by tgr.ident
 ) as tcl2
 on(tcl2.ident=tgr.ident)
 group by tgr.name,tgr.ident,tgr.lvl
 order by tgr.ident;

 --Итог по актам
 insert into rep_f32_tbl 
 select vdepartment,''s12'',''Виставленi рахунки за порушення ПКЕЕ'','''',sum(demand_tcl1),sum(sum_tcl1),
 sum(demand_tcl2),sum(sum_tcl2),3,12,pmmgg
 from rep_f32_tbl  where mmgg = pmmgg and gr_lvl=1 and part_code=13;

 --для нежина персонально!
 --прямо указываю абонента и его точку учета
 insert into rep_f32_tbl 
 select vdepartment,''ees'',''З шин ПС ЕЕС'','''',
 coalesce(demand_tcl1,0)::numeric as demand_tcl1,coalesce(sum_tcl1,0) as sum_tcl1,
 coalesce(demand_tcl2,0)::numeric as demand_tcl2,coalesce(sum_tcl2,0) as sum_tcl2,
 2,15,pmmgg
 from
 (
  select 1 as id_section,  
  sum(bs.demand_val) as demand_tcl1,round(sum(bs.sum_val),2) as sum_tcl1
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and coalesce(ph.id_extra,0) = 1011
  and bs.mmgg=vmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by 1
 ) as tcl1
 Full outer join
 (
  select 1 as id_section,  
  sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
  from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
  and coalesce(ph.id_extra,0) = 1011
  and bs.mmgg=vmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
  group by 1
 ) as tcl2
 using (id_section);

 --для городских персонально!
 --прямо указываю абонента и его точку учета
 insert into rep_f32_tbl 
 select vdepartment,''tec'',''З шин ТЕЦ'','''',
 (coalesce(demand_tcl1,0))::numeric as demand_tcl1,(coalesce(sum_tcl1,0)) as sum_tcl1,
 (coalesce(demand_tcl2,0))::numeric as demand_tcl2,(coalesce(sum_tcl2,0)) as sum_tcl2,
 2,15,pmmgg
 from
 ( select  sum(demand_tcl1) as demand_tcl1, sum(sum_tcl1) as sum_tcl1,
   sum(demand_tcl2) as demand_tcl2, sum(sum_tcl2) as sum_tcl2 from 
   (select 1 as id_section, 
    sum(bs.demand_val) as demand_tcl1,round(sum(bs.sum_val),2) as sum_tcl1
    from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
    join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
    join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
    where tcl.ident=''tcl1'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
    and coalesce(ph.id_extra,0) = 1014
    and bs.mmgg=vmmgg 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point
    and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
    group by 1
   ) as tcl1
   Full outer join
  (
   select 1 as id_section,  
    sum(bs.demand_val) as demand_tcl2,round(sum(bs.sum_val),2) as sum_tcl2
    from acd_billsum_tbl as bs join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
    join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
    join acm_bill_tbl as bm on (bs.id_doc=bm.id_doc)
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
    where tcl.ident=''tcl2'' and bm.id_pref in (10,101)  and (bm.idk_doc <> 280) 
    and coalesce(ph.id_extra,0) = 1014
    and bs.mmgg=vmmgg 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) )
    group by 1
  ) as tcl2
  using (id_section) ) as fff--group by id_section 
-- group by vdepartment,''tec'',''З шин ТЕЦ'','''',2,15,pmmgg
;
 
 update  rep_f32_tbl set num = ident where mmgg=pmmgg ;
 update  rep_f32_tbl set num = ''tgr7_140'' where ident = ''tgr8_101'' and mmgg=pmmgg ;  
 update  rep_f32_tbl set num = ''tgr7_141'' where ident = ''tgr8_61'' and mmgg=pmmgg ;  
 
RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

