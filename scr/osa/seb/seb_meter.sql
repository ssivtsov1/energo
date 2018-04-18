;
create or replace function seb_meter(date,date) returns boolean as '
declare 
pdat_b alias for $1;
pdat_e alias for $2;
pmmgg date;

kodres int;
pr boolean;      
  path_export text;
  flag_export varchar;

 tabl varchar;
 del varchar; nul varchar;
 SQL text;
                             

begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;
select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
insert into seb_meter_tmp (
mmgg,kod_res,code,name,dt_zam,
name_eqp, adress,
num_old,type_old,energy,zone,coef_old,value_old,
num_new,type_new,           coef_new,value_new)

select  
  bom(sss1.date_end::date),c.kind_dep,c.code, substr(c.short_name,1,100), sss1.date_end,
 substr(eq.name_eqp,1,50), substr(adr.adr,1,100),
 sss1.num_eqp,substr(m1.type,1,50) , e.name as energy,z.name as zone, sss1.coef_comp, sss1.value,
  sss1.num_eqp2,m2.type as type2 ,sss1.coef_comp2,sss1.value2
  from 
 ( select id_client, id_doc, id_meter, id_point, kind_energy, id_zone , ss1.num_eqp, ss1.id_typemet, ss1.value, ss1.prev_value  , ss1.coef_comp, 
     ss2.num_eqp as num_eqp2, ss2.id_typemet as id_typemet2, ss2.value as value2, ss2.coef_comp as coef_comp2 , coalesce(ss1.date_end,ss2.date_end) as date_end 
     from 
(  select distinct i.id_doc,i.id_client, i.date_end,dind.id_meter, mp.id_point, dind.id_previndic, dind.num_eqp, 
    dind.id_typemet,dind.kind_energy, dind.id_zone, dind.value, prind.value as prev_value , dind.coef_comp 
  from acm_headindication_tbl as i 
  join dci_document_tbl as dk on (i.idk_document = dk.id) 
  join acd_indication_tbl as dind on (i.id_doc = dind.id_doc) 
  join eqm_meter_point_h as mp on (mp.id_meter = dind.id_meter and mp.dt_b<=i.reg_date and coalesce(mp.dt_e,i.date_end) >= i.date_end) 
  left join eqm_equipment_h as eq on (eq.id = dind.id_meter and eq.num_eqp  = dind.num_eqp and eq.dt_e = i.date_end) 
  left join acd_indication_tbl as prind on (prind.id = dind.id_previndic) 
  where dk.ident = ''chn_cnt'' and i.date_end >= pdat_b and i.date_end <= pdat_e and ((dind.id_previndic is not null and dind.value_prev is not null)or eq.id is not null  )
 -- and dind.num_eqp in (181862,866610) order by dind.num_eqp
) as ss1 
full outer join 
(  select distinct i.id_doc,i.id_client , i.date_end ,dind.id_meter, mp.id_point, dind.num_eqp, dind.id_typemet, dind.kind_energy, dind.id_zone,
  dind.value, dind.coef_comp,dind.id_previndic  
  from acm_headindication_tbl as i 
  join dci_document_tbl as dk on (i.idk_document = dk.id) 
  join acd_indication_tbl as dind on (i.id_doc = dind.id_doc) 
  join eqm_meter_point_h as mp on (mp.id_meter = dind.id_meter and mp.dt_b<=i.reg_date and coalesce(mp.dt_e,i.date_end) >= i.date_end) 
  join eqm_equipment_h as eq on (eq.id = dind.id_meter and eq.num_eqp  = dind.num_eqp and eq.dt_b = i.date_end) 
  where dk.ident = ''chn_cnt'' and i.date_end >= pdat_b and i.date_end <= pdat_e and (dind.id_previndic is null or dind.value_prev is null) order by id_doc
) as ss2 
 using(id_client,id_doc, id_meter, id_point, kind_energy, id_zone) 
) as sss1 
join eqm_equipment_h as eq on ( eq.id  = sss1.id_point ) 
join eqk_energy_tbl as e on (e.id = kind_energy) 
join eqk_zone_tbl as z on (z.id = id_zone) 
join clm_client_tbl as c on (c.id = sss1.id_client) 
left join adv_address_tbl as adr on ( adr.id  = eq.id_addres ) 
left join eqi_meter_tbl as m1 on (m1.id = id_typemet) 
left join eqi_meter_tbl as m2 on (m2.id = id_typemet2)
where eq.dt_b = (select max(dt_b) from eqm_equipment_h where id = eq.id and dt_b < date_end  ) 
 -- and (c.id = :client or :client = 0) 
order by sss1.date_end, c.code,id_point, id_meter ;

raise notice ''meter_change'';
 tabl=path_export||kodres||''meter_change.TXT'';
 del=''@''; nul='''';

 SQL=''copy seb_meter_tmp
  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export=''1'' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;




return true;
end;
' language 'plpgsql';
