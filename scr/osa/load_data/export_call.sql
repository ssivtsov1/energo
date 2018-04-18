;

DROP FUNCTION   export_callcentr();
-- Function: export_callcentr()

CREATE OR REPLACE FUNCTION export_callcentr()
  RETURNS boolean AS
$BODY$
declare 
 kodres int;
 existt boolean;
 pr boolean;
 tabl varchar;
 del varchar;
 nul varchar;
 SQL text;
begin
  del=';'; 
  nul='';
set client_encoding='UTF8';
 select value_ident into kodres from syi_sysvars_tbl where ident='kod_res'; 
if table_exists('tmp_eqp_tree_call') then
 delete from tmp_eqp_tree_call;

 insert into tmp_eqp_tree_call (code_res,id_tree,id_client,id_parent_eqp,id_eqp,lvl,name,num_eqp,type_eqp )
  select getsysvar('kod_res') as code_res,et.id_tree,t.id_client,et.code_eqp_e as id_parent_eqp,et.code_eqp as id_eqp,
  et.lvl,replace(replace(replace(et.name,';',','),'"',' ' ),chr(39),' ' ),e.num_eqp,e.type_eqp 
   from eqm_tree_tbl t,eqm_eqp_tree_tbl et,eqm_equipment_tbl e 
 where t.id=et.id_tree and et.code_eqp=e.id  order by id_client,id_tree,id_parent_eqp;
 
 else
 CREATE  TABLE tmp_eqp_tree_call AS 
 select getsysvar('kod_res') as code_res,et.id_tree,t.id_client,et.code_eqp_e as id_parent_eqp,et.code_eqp as id_eqp,
  et.lvl,replace(replace(replace(et.name,';',','),'"',' ' ),chr(39),' ' ),e.num_eqp,e.type_eqp 
  from eqm_tree_tbl t,eqm_eqp_tree_tbl et,eqm_equipment_tbl e 
 where t.id=et.id_tree and et.code_eqp=e.id  order by id_client,id_tree,lvl,id_parent_eqp;

end if;
  tabl='/home/local/replicat/call/'||kodres||'cdtree.csv';

  SQL='copy  tmp_eqp_tree_call (code_res,id_client,id_parent_eqp,id_eqp,name,type_eqp)
          to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;

 

  tabl='/home/local/replicat/call/'||kodres||'cdpclient.csv';

  SQL='copy (select getsysvar(''kod_res'') as code_res,id_eqpborder,intcod
    from clm_pclient_tbl where id_state not in (50,99) and intcod is not null order by intcod )
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;

  tabl='/home/local/replicat/call/'||kodres||'cddeltree.csv';
  
 SQL='copy  ( select getsysvar(''kod_res'') as code_res,n.code_eqp,n.lvl from 
    (select * from eqm_eqp_tree_h where dt_e>=''2016-02-26'' ) n
    left join (select * from eqm_eqp_tree_h where dt_b>=''2016-02-26'' ) n2 on (n2.code_eqp=n.code_eqp) where n2.code_eqp is null
) 
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;


  tabl='/home/local/replicat/call/'||kodres||'cduaccount.csv';

