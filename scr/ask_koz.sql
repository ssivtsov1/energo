-- Function: load_askue_hour(character varying)

-- DROP FUNCTION load_askue_hour(character varying);
;

CREATE OR REPLACE FUNCTION load_askue_hour(character varying)
  RETURNS boolean AS
$BODY$
  declare
pid_file alias for $1;
  rec record;
  SSQL text;
  fil text;
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
  path='/home/local/replicat/in/askue/';     
     fil=path||pid_file;   
    delete from  load_hour_tmp where id_file=pid_file;
   skod_res=getsysvar('id_res');
   SSQL=' copy load_hour_tmp   from '||quote_literal(fil)|| '  with delimiter as '':'' null as ''''';
   raise notice 'SQL % ',SSQL;
   Execute  SSQL;

 /*
copy load_hour_tmp 
         from '/home/local/replicat/in/askue/askue_hour.txt' 
      with delimiter as ':' null as '';
*/
update load_hour_tmp set id_file=pid_file where id_file is null;
cou_h=0;     
delete from ask_demand_tbl where id_file=pid_file;
while cou_h<=49 loop 
 SSQL='insert into ask_demand_tbl (id_file ,num_meter,kind_energy,date_ind,id_time,demand)
      select id_file,substr(btrim(num,''()''),1,length(btrim(num,''()'')) -1 ),
       case when substr(btrim(num,''()''),length(btrim(num,''()'')))=''3'' then ''2'' else case when substr(btrim(num,''()''),length(btrim(num,''()'')))=''2'' then ''3'' else to_number(substr(btrim(num,''()''),length(btrim(num,''()''))),''9'') end  end 
        ,to_date(substr(id_file,5,6),''ddmmyy''),'||cou_h||',to_number(replace(h_'||cou_h||','','',''.''),''99999999.99999'') from load_hour_tmp where id_file='||quote_literal(pid_file);
-- raise notice 'SSQL %',SSQL;
 Execute SSQL;
 cou_h=cou_h+1;
end loop;

   raise notice 'pid_file  %',pid_file;
  update ask_demand_tbl set id_meter= e.id from eqm_equipment_tbl e 
     where e.type_eqp=1 and num_meter=num_eqp and id_file=pid_file;

  update ask_demand_tbl set stime=t.strtime from cmi_time_tbl t where t.id=id_time and id_file=pid_file;
  
   update  ask_demand_tbl set id_client=m.id_client
   from eqv_pnt_met m where m.id_meter=ask_demand_tbl.id_meter and id_file=pid_file;

   update  ask_demand_tbl set id_client=m.id_client
   from eqv_pnt_met m where m.id_client<>skod_res
   and m.id_meter=ask_demand_tbl.id_meter and id_file=pid_file;

   raise notice 'pid_file  end %',pid_file;
--return 0;
select into recfound distinct to_date(substr(id_file,5,6),'ddmmyy'),('ask_'||substr(id_file,5,6))::varchar(30),
   700,m.id_client,pid_file,bom(to_date(substr(id_file,5,6),'ddmmyy')),t.night_day 
   from ask_demand_tbl a ,eqv_pnt_met m,cmi_time_tbl t 
  where t.id=a.id_time and m.id_meter=a.id_meter and a.id_file=pid_file;
if found then 

delete from acm_headpowerindication_tbl where id_file=pid_file;
 cou_h=1;     
while cou_h<=2 loop 
  raise notice 'cou_h %',cou_h;
 insert into acm_headpowerindication_tbl (reg_date,reg_num,idk_document,id_client,id_file,mmgg,night_day)
   select distinct to_date(substr(id_file,5,6),'ddmmyy'),('ask_'||substr(id_file,5,6))::varchar(30),
   700,m.id_client,pid_file,bom(to_date(substr(id_file,5,6),'ddmmyy')),t.night_day 
   from ask_demand_tbl a ,eqv_pnt_met m,cmi_time_tbl t 
   where m.id_meter=a.id_meter and a.id_file=pid_file and t.id=a.id_time 
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
  where h.id_file=a.id_file and h.id_client=a.id_client and  
  a.kind_energy=1    and t.id=a.id_time  and t.night_day=cou_h   and h.night_day=t.night_day
 and tt.id_time=t.id and a.id_time=tt.id_time and tt.mmgg=bom(to_date(substr(a.id_file,5,6),'ddMMYY') ) 
  and a.id_file=pid_file and id_meter is not null;
-- select * from ask_demand_tbl
 cou_h=cou_h+1;
end loop;
   raise notice 'update   acd_powerindication_tbl set carry=carry_met';
 update   acd_powerindication_tbl set carry=carry_met,k_ts=koef_tt,k_tr=koef_tu,value_dev=value_dem/(coalesce(koef_tt,1)*coalesce(koef_tu,1))  
 from eqv_pnt_met m where m.id_meter=acd_powerindication_tbl.id_meter and carry is null;

   raise notice 'update   acd_powerindication_tbl set id_area';
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



update acd_billsum_tbl set id_area=0 	where id_area is null;

for rec in select distinct id_doc,id_client,mmgg from acm_headpowerindication_tbl where id_file=pid_file loop
--  cou_h=crt_pwr2krbill(rec.id_client, rec.id_doc,rec.mmgg);
end loop;

end if; 


for dt_indic in select date_rej from ask_regday_tbl rd, (select distinct date_ind from ask_demand_tbl where id_file=pid_file) dd where dd.date_ind=rd.date_rej    loop
ret=load_regim(dt_indic);

end loop;

RETURN true;

end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION load_askue_hour(character varying)
  OWNER TO local;



CREATE OR REPLACE FUNCTION load_askue_day(character varying)
  RETURNS boolean AS
$BODY$
  declare
  pid_file alias for $1;
  fil text;
  rec record;
  SQL text;
  path text;
  res bool;
  pnum_met varchar(25);
  penergy int;
  pzone int;
  skod_res int;
begin  
   path='/home/local/replicat/in/askue/';          
   fil=path||pid_file;
   delete from  load_demand_tmp where id_file=pid_file;
   skod_res=getsysvar('id_res');

   BEGIN
   SQL=' copy load_demand_tmp   from '||quote_literal(fil)|| '  with delimiter as '':'' null as ''''';
   raise notice 'SQL % ',SQL;
   Execute  SQL;
   /*EXCEPTION WHEN OTHERS THEN
   copy load_demand_tmp (num, d_0, d_1, d_2, d_3)
         from '/home/local/replicat/in/askue/askue_day.txt' 
         with delimiter as ':' null as '';*/
   END;

   raise notice 'delete ';
   delete from ask_indic_tbl where id_file=pid_file;

   raise notice 'update ';
 update load_demand_tmp set id_file=pid_file where id_file is null;
 --for rec in select * from load_demand_tmp where id_file=pid_file loop
 -- pnum_met=rtrim(btrim(rec.num,'()'),'1234');
 -- penergy =substr(btrim(rec.num,'()'),length(btrim(rec.num,'()')));

   raise notice 'insert 1 ';
   insert into   ask_indic_tbl ( id_file ,num_meter,kind_energy,  id_zone, date_ind ,  id_time ,  indic )
      select id_file,substr(btrim(num,'()'),1,length(btrim(num,'()')) -1 ),--rtrim(btrim(num,'()'),'1234'),
       case when substr(btrim(num,'()'),length(btrim(num,'()')))='3' then '2' else case when substr(btrim(num,'()'),length(btrim(num,'()')))='2' then '3' else to_number(substr(btrim(num,'()'),length(btrim(num,'()'))),'9') end  end 
       ,0,to_date(substr(id_file,5,6),'ddmmyy'),0,to_number(replace(d_0,',','.'),'99999999999.99999') from load_demand_tmp where id_file=pid_file;
