-- Корректировка схемы РЕС
--delete from bal_fider_errors_tbl;
--delete from bal_grp_tree_tbl;
--delete from bal_demand_tbl;
--delete from bal_client_errors_tbl;
--delete from bal_acc_tbl;
--delete from bal_eqp_tbl;


UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_line_c_tbl';

 update eqm_line_c_tbl set id_voltage = 3 where id_voltage = 31;
 update eqm_line_c_tbl set id_voltage = 4 where id_voltage = 41;

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_line_c_tbl';


UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_line_a_tbl';

 update eqm_line_a_tbl set id_voltage = 3 where id_voltage = 31;
 update eqm_line_a_tbl set id_voltage = 4 where id_voltage = 41;

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_line_a_tbl';


-- Если оборудование принадлежит ПС и Фидеру, оставляем только ПС,
-- строки для фидера удаляем

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_compens_station_inst_tbl';

delete from eqm_compens_station_inst_tbl where code_eqp in
  (select distinct csi.code_eqp from eqm_compens_station_inst_tbl as csi join eqm_equipment_tbl as eq on (eq.id = csi.code_eqp_inst)
   where eq.type_eqp = 8)
  and code_eqp_inst in 
  (select distinct id from eqm_equipment_tbl  where type_eqp = 15);

-- снять флаг принадлежности с границ раздела
delete from eqm_compens_station_inst_tbl where code_eqp in
   (select distinct id from eqm_equipment_tbl  where type_eqp = 9);

-- снять флаг принадлежности с оборудования, которое используется абонентами
delete from eqm_compens_station_inst_tbl where code_eqp in
  (select code_eqp from eqm_eqp_use_tbl)
  and code_eqp_inst in 
  (select distinct id from eqm_equipment_tbl  where type_eqp = 15 or type_eqp = 8);


 -- убрать принадлежность к фидеру линий 0.4
 delete from eqm_compens_station_inst_tbl where 
 (code_eqp in (select code_eqp from eqm_line_c_tbl where id_voltage = 4 )
 or code_eqp in (select code_eqp from eqm_line_a_tbl where id_voltage = 4 ))
 and code_eqp_inst in (select id from eqm_equipment_tbl where type_eqp = 15);

 --убрать принадлежность счетчиков и ТТ фидерам и ПС
 delete from eqm_compens_station_inst_tbl where code_eqp in
   (select distinct id from eqm_equipment_tbl  where type_eqp = 1 or type_eqp = 10)
 and code_eqp_inst in (select id from eqm_equipment_tbl where type_eqp = 15 or type_eqp = 8);


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_compens_station_inst_tbl';


-- поставить для всех линий, включенных в фидера флаг расчета потерь
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_equipment_tbl';

 update eqm_equipment_tbl set loss_power = 1 where (type_eqp = 6 or type_eqp = 7) and 
 exists (select csi.code_eqp from eqm_compens_station_inst_tbl as csi 
         join eqm_equipment_tbl as eq on (eq.id = csi.code_eqp_inst) where eq.type_eqp = 15 and csi.code_eqp = eqm_equipment_tbl.id);

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_equipment_tbl';


INSERT INTO syi_sysvars_tbl (id, ident, type_ident, value_ident, sql_ident) VALUES (22, 'fidercontrol', 'int', '1', NULL);