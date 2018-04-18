--delete from dck_document_tbl;
--set sequence dck_document_seq to 1;

--delete from dck_document_tbl where id in (1000,100,200,300,400);
;
insert into cli_state_tbl (id,name) values (49,'Закрыт договор');

insert into dck_document_tbl (id,name,ident) values(1000,'Сальдо','saldo');
insert into dck_document_tbl (id,name,ident) values(100,'Платежи','pay');
insert into dck_document_tbl (id,name,ident) values(200,'Счета','bill');
insert into dck_document_tbl (id,name,ident) values(300,'Отчеты о потреблении','rep_dem');
insert into dck_document_tbl (id,name,ident) values(400,'Договора','accord');
insert into dck_document_tbl (id,name,ident) values(500,'Доп.расчеты','adddem');

--delete from dci_group_tbl where id in (1000,100,200,300,400);
insert into dci_group_tbl (id,name,level) values(1000,'Сальдо',0);
insert into dci_group_tbl (id,name,level) values(100,'Платежи',0);
insert into dci_group_tbl (id,name,level) values(200,'Счета',0);
insert into dci_group_tbl (id,name,level) values(300,'Отчеты о потреблении',0);
insert into dci_group_tbl (id,name,level) values(400,'Договорные документы',0);


insert into dci_document_tbl (id,name,ident,idk_document) values(300,'Начальные показания','beg_ind',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(310,'Отчет о потреблении','rep_pwr',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(320,'Корректирующие показания','kor_ind',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(330,'Отчет по среднемy','rep_avg',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(340,'Установка счетчика','set_cnt',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(345,'Замена счетчика','chn_cnt',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(370,'Связанные отчеты','rep_bound',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(350,'Акт осмотра после отсутствия показаний','act_start',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(351,'Акт осмотра (неисправность не по вине потребителя)','act_chn',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(352,'Акт осмотра оборудования, акт нарушения правил','act_pwr',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(354,'Акт проверки оборудования без нарушений','act_check',300);
insert into dci_document_tbl (id,name,ident,idk_document) values(1000,'Салдо','saldo',1000);
insert into dci_document_tbl (id,name,ident,idk_document) values(100,'Платежка','pay',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(109,'Плат.акт','pay_act',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(110,'Квитанция','aquit',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(120,'Авизо','avizo',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(130,'Зачет','trush',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(191,'Льгота','comp_categ',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(199,'Корр.сальдо кредит','kork_sal',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(192,'Субсидия','subsid',100);
insert into dci_document_tbl (id,name,ident,idk_document) values(200,'Счет','bill',200);
delete from dci_document_tbl where id=280;
insert into dci_document_tbl (id,name,ident,idk_document) values(280,'Счет детал','bill_div',200);
insert into dci_document_tbl (id,name,ident,idk_document) values(209,'Счет.акт','bill_act',200);

insert into dci_document_tbl (id,name,ident,idk_document) values(291,'Корр.сальдо дебет','kord_sal',200);
insert into dci_document_tbl (id,name,ident,idk_document) values(201,'Авансовый счет','bill_avans',200);
insert into dci_document_tbl (id,name,ident,idk_document) values(400,'Договор','accord',400);

insert into dci_document_tbl (id,name,ident,idk_document) values(510,'Авансов. потребление','avans_dem',500);
insert into dci_document_tbl (id,name,ident,idk_document) values(520,'Дополн.физ.расчетов','fiz_dem',500);
insert into dci_document_tbl (id,name,ident,idk_document) values(530,'Среднее потребление','midl_dem',500);
insert into dci_document_tbl (id,name,ident,idk_document) values(540,'Перерасчет потребения','addpnt_dem',500);
insert into dci_document_tbl (id,name,ident,idk_document) values(541,'Распределение','div_sum',500);
insert into dci_document_tbl (id,name,ident,idk_document) values(550,'Перерасчет суммы','cor_sum',500);
insert into dci_document_tbl (id,name,ident,idk_document) values(560,'Расчет по акту','act_dem',500);

--delete from dci_document_tbl where id = 140;
insert into dci_document_tbl(id,name,idk_document,ident)  values(140,'Списание',100,'writeoff');
insert into dci_document_tbl(id,name,idk_document,ident)  values(149,'Списание акт',100,'wr_off_act');
delete from dci_document_tbl where id = 150;
insert into dci_document_tbl(id,name,idk_document,ident)  values(150,'Пост.664(чек)',100,'depozit_1');
insert into dci_document_tbl(id,name,idk_document,ident)  values(160,'Пост.664(перед.)',100,'depozit_2');

update dci_document_tbl set idk_document=200 where id>=200 and id<300;

--delete from aci_pref_tbl;

INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (10,'АЕ','расчеты за АЕ','act_ee',1);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (101,'СводАЕ','Сводный АЕ','act_sv',1);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (20,'РE','расчеты за РЕ','react_ee',2);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (201,'СводРE','Сводный РЕ','react_sv',2);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (11,'Фидер','АЕ для фидера','fider_ee',2);
--INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (1099,'АЕ-99','расчеты за АЕ 99 года','act_ee99',1);
--INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (2099,'РE-99','расчеты за РЕ 99 года','react_ee99',2);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (901,'Пеня','Пеня','pena',3);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (902,'Инф.','Инфляция','inf',4);
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (903,'3%.','3% годовых','3_proc',4); -- from yana
INSERT INTO aci_pref_tbl (id,name,comment,ident,kind_energy) VALUES (500,'5-КР.','Прев.лимита (5КР)','5kr',5);
insert into aci_pref_tbl (id,name,comment,ident,kind_energy) values (9999,'аванс','выписка авансов','avans',0);
INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (510, '2-КР мощ', 'Прев.лимита (2КР) мощность', '2kr_p', 6, NULL, NULL, 0);
INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (520, '2-КР потр', 'Прев.лимита (2КР) потребление', '2kr_d', 6, NULL, NULL, 1);
INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (110, 'Передача ЕЕ', 'расчеты за передачу ЕЕ ', 'transit', 0, NULL, NULL, 0);
INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (120, 'Инф.услуги', 'инф.услуги за передачу ее', 'service', 0, NULL, NULL, 0);
INSERT INTO aci_pref_tbl (id, name, "comment", ident, kind_energy, pref, dt_pref, in_acc) VALUES (524, '2-КР 2014', 'Прев.лимита (2КР 2014) потребление', '2kr_d', 6, NULL, NULL, 1);
update aci_pref_tbl set ident ='2kr_od' where id=520; 

update aci_pref_tbl set in_acc=1 where id in (10,20,520,524);

--- for 2014 2-ka
update acm_bill_tbl set id_pref=524 where id_pref=520 and mmgg>='2014-01-01' and mmgg_bill>='2014-01-01'; 

update acm_pay_tbl set id_pref=524 where id_pref=520 and mmgg>='2014-01-01' and mmgg_pay>='2014-01-01'; 


--delete from aci_pref_tbl where id in (1099,2099);

create sequence clm_protocol_seq increment 1; 
CREATE TABLE clm_protocol_tbl 
( id          int default nextval('clm_protocol_seq'),
  id_client   int,
  mmgg        date default fun_mmgg(),
  reg_date    date, 
  reg_num     varchar (15),
  comment     varchar(150),
  flock       int,
primary key (id_client,mmgg)
);



--drop table clm_docconnect_tbl;
create sequence clm_docconnect_seq increment 1; 
CREATE TABLE clm_docconnect_tbl 
( id               int default nextval('clm_docconnect_seq'),
  name             varchar(180),
  id_client        int,
  id_org_tu        int,
  dt_tu            date,
  n_pay_tu         varchar(20),
  set_power_tu     numeric(10,4),
  dt_pay_tu        date,
  N_connect        varchar(20),
  dt_connect       date,
  n_pay_connect    varchar(20),
  dt_pay_connect   date,
  id_org_proect    int,
  n_pay_proect     varchar(20),
  dt_pay_proect    date,
  n_act_net        varchar(20),
  dt_act_net       date,
  n_common_use     varchar(20),
  dt_common_use    date,
  dt_real_connect  date,
  comment          varchar(150),
  mmgg       date DEFAULT fun_mmgg(), 
  flock      int   default 0,
primary key (id)
);

create sequence clm_org_seq increment 1; 
CREATE TABLE clm_org_tbl 
( id               int default nextval('clm_org_seq'),
  name             varchar(200),
  short_name       varchar(35),
  id_address       int,
primary key (id)
);

insert into clm_org_tbl (id,name,short_name) values (1000000,'ВАТ ЕК Чернигiвобленерго','ВАТ ЕК Чернигiвобленерго');

/*
--alter table eqm_borders_tbl add column id_doc int;
--alter table eqm_borders_h add column id_doc int;

--alter table eqm_borders_h rename column dt_b to dt_b1;

--alter table eqm_borders_h add column dt_b timestamp;

--update eqm_borders_h set dt_b=dt_b1;
--alter table eqm_borders_h drop column dt_b1;

--alter table eqm_borders_h rename column dt_e to dt_e1;
--alter table eqm_borders_h add column dt_e timestamp;
--update eqm_borders_h set dt_e=dt_e1;
--alter table eqm_borders_h drop column dt_e1;

--alter table eqm_borders_h rename column mmgg to mmgg1;
--alter table eqm_borders_h add column mmgg date;
--update eqm_borders_h set mmgg=mmgg1;
--alter table eqm_borders_h alter column mmgg set default fun_mmgg();
--alter table eqm_borders_h drop column mmgg1;

--alter table eqm_borders_h rename column dt to dt1;
--alter table eqm_borders_h add column dt date;
--update eqm_borders_h set dt=dt1;
--alter table eqm_borders_h alter column dt set default now();
--alter table eqm_borders_h drop column dt1;


*/


update syi_sysvars_tbl set value_ident=1 where id=10;


