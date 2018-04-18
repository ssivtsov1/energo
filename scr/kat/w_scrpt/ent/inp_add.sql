drop function inp_ind_add(int); 
create or replace function inp_ind_add(int) Returns boolean As'
Declare
idind Alias for $1;
r record;
r1 record;
r2 record;
begin
for r in select * from acm_headdem_tbl where id_doc=idind loop
 select * into r1 from acd_demand_tbl where id_doc=idind;
 if not found then
  select * into r2 from clm_statecl_h 
   where id_client=r1.id_client and dt_b>=bom(r1.reg_date) 
   and dt_e<= eom(r1.reg_date) order by dt_b;
  if found then
   insert into acm_demand_tbl (id_doc,dt_b,dt_e,sum_demand,sum_tax ) values 
     (idind,bom(r1.reg_date),eom(r1.reg_date),r2.pre_pay_grn,round(r2.pre_pay_grn/5.00,2));
  end if;
 end if;
end loop;
Return true;
end;
' Language 'plpgsql';