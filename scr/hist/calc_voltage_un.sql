-- расчет уровня напряжения для ТУ (дополнительное поле для Кати), 
-- на основе анализа схемы
create or replace function calc_un_voltage_fun() Returns int As'
Declare
v int;
v_eqp int;
v_voltage int;
r record;
r2 record;
v_voltage2_nom numeric(9,1);
id_res int;
begin

 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

 for r in  select tt.id_tree, eq.id , tt.code_eqp_e , eq.type_eqp 
   from  eqm_eqp_tree_tbl as tt 
   join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id )
   join eqm_tree_tbl as t on (t.id = tt.id_tree)  
   join clm_client_tbl as c on (c.id = t.id_client)  
   join eqm_point_tbl as p on (p.code_eqp=eq.id ) 
   where  eq.type_eqp = 12
   and c.book = -1
   and tt.code_eqp_e is not null
   and p.id_un is null 
--   and t.id_client<>id_res
   order by tt.lvl
 loop

--  RAISE NOTICE '' tree %'',r.id_tree; 
  RAISE NOTICE '' point %'',r.id; 

  v_voltage:=NULL;

  v_eqp:=r.code_eqp_e;

  LOOP 

    select into r2 tt2.code_eqp_e, eq2.type_eqp 
    from eqm_eqp_tree_tbl as tt2 
    join eqm_equipment_tbl as eq2 on (tt2.code_eqp=eq2.id )
    where ((tt2.code_eqp_e is not null and eq2.type_eqp = 9) or (eq2.type_eqp <> 9)) 
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

       if v_voltage2_nom is not null then 

        if v_voltage2_nom <=400 then 
           v_voltage:=4;
        else

         if v_voltage2_nom <=20000 then 
            v_voltage:=3;
         else
            v_voltage:=2;
         end if; 
        end if; 
       end if; 

       RAISE NOTICE '' compens voltage %'',v_voltage; 
     end if; 

     v_eqp:=r2.code_eqp_e;

     EXIT WHEN ((v_eqp is null) or (v_voltage is not null)); 

  END LOOP;


  if (v_voltage is not null) then 

      update eqm_point_tbl  set id_un =  v_voltage
      where code_eqp = r.id;

      update eqm_point_h  set id_un =  v_voltage
      where code_eqp = r.id;

      RAISE NOTICE ''+ voltage %'',v_voltage; 
   end if;

 end loop;




 --дополнительно обработать точки учета в схеме РЕС, принадлежащие абонентам
 ------------------------------------------------------------------------------
/*
 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

 update eqm_point_tbl set id_voltage = 4 
 where code_eqp in 
  (select tt.code_eqp from 
   eqm_tree_tbl AS t join eqm_eqp_tree_tbl AS tt on (t.id=tt.id_tree) 
   left join eqm_eqp_use_tbl as use on (use.code_eqp=tt.code_eqp)
   WHERE (t.id_client=id_res) 
     and (use.id_client is not NULL)); -- используется абонентом
*/

 RETURN 0;
end;
' Language 'plpgsql';

--------------------------------------------------------------------------------------

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_point_tbl';


select calc_un_voltage_fun();


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_point_tbl';
