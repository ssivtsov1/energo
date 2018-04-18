drop view eqv_pnt_met cascade;

CREATE VIEW eqv_pnt_met (id_client,id_point,name_point,id_meter,num_eqp,type_met,carry_met,
    code_tt,name_tt,type_tt,koef_tt,code_tu,name_tu,type_tu,koef_tu)
AS
select e.id_client,e.id,e.name_eqp as name_point,met.id_meter,met.num_eqp,met.type,met.carry, 
   case when t1.conversion=1  then   t1.code_eqp else case when t2.conversion=1  then t2.code_eqp else NULL end end as code_tt ,
    case when t1.conversion=1  then  t1.name_eqp else case when t2.conversion=1  then t2.name_eqp else NULL end end as name_tt,
    case when t1.conversion=1  then  t1.type else case when t2.conversion=1  then  t2.type else NULL end end as type_tt,
    case when t1.conversion=1  then case when t1.amperage2_nom<>0 then t1.amperage_nom/t1.amperage2_nom else 1 end
                               else  case when t2.amperage2_nom<>0 then t2.amperage_nom/t2.amperage2_nom else 1 end
     end as koef_tt,   
   case when t2.conversion=2 then  t2.code_eqp else case when t1.conversion=2  then  t1.code_eqp  else NULL end end as code_tu ,
    case when t2.conversion=2 then  t2.name_eqp else  case when t1.conversion=2  then  t1.name_eqp   else NULL end end as name_tu,
    case when t2.conversion=2 then  t2.type else case when t1.conversion=2  then  t1.type  else NULL end  end as type_tu,
    case when t2.conversion=2 then case when t2.voltage2_nom<>0 then round(t2.voltage_nom/t2.voltage2_nom ,0) else 1 end
                               else  case when t1.voltage2_nom<>0 then round(t1.voltage_nom/t1.voltage2_nom,0) else 1 end
     end as koef_tu
 from 
(
  select * from                                                                                                                  
    ((select e.*,et.id_client from                                                                                               
       (select * from eqm_equipment_tbl where type_eqp in (12)) as e,                                                            
         ( select e.*,et.id_client from eqm_eqp_tree_tbl e,                                                                      
                 eqm_tree_tbl   et                                                                                                           
           where et.id=e.id_tree                                                                                                 
          ) et where e.id=et.code_eqp                                                                                            
        )                                                                                                                        
        union                                                                                                                    
       (select e.*,et.id_client from                                                                                             
          (select * from eqm_equipment_tbl where type_eqp in (12) ) as e,                                                        
           eqm_eqp_use_tbl  et                                                                                                               
            where e.id=et.code_eqp                                                                                               
           )                                                                                                                     
       ) as e 
) e
left join ( select mp.*,e.num_eqp,m.id_type_eqp,mi.type,mi.carry  
             from ( select * from eqm_meter_point_h where dt_b<=now() and coalesce(dt_e,now())>=now()) mp,
                   (  select * from eqm_equipment_h where dt_b<=now() and coalesce(dt_e,now())>=now()) e,
                 (  select * from eqm_meter_h where dt_b<=now() and coalesce(dt_e,now())>=now()) m,
                  eqi_meter_tbl mi 
             where  e.id=mp.id_meter and  m.code_eqp=mp.id_meter and mi.id=m.id_type_eqp         
            order by mp.id_point ) met on met.id_point=e.id
left join (select t.*,e.*,ei.type,ei.conversion,ei.voltage_nom,ei.voltage2_nom,ei.amperage_nom,ei.amperage2_nom 
from eqm_eqp_tree_tbl t,eqm_equipment_tbl e,eqm_compensator_i_tbl ec, eqi_compensator_i_tbl ei
             where t.code_eqp=e.id and e.type_eqp=10 and e.id=ec.code_eqp and ec.id_type_eqp=ei.id ) t1 on t1.code_eqp_e=e.id
left join (select t.*,E.*,ei.type,ei.conversion,ei.voltage_nom,ei.voltage2_nom,ei.amperage_nom,ei.amperage2_nom 
            from eqm_eqp_tree_tbl t, eqm_equipment_tbl e ,eqm_compensator_i_tbl ec, eqi_compensator_i_tbl ei
          where t.code_eqp=e.id and e.type_eqp=10 and e.id=ec.code_eqp and ec.id_type_eqp=ei.id ) t2 on t2.code_eqp_e=t1.code_eqp
;



