-- ----------------------------------------------------------------
-- payments.sql - 
-- ----------------------------------------------------- 04.01.2003 9:20

alter table  acm_pay_tbl add column mmgg_pay date;
alter table  acm_pay_tbl add column mmgg_hpay date;

alter table  acm_pay_tbl alter column mmgg_hpay set default fun_mmgg();
alter table  acm_headpay_tbl add column mmgg_hpay date;
alter table  acm_headpay_tbl alter column mmgg_hpay set default fun_mmgg();
alter table  acm_pay_tbl alter column mmgg_pay set default fun_mmgg();

update acm_billpay_tbl set id_client=p.id_client from acm_pay_tbl p 
 where acm_billpay_tbl.id_pay=p.id_doc and acm_billpay_tbl.id_client is null;

create  index acm_billpay_bill on acm_billpay_tbl (id_bill);
create  index acm_billpay_pay on acm_billpay_tbl (id_pay);
create  index acm_billpay_mmgg on acm_billpay_tbl (mmgg);
create  index acm_billpay_client on acm_billpay_tbl (id_client);


drop view acv_billpay_paym;
CREATE VIEW acv_billpay_paym  (id_doc,mmgg_bill,id_client,val,val_tax,pay,pay_tax,rest,rest_tax)AS select b.id_doc, b.mmgg,b.id_client,b.value as val ,b.value_tax as val_tax,  sum(coalesce(bp.value,0)) as pay ,sum(coalesce(bp.value_tax,0)) as pay_tax,  coalesce(b.value,0)-sum(coalesce(bp.value,0)) as rest,   coalesce(b.value_tax,0)-sum(coalesce(bp.value_tax,0)) as rest_tax from acm_bill_tbl b left outer join  acm_billpay_tbl bp on b.id_doc=bp.id_bill group by  b.id_doc,b.mmgg,b.id_client,b.value,b.value_tax  order by b.id_doc;   
drop view acv_paybill_paym;
CREATE VIEW acv_paybill_paym (id_doc,mmgg_pay,mmgg,id_client,val,pay,pay_tax,rest)AS select p.id_doc,p.mmgg_pay,p.mmgg,p.id_client,p.value as val,  sum(coalesce(bp.value,0)) as pay ,sum(coalesce(bp.value_tax,0)) as pay_tax,  coalesce(p.value,0)-sum(coalesce(bp.value,0)) as rest,  coalesce(p.value_tax,0)-sum(coalesce(bp.value_tax,0)) as rest_tax  from acm_pay_tbl p left outer join  acm_billpay_tbl bp on p.id_doc=bp.id_pay group by  p.id_doc,p.mmgg_pay,p.mmgg,p.id_client,p.value,p.value_tax order by p.id_doc; 



