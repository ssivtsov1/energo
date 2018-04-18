-----------///////////////////////////////---------------------
DROP TRIGGER eqc_deltreenode_trg ON eqm_eqp_tree_tbl;
DROP TRIGGER eqc_edtreenode_trg ON eqm_eqp_tree_tbl;
DROP TRIGGER eqc_newtreenode_trg ON eqm_eqp_tree_tbl;

-- удаление узла  дерева
  DROP FUNCTION eqc_deltreenode_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqc_deltreenode_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;

  old_oid oid;
--  old_id  integer;

  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  vmmgg date;
  vbill record;

  begin                

--  Raise Notice '' eqm_eqp_tree_tbl delete start'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 
       delete from eqm_eqp_tree_h 
       where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
       and dt_e is null;

       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);

  -- получить клиента 
--  select into client id_client from eqm_tree_tbl where id = old.id_tree; 


  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  -- протокол отключен
  vmmgg:=fun_mmgg();   --текущий mmgg

  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;

   if change.enabled=0 then
     delete from eqm_eqp_tree_h 
     where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
     and dt_e is null;

     RETURN OLD;
   end if;


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
       Raise EXCEPTION ''ф┴╘┴ ╔┌═┼╬┼╬╔╤ ═┼╬╪█┼ ─┴╘┘ ╨╧╙╠┼─╬┼╟╧ ╙▐┼╘┴! '';
    end if; 

   end if; 
   vdate_change:= change.date_change;
  end loop; --цикл временной таблице


  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--   insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--   values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--   update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

--  Raise Notice '' eqm_eqp_tree_tbl delete ok'';

  delete from eqm_eqp_tree_h 
  where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
  and dt_e is null and dt_b = vdate_change ;

  update eqm_eqp_tree_h set dt_e = vdate_change 
  where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
  and dt_e is null;


  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_deltreenode_trg 
before  DELETE 
ON eqm_eqp_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deltreenode_fun();

----------------------------------------------------------------------------
-- изменение узла  дерева
  DROP FUNCTION eqc_edtreenode_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqc_edtreenode_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  old_oid oid;
  ischange boolean;
  ready  integer;

  tableid integer;
  oldval  varchar;
  operation integer;
  flag record;
  vbill record;
  vmmgg date;

  begin                

  if (coalesce(old.code_eqp_e,0)=coalesce(new.code_eqp_e,0)) and (old.id_tree=new.id_tree) 
     and (coalesce(old.tranzit,0)=coalesce(new.tranzit,0)) 
     and (old.lvl=new.lvl) and (old.parents=new.parents) then 

     if coalesce(old.name,'''')<>coalesce(new.name,'''') then
	update eqm_eqp_tree_h set name  = new.name where code_eqp = OLD.code_eqp and dt_e is null;
     end if;


    return new;
  end if;


  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from eqm_eqp_tree_h 
       where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
       and dt_e is null;

       insert into eqm_eqp_tree_h
       select tt.*, eq.dt_install  from  eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (eq.id= tt.code_eqp)
       where id_tree = NEW.id_tree and code_eqp = NEW.code_eqp and line_no=NEW.line_no ;

       RETURN NEW;
    end if;
  end loop;


  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   
  -- получить клиента 
--  select into client id_client from eqm_tree_tbl where id = old.id_tree; 

--  Raise Notice '' id_client % '',client.id_client;
  -- получим oid удаляемой записи
  --  end loop перенесли в конец, т.к. oldrec доступен только в цикле;
  
  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  -- протокол отключен
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;

   if change.enabled=0 then

     delete from eqm_eqp_tree_h 
     where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
     and dt_e is null;

     insert into eqm_eqp_tree_h
     select tt.*, eq.dt_install  from  eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (eq.id= tt.code_eqp)
     where id_tree = NEW.id_tree and code_eqp = NEW.code_eqp and line_no=NEW.line_no ;

     RETURN NEW;
   end if;


   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
       Raise EXCEPTION ''ф┴╘┴ ╔┌═┼╬┼╬╔╤ ═┼╬╪█┼ ─┴╘┘ ╨╧╙╠┼─╬┼╟╧ ╙▐┼╘┴! '';
    end if; 

   end if; 
   vdate_change:= change.date_change;
  end loop; --цикл временной таблице


--  if (change.processing=0) then
--   insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--   values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--   update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  --------------------------------------------------------


  delete from eqm_eqp_tree_h 
  where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
  and dt_b >= vdate_change;

  update eqm_eqp_tree_h set dt_e = vdate_change 
  where id_tree = OLD.id_tree and code_eqp = OLD.code_eqp and line_no=old.line_no 
  and dt_b <= vdate_change and vdate_change <= coalesce (dt_e,vdate_change);

  insert into eqm_eqp_tree_h
  select *, vdate_change from  eqm_eqp_tree_tbl 
  where id_tree = NEW.id_tree and code_eqp = NEW.code_eqp and line_no=NEW.line_no ;

  RETURN new;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edtreenode_trg 
--before  UPDATE 
after  UPDATE 
ON eqm_eqp_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edtreenode_fun();


-----------///////////////////////////////---------------------
-- создание 
                                                                                                  
  CREATE or replace FUNCTION eqc_newtreenode_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  begin
  -- при вставке новой строки она должна продублироваться в таблице замены 
  -- независимо от редима

  --╒─┴╠┼╬╔┼ ╙╥┴┬╧╘┴┼╘ ╘╧╠╪╦╧ ╫ ╙╠╒▐┴┼ ╔┌═┼╬┼╬╔╤ ▐┼╥┼┌ ╘╥╔╟╟┼╥ ╦ eqm_privmeter_tbl
  delete from eqm_eqp_tree_h
  where id_tree = NEW.id_tree and code_eqp = NEW.code_eqp and line_no=NEW.line_no 
  and dt_b = (select eq.dt_install  from  eqm_equipment_tbl as eq where eq.id= NEW.code_eqp);


  insert into eqm_eqp_tree_h
  select tt.*, eq.dt_install  from  eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (eq.id= tt.code_eqp)
  where id_tree = NEW.id_tree and code_eqp = NEW.code_eqp and line_no=NEW.line_no ;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqc_newtreenode_trg 
after insert 
ON eqm_eqp_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newtreenode_fun();
