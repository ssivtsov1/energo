;
set client_encoding = 'win';


create or replace function rep_nds2016_re_fun(date,int,bool) returns int
AS                                                                                              
$BODY$
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
  r1 record;
  r2 record;

BEGIN

 if pmmgg < '2016-03-01' then

  return 0;

 end if;

/*
 if pbuild then 

  perform seb_all(0, date_trunc('month', pmmgg)::date );

 end if;

*/

-------------------------------------------------------------------------

 select trim(value_ident) into vkodres from syi_sysvars_tbl where ident='kod_res'; 

 if ( select flock from rep_nds2011_tbl where mmgg = pmmgg and id_pref = ppref) = 1 then
  raise notice 'closed month!';
  return -1;
 end if;


-- perform rep_mmggpay_2016_fun(ppref, pmmgg);
-- perform rep_mmggbill_2016_fun(ppref, pmmgg);
-- perform rep_nds2016_abon_fun(pmmgg, ppref, true);

 perform rep_periods_saldo_re_fun(pmmgg, ppref, null);


 delete from rep_nds2011_tbl where mmgg = pmmgg and id_pref = ppref and flock = 0;

 -- 2016

insert into rep_nds2011_tbl ( mmgg, id_pref, deb_b_16_1, dpdv_b_16_1, kr_b_16_1, kpdv_b_16_1, 
            deb_e_16_1, dpdv_e_16_1, kr_e_16_1, kpdv_e_16_1, kvt_16_1, dem_16_1, 
            dempdv_16_1, opl_16_1, oplpdv_16_1, sp1_16_1, sp1pdv_16_1, sp2_16_1, 
            sp2pdv_16_1, billkt_16_1, billktpdv_16_1,
--            deb_b_16_2, dpdv_b_16_2, 
--            kr_b_16_2, kpdv_b_16_2, deb_e_16_2, dpdv_e_16_2, kr_e_16_2, kpdv_e_16_2, 
--            kvt_16_2, dem_16_2, dempdv_16_2, opl_16_2, oplpdv_16_2, sp1_16_2, 
--            sp1pdv_16_2, sp2_16_2, sp2pdv_16_2, billkt_16_2, billktpdv_16_2, 
--            deb_b_16_3, dpdv_b_16_3, kr_b_16_3, kpdv_b_16_3, deb_e_16_3, 
--            dpdv_e_16_3, kr_e_16_3, kpdv_e_16_3, kvt_16_3, dem_16_3, dempdv_16_3, 
--            opl_16_3, oplpdv_16_3, sp1_16_3, sp1pdv_16_3, sp2_16_3, sp2pdv_16_3, 
--            billkt_16_3, billktpdv_16_3, deb_b_16_4, dpdv_b_16_4, kr_b_16_4, 
--            kpdv_b_16_4, deb_e_16_4, dpdv_e_16_4, kr_e_16_4, kpdv_e_16_4, 
--            kvt_16_4, dem_16_4, dempdv_16_4, opl_16_4, oplpdv_16_4, sp1_16_4, 
--            sp1pdv_16_4, sp2_16_4, sp2pdv_16_4, depozit1_16, depozit1pdv_16, 
--            depozit2_16, depozit2pdv_16, billkt_16_4, billktpdv_16_4, 
            deb_b_16_5, 
            dpdv_b_16_5, kr_b_16_5, kpdv_b_16_5, deb_e_16_5, dpdv_e_16_5, 
            kr_e_16_5, kpdv_e_16_5, kvt_16_5, dem_16_5, dempdv_16_5, opl_16_5, 
            oplpdv_16_5, sp1_16_5, sp1pdv_16_5, sp2_16_5, sp2pdv_16_5, billkt_16_5, 
            billktpdv_16_5)
select pmmgg, * from  

  (select ppref as key, 
  -sum(coalesce(deb_zpmv,0)) as deb_b_01_1,-sum(-coalesce(deb_zpmpdv,0)) as dpdv_b_01_1, 
  sum(kr_zpmv) as kr_b_01_1, sum(kr_zpmpdv) as kpdv_b_01_1, 

  -sum(deb_kmv) as deb_e_01_1, 
  -sum(deb_kmpdv) as dpdv_e_01_1, 
  sum(kr_zkmv) as kr_e_01_1, sum(kr_zkmpdv) as kpdv_e_01_1, 

  sum(nar) as kvt_01_1,sum(nar_v) as dem_01_1,sum(nar_pdv) as dempdv_01_1, 
  sum(opl_zv) as opl_01_1,sum(opl_zpdv) as oplpdv_01_1, 

  --sum(p.writeoff) as sp1_01_1, sum(p.writeoff_tax) as sp1pdv_01_1,sum(p.trush) as sp2_01_1, sum(p.trush_tax) as sp2pdv_01_1, 
  0 as sp1_01_1, 0 as sp1pdv_01_1, 0 as sp2_01_1, 0 as sp2pdv_01_1, 

--  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as BILLKT_01_1, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_01_1 

  sum(coalesce(p.dtval_kt+p.dtval_kt_tax,0)) as BILLKT_01_1, sum(coalesce(p.dtval_kt_tax,0)) as billktpdv_01_1 

  from seb_obr_all_tmp as s 
--  left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2016 and p.id_pref = ppref and p.mmgg = period) 
  left join rep_periods_saldo_tmp as p on (p.id_client = s.id_client and p.hperiod = 2016 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
--  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2016 )  
  where period =  date_trunc('month', pmmgg) 
  --and roz in (101,102,103,104) 
  and roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_1 

