insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values (35,'pg_version', 'varchar', '9.4');

CREATE OR REPLACE FUNCTION sys_check_pwd(integer, character varying)
  RETURNS boolean AS
$BODY$
declare
usr_id alias for $1; 
usr_pwd alias for $2;
rec record; 
ret boolean;
v int;
begin
 ret=false;

 if position('8.2' in version()) >0 then

  raise notice 'current 8.2';
  select into v id from syi_sysvars_tbl where ident = 'pg_version' and value_ident = '8.2';

  if not found then
    raise notice 'source 8.2';
    return true;
  end if; 

  for rec in select * from syi_user   where id=usr_id 
              and   (pwd_code=hashname(usr_pwd::name) or pwd_code is null )  
  loop
    raise notice '8.2 ok';
    ret = true;
  end loop;

 else  

  raise notice 'current 9.4';
   for rec in select * from syi_user   where id=usr_id 
              and   (  pwd_code=   ('x'||substr(md5(usr_pwd),1,8))::bit(32)::int   or pwd_code is null )  
   loop
    raise notice '9.4 ok';
    ret = true;
   end loop;
 end if; 

 return ret;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

