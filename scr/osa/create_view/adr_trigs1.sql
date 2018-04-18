
DROP TRIGGER adi_insstreet_trg ON adi_street_tbl;
DROP TRIGGER adi_delstreet_trg ON adi_street_tbl;
DROP TRIGGER adi_updstreet_trg ON adi_street_tbl;

alter table adi_town_tbl alter column id_region set default syi_region_fun();

DROP FUNCTION adi_insstreet_fun ();                                                   
                                                                                                  
  CREATE or REPLACE FUNCTION adi_insstreet_fun ()                                                  
  RETURNS OPAQUE                                                                                     
  AS  '                                                                                            
   declare id_dom integer;
   declare id_reg integer; 
    begin     
      select into id_reg id_region from adi_town_tbl where id=NEW.id_town;
      select into id_dom id_domain from adi_region_tbl where id=id_reg;
               
   insert into adm_commadr_tbl (id_domain,id_region,id_town,id_street)
       values (id_dom,id_reg,NEW.id_town,NEW.id);   
  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER adi_insstreet_trg 
AFTER INSERT 
ON adi_street_tbl
FOR EACH ROW 
EXECUTE PROCEDURE adi_insstreet_fun();



DROP FUNCTION adi_delstreet_fun ();                                                   
                                                                                                  
  CREATE  or replace FUNCTION adi_delstreet_fun ()                                                  
  RETURNS OPAQUE                                                                                     
  AS  '     
  declare is_adr int;
  declare recadr record;
  begin
  is_adr:=0;
  for  recadr in select id_street from adm_address_tbl where id_street=old.id 
   loop
   is_adr:=1;
    exit;
  end loop; 
  if is_adr=0 then                                                                               
   delete from adm_commadr_tbl where id_street=old.id;
  end if;
  RETURN old;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER adi_delstreet_trg 
BEFORE DELETE 
ON adi_street_tbl
FOR EACH ROW 
EXECUTE PROCEDURE adi_delstreet_fun();

DROP TRIGGER adi_updstreet_trg 
DROP FUNCTION adi_updstreet_fun ();                                                   
                                                                                              
CREATE  or replace FUNCTION adi_updstreet_fun ()                                                  
  RETURNS OPAQUE                                                                                     
  AS  '     
  declare is_adr int;
  declare recadr record;
  begin
  is_adr:=0;
  for  recadr in select id_street from adm_address_tbl where id_street=old.id 
   loop
   is_adr:=1;
    exit;
  end loop; 
  if is_adr=0 then                                                                               
   update adm_commadr_tbl set id_town=new.id_town where id_street=old.id;
  end if;
  RETURN old;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER adi_updstreet_trg 
After Update
ON adi_street_tbl
FOR EACH ROW 
EXECUTE PROCEDURE adi_updstreet_fun();

alter table adk_building_tbl add column short_name varchar (10);
alter table adk_office_tbl add column short_name varchar (10);
alter table adm_address_tbl add column short_adr  varchar (100);


--alter table adm_address_tbl add column building1  varchar (12);
--update adm_address_tbl set building1=cast(building as varchar(12));

--alter table adm_address_tbl drop column building cascade; 
--alter table adm_address_tbl add column building  varchar (5);
--DROP TRIGGER adm_adr_trg;
--update adm_address_tbl set building=ltrim(building1);
--alter table adm_address_tbl drop column building1;



DROP TRIGGER adm_adr_trg; 
DROP FUNCTION adm_adres_fun () cascade;                                                   
DROP FUNCTION adm_adr_fun () cascade;                                                   
update adm_address_tbl set building=null where building>9999;
select altr_colmn('adm_address_tbl','building','varchar(4)');
                                                                                              
CREATE  or replace FUNCTION adm_adres_fun ()                                                  
  RETURNS OPAQUE                                                                                     
  AS  '     
  declare k_build varchar(10);
  declare build   varchar(10);
  declare k_addbuild   varchar(10);
  declare addbuild   varchar(10);
  declare k_office   varchar(10);
  declare office   varchar(10);
  begin
  
 select into k_build  short_name from adk_building_tbl where id=new.idk_building;
 if new.building is not null then
   build=coalesce(k_build,'' '')||'' ''||lpad(ltrim(new.building),4);
 else
    build='''';
 end if;

 if (new.building_add is not null and ltrim(rtrim(new.building_add))<>'''')then
   addbuild=''-''||rtrim(ltrim(new.building_add));
 else
    addbuild='''';
 end if;

 select into k_office  short_name from adk_office_tbl where id=new.idk_office;

 if new.office is not null then
   office=coalesce(k_office,''/'')||lpad(ltrim(rtrim(new.office)),3);
 else
    office='''';
 end if;
 raise notice ''build- %'',build;
 raise notice ''addbuild- %'',addbuild;
 raise notice ''office- %'',office;

 new.short_adr=build||addbuild||office; 

RETURN new;
end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER adm_adr_trg 
before Update or insert
ON adm_address_tbl
FOR EACH ROW 
EXECUTE PROCEDURE adm_adres_fun();

--select count(*)  from adm_address_tbl where short_adr is null;
--update adm_address_tbl set office=office where short_adr is null;

