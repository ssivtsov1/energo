CREATE TABLE acm_headdemandlimit_tbl (
    id_doc integer DEFAULT nextval('dcm_doc_seq'::text) NOT NULL,
    dt timestamp without time zone default now(),
    id_person integer default GetSysVar('id_person'),
    reg_date date,
    reg_num character varying(20),
    idk_document integer,
    id_client integer,
    date_begin date,
    date_end date,
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0,
    primary key(id_doc)
);



  CREATE SEQUENCE acd_demandlimit_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

CREATE TABLE acd_demandlimit_tbl (
    id integer DEFAULT nextval('acd_demandlimit_seq'::text) NOT NULL,
    dt timestamp without time zone default now(),
    id_person integer default GetSysVar('id_person'),

    kind_energy integer,

    id_area integer,        --площадка                        
    night_day  int,         --утренний/вечерний лимит мощности
    month_limit date,
    value_dem numeric(14,4),

    id_doc integer,
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0,
    id_client integer,
    primary key(id)
    , foreign key (id_doc) references acm_headdemandlimit_tbl(id_doc)
);


alter table acd_demandlimit_tbl add column id_area integer;
alter table acd_demandlimit_tbl add column night_day integer;

---контрольные показания для 2-кр по мощности

CREATE TABLE acm_headpowerindication_tbl (
    id_doc integer DEFAULT nextval('dcm_doc_seq'::text) NOT NULL,
    dt timestamp without time zone default now(),
    id_person integer default GetSysVar('id_person'),
    reg_date date,
    reg_num character varying(20),
    idk_document integer,
    id_client integer,
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0,
    primary key(id_doc)
);

alter table acm_headpowerindication_tbl add column id_file varchar(20);
alter table acm_headpowerindication_tbl add column night_day int;
alter table acm_headpowerindication_tbl add column comment varchar(200);

  drop trigger acm_headpowerindication_del on acm_headpowerindication_tbl;
drop function fun_headpowerindication_del();
create function fun_headpowerindication_del() returns opaque as'
Declare
  begin 
   if old.flock=1 then 
     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    
  --  delete from acm_headindication_tbl where id_main_ind=old.id_doc;
    delete from acd_powerindication_tbl where id_doc=old.id_doc;
  delete from acm_bill_tbl where id_ind=old.id_doc;
  Return old;  
end;     
' Language 'plpgsql';

create trigger acm_headpowerindication_del
    Before Delete ON acm_headpowerindication_tbl
    For Each Row Execute Procedure fun_headpowerindication_del();



CREATE SEQUENCE acd_powerindication_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;


CREATE TABLE acd_powerindication_tbl
(
  id int DEFAULT nextval('acd_powerindication_seq'::text),
  id_doc int,
  dt timestamp without time zone default now(),
  id_person int default GetSysVar('id_person'),
  id_meter int,
  num_eqp varchar(25),
  kind_energy int,
  id_zone int default 0,
  id_client int,
  id_area integer,
  time_indic timestamp,
  value numeric(14,4),
  night_day  int,         --утренний/вечерний замер
  id_previndic int,

  ---поля из стандартных показаний для совместимости

  id_typemet int,
  id_typecompa int,
  id_typecompu int,

  carry int,
  k_tr numeric(14,4), -- общий коеф. трансформации
  k_ts numeric(14,4), -- коеф. трансформации тока

  value_dev numeric(14,4),
  value_dem numeric(14,4),

--  value_prev numeric(14,4),

  mmgg date DEFAULT fun_mmgg(),
  flock int DEFAULT 0,

  PRIMARY KEY (id)
); 

alter table acd_powerindication_tbl add column night_day integer;
alter table acd_powerindication_tbl alter column k_tr set default 1;
alter table acd_powerindication_tbl alter column k_ts set default 1;
update acd_powerindication_tbl set k_tr=1 where k_tr<1;
update acd_powerindication_tbl set k_ts=1 where k_ts<1;

/*
drop TABLE acd_pwr_limit_over_tbl;
drop TABLE acd_pwr_limit_over_del;
drop TABLE acd_pwr_limit_pnt_tbl;
drop TABLE acd_pwr_limit_pnt_del;


*/
CREATE TABLE acd_pwr_limit_over_tbl (
    id_doc 	int,
    dt 		timestamp without time zone default now(),
    id_area     int DEFAULT 0,
    night_day   int,
    power_limit int,
    power_fact  int,
    power_ower  int,
    power_trans int,
    power_bill  int,
    tarif       numeric(14,4),
    sum_value   numeric(14,2),
    dat_b       date,
    dat_e       date,
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0,
    primary key(id_doc,id_area,night_day)
);

alter table  acd_pwr_limit_over_tbl add column dat_b date;
alter table  acd_pwr_limit_over_tbl add column dat_e date;
alter table  acd_pwr_limit_over_tbl add column power_ower int;
alter table  acd_pwr_limit_over_tbl add column power_bill int;
alter table  acd_pwr_limit_over_tbl add column power_trans int;

create sequence acd_pwr_limit_overd_seq;
CREATE TABLE acd_pwr_limit_over_del
( id int ,
  id_doc int4 NOT NULL,
  dt timestamp ,
  id_area int4 NOT NULL DEFAULT 0,
  night_day int4 NOT NULL,
  power_limit int4,
  power_fact int4,
  power_ower int4,
  power_trans int,
  power_bill  int,
  tarif numeric(14,4),
  sum_value numeric(14,2),
  dat_b       date,
  dat_e       date,
  mmgg date DEFAULT fun_mmgg(),
  flock int4 DEFAULT 0,

  id_change int  DEFAULT nextval('acd_pwr_limit_overd_seq'::text),
  dt_change timestamp without time zone default now(),
  id_person_change integer default GetSysVar('id_person'),
  primary key(id_change)
); 

create sequence acd_pwr_limit_pnt_seq;
CREATE TABLE acd_pwr_limit_pnt_tbl
( id int  DEFAULT nextval('acd_pwr_limit_pnt_seq'::text),
  id_doc int4 NOT NULL,
  dt timestamp default now(),
  id_area int4 NOT NULL DEFAULT 0,
  id_point int4,
  demand int4,
  dat_b       date,
  dat_e       date,
  mmgg date DEFAULT fun_mmgg(),
  flock int4 DEFAULT 0
); 


create sequence acd_pwr_limit_pntd_seq;
CREATE TABLE acd_pwr_limit_pnt_del
( id int ,
  id_doc int4 NOT NULL,
  dt timestamp ,
  id_area int4 NOT NULL DEFAULT 0,
  id_point int4,
  demand int4,
  dat_b       date,
  dat_e       date,
  mmgg date DEFAULT fun_mmgg(),
  flock int4 DEFAULT 0,
  id_change int  DEFAULT nextval('acd_pwr_limit_pntd_seq'::text),
  dt_change timestamp without time zone default now(),
  id_person_change integer default GetSysVar('id_person'),
    primary key(id_change)
); 
