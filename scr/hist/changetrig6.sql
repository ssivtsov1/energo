-----------///////////////////////////////---------------------
-- удаление зоны счетчика
  DROP TRIGGER eqc_delmeterzone_trg ON eqd_meter_zone_tbl;
  DROP TRIGGER eqc_delmeterenergy_trg ON eqd_meter_energy_tbl;
  drop TRIGGER eqc_delpointenergy_trg  on eqd_point_energy_tbl;

--  DROP FUNCTION eqc_delmeterzone_fun ();                                                   
                                                                                                  
  CREATE  or replace FUNCTION eqc_delmeterzone_fun ()
  RETURNS trigger
  AS                                                                                              
  '
  declare
  client record;
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
  flag record;
  vmmgg date;
  vbill record;
  dtstr varchar;
  begin                

--  Raise Notice ''Delete zone trigger'';
  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from eqd_meter_zone_h 
       where code_eqp = old.code_eqp 
       and kind_energy = old.kind_energy and zone = old.zone and dt_zone_install = old.dt_zone_install and dt_e is null;

       RETURN OLD;
    end if;
  end loop;
  
--  for client in  select id_client from eqm_tree_tbl where code_eqp= old.id group by id_client loop
  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg
  -- получим oid удаляемой записи
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
   if change.enabled=0 then

     delete from eqd_meter_zone_h 
     where code_eqp = old.code_eqp 
     and kind_energy = old.kind_energy and zone = old.zone and dt_zone_install = old.dt_zone_install and dt_e is null;

     RETURN OLD;
   end if;

   if change.date_change < old.dt_zone_install then
       Raise EXCEPTION ''Дата удаления меньше даты установки! '';
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

  end loop;

  
  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--  insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--  values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--  update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  delete from eqd_meter_zone_h  
  where code_eqp = old.code_eqp and dt_b = vdate_change 
  and kind_energy = old.kind_energy and zone = old.zone and dt_zone_install = old.dt_zone_install and dt_e is null;

  update eqd_meter_zone_h set dt_e = vdate_change 
  where code_eqp = old.code_eqp 
  and kind_energy = old.kind_energy and zone = old.zone and dt_zone_install = old.dt_zone_install and dt_e is null;

--  end loop; --цикл по обонентам
--  end loop; --выбор old
  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_delmeterzone_trg 
before  DELETE 
ON eqd_meter_zone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_delmeterzone_fun();

-----------///////////////////////////////---------------------
-- удаление измеряемой энергии счетчика
-- (изменение не предусмотрено)
--  DROP FUNCTION eqc_delmeterenergy_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_delmeterenergy_fun ()
  RETURNS trigger
  AS                                                                                              
  '
  declare
  client record;
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
  flag record;
  vmmgg date;
  vbill record;
  dtstr varchar;
  begin                

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from  eqd_meter_energy_h  
       where code_eqp = old.code_eqp 
       and kind_energy = old.kind_energy and date_inst = old.date_inst and dt_e is null;

       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
  vmmgg:=fun_mmgg();   --текущий mmgg
  -- получим oid удаляемой записи
  -- old_id:=old.id;
/*
  for oldrec in EXECUTE ''select oid,* from ''|| TG_RELNAME ||'' where code_eqp = ''||quote_literal(old.code_eqp)||
  '' and kind_energy=''||quote_literal(old.kind_energy)||'' and date_inst=''|| quote_literal(old.date_inst) loop

  old_oid:=oldrec.oid;
  --  end loop перенесли в конец, т.к. oldrec доступен только в цикле;
*/  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
--  select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

   update eqm_changelog_tbl set processing = 1 where id_change = change.id_change; 
   -- протокол отключен
   if change.enabled=0 then

     delete from  eqd_meter_energy_h  
     where code_eqp = old.code_eqp 
     and kind_energy = old.kind_energy and date_inst = old.date_inst and dt_e is null;

     RETURN OLD;
   end if;

   if change.date_change < old.date_inst then
       Raise EXCEPTION ''Дата удаления меньше даты установки! '';
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

  end loop;
 
--  if (change.processing=0) then
--  insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--  values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--  update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  delete from eqd_meter_energy_h  
  where code_eqp = old.code_eqp and dt_b = vdate_change 
  and kind_energy = old.kind_energy and date_inst = old.date_inst and dt_e is null;

  update eqd_meter_energy_h set dt_e = vdate_change 
  where code_eqp = old.code_eqp 
  and kind_energy = old.kind_energy and date_inst = old.date_inst and dt_e is null;

