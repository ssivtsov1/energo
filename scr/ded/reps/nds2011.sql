;
set client_encoding = 'win';
/*
ALTER TABLE rep_nds2011_tbl ADD COLUMN deb_e_01_5 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN deb_e_01_5 SET DEFAULT 0;

ALTER TABLE rep_nds2011_tbl ADD COLUMN dpdv_e_01_5 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN dpdv_e_01_5 SET DEFAULT 0;

ALTER TABLE rep_nds2011_tbl ADD COLUMN kr_e_01_5 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN kr_e_01_5 SET DEFAULT 0;

ALTER TABLE rep_nds2011_tbl ADD COLUMN kpdv_e_01_5 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN kpdv_e_01_5 SET DEFAULT 0;


ALTER TABLE rep_nds2011_tbl ADD COLUMN deb_e_01_1 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN deb_e_01_1 SET DEFAULT 0;

ALTER TABLE rep_nds2011_tbl ADD COLUMN dpdv_e_01_1 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN dpdv_e_01_1 SET DEFAULT 0;

ALTER TABLE rep_nds2011_tbl ADD COLUMN kr_e_01_1 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN kr_e_01_1 SET DEFAULT 0;

ALTER TABLE rep_nds2011_tbl ADD COLUMN kpdv_e_01_1 numeric(14,2);
ALTER TABLE rep_nds2011_tbl ALTER COLUMN kpdv_e_01_1 SET DEFAULT 0;

UPDATE rep_nds2011_tbl set flock=0 ;

 update rep_nds2011_tbl set deb_e_01_1 =  coalesce(deb_b_01_1,0) - coalesce(opl_01_1,0) - coalesce(sp1_01_1,0)- coalesce(sp2_01_1,0)
 where deb_e_01_1 is null; 

 update rep_nds2011_tbl set dpdv_e_01_1 = coalesce(dpdv_b_01_1,0) - coalesce(oplpdv_01_1,0) - coalesce(sp1pdv_01_1,0)- coalesce(sp2pdv_01_1,0)
 where dpdv_e_01_1 is null; 

 update rep_nds2011_tbl set deb_e_01_5 = coalesce(deb_b_01_5,0) - coalesce(opl_01_5,0) - coalesce(sp1_01_5,0)- coalesce(sp2_01_5,0)
 where deb_e_01_5 is null; 

 update rep_nds2011_tbl set dpdv_e_01_5 = coalesce(dpdv_b_01_5,0) - coalesce(oplpdv_01_5,0) - coalesce(sp1pdv_01_5,0)- coalesce(sp2pdv_01_5,0)
 where dpdv_e_01_5 is null; 

 update rep_nds2011_tbl set kr_e_01_1 = coalesce(kr_b_01_1,0) - coalesce(billkt_01_1,0)
 where kr_e_01_1 is null; 
 update rep_nds2011_tbl set kpdv_e_01_1 = coalesce(kpdv_b_01_1,0) - coalesce(billktpdv_01_1,0)
 where kpdv_e_01_1 is null; 

 update rep_nds2011_tbl set kr_e_01_5 = coalesce(kr_b_01_5,0) - coalesce(billkt_01_5,0)
 where kr_e_01_5 is null; 
 update rep_nds2011_tbl set kpdv_e_01_5 = coalesce(kpdv_b_01_5,0) - coalesce(billktpdv_01_5,0)
 where kpdv_e_01_5 is null; 

UPDATE rep_nds2011_tbl set flock=1 where mmgg < '2012-01-01';

*/

  /*

CREATE TABLE rep_nds2011_fiz_tbl (
    mmgg date,
    id_pref integer default 10,
    id_grp int,
    deb_b_01  numeric(14,2) default 0,
    dpdv_b_01 numeric(14,2) default 0,
    kr_b_01   numeric(14,2) default 0,
    kpdv_b_01 numeric(14,2) default 0,
    deb_e_01  numeric(14,2) default 0,
    dpdv_e_01 numeric(14,2) default 0,
    kr_e_01   numeric(14,2) default 0,
    kpdv_e_01 numeric(14,2) default 0,
    kvt_01    numeric(14,2) default 0,
    dem_01    numeric(14,2) default 0,
    dempdv_01 numeric(14,2) default 0,
    opl_01    numeric(14,2) default 0,
    oplpdv_01 numeric(14,2) default 0,
    sp1_01    numeric(14,2) default 0,
    sp1pdv_01 numeric(14,2) default 0,
    sp2_01    numeric(14,2) default 0,
    sp2pdv_01 numeric(14,2) default 0,
    depozit1_01  numeric(14,2) default 0,
    depozit1pdv_01  numeric(14,2) default 0,
    depozit2_01  numeric(14,2) default 0,
    depozit2pdv_01  numeric(14,2) default 0,
--    billkt_01 numeric(14,2) default 0,
--    billktpdv_01 numeric(14,2) default 0,
    primary key (mmgg, id_pref,id_grp)
);

     */

create or replace function rep_nds2011_fun(date,int,bool) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
  ppref alias for $2;
  pbuild alias for $3;
  v int;
  r record;
  vid_pref int;
  r_old record;
  vkodres varchar;
  vkor_kt record;
  vopl_01 record;

BEGIN

 if pmmgg < ''2011-04-01'' then

  return 0;

 end if;

 if (pmmgg >= ''2016-01-01'') and (ppref = 10)  then

  return 0;

 end if;

 if (pmmgg >= ''2016-03-01'') and (ppref = 20)  then

  return 0;

 end if;


 if pbuild then 

  perform seb_all(0, date_trunc(''month'', pmmgg)::date );

 end if;

 select trim(value_ident) into vkodres from syi_sysvars_tbl where ident=''kod_res''; 

 perform rep_mmggpay_fun(ppref,date_trunc(''month'', pmmgg)::date);

 if ( select flock from rep_nds2011_tbl where mmgg = pmmgg and id_pref = ppref) = 1 then
  raise notice ''closed month!'';
  return -1;
 end if;

 delete from rep_nds2011_tbl where mmgg = pmmgg and id_pref = ppref and flock = 0;

