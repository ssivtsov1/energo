;
set client_encoding = 'win';

create or replace function rep_lost_fun(date,int) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
  pfile alias for $2;
--  v int;
  r record;
  vid_pref int;
  vdepartment int;
  tabl varchar;
  del varchar; 
  nul varchar;
  SQL text;

BEGIN

 delete from rep_lost_tbl;

 vdepartment := getsysvar(''kod_res'');
 

 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''nl'',''безвтратнi'',2, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=160 and v.voltage_min>=110  then kvt ELSE 0 END),   
  sum(CASE WHEN lost = 0 and v.voltage_max<=35 and v.voltage_min>=27  then kvt ELSE 0 END) , 
  sum(CASE WHEN lost = 0 and v.voltage_max<=10 and v.voltage_min>=3  then kvt ELSE 0 END) , 
  sum(CASE WHEN lost = 0 and v.voltage_min<1 then kvt ELSE 0 END),pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt
  from clm_client_tbl as cl
  join acm_bill_tbl as b on (cl.id = b.id_client)
  join acd_billsum_tbl as bs using ( id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client)
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point)
  where b.mmgg = pmmgg and b.id_pref in(10,101)  and b.idk_doc<>280 and cl.book = -1
  and cl.idk_work <> 0 
  and bs.id_tariff not in (900002, 900001, 999999)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) )
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section ) as ts
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);
  

 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''l'',''втратнi'',7, 
  sum(CASE WHEN lost = 1 and v.voltage_max<=160 and v.voltage_min>=110  then kvt ELSE 0 END)  as l110, 
  sum(CASE WHEN lost = 1 and v.voltage_max<=35 and v.voltage_min>=27  then kvt ELSE 0 END)  as l35, 
  sum(CASE WHEN lost = 1 and v.voltage_max<=10 and v.voltage_min>=3  then kvt ELSE 0 END)  as l10, 
  sum(CASE WHEN lost = 1 and v.voltage_min<1 then kvt ELSE 0 END)  as l04 ,pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and cl.idk_work <> 0 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section )as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);


 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''fiz'',''    в т.ч.населення та населенi пункти'',9, 
  sum(CASE WHEN  v.voltage_max<=160 and v.voltage_min>=110 and (ts.ident like ''tgr7%'' or ts.ident like ''tgr8%'') and (ts.ident not in (''tgr8_62'',''tgr8_63''))  then kvt ELSE 0 END)  as fl110, 
  sum(CASE WHEN  v.voltage_max<=35 and v.voltage_min>=27 and (ts.ident like ''tgr7%'' or ts.ident like ''tgr8%'') and (ts.ident not in (''tgr8_62'',''tgr8_63'')) then kvt ELSE 0 END)  as fl35, 
  sum(CASE WHEN  v.voltage_max<=10 and v.voltage_min>=3 and (ts.ident like ''tgr7%'' or ts.ident like ''tgr8%'') and (ts.ident not in (''tgr8_62'',''tgr8_63'')) then kvt ELSE 0 END)  as fl10, 
  sum(CASE WHEN  v.voltage_min<1 and (ts.ident like ''tgr7%'' or ts.ident like ''tgr8%'') and (ts.ident not in (''tgr8_62'',''tgr8_63'')) then kvt ELSE 0 END)  as fl04, 
  pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and cl.idk_work <> 0 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section )as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);


 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''tve'',''   компенсацiя ТВЕ iншими лiцензiатами'',6, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=160 and v.voltage_min>=110 and ts.id_section = 217 then kvt ELSE 0 END)  as nltve110, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=35 and v.voltage_min>=27 and ts.id_section = 217 then kvt ELSE 0 END)  as nltve35, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=10 and v.voltage_min>=3 and ts.id_section = 217 then kvt ELSE 0 END)  as nltve10, 
  sum(CASE WHEN lost = 0 and v.voltage_min<1 and ts.id_section = 217 then kvt ELSE 0 END)  as nltve04, pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and cl.idk_work <> 0 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section )as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);


 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''trnl'',''незалежним постачальникам'',5, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=160 and v.voltage_min>=110 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr110, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=35 and v.voltage_min>=27 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr35, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=10 and v.voltage_min>=3 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr10, 
  sum(CASE WHEN lost = 0 and v.voltage_min<1 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr04,pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and cl.idk_work <> 0 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section )as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);


 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''trl'',''iз них:                                          незалежним постачальникам'',8, 
  sum(CASE WHEN lost = 1 and v.voltage_max<=160 and v.voltage_min>=110 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr110, 
  sum(CASE WHEN lost = 1 and v.voltage_max<=35 and v.voltage_min>=27 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr35, 
  sum(CASE WHEN lost = 1 and v.voltage_max<=10 and v.voltage_min>=3 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr10, 
  sum(CASE WHEN lost = 1 and v.voltage_min<1 and ts.id_section = 209 then kvt ELSE 0 END)  as nltr04,pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and cl.idk_work <> 0 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section )as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);


 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''psees'',''безпосередньо з шин  ПС ЕЕС'',4, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=160 and v.voltage_min>=110  then kvt ELSE 0 END)  as nl110, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=35 and v.voltage_min>=27  then kvt ELSE 0 END)  as nl35, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=10 and v.voltage_min>=3  then kvt ELSE 0 END)  as nl10, 
  sum(CASE WHEN lost = 0 and v.voltage_min<1 then kvt ELSE 0 END)  as nl04 ,pmmgg
  from  ( select tgr.ident, ph.id_voltage, stcl.id_section, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and coalesce(ph.id_extra,0) = 1011
--  and b.id_client = 2154 and bs.id_point = 265559 
  and vdepartment in (210,211)
  and cl.idk_work <> 0 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, tgr.ident, stcl.id_section )as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);



 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
 select vdepartment,''tec'',''iз них:  за регульованим тарифом  безпосередньо з шин ТЕЦ'',3, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=160 and v.voltage_min>=110 and ts.id_extra = 1014 then kvt ELSE 0 END)  as nltr110, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=35 and v.voltage_min>=27 and ts.id_extra = 1014 then kvt ELSE 0 END)  as nltr35, 
  sum(CASE WHEN lost = 0 and v.voltage_max<=10 and v.voltage_min>=3 and ts.id_extra = 1014 then kvt ELSE 0 END)  as nltr10, 
  sum(CASE WHEN lost = 0 and v.voltage_min<1 and ts.id_extra = 1014 then kvt ELSE 0 END)  as nltr04,pmmgg
  from  ( select ph.id_voltage, ph.id_extra, coalesce(ph.lost_nolost,0) as lost, sum(bs.demand_val) as kvt 
  from  clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  where b.mmgg = pmmgg and b.id_pref in (10,101)  and b.idk_doc<>280 and cl.book = -1 
  and cl.idk_work <> 0 
  and bs.id_tariff not in ( 900002, 900001, 999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  group by ph.id_voltage, lost, ph.id_extra ) as ts  
  left join eqk_voltage_tbl as v on (v.id = ts.id_voltage);



-- insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,mmgg)
-- select vdepartment,''tec'',''iз них:  за регульованим тарифом  безпосередньо з шин ТЕЦ'',3,0,0,0,0,pmmgg; 

 insert into rep_lost_tbl(id_department,ident,caption,ordr,d110,d35,d10,d04,gr_lvl,mmgg)
 select vdepartment,''sum1'',''  1.  Корисний  вiдпуск -  всього  (власнi+транзит+компенс.ТВЕ)'',1,
 sum(d110),sum(d35),sum(d10),sum(d04),1,pmmgg
 from  rep_lost_tbl where ident in (''l'',''nl'');

 --------------------------------------------------------------------------------
 if pfile =1 then

   tabl=''/home/local/seb/''||vdepartment||''lost.TXT'';
   del=''@''; nul='''';

   SQL=''copy  rep_lost_tbl  to ''
   ||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

   raise notice ''%'',SQL;

   Execute SQL;

 end if;
  
RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

