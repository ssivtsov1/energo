--исправление ошибок, вызванных переносом фрагмента схемы , содержащего гр. раздела,
-- из одно ветки в другую
-- При этом содержимое дерева - субобонента ошибочно получало код дерева
-- на которое переносился фрагмент
create or replace function eqm_border_fix_fun() Returns int As'
Declare
rec record;
vtree int;
begin

 for rec in select eqt.code_eqp,eqt.id_tree from eqm_eqp_tree_tbl as eqt 
   join eqm_equipment_tbl as eq  on (eq.id = eqt.code_eqp)
   join eqm_eqp_tree_tbl as eqt2 on (eqt.code_eqp= eqt2.code_eqp_e and eqt.id_tree=eqt2.id_tree)
   where eq.type_eqp=9 and eqt.code_eqp_e is not null
 loop
   
   select into vtree id_tree from eqm_eqp_tree_tbl as eqt3
   where code_eqp = rec.code_eqp and id_tree<>rec.id_tree and code_eqp_e is null;

   if found then

    update eqm_eqp_tree_tbl set id_tree = vtree
    where code_eqp_e = rec.code_eqp and id_tree=rec.id_tree;

   end if;
 
 end loop;


 RETURN 0;
end;
' Language 'plpgsql';

 select eqm_border_fix_fun();

 UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_eqp_tree_tbl';

 select eq_lvl_calc_all();

 UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
 WHERE relname = 'eqm_eqp_tree_tbl';
