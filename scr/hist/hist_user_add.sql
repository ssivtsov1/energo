
ALTER TABLE  eqm_tree_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_tree_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_eqp_tree_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_eqp_tree_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_equipment_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_equipment_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_meter_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_meter_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqd_meter_zone_h ADD COLUMN id_user integer;
ALTER TABLE  eqd_meter_zone_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqd_meter_energy_h ADD COLUMN id_user integer;
ALTER TABLE  eqd_meter_energy_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_compens_station_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_compens_station_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_fider_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_fider_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_compens_station_inst_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_compens_station_inst_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_compensator_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_compensator_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_compensator_i_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_compensator_i_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_line_a_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_line_a_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_line_c_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_line_c_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_jack_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_jack_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_switch_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_switch_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_fuse_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_fuse_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_borders_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_borders_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_point_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_point_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_area_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_area_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqd_point_energy_h ADD COLUMN id_user integer;
ALTER TABLE  eqd_point_energy_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

ALTER TABLE  eqm_eqp_use_h ADD COLUMN id_user integer;
ALTER TABLE  eqm_eqp_use_h ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);


ALTER TABLE clm_statecl_h ALTER COLUMN id_person SET DEFAULT getsysvar('id_person'::character varying);