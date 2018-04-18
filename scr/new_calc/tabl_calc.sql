


select crt_ttbl();


select calc_client(3008,'2014-12-01')

select * from act_difmetzone_tbl 

select * from acd_comp_percent_tbl

select * from acd_indication_tbl where id_client=4354 and mmgg='2014-12-01'

select * from acd_indication_tbl where id_main_ind is not null

select * from act_pwr_demand_tbl where id_point in (1105141,1118052)


update act_pwr_demand_tbl 
  set fact_demand=fact_demand-pp.demand_calc 
  from (select id_point_p,zone_p,kind_energy,dt_e,dt_b,sum(demand_calc)
        as demand_calc from
        act_difmetzone_tbl where dt_b=test.dat_b and dt_e=test.dat_e
         group by id_point_p,zone_p,kind_energy,dt_e,dt_b
        ) 
       pp 
 where  act_pwr_demand_tbl.id_point=pp.id_point_p 
   and act_pwr_demand_tbl.kind_energy=pp.kind_energy 
   and act_pwr_demand_tbl.dat_b=pp.dt_b 
   and act_pwr_demand_tbl.dat_e=pp.dt_e 
   and act_pwr_demand_tbl.id_point=test.id_point 
    and   act_pwr_demand_tbl.id_zone=test.id_zone 
   and act_pwr_demand_tbl.kind_energy=test.kind_energy
  -- and act_pwr_demand_tbl.dat_e=test.dat_e 
   --and act_pwr_demand_tbl.dat_b=test.dat_b
   and act_pwr_demand_tbl.ident=1 
   and act_pwr_demand_tbl.id_zone=pp.zone_p;

   select id_point,kind_energy,id_zone,dat_b,dat_e,sum(coalesce(fact_demand,0,00))  as fact_demand
    from act_pwr_demand_tbl  where dat_b>='2014-12-01' and dat_e<='2015-01-01'
     group by  id_point,kind_energy,id_zone,dat_b,dat_e order by id_point 



select * from acd_inddifzone_tbl where id_meter=1118055

select calc_client(516,'2014-11-01')

select * from clm_client_tbl where code=516;

select * from acm_tax_tbl where  mmgg='2014-11-01'






delete from acm_tax_tbl where  flock=0
 delete from acm_taxadvcor_tbl where  flock=0
delete from  acm_taxcorrection_tbl where flock=0

select * from act_pnt_lost

select start_calc(2611,2021167,
 '2014-11-01' ) as boolch


select crt_ttbl();
select * from  act_comp_percent
select * from act_calc_losts_tbl
select * from act_losts_eqm_tbl 

delete from acm_tax_tbl where mmgg='2014-11-01'
update acm_tax_tbl set flag_transmis=0 where mmgg='2014-11-01'

update acm_taxcorrection_tbl set flag_transmis=0 where mmgg='2014-11-01'
delete from acm_taxcorrection_tbl where mmgg='2014-11-01'
select * from acm_taxcorrection_tbl where mmgg='2014-11-01'

select * from clm_position_tbl where id_client=4781 order by last_name
select * into tmp_clm from clm_position_tbl where id in (273,267) 

select * from act_calc_losts_tbl
select * from act

insert into  act_comp_percent (id_point,id_eqp,id_p_point,sn_len,sum_wp,sum_wq,dat_b,dat_e, wp_parent,perc,add_wp,all_wp)
select l.id_point,l.id_eqp,p.id_p_point,sn_len,sum_wp,sum_wq,l.dat_b,l.dat_e ,0 as wp_parent,0 as perc,0 as add_wp,0 as all_wp
from act_losts_eqm_tbl l,act_point_branch_tbl p 
where l.type_eqm=2 and p.id_point=l.id_point and p.id_p_point is not null
order by l.id_point

select * from act_comp_percent order by id_p_point


select * from act_pwr_demand_tbl where id_point=1148935

select c.*,p.* from  act_comp_percent c,act_pwr_demand_tbl p where p.id_point=c.id_p_point and p.kind_energy=1

update act_comp_percent set perc=cc from
(select c.*,100.00/pr.ssn*c.sn_len as cc  from act_comp_percent c, 
(
 select id_p_point,dat_b,dat_e,sum(sn_len)  as ssn from 
 (select  distinct id_p_point,id_eqp,dat_b,dat_e,sn_len from act_comp_percent )  d
 group by id_p_point,dat_b,dat_e
) pr
where  c.id_p_point=pr.id_p_point) pers
where pers.id_p_point=act_comp_percent.id_p_point and pers.id_eqp=act_comp_percent.id_eqp
  and pers.id_point=act_comp_percent.id_point

update act_comp_percent set wp_parent =fact_par.fact,add_wp=(perc/100)*fact_par.fact from  
 (select id_point,sum(fact_demand) as fact from act_pwr_demand_tbl where kind_energy=1 group by id_point) fact_par
 where fact_par.id_point=act_comp_percent.id_p_point






create sequence acd_comp_percent_seq;
drop table acd_comp_percent
create table acd_comp_percent(
     id                 int default nextval('acd_comp_percent_seq'),
     id_doc             int,   
     id_point		int,
     id_eqp		int,
     id_p_point         int,
     dat_b		date,
     dat_e		date,
     sn_len		numeric(14,2),
     sum_wp             int,
     sum_wq             int  ,
     wp_parent          int,
     perc               numeric (10,5),
     add_wp             int,
     all_wp             int, 
     primary key(id)
);




insert into  act_comp_percent (id_point,id_eqp,id_p_point,sn_len,sum_wp,sum_wq,dat_b,dat_e, wp_parent,perc,add_wp,all_wp)

select l.id_point,l.id_eqp,p.id_p_point,sn_len,sum_wp,sum_wq,l.dat_b,l.dat_e ,0as wq_parent,0 as perc,0 as add_wq,0 as all_wq
from act_losts_eqm_tbl l,act_point_branch_tbl p 
where l.type_eqm=2 and p.id_point=l.id_point and p.id_p_point is not null
order by l.id_point



select * from act_point_branch_tbl order by id_p_point

