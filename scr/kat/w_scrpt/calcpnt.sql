;
set client_encoding = 'koi8';

alter table acd_pwr_demand_tbl add column doubl2_demand      int;
alter table acd_pwr_demand_del add column doubl2_demand      int;

select altr_colmn_repl('eqm_point_tbl', 'share', 'numeric(10,5)');
select altr_colmn_repl('eqm_point_h', 'share', 'numeric(10,5)');

--drop function clc_abn(int,date,date);
create or replace function clc_abn(int,date,date) Returns boolean As'
Declare
idcl Alias for $1;
dtb Alias for $2;
dte Alias for $3;
test record;
test_difm record;
r record; 
r_1 record;
rek_d record; 
rs boolean;
cnt int;
cou int;

begin

Raise Notice ''insert into act_pwr_demand_tbl'';
---- ident= 1-indic,2-pwr,3-avrg,4-r_by_active,5 - add_calc,6 - percent
insert into act_pwr_demand_tbl(id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,sum_losts,fact_losts,ident) 
select id_point,kind_energy,id_zone,dat_b,dat_e
   ,ktr_demand,ktr_demand,hand_losts,hand_losts,1 
from (
 select t2.id_point,t2.kind_energy,t2.id_zone,t2.ktr_demand,coalesce(t2.hand_losts,0) as hand_losts
   ,case when mdtb_kndzn(t2.dat_b,t1.dat_b,t2.id_point,t2.kind_energy,t2.id_zone)
    <=t1.dat_b then t1.dat_b else mdtb_kndzn(t2.dat_b,t1.dat_b
       ,t2.id_point,t2.kind_energy,t2.id_zone) end as dat_b
   ,case when t2.dat_e>=t1.dat_e then t1.dat_e 
     else t2.dat_e end as dat_e 
 from act_met_kndzn_tbl as t2 inner join 
(select a1.id_point,a2.kind_energy
  ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
  ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e  
 from 
(select distinct a.id_point,a.dat_b,a.dat_e from act_point_branch_tbl as a         --*********
   where a.id_client=idcl) as a1 
inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b)) as t1
on (t1.id_point=t2.id_point and t1.kind_energy=t2.kind_energy 
    and t2.dat_b<=t1.dat_e and t2.dat_e>t1.dat_b)) as k; 
--  group by id_point,kind_energy,id_zone,dat_b ;
--  and t2.dat_b<t1.dat_e and t2.dat_e>t1.dat_b)) as k;  б?ло до 29.10
--return false;
Raise Notice ''insert into act_pwr_demand_tbl 2'';
----additional insert up points for share calc
insert into act_pwr_demand_tbl(id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,sum_losts,fact_losts,ident) 
select id_point,kind_energy,id_zone,dat_b,dat_e
   ,ktr_demand,ktr_demand,hand_losts,hand_losts,1 
from (
 select t2.id_point,t2.kind_energy,t2.id_zone,t2.ktr_demand,coalesce(t2.hand_losts,0) as hand_losts
   ,case when mdtb_kndzn(t2.dat_b,t1.dat_b,t2.id_point,t2.kind_energy,t2.id_zone)
    <=t1.dat_b then t1.dat_b else mdtb_kndzn(t2.dat_b,t1.dat_b
       ,t2.id_point,t2.kind_energy,t2.id_zone) end as dat_b
   ,case when t2.dat_e>=t1.dat_e then t1.dat_e 
     else t2.dat_e end as dat_e 
 from act_met_kndzn_tbl as t2 inner join 
(select a1.id_point,a2.kind_energy
  ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
  ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e  
 from 
(select distinct e1.id_p_point as id_point,e1.dat_b,e1.dat_e 
 from  
 (select a.id_point,b.dat_b,b.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point) 
  where a.id_client=idcl and b.id_client<>idcl) as e1 
 inner join 
 act_pnt_knd as a2 on (e1.id_point=a2.id_point and a2.dat_b<e1.dat_e 
  and a2.dat_e>e1.dat_b) 
  left join (select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as a4 
     on (a4.id_point=e1.id_point and a4.kind_energy=a2.kind_energy)
inner join 
 act_pnt_share as a3 on (a3.id_point=e1.id_point and a3.dat_b<e1.dat_e 
  and a3.dat_e>e1.dat_b) 
 where share<>0 and a4.id_point is null) as a1 
inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b)) as t1
on (t1.id_point=t2.id_point and t1.kind_energy=t2.kind_energy 
    and t2.dat_b<t1.dat_e and t2.dat_e>t1.dat_b)) as k ;
--  group by id_point,kind_energy,id_zone,dat_b ;

--return false;

----additional insert up points for share calc
-----addcalc for losts on idcl point
Raise Notice ''insert into act_pwr_demand_tbl 3'';
insert into act_pwr_demand_tbl(id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,sum_losts,fact_losts,ident) 
select id_point,kind_energy,id_zone,dat_b,dat_e
   ,ktr_demand,ktr_demand,hand_losts,hand_losts,1 
from (
 select t2.id_point,t2.kind_energy,t2.id_zone,t2.ktr_demand,coalesce(t2.hand_losts,0) as hand_losts
   ,case when mdtb_kndzn(t2.dat_b,t1.dat_b,t2.id_point,t2.kind_energy,t2.id_zone)
    <=t1.dat_b then t1.dat_b else mdtb_kndzn(t2.dat_b,t1.dat_b
       ,t2.id_point,t2.kind_energy,t2.id_zone) end as dat_b
   ,case when t2.dat_e>=t1.dat_e then t1.dat_e 
     else t2.dat_e end as dat_e 
 from act_met_kndzn_tbl as t2 inner join 
(select a1.id_point,a2.kind_energy
  ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
  ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e  
 from 
(select distinct a.id_point,a.dat_b,a.dat_e from act_point_branch_tbl as a  ---***********
   inner join act_desclosts_eqm_tbl as b on (a.id_point=b.id_point)
   where a.id_client<>idcl) as a1 
inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b)) as t1
on (t1.id_point=t2.id_point and t1.kind_energy=t2.kind_energy 
    and t2.dat_b<t1.dat_e and t2.dat_e>t1.dat_b)) as k ;
--  group by id_point,kind_energy,id_zone,dat_b ;
-----addcalc for losts on idcl point

--return false;
Raise Notice ''insert into act_pwr_demand_tbl 4'';
----hand_losts

insert into act_pwr_demand_tbl(id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,sum_losts,fact_losts,ident) 
select id_point,kind_energy,id_zone,dat_b,dat_e
   ,ktr_demand,ktr_demand,hand_losts,hand_losts,1 
from (
 select t2.id_point,t2.kind_energy,t2.id_zone,t2.ktr_demand,coalesce(hand_losts,0) as hand_losts
   ,case when mdtb_kndzn(t2.dat_b,t1.dat_b,t2.id_point,t2.kind_energy,t2.id_zone)
    <=t1.dat_b then t1.dat_b else mdtb_kndzn(t2.dat_b,t1.dat_b
       ,t2.id_point,t2.kind_energy,t2.id_zone) end as dat_b
   ,case when t2.dat_e>=t1.dat_e then t1.dat_e 
     else t2.dat_e end as dat_e 
 from act_met_kndzn_tbl as t2 inner join 
(select a1.id_point,a2.kind_energy
  ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
  ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e 
 from 
-- (select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   (select distinct a.id_point,a.dat_b,a.dat_e from act_point_branch_tbl as a 
   inner join act_pwr_demand_tbl as b on (a.id_p_point=b.id_point) where 
    a.id_client<>idcl) as a1
inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b)) as t1
on (t1.id_point=t2.id_point and t1.kind_energy=t2.kind_energy 
    and t2.dat_b<t1.dat_e and t2.dat_e>t1.dat_b)) as k ;
--  group by id_point,kind_energy,id_zone,dat_b;

update act_pwr_demand_tbl set sum_losts=0,fact_losts=0 where not exists (
  select id_point from act_pnt_hlosts as a 
  where a.id_point=act_pwr_demand_tbl.id_point);