---------------------------------------------------------------
  join (select ppref as key, 
  -sum(coalesce(deb_zpmv,0)) as deb_b_01_5,-sum(coalesce(deb_zpmpdv,0)) as dpdv_b_01_5, 
  sum(kr_zpmv) as kr_b_01_5, sum(kr_zpmpdv) as kpdv_b_01_5, 
--  -sum(coalesce(deb_km16v,0)) as deb_e_01_5, -sum(coalesce(deb_km16pdv,0)) as dpdv_e_01_5, 
  -sum(deb_kmv) as deb_e_01_5,  -sum(deb_kmpdv) as dpdv_e_01_5, 
  sum(kr_zkmv) as kr_e_01_5, sum(kr_zkmpdv) as kpdv_e_01_5, 
  sum(nar) as kvt_01_5,sum(nar_v) as dem_01_5,sum(nar_pdv) as dempdv_01_5, 
  sum(opl_zv) as opl_01_5,sum(opl_zpdv) as oplpdv_01_5, 
--  sum(p.writeoff)as sp1_01_5, sum(p.writeoff_tax)as sp1pdv_01_5,sum(p.trush)as sp2_01_5, sum(p.trush_tax)as sp2pdv_01_5, 
  0 as sp1_01_5, 0 as sp1pdv_01_5, 0 as sp2_01_5, 0 as sp2pdv_01_5, 
  sum(coalesce(p.dtval_kt+p.dtval_kt_tax,0)) as BILLKT_01_5, sum(coalesce(p.dtval_kt_tax,0)) as billktpdv_01_5 
--  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as billkt_01_5, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_01_5 
  from seb_obr_all_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  left join rep_periods_saldo_tmp as p on (p.id_client = s.id_client and p.hperiod = 2016 and p.id_pref = ppref and p.mmgg = period) 
--  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2016 )  
  where period =  date_trunc('month', pmmgg) 
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_5 using (key);

