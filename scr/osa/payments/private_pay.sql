create sequence acm_headpayp_seq;

CREATE TABLE acm_headpayp_tbl (
    id integer DEFAULT nextval('acm_headpayp_seq'::text) NOT NULL,
    dt timestamp,
    id_person integer,
    id_client int,
    mfo_bank  int,
    reg_date date,
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0
);


create sequence acm_payp_seq;

CREATE TABLE acm_payp_tbl (
    id  integer DEFAULT nextval('acm_payp_seq') NOT NULL,
    id_headpay integer,
    dt timestamp,
    nom integer,
    id_person integer DEFAULT getsysvar('id_person'),
    comment varchar(25),
    value_pay numeric(14,2),
    value numeric(14,2),
    value_tax numeric(14,2),
    mmgg_pay date DEFAULT fun_mmgg(),
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0,
primary key (id_headpay,id)    
);

alter table acm_payp_tbl add column nom integer;
create sequence acm_paypsum_seq;

CREATE TABLE acm_paypsum_tbl (
   
    id  integer DEFAULT nextval('acm_payp_seq'::text) NOT NULL,
    id_headpay integer,
    id_pay  integer,
    dt timestamp without time zone,
    id_person integer DEFAULT getsysvar('id_person'::character varying),
    value_pay numeric(14,2),
    value numeric(14,2),
    value_tax numeric(14,2),
    mmgg_pay date DEFAULT fun_mmgg(),
    mmgg date DEFAULT fun_mmgg(),
    flock integer DEFAULT 0
    
);



drop trigger payphead_del on acm_headpayp_tbl;
drop function fun_payphead_del();

create function fun_payphead_del() returns opaque as'
Declare
  begin 
if old.flock=1 then 
  RAISE EXCEPTION ''Closed Data.'';
end if;    
    delete from acm_payp_tbl where id_headpay=old.id;
    delete from acm_paypsum_tbl where id_headpay=old.id;
  Return old;  
end;     
' Language 'plpgsql';


create trigger payphead_del
    Before Delete ON acm_headpayp_tbl
    For Each Row Execute Procedure fun_payphead_del();



drop trigger payp_del on acm_payp_tbl;
drop function fun_payp_del();
 /*--------------------------------------------------------------*/
create function fun_payp_del() returns opaque as '
Declare 
pay record;
fl_ins int;
tr_pay record;
begin

 fl_ins=1;
if old.flock=1 then
   RAISE EXCEPTION ''CLOSED DATA'';
end if;

Return old;
end;'
 Language 'plpgsql';

create trigger payp_del
    Before Delete ON acm_payp_tbl
    For Each Row Execute Procedure fun_payp_del();
    

drop trigger paypsum_del on acm_paypsum_tbl;
drop function fun_paypsum_del();
 /*--------------------------------------------------------------*/
create function fun_paypsum_del() returns opaque as '
Declare 
pay record;
fl_ins int;
tr_pay record;
begin

 fl_ins=1;
if old.flock=1 then
   RAISE EXCEPTION ''CLOSED DATA'';
end if;
delete from acm_pay_tbl where id_doc=old.id_pay;
Return old;
end;'
 Language 'plpgsql';

create trigger paypsum_del
    Before Delete ON acm_paypsum_tbl
    For Each Row Execute Procedure fun_paypsum_del();

drop trigger paypsum_upd on acm_paypsum_tbl;
drop function fun_paypsum_upd();
 /*--------------------------------------------------------------*/
create function fun_paypsum_upd() returns opaque as '
Declare 
pay record;
fl_ins int;
tr_pay record;
begin

 fl_ins=1;
if old.flock=1 then
   RAISE EXCEPTION ''CLOSED DATA'';
end if;
update acm_pay_tbl set value_pay=new.value_pay, 
                       value=new.value,
                       value_tax=new.value_tax 
    where id_doc=old.id_pay;
Return new;
end;'
 Language 'plpgsql';

create trigger paypsum_upd
    Before Update ON acm_paypsum_tbl
    For Each Row Execute Procedure fun_paypsum_upd();