--  end loop; --цикл по обонентам
--  end loop; --выбор old
  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_delmeterenergy_trg 
before  DELETE 
ON eqd_meter_energy_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_delmeterenergy_fun();

-----------///////////////////////////////---------------------
-- удаление измеряемой энергии в точке учета
-- (изменение не предусмотрено)
--  DROP FUNCTION eqc_delpointenergy_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_delpointenergy_fun ()
  RETURNS trigger
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

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from  eqd_point_energy_h 
       where code_eqp = old.code_eqp 
       and kind_energy = old.kind_energy and dt_instal = old.dt_instal and dt_e is null;

       RETURN OLD;
    end if;
  end loop;

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
-- vmmgg:=fun_mmgg();   --текущий mmgg
  -- получим oid удаляемой записи
  -- old_id:=old.id;
/*
  for oldrec in EXECUTE ''select oid,* from ''|| TG_RELNAME ||'' where code_eqp = ''||quote_literal(old.code_eqp)||
  '' and kind_energy=''||quote_literal(old.kind_energy)||'' and dt_instal=''|| quote_literal(old.dt_instal) loop

  old_oid:=oldrec.oid;
*/
  --  end loop перенесли в конец, т.к. oldrec доступен только в цикле;
  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

  -- получить текущую операцию
  select into change * from eqt_change_tbl where id_operation=operation;

  update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
   -- протокол отключен
  if change.enabled=0 then

     delete from  eqd_point_energy_h 
     where code_eqp = old.code_eqp 
     and kind_energy = old.kind_energy and dt_instal = old.dt_instal and dt_e is null;

     RETURN OLD;
  end if;

  if change.date_change < old.dt_instal then
       Raise EXCEPTION ''Дата удаления меньше даты установки! '';
  end if;

 
/*
  select into vbill * from acm_bill_tbl where id_client = change.id_client and 
   mmgg_bill <> vmmgg and mmgg_bill is not null order by mmgg_bill desc limit 1;

  if found then 
    if (vbill.dat_e is not null ) and (vbill.dat_e > change.date_change) then
      Raise EXCEPTION ''Дата удаления меньше даты последнего счета! '';
    end if; 
  end if ;
*/
  -- если не была создана запись в eqm_change_tbl, создадим
--  if (change.processing=0) then
--  insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--  values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);

--  update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--  end if;

  delete from eqd_point_energy_h 
  where code_eqp = old.code_eqp and dt_b = change.date_change 
  and kind_energy = old.kind_energy and dt_instal = old.dt_instal and dt_e is null;

  update eqd_point_energy_h set dt_e = change.date_change 
  where code_eqp = old.code_eqp 
  and kind_energy = old.kind_energy and dt_instal = old.dt_instal and dt_e is null;

--  end loop; --цикл по обонентам
--  end loop; --выбор old
  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqc_delpointenergy_trg 
before  DELETE 
ON eqd_point_energy_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_delpointenergy_fun();


-----------///////////////////////////////---------------------
-- создание 

  CREATE  or replace FUNCTION eqc_newmeterzone_fun ()                                           
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--   v_h_tablename varchar;
  vdt_inst date;
  begin

  select into vdt_inst dt_install from eqm_equipment_tbl where id = new.code_eqp;

--  Raise Notice '' new.dt_zone_install % '',new.dt_zone_install;  
--  Raise Notice '' vdt_inst % '',vdt_inst;  

  if new.dt_zone_install < vdt_inst then
      Raise EXCEPTION ''Дата меньше даты установки оборудования! '';
  end if;


  delete from eqd_meter_zone_h where code_eqp =new.code_eqp and kind_energy = new.kind_energy 
  and zone = new.zone and dt_b = new.dt_zone_install;

  insert into eqd_meter_zone_h (code_eqp,dt_zone_install,kind_energy,zone,dt_b) values
  (new.code_eqp,new.dt_zone_install,new.kind_energy,new.zone,new.dt_zone_install);


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_newmeterzone_trg 
after insert 
ON eqd_meter_zone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newmeterzone_fun();

-------------------------------------------------------------------------
  CREATE  or replace FUNCTION eqc_newmeterenergy_fun ()                                           
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  vdt_inst date;
--   v_h_tablename varchar;
  begin
