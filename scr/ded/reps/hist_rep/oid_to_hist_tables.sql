
-- у Козельца есть граници раздела в схеме, которые создались когда-то под население. Чистим.
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_eqp_tree_tbl';
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_equipment_tbl';
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_borders_tbl';


delete from eqm_borders_h where code_eqp in (select code_eqp from eqm_borders_tbl as b
left join clm_client_tbl as c on (c.id = b.id_clientb)where c.id is null);

delete from eqm_eqp_tree_h where code_eqp in (select code_eqp from eqm_borders_tbl as b
left join clm_client_tbl as c on (c.id = b.id_clientb)where c.id is null);

delete from eqm_equipment_h where id in (select code_eqp from eqm_borders_tbl as b
left join clm_client_tbl as c on (c.id = b.id_clientb)where c.id is null);


delete from eqm_eqp_tree_tbl where code_eqp in (select code_eqp from eqm_borders_tbl as b
left join clm_client_tbl as c on (c.id = b.id_clientb)where c.id is null);

delete from eqm_equipment_tbl where id in (select code_eqp from eqm_borders_tbl as b
left join clm_client_tbl as c on (c.id = b.id_clientb)where c.id is null);

delete from eqm_borders_tbl where code_eqp in (select code_eqp from eqm_borders_tbl as b
left join clm_client_tbl as c on (c.id = b.id_clientb)where c.id is null);


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_eqp_tree_tbl';
UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_equipment_tbl';

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_borders_tbl';

-------------------------------------------------------------------------------------------------------



  CREATE or replace FUNCTION oid_to_hist_tables_fun()
  RETURNS int
  AS                                                                                              
  '
  declare
   r record;
  begin



BEGIN

    select into r oid from eqm_equipment_h limit 1;

EXCEPTION

  WHEN 	undefined_column THEN


