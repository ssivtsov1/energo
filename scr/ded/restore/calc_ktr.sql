--  DROP FUNCTION eqc_ktr_calc_fun (integer);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_ktr_calc_fun (integer)
  RETURNS int
  AS                                                                                              
  '
  declare
  client Alias for $1;
  meter record;
  v int;

  begin 

  for meter in select distinct ad.oid,ad.id_meter,ad.dat_b,ad.dat_e -- все строки из act_demand_tbl
   from act_demand_tbl as ad ,act_eqp_branch_tbl as ae 
   where (ae.id_client=client)and (ae.code_eqp=ad.id_meter) loop 

       --Raise Notice ''eqc_ktr_calc_fun: meter %'',meter.id_meter;
       --Raise Notice ''eqc_ktr_calc_fun: dat_b %'',meter.dat_b;
       --Raise Notice ''eqc_ktr_calc_fun: dat_e %'',meter.dat_e;
       v:=eqc_meter_ktr_calc_fun (meter.id_meter,1,meter.id_meter,meter.dat_b::date,meter.dat_e::date);                                                   

  END LOOP;

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

------------------------------------------------------------------------------
--  DROP FUNCTION eqc_meter_ktr_calc_fun (int,int,date,date);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_meter_ktr_calc_fun (int,int,int,date,date)
  RETURNS int
  AS                                                                                              
  '
  declare
  peqp    Alias for $1;
  pktr    Alias for $2;
  pmeter   Alias for $3;
  p_begin Alias for $4;
  p_end   Alias for $5;
  eqp record;
  demand  record;
  comp_type record;
  compensator record;
  f_id_type_eqp int;
  ktr int;
  v int;

  begin

  --Raise Notice ''==============start ============'';
  for eqp in 
    -- все копии данного оборудования в дереве в данном временном интервале
    select distinct ae.code_eqp,ae.id_p_eqp,ae.type_eqp,
    date_larger(ae.dat_b::date,p_begin) as dat_b,date_smaller(ae.dat_e::date,p_end) as dat_e
    from act_eqp_branch_tbl as ae 
    where ae.code_eqp = peqp and 
      tintervalov(tinterval(abstime(p_begin::timestamp),abstime(p_end::timestamp)),
                  tinterval(abstime(ae.dat_b::timestamp),abstime(ae.dat_e::timestamp))) and 
      (p_begin<>ae.dat_e)and (p_end<>ae.dat_b) loop   --чтобы не захватывать интервалы, пересекающие текущий в начальной или конечной точке

      --Raise Notice ''eqc_meter_ktr_calc_fun: eqp.code_eqp %'',eqp.code_eqp;
      --Raise Notice ''eqc_meter_ktr_calc_fun: eqp.type_eqp %'',eqp.type_eqp;
      --Raise Notice ''eqc_meter_ktr_calc_fun: eqp.dat_b %'',eqp.dat_b;
      --Raise Notice ''eqc_meter_ktr_calc_fun: eqp.dat_e %'',eqp.dat_e;


    --ktr:=1;
     -- если это НЕ измерительный трансформатор, это или ТУ, или счетчик
    if eqp.type_eqp=12 then -- точка учета (расчет окончен)
       --return pktr;
       select into demand oid,* from act_demand_tbl 
       where p_begin>=dat_b and p_end<=dat_e and id_meter= pmeter;
       --побить исходный интервал в act_demand_tbl в соответствии с текущим интервалом
       delete from act_demand_tbl where oid = demand.oid;

       if demand.dat_b<> p_begin then
          insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,dat_b,dat_e)
          values (demand.id_meter,demand.num_eqp,demand.id_type_eqp, 
	  demand.dat_b,p_begin);

       end if;

       if demand.dat_e<> p_end then
          insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,dat_b,dat_e)
          values (demand.id_meter,demand.num_eqp,demand.id_type_eqp, 
	  p_end,demand.dat_e);

       end if;

       insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,k_tr,dat_b,dat_e)
       values (demand.id_meter,demand.num_eqp,demand.id_type_eqp,pktr, 
       p_begin,p_end);

        --Raise Notice ''==============exit============'';
       return pktr;
    end if;

    if eqp.type_eqp=1 then -- счетчик (начало расчета)
        -- просто идем дальше 
        --Raise Notice ''enter eqc_meter_ktr_calc_fun: eqp.id_p_eqp %'',eqp.id_p_eqp;
        v:=eqc_meter_ktr_calc_fun (eqp.id_p_eqp,pktr,pmeter,eqp.dat_b,eqp.dat_e);                                                   
        --return 0;
    end if;


    if eqp.type_eqp=10 then --измерительный трансф.

     select into f_id_type_eqp id from syi_field_tbl where name=''id_type_eqp'' and id_table in
     (select id from syi_table_tbl where name=''eqm_compensator_i_tbl'');


     for comp_type in 
        -- значения типа изм. тр. за период
        select int4(act.val) as val, 
        date_larger(act.dat_b::date,eqp.dat_b::date) as dat_b,date_smaller(act.dat_e::date,eqp.dat_e::date) as dat_e
        from act_eqm_par_tbl as act, aci_eqm_par_tbl as aci 
        where (aci.id_field=f_id_type_eqp) and (aci.id=act.id_param) and
        (act.id_eqp=eqp.code_eqp) and 
        tintervalov(tinterval(abstime(act.dat_b::timestamp),abstime(act.dat_e::timestamp)),
                    tinterval(abstime(eqp.dat_b::timestamp),abstime(eqp.dat_e::timestamp))) and 
        (act.dat_b<>eqp.dat_e)and (act.dat_e<>eqp.dat_b) loop   --чтобы не захватывать интервалы, пересекающие текущий в начальной или конечной точке

        select into compensator ci.conversion,ci.voltage_nom,ci.amperage_nom,ci.voltage2_nom,ci.amperage2_nom
        from eqi_compensator_i_tbl as ci 
        where ci.id=comp_type.val;

        --Raise Notice ''eqc_meter_ktr_calc_fun: comp_type.val %'',comp_type.val;
        --Raise Notice ''eqc_meter_ktr_calc_fun: comp_type.dat_b %'',comp_type.dat_b;
        --Raise Notice ''eqc_meter_ktr_calc_fun: comp_type.dat_e %'',comp_type.dat_e;


        if compensator.conversion=1  then -- ток
            ktr:=pktr*(compensator.amperage_nom/compensator.amperage2_nom)::integer;
        else        --напряжение
            ktr:=pktr*(compensator.voltage_nom/compensator.voltage2_nom)::integer;
        end if;

        --Raise Notice ''enter eqc_meter_ktr_calc_fun: eqp.id_p_eqp %'',eqp.id_p_eqp;

        v:=eqc_meter_ktr_calc_fun (eqp.id_p_eqp,ktr,pmeter,comp_type.dat_b,comp_type.dat_e);                                                   

     END LOOP; --comp_type

    end if;

  END LOOP; --eqp

  --Raise Notice ''==============exit============'';
  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
