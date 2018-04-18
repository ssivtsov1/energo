
drop function area_calc(); 

drop function full_popl_calc(); 

drop function full_popl_calc(int); 
create function full_popl_calc(int) Returns boolean As'
Declare
id_area Alias for $1;
r record;
mg date;
rs boolean;
begin
select into mg (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''||substr(value_ident,1,2))::date 
from syi_sysvars_tmp where ident=''mmgg'';

if id_area is null then
 for r in select distinct a.id_client from acd_indication_tbl as a 
  inner join (select * from acm_headindication_tbl as a1 inner join 
   (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'') as a2 on (a1.idk_document=a2.id) 
   where flag_priv) as b on (a.id_doc=b.id_doc) 
  where a.mmgg<=mg and a.id_cor_doc is null and a.id_previndic is not null loop
 
--  Raise Notice ''ID_CL - %'',r.id_client;
  rs:=start_popl_calc(r.id_client);
 end loop;
else
 for r in  select distinct a.id_client from acd_indication_tbl as a 
   inner join (select * from acm_headindication_tbl as a1 inner join 
   (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'') as a2 on (a1.idk_document=a2.id) 
   where flag_priv and id_doc_inspect=id_area) as b on (a.id_doc=b.id_doc) 
   where a.mmgg<=mg and a.id_cor_doc is null and a.id_previndic is not null 
   loop
       rs:=start_popl_calc(r.id_client);
 end loop;
end if;
 Return true;
end;
' Language 'plpgsql';




