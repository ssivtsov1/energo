
;
set client_encoding = 'win';


-- информация для отчетов по 3-зонным счетчикам

create or replace function rep_3zone_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;
  vmmgg date;
BEGIN

 delete from rep_3zone_tbl where mmgg=pmmgg ;
 
 vmmgg = date_trunc(''month'',pmmgg);

 insert into rep_3zone_tbl 
 select id_client,id_tariff,id_meter,id_type_eqp,z3.num_eqp,coalesce(demand_z1,0),
  coalesce(demand_z2,0),coalesce(demand_z3,0),coalesce(sum_z1,0),
  coalesce(sum_z2,0),coalesce(sum_z3,0),tar0,sum01,sum02,sum03,pmmgg, id_point 
 from 
 (select * from 
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp,bs.tar0,--bs.koef,
   sum(bs.demand_val) as demand_z1,sum(bs.sum_val) as sum_z1, sum(bs.sum0) as sum01
   from (select b.*,coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as tar0,z.koef,b.demand_val*coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as sum0 
          from acd_billsum_tbl b
	       join acd_zone_tbl z  on (b.id_zonekoef=z.id)
               left join acd_tarif_tbl t on (b.id_sumtariff=t.id)              
                where b.id_zone=1 -- and b.demand_val <> 0
         )   as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z1

  full outer join
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp,bs.tar0,--bs.koef, 
   sum(bs.demand_val) as demand_z2,sum(bs.sum_val) as sum_z2, sum(bs.sum0) as sum02
   from (select b.*,coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as tar0,z.koef,b.demand_val*coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as sum0 
          from acd_billsum_tbl b
	       join acd_zone_tbl z  on (b.id_zonekoef=z.id)
               left join acd_tarif_tbl t on (b.id_sumtariff=t.id)              
                where b.id_zone=2 --and b.demand_val <> 0
         )   as bs join acm_bill_tbl as bm using (id_doc)

   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z2
  using (id_client,id_point,id_tariff,id_meter,id_type_eqp,tar0)
 ) as z12
 full outer join
 (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp,  mkz.num_eqp, bs.tar0,--bs.koef,
   sum(bs.demand_val) as demand_z3,sum(bs.sum_val) as sum_z3, sum(bs.sum0) as sum03
   from (select b.*,coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as tar0,z.koef,b.demand_val*coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as sum0 
          from acd_billsum_tbl b
	       join acd_zone_tbl z  on (b.id_zonekoef=z.id)
               left join acd_tarif_tbl t on (b.id_sumtariff=t.id)              
                where b.id_zone=3 -- and b.demand_val <> 0
         )   as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
 ) as z3
 using (id_client,id_point,id_tariff,id_meter,id_type_eqp,tar0);

 update rep_3zone_tbl set num_eqp = eq.num_eqp, id_meter = eq.id, id_type_meter = m.id_type_eqp
  from eqm_meter_point_h as mp 
  join eqm_equipment_tbl as eq on (mp.id_meter = eq.id)
  join eqm_meter_tbl as m on (mp.id_meter = m.code_eqp)
 where rep_3zone_tbl.id_meter is null 
 and rep_3zone_tbl.mmgg=pmmgg 
 and mp.dt_e is null
 and rep_3zone_tbl.id_point = mp.id_point;
 


RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          


create or replace function rep_3zone_fiz_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;
  vmmgg date;
