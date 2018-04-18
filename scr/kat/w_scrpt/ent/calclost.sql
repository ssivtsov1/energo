--alter table acd_zone_tbl add column tm_begin int;
--alter table acd_zone_tbl add column tm_end int;
alter table acd_zone_tbl add column hours int;
--update acd_zone_tbl set hours=12 where id_zone=1;
--update acd_zone_tbl set hours=7  where id_zone=2;
--update acd_zone_tbl set hours=5  where id_zone=3;
--update acd_zone_tbl set hours=24 where id_zone=0;

alter table acd_calc_losts_tbl add column res_l int;
alter table acd_calc_losts_tbl add column is_use int;
alter table acd_calc_losts_tbl add column in_demand int;
alter table acd_pwr_demand_tbl add column in_res_losts int;
alter table acd_pwr_demand_tbl add column out_res_losts int;
alter table acd_pwr_demand_tbl add column abn_losts int;

alter table acd_calc_losts_del add column res_l int;
alter table acd_calc_losts_del add column is_use int;
alter table acd_calc_losts_del add column in_demand int;
alter table acd_pwr_demand_del add column in_res_losts int;
alter table acd_pwr_demand_del add column out_res_losts int;
alter table acd_pwr_demand_del add column abn_losts int;
                                        

alter table acd_pwr_demand_del drop column abn_res_losts;
alter table acd_pwr_demand_tbl drop column abn_res_losts;


------- рекурсивный запуск расчета потерь от родителя к потомку calc_lost_desc(r.id_point)


create  or replace function date_mi_nol(date,date) Returns int As'
Declare
dte alias for $1;
dtb alias for $2;
minus int;
begin
minus=date_mi(dte,dtb);
if minus=0 then
 minus=1;
end if;
Return minus;
end;
' Language 'plpgsql';


--drop function calc_lost_desc(int);
create or replace function calc_lost_desc(int) Returns boolean As'
Declare

idpnt Alias for $1; -- код точки учета

rs boolean; -- возвращаемое значение, если обнаружена ошибка, то False
rs1 boolean;
r record;
r1 record;
r2 record;
r3 record;
rz record;
calc_dem record;
sum_l int;
abn_l int;
inres_l int;
outres_l int;
idres int;
test record;
dcalc int;
isdouble int;

