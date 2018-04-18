--set client_encoding='win';
;
create table cmi_time_tbl
( id int,
  strtime time,
  primary key (id)
 
);

alter table cmi_time_tbl add column pick_time int;
alter table cmi_time_tbl add column night_day int;

update cmi_time_tbl set night_day=1 where id<=24;
update cmi_time_tbl set night_day=2 where id>24;

alter table acd_indication_tbl add column id_askue int;
alter table acd_indication_del add column id_askue int;



/*
select * from acd_indication_tbl  where mmgg='2014-06-01'
select * from ask_indic_tbl

*/



--drop table ask_regim_tbl;

create sequence ask_regim_seq;
create table ask_regim_tbl
( id int default nextval('ask_regim_seq'),
  id_area int,
  id_client int,
  kind_energy int,
  date_ind date,
  night_day int,
  dt_b date,
  dt_e date, 
  all_demand numeric(15,5),
  avg_demand numeric(15,5),
  max_demand numeric(15,5),
  koef numeric(15,5),
  primary key (id)
);

--drop table ask_regday_tbl;
create sequence ask_regday_seq;
create table ask_regday_tbl
( id int default nextval('ask_regday_seq'),
  date_rej date,
  primary key (id)
);

insert into ask_regday_tbl values (1,'2014-06-18');

create table ask_regmonth_tbl
(  id int,
   kind int
);

insert into ask_regmonth_tbl values (1,0);
insert into ask_regmonth_tbl values (2,0);
insert into ask_regmonth_tbl values (3,0);
insert into ask_regmonth_tbl values (4,0);
insert into ask_regmonth_tbl values (5,1);
insert into ask_regmonth_tbl values (6,1);
insert into ask_regmonth_tbl values (7,1);
insert into ask_regmonth_tbl values (8,1);
insert into ask_regmonth_tbl values (9,1);
insert into ask_regmonth_tbl values (10,1);
insert into ask_regmonth_tbl values (11,0);
insert into ask_regmonth_tbl values (12,0);


--drop table ask_indic_tbl;
create sequence ask_indic_seq;
create table ask_indic_tbl
( id int default nextval('ask_indic_seq'),
  id_file varchar(20),
  id_meter int,
  num_meter varchar(25),
  id_client int,
  kind_energy int,
  id_zone int,
  date_ind date,
  id_time int,
  stime time,
  indic numeric(15,5),
  primary key (id)
);

alter table ask_indic_tbl add column id_area int;
CREATE INDEX ask_indic_file_idx
  ON ask_indic_tbl
  USING btree
  (id_file,num_meter,date_ind);

CREATE INDEX ask_indic_meter_idx
  ON ask_indic_tbl
  USING btree
  (num_meter,date_ind);

-- select * from ask_indic_tbl



--drop table ask_demand_tbl;
create sequence ask_demand_seq;
create table ask_demand_tbl
( id int default nextval('ask_demand_seq'),
  id_file varchar(20),
  id_meter int,
  id_client int,
  num_meter varchar(25),
  kind_energy int,
  date_ind date,
  id_time int,
  stime time,
  demand numeric(15,5),
 primary key (id)
);
alter table ask_demand_tbl add column id_area int;

CREATE INDEX ask_demand_file_idx
  ON ask_demand_tbl
  USING btree
  (id_file,num_meter,date_ind);

CREATE INDEX ask_demand_meter_idx
  ON ask_demand_tbl
  USING btree
  (num_meter,date_ind,id_time);




create sequence ask_picktime_seq;
create table ask_picktime_tbl
( id int default nextval('ask_picktime_seq'),
  mmgg date,
  id_time int,
  primary key (mmgg,id_time)
);


--drop table load_demand_tmp;
create table load_demand_tmp
(
  num varchar(12),
  d_0 varchar(12),
  d_1 varchar(12),
  d_2 varchar(12),
  d_3 varchar(12),
  id_file varchar(20)--,
 --primary key (num)
); 

CREATE INDEX load_day_file_idx
  ON load_day_tbl
  USING btree
  (id_file,num);



