-- drop table clm_action_tbl
CREATE TABLE clm_action_tbl
(
  id  serial,
  dt timestamp DEFAULT now(),
  id_person integer DEFAULT getsysvar('id_person'::character varying),
  mmgg date  DEFAULT fun_mmgg(),
  id_client integer,
  kind_energy int,
  flag_avans  int,
  dt_warning date,
  dt_warning_to date,
  dt_trans_warning date,
  id_trans_mode int,
  add_trans_mode varchar(50),
  summ_warning   numeric (15,5)  DEFAULT 0.00,
  comment_warning varchar (255),
  dt_off date,
  id_person_off int,
  id_eqp_off int,
  place_off varchar(50),
  reason_off varchar(50), 
  order_off varchar(25), 
  dt_pay date,
  summ_pay  numeric (15,5)  DEFAULT 0.00,
  dt_on date,
  order_on varchar(25), 
  id_person_on int,
  PRIMARY KEY (id)
);



CREATE TABLE clm_action_h
(
  id int,
  dt timestamp DEFAULT now(),
  id_person integer DEFAULT getsysvar('id_person'::character varying),
  mmgg date,
  id_client integer,
  kind_energy int,
  flag_avans  int,
  dt_warning date,
  dt_warning_to date,
  dt_trans_warning date,
  id_trans_mode int,
  add_trans_mode varchar(50),
  summ_warning   numeric (15,5)  DEFAULT 0.00,
  comment_warning varchar (255),
  dt_off date,
  id_person_off int,
  id_eqp_off int,
  place_off varchar(50),
  reason_off varchar(50), 
  order_off varchar(25), 
  dt_pay date,
  summ_pay  numeric (15,5)  DEFAULT 0.00,
  dt_on date,
  order_on varchar(25), 
  id_person_on int,
  id_change serial ,
  dt_change timestamp without time zone DEFAULT now(),
  id_person_change integer DEFAULT getsysvar('id_person'::character varying),
  mmgg_change date  DEFAULT fun_mmgg(),
  PRIMARY KEY (id_change)
);


CREATE TABLE cmi_transmiss_tbl
(
  id serial,
  name varchar(30),
  PRIMARY KEY (id)
);
insert into cmi_transmiss_tbl (id,name) values (1,'особисто (під підпис)');
insert into cmi_transmiss_tbl (id,name) values (2,'телефоном (телефонограмма)');
insert into cmi_transmiss_tbl (id,name) values (3,'лист (рекомендований лист)');
insert into cmi_transmiss_tbl (id,name) values (4,'факс');
insert into cmi_transmiss_tbl (id,name) values (5,'електр.пошта');
insert into cmi_transmiss_tbl (id,name) values (6,'нарочним');
insert into cmi_transmiss_tbl (id,name) values (11,'від підпису відмовився');


/*
select s.* from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  ms where s.id_client=ms.id_client 
and s.dt_action=ms.maxdt  --and action=2 
  order by id_client

select * from clm_switching_tbl where id_client=2268 order by id

select * from clm_action_tbl order by id_client

update clm_switcing_tbl set reason_off='аванс' where reason_off='попередня оплата';
*/
update clm_switching_tbl set reason_off='аванс' where reason_off='попередня оплата';
update clm_switching_tbl set reason_off='аванс' where reason_off='плановий платіж';
update clm_switching_tbl set reason_off='аванс' where lower(reason_off) like '%план%';
update clm_switching_tbl set reason_off='аванс' where reason_off like '%предопл%';

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,10,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,float4larger(coalesce(sum_ae,0),sum_warning),comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and reason_off not like '%аванс%' and reason_off not like '%Аванс%' and sum_re is null and sum_2kr is null 
 order by id_client;


insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,20,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and reason_off not like '%аванс%' and reason_off not like '%Аванс%' and sum_re is not null  
order by id_client;

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,520,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and reason_off not like '%аванс%' and reason_off not like '%Аванс%' and sum_2kr is not null 
 order by id_client;

-- null
insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,10,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and reason_off is null and sum_re is null and sum_2kr is null 
order by id_client;


insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,20,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and reason_off is null and sum_re is not null  
order by id_client;

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,520,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and reason_off is null and sum_2kr is not null  
order by id_client;




-- аванс

--select * from clm_action_tbl
insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,10,1,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and (action=5 or reason_off  like '%аванс%' or reason_off  like '%Аванс%') and sum_re is null and sum_2kr is null 
order by id_client;


insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,20,1,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and (action=5 or reason_off  like '%аванс%' or reason_off  like '%Аванс%') and sum_re is not null  
order by id_client;

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,520,1,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and (action=5 or reason_off  like '%аванс%' or reason_off  like '%Аванс%') and sum_2kr is not null  
order by id_client;