--drop function full_popl_calc(int); 
  /*
create function full_popl_calc(int) Returns boolean As'
Declare
id_area Alias for $1;
r record;
rs boolean;
rs1 boolean;
iddc int;
existt boolean;
begin

if id_area is null then
 select into existt table_exists(''calc_fiz'');
 if existt then
 delete from calc_fiz;

 insert into temp calc_fiz select a.*,c.cnt from clm_client_tbl as a 
      inner join 
       ( select count(*) as cnt,a.id_client from acd_indication_tbl as a 
         left join 
          acm_bill_tbl as b on (a.id=b.id_ind) 
             where id_previndic is not null and b.id_doc is null 
          group by a.id_client) as c 
         on (a.id=c.id_client) 
       where a.book<>-1 and c.cnt>0;

 else
 select a.*,c.cnt into temp calc_fiz from clm_client_tbl as a 
      inner join 
       ( select count(*) as cnt,a.id_client from acd_indication_tbl as a 
         left join 
          acm_bill_tbl as b on (a.id=b.id_ind) 
             where id_previndic is not null and b.id_doc is null 
          group by a.id_client) as c 
         on (a.id=c.id_client) 
       where a.book<>-1 and c.cnt>0;


 end if;

 for r in select * from calc_fiz  loop
     Raise Notice ''ID_CL - %'',r.id;
     
     iddc:=start_popl_calc(r.id_client);
     --iddc:=crt_popl_bill(r.id);
     
   if (iddc isnull) then
      rs:=false;
      
      if (select id_client from acm_subs_tbl where flock=0 and id_client=r.id 
            and (s_part_full>0 and s_norm>0) limit 1) is not null then 
 RAISE NOTICE ''Calc_subs1'';
       rs1:=calc_subs(r.id);
     end if;
   else

    if (select id from cld_addon_tbl as d inner join (select a.id_client as idcl
      ,b.dat_b as dtb,b.dat_e as dte from acm_bill_tbl as a inner join 
       acd_point_branch_tbl as b on (a.id_doc=b.id_doc) where a.id_doc=iddc) as c 
     on (d.id_client=c.idcl) 
     where (d.dat_e>c.dtb or d.dat_e isnull) limit 1) 
      notnull then
RAISE NOTICE ''Calc_kateg'';
       rs1:=kateg_calc(iddc);
    end if;
    if (select id_client from acm_subs_tbl where flock=0 and id_client=r.id 
            and (s_part_full>0 and s_norm>0) limit 1) is not null then 
RAISE NOTICE ''Calc_subs2'';
        rs1:=calc_subs(r.id);
    end if;
    rs:=true;
   end if;
 end loop;
else 
select into existt table_exists(''calc_fiz'');
if existt then
delete from calc_fiz;

insert into temp calc_fiz 

select a.*,c.cnt from clm_client_tbl as a inner join 
 (select count(*) as cnt,a.id_client from (select a1.* from acd_indication_tbl
   as a1 right join acm_headindication_tbl as a2 on (a1.id_doc=a2.id_doc) where 
      id_doc_inspect=id_area) as a left join 
  acm_bill_tbl as b on (a.id=b.id_ind) 
   where id_previndic is not null and b.id_doc is null group by a.id_client) as c 
    on (a.id=c.id_client) where a.book<>-1 and c.cnt>0;

else

select a.*,c.cnt into temp calc_fiz from clm_client_tbl as a inner join 
 (select count(*) as cnt,a.id_client from (select a1.* from acd_indication_tbl
   as a1 right join acm_headindication_tbl as a2 on (a1.id_doc=a2.id_doc) where 
      id_doc_inspect=id_area) as a left join 
  acm_bill_tbl as b on (a.id=b.id_ind) 
   where id_previndic is not null and b.id_doc is null group by a.id_client) as c 
    on (a.id=c.id_client) where a.book<>-1 and c.cnt>0;


end if;
for r in select * from calc_fiz  loop

  Raise Notice ''ID_CL - %'',r.id;
--   iddc:=crt_popl_bill(r.id);
       iddc:=start_popl_calc(r.id_client);  
if (iddc isnull) then
     rs:=false;
     if (select id_client from acm_subs_tbl where flock=0 and id_client=r.id 
            and (s_part_full>0 and s_norm>0) limit 1) is not null then 
RAISE NOTICE ''Calc_subs1'';
       rs1:=calc_subs(r.id);
     end if;
   else

    if (select id from cld_addon_tbl as d inner join (select a.id_client as idcl
      ,b.dat_b as dtb,b.dat_e as dte from acm_bill_tbl as a inner join 
       acd_point_branch_tbl as b on (a.id_doc=b.id_doc) where a.id_doc=iddc) as c 
     on (d.id_client=c.idcl) 
     where (d.dat_e>c.dtb or d.dat_e isnull) limit 1) 
      notnull then
RAISE NOTICE ''Calc_kateg'';
       rs1:=kateg_calc(iddc);
    end if;
    if (select id_client from acm_subs_tbl where flock=0 and id_client=r.id 
            and (s_part_full>0 and s_norm>0) limit 1) is not null then 
RAISE NOTICE ''Calc_subs2'';
        rs1:=calc_subs(r.id);
    end if;
    rs:=true;
   end if;
 end loop;
end if;
 Return true;
end;
' Language 'plpgsql';
   */
  
drop function kateg_calc(int); 
create function kateg_calc(int) Returns boolean As'
Declare
iddc Alias for $1;
rs boolean;
r record;
hpay int;
begin
--Raise Notice ''Kateg_calc'';
rs:=false;
select into r a.id_client as idcl,a.mfo_self as mfo_s,a.account_self 
  as acc_s,a.mmgg as mg,b.dat_b as dtb,b.dat_e as dte 
  from acm_bill_tbl as a,acd_point_branch_tbl as b where a.id_doc=b.id_doc 
  and a.id_doc=iddc;