begin
  raise notice ''+++++++++++++++++++++++calc_lost_desc+++++++++++++++++++++++++++'';  
  raise notice ''start   calc_lost_desc(idpnt)'';
  raise notice ''start  calc_lost_desc(%)'',idpnt;
  select into idres int4(value_ident) from syi_sysvars_tbl where ident=''id_res'';

  for r in select a.* from act_point_branch_tbl as a 
  inner join (select id_point,count(*) as cnt from act_losts_eqm_tbl 
   group by id_point) as b on a.id_point=b.id_point where a.id_p_point=idpnt loop
     raise notice ''recurs() '';
     rs1:=calc_lost_desc(r.id_point); 
  end loop;

  for rz in select distinct d.id_point,d.kind_energy,d.id_zone,d.dat_b,dat_e 
   from act_pwr_demand_tbl d where d.id_point=idpnt and d.ident<>2 
   loop 

   select into calc_dem    d.id_point,d.kind_energy,d.dat_b,d.dat_e,
    count(d.id_point) as calc 
    from act_pwr_demand_tbl d 
   where d.id_point=idpnt and d.kind_energy=rz.kind_energy 
     and d.dat_b=rz.dat_b and d.dat_e=rz.dat_e  and d.ident<>2
     group by d.id_point,d.kind_energy,d.dat_b,d.dat_e; 

     raise notice ''calc_dem___ d.id_point %,d.kind_energy %,d.dat_b %,d.dat_e %, calc %'',calc_dem.id_point,calc_dem.kind_energy,calc_dem.dat_b,calc_dem.dat_e,calc_dem.calc;
     isdouble=0;
    select into isdouble count(*) from  act_2point_branch_tbl where id_point=idpnt or id_p_point=idpnt;   
    if isdouble>0  then
      raise notice ''isdouble>0  id_pnt =  % '',idpnt; 
 raise notice ''isdouble++++++++++++++++++++++++++++++++++ ''; 
    
     update act_pwr_demand_tbl set id_bill=cou,fact_losts=coalesce(fact_losts,0)-coalesce(round(round(k.s_l,0)::int*k.perc,0),0)::int 
      from 
           (select k1.*,k2.perc as perc from 
           (select sum(sum_losts+in_res_losts+abn_losts)/cou*1 as s_l,cou,idpnt as id_point,a.kind_energy as kind_energy,rz.id_zone as id_zone
             ,a.dat_b as dat_b,a.dat_e as dat_e 
             from 
--             act_pwr_demand_tbl as a
          (select distinct d.*,coalesce(d4.cou,1) as cou from act_pwr_demand_tbl d
           left join  
          (select d3.*,d2.cou from  
          (select id_point,count(*) as cou from act_2point_branch_tbl group by id_point) d2
         left join (select id_p_point,id_point from  act_2point_branch_tbl ) d3
         on d2.id_point=d3.id_point 
        ) d4 on d4.id_point=d.id_point) as a
        inner join (select * from act_point_branch_tbl where id_p_point=idpnt) as b on a.id_point=b.id_point 
        where (a.ident<>2 or (a.ident=2 and a.sum_demand=0))
        group by a.kind_energy,cou,a.dat_b,a.dat_e) as k1 
       inner join 
                (select b.*,coalesce(a.perc,1) as perc from 
        (select rz.id_point as id_point,rz.kind_energy as kind_energy,rz.dat_e as dat_e,rz.dat_b as dat_b 
                ,rz.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=rz.id_zone and a11.dt_begin<rz.dat_e)) as a 
       on a.id_zone=b.id_zone) as k2
       on  k1.id_point=k2.id_point and k1.kind_energy=k2.kind_energy and k1.dat_b=k2.dat_b and k1.dat_e=k2.dat_e
            and k1.id_zone=k2.id_zone) as k

      where act_pwr_demand_tbl.id_point=idpnt 
       and k.kind_energy=act_pwr_demand_tbl.kind_energy and k.id_zone=act_pwr_demand_tbl.id_zone 
       and k.dat_b=act_pwr_demand_tbl.dat_b and k.dat_e=act_pwr_demand_tbl.dat_e 
       and (act_pwr_demand_tbl.ident<>2 or (act_pwr_demand_tbl.ident=2 and act_pwr_demand_tbl.sum_demand=0));

    else

       raise notice ''ELSW isdouble== 0   id_pnt =  % '',idpnt; 
      update act_pwr_demand_tbl set fact_losts=coalesce(fact_losts,0)-coalesce(round(round(k.s_l,0)::int*k.perc,0),0)::int 
      from 
           (select k1.*,k2.perc as perc from 
           (select sum(sum_losts+in_res_losts+abn_losts) as s_l,idpnt as id_point,a.kind_energy as kind_energy,rz.id_zone as id_zone
             ,a.dat_b as dat_b,a.dat_e as dat_e 
             from act_pwr_demand_tbl as a 
       inner join (select * from act_point_branch_tbl where id_p_point=idpnt) as b on a.id_point=b.id_point 
        where (a.ident<>2 or (a.ident=2 and a.sum_demand=0))
        group by a.kind_energy,a.dat_b,a.dat_e) as k1 

      inner join 
                (select b.*,coalesce(a.perc,1) as perc from 
        (select rz.id_point as id_point,rz.kind_energy as kind_energy,rz.dat_e as dat_e,rz.dat_b as dat_b 
                ,rz.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=rz.id_zone and a11.dt_begin<rz.dat_e)) as a 
       on a.id_zone=b.id_zone) as k2
       on  k1.id_point=k2.id_point and k1.kind_energy=k2.kind_energy and k1.dat_b=k2.dat_b 
             and (k1.dat_e=k2.dat_e OR (K2.DAT_E- INTERVAL ''1 DAY''=k1.dat_e) ) 
             --k1.dat_e=k2.dat_e 2012-03-19 WAS NO MINUS LOST ABON 
            and k1.id_zone=k2.id_zone) as k
        where act_pwr_demand_tbl.id_point=idpnt 
       and k.kind_energy=act_pwr_demand_tbl.kind_energy and k.id_zone=act_pwr_demand_tbl.id_zone 
       and k.dat_b=act_pwr_demand_tbl.dat_b and k.dat_e=act_pwr_demand_tbl.dat_e 
       and (act_pwr_demand_tbl.ident<>2 or (act_pwr_demand_tbl.ident=2 and act_pwr_demand_tbl.sum_demand=0));
   
   /*   */

   --    raise notice ''RZ.DAT_B    ________                % '',RZ.DAT_B;
   --    raise notice ''RZ.DAT_E    ________                % '',RZ.DAT_E;
       
      for test in  select k1.*,k2.perc as perc from 
           (select sum(sum_losts+in_res_losts+abn_losts) as s_l,idpnt as id_point,a.kind_energy as kind_energy,rz.id_zone as id_zone
             ,a.dat_b as dat_b,a.dat_e as dat_e 
             from act_pwr_demand_tbl as a 
       inner join (select * from act_point_branch_tbl where id_p_point=idpnt) as b on a.id_point=b.id_point 
        where (a.ident<>2 or (a.ident=2 and a.sum_demand=0))
        group by a.kind_energy,a.dat_b,a.dat_e) as k1 

      inner join 
                (select b.*,coalesce(a.perc,1) as perc from 
        (select rz.id_point as id_point,rz.kind_energy as kind_energy,rz.dat_e as dat_e,rz.dat_b as dat_b 
                ,rz.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=rz.id_zone and a11.dt_begin<rz.dat_e)) as a 
       on a.id_zone=b.id_zone) as k2
       on  k1.id_point=k2.id_point and k1.kind_energy=k2.kind_energy and k1.dat_b=k2.dat_b 
          --   and (k1.dat_e=k2.dat_e OR (K2.DAT_E- INTERVAL ''1 DAY''=k1.dat_e) )  
            and k1.id_zone=k2.id_zone loop
             --raise notice ''test.id_point in      ________     % ,test.s_l %'',test.id_point,test.s_l;
        end loop;


      /* */


   end if;

  end loop;

  for r1 in select count(*),id_point,kind_energy,dat_b,dat_e from act_pwr_demand_tbl 
         where id_point=idpnt and (ident<>2 or (ident=2 and sum_demand=0)) 
         group by id_point,kind_energy,dat_b,dat_e order by  id_point,kind_energy,dat_b,dat_e
     loop

   select into calc_dem    d.id_point,d.kind_energy,d.dat_b,d.dat_e,
     count(d.id_point) as calc 
     from act_pwr_demand_tbl d 
     where d.id_point=idpnt and d.kind_energy=r1.kind_energy 
      and d.dat_b=r1.dat_b and d.dat_e=r1.dat_e  and d.ident<>2
      group by d.id_point,d.kind_energy,d.dat_b,d.dat_e; 

         rs:=clc_lost(r1.id_point,r1.dat_b,r1.dat_e,r1.kind_energy);
      
     for r2 in select * from act_pwr_demand_tbl where id_point=r1.id_point and dat_b=r1.dat_b 
          and dat_e=r1.dat_e and kind_energy=r1.kind_energy loop 


     raise notice ''r2.id_point %,r2.kind_energy %, r2.id_zone  %,r2.dat_b %,r2.dat_e %, sum_demand %,fact_demand %,sum_losts %, fact_losts  %'',      
       r2.id_point ,r2.kind_energy ,r2.id_zone ,r2.dat_b ,r2.dat_e , r2.sum_demand ,r2.fact_demand ,r2.sum_losts , r2.fact_losts;

        select into sum_l coalesce(sum(a.dw),0) from act_calc_losts_tbl as a 
            where id_point=idpnt
            and res_l=0 and a.dat_b=r1.dat_b and a.dat_e=r1.dat_e 
            and a.kind_energy=r1.kind_energy 
            and a.kind_energy=calc_dem.kind_energy
             and a.dat_b=calc_dem.dat_b
            and a.dat_e=calc_dem.dat_e
            and is_use<1 and in_demand<calc_dem.calc;
            dcalc=0;

            for test in select * from act_calc_losts_tbl  where id_point=idpnt  loop
             raise notice ''calc sum_l  test.id_point    %   dw  % kind_energy %, in_demand %,  '',test.id_point, test.dw,test.kind_energy,test.in_demand;
           end loop;


       for dcalc in select coalesce(is_use,0) as is_use  
                 from act_calc_losts_tbl cl,
                     act_2point_branch_tbl pb 
                 where cl.id_point=idpnt and cl.dat_b=r1.dat_b and cl.dat_e=r1.dat_e 
                  and cl.kind_energy=r1.kind_energy and cl.id_point=pb.id_point loop
           raise notice ''_(((((((((((((dcalc )))))))))))  %'',dcalc ;
       end loop; 

       select into isdouble count(*) from  act_2point_branch_tbl where id_point=idpnt or id_p_point=idpnt;   
       if isdouble>0  then
         update act_calc_losts_tbl set is_use=coalesce(is_use,0)+1 
          where id_point=idpnt and   dat_b=r1.dat_b  and dat_e=r1.dat_e;
       end if;

      update act_pwr_demand_tbl set sum_losts=coalesce(sum_losts,0)+coalesce(round(round(sum_l,0)::int*k.perc,0),0)::int 
                                 ,fact_losts=coalesce(fact_losts,0)+coalesce(round(round(sum_l,0)::int*k.perc,0),0)::int    
       from    
        (select r2.id_zone as id_zone,coalesce(a.perc,1) as perc from 
         --     (select id_zone,dat_b,dat_e from act_pwr_demand_tbl  
         --       where id_point=r1.id_point  and dat_b=r1.dat_b and dat_e=r1.dat_e and kind_energy=r1.kind_energy 
         --      and (ident<>2 or (ident=2 and sum_demand=0))) as b 
         (select r2.id_zone as id_zone ) as b
           left join 
           (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
            from acd_zone_tbl as a1 where dt_begin=
             (select max(a11.dt_begin) from acd_zone_tbl as a11 
             where a11.id_zone=r2.id_zone and a11.dt_begin<r1.dat_e)) as a 
           on a.id_zone=b.id_zone) as k
          where act_pwr_demand_tbl.id_point=r1.id_point and act_pwr_demand_tbl.kind_energy=r1.kind_energy 
             and act_pwr_demand_tbl.id_zone=k.id_zone 
             and act_pwr_demand_tbl.dat_b=r1.dat_b and act_pwr_demand_tbl.dat_e=r1.dat_e; 
           
     for test in select * from act_pwr_demand_tbl where id_point=50123  loop
             raise notice ''first upd test.id_point in      ________                % '',test.id_point;
             raise notice ''first upd test.fact_losts in  ________                % '',test.fact_losts;
             raise notice ''first upd test.sum_lost in      ________                % '',test.sum_losts;
             raise notice ''first upd test.out_lost in      ________                % '',test.out_res_losts;
           end loop;


 -- end if;   ???
/* 
          for test in select * from  act_calc_losts_tbl  where id_point=idpnt  loop
             raise notice ''1   test.id_point    %    in_demand %    dw  %'',test.id_point,test.in_demand, test.dw;
           end loop;
        */


      /* 
          for test in select * from  act_calc_losts_tbl  where id_point=idpnt  loop
             raise notice ''1   test.id_point    %    in_demand %    dw  %'',test.id_point,test.in_demand, test.dw;
           end loop;
        */


   select into abn_l coalesce(sum(a.dw),0) from act_calc_losts_tbl as a where id_point=idpnt
            and res_l=3 and a.dat_b=r1.dat_b and a.dat_e=r1.dat_e 
            and a.kind_energy=r1.kind_energy 
            and a.kind_energy=calc_dem.kind_energy
             and a.dat_b=calc_dem.dat_b
            and a.dat_e=calc_dem.dat_e
            and --a.in_demand<=calc_dem.calc;--
               a.in_demand=0;
             --raise notice ''abn_l     ________                % '',abn_l;

                                                                                                   --*k.pers OSA 2014-06-03
   update act_pwr_demand_tbl set abn_losts=coalesce(abn_losts,0)+coalesce(round(round(abn_l,0)::int*1,0),0)::int
      from    
        (select r2.id_zone as id_zone,coalesce(a.perc,1) as perc from 
        (select r2.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=r2.id_zone and a11.dt_begin<r1.dat_e)) as a 
       on a.id_zone=b.id_zone) as k
      where act_pwr_demand_tbl.id_point=r1.id_point and act_pwr_demand_tbl.kind_energy=r1.kind_energy 
            and act_pwr_demand_tbl.id_zone=k.id_zone 
            and act_pwr_demand_tbl.dat_b=r1.dat_b and act_pwr_demand_tbl.dat_e=r1.dat_e; 
  

   select into inres_l coalesce(sum(a.dw),0) from act_calc_losts_tbl as a 
             where id_point=idpnt
            and res_l=1 and a.dat_b=r1.dat_b and a.dat_e=r1.dat_e and a.kind_energy=r1.kind_energy 
            and a.kind_energy=calc_dem.kind_energy
             and a.dat_b=calc_dem.dat_b
            and a.dat_e=calc_dem.dat_e
            and --a.in_demand<=calc_dem.calc;--
            a.in_demand=0;            -- raise notice ''inres_l     ________                % '',inres_l;
                                                                                                       --*k.pers OSA 2014-06-03
    update act_pwr_demand_tbl set in_res_losts=coalesce(in_res_losts,0)+coalesce(round(round(inres_l,0)::int*1,0),0)::int
      from    
        (select r2.id_zone as id_zone,coalesce(a.perc,1) as perc from 
        (select r2.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=r2.id_zone and a11.dt_begin<r1.dat_e)) as a 
       on a.id_zone=b.id_zone) as k
      where act_pwr_demand_tbl.id_point=r1.id_point and act_pwr_demand_tbl.kind_energy=r1.kind_energy 
            and act_pwr_demand_tbl.id_zone=k.id_zone 
            and act_pwr_demand_tbl.dat_b=r1.dat_b and act_pwr_demand_tbl.dat_e=r1.dat_e; 


    select into outres_l coalesce(sum(a.dw),0) from act_calc_losts_tbl as a where id_point=idpnt
            and res_l=2 and a.dat_b=r1.dat_b and a.dat_e=r1.dat_e and a.kind_energy=r1.kind_energy 
            and a.kind_energy=calc_dem.kind_energy
             and a.dat_b=calc_dem.dat_b
            and a.dat_e=calc_dem.dat_e
          and --a.in_demand<=calc_dem.calc;--
          a.in_demand=0;

     --raise notice ''outres_l     ________                % '',outres_l; 

                                                                                                            --*k.pers OSA 2014-06-03
    update act_pwr_demand_tbl set out_res_losts=coalesce(out_res_losts,0)+coalesce(round(round(outres_l,0)::int*1,0),0)::int
      from    
       (select r2.id_zone as id_zone,coalesce(a.perc,1) as perc from 
        (select r2.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=r2.id_zone and a11.dt_begin<r1.dat_e)) as a 
       on a.id_zone=b.id_zone) as k
      where act_pwr_demand_tbl.id_point=r1.id_point and act_pwr_demand_tbl.kind_energy=r1.kind_energy 
            and act_pwr_demand_tbl.id_zone=k.id_zone 
            and act_pwr_demand_tbl.dat_b=r1.dat_b and act_pwr_demand_tbl.dat_e=r1.dat_e;

    
  
      raise notice ''upd in_demand  idpnt %,r1.dat_b  %,r1.dat_e  %, r1.kind_energy %'',idpnt,r1.dat_b,r1.dat_e, r1.kind_energy;

           for test in select * from act_calc_losts_tbl  where id_point=idpnt  loop
             --raise notice ''1  test.id_point    %   dw  % kind_energy %, in_demand %'',test.id_point, test.dw,test.kind_energy,test.in_demand;
           end loop;

        update act_calc_losts_tbl set in_demand=in_demand+1 where id_point=idpnt
           and dat_b=r1.dat_b and dat_e=r1.dat_e and r1.kind_energy=kind_energy;
          
           for test in select * from act_calc_losts_tbl  where id_point=idpnt  loop
             --raise notice ''2  test.id_point    %   dw  % kind_energy %, in_demand %'',test.id_point, test.dw,test.kind_energy,test.in_demand;
           end loop;

           
   for r3 in  select distinct a.id_point,a.id_client,a.id_rclient from act_point_branch_tbl as a 
          where a.id_point=idpnt and (a.id_client<>a.id_rclient and a.id_rclient=idres )
   loop

