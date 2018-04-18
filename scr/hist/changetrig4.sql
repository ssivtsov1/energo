-----------///////////////////////////////---------------------
DROP TRIGGER eqc_delswitch_trg ON eqm_switch_tbl;
DROP TRIGGER eqc_edswitch_trg ON eqm_switch_tbl;
DROP TRIGGER eqc_delcompens_trg ON eqm_compensator_tbl;
DROP TRIGGER eqc_delcompensi_trg ON eqm_compensator_i_tbl;
DROP TRIGGER eqc_delfuse_trg ON eqm_fuse_tbl;
DROP TRIGGER eqc_edcompens_trg ON eqm_compensator_tbl;
DROP TRIGGER eqc_edcompensi_trg ON eqm_compensator_i_tbl;
DROP TRIGGER eqc_edfuse_trg ON eqm_fuse_tbl;
DROP TRIGGER eqc_dellinec_trg ON eqm_line_c_tbl;
DROP TRIGGER eqc_edlinec_trg ON eqm_line_c_tbl;
DROP TRIGGER eqc_deljack_trg ON eqm_jack_tbl;
DROP TRIGGER eqc_edjack_trg ON eqm_jack_tbl;
DROP TRIGGER eqc_delborder_trg ON eqm_borders_tbl;
DROP TRIGGER eqc_edborder_trg ON eqm_borders_tbl;
DROP TRIGGER eqc_dellinea_trg ON eqm_line_a_tbl;
DROP TRIGGER eqc_edlinea_trg ON eqm_line_a_tbl;
DROP TRIGGER eqc_delmeter_trg ON eqm_meter_tbl;
DROP TRIGGER eqc_edmeter_trg ON eqm_meter_tbl;
DROP TRIGGER eqc_delpoint_trg ON eqm_point_tbl;
DROP TRIGGER eqc_edpoint_trg ON eqm_point_tbl;
DROP TRIGGER eqc_delfider_trg ON eqm_fider_tbl;
DROP TRIGGER eqc_delground_trg ON eqm_ground_tbl;
DROP TRIGGER eqc_delstation_trg ON eqm_compens_station_tbl;
DROP TRIGGER eqc_edfider_trg ON eqm_fider_tbl;
DROP TRIGGER eqc_edground_trg ON eqm_ground_tbl;
DROP TRIGGER eqc_edstation_trg ON eqm_compens_station_tbl;


DROP TRIGGER eqc_newswitch_trg ON eqm_switch_tbl;
DROP TRIGGER eqc_newcompens_trg ON eqm_compensator_tbl;
DROP TRIGGER eqc_newcompensi_trg ON eqm_compensator_i_tbl;
DROP TRIGGER eqc_newfuse_trg ON eqm_fuse_tbl;
DROP TRIGGER eqc_newlinec_trg ON eqm_line_c_tbl;
DROP TRIGGER eqc_newjack_trg ON eqm_jack_tbl;
DROP TRIGGER eqc_newborder_trg ON eqm_borders_tbl;
DROP TRIGGER eqc_newlinea_trg ON eqm_line_a_tbl;
DROP TRIGGER eqc_newmeter_trg ON eqm_meter_tbl;
DROP TRIGGER eqc_newpoint_trg ON eqm_point_tbl;
DROP TRIGGER eqc_newfider_trg ON eqm_fider_tbl;
DROP TRIGGER eqc_newground_trg ON eqm_ground_tbl;
DROP TRIGGER eqc_newstation_trg ON eqm_compens_station_tbl;


DROP FUNCTION eqc_delswitch_fun ();                                                   
DROP FUNCTION eqc_delcompens_fun ();                                                   
DROP FUNCTION eqc_dellinec_fun ();                                                   
DROP FUNCTION eqc_delpoint_fun ();                                                   
DROP FUNCTION eqc_delmeter_fun ();                                                   
DROP FUNCTION eqc_deljack_fun ();                                                   
DROP FUNCTION eqc_delborder_fun ();                                                   
DROP FUNCTION eqc_dellinea_fun ();                                                   
                                                                                                  

-- удаление экземпляра оборудования 
                                                                                                  
  CREATE or replace FUNCTION eqc_deleqpdet_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  oldrec record;

  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;

  v_h_tablename varchar;
  dtstr varchar;
  begin                

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||'' and dt_e is null;'';

--       delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_e is null;
       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  -- получим oid удаляемой записи
  old_id:=old.code_eqp;

-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old_id and t.id=tt.id_tree group by id_client limit 1 loop

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation limit 1 ;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||'' and dt_e is null;'';

    RETURN OLD;
  end if;

  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,change.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--    update eqt_change_tbl set processing=1 where id_operation=operation;
--  end if;

  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||'' and dt_e is null and  dt_b = ''||quote_literal(change.date_change);

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(change.date_change)||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||'' and dt_e is null;'';

--  update eqm_switch_h set dt_e = change.date_change where code_eqp = OLD.code_eqp and dt_e is null;
--  end loop; --цикл по обонентам
  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_delswitch_trg 
