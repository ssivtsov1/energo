alter table acd_calc_losts_tbl add column res_l int;
alter table acd_pwr_demand_tbl add column in_res_losts int;
alter table acd_pwr_demand_tbl add column out_res_losts int;
alter table acd_pwr_demand_tbl add column abn_losts int;

alter table acd_calc_losts_del add column res_l int;
alter table acd_pwr_demand_del add column in_res_losts int;
alter table acd_pwr_demand_del add column out_res_losts int;
alter table acd_pwr_demand_del add column abn_losts int;


alter table acd_pwr_demand_del drop column abn_res_losts;
alter table acd_pwr_demand_tbl drop column abn_res_losts;


\i tmptbl.sql
\i calclost.sql
\i selpnt.sql
\i seltree.sql
\i calcpnt.sql
\i crtbill.sql
\i table_calc.sql