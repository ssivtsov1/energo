--drop table volt_tmp;
--create table volt_tmp (
--id_client int,
--id_border int,
--id_tree   int,
--id_voltage int );



-- расчет уровня напряжения для точек учета, 
-- на основе анализа схемы, начиная с граници раздела
create or replace function calc_tree_voltage_monitor_fun() Returns int As'
Declare
v int;
v_eqp int;
v_voltage int;
r record;
r2 record;
v_voltage2_nom numeric(9,1);
id_res int;
vres int;
begin

 -- сначала для абонентов, подключенных непосредственно к схеме РЕС

 vres:=syi_resid_fun();
 delete from tree_volt_tmp;

 for r in  select tt.id_tree, eq.id, b.id_clienta,b.id_clientb
   from  eqm_eqp_tree_tbl as tt 
   join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id )
   join eqm_tree_tbl as t on (t.id = tt.id_tree)  
   join clm_client_tbl as cl on (cl.id= t.id_client)	
   join eqm_borders_tbl as b on (b.code_eqp=eq.id )  
   where  eq.type_eqp=9
   and tt.code_eqp_e is null
   and cl.book = -1
   and b.id_clienta = vres
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

    -- точка учета РЕС 
    if r2.type_eqp = 12 then 

       select into v_voltage id_voltage from eqm_point_tbl 
       where code_eqp = v_eqp;

       RAISE NOTICE '' point voltage %'',v_voltage; 
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


     RAISE NOTICE ''+ voltage %'',v_voltage; 

     insert into tree_volt_tmp (id_client,id_border,id_tree,id_voltage) values (r.id_clientb,r.id,r.id_tree,v_voltage);

   end if;


 end loop;

 -- субабоненты
 --выбираем граници раздела, у который дерево выше уже есть во временной таблице, а дерева ниже еще нет

 RAISE NOTICE '' sub 1 ''; 

 for r in  select ttb.id_tree, eq.id, b.id_clienta,b.id_clientb, tmp.id_voltage
   from eqm_borders_tbl as b 
   join eqm_equipment_tbl as eq on (b.code_eqp=eq.id )

   join eqm_eqp_tree_tbl as ttb on (ttb.code_eqp=eq.id )
   join eqm_eqp_tree_tbl as tta on (ttb.code_eqp=tta.code_eqp )

   join clm_client_tbl as cl on (cl.id= b.id_clientb)	
   join tree_volt_tmp as tmp on (tmp.id_tree = tta.id_tree)
   left join tree_volt_tmp as tmp2 on (tmp2.id_tree = ttb.id_tree)
   where
   ttb.code_eqp_e is null
   and tta.code_eqp_e is not null
   and cl.book = -1
   and b.id_clienta <> vres
   and b.id_clientb <> vres
   and tmp2.id_client is null  
 loop

     RAISE NOTICE ''++++ voltage %'',r.id_voltage; 

     insert into tree_volt_tmp (id_client,id_border,id_tree,id_voltage) values (r.id_clientb,r.id,r.id_tree,r.id_voltage);

 end loop;


 RAISE NOTICE '' sub 2 ''; 

 for r in  select ttb.id_tree, eq.id, b.id_clienta,b.id_clientb, tmp.id_voltage
   from eqm_borders_tbl as b 
   join eqm_equipment_tbl as eq on (b.code_eqp=eq.id )

   join eqm_eqp_tree_tbl as ttb on (ttb.code_eqp=eq.id )
   join eqm_eqp_tree_tbl as tta on (ttb.code_eqp=tta.code_eqp )

   join clm_client_tbl as cl on (cl.id= b.id_clientb)	
   join tree_volt_tmp as tmp on (tmp.id_tree = tta.id_tree)
   left join tree_volt_tmp as tmp2 on (tmp2.id_tree = ttb.id_tree)
   where
   ttb.code_eqp_e is null
   and tta.code_eqp_e is not null
   and cl.book = -1
   and b.id_clienta <> vres
   and b.id_clientb <> vres
   and tmp2.id_client is null  
 loop

     RAISE NOTICE ''+++++ voltage %'',r.id_voltage; 

     insert into tree_volt_tmp (id_client,id_border,id_tree,id_voltage) values (r.id_clientb,r.id,r.id_tree,r.id_voltage);

 end loop;



 RAISE NOTICE '' sub 3 ''; 

 for r in  select ttb.id_tree, eq.id, b.id_clienta,b.id_clientb, tmp.id_voltage
   from eqm_borders_tbl as b 
   join eqm_equipment_tbl as eq on (b.code_eqp=eq.id )

   join eqm_eqp_tree_tbl as ttb on (ttb.code_eqp=eq.id )
   join eqm_eqp_tree_tbl as tta on (ttb.code_eqp=tta.code_eqp )

   join clm_client_tbl as cl on (cl.id= b.id_clientb)	
   join tree_volt_tmp as tmp on (tmp.id_tree = tta.id_tree)
   left join tree_volt_tmp as tmp2 on (tmp2.id_tree = ttb.id_tree)
   where
   ttb.code_eqp_e is null
   and tta.code_eqp_e is not null
   and cl.book = -1
   and b.id_clienta <> vres
   and b.id_clientb <> vres
   and tmp2.id_client is null  
 loop

     RAISE NOTICE ''++++++ voltage %'',r.id_voltage; 

     insert into tree_volt_tmp (id_client,id_border,id_tree,id_voltage) values (r.id_clientb,r.id,r.id_tree,r.id_voltage);

 end loop;



 RETURN 0;
end;
' Language 'plpgsql';

