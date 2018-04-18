;
set client_encoding = 'koi8';

drop function  tarif_ins_fun() cascade;


CREATE OR REPLACE FUNCTION tarif_ins_fun()   RETURNS trigger AS
$BODY$
Declare
rec record;
begin

raise notice 'updval %',new.value;
raise notice 'updid %',new.id;
raise notice 'upddt %',new.dt_begin;
--select * from acd_tarif_tbl where id_tarif=new.id;
update acd_tarif_tbl set dt_end=new.dt_begin where id_tarif=new.id 
 and idk_currency=GetSysVar('def_currency') and dt_end is null;
--select * from acd_tarif_tbl where id_tarif=new.id;
raise notice 'ins %',new.value;
select  into rec id  from acd_tarif_tbl where id_tarif=new.id
  and dt_begin=new.dt_begin and idk_currency= GetSysVar('def_currency');
if not found then
  raise notice 'insval %',new.value;
  raise notice 'insid %',new.id;
  raise notice 'insdt %',new.dt_begin;
--select * from acd_tarif_tbl where id_tarif=new.id;
 insert into acd_tarif_tbl (id_tarif,dt_begin,idk_currency,value)
  values (new.id,new.dt_begin,GetSysVar('def_currency'),new.value);
--select * from acd_tarif_tbl where id_tarif=new.id;
  raise notice 'ins1111';
else
 raise exception 'Exception';
end if;
return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION tarif_ins_fun()
  OWNER TO local;
                 
create trigger tarif_ins
   before Insert on aci_tarif_tbl
   For Each Row Execute Procedure tarif_ins_fun();
       
drop function tarif_upd_fun() cascade;

CREATE OR REPLACE FUNCTION tarif_upd_fun()  RETURNS trigger AS
$BODY$
Declare
rec record;
begin

raise notice 'updval %',new.value;
raise notice 'updid %',new.id;
raise notice 'upddt %',new.dt_begin;
--select * from acd_tarif_tbl where id_tarif=new.id;
update acd_tarif_tbl set dt_end=new.dt_begin where id_tarif=new.id 
 and idk_currency=GetSysVar('def_currency') and dt_end is null;
--select * from acd_tarif_tbl where id_tarif=new.id;
raise notice 'ins %',new.value;
select  into rec id  from acd_tarif_tbl where id_tarif=new.id
  and dt_begin=new.dt_begin and idk_currency= GetSysVar('def_currency');
if not found then
  raise notice 'insval %',new.value;
  raise notice 'insid %',new.id;
  raise notice 'insdt %',new.dt_begin;
--select * from acd_tarif_tbl where id_tarif=new.id;
 insert into acd_tarif_tbl (id_tarif,dt_begin,idk_currency,value)
  values (new.id,new.dt_begin,GetSysVar('def_currency'),new.value);
--select * from acd_tarif_tbl where id_tarif=new.id;
  raise notice 'ins1111';
else
 raise exception 'Exception';
end if;
return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION tarif_upd_fun()
  OWNER TO local;
  
                     
create trigger tarif_upd
   After Update  on aci_tarif_tbl
   For Each Row Execute Procedure tarif_ins_fun();

                


drop function tarifd_upd_ins_fun() cascade;
drop trigger tarifd_ins on acd_tarif_tbl;
drop trigger tarifd_upd on acd_tarif_tbl;

CREATE OR REPLACE FUNCTION tarifd_upd_ins_fun()   RETURNS trigger AS
$BODY$
Declare
nextr record;
begin

raise notice 'updid % newdt % newval %',new.id,new.dt_begin,new.value;


update acd_tarif_tbl set dt_end=new.dt_begin where id_tarif=new.id_tarif 
 and idk_currency=new.idk_currency  
  and dt_begin=(select max(dt_begin) 
                 from acd_tarif_tbl 
                 where dt_begin<new.dt_begin and id_tarif=new.id_tarif and idk_currency=new.idk_currency);


select  into nextr * from acd_tarif_tbl where    id_tarif=new.id_tarif 
    and idk_currency=new.idk_currency  
    and dt_begin=(select max(dt_begin) 
                 from acd_tarif_tbl 
                 where dt_begin<new.dt_begin and id_tarif=new.id_tarif and idk_currency=new.idk_currency);
if  found then
  raise notice 'nextr id % nextr dtold % nextr dtnew %', nextr.id, nextr.dt_begin,new.dt_begin;
  new.dt_end=nextr.dt_begin;
  update acd_tarif_tbl set dt_begin=new.dt_end where id=nextr.id;