raise notice ''++++hhhhhhhhhhhhh hlosts  demand '';
for test in select *  from act_pwr_demand_tbl    where id_point=278881
 loop
--raise notice ''r.id_point   % r.sum_demand   % r.fact_demand  % '',r.id_point,r.sum_demand,r.fact_demand ;
end loop;
/*
for r in select id_point from act_pnt_hlosts loop
Raise Notice ''h_losts r.id_point - %'',r.id_point;
 rs:=desc_hlosts(r.id_point);
end loop;
*/
----hand_losts

--/*
--=-===========-===============-============-==-=-=-==-=
--если в ходе обработки получили в act_pwr_demand_tbl несколько строчек по одной точке, зоне и енергии
--оставим только одну поправив ей даты 

--return false;
/*Raise Notice ''insert into act_pwr_demand_tbl 444'';

for r in select id_point,kind_energy,id_zone,min(dat_b) as db, max(dat_e) as de  		
 from act_pwr_demand_tbl as pd 
 where ident = 1
 group by id_point,kind_energy,id_zone
 having count(*)>1
loop

 Raise Notice ''act_pwr_demand_tbl 2xpoint - %'',r.id_point;

 update act_pwr_demand_tbl set dat_e = r.de
 where id_point=r.id_point and kind_energy=r.kind_energy and id_zone=r.id_zone and dat_b=r.db;


 delete from act_pwr_demand_tbl
 where id_point = r.id_point and kind_energy = r.kind_energy and id_zone=r.id_zone and dat_b <> r.db;

end loop;
*/
--
--return false; 


for r in select id_point,kind_energy,id_zone,dat_b, dat_e  		
 from act_pwr_demand_tbl as pd  
 where ident = 1  order by id_point,kind_energy,id_zone,dat_b,dat_e
loop
Raise Notice ''zam - %  ............................'',r.id_point;
 for r_1 in select id_point,kind_energy,id_zone,dat_b, dat_e  		
  from act_pwr_demand_tbl as pd 
  where ident = 1 and id_point=r.id_point and kind_energy=r.kind_energy
   and id_zone=r.id_zone and dat_b=r.dat_b  order by id_point,kind_energy,id_zone,dat_b,dat_e
 loop
  Raise Notice ''r.id_point - %  ,%  ,% -'',r.id_point,r.dat_b,r.dat_e;
  Raise Notice ''r1.id_point - %  ,%  ,% -'',r_1.id_point,r_1.dat_b,r_1.dat_e;
--  Raise Notice ''zam Date r - %'',r.dat_e;
 -- Raise Notice ''zam Date r1 - %'',r_1.dat_b;
 --   Raise Notice ''zam Date E r1 - %'',r_1.dat_e;
 update act_pwr_demand_tbl set dat_b=r.dat_e where ident = 1 and id_point=r.id_point and kind_energy=r.kind_energy
 and id_zone=r.id_zone and   dat_e>r.dat_e and dat_b<=r.dat_e;
end loop;

end loop;
--return false;
/*
for r in select id_point,kind_energy,id_zone,dat_b, dat_e  		
 from act_pwr_demand_tbl as pd  
 where ident = 1  order by id_point,kind_energy,id_zone,dat_b,dat_e
loop
Raise Notice ''zam - %  ............................'',r.id_point;
 for r_1 in select id_point,kind_energy,id_zone,dat_b, dat_e  		
  from act_pwr_demand_tbl as pd 
  where ident = 1 and id_point=r.id_point and kind_energy=r.kind_energy
   and id_zone=r.id_zone and dat_b=r.dat_b  order by id_point,kind_energy,id_zone,dat_b,dat_e
 loop
  Raise Notice ''r.id_point - %  ,%  ,% -'',r.id_point,r.dat_b,r.dat_e;
  Raise Notice ''r1.id_point - %  ,%  ,% -'',r_1.id_point,r_1.dat_b,r_1.dat_e;
--  Raise Notice ''zam Date r - %'',r.dat_e;
 -- Raise Notice ''zam Date r1 - %'',r_1.dat_b;
 --   Raise Notice ''zam Date E r1 - %'',r_1.dat_e;
  update act_pwr_demand_tbl set dat_b=r.dat_e+1 where ident = 1 and id_point=r.id_point and kind_energy=r.kind_energy
   and id_zone=r.id_zone and   dat_e>r.dat_e and dat_b<=r.dat_e;
end loop;

end loop;
 */




--//*
--=-===========-===============-============-==-=-=-==-=
--если в ходе обработки получили в act_pwr_demand_tbl несколько строчек по одной точке, зоне и енергии
--оставим только одну поправив ей даты 
--return false;
Raise Notice ''insert into act_pwr_demand_tbl 444'';

for r in select id_point,kind_energy,id_zone,
 sum_demand,fact_demand,sum_losts,fact_losts,min(dat_b) as db, max(dat_e) as de  		
 from act_pwr_demand_tbl as pd 
 where (ident = 1 )
 group by id_point,kind_energy,id_zone,sum_demand,fact_demand,sum_losts,fact_losts
 having count(*)>1
loop

 Raise Notice ''act_pwr_demand_tbl 2xpoint - %'',r.id_point;

 update act_pwr_demand_tbl set dat_e = r.de
 where id_point=r.id_point and kind_energy=r.kind_energy 
and id_zone=r.id_zone and dat_b=r.db;


 delete from act_pwr_demand_tbl
 where id_point = r.id_point and kind_energy = r.kind_energy and id_zone=r.id_zone 
  and dat_b <> r.db and dat_e=r.de;


end loop;



update act_pwr_demand_tbl set id_bill=-1;

insert into act_pwr_demand_tbl(id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,sum_losts,fact_losts,ident) 
select distinct id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,sum_losts,fact_losts,ident from act_pwr_demand_tbl;

delete from act_pwr_demand_tbl where id_bill=-1;


raise notice ''111111123088_2'';
for r in select id_point 		
 from act_pwr_demand_tbl  
 where id_point=100714
 loop
raise notice ''100714'';
end loop;

  
--return false;

