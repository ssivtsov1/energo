select crt_ttbl();

create or replace function seb_recalc_plan(date) returns bool as
'declare 
pmmgg alias for $1;
dmmgg date;
pr bool;
begin

dmmgg=pmmgg;
while dmmgg<=bom(now()::date) loop
raise notice '' %'',dmmgg;
  pr=seb_plan_full(dmmgg);
  pr=seb_plan_rep(dmmgg);
dmmgg=(dmmgg::date+ interval ''1 month'');
end loop;
return true;
end
' language  'plpgsql';

select now();
select seb_recalc_plan('2010-01-01'::date);
select now();