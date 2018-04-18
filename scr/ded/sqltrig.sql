;
set client_encoding = 'koi8';

DROP TRIGGER eqm_deleqp_trg ON eqm_equipment_tbl;
DROP TRIGGER eqm_delpoint_trg ON eqm_point_tbl;
DROP TRIGGER eqm_delmeter_trg ON eqm_meter_tbl;
DROP TRIGGER eqi_delmeter_trg ON eqi_meter_tbl;
DROP TRIGGER eqi_delcompens_trg ON eqi_compensator_tbl;
DROP TRIGGER eqm_editeqp_trg ON eqm_equipment_tbl;
DROP TRIGGER eqi_editcompens_trg ON eqi_compensator_tbl;
DROP TRIGGER eqm_editmeter_trg ON eqm_meter_tbl;
DROP TRIGGER eqm_delchange_trg ON eqm_change_tbl;

-- удаление экземпляра оборудования
  DROP FUNCTION eqm_deleqp_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_deleqp_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
   tname varchar(80);
   begin                
   -- площадка 
   delete from eqm_compens_station_inst_tbl where
   (code_eqp_inst = OLD.id) or (code_eqp = OLD.id);

   delete from eqm_area_tbl where (code_eqp = OLD.id);

   -- адрес может быть не использован
   --delete from eqm_line_path_tbl where code_eqp = OLD.id;
   -- таблица исп. для ресовского оборудования
   delete from eqm_eqp_use_tbl where code_eqp = OLD.id;

