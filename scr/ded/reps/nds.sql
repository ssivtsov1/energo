create or replace function rep_nds_fun(date,int,bool) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
  ppref alias for $2;
  pbuild alias for $3;
  v int;
  r record;
  vid_pref int;

BEGIN

 if pbuild then 

  perform seb_all(0, date_trunc(''month'', pmmgg)::date );
  perform rep_mmggpay_fun(ppref,date_trunc(''month'', pmmgg)::date);

 end if;

 delete from rep_nds_tbl;

insert into rep_nds_tbl
select pmmgg, * from  
  (select ppref as key, 
  -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)) as deb_b_01_1,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)) as dpdv_b_01_1, 
  sum(kr_zpmv) as kr_b_01_1, sum(kr_zpmpdv) as kpdv_b_01_1, 
  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)) as deb_e_01_1, -sum(deb_kmpdv-coalesce(deb_km00pdv,0)) as dpdv_e_01_1, 
  sum(kr_zkmv) as kr_e_01_1, sum(kr_zkmpdv) as kpdv_e_01_1, 
  sum(nar) as kvt_01_1,sum(nar_v) as dem_01_1,sum(nar_pdv) as dempdv_01_1, 
  sum(p.pay) as opl_01_1,sum(p.pay_tax) as oplpdv_01_1, 
  sum(p.writeoff) as sp1_01_1, sum(p.writeoff_tax) as sp1pdv_01_1,sum(p.trush) as sp2_01_1, sum(p.trush_tax) as sp2pdv_01_1, 
  sum(ktpay.value_pay) as billkt_01_1, sum(ktpay.value_tax) as billktpdv_01_1 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  left join (
   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
   from (select id_client,date_part(''year'',hmmgg) as gg, sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, case when date_part(''year'',mmgg)=2009 and date_part(''year'',hmmgg)=2008 then ''2009-01-01'' 
					when date_part(''year'',mmgg)=2010 and date_part(''year'',hmmgg)=2009 then ''2010-01-01''  
					when date_part(''year'',mmgg)=2011 and date_part(''year'',hmmgg)=2010 then ''2011-01-01''
					else hmmgg end as hmmgg , b_ktval,b_ktval_tax,e_ktval,e_ktval_tax from  seb_obrs_tmp 
   ) as obrs
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg)
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 
  where period =  date_trunc(''month'', pmmgg) 
  --and roz in (101,102,103,104) 
  and roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  --������ ᮡ�⢥��� �㦤�
