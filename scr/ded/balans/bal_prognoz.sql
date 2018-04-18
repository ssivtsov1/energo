;
set client_encoding = 'win';


CREATE TABLE bal_points_all_tbl
(
  id_client integer,
  id_point integer NOT NULL,
  id_grp integer,
  type_grp integer,
  id_fider integer,
  id_p_point integer,
  fiz_count integer,
  dat date NOT NULL,
  CONSTRAINT bal_points_all_tbl_pkey PRIMARY KEY (id_point, dat)
); 

create table bal_prognoz_basics_tbl (
	res_demand int,
	losts_1kl  int,
        losts_2kl  int,
        mmgg       date,
	primary key (mmgg)
);

ALTER TABLE bal_prognoz_basics_tbl ADD COLUMN res_demand_fact integer;
ALTER TABLE bal_prognoz_basics_tbl ADD COLUMN losts_1kl_fact integer;
ALTER TABLE bal_prognoz_basics_tbl ADD COLUMN losts_2kl_fact integer;


create table bal_prognoz_fiders_tbl (
        id_fider   int,
	res_demand_prognoz int,
	losts_prognoz  int,
	abon_demand_prognoz int,
	abon_sum_prognoz int,
        mmgg       date,
	primary key (id_fider,mmgg)
);

drop table bal_prognoz_points_tbl;
create table bal_prognoz_points_tbl (
        id_client  int,
        id_point   int,
	demand_prognoz int,
        id_tariff      int,
        sum_tariff     numeric(10,4),
        sum_prognoz    numeric(12,2),
        mmgg       date,
	primary key (id_client,id_point,mmgg)
);

--select * from clm_client_tbl where book <>-1

delete from bal_points_all_tbl;

create or replace function bal_points_find_fun(date) Returns boolean As'
Declare
pdt Alias for $1;

r record;
rr record;
rs boolean;
id_res int;
parent int;
dubl   int;
fider  int;
grp record;

child record;
child_code int;
v boolean; 

begin


 delete from bal_points_all_tbl where dat = pdt;
 

 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
  
 for r in 
   Select distinct t.id as id_tree, cl.id as id_client,tt.code_eqp,tt.code_eqp_e 
    From eqm_point_h AS eq 
    join (select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <=  pdt and coalesce(dt_e, pdt) >=  pdt group by code_eqp order by code_eqp ) as p2 on (eq.code_eqp = p2.code_eqp and p2.dt = eq.dt_b) 
--    join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.code_eqp and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt)
    join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.code_eqp )
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e, pdt) >= pdt group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
--    join eqm_tree_h AS t on (t.id=tt.id_tree and t.dt_b <= pdt and coalesce(t.dt_e,pdt) >= pdt)
    join eqm_tree_h AS t on (t.id=tt.id_tree )
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <=  pdt and coalesce(dt_e,  pdt) >= pdt group by id order by id) as t2 on (t.id = t2.id and t2.dt = t.dt_b) 

--    left join eqm_eqp_use_h as use on (use.code_eqp=eq.code_eqp and use.dt_b <= pdt and coalesce(use.dt_e,pdt) >= pdt)

    left join  ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h  where dt_b <=  pdt and coalesce(dt_e, pdt) >=  pdt group by code_eqp order by code_eqp ) as u2 
     on (u1.code_eqp = u2.code_eqp and u2.dt = u1.dt_b) 
     where coalesce(dt_b,now()) <>coalesce( dt_e, now())
    ) as use on (use.code_eqp = eq.code_eqp) 
    join clm_client_tbl as cl on (coalesce(use.id_client,t.id_client) = cl.id)
    WHERE cl.id<>id_res and cl.book =-1  
--    and eq.dt_b <= pdt and coalesce(eq.dt_e,pdt) >= pdt
 loop

   Raise Notice ''Start %'',r.code_eqp;

   parent :=r.code_eqp_e;

   dubl :=0; 
   fider:=0;

   -----------------------------------------------------------------------

   if (r.code_eqp_e is not NULL) then


     LOOP
    
       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp
       from eqm_equipment_h as eq 
       join (select id, max(dt_b) as dt from eqm_equipment_h  where  id = parent and dt_b <=  pdt and coalesce(dt_e, pdt) >= pdt group by id order by id ) as eq3 on (eq.id = eq3.id and eq3.dt = eq.dt_b) 
