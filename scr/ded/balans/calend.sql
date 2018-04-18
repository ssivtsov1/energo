create or replace function cal_days_fun(date,date) Returns Int As'
Declare
 pdt_b Alias for $1;
 pdt_e Alias for $2;
 v int;
begin

select into v count(*) from calendar where c_date>=pdt_b and c_date<=pdt_e and coalesce(holiday,false) = false; 

if v = 0 then v :=1; end if;

return v;
end;
' Language 'plpgsql';


create or replace function cal_daysall_fun(date,date) Returns Int As'
Declare
 pdt_b Alias for $1;
 pdt_e Alias for $2;
 v int;
begin

select into v count(*) from calendar where c_date>=pdt_b and c_date<=pdt_e ; 

--if v = 0 then v :=1; end if;

return v;
end;
' Language 'plpgsql';


create or replace function cal_minutes_fun(timestamp,timestamp) Returns Int As'
Declare
 pdt_b Alias for $1;
 pdt_e Alias for $2;
 v int;
begin

if (pdt_b <pdt_e ) then
 select into v extract (''epoch'' from pdt_e - pdt_b)/60  ; 
else
 v:=0;
end if;

return v;
end;
' Language 'plpgsql';