before  DELETE 
ON eqm_switch_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delcompens_trg 
before  DELETE 
ON eqm_compensator_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delcompensi_trg 
before  DELETE 
ON eqm_compensator_i_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delfuse_trg 
before  DELETE 
ON eqm_fuse_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delpoint_trg 
before  DELETE 
ON eqm_point_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delmeter_trg 
before  DELETE 
ON eqm_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_dellinec_trg 
before  DELETE 
ON eqm_line_c_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_deljack_trg 
before  DELETE 
ON eqm_jack_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delborder_trg 
before  DELETE 
ON eqm_borders_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_dellinea_trg 
before  DELETE 
ON eqm_line_a_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delfider_trg 
before  DELETE 
ON eqm_fider_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delstation_trg 
before  DELETE 
ON eqm_compens_station_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

CREATE TRIGGER eqc_delground_trg 
before  DELETE 
ON eqm_ground_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpdet_fun();

-----------///////////////////////////////---------------------
-- создание 
                                                                                                  
  CREATE or replace FUNCTION eqc_neweqpdet_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';
  -- при вставке новой строки она должна продублироваться в таблице замены 
  -- независимо от редима

  EXECUTE ''insert into ''|| v_h_tablename ||
  '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
  '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp);

--  insert into eqm_eqp_tree_h
--  select eqd.*, eq.dt_install  from   as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp)
--  where  code_eqp = NEW.code_eqp ;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


------------------------------------------------------------------------------------------------
  CREATE or replace FUNCTION eqc_newpointdet_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

   insert into eqm_point_h (code_eqp,id_department,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,
   share,ldemand,pdays,count_itr,itr_comment,cmp,zone,flag_hlosts,id_depart,main_losts,ldemandr,ldemandg,id_un,
   lost_nolost,power,id_extra,day_control,reserv,in_lost,connect_power,id_position,con_power_kva,safe_category,disabled,dt_b)
 select eqd.code_eqp,eqd.id_department,eqd.id_tarif,eqd.industry,eqd.count_lost,eqd.d,eqd.wtm,eqd.id_tg,eqd.id_voltage,eqd.share,eqd.ldemand,eqd.pdays,eqd.count_itr,
            eqd.itr_comment,eqd.cmp,eqd.zone,eqd.flag_hlosts,eqd.id_depart,eqd.main_losts,eqd.ldemandr,eqd.ldemandg,eqd.id_un,eqd.lost_nolost,eqd.power,eqd.id_extra,eqd.day_control,eqd.reserv,eqd.in_lost,eqd.connect_power,eqd.id_position,eqd.con_power_kva,eqd.safe_category,eqd.disabled, 
  eq.dt_install  from eqm_point_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;
   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------------------------------------
  CREATE or replace FUNCTION eqc_newmeterdet_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

    insert into eqm_meter_h (code_eqp,id_department,id_type_eqp,dt_control,d,nm,account,main_duble,class,code_group,count_lost,warm ,industry,count_met, met_comment, warm_comment,magnet,dt_b)
    select eqd.*, eq.dt_install  from eqm_meter_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------------------------------------
  CREATE or replace FUNCTION eqc_newcompidet_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

    insert into eqm_compensator_i_h (code_eqp,id_department,id_type_eqp,date_check,dt_b)
    select eqd.*, eq.dt_install  from eqm_compensator_i_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------------------------------------
  CREATE or replace FUNCTION eqc_newfiderdet_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

   insert into eqm_fider_h (code_eqp,id_department,id_voltage,losts_coef,id_position,l04_count,l04_length,l04f1_length,l04f3_length,Fgcp,balans_only,id_station,dt_b)
   select eqd.*, eq.dt_install  from eqm_fider_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------------------------------------
  CREATE or replace FUNCTION eqc_newstation_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

   insert into eqm_compens_station_h (code_eqp,id_department,id_voltage,abon_ps,power, comp_cnt, id_type1, id_type2, id_type3, id_type4,p_regday,date_regday,dt_b)
   select eqd.code_eqp,eqd.id_department,eqd.id_voltage,eqd.abon_ps,eqd.power, eqd.comp_cnt, eqd.id_type1, eqd.id_type2, eqd.id_type3, eqd.id_type4, eqd.p_regday, eqd.date_regday, eq.dt_install  
   from eqm_compens_station_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------------------------------------

  CREATE or replace FUNCTION eqc_newground_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

   insert into eqm_ground_h (code_eqp,id_department,power,wtm,dt_b)
   select eqd.*, eq.dt_install  from eqm_ground_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
---------------------------------------------------------------------------------------------

  CREATE or replace FUNCTION eqc_newswitch_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   v_h_tablename varchar;
  begin

    insert into eqm_switch_h (code_eqp,id_department,id_type_eqp,folk,amperage_nom,dt_b)
    select eqd.*, eq.dt_install  from eqm_switch_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------------------------------------

CREATE TRIGGER eqc_newswitch_trg 
after insert 
ON eqm_switch_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newswitch_fun();

CREATE TRIGGER eqc_newcompens_trg 
after insert 
ON eqm_compensator_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpdet_fun();

CREATE TRIGGER eqc_newcompensi_trg 
after insert 
ON eqm_compensator_i_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newcompidet_fun();

CREATE TRIGGER eqc_newfuse_trg 
after insert 
ON eqm_fuse_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpdet_fun();

CREATE TRIGGER eqc_newpoint_trg 
after insert 
ON eqm_point_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newpointdet_fun();


CREATE TRIGGER eqc_newmeter_trg 
after insert 
ON eqm_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newmeterdet_fun();

CREATE TRIGGER eqc_newlinec_trg 
after insert 
ON eqm_line_c_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpdet_fun();

