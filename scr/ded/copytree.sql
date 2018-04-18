--drop function eqm_copy_tree_fun(int,int,int,int,date);
-- длинный вариант вызова с указанием абонентов
create or replace function eqm_copy_tree_fun(int,int,int,int,int,int,date) Returns int As'
Declare
pid_sclient Alias for $1;
pid_dclient Alias for $2;

pid_stree Alias for $3;
pid_snode Alias for $4;
pid_dtree Alias for $5;
pid_dparent Alias for $6;
pnewdate  Alias for $7;

vtype int;
r record;
rs int;
pnewid int;

vid_dparent int;

begin

 Raise Notice ''  - - -+++'';  
 --новое оборудование - новый id
 select into pnewid eqm_neweqp_fun(type_eqp,name_eqp,num_eqp,id_addres,pnewdate,pnewdate,loss_power,is_owner)
 from eqm_equipment_tbl where id = pid_snode; 

 if pid_dparent is null then

  select into vid_dparent eq.id from eqm_tree_tbl as t join eqm_equipment_tbl as eq on (t.code_eqp = eq.id)
  where t.id = pid_dtree and eq.type_eqp = 9 ;

  if not found then 
    vid_dparent :=null;
  end if;
 else
  vid_dparent:=pid_dparent;
 end if;


 insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
 select pid_dtree,pnewid,vid_dparent,name,parents
 from eqm_eqp_tree_tbl where code_eqp = pid_snode and id_tree=pid_stree and line_no = 0;

 select into vtype type_eqp from eqm_equipment_tbl where id = pid_snode; 
-- -- получим имя специфической таблици
-- select into vtablename st.name from eqi_device_kinds_tbl as dk 
-- join syi_table_tbl as st on (st.id=dk.id_table) where dk.id = vtype;

-- if found then
-- execute ''insert into ''||vtablename||'' select * from ''||vtablename||'' where code_eqp = ''||quote_literal(pid_snode);
-- end if;

 if vtype = 1 then --счетчик

  insert into eqm_meter_tbl (code_eqp,id_type_eqp,dt_control,nm,main_duble,warm,count_met,met_comment,warm_comment)
  select pnewid,m.id_type_eqp,m.dt_control,m.nm,m.main_duble,m.warm,m.count_met,m.met_comment,m.warm_comment from eqm_meter_tbl as m
  where m.code_eqp = pid_snode;
