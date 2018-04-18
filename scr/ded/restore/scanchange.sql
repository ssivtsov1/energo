-----------///////////////////////////////---------------------
-- Восстановление изменений
--  DROP FUNCTION eqc_scanchange_fun (integer,timestamp,timestamp);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_scanchange_fun (integer,timestamp,timestamp)                                                   
  RETURNS int
  AS                                                                                              
  '
  declare
  client Alias for $1;
  begindate Alias for $2;
  enddate Alias for $3;
  change record;
  change_eqp record;
  param record;
  change_val record;
  eqp_branch record;
  demand_rec record;
  ptarif_rec record;
  power_rec record; 
  wtm_rec   record; 
  tg_rec   record; 
  share_rec  record; 
  meter record;
  zn record;
  en record;
  pen record;
  n_zone int;

  eqptable int;
  eqptreetable int;
  metertable int;
  zonetable int;
  energytable int;
  pointtable int;
  point_energytable int;


  f_id_tree int;
--  f_code_eqp int;
  f_id_p_eqp int;
  f_lvl int;
  f_line_no int;
  f_dt_install int;
  f_dt_change int;
  f_type_eqp int;
  f_id_tarif int;
  f_id_voltage int;
  f_num_eqp int;
  f_loss_power int;
  f_id_type_eqp int;
  f_zone int;
  f_dt_zone_install int;
  f_kind_energy int;
  f_dt_energy_install int;
  f_count_lost int;
  f_power int; 
  f_point_kind_energy int;
  f_point_dt_instal int;
  f_wtm int;
  f_tg int;
  f_share int;

  v_id_tree int;
  v_id_p_eqp int;
  v_type_eqp int;
  v_lvl     int;
  v_line_no int;
  v_dt_install timestamp;
  v_dt_change timestamp;
  v_id_tarif int;
  v_id_voltage int;
  v_num_eqp varchar;
  v_param numeric;
  v_loss_power int;
  v_id_type_eqp int;
  v_zone int;
  v_dt_zone_install timestamp;
  v_kind_energy int;
  v_dt_energy_install timestamp;
  v_count_lost int;
  v_power int;
  v_point_kind_energy int;
  v_point_dt_instal timestamp;
  V_wtm int;
  V_tg int;
  v_share numeric(5,2);

  eqp_ok int;
  tree_ok int;
  flag int;
  d date;
  db date;
  de date;
  member boolean;
  state int;

  begin
  -- коды таблиц

      RAISE NOTICE ''begin''; 
  select into eqptable id from syi_table_tbl where name=''eqm_equipment_tbl'';
  select into pointtable id from syi_table_tbl where name=''eqm_point_tbl'';
  select into eqptreetable id from syi_table_tbl where name=''eqm_eqp_tree_tbl'';
  select into metertable id from syi_table_tbl where name=''eqm_meter_tbl'';
  select into zonetable id from syi_table_tbl where name=''eqd_meter_zone_tbl'';
  select into energytable id from syi_table_tbl where name=''eqd_meter_energy_tbl'';
  select into point_energytable id from syi_table_tbl where name=''eqd_point_energy_tbl'';
  -- коды полей
  select into f_type_eqp id from syi_field_tbl where name=''type_eqp'' and id_table=eqptable;
  select into f_dt_install id from syi_field_tbl where name=''dt_install'' and id_table=eqptable;
  select into f_dt_change id from syi_field_tbl where name=''dt_change'' and id_table=eqptable;
  select into f_num_eqp id from syi_field_tbl where name=''num_eqp'' and id_table=eqptable;
  select into f_loss_power id from syi_field_tbl where name=''loss_power'' and id_table=eqptable;

  select into f_id_tree id from syi_field_tbl where name=''id_tree'' and id_table=eqptreetable;
  select into f_id_p_eqp id from syi_field_tbl where name=''code_eqp_e'' and id_table=eqptreetable;
  select into f_lvl id from syi_field_tbl where name=''lvl'' and id_table=eqptreetable;
  select into f_line_no id from syi_field_tbl where name=''line_no'' and id_table=eqptreetable;

  --select into f_id_tarif id from syi_field_tbl where name=''code_group'' and id_table=metertable;
  select into f_id_voltage id from syi_field_tbl where name=''class'' and id_table=metertable;
  select into f_id_type_eqp id from syi_field_tbl where name=''id_type_eqp'' and id_table=metertable;
  --select into f_count_lost id from syi_field_tbl where name=''count_lost'' and id_table=metertable;  

  select into f_id_tarif id from syi_field_tbl where name=''id_tarif'' and id_table=pointtable;
  select into f_power id from syi_field_tbl where name=''power'' and id_table=pointtable;
  select into f_wtm id from syi_field_tbl where name=''wtm'' and id_table=pointtable;
  select into f_tg id from syi_field_tbl where name=''id_tg'' and id_table=pointtable;
  select into f_share id from syi_field_tbl where name=''share'' and id_table=pointtable;

  select into f_zone id from syi_field_tbl where name=''zone'' and id_table=zonetable;
  select into f_dt_zone_install id from syi_field_tbl where name=''dt_zone_install'' and id_table=zonetable;
  select into f_kind_energy id from syi_field_tbl where name=''kind_energy'' and id_table=energytable;
  select into f_dt_energy_install id from syi_field_tbl where name=''date_inst'' and id_table=energytable;

  select into f_point_kind_energy id from syi_field_tbl where name=''kind_energy'' and id_table=point_energytable;
  select into f_point_dt_instal id from syi_field_tbl where name=''dt_instal'' and id_table=point_energytable;

