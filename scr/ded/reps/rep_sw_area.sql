
create or replace function rep_switch_area_fun(int,int,int) Returns boolean As'
Declare

pid_eqp Alias for $1;
pid_tree Alias for $2;
pid_sw Alias for $3;

v int;
vid_area int;
r record;
rs boolean;
begin

 for r in  select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq 
 where  eq.id = eqt.code_eqp  
 and code_eqp_e=pid_eqp and eqt.id_tree=pid_tree and eqt.line_no =0 and code_eqp_e <> code_eqp loop

     --RAISE notice ''-- %'',r.id;
     select into vid_area st.code_eqp_inst  from eqm_compens_station_inst_tbl as st 
        join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst)
        where eq2.type_eqp = 11 and st.code_eqp = r.id limit 1;

     if found then 

       select into v id_switch from rep_switch_area_tmp
       where id_switch = pid_sw limit 1;

       if not found then
 
         insert into rep_switch_area_tmp(id_switch,id_area) values
         (pid_sw,vid_area);
       end if;
     else

       rs:=rep_switch_area_fun(r.id,pid_tree,pid_sw);
     end if;

 end loop;
 RETURN True;
end;
' Language 'plpgsql';



create or replace function rep_switch_area_start_fun() Returns boolean As'
Declare

v int;
vid_area int;
r record;

begin

 for r in select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq 
 where  eq.id = eqt.code_eqp  
 and type_eqp =3 loop

   perform rep_switch_area_fun(r.id,r.id_tree,r.id); 
 
 end loop;
 RETURN True;
end;
' Language 'plpgsql';