--  and not exists (select b2.id_client from acm_bill_tbl as b2 join acd_billsum_tbl as bs2 using (id_doc) 
--    where bs2.id_tariff = 900002 and b2.id_client = s.id_client and bs2.demand_val <> 0 and b2.mmgg =  date_trunc(''month'', pmmgg) )
) as s01_1 
  join (select ppref as key, 
  -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)) as deb_b_01_2,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)) as dpdv_b_01_2, 
  sum(kr_zpmv) as kr_b_01_2, sum(kr_zpmpdv) as kpdv_b_01_2, 
  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)) as deb_e_01_2, -sum(deb_kmpdv-coalesce(deb_km00pdv,0)) as dpdv_e_01_2, 
  sum(kr_zkmv) as kr_e_01_2, sum(kr_zkmpdv) as kpdv_e_01_2, 
  sum(nar) as kvt_01_2,sum(nar_v) as dem_01_2,sum(nar_pdv) as dempdv_01_2, 
  sum(p.pay) as opl_01_2,sum(p.pay_tax) as oplpdv_01_2, 
  sum(p.writeoff)as sp1_01_2, sum(p.writeoff_tax)as sp1pdv_01_2,sum(p.trush)as sp2_01_2, sum(p.trush_tax)as sp2pdv_01_2,  
  sum(ktpay.value_pay) as billkt_01_2, sum(ktpay.value_tax) as billktpdv_01_2 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  left join (
   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
   from (select id_client,date_part(''year'',hmmgg) as gg, sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, case when date_part(''year'',mmgg)=2009 and date_part(''year'',hmmgg)=2008 then ''2009-01-01'' 
					when date_part(''year'',mmgg)=2010 and date_part(''year'',hmmgg)=2009 then ''2010-01-01''
					when date_part(''year'',mmgg)=2011 and date_part(''year'',hmmgg)=2010 then ''2011-01-01''
					else hmmgg end as hmmgg ,b_ktval,b_ktval_tax,e_ktval,e_ktval_tax from  seb_obrs_tmp ) as obrs
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 
  where period =  date_trunc(''month'', pmmgg) and roz in (11) and s.id_pref = ppref and c.idk_work not in (0,99)
  --������ ᮡ�⢥��� �㦤�
--  and not exists (select b2.id_client from acm_bill_tbl as b2 join acd_billsum_tbl as bs2 using (id_doc) 
--    where bs2.id_tariff = 900002 and b2.id_client = s.id_client and bs2.demand_val <> 0 and b2.mmgg =  date_trunc(''month'', pmmgg) )
) as s01_2 using (key) 
  join (select ppref as key, 
  -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)) as deb_b_01_3,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)) as dpdv_b_01_3, 
  sum(kr_zpmv) as kr_b_01_3, sum(kr_zpmpdv) as kpdv_b_01_3, 
  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)) as deb_e_01_3, -sum(deb_kmpdv-coalesce(deb_km00pdv,0)) as dpdv_e_01_3, 
  sum(kr_zkmv) as kr_e_01_3, sum(kr_zkmpdv) as kpdv_e_01_3, 
  sum(nar) as kvt_01_3,sum(nar_v) as dem_01_3,sum(nar_pdv) as dempdv_01_3, 
  sum(p.pay) as opl_01_3,sum(p.pay_tax) as oplpdv_01_3, 
  sum(p.writeoff)as sp1_01_3, sum(p.writeoff_tax)as sp1pdv_01_3,sum(p.trush)as sp2_01_3, sum(p.trush_tax)as sp2pdv_01_3, 
  sum(ktpay.value_pay) as billkt_01_3, sum(ktpay.value_tax) as billktpdv_01_3 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period)  
  join clm_client_tbl as c on (c.id = s.id_client )
  left join (
   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
   from (select id_client,date_part(''year'',hmmgg) as gg, sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, case when date_part(''year'',mmgg)=2009 and date_part(''year'',hmmgg)=2008 then ''2009-01-01'' 
					when date_part(''year'',mmgg)=2010 and date_part(''year'',hmmgg)=2009 then ''2010-01-01'' 
					when date_part(''year'',mmgg)=2011 and date_part(''year'',hmmgg)=2010 then ''2011-01-01''
					else hmmgg end as hmmgg ,b_ktval,b_ktval_tax,e_ktval,e_ktval_tax from  seb_obrs_tmp ) as obrs
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 

  where period =  date_trunc(''month'', pmmgg) and roz in (12) and s.id_pref = ppref and c.idk_work not in (0,99)
  --������ ᮡ�⢥��� �㦤�
--  and not exists (select b2.id_client from acm_bill_tbl as b2 join acd_billsum_tbl as bs2 using (id_doc) 
--    where bs2.id_tariff = 900002 and b2.id_client = s.id_client and bs2.demand_val <> 0 and b2.mmgg =  date_trunc(''month'', pmmgg) )
) as s01_3 using (key) 
  join (select ppref as key, 
  -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)) as deb_b_01_4,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)) as dpdv_b_01_4, 
  sum(kr_zpmv) as kr_b_01_4, sum(kr_zpmpdv) as kpdv_b_01_4, 
  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)) as deb_e_01_4, -sum(deb_kmpdv-coalesce(deb_km00pdv,0)) as dpdv_e_01_4, 
  sum(kr_zkmv) as kr_e_01_4, sum(kr_zkmpdv) as kpdv_e_01_4, 
  sum(nar) as kvt_01_4,sum(nar_v) as dem_01_4,sum(nar_pdv) as dempdv_01_4, 
  sum(p.pay) as opl_01_4,sum(p.pay_tax) as oplpdv_01_4, 
  sum(p.writeoff)as sp1_01_4, sum(p.writeoff_tax)as sp1pdv_01_4,sum(p.trush)as sp2_01_4, sum(p.trush_tax)as sp2pdv_01_4, 
  sum(p.depozit1)as depozit1_01, sum(p.depozit1_tax) as depozit1pdv_01,
  sum(p.depozit2)as depozit2_01, sum(p.depozit2_tax) as depozit2pdv_01,
  sum(ktpay.value_pay) as billkt_01_4, sum(ktpay.value_tax) as billktpdv_01_4 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  left join (
   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
   from (select id_client,
 --   case when date_part(''year'',mmgg)=2008 and date_part(''year'',hmmgg)=2007 then ''2008-01-01'' else hmmgg end as hmmgg ,
      date_part(''year'',hmmgg) as gg, 
  sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax 
   from 
    -- seb_obrs_tmp 
   (select id_client,id_pref,mmgg, case when date_part(''year'',mmgg)=2009 and date_part(''year'',hmmgg)=2008 then ''2009-01-01'' 
					when date_part(''year'',mmgg)=2010 and date_part(''year'',hmmgg)=2009 then ''2010-01-01'' 
					when date_part(''year'',mmgg)=2011 and date_part(''year'',hmmgg)=2010 then ''2011-01-01''
					else hmmgg end as hmmgg ,
     b_ktval,b_ktval_tax,e_ktval,e_ktval_tax from  seb_obrs_tmp 
   ) as seb_obrs_tmp --obrs
    --��ᥫ���� �� ��७�ᨬ 2007-2006
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 
  where period =  date_trunc(''month'', pmmgg) and roz in (9,13) and s.id_pref = ppref and c.idk_work not in (0,10,99)
  --������ ᮡ�⢥��� �㦤�
--  and not exists (select b2.id_client from acm_bill_tbl as b2 join acd_billsum_tbl as bs2 using (id_doc) 
--    where bs2.id_tariff = 900002 and b2.id_client = s.id_client and bs2.demand_val <> 0 and  b2.mmgg =  date_trunc(''month'', pmmgg) )
) as s01_4 using (key) 
  join (select ppref as key, 
  -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)) as deb_b_01_5,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)) as dpdv_b_01_5, 
  sum(kr_zpmv) as kr_b_01_5, sum(kr_zpmpdv) as kpdv_b_01_5, 
  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)) as deb_e_01_5, -sum(deb_kmpdv-coalesce(deb_km00pdv,0)) as dpdv_e_01_5, 
  sum(kr_zkmv) as kr_e_01_5, sum(kr_zkmpdv) as kpdv_e_01_5, 
  sum(nar) as kvt_01_5,sum(nar_v) as dem_01_5,sum(nar_pdv) as dempdv_01_5, 
  sum(p.pay) as opl_01_5,sum(p.pay_tax) as oplpdv_01_5, 
  sum(p.writeoff)as sp1_01_5, sum(p.writeoff_tax)as sp1pdv_01_5,sum(p.trush)as sp2_01_5, sum(p.trush_tax)as sp2pdv_01_5, 
  sum(ktpay.value_pay) as billkt_01_5, sum(ktpay.value_tax) as billktpdv_01_5 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  left join (
   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
   from (select id_client,date_part(''year'',hmmgg) as gg, sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, case when date_part(''year'',mmgg)=2009 and date_part(''year'',hmmgg)=2008 then ''2009-01-01'' 
					when date_part(''year'',mmgg)=2010 and date_part(''year'',hmmgg)=2009 then ''2010-01-01''
					when date_part(''year'',mmgg)=2011 and date_part(''year'',hmmgg)=2010 then ''2011-01-01''
					else hmmgg end as hmmgg ,b_ktval,b_ktval_tax,e_ktval,e_ktval_tax from  seb_obrs_tmp ) as obrs
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 
  where period =  date_trunc(''month'', pmmgg) 
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
  --������ ᮡ�⢥��� �㦤�
--  and not exists (select b2.id_client from acm_bill_tbl as b2 join acd_billsum_tbl as bs2 using (id_doc) 
--    where bs2.id_tariff = 900002 and b2.id_client = s.id_client and bs2.demand_val <> 0 and b2.mmgg =  date_trunc(''month'', pmmgg) )
) as s01_5 using (key)