--                   and a.id_rclient=idres
-- ) 
         raise notice ''minus lost res lost   id_point  %    id_client %    id_r_client  %'',r3.id_point,r3.id_client,r3.id_rclient;
    ------ потери РЭС с минусом в фактические потери, если учет на стороне РЭС
     update act_pwr_demand_tbl set fact_losts=coalesce(fact_losts,0)-coalesce(round(round(in_res_losts,0)::int*k.perc,0),0)::int
      from    
       (select r2.id_zone as id_zone,coalesce(a.perc,1) as perc from 
        (select r2.id_zone as id_zone ) as b
       left join 
        (select a1.id_zone,round(a1.hours::numeric/24,2) as perc        
         from acd_zone_tbl as a1 where dt_begin=
          (select max(a11.dt_begin) from acd_zone_tbl as a11 
            where a11.id_zone=r2.id_zone and a11.dt_begin<r1.dat_e)) as a 
       on a.id_zone=b.id_zone) as k
      where act_pwr_demand_tbl.id_point=r1.id_point and act_pwr_demand_tbl.kind_energy=r1.kind_energy 
            and act_pwr_demand_tbl.id_zone=k.id_zone 
            and act_pwr_demand_tbl.dat_b=r1.dat_b and act_pwr_demand_tbl.dat_e=r1.dat_e;

   end loop;



 end loop;
