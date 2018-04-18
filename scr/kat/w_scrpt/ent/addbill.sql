drop function crt_prebill(int);
drop function crt_addbill(int);

/*select crt_ttbl();
select crt_addbill(23684) as boolch
*/
-- Function: crt_addbill(integer)

-- DROP FUNCTION crt_addbill(integer);

CREATE OR REPLACE FUNCTION crt_addbill(integer)
  RETURNS integer AS
$BODY$
Declare
iddoc Alias for $1;
mfo_s int;
acc_s numeric;
nds numeric;
r record;
r1 record;
kdoc int;
iddc int;
ch_val text;
psection int;
begin
delete from act_res_notice;
ch_val:='';
iddc:=null;
raise notice '1';
for r in select a.*,b.ident from acm_headdem_tbl as a inner join 
    dci_document_tbl as b on (a.idk_doc=b.id) where id_doc=iddoc loop
 if r.mmgg<(select (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||
      '-'||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident='mmgg') then
  Raise Notice 'Period is closed!!!';
  Return null;
 end if;
 raise notice '2';
 /* if r.id_bill is not null then 
    delete from acm_bill_tbl where id_doc=r.id_bill;
    update acm_headdem_tbl set id_bill=null where id_doc=iddoc and not exists 
    (select a.id_doc from acm_bill_tbl as a where a.id_doc=acm_headdem_tbl.id_bill);  
   end if;
 */
 delete from acm_bill_tbl where id_ind=iddoc and mmgg=r.mmgg and idk_doc>200; -- and id_client=idcl;

 if r.kind_energy=1 then
   ch_val:='act_ee';
 else
   ch_val:='react_ee';
 end if;

 for r1 in select * from cli_account_tbl as a inner join (select int4('0'||value_ident) as val from 
          syi_sysvars_tbl where ident='id_res') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
    acc_s:=r1.account;
 end loop;
 if mfo_s is null then
   Raise Notice 'Account not found';
   insert into act_res_notice values('Account not found');
   Return null;
 end if;
 ---will be changed
  raise notice '3';
 select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident='tax' 
     and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
    where a.date_inst<=r.mmgg and b.ident='tax');

 if r.ident='avans_dem' then 
  select into kdoc id from dci_document_tbl where ident='bill_avans';
  iddc:=nextval('dcm_doc_seq');

  insert into acm_bill_tbl(id_doc,id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc
   ,dat_b,dat_e,flag_priv) 
  values(iddc,r.id_pref
   ,now(),(select 'A'||code::text from clm_client_tbl where id=r.id_client)||'_'
   ||to_char(r.reg_date,'mm')||'-'||to_char(r.reg_date,'yyyy')
   ,now()::date,r.id_client 
   ,mfo_s ,acc_s
   ,0.0,0.0
   ,(select sum(demand) from acm_demand_tbl where id_doc=r.id_doc) -- 0
   ,iddoc,r.mmgg,r.mmgg,kdoc
   ,(select min(dt_b) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select max(dt_e) from acm_demand_tbl where id_doc=r.id_doc)
   ,false);
  --iddc:=currval('dcm_doc_seq');

  raise notice '4';
  ----acd_pwr_demand_tbl
  insert into acd_pwr_demand_tbl(id_doc,id_point,kind_energy,id_zone,dat_b,dat_e
   ,sum_demand,fact_demand,sum_losts,fact_losts,ident,mmgg)
  select iddc,id_point,r.kind_energy,0,dt_b,dt_e
  ,demand,demand 
  ,0,0,1,r.mmgg 
  from acm_demand_tbl where id_doc=r.id_doc;
 ----acd_billsum_tbl
  insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,id_tariff,
    id_zone ,id_sumtariff,demand_val,sum_val,id_doc,mmgg)
  select id_point,r.kind_energy,dt_b,dt_e,id_tariff,
       id_zone
       ,id_tarval
       ,calc_dem 
       ,round(k_curr*tar*calc_dem,2) as calc_sum
       ,iddc,r.mmgg 
  from
   (select k.id_point,k.id_tariff,k.id_tarval,k.tar,k.dt_b,k.dt_e,id_zone
     ,round(dem_pay*date_mi(k.dt_e,k.dt_b),0) as calc_dem 
     ,(select value from cmm_currency_tbl where id_currency=k.idk_currency) as k_curr
    from 
    ( select a2.id_point,a2.id_tariff,a1.id_tarval,a1.idk_currency,a1.value as tar
      ,case when a2.dt_b<=a1.dt_begin then a1.dt_begin else a2.dt_b end as dt_b
      ,case when a2.dt_e>=a1.dt_end then a1.dt_end else a2.dt_e end as dt_e
      ,demand::numeric/date_mi(a2.dt_e,a2.dt_b) as dem_pay,id_zone
     from 
      (select * from acm_demand_tbl where id_doc=iddoc) as a2 left join 
      (select c.id,a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
        ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif 
          and b.dt_begin>a.dt_begin),c.dt_e) as dt_end 
      from (select * from acm_demand_tbl where id_doc=iddoc) as c inner join 
       acd_tarif_tbl as a on (a.id_tarif=c.id_tariff and a.dt_begin<c.dt_e)) as a1
      on (a2.id=a1.id and a2.dt_b<a1.dt_end and a2.dt_e>a1.dt_begin) 
     ) as k ) as k1;
   
   update acd_billsum_tbl set demand_val=a.calc_dem
      ,sum_val=round((a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
        where c.id=acd_billsum_tbl.id_sumtariff 
           and b.id_currency=c.idk_currency)),2) 
   from (select a1.id_point,dat_b,dat_e,fact_demand
     ,(fact_demand)-coalesce((select sum(demand_val) from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point 
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem 
    from acd_pwr_demand_tbl as a1 
     where a1.id_doc=iddc) as a 
    where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.id_point 
      and acd_billsum_tbl.dt_end=a.dat_e;

    Raise Notice 'upd acm_bill_tbl';
    update acm_bill_tbl set value = coalesce(a.calc_sum,0)
     ,value_tax=coalesce(round(a.calc_sum*nds,2),0)
       --   ,demand_val=coalesce(a.dem,0) 
     from (select sum(sum_val) as calc_sum
         --,sum(demand_val) as dem  
       from acd_billsum_tbl where id_doc=iddc) as a 
     where acm_bill_tbl.id_doc=iddc; 
     delete from acd_pwr_demand_tbl where id_doc=iddc;
    Raise Notice 'END upd acm_bill_tbl';

 end if;
 raise notice '5';
 if r.ident='temp_dem' then 
   select into kdoc id from dci_document_tbl where ident='bill_temp';
   iddc:=nextval('dcm_doc_seq');
   --create bill
   insert into acm_bill_tbl(id_doc,id_pref,dt,reg_num, reg_date,id_client
    ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
    ,mmgg_bill,idk_doc
    ,dat_b,dat_e,flag_priv) 
   values(iddc,r.id_pref
    ,now(),(select 'T'||code::text from clm_client_tbl where id=r.id_client)||'_'
    ||to_char(r.reg_date,'mm')||'-'||to_char(r.reg_date,'yyyy') 
    ,now()::date,r.id_client
    ,mfo_s,acc_s
    ,0.0,0.0,0
    ,iddoc,r.mmgg,r.mmgg,kdoc
    ,(select min(dt_b) from acm_demand_tbl where id_doc=r.id_doc)
    ,(select max(dt_e) from acm_demand_tbl where id_doc=r.id_doc)
    ,false);
    -- iddc:=currval('dcm_doc_seq');
    ----acd_pwr_demand_tbl
    insert into acd_pwr_demand_tbl(id_doc,id_point,kind_energy,id_zone,dat_b,dat_e
      ,sum_demand,fact_demand,sum_losts,fact_losts,ident,mmgg)
    select iddc,id_point,r.kind_energy,0,dt_b,dt_e,round(power*wtm::numeric,0)
     ,round(power*wtm::numeric,0),0,0,1,r.mmgg 
    from acm_demand_tbl where id_doc=r.id_doc;
    ----acd_billsum_tbl
    insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,id_tariff,
     id_zone
     ,id_sumtariff,demand_val,sum_val,id_doc,mmgg)
    select id_point,r.kind_energy,dt_b,dt_e,id_tariff,id_zone
       ,id_tarval
       ,calc_dem 
       ,round(k_curr*tar*calc_dem,2) as calc_sum
       ,iddc,r.mmgg 
    from
    (
      select k.id_point,k.id_tariff,k.id_tarval,k.tar,k.dt_b,k.dt_e,id_zone
      ,round(dem_pay*date_mi(k.dt_e,k.dt_b),0) as calc_dem 
      ,(select value from cmm_currency_tbl where id_currency=k.idk_currency) as k_curr
        from 
       (   select a2.id_point,a2.id_tariff,a1.id_tarval,a1.idk_currency,a1.value as tar
          ,case when a2.dt_b<=a1.dt_begin then a1.dt_begin else a2.dt_b end as dt_b
          ,case when a2.dt_e>=a1.dt_end then a1.dt_end else a2.dt_e end as dt_e
         ,round(power*wtm::numeric,0)::numeric/date_mi(a2.dt_e,a2.dt_b) as dem_pay
      from 
      (select * from acm_demand_tbl where id_doc=iddoc) as a2 left join 
       (select c.id,a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
         ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif 
          and b.dt_begin>a.dt_begin),c.dt_e) as dt_end 
       from (select * from acm_demand_tbl where id_doc=iddoc) as c inner join 
        acd_tarif_tbl as a on (a.id_tarif=c.id_tariff and a.dt_begin<c.dt_e)) as a1
       on (a2.id=a1.id and a2.dt_b<a1.dt_end and a2.dt_e>a1.dt_begin) 
     ) as k ) as k1;
   
    update acd_billsum_tbl set demand_val=a.calc_dem
      ,sum_val=round((a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
        where c.id=acd_billsum_tbl.id_sumtariff 
           and b.id_currency=c.idk_currency)),2) 

    from (select a1.id_point,dat_b,dat_e,fact_demand
    ,(fact_demand)-coalesce((select sum(demand_val) from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point 
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem 
   from acd_pwr_demand_tbl as a1 
     where a1.id_doc=iddc) as a 
   where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.id_point 
      and acd_billsum_tbl.dt_end=a.dat_e;

   Raise Notice 'upd acm_bill_tbl';
   update acm_bill_tbl set value = coalesce(a.calc_sum,0)
    ,value_tax=coalesce(round(a.calc_sum*nds,2),0)
    ,demand_val=coalesce(a.dem,0) 
    from (select sum(sum_val) as calc_sum,sum(demand_val) as dem  
       from acd_billsum_tbl where id_doc=iddc) as a 
   where acm_bill_tbl.id_doc=iddc; 
   Raise Notice 'END upd acm_bill_tbl';

end if;

if (r.ident='add_pntdem') or (r.ident='div_sum') or (r.ident='trans_ee') then 
  raise notice 'add_pntdem';
  select into kdoc id from dci_document_tbl where ident='bill_addp';
   if  (r.ident='div_sum')    then
    select into kdoc id from dci_document_tbl where ident='bill_div';
   end if;
  iddc:=nextval('dcm_doc_seq');
  --create bill
  insert into acm_bill_tbl(id_doc,id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc
   ,dat_b,dat_e,flag_priv) 
  values(iddc,r.id_pref
   ,now() ,(select 'AD'||code::text from clm_client_tbl where id=r.id_client)||'_'
   ||to_char(r.reg_date,'mm')||'-'||to_char(r.reg_date,'yyyy') 
   ,now()::date,r.id_client
   ,mfo_s,acc_s 
   ,(select sum(sum_demand) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select sum(case when sum_tax is null then round(sum_demand*nds,2) 
      else sum_tax end) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select sum(demand) from acm_demand_tbl where id_doc=r.id_doc)
   ,iddoc,r.mmgg
   ,coalesce((select date_trunc('month',max(dt_e)) from acm_demand_tbl 
         where id_doc=r.id_doc),r.mmgg)--r.mmgg
   ,kdoc
   ,(select min(dt_b) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select max(dt_e) from acm_demand_tbl where id_doc=r.id_doc)
   ,false);

  if (r.ident='trans_ee') then 
    update acm_bill_tbl set value_tax=round(value*nds,2) where id_doc=iddc;
    update acm_bill_tbl set reg_date=(mmgg+interval '1 month'-interval '1 day') where id_doc=iddc;
  end if; 
  raise notice 'ch-';
   insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,id_tariff,id_zone
   ,demand_val,sum_val,id_doc,mmgg)

  select id_point,r.kind_energy,dt_b,dt_e,id_tariff,id_zone,demand,sum_demand,iddc,r.mmgg  
   from acm_demand_tbl where id_doc=r.id_doc;

  ----acd_pwr_demand_tbl
  if ((r.ident='add_pntdem')  or (r.ident='div_sum')) then
    insert into acd_pwr_demand_tbl(id_doc,id_point,kind_energy,id_zone,dat_b,dat_e
     ,sum_demand,fact_demand,sum_losts,fact_losts,ident,mmgg)
    select iddc,id_point,r.kind_energy,0,dt_b,dt_e,demand,demand,0,0,1,r.mmgg 
    from acm_demand_tbl where id_doc=r.id_doc;
  end if;
 
end if;

if r.ident='cor_sum' then 
 raise notice 'cor_sum';
 select into kdoc id from dci_document_tbl where ident='bill_cors';
  iddc:=nextval('dcm_doc_seq');
 --create bill
 insert into acm_bill_tbl(id_doc,id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc
   ,dat_b,dat_e,flag_priv) 
 values(iddc,r.id_pref
   ,now() ,(select 'AS'||code::text from clm_client_tbl where id=r.id_client)||'_'
   ||to_char(r.reg_date,'mm')||'-'||to_char(r.reg_date,'yyyy') 
   ,now()::date ,r.id_client
   ,mfo_s,acc_s
   ,(select sum(sum_demand) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select sum(case when sum_tax is null then round(sum_demand*nds,2) 
      else sum_tax end) from acm_demand_tbl where id_doc=r.id_doc)
   ,0
   ,iddoc,r.mmgg
   ,coalesce((select date_trunc('month',max(dt_e)) from acm_demand_tbl 
         where id_doc=r.id_doc),r.mmgg)
   ,kdoc
   ,(select min(dt_b) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select max(dt_e) from acm_demand_tbl where id_doc=r.id_doc)
   ,false);

 --iddc:=currval('dcm_doc_seq');

----acd_billsum_tbl
 insert into acd_billsum_tbl(id_point,kind_energy,id_zone,dt_begin,dt_end,id_tariff
  ,demand_val,sum_val,id_doc,mmgg)
 select coalesce(id_point,0),r.kind_energy,id_zone,dt_b,dt_e,id_tariff
   ,0,sum_demand,iddc,r.mmgg  
  from acm_demand_tbl where id_doc=r.id_doc;
end if;

if r.ident='add_act' then 
 raise notice 'add_act';
 select into kdoc id from dci_document_tbl where ident='bill_act';
 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc
   ,dat_b,dat_e,flag_priv) 
 values(r.id_pref
   ,now() ,(select 'AD'||code::text from clm_client_tbl where id=r.id_client)||'_'
   ||to_char(r.reg_date,'mm')||'-'||to_char(r.reg_date,'yyyy') 
   ,now()::date,r.id_client
   ,mfo_s,acc_s 
   ,(select sum(sum_demand) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select sum(case when sum_tax is null then round(sum_demand*nds,2) 
      else sum_tax end) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select sum(demand) from acm_demand_tbl where id_doc=r.id_doc)
   ,iddoc,r.mmgg
   ,coalesce((select date_trunc('month',max(dt_e)) from acm_demand_tbl 
         where id_doc=r.id_doc),r.mmgg)--r.mmgg
   ,kdoc
   ,(select min(dt_b) from acm_demand_tbl where id_doc=r.id_doc)
   ,(select max(dt_e) from acm_demand_tbl where id_doc=r.id_doc)
   ,false);
 iddc:=currval('dcm_doc_seq');
