drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
res boolean;
begin
res:=altr_colmn(''clm_statecl_tbl'',''tax_num'',''varchar(14)'');
Raise Notice ''alter tax_num - %'',res;
res:=altr_colmn(''clm_statecl_tbl'',''licens_num'',''varchar(14)'');
Raise Notice ''alter licens_num - %'',res;
res:=altr_colmn(''clm_statecl_tbl'',''okpo_num'',''varchar(14)'');
Raise Notice ''alter okpo_num - %'',res;
res:=altr_colmn(''clm_statecl_tbl'',''doc_ground'',''varchar(100)'');
Raise Notice ''alter doc_ground - %'',res;
Return true;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();
