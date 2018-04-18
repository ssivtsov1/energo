;
set client_encoding='win';
create table sys_user_client
(id_res int,
 kod_res int,
 id_user int,
 id_client int,
 code_client numeric(7),
primary key (id_res,kod_res,id_user,id_client)
);




insert into syi_user (id,id_parent,flag_type,name) values(199,100,0,'_Расчет дирекции');
select sys_fill_full_lvl();
select sys_upd_pwd(199,'199199','1');


insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,589,id from clm_client_tbl 
where code=589 and getsysvar('kod_res')=100;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,365,id from clm_client_tbl 
where code=365 and getsysvar('kod_res')=110;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,359,id from clm_client_tbl 
where code=359 and getsysvar('kod_res')=120;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,216,id from clm_client_tbl 
where code=216 and getsysvar('kod_res')=130;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,323,id from clm_client_tbl 
where code=323 and getsysvar('kod_res')=140;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,1041,id from clm_client_tbl 
where code=1041 and getsysvar('kod_res')=150;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,498,id from clm_client_tbl 
where code=498 and getsysvar('kod_res')=160;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,282,id from clm_client_tbl 
where code=282 and getsysvar('kod_res')=170;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,263,id from clm_client_tbl 
where code=263 and getsysvar('kod_res')=180;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,140,id from clm_client_tbl 
where code=140 and getsysvar('kod_res')=190;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,466,id from clm_client_tbl 
where code=466 and getsysvar('kod_res')=200;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,10045,id from clm_client_tbl 
where code=10045 and getsysvar('kod_res')=210;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,420,id from clm_client_tbl 
where code=420 and getsysvar('kod_res')=220;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,330,id from clm_client_tbl 
where code=330 and getsysvar('kod_res')=230;


insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,691,id from clm_client_tbl 
where code=691 and getsysvar('kod_res')=240;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,718,id from clm_client_tbl 
where code=718 and getsysvar('kod_res')=240;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,393,id from clm_client_tbl 
where code=393 and getsysvar('kod_res')=250;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,237,id from clm_client_tbl 
where code=237 and getsysvar('kod_res')=260;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,287,id from clm_client_tbl 
where code=287 and getsysvar('kod_res')=270;
-- Sribne
insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,145,id from clm_client_tbl 
where code=145 and getsysvar('kod_res')=280;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,54,id from clm_client_tbl 
where code=54 and getsysvar('kod_res')=290;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,425,id from clm_client_tbl 
where code=425 and getsysvar('kod_res')=300;


insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,2798,id from clm_client_tbl 
where code=2798 and getsysvar('kod_res')=310;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,6130,id from clm_client_tbl 
where code=6130 and getsysvar('kod_res')=320;

insert into sys_user_client  (id_res,kod_res,id_user,code_client,id_client) 
 select getsysvar('id_res'),getsysvar('kod_res'),199,8452,id from clm_client_tbl 
where code=8452 and getsysvar('kod_res')=330;

CREATE OR REPLACE FUNCTION fill_user_client()
  RETURNS bool AS
$BODY$
declare
 sys_base record; 
 kodres int;
idres int;
 existt boolean;
 pr boolean;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
 res boolean;
begin
for sys_base in select * from sys_basa_tbl loop
kodres=getsysvar('kod_res');
idres=getsysvar('id_res');
SQL='insert into sys_user_client  (id_res,kod_res,id_user,id_client,code_client )  
       select *  from 
    dblink(''dbname= '||sys_base.alias_||''', '' select '||idres||','||kodres||',199,null,null  '' )  as d 
 (    id_res integer,kod_res integer,id_user integer,id_client integer,code_client numeric) ';
 raise notice ' SQL = % ',SQL;
 Execute SQL;
end loop;
return true;
end $BODY$
  LANGUAGE 'plpgsql' VOLATILE;