create or replace function calc_pay_priv(int,int) returns boolean as '
declare
head alias for $1;
flag alias for $2;
rec_head record;
psum record;
pay record;
hpay record;
account record;
pid_pref int;
idk_pay int; 
pid_pay int;
begin

pid_pref=10;
select into rec_head * from acm_headpayp_tbl where id=head;
if not found then
raise exception ''Нет заголовка платежей !!!!'';
return false;
end if;


select into idk_pay id from dci_document_tbl where ident=''pay'';
if not found then
raise exception ''Нет вида платежей !!!!'';
return false;
end if;

select into account * from cli_account_tbl 
  where id_client=syi_resid_fun() and ident=''act_ee'';
 if not found then
    raise exception ''Нет расчетного счета РЕС за активную ЕЕ. Нонсенс!!!'';
  end if;


insert into acm_paypsum_tbl (dt,id_headpay,mmgg_pay)
     select distinct now(),bb.id_headpay,bb.mmgg_pay
     from 
       (select distinct b.id_headpay, b.mmgg_pay
             from (select * from acm_payp_tbl where id_headpay=head) as b 
               left join (select * from acm_paypsum_tbl where id_headpay=head)  s1 
            on (s1.id_headpay=head and 
                s1.mmgg_pay=b.mmgg_pay and s1.id_headpay=b.id_headpay
             )
            where s1.id is null
       ) as bb; 

raise notice ''update '';

update acm_paypsum_tbl set value_pay=coalesce(cnt.value_pay,0),
                           value=coalesce(cnt.value,0),
                           value_tax=coalesce(cnt.value_tax,0)
       from 
          (select d.id_headpay,
           d.mmgg_pay,
           sum(d.value) as value,sum(d.value_tax) as value_tax,
            sum(d.value_pay) as value_pay
           from acm_payp_tbl as d 
             where d.id_headpay=head
           group by d.id_headpay,d.mmgg_pay 
        ) as cnt
       where   cnt.id_headpay=acm_paypsum_tbl.id_headpay and
         cnt.mmgg_pay=acm_paypsum_tbl.mmgg_pay
          and acm_paypsum_tbl.id_headpay=head; 

if flag=1 then

for psum in select * from acm_paypsum_tbl where id_headpay=head loop
 select into pay * from acm_pay_tbl 
    where id_doc=psum.id_pay and psum.id_pay is not null; 
  if not found then
      select into hpay * from acm_headpay_tbl where mmgg=psum.mmgg and 
             mfo_self=account.mfo and account_self=account.account and
             reg_date=rec_head.reg_date; 
       if not found   then
         insert into acm_headpay_tbl (dt,reg_num,reg_date,
                     mfo_self,account_self, mmgg,mmgg_hpay)
          values(now(),''A_''||rec_head.reg_num,rec_head.reg_date,
                       account.mfo,account.account,rec_head.mmgg,rec_head.mmgg);
   
         select into hpay * from acm_headpay_tbl where mmgg=psum.mmgg and 
             mfo_self=account.mfo and account_self=account.account and
             reg_date=rec_head.reg_date; 
       end if; 
     insert into acm_pay_tbl (dt,id_headpay,id_pref,reg_num,reg_date,
            id_client,mfo_client,pay_date,value_pay,value,value_tax,sign_pay,
            idk_doc,mmgg_pay,mmgg )
          values (now(),rec_head.id,pid_pref,''A_''||rec_head.reg_num,rec_head.reg_date,
            rec_head.id_client,rec_head.mfo,rec_head.reg_date,
            psum.value_pay,psum.value,psum.value_tax,1,idk_pay,
            psum.mmgg_pay,psum.mmgg);
        pid_pay=currval(''dcm_doc_seq'');
      update acm_paypsum_tbl set id_pay=pid_pay where id=psum.id; 
  else 
   update acm_pay_tbl set value_pay=psum.value_pay,value=psum.value,
        value_tax=psum.value_tax where id_doc=psum.id_pay;
  end if;

end loop;
end if;
return true;
end;


' language 'plpgsql';