--calc compens_kateg summs
-------------------------------
---check_bill
 delete from acd_kateg_tbl where id_doc=iddc;
 if (select id from cld_addon_tbl where id_client=r.idcl and (dat_e>r.dtb or dat_e isnull) limit 1) notnull then
  rs:=true;
  insert into acd_kateg_tbl(id_bills,id_doc,id_point,id_tarif,id_k,dat_b,dat_e
             ,prio,persent,calc_norm,demand,comp_sum)
  select id_bills,id_doc,id_point,id_tariff,id_k,dat_b,dat_e,prio,persent,calc_norm,demand
   ,round((persent::numeric/100)*zk*
   (select value*(select value from cmm_currency_tbl where id_currency=b.idk_currency) 
    from acd_tarif_tbl as b where id=id_tar) 
   *(case when (demand-calc_norm)<=0 then demand else calc_norm end),2) as comp_sum
  from 
  (
   select a.id_bills,iddc as id_doc,a.id_point,a.id_tariff,a.id_k,max(a.dat_b,f.dat_b) as dat_b
       ,min(a.dat_e,f.dat_e) as dat_e,a.prio,a.persent 
       ,case when a.norm=0 then 
              (case when f.ident=''clc_sqr'' then 
                 (case when (f.min+f.one*a.num)>=f.max then f.max 
                                      else (f.min+f.one*a.num) end)
               else (case when (f.min+f.one*a.num1)>=f.max then f.max 
                                      else (f.min+f.one*a.num1) end) end) 
             else a.norm end as full_norm
   ,round((case when a.norm=0 then 
             (case when f.ident=''clc_sqr'' then 
                 (case when (f.min+f.one*a.num)>=f.max then f.max 
                                      else (f.min+f.one*a.num) end)
               else (case when (f.min+f.one*a.num1)>=f.max then f.max 
                                      else (f.min+f.one*a.num1) end) end)
             else a.norm end)*(date_mi(min(a.dat_e,f.dat_e)::date,max(a.dat_b,f.dat_b)::date)::numeric/date_mi(r.dte::date,r.dtb::date)::numeric),3) as calc_norm --???round
   ,round((select demand_val/date_mi(acd_billsum_tbl.dt_end::date,acd_billsum_tbl.dt_begin::date)::numeric from acd_billsum_tbl where id=id_bills)*(date_mi(min(a.dat_e,f.dat_e)::date,max(a.dat_b,f.dat_b)::date)::numeric),3) as demand --????
   ,(select koef from acd_zone_tbl where id=(select id_zonekoef from acd_billsum_tbl where id=a.id_bills)) as zk
   ,(select id_sumtariff from acd_billsum_tbl where id=a.id_bills) as id_tar
  from
   (select d.id as id_bills,d.id_point,d.id_tariff,e.id_client,e.id_k,e.num,e.norm
    ,e.num1,e.prio,e.persent,max(d.dat_b,e.dat_b) as dat_b
    ,min(d.dat_e,e.dat_e) as dat_e 
   from
   (select id,id_point,id_tariff,dt_begin as dat_b,dt_end as dat_e from acd_billsum_tbl 
   where id_doc=iddc) as d 
 Left Join
  (select a.id_client,a.id_k,a.num,a.norm,a.num1,(select num from cla_kateg_tbl where id=a.id_k) as prio,g.persent
       ,max(a.dat_b,g.dat_b) as dat_b,min(a.dat_e,g.dat_e) as dat_e 
   from
   (select id_client,id_k,num,norm,case when (num-2)<=0 then 0 else (num-2) end as num1
      ,max(dat_b,r.dtb) as dat_b,coalesce(dat_e,r.dte) as dat_e  
   from cld_addon_tbl where id_client=r.idcl 
   and coalesce(dat_e,r.dte)>r.dtb) as a 
  Left Join
  (select id,persent,max(dt,r.dtb) as dat_b,coalesce((select min(dt) 
      from clad_kateg_tbl as c where 
      c.dt>b.dt and c.id=b.id),r.dte) as dat_e 
   from clad_kateg_tbl as b
   where --!!!b.id=a.id_k and 
      coalesce((select min(dt) from clad_kateg_tbl as c 
      where c.dt>b.dt and c.id=b.id),r.dte)>r.dtb) as g
  on (a.id_k=g.id and (a.dat_b<g.dat_e and a.dat_e>g.dat_b))) as e
 on (d.dat_b<e.dat_e and d.dat_e>e.dat_b)) as a 
 Left Join
  (select b.id_t,b.id_k,max(b.dt,r.dtb) as dat_b,d.ident,b.min,b.one 
   ,case when d.ident=''clc_sqr'' then 
    (select round(cast(substring(value_ident,1,100) as numeric)*b.max,0) from clm_sysparam_tbl 
       where ident=''square'' and id_client=r.idcl) else b.max end as max
   ,coalesce((select min(dt) from cld_kateg_tbl as c where c.dt>b.dt 
             and c.id_t=b.id_t and c.id_k=b.id_k),r.dte) as dat_e 
   from cld_kateg_tbl as b,aci_tarif_tbl as d 
       where b.id_t=d.id and coalesce((select min(dt) from cld_kateg_tbl as c 
          where c.dt>b.dt and c.id_t=b.id_t and c.id_k=b.id_k),r.dte)>r.dtb) as f 
  on (f.id_k=a.id_k and f.id_t=a.id_tariff and a.dat_b<f.dat_e 
    and a.dat_e>f.dat_b)
  ) as k;
