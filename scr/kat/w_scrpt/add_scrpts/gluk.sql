----talalaevka 
alter table acd_point_branch_tbl alter column dat_b Set not null;
alter table acd_point_branch_tbl add primary key(id_point,dat_b,id_doc);

alter table acd_point_branch_del alter column dat_b Set not null;
alter table acd_point_branch_del add primary key(id_point,dat_b,id_doc);

alter table acd_met_kndzn_tbl alter column dat_b Set not null;
alter table acd_met_kndzn_tbl add primary key(id_doc,id_point,id_meter,num_eqp 
 ,kind_energy,id_zone,dat_b);

alter table acd_met_kndzn_del alter column dat_b Set not null;
alter table acd_met_kndzn_del add primary key(id_doc,id_point,id_meter,num_eqp 
 ,kind_energy,id_zone,dat_b);

alter table acd_pwr_demand_tbl alter column dat_b Set not null;
alter table acd_pwr_demand_tbl add primary key(id_doc,id_point,kind_energy
 ,dat_b,id_zone,ident);

alter table acd_pwr_demand_del alter column dat_b Set not null;
alter table acd_pwr_demand_del add primary key(id_doc,id_point,kind_energy
 ,dat_b,id_zone,ident);

alter table acd_pnt_tarif alter column dat_b Set not null;
alter table acd_pnt_tarif add primary key(id_doc,id_point,id_tarif,dat_b);

alter table acd_pnt_tarif_del alter column dat_b Set not null;
alter table acd_pnt_tarif_del add primary key(id_doc,id_point,id_tarif,dat_b);
