;
set client_encoding = 'win';


CREATE TABLE rep_periods_corr_tmp
( id_client int4,
  id_pref int4,
  mmgg date,
  hperiod int,
  b_dtval numeric(14,4),
  b_dtval_tax numeric(14,4),
  b_ktval numeric(14,4),
  b_ktval_tax numeric(14,4),

  dtval numeric(14,4),
  dtval_tax numeric(14,4),

  ktval numeric(14,4),
  ktval_tax numeric(14,4),

  dtval_kt numeric(14,4),
  dtval_kt_tax numeric(14,4),

  ktval_kt numeric(14,4),
  ktval_kt_tax numeric(14,4),

  e_dtval numeric(14,4),
  e_dtval_tax numeric(14,4),
  e_ktval numeric(14,4),
  e_ktval_tax numeric(14,4),
  sp1 numeric(14,2),
  sp1_tax numeric(14,2), 
  sp2 numeric(14,2),
  sp2_tax numeric(14,2), 
  primary key (id_client,id_pref,mmgg,hperiod)
) ;


CREATE OR REPLACE FUNCTION rep_periods_saldo_ae_fun(date, integer, integer)
  RETURNS boolean AS
$BODY$
declare 
 pmmgg alias for $1;
 pid_pref  alias for $2;
 pid_client alias for $3;

 r record;
 r_15 record;
 r_16 record;

 vdelta numeric;
 vdelta_tax numeric;
  
begin

-----------------------------------------------------------------------------------------------
perform seb_all( 0, pmmgg);

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

-----------------------------------------------------------------------------------------------
raise notice 'delete from ;';
delete from rep_periods_saldo_tmp where mmgg = pmmgg and id_pref = pid_pref;
delete from rep_periods_bad_tmp;
raise notice 'insert into ';


--if pmmgg ='2016-03-01'::date then

       /*
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2016 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  --where not exists (select * from seb_saldo_tmp as s where ss.id_client = s.id_client and  ss.id_pref = s.id_pref and ss.mmgg = s.mmgg and ss.hmmgg = s.hmmgg);
  ; */

  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  
   b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax,  dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, 
   e_dtval, e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2016 , b_dt, b_dttax, b_kt, b_kttax, 0,0,0,0,0,0,0,0, e_dt, e_dttax, e_kt, e_kttax
  from
  (
     select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,
                       sum(b_ktval) as b_kt, sum(b_ktval_tax) as b_kttax,
                       sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax,   
                       sum(e_ktval) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = pid_pref  
     and date_part('year',hmmgg) >=2016 
     group by id_client
  ) as ss ;


  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  
   b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax,  dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, 
   e_dtval, e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2015 , b_dt, b_dttax, b_kt, b_kttax, 0,0,0,0,0,0,0,0, e_dt, e_dttax, e_kt, e_kttax
  from
  (
     select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,
                       sum(b_ktval) as b_kt, sum(b_ktval_tax) as b_kttax,
                       sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax,   
                       sum(e_ktval) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = pid_pref  
     and date_part('year',hmmgg) in (2011,2012,2013,2014,2015) 
     group by id_client
  ) as ss ;

  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  
   b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax,  dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, 
   e_dtval, e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2011 , b_dt, b_dttax, b_kt, b_kttax, 0,0,0,0,0,0,0,0, e_dt, e_dttax, e_kt, e_kttax
  from
  (
     select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,
                       sum(b_ktval) as b_kt, sum(b_ktval_tax) as b_kttax,
                       sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax,   
                       sum(e_ktval) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = pid_pref  
     and date_part('year',hmmgg) in (2002,2003,2004,2005,2006,2007,2008,2009,2010) 
     group by id_client
  ) as ss ;


  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  
   b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax,  dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, 
   e_dtval, e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2001 , b_dt, b_dttax, b_kt, b_kttax, 0,0,0,0,0,0,0,0, e_dt, e_dttax, e_kt, e_kttax
  from
  (
     select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,
                       sum(b_ktval) as b_kt, sum(b_ktval_tax) as b_kttax,
                       sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax,   
                       sum(e_ktval) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = pid_pref  
     and date_part('year',hmmgg) in (2001) 
     group by id_client
  ) as ss  ;

  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  
   b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax,  dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, 
   e_dtval, e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2000 , b_dt, b_dttax, b_kt, b_kttax, 0,0,0,0,0,0,0,0, e_dt, e_dttax, e_kt, e_kttax
  from
  (
     select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,
                       sum(b_ktval) as b_kt, sum(b_ktval_tax) as b_kttax,
                       sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax,   
                       sum(e_ktval) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = pid_pref  
     and date_part('year',hmmgg) in (2000) 
     group by id_client
  ) as ss ;

  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  
   b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax,  dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, 
   e_dtval, e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 1999 , b_dt, b_dttax, b_kt, b_kttax, 0,0,0,0,0,0,0,0, e_dt, e_dttax, e_kt, e_kttax
  from
  (
     select id_client, sum(b_dtval) as b_dt, sum(b_dtval_tax) as b_dttax,
                       sum(b_ktval) as b_kt, sum(b_ktval_tax) as b_kttax,
                       sum(e_dtval) as e_dt, sum(e_dtval_tax) as e_dttax,   
                       sum(e_ktval) as e_kt, sum(e_ktval_tax) as e_kttax   
     from seb_obrs_tmp 
     where  id_client is not null and id_pref = pid_pref  
     and date_part('year',hmmgg) in (1999) 
     group by id_client
  ) as ss ;

