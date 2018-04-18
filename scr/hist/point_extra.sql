alter table eqm_point_tbl add column id_extra  int;
alter table eqm_point_h add column id_extra  int;


alter table eqm_point_tbl add column in_lost int;
alter table eqm_point_h add column in_lost int;
alter table eqm_point_tbl alter column in_lost set default 0;
alter table eqm_point_h alter column in_lost set default 0;

alter table eqm_point_tbl add column connect_power numeric (9,3);
alter table eqm_point_h add column connect_power numeric (9,3);
alter table eqm_point_tbl alter column connect_power set default 0;
alter table eqm_point_h alter column connect_power set default 0;

alter table eqm_compensator_i_tbl add column date_check date;
alter table eqm_compensator_i_h add column date_check date;

ALTER TABLE eqm_point_tbl ADD COLUMN "con_power_kva" integer;
ALTER TABLE eqm_point_h ADD COLUMN "con_power_kva" integer;

ALTER TABLE eqm_point_tbl ADD COLUMN safe_category integer;
ALTER TABLE eqm_point_h ADD COLUMN safe_category integer;

ALTER TABLE eqm_switch_tbl ADD COLUMN amperage_nom numeric(12,2);
ALTER TABLE eqm_switch_h ADD COLUMN amperage_nom numeric(12,2);

ALTER TABLE eqm_switch_tbl ALTER COLUMN amperage_nom TYPE numeric(12,2)	;
ALTER TABLE eqm_switch_h ALTER COLUMN amperage_nom TYPE numeric(12,2)	;

alter table eqm_point_tbl add column disabled  int;
alter table eqm_point_h   add column disabled  int;
/*

delete from cla_param_tbl where id_group = 1000 or id = 1000;

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1000, NULL, 6, 'Дополнительные свойства ТУ', NULL, NULL, 'Дополнительные свойства ТУ', 1, NULL, '~gr_extra', NULL, NULL, NULL,999);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1001, 1000, NULL, NULL, NULL, NULL, 'Пенiтенциарна система', 2, NULL, '', 1000, '01', NULL,1);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1002, 1000, NULL, NULL, NULL, NULL, 'Пенiтенциарна система виробн. потреби', 2, NULL, '', 1000, '02', NULL,2);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1003, 1000, NULL, NULL, NULL, NULL, 'Релiгiйна орг. побутовi потреби', 2, NULL, '', 1000, '03', NULL,3);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1004, 1000, NULL, NULL, NULL, NULL, 'Релiгiйна орг. виробн. потреби', 2, NULL, '', 1000, '04', NULL,4);
                                                                                                                                                                                                                             
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1005, 1000, NULL, NULL, NULL, NULL, 'Населенi пункти на технiчнi цiлi', 2, NULL, '', 1000, '05', NULL,5);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1005, 1000, NULL, NULL, NULL, NULL, 'Освiтлення насел.п.-мiсто', 2, NULL, '', 1000, '05', NULL,5);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1006, 1000, NULL, NULL, NULL, NULL, 'Освiтлення насел.п.-село', 2, NULL, '', 1000, '06', NULL,6);

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1007, 1000, NULL, NULL, NULL, NULL, 'Населення ел.плити/опалення -мiсто', 2, NULL, '', 1000, '07', NULL,7);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1008, 1000, NULL, NULL, NULL, NULL, 'Населення ел.плити/опалення -село', 2, NULL, '', 1000, '08', NULL,8);

--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1007, 1000, NULL, NULL, NULL, NULL, 'Населення електроплити-мiсто', 2, NULL, '', 1000, '07', NULL,7);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1008, 1000, NULL, NULL, NULL, NULL, 'Населення електроплити-село', 2, NULL, '', 1000, '08', NULL,8);

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1009, 1000, NULL, NULL, NULL, NULL, 'За загальним засобом облiку - мiсто', 2, NULL, '', 1000, '09', NULL,9);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1010, 1000, NULL, NULL, NULL, NULL, 'За загальним засобом облiку - село', 2, NULL, '', 1000, '10', NULL,10);

--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1009, 1000, NULL, NULL, NULL, NULL, 'Населенi пункти електроплити-мiсто', 2, NULL, '', 1000, '09', NULL,9);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1010, 1000, NULL, NULL, NULL, NULL, 'Населенi пункти електроплити-село', 2, NULL, '', 1000, '10', NULL,10);

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1011, 1000, NULL, NULL, NULL, NULL, 'З шин ПС ЕЕС', 2, NULL, '', 1000, '11', NULL,20);

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1012, 1000, NULL, NULL, NULL, NULL, 'Пенiтенц. система-нас.пункти електроплити-мiсто', 2, NULL, '', 1000, '12', NULL,16);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1013, 1000, NULL, NULL, NULL, NULL, 'Пенiтенц. система-нас.пункти електроплити-село', 2, NULL, '', 1000, '13', NULL,17);

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1014, 1000, NULL, NULL, NULL, NULL, 'Безпосередньо з шин ТЕЦ', 2, NULL, '', 1000, '14', NULL,21);

INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1015, 1000, NULL, NULL, NULL, NULL, 'Населення у негазиф.буд. без теплопостач. -мiсто', 2, NULL, '', 1000, '15', NULL,18);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1016, 1000, NULL, NULL, NULL, NULL, 'Населення у негазиф.буд. без теплопостач. -село', 2, NULL, '', 1000, '16', NULL,19);


INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1017, 1000, NULL, NULL, NULL, NULL, 'За загальним засобом облiку-ОСББ', 2, NULL, '', 1000, '17', NULL,11);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1018, 1000, NULL, NULL, NULL, NULL, 'За загальним засобом облiку-ЖБК', 2, NULL, '', 1000, '18', NULL,12);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1019, 1000, NULL, NULL, NULL, NULL, 'За загальним засобом облiку-ЖБТ', 2, NULL, '', 1000, '19', NULL,13);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1020, 1000, NULL, NULL, NULL, NULL, 'Сад.товариства,дачнi кооп.', 2, NULL, '', 1000, '20', NULL,14);
INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (1021, 1000, NULL, NULL, NULL, NULL, 'Гаражно-будiвельнi кооп.', 2, NULL, '', 1000, '21', NULL,15);

*/
--delete from eqm_borders_h where dt_b = dt_e;

