select del_NoTrigger('acd_billsum_del','delete from acd_billsum_del');
select del_NoTrigger('acd_billsum_tbl','delete from acd_billsum_tbl');

select del_NoTrigger('acd_calc_losts_del','delete from acd_calc_losts_del');
select del_NoTrigger('acd_calc_losts_tbl','delete from acd_calc_losts_tbl');

select del_NoTrigger('acd_clc_inf_del','delete from acd_clc_inf_del');
select del_NoTrigger('acd_clc_inf','delete from  acd_clc_inf');

select del_NoTrigger('acd_demandlimit_tbl','delete from acd_demandlimit_tbl');

select del_NoTrigger('acd_difmetzone_tbl','delete from acd_difmetzone_tbl');
select del_NoTrigger('acd_inddifzone_tbl','delete from    acd_inddifzone_tbl');



select del_NoTrigger('acd_met_kndzn_del','delete from    acd_met_kndzn_del');
select del_NoTrigger('acd_met_kndzn_tbl','delete from    acd_met_kndzn_tbl');

select del_NoTrigger('acd_pnt_tarif_del','delete from    acd_pnt_tarif_del');
select del_NoTrigger('acd_pnt_tarif','delete from    acd_pnt_tarif');

select del_NoTrigger('acd_point_branch_del','delete from    acd_point_branch_del');
select del_NoTrigger('acd_point_branch_tbl','delete from    acd_point_branch_tbl');

select del_NoTrigger('acd_pwr_demand_del','delete from    acd_pwr_demand_del');
select del_NoTrigger('acd_pwr_demand_tbl','delete from    acd_pwr_demand_tbl');

select del_NoTrigger('acd_summ_val','delete from    acd_summ_val');
select del_NoTrigger('acd_summ_val_del','delete from    acd_summ_val_del');

select del_NoTrigger('acd_tax_del','delete from    acd_tax_del');
select del_NoTrigger('acd_tax_tbl','delete from    acd_tax_tbl');
select del_NoTrigger('acm_tax_del','delete from    acm_tax_del');
select del_NoTrigger('acm_tax_tbl','delete from    acm_tax_tbl');

select del_NoTrigger('acd_taxcorrection_tbl','delete from    acd_taxcorrection_tbl');
select del_NoTrigger('acm_taxadvcor_tbl','delete from    acm_taxadvcor_tbl');
select del_NoTrigger('acm_taxcorrection_tbl','delete from    acm_taxcorrection_tbl');
select del_NoTrigger('acm_taxpayerr_tbl','delete from    acm_taxpayerr_tbl');

select del_NoTrigger('acm_bill_del','delete from   acm_bill_del');
select del_NoTrigger('acm_bill_tbl','delete from    acm_bill_tbl');

select del_NoTrigger('acm_billpay_tbl','delete from   acm_billpay_tbl');
select del_NoTrigger('acm_billtax_tbl','delete from    acm_billtax_tbl');
select del_NoTrigger('acm_demand_tbl','delete from    acm_demand_tbl');
select del_NoTrigger('acm_headdem_tbl','delete from    acm_headdem_tbl');
select del_NoTrigger('acm_headdemandlimit_tbl','delete from    acm_headdemandlimit_tbl');

select del_NoTrigger('acm_headindication_tbl','delete from    acm_headindication_tbl');
select del_NoTrigger('acd_indication_del','delete from    acd_indication_del');
select del_NoTrigger('acd_indication_tbl','delete from    acd_indication_tbl');
select del_NoTrigger('acm_privdem_tbl','delete from    acm_privdem_tbl');


select del_NoTrigger('acm_headpay_tbl','delete from    acm_headpay_tbl');
select del_NoTrigger('acm_pay_tbl','delete from    acm_pay_tbl');
select del_NoTrigger('acm_headpayp_tbl','delete from    acm_headpayp_tbl');
select del_NoTrigger('acm_payp_tbl','delete from    acm_payp_tbl');
select del_NoTrigger('acm_paypsum_tbl','delete from    acm_paypsum_tbl');

select del_NoTrigger('acm_headpowerindication_tbl','delete from    acm_headpowerindication_tbl');
select del_NoTrigger('acm_headsum_tbl','delete from    acm_headsum_tbl');

