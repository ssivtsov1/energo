;
set client_encoding = 'win';
--id_section = 2000
--id_section = 2001
--id_section = 2002
--id_section = 2011



ALTER TABLE rep_nds2011_fiz_tbl ADD COLUMN flock integer;
ALTER TABLE rep_nds2011_fiz_tbl ADD COLUMN id_section integer;
ALTER TABLE rep_nds2011_fiz_tbl ADD COLUMN id serial;
ALTER TABLE rep_nds2011_fiz_tbl ADD COLUMN fixed integer;

ALTER TABLE rep_nds2011_fiz_tbl ADD COLUMN BILLKT_01_1  numeric(14,2);
ALTER TABLE rep_nds2011_fiz_tbl ALTER COLUMN BILLKT_01_1 SET DEFAULT 0;
ALTER TABLE rep_nds2011_fiz_tbl ADD COLUMN BILLKTPDV_01_1  numeric(14,2);
ALTER TABLE rep_nds2011_fiz_tbl ALTER COLUMN BILLKTPDV_01_1 SET DEFAULT 0;



update rep_nds2011_fiz_tbl set id_section = 2002 where id_section is null;
update rep_nds2011_fiz_tbl set fixed = 0 where fixed is null;

ALTER TABLE rep_nds2011_fiz_tbl drop CONSTRAINT rep_nds2011_fiz_tbl_pkey;
ALTER TABLE rep_nds2011_fiz_tbl add CONSTRAINT rep_nds2011_fiz_tbl_pkey  PRIMARY KEY (mmgg, id_pref, id_grp,id_section);




create or replace function rep_nds2016_abon_fun(date,int,bool) returns int
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

  r2_01 record;
  r3_01 record;
  r4_01 record;

  r2_11 record;
  r3_11 record;
  r4_11 record;

  r4_008 record;
  r4_00 record;
  r4_99 record;
  
BEGIN

 if pmmgg < '2016-01-01' then

  return 0;

 end if;


 if pbuild then 

  perform seb_all(0, date_trunc('month', pmmgg)::date );


  update seb_obrs_tmp set b_dtval=0, b_ktval=b_ktval-b_dtval where b_dtval<0;
  update seb_obrs_tmp set  b_dtval_tax=0, b_ktval_tax=b_ktval_tax-b_dtval_tax  where b_dtval_tax<0;
  update seb_obrs_tmp set e_dtval=0,e_ktval=e_ktval-e_dtval where e_dtval<0;
  update seb_obrs_tmp set   e_dtval_tax=0,e_ktval_tax=e_ktval_tax-e_dtval_tax  where e_dtval_tax<0;

  update seb_obrs_tmp set b_ktval=0,    b_dtval=b_dtval-b_ktval 
                 where b_ktval<0 and (select sum(b_ktval)  as skt_val from seb_obrs_tmp a
                        where a.id_client=seb_obrs_tmp.id_client  
                        and a.id_pref=seb_obrs_tmp.id_pref 
                        and a.hmmgg=seb_obrs_tmp.hmmgg)<>0  
                                     and date_trunc('year',seb_obrs_tmp.hmmgg)=date_trunc('year',pmmgg::date);

  update seb_obrs_tmp set b_ktval_tax=0, b_dtval_tax=b_dtval_tax-b_ktval_tax   
               where b_ktval_tax<0 and (select sum(b_ktval_tax)  as skt_val from seb_obrs_tmp a
                        where a.id_client=seb_obrs_tmp.id_client  
                        and a.id_pref=seb_obrs_tmp.id_pref 
                        and a.hmmgg=seb_obrs_tmp.hmmgg)<>0 
                         and date_trunc('year',seb_obrs_tmp.hmmgg)=date_trunc('year',pmmgg::date);


  update seb_obrs_tmp set e_ktval=0,e_dtval=coalesce(e_dtval,0)-e_ktval 
               where e_ktval<0 and (select sum(e_ktval)  as skt_val from seb_obrs_tmp a
                        where a.id_client=seb_obrs_tmp.id_client  
                        and a.id_pref=seb_obrs_tmp.id_pref 
                        and a.hmmgg=seb_obrs_tmp.hmmgg)<>0
                         and date_trunc('year',seb_obrs_tmp.hmmgg)=date_trunc('year',pmmgg::date);

  update seb_obrs_tmp set   e_ktval_tax=0,e_dtval_tax=e_dtval_tax-e_ktval_tax  
               where e_ktval_tax<0 and (select sum(e_ktval_tax)  as skt_val from seb_obrs_tmp a
                        where a.id_client=seb_obrs_tmp.id_client  
                        and a.id_pref=seb_obrs_tmp.id_pref 
                        and a.hmmgg=seb_obrs_tmp.hmmgg)<>0 
                         and date_trunc('year',seb_obrs_tmp.hmmgg)=date_trunc('year',pmmgg::date);


 end if;


 select into r_old * from rep_nds2011_tbl where id_pref = ppref and mmgg = pmmgg - '1 month'::interval;

 -- for old kt
 

 delete from rep_nds_oldkt_tbl;

 insert into rep_nds_oldkt_tbl(mmgg,id_pref,id_client,kt_b,kt_pdv_b,kt_e,kt_pdv_e)
 select pmmgg,ppref,id_client, sum(b_ktval)+sum(b_ktval_tax) as b_kt, sum(b_ktval_tax) as b_kttax,
     sum(e_ktval)+sum(e_ktval_tax) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = ppref  
     and date_part('year',hmmgg) in (1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015) group by id_client;


 select trim(value_ident) into vkodres from syi_sysvars_tbl where ident='kod_res'; 

 perform rep_mmggpay_2016_fun(ppref, pmmgg);
 perform rep_mmggbill_2016_fun(ppref, pmmgg);

 if ( select flock from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_grp = 2 and id_section = 2011) = 1 then
  raise notice 'closed month!';
  return -1;
 end if;
