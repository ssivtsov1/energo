;
set client_encoding = 'koi8';

create table cli_works_tbl (
id serial,
name varchar(100),
ident varchar(10),
primary key (id)
); 

--delete from cli_works_tbl;
insert into cli_works_tbl values (1,'Технiчна перевiрка','work1');
insert into cli_works_tbl values (2,'Контрольний огляд','work2');
insert into cli_works_tbl values (3,'Замiна','work3');
insert into cli_works_tbl values (4,'Перепломбування','work4');
insert into cli_works_tbl values (5,'Допуск в експлуатацiю','work5');
insert into cli_works_tbl values (6,'Вiдключення','work6');
insert into cli_works_tbl values (7,'Переоформлення договору','work7');
insert into cli_works_tbl values (8,'Вимога','work8');

create table clm_works_tbl (
id serial,
id_client int, 
id_point int, 
id_type int,
dt_work date,
id_position int, 
requirement_text varchar(250),
requirement_date date,
next_work_date date, 
comment varchar(205),
dt timestamp default now(),
primary key (id)
); 


ALTER TABLE clm_works_tbl ADD COLUMN id_person integer;
ALTER TABLE clm_works_tbl ALTER COLUMN id_person SET DEFAULT getsysvar('id_person'::character varying);
ALTER TABLE clm_works_tbl ADD COLUMN requirement_ok_date date;

ALTER TABLE clm_works_tbl ADD COLUMN act_num character varying(25);

ALTER TABLE clm_works_del ADD COLUMN act_num character varying(25);


create table clm_work_indications_tbl (
id serial,
id_work int, 
id_point int, 
id_meter int,
num_eqp varchar(50),
id_type int,
kind_energy int,
id_zone int,
value numeric(14,4),
primary key (id)
); 


alter table clm_work_indications_tbl add column id_indic int;



CREATE TABLE clm_work_indications_del
(
  id integer,
  id_work integer,
  id_point integer,
  id_meter integer,
  num_eqp character varying(50),
  id_type integer,
  kind_energy integer,
  id_zone integer,
  value numeric(14,4),
  dt_del timestamp without time zone DEFAULT now(),
  oper int,
  PRIMARY KEY (id,dt_del)
);


CREATE TABLE clm_works_del
(
  id int NOT NULL,
  id_client integer,
  id_point integer,
  id_type integer,
  dt_work date,
  id_position integer,
  requirement_text character varying(250),
  requirement_date date,
  next_work_date date,
  "comment" character varying(205),
  dt timestamp without time zone ,
  id_person integer ,
  requirement_ok_date date,
  dt_del timestamp without time zone DEFAULT now(),
  oper int,
  PRIMARY KEY (id,dt_del)
) ;


create table cli_plomb_type_tbl (
id serial,
name varchar(100),
ident varchar(10),
primary key (id)
); 


update clm_plomb_tbl set id_type = 16 where id_type = 12 and not exists (select id from cli_plomb_type_tbl where id = 16);
update cli_plomb_type_tbl set name = 'Клипсил' where id = 12;

insert into cli_plomb_type_tbl values (1,'Невiдомий', 'pl0');
insert into cli_plomb_type_tbl values (2,'Голограма', 'pl1');
insert into cli_plomb_type_tbl values (3,'Пластикова','pl2');
insert into cli_plomb_type_tbl values (4,'Металева',  'pl3');
insert into cli_plomb_type_tbl values (5,'Свинцева',  'pl3');

insert into cli_plomb_type_tbl values (6,'Ротосил-II','pl4');
insert into cli_plomb_type_tbl values (7,'Кристал',   'pl4');
insert into cli_plomb_type_tbl values (8,'Фаворит',   'pl4');
insert into cli_plomb_type_tbl values (9,'Гранiт',    'pl4');
insert into cli_plomb_type_tbl values (10,'Магнет',   'pl4');
insert into cli_plomb_type_tbl values (11,'MFI-3t',   'pl4');
--insert into cli_plomb_type_tbl values (12,'ИМП',      'pl4');
insert into cli_plomb_type_tbl values (12,'Клiпсил',  'pl4');
insert into cli_plomb_type_tbl values (13,'Iнше',     'pl0');
insert into cli_plomb_type_tbl values (14,'Сiлтек',   'pl4');
insert into cli_plomb_type_tbl values (15,'Мастiка',  'pl4');
insert into cli_plomb_type_tbl values (16,'ИМП',      'pl4');
insert into cli_plomb_type_tbl values (17,'КРОК',     'pl4');