--create compens_payms !!!
--acm_headpay_tbl;
--acm_pay_tbl;
select into hpay id from acm_headpay_tbl where flock=0 and flag_priv and flag_type=3;
--headpay_tbl
--flag_type=3 for compens. summs
if (hpay isnull) then
 insert into acm_headpay_tbl(reg_num,reg_date,mfo_self,account_self,flag_priv,flag_type) 
  values(''lgot''||cast((now()::date) as varchar(10)),now()::date,r.mfo_s as mfo_self
   ,r.acc_s as account_self,true,3);
 select into hpay id from acm_headpay_tbl where flock=0 and flag_priv and flag_type=3;
end if;
--pay_tbl
insert into acm_pay_tbl(id_bill,id_headpay,id_pref,reg_num,reg_date,id_client,mfo_self
  ,account_self,pay_date,sign_pay,idk_doc,value,value_pay,value_tax) 
select iddc,hpay,(select id from aci_pref_tbl where ident=''act_ee'')
  ,cast((select coalesce(max(substring(reg_num,1,100)::int),0)+1 from acm_pay_tbl where id_headpay=hpay) as varchar(10))
  ,now()::date,r.idcl,r.mfo_s::int as mfo_self,r.acc_s::int as account_self,now()::date
  ,1,(select id from dci_document_tbl where ident=''comp_kateg'')
  ,val,val+val_tax,val_tax 
from 
 (select sum(comp_sum) as val,round(sum(comp_sum)::numeric*(select value::numeric/100 as nds from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident=''tax'' and a.date_inst=(select max(date_inst) from cmd_tax_tbl where date_inst<=r.mg)),2) as val_tax,id_k 
   from acd_kateg_tbl 
   where id_doc=iddc group by id_k) as k;
--create compens_payms !!!
 end if;
--calc compens_kateg summs
Return rs;
end;
' Language 'plpgsql';


drop function calc_subs(int); 
create function calc_subs(int) Returns boolean As'
Declare
idcl Alias for $1;
rs boolean;
r record;
idbs int;
w_dat date;
mg date;
begin
--Raise Notice ''Calc_subs'';
rs:=false;
select into mg (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''||substr(value_ident,1,2))::date 
--from syi_sysvars_tbl where ident=''mmgg'';
from syi_sysvars_tmp where ident=''mmgg'';

delete from acd_addsubs_tbl where id_dsubs in (select id from acd_subs_tbl 
  where id_client=idcl and flock=0);
delete from acd_subs_tbl where id_client=idcl and flock=0;