----acd_billsum_tbl
 insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,id_tariff,id_zone
  ,demand_val,sum_val,id_doc,mmgg)
 select id_point,r.kind_energy,dt_b,dt_e,id_tariff,id_zone,demand,sum_demand,iddc,r.mmgg  
  from acm_demand_tbl 
  where id_doc=r.id_doc;

----acd_pwr_demand_tbl
 insert into acd_pwr_demand_tbl(id_doc,id_point,kind_energy,id_zone,dat_b,dat_e
   ,sum_demand,fact_demand,sum_losts,fact_losts,ident,mmgg)
 select iddc,id_point,r.kind_energy,id_zone,dt_b,dt_e,demand,demand,0,0,1,r.mmgg 
  from acm_demand_tbl where id_doc=r.id_doc;
end if;

update acd_billsum_tbl set id_area=coalesce(a.code_eqp_inst,0) 
 from (select e.name_eqp,e.type_eqp,h.code_eqp,h.code_eqp_inst,h.dt_b,h.dt_e
           from eqm_compens_station_inst_h h left join eqm_area_tbl a on a.code_eqp= h.code_eqp_inst,
               eqm_equipment_tbl e,acd_billsum_tbl bs  
               where bs.id_doc=iddc and bs.id_point=h.code_eqp and  
              bs.dt_begin>=h.dt_b
             and bs.dt_end<=coalesce(h.dt_e,bs.dt_end) and
             e.id=a.code_eqp and type_eqp=11
      ) a 