insert into rep_nds2011_tbl ( mmgg, id_pref, deb_b_11_1, dpdv_b_11_1, kr_b_11_1, kpdv_b_11_1, 
            deb_e_11_1, dpdv_e_11_1, kr_e_11_1, kpdv_e_11_1, kvt_11_1, dem_11_1, 
            dempdv_11_1, opl_11_1, oplpdv_11_1, sp1_11_1, sp1pdv_11_1, sp2_11_1, 
            sp2pdv_11_1, billkt_11_1, billktpdv_11_1, deb_b_11_2, dpdv_b_11_2, 
            kr_b_11_2, kpdv_b_11_2, deb_e_11_2, dpdv_e_11_2, kr_e_11_2, kpdv_e_11_2, 
            kvt_11_2, dem_11_2, dempdv_11_2, opl_11_2, oplpdv_11_2, sp1_11_2, 
            sp1pdv_11_2, sp2_11_2, sp2pdv_11_2, billkt_11_2, billktpdv_11_2, 
            deb_b_11_3, dpdv_b_11_3, kr_b_11_3, kpdv_b_11_3, deb_e_11_3, 
            dpdv_e_11_3, kr_e_11_3, kpdv_e_11_3, kvt_11_3, dem_11_3, dempdv_11_3, 
            opl_11_3, oplpdv_11_3, sp1_11_3, sp1pdv_11_3, sp2_11_3, sp2pdv_11_3, 
            billkt_11_3, billktpdv_11_3, deb_b_11_4, dpdv_b_11_4, kr_b_11_4, 
            kpdv_b_11_4, deb_e_11_4, dpdv_e_11_4, kr_e_11_4, kpdv_e_11_4, 
            kvt_11_4, dem_11_4, dempdv_11_4, opl_11_4, oplpdv_11_4, sp1_11_4, 
            sp1pdv_11_4, sp2_11_4, sp2pdv_11_4, depozit1_11, depozit1pdv_11, 
            depozit2_11, depozit2pdv_11, billkt_11_4, billktpdv_11_4, deb_b_11_5, 
            dpdv_b_11_5, kr_b_11_5, kpdv_b_11_5, deb_e_11_5, dpdv_e_11_5, 
            kr_e_11_5, kpdv_e_11_5, kvt_11_5, dem_11_5, dempdv_11_5, opl_11_5, 
            oplpdv_11_5, sp1_11_5, sp1pdv_11_5, sp2_11_5, sp2pdv_11_5, billkt_11_5, 
            billktpdv_11_5)
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
   from (select id_client,date_part(''year'',hmmgg) as gg, numeric_larger(0,sum(b_ktval)) as kt, numeric_larger(0,sum(b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, 
    CASE WHEN c.order_pay = 0 THEN date_trunc(''year'',pmmgg::date)::date ELSE hmmgg end as hmmgg ,
      b_ktval,b_ktval_tax,e_ktval,e_ktval_tax 
      from  seb_obrs_tmp as t
      join clm_client_tbl as c on (c.id = t.id_client)
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
   from (select id_client,date_part(''year'',hmmgg) as gg, numeric_larger(0,sum(b_ktval)) as kt, numeric_larger(0,sum(b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, 
    CASE WHEN c.order_pay = 0 THEN date_trunc(''year'',pmmgg::date)::date ELSE hmmgg end as hmmgg ,
    b_ktval,b_ktval_tax,e_ktval,e_ktval_tax 
    from  seb_obrs_tmp as t
    join clm_client_tbl as c on (c.id = t.id_client)
) as obrs
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 
  where period =  date_trunc(''month'', pmmgg) and roz in (11) and s.id_pref = ppref and c.idk_work not in (0,99)
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
   from (select id_client,date_part(''year'',hmmgg) as gg, numeric_larger(0,sum(b_ktval)) as kt, numeric_larger(0,sum(b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, 
    CASE WHEN c.order_pay = 0 THEN date_trunc(''year'',pmmgg::date)::date ELSE hmmgg end as hmmgg ,
    b_ktval,b_ktval_tax,e_ktval,e_ktval_tax 
    from  seb_obrs_tmp as t
    join clm_client_tbl as c on (c.id = t.id_client)
) as obrs
   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
   having sum(b_ktval+b_ktval_tax) <>0 ) s
   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 

  where period =  date_trunc(''month'', pmmgg) and roz in (12) and s.id_pref = ppref and c.idk_work not in (0,99)
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
--0
-- погашение кт по населению всегда идет по одному лицевому, и все начисление по нему идет в погашение кредита
  left join (
   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
   from (select id_client,  sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax 
   from 
   (select id_client,id_pref,  sum(b_ktval) as b_ktval, sum(b_ktval_tax) as b_ktval_tax ,sum(e_ktval) as e_ktval, sum(e_ktval_tax) as e_ktval_tax
        from  seb_obrs_tmp as t
      group by id_client,id_pref
   ) as seb_obrs_tmp --obrs
   where  id_pref = ppref and id_client is not null group by id_client ) as s 
   join ( select id_client, sum(value) as billsum, sum(value_tax) as billtax
   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) group by id_client ) as b
   on (b.id_client =s.id_client  ) group by s.id_client
) as ktpay  on (ktpay.id_client= s.id_client) 
--0
--  left join (
--   select s.id_client, sum(numeric_smaller(s.kt,b.billsum))+sum(numeric_smaller(s.kt_tax,b.billtax)) as value_pay, sum(numeric_smaller(s.kt_tax,b.billtax)) as value_tax    
--   from (select id_client,
--      date_part(''year'',hmmgg) as gg, 
--  sum(numeric_larger(0,b_ktval)) as kt, sum(numeric_larger(0,b_ktval_tax)) as kt_tax 
--   from 
--   (select id_client,id_pref,mmgg, case when date_part(''year'',mmgg)=2009 and date_part(''year'',hmmgg)=2008 then ''2009-01-01'' 
--					when date_part(''year'',mmgg)=2010 and date_part(''year'',hmmgg)=2009 then ''2010-01-01'' 
--					when date_part(''year'',mmgg)=2011 and date_part(''year'',hmmgg)=2010 then ''2011-01-01''
--					when date_part(''year'',mmgg)=2012 and date_part(''year'',hmmgg)=2011 then ''2012-01-01''
--					when date_part(''year'',mmgg)=2013 and date_part(''year'',hmmgg)=2012 then ''2013-01-01''
--					when date_part(''year'',mmgg)=2014 and date_part(''year'',hmmgg)=2013 then ''2014-01-01''
--					when date_part(''year'',mmgg)=2015 and date_part(''year'',hmmgg)=2014 then ''2015-01-01''
--					else hmmgg end as hmmgg ,
--     b_ktval,b_ktval_tax,e_ktval,e_ktval_tax from  seb_obrs_tmp as t
--	join clm_client_tbl as c on (c.id = t.id_client)
--   ) as seb_obrs_tmp --obrs
--
--   where  id_pref = ppref and id_client is not null group by id_client ,date_part(''year'',hmmgg) 
--   having sum(b_ktval+b_ktval_tax) <>0 ) s
--   join ( select id_client, date_part(''year'',mmgg_bill) as gg, sum(value) as billsum, sum(value_tax) as billtax
--   from  acm_bill_tbl where id_pref = ppref and mmgg = date_trunc(''month'', pmmgg) and value >0 group by id_client ,date_part(''year'',mmgg_bill) ) as b
--   on (b.id_client =s.id_client and s.gg =b.gg ) group by s.id_client
--) as ktpay  on (ktpay.id_client= s.id_client) 
  where period =  date_trunc(''month'', pmmgg) and roz in (9,13) and s.id_pref = ppref and c.idk_work not in (0,10,99)
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
   from (select id_client,date_part(''year'',hmmgg) as gg, numeric_larger(0,sum(b_ktval)) as kt, numeric_larger(0,sum(b_ktval_tax)) as kt_tax from 
   (select id_client,id_pref,mmgg, 
    CASE WHEN c.order_pay = 0 THEN date_trunc(''year'',pmmgg::date)::date ELSE hmmgg end as hmmgg ,
    b_ktval,b_ktval_tax,e_ktval,e_ktval_tax 
   from  seb_obrs_tmp as t
   join clm_client_tbl as c on (c.id = t.id_client)
) as obrs
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
) as s01_5 using (key);

--------------------------------------------------------------

 if pmmgg = ''2011-04-01'' then

  -- сальдо на начало 
  update rep_nds2011_tbl set 
   deb_b_01_1=deb_b_11_1, dpdv_b_01_1=dpdv_b_11_1, kr_b_01_1=kr_b_11_1, kpdv_b_01_1=kpdv_b_11_1, 
   deb_b_01_2=deb_b_11_2, dpdv_b_01_2=dpdv_b_11_2, kr_b_01_2=kr_b_11_2, kpdv_b_01_2=kpdv_b_11_2, 
   deb_b_01_3=deb_b_11_3, dpdv_b_01_3=dpdv_b_11_3, kr_b_01_3=kr_b_11_3, kpdv_b_01_3=kpdv_b_11_3, 
   deb_b_01_4=deb_b_11_4, dpdv_b_01_4=dpdv_b_11_4, kr_b_01_4=kr_b_11_4, kpdv_b_01_4=kpdv_b_11_4, 
   deb_b_01_5=deb_b_11_5, dpdv_b_01_5=dpdv_b_11_5, kr_b_01_5=kr_b_11_5, kpdv_b_01_5=kpdv_b_11_5 
  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

--  update rep_nds2011_tbl set 
--   deb_b_11_1=0, dpdv_b_11_1=0, kr_b_11_1=0, kpdv_b_11_1=0, 
--   deb_b_11_2=0, dpdv_b_11_2=0, kr_b_11_2=0, kpdv_b_11_2=0, 
--   deb_b_11_3=0, dpdv_b_11_3=0, kr_b_11_3=0, kpdv_b_11_3=0, 
--   deb_b_11_4=0, dpdv_b_11_4=0, kr_b_11_4=0, kpdv_b_11_4=0, 
--   deb_b_11_5=0, dpdv_b_11_5=0, kr_b_11_5=0, kpdv_b_11_5=0 
--  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

  -- в первом месяце сумма счета в погашение кредита будет равне общей сумме счетов погашенных кредитом

  update rep_nds2011_tbl set billkt_01_1 = billkt_11_1, billktpdv_01_1  = billktpdv_11_1,
		  	     billkt_01_2 = billkt_11_2, billktpdv_01_2  = billktpdv_11_2,
		  	     billkt_01_3 = billkt_11_3, billktpdv_01_3  = billktpdv_11_3,
		  	     billkt_01_4 = billkt_11_4, billktpdv_01_4  = billktpdv_11_4,
		  	     billkt_01_5 = billkt_11_5, billktpdv_01_5  = billktpdv_11_5
  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 else

  select into r_old * from rep_nds2011_tbl where id_pref = ppref and mmgg = pmmgg - ''1 month''::interval;

  update rep_nds2011_tbl set 
----   deb_b_01_1= coalesce(r_old.deb_b_01_1,0) - coalesce(r_old.opl_01_1,0) - coalesce(r_old.sp1_01_1,0)- coalesce(r_old.sp2_01_1,0),
   deb_b_01_1= coalesce(r_old.deb_e_01_1,0),
--   deb_b_01_2= coalesce(r_old.deb_b_01_2,0) - coalesce(r_old.opl_01_2,0) - coalesce(r_old.sp1_01_2,0)- coalesce(r_old.sp2_01_2,0),
--   deb_b_01_3= coalesce(r_old.deb_b_01_3,0) - coalesce(r_old.opl_01_3,0) - coalesce(r_old.sp1_01_3,0)- coalesce(r_old.sp2_01_3,0),
--   deb_b_01_4= coalesce(r_old.deb_b_01_4,0) - coalesce(r_old.opl_01_4,0) - coalesce(r_old.sp1_01_4,0)- coalesce(r_old.sp2_01_4,0),
   deb_b_01_2= coalesce(r_old.deb_e_01_2,0) ,
   deb_b_01_3= coalesce(r_old.deb_e_01_3,0) ,
   deb_b_01_4= coalesce(r_old.deb_e_01_4,0) ,

----   deb_b_01_5= coalesce(r_old.deb_b_01_5,0) - coalesce(r_old.opl_01_5,0) - coalesce(r_old.sp1_01_5,0)- coalesce(r_old.sp2_01_5,0),
   deb_b_01_5= coalesce(r_old.deb_e_01_5,0) ,

----   dpdv_b_01_1= coalesce(r_old.dpdv_b_01_1,0) - coalesce(r_old.oplpdv_01_1,0) - coalesce(r_old.sp1pdv_01_1,0)- coalesce(r_old.sp2pdv_01_1,0),
   dpdv_b_01_1= coalesce(r_old.dpdv_e_01_1,0) ,
--   dpdv_b_01_2= coalesce(r_old.dpdv_b_01_2,0) - coalesce(r_old.oplpdv_01_2,0) - coalesce(r_old.sp1pdv_01_2,0)- coalesce(r_old.sp2pdv_01_2,0),
--   dpdv_b_01_3= coalesce(r_old.dpdv_b_01_3,0) - coalesce(r_old.oplpdv_01_3,0) - coalesce(r_old.sp1pdv_01_3,0)- coalesce(r_old.sp2pdv_01_3,0),
--   dpdv_b_01_4= coalesce(r_old.dpdv_b_01_4,0) - coalesce(r_old.oplpdv_01_4,0) - coalesce(r_old.sp1pdv_01_4,0)- coalesce(r_old.sp2pdv_01_4,0),
   dpdv_b_01_2= coalesce(r_old.dpdv_e_01_2,0) ,
   dpdv_b_01_3= coalesce(r_old.dpdv_e_01_3,0) ,
   dpdv_b_01_4= coalesce(r_old.dpdv_e_01_4,0) ,
----   dpdv_b_01_5= coalesce(r_old.dpdv_b_01_5,0) - coalesce(r_old.oplpdv_01_5,0) - coalesce(r_old.sp1pdv_01_5,0)- coalesce(r_old.sp2pdv_01_5,0),
   dpdv_b_01_5= coalesce(r_old.dpdv_e_01_5,0),

----   kr_b_01_1= coalesce(r_old.kr_b_01_1,0) - coalesce(r_old.billkt_01_1,0),
   kr_b_01_1= coalesce(r_old.kr_e_01_1,0),
--   kr_b_01_2= coalesce(r_old.kr_b_01_2,0) - coalesce(r_old.billkt_02_1,0),
--   kr_b_01_3= coalesce(r_old.kr_b_01_3,0) - coalesce(r_old.billkt_03_1,0),
--   kr_b_01_4= coalesce(r_old.kr_b_01_4,0) - coalesce(r_old.billkt_04_1,0),
   kr_b_01_2= coalesce(r_old.kr_e_01_2,0) ,
   kr_b_01_3= coalesce(r_old.kr_e_01_3,0) ,
   kr_b_01_4= coalesce(r_old.kr_e_01_4,0) ,
----   kr_b_01_5= coalesce(r_old.kr_b_01_5,0) - coalesce(r_old.billkt_01_5,0),
   kr_b_01_5= coalesce(r_old.kr_e_01_5,0) ,

----   kpdv_b_01_1= coalesce(r_old.kpdv_b_01_1,0) - coalesce(r_old.billktpdv_01_1,0),
   kpdv_b_01_1= coalesce(r_old.kpdv_e_01_1,0) ,
--   kpdv_b_01_2= coalesce(r_old.kpdv_b_01_2,0) - coalesce(r_old.billktpdv_02_1,0),
--   kpdv_b_01_3= coalesce(r_old.kpdv_b_01_3,0) - coalesce(r_old.billktpdv_03_1,0),
--   kpdv_b_01_4= coalesce(r_old.kpdv_b_01_4,0) - coalesce(r_old.billktpdv_04_1,0),
   kpdv_b_01_2= coalesce(r_old.kpdv_e_01_2,0) ,
   kpdv_b_01_3= coalesce(r_old.kpdv_e_01_3,0) ,
   kpdv_b_01_4= coalesce(r_old.kpdv_e_01_4,0) ,
----   kpdv_b_01_5= coalesce(r_old.kpdv_b_01_5,0) - coalesce(r_old.billktpdv_01_5,0)
   kpdv_b_01_5= coalesce(r_old.kpdv_e_01_5,0) 
  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 end if;

-------------------------------------------------------------------------
  -- посчитаем сумму счетов, погашенных авансами прошлого 
  -- и киловаты пропорционально общей сумме счета

  update rep_nds2011_tbl set 
  billkt_01_1     = numeric_smaller(numeric_larger(kr_b_01_1, 0), coalesce(sum_val1+sum_tax1,0)), 
  billktpdv_01_1  = numeric_smaller(numeric_larger(kpdv_b_01_1, 0), coalesce(sum_tax1,0)),
  billkt_01_2     = numeric_smaller(numeric_larger(kr_b_01_2, 0), coalesce(sum_val2+sum_tax2,0)), 
  billktpdv_01_2  = numeric_smaller(numeric_larger(kpdv_b_01_2, 0), coalesce(sum_tax2,0)),
  billkt_01_3     = numeric_smaller(numeric_larger(kr_b_01_3, 0), coalesce(sum_val3+sum_tax3,0)),
  billktpdv_01_3  = numeric_smaller(numeric_larger(kpdv_b_01_3, 0), coalesce(sum_tax3,0)),
  billkt_01_4     = numeric_smaller(numeric_larger(kr_b_01_4, 0), coalesce(sum_val4+sum_tax4,0)),
  billktpdv_01_4  = numeric_smaller(numeric_larger(kpdv_b_01_4, 0), coalesce(sum_tax4,0)),
  billkt_01_5     = numeric_smaller(numeric_larger(kr_b_01_5, 0), coalesce(sum_val5+sum_tax5,0)),
  billktpdv_01_5  = numeric_smaller(numeric_larger(kpdv_b_01_5, 0), coalesce(sum_tax5,0))

  from 
  (select sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN bp.value ELSE 0 END) as sum_val1,
        sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN bp.value_tax ELSE 0 END) as sum_tax1,
        sum(CASE WHEN scl.id_section =206 THEN bp.value ELSE 0 END) as sum_val2,
        sum(CASE WHEN scl.id_section =206 THEN bp.value_tax ELSE 0 END) as sum_tax2,
        sum(CASE WHEN scl.id_section =207 THEN bp.value ELSE 0 END) as sum_val3,
        sum(CASE WHEN scl.id_section =207 THEN bp.value_tax ELSE 0 END) as sum_tax3,
        sum(CASE WHEN scl.id_section in (205,208)  THEN bp.value ELSE 0 END) as sum_val4,
        sum(CASE WHEN scl.id_section in (205,208)  THEN bp.value_tax ELSE 0 END) as sum_tax4,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN bp.value ELSE 0 END) as sum_val5,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN bp.value_tax ELSE 0 END) as sum_tax5--,

        --sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN round(b.demand_val::numeric*bp.value/ b.value,0) ELSE 0 END) as dem1,
        --sum(CASE WHEN scl.id_section =206 THEN round(b.demand_val::numeric*bp.value/ b.value,0) ELSE 0 END) as dem2,
        --sum(CASE WHEN scl.id_section =207 THEN round(b.demand_val::numeric*bp.value/ b.value,0) ELSE 0 END) as dem3,
        --sum(CASE WHEN scl.id_section in (205,208)  THEN round(b.demand_val::numeric*bp.value/ b.value,0) ELSE 0 END) as dem4,
        --sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN round(b.demand_val::numeric*bp.value/b.value,0) ELSE 0 END) as dem5

     from acm_billpay_tbl as bp
     left join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     left join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     left join clm_client_tbl as cm on (cm.id = b.id_client)
     left join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and date_part(''year'',p.mmgg_pay) > 2000 
     and p.mmgg < ''2011-04-01''
     and bp.value <> 0 
     and cm.idk_work not in (0,10,99)
     and (vkodres<> ''120'' or cm.code <> 103 or b.id_pref <>20 ) -- 103 абонент борзны не должен попадать в прошлый период
  ) as sss
   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;



 update rep_nds2011_tbl set dem_01_1 = billkt_01_1  , dempdv_01_1 = billktpdv_01_1  ,
		  	    dem_01_2 = billkt_01_2  , dempdv_01_2 = billktpdv_01_2  ,
		  	    dem_01_3 = billkt_01_3  , dempdv_01_3 = billktpdv_01_3  ,
		  	    dem_01_4 = billkt_01_4  , dempdv_01_4 = billktpdv_01_4  ,
		  	    dem_01_5 = billkt_01_5  , dempdv_01_5 = billktpdv_01_5  
 where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 -- оплата прошлого периода
