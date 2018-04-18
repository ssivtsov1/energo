create or replace function seb_plan_full(date) returns boolean as '
declare 
pmmgg alias for $1;
kodres int;
pr boolean;                                   
begin
raise notice ''start'';

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

insert into seb_plan (kod_res,code,doc_num,mmgg,id_client,id_pref) 
select kodres,-100,1,pmmgg  ,d.id_client,10 from 
(select c.id as id_client,st.id_section,c.idk_work 
   from (select * from clm_client_tbl  where  idk_work<>0) c 
    left join clm_statecl_tbl st on c.id=st.id_client 
 ) d  
left join 
 (select id_client,id_pref,mmgg from seb_plan where mmgg=pmmgg)
  as p  on  (  d.id_client=p.id_client 
              and p.id_pref=10 and p.mmgg=pmmgg
             )
 where p.id_client is null;
raise notice ''1'';
insert into seb_plan 
select kodres,b.id_client,-100,''-100'',b.id_pref,b.mmgg,b.demand,0,0,''?????'' 
 from  
 (select b.id_client,b.id_pref,b.mmgg,sum(b.demand_val) as demand 
   from acm_bill_tbl b
   where b.id_client is not null
   group by b.id_client,b.id_pref,b.mmgg 
    having b.mmgg=pmmgg
 ) as b left join 
 (select id_client,id_pref,mmgg from seb_plan where mmgg=pmmgg)
  as p  on  (  b.id_client=p.id_client 
              and b.id_pref=p.id_pref and p.mmgg=b.mmgg
             )
 where p.id_client is null;
raise notice ''2'';
update seb_plan set demand=b.demand 
from  
 (select b.id_client,b.id_pref,b.mmgg,sum(b.demand_val) as demand 
   from acm_bill_tbl b  
   group by b.id_client,b.id_pref,b.mmgg 
    having b.mmgg=pmmgg
 ) as b 
  where  seb_plan.id_client=b.id_client 
   and  seb_plan.id_pref=b.id_pref and seb_plan.mmgg=b.mmgg;

raise notice ''demand_plan'';
update seb_plan set demand_plan=b.value_dem  from
   (select hl.id_client, sum(d1.value_dem) as value_dem 
     from acd_demandlimit_tbl as d1 
     join acm_headdemandlimit_tbl as hl on (hl.id_doc = d1.id_doc) 
           join ( 
           select h2.id_client,d2.month_limit, d2.id_area, max(h2.reg_date) as maxdate , max(h2.mmgg) as maxmmgg 
           from acm_headdemandlimit_tbl as h2 
           join acd_demandlimit_tbl as d2  on  (h2.id_doc = d2.id_doc) 
           left join eqm_ground_tbl as g on (g.code_eqp = d2.id_area)
           where h2.idk_document = 600 and d2.month_limit= pmmgg 
           and (d2.id_area is null or g.code_eqp is not null) 
           group by h2.id_client , d2.id_area, d2.month_limit order by h2.id_client 
          ) as hh on (hh.id_client = hl.id_client and hh.maxdate = hl.reg_date and hh.maxmmgg = hl.mmgg  
             and hh.month_limit = d1.month_limit and hh.id_area = d1.id_area) 
     where hl.idk_document = 600  and d1.month_limit= pmmgg
     group by hl.id_client 
     order by hl.id_client) b 
 where (b.id_client=seb_plan.id_client and seb_plan.mmgg=pmmgg);
 
raise notice ''end demand_plan'';
update seb_plan set code=coalesce(c.code,-100),
name=c.short_name, doc_num= coalesce(c.doc_num,''-100'')
from ( select c.id,c.code,c.short_name,s.doc_num from clm_client_tbl c 
       left join clm_statecl_tbl s on c.id=s.id_client 
  )  as c
where  seb_plan.id_client=c.id and seb_plan.code=-100;

update  seb_plan set name=c.short_name 
 from clm_client_tbl c where id_client=c.id and c.code<>seb_plan.code;
raise notice ''end '';
--pr=seb_plan_rep(pmmgg);

return true;
end;
' language 'plpgsql';




create or replace function seb_plan_rep(date) returns boolean as'
declare 
mon alias for $1;
pr  boolean;
begin 
delete from seb_plan_tmp;
pr=seb_plan_full((mon-interval ''1 month'')::date);
pr=seb_plan_full(mon);
insert into seb_plan_tmp (mmgg,id_section,id_client,id_pref) 
select mon,id_section,id_client,10 from 
(select c.id as id_client,st.id_section,c.idk_work 
   from clm_client_tbl c left join clm_statecl_tbl st on c.id=st.id_client 
) d ; 
-- where    idk_work<>0;