CREATE TRIGGER eqc_newjack_trg 
after insert 
ON eqm_jack_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpdet_fun();

CREATE TRIGGER eqc_newborder_trg 
after insert 
ON eqm_borders_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpdet_fun();

CREATE TRIGGER eqc_newlinea_trg 
after insert 
ON eqm_line_a_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpdet_fun();

CREATE TRIGGER eqc_newfider_trg 
after insert 
ON eqm_fider_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newfiderdet_fun();

CREATE TRIGGER eqc_newstation_trg 
after insert 
ON eqm_compens_station_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newstation_fun();

CREATE TRIGGER eqc_newground_trg 
after insert 
ON eqm_ground_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newground_fun();

-------------------------------------------------------------------------
-- изменение экземпляра оборудования -переключателя
  DROP FUNCTION eqc_edswitch_fun ();                                                   
                                                                                                  
  CREATE FUNCTION eqc_edswitch_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                


--  Raise Notice ''  - ++'';  

  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0)) and
     (coalesce(old.folk,0)=coalesce(new.folk,0)) and 
     (coalesce(old.amperage_nom,0)=coalesce(new.amperage_nom,0))  
  then 
    return NEW;
  end if;

--  Raise Notice ''  - -++'';  
  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

--       EXECUTE ''insert into ''|| v_h_tablename ||
--       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       insert into eqm_switch_h (code_eqp,id_department,id_type_eqp,folk,amperage_nom,dt_b)
       select eqd.*, eq.dt_install  from eqm_switch_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;


       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    insert into eqm_switch_h (code_eqp,id_department,id_type_eqp,folk,amperage_nom,dt_b)
    select eqd.*, eq.dt_install  from eqm_switch_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;


--    EXECUTE ''insert into ''|| v_h_tablename ||
--    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
   end if;

   --------------------------------------------------------------------------


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then 
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;
   vdate_change:= change.date_change;
  end loop;

--  Raise Notice ''  - - - - ++'';  
  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

--  delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_b = change.date_change;

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';


--  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(vdate_change)||
--  '' from ''||TG_RELNAME::varchar||
--  '' where code_eqp = ''||quote_literal(NEW.code_eqp);

  insert into eqm_switch_h (code_eqp,id_department,id_type_eqp,folk,amperage_nom,dt_b)
  select *, vdate_change from eqm_switch_tbl where code_eqp = NEW.code_eqp;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам
  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edswitch_trg 
after  update 
ON eqm_switch_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edswitch_fun();

-------------------------------------------------------------------------
-- изменение экземпляра оборудования -трансф. или предохр.
  DROP FUNCTION eqc_edcompens_fun ();                                                   
                                                                                                  
  CREATE FUNCTION eqc_edcompens_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin     


  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0))  then 
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

       EXECUTE ''insert into ''|| v_h_tablename ||
       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    EXECUTE ''insert into ''|| v_h_tablename ||
    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
   end if;

   --------------------------------------------------------------------------


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then 
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;
   vdate_change:= change.date_change;
  end loop;

--  Raise Notice ''  - - - - ++'';  
  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

--  delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_b = change.date_change;

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';


  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(vdate_change)||
  '' from ''||TG_RELNAME::varchar||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp);


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



-------------------------------------------------------------------------
-- изменение экземпляра оборудования -трансф измерительного

  CREATE or replace FUNCTION eqc_edcompensi_fun()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                

  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0)) and 
     (coalesce(old.date_check,now()::date)=coalesce(NEW.date_check,now()::date)) 
  then 
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

--       EXECUTE ''insert into ''|| v_h_tablename ||
--       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       insert into eqm_compensator_i_h (code_eqp,id_department,id_type_eqp,check_date,dt_b)
       select eqd.*, eq.dt_install  from eqm_compensator_i_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
   if change.enabled=0 then

     EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
     '' and dt_e is null;'';

     insert into eqm_compensator_i_h (code_eqp,id_department,id_type_eqp,date_check,dt_b)
     select eqd.*, eq.dt_install  from eqm_compensator_i_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

     RETURN NEW;
   end if;


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;
   vdate_change:= change.date_change;
  end loop;


  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';


  insert into eqm_compensator_i_h (code_eqp,id_department,id_type_eqp,date_check,dt_b)
  select *, vdate_change from eqm_compensator_i_tbl where code_eqp = NEW.code_eqp;

  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--  insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                  

CREATE TRIGGER eqc_edcompens_trg 
after  UPDATE 
ON eqm_compensator_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edcompens_fun();

CREATE TRIGGER eqc_edcompensi_trg 
after  UPDATE 
ON eqm_compensator_i_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edcompensi_fun();

CREATE TRIGGER eqc_edfuse_trg 
after  UPDATE 
ON eqm_fuse_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edcompens_fun();



-------------------------------------------------------------------------
-- изменение экземпляра оборудования -линии кабельной
  DROP FUNCTION eqc_edlinec_fun ();                                                   
                                                                                                  
  CREATE FUNCTION eqc_edlinec_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                


  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0)) and 
     (coalesce(old.length,0)=coalesce(new.length,0)) and
     (coalesce(old.id_voltage,0)=coalesce(new.id_voltage,0)) 
  then 
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

       EXECUTE ''insert into ''|| v_h_tablename ||
       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    EXECUTE ''insert into ''|| v_h_tablename ||
    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
   end if;

   --------------------------------------------------------------------------


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then 
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;
   vdate_change:= change.date_change;
  end loop;