--- update rep_nds2011_tbl set opl_01_1 = coalesce(sum_val1+sum_tax1,0), oplpdv_01_1  = coalesce(sum_tax1,0),
---		  	    --opl_01_2 = coalesce(sum_val2+sum_tax2,0), oplpdv_01_2  = coalesce(sum_tax2,0),
---		  	    --opl_01_3 = coalesce(sum_val3+sum_tax3,0), oplpdv_01_3  = coalesce(sum_tax3,0),
---		  	    --opl_01_4 = coalesce(sum_val4+sum_tax4,0), oplpdv_01_4  = coalesce(sum_tax4,0),
---		  	    opl_01_5 = coalesce(sum_val5+sum_tax5,0), oplpdv_01_5  = coalesce(sum_tax5,0)
---  from  (
/*

     select into vopl_01 sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN bp.value ELSE 0 END) as sum_val1,
        sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN bp.value_tax ELSE 0 END) as sum_tax1,
--        sum(CASE WHEN scl.id_section =206 THEN bp.value ELSE 0 END) as sum_val2,
--        sum(CASE WHEN scl.id_section =206 THEN bp.value_tax ELSE 0 END) as sum_tax2,
--        sum(CASE WHEN scl.id_section =207 THEN bp.value ELSE 0 END) as sum_val3,
--        sum(CASE WHEN scl.id_section =207 THEN bp.value_tax ELSE 0 END) as sum_tax3,
--        sum(CASE WHEN scl.id_section in (205,208)  THEN bp.value ELSE 0 END) as sum_val4,
--        sum(CASE WHEN scl.id_section in (205,208)  THEN bp.value_tax ELSE 0 END) as sum_tax4,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN bp.value ELSE 0 END) as sum_val5,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN bp.value_tax ELSE 0 END) as sum_tax5
     from acm_billpay_tbl as bp
     left join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     left join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     left join clm_client_tbl as cm on (cm.id = b.id_client)
     left join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and p.mmgg=pmmgg 
     and p.idk_doc <> 199
     and b.id_pref = ppref
     and date_part(''year'',b.mmgg_bill) > 2000 
     and b.mmgg < ''2011-04-01''
     and bp.value <> 0 
     and cm.idk_work not in (0,10,99)
     and (vkodres<> ''120'' or cm.code <> 103 or b.id_pref <>20 ); -- 103 абонент борзны не должен попадать в прошлый период
---  ) as sss
---   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

*/
     -- Июнь 2012. Думаю можно уже брать без acm_billpay_tbl, просто по периоду оплаты
     select into vopl_01 sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN p.value ELSE 0 END) as sum_val1,
        sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN p.value_tax ELSE 0 END) as sum_tax1,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN p.value ELSE 0 END) as sum_val5,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN p.value_tax ELSE 0 END) as sum_tax5
     from acm_pay_tbl as p 
     join clm_client_tbl as cm on (cm.id = p.id_client)
     join clm_statecl_tbl as scl on (p.id_client=scl.id_client)
     where cm.book = -1 
     and p.mmgg=pmmgg 
     and p.idk_doc <> 199
     and p.id_pref = ppref
     and p.value > 0
     and date_part(''year'',p.mmgg_pay) > 2000 
     and p.mmgg_pay < ''2011-04-01''
     and cm.idk_work not in (0,10,99)
     and (vkodres<> ''120'' or cm.code <> 103 or p.id_pref <>20 ); -- 103 абонент борзны не должен попадать в прошлый период


 -- оплата прошлого периода для населения льгот и субсидий
 -- берем напрямую по периоду оплаты
 update rep_nds2011_tbl set 
                            opl_01_2 = coalesce(sum_val2+sum_tax2,0), oplpdv_01_2  = coalesce(sum_tax2,0),
		  	    opl_01_3 = coalesce(sum_val3+sum_tax3,0), oplpdv_01_3  = coalesce(sum_tax3,0),
		  	    opl_01_4 = coalesce(sum_val4+sum_tax4,0), oplpdv_01_4  = coalesce(sum_tax4,0),

                            sp1_01_2 = coalesce(sp1_val2+sp1_tax2,0), sp1pdv_01_2  = coalesce(sp1_tax2,0),
		  	    sp1_01_3 = coalesce(sp1_val3+sp1_tax3,0), sp1pdv_01_3  = coalesce(sp1_tax3,0),
		  	    sp1_01_4 = coalesce(sp1_val4+sp1_tax4,0), sp1pdv_01_4  = coalesce(sp1_tax4,0)

  from 
  (select
        sum(CASE WHEN scl.id_section =206 and p.idk_doc <> 149 THEN p.value ELSE 0 END) as sum_val2,
        sum(CASE WHEN scl.id_section =206 and p.idk_doc <> 149 THEN p.value_tax ELSE 0 END) as sum_tax2,
        sum(CASE WHEN scl.id_section =207 and p.idk_doc <> 149 THEN p.value ELSE 0 END) as sum_val3,
        sum(CASE WHEN scl.id_section =207 and p.idk_doc <> 149 THEN p.value_tax ELSE 0 END) as sum_tax3,
        sum(CASE WHEN scl.id_section in (205,208)  and p.idk_doc <> 149 THEN p.value ELSE 0 END) as sum_val4,
        sum(CASE WHEN scl.id_section in (205,208)  and p.idk_doc <> 149 THEN p.value_tax ELSE 0 END) as sum_tax4, 

        sum(CASE WHEN scl.id_section =206 and p.idk_doc = 149 THEN p.value ELSE 0 END) as sp1_val2,
        sum(CASE WHEN scl.id_section =206 and p.idk_doc = 149 THEN p.value_tax ELSE 0 END) as sp1_tax2,
        sum(CASE WHEN scl.id_section =207 and p.idk_doc = 149 THEN p.value ELSE 0 END) as sp1_val3,
        sum(CASE WHEN scl.id_section =207 and p.idk_doc = 149 THEN p.value_tax ELSE 0 END) as sp1_tax3,
        sum(CASE WHEN scl.id_section in (205,208)  and p.idk_doc = 149 THEN p.value ELSE 0 END) as sp1_val4,
        sum(CASE WHEN scl.id_section in (205,208)  and p.idk_doc = 149 THEN p.value_tax ELSE 0 END) as sp1_tax4 


     from acm_pay_tbl as p 
     join clm_client_tbl as cm on (cm.id = p.id_client)
     join clm_statecl_tbl as scl on (p.id_client=scl.id_client)
     where cm.book = -1 
     and p.mmgg=pmmgg 
     and p.id_pref = ppref 
     and date_part(''year'',p.mmgg_pay) > 2000 
     and p.mmgg_pay < ''2011-04-01''
     and cm.idk_work not in (0,10,99)
  ) as sss
   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 -- списание кредита проводится через тип документа "Корр.сальдо кредит" (или через отрицательную платежку) и должно уменьшать кредитовое сальдо
 -- берем напрямую по периоду оплаты
    select into vkor_kt sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN p.value ELSE 0 END) as sum_val1,
        sum(CASE WHEN scl.id_section not in (207,206) and scl.flag_budjet=1 THEN p.value_tax ELSE 0 END) as sum_tax1,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN p.value ELSE 0 END) as sum_val5,
        sum(CASE WHEN scl.id_section not in (205,206,207,208,216,217) and scl.flag_budjet=0 THEN p.value_tax ELSE 0 END) as sum_tax5
    from acm_pay_tbl as p 
     join clm_client_tbl as cm on (cm.id = p.id_client)
     join clm_statecl_tbl as scl on (p.id_client=scl.id_client)
     where cm.book = -1 
     and p.mmgg=pmmgg 
     and ((p.idk_doc = 199) or (p.value <0 ))
     and p.id_pref = ppref
     and date_part(''year'',p.mmgg_pay) > 2000 
     and p.mmgg_pay < ''2011-04-01''
     and cm.idk_work not in (0,10,99);


 raise notice ''vkor_kt.sum_val1 %'',vkor_kt.sum_val1;
 raise notice ''vkor_kt.sum_val5 %'',vkor_kt.sum_val5;


 update rep_nds2011_tbl set

	opl_01_1 = coalesce(vopl_01.sum_val1+vopl_01.sum_tax1,0)+coalesce(vkor_kt.sum_val1+vkor_kt.sum_tax1,0), 
   	opl_01_5 = coalesce(vopl_01.sum_val5+vopl_01.sum_tax5,0)+coalesce(vkor_kt.sum_val5+vkor_kt.sum_tax5,0), 
	oplpdv_01_1  = coalesce(vopl_01.sum_tax1,0)+coalesce(vkor_kt.sum_tax1,0),
	oplpdv_01_5  = coalesce(vopl_01.sum_tax5,0)+coalesce(vkor_kt.sum_tax5,0),

	deb_e_01_1 =  coalesce(deb_b_01_1,0) - coalesce(vopl_01.sum_val1+vopl_01.sum_tax1,0) - coalesce(sp1_01_1,0)- coalesce(sp2_01_1,0),
	dpdv_e_01_1 = coalesce(dpdv_b_01_1,0) - coalesce(vopl_01.sum_tax1,0) - coalesce(sp1pdv_01_1,0)- coalesce(sp2pdv_01_1,0),

	deb_e_01_2 = coalesce(deb_b_01_2,0) - coalesce(opl_01_2,0) - coalesce(sp1_01_2,0)- coalesce(sp2_01_2,0),
	dpdv_e_01_2 = coalesce(dpdv_b_01_2,0) - coalesce(oplpdv_01_2,0) - coalesce(sp1pdv_01_2,0)- coalesce(sp2pdv_01_2,0),
	deb_e_01_3 = coalesce(deb_b_01_3,0) - coalesce(opl_01_3,0) - coalesce(sp1_01_3,0)- coalesce(sp2_01_3,0),
	dpdv_e_01_3 = coalesce(dpdv_b_01_3,0) - coalesce(oplpdv_01_3,0) - coalesce(sp1pdv_01_3,0)- coalesce(sp2pdv_01_3,0),
	deb_e_01_4 = coalesce(deb_b_01_4,0) - coalesce(opl_01_4,0) - coalesce(sp1_01_4,0)- coalesce(sp2_01_4,0),
	dpdv_e_01_4 = coalesce(dpdv_b_01_4,0) - coalesce(oplpdv_01_4,0) - coalesce(sp1pdv_01_4,0)- coalesce(sp2pdv_01_4,0),

	deb_e_01_5 = coalesce(deb_b_01_5,0) - coalesce(vopl_01.sum_val5+vopl_01.sum_tax5,0) - coalesce(sp1_01_5,0)- coalesce(sp2_01_5,0),
	dpdv_e_01_5 = coalesce(dpdv_b_01_5,0) - coalesce(vopl_01.sum_tax5,0) - coalesce(sp1pdv_01_5,0)- coalesce(sp2pdv_01_5,0),

	kr_e_01_1 = coalesce(kr_b_01_1,0) - coalesce(billkt_01_1,0)+coalesce(vkor_kt.sum_val1+vkor_kt.sum_tax1,0),
	kpdv_e_01_1 = coalesce(kpdv_b_01_1,0) - coalesce(billktpdv_01_1,0) +coalesce(vkor_kt.sum_tax1,0) ,

	kr_e_01_2 = coalesce(kr_b_01_2,0) - coalesce(billkt_01_2,0),
	kpdv_e_01_2 = coalesce(kpdv_b_01_2,0) - coalesce(billktpdv_01_2,0),
	kr_e_01_3 = coalesce(kr_b_01_3,0) - coalesce(billkt_01_3,0),
	kpdv_e_01_3 = coalesce(kpdv_b_01_3,0) - coalesce(billktpdv_01_3,0),
	kr_e_01_4 = coalesce(kr_b_01_4,0) - coalesce(billkt_01_4,0),
	kpdv_e_01_4 = coalesce(kpdv_b_01_4,0) - coalesce(billktpdv_01_4,0),

	kr_e_01_5 = coalesce(kr_b_01_5,0) - coalesce(billkt_01_5,0)+coalesce(vkor_kt.sum_val5+vkor_kt.sum_tax5,0),
	kpdv_e_01_5 = coalesce(kpdv_b_01_5,0) - coalesce(billktpdv_01_5,0) +coalesce(vkor_kt.sum_tax5,0)

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 -- население, льготы и субсидии вводят в ручную из MSM
 ----------------------------------------------------------------
 update rep_nds2011_tbl set
    deb_e_01_2  =  m.deb_e_01,
    dpdv_e_01_2 =  m.dpdv_e_01,
    kr_e_01_2   =  m.kr_e_01,
    kpdv_e_01_2 =  m.kpdv_e_01,
    kvt_01_2    =  m.kvt_01,
    dem_01_2    =  m.dem_01,
    dempdv_01_2 =  m.dempdv_01,
    opl_01_2    =  m.opl_01,
    oplpdv_01_2 =  m.oplpdv_01,
    sp1_01_2    =  m.sp1_01,
    sp1pdv_01_2 =  m.sp1pdv_01 ,
    sp2_01_2    =  m.sp2_01,
    sp2pdv_01_2 =  m.sp2pdv_01,
    billkt_01_2 =  m.dem_01,
    billktpdv_01_2 = m.dempdv_01
 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 2 
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 update rep_nds2011_tbl set
    deb_e_01_3  =  m.deb_e_01,
    dpdv_e_01_3 =  m.dpdv_e_01,
    kr_e_01_3   =  m.kr_e_01,
    kpdv_e_01_3 =  m.kpdv_e_01,
    kvt_01_3    =  m.kvt_01,
    dem_01_3    =  m.dem_01,
    dempdv_01_3 =  m.dempdv_01,
    opl_01_3    =  m.opl_01,
    oplpdv_01_3 =  m.oplpdv_01,
    sp1_01_3    =  m.sp1_01,
    sp1pdv_01_3 =  m.sp1pdv_01 ,
    sp2_01_3    =  m.sp2_01,
    sp2pdv_01_3 =  m.sp2pdv_01,
    billkt_01_3 =  m.dem_01,
    billktpdv_01_3 = m.dempdv_01
 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 3
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 update rep_nds2011_tbl set
    deb_e_01_4  =  m.deb_e_01,
    dpdv_e_01_4 =  m.dpdv_e_01,
    kr_e_01_4   =  m.kr_e_01,
    kpdv_e_01_4 =  m.kpdv_e_01,
    kvt_01_4    =  m.kvt_01,
    dem_01_4    =  m.dem_01,
    dempdv_01_4 =  m.dempdv_01,
    opl_01_4    =  m.opl_01,
    oplpdv_01_4 =  m.oplpdv_01,
    sp1_01_4    =  m.sp1_01,
    sp1pdv_01_4 =  m.sp1pdv_01 ,
    sp2_01_4    =  m.sp2_01,
    sp2pdv_01_4 =  m.sp2pdv_01,
    billkt_01_4 =  m.dem_01,
    billktpdv_01_4 = m.dempdv_01
 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 4
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;
 --------------------------------------------------------------------------------------------

 update rep_nds2011_tbl set

	deb_b_11_1  = coalesce(deb_b_11_1,0) - coalesce(deb_b_01_1,0),
	dpdv_b_11_1 = coalesce(dpdv_b_11_1,0) - coalesce(dpdv_b_01_1,0),
	kr_b_11_1   = coalesce(kr_b_11_1,0) - coalesce(kr_b_01_1,0),
	kpdv_b_11_1 = coalesce(kpdv_b_11_1,0) - coalesce(kpdv_b_01_1,0), 