------------------
--return 0;
------------------


  --перенос начальных остатков

  select into r_old * from rep_nds2011_tbl where id_pref = ppref and mmgg = pmmgg - '1 month'::interval;

  update rep_nds2011_tbl set 
   deb_b_00_1= coalesce(r_old.deb_e_00_1,0),
   deb_b_00_2= coalesce(r_old.deb_e_00_2,0) ,
   deb_b_00_3= coalesce(r_old.deb_e_00_3,0) ,
   deb_b_00_4= coalesce(r_old.deb_e_00_4,0) ,
   deb_b_00_5= coalesce(r_old.deb_e_00_5,0) ,

   dpdv_b_00_1= coalesce(r_old.dpdv_e_00_1,0) ,
   dpdv_b_00_2= coalesce(r_old.dpdv_e_00_2,0) ,
   dpdv_b_00_3= coalesce(r_old.dpdv_e_00_3,0) ,
   dpdv_b_00_4= coalesce(r_old.dpdv_e_00_4,0) ,
   dpdv_b_00_5= coalesce(r_old.dpdv_e_00_5,0),

   deb_b_99_1= coalesce(r_old.deb_e_99_1,0),
   deb_b_99_2= coalesce(r_old.deb_e_99_2,0) ,
   deb_b_99_3= coalesce(r_old.deb_e_99_3,0) ,
   deb_b_99_4= coalesce(r_old.deb_e_99_4,0) ,
   deb_b_99_5= coalesce(r_old.deb_e_99_5,0) ,

   deb_b_008_4 = coalesce(r_old.deb_e_008_4,0) ,
   dpdv_b_008_4 = coalesce(r_old.dpdv_e_008_4,0) ,

   deb_b_008_5 = coalesce(r_old.deb_e_008_5,0) ,
   dpdv_b_008_5 = coalesce(r_old.dpdv_e_008_5,0) 

  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;



  update rep_nds2011_tbl set 
   deb_b_01_1= coalesce(r_old.deb_e_01_1,0),
   deb_b_01_2= coalesce(r_old.deb_e_01_2,0) ,
   deb_b_01_3= coalesce(r_old.deb_e_01_3,0) ,
   deb_b_01_4= coalesce(r_old.deb_e_01_4,0) ,
   deb_b_01_5= coalesce(r_old.deb_e_01_5,0) ,

   dpdv_b_01_1= coalesce(r_old.dpdv_e_01_1,0) ,
   dpdv_b_01_2= coalesce(r_old.dpdv_e_01_2,0) ,
   dpdv_b_01_3= coalesce(r_old.dpdv_e_01_3,0) ,
   dpdv_b_01_4= coalesce(r_old.dpdv_e_01_4,0) ,
   dpdv_b_01_5= coalesce(r_old.dpdv_e_01_5,0),

   kr_b_01_1= coalesce(r_old.kr_e_01_1,0),
   kr_b_01_2= coalesce(r_old.kr_e_01_2,0) ,
   kr_b_01_3= coalesce(r_old.kr_e_01_3,0) ,
   kr_b_01_4= coalesce(r_old.kr_e_01_4,0) ,
   kr_b_01_5= coalesce(r_old.kr_e_01_5,0) ,

   kpdv_b_01_1= coalesce(r_old.kpdv_e_01_1,0) ,
   kpdv_b_01_2= coalesce(r_old.kpdv_e_01_2,0) ,
   kpdv_b_01_3= coalesce(r_old.kpdv_e_01_3,0) ,
   kpdv_b_01_4= coalesce(r_old.kpdv_e_01_4,0) ,
   kpdv_b_01_5= coalesce(r_old.kpdv_e_01_5,0) 
  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


  update rep_nds2011_tbl set 
   deb_b_11_1= coalesce(r_old.deb_e_11_1,0),
   deb_b_11_2= coalesce(r_old.deb_e_11_2,0) ,
   deb_b_11_3= coalesce(r_old.deb_e_11_3,0) ,
   deb_b_11_4= coalesce(r_old.deb_e_11_4,0) ,
   deb_b_11_5= coalesce(r_old.deb_e_11_5,0) ,

   dpdv_b_11_1= coalesce(r_old.dpdv_e_11_1,0) ,
   dpdv_b_11_2= coalesce(r_old.dpdv_e_11_2,0) ,
   dpdv_b_11_3= coalesce(r_old.dpdv_e_11_3,0) ,
   dpdv_b_11_4= coalesce(r_old.dpdv_e_11_4,0) ,
   dpdv_b_11_5= coalesce(r_old.dpdv_e_11_5,0),

   kr_b_11_1= coalesce(r_old.kr_e_11_1,0),
   kr_b_11_2= coalesce(r_old.kr_e_11_2,0) ,
   kr_b_11_3= coalesce(r_old.kr_e_11_3,0) ,
   kr_b_11_4= coalesce(r_old.kr_e_11_4,0) ,
   kr_b_11_5= coalesce(r_old.kr_e_11_5,0) ,

   kpdv_b_11_1= coalesce(r_old.kpdv_e_11_1,0) ,
   kpdv_b_11_2= coalesce(r_old.kpdv_e_11_2,0) ,
   kpdv_b_11_3= coalesce(r_old.kpdv_e_11_3,0) ,
   kpdv_b_11_4= coalesce(r_old.kpdv_e_11_4,0) ,
   kpdv_b_11_5= coalesce(r_old.kpdv_e_11_5,0) 

  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

  update rep_nds2011_tbl set 
   deb_b_16_1= coalesce(r_old.deb_e_16_1,0),
   deb_b_16_2= coalesce(r_old.deb_e_16_2,0) ,
   deb_b_16_3= coalesce(r_old.deb_e_16_3,0) ,
   deb_b_16_4= coalesce(r_old.deb_e_16_4,0) ,
   deb_b_16_5= coalesce(r_old.deb_e_16_5,0) ,

   dpdv_b_16_1= coalesce(r_old.dpdv_e_16_1,0) ,
   dpdv_b_16_2= coalesce(r_old.dpdv_e_16_2,0) ,
   dpdv_b_16_3= coalesce(r_old.dpdv_e_16_3,0) ,
   dpdv_b_16_4= coalesce(r_old.dpdv_e_16_4,0) ,
   dpdv_b_16_5= coalesce(r_old.dpdv_e_16_5,0),

   kr_b_16_1= coalesce(r_old.kr_e_16_1,0),
   kr_b_16_2= coalesce(r_old.kr_e_16_2,0) ,
   kr_b_16_3= coalesce(r_old.kr_e_16_3,0) ,
   kr_b_16_4= coalesce(r_old.kr_e_16_4,0) ,
   kr_b_16_5= coalesce(r_old.kr_e_16_5,0) ,

   kpdv_b_16_1= coalesce(r_old.kpdv_e_16_1,0) ,
   kpdv_b_16_2= coalesce(r_old.kpdv_e_16_2,0) ,
   kpdv_b_16_3= coalesce(r_old.kpdv_e_16_3,0) ,
   kpdv_b_16_4= coalesce(r_old.kpdv_e_16_4,0) ,
   kpdv_b_16_5= coalesce(r_old.kpdv_e_16_5,0) 

  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

