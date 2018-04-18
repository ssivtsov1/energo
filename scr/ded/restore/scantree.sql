--  DROP FUNCTION max (timestamp,timestamp);                                                   
  CREATE or replace FUNCTION max (timestamp,timestamp)
  RETURNS timestamp
  AS                                                                                              
  '
  declare
  date1 Alias for $1;
  date2 Alias for $2;
  begin

  if date1 is NULL then
   RETURN date2;
  end if;

  if date2 is NULL then
   RETURN date1;
  end if;


  if date1>date2 then
   RETURN date1;
  else
   RETURN date2;
  end if;

  end;'                                                                                           
  LANGUAGE 'plpgsql';          
--------------------
  CREATE or replace FUNCTION min (timestamp,timestamp)
  RETURNS timestamp
  AS                                                                                              
  '
  declare
  date1 Alias for $1;
  date2 Alias for $2;
  begin

  if date1 is NULL then
   RETURN date2;
  end if;

  if date2 is NULL then
   RETURN date1;
  end if;


  if date1>date2 then
   RETURN date2;
  else
   RETURN date1;
  end if;

  end;'                                                                                           
  LANGUAGE 'plpgsql';          

------------------------------------------------------
-- Выбор дерева
--  DROP FUNCTION eqc_scantree_fun (integer,timestamp,timestamp);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_scantree_fun (integer,timestamp,timestamp)
  RETURNS int
  AS                                                                                              
  '
  declare
  client Alias for $1;
  begindate Alias for $2;
  enddate Alias for $3;
  node record;
  meter_info record;
  point_info record;
  transform int;
  param record;
  v int;
  vdat_b timestamp;
  vinfinity timestamp;

--  countlost bool;

  begin

  vinfinity:=''2030-01-01'';
   -- выбирается собственное оборудование состоянием на текущий момент (>= enddate)
   --  и использованное на протяжении рассматриваемого периода на текущий момент
   for node in
    Select t.id as id_tree,t.id_client,tt.code_eqp,tt.code_eqp_e,tt.name,tt.oid as eqp_tree_oid,
    eq.type_eqp,eq.num_eqp,eq.loss_power, tt.line_no,tt.parents,dk.calc_lost,tt.lvl,eq.dt_install,
    eu.id_client as use_client, eu.dt_b as dt_useb,eu.dt_e as dt_usee 
    From 
    (eqm_tree_tbl AS t JOIN 
    (eqm_eqp_tree_tbl AS tt JOIN 
    (eqm_equipment_tbl AS eq JOIN eqi_device_kinds_tbl AS dk
       ON (eq.type_eqp=dk.id)) ON (tt.code_eqp=eq.id)) ON (t.id=tt.id_tree))
    left join eqv_eqp_use as eu on ((eu.code_eqp=eq.id) and 
     tintervalov(tinterval(begindate::abstime,enddate::abstime),tinterval(coalesce(eu.dt_b,begindate)::abstime,max(coalesce(eu.dt_e,enddate),eu.dt_b)::abstime)))
    WHERE(
          (
           --собственное оборудование, не исп. для расчета других абонентов в текущем периоде
           (t.id_client=client) and 
             ((eu.id_client is null)  -- никем не использовалось в тек. периоде
             --?? пусть пока так, хотя если использовался не все время, то что тогда???
              -- или использоаплось, но не в текущем периоде
--              or not tintervalov(tinterval(begindate::abstime,enddate:abstime),tinterval(coalesce(dt_useb,begindate)::abstime,coalesce(dt_usee,enddate)::abstime)))
             )
--           (eq.id not in (select code_eqp from eqm_eqp_use_tbl where dt_install<enddate))
          )or      
--          (eq.id in (select code_eqp from eqm_eqp_use_tbl where id_client =client and dt_install<enddate)
            -- или чужое, используемое данным абонентом в текущем периоде времени
          (
           (eu.id_client = client ) 
           --and tintervalov(tinterval(begindate::abstime,enddate:abstime),tinterval(dt_useb::abstime,coalesce(dt_usee,enddate)::abstime))
          )
         ) and (eq.dt_install<enddate) and (tt.line_no=0)  --пока дубли точек уберем
    Order By tt.lvl,tt.line_no                           
   loop

--       if node.type_eqp = 13 then -- точка коммутации
           --!!!!!!!!!!!!!!!

       --else  --другое оборудование
        --vdat_b:=max(max(node.dt_install::timestamp,coalesce(node.dt_useb,begindate)),begindate);
        vdat_b:=max(node.dt_install::timestamp,begindate);
