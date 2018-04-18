drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
res boolean;
begin
if calc_type(''aci_pref_tbl'',''in_acc'')=''empty'' then 
  alter table aci_pref_tbl add column in_acc integer;
  alter table aci_pref_tbl alter column in_acc set default 0;
 res:=true;
else
 res:=false;
end if;
update aci_pref_tbl set kind_energy=0 where id in (901,902) and kind_energy<>0;
update aci_pref_tbl set in_acc=1 where id in (10,20,901,902) and in_acc<>1; 
Return res;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();

