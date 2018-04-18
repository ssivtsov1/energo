  CREATE or replace FUNCTION rep_monitor_a2a3_fun(date)
  RETURNS int
  AS                                                                                              
  '
  declare
   pdt Alias for $1;

   vdef_addr_type bool;
   vid_res int; 
  BEGIN

   delete from rep_points_info_tmp;

   insert into rep_points_info_tmp(id_client,id_point,demand,dat_e)
   select b.id_client, bs.id_point, sum(bs.demand_val) as demand_all , max(b.dat_e) as dat
   from 
   (select * from acm_bill_tbl where ((id_pref = 10) and (idk_doc<>280)) or (id_pref=101) order by id_doc) as b join 
   (select * from acd_billsum_tbl where demand_val <> 0 and  date_part(''year'',mmgg ) = date_part(''year'',pdt::date )-1 
    order by id_doc 
   ) as bs on (bs.id_doc = b.id_doc) 
   join clm_client_tbl as c on (c.id = b.id_client) 
   join clm_statecl_tbl as scl on (c.id = scl.id_client) 
   where scl.id_section not in (205,206,207,208) 
   and coalesce(bs.id_tariff,900001) not in (900001,900002) 
   group by bs.id_point, b.id_client;


   update rep_points_info_tmp  set is_town = ap.is_town, is_subabon = ap.is_subabon, voltage = ap.voltage, id_area = ap.id_area
   from rep_areas_points_tbl as ap where 
   ap.id_point  = rep_points_info_tmp.id_point and ap.id_client  = rep_points_info_tmp.id_client;


   if (select getsysvar(''kod_res'')) = 310 then
      vdef_addr_type :=true;
   else
      vdef_addr_type :=false;
   end if;

   vid_res:= syi_resid_fun() ;

   update rep_points_info_tmp set id_area = area.id,  is_town = coalesce(kt.flag_type , vdef_addr_type)
    from eqm_compens_station_inst_h as inst 
    join eqm_equipment_h as area on (inst.code_eqp_inst = area.id and area.type_eqp = 11)
    left join adm_address_tbl as a on (a.id = area.id_addres)
    left join adi_street_tbl as s on (s.id = a.id_street)
    left join adi_town_tbl as t on (t.id = s.id_town)
    left join adk_town_tbl as kt on (kt.id = t.idk_town)
    where inst.code_eqp= rep_points_info_tmp.id_point
    and area.dt_b = (select max(dt_b) from eqm_equipment_h where id = area.id and dt_b <= rep_points_info_tmp.dat_e )
    and inst.dt_b = (select max(dt_b) from eqm_compens_station_inst_h where code_eqp = inst.code_eqp and code_eqp_inst = inst.code_eqp_inst and  dt_b <= rep_points_info_tmp.dat_e )
    and rep_points_info_tmp.is_town is null;


   update rep_points_info_tmp set voltage = p.id_voltage
   from eqm_point_h as p 
    where p.code_eqp= rep_points_info_tmp.id_point   
    and p.dt_b = (select max(dt_b) from eqm_point_h where code_eqp = p.code_eqp and dt_b <= rep_points_info_tmp.dat_e )
    and rep_points_info_tmp.voltage is null;
    

   update rep_points_info_tmp set is_subabon = CASE WHEN (b.code_eqp is not null ) and (b.id_clienta <> vid_res ) THEN 1 ELSE 0 END 
   from 
   eqm_eqp_tree_h as tt 
   join eqm_tree_h as t on (tt.id_tree = t.id) 
   left join eqm_borders_h as b on (b.code_eqp = t.code_eqp) 
   where tt.code_eqp= rep_points_info_tmp.id_point   
    and rep_points_info_tmp.is_subabon is null
    and tt.dt_b = (select max(dt_b) from eqm_eqp_tree_h where code_eqp = tt.code_eqp and dt_b <= rep_points_info_tmp.dat_e )
    and t.dt_b = (select max(dt_b) from eqm_tree_h where id = t.id and dt_b <= rep_points_info_tmp.dat_e )
    and (b.dt_b = (select max(dt_b) from eqm_borders_h where code_eqp = b.code_eqp and dt_b <= rep_points_info_tmp.dat_e ) or (b.dt_b is null));


   update rep_points_info_tmp set is_subabon=0 where is_subabon is null;
   update rep_points_info_tmp set voltage=4 where voltage is null;
   update rep_points_info_tmp set is_town = vdef_addr_type where is_town is null;


  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
