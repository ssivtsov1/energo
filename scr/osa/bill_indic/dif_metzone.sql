create sequence eqd_difmetzone_seq  INCREMENT 1   MINVALUE 1  START 1 ;
create table eqd_difmetzone_tbl (
     id 		int DEFAULT nextval('eqd_difmetzone_seq'),
     code_eqp           int,
     kind_energy	int,
     zone_p             int,
     zone               int,
     percent            numeric (8,3),
     dt_b               date,
     dt_e               date,
     dt                 date default fun_mmgg(),
    primary key(id)
);
alter table eqd_difmetzone_tbl add column zone_p int;

create table eqd_difmetzone_h (
     id 		int,
     code_eqp           int,
     kind_energy	int,
     zone_p             int,
     zone               int,
     percent            numeric (8,3),
     dt_b               date,
     dt_e               date,
     dt                 date default fun_mmgg(),
    primary key(id)
);

alter table eqd_difmetzone_h drop constraint eqd_difmetzone_h_pkey;
alter table eqd_difmetzone_h alter column dt_b set not null ;
alter table eqd_difmetzone_h add primary key(id,dt_b);

create sequence acd_inddifzone_seq  INCREMENT 1   MINVALUE 1  START 1 ;
create table acd_inddifzone_tbl (
     id_doc             int,
     id_meter           int,
     kind_energy	int,
     zone               int,
     zone_p             int,
     percent            numeric (8,3),
     dt_b               date,
     dt_e               date,
     dt                 date default now(),
     mmgg               date default fun_mmgg(),
    primary key(id_doc,id_meter,kind_energy,zone_p)
);

--alter table acd_inddifzone_tbl ;
drop constraint acd_inddifzone_tbl_pkey on table acd_inddifzone_tbl instead;
create unique index  acd_inddifzone_tbl_pkey on acd_inddifzone_tbl (id_doc,id_meter,kind_energy,zone_p);

alter table acd_inddifzone_tbl add column zone_p int;
alter table acd_inddifzone_tbl add column mmgg date;
alter table acd_inddifzone_tbl alter column mmgg set default fun_mmgg();

create table acd_difmetzone_tbl (
     id_doc             int,
     dt                 date,
     kind_energy        int,
     id_point_p   	int,
     zone_p   	        int, 
     id_point           int,
     zone               int,
     dt_b               date,
     dt_e               date,
     percent            numeric(10,5),
     demand_p           int,
     demand_calc        int,
     fact_demand_p      int,
     primary key(id_doc,id_point_p,zone_p,id_point,zone,kind_energy,dt_b,dt_e)
);



drop function  add_inddifzone(int,date,date);

create or replace function add_inddifzone(int,date) returns int as'
declare headdoc alias for $1;
        dte alias for $2;
        indic record;
        dtb date;
begin
select into dtb max(dt_e) from acd_inddifzone_tbl where dt_e<dte;
if not found  then
  dtb=dte-interval ''1 month'';
end if;
if dtb is null then
  dtb=dte-interval ''1 month'';
end if;

raise  notice ''dte - %  dtb-%'',dte,dtb;
insert into acd_inddifzone_tbl 
                   (id_doc,id_meter,kind_energy,zone_p,zone,percent,dt_b,dt_e,mmgg) 
       select distinct headdoc as hdoc,i.code_eqp,i.kind_energy,
       i.zone_p,i.zone,i.percent,
        dtb as dt_b,dte as dt_e,i.mmgg
--         into temp tt
     from (select ii.id_doc,ii.mmgg,dd.code_eqp,dd.kind_energy,dd.zone_p,
            dd.zone,dd.percent from 
                (select d1.* from eqd_difmetzone_h d1,acd_indication_tbl i1
                  where d1.code_eqp=i1.id_meter and i1.id_doc=headdoc 
                   and (dte between d1.dt_b and coalesce(d1.dt_e,dte))   
                ) dd 
                left join 
               (select * from acd_inddifzone_tbl where id_doc=headdoc) ii 
              on ( ii.id_meter=dd.code_eqp and 
                   ii.kind_energy=dd.kind_energy   and
                   ii.zone_p=dd.zone_p and
                   ii.zone=dd.zone
               )  where ii.id_doc is null ) as i;

update acd_inddifzone_tbl   set dt_e=dte  where id_doc=headdoc;  
/*update acd_inddifzone_tbl   set dt_b=i.dte  from 
 ( select * from acd_indication_tbl where  ) i
where id_doc=headdoc;  
  */
return 1;
end;
' language 'plpgsql';
