
create sequence ask_calclimit_seq;
CREATE TABLE ask_calclimit_tbl (
    id integer DEFAULT nextval('ask_calclimit_seq'::text) NOT NULL,
    dt timestamp without time zone default now(),
    id_client int,
    id_area integer,
    dt_doc date,     
    dt_ind1 date,
    dt_ind2 date,
    limit1 int,
    limit2 int,
    hours int,
    day1 int,
    day2 int,
    clc_pwr1 numeric(12,4),
    clc_pwr2 numeric(12,4),
    clc_lim  numeric(12,4),
    day_avg  numeric(12,4),
    clc_lim_day  numeric(12,4),
    clc_lim_night  numeric(12,4),
    bron   int,
    fin_lim_day  int,
    fin_lim_night  int,
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0,
    primary key(id)
);


drop trigger ask_calclimit_trg on ask_calclimit_tbl;
drop function ask_calclimit_fun();

-------------------------==========================-----------------
create or replace function ask_calclimit_fun() returns opaque as'
declare 
  fl_ins int;
  vbill  record;
  tr_pay record;
  restb numeric;
begin
  Return new;
  end; 
' LANGUAGE 'plpgsql';



create or replace function calc_askue_limit(int,int,date) Returns int  AS
$BODY$

Declare
 pid_client Alias for $1;
 pid_area Alias for $2;
 pdt alias for $3;
 r record;
 r1 record;
 kdoc int;
 iddc int;
 vlimit record;
 vfact record;
 v2kr record;
 d_bill date;
 vbill_dat date;
vmmgg1 date;
vmmgg2 date;

 vdemand_2kr int;
 vbill_num varchar;
sbill numeric;
recpower record;   
begin

-- delete from act_res_notice;
 delete from sys_error_tbl;
delete from  ask_calclimit_tbl where id_client=pid_client and id_area=pid_area and dt_doc=pdt;
vmmgg1=bom(pdt)-interval '1 month';
vmmgg2=bom(pdt);


insert into ask_calclimit_tbl (id_client,id_area,dt_doc) values (pid_client,pid_area,pdt);
/*
update ask_calclimit_tbl set dt_ind1=vmmgg1+a.dt_ind-1    ,dt_ind2=vmmgg2+a.dt_ind-1 
  (select * from clm_statecl_tbl where id_client=pid_client) a  
 where id_client=pid_client and id_area=pid_area and dt_doc=pdt;
*/


update ask_calclimit_tbl set dt_ind1=vmmgg1+a.dt_indicat-1    ,dt_ind2=vmmgg2+a.dt_indicat-1
from 
  (select * from clm_statecl_tbl where id_client=pid_client) a  
 where ask_calclimit_tbl.id_client=pid_client and id_area=pid_area and ask_calclimit_tbl.dt_doc=pdt;

update ask_calclimit_tbl set limit1=a.value_dem from (select value_dem, l.id_area, hl.id_doc from acm_headdemandlimit_tbl as hl 
 join (select d.* from acd_demandlimit_tbl d 
                      left join eqm_ground_tbl g 
                      on d.id_area=g.code_eqp where d.id_area is null  or (d.id_area =code_eqp)
       )  as l  on(hl.id_doc = l.id_doc)
 where l.id_area =pid_area and  hl.id_client = pid_client 
  and date_trunc('month',l.month_limit)  = vmmgg1  
  and hl.reg_date <= pdt::date  
   and idk_document = 600
 order by hl.reg_date desc limit 1) a
 where id_client=pid_client and ask_calclimit_tbl.id_area=pid_area and dt_doc=pdt;

update ask_calclimit_tbl set limit2=a.value_dem from (select value_dem, l.id_area, hl.id_doc from acm_headdemandlimit_tbl as hl 
 join (select d.* from acd_demandlimit_tbl d 
                      left join eqm_ground_tbl g 
                      on d.id_area=g.code_eqp where d.id_area is null  or (d.id_area =code_eqp)
       )  as l  on(hl.id_doc = l.id_doc)
 where l.id_area =pid_area and  hl.id_client = pid_client 
  and date_trunc('month',l.month_limit)  = vmmgg2  
  and hl.reg_date <= pdt::date + '1 month - 1 days'::interval 
   and idk_document = 600
 order by hl.reg_date desc limit 1) a
 where id_client=pid_client and ask_calclimit_tbl.id_area=pid_area and ask_calclimit_tbl.dt_doc=pdt;


update ask_calclimit_tbl set hours=g.wtm from (select * from eqm_ground_tbl)  g
where ask_calclimit_tbl.id_area=code_eqp and dt_doc=pdt  
and  ask_calclimit_tbl.id_client=pid_client and id_area=pid_area;

update ask_calclimit_tbl set day1=cal_days_fun(bom(dt_ind1),dt_ind1),
 day2= cal_days_fun((dt_ind1+interval '1 day')::date,eom(dt_ind1))
 where  dt_doc=pdt  and  id_client=pid_client 
  and id_area=pid_area and (hours is null or hours<470);

update ask_calclimit_tbl set day1=cal_daysall_fun(bom(dt_ind1),dt_ind1),
day2= cal_days_fun((dt_ind1+interval '1 day')::date,eom(dt_ind1))
 where dt_doc=pdt  and  id_client=pid_client 
  and id_area=pid_area and (hours is null or hours>=470);

update ask_calclimit_tbl set clc_pwr1=(limit1::numeric/date_part('day',(eom(dt_ind1))))*day1
  where  dt_doc=pdt  and  id_client=pid_client 
  and id_area=pid_area;

update ask_calclimit_tbl set clc_pwr2=(limit2::numeric/date_part('day',(eom(dt_ind2))))*day2
  where  dt_doc=pdt  and  id_client=pid_client 
  and id_area=pid_area;

/*
update ask_calclimit_tbl set day_avg=(limit2::numeric/date_part(day(eom(dt_ind2)))*day2
  where id_area=code_eqp and dt_doc=pdt_doc  and  id_client=pid_client 
  and id_area=pid_area;
 */

update ask_calclimit_tbl set clc_lim_day=(clc_pwr1+clc_pwr2)/ 
(date_part('day',(eom(dt_ind2)))*24  * koef )
from (select * from  ask_regim_tbl 
        where  id_client=pid_client and id_area=pid_area and night_day=1 
        and date_part('month',pdt) between date_part('month',dt_b) and date_part('month',dt_e) 
        order by   dt_b desc  limit 1
  ) as  rr  where rr.id_client=ask_calclimit_tbl.id_client 
      and rr.id_area=ask_calclimit_tbl.id_area
      and ask_calclimit_tbl.dt_doc=pdt  and  ask_calclimit_tbl.id_client=pid_client 
  and ask_calclimit_tbl.id_area=pid_area and koef<>0;



update ask_calclimit_tbl set clc_lim_night=(clc_pwr1+clc_pwr2)/ 
(date_part('day',(eom(dt_ind2))) *24  * koef )              from (select * from  ask_regim_tbl 
         where  id_client=pid_client and id_area=pid_area and night_day=2 
         and date_part('month',pdt) between date_part('month',dt_b) and date_part('month',dt_e) 
         order by   dt_b desc  limit 1
        ) as rr  
 where rr.id_client=ask_calclimit_tbl.id_client 
      and rr.id_area=ask_calclimit_tbl.id_area
      and ask_calclimit_tbl.dt_doc=pdt  and  ask_calclimit_tbl.id_client=pid_client 
  and ask_calclimit_tbl.id_area=pid_area and koef<>0;

        

Return 1;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


