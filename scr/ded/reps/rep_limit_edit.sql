

create or replace function rep_limit_area_change_fun(date,date) Returns int As'
Declare

 pdt1 Alias for $1;
 pdt2 Alias for $2;

 r record;
 vlimit_old numeric;

BEGIN

 delete from rep_limit_area_change_tbl;

 insert into rep_limit_area_change_tbl(id_doc, id_client, id_area , reg_date, reg_num, month_limit, name_area, value_new, dt )
 select hl.id_doc, hl.id_client, l.id_area, hl.reg_date, hl.reg_num, l.month_limit, eq.name_eqp as name_area,    l.value_dem,  hl.dt
  from acm_headdemandlimit_tbl as hl 
  join acd_demandlimit_tbl as l  on (l.id_doc = hl.id_doc)
  left join eqm_equipment_h as eq on (eq.id = l.id_area )
 where hl.reg_date >= pdt1 and hl.reg_date <= pdt2
  and hl.idk_document = 600 
  and eq.dt_b = (select max(dt_b) from eqm_equipment_h as eq2 
   where eq2.id = eq.id and eq2.dt_b <= hl.reg_date ) ;

 for r in 
  select * from rep_limit_area_change_tbl
 loop

        select into vlimit_old sum(l3.value_dem) as value_dem
        from
        (
         select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
         from 
         (	
          select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
          from acm_headdemandlimit_tbl as hl 
          join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
          where hl.id_client = r.id_client and date_trunc(''month'',l.month_limit) = r.month_limit 
           and l.id_area = r.id_area and hl.reg_date <=r.reg_date and hl.id_doc <> r.id_doc
           and idk_document = 600 
          group by hl.id_client,l.id_area
         ) as s
         join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
         join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)
         left join eqm_ground_tbl as g on (g.code_eqp = l2.id_area)
         where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = r.month_limit
         and (l2.id_area is null or g.code_eqp is not null) 
         group by h2.reg_date, l2.id_area  
        ) as ss
        join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
        join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area) 
        where ss.id_area = r.id_area and l3.month_limit = r.month_limit ;


	update rep_limit_area_change_tbl set value_old = vlimit_old
        where id_doc = r.id_doc and id_area = r.id_area and month_limit = r.month_limit;
 end loop;

    return 1;
end;
' Language 'plpgsql'; 