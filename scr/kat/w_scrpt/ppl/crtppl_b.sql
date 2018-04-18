drop function start_popl_calc(int); 
create function start_popl_calc(int) Returns boolean As'
Declare
idcl Alias for $1;
rs boolean;
rs1 boolean;
iddc int;
mg date;
mg1 date;
mfo_s int;
acc_s numeric;
nds numeric;
dte date;
dtb date;
dtb1 date;
r_ind record;
rp record;
st text;
begin
--delete from sys_error_tbl where nam=''start_popl_calc'';
----------------------------------------------
select into mg (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''||substr(value_ident,1,2))::date 
from syi_sysvars_tmp where ident=''mmgg'';
 mg1:=date_trunc(''month'',date_mii(mg,-32))::date;
for rp in select * from cli_account_tbl as a inner join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=''act_ee'' loop
  mfo_s:=rp.mfo;
  acc_s:=to_number(rp.account,''99999999999999'');
end loop;

select into nds value::numeric/100 from cmd_tax_tbl as a 
  inner join (select * from cmi_tax_tbl where ident=''tax'') as b 
   on (a.id_tax=b.id)
 where a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
   where a.date_inst<=mg and b.ident=''tax'');


select into dte max(a.dat_ind) from acd_indication_tbl as a 
  inner join (select * from acm_headindication_tbl as a1 inner join 
   (select id from dci_document_tbl where ident=''rep_pwr'' 
    --  or ident=''chn_cnt''
    ) as a2 on (a1.idk_document=a2.id) 
   where flag_priv) as b on (a.id_doc=b.id_doc) 
   left join acm_bill_tbl as c on (a.id=c.id_ind and a.id_client=c.id_client)
  where a.mmgg<mg1 and a.id_cor_doc is null and a.id_previndic is not null 
   and a.id_client=idcl and (a.flock=0 or (a.flock=1 and 
    (c.id_doc is null or c.flock=0))); 


if dte is not null then
  dtb:=null;
 select into dtb1 max(a.dat_ind)  from acd_indication_tbl as a 
  inner join (select * from acm_headindication_tbl as a1 inner join 
   (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'' or ident=''kor_ind'') as a2 
    on (a1.idk_document=a2.id) 
   where flag_priv) as b on (a.id_doc=b.id_doc) 
   left join acm_bill_tbl as c on (a.id=c.id_ind and a.id_client=c.id_client)
  where a.id_cor_doc is null
   and a.id_client=idcl 
   and c.id_doc is not null and a.dat_ind<dte and a.mmgg<mg1;

 if dtb1 is not null then

  for r_ind in select a.id,b.id_previndic 
    from (select c1.* from acd_indication_tbl  as c1 
      inner join (select * from acm_headindication_tbl as a1 inner join 
   (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'' or ident=''kor_ind'') as a2 
    on (a1.idk_document=a2.id)) c2 on (c1.id_doc=c2.id_doc) 
     where c1.mmgg<mg1 and c1.id_client=idcl and c1.dat_ind=dtb1 
       and id_cor_doc is null
     ) as a 
    left join acd_indication_tbl as b on (a.id=b.id_previndic) loop 

    if r_ind.id_previndic is not null then
      dtb:=dtb1;
    else 
     select into dtb min(a.dat_ind)  from acd_indication_tbl as a 
      inner join (select * from acm_headindication_tbl as a1 inner join 
      (select id from dci_document_tbl where ident=''rep_pwr'' 
       or ident=''chn_cnt'' or ident=''kor_ind'' or ident=''set_cnt'' 
       or ident=''beg_ind'') as a2 
      on (a1.idk_document=a2.id) 
       where flag_priv) as b on (a.id_doc=b.id_doc) 
      left join acm_bill_tbl as c on (a.id=c.id_ind and a.id_client=c.id_client)
      inner join acd_indication_tbl as d on (a.id=d.id_previndic)
      where a.id_cor_doc is null and a.id_previndic is not null 
       and a.id_client=idcl 
       and c.id_doc is null and a.dat_ind>dtb1 and a.dat_ind<dte and a.mmgg<mg1;
    end if;
  end loop;

 end if;


 if dtb is null then
   select into dtb min(a.dat_ind)  from acd_indication_tbl as a 
   inner join (select * from acm_headindication_tbl as a1 inner join 
    (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'' or ident=''kor_ind'' or ident=''set_cnt'' 
      or ident=''beg_ind'') as a2 
    on (a1.idk_document=a2.id) 
   where flag_priv) as b on (a.id_doc=b.id_doc) 
   left join acm_bill_tbl as c on (a.id=c.id_ind and a.id_client=c.id_client) 
   inner join acd_indication_tbl as d on (a.id=d.id_previndic)
  where a.id_cor_doc is null
   and a.id_client=idcl 
   and c.id_doc is null and a.dat_ind<dte and a.mmgg<mg1;
 end if;

 if dtb is null then