Raise Notice ''insert into act_pwr_demand_tbl 4 222'';
------- fact_demand for two different parents
               /*
insert into act_2point_branch_tbl (id_2point) 
select dictinct id_2point from act_2point_branch_tbl;

*/
/*

---------------------------------------------------------------------------------------------
    
update act_pwr_demand_tbl set doubl2_demand=d_dem  ,
 fact_demand=fact_demand-k.s_dem,
 fact_demand=k.s_dem
from 
(select l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b 
  -- ,sum(round(desc_sdem*round(l3.sum_demand::numeric/(case when  sum_dem=0 then desc_sdem else sum_dem end),2),0)) as s_dem,
  -- sum(round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/(case when  sum_dem=0 then desc_sdem else sum_dem end),2),0)) as d_dem  
  ,sum(case when sum_dem<>0 then round(desc_sdem*round(l3.sum_demand::numeric/sum_dem,2),0) else desc_sdem end)  as s_dem,
   sum(case when sum_dem<>0 then round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/sum_dem,2),0) else 0 end) as d_dem 
 from 
--суммарное потребление по обоим предкам
 (select k1.id_point,sum(k2.sum_demand) as sum_dem,k2.kind_energy 
  from 
    (select a.id_point,b.id_p_point,b.dat_b,b.dat_e 
     from 
       (select count(*),id_point from act_point_branch_tbl  -- where id_client=idcl 
        group by id_point 
        having count(*)>1
       ) as a 
       inner join act_point_branch_tbl as b  on (a.id_point=b.id_point)
     ) as k1
     join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
          and k2.dat_b<k1.dat_e and k2.dat_e>k1.dat_b) 
     where k2.ident=1 
     group by k1.id_point,k2.kind_energy
 ) as l1
 inner join 
 -- потребление дубля
 (select k1.id_point,k2.kind_energy,coalesce(sum(k2.sum_demand),0) as desc_sdem,
  from 
   (select count(*),id_point from act_point_branch_tbl 
     group by id_point 
     having count(*)>1) as k1
   join act_pwr_demand_tbl as k2 on (k1.id_point=k2.id_point) where k2.ident=1
   group by k1.id_point,k2.kind_energy

) as l2  on (l1.id_point=l2.id_point and l1.kind_energy=l2.kind_energy)

inner join 
-- потребление каждого предка
(
select k1.id_point,k1.id_p_point,k2.kind_energy,k2.id_zone,k2.dat_b 
  ,k2.sum_demand
 from 
(select id_point,id_p_point,dat_b,dat_e from
 act_2point_branch_tbl
  ) as k1
  join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
 and k2.dat_b<=k1.dat_e and k2.dat_e>=k1.dat_b
) where k2.ident=1 order by k1.id_point,k1.id_p_point
````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````) as l3 on (l3.id_point=l1.id_point and l3.kind_energy=l1.kind_energy)

 group by l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b) as k  

where k.id_p_point=act_pwr_demand_tbl.id_point 
  and k.kind_energy=act_pwr_demand_tbl.kind_energy  
  and k.id_zone=act_pwr_demand_tbl.id_zone 
  and k.dat_b=act_pwr_demand_tbl.dat_b 
  and act_pwr_demand_tbl.ident=1;   
  
*/
-------------------------------------------------------------------------  
------- fact_demand for two different parents

  /*

update act_pwr_demand_tbl set doubl2_demand=d_dem ,
 fact_demand=fact_demand-k.s_dem
--, fact_demand=k.s_dem
from 
(select l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b 
  -- ,sum(round(desc_sdem*round(l3.sum_demand::numeric/(case when  sum_dem=0 then desc_sdem else sum_dem end),2),0)) as s_dem,
  -- sum(round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/(case when  sum_dem=0 then desc_sdem else sum_dem end),2),0)) as d_dem  
  ,sum(case when sum_dem<>0 then round(desc_sdem*round(l3.sum_demand::numeric/sum_dem,2),0) else desc_sdem end)  as s_dem,
   sum(case when sum_dem<>0 then round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/sum_dem,2),0) else 0 end) as d_dem 
 from 
--суммарное потребление по обоим предкам
 (  select p.id_p_point as id_point,kind_energy,sum(d.sum_demand)  as sum_dem
    from act_pwr_demand_tbl d,act_2point_branch_tbl p 
    where d.id_point=p.id_p_point and p.id_point is null 
    group by p.id_p_point,kind_energy
 ) as l1
 inner join 
 -- потребление дубля
 (SELECT P.id_P_point as id_point,kind_energy,sum(d.sum_demand) as desc_sdem
    from act_pwr_demand_tbl d,act_2point_branch_tbl p 
    where d.id_point=p.id_point and p.id_point is not null 
    group by P.id_P_point,kind_energy  ) as l2  
on (l1.id_point=l2.id_point and l1.kind_energy=l2.kind_energy)

inner join 
-- потребление каждого предка
(select k1.id_point,k1.id_p_point,k2.kind_energy,k2.id_zone,k2.dat_b 
  ,k2.sum_demand
 from 
(select id_point,id_p_point,dat_b,dat_e from
 act_2point_branch_tbl
  ) as k1
  join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
 and k2.dat_b<=k1.dat_e and k2.dat_e>=k1.dat_b
) where k2.ident=1 order by k1.id_point,k1.id_p_point) as l3 on (l3.id_point=l1.id_point and l3.kind_energy=l1.kind_energy)

 group by l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b) as k  

where k.id_p_point=act_pwr_demand_tbl.id_point 
  and k.kind_energy=act_pwr_demand_tbl.kind_energy  
  and k.id_zone=act_pwr_demand_tbl.id_zone 
 -- and k.dat_b=act_pwr_demand_tbl.dat_b 
  and act_pwr_demand_tbl.ident=1;   

    */
/*
update act_pwr_demand_tbl set doubl2_demand=d_dem  ,
 fact_demand=fact_demand-k.s_dem
from 
(select l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b 
,sum(case when sum_dem<>0 then round(desc_sdem*round(l3.sum_demand::numeric/sum_dem,2),0) else desc_sdem end)  as s_dem,
 sum(case when sum_dem<>0 then round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/sum_dem,2),0) else 0 end) as d_dem 
from 
--суммарное потребление по обоим предкам
(select k1.id_point,sum(k2.sum_demand) as sum_dem,k2.kind_energy 
 from 
(select a.id_point,b.id_p_point,b.dat_b,b.dat_e from 
 (select count(*),id_point from act_point_branch_tbl  -- where id_client=idcl 
group by id_point 
   having count(*)>1) as a inner join act_point_branch_tbl as b 
   on (a.id_point=b.id_point)) as k1
   join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
  and k2.dat_b<k1.dat_e --and k2.dat_e>k1.dat_b
) 
  where k2.ident=1 
  group by k1.id_point,k2.kind_energy

) as l1

inner join 
-- потребление дубля
(select k1.id_point,coalesce(sum(k2.sum_demand),0) as desc_sdem,k2.kind_energy from 

  (select count(*),id_point from act_point_branch_tbl 
   group by id_point 
   having count(*)>1) as k1
   join act_pwr_demand_tbl as k2 on (k1.id_point=k2.id_point) where k2.ident=1
   group by k1.id_point,k2.kind_energy

) as l2  on (l1.id_point=l2.id_point and l1.kind_energy=l2.kind_energy)

inner join 
-- потребление каждого предка
(select k1.id_point,k1.id_p_point,k2.kind_energy,k2.id_zone,k2.dat_b 
  ,k2.sum_demand
 from 
(select a.id_point,b.id_p_point,b.dat_b,b.dat_e from 
 (select count(*),id_point from act_point_branch_tbl group by id_point 
   having count(*)>1) as a inner join act_point_branch_tbl as b 
   on (a.id_point=b.id_point)) as k1
  join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
  and k2.dat_b<k1.dat_e --and k2.dat_e>k1.dat_b
 ) where k2.ident=1

) as l3 on (l3.id_point=l1.id_point and l3.kind_energy=l1.kind_energy)

 group by l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b) as k  

where k.id_p_point=act_pwr_demand_tbl.id_point 
  and k.kind_energy=act_pwr_demand_tbl.kind_energy  
  and k.id_zone=act_pwr_demand_tbl.id_zone 
  and k.dat_b=act_pwr_demand_tbl.dat_b 
  and act_pwr_demand_tbl.ident=1;   
*/

raise notice ''  calc demand double2demand ++++++++++++++++++++'';

update act_pwr_demand_tbl set doubl2_demand=d_dem  ,
 fact_demand=fact_demand-k.s_dem
from 
(

select l3.id_p_point,l3.dat_b,l3.kind_energy,l3.id_zone--,l3.dat_b,l1.*,l2.*,l3.*
--,(case when sum_dem<>0 then round(desc_sdem*round(l3.sum_demand::numeric/sum_dem,2),0) else desc_sdem end)  as s_dem,
--(case when sum_dem<>0 then round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/sum_dem,2),0) else 0 end) as d_dem 
 
--,sum(case when sum_dem<>0 then round(desc_sdem*round(l3.sum_demand::numeric/sum_dem,2),0) else desc_sdem end)  as s_dem,
-- sum(case when sum_dem<>0 then round(desc_sdem*round((sum_dem-l3.sum_demand)::numeric/sum_dem,2),0) else 0 end) as d_dem 

,round(sum(case when sum_dem<>0 then (desc_sdem*(l3.sum_demand::numeric/sum_dem)) else desc_sdem end),0)  as s_dem,
 round(sum(case when sum_dem<>0 then (desc_sdem*((sum_dem-l3.sum_demand)::numeric/sum_dem)) else 0 end),0) as d_dem 

from 
--суммарное потребление по обоим предкам
(
select d2.id_point,d1.dat_b,d1.dat_e,
 sum(d1.sum_demand) as sum_dem,
 kind_energy 
 from act_pwr_demand_tbl d1, act_2point_branch_tbl d2 
where d1.id_point=d2.id_p_point and d2.id_p_point is not null 
group by d2.id_point,d1.dat_b,d1.dat_e,kind_energy
order by d2.id_point,dat_b

) as l1