create table clm_plomb_tbl (
id serial,
id_client int, 
id_point int, 
id_type int,
id_position int, 
id_position_off int, 
plomb_num varchar(200),
plomb_owner varchar(200),
object_name varchar(250),
dt_b date,
dt_e date,
comment varchar(250),
dt timestamp default now(),
primary key (id)
); 

ALTER TABLE clm_plomb_tbl ADD COLUMN id_person integer;
ALTER TABLE clm_plomb_tbl ALTER COLUMN id_person SET DEFAULT getsysvar('id_person'::character varying);



  CREATE or REPLACE FUNCTION clm_work_new_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       
   
	insert into clm_work_indications_tbl(id_work,id_point,id_meter,num_eqp,id_type,kind_energy,id_zone)
        select NEW.id,mp.id_point, mp.id_meter, eqm.num_eqp, m.id_type_eqp, me.kind_energy, mz.zone
        from eqm_meter_point_h as mp
        join eqm_equipment_h as eqm on (eqm.id =mp.id_meter)
        join eqm_meter_h as m on (m.code_eqp=mp.id_meter )
        join eqi_meter_tbl as im on (im.id = m.id_type_eqp)
        join eqd_meter_energy_h as me on (me.code_eqp = mp.id_meter)
        join eqd_meter_zone_h as mz on (mz.code_eqp = mp.id_meter and mz.kind_energy = me.kind_energy)
        where eqm.dt_b <= NEW.dt_work and (eqm.dt_e is null or eqm.dt_e>NEW.dt_work)  
        and m.dt_b <= NEW.dt_work and (m.dt_e is null or m.dt_e>NEW.dt_work)  
        and me.dt_b <= NEW.dt_work and (me.dt_e is null or me.dt_e>NEW.dt_work)  
        and mz.dt_b <= NEW.dt_work and (mz.dt_e is null or mz.dt_e>NEW.dt_work)  
        and mp.dt_b <= NEW.dt_work and (mp.dt_e is null or mp.dt_e>NEW.dt_work)  
        and mp.id_point = NEW.id_point;


	update clm_work_indications_tbl set id_indic = ind.id
        from acd_indication_tbl as ind ,
        (select i.id,max(ind.dat_ind) as max_ind
         from clm_work_indications_tbl as i 
         join clm_works_tbl as w on (w.id = i.id_work)  
         join acd_indication_tbl as ind on (i.id_meter = ind.id_meter and i.id_zone = ind.id_zone and i.kind_energy = ind.kind_energy and i.num_eqp = ind.num_eqp)
	 join acm_headindication_tbl as h on (ind.id_doc = h.id_doc)  
         where ind.dat_ind <= NEW.dt_work and h.idk_document in (310,345)
         and i.id_work = NEW.id
         and h.id_client = NEW.id_client
         group by i.id order by i.id
        ) as mi
       where mi.id = clm_work_indications_tbl.id
	and clm_work_indications_tbl.id_meter = ind.id_meter and clm_work_indications_tbl.id_zone = ind.id_zone and clm_work_indications_tbl.kind_energy = ind.kind_energy 
	and clm_work_indications_tbl.num_eqp = ind.num_eqp
	and ind.dat_ind = mi.max_ind
        and clm_work_indications_tbl.id_work = NEW.id;


   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



CREATE TRIGGER clm_work_new_trg 
AFTER  INSERT 
ON clm_works_tbl
FOR EACH ROW 
EXECUTE PROCEDURE clm_work_new_fun();


