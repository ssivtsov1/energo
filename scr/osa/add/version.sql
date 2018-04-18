insert into syi_sysvars_tbl (id,ident,type_ident,value_ident) 
values (110,'vers_scr','varchar(20)',null);

insert into syi_sysvars_tbl (id,ident,type_ident,value_ident) 
values (111,'vers_prg','varchar(20)',null);

insert into syi_sysvars_tbl (id,ident,type_ident,value_ident) 
values (112,'dt_create_vers','varchar(20)',null);
insert into syi_sysvars_tbl (id,ident,type_ident,value_ident) 
values (113,'dt_set_vers','varchar(20)',null);

create sequence syi_version_seq increment 1; 
CREATE TABLE syi_version 
( id     int default nextval('syi_version_seq'),
  vers_scr int,
  vers_prg int,
  dt_creat date,
  dt_set   timestamp
);

create or replace function set_version(int,int,date) Returns boolean As'
declare
vers_s alias for $1; 
vers_p alias for $2; 
cr_date alias for $3; 
begin
insert into syi_version (vers_scr,vers_prg,dt_creat,dt_set)
 values (vers_s,vers_p,cr_date, now());

update syi_sysvars_tbl set value_ident=vers_s where ident=''vers_scr'';
update syi_sysvars_tbl set value_ident=vers_p where ident=''vers_prg'';
update syi_sysvars_tbl set value_ident=cr_date where ident=''dt_create_vers'';
update syi_sysvars_tbl set value_ident= now() where ident=''dt_set_vers'';

return true;
end;
' language 'plpgsql';
