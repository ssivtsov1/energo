DROP VIEW rel_ktp_v;
DROP VIEW rel_line_v;
DROP VIEW eqv_meterfiz;
DROP VIEW eqv_meter;
DROP VIEW eqv_meter_tbl;

drop view eqv_pnt_met;

select altr_colmn('eqm_equipment_tbl','name_eqp', 'varchar(50)');
select altr_colmn('eqm_equipment_h','name_eqp', 'varchar(50)');


CREATE OR REPLACE VIEW eqv_meter_tbl AS 

 SELECT tr.id_client, et.code_eqp, equ.num_eqp, max(equ.dt_change, equ.dt_install ) AS dt_inst_change, equ.name_eqp, equ.id_addres, met.nm, met.main_duble 
   FROM eqm_tree_tbl tr, eqm_eqp_tree_tbl et, eqm_equipment_tbl equ, eqm_meter_tbl met 
  WHERE (((tr.id = et.id_tree ) AND (equ.id = et.code_eqp )) AND (equ.id = met.code_eqp )); 


CREATE OR REPLACE VIEW eqv_meter AS 
((
 SELECT tr.id_client, et.code_eqp, equ.num_eqp, equ.name_eqp, equ.id_addres, met.nm, met.main_duble 
   FROM eqm_tree_tbl tr, eqm_eqp_tree_tbl et, eqm_equipment_tbl equ, eqm_meter_tbl met 
  WHERE (((tr.id = et.id_tree ) AND (equ.id = et.code_eqp )) AND (equ.id = met.code_eqp ))) 
UNION
(
 SELECT us.id_client, us.code_eqp, equ.num_eqp, equ.name_eqp, equ.id_addres, met.nm, met.main_duble 
   FROM eqm_eqp_use_tbl us, eqm_equipment_tbl equ, eqm_meter_tbl met 
  WHERE ((equ.id = us.code_eqp ) AND (equ.id = met.code_eqp )))); 



