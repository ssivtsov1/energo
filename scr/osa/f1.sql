CREATE FUNCTION plpgsql_call_handler () RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


--
-- TOC entry 740 (OID 1103772)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: public; Owner: 
--

CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler;



 CREATE OR REPLACE FUNCTION syi_resid_fun()                                                   
  RETURNS int                                                                                     
  AS                                                                                              
  '
  declare
  id_res int;
  begin
   select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
   RETURN id_res;
  end;'                                                                                           
  LANGUAGE 'plpgsql';


drop function droptable(varchar);
CREATE FUNCTION droptable(varchar) RETURNS BOOLEAN AS '
DECLARE
    TableName ALIAS FOR $1;
    T varchar;
BEGIN
    IF table_exists(TableName) THEN
        T:=lower(TableName);
        EXECUTE ''DROP TABLE ''
	       || quote_ident(T);
	RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
' LANGUAGE 'plpgsql' WITH (isstrict);    


create or replace function GetSysVar(varchar) returns int as '
Declare 
  iden ALIAS for $1;
  recsys record;
  res int;
  istab boolean;
 Begin
istab=isTableTemp(''syi_sysvars_tmp'');
 if istab=''false'' or istab is null then
    --raise notice '' tbl'' ;
    select into  recsys ident,type_ident,value_ident from syi_sysvars_tbl where ident=iden;
 else
   -- raise notice '' tmp'' ;
    select into  recsys ident,type_ident,value_ident from syi_sysvars_tmp where ident=iden;
 end if;  
  if found then 
    if recsys.type_ident=''varchar''   then
         res=to_number(recsys.value_ident ,''999999999999'');
	-- raise notice ''ch''; 
     end if;   
 --raise notice ''eee1'';
     
     if recsys.type_ident=lower(''int'')  then
         res=recsys.value_ident;
     -- raise notice ''int'';
     end if;   

     if recsys.type_ident=''numeric''  then
         res=int4(recsys.value_ident);
	--  raise notice ''int4'';
     end if;   
   else
    res=0;  
   end if;
  -- raise notice ''eee2 %'',res ; 
   
 return res;  
 End;
' 
LANGUAGE 'plpgsql' WITH (isstrict);    

drop function GetSysVarN(varchar);

CREATE OR REPLACE FUNCTION getsysvarn(character varying)
  RETURNS numeric AS
$BODY$
Declare 
  iden ALIAS for $1;
  recsys record;
  res numeric;
  istab boolean;

 Begin
 istab=isTableTemp('syi_sysvars_tmp');
 if istab='false' or istab is null then
    --raise notice ' tbl' ;
    select into  recsys ident,type_ident,value_ident from syi_sysvars_tbl where ident=iden;
 else
    -- raise notice ' tmp' ;
    select into  recsys ident,type_ident,value_ident from syi_sysvars_tmp where ident=iden;
 end if;  

   if found then 
     if recsys.type_ident='varchar' or recsys.type_ident='char'  then
         res=to_number(recsys.value_ident ,'9999999999.99');
     end if;   
     if recsys.type_ident='int'  then
         res=recsys.value_ident;
     end if;   
     if recsys.type_ident='numeric'  then
         res=recsys.value_ident;
     end if;   
   else
    res=0;  
   end if;
 return res;  
 End;
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION getsysvarn(character varying)

create or replace function GetSysVarC(varchar) returns varchar as '
Declare 
  iden ALIAS for $1;
  recsys record;
  res varchar;
  istab boolean;
 Begin
istab=isTableTemp(''syi_sysvars_tmp'');
 if istab=''false'' or istab is null then
    raise notice '' tbl'' ;
    select into  recsys ident,type_ident,value_ident from syi_sysvars_tbl where ident=iden;
 else
     raise notice '' tmp'' ;
    select into  recsys ident,type_ident,value_ident from syi_sysvars_tmp where ident=iden;
 end if;  
  if found then 
    if recsys.type_ident=''varchar'' or recsys.type_ident=''timestamp''   then
         res=recsys.value_ident;
	 raise notice ''ch''; 
     end if;   
  if recsys.type_ident=lower(''int'')  then
         res=recsys.value_ident;
      raise notice ''int'';
  end if;   

  if recsys.type_ident=''numeric''  then
         res=int4(recsys.value_ident);
    raise notice ''int4'';
   end if;   
  if recsys.type_ident=''date''  then
         res=recsys.value_ident;
    raise notice ''date'';
   end if;   

   else
    res='' '';  
   end if;
  -- raise notice ''eee2 %'',res ; 
   
 return res;  
 End;