end if;
return null;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION tarif_ins_fun()
  OWNER TO local;


create trigger tarifd_ins
   After Insert on acd_tarif_tbl
   For Each row Execute Procedure tarifd_upd_ins_fun();
 /*
create trigger tarifd_upd
   After update on acd_tarif_tbl
   For Each row Execute Procedure tarifd_upd_ins_fun();
*/
drop function tarifd_del_fun() cascade;
drop trigger tarifd_del on acd_tarif_tbl;

CREATE OR REPLACE FUNCTION tarifd_del_fun()   RETURNS trigger AS
$BODY$
Declare
nextr record;
begin

raise notice 'oldid % olddt % oldval %',old.id,old.dt_begin,old.value;

update acd_tarif_tbl set dt_end=null where id_tarif=old.id_tarif 
 and idk_currency=old.idk_currency  
  and dt_begin=(select max(dt_begin) 
                 from acd_tarif_tbl 
                 where dt_begin<old.dt_begin and id_tarif=old.id_tarif and idk_currency=old.idk_currency);

update acd_tarif_tbl set dt_end=(select min(dt_begin) 
                 from acd_tarif_tbl 
                 where dt_begin>old.dt_begin and id_tarif=old.id_tarif and idk_currency=old.idk_currency)
  where id_tarif=old.id_tarif 
 and idk_currency=old.idk_currency  
  and dt_begin=(select min(dt_begin) 
                 from acd_tarif_tbl 
                 where dt_begin>old.dt_begin and id_tarif=old.id_tarif and idk_currency=old.idk_currency);


select into nextr  * from acd_tarif_tbl where    id_tarif=old.id_tarif 
    and idk_currency=old.idk_currency  
    and dt_begin=(select min(dt_begin) 
                 from acd_tarif_tbl 
                 where dt_begin>old.dt_begin and id_tarif=old.id_tarif and idk_currency=old.idk_currency );

if  found then
  raise notice 'nextr id % nextr dtold % nextr dtnew %', nextr.id, nextr.dt_begin,new.dt_begin;
  update acd_tarif_tbl set dt_begin=old.dt_begin where id=nextr.id;
end if;
return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;


create trigger tarifd_del
   After delete on acd_tarif_tbl
   For Each row Execute Procedure tarifd_del_fun();


/*

update aci_tarif_tbl  set value=
 (select value from acd_tarif_tbl t2 where dt_begin>=
          (select max(dt_begin) from acd_tarif_tbl t3 where t3.id_tarif=t2.id_tarif) 
   and aci_tarif_tbl.id=t2.id_tarif),
dt_begin=(select dt_begin from acd_tarif_tbl t2 where dt_begin>=
          (select max(dt_begin) from acd_tarif_tbl t3 where t3.id_tarif=t2.id_tarif) 
   and aci_tarif_tbl.id=t2.id_tarif);

*/

DROP TRIGGER eqk_updzone_trg ON eqk_zone_tbl;
DROP TRIGGER eqk_inszone_trg ON eqk_zone_tbl;
DROP FUNCTION eqk_updzone_fun();                                                   
                                                                                                  
CREATE FUNCTION eqk_updzone_fun()  RETURNS trigger     AS  '
declare przon record;
  begin 
   
   select into przon id_zone,dt_begin,koef,hours from acd_zone_tbl
      where id_zone=new.id and new.dt_begin=dt_begin; 
    if found then
      if (przon.koef=new.koef) or (przon.hours=new.hours) then
       return new;
      end if;
     if (przon.koef<>new.koef) or (przon.hours=new.hours) then
      update acd_zone_tbl set koef=new.koef, hours=new.hours 
       where id_zone=new.id and dt_begin=new.dt_begin;

      -- insert into acd_zone_tbl (id_zone,dt_begin,koef) values(new.id,new.dt_begin+ interval ''1 day'',new.koef);
      -- raise exception ''Нельзя изменять коеффициент на старую дату '';
      -- return old;
     end if;
    else
      insert into acd_zone_tbl (id_zone,dt_begin,koef,hours) values(new.id,new.dt_begin,new.koef,new.hours);
    end if;

  RETURN NEW;
 end;'                                                                                           
 LANGUAGE 'plpgsql';          

CREATE TRIGGER eqk_updzone_trg 
AFTER update 
ON eqk_zone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqk_updzone_fun();

CREATE TRIGGER eqk_inszone_trg 
AFTER insert
ON eqk_zone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqk_updzone_fun();