-------------------------------------------------------------------------------------
-- 1999π
 select into r4_99 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 1999 and id_grp = 4 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 1999 and id_grp = 4;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 4, 1999 , coalesce(r_old.deb_e_99_4,0), 0, 0, 0);


  update rep_nds2011_fiz_tbl set  deb_e_01 = deb_b_01 
  where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 4 and id_section = 1999;

  select into r4_99 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 1999 and id_grp = 4;
 end if;

-- 2000π
 select into r4_00 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2000 and id_grp = 4 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2000 and id_grp = 4;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 4, 2000 , coalesce(r_old.deb_e_00_4,0), coalesce(r_old.dpdv_e_00_4,0), 0, 0);


  update rep_nds2011_fiz_tbl set  deb_e_01 = deb_b_01, dpdv_e_01 = dpdv_b_01, kr_e_01 = kr_b_01,kpdv_e_01 = kpdv_b_01
  where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 4 and id_section = 2000;

  select into r4_00 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2000 and id_grp = 4;
 end if;


-- 2001π³κ δξ 1 ρεπονÿ
 select into r4_008 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2001 and id_grp = 4 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2001 and id_grp = 4;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 4, 2001 , coalesce(r_old.deb_e_008_4,0), coalesce(r_old.dpdv_e_008_4,0), 0, 0);


  update rep_nds2011_fiz_tbl set  deb_e_01 = deb_b_01, dpdv_e_01 = dpdv_b_01, kr_e_01 = kr_b_01,kpdv_e_01 = kpdv_b_01
  where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 4 and id_section = 2001;

  select into r4_008 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2001 and id_grp = 4;
 end if;