-------------------------------------------------------------

 -- 2015-2011
update rep_nds2011_tbl set 

deb_e_11_1 = deb_b_11_1-  coalesce(  sss.sdeb_b_11_1 - sss.sdeb_e_11_1 ,0), 
dpdv_e_11_1=dpdv_b_11_1-  coalesce(  sss.sdpdv_b_11_1- sss.sdpdv_e_11_1,0), 

kr_e_11_1  =kr_b_11_1  -  coalesce(  sss.skr_b_11_1  - sss.skr_e_11_1,0), 
kpdv_e_11_1=kpdv_b_11_1-  coalesce(  sss.skpdv_b_11_1 - sss.skpdv_e_11_1,0), 

kvt_11_1=coalesce(sss.kvt_11_1,0), 
dem_11_1=coalesce(sss.dem_11_1,0),           
dempdv_11_1=coalesce(sss.dempdv_11_1,0), 
opl_11_1=coalesce(sss.opl_11_1,0), 
oplpdv_11_1=coalesce(sss.oplpdv_11_1,0), 
sp1_11_1=coalesce(sss.sp1_11_1,0), 
sp1pdv_11_1=coalesce(sss.sp1pdv_11_1,0), 
sp2_11_1=coalesce(sss.sp2_11_1,0),         
sp2pdv_11_1=coalesce(sss.sp2pdv_11_1,0),  
billkt_11_1=coalesce(sss.billkt_11_1,0),  
billktpdv_11_1=coalesce(sss.billktpdv_11_1,0),  


deb_e_11_5 = deb_b_11_5- coalesce(   sss.sdeb_b_11_5 - sss.sdeb_e_11_5,0), 
dpdv_e_11_5=dpdv_b_11_5- coalesce(   sss.sdpdv_b_11_5- sss.sdpdv_e_11_5,0), 

kr_e_11_5  =kr_b_11_5  - coalesce(   sss.skr_b_11_5  - sss.skr_e_11_5,0), 
kpdv_e_11_5=kpdv_b_11_5- coalesce(   sss.skpdv_b_11_5 - sss.skpdv_e_11_5,0), 

kvt_11_5=coalesce(sss.kvt_11_5,0), 
dem_11_5=coalesce(sss.dem_11_5,0), 
dempdv_11_5=coalesce(sss.dempdv_11_5,0), 
opl_11_5=coalesce(sss.opl_11_5,0), 
            
oplpdv_11_5=coalesce(sss.oplpdv_11_5,0), 
sp1_11_5=coalesce(sss.sp1_11_5,0), 
sp1pdv_11_5=coalesce(sss.sp1pdv_11_5,0), 
sp2_11_5=coalesce(sss.sp2_11_5,0), 
sp2pdv_11_5=coalesce(sss.sp2pdv_11_5,0), 
billkt_11_5=coalesce(sss.billkt_11_5,0), 
billktpdv_11_5=coalesce(sss.billktpdv_11_5,0) 

from (select * from  
  (select ppref as key, 

  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_11_1, 
  sum(s.b_dtval_tax) as sdpdv_b_11_1, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_11_1,
  sum(s.b_ktval_tax) as skpdv_b_11_1, 
  0 as kvt_11_1, 
  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_11_1, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_11_1,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_11_1, sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_11_1, 
  0 as sp1_11_1, 0 as sp1pdv_11_1,0 as sp2_11_1, 0 as sp2pdv_11_1, 
  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_11_1, sum(s.dtval_kt_tax) as billktpdv_11_1,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_11_1, 
  sum(s.e_dtval_tax) as sdpdv_e_11_1, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_11_1,
  sum(s.e_ktval_tax) as skpdv_e_11_1 
  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
--  left join rep_nds_oldkt_tbl as old_kt on (old_kt.id_client = s.id_client and old_kt.id_pref = ppref and old_kt.mmgg = pmmgg)
--  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2011 )  
--  left join rep_nds_bill_tbl as bb  on (bb.id_client= s.id_client and bb.id_section=2011 )  
  where s.mmgg =  pmmgg and s.hperiod = 2015
  and ss.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_1     
  join (select ppref as key, 


  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_11_5, 
  sum(s.b_dtval_tax) as sdpdv_b_11_5, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_11_5,
  sum(s.b_ktval_tax) as skpdv_b_11_5, 
  0 as kvt_11_5, 
  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_11_5, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_11_5,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_11_5, sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_11_5, 
  0 as sp1_11_5, 0 as sp1pdv_11_5,0 as sp2_11_5, 0 as sp2pdv_11_5, 
  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_11_5, sum(s.dtval_kt_tax) as billktpdv_11_5,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_11_5, 
  sum(s.e_dtval_tax) as sdpdv_e_11_5, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_11_5,
  sum(s.e_ktval_tax) as skpdv_e_11_5 


  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)

  where s.mmgg =  pmmgg and s.hperiod = 2015
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and ss.roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_5 using (key)
) as sss
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


