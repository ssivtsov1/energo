
select crt_ttbl();

--update syi_sysvars_tmp set value_ident='01.08.2005' where ident='mmgg';

drop function err_pay_client(int);
create or replace function err_pay_client(int) returns boolean as
'
declare     id_cli int;
              cli alias for $1;
              ret boolean; 
begin
  select into id_cli min(id) from clm_client_tbl where code=cli and book<0;
 if not found then
   raise exception ''Client not found!'';
 end if;
  ret=err_pay_bill(id_cli);
return true;
end;
' language 'plpgsql';



drop function err_pay_bill(int);
create or replace function err_pay_bill(int) returns boolean as
' declare id_cli alias for $1;
           del_id record;
           vbill record;
           mgd date;
           mgclose date;
           pr boolean;
           SSQL text;  
begin

   mgd=fun_mmgg();

update acm_billpay_tbl set id_client=p.id_client from acm_pay_tbl p 
 where acm_billpay_tbl.id_pay=p.id_doc and acm_billpay_tbl.id_client is null;


for  del_id in select id_doc from acm_bill_tbl  where id_client=id_cli
loop
 delete from acm_billpay_tbl where id_bill=del_id.id_doc  and flock<>1;  
end loop;
 delete from acm_billpay_tbl where id_client=id_cli  and flock<>1;  

                           
for vbill in select b.id_doc from 
       ( select * from acm_bill_tbl where id_client=id_cli 
         and (value<0 or value_tax<0)
       ) b 
       left join (select * from acv_billpay where id_client=id_cli and 
                  (rest<>0 or rest_tax<>0) 
       ) bv  on bv.id_doc=b.id_doc
   where bv.id_doc is not null 
  order by b.mmgg, b.mmgg_bill  loop
     update acm_bill_tbl set flock=0 where id_doc=vbill.id_doc; 
end loop;
                             
--for vbill in select id_doc from acm_bill_tbl where id_client=id_cli 
-- and (value>=0 and value_tax>=0) --and flock<>1
 -- order by mmgg, mmgg_bill --,case when value>0 then reg_date else bom(mmgg) end  
--  loop
for vbill in select b.id_doc from 
       ( select * from acm_bill_tbl where id_client=id_cli 
         and (value>=0 or value_tax>=0)
       ) b 
       left join (select * from acv_billpay where id_client=id_cli and 
                  (rest<>0 or rest_tax<>0) 
       ) bv  on bv.id_doc=b.id_doc
   where bv.id_doc is not null 
  order by b.mmgg, b.mmgg_bill  loop

     update acm_bill_tbl set flock=0 where id_doc=vbill.id_doc; 
end loop;
mgclose=fun_mmgg(1); 
SSQL=''update acm_bill_tbl set flock=1 where mmgg<''''''||mgclose::varchar||'''''' and flock=0'';

raise notice '' %'',SSQL;

pr=del_NoTrigger(''acm_bill_tbl'',SSQL);

return true;
end;
 ' language 'plpgsql';

select now();


drop function err_pay_bill_all();
create or replace function err_pay_bill_all() returns boolean as
'  declare      id_cli int;
                del_id record;
                cli record;
                mgd date;
                ret boolean;
begin
 for cli in select id,code  from clm_client_tbl where book=-1 
        order by code 
  loop
     raise notice ''licevoy ================= % '',cli.code;
     ret=err_pay_bill(cli.id);
  end loop;
 return true;
end;
 ' language 'plpgsql';

select now();
--select err_pay_all();
select now();