-- pick
   raise notice 'insert 2';
   insert into   ask_indic_tbl ( id_file ,num_meter,kind_energy,  id_zone, date_ind ,  id_time ,   indic )
     select id_file,substr(btrim(num,'()'),1,length(btrim(num,'()')) -1 ),--rtrim(btrim(num,'()'),'1234'),
        case when substr(btrim(num,'()'),length(btrim(num,'()')))='3' then '2' else case when substr(btrim(num,'()'),length(btrim(num,'()')))='2' then '3' else to_number(substr(btrim(num,'()'),length(btrim(num,'()'))),'9') end  end      
,3,to_date(substr(id_file,5,6),'ddmmyy'),0,to_number(replace(d_1,',','.'),'99999999999.99999') from load_demand_tmp where id_file=pid_file;
--half-pick
   raise notice 'insert 3';
   insert into   ask_indic_tbl ( id_file ,num_meter,kind_energy,  id_zone, date_ind ,  id_time ,   indic )
      select id_file,substr(btrim(num,'()'),1,length(btrim(num,'()')) -1 ),--rtrim(btrim(num,'()'),'1234'),
           case when substr(btrim(num,'()'),length(btrim(num,'()')))='3' then '2' else case when substr(btrim(num,'()'),length(btrim(num,'()')))='2' then '3' else to_number(substr(btrim(num,'()'),length(btrim(num,'()'))),'9') end  end   
  ,2,to_date(substr(id_file,5,6),'ddmmyy'),0,to_number(replace(d_2,',','.'),'99999999999.99999') from load_demand_tmp where id_file=pid_file;
