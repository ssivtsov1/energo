;
set client_encoding = 'win';


create or replace function rep_nds2016_ae_fun(date,int,bool) returns int
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

 perform rep_periods_saldo_ae_fun(pmmgg, ppref, null);

 perform rep_nds2016_abon_fun(pmmgg, ppref, false);
-- perform rep_mmggpay_2016_fun(ppref, pmmgg);
-- perform rep_mmggbill_2016_fun(ppref, pmmgg);



 delete from rep_nds2011_tbl where mmgg = pmmgg and id_pref = ppref and flock = 0;

 -- 2016

insert into rep_nds2011_tbl ( mmgg, id_pref, deb_b_16_1, dpdv_b_16_1, kr_b_16_1, kpdv_b_16_1, 
            deb_e_16_1, dpdv_e_16_1, kr_e_16_1, kpdv_e_16_1, kvt_16_1, dem_16_1, 
            dempdv_16_1, opl_16_1, oplpdv_16_1, sp1_16_1, sp1pdv_16_1, sp2_16_1, 
            sp2pdv_16_1, billkt_16_1, billktpdv_16_1,
            deb_b_16_2, dpdv_b_16_2, 
            kr_b_16_2, kpdv_b_16_2, deb_e_16_2, dpdv_e_16_2, kr_e_16_2, kpdv_e_16_2, 
            kvt_16_2, dem_16_2, dempdv_16_2, opl_16_2, oplpdv_16_2, sp1_16_2, 
            sp1pdv_16_2, sp2_16_2, sp2pdv_16_2, billkt_16_2, billktpdv_16_2, 

            deb_b_16_3, dpdv_b_16_3, kr_b_16_3, kpdv_b_16_3, deb_e_16_3, 
            dpdv_e_16_3, kr_e_16_3, kpdv_e_16_3, kvt_16_3, dem_16_3, dempdv_16_3, 
            opl_16_3, oplpdv_16_3, sp1_16_3, sp1pdv_16_3, sp2_16_3, sp2pdv_16_3, 
            billkt_16_3, billktpdv_16_3, 

            deb_b_16_4, dpdv_b_16_4, kr_b_16_4, 
            kpdv_b_16_4, deb_e_16_4, dpdv_e_16_4, kr_e_16_4, kpdv_e_16_4, 
            kvt_16_4, dem_16_4, dempdv_16_4, opl_16_4, oplpdv_16_4, sp1_16_4, 
            sp1pdv_16_4, sp2_16_4, sp2pdv_16_4, 
--            depozit1_16, depozit1pdv_16, depozit2_16, depozit2pdv_16, 
            billkt_16_4, billktpdv_16_4, 
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
  sum(opl_zv) - coalesce(sum(sp.sp1),0) - coalesce(sum(sp.sp2),0)  as opl_01_1,
  sum(opl_zpdv) - coalesce(sum(sp.sp1_tax),0) - coalesce(sum(sp.sp2_tax),0) as oplpdv_01_1, 

--  sum(p.sp1+p.sp1_tax) as sp1_01_1, sum(p.sp1_tax) as sp1pdv_01_1,
--  sum(p.sp2+p.sp2_tax) as sp2_01_1, sum(p.sp2_tax) as sp2pdv_01_1, 
  sum(sp.sp1) as sp1_01_1, sum(sp.sp1_tax) as sp1pdv_01_1,
  sum(sp.sp2) as sp2_01_1, sum(sp.sp2_tax) as sp2pdv_01_1, 

--  0 as sp1_01_1, 0 as sp1pdv_01_1, 0 as sp2_01_1, 0 as sp2pdv_01_1, 
--  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as BILLKT_01_1, sum(coalesce(ktpay.billktpdv,0)) as billktpdv_01_1 
  sum(coalesce(p.dtval_kt+p.dtval_kt_tax,0)) as BILLKT_01_1, sum(coalesce(p.dtval_kt_tax,0)) as billktpdv_01_1 
  from seb_obr_all_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
--  left join rep_ndspay_tbl as p on (p.id_client = s.id_client and p.period_pay = 2016 and p.id_pref = ppref and p.mmgg = period) 
  left join rep_periods_saldo_tmp as p on (p.id_client = s.id_client and p.hperiod = 2016 and p.id_pref = ppref and p.mmgg = period) 
  left join ( 
    select p.id_client,
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_pay  ELSE 0 END) as sp1 , 
    sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END) as sp2,  
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as sp1_tax, 
    sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as sp2_tax
    from acm_pay_tbl as p 
    join dci_document_tbl as d on (d.id = p.idk_doc)
    where p.id_pref = ppref and p.mmgg = pmmgg 
    group by p.id_client
  ) as sp on (sp.id_client = s.id_client) 
