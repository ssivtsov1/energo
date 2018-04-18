
create sequence syi_user_seq increment 1; 

CREATE TABLE syi_user 
( id     int default nextval('syi_user_seq'),
  id_parent int,
  flag_type int,
  name varchar (30),
  id_person int,
  pwd_code  int default hashname('1'),
  login_name varchar(10) default 'local',
primary key (id)
);

select altr_colmn('syi_user','pwd_code','int');
select altr_colmn('syi_enviroment','name',' varchar(100)');
drop trigger syi_usr_upd on  syi_user;
drop trigger syi_usr_ins on  syi_user;
drop function user_upd_fun();

create  function user_upd_fun() returns opaque as '
declare
rec record;
res record;
sql text;
begin
if new.login_name=''local'' or new.login_name is null  then 
 return new;
end if;
--new.pwd_code=hashname(new.pwd_code); 
for rec in select * from syi_user where login_name=new.login_name  
       and id<>new.id
   loop
 raise exception ''Пользователь %  уже зарегистрирован в системе'',new.login_name;
--    raise exception ''Double login name'';

   -- return old;

end loop;

select  into res * from pg_shadow where usename=lower(new.login_name)::name;  
if  found then
 if new.pwd_code is not null then 
  sql=''alter user ''||new.login_name||'' password ''||    quote_literal(new.pwd_code)||'' createdb createuser'';
 end if;
 execute sql;  

else 
 if new.pwd_code is not null then 
  sql=''create user ''||new.login_name||'' password ''||   quote_literal(new.pwd_code)||'' createdb createuser'';
 else
  sql=''create user ''||new.login_name||'' createdb createuser'';
end if;
execute sql; 

end if;
return new;
end
'language 'plpgsql';

create trigger syi_usr_upd  
        before update on syi_user
         for each row execute procedure user_upd_fun();

create trigger syi_usr_ins  
        before insert on syi_user
         for each row execute procedure user_upd_fun();

drop trigger syi_usr_del on syi_user;
drop function user_del_fun();


create or replace function user_del_fun() returns opaque as '
declare
rec record;
sql text;
begin

if old.login_name=''local'' or old.login_name is null  then 
 return old;
end if;
 
select into rec * from pg_shadow where usename=old.login_name::name;
if  found then
 sql=''drop user ''||old.login_name::name;
 execute sql; 
end if;
return old;
end
'language 'plpgsql';

create trigger syi_usr_del  
        before delete on syi_user
         for each row execute procedure user_del_fun();


insert into syi_sysvars_tbl (id,ident,value_ident) values (200,'last_user',10); 

--delete from syi_user where id=101; 
-- insert into syi_user (id,id_parent,flag_type,name,login_name) values(0,null,0,'Energo','osa');
insert into syi_user (id,id_parent,flag_type,name) values(0,null,0,'Energo');
insert into syi_user (id,id_parent,flag_type,name) values(1,null,1,'Администраторы');
insert into syi_user (id,id_parent,flag_type,name) values(10,1,0,'Администратор');
insert into syi_user (id,id_parent,flag_type,name) values(100,null,1,'Дирекция');
insert into syi_user (id,id_parent,flag_type,name) values(101,100,0,'Представитель дирекции');
insert into syi_user (id,id_parent,flag_type,name) values(200,null,1,'Сбытовой персонал');
insert into syi_user (id,id_parent,flag_type,name) values(300,null,1,'Бухгалтерия');
insert into syi_user (id,id_parent,flag_type,name) values(400,null,1,'Инженерно-технический персонал');
insert into syi_user (id,id_parent,flag_type,name) values(500,null,1,'Нормативно справочная группа');
insert into syi_user (id,id_parent,flag_type,name) values(900,null,1,'Дополнительно');



CREATE TABLE syi_user_lvl
( id_usr     int,
  id_env     int,
  lvl        int,
primary key (id_usr,id_env)
);

insert into syi_user_lvl (id_usr,id_env,lvl) values (0,1,3);
insert into syi_user_lvl (id_usr,id_env,lvl) values (1,1,3);
insert into syi_user_lvl (id_usr,id_env,lvl) values (10,1,3);

create sequence syi_enviroment_seq increment 1;
CREATE TABLE syi_enviroment
( id     int default nextval('syi_enviroment_seq'),
  name     varchar(30),
  type_env  int,
primary key (id)
);

alter table  syi_enviroment add column type_env int;
alter table  syi_enviroment add column default_rule int;
alter table  syi_enviroment alter column default_rule set default -1;
update  syi_enviroment set default_rule= -1 where default_rule is null;
alter table  syi_enviroment alter column type_env set default 0;
update syi_enviroment set type_env=0 where type_env is null;
insert into syi_enviroment (id,name) values (0,'Окна программы');
insert into syi_enviroment (id,name) values (1,'Пользователи и пароли');



insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values (35,'pg_version', 'varchar', '9.4');

CREATE TABLE sys_pw89
(
  id_usr integer,
  alias_ character varying(50) ,
PRIMARY KEY (id_usr)
);


