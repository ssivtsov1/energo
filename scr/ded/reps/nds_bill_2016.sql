create or replace function rep_mmggbill_2016_fun(int,date) returns int
AS                                                                                              
$BODY$
declare 
  ppref alias for $1; 
  pmmgg alias for $2; 

  v int;
  r record;
  vid_pref int;

  id_rep int;
  param_mode int;
  key_name0120 varchar; 
  id_jkh int;

BEGIN

     delete from rep_nds_billkt_tbl;

     insert into rep_nds_billkt_tbl (id_section,mmgg,id_pref,id_client,billkt,billktpdv)  
     select 2016,pmmgg,ppref,ss.id_client,numeric_smaller(numeric_larger(0,obrs.b_ktval),ss.sum_val) as billkt,
                                     numeric_smaller(numeric_larger(0,obrs.b_ktval_tax),ss.sum_tax) as billktpdv
     from (
     select b.id_pref,b.id_client, sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and date_part('year',p.mmgg_pay) >=2016 
     and p.mmgg < pmmgg
     and bp.value <> 0 
     and cm.idk_work not in (0,10,99)
     and scl.id_section not in (205,208)   
     group by b.id_pref,b.id_client
     ) as ss
     join
     (select id_client,id_pref,     
       sum(b_ktval) as b_ktval , sum(b_ktval_tax) as b_ktval_tax
       from  seb_obrs_tmp as t
       join clm_client_tbl as c on (c.id = t.id_client)
       where id_pref = ppref and id_client is not null and date_part('year',hmmgg) >=2016 
       group by id_client,id_pref
     ) as obrs on (ss.id_client = obrs.id_client and ss.id_pref = obrs.id_pref);

     ----------------------

     insert into rep_nds_billkt_tbl (id_section,mmgg,id_pref,id_client,billkt,billktpdv)  
     select 2016,pmmgg,ppref,ss.id_client,ss.sum_val,ss.sum_tax
     from (
     select b.id_pref,b.id_client, sum(b.value) as sum_val, sum(b.value_tax) as sum_tax
     from acm_bill_tbl as b 
     join seb_obr_all_tmp as s on (b.id_client = s.id_client )
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and date_part('year',b.mmgg_bill) >=2016 
     and s.kr_zpmv <>0    	

     and cm.idk_work not in (0,10,99)
     and scl.id_section in (205,208)   
     group by b.id_pref,b.id_client
     ) as ss ;



     insert into rep_nds_billkt_tbl (id_section,mmgg,id_pref,id_client,billkt,billktpdv)  
     select 2011,pmmgg,ppref,ss.id_client,numeric_smaller(numeric_larger(0,obrs.b_ktval),ss.sum_val) as billkt,
                                     numeric_smaller(numeric_larger(0,obrs.b_ktval_tax),ss.sum_tax) as billktpdv
     from (
     select b.id_pref,b.id_client, sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and p.mmgg_pay >= '2011-04-01'
     and date_part('year',p.mmgg_pay) < 2016 
     and p.mmgg < pmmgg
     and bp.value <> 0 
     and cm.idk_work not in (0,10,99)
     and scl.id_section not in (205,208)   
     group by b.id_pref,b.id_client
     ) as ss
     join
     (select id_client,id_pref,     
       sum(b_ktval) as b_ktval , sum(b_ktval_tax) as b_ktval_tax
       from  seb_obrs_tmp as t
       join clm_client_tbl as c on (c.id = t.id_client)
       where id_pref = ppref and id_client is not null and date_part('year',hmmgg) <2016 and date_part('year',hmmgg) >=2011 
       group by id_client,id_pref
     ) as obrs on (ss.id_client = obrs.id_client and ss.id_pref = obrs.id_pref);




     insert into rep_nds_billkt_tbl (id_section,mmgg,id_pref,id_client,billkt,billktpdv)  
     select 2011,pmmgg,ppref,ss.id_client,ss.sum_val,ss.sum_tax
     from (
     select b.id_pref,b.id_client, sum(b.value) as sum_val, sum(b.value_tax) as sum_tax
     from acm_bill_tbl as b 
     join seb_obr_all_tmp as s on (b.id_client = s.id_client )
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref

     and b.mmgg_bill >= '2011-04-01'
     and date_part('year',b.mmgg_bill) < 2016 

     and s.kr_zpmv <>0    	

     and cm.idk_work not in (0,10,99)
     and scl.id_section in (205,208)   
     group by b.id_pref,b.id_client
     ) as ss ;


       /*
     insert into rep_nds_billkt_tbl (id_section,mmgg,id_pref,id_client,billkt,billktpdv)  
     select 2001,pmmgg,ppref,ss.id_client, numeric_smaller(numeric_larger(0,obrs.b_ktval),ss.sum_val) as billkt,
                                     numeric_smaller(numeric_larger(0,obrs.b_ktval_tax),ss.sum_tax) as billktpdv
     from (
     select b.id_pref,b.id_client, sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and p.mmgg_pay < '2011-04-01'
     and date_part('year',p.mmgg_pay) >= 2001 
     and p.mmgg < pmmgg
     and bp.value <> 0 
     and cm.idk_work not in (0,10,99)
     group by b.id_pref,b.id_client
     ) as ss
     join
     (select id_client,id_pref,     
       sum(b_ktval) as b_ktval , sum(b_ktval_tax) as b_ktval_tax
       from  seb_obrs_tmp as t
       join clm_client_tbl as c on (c.id = t.id_client)
       where id_pref = ppref and id_client is not null and date_part('year',hmmgg) <2016 and date_part('year',hmmgg) >=2011 
       group by id_client,id_pref
     ) as obrs on (ss.id_client = obrs.id_client and ss.id_pref = obrs.id_pref);
         */
     -------------------------------------------------------------------------
     delete from rep_nds_bill_tbl;

     insert into rep_nds_bill_tbl (id_section,mmgg,id_pref,id_client,summ_bill,summ_pdv)  
     select 2001,pmmgg,ss.id_pref,ss.id_client, 
        CASE WHEN coalesce(ss.sum_order,0) <>0 THEN 
	  ss.sum_order ELSE coalesce(ss.sum_minus,0)+ coalesce(kt.billkt,0) END, 
	CASE WHEN coalesce(ss.sum_tax_order,0) <>0 THEN 
	  ss.sum_tax_order ELSE coalesce(ss.sum_tax_minus,0)+ coalesce(kt.billktpdv,0) END 
     from (
     select b.id_pref,b.id_client, 
     sum(CASE WHEN b.mmgg_bill < '2011-04-01' and date_part('year',b.mmgg_bill) >= 2001 and b.value<0 THEN b.value ELSE 0 END ) as sum_minus, 
     sum(CASE WHEN b.mmgg_bill < '2011-04-01' and date_part('year',b.mmgg_bill) >= 2001 and b.value_tax<0 THEN b.value_tax  ELSE 0 END ) as sum_tax_minus, 
     sum(CASE WHEN b.mmgg_bill < '2011-04-01' and date_part('year',b.mmgg_bill) >= 2001 and cm.order_pay = 1 THEN b.value  ELSE 0 END ) as sum_order, 
     sum(CASE WHEN b.mmgg_bill < '2011-04-01' and date_part('year',b.mmgg_bill) >= 2001 and cm.order_pay = 1 THEN b.value_tax  ELSE 0 END ) as sum_tax_order 
     from acm_bill_tbl as b 
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and cm.idk_work not in (0,10,99)
     group by b.id_pref,b.id_client
     ) as ss
     left join rep_nds_billkt_tbl as kt on (kt.id_client = ss.id_client and kt.mmgg = pmmgg and kt.id_pref = ppref and kt.id_section = 2001 );



     insert into rep_nds_bill_tbl (id_section,mmgg,id_pref,id_client,summ_bill,summ_pdv)  
     select 2011,pmmgg,ss.id_pref,ss.id_client, 
        CASE WHEN coalesce(ss.sum_order,0) <>0 THEN 
	  ss.sum_order ELSE coalesce(ss.sum_minus,0)+ coalesce(kt.billkt,0) END, 
	CASE WHEN coalesce(ss.sum_tax_order,0) <>0 THEN 
	  ss.sum_tax_order ELSE coalesce(ss.sum_tax_minus,0)+ coalesce(kt.billktpdv,0) END 
     from (
     select b.id_pref,b.id_client, 
     sum(CASE WHEN b.mmgg_bill >= '2011-04-01' and date_part('year',b.mmgg_bill) < 2016 and b.value<0 THEN b.value ELSE 0 END ) as sum_minus, 
     sum(CASE WHEN b.mmgg_bill >= '2011-04-01' and date_part('year',b.mmgg_bill) < 2016 and b.value_tax<0 THEN b.value_tax  ELSE 0 END ) as sum_tax_minus, 
     sum(CASE WHEN b.mmgg_bill >= '2011-04-01' and date_part('year',b.mmgg_bill) < 2016 and cm.order_pay = 1 THEN b.value  ELSE 0 END ) as sum_order, 
     sum(CASE WHEN b.mmgg_bill >= '2011-04-01' and date_part('year',b.mmgg_bill) < 2016 and cm.order_pay = 1 THEN b.value_tax  ELSE 0 END ) as sum_tax_order 
     from acm_bill_tbl as b 
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and cm.idk_work not in (0,10,99)
     group by b.id_pref,b.id_client
     ) as ss
     left join rep_nds_billkt_tbl as kt on (kt.id_client = ss.id_client and kt.mmgg = pmmgg and kt.id_pref = ppref and kt.id_section = 2011 );

