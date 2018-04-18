

--set client_encoding='win';

CREATE INDEX acd_point_branch_doc_key
  ON acd_point_branch_tbl
  USING btree
  (id_doc,id_point);

--drop function abn_bill(int,int,int,date,date,date); 
--drop function abn_bill(int,int,int,date,date,date,int); 
create or replace function abn_bill(int,int,int,date,date,date,int) Returns int As'
Declare
idcl Alias for $1;
idind Alias for $2;---report indications
knde Alias for $3;
mg Alias for $4;
dtb Alias for $5;
dte Alias for $6;
dt_add Alias for $7;
mfo_s int;
acc_s numeric;
flag_react int;
nds numeric;
dt_b timestamp;
dt_e timestamp;
kodres int;
r record;
rs int;
iddc int;  --id_doc
ch_val text;
kk int;
kdoc int;
cbaz int;
k_cor numeric;
datind date;
psection int;
test record;
begin
----constants
Raise Notice ''Crt_Bill1'';
select into datind reg_date from acm_headindication_tbl where id_doc=idind;
select into kodres value_ident from syi_sysvars_tbl where ident=''kod_res'';

--!!!!!!!!!!!!!
--return 0;




kk=3;
cbaz=1;

if knde=1 then
  select into flag_react flag_reactive from clm_statecl_h 
  where id_client=idcl and
  mmgg_b=(select max(mmgg_b)  from clm_statecl_h as scl2 
           where scl2.id_client = idcl and scl2.mmgg_b <= date_trunc(''month'', dtb )
         );
raise notice ''flag_react= %'', flag_react;  
if flag_react=5  then
  
    ch_val:=''fider_ee'';
  else
   ch_val:=''act_ee'';
  end if;
else
  ch_val:=''react_ee'';
/*
  select into k_cor b.k_corr  
     from (select case when date_mi(mg,date_trunc(''month'',coalesce(dt_re_start,''1999-01-01''))::date)/365+1<4 
            then date_mi(mg,date_trunc(''month'',coalesce(dt_re_start,''1999-01-01''))::date)/365+1 
              else 4 end as cnt
           from (select max(doc_dat) as doc_dat,id_client 
            from clm_statecl_tbl where id_client=idcl and doc_num is not null 
             group by id_client) as a left join clm_statecl_tbl as c 
        on (c.id_client=a.id_client and c.doc_dat=a.doc_dat)) as a 
         inner join acm_k_corr_tbl as b on (b.cnt_year=a.cnt);
*/
end if;
for r in select * from cli_account_tbl as a inner join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
  mfo_s:=r.mfo;
  acc_s:=to_number(r.account::varchar,''99999999999999'');
end loop;
Raise Notice ''Crt_Bill2'';
if mfo_s is null then
  Raise Notice ''Account not found'';

  insert into act_res_notice values(''Account not found'');
---  Raise Exception ''�/� ��� �� ������! (Account not found)'';
if    ch_val<>''fider_ee'' then
  Return null;
end if;
end if;

---will be changed
Raise Notice ''Crt_Bill3'';
select into nds value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
 where a.id_tax=b.id and b.ident=''tax'' 
    and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
   where a.date_inst<=mg and b.ident=''tax'');

select into kdoc id from dci_document_tbl where ident=''bill'';
--create bill
Raise Notice ''Crt_Bill4'';
insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,id_ind,mmgg
   ,mmgg_bill,idk_doc
   ,dat_b,dat_e,flag_priv) 
values((select id from aci_pref_tbl where ident=ch_val)
  ,now() ,(select code::text from clm_client_tbl where id=idcl)||''_''
  ||to_char(mg,''mm'')||''-''||to_char(mg,''yyyy'')
  ,datind,idcl
  ,mfo_s ,acc_s ,0.0,0.0,idind,mg
  ,mg,kdoc
  ,dtb,dte,false); --dat_b,dat_e
iddc:=currval(''dcm_doc_seq'');
--fill acd_point_branch_tbl

Raise Notice ''Crt_Bill5'';
--return 0;
insert into acd_difmetzone_tbl  
--(
--id_doc,dt,kind_energy,id_point_p,zone_p,id_point,zone,dt_b,dt_e,percent,demand_p,demand_calc,fact_demand_p
--   ) 
  select iddc,now()::date,d.kind_energy,d.id_point_p,
    d.zone_p,d.id_point,d.zone,d.dt_b,d.dt_e,d.percent,d.demand_p,d.demand_calc
   ,d.fact_demand_p
  from act_difmetzone_tbl d where d.id_point_p is not null;


------------
--return 0;
------------

Raise Notice ''Crt_Bill6'';
  insert into acd_point_branch_tbl(id_doc,dt,id_tree,id_point,id_p_point,dat_b
    ,dat_e,id_client,id_rclient,id_border,count_lost,mmgg,k_corr,p_point2) 
  select distinct iddc,now()::date,id_tree,a.id_point,case when b.id_client<>idcl 
     then null else a.id_p_point end,a.dat_b,a.dat_e
    ,a.id_client,a.id_rclient,a.id_border,a.count_lost,mg,a.k_corr,
 
     coalesce(case when b.id_client<>idcl then null else a.id_p_point end,0) 


    from (
          act_point_branch_tbl as a 
          left join 
             (select distinct id_client,id_point
              from act_point_branch_tbl where id_client=idcl
             ) as b 
          on a.id_p_point=b.id_point
         ) inner join 
         (select distinct id_point  from act_pnt_knd where ((kind_energy=knde and knde=1) 
          or (kind_energy in (knde,4) and knde=2))
         ) as c on (c.id_point=a.id_point)

    where (a.id_client=idcl or b.id_client=idcl);


--return 0;

