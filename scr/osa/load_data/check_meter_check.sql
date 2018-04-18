select crt_ttbl();

select calc_client(1155,'2014-07-01')

select * from eqm_eqp_tree_h h1  eqm_eqp_tree_h h2 on   h2.id_tree=h1.id_tree where h1.dt_e>='2014-03-20' and h2

select * from clm_switching_tbl  where dt_action>='2014-06-01' and action=4

select c.id, c.short_name, c.code,m.code_eqp, m.id_type_eqp, eq.name_eqp, eq.num_eqp, im.type,im.term_control,im.carry,m.dt_control,
 CASE WHEN dt_control is not null THEN dt_control + (text(im.term_control)||' year')::interval ELSE NULL END as newcontrol,
 hm.dt_b as dt_ch, sc.phone,cp.represent_name from eqm_tree_tbl as tr join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) 
 join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) join eqm_meter_tbl as m on (m.code_eqp = eq.id) join eqm_meter_point_h as mp 
on (mp.id_meter = eq.id and dt_e is null)
 join eqm_point_tbl as pp on (mp.id_point = pp.code_eqp) 
 join eqi_meter_tbl as im on (im.id = m.id_type_eqp) left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id) 
left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))
  left join clm_statecl_h as sc on (c.id = sc.id_client) left join clm_position_tbl as cp on (coalesce(pp.id_position,sc.id_position)=cp.id)
 left join eqm_equipment_h as hm on (hm.id = eq.id) 
 where hm.dt_b = (select dt_b from eqm_equipment_h where id = eq.id and num_eqp = eq.num_eqp order by dt_b ASC limit 1 )
  and sc.mmgg_b = (select max(mmgg_b) from clm_statecl_h as sc2 where sc2.id_client = sc.id_client 
 and sc2.mmgg_b <= date_trunc('month', '2014-06-01'::date ) ) 
 and dt_control is not null and (dt_control + (text(im.term_control)||' year')::interval) between '2014-04-30' and '2014-06-30' 
 and c.idk_work not in (0,99)
 and coalesce(c.id_state,0) not in (50,99) and coalesce(pp.disabled,0) =0 order by c.code, eq.num_eqp;