-- empty rows 
  --2016
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2016 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client 
  and  s.id_pref=pid_pref  and s.mmgg = pmmgg and s.hperiod  =2016 );
 
  --2015
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2015 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client 
  and  s.id_pref=pid_pref  and s.mmgg = pmmgg and s.hperiod  =2015 );

  --2011
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2011 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client 
  and  s.id_pref=pid_pref  and s.mmgg = pmmgg and s.hperiod  =2011 );

  --2001
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2001 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client 
  and  s.id_pref=pid_pref  and s.mmgg = pmmgg and s.hperiod  =2001 );

  --2000
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2000 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client 
  and  s.id_pref=pid_pref  and s.mmgg = pmmgg and s.hperiod  =2000 );

  --1999
  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 1999 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client 
  and  s.id_pref=pid_pref  and s.mmgg = pmmgg and s.hperiod  =1999 );

--else 


--  insert into rep_periods_saldo_tmp   
--  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
--   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
--            e_dtval_tax, e_ktval, e_ktval_tax )
--  select 
--   id_client ,  id_pref ,  pmmgg ,   hperiod ,  e_dtval ,  e_dtval_tax ,  e_ktval ,  e_ktval_tax,
--   0,0,0,0,0,0,0,0,0,0,0,0
--   from rep_periods_saldo_tmp where id_pref = pid_pref and mmgg = (pmmgg::date - '1 month'::interval)::date;
 
--end if;

-----------------------------------------------------------------------------------------------------
--return false;

raise notice 'bill 1;';
-- 2016
update rep_periods_saldo_tmp set dtval=coalesce(value,0) , dtval_tax= coalesce(value_tax,0) 
 from (select b.id_client,  sum(b.value - coalesce(bp.value,0)) as value,  sum(b.value_tax - coalesce(bp.value_tax,0)) as value_tax
      from acm_bill_tbl b 
      left join 
          (select bp.id_bill,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where p.mmgg <pmmgg and b.mmgg =pmmgg  and p.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_bill
          ) as bp on (b.id_doc=bp.id_bill)
      where 
         b.mmgg=pmmgg and b.id_pref = pid_pref
         and b.mmgg_bill >= '2016-01-01' 
      group by b.id_client ) as deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2016;


--2015
update rep_periods_saldo_tmp set dtval=coalesce(value,0) , dtval_tax= coalesce(value_tax,0) 
 from (select b.id_client,  sum(b.value - coalesce(bp.value,0)) as value,  sum(b.value_tax - coalesce(bp.value_tax,0)) as value_tax
      from acm_bill_tbl b 
      left join 
          (select bp.id_bill,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where p.mmgg <pmmgg and b.mmgg =pmmgg  and p.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_bill
          ) as bp on (b.id_doc=bp.id_bill)
      where 
         b.mmgg=pmmgg and b.id_pref = pid_pref
         and b.mmgg_bill < '2016-01-01' and  b.mmgg_bill >= '2011-04-01'
      group by b.id_client ) as deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2015;

--2011
update rep_periods_saldo_tmp set dtval=coalesce(value,0) , dtval_tax= coalesce(value_tax,0) 
 from (select b.id_client,  sum(b.value - coalesce(bp.value,0)) as value,  sum(b.value_tax - coalesce(bp.value_tax,0)) as value_tax
      from acm_bill_tbl b 
      left join 
          (select bp.id_bill,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where p.mmgg <pmmgg and b.mmgg =pmmgg  and p.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_bill
          ) as bp on (b.id_doc=bp.id_bill)
      where 
         b.mmgg=pmmgg and b.id_pref = pid_pref
         and  b.mmgg_bill < '2011-04-01' and  b.mmgg_bill >= '2001-08-01'
      group by b.id_client ) as deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2011;

