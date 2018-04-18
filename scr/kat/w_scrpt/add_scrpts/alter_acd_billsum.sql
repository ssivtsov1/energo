drop function upd_billsumarea_tmp();
CREATE function upd_billsumarea_tmp() Returns boolean As'
Declare
begin
if calc_type(''acd_billsum_tbl'',''id_area'')=''empty'' then
alter table acd_billsum_tbl add column id_area int;
alter table acd_billsum_del add column id_area int;

 Return true;
else
 Return false;
end if;
end;
' Language 'plpgsql';

select upd_billsumarea_tmp();

drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
begin
if calc_type(''acd_billsum_tbl'',''p1'')=''empty'' then
alter table acd_billsum_tbl add column p1 numeric(14,4);
alter table acd_billsum_tbl add column p2 numeric(14,4);
alter table acd_billsum_tbl add column p3 numeric(14,4);
alter table acd_billsum_tbl add column tg_fi numeric(4,2);
alter table acd_billsum_tbl add column k_fi numeric(6,4);
alter table acd_billsum_tbl add column d numeric(6,4);
alter table acd_billsum_tbl add column wp int;
alter table acd_billsum_tbl add column wq int;

alter table acd_billsum_del add column p1 numeric(14,4);
alter table acd_billsum_del add column p2 numeric(14,4);
alter table acd_billsum_del add column p3 numeric(14,4);
alter table acd_billsum_del add column tg_fi numeric(4,2);
alter table acd_billsum_del add column k_fi numeric(6,4);
alter table acd_billsum_del add column d numeric(6,4);
alter table acd_billsum_del add column wp int;
alter table acd_billsum_del add column wq int;

 Return true;
else
 Return false;
end if;
end;
' Language 'plpgsql';

--select upd_tbl_tmp();
drop function upd_tbl_tmp();

drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
res boolean;
begin
if calc_type(''acm_bill_tbl'',''id_ind'')=''empty'' then
 alter table acm_bill_tbl add column id_ind int; 
 alter table acm_bill_tbl alter column id_ind set default 0;

 alter table acm_bill_del add column id_ind int;
end if;

if calc_type(''acd_pwr_demand_tbl'',''sum_losts'')=''empty'' then
  alter table acd_pwr_demand_tbl drop column sum_losts_c;
  alter table acd_pwr_demand_tbl drop column sum_losts_l;
  alter table acd_pwr_demand_del drop column sum_losts_c;
  alter table acd_pwr_demand_del drop column sum_losts_l;
  alter table acd_pwr_demand_tbl add column sum_losts int;
  alter table acd_pwr_demand_del add column sum_losts int;
end if;

if calc_type(''acd_pwr_demand_tbl'',''fact_losts'')=''empty'' then
  alter table acd_pwr_demand_tbl drop column fact_losts_c;
  alter table acd_pwr_demand_tbl drop column fact_losts_l;
  alter table acd_pwr_demand_del drop column fact_losts_c;
  alter table acd_pwr_demand_del drop column fact_losts_l;
  alter table acd_pwr_demand_tbl add column fact_losts int;
  alter table acd_pwr_demand_del add column fact_losts int;
end if;

 res:=altr_colmn(''acd_pwr_demand_tbl'',''dat_b'',''date'');
 res:=altr_colmn(''acd_pwr_demand_tbl'',''dat_e'',''date'');
 res:=altr_colmn(''acd_pwr_demand_del'',''dat_b'',''date'');
 res:=altr_colmn(''acd_pwr_demand_del'',''dat_e'',''date'');

 res:=altr_colmn(''acd_point_branch_tbl'',''dat_b'',''date'');
 res:=altr_colmn(''acd_point_branch_tbl'',''dat_e'',''date'');
 res:=altr_colmn(''acd_point_branch_del'',''dat_b'',''date'');
 res:=altr_colmn(''acd_point_branch_del'',''dat_e'',''date'');

 res:=altr_colmn(''acd_met_kndzn_tbl'',''dat_b'',''date'');
 res:=altr_colmn(''acd_met_kndzn_tbl'',''dat_e'',''date'');
 res:=altr_colmn(''acd_met_kndzn_del'',''dat_b'',''date'');
 res:=altr_colmn(''acd_met_kndzn_del'',''dat_e'',''date'');

 res:=altr_colmn(''acd_pnt_tarif'',''dat_b'',''date'');
 res:=altr_colmn(''acd_pnt_tarif'',''dat_e'',''date'');
 res:=altr_colmn(''acd_pnt_tarif_del'',''dat_b'',''date'');
 res:=altr_colmn(''acd_pnt_tarif_del'',''dat_e'',''date'');

Return true;
end;
' Language 'plpgsql';

--select upd_tbl_tmp();
drop function upd_tbl_tmp();

