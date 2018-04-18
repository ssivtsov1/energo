-----\\-----\\-----\\-----\\-----\\------\\-------\\--------\\--------
-- Расчет коеф. трансформации
-- для счетчиков РЕС
-- !!!!!!!!!!НЕ ОБРАБАТЫВАЕТСЯ ИСТОРИЯ!!!!!!!!

                                                                                                  
  CREATE OR REPLACE FUNCTION bal_ktr_calc_fun (date)
  RETURNS int
  AS                                                                                              
  '
  declare
  pdate Alias for $1;
--  meter_parent Alias for $1;
--  tree Alias for $2;
  meter record;
  eqp record;
  compensator record;
  ktr integer;
  cur_node integer;
  compens_type int; 
  f_id_type_eqp int;
  min_b timestamp;

  begin

  for meter in select id_meter,num_eqp
   from bal_demand_tbl as d where mmgg::date = pdate loop

    ktr:=1;
    cur_node:=meter.id_meter;
    LOOP

     select into eqp tt.code_eqp_e as id_p_eqp,eq.type_eqp from
      eqm_eqp_tree_tbl AS tt JOIN 
      eqm_equipment_tbl AS eq ON (tt.code_eqp=eq.id)
     where eq.id=cur_node;


     EXIT WHEN eqp.type_eqp=12; -- точка учета

     if eqp.type_eqp=10 then --измерительный трансф.

       select into compens_type id_type_eqp from eqm_compensator_i_tbl where
       code_eqp=cur_node;

       select into compensator ci.conversion,ci.voltage_nom,ci.amperage_nom,ci.voltage2_nom,ci.amperage2_nom
       from eqi_compensator_i_tbl as ci 
       where ci.id=compens_type;

       if compensator.conversion=1  then -- ток

           ktr:=ktr*(compensator.amperage_nom/compensator.amperage2_nom)::integer;
       else        --напряжение
           ktr:=ktr*(compensator.voltage_nom/compensator.voltage2_nom)::integer;
       end if;
     end if; 

     if eqp.type_eqp not in (1,10,12) then

         Raise EXCEPTION ''Ошибка в схеме подключения счетчика  % .'',meter.num_eqp;

     end if;

     cur_node:=eqp.id_p_eqp;

    END LOOP;

  update bal_demand_tbl set k_tr = ktr, id_point = cur_node where id_meter = meter.id_meter;

  END LOOP;

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


------------------------------------------------------