--        vdat_e:=
        
        insert into act_eqp_branch_tbl (node_oid,id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e,lvl,line_no,id_client,id_rclient,loss_power) 
        values (node.eqp_tree_oid,node.id_tree,node.code_eqp,node.code_eqp_e,node.type_eqp,vdat_b,
	vinfinity,node.lvl,node.line_no,client,node.id_client,node.loss_power);
	--/\enddate устремляем в бесконечность
        if node.type_eqp = 9 then -- граница раздела
            -- !!!!!!!1 надо вызвать данную ф-цию для другого обонента
        end if;

	if node.type_eqp = 1 then -- счетчик

	  --  коеф. трансформации на конец периода
	  -- transform:=eqm_ktr_calc_fun(node.code_eqp_e,node.id_tree);

 	  select into meter_info code_group,class,id_type_eqp,count_lost from eqm_meter_tbl where code_eqp = node.code_eqp;

	  insert into act_demand_tbl (id_meter,num_eqp,id_type_eqp,dat_b,dat_e,k_tr)
	  values (node.code_eqp,node.num_eqp,meter_info.id_type_eqp,
          vdat_b,vinfinity,1);

          --энергия
          insert into act_met_knd_tbl (id_meter,num_eqp,kind_energy,dat_b_energy,dat_e)
          select node.code_eqp,node.num_eqp,me.kind_energy,me.date_inst,vinfinity 
          from eqd_meter_energy_tbl as me 
	  where me.code_eqp=node.code_eqp;
	  -- зоны
          insert into act_met_zn_tbl (id_meter,num_eqp,id_zone,dat_b_zone,dat_e)
          select node.code_eqp,node.num_eqp,mz.zone,mz.dt_zone_install,vinfinity 
          from eqd_meter_zone_tbl as mz
	  where mz.code_eqp=node.code_eqp;


--        select into table act_met_kndzn_tbl node.code_eqp,node.num_eqp,me.kind_energy,mz.zone,max(me.date_inst,mz.dt_zone_install) 
--	from eqd_meter_zone_tbl as mz,eqd_meter_energy_tbl as me 
--	where mz.code_eqp=node.code_eqp and me.code_eqp=node.code_eqp),''2999-01-01'');

        end if;
--	if node.calc_lost = 1 then -- потери

	if node.type_eqp = 12 then -- точка учета

           select into point_info power,id_tarif,wtm,id_tg,share from eqm_point_tbl where code_eqp = node.code_eqp;

 	   insert into act_pnt_pwr (id_point,power,dat_b,dat_e)
	   values (node.code_eqp,point_info.power,vdat_b,vinfinity);

 	   insert into act_pnt_tarif (id_point,id_tarif,dat_b,dat_e)
	   values (node.code_eqp,point_info.id_tarif,vdat_b,vinfinity);

 	   insert into act_pnt_wtm (id_point,wtm,dat_b,dat_e)
	   values (node.code_eqp,point_info.wtm,vdat_b,vinfinity);

 	   insert into act_pnt_tg (id_point,id_tg,dat_b,dat_e)
	   values (node.code_eqp,point_info.id_tg,vdat_b,vinfinity);

 	   insert into act_pnt_share (id_point,share,dat_b,dat_e)
	   values (node.code_eqp,point_info.share,vdat_b,vinfinity);

           insert into act_pnt_knd (id_point,kind_energy,dat_b,dat_e)
           select node.code_eqp,pe.kind_energy,max(pe.dt_instal::timestamp,vdat_b),vinfinity 
           from eqd_point_energy_tbl as pe 
	   where pe.code_eqp=node.code_eqp;

	end if;

	 for param in select par.id,par.id_field, st.name as tablename,sf.name as fieldname
         from aci_eqm_par_tbl as par, syi_table_tbl as st,syi_field_tbl as sf
	 where (par.type_eqp=node.type_eqp) and (par.id_field=sf.id) and (sf.id_table=st.id) loop

          insert into act_eqm_par_tbl(id_eqp,dat_b,dat_e,id_param)
          values (node.code_eqp,vdat_b,vinfinity,param.id);
                                                                                
--          EXECUTE ''update act_eqm_par_tbl as pv set pv.val= cast(dt.''||Text(param.fieldname)||'' as numeric(14,4))
--          ''from  ''||quote_ident(param.tablename)||'' as dt where (pv.id_eqp=''||quote_literal(node.code_eqp)||
--          '') and (pv.id_param =''||quote_literal(param.id)||'') and (dt.code_eqp=pv.id_eqp);'';

         Raise Notice ''имя поля %'',param.fieldname;
         Raise Notice ''имя табл %'',param.tablename;
         Raise Notice ''оборуд %'',node.code_eqp;
         Raise Notice ''параметр  %'',param.id;

          EXECUTE ''update act_eqm_par_tbl set val= cast(dt.''||Text(param.fieldname)||'' as numeric(14,4))''||
          ''from  ''||quote_ident(param.tablename)||'' as dt where (id_eqp=''||quote_literal(node.code_eqp)||
          '') and (id_param =''||quote_literal(param.id)||'') and (dt.code_eqp=id_eqp);'';
          -- многие параметры на самом деле находятся в таблице типов, но они однозначно 
          -- определяются типом оборудования
	 end loop;

        --end if;

      -- end if;

   end loop;
--   RAISE NOTICE ''Redy1''; 
   v := eqc_scanchange_fun(client,begindate,enddate);  --поиск изм.
   v := eqc_trim_end_fun(client,begindate,enddate);    --обрезка по enddate 
   v := eqc_ktr_calc_fun (client);                     -- расчет. к.тр.

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
