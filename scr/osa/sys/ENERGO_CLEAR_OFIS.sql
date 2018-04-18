select * from clm_client_tbl order by id
insert into clm_client_tbl()

update clm_client_tbl set kind_dep=1
update clm_client_tbl set id_department=10000000

select del_notrigger('clm_client_tbl','update clm_client_tbl set id=100000000 where  id=10000000');
select del_notrigger('clm_statecl_tbl','update clm_statecl_tbl set id=100000000 where  id=10000000');
select del_notrigger('clm_statecl_h','update clm_statecl_h set id=100000000 where  id=10000000');

update clm_client_tbl set name='Название гол.офиса', Short_name='Название  гол.офиса кратко', code=1000000 ,
 code_okpo= 123456666 where id=999999999;

update clm_client_tbl set name='Название подразделения', Short_name='Название подразделения кратко', code=0 ,
 code_okpo= 123456666 where id=10000000

update clm_client_tbl set id=999999999 where id=10000000
update clm_client_tbl set code=0 where id=10000000


select droptable('seq');
select  * from (select * from pg_type where typnamespace=2200 ) p  where p.typname  like '%_seq';
 
select * from syi_sysvars_tbl order by id

select * from adi_town_tbl


select * from adi_region_tbl

update adi_domain_tbl set koatu=''
update adi_domain_tbl set name=replace(name,'i','і');
update adi_domain_tbl set koatu=c.ident from (select d.id,c.ident from adi_class_tbl c, adi_domain_tbl d  where c.name like d.name and idk_class=2) c where c.id= adi_domain_tbl.id;
update adi_domain_tbl set koatu=c.ident from (select d.id,c.ident from adi_class_tbl c, adi_domain_tbl d  where substr(trim(c.name),1,7) like substr(trim(d.name),1,7) and idk_class=2) c where c.id= adi_domain_tbl.id and (koatu is null or koatu='');

update adi_region_tbl set koatu=c.ident from (select d.id,c.ident from adi_class_tbl c, adi_region_tbl d  where substr(trim(c.name),1,7) like substr(trim(d.name),1,7) and idk_class=2) c where c.id= adi_region_tbl.id and (koatu is null or koatu='');


update adi_region_tbl set koatu=c.ident from (select d.id,c.ident from adi_class_tbl c, adi_region_tbl d  where substr(c.name,1,10) like trim(substr(d.name,1,10)) and idk_class=3) c where c.id= adi_region_tbl.id;

select * from adi_class_tbl c, adi_domain_tbl d  where trim(c.name) like trim(d.name) and idk_class=2

select * from adi_class_tbl c, adi_region_tbl d  where substr(c.name,1,10) like trim(substr(d.name,1,10)) and idk_class=3


select * from adi_class_tbl c, adi_town_tbl d  where c.name like d.name and idk_class in (4,5,6,7)
update adi_town_tbl set koatu='';
update adi_town_tbl set koatu=c.ident from (select d.id,c.ident from adi_class_tbl c, adi_town_tbl d  where c.name like d.name and idk_class in (4,5,6,7) and c.ident like '74%') c where c.id= adi_town_tbl.id;
select * from adk_town_tbl


select * from adi_class_tbl c, adi_town_tbl d  where substr(c.name,1,5) like trim(substr(d.name,1,5)) and idk_class in (4,5,6,7)

select * from adi_class_tbl c where name like '%Чернігівська%'
select * from adi_class_tbl c where idk_class=3
select * from adi_domain_tbl

update adi_domain_tbl set id=(koatu::bigint)/100000 where koatu<>''

select * from adi_region_tbl

delete from from adi_street_tbl 

alter table adi_domain_tbl add column koatu bigint; 
alter table adi_region_tbl add column koatu bigint; 
alter table adi_town_tbl add column koatu bigint; 
alter table adi_street_tbl add column koatu bigint; 

alter table adi_domain_tbl alter column koatu type  varchar(13); 
alter table adi_region_tbl alter column koatu type varchar(13); 
alter table adi_town_tbl alter column koatu type varchar(13); 
alter table adi_street_tbl alter column koatu  type varchar(13); 


