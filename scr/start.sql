;
set client_encoding = 'koi8';
select set_version(304,304,'2018-01-05');
\i kat/tmptbl.sql
set client_encoding='win';
select close();  
set client_encoding = 'koi8';

--select crt_ttbl();                                                  
--select close();
;
============================================
;

\i cl_meter.sql

\i osa/f1.sql

\cd osa
\cd create_view
\i iv.sql
\cd ..
\cd ..


\cd osa
\cd seb
\i i_seb.sql
\cd ..
\cd ..


\i ded/regexp_replace.sql
\i ded/eqpuse.sql
--\i ded/point_meter2.sql
\i ded/findval.sql
\i ded/delete_dead_areas.sql
\i ded/seb_bill_del.sql
\i ded/load_l04.sql
--\i ded/keyabon.sql
--\i ded/line_voltage.sql
--\i ded/tablefields.sql
--\i ded/tree_select.sql
--\i ded/user_id.sql
--\i ded/ktr_numeric.sql
\i ded/meter_spr_dt.sql
\i ded/point_order.sql
\i ded/alter_point_br.sql
\i ded/abon_switch.sql
\i ded/fider.sql
\i ded/calend.sql
\i ded/sqltrig.sql
\i ded/sqlproc.sql
\i ded/id_res.sql
\i ded/limit_trg.sql
\i ded/copytree.sql
\i ded/copy_full.sql
\i ded/viewbuild.sql
\i ded/calc_voltage_p2.sql
\i ded/works/work_tables.sql
\i ded/works/grafic_works.sql
\i ded/comp_station_upd.sql
\i ded/index_new.sql
--\i ded/insertfiz.sql
\i ded/editfiz.sql
\i ded/fider_monitor.sql
\i ded/fider_monitor_plan.sql
\i ded/clear_garbage.sql

\i ded/ground.sql
\i ded/energo_cabinet.sql
--\i ded/add_spr/cable_p1.sql

\cd ded
\cd balans
\i i_bal.sql
\i border_rename.sql
\cd ..
\cd ..

\cd ded
\cd nalog
\i i_nn.sql
\cd ..
\cd ..

\cd ded
\cd koatu
\i i_koatu.sql
\cd ..
\cd ..

\cd ded
\cd reps
\i i_rep.sql
\cd ..
\cd ..

\i ded/tree/eqmt_upd.sql
\i ded/show_def.sql

\cd osa

\cd close
\i _i.sql
\cd ..

\cd bill_indic 
\i  _i.sql
\cd ..


\cd payments 
\i  _i.sql
\cd ..

\cd add 
\i  _i.sql
\cd ..

\cd load_data 
\i  _i.sql
\cd ..


\cd sys
\i i.sql
\cd ..


\cd .. 
;
============================================
;

select * from seb_tar_tmp;

--\cd yur
--\i s.sql
--\i clmc_ins.sql
--\cd ..


\cd kat
\i i.sql
\cd ..


update acd_zone_tbl set koef=1.02 where id=3 and id_zone=2 and koef=1.2;

\cd hist
\i i_ch.sql
\cd ..


update syi_sysvars_tbl set value_ident=1 where ident='eqp_log';

\i kat/kzl.sql
--\i pclient_gek.sql
--\i osa/for_meter.sql


select upd_point();

--select set_version( vers_scr, vers_exe,dt_scr)
  

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_eqp_tree_tbl';

delete from eqm_eqp_tree_tbl where id_tree not in (select id from eqm_tree_h);
delete from eqm_eqp_tree_h where id_tree not in (select id from eqm_tree_h);

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_eqp_tree_tbl';

--\i for_meter.sql;
update clm_client_tbl set book='898989' where code is null and name is null;
update syi_sysvars_tbl set value_ident=1 where ident='eqp_log';


/*
update eqk_zone_tbl set koef=0.4, dt_begin='2009-12-01' where id=4;
update eqk_zone_tbl set koef=1.5, dt_begin='2009-12-01' where id=5;
update eqk_zone_tbl set koef=0.35, dt_begin='2009-12-01' where id=1;
update eqk_zone_tbl set koef=1.02, dt_begin='2009-12-01' where id=2;
update eqk_zone_tbl set koef=1.68, dt_begin='2009-12-01' where id=3;



update acd_zone_tbl set hours=9 where id_zone in(4,9);
update acd_zone_tbl set hours=15 where id_zone in (5,10);

update acd_zone_tbl set hours=12 where id_zone  in (1,6);
update acd_zone_tbl set hours=7 where id_zone in (2,7);
update acd_zone_tbl set hours=5 where id_zone in (3,8);
*/