CREATE OR REPLACE VIEW eqv_pnt_met AS 

 SELECT e.id_client, e.id AS id_point, e.name_eqp AS name_point, met.id_meter, met.num_eqp, met."type" AS type_met, met.carry AS carry_met, 
        CASE 
            WHEN (t1."conversion" = 1 ) THEN t1.code_eqp 
            ELSE 
            CASE 
                WHEN (t2."conversion" = 1 ) THEN t2.code_eqp 
                ELSE NULL::integer 
            END  
        END  AS code_tt, 
        CASE 
            WHEN (t1."conversion" = 1 ) THEN t1.name_eqp 
            ELSE 
            CASE 
                WHEN (t2."conversion" = 1 ) THEN t2.name_eqp 
                ELSE NULL::character varying 
            END  
        END  AS name_tt, 
        CASE 
            WHEN (t1."conversion" = 1 ) THEN t1."type" 
            ELSE 
            CASE 
                WHEN (t2."conversion" = 1 ) THEN t2."type" 
                ELSE NULL::character varying 
            END  
        END  AS type_tt, 
        CASE 
            WHEN (t1."conversion" = 1 ) THEN 
            CASE 
                WHEN (t1.amperage2_nom <> 0 ) THEN (t1.amperage_nom / t1.amperage2_nom ) 
                ELSE 1 
            END  
            ELSE 
            CASE 
                WHEN (t2.amperage2_nom <> 0 ) THEN (t2.amperage_nom / t2.amperage2_nom ) 
                ELSE 1 
            END  
        END  AS koef_tt, 
        CASE 
            WHEN (t2."conversion" = 2 ) THEN t2.code_eqp 
            ELSE 
            CASE 
                WHEN (t1."conversion" = 2 ) THEN t1.code_eqp 
                ELSE NULL::integer 
            END  
        END  AS code_tu, 
        CASE 
            WHEN (t2."conversion" = 2 ) THEN t2.name_eqp 
            ELSE 
            CASE 
                WHEN (t1."conversion" = 2 ) THEN t1.name_eqp 
                ELSE NULL::character varying 
            END  
        END  AS name_tu, 
        CASE 
            WHEN (t2."conversion" = 2 ) THEN t2."type" 
            ELSE 
            CASE 
                WHEN (t1."conversion" = 2 ) THEN t1."type" 
                ELSE NULL::character varying 
            END  
        END  AS type_tu, 
        CASE 
            WHEN (t2."conversion" = 2 ) THEN 
            CASE 
                WHEN (t2.voltage2_nom <> (0 )::numeric) THEN round((t2.voltage_nom / t2.voltage2_nom ), 0 ) 
                ELSE (1 )::numeric 
            END  
            ELSE 
            CASE 
                WHEN (t1.voltage2_nom <> (0 )::numeric) THEN round((t1.voltage_nom / t1.voltage2_nom ), 0 ) 
                ELSE (1 )::numeric 
            END  
        END  AS koef_tu 
   FROM ((((
         SELECT e.id, e.type_eqp, e.name_eqp, e.num_eqp, e.id_addres, e.dt_install, e.dt_change, e.loss_power, e.id_department, e.id_client 
           FROM (((
                 SELECT e.id, e.type_eqp, e.name_eqp, e.num_eqp, e.id_addres, e.dt_install, e.dt_change, e.loss_power, e.id_department, et.id_client 
                   FROM (
                         SELECT eqm_equipment_tbl.id, eqm_equipment_tbl.type_eqp, eqm_equipment_tbl.name_eqp, eqm_equipment_tbl.num_eqp, eqm_equipment_tbl.id_addres, eqm_equipment_tbl.dt_install, eqm_equipment_tbl.dt_change, eqm_equipment_tbl.loss_power, eqm_equipment_tbl.id_department 
                           FROM eqm_equipment_tbl 
                          WHERE (eqm_equipment_tbl.type_eqp = 12 )) e, (
                                 SELECT e.id_tree, e.id_department, e.code_eqp, e.code_eqp_e, e.name, e.tranzit, e.lvl, e.parents, e.line_no, et.id_client 
                                   FROM eqm_eqp_tree_tbl e, eqm_tree_tbl et 
                                  WHERE (et.id = e.id_tree )) et 
                                  WHERE (e.id = et.code_eqp )) 
UNION
(
 SELECT e.id, e.type_eqp, e.name_eqp, e.num_eqp, e.id_addres, e.dt_install, e.dt_change, e.loss_power, e.id_department, et.id_client 
   FROM (
         SELECT eqm_equipment_tbl.id, eqm_equipment_tbl.type_eqp, eqm_equipment_tbl.name_eqp, eqm_equipment_tbl.num_eqp, eqm_equipment_tbl.id_addres, eqm_equipment_tbl.dt_install, eqm_equipment_tbl.dt_change, eqm_equipment_tbl.loss_power, eqm_equipment_tbl.id_department 
           FROM eqm_equipment_tbl 
          WHERE (eqm_equipment_tbl.type_eqp = 12 )) e, eqm_eqp_use_tbl et 
          WHERE (e.id = et.code_eqp )))) e ) e 
           LEFT JOIN  (
                      SELECT mp.id_point, mp.id_meter, mp.dt_b, mp.dt_e, e.num_eqp, m.id_type_eqp, mi."type", mi.carry 
                        FROM (
                              SELECT eqm_meter_point_h.id_point, eqm_meter_point_h.id_meter, eqm_meter_point_h.dt_b, eqm_meter_point_h.dt_e 
                                FROM eqm_meter_point_h 
                               WHERE (((eqm_meter_point_h.dt_b )::timestamp with time zone <= now( )) AND (
                                     CASE 
                                         WHEN (eqm_meter_point_h.dt_e IS NOT NULL ) THEN (eqm_meter_point_h.dt_e )::timestamp with time zone 
                                         WHEN (now( ) IS NOT NULL ) THEN now( ) 
                                         ELSE NULL::timestamp with time zone 
                                     END  >= now( )))) mp, (
                                      SELECT eqm_equipment_h.id, eqm_equipment_h.type_eqp, eqm_equipment_h.name_eqp, eqm_equipment_h.num_eqp, eqm_equipment_h.id_addres, eqm_equipment_h.dt_install, eqm_equipment_h.dt_change, eqm_equipment_h.loss_power, eqm_equipment_h.id_department, eqm_equipment_h.dt_b, eqm_equipment_h.dt_e, eqm_equipment_h.mmgg, eqm_equipment_h.dt 
                                        FROM eqm_equipment_h 
                                       WHERE (((eqm_equipment_h.dt_b )::timestamp with time zone <= now( )) AND (
                                             CASE 
                                                 WHEN (eqm_equipment_h.dt_e IS NOT NULL ) THEN (eqm_equipment_h.dt_e )::timestamp with time zone 
                                                 WHEN (now( ) IS NOT NULL ) THEN now( ) 
                                                 ELSE NULL::timestamp with time zone 
                                             END  >= now( )))) e, (
                                              SELECT eqm_meter_h.code_eqp, eqm_meter_h.id_department, eqm_meter_h.id_type_eqp, eqm_meter_h.dt_control, eqm_meter_h.d, eqm_meter_h.nm, eqm_meter_h.account, eqm_meter_h.main_duble, eqm_meter_h."class", eqm_meter_h.code_group, eqm_meter_h.count_lost, eqm_meter_h.warm, eqm_meter_h.industry, eqm_meter_h.count_met, eqm_meter_h.met_comment, eqm_meter_h.dt_b, eqm_meter_h.dt_e, eqm_meter_h.mmgg, eqm_meter_h.dt, eqm_meter_h.warm_comment 
                                                FROM eqm_meter_h 
                                               WHERE (((eqm_meter_h.dt_b )::timestamp with time zone <= now( )) AND (
                                                     CASE 
                                                         WHEN (eqm_meter_h.dt_e IS NOT NULL ) THEN (eqm_meter_h.dt_e )::timestamp with time zone 
                                                         WHEN (now( ) IS NOT NULL ) THEN now( ) 
                                                         ELSE NULL::timestamp with time zone 
                                                     END  >= now( )))) m, eqi_meter_tbl mi 
                                               WHERE (((e.id = mp.id_meter ) AND (m.code_eqp = mp.id_meter )) AND (mi.id = m.id_type_eqp )) 
                                               ORDER BY mp.id_point ) met  ON ((met.id_point = e.id ))) 
                                           LEFT JOIN  (
                                                      SELECT t.id_tree, t.id_department, t.code_eqp, t.code_eqp_e, t.name, t.tranzit, t.lvl, t.parents, t.line_no, e.id, e.type_eqp, e.name_eqp, e.num_eqp, e.id_addres, e.dt_install, e.dt_change, e.loss_power, e.id_department, ei."type", ei."conversion", ei.voltage_nom, ei.voltage2_nom, ei.amperage_nom, ei.amperage2_nom 
                                                        FROM eqm_eqp_tree_tbl t, eqm_equipment_tbl e, eqm_compensator_i_tbl ec, eqi_compensator_i_tbl ei 
                                                       WHERE ((((t.code_eqp = e.id ) AND (e.type_eqp = 10 )) AND (e.id = ec.code_eqp )) AND (ec.id_type_eqp = ei.id ))) t1  ON ((t1.code_eqp_e = e.id ))) 
                                                   LEFT JOIN  (
                                                              SELECT t.id_tree, t.id_department, t.code_eqp, t.code_eqp_e, t.name, t.tranzit, t.lvl, t.parents, t.line_no, e.id, e.type_eqp, e.name_eqp, e.num_eqp, e.id_addres, e.dt_install, e.dt_change, e.loss_power, e.id_department, ei."type", ei."conversion", ei.voltage_nom, ei.voltage2_nom, ei.amperage_nom, ei.amperage2_nom 
                                                                FROM eqm_eqp_tree_tbl t, eqm_equipment_tbl e, eqm_compensator_i_tbl ec, eqi_compensator_i_tbl ei 
                                                               WHERE ((((t.code_eqp = e.id ) AND (e.type_eqp = 10 )) AND (e.id = ec.code_eqp )) AND (ec.id_type_eqp = ei.id ))) t2  ON ((t2.code_eqp_e = t1.code_eqp ))); 