--	deb_e_11_1  = coalesce(deb_e_11_1,0) - (coalesce(deb_b_01_1,0) - coalesce(opl_01_1,0) - coalesce(sp1_01_1,0)- coalesce(sp2_01_1,0)), 
--	dpdv_e_11_1 = coalesce(dpdv_e_11_1,0) - (coalesce(dpdv_b_01_1,0) - coalesce(oplpdv_01_1,0) - coalesce(sp1pdv_01_1,0)- coalesce(sp2pdv_01_1,0)), 
--	kr_e_11_1   = coalesce(kr_e_11_1,0) - (coalesce(kr_b_01_1,0) - coalesce(billkt_01_1,0)), 
--	kpdv_e_11_1 = coalesce(kpdv_e_11_1,0) - (coalesce(kpdv_b_01_1,0) - coalesce(billktpdv_01_1,0)), 
	deb_e_11_1  = coalesce(deb_e_11_1,0)  - coalesce(deb_e_01_1,0) , 
	dpdv_e_11_1 = coalesce(dpdv_e_11_1,0) - coalesce(dpdv_e_01_1,0), 
	kr_e_11_1   = coalesce(kr_e_11_1,0)   - coalesce(kr_e_01_1,0), 
	kpdv_e_11_1 = coalesce(kpdv_e_11_1,0) - coalesce(kpdv_e_01_1,0), 

	kvt_11_1    = coalesce(kvt_11_1,0) - coalesce(kvt_01_1,0), 
	dem_11_1    = coalesce(dem_11_1,0) - coalesce(dem_01_1,0), 
	dempdv_11_1 = coalesce(dempdv_11_1,0) - coalesce(dempdv_01_1,0), 
	opl_11_1    = coalesce(opl_11_1,0) - coalesce(opl_01_1,0), 
	oplpdv_11_1 = coalesce(oplpdv_11_1,0) - coalesce(oplpdv_01_1,0), 
	sp1_11_1    = coalesce(sp1_11_1,0) - coalesce(sp1_01_1,0), 
	sp1pdv_11_1 = coalesce(sp1pdv_11_1,0) - coalesce(sp1pdv_01_1,0), 
	sp2_11_1    = coalesce(sp2_11_1,0) - coalesce(sp2_01_1,0), 
	sp2pdv_11_1 = coalesce(sp2pdv_11_1,0) - coalesce(sp2pdv_01_1,0), 
	billkt_11_1 = coalesce(billkt_11_1,0) - coalesce(billkt_01_1,0), 
	billktpdv_11_1 = coalesce(billktpdv_11_1,0) - coalesce(billktpdv_01_1,0),

	deb_b_11_2  = coalesce(deb_b_11_2,0) - coalesce(deb_b_01_2,0),
	dpdv_b_11_2 = coalesce(dpdv_b_11_2,0) - coalesce(dpdv_b_01_2,0),
	kr_b_11_2   = coalesce(kr_b_11_2,0) - coalesce(kr_b_01_2,0),
	kpdv_b_11_2 = coalesce(kpdv_b_11_2,0) - coalesce(kpdv_b_01_2,0), 
	deb_e_11_2  = coalesce(deb_e_11_2,0) - coalesce(deb_e_01_2,0), 
	dpdv_e_11_2 = coalesce(dpdv_e_11_2,0) - coalesce(dpdv_e_01_2,0), 
	kr_e_11_2   = coalesce(kr_e_11_2,0) - coalesce(kr_e_01_2,0), 
	kpdv_e_11_2 = coalesce(kpdv_e_11_2,0) - coalesce(kpdv_e_01_2,0), 
	kvt_11_2    = coalesce(kvt_11_2,0) - coalesce(kvt_01_2,0), 
	dem_11_2    = coalesce(dem_11_2,0) - coalesce(dem_01_2,0), 
	dempdv_11_2 = coalesce(dempdv_11_2,0) - coalesce(dempdv_01_2,0), 
	opl_11_2    = coalesce(opl_11_2,0) - coalesce(opl_01_2,0), 
	oplpdv_11_2 = coalesce(oplpdv_11_2,0) - coalesce(oplpdv_01_2,0), 
	sp1_11_2    = coalesce(sp1_11_2,0) - coalesce(sp1_01_2,0), 
	sp1pdv_11_2 = coalesce(sp1pdv_11_2,0) - coalesce(sp1pdv_01_2,0), 
	sp2_11_2    = coalesce(sp2_11_2,0) - coalesce(sp2_01_2,0), 
	sp2pdv_11_2 = coalesce(sp2pdv_11_2,0) - coalesce(sp2pdv_01_2,0), 
	billkt_11_2 = coalesce(billkt_11_2,0) - coalesce(billkt_01_2,0), 
	billktpdv_11_2 = coalesce(billktpdv_11_2,0)- coalesce(billktpdv_01_2,0),

	deb_b_11_3  = coalesce(deb_b_11_3,0) - coalesce(deb_b_01_3,0),
	dpdv_b_11_3 = coalesce(dpdv_b_11_3,0) - coalesce(dpdv_b_01_3,0),
	kr_b_11_3   = coalesce(kr_b_11_3,0) - coalesce(kr_b_01_3,0),
	kpdv_b_11_3 = coalesce(kpdv_b_11_3,0) - coalesce(kpdv_b_01_3,0), 
	deb_e_11_3  = coalesce(deb_e_11_3,0) - coalesce(deb_e_01_3,0), 
	dpdv_e_11_3 = coalesce(dpdv_e_11_3,0) - coalesce(dpdv_e_01_3,0), 
	kr_e_11_3   = coalesce(kr_e_11_3,0) - coalesce(kr_e_01_3,0), 
	kpdv_e_11_3 = coalesce(kpdv_e_11_3,0) - coalesce(kpdv_e_01_3,0), 
	kvt_11_3    = coalesce(kvt_11_3,0) - coalesce(kvt_01_3,0), 
	dem_11_3    = coalesce(dem_11_3,0) - coalesce(dem_01_3,0), 
	dempdv_11_3 = coalesce(dempdv_11_3,0) - coalesce(dempdv_01_3,0), 
	opl_11_3    = coalesce(opl_11_3,0) - coalesce(opl_01_3,0), 
	oplpdv_11_3 = coalesce(oplpdv_11_3,0) - coalesce(oplpdv_01_3,0), 
	sp1_11_3    = coalesce(sp1_11_3,0) - coalesce(sp1_01_3,0), 
	sp1pdv_11_3 = coalesce(sp1pdv_11_3,0) - coalesce(sp1pdv_01_3,0), 
	sp2_11_3    = coalesce(sp2_11_3,0) - coalesce(sp2_01_3,0), 
	sp2pdv_11_3 = coalesce(sp2pdv_11_3,0) - coalesce(sp2pdv_01_3,0), 
	billkt_11_3 = coalesce(billkt_11_3,0) - coalesce(billkt_01_3,0), 
	billktpdv_11_3 = coalesce(billktpdv_11_3,0)- coalesce(billktpdv_01_3,0),

	deb_b_11_4  = coalesce(deb_b_11_4,0) - coalesce(deb_b_01_4,0),
	dpdv_b_11_4 = coalesce(dpdv_b_11_4,0) - coalesce(dpdv_b_01_4,0),
	kr_b_11_4   = coalesce(kr_b_11_4,0) - coalesce(kr_b_01_4,0),
	kpdv_b_11_4 = coalesce(kpdv_b_11_4,0) - coalesce(kpdv_b_01_4,0), 
	deb_e_11_4  = coalesce(deb_e_11_4,0) - coalesce(deb_e_01_4,0), 
	dpdv_e_11_4 = coalesce(dpdv_e_11_4,0) - coalesce(dpdv_e_01_4,0), 
	kr_e_11_4   = coalesce(kr_e_11_4,0) - coalesce(kr_e_01_4,0), 
	kpdv_e_11_4 = coalesce(kpdv_e_11_4,0) - coalesce(kpdv_e_01_4,0), 
	kvt_11_4    = coalesce(kvt_11_4,0) - coalesce(kvt_01_4,0), 
	dem_11_4    = coalesce(dem_11_4,0) - coalesce(dem_01_4,0), 
	dempdv_11_4 = coalesce(dempdv_11_4,0) - coalesce(dempdv_01_4,0), 
	opl_11_4    = coalesce(opl_11_4,0) - coalesce(opl_01_4,0), 
	oplpdv_11_4 = coalesce(oplpdv_11_4,0) - coalesce(oplpdv_01_4,0), 
	sp1_11_4    = coalesce(sp1_11_4,0) - coalesce(sp1_01_4,0), 
	sp1pdv_11_4 = coalesce(sp1pdv_11_4,0) - coalesce(sp1pdv_01_4,0), 
	sp2_11_4    = coalesce(sp2_11_4,0) - coalesce(sp2_01_4,0), 
	sp2pdv_11_4 = coalesce(sp2pdv_11_4,0) - coalesce(sp2pdv_01_4,0), 
	billkt_11_4 = coalesce(billkt_11_4,0) - coalesce(billkt_01_4,0), 
	billktpdv_11_4 = coalesce(billktpdv_11_4,0)- coalesce(billktpdv_01_4,0),

        depozit1_11 = coalesce(depozit1_11,0) - coalesce(depozit1_01,0),
        depozit1pdv_11 = coalesce(depozit1pdv_11,0) - coalesce(depozit1pdv_01,0), 
        depozit2_11 = coalesce(depozit2_11,0) - coalesce(depozit2_01,0), 
        depozit2pdv_11 = coalesce(depozit2pdv_11,0) - coalesce(depozit2pdv_01,0), 

	deb_b_11_5  = coalesce(deb_b_11_5,0) - coalesce(deb_b_01_5,0),
	dpdv_b_11_5 = coalesce(dpdv_b_11_5,0) - coalesce(dpdv_b_01_5,0),
	kr_b_11_5   = coalesce(kr_b_11_5,0) - coalesce(kr_b_01_5,0),
	kpdv_b_11_5 = coalesce(kpdv_b_11_5,0) - coalesce(kpdv_b_01_5,0), 
