drop function eqmterm_pr(integer,integer,int);

create function eqmterm_pr(integer,integer,int) returns boolean as' --check for descendants
Declare
 idp Alias For $1;
 idt Alias For $3;
 clone Alias For $2;
 k integer;
 r record;
begin
if clone>0 then 
  Return true;
end if;
k:=0;

select into k count(code_eqp) from eqm_eqp_tree_tbl where code_eqp_e=idp and id_tree=idt;

if k>0 then
 Return false;
else
 Return true;
end if;
end;
' language 'plpgsql';