
update ask_demand_tbl set stime=strtime from cmi_time_tbl t where t.id=id_time  and stime is null and date_ind>'2017-10-01' and date_ind<='2017-10-31';



update acd_powerindication_tbl set time_indic=t.timest from
(select distinct p.id,r.timest from acd_powerindication_tbl p, 
  (select h.id_doc,a.id_meter,a.num_meter,1,0,h.id_client,  to_timestamp(to_date(substr(a.id_file,5,6),'ddMMYY')|| ' '|| stime::time,'YYYY-MM-DD hh24:mi') as timest,
   t.night_day,demand,bom(to_date(substr(a.id_file,5,6),'ddMMYY') )  
  from ask_demand_tbl a, acm_headpowerindication_tbl h,acd_powerindication_tbl p, ask_picktime_tbl tt,cmi_time_tbl t 
  where h.id_file=a.id_file and h.id_client=a.id_client and  p.mmgg='2017-10-01' and p.time_indic is null and p.id_doc=h.id_doc and
  a.kind_energy=1    and t.id=a.id_time  and t.night_day=1   and h.night_day=t.night_day
 and tt.id_time=t.id and a.id_time=tt.id_time and tt.mmgg=bom(to_date(substr(a.id_file,5,6),'ddMMYY') ) 
  and a.id_file=h.id_file and a.id_meter is not null and a.demand>0) r where r.id_doc=p.id_doc and r.id_meter=p.id_meter and r.num_meter=p.num_eqp and p.value_dem=r.demand
) t where t.id=acd_powerindication_tbl.id and acd_powerindication_tbl.time_indic is null;




update acd_powerindication_tbl set time_indic=t.timest from
(
select distinct p.id,r.timest from acd_powerindication_tbl p, 
  (select h.id_doc,a.id_meter,a.num_meter,1,0,h.id_client,  to_timestamp(to_date(substr(a.id_file,5,6),'ddMMYY')|| ' '|| stime::time,'YYYY-MM-DD hh24:mi') as timest,
   t.night_day,demand,bom(to_date(substr(a.id_file,5,6),'ddMMYY') )  
  from ask_demand_tbl a, acm_headpowerindication_tbl h,acd_powerindication_tbl p, ask_picktime_tbl tt,cmi_time_tbl t 
  where h.id_file=a.id_file and h.id_client=a.id_client and  p.mmgg='2017-10-01' and p.time_indic is null and p.id_doc=h.id_doc and
  a.kind_energy=1    and t.id=a.id_time  and t.night_day=2   and h.night_day=t.night_day
 and tt.id_time=t.id and a.id_time=tt.id_time and tt.mmgg=bom(to_date(substr(a.id_file,5,6),'ddMMYY') ) 
  and a.id_file=h.id_file and a.id_meter is not null and a.demand>0) r where r.id_doc=p.id_doc and r.id_meter=p.id_meter and r.num_meter=p.num_eqp and p.value_dem=r.demand
) t where t.id=acd_powerindication_tbl.id and acd_powerindication_tbl.time_indic is null;



update acd_powerindication_tbl set id_area=coalesce(a.code_eqp_inst,0) 
 from (select distinct e.name_eqp,e.type_eqp,h.code_eqp,h.code_eqp_inst,h.dt_b,h.dt_e,ev.id_meter
           from eqm_compens_station_inst_h h left join eqm_area_tbl a on a.code_eqp= h.code_eqp_inst,
               eqm_equipment_tbl e,acd_powerindication_tbl bs,eqv_pnt_met ev  
               where bs.id_area is null and ev.id_meter=bs.id_meter and ev.id_point=h.code_eqp and  
              bs.time_indic::date>=h.dt_b
             and bs.time_indic::date<=coalesce(h.dt_e,bs.time_indic::date) and
             e.id=a.code_eqp and type_eqp=11
      ) a 
where acd_powerindication_tbl.id_area is null and acd_powerindication_tbl.id_meter=a.id_meter and  acd_powerindication_tbl.mmgg='2017-10-01';



