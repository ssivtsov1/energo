create or replace function calc_compens() returns boolean as '
declare
r record;
tes record;
begin 
update acd_met_kndzn_tbl set flock=0 where flock=1;
for r in select * from acd_met_kndzn_tbl where ident=1 
 and met_demand<>ktr_demand  and mmgg>=''2006-01-01'' loop
               
raise notice ''r.id_doc   - % r.id_point -- %'',r.id_doc,r.id_point;
        /*

for tes in  select *  from
(select r.id_point as id_point,r.id_meter as id_meter,r.num_eqp as num_eqp
   ,r.kind_energy as kind_energy,r.id_zone as id_zone,r.dat_b as dat_b 
   ,round((r.ktr_demand/(sqrt(3)::numeric*
      un_p*  cos_p*     r.k_ts     *r.i_ts*
     (case when r.id_zone=0 then wtm_p 
     else round(wtm_p*round(r.ktr_demand::numeric/sum_zone,2),0) end)
    ))*100,2) as p_w
   ,round(5*(sqrt(3)::numeric*un_p*cos_p*r.k_ts*r.i_ts*
     (case when r.id_zone=0 then wtm_p 
     else round(wtm_p*round(r.ktr_demand::numeric/sum_zone,2),0) end)
    )/100,0)  as wp
 from 
 (select a.id_point,a.id_doc
   from acd_met_kndzn_tbl as a where a.id_doc=r.id_doc and a.id_point=r.id_point 

 )   as a1 
  left join 

  (select a.id_doc,a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.dat_b
    ,sum(a.ktr_demand) as sum_zone from acd_met_kndzn_tbl as a 
     where a.id_doc=r.id_doc 
       and a.id_point=r.id_point and a.id_meter=r.id_meter 
       and a.num_eqp=r.num_eqp and a.kind_energy=r.kind_energy 
       and a.dat_b=r.dat_b and a.id_zone<>0 
       group by a.id_doc,a.id_point,a.id_meter ,a.num_eqp,a.kind_energy,a.dat_b
   ) as a2 
    on true
    inner join (select sum(round((case when b.wtm<>0 then b.wtm else 168 end)*date_mi(b.dat_e,b.dat_b),0)) as wtm_p  
     from 
     (select a.code_eqp as id_point,(case when a.wtm<>0 then a.wtm else 168 end)/date_mi(r.dat_e,r.dat_b)::numeric as wtm  
     ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
     ,case when a.dt_e>=r.dat_e then r.dat_e else a.dt_e end as dat_e
    from eqm_point_h as a where a.code_eqp=r.id_point and a.dt_b<r.dat_e 
    and a.dt_e>r.dat_b) as b 
    ) as a4 
   on true
  inner join (select sum(round(c.un*date_mi(c.dat_e,c.dat_b),2)) as un_p 
   from 
    (select a.code_eqp as id_point,b.voltage_min::numeric/date_mi(r.dat_e,r.dat_b) as un
     ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
     ,case when a.dt_e>=r.dat_e then r.dat_e else a.dt_e end as dat_e
     from eqm_point_h as a inner join eqk_voltage_tbl as b 
    on (a.id_voltage=b.id)
    where a.code_eqp=r.id_point and a.dt_b<r.dat_e 
    and coalesce(a.dt_e,r.dat_e) > r.dat_b) as c
   ) as a3 
   on true 
  left join (select sum(round(c.vcos*date_mi(c.dat_e,c.dat_b),2)) as cos_p 
   from 
    (select a.code_eqp as id_point,b.value_cos::numeric/date_mi(r.dat_e,r.dat_b) as vcos
     ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
     ,case when a.dt_e>=r.dat_e then r.dat_e else a.dt_e end as dat_e
     from eqm_point_h as a inner join eqk_tg_tbl as b 
    on (a.id_tg=b.id)
    where a.code_eqp=r.id_point and a.dt_b<r.dat_e and 
        coalesce(a.dt_e,r.dat_b)>r.dat_b) as c
   limit 1) as a5
   on true   as aaa
 
loop
  
raise notice ''tes.un_p   - % tes.cos_p -- %'',tes.un_p,tes.cos_p;
end loop;
          */
update acd_met_kndzn_tbl set calc_demand_nocnt=coalesce(k.wp,0)
  ,p_w=k.p_w
 from 
 
