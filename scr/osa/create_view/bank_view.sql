drop view cmv_bank cascade;


  alter table acm_headpay_tbl add column flag_priv boolean;
  select altr_colmn('acm_pay_tbl','account_client','varchar(14)');
  select altr_colmn('acm_pay_tbl','account_self','varchar(14)');
  select altr_colmn('acm_headpay_tbl','account_self','varchar(14)');

  alter table acm_pay_tbl add column year_pay integer;
  alter table acm_headpay_tbl add column flag_type int;




CREATE VIEW cmv_bank (mfo,acc,dat,begs,plus,minus,ends)
AS
select mfoe as mfo,acce as acc,datae as dat,begs,plus,minus,ends from 
 (select * from 
  (
     ( select  hte.mfo_self as mfoe,hte.account_self as acce,
       hte.reg_date as datae,   sum(ptple.value_pay*ptple.sign_pay) as ends 
       from acm_headpay_tbl hte, acm_headpay_tbl htee,acm_pay_tbl ptple 
       where ptple.id_headpay=htee.id 
          and hte.reg_date>=htee.reg_date  
             and hte.mfo_self=htee.mfo_self
             and hte.account_self=htee.account_self
       group by  hte.mfo_self,hte.account_self,hte.reg_date  
     )  as e
     left join 
     ( select  htb.mfo_self as mfob,htb.account_self as accb,
       htb.reg_date as datab,
       sum(ptplb.value_pay*ptplb.sign_pay) as begs 
       from acm_headpay_tbl htb, acm_headpay_tbl htn,acm_pay_tbl ptplb 
       where ptplb.id_headpay=htn.id 
             and htn.mfo_self=htb.mfo_self
             and htn.account_self=htb.account_self
             and htn.reg_date<htb.reg_date 
       group by  htb.mfo_self,htb.account_self,htb.reg_date  
     )  as b
    on (b.mfob=e.mfoe and b.accb=e.acce   and b.datab=e.datae)
 ) as s
 left join
 ( select ht.mfo_self as mfop,ht.account_self as accp,ht.reg_date as datp,
        sum(ptpl.value_pay) as plus
         from acm_headpay_tbl ht,acm_pay_tbl ptpl
         where  ptpl.id_headpay=ht.id and ptpl.sign_pay=1 
         group by  ht.mfo_self,ht.account_self,ht.reg_date 
 )  as p 
    on (s.mfoe=p.mfop and s.acce=p.accp   and s.datae=p.datp)
) as t 
 left join 
(select  ht1.mfo_self as mfom,ht1.account_self as accm,ht1.reg_date as datm,
       sum(ptpl1.value_pay) as minus 
      from acm_headpay_tbl ht1, acm_pay_tbl ptpl1 
      where ptpl1.id_headpay=ht1.id and ptpl1.sign_pay=-1 
       group by  ht1.mfo_self,ht1.account_self,ht1.reg_date  
  ) as m
  on (t.mfoe=m.mfom and t.acce=m.accm   and t.datae=m.datm)
