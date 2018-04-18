/*
create temp table bal_midpoint_demand_tmp(

 id_midpoint int,
 id_client int,
 id_point  int,
 demand    int,
 id_grp    int,
 primary key (id_midpoint,id_point)

);
*/

create or replace function bal_midpoint_fun(int,int,int,int,date) 
Returns boolean As'
Declare

 pid_eqp Alias for $1;
 pid_client Alias for $2;
 pid_res Alias for $3;

-- ptype_eqp Alias for $5;
-- pid_tree Alias for $6;
-- pid_p_grp Alias for $7;
-- pid_grp_lvl Alias for $8;
 pid_midpoint Alias for $4;
 pmmgg Alias for $5;


 point int;
 child record;
 v boolean; 

begin


 if pid_client<>pid_res then  -- не оборудование РЕС = ТУ абононта
-- if ptype_eqp=12 then 

   Raise Notice '' point %'',pid_eqp;

   insert into bal_midpoint_demand_tmp (id_midpoint,id_client,id_point,demand)
   select pid_midpoint,pid_client,pid_eqp,acc.demand
   from bal_acc_tbl as acc 
   where acc.code_eqp=pid_eqp and acc.mmgg=pmmgg;

   return true;

--   if found or (pid_client<>pid_res) then
--     return true;
--  end if;

 end if;


 for child in 
   select bt.code_eqp,bt.id_client,bt.type_eqp,bt.id_tree 
   from bal_eqp_tbl as bt
   where bt.id_p_eqp = pid_eqp
   and bt.mmgg = pmmgg loop

   Raise Notice ''start1 %'',child.code_eqp;

   v:=bal_midpoint_fun(child.code_eqp,child.id_client,pid_res,pid_midpoint,pmmgg);

  end loop;

 return true;
end;
' Language 'plpgsql';



create or replace function bal_midpoint_start_fun(date) 
Returns boolean As'
Declare

 pmmgg Alias for $1;

 point int;
 rec record;
 child record;
 v boolean; 
 vid_res int;

begin

 id_res := syi_resid_fun();
 delete from bal_midpoint_demand_tmp;

 for rec in 
  select p.code_eqp 
  from bal_eqp_tbl as p
--  join bal_demand_tbl as d on (d.id_point = p.code_eqp and d.mmgg='2009-04-01')
--  join bal_acc_tbl as acc on (acc.code_eqp = p.code_eqp and acc.mmgg='2009-04-01')
  left join bal_grp_tree_tbl as g on (p.code_eqp = g.id_point and g.mmgg=pmmgg)
  left join eqm_compens_station_inst_tbl as inst on (inst.code_eqp = p.code_eqp)
  left join eqm_equipment_tbl as eq on (eq.id = inst.code_eqp_inst)
  where p.type_eqp =12 and p.mmgg=pmmgg and p.id_client = vid_res
  and g.id_point is null and (coalesce(eq.type_eqp,15)=15)
 loop

   for child in 
     select bt.code_eqp,bt.id_client,bt.type_eqp,bt.id_tree 
     from bal_eqp_tbl as bt
     where bt.id_p_eqp = rec.code_eqp
     and bt.mmgg = pmmgg loop

     Raise Notice ''start0 %'',child.code_eqp;

     v:=bal_midpoint_fun(child.code_eqp,child.id_client,vid_res,rec.code_eqp,pmmgg);

    end loop;

 end loop;


 update bal_midpoint_demand_tmp set id_grp =  g.id_p_eqp
 from bal_grp_tree_tbl as g
 where g.code_eqp = bal_midpoint_demand_tmp.id_point  
 and g.mmgg= pmmgg;


 return true;
end;
' Language 'plpgsql';


/*
select p.code_eqp, d.ktr_demand, acc.demand,acc.demand04,acc.fiz_count,acc.fiz_power 
from bal_eqp_tbl as p
join bal_demand_tbl as d on (d.id_point = p.code_eqp and d.mmgg='2009-04-01')
join bal_acc_tbl as acc on (acc.code_eqp = p.code_eqp and acc.mmgg='2009-04-01')
left join bal_grp_tree_tbl as g on (p.code_eqp = g.id_point and g.mmgg='2009-04-01')
left join eqm_compens_station_inst_tbl as inst on (inst.code_eqp = p.code_eqp)
left join eqm_equipment_tbl as eq on (eq.id = inst.code_eqp_inst)
where p.type_eqp =12 and p.mmgg='2009-04-01' and p.id_client = syi_resid_fun()
and g.id_point is null and (coalesce(eq.type_eqp,15)=15)

*/