--drop table  load_hour_tmp;
create table load_hour_tmp
(
  num varchar(12),
  h_0 varchar(12),
  h_1 varchar(12),
  h_2 varchar(12),
  h_3 varchar(12),
  h_4 varchar(12),
  h_5 varchar(12),
  h_6 varchar(12),
  h_7 varchar(12),
  h_8 varchar(12),
  h_9 varchar(12),
  h_10 varchar(12),
  h_11 varchar(12),
  h_12 varchar(12),
  h_13 varchar(12),
  h_14 varchar(12),
  h_15 varchar(12),
  h_16 varchar(12),
  h_17 varchar(12),
  h_18 varchar(12),
  h_19 varchar(12),
  h_20 varchar(12),
  h_21 varchar(12),
  h_22 varchar(12),
  h_23 varchar(12),
  h_24 varchar(12),
  h_25 varchar(12),
  h_26 varchar(12),
  h_27 varchar(12),
  h_28 varchar(12),
  h_29 varchar(12),
  h_30 varchar(12),
  h_31 varchar(12),
  h_32 varchar(12),
  h_33 varchar(12),
  h_34 varchar(12),
  h_35 varchar(12),
  h_36 varchar(12),
  h_37 varchar(12),
  h_38 varchar(12),
  h_39 varchar(12),
  h_40 varchar(12),
  h_41 varchar(12),
  h_42 varchar(12),
  h_43 varchar(12),
  h_44 varchar(12),
  h_45 varchar(12),
  h_46 varchar(12),
  h_47 varchar(12),
  h_48 varchar(12),
  h_49 varchar(12),
 id_file varchar(20)--,
--primary key (num)
);
CREATE INDEX load_hour_file_idx
  ON load_hour_tbl
  USING btree
  (id_file,num);


--drop FUNCTION load_askue_day ();  

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
    where type_eqp=1 and num_meter=translate(trim(num_eqp),'[,._-=]','') and id_file=pid_file;

  update ask_indic_tbl set date_ind=date_ind+ interval '1 day'     where  id_file=pid_file;


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
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION load_askue_day(character varying)
  OWNER TO local;






--select * from acd_indication_tbl where mmgg='2014-07-01'
--select * from eqk_energy_tbl

--drop FUNCTION load_askue_hour();   

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
 /*2017-10-31*/
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
       case when substr(btrim(num,''()''),length(btrim(num,''()'')))=''3'' then 2 else case when substr(btrim(num,''()''),length(btrim(num,''()'')))=''2'' then 3 else to_number(substr(btrim(num,''()''),length(btrim(num,''()''))),''9'') end  end 
        ,to_date(substr(id_file,5,6),''ddmmyy''),'||cou_h||',to_number(replace(h_'||cou_h||','','',''.''),''99999999.99999'') from load_hour_tmp where id_file='||quote_literal(pid_file);
-- raise notice 'SSQL %',SSQL;
 Execute SSQL;
 cou_h=cou_h+1;
end loop;

   raise notice 'pid_file  %',pid_file;
 
  update ask_demand_tbl set id_meter= e.id from eqm_equipment_tbl e 
     where e.type_eqp=1 and num_meter=translate(trim(num_eqp),'[,._-=]','') and id_file=pid_file;

  update ask_demand_tbl set date_ind=date_ind+interval '1 day'    where  id_file=pid_file;

   update ask_demand_tbl set stime=strtime from cmi_time_tbl t where t.id=id_time and id_file=pid_file;
  
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

