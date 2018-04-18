
create or replace function oabn_tree_res(int,date,date,int) Returns boolean As '
Declare
idcl Alias for $1;
dtb Alias for $2;
dte Alias for $3;
pfider Alias for $4;

fl_up int;
fl_down int;
r record;
rs boolean;
rs1 text;
begin
fl_up:=0;
fl_down:=0;
-------------------- ins into act_eqp_branch_tbl
    Raise Notice ''SEL_TREE_RES'';

insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 

select distinct a_12.id,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e   
  ,coalesce(a4.id_rclient,a_12.id_client),a_12.id_client,a_12.line_no
  ,0
from 
(select distinct a1.id,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no
     from 
(select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h
  where id_client=idcl and coalesce(dt_e,dte)>dtb and dt_b<dte) as a1
 inner join 
(select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte) as a2 
 on (a1.id=a2.id_tree and (a1.dt_b<a2.dt_e and a1.dt_e>a2.dt_b))
 ) as a_12
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,dte)>dtb and dt_b<dte and type_eqp = 1 or type_eqp = 10 or type_eqp = 12) as a3
  on (a3.id=a_12.code_eqp)
 left join (select code_eqp,id_client as id_rclient,case when dt_b<=dtb 
  then dtb else dt_b end as dt_b
 ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e 
  from eqm_eqp_use_h where coalesce(dt_e,dte)>dtb and dt_b<dte) as a4
 on (a_12.code_eqp=a4.code_eqp and a_12.dt_b<a4.dt_e and a_12.dt_e>a4.dt_b) 
  where  (a4.id_rclient is null);


/*
insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 

select  distinct a_12.id_tree,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e 
  ,a_12.id_client,a4.id_client,a_12.line_no 
  ,0
from 
(select  a2.id_tree,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no
 from 
(select code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e,id_client 
  from eqm_eqp_use_h where id_client = idcl 
    and coalesce(dt_e,dte)>dtb and dt_b<dte) as a1 
 inner join 
(select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte) as a2 
 on (a1.code_eqp=a2.code_eqp and (a2.dt_b<a1.dt_e and a2.dt_e>a1.dt_b))
 ) as a_12
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,dte)>dtb and dt_b<dte) as a3
  on (a3.id=a_12.code_eqp)
 inner join
(select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h 
  where id_client<>idcl and coalesce(dt_e,dte)>dtb and dt_b<dte) as a4
 on (a_12.id_tree=a4.id and a4.dt_b<a_12.dt_e and a4.dt_e>a_12.dt_b) 
  where not (a3.type_eqp=9 and a_12.code_eqp_e is null);-----050322
*/
-----upd up-lvl eqp
    Raise Notice ''upd up-lvl eqp'';

update act_eqp_branch_tbl set id_p_eqp=null where not exists 
 (select code_eqp from act_eqp_branch_tbl as a 
    where a.code_eqp=act_eqp_branch_tbl.id_p_eqp) and id_p_eqp is not null;
    Raise Notice ''sel_point_tree'';
------- sel_point_tree
  insert into act_point_branch_tbl(id_point,id_p_point,dat_b,dat_e,id_client
     ,id_rclient,id_tree) 
  select distinct a.code_eqp,null::int,a.dat_b,a.dat_e,a.id_client ,a.id_rclient,a.id_tree 
  from act_eqp_branch_tbl as a 
  left join eqm_compens_station_inst_tbl as sci on ( a.code_eqp = sci.code_eqp)
  where  (coalesce(sci.code_eqp_inst,0) = pfider or pfider is null)
  and a.type_eqp=12;


--act_meter_pnt_tbl
    Raise Notice ''act_meter_pnt_tbl'';

insert into act_meter_pnt_tbl 
select b.id_point,a.code_eqp
 ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
 ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
from (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)=1) as a2 on (a1.code_eqp=a2.code_eqp) 
 ) as a inner join act_point_branch_tbl as b 
 on (a.id_p_eqp=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b)  
 where a.type_eqp=1--;
