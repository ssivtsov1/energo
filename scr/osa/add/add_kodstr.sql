
update cla_param_tbl set kod=(select substr(a.kod ,1,2)::varchar(2) from cla_param_tbl a
 where a.id_parent=cla_param_tbl.id order by id limit 1) where cla_param_tbl.kod is null;

update cla_param_tbl set kod=(select substr(a.kod ,1,2)::varchar(2) from cla_param_tbl a
 where a.id_parent=cla_param_tbl.id limit 1) where cla_param_tbl.kod is null;

drop function add_kodstr(varchar,int);
drop function add_kodstr(varchar,int,varchar);
 /*--------------------------------------------------------------*/
create function add_kodstr(varchar,int,varchar) returns int as '
Declare 
groupd record;
len int;
key alias for $1;
napr alias for $2;
sym alias for $3;
begin
 for groupd in  select id,name from cla_param_tbl where key_name=key loop
    select into len max(length(kod)) from cla_param_tbl where id_group=groupd.id;
  raise notice ''%'',groupd.name;
  raise notice ''%'',len;
  if napr=1 then
   update  cla_param_tbl set kod=lpad(kod::text,len,sym::text) where id_group=groupd.id;
  else 
   update  cla_param_tbl set kod=rpad(kod::text,len,sym::text) where id_group=groupd.id;
  end if;
  end loop;
return 0;
 end;'
 Language 'plpgsql';

 select add_kodstr('~gr_ind',1,'0');
 select add_kodstr('~gr_kwed',0,'.');

--select id,kod,name,val from cla_param_tbl where id_group in (select id from cla_param_tbl where key_name like '~gr%') 