' 
LANGUAGE 'plpgsql' WITH (isstrict);    

CREATE OR REPLACE FUNCTION isTableTemp(text) RETURNS boolean STABLE RETURNS NULL ON NULL INPUT  AS '
DECLARE r record; strSQL text; BEGIN
strSQL:=''SELECT pg_namespace.nspname AS ret FROM pg_class INNER JOIN pg_namespace ON pg_class.relnamespace=pg_namespace.oid WHERE pg_table_is_visible(pg_class.oid) AND pg_class.relname=''||quote_literal($1)||'';'';
FOR r IN EXECUTE strSQL LOOP  RETURN (r.ret LIKE ''pg_temp%''); END LOOP;
RETURN Null; END; ' LANGUAGE 'plpgsql';


--drop function fun_mmgg();
create or replace function fun_mmgg() returns date as'
Declare
mmggs varchar(10);
mmggd date;
istab boolean;
begin
istab=isTableTemp(''syi_sysvars_tmp'');
if istab=''false'' or istab is null then
-- raise notice '' tbl'' ;
 select into mmggs value_ident from syi_sysvars_tbl where ident=''mmgg'';
 else
-- raise notice '' tmp'' ;
 select into mmggs value_ident from syi_sysvars_tmp where ident=''mmgg'';
 
end if;
-- raise notice '' %'',mmggs ;
mmggd=date(to_date(mmggs,''dd.mm.yyyy''));

Return date(mmggd);

end;
' Language 'plpgsql';

create or replace function fun_mmgg(int) returns date as'
Declare
par alias for $1;
mmggs varchar(10);
mmggd date;
istab boolean;
begin

istab=isTableTemp(''syi_sysvars_tmp'');
if istab=''false'' or istab is null or par is not null then
--raise notice '' tbl2'' ;
 select into mmggs value_ident from syi_sysvars_tbl where ident=''mmgg'';
 else
-- raise notice '' tmp2'' ;
 select into mmggs value_ident from syi_sysvars_tmp where ident=''mmgg'';
end if;
raise notice '' %'',mmggs ;
mmggd=date(to_date(mmggs,''dd.mm.yyyy''));

Return date(mmggd);

end;
' Language 'plpgsql';


create or replace function fun_tax(varchar,date) returns numeric as'
Declare
par alias for $1;
--bdat alias for $2;
edat alias for $2;
e_d date;
ret numeric;
begin
if edat is null then
 e_d=fun_mmgg();
else
 e_d=edat;
end if;
select into ret value::numeric from cmd_tax_tbl as a,
  cmi_tax_tbl as b where a.id_tax=b.id 
  and b.ident=par and a.date_inst=(select max(date_inst) from cmd_tax_tbl 
   where cmd_tax_tbl.date_inst<=e_d and cmd_tax_tbl.id_tax=b.id);

Return ret;

end;
' Language 'plpgsql';

CREATE or replace FUNCTION syi_region_fun () RETURNS integer
    AS '
  declare
  id_res int;
  begin
   select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_region'';
   RETURN id_res;
  end;'
    LANGUAGE plpgsql;



CREATE or replace FUNCTION acm_nexttaxnum () RETURNS integer
    AS '
  declare 
     vreg_num     varchar;
     vnum_end     varchar;

  begin