--       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt)
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL )
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where code_eqp = parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt and code_eqp_e is not NULL group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
--       left join eqm_compens_station_inst_h as st on (eq.id = st.code_eqp and st.dt_b <= pdt and coalesce(st.dt_e,pdt) >= pdt)
       left join 
       (select inst.* from eqm_compens_station_inst_h as inst 
--         join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp_inst,code_eqp order by code_eqp_inst,code_eqp) as inst2 
          join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where code_eqp = parent and coalesce(dt_e,pdt) >= pdt group by code_eqp_inst,code_eqp order by code_eqp_inst) as inst2 
          on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b) 
       ) as st on (eq.id = st.code_eqp )
       left join 
       (select eq3.* from eqm_equipment_tbl as eq3 
         join eqm_area_tbl as aa on (aa.code_eqp = eq3.id)
         left join eqm_fider_tbl as f on (f.code_eqp = eq3.id)
         where eq3.type_eqp in (15,8) and coalesce(f.id_voltage,0) not in (4,42) 
          and aa.id_client = id_res order by eq3.id 
       ) as eq2 on (eq2.id = st.code_eqp_inst )
       where  eq.id = parent 
--       and eq.dt_b <= pdt and coalesce(eq.dt_e,pdt) >= pdt
       ;

       Raise Notice ''-eqp %'',parent;
    
       if grp.type_grp is not null then
    
        if (dubl<>0) then
         insert into bal_points_all_tbl (id_client,id_point,id_grp,type_grp,id_p_point,dat) values (r.id_client,r.code_eqp, grp.id_grp,grp.type_grp,dubl,pdt);
        else
         insert into bal_points_all_tbl (id_client,id_point,id_grp,type_grp,dat) values (r.id_client,r.code_eqp, grp.id_grp,grp.type_grp,pdt);
        end if;
    
        fider:=grp.id_grp;
    
       else
    
        if grp.code_eqp_e is null then
    
         if (dubl<>0) then
          insert into bal_points_all_tbl (id_client,id_point,id_p_point,dat) values (r.id_client,r.code_eqp, dubl,pdt);
         else
          insert into bal_points_all_tbl (id_client,id_point,dat) values (r.id_client,r.code_eqp,pdt);
         end if;
    
        end if;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- наткнулись на другую “” 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;

     end loop;

   else

     insert into bal_points_all_tbl (id_client,id_point,dat) values (r.id_client,r.code_eqp,pdt);
   end if;

 end loop;


---------------------------------------------------------------------------
 for r in 
   Select  c.id_eqpborder , count(distinct c.id) as fiz_count  
   from clm_pclient_tbl as c
--   left join acm_privdem_tbl as pm  on (c.id = pm.id_client) 
   where 
   --value <>0 and 
   coalesce(c.id_state,0)<>50
--   and pm.mmgg = date_trunc(''month'',pdt) - ''1 month''::interval -- and pm.id_eqpborder is not null
   group by c.id_eqpborder 
 loop

   Raise Notice ''Start fiz%'',r.id_eqpborder;

   parent :=r.id_eqpborder;

   dubl :=0; 
   fider:=0;

   if (r.id_eqpborder is not NULL) then

     LOOP
    
--       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp
--       from eqm_equipment_h as eq 
--       left join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt)
--       left join eqm_compens_station_inst_h as st on (eq.id = st.code_eqp and st.dt_b <= pdt and coalesce(st.dt_e,pdt) >= pdt)
--       left join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst and eq2.type_eqp in (15,8))
--       where  eq.id = parent and eq.dt_b <= pdt and coalesce(eq.dt_e,pdt) >= pdt;
       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp
       from eqm_equipment_h as eq 
       join (select id, max(dt_b) as dt from eqm_equipment_h  where id=parent and dt_b <=  pdt and coalesce(dt_e, pdt) >= pdt group by id order by id ) as eq3 on (eq.id = eq3.id and eq3.dt = eq.dt_b) 