--	deb_e_11_5  = coalesce(deb_e_11_5,0) - (coalesce(deb_b_01_5,0) - coalesce(opl_01_5,0) - coalesce(sp1_01_5,0)- coalesce(sp2_01_5,0)), 
--	dpdv_e_11_5 = coalesce(dpdv_e_11_5,0) - (coalesce(dpdv_b_01_5,0) - coalesce(oplpdv_01_5,0) - coalesce(sp1pdv_01_5,0)- coalesce(sp2pdv_01_5,0)), 
--	kr_e_11_5   = coalesce(kr_e_11_5,0) - (coalesce(kr_b_01_5,0) - coalesce(billkt_01_5,0)), 
--	kpdv_e_11_5 = coalesce(kpdv_e_11_5,0) - (coalesce(kpdv_b_01_5,0) - coalesce(billktpdv_01_5,0)), 

	deb_e_11_5  = coalesce(deb_e_11_5,0)  - coalesce(deb_e_01_5,0), 
	dpdv_e_11_5 = coalesce(dpdv_e_11_5,0) - coalesce(dpdv_e_01_5,0), 
	kr_e_11_5   = coalesce(kr_e_11_5,0)   - coalesce(kr_e_01_5,0), 
	kpdv_e_11_5 = coalesce(kpdv_e_11_5,0) - coalesce(kpdv_e_01_5,0), 

	kvt_11_5    = coalesce(kvt_11_5,0) - coalesce(kvt_01_5,0), 
	dem_11_5    = coalesce(dem_11_5,0) - coalesce(dem_01_5,0), 
	dempdv_11_5 = coalesce(dempdv_11_5,0) - coalesce(dempdv_01_5,0), 
	opl_11_5    = coalesce(opl_11_5,0) - coalesce(opl_01_5,0), 
	oplpdv_11_5 = coalesce(oplpdv_11_5,0) - coalesce(oplpdv_01_5,0), 
	sp1_11_5    = coalesce(sp1_11_5,0) - coalesce(sp1_01_5,0), 
	sp1pdv_11_5 = coalesce(sp1pdv_11_5,0) - coalesce(sp1pdv_01_5,0), 
	sp2_11_5    = coalesce(sp2_11_5,0) - coalesce(sp2_01_5,0), 
	sp2pdv_11_5 = coalesce(sp2pdv_11_5,0) - coalesce(sp2pdv_01_5,0), 
	billkt_11_5 = coalesce(billkt_11_5,0) - coalesce(billkt_01_5,0), 
	billktpdv_11_5 = coalesce(billktpdv_11_5,0)- coalesce(billktpdv_01_5,0)
   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