CREATE OR REPLACE FUNCTION sys_pw89(integer, character varying)
  RETURNS boolean AS
$BODY$
declare
usr_id alias for $1; 
usr_pwd alias for $2;
rec record; 
begin
  select into rec * from sys_pw89   where id_usr=usr_id;
  if not found then
      insert into sys_pw89 (  id_usr ,  alias_) values (usr_id,usr_pwd);
  else
      update sys_pw89 set  alias_=usr_pwd where id_usr=usr_id;
  end if; 
 return true;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;

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
         perform sys_pw89(usr_id ,usr_pwd);
    return true;
  end if; 

  for rec in select * from syi_user   where id=usr_id 
              and   (pwd_code=hashname(usr_pwd::name) or pwd_code is null )  
  loop
    raise notice '8.2 ok';
    ret = true;
  end loop;
  if ret =true then
    perform sys_pw89(usr_id ,usr_pwd);
  end if;

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



CREATE OR REPLACE FUNCTION sys_upd_pwd(integer, character varying, character varying)
  RETURNS boolean AS
$BODY$
declare
usr_id alias for $1; 
usr_pwd alias for $2;
old_pwd alias for $3; 
rec record; 
ret boolean;
 hpwde int;
hpwda int;
begin
ret=false;
select into hpwda pwd_code from syi_user where id=0;
select into hpwde pwd_code from syi_user where id=10;

 if position('8.2' in version()) >0 then

  for rec in select * from syi_user  
  where id=usr_id and (pwd_code=hashname(old_pwd::name) 
                       or pwd_code is null 
                       or  hashname(old_pwd::name)=hpwde 
                       or hashname(old_pwd::name)=hpwda
  )  loop
     ret = true;
    update syi_user set pwd_code=hashname(usr_pwd::name) where id=usr_id;
   end loop;
   
 else 

   for rec in select * from syi_user  where id=usr_id 
     -- and (pwd_code=hashname(old_pwd::name) 
     --                    or pwd_code is null 
     --                    or  hashname(old_pwd::name)=hpwde 
     --                    or hashname(old_pwd::name)=hpwda) 
   loop
    ret = true;
    update syi_user set pwd_code= ('x'||substr(md5(usr_pwd),1,8))::bit(32)::int  where id=usr_id;
   end loop;
 end if;  
return ret;
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;


create or replace function sys_check_lvl(int,int ) Returns int As'
declare
usr_id alias for $1; 
env_id alias for $2;
rec record; 
ret int;

begin
ret=-1;

for rec in select * from syi_user_lvl 
  where id_usr=(select id_parent from syi_user where id=usr_id) 
     and id_env=env_id  loop
  ret = rec.lvl;
end loop;

for rec in select * from syi_user_lvl 
  where id_usr=usr_id and id_env=env_id  loop
  ret = rec.lvl;
end loop;
 if ret=-1 then
  ret=3;
 end if;
return ret;
end;
' language 'plpgsql';


create or replace function sys_check_lvl(varchar ) Returns int As'
declare
env_name alias for $1;
rusr_id record;
usr_id integer;
env_id int;
usr_ch varchar;
rec record; 
env int;
ret int;
begin

env_id=-1;
select into env id from  syi_enviroment where name=env_name;
if not found then 
 select into ret max(id)+1 from syi_enviroment;
 ret=setval(''syi_enviroment_seq'',ret);
insert into syi_enviroment (name) values (env_name);
end if; 
ret=-1;
for rusr_id in select *  from syi_sysvars_tmp where ident=''last_user'' loop
--if rtrim(ltrim(usr_ch))<>'''' the
usr_id=rusr_id.value_ident;
raise notice ''usr_id --- %'',usr_id;
  for rec in select * from syi_enviroment where name=env_name  loop 
  env_id=rec.id;
raise notice ''env'';
    for rec in select * from syi_user_lvl 
       where id_usr=(select id_parent from syi_user where id=usr_id) 
          and id_env=env_id  loop
raise notice ''lev_gr'';
       ret = rec.lvl;
raise notice ''usr_id --- %'',ret;
    end loop;

   for rec in select * from syi_user_lvl  --  and lvl>=0 otcekaem umolcania
     where id_usr=usr_id and id_env=env_id and lvl>=0 loop
raise notice ''lev_usr'';
     ret = rec.lvl;
raise notice ''usr_id --- %'',ret;
   end loop;
  end loop;
--end if;
end loop;

 if ret=-1 then  -- otherwise give all full access
  ret=3;
 end if;
raise notice ''usr_id 1111--- %'',ret;
return ret;
end;
' language 'plpgsql';

create or replace function sys_check_lvl_strong(varchar ) Returns int As'
declare
env_name alias for $1;
rusr_id record;
usr_id integer;
env_id int;
usr_ch varchar;
rec record; 
env int;
ret int;
begin

env_id=-1;
select into env id from  syi_enviroment where name=env_name;
if not found then 
 select into ret max(id)+1 from syi_enviroment;
 ret=setval(''syi_enviroment_seq'',ret);
insert into syi_enviroment (name) values (env_name);
end if; 
ret=-1;
for rusr_id in select *  from syi_sysvars_tmp where ident=''last_user'' loop
--if rtrim(ltrim(usr_ch))<>'''' the
usr_id=rusr_id.value_ident;
raise notice ''usr_id --- %'',usr_id;
  for rec in select * from syi_enviroment where name=env_name  loop 
  env_id=rec.id;