--       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt)
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL )
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where code_eqp =parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt and code_eqp_e is not NULL group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
--       left join eqm_compens_station_inst_h as st on (eq.id = st.code_eqp and st.dt_b <= pdt and coalesce(st.dt_e,pdt) >= pdt)
       left join 
       (select inst.* from eqm_compens_station_inst_h as inst 
--         join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp_inst,code_eqp order by code_eqp_inst,code_eqp) as inst2 
          join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where code_eqp = parent and coalesce(dt_e,pdt) >= pdt group by code_eqp_inst,code_eqp order by code_eqp_inst) as inst2 
          on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b) 
       ) as st on (eq.id = st.code_eqp )
       left join 
       (select eq3.* from eqm_equipment_tbl as eq3 
         join eqm_area_tbl as aa on (aa.code_eqp = eq3.id)
         left join eqm_fider_tbl as f on (f.code_eqp = eq3.id)
         where type_eqp in (15,8) and coalesce(f.id_voltage,0) not in (4,42) 
         and aa.id_client = id_res order by eq3.id 
       ) as eq2 on (eq2.id = st.code_eqp_inst )
       where  eq.id = parent 
--       and eq.dt_b <= pdt and coalesce(eq.dt_e,pdt) >= pdt
       ;

    
       if grp.type_grp is not null then
    
        if (dubl<>0) then
	   insert into bal_points_all_tbl (id_client,id_point,id_grp,type_grp,id_p_point,dat,fiz_count) values (-1,-r.id_eqpborder, grp.id_grp,grp.type_grp,dubl,pdt,r.fiz_count);
        else
	   insert into bal_points_all_tbl (id_client,id_point,id_grp,type_grp,dat,fiz_count) values (-1,-r.id_eqpborder, grp.id_grp,grp.type_grp,pdt,r.fiz_count);
        end if;
    
        fider:=grp.id_grp;
    
       else
    
        if grp.code_eqp_e is null then
    
         if (dubl<>0) then
	   insert into bal_points_all_tbl (id_client,id_point,id_p_point,dat,fiz_count) values (-1,-r.id_eqpborder,dubl,pdt,r.fiz_count);
         else
	   insert into bal_points_all_tbl (id_client,id_point,dat,fiz_count) values (-1,-r.id_eqpborder,pdt,r.fiz_count);
         end if;
    
        end if;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;
     end loop;

   else
	insert into bal_points_all_tbl (id_client,id_point,dat,fiz_count) values (-1,0,pdt,r.fiz_count);
   end if;                                        

 end loop;

 update bal_points_all_tbl set id_fider = 
   case when gr1.id_voltage in (3,31,32) and gr1.type_eqp = 15 then gr1.code_eqp   when gr2.id_voltage in (3,31,32) and gr2.type_eqp = 15 then gr2.code_eqp  END 
 from 
    bal_grp_tree_tbl as gr1 
    left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= (select max(mmgg) from bal_grp_tree_tbl where mmgg < pdt) ) 
 where gr1.code_eqp = bal_points_all_tbl.id_grp and gr1.mmgg = (select max(mmgg) from bal_grp_tree_tbl where mmgg < pdt)   ;

 Return true;
end;
' Language 'plpgsql';



-------------------------------------------------------------------------------------------------------------------


create or replace function bal_prognoz_calc_fun(date) Returns boolean As'
Declare
pdt Alias for $1;

