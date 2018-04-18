-----------///////////////////////////////---------------------
DROP TRIGGER eqc_deltree_trg ON eqm_tree_tbl;
DROP TRIGGER eqc_edtree_trg ON eqm_tree_tbl;
DROP TRIGGER eqc_newtree_trg ON eqm_tree_tbl;

-- удаление дерева
  DROP FUNCTION eqc_deltree_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqc_deltree_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--  client record;
  field  record;
  change record;
  oldrec record;

  old_oid oid;
  old_id  integer;

  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  begin                

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 
       delete from eqm_tree_h where id = OLD.id and dt_e is null;
       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  -- получим oid удаляемой записи
  old_id:=old.id;

  -- получить текущую операцию
  select into change * from eqt_change_tbl where  id_operation=operation;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
  -- протокол отключен
  if change.enabled=0 then
    delete from eqm_tree_h where id = OLD.id and dt_e is null;
    RETURN OLD;
  end if;

  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then

--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,old.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_client = old.id_client and id_operation=operation;
--  end if;

  delete from eqm_tree_h where id = OLD.id and dt_e is null and dt_b = change.date_change;

  update eqm_tree_h set dt_e = change.date_change where id = OLD.id and dt_e is null;

  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_deltree_trg 
before  DELETE 
ON eqm_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deltree_fun();

----------------------------------------------------------------------------
-- изменение дерева
  DROP FUNCTION eqc_edtree_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqc_edtree_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--  client record;
  field  record;
  change record;
  oldrec record;
  ischange boolean;
  old_oid oid;
  old_id  integer;

  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  begin                



  if (coalesce(old.code_eqp,0)=coalesce(new.code_eqp,0)) and (coalesce(old.tranzit,0)=coalesce(new.tranzit,0)) then 

    if coalesce(old.name,'''')<>coalesce(new.name,'''') then
	update eqm_tree_h set name  = new.name where id = OLD.id and dt_e is null;
    end if;

    return NEW;
  end if;

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 
       delete from eqm_tree_h where id = OLD.id and dt_e is null;

       insert into eqm_tree_h
       select *, ''1900-01-01'' from eqm_tree_tbl where id = OLD.id;

       RETURN NEW;
    end if;
  end loop;


  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  -- получим oid удаляемой записи
  old_id:=old.id;


  
  -- получить текущую операцию
  select into change * from eqt_change_tbl where  id_operation=operation;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;

  -- протокол отключен
  if change.enabled=0 then

    delete from eqm_tree_h where id = OLD.id and dt_e is null;

    insert into eqm_tree_h
    select *, ''1900-01-01'' from eqm_tree_tbl where id = OLD.id;

    RETURN NEW;
  end if;

--  if (change.processing=0) then
--   insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--   values (change.id_change,change.mode,old.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--   update eqt_change_tbl set processing=1 where id_client = old.id_client and id_operation=operation;
--  end if;
 
--  delete from eqm_tree_h where id = OLD.id and ((dt_b >= change.date_change) or (dt_b =''1900-01-01''::date)) ;
  delete from eqm_tree_h where id = OLD.id and (dt_b >= change.date_change)  ;

  update eqm_tree_h set dt_e = change.date_change where id = OLD.id and 
   dt_b <= change.date_change and change.date_change <= coalesce (dt_e,change.date_change);

  insert into eqm_tree_h
  select *, change.date_change from eqm_tree_tbl where id = NEW.id;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edtree_trg 
after  UPDATE 
ON eqm_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edtree_fun();
--------------------------------------------------------------------------
-- создание 
                                                                                                  
  CREATE or replace FUNCTION eqc_newtree_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  begin
  -- при вставке новой строки она должна продублироваться в таблице замены 
  -- независимо от редима
  insert into eqm_tree_h
  select *,''1900-01-01''  from eqm_tree_tbl where id = NEW.id;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqc_newtree_trg 
after insert 
ON eqm_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newtree_fun();
