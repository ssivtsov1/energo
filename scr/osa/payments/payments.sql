-- ----------------------------------------------------------------
-- payments.sql - 
-- ----------------------------------------------------- 04.01.2003 9:20

alter table  acm_pay_tbl add column mmgg_pay date;
alter table  acm_pay_tbl add column mmgg_hpay date;
alter table  acm_pay_tbl alter column mmgg_hpay set default fun_mmgg();
alter table  acm_headpay_tbl add column mmgg_hpay date;
alter table  acm_headpay_tbl alter column mmgg_hpay set default fun_mmgg();
alter table  acm_pay_tbl alter column mmgg_pay set default fun_mmgg();




alter table  clm_client_tbl add column order_pay int;
alter table  clm_client_tbl alter column order_pay set default 0;
update clm_client_tbl set order_pay=0 where order_pay is null;

alter table  acm_billpay_tbl add column id_client int;

update acm_billpay_tbl set id_client=p.id_client from acm_pay_tbl p 
 where acm_billpay_tbl.id_pay=p.id_doc and acm_billpay_tbl.id_client is null;

drop view acv_billpay;
CREATE VIEW acv_billpay  (id_doc,mmgg_bill,id_client,val,val_tax,pay,pay_tax
,rest,rest_tax)
AS
 select b.id_doc, b.mmgg,b.id_client,b.value as val ,b.value_tax as val_tax
,
  sum(coalesce(bp.value,0)) as pay ,sum(coalesce(bp.value_tax,0)) as pay_tax,
  coalesce(b.value,0)-sum(coalesce(bp.value,0)) as rest,
   coalesce(b.value_tax,0)-sum(coalesce(bp.value_tax,0)) as rest_tax
 from acm_bill_tbl b left outer join  acm_billpay_tbl bp on b.id_doc=bp.id_bill
 group by  b.id_doc,b.mmgg,b.id_client,b.value,b.value_tax 
 order by b.id_client,b.id_doc; 


drop view acv_paybill;
CREATE VIEW acv_paybill (id_doc,mmgg_pay,mmgg,id_client,val,pay,pay_tax
,rest)
AS
 select p.id_doc,p.mmgg_pay,p.mmgg,p.id_client,p.value as val
,
  sum(coalesce(bp.value,0)) as pay ,sum(coalesce(bp.value_tax,0)) as pay_tax,
  coalesce(p.value,0)-sum(coalesce(bp.value,0)) as rest,
  coalesce(p.value_tax,0)-sum(coalesce(bp.value_tax,0)) as rest_tax 
 from acm_pay_tbl p left outer join  acm_billpay_tbl bp on p.id_doc=bp.id_pay
 group by  p.id_doc,p.mmgg_pay,p.mmgg,p.id_client,p.value,p.value_tax
 order by p.id_client,p.id_doc; 

drop view acv_bp;

CREATE VIEW acv_bp (id_client,id_bill,id_pay,mg_bill,mg_pay,mgbp,valb,val_taxb,payp,pay_taxp,val,val_tax)
AS                                                                   
select  coalesce(b.id_client,p.id_client) as id_client,
                    b.id_doc as id_bill,p.id_doc as id_pay,
                    b.mmgg as mg_bill,  p.mmgg as mg_pay, b.bpmg::date,
                    b.value as valb,b.value_tax as val_taxb,
                    p.value as valp,p.value_tax as val_taxp,
                    b.valbb,b.val_taxbb
 from (select b.*,a.id_pay,a.mmgg as bpmg,a.value as valbb,
      a.value_tax  as val_taxbb from acm_bill_tbl b 
        full join  acm_billpay_tbl a on b.id_doc=a.id_bill) as b
      full join
       acm_pay_tbl p on p.id_doc=b.id_pay order by b.mmgg;
 


drop function acc_payments_bill(int,numeric,int);
create  or replace function acc_payments_bill (int,numeric,int) returns numeric(14,4)  
as '  declare 
      
      vid_bill alias for $1;
      rest_bill alias for $2;
      cou alias for $3; 
      vbill record;
      vpay record;
      val_pay numeric;
      valtax_pay numeric;
      resb numeric;
      resb_tax numeric;
      isbill int;
      mgbillpay date;
      strrest varchar;
      repay boolean;
      pay_per int;
      kor_doc int;
      ret boolean;
      vbill1 record;
      vbill2 record;
      resb2 numeric;
      ord_pay int;
