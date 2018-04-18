;
set client_encoding = 'win';

--drop TABLE rep_periods_saldo_tmp;

CREATE TABLE rep_periods_saldo_tmp
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
  primary key (id_client,id_pref,mmgg,hperiod)

) ;



ALTER TABLE rep_periods_saldo_tmp ADD COLUMN sp1 numeric(14,2);
ALTER TABLE rep_periods_saldo_tmp ADD COLUMN sp1_tax numeric(14,2);

ALTER TABLE rep_periods_saldo_tmp ADD COLUMN sp2 numeric(14,2);
ALTER TABLE rep_periods_saldo_tmp ADD COLUMN sp2_tax numeric(14,2);


ALTER TABLE rep_periods_saldo_tmp ALTER COLUMN sp1 SET DEFAULT 0;
ALTER TABLE rep_periods_saldo_tmp ALTER COLUMN sp1_tax SET DEFAULT 0;

ALTER TABLE rep_periods_saldo_tmp ALTER COLUMN sp2 SET DEFAULT 0;
ALTER TABLE rep_periods_saldo_tmp ALTER COLUMN sp2_tax SET DEFAULT 0;


CREATE TABLE rep_periods_bad_tmp
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
  status int,
  primary key (id_client,id_pref,mmgg,hperiod)
) ;

--select crt_ttbl();
--select seb_all( 0, '2016-03-01');
--select * from seb_obr_all_tmp where id_pref = 20

drop FUNCTION rep_periods_saldo_fun(date, integer, integer);

CREATE OR REPLACE FUNCTION rep_periods_saldo_re_fun(date, integer, integer)
  RETURNS boolean AS
$BODY$
declare 
 pmmgg alias for $1;
 pid_pref  alias for $2;
 pid_client alias for $3;

 r record;
 
begin

perform seb_all( 0, pmmgg);

raise notice 'delete from ;';
delete from rep_periods_saldo_tmp where mmgg = pmmgg and id_pref = pid_pref;
raise notice 'insert into ';


if pmmgg ='2016-03-01'::date then

  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2015 , -deb_zpme, -deb_zpmpdv,kr_zpme,kr_zpmpdv,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client, deb_zpme , deb_zpmpdv, kr_zpme, kr_zpmpdv from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  --where not exists (select * from seb_saldo_tmp as s where ss.id_client = s.id_client and  ss.id_pref = s.id_pref and ss.mmgg = s.mmgg and ss.hmmgg = s.hmmgg);
  ;

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
  ;


  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2011 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  ;

else 


  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax ,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select 
   id_client ,  id_pref ,  pmmgg ,   hperiod ,  e_dtval ,  e_dtval_tax ,  e_ktval ,  e_ktval_tax,
   0,0,0,0,0,0,0,0,0,0,0,0
   from rep_periods_saldo_tmp where id_pref = pid_pref and mmgg = (pmmgg::date - '1 month'::interval)::date;

 

  insert into rep_periods_saldo_tmp   
  ( id_client ,  id_pref ,  mmgg ,   hperiod ,  b_dtval ,  b_dtval_tax ,  b_ktval ,  b_ktval_tax,
   dtval, dtval_tax, ktval, ktval_tax, dtval_kt, dtval_kt_tax,  ktval_kt, ktval_kt_tax, e_dtval, 
            e_dtval_tax, e_ktval, e_ktval_tax )
  select  id_client, pid_pref, pmmgg, 2016 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from
  (
   select id_client from seb_obr_all_tmp where id_pref = pid_pref and id_client is not null
  ) as ss
  where not exists (select * from rep_periods_saldo_tmp as s where ss.id_client = s.id_client and   s.id_pref = pid_pref 
     and s.mmgg = pmmgg and  s.hperiod = 2016);


end if;

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
         and b.mmgg_bill >= '2016-03-01' 
      group by b.id_client ) deb

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
         and b.mmgg_bill < '2016-03-01' and  b.mmgg_bill >= '2011-04-01'
      group by b.id_client ) deb

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
         and  b.mmgg_bill < '2011-04-01'
      group by b.id_client ) deb

      where  rep_periods_saldo_tmp.id_client=deb.id_client
      and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2011;



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
         and ((p.mmgg_pay >= '2016-03-01') or (p.mmgg >= '2016-03-01') and ((cm.order_pay = 0) or (date_part('year', p.mmgg_pay ) = date_part('year', p.mmgg ))))
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
         and p.mmgg_pay < '2016-03-01' and  p.mmgg_pay >= '2011-04-01' and 
           ((p.mmgg < '2016-03-01') or 
              cm.order_pay = 1 and (date_part('year', p.mmgg_pay ) <> date_part('year', p.mmgg )))

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
         and p.mmgg_pay < '2011-04-01' and
           ((p.mmgg < '2016-03-01') or 
              cm.order_pay = 1 and (date_part('year', p.mmgg_pay ) <> date_part('year', p.mmgg )))

      group by b.id_client ) deb
      where  rep_periods_saldo_tmp.id_client=deb.id_client 
      and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2011;