select ssss.*, case when ssss.id_voltage in (1,2) and ssss.type_eqp = 8 then ssss.code_eqp when ssss.id_voltage2 in (1,2) and type_eqp2 = 8 then code_eqp2 when ssss.id_voltage3 in (1,2) and type_eqp3 = 8 then code_eqp3 when ssss.id_voltage4 in (1,2) and type_eqp4 = 8 then code_eqp4 END as code_ps35, 
case when ssss.id_voltage in (1,2) and ssss.type_eqp = 8 then grpname when ssss.id_voltage2 in (1,2) and type_eqp2 = 8 then grpname2 when ssss.id_voltage3 in (1,2) and type_eqp3 = 8 then grpname3 when ssss.id_voltage4 in (1,2) and type_eqp4 = 8 then grpname4 END as name_ps35, 
case when ssss.id_voltage in (3,31,32) and ssss.type_eqp = 15 then ssss.code_eqp when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 15 then code_eqp4 END as code_f10, 
case when ssss.id_voltage in (3,31,32) and ssss.type_eqp = 15 then grpname when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 15 then grpname2 when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 15 then grpname3 when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 15 then grpname4 END as name_f10, 
case when ssss.id_voltage in (3,31,32) and ssss.type_eqp = 8 then ssss.code_eqp when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 8 then code_eqp2 when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 8 then code_eqp3 when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 8 then code_eqp4 END as code_ps10,
 case when ssss.id_voltage in (3,31,32) and ssss.type_eqp = 8 then grpname when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 8 then grpname2 when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 8 then grpname3 when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 8 then grpname4 END as name_ps10
 from ( select sss.*, ee.name_eqp as grpname , gr1.type_eqp, gr1.code_eqp, gr1.id_voltage , gr2.type_eqp as type_eqp2, gr2.code_eqp as code_eqp2, gr2.id_voltage as id_voltage2, gr3.type_eqp as type_eqp3, gr3.code_eqp as code_eqp3, gr3.id_voltage as id_voltage3, gr4.type_eqp as type_eqp4,
        gr4.code_eqp as code_eqp4, gr4.id_voltage as id_voltage4, ee2.name_eqp as grpname2,ee3.name_eqp as grpname3,ee4.name_eqp as grpname4 
          from ( select c.id, c.short_name, c.name,c.code,c.action , m.id_type_eqp, eq.name_eqp, eq.num_eqp, im.type,im.term_control,im.carry,m.dt_control, 
                      CASE WHEN dt_control is not null THEN dt_control + (text(im.term_control)||' year')::interval ELSE NULL END as newcontrol, 
                          hm.dt_b as dt_ch, sc.phone,cp.represent_name , adr.adr , adr_c.adr as adr_abon, phones.pos_phones, town.name as city , 
                                 CASE WHEN im.phase =1 then 1 WHEN im.phase =2 then 3 END as phase , 
                                    rq.dt_work, rq.requirement_text, rq.requirement_date, cla.name as groupname, 
                                       coalesce(koef_u,1)* coalesce(koef_i,1) as k_tr, id_grp as link
                         from eqm_tree_tbl as tr join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)
                           join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) 
                         join eqm_meter_tbl as m on (m.code_eqp = eq.id) join eqm_meter_point_h as mp on (mp.id_meter = eq.id and dt_e is null) 
                         join eqm_equipment_tbl as eq2 on (mp.id_point = eq2.id) 
                         join eqm_point_tbl as pp on (mp.id_point = pp.code_eqp) join eqi_meter_tbl as im on (im.id = m.id_type_eqp) 
         left join bal_abons_tbl as ba on (ba.id_point = mp.id_point) left join rep_lighting_points_tmp as lp on (lp.id_point = mp.id_point) 
           left join ( select CASE WHEN eq2.type_eqp = 1 THEN eq2.id WHEN eq3.type_eqp = 1 THEN eq3.id END as id_meter, ic.conversion , ic.type as tt_type,ic.accuracy,
            CASE WHEN coalesce(ic.amperage2_nom,0)=0 THEN 0 ELSE ic.amperage_nom/ic.amperage2_nom END as koef_i from eqm_compensator_i_tbl as c 
           join eqi_compensator_i_tbl as ic on (ic.id = c.id_type_eqp) left join eqm_eqp_tree_tbl as tt on (tt.code_eqp_e=c.code_eqp ) 
          left join eqm_eqp_tree_tbl as tt2 on (tt2.code_eqp_e=tt.code_eqp ) left join eqm_equipment_tbl as eq2 on (eq2.id =tt.code_eqp ) 
        left join eqm_equipment_tbl as eq3 on (eq3.id =tt2.code_eqp ) where ic.conversion = 1 order by id_meter ) as sti on (sti.id_meter = eq.id) 
        left join ( select CASE WHEN eq2.type_eqp = 1 THEN eq2.id WHEN eq3.type_eqp = 1 THEN eq3.id END as id_meter, ic.conversion , ic.type as tu_type,ic.accuracy,
 CASE WHEN coalesce(ic.voltage2_nom,0)=0 THEN 0 ELSE ic.voltage_nom/ic.voltage2_nom END as koef_u from eqm_compensator_i_tbl as c join eqi_compensator_i_tbl as ic on (ic.id = c.id_type_eqp) 
left join eqm_eqp_tree_tbl as tt on (tt.code_eqp_e=c.code_eqp ) left join eqm_eqp_tree_tbl as tt2 on (tt2.code_eqp_e=tt.code_eqp )
 left join eqm_equipment_tbl as eq2 on (eq2.id =tt.code_eqp ) left join eqm_equipment_tbl as eq3 on (eq3.id =tt2.code_eqp ) where ic.conversion = 2 order by id_meter ) as stu on (stu.id_meter = eq.id)
 left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id) 
 left join 
 (select c.*,sw.action from clm_client_tbl c,clm_switching_tbl sw where c.id=sw.id_client and dt_action>='2014-06-01' and action=4
  ) as c on (c.id = coalesce (use.id_client, tr.id_client))
 left join clm_statecl_h as sc on (c.id = sc.id_client) left join clm_position_tbl as cp on (coalesce(pp.id_position,sc.id_position)=cp.id) 
 left join eqm_equipment_h as hm on (hm.id = eq.id) left join adv_address_tbl as adr on (adr.id = eq2.id_addres)
  left join cla_param_tbl as cla on (sc.id_section = cla.id) left join (select id_client, sum(','||phone) as pos_phones from clm_position_tbl where coalesce(phone,'')<>'' group by id_client ) as phones on (c.id = phones.id_client) 
 left join adv_address_tbl as adr_c on (adr_c.id = c.id_addres) left join adi_town_tbl as town on (town.id = adr_c.id_town) 
left join ( select w.id , w.id_point, w.dt_work, w.requirement_text, w.requirement_date from clm_works_tbl as w 
join (select id_point, max(dt_work) as dt_work from clm_works_tbl where id_type = 8 and requirement_ok_date is null group by id_point ) as ww on (w.id_point = ww.id_point and w.dt_work = ww.dt_work ) 
 where id_type = 8 and requirement_ok_date is null and w.dt_work >= '2013-01-01'::date) as rq on (rq.id_point = mp.id_point) where hm.dt_b = (select dt_b from eqm_equipment_h where id = eq.id and num_eqp = eq.num_eqp order by dt_b ASC limit 1 )
 and sc.mmgg_b = (select max(mmgg_b) from clm_statecl_h as sc2 where sc2.id_client = sc.id_client and sc2.mmgg_b <= date_trunc('month', '2014-06-30 09:45:28'::date ) )
  and dt_control is not null and (dt_control + (text(im.term_control)||' year')::interval) <= '2014-06-30 09:45:28' and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) and lp.id_point is null and coalesce(pp.disabled,0) =0 )as sss left join eqm_equipment_tbl as ee on (ee.id = link) left join bal_grp_tree_tbl as gr1 on (gr1.code_eqp = sss.link and gr1.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) left join bal_grp_tree_tbl as gr4 on (gr3.id_p_eqp = gr4.code_eqp and gr4.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) left join eqm_equipment_tbl as ee4 on (ee4.id = gr4.code_eqp) ) as ssss order by code,num_eqp 
