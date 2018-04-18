alter table eqd_meter_zone_tbl drop constraint eqd_meter_zone_tbl_pkey;
alter table eqd_meter_zone_tbl add column kind_energy int ;

update eqd_meter_zone_tbl set kind_energy  = 
coalesce((select kind_energy from eqd_meter_energy_tbl where eqd_meter_energy_tbl.code_eqp =  eqd_meter_zone_tbl.code_eqp limit 1),1);

alter table eqd_meter_zone_tbl alter column kind_energy set not null ;


drop table tmp;

select count(d.*), d.code_eqp,d.kind_energy,d.zone,d.dt_zone_install 
         into table tmp
        from eqd_meter_zone_tbl as  d 
          group by d.code_eqp,d.kind_energy,d.zone, d.dt_zone_install  
           having count(*)>1; 



delete   from  eqd_meter_zone_tbl 
 where exists  (select * from tmp 
                  where tmp.code_eqp=eqd_meter_zone_tbl.code_eqp);


alter table eqd_meter_zone_tbl add primary key(code_eqp,kind_energy,zone,dt_zone_install);
alter table eqd_meter_zone_h drop constraint eqd_meter_zone_h_pkey;

delete from  eqd_meter_zone_h;

insert into eqd_meter_zone_h  
 select code_eqp,id_department,dt_zone_install,kind_energy,zone,NULL,NULL,dt_zone_install from eqd_meter_zone_tbl;

drop table tmp1;

select count(d.*), d.code_eqp,d.kind_energy,d.zone,d.dt_b
         into table tmp1
        from eqd_meter_zone_h as d 
          group by d.code_eqp,d.kind_energy,d.zone, d.dt_b  
           having count(*)>1; 

delete   from  eqd_meter_zone_h
 where exists  (select * from tmp1 
                  where tmp1.code_eqp=eqd_meter_zone_tbl.code_eqp);


alter table eqd_meter_zone_h add primary key(code_eqp,kind_energy,zone,dt_b);