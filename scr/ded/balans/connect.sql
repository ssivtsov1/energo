drop TABLE bal_connector_tbl;
drop sequence bal_connector_seq;
/*
create sequence bal_connector_seq increment 1; 

CREATE TABLE bal_connector_tbl
(
  id  int default nextval('bal_connector_seq'),
  name varchar(100),
  PRIMARY KEY (id)
) 
WITH OIDS;

*/

CREATE TABLE bal_connector_oper_tbl
(
  id_con int,
  id_fider integer,
  id_st integer,
  PRIMARY KEY (id_con,id_fider,id_st)
) 
WITH OIDS;

drop TABLE bal_connector_depend_tbl;
/*
CREATE TABLE bal_connector_depend_tbl
(
  id_con int,
  id_con2 int,
  operation int,
  PRIMARY KEY (id_con,id_con2)
) 
WITH OIDS;
*/


create sequence bal_switching_seq increment 1; 

CREATE TABLE bal_switching_tbl
(
  id integer NOT NULL DEFAULT nextval('bal_switching_seq'),
  id_fider  int,
--  id_con int,
--  operation int,
--  dt_operation timestamp without time zone,
  dt_on timestamp without time zone,
  dt_off timestamp without time zone,
  comment varchar(200),
  dt timestamp without time zone DEFAULT now(),
  PRIMARY KEY (id)
) 
WITH OIDS;


alter table bal_switching_tbl drop column id_con;
alter table bal_switching_tbl drop column operation;
alter table bal_switching_tbl drop column dt_operation;
alter table bal_switching_tbl add column dt_on timestamp without time zone;
alter table bal_switching_tbl add column dt_off timestamp without time zone;
alter table bal_switching_tbl add column id_fider  int;
--------------------------------------------------
/*                                                                                                  
  CREATE or replace FUNCTION bal_delconnector_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
    v int;
   begin       
         
   select into v id from bal_switching_tbl where id_con = OLD.id;

   if found then 
     raise exception ''Для данного переключателя есть записи в журнале переключения !'';
   end if;

   delete from bal_connector_oper_tbl where id_con = OLD.id;

   delete from bal_connector_depend_tbl where id_con = OLD.id;
   delete from bal_connector_depend_tbl where id_con2 = OLD.id;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER bal_delconnector_trg 
BEFORE  DELETE 
ON bal_connector_tbl
FOR EACH ROW 
EXECUTE PROCEDURE bal_delconnector_fun();
*/
-------------------------------------------------
drop TRIGGER bal_switching_trg ON bal_switching_tbl;
drop FUNCTION bal_switching_fun () ;
/*
  CREATE or replace FUNCTION bal_switching_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
    v int;
   begin       
         
    insert into bal_switching_tbl(id_con,operation,dt_operation,comment)
    select id_con2, operation, NEW.dt_operation,''Автопереключение'' 
    from bal_connector_depend_tbl 
    where id_con = NEW.id_con;

   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER bal_switching_trg 
AFTER INSERT 
ON bal_switching_tbl
FOR EACH ROW 
EXECUTE PROCEDURE bal_switching_fun();
*/

  CREATE or replace FUNCTION bal_delswitching_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
    v int;
   begin       
         
     delete from bal_connector_oper_tbl where id_con = OLD.id;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER bal_delswitching_trg 
BEFORE DELETE 
ON bal_switching_tbl
FOR EACH ROW 
EXECUTE PROCEDURE bal_delswitching_fun();

-------------------------------------------------
/*
  CREATE or replace FUNCTION bal_connector_dependadd_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   declare
    v int;
   begin       

   if NEW.id_con = NEW.id_con2 then 
     raise exception ''Переключатель не может быть связан с самим собой !'';
   end if;
         

   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


CREATE TRIGGER bal_connector_dependadd_trg 
BEFORE INSERT 
ON bal_connector_depend_tbl
FOR EACH ROW 
EXECUTE PROCEDURE bal_connector_dependadd_fun();
-------------------------------------------------
*/
create sequence bal_grp_tree_conn_seq increment 1; 
/*
CREATE TABLE bal_grp_tree_conn_tmp
(
  id_tree  integer ,
  code_eqp integer ,
  name     character varying(25),
  id_p_eqp integer,
  type_eqp integer,
  dat_b    timestamp without time zone,
  dat_e    timestamp without time zone,
  lvl      integer,
  id_client integer,
  id_point integer,
  demand   numeric(14,4),
  demand04 numeric(14,4),
  losts    numeric(14,4),
  fact_losts numeric(14,4),
  losts_coef numeric(12,10) DEFAULT 0,
  id_voltage integer,
  mmgg     date NOT NULL,
  is_recon int default 0,
  id_switching int,
  id integer NOT NULL DEFAULT nextval('bal_grp_tree_conn_seq'),
  PRIMARY KEY (id)
); 
*/
CREATE TABLE bal_grp_tree_conn_tbl
(
  id_tree  integer ,
  code_eqp integer ,
  name     character varying(25),
  id_p_eqp integer,
  type_eqp integer,
  dat_b    timestamp without time zone,
  dat_e    timestamp without time zone,
  lvl      integer,
  id_client integer,
  id_point integer,
  demand   integer,
  demand04 integer,
  losts    integer,
  fact_losts integer,
  losts_coef numeric(12,10) DEFAULT 0,
  id_voltage integer,
  mmgg     date NOT NULL,
  is_recon int default 0,
  id_switching int,
  id integer NOT NULL DEFAULT nextval('bal_grp_tree_conn_seq'),
  PRIMARY KEY (id)
); 