inner join 
-- потребление дубля
(
 select d1.id_point,d1.dat_b,d1.dat_e,
  sum(d1.sum_demand) as desc_sdem,
  kind_energy 
 from act_pwr_demand_tbl d1, 
  (select distinct id_point from act_2point_branch_tbl) d2 
 where d1.id_point=d2.id_point   
 group by d1.id_point,d1.dat_b,d1.dat_e,kind_energy
 order by d1.id_point,d1.dat_b

) as l2  on (l1.id_point=l2.id_point and l1.kind_energy=l2.kind_energy and 
l1.dat_b=l2.dat_b  and l1.dat_e=l2.dat_e)

inner join 
-- потребление каждого предка
(
select d2.id_point ,d1.id_point as id_p_point,d1.dat_b,d1.dat_e,
 d1.sum_demand, kind_energy,id_zone 
 from act_pwr_demand_tbl d1, 
 (select distinct id_point,id_p_point from act_2point_branch_tbl) d2 
where d1.id_point=d2.id_p_point    
order by d1.id_point,d2.id_point,d1.dat_b

) as l3 on (l3.id_point=l1.id_point and l3.kind_energy=l1.kind_energy and l3.dat_b=l1.dat_b and l3.dat_e=l1.dat_e)

 group by l3.id_p_point,l3.kind_energy,l3.id_zone,l3.dat_b
                                                               
 ) as k  

where k.id_p_point=act_pwr_demand_tbl.id_point 
  and k.kind_energy=act_pwr_demand_tbl.kind_energy  
  and k.id_zone=act_pwr_demand_tbl.id_zone 
  and k.dat_b=act_pwr_demand_tbl.dat_b 
  and act_pwr_demand_tbl.ident=1;   


                                 
for rek_d in select id_p_point,dat_b,dat_e,kind_energy,sum(coalesce(sum_demand,0)) as sum_demand 
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)
 left join 
 (select count(*),id_point from act_point_branch_tbl group by id_point 
   having count(*)>1) as c  on (a.id_point=c.id_point) 
   where c.id_point is null) as a1  
inner join 
(select * from act_pwr_demand_tbl where ident=1) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy order by id_p_point,kind_energy,id_p_point 
loop

raise notice ''000000000000000000000 minus double cirk  id_p_point - %   %   %   %'',rek_d.id_p_point,rek_d.dat_b,rek_d.dat_e, rek_d.sum_demand;

update act_pwr_demand_tbl set fact_demand=fact_demand-rek_d.sum_demand
where  act_pwr_demand_tbl.id_point=rek_d.id_p_point 
   and act_pwr_demand_tbl.kind_energy=rek_d.kind_energy 
   and act_pwr_demand_tbl.dat_b<=rek_d.dat_b --??? <=
   and act_pwr_demand_tbl.dat_e>=rek_d.dat_e --??? >=
   and act_pwr_demand_tbl.ident=1 
   and act_pwr_demand_tbl.id_zone=0;

end loop;

--return 0;
 
-- osa 2009-03-31  нЕ В?ЧИТАЛИСЬ стар?е дубли при вкл нов?х в середине периода
/*    
Raise Notice ''insert into act_pwr_demand_tbl 4   333'';
update act_pwr_demand_tbl set fact_demand=fact_demand-k1.sum_demand
from  
(select id_p_point,dat_b,dat_e,kind_energy,sum(coalesce(sum_demand,0)) as sum_demand 
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)
 left join 
 (select count(*),id_point from act_point_branch_tbl group by id_point 
   having count(*)>1) as c  on (a.id_point=c.id_point) 
   where c.id_point is null) as a1  
inner join 
(select * from act_pwr_demand_tbl where ident=1) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy) as k1  
 where  act_pwr_demand_tbl.id_point=k1.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k1.kind_energy 
   and act_pwr_demand_tbl.dat_b<=k1.dat_b --??? <=
   and act_pwr_demand_tbl.dat_e>=k1.dat_e --??? >=
   and act_pwr_demand_tbl.ident=1 
   and act_pwr_demand_tbl.id_zone=0;
*/

update act_pwr_demand_tbl set fact_demand=fact_demand-k1.sum_demand 
from  
(select id_p_point,dat_b,dat_e,kind_energy,id_zone,sum(sum_demand) as sum_demand 
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy,a2.id_zone  
from 
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)
 left join 
 (select count(*),id_point from act_point_branch_tbl group by id_point 
   having count(*)>1) as c  on (a.id_point=c.id_point) 
   where c.id_point is null) as a1  
inner join 
(select * from act_pwr_demand_tbl where ident=1 and id_zone<>0) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy,id_zone) as k1  
 where  act_pwr_demand_tbl.id_point=k1.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k1.kind_energy 
   and act_pwr_demand_tbl.dat_b<=k1.dat_b --??? <=
   and act_pwr_demand_tbl.dat_e>=k1.dat_e --??? >=
   and act_pwr_demand_tbl.ident=1 
   and act_pwr_demand_tbl.id_zone=k1.id_zone;



--- for diftarif
raise notice ''%    %'',dtb,dte ;
--return false;
insert into act_difmetzone_tbl 
 (id_point_p,zone_p,id_point,zone,kind_energy,dt_b,dt_e,percent,demand_p)
 select distinct dp.id_p_point,dp.zone_p,dp.id_point,dp.zone,dp.kind_energy,
           coalesce(pwr1.dat_b,dp.dt_b),coalesce(pwr1.dat_e,dp.dt_e),dp.percent,pwr1.fact_demand from 
 (   select pp.id_p_point,dif.zone_p,dif.id_point,dif.zone,dif.kind_energy,
           dif.dt_b,
     dif.dt_e,dif.percent
     from 
       (select m.id_point,d.* from acd_inddifzone_tbl d, act_meter_pnt_tbl m 
        where 
          m.id_meter=d.id_meter and 
       (coalesce(dt_b,dtb) between dtb-interval ''1 day'' and dte- interval ''1 day'') and 
         (coalesce(dt_e,dte) between dtb - interval ''1 day'' and dte - interval ''1 day'')
       ) as dif
     left join
       (select  p1.id_point as id_p_point,p2.id_point, 
         case when p1.dat_b<=p2.dat_b then p2.dat_b else p1.dat_b end as dat_b,
         case when p1.dat_b<=p2.dat_b then p2.dat_b else p1.dat_b end as dat_b
        from act_point_branch_tbl p1 
        left join act_point_branch_tbl p2 
        on p1.id_point=p2.id_p_point  where p1.id_point is not null   
       ) as pp 
      on (pp.id_point=dif.id_point --and pp.id_p_point=dif.id_point_p 
          ) 
 ) as dp 
 left join
  ( select * from act_pwr_demand_tbl ) pwr1 
  on (dp.id_p_point =pwr1.id_point and dp.kind_energy=pwr1.kind_energy
      and dp.zone_p=pwr1.id_zone)
;
          
/*   
update act_difmetzone_tbl set percent=(percent/countz) 
from  ( select id_point,kind_energy,id_zone,count(*)  as countz
    from act_pwr_demand_tbl  group by  id_point,kind_energy,id_zone
  ) as d

  where act_difmetzone_tbl.id_point=d.id_point 
    and act_difmetzone_tbl.kind_energy=d.kind_energy 
    and act_difmetzone_tbl.zone=d.id_zone   ;

*/
            
-- замена дает 2 строки
for test in     select * from  act_difmetzone_tbl loop
raise notice '' ---test  % % % % % %'', test.id_point,test.dt_b,test.dt_e,test.demand_p,test.demand_calc,test.fact_demand_p;
update act_difmetzone_tbl set 
  demand_calc=coalesce(round(d.fact_demand*percent/100,0),0),
 fact_demand_p=coalesce(demand_p,0)-round(coalesce(d.fact_demand,0)*percent/100,0)
-- demand_do=demand_p
  from 
  ( select id_point,kind_energy,id_zone,dat_b,dat_e,sum(fact_demand)  as fact_demand
    from act_pwr_demand_tbl  where dat_b>=test.dt_b and dat_e<=test.dt_e 
     group by  id_point,kind_energy,id_zone,dat_b,dat_e
  ) as d
  where act_difmetzone_tbl.id_point=d.id_point 
    and act_difmetzone_tbl.kind_energy=d.kind_energy 
    and act_difmetzone_tbl.zone=d.id_zone