join (select ppref as key, 
  -sum(deb_pm00v) as deb_b_00_1,-sum(deb_pm00pdv) as dpdv_b_00_1, 
  -sum(deb_km00v) as deb_e_00_1, -sum(deb_km00pdv) as dpdv_e_00_1, 
  sum(p.pay) as opl_00_1,sum(p.pay_tax) as oplpdv_00_1, 
  sum(p.writeoff)as sp1_00_1, sum(p.writeoff_tax)as sp1pdv_00_1,sum(p.trush)as sp2_00_1, sum(p.trush_tax)as sp2pdv_00_1 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2000 and p.id_pref = ppref and p.mmgg = period) 
  join clm_statecl_h as cp on (cp.id_client=s.id_client)
  where period =  date_trunc(''month'', pmmgg) and s.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  ) as s00_1 using (key) 
  join (select ppref as key, 
  -sum(deb_pm00v) as deb_b_00_2,-sum(deb_pm00pdv) as dpdv_b_00_2, 
  -sum(deb_km00v) as deb_e_00_2, -sum(deb_km00pdv) as dpdv_e_00_2, 
  sum(p.pay) as opl_00_2,sum(p.pay_tax) as oplpdv_00_2, 
  sum(p.writeoff)as sp1_00_2, sum(p.writeoff_tax)as sp1pdv_00_2,sum(p.trush)as sp2_00_2, sum(p.trush_tax)as sp2pdv_00_2 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2000 and p.id_pref = ppref and p.mmgg = period) 
  where period =  date_trunc(''month'', pmmgg) and roz in (11) and s.id_pref = ppref) as s00_2 using (key) 
  join (select ppref as key, 
  -sum(deb_pm00v) as deb_b_00_3,-sum(deb_pm00pdv) as dpdv_b_00_3, 
  -sum(deb_km00v) as deb_e_00_3, -sum(deb_km00pdv) as dpdv_e_00_3, 
  sum(p.pay) as opl_00_3,sum(p.pay_tax) as oplpdv_00_3, 
  sum(p.writeoff)as sp1_00_3, sum(p.writeoff_tax)as sp1pdv_00_3,sum(p.trush)as sp2_00_3, sum(p.trush_tax)as sp2pdv_00_3 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2000 and p.id_pref = ppref and p.mmgg = period) 
  where period =  date_trunc(''month'', pmmgg) and roz in (12) and s.id_pref = ppref) as s00_3 using (key) 
  join (select ppref as key, 
  -sum(deb_pm00v) as deb_b_00_4,-sum(deb_pm00pdv) as dpdv_b_00_4, 
  -sum(deb_km00v) as deb_e_00_4, -sum(deb_km00pdv) as dpdv_e_00_4, 
  sum(p.pay) as opl_00_4,sum(p.pay_tax) as oplpdv_00_4, 
  sum(p.writeoff)as sp1_00_4, sum(p.writeoff_tax)as sp1pdv_00_4,sum(p.trush)as sp2_00_4, sum(p.trush_tax)as sp2pdv_00_4, 
  sum(p.depozit1)as depozit1_00, sum(p.depozit1_tax) as depozit1pdv_00,
  sum(p.depozit2)as depozit2_00, sum(p.depozit2_tax) as depozit2pdv_00
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2000 and p.id_pref = ppref and p.mmgg = period) 
  where period =  date_trunc(''month'', pmmgg) and roz in (9,13) and s.id_pref = ppref) as s00_4 using (key) 
  join (select ppref as key, 
  -sum(deb_pm00v) as deb_b_00_5,-sum(deb_pm00pdv) as dpdv_b_00_5, 
  -sum(deb_km00v) as deb_e_00_5, -sum(deb_km00pdv) as dpdv_e_00_5, 
  sum(p.pay) as opl_00_5,sum(p.pay_tax) as oplpdv_00_5, 
  sum(p.writeoff)as sp1_00_5, sum(p.writeoff_tax)as sp1pdv_00_5,sum(p.trush)as sp2_00_5, sum(p.trush_tax)as sp2pdv_00_5 
  from seb_obr_all_tmp as s left  join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2000 and p.id_pref = ppref and p.mmgg = period) 
  join clm_statecl_h as cp on (cp.id_client=s.id_client)
  where period =  date_trunc(''month'', pmmgg) and roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
 ) as s00_5 using (key) 
 join (select ppref as key, 
  -sum(deb_pm99v) as deb_b_99_1,-sum(deb_km99v) as deb_e_99_1, 
  sum(p.pay) as opl_99_1,  sum(p.writeoff)as sp1_99_1, sum(p.trush)as sp2_99_1 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 1999 and p.id_pref = ppref and p.mmgg = period) 
  join clm_statecl_h as cp on (cp.id_client=s.id_client)
  where s.period =  date_trunc(''month'', pmmgg) and s.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
 ) as s99_1 using (key) 
  join (select ppref as key, 
  -sum(deb_pm99v) as deb_b_99_2,-sum(deb_km99v) as deb_e_99_2, 
  sum(p.pay) as opl_99_2,  sum(p.writeoff)as sp1_99_2, sum(p.trush)as sp2_99_2 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 1999 and p.id_pref = ppref and p.mmgg = period) 
  where period =  date_trunc(''month'', pmmgg) and roz in (11) and s.id_pref = ppref) as s99_2 using (key) 
  join (select ppref as key, 
  -sum(deb_pm99v) as deb_b_99_3,-sum(deb_km99v) as deb_e_99_3, 
  sum(p.pay) as opl_99_3,  sum(p.writeoff)as sp1_99_3, sum(p.trush)as sp2_99_3 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 1999 and p.id_pref = ppref and p.mmgg = period) 
  where period =  date_trunc(''month'', pmmgg) and roz in (12) and s.id_pref = ppref) as s99_3 using (key) 
  join (select ppref as key, 
  -sum(deb_pm99v) as deb_b_99_4, -sum(deb_km99v) as deb_e_99_4, 
  sum(p.pay) as opl_99_4,  sum(p.writeoff)as sp1_99_4, sum(p.trush)as sp2_99_4 ,
  sum(p.depozit1)as depozit1_99, sum(p.depozit2)as depozit2_99 

  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 1999 and p.id_pref = ppref and p.mmgg = period) 
  where period =  date_trunc(''month'', pmmgg) and roz in (9,13) and s.id_pref = ppref) as s99_4 using (key) 
  join (select ppref as key, 
  -sum(deb_pm99v) as deb_b_99_5,-sum(deb_km99v) as deb_e_99_5, 
  sum(p.pay) as opl_99_5,  sum(p.writeoff) as sp1_99_5, sum(p.trush) as sp2_99_5 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 1999 and p.id_pref = ppref and p.mmgg = period) 
  join clm_statecl_h as cp on (cp.id_client=s.id_client)
  where period =  date_trunc(''month'', pmmgg) and roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  ) as s99_5 using (key)
  join (select ppref as key, 
  -sum(deb_pm01v) as deb_b_008_4,-sum(deb_pm01pdv) as dpdv_b_008_4, 
  -sum(deb_km01v) as deb_e_008_4, -sum(deb_km01pdv) as dpdv_e_008_4, 
  sum(p.pay) as opl_008_4,sum(p.pay_tax) as oplpdv_008_4, 
  sum(p.writeoff)as sp1_008_4, sum(p.writeoff_tax)as sp1pdv_008_4,sum(p.trush)as sp2_008_4, sum(p.trush_tax)as sp2pdv_008_4, 
  sum(p.depozit1)as depozit1_008, sum(p.depozit1_tax) as depozit1pdv_008,
  sum(p.depozit2)as depozit2_008, sum(p.depozit2_tax) as depozit2pdv_008
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  where period =  date_trunc(''month'', pmmgg) and roz in (9,13) and s.id_pref = ppref and c.idk_work = 10 ) as s008_4 using (key) ;


RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          