select del_NoTrigger('acm_inspecth_tbl','delete from    acm_inspecth_tbl');
select del_NoTrigger('acm_inspectstr_tbl','delete from    acm_inspectstr_tbl');
select del_NoTrigger('acm_loadpay_tbl','delete from    acm_loadpay_tbl');

select del_NoTrigger('acm_saldo_tbl','delete from    acm_saldo_tbl');
select del_NoTrigger('acm_saldoakt_tbl','delete from    acm_saldoakt_tbl');

select del_NoTrigger('bal_abons_tbl','delete from    bal_abons_tbl');
select del_NoTrigger('bal_demand_tbl','delete from    bal_demand_tbl');
select del_NoTrigger('bal_eqp_tbl','delete from    bal_eqp_tbl');
select del_NoTrigger('bal_fider_st_tbl','delete from    bal_fider_st_tbl');
select del_NoTrigger('bal_grp_tree_conn_tbl','delete from    bal_grp_tree_conn_tbl');
select del_NoTrigger('bal_grp_tree_tbl','delete from    bal_grp_tree_tbl');
select del_NoTrigger('bal_losts04_tbl','delete from    bal_losts04_tbl');
select del_NoTrigger('bal_meter_demand_tbl','delete from    bal_meter_demand_tbl');
select del_NoTrigger('bal_points_all_tbl','delete from    bal_points_all_tbl');
select del_NoTrigger('bal_prognoz_basics_tbl','delete from    bal_prognoz_basics_tbl');
select del_NoTrigger('bal_prognoz_fiders_tbl','delete from    bal_prognoz_fiders_tbl');
select del_NoTrigger('bal_prognoz_points_tbl','delete from    bal_prognoz_points_tbl');
select del_NoTrigger('bal_switching_tbl','delete from    bal_switching_tbl');

select del_NoTrigger('cli_account_tbl','delete from    cli_account_tbl');
select del_NoTrigger('clm_client_tbl','delete from       clm_client_tbl where (id not in 
             (select value_ident::int from syi_sysvars_tbl where id in (25)) and id<>999999999)');

select del_NoTrigger('clm_statecl_h','delete from clm_statecl_tbl where (id_client not in 
             (select value_ident::int from syi_sysvars_tbl where id in (25)) and id<>999999999)');

select del_NoTrigger('clm_statecl_tbl','delete from clm_statecl_h where (id_client not in 
             (select value_ident::int from syi_sysvars_tbl where id in (25)) and id<>999999999)');

/*
select *  from    clm_client_tbl where (id not in 
             (select value_ident::int from syi_sysvars_tbl where id in (25)) and id<>999999999);

select * from clm_client_h

*/
--select * from syi_sysvars_tbl where id not in (1,20) ORDER BY id

select del_NoTrigger('clm_docconnect_tbl','delete from    clm_docconnect_tbl');
select del_NoTrigger('clm_org_tbl','delete from    clm_org_tbl');
select del_NoTrigger('clm_param_tbl','delete from    clm_param_tbl');
select del_NoTrigger('clm_pardef_tbl','delete from    clm_pardef_tbl');
select del_NoTrigger('clm_pclient_tbl','delete from    clm_pclient_tbl');
select del_NoTrigger('clm_plomb_tbl','delete from    clm_plomb_tbl');
select del_NoTrigger('clm_position_tbl','delete from    clm_position_tbl');
select del_NoTrigger('clm_protocol_tbl','delete from    clm_protocol_tbl');
select del_NoTrigger('clm_renthist_tbl','delete from    clm_renthist_tbl');
select del_NoTrigger('clm_salary_tbl','delete from    clm_salary_tbl');