BEGIN

 delete from rep_3zone_tbl where mmgg=pmmgg ;
 
 vmmgg = date_trunc(''month'',pmmgg);

 insert into rep_3zone_tbl 
 select id_client,id_tariff,id_meter,id_type_eqp,z3.num_eqp,coalesce(demand_z1,0),
  coalesce(demand_z2,0),coalesce(demand_z3,0),coalesce(sum_z1,0),
  coalesce(sum_z2,0),coalesce(sum_z3,0),tar0,sum01,sum02,sum03,pmmgg, id_point 
 from 
 (select * from 
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp,bs.tar0,--bs.koef,
   sum(bs.demand_val) as demand_z1,sum(bs.sum_val) as sum_z1, sum(bs.sum0) as sum01
   from (select b.*,coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as tar0,z.koef,b.demand_val*coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as sum0 
          from acd_billsum_tbl b
	       join acd_zone_tbl z  on (b.id_zonekoef=z.id)
               left join acd_tarif_tbl t on (b.id_sumtariff=t.id)              
                where b.id_zone=6 -- and b.demand_val <> 0
         )   as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z1

  full outer join
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp,bs.tar0,--bs.koef, 
   sum(bs.demand_val) as demand_z2,sum(bs.sum_val) as sum_z2, sum(bs.sum0) as sum02
   from (select b.*,coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as tar0,z.koef,b.demand_val*coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as sum0 
          from acd_billsum_tbl b
	       join acd_zone_tbl z  on (b.id_zonekoef=z.id)
               left join acd_tarif_tbl t on (b.id_sumtariff=t.id)              
                where b.id_zone=7 -- and b.demand_val <> 0
         )   as bs join acm_bill_tbl as bm using (id_doc)

   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z2
  using (id_client,id_point,id_tariff,id_meter,id_type_eqp,tar0)
 ) as z12
 full outer join
 (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp,  mkz.num_eqp, bs.tar0,--bs.koef,
   sum(bs.demand_val) as demand_z3,sum(bs.sum_val) as sum_z3, sum(bs.sum0) as sum03
   from (select b.*,coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as tar0,z.koef,b.demand_val*coalesce(t.value, round((sum_val/demand_val)/z.koef,5)) as sum0 
          from acd_billsum_tbl b
	       join acd_zone_tbl z  on (b.id_zonekoef=z.id)
               left join acd_tarif_tbl t on (b.id_sumtariff=t.id)              
                where b.id_zone=8 -- and b.demand_val <> 0
         )   as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
 ) as z3
 using (id_client,id_point,id_tariff,id_meter,id_type_eqp,tar0);

 update rep_3zone_tbl set num_eqp = eq.num_eqp, id_meter = eq.id, id_type_meter = m.id_type_eqp
  from eqm_meter_point_h as mp 
  join eqm_equipment_tbl as eq on (mp.id_meter = eq.id)
  join eqm_meter_tbl as m on (mp.id_meter = m.code_eqp)
 where rep_3zone_tbl.id_meter is null 
 and rep_3zone_tbl.mmgg=pmmgg 
 and mp.dt_e is null
 and rep_3zone_tbl.id_point = mp.id_point;
 


RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

-----------------------------------------------------------------------------------------------

create or replace function rep_2zone_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;
  vmmgg date;
BEGIN

 delete from rep_2zone_tbl where mmgg=pmmgg ;
 
 vmmgg = date_trunc(''month'',pmmgg);

 insert into rep_2zone_tbl 
 select id_client,id_tariff,id_meter,id_type_eqp,coalesce(z12.num_eqp1,z12.num_eqp2),
 coalesce(demand_z1,0),  coalesce(demand_z2,0),coalesce(sum_z1,0),
  coalesce(sum_z2,0),tar0,sum01,sum02 ,pmmgg ,id_point
 from 
 (select * from 
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp as num_eqp1,bs.tar0,
   sum(bs.demand_val) as demand_z1,sum(bs.sum_val) as sum_z1,sum(bs.sum0) as sum01
   from (select b.*,t.value as tar0,z.koef,b.demand_val*t.value as sum0 from acd_billsum_tbl b,acd_tarif_tbl t,acd_zone_tbl z 
where b.id_zone=4 and id_sumtariff=t.id and b.id_zonekoef=z.id
         ) as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.id_zone=4 and bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z1
  full outer join
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp as num_eqp2, bs.tar0,
   sum(bs.demand_val) as demand_z2,sum(bs.sum_val) as sum_z2,sum(bs.sum0) as sum02
   from (select b.*,t.value as tar0,z.koef,b.demand_val*t.value as sum0 from acd_billsum_tbl b,acd_tarif_tbl t,acd_zone_tbl z 
where b.id_zone=5 and id_sumtariff=t.id and b.id_zonekoef=z.id
         ) as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.id_zone=5 and bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z2
  using (id_client,id_point,id_tariff,id_meter,id_type_eqp,tar0)
 ) as z12;


RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          


create or replace function rep_2zone_fiz_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
--  edate alias for $2;
  v int;
  r record;
  vid_pref int;
  vmmgg date;