end loop;
raise notice ''end  calc_lost_desc()'';
Return true;
  
end;
' Language 'plpgsql';



--drop function clc_lost(int,date,date,int);
--drop function clc_lost(int,date,date);
create or replace function clc_lost(int,date,date,int) Returns boolean As'
Declare

idpnt Alias for $1; -- код точки учета
dtb Alias for $2; -- дата начала
dte Alias for $3; -- дата завершения
knde Alias for $4; -- вид энергии

wp int; -- суммарное потребление по точке учета АЕ
fwp int; -- фактическое потребление по точке учета АЕ
fwq int; -- фактическое потребление по точке учета РЕ
wq int; -- суммарное потребление по точке учета РЕ
r record; -- параметры из таблицы оборудования для расчета потерь act_losts_eqm_tbl + 
          -- таблица точек для расчета потерь, первый в дереве оборудования элемент.
rs boolean; -- возвращаемое значение, если обнаружена ошибка, то False

rs1 text;
dwp int;
dwq int;
cnt int;

begin
--calc losts
dwp:=0;
dwq:=0;

rs:=false;
raise notice ''+++++++++++++++++++++clc_lost+++++++++++++++++++++++++++++'';
raise notice ''start   clc_lost (%,%,%,%)'' ,idpnt,dtb,dte,knde ;
 
--потребление, на которое начисляются потери добавляем в условия даты начала и окончания
select into fwp coalesce(sum(fact_demand),0) from act_pwr_demand_tbl 
  where id_point=idpnt and kind_energy=1 and ident<>2 and dat_b=dtb and dat_e=dte;

select into wp coalesce(sum(sum_demand),0) from act_pwr_demand_tbl 
  where id_point=idpnt and kind_energy=1 and ident<>2  and dat_b=dtb and dat_e=dte;

select into fwq sum(fact_demand) from act_pwr_demand_tbl where id_point=idpnt 
  and kind_energy=2 and ident<>2 and dat_b=dtb and dat_e=dte;

