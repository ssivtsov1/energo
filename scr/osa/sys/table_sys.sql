create sequence syi_table_seq;

\i syi_table.dmp
\i syi_field.dmp
 
select setval('syi_table_seq',(select max(id)+1 as di from syi_table_tbl));

alter table syi_table_tbl alter column  id set default nextval('syi_table_seq');
alter table syi_table_tbl add column  flag_repl  bool;
alter table syi_table_tbl alter column  flag_repl set default false;
alter table syi_table_tbl add column  flag_ins  bool;
alter table syi_table_tbl add column  flag_upd  bool;
alter table syi_table_tbl alter column  flag_ins set default false;
alter table syi_table_tbl alter column  flag_upd set default false;
alter table syi_table_tbl add column  flag_clear bool;
alter table syi_table_tbl alter column  flag_clear set default false;
alter table syi_table_tbl add column  ord_clear int;
alter table syi_table_tbl alter column  ord_clear set default 10;


alter table syi_table_tbl add column  ord integer;
update syi_table_tbl set flag_repl=true,ord =-100 where name='syi_table_tbl';
update syi_table_tbl set flag_repl=true,ord =-99 where name='syi_field_tbl';
update syi_table_tbl set flag_ins=true,ord =-100 where name='syi_table_tbl';
update syi_table_tbl set flag_ins=true,ord =-99 where name='syi_field_tbl';
update syi_table_tbl set flag_upd=true,ord =-100 where name='syi_table_tbl';
update syi_table_tbl set flag_upd=true,ord =-99 where name='syi_field_tbl';


update syi_field_tbl set flag_repl=true 
   where id_table=(select id from syi_table_tbl where name='syi_table_tbl');

update syi_field_tbl set flag_repl=true 
   where id_table=(select id from syi_table_tbl where name='syi_field_tbl');

update syi_table_tbl set ord=0 where ord is null and flag_repl=true;



alter table syi_field_tbl add column  flag_repl  bool;
alter table syi_field_tbl alter column  flag_repl set default false;

alter table syi_field_tbl add column  ord int;
--alter table syi_field_tbl alter column  ord ;


insert into syi_table_tbl (name) 
select  typname from (select * from pg_type where typnamespace=2200 ) p left 
 join syi_table_tbl s on s.name=p.typname::varchar where s.name is null and p.typname not like 'pga_%'
and p.typname not like '%_seq';


delete from syi_table_tbl where name like '%_seq';
alter table syi_table_tbl alter column  act set default 2;
update syi_table_tbl set act=0 where  act is null;
alter table syi_table_tbl add column tbl_owner varchar (30);
alter table syi_table_tbl add column id_task int;
alter table syi_table_tbl add column act int;

insert into syi_task_tbl (id,name) values (10,'Оборудование  Справочник');
insert into syi_task_tbl (id,name) values (11,'Оборудование  Спр.видов');
insert into syi_task_tbl (id,name) values (12,'Оборудование  Установленое');
insert into syi_task_tbl (id,name) values (13,'Оборудование  История');

insert into syi_task_tbl (id,name) values (50,'Расчет   Счета');
insert into syi_task_tbl (id,name) values (51,'Расчет   Расчет');
insert into syi_task_tbl (id,name) values (52,'Расчет   Платежи');
insert into syi_task_tbl (id,name) values (53,'Расчет   Сальдо');
insert into syi_task_tbl (id,name) values (54,'Расчет   Налоговые');
insert into syi_task_tbl (id,name) values (55,'Расчет   Показания');
insert into syi_task_tbl (id,name) values (56,'Расчет   Доп.расчет');
insert into syi_task_tbl (id,name) values (57,'Расчет   Погашения');
insert into syi_task_tbl (id,name) values (58,'Расчет   Пеня, Инфляция');
insert into syi_task_tbl (id,name) values (59,'Расчет   Справочн.дан');

insert into syi_task_tbl (id,name) values (90,'Справочник   Общие');
insert into syi_task_tbl (id,name) values (91,'Справочник   Адреса');
insert into syi_task_tbl (id,name) values (92,'Справочник   Документы');
insert into syi_task_tbl (id,name) values (94,'Справочник   Тарифы');
insert into syi_task_tbl (id,name) values (95,'Справочник   Клиент');

insert into syi_task_tbl (id,name) values (120,'Отчеты   Стандартные');
insert into syi_task_tbl (id,name) values (121,'Отчеты   Пофидерный');
insert into syi_task_tbl (id,name) values (122,'Отчеты   СЕБ');



insert into syi_task_tbl (id,name) values (150,'Системные   Таблицы и задания');
insert into syi_task_tbl (id,name) values (151,'Системные   Пользователи и пароли');
insert into syi_task_tbl (id,name) values (152,'Системные   Настройки и описания');



















--l add column act integer;