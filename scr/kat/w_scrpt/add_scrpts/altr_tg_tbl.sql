drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
res boolean;
begin
if calc_type(''eqk_tg_tbl'',''value_r'')=''empty'' then 
 alter table eqk_tg_tbl add column value_r numeric(8,5);
 res:=true;
else
 res:=false;
end if;
if calc_type(''eqk_tg_tbl'',''value_cos'')=''empty'' then 
 alter table eqk_tg_tbl add column value_cos numeric(8,5);
 res:=true;
else
 res:=false;
end if;
update eqk_tg_tbl set value_r=0.8 where id in (1,2) and value_r<>0.8;
update eqk_tg_tbl set value_r=value where id in (3,4) and value_r<>value;
update eqk_tg_tbl set value_cos=0.78 where id=1 and value_cos<>0.78;
update eqk_tg_tbl set value_cos=0.85 where id=2 and value_cos<>0.85;
Return res;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();


update aci_tarif_tbl set ident=null where id=999;