-- на эти периоды счета не должны ложитьс€, но пусть будет на вс€кий случай
--2001
update rep_periods_saldo_tmp set dtval=coalesce(value,0) , dtval_tax= coalesce(value_tax,0) 
 from (select b.id_client,  sum(b.value - coalesce(bp.value,0)) as value,  sum(b.value_tax - coalesce(bp.value_tax,0)) as value_tax
      from acm_bill_tbl b 
      left join 
          (select bp.id_bill,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where p.mmgg <pmmgg and b.mmgg =pmmgg  and p.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_bill
          ) as bp on (b.id_doc=bp.id_bill)
      where 
         b.mmgg=pmmgg and b.id_pref = pid_pref
         and  b.mmgg_bill < '2001-08-01' and  b.mmgg_bill >= '2001-01-01'
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2001;

--2000
update rep_periods_saldo_tmp set dtval=coalesce(value,0) , dtval_tax= coalesce(value_tax,0) 
 from (select b.id_client,  sum(b.value - coalesce(bp.value,0)) as value,  sum(b.value_tax - coalesce(bp.value_tax,0)) as value_tax
      from acm_bill_tbl b 
      left join 
          (select bp.id_bill,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where p.mmgg <pmmgg and b.mmgg =pmmgg  and p.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_bill
          ) as bp on (b.id_doc=bp.id_bill)
      where 
         b.mmgg=pmmgg and b.id_pref = pid_pref
         and  b.mmgg_bill <= '2000-12-01' and  b.mmgg_bill >= '2000-01-01'
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2000;

--1999
update rep_periods_saldo_tmp set dtval=coalesce(value,0) , dtval_tax= coalesce(value_tax,0) 
 from (select b.id_client,  sum(b.value - coalesce(bp.value,0)) as value,  sum(b.value_tax - coalesce(bp.value_tax,0)) as value_tax
      from acm_bill_tbl b 
      left join 
          (select bp.id_bill,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where p.mmgg <pmmgg and b.mmgg =pmmgg  and p.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_bill
          ) as bp on (b.id_doc=bp.id_bill)
      where 
         b.mmgg=pmmgg and b.id_pref = pid_pref
         and  b.mmgg_bill <= '1999-12-01' and  b.mmgg_bill >= '1999-01-01'
      group by b.id_client ) deb

      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 1999;

raise notice 'bill 2;';
-- 2016
-- счета, погашенные платежками прошлого периода (то есть кредитом)
update rep_periods_saldo_tmp set dtval_kt=coalesce(value,0) , dtval_kt_tax= coalesce(value_tax,0)  
 from (select b.id_client, sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_bill_tbl as b 
      join clm_client_tbl as cm on (cm.id = b.id_client)      
      join acm_billpay_tbl bp on (b.id_doc=bp.id_bill)
      join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
      where 
         b.mmgg=pmmgg and p.mmgg < pmmgg and b.id_pref = pid_pref and p.id_pref = pid_pref and bp.mmgg =pmmgg 
         and ((p.mmgg_pay >= '2016-01-01') or (p.mmgg >= '2016-01-01') and (cm.order_pay = 0) )
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2016;

-- 2015
update rep_periods_saldo_tmp set dtval_kt=coalesce(value,0) , dtval_kt_tax= coalesce(value_tax,0)  
 from (select b.id_client, sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_bill_tbl as b 
      join clm_client_tbl as cm on (cm.id = b.id_client)      
      join acm_billpay_tbl bp on (b.id_doc=bp.id_bill)
      join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
      where 
         b.mmgg=pmmgg and p.mmgg < pmmgg and b.id_pref = pid_pref and p.id_pref = pid_pref and bp.mmgg =pmmgg 
         and p.mmgg_pay < '2016-01-01' and  p.mmgg_pay >= '2011-04-01' and 
           ((p.mmgg < '2016-01-01' and  p.mmgg >= '2011-04-01') or  cm.order_pay = 1 )
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2015;

-- 2011
update rep_periods_saldo_tmp set dtval_kt=coalesce(value,0) , dtval_kt_tax= coalesce(value_tax,0)  
 from (select b.id_client, sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_bill_tbl as b 
      join clm_client_tbl as cm on (cm.id = b.id_client)      
      join acm_billpay_tbl bp on (b.id_doc=bp.id_bill)
      join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
      where 
         b.mmgg=pmmgg and p.mmgg < pmmgg and b.id_pref = pid_pref and p.id_pref = pid_pref and bp.mmgg =pmmgg 
         and p.mmgg_pay < '2011-04-01' and p.mmgg_pay >= '2001-08-01' 
         --  and  ((p.mmgg < '2011-04-01' and p.mmgg >= '2001-08-01') or cm.order_pay = 1 )
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2011;

/*
-- 2001
update rep_periods_saldo_tmp set dtval_kt=coalesce(value,0) , dtval_kt_tax= coalesce(value_tax,0)  
 from (select b.id_client, sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_bill_tbl as b 
      join clm_client_tbl as cm on (cm.id = b.id_client)      
      join acm_billpay_tbl bp on (b.id_doc=bp.id_bill)
      join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
      where 
         b.mmgg=pmmgg and p.mmgg < pmmgg and b.id_pref = pid_pref and p.id_pref = pid_pref and bp.mmgg =pmmgg 

         and p.mmgg_pay < '2001-08-01' and p.mmgg_pay >= '2001-01-01' and
           ((p.mmgg < '2001-08-01' and p.mmgg >= '2001-01-01') or cm.order_pay = 1 )
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2001;

-- 2000
update rep_periods_saldo_tmp set dtval_kt=coalesce(value,0) , dtval_kt_tax= coalesce(value_tax,0)  
 from (select b.id_client, sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_bill_tbl as b 
      join clm_client_tbl as cm on (cm.id = b.id_client)      
      join acm_billpay_tbl bp on (b.id_doc=bp.id_bill)
      join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
      where 
         b.mmgg=pmmgg and p.mmgg < pmmgg and b.id_pref = pid_pref and p.id_pref = pid_pref and bp.mmgg =pmmgg 

         and p.mmgg_pay <= '2000-12-01' and p.mmgg_pay >= '2000-01-01' and
           ((p.mmgg <= '2000-12-01' and p.mmgg >= '2000-01-01') or cm.order_pay = 1 )
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2000;

-- 1999
update rep_periods_saldo_tmp set dtval_kt=coalesce(value,0) , dtval_kt_tax= coalesce(value_tax,0)  
 from (select b.id_client, sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_bill_tbl as b 
      join clm_client_tbl as cm on (cm.id = b.id_client)      
      join acm_billpay_tbl bp on (b.id_doc=bp.id_bill)
      join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
      where 
         b.mmgg=pmmgg and p.mmgg < pmmgg and b.id_pref = pid_pref and p.id_pref = pid_pref and bp.mmgg =pmmgg 

         and p.mmgg_pay <= '1999-12-01' and p.mmgg_pay >= '1999-01-01' and
           ((p.mmgg <= '1999-12-01' and p.mmgg >= '1999-01-01') or cm.order_pay = 1 )
      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 1999;
*/
------------------------------------------------------------------------------------------------
raise notice 'pay 1;';
--2016
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 

 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      left join 
          (select bp.id_pay,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where b.mmgg <=pmmgg and p.mmgg =pmmgg and b.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_pay
          ) as bp on (p.id_doc=bp.id_pay)
      where 
             p.mmgg=pmmgg and p.id_pref = pid_pref -- and p.value >0
             and d.ident not in ('writeoff','trush') 
             and ((p.mmgg_pay >= '2016-01-01') or (p.mmgg >= '2016-01-01') and (cm.order_pay = 0) and (p.mmgg_pay >= '2011-04-01') )
      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2016;

--2015
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 

 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      left join 
          (select bp.id_pay,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where b.mmgg <=pmmgg and p.mmgg =pmmgg and b.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_pay
          ) as bp on (p.id_doc=bp.id_pay)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref -- and p.value >0
            and d.ident not in ('writeoff','trush') 
            and p.mmgg_pay < '2016-01-01' and  p.mmgg_pay >= '2011-04-01' and 
            ((p.mmgg < '2016-01-01' and  p.mmgg >= '2011-04-01') or  cm.order_pay = 1 )
      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2015;

--2011
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 

 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      left join 
          (select bp.id_pay,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where b.mmgg <=pmmgg and p.mmgg =pmmgg and b.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_pay
          ) as bp on (p.id_doc=bp.id_pay)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref -- and p.value >0
            and d.ident not in ('writeoff','trush') 
            and p.mmgg_pay < '2011-04-01' and p.mmgg_pay >= '2001-08-01'
      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2011;

--2001
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 
 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      left join 
          (select bp.id_pay,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where b.mmgg <=pmmgg and p.mmgg =pmmgg and b.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_pay
          ) as bp on (p.id_doc=bp.id_pay)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref -- and p.value >0
            and d.ident not in ('writeoff','trush') 
            and p.mmgg_pay < '2001-08-01' and p.mmgg_pay >= '2001-01-01' 
      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2001;

--2000
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 
 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      left join 
          (select bp.id_pay,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where b.mmgg <=pmmgg and p.mmgg =pmmgg and b.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_pay
          ) as bp on (p.id_doc=bp.id_pay)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref -- and p.value >0
            and d.ident not in ('writeoff','trush') 
            and p.mmgg_pay <= '2000-12-01' and p.mmgg_pay >= '2000-01-01' 
      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2000;

--1999
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 
 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      left join 
          (select bp.id_pay,sum(bp.value) as value, sum(bp.value_tax) as value_tax 
           from acm_billpay_tbl as bp 
           join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
           join acm_pay_tbl as p on (p.id_doc = bp.id_pay) 
           where b.mmgg <=pmmgg and p.mmgg =pmmgg and b.id_pref = pid_pref and bp.mmgg =pmmgg
           group by bp.id_pay
          ) as bp on (p.id_doc=bp.id_pay)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref -- and p.value >0
            and d.ident not in ('writeoff','trush') 
            and p.mmgg_pay <= '1999-12-01' and p.mmgg_pay >= '1999-01-01' 
      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 1999;


 raise notice 'pay 2;';
 --2016
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
        and b.mmgg_bill >= '2016-01-01' 
        and d.ident not in ('writeoff','trush') 
      group by p.id_client ) kred

      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2016;

--2015
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
        and b.mmgg_bill < '2016-01-01' and  b.mmgg_bill >= '2011-04-01'
        and d.ident not in ('writeoff','trush') 
      group by p.id_client ) kred
      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2015;

--2011
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
        and b.mmgg_bill < '2011-04-01' and  b.mmgg_bill >= '2001-08-01'
        and d.ident not in ('writeoff','trush') 
      group by p.id_client ) kred
      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2011;

--2001
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
         and  b.mmgg_bill < '2001-08-01' and  b.mmgg_bill >= '2001-01-01'
        and d.ident not in ('writeoff','trush') 
      group by p.id_client ) kred
      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2001;

--2000
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
         and  b.mmgg_bill <= '2000-12-01' and  b.mmgg_bill >= '2000-01-01'
        and d.ident not in ('writeoff','trush') 
      group by p.id_client ) kred
      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2000;