--   select syt.name from 
--   (eqm_equipment_tbl AS eq JOIN
--   (eqi_device_kinds_tbl AS dk JOIN syi_table_tbl AS syt ON (dk.id_table=syt.id))
--        ON (eq.type_eqp=dk.id)) where eq.id=OLD.id;
   tname:='''';
   -- имя таблици данных
   select into tname syt.name from 
   (eqi_device_kinds_tbl AS dk JOIN syi_table_tbl AS syt ON (dk.id_table=syt.id))
         where OLD.type_eqp=dk.id;
    -- 
    IF table_exists(tname) THEN
        EXECUTE ''delete from ''|| quote_ident(tname) || '' where code_eqp =''||quote_literal(OLD.id);
    END IF;

   -- удаление из дерева (триггер дерева)
   delete from eqm_eqp_tree_tbl where code_eqp = OLD.id;

   update clm_pclient_tbl set id_eqpborder = null where id_eqpborder = OLD.id;

   delete from mnm_eqp_params_tbl where code_eqp = OLD.id;

  RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqm_deleqp_trg 
BEFORE  DELETE 
ON eqm_equipment_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_deleqp_fun();

-----------------------------
--удаление экземпляра счетчика
  DROP FUNCTION eqm_delmeter_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_delmeter_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
         
   delete from eqd_meter_zone_tbl where code_eqp = OLD.code_eqp;

   delete from eqd_meter_energy_tbl where code_eqp = OLD.code_eqp;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqm_delmeter_trg 
BEFORE  DELETE 
ON eqm_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_delmeter_fun();

-----------------------------
--удаление типа счетчика

  DROP FUNCTION eqi_delmeter_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqi_delmeter_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
        
   delete from eqi_meter_prec_tbl where id_type_eqp = OLD.id;

   delete from eqi_meter_energy_tbl where id_type_eqp = OLD.id;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqi_delmeter_trg 
BEFORE  DELETE 
ON eqi_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqi_delmeter_fun();
-------------------------------------------------
--удаление типа трансформатора

  DROP FUNCTION eqi_delcompens_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqi_delcompens_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
         
   delete from eqi_compensator_2_tbl where id_type_eqp = OLD.id;

   delete from eqi_compensator_3_tbl where id_type_eqp = OLD.id;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqi_delcompens_trg 
BEFORE  DELETE 
ON eqi_compensator_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqi_delcompens_fun();
-------------------------------------------------
--изменение числа обмоток трансформатора

  DROP FUNCTION eqi_editcompens_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqi_editcompens_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
   
   if OLD.swathe<>NEW.swathe then
   
   if OLD.swathe= 2 then
   delete from eqi_compensator_2_tbl where id_type_eqp = OLD.id;
   insert into eqi_compensator_3_tbl(id_type_eqp) values (OLD.id);
   end if;

   if OLD.swathe= 3 then
   delete from eqi_compensator_3_tbl where id_type_eqp = OLD.id;
   insert into eqi_compensator_2_tbl(id_type_eqp) values (OLD.id);
   end if;
   end if;

   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqi_editcompens_trg 
BEFORE  UPDATE 
ON eqi_compensator_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqi_editcompens_fun();

------------------------------------------------
--удаление дерева

  DROP TRIGGER eqm_deltree_trg ON eqm_tree_tbl;


  DROP FUNCTION eqm_deltree_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_deltree_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
   
   delete from eqm_equipment_tbl where id = OLD.code_eqp;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqm_deltree_trg 
BEFORE DELETE 
ON eqm_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_deltree_fun();

------------------------------------------------
--Вставка адреса 
/*
  DROP TRIGGER eqm_addadr_trg ON eqm_line_path_tbl;
  DROP FUNCTION eqm_addadr_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_addadr_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
   maxorder int;
   begin       
   
   select into maxorder max(pathorder) from eqm_line_path_tbl 
   where code_eqp=new.code_eqp;

   update eqm_line_path_tbl set pathorder=maxorder+1 
   where code_eqp=new.code_eqp and id_addres=new.id_addres;

   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqm_addadr_trg 
after INSERT 
ON eqm_line_path_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_addadr_fun();
*/
------------------------------------------------
--Удаление адреса 
/*
  DROP TRIGGER eqm_deladr_trg ON eqm_line_path_tbl;
  DROP FUNCTION eqm_deladr_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_deladr_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       

   update eqm_line_path_tbl set pathorder=pathorder-1 
   where code_eqp=old.code_eqp and pathorder>old.pathorder;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqm_deladr_trg 
before DELETE 
ON eqm_line_path_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_deladr_fun();
*/
-----------------------------
--изменение экземпляра счетчика

  DROP FUNCTION eqm_editmeter_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_editmeter_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       

   if OLD.id_type_eqp<>NEW.id_type_eqp then

   delete from eqd_meter_energy_tbl where code_eqp = OLD.code_eqp;
   delete from eqd_meter_zone_tbl where code_eqp = OLD.code_eqp;
--   select ... from eqi_meter_energy_tbl where NEW.id_type_eqp
   end if;
   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


--CREATE TRIGGER eqm_editmeter_trg 
--BEFORE  UPDATE 
--ON eqm_meter_tbl
--FOR EACH ROW 
--EXECUTE PROCEDURE eqm_editmeter_fun();

-----------------------------
--новый экземпляр счетчика
  DROP TRIGGER eqm_newmeter_trg ON eqm_meter_tbl;
  DROP FUNCTION eqm_newmeter_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_newmeter_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
    newdate timestamp;
    energy record;
    energy_count integer;
   begin       
   -- дата нового оборудования
   select into newdate dt_install::timestamp from eqm_equipment_tbl where id = NEW.code_eqp;
   -- посчитаем виды энергии, если он один, то поставим его (count может глючить)
   energy_count:=0;
   for energy in select kind_energy from eqi_meter_energy_tbl where NEW.id_type_eqp=id_type_eqp loop
     energy_count:=energy_count+1;
   end loop;
 
   if energy_count=1 then
  
     insert into eqd_meter_energy_tbl(code_eqp,kind_energy,date_inst)
     select NEW.code_eqp, eqi.kind_energy, newdate from eqi_meter_energy_tbl as eqi 
     where NEW.id_type_eqp=eqi.id_type_eqp;

     -- зона по умолчанию
     insert into eqd_meter_zone_tbl(code_eqp,zone,kind_energy,dt_zone_install)
     select NEW.code_eqp, 0,eqi.kind_energy, newdate from eqi_meter_energy_tbl as eqi 
     where NEW.id_type_eqp=eqi.id_type_eqp;

   end if;


   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqm_newmeter_trg 
AFTER  INSERT 
ON eqm_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_newmeter_fun();


-- Изменение экземпляра оборудования
  drop TRIGGER eqm_editeqp_trg ON eqm_equipment_tbl;
  DROP FUNCTION eqm_editeqp_fun ();                                                   
                                                                                                  
  CREATE or replace FUNCTION eqm_editeqp_fun ()                                                  
  RETURNS trigger                                                                                     
  AS                                                                                              
  '
   declare
   tname varchar(80);
   vnamecopy int;
   v_h_tablename varchar;
   begin                
   tname:='''';
   -- имя таблици данных
   select into tname syt.name from 
   (eqi_device_kinds_tbl AS dk JOIN syi_table_tbl AS syt ON (dk.id_table=syt.id))
         where OLD.type_eqp=dk.id;


   if new.type_eqp<>old.type_eqp then
    IF table_exists(tname) THEN
        EXECUTE ''delete from ''|| quote_ident(tname) || '' where code_eqp =''||quote_literal(OLD.id);
    END IF;
   END IF;


   vnamecopy:=GetSysVar(''eqpnamecopy'');

   if (new.name_eqp<>old.name_eqp) and (vnamecopy=1) then

    update eqm_eqp_tree_tbl set name = new.name_eqp where code_eqp= old.id and line_no= 0;

   END IF;


   if (old.dt_install=old.dt_change) and (old.dt_install<>new.dt_install) then

    update eqm_equipment_tbl set dt_change = new.dt_install where id= old.id ;