/*
--  for change in select cm.id,cm.mode,cm.date_change,ca.id_record,ca.code_eqp,ca.idk_operation,ca.id_table
--      from eqm_change_tbl as cm join eqa_change_tbl as ca on (cm.id = ca.id_change)
--      where cm.id_client =client and cm.date_change >= begindate and (cm.mode=1 or cm.mode=2)
--      order by cm.date_change DESC,ca.code_eqp loop
  */

  --выберем оборудование, которое было удалено и добавим его в act_eqp_branch_tbl
  for change in select cm.id,cm.date_change,ca.code_eqp,ca.id_record,cm.id_client
--      eu.id_client as use_client, eu.dt_b as dt_useb,eu.dt_e as dt_usee
      from eqm_change_tbl as cm join eqa_change_tbl as ca on (cm.id = ca.id_change)
      left join eqv_eqp_use as eu on ((eu.code_eqp=ca.code_eqp) and 
       tintervalov(tinterval(begindate::abstime,enddate::abstime),tinterval(coalesce(eu.dt_b,begindate)::abstime,max(coalesce(eu.dt_e,enddate),eu.dt_b)::abstime)))
      where 
--      cm.id_client = client 
      (((cm.id_client=client) and (eu.id_client is null ))or(eu.id_client = client))

      and cm.date_change >= begindate and (cm.mode=2 and
      ca.idk_operation=1) and ca.id_table = eqptreetable
      group by cm.id,cm.date_change,ca.code_eqp,ca.id_record,cm.id_client
      order by cm.date_change DESC,ca.code_eqp loop

       Raise Notice ''Удалено %'',change.date_change;
       Raise Notice ''оборудования %'',change.code_eqp;

   -- сначала  добавим в act_eqp_branch_tbl
--      RAISE NOTICE ''DEl''; 

      select into v_loss_power cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_loss_power and id_record in 
      (select id_record from eqa_change_tbl where id_change = change.id and id_table = eqptable and code_eqp=change.code_eqp);

      select into v_type_eqp cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_type_eqp and id_record in 
      (select id_record from eqa_change_tbl where id_change = change.id and id_table = eqptable and code_eqp=change.code_eqp);
  
      select into v_dt_install to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
      id_field = f_dt_install and id_record in
      (select id_record from eqa_change_tbl where id_change = change.id and id_table = eqptable and code_eqp=change.code_eqp);