raise notice 'pay 1;';
--2016
 update rep_periods_saldo_tmp set ktval_kt= coalesce(value,0) , ktval_kt_tax= coalesce(value_tax,0) 

 from (select p.id_client,
   sum(p.value - coalesce(bp.value,0)) as value,
   sum(p.value_tax - coalesce(bp.value_tax,0)) as value_tax  
      from acm_pay_tbl as p 
      join clm_client_tbl as cm on (cm.id = p.id_client)      
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
            and ((p.mmgg_pay >= '2016-03-01') or 
                ((cm.order_pay = 0) or (date_part('year', p.mmgg_pay ) = date_part('year', p.mmgg ))) and p.value >0 )
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
            and p.mmgg_pay < '2016-03-01' and  p.mmgg_pay >= '2011-04-01' 
             and ((cm.order_pay = 1  and (date_part('year', p.mmgg_pay ) <> date_part('year', p.mmgg ))) or (p.value < 0))

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
            and p.mmgg_pay < '2011-04-01'
             and ((cm.order_pay = 1  and (date_part('year', p.mmgg_pay ) <> date_part('year', p.mmgg ))) or (p.value < 0))

      group by p.id_client ) kred
      where rep_periods_saldo_tmp.id_client=kred.id_client --and seb_saldo_tmp.mmgg=pmmgg --and 
        and rep_periods_saldo_tmp.mmgg = pmmgg
      and rep_periods_saldo_tmp.id_pref = pid_pref
      and rep_periods_saldo_tmp.hperiod = 2011;


 raise notice 'pay 2;';
 --2016
 update rep_periods_saldo_tmp set ktval=value , ktval_tax= value_tax 
 from (select p.id_client,
      sum(bp.value) as value,sum(bp.value_tax) as value_tax  
      from acm_pay_tbl p 
      join acm_billpay_tbl bp on (p.id_doc=bp.id_pay)
      join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
        and b.mmgg_bill >= '2016-03-01' 
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
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
        and b.mmgg_bill < '2016-03-01' and  b.mmgg_bill >= '2011-04-01'
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
      where 
        p.mmgg=pmmgg and b.mmgg <=pmmgg and p.id_pref = pid_pref and b.id_pref = pid_pref and bp.mmgg =pmmgg -- and p.value >0
        and b.mmgg_bill < '2011-04-01'
      group by p.id_client ) kred

      where  rep_periods_saldo_tmp.id_client=kred.id_client 
        and rep_periods_saldo_tmp.mmgg = pmmgg
        and rep_periods_saldo_tmp.id_pref = pid_pref
        and rep_periods_saldo_tmp.hperiod = 2011;

-------------------------------------------

update rep_periods_saldo_tmp set e_dtval    = b_dtval - ktval + dtval 
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref;

update rep_periods_saldo_tmp set e_dtval_tax= b_dtval_tax - ktval_tax + dtval_tax 
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref;

update rep_periods_saldo_tmp set e_ktval    = b_ktval - dtval_kt+ktval_kt
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref;

update rep_periods_saldo_tmp set e_ktval_tax= b_ktval_tax - dtval_kt_tax+ktval_kt_tax
where rep_periods_saldo_tmp.mmgg = pmmgg  and rep_periods_saldo_tmp.id_pref = pid_pref;

-----------------
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



---------------------------------------------------------------------------------------
-- таблица ручных корректировок

delete from rep_periods_saldo_tmp where exists 
(select id_client from rep_periods_corr_tmp as c where c.mmgg = pmmgg and c.id_pref = pid_pref 
  and c.id_client = rep_periods_saldo_tmp.id_client and c.hperiod = rep_periods_saldo_tmp.hperiod);

insert into rep_periods_saldo_tmp
select * from rep_periods_corr_tmp where mmgg = pmmgg and id_pref = pid_pref;


---------------------------------------

delete from rep_periods_saldo_tmp 
where mmgg = pmmgg  and id_pref = pid_pref
and 
 b_dtval = 0 and  b_dtval_tax=0 and  b_ktval = 0 and  b_ktval_tax =0 and  dtval =0 and dtval_tax = 0 and ktval=0 and ktval_tax=0 and
 dtval_kt =0 and dtval_kt_tax =0 and  ktval_kt =0 and ktval_kt_tax =0 and e_dtval =0 and e_dtval_tax=0 and e_ktval=0 and e_ktval_tax=0 ;

raise notice 'end_seb_obrs';
                         
  
return true;


end $BODY$
  LANGUAGE plpgsql VOLATILE;
/*

select rep_periods_saldo_fun('2016-03-01',20,null);


select sum(e_dtval) as e_dtval, sum (e_ktval) as e_ktval
from (

select 
cla.name as grp_name, CASE WHEN s.hperiod=2016 THEN 'З 01.03.2016' ELSE 'До 01.03.2016' END as  period,
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
group by CASE WHEN s.hperiod=2016 THEN 'З 01.03.2016' ELSE 'До 01.03.2016' END,
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