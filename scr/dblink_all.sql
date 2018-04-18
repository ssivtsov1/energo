
CREATE OR REPLACE FUNCTION check_blank_spr()
  RETURNS boolean AS
$BODY$
declare
 sys_base record; 
 kodres int;
 existt boolean;
 pr boolean;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
 res boolean;

begin

for sys_base in select * from sys_basa_tbl loop
SQL='insert into tmp_meter  (res  ,id  ,"type" ,  phase,  carry ,zones )  
       select *  from 
    dblink(''dbname= '||sys_base.alias_||''', '' select d.value_ident,m.id,m.type,m.phase,m.carry,m.zones 
           from eqi_meter_tbl m,syi_sysvars_tbl d where d.id=23  '' )  as d 
 (    res integer ,id integer ,type character varying (50),  phase integer,  carry integer, zones integer) ';
 --raise notice ' SQL = % ',SQL;
 Execute SQL;


SQL='insert into cable (res  ,id  ,  "type" ,  dpo ,  xo ,ro   ,s_nom )   
       select *  from 
    dblink(''dbname= '||sys_base.alias_||''', '' select  value_ident,e.id,
 "type" ,  e.dpo,e.xo,e.ro,e.s_nom from eqi_cable_tbl e,syi_sysvars_tbl d where d.id=23  '' )  as d 
 (     res integer ,id integer ,  "type" character varying (50),  dpo numeric,  xo numeric,ro numeric  ,s_nom numeric ) ';
 raise notice ' SQL = % ',SQL;
 Execute SQL;
end loop;


return true;
end $BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION check_blank_spr()
  OWNER TO postgres;