(select r.id_point as id_point,r.id_meter as id_meter,r.num_eqp as num_eqp
   ,r.kind_energy as kind_energy,r.id_zone as id_zone,r.dat_b as dat_b 
   ,round((r.ktr_demand/(sqrt(3)::numeric*
    -- un_p* 
--    cos_p*  
--  r.k_ts     *r.i_ts*
     (case when r.id_zone=0 then (case when wtm_p<>0  then wtm_p else 1 end ) 
     else round(wtm_p*round(r.ktr_demand::numeric/(case when sum_zone<>0  then sum_zone else 999 end ),2),0) end)
    ))*100,2) as p_w
   ,round(5*(sqrt(3)::numeric*
-- un_p*
--  cos_p*
--r.k_ts*r.i_ts*
     (case when r.id_zone=0 then wtm_p 
     else round(wtm_p*round(r.ktr_demand::numeric/(case when sum_zone<>0  then sum_zone else 999 end )
      ,2),0) end)
    )/100,0)  as wp
 from 
 (select a.id_point,a.id_doc
   from acd_met_kndzn_tbl as a where a.id_doc=r.id_doc and a.id_point=r.id_point 

 )   as a1 
  left join 

  (select a.id_doc,a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.dat_b
    ,sum(a.ktr_demand) as sum_zone from acd_met_kndzn_tbl as a 
     where a.id_doc=r.id_doc 
       and a.id_point=r.id_point and a.id_meter=r.id_meter 
       and a.num_eqp=r.num_eqp and a.kind_energy=r.kind_energy 
       and a.dat_b=r.dat_b and a.id_zone<>0 
       group by a.id_doc,a.id_point,a.id_meter ,a.num_eqp,a.kind_energy,a.dat_b
   ) as a2 
    on true
    inner join (select sum(round((case when b.wtm<>0 then b.wtm else 168 end)*date_mi(b.dat_e,b.dat_b),0)) as wtm_p  
     from 
     (select a.code_eqp as id_point,(case when a.wtm<>0 then a.wtm else 168 end)/( case when date_mi(r.dat_e,r.dat_b)<>0 then date_mi(r.dat_e,r.dat_b) else 1 end)::numeric as wtm  
     ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
     ,case when a.dt_e>=r.dat_e then r.dat_e else a.dt_e end as dat_e
    from eqm_point_h as a where a.code_eqp=r.id_point and a.dt_b<r.dat_e 
    and a.dt_e>r.dat_b) as b 
    ) as a4 
   on true
  inner join (select sum(round(c.un*date_mi(c.dat_e,c.dat_b),2)) as un_p 
   from 
    (select a.code_eqp as id_point,b.voltage_min::numeric/( case when date_mi(r.dat_e,r.dat_b)<>0 then date_mi(r.dat_e,r.dat_b) else 1 end) as un
     ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
     ,case when a.dt_e>=r.dat_e then r.dat_e else a.dt_e end as dat_e
     from eqm_point_h as a inner join eqk_voltage_tbl as b 
    on ((case when coalesce(a.id_voltage,0)=0 then 4 else a.id_voltage end )=b.id)
    where a.code_eqp=r.id_point and a.dt_b<r.dat_e 
    and coalesce(a.dt_e,r.dat_e) > r.dat_b) as c
   ) as a3 
   on true 
  left join (select sum(round(c.vcos*date_mi(c.dat_e,c.dat_b),2)) as cos_p 
   from 
    (select a.code_eqp as id_point,b.value_cos::numeric/( case when date_mi(r.dat_e,r.dat_b)<>0 then date_mi(r.dat_e,r.dat_b) else 1 end) as vcos
     ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
     ,case when a.dt_e>=r.dat_e then r.dat_e else a.dt_e end as dat_e
     from eqm_point_h as a inner join eqk_tg_tbl as b 
    on ((case when coalesce(a.id_tg,0)  in (1,2) then a.id_tg else 2 end) =b.id)
    where a.code_eqp=r.id_point and a.dt_b<r.dat_e and 
        coalesce(a.dt_e,r.dat_b)>r.dat_b) as c
   limit 1) as a5
   on true) as k 
 where 
  r.id_doc=acd_met_kndzn_tbl.id_doc 
  and k.id_meter=acd_met_kndzn_tbl.id_meter 
  and k.id_point=acd_met_kndzn_tbl.id_point 
  and k.num_eqp=acd_met_kndzn_tbl.num_eqp 
  and k.kind_energy=acd_met_kndzn_tbl.kind_energy
  and k.id_zone=acd_met_kndzn_tbl.id_zone 
  and k.dat_b=acd_met_kndzn_tbl.dat_b;


end loop;
return true;
end;
' language 'plpgsql';

select calc_compens();