/*

     insert into rep_nds_bill_tbl (id_section,mmgg,id_pref,id_client,summ_bill,summ_pdv)  
     select 2016,ss.id_client,ss.id_pref, ss.sum_bill - coalesce(bb.summ_old,0), 
					  ss.sum_pdv  - coalesce(bb.summ_pdv_old,0) 
     from (
     select b.id_pref,b.id_client, 
     sum(b.value ) as sum_bill, 
     sum(b.value_tax) as sum_pdv 
     from acm_bill_tbl as b 
     join clm_client_tbl as cm on (cm.id = b.id_client)
     join clm_statecl_tbl as scl on (b.id_client=scl.id_client)
     where cm.book = -1 
     and b.mmgg=pmmgg 
     and b.id_pref = ppref
     and cm.idk_work not in (0,10,99)
     group by b.id_pref,b.id_client
     ) as ss
     left join 
     ( select mmgg,id_pref,id_client, sum(summ_bill) as summ_old ,sum(summ_pdv) as summ_pdv_old
       from rep_nds_bill_tbl where mmgg=pmmgg  and id_pref = ppref and id_section in(2011,2001)
       group by mmgg,id_pref,id_client
     ) as bb on (bb.id_client = ss.id_client and bb.mmgg = pmmgg and bb.id_pref = ppref );

*/

RETURN 0;                      
end;
$BODY$                                                                                               
LANGUAGE 'plpgsql';          
