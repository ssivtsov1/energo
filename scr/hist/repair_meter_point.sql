
--Восстановление потерянных строк в таблице eqm_meter_point_h


  CREATE or replace FUNCTION sel_meterpnt_upd_fun()
  RETURNS int
  AS                                                                                              
  '
  declare
--   pdt Alias for $1;
   veqp int;
   r record;
   rr record;
   vareas_noprom10k int;
   vabons_sh int;
   vabons_noprom10k int;
   vareas record;
   vareas_sh int;
   vpoints record;
   vsh record;
   vpoint_noprom10k record;
   vprom  record;
  begin

   delete from eqm_meter_point_h where id_point is null;


    insert into eqm_meter_point_h (id_meter,dt_b)
    select distinct eq.id, coalesce((select max(dt_e) from eqm_meter_point_h as mp3 where mp3.id_meter = mp.id_meter and mp.id_point is not null),eq.dt_install) as dt_install  
    from eqm_equipment_tbl as eq 
    left join  eqm_meter_point_h as mp on (mp.id_meter =eq.id )
    where eq.type_eqp = 1 and 
     (mp.id_point is null or not exists (select * from eqm_meter_point_h as mp2 where mp2.id_meter = mp.id_meter and mp2.dt_e is null)) ;


    for r in select h.*, tt.code_eqp_e
     from eqm_meter_point_h as h join eqm_eqp_tree_tbl as tt on (tt.code_eqp = h.id_meter)
     where h.id_point is null
    loop

     Raise Notice ''Start %'',r.id_meter;

     veqp :=r.code_eqp_e;


      LOOP

       select into rr tt.code_eqp,tt.code_eqp_e, eq.type_eqp 
       From eqm_equipment_tbl AS eq 
       join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
       where (tt.code_eqp = veqp)  limit 1;


--       Raise Notice ''Start2  %'',rr.code_eqp;

--       EXIT WHEN ( rr.type_eqp = 12 or rr.code_eqp_e is null );   
       EXIT WHEN ( rr.type_eqp <> 10 or rr.code_eqp_e is null );   

       veqp = rr.code_eqp_e;

      END LOOP;


      if (rr.type_eqp = 12) then

        update eqm_meter_point_h set id_point = rr.code_eqp
        where id_meter = r.id_meter;
 
      end if;


    END LOOP;



  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          




select sel_meterpnt_upd_fun();