r record;
rr record;
rs boolean;
id_res int;
fider  int;
rfiz   record;
v boolean; 
vmmgg_1 date;
vabon_demand int;
vfiz_demand int;
vprog record;
vsumdemand int;
verrordemand int;
verrorlost int;
vsumktr_demand int;
vsumlost int;
begin

 delete from bal_prognoz_points_tbl where mmgg=date_trunc(''month'',pdt); 
 delete from bal_prognoz_fiders_tbl where mmgg=date_trunc(''month'',pdt); 

 select into r * from bal_points_all_tbl where dat = pdt limit 1;
 if not found then
  perform bal_points_find_fun(pdt);
 end if; 

 vmmgg_1:= date_trunc(''month'',pdt) - ''1 month''::interval;

 select into vabon_demand sum(bs.demand_val) as sdemand from 
  clm_client_tbl as cl 
  join clm_statecl_tbl as scl on (cl.id = scl.id_client)
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join bal_points_all_tbl as pa on (pa.id_point = bs.id_point)
  where b.mmgg = vmmgg_1 and b.id_pref in (10,101) and (b.idk_doc <> 280)  and cl.book = -1 
  and scl.id_section not in (205,206,207,208) 
  and cl.idk_work not in (0,99) and coalesce(cl.id_state,0) not in (50,99) and pa.dat = pdt and pa.id_fider is not null;


 Select into vfiz_demand sum(value) from acm_privdem_tbl  
   where  mmgg = vmmgg_1 and id_eqpborder is not null ;


 select into vprog res_demand,coalesce(losts_1kl,0) as losts_1kl, coalesce(losts_2kl,0) as losts_2kl, 
  res_demand - coalesce(losts_1kl,0) - coalesce(losts_2kl,0)  as abon_demand
  from bal_prognoz_basics_tbl 
 where mmgg = date_trunc(''month'',pdt);

 --по “” юр лиц
 insert into bal_prognoz_points_tbl(id_client,id_point, id_tariff, demand_prognoz, mmgg)
 select cl.id, bs.id_point, max(bs.id_tariff), 
  round(coalesce(sum(bs.demand_val),0)::numeric * vprog.abon_demand / (vabon_demand+vfiz_demand),0) as sdemand, 
  date_trunc(''month'',pdt)
  from clm_client_tbl as cl 
  join clm_statecl_tbl as scl on (cl.id = scl.id_client)
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join acd_billsum_tbl as bs using ( id_doc) 
  join bal_points_all_tbl as pa on (pa.id_point = bs.id_point and pa.dat = pdt and pa.id_fider is not null)
  where b.mmgg = vmmgg_1 and b.id_pref in (10,101) and (b.idk_doc <> 280) and cl.book = -1 
  and scl.id_section not in (205,206,207,208) 
  and cl.idk_work not in (0,99) and coalesce(cl.id_state,0) not in (50,99)