--  Raise Notice ''  - - - - ++'';  
  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

--  delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_b = change.date_change;

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';


  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(vdate_change)||
  '' from ''||TG_RELNAME::varchar||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp);


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edlinec_trg 
after  update 
ON eqm_line_c_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edlinec_fun();

-------------------------------------------------------------------------
-- изменение экземпляра оборудования -компенсатора
  DROP FUNCTION eqc_edjack_fun ();                                                   
                                                                                                  
  CREATE FUNCTION eqc_edjack_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                


  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0)) and 
     (coalesce(old.quantity,0)=coalesce(new.quantity,0)) 
  then 
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

       EXECUTE ''insert into ''|| v_h_tablename ||
       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    EXECUTE ''insert into ''|| v_h_tablename ||
    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
   end if;

   --------------------------------------------------------------------------


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then 
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;
   vdate_change:= change.date_change;
  end loop;

--  Raise Notice ''  - - - - ++'';  
  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

--  delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_b = change.date_change;

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';


  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(vdate_change)||
  '' from ''||TG_RELNAME::varchar||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp);


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edjack_trg 
after  update 
ON eqm_jack_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edjack_fun();

-------------------------------------------------------------------------
-- изменение экземпляра оборудования -линии воздушной
  DROP FUNCTION eqc_edlinea_fun ();                                                   
                                                                                                  
  CREATE FUNCTION eqc_edlinea_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                


  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0)) and 
     (coalesce(old.length,0)=coalesce(new.length,0)) and
     (coalesce(old.pillar,0)=coalesce(new.pillar,0)) and
     (coalesce(old.pillar_step,0)=coalesce(new.pillar_step,0)) and
     (coalesce(old.pendant,0)=coalesce(new.pendant,0)) and
     (coalesce(old.earth,0)=coalesce(new.earth,0)) and
     (coalesce(old.id_voltage,0)=coalesce(new.id_voltage,0)) 
  then 
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

       EXECUTE ''insert into ''|| v_h_tablename ||
       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    EXECUTE ''insert into ''|| v_h_tablename ||
    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
   end if;

   --------------------------------------------------------------------------


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then 
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;
   vdate_change:= change.date_change;
  end loop;

--  Raise Notice ''  - - - - ++'';  
  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

--  delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_b = change.date_change;

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';


  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(vdate_change)||
  '' from ''||TG_RELNAME::varchar||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp);


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edlinea_trg 
after  update 
ON eqm_line_a_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edlinea_fun();


-----------///////////////////////////////---------------------
-- изменение экземпляра оборудования -счетчика
CREATE OR REPLACE FUNCTION eqc_edmeter_fun()
  RETURNS trigger AS
$BODY$
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                

  if (coalesce(old.id_type_eqp,0)=coalesce(new.id_type_eqp,0)) and 
     (coalesce(old.dt_control,now()::date)=coalesce(NEW.dt_control,now()::date)) and 
     (coalesce(old.nm,'')=coalesce(NEW.nm,'')) and
     (coalesce(old.warm,0)=coalesce(NEW.warm,0)) and 
     (coalesce(old.warm_comment,'')=coalesce(NEW.warm_comment,'')) and 
     (coalesce(old.count_met,0)=coalesce(NEW.count_met,0)) and 
     (coalesce(old.met_comment,'')=coalesce(NEW.met_comment,'')) and
     (coalesce(old.magnet,0)=coalesce(NEW.magnet,0)) 

  then 
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, '_tbl'))::varchar||'_h';

  for flag in select to_number(value_ident,'9') as val from syi_sysvars_tbl where ident='eqp_log' loop
    if flag.val=0 then 

       EXECUTE 'delete from '|| v_h_tablename ||' where code_eqp = '||quote_literal(OLD.code_eqp)||
       ' and dt_e is null;';

--       EXECUTE 'insert into '|| v_h_tablename ||
--       ' select eqd.*, eq.dt_install  from '||TG_RELNAME::varchar||
--       ' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) '||
--       ' where code_eqp = '||quote_literal(NEW.code_eqp);

       insert into eqm_meter_h (code_eqp,id_department,id_type_eqp,dt_control,d,nm,account,main_duble,class,code_group,count_lost,warm ,industry,count_met, met_comment, warm_comment,magnet,dt_b)
       select eqd.*, eq.dt_install  from eqm_meter_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice '  - - -++';  
  -- получить код текущей операции
  select into operation currval('"eqm_change_oper_seq"'::text);
  vmmgg:=fun_mmgg();   --текущий mmgg
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
   if change.enabled=0 then

     EXECUTE 'delete from '|| v_h_tablename ||' where code_eqp = '||quote_literal(OLD.code_eqp)||
     ' and dt_e is null;';

     insert into eqm_meter_h (code_eqp,id_department,id_type_eqp,dt_control,d,nm,account,main_duble,class,code_group,count_lost,warm ,industry,count_met, met_comment, warm_comment,magnet,dt_b)
     select eqd.*, eq.dt_install  from eqm_meter_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

     RETURN NEW;
   end if;


   if (coalesce(old.id_type_eqp,0)<>coalesce(new.id_type_eqp,0)) or 
     (coalesce(old.warm,0)<>coalesce(NEW.warm,0)) or 
     (coalesce(old.count_met,0)<>coalesce(NEW.count_met,0)) 
   then 

     select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
      mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

     if found then 
      if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
         dtstr:=to_char(vbill.dat_e,'DD.MM.YYYY');
         Raise EXCEPTION 'Дата изменения меньше даты последнего счета % ! ',dtstr;
      end if; 

     end if ;
   end if ;
   
   vdate_change:= change.date_change;
  end loop;


  EXECUTE 'delete from '|| v_h_tablename ||' where code_eqp = '||quote_literal(NEW.code_eqp)||
  ' and dt_b >='||quote_literal(vdate_change);

  EXECUTE 'update '|| v_h_tablename ||' set dt_e = '||quote_literal(vdate_change)||
  ' where code_eqp = '||quote_literal(NEW.code_eqp)||' and dt_b <= '||quote_literal(vdate_change)||' and '||quote_literal(vdate_change)||
  '<= coalesce (dt_e,'||quote_literal(vdate_change)||')';


  insert into eqm_meter_h (code_eqp,id_department,id_type_eqp,dt_control,d,nm,account,main_duble,class,code_group,count_lost,warm ,industry,count_met, met_comment, warm_comment,magnet,dt_b)
  select *, vdate_change from eqm_meter_tbl where code_eqp = NEW.code_eqp;

  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;$BODY$
  LANGUAGE 'plpgsql';          