drop function acc_payments_pay(int,numeric(14,2),date,int);
create function acc_payments_pay (int,numeric(14,2),date,int) returns numeric(14,2)  as 'declare   vid_pay alias for $1;  vvrest  alias for $2;  dbill alias for $3;  nbill int;  nulldate date;  nullbill int;  vpay record;  vbill record;  val_pay numeric;  valtax_pay numeric;  des numeric;  counti1 alias for $4;  counti int;  vrest numeric;  vrest_tax numeric;  isbill int;  mgbillpay date;   ord_pay int;begin  vrest=vvrest;  counti=counti1+1;  raise notice ''counti %'',counti;  val_pay=0;  valtax_pay=0;  mgbillpay=fun_mmgg();  raise notice ''mgbillpay - %'',mgbillpay;  select into vpay p.id_doc,p.id_client,p.id_pref,p.mmgg,p.mmgg_pay,p.mmgg_hpay,        p.value,p.value_tax,p.id_bill,coalesce(pb.rest,0) as rest,              coalesce(pb.rest_tax,0) as rest_tax,p.id_client             from acm_pay_tbl p left outer join acv_paybill pb on p.id_doc=pb.id_doc                  where p.id_doc=vid_pay and (pb.rest>0 or pb.rest is null              or pb.rest_tax is null or pb.rest_tax!=0);if found then    select into ord_pay order_pay from clm_client_tbl where id=vpay.id_client;    raise notice ''ordpay ---------------------- ,%'',ord_pay;    raise notice ''vrest ---------------------- ,%'',vrest;    raise notice ''vpay.rest ------------------ ,%'',vpay.rest;    raise notice ''dbill------------------ ,%'',dbill;    vrest=vpay.rest;    vrest_tax=vpay.rest_tax;     while vrest>0  or vrest_tax>0  loop      if not(dbill is NULL) then       raise notice ''dbill not is NULL '';          isbill=0;           for  vbill in select b.id_doc,b.mmgg,b.id_client,b.value,b.value_tax,               coalesce(bp.rest,0) as rest,coalesce(bp.rest_tax,0) as rest_tax               from acm_bill_tbl b left outer join acv_billpay_paym bp on b.id_doc=bp.id_doc                  where b.mmgg_bill=dbill                  and b.id_client=vpay.id_client  and b.id_pref=vpay.id_pref                  and ((bp.rest!=0 or bp.rest is null)                    or (bp.rest_tax!=0 or bp.rest_tax is null))                      order by b.mmgg,b.dat_e  loopisbill=1;                      raise notice ''vbill_id   -% '',vbill.id_doc;                      raise notice ''vbill_rest   -% '',vbill.rest;                      raise notice ''pay_rest   -% '',vpay.rest;               if vbill.rest>=vpay.rest  then		            val_pay=vpay.rest;               end if;               if  vbill.rest_tax>=vpay.rest_tax  then		            valtax_pay=vpay.rest_tax;	     	       end if;	      if vbill.rest<=vpay.rest then    		            val_pay=vbill.rest;	      end if; 	      if vbill.rest_tax<=vpay.rest_tax then		            valtax_pay=vbill.rest_tax;   	      end if;               if val_pay!=0 or valtax_pay!=0 then         	  mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date; raise notice ''pay - %'',val_pay; raise notice ''valtax_pay - %'',valtax_pay;-- raise notice ''vpay_mmgg - %'',vpay.mmgg;                  insert into acm_billpay_tbl (id_bill,id_client,id_pay,value,value_tax,mmgg) values                  (vbill.id_doc,vbill.id_client,vpay.id_doc,val_pay,valtax_pay,mgbillpay);                 -- isbill=1;              end if;	     exit;	   end loop;        if isbill=0 thenraise notice ''1'';          vrest= acc_payments_pay(vpay.id_doc,vrest,null,counti);raise notice ''2'';        end if;      end if;         --   date_trunc(''year'',b.mmgg_bill)=date_trunc(''year'',vpay.mmgg_pay)raise notice ''3'';	      if dbill is  NULL thenraise notice ''4'';        for vbill in select  b.id_doc,b.id_client,b.mmgg,b.reg_date,b.value_tax,             coalesce(bp.rest,0) as rest,coalesce(bp.rest_tax,0) as rest_tax             from acm_bill_tbl b left outer join (select * from acv_billpay_paym where id_client=vpay.id_client order by id_doc) bp on b.id_doc=bp.id_doc                  where b.id_pref=vpay.id_pref and b.id_client=vpay.id_client                    and                     (case when ( ord_pay=0 and                     (date_part(''year'',b.mmgg_bill)>=2006 and date_part(''year'',b.mmgg)>=2006)                       and (date_part(''year'',vpay.mmgg_pay) >=2006 and date_part(''year'',vpay.mmgg) >=2006) )                     then                       1=1                     else                       date_part(''year'',vpay.mmgg_pay)= date_part(''year'',b.mmgg_bill)                     end                     )        	  and (bp.rest!=0 or bp.rest is null or bp.rest_tax!=0 or bp.rest_tax is null)                   order by b.mmgg,b.reg_date loop		  raise notice ''dbill=null %'',vrest;              if vbill.rest>=vpay.rest  then		     val_pay=vpay.rest;	      end if;              if vbill.rest_tax>=vpay.rest_tax  then		     valtax_pay=vpay.rest_tax;	     	      end if;	      if vbill.rest<vpay.rest then		      val_pay=vbill.rest;              end if;     	      if vbill.rest_tax<vpay.rest_tax then		      valtax_pay=vbill.rest_tax;                 end if;     	      if val_pay!=0 or valtax_pay!=0 then      	  mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;          raise notice ''mgbillpay - %'',mgbillpay;        raise notice ''vbill_mmgg - %'',vbill.mmgg;          raise notice ''vpay_mmgg - %'',vpay.mmgg;            	--     insert into acm_billpay_tbl (id_bill,id_pay,value,value_tax,mmgg) values                -- (vbill.id_doc,vpay.id_doc,val_pay,valtax_pay,vpay.mmgg);         insert into acm_billpay_tbl (id_bill,id_client,id_pay,value,value_tax,mmgg) values              (vbill.id_doc,vbill.id_client,vpay.id_doc,val_pay,valtax_pay,mgbillpay);	      end if;         exit;     end loop;raise notice ''5'';end if; raise notice ''End_Rest %'',vrest;-- des=vrest-val_pay-valtax_pay;  if val_pay!=0 or valtax_pay!=0 then     vrest= acc_payments_pay(vpay.id_doc,vrest-val_pay,null,counti);   else vrest=0;      vrest_tax=0;  end if;   return vrest;end loop; raise notice ''return %'',vrest; raise notice ''return %'',vrest_tax; return vrest;else raise notice ''return1 %'',vrest; raise notice ''return1 %'',vrest_tax; return vrest;end if; --loop;end;' LANGUAGE 'plpgsql';/*create function acc_payments_pay 
(int,numeric(14,2),date,int) returns numeric(14,2)  as '
declare 
  vid_pay alias for $1;
  vvrest  alias for $2;
  dbill alias for $3;
  nbill int;
  nulldate date;
  nullbill int;
  vpay record;
  vbill record;
  val_pay numeric;
  valtax_pay numeric;
  des numeric;
  counti1 alias for $4;
  counti int;
  vrest numeric;
  vrest_tax numeric;
  isbill int;
  mgbillpay date; 
  ord_pay int;
begin
  vrest=vvrest;
  counti=counti1+1;
  raise notice ''counti %'',counti;
  val_pay=0;
  valtax_pay=0;
  mgbillpay=fun_mmgg();
  raise notice ''mgbillpay - %'',mgbillpay;
  select into vpay p.id_doc,p.id_client,p.id_pref,p.mmgg,p.mmgg_pay,p.mmgg_hpay,
        p.value,p.value_tax,p.id_bill,coalesce(pb.rest,0) as rest,
              coalesce(pb.rest_tax,0) as rest_tax,p.id_client
             from acm_pay_tbl p left outer join 
                                (select * from acv_paybill where id_doc=vid_pay) pb 
                                on p.id_doc=pb.id_doc
                  where p.id_doc=vid_pay and (pb.rest>0 or pb.rest is null 
             or pb.rest_tax is null or pb.rest_tax!=0);
if found then
    select into ord_pay order_pay from clm_client_tbl where id=vpay.id_client;
    raise notice ''ordpay ---------------------- ,%'',ord_pay;
    raise notice ''vrest ---------------------- ,%'',vrest;
    raise notice ''vpay.rest ------------------ ,%'',vpay.rest;
    vrest=vpay.rest;
    vrest_tax=vpay.rest_tax;
     while vrest>0  or vrest_tax>0  loop 
     if not(dbill is NULL) then
       raise notice ''dbill not is NULL '';
          isbill=0;
           for  vbill in select b.id_doc,b.mmgg,b.id_client,b.value,b.value_tax,
               coalesce(bp.rest,0) as rest,coalesce(bp.rest_tax,0) as rest_tax
               from acm_bill_tbl b 
                     left outer join ( acv_billpay ) bp 
                    on b.id_doc=bp.id_doc
                  where b.mmgg_bill=dbill 
                 and b.id_client=vpay.id_client  and b.id_pref=vpay.id_pref 
                 and ((bp.rest!=0 or bp.rest is null) 
                   or (bp.rest_tax!=0 or bp.rest_tax is null)) 
                     order by b.mmgg,b.dat_e  loop
isbill=1;
                      raise notice ''vbill_id   -% '',vbill.id_doc;
                      raise notice ''vbill_rest   -% '',vbill.rest;
                      raise notice ''pay_rest   -% '',vpay.rest;
               if vbill.rest>=vpay.rest  then
		            val_pay=vpay.rest;
               end if;
               if  vbill.rest_tax>=vpay.rest_tax  then
		            valtax_pay=vpay.rest_tax;	     
	       end if;
	      if vbill.rest<=vpay.rest then
    		            val_pay=vbill.rest;
	      end if; 
	      if vbill.rest_tax<=vpay.rest_tax then
		            valtax_pay=vbill.rest_tax;   
	      end if; 
              if val_pay!=0 or valtax_pay!=0 then 

        	  mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;
 raise notice ''pay - %'',val_pay;
 raise notice ''valtax_pay - %'',valtax_pay;
-- raise notice ''vpay_mmgg - %'',vpay.mmgg;
                  insert into acm_billpay_tbl (id_bill,id_client,id_pay,value,value_tax,mmgg) values
                  (vbill.id_doc,vbill.id_client,vpay.id_doc,val_pay,valtax_pay,mgbillpay);

                 -- isbill=1;
              end if;
	     exit;
	   end loop;
        if isbill=0 then
          vrest= acc_payments_pay(vpay.id_doc,vrest,null,counti);
        end if;
      end if;
         --   date_trunc(''year'',b.mmgg_bill)=date_trunc(''year'',vpay.mmgg_pay)
	
      if dbill is  NULL then
        for vbill in select  b.id_doc,b.id_client,b.mmgg,b.reg_date,b.value_tax,
             coalesce(bp.rest,0) as rest,coalesce(bp.rest_tax,0) as rest_tax
             from acm_bill_tbl b left outer join acv_billpay bp on b.id_doc=bp.id_doc
                  where b.id_pref=vpay.id_pref and b.id_client=vpay.id_client 
                   and 
                    (case when ( ord_pay=0 and
                     (date_trunc(''year'',b.mmgg_bill)>=2006 and date_trunc(''year'',b.mmgg)>=2006) 
                      and (date_trunc(''year'',vpay.mmgg_pay) >=2006 and date_trunc(''year'',vpay.mmgg) >=2006) )
                     then 
                      1=1
                     else
                       date_trunc(''year'',vpay.mmgg_pay)= date_trunc(''year'',b.mmgg_bill)
                     end 
                    )
        	  and (bp.rest!=0 or bp.rest is null or bp.rest_tax!=0 or bp.rest_tax is null) 
                  order by b.mmgg,b.reg_date loop
		  raise notice ''dbill=null %'',vrest;
              if vbill.rest>=vpay.rest  then
		     val_pay=vpay.rest;
	      end if;
              if vbill.rest_tax>=vpay.rest_tax  then
		     valtax_pay=vpay.rest_tax;	     
	      end if;
	      if vbill.rest<vpay.rest then
		      val_pay=vbill.rest;
              end if;     
	      if vbill.rest_tax<vpay.rest_tax then
		      valtax_pay=vbill.rest_tax;   
              end if;     
	      if val_pay!=0 or valtax_pay!=0 then 
     	  mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;
          raise notice ''mgbillpay - %'',mgbillpay;
        raise notice ''vbill_mmgg - %'',vbill.mmgg;
          raise notice ''vpay_mmgg - %'',vpay.mmgg;
   
         	--     insert into acm_billpay_tbl (id_bill,id_pay,value,value_tax,mmgg) values
                -- (vbill.id_doc,vpay.id_doc,val_pay,valtax_pay,vpay.mmgg);
         insert into acm_billpay_tbl (id_bill,id_client,id_pay,value,value_tax,mmgg) values
              (vbill.id_doc,vbill.id_client,vpay.id_doc,val_pay,valtax_pay,mgbillpay);

	      end if;
         exit;
     end loop;
end if;
 
raise notice ''End_Rest %'',vrest;
-- des=vrest-val_pay-valtax_pay;
  if val_pay!=0 or valtax_pay!=0 then
     vrest= acc_payments_pay(vpay.id_doc,vrest-val_pay,null,counti);
   else vrest=0; 
     vrest_tax=0;
  end if;
   return vrest;
end loop;
 raise notice ''return %'',vrest;
 raise notice ''return %'',vrest_tax;
 return vrest;
else
 raise notice ''return1 %'',vrest;
 raise notice ''return1 %'',vrest_tax;
 return vrest;
end if; --loop;
end;
' LANGUAGE 'plpgsql';

*/
create function acc_payments_head(int) returns boolean as'
  declare 
     id_headp   alias for $1;
     vpay record;
     vrest numeric(14,2);
  begin
    for vpay in
           select p.id_doc,p.mmgg_pay,p.mmgg,p.mmgg_pay,p_value,p.id_bill,
            coalesce(v.rest,0) as rest
             from acm_pay_tbl p left outer join acv_paybill pb on p.id=pb.id_doc
                  where p.id_headpay=id_headp and (pv.rest!=0 or pv.rest is null)	     
        loop
	 vrest=vpay.rest;
	 while vrest>0 loop
	     acc_payments_pay(vpay.id_doc,vrest,vpay.mmgg_pay);	 
 	 end loop
         end loop;
     return true;
  end;
