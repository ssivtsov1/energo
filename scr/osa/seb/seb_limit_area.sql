
create or replace function area_limit_fun(date) returns boolean as 
'declare 
  pmmgg Alias for $1;
  pref int; 
  kodres int;
  recl record;
  path_export text;
  flag_export varchar;
  tabl varchar;
  del varchar; 
  nul varchar;
  SQL text;
  ret boolean;
  k_energy int;
begin 
pref=10;
k_energy=1;
--ret=bal_abon_find_fun();
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

delete from  seb_area_limit_tmp; 

select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

insert into seb_area_limit_tmp 
 (   kind_dep,  mmgg ,  id_client , id_area
 )
select distinct *  from
(select distinct kodres,pmmgg,b.id_client,bs.id_area
 from acm_bill_tbl b,acd_billsum_tbl bs where  b.id_doc=bs.id_doc and b.mmgg=pmmgg
 and bs.kind_energy=1 and b.id_pref=10 order by id_client,id_area ) b
union
(select distinct kodres,pmmgg,hl.id_client,l.id_area from acm_headdemandlimit_tbl as hl 
 join acd_demandlimit_tbl as l  on(hl.id_doc = l.id_doc)
 where  date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + interval ''1 month - 1 days''::interval and idk_document = 600 
order by id_client,id_area) ;--v on v.id_area=b.id_area and v.id_client=b.id_client;

update seb_area_limit_tmp set  code= c.code from
 (select id,code from clm_client_tbl) as c where c.id=seb_area_limit_tmp.id_client;

update seb_area_limit_tmp set  name_area= name_eqp,adr_area=adr from
 (select s.*,e.name_eqp,a.adr::varchar(250) from seb_area_limit_tmp s 
 left join eqm_equipment_tbl e on s.id_area=e.id  
 left join adv_address_tbl a on e.id_addres=a.id   order by id_client,id_area
 ) a where seb_area_limit_tmp.id_area=a.id_area ;


update seb_area_limit_tmp set  d_kvt= kvt from
 (select bs.id_area,b.id_client,sum(bs.demand_val) as kvt
 from acm_bill_tbl b,acd_billsum_tbl bs where  b.id_doc=bs.id_doc and bs.mmgg=pmmgg
 and  b.id_pref in (520,524 )
 group by b.id_client,bs.mmgg,bs.id_area) as a 
 where a.id_client=seb_area_limit_tmp.id_client and a.id_area=seb_area_limit_tmp.id_area;

update seb_area_limit_tmp set  bill_kvt= kvt from
(select b.id_client,bs.id_area,sum(bs.demand_val) as kvt
 from acm_bill_tbl b,acd_billsum_tbl bs 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
 where  b.id_doc=bs.id_doc and bs.mmgg=pmmgg 
 and bs.kind_energy=1 and b.id_pref=10  and b.idk_doc in (200,204 ) 
  and (( tgr.ident !~''tgr8'' and tgr.ident !~''tgr7'') ) 
 group by b.id_client,bs.mmgg,bs.id_area) as a  
where a.id_area=seb_area_limit_tmp.id_area and a.id_client=seb_area_limit_tmp.id_client;

for recl in select * from  seb_area_limit_tmp order by id_client,id_area loop
raise notice ''id_client   % ,id_area %'',recl.id_client,recl.id_area;

update seb_area_limit_tmp set  value_limit= a.value_dem, id_limit=id, doc_limit=reg_num,date_limit=reg_date from
 (select value_dem, l.id_area,l.id, hl.id_doc,hl.reg_num,hl.reg_date from acm_headdemandlimit_tbl as hl 
 join acd_demandlimit_tbl as l  on(hl.id_doc = l.id_doc)
 where l.id_area =recl.id_area and  hl.id_client = recl.id_client and date_trunc(''month'',l.month_limit)  = pmmgg 
 and hl.reg_date <= pmmgg::date + ''1 month - 1 days''::interval and idk_document = 600
 order by hl.reg_date desc limit 1) a  where  seb_area_limit_tmp.id_area=a.id_area;


end loop;


update seb_area_limit_tmp set kind_dep=c.kind_dep from clm_client_tbl c where c.id= seb_area_limit_tmp.id_client;


  

 tabl=path_export||kodres||''limita.TXT'';
 del=''@''; nul='''';
 SQL=''copy  seb_area_limit_tmp( 
     kind_dep  ,       code ,     name_area, mmgg   , adr_area,
     bill_kvt,         value_limit,     doc_limit,     date_limit,      d_kvt       ) 
  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export=''1'' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;


return true;

end;
' language 'plpgsql';



