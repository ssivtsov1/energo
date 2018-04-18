
--select DropTable('bal_eqp_tbl');
create table bal_eqp_tbl (
     id_tree    	int,  	-- tree index
     code_eqp		int,		-- equipment index
     id_p_eqp		int,		--
     type_eqp		int,
     id_type_eqp	int,
     dat_b		timestamp,
     dat_e		timestamp,
     lvl		int,	
     id_client		int,
     id_rclient		int,
     loss_power         int,
--for calc losts
     sn_len		numeric(14,2),
     tgfi		numeric(5,2),
     tt			int,
     pxx_r0		numeric(14,4),
     pkz_x0		numeric(14,4),
     ixx		numeric,
     ukz_un		numeric,
     mmgg               date
     ,primary key(code_eqp,id_tree,mmgg)
);

--select DropTable('bal_acc_tbl');
create table bal_acc_tbl (
     code_eqp		int,		-- equipment index
     dat_b		timestamp,
     dat_e		timestamp,
     demand		int,
     demand04           int,          -- ����������� �� 0.4 �� 
     lst		int default 0, -- ����� ������ ������� 
     losts		int default 0, -- ����������� ������ ������������ 
     mmgg               date,
     primary key(code_eqp,mmgg)
);


--select DropTable('bal_client_errors_tbl');
create table bal_client_errors_tbl (
     id 	   serial,
     id_client     int,
     id_tree   	   int,
     id_border     int,
     id_parent_eqp int,	
     id_grp	   int,	
     mmgg          date,
     primary key(id)
);


--select DropTable('bal_meter_demand_tbl');
create table bal_meter_demand_tbl (

     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     k_tr		int default 1,
     id_type_eqp	int,
     dat_b		timestamp,
     dat_e		timestamp,
     b_val		numeric(14,4),
     e_val		numeric(14,4),
     met_demand		numeric(14,4),
     ktr_demand		int,
     mmgg               date,
     primary key(id_meter,num_eqp,k_tr,mmgg)
);


--select DropTable('bal_demand_tbl');
create table bal_demand_tbl (

     id_point		int,
     ktr_demand		int,
     mmgg               date,
     primary key(id_point,mmgg)
);


--select DropTable('bal_grp_tree_tbl');
create table bal_grp_tree_tbl(
     id_tree    	int,  	-- tree index
     code_eqp		int,		-- equipment index
     name               varchar(25),
     id_p_eqp		int,		--
     type_eqp		int,
     dat_b		timestamp,
     dat_e		timestamp,
     lvl		int,	
     id_client		int,
     id_point           int, --����� ����� ��� �������, ������, ���������
     demand		int, -- �������� ������ �� ������
     demand04           int, -- ����������� �� 0.4 
     losts		int, -- ������ �� ������ 
     fact_losts         int, -- ����������� ������ (��� ��������)
     losts_coef         numeric(12,10) default 0,
     id_voltage         int,
     mmgg               date,
     primary key(code_eqp,id_tree,mmgg)
);

  
-- ���������� �������� �������/�� �� �����������
--select DropTable('bal_fider_errors_tbl');
create table bal_fider_errors_tbl(
     id_area    	int,  	-- fider/station index
     name_area          varchar(50),
     roots              int,    -- ���������� ��������� ����� ������� (>1 = ������)
     code_eqp_root	int,    -- id ��������� �����
     name_eqp_root      varchar(50), -- �������� �� 
     id_p_eqp		int,	-- id ������ ��������� ����� (��������� ����� ������)
     name_p_eqp         varchar(50) -- �������� �� 
--     primary key(id_area,code_eqp_root)
);




