

create or replace function abon_lost_fun(date) returns boolean as 
'declare 
  mmgg1 Alias for $1;
  mmgg2 date; 
  pref int; 
  kodres int;
  tabl varchar;
  del varchar; 
  nul varchar;
  SQL text;
  ret boolean;
  k_energy int;
begin 
pref=10;
k_energy=1;
mmgg2=eom(mmgg1);
ret=bal_abon_find_fun();
delete from  seb_abon_lost_tmp; 
select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

insert into seb_abon_lost_tmp 
 (   kind_dep,  mmgg , losts,  voltage  ,   code , id_client ,
    id_fider    , fider,  id_point, point_name, num_eqp,  
    demand     , sum_demand,set_power,connect_power  )
select kodres,mmgg1, coalesce(lost_nolost,0),coalesce(id_voltage,0), cl.code, cl.id,   
   0 as id_fider ,Null as fider ,  id_point, name_eqp, num_eqp,  
    sum(dem) as dem , sum(kvt) as kvt,set_power,connect_power  
  from clm_client_tbl as cl 
  join acm_bill_tbl as b on (cl.id = b.id_client) 
  join (select id_point, id_doc, sum(demand_val) as kvt,sum(sum_val) as dem, max(dt_end) as dt_end 
   from acd_billsum_tbl where id_tariff not in ( 900002, 900001, 999999) group by id_point, id_doc )as bs using ( id_doc) 
  join  ( select eq3.id,eq3.name_eqp from eqm_equipment_h as eq3 join 
    (select id,max(dt_b) as maxdt from eqm_equipment_h where type_eqp = 12  group by id ) as sdt3 on (sdt3.id = eq3.id and sdt3.maxdt = eq3.dt_b) 
  ) as eq2  on (bs.id_point=eq2.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  left join  ( select distinct id_point,id_doc, max(num_eqp) as num_eqp 
    from acd_met_kndzn_tbl where mmgg >= date_trunc(''month'', mmgg1::date) and mmgg <= date_trunc(''month'', mmgg2::date) and kind_energy = k_energy 
    group by id_point,id_doc) as kz   using (id_point,id_doc) 
  where b.mmgg >= date_trunc(''month'', mmgg1::date) and b.mmgg <= date_trunc(''month'', mmgg2::date) and b.id_pref = pref and cl.book = -1 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 
   where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,b.reg_date,p2.dt_b) ) 
  and (bs.dem <>0 or bs.kvt <>0 ) 
  group by id_point, name_eqp, num_eqp,id_voltage,lost_nolost,cl.id, cl.code
  order by id_voltage desc , cl.code;
 
update seb_abon_lost_tmp set id_fider=b.id_grp,fider=b.name_fid 
 from ( select b.*,e.name_eqp  as name_fid 
 from bal_abons_tbl b,eqm_equipment_tbl e where e.id=b.id_grp) b where b.id_client=seb_abon_lost_tmp.id_client 
  and  b.id_point=seb_abon_lost_tmp.id_point;
  
raise notice ''losts'';
 tabl=''/home/local/seb/''||kodres||''lst_lost.TXT'';
 del=''@''; nul='''';
 SQL=''copy  seb_abon_lost_tmp ( kind_dep,  mmgg , losts,  voltage  ,   code , 
     fider,   point_name, num_eqp,  
    demand     , sum_demand) 
  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 Execute SQL;

return true;

end;
' language 'plpgsql';

create or replace function abon_limit_fun(date) returns boolean as 
'declare 
  mmgg1 Alias for $1;
  mmgg2 date; 
  pref int; 
  kodres int;
  tabl varchar;
  del varchar; 
  nul varchar;
  SQL text;
  ret boolean;
  k_energy int;
begin 
pref=10;
k_energy=1;
mmgg2=eom(mmgg1);
ret=bal_abon_find_fun();
delete from  seb_abon_lost_tmp; 
select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

insert into seb_abon_limit_tmp 
 (   kind_dep,  mmgg ,  reg_num ,  reg_date , idk_document, 
     code ,  dt,id_area, id_point, month_limit,value_dem
 )
select kodres,h.mmgg, h.reg_num,h.reg_date,h.idk_document,
 cl.code, h.dt,h.id_area ,null, h.month_limit, h.value_dem 
  from clm_client_tbl as cl,
  (select h.mmgg,h.id_client, h.reg_num,h.reg_date,h.idk_document,
  h.dt,d.id_area ,null, d.month_limit, d.value_dem  from acm_headdemandlimit_tbl h,acd_demandlimit_tbl d where d.id_doc=h.id_doc ) as h
  where h.id_client=cl.id;



 
update seb_abon_limit_tmp set id_point= a.code_eqp from
        (select c.code_eqp,c.code_eqp_inst from eqm_compens_station_inst_tbl c,
        eqm_area_tbl a where c.code_eqp_inst=a.code_eqp order by c.code_eqp) a 
where a.code_eqp_inst= seb_abon_limit_tmp.id_area;

  
raise notice ''losts'';
 tabl=''/home/local/seb/''||kodres||''lst_lost.TXT'';
 del=''@''; nul='''';
 SQL=''copy  seb_abon_lost_tmp ( kind_dep,  mmgg , losts,  voltage  ,   code , 
     fider,   point_name, num_eqp,  
    demand     , sum_demand) 
  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 Execute SQL;

return true;

end;
' language 'plpgsql';