CREATE TRIGGER eqc_edmeter_trg 
after  update 
ON eqm_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edmeter_fun();

-----------///////////////////////////////---------------------

-- изменение 
--  DROP FUNCTION eqc_edpoint_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_edpoint_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;  
  vbill record;
  vmmgg date;
  dtstr varchar;
begin                


  if   coalesce(old.id_tarif,0)=coalesce(NEW.id_tarif,0) and
       coalesce(old.industry,0)=coalesce(NEW.industry,0) and
       coalesce(old.count_lost,0)=coalesce(NEW.count_lost,0) and
       coalesce(old.d,0)=coalesce(NEW.d,0) and
       coalesce(old.wtm,0)=coalesce(NEW.wtm,0) and
       coalesce(old.id_tg,0)=coalesce(NEW.id_tg,0) and
       coalesce(old.id_voltage,0)=coalesce(NEW.id_voltage,0) and
       coalesce(old.share,0)=coalesce(NEW.share,0) and
       coalesce(old.ldemand,0)=coalesce(NEW.ldemand,0) and
       coalesce(old.ldemandr,0)=coalesce(NEW.ldemandr,0) and
       coalesce(old.ldemandg,0)=coalesce(NEW.ldemandg,0) and
       coalesce(old.pdays,0)=coalesce(NEW.pdays,0) and
       coalesce(old.count_itr,0)=coalesce(NEW.count_itr,0) and
       coalesce(old.cmp,0)=coalesce(NEW.cmp,0) and
       coalesce(old.flag_hlosts,0)=coalesce(NEW.flag_hlosts,0) and
       coalesce(old.id_depart,0)=coalesce(NEW.id_depart,0) and
       coalesce(old.main_losts,0)=coalesce(NEW.main_losts,0) and
       coalesce(old.id_un,0)=coalesce(NEW.id_un,0) and
       coalesce(old.lost_nolost,0)=coalesce(NEW.lost_nolost,0) and
       coalesce(old.itr_comment,'''')=coalesce(NEW.itr_comment,'''') and
       coalesce(old.id_extra,0)=coalesce(NEW.id_extra,0)   and
       coalesce(old.id_position,0)=coalesce(NEW.id_position,0) and
       coalesce(old.disabled,0)=coalesce(NEW.disabled,0) and
       coalesce(old.in_lost,0)=coalesce(NEW.in_lost,0) and 
       coalesce(old.power,0)=coalesce(NEW.power,0) and 
       coalesce(old.connect_power,0)=coalesce(NEW.connect_power,0) and 
       coalesce(old.con_power_kva,0)=coalesce(NEW.con_power_kva,0) and 
       coalesce(old.safe_category,0)=coalesce(NEW.safe_category,0) 
      -- and coalesce(old.day_control,0)=coalesce(NEW.day_control,0) 
  then                

--    if (coalesce(old.connect_power,0)<>coalesce(NEW.connect_power,0)) or 
--       (coalesce(old.power,0)<>coalesce(NEW.power,0)) or
--       (coalesce(old.safe_category,0)<>coalesce(NEW.safe_category,0)) or
--       (coalesce(old.con_power_kva,0)<>coalesce(NEW.con_power_kva,0))  then
--       --сентябрь 2012 
--      update eqm_point_h set connect_power = NEW.connect_power, con_power_kva = NEW.con_power_kva, power = NEW.power, safe_category = NEW.safe_category
--      where code_eqp = NEW.code_eqp and dt_e is null;
--    end if;

    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

--       EXECUTE ''insert into ''|| v_h_tablename ||
--       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

         insert into eqm_point_h (code_eqp,id_department,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,share,ldemand,pdays,count_itr,
         itr_comment,cmp,zone,flag_hlosts,id_depart,main_losts,ldemandr,ldemandg,id_un,lost_nolost,power,id_extra,day_control,reserv,in_lost,connect_power,id_position,con_power_kva,safe_category,disabled,dt_b)
           select eqd.code_eqp,eqd.id_department,eqd.id_tarif,eqd.industry,eqd.count_lost,eqd.d,eqd.wtm,eqd.id_tg,eqd.id_voltage,eqd.share,eqd.ldemand,eqd.pdays,eqd.count_itr,
            eqd.itr_comment,eqd.cmp,eqd.zone,eqd.flag_hlosts,eqd.id_depart,eqd.main_losts,eqd.ldemandr,eqd.ldemandg,eqd.id_un,eqd.lost_nolost,eqd.power,eqd.id_extra,eqd.day_control,eqd.reserv,eqd.in_lost,eqd.connect_power,eqd.id_position,eqd.con_power_kva,eqd.safe_category,eqd.disabled, vdate_change, 
            eq.dt_install  from eqm_point_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;


       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

     EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
     '' and dt_e is null;'';

     insert into eqm_point_h (code_eqp,id_department,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,share,ldemand,pdays,count_itr,
     itr_comment,cmp,zone,flag_hlosts,id_depart,main_losts,ldemandr,ldemandg,id_un,lost_nolost,power,id_extra,day_control,reserv,in_lost,connect_power,id_position,con_power_kva,safe_category,disabled,dt_b)
       select eqd.code_eqp,eqd.id_department,eqd.id_tarif,eqd.industry,eqd.count_lost,eqd.d,eqd.wtm,eqd.id_tg,eqd.id_voltage,eqd.share,eqd.ldemand,eqd.pdays,eqd.count_itr,
         eqd.itr_comment,eqd.cmp,eqd.zone,eqd.flag_hlosts,eqd.id_depart,eqd.main_losts,eqd.ldemandr,eqd.ldemandg,eqd.id_un,eqd.lost_nolost,eqd.power,eqd.id_extra,eqd.day_control,eqd.reserv,eqd.in_lost,eqd.connect_power,eqd.id_position,eqd.con_power_kva,eqd.safe_category,eqd.disabled,
          eq.dt_install  
         from eqm_point_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;

     RETURN NEW;
   end if;


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
   mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if ;

   vdate_change:= change.date_change;
  end loop;

  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(vdate_change);

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(vdate_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(vdate_change)||'' and ''||quote_literal(vdate_change)||
  ''<= coalesce (dt_e,''||quote_literal(vdate_change)||'')'';

--  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(change.date_change)||
--  '' from ''||TG_RELNAME::varchar||
--  '' where code_eqp = ''||quote_literal(NEW.code_eqp);

  insert into eqm_point_h (code_eqp,id_department,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,share,ldemand,pdays,count_itr,
  itr_comment,cmp,zone,flag_hlosts,id_depart,main_losts,ldemandr,ldemandg,id_un,lost_nolost,power,id_extra,day_control,reserv,in_lost,connect_power,id_position,con_power_kva,safe_category,disabled,dt_b)
  select eqd.code_eqp,eqd.id_department,eqd.id_tarif,eqd.industry,eqd.count_lost,eqd.d,eqd.wtm,eqd.id_tg,eqd.id_voltage,eqd.share,eqd.ldemand,eqd.pdays,eqd.count_itr,
  eqd.itr_comment,eqd.cmp,eqd.zone,eqd.flag_hlosts,eqd.id_depart,eqd.main_losts,eqd.ldemandr,eqd.ldemandg,eqd.id_un,eqd.lost_nolost,eqd.power,eqd.id_extra,eqd.day_control,eqd.reserv,eqd.in_lost,eqd.connect_power,eqd.id_position,eqd.con_power_kva,eqd.safe_category,eqd.disabled, vdate_change 
 from eqm_point_tbl as eqd where code_eqp = NEW.code_eqp;

  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = vdate_change where id = old.code_eqp;

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edpoint_trg 
after  update 
ON eqm_point_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edpoint_fun();

-----------///////////////////////////////---------------------

-- изменение 
  CREATE or replace FUNCTION eqc_edfider_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;  
  vbill record;
  vmmgg date;
  dtstr varchar;
  vold_dt date;
begin                

    if coalesce(old.id_voltage,0)=coalesce(NEW.id_voltage,0) and 
       coalesce(old.id_position,0)=coalesce(NEW.id_position,0) and 
       coalesce(old.losts_coef,0)=coalesce(NEW.losts_coef,0) and 
       coalesce(old.l04_count,0)=coalesce(NEW.l04_count,0) and 
       coalesce(old.l04_length,0)=coalesce(NEW.l04_length,0) and 
       coalesce(old.l04f1_length,0)=coalesce(NEW.l04f1_length,0) and 
       coalesce(old.l04f3_length,0)=coalesce(NEW.l04f3_length,0) and 
       coalesce(old.Fgcp,0)=coalesce(NEW.Fgcp,0) and  
       coalesce(old.balans_only,0)=coalesce(NEW.balans_only,0) and 
       coalesce(old.id_station,0)=coalesce(NEW.id_station,0)  
    then
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

       insert into eqm_fider_h (code_eqp,id_department,id_voltage,losts_coef,id_position,l04_count,l04_length,l04f1_length,l04f3_length,Fgcp,balans_only,id_station,dt_b)
        select eqd.*, eq.dt_install  from eqm_fider_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;


--       EXECUTE ''insert into ''|| v_h_tablename ||
--       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

    select into vold_dt dt_b from eqm_fider_h where code_eqp = OLD.code_eqp and dt_e is null;

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    insert into eqm_fider_h (code_eqp,id_department,id_voltage,losts_coef,id_position,l04_count,l04_length,l04f1_length,l04f3_length,Fgcp,balans_only,id_station,dt_b)
    select eqd.*, coalesce(vold_dt,eq.dt_install)  from eqm_fider_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) where code_eqp = NEW.code_eqp;


--    EXECUTE ''insert into ''|| v_h_tablename ||
--    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
  end if;



  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(change.date_change);

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(change.date_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(change.date_change)||'' and ''||quote_literal(change.date_change)||
  ''<= coalesce (dt_e,''||quote_literal(change.date_change)||'')'';

--  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(change.date_change)||
--  '' from ''||TG_RELNAME::varchar||
--  '' where code_eqp = ''||quote_literal(NEW.code_eqp);

  insert into eqm_fider_h (code_eqp,id_department,id_voltage,losts_coef,id_position,l04_count,l04_length,l04f1_length,l04f3_length,Fgcp,balans_only,id_station,dt_b)
  select eqd.*, change.date_change  from eqm_fider_tbl as eqd where code_eqp = NEW.code_eqp;


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = change.date_change where id = old.code_eqp;

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edfider_trg 
after  update 
ON eqm_fider_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edfider_fun();

-----------///////////////////////////////---------------------

-- изменение 
  DROP FUNCTION eqc_edstation_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_edstation_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;  
  vbill record;
  vmmgg date;
  dtstr varchar;
begin                

    if coalesce(old.id_voltage,0)=coalesce(NEW.id_voltage,0) and 
       coalesce(old.power,0)=coalesce(NEW.power,0) and 
       coalesce(old.comp_cnt,0)=coalesce(NEW.comp_cnt,0) and 
       coalesce(old.id_type1,0)=coalesce(NEW.id_type1,0) and
       coalesce(old.id_type2,0)=coalesce(NEW.id_type2,0) and
       coalesce(old.id_type3,0)=coalesce(NEW.id_type3,0) and
       coalesce(old.id_type4,0)=coalesce(NEW.id_type4,0) and
       coalesce(old.p_regday,0)=coalesce(NEW.p_regday,0) and
       coalesce(old.date_regday,now()::date)=coalesce(NEW.date_regday,now()::date) and 
       coalesce(old.abon_ps,0)=coalesce(NEW.abon_ps,0) 
    then
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

--       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
--       '' and dt_e is null;'';


--       insert into eqm_compens_station_h (code_eqp,id_department,id_voltage,abon_ps,power, comp_cnt, id_type1, id_type2, id_type3, id_type4,p_regday,date_regday,dt_b)
--       select eqd.code_eqp,eqd.id_department,eqd.id_voltage,eqd.abon_ps,eqd.power, eqd.comp_cnt, eqd.id_type1, eqd.id_type2, eqd.id_type3, eqd.id_type4, eqd.p_regday, eqd.date_regday, eq.dt_install  
--       from eqm_compens_station_tbl as eqd 
--       join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp)
--       where code_eqp = NEW.code_eqp;

       UPDATE eqm_compens_station_h
       SET  id_voltage=NEW.id_voltage, abon_ps=NEW.abon_ps, power=NEW.power, comp_cnt=NEW.comp_cnt, 
       id_type1=NEW.id_type1, id_type2=NEW.id_type2, id_type3=NEW.id_type3, id_type4=NEW.id_type4, p_regday=NEW.p_regday, date_regday=NEW.date_regday
       where code_eqp = NEW.code_eqp and dt_e is null;

--       EXECUTE ''insert into ''|| v_h_tablename ||
--       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

--    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
--    '' and dt_e is null;'';

--    EXECUTE ''insert into ''|| v_h_tablename ||
--    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
--    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
--    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

--    insert into eqm_compens_station_h (code_eqp,id_department,id_voltage,abon_ps,power, comp_cnt, id_type1, id_type2, id_type3, id_type4,p_regday,date_regday,dt_b)
--    select eqd.code_eqp,eqd.id_department,eqd.id_voltage,eqd.abon_ps,eqd.power, eqd.comp_cnt, eqd.id_type1, eqd.id_type2, eqd.id_type3, eqd.id_type4, eqd.p_regday, eqd.date_regday,eq.dt_install  
--    from eqm_compens_station_tbl as eqd 
--    join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp)
--    where code_eqp = NEW.code_eqp;

       UPDATE eqm_compens_station_h
       SET  id_voltage=NEW.id_voltage, abon_ps=NEW.abon_ps, power=NEW.power, comp_cnt=NEW.comp_cnt, 
       id_type1=NEW.id_type1, id_type2=NEW.id_type2, id_type3=NEW.id_type3, id_type4=NEW.id_type4, p_regday=NEW.p_regday, date_regday=NEW.date_regday
       where code_eqp = NEW.code_eqp and dt_e is null;


    RETURN NEW;
  end if;



  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(change.date_change);

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(change.date_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(change.date_change)||'' and ''||quote_literal(change.date_change)||
  ''<= coalesce (dt_e,''||quote_literal(change.date_change)||'')'';


  insert into eqm_compens_station_h (code_eqp,id_department,id_voltage,abon_ps,power, comp_cnt, id_type1, id_type2, id_type3, id_type4,p_regday,date_regday,dt_b)
  select eqd.code_eqp,eqd.id_department,eqd.id_voltage,eqd.abon_ps,eqd.power, eqd.comp_cnt, eqd.id_type1, eqd.id_type2, eqd.id_type3, eqd.id_type4, eqd.p_regday,eqd.date_regday, change.date_change  
  from eqm_compens_station_tbl as eqd 
  where code_eqp = NEW.code_eqp;


--  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(change.date_change)||
--  '' from ''||TG_RELNAME::varchar||
--  '' where code_eqp = ''||quote_literal(NEW.code_eqp);


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = change.date_change where id = old.code_eqp;

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edstation_trg 
after  update 
ON eqm_compens_station_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edstation_fun();
  


----------------------------------------------------------------------------------------------------------
  DROP FUNCTION eqc_edborder_fun ();                                                   
                                                                                                  
  CREATE FUNCTION eqc_edborder_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  vbill record;
  vmmgg date;
  dtstr varchar;
  begin                


 Raise Notice ''  - ++'';  

  if (coalesce(old.id_clienta,0)=coalesce(new.id_clienta,0)) and 
     (coalesce(old.id_clientb,0)=coalesce(new.id_clientb,0)) and
     (coalesce(old.inf,'''')    =coalesce(NEW.inf,'''')) then 
     if    (coalesce(old.id_doc,0)!=coalesce(new.id_doc,0))  then
         update eqm_borders_h set id_doc = old.id_doc where code_eqp = old.code_eqp and dt_e is null;
     end if;
    return NEW;
  end if;

--  Raise Notice ''  - -++'';  
  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

       EXECUTE ''insert into ''|| v_h_tablename ||
       '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
       '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
       '' where code_eqp = ''||quote_literal(NEW.code_eqp);

       RETURN NEW;
    end if;
  end loop;
--  Raise Notice ''  - - -++'';  
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation limit 1;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    EXECUTE ''insert into ''|| v_h_tablename ||
    '' select eqd.*, eq.dt_install  from ''||TG_RELNAME::varchar||
    '' as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) ''||
    '' where code_eqp = ''||quote_literal(NEW.code_eqp);

    RETURN NEW;
  end if;

  --------------------------------------------------------------------------
  vmmgg:=fun_mmgg();   --текущий mmgg

  select into vbill * from acm_bill_tbl where (id_client = old.id_clienta or id_client = old.id_clientb) and id_pref in (10,20) and 
   mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

  if found then 
   if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then 
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
      Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
   end if; 

  end if ;


--  Raise Notice ''  - - - - ++'';  
  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(change.date_change);

--  delete from eqm_switch_h where code_eqp = OLD.code_eqp and dt_b = change.date_change;

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(change.date_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(change.date_change)||'' and ''||quote_literal(change.date_change)||
  ''<= coalesce (dt_e,''||quote_literal(change.date_change)||'')'';


  EXECUTE ''insert into ''|| v_h_tablename ||'' select *, ''||quote_literal(change.date_change)||
  '' from ''||TG_RELNAME::varchar||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp);


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,change.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_operation=operation;
--  end if;

  
  update eqm_equipment_tbl set Dt_change = change.date_change where id = old.code_eqp;

--  end loop; --цикл по обонентам
  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edborder_trg 
after  update 
ON eqm_borders_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edborder_fun();

-------------------------------------------------------------------------

--  DROP FUNCTION eqc_edground_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_edground_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;
  treeid  integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;  
  vbill record;
  vmmgg date;
  dtstr varchar;
begin                

    if coalesce(old.power,0)=coalesce(NEW.power,0) and 
       coalesce(old.wtm,0)=coalesce(NEW.wtm,0) 
    then
    return NEW;
  end if;

  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
       '' and dt_e is null;'';

 
       insert into eqm_ground_h (code_eqp,id_department,power,wtm,dt_b)
       select eqd.*, eq.dt_install  from eqm_ground_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) 
       where code_eqp = NEW.code_eqp;

       RETURN NEW;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  
  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

    EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(OLD.code_eqp)||
    '' and dt_e is null;'';

    insert into eqm_ground_h (code_eqp,id_department,power,wtm,dt_b)
    select eqd.*, eq.dt_install  from eqm_ground_tbl as eqd join eqm_equipment_tbl as eq on (eq.id= eqd.code_eqp) 
    where code_eqp = NEW.code_eqp;

    RETURN NEW;
  end if;



  EXECUTE ''delete from ''|| v_h_tablename ||'' where code_eqp = ''||quote_literal(NEW.code_eqp)||
  '' and dt_b >=''||quote_literal(change.date_change);

  EXECUTE ''update ''|| v_h_tablename ||'' set dt_e = ''||quote_literal(change.date_change)||
  '' where code_eqp = ''||quote_literal(NEW.code_eqp)||'' and dt_b <= ''||quote_literal(change.date_change)||'' and ''||quote_literal(change.date_change)||
  ''<= coalesce (dt_e,''||quote_literal(change.date_change)||'')'';


  insert into eqm_ground_h (code_eqp,id_department,power,wtm,dt_b)
  select eqd.*, change.date_change  from eqm_ground_tbl as eqd 
  where code_eqp = NEW.code_eqp;

  update eqm_equipment_tbl set Dt_change = change.date_change where id = old.code_eqp;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edground_trg 
after  update 
ON eqm_ground_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edground_fun();
  


----------------------------------------------------------------------------------------------------------
