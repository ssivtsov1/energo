CREATE SEQUENCE clm_switching_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


CREATE TABLE clm_switching_tbl 
(
  id int4 NOT NULL DEFAULT nextval('clm_switching_seq'::text),
  id_client int,
  action int,
  dt_action date,
  percent  numeric(6,2),
  "comment" varchar(254),
  dt timestamp without time zone default now(),
  id_person integer default GetSysVar('id_person'),
  PRIMARY KEY (id)
);



alter table clm_switching_tbl add column dt_warning date;
alter table clm_switching_tbl add column sum_warning numeric;
alter table clm_switching_tbl alter column sum_warning set default 0.00;
update clm_switching_tbl set sum_warning = 0.00 where sum_warning is null;

alter table clm_switching_tbl add column place_off varchar(50);
alter table clm_switching_tbl add column reason_off varchar(50);
alter table clm_switching_tbl add column dt_transmiss date;
alter table clm_switching_tbl add column mode_transmiss varchar(50);

ALTER TABLE clm_switching_tbl ADD COLUMN sum_ae numeric(14,2);
ALTER TABLE clm_switching_tbl ADD COLUMN sum_re numeric(14,2);
ALTER TABLE clm_switching_tbl ADD COLUMN sum_2kr numeric(14,2);