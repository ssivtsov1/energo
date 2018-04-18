/*
CREATE TABLE rep_meter_indic_hist_tbl (
    id_client        int,
    id_point         int,
    id_meter         int,
    num_eqp          character varying(25),
    kind_energy      int,
    type_eqp         int,
    work_type        int,
    work_name        varchar(50),
    id_doc           int, 
    id_position      int,
    reg_date         date, 
    value1           numeric(14,4), 
    value2           numeric(14,4), 
    value3           numeric(14,4), 
    zone1            int, 
    zone2            int, 
    zone3            int 
);		

*/
CREATE or replace FUNCTION rep_meter_indic_hist_fun (date,date)
  RETURNS int
  AS                                                                                              
  '
  declare
  pdtb Alias for $1;    
  pdte Alias for $2;    

  r record;

begin

 delete from rep_meter_indic_hist_tmp;

   --нулевая зона
   insert into rep_meter_indic_hist_tmp (reg_date,id_client,id_point,id_meter,num_eqp,kind_energy,type_eqp,work_type,work_name,id_doc,id_position,zone1,value1)
   select i.dt_insp as reg_date ,i.id_client,i.id_point,i.id_meter,i.num_eqp, i.kind_energy , i.type_eqp, -1 as work_type,''Обход'' as work_name, i.id_doc, h.id_position,i.zone,i.value 
   from 
    ( select * from acm_inspectstr_tbl where value is not null and dt_insp >= pdtb and dt_insp <= pdte and zone = 0 order by id_doc) as i 
    join (select * from acm_inspecth_tbl  order by id_doc ) as h 
    on (h.id_doc = i.id_doc) 
   union 
    select w.dt_work,w.id_client, i.id_point, i.id_meter, i.num_eqp, i.kind_energy, i.id_type, w.id_type,wi.name, i.id_work, w.id_position,i.id_zone,i.value
     from ( select * from clm_work_indications_tbl where value is not null and id_zone = 0 order by id_work )as i 
     join ( select * from clm_works_tbl where  dt_work >= pdtb and dt_work <= pdte  order by id ) as w on (w.id = i.id_work) 
     join cli_works_tbl as wi on (wi.id = w.id_type) 
     join eqi_meter_tbl as im on (im.id = i.id_type) 
   union
   select h.date_end, h.id_client,mp.id_point, ind.id_meter,ind.num_eqp, ind.kind_energy , ind.id_typemet, h.idk_document,dci.name, h.id_doc, null ,ind.id_zone, ind.value
    from 
   (select id_doc, idk_document, id_client, date_end  from acm_headindication_tbl where  date_end >= pdtb and date_end <= pdte  order by id_doc  ) as h 
   join 
   (select id_doc,id_meter, num_eqp, kind_energy, id_zone, value, coef_comp , id_typemet from acd_indication_tbl 
      where dat_ind >= pdtb and dat_ind <= pdte and id_zone = 0 order by id_doc) as ind
   on (ind.id_doc = h.id_doc) 
   join dci_document_tbl as dci on (dci.id = h.idk_document)
   left join eqm_meter_point_h as mp on (mp.id_meter = ind.id_meter and mp.dt_e is null); 


   -- ночь (2 и 3 зонная)
   insert into rep_meter_indic_hist_tmp (reg_date,id_client,id_point,id_meter,num_eqp,kind_energy,type_eqp,work_type,work_name,id_doc,id_position,zone1,value1)
   select i.dt_insp as reg_date ,i.id_client,i.id_point,i.id_meter,i.num_eqp, i.kind_energy , i.type_eqp, -1 as work_type,''Обход'' as work_name, i.id_doc, h.id_position,i.zone,i.value 
   from 
    ( select * from acm_inspectstr_tbl where value is not null and dt_insp >= pdtb and dt_insp <= pdte and zone in (1,4) order by id_doc) as i 
    join (select * from acm_inspecth_tbl  order by id_doc ) as h 
    on (h.id_doc = i.id_doc) 
   union 
    select w.dt_work,w.id_client, i.id_point, i.id_meter, i.num_eqp, i.kind_energy, i.id_type, w.id_type,wi.name, i.id_work, w.id_position,i.id_zone,i.value
     from ( select * from clm_work_indications_tbl where value is not null and id_zone in (1,4) order by id_work )as i 
     join ( select * from clm_works_tbl where  dt_work >= pdtb and dt_work <= pdte  order by id ) as w on (w.id = i.id_work) 
     join cli_works_tbl as wi on (wi.id = w.id_type) 
     join eqi_meter_tbl as im on (im.id = i.id_type) 
   union
   select h.date_end, h.id_client,mp.id_point, ind.id_meter,ind.num_eqp, ind.kind_energy , ind.id_typemet, h.idk_document,dci.name, h.id_doc, null ,ind.id_zone, ind.value
    from 
   (select id_doc, idk_document, id_client, date_end  from acm_headindication_tbl where  date_end >= pdtb and date_end <= pdte  order by id_doc  ) as h 
   join 
   (select id_doc,id_meter, num_eqp, kind_energy, id_zone, value, coef_comp , id_typemet from acd_indication_tbl 
      where dat_ind >= pdtb and dat_ind <= pdte and id_zone in (1,4) order by id_doc) as ind
   on (ind.id_doc = h.id_doc) 
   join dci_document_tbl as dci on (dci.id = h.idk_document)
   left join eqm_meter_point_h as mp on (mp.id_meter = ind.id_meter and mp.dt_e is null); 


  -- день 2зон и полупик 3зон