--  Raise Notice ''NO begin indications'';
  Return false;
 end if; 
else
-- Raise NOtice ''NO end indications'';
 Return false;
end if;

select into r_ind a.*,c.id_ind,c.id_doc as bill,b.flock as flck,c.flock as flck1  
  from acd_indication_tbl as a 
  inner join (select * from acm_headindication_tbl as a1 inner join 
   (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'') as a2 on (a1.idk_document=a2.id) 
   where flag_priv) as b on (a.id_doc=b.id_doc) 
   left join acm_bill_tbl as c on (a.id=c.id_ind and a.id_client=c.id_client) 
  where a.id_cor_doc is null and a.id_previndic is not null 
   and a.id_client=idcl and a.dat_ind=dte;

if r_ind.id_ind is not null then
  if r_ind.flck=0 and r_ind.flck1=0 then 
    delete from acm_bill_tbl where id_doc=r_ind.bill;
  end if;
end if;
----------------------------------------------
if r_ind.id_ind is null or (r_ind.id_ind is not null and r_ind.flck=0 
    and r_ind.flck1=0) then 
  iddc:=crt_popl_bill(idcl,r_ind.id,dtb,dte,acc_s,mfo_s,nds,mg);
end if;


if (iddc isnull) then
  rs:=false;
  rs1:=calc_subs(idcl);
else
  rs1:=kateg_calc(iddc);
  rs1:=calc_subs(idcl);
  rs:=true;
end if;
  /*
if rs then
 insert into sys_error_tbl(nam,id_error,ident) values(''start_popl_calc'',3,''start_popl'');
else
 insert into sys_error_tbl(nam,id_error,ident) values(''start_popl_calc'',1,''start_popl'');
end if;
*/
--Raise Notice ''RESULT - %'',rs;
Return true;
--Return rs;
end;
' Language 'plpgsql';

drop function crt_popl_bill(int); 
drop function crt_popl_bill(int,int,date,date,numeric,int,numeric,date); 
create function crt_popl_bill(int,int,date,date,numeric,int,numeric,date) Returns int As'
Declare
idcl Alias for $1;
idind Alias for $2;
dtb Alias for $3;
dte Alias for $4;
acc_s Alias for $5;
mfo_s Alias for $6;
nds Alias for $7;
mg Alias for $8;
mg1 date;
iddc int; 
dt_b timestamp;
dt_e timestamp;
kdoc int;
r record;
rs int;
r1 record;
rnum text;
begin
mg1:=date_trunc(''month'',date_mii(mg,-32))::date;
select into rnum book::text||''/''||code::text from clm_client_tbl where id=idcl;
rnum:=rnum||''_''||to_char(dte,''mm'')||''-''||to_char(dte,''yyyy'');

select into kdoc id from dci_document_tbl where ident=''bill'';

--create bill
insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
                   ,mfo_self,account_self,value,value_tax,id_ind,dat_b,dat_e
                   ,idk_doc,mmgg,mmgg_bill,flag_priv) 
select a.id,now(),rnum,now()::date
 ,idcl,mfo_s,acc_s,0.0,0.0,idind,dtb,dte,kdoc,mg,mg,true  
from aci_pref_tbl as a where ident=''act_ee'';

iddc:=currval(''dcm_doc_seq'');

for r in select a.id_point,a.id_tariff
         ,case when b.dt_b<=dtb then dtb else b.dt_b end as dat_b
         ,case when coalesce(b.dt_e,dte)>=dte then dte else b.dt_e end as dat_e 
       from eqm_privmeter_tbl as a inner join eqm_equipment_h as b 
          on (a.id_point=b.id)
          where a.id_client=idcl and b.dt_b<dte and coalesce(b.dt_e,dte)>dtb loop

