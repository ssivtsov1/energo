select id_doc,dat,ident,case when ident='pay' then pay_num else bill_num  end as num_doc,
case when ident='pay' then pay_date else bill_date  end as date_doc,summ,ident1 
from (select b.*,p.reg_num as pay_num,p.reg_date as pay_date from
 (select c.*,b.reg_num as bill_num,b.reg_date as bill_date from acd_summ_val c 
   left join acm_bill_tbl b on b.id_doc=c.id_p_doc ) as b 
  left join
   acm_pay_tbl p on p.id_doc=b.id_p_doc
 ) as r where ident <>'se'
 order by id_doc,ident1,dat