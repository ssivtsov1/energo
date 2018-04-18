-- новый экземпляр оборудования
--  DROP FUNCTION eqm_neweqp_fun (int,varchar,varchar,int,timestamp,timestamp,int);                                                   
  DROP FUNCTION eqm_neweqp_fun (int,varchar,varchar,int,timestamp,timestamp,int);
  CREATE or replace FUNCTION eqm_neweqp_fun (int,varchar,varchar,int,timestamp,timestamp,int,int)
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   newid int;
   begin                

   insert into eqm_equipment_tbl (type_eqp,name_eqp,num_eqp,id_addres,dt_install,dt_change,loss_power,is_owner)
   values ($1,$2,$3,$4,$5,$6,$7,$8);
   select into newid currval(''"eqm_equipment_seq"''::text);

   insert into mnm_eqp_params_tbl(code_eqp,id_param)
   select newid,i.id from  mni_eqp_params_tbl as i 
   where i.type_eqp = $1 
   order by i.id;

  RETURN newid;
  end;'                                                                                           
  LANGUAGE 'plpgsql';

-- новый вид трансформатора
--  DROP FUNCTION eqi_newcomp_fun (varchar,varchar,numeric(9,1),int,numeric(9,1),int,numeric(9,1),int,int,int,int,int,numeric(8,4));                                                   
                                                                                                  
  CREATE or replace FUNCTION eqi_newcomp_fun (varchar,varchar,numeric(9,1),int,numeric(9,1),int,numeric(9,1),int,int,int,int,int,numeric(8,4))
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   newid int;
   begin                

   insert into eqi_compensator_tbl (type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,
   voltage2_nom,amperage2_nom,phase,swathe,hook_up,power_nom,amperage_no_load)
   values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13);
   select into newid currval(''"eqi_devices_seq"''::text);

  RETURN newid;
  end;'                                                                                           
  LANGUAGE 'plpgsql';

-- новый вид кабеля
--  DROP FUNCTION eqi_newcable_fun (varchar,varchar,numeric(9,1),int,numeric(9,1),int,int,int,int,numeric(10,6),numeric(8,4));                                                   
                                                                                                  
  CREATE or replace FUNCTION eqi_newcable_fun (varchar,varchar,numeric(9,1),int,numeric(9,1),int,int,int,int,numeric(10,6),numeric(8,4))
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   newid int;
   begin                

   insert into eqi_cable_tbl (type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,cords,cover,s_nom,ro,dpo)
   values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11);
   select into newid currval(''"eqi_devices_seq"''::text);

  RETURN newid;
  end;'                                                                                           
  LANGUAGE 'plpgsql';
-- новый вид счетчика
--  DROP FUNCTION eqi_newmeter_fun (varchar,varchar,int,int,int,int,int,int,int,int,int,int,int,int,int,numeric(4,2),int);                                                   
                                                                                                  
--  CREATE FUNCTION eqi_newmeter_fun (varchar,varchar,int,int,int,int,int,int,int,int,int,int,int,int,int,numeric(4,2),int)
--  RETURNS int                                                                                     
--  AS                                                                                              
--  '
--   declare
--   newid int;
--   begin                

--   insert into eqi_meter_tbl (normative,voltage_nom,amperage_nom,voltage_max,amperage_max,
--   kind_meter, kind_count, phase, carry, schema_inst, hook_up, amperage_nom_s, voltage_nom_s, 
--   zones, zone_time_min, term_control)
--   values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17);
--   select into newid currval(''"eqi_devices_seq"''::text);

--  RETURN newid;
--  end;'                                                                                           
--  LANGUAGE 'plpgsql';

-- новый вид трансформатора тока 
--  DROP FUNCTION eqi_newcomp_i_fun (varchar,varchar,int,int,int,int,int,int,int,int,numeric(8,4),int);                                                   
                                                                                                  