---------------------------------------------------------------------------------

  CREATE or REPLACE FUNCTION clm_work_del_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       

        INSERT INTO clm_works_del( id, id_client, id_point, id_type, dt_work, id_position, requirement_text, 
            requirement_date, next_work_date, "comment", dt, id_person, requirement_ok_date,act_num,oper)
        values(OLD.id, OLD.id_client, OLD.id_point, OLD.id_type, OLD.dt_work, OLD.id_position, OLD.requirement_text, 
          OLD.requirement_date, OLD.next_work_date, OLD.comment, OLD.dt, OLD.id_person, OLD.requirement_ok_date,OLD.act_num,1);
   
	delete from clm_work_indications_tbl where id_work = OLD.id;

   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



 CREATE TRIGGER clm_work_del_trg 
 AFTER  DELETE 
 ON clm_works_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE clm_work_del_fun();

 --------------------------------------------------------------

  CREATE or REPLACE FUNCTION clm_work_ed_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       

      INSERT INTO clm_works_del( id, id_client, id_point, id_type, dt_work, id_position, requirement_text, 
            requirement_date, next_work_date, "comment", dt, id_person, requirement_ok_date,act_num,oper)
      values(OLD.id, OLD.id_client, OLD.id_point, OLD.id_type, OLD.dt_work, OLD.id_position, OLD.requirement_text, 
          OLD.requirement_date, OLD.next_work_date, OLD.comment, OLD.dt, OLD.id_person, OLD.requirement_ok_date,OLD.act_num,2);
   

      if (coalesce(NEW.dt_work,now())<>coalesce(OLD.dt_work,now())) then

 	 update clm_work_indications_tbl set id_indic = ind.id
         from acd_indication_tbl as ind ,
         (select i.id,max(ind.dat_ind) as max_ind
          from clm_work_indications_tbl as i 
          join clm_works_tbl as w on (w.id = i.id_work)  
          join acd_indication_tbl as ind on (i.id_meter = ind.id_meter and i.id_zone = ind.id_zone and i.kind_energy = ind.kind_energy and i.num_eqp = ind.num_eqp)
	  join acm_headindication_tbl as h on (ind.id_doc = h.id_doc)  
          where ind.dat_ind <= NEW.dt_work and h.idk_document in (310,345)  
          and i.id_work = NEW.id
          and h.id_client = NEW.id_client
          group by i.id order by i.id
         ) as mi
         where mi.id = clm_work_indications_tbl.id
	 and clm_work_indications_tbl.id_meter = ind.id_meter and clm_work_indications_tbl.id_zone = ind.id_zone and clm_work_indications_tbl.kind_energy = ind.kind_energy 
	 and clm_work_indications_tbl.num_eqp = ind.num_eqp
	 and ind.dat_ind = mi.max_ind
         and clm_work_indications_tbl.id_work = NEW.id;

       end if;

   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



 CREATE TRIGGER clm_work_ed_trg 
 AFTER  UPDATE 
 ON clm_works_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE clm_work_ed_fun();

---------------------------------------------------------------
  CREATE or REPLACE FUNCTION clm_work_ind_create ()                                                  
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
       r record;
   begin       
   

        for r in select * from clm_works_tbl as w where id not in (select id_work from clm_work_indications_tbl)
        loop
 
  	 insert into clm_work_indications_tbl(id_work,id_point,id_meter,num_eqp,id_type,kind_energy,id_zone)
         select r.id,mp.id_point, mp.id_meter, eqm.num_eqp, m.id_type_eqp, me.kind_energy, mz.zone
         from eqm_meter_point_h as mp
         join eqm_equipment_h as eqm on (eqm.id =mp.id_meter)
         join eqm_meter_h as m on (m.code_eqp=mp.id_meter )
         join eqi_meter_tbl as im on (im.id = m.id_type_eqp)
         join eqd_meter_energy_h as me on (me.code_eqp = mp.id_meter)
         join eqd_meter_zone_h as mz on (mz.code_eqp = mp.id_meter)
         where eqm.dt_b <= r.dt_work and (eqm.dt_e is null or eqm.dt_e>r.dt_work)  
         and m.dt_b <= r.dt_work and (m.dt_e is null or m.dt_e>r.dt_work)  
         and me.dt_b <= r.dt_work and (me.dt_e is null or me.dt_e>r.dt_work)  
         and mz.dt_b <= r.dt_work and (mz.dt_e is null or mz.dt_e>r.dt_work)  
         and mp.dt_b <= r.dt_work and (mp.dt_e is null or mp.dt_e>r.dt_work)  
         and mp.id_point = r.id_point;

        end loop;
   RETURN 1;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