-- and act_difmetzone_tbl.dt_b<=d.dat_b and act_difmetzone_tbl.dt_e>=d.dat_e 
 and test.id_point=act_difmetzone_tbl.id_point

;        

for test_difm in   select * from  act_difmetzone_tbl where kind_energy=1 loop
raise notice '' test_difm  % % % % % %'', test_difm.id_point,test_difm.dt_b,test_difm.dt_e,test_difm.demand_p,test_difm.demand_calc,test_difm.fact_demand_p;

end loop;

end loop;



for test in select id_point_p,zone_p,id_point,zone,kind_energy,dt_e,count(*)
  from act_difmetzone_tbl group by id_point_p,zone_p,id_point,zone,kind_energy,dt_e 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_difmet'',100,525,''d_difmet'');
   insert into act_res_notice 
   values(''Double in table act_difmetzone_tbl'');

 return false;
end loop;

  
for test in select * from  act_pwr_demand_tbl loop 

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

end loop;



--return false;

-------for zone 4,5
update act_pwr_demand_tbl set fact_demand=fact_demand-k1.sum_demand 
from  
(select id_p_point,dat_b,dat_e,kind_energy,sum(sum_demand) as sum_demand 
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)
 left join 
 (select count(*),id_point from act_point_branch_tbl group by id_point 
   having count(*)>1) as c  on (a.id_point=c.id_point) 
   where c.id_point is null) as a1  
inner join 
(select * from act_pwr_demand_tbl where ident=1 and id_zone=4) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy) as k1  
 where  act_pwr_demand_tbl.id_point=k1.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k1.kind_energy 
   and act_pwr_demand_tbl.dat_b=k1.dat_b --??? <=
   and act_pwr_demand_tbl.dat_e=k1.dat_e --??? >=
   and act_pwr_demand_tbl.ident=1 
   and act_pwr_demand_tbl.id_zone=5;
-------for zone 4,5

/*
update act_pwr_demand_tbl 
  set fact_demand=round((fact_demand::numeric/k13.sum_dem)*
  (k13.sum_dem-k13.sum_demand),0) 
from
(select k1.id_p_point,k1.kind_energy,k1.dat_b,k1.dat_e,k1.sum_demand,k2.sum_dem 
from 
(select k12.id_point,k12.dat_b,k12.dat_e,k12.kind_energy,sum(k12.fact_demand) 
  as sum_dem
 from 
(select a.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e
   ,a.kind_energy,a.fact_demand
  from act_pwr_demand_tbl as a inner join (select distinct id_p_point,dat_b,dat_e  
      from act_point_branch_tbl) as b on (a.id_point=b.id_p_point 
   and a.dat_b<b.dat_e and a.dat_e>b.dat_b) where a.id_zone<>0 
    and ident=1) as k12 
  group by k12.id_point,k12.dat_b,k12.dat_e,k12.kind_energy) as k2  
inner join 
(select id_p_point,dat_b,dat_e,kind_energy,sum(sum_demand) as sum_demand 
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)
 left join 
 (select count(*),id_point from act_point_branch_tbl group by id_point 
   having count(*)>1) as c  on (a.id_point=c.id_point) 
   where c.id_point is null) as a1 
inner join 
(select * from act_pwr_demand_tbl where ident=1) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy) as k1  
on (k1.id_p_point=k2.id_point and k1.kind_energy=k2.kind_energy 
     and k1.dat_b=k2.dat_b and k1.dat_e=k2.dat_e)) as k13
 where  act_pwr_demand_tbl.id_point=k13.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k13.kind_energy 
   and act_pwr_demand_tbl.dat_b=k13.dat_b 
   and act_pwr_demand_tbl.dat_e=k13.dat_e 
   and act_pwr_demand_tbl.ident=1 
   and act_pwr_demand_tbl.id_zone<>0;
*/

-----check summ


--return false;
update act_pwr_demand_tbl set fact_demand=0 where  
ident=1 and kind_energy <>1 and fact_demand<0;


--select into cnt count(*) from act_pwr_demand_tbl where 
--ident=1 and kind_energy =1 and fact_demand<0;
select into cnt count(*) from act_pwr_demand_tbl d
,act_point_branch_tbl b 
where 
ident=1 and kind_energy =1 and fact_demand<0 
and b.id_point=d.id_point and id_client=idcl
;
 if cnt>0 then
   Raise Notice ''Double>Main''; 
   insert into act_res_notice select ''Т. у. - ''||a.id_point||'',''
    ||coalesce(b.name_eqp,''нет в текущей схеме (только в истории)'')||
    ''  клиент - ''||c1.id_client||'',''||c.code 
    from act_pwr_demand_tbl as a inner join eqm_equipment_tbl as b  
    on (a.id_point=b.id) 
    inner join act_point_branch_tbl as c1 on (a.id_point=c1.id_point)
    inner join clm_client_tbl as c on (c1.id_client=c.id) where a.ident=1 
    and a.fact_demand<0;
   insert into act_res_notice values(''Double>Main'');
   insert into sys_error_tmp (nam,res,id_error,ident) values 
    (''dubl>m'',100,506,''dubl>m'');

   Return false;
 end if;
-----check summ

raise notice '' divide tarif   %    %'',dtb,dte ;
insert into act_pwr_demand_tbl(id_point,kind_energy,id_zone,dat_b,dat_e
 ,sum_demand,fact_demand,ident) 
select distinct k1.id_point,k1.kind_energy,k1.id_zone
  ,case when k1.dat_b<=k2.dat_b then k2.dat_b else k1.dat_b end as dat_b
  ,case when k1.dat_e>=k2.dat_e then k2.dat_e else k1.dat_e end as dat_e
  ,round(k2.fact_demand::numeric*(k1.share::numeric/100.00000),0)
  ,round(k2.fact_demand::numeric*(k1.share::numeric/100.00000),0)
  ,6 
from 
(select a1.id_p_point,a1.id_point,a1.dat_b,a1.dat_e,a2.kind_energy
  ,a3.id_zone,round(a3.share*date_mi(a3.dat_e,a3.dat_b),5) as share
from  
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)) as a1 
 inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b) 
  left join (select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as a4 
     on (a4.id_point=a1.id_point and a4.kind_energy=a2.kind_energy)
inner join 
 (select e1.id_point,e1.share::numeric
       /case when date_mi(e1.dat_e,e1.dat_b)<>0  then date_mi(e1.dat_e,e1.dat_b) else 1 end
       as share
   ,e1.id_zone
   ,case when e1.dat_b<=e2.dat_b then e2.dat_b else e1.dat_b end as dat_b 
   ,case when e1.dat_e>=e2.dat_e then e2.dat_e else e1.dat_e end as dat_e 
 from act_pnt_share as e1 inner join act_point_branch_tbl as e3 
  on (e1.id_point=e3.id_point)
  left join act_warm_period as e2 
  on (e3.id_client=e2.id_client and e2.dat_b<e1.dat_e and e2.dat_e>e1.dat_b)
   where e1.id_zone not in (4,5) or (e1.id_zone in (4,5) 
    and e2.id_client is not null)
  ) as a3 on (a3.id_point=a1.id_point and a3.dat_b<a1.dat_e 
  and a3.dat_e>a1.dat_b) 
 where share<>0 and a4.id_point is null) as k1 
 inner join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
  and k1.kind_energy=k2.kind_energy and k1.dat_b<k2.dat_e and k1.dat_e>k2.dat_b);

for test in select id_point,kind_energy,dat_b,id_zone,count(*)
  from act_pwr_demand_tbl group by id_point,kind_energy,dat_b,id_zone 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_pwrdem'',100,521,''d_pwrdem'');
   insert into act_res_notice 
   values(''Double in table act_pwr_demand_tbl'');

 return false;
end loop;


