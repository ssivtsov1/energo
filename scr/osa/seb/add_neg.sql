alter table seb_plan add column id int;
create sequence seb_plan_seq;
alter table seb_plan alter column id set default  nextval('seb_plan_seq');
update seb_plan set id=nextval('seb_plan_seq') where id is null;