-- отключен


insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_off,  dt_warning,     place_off,reason_off
)
select  s.id_client,10,0,dt_action,dt_warning,place_off,substring(coalesce(reason_off,' ')||coalesce(comment,' '),1,50)
 from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=1  
order by s.id_client;

--Подключен
insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_on,  dt_warning,comment_warning
)
select  s.id_client,10,0,dt_action,dt_warning,substring(coalesce(reason_off,' ')||coalesce(comment,' '),1,50)
 from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=3  
order by s.id_client;
--select * from clm_action_tbl
--Оплачено
insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_pay,  dt_warning  
)
select  s.id_client,10,0,dt_action,dt_warning
 from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=4  
order by s.id_client;


 select distinct id_trans_mode,add_trans_mode from clm_action_tbl;
update clm_action_tbl set id_trans_mode = 2 where strpos(lower(add_trans_mode),'телеф'::text)>0;
update clm_action_tbl set id_trans_mode = 1 where strpos(lower(add_trans_mode),'підпис'::text)>0;
update clm_action_tbl set id_trans_mode = 1 where strpos(lower(add_trans_mode),'особ'::text)>0;
update clm_action_tbl set id_trans_mode = 3 where strpos(lower(add_trans_mode),'лист'::text)>0;
update clm_action_tbl set id_trans_mode = 4 where strpos(lower(add_trans_mode),'факс'::text)>0;
update clm_action_tbl set id_trans_mode = 5 where strpos(lower(add_trans_mode),'елек'::text)>0;
update clm_action_tbl set id_trans_mode = 5 where strpos(lower(add_trans_mode),'ел.адреса'::text)>0;
update clm_action_tbl set id_trans_mode = 6 where strpos(lower(add_trans_mode),'нароч'::text)>0;
update clm_action_tbl set id_trans_mode = 7 where strpos(lower(add_trans_mode),'відмов'::text)>0;

/*
select c.code,id_client,kind_energy,flag_avans,count(*) from clm_action_tbl,clm_client_tbl c where c.id=id_client
 group by c.code,id_client,kind_energy,flag_avans having count(*)>1 

select * from clm_action_tbl a,clm_action_tbl b where a.id_client=b.id_client and a.kind_energy=b.kind_energy
 and a.flag_avans=b.flag_avans and a.dt_warning between  b.dt_off -interval '3 day' and b.dt_off  and a.id<>b.id order by a.id_client

select * from clm_action_tbl a,clm_action_tbl b where a.id_client=b.id_client and a.kind_energy=b.kind_energy
 and a.flag_avans=b.flag_avans and a.dt_warning between  b.dt_pay -interval '3 day' and b.dt_pay  and a.id<>b.id order by a.id_client

*/

select distinct id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  id_trans_mode ,  summ_warning   ,  comment_warning ,
  dt_off ,  id_person_off ,  id_eqp_off ,  place_off ,  reason_off , 
  dt_pay ,  summ_pay  ,  dt_on ,  order_on ,  id_person_on into clm_action_tbl22 from clm_action_tbl order by id_client;

delete from clm_action_tbl;

insert into clm_action_tbl ( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  id_trans_mode ,  summ_warning   ,  comment_warning ,
  dt_off ,  id_person_off ,  id_eqp_off ,  place_off ,  reason_off , 
  dt_pay ,  summ_pay  ,  dt_on ,  order_on ,  id_person_on)  
select id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  id_trans_mode ,  summ_warning   ,  comment_warning ,
  dt_off ,  id_person_off ,  id_eqp_off ,  place_off ,  reason_off , 
  dt_pay ,  summ_pay  ,  dt_on ,  order_on ,  id_person_on from clm_action_tbl22;


update clm_action_tbl set dt_off=dof from 
( select a.*,b.dt_off  as dof from clm_action_tbl a,clm_action_tbl b where a.id_client=b.id_client and a.kind_energy=b.kind_energy
  and a.flag_avans=b.flag_avans and a.dt_warning between  b.dt_off -interval '3 day' and b.dt_off  and a.id<>b.id  and b.dt_warning is null order by a.id_client
) a where clm_action_tbl.id=a.id;

update clm_action_tbl set dt_pay=dpay from 
(select a.*,b.dt_pay as dpay  from clm_action_tbl a,clm_action_tbl b where a.id_client=b.id_client and a.kind_energy=b.kind_energy
 and a.flag_avans=b.flag_avans and a.dt_warning between  b.dt_pay -interval '3 day' and b.dt_pay  and a.id<>b.id  and b.dt_warning is null order by a.id_client
) a where clm_action_tbl.id=a.id;

