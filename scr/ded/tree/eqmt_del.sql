drop trigger eqmtree_del on eqm_eqp_tree_tbl;
drop function eqmtree_del_pr();
--drop trigger eqmtreea_del on eqm_eqp_tree_tbl;
--drop function eqmtreea_del_pr();

create or replace function eqmtree_del_pr() returns trigger as'
Declare

 t smallint;
 cod integer;
 children smallint;
begin

if old.code_eqp_e is null then
--select into t type_eqp from eqm_equipment_tbl where id=old.code_eqp;
--if t<>9 then
--for ch_r in select code_eqp from eqm_eqp_tree_tbl where code_eqp_e=old.code_eqp loop
--EXECUTE ''select del_desc(''||ch_r.code_eqp||'')'';
--end loop;
--else
  select into children count(code_eqp) from eqm_eqp_tree_tbl where code_eqp_e=old.code_eqp and id_tree=old.id_tree;
  if children>1 then
    RAISE EXCEPTION ''Root have >1 children.''; 
  end if;

  select into cod code_eqp from eqm_eqp_tree_tbl where code_eqp_e=old.code_eqp and id_tree=old.id_tree;
  update eqm_eqp_tree_tbl set code_eqp_e=null,lvl=1 where code_eqp_e=old.code_eqp and id_tree=old.id_tree;
  update eqm_tree_tbl set code_eqp=cod where id=old.id_tree;
--end if;
else
 if not eqmterm_pr(old.code_eqp,old.line_no,old.id_tree) then 
  update eqm_eqp_tree_tbl set code_eqp_e=old.code_eqp_e where code_eqp_e=old.code_eqp and id_tree=old.id_tree;
 end if;
end if;

Return old;
end;
' Language 'plpgsql';

create trigger eqmtree_del
    Before Delete ON eqm_eqp_tree_tbl
    For Each Row Execute Procedure eqmtree_del_pr();