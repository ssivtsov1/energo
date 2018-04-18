
create or replace function tarif_limit_fun(date) returns boolean as 
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

  delete from rep_last_bill_tmp;

  insert into rep_last_bill_tmp 
              select id_client, max(mmgg) 
              from acm_bill_tbl 
              where mmgg <= pmmgg::date - ''1 month''::interval  and mmgg >=pmmgg::date - ''3 month''::interval 
--              where mmgg <= pmmgg::date and mmgg >=pmmgg::date - ''3 month''::interval 
              and demand_val > 0 and id_pref=10 and idk_doc = 200 
              group by id_client order by id_client ;


   select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

   delete from seb_limit_tarif_tmp ;


   insert into seb_limit_tarif_tmp (kind_dep,mmgg, id_client, value_limit, tarif_value ) 
   select cl.kind_dep, pmmgg, cl.code,  slimit.value_dem, 
     CASE WHEN avgtarsss.f_zone<>0 or avgtarsss.f_othertarif <> 0 or ((avgtarsss.f_main =0) and (avgtarsss.f_fiz <> 0 ) ) 
      THEN avgtarsss.avg_tar ELSE CASE WHEN tarsss.tarif_value is not null THEN tarsss.tarif_value 
      ELSE tar_2kl.tarif_value END END as tarif_value  
--     cl.code, cl.short_name,cl.name as abonname
     from 
      (select cl.* from clm_client_tbl as cl where idk_work not in (0,99) and coalesce(id_state,0) not in (50,99) order by cl.id) as cl  
   left join ( 
   select hl.id_client, sum(d1.value_dem) as value_dem 
     from acd_demandlimit_tbl as d1 
     join acm_headdemandlimit_tbl as hl on (hl.id_doc = d1.id_doc) 
           join ( 
           select h2.id_client,d2.month_limit, d2.id_area, max(h2.reg_date) as maxdate , max(h2.mmgg) as maxmmgg 
           from acm_headdemandlimit_tbl as h2 
           join acd_demandlimit_tbl as d2  on  (h2.id_doc = d2.id_doc) 
           left join eqm_ground_tbl as g on (g.code_eqp = d2.id_area)
           where h2.idk_document = 600 and d2.month_limit= pmmgg 
           and (d2.id_area is null or g.code_eqp is not null) 
           group by h2.id_client , d2.id_area, d2.month_limit order by h2.id_client 
          ) as hh on (hh.id_client = hl.id_client and hh.maxdate = hl.reg_date and hh.maxmmgg = hl.mmgg  
             and hh.month_limit = d1.month_limit and hh.id_area = d1.id_area) 
     where hl.idk_document = 600  and d1.month_limit= pmmgg 
     group by hl.id_client 
     order by hl.id_client 
   ) as slimit on (slimit.id_client =cl.id ) 
   
   left join 
   ( select id_client, CASE when dem1>dem2 then  tcl1_id else tcl2_id end as tcl_id, t.id , tt.value as tarif_value 
     from 
     (select b.id_client, 
      sum(CASE when tcl1.ident=''tcl1'' then bs1.demand_val else 0 end ) as dem1, 
      sum(CASE when tcl1.ident=''tcl2'' then bs1.demand_val else 0 end ) as dem2, 
      max(CASE when tcl1.ident=''tcl1'' then tcl1.id else 0 end) as tcl1_id, 
      max(CASE when tcl1.ident=''tcl2'' then tcl1.id else 0 end) as tcl2_id 
      from acm_bill_tbl as b 
      join acd_billsum_tbl as bs1 on (bs1.id_doc = b.id_doc) 
      join rep_last_bill_tmp as t2 on (t2.id_client = b.id_client and t2.mmgg = b.mmgg ) 
      join aci_tarif_tbl as tar1 on (tar1.id=bs1.id_tariff) 
      join eqi_classtarif_tbl as tcl1 on (tar1.id_classtarif=tcl1.id) 
      where b.id_pref=10 and bs1.demand_val<>0 and b.idk_doc = 200 
      group by b.id_client order by b.id_client 
     ) as tss 
     
    join aci_tarif_tbl as t on (t.id_grouptarif = 12 and t.id_classtarif = CASE when dem1>dem2 then  tcl1_id else tcl2_id end ) 
    join acd_tarif_tbl as tt on (tt.id_tarif = t.id) 
    join (select id_tarif, max(dt_begin) as dtb from acd_tarif_tbl 
              where dt_begin <= pmmgg::date 
              group by id_tarif  )as ttd on (tt.id_tarif = ttd.id_tarif and tt.dt_begin = ttd.dtb) 
    order by id_client 
   ) as tarsss on (tarsss.id_client = cl.id) 
   
   left join 
      ( select b.id_client, CASE WHEN sum(bs1.demand_val) >0 THEN round(sum(bs1.sum_val)/sum(bs1.demand_val),5) ELSE 0 END as avg_tar, 
      sum(CASE WHEN coalesce(bs1.id_zone ,0)<>0 THEN 1 ELSE 0 END ) as f_zone, 
      sum(CASE WHEN coalesce(bs1.id_tariff ,0) not in (12,14,15,16,21,22,29,30,44,45,28,35,37,48) THEN 1 ELSE 0 END ) as f_othertarif, 
      sum(CASE WHEN coalesce(bs1.id_tariff ,0) in (12,14,15,16,21,22,29,30) THEN 1 ELSE 0 END ) as f_main, 
      sum(CASE WHEN coalesce(bs1.id_tariff ,0) in (28,35,37,48) THEN 1 ELSE 0 END ) as f_fiz 
      from acm_bill_tbl as b 
      join acd_billsum_tbl as bs1 on (bs1.id_doc = b.id_doc) 
      join rep_last_bill_tmp as t1 on (t1.id_client = b.id_client and t1.mmgg = b.mmgg ) 
      where b.id_pref=10 and bs1.demand_val<>0 and b.idk_doc = 200 
      group by b.id_client order by b.id_client 
   ) as avgtarsss on (avgtarsss.id_client = cl.id) ,
     (select t.id , tt.value as tarif_value 
      from aci_tarif_tbl as t  
      join acd_tarif_tbl as tt on (tt.id_tarif = t.id) 
      join (select id_tarif, max(dt_begin) as dtb from acd_tarif_tbl 
              where dt_begin <= pmmgg::date 
      group by id_tarif  )as ttd on (tt.id_tarif = ttd.id_tarif and tt.dt_begin = ttd.dtb) 
      where t.id_grouptarif = 12 and t.id_classtarif = 14 
     ) as tar_2kl ;


 tabl=path_export||kodres||''LIMTAR.TXT'';
 del=''@''; nul='''';

 SQL=''copy  seb_limit_tarif_tmp( kind_dep,mmgg, id_client, value_limit, tarif_value  ) 
  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';

  if flag_export is null or flag_export=''1'' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;


return true;

end;
' language 'plpgsql';