--  Raise Notice ''  - _ -++'';  

  select into vdt_inst dt_install from eqm_equipment_tbl where id = new.code_eqp;

--  Raise Notice '' new.date_inst % '',new.date_inst;  
--  Raise Notice '' vdt_inst % '',vdt_inst;  


  if new.date_inst < vdt_inst then
      Raise EXCEPTION ''Дата меньше даты установки оборудования! '';
  end if;

  delete from eqd_meter_energy_h where code_eqp =new.code_eqp and  kind_energy = new.kind_energy and dt_b = new.date_inst;

  insert into eqd_meter_energy_h (code_eqp,date_inst,kind_energy,dt_b) values
  (new.code_eqp,new.date_inst,new.kind_energy,new.date_inst);


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_newmeterenergy_trg 
after insert 
ON eqd_meter_energy_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newmeterenergy_fun();

-------------------------------------------------------------------------
  CREATE  or replace FUNCTION eqc_newpointenergy_fun ()                                           
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--   v_h_tablename varchar;
  vdt_inst date;
  begin
--  Raise Notice ''  - _ -++'';  

  select into vdt_inst dt_install from eqm_equipment_tbl where id = new.code_eqp;

--  Raise Notice '' new.dt_instal % '',new.dt_instal;  
--  Raise Notice '' vdt_inst % '',vdt_inst;  

/*
  if new.dt_instal < vdt_inst then
      Raise EXCEPTION ''Дата меньше даты установки оборудования! '';
  end if;
*/

  delete from eqd_point_energy_h where code_eqp =new.code_eqp and kind_energy=new.kind_energy and dt_b=new.dt_instal;

  insert into eqd_point_energy_h (code_eqp,dt_instal,kind_energy,dt_b) values
  (new.code_eqp,new.dt_instal,new.kind_energy,new.dt_instal);


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_newpointenergy_trg 
after insert 
ON eqd_point_energy_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newpointenergy_fun();


---------------------------------------------------------------------------------------------------
--========================================================================================================

DROP TRIGGER eqc_deldifmetzone_trg ON eqd_difmetzone_tbl;
DROP TRIGGER eqc_newdifmetzone_trg ON eqd_difmetzone_tbl;
DROP TRIGGER eqc_eddifmetzone_trg ON eqd_difmetzone_tbl;


CREATE  or replace FUNCTION eqc_newdifmetzone_fun()                                           
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
--   v_h_tablename varchar;
  vdt_inst date;
  begin

  select into vdt_inst dt_install from eqm_equipment_tbl where id = new.code_eqp;

--  Raise Notice '' new.dt_zone_install % '',new.dt_zone_install;  
--  Raise Notice '' vdt_inst % '',vdt_inst;  

  if new.dt_b < vdt_inst then
      Raise EXCEPTION ''Дата меньше даты установки оборудования! '';
  end if;


  delete from eqd_difmetzone_h where code_eqp =new.code_eqp and kind_energy = new.kind_energy 
  and zone = new.zone and zone_p = new.zone_p and dt_b = new.dt_b;

  insert into eqd_difmetzone_h (id,code_eqp,kind_energy,zone,zone_p,percent,dt_b) values
  (new.id,new.code_eqp,new.kind_energy,new.zone,new.zone_p,new.percent,new.dt_b);


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

                                                                                                 
CREATE TRIGGER eqc_newdifmetzone_trg 
after insert 
ON eqd_difmetzone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_newdifmetzone_fun();

-------------------------------------------------------------------------
  CREATE  or replace FUNCTION eqc_deldifmetzone_fun ()
  RETURNS trigger
  AS                                                                                              
  '
  declare
  client record;
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
  flag record;
  vmmgg date;
  vbill record;
  dtstr varchar;
  begin                

--  Raise Notice ''Delete zone trigger'';
  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from eqd_difmetzone_h 
       where code_eqp = old.code_eqp 
       and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p and dt_b = old.dt_b and dt_e is null;

       RETURN OLD;
    end if;
  end loop;
  

  -- получить код текущей операции
  select into operation currval(''"eqm_change_oper_seq"''::text);
    vmmgg:=fun_mmgg();   --текущий mmgg  
-- получить текущего обонента(обонентов может быть >1 при удалении граници)
--  for client in select t.id_client  from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt where 
--    tt.code_eqp= old.code_eqp and t.id=tt.id_tree group by id_client loop

    -- получить текущую операцию