select del_NoTrigger('clm_switching_tbl','delete from    clm_switching_tbl');
select del_NoTrigger('clm_work_indications_del','delete from    clm_work_indications_del');
select del_NoTrigger('clm_work_indications_tbl','delete from    clm_work_indications_tbl');
select del_NoTrigger('clm_works_del','delete from    clm_works_del');
select del_NoTrigger('clm_works_tbl','delete from   clm_works_tbl');
--select del_NoTrigger('cmd_tax_tbl','delete from   cmd_tax_tbl');
select del_NoTrigger('cmi_area_tbl','delete from   cmi_area_tbl');
select del_NoTrigger('eqd_difmetzone_h','delete from   eqd_difmetzone_h');
select del_NoTrigger('eqd_difmetzone_tbl','delete from   eqd_difmetzone_tbl');

select del_NoTrigger('eqd_meter_energy_h','delete from   eqd_meter_energy_h');
select del_NoTrigger('eqd_meter_energy_tbl','delete from   eqd_meter_energy_tbl');
select del_NoTrigger('eqd_meter_zone_h','delete from   eqd_meter_zone_h');
select del_NoTrigger('eqd_meter_zone_tbl','delete from   eqd_meter_zone_tbl');
select del_NoTrigger('eqd_point_energy_h','delete from   eqd_point_energy_h');
select del_NoTrigger('eqd_point_energy_tbl','delete from   eqd_point_energy_tbl');

select del_NoTrigger('eqm_area_h','delete from   eqm_area_h');
select del_NoTrigger('eqm_area_tbl','delete from   eqm_area_tbl');

select del_NoTrigger('eqm_borders_h','delete from   eqm_borders_h');
select del_NoTrigger('eqm_borders_tbl','delete from   eqm_borders_tbl');


select del_NoTrigger('eqm_compens_station_h','delete from   eqm_compens_station_h');
select del_NoTrigger('eqm_compens_station_tbl','delete from   eqm_compens_station_tbl');

select del_NoTrigger('eqm_compens_station_inst_h','delete from   eqm_compens_station_inst_h');
select del_NoTrigger('eqm_compens_station_inst_tbl','delete from   eqm_compens_station_inst_tbl');

select del_NoTrigger('eqm_compensator_h','delete from   eqm_compensator_h');
select del_NoTrigger('eqm_compensator_tbl','delete from   eqm_compensator_tbl');

select del_NoTrigger('eqm_compensator_i_h','delete from   eqm_compensator_i_h');
select del_NoTrigger('eqm_compensator_i_tbl','delete from   eqm_compensator_i_tbl');

select del_NoTrigger('eqm_eqp_tree_h','delete from   eqm_eqp_tree_h');
select del_NoTrigger('eqm_eqp_tree_tbl','delete from   eqm_eqp_tree_tbl');

select del_NoTrigger('eqm_eqp_use_h','delete from   eqm_eqp_use_h');
select del_NoTrigger('eqm_eqp_use_tbl','delete from   eqm_eqp_use_tbl');



select del_NoTrigger('eqm_equipment_h','delete from   eqm_equipment_h');
select del_NoTrigger('eqm_equipment_tbl','delete from   eqm_equipment_tbl');
--select del_NoTrigger('eqm_equipment_tmp','delete from   eqm_equipment_tmp');

select del_NoTrigger('eqm_fider_h','delete from   eqm_fider_h');
select del_NoTrigger('eqm_fider_tbl','delete from   eqm_fider_tbl');

select del_NoTrigger('eqm_fuse_h','delete from   eqm_fuse_h');
select del_NoTrigger('eqm_fuse_tbl','delete from   eqm_fuse_tbl');

select del_NoTrigger('eqm_jack_h','delete from   eqm_jack_h');
select del_NoTrigger('eqm_jack_tbl','delete from   eqm_jack_tbl');

select del_NoTrigger('eqm_line_a_h','delete from   eqm_line_a_h');
select del_NoTrigger('eqm_line_a_tbl','delete from   eqm_line_a_tbl');

select del_NoTrigger('eqm_line_c_h','delete from   eqm_line_c_h');
select del_NoTrigger('eqm_line_c_tbl','delete from   eqm_line_c_tbl');

select del_NoTrigger('eqm_meter_h','delete from   eqm_meter_h');
select del_NoTrigger('eqm_meter_tbl','delete from   eqm_meter_tbl');


select del_NoTrigger('eqm_meter_point_h','delete from   eqm_meter_point_h');
--select del_NoTrigger('eqm_meter_point_tbl','delete from   eqm_meter_point_tbl');

