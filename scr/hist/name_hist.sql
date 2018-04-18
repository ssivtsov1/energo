update eqm_equipment_h set name_eqp = eq.name_eqp  from eqm_equipment_tbl as eq where eq.id = eqm_equipment_h.id 
and eqm_equipment_h.dt_e is null;
update eqm_point_h set day_control = eq.day_control  from eqm_point_tbl as eq where eq.code_eqp = eqm_point_h.code_eqp 
and eqm_point_h.dt_e is null;
update eqm_borders_h set id_doc = eq.id_doc  from eqm_borders_tbl as eq where eq.code_eqp = eqm_borders_h.code_eqp 
and eqm_borders_h.dt_e is null;