---------------------------------------------------------------

  CREATE or REPLACE FUNCTION clm_work_indications_del_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       

   INSERT INTO clm_work_indications_del( id, id_work, id_point, id_meter, num_eqp, id_type, kind_energy, id_zone, value ,oper)   
   VALUES ( OLD.id, OLD.id_work, OLD.id_point, OLD.id_meter, OLD.num_eqp, OLD.id_type, OLD.kind_energy, OLD.id_zone, OLD.value,1 );
 
   RETURN OLD;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



 CREATE TRIGGER clm_work_indications_del_trg 
 AFTER  DELETE 
 ON clm_work_indications_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE clm_work_indications_del_fun();

---------------------------------------------------------------

  CREATE or REPLACE FUNCTION clm_work_indications_ed_fun ()                                                  
  RETURNS TRIGGER                                                                                     
  AS                                                                                              
  '
   begin       

   if (OLD.value is not null) and (coalesce(OLD.value,0)<>coalesce(NEW.value,0)) then
    INSERT INTO clm_work_indications_del( id, id_work, id_point, id_meter, num_eqp, id_type, kind_energy, id_zone, value, oper )   
    VALUES ( OLD.id, OLD.id_work, OLD.id_point, OLD.id_meter, OLD.num_eqp, OLD.id_type, OLD.kind_energy, OLD.id_zone, OLD.value,2 );
   end if; 

   RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



 CREATE TRIGGER clm_work_indications_ed_trg 
 AFTER  UPDATE 
 ON clm_work_indications_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE clm_work_indications_ed_fun();

---------------------------------------------------------------
delete from clm_work_indications_tbl where id not in 
(select minid from 
(
select id_work,id_point,id_meter,num_eqp,id_type, kind_energy, id_zone,value, count(*), min(id) as minid
from clm_work_indications_tbl 
group by id_work,id_point,id_meter,num_eqp,id_type, kind_energy, id_zone,value
) as ss
); 

---------------------------------------------------------------

CREATE OR REPLACE FUNCTION fun_indic_new()
  RETURNS trigger 
  AS
  '
   begin       

 	 update clm_work_indications_tbl set id_indic = NEW.id
          from clm_works_tbl as w, acd_indication_tbl as i
          where ((i.id = clm_work_indications_tbl.id_indic) or (clm_work_indications_tbl.id_indic is null))
                and w.id = clm_work_indications_tbl.id_work
   	        and clm_work_indications_tbl.id_meter = NEW.id_meter and clm_work_indications_tbl.id_zone = NEW.id_zone 
		and clm_work_indications_tbl.kind_energy = NEW.kind_energy 
	        and clm_work_indications_tbl.num_eqp = NEW.num_eqp
                and w.dt_work >= NEW.dat_ind
                and i.dat_ind < NEW.dat_ind;

   RETURN NEW;
  end;'
  LANGUAGE 'plpgsql' VOLATILE;


CREATE TRIGGER indic_new
  AFTER INSERT
  ON acd_indication_tbl
  FOR EACH ROW
  EXECUTE PROCEDURE fun_indic_new();

------------

CREATE OR REPLACE FUNCTION fun_indic_delafter()
  RETURNS trigger 
  AS
  '
   begin       


	update clm_work_indications_tbl set id_indic = ind.id
        from acd_indication_tbl as ind ,
        (select i.id,max(ind.dat_ind) as max_ind
         from clm_work_indications_tbl as i 
         join clm_works_tbl as w on (w.id = i.id_work)  
         join acd_indication_tbl as ind on (i.id_meter = ind.id_meter and i.id_zone = ind.id_zone and i.kind_energy = ind.kind_energy and i.num_eqp = ind.num_eqp)
	 join acm_headindication_tbl as h on (ind.id_doc = h.id_doc)  
         where ind.dat_ind <= w.dt_work and h.idk_document in (310,345)
         and h.id_client = OLD.id_client
         and w.id_client = OLD.id_client
         group by i.id order by i.id
        ) as mi
       where mi.id = clm_work_indications_tbl.id
	and clm_work_indications_tbl.id_meter = ind.id_meter and clm_work_indications_tbl.id_zone = ind.id_zone and clm_work_indications_tbl.kind_energy = ind.kind_energy 
	and clm_work_indications_tbl.num_eqp = ind.num_eqp
	and ind.dat_ind = mi.max_ind
        and clm_work_indications_tbl.id_indic = OLD.id;   


   RETURN NEW;
  end;'
  LANGUAGE 'plpgsql' VOLATILE;


