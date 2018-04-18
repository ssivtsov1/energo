
--drop table  table_del;
CREATE TABLE table_del (
    name varchar(80),
    own name,
    trig boolean,
    fdel integer,
    ftype integer default 1,
 primary key (name)
);

insert into table_del (name) 
select  typname from (select * from pg_type where typnamespace=2200 ) p left 
 join table_del s on s.name=p.typname::varchar where s.name is null and p.typname not like 'pga_%'
and p.typname not like '%_seq';

delete from table_del where name like '%_seq';

drop function droptable(varchar,int);
CREATE FUNCTION droptable(varchar,int) RETURNS BOOLEAN AS '
DECLARE
    TableName ALIAS FOR $1;
    casc  ALIAS FOR $2;
    T varchar;
BEGIN
    IF table_exists(TableName) THEN
        T:=lower(TableName);
        EXECUTE ''DROP TABLE ''
	       || quote_ident(T)|| '' Cascade'';
	RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
' LANGUAGE 'plpgsql' WITH (isstrict);    

create or replace function del_table(varchar) returns boolean as 
'
declare 
SSql text;
DSql text;
pr int;
tabl alias for $1;
cou record;
begin
pr=0;
 IF table_exists(tabl) THEN
SSql=''select  count(*) as count1  from ''::varchar||tabl;
for cou in Execute SSql loop
if cou.count1=0 then 
   pr=1;
end if;
end loop;
if pr=1 then

  DSql=''select droptable (''::varchar|| quote_literal(tabl) || '')''::varchar;
  raise notice ''%'',DSql;
  Execute DSql;
  return true;
end if;
end if;
return false;
end;
' language 'plpgsql';

create or replace function t_del() returns boolean as
'
declare pr boolean;
rec record;
begin

insert into table_del (name) 
select  typname from (select * from pg_type where typnamespace=2200 ) p left 
 join table_del s on s.name=p.typname::varchar where s.name is null and p.typname not like ''pga_%''
and p.typname not like ''%_seq'';

insert into syi_table_tbl (name) 
select  typname from (select * from pg_type where typnamespace=2200 ) p left 
 join syi_table_tbl s on s.name=p.typname::varchar where s.name is null and p.typname not like ''pga_%''
and p.typname not like ''%_seq'';


update table_del set fdel=1  from 
  (select t.* from table_del t  left join
   (select name from syi_table_tbl where (act is null 
    or ( act<>1 ))) s on s.name=t.name where s.name is null  
  ) as t where table_del.name=t.name;
--delete from syi_field_tbl where id_table in  (select  id from syi_table_tbl where act=1);
--delete from syi_table_tbl where act=1;
for rec in select distinct * from table_del where fdel=1 and ftype=1  order by name 
 loop
raise notice ''%'',rec.name;
pr=droptable(rec.name,1);
--pr=del_table(rec.name);
end loop; 
return true;
end;
' language  'plpgsql';

select t_del();
