  DROP TRIGGER eqm_edprivmeter_trg ON eqm_privmeter_tbl;

  CREATE or replace FUNCTION eqm_edprivmeter_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
    vid_tree int;
    v        int;
    vparent  record;
    vid_old_tree int;
    olduse   int;
    newuse   int;

  begin

  select into vid_tree id_tree from eqm_eqp_tree_tbl
  where code_eqp=NEW.id_eqp;

  --протокол включен (признак 0)
--  v:= eqt_change_fun(0,vid_tree,NEW.dt_change, NEW.id_person, NEW.id_eqp, 1); 
--Дерево не передаем, чтоб нормально отработал случай изменения граници
  if (OLD.id_eqmborder is not NULL) then
--  Raise Notice '' 1 '';
   v:= eqt_change_fun(0,NULL,NEW.dt_change, NEW.id_person, NEW.id_border , 1); 
  else
--  Raise Notice '' 2 '';
   v:= eqt_change_fun(0,vid_tree,NEW.dt_change, NEW.id_person, New.id_eqp, 1); 
  end if;
-------------===================================================-----------
  -- свойства ТУ
  if (NEW.id_tariff<>OLD.id_tariff) or (NEW.set_power<>OLD.set_power)  
  or (NEW.id_classpower<>OLD.id_classpower) then

   update eqm_point_tbl set id_voltage=NEW.id_classpower,id_tarif=NEW.id_tariff,
   power=NEW.set_power 
   where code_eqp=NEW.id_point;

  end if;

  -- код счетчика
  if NEW.num_eqp<>OLD.num_eqp then

    update eqm_equipment_tbl set num_eqp= NEW.num_eqp 
    where id = NEW.id_eqp;

  end if;

  -- свойства счетчика
  if (NEW.id_typemet<>OLD.id_typemet) or (NEW.date_check<>OLD.date_check) then

   update eqm_meter_tbl set id_type_eqp=NEW.id_typemet, dt_control=NEW.date_check
   where code_eqp=NEW.id_eqp;

   -- при смене типа счетчика триггер убрал вид енергии
   -- вернем его назад
   if NEW.id_typemet<>OLD.id_typemet then 
     insert into eqd_meter_energy_tbl (code_eqp,kind_energy,date_inst)
     values (NEW.id_eqp,1,new.dt_change);
   end if; 

  end if;

  --изменение типа тр. тока
  if (coalesce(old.id_typecompa,0)<>coalesce(NEW.id_typecompa,0))
      and (NEW.id_typecompa is not null) and (OLD.id_typecompa is not null) then

   update eqm_compensator_i_tbl set id_type_eqp=NEW.id_typecompa
   where code_eqp=NEW.id_compa;

  end if;

  --изменение типа тр. напр.
  if (coalesce(old.id_typecompu,0)<>coalesce(NEW.id_typecompu,0)) 
     and (NEW.id_typecompu is not null) and (OLD.id_typecompu is not null) then

   update eqm_compensator_i_tbl set id_type_eqp=NEW.id_typecompu
   where code_eqp=NEW.id_compu;

  end if;
-------------===================================================-----------
  -- очистим таблицу замены
--//--  Delete from eqt_change_tbl where id_operation = v;
  --протокол включен для изменения с изм. топологии
--//--  v:= eqt_change_fun(2,vid_tree,NEW.dt_change, NEW.id_person, NEW.id_eqp, 1); 
-------------===================================================-----------
  -- вставка тр. тока
  if (OLD.id_typecompa is null) and (NEW.id_typecompa is not null) then

    --select into vid_tree id_tree from eqm_eqp_tree_tbl
    --where code_eqp=NEW.id_eqp;

    insert into eqm_equipment_tbl (id,type_eqp,name_eqp,id_addres,dt_install,dt_change)
    values (NEW.id_compa,10,''Тр.тока''||NEW.name,NEW.id_address,NEW.dt_change,NEW.dt_change);

    insert into eqm_compensator_i_tbl(code_eqp,id_type_eqp)
    values (NEW.id_compa,NEW.id_typecompa);

    insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
    values(vid_tree,NEW.id_compa,NEW.id_point,''Тр.тока''||NEW.name,1);

    if NEW.id_typecompu is not NULL then
      update eqm_eqp_tree_tbl set code_eqp_e = NEW.id_compa 
      where code_eqp = NEW.id_compu;
    else
      update eqm_eqp_tree_tbl set code_eqp_e = NEW.id_compa 
      where code_eqp = NEW.id_eqp;
   end if;
  end if;


  -- удаление тр. тока
  if (OLD.id_typecompa is not null) and (NEW.id_typecompa is null) then

    delete from eqm_equipment_tbl where id=OLD.id_compa; --остальное сделают три

  end if;

  -- вставка тр. напр.
  if (OLD.id_typecompu is null) and (NEW.id_typecompu is not null) then

--    select into vid_tree id_tree from eqm_eqp_tree_tbl
--    where code_eqp=NEW.id_eqp;

    insert into eqm_equipment_tbl (id,type_eqp,name_eqp,id_addres,dt_install,dt_change)
    values (NEW.id_compu,10,''Тр.напр.''||NEW.name,NEW.id_address,NEW.dt_change,NEW.dt_change);

    insert into eqm_compensator_i_tbl(code_eqp,id_type_eqp)
    values (NEW.id_compu,NEW.id_typecompu);

    insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
    values(vid_tree,NEW.id_compu,NEW.id_point,''Тр.напр.''||NEW.name,1);

    if NEW.id_typecompa is not NULL then
      update eqm_eqp_tree_tbl set code_eqp_e = NEW.id_compu 
      where code_eqp = NEW.id_compa;
    else
      update eqm_eqp_tree_tbl set code_eqp_e = NEW.id_compu 
      where code_eqp = NEW.id_eqp;
   end if;

  end if;

  -- удаление тр. напр.
  if (OLD.id_typecompu is not null) and (NEW.id_typecompu is null) then

    delete from eqm_equipment_tbl where id=OLD.id_compu; --остальное сделают три

  end if;
  -- очистим таблицу замены