raise notice ''env'';
    for rec in select * from syi_user_lvl 
       where id_usr=(select id_parent from syi_user where id=usr_id) 
          and id_env=env_id  loop
raise notice ''lev_gr'';
       ret = rec.lvl;
raise notice ''usr_id --- %'',ret;
    end loop;

   for rec in select * from syi_user_lvl   --lvl>=0 otcekaem umolcania
     where id_usr=usr_id and id_env=env_id and lvl>=0  loop   --lvl>=0 otcekaem umolcania
raise notice ''lev_usr'';
     ret = rec.lvl;
raise notice ''usr_id --- %'',ret;
   end loop;
  end loop;
--end if;
end loop;
if ret<0  then 
ret=0;
end if;

return ret;
end;
' language 'plpgsql';

create or replace function sys_check_lvl_read(varchar ) Returns int As'
declare
env_name alias for $1;
rusr_id record;
usr_id integer;
env_id int;
usr_ch varchar;
rec record; 
env int;
ret int;
begin

env_id=1;
select into env id from  syi_enviroment where name=env_name;
if not found then 
 select into ret max(id)+1 from syi_enviroment;
 ret=setval(''syi_enviroment_seq'',ret);
insert into syi_enviroment (name) values (env_name);
end if; 
ret=-1;
for rusr_id in select *  from syi_sysvars_tmp where ident=''last_user'' loop
--if rtrim(ltrim(usr_ch))<>'''' the
usr_id=rusr_id.value_ident;
raise notice ''usr_id --- %'',usr_id;
  for rec in select * from syi_enviroment where name=env_name  loop 
  env_id=rec.id;
    for rec in select * from syi_user_lvl 
       where id_usr=(select id_parent from syi_user where id=usr_id) 
          and id_env=env_id  loop
       ret = rec.lvl;
    end loop;

   for rec in select * from syi_user_lvl  --lvl>=0 otcekaem umolcania
     where id_usr=usr_id and id_env=env_id and lvl>=0  loop
     ret = rec.lvl;
   end loop;
  end loop;
--end if;
end loop;
if ret<0  then 
ret=1;
end if;

return ret;
end;
' language 'plpgsql';


create or replace function sys_fill_full_lvl(  ) Returns int As'
declare
rec record;
ret int;
begin

for rec in select * from syi_user loop
raise notice ''  %'',rec.id;
ret=sys_fill_lvl(rec.id);
end loop;

       
return 1;
end;
' language 'plpgsql';

create or replace function sys_fill_adm_lvl(  ) Returns int As'
declare
rec record;
ret int;
begin
update  syi_user_lvl set lvl=3 where id_usr in (0,1,10);
       
return 1;
end;
' language 'plpgsql';



create or replace function sys_fill_lvl( int ) Returns int As'
declare
pid_usr alias for $1;

begin

insert into syi_user_lvl (id_usr,id_env,lvl )
     select distinct pid_usr,id,default_rule 
     from 
       (select distinct e.*
             from syi_enviroment as e 
               left join  syi_user_lvl l 
            on (e.id=l.id_env and l.id_usr=pid_usr
             )
            where l.id_usr is null
       ) as bb ;
       
return 0;
end;
' language 'plpgsql';


;

create or replace function sys_fill_lvl_group( int ) Returns int As'
declare
pid_usr alias for $1;

begin

update syi_user_lvl set lvl=g.lvl from syi_user_lvl g,syi_user u 
where syi_user_lvl.id_usr=pid_usr and u.id=syi_user_lvl.id_usr and  g.id_env=syi_user_lvl.id_env and g.id_usr=u.id_parent;
     
return 0;
end;
' language 'plpgsql';



delete from syi_user where name is null;
select sys_upd_pwd(0,'bugs','1');
select sys_fill_full_lvl();

select sys_upd_pwd(10,'01012004','1');
select sys_upd_pwd(101,'100100','1');



select * from syi_user s 
 left join syi_user  r   on s.id_parent=r.id where r.id is null and s.id_parent is not null;

update syi_user  set id_parent=sd.id from 
(select s.* from syi_user s
 left join syi_user  r   on s.id_parent=r.id where r.id is null and s.id_parent is not null) s,
(select id from syi_user where flag_type=1 order by id desc limit 1) sd
where s.id=syi_user.id and s.pwd_code is not null;

update syi_user  set flag_type=-100 from 
(select s.* from syi_user s
 left join syi_user  r   on s.id_parent=r.id where r.id is null and s.id_parent is not null) s
where s.id=syi_user.id and s.pwd_code is null;

delete from syi_user where flag_type=-100;


 alter table syi_user add CONSTRAINT syi_user_par FOREIGN KEY (id_parent)
      REFERENCES syi_user (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;