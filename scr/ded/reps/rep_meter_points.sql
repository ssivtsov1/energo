  CREATE or replace FUNCTION rep_meter_pnt_fun(date)
  RETURNS int
  AS                                                                                              
  '
  declare
   pdt Alias for $1;
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

   delete from rep_meter_points_tbl;


   insert into rep_meter_points_tbl (id_client,id_meter,id_type_meter)
    select c.id, p.code_eqp, p.id_type_eqp
    from eqm_tree_h as tr
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by id) as tr2 on (tr.id = tr2.id and tr2.dt = tr.dt_b)
    join eqm_eqp_tree_h as ttr on (tr.id = ttr.id_tree)
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp) as ttr2 on (ttr.code_eqp = ttr2.code_eqp and ttr2.dt = ttr.dt_b)
    join eqm_meter_h as p on (ttr.code_eqp = p.code_eqp)
    join (select code_eqp, max(dt_b) as dt from eqm_meter_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp) as p2 on (p.code_eqp = p2.code_eqp and p2.dt = p.dt_b)
    left join 
    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp ) as u2
     on (u1.code_eqp = u2.code_eqp and u2.dt = u1.dt_b) 
    ) as use on (use.code_eqp = p.code_eqp)
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))
--    left join clm_client_tbl as c on (c.id = tr.id_client)
    left join clm_statecl_tbl as scl on (c.id = scl.id_client)
    where scl.id_section not in (205,206,207,208) 
    and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)
    and c.book=-1;


    for r in select * from rep_meter_points_tbl
    loop

     Raise Notice ''Start %'',r.id_meter;

     veqp :=r.id_meter;


      LOOP

       select into rr tt.code_eqp,tt.code_eqp_e, eq.type_eqp 
       From eqm_equipment_h AS eq 
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id )
       where (tt.code_eqp = veqp)  
       and eq.dt_b <= pdt and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt and coalesce(eq.dt_e,pdt) >= pdt
       order by tt.dt_b,eq.dt_b limit 1;


--       Raise Notice ''Start2  %'',rr.code_eqp;

       EXIT WHEN ( rr.type_eqp = 12 or rr.code_eqp_e is null );   

       veqp = rr.code_eqp_e;

      END LOOP;


      if (rr.type_eqp = 12) then

        update rep_meter_points_tbl set id_point = rr.code_eqp
        where id_meter = r.id_meter;
 
      end if;


    END LOOP;


    update rep_meter_points_tbl set id_area = area.id
    from eqm_compens_station_inst_h as inst 
    join (select code_eqp, max(dt_b) as dt from eqm_compens_station_inst_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp) as inst2 on (inst.code_eqp = inst2.code_eqp and inst2.dt = inst.dt_b)
    join eqm_equipment_h as area on (inst.code_eqp_inst = area.id and area.type_eqp = 11)
    join (select id, max(dt_b) as dt from eqm_equipment_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by id) as area2 on (area.id = area2.id and area2.dt = area.dt_b)
    where inst.code_eqp= rep_meter_points_tbl.id_point;


  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
