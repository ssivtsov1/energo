create or replace function calc_client (int,date) returns boolean as
'declare
 cod_cl alias for $1;
 dat alias for $2;
id_cl record;
datr date;
report int;
ret boolean;
begin 

ret=false;

for  id_cl in select id from clm_client_tbl where code=cod_cl and book=-1 loop
  if dat is null then
     select into report max(id_doc) from acm_headindication_tbl where id_client=id_cl.id
    and mmgg=(select max(mmgg) from acm_headindication_tbl where id_client=id_cl.id
     and idk_document=310) and idk_document=310;
     raise notice ''report  %'',report;
  else 
    select into report max(id_doc) from acm_headindication_tbl where id_client=id_cl.id
    and mmgg=dat and idk_document=310;
     raise notice ''report  %'',report;
  end if;
   ret=start_calc(id_cl.id,report, null);
end loop;
return ret;

end
' language 'plpgsql';

--select crt_ttbl();


--select calc_client(51,null);



