
  CREATE or replace FUNCTION rep_noindicnt_fun(date)
  RETURNS int
  AS                                                                                              
  '
  declare
   pmmgg Alias for $1;
   vcur_mmgg date;
  begin

  vcur_mmgg := pmmgg;
  truncate rep_noindic_mmgg_tbl;

    insert into rep_noindic_mmgg_tbl(id_client,id_meter,id_point,num_meter,point_name,mmgg) 
    select c.id, eq.id, eqpp.id, eq.num_eqp, eqpp.name_eqp, vcur_mmgg
    from eqm_tree_tbl as tr  
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)  
    join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id)  
    join eqm_meter_tbl as m on (m.code_eqp = eq.id)  
    join eqi_meter_tbl as im on (im.id = m.id_type_eqp)  
    left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id)  
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))  
    left join clm_statecl_tbl as sc on (c.id = sc.id_client)  
    left join eqm_meter_point_h as mp on (mp.id_meter = eq.id and mp.dt_e is null) 
    left join eqm_point_tbl as pp on (pp.code_eqp = mp.id_point ) 
    left join eqm_equipment_tbl as eqpp on (mp.id_point = eqpp.id) 
    left join 
    (
      select distinct h.id_client,i.id_meter, h.mmgg
      from acm_headindication_tbl as h 
      join acd_indication_tbl as i on (h.id_doc =i.id_doc)  
      where idk_document = 310 and h.mmgg = vcur_mmgg  
      and i.value is not null and i.value <>0 and i.value_dem <>0    
    ) as ind on (ind.id_meter = m.code_eqp)
    where     book=-1 and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) 
    and ind.id_meter is null;

   vcur_mmgg:=vcur_mmgg-''1 month''::interval;

  LOOP

    raise notice '' rep_noindicnt %'',vcur_mmgg;

    insert into rep_noindic_mmgg_tbl(id_client,id_meter,id_point,num_meter,point_name,mmgg) 
    select distinct c.id, eq.id, eqpp.id, eq.num_eqp, eqpp.name_eqp, vcur_mmgg
    from eqm_tree_tbl as tr  
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)  
    join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id)  
    join eqm_meter_tbl as m on (m.code_eqp = eq.id)  
    join eqi_meter_tbl as im on (im.id = m.id_type_eqp)  
    left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id)  
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))  
    left join clm_statecl_tbl as sc on (c.id = sc.id_client)  
    left join eqm_meter_point_h as mp on (mp.id_meter = eq.id and mp.dt_e is null) 
    left join eqm_point_tbl as pp on (pp.code_eqp = mp.id_point ) 
    left join eqm_equipment_tbl as eqpp on (mp.id_point = eqpp.id) 
    left join rep_noindic_mmgg_tbl as rr on (rr.id_client = c.id and rr.id_meter = eq.id and rr.num_meter = eq.num_eqp and rr.mmgg = vcur_mmgg + ''1 month''::interval )
    left join 
    (
     select distinct h.id_client,i.id_meter, h.mmgg
     from acm_headindication_tbl as h 
     join acd_indication_tbl as i on (h.id_doc =i.id_doc)  
     where idk_document = 310 and h.mmgg = vcur_mmgg  
     and i.value is not null and i.value <>0 and i.value_dem <>0    
    ) as ind on (ind.id_meter = m.code_eqp)
    where     book=-1 and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) 
    and ind.id_meter is null and rr.id_client is not null;

       vcur_mmgg:=vcur_mmgg-''1 month''::interval;

       EXIT WHEN ( vcur_mmgg <''2010-01-01'' );   

   END LOOP;

   return 0;

  end;'                                                                                           
  LANGUAGE 'plpgsql';          