-- те строки, по которым не было движения
update rep_nds2011_tbl set 

deb_e_11_1 = deb_b_11_1, 
dpdv_e_11_1=dpdv_b_11_1, 

kr_e_11_1  =kr_b_11_1 , 
kpdv_e_11_1=kpdv_b_11_1 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
and dem_11_1 = 0 and dempdv_11_1 = 0 and opl_11_1 = 0 and oplpdv_11_1=0 and sp1_11_1 =0 and sp1pdv_11_1 = 0
and sp2_11_1 = 0 and sp2pdv_11_1 = 0;


update rep_nds2011_tbl set 

deb_e_11_5 = deb_b_11_5, 
dpdv_e_11_5=dpdv_b_11_5, 

kr_e_11_5  =kr_b_11_5 , 
kpdv_e_11_5=kpdv_b_11_5 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
and dem_11_5 = 0 and dempdv_11_5 = 0 and opl_11_5 = 0 and oplpdv_11_5=0 and sp1_11_5 =0 and sp1pdv_11_5 = 0
and sp2_11_5 = 0 and sp2pdv_11_5 = 0;


--------------------------------------------------------------

 -- 2011-2001

update rep_nds2011_tbl set 

deb_e_01_1 = deb_b_01_1-  coalesce(  sss.sdeb_b_01_1 - sss.sdeb_e_01_1 ,0), 
dpdv_e_01_1=dpdv_b_01_1-  coalesce(  sss.sdpdv_b_01_1- sss.sdpdv_e_01_1,0), 

kr_e_01_1  =kr_b_01_1  -  coalesce(  sss.skr_b_01_1  - sss.skr_e_01_1,0), 
kpdv_e_01_1=kpdv_b_01_1-  coalesce(  sss.skpdv_b_01_1 - sss.skpdv_e_01_1,0), 

kvt_01_1=coalesce(sss.kvt_01_1,0), 
dem_01_1=coalesce(sss.dem_01_1,0),           
dempdv_01_1=coalesce(sss.dempdv_01_1,0), 
opl_01_1=coalesce(sss.opl_01_1,0), 
oplpdv_01_1=coalesce(sss.oplpdv_01_1,0), 
sp1_01_1=coalesce(sss.sp1_01_1,0), 
sp1pdv_01_1=coalesce(sss.sp1pdv_01_1,0), 
sp2_01_1=coalesce(sss.sp2_01_1,0),         
sp2pdv_01_1=coalesce(sss.sp2pdv_01_1,0),  
billkt_01_1=coalesce(sss.billkt_01_1,0),  
billktpdv_01_1=coalesce(sss.billktpdv_01_1,0),  


deb_e_01_5 = deb_b_01_5- coalesce(   sss.sdeb_b_01_5 - sss.sdeb_e_01_5,0), 
dpdv_e_01_5=dpdv_b_01_5- coalesce(   sss.sdpdv_b_01_5- sss.sdpdv_e_01_5,0), 

kr_e_01_5  =kr_b_01_5  - coalesce(   sss.skr_b_01_5  - sss.skr_e_01_5,0), 
kpdv_e_01_5=kpdv_b_01_5- coalesce(   sss.skpdv_b_01_5 - sss.skpdv_e_01_5,0), 

kvt_01_5=coalesce(sss.kvt_01_5,0), 
dem_01_5=coalesce(sss.dem_01_5,0), 
dempdv_01_5=coalesce(sss.dempdv_01_5,0), 
opl_01_5=coalesce(sss.opl_01_5,0), 
            
oplpdv_01_5=coalesce(sss.oplpdv_01_5,0), 
sp1_01_5=coalesce(sss.sp1_01_5,0), 
sp1pdv_01_5=coalesce(sss.sp1pdv_01_5,0), 
sp2_01_5=coalesce(sss.sp2_01_5,0), 
sp2pdv_01_5=coalesce(sss.sp2pdv_01_5,0), 
billkt_01_5=coalesce(sss.billkt_01_5,0), 
billktpdv_01_5=coalesce(sss.billktpdv_01_5,0) 