/*
  insert into eqd_meter_zone_tbl (code_eqp,dt_zone_install,zone,time_begin,time_end)
  select pnewid,dt_zone_install,zone,time_begin,time_end from eqd_meter_zone_tbl
  where code_eqp = pid_snode;

  insert into eqd_meter_energy_tbl(code_eqp,kind_energy,date_inst)
  select pnewid,kind_energy,date_inst from eqd_meter_energy_tbl
  where code_eqp = pid_snode;
*/

 end if ;

 if vtype = 2 then --тр. пониж.

  insert into eqm_compensator_tbl (code_eqp,id_type_eqp)
  select pnewid,id_type_eqp from eqm_compensator_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 3 then -- ключ

  insert into eqm_switch_tbl (code_eqp,id_type_eqp,folk)
  select pnewid,id_type_eqp,folk from eqm_switch_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 4 then -- компенсатор

  insert into eqm_jack_tbl (code_eqp,id_type_eqp,quantity)
  select pnewid,id_type_eqp,quantity from eqm_jack_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 5 then -- предохранитель

  insert into eqm_fuse_tbl (code_eqp,id_type_eqp)
  select pnewid,id_type_eqp from eqm_fuse_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 6 then -- л. кабель

  insert into eqm_line_c_tbl (code_eqp,id_type_eqp,length,id_voltage)
  select pnewid,id_type_eqp,length,id_voltage from eqm_line_c_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 7 then -- л. возд.

  insert into eqm_line_a_tbl (code_eqp,id_type_eqp,length,pillar,pillar_step,pendant,earth,id_voltage)
  select pnewid,id_type_eqp,length,pillar,pillar_step,pendant,earth,id_voltage from eqm_line_a_tbl
  where code_eqp = pid_snode;

 end if ;

 if vtype = 9 then -- Граница раздела (только как корень)

  insert into eqm_borders_tbl (code_eqp,id_clienta,id_clientb,inf)
  select pnewid,id_clienta,pid_dclient,inf from eqm_borders_tbl
  where code_eqp = pid_snode;

  insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
  select id_tree,pnewid,code_eqp_e,name,parents
  from eqm_eqp_tree_tbl where code_eqp = pid_snode and (id_tree<>pid_stree) and (id_tree<>pid_dtree)  and line_no = 0;

 end if ;

 if vtype = 10 then -- тр. измерительный

  insert into eqm_compensator_i_tbl (code_eqp,id_type_eqp)
  select pnewid,id_type_eqp from eqm_compensator_i_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 12 then -- т. учета

  insert into eqm_point_tbl (code_eqp,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,"share",ldemand,pdays,count_itr,itr_comment,cmp,"zone",flag_hlosts,id_depart,main_losts,ldemandr,ldemandg,id_un,lost_nolost,"power",id_extra,day_control)
  select pnewid,p.id_tarif,p.industry,p.count_lost,p.d,p.wtm,p.id_tg,p.id_voltage,p.share,p.ldemand,p.pdays,p.count_itr,p.itr_comment,p.cmp,p.zone,p.flag_hlosts,p.id_depart::int,p.main_losts,p.ldemandr,p.ldemandg,p.id_un,p.lost_nolost,p.power,p.id_extra,p.day_control
  from eqm_point_tbl as p where p.code_eqp = pid_snode;

  insert into eqd_point_energy_tbl(code_eqp,kind_energy,dt_instal)
  select pnewid,kind_energy,pnewdate from eqd_point_energy_tbl
  where code_eqp = pid_snode;

 end if ;

 if vtype = 16 then -- дизель

  insert into eqm_des_tbl (code_eqp,id_type_eqp,power)
  select pnewid,id_type_eqp,power from eqm_des_tbl
  where code_eqp = pid_snode;

 end if ;
 -- все потомки узла, кроме копий точек и границ раздела
 for r in  select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq 
 where eqt.code_eqp_e= pid_snode and eqt.id_tree = pid_stree and eq.type_eqp<>9 and line_no =0
 and eq.id = eqt.code_eqp loop

   rs:=eqm_copy_tree_fun(pid_sclient,pid_dclient,pid_stree,r.code_eqp,pid_dtree,pnewid,pnewdate);

 end loop;
 RETURN pnewid;
end;
' Language 'plpgsql';



----------------------------------------------------------------------------
-- короткий вариант вызова
CREATE OR REPLACE FUNCTION eqm_copy_tree_fun(integer, integer, integer, integer, date)
  RETURNS integer AS
'
Declare
pid_stree Alias for $1;
pid_snode Alias for $2;
pid_dtree Alias for $3;
pid_dparent Alias for $4;
pnewdate  Alias for $5;

vid_dparent int;
vtype int;
r record;
rs int;
pnewid int;

begin

 --новое оборудование - новый id
 select into pnewid eqm_neweqp_fun(type_eqp,name_eqp,num_eqp,null,pnewdate,pnewdate,loss_power,is_owner)
 from eqm_equipment_tbl where id = pid_snode; 

 if pid_dparent is null then

  select into vid_dparent eq.id from eqm_tree_tbl as t join eqm_equipment_tbl as eq on (t.code_eqp = eq.id)
  where t.id = pid_dtree and eq.type_eqp = 9 ;

  if not found then 
    vid_dparent :=null;
  end if;
 else
  vid_dparent:=pid_dparent;
 end if;

 insert into eqm_eqp_tree_tbl (id_tree,code_eqp,code_eqp_e,name,parents)
 select pid_dtree,pnewid,vid_dparent,name,parents
 from eqm_eqp_tree_tbl where code_eqp = pid_snode and id_tree=pid_stree and line_no = 0;

 select into vtype type_eqp from eqm_equipment_tbl where id = pid_snode; 