--    select into vnum_end value_ident from syi_sysvars_tbl 
--    where ident=''tax_num_ending'';

    select into vreg_num value_ident from syi_sysvars_tbl 
    where ident=''last_tax_num'';

    update syi_sysvars_tbl set value_ident=Text(to_number(vreg_num::text,''0000000000'')+1) where ident=''last_tax_num'';

    return to_number(vreg_num::text,''0000000000''); --||coalesce(vnum_end,'''');

  end;
'
    LANGUAGE plpgsql;

alter table acm_bill_tbl alter column mmgg_bill drop default;
alter table acm_pay_tbl alter column mmgg_hpay drop default;
alter table acm_headpay_tbl alter column mmgg_hpay drop default;

alter table acm_pay_tbl alter column mmgg_hpay set default fun_mmgg();
alter table acm_headpay_tbl alter column mmgg_hpay set default fun_mmgg();

drop function fulling_month ();
drop function fulling_month (varchar);

CREATE  FUNCTION fulling_month () RETURNS date
    AS '
  declare 
  begin
      return new.mmgg;
  end;
'
    LANGUAGE plpgsql;

/*
create or replace function del_NoTrigger(text,text) returns boolean as 
'declare 
 tabl alias for $1;
 sql alias for $2;
 c_trg int;
begin
 select into c_trg reltriggers from pg_class where relname::text=tabl::text;
 if not  found then
  Execute sql;
 else 
  update pg_class set reltriggers=0  where relname::text=tabl::text;
  Execute (sql);
  update pg_class set reltriggers=c_trg  where cast(relname as text)=tabl::text;

 end if;
return true;
end;' language 'plpgsql';
*/


CREATE OR REPLACE FUNCTION del_notrigger(text, text)
  RETURNS boolean AS
$BODY$
declare 
 tabl alias for $1;
 sql alias for $2;
 c_trg int;
begin

 if position('8.2' in version()) >0 then

  select into c_trg reltriggers from pg_class where relname::text=tabl::text;
  if not  found then
   Execute sql;
  else 
   update pg_class set reltriggers=0  where relname::text=tabl::text;
   Execute (sql);
   update pg_class set reltriggers=c_trg  where cast(relname as text)=tabl::text;

  end if;
 else

  SET session_replication_role = replica;
  Execute sql;
  SET session_replication_role = DEFAULT;

 end if;


return true;
end;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


drop function bom(date);
drop function eom(date);

 
create function bom(date) Returns date As'
declare
dt alias for $1; 
ndt date;
begin
ndt=date_trunc(''month'',dt);
return ndt;
end;
' language 'plpgsql';

create or replace function eom(date) Returns date As'
declare
dt alias for $1; 
nmon date;
ndt date;
begin
ndt=date_trunc(''month'',dt+interval ''1 month'')-interval ''1 day '';
return ndt;
end;
' language 'plpgsql';

/*
create sequence 'sys_basa_seq' increment 1;
create table sys_basa_tbl (
     id                 int default nextval('sys_basa_seq'),
     name               varchar(100),
     alias_             varchar (50),
     host_              varchar(12),
     program            varchar(15),
     dt_restore         date,
    primary key(alias_,host_)
);

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (10,'Бахмач (10.71.1.10)','en_bah','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (20,'Бобровица (10.71.1.10)','en_bobr','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (30,'Борзна (10.71.1.10)','en_brz','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (40,'Варва (10.71.1.10)','en_var','10.71.1.10','Energo');


insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (50,'Городня (10.71.1.10)','en_gor','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (60,'Ичня (10.71.1.10)','en_ichn','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (70,'Короп (10.71.1.10)','en_krp','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (80,'Корюковка (10.71.1.10)','en_krk','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (90,'Козелец (10.71.1.10)','en_koz','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (100,'Куликовка (10.71.1.10)','en_kul','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (110,'Мена (10.71.1.10)','en_mena','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (120,'Нежин (10.71.1.10)','en_neg','10.71.1.10','Energo');


insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (130,'Носовка (10.71.1.10)','en_nos','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (140,'Н.Северский (10.71.1.10)','en_ns','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (150,'Прилуки (10.71.1.10)','en_pril','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (160,'Репки (10.71.1.10)','en_rep','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (170,'Семеновка (10.71.1.10)','en_sem','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (180,'Славутич (10.71.1.10)','en_slav','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (190,'Сосница (10.71.1.10)','en_sosn','10.71.1.10','Energo');


insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (200,'Сребное (10.71.1.10)','en_srb','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (210,'Талалаевка (10.71.1.10)','en_tal','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (220,'Чернигов город (10.71.1.10)','en_mem','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (230,'Чернигов РЕС (10.71.1.10)','en_cher','10.71.1.10','Energo');

insert into sys_basa_tbl (id,name,alias_,host_,program) 
 values (240,'Щорс (10.71.1.10)','en_sch','10.71.1.10','Energo');
  */
update sys_basa_tbl set dt_restore=now()::date 
  where alias_=current_database()::varchar and host_='10.71.1.10';

  /*
CREATE SEQUENCE syi_sysvars_seq
    START 1
    INCREMENT 1
    MAXVALUE 2147483647
    MINVALUE 1
    CACHE 1;

CREATE TABLE syi_sysvars_tbl (
    id integer DEFAULT nextval('syi_sysvars_seq'::text) NOT NULL,
    ident character varying(15),
    type_ident character varying(15),
    value_ident character varying(255),
    sql_ident character varying(255),
primary key(id)
);
*/

