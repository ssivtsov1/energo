drop trigger eqmtree_ins on eqm_eqp_tree_tbl;
drop function eqmtree_ins_pr();
drop trigger eqmtreea_ins on eqm_eqp_tree_tbl;
drop function eqmtreea_ins_pr();

create or replace function eqmtree_ins_pr() returns trigger As'
Declare
 pr_r record;
begin
 if new.code_eqp_e is null then
  new.lvl:=1;
  new.parents:=0;
 else
  select into pr_r lvl from eqm_eqp_tree_tbl where code_eqp=new.code_eqp_e and id_tree=new.id_tree and line_no=0;
  new.lvl:=pr_r.lvl+1;
 end if;
 Return new;
end;
' Language 'plpgsql';

create or replace function eqmtreea_ins_pr() returns trigger As'
Declare
begin
 if new.code_eqp_e is null then
  update eqm_eqp_tree_tbl set code_eqp_e=new.code_eqp,lvl=new.lvl+1 where code_eqp_e is null and code_eqp<>new.code_eqp and id_tree=new.id_tree;
  update eqm_tree_tbl set code_eqp=new.code_eqp where id=new.id_tree;
 end if;
 Return new;
end;
' Language 'plpgsql';

create trigger eqmtree_ins 
   Before Insert on eqm_eqp_tree_tbl
   For Each Row Execute Procedure eqmtree_ins_pr(); 
   
create trigger eqmtreea_ins 
   After Insert on eqm_eqp_tree_tbl
   For Each Row Execute Procedure eqmtreea_ins_pr(); 
   