select into wq sum(sum_demand) from act_pwr_demand_tbl where id_point=idpnt 
  and kind_energy=2 and ident<>2  and dat_b=dtb and dat_e=dte;

-- raise notice ''1 wq lost  %'',wq;
if wq is null then
  select into cnt count(*) from act_pnt_tg where id_point=idpnt and not (id_tg=0 
  or id_tg is null);
   if cnt>0 then
    -- расчет реактива при замене активного счетчика
      Raise Notice ''calc reactive if change active meter'';
      select into wq sum(w_p) from 
      (select round(round(wp::numeric/date_mi_nol(date_smaller(dte::date,b.dat_e)
       ,date_larger(dtb::date,b.dat_b))*date_mi_nol(date_smaller(dte::date,b.dat_e),date_larger(dtb::date,b.dat_b)),0)*c.value,0) as w_p 
              from act_pnt_tg as b,eqk_tg_tbl as c where b.id_point=idpnt 
                 and b.id_tg=c.id) as a;
      fwq:=wq;
   else
    Raise Notice ''tg_fi not present'';
    insert into act_res_notice values(''tg_fi not present'');
    Return false;
  end if;
end if;
for r in select distinct a.id_eqp,a.id_p_eqp,a.id_point
       from act_losts_eqm_tbl as a              
           where a.id_point=idpnt and a.id_p_eqp is null loop 
   if ((wp+wq>0) or (knde=1)) then
        rs1:=clc_lost_eqp(idpnt,r.id_eqp,wp,wq,0,0,knde,dtb,dte,r.id_p_eqp);
     if knde=1 then
       dwp:=split_part(rs1,'';'',1)::int;
       rs:=true;
     end if;
     ----запись реактивных потерь
     if knde=2 then
       dwq:=split_part(rs1,'';'',2)::int;
       raise notice ''write reactive lost         dwq   %'',dwq;
       rs:=true;
     end if;
   end if;
end loop;

Return rs;
end;
' Language 'plpgsql';




--drop function clc_lost_eqp(int,int,int,int,int,int,int,int,date,date,int);
--drop function clc_lost_eqp(int,int,int,int,int,int,int,date,date,int);
--drop function clc_lost_eqp(int,int,int,int,int,int,int,int,date,date);
--drop function clc_lost_eqp(int,int,int,int,int,int,int,int,date,date,int);

create  or replace function clc_lost_eqp(int,int,int,int,int,int,int,date,date,int) Returns text As'
Declare
idpnt Alias for $1;
ideqp Alias for $2;
wp Alias for $3;
wq Alias for $4;
addwp Alias for $5;
addwq Alias for $6;
md Alias for $7; ---0 - all losts, 1 - only active, 2 - only reactive
dtb Alias for $8;
dte Alias for $9;
idpeqp Alias for $10;
r record;
test record;
add_wp int;
add_wq int;
w_p int;
w_pd int;
w_q int;
w_qd int;
d_wp int;                              
d_wq int;
dwp int;
dwq int;
rs text;
wp_xx int;
wp1 int;
wq1 int;
wp_wp1 numeric;
wq_wq1 numeric;
cnt_wp1 int;
sumlta_xx int;
sumlta_kz int;
sumltr_xx int;
sumltr_kz int;
d_wp1 int;
d_wq1 int;
d int;
koef_graf numeric;

doubl_ins record;
-- split_part(text,text,int)::text

begin 
koef_graf=1.17;
raise notice ''+++++++++++++++++++++++clc_lost_eqp+++++++++++++++++++++++++++'';
raise notice ''start   clc_lost_eqp (idpnt,ideqp ,wp , wq , addwp ,addwq ,md ,dtb,dte,idpeqp )'';
raise notice ''start   clc_lost_eqp (%,%,%,%,%,%,%,%,%,%)'',idpnt,ideqp ,wp , wq , addwp ,addwq ,md ,dtb,dte,idpeqp;


dwp:=0;
dwq:=0;
d_wp:=0;
d_wq:=0;
d_wp1:=0;
d_wq1:=0;

select into w_pd sum(a.sum_demand) from act_pwr_demand_tbl as a 
    inner join (select a1.* from act_point_branch_tbl as a1 inner join 
     act_losts_eqm_tbl as a2 on (a1.id_point=a2.id_point)
     where a1.id_p_point=idpnt and a2.id_eqp=ideqp) as b 
      on (a.id_point=b.id_point) where a.kind_energy=1 and ident<>2 
           and a.dat_b=dtb and a.dat_e=dte; 

if w_pd is null then
  w_pd:=0;
end if;

--raise notice ''idpnt % ,ideqp % ,wp %, wq % , addwp %, addwq %, w_pd  %'',idpnt,ideqp ,wp , wq , addwp ,addwq ,w_pd;

select into w_qd sum(a.sum_demand) from act_pwr_demand_tbl as a 
    inner join (select a1.* from act_point_branch_tbl as a1 inner join 
     act_losts_eqm_tbl as a2 on (a1.id_point=a2.id_point)
     where a1.id_p_point=idpnt and a2.id_eqp=ideqp) as b 
      on (a.id_point=b.id_point) where a.kind_energy=2 and ident<>2; 

if w_qd is null then
  w_qd:=0;
end if;
if idpnt=158425 then
Raise Notice ''reactiv  pnt - %  w_qd - %'',idpnt,w_qd ;
end if;

w_p:=wp-w_pd;
w_q:=wq-w_qd;
add_wp:=addwp;
add_wq:=addwq;