--  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2016 )  
  where period =  date_trunc('month', pmmgg) 
  --and roz in (101,102,103,104) 
  and roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_1 
  join (select ppref as key, 
  -sum(coalesce(deb_zpmv,0)) as deb_b_01_2,-sum(-coalesce(deb_zpmpdv,0)) as dpdv_b_01_2, 
  sum(kr_zpmv) as kr_b_01_2, sum(kr_zpmpdv) as kpdv_b_01_2, 

  -sum(deb_kmv) as deb_e_01_2, 
  -sum(deb_kmpdv) as dpdv_e_01_2, 
  sum(kr_zkmv) as kr_e_01_2, sum(kr_zkmpdv) as kpdv_e_01_2, 

  sum(nar) as kvt_01_2,sum(nar_v) as dem_01_2,sum(nar_pdv) as dempdv_01_2, 
--  sum(opl_zv) as opl_01_2,sum(opl_zpdv) as oplpdv_01_2, 
  sum(opl_zv) - coalesce(sum(sp.sp1),0) - coalesce(sum(sp.sp2),0)  as opl_01_2,
  sum(opl_zpdv) - coalesce(sum(sp.sp1_tax),0) - coalesce(sum(sp.sp2_tax),0) as oplpdv_01_2, 

  sum(sp.sp1) as sp1_01_2, sum(sp.sp1_tax) as sp1pdv_01_2,
  sum(sp.sp2) as sp2_01_2, sum(sp.sp2_tax) as sp2pdv_01_2, 
  sum(coalesce(p.dtval_kt+p.dtval_kt_tax,0)) as BILLKT_01_2, sum(coalesce(p.dtval_kt_tax,0)) as billktpdv_01_2 
  from seb_obr_all_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)

  left join rep_periods_saldo_tmp as p on (p.id_client = s.id_client and p.hperiod = 2016 and p.id_pref = ppref and p.mmgg = period) 
  left join ( 
    select p.id_client,
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_pay  ELSE 0 END) as sp1 , 
    sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END) as sp2,  
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as sp1_tax, 
    sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as sp2_tax
    from acm_pay_tbl as p 
    join dci_document_tbl as d on (d.id = p.idk_doc)
    where p.id_pref = ppref and p.mmgg = pmmgg 
    group by p.id_client
  ) as sp on (sp.id_client = s.id_client) 
  where period =  date_trunc('month', pmmgg) and roz in (11) and s.id_pref = ppref and c.idk_work not in (0,99)
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_2 using (key)

  join (select ppref as key, 
  -sum(coalesce(deb_zpmv,0)) as deb_b_01_3,-sum(-coalesce(deb_zpmpdv,0)) as dpdv_b_01_3, 
  sum(kr_zpmv) as kr_b_01_3, sum(kr_zpmpdv) as kpdv_b_01_3, 

  -sum(deb_kmv) as deb_e_01_3, 
  -sum(deb_kmpdv) as dpdv_e_01_3, 
  sum(kr_zkmv) as kr_e_01_3, sum(kr_zkmpdv) as kpdv_e_01_3, 

  sum(nar) as kvt_01_3,sum(nar_v) as dem_01_3,sum(nar_pdv) as dempdv_01_3, 
--  sum(opl_zv) as opl_01_3,sum(opl_zpdv) as oplpdv_01_3, 
  sum(opl_zv) - coalesce(sum(sp.sp1),0) - coalesce(sum(sp.sp2),0)  as opl_01_3,
  sum(opl_zpdv) - coalesce(sum(sp.sp1_tax),0) - coalesce(sum(sp.sp2_tax),0) as oplpdv_01_3, 

  sum(sp.sp1) as sp1_01_3, sum(sp.sp1_tax) as sp1pdv_01_3,
  sum(sp.sp2) as sp2_01_3, sum(sp.sp2_tax) as sp2pdv_01_3, 

  sum(coalesce(p.dtval_kt+p.dtval_kt_tax,0)) as BILLKT_01_3, sum(coalesce(p.dtval_kt_tax,0)) as billktpdv_01_3 
  from seb_obr_all_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  left join rep_periods_saldo_tmp as p on (p.id_client = s.id_client and p.hperiod = 2016 and p.id_pref = ppref and p.mmgg = period) 
  left join ( 
    select p.id_client,
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_pay  ELSE 0 END) as sp1 , 
    sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END) as sp2,  
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as sp1_tax, 
    sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as sp2_tax
    from acm_pay_tbl as p 
    join dci_document_tbl as d on (d.id = p.idk_doc)
    where p.id_pref = ppref and p.mmgg = pmmgg 
    group by p.id_client
  ) as sp on (sp.id_client = s.id_client) 
  where period =  date_trunc('month', pmmgg) and roz in (12) and s.id_pref = ppref and c.idk_work not in (0,99)
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_3 using (key)
--------------------------------------------------------------
  join (select ppref as key, 
  -sum(coalesce(deb_zpmv,0)) as deb_b_01_4,-sum(-coalesce(deb_zpmpdv,0)) as dpdv_b_01_4, 
  sum(kr_zpmv) as kr_b_01_4, sum(kr_zpmpdv) as kpdv_b_01_4, 
  -sum(deb_kmv) as deb_e_01_4, 
  -sum(deb_kmpdv) as dpdv_e_01_4, 
  sum(kr_zkmv) as kr_e_01_4, sum(kr_zkmpdv) as kpdv_e_01_4, 
  sum(nar) as kvt_01_4,sum(nar_v) as dem_01_4,sum(nar_pdv) as dempdv_01_4, 

--  sum(opl_zv) - coalesce(sum(sp.sp1),0) - coalesce(sum(sp.sp2),0)  as opl_01_4,
--  sum(opl_zpdv) - coalesce(sum(sp.sp1_tax),0) - coalesce(sum(sp.sp2_tax),0) as oplpdv_01_4, 

  sum(opl_zv)  as opl_01_4,
  sum(opl_zpdv) as oplpdv_01_4, 

  sum(sp.sp1) as sp1_01_4, sum(sp.sp1_tax) as sp1pdv_01_4,
  sum(sp.sp2) as sp2_01_4, sum(sp.sp2_tax) as sp2pdv_01_4, 
--  sum(p.writeoff)as sp1_01_4, sum(p.writeoff_tax)as sp1pdv_01_4,sum(p.trush)as sp2_01_4, sum(p.trush_tax)as sp2pdv_01_4, 
--  sum(p.depozit1)as depozit1_01, sum(p.depozit1_tax) as depozit1pdv_01,
--  sum(p.depozit2)as depozit2_01, sum(p.depozit2_tax) as depozit2pdv_01,
  sum(coalesce(ktpay.billkt+ktpay.billktpdv,0)) as billkt_01_4, 
  sum(coalesce(ktpay.billktpdv,0)) as billktpdv_01_4 
  from seb_obr_all_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  left join ( 
    select p.id_client,
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_pay  ELSE 0 END) as sp1 , 
    sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END) as sp2,  
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as sp1_tax, 
    sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as sp2_tax
    from acm_pay_tbl as p 
    join dci_document_tbl as d on (d.id = p.idk_doc)
    where p.id_pref = ppref and p.mmgg = pmmgg 
    group by p.id_client
  ) as sp on (sp.id_client = s.id_client) 
  left join rep_nds_billkt_tbl as ktpay  on (ktpay.id_client= s.id_client and ktpay.id_section=2016 )  
  where period =  date_trunc('month', pmmgg) and roz in (9,13) and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_4 using (key) 

