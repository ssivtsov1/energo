drop function del_desc(integer);

create function del_desc(integer) returns boolean as'
Declare
idp Alias for $1;
ch_r record;
i smallint;

begin
 select into i id_tree from eqm_eqp_tree_tbl where code_eqp=idp;

 if not eqmterm_pr(idp,i) then
  for ch_r in select code_eqp from eqm_eqp_tree_tbl where code_eqp_e=idp loop
   EXECUTE ''select del_desc(''||ch_r.code_eqp||'')'';
  end loop;
 else
  delete from eqm_equipment_tbl where id=idp;
 end if;

Return true;
end;
' Language 'plpgsql';