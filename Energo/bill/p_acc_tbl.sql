-- -------------------------------------------------------------------------
-- создание таблиц для хранения расчетных данных для формирования счета
-- ------------------------------------------------ Mon 12 May 10:57:48 2003

select DropTable('acd_point_branch_tbl'); -- получена из  act_point_branch_tbl
create table acd_point_branch_tbl (
     id_doc             int,
     dt                 timestamp,
     id_tree    	int,  	-- tree index
     id_point		int,		-- meter index
     id_p_point		int,		
     dat_b		timestamp,
     dat_e		timestamp,
     id_client		int,
     id_border		int,
     count_lost		int,
     level              int,
     num_order          int
-- ,     primary key(id_point)
);

select DropTable('acd_met_kndzn_tbl');
create table acd_met_kndzn_tbl (
     id_doc             int,
     dt                 timestamp,
     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     id_zone		int,	
     k_tr		int default 1,
     id_type_eqp	int,
     dat_b		timestamp,
     dat_e		timestamp,
     b_val		numeric(14,4),
     e_val		numeric(14,4),
     id_parent_doc	int,
     met_demand		numeric(14,4),
     ktr_demand		int,
     dat_b_zone		timestamp,
     dat_b_energy	timestamp
-- ,     primary key(id_meter,num_eqp,kind_energy,id_zone,dat_b)
);

select DropTable('acd_pnt_tarif');
create table acd_pnt_tarif (
     id_doc             int,
     dt                 timestamp,
     id_point		int,		
     id_tarif		int,		
     dat_b		timestamp,
     dat_e		timestamp
-- ,     primary key(id_point,id_tarif,dat_b)
);

select DropTable('acd_pwr_demand_tbl');
create table acd_pwr_demand_tbl (
     id_doc             int,
     dt                 timestamp,
     id_point		int,
     kind_energy	int,
     id_tarif           int,
     id_zone		int,	
     dat_b		timestamp,
     dat_e		timestamp,
     fact_demand	int,
     sum_losts_c	int,
     sum_losts_l	int,
     fact_losts_c	int,
     fact_losts_l	int,
     ident		int
-- ,     primary key(id_point,kind_energy,dat_b,id_zone,ident)
);