---------------------------------------------------------------
  join (select ppref as key, 
  -sum(coalesce(deb_zpmv,0)) as deb_b_01_5,-sum(coalesce(deb_zpmpdv,0)) as dpdv_b_01_5, 
  sum(kr_zpmv) as kr_b_01_5, sum(kr_zpmpdv) as kpdv_b_01_5, 
  -sum(deb_kmv) as deb_e_01_5,  -sum(deb_kmpdv) as dpdv_e_01_5, 
  sum(kr_zkmv) as kr_e_01_5, sum(kr_zkmpdv) as kpdv_e_01_5, 
  sum(nar) as kvt_01_5,sum(nar_v) as dem_01_5,sum(nar_pdv) as dempdv_01_5, 
--  sum(opl_zv) as opl_01_5,sum(opl_zpdv) as oplpdv_01_5, 
--  sum(p.sp1+p.sp1_tax) as sp1_01_5, sum(p.sp1_tax) as sp1pdv_01_5,
--  sum(p.sp2+p.sp2_tax) as sp2_01_5, sum(p.sp2_tax) as sp2pdv_01_5, 
  sum(opl_zv) - coalesce(sum(sp.sp1),0) - coalesce(sum(sp.sp2),0)  as opl_01_5,
  sum(opl_zpdv) - coalesce(sum(sp.sp1_tax),0) - coalesce(sum(sp.sp2_tax),0) as oplpdv_01_5, 

  sum(sp.sp1) as sp1_01_5, sum(sp.sp1_tax) as sp1pdv_01_5,
  sum(sp.sp2) as sp2_01_5, sum(sp.sp2_tax) as sp2pdv_01_5, 

  sum(coalesce(p.dtval_kt+p.dtval_kt_tax,0)) as BILLKT_01_5, sum(coalesce(p.dtval_kt_tax,0)) as billktpdv_01_5 
  from seb_obr_all_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  left join rep_periods_saldo_tmp as p on (p.id_client = s.id_client and p.hperiod = 2016 and p.id_pref = ppref and p.mmgg = period) 
  left join ( 
    select p.id_client,
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_pay  ELSE 0 END) as sp1 , 
    sum(CASE WHEN d.ident ='trush' THEN p.value_pay  ELSE 0 END) as sp2,  
    sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as sp1_tax, 
    sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as sp2_tax
    from acm_pay_tbl as p 
    join dci_document_tbl as d on (d.id = p.idk_doc)
    where p.id_pref = ppref and p.mmgg = pmmgg 
    group by p.id_client
  ) as sp on (sp.id_client = s.id_client) 
  where period =  date_trunc('month', pmmgg) 
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

--  0 as sp1_11_1, 0 as sp1pdv_11_1,0 as sp2_11_1, 0 as sp2pdv_11_1, 
  sum(s.sp1+s.sp1_tax) as sp1_11_1, sum(s.sp1_tax) as sp1pdv_11_1,
  sum(s.sp2+s.sp2_tax) as sp2_11_1, sum(s.sp2_tax) as sp2pdv_11_1, 

  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_11_1, sum(s.dtval_kt_tax) as billktpdv_11_1,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_11_1, 
  sum(s.e_dtval_tax) as sdpdv_e_11_1, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_11_1,
  sum(s.e_ktval_tax) as skpdv_e_11_1 
  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
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
--  0 as sp1_11_5, 0 as sp1pdv_11_5,0 as sp2_11_5, 0 as sp2pdv_11_5, 
  sum(s.sp1+s.sp1_tax) as sp1_11_5, sum(s.sp1_tax) as sp1pdv_11_5,
  sum(s.sp2+s.sp2_tax) as sp2_11_5, sum(s.sp2_tax) as sp2pdv_11_5, 
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
--  0 as sp1_01_1, 0 as sp1pdv_01_1,0 as sp2_01_1, 0 as sp2pdv_01_1, 
  sum(s.sp1+s.sp1_tax) as sp1_01_1, sum(s.sp1_tax) as sp1pdv_01_1,
  sum(s.sp2+s.sp2_tax) as sp2_01_1, sum(s.sp2_tax) as sp2pdv_01_1, 

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
--  0 as sp1_01_5, 0 as sp1pdv_01_5,0 as sp2_01_5, 0 as sp2pdv_01_5, 
  sum(s.sp1+s.sp1_tax) as sp1_01_5, sum(s.sp1_tax) as sp1pdv_01_5,
  sum(s.sp2+s.sp2_tax) as sp2_01_5, sum(s.sp2_tax) as sp2pdv_01_5, 

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
------------------------------------------------------------------------

 -- 2001 - может быть только строка 5

update rep_nds2011_tbl set 

deb_e_008_5 = deb_b_008_5- coalesce(   sss.sdeb_b_01_5 - sss.sdeb_e_01_5,0), 
dpdv_e_008_5=dpdv_b_008_5- coalesce(   sss.sdpdv_b_01_5- sss.sdpdv_e_01_5,0), 

opl_008_5=coalesce(sss.opl_01_5,0),          
oplpdv_008_5=coalesce(sss.oplpdv_01_5,0), 

sp1_008_5=coalesce(sss.sp1_01_5,0), 
sp1pdv_008_5=coalesce(sss.sp1pdv_01_5,0), 
sp2_008_5=coalesce(sss.sp2_01_5,0), 
sp2pdv_008_5=coalesce(sss.sp2pdv_01_5,0) 

from (select * from  
  (select ppref as key, 
  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_5, 
  sum(s.b_dtval_tax) as sdpdv_b_01_5, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_5,
  sum(s.b_ktval_tax) as skpdv_b_01_5, 
--  0 as kvt_01_5, 
--  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_5, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_5,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_5, 
  sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_5, 
--  0 as sp1_01_5, 0 as sp1pdv_01_5,0 as sp2_01_5, 0 as sp2pdv_01_5, 
  sum(s.sp1+s.sp1_tax) as sp1_01_5, sum(s.sp1_tax) as sp1pdv_01_5,
  sum(s.sp2+s.sp2_tax) as sp2_01_5, sum(s.sp2_tax) as sp2pdv_01_5, 

--  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_5, sum(s.dtval_kt_tax) as billktpdv_01_5,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_5, 
  sum(s.e_dtval_tax) as sdpdv_e_01_5, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_5,
  sum(s.e_ktval_tax) as skpdv_e_01_5 

  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)

  where s.mmgg =  pmmgg and s.hperiod = 2001
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and ss.roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_5 
) as sss
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