create or replace function build_ins_fun() returns int as'
declare 
  fl_ins int;
  buildr record;
  exist_eqp  record;
begin
------------------------------
select into fl_ins eqt_change_fun(2,null,null,null,null,0);

-- new  
delete from adi_build_tbl where id is null;
 for  buildr in select * from adi_build_tbl loop
 raise notice ''%  %  %  '',buildr.id,buildr.name,buildr.num_gek;
 fl_ins=1;
if buildr.id>999999999 then
 raise notice '' Large number GEK %  %  %  '',buildr.id,buildr.name,buildr.num_gek;
 continue;
end if;

  for exist_eqp in select id from eqm_equipment_tbl where id=buildr.id loop 
    fl_ins=0;
  end loop;
  -- raise notice ''fl_ins %  exist_eqp %  buildr.id %  '',fl_ins,exist_eqp,buildr.id;
  if fl_ins=1 then
     raise notice '' 22    %  %  %  '',buildr.id,buildr.name,buildr.num_gek;
    insert into eqm_equipment_tbl(id,type_eqp,name_eqp, num_eqp,
         id_addres,dt_install,dt_change,loss_power) 
       values (buildr.id,17,substr(buildr.name,1,50),buildr.num_gek,
       null,''2009-01-01'',null,0);
   else
     update eqm_equipment_tbl
     set name_eqp=substr(buildr.name,1,50),num_eqp=buildr.num_gek,
        dt_change=now()
	where id=buildr.id;
   end if;
 end loop;
 Return 1;
end; 
' LANGUAGE 'plpgsql';

select  distinct * into temp tmp_adi_build from adi_build_tbl;
delete from adi_build_tbl;
insert into adi_build_tbl select * from  tmp_adi_build;
delete from adi_build_tbl where  id in (select id from (select id,count(*) from adi_build_tbl group by id having count(*)>1) a );
delete from adi_build_tbl where id is null;
CREATE UNIQUE INDEX adi_build_ind1 ON adi_build_tbl (id);


select crt_ttbl();
select build_ins_fun()
;