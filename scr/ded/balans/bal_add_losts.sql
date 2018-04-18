ALTER TABLE bal_acc_tbl ADD COLUMN losts_ti numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_ti SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_tu numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_tu SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_meter numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_meter SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_linea numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_linea SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_linec numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_linec SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_ti numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_ti SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_tu numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_tu SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_meter numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_meter SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_linea numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_linea SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_linec numeric(14,4);
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_linec SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN fiz_demand integer;
ALTER TABLE bal_acc_tbl ALTER COLUMN fiz_demand SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN nolost_demand integer;
ALTER TABLE bal_acc_tbl ALTER COLUMN nolost_demand SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_kz int;
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_kz SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_xx int;
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_xx SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_kz int;
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_kz SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_xx int;
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_xx SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_air int;
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_air SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN losts_cable int;
ALTER TABLE bal_acc_tbl ALTER COLUMN losts_cable SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_air int;
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_air SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN sumlosts_cable int;
ALTER TABLE bal_acc_tbl ALTER COLUMN sumlosts_cable SET DEFAULT 0;

ALTER TABLE bal_acc_tbl ADD COLUMN id_un int;
ALTER TABLE bal_acc_tbl ADD COLUMN id_spr_type int;

--ALTER TABLE bal_acc_tbl ADD COLUMN fact_demand integer;


create table eqi_meter_losts_tbl
(
  kind_meter integer NOT NULL,
  phase integer NOT NULL,
  class varchar(10),
  power_lost numeric (12,10),
 primary key (kind_meter,phase,class)
);

create table bal_weather_coef_tbl
(
  weather integer NOT NULL,
  voltage integer NOT NULL,
  power_lost numeric (12,10),
 primary key (weather,voltage)
);


create table bal_weather_calendar_tbl
(
  mmgg    date, 
  weather integer,
 primary key (mmgg)
);

create table bal_cable_coef_tbl
(
  s_min   integer NOT NULL,
  s_max   integer NOT NULL,
  voltage integer NOT NULL,
  g0      numeric (12,10),
 primary key (s_min,s_max,voltage)
);


create table bal_losts04_tbl(
     code_eqp		int,		
     l04_count 		int,
     l04_length 	int,
     l04f1_length 	int,
     l04f3_length 	int   ,
     fgcp 		numeric(12,4) ,
     fiz_demand         int,
     nolost_demand	int,
--     lost04_metod 	int,
     losts04		int,
     mmgg               date,
     primary key(code_eqp,mmgg)
);


insert into bal_weather_coef_tbl values (1,6000,0.011);
insert into bal_weather_coef_tbl values (2,6000,0.094);
insert into bal_weather_coef_tbl values (3,6000,0.154);

insert into bal_weather_coef_tbl values (1,10000,0.017);
insert into bal_weather_coef_tbl values (2,10000,0.153);
insert into bal_weather_coef_tbl values (3,10000,0.255);


insert into bal_cable_coef_tbl values (1,16,10000,5.9);
insert into bal_cable_coef_tbl values (17,25,10000,8.6);
insert into bal_cable_coef_tbl values (26,35,10000,10.7);
insert into bal_cable_coef_tbl values (36,50,10000,11.7);
insert into bal_cable_coef_tbl values (51,70,10000,13.5);
insert into bal_cable_coef_tbl values (71,95,10000,15.6);
insert into bal_cable_coef_tbl values (96,120,10000,16.9);
insert into bal_cable_coef_tbl values (121,150,10000,18.3);
insert into bal_cable_coef_tbl values (151,185,10000,20);
insert into bal_cable_coef_tbl values (186,240,10000,21.5);

insert into bal_cable_coef_tbl values (1,10,6000,2.3);
insert into bal_cable_coef_tbl values (11,16,6000,2.6);
insert into bal_cable_coef_tbl values (17,25,6000,4.1);
insert into bal_cable_coef_tbl values (26,35,6000,4.6);
insert into bal_cable_coef_tbl values (36,50,6000,5.2);
insert into bal_cable_coef_tbl values (51,70,6000,6.6);
insert into bal_cable_coef_tbl values (71,95,6000,8.7);
insert into bal_cable_coef_tbl values (96,120,6000,9.5);
insert into bal_cable_coef_tbl values (121,150,6000,10.4);
insert into bal_cable_coef_tbl values (151,185,6000,11.7);
insert into bal_cable_coef_tbl values (186,240,6000,13);


insert into bal_weather_calendar_tbl values ('2009-07-01',1);
insert into bal_weather_calendar_tbl values ('2009-08-01',1);
insert into bal_weather_calendar_tbl values ('2009-09-01',1);
insert into bal_weather_calendar_tbl values ('2009-10-01',1);

insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,2,'0.2',0.00000945);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,2,'0.5',0.00000945);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,2,'1',0.00000885);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,2,'2',0.00000468);

insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,1,'0.2',0.0000036);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,1,'0.5',0.0000036);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,1,'1',0.0000034);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,1,'2',0.00000133);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (1,1,'2.5',0.00000207);

insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,2,'0.2',0.0000063);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,2,'0.5',0.0000063);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,2,'1',0.0000072);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,2,'2',0.00000675);

insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,1,'0.2',0.0000021);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,1,'0.5',0.0000021);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,1,'1',0.0000024);
insert into eqi_meter_losts_tbl (kind_meter,phase,class,power_lost) values (2,1,'2',0.0000025);