-- -- получим имя специфической таблици
-- select into vtablename st.name from eqi_device_kinds_tbl as dk 
-- join syi_table_tbl as st on (st.id=dk.id_table) where dk.id = vtype;

-- if found then
-- execute ''insert into ''||vtablename||'' select * from ''||vtablename||'' where code_eqp = ''||quote_literal(pid_snode);
-- end if;

 if vtype = 1 then --счетчик

  insert into eqm_meter_tbl (code_eqp,id_type_eqp,dt_control,nm,main_duble,warm)
  select pnewid,id_type_eqp,dt_control,nm,main_duble,warm from eqm_meter_tbl
  where code_eqp = pid_snode;
/*
  insert into eqd_meter_zone_tbl (code_eqp,dt_zone_install,zone,time_begin,time_end)
  select pnewid,dt_zone_install,zone,time_begin,time_end from eqd_meter_zone_tbl
  where code_eqp = pid_snode;

  insert into eqd_meter_energy_tbl(code_eqp,kind_energy,date_inst)
  select pnewid,kind_energy,date_inst from eqd_meter_energy_tbl
  where code_eqp = pid_snode;
*/

 end if ;

 if vtype = 2 then --тр. пониж.

  insert into eqm_compensator_tbl (code_eqp,id_type_eqp)
  select pnewid,id_type_eqp from eqm_compensator_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 3 then -- ключ

  insert into eqm_switch_tbl (code_eqp,id_type_eqp,folk)
  select pnewid,id_type_eqp,folk from eqm_switch_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 4 then -- компенсатор

  insert into eqm_jack_tbl (code_eqp,id_type_eqp,quantity)
  select pnewid,id_type_eqp,quantity from eqm_jack_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 5 then -- предохранитель

  insert into eqm_fuse_tbl (code_eqp,id_type_eqp)
  select pnewid,id_type_eqp from eqm_fuse_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 6 then -- л. кабель

  insert into eqm_line_c_tbl (code_eqp,id_type_eqp,length,id_voltage)
  select pnewid,id_type_eqp,length,id_voltage from eqm_line_c_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 7 then -- л. возд.

  insert into eqm_line_a_tbl (code_eqp,id_type_eqp,length,pillar,pillar_step,pendant,earth,id_voltage)
  select pnewid,id_type_eqp,length,pillar,pillar_step,pendant,earth,id_voltage from eqm_line_a_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 10 then -- тр. измерительный

  insert into eqm_compensator_i_tbl (code_eqp,id_type_eqp)
  select pnewid,id_type_eqp from eqm_compensator_i_tbl
  where code_eqp = pid_snode;

 end if ;
 if vtype = 12 then -- т. учета

  insert into eqm_point_tbl (code_eqp,power,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,share)
  select pnewid,power,id_tarif,industry,count_lost,d,wtm,id_tg,id_voltage,share 
  from eqm_point_tbl where code_eqp = pid_snode;

  insert into eqd_point_energy_tbl(code_eqp,kind_energy,dt_instal)
  select pnewid,kind_energy,pnewdate from eqd_point_energy_tbl
  where code_eqp = pid_snode;

 end if ;

 if vtype = 16 then -- дизель

  insert into eqm_des_tbl (code_eqp,id_type_eqp,power)
  select pnewid,id_type_eqp,power from eqm_des_tbl
  where code_eqp = pid_snode;

 end if ;
 -- все потомки узла, кроме копий точек и границ раздела
 for r in  select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq 
 where eqt.code_eqp_e= pid_snode and eqt.id_tree = pid_stree and eq.type_eqp<>9 and line_no =0
 and eq.id = eqt.code_eqp loop

   rs:=eqm_copy_tree_fun(pid_stree,r.code_eqp,pid_dtree,pnewid,pnewdate);

 end loop;
 RETURN pnewid;
end;
'
  LANGUAGE 'plpgsql' VOLATILE;