---------------------------------------------------------------------------
update rep_nds2011_tbl set 
deb_b_00_1=s00_1.deb_b_00_1,dpdv_b_00_1=s00_1.dpdv_b_00_1, deb_e_00_1=s00_1.deb_e_00_1, dpdv_e_00_1=s00_1.dpdv_e_00_1, 
opl_00_1=s00_1.opl_00_1, oplpdv_00_1=s00_1.oplpdv_00_1, 
sp1_00_1=s00_1.sp1_00_1, sp1pdv_00_1=s00_1.sp1pdv_00_1, sp2_00_1=s00_1.sp2_00_1, sp2pdv_00_1=s00_1.sp2pdv_00_1, 

deb_b_00_2=s00_2.deb_b_00_2,dpdv_b_00_2=s00_2.dpdv_b_00_2, deb_e_00_2=s00_2.deb_e_00_2, dpdv_e_00_2=s00_2.dpdv_e_00_2, 
opl_00_2=s00_2.opl_00_2, oplpdv_00_2=s00_2.oplpdv_00_2, 
sp1_00_2=s00_2.sp1_00_2, sp1pdv_00_2=s00_2.sp1pdv_00_2, sp2_00_2=s00_2.sp2_00_2, sp2pdv_00_2=s00_2.sp2pdv_00_2, 