--------------------------------------------------------------

-- те строки, по которым не было движения
update rep_nds2011_tbl set 

deb_e_008_5 = deb_b_008_5, 
dpdv_e_008_5=dpdv_b_008_5 

--kr_e_008_5  =kr_b_008_5 , 
--kpdv_e_008_5=kpdv_b_008_5 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
--and dem_008_5 = 0 and dempdv_008_5 = 0 
and opl_008_5 = 0 and oplpdv_008_5=0 and sp1_008_5 =0 and sp1pdv_008_5 = 0
and sp2_008_5 = 0 and sp2pdv_008_5 = 0;
-------------------------------------

 -- 2000
update rep_nds2011_tbl set 

deb_e_00_1 = deb_b_00_1-  coalesce(  sss.sdeb_b_01_1 - sss.sdeb_e_01_1 ,0), 
dpdv_e_00_1=dpdv_b_00_1-  coalesce(  sss.sdpdv_b_01_1- sss.sdpdv_e_01_1,0), 

opl_00_1=coalesce(sss.opl_01_1,0), 
oplpdv_00_1=coalesce(sss.oplpdv_01_1,0), 
sp1_00_1=coalesce(sss.sp1_01_1,0), 
sp1pdv_00_1=coalesce(sss.sp1pdv_01_1,0), 
sp2_00_1=coalesce(sss.sp2_01_1,0),         
sp2pdv_00_1=coalesce(sss.sp2pdv_01_1,0),  

deb_e_00_5 = deb_b_00_5- coalesce(   sss.sdeb_b_01_5 - sss.sdeb_e_01_5,0), 
dpdv_e_00_5=dpdv_b_00_5- coalesce(   sss.sdpdv_b_01_5- sss.sdpdv_e_01_5,0), 

opl_00_5=coalesce(sss.opl_01_5,0),           
oplpdv_00_5=coalesce(sss.oplpdv_01_5,0), 

sp1_00_5=coalesce(sss.sp1_01_5,0), 
sp1pdv_00_5=coalesce(sss.sp1pdv_01_5,0), 
sp2_00_5=coalesce(sss.sp2_01_5,0), 
sp2pdv_00_5=coalesce(sss.sp2pdv_01_5,0) 