/*
select coalesce(mfo,mfoe) as mfo,coalesce(acc,acce) as acc,
   coalesce(dat,datae) as dat,begs,plus,minus,ends
from 

 (select coalesce(mfoa,mfob) as mfo,coalesce(acca,accb) as acc,
   coalesce(dataa,datab) as dat,begs,
   plus,minus from 
 (
  select coalesce(mfo1,mfo2) as mfoa,coalesce(account1,account2) as acca,
   coalesce(reg_date1,reg_date2) as dataa,
   plus,minus
  from  
   ( select ht.mfo_self as mfo1,ht.account_self as account1,ht.reg_date as reg_date1,
       sum(ptpl.value_pay) as plus
     from acm_headpay_tbl ht,acm_pay_tbl ptpl
     where  ptpl.id_headpay=ht.id and ptpl.sign_pay=1 
       group by  ht.mfo_self,ht.account_self,ht.reg_date
   )
     as a  
       full outer join 
    ( select  ht1.mfo_self as mfo2,ht1.account_self as account2,ht1.reg_date as reg_date2,
       sum(ptpl1.value_pay) as minus 
      from acm_headpay_tbl ht1, acm_pay_tbl ptpl1 
      where ptpl1.id_headpay=ht1.id and ptpl1.sign_pay=-1 
       group by  ht1.mfo_self,ht1.account_self,ht1.reg_date  
    ) 
    as b
    on (a.mfo1=b.mfo2 and a.account1=b.account2 
    and a.reg_date1=b.reg_date2)
  ) as c
   full outer join 
    ( select  htb.mfo_self as mfob,htb.account_self as accb,
       htb.reg_date as datab,
       sum(ptplb.value_pay*ptplb.sign_pay) as begs 
      from acm_headpay_tbl htb, acm_headpay_tbl htn,acm_pay_tbl ptplb 
      where ptplb.id_headpay=htn.id and htn.reg_date<htb.reg_date 
       group by  htb.mfo_self,htb.account_self,htb.reg_date  
    ) 
    as d
    on (d.mfob=c.mfoa and c.acca=d.accb 
    and c.dataa=d.datab)
  ) as e
   full outer join 
    ( select  hte.mfo_self as mfoe,hte.account_self as acce,
       hte.reg_date as datae,
       sum(ptple.value_pay*ptple.sign_pay) as ends 
      from acm_headpay_tbl hte, acm_headpay_tbl htee,acm_pay_tbl ptple 
      where ptple.id_headpay=htee.id and hte.reg_date>=htee.reg_date 
       group by  hte.mfo_self,hte.account_self,hte.reg_date  
    ) 
    as f
    on (e.mfo=f.mfoe and e.acc=f.acce 
    and e.dat=f.datae);






CREATE VIEW cmv_bank1 (mfo,acc,dat,begs,plus,minus,ends)
AS

select coalesce(mfo,mfoe) as mfo,coalesce(acc,acce) as acc,
   coalesce(dat,datae) as dat,begs,plus,minus,ends
from 
    select * from 
   ( ( select  hte.mfo_self as mfoe,hte.account_self as acce,
       hte.reg_date as datae,
       sum(ptple.value_pay*ptple.sign_pay) as ends 
       from acm_headpay_tbl hte, acm_headpay_tbl htee,acm_pay_tbl ptple 
       where ptple.id_headpay=htee.id and hte.reg_date>=htee.reg_date 
       group by  hte.mfo_self,hte.account_self,hte.reg_date  
     )  as b
      left join 
     ( select  htb.mfo_self as mfob,htb.account_self as accb,
       htb.reg_date as datab,
       sum(ptplb.value_pay*ptplb.sign_pay) as begs 
       from acm_headpay_tbl htb, acm_headpay_tbl htn,acm_pay_tbl ptplb 
       where ptplb.id_headpay=htn.id and htn.reg_date<htb.reg_date 
       group by  htb.mfo_self,htb.account_self,htb.reg_date  
     )  as e
    on (b.mfob=e.mfoe and b.accb=e.acce   and b.datab=e.datae)
   ) 




 (select coalesce(mfoa,mfob) as mfo,coalesce(acca,accb) as acc,
   coalesce(dataa,datab) as dat,begs,
   plus,minus from 
 (
  select coalesce(mfo1,mfo2) as mfoa,coalesce(account1,account2) as acca,
   coalesce(reg_date1,reg_date2) as dataa,
   plus,minus
  from  
   ( select ht.mfo_self as mfo1,ht.account_self as account1,ht.reg_date as reg_date1,
       sum(ptpl.value_pay) as plus
     from acm_headpay_tbl ht,acm_pay_tbl ptpl
     where  ptpl.id_headpay=ht.id and ptpl.sign_pay=1 
       group by  ht.mfo_self,ht.account_self,ht.reg_date
   )
     as a  
       full outer join 
    ( select  ht1.mfo_self as mfo2,ht1.account_self as account2,ht1.reg_date as reg_date2,
       sum(ptpl1.value_pay) as minus 
      from acm_headpay_tbl ht1, acm_pay_tbl ptpl1 
      where ptpl1.id_headpay=ht1.id and ptpl1.sign_pay=-1 
       group by  ht1.mfo_self,ht1.account_self,ht1.reg_date  
    ) 
    as b
    on (a.mfo1=b.mfo2 and a.account1=b.account2 
    and a.reg_date1=b.reg_date2)
  ) as c
   full outer join 
    ( select  htb.mfo_self as mfob,htb.account_self as accb,
       htb.reg_date as datab,
       sum(ptplb.value_pay*ptplb.sign_pay) as begs 
      from acm_headpay_tbl htb, acm_headpay_tbl htn,acm_pay_tbl ptplb 
      where ptplb.id_headpay=htn.id and htn.reg_date<htb.reg_date 
       group by  htb.mfo_self,htb.account_self,htb.reg_date  
    ) 
    as d
    on (d.mfob=c.mfoa and c.acca=d.accb 
    and c.dataa=d.datab)
  ) as e
   full outer join 
    ( select  hte.mfo_self as mfoe,hte.account_self as acce,
       hte.reg_date as datae,
       sum(ptple.value_pay*ptple.sign_pay) as ends 
      from acm_headpay_tbl hte, acm_headpay_tbl htee,acm_pay_tbl ptple 
      where ptple.id_headpay=htee.id and hte.reg_date>=htee.reg_date 
       group by  hte.mfo_self,hte.account_self,hte.reg_date  
    ) 
    as f
    on (e.mfo=f.mfoe and e.acc=f.acce 
    and e.dat=f.datae)



  */

