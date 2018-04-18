CREATE TABLE rep_power_abons_tbl
(
  id serial NOT NULL,
  id_department integer,
  code_eqp integer NOT NULL,
  idk_abon integer,
  cnt integer,
  power numeric(12,2),
  power_calc numeric(12,2),
  CONSTRAINT rep_power_abons_tbl_pkey PRIMARY KEY (id)
);


--select crt_ttbl();

CREATE OR REPLACE FUNCTION rep_power_abons_fun( integer, integer)
  RETURNS integer AS
$BODY$
Declare
  pid_res  Alias for $1;
  pbuild   Alias for $2;
 
 rr record;
begin
 
 if pbuild = 1 then 
   perform  bal_abon_find_fun(  ) ;
 end if; 
 
 perform rep_lighting_dubl_fun( );

 delete from rep_power_abons_tbl ;

 insert into rep_power_abons_tbl(idk_abon,id_department,code_eqp,cnt,power,power_calc)
 select 1, pid_res, id_grp , count(distinct c.id ), sum(p.power), sum(p.power) as power_roz
 from bal_abons_tbl as ba  
   join clm_client_tbl as c on (c.id = ba.id_client  )  
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id  )  
   join eqm_equipment_h as eq on (eq.id = ba.id_point  and eq.dt_e is null )  
   join eqm_point_h as p on (p.code_eqp = ba.id_point  and p.dt_e is null )  
   left join rep_lighting_points_tmp as lp on (lp.id_point = ba.id_point)  
   where  c.book = -1 and 
    coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0,99) 
  and coalesce(c.id_state,0) not in (50,99) and id_grp is not null and p.reserv=0 and lp.id_point is null 
 group by id_grp ;


   insert into rep_power_abons_tbl(idk_abon,id_department,code_eqp,cnt,power,power_calc)
   select 2,  pid_res,   id_grp,fiz1.cnt,fiz1.power,  ((fiz1.power-0.58*fiz1.cnt)*coalesce(cf.val,0.005) + 0.58*fiz1.cnt) as power_roz
    from  
   ( select id_grp, count(distinct ba.id_client) as cnt, sum( c.set_power) as power  
   from bal_abons_tbl as ba  
   join clm_pclient_tbl as c on (c.id = ba.id_client  )  
   where  id_grp is not null and coalesce(c.cod_tarif,0) not in (37,48) and coalesce(c.cod_zone,0) in (0) and coalesce(c.id_state,0)<>50  
   group by id_grp ) as fiz1  
   left join bal_fizabon_coef_tbl as cf on (cf.type = 1 and cf.cnt = fiz1.cnt  ) ;


   insert into rep_power_abons_tbl(idk_abon,id_department,code_eqp,cnt,power,power_calc)
   select 3, pid_res, id_grp, fiz2.cnt,fiz2.power,  ((fiz2.power-1.31*fiz2.cnt)*coalesce(cf.val,0.001) + 1.31*fiz2.cnt) as power_roz
   from  
   ( select id_grp, count(distinct ba.id_client) as cnt, sum( c.set_power) as power  
   from bal_abons_tbl as ba  
   join clm_pclient_tbl as c on (c.id = ba.id_client  )  
   where id_grp is not null and coalesce(c.cod_tarif,0) =37 and coalesce(c.cod_zone,0) in (0) and coalesce(c.id_state,0)<>50  
   group by id_grp ) as fiz2  
   left join bal_fizabon_coef_tbl as cf on (cf.type = 2 and cf.cnt = fiz2.cnt  ) ; 



   insert into rep_power_abons_tbl(idk_abon,id_department,code_eqp,cnt,power,power_calc)
   select 4,  pid_res,  id_grp, count(distinct ba.id_client), sum( c.set_power) , sum( c.set_power) 
   from bal_abons_tbl as ba  
   join clm_pclient_tbl as c on (c.id = ba.id_client )  
   where id_grp is not null and coalesce(c.cod_tarif,0) =48 and coalesce(c.cod_zone,0) in (0) and coalesce(c.id_state,0)<>50  
   group by id_grp   ; 

 Return 1;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;

--select rep_power_abons_fun( 17, 0);
--select * from rep_power_abons_tbl;