--fill acd_point_branch_tbl
  insert into acd_point_branch_tbl(id_doc,dt,id_tree,id_point,id_p_point
    ,dat_b,dat_e,id_client,id_rclient,id_border,count_lost)  
  select iddc,now()
   ,a.id_tree,a.code_eqp,null
   ,case when a.dt_b<=r.dat_b then r.dat_b else a.dt_b end as dat_b
   ,case when coalesce(a.dt_e,r.dat_e)>=r.dat_e then r.dat_e else a.dt_e end as dat_e 
   ,idcl,idcl,0,0 
   from eqm_eqp_tree_h as a where a.code_eqp=r.id_point and a.dt_b<r.dat_e and 
    coalesce(a.dt_e,r.dat_e)>r.dat_b; 

--fill acd_met_kndzn_tbl
  insert into acd_met_kndzn_tbl(id_doc,dt,id_point,id_meter,num_eqp,kind_energy
   ,id_zone,k_tr,id_type_eqp,dat_b,dat_e,b_val,e_val,id_parent_doc,met_demand
   ,ktr_demand,ident,id_ind) 
   select iddc,now()
    ,r.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.id_zone,a.ktr
   ,a.id_typemet,b.dat_ind,a.dat_ind,b.value,a.value,a.id_doc
   ,calc_ind_pr(a.value,b.value,a.car)
   ,round(calc_ind_pr(a.value,b.value,a.car)*a.ktr,0),1
   ,a.id
  from 
  (select c.*,coalesce((select d.amperage_nom/d.amperage2_nom from eqi_compensator_i_tbl as d where c.id_typecompa=d.id),1)*
   coalesce((select e.voltage_nom/e.voltage2_nom from eqi_compensator_i_tbl as e where c.id_typecompu=e.id),1) as ktr 
   ,(select carry from eqi_meter_tbl where id=c.id_typemet) as car
   from acd_indication_tbl as c 
    inner join (select * from acm_headindication_tbl as a1 inner join 
     (select id from dci_document_tbl where ident=''rep_pwr'' 
      or ident=''chn_cnt'' or ident=''kor_ind'') as a2 
       on (a1.idk_document=a2.id) where flag_priv) as b on (c.id_doc=b.id_doc) 
   where c.mmgg<mg1 and id_cor_doc is null and (c.dat_ind<=r.dat_e 
      and c.dat_ind>r.dat_b) and c.id_previndic is not null 
      and c.id_client=idcl ) as a 
  Left Join (select * from acd_indication_tbl) as b on a.id_previndic=b.id;

--fill acd_pwr_demand_tbl
  insert into acd_pwr_demand_tbl(id_doc,dt,id_point,kind_energy,id_zone,dat_b,dat_e,
             sum_demand,fact_demand,sum_losts,fact_losts,ident)
   select iddc,now(),r.id_point,a.kind_energy,a.id_zone,d.dat_b,d.dat_e,a.sm,a.sm 
          ,0,0,1
   from
   (select sum(ktr_demand) as sm,kind_energy,id_zone 
    from acd_met_kndzn_tbl where id_point=r.id_point and kind_energy=1 
     and id_doc=iddc
    group by kind_energy,id_zone) as a
   left join
   (select b.kind_energy,b.id_zone,dat_b,dat_e from 
    (select max(dat_e) as dat_e,kind_energy,id_zone from acd_met_kndzn_tbl 
     where id_point=r.id_point and kind_energy=1 
     and id_doc=iddc
     group by kind_energy,id_zone) as b
   join
   (select min(dat_b) as dat_b,kind_energy,id_zone from acd_met_kndzn_tbl 
     where id_point=r.id_point and kind_energy=1 
     and id_doc=iddc
     group by kind_energy,id_zone) as c 
     on (b.kind_energy=c.kind_energy and b.id_zone=c.id_zone)) as d 
     on (a.kind_energy=d.kind_energy and a.id_zone=d.id_zone);

--fill acd_pnt_tarif

insert into acd_pnt_tarif(id_doc,dt,id_point,id_tarif,dat_b,dat_e)  
select iddc,now(),k.code_eqp,k.id_tarif,k.dt_b1,max(k.dt_e1) 
 from (select a.code_eqp,coalesce(a.id_tarif,0) as id_tarif 
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_tarif,0)),''id_tarif'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_tarif,0)),''id_tarif'',''eqm_point_h'',a.code_eqp) end as dt_b1 
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e1 
from  (select * from acd_point_branch_tbl where id_doc=iddc) as b 
   inner join  eqm_point_h as a
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by k.code_eqp,k.id_tarif,k.dt_b1; 

--calc summs
---insert into acd_billsum_tbl()
insert into acd_billsum_tbl(id_doc,dt,id_point,kind_energy,id_tariff
          ,id_sumtariff,id_zone,id_zonekoef,demand_val,sum_val,dt_begin,dt_end) 
