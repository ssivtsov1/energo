drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
res boolean;
begin
res:=altr_colmn(''acd_tarif_tbl'',''value'',''numeric(10,5)'');
Raise Notice ''alter tax_num - %'',res;
Return res;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();