update aci_pref_tbl set in_acc=1 where id in (10,20,520);

select altr_colmn('eqi_cable_tbl','s_nom','numeric(12,2)');
--\i osa/eqm_equipment_name_50.sql
--\i osa/tarif_power.sql

update clm_statecl_tbl set dt_end_rent=null where dt_end_rent is not null;

update eqi_meter_energy_tbl set kind_energy=2 where id_type_eqp in (7171,7172,7173,7174) and kind_energy=3;
delete from  eqi_meter_energy_tbl where id_type_eqp in (7171,7172,7173,7174) and kind_energy=4;

update acm_bill_tbl set value=round(value,2),  value_tax=round(value_tax,2) where id_pref=520 and mmgg='2013-01-01'; 
delete from acm_bill_tbl  where id_pref=520 and (value =0 or value is null) and flock<>1; 
;;
111111111111111111111111111111 esli visit vignat, vseh is basi 
;;


--alter table clm_client_tbl alter column name type varchar(250);
--\i pt.dmp
--\i ti.dmp


ALTER TABLE acd_calc_losts_tbl
  ADD CONSTRAINT acd_calc_losts_tbl_pkey PRIMARY KEY(id_doc, id_point, id_eqp, dat_b, dat_e,kind_energy);

  ALTER TABLE acd_calc_losts_del DROP CONSTRAINT acd_calc_losts_del_pkey;

ALTER TABLE acd_calc_losts_del
  ADD CONSTRAINT acd_calc_losts_del_pkey PRIMARY KEY(id_doc, id_point, id_eqp, dat_b, dat_e,kind_energy);

alter table clm_client_tbl alter column dt set default now();

alter table clm_client_tbl alter column id_person   set DEFAULT getsysvar('id_person'::character varying);


create or replace function repl_add (date) returns int as
$BODY$
declare
pmg alias for $1;
rec record;

begin

for rec in select h.* from acm_headdem_tbl h,acm_demand_tbl d  where d.id_doc=h.id_doc and d.demand<0 and h.mmgg=pmg loop
 perform crt_addbill(rec.id_doc);
end loop;

return 1;
end;
$BODY$
language 'plpgsql';

alter table eqk_voltage_tbl alter column voltage_min type numeric(9,2);
alter table eqk_voltage_tbl alter column voltage_max type numeric(9,2);

insert into eqk_voltage_tbl (id,voltage_min,voltage_max) values (42,0.22,0.22);
update  eqk_voltage_tbl set voltage_min=0.22 ,voltage_max=0.22 where id=42;
ALTER SEQUENCE "eqi_grouptarif_seq" NO MAXVALUE;
ALTER SEQUENCE "aci_eqm_par_seq" NO MAXVALUE;
ALTER SEQUENCE "cli_position_seq" NO MAXVALUE;
ALTER SEQUENCE "aci_tarif_seq" NO MAXVALUE;

alter table adi_domain_tbl add column koatu bigint; 
alter table adi_region_tbl add column koatu bigint; 
alter table adi_town_tbl add column koatu bigint; 
alter table adi_street_tbl add column koatu bigint; 

alter table adi_domain_tbl alter column koatu type  varchar(13); 
alter table adi_region_tbl alter column koatu type varchar(13); 
alter table adi_town_tbl alter column koatu type varchar(13); 
alter table adi_street_tbl alter column koatu  type varchar(13); 
set client_encoding='win';

                                            /*
update adi_region_tbl set name=replace(name,'¨','³');
update adi_town_tbl set name=replace(name,'¨','³');


update adi_domain_tbl set name=replace(name,'0','³');
update adi_domain_tbl set name=replace(name,'i','³');
update adi_region_tbl set name=replace(name,'i','³');
update adi_region_tbl set name=replace(name,'?','³');
update adi_town_tbl set name=replace(name,'i','³');
update adi_town_tbl set name=replace(name,'?','³');
                                              */

alter table eqi_grouptarif_tbl add column old_tarif int;
alter table eqi_grouptarif_tbl alter column old_tarif  set default 0;
update eqi_grouptarif_tbl set old_tarif=1 where dt_end is not null;
update eqi_grouptarif_tbl set old_tarif=0 where dt_end is  null;


\i calc_action.sql

set client_encoding = 'koi8';
set client_encoding ='UTF8';
-- \i new_action_client.sql ONE TIME FOR RES
--select  repl_add ('2016-05-01');

--\i point_extra.sql
--\i repair_askue.sql
--\i repair_askue2.sql
--select * from seb_tar_tmp;

