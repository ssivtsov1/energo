delete from  eqm_tree_h;
delete from  eqm_eqp_tree_h;
delete from  eqm_equipment_h;
delete from  eqm_meter_h;
delete from  eqd_meter_zone_h;
delete from  eqd_meter_energy_h;
delete from  eqm_compens_station_h;
delete from  eqm_fider_h;
delete from  eqm_compens_station_inst_h;
delete from  eqm_compensator_h;
delete from  eqm_compensator_i_h;
delete from  eqm_line_a_h;
delete from  eqm_line_c_h;
delete from  eqm_jack_h;
delete from  eqm_switch_h;
delete from  eqm_fuse_h;
delete from  eqm_borders_h;
delete from  eqm_point_h;
delete from  eqm_area_h;
delete from  eqd_point_energy_h;
delete from  eqm_eqp_use_h;

-------------

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_equipment_tbl';

update eqm_equipment_tbl set dt_install =  eq.dt_install
from   eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (tt.code_eqp = eq.id)
where tt.code_eqp_e = eqm_equipment_tbl.id and eqm_equipment_tbl.dt_install is null;


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_equipment_tbl';

-------------

 insert into eqm_equipment_h  select *,dt_install  from eqm_equipment_tbl ;



 insert into eqm_tree_h
 select t.*,coalesce(eq.dt_install,'1900-01-01'::date)
 from eqm_tree_tbl as t left join eqm_equipment_tbl as eq on  (t.code_eqp = eq.id) ;


 insert into eqm_eqp_tree_h
 select tt.*, eq.dt_install  from  eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (eq.id= tt.code_eqp);



 insert into  eqm_meter_h
 select ed.*, eq.dt_install  from   eqm_meter_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_compens_station_h
 select ed.*, eq.dt_install  from   eqm_compens_station_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_fider_h 
 select ed.*, eq.dt_install  from   eqm_fider_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into   eqm_compensator_h
 select ed.*, eq.dt_install  from   eqm_compensator_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_compensator_i_h 
 select ed.*, eq.dt_install  from   eqm_compensator_i_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_line_a_h 
 select ed.*, eq.dt_install  from   eqm_line_a_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into eqm_line_c_h 
 select ed.*, eq.dt_install  from  eqm_line_c_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_jack_h 
 select ed.*, eq.dt_install  from   eqm_jack_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_switch_h 
 select ed.*, eq.dt_install  from   eqm_switch_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_fuse_h 
 select ed.*, eq.dt_install  from    eqm_fuse_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_borders_h 
 select ed.*, eq.dt_install  from    eqm_borders_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);

 insert into  eqm_point_h 
 select ed.*, eq.dt_install  from    eqm_point_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);


 insert into  eqm_area_h 
 select ed.*, eq.dt_install  from   eqm_area_tbl as ed join eqm_equipment_tbl as eq on (eq.id= ed.code_eqp);



 insert into eqd_meter_zone_h  
 select code_eqp,id_department,dt_zone_install,kind_energy,zone,NULL,NULL,dt_zone_install from eqd_meter_zone_tbl;

 insert into eqd_meter_energy_h  
 select *,date_inst from eqd_meter_energy_tbl;

 insert into eqd_point_energy_h  
 select *,dt_instal from eqd_point_energy_tbl;

 insert into eqm_eqp_use_h  
 select *,dt_install from eqm_eqp_use_tbl;



 insert into eqm_compens_station_inst_h 
 select csi.*, CASE WHEN eq.dt_install<eqi.dt_install THEN eqi.dt_install  ELSE eq.dt_install END 
 from eqm_compens_station_inst_tbl as csi 
 join eqm_equipment_tbl as eq on (eq.id= csi.code_eqp)
 join eqm_equipment_tbl as eqi on (eqi.id= csi.code_eqp_inst);


alter table eqd_meter_zone_tbl drop constraint eqd_meter_zone_tbl_pkey;
alter table eqd_meter_zone_tbl add column kind_energy int ;

update eqd_meter_zone_tbl set kind_energy  = 
coalesce((select kind_energy from eqd_meter_energy_tbl where eqd_meter_energy_tbl.code_eqp =  eqd_meter_zone_tbl.code_eqp limit 1),1);

alter table eqd_meter_zone_tbl alter column kind_energy set not null ;


drop table tmp;

select count(d.*), d.code_eqp,d.kind_energy,d.zone,d.dt_zone_install 
         into table tmp
        from eqd_meter_zone_tbl as  d 
          group by d.code_eqp,d.kind_energy,d.zone, d.dt_zone_install  
           having count(*)>1; 



delete   from  eqd_meter_zone_tbl 
 where exists  (select * from tmp 
                  where tmp.code_eqp=eqd_meter_zone_tbl.code_eqp);


alter table eqd_meter_zone_tbl add primary key(code_eqp,kind_energy,zone,dt_zone_install);
alter table eqd_meter_zone_h drop constraint eqd_meter_zone_h_pkey;

delete from  eqd_meter_zone_h;

insert into eqd_meter_zone_h  
 select code_eqp,id_department,dt_zone_install,kind_energy,zone,NULL,NULL,dt_zone_install from eqd_meter_zone_tbl;

drop table tmp1;

select count(d.*), d.code_eqp,d.kind_energy,d.zone,d.dt_b
         into table tmp1
        from eqd_meter_zone_h as d 
          group by d.code_eqp,d.kind_energy,d.zone, d.dt_b  
           having count(*)>1; 

delete   from  eqd_meter_zone_h
 where exists  (select * from tmp1 
                  where tmp1.code_eqp=eqd_meter_zone_tbl.code_eqp);


alter table eqd_meter_zone_h add primary key(code_eqp,kind_energy,zone,dt_b);