deb_b_00_3=s00_3.deb_b_00_3,dpdv_b_00_3=s00_3.dpdv_b_00_3, deb_e_00_3=s00_3.deb_e_00_3, dpdv_e_00_3=s00_3.dpdv_e_00_3, 
opl_00_3=s00_3.opl_00_3, oplpdv_00_3=s00_3.oplpdv_00_3, 
sp1_00_3=s00_3.sp1_00_3, sp1pdv_00_3=s00_3.sp1pdv_00_3, sp2_00_3=s00_3.sp2_00_3, sp2pdv_00_3=s00_3.sp2pdv_00_3, 

deb_b_00_4=s00_4.deb_b_00_4,dpdv_b_00_4=s00_4.dpdv_b_00_4, deb_e_00_4=s00_4.deb_e_00_4, dpdv_e_00_4=s00_4.dpdv_e_00_4, 
opl_00_4=s00_4.opl_00_4, oplpdv_00_4=s00_4.oplpdv_00_4, 
sp1_00_4=s00_4.sp1_00_4, sp1pdv_00_4=s00_4.sp1pdv_00_4, sp2_00_4=s00_4.sp2_00_4, sp2pdv_00_4=s00_4.sp2pdv_00_4, 

depozit1_00=s00_4.depozit1_00, depozit1pdv_00=s00_4.depozit1pdv_00, depozit2_00=s00_4.depozit2_00, depozit2pdv_00=s00_4.depozit2pdv_00, 

