update eqi_classtarif_tbl set ident = 'tcl1' where id =13; 
update eqi_classtarif_tbl set ident = 'tcl2' where id =14; 

update eqi_grouptarif_tbl set ident = 'tgr9990' where id =27; 
update eqi_grouptarif_tbl set ident = 'tgr9000' where id =900000; 
update eqi_grouptarif_tbl set ident = 'tgr9999' where id =999999; 

--alter table clm_statecl_tbl add column id_section int;

--alter table cla_param_tbl add column sort int;

--delete from cla_param_tbl where id_group = 200 or id = 200;

--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (200, NULL, 6, 'Группы потребителей', NULL, NULL, 'Группы потребителей (СЕБ)', 1, NULL, '~gr_sect', NULL, NULL, NULL,999);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (201, 200, NULL, NULL, NULL, NULL, 'Промисловiсть', 2, NULL, '', 200, '2', NULL,2);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (202, 200, NULL, NULL, NULL, NULL, 'Сiльське господарство', 2, NULL, NULL, 200, '3', NULL,1);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (203, 200, NULL, NULL, NULL, NULL, 'ЖКГ', 2, NULL, 'gr_jkh', 200, '6', NULL,9);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (204, 200, NULL, NULL, NULL, NULL, 'Iншi', 2, NULL, NULL, 200, '8', NULL,10);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (205, 200, NULL, NULL, NULL, NULL, 'Населення (рахунки)', 2, NULL, NULL, 200, '9', NULL,11);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (206, 200, NULL, NULL, NULL, NULL, 'Пiльги', 2, NULL, NULL, 200, '11', NULL,13);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (207, 200, NULL, NULL, NULL, NULL, 'Субсидi╓╖', 2, NULL, NULL, 200, '12', NULL,14);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (208, 200, NULL, NULL, NULL, NULL, 'Населення (акти)', 2, NULL, NULL, 200, '13', NULL,12);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (209, 200, NULL, NULL, NULL, NULL, 'Транзит', 2, NULL, NULL, 200, '100', NULL,15);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (210, 200, NULL, NULL, NULL, NULL, 'Бюджет', 2, NULL, NULL, 200, NULL, NULL,3);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (211, 210, NULL, NULL, NULL, NULL, 'Державний', 3, NULL, NULL, 200, '101', NULL,4);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (212, 210, NULL, NULL, NULL, NULL, 'Мiсцевий', 3, NULL, NULL, 200, NULL, NULL,5);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (213, 212, NULL, NULL, NULL, NULL, 'Обласний бюджет', 4, NULL, NULL, 200, '102', NULL,6);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (214, 212, NULL, NULL, NULL, NULL, 'Мiський бюджет', 4, NULL, NULL, 200, '103', NULL,7);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (215, 212, NULL, NULL, NULL, NULL, 'Районний бюджет', 4, NULL, NULL, 200, '104', NULL,8);
--INSERT INTO cla_param_tbl (id, id_parent, id_type, val, term, len, name, lev, fl_reg, key_name, id_group, kod, field_name,sort) VALUES (216, 200, NULL, NULL, NULL, NULL, 'Непрокодованi', 2, NULL, NULL, 200, '999', NULL,99);


update aci_pref_tbl set "comment" =  'Прев.лимита (5КР)' where id = 500; 

INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (510, '2-КР м', 'Прев.лимита (2КР) мощность', '2kr_p', 6, NULL, NULL, 0);
INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (520, '2-КР п', 'Прев.лимита (2КР) потребление', '2kr_d', 6, NULL, NULL, 0);