for r in select distinct a.*
      ,round(b.wtm*round(date_mi_nol(date_smaller(a.dat_e,dte),date_larger(a.dat_b,dtb))::numeric/ 
       date_mi_nol(dte,dtb) ,2),0) as tw
      ,round(date_mi_nol(date_smaller(a.dat_e,dte),date_larger(a.dat_b,dtb))::numeric/date_mi_nol(dte,dtb),2) as dt_perc
       from act_losts_eqm_tbl as a
        inner join (select id_point,sum(round(wtm*(date_mi_nol(date_smaller(dat_e,dte),date_larger(dat_b,dtb))::numeric/date_mi_nol(dat_e,dat_b)),0)) as wtm 
          from act_pnt_wtm where id_point=idpnt group by id_point) as b  
           on (a.id_point=b.id_point) 
         where a.id_point=idpnt and id_eqp=ideqp 
           and coalesce(a.id_p_eqp,0)=coalesce(idpeqp,0) loop
                     
     Raise Notice ''   pnt - %  idpeqp- %  r.tw - %  r.dt_pers - % r.wp_own %'',idpnt,idpeqp,r.tw,r.dt_perc,r.own_wp;
    if r.tw=0 then
   --     return null; -------    
     Raise exception ''Для точки учета  с кодом  % не указано рабочих часов в месяц'',idpnt;
    end if;
       raise notice ''r.sn_len  % r.tw  % r.dt_perc  % wp1 % wq1 %'',r.sn_len,r.tw,r.dt_perc,w_p,w_q;

    if (r.type_eqm=2) then
      wp1:=r.sum_wp+r.own_wp;
       raise notice ''wp1 %'',wp1;
      wq1:=r.sum_wq;
       raise notice ''test 0 r.sn_len  % r.tw  % r.dt_perc  % wp1 % wq1 %'',r.sn_len,r.tw,r.dt_perc,wp1,wq1;
      if wp1=0 then
        select into cnt_wp1 count(code_eqp) from act_eqp_branch_tbl where code_eqp
              =ideqp and id_client=(select distinct id_client from act_point_branch_tbl 
               where id_point=idpnt);
        if cnt_wp1<>0 then
         wp_wp1:=1;
        else 
         wp_wp1:=0;
        end if;
      else
       wp_wp1:=w_p/wp1::numeric;
      end if;
      if wq1=0 then
       select into cnt_wp1 count(code_eqp) from act_eqp_branch_tbl where code_eqp
              =ideqp and id_client=(select distinct id_client from act_point_branch_tbl 
               where id_point=idpnt);
       if cnt_wp1<>0 then
         wq_wq1:=1;
       else 
        wq_wq1:=0;
       end if;
      else
       wq_wq1:=w_q/wq1::numeric;
      end if;
      if md<>2 then
        sumlta_xx:=round(round(r.pxx_r0::numeric*r.tt,0)*wp_wp1,0)::int;
       if (r.sn_len*r.tw)<>0 then
         if not (w_p=0 and w_q=0) then
          sumlta_kz:=round(koef_graf*(round(w_p*r.dt_perc,0)::bigint*round(w_p*r.dt_perc,0)::bigint+round(w_q*r.dt_perc,0)::bigint*round(w_q*r.dt_perc,0)::bigint)/(r.sn_len::bigint*r.sn_len::bigint*r.tw)::numeric*r.pkz_x0,0)::int;
         else
          sumlta_kz:=0;
         end if;
       else 
         Raise exception ''Для оборудования  с кодом  % не указаны все расч.параметры'',ideqp;
       end if;
       d_wp:=sumlta_xx+sumlta_kz;
      end if;
      if md<>1 then 
       if w_qd=0 and w_pd<>0 then
        sumltr_xx:=round(round(r.sn_len::bigint/100::numeric*r.ixx*r.tt,0)*wp_wp1 --*wq_wq1
         ,0)::int;
        if not (w_p=0 and w_q=0) then
         sumltr_kz:=round(koef_graf*(round(wp*r.dt_perc,0)::bigint*round(wp*r.dt_perc,0)::bigint+round(w_q*r.dt_perc,0)::bigint*round(w_q*r.dt_perc,0)::bigint)/(r.sn_len::bigint*r.tw*100)::numeric*r.ukz_un*koef_graf,0)::int;
        else
         sumltr_kz:=0;
        end if;
       else
        sumltr_xx:=round(round(r.sn_len::bigint/100::numeric*r.ixx*r.tt,0)*wp_wp1 --*wq_wq1
          ,0)::int;
        sumltr_kz:=round(koef_graf*(round(w_p*r.dt_perc,0)::bigint*round(w_p*r.dt_perc,0)::bigint+round(w_q*r.dt_perc,0)::bigint*round(w_q*r.dt_perc,0)::bigint)/(r.sn_len::bigint*r.tw*100)::numeric*r.ukz_un,0)::int;
       end if;
       d_wq:=sumltr_xx+sumltr_kz;
      end if;
 
      add_wp:=add_wp+coalesce(d_wp,0);
      add_wq:=add_wq+coalesce(d_wq,0);
      RAISE NOTICE ''WP %  INSERT W_Q  % '',W_P,W_Q;
      if md<>2 then
       insert into act_calc_losts_tbl 
        values (r.id_point,r.id_eqp,(case when r.id_p_eqp is null then 1 else 
        (select distinct num+1 from act_calc_losts_tbl where id_eqp=r.id_p_eqp 
        and id_point=idpnt and kind_energy=1 and dat_b<r.dat_e and dat_e>r.dat_b) end)
       ,case when r.dat_b<=dtb then dtb else r.dat_b end 
       ,case when r.dat_e>=dte then dte else r.dat_e end 
       ,r.type_eqm,r.id_type_eqp
       ,r.sn_len,r.tt,r.tw,r.pxx_r0,r.pkz_x0,r.ixx,r.ukz_un --,w_p,w_q
       ,round(w_p*r.dt_perc,0),round(w_q*r.dt_perc,0)
       ,r.sum_wp+r.own_wp,sumlta_xx,sumlta_kz,1,d_wp,r.res_l);
      end if;
      if md<>1 then
        insert into act_calc_losts_tbl 
        values (r.id_point,r.id_eqp,(case when r.id_p_eqp is null then 1 else 
        (select distinct num+1 from act_calc_losts_tbl where id_eqp=r.id_p_eqp 
        and id_point=idpnt and kind_energy=2 and dat_b<r.dat_e and dat_e>r.dat_b) end)
        ,case when r.dat_b<=dtb then dtb else r.dat_b end 
        ,case when r.dat_e>=dte then dte else r.dat_e end 
        ,r.type_eqm,r.id_type_eqp
        ,r.sn_len,r.tt,r.tw,r.pxx_r0,r.pkz_x0,r.ixx,r.ukz_un
        ,round(w_p*r.dt_perc,0),round(w_q*r.dt_perc,0)
        ,r.sum_wp+r.own_wp,sumltr_xx,sumltr_kz,2,d_wq,r.res_l);
      end if;
    else
      if not (w_p=0 and w_q=0) then
       w_p:=w_p+addwp;
       w_q:=w_q+addwq;
      end if;
      RAISE NOTICE ''1 WP %  INSERT W_Q  % '',W_P,W_Q;
      if ((md=1) and (coalesce(w_q,0)=0)) then
       select into w_q sum(w__p) from (select round(round(w_p::numeric/date_mi_nol(dte::date
       ,dtb::date)*date_mi_nol(date_smaller(b.dat_e,dte)::date,date_larger(b.dat_b,dtb)::date),0)*c.value,0) as w__p 
              from act_pnt_tg as b,eqk_tg_tbl as c where b.id_point=idpnt 
                 and b.id_tg=c.id) as a;
          RAISE NOTICE ''1-1 WP %  INSERT W_Q  %   MD % '',W_P,W_Q,MD;
      end if;
      if md<>2 then
        if not (w_p=0 and w_q=0) then
          if ((r.ukz_un::bigint*r.ukz_un::bigint*r.tw)!=0) then
           d_wp:=round(koef_graf*(round(w_p*r.dt_perc,0)::bigint*round(w_p*r.dt_perc,0)::bigint+round(w_q*r.dt_perc,0)::bigint*round(w_q*r.dt_perc,0)::bigint)/(r.ukz_un::bigint*r.ukz_un::bigint*r.tw)::numeric*r.pxx_r0*r.sn_len,0)::int; 
          else 
           if r.tw =0 then
            Raise Notice ''Time_work not present'';
            insert into act_res_notice values(''Нет времени работы для точки ''||r.id_point);
             raise exception ''Нет времени работы для точки %'',r.id_point;
             Return rs;                     
           end if;
           if r.ukz_un =0 then
            Raise Notice ''Not parameter'';
            insert into act_res_notice values(''Справочник оборудования, что-то не заполнено    ''||r.id_point);
             raise exception ''Справочник оборудования, что-то не заполнено % '',r.id_point;
            Return rs;        
           end if;
          end if;
        else 
          d_wp:=0;
        end if;
      end if;
      if md<>1 then
        if r.type_eqm=7 then
          if w_qd=0 and w_pd<>0 then
            if not (w_p=0 and w_q=0) then
             d_wq:=round(koef_graf*(round((w_p+w_pd)*r.dt_perc,0)::bigint*round((w_p+w_pd)*r.dt_perc,0)::bigint+round(w_q*r.dt_perc,0)::bigint*round(w_q*r.dt_perc,0)::bigint)/(r.ukz_un::bigint*r.ukz_un::bigint*r.tw)::numeric*r.pkz_x0*r.sn_len,0)::int;
            else 
             d_wq:=0;
            end if;
          else
           d_wq:=round(koef_graf*(round(w_p*r.dt_perc,0)::bigint*round(w_p*r.dt_perc,0)::bigint+round(w_q*r.dt_perc,0)::bigint*round(w_q*r.dt_perc,0)::bigint)/(r.ukz_un::bigint*r.ukz_un::bigint*r.tw)::numeric*r.pkz_x0*r.sn_len,0)::int;
          end if;
        end if;
      end if;
 
      if md<>2 then 
        raise notice ''r.id_point,  %'',r.id_point;
        raise notice ''r.id_p_eqp,  %'',r.id_p_eqp;
      RAISE NOTICE ''2 WP %  INSERT W_Q  % '',W_P,W_Q;
        insert into act_calc_losts_tbl 
        select a.id_point,a.id_eqp,a.num,a.dat_b,a.dat_e,
          a.type_eqm,a.id_type_eqp,a.sn_len,a.tt,a.tw,a.pxx_r0,a.pkz_x0,a.ixx
         ,a.ukz_un
         ,a.wp34
         ,a.wq34
         ,a.wp1p
         ,a.s_xx_addwp
         ,a.s_kz_addwq
         ,a.kind_energy,     a.dw,r.res_l
         from 
         ( select distinct r.id_point as id_point,r.id_eqp as id_eqp
             ,(case when r.id_p_eqp is null then 1 else
                ( select distinct num+1 from act_calc_losts_tbl
                  where id_eqp=r.id_p_eqp
                   and id_point=idpnt and kind_energy=1
                   and dat_b<r.dat_e and dat_e>r.dat_b
                )
              end)::int as num
           ,(case when r.dat_b<=dtb then dtb else r.dat_b end)::date as dat_b
          ,(case when r.dat_e>=dte then dte else r.dat_e end)::date as dat_e
          ,r.type_eqm as type_eqm, r.id_type_eqp as id_type_eqp
          ,r.sn_len as sn_len ,r.tt as tt,r.tw as tw,r.pxx_r0 as pxx_r0,
           r.pkz_x0 as pkz_x0,r.ixx as ixx
          ,r.ukz_un  as ukz_un
          ,(coalesce(round(w_p*r.dt_perc,0),0))::int as wp34 
          ,(coalesce(round(w_q*r.dt_perc,0),0))::int as wq34
          ,(1-1)::int as wp1p
          ,addwp::int as s_xx_addwp 
          ,addwq::int as s_kz_addwq
          ,1::int as kind_energy, d_wp as dw
         ) as a
         left join act_calc_losts_tbl ac 
         on (ac.id_point=a.id_point and ac.id_eqp=a.id_eqp  and a.dat_b=ac.dat_b)
         where ac.id_point is null; 
      end if;
    
      if md<>1 then 
        if r.type_eqm=7 then
          insert into act_calc_losts_tbl
          values (r.id_point,r.id_eqp,(case when r.id_p_eqp is null then 1 else 
          (select distinct num+1 from act_calc_losts_tbl where id_eqp=r.id_p_eqp 
          and id_point=idpnt and kind_energy=2 and dat_b<r.dat_e and dat_e>r.dat_b) end)
          ,case when r.dat_b<=dtb then dtb else r.dat_b end 
          ,case when r.dat_e>=dte then dte else r.dat_e end 
          ,r.type_eqm,r.id_type_eqp
          ,r.sn_len,r.tt,r.tw,r.pxx_r0,r.pkz_x0,r.ixx,r.ukz_un --,w_p,w_q
          ,round(w_p*r.dt_perc,0),round(w_q*r.dt_perc,0)
          ,0,addwp
          ,addwq,2,d_wq,r.res_l);
        end if;
      end if;
    end if;
  end loop;
 RAISE NOTICE ''3 WP %  INSERT W_Q  % '',W_P,W_Q;  
