select crt_ttbl();
select rep_lighting_dubl_fun();



CREATE TABLE eqm_ground_tbl
(
  code_eqp integer NOT NULL,
  id_department integer DEFAULT syi_resid_fun(),
  power numeric(14,3),
  wtm integer,
  PRIMARY KEY (code_eqp)
) ;


CREATE TABLE eqm_ground_h
(
  code_eqp integer NOT NULL,
  id_department integer DEFAULT syi_resid_fun(),
  power numeric(14,3),
  wtm integer,

  dt_b date NOT NULL,
  dt_e date,
  mmgg date DEFAULT fun_mmgg(),
  dt timestamp without time zone DEFAULT now(),
  id_user integer DEFAULT getsysvar('last_user'::character varying),

  PRIMARY KEY (code_eqp, dt_b)
) ;


insert into eqm_ground_h (code_eqp,dt_b)
select id, min(dt_b) from eqm_equipment_h 
where type_eqp = 11
and not exists (select code_eqp from eqm_ground_h as h2 where h2.code_eqp =eqm_equipment_h.id)
group by id;


update eqm_ground_h set power = ss.power
from (select ins.code_eqp_inst, sum(p.power) as power
    from eqm_point_tbl as p
    join eqm_compens_station_inst_tbl as ins on (p.code_eqp = ins.code_eqp) 
    left join rep_lighting_points_tmp as lp on (lp.id_point = p.code_eqp) 
where coalesce(p.reserv,0)=0 and lp.id_point is null
group by ins.code_eqp_inst) as ss
where eqm_ground_h.power is null
and ss.code_eqp_inst = eqm_ground_h.code_eqp;


update eqm_ground_h set wtm = ss.wtm
from (select ins.code_eqp_inst, min(p.wtm) as wtm
    from eqm_point_tbl as p
    join eqm_compens_station_inst_tbl as ins on (p.code_eqp = ins.code_eqp) 
where coalesce(p.reserv,0)=0 
group by ins.code_eqp_inst) as ss
where eqm_ground_h.wtm is null
and ss.code_eqp_inst = eqm_ground_h.code_eqp;


UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_ground_tbl';

insert into eqm_ground_tbl(code_eqp,power,wtm)
select code_eqp,power,wtm from eqm_ground_h where dt_e is null
and not exists (select code_eqp from eqm_ground_tbl as g2 where g2.code_eqp = eqm_ground_h.code_eqp );


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_ground_tbl';


insert into syi_table_tbl (id, name, note,tbl_owner,id_task,act)
values(574,'eqm_ground_tbl','Площадки','ded',12,0);

insert into syi_table_tbl (id, name, note,tbl_owner,id_task,act)
values(575,'eqm_ground_h','история площадок','ded',12,0);

update eqi_device_kinds_tbl set id_table=574
where id = 11;	

insert into eqi_device_kinds_prop_tbl(type_eqp,form_name)
values(11,'TfGroundDet');
