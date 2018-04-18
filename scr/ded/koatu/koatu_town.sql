;
SET client_encoding = 'WIN';


DROP TABLE tmp_town_koatu_tbl;

CREATE TABLE tmp_town_koatu_tbl
(
  id integer NOT NULL,
  id_region integer,
  cod_res int default getsysvar('kod_res'),
  name_res varchar(200),
  idk_town integer,
  name character varying(45),
  ident character varying(20),
  PRIMARY KEY (id)
) ;


insert into tmp_town_koatu_tbl (id,id_region, idk_town,name, name_res)
select distinct t.id,t.id_region, t.idk_town,t.name, (select name from tmp_res_koatu_tbl where code = getsysvar('kod_res'))
 from eqm_equipment_tbl as eq
join adv_address_tbl as adv on (adv.id = eq.id_addres)
join adi_town_tbl as t on (t.id = adv.id_town) 
where eq.type_eqp = 12
order by t.name;


update tmp_town_koatu_tbl set name = replace(name,'C','ׁ');
update tmp_town_koatu_tbl set name = replace(name,'c','ס');
update tmp_town_koatu_tbl set name = replace(name,'I','²');
update tmp_town_koatu_tbl set name = replace(name,'i','³');

update tmp_town_koatu_tbl set name = replace(name,'  ',' ');
update tmp_town_koatu_tbl set name = replace(name,'"','''');

update tmp_town_koatu_tbl set name = replace(name,'ס.','') where name ~'^ס\\.'; ;
update tmp_town_koatu_tbl set name = replace(name,'סלע.','') where name ~'^סלע\\.'; ;
update tmp_town_koatu_tbl set name = replace(name,'ל.','') where name ~'^ל\\.'; ;

update tmp_town_koatu_tbl set name = trim(name);

update tmp_town_koatu_tbl set ident = substr(ss.ident,1,10)
from
(
select t.id, c.ident from tmp_town_koatu_tbl as t left join 
adi_class_tbl as c on (lower(t.name) = lower(trim(c.name))
and substr(c.ident,1,5) = (select substr(ident,1,5) from tmp_res_koatu_tbl 
where code = getsysvar('kod_res')) )
) as ss where (ss.id =  tmp_town_koatu_tbl.id);
