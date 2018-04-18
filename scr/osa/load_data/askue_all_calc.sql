;;
CREATE  or replace FUNCTION load_askue_hour_all()                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
$BODY$
  declare
recfile record;
ret bool;
begin
for  recfile in select distinct id_file from ask_demand_tbl where date_ind>='2016-01-01' loop
ret=load_reaskue_hour(recfile.id_file);
end loop;
return true;
end;
$BODY$                                                                                          
LANGUAGE 'plpgsql';  



CREATE  or replace FUNCTION load_reaskue_hour(varchar)                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
$BODY$
  declare
pid_file alias for $1;
  rec record;
  SSQL text;
  path text;
  res bool;
  dt_indic date;
  pnum_met varchar(25);
  penergy int;
  pzone int;
  cou_h int;
  iddc int;
  skod_res int;
  ret boolean;
  recfound record;
begin  
   raise notice 'pid_file  %',pid_file;
  update ask_demand_tbl set id_meter= e.id from eqm_equipment_tbl e 
     where e.type_eqp=1 and num_meter=num_eqp and id_file=pid_file;
  update ask_demand_tbl set stime=t.strtime from cmi_time_tbl t where t.id=id_time and id_file=pid_file;
  
   update  ask_demand_tbl set id_client=m.id_client
   from eqv_pnt_met m where m.id_meter=ask_demand_tbl.id_meter and id_file=pid_file;

   update  ask_demand_tbl set id_client=m.id_client
   from eqv_pnt_met m where m.id_client<>skod_res
   and m.id_meter=ask_demand_tbl.id_meter and id_file=pid_file;



--return 0;
for recfound in select distinct to_date(substr(id_file,5,6),'ddmmyy'),('ask_'||substr(id_file,5,6))::varchar(30),
   700,m.id_client,pid_file,bom(to_date(substr(id_file,5,6),'ddmmyy')),t.night_day 
   from ask_demand_tbl a ,eqv_pnt_met m,cmi_time_tbl t 
  where t.id=a.id_time and m.id_meter=a.id_meter and a.id_file=pid_file loop
  
 raise notice 'start insert acm_headpowerindication_tbl';
--if found then 
 raise notice 'found insert acm_headpowerindication_tbl';
delete from acm_headpowerindication_tbl where id_file=pid_file and night_day=recfound.night_day and id_client=recfound.id_client;

 cou_h= recfound.night_day;
-- cou_h=1;     
--while cou_h<=2 loop 
  raise notice 'cou_h %',cou_h;
 insert into acm_headpowerindication_tbl (reg_date,reg_num,idk_document,id_client,id_file,mmgg,night_day)
   select distinct to_date(substr(id_file,5,6),'ddmmyy'),('ask_'||substr(id_file,5,6))::varchar(30),
   700,m.id_client,pid_file,bom(to_date(substr(id_file,5,6),'ddmmyy')),t.night_day 
   from ask_demand_tbl a ,eqv_pnt_met m,cmi_time_tbl t 
   where a.id_client=recfound.id_client and m.id_meter=a.id_meter and a.id_file=pid_file and t.id=a.id_time 
   and t.night_day=cou_h;
 --and a.id_file='310_010514_30917.txt'; 
 iddc:=currval('dcm_doc_seq');
--update acm_headpowerindication_tbl set id_file=pid_file where id_file is null;
raise notice 'ins_power';
 insert into acd_powerindication_tbl (id_doc,id_meter,num_eqp,kind_energy,id_zone,id_client,
  time_indic,night_day,value_dem,mmgg)
  select h.id_doc,id_meter,num_meter,1,0,h.id_client,  to_timestamp(to_date(substr(a.id_file,5,6),'ddMMYY')|| ' '|| stime::time,'YYYY-MM-DD hh24:mi'),
   t.night_day,demand,bom(to_date(substr(a.id_file,5,6),'ddMMYY') )  
  from ask_demand_tbl a, acm_headpowerindication_tbl h,ask_picktime_tbl tt,cmi_time_tbl t 
  where h.id_file=a.id_file and h.id_client=a.id_client  and h.id_client=recfound.id_client and a.id_client=recfound.id_client and 
  a.kind_energy=1 
  and t.id=a.id_time  and t.night_day=cou_h and h.night_day=cou_h 
 and tt.id_time=t.id and a.id_time=tt.id_time and tt.mmgg=bom(to_date(substr(a.id_file,5,6),'ddMMYY') ) 
  and a.id_file=pid_file and id_meter is not null;
-- select * from ask_demand_tbl
-- cou_h=cou_h+1;
end loop;


 update   acd_powerindication_tbl set carry=carry_met,k_ts=koef_tt,k_tr=koef_tu,value_dev=value_dem/(coalesce(koef_tt,1)*coalesce(koef_tu,1))  
 from eqv_pnt_met m where m.id_meter=acd_powerindication_tbl.id_meter and carry is null;

raise notice 'start update';
update acd_powerindication_tbl set id_area=coalesce(a.code_eqp_inst,0) 
 from (select distinct e.name_eqp,e.type_eqp,h.code_eqp,h.code_eqp_inst,h.dt_b,h.dt_e,ev.id_meter
           from eqm_compens_station_inst_h h left join eqm_area_tbl a on a.code_eqp= h.code_eqp_inst,
               eqm_equipment_tbl e,acd_powerindication_tbl bs,eqv_pnt_met ev  
               where bs.id_area is null and ev.id_meter=bs.id_meter and ev.id_point=h.code_eqp and  
              bs.time_indic::date>=h.dt_b
             and bs.time_indic::date<=coalesce(h.dt_e,bs.time_indic::date) and
             e.id=a.code_eqp and type_eqp=11
      ) a 
where acd_powerindication_tbl.id_area is null and acd_powerindication_tbl.id_meter=a.id_meter;



raise notice 'start calc calc';
update acd_billsum_tbl set id_area=0 	where id_area is null;
/*
for rec in select distinct id_doc,id_client,mmgg from acm_headpowerindication_tbl where id_file=pid_file loop
  cou_h=crt_pwr2krbill(rec.id_client, rec.id_doc,rec.mmgg);
end loop;
*/
--end if; 


for dt_indic in select date_rej from ask_regday_tbl rd, (select distinct date_ind from ask_demand_tbl where id_file=pid_file) dd where dd.date_ind=rd.date_rej    loop
--ret=load_regim(dt_indic);

end loop;

RETURN true;

end;
$BODY$                                                                                          
LANGUAGE 'plpgsql';  




select crt_ttbl(); 
select  load_askue_hour_all(); 