for r in select * from acm_subs_tbl where flock=0 and id_client=idcl 
           and (s_part_full>0 and s_norm>0) loop

  rs:=true;
 insert into acd_subs_tbl(id_client,id_msubs,id_bill,id_sold,s_dat,s_part
   ,s_part_tax,s_norm,pay_sum,pay_sum_tax,dem_s_norm) 
 select idcl as id_client,r.id as id_msubs,b.id_doc as id_bill
    ,(select id from acd_subs_tbl where flock=1 and s_dat=r.dat_b 
     and id_client=idcl and mmgg=(select max(mmgg) from acd_subs_tbl 
     where flock=1 and s_dat=r.dat_b and id_client=idcl and mmgg<mg)) as id_sold
    ,r.dat_b as s_dat,r.s_part as s_part,r.s_part_tax as s_part_tax
    ,r.s_norm as s_norm,coalesce(b.value-coalesce((select sum(comp_sum) from acd_kateg_tbl as c 
      where c.id_doc=b.id_doc),0),0) as pay_sum
    ,coalesce(b.value_tax-coalesce((select round(sum(comp_sum)*e.nds,2) from acd_kateg_tbl as c 
      where c.id_doc=b.id_doc),0),0) as pay_sum_tax 
    ,case when coalesce((select sum(demand_val) from acd_billsum_tbl as c 
       where c.id_doc=b.id_doc),0)-r.s_norm<=0 then 0 else 
        (select sum(demand_val) from acd_billsum_tbl as c 
          where c.id_doc=b.id_doc)-r.s_norm end as dem_s_norm 
 from acm_bill_tbl as b
    ,(select value::numeric/100 as nds from cmd_tax_tbl as a
        ,cmi_tax_tbl as b where a.id_tax=b.id and b.ident=''tax'' 
    and a.date_inst=(select max(date_inst) from cmd_tax_tbl where date_inst<=mg)) as e
  where mmgg=r.dat_b and id_client=idcl 
    and id_pref=(select id from aci_pref_tbl where ident=''act_ee'');

 if date_mi(r.dat_b,r.dat_e)<>0 and (to_char(r.dat_b,''MM'')<>to_char(r.dat_e,''MM'')) then
   w_dat:=r.dat_e::date;
   while (w_dat<>r.dat_b) loop
    insert into acd_subs_tbl(id_client,id_msubs,id_bill,id_sold,s_dat,s_part
     ,s_part_tax,s_norm,pay_sum,pay_sum_tax,dem_s_norm) 
    select idcl as id_client,r.id as id_msubs,b.id_doc as id_bill
     ,(select id from acd_subs_tbl where flock=1 and s_dat=w_dat  
      and id_client=idcl and mmgg=(select max(mmgg) from acd_subs_tbl 
      where flock=1 and s_dat=w_dat and id_client=idcl and mmgg<mg)) as id_sold
     ,w_dat as s_dat,r.s_part as s_part,r.s_part_tax as s_part_tax
     ,r.s_norm as s_norm,coalesce(b.value-coalesce((select sum(comp_sum) from acd_kateg_tbl as c 
       where c.id_doc=b.id_doc),0),0) as pay_sum
     ,coalesce(b.value_tax-coalesce((select round(sum(comp_sum)*e.nds,2) from acd_kateg_tbl as c 
       where c.id_doc=b.id_doc),0),0) as pay_sum_tax 
     ,case when coalesce((select sum(demand_val) from acd_billsum_tbl as c 
        where c.id_doc=b.id_doc),0)-r.s_norm<=0 then 0 else 
         (select sum(demand_val) from acd_billsum_tbl as c 
           where c.id_doc=b.id_doc)-r.s_norm end as dem_s_norm 
    from acm_bill_tbl as b 
      ,(select value::numeric/100 as nds from cmd_tax_tbl as a
         ,cmi_tax_tbl as b where a.id_tax=b.id and b.ident=''tax'' 
      and a.date_inst=(select max(date_inst) from cmd_tax_tbl where date_inst<=mg)) as e
     where mmgg=w_dat and id_client=idcl 
     and id_pref=(select id from aci_pref_tbl where ident=''act_ee'');

     w_dat:=date_trunc(''month'',date_mii(w_dat,28));
   end loop; 
 end if;

end loop;
--calc abn_sum
update acd_subs_tbl set 
  abn_sum=(case when (acd_subs_tbl.pay_sum+acd_subs_tbl.pay_sum_tax)<=
   (acd_subs_tbl.s_part+acd_subs_tbl.s_part_tax) 
   then acd_subs_tbl.pay_sum else acd_subs_tbl.s_part end)-coalesce(a.abn_sum,0)
  ,abn_sum_tax=(case when (acd_subs_tbl.pay_sum+acd_subs_tbl.pay_sum_tax)<=
   (acd_subs_tbl.s_part+acd_subs_tbl.s_part_tax) 
   then acd_subs_tbl.pay_sum_tax else acd_subs_tbl.s_part_tax end)-coalesce(a.abn_sum_tax,0)