CREATE temp TABLE eqm_equipment_ht (LIKE eqm_equipment_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_eqp_tree_ht (LIKE eqm_eqp_tree_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_compens_station_ht (LIKE eqm_compens_station_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_fider_ht (LIKE eqm_fider_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_compensator_ht (LIKE eqm_compensator_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_compensator_i_ht (LIKE eqm_compensator_i_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_fuse_ht (LIKE eqm_fuse_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_jack_ht (LIKE eqm_jack_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_line_a_ht (LIKE eqm_line_a_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_line_c_ht (LIKE eqm_line_c_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_meter_ht (LIKE eqm_meter_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_point_ht (LIKE eqm_point_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_switch_ht (LIKE eqm_switch_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_borders_ht (LIKE eqm_borders_h INCLUDING DEFAULTS);

CREATE temp TABLE eqd_meter_energy_ht (LIKE eqd_meter_energy_h INCLUDING DEFAULTS);

CREATE temp TABLE eqd_meter_zone_ht (LIKE eqd_meter_zone_h INCLUDING DEFAULTS);

CREATE temp TABLE eqd_point_energy_ht (LIKE eqd_point_energy_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_tree_ht (LIKE eqm_tree_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_eqp_use_ht (LIKE eqm_eqp_use_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_compens_station_inst_ht (LIKE eqm_compens_station_inst_h INCLUDING DEFAULTS);

CREATE temp TABLE eqm_area_ht (LIKE eqm_area_h INCLUDING DEFAULTS);

----------------------------------------------------------------
 insert into eqm_equipment_ht select distinct * from eqm_equipment_h;

 insert into eqm_eqp_tree_ht select distinct * from eqm_eqp_tree_h;

 insert into eqm_compens_station_ht select distinct * from eqm_compens_station_h;
 insert into eqm_fider_ht select distinct * from eqm_fider_h;

 insert into eqm_compensator_ht select distinct * from eqm_compensator_h;
 insert into eqm_compensator_i_ht select distinct * from eqm_compensator_i_h;
 insert into eqm_fuse_ht select distinct * from eqm_fuse_h;
 insert into eqm_jack_ht select distinct * from eqm_jack_h;
 insert into eqm_line_a_ht select distinct * from eqm_line_a_h;
 insert into eqm_line_c_ht select distinct * from eqm_line_c_h;
 insert into eqm_meter_ht select distinct * from eqm_meter_h;
 insert into eqm_point_ht select distinct * from eqm_point_h;
 insert into eqm_switch_ht select distinct * from eqm_switch_h;
 insert into eqm_borders_ht select distinct * from eqm_borders_h;

 insert into eqd_meter_energy_ht select distinct * from eqd_meter_energy_h;
 insert into eqd_meter_zone_ht select distinct * from eqd_meter_zone_h;
 insert into eqd_point_energy_ht select distinct * from eqd_point_energy_h;

 insert into eqm_tree_ht select distinct * from eqm_tree_h;

 insert into eqm_eqp_use_ht select distinct * from eqm_eqp_use_h;

 insert into eqm_compens_station_inst_ht select  distinct * from eqm_compens_station_inst_h;

 insert into eqm_area_ht select distinct * from eqm_area_h;

---------------------------------------------------------------
 drop view eqv_pnt_met;

 drop table eqm_equipment_h;

 drop table eqm_eqp_tree_h;

 drop table eqm_compens_station_h;
 drop table eqm_fider_h;

 drop table eqm_compensator_h;
 drop table eqm_compensator_i_h;
 drop table eqm_fuse_h;
 drop table eqm_jack_h;
 drop table eqm_line_a_h;
 drop table eqm_line_c_h;
 drop table eqm_meter_h;
 drop table eqm_point_h;
 drop table eqm_switch_h;
 drop table eqm_borders_h;

 drop table eqd_meter_energy_h;
 drop table eqd_meter_zone_h;
 drop table eqd_point_energy_h;

 drop table eqm_tree_h;

 drop table eqm_eqp_use_h;

 drop table eqm_compens_station_inst_h;

 drop table eqm_area_h;


CREATE  TABLE eqm_equipment_h (LIKE eqm_equipment_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_eqp_tree_h (LIKE eqm_eqp_tree_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_compens_station_h (LIKE eqm_compens_station_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_fider_h (LIKE eqm_fider_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_compensator_h (LIKE eqm_compensator_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_compensator_i_h (LIKE eqm_compensator_i_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_fuse_h (LIKE eqm_fuse_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_jack_h (LIKE eqm_jack_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_line_a_h (LIKE eqm_line_a_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_line_c_h (LIKE eqm_line_c_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_meter_h (LIKE eqm_meter_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_point_h (LIKE eqm_point_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_switch_h (LIKE eqm_switch_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_borders_h (LIKE eqm_borders_ht INCLUDING DEFAULTS);

CREATE  TABLE eqd_meter_energy_h (LIKE eqd_meter_energy_ht INCLUDING DEFAULTS);

CREATE  TABLE eqd_meter_zone_h (LIKE eqd_meter_zone_ht INCLUDING DEFAULTS);

CREATE  TABLE eqd_point_energy_h (LIKE eqd_point_energy_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_tree_h (LIKE eqm_tree_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_eqp_use_h (LIKE eqm_eqp_use_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_compens_station_inst_h (LIKE eqm_compens_station_inst_ht INCLUDING DEFAULTS);

CREATE  TABLE eqm_area_h (LIKE eqm_area_ht INCLUDING DEFAULTS);


-------------------------------------------------------------------------------------

ALTER TABLE ONLY eqm_equipment_h
    ADD CONSTRAINT eqm_equipment_h_pkey PRIMARY KEY (id, dt_b);


ALTER TABLE ONLY eqm_equipment_h
    ADD CONSTRAINT "$1" FOREIGN KEY (type_eqp) REFERENCES eqi_device_kinds_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_eqp_tree_h
    ADD CONSTRAINT eqm_eqp_tree_h_pkey PRIMARY KEY (id_tree, code_eqp, line_no, dt_b);


ALTER TABLE ONLY eqm_compens_station_h
    ADD CONSTRAINT eqm_compens_station_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_compens_station_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_voltage) REFERENCES eqk_voltage_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_fider_h
    ADD CONSTRAINT eqm_fider_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_fider_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_voltage) REFERENCES eqk_voltage_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_compensator_h
    ADD CONSTRAINT eqm_compensator_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_compensator_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_compensator_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_compensator_i_h
    ADD CONSTRAINT eqm_compensator_i_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_compensator_i_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_compensator_i_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_fuse_h
    ADD CONSTRAINT eqm_fuse_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_fuse_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_fuse_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_jack_h
    ADD CONSTRAINT eqm_jack_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_jack_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_jack_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_line_a_h
    ADD CONSTRAINT eqm_line_a_h_pkey PRIMARY KEY (code_eqp, dt_b);



ALTER TABLE ONLY eqm_line_a_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_corde_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;



ALTER TABLE ONLY eqm_line_a_h
    ADD CONSTRAINT "$2" FOREIGN KEY (pillar) REFERENCES eqi_pillar_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;



ALTER TABLE ONLY eqm_line_a_h
    ADD CONSTRAINT "$3" FOREIGN KEY ("pendant") REFERENCES eqi_pendant_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;



ALTER TABLE ONLY eqm_line_a_h
    ADD CONSTRAINT "$4" FOREIGN KEY (earth) REFERENCES eqi_earth_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_line_a_h
    ADD CONSTRAINT "$5" FOREIGN KEY (id_voltage) REFERENCES eqk_voltage_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_line_c_h
    ADD CONSTRAINT eqm_line_c_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_line_c_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_cable_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_line_c_h
    ADD CONSTRAINT "$2" FOREIGN KEY (id_voltage) REFERENCES eqk_voltage_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_meter_h
    ADD CONSTRAINT eqm_meter_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_meter_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_meter_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_point_h
    ADD CONSTRAINT eqm_point_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_point_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_tarif) REFERENCES aci_tarif_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_point_h
    ADD CONSTRAINT "$2" FOREIGN KEY (industry) REFERENCES cla_param_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_point_h
    ADD CONSTRAINT "$3" FOREIGN KEY (id_tg) REFERENCES eqk_tg_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_point_h
    ADD CONSTRAINT "$4" FOREIGN KEY (id_voltage) REFERENCES eqk_voltage_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_switch_h
    ADD CONSTRAINT eqm_switch_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_switch_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_type_eqp) REFERENCES eqi_switch_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE eqm_borders_h
    ADD CONSTRAINT eqm_borders_h_pkey PRIMARY KEY (code_eqp, dt_b);


ALTER TABLE ONLY eqm_borders_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_clienta) REFERENCES clm_client_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;



ALTER TABLE ONLY eqm_borders_h
    ADD CONSTRAINT "$2" FOREIGN KEY (id_clientb) REFERENCES clm_client_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqd_meter_energy_h
    ADD CONSTRAINT eqd_meter_energy_h_pkey PRIMARY KEY (code_eqp, kind_energy, dt_b);


ALTER TABLE ONLY eqd_meter_energy_h
    ADD CONSTRAINT "$1" FOREIGN KEY (kind_energy) REFERENCES eqk_energy_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqd_meter_zone_h
    ADD CONSTRAINT eqd_meter_zone_h_pkey PRIMARY KEY (code_eqp, kind_energy, "zone", dt_b);



ALTER TABLE ONLY eqd_meter_zone_h
    ADD CONSTRAINT "$1" FOREIGN KEY ("zone") REFERENCES eqk_zone_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqd_point_energy_h
    ADD CONSTRAINT eqd_point_energy_h_pkey PRIMARY KEY (code_eqp, kind_energy, dt_b);


ALTER TABLE ONLY eqd_point_energy_h
    ADD CONSTRAINT "$1" FOREIGN KEY (kind_energy) REFERENCES eqk_energy_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_tree_h
    ADD CONSTRAINT eqm_tree_h_pkey PRIMARY KEY (id, dt_b);


ALTER TABLE ONLY eqm_tree_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_client) REFERENCES clm_client_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY eqm_eqp_use_h
    ADD CONSTRAINT eqm_eqp_use_h_pkey PRIMARY KEY (code_eqp, id_client, dt_b);


ALTER TABLE ONLY eqm_compens_station_inst_h
    ADD CONSTRAINT eqm_compens_station_inst_h_pkey PRIMARY KEY (code_eqp, code_eqp_inst, dt_b);


ALTER TABLE ONLY eqm_area_h
    ADD CONSTRAINT eqm_area_h_pkey PRIMARY KEY (code_eqp, dt);


ALTER TABLE ONLY eqm_area_h
    ADD CONSTRAINT "$1" FOREIGN KEY (id_client) REFERENCES clm_client_tbl(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


-----------------------------------------------------------------------

 insert into eqm_equipment_h select * from eqm_equipment_ht;

 insert into eqm_eqp_tree_h select * from eqm_eqp_tree_ht;

 insert into eqm_compens_station_h select * from eqm_compens_station_ht;
 insert into eqm_fider_h select * from eqm_fider_ht;

 insert into eqm_compensator_h select * from eqm_compensator_ht;
 insert into eqm_compensator_i_h select * from eqm_compensator_i_ht;
 insert into eqm_fuse_h select * from eqm_fuse_ht;
 insert into eqm_jack_h select * from eqm_jack_ht;
 insert into eqm_line_a_h select * from eqm_line_a_ht;
 insert into eqm_line_c_h select * from eqm_line_c_ht;
 insert into eqm_meter_h select * from eqm_meter_ht;
 insert into eqm_point_h select * from eqm_point_ht;
 insert into eqm_switch_h select * from eqm_switch_ht;
 insert into eqm_borders_h select * from eqm_borders_ht;

 insert into eqd_meter_energy_h select * from eqd_meter_energy_ht;
 insert into eqd_meter_zone_h select * from eqd_meter_zone_ht;
 insert into eqd_point_energy_h select * from eqd_point_energy_ht;

 insert into eqm_tree_h select * from eqm_tree_ht;

 insert into eqm_eqp_use_h select * from eqm_eqp_use_ht;

 insert into eqm_compens_station_inst_h select * from eqm_compens_station_inst_ht;

 insert into eqm_area_h select * from eqm_area_ht;

  RETURN 1;                              

  END;

  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


  SET default_with_oids = true;

  select oid_to_hist_tables_fun();