update act_calc_losts_tbl set num=1 where num is null;



  RAISE NOTICE ''3 WP %  INSERT W_Q  % '',W_P,W_Q;  

  for test in select * from act_calc_losts_tbl  where id_point=idpnt  loop
             --raise notice ''3  test.id_point    %   dw  % kind_energy %, in_demand %,wp1 %'',test.id_point, test.dw,test.kind_energy,test.in_demand,test.wp_1;
  end loop;

  update act_calc_losts_tbl set in_demand=a.in_demand 
 from (select id_point,id_eqp,num,dat_b,dat_e,type_eqm,id_type_eqp,kind_energy,max(in_demand) as in_demand 
        from act_calc_losts_tbl group by id_point,id_eqp,num,dat_b,dat_e,type_eqm,id_type_eqp,kind_energy,dw) a
   where act_calc_losts_tbl.id_point=a.id_point and act_calc_losts_tbl.id_eqp=a.id_eqp 
        and act_calc_losts_tbl.kind_energy=a.kind_energy 
        and act_calc_losts_tbl.num=a.num and act_calc_losts_tbl.dat_b=a.dat_b 
       and act_calc_losts_tbl.dat_e=a.dat_e and act_calc_losts_tbl.type_eqm=a.type_eqm 
        and act_calc_losts_tbl.id_type_eqp=a.id_type_eqp 
     ;


  for test in select * from act_calc_losts_tbl  where id_point=idpnt  loop
             raise notice ''4  test.id_point    %   dw  % kind_energy %, in_demand % wp1 %'',test.id_point, test.dw,test.kind_energy,test.in_demand,test.wp_1;
  end loop;
   
  delete from act_calc_losts2_tbl;
  insert into act_calc_losts2_tbl select distinct *  from act_calc_losts_tbl; 
  delete from act_calc_losts_tbl;
  insert into act_calc_losts_tbl select distinct * from act_calc_losts2_tbl;
 