--1999
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
         and  b.mmgg_bill <= '1999-12-01' and  b.mmgg_bill >= '1999-01-01'
        and d.ident not in ('writeoff','trush') 
      group by p.id_client ) kred
      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 1999;

---------------------------------------------------------------------------------------
--sp
 --2016
 update rep_periods_saldo_tmp set sp1= coalesce(psp1,0) , sp1_tax= coalesce(psp1_tax,0) , 
				  sp2= coalesce(psp2,0) , sp2_tax= coalesce(psp2_tax,0)  
 from (select p.id_client,
   sum(CASE WHEN d.ident ='writeoff' THEN p.value  ELSE 0 END) as psp1 , 
   sum(CASE WHEN d.ident ='trush' THEN p.value  ELSE 0 END) as psp2,  
   sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as psp1_tax, 
   sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as psp2_tax
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref 
            and p.mmgg_pay >= '2016-01-01'
      group by p.id_client ) as sp
      where rep_periods_saldo_tmp.id_client=sp.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2016;

 --2015
 update rep_periods_saldo_tmp set sp1= coalesce(psp1,0) , sp1_tax= coalesce(psp1_tax,0) , 
				  sp2= coalesce(psp2,0) , sp2_tax= coalesce(psp2_tax,0)  
 from (select p.id_client,
   sum(CASE WHEN d.ident ='writeoff' THEN p.value  ELSE 0 END) as psp1 , 
   sum(CASE WHEN d.ident ='trush' THEN p.value  ELSE 0 END) as psp2,  
   sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as psp1_tax, 
   sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as psp2_tax
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref 
            and p.mmgg_pay < '2016-01-01' and  p.mmgg_pay >= '2011-04-01'
      group by p.id_client ) as sp
      where rep_periods_saldo_tmp.id_client=sp.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2015;

 --2011
 update rep_periods_saldo_tmp set sp1= coalesce(psp1,0) , sp1_tax= coalesce(psp1_tax,0) , 
				  sp2= coalesce(psp2,0) , sp2_tax= coalesce(psp2_tax,0)  
 from (select p.id_client,
   sum(CASE WHEN d.ident ='writeoff' THEN p.value  ELSE 0 END) as psp1 , 
   sum(CASE WHEN d.ident ='trush' THEN p.value  ELSE 0 END) as psp2,  
   sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as psp1_tax, 
   sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as psp2_tax
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref 
	    and p.mmgg_pay < '2011-04-01' and p.mmgg_pay >= '2001-08-01'
      group by p.id_client ) as sp
      where rep_periods_saldo_tmp.id_client=sp.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2011;

 --2001
 update rep_periods_saldo_tmp set sp1= coalesce(psp1,0) , sp1_tax= coalesce(psp1_tax,0) , 
				  sp2= coalesce(psp2,0) , sp2_tax= coalesce(psp2_tax,0)  
 from (select p.id_client,
   sum(CASE WHEN d.ident ='writeoff' THEN p.value  ELSE 0 END) as psp1 , 
   sum(CASE WHEN d.ident ='trush' THEN p.value  ELSE 0 END) as psp2,  
   sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as psp1_tax, 
   sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as psp2_tax
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref 
	    and p.mmgg_pay < '2001-08-01' and p.mmgg_pay >= '2001-01-01'
      group by p.id_client ) as sp
      where rep_periods_saldo_tmp.id_client=sp.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2001;

 --2000
 update rep_periods_saldo_tmp set sp1= coalesce(psp1,0) , sp1_tax= coalesce(psp1_tax,0) , 
				  sp2= coalesce(psp2,0) , sp2_tax= coalesce(psp2_tax,0)  
 from (select p.id_client,
   sum(CASE WHEN d.ident ='writeoff' THEN p.value  ELSE 0 END) as psp1 , 
   sum(CASE WHEN d.ident ='trush' THEN p.value  ELSE 0 END) as psp2,  
   sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as psp1_tax, 
   sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as psp2_tax
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref 
	    and p.mmgg_pay <= '2000-12-01' and p.mmgg_pay >= '2000-01-01'
      group by p.id_client ) as sp
      where rep_periods_saldo_tmp.id_client=sp.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2000;

 --1999
 update rep_periods_saldo_tmp set sp1= coalesce(psp1,0) ,
				  sp2= coalesce(psp2,0) 
 from (select p.id_client,
   sum(CASE WHEN d.ident ='writeoff' THEN p.value  ELSE 0 END) as psp1 , 
   sum(CASE WHEN d.ident ='trush' THEN p.value  ELSE 0 END) as psp2  
--   sum(CASE WHEN d.ident ='writeoff' THEN p.value_tax  ELSE 0 END) as sp1_tax, 
--   sum(CASE WHEN d.ident ='trush' THEN p.value_tax  ELSE 0 END) as sp2_tax
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
      join dci_document_tbl as d on (d.id = p.idk_doc)
      where 
            p.mmgg=pmmgg and p.id_pref = pid_pref 
	    and p.mmgg_pay <= '1999-12-01' and p.mmgg_pay >= '1999-01-01'
      group by p.id_client ) as sp
      where rep_periods_saldo_tmp.id_client=sp.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 1999;