raise notice '' divide tarif2   %    %'',dtb,dte ;
update act_pwr_demand_tbl set fact_demand=fact_demand-k1.sum_demand 
from  
(select id_p_point,dat_b,dat_e,kind_energy,sum(sum_demand) as sum_demand
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)) as a1 
inner join 
(select * from act_pwr_demand_tbl where ident=6) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy) as k1  
 where  act_pwr_demand_tbl.id_point=k1.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k1.kind_energy 
   and act_pwr_demand_tbl.dat_b=k1.dat_b 
   and act_pwr_demand_tbl.dat_e=k1.dat_e ;


update act_pwr_demand_tbl set sum_demand=sum_demand+k3.f_dem
 ,fact_demand=fact_demand+k3.f_dem
from 
(select k1.id_p_point,k4.id_p
  ,case when k1.dat_b<=k2.dat_b then k2.dat_b else k1.dat_b end as dat_b
  ,case when k1.dat_e>=k2.dat_e then k2.dat_e else k1.dat_e end as dat_e
  ,k1.kind_energy,k2.fact_demand as f_dem,k1.share
from 
(select a1.id_p_point,a1.dat_b,a1.dat_e,a2.kind_energy
  ,sum(round(a3.share*date_mi(a3.dat_e,a3.dat_b),0)) as share 
from  
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)) as a1 
 inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b) 
  left join (select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as a4 
     on (a4.id_point=a1.id_point and a4.kind_energy=a2.kind_energy)
inner join 
  (select e1.id_point,e1.share::numeric/case when date_mi(e1.dat_e,e1.dat_b)<>0  then date_mi(e1.dat_e,e1.dat_b) else 1 end
     as share,e1.id_zone
   ,case when e1.dat_b<=e2.dat_b then e2.dat_b else e1.dat_b end as dat_b 
   ,case when e1.dat_e>=e2.dat_e then e2.dat_e else e1.dat_e end as dat_e 
 from act_pnt_share as e1 inner join act_point_branch_tbl as e3 
  on (e1.id_point=e3.id_point)
  left join act_warm_period as e2 
  on (e3.id_client=e2.id_client and e2.dat_b<e1.dat_e and e2.dat_e>e1.dat_b)
   where e1.id_zone not in (4,5) or (e1.id_zone in (4,5) 
    and e2.id_client is not null)
  ) as a3 on (a3.id_point=a1.id_point and a3.dat_b<a1.dat_e 
  and a3.dat_e>a1.dat_b) 
 where share<>0 and a4.id_point is null 
  group by a1.id_p_point,a1.dat_b,a1.dat_e,a2.kind_energy) as k1 
 inner join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
  and k1.kind_energy=k2.kind_energy and k1.dat_b<k2.dat_e 
  and k1.dat_e>k2.dat_b) inner join 
   (select a1.id_p_point,max(a2.id_point) as id_p,a2.kind_energy from act_point_branch_tbl as a1 
    inner join act_pwr_demand_tbl as a2 on (a1.id_point=a2.id_point) 
     where a2.ident=6 and a1.id_p_point is not null 
      group by a1.id_p_point,a2.kind_energy)
   as k4 on (k4.id_p_point=k2.id_point and k4.kind_energy=k2.kind_energy) 
  where k1.share=100 and k2.fact_demand<>0) as k3 
 where act_pwr_demand_tbl.id_point=k3.id_p 
   and act_pwr_demand_tbl.kind_energy=k3.kind_energy 
   and act_pwr_demand_tbl.dat_b=k3.dat_b and act_pwr_demand_tbl.dat_e=k3.dat_e;

update act_pwr_demand_tbl set fact_demand=0
from 
(select k1.id_p_point
  ,case when k1.dat_b<=k2.dat_b then k2.dat_b else k1.dat_b end as dat_b
  ,case when k1.dat_e>=k2.dat_e then k2.dat_e else k1.dat_e end as dat_e
  ,k1.kind_energy,k2.fact_demand,k1.share
from 
(select a1.id_p_point,a1.dat_b,a1.dat_e,a2.kind_energy
  ,sum(round(a3.share*date_mi(a3.dat_e,a3.dat_b),0)) as share 
from  
(select distinct a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)) as a1 
 inner join 
 act_pnt_knd as a2 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e 
  and a2.dat_e>a1.dat_b) 
  left join (select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as a4 
     on (a4.id_point=a1.id_point and a4.kind_energy=a2.kind_energy)
inner join 
  (select e1.id_point,e1.share::numeric/case when date_mi(e1.dat_e,e1.dat_b)<>0  then date_mi(e1.dat_e,e1.dat_b) else 1 end
   as share,e1.id_zone
   ,case when e1.dat_b<=e2.dat_b then e2.dat_b else e1.dat_b end as dat_b 
   ,case when e1.dat_e>=e2.dat_e then e2.dat_e else e1.dat_e end as dat_e 
  from act_pnt_share as e1 inner join act_point_branch_tbl as e3 
  on (e1.id_point=e3.id_point)
  left join act_warm_period as e2 
  on (e3.id_client=e2.id_client and e2.dat_b<e1.dat_e and e2.dat_e>e1.dat_b)
   where e1.id_zone not in (4,5) or (e1.id_zone in (4,5) 
    and e2.id_client is not null)
  ) as a3 on (a3.id_point=a1.id_point and a3.dat_b<a1.dat_e 
  and a3.dat_e>a1.dat_b) 
 where share<>0 and a4.id_point is null 
  group by a1.id_p_point,a1.dat_b,a1.dat_e,a2.kind_energy) as k1 
 inner join act_pwr_demand_tbl as k2 on (k1.id_p_point=k2.id_point 
  and k1.kind_energy=k2.kind_energy and k1.dat_b<k2.dat_e 
  and k1.dat_e>k2.dat_b) 
  where k1.share=100 and k2.fact_demand<>0) as k3 
 where act_pwr_demand_tbl.id_point=k3.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k3.kind_energy 
   and act_pwr_demand_tbl.dat_b=k3.dat_b and act_pwr_demand_tbl.dat_e=k3.dat_e;
-----------no meter calcs
------knde=2
insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,sum_demand,fact_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(c.pwr),sum(c.pwr),4 
from 
(select a.id_point,a.kind_energy,a.dat_b,a.dat_e from 
(select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=2) as a
left join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy)
 where b.id_point is null) as b
inner join
  (select e.id_point,f.dat_b,f.dat_e
  ,round(pwr*date_mi(e.dat_e,e.dat_b)*tg,0) as pwr
  -- ,round(pwr*date_mi(min(f.dat_e,e.dat_e)::date,min(f.dat_b,e.dat_b)::date)*tg,0) as pwr
   --     ,round(pwr*date_mi(f.dat_e::date,f.dat_b::date)*tg,0) as pwr
       from 
       (select id_point
--        ,fact_demand/date_mi(dat_e::date,dat_b::date)::numeric as pwr
--change made 07.09.2005 according to ch. 5.5 of metodica for RE
        ,sum_demand/case when date_mi(dat_e::date,dat_b::date)::numeric<>0  then date_mi(dat_e::date,dat_b::date)::numeric else 1 end
           as pwr
        ,dat_b,dat_e 
       from act_pwr_demand_tbl where kind_energy=1) as e
       inner Join
       (select id_point,value_r as tg,dat_b,dat_e from act_pnt_tg,eqk_tg_tbl 
          where act_pnt_tg.id_tg=eqk_tg_tbl.id) as f
       on (e.id_point=f.id_point and e.dat_b<f.dat_e and e.dat_e>f.dat_b)
      ) as c 
     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;

update act_pwr_demand_tbl set fact_demand=fact_demand-k1.sum_demand 
from  
(select id_p_point,dat_b,dat_e,kind_energy,sum(sum_demand) as sum_demand
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)) as a1 
inner join 
(select * from act_pwr_demand_tbl where ident=4) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy) as k1  
 where  act_pwr_demand_tbl.id_point=k1.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k1.kind_energy 
   and act_pwr_demand_tbl.dat_b=k1.dat_b 
   and act_pwr_demand_tbl.dat_e=k1.dat_e and act_pwr_demand_tbl.ident<>4;