Raise Notice ''Crt_Bill7'';
--fill acd_met_kndzn_tbl
for test in select a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.id_zone,a.dat_b,count(a.*) from act_met_kndzn_tbl as a right join 
     (select distinct id_point from acd_point_branch_tbl where id_doc=iddc) as b 
     on a.id_point=b.id_point where ((kind_energy=knde and knde=1) or (kind_energy in (knde,4) 
    and knde=2))  
   group by a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.id_zone,a.dat_b
   having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_branch'',100,507,''d_metkndzn'');
   insert into act_res_notice 
   values(''Double in table acd_met_kndzn_tbl'');

 return 0;
end loop;


  insert into acd_met_kndzn_tbl(id_doc,dt,id_point,id_meter,num_eqp,kind_energy
    ,id_zone,k_tr,id_type_eqp,dat_b,dat_e,b_val,e_val,id_parent_doc,met_demand
    ,ktr_demand,ident,id_ind
    ,meter_demand,calc_demand_cnt,comment_cnt,calc_demand_w,comment_w
    ,k_ts,i_ts,hand_losts,calc_demand_nocnt,p_w 
    ,mmgg)
   select iddc,now()::date,a.*,mg from act_met_kndzn_tbl as a right join 
     (select distinct id_point from acd_point_branch_tbl where id_doc=iddc) as b 
     on a.id_point=b.id_point where ((kind_energy=knde and knde=1) or (kind_energy in (knde,4) 
    and knde=2));
--fill acd_pwr_demand_tbl

 UPDATE ACT_PWR_DEMAND_TBL SET FACT_LOSTS=0 WHERE FACT_DEMAND+FACT_LOSTS<0.00;

Raise Notice ''Crt_Bill8'';
  insert into acd_pwr_demand_tbl(id_doc,dt,id_point,kind_energy,id_zone,dat_b,dat_e,
             sum_demand,fact_demand,sum_losts,fact_losts,ident,in_res_losts,out_res_losts,abn_losts,mmgg)
   select iddc,now()::date,a.id_point,a.kind_energy,a.id_zone,a.dat_b,a.dat_e,
             a.sum_demand,a.fact_demand,a.sum_losts,a.fact_losts,a.ident,a.in_res_losts,a.out_res_losts,a.abn_losts,mg
   from act_pwr_demand_tbl as a right join (select distinct id_point 
     from acd_point_branch_tbl where id_doc=iddc) as b 
     on a.id_point=b.id_point where ((kind_energy=knde and knde=1) or (kind_energy in (knde,4) 
    and knde=2));

update  acd_pwr_demand_tbl set fact_losts=sum_losts where id_doc=iddc and 
fact_losts is null;
--fill acd_calc_losts_tbl
Raise Notice ''Crt_Bill9'';
  
for test in select id_point,id_eqp,dat_b,kind_energy,count(*)
  from act_calc_losts_tbl group by id_point,id_eqp,dat_b,kind_energy 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_clclost'',100,591,''d_clclost'');
   insert into act_res_notice 
   values(''Double in table act_calc_losts_tbl'');
   raise notice ''Crt_Bill9  d_clclost test   %'',test;
--  return 0;
end loop;

insert into acd_calc_losts_tbl(id_doc,dt,id_point,id_eqp,num,dat_b,dat_e
     ,type_eqm,id_type_eqp,sn_len,tt,tw,pxx_r0,pkz_x0,ixx,ukz_un,wp,wq,wp1
     ,s_xx_addwp,s_kz_addwq,kind_energy,dw,res_l,is_use,mmgg)
   select distinct iddc,now()::date,a.*,mg 
  from (select distinct id_point,id_eqp,num,dat_b,dat_e,type_eqm,id_type_eqp,sn_len,tt,tw,pxx_r0,pkz_x0,ixx,ukz_un,w_p,w_q,
       wp_1,s_xx_addwp,s_kz_addwq,kind_energy,dw,res_l,1 
       from act_calc_losts_tbl) as a right join 
     (select distinct id_point from acd_point_branch_tbl where id_doc=iddc) as b 
     on a.id_point=b.id_point where ((kind_energy=knde and knde=1) or (kind_energy in (knde,4) 
    and knde=2));
--fill acd_pnt_tarif
 if knde=1 then
--return 0;
Raise Notice ''Crt_Bill10'';
   insert into acd_pnt_tarif(id_doc,dt,id_point,id_tarif,dat_b,dat_e,mmgg)  
     select iddc,now()::date,a.*,mg  
     from act_pnt_tarif as a right join (select distinct id_point 
       from acd_point_branch_tbl where id_doc=iddc and id_client=idcl) as b 
       on a.id_point=b.id_point;
 else
Raise Notice ''Crt_Bill11'';
   insert into acd_pnt_tarif(id_doc,dt,id_point,id_tarif,dat_b,dat_e,mmgg)  
     select iddc,now()::date,b.id_point,a.id_tarif,b.dat_b,b.dat_e,mg  
     from (select id as id_tarif from aci_tarif_tbl where ident=''clc_re'') as a 
      right join (select distinct id_point,dat_b,dat_e 
       from acd_point_branch_tbl where id_doc=iddc and id_client=idcl) as b 
       on true;
 end if;
--calc summs
---insert into acd_billsum_tbl()
if knde=1 then
Raise Notice ''Crt_Bill12'';
--return 0;
insert into acd_billsum_tbl(id_doc,dt,id_point,kind_energy,id_tariff
          ,id_sumtariff,id_zone,id_zonekoef,demand_val,sum_val,dt_begin,dt_end,mmgg) 
select iddc,now()::date,c.id_point,knde,id_tarif,id_tarval,id_zone,id_znk
       ,calc_dem 
       ,round(k_curr*tar*koef*calc_dem,2) as calc_sum
       ,dat_b,dat_e,mg 
