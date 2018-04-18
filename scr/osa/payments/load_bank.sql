alter table  acm_headpay_tbl add column name_file numeric(8);
alter table  acm_pay_tbl add column bank_flag int;
alter table  acm_pay_tbl add column fix int;
insert into syi_sysvars_tbl (id,ident,value_ident) values (300,'path_bank','.\\dbf\\'); 

--drop table acm_loadpay_tbl;
create sequence acm_loadpay_seq; 
create table  acm_loadpay_tbl
( id_doc      int,
  id          int default nextval('acm_loadpay_seq'), 
  mfo_res     int,
  account_res numeric (14),
  reg_num     varchar (15),
  reg_date    date,
  pay_date    date,
  id_client   int,
  okpo_client varchar(10),
  name_client varchar(200),
  mfo_client  int,
  account_client varchar(14),
  comment varchar( 255),
  value numeric(14,2),
  value_pay numeric(14,2),
  value_tax numeric(14,2),
  sign_pay integer,
  id_pref integer,
  mmgg_pay date,-- DEFAULT fun_mmgg(),
  mmgg_hpay date DEFAULT fun_mmgg(),
  mmgg date DEFAULT fun_mmgg(),
  flag_add int,
  flock integer DEFAULT 0
);

alter table acm_loadpay_tbl add column id int;
alter table acm_loadpay_tbl alter column id set default nextval('acm_loadpay_seq');

drop function LoadBankScr( int); 
create or replace function LoadBankScr( int) returns varchar AS 
'
declare 
num alias for $1;
ret varchar;
recload record;
rechead record;
id_kindpay int;
begin
ret=''____'';
for rechead in  select * from acm_headpay_tbl where name_file=num loop
    if rechead.flock=1 then
     ret=''Закрытый период! Загрузка невозможна!'';
      return ret;
    end if;
    raise notice ''rechead.id % '',rechead.id;
    update acm_pay_tbl set bank_flag=num 
       where acm_pay_tbl.id_headpay=rechead.id and bank_flag=1;
    delete from acm_pay_tbl where bank_flag=num;
    for recload in select * from acm_loadpay_tbl 
        where flag_add=1 and (id_client is null or id_pref is null or mmgg_pay is null) loop
            ret='' Загрузка невозможна для платежки  - ''||recload.reg_num||''Проверте вид оплаты, период оплаты и код клиента'';
            return ret;
      end loop;

select into id_kindpay  id from dci_document_tbl where ident=''pay'';
    for recload in select * from acm_loadpay_tbl  where flag_add=1  loop
      insert into acm_pay_tbl (id_headpay,idk_doc,sign_pay,reg_num,reg_date,
        id_client,mfo_client,account_client,
        pay_date,value_pay,value_tax,value,id_pref,comment,mmgg , mmgg_pay,bank_flag  )
        values (
          rechead.id,id_kindpay ,recload.sign_pay,recload.reg_num,recload.reg_date,
              recload.id_client,recload.mfo_client,recload.account_client, 
             recload.pay_date,recload.value_pay,recload.value_tax,recload.value,recload.id_pref,recload.comment,recload.mmgg,
           recload.mmgg_pay ,1);
     end loop;


end loop;
 ret='' Загрузка завершена успешно!'';
            return ret;


end;
' 
language 'plpgsql'; 
