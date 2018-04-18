-----------///////////////////////////////---------------------
-- удаление запиcи о принадлежноcти оборудования подcтанции
-- 
DROP TRIGGER "eqА_delstation_inst_trg"  
  ON eqm_compens_station_inst_tbl;

DROP TRIGGER eqс_delstation_inst_trg ON eqm_compens_station_inst_tbl;
  DROP TRIGGER eqc_newstation_inst_trg ON eqm_compens_station_inst_tbl;


  DROP FUNCTION eqc_delstation_inst_fun ();                                                   
                                                                                                  
  CREATE  or replace FUNCTION eqc_delstation_inst_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  oldrec record;
  treeid integer;

  old_oid oid;
  old_id  integer;

  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  v_h_tablename varchar;
  begin                

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from eqm_compens_station_inst_h where code_eqp_inst = old.code_eqp_inst 
       and code_eqp = old.code_eqp  and dt_e is null;

       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation limit 1;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

    delete from eqm_compens_station_inst_h where code_eqp_inst = old.code_eqp_inst 
    and code_eqp = old.code_eqp  and dt_e is null;

    RETURN OLD;
  end if;



  delete from eqm_compens_station_inst_h  
  where code_eqp_inst = old.code_eqp_inst 
  and code_eqp = old.code_eqp and dt_e is null and dt_b = change.date_change ;

  update eqm_compens_station_inst_h set dt_e = change.date_change 
  where code_eqp_inst = old.code_eqp_inst 
  and code_eqp = old.code_eqp and dt_e is null;



  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_delstation_inst_trg 
before  DELETE 
ON eqm_compens_station_inst_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_delstation_inst_fun();


-----------///////////////////////////////---------------------
-- cоздание 
  drop FUNCTION eqc_newstation_inst_fun();
                                           
  CREATE or replace FUNCTION eqc_newstation_inst_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
    change record;
    flag record;
    operation integer;
  begin

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

      delete from eqm_compens_station_inst_h where code_eqp = NEW.code_eqp 
       and code_eqp_inst = NEW.code_eqp_inst and dt_b = (select dt_install from eqm_equipment_tbl where id = NEW.code_eqp);

      insert into eqm_compens_station_inst_h 
      select csi.*, eq.dt_install  from eqm_compens_station_inst_tbl as csi join eqm_equipment_tbl as eq on (eq.id= csi.code_eqp)
      where  code_eqp = NEW.code_eqp and code_eqp_inst = NEW.code_eqp_inst;

      RETURN NEW;
    end if;
  end loop;


  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation limit 1;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

      delete from eqm_compens_station_inst_h where code_eqp = NEW.code_eqp 
       and code_eqp_inst = NEW.code_eqp_inst and dt_b = (select dt_install from eqm_equipment_tbl where id = NEW.code_eqp);

      insert into eqm_compens_station_inst_h 
      select csi.*, eq.dt_install  from eqm_compens_station_inst_tbl as csi join eqm_equipment_tbl as eq on (eq.id= csi.code_eqp)
      where  code_eqp = NEW.code_eqp and code_eqp_inst = NEW.code_eqp_inst;

    RETURN NEW;
  end if;

  insert into eqm_compens_station_inst_h 
  select csi.*, change.date_change  from eqm_compens_station_inst_tbl as csi 
  where  code_eqp = NEW.code_eqp and code_eqp_inst = NEW.code_eqp_inst;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_newstation_inst_trg 
after insert 
ON eqm_compens_station_inst_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newstation_inst_fun();