select del_NoTrigger('eqm_point_h','delete from   eqm_point_h');
select del_NoTrigger('eqm_point_tbl','delete from   eqm_point_tbl');

select del_NoTrigger('eqm_privmeter_tbl','delete from   eqm_privmeter_tbl');

select del_NoTrigger('eqm_switch_h','delete from   eqm_switch_h');
select del_NoTrigger('eqm_switch_tbl','delete from   eqm_switch_tbl');

select del_NoTrigger('eqm_tree_h','delete from   eqm_tree_h');
select del_NoTrigger('eqm_tree_tbl','delete from   eqm_tree_tbl');
--select del_NoTrigger('eqm_tree_tmp','delete from   eqm_tree_tmp');

select del_NoTrigger('acd_demandlimit_del','delete from   acd_demandlimit_del');
select del_NoTrigger('acd_demandlimit_tbl','delete from   acd_demandlimit_tbl');

select del_NoTrigger('acd_indication_del','delete from   acd_indication_del');
select del_NoTrigger('acd_indication_tbl','delete from   acd_indication_tbl');

select del_NoTrigger('acd_met_kndzn_del','delete from   acd_met_kndzn_del');
select del_NoTrigger('acd_met_kndzn_tbl','delete from   acd_met_kndzn_tbl');

select del_NoTrigger('acd_pnt_tarif_del','delete from   acd_pnt_tarif_del');
select del_NoTrigger('acd_pnt_tarif','delete from   acd_pnt_tarif');

select del_NoTrigger('acd_point_branch_del','delete from   acd_point_branch_del');
select del_NoTrigger('acd_point_branch_tbl','delete from  acd_point_branch_tbl');

select del_NoTrigger('acd_pwr_demand_del','delete from   acd_pwr_demand_del');
select del_NoTrigger('acd_pwr_demand_tbl','delete from  acd_pwr_demand_tbl');

select del_NoTrigger('acd_pwr_limit_over_del','delete from   acd_pwr_limit_over_del');
select del_NoTrigger('acd_pwr_limit_over_tbl','delete from  acd_pwr_limit_over_tbl');

select del_NoTrigger('acd_pwr_limit_pnt_del','delete from   acd_pwr_limit_pnt_del');
select del_NoTrigger('acd_pwr_limit_pnt_tbl','delete from  acd_pwr_limit_pnt_tbl');

select del_NoTrigger('acd_summ_val_del','delete from   acd_summ_val_del');
select del_NoTrigger('acd_summ_val','delete from  acd_summ_val');

select del_NoTrigger('acd_tax_del','delete from   acd_tax_del');
select del_NoTrigger('acd_tax_tbl','delete from  acd_tax_tbl');

select del_NoTrigger('acm_bill_del','delete from   acm_bill_del');
select del_NoTrigger('acm_bill_tbl','delete from  acm_bill_tbl');

select del_NoTrigger('acm_pay_tbl','delete from  acm_pay_tbl');

delete from acm_billpay_tbl;
delete from acm_billtax_tbl;


delete from acm_demand_tbl;
delete from acm_headdem_tbl;

delete from acm_headdemandlimit_tbl;
delete from acm_headdemandlimit_del;

delete from adm_address_tbl;
delete from adm_commadr_tbl;

delete from bal_acc_tbl;
delete from  bal_client_errors_tbl;
delete from bal_fizabon_coef_tbl;
delete from clm_client;
delete from eqm_changelog_tbl;
select del_NoTrigger('eqm_ground_tbl','delete from eqm_ground_tbl;');
delete from eqm_ground_h;
delete from eqt_change_tbl;
delete from eqt_viewtree;

delete from seb_obr_all_tbl;
delete from seb_obrs_tbl;
delete from seb_plan;
delete from seb_renthist_tbl;

delete from ss_met;
delete from ss_pok;

select del_NoTrigger('acm_headindication_tbl','delete from  acm_headindication_tbl');
select del_NoTrigger('acm_headpay_tbl','delete from  acm_headpay_tbl');

select del_NoTrigger('acd_taxcorrection_tbl','delete from  acd_taxcorrection_tbl');












