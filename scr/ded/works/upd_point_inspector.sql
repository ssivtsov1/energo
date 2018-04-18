UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_point_tbl';

update eqm_point_tbl set id_position= null
where id_position not in (select id from clm_position_tbl);

update eqm_point_h set id_position= null
where id_position not in (select id from clm_position_tbl);


update eqm_point_tbl set id_position  = f.id_position
from bal_grp_tree_tbl as gr1
left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = gr2.code_eqp)) 
left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = gr3.code_eqp)) 
left join eqm_fider_tbl as f on ( case when gr2.id_voltage =3 and gr2.type_eqp = 15 then gr2.code_eqp 
                                  when gr3.id_voltage =3 and gr3.type_eqp = 15 then gr3.code_eqp end  = f.code_eqp)
where gr1.code_eqp = eqm_point_tbl.code_eqp and gr1.mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = gr1.code_eqp)
and eqm_point_tbl.id_position is null and f.id_position is not null;


update eqm_point_h set id_position  = f.id_position
from bal_grp_tree_tbl as gr1
left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = gr2.code_eqp)) 
left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = gr3.code_eqp)) 
left join eqm_fider_tbl as f on ( case when gr2.id_voltage =3 and gr2.type_eqp = 15 then gr2.code_eqp 
                                  when gr3.id_voltage =3 and gr3.type_eqp = 15 then gr3.code_eqp end  = f.code_eqp)
where gr1.code_eqp = eqm_point_h.code_eqp and gr1.mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = gr1.code_eqp)
and eqm_point_h.id_position is null and f.id_position is not null;


update eqm_point_h set id_position  = f.id_position
from 
( select * from bal_grp_tree_tbl as bg1 where mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = bg1.code_eqp ) and id_voltage =3 and type_eqp = 15 ) as ff
left join
( select * from bal_grp_tree_tbl as bg2  where mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = bg2.code_eqp) and id_voltage =3 and type_eqp = 8 ) as ss on (ss.id_p_eqp = ff.code_eqp)
join bal_abons_tbl as ba on (ba.id_grp = ff.code_eqp or ba.id_grp = ss.code_eqp)
join eqm_fider_tbl as f on (f.code_eqp = ff.code_eqp)
where ba.id_point = eqm_point_h.code_eqp 
and eqm_point_h.id_position is null and f.id_position is not null;


update eqm_point_tbl set id_position  = f.id_position
from 
( select * from bal_grp_tree_tbl as bg1 where mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = bg1.code_eqp ) and id_voltage =3 and type_eqp = 15 ) as ff
left join
( select * from bal_grp_tree_tbl as bg2  where mmgg= (select max(mmgg) from bal_grp_tree_tbl where code_eqp = bg2.code_eqp ) and id_voltage =3 and type_eqp = 8 ) as ss on (ss.id_p_eqp = ff.code_eqp)
join bal_abons_tbl as ba on (ba.id_grp = ff.code_eqp or ba.id_grp = ss.code_eqp)
join eqm_fider_tbl as f on (f.code_eqp = ff.code_eqp)
where ba.id_point = eqm_point_tbl.code_eqp 
and eqm_point_tbl.id_position is null and f.id_position is not null;


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_point_tbl';