union
---!!!---------
---insert into act_meter_pnt_tbl 
select a1.id_point,a2.code_eqp
 ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
 ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e 
from 
 (select a.code_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b)  
   where a.type_eqp=10) as a1 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)=1) as a2 on (a1.code_eqp=a2.code_eqp)) as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<a2.dat_e and a1.dat_e>a2.dat_b) 
  where a2.type_eqp=1--;
union 
---insert into act_meter_pnt_tbl 
select a3.id_point,a4.code_eqp
 ,case when a4.dat_b<=a3.dat_b then a3.dat_b else a4.dat_b end as dat_b
 ,case when a4.dat_e>=a3.dat_e then a3.dat_e else a4.dat_e end as dat_e 
from 
 (select a2.code_eqp,a2.type_eqp,a1.id_point
   ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e 
  from
 (select a.code_eqp,a.type_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b)  
   where a.type_eqp=10) as a1 inner join act_eqp_branch_tbl as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<a2.dat_e and a1.dat_e>a2.dat_b) 
  where a2.type_eqp=10) as a3 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)=1) as a2 on (a1.code_eqp=a2.code_eqp)) as a4 
   on (a4.id_p_eqp=a3.code_eqp and a3.dat_b<a4.dat_e and a3.dat_e>a4.dat_b) 
  where a4.type_eqp=1;

for r in select * from (
   select b.id_point,a.code_eqp as id_meter
 ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
 ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
from (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)>1) as a2 on (a1.code_eqp=a2.code_eqp) 
 ) as a inner join act_point_branch_tbl as b 
 on (a.id_p_eqp=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b)  
 where a.type_eqp=1
union 
select a1.id_point,a2.code_eqp as id_meter
 ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
 ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e 
from 
 (select a.code_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b)  
   where a.type_eqp=10) as a1 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)>1) as a2 on (a1.code_eqp=a2.code_eqp)) as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<a2.dat_e and a1.dat_e>a2.dat_b) 
  where a2.type_eqp=1
union  
select a3.id_point,a4.code_eqp as id_meter
 ,case when a4.dat_b<=a3.dat_b then a3.dat_b else a4.dat_b end as dat_b
 ,case when a4.dat_e>=a3.dat_e then a3.dat_e else a4.dat_e end as dat_e 
from 
 (select a2.code_eqp,a2.type_eqp,a1.id_point
   ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e 
  from
 (select a.code_eqp,a.type_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b)  
   where a.type_eqp=10) as a1 inner join act_eqp_branch_tbl as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<a2.dat_e and a1.dat_e>a2.dat_b) 
  where a2.type_eqp=10) as a3 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)>1) as a2 on (a1.code_eqp=a2.code_eqp)) as a4 
   on (a4.id_p_eqp=a3.code_eqp and a3.dat_b<a4.dat_e and a3.dat_e>a4.dat_b) 
  where a4.type_eqp=1 ) as k
 order by k.id_point,k.id_meter,k.dat_b
 loop

  insert into act_meter_pnt_tbl 
  select r.id_point,r.id_meter,r.dat_b,r.dat_e from (select 1) as a left join 
   (select * from act_meter_pnt_tbl where id_point=r.id_point 
   and id_meter=r.id_meter) as b on true where b.id_point is null or 
   (b.id_point is not null and b.dat_e<>r.dat_b);

  update act_meter_pnt_tbl set dat_e=r.dat_e 
  where act_meter_pnt_tbl.id_point=r.id_point 
   and act_meter_pnt_tbl.id_meter=r.id_meter 
   and act_meter_pnt_tbl.dat_e=r.dat_b;

end loop;

--act_demand_tbl
insert into act_demand_tbl 
select b.id_point,b.id_meter,b.num_eqp,c.k_tr,c.k_tr_i,c.i_ts
   ,b.id_type_eqp 
   ,case when c.dat_b<=b.dat_b then b.dat_b else c.dat_b end as dat_b
   ,case when c.dat_e>b.dat_e then b.dat_e else c.dat_e end as dat_e 
