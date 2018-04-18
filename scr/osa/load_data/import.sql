;
SET client_encoding = 'WIN';


copy (
select p.code_eqp, c.code, replace(c.name,';',',') as name , eq.name_eqp, replace(stl.phone,';',',') as phone, t.ident as town_ident, adv.id_street, s.name as street_name, k.name as street_type, adm.building, adm.building_add, adm.office, adv.adr::varchar, tar.name as tar_name,
mm.num_eqp as num_meter,mm.dt_ch, case when pp.phase = 1 then 1 when pp.phase = 2 then 3 end as phase,
mm.zone_cnt::int  

from 
rep_areas_points_tbl as pp
join clm_client_tbl as c on (c.id = pp.id_client)
join clm_statecl_tbl as stl on (c.id = stl.id_client)
join eqm_point_tbl as p on (p.code_eqp = pp.id_point)
join eqm_equipment_tbl as eq on (eq.id = pp.id_point)
join aci_tarif_tbl as tar on (tar.id=p.id_tarif) 
left join adv_address_tbl as adv on (adv.id = eq.id_addres)
left join adm_address_tbl as adm on (adm.id = eq.id_addres)
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
 where c.book=-1 and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) 
) 
   to '/home/local/seb/UACCOUNT.txt' with delimiter as ';' null as '';
