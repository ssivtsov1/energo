alter table acm_headpay_tbl add column b_sum numeric (14,2);
alter table acm_headpay_tbl alter column b_sum set default 0;
alter table acm_headpay_tbl add column dt_sum numeric (14,2);
alter table acm_headpay_tbl alter column dt_sum set default 0;
alter table acm_headpay_tbl add column kt_sum numeric (14,2);
alter table acm_headpay_tbl alter column kt_sum set default 0;
alter table acm_headpay_tbl add column e_sum numeric (14,2);
alter table acm_headpay_tbl alter column e_sum set default 0;

drop trigger payhead_del on acm_headpay_tbl;
drop function fun_payhead_del();

create function fun_payhead_del() returns opaque as'
Declare
  begin 
if old.flock=1 then 
  RAISE EXCEPTION ''Closed Data.'';
end if;    
    delete from acm_pay_tbl where id_headpay=old.id;
  Return old;  
end;     
' Language 'plpgsql';


create trigger payhead_del
    Before Delete ON acm_headpay_tbl
    For Each Row Execute Procedure fun_payhead_del();



drop trigger pay_del on acm_pay_tbl;
drop function fun_pay_del();
 /*--------------------------------------------------------------*/
create function fun_pay_del() returns opaque as '
Declare 
pay record;
fl_ins int;
tr_pay record;
begin

 fl_ins=1;
if old.flock=1 then
   RAISE EXCEPTION ''CLOSED DATA'';
end if;

update acm_saldo_tbl 
     set kt_val=kt_val-old.value,
        kt_valtax=kt_valtax-old.value_tax,
	e_val=b_val+dt_val-(kt_val-old.value),
	e_valtax=b_valtax+dt_valtax-(kt_valtax-old.value_tax)
   where id_client=old.id_client and id_pref=old.id_pref  and mmgg=old.mmgg;

delete from acm_billpay_tbl where id_pay=old.id_doc and flock<>1;
Return old;
end;'
 Language 'plpgsql';

create trigger pay_del
    Before Delete ON acm_pay_tbl
    For Each Row Execute Procedure fun_pay_del();
    
drop trigger pay_del_aft on acm_pay_tbl;
drop function fun_pay_del_aft();
 /*--------------------------------------------------------------*/
create function fun_pay_del_aft() returns opaque as '
Declare 
res boolean;
begin
   res=repayment(old.id_client,old.id_pref);
return old;
end;'
 Language 'plpgsql';

create trigger pay_del_aft
    after Delete ON acm_pay_tbl
    For Each Row Execute Procedure fun_pay_del_aft();
    
    
drop trigger pay_ins on acm_pay_tbl;
drop function fun_pay_ins();
 /*--------------------------------------------------------------*/
create function fun_pay_ins() returns opaque as '
Declare 
pay record;
fl_ins int;
res numeric;
begin
 fl_ins=1;
  for pay in select id from acm_saldo_tbl 
   where  id_client=new.id_client and id_pref=new.id_pref   and mmgg=new.mmgg
   loop
    fl_ins=0;
  end loop;
  if fl_ins=1 then
    insert into acm_saldo_tbl(id_client,mmgg,id_pref,
     kt_val,kt_valtax,e_val,e_valtax) 
       values (new.id_client,new.mmgg,new.id_pref,
       new.value,new.value_tax,-new.value,-new.value_tax);
  else
   update acm_saldo_tbl 
     set kt_val=kt_val+new.value,
        kt_valtax=kt_valtax+new.value_tax,
	e_val=b_val+dt_val-(kt_val+new.value),
	e_valtax=b_valtax+dt_valtax-(kt_valtax+new.value_tax)
   where id_client=new.id_client and id_pref=new.id_pref  and mmgg=new.mmgg;
end if;

   res=acc_payments_pay(new.id_doc,new.value,new.mmgg_pay,0);
    Return new;
end;'
 Language 'plpgsql';

create trigger pay_ins
    After INSERT ON acm_pay_tbl
    For Each Row Execute Procedure fun_pay_ins();    
    
drop trigger pay_upd on acm_pay_tbl;
drop function fun_pay_upd();
 /*--------------------------------------------------------------*/
create function fun_pay_upd() returns opaque as '
Declare 
pay record;
fl_ins int;
res numeric;
tr_pay record;
begin

------------------------------
-- old
fl_ins=1;
 if (old.flock=1 and new.flock<>0) then
   RAISE EXCEPTION ''CLOSED DATA'';
end if;

update acm_saldo_tbl 
     set kt_val=kt_val-old.value,
        kt_valtax=kt_valtax-old.value_tax,
	e_val=b_val+dt_val-(kt_val-old.value),
	e_valtax=b_valtax+dt_valtax-(kt_valtax-old.value_tax)
    where id_client=old.id_client and id_pref=old.id_pref  and mmgg=old.mmgg;

delete from acm_billpay_tbl where id_pay=old.id_doc and flock<>1;

--------------------  new 
 fl_ins=1;
 for pay in select id from acm_saldo_tbl 
   where  id_client=new.id_client and id_pref=new.id_pref   and mmgg=new.mmgg
   loop
    fl_ins=0;
  end loop;
  if fl_ins=1 then
    insert into acm_saldo_tbl(id_client,mmgg,id_pref,
     kt_val,kt_valtax,e_val,e_valtax) 
       values (new.id_client,new.mmgg,new.id_pref,
       new.value,new.value_tax,-new.value,-new.value_tax);
  else

   update acm_saldo_tbl 
     set kt_val=kt_val+new.value,
        kt_valtax=kt_valtax+new.value_tax,
	e_val=b_val+dt_val-(kt_val+new.value),
	e_valtax=b_valtax+dt_valtax-(kt_valtax+new.value_tax)
        where id_client=new.id_client and id_pref=new.id_pref  and mmgg=new.mmgg;
end if;
Return new;
end;'
 Language 'plpgsql';

create trigger pay_upd
    before update ON acm_pay_tbl
    For Each Row Execute Procedure fun_pay_upd();        


drop trigger pay_upd_aft on acm_pay_tbl;
drop function fun_pay_upd_aft();
 /*--------------------------------------------------------------*/

create function fun_pay_upd_aft() returns opaque as '
Declare 
res numeric;
tr_pay record;
res1 boolean;
begin
 raise notice ''pay_upd'';
 res=acc_payments_pay(new.id_doc,new.value,new.mmgg_pay,0);
 --res1=repayment(new.id_client,new.id_pref); 
if ( new.id_pref<>old.id_pref or new.id_client<>old.id_client 
     or new.value<>old.value or new.value_tax<> old.value_tax
     or new.mmgg_pay<>old.mmgg_pay) then
 res1=repayment(old.id_client,old.id_pref);
 end if;

--   res=repayment(old.id_client,old.id_pref);
   

Return new;
end;'
 Language 'plpgsql';

create trigger pay_upd_aft
    after update ON acm_pay_tbl
    For Each Row Execute Procedure fun_pay_upd_aft();        
    