---------------------------------------------------------------------------------------
-- таблица ручных корректировок

delete from rep_periods_saldo_tmp where exists 
(select id_client from rep_periods_corr_tmp as c where c.mmgg = pmmgg and c.id_pref = pid_pref 
  and c.id_client = rep_periods_saldo_tmp.id_client and c.hperiod = rep_periods_saldo_tmp.hperiod);

insert into rep_periods_saldo_tmp
select * from rep_periods_corr_tmp where mmgg = pmmgg and id_pref = pid_pref;

---------------------------------------------------------------------------------------
--старые периоды - вс€ оплата и списание гас€т дебет
update rep_periods_saldo_tmp set e_dtval    = b_dtval - ktval - ktval_kt - sp1 - sp2 
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref 
and hperiod in (1999,2000,2001);

update rep_periods_saldo_tmp set e_dtval_tax= b_dtval_tax - ktval_tax - ktval_kt_tax - sp1_tax - sp2_tax
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref
and hperiod in (1999,2000,2001);
-- кредита быть не должно
------------
update rep_periods_saldo_tmp set e_dtval    = b_dtval - ktval - sp1 - sp2 
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref 
and hperiod in (2011);

update rep_periods_saldo_tmp set e_dtval_tax= b_dtval_tax - ktval_tax - sp1_tax - sp2_tax
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref
and hperiod in (2011);


