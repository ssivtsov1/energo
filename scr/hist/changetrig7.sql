  drop TRIGGER eqc_deleqpuse_trg  on eqm_eqp_use_tbl;

--  DROP FUNCTION eqc_deleqpuse_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_deleqpuse_fun ()
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
  treeid integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  vmmgg date;
  vbill record;
  dtstr varchar;
  begin                

--  Raise Notice ''Delete zone trigger'';
  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from  eqm_eqp_use_h  
       where code_eqp = old.code_eqp 
       and id_client = old.id_client and dt_install = old.dt_install and dt_e is null;

       RETURN OLD;
    end if;
  end loop;
  
--  for client in  select id_client from eqm_tree_tbl where code_eqp= old.id group by id_client loop
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  -- получим oid удаляемой записи
  -- old_id:=old.id;
  vmmgg:=fun_mmgg();   --текущий mmgg
  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation limit 1;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then

    delete from  eqm_eqp_use_h  
    where code_eqp = old.code_eqp 
    and id_client = old.id_client and dt_install = old.dt_install and dt_e is null;

    RETURN OLD;
  end if;

  if change.date_change < old.dt_install then
      Raise EXCEPTION ''Дата удаления меньше даты установки! '';
  end if;

  select into vbill * from acm_bill_tbl where id_client = old.id_client and id_pref in (10,20) and 
   mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

  if found then 
     if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата удаления меньше даты последнего счета % ! '',dtstr;
     end if; 
  end if ;
  
  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--   insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--   values (change.id_change,change.mode,old.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);
--   values (change.id_change,change.mode,change.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);
--   update eqt_change_tbl set processing=1 where id_operation=operation;
--  end if;

  delete from eqm_eqp_use_h 
  where code_eqp = old.code_eqp and dt_b = change.date_change 
  and id_client = old.id_client and dt_install = old.dt_install and dt_e is null;

  update eqm_eqp_use_h set dt_e = change.date_change 
  where code_eqp = old.code_eqp 
  and id_client = old.id_client and dt_install = old.dt_install and dt_e is null;

  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_deleqpuse_trg 
before  DELETE 
ON eqm_eqp_use_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqpuse_fun();


-------------------------------------------------------------------------
  CREATE  or replace FUNCTION eqc_neweqpuse_fun ()                                           
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--   v_h_tablename varchar;
  begin
--  Raise Notice ''  - _ -++'';  

  delete from eqm_eqp_use_h where code_eqp= new.code_eqp and  id_client= new.id_client and dt_b=new.dt_install;

  insert into eqm_eqp_use_h (code_eqp,dt_install,id_client,dt_b) values
  (new.code_eqp,new.dt_install,new.id_client,new.dt_install);


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_neweqpuse_trg 
after insert 
ON eqm_eqp_use_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqpuse_fun();


-------------------------------------------------------------------------------------
--===============================================================================----
-------------------------------------------------------------------------------------


 CREATE  or replace FUNCTION eqc_newarea_fun ()                                           
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  begin

  delete from eqm_area_h where code_eqp= new.code_eqp and  id_client= new.id_client ;

  insert into eqm_area_h (code_eqp,id_client,dt_b) 
  select new.code_eqp, new.id_client, eq.dt_install from eqm_equipment_tbl as eq where id = NEW.code_eqp;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_newarea_trg 
after insert 
ON eqm_area_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newarea_fun();



--------------------------------------------------------------------------------------------------                                                                                                 
  CREATE or replace FUNCTION eqc_delarea_fun()
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
  treeid integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  begin                

--  Raise Notice ''Delete zone trigger'';
  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from eqm_area_h  
       where code_eqp = old.code_eqp 
       and id_client = old.id_client and dt_e is null;

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

    delete from eqm_area_h  
    where code_eqp = old.code_eqp 
    and id_client = old.id_client and dt_e is null;

    RETURN OLD;
  end if;

/*
  if change.date_change < old.dt_install then
      Raise EXCEPTION ''Дата удаления меньше даты установки! '';
  end if;
*/  
  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--   insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--   values (change.id_change,change.mode,change.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--   update eqt_change_tbl set processing=1 where id_operation=operation;
--  end if;

  delete from eqm_area_h 
  where code_eqp = old.code_eqp and dt_b = change.date_change 
  and id_client = old.id_client and dt_e is null;

  update eqm_area_h set dt_e = change.date_change 
  where code_eqp = old.code_eqp 
  and id_client = old.id_client and dt_e is null;


  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_delarea_trg 
before  DELETE 
ON eqm_area_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_delarea_fun();
