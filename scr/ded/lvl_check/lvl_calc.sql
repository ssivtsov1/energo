create or replace function eq_lvl_calc(int,int,int,int,int) Returns boolean As'
Declare
pid_tree Alias for $1;
pidp Alias for $2;
pusr_id Alias for $3;
plvl Alias for $4;
pline_no Alias for $5;

v int;
r record;
rs boolean;
begin

 update eqm_eqp_tree_tbl set lvl=plvl 
 where code_eqp=pidp and line_no=pline_no and id_tree=pid_tree;

 update eqm_eqp_tree_h set lvl=plvl 
 where code_eqp=pidp and line_no=pline_no and id_tree=pid_tree and dt_e is null;



 for r in  select * from eqm_eqp_tree_tbl as eqt  where code_eqp_e=pidp and id_tree=pid_tree
 loop

   rs:=eq_lvl_calc(pid_tree,r.code_eqp,pusr_id,plvl+1,r.line_no);

 end loop;
 RETURN True;
end;
' Language 'plpgsql';




create or replace function eq_lvl_calc_statr(int) Returns boolean As'
Declare
pusr_id Alias for $1;                        
r record;
rs boolean;
begin

 for r in  select * from eqm_eqp_tree_tbl as eqt join eqm_tree_tbl as t on (t.id=eqt.id_tree)
  where code_eqp_e is null and t.id_client= pusr_id
 loop

   rs:=eq_lvl_calc(r.id_tree,r.code_eqp,pusr_id,1,r.line_no);

 end loop;

 RETURN True;
end;
' Language 'plpgsql';


create or replace function eq_lvl_calc_all() Returns boolean As'
Declare
--pusr_id Alias for $1;                        
r record;
rs boolean;
begin

 for r in  select * from eqm_eqp_tree_tbl as eqt join eqm_tree_tbl as t on (t.id=eqt.id_tree)
  where code_eqp_e is null 
 loop

   rs:=eq_lvl_calc(r.id_tree,r.code_eqp,0,1,r.line_no);

 end loop;

 RETURN True;
end;
' Language 'plpgsql';


--select eq_lvl_calc_all();

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_eqp_tree_tbl';

select eq_lvl_calc_statr(syi_resid_fun());

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_eqp_tree_tbl';