--    select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

    update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;

    -- протокол отключен
    if change.enabled=0 then
  
      delete from eqd_difmetzone_h 
      where code_eqp = old.code_eqp 
      and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p and dt_b = old.dt_b and dt_e is null;
  
      RETURN OLD;
    end if;
  
    if change.date_change < old.dt_b then
        Raise EXCEPTION ''Дата удаления меньше даты установки! '';
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

  end loop;
    
    -- если не была создана запись в eqm_change_tbl, создадим
--    if (change.processing=0) then
--    insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--    values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);
  
--    update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--    end if;
  
    delete from eqd_difmetzone_h 
    where code_eqp = old.code_eqp and dt_b = vdate_change 
    and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p and dt_b = old.dt_b and dt_e is null;
  
  
    update eqd_difmetzone_h set dt_e = vdate_change 
    where code_eqp = old.code_eqp 
    and kind_energy = old.kind_energy and zone = old.zone and dt_b = old.dt_b and zone_p = old.zone_p and dt_e is null;

--  end loop; --цикл по обонентам

  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_deldifmetzone_trg 
before  DELETE 
ON eqd_difmetzone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_deldifmetzone_fun();


-----------------------------------------------------------------------------------                                                                                                  
  CREATE or replace FUNCTION eqc_eddifmetzone_fun ()
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

  if (coalesce(old.percent,0)=coalesce(new.percent,0))  
  then 
    return NEW;
  end if;

--  v_h_tablename :=  substr(TG_RELNAME::varchar, 0, strpos(TG_RELNAME::varchar, ''_tbl''))::varchar||''_h'';

  for flag in select to_number(value_ident,''9'') as val from syi_sysvars_tbl where ident=''eqp_log'' loop
    if flag.val=0 then 

       delete from eqd_difmetzone_h 
       where code_eqp = old.code_eqp 
       and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p and dt_b = old.dt_b and dt_e is null;

       insert into eqd_difmetzone_h (id,code_eqp,kind_energy,zone,zone_p,percent,dt_b) values
       (new.id,new.code_eqp,new.kind_energy,new.zone,new.zone_p,new.percent,new.dt_b);

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
--    select into change * from eqt_change_tbl where id_client = client.id_client and id_operation=operation;
  for change in select * from eqt_change_tbl where id_operation=operation loop

    update eqm_changelog_tbl set processing = 1 where id_change = change.id_change;
    -- протокол отключен
    if change.enabled=0 then
  
       delete from eqd_difmetzone_h 
       where code_eqp = old.code_eqp 
       and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p and dt_b = old.dt_b and dt_e is null;
  
       insert into eqd_difmetzone_h (id,code_eqp,kind_energy,zone,zone_p,percent,dt_b) values
       (new.id,new.code_eqp,new.kind_energy,new.zone,new.zone_p,new.percent,new.dt_b);
  
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

  
   delete from eqd_difmetzone_h 
   where code_eqp = old.code_eqp 
   and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p and dt_b >= vdate_change ;
  
   update eqd_difmetzone_h set dt_e = vdate_change
   where code_eqp = old.code_eqp  and kind_energy = old.kind_energy and zone = old.zone and zone_p = old.zone_p 
   and dt_b <= vdate_change and vdate_change <= coalesce (dt_e,vdate_change);
  
   insert into eqd_difmetzone_h (id,code_eqp,kind_energy,zone,zone_p,percent,dt_b) values
   (new.id,new.code_eqp,new.kind_energy,new.zone,new.zone_p,new.percent,vdate_change);
  
  
    -- если не была создана запись в eqm_change_tbl, создадим
--    if (change.processing=0) then
--      insert into eqm_change_tbl (id,mode,id_client,date_change,dt,id_usr)
--      values (change.id_change,change.mode,client.id_client,change.date_change,CURRENT_TIMESTAMP,change.id_usr);
  
--      update eqt_change_tbl set processing=1 where id_client = client.id_client and id_operation=operation;
--    end if;
  
--    new.dt_b = change.date_change;
   update eqd_difmetzone_tbl set dt_b = vdate_change where id = new.id;
  

--  end loop; --цикл по обонентам

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqc_eddifmetzone_trg 
after  update 
ON eqd_difmetzone_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqc_eddifmetzone_fun();
