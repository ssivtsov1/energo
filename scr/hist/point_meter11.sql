alter table eqm_point_tbl add column reserv     int;
alter table eqm_point_h add column  reserv     int;

alter table eqm_point_tbl alter  column reserv   set default 0;
alter table eqm_point_h alter column  reserv     set default 0;




UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_point_tbl';


update eqm_point_tbl set reserv=0 where reserv is null;
update eqm_point_h set reserv=0 where reserv is null;

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_point_tbl';
