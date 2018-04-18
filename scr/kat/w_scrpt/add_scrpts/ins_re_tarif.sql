drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
begin
if calc_type(''aci_tarif_tbl'',''ident'')=''empty'' then 
 alter table aci_tarif_tbl add column ident varchar(10);
 Return true;
else
 Return false;
end if;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();

