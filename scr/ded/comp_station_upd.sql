ALTER TABLE eqm_compens_station_tbl drop COLUMN h_boxes ;
ALTER TABLE eqm_compens_station_tbl drop COLUMN l_boxes ;
ALTER TABLE eqm_compens_station_tbl drop COLUMN h_points;
ALTER TABLE eqm_compens_station_tbl drop COLUMN l_points;

ALTER TABLE eqm_compens_station_h drop COLUMN h_boxes ;
ALTER TABLE eqm_compens_station_h drop COLUMN l_boxes ;
ALTER TABLE eqm_compens_station_h drop COLUMN h_points;
ALTER TABLE eqm_compens_station_h drop COLUMN l_points;


ALTER TABLE eqm_compens_station_tbl ADD COLUMN power numeric(14,3);
ALTER TABLE eqm_compens_station_h ADD COLUMN power numeric(14,3);

ALTER TABLE eqm_compens_station_tbl ADD COLUMN comp_cnt int;
ALTER TABLE eqm_compens_station_h ADD COLUMN comp_cnt int;

ALTER TABLE eqm_compens_station_tbl ADD COLUMN id_type1 int;
ALTER TABLE eqm_compens_station_tbl ADD COLUMN id_type2 int;
ALTER TABLE eqm_compens_station_tbl ADD COLUMN id_type3 int;
ALTER TABLE eqm_compens_station_tbl ADD COLUMN id_type4 int;


ALTER TABLE eqm_compens_station_h ADD COLUMN id_type1 int;
ALTER TABLE eqm_compens_station_h ADD COLUMN id_type2 int;
ALTER TABLE eqm_compens_station_h ADD COLUMN id_type3 int;
ALTER TABLE eqm_compens_station_h ADD COLUMN id_type4 int;

ALTER TABLE eqm_compens_station_tbl ADD COLUMN p_regday numeric(14,3);
ALTER TABLE eqm_compens_station_h   ADD COLUMN p_regday numeric(14,3);

ALTER TABLE eqm_compens_station_tbl ADD COLUMN date_regday date;
ALTER TABLE eqm_compens_station_h   ADD COLUMN date_regday date;


ALTER TABLE eqm_compens_station_tbl DISABLE TRIGGER user;

update eqm_compens_station_tbl set power =s.ps_power, comp_cnt = s.tr_cnt
from (
 select a.code_eqp, 
    sum(eqi.power_nom::numeric) as ps_power, 
    count (distinct c.code_eqp) as tr_cnt
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    group by a.code_eqp
) as s where s.code_eqp = eqm_compens_station_tbl.code_eqp and eqm_compens_station_tbl.power is null;


update eqm_compens_station_h set power =s.ps_power, comp_cnt = s.tr_cnt
from (
 select a.code_eqp, 
    sum(eqi.power_nom::numeric) as ps_power, 
    count (distinct c.code_eqp) as tr_cnt
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    group by a.code_eqp
) as s where s.code_eqp = eqm_compens_station_h.code_eqp and eqm_compens_station_h.power is null;


update eqm_compens_station_tbl set id_type1 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_tbl.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 0)
    where id_type1 is null;

update eqm_compens_station_tbl set id_type2 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_tbl.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 1) where comp_cnt >1 and id_type2 is null;

update eqm_compens_station_tbl set id_type3 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_tbl.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 2) where comp_cnt >2 and id_type3 is null;

update eqm_compens_station_tbl set id_type4 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_tbl.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 3) where comp_cnt >3 and id_type4 is null;

update eqm_compens_station_h set id_type1 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_h.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 0)
    where id_type1 is null;

update eqm_compens_station_h set id_type2 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_h.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 1) where comp_cnt >1 and id_type2 is null;

update eqm_compens_station_h set id_type3 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_h.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 2) where comp_cnt >2 and id_type3 is null;

update eqm_compens_station_h set id_type4 = (
 select eqi.id
    from eqm_area_tbl as a 
    join eqm_compens_station_inst_tbl as ins on (a.code_eqp = ins.code_eqp_inst) 
    join eqm_compensator_tbl as c on (c.code_eqp = ins.code_eqp) 
    join eqm_equipment_tbl as eq on (eq.id = a.code_eqp ) 
    join eqi_compensator_tbl as eqi on (eqi.id = c.id_type_eqp) 
    where eq.type_eqp=8 
    and a.code_eqp = eqm_compens_station_h.code_eqp
    order by eq.name_eqp, eq.id limit 1 offset 3) where comp_cnt >3 and id_type4 is null;

ALTER TABLE eqm_compens_station_tbl ENABLE TRIGGER user;