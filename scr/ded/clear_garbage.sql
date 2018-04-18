update eqi_compensator_i_tbl set phase  = null where phase = 3; 

alter table eqm_meter_tbl disable trigger all;
delete from eqm_meter_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_meter_tbl enable trigger all;

delete from eqm_meter_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_compens_station_inst_tbl disable trigger all;
delete from eqm_compens_station_inst_tbl where code_eqp_inst not in (select id from eqm_equipment_tbl);
alter table eqm_compens_station_inst_tbl enable trigger all;

delete from eqm_compens_station_inst_h where code_eqp_inst not in (select id from eqm_equipment_h);


alter table eqm_compensator_i_tbl disable trigger all;
delete from eqm_compensator_i_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_compensator_i_tbl enable trigger all;

delete from eqm_compensator_i_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_line_a_tbl disable trigger all;
delete from eqm_line_a_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_line_a_tbl enable trigger all;

delete from eqm_line_a_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_line_c_tbl disable trigger all;
delete from eqm_line_c_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_line_c_tbl enable trigger all;

delete from eqm_line_c_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_switch_tbl disable trigger all;
delete from eqm_switch_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_switch_tbl enable trigger all;

delete from eqm_switch_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_fuse_tbl disable trigger all;
delete from eqm_fuse_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_fuse_tbl enable trigger all;

delete from eqm_fuse_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_borders_tbl disable trigger all;
delete from eqm_borders_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_borders_tbl enable trigger all;

delete from eqm_borders_h where code_eqp not in (select id from eqm_equipment_h);

alter table eqm_compensator_tbl disable trigger all;
delete from eqm_compensator_tbl where code_eqp not in (select id from eqm_equipment_tbl);
alter table eqm_compensator_tbl enable trigger all;

delete from eqm_compensator_h where code_eqp not in (select id from eqm_equipment_h);


alter table eqd_meter_energy_tbl disable trigger all;
delete from eqd_meter_energy_tbl where code_eqp not in (select code_eqp from eqm_meter_tbl);
alter table eqd_meter_energy_tbl enable trigger all;

delete from eqd_meter_energy_h where code_eqp not in (select code_eqp from eqm_meter_h);


alter table eqd_meter_zone_tbl disable trigger all;
delete from eqd_meter_zone_tbl where code_eqp not in (select code_eqp from eqm_meter_tbl);
alter table eqd_meter_zone_tbl enable trigger all;

delete from eqd_meter_zone_h where code_eqp not in (select code_eqp from eqm_meter_h);

alter table eqm_eqp_tree_tbl disable trigger all;
delete from eqm_eqp_tree_tbl where code_eqp_e not in (select id from eqm_equipment_tbl);
alter table eqm_eqp_tree_tbl enable trigger all;

delete from cli_account_tbl where id_client not in (select id from clm_client_tbl);


delete from acm_billpay_tbl where id_pay not in (select id_doc from acm_pay_tbl );
delete from acm_billpay_tbl where id_bill not in (select id_doc from acm_bill_tbl );
----------------------------------------------------

ALTER TABLE acm_bill_tbl ALTER COLUMN dt SET DEFAULT now();
ALTER TABLE acm_pay_tbl ALTER COLUMN dt SET DEFAULT now();
ALTER TABLE clm_client_tbl ALTER COLUMN dt SET DEFAULT now();