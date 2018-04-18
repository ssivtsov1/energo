--

create or replace function eqm_copy_all_fun(int,int,date) Returns int As'
Declare
psclient Alias for $1;
pdclient Alias for $2;
pnewdate  Alias for $3;

vtype int;
vtree int;
r record;
rs int;
pnewid int;
vsidclient int;
vdidclient int;

begin

-- perform crt_ttbl();

 select into vsidclient id from clm_client_tbl where code = psclient and book = -1;
 select into vdidclient id from clm_client_tbl where code = pdclient and book = -1;

 perform eqt_change_fun( 2, NULL, pnewdate, vdidclient, NULL, 1);

 --площадки
 for r in select * from eqm_equipment_tbl as eq join eqm_area_tbl as a on (a.code_eqp = eq.id)  where a.id_client = vsidclient
 loop

   select into pnewid eqm_neweqp_fun(type_eqp,name_eqp,num_eqp,id_addres,pnewdate,pnewdate,loss_power,is_owner)
   from eqm_equipment_tbl where id = r.id; 

   insert into  eqm_area_tbl (code_eqp,id_client) values (pnewid,vdidclient);

 end loop;

 --схема
 for r in select * from eqm_tree_tbl as t where t.id_client = vsidclient
 loop

  vtree:=eqi_newtree_fun(r.name,NULL,vdidclient);
  rs:=eqm_copy_tree_fun(vsidclient,vdidclient,r.id,r.code_eqp,vtree,NULL,pnewdate);

 end loop;



 RETURN 0;
end;
' Language 'plpgsql';





--select eqm_copy_all_fun(165,399,'2007-01-01');



