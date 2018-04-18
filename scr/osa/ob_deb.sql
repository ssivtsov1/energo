select ss.id_client, ss.db, ss.kb,ss.kb_now, ss.kbold,ss.db99,ss.db00,ss.db01,ss.db02,ss.db03,ss.db04,ss.db05,ss.db06,ss.db07, ss.db08, 
     ss.sumbill,ss.bill_date,ss.transmis_date,ss.pay_all,ss.pay_date, stcl.phone,  
     calend_dt_inc(coalesce(ss.transmis_date,ss.bill_date)::date,stcl.day_pay_bill) as last_date, stcl.phone||coalesce(pos_phones,'') as phones,  
     ss.dk99,ss.dk00,ss.dk01,ss.dk02,ss.dk03,ss.dk04,ss.dk05,  
     CASE WHEN ss.dk06 >0  THEN ss.dk06 ELSE 0 END as dk06,  
     CASE WHEN ss.dk07 >0  THEN ss.dk07 ELSE 0 END as dk07,  
     CASE WHEN ss.dk08 >0  THEN ss.dk08 ELSE 0 END as dk08,  
     ss.kk_now, ss.kkold, ss.kk_now + ss.kkold as kk ,  
     CASE WHEN (ss.dk99+ss.dk00+ss.dk01+ss.dk02+ss.dk03+ss.dk04+ss.dk05+ss.dk06+ss.dk07+ss.dk08) >0 THEN (ss.dk99+ss.dk00+ss.dk01+ss.dk02+ss.dk03+ss.dk04+ss.dk05+ss.dk06+ss.dk07+ss.dk08) ELSE 0 END as dk,  
     cl.code, cl.short_name, CASE WHEN coalesce(stcl.id_section,0) =0 THEN 216 ELSE stcl.id_section END as link, ssw.status,ssw.comment,cp.represent_name  
     from  
    ( select coalesce(s.id_client, bill.id_client, pay.id_client) as id_client,  
     coalesce(s.deb_k,0) as db, coalesce(s.kr_zkmv,0) as kb, kr_zkmv_now as kb_now, kr_zkmv_old as kbold,  
     coalesce(s.deb99_k,0) as db99,coalesce(s.deb00_k,0) as db00, coalesce(s.deb01_k,0) as db01,  
     coalesce(s.deb02_k,0) as db02, coalesce(s.deb03_k,0) as db03, coalesce(s.deb04_k,0) as db04, 
     coalesce(s.deb05_k,0) as db05, coalesce(s.deb06_k,0) as db06, coalesce(s.deb07_k,0) as db07, 
     coalesce(s.deb08_k,0) as db08, 
     coalesce(bill.sumbill,0) AS sumbill, bill.reg_date as bill_date, bill.transmis_date, 
     coalesce(pay.pay_all,0) AS pay_all, pay.reg_date as pay_date,  
     coalesce(s.deb99_k,0) - coalesce(pay.pay99,0) + coalesce(bill.sumbill99,0) as dk99,  
     coalesce(s.deb00_k,0) - coalesce(pay.pay00,0) + coalesce(bill.sumbill00,0) as dk00,  
     coalesce(s.deb01_k,0) - coalesce(pay.pay01,0) + coalesce(bill.sumbill01,0) as dk01,  
     coalesce(s.deb02_k,0) - coalesce(pay.pay02,0) + coalesce(bill.sumbill02,0) as dk02,  
     coalesce(s.deb03_k,0) - coalesce(pay.pay03,0) + coalesce(bill.sumbill03,0) as dk03,  
     coalesce(s.deb04_k,0) - coalesce(pay.pay04,0) + coalesce(bill.sumbill04,0) as dk04,  
     coalesce(s.deb05_k,0) - coalesce(pay.pay05,0) + coalesce(bill.sumbill05,0) as dk05,  
     (coalesce(s.deb06_k,0) - coalesce(pay.pay06,0) + coalesce(bill.sumbill06,0) )  as dk06,  
     (coalesce(s.deb07_k,0) - coalesce(pay.pay07,0) + coalesce(bill.sumbill07,0) - coalesce(s.kr_old_pos,0) ) as dk07,  
    (coalesce(s.deb08_k,0) - coalesce(pay.pay08,0) + coalesce(bill.sumbill08,0) - coalesce(s.kr_zkmv_now,0) ) as dk08,  
     numeric_larger(coalesce(s.kr_zkmv_now,0) + coalesce(pay.pay08,0) - coalesce(bill.sumbill08,0) - coalesce(s.deb08_k,0),0 ) as kk_now,  
     CASE WHEN (kr_zkmv_old <0 ) and (coalesce(pay.pay07,0) < -coalesce(kr_zkmv_old,0)) THEN coalesce(s.kr_zkmv_old,0) + coalesce(pay.pay07,0)  
     ELSE numeric_larger(coalesce(s.kr_zkmv_old,0) + coalesce(pay.pay07,0) - coalesce(bill.sumbill07,0) - coalesce(s.deb07_k,0),0 ) END as kkold  
     from  
     (select obr.id_client,  
     -deb_kmv as deb_k,kr_zkmv as kr_zkmv, - deb_km99v as deb99_k ,- deb_km00v as deb00_k, - deb_km01v as deb01_k,- deb_km02v as  deb02_k,  
     -deb_km03v  as deb03_k,- deb_km04v as deb04_k,  
     -deb_km05v as deb05_k, - deb_km06v as deb06_k, - deb_km07v as deb07_k,- deb_km08v as deb08_k, 
     e_kred+e_kred_tax as kr_zkmv_now, kr_zkmv - (e_kred+e_kred_tax) as kr_zkmv_old,  
     CASE WHEN kr_zkmv > (e_kred+e_kred_tax) THEN kr_zkmv - (e_kred+e_kred_tax) ELSE 0 END as kr_old_pos  
     from seb_obr_all_tbl as obr  
     where obr.period = date_trunc('month', '2008-01-01'::date)- '1 month'::interval and obr.id_pref = :pref  )as s  
     full outer join  
     ( select b.id_client,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 1999 THEN b.value+b.value_tax ELSE 0 END) as sumbill99,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2000 THEN b.value+b.value_tax ELSE 0 END) as sumbill00,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2001 THEN b.value+b.value_tax ELSE 0 END) as sumbill01,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2002 THEN b.value+b.value_tax ELSE 0 END) as sumbill02,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2003 THEN b.value+b.value_tax ELSE 0 END) as sumbill03,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2004 THEN b.value+b.value_tax ELSE 0 END) as sumbill04,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2005 THEN b.value+b.value_tax ELSE 0 END) as sumbill05,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2006 THEN b.value+b.value_tax ELSE 0 END) as sumbill06,  
       sum(CASE WHEN date_part('year',b.mmgg_bill) = 2007 THEN b.value+b.value_tax ELSE 0 END) as sumbill07,  
          sum(CASE WHEN date_part('year',b.mmgg_bill) = 2008 THEN b.value+b.value_tax ELSE 0 END) as sumbill08,  
          sum(b.value+b.value_tax) as sumbill,  
       max(b.date_transmis) as transmis_date, max(b.reg_date) as reg_date   
     from acm_bill_tbl as b  
      left join clm_client_tbl as c on (c.id= b.id_client)  
      where b.mmgg = date_trunc('month', '2008-01-01'::date) and b.reg_date <= '2008-01-31'::date  
      and b.id_pref = 10 and c.book = -1 and c.idk_work not in (0,99) and b.idk_doc <> 201 group by b.id_client) as bill using (id_client)  
     full outer join  
     (select p.id_client, max(p.reg_date) as reg_date,  sum(p.value_pay) as pay_all,   
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 1999 THEN p.value_pay ELSE 0 END) as pay99,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2000 THEN p.value_pay ELSE 0 END) as pay00,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2001 THEN p.value_pay ELSE 0 END) as pay01,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2002 THEN p.value_pay ELSE 0 END) as pay02,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2003 THEN p.value_pay ELSE 0 END) as pay03,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2004 THEN p.value_pay ELSE 0 END) as pay04,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2005 THEN p.value_pay ELSE 0 END) as pay05,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2006 THEN p.value_pay ELSE 0 END) as pay06, 
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2007 THEN p.value_pay ELSE 0 END) as pay07,  
      sum(CASE WHEN date_part('year',p.mmgg_pay) = 2008 THEN p.value_pay ELSE 0 END) as pay08  
      from acm_pay_tbl as p left join clm_client_tbl as c on (c.id= p.id_client)  
       where p.reg_date <= '2008-01-31' and (date_trunc('month', '2008-01-01'::date) = date_trunc('month', p.reg_date))   
       and p.id_pref = 10 and c.book = -1 and p.sign_pay = 1 group by p.id_client ) as pay using (id_client) )as ss  
     join clm_client_tbl as cl on (cl.id = ss.id_client)  
     join clm_statecl_tbl as stcl on (cl.id = stcl.id_client)  
     left join clm_position_tbl as cp on (stcl.id_position=cp.id)  
     left join (select id_client, sum(','||phone) as pos_phones from clm_position_tbl where coalesce(phone,'')<>'' group by id_client ) as phones on (cl.id = phones.id_client)  
     left join  
      ( select csw.id_client,  csw.dt_action,  csw.action, csw.comment,   
       case when csw.action =1 then 'В_дключений '||to_char(csw.dt_action, 'DD.MM.YYYY') when csw.action =2 then 'Попереджений '||to_char(csw.dt_action, 'DD.MM.YYYY') end as status  
       from clm_switching_tbl as csw  
       join (select id_client, max(dt_action) as maxdt from clm_switching_tbl  group by id_client) as csdt  
       on (csw.id_client = csdt.id_client and csw.dt_action = csdt.maxdt)  
       left join clm_switching_tbl as cswc on (csw.id_client = cswc.id_client and csw.dt_action = cswc.dt_action and cswc.action in (3,4))  
       where csw.action not in (3,4) and cswc.id_client is null  
      ) as ssw on (cl.id = ssw.id_client)  
     where cl.idk_work not in (0,99)     
order by cl.code ;