' LANGUAGE 'plpgsql';


drop function acc_payments_bill(int);
drop function acc_payments_bill1(int,numeric,int);

create function acc_payments_bill1 (int,numeric,int) returns numeric(14,4)  as '
declare 
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
begin 
  resb=rest_bill;
  val_pay=0;
  mgbillpay=fun_mmgg();
--if resb>0 then 
 select  into vbill b.id_doc,b.mmgg,b.mmgg_bill,b.id_client,b.reg_date,b.id_pref,b.value,b.value_tax 
       ,coalesce(pb.rest,0) as rest,coalesce(pb.rest_tax,0) as rest_tax
       from acm_bill_tbl b left outer join acv_billpay_paym pb on b.id_doc=pb.id_doc
      where b.id_doc=vid_bill and ((pb.rest>0 or pb.rest is null) 
        or (pb.rest_tax>0 or pb.rest_tax is null));
   if found then 
   resb=vbill.rest;
   resb_tax=vbill.rest_tax;
/*
    while resb>0 or resb_tax>0 loop
*/
       val_pay=0; 
       valtax_pay=0; 
       raise notice ''id_bill %'',vbill.id_doc ;
       isbill=0;
       for vpay in 
         select p.id_doc,p.id_pref,p.mmgg,p.mmgg_pay,coalesce(p.value,0) as value,
         p.mmgg_pay,coalesce(pb.rest,0) as rest ,coalesce(pb.rest_tax,0) as rest_tax 
         ,p.id_client
         from acm_pay_tbl p left outer join 
           ( select * from acv_paybill where id_client=vbill.id_client) pb  
          on      p.id_doc=pb.id_doc
         where p.id_client=vbill.id_client and p.id_pref=vbill.id_pref 
         and date_trunc(''year'',vbill.mmgg_bill)=
               date_trunc(''year'',p.mmgg_pay)
          and (((pb.rest is null or pb.rest<>0) and vbill.rest<>0) 
             or ((pb.rest_tax is null or pb.rest_tax<>0) and vbill.rest_tax<>0)
          ) 
            ORDER BY p.mmgg, p.reg_date
       loop
          isbill=1; 
          raise notice '' vbill.rest %'',vbill.rest;           
          raise notice ''vpay.rest %'',vpay.rest;
          raise notice '' vbill.rest_tax %'',vbill.rest_tax;           
          raise notice ''vpay.rest_tax %'',vpay.rest_tax;
          
          if   vpay.rest>vbill.rest  then
               val_pay=vbill.rest;
          end if;
          if   vpay.rest_tax>vbill.rest_tax  then
               valtax_pay=vbill.rest_tax;	     
          end if;
          if (vpay.rest<=vbill.rest and vbill.rest<>0) then
                  val_pay=vpay.rest;
          end if; 
          if (vpay.rest_tax<=vbill.rest_tax and vbill.rest_tax<>0) then
                 valtax_pay=vpay.rest_tax;   
          end if; 
          raise notice '' val_pay ------ %'',val_pay;
          raise notice '' valtax_pay ------ %'',valtax_pay;
          if val_pay!=0 or valtax_pay!=0 then 
            mgbillpay=max(mgbillpay,max(vbill.mmgg,vpay.mmgg)::date)::date;