update act_pwr_demand_tbl set fact_demand=0 
  where kind_energy=2 and fact_demand<0 and ident<>4;

--return false;

Raise Notice ''act_pwr_demand_tbl 2xpoint 44444444441- %'',r.id_point;
for r in select id_point,kind_energy,id_zone,
 sum_demand,fact_demand,min(dat_b) as db, max(dat_e) as de  		
 from act_pwr_demand_tbl as pd 
 where (ident = 4 )
 group by id_point,kind_energy,id_zone,sum_demand,fact_demand
 having count(*)>1
loop

 Raise Notice ''act_pwr_demand_tbl 2xpoint 4444444444- %'',r.id_point;

 update act_pwr_demand_tbl set dat_e = r.de
 where id_point=r.id_point and kind_energy=r.kind_energy 
and id_zone=r.id_zone and dat_b=r.db;


 delete from act_pwr_demand_tbl
 where id_point = r.id_point and kind_energy = r.kind_energy and id_zone=r.id_zone 
  and dat_b <> r.db and dat_e=r.de;

end loop;


-----knde=1

 insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,fact_demand,sum_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(round(c.ldemand::numeric/c.pdays*case when date_mi(b.dat_e,b.dat_b)<>0  then date_mi(b.dat_e,b.dat_b) else 1 end,0))
     ,sum(round(c.ldemand::numeric/c.pdays*case when date_mi(b.dat_e,b.dat_b)<>0  then date_mi(b.dat_e,b.dat_b) else 1 end,0)),3 
   from 
(select a.id_point,a.kind_energy  
   ,case when (a.dat_b<coalesce(b.dat_b,a.dat_b) and a.dat_e=coalesce(b.dat_e,a.dat_e))  
    then a.dat_b 
    when (a.dat_b=coalesce(b.dat_b,a.dat_b) and a.dat_e>coalesce(b.dat_e,a.dat_e))
    then b.dat_e end as dat_b  
   ,case when (a.dat_b<coalesce(b.dat_b,a.dat_b) and a.dat_e=coalesce(b.dat_e,a.dat_e))  
    then b.dat_b 
    when (a.dat_b=coalesce(b.dat_b,a.dat_b) and a.dat_e>coalesce(b.dat_e,a.dat_e))
    then a.dat_e end as dat_e  
 from 
 (select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=1 ) as a
 inner join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
   ,case when c1.dat_b<=c2.dat_b then c2.dat_b else c1.dat_b end as dat_b
   ,case when c1.dat_e>=c2.dat_e then c2.dat_e else c1.dat_e end as dat_e
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter and c1.dat_b < c2.dat_e and c1.dat_e>c2.dat_b)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy 
   and (a.dat_b<b.dat_b or a.dat_e>b.dat_e)) ) as b 
     inner join 
        (select * from act_pnt_cntavg where ldemand<>0 and pdays<>0) as c 
     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;

 insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,fact_demand,sum_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(round(c.ldemand/c.pdays*case when date_mi(c.dat_e,c.dat_b)<>0  then date_mi(c.dat_e,c.dat_b) else 1 end,0))
     ,sum(round(c.ldemand/c.pdays*case when date_mi(c.dat_e,c.dat_b)<>0  then date_mi(c.dat_e,c.dat_b) else 1 end,0)),3 
     from 
 (select a.id_point,a.kind_energy,a.dat_b,a.dat_e from 
 (select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=1) as a
left join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy)
  left join act_pwr_demand_tbl as c on (c.id_point=a.id_point 
    and c.kind_energy=a.kind_energy and c.dat_b<a.dat_e and c.dat_e>a.dat_b)
 where b.id_point is null and c.id_point is null) as b
     inner join 
        (select * from act_pnt_cntavg where ldemand<>0 and pdays<>0) as c 
     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;


-----knde=2 , 3 - avg

 insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,fact_demand,sum_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(round(c.ldemandr::numeric/c.pdays*date_mi(b.dat_e,b.dat_b),0))
     ,sum(round(c.ldemandr::numeric/c.pdays*date_mi(b.dat_e,b.dat_b),0)),3 
   from 
(select a.id_point,a.kind_energy  
   ,case when (a.dat_b<coalesce(b.dat_b,a.dat_b) and a.dat_e=coalesce(b.dat_e,a.dat_e))  
    then a.dat_b 
    when (a.dat_b=coalesce(b.dat_b,a.dat_b) and a.dat_e>coalesce(b.dat_e,a.dat_e))
    then b.dat_e end as dat_b  
   ,case when (a.dat_b<coalesce(b.dat_b,a.dat_b) and a.dat_e=coalesce(b.dat_e,a.dat_e))  
    then b.dat_b 
    when (a.dat_b=coalesce(b.dat_b,a.dat_b) and a.dat_e>coalesce(b.dat_e,a.dat_e))
    then a.dat_e end as dat_e  
 from 
 (select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=2 ) as a
 inner join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
   ,case when c1.dat_b<=c2.dat_b then c2.dat_b else c1.dat_b end as dat_b
   ,case when c1.dat_e>=c2.dat_e then c2.dat_e else c1.dat_e end as dat_e
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter and c1.dat_b < c2.dat_e and c1.dat_e>c2.dat_b)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy 
   and (a.dat_b<b.dat_b or a.dat_e>b.dat_e)) ) as b 
     inner join 
        (select * from act_pnt_cntavgr where ldemandr<>0 and pdays<>0) as c 
     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;

 insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,fact_demand,sum_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(round(c.ldemandr/c.pdays*date_mi(c.dat_e,c.dat_b),0))
     ,sum(round(c.ldemandr/c.pdays*date_mi(c.dat_e,c.dat_b),0)),3 
     from 
 (select a.id_point,a.kind_energy,a.dat_b,a.dat_e from 
 (select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=2) as a
left join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy)
  left join act_pwr_demand_tbl as c on (c.id_point=a.id_point 
    and c.kind_energy=a.kind_energy and c.dat_b<a.dat_e and c.dat_e>a.dat_b)
 where b.id_point is null and c.id_point is null) as b
     inner join 
        (select * from act_pnt_cntavgr where ldemandr<>0 and pdays<>0) as c 
     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;

update act_pwr_demand_tbl set fact_demand=fact_demand-k1.sum_demand 
from  
(select id_p_point,dat_b,dat_e,kind_energy,sum(sum_demand) as sum_demand
 from 
(select a1.id_p_point,a1.id_point
  ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
  ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e
  ,a2.sum_demand,a2.kind_energy  
from 
(select a.id_point,a.dat_b,a.dat_e,a.id_p_point from act_point_branch_tbl as a 
   inner join act_point_branch_tbl as b on (a.id_p_point=b.id_point)) as a1 
inner join 
(select * from act_pwr_demand_tbl where ident=3) as a2 
 on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b) 
) as k group by id_p_point,dat_b,dat_e,kind_energy) as k1  
 where  act_pwr_demand_tbl.id_point=k1.id_p_point 
   and act_pwr_demand_tbl.kind_energy=k1.kind_energy 
   and act_pwr_demand_tbl.dat_b=k1.dat_b 
   and act_pwr_demand_tbl.dat_e=k1.dat_e;

----------------avg

 insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,fact_demand,sum_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(c.pwr),sum(c.pwr),2 
     from 
 (select a.id_point,a.kind_energy,a.dat_b,a.dat_e from 
 (select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=1) as a
left join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy)
  left join act_pwr_demand_tbl as c on (c.id_point=a.id_point 
    and c.kind_energy=a.kind_energy and c.dat_b<a.dat_e and c.dat_e>a.dat_b)
 where b.id_point is null and c.id_point is null) as b
     inner join 
      (select c1.id_point,c1.dat_b,c1.dat_e,c1.a_pwr,c1.wtm
        ,round(c1.a_pwr*round(c1.wtm*date_mi(c1.dat_e::date,c1.dat_b::date),0),0) as pwr 
       from  
        (select e.id_point
          ,case when f.dat_b<=e.dat_b then e.dat_b else f.dat_b end as dat_b
          ,case when f.dat_e>=e.dat_e then e.dat_e else f.dat_e end as dat_e 
          ,e.a_pwr,f.wtm 
       from 
        (select id_point,power as a_pwr
                ,dat_b,dat_e 
          from act_pnt_pwr --where power<>0
          ) as e
        inner join
        (select id_point,(wtm/date_mi(dte::date,dtb::date)::numeric) as wtm
                ,dat_b,dat_e 
          from act_pnt_wtm --where wtm<>0
          ) as f 
      on (e.id_point=f.id_point and e.dat_b<f.dat_e and e.dat_e>f.dat_b)) as c1
      ) as c 

     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;