from (select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp,b.id_p_eqp  
   ,case when b.dat_b<=a.dat_b then a.dat_b else b.dat_b end as dat_b
   ,case when b.dat_e>a.dat_e then a.dat_e else b.dat_e end as dat_e 
 from  
 (select a1.id_point,a1.id_meter,a1.num_eqp,f.id_type_eqp 
   ,case when a1.dat_b<=f.dt_b then f.dt_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>coalesce(f.dt_e,a1.dat_e) then f.dt_e else a1.dat_e end as dat_e 
from 
(select a1.id_point,a1.id_meter,e.num_eqp
     ,case when e.dt_b<=a1.dat_b then a1.dat_b else e.dt_b end as dat_b
     ,case when coalesce(e.dt_e,a1.dat_e)>=a1.dat_e then a1.dat_e else e.dt_e end as dat_e   
  from act_meter_pnt_tbl as a1 
  inner join eqm_equipment_h as e 
   on (e.id=a1.id_meter and e.dt_b<a1.dat_e 
   and coalesce(e.dt_e,a1.dat_e)>a1.dat_b) ) as a1 
  inner join eqm_meter_h as f on (f.code_eqp=a1.id_meter
   and f.dt_b<a1.dat_e 
   and coalesce(f.dt_e,a1.dat_e)>a1.dat_b) ) as a 
  inner join act_eqp_branch_tbl as b on 
 (a.id_meter=b.code_eqp and b.dat_b<a.dat_e and b.dat_e>a.dat_b) ) as b 
  inner join  
 (select c.code_eqp
   ,case when coalesce(d.dat_b,c.dat_b)<=c.dat_b then c.dat_b 
     else d.dat_b end as dat_b
   ,case when coalesce(d.dat_e,c.dat_e)>=c.dat_e then c.dat_e 
     else d.dat_e end as dat_e 
   ,(case when c.conversion=1 then c.k_tr_i else c.k_tr_u end)*(
    case when d.conversion=1 then coalesce(d.k_tr_i,1) else 
     coalesce(d.k_tr_u,1) end) as k_tr
   ,case when c.conversion=1 then c.i_ts else case when d.conversion=1 
    then d.i_ts end end as i_ts
   ,case when c.conversion=1 then c.k_tr_i else 
    case when d.conversion=1 then d.k_tr_i end end as k_tr_i
 from 
  (select c1.code_eqp,c1.id_p_eqp,c2.id_type_eqp,c3.conversion
   ,case when c2.dt_b<=c1.dat_b then c1.dat_b else c2.dt_b end as dat_b
   ,case when coalesce(c2.dt_e,c1.dat_e)>c1.dat_e then c1.dat_e 
    else coalesce(c2.dt_e,c1.dat_e) end as dat_e
   ,coalesce(c3.amperage2_nom,0) as i_ts
   ,case when c3.conversion=1 then c3.amperage_nom::numeric/c3.amperage2_nom else 1 end as k_tr_i
   ,case when c3.conversion=2 then c3.voltage_nom::numeric/c3.voltage2_nom else 1 end as k_tr_u
   from act_eqp_branch_tbl as c1 inner join 
    eqm_compensator_i_h as c2 on (c1.code_eqp=c2.code_eqp and 
      c2.dt_b<c1.dat_e and coalesce(c2.dt_e,c1.dat_e)>c1.dat_b) inner join 
    eqi_compensator_i_tbl as c3 on (c2.id_type_eqp=c3.id)
    where type_eqp=10) as c 
  left join (select c1.code_eqp,c2.id_type_eqp,c3.conversion
   ,case when c2.dt_b<=c1.dat_b then c1.dat_b else c2.dt_b end as dat_b
   ,case when coalesce(c2.dt_e,c1.dat_e)>c1.dat_e then c1.dat_e 
    else coalesce(c2.dt_e,c1.dat_e) end as dat_e
   ,coalesce(c3.amperage2_nom,0) as i_ts
   ,case when c3.conversion=1 then c3.amperage_nom::numeric/c3.amperage2_nom else 1 end as k_tr_i
   ,case when c3.conversion=2 then c3.voltage_nom::numeric/c3.voltage2_nom else 1 end as k_tr_u
   from act_eqp_branch_tbl as c1 inner join 
    eqm_compensator_i_h as c2 on (c1.code_eqp=c2.code_eqp and 
      c2.dt_b<c1.dat_e and coalesce(c2.dt_e,c1.dat_e)>c1.dat_b) inner join 
    eqi_compensator_i_tbl as c3 on (c2.id_type_eqp=c3.id)
    where type_eqp=10) as d 
  on (d.code_eqp=c.id_p_eqp and c.dat_b<d.dat_e and c.dat_e>d.dat_b)) as c 
  on (c.code_eqp=b.id_p_eqp and b.dat_b<c.dat_e and b.dat_e>c.dat_b);
