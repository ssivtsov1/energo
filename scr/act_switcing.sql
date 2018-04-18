alter table clm_action_tbl add column id_place_on int;
alter table clm_action_tbl add column id_place_off int;
alter table clm_action_tbl add column id_reason_warning int;
alter table clm_action_tbl add column id_reason_off int;

create or replace function seb_action() returns boolean as 
$BODY$
declare 

 kodres int;
 existt boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; 
 nul varchar;
 SQL text;
begin


 select into path_export value_ident from syi_sysvars_tbl where ident='path_exp';
  if path_export is null then
     path_export='/home/local/seb/';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident='kod_res'; 
 if found then 
   tabl=path_export||kodres||'ACTION.TXT';
   del=';'; nul='';

   SQL='copy (   select c.kind_dep,a.id,a.dt::date,mmgg,c.code,a.id_pref,flag_avans,dt_warning,dt_warning_to,dt_trans_warning,id_trans_mode,coalesce(trim(t.name),'' '')||'' ''||trim(add_trans_mode),summ_warning,
       id_reason_warning,coalesce(trim(rw.name),'' '')||'' ''||trim(comment_warning), 
dt_off,order_off,poff.represent_name,id_place_off,coalesce(trim(pl_off.name),'' '')||'' ''||trim(place_off),id_reason_off,coalesce(trim(roff.name),trim(reason_off)),dt_pay,summ_pay,dt_on,order_on,pon.represent_name,
id_place_on,pl_on.name
from clm_client_tbl c,clm_action_tbl  a 
left join cmi_transmiss_tbl t on a.id_trans_mode=t.id
left join cmi_place_tbl pl_off on a.id_place_off=pl_off.id
left join cmi_reason_tbl rw on a.id_reason_warning=rw.id
left join cmi_reason_tbl roff on a.id_reason_off=roff.id
left join cmi_place_tbl pl_on on a.id_place_on=pl_on.id
left join 
(   select p.id,p.id_position,(pn.name||''  ''|| p.represent_name)::varchar as represent_name from clm_position_tbl p, cli_position_tbl pn
       where p.id_position=pn.id  ) poff on poff.id=a.id_person_off 
left join 
(   select p.id,p.id_position,(pn.name||''  ''|| p.represent_name)::varchar as represent_name from clm_position_tbl p, cli_position_tbl pn
       where p.id_position=pn.id  ) pon on pon.id=a.id_person_on    
where c.id=a.id_client )
                to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '''' ';

--SQL='copy  seb_tar_tmp (kind_dep,code,id_grouptarif,mmgg,id_tariff,id_classtarif, kvt,val) to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul);

   raise notice 'SQL   --- %',SQL;

   Execute SQL;


   if flag_export is null or flag_export='1' then
     raise notice ' ======== Copy Sql  ======  %',SQL;
     Execute SQL;
  end if;


 return true;
else
  raise exception 'Not found kod_res in SYSVARS';
  return false;
end if;
 end;$BODY$
 language 'plpgsql';
/*
select seb_action()

select * from clm_client_tbl
select * from clm_action_tbl

select a.id,dt,mmgg,id_client,id_pref,flag_avans,dt_warning,dt_warning_to,dt_trans_warning,id_trans_mode,coalesce(t.name,' ')||' '||add_trans_mode,summ_warning,id_reason_warning,coalesce(rw.name,' ')||' '||comment_warning, 
dt_off,order_off,poff.represent_name,id_place_off,coalesce(pl_off.name,' ')||' '||place_off,id_reason_off,coalesce(roff.name,reason_off),dt_on,order_on,pon.represent_name
from clm_action_tbl  a 
left join cmi_transmiss_tbl t on a.id_trans_mode=t.id
left join cmi_place_tbl pl_off on a.id_place_off=pl_off.id
left join cmi_reason_tbl rw on a.id_reason_warning=rw.id
left join cmi_reason_tbl roff on a.id_reason_off=roff.id
left join 
(   select p.id,p.id_position,(pn.name||'  '|| p.represent_name)::varchar as represent_name from clm_position_tbl p, cli_position_tbl pn
       where p.id_position=pn.id  ) poff on poff.id=a.id_person_off 
left join 
(   select p.id,p.id_position,(pn.name||'  '|| p.represent_name)::varchar as represent_name from clm_position_tbl p, cli_position_tbl pn
       where p.id_position=pn.id  ) pon on pon.id=a.id_person_on 
 */


create table cmi_place_tbl
(id serial,
 name varchar(25),
primary key (id)
);
insert into cmi_place_tbl (id,name) values (1,'на опорі');
insert into cmi_place_tbl (id,name) values (2,'ввідний автомат');
insert into cmi_place_tbl (id,name) values (3,'на їзоляторах ввода ');
insert into cmi_place_tbl (id,name) values (4,'в щитовій');
insert into cmi_place_tbl (id,name) values (5,'в КТП');
insert into cmi_place_tbl (id,name) values (6,'на обладнанні споживача');
insert into cmi_place_tbl (id,name) values (7,'інше');

create table cmi_reason_tbl
(id serial,
 name varchar(25),
primary key (id)
);



insert into cmi_reason_tbl (id,name) values (1,'борг');
insert into cmi_reason_tbl (id,name) values (2,'недоплата');
insert into cmi_reason_tbl (id,name) values (3,'невиконання вимоги');
insert into cmi_reason_tbl (id,name) values (4,'недопуск');
insert into cmi_reason_tbl (id,name) values (5,'заява споживача');
insert into cmi_reason_tbl (id,name) values (6,'за акт порушення');
insert into cmi_reason_tbl (id,name) values (10,'закритий договір');

/*
select distinct comment  from clm_switching_tbl

select distinct place_off from clm_switching_tbl
select distinct  reason_off from clm_switching_tbl order by  reason_off

*/