CREATE TRIGGER indic_delafter
  AFTER DELETE
  ON acd_indication_tbl
  FOR EACH ROW
  EXECUTE PROCEDURE fun_indic_delafter();

-------

CREATE OR REPLACE FUNCTION fun_indic_updafter()
  RETURNS trigger 
  AS
  '
   begin       

     if OLD.dat_ind<>NEW.dat_ind then

	update clm_work_indications_tbl set id_indic = ind.id
        from acd_indication_tbl as ind ,
        (select i.id,max(ind.dat_ind) as max_ind
         from clm_work_indications_tbl as i 
         join clm_works_tbl as w on (w.id = i.id_work)  
         join acd_indication_tbl as ind on (i.id_meter = ind.id_meter and i.id_zone = ind.id_zone and i.kind_energy = ind.kind_energy and i.num_eqp = ind.num_eqp)
	 join acm_headindication_tbl as h on (ind.id_doc = h.id_doc)  
         where ind.dat_ind <= w.dt_work and h.idk_document in (310,345)
         and h.id_client = OLD.id_client
         and w.id_client = OLD.id_client
         group by i.id order by i.id
        ) as mi
       where mi.id = clm_work_indications_tbl.id
	and clm_work_indications_tbl.id_meter = ind.id_meter and clm_work_indications_tbl.id_zone = ind.id_zone and clm_work_indications_tbl.kind_energy = ind.kind_energy 
	and clm_work_indications_tbl.num_eqp = ind.num_eqp
	and ind.dat_ind = mi.max_ind
        and clm_work_indications_tbl.id_indic = OLD.id;   



 	 update clm_work_indications_tbl set id_indic = NEW.id
          from clm_works_tbl as w, acd_indication_tbl as i
          where ((i.id = clm_work_indications_tbl.id_indic) or (clm_work_indications_tbl.id_indic is null))
                and w.id = clm_work_indications_tbl.id_work
   	        and clm_work_indications_tbl.id_meter = NEW.id_meter and clm_work_indications_tbl.id_zone = NEW.id_zone 
		and clm_work_indications_tbl.kind_energy = NEW.kind_energy 
	        and clm_work_indications_tbl.num_eqp = NEW.num_eqp
                and w.dt_work >= NEW.dat_ind
                and i.dat_ind < NEW.dat_ind;

     end if;

   RETURN NEW;
  end;'
  LANGUAGE 'plpgsql' VOLATILE;


CREATE TRIGGER indic_updafter
  AFTER UPDATE
  ON acd_indication_tbl
  FOR EACH ROW
  EXECUTE PROCEDURE fun_indic_updafter();


-----------------------------------------
--заполнение нового поля id_indic кодом строки последних показаний
/*
update clm_work_indications_tbl set id_indic = ind.id
       from acd_indication_tbl as ind ,
       (select i.id,max(ind.dat_ind) as max_ind
         from clm_work_indications_tbl as i 
         join clm_works_tbl as w on (w.id = i.id_work)  
         join acd_indication_tbl as ind on (i.id_meter = ind.id_meter and i.id_zone = ind.id_zone and i.kind_energy = ind.kind_energy and i.num_eqp = ind.num_eqp)
	 join acm_headindication_tbl as h on (ind.id_doc = h.id_doc)  
         where ind.dat_ind <= w.dt_work and h.idk_document in (310,345)
         group by i.id order by i.id
       ) as mi
       where mi.id = clm_work_indications_tbl.id
and clm_work_indications_tbl.id_meter = ind.id_meter and clm_work_indications_tbl.id_zone = ind.id_zone and clm_work_indications_tbl.kind_energy = ind.kind_energy 
and clm_work_indications_tbl.num_eqp = ind.num_eqp
and ind.dat_ind = mi.max_ind
and clm_work_indications_tbl.id_indic is null;
*/
-----------------------------------------