-- построение дерева от текущей точки до низа, включая субабонентов
-- в таблице eqt_viewtree
create or replace function eq_sel_viewtree(int,int,int,int,int) Returns boolean As'
Declare
pidp Alias for $1;
pidroot Alias for $2;
pusr_id Alias for $3;
plvl Alias for $4;
pline_no Alias for $5;

v int;
r record;
rs boolean;
begin

 if pidp=pidroot then 
   Delete from eqt_viewtree where (id_usr = pusr_id) and(root_eqp = pidroot);
 end if;

 Insert into eqt_viewtree(
 Select t.id_client,pidroot,tt.code_eqp,tt.code_eqp_e,tt.name,eq.type_eqp,plvl,tt.line_no,tt.parents, dkp.id_icon,pusr_id
 From 
 (eqm_tree_tbl AS t JOIN 
 (eqm_eqp_tree_tbl AS tt JOIN 
 (eqm_equipment_tbl AS eq JOIN eqi_device_kinds_prop_tbl AS dkp 
      ON (eq.type_eqp=dkp.type_eqp)) ON (tt.code_eqp=eq.id)) ON (t.id=tt.id_tree))
 -- границу раздела выбираем только 1 раз (для субабонента)
 WHERE (eq.id=pidp) and (tt.line_no=pline_no) and ((eq.type_eqp<>9)or(eq.type_eqp=9 and tt.parents<>0)));
   --Order By tt.lvl,tt.line_no);


-- for r in  select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq 
-- where code_eqp_e=pidp and eq.id = eqt.code_eqp loop
 for r in  select * from eqm_eqp_tree_tbl as eqt  where code_eqp_e=pidp  
 loop

   rs:=eq_sel_viewtree(r.code_eqp,pidroot,pusr_id,plvl+1,r.line_no);

 end loop;
 RETURN True;
end;
' Language 'plpgsql';
