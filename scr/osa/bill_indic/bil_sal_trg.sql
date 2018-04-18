CREATE INDEX acd_billsum_doc_idx
  ON acd_billsum_tbl
  USING btree
  (id_doc);

drop trigger bill_upd_trg on acm_bill_tbl;
drop function bill_upd_fun();

drop trigger bill_ins_trg on acm_bill_tbl;
drop function bill_ins_fun();

-------------------------==========================-----------------
create or replace function bill_ins_fun() returns opaque as'
declare 
  fl_ins int;
  vbill  record;
  tr_pay record;
  restb numeric;
begin
------------------------------
-- new 

 raise notice ''%  %  %  '',new.id_client,new.id_pref,new.mmgg;
 fl_ins=1;
  for vbill in select id from acm_saldo_tbl 
   where  id_client=new.id_client and id_pref=new.id_pref   and mmgg=new.mmgg
   loop
    fl_ins=0;
  end loop;
   if fl_ins=1 then
    insert into acm_saldo_tbl(id_client,mmgg,id_pref,
     dt_val,dt_valtax,e_val,e_valtax) 
       values (new.id_client,new.mmgg,new.id_pref,
       new.value,new.value_tax,new.value,new.value_tax);
   else
     update acm_saldo_tbl 
     set dt_val=dt_val+coalesce(new.value,0),
        dt_valtax=dt_valtax+coalesce(new.value_tax,0),
	e_val=b_val+(dt_val+coalesce(new.value,0))-kt_val,
	e_valtax=b_valtax+(dt_valtax+coalesce(new.value_tax,0))-kt_valtax
    where id_client=new.id_client and id_pref=new.id_pref  and mmgg=new.mmgg;
   end if;
   restb=acc_payments_bill(new.id_doc,new.value,0); 
  Return new;
  end; 
' LANGUAGE 'plpgsql';
 
-- создание триггера для acm_bill_tbl
    
create trigger bill_ins_trg after insert
    on acm_bill_tbl for each row
    execute procedure  bill_ins_fun();

-------------------------==========================-----------------
-- обновление saldo и снятие погашения (before update bill)

create or replace function bill_upd_fun() returns opaque as'
declare 
  fl_ins int;
  vbill  record;
   tr_pay record;
   restb numeric;
begin
 if (old.flock=1 and new.flock<>0) then
   raise exception ''bill %'',old.id;
   RAISE EXCEPTION ''CLOSED DATA'';
end if;

------------------------------
-- old
 fl_ins=1;
   update acm_saldo_tbl 
     set dt_val=dt_val-coalesce(old.value,0),
        dt_valtax=dt_valtax-coalesce(old.value_tax,0),
	e_val=b_val+(dt_val-coalesce(old.value,0))-kt_val,
	e_valtax=b_valtax+(dt_valtax-coalesce(old.value_tax,0))-kt_valtax
   where id_client=old.id_client and id_pref=old.id_pref  and mmgg=old.mmgg;


  delete from acm_billpay_tbl where id_bill=old.id_doc and flock<>1;
-----------------------------
-- new 
 fl_ins=1;
  for vbill in select id from acm_saldo_tbl 
   where  id_client=new.id_client and id_pref=new.id_pref   and mmgg=new.mmgg
   loop
    fl_ins=0;
  end loop;

  if fl_ins=1 then
     insert into acm_saldo_tbl(id_client,mmgg,id_pref,
     dt_val,dt_valtax,e_val,e_valtax) 
       values (new.id_client,new.mmgg,new.id_pref,
       new.value,new.value_tax,new.value,new.value_tax);
   else
   update acm_saldo_tbl 
     set dt_val=dt_val+coalesce(new.value,0),
        dt_valtax=dt_valtax+coalesce(new.value_tax,0),
	e_val=b_val+(dt_val+coalesce(new.value,0))-kt_val,
	e_valtax=b_valtax+(dt_valtax+coalesce(new.value_tax,0))-kt_valtax
   where id_client=new.id_client and id_pref=new.id_pref  and mmgg=new.mmgg;
  end if;
Return new;
  end;  -- function acm_bill_trf3
' LANGUAGE 'plpgsql';
 
-- создание триггера для acm_bill_tbl

-- триггеры на редактирование счета
-- (Процедуры писала Оксана)

    
create trigger bill_upd_trg before UPDATE
    on acm_bill_tbl for each row
    execute procedure  bill_upd_fun();

drop trigger bill_upd_aft on acm_bill_tbl;
drop function fun_bill_upd_aft();

create function fun_bill_upd_aft() returns opaque as '
Declare 
res numeric;
tr_pay record;
res1 boolean;
begin
-- res1=repayment(new.id_client,new.id_pref);
res=acc_payments_bill(new.id_doc,new.value,0); 
 if ( new.id_pref<>old.id_pref or new.id_client<>old.id_client 
     or new.value<>old.value or new.value_tax<> old.value_tax) then
 res1=repayment(old.id_client,old.id_pref);
 end if;
Return new;
end;'
 Language 'plpgsql';

create trigger bill_upd_aft
    after update ON acm_bill_tbl
    For Each Row Execute Procedure fun_bill_upd_aft();        