--          raise notice ''mgbillpay - %'',mgbillpay;
            raise notice ''res_b - %'',resb;
           raise notice ''res_btax - %'',resb_tax;
   
            insert into acm_billpay_tbl (id_bill,id_client,id_pay,value,value_tax,mmgg) values
                  (vbill.id_doc,vbill.id_client,vpay.id_doc,val_pay,valtax_pay,mgbillpay);
            resb=resb-val_pay;
            resb_tax=resb_tax-valtax_pay;
          end if;

        exit;
       end loop;
       if resb<0 or resb_tax<0 then
        Raise Notice ''resb < 0 , %'',resb;
        Raise Notice ''or resb_tax < 0, %'',resb_tax;
        --return 0;
        --exit;
       end if;
         Raise Notice ''isbill  - %'',isbill;
      if ((resb!=0 or resb_tax!=0) and isbill!=0) then
        raise notice '' recurs - %'',resb;
        raise notice '' recurs tax - %'',resb_tax;
       resb= acc_payments_bill(vbill.id_doc,resb,cou);
      else 
       resb=0;
       resb_tax=0;
      end if;

--    end loop; ----while
else
return resb;
end if;
/*
else
 select  into vbill b.id_doc,b.mmgg,b.mmgg_bill,b.id_client,b.reg_date,b.id_pref,b.value,b.value_tax 
       from acm_bill_tbl b 
      where b.id_doc=vid_bill;
  if found then 
  insert into acm_billpay_tbl (id_bill,id_pay,value,value_tax) values
                  (vbill.id_doc,null,0,0);
  end if;
--end if;
*/