from acd_subs_tbl as a 
where (acd_subs_tbl.id_sold isnull or a.id=acd_subs_tbl.id_sold) 
   and acd_subs_tbl.id_client=idcl and acd_subs_tbl.flock=0;

for r in select * from acd_subs_tbl where flock=0 and dem_s_norm>0 
          and id_client=idcl loop
  insert into acd_addsubs_tbl(id_dsubs,id_bills,id_bill,dem_s_norm,s_norm_sum
    ,s_norm_sum_tax)
  select id_dsubs,id_bills,id_bill,round(dem_s_norm::numeric*d_day/f_day,0)
   ,round(round(dem_s_norm::numeric*d_day/f_day,0)*tar*zk,2) 
   ,round(round(round(dem_s_norm::numeric*d_day/f_day,0)*tar*zk,2)*nds,2) 
  from
  (select r.id as id_dsubs,b.id as id_bills,r.id_bill as id_bill,r.dem_s_norm as dem_s_norm
    ,(select d.value*e.value from cmm_currency_tbl as d, acd_tarif_tbl as e 
      where e.id=b.id_sumtariff and d.id_currency=e.idk_currency) as tar
    ,(select koef from acd_zone_tbl where b.id_zonekoef=acd_zone_tbl.id) as zk
    ,date_mi(c.dat_e::date,c.dat_b::date) as f_day
    ,date_mi(b.dt_end::date,b.dt_begin::date) as d_day 
    ,e.nds
   from acd_billsum_tbl as b, acd_point_branch_tbl as c 
    ,(select value::numeric/100 as nds from cmd_tax_tbl as a,cmi_tax_tbl as b 
       where a.id_tax=b.id and b.ident=''tax'' and a.date_inst=
        (select max(date_inst) from cmd_tax_tbl where date_inst<=mg)) as e
   where c.id_doc=r.id_bill and b.id_doc=r.id_bill) as k;

  select into idbs max(id_bills) from acd_addsubs_tbl as a where a.id_dsubs=r.id;

  update acd_addsubs_tbl set dem_s_norm=k.dem_s_norm
    ,s_norm_sum=round(k.dem_s_norm*k.tar*k.zk,2)
    ,s_norm_sum_tax=round(round(k.dem_s_norm*k.tar*k.zk,2)*nds,2) 
   from 
   (select (select r.dem_s_norm-coalesce(sum(dem_s_norm),0) from acd_addsubs_tbl as a 
      where a.id_dsubs=r.id and a.id_bills<>idbs) as dem_s_norm 
    ,(select d.value*e.value from cmm_currency_tbl as d, acd_tarif_tbl as e 
      where e.id=m.id_sumtariff and d.id_currency=e.idk_currency) as tar
    ,(select koef from acd_zone_tbl where m.id_zonekoef=acd_zone_tbl.id) as zk
    ,(select value::numeric/100 as nds from cmd_tax_tbl as a,cmi_tax_tbl as b 
        where a.id_tax=b.id and b.ident=''tax'' and a.date_inst=
        (select max(date_inst) from cmd_tax_tbl where date_inst<=mg)) as nds 
   from acd_addsubs_tbl as l,acd_billsum_tbl as m where m.id=l.id_bills 
        and l.id_bills=idbs) as k 
   where id_bills=idbs;

  update acd_subs_tbl set abn_sum=abn_sum+sm,abn_sum_tax=abn_sum_tax+sm_t 
  from 
  (select sum(s_norm_sum) as sm,sum(s_norm_sum_tax) as sm_t 
   from acd_addsubs_tbl where id_dsubs=r.id) as a 
  where acd_subs_tbl.id=r.id;