update rep_periods_saldo_tmp set e_ktval    = b_ktval - dtval_kt+ktval_kt
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref
and hperiod in (2011);

update rep_periods_saldo_tmp set e_ktval_tax= b_ktval_tax - dtval_kt_tax+ktval_kt_tax
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref
and hperiod in (2011);
---------------------------------

delete from rep_periods_saldo_tmp 
where mmgg = pmmgg  and id_pref = pid_pref
and 
 b_dtval = 0 and  b_dtval_tax=0 and  b_ktval = 0 and  b_ktval_tax =0 and  dtval =0 and dtval_tax = 0 and ktval=0 and ktval_tax=0 and
 dtval_kt =0 and dtval_kt_tax =0 and  ktval_kt =0 and ktval_kt_tax =0 and e_dtval =0 and e_dtval_tax=0 and e_ktval=0 and e_ktval_tax=0 
 and sp1 = 0 and sp1_tax = 0 and sp2 = 0 and sp2_tax = 0;

---------------------------------
for r in select id_client, 
 sum(b_dtval) as b_dtval , sum(b_dtval_tax) as b_dtval_tax,
 sum(b_ktval) as b_ktval , sum(b_ktval_tax) as b_ktval_tax,  
 sum(dtval) as dtval, sum(dtval_tax) as dtval_tax , sum(ktval) as ktval, sum(ktval_tax) as ktval_tax,
 sum(dtval_kt) as dtval_kt, sum(dtval_kt_tax) as dtval_kt_tax ,
 sum(ktval_kt) as ktval_kt, sum(ktval_kt_tax) as ktval_kt_tax,
 sum(e_dtval) as e_dtval, sum(e_dtval_tax) as e_dtval_tax, 
 sum(e_ktval) as e_ktval, sum(e_ktval_tax) as e_ktval_tax, 
 sum(sp1) as sp1, sum(sp1_tax) as sp1_tax, sum(sp2) as sp2, sum(sp2_tax) as sp2_tax
 from rep_periods_saldo_tmp as p
 where p.mmgg = pmmgg and p.id_pref = pid_pref and hperiod in (2015,2016)
 and not exists (select id_client from rep_periods_saldo_tmp as pp where pp.id_client = p.id_client 
    and pp.mmgg = pmmgg and pp.id_pref = pid_pref and pp.hperiod in (1999,2000,2001,2011)) 
 group by id_client