from (select * from  
  (select ppref as key, 

  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_1, 
  sum(s.b_dtval_tax) as sdpdv_b_01_1, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_1,
  sum(s.b_ktval_tax) as skpdv_b_01_1, 
--  0 as kvt_01_1, 
--  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_1, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_1,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_1, sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_1, 
--  0 as sp1_01_1, 0 as sp1pdv_01_1,0 as sp2_01_1, 0 as sp2pdv_01_1, 
  sum(s.sp1+s.sp1_tax) as sp1_01_1, sum(s.sp1_tax) as sp1pdv_01_1,
  sum(s.sp2+s.sp2_tax) as sp2_01_1, sum(s.sp2_tax) as sp2pdv_01_1, 
--  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_1, sum(s.dtval_kt_tax) as billktpdv_01_1,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_1, 
  sum(s.e_dtval_tax) as sdpdv_e_01_1, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_1,
  sum(s.e_ktval_tax) as skpdv_e_01_1 
  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
  where s.mmgg =  pmmgg and s.hperiod = 2000
  and ss.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_1     

  join (select ppref as key, 
  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_5, 
  sum(s.b_dtval_tax) as sdpdv_b_01_5, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_5,
  sum(s.b_ktval_tax) as skpdv_b_01_5, 
--  0 as kvt_01_5, 
--  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_5, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_5,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_5, sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_5, 
--  0 as sp1_01_5, 0 as sp1pdv_01_5,0 as sp2_01_5, 0 as sp2pdv_01_5, 
  sum(s.sp1+s.sp1_tax) as sp1_01_5, sum(s.sp1_tax) as sp1pdv_01_5,
  sum(s.sp2+s.sp2_tax) as sp2_01_5, sum(s.sp2_tax) as sp2pdv_01_5, 
--  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_5, sum(s.dtval_kt_tax) as billktpdv_01_5,
  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_5, 
  sum(s.e_dtval_tax) as sdpdv_e_01_5, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_5,
  sum(s.e_ktval_tax) as skpdv_e_01_5 

  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
  where s.mmgg =  pmmgg and s.hperiod = 2000
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and ss.roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_5 using (key)
) as sss
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

--------------------------------------------------------------

-- те строки, по которым не было движения
update rep_nds2011_tbl set 

deb_e_00_1 = deb_b_00_1, 
dpdv_e_00_1=dpdv_b_00_1 

--kr_e_00_1  =kr_b_00_1 , 
--kpdv_e_00_1=kpdv_b_00_1 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
--and dem_00_1 = 0 and dempdv_00_1 = 0 
and opl_00_1 = 0 and oplpdv_00_1=0 and sp1_00_1 =0 and sp1pdv_00_1 = 0
and sp2_00_1 = 0 and sp2pdv_00_1 = 0;


update rep_nds2011_tbl set 

deb_e_00_5 = deb_b_00_5, 
dpdv_e_00_5=dpdv_b_00_5 

--kr_e_00_5  =kr_b_00_5 , 
--kpdv_e_00_5=kpdv_b_00_5 

where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
--and dem_00_5 = 0 and dempdv_00_5 = 0 
and opl_00_5 = 0 and oplpdv_00_5=0 and sp1_00_5 =0 and sp1pdv_00_5 = 0
and sp2_00_5 = 0 and sp2pdv_00_5 = 0;
------------------------------------------------------------------------
 -- 1999
update rep_nds2011_tbl set 

deb_e_99_1 = deb_b_99_1-  coalesce(  sss.sdeb_b_01_1 - sss.sdeb_e_01_1 ,0), 
opl_99_1=coalesce(sss.opl_01_1,0),
sp1_99_1=coalesce(sss.sp1_01_1,0),
sp2_99_1=coalesce(sss.sp2_01_1,0),

deb_e_99_5 = deb_b_99_5- coalesce(   sss.sdeb_b_01_5 - sss.sdeb_e_01_5,0), 
opl_99_5=coalesce(sss.opl_01_5,0),
sp1_99_5=coalesce(sss.sp1_01_5,0),
sp2_99_5=coalesce(sss.sp2_01_5,0)

from (select * from  
  (select ppref as key, 

  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_1, 
--  sum(s.b_dtval_tax) as sdpdv_b_01_1, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_1,
--  sum(s.b_ktval_tax) as skpdv_b_01_1, 
--  0 as kvt_01_1, 
--  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_1, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_1,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_1, 
--  sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_1, 
--  0 as sp1_01_1, 0 as sp1pdv_01_1,0 as sp2_01_1, 0 as sp2pdv_01_1, 
  sum(s.sp1) as sp1_01_1, --sum(s.sp1_tax) as sp1pdv_01_1,
  sum(s.sp2) as sp2_01_1, --sum(s.sp2_tax) as sp2pdv_01_1, 
--  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_1, sum(s.dtval_kt_tax) as billktpdv_01_1,

  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_1, 
--  sum(s.e_dtval_tax) as sdpdv_e_01_1, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_1
--  sum(s.e_ktval_tax) as skpdv_e_01_1 
  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
  where s.mmgg =  pmmgg and s.hperiod = 1999
  and ss.roz not in (11,12) and cp.flag_budjet=1 and s.id_pref = ppref and c.idk_work not in (0,99) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
) as s01_1     

  join (select ppref as key, 
  sum(s.b_dtval+s.b_dtval_tax) as sdeb_b_01_5, 
--  sum(s.b_dtval_tax) as sdpdv_b_01_5, 
  sum(s.b_ktval+s.b_ktval_tax) as skr_b_01_5,
--  sum(s.b_ktval_tax) as skpdv_b_01_5, 
--  0 as kvt_01_5, 
--  sum(s.dtval+s.dtval_tax+s.dtval_kt+s.dtval_kt_tax) as dem_01_5, sum(s.dtval_tax+s.dtval_kt_tax) as dempdv_01_5,
  sum(s.ktval+s.ktval_tax+s.ktval_kt+s.ktval_kt_tax) as opl_01_5,
--  sum(s.ktval_tax+s.ktval_kt_tax) as oplpdv_01_5, 
--  0 as sp1_01_5, 0 as sp1pdv_01_5,0 as sp2_01_5, 0 as sp2pdv_01_5, 
  sum(s.sp1) as sp1_01_5, --sum(s.sp1_tax) as sp1pdv_01_5,
  sum(s.sp2) as sp2_01_5, --sum(s.sp2_tax) as sp2pdv_01_5, 
--  sum(s.dtval_kt+s.dtval_kt_tax) as billkt_01_5, sum(s.dtval_kt_tax) as billktpdv_01_5,
  sum(s.e_dtval+s.e_dtval_tax) as sdeb_e_01_5, 
--  sum(s.e_dtval_tax) as sdpdv_e_01_5, 
  sum(s.e_ktval+s.e_ktval_tax) as skr_e_01_5
--  sum(s.e_ktval_tax) as skpdv_e_01_5 

  from rep_periods_saldo_tmp as s 
  join clm_client_tbl as c on (c.id = s.id_client )
  join clm_statecl_h as cp on (cp.id_client=c.id)
  join seb_obr_all_tmp as ss on (ss.id_client = s.id_client and ss.period =  pmmgg and ss.id_pref = ppref)
  where s.mmgg =  pmmgg and s.hperiod = 1999
  --and roz in (2,3,6,8) 
  and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
  and ss.roz not in (9,11,12,13,200,999) and cp.flag_budjet=0 and s.id_pref = ppref and c.idk_work not in (0,99)
) as s01_5 using (key)
) as sss
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

--------------------------------------------------------------

-- те строки, по которым не было движения
update rep_nds2011_tbl set 
deb_e_99_1 = deb_b_99_1 
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
and opl_99_1 = 0 and sp1_99_1 =0 and sp2_99_1 = 0 ;

update rep_nds2011_tbl set 
deb_e_99_5= deb_b_99_5 
where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref
and opl_99_5 = 0 and sp1_99_5 =0 and sp2_99_5 = 0 ;
-------------------------------------------------------------------------

-- calculate current period

 update rep_nds2011_tbl set

	dem_16_1    = coalesce(dem_16_1,0) - coalesce(dem_11_1,0)  - coalesce(dem_01_1,0),             
	dempdv_16_1 = coalesce(dempdv_16_1,0) - coalesce(dempdv_11_1,0) - coalesce(dempdv_01_1,0),  

	dem_16_5    = coalesce(dem_16_5,0) - coalesce(dem_11_5,0) - coalesce(dem_01_5,0), 
	dempdv_16_5 = coalesce(dempdv_16_5,0) - coalesce(dempdv_11_5,0) - coalesce(dempdv_01_5,0), 

	-------
	opl_16_1    = coalesce(opl_16_1,0) - coalesce(opl_11_1,0)- coalesce(opl_01_1,0) -
                      --coalesce(opl_008_1,0) -
                      coalesce(opl_00_1,0) - coalesce(opl_99_1,0),
	oplpdv_16_1 = coalesce(oplpdv_16_1,0) - coalesce(oplpdv_11_1,0) - coalesce(oplpdv_01_1,0)-
  		      --coalesce(oplpdv_008_1,0)- 
                      coalesce(oplpdv_00_1,0)	 ,

	opl_16_5    = coalesce(opl_16_5,0) - coalesce(opl_11_5,0)- coalesce(opl_01_5,0) -
                      coalesce(opl_008_5,0) -coalesce(opl_00_5,0) - coalesce(opl_99_5,0), 
	oplpdv_16_5 = coalesce(oplpdv_16_5,0) - coalesce(oplpdv_11_5,0) - coalesce(oplpdv_01_5,0)- 
  		      coalesce(oplpdv_008_5,0)- coalesce(oplpdv_00_5,0)	 ,
	-----------------
	-------
	sp1_16_1    = coalesce(sp1_16_1,0) - coalesce(sp1_11_1,0)- coalesce(sp1_01_1,0) -
                      --coalesce(sp1_008_1,0) -
                      coalesce(sp1_00_1,0) - coalesce(sp1_99_1,0),
	sp1pdv_16_1 = coalesce(sp1pdv_16_1,0) - coalesce(sp1pdv_11_1,0) - coalesce(sp1pdv_01_1,0)-
  		      --coalesce(sp1pdv_008_1,0)- 
                      coalesce(sp1pdv_00_1,0)	 ,
	-------
	sp2_16_1    = coalesce(sp2_16_1,0) - coalesce(sp2_11_1,0)- coalesce(sp2_01_1,0) -
                      --coalesce(sp2_008_1,0) -
                      coalesce(sp2_00_1,0) - coalesce(sp2_99_1,0),
	sp2pdv_16_1 = coalesce(sp2pdv_16_1,0) - coalesce(sp2pdv_11_1,0) - coalesce(sp2pdv_01_1,0)-
  		      --coalesce(sp2pdv_008_1,0)- 
                      coalesce(sp2pdv_00_1,0)	 ,
	-------
	sp1_16_5    = coalesce(sp1_16_5,0) - coalesce(sp1_11_5,0)- coalesce(sp1_01_5,0) -
                      coalesce(sp1_008_5,0) -coalesce(sp1_00_5,0) - coalesce(sp1_99_5,0),
	sp1pdv_16_5 = coalesce(sp1pdv_16_5,0) - coalesce(sp1pdv_11_5,0) - coalesce(sp1pdv_01_5,0)-
  		      coalesce(sp1pdv_008_5,0)- coalesce(sp1pdv_00_5,0)	 ,
	-------
	sp2_16_5    = coalesce(sp2_16_5,0) - coalesce(sp2_11_5,0)- coalesce(sp2_01_5,0) -
                      coalesce(sp2_008_5,0) -coalesce(sp2_00_5,0) - coalesce(sp2_99_5,0),
	sp2pdv_16_5 = coalesce(sp2pdv_16_5,0) - coalesce(sp2pdv_11_5,0) - coalesce(sp2pdv_01_5,0)-
  		      coalesce(sp2pdv_008_5,0)- coalesce(sp2pdv_00_5,0)	 ,

  	-----------------------------

	kr_e_16_1   = coalesce(kr_e_16_1,0)   - coalesce(kr_e_11_1,0) -coalesce(kr_e_01_1,0), 
	kpdv_e_16_1 = coalesce(kpdv_e_16_1,0) - coalesce(kpdv_e_11_1,0) -coalesce(kpdv_e_01_1,0), 
        

	kr_e_16_5   = coalesce(kr_e_16_5,0)   - coalesce(kr_e_11_5,0) -coalesce(kr_e_01_5,0), 
	kpdv_e_16_5 = coalesce(kpdv_e_16_5,0) - coalesce(kpdv_e_11_5,0) -coalesce(kpdv_e_01_5,0),

	-------------------
        deb_e_16_1  =  coalesce(deb_e_16_1,0) - coalesce(deb_e_11_1,0) - coalesce(deb_e_01_1,0)-
		       --coalesce(deb_e_008_1,0)- 
                       coalesce(deb_e_00_1,0) - coalesce(deb_e_99_1,0),

        dpdv_e_16_1 =  coalesce(dpdv_e_16_1,0)- coalesce(dpdv_e_11_1,0) - coalesce(dpdv_e_01_1,0)-
                       --coalesce(dpdv_e_008_1,0)-
                       coalesce(dpdv_e_00_1,0),

        deb_e_16_5  =  coalesce(deb_e_16_5,0) - coalesce(deb_e_11_5,0) - coalesce(deb_e_01_5,0) -
		       coalesce(deb_e_008_5,0)- coalesce(deb_e_00_5,0) - coalesce(deb_e_99_5,0),

        dpdv_e_16_5 =  coalesce(dpdv_e_16_5,0)-coalesce(dpdv_e_11_5,0) - coalesce(dpdv_e_01_5,0) -
                       coalesce(dpdv_e_008_5,0)-coalesce(dpdv_e_00_5,0)
	-------------------

   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;
---------------------------------------------------------------------------
 -- население, льготы и субсидии вводят из таблицы для ручного корректирования 
 ----------------------------------------------------------------
 update rep_nds2011_tbl set

    deb_b_99_4 =  m.deb_b_01,
    deb_e_99_4  =  m.deb_e_01,
    opl_99_4    =  m.opl_01,
    sp1_99_4    =  m.sp1_01,
    sp2_00_4    =  m.sp2_01

 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 4 and m.id_section = 1999
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 update rep_nds2011_tbl set

    deb_b_00_4 =  m.deb_b_01,
    dpdv_b_00_4=  m.dpdv_b_01,

    deb_e_00_4  =  m.deb_e_01,
    dpdv_e_00_4 =  m.dpdv_e_01,

    opl_00_4    =  m.opl_01,
    oplpdv_00_4 =  m.oplpdv_01,

    sp1_00_4    =  m.sp1_01,
    sp1pdv_00_4 =  m.sp1pdv_01 ,
    sp2_00_4    =  m.sp2_01,
    sp2pdv_00_4 =  m.sp2pdv_01

 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 4 and m.id_section = 2000 
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 update rep_nds2011_tbl set

    deb_b_008_4 =  m.deb_b_01,
    dpdv_b_008_4=  m.dpdv_b_01,

    deb_e_008_4  =  m.deb_e_01,
    dpdv_e_008_4 =  m.dpdv_e_01,

    opl_008_4    =  m.opl_01,
    oplpdv_008_4 =  m.oplpdv_01,

    sp1_008_4    =  m.sp1_01,
    sp1pdv_008_4 =  m.sp1pdv_01 ,
    sp2_008_4    =  m.sp2_01,
    sp2pdv_008_4 =  m.sp2pdv_01

 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 4 and m.id_section = 2001 
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 update rep_nds2011_tbl set

    deb_b_01_2  =  m.deb_b_01,
    dpdv_b_01_2 =  m.dpdv_b_01,
    kr_b_01_2   =  m.kr_b_01,
    kpdv_b_01_2 =  m.kpdv_b_01,

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

    billkt_01_2 =  m.BILLKT_01_1,
    billktpdv_01_2 = m.BILLKTPDV_01_1

 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 2 and m.id_section = 2002 
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 update rep_nds2011_tbl set

    deb_b_01_3  =  m.deb_b_01,
    dpdv_b_01_3 =  m.dpdv_b_01,
    kr_b_01_3   =  m.kr_b_01,
    kpdv_b_01_3 =  m.kpdv_b_01,

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
    billkt_01_3 =  m.BILLKT_01_1,
    billktpdv_01_3 = m.BILLKTPDV_01_1

 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 3 and m.id_section = 2002
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 update rep_nds2011_tbl set

    deb_b_01_4  =  m.deb_b_01,
    dpdv_b_01_4 =  m.dpdv_b_01,
    kr_b_01_4   =  m.kr_b_01,
    kpdv_b_01_4 =  m.kpdv_b_01,
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
    billkt_01_4 =  m.BILLKT_01_1,
    billktpdv_01_4 = m.BILLKTPDV_01_1

 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 4 and m.id_section = 2002
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;
 --------------------------------------------------------------------------------------------

 update rep_nds2011_tbl set

    deb_b_11_2  =  m.deb_b_01,
    dpdv_b_11_2 =  m.dpdv_b_01,
    kr_b_11_2   =  m.kr_b_01,
    kpdv_b_11_2 =  m.kpdv_b_01,

    deb_e_11_2  =  m.deb_e_01,
    dpdv_e_11_2 =  m.dpdv_e_01,
    kr_e_11_2   =  m.kr_e_01,
    kpdv_e_11_2 =  m.kpdv_e_01,

    kvt_11_2    =  m.kvt_01,
    dem_11_2    =  m.dem_01,
    dempdv_11_2 =  m.dempdv_01,

    opl_11_2    =  m.opl_01,
    oplpdv_11_2 =  m.oplpdv_01,

    sp1_11_2    =  m.sp1_01,
    sp1pdv_11_2 =  m.sp1pdv_01 ,
    sp2_11_2    =  m.sp2_01,
    sp2pdv_11_2 =  m.sp2pdv_01,

    billkt_11_2 =  m.BILLKT_01_1,
    billktpdv_11_2 = m.BILLKTPDV_01_1
 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 2 and m.id_section = 2011 
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


 update rep_nds2011_tbl set

    deb_b_11_3  =  m.deb_b_01,
    dpdv_b_11_3 =  m.dpdv_b_01,
    kr_b_11_3   =  m.kr_b_01,
    kpdv_b_11_3 =  m.kpdv_b_01,

    deb_e_11_3  =  m.deb_e_01,
    dpdv_e_11_3 =  m.dpdv_e_01,
    kr_e_11_3   =  m.kr_e_01,
    kpdv_e_11_3 =  m.kpdv_e_01,
    kvt_11_3    =  m.kvt_01,
    dem_11_3    =  m.dem_01,
    dempdv_11_3 =  m.dempdv_01,
    opl_11_3    =  m.opl_01,
    oplpdv_11_3 =  m.oplpdv_01,
    sp1_11_3    =  m.sp1_01,
    sp1pdv_11_3 =  m.sp1pdv_01 ,
    sp2_11_3    =  m.sp2_01,
    sp2pdv_11_3 =  m.sp2pdv_01,
    billkt_11_3 =  m.BILLKT_01_1,
    billktpdv_11_3 = m.BILLKTPDV_01_1
 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 3 and m.id_section = 2011
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;

 update rep_nds2011_tbl set

    deb_b_11_4  =  m.deb_b_01,
    dpdv_b_11_4 =  m.dpdv_b_01,
    kr_b_11_4   =  m.kr_b_01,
    kpdv_b_11_4 =  m.kpdv_b_01,
    deb_e_11_4  =  m.deb_e_01,
    dpdv_e_11_4 =  m.dpdv_e_01,
    kr_e_11_4   =  m.kr_e_01,
    kpdv_e_11_4 =  m.kpdv_e_01,
    kvt_11_4    =  m.kvt_01,
    dem_11_4    =  m.dem_01,
    dempdv_11_4 =  m.dempdv_01,
    opl_11_4    =  m.opl_01,
    oplpdv_11_4 =  m.oplpdv_01,
    sp1_11_4    =  m.sp1_01,
    sp1pdv_11_4 =  m.sp1pdv_01 ,
    sp2_11_4    =  m.sp2_01,
    sp2pdv_11_4 =  m.sp2pdv_01,
    billkt_11_4 =  m.BILLKT_01_1,
    billktpdv_11_4 = m.BILLKTPDV_01_1
 from rep_nds2011_fiz_tbl as m where m.mmgg = pmmgg and m.id_pref = ppref and m.id_grp = 4 and m.id_section = 2011
  and rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;
 --------------------------------------------------------------------------------------------

 update rep_nds2011_tbl set

	---------------
	dem_16_2    = coalesce(dem_16_2,0) - coalesce(dem_11_2,0) - coalesce(dem_01_2,0), 
	dempdv_16_2 = coalesce(dempdv_16_2,0) - coalesce(dempdv_11_2,0) - coalesce(dempdv_01_2,0), 

	dem_16_3    = coalesce(dem_16_3,0) - coalesce(dem_11_3,0) - coalesce(dem_01_3,0), 
	dempdv_16_3 = coalesce(dempdv_16_3,0) - coalesce(dempdv_11_3,0) - coalesce(dempdv_01_3,0), 

	dem_16_4    = coalesce(dem_16_4,0) - coalesce(dem_11_4,0) - coalesce(dem_01_4,0) , 
	dempdv_16_4 = coalesce(dempdv_16_4,0) - coalesce(dempdv_11_4,0) - coalesce(dempdv_01_4,0), 

	-------
	opl_16_2    = coalesce(opl_16_2,0) - coalesce(opl_11_2,0)- coalesce(opl_01_2,0), 
	oplpdv_16_2 = coalesce(oplpdv_16_2,0) - coalesce(oplpdv_11_2,0) - coalesce(oplpdv_01_2,0), 

	opl_16_3    = coalesce(opl_16_3,0) - coalesce(opl_11_3,0)- coalesce(opl_01_3,0), 
	oplpdv_16_3 = coalesce(oplpdv_16_3,0) - coalesce(oplpdv_11_3,0) - coalesce(oplpdv_01_3,0), 

	opl_16_4    = coalesce(opl_16_4,0) -  coalesce(opl_11_4,0)- coalesce(opl_01_4,0) - coalesce(opl_00_4,0) -  coalesce(opl_008_4,0) -  coalesce(opl_99_4,0)-
                       numeric_larger(coalesce(SP1_16_4,0), 
                                        coalesce(SP1_11_4,0) + coalesce(SP1_01_4,0) + 
                                        coalesce(sp1_008_4,0) + coalesce(sp1_00_4,0) + coalesce(sp1_99_4,0))-
                       numeric_larger(coalesce(SP2_16_4,0), 
                                        coalesce(SP2_11_4,0) + coalesce(SP2_01_4,0) + 
                                        coalesce(sp2_008_4,0) + coalesce(sp2_00_4,0) + coalesce(sp2_99_4,0)),
  
	oplpdv_16_4 = coalesce(oplpdv_16_4,0) - coalesce(oplpdv_11_4,0) - coalesce(oplpdv_01_4,0)- coalesce(oplpdv_00_4,0) -  coalesce(oplpdv_008_4,0) -  
                       numeric_larger(coalesce(SP1PDV_16_4,0), 
                                        coalesce(SP1PDV_11_4,0) + coalesce(SP1PDV_01_4,0) + 
                                        coalesce(SP1PDV_008_4,0) + coalesce(SP1PDV_00_4,0))-
                       numeric_larger(coalesce(SP2PDV_16_4,0), 
                                        coalesce(SP2PDV_11_4,0) + coalesce(SP2PDV_01_4,0) + 
                                        coalesce(SP2PDV_008_4,0) + coalesce(SP2PDV_00_4,0)),

        SP1_16_4    = numeric_larger(coalesce(SP1_16_4,0)  - coalesce(SP1_11_4,0)  - coalesce(SP1_01_4,0) 
                       - coalesce(sp1_008_4,0) - coalesce(sp1_00_4,0) - coalesce(sp1_99_4,0),0),

        SP1PDV_16_4    = numeric_larger(coalesce(SP1PDV_16_4,0)  - coalesce(SP1PDV_11_4,0)  - coalesce(SP1PDV_01_4,0) 
                       - coalesce(SP1PDV_008_4,0) - coalesce(SP1PDV_00_4,0),0) ,

        SP2_16_4    = numeric_larger(coalesce(SP2_16_4,0)  - coalesce(SP2_11_4,0)  - coalesce(SP2_01_4,0) 
                       - coalesce(sp2_008_4,0) - coalesce(sp2_00_4,0) - coalesce(sp2_99_4,0),0),

        SP2PDV_16_4    = numeric_larger(coalesce(SP2PDV_16_4,0)  - coalesce(SP2PDV_11_4,0)  - coalesce(SP2PDV_01_4,0) 
                       - coalesce(SP2PDV_008_4,0) - coalesce(SP2PDV_00_4,0),0) ,

	-----------------
	kr_e_16_2   = coalesce(kr_e_16_2,0)   - coalesce(kr_e_11_2,0) - coalesce(kr_e_01_2,0), 
	kpdv_e_16_2 = coalesce(kpdv_e_16_2,0) - coalesce(kpdv_e_11_2,0) - coalesce(kpdv_e_01_2,0), 

	kr_e_16_3   = coalesce(kr_e_16_3,0)   - coalesce(kr_e_11_3,0)  - coalesce(kr_e_01_3,0), 
	kpdv_e_16_3 = coalesce(kpdv_e_16_3,0) - coalesce(kpdv_e_11_3,0)  - coalesce(kr_e_01_3,0), 

	kr_e_16_4  = coalesce(kr_e_16_4,0)   - coalesce(kr_e_11_4,0) - coalesce(kr_e_01_4,0), 
	kpdv_e_16_4 = coalesce(kpdv_e_16_4,0) - coalesce(kpdv_e_11_4,0) -coalesce(kpdv_e_01_4,0), 
	------------------

        deb_e_16_2  =  coalesce(deb_e_16_2,0) - coalesce(deb_e_11_2,0) - coalesce(deb_e_01_2,0),
        dpdv_e_16_2 =  coalesce(dpdv_e_16_2,0)-coalesce(dpdv_e_11_2,0) - coalesce(dpdv_e_01_2,0),

        deb_e_16_3  =  coalesce(deb_e_16_3,0) - coalesce(deb_e_11_3,0) - coalesce(deb_e_01_3,0),
        dpdv_e_16_3 =  coalesce(dpdv_e_16_3,0)-coalesce(dpdv_e_11_3,0) - coalesce(dpdv_e_01_3,0),

        deb_e_16_4  =  coalesce(deb_e_16_4,0) - coalesce(deb_e_11_4,0) - coalesce(deb_e_01_4,0) - coalesce(deb_e_00_4,0) -  coalesce(deb_e_008_4,0)- coalesce(deb_e_99_4,0),
        dpdv_e_16_4 =  coalesce(dpdv_e_16_4,0)-coalesce(dpdv_e_11_4,0) - coalesce(dpdv_e_01_4,0)- coalesce(dpdv_e_00_4,0) - coalesce(dpdv_e_008_4,0)
	-------------------
   where rep_nds2011_tbl.mmgg = pmmgg and rep_nds2011_tbl.id_pref = ppref;


RETURN 1;
end;
$BODY$
LANGUAGE 'plpgsql';          