from
(select d.id_point,d.id_zone,d.id_znk,d.koef,e.id_tarif,e.id_tarval
        ,e.idk_currency,e.value as tar,max(d.dat_b,e.dat_b) as dat_b
        ,min(d.dat_e,e.dat_e) as dat_e,d.dem_pay
        ,round(d.dem_pay*date_mi(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem  
        ,(select value from cmm_currency_tbl where id_currency=e.idk_currency) as k_curr 
 from 
 (
 select a.id_point,a.id_zone,c.id_znk,max(c.dt_begin,a.dat_b) as dat_b
      ,min(c.dt_end,a.dat_e) as dat_e,c.koef,a.dem_pay,a.fact_demand 
 from 
 (select a1.id_point,a1.id_zone,a1.dat_b,a1.dat_e
   ,case when (a1.fact_demand+a1.fact_losts)<0 
       then 
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
    else (a1.fact_demand+a1.fact_losts) end as fact_demand
   ,(case when (a1.fact_demand+a1.fact_losts)<0 then 
            case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
 
   else 
      (a1.fact_demand+a1.fact_losts) end)::numeric/date_mi_nol(a1.dat_e::date,a1.dat_b::date) as dem_pay  

  from (select * from acd_pwr_demand_tbl where id_doc=iddc )as a1 right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl where id_doc=iddc 
    and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) as a 
 left join 
 (select a.id as id_znk,a.id_zone,dt_begin,koef
      ,coalesce((select min(dt_begin) from acd_zone_tbl as b 
         where a.id_zone=b.id_zone and b.dt_begin>a.dt_begin),dte) as dt_end 
  from acd_zone_tbl as a 
   where coalesce((select min(dt_begin) from acd_zone_tbl as b 
         where a.id_zone=b.id_zone and b.dt_begin>a.dt_begin),dte)>dtb  and  (id<=27 or id>=300)) as c
 on (a.id_zone=c.id_zone and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
order by id_point,dat_b,dat_e 
) as d 
Inner Join 
 (
 select a.id_point,a.id_tarif,c.id_tarval,max(c.dt_begin,a.dat_b) as dat_b
   ,min(c.dt_end,a.dat_e) as dat_e,c.idk_currency,c.value 
  from 
   (select a1.* from (select * from acd_pnt_tarif where id_doc=iddc) as a1 right join 
    (select distinct id_point,id_doc from acd_point_branch_tbl where id_doc=iddc 
     and id_client=idcl) as a2
    on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) as a 
   left join 
   (select a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
       ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
         where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte) as dt_end 
   from acd_tarif_tbl as a 
    where coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte)>dtb 
     order by id_tarif 
  ) as c 
   on (a.id_tarif=c.id_tarif and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
order by id_point,dat_b,dat_e ) as e 
on (d.dat_b<e.dat_e and d.dat_e>e.dat_b and d.id_point=e.id_point)  
) as c;

--update end calc summs
Raise Notice ''Crt_Bill13'';
update acd_billsum_tbl set demand_val=a.calc_dem
      ,sum_val=round((a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *(select koef from acd_zone_tbl where acd_billsum_tbl.id_zonekoef=acd_zone_tbl.id)),2) 
from (select a1.id_point,id_zone,dat_b,dat_e,
    case when fact_demand+fact_losts<0 then 
             case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
 else fact_demand+fact_losts end as fact_demand
   ,(case when fact_demand+fact_losts<0 then 
          case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end

     else fact_demand+fact_losts end)-coalesce((select sum(demand_val) from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point and id_zone=a1.id_zone 
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem 
   from acd_pwr_demand_tbl as a1 right join (select distinct id_point,count_lost  
     from acd_point_branch_tbl where id_doc=iddc and id_client=idcl) as a2 
    on a1.id_point=a2.id_point
    where a1.id_doc=iddc --id_point=r.id_point
  ) as a 
where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.id_point 
      and acd_billsum_tbl.dt_end=a.dat_e and acd_billsum_tbl.id_zone=a.id_zone;
--update end calc summs
else --(if knde=1)
Raise Notice ''Crt_Bill14'';
if mg<=''2005-08-01'' then 
   insert into acd_billsum_tbl(id_doc,dt,id_point,kind_energy,id_tariff
          ,id_sumtariff,id_zone,demand_val,cdemand_val,sum_val,dt_begin,dt_end,mmgg
          ,p1,p2,p3,k_fi,tg_fi,wp,wq,d,k_corr)  
   select  iddc,now()::date,c.id_point,knde,id_tarif,id_tarval,id_zone
       ,calc_dem1,calc_dem  
       ,round(k_corr*(round(k_curr*tar*d*calc_dem,2)+round(round(k_curr*tar*d*calc_dem,2)*cbaz*(k_fi-1),2)),2) as calc_sum
       ,dat_b,dat_e,mg 
      ,round(k_curr*tar*d*calc_dem,2) as p1
      ,round(round(k_curr*tar*d*calc_dem,2)*cbaz*(k_fi-1),2) as p2
      ,0 as p3,k_fi,tg_fi,w_p,w_q,d,k_corr
   from
    (select d.id_point,d.id_zone,d.k_fi,e.id_tarif,e.id_tarval,d.d
        ,d.tg_fi,d.w_p,d.w_q 
        ,e.idk_currency,e.value as tar,max(d.dat_b,e.dat_b) as dat_b
        ,min(d.dat_e,e.dat_e) as dat_e,d.dem_pay
        ,round(d.dem_pay*date_mi_nol(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem  
        ,round(d.dem_pay1*date_mi_nol(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem1  
        ,(select value from cmm_currency_tbl where id_currency=e.idk_currency) as k_curr 
        ,e.k_corr
    from 
    (select a.id_point,0 as id_zone,a.dem_pay,a.dem_pay1,a.fact_demand
      ,(select k_fi from acm_k_fi_tbl where tg=(
        case when tg_fi>2 then 2 else tg_fi end)) as k_fi 
   ,tg_fi,case when (w_p=1 and wp_a=0 and swp_a=0) then 0 else w_p end,w_q 
   ,max(c.dat_b,a.dat_b) as dat_b,min(c.dat_e,a.dat_e) as dat_e,c.d 
     from 
      (select a1.id_point,max(a1.dat_e,a3.dat_e) as dat_e,min(a3.dat_b,a1.dat_b) as dat_b
     ,(case when (a1.fact_demand+a1.fact_losts)<0 
       then 
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
       else (a1.fact_demand+a1.fact_losts) end)+kk*coalesce(a3.fact_demandg,0) 
     as fact_demand
--   ,round(a1.fact_demand::numeric/case when (a1.fact_demand=a1.sum_demand 
--     and a4.fact_demanda<>a4.sum_demanda) 
--     then a4.sum_demanda else a4.fact_demanda end,2) as tg_fi

   ,round(a1.fact_demand::numeric/(case when coalesce(a1_2.ident,0)=4 
     then a4.sum_demanda else a4.sum_demanda-coalesce(a5.sum_demandar,0) end),2) as tg_fi

   ,a1.fact_demand as w_q
--   ,case when (a1.fact_demand=a1.sum_demand 
--     and a4.fact_demanda<>a4.sum_demanda) 
--     then a4.sum_demanda else a4.fact_demanda end as w_p

   ,case when coalesce(a1_2.ident,0)=4 
     then a4.sum_demanda else a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0) end as w_p
   ,a4.wp_a,a4.swp_a  
   ,((case when (a1.fact_demand+a1.fact_losts)<0 then 
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
 else 
      (a1.fact_demand+a1.fact_losts) end)+kk*coalesce(a3.fact_demandg,0))::numeric/date_mi_nol(max(a1.dat_e,a3.dat_e)::date
      ,min(a3.dat_b,a1.dat_b)::date) as dem_pay  
   ,((case when (a1.fact_demand+a1.fact_losts)<0 then 
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
 else 
      (a1.fact_demand+a1.fact_losts) end)+coalesce(a3.fact_demandg,0))::numeric/date_mi_nol(max(a1.dat_e,a3.dat_e)::date
      ,min(a3.dat_b,a1.dat_b)::date) as dem_pay1  

   from (((select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demand,sum(coalesce(fact_losts,0)) as fact_losts  
       ,sum(sum_demand) as sum_demand 
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=2 
      group by id_point,id_doc) as a1 
       left join (select distinct ident,id_point from acd_pwr_demand_tbl 
        where ident=4 and id_doc=iddc and kind_energy=2) as a1_2 
       on (a1.id_point=a1_2.id_point)
    right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl 
      where id_doc=iddc and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) 
   left join 
     (select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demandg  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=4 
       and id_zone in (0,1,4) group by id_point,id_doc) as a3 
   on (a3.id_point=a2.id_point and a3.id_doc=a2.id_doc))
   left join 
     (select id_point,case when sum(fact_demand)=0 then 1::numeric(4,2) 
                else sum(fact_demand) end as fact_demanda
      ,case when sum(sum_demand)=0 then 1::numeric(4,2) 
                else sum(sum_demand) end as sum_demanda 
      ,sum(fact_demand) as wp_a,sum(sum_demand) as swp_a
      from act_pwr_demand_tbl where kind_energy=1 
      group by id_point) as a4  
   on (a4.id_point=a2.id_point)
    left join (select sum(a.sum_demand) as sum_demandar,b.id_p_point 
     from 
      act_pwr_demand_tbl as a 
      inner join (select b1.* from act_point_branch_tbl as b1 inner join 
        act_pnt_knd as b2 on (b1.id_point=b2.id_point and b1.dat_b<b2.dat_e 
           and b1.dat_e>b2.dat_b) 
         where b2.kind_energy=2) as b on (a.id_point=b.id_point 
       and a.dat_b<b.dat_e and a.dat_e>b.dat_b) where b.id_p_point is not null 
       and a.kind_energy=1 and a.ident<>2 
     group by b.id_p_point) as a5 
     on (a5.id_p_point=a4.id_point)
  left join
  (select id_point, sum(doubl2_demand) as doubl2
       from  act_pwr_demand_tbl where kind_energy=1
      group by id_point) as a6  
   on (a6.id_point=a2.id_point)
    ) as a 
   inner join act_pnt_d as c on (c.id_point=a.id_point)
    ) as d 
   Inner Join 
   (
   select a.id_point,a.id_tarif,c.id_tarval,max(c.dt_begin,a.dat_b) as dat_b
    ,min(c.dt_end,a.dat_e) as dat_e,c.idk_currency,c.value,a.k_corr 
   from 
   (select a1.*,a2.k_corr from acd_pnt_tarif as a1 right join 
    (select distinct id_point,id_doc,k_corr from acd_point_branch_tbl where id_doc=iddc 
     and id_client=idcl) as a2
    on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) as a 
   left join 
   (select a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
       ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
         where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte) as dt_end 
   from acd_tarif_tbl as a 
    where coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte)>dtb) as c 
   on (a.id_tarif=c.id_tarif and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
   ) as e 
  on (d.dat_b<e.dat_e and d.dat_e>e.dat_b and d.id_point=e.id_point)  
  ) as c;
  --update end calc summs
        
Raise Notice ''Crt_Bill15'';
  update acd_billsum_tbl set demand_val=a.calc_dem1
       ,sum_val=round(k_corr*(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)+round(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)*cbaz*(k_fi-1),2)),2) 
       ,p1=round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)
       ,p2=round(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)*cbaz*(k_fi-1),2)
       ,cdemand_val=a.calc_dem

  from 

  (select a1.id_point,max(a1.dat_e,a3.dat_e) as dat_e,min(a3.dat_b,a1.dat_b) as dat_b
   ,(case when (a1.fact_demand+a1.fact_losts)<0 
       then 
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
 else (a1.fact_demand+a1.fact_losts) end)+kk*coalesce(a3.fact_demandg,0) as fact_demand
   ,round(a1.fact_demand::numeric/a4.fact_demanda,2) as tg_fi 
   ,((case when (a1.fact_demand+a1.fact_losts)<0 then  
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
 else 
      (a1.fact_demand+a1.fact_losts) end)+kk*coalesce(a3.fact_demandg,0))-coalesce((select sum(cdemand_val) 
             from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem  
   ,((case when (a1.fact_demand+a1.fact_losts)<0 then 
          case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
  else 
      (a1.fact_demand+a1.fact_losts) end)+coalesce(a3.fact_demandg,0))-coalesce((select sum(demand_val) 
             from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem1  

   from (((select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demand,sum(coalesce(fact_losts,0)) as fact_losts  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=2 
      group by id_point,id_doc) as a1 right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl 
      where id_doc=iddc and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) 
   left join 
     (select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demandg  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=4 
       and id_zone in (0,1,4) group by id_point,id_doc) as a3 
   on (a3.id_point=a2.id_point and a3.id_doc=a2.id_doc))
   left join 
     (select id_point,case when sum(fact_demand)=0 then 1 
         else sum(fact_demand) end as fact_demanda
      from acd_pwr_demand_tbl where kind_energy=1 
      group by id_point) as a4 
   on (a4.id_point=a2.id_point)) as a 
   inner join act_pnt_d as c on (c.id_point=a.id_point 
   and (c.dat_b<=a.dat_b and c.dat_e>=a.dat_b))

   where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.id_point 
      and acd_billsum_tbl.dt_end=a.dat_e;
else 

-- normal  reactive-generation
Raise Notice ''New calc RE_GE '';
------ separate calc RE and GE 

Raise Notice ''Crt_Bill16'';

insert into acd_billsum_tbl(id_doc,dt,id_point,kind_energy,id_tariff
          ,id_sumtariff,id_zone,demand_val,cdemand_val,sum_val,dt_begin,dt_end,mmgg
          ,p1,p2,p3,k_fi,tg_fi,wp,wq,d,k_corr)  
select  iddc,now()::date,c.id_point,knde,id_tarif,id_tarval,id_zone
       ,calc_dem1,calc_dem  
       ,round(k_corr*(round(k_curr*tar*d*calc_dem,2)+round(round(k_curr*tar*d*calc_dem,2)*cbaz*(k_fi-1),2)),2) as calc_sum
       ,dat_b,dat_e,mg 
      ,round(k_curr*tar*d*calc_dem,2) as p1
      ,round(round(k_curr*tar*d*calc_dem,2)*cbaz*(k_fi-1),2) as p2
      ,0 as p3,k_fi,tg_fi,w_p,w_q,d,k_corr
from
(select d.id_point,d.id_zone,d.k_fi,e.id_tarif,e.id_tarval,d.d
        ,d.tg_fi,d.w_p,d.w_q 
        ,e.idk_currency,e.value as tar,max(d.dat_b,e.dat_b) as dat_b
        ,min(d.dat_e,e.dat_e) as dat_e,d.dem_pay
        ,round(d.dem_pay*date_mi_nol(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem  
        ,round(d.dem_pay1*date_mi_nol(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem1  
        ,(select value from cmm_currency_tbl where id_currency=e.idk_currency) as k_curr 
        ,e.k_corr
 from 
 (select a.id_point,0 as id_zone,a.dem_pay,a.dem_pay1 --,a.fact_demand
   ,(select k_fi from acm_k_fi_tbl where tg=(
     case when tg_fi>2 then 2 else tg_fi end)) as k_fi 
   ,tg_fi,case when (w_p=1 and wp_a=0 and swp_a=0) then 0 else w_p end,w_q 
   ,max(c.dat_b,a.dat_b) as dat_b,min(c.dat_e,a.dat_e) as dat_e,c.d 
 from 
 (select a1.id_point,a1.dat_e,a1.dat_b 
   ,round(a1.fact_demand::numeric
/(case when coalesce(a1_2.ident,0)=4 
     then case when a4.sum_demanda<>0 then a4.sum_demanda else -1 end 
     else case when a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0)<>0  then a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0) else -1 end
  end)
,2) as tg_fi
/*
/(case when coalesce(a1_2.ident,0)=4 
     then a4.sum_demanda else a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0) end)
,2) as tg_fi
*/
   ,a1.fact_demand as w_q
   ,case when coalesce(a1_2.ident,0)=4 
     then a4.sum_demanda else a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0) end as w_p
   ,a4.wp_a,a4.swp_a  
   ,(case when (a1.fact_demand+a1.fact_losts)<0 then  
          case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then  (a1.fact_demand+a1.fact_losts) 
          end
  else 
      (a1.fact_demand+a1.fact_losts) end)::numeric/date_mi_nol(a1.dat_e,a1.dat_b) as dem_pay  
   ,(case when (a1.fact_demand+a1.fact_losts)<0 then 
          case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end

  else 
      (a1.fact_demand+a1.fact_losts) end)::numeric/date_mi_nol(a1.dat_e,a1.dat_b) as dem_pay1  

   from ((select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demand,sum(coalesce(fact_losts,0)) as fact_losts  
       ,sum(sum_demand) as sum_demand 
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=2 
      group by id_point,id_doc) as a1 
       left join (select distinct ident,id_point from acd_pwr_demand_tbl 
        where ident=4 and id_doc=iddc and kind_energy=2) as a1_2 
       on (a1.id_point=a1_2.id_point)
    right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl 
      where id_doc=iddc and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) 
   left join 
     (select id_point,case when sum(fact_demand)=0 then 1::numeric(4,2) 
                else sum(fact_demand) end as fact_demanda
      ,case when sum(sum_demand)=0 then 1::numeric(4,2) 
                else sum(sum_demand) end as sum_demanda 
      ,sum(fact_demand) as wp_a,sum(sum_demand) as swp_a
      from act_pwr_demand_tbl where kind_energy=1 
      group by id_point) as a4  
   on (a4.id_point=a2.id_point)
    left join 
     (select sum(a.sum_demand) as sum_demandar,b.id_p_point 
     from act_pwr_demand_tbl as a 
     inner join (select b1.* from act_point_branch_tbl as b1 inner join 
       act_pnt_knd as b2 on (b1.id_point=b2.id_point and b1.dat_b<b2.dat_e 
          and b1.dat_e>b2.dat_b) 
        where b2.kind_energy=2) as b on (a.id_point=b.id_point 
      and a.dat_b<b.dat_e and a.dat_e>b.dat_b) where b.id_p_point is not null 
       and a.kind_energy=1 and a.ident<>2 group by b.id_p_point) as a5 
     on (a5.id_p_point=a4.id_point)
  left join
  (
  select id_point, sum(doubl2_demand) as doubl2
       from  act_pwr_demand_tbl where kind_energy=1
      group by id_point) as a6  
   on (a6.id_point=a2.id_point)

 ) as a 
 inner join act_pnt_d as c on (c.id_point=a.id_point)
 ) as d 
Inner Join 
 (
 select a.id_point,a.id_tarif,c.id_tarval,max(c.dt_begin,a.dat_b) as dat_b
   ,min(c.dt_end,a.dat_e) as dat_e,c.idk_currency,c.value,a.k_corr 
  from 
   (select a1.*,a2.k_corr from acd_pnt_tarif as a1 right join 
    (select distinct id_point,id_doc,k_corr from acd_point_branch_tbl where id_doc=iddc 
     and id_client=idcl) as a2
    on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) as a 
   left join 
   (select a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
       ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
         where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte) as dt_end 
   from acd_tarif_tbl as a 
    where coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte)>dtb) as c 
   on (a.id_tarif=c.id_tarif and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
 ) as e 
on (d.dat_b<e.dat_e and d.dat_e>e.dat_b and d.id_point=e.id_point)  
) as c;
--update end calc summs
        
Raise Notice ''Crt_Bill17'';
update acd_billsum_tbl set demand_val=a.calc_dem1
       ,sum_val=round(k_corr*(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)+round(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)*cbaz*(k_fi-1),2)),2) 
       ,p1=round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)
       ,p2=round(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)*cbaz*(k_fi-1),2)
       ,cdemand_val=a.calc_dem

from 

 (select a1.id_point,a1.dat_e,a1.dat_b 
   ,(case when (a1.fact_demand+a1.fact_losts)<0 then 
          case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then  (a1.fact_demand+a1.fact_losts) 
          end

  else 
      (a1.fact_demand+a1.fact_losts) end)-coalesce((select sum(cdemand_val) 
             from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point and kind_energy=2 
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem  
   ,(case when (a1.fact_demand+a1.fact_losts)<0 then 
         case when (kodres=330 and (a1.id_point=101538 or a1.id_point= 101544))
               then (a1.fact_demand+a1.fact_losts) 
          end
  
 else 
      (a1.fact_demand+a1.fact_losts) end)-coalesce((select sum(demand_val) 
             from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point and kind_energy=2 
                 and (dt_begin>=a1.dat_b and dt_end<a1.dat_e)),0) as calc_dem1  

   from ((select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demand,sum(coalesce(fact_losts,0)) as fact_losts  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=2 
      group by id_point,id_doc) as a1 right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl 
      where id_doc=iddc and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) 
   left join 
     (select id_point,case when sum(fact_demand)=0 then 1 
         else sum(fact_demand) end as fact_demanda
      from acd_pwr_demand_tbl where kind_energy=1 
      group by id_point) as a4 
   on (a4.id_point=a2.id_point)) as a 
 inner join act_pnt_d as c on (c.id_point=a.id_point 
   and (c.dat_b<=a.dat_b and c.dat_e>=a.dat_b))

where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.id_point 
      and acd_billsum_tbl.dt_end=a.dat_e and acd_billsum_tbl.kind_energy=2;


Raise Notice ''Crt_Bill18'';
insert into acd_billsum_tbl(id_doc,dt,id_point,kind_energy,id_tariff
          ,id_sumtariff,id_zone,demand_val,cdemand_val,sum_val,dt_begin,dt_end,mmgg
          ,p1,p2,p3,k_fi,tg_fi,wp,wq,d,k_corr)  
select  iddc,now()::date,c.id_point,4,id_tarif,id_tarval,id_zone
       ,calc_dem1,calc_dem  
       ,round(k_corr*(round(k_curr*tar*d*calc_dem,2)+round(round(k_curr*tar*d*calc_dem,2)*cbaz*(k_fi-1),2)),2) as calc_sum
       ,dat_b,dat_e,mg 
      ,round(k_curr*tar*d*calc_dem,2) as p1
      ,round(round(k_curr*tar*d*calc_dem,2)*cbaz*(k_fi-1),2) as p2
      ,0 as p3,k_fi,tg_fi,w_p,w_q,d,k_corr
from
(select d.id_point,d.id_zone,d.k_fi,e.id_tarif,e.id_tarval,d.d
        ,d.tg_fi,d.w_p,d.w_q 
        ,e.idk_currency,e.value as tar,max(d.dat_b,e.dat_b) as dat_b
        ,min(d.dat_e,e.dat_e) as dat_e,d.dem_pay
        ,round(d.dem_pay*date_mi_nol(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem  
        ,round(d.dem_pay1*date_mi_nol(min(e.dat_e,d.dat_e)::date,max(e.dat_b,d.dat_b)::date),0) as calc_dem1  
        ,(select value from cmm_currency_tbl where id_currency=e.idk_currency) as k_curr 
        ,e.k_corr
 from 
 (select a.id_point,0 as id_zone,a.dem_pay,a.dem_pay1 --,a.fact_demand
   ,(select k_fi from acm_k_fi_tbl where tg=(
     case when tg_fi>2 then 2 else tg_fi end)) as k_fi 
   ,tg_fi,case when (w_p=1 and wp_a=0 and swp_a=0) then 0 else w_p end,w_q 
   ,max(c.dat_b,a.dat_b) as dat_b,min(c.dat_e,a.dat_e) as dat_e,c.d 
 from 
 (select a3.id_point,a3.dat_e,a3.dat_b as dat_b
--   ,kk*coalesce(a3.fact_demandg,0) as fact_demand
   ,round(a1.fact_demand::numeric
/(case when coalesce(a1_2.ident,0)=4 
     then case when a4.sum_demanda<>0 then a4.sum_demanda else -1 end 
     else case when a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0)<>0  then a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0) else -1 end
  end)
,2) as tg_fi
   ,a1.fact_demand as w_q
   ,case when coalesce(a1_2.ident,0)=4 
     then a4.sum_demanda else a4.sum_demanda-coalesce(a5.sum_demandar,0)+coalesce(a6.doubl2,0) end as w_p
   ,a4.wp_a,a4.swp_a  
   ,kk*coalesce(a3.fact_demandg,0)::numeric/date_mi_nol(a3.dat_e,a3.dat_b) as dem_pay  
   ,coalesce(a3.fact_demandg,0)::numeric/date_mi_nol(a3.dat_e,a3.dat_b) as dem_pay1  

   from (((select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demand,sum(coalesce(fact_losts,0)) as fact_losts  
       ,sum(sum_demand) as sum_demand 
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=2 
      group by id_point,id_doc) as a1 
       left join (select distinct ident,id_point from acd_pwr_demand_tbl 
        where ident=4 and id_doc=iddc and kind_energy=2) as a1_2 
       on (a1.id_point=a1_2.id_point)
    right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl 
      where id_doc=iddc and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) 
   left join 
     (select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demandg  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=4 
       and id_zone in (0,1,4) group by id_point,id_doc) as a3 
   on (a3.id_point=a2.id_point and a3.id_doc=a2.id_doc))
   left join 
     (select id_point,case when sum(fact_demand)=0 then 1::numeric(4,2) 
                else sum(fact_demand) end as fact_demanda
      ,case when sum(sum_demand)=0 then 1::numeric(4,2) 
                else sum(sum_demand) end as sum_demanda 
      ,sum(fact_demand) as wp_a,sum(sum_demand) as swp_a
      from act_pwr_demand_tbl where kind_energy=1 
      group by id_point) as a4  
   on (a4.id_point=a2.id_point)
    left join (select sum(a.sum_demand) as sum_demandar,b.id_p_point 
     from act_pwr_demand_tbl as a 
     inner join (select b1.* from act_point_branch_tbl as b1 inner join 
       act_pnt_knd as b2 on (b1.id_point=b2.id_point and b1.dat_b<b2.dat_e 
          and b1.dat_e>b2.dat_b) 
        where b2.kind_energy=2) as b on (a.id_point=b.id_point 
      and a.dat_b<b.dat_e and a.dat_e>b.dat_b) where b.id_p_point is not null 
       and a.kind_energy=1 and a.ident<>2 group by b.id_p_point) as a5 
     on (a5.id_p_point=a4.id_point)
  left join
  (select id_point, sum(doubl2_demand) as doubl2
       from  act_pwr_demand_tbl where kind_energy=1
      group by id_point) as a6  
   on (a6.id_point=a2.id_point)
 ) as a 
 inner join act_pnt_d as c on (c.id_point=a.id_point)
 ) as d 
Inner Join 
 (
 select a.id_point,a.id_tarif,c.id_tarval,max(c.dt_begin,a.dat_b) as dat_b
   ,min(c.dt_end,a.dat_e) as dat_e,c.idk_currency,c.value,a.k_corr 
  from 
   (select a1.*,a2.k_corr from acd_pnt_tarif as a1 right join 
    (select distinct id_point,id_doc,k_corr from acd_point_branch_tbl where id_doc=iddc 
     and id_client=idcl) as a2
    on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) as a 
   left join 
   (select a.id as id_tarval,a.id_tarif,a.idk_currency,a.value,dt_begin
       ,coalesce((select min(dt_begin) from acd_tarif_tbl as b
         where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte) as dt_end 
   from acd_tarif_tbl as a 
    where coalesce((select min(dt_begin) from acd_tarif_tbl as b
          where a.id_tarif=b.id_tarif and b.dt_begin>a.dt_begin),dte)>dtb) as c 
   on (a.id_tarif=c.id_tarif and (c.dt_end>a.dat_b and c.dt_begin<a.dat_e))
 ) as e 
on (d.dat_b<e.dat_e and d.dat_e>e.dat_b and d.id_point=e.id_point)  
) as c;

--update end calc summs
Raise Notice ''Crt_Bill19'';
        
update acd_billsum_tbl set demand_val=a.calc_dem1
       ,sum_val=round(k_corr*(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)+round(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)*cbaz*(k_fi-1),2)),2) 
       ,p1=round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)
       ,p2=round(round(a.calc_dem::numeric*(select b.value*c.value 
       from cmm_currency_tbl as b, acd_tarif_tbl as c 
       where c.id=acd_billsum_tbl.id_sumtariff and b.id_currency=c.idk_currency)
       *acd_billsum_tbl.d,2)*cbaz*(k_fi-1),2)
       ,cdemand_val=a.calc_dem

from 

 (select a3.id_point,a3.dat_e,a3.dat_b
--   ,kk*coalesce(a3.fact_demandg,0) as fact_demand
--   ,round(a1.fact_demand::numeric/a4.fact_demanda,2) as tg_fi 
   ,kk*coalesce(a3.fact_demandg,0)-coalesce((select sum(cdemand_val) 
             from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point and kind_energy=4 
                 and (dt_begin>=a3.dat_b and dt_end<a3.dat_e)),0) as calc_dem  
   ,coalesce(a3.fact_demandg,0)-coalesce((select sum(demand_val) 
             from acd_billsum_tbl 
             where id_doc=iddc and id_point=a1.id_point and kind_energy=4 
                 and (dt_begin>=a3.dat_b and dt_end<a3.dat_e)),0) as calc_dem1  

   from (((select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demand,sum(coalesce(fact_losts,0)) as fact_losts  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=2 
      group by id_point,id_doc) as a1 right join 
   (select distinct id_point,id_doc,count_lost from acd_point_branch_tbl 
      where id_doc=iddc and id_client=idcl) as a2
   on (a1.id_point=a2.id_point and a1.id_doc=a2.id_doc)) 
   left join 
     (select id_doc,id_point,min(dat_b) as dat_b,max(dat_e) as dat_e
       ,sum(fact_demand) as fact_demandg  
      from acd_pwr_demand_tbl where id_doc=iddc and kind_energy=4 
       and id_zone in (0,1,4) group by id_point,id_doc) as a3 
   on (a3.id_point=a2.id_point and a3.id_doc=a2.id_doc))
   left join 
     (select id_point,case when sum(fact_demand)=0 then 1 
         else sum(fact_demand) end as fact_demanda
      from acd_pwr_demand_tbl where kind_energy=1 
      group by id_point) as a4 
   on (a4.id_point=a2.id_point)) as a 
 inner join act_pnt_d as c on (c.id_point=a.id_point 
   and (c.dat_b<=a.dat_b and c.dat_e>=a.dat_b))

where acd_billsum_tbl.id_doc=iddc and acd_billsum_tbl.id_point=a.id_point 
      and acd_billsum_tbl.dt_end=a.dat_e and acd_billsum_tbl.kind_energy=4;

------ separate calc RE and GE 
 
end if;

          
--update end calc summs
end if; --(if knde=1)
update acd_billsum_tbl set demand_val=0  ,sum_val=0 where demand_val<0 and id_doc=iddc; 
---update head_summs
if mg<''2005-08-01'' then
Raise Notice ''Crt_Bill20'';  
update acm_bill_tbl set dat_e=date_mii(dat_e,dt_add)
  ,demand_val=coalesce(a.dem,0) 
from (select sum(sum_val) as calc_sum,sum(demand_val) as dem  
       from acd_billsum_tbl where id_doc=iddc) as a 
where acm_bill_tbl.id_doc=iddc;  
else  
Raise Notice ''Crt_Bill21'';
update acm_bill_tbl set value = coalesce(a.calc_sum,0)
  ,value_tax=coalesce(round(a.calc_sum*nds,2),0)
  ,dat_e=date_mii(dat_e,dt_add)
  ,demand_val=coalesce(a.dem,0) 
from (select sum(sum_val) as calc_sum,sum(demand_val) as dem  
       from acd_billsum_tbl where id_doc=iddc) as a 
where acm_bill_tbl.id_doc=iddc;   
end if; 

Raise Notice ''Crt_Bill22'';
update acd_billsum_tbl set dt_end=date_mii(dt_end,1) where id_doc=iddc;
--create bill
update acd_point_branch_tbl set dat_e=date_mii(dat_e,dt_add) where id_doc=iddc;
update acd_met_kndzn_tbl set dat_e=date_mii(dat_e,dt_add) where id_doc=iddc;
update acd_pwr_demand_tbl set dat_e=date_mii(dat_e,dt_add) where id_doc=iddc;
update acd_pnt_tarif set dat_e=date_mii(dat_e,dt_add) where id_doc=iddc;


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

update acd_billsum_tbl set id_area=0 	where id_area is null;

update acd_billsum_tbl set demand_val=0  ,sum_val=0 where demand_val<0 and id_doc=iddc; 
--if (select value from acm_bill_tbl where flock=0 and id_doc=iddc)<=0 then
-- Raise Notice ''value of bill <=0'';
-- rs:=null;
-- delete from acm_bill_tbl where id_doc=iddc; --idk_document
----delete from _del tables
--else
 rs:=iddc;
--end if;

------------------------------------------------------------------------
Raise Notice ''Crt_Bill33'';

perform eqc_bill_addr_fun( iddc, dte);

Raise Notice ''Crt_Bill34'';

perform bl_point_order_fun( iddc,NULL,1,0);

Raise Notice ''Crt_Bill35'';


for r in select id_doc,id_point,count(*), max(num_order) as maxorder, min(num_order) as minorder
 from acd_point_branch_tbl as pb
 where id_doc = iddc 
 group by id_doc,id_point
 having count(*)>1
loop

 update acd_point_branch_tbl set num_order = -1  
 where id_doc = iddc and id_point = r.id_point and num_order <> r.minorder;
 Raise notice ''point % '',r.id_point;
end loop;



kk:=1;

for r in select * from acd_point_branch_tbl as pb
 where id_doc = iddc and num_order <> -1 order by num_order 
loop

 update acd_point_branch_tbl set num_order = kk  
 where id_point=r.id_point and p_point2=r.p_point2 and id_doc=r.id_doc and  dat_b=r.dat_b;

 kk:=kk+1;
end loop;

  select into psection id_section from clm_statecl_h 
  where id_client=idcl and
  mmgg_b=(select max(mmgg_b)  from clm_statecl_h as scl2 
           where scl2.id_client = idcl and scl2.mmgg_b <= date_trunc(''month'', dtb )
         );

if psection=201 or psection=202 or psection=204 then
raise notice ''form  2-kr for %'',psection;
if knde=1 then
 if mg>=''2013-01-01'' then
     raise notice ''crt_dem2krmmgg_area  2012-01-01'';
    perform crt_dem2krmmgg_area(idcl,mg);
 else 
  if mg >=''2010-05-01''::date then 
       raise notice ''crt_dem2krmmgg 2010-05-01'';
   perform crt_dem2krmmgg(idcl,mg);
  else
     raise notice ''crt_dem2krbill'';
     perform crt_dem2krbill(idcl,iddc,mg);
   end if;
 end if;
end if;
else
raise notice ''need not 2-kr for %'',psection;
end if;

Return rs;
end;
' Language 'plpgsql';


set client_encoding='koi8';