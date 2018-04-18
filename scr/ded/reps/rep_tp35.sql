--функция выбирает фидер, и ТП35/100 для каждого абонента на основе bal_abons_tbl
CREATE OR REPLACE FUNCTION rep_abons_connect_find()
  RETURNS int AS
$BODY$
  begin


delete from rep_abons_connect_tmp;

insert into rep_abons_connect_tmp (id_client,id_point,id_ps10)
select p.id_client,p.code_eqp,ps.id as id_ps10 from 
 eqm_equipment_tbl as ps  
 join eqm_compens_station_tbl as cs on (cs.code_eqp = ps.id)  
 join eqm_area_tbl as a on (a.code_eqp = cs.code_eqp)  
 join clm_client_tbl as c on (c.id = a.id_client )  
 join  
 (select ba.id_point as code_eqp,ba.id_grp,ba.id_client,eqp.power,eqp.connect_power, eqp.safe_category  
  from bal_abons_tbl as ba  
  join eqm_point_tbl as eqp on (eqp.code_eqp = ba.id_point  )  
  join clm_client_tbl as c on (c.id = ba.id_client )  
  where coalesce(eqp.reserv,0)=0 and coalesce(eqp.share,0)=0 
  and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)  
  ) as p  on (ps.id = p.id_grp )  
 where  ps.type_eqp=8 and cs.id_voltage in (3,31,32)   
 and exists (select csi.code_eqp from eqm_compens_station_inst_tbl as csi where csi.code_eqp_inst = ps.id)  
 and ((c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)) or (a.id_client = a.id_department))  ;


insert into rep_abons_connect_tmp (id_client,id_point,id_fider)
select p.id_client,p.code_eqp,ps.id as id_fider from 
 eqm_equipment_tbl as ps  
 --join eqm_area_tbl as a on (a.code_eqp = ps.id)  
 --join clm_client_tbl as c on (c.id = a.id_client )  
 join  
 (select ba.id_point as code_eqp,ba.id_grp,ba.id_client,eqp.power,eqp.connect_power, eqp.safe_category  
  from bal_abons_tbl as ba  
  join eqm_point_tbl as eqp on (eqp.code_eqp = ba.id_point  )  
  join clm_client_tbl as c on (c.id = ba.id_client )  
  where coalesce(eqp.reserv,0)=0 and coalesce(eqp.share,0)=0 
  and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)  
  ) as p  on (ps.id = p.id_grp )  
 where  ps.type_eqp=15 ;
 --and exists (select csi.code_eqp from eqm_compens_station_inst_tbl as csi where csi.code_eqp_inst = ps.id)  
 --and ((c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)) or (a.id_client = a.id_department))  ;


insert into rep_abons_connect_tmp (id_client,id_point,id_ps35)
select p.id_client,p.code_eqp,ps.id as id_ps35 from 
 eqm_equipment_tbl as ps  
 join eqm_compens_station_tbl as cs on (cs.code_eqp = ps.id)  
 join eqm_area_tbl as a on (a.code_eqp = cs.code_eqp)  
 --join clm_client_tbl as c on (c.id = a.id_client )  
 join  
 (select ba.id_point as code_eqp,ba.id_grp,ba.id_client,eqp.power,eqp.connect_power, eqp.safe_category  
  from bal_abons_tbl as ba  
  join eqm_point_tbl as eqp on (eqp.code_eqp = ba.id_point  )  
  join clm_client_tbl as c on (c.id = ba.id_client )  
  where coalesce(eqp.reserv,0)=0 and coalesce(eqp.share,0)=0 
  and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)  
  ) as p  on (ps.id = p.id_grp )  
 where  ps.type_eqp=8 and cs.id_voltage in (1,2,11,12,21)
-- and exists (select csi.code_eqp from eqm_compens_station_inst_tbl as csi where csi.code_eqp_inst = ps.id)  
 and a.id_client = a.id_department ;



insert into rep_abons_connect_tmp (id_client,id_ps10)
select ba.id_client,ps.id as id_ps10 from 
 bal_abons_tbl as ba  
 join clm_pclient_tbl as c on (c.id = ba.id_client)  
 join eqm_equipment_tbl as ps on (ps.id = ba.id_grp )  
 join eqm_compens_station_tbl as cs on (cs.code_eqp = ps.id)  
 where coalesce(c.cod_zone,0) in (0) and coalesce(c.id_state,0)<>50  
 and   ps.type_eqp=8 and cs.id_voltage in (3,31,32);   
 