--//--  Delete from eqt_change_tbl where id_operation = v;
-------------===========================================-----------

  -- предок
  if coalesce(NEW.id_eqmborder,0)<>coalesce(OLD.id_eqmborder,0) then

     if OLD.id_eqmborder is not null then 
       --граница была 

--       select into vid_old_tree id_tree from eqm_eqp_tree_tbl
--       where code_eqp=OLD.id_eqmborder;

--//--       v:= eqt_change_fun(2,vid_old_tree,NEW.dt_change, NEW.id_person, NEW.id_border, 1); 

       -- переподключение
       if NEW.id_eqmborder is not null then 

         select into vparent tt.id_tree,t.id_client
         from eqm_tree_tbl AS t JOIN eqm_eqp_tree_tbl AS tt on (t.id=tt.id_tree)
         where tt.code_eqp = NEW.id_eqmborder;

         -- проверить, не изменилась ли принадлежность
         select into olduse id_client from eqm_eqp_use_tbl where code_eqp = OLD.id_border;
         select into newuse id_client from eqm_eqp_use_tbl where code_eqp = NEW.id_eqmborder;

         if (coalesce(olduse,0)<>coalesce(newuse,0)) then

           delete from eqm_eqp_use_tbl where code_eqp = OLD.id_border;

           insert into eqm_eqp_use_tbl (code_eqp,id_client,dt_install) 
           select NEW.id_border,u.id_client, date_larger(u.dt_install::date,NEW.dt_change::date) 
           from eqm_eqp_use_tbl as u where code_eqp = NEW.id_eqmborder;

         end if;


         delete from eqm_eqp_tree_tbl  
         where code_eqp = OLD.id_border and code_eqp_e=OLD.id_eqmborder;

         update eqm_equipment_tbl set dt_install=new.dt_change where id=new.id_border;

         -- в новое родительское
         insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
         values(vparent.id_tree,NEW.id_border,NEW.id_eqmborder,''Граница_''||NEW.name,1);

         update eqm_borders_tbl set id_clientA=vparent.id_client 
         where code_eqp=OLD.id_border;

       else
       -- отключение
         delete from eqm_equipment_tbl where id = OLD.id_border;

       end if;
       -- очистим таблицу замены
--//--       Delete from eqt_change_tbl where id_operation = v;

     else
      --граници раньше не было
--//--       v:= eqt_change_fun(2,vid_tree,NEW.dt_change, NEW.id_person, 0, 1); 

       select into vparent tt.id_tree,t.id_client
       from eqm_tree_tbl AS t JOIN eqm_eqp_tree_tbl AS tt on (t.id=tt.id_tree)
       where tt.code_eqp = NEW.id_eqmborder;

       --Граница раздела
       insert into eqm_equipment_tbl (id,type_eqp,name_eqp,id_addres,dt_install,dt_change)
       values (NEW.id_border,9,''Граница_''||NEW.name,NEW.id_address,NEW.dt_change,NEW.dt_change);

       insert into eqm_borders_tbl (code_eqp,id_clientA,id_clientB)
       values (NEW.id_border,vparent.id_client,NEW.id_client);

       -- в текущее дерево
       insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
       values(vid_tree,NEW.id_border,NULL,''Граница_''||NEW.name,0);

       -- в родительское
       insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
       values(vparent.id_tree,NEW.id_border,NEW.id_eqmborder,''Граница_''||NEW.name,1);

       -- если предок граници используется в расчете другого абонента, то и граница должна
       insert into eqm_eqp_use_tbl (code_eqp,id_client,dt_install) 
       select NEW.id_border,u.id_client, date_larger(u.dt_install::date,NEW.dt_change::date) 
       from eqm_eqp_use_tbl as u where code_eqp = NEW.id_eqmborder;

       -- очистим таблицу замены
--//--       Delete from eqt_change_tbl where id_operation = v;

     end if;

  end if;
--  Delete from eqt_change_tbl where id_operation = v;

  RETURN NEW;                                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


 CREATE TRIGGER eqm_edprivmeter_trg 
 before  UPDATE 
 ON eqm_privmeter_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE eqm_edprivmeter_fun();
-----------------------------------------------------------

/*
  DROP TRIGGER eqm_delprivmeter_zone_trg ON eqm_privmetzone_tbl;

  CREATE or replace FUNCTION eqm_delprivmeter_zone_fun ()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
  v int;
  begin

--   v:= eqt_change_fun(4,null, NEW.date_inst, 0, NEW.id_eqp, 0); --протокол отключен

   delete from eqd_meter_zone_tbl where code_eqp = OLD.id_eqp and zone=OLD.id_zone;

  -- Delete from eqt_change_tbl where id_operation = v;
   --Raise Notice ''stop'';


  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


 CREATE TRIGGER eqm_delprivmeter_zone_trg 
 before  delete 
 ON eqm_privmetzone_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE eqm_delprivmeter_zone_fun();

*/