/*select * from  
  ( select ht.mfo_self,ht.account_self,ht.reg_date,
      sum(ptpl.value_pay) as plus
     from acm_headpay_tbl ht,acm_pay_tbl ptpl
     where  ptpl.id_headpay=ht.id and ptpl.sign_pay=1 
     group by  ht.mfo_self,ht.account_self,ht.reg_date
)
     as a  
       full outer join 
    (select  ht1.mfo_self,ht1.account_self,ht1.reg_date,
      sum(ptpl1.value_pay) as minus 
     from acm_headpay_tbl ht1, acm_pay_tbl ptpl1 
      where ptpl1.id_headpay=ht1.id and ptpl1.sign_pay=-1 
     group by  ht1.mfo_self,ht1.account_self,ht1.reg_date  
     ) as b
     on (a.mfo_self=b.mfo_self and a.account_self=b.account_self 
      and a.reg_date=b.reg_date)
  */

     
/*select c.* from  
  (( select ht.mfo_self,ht.account_self,ht.reg_date,
      0 as begs,sum(ptpl.value_pay) as plus, 0 as minus,
      0 as ends
     from acm_headpay_tbl ht,acm_pay_tbl ptpl
     where  ptpl.id_headpay=ht.id and ptpl.sign_pay=1 
     group by  ht.mfo_self,ht.account_self,ht.reg_date)
     as a  
       full outer join 
    (select ht1.mfo_self,ht1.account_self,ht1.reg_date,
      0 as begs,0 as plus, sum(ptpl1.value_pay) as minus,
      0 as ends 
     from acm_headpay_tbl ht1, acm_pay_tbl ptpl1 
     where  ptpl1.id_headpay=ht1.id and ptpl1.sign_pay=1  
     group by  ht1.mfo_self,ht1.account_self,ht1.reg_date)  
    as b 
     where a.mfo_self=b.mfo_self and a.account_self=b.account_self 
and a.reg_date=b.reg_date) as c;
  */