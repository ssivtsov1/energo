INSERT INTO eqi_device_kinds_tbl (id, name, id_table_ind, id_table, calc_lost, inst_station) VALUES (15, 'ц╔─┼╥', NULL, 29, 0, 1);
INSERT INTO eqi_device_kinds_prop_tbl (type_eqp, id_icon, form_name) VALUES (15, NULL, 'TfFiderDet');
alter table eqm_fider_tbl add column losts_coef    numeric(10,8);
alter table eqm_fider_tbl alter column losts_coef  set default 0;
alter table eqm_fider_tbl add column id_position int;
alter table eqm_fider_h add column id_position int;

alter table eqm_point_tbl add column id_position int;
alter table eqm_point_h add column id_position int;

--для гор.сетей, чтобы убрать дубль первичного ключа
delete from eqm_borders_h where code_eqp = 1113641 and id_clienta = 2380 and id_clientb = 667205 and dt_e is not null;
--

ALTER TABLE eqm_borders_h ALTER COLUMN dt_b SET NOT NULL;

ALTER TABLE eqm_borders_h
  ADD CONSTRAINT eqm_borders_h_pkey PRIMARY KEY(code_eqp, dt_b);