ALTER TABLE eqm_borders_h
    ADD CONSTRAINT eqm_borders_h_pkey PRIMARY KEY (code_eqp, dt_b);

ALTER TABLE eqm_meter_tbl ADD COLUMN magnet integer;
ALTER TABLE eqm_meter_tbl ALTER COLUMN magnet SET DEFAULT 0;


ALTER TABLE eqm_meter_h ADD COLUMN magnet integer;
ALTER TABLE eqm_meter_h ALTER COLUMN magnet SET DEFAULT 0;

ALTER TABLE eqm_equipment_tbl ADD COLUMN is_owner integer;
ALTER TABLE eqm_equipment_h ADD COLUMN is_owner integer;
--ALTER TABLE eqm_equipment_tbl ALTER COLUMN is_owner SET DEFAULT 1;


--UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_equipment_tbl';

--update eqm_equipment_tbl set is_owner = 0
--from eqm_eqp_tree_tbl as tt  
--join eqm_tree_tbl as t on (t.id = tt.id_tree)
--where (is_owner is null) and (t.id_client = t.id_department )
--and (tt.code_eqp = eqm_equipment_tbl.id);

--update eqm_equipment_tbl set is_owner = 1
--from eqm_eqp_tree_tbl as tt  
--join eqm_tree_tbl as t on (t.id = tt.id_tree)
--where (is_owner is null) and (t.id_client <> t.id_department )
--and (tt.code_eqp = eqm_equipment_tbl.id);


--update eqm_equipment_h set is_owner = 0
--from eqm_eqp_tree_tbl as tt  
--join eqm_tree_tbl as t on (t.id = tt.id_tree)
--where (is_owner is null) and (t.id_client = t.id_department )
--and (tt.code_eqp = eqm_equipment_h.id) and (eqm_equipment_h.dt_e is null);

--update eqm_equipment_h set is_owner = 1
--from eqm_eqp_tree_tbl as tt  
--join eqm_tree_tbl as t on (t.id = tt.id_tree)
--where (is_owner is null) and (t.id_client <> t.id_department )
--and (tt.code_eqp = eqm_equipment_h.id) and (eqm_equipment_h.dt_e is null);


--UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
--WHERE relname = 'eqm_equipment_tbl';



ALTER TABLE eqm_point_tbl ALTER column connect_power TYPE numeric (14,4);
ALTER TABLE eqm_point_h ALTER column connect_power TYPE numeric (14,4);

ALTER TABLE eqm_point_tbl ALTER column power TYPE numeric (14,4);
ALTER TABLE eqm_point_h ALTER column   power TYPE numeric (14,4);

ALTER TABLE eqm_ground_tbl  ALTER column power TYPE numeric (14,4);
ALTER TABLE eqm_ground_tbl  ALTER column   power TYPE numeric (14,4);