from (select * from  
  (select ppref as key, 

  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_1, 
  sum(s.b_dtval_tax) as sdpdv_b_01_1, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_1,
  sum(s.b_ktval_tax) as skpdv_b_01_1, 
  0 as kvt_01_1, 
  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_1, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_1,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_1, sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_1, 
  0 as sp1_01_1, 0 as sp1pdv_01_1,0 as sp2_01_1, 0 as sp2pdv_01_1, 
  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_1, sum(s.dtval_kt_tax) as billktpdv_01_1,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_1, 
  sum(s.e_dtval_tax) as sdpdv_e_01_1, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_1,
  sum(s.e_ktval_tax) as skpdv_e_01_1 
  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
--  left join rep_nds_oldkt_tbl as old_kt on (old_kt.id_client = s.id_client and old_kt.id_pref = ppref and old_kt.mmgg = pmmgg)
--  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2011 )  
--  left join rep_nds_bill_tbl as bb  on (bb.id_client= s.id_client and bb.id_section=2011 )  
  where s.mmgg =  pmmgg and s.hperiod = 2011
  and ss.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_1     
  join (select ppref as key, 


  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_5, 
  sum(s.b_dtval_tax) as sdpdv_b_01_5, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_5,
  sum(s.b_ktval_tax) as skpdv_b_01_5, 
  0 as kvt_01_5, 
  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_5, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_5,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_5, sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_5, 
  0 as sp1_01_5, 0 as sp1pdv_01_5,0 as sp2_01_5, 0 as sp2pdv_01_5, 
  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_5, sum(s.dtval_kt_tax) as billktpdv_01_5,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_5, 
  sum(s.e_dtval_tax) as sdpdv_e_01_5, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_5,
  sum(s.e_ktval_tax) as skpdv_e_01_5 


  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)

  where s.mmgg =  pmmgg and s.hperiod = 2011
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and ss.roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_5 using (key)
) as sss
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

--------------------------------------------------------------

-- те строки, по которым не было движения
update rep_nds2011_tbl set 

deb_e_01_1 = deb_b_01_1, 
dpdv_e_01_1=dpdv_b_01_1, 

kr_e_01_1  =kr_b_01_1 , 
kpdv_e_01_1=kpdv_b_01_1 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
and dem_01_1 = 0 and dempdv_01_1 = 0 and opl_01_1 = 0 and oplpdv_01_1=0 and sp1_01_1 =0 and sp1pdv_01_1 = 0
and sp2_01_1 = 0 and sp2pdv_01_1 = 0;


update rep_nds2011_tbl set 

deb_e_01_5 = deb_b_01_5, 
dpdv_e_01_5=dpdv_b_01_5, 

kr_e_01_5  =kr_b_01_5 , 
kpdv_e_01_5=kpdv_b_01_5 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
and dem_01_5 = 0 and dempdv_01_5 = 0 and opl_01_5 = 0 and oplpdv_01_5=0 and sp1_01_5 =0 and sp1pdv_01_5 = 0
and sp2_01_5 = 0 and sp2pdv_01_5 = 0;


-------------------------------------------------------------------------
 -- совсем старое - реактивки быть не должно
  update rep_nds2011_tbl set 
   deb_e_008_5 = deb_b_008_5,
   dpdv_e_008_5 = dpdv_b_008_5   
  where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 update rep_nds2011_tbl set 
  deb_e_99_1 = deb_b_99_1 , 
  deb_e_99_5 = deb_b_99_5  
 where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 update rep_nds2011_tbl set 
  deb_e_00_1 = deb_b_00_1 ,
  dpdv_e_00_1= dpdv_b_00_1 ,

  deb_e_00_5 =deb_b_00_5 ,
  dpdv_e_00_5=dpdv_b_00_5 
 where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;
 

-------------------------------------------------------------------------