update seb_plan_tmp set ym13=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg= (mon-interval ''1 year'') - interval ''3 month'' 
and p.id_pref=seb_plan_tmp.id_pref ;

update seb_plan_tmp set ym12=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg= (mon-interval ''1 year'') - interval ''2 month''  
and p.id_pref=seb_plan_tmp.id_pref;

update seb_plan_tmp set ym11=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg= (mon-interval ''1 year'') - interval ''1 month''  
and p.id_pref=seb_plan_tmp.id_pref;

update seb_plan_tmp set ym10=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg= (mon-interval ''1 year'')   
and p.id_pref=seb_plan_tmp.id_pref;


update seb_plan_tmp set ym03=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg=mon - interval ''3 month''  
and p.id_pref=seb_plan_tmp.id_pref;

update seb_plan_tmp set ym02=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg= mon - interval ''2 month''  
and p.id_pref=seb_plan_tmp.id_pref;

update seb_plan_tmp set ym01=demand from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg= mon - interval ''1 month''  
and p.id_pref=seb_plan_tmp.id_pref;

update seb_plan_tmp set ym_plan=demand_plan, ym_fact=demand ,
  ym_calc=demand_calc
 from seb_plan  p
 where  seb_plan_tmp.id_client=p.id_client 
  and p.mmgg=mon  
and p.id_pref=seb_plan_tmp.id_pref;

update seb_plan_tmp 
set s31=ym13+ym12+ym11, s30=ym03+ym02+ym01;
         
update seb_plan_tmp 
set pr_13_03= (case when ym13<>0 then ym03/ym13::numeric*100 else 0 end),
    pr_12_02= (case when ym12<>0 then ym02/ym12::numeric*100 else 0 end), 
    pr_11_01= (case when ym11<>0 then ym01/ym11::numeric*100 else 0 end),
    pr_31_30= (case when s31<>0 then  s30/s31::numeric*100 else 0 end), 
    pr_03_02= (case when ym02<>0 then ym03/ym02::numeric*100 else 0 end),
    pr_02_01= (case when ym01<>0 then ym02/ym01::numeric*100 else 0 end); 
           

update seb_plan_tmp 
set ym_calc=round(ym10*pr_31_30/100,3);
              
update seb_plan_tmp 
set deflect=ym_calc-ym_plan, 
pr_deflect= case when ym_calc<>0 then ym_plan/ym_calc::numeric*100 else 0 end;

update seb_plan set demand_calc=ym_calc from seb_plan_tmp p 
 where seb_plan.id_client=p.id_client and seb_plan.id_pref=p.id_pref 
     and seb_plan.mmgg=p.mmgg; 

           
  
return true;
end;
' language 'plpgsql';





create or replace function seb_plan_perc(int,int,int,int) returns int as '
declare 
cli alias for $1;
d_start alias for $2;
d_end alias for $3;
flag alias for $4;
d_day int;
rec record;
noproc int;
pr int;                                   
pday int;
begin

select into rec * from clm_statecl_tbl where id_client=cli;

pr=0;
if rec.pre_pay_day1<0 then
  pday=rec.dt_indicat+1+rec.pre_pay_day1;
else
   pday=rec.pre_pay_day1;
end if;

if pday>=d_start and pday<=d_end then
 pr=pr+rec.pre_pay_perc1;
 d_day=pday;
end if;

if rec.pre_pay_day2<0 then
  pday=rec.dt_indicat+1+rec.pre_pay_day2;
else
   pday=rec.pre_pay_day2;
end if;

if pday>=d_start and pday<=d_end then
 pr=pr+rec.pre_pay_perc2;
d_day=pday;
end if;

if rec.pre_pay_day3<0 then
  pday=rec.dt_indicat+1+rec.pre_pay_day3;
else
   pday=rec.pre_pay_day3;
end if;


if pday>=d_start and pdayp<=d_end  then
 pr=pr+rec.pre_pay_perc3;
d_day=rec.pday;
end if;
 noproc=rec.pre_pay_perc1+rec.pre_pay_perc2+rec.pre_pay_perc3;
if  noproc<100 then
 if rec.dt_start+rec.day_pay_bill>=d_start and rec.dt_start+rec.day_pay_bill<=d_end  then 
   pr=pr+100-noproc;
   d_day=case when rec.dt_start+rec.day_pay_bill<31 then rec.dt_start+rec.day_pay_bill else 30 end ;
 end if;
end if;

raise notice ''--------------------'';
raise notice ''client  ,  %'',rec.id_client ;
raise notice ''pr    %'',pr;
raise notice ''d_day    %'',d_day;
if flag=0 then
 return pr; 
else 
return d_day;
end if;
end;
' language 'plpgsql';