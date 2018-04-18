
--ВНИМАНИЕ!!!
-- создавать после создания триггеров по замене оборудования

drop trigger eqmtree_upd on eqm_eqp_tree_tbl;
drop function eqmtree_upd_pr();

create or replace function eqmtree_upd_pr() returns trigger As'
Declare
----old_r record;
new_p record;
cn integer;
begin
----select into old_r * from eqm_eqp_tree_tbl where code_eqp=new.code_eqp and id_tree=old.id_tree and code_eqp_e=old.code_eqp_e;
----select into new_p * from eqm_eqp_tree_tbl where code_eqp=new.code_eqp_e and id_tree=new.id_tree and line_no=0; 
--create second root!
--if new.code_eqp_e=null then
--select into cn count(code_eqp) from eqm_eqp_tree_tbl where id_tree=new.id_tree and code_eqp_e=null;
--if cn<>0 then
--new.code_eqp_e:=old_r.code_eqp_e;
--new.lvl:=old_r.lvl;
--end if;
--end if;
--if old_r.code_eqp_e=null  and new.code_eqp_e<> null then
--update eqm_tree_tbl set code_eqp=null where id=old_r.id_tree;
--end if;
    RAISE NOTICE ''===eqmtree_upd==='';   

if new.id_tree<>old.id_tree then
 if old.code_eqp_e is NULL then
  update eqm_tree_tbl set code_eqp = NULL where id = old.id_tree;
 end if;
 if new.code_eqp_e is NULL then
  update eqm_tree_tbl set code_eqp = new.code_eqp  where id = new.id_tree;
 end if;

 if old.line_no=0 then 
  update eqm_eqp_tree_tbl set id_tree=new.id_tree 
  where code_eqp_e=new.code_eqp and id_tree=old.id_tree ;
 end if;
end if;

--if (old.code_eqp_e<>new.code_eqp_e) or ((old.code_eqp_e=NULL) and (new.code_eqp_e<>NULL))  then --change parent
if not (new.code_eqp_e is NULL)  then --change parent
 if (old.code_eqp_e<>new.code_eqp_e) or (old.code_eqp_e is NULL) then 

 select into new_p * from eqm_eqp_tree_tbl where code_eqp=new.code_eqp_e and id_tree=new.id_tree and line_no=0; 
 new.lvl:=new_p.lvl+1; 

 if new.parents=0 then new.parents:=1; end if;

end if;
else
new.lvl:=1;
if new.parents=1 then new.parents:=0; end if;
end if;
--for descendants
if new.lvl<>old.lvl and not eqmterm_pr(new.code_eqp,new.line_no,new.id_tree) then --changed lvl
--change lvl for descendants
 update eqm_eqp_tree_tbl set lvl=new.lvl+1 where code_eqp_e=new.code_eqp and id_tree=new.id_tree;
end if;
Return new;
end;
' language 'plpgsql';

Create trigger eqmtree_upd
    Before Update on eqm_eqp_tree_tbl
    For Each Row Execute Procedure eqmtree_upd_pr();    