--   update rep_meter_indic_hist_tmp set zone2 = sss.zone, value2 = sss.value from 
--  ( 
   insert into rep_meter_indic_hist_tmp (reg_date,id_client,id_point,id_meter,num_eqp,kind_energy,type_eqp,work_type,work_name,id_doc,id_position,zone2,value2)
   select i.dt_insp as reg_date ,i.id_client,i.id_point,i.id_meter,i.num_eqp, i.kind_energy , i.type_eqp, -1 as work_type,''Обход'' as work_name, i.id_doc, h.id_position,i.zone,i.value 
   from 
    ( select * from acm_inspectstr_tbl where value is not null and dt_insp >= pdtb and dt_insp <= pdte and zone in (2,5) order by id_doc) as i 
    join (select * from acm_inspecth_tbl  order by id_doc ) as h 
    on (h.id_doc = i.id_doc) 
   union 
    select w.dt_work,w.id_client, i.id_point, i.id_meter, i.num_eqp, i.kind_energy, i.id_type, w.id_type,wi.name, i.id_work, w.id_position,i.id_zone,i.value
     from ( select * from clm_work_indications_tbl where value is not null and id_zone in (2,5) order by id_work )as i 
     join ( select * from clm_works_tbl where  dt_work >= pdtb and dt_work <= pdte  order by id ) as w on (w.id = i.id_work) 
     join cli_works_tbl as wi on (wi.id = w.id_type) 
     join eqi_meter_tbl as im on (im.id = i.id_type) 
   union
   select h.date_end, h.id_client,mp.id_point, ind.id_meter,ind.num_eqp, ind.kind_energy , ind.id_typemet, h.idk_document,dci.name, h.id_doc, null ,ind.id_zone, ind.value
    from 
   (select id_doc, idk_document, id_client, date_end  from acm_headindication_tbl where  date_end >= pdtb and date_end <= pdte  order by id_doc  ) as h 
   join 
   (select id_doc,id_meter, num_eqp, kind_energy, id_zone, value, coef_comp , id_typemet from acd_indication_tbl 
      where dat_ind >= pdtb and dat_ind <= pdte and id_zone in (2,5) order by id_doc) as ind
   on (ind.id_doc = h.id_doc) 
   join dci_document_tbl as dci on (dci.id = h.idk_document)
   left join eqm_meter_point_h as mp on (mp.id_meter = ind.id_meter and mp.dt_e is null);
--  ) as sss 
--  where 
--   rep_meter_indic_hist_tmp.reg_date = sss.reg_date and rep_meter_indic_hist_tmp.id_meter = sss.id_meter and rep_meter_indic_hist_tmp.kind_energy = sss.kind_energy 
--   and rep_meter_indic_hist_tmp.work_type = sss.work_type  and rep_meter_indic_hist_tmp.id_doc = sss.id_doc and rep_meter_indic_hist_tmp.num_eqp = sss.num_eqp;

  -- пик 3зон
--   update rep_meter_indic_hist_tmp set zone3 = sss.zone, value3 = sss.value from 
--  ( 
   insert into rep_meter_indic_hist_tmp (reg_date,id_client,id_point,id_meter,num_eqp,kind_energy,type_eqp,work_type,work_name,id_doc,id_position,zone3,value3)
   select i.dt_insp as reg_date ,i.id_client,i.id_point,i.id_meter,i.num_eqp, i.kind_energy , i.type_eqp, -1 as work_type,''Обход'' as work_name, i.id_doc, h.id_position,i.zone,i.value 
   from 
    ( select * from acm_inspectstr_tbl where value is not null and dt_insp >= pdtb and dt_insp <= pdte and zone =3 order by id_doc) as i 
    join (select * from acm_inspecth_tbl  order by id_doc ) as h 
    on (h.id_doc = i.id_doc) 
   union 
    select w.dt_work,w.id_client, i.id_point, i.id_meter, i.num_eqp, i.kind_energy, i.id_type, w.id_type,wi.name, i.id_work, w.id_position,i.id_zone,i.value
     from ( select * from clm_work_indications_tbl where value is not null and id_zone =3 order by id_work )as i 
     join ( select * from clm_works_tbl where  dt_work >= pdtb and dt_work <= pdte  order by id ) as w on (w.id = i.id_work) 
     join cli_works_tbl as wi on (wi.id = w.id_type) 
     join eqi_meter_tbl as im on (im.id = i.id_type) 
   union
   select h.date_end, h.id_client,mp.id_point, ind.id_meter,ind.num_eqp, ind.kind_energy , ind.id_typemet, h.idk_document,dci.name, h.id_doc, null ,ind.id_zone, ind.value
    from 
   (select id_doc, idk_document, id_client, date_end  from acm_headindication_tbl where  date_end >= pdtb and date_end <= pdte  order by id_doc  ) as h 
   join 
   (select id_doc,id_meter, num_eqp, kind_energy, id_zone, value, coef_comp , id_typemet from acd_indication_tbl 
      where dat_ind >= pdtb and dat_ind <= pdte and id_zone = 3 order by id_doc) as ind
   on (ind.id_doc = h.id_doc) 
   join dci_document_tbl as dci on (dci.id = h.idk_document)
   left join eqm_meter_point_h as mp on (mp.id_meter = ind.id_meter and mp.dt_e is null);
--  ) as sss 
--  where 
--   rep_meter_indic_hist_tmp.reg_date = sss.reg_date and rep_meter_indic_hist_tmp.id_meter = sss.id_meter and rep_meter_indic_hist_tmp.kind_energy = sss.kind_energy 
--   and rep_meter_indic_hist_tmp.work_type = sss.work_type  and rep_meter_indic_hist_tmp.id_doc = sss.id_doc and rep_meter_indic_hist_tmp.num_eqp = sss.num_eqp;

 RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          


