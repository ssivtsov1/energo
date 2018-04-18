
drop function progn_5(date); 

create  function progn_5(date) returns boolean as
'
declare pmmgg alias for $1;
Ssql text;
daya int;
bday int;
eday int;
yeart text;
begin
yeart=''year'';
delete from rep_prognoz5_tmp;
raise notice ''start prognoz5'';
update clm_statecl_tbl set pre_pay_perc1=0 where pre_pay_perc1 is null;  
update clm_statecl_tbl set pre_pay_perc2=0 where pre_pay_perc2 is null; 
update clm_statecl_tbl set pre_pay_perc3=0 where pre_pay_perc3 is null;   

--delete from clm_daypay_tbl;
/*
insert into clm_daypay_tbl (id_client,day,perc) select id_client,case when (pre_pay_day1>0 )  then pre_pay_day1 else  dt_indicat+1+pre_pay_day1 end ,pre_pay_perc1 from clm_statecl_tbl where  pre_pay_perc1>0;
insert into clm_daypay_tbl (id_client,day,perc) select id_client, pre_pay_day2  , pre_pay_perc2 from clm_statecl_tbl where pre_pay_day2>0 and pre_pay_perc2>0;
insert into clm_daypay_tbl (id_client,day,perc) select id_client, pre_pay_day3  , pre_pay_perc3 from clm_statecl_tbl where pre_pay_day3>0 and pre_pay_perc3>0;
*/
insert into rep_prognoz5_tmp (id_section,  id_client, code, name, dt_indicat,
  tar,  sum_credit,  id_represent, represent_name, demand,  value_all, 
  dem,  val,  pay_all)
  select s.id_section as link,c.id as id_client,c.code,c.short_name as name, s.dt_indicat,
  p.tar,  kr.sum_kredit, s.id_position, cp.represent_name, bill.demand,bill.value_all, 
  seb.dem as dem,  round(seb.dem*p.tar,2) as val,  pay.pay as pay_all
   from clm_client_tbl c 
   left join clm_statecl_tbl s  on (c.id=s.id_client) 
   left join clm_position_tbl as cp on (s.id_position=cp.id) 
   left join (select  id_client,  
               case when demand_plan=0 then demand_calc else demand_plan end as dem  
                from  seb_plan  where id_pref=10 and mmgg=pmmgg order by id_client 
             ) seb  on (c.id=seb.id_client ) 
   left join (select id_client,sum(demand_val) as dem ,sum(value+value_tax) as val,
               case when sum(demand_val)>0 then round((sum(value+value_tax)/ ( case when sum(demand_val)>0 then sum(demand_val) else -1 end ) ) ,5 ) else 0 end as tar  
               from acm_bill_tbl where mmgg= (pmmgg- interval ''1 month'')::date  
               and id_pref=10 group by id_client 
              ) as p    on (p.id_client =c.id) 
   left join (select id_client,sum(demand_val) as demand ,sum(value+value_tax) as value_all 
              from acm_bill_tbl where mmgg= pmmgg  and id_pref=10 group by id_client
             ) as bill   on (bill.id_client =c.id) 
   left join (select  id_client,id_pref,mmgg,case when (b_val+b_valtax)<0 then -(b_val+b_valtax) else 0 end as sum_kredit  
                from acm_saldo_tbl where id_pref=10 and mmgg=pmmgg
             ) kr   on c.id=kr.id_client
   left join (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  
              where  id_pref=10 and mmgg=pmmgg and date_trunc(''year'',mmgg_pay)=date_trunc(''year'',pmmgg) 
                group by id_client,id_pref 
              ) as pay on pay.id_client=c.id 
   where  coalesce(c.id_state,0) not in (50,99)
   order by c.code;
 
  daya=5;
delete from rep_prognoz5_tmp where code is null or code=1000000;

while  daya<30 loop
raise notice '' daya %'',daya ;
--raise notice '' client %'', ;
if daya=5 then
   bday=daya-5;
   eday=daya;
 else 
  bday=daya-4;
  eday=daya;
 end if;
 if daya=25 then
   eday=31;
 end if;
 SSql=''update rep_prognoz5_tmp set
        pre_pay_perc''||daya||''=s.perc,
     pre_pay_day''||daya||''=s.day,
     pre_pay_sum''||daya||''= round(coalesce(dem,0)*coalesce(tar,0)*(coalesce(s.perc,0)/100.00),2),
     pre_pay_dem''||daya||''= round(coalesce(dem)*(coalesce(s.perc,0)/100.00),2)
 from
  ( select id_client,max(day) as day ,sum(perc) as perc 
     from clm_daypay_tbl c 
     where c.day>=''||bday||'' and day<=''||eday||''   
      group by id_client 
  ) as s where s.id_client=rep_prognoz5_tmp.id_client'';

raise notice ''% '',SSql;
Execute (SSql);        
--SSQl=''and date_trunc(''||quote_literal(yeart)||'',mmgg_pay)=date_trunc(''||quote_literal(yeart)||'',''||quote_literal(pmmgg)||'')'' ;
--raise notice ''% '',SSql;

 SSql=''update rep_prognoz5_tmp set   pay''||daya||''=pay.pay 
       from 
        (select id_client,id_pref,sum(value_pay) as pay from acm_pay_tbl  
                 where (reg_date-bom(reg_date))>=''||bday||'' and (reg_date-bom(reg_date))<=''||eday||'' 
                   and id_pref=10 and mmgg=''||quote_literal(pmmgg)||'' 
                    and date_trunc(''||quote_literal(yeart)||'',mmgg_pay)=date_trunc(''||quote_literal(yeart)||'',''||quote_literal(pmmgg)||''::date) 
                    group by id_client,id_pref order by id_client 
        ) as pay 
        where  pay.id_client=rep_prognoz5_tmp.id_client''; 
Execute (SSql);        
raise notice ''% '',SSql;

--                    and date_trunc(''||quote_literal(yeart)||'',mmgg_pay)=date_trunc(''||quote_literal(yeart)||'',''||pmmgg||''::date) 

daya=daya+5;

end loop;
return true;
end '
language 'plpgsql';           

