-----------///////////////////////////////---------------------
DROP TRIGGER eqc_deleqp_trg ON eqm_equipment_tbl;
DROP TRIGGER eqc_edeqp_trg ON eqm_equipment_tbl;
DROP TRIGGER eqc_neweqp_trg ON eqm_equipment_tbl;
---------------------------------------------------------------------
-- удаление экземпляра оборудования
  DROP FUNCTION eqc_deleqp_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqc_deleqp_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;

  old_oid oid;
  old_id  integer;
  treeid integer;
  tableid integer;
  oldval  varchar;
  operation integer;
  is_group integer;
  flag record;
  vmmgg date;
  vbill record;
  dtstr varchar;

  begin                

--  Raise Notice '' eqm_equipment_tbl delete start'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 
       delete from eqm_equipment_h where id = OLD.id and dt_e is null;
       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);

  -- получим oid удаляемой записи
  old_id:=old.id;

  vmmgg:=fun_mmgg();   --текущий mmgg
  vdate_change:= null;
  -- получить текущую операцию
  -- В каждой операции замены может участвовать только одна запись данной таблици
  -- но при изменении граници создается отдельная запись для каждого абонента
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;

   -- протокол отключен
   if change.enabled=0 then
     delete from eqm_equipment_h where id = OLD.id and dt_e is null;
     RETURN OLD;
   end if;

   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
      dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
      Raise EXCEPTION ''Дата удаления меньше даты последнего счета % ! '',dtstr;
    end if; 
   end if ;

   vdate_change:= change.date_change;

  end loop; --цикл по временной таблице

   if vdate_change is null then
      Raise EXCEPTION ''Дата удаления не определена! '';
   end if;

   if vdate_change < old.dt_change then
      Raise EXCEPTION ''Дата удаления меньше даты последнего изменения! '';
   end if;

   if vdate_change < old.dt_install then
      Raise EXCEPTION ''Дата удаления меньше даты установки! '';
   end if;

   -- если не была создана запись в eqm_change_tbl, создадим
--   if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,change.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--    update eqt_change_tbl set processing=1 where id_operation=operation;
--   end if;

   delete from eqm_equipment_h where id = OLD.id and dt_e is null and dt_b =vdate_change;

   update eqm_equipment_h set dt_e = vdate_change where id = OLD.id and dt_e is null;

   update mnm_eqp_params_h set dt_e = vdate_change where code_eqp = OLD.id and dt_e is null;

   if (OLD.type_eqp in (1,12) ) then

      delete from eqm_meter_point_h where ( id_point = OLD.id or id_meter = OLD.id ) and dt_e is null and dt_b =vdate_change;
      update eqm_meter_point_h set dt_e = vdate_change where ( id_point = OLD.id or id_meter = OLD.id ) and dt_e is null;

   end if;

  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_deleqp_trg 
before  DELETE 
ON eqm_equipment_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deleqp_fun();