SQL='copy (
select p.code_eqp, c.code, replace(replace(replace(c.name,'';'','',''),''"'','' '' ),chr(39),'' '' ) as name , 
replace(replace(replace(eq.name_eqp,'';'','',''),''"'','' '' ) ,chr(39),'' '' ) as name_eqp, 
replace(stl.phone,'';'','','') as phone,
trim(coalesce(town.koatu,t.ident)) as town_ident,adv.id_street, 
replace(replace(replace(s.name,'';'','',''),''"'','' '' ),chr(39),'' '' ) as street_name, 
k.name as street_type, 
replace(replace(replace(substr(trim(adm.building),1,8),'';'','',''),''"'','' '' ),chr(39),'' '' ) as building, 
replace(replace(replace(substr(trim(adm.building_add),1,8),'';'','',''),''"'','' '' ),chr(39),'' '' ), 
replace(replace(replace(substr(trim(adm.office),1,8),'';'','',''),''"'','' '' ),chr(39),'' '' ), 
replace(replace(replace(adv.adr,'';'','',''),''"'','' '' ),chr(39),'' '' ) ::varchar as adr,
replace(tar.name,'';'','','') as tar_name,
mm.num_eqp as num_meter,mm.dt_ch, case when pp.phase = 1 then 1 when pp.phase = 2 then 3 end as phase,
mm.zone_cnt::int,c.id_state,case when coalesce(p.disabled,0)=1 then 2 else p.reserv end  
from 
rep_areas_points_tbl as pp
join clm_client_tbl as c on (c.id = pp.id_client)
join clm_statecl_tbl as stl on (c.id = stl.id_client)
join eqm_point_tbl as p on (p.code_eqp = pp.id_point)
join eqm_equipment_tbl as eq on (eq.id = pp.id_point)
join aci_tarif_tbl as tar on (tar.id=p.id_tarif) 
left join eqm_equipment_tbl as eqpp on (pp.id_area = eqpp.id) 
left join adv_address_tbl as adv on (adv.id = coalesce(case when eq.id_addres=0 then null else eq.id_addres end , eqpp.id_addres)  )
left join adm_address_tbl as adm on (adm.id = coalesce(case when eq.id_addres=0 then null else eq.id_addres end , eqpp.id_addres))
left join tmp_town_koatu_tbl as t on (t.id = adv.id_town)
left join adi_town_tbl as town  on (town.id= adv.id_town)
left join adi_street_tbl as s on (s.id = adv.id_street)
left join adk_street_tbl as k on (k.id = s.idk_street)

 left join 
(
 select eq.id, mp.id_point, im.type, eq.num_eqp, hm.dt_b as dt_ch, zone_cnt
 from eqm_meter_tbl as m 
 join eqm_meter_point_h as mp on (mp.id_meter = m.code_eqp and mp.dt_e is null) 
 join eqi_meter_tbl as im on (im.id = m.id_type_eqp) 
 join eqm_equipment_tbl as eq on (eq.id = m.code_eqp)
 join eqm_equipment_h as hm on (hm.id = m.code_eqp)
 left join (select code_eqp, count(distinct zone) as zone_cnt from eqd_meter_zone_tbl where kind_energy = 1 group by code_eqp) as zz 
  on (zz.code_eqp = m.code_eqp) 
    where hm.dt_b = (select dt_b from eqm_equipment_h where id = m.code_eqp and num_eqp = eq.num_eqp order by dt_b ASC limit 1 ) 
   and exists 
      (select code_eqp from eqd_meter_energy_tbl as me where me.kind_energy = 1 and me.code_eqp = m.code_eqp)
) as mm on (mm.id_point = p.code_eqp)
 where c.book=-1 and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) )
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '''' ';
  raise notice 'SQL   --- %',SQL;
   Execute SQL;



set client_encoding='win';
return true;

end;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION export_callcentr()
  OWNER TO local;

CREATE OR REPLACE FUNCTION export_callcentr_old()
  RETURNS boolean AS
$BODY$
declare 
 kodres int;
 existt boolean;
 pr boolean;
 tabl varchar;
 del varchar;
 nul varchar;
 SQL text;
begin
  del=';'; 
  nul='';
set client_encoding='UTF8';
 select value_ident into kodres from syi_sysvars_tbl where ident='kod_res'; 
if table_exists('tmp_eqp_tree_call') then
 delete from tmp_eqp_tree_call;

 insert into tmp_eqp_tree_call (code_res,id_tree,id_client,id_parent_eqp,id_eqp,lvl,name,num_eqp,type_eqp )
  select getsysvar('kod_res') as code_res,et.id_tree,t.id_client,et.code_eqp_e as id_parent_eqp,et.code_eqp as id_eqp,
  et.lvl,et.name,e.num_eqp,e.type_eqp 
   from eqm_tree_tbl t,eqm_eqp_tree_tbl et,eqm_equipment_tbl e 
 where t.id=et.id_tree and et.code_eqp=e.id  order by id_client,id_tree,id_parent_eqp;
 
 else
 CREATE  TABLE tmp_eqp_tree_call AS 
 select getsysvar('kod_res') as code_res,et.id_tree,t.id_client,et.code_eqp_e as id_parent_eqp,et.code_eqp as id_eqp,
  et.lvl,et.name,e.num_eqp,e.type_eqp 
  from eqm_tree_tbl t,eqm_eqp_tree_tbl et,eqm_equipment_tbl e 
 where t.id=et.id_tree and et.code_eqp=e.id  order by id_client,id_tree,lvl,id_parent_eqp;

end if;
  tabl='/home/local/replicat/call/'||kodres||'tree.csv';

  SQL='copy  tmp_eqp_tree_call (code_res,id_tree,id_client,id_parent_eqp,id_eqp,lvl,name,num_eqp,type_eqp)
          to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;

 
if table_exists('tmp_pclient_call') then
 delete from tmp_pclient_call;
 
 insert into tmp_pclient_call (code_res,book,code,id_eqpborder,intcod)
 select getsysvar('kod_res') as code_res,book,code,id_eqpborder,intcod
    from clm_pclient_tbl where id_state not in (50,99) and intcod is not null order by book,code;
    

else
 CREATE  TABLE tmp_pclient_call AS 
 select getsysvar('kod_res') as code_res,book,code,id_eqpborder,intcod
    from clm_pclient_tbl where id_state not in (50,99) and intcod is not null  order by book,code;

end if;
  tabl='/home/local/replicat/call/'||kodres||'pclient.csv';

  SQL='copy  tmp_pclient_call  (code_res,book,code,id_eqpborder,intcod)
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;

if table_exists('tmp_delete_call') then
  delete from tmp_delete_call;
  
  insert into tmp_delete_call (code_res,code_eqp_e,code_eqp)
   select getsysvar('kod_res') as code_res,n.code_eqp_e,n.code_eqp from 
    (select * from eqm_eqp_tree_h where dt_e>='2014-02-26' ) n
    left join (select * from eqm_eqp_tree_h where dt_b>='2014-02-26' ) n2 on (n2.code_eqp=n.code_eqp) where n2.code_eqp is null;
else
 CREATE  TABLE tmp_delete_call AS 
  select getsysvar('kod_res') as code_res,n.code_eqp_e,n.code_eqp from 
    (select * from eqm_eqp_tree_h where dt_e>='2014-02-26' ) n
    left join (select * from eqm_eqp_tree_h where dt_b>='2014-02-26' ) n2 on (n2.code_eqp=n.code_eqp) where n2.code_eqp is null;

end if;



  tabl='/home/local/replicat/call/'||kodres||'cddeltree.csv';
  
 SQL='copy  tmp_delete_call  (code_res,code_eqp_e,code_eqp)
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;

  tabl='/home/local/replicat/call/'||kodres||'cddeltree.csv';
  
 SQL='copy  ( select getsysvar(''kod_res'') as code_res,n.code_eqp,n.lvl from 
    (select * from eqm_eqp_tree_h where dt_e>=''2016-02-26'' ) n
    left join (select * from eqm_eqp_tree_h where dt_b>=''2016-02-26'' ) n2 on (n2.code_eqp=n.code_eqp) where n2.code_eqp is null
) 
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul) ;
  raise notice 'SQL   --- %',SQL;
   Execute SQL;


  tabl='/home/local/replicat/call/'||kodres||'uaccount.csv';

SQL='copy (

select p.code_eqp, c.code, replace(replace(replace(c.name,'';'','',''),''"'','' '' ),chr(39),'' '' ) as name , 
replace(replace(replace(eq.name_eqp,'';'','',''),''"'','' '' ) ,chr(39),'' '' ) as name_eqp, 
replace(stl.phone,'';'','','') as phone,
trim(t.ident) as town_ident, adv.id_street, 
replace(replace(replace(s.name,'';'','',''),''"'','' '' ),chr(39),'' '' ) as street_name, 
k.name as street_type, 
adm.building, 
adm.building_add, adm.office, 
replace(replace(replace(adv.adr,'';'','',''),''"'','' '' ),chr(39),'' '' ) ::varchar as adr,
replace(tar.name,'';'','','') as tar_name,
mm.num_eqp as num_meter,mm.dt_ch, case when pp.phase = 1 then 1 when pp.phase = 2 then 3 end as phase,
mm.zone_cnt::int  

from 
rep_areas_points_tbl as pp
join clm_client_tbl as c on (c.id = pp.id_client)
join clm_statecl_tbl as stl on (c.id = stl.id_client)
join eqm_point_tbl as p on (p.code_eqp = pp.id_point)
join eqm_equipment_tbl as eq on (eq.id = pp.id_point)
join aci_tarif_tbl as tar on (tar.id=p.id_tarif) 
left join eqm_equipment_tbl as eqpp on (pp.id_area = eqpp.id) 
left join adv_address_tbl as adv on (adv.id = coalesce(case when eq.id_addres=0 then null else eq.id_addres end , eqpp.id_addres)  )
left join adm_address_tbl as adm on (adm.id = coalesce(case when eq.id_addres=0 then null else eq.id_addres end , eqpp.id_addres))
left join tmp_town_koatu_tbl as t on (t.id = adv.id_town) 
left join adi_street_tbl as s on (s.id = adv.id_street)
left join adk_street_tbl as k on (k.id = s.idk_street)

 left join 
(
 select eq.id, mp.id_point, im.type, eq.num_eqp, hm.dt_b as dt_ch, zone_cnt
 from eqm_meter_tbl as m 
 join eqm_meter_point_h as mp on (mp.id_meter = m.code_eqp and mp.dt_e is null) 
 join eqi_meter_tbl as im on (im.id = m.id_type_eqp) 
 join eqm_equipment_tbl as eq on (eq.id = m.code_eqp)
 join eqm_equipment_h as hm on (hm.id = m.code_eqp)
 left join (select code_eqp, count(distinct zone) as zone_cnt from eqd_meter_zone_tbl where kind_energy = 1 group by code_eqp) as zz 
  on (zz.code_eqp = m.code_eqp) 
    where hm.dt_b = (select dt_b from eqm_equipment_h where id = m.code_eqp and num_eqp = eq.num_eqp order by dt_b ASC limit 1 ) 
   and exists 
      (select code_eqp from eqd_meter_energy_tbl as me where me.kind_energy = 1 and me.code_eqp = m.code_eqp)
) as mm on (mm.id_point = p.code_eqp)
 where c.book=-1 and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) )
         to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '''' ';
  raise notice 'SQL   --- %',SQL;
   Execute SQL;



set client_encoding='win';
return true;

end;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION export_callcentr()
  OWNER TO local;

--set client_encoding='win';
--select export_callcentr();