begin 
  resb=rest_bill;
  val_pay=0;
  mgbillpay=fun_mmgg();
    raise notice ''bill % ,%'',vid_bill,rest_bill ;
   select  into vbill b.id_doc,b.mmgg,b.mmgg_bill,b.id_client,b.reg_date
       ,b.id_pref,b.value,b.value_tax 
       ,coalesce(pb.rest,0) as rest,coalesce(pb.rest_tax,0) as rest_tax
       from acm_bill_tbl b left outer join 
           (select * from acv_billpay_paym where id_doc=vid_bill) pb 
            on b.id_doc=pb.id_doc
      where b.id_doc=vid_bill and ((pb.rest!=0 or pb.rest is null) 
        or (pb.rest_tax!=0 or pb.rest_tax is null));
   if found then 
      select into ord_pay order_pay from clm_client_tbl where id=vbill.id_client;
      raise notice ''ordpay - %'',ord_pay;
      resb=vbill.rest;
      resb_tax=vbill.rest_tax;
      val_pay=0; 
      valtax_pay=0; 
      raise notice ''id_bill %'',vbill.id_doc ;
      raise notice ''id_client %'',vbill.id_client;
      isbill=0;
      if resb<0 or resb_tax<0 then
        select into kor_doc id from dci_document_tbl where ident=''kork_sal'';
          strrest=''rest_pay == ''||to_char(resb,''999999999.99'')||'' resb_tax ==''||to_char(resb_tax,''999999999.99'');
          raise notice '' bill  <0  %'',strrest;
         select into pay_per p.id_doc from acm_pay_tbl p 
            where
                p.id_pref=vbill.id_pref and 
                p.id_client=vbill.id_client and 
                p.mmgg_hpay=vbill.mmgg_bill  
                -- p.mmgg_hpay=vbill.mmgg 
                 and vbill.mmgg_bill=p.mmgg_pay  --------add 06-02-2006
                and p.mmgg=vbill.mmgg 
               and idk_doc=kor_doc;
           raise notice ''rrr %'',vbill.rest ;
         if not found then
            raise notice ''not pay    --- insert pay '';   
            raise notice ''rrr %'',vbill.rest ;
            
           insert into acm_pay_tbl (id_pref,idk_doc,reg_num,reg_date,
                 mmgg,mmgg_hpay,mmgg_pay,id_client,id_headpay
                 ,value,value_tax,value_pay) values
               (vbill.id_pref,kor_doc,''for korrect'',eom(vbill.mmgg),
                vbill.mmgg,vbill.mmgg_bill,vbill.mmgg_bill,
                vbill.id_client,null,0,0,0);
         end if;  
         for vpay in 
            select p.id_doc,p.id_pref,p.mmgg,p.mmgg_pay,coalesce(p.value,0) as value,
             p.mmgg_pay,coalesce(pb.rest,0) as rest ,coalesce(pb.rest_tax,0) as rest_tax 
             ,p.id_client
            from acm_pay_tbl p left outer join 
             (select * from acv_paybill where id_client=vbill.id_client) pb on  
              p.id_doc=pb.id_doc
            where  p.id_client=vbill.id_client and p.id_pref=vbill.id_pref 
              and  vbill.mmgg_bill=p.mmgg_hpay 
             and vbill.mmgg_bill=p.mmgg_pay 
             and vbill.mmgg=p.mmgg and p.idk_doc=kor_doc
               loop
             -- and p.reg_num=''for korrect'' loop
             --isbill=1;
            raise notice ''found rrr %'',vbill.rest ;
             val_pay=vbill.rest;
             valtax_pay=vbill.rest_tax;	   
             mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;
             raise notice ''client 100000000000 %'',vpay.id_client;
             
             insert into acm_billpay_tbl (id_bill,id_pay,id_client,value,value_tax,mmgg) values
               (vbill.id_doc,vpay.id_doc,vpay.id_client,val_pay,valtax_pay,mgbillpay);
             resb=resb-val_pay;
             resb_tax=resb_tax-valtax_pay;
             exit;
         end loop;
      end if;
       raise notice ''start for vpay'';
      for vpay in 
         select p.id_doc,p.id_pref,p.mmgg,p.mmgg_hpay,p.mmgg_pay,coalesce(p.value,0) as value,
            p.mmgg_pay,coalesce(pb.rest,0) as rest ,coalesce(pb.rest_tax,0) as rest_tax 
            ,p.id_client
         from (select p.*,
              case when p.value>0 then p.reg_date else bom(p.mmgg) end  as dat_r  
             from (select p.* from acm_pay_tbl p,acv_paybill pb 
                   where p.id_client=vbill.id_client and p.id_doc=pb.id_doc 
                   and (pb.rest<>0 or pb.rest_tax<>0)
                  )  p where id_client=vbill.id_client) p 
            left outer join 
           (select * from acv_paybill where id_client=vbill.id_client)          
            pb on  p.id_doc=pb.id_doc
          where (resb!=0 or resb_tax!=0) and p.id_client=vbill.id_client and p.id_pref=vbill.id_pref 
          and ( (case when ( ord_pay=0 and
                     (date_part(''year'',vbill.mmgg_bill)>=2006 and date_part(''year'',vbill.mmgg)>=2006) 
                      and (date_part(''year'',p.mmgg_pay) >=2006 and date_part(''year'',p.mmgg) >=2006) )
                  then 
                      1=1
                  else
                    date_part(''year'',vbill.mmgg_bill)= date_part(''year'',p.mmgg_pay)
                 end 
                )
          and ( ((pb.rest is null or coalesce(pb.rest,0)!=0)  and coalesce(vbill.rest,0)>0) 
              or ((pb.rest_tax is null or pb.rest_tax!=0) and vbill.rest_tax>0)
              ) ) 
          ORDER BY p.mmgg, p.mmgg_pay,p.dat_r,p.value loop
          raise notice ''find pay ---- id_pay   ==== %'',vpay.id_doc;
          isbill=1;
          if vpay.rest<0 or vpay.rest_tax<0 then
                 val_pay=vpay.rest;
                 valtax_pay=vpay.rest_tax;	   
                 mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;
             raise notice ''client 2 %'',vpay.id_client;            
                insert into acm_billpay_tbl (id_bill,id_pay,id_client,value,value_tax,mmgg) values
                (vbill.id_doc,vpay.id_doc,vpay.id_client,val_pay,valtax_pay,mgbillpay);
                resb=resb-val_pay;
                resb_tax=resb_tax-valtax_pay;
                raise notice ''resb  aft bill'';
                exit;
          else
           val_pay=0; 
           valtax_pay=0; 
           if   vpay.rest>=vbill.rest  then
                val_pay=vbill.rest;
            else
              val_pay=vpay.rest;
           end if;
           if   vpay.rest_tax>=vbill.rest_tax  then
               valtax_pay=vbill.rest_tax;	   
           else
               valtax_pay=vpay.rest_tax;	   
           end if;
          if val_pay!=0 or valtax_pay!=0 then 
            mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;
                        raise notice ''client 3 %'',vpay.id_client;
           insert into acm_billpay_tbl (id_bill,id_pay,id_client,value,value_tax,mmgg) values
               (vbill.id_doc,vpay.id_doc,vpay.id_client,val_pay,valtax_pay,mgbillpay);

            resb=resb-val_pay;
            resb_tax=resb_tax-valtax_pay;
           raise notice ''resb  -% '',resb;
           raise notice ''val_pay  -% '',val_pay;
          end if;
          exit;
        end if;
      end loop;
      raise notice ''end start vpay'';
      if (((resb!=0 or resb_tax!=0) and isbill!=0)) then
          raise notice ''is bill  %'',isbill; 
          strrest=''restb== ''||to_char(resb,''999999999.99'')||'' resb_tax ==''||to_char(resb_tax,''999999999.99'');
          raise notice ''Recurs from bill  %'',strrest;
              
          resb= acc_payments_bill(vbill.id_doc,resb,cou);
      else 
       return resb;
      end if;
   end if; 
return resb;
end;
' LANGUAGE 'plpgsql';