select * from adi_domain_tbl
update adi_domain_tbl set name=replace(name,'0','і')
update adi_domain_tbl set name=replace(name,'i','і');
update adi_region_tbl set name=replace(name,'i','і');
update adi_region_tbl set name=replace(name,'?','і');
update adi_town_tbl set name=replace(name,'i','і');
update adi_town_tbl set name=replace(name,'?','і');

delete from adi_street_tbl;
delete from adi_town_tbl;
delete from adi_region_tbl;
delete from adi_domain_tbl;
select * from adi_domain_tbl;

insert into adi_domain_tbl (id,name,koatu) select id,' Україна м. '||name,ident from  adi_class_tbl where idk_class=4 and lvl=2;
insert into adi_domain_tbl (id,name,koatu) select id,name||' обл.',ident from  adi_class_tbl where idk_class=2 and lvl=2;
insert into adi_region_tbl (id,id_domain,name,koatu) select id,id_parent,name||' р-н.',ident  from  adi_class_tbl where lvl=3 and   idk_class in (3);
insert into adi_region_tbl (id,id_domain,name,koatu) select id,id_parent,' м. '||name,ident  from  adi_class_tbl where lvl=3 and   idk_class in (4);
insert into adi_region_tbl (id,id_domain,name,koatu) select id,id_parent,'  '||name||' р-н.',ident  from  adi_class_tbl where lvl=3 and   idk_class in (8);

insert into adi_town_tbl (id,id_region,idk_town,name,koatu)  select id,id_parent,idk_class,name,ident  from  adi_class_tbl where lvl=4 and idk_class in (4,5,6,7,8);

select * from adi_region_tbl r right join 
 ( select id,id_parent,idk_class,name,ident  from  adi_class_tbl where lvl=4 and idk_class in (4,5,6,7,8)) t on t.id_parent=r.id where r.id is null 


insert into  adi_town_tbl (id_region,idk_town,name)  
select distinct r.id,4,'.' from adi_region_tbl r left join  adi_town_tbl t on t.id_region=r.id where t.id is null

delete from adi_town_tbl where name='.'


select * from adi_region_tbl r right join 
 ( select *  from  adi_class_tbl where lvl=4 and idk_class in (4,5,6,7,8)) t on t.id_parent=r.id where r.id is null

select * from adi_class_tbl where id in (41963,41987)

delete from adi_town_tbl
delete from adi_region_tbl

select * from adi_town_tbl
select * from adi_region_tbl where id_domain=0

select * from adk_town_tbl
select * from adi_domain_tbl where id in (41961,41949)
delete from adi_domain_tbl where id in (41961,41949)

insert into adi_region_tbl (id,id_domain,name,koatu)  select id,0,name,ident from  adi_class_tbl where idk_class=4 and lvl=2


delete from adi_region_tbl where id_domain in (41961,41949)

delete from adi_town_tbl where id_region in (select id  from adi_region_tbl where id_domain in (41961,41949)

 )
insert into adi_domain_tbl (id,name) values (0,' ');
 
--delete from adi_domain_tbl 

update adk_town_tbl set name='Селище', shot_name='с-ще' where id=7
insert into adk_town_tbl (id,name,shot_name,flag_type) values (8,'Район міста','р-н',true)

select * from adi_class_tbl where lvl=3 and idk_class<>3
select * from adi_class_tbl where id_parent=11

select * from adi_class_tbl where lvl=2 and idk_class<>2

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
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION getsysvarn(character varying)
  OWNER TO osa;
select getsysvarn('kod_res');
select getsysvarn('kod_res')*100000000


select  typname into table seq from (select * from pg_type where typnamespace=2200 ) p  where p.typname  like '%_seq';
select * from seq
select  * from (select * from pg_type ) p   where p.typname  like '%_seq';

SELECT               
  pg_attribute.attname, 
  format_type(pg_attribute.atttypid, pg_attribute.atttypmod) 
