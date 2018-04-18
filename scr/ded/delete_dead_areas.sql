
create temp table eqt_deadareas_tbl
( id int );

create temp table eqt_liveareas_tbl
( id int );

insert into eqt_deadareas_tbl 
select id from eqm_equipment_h where dt_e is null and not exists (select id from eqm_equipment_tbl where eqm_equipment_tbl.id = eqm_equipment_h.id);

insert into eqt_liveareas_tbl
select id from eqm_equipment_h where type_eqp = 11 and dt_e is null and not exists (select id from eqm_equipment_tbl where eqm_equipment_tbl.id = eqm_equipment_h.id)
and  exists (select code_eqp from eqm_compens_station_inst_h where dt_e is null and eqm_compens_station_inst_h.code_eqp_inst = eqm_equipment_h.id 
  and not exists (select code_eqp from eqm_compens_station_inst_tbl where eqm_compens_station_inst_h.code_eqp = eqm_compens_station_inst_tbl.code_eqp)
  and  exists (select id from eqm_equipment_tbl as eq2 where eqm_compens_station_inst_h.code_eqp = eq2.id)
)
and  exists (select code_eqp from eqm_area_h where dt_e is null and eqm_area_h.code_eqp = eqm_equipment_h.id);


delete from eqm_equipment_h where id in (select id from eqt_deadareas_tbl) and 
 id not in (select id from eqt_liveareas_tbl) ; 

delete from eqm_area_h where code_eqp in (select id from eqt_deadareas_tbl) and 
 code_eqp not in (select id from eqt_liveareas_tbl) ; 

delete from eqm_compens_station_inst_h where code_eqp_inst in (select id from eqt_deadareas_tbl) and 
 code_eqp_inst not in (select id from eqt_liveareas_tbl) ; 


UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_equipment_tbl';
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_area_tbl';
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_compens_station_inst_tbl';

insert into eqm_equipment_tbl
SELECT id, type_eqp, name_eqp, num_eqp, id_addres, dt_install, dt_change, 
       loss_power, id_department
  FROM eqm_equipment_h
where id in (select id from eqt_liveareas_tbl) and  
dt_e is null;

insert into eqm_area_tbl
SELECT code_eqp, id_department, id_client
  FROM eqm_area_h
where code_eqp in (select id from eqt_liveareas_tbl) and  
dt_e is null;

insert into eqm_compens_station_inst_tbl
SELECT  id_department, code_eqp,code_eqp_inst
  FROM eqm_compens_station_inst_h
where code_eqp_inst in (select id from eqt_liveareas_tbl) and  
dt_e is null
and  exists (select id from eqm_equipment_tbl as eq2 where eqm_compens_station_inst_h.code_eqp = eq2.id) 
and not exists (select code_eqp from eqm_compens_station_inst_tbl where eqm_compens_station_inst_h.code_eqp = eqm_compens_station_inst_tbl.code_eqp) ;

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_equipment_tbl';

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_area_tbl';

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_compens_station_inst_tbl';