BEGIN

 delete from rep_2zone_tbl where mmgg=pmmgg ;
 
 vmmgg = date_trunc(''month'',pmmgg);

 insert into rep_2zone_tbl 
 select id_client,id_tariff,id_meter,id_type_eqp,coalesce(z12.num_eqp1,z12.num_eqp2),
 coalesce(demand_z1,0),  coalesce(demand_z2,0),coalesce(sum_z1,0),
  coalesce(sum_z2,0),tar0,sum01,sum02 ,pmmgg ,id_point
 from 
 (select * from 
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp as num_eqp1,bs.tar0,
   sum(bs.demand_val) as demand_z1,sum(bs.sum_val) as sum_z1,sum(bs.sum0) as sum01
   from (select b.*,t.value as tar0,z.koef,b.demand_val*t.value as sum0 from acd_billsum_tbl b,acd_tarif_tbl t,acd_zone_tbl z 
where b.id_zone=9 and id_sumtariff=t.id and b.id_zonekoef=z.id
         ) as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.id_zone=9 and bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z1
  full outer join
  (
   select bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp, mkz.num_eqp as num_eqp2, bs.tar0,
   sum(bs.demand_val) as demand_z2,sum(bs.sum_val) as sum_z2,sum(bs.sum0) as sum02
   from (select b.*,t.value as tar0,z.koef,b.demand_val*t.value as sum0 from acd_billsum_tbl b,acd_tarif_tbl t,acd_zone_tbl z 
where b.id_zone=10 and id_sumtariff=t.id and b.id_zonekoef=z.id
         ) as bs join acm_bill_tbl as bm using (id_doc)
   left join (select id_point,id_doc,kind_energy,id_zone, 
           max(id_meter) as id_meter,max(id_type_eqp) as id_type_eqp,max(num_eqp) as num_eqp 
           from acd_met_kndzn_tbl where mmgg = vmmgg
           group by id_point,id_doc,kind_energy,id_zone ) as mkz 
           using (id_point,id_doc,kind_energy,id_zone)  
   where bs.id_zone=10 and bs.kind_energy=1 and bm.id_pref in (10,101) and (bm.idk_doc <> 280) 
   and bs.mmgg=vmmgg
   group by bm.id_client,bs.id_point,bs.id_tariff,mkz.id_meter,mkz.id_type_eqp , mkz.num_eqp,bs.tar0 --,bs.koef
  ) as z2
  using (id_client,id_point,id_tariff,id_meter,id_type_eqp,tar0)
 ) as z12;


RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

--------------------------------------------------------------------------------------------------------------------------

create or replace function rep_lighting_dubl_fun() returns int
AS                                                                                              
'
declare 
BEGIN

delete from  rep_lighting_points_tmp;

insert into rep_lighting_points_tmp
select nums.* from
(select distinct trim(regexp_replace(trim(eqm.num_eqp),''(н|д)$'',''''))::varchar as num_eqp 
from eqm_point_tbl as p join eqm_meter_point_h as mp on (mp.id_point = p.code_eqp and mp.dt_e is null) 
join eqm_equipment_tbl as eqm on (eqm.id = mp.id_meter)
where p.id_tarif = 51 and coalesce(power,0) <>0 
) as l_nums
join (select p.code_eqp, p.id_tarif, p.power, trim(regexp_replace(trim(eqm.num_eqp),''(н|д)$'',''''))::varchar as num_eqp 
from eqm_point_tbl as p join eqm_meter_point_h as mp on (mp.id_point = p.code_eqp and mp.dt_e is null) 
join eqm_equipment_tbl as eqm on (eqm.id = mp.id_meter) 
where coalesce(power,0) <>0 
) as nums on (nums.num_eqp = l_nums.num_eqp);


delete from rep_lighting_points_tmp where id_point in (
select CASE WHEN id_point <0 THEN  -id_point ELSE id_point END as id_point from(
select  max(CASE WHEN (eq.id is null) or (p.reserv =1) THEN  -id_point ELSE id_point END ) as id_point 
  from rep_lighting_points_tmp as lp
  join eqm_point_tbl as p on (p.code_eqp = lp.id_point)
  left join eqm_compens_station_inst_tbl as csi on (lp.id_point = csi.code_eqp) 
  left join eqm_equipment_tbl as eq on (eq.id = csi.code_eqp_inst and eq.type_eqp = 11) 
group by lp.num_eqp,lp.power
) as ss
);

RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';    