select iddc,now(),r.id_point,1,id_tarif,id_tarval,id_zone,id_znk
       ,calc_dem 
       ,round(k_curr*tar*koef*calc_dem,2) as calc_sum
       ,dat_b,dat_e 
from
(select r.id_point,d.id_zone,d.id_znk,d.koef,e.id_tarif,e.id_tarval
        ,e.idk_currency,e.value as tar,max(d.dat_b,e.dat_b) as dat_b
        ,min(d.dat_e,e.dat_e) as dat_e,d.dem_pay
        ,round(d.dem_pay*date_mi(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem  
        ,(select value from cmm_currency_tbl where id_currency=e.idk_currency) as k_curr 
 from 
 (
 select r.id_point,a.id_zone,c.id_znk,max(c.dt_begin,a.dat_b) as dat_b
      ,min(c.dt_end,a.dat_e) as dat_e,c.koef,a.dem_pay,a.fact_demand 
 from 
 (select id_zone,dat_b,dat_e,fact_demand
   ,fact_demand::numeric/date_mi(dat_e::date,dat_b::date) as dem_pay  
   from acd_pwr_demand_tbl where id_point=r.id_point and id_doc=iddc) as a 
 left join 
 (select a.id as id_znk,a.id_zone,dt_begin,koef
      ,coalesce((select min(dt_begin) from acd_zone_tbl as b 
         where a.id_zone=b.id_zone and b.dt_begin>a.dt_begin),dte) as dt_end 
  from acd_zone_tbl as a 
   where coalesce((select min(dt_begin) from acd_zone_tbl as b 
         where a.id_zone=b.id_zone and b.dt_begin>a.dt_begin),dte)>dtb) as c
 on (a.id_zone=c.id_zone and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
 ) as d 
Inner Join 
 (
 select r.id_point,a.id_tarif,c.id_tarval,max(c.dt_begin,a.dat_b) as dat_b
   ,min(c.dt_end,a.dat_e) as dat_e,c.idk_currency,c.value 
  from 
   (select * from acd_pnt_tarif where id_point=r.id_point and id_doc=iddc) as a 
   left join 
   (select a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
       ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
         where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte) as dt_end 
   from acd_tarif_tbl as a 
    where coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte)>dtb) as c 
   on (a.id_tarif=c.id_tarif and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
 ) as e 
on (d.dat_b<e.dat_e and d.dat_e>e.dat_b) --a.id_point=b.id_point and 
) as c;

--update end calc summs
update acd_billsum_tbl set demand_val=a.calc_dem
      ,sum_val=round((a.calc_dem::numeric*(select b.value*c.value from cmm_currency_tbl as b, acd_tarif_tbl as c where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)*(select koef from acd_zone_tbl where acd_billsum_tbl.id_zonekoef=acd_zone_tbl.id)),2) 
from
(select id_zone,dat_b,dat_e,fact_demand
   ,fact_demand-coalesce((select sum(demand_val) from acd_billsum_tbl 
                   where id_doc=iddc and id_zone=a1.id_zone 
                   and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem 
   from acd_pwr_demand_tbl as a1 where id_point=r.id_point and id_doc=iddc) as a 
where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.dt_end=a.dat_e 
      and acd_billsum_tbl.id_zone=a.id_zone;
---update head_summs
update acm_bill_tbl set value = coalesce(a.calc_sum,0),value_tax 
   = round(coalesce(a.calc_sum,0)::numeric*nds,2)
   , demand_val=coalesce(a.dem,0) 
from (select sum(sum_val) as calc_sum,sum(demand_val) as dem 
  from acd_billsum_tbl where id_doc=iddc) as a 
 where acm_bill_tbl.id_doc=iddc;
--create bill
end loop;

if (select value as val from acm_bill_tbl where id_doc=iddc)<=0 then
 --rs:=null;
-- delete from acm_bill_tbl where id_doc=iddc; --idk_document
 --Raise Notice ''Sum = 0 !!!!'';
else
 rs:=iddc;
end if;


Return rs;
end;
' Language 'plpgsql';

drop function del_popl_bill(int,int); 
/*
create function del_popl_bill(int,int) Returns boolean As'
Declare
idcl Alias for $1;
r_ind Alias for $2;
begin
 delete from acm_bill_tbl where id_client=idcl and flock=0 
  and id_ind=r_ind; --idk_document
 Return true;
end;
' Language 'plpgsql';
  */