------knde=4
 insert into act_pwr_demand_tbl(id_point,kind_energy,dat_b,dat_e
     ,sum_demand,fact_demand,ident)
select b.id_point,b.kind_energy,b.dat_b,b.dat_e
     ,sum(c.pwr),sum(c.pwr),2 
     from 
 (select a.id_point,a.kind_energy,a.dat_b,a.dat_e from 
 (select a1.id_point,a2.kind_energy,a1.dat_b,a1.dat_e from 
  act_point_branch_tbl as a1 inner join act_pnt_knd as a2 
    on (a1.id_point=a2.id_point and a2.dat_b<a1.dat_e and a2.dat_e>a1.dat_b)
    where a2.kind_energy=4) as a
 left join  
(select distinct c1.id_point,c1.id_meter,c2.kind_energy
  from act_meter_pnt_tbl as c1 inner join act_met_knd as c2 
   on (c1.id_meter=c2.id_meter)) as b
     on (a.id_point=b.id_point and a.kind_energy=b.kind_energy)
 where b.id_point is null) as b
     inner join 
      (select e.id_point,f.dat_b,f.dat_e
        ,round(comp*(date_mi(dte::date,dtb::date)*24-round(wtm*date_mi(f.dat_e::date,f.dat_b::date),0)),0) as pwr 
       from 
        (select id_point,comp,dat_b,dat_e 
          from act_pnt_cmp where comp<>0) as e
        inner join
        (select id_point,(wtm/date_mi(dte::date,dtb::date)::numeric) as wtm
                ,dat_b,dat_e 
          from act_pnt_wtm where wtm<>0) as f 
        on (e.id_point=f.id_point and e.dat_b<f.dat_e and e.dat_e>f.dat_b)
      ) as c 
     on (b.id_point=c.id_point and b.dat_b<c.dat_e and b.dat_e>c.dat_b) 
     group by b.id_point,b.kind_energy,b.dat_b,b.dat_e;
-----------------upd sum_wp for losts XX
for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and b.id_client=idcl 
      -- and a1.id_client=b.id_client 
      and a.sum_wp is null loop 
Raise Notice ''sum_wp_last'';

  update act_losts_eqm_tbl set sum_wp=(select sum(k.sum_demand) 
    from (select distinct a.id_point,a.kind_energy
     ,a.dat_b,a.id_zone,sum_demand  
    from act_pwr_demand_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
     where b.id_eqp=r.id_eqp and a.kind_energy=1 and a.ident=2 and 
      a.sum_demand=0 and a.fact_demand=0 and c.id_p_point is null) as k)
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;

end loop;

for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and b.id_client=idcl 
    --   and a1.id_client=b.id_client 
    and a.sum_wq is null loop 
Raise Notice ''sum_wq_last'';
  update act_losts_eqm_tbl set sum_wq=(select sum(k.sum_demand) 
    from (select distinct a.id_point,a.kind_energy
     ,a.dat_b,a.id_zone,sum_demand  
    from act_pwr_demand_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
     where b.id_eqp=r.id_eqp and a.kind_energy=2 and a.ident=4 
     and c.id_p_point is null) as k) 
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;

end loop;

for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and b.id_client=idcl 
      -- and a1.id_client=b.id_client 
      loop 
Raise Notice ''sum_wp_last_3'';

  update act_losts_eqm_tbl set sum_wp=coalesce(sum_wp,0)+
   coalesce((select sum(k.sum_demand) 
    from (select distinct a.id_point,a.kind_energy
     ,a.dat_b,a.id_zone,sum_demand  
    from act_pwr_demand_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
     where b.id_eqp=r.id_eqp and a.kind_energy=1 and a.ident=3 and 
       c.id_p_point is null) as k),0)
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;

end loop;
for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and b.id_client=idcl 
    --   and a1.id_client=b.id_client 
    --and a.sum_wq is null 
    loop 
Raise Notice ''sum_wq_last_3'';
  update act_losts_eqm_tbl set sum_wq=coalesce(sum_wq,0)+
    coalesce((select sum(k.sum_demand) 
    from (select distinct a.id_point,a.kind_energy
     ,a.dat_b,a.id_zone,sum_demand  
    from act_pwr_demand_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
     where b.id_eqp=r.id_eqp and a.kind_energy=2 and a.ident=3 
     and c.id_p_point is null) as k),0)   
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;

end loop;

-----------------upd sum_wp for losts XX

-----------no meter calcs
------calc losts-------


for r in select id_point from act_pnt_hlosts loop
Raise Notice ''h_losts r.id_point - %'',r.id_point;
 rs:=desc_hlosts(r.id_point);
end loop;


for r in select distinct  a.* from act_point_branch_tbl as a 
   inner join (select id_point,count(*) from act_losts_eqm_tbl 
                 group by id_point
              ) as b on a.id_point=b.id_point where id_p_point is null loop

   raise notice ''+++++++++++++calc lost  ID_P_POINT=null   % '',r.id_point;
   rs:=calc_lost_desc(r.id_point);  

end loop;


for r in select distinct a.* from act_point_branch_tbl as a 
    inner join (select id_point,count(*) from act_losts_eqm_tbl 
                 group by id_point  having count(*)>=2
               ) as b on a.id_point=b.id_point 
   inner join act_point_branch_tbl as c on a.id_p_point=c.id_point
   where c.id_client<>c.id_rclient 
   and c.id_rclient=(select int4(value_ident) 
        from syi_sysvars_tbl where ident=''id_res'') loop

   raise notice ''.................calc lost >=2  % '',r.id_point;
    rs:=calc_lost_desc(r.id_point);  

end loop;

     --osa 2011-10-20  
  
for r in select distinct a.* from act_point_branch_tbl as a 
   inner join (select id_point,id_eqp,count(*) from act_losts_eqm_tbl 
                group by id_point,id_eqp having count(*)<2
               ) as b on a.id_point=b.id_point 
   inner join act_point_branch_tbl as c on a.id_p_point=c.id_point
   where c.id_client=c.id_rclient 
   and c.id_rclient<>(select int4(value_ident)
                       from syi_sysvars_tbl where ident=''id_res''
   ) loop

   raise notice ''.......................calc lost <2 +++  % '',r.id_point;
   rs:=calc_lost_desc(r.id_point);  

end loop;

for r in select  pl.* from act_pnt_lost pl left join act_losts_eqm_tbl pe
on pe.id_point=pl.id_point where pl.count_lost=1 and pe.id_point is null
 loop 
   raise notice '' 333333333 calc_loct if not losts eqp  % '',r.id_point;
      rs:=calc_lost_desc(r.id_point);  
end loop; 


  
-- update for hand_losts  2012-10-16
update act_pwr_demand_tbl set fact_losts=hl.sum_hand_losts 
from 
 (select id_point,kind_energy,id_zone,dat_b,dat_e,sum(hand_losts)  as sum_hand_losts
   from act_met_kndzn_tbl 
   where hand_losts is not null
   group by id_point,kind_energy,id_zone,dat_b,dat_e 
  ) hl 
where act_pwr_demand_tbl.id_point=hl.id_point and  
          act_pwr_demand_tbl.kind_energy=hl.kind_energy  and
          act_pwr_demand_tbl.id_zone=hl.id_zone and 
          act_pwr_demand_tbl.dat_b= hl.dat_b and
          act_pwr_demand_tbl.dat_e= hl.dat_e;


------calc losts-------
 
Return true;
--Return False;
   raise notice '' end calcpnt   '';
end;
' Language 'plpgsql';