-- 2016


 update rep_nds2011_tbl set

	dem_16_1    = coalesce(dem_16_1,0) - coalesce(dem_11_1,0)  - coalesce(dem_01_1,0),             
	dempdv_16_1 = coalesce(dempdv_16_1,0) - coalesce(dempdv_11_1,0) - coalesce(dempdv_01_1,0),  

	dem_16_5    = coalesce(dem_16_5,0) - coalesce(dem_11_5,0) - coalesce(dem_01_5,0), 
	dempdv_16_5 = coalesce(dempdv_16_5,0) - coalesce(dempdv_11_5,0) - coalesce(dempdv_01_5,0), 

	-------
	opl_16_1    = coalesce(opl_16_1,0) - coalesce(opl_11_1,0)- coalesce(opl_01_1,0) , 
	oplpdv_16_1 = coalesce(oplpdv_16_1,0) - coalesce(oplpdv_11_1,0) - coalesce(oplpdv_01_1,0), 

	opl_16_5    = coalesce(opl_16_5,0) - coalesce(opl_11_5,0)- coalesce(opl_01_5,0) , 
	oplpdv_16_5 = coalesce(oplpdv_16_5,0) - coalesce(oplpdv_11_5,0) - coalesce(oplpdv_01_5,0), 

	-----------------

	kr_e_16_1   = coalesce(kr_e_16_1,0)   - coalesce(kr_e_11_1,0) -coalesce(kr_e_01_1,0), 
	kpdv_e_16_1 = coalesce(kpdv_e_16_1,0) - coalesce(kpdv_e_11_1,0) -coalesce(kpdv_e_01_1,0), 
        

	kr_e_16_5   = coalesce(kr_e_16_5,0)   - coalesce(kr_e_11_5,0) -coalesce(kr_e_01_5,0), 
	kpdv_e_16_5 = coalesce(kpdv_e_16_5,0) - coalesce(kpdv_e_11_5,0) -coalesce(kpdv_e_01_5,0),

	-------------------
        deb_e_16_1  =  coalesce(deb_e_16_1,0) - coalesce(deb_e_11_1,0) - coalesce(deb_e_01_1,0),
        dpdv_e_16_1 =  coalesce(dpdv_e_16_1,0)-coalesce(dpdv_e_11_1,0) - coalesce(dpdv_e_01_1,0),

        deb_e_16_5  =  coalesce(deb_e_16_5,0) - coalesce(deb_e_11_5,0) - coalesce(deb_e_01_5,0) ,-- - coalesce(deb_e_99_5,0),
        dpdv_e_16_5 =  coalesce(dpdv_e_16_5,0)-coalesce(dpdv_e_11_5,0) - coalesce(dpdv_e_01_5,0)
	-------------------

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;