--Raise Notice ''-++++++wp+wq - %'',wp;

-- calc losts 
  for r in select distinct id_point,id_eqp,id_p_eqp from act_losts_eqm_tbl where id_point=idpnt 
            and id_p_eqp=ideqp loop
    if ((wp+wq>0) or (md=1)) then 
      rs:=clc_lost_eqp(r.id_point,r.id_eqp,wp,wq,add_wp,add_wq,md,dtb,dte,r.id_p_eqp);
      dwp:=dwp+split_part(rs,'';'',1)::int;
      dwq:=dwq+split_part(rs,'';'',2)::int;
    end if;
  end loop;
  rs:=coalesce((d_wp1+dwp),0)::text||'';''||coalesce((d_wq1+dwq),0)::text;
  Raise Notice ''md - %'',md;
 /* Raise Notice ''DWP1 - %'',d_wp1;
  Raise Notice ''DWQ - %'',d_wQ;
  Raise Notice ''DWQ1 - %'',d_wQ1;
   */

 for test in select * from act_calc_losts_tbl order by id_point,kind_energy,dat_b,dat_e loop
      raise notice ''21 test.id_point  % ,DAT_B  %, DAT_E %, KIND_ENERGY % ,WP %,  WQ % in_demand %'',test.id_point,test.dat_b,test.dat_e,test.kind_energy,test.W_P,test.W_Q,test.in_demand;

 end loop;

     
  update act_calc_losts_tbl set in_demand=a.in_demand 
  from (select id_point,id_eqp,num,dat_b,dat_e,type_eqm,id_type_eqp,kind_energy,max(in_demand) as in_demand 
        from act_calc_losts_tbl group by id_point,id_eqp,num,dat_b,dat_e,type_eqm,kind_energy,id_type_eqp) a
   where act_calc_losts_tbl.id_point=a.id_point and act_calc_losts_tbl.id_eqp=a.id_eqp 
        and act_calc_losts_tbl.num=a.num and act_calc_losts_tbl.dat_b=a.dat_b  and act_calc_losts_tbl.kind_energy=a.kind_energy 
       and act_calc_losts_tbl.dat_e=a.dat_e and act_calc_losts_tbl.type_eqm=a.type_eqm and act_calc_losts_tbl.id_type_eqp=a.id_type_eqp 
        ;

       
  delete from act_calc_losts2_tbl;
  insert into act_calc_losts2_tbl select  * from act_calc_losts_tbl;
  delete from act_calc_losts_tbl;
  insert into act_calc_losts_tbl select distinct * from act_calc_losts2_tbl;

  Raise Notice ''TEST '';

 for test in select * from act_calc_losts_tbl order by id_point,kind_energy,dat_b,dat_e loop
      raise notice ''22 test.id_point  % ,DAT_B  %, DAT_E %, KIND_ENERGY % ,WP %,  WQ % in_demand %  wp1 %'',test.id_point,test.dat_b,test.dat_e,test.kind_energy,test.W_P,test.W_Q,test.in_demand,test.wp_1;

 end loop;
  

Return rs;
end;
' Language 'plpgsql';












/*
 ''2 test.id_point  % ,DAT_B  %, DAT_E %, KIND_ENERGY % ,WP %,  WQ % in_demand %'',test.id_point,test.dat_b,test.dat_e,test.kind_energy,test.W_P,test.W_Q,test.in_demand;

 end loop;


Return rs;
end;
' Language 'plpgsql';



  */