--количество линий 0.4
ALTER TABLE eqm_fider_tbl ADD COLUMN l04_count integer;
ALTER TABLE eqm_fider_tbl ALTER COLUMN l04_count SET DEFAULT 0;
-- общая длина линий 0.4,м
ALTER TABLE eqm_fider_tbl ADD COLUMN l04_length integer;
ALTER TABLE eqm_fider_tbl ALTER COLUMN l04_length SET DEFAULT 0;
--длина однофазных ответвлений,м
ALTER TABLE eqm_fider_tbl ADD COLUMN l04f1_length integer;
ALTER TABLE eqm_fider_tbl ALTER COLUMN l04f1_length SET DEFAULT 0;
--длина трехфазных ответвлений,м
ALTER TABLE eqm_fider_tbl ADD COLUMN l04f3_length integer;
ALTER TABLE eqm_fider_tbl ALTER COLUMN l04f3_length SET DEFAULT 0;
--среднее сечение головных участков, мм2
ALTER TABLE eqm_fider_tbl ADD COLUMN Fgcp numeric(12,4);
ALTER TABLE eqm_fider_tbl ALTER COLUMN Fgcp SET DEFAULT 0;

ALTER TABLE eqm_fider_tbl ADD COLUMN  balans_only int;
ALTER TABLE eqm_fider_tbl ALTER COLUMN balans_only SET DEFAULT 0;


ALTER TABLE eqm_fider_h ADD COLUMN l04_count integer;
ALTER TABLE eqm_fider_h ALTER COLUMN l04_count SET DEFAULT 0;
ALTER TABLE eqm_fider_h ADD COLUMN l04_length integer;
ALTER TABLE eqm_fider_h ALTER COLUMN l04_length SET DEFAULT 0;

ALTER TABLE eqm_fider_h ADD COLUMN l04f1_length integer;
ALTER TABLE eqm_fider_h ALTER COLUMN l04f1_length SET DEFAULT 0;

ALTER TABLE eqm_fider_h ADD COLUMN l04f3_length integer;
ALTER TABLE eqm_fider_h ALTER COLUMN l04f3_length SET DEFAULT 0;

ALTER TABLE eqm_fider_h ADD COLUMN Fgcp numeric(12,4);
ALTER TABLE eqm_fider_h ALTER COLUMN Fgcp SET DEFAULT 0;

ALTER TABLE eqm_fider_h ADD COLUMN  balans_only int;

update eqm_fider_tbl set l04_count = 0 where l04_count is null;
update eqm_fider_tbl set l04_length = 0 where l04_length is null;
update eqm_fider_tbl set l04f1_length = 0 where l04f1_length is null;
update eqm_fider_tbl set l04f3_length = 0 where l04f3_length is null;
update eqm_fider_tbl set Fgcp = 0 where Fgcp is null;

update eqm_fider_h set l04_count = 0 where l04_count is null;
update eqm_fider_h set l04_length = 0 where l04_length is null;
update eqm_fider_h set l04f1_length = 0 where l04f1_length is null;
update eqm_fider_h set l04f3_length = 0 where l04f3_length is null;
update eqm_fider_h set Fgcp = 0 where Fgcp is null;

ALTER TABLE eqm_fider_tbl ADD COLUMN id_station integer;
ALTER TABLE eqm_fider_h ADD COLUMN id_station integer;

alter table bal_grp_tree_tbl ADD COLUMN lost04_metod int;
alter table bal_grp_tree_tbl ADD COLUMN id_fider int;
alter table bal_grp_tree_conn_tbl ADD COLUMN id_fider int;



delete from acd_pwr_demand_tbl where not exists (select id_doc from acm_bill_tbl as b where b.id_doc = acd_pwr_demand_tbl.id_doc);
delete from acd_billsum_tbl where not exists (select id_doc from acm_bill_tbl as b where b.id_doc = acd_billsum_tbl.id_doc);


ALTER TABLE bal_eqp_tbl ADD COLUMN id_bal int;
ALTER TABLE bal_acc_tbl ADD COLUMN id_bal int;
ALTER TABLE bal_demand_tbl ADD COLUMN id_bal int;
ALTER TABLE bal_meter_demand_tbl ADD COLUMN id_bal int;
ALTER TABLE bal_grp_tree_tbl ADD COLUMN id_bal int;
ALTER TABLE bal_losts04_tbl ADD COLUMN id_bal int;
ALTER TABLE bal_grp_tree_conn_tbl ADD COLUMN id_bal int;

ALTER TABLE bal_eqp_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');
ALTER TABLE bal_acc_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');
ALTER TABLE bal_demand_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');
ALTER TABLE bal_meter_demand_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');
ALTER TABLE bal_grp_tree_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');
ALTER TABLE bal_losts04_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');
ALTER TABLE bal_grp_tree_conn_tbl ALTER COLUMN id_bal SET DEFAULT getsysvar('id_bal');



update bal_eqp_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
--update bal_eqp_tbl set id_bal = select value from syi_sysvars_tbl where ident= 'id_bal' where id_bal is null;
update bal_acc_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
update bal_demand_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
update bal_meter_demand_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
update bal_grp_tree_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
update bal_grp_tree_conn_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
update bal_losts04_tbl set  id_bal = (select to_number(value_ident,'999999999') from syi_sysvars_tbl where ident= 'id_bal') where id_bal is null;
 
ALTER TABLE bal_grp_tree_tbl ALTER COLUMN name TYPE  character varying(50);
ALTER TABLE bal_grp_tree_conn_tbl ALTER COLUMN name TYPE  character varying(50);
