set client_encoding='win';
delete from acd_powerindication_tbl where id in 
( select id from acm_headpowerindication_tbl ph 
right join acd_powerindication_tbl pd on pd.id_doc=ph.id_doc 
 where time_indic::date<>reg_date and time_indic::date>='2014-09-01'--where pd.id_doc is null
order by ph.id_doc,id_meter);


delete from acd_powerindication_tbl where id in
(select pd.id from acd_powerindication_tbl pd 
left join  acm_headpowerindication_tbl ph  on pd.id_doc=ph.id_doc 
 where  ph.id_doc is null
order by ph.id_doc,id_meter 
)
;

update acm_headpowerindication_tbl set id_file=null where reg_num not like 'ask%';


alter table acd_powerindication_tbl alter column k_tr set default 1;
alter table acd_powerindication_tbl alter column k_ts set default 1;
update acd_powerindication_tbl set k_tr=1 where k_tr<1;
update acd_powerindication_tbl set k_ts=1 where k_ts<1;




update acd_powerindication_tbl set  
value_dem=value_dev --*coalesce(k_tr,1.00)*coalesce(k_ts,1.00)
where value is null and value_dem<>value_dev;--*coalesce(k_tr,1.00)*coalesce(k_ts,1.00);

update acd_powerindication_tbl set  
value_dev=value_dem/(coalesce(k_tr,1.00)*coalesce(k_ts,1.00))
where value is null and value_dem=value_dev;--*coalesce(k_tr,1.00)*coalesce(k_ts,1.00);

/*
select * from acd_powerindication_tbl pd 
left join  acm_headpowerindication_tbl ph  on pd.id_doc=ph.id_doc 
 where  ph.id_doc is null
order by ph.id_doc,id_meter
select * from acd_powerindication_tbl order by id_meter,time_indic;


select   *  FROM acd_powerindication_tbl order  by id_meter,time_indic,id_doc;

select * from acm_headpowerindication_tbl where reg_num not like 'ask%';


select * from acd_powerindication_tbl pd 
left join  acm_headpowerindication_tbl ph  on pd.id_doc=ph.id_doc 
 where  ph.id_doc is null
order by ph.id_doc,id_meter
*/


create or replace function calc_all_powerdemand()
  RETURNS bool                                                                                     
  AS                                                                                              
$BODY$
  declare
cou_h int;
  rec record;

  ret boolean;
begin  
 
for rec in select distinct id_doc,id_client,mmgg from acm_headpowerindication_tbl where mmgg='2014-09-01'  loop
  cou_h=crt_pwr2krbill(rec.id_client, rec.id_doc,rec.mmgg);
end loop;


RETURN true;

end;
$BODY$                                                                                          
LANGUAGE 'plpgsql';  


select crt_ttbl();
select calc_all_powerdemand();


/*
select * from acd_pwr_limit_over_tbl where id_doc>1156140
select * from acd_powerindication_tbl where id_doc= 1153634

select crt_pwr2krbill( 2121, 1153634 , '2014-09-01'); 

select id_area, night_day, max(dem)*2 as max_power from
  (select coalesce(i.id_area,0) as id_area, i.night_day, i.time_indic, sum(i.value_dem) as dem
   from 
   acm_headpowerindication_tbl as h
   join acd_powerindication_tbl as i on (h.id_doc = i.id_doc)
   where h.id_doc = 1153634
   group by i.id_area,i.time_indic,i.night_day ) as s1 
  group by id_area, night_day

 select * from  acm_headpowerindication_tbl WHERE ID_DOC=1153634

 select * from acm_headdemandlimit_tbl as hl 
   join acd_demandlimit_tbl as l  on(hl.id_doc = l.id_doc)
   where hl.id_client = 2121 and date_trunc('month',l.month_limit)  = '2014-09-01' -- 2014-09-12  pmmgg 
  -- and hl.reg_date <= '2014-09-01' 
   --and idk_document = 601
   and coalesce(l.id_area,0) = 359244 and l.night_day =1
   order by hl.reg_date desc limit 1;   

   SELECT * FROM acd_demandlimit_tbl WHERE ID_AREA=359244 ORDER BY MONTH_LIMIT

   select * acd_powerindication_tbl
  

*/