loop

  if ((r.b_dtval - r.b_ktval +  r.dtval + r.dtval_kt - r.ktval - r.ktval_kt - r.sp1 - r.sp2 -  r.e_dtval + r.e_ktval) <>0) or 
     ((r.b_dtval_tax - r.b_ktval_tax +  r.dtval_tax + r.dtval_kt_tax - r.ktval_tax - r.ktval_kt_tax - r.sp1_tax - r.sp2_tax -  r.e_dtval_tax + r.e_ktval_tax) <>0)
  then 
     -- не идет контроль по абоненту в целом  -пишем в ошибки и продолжаем 
     raise notice '- bed common balans for abon %',r.id_client;
     insert into rep_periods_bad_tmp 
     select s.*, 1 from rep_periods_saldo_tmp as s  where 
     s.id_client = r.id_client and s.mmgg = pmmgg and s.id_pref = pid_pref;
  else

     select into r_15 id_client, 
      b_dtval , b_dtval_tax, b_ktval , b_ktval_tax,  
      dtval, dtval_tax , ktval,  ktval_tax,
      dtval_kt,  dtval_kt_tax ,
      ktval_kt,  ktval_kt_tax,
      e_dtval, e_dtval_tax, 
      e_ktval, e_ktval_tax, 
      sp1, sp1_tax, sp2,  sp2_tax
     from rep_periods_saldo_tmp as p
     where p.mmgg = pmmgg and p.id_pref = pid_pref and hperiod =2015
     and p.id_client = r.id_client ;
     -- нет 2015 года - нечего делать
     if found then

       select into r_16 id_client, 
        b_dtval , b_dtval_tax, b_ktval , b_ktval_tax,  
        dtval, dtval_tax , ktval,  ktval_tax,
        dtval_kt,  dtval_kt_tax ,
        ktval_kt,  ktval_kt_tax,
        e_dtval, e_dtval_tax, 
        e_ktval, e_ktval_tax, 
        sp1, sp1_tax, sp2,  sp2_tax
       from rep_periods_saldo_tmp as p
       where p.mmgg = pmmgg and p.id_pref = pid_pref and hperiod =2016
       and p.id_client = r.id_client ;

       if found then

 	  vdelta:=r_16.b_dtval - r_16.b_ktval +  r_16.dtval + r_16.dtval_kt - r_16.ktval - r_16.ktval_kt - r_16.sp1 - r_16.sp2 -  r_16.e_dtval + r_16.e_ktval;
          vdelta_tax:=r_16.b_dtval_tax - r_16.b_ktval_tax +  r_16.dtval_tax + r_16.dtval_kt_tax - r_16.ktval_tax - r_16.ktval_kt_tax - r_16.sp1_tax - r_16.sp2_tax -  r_16.e_dtval_tax + r_16.e_ktval_tax;

          raise notice '- delta % for abon %',vdelta, r.id_client;
          raise notice '- delta_tax % for abon %',vdelta_tax, r.id_client;

         if (vdelta <>0 or vdelta_tax <>0)
         then 

            insert into rep_periods_bad_tmp 
            select s.*, 2 from rep_periods_saldo_tmp as s  where 
            s.id_client = r.id_client and s.mmgg = pmmgg and s.id_pref = pid_pref;

            if r_16.dtval <>0  then 

               raise notice '- - dt repair!';
               update rep_periods_saldo_tmp set dtval = dtval - vdelta , dtval_tax = dtval_tax - vdelta_tax
	       where mmgg = pmmgg and id_pref = pid_pref and hperiod =2016
	       and id_client = r.id_client ;

               update rep_periods_saldo_tmp set dtval = dtval + vdelta , dtval_tax = dtval_tax + vdelta_tax
	       where mmgg = pmmgg and id_pref = pid_pref and hperiod =2015
	       and id_client = r.id_client ;

	    else 	

               if r_16.dtval_kt <>0  then 

                  raise notice '- - dt_kt repair!';
                  update rep_periods_saldo_tmp set dtval_kt = dtval_kt - vdelta , dtval_kt_tax = dtval_kt_tax - vdelta_tax
	          where mmgg = pmmgg and id_pref = pid_pref and hperiod =2016
	          and id_client = r.id_client ;

                  update rep_periods_saldo_tmp set dtval_kt = dtval_kt + vdelta , dtval_kt_tax = dtval_kt_tax + vdelta_tax
	          where mmgg = pmmgg and id_pref = pid_pref and hperiod =2015
	          and id_client = r.id_client ;

	       else
                  raise notice '- - kt repair!';
                  update rep_periods_saldo_tmp set ktval_kt = ktval_kt + vdelta , ktval_kt_tax = ktval_kt_tax + vdelta_tax
   	          where mmgg = pmmgg and id_pref = pid_pref and hperiod =2016
	          and id_client = r.id_client ;

                  update rep_periods_saldo_tmp set ktval_kt = ktval_kt - vdelta , ktval_kt_tax = ktval_kt_tax - vdelta_tax
	          where mmgg = pmmgg and id_pref = pid_pref and hperiod =2015
	         and id_client = r.id_client ;
               end if;
            end if;
      
         end if;

       end if;
     end if;

  end if;