group by cl.id, bs.id_point ;


 --по населению возьмем потребление и оплату за прошлый мес€ц и посчитаем средний тариф
 select into rfiz sum(nar_v) as snar_v, sum(nar_pdv) as snar_n , sum(nar) as snar
  from seb_obr_all_tbl as obr join clm_client_tbl as c on (c.id = obr.id_client) 
  where obr.period = vmmgg_1 and obr.id_pref in (10,101)  and obr.idk_work not in (0,99) and obr.roz =9;

 --население
 insert into bal_prognoz_points_tbl(id_client,id_point, id_tariff, sum_tariff, demand_prognoz, mmgg)
 Select -1,-coalesce(pm.id_eqpborder,0) ,-1, round((rfiz.snar_v -  rfiz.snar_n)/rfiz.snar,4),
  round(coalesce(sum(value),0)::numeric * vprog.abon_demand / (vabon_demand+vfiz_demand),0) as sdemand, 
  date_trunc(''month'',pdt)
  from acm_privdem_tbl as pm 
   where mmgg = vmmgg_1 and id_eqpborder is not null
   group by pm.id_eqpborder ;

 -- разбрасываеи погрешность по 1 к¬т
 select into vsumdemand sum(demand_prognoz) from bal_prognoz_points_tbl where mmgg = date_trunc(''month'',pdt);
 
 verrordemand := vprog.abon_demand - vsumdemand;
 
 for r in select * from bal_prognoz_points_tbl 
  where mmgg = date_trunc(''month'',pdt) order by demand_prognoz desc
 loop

  if verrordemand>0 then
    update bal_prognoz_points_tbl  set demand_prognoz = demand_prognoz+1
    where id_point = r.id_point and  mmgg = date_trunc(''month'',pdt);
    verrordemand:=verrordemand-1;
   end if;

   if verrordemand<0 then
    update bal_prognoz_points_tbl  set demand_prognoz = demand_prognoz-1
    where id_point = r.id_point and  mmgg = date_trunc(''month'',pdt);
    verrordemand:=verrordemand+1;
   end if;

  EXIT WHEN ( verrordemand = 0 );   
   
 end loop;


 update bal_prognoz_points_tbl set sum_tariff = td.value
    from acd_tarif_tbl as td 
    join (select id_tarif, max(dt_begin) as dt_begin from acd_tarif_tbl where dt_begin <= pdt group by id_tarif ) as td2 
     on (td.id_tarif = td2.id_tarif  and td.dt_begin = td2.dt_begin)
  where td.id_tarif = bal_prognoz_points_tbl.id_tariff and bal_prognoz_points_tbl.mmgg = date_trunc(''month'',pdt) ;


 update bal_prognoz_points_tbl set sum_prognoz = demand_prognoz * sum_tariff *1.2
 where mmgg = date_trunc(''month'',pdt);
 -----------------------------------------------------------------------------------------
  -- по фидеру в целом поступление и потери
  select into vsumktr_demand sum(bd.ktr_demand)
   from bal_grp_tree_conn_tbl as gt 
   join bal_demand_tbl as bd on (bd.id_point=gt.id_point and bd.mmgg = vmmgg_1  ) 
   join eqm_fider_tbl as f on (f.code_eqp = gt.code_eqp)
   where gt.type_eqp=15 and gt.mmgg = vmmgg_1 and coalesce(f.balans_only,0)= 0 ;
 
  select into vsumlost sum(losts)
   from bal_grp_tree_conn_tbl as gt 
   join eqm_fider_tbl as f on (f.code_eqp = gt.code_eqp)
   where gt.type_eqp=15 and gt.mmgg = vmmgg_1 and coalesce(f.balans_only,0)= 0;

  insert into bal_prognoz_fiders_tbl(id_fider,res_demand_prognoz,losts_prognoz,mmgg)
   select gt.code_eqp,
   round(coalesce(bd.ktr_demand,0)::numeric * (vprog.res_demand - vprog.losts_1kl) / vsumktr_demand ,0) , 
   round(coalesce(gt.losts,0)::numeric * vprog.losts_2kl / vsumlost ,0) ,date_trunc(''month'',pdt) 
   from bal_grp_tree_conn_tbl as gt 
   join eqm_fider_tbl as f on (f.code_eqp = gt.code_eqp)
   left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = vmmgg_1 ) 
    where gt.type_eqp=15 and gt.mmgg = vmmgg_1 and coalesce(f.balans_only,0)= 0 and gt.id_voltage in (3,31,32);  

  -- просуммируем абонентский прогноз
  update bal_prognoz_fiders_tbl set abon_demand_prognoz = ss.demand, abon_sum_prognoz = ss.sum
   from 
   (select pa.id_fider, coalesce(sum(pp.demand_prognoz),0) as demand, coalesce(sum(pp.sum_prognoz),0) as sum  
   from bal_prognoz_points_tbl as pp 
   join bal_points_all_tbl as pa on (pa.id_point = pp.id_point)
   where pp.mmgg = date_trunc(''month'',pdt) and pa.dat = pdt
   group by pa.id_fider
   ) as ss 
  where ss.id_fider =  bal_prognoz_fiders_tbl.id_fider ;


  select into rr sum(res_demand_prognoz) as dem_prog, sum(losts_prognoz) as lost_prog 
   from bal_prognoz_fiders_tbl
   where mmgg = date_trunc(''month'',pdt);

  verrordemand := vprog.res_demand - vprog.losts_1kl  - rr.dem_prog;
  verrorlost := vprog.losts_2kl  - rr.lost_prog;

 for r in select * from bal_prognoz_fiders_tbl 
  where mmgg = date_trunc(''month'',pdt) and losts_prognoz is not null and res_demand_prognoz is not null
  order by losts_prognoz desc
 loop

  if verrordemand>0 then
    update bal_prognoz_fiders_tbl  set res_demand_prognoz = res_demand_prognoz+1
    where id_fider = r.id_fider and  mmgg = date_trunc(''month'',pdt);
    verrordemand:=verrordemand-1;
  end if;

  if verrordemand<0 then
    update bal_prognoz_fiders_tbl  set res_demand_prognoz = res_demand_prognoz-1
    where id_fider = r.id_fider and  mmgg = date_trunc(''month'',pdt);
    verrordemand:=verrordemand+1;
  end if;

  if verrorlost>0 then
    update bal_prognoz_fiders_tbl  set losts_prognoz = losts_prognoz+1
    where id_fider = r.id_fider and  mmgg = date_trunc(''month'',pdt);
    verrorlost:=verrorlost-1;
  end if;

  if verrorlost<0 then
    update bal_prognoz_fiders_tbl  set losts_prognoz = losts_prognoz-1
    where id_fider = r.id_fider and  mmgg = date_trunc(''month'',pdt);
    verrorlost:=verrorlost+1;
  end if;

  EXIT WHEN ( verrordemand = 0 and verrorlost = 0);   
   
 end loop;

 Return true;
end;
' Language 'plpgsql';