--
      select into v_id_tree cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_id_tree and id_record=change.id_record;

      select into v_id_p_eqp cast(to_number(old_value,''9999999999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_id_p_eqp and id_record=change.id_record;

      select into v_lvl cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_lvl and id_record=change.id_record;

      select into v_line_no cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_line_no and id_record=change.id_record;

--      insert into act_eqp_branch_tbl (node_oid,id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e,lvl,line_no,id_client)
--      values (change.id_record,cast(id_tree as int),change.code_eqp,cast(id_p_eqp as int),
--              cast(type_eqp as int),max(begindate,cast(dt_install as timestamp)),change.date_change,
--              cast(lvl as int),cast(line_no as int),client);

     if v_line_no = 0 then --без копий точек схождения

      insert into act_eqp_branch_tbl (node_oid,id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e,lvl,line_no,id_client,id_rclient,loss_power)
      values (change.id_record,v_id_tree,change.code_eqp,v_id_p_eqp,
              v_type_eqp,max(begindate,v_dt_install),change.date_change,
              v_lvl,v_line_no,client,change.id_client,v_loss_power);
     end if;
  
     if v_type_eqp=1 then -- счетчик

      -- select into v_id_tarif cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      -- id_field = f_id_tarif and id_record in 
      -- (select id_record from eqa_change_tbl where id_change = change.id and id_table =  metertable and code_eqp=change.code_eqp);

      -- select into v_id_voltage cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      -- id_field = f_id_voltage and id_record in 
      -- (select id_record from eqa_change_tbl where id_change = change.id and id_table =  metertable and code_eqp=change.code_eqp);

       select into v_id_type_eqp cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
       id_field = f_id_type_eqp and id_record in
       (select id_record from eqa_change_tbl where id_change = change.id and id_table = metertable and code_eqp=change.code_eqp);

       select into v_num_eqp old_value from eqd_change_tbl where id_change = change.id and
       id_field = f_num_eqp and id_record in
       (select id_record from eqa_change_tbl where id_change = change.id and id_table = eqptable and code_eqp=change.code_eqp);

      -- select into v_count_lost cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      -- id_field = f_count_lost and id_record in 
      -- (select id_record from eqa_change_tbl where id_change = change.id and id_table =  metertable and code_eqp=change.code_eqp);

       insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,dat_b,dat_e)
       values (change.code_eqp,v_num_eqp,v_id_type_eqp,
       max(begindate,v_dt_install),change.date_change);
       -- зоны и виды энергии
       for en in select * from eqa_change_tbl 
 	  where (id_change = change.id) and (id_table=energytable) loop

            select into v_kind_energy cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
            id_field = f_kind_energy and id_record = en.id_record; 

            select into v_dt_energy_install to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
            id_field = f_dt_energy_install and id_record = en.id_record; 

            insert into act_met_knd_tbl (id_meter,num_eqp,kind_energy,dat_b_energy,dat_e)
            values (change.code_eqp,v_num_eqp,v_kind_energy,v_dt_energy_install,
            change.date_change);

       end loop;

       for zn in select * from eqa_change_tbl 
          where (id_change = change.id) and (id_table=zonetable) loop

            select into v_zone cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
            id_field = f_zone and id_record = zn.id_record; 

            select into v_dt_zone_install to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
            id_field = f_dt_zone_install and id_record = zn.id_record; 

            insert into act_met_zn_tbl (id_meter,num_eqp,id_zone,dat_b_zone,dat_e)
            values (change.code_eqp,v_num_eqp,v_zone,
	    v_dt_zone_install,change.date_change);

       end loop;

     end if;

     if v_type_eqp=12 then -- точка учета
      
       select into v_id_tarif cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
       id_field = f_id_tarif and id_record in 
       (select id_record from eqa_change_tbl where id_change = change.id and id_table =  pointtable and code_eqp=change.code_eqp);

       select into v_power cast(to_number(old_value,''999999999'') as int) from eqd_change_tbl where id_change = change.id and
       id_field = f_power and id_record in 
       (select id_record from eqa_change_tbl where id_change = change.id and id_table =  pointtable and code_eqp=change.code_eqp);

       select into v_wtm cast(to_number(old_value,''999999999'') as int) from eqd_change_tbl where id_change = change.id and
       id_field = f_wtm and id_record in 
       (select id_record from eqa_change_tbl where id_change = change.id and id_table =  pointtable and code_eqp=change.code_eqp);

       select into v_tg cast(to_number(old_value,''999999999'') as int) from eqd_change_tbl where id_change = change.id and
       id_field = f_tg and id_record in 
       (select id_record from eqa_change_tbl where id_change = change.id and id_table =  pointtable and code_eqp=change.code_eqp);

       select into v_share to_number(old_value,''999.99'')  from eqd_change_tbl where id_change = change.id and
       id_field = f_share and id_record in 
       (select id_record from eqa_change_tbl where id_change = change.id and id_table =  pointtable and code_eqp=change.code_eqp);


       insert into act_pnt_pwr (id_point,power,dat_b,dat_e)
       values (change.code_eqp,v_power,max(begindate,v_dt_install),change.date_change);

       insert into act_pnt_tarif (id_point,id_tarif,dat_b,dat_e)
       values (change.code_eqp,v_id_tarif,max(begindate,v_dt_install),change.date_change);

       insert into act_pnt_wtm (id_point,wtm,dat_b,dat_e)
       values (change.code_eqp,v_wtm,max(begindate,v_dt_install),change.date_change);

       insert into act_pnt_tg (id_point,id_tg,dat_b,dat_e)
       values (change.code_eqp,v_tg,max(begindate,v_dt_install),change.date_change);

       insert into act_pnt_share (id_point,share,dat_b,dat_e)
       values (change.code_eqp,v_share,max(begindate,v_dt_install),change.date_change);

       --виды енергии для точки учета
       for pen in select * from eqa_change_tbl 
          where (id_change = change.id) and (id_table=point_energytable) loop

            select into v_point_kind_energy cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
            id_field = f_point_kind_energy and id_record = pen.id_record; 

            select into v_point_dt_instal to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
            id_field = f_point_dt_instal and id_record = pen.id_record; 

            insert into act_pnt_knd (id_point,kind_energy,dat_b,dat_e)
            values (change.code_eqp,v_point_kind_energy,
	    max(begindate,v_point_dt_instal),change.date_change);

       end loop;

     end if;
--    параметры 
     for param in select par.id,par.id_field,sf.id_table 
       from aci_eqm_par_tbl as par,syi_field_tbl as sf
       where (par.type_eqp=v_type_eqp) and (par.id_field=sf.id) loop

       Raise Notice ''параметр %'',param.id;
       Raise Notice ''оборудования %'',change.code_eqp;

       select into v_param to_number(dc.old_value,''999999999.9999'') from eqd_change_tbl as dc 
       where dc.id_change = change.id and
       dc.id_field =param.id_field and dc.id_record in 
       (select id_record from eqa_change_tbl where id_change = change.id and id_table = param.id_table and code_eqp=change.code_eqp);

       insert into act_eqm_par_tbl(id_eqp,dat_b,dat_e,id_param,val)
       values (change.code_eqp,max(v_dt_install,begindate),change.date_change,param.id,v_param);             


--       insert into act_eqm_par_tbl(id_eqp,dat_b,dat_e,id_param,val)
--       values (              
--           select change.code_eqp,max(v_dt_install,begindate),change.date_change,param.id,dc.old_value 
--           from eqd_change_tbl as dc where dc.id_change = change.id and
--           dc.id_field =param.id_field and dc.id_record in 
--           (select id_record from eqa_change_tbl where id_change = change.id and id_table = param.id_table and code_eqp=change.code_eqp));
          
     end loop;                                                             

  end loop;

  -- Удаленнные виды энергии точки учета
  for change in select cm.id,cm.date_change,ca.code_eqp,ca.id_record
      from eqm_change_tbl as cm join eqa_change_tbl as ca on (cm.id = ca.id_change)
      left join eqv_eqp_use as eu on ((eu.code_eqp=ca.code_eqp) and 
       tintervalov(tinterval(begindate::abstime,enddate::abstime),tinterval(coalesce(eu.dt_b,begindate)::abstime,max(coalesce(eu.dt_e,enddate),eu.dt_b)::abstime)))

      where  
      (((cm.id_client=client) and (eu.id_client is null ))or(eu.id_client = client))
      and cm.date_change >= begindate and (cm.mode=4 and
      ca.idk_operation=1) and ca.id_table = point_energytable
      order by cm.date_change DESC loop


      select into v_point_kind_energy cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_point_kind_energy and id_record = change.id_record; 

      select into v_point_dt_instal to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
      id_field = f_point_dt_instal and id_record = change.id_record; 

      insert into act_pnt_knd (id_point,kind_energy,dat_b,dat_e)
      values (change.code_eqp,v_point_kind_energy,
      max(begindate,v_point_dt_instal),change.date_change);

  end loop;

  -- Удаленнные виды энергии
  for change in select cm.id,cm.date_change,ca.code_eqp,ca.id_record
      from eqm_change_tbl as cm join eqa_change_tbl as ca on (cm.id = ca.id_change)
      left join eqv_eqp_use as eu on ((eu.code_eqp=ca.code_eqp) and 
       tintervalov(tinterval(begindate::abstime,enddate::abstime),tinterval(coalesce(eu.dt_b,begindate)::abstime,max(coalesce(eu.dt_e,enddate),eu.dt_b)::abstime)))

      where --cm.id_client = client
      (((cm.id_client=client) and (eu.id_client is null ))or(eu.id_client = client))
      and cm.date_change >= begindate and ((cm.mode=4 or cm.mode=1) and
      ca.idk_operation=1) and ca.id_table = energytable
      order by cm.date_change DESC loop

--      RAISE NOTICE ''DEl_ener''; 
      select into v_kind_energy cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_kind_energy and id_record = change.id_record; 

      select into v_dt_energy_install to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
      id_field = f_dt_energy_install and id_record = change.id_record; 

      -- выборка из act_met_kndzn_tbl только для получения num_eqp
      -- добавляем все записи для видов энергии и не смотрим пока на зоны
      insert into act_met_knd_tbl (id_meter,num_eqp,kind_energy,dat_b_energy,dat_e)
      select id_meter,num_eqp, v_kind_energy, v_dt_energy_install,change.date_change
      from act_met_knd_tbl where id_meter=change.code_eqp LIMIT 1 OFFSET 0;
 

  end loop;

   -- Удаленые зоны счетчика
  for change in select cm.id,cm.date_change,ca.code_eqp,ca.id_record
      from eqm_change_tbl as cm join eqa_change_tbl as ca on (cm.id = ca.id_change)
      left join eqv_eqp_use as eu on ((eu.code_eqp=ca.code_eqp) and 
       tintervalov(tinterval(begindate::abstime,enddate::abstime),tinterval(coalesce(eu.dt_b,begindate)::abstime,max(coalesce(eu.dt_e,enddate),eu.dt_b)::abstime)))

      where --cm.id_client = client  
      (((cm.id_client=client) and (eu.id_client is null ))or(eu.id_client = client))
      and cm.date_change >= begindate and ((cm.mode=4 or cm.mode=1) and
      ca.idk_operation=1) and ca.id_table = zonetable
      order by cm.date_change DESC loop

--      RAISE NOTICE ''DEl_zzz''; 

      select into v_zone cast(to_number(old_value,''99999'') as int) from eqd_change_tbl where id_change = change.id and
      id_field = f_zone and id_record = change.id_record; 

      select into v_dt_zone_install to_date(old_value,''YYYY-MM-DD'') from eqd_change_tbl where id_change = change.id and
      id_field = f_dt_zone_install and id_record = change.id_record; 

      insert into act_met_zn_tbl (id_meter,num_eqp,id_zone,dat_b_zone,dat_e)
      select id_meter,num_eqp,v_zone,v_dt_zone_install,change.date_change
      from act_met_zn_tbl where id_meter=change.code_eqp LIMIT 1 OFFSET 0;  
  
  end loop;

  -- теперь поиск дыр в зонах и их заполнение
  -- в act_demand_tbl каждый счетчик лежит пока только 1 раз (изменения еще не сканировали)

  for meter in select * from act_demand_tbl where id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client) loop
      --RAISE NOTICE ''meter''; 

   d:=begindate::date;
   state:=0;
 --  bd:=d;
   WHILE d<=enddate::date LOOP

    member:=false;

    for change in select 1 from act_met_zn_tbl where d<=dat_e and d>=dat_b_zone and id_meter=meter.id_meter LIMIT 1 OFFSET 0 loop
     member:=true;
    --       RAISE NOTICE ''true''; 
    end loop;

    if member=true then 

     if state = 1 then -- накапливался период

      state:=0;
      de:= d;
      insert into act_met_zn_tbl (id_meter,num_eqp,id_zone,dat_b_zone,dat_e)
      values (meter.id_meter,meter.num_eqp,0,db,de);
  --    RAISE NOTICE ''insert1''; 
      --RAISE NOTICE ''go''; 

     end if;

    else
           --RAISE NOTICE ''false''; 
     if state = 0 then -- не накапливался период
      -- начнем накапливать
      --RAISE NOTICE ''start''; 
      state:=1;
      if d = begindate::date then
        db:= begindate::date;
      else
        db:=d-1;
      end if;
     end if;
    end if;

    d:=d+1;
   end loop; -- даты

   if state = 1 then -- накапливался период, но не закончился с концом периода
    de:=enddate ;
    insert into act_met_zn_tbl (id_meter,num_eqp,id_zone,dat_b_zone,dat_e)
    values (meter.id_meter,meter.num_eqp,0,db,de);
