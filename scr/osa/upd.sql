    select crt_ttbl(); 

    select eqt_change_fun( 1, 18732, '2006-09-01', 1, NULL, 1);    

    update eqm_equipment_tbl set loss_power = 1 
    from eqm_tree_tbl as tr
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)
    join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id)

    where ttr.id_tree = 18732 and eq.type_eqp in (6,7,2)
    and eqm_equipment_tbl.id = eq.id