update clm_action_tbl set dt_on=don from 
(select a.*,b.dt_on as don from clm_action_tbl a,clm_action_tbl b where a.id_client=b.id_client and a.kind_energy=b.kind_energy
 and a.flag_avans=b.flag_avans and a.dt_warning between  b.dt_on -interval '3 day' and b.dt_on  and a.id<>b.id  and b.dt_warning is null order by a.id_client
) a where clm_action_tbl.id=a.id;

delete from clm_action_tbl where dt_warning is null and dt_pay<='2017-10-31';
select * from clm_action_tbl where dt_warning is null;

select c.code,id_client,kind_energy,flag_avans,count(*) from clm_action_tbl,clm_client_tbl c where c.id=id_client
 group by c.code,id_client,kind_energy,flag_avans having count(*)>1; 

/*
select * from clm_action_tbl order by id_client


select sw.*, 
    (case when  sw.dt_off is not null then 'îòêë.' else '    ' end)::varchar as off, 
        (case when  sw.dt_off is not null then 'îïë.' else '   ' end)::varchar  as pay, 
               (case when  sw.dt_on is not null then 'ïîäêë.' else '     ' end)::varchar  as onn 
     from clm_action_tbl sw 
    order by sw.dt_warning desc,dt_off desc,dt_pay desc; 

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,20,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and ((reason_off not like '%аванс%' and reason_off not like '%Аванс%') or reason_off is null) and sum_re is not null  order by id_client

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  add_trans_mode ,  summ_warning   ,  comment_warning , place_off,reason_off
)
select s.id_client,520,0,dt_action,dt_warning,dt_transmiss,mode_transmiss,sum_ae,comment,place_off,reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  
  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 and ((reason_off not like '%аванс%' and reason_off not like '%Аванс%') or reason_off is null) and sum_2kr is not null  order by id_client

select sw.*, c.code, c.short_name  from clm_action_tbl as sw join clm_client_tbl as c on (c.id = sw.id_client)");
   order by sw.dt_warning, code


select s.* from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  ms where s.id_client=ms.id_client 
and s.dt_action=ms.maxdt  and action=5    order by id_client


select s.* from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  ms where s.id_client=ms.id_client 
and s.dt_action=ms.maxdt     order by id_client

select distinct reason_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 

select distinct place_off from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 



select distinct mode_transmiss from  clm_switching_tbl s,
(select distinct id_client,max(dt_action) over  ( partition by id_client order  by id_client)  as maxdt from clm_switching_tbl group by id_client,dt_action)  ms where s.id_client=ms.id_client and s.dt_action=ms.maxdt  and action=2 



select * from  clm_switching_tbl s order by id_client,dt_action


select sw.*,e.name as energy,trans.name as trans_mode ,poff.represent_name as fio_person_off, pon.represent_name as fio_person_on from clm_action_tbl sw 
left join cmi_transmiss_tbl trans on sw.id_trans_mode=trans.id left join clm_position_tbl poff on sw.id_person_off=poff.id left join clm_position_tbl pon on sw.id_person_on=pon.id ,
aci_pref_tbl e where e.id=sw.kind_energy and sw.id_client = 1965 order by sw.dt_warning desc,dt_off desc,dt_pay desc


--select sw.*,e.name as energy,trans.name as trans_mode ,poff.represent_name as fio_person_off, pon.represent_name as fio_person_on from clm_action_tbl sw left join cmi_transmiss_tbl trans on sw.id_trans_mode=trans.id left join clm_position_tbl poff on sw.id_person_off=poff.id left join clm_position_tbl pon on sw.id_person_on=pon.id ,aci_pref_tbl e where e.id=sw.kind_energy and sw.id_client = 57807 order by sw.dt_warning desc,dt_off desc,dt_pay desc; 

--select * from clm_action_tbl  order by id


select * from aci_pref_tbl order by id

insert into clm_action_tbl
( id_client ,  kind_energy ,  flag_avans  ,  
dt_warning,  dt_warning_to,  dt_trans_warning ,  id_trans_mode ,  summ_warning   ,  comment_warning ,
  dt_off ,  id_person_off ,  id_eqp_off ,  place_off ,  reason_off , 
  dt_pay ,  summ_pay  ,  dt_on ,  order_on ,  id_person_on 
)
*/

select id,dt,mmgg,id_client,kind_energy,flag_avans,dt_warning from clm_action_tbl


select *  from eqm_compens_station_inst_h where code_eqp_inst=273348

select * from eqm_equipment_tbl where type_eqp=11 and id=273348

select * from acd_pwr_limit_over_tbl order by id

select * from eqi_device_kinds_tbl