end loop;
--------------------------------
/*
update rep_periods_saldo_tmp set e_ktval = e_ktval- e_dtval, e_ktval_tax = e_ktval_tax-e_dtval_tax, 
dtval = dtval -  e_dtval, dtval_kt = dtval_kt +e_dtval,
dtval_tax = dtval_tax -  e_dtval_tax, dtval_kt_tax = dtval_kt_tax +e_dtval_tax,
e_dtval =0, e_dtval_tax  =0 
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref and hperiod in (2015,2016) 
and ((e_dtval+e_dtval_tax)<0 )and ((e_ktval+e_ktval_tax) = 0);


update rep_periods_saldo_tmp set e_dtval = e_dtval- e_ktval, e_dtval_tax = e_dtval_tax-e_ktval_tax , 
ktval = ktval - e_ktval , ktval_kt = ktval_kt +e_ktval,
ktval_tax = ktval_tax - e_ktval_tax , ktval_kt_tax = ktval_kt_tax +e_ktval_tax,
e_ktval = 0, e_ktval_tax=0
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref and hperiod in (2015,2016) 
and ((e_dtval+e_dtval_tax)=0 )and ((e_ktval+e_ktval_tax) < 0);


update rep_periods_saldo_tmp set e_dtval = e_dtval- e_ktval, e_dtval_tax = e_dtval_tax-e_ktval_tax, 
ktval = ktval - e_ktval , ktval_kt = ktval_kt +e_ktval,
ktval_tax = ktval_tax - e_ktval_tax , ktval_kt_tax = ktval_kt_tax +e_ktval_tax,
e_ktval = 0, e_ktval_tax=0
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref and hperiod in (2015,2016) 
and ((e_dtval+e_dtval_tax)<>0 )and ((e_ktval+e_ktval_tax) <> 0) and (e_dtval+e_dtval_tax) - (e_ktval+e_ktval_tax) >=0 ;

update rep_periods_saldo_tmp set e_ktval = e_ktval- e_dtval, e_ktval_tax = e_ktval_tax-e_dtval_tax, 
dtval = dtval -  e_dtval, dtval_kt = dtval_kt +e_dtval,
dtval_tax = dtval_tax -  e_dtval_tax, dtval_kt_tax = dtval_kt_tax +e_dtval_tax,
e_dtval =0, e_dtval_tax  =0 
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref and hperiod in (2015,2016) 
and ((e_dtval+e_dtval_tax)<>0 )and ((e_ktval+e_ktval_tax) <> 0) and (e_dtval+e_dtval_tax) - (e_ktval+e_ktval_tax) <0 ;
*/
---------------------------------------


raise notice 'end_seb_obrs';
                         
  
return true;


end $BODY$
  LANGUAGE plpgsql VOLATILE;
/*

select rep_periods_saldo_fun('2016-03-01',20,null);


select sum(e_dtval) as e_dtval, sum (e_ktval) as e_ktval
from (

select 
cla.name as grp_name, CASE WHEN s.hperiod=2016 THEN '« 01.03.2016' ELSE 'ƒо 01.03.2016' END as  period,
s.id_client, cm.short_name, cm.code, cm.order_pay, 
sum(s.b_dtval) as b_dtval,sum(s.b_dtval_tax) as b_dtval_tax, 
sum(s.b_ktval) as b_ktval,sum(s.b_ktval_tax) as b_ktval_tax,
sum(s.dtval_kt) as dtval_kt,sum(s.dtval_kt_tax) as dtval_kt_tax,
sum(s.dtval+s.dtval_kt) as dtval, sum(s.dtval_tax+s.dtval_kt_tax)  as dtval_tax, 
sum(s.ktval_kt) as ktval_kt, sum(s.ktval_kt_tax) as ktval_kt_tax, 
sum(s.ktval+s.ktval_kt) as ktval,sum(s.ktval_tax+s.ktval_kt_tax) as ktval_tax,
sum(s.e_dtval) as e_dtval, sum(s.e_dtval_tax) as e_dtval_tax, 
sum(s.e_ktval) as e_ktval,sum(s.e_ktval_tax) as e_ktval_tax

from rep_periods_saldo_tmp as s
 join clm_client_tbl as cm on (cm.id = s.id_client)      
 join clm_statecl_tbl as stcl on (stcl.id_client = cm.id ) 
 join cla_param_tbl as cla on (stcl.id_section = cla.id) 
group by CASE WHEN s.hperiod=2016 THEN '« 01.03.2016' ELSE 'ƒо 01.03.2016' END,
 s.id_client, cm.short_name, cm.code, cm.order_pay, cla.name 
  order by cla.name, period, code

)as ss;


select 
--hperiod, 
sum(b_dtval) as b_dtval,  sum(b_ktval) as b_ktval,  sum(dtval_kt) as dtval_kt, sum( dtval)  as dtval, sum(ktval_kt) + sum(ktval) as ktval
from rep_periods_saldo_tmp
--group by hperiod



select 
hperiod,-- id_client,
sum(b_dtval) as b_dtval,  sum(b_ktval) as b_ktval,  sum(dtval_kt) as dtval_kt, sum( dtval)  as dtval, sum(ktval_kt) as ktval_kt, sum(ktval) as ktval,
sum(e_dtval) as e_dtval, 
sum(e_ktval) as e_ktval

from rep_periods_saldo_tmp
group by hperiod--, id_client order by id_client , hperiod
  */