update acd_powerindication_tbl set id_area=coalesce(a.code_eqp_inst,0) 
 from (select distinct e.name_eqp,e.type_eqp,h.code_eqp,h.code_eqp_inst,h.dt_b,h.dt_e,ev.id_meter
           from eqm_compens_station_inst_h h left join eqm_area_tbl a on a.code_eqp= h.code_eqp_inst,
               eqm_equipment_tbl e,acd_powerindication_tbl bs,eqv_pnt_met ev  
               where bs.id_area is null and ev.id_meter=bs.id_meter and ev.id_point=h.code_eqp and  
            --  bs.time_indic::date>=h.dt_b
            -- and bs.time_indic::date<=coalesce(h.dt_e,bs.time_indic::date) and
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
     where e.type_eqp=1 and num_meter=translate(num_eqp,'[,._-=]','') and id_file=pid_file;
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


                                                                                                                      






--select * from ask_demand_tbl

CREATE  or replace FUNCTION load_regim(date)                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
$BODY$
  declare
  date_rej alias for $1;
  rec_area record;
begin  

update ask_demand_tbl set id_area=coalesce(a.code_eqp_inst,0) 
 from (
select distinct e.name_eqp,e.type_eqp,h.code_eqp,h.code_eqp_inst,h.dt_b,h.dt_e,ev.id_meter
           from eqm_compens_station_inst_h h left join eqm_area_tbl a on a.code_eqp= h.code_eqp_inst,
               eqm_equipment_tbl e,ask_demand_tbl bs,eqv_pnt_met ev  
               where bs.id_area is null and ev.id_meter=bs.id_meter and ev.id_point=h.code_eqp and  
              bs.date_ind>=h.dt_b
             and bs.date_ind<=coalesce(bs.date_ind) and
             e.id=a.code_eqp and type_eqp=11) a
where ask_demand_tbl.id_area is null and ask_demand_tbl.id_meter=a.id_meter;

delete from  ask_regim_tbl where  date_ind=date_rej;

insert into  ask_regim_tbl
( id_area ,  id_client,  kind_energy ,  date_ind ,  night_day ,  
  dt_b,  dt_e ,  
 all_demand ,  avg_demand ,  max_demand , koef )
 select id_area,id_client,kind_energy ,  date_rej ,  1, bom(date_rej),bom(date_rej)+ interval '4 month' - interval '1 day',
    sumdem,sumdem/24.00,-1,0
 from  ( select id_area,id_client,kind_energy,max(demand)*2 as maxdem,sum(demand) as sumdem 
         from   ask_demand_tbl d,cmi_time_tbl t where t.id=d.id_time and  date_ind=date_rej 
           --  and night_day=1
            and  id_time<>0 group by id_area,id_client,kind_energy ) a;


insert into  ask_regim_tbl
( id_area ,  id_client,  kind_energy ,  date_ind ,  night_day ,  
  dt_b,  dt_e ,  
 all_demand ,  avg_demand ,  max_demand , koef )
 select id_area,id_client,kind_energy ,  date_rej ,  2, bom(date_rej),bom(date_rej)+ interval '4 month' - interval '1 day',
    sumdem,sumdem/24.00,-1,0
 from  ( select id_area,id_client,kind_energy,max(demand)*2 as maxdem,sum(demand) as sumdem 
         from   ask_demand_tbl d,cmi_time_tbl t where t.id=d.id_time and  date_ind=date_rej 
       --      and night_day=2 
       and  id_time<>0 group by id_area,id_client,kind_energy ) a;

update ask_regim_tbl set max_demand=a.maxdem 
from
(  
        select id_area,id_client,kind_energy,t.night_day,max(demand)*2 as maxdem
         from   ask_demand_tbl d 
          join ask_picktime_tbl pt on d.id_time=pt.id_time 
           join cmi_time_tbl t on t.id=pt.id_time
          where  bom(date_ind)::date=pt.mmgg    
         and  pt.id_time<>0 
          group by id_area,id_client,kind_energy,night_day order by id_client
) a where ask_regim_tbl.id_area=a.id_area and ask_regim_tbl.id_client=a.id_client 
        and ask_regim_tbl.kind_energy=a.kind_energy and ask_regim_tbl.night_day=a.night_day 
and ask_regim_tbl.date_ind=date_rej;  

/*insert into  ask_regim_tbl
( id_area ,  id_client,  kind_energy ,  date_ind ,  night_day ,  
  dt_b,  dt_e ,  
 all_demand ,  avg_demand ,  max_demand , koef )
 select id_area,id_client,kind_energy ,  date_rej ,  2, bom(date_rej),bom(date_rej)+ interval '4 month' - interval '1 day',
    sumdem,sumdem/24.00,maxdem,0
 from  ( select id_area,id_client,kind_energy,max(demand) as maxdem,sum(demand) as sumdem 
        from  ask_demand_tbl d,cmi_time_tbl t where t.id=d.id_time    and night_day=2   and id_time<>0
        group by id_area,id_client,kind_energy ) a;
*/


update ask_regim_tbl set koef=avg_demand/max_demand where max_demand>0;
delete from ask_regim_tbl where kind_energy<>1;
for rec_area in select distinct id_client,id_area from ask_regim_tbl where   date_ind=date_rej loop  
  perform calc_askue_limit(rec_area.id_client,rec_area.id_area,date_rej);
end loop;
RETURN true;

end;
$BODY$                                                                                          
LANGUAGE 'plpgsql';  



--select crt_ttbl()
/*

select * from load_hour_tmp
select to_number('2.444','99999.99999' )

  select id_file,substr(btrim(num,'()'),1,length(btrim(num,'()')) -1 ),
       case when substr(btrim(num,'()'),length(btrim(num,'()')))=3 then 2 else case when substr(btrim(num,'()'),length(btrim(num,'()')))=2 then 3 else to_number(substr(btrim(num,'()'),length(btrim(num,'()'))),'9') end  end 
        ,to_date(substr(id_file,5,6),'ddmmyy'),46,to_number(replace(h_46,',','.'),'99999999.99999'),replace(h_46,',','.') from load_hour_tmp where id_file='310_020914_30917.txt'

select * from ask_demand_tbl where num_meter='31080' order by stime

select replace('433,4555',',','.')
--select load_askue_hour('310_020914_30917.txt')        
--select load_askue_day('310_020914_30818.txt') 
select to_timestamp('2014-05-23 10:30','YYYY-MM-DD hh24:mi') 


 select id_meter,num_meter,1,0,id_client, stime::time, 
 substr(id_file,5,6)|| ' '|| stime,to_timestamp(to_date(substr(id_file,5,6),'ddMMYY')|| ' '|| stime::time,'YYYY-MM-DD hh24:mi'),t.night_day,demand  
  from ask_demand_tbl a, cmi_time_tbl t  where a.id_time=t.id and id_meter is not null
select * from acd_powerindication_tbl
select * from acm_headpowerindication_tbl

select * from acd_powerindication_tbl order by id_meter


delete from acd_powerindication_tbl where dt>='2014-07-01';
delete from acm_headpowerindication_tbl where dt>='2014-07-01'

select * from ask_demand_tbl

select e.name_eqp,e.type_eqp,h.code_eqp,h.code_eqp_inst,h.dt_b,h.dt_e,ev.id_meter
           from eqm_compens_station_inst_h h left join eqm_area_tbl a on a.code_eqp= h.code_eqp_inst,
               eqm_equipment_tbl e,acd_powerindication_tbl bs,eqv_pnt_met ev  
               where bs.id_doc=iddc and ev.id_meter=bs.id_meter and ev.id_point=h.code_eqp and  
              bs.time_indic::date>=h.dt_b
             and bs.time_indic::date<=coalesce(h.dt_e,bs.time_indic::date) and
             e.id=a.code_eqp and type_eqp=11

*/
/*
     select id_file,num,rtrim(btrim(num,'()'),'1234'),substr(btrim(num,'()'),1,length(btrim(num,'()')) -1 ),
       case when substr(btrim(num,'()'),length(btrim(num,'()')))=3 then 2 else case when substr(btrim(num,'()'),length(btrim(num,'()')))=3 then 2 else to_number(substr(btrim(num,'()'),length(btrim(num,'()'))),'9') end  end 
        ,to_date(substr(id_file,5,6),'ddmmyy') from load_hour_tmp order by num

*/


   