--  CREATE FUNCTION eqi_newcomp_i_fun (varchar,varchar,int,int,int,int,int,int,int,int,numeric(8,4),int)
--  RETURNS int                                                                                     
--  AS                                                                                              
--  '
--   declare
--   newid int;
--   begin                

--   insert into eqi_compensator_i_tbl (type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,
--   phase,swathe,hook_up,power_nom,amperage_no_load,k_compens)
--   values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);
--   select into newid currval(''"eqi_devices_seq"''::text);

--  RETURN newid;
--  end;'                                                                                           
--  LANGUAGE 'plpgsql';
 -- новое дерево 
--  DROP FUNCTION eqi_newtree_fun (varchar,integer,varchar);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqi_newtree_fun (varchar,integer,varchar)                                                   
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   newid int;
   begin                
   insert  into eqm_tree_tbl (name,code_eqp,id_client) values ($1,$2,$3);
   select into newid currval(''"eqm_tree_seq"''::text);

  RETURN newid;
  end;'                                                                                           
  LANGUAGE 'plpgsql';
/*
  DROP FUNCTION eqm_adr_up_fun (integer,integer);                                                  
  CREATE FUNCTION eqm_adr_up_fun (integer,integer)                                                  
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   oldorder int;
--   maxorder int;
   begin       

   select into oldorder pathorder from eqm_line_path_tbl
   where code_eqp=$1 and id_addres=$2;

--   select into maxorder max(pathorder) from eqm_line_path_tbl
--   where code_eqp=$1;

   update eqm_line_path_tbl set pathorder=pathorder+1 
   where code_eqp=$1 and pathorder=oldorder-1;

   update eqm_line_path_tbl set pathorder=pathorder-1 
   where code_eqp=$1 and id_addres=$2 and pathorder<>1;

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
*/
/*
  DROP FUNCTION eqm_adr_down_fun (integer,integer);                                                  
  CREATE FUNCTION eqm_adr_down_fun (integer,integer)                                                  
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   oldorder int;
   maxorder int;
   begin       

   select into oldorder pathorder from eqm_line_path_tbl
   where code_eqp=$1 and id_addres=$2;

   select into maxorder max(pathorder) from eqm_line_path_tbl
   where code_eqp=$1;

   update eqm_line_path_tbl set pathorder=pathorder-1 
   where code_eqp=$1 and pathorder=oldorder+1;

   update eqm_line_path_tbl set pathorder=pathorder+1 
   where code_eqp=$1 and id_addres=$2 and pathorder<>maxorder;

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

*/
--  DROP FUNCTION eqi_newtree_border_fun (varchar,integer,varchar,integer,varchar);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqi_newtree_border_fun (varchar,integer,varchar,integer,varchar)                                                   
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
   newid int;
   treename Alias for $1;
   root Alias for $2;
   rootname Alias for $3;
   abon Alias for $4;
   abonname Alias for $5;
   res record;
   resid int;

   begin            
   
   select into resid cast(to_number(value_ident,''9999999999'') as int) from syi_sysvars_tbl where ident=''id_res'';   

--   UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = ''eqm_tree_tbl'';

   insert into eqm_tree_tbl (name,code_eqp,id_client) values (abonname,root,resid);
   select into newid currval(''"eqm_tree_seq"''::text);

   insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
          values (newid, root, NULL, rootname, 0);

   insert into eqm_tree_tbl (name,code_eqp,id_client) values (treename,root,abon);
   select into newid currval(''"eqm_tree_seq"''::text);

   insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
          values (newid, root, NULL, rootname, 0);

--   UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) WHERE relname = ''eqm_tree_tbl'';
  
  RETURN newid;
  end;'                                                                                           
  LANGUAGE 'plpgsql';




 CREATE OR REPLACE FUNCTION syi_resid_fun()                                                   
  RETURNS int                                                                                     
  AS                                                                                              
  '
  declare
  id_res int;
  begin
   select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
   RETURN id_res;
  end;'                                                                                           
  LANGUAGE 'plpgsql';