--    RAISE NOTICE ''insert2'';   
   end if;
  
  end loop;  -- счетчики
  ----------------------------------------------------------------------

  delete from act_met_knd_tbl where dat_b_energy>enddate and
   id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  delete from act_met_zn_tbl where dat_b_zone>enddate and 
   id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);


  insert into act_met_kndzn_tbl (id_meter,num_eqp,kind_energy,id_zone,dat_b,dat_e)
  select ee.id_meter,ee.num_eqp,ee.kind_energy,zz.id_zone,max(max(ee.dat_b_energy,zz.dat_b_zone),begindate),
     date_smaller(date_smaller(ee.dat_e::date,zz.dat_e::date),enddate::date) 
--     date_smaller(ee.dat_e::date,zz.dat_e::date) 
     from act_met_knd_tbl as ee , act_met_zn_tbl as zz
     where
     (ee.id_meter=zz.id_meter) and
--     (ee.kind_energy<>0)and (zz.kind_energy=0) and
      tintervalov(tinterval(ee.dat_b_energy::abstime,ee.dat_e::abstime),tinterval(zz.dat_b_zone::abstime,zz.dat_e::abstime)) and 
     (ee.dat_b_energy<>zz.dat_e)and (ee.dat_e<>zz.dat_b_zone) and   --чтобы не захватывать интервалы, пересекающие текущий в начальной или конечной точке
     ee.id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);
    RAISE NOTICE ''insert_end''; 

  delete from act_met_knd_tbl;
  delete from act_met_zn_tbl;
 
  ----------------------------------------------------------------------
   
  --выберем изменения, а также удаления при замене (кабель на воздушку)
  for change in select cm.id,cm.mode,cm.date_change,cm.dt,ca.code_eqp,ca.id_record,ca.id_table,ca.idk_operation,cm.id_client
      from eqm_change_tbl as cm join eqa_change_tbl as ca on (cm.id = ca.id_change)
      left join eqv_eqp_use as eu on ((eu.code_eqp=ca.code_eqp) and 
       tintervalov(tinterval(begindate::abstime,enddate::abstime),tinterval(coalesce(eu.dt_b,begindate)::abstime,max(coalesce(eu.dt_e,enddate),eu.dt_b)::abstime)))

      where --cm.id_client =client 
      (((cm.id_client=client) and (eu.id_client is null ))or(eu.id_client = client))
      and cm.date_change >= begindate and (cm.mode=1 or
      (ca.idk_operation=0 and cm.mode=2))
      order by cm.date_change DESC,cm.dt DESC, ca.code_eqp loop

      -- в таблице eqm_equipment_tbl только изменения, возможно type_eqp
      -- для счетчика замена на другой тип невозможно