------------------------------------------
/*
  select into r1 * from rep_nds2011_tbl where id_pref = ppref and mmgg = pmmgg ;
  select into r2 * from rep_nds2011_tbl where id_pref = ppref and mmgg = pmmgg ;

  if (r1.KR_E_11_1 > r1.KR_b_11_1) then r1.KR_E_11_1 = r1.KR_b_11_1; end if;
  if (r1.KPDV_E_11_1 > r1.KPDV_B_11_1) then r1.KPDV_E_11_1 = r1.KPDV_B_11_1; end if;

  if (r1.DEB_E_11_1 > r1.DEB_B_11_1) then r1.DEB_E_11_1 = r1.DEB_B_11_1; end if;
  if (r1.DPDV_E_11_1 > r1.DPDV_B_11_1) then r1.DPDV_E_11_1 = r1.DPDV_B_11_1; end if;

  if (r1.KR_E_11_1 <0 ) then r1.KR_E_11_1 = 0; end if;
  if (r1.KPDV_E_11_1 <0 ) then r1.KPDV_E_11_1 = 0; end if;
  if (r1.DEB_E_11_1 <0 ) then r1.DEB_E_11_1 = 0; end if;
  if (r1.DPDV_E_11_1 <0 ) then r1.DPDV_E_11_1 = 0; end if;

  if (r1.DEB_B_11_1 -  r1.KR_b_11_1 + r1.DEM_11_1 - r1.OPL_11_1 - r1.DEB_E_11_1 + r1.KR_E_11_1 <> 0 ) or
     (r1.DPDV_B_11_1 -  r1.KPDV_b_11_1 + r1.DEMPDV_11_1 - r1.OPLPDV_11_1 - r1.DPDV_E_11_1 + r1.KPDV_E_11_1 <> 0)
  THEN
    
    r1.OPL_11_1:= r1.DEB_B_11_1 - r1.DEB_E_11_1;
    r1.DEM_11_1:= r1.KR_b_11_1 - r1.KR_E_11_1;

    r1.OPLPDV_11_1:= r1.DPDV_B_11_1 - r1.DPDV_E_11_1;
    r1.DEMPDV_11_1:= r1.KPDV_b_11_1 - r1.KPDV_E_11_1;

    update rep_nds2011_tbl set

	dem_11_1    =  r1.dem_11_1,
	dempdv_11_1 =  r1.dempdv_11_1,

	opl_11_1    =  r1.opl_11_1,
	oplpdv_11_1 =  r1.oplpdv_11_1,

	kr_e_11_1   =  r1.kr_e_11_1,
	kpdv_e_11_1 =  r1.kpdv_e_11_1,
        
        deb_e_11_1  =  r1.deb_e_11_1,
        dpdv_e_11_1 =  r1.dpdv_e_11_1,

	billkt_11_1 =  r1.dem_11_1,
	billktpdv_11_1 =  r1.dempdv_11_1

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


   update rep_nds2011_tbl set

	dem_16_1    =  dem_16_1   + (r2.dem_11_1 - r1.dem_11_1),
	dempdv_16_1 =  dempdv_16_1+ (r2.dempdv_11_1 - r1.dempdv_11_1),

	opl_16_1    =  opl_16_1   + (r2.opl_11_1 - r1.opl_11_1),
	oplpdv_16_1 =  oplpdv_16_1+ (r2.oplpdv_11_1 - r1.oplpdv_11_1),

	kr_e_16_1   =  kr_e_16_1  + (r2.kr_e_11_1 - r1.kr_e_11_1),
	kpdv_e_16_1 =  kpdv_e_16_1+ (r2.kpdv_e_11_1 - r1.kpdv_e_11_1),
        
        deb_e_16_1  =  deb_e_16_1 + (r2.deb_e_11_1 - r1.deb_e_11_1),
        dpdv_e_16_1 =  dpdv_e_16_1+ (r2.dpdv_e_11_1 - r1.dpdv_e_11_1),

	billkt_16_1 =  billkt_16_1+ (r2.dem_11_1 - r1.dem_11_1),
	billktpdv_16_1 =  billktpdv_16_1+ (r2.dempdv_11_1 - r1.dempdv_11_1)

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

  end if;

                

  if (r1.KR_E_11_5 > r1.KR_b_11_5) then r1.KR_E_11_5 = r1.KR_b_11_5; end if;
  if (r1.KPDV_E_11_5 > r1.KPDV_B_11_5) then r1.KPDV_E_11_5 = r1.KPDV_B_11_5; end if;

  if (r1.DEB_E_11_5 > r1.DEB_B_11_5) then r1.DEB_E_11_5 = r1.DEB_B_11_5; end if;
  if (r1.DPDV_E_11_5 > r1.DPDV_B_11_5) then r1.DPDV_E_11_5 = r1.DPDV_B_11_5; end if;

  if (r1.KR_E_11_5 <0 ) then r1.KR_E_11_5 = 0; end if;
  if (r1.KPDV_E_11_5 <0 ) then r1.KPDV_E_11_5 = 0; end if;
  if (r1.DEB_E_11_5 <0 ) then r1.DEB_E_11_5 = 0; end if;
  if (r1.DPDV_E_11_5 <0 ) then r1.DPDV_E_11_5 = 0; end if;

  if (r1.DEB_B_11_5 -  r1.KR_b_11_5 + r1.DEM_11_5 - r1.OPL_11_5 - r1.DEB_E_11_5 + r1.KR_E_11_5 <> 0 ) or
     (r1.DPDV_B_11_5 -  r1.KPDV_b_11_5 + r1.DEMPDV_11_5 - r1.OPLPDV_11_5 - r1.DPDV_E_11_5 + r1.KPDV_E_11_5 <> 0)
  THEN
    
    r1.OPL_11_5:= r1.DEB_B_11_5 - r1.DEB_E_11_5;
    r1.DEM_11_5:= r1.KR_b_11_5 - r1.KR_E_11_5;

    r1.OPLPDV_11_5:= r1.DPDV_B_11_5 - r1.DPDV_E_11_5;
    r1.DEMPDV_11_5:= r1.KPDV_b_11_5 - r1.KPDV_E_11_5;

    update rep_nds2011_tbl set

	dem_11_5    =  r1.dem_11_5,
	dempdv_11_5 =  r1.dempdv_11_5,

	opl_11_5    =  r1.opl_11_5,
	oplpdv_11_5 =  r1.oplpdv_11_5,

	kr_e_11_5   =  r1.kr_e_11_5,
	kpdv_e_11_5 =  r1.kpdv_e_11_5,
        
        deb_e_11_5  =  r1.deb_e_11_5,
        dpdv_e_11_5 =  r1.dpdv_e_11_5,

	billkt_11_5 =  r1.dem_11_5,
	billktpdv_11_5 =  r1.dempdv_11_5

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


   update rep_nds2011_tbl set

	dem_16_5    =  dem_16_5   + (r2.dem_11_5 - r1.dem_11_5),
	dempdv_16_5 =  dempdv_16_5+ (r2.dempdv_11_5 - r1.dempdv_11_5),

	opl_16_5    =  opl_16_5   + (r2.opl_11_5 - r1.opl_11_5),
	oplpdv_16_5 =  oplpdv_16_5+ (r2.oplpdv_11_5 - r1.oplpdv_11_5),

	kr_e_16_5   =  kr_e_16_5  + (r2.kr_e_11_5 - r1.kr_e_11_5),
	kpdv_e_16_5 =  kpdv_e_16_5+ (r2.kpdv_e_11_5 - r1.kpdv_e_11_5),
        
        deb_e_16_5  =  deb_e_16_5 + (r2.deb_e_11_5 - r1.deb_e_11_5),
        dpdv_e_16_5 =  dpdv_e_16_5+ (r2.dpdv_e_11_5 - r1.dpdv_e_11_5),

	billkt_16_5 =  billkt_16_5+ (r2.dem_11_5 - r1.dem_11_5),
	billktpdv_16_5 =  billktpdv_16_5+ (r2.dempdv_11_5 - r1.dempdv_11_5)

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

  end if;

*/                       

RETURN 1;
end;
$BODY$
LANGUAGE 'plpgsql';          