--night 
   raise notice 'insert 4';
  insert into   ask_indic_tbl ( id_file ,num_meter,kind_energy,  id_zone, date_ind ,  id_time ,   indic )
      select id_file,substr(btrim(num,'()'),1,length(btrim(num,'()')) -1 ),--rtrim(btrim(num,'()'),'1234'),
       case when substr(btrim(num,'()'),length(btrim(num,'()')))='3' then '2' else case when substr(btrim(num,'()'),length(btrim(num,'()')))='2' then '3' else to_number(substr(btrim(num,'()'),length(btrim(num,'()'))),'9') end  end 
        ,1,to_date(substr(id_file,5,6),'ddmmyy'),0,to_number(replace(d_3,',','.'),'99999999999.99999') from load_demand_tmp where id_file=pid_file;


   raise notice 'update id_meter';
  update ask_indic_tbl set id_meter= e.id from eqm_equipment_tbl e 
    where type_eqp=1 and num_meter=num_eqp and id_file=pid_file;

 raise notice 'update strtime';
 update ask_indic_tbl set stime=strtime from cmi_time_tbl t where t.id=id_time and id_file=pid_file;
 raise notice 'update id_client';
 update  ask_indic_tbl set id_client=m.id_client
   from eqv_pnt_met m where m.id_meter=ask_indic_tbl.id_meter and id_file=pid_file;

   raise notice 'update id_client 2';
 update  ask_indic_tbl set id_client=m.id_client
   from eqv_pnt_met m where  m.id_client<>skod_res 
   and m.id_meter=ask_indic_tbl.id_meter and id_file=pid_file;

   raise notice 'update id_askue';
update acd_indication_tbl set id_askue=a.id   from ask_indic_tbl a
 where acd_indication_tbl.id_meter=a.id_meter and  acd_indication_tbl.num_eqp=a.num_meter
    and acd_indication_tbl.kind_energy=a.kind_energy and acd_indication_tbl.id_zone=a.id_zone
    and a.id_time=0 and acd_indication_tbl.dat_ind=a.date_ind and a.id_file=pid_file;

   raise notice 'update value in indication';
update acd_indication_tbl set value=a.indic,
        id_askue=a.id  
  from ask_indic_tbl a,acd_indication_tbl a1
 where acd_indication_tbl.id_meter=a.id_meter 
       and acd_indication_tbl.id_previndic=a1.id 
       and  acd_indication_tbl.num_eqp=a.num_meter
    and acd_indication_tbl.kind_energy=a.kind_energy and acd_indication_tbl.id_zone=a.id_zone
    and a.id_time=0 and acd_indication_tbl.dat_ind=a.date_ind and 
     acd_indication_tbl.id_client=a.id_client and acd_indication_tbl.value is null
   and a.id_file=pid_file;


   raise notice 'update value in indication 2';
update acd_indication_tbl set value=a.indic,
 id_askue=a.id  
  from ask_indic_tbl a
 where acd_indication_tbl.id_meter=a.id_meter 
       and  acd_indication_tbl.num_eqp=a.num_meter
    and acd_indication_tbl.kind_energy=a.kind_energy and acd_indication_tbl.id_zone=a.id_zone
    and a.id_time=0 and acd_indication_tbl.dat_ind=a.date_ind and 
     acd_indication_tbl.id_client=a.id_client and acd_indication_tbl.value is null
   and a.id_file=pid_file;
   raise notice 'update value_dev in indication';

update acd_indication_tbl 
  set value_dev=calc_ind_pr(coalesce(acd_indication_tbl.value,0),coalesce(a1.value,0),acd_indication_tbl.carry),  
      value_dem=calc_ind_pr(coalesce(acd_indication_tbl.value,0),coalesce(a1.value,0),acd_indication_tbl.carry)*acd_indication_tbl.coef_comp
  from    ask_indic_tbl a,
          acd_indication_tbl a1
  where     
    acd_indication_tbl.id_meter=a.id_meter 
       and  acd_indication_tbl.num_eqp=a.num_meter
    and acd_indication_tbl.kind_energy=a.kind_energy and acd_indication_tbl.id_zone=a.id_zone
    and a.id_time=0 and acd_indication_tbl.dat_ind=a.date_ind and 
     acd_indication_tbl.id_client=a.id_client and acd_indication_tbl.value is null
   and a.id_file=pid_file and    acd_indication_tbl.id_previndic=a1.id 
     AND acd_indication_tbl.value_dev is null
     and  acd_indication_tbl.value is  not null
     and calc_ind_pr(coalesce(acd_indication_tbl.value,0),coalesce(a1.value,0),acd_indication_tbl.carry)*acd_indication_tbl.coef_comp<100000000
;





--end loop;

  RETURN true;

end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION load_askue_day(character varying)
  OWNER TO local;