--- 2001π³κ η 1 ρεπονÿ (2002)

 select into r2_01 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 2 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 2;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 2, 2002 , coalesce(r_old.deb_e_01_2,0), coalesce(r_old.dpdv_e_01_2,0), coalesce(r_old.kr_e_01_2,0), coalesce(r_old.kpdv_e_01_2,0));


  update rep_nds2011_fiz_tbl set  deb_e_01 = deb_b_01, dpdv_e_01 = dpdv_b_01, kr_e_01 = kr_b_01,kpdv_e_01 = kpdv_b_01
  where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 2 and id_section = 2002;

  select into r2_01 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 2;
 end if;

 select into r3_01 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 3 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl where  mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 3;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 3, 2002 , coalesce(r_old.deb_e_01_3,0), coalesce(r_old.dpdv_e_01_3,0), coalesce(r_old.kr_e_01_3,0), coalesce(r_old.kpdv_e_01_3,0));

  update rep_nds2011_fiz_tbl set  deb_e_01 = deb_b_01, dpdv_e_01 = dpdv_b_01, kr_e_01 = kr_b_01,kpdv_e_01 = kpdv_b_01
  where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 3 and id_section = 2002;

  select into r3_01 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 3;

 end if;
 
 select into r4_01 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 4 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl  where  mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 4;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 4, 2002 , coalesce(r_old.deb_e_01_4,0), coalesce(r_old.dpdv_e_01_4,0), coalesce(r_old.kr_e_01_4,0), coalesce(r_old.kpdv_e_01_4,0));

  update rep_nds2011_fiz_tbl set  deb_e_01 = deb_b_01, dpdv_e_01 = dpdv_b_01, kr_e_01 = kr_b_01,kpdv_e_01 = kpdv_b_01
  where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 4 and id_section = 2002;

  select into r4_01 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2002 and id_grp = 4;

 end if;

 ---------------------------------------------------------------------------------------------------------
 --delete from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2;
 select into r2_11 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2011 and id_grp = 2 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl  where  mmgg = pmmgg and id_pref = ppref and id_section = 2011 and id_grp = 2;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 2, 2011 , coalesce(r_old.deb_e_11_2,0), coalesce(r_old.dpdv_e_11_2,0), coalesce(r_old.kr_e_11_2,0), coalesce(r_old.kpdv_e_11_2,0));


  update rep_nds2011_fiz_tbl set 
  deb_e_01     = coalesce(ss.deb_e_11_2,0) 		- r2_01.deb_e_01,
  dpdv_e_01    = coalesce(ss.dpdv_e_11_2,0) 	- r2_01.dpdv_e_01,
  kr_e_01      = coalesce(ss.kr_e_11_2,0) 		- r2_01.kr_e_01,
  kpdv_e_01    = coalesce(ss.kpdv_e_11_2,0) 	- r2_01.kpdv_e_01,
  kvt_01       = coalesce(ss.kvt_11_2,0) 		- r2_01.kvt_01,
  dem_01       = coalesce(ss.dem_11_2,0) 		- r2_01.dem_01,
  dempdv_01    = coalesce(ss.dempdv_11_2,0) 	- r2_01.dempdv_01,
  opl_01       = coalesce(ss.opl_11_2,0) 		- r2_01.opl_01,
  oplpdv_01    = coalesce(ss.oplpdv_11_2,0) 	- r2_01.oplpdv_01,
  sp1_01       = coalesce(ss.sp1_11_2,0) 		- r2_01.sp1_01,
  sp1pdv_01    = coalesce(ss.sp1pdv_11_2,0) 	- r2_01.sp1pdv_01,
  sp2_01       = coalesce(ss.sp2_11_2,0)		- r2_01.sp2_01,
  sp2pdv_01    = coalesce(ss.sp2pdv_11_2,0)		- r2_01.sp2pdv_01,
  BILLKT_01_1    = coalesce(ss.billkt_11_2,0),--	- r2_01.BILLKT_01_1,
  BILLKTPDV_01_1 = coalesce(ss.billktpdv_11_2,0)-- 	- r2_01.BILLKTPDV_01_1

  from ( select
--  select -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)-coalesce(deb_pm16v,0)) as deb_b_11_2,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)-coalesce(deb_pm16pdv,0)) as dpdv_b_11_2, 
--  sum(old_kt.kt_b) as kr_b_11_2, sum(old_kt.kt_pdv_b) as kpdv_b_11_2, 

  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)-coalesce(deb_km16v,0)-coalesce(deb_km17v,0)) as deb_e_11_2, 
  -sum(deb_kmpdv-coalesce(deb_km00pdv,0)-coalesce(deb_km16pdv,0)-coalesce(deb_km17pdv,0)) as dpdv_e_11_2, 
  sum(old_kt.kt_e) as kr_e_11_2, sum(old_kt.kt_pdv_e) as kpdv_e_11_2, 
  0 as kvt_11_2, 
  --sum(coalesce(old_kt.kt_b - old_kt.kt_e,0)) as dem_11_2,  sum(coalesce(old_kt.kt_pdv_b - old_kt.kt_pdv_e,0)) as dempdv_11_2,
  sum(bb.summ_bill+bb.summ_pdv) as dem_11_2, sum(bb.summ_pdv) as dempdv_11_2,
  sum(p.pay) as opl_11_2,sum(p.pay_tax) as oplpdv_11_2, 
  sum(p.writeoff)as sp1_11_2, sum(p.writeoff_tax)as sp1pdv_11_2,sum(p.trush)as sp2_11_2, sum(p.trush_tax)as sp2pdv_11_2,  

