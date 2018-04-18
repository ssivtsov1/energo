-- расчет уровня напряжения для точек учета, 
-- на основе анализа схемы, начиная с граници раздела
create or replace function calc_point_voltage_fun() Returns int As'
Declare
v int;
v_eqp int;
v_voltage int;
r record;
r2 record;
v_voltage2_nom numeric(9,1);
id_res int;
begin

 for r in  select tt.id_tree, eq.id from  eqm_eqp_tree_tbl as tt 
   join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id )
   join eqm_tree_tbl as t on (t.id = tt.id_tree)  
   join clm_client_tbl as cl on (cl.id= t.id_client)
   where  eq.type_eqp=9
   and tt.code_eqp_e is null
   and cl.book = -1
 loop

  RAISE NOTICE '' tree %'',r.id_tree; 

  v_voltage:=NULL;

  v_eqp:=r.id;

  LOOP 

    select into r2 tt2.code_eqp_e, eq2.type_eqp 
    from eqm_eqp_tree_tbl as tt2 
    join eqm_equipment_tbl as eq2 on (tt2.code_eqp=eq2.id )
    where tt2.code_eqp_e is not null
    and eq2.id = v_eqp;
                   

    if r2.type_eqp = 6 then 

       select into v_voltage id_voltage from eqm_line_c_tbl 
       where code_eqp = v_eqp;

       RAISE NOTICE '' line voltage %'',v_voltage; 

    end if; 

    if r2.type_eqp = 7 then 

       select into v_voltage id_voltage from eqm_line_a_tbl 
       where code_eqp = v_eqp;

       RAISE NOTICE '' line voltage %'',v_voltage; 
    end if; 

    if r2.type_eqp = 2 then 

       select into v_voltage2_nom ci.voltage2_nom 
       from eqm_compensator_tbl as cm join eqi_compensator_tbl as ci
       on (cm.id_type_eqp =ci.id)
       where cm.code_eqp = v_eqp;

       if v_voltage2_nom <=400 then 
          v_voltage:=4;
       else

        if v_voltage2_nom <=20000 then 
           v_voltage:=3;
        else
           v_voltage:=2;
        end if; 
       end if; 

       RAISE NOTICE '' compens voltage %'',v_voltage; 
     end if; 

     v_eqp:=r2.code_eqp_e;

     EXIT WHEN ((v_eqp is null) or (v_voltage is not null)); 

  END LOOP;


  if (v_voltage is not null) then 

     update eqm_point_tbl  set id_voltage =  v_voltage
     where id_voltage is null 
     and exists (select * from eqm_eqp_tree_tbl as eqt 
         where eqt.code_eqp = eqm_point_tbl.code_eqp and eqt.id_tree = r.id_tree);

     RAISE NOTICE ''+ voltage %'',v_voltage; 

   end if;

 end loop;

 --дополнительно обработать точки учета в схеме РЕС, принадлежащие абонентам
 ------------------------------------------------------------------------------
 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

 update eqm_point_tbl set id_voltage = 4 
 where code_eqp in 
  (select tt.code_eqp from 
   eqm_tree_tbl AS t join eqm_eqp_tree_tbl AS tt on (t.id=tt.id_tree) 
   left join eqm_eqp_use_tbl as use on (use.code_eqp=tt.code_eqp)
   WHERE (t.id_client=id_res) 
     and (use.id_client is not NULL)); -- используется абонентом


 RETURN 0;
end;
' Language 'plpgsql';

update eqi_compensator_tbl set voltage2_nom = 400 where id = 185;
select calc_point_voltage_fun();