--      RAISE NOTICE ''Change''; 
      if change.id_table = eqptable then 

        for change_val in select old_value, id_field
	from eqd_change_tbl where id_change = change.id and id_record = change.id_record loop

	  if (change_val.id_field = f_type_eqp) or (change_val.id_field = f_loss_power) then 

 	     select into eqp_branch oid,* from act_eqp_branch_tbl as act
             where code_eqp=change.code_eqp and        
             act.dat_e>=change.date_change and act.dat_b<=change.date_change
      	     order by act.dat_e;

             if (change_val.id_field = f_type_eqp) then 
               eqp_branch.type_eqp:=cast (to_number(change_val.old_value,''99999'') as int);
             end if;

             if (change_val.id_field = f_loss_power) then 
               eqp_branch.loss_power:=cast (to_number(change_val.old_value,''9'') as int);
             end if;


             if change.date_change=eqp_branch.dat_e then 
               -- дата изменения предыдущего равна текущей
               delete from act_eqp_branch_tbl where oid = eqp_branch.oid;
             else

    	      -- обновим последующую (исправим начало периода)
	      update act_eqp_branch_tbl set dat_b=change.date_change
	      where oid = eqp_branch.oid;

	     end if;

            insert into act_eqp_branch_tbl (node_oid,id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e,lvl,line_no,id_client,id_rclient,loss_power)
            values (eqp_branch.node_oid,eqp_branch.id_tree,eqp_branch.code_eqp,eqp_branch.id_p_eqp,eqp_branch.type_eqp,
              eqp_branch.dat_b,change.date_change,eqp_branch.lvl,eqp_branch.line_no,client,change.id_client,eqp_branch.loss_power);

	  end if;

	  if change_val.id_field = f_num_eqp then
	   --цикл нужен для того, чтобы обработать изменение num_eqp не у счтечика
	   -- (цикл вып. 1 или 0 раз)
  	   for demand_rec in select oid,* from act_demand_tbl as dm
           where dm.id_meter =change.code_eqp and dm.dat_e>=change.date_change and dm.dat_b<=change.date_change
    	   order by dm.dat_e loop     

             demand_rec.num_eqp:=change_val.old_value;

             if change.date_change=demand_rec.dat_e then 
               delete from act_demand_tbl where oid = demand_rec.oid;
             else
       
      	       -- обновим последующую (исправим начало периода)
 	       update act_demand_tbl set dat_b=change.date_change
	       where oid = demand_rec.oid;

	     end if;

             insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,dat_b,dat_e)
             values (demand_rec.id_meter,demand_rec.num_eqp,demand_rec.id_type_eqp,
	     demand_rec.dat_b,change.date_change);
             RAISE NOTICE ''ins 1''; 	     
	     --разделить записи по зонам и энергии
	     -- сначала новые
	     -- если запись начинается или кончается с даты замены счетчика, 
	     -- ее пропускаем, потому что возможно одновременно с заменой
	     -- счетчика были введены новые зоны и виды энергии, и они уже выбраны
	     -- (выборка удаленных выполнялась ранее)

	     insert into act_met_kndzn_tbl (id_meter,num_eqp,kind_energy,id_zone,dat_b,dat_e)
	     select distinct demand_rec.id_meter,num_eqp, kind_energy, id_zone,change.date_change,dat_e
	     from act_met_kndzn_tbl where id_meter=demand_rec.id_meter and 
	     dat_e>change.date_change and dat_b<change.date_change;
             RAISE NOTICE ''ins 2''; 

	     -- изменим предыдущие
	     update act_met_kndzn_tbl set dat_e=change.date_change
             ,num_eqp=demand_rec.num_eqp
             where id_meter=demand_rec.id_meter and 
	     dat_e>=change.date_change and dat_b<change.date_change;
             -- в случае dat_e=change.date_change в пред. insert ничего не добавлялось
             -- но надо сделать update

	     -- изменим номер в записях, целиком находящихся в периоде до изменения номера 
	     update act_met_kndzn_tbl set num_eqp=demand_rec.num_eqp
             where id_meter=demand_rec.id_meter and 
	     dat_e<change.date_change;


             RAISE NOTICE ''ins 3''; 
	   end loop;

	  end if;

	end loop;
      end if;


      if change.id_table = eqptreetable then -- таблица узлов дерева

        -- выбрать состояние после замены 
	select into eqp_branch oid,* from act_eqp_branch_tbl as act
        where act.node_oid=change.id_record and act.dat_e>=change.date_change and act.dat_b<=change.date_change
	order by act.dat_e;

	if found then  --если не нашли - возможно это был перенос копии точки сх.
	--никто не мешает ввести 2 изменения одной датой,
	-- так что может уже существовать запись с точно таким же периодом для данного оборудования
	flag:= 0;
	-- определим, что поменялось
        for change_val in select old_value, id_field
	from eqd_change_tbl where id_change = change.id and id_record = change.id_record loop

	  if change_val.id_field = f_id_tree then 
             eqp_branch.id_tree:=cast (to_number(change_val.old_value,''99999'') as int);
             flag:= 1;
	  end if;
	  if change_val.id_field = f_id_p_eqp then 
             eqp_branch.id_p_eqp:=cast (to_number(change_val.old_value,''9999999999'') as int);
             flag:= 1;
	  end if;
	  if change_val.id_field = f_lvl then
             eqp_branch.lvl:=cast (to_number(change_val.old_value,''99999'') as int);
             flag:= 1;
	  end if;

	end loop;
        --запишем измененную
        if flag = 1 then
	--  если поменялось поле parents и больше ничего (добавили новую копию точки, у старых копий изменился только Parents)
          if change.date_change=eqp_branch.dat_e then 
            -- дата изменения предыдущего равна текущей
            delete from act_eqp_branch_tbl where oid = eqp_branch.oid;
          else

    	   -- обновим последующую (исправим начало периода)
	   update act_eqp_branch_tbl set dat_b=change.date_change
	   where oid = eqp_branch.oid;

	  end if;

          insert into act_eqp_branch_tbl (node_oid,id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e,lvl,line_no,id_client,id_rclient,loss_power)
          values (eqp_branch.node_oid,eqp_branch.id_tree,eqp_branch.code_eqp,eqp_branch.id_p_eqp,eqp_branch.type_eqp,
            eqp_branch.dat_b,change.date_change,eqp_branch.lvl,eqp_branch.line_no,client,change.id_client,eqp_branch.loss_power);

	end if;
       end if;
      end if;

      if change.id_table = metertable then 
      --в этой таблице только счетчики 
      
        -- выбрать состояние после замены 
	select into demand_rec oid,* from act_demand_tbl as dm
        where dm.id_meter =change.code_eqp  and dm.dat_e>=change.date_change and dm.dat_b<=change.date_change
    	order by dm.dat_e;     
	flag:= 0;

	-- определим, что поменялось
        for change_val in select old_value, id_field
 	 from eqd_change_tbl where id_change = change.id and id_record = change.id_record loop

	  -- не фиксируем изменения
	  --if change_val.id_field = f_id_tarif then 
          --   demand_rec.id_tarif:=cast (to_number(change_val.old_value,''99999'') as int);
          --   flag:= 1;
	  --end if;

	  -- удален
	  --if change_val.id_field = f_id_voltage then 
          --   demand_rec.id_voltage:=cast (to_number(change_val.old_value,''99999'') as int);
          --   flag:= 1;
	  --end if;

	  if change_val.id_field = f_id_type_eqp then 
             demand_rec.id_type_eqp:=cast (to_number(change_val.old_value,''99999'') as int);
             flag:= 1;
	  end if;

	  --if change_val.id_field = f_count_lost then 
          --   demand_rec.count_lost:=cast (to_number(change_val.old_value,''99999'') as int);
          --   flag:= 1;
	  --end if;

	end loop;
        --запишем измененную
        if flag = 1 then

          if change.date_change=demand_rec.dat_e then 
            delete from act_demand_tbl where oid = demand_rec.oid;
          else

    	    -- обновим последующую (исправим начало периода)
	    update act_demand_tbl set dat_b=change.date_change
	    where oid = demand_rec.oid;

	  end if;

          insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,dat_b,dat_e)
          values (demand_rec.id_meter,demand_rec.num_eqp,demand_rec.id_type_eqp, 
	  demand_rec.dat_b,change.date_change);
	end if;
      end if;


      if change.id_table = pointtable then 
      --в этой таблице точки учета 

	-- определим, что поменялось
        for change_val in select old_value, id_field
 	 from eqd_change_tbl where id_change = change.id and id_record = change.id_record loop

	  if change_val.id_field = f_id_tarif then 
	  -- тариф
  	    select into ptarif_rec oid,* from act_pnt_tarif as pt
            where pt.id_point =change.code_eqp  and pt.dat_e>=change.date_change and pt.dat_b<=change.date_change
            order by pt.dat_e;     

            ptarif_rec.id_tarif:=cast (to_number(change_val.old_value,''99999'') as int);

            if change.date_change=ptarif_rec.dat_e then 
              delete from act_pnt_tarif where oid = ptarif_rec.oid;
            else
    	      -- обновим последующую (исправим начало периода)
	      update act_pnt_tarif set dat_b=change.date_change
	      where oid = ptarif_rec.oid;

 	    end if;

            insert into act_pnt_tarif (id_point,id_tarif,dat_b,dat_e)
            values (ptarif_rec.id_point,ptarif_rec.id_tarif,ptarif_rec.dat_b,change.date_change);

	  end if;


	  if change_val.id_field = f_power then 
	  --мощность
  	    select into power_rec oid,* from act_pnt_pwr as pw
            where pw.id_point =change.code_eqp  and pw.dat_e>=change.date_change and pw.dat_b<=change.date_change
            order by pw.dat_e;     

            power_rec.power:=cast (to_number(change_val.old_value,''999999999'') as int);

            if change.date_change=power_rec.dat_e then 
              delete from act_pnt_pwr where oid = power_rec.oid;
            else
    	      -- обновим последующую (исправим начало периода)
	      update act_pnt_pwr set dat_b=change.date_change
	      where oid = power_rec.oid;

 	    end if;

            insert into act_pnt_pwr (id_point,power,dat_b,dat_e)
            values (power_rec.id_point,power_rec.power,power_rec.dat_b,change.date_change);

	  end if;

	  if change_val.id_field = f_wtm then 
	  --время работы
  	    select into wtm_rec oid,* from act_pnt_wtm as wtm
            where wtm.id_point =change.code_eqp  and wtm.dat_e>=change.date_change and wtm.dat_b<=change.date_change
            order by wtm.dat_e;     

            wtm_rec.wtm:=cast (to_number(change_val.old_value,''999999999'') as int);

            if change.date_change=wtm_rec.dat_e then 
              delete from act_pnt_wtm where oid = wtm_rec.oid;
            else
    	      -- обновим последующую (исправим начало периода)
	      update act_pnt_wtm set dat_b=change.date_change
	      where oid = wtm_rec.oid;

 	    end if;

            insert into act_pnt_wtm (id_point,wtm,dat_b,dat_e)
            values (wtm_rec.id_point,wtm_rec.wtm,wtm_rec.dat_b,change.date_change);

	  end if;

	  if change_val.id_field = f_tg then 
	  -- тангенс фи 
  	    select into tg_rec oid,* from act_pnt_tg as tg
            where tg.id_point =change.code_eqp  and tg.dat_e>=change.date_change and tg.dat_b<=change.date_change
            order by tg.dat_e;     

            tg_rec.id_tg:=cast (to_number(change_val.old_value,''999999999'') as int);

            if change.date_change=tg_rec.dat_e then 
              delete from act_pnt_tg where oid = tg_rec.oid;
            else
    	      -- обновим последующую (исправим начало периода)
	      update act_pnt_tg set dat_b=change.date_change
	      where oid = tg_rec.oid;

 	    end if;

            insert into act_pnt_tg (id_point,id_tg,dat_b,dat_e)
            values (tg_rec.id_point,tg_rec.id_tg,tg_rec.dat_b,change.date_change);

	  end if;

	  if change_val.id_field = f_share then 
	  -- процент 
  	    select into share_rec oid,* from act_pnt_share as sh
            where sh.id_point =change.code_eqp  and sh.dat_e>=change.date_change and sh.dat_b<=change.date_change
            order by sh.dat_e;     

            share_rec.share:=to_number(change_val.old_value,''999.99'');

            if change.date_change=share_rec.dat_e then 
              delete from act_pnt_share where oid = share_rec.oid;
            else
    	      -- обновим последующую (исправим начало периода)
	      update act_pnt_share set dat_b=change.date_change
	      where oid = share_rec.oid;

 	    end if;

            insert into act_pnt_share (id_point,share,dat_b,dat_e)
            values (share_rec.id_point,share_rec.share,share_rec.dat_b,change.date_change);

	  end if;

	end loop;

      end if;
