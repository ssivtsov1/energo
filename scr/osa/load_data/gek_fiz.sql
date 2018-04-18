INSERT INTO eqi_device_kinds_tbl (id, name, id_table_ind, id_table, calc_lost, inst_station) VALUES (17, 'Внутридомовая схема', NULL, Null, 0, 1);
INSERT INTO eqi_device_kinds_prop_tbl (type_eqp, id_icon, form_name) VALUES (17, NULL, 'TfGekDet');

drop function load_demand_gek(); 
create or replace function load_demand_gek() 
returns boolean as
'
declare 
rec record;
i int;
t boolean; 
sq text;
begin 
i=1;
 for rec in select * from tmp_load where str_sql like ''insert into adi_build_tbl%'' loop
  sq=rec.str_sql;
  execute(sq);
  i=i+1;
  raise notice '' %  ,   % '',i,sq;
 end loop;
 return true;
end;
' language 'plpgsql';

--drop table adi_build_tbl;
create table adi_build_tbl (
              id numeric(15),
              name varchar(100),
              num_gek int,
              code_eqp int,
     primary key(id )
 );

select  distinct * into temp tmp_adi_build from adi_build_tbl;
delete from adi_build_tbl;
insert into adi_build_tbl select * from  tmp_adi_build;
delete from adi_build_tbl where  id in (select id from (select id,count(*) from adi_build_tbl group by id having count(*)>1) a );
delete from adi_build_tbl where id is null;
CREATE UNIQUE INDEX adi_build_ind1 ON adi_build_tbl (id);

select load_demand_all();


create table acd_build_demand_tbl 
          (id_build int,
           mmgg date,
           value numeric(10,4),
primary key (id_build,mmgg));

alter table clm_pclient_tbl add column set_power numeric (8,4);

-------------------------==========================-----------------

create or replace function build_ins_fun() returns int as'
declare 
  fl_ins int;
  buildr record;
  exist_eqp  record;
begin
------------------------------
select into fl_ins eqt_change_fun(2,null,null,null,null,0);

-- new  
delete from adi_build_tbl where id is null;
 for  buildr in select * from adi_build_tbl loop
-- raise notice ''%  %  %  '',buildr.id,buildr.name,buildr.num_gek;
 fl_ins=1;
if buildr.id>999999999 then
-- raise notice '' Large number GEK %  %  %  '',buildr.id,buildr.name,buildr.num_gek;
 continue;
end if;

  for exist_eqp in select id from eqm_equipment_tbl where id=buildr.id loop 
    fl_ins=0;
  end loop;
  -- raise notice ''fl_ins %  exist_eqp %  buildr.id %  '',fl_ins,exist_eqp,buildr.id;
  if fl_ins=1 then
  --   raise notice '' 22    %  %  %  '',buildr.id,buildr.name,buildr.num_gek;
    insert into eqm_equipment_tbl(id,type_eqp,name_eqp, num_eqp,
         id_addres,dt_install,dt_change,loss_power) 
       values (buildr.id,17,substr(buildr.name,1,50),buildr.num_gek,
       null,''2009-01-01'',null,0);
   else
     update eqm_equipment_tbl
     set name_eqp=substr(buildr.name,1,50),num_eqp=buildr.num_gek,
        dt_change=now()
	where id=buildr.id;
   end if;
 end loop;
 Return 1;
end; 
' LANGUAGE 'plpgsql';