end loop;

 if (select count(*) from acm_salsubs_tbl where id_client=idcl and mmgg=mg)>0 then
   update acm_salsubs_tbl set s_sal_e=(coalesce(a.s_sal_e,0)+coalesce(b.pay_sum,0)-coalesce(b.abn_sum,0)-coalesce(c.s_sum,0))
     ,s_tax_e=(coalesce(a.s_tax_e,0)+coalesce(b.pay_sum_tax,0)-coalesce(b.abn_sum_tax,0)-coalesce(c.s_sum_tax,0))
     ,abn_sum=coalesce(b.abn_sum,0),abn_sum_tax=coalesce(b.abn_sum_tax,0),pay_sum=coalesce(b.pay_sum,0)
     ,pay_sum_tax=coalesce(b.pay_sum_tax,0),s_sum=coalesce(c.s_sum,0),s_sum_tax=coalesce(c.s_sum_tax,0) 
   from
     ((select sum(s_sum) as s_sum,sum(s_sum_tax) as s_sum_tax 
        from acm_subs_tbl where id_client=idcl and flock=0) as c 
     left join 
     (select s_sal_e,s_tax_e from acm_salsubs_tbl where id_client=idcl 
       and flock=1 and mmgg=date_trunc(''month'',date_mii(mg,28))) as a 
     on True) 
     left join 
     (select sum(pay_sum) as pay_sum,sum(pay_sum_tax) as pay_sum_tax
        ,sum(abn_sum) as abn_sum,sum(abn_sum_tax) as abn_sum_tax  
        from acd_subs_tbl where id_client=idcl and flock=0) as b on True
    where acm_salsubs_tbl.id_client=idcl and mmgg=mg;
--  Raise Notice ''Sal updated'';
 else
   insert into acm_salsubs_tbl(id_client,s_sal_e,s_tax_e,abn_sum,abn_sum_tax
    ,pay_sum,pay_sum_tax,s_sum,s_sum_tax) 
   select idcl,(coalesce(s_sal_e,0)+coalesce(pay_sum,0)-coalesce(abn_sum,0)-coalesce(s_sum,0))
    ,(coalesce(s_tax_e,0)+coalesce(pay_sum_tax,0)-coalesce(abn_sum_tax,0)-coalesce(s_sum_tax,0))
    ,coalesce(abn_sum,0),coalesce(abn_sum_tax,0),coalesce(pay_sum,0)
    ,coalesce(pay_sum_tax,0),coalesce(s_sum,0),coalesce(s_sum_tax,0) 
   from (((select 1) as d left join
     (select sum(s_sum) as s_sum,sum(s_sum_tax) as s_sum_tax 
        from acm_subs_tbl where id_client=idcl and flock=0) as c on True)  
     left join 
     (select s_sal_e,s_tax_e from acm_salsubs_tbl where id_client=idcl 
       and flock=1 and mmgg=date_trunc(''month'',date_mii(mg,28))) as a 
     on True) 
     left join 
     (select sum(pay_sum) as pay_sum,sum(pay_sum_tax) as pay_sum_tax
        ,sum(abn_sum) as abn_sum,sum(abn_sum_tax) as abn_sum_tax  
        from acd_subs_tbl where id_client=idcl and flock=0) as b on True;

--  Raise Notice ''Sal inserted'';
 end if;
 if ((select count(*) from acm_salsubs_tbl where flock=0 and id_client=idcl 
     and s_sal_e=0 and s_tax_e=0 and abn_sum=0 and abn_sum_tax=0 and pay_sum=0 
     and pay_sum_tax=0 and s_sum=0 and s_sum_tax=0)>0 or 
     (select count(*) from acm_salsubs_tbl where flock=0 and id_client=idcl)=0) 
    and 
    ((select count(*) from acm_salsubs_tbl where flock=1 and id_client=idcl 
     and s_sal_e=0 and mmgg=date_trunc(''month'',date_mii(mg,28)) 
     and s_tax_e=0 and abn_sum=0 and abn_sum_tax=0 and pay_sum=0 
     and pay_sum_tax=0 and s_sum=0 and s_sum_tax=0)>0  or 
    (select count(*) from acm_salsubs_tbl where flock=1 and id_client=idcl 
     and mmgg=date_trunc(''month'',date_mii(mg,28)))=0) then
  delete from acm_salsubs_tbl where flock=0 and id_client=idcl; 
  rs:=false;
 else 
  rs:=true;
 end if;
Return rs;
end;
' Language 'plpgsql';