--  sum(coalesce(ktpay.billkt,0)) as billkt_11_2, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_11_2 
  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as billkt_11_2, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_11_2 

--  sum(coalesce(old_kt.kt_b - old_kt.kt_e,0)) as billkt_11_2, 
--  sum(coalesce(old_kt.kt_pdv_b - old_kt.kt_pdv_e,0)) as billktpdv_11_2
  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  left join rep_nds_oldkt_tbl as old_kt on (old_kt.id_client = s.id_client and old_kt.id_pref = ppref and old_kt.mmgg = pmmgg)
  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2011 )  
  left join rep_nds_bill_tbl as bb  on (bb.id_client= s.id_client and bb.id_section=2011 )  
  where period =  date_trunc('month', pmmgg) and roz in (11) and s.id_pref = ppref and c.idk_work not in (0,99)
  ) as ss where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 2 and id_section = 2011;
 
 end if;

 select into r3_11 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2011 and id_grp = 3 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl  where  mmgg = pmmgg and id_pref = ppref and id_section = 2011 and id_grp = 3;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 3, 2011 , coalesce(r_old.deb_e_11_3,0), coalesce(r_old.dpdv_e_11_3,0), coalesce(r_old.kr_e_11_3,0), coalesce(r_old.kpdv_e_11_3,0));

  update rep_nds2011_fiz_tbl set 
  deb_e_01     = coalesce(ss.deb_e_11_2,0) 		- r3_01.deb_e_01,
  dpdv_e_01    = coalesce(ss.dpdv_e_11_2,0) 	- r3_01.dpdv_e_01,
  kr_e_01      = coalesce(ss.kr_e_11_2,0) 		- r3_01.kr_e_01,
  kpdv_e_01    = coalesce(ss.kpdv_e_11_2,0) 	- r3_01.kpdv_e_01,
  kvt_01       = coalesce(ss.kvt_11_2,0) 		- r3_01.kvt_01,
  dem_01       = coalesce(ss.dem_11_2,0) 		- r3_01.dem_01,
  dempdv_01    = coalesce(ss.dempdv_11_2,0) 	- r3_01.dempdv_01,
  opl_01       = coalesce(ss.opl_11_2,0) 		- r3_01.opl_01,
  oplpdv_01    = coalesce(ss.oplpdv_11_2,0) 	- r3_01.oplpdv_01,
  sp1_01       = coalesce(ss.sp1_11_2,0) 		- r3_01.sp1_01,
  sp1pdv_01    = coalesce(ss.sp1pdv_11_2,0) 	- r3_01.sp1pdv_01,
  sp2_01       = coalesce(ss.sp2_11_2,0)		- r3_01.sp2_01,
  sp2pdv_01    = coalesce(ss.sp2pdv_11_2,0)		- r3_01.sp2pdv_01,
  BILLKT_01_1    = coalesce(ss.billkt_11_2,0),--	- r3_01.BILLKT_01_1,
  BILLKTPDV_01_1 = coalesce(ss.billktpdv_11_2,0)-- 	- r3_01.BILLKTPDV_01_1

  from (  select
--  select -sum(deb_zpmv-coalesce(deb_pm99v,0)-coalesce(deb_pm00v,0)-coalesce(deb_pm16v,0)) as deb_b_11_2,-sum(deb_zpmpdv-coalesce(deb_pm00pdv,0)-coalesce(deb_pm16pdv,0)) as dpdv_b_11_2, 
--  sum(old_kt.kt_b) as kr_b_11_2, sum(old_kt.kt_pdv_b) as kpdv_b_11_2, 

  -sum(deb_kmv-coalesce(deb_km99v,0)-coalesce(deb_km00v,0)-coalesce(deb_km16v,0)-coalesce(deb_km17v,0)) as deb_e_11_2, 
  -sum(deb_kmpdv-coalesce(deb_km00pdv,0)-coalesce(deb_km16pdv,0)-coalesce(deb_km17pdv,0)) as dpdv_e_11_2, 
  sum(old_kt.kt_e) as kr_e_11_2, sum(old_kt.kt_pdv_e) as kpdv_e_11_2, 
  0 as kvt_11_2, 
  --sum(coalesce(old_kt.kt_b - old_kt.kt_e,0)) as dem_11_2,  sum(coalesce(old_kt.kt_pdv_b - old_kt.kt_pdv_e,0)) as dempdv_11_2,
  sum(bb.summ_bill+bb.summ_pdv) as dem_11_2, sum(bb.summ_pdv) as dempdv_11_2,
  sum(p.pay) as opl_11_2,sum(p.pay_tax) as oplpdv_11_2, 
  sum(p.writeoff)as sp1_11_2, sum(p.writeoff_tax)as sp1pdv_11_2,sum(p.trush)as sp2_11_2, sum(p.trush_tax)as sp2pdv_11_2,  
--  sum(coalesce(old_kt.kt_b - old_kt.kt_e,0)) as billkt_11_2, 
--  sum(coalesce(old_kt.kt_pdv_b - old_kt.kt_pdv_e,0)) as billktpdv_11_2
--  sum(coalesce(ktpay.billkt,0)) as billkt_11_2, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_11_2 
  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as billkt_11_2, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_11_2 

  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  left join rep_nds_oldkt_tbl as old_kt on (old_kt.id_client = s.id_client and old_kt.id_pref = ppref and old_kt.mmgg = pmmgg)
  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2011 )  
  left join rep_nds_bill_tbl as bb  on (bb.id_client= s.id_client and bb.id_section=2011 )  
  where period =  date_trunc('month', pmmgg) and roz in (12) and s.id_pref = ppref and c.idk_work not in (0,99)
  ) as ss where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 3 and id_section = 2011;

 end if;


 select into r4_11 * from rep_nds2011_fiz_tbl where mmgg = pmmgg and id_pref = ppref and id_section = 2011 and id_grp = 4 and fixed = 1;
 if not found then 

  delete from rep_nds2011_fiz_tbl  where  mmgg = pmmgg and id_pref = ppref and id_section = 2011 and id_grp = 4;

  insert into rep_nds2011_fiz_tbl (mmgg, id_pref, id_grp, id_section, deb_b_01, dpdv_b_01, kr_b_01, kpdv_b_01)
  values(pmmgg, ppref, 4, 2011 , coalesce(r_old.deb_e_11_4,0), coalesce(r_old.dpdv_e_11_4,0), coalesce(r_old.kr_e_11_4,0), coalesce(r_old.kpdv_e_11_4,0));

  update rep_nds2011_fiz_tbl set 
  deb_e_01     = coalesce(ss.deb_e_11_2,0) 	- r4_01.deb_e_01	-r4_008.deb_e_01 	-r4_00.deb_e_01		-r4_99.deb_e_01,
  dpdv_e_01    = coalesce(ss.dpdv_e_11_2,0) 	- r4_01.dpdv_e_01	-r4_008.dpdv_e_01	-r4_00.dpdv_e_01,
  kr_e_01      = coalesce(ss.kr_e_11_2,0) 		- r4_01.kr_e_01		-r4_008.kr_e_01 	-r4_00.kr_e_01,
  kpdv_e_01    = coalesce(ss.kpdv_e_11_2,0) 	- r4_01.kpdv_e_01	-r4_008.kpdv_e_01 	-r4_00.kpdv_e_01,
  kvt_01       = coalesce(ss.kvt_11_2,0) 		- r4_01.kvt_01		-r4_008.kvt_01 		-r4_00.kvt_01,
  dem_01       = coalesce(ss.dem_11_2,0) 		- r4_01.dem_01		-r4_008.dem_01 		-r4_00.dem_01,
  dempdv_01    = coalesce(ss.dempdv_11_2,0) 	- r4_01.dempdv_01	-r4_008.dempdv_01 	-r4_00.dempdv_01,
  opl_01       = coalesce(ss.opl_11_2,0) 		- r4_01.opl_01		-r4_008.opl_01 		-r4_00.opl_01           -r4_99.opl_01,
  oplpdv_01    = coalesce(ss.oplpdv_11_2,0) 	- r4_01.oplpdv_01	-r4_008.oplpdv_01 	-r4_00.oplpdv_01	-r4_99.oplpdv_01,
  sp1_01       = coalesce(ss.sp1_11_2,0) 		- r4_01.sp1_01		-r4_008.sp1_01 		-r4_00.sp1_01		-r4_99.sp1_01,
  sp1pdv_01    = coalesce(ss.sp1pdv_11_2,0) 	- r4_01.sp1pdv_01	-r4_008.sp1pdv_01 	-r4_00.sp1pdv_01	-r4_99.sp1pdv_01,
  sp2_01       = coalesce(ss.sp2_11_2,0)		- r4_01.sp2_01		-r4_008.sp2_01 		-r4_00.sp2_01		-r4_99.sp2_01,
  sp2pdv_01    = coalesce(ss.sp2pdv_11_2,0)		- r4_01.sp2pdv_01	-r4_008.sp2pdv_01 	-r4_00.sp2pdv_01	-r4_99.sp2pdv_01,
  BILLKT_01_1    = coalesce(ss.billkt_11_2,0),--	- r4_01.BILLKT_01_1	,
  BILLKTPDV_01_1 = coalesce(ss.billktpdv_11_2,0)-- 	- r4_01.BILLKTPDV_01_1  

  from (
  select 
--  -sum(deb_zpmv-coalesce(deb_pm16v,0)) as deb_b_11_2,-sum(deb_zpmpdv-coalesce(deb_pm16pdv,0)) as dpdv_b_11_2, 
--  sum(old_kt.kt_b) as kr_b_11_2, sum(old_kt.kt_pdv_b) as kpdv_b_11_2, 

  -sum(deb_kmv-coalesce(deb_km16v,0)-coalesce(deb_km17v,0)) as deb_e_11_2, 
  -sum(deb_kmpdv-coalesce(deb_km16pdv,0)-coalesce(deb_km17pdv,0)) as dpdv_e_11_2, 
  sum(old_kt.kt_e) as kr_e_11_2, sum(old_kt.kt_pdv_e) as kpdv_e_11_2, 
  0 as kvt_11_2, 
  --sum(coalesce(old_kt.kt_b - old_kt.kt_e,0)) as dem_11_2,  sum(coalesce(old_kt.kt_pdv_b - old_kt.kt_pdv_e,0)) as dempdv_11_2,
  sum(bb.summ_bill+bb.summ_pdv) as dem_11_2, sum(bb.summ_pdv) as dempdv_11_2,
  sum(p.pay) as opl_11_2,sum(p.pay_tax) as oplpdv_11_2, 
  sum(p.writeoff)as sp1_11_2, sum(p.writeoff_tax)as sp1pdv_11_2,sum(p.trush)as sp2_11_2, sum(p.trush_tax)as sp2pdv_11_2,  

--  sum(coalesce(old_kt.kt_b - old_kt.kt_e,0)) as billkt_11_2, 
--  sum(coalesce(old_kt.kt_pdv_b - old_kt.kt_pdv_e,0)) as billktpdv_11_2
--  sum(coalesce(ktpay.billkt,0)) as billkt_11_2, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_11_2 
  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as billkt_11_2, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_11_2 

  from seb_obr_all_tmp as s left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2001 and p.id_pref = ppref and p.mmgg = period) 
  join clm_client_tbl as c on (c.id = s.id_client )
  left join rep_nds_oldkt_tbl as old_kt on (old_kt.id_client = s.id_client and old_kt.id_pref = ppref and old_kt.mmgg = pmmgg)
  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2011 )  
  left join rep_nds_bill_tbl as bb  on (bb.id_client= s.id_client and bb.id_section=2011 )  
  where period =  date_trunc('month', pmmgg) and roz in (9,13) and s.id_pref = ppref and c.idk_work not in (0,99)
  ) as ss where  rep_nds2011_fiz_tbl.mmgg = pmmgg and rep_nds2011_fiz_tbl.id_pref = ppref and id_grp = 4 and id_section = 2011;

 end if;

RETURN 1;
end;
$BODY$                                                                                           
LANGUAGE 'plpgsql';          

/*
select crt_ttbl();

select rep_nds2016_abon_fun('2016-02-01',10, true);

delete from rep_nds2011_fiz_tbl where mmgg = '2016-01-01'

  */