deb_b_00_5=s00_5.deb_b_00_5,dpdv_b_00_5=s00_5.dpdv_b_00_5, deb_e_00_5=s00_5.deb_e_00_5, dpdv_e_00_5=s00_5.dpdv_e_00_5, 
opl_00_5=s00_5.opl_00_5, oplpdv_00_5=s00_5.oplpdv_00_5, 
sp1_00_5=s00_5.sp1_00_5, sp1pdv_00_5=s00_5.sp1pdv_00_5, sp2_00_5=s00_5.sp2_00_5, sp2pdv_00_5=s00_5.sp2pdv_00_5 

from (select ppref as key, 
  -sum(deb_pm00v) as deb_b_00_1,-sum(deb_pm00pdv) as dpdv_b_00_1, 
  -sum(deb_km00v) as deb_e_00_1, -sum(deb_km00pdv) as dpdv_e_00_1, 
  sum(p.pay) as opl_00_1,sum(p.pay_tax) as oplpdv_00_1, 
  sum(p.writeoff)as sp1_00_1, sum(p.writeoff_tax)as sp1pdv_00_1,sum(p.trush)as sp2_00_1, sum(p.trush_tax)as sp2pdv_00_1 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2000 and p.id_pref = ppref and p.mmgg = period) 
  join clm_statecl_h as cp on (cp.id_client=s.id_client)
  where period =  date_trunc(''month'', pmmgg) and s.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  ) as s00_1 
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
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


update rep_nds2011_tbl set 
deb_b_99_1=s99_1.deb_b_99_1, deb_e_99_1=s99_1.deb_e_99_1, opl_99_1=s99_1.opl_99_1, sp1_99_1=s99_1.sp1_99_1, sp2_99_1=s99_1.sp2_99_1, 
deb_b_99_2=s99_2.deb_b_99_2, deb_e_99_2=s99_2.deb_e_99_2, opl_99_2=s99_2.opl_99_2, sp1_99_2=s99_2.sp1_99_2, sp2_99_2=s99_2.sp2_99_2, 
deb_b_99_3=s99_3.deb_b_99_3, deb_e_99_3=s99_3.deb_e_99_3, opl_99_3=s99_3.opl_99_3, sp1_99_3=s99_3.sp1_99_3, sp2_99_3=s99_3.sp2_99_3, 
deb_b_99_4=s99_4.deb_b_99_4, deb_e_99_4=s99_4.deb_e_99_4, opl_99_4=s99_4.opl_99_4, sp1_99_4=s99_4.sp1_99_4, sp2_99_4=s99_4.sp2_99_4, depozit1_99=s99_4.depozit1_99, depozit2_99=s99_4.depozit2_99, 
deb_b_99_5=s99_5.deb_b_99_5, deb_e_99_5=s99_5.deb_e_99_5, opl_99_5=s99_5.opl_99_5, sp1_99_5=s99_5.sp1_99_5, sp2_99_5=s99_5.sp2_99_5

 from (select ppref as key, 
  -sum(deb_pm99v) as deb_b_99_1,-sum(deb_km99v) as deb_e_99_1, 
  sum(p.pay) as opl_99_1,  sum(p.writeoff)as sp1_99_1, sum(p.trush)as sp2_99_1 
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 1999 and p.id_pref = ppref and p.mmgg = period) 
  join clm_statecl_h as cp on (cp.id_client=s.id_client)
  where s.period =  date_trunc(''month'', pmmgg) and s.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
 ) as s99_1 
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
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


update rep_nds2011_tbl set 
deb_b_008_4=s008_4.deb_b_008_4, dpdv_b_008_4=s008_4.dpdv_b_008_4, deb_e_008_4=s008_4.deb_e_008_4, dpdv_e_008_4=s008_4.dpdv_e_008_4, 
opl_008_4=s008_4.opl_008_4, oplpdv_008_4=s008_4.oplpdv_008_4, sp1_008_4=s008_4.sp1_008_4, sp1pdv_008_4=s008_4.sp1pdv_008_4, sp2_008_4=s008_4.sp2_008_4, 
sp2pdv_008_4=s008_4.sp2pdv_008_4, depozit1_008=s008_4.depozit1_008, depozit1pdv_008=s008_4.depozit1pdv_008, 
depozit2_008=s008_4.depozit2_008,depozit2pdv_008=s008_4.depozit2pdv_008
  from (select ppref as key, 
  -sum(deb_pm01v) as deb_b_008_4,-sum(deb_pm01pdv) as dpdv_b_008_4, 
  -sum(deb_km01v) as deb_e_008_4, -sum(deb_km01pdv) as dpdv_e_008_4, 
  sum(p.pay) as opl_008_4,sum(p.pay_tax) as oplpdv_008_4, 
  sum(p.writeoff)as sp1_008_4, sum(p.writeoff_tax)as sp1pdv_008_4,sum(p.trush)as sp2_008_4, sum(p.trush_tax)as sp2pdv_008_4, 
  sum(p.depozit1)as depozit1_008, sum(p.depozit1_tax) as depozit1pdv_008,
  sum(p.depozit2)as depozit2_008, sum(p.depozit2_tax) as depozit2pdv_008
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  where period =  date_trunc(''month'', pmmgg) and roz in (9,13) and s.id_pref = ppref and c.idk_work = 10 ) as s008_4 
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

RETURN 1;
end;'                                                                                           
LANGUAGE 'plpgsql';          