-----------///////////////////////////////---------------------
-- изменение экземпляра оборудования
  DROP FUNCTION eqc_edeqp_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqc_edeqp_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--  client record;
  field  record;
  change record;
  vdate_change date;
  oldrec record;
  ischange boolean;
  treeid integer;
  old_oid oid;
  old_id  integer;

  tableid integer;
  oldval  varchar;
  operation integer;
  is_group integer;
  flag record;
  vmmgg date;
  vbill record;
  vhist record;
  dtstr varchar;

  begin                


  if (coalesce(old.type_eqp,0)=coalesce(new.type_eqp,0)) and 
     (coalesce(old.num_eqp,'''')=coalesce(new.num_eqp,'''')) and 
     (coalesce(old.name_eqp,'''')=coalesce(new.name_eqp,'''')) and 
     (coalesce(old.id_addres,0)=coalesce(new.id_addres,0)) and
     (coalesce(old.loss_power,0)=coalesce(new.loss_power,0)) and
     (coalesce(old.is_owner,0)=coalesce(new.is_owner,0)) and
     (coalesce(old.dt_install,now()::date)=coalesce(NEW.dt_install,now()::date))  
  then
     RETURN NEW;
  end if;

  -- если поменяли только наименование
  if (coalesce(old.name_eqp,'''')<>coalesce(new.name_eqp,'''')) and 
     (coalesce(old.type_eqp,0)=coalesce(new.type_eqp,0)) and 
     (coalesce(old.num_eqp,'''')=coalesce(new.num_eqp,'''')) and 
     (coalesce(old.id_addres,0)=coalesce(new.id_addres,0)) and
     (coalesce(old.loss_power,0)=coalesce(new.loss_power,0)) and
     (coalesce(old.is_owner,0)=coalesce(new.is_owner,0)) and
     (coalesce(old.dt_install,now()::date)=coalesce(NEW.dt_install,now()::date))  
  then
     
     update eqm_equipment_h set name_eqp = new.name_eqp where id = OLD.id and dt_e is null; 

     RETURN NEW;
  end if;


  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 
       delete from eqm_equipment_h where id = OLD.id and dt_e is null;

       insert into eqm_equipment_h (id, type_eqp, name_eqp, num_eqp, id_addres, dt_install, dt_change,loss_power, id_department, is_owner, dt_b )
       select new.id,new.type_eqp,new.name_eqp,new.num_eqp,new.id_addres,
       new.dt_install,new.dt_change,new.loss_power,new.id_department,new.is_owner,new.dt_install  ;

       RETURN NEW;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  -- получим oid удаляемой записи
  old_id:=old.id;

  vmmgg:=fun_mmgg();   --текущий mmgg


  -- получить текущую операцию
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;

   if change.enabled=0 then
    delete from eqm_equipment_h where id = OLD.id and dt_e is null;

    insert into eqm_equipment_h (id, type_eqp, name_eqp, num_eqp, id_addres, dt_install, dt_change,loss_power, id_department, is_owner, dt_b )
    select new.id,new.type_eqp,new.name_eqp,new.num_eqp,new.id_addres,
    new.dt_install,new.dt_change,new.loss_power,new.id_department,new.is_owner, new.dt_install  ;

    RETURN NEW;
   end if;



   select into vbill * from acm_bill_tbl where id_client = change.id_client and id_pref in (10,20) and 
    mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

   if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
       dtstr:=to_char(vbill.dat_e,''DD.MM.YYYY'');
       Raise EXCEPTION ''Дата изменения меньше даты последнего счета % ! '',dtstr;
    end if; 

   end if; 
   vdate_change:= change.date_change;
  end loop; --цикл временной таблице


  delete from eqm_equipment_h where id = OLD.id and dt_b >= vdate_change;

  update eqm_equipment_h set dt_e = vdate_change where id = OLD.id and 
      dt_b <= vdate_change and vdate_change <= coalesce (dt_e,vdate_change); 


  insert into eqm_equipment_h (id, type_eqp, name_eqp, num_eqp, id_addres, dt_install, dt_change,loss_power, id_department, is_owner, dt_b )
  select new.id,new.type_eqp,new.name_eqp,new.num_eqp,new.id_addres,
  new.dt_install,new.dt_change,new.loss_power,new.id_department, new.is_owner, vdate_change ;

--  if (change.processing=0) then
--   insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--   values (change.id_change,change.mode,change.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--   update eqt_change_tbl set processing=1 where id_operation=operation;
--  end if;

  new.Dt_change:=change.date_change;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_edeqp_trg 
before UPDATE 
ON eqm_equipment_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_edeqp_fun();


-----------///////////////////////////////---------------------
-- создание оборудования
                                                                                                  
  CREATE or replace FUNCTION eqc_neweqp_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  begin
  -- при вставке новой строки она должна продублироваться в таблице замены 
  -- независимо от редима
  insert into eqm_equipment_h (id, type_eqp, name_eqp, num_eqp, id_addres, dt_install, dt_change,loss_power, id_department,is_owner, dt_b )
  select id, type_eqp, name_eqp, num_eqp, id_addres, dt_install, dt_change,loss_power, id_department,is_owner,
  new.dt_install  from eqm_equipment_tbl where id = NEW.id;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqc_neweqp_trg 
after insert 
ON eqm_equipment_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_neweqp_fun();