--      new.dt_change:=new.dt_install;
   END IF;


   if (old.dt_install<>new.dt_install) then
 
    v_h_tablename :=  substr(tname, 0, strpos(tname, ''_tbl''))::varchar||''_h'';

    EXECUTE ''update ''|| v_h_tablename ||'' set dt_b = ''||quote_literal(new.dt_install)||
    '' where code_eqp = ''||quote_literal(new.id)||'' and dt_b = ''||quote_literal(old.dt_install);

   end if;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqm_editeqp_trg 
AFTER  UPDATE 
ON eqm_equipment_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_editeqp_fun();

-----------------------------
-----------------------------
--новая энергия счетчика
-- триггер автоматически добавляет энергию точке учета при добавлении ее счетчику
  DROP TRIGGER eqd_newmeter_energy_trg ON eqd_meter_energy_tbl;
  DROP FUNCTION eqd_meter_energy_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqd_meter_energy_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
  declare
   tree_id  int;
   point_id int;
   v int;
  begin

   select into tree_id id_tree from eqm_eqp_tree_tbl where code_eqp=new.code_eqp;

   point_id:= find_eqm(new.code_eqp,tree_id,12); --ищем точку учета

   if point_id<>0 then
      --есть ли такой вид энергии у точки
      select into v kind_energy from eqd_point_energy_tbl where kind_energy=new.kind_energy and code_eqp=point_id;

      if not found then

         insert into eqd_point_energy_tbl (code_eqp,kind_energy,dt_instal)
         values (point_id,new.kind_energy,new.date_inst);

      end if;
   end if;

  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqd_newmeter_energy_trg 
AFTER  insert 
ON eqd_meter_energy_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqd_meter_energy_fun();
---------------------------------------------------------------------------

--удаление точки учета
  DROP FUNCTION eqm_delpoint_fun ();                                                   
                                                                                                  
  CREATE or Replace FUNCTION eqm_delpoint_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
         
     delete from eqd_point_energy_tbl where code_eqp = OLD.code_eqp;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqm_delpoint_trg 
BEFORE  DELETE 
ON eqm_point_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_delpoint_fun();



CREATE OR REPLACE FUNCTION eqm_editpoint_fun()
  RETURNS "trigger" AS
$BODY$
   declare
     varea int;
     vcnt int;
   begin       
         
   if (coalesce(NEW.power,0) = coalesce(OLD.power,0) ) and (coalesce(NEW.wtm,0) = coalesce(OLD.wtm,0)) then
     return NEW;
   end if;

   select into varea a.id as id_area
   from eqm_compens_station_inst_tbl as csi
   join eqm_equipment_tbl as a on (a.id = csi.code_eqp_inst)
   where a.type_eqp = 11 and csi.code_eqp = NEW.code_eqp
   limit 1;

   if varea is not null then 

    select into vcnt count(csi.code_eqp) 
    from eqm_compens_station_inst_tbl as csi
    join eqm_equipment_tbl as eq on (eq.id = csi.code_eqp)
    where csi.code_eqp_inst = varea and eq.type_eqp = 12;


    if vcnt = 1 then
     -- ╘╧╠╪╦╧ ╧─╬┴ ╘╧▐╦┴ ╒▐┼╘┴ ╨╥╔╬┴─╠┼╓╔╘ ╨╠╧▌┴─╦┼
     update eqm_ground_tbl set power = NEW.power, wtm = NEW.wtm
     where code_eqp = varea; 
   
    end if;

   end if;

   RETURN NEW;
  end;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;




CREATE TRIGGER eqm_editpoint_trg
  BEFORE UPDATE
  ON eqm_point_tbl
  FOR EACH ROW
  EXECUTE PROCEDURE eqm_editpoint_fun();



  CREATE or replace FUNCTION eqi_meter_new_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare

   begin                

   raise exception ''·┴╨╥┼▌┼╬╧ ╙┴═╧╙╘╧╤╘┼╠╪╬╧┼ ─╧┬┴╫╠┼╬╔┼ ╙▐┼╘▐╔╦╧╫ ╫ ╙╨╥┴╫╧▐╬╔╦!'';

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER eqi_meter_new_trg 
BEFORE  INSERT
ON eqi_meter_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqi_meter_new_fun();