insert into rep_abons_connect_tmp (id_client,id_fider)
select ba.id_client,ps.id as id_fider from 
 bal_abons_tbl as ba  
 join clm_pclient_tbl as c on (c.id = ba.id_client)  
 join eqm_equipment_tbl as ps on (ps.id = ba.id_grp )  
  where coalesce(c.cod_zone,0) in (0) and coalesce(c.id_state,0)<>50  
 and ps.type_eqp=15 ;
 

update rep_abons_connect_tmp set id_fider  = bal_fider_st_tbl.id_fider
from bal_fider_st_tbl where 
rep_abons_connect_tmp.id_ps10 = bal_fider_st_tbl.id_st 
and rep_abons_connect_tmp.id_fider is null;


update rep_abons_connect_tmp set id_ps35  = eqm_fider_tbl.id_station 
from eqm_fider_tbl where 
rep_abons_connect_tmp.id_fider = eqm_fider_tbl.code_eqp 
and rep_abons_connect_tmp.id_ps35 is null;

 return 0;

end;  

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


-------------------------------------------------------------------------------------------------


ALTER TABLE eqm_fider_tbl DISABLE TRIGGER user;

update eqm_fider_tbl set id_station = code_ps35 from
(
select distinct -- ssss.*, 
case when id_voltage in (1,2) and type_eqp = 8 then code_eqp 
     when id_voltage2 in (1,2) and type_eqp2 = 8 then code_eqp2 
     when id_voltage3 in (1,2) and type_eqp3 = 8 then code_eqp3 
     when id_voltage4 in (1,2) and type_eqp4 = 8 then code_eqp4 END as code_ps35, 
case when id_voltage in (1,2) and type_eqp = 8 then grpname 
     when id_voltage2 in (1,2) and type_eqp2 = 8 then grpname2 
     when id_voltage3 in (1,2) and type_eqp3 = 8 then grpname3 
     when id_voltage4 in (1,2) and type_eqp4 = 8 then grpname4 END as name_ps35, 
case when id_voltage in (3,31,32) and type_eqp = 15 then code_eqp 
     when id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
     when id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 
     when id_voltage4 in (3,31,32) and type_eqp4 = 15 then code_eqp4 END as code_f10, 
case when id_voltage in (3,31,32) and type_eqp = 15 then grpname 
     when id_voltage2 in (3,31,32) and type_eqp2 = 15 then grpname2 
     when id_voltage3 in (3,31,32) and type_eqp3 = 15 then grpname3 
     when id_voltage4 in (3,31,32) and type_eqp4 = 15 then grpname4 END as name_f10
from 
( 
  select  ee.name_eqp as grpname , 
  gr1.type_eqp, gr1.code_eqp, gr1.id_voltage , 
  gr2.type_eqp as type_eqp2, gr2.code_eqp as code_eqp2, gr2.id_voltage as id_voltage2, 
  gr3.type_eqp as type_eqp3, gr3.code_eqp as code_eqp3, gr3.id_voltage as id_voltage3, 
  gr4.type_eqp as type_eqp4, gr4.code_eqp as code_eqp4, gr4.id_voltage as id_voltage4, 
  ee2.name_eqp as grpname2,ee3.name_eqp as grpname3,ee4.name_eqp as grpname4 
from 
  eqm_equipment_tbl as ee
  join bal_grp_tree_tbl as gr1 on (gr1.code_eqp = ee.id and gr1.mmgg= '2013-02-01'::date) 
  left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= '2013-02-01'::date) 
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) 
  left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= '2013-02-01'::date) 
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) 
  left join bal_grp_tree_tbl as gr4 on (gr3.id_p_eqp = gr4.code_eqp and gr4.mmgg= '2013-02-01'::date) 
  left join eqm_equipment_tbl as ee4 on (ee4.id = gr4.code_eqp) 
  where gr1.type_eqp in (8,15)
  ) as ssss   
) as fst
where id_station is null and eqm_fider_tbl.code_eqp = fst.code_f10; 

ALTER TABLE eqm_fider_tbl ENABLE TRIGGER user;

update eqm_fider_h set id_station = eqm_fider_tbl.id_station
from eqm_fider_tbl 
where eqm_fider_h.id_station is null and eqm_fider_h.dt_e is null and eqm_fider_h.code_eqp = eqm_fider_tbl.code_eqp;