return resb;
end;
' LANGUAGE 'plpgsql';

drop function repayment (int,int); 
create or replace function repayment (int,int) returns boolean  as '
declare 
  vid_client alias for $1;
  vid_pref alias for $2;
  vbill record;
   vpay record;
  vrest numeric;
begin
  raise notice ''repayment'';

for  vbill  in select b.id_doc,b.mmgg,b.mmgg_bill,b.id_client,b.reg_date,b.id_pref,b.value,b.value_tax 
       ,coalesce(pb.rest,0) as rest,coalesce(pb.rest_tax,0) as rest_tax
       from ( select * from acm_bill_tbl where id_client=vid_client 
                and id_pref=vid_pref) b 
       left outer join (Select * from acv_billpay where id_client=vid_client) pb on b.id_doc=pb.id_doc
      where  (pb.rest>0 or pb.rest is null or 
            pb.rest_tax is null or pb.rest_tax!=0) 
       order by b.mmgg,b.reg_date 
     loop
/*
select p.*,
              case when p.value>0 then p.reg_date else bom(p.mmgg) end  as dat_r  
             from acm_pay_tbl  p where id_client=vbill.id_client) p 
            left outer join 
           (select * from acv_paybill where id_client=vbill.id_client)          
            pb on  p.id_doc=pb.id_doc
          where (resb!=0 or resb_tax!=0)
                                        */
     raise notice ''repayment bill 11 % '',vbill.id_doc;
      select into vpay p.id_doc,p.id_pref,p.mmgg,p.mmgg_pay,p.mmgg_hpay,
        p.reg_date, p.value,p.value_tax,p.id_bill,coalesce(pb.rest,0) as rest,
              coalesce(pb.rest_tax,0) as rest_tax,p.id_client
             from (select p.* from acm_pay_tbl p, acv_paybill pb  where 
                   p.id_client=vid_client and p.id_doc=pb.id_doc 
                   and (pb.rest<>0 or pb.rest_tax<>0) 
                   and id_pref=vid_pref) p 
               left outer join 
                 (Select * from acv_billpay where id_client=vid_client 
                  and ((rest is null or rest<>0) or (rest_tax is null or rest_tax<>0)) order by id_doc) 
               pb on p.id_doc=pb.id_doc
            where  (((pb.rest is null or pb.rest<>0) and vbill.rest<>0) 
             or ((pb.rest_tax is null or pb.rest_tax<>0) and vbill.rest_tax<>0))
        order by p.mmgg,p.reg_date;
raise notice ''end '';
      if not  found then
        exit;
      end if;
        raise notice ''repayment pay  % '',vpay.id_doc;
        raise notice ''repayment vbill.id_doc  % '',vbill.id_doc;
        raise notice ''repayment vbill.rest % '',vbill.rest;
       vrest=acc_payments_bill(vbill.id_doc,vbill.rest,1) ;
       raise notice ''vrest  % '',vrest;
    end loop;
return true;
end;
' LANGUAGE 'plpgsql';