--act_met_kndzn_tbl
insert into act_met_kndzn_tbl(id_point,id_meter,num_eqp,kind_energy,id_zone,k_tr
 ,id_type_eqp,dat_b,dat_e) 
select k.id_point,k.id_meter,k.num_eqp,g.kind_energy,h.zone as id_zone,k.k_tr
  ,k.id_type_eqp
  ,case when coalesce(h.dt_b,k.dat_b)<=k.dat_b then k.dat_b 
   else h.dt_b end as dat_b
  ,case when coalesce(h.dt_e,k.dat_e)>=k.dat_e then k.dat_e 
   else h.dt_e end as dat_e 
from 
(select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
  ,coalesce(c.k_tr,1) as k_tr
  ,case when coalesce(c.dat_b,a.dat_b)<=a.dat_b then a.dat_b 
   else c.dat_b end as dat_b
  ,case when coalesce(c.dat_e,a.dat_e)>=a.dat_e then a.dat_e 
   else c.dat_e end as dat_e 
from 

(select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
  ,case when b.dat_b<=a.dat_b then a.dat_b else b.dat_b end as dat_b
  ,case when b.dat_e>=a.dat_e then a.dat_e else b.dat_e end as dat_e 
 from 
 (select a1.id_point,a1.id_meter,a1.num_eqp,f.id_type_eqp 
   ,case when a1.dat_b<=f.dt_b then f.dt_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>coalesce(f.dt_e,a1.dat_e) then f.dt_e else a1.dat_e end as dat_e 
from 
(select a1.id_point,a1.id_meter,e.num_eqp
     ,case when e.dt_b<=a1.dat_b then a1.dat_b else e.dt_b end as dat_b
     ,case when coalesce(e.dt_e,a1.dat_e)>=a1.dat_e then a1.dat_e else e.dt_e end as dat_e   
  from act_meter_pnt_tbl as a1 
  inner join eqm_equipment_h as e 
   on (e.id=a1.id_meter and e.dt_b<a1.dat_e 
   and coalesce(e.dt_e,a1.dat_e)>a1.dat_b) ) as a1 
  inner join eqm_meter_h as f on (f.code_eqp=a1.id_meter
   and f.dt_b<a1.dat_e 
   and coalesce(f.dt_e,a1.dat_e)>a1.dat_b)) as a 

  inner join act_eqp_branch_tbl as b on 
 (a.id_meter=b.code_eqp and b.dat_b<a.dat_e and b.dat_e>a.dat_b) ) as a

  left join act_demand_tbl as c on (c.id_point=a.id_point and c.id_meter=a.id_meter 
  and c.num_eqp=a.num_eqp and a.dat_b<=c.dat_b and a.dat_e>=c.dat_e) ) as k
-- inner join (en_pril 27.03.2007)
   left join eqd_meter_energy_h as g on (k.id_meter=g.code_eqp and g.dt_b<k.dat_e 
   and coalesce(g.dt_e,k.dat_e)>k.dat_b)
-- inner join (en_pril 27.03.2007)
   left join  eqd_meter_zone_h as h on (h.code_eqp=g.code_eqp and 
   h.kind_energy=g.kind_energy and h.dt_b<k.dat_e 
   and coalesce(h.dt_e,k.dat_e)>k.dat_b)  ;

Return true;
end;
' Language 'plpgsql';