--    параметры 
      
      if (change.id_table <> eqptable) and (change.id_table <> metertable) and 
       (change.id_table <> eqptreetable) then

        if change.idk_operation=1 then --удаление
        -- в данном контексте возможно только при замене
        -- обрежем все параметры, которые были позднее (тип их не известен,)
        -- т.к. изменился тип оборудования
          update act_eqm_par_tbl set dat_b=change.date_change 
          where id_eqp=change.code_eqp and 
          dat_e>change.date_change and dat_b<change.date_change;

        end if;

	for change_val in select old_value, id_field
 	from eqd_change_tbl where id_change = change.id and id_record = change.id_record loop

 	 for param in select id from  aci_eqm_par_tbl where id_field=change_val.id_field loop 

 	  -- обрезать период более позднего значения параметра, но его может не быть
          update act_eqm_par_tbl set dat_b=change.date_change 
          where id_eqp=change.code_eqp and id_param=param.id and 
          dat_e>change.date_change and dat_b<change.date_change;
                                          --сдесь не <=, т.к. если =, ничего делать не надо

          -- удалить значение того же параметра на ту же дату, если оно уже есть
          delete from act_eqm_par_tbl where 
          id_eqp=change.code_eqp and id_param=param.id and change.date_change=dat_e;
     
          insert into act_eqm_par_tbl(id_eqp,dat_b,dat_e,id_param,val)
          values (change.code_eqp,(select min(dat_b) from act_eqp_branch_tbl where code_eqp=change.code_eqp),
	  change.date_change,param.id,to_number(change_val.old_value,''999999999.9999''));

         end loop;                    

        end loop;

      end if;
     
  end loop;

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

-----------///////////////////////////////---------------------