where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.code_eqp and  acd_billsum_tbl.dt_begin>=a.dt_b
            and acd_billsum_tbl.dt_end<=coalesce(a.dt_e,acd_billsum_tbl.dt_end);

select into psection id_section from clm_statecl_h 
  where id_client=r.id_client and
  mmgg_b=(select max(mmgg_b)  from clm_statecl_h as scl2 
           where scl2.id_client = r.id_client and scl2.mmgg_b <= date_trunc('month', r.reg_date )
         );

if psection=201 or psection=202 or psection=204 then
raise notice 'form  2-kr for %',psection;
 
if r.mmgg <='2012-12-01'::date then 
 if r.ident='add_pntdem' then 
 raise notice ' crt_dem2krmmgg_area    2222';
    perform crt_dem2krmmgg(r.id_client,r.mmgg);
 end if;
else 
 if r.ident='add_pntdem' then 
  raise notice ' crt_dem2krmmgg_area';
  perform crt_dem2krmmgg_area(r.id_client,r.mmgg);
 end if;
end if;
else
raise notice 'need not 2-kr for %',psection;
end if;



end loop;

if iddc is not null then
  update acm_headdem_tbl set id_bill=iddc where id_doc=iddoc;
end if;

update acd_billsum_tbl set id_zonekoef=zk.id from 
(
select z.*,dt_b,mz.id_bill from acd_zone_tbl z, 
(select z.id_zone,max(z.dt_begin) as dt_begin,b.dt_begin   as dt_b ,b.id as id_bill from acd_zone_tbl z,
(select id,id_zone,dt_begin from acd_billsum_tbl where id_doc=iddc) b where z.dt_begin<=b.dt_begin and z.id_zone=b.id_zone group by z.id_zone,b.dt_begin,b.id )  mz
where z.id_zone=mz.id_zone and z.dt_begin=mz.dt_begin) zk
where zk.id_bill=acd_billsum_tbl.id;
                /*
update acd_billsum_tbl set id_sumtariff=st.id from 
acd_tariff_tbl st
where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_tariff=st.id_tarif 
 
   and id_sumtariff is null;
*/


Return iddc;
end;
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION crt_addbill(integer)
  OWNER TO local;