FROM pg_index, pg_class, pg_attribute, pg_namespace 
WHERE 
  pg_class.oid = 'tablename'::regclass AND 
  indrelid = pg_class.oid AND 
  nspname = 'public' AND 
  pg_class.relnamespace = pg_namespace.oid AND 
  pg_attribute.attrelid = pg_class.oid AND 
  pg_attribute.attnum = any(pg_index.indkey)
 AND indisprimary


create or replace function set_seq_cod() returns boolean as 
$BODY$ 
declare 
rec_table record;
kodres numeric;
begin 
kodres=getsysvarn('kod_res');
/*if table_exists('seq')  then
perform droptable('seq');
end if;
*/--select  typname into table seq from (select * from pg_type where typnamespace=2200 ) p  where p.typname  like '%_seq'

for rec_table in select * from seq loop
--perform del_notrigger(quote_literal(rec_table.typname),'delete from '||(rec_table.typname));
perform setval(rec_table.typname::varchar,(kodres*10000000)::int4 );
-- getsysvarn('kod_res')*100000000
end loop;
return true;
end;
$BODY$ language plpgsql;
-- устанавливаем последовательности
select set_seq_cod();


select *
from information_schema.columns
where table_schema='public'

select * 
from information_schema.sequences where maximum_value<'2147483647' 

select * 
from information_schema.sequences order by maximum_value

ALTER SEQUENCE "eqi_grouptarif_seq" NO MAXVALUE;
ALTER SEQUENCE "aci_eqm_par_seq" NO MAXVALUE;
ALTER SEQUENCE "cli_position_seq" NO MAXVALUE;
ALTER SEQUENCE "aci_tarif_seq" NO MAXVALUE;

update  information_schema.sequences set   maximum_value='2147483647' where  maximum_value='32767'

where increment = '10' 
and sequence_schema = 'core' 
and sequence_name = 'seqsynceodlogw'

select s.doc_num, s.okpo_num,c.*,s.doc_dat,s.phone,s.inspector, s.operator, 
       s.tax_num,s.flag_taxpay,s.flag_budjet,s.licens_num,s.flag_ed,s.flag_jur, s.fl_cabinet 
      from clm_client_tbl c 
      left join (select s.id,s.id_client,s.okpo_num,s.doc_num,s.doc_dat,s.id_position,s.phone, s.fl_cabinet , 
       tax_num,flag_taxpay,flag_budjet,licens_num,
      p.represent_name as inspector, pp.represent_name as operator, s.flag_ed,s.flag_jur 
      from clm_statecl_tbl s 
      left join clm_position_tbl p  on (s.id_position=p.id) 
      left join clm_position_tbl pp  on (s.id_kur=pp.id) 
      ) s on (s.id_client=c.id)  
 where book<0  and id_state<>50 and c.id_state<>99 order by book,code  
     -- where book<0  and id_state<>50 and c.id_state<>99 and idk_work<>0 order by book,code  

select s.doc_num, s.okpo_num,c.*,s.doc_dat,s.phone,s.inspector, s.operator ,
       s.tax_num,s.flag_taxpay,s.flag_budjet,s.licens_num,s.flag_ed, s.flag_jur, s.fl_cabinet 
      from clm_client_tbl c 
      left join (select s.id,s.id_client,s.okpo_num,s.doc_num,s.doc_dat,s.id_position,s.phone, 
       tax_num,flag_taxpay,flag_budjet,licens_num,
      p.represent_name as inspector, pp.represent_name as operator, s.flag_ed,s.flag_jur, s.fl_cabinet 
         from clm_statecl_tbl as s 
         left join clm_position_tbl p  on (s.id_position=p.id) 
         left join clm_position_tbl pp  on (s.id_kur=pp.id) 
          ) s on (s.id_client=c.id)  
       left join    sys_user_client cu 
        on cu.id_user=getsysvar('last_user') and cu.id_client=c.id    
      where book<0      order by book,code


select * from sys_user_client_tbl

