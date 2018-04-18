
INSERT INTO syi_sysvars_tbl (id, ident, type_ident, value_ident, sql_ident) VALUES (123, 'monthctr_ignore', 'int', '1', NULL);

--set client_encoding='win';

CREATE INDEX acd_indication_meter_idx
  ON acd_indication_tbl
  USING btree
  (id_meter);


CREATE INDEX acd_indication_doc_idx
  ON acd_indication_tbl
  USING btree
  (id_doc);




create sequence acm_inspecth_seq  INCREMENT 1   MINVALUE 1  START 1 ;
create table acm_inspecth_tbl (
     id_doc 		int DEFAULT nextval('acm_inspecth_seq'),
     dt                 timestamp default now(),  
     id_position        int,
     reg_num            varchar (20),   
     reg_date           date default now(),   
     comment            varchar (254),
     mmgg               date default fun_mmgg(),
     flock              int default 0,
    primary key(id_doc)
);

alter table acm_inspecth_tbl add column id_fider int;
alter table acm_inspecth_tbl add column ind int;
alter table acm_inspecth_tbl alter column ind set default(0);
update  acm_inspecth_tbl set ind=id_doc where ind is null;
--drop constraingt  acm_inspecth_one_idx;
CREATE unique INDEX acm_inspecth_one_idx
  ON acm_inspecth_tbl
  USING btree
  (id_position,id_fider,mmgg,ind);

create sequence acm_inspectstr_seq  INCREMENT 1   MINVALUE 1  START 1 ;
create table acm_inspectstr_tbl (
     id                 int DEFAULT nextval('acm_inspectstr_seq'), 
     dt                 timestamp default now(),
     id_doc 		int,
     id_client          int,
     id_point           int,
     id_meter		int,
     id_address         int,
     num_eqp            varchar(50),
     type_eqp           int,
     carry              int,
     koef               int,
     kind_energy        int,
     zone               int,
     dt_insp            date,
     id_previndic       int,
     value              numeric(10,4),
     value_dev         numeric(10,4),
     value_dem         numeric(10,4),
     comment            varchar (254),
     mmgg               date default fun_mmgg(),
     flock              int default 0,
    primary key(id)
);

--select del_notrigger('acm_inspectstr_tbl','select altr_colmn(''acm_inspectstr_tbl'',''value'',''numeric(15,4)'')');
--select del_notrigger('acm_inspectstr_tbl','select altr_colmn(''acm_inspectstr_tbl'',''value_dev'',''numeric(15,4)'')');
--select del_notrigger('acm_inspectstr_tbl','select altr_colmn(''acm_inspectstr_tbl'',''value_dem'',''numeric(15,4)'')');

alter table acm_inspectstr_tbl add column id_previndic int;
alter table acm_inspectstr_tbl add column id_fider int;
alter table acm_inspectstr_tbl add column value_dev numeric(10,4);
alter table acm_inspectstr_tbl add column value_dem numeric(10,4);

drop trigger insphead_del on acm_inspecth_tbl;
drop function fun_insphead_del();

create function fun_insphead_del() returns trigger as'
Declare
  begin 
   if old.flock=1 then 
     raise exception ''insp_head %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    
    delete from acm_inspectstr_tbl where id_doc=old.id_doc;
  Return old;  
end;     
' Language 'plpgsql';

create trigger insphead_del
    Before Delete ON acm_inspecth_tbl
    For Each Row Execute Procedure fun_insphead_del();

                         /*
create or replace function change_dat_control() returns boolean as
' declare
  begin
 alter table eqm_point_tbl         DISABLE TRIGGER user;
 update eqm_point_tbl

 alter table eqm_point_tbl         ENABLE TRIGGER user;

   Return true;  
  end;     
' Language 'plpgsql';  */


-- Function: add_inspectindic(integer)

-- DROP FUNCTION add_inspectindic(integer);

CREATE OR REPLACE FUNCTION add_inspectindic(integer)
  RETURNS boolean AS
$BODY$
declare 
doc alias for $1;
insp int;
dat  date;
headind record;
ind record;
prov_ind record;
prov numeric;
dayi int;
count1 int;
vmmgg date;
vgrafic_ignore int;

begin


 select into vgrafic_ignore to_number(trim(value_ident),'0000000000') from syi_sysvars_tbl 
                 where ident='monthctr_ignore';

 if not found then
   vgrafic_ignore:=0;
 end if;


for headind in select * from acm_inspecth_tbl where id_doc=doc loop

  dayi= date_part('day',headind.reg_date);

  --vmmgg = date_trunc('month',headind.reg_date);
  select into vmmgg mmgg from bal_grp_tree_tbl order by mmgg desc limit 1;

  if (headind.id_fider is not null) then

    raise notice ' - - fider % ', headind.id_fider ;
   select value into prov from acm_inspectstr_tbl where id_doc=doc and value>0;
  if not found then
    delete from acm_inspectstr_tbl where id_doc=doc;
  else
        raise exception ' Full CURRENT VALUE  ';
  end if;
    raise notice ' - deleted - -  ' ;

    insert into acm_inspectstr_tbl (id_doc,id_client,id_meter,id_point, id_address,num_eqp, type_eqp,carry,kind_energy,zone, dt_insp,id_fider)
    select distinct headind.id_doc, id_client,id_meter,id_point,id_addres,num_meter,id_type_eqp,carry,kind_energy,zone, dt1,
    case when id_voltage in (3,31,32) and type_eqp = 15 then code_eqp 
       when id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
       when id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 END
    from (
    select sss.*,   
     calend_dt_dec(case when period_indicat in (0, 1) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 2 and month_indicat = 1 and date_part('month',headind.mmgg) in (1,3,5,7,9,11) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 2 and month_indicat = 2 and date_part('month',headind.mmgg) in (2,4,6,8,10,12) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 1 and date_part('month',headind.mmgg) in (1,4,7,10)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 2 and date_part('month',headind.mmgg) in (2,5,8,11)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 3 and date_part('month',headind.mmgg) in (3,6,9,12)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                         END::date ,2) as dt1, 

    gr1.type_eqp, gr1.code_eqp, gr1.id_voltage , 
    gr2.type_eqp as type_eqp2, gr2.code_eqp as code_eqp2, gr2.id_voltage as id_voltage2, 
    gr3.type_eqp as type_eqp3, gr3.code_eqp as code_eqp3, gr3.id_voltage as id_voltage3 
    from (
  
    select c.id as id_client,sc.dt_start,sc.dt_indicat,

    CASE WHEN vgrafic_ignore=1 THEN 1 ELSE substring(text(sc.month_control)::varchar,1,1)::int END as period_indicat,

    CASE WHEN vgrafic_ignore=1 THEN 1 ELSE  CASE WHEN coalesce(substring(text(sc.month_control)::varchar,2,1),'') = '' THEN '1' ELSE substring(text(sc.month_control)::varchar,2,1) END::int END as month_indicat,

      ba.id_point, mp.id_meter , eqm.num_eqp as num_meter, m.id_type_eqp, im.carry, me.kind_energy, mz.zone,
    eq.id_addres, sc.id_position, ba.id_grp as link 
    from 
--    (select id_p_eqp, id_point, id_client from bal_grp_tree_tbl as gr0 where mmgg= vmmgg and type_eqp = 12 and id_client <>-1 order by id_point) as ba 
    bal_abons_tbl as ba 
    join clm_client_tbl as c on (c.id = ba.id_client) 
    join clm_statecl_tbl as sc on (c.id = sc.id_client) 
    join eqm_equipment_tbl as eq on (eq.id = ba.id_point) 
    join eqm_point_tbl as p on (p.code_eqp=ba.id_point ) 
    join (select * from eqm_meter_point_h where dt_e is null order by id_point) as mp on ( mp.id_point = ba.id_point )
    join eqm_equipment_tbl as eqm on (eqm.id =mp.id_meter) 
    join eqm_meter_tbl as m on (m.code_eqp=mp.id_meter ) 
    join eqi_meter_tbl as im on (im.id = m.id_type_eqp) 
    join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter)
    join eqd_meter_zone_tbl as mz on (mz.code_eqp = mp.id_meter)
  
    where c.book = -1 and coalesce(sc.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) 
--      and coalesce(sc.id_section,0) not in (210,211,212,213,214,215)
--    and p.day_control = dayi
    )as sss 
    left join eqm_equipment_tbl as ee on (ee.id = link) 
    left join bal_grp_tree_tbl as gr1 on (gr1.code_eqp = sss.link and gr1.mmgg= vmmgg) 
    left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= vmmgg) 
    left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) 
    left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= vmmgg) 
    left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) 
    ) as ssss  
--    where ( bom(dt1)=headind.mmgg  -- not need by date
      where ((dt1 is not null)
       and case when id_voltage in (3,31,32) and type_eqp = 15 then code_eqp 
       when id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
       when id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 END = headind.id_fider);


  else
      raise notice 'else if   (fider empty)';
  /* for ind in 
    select ep.id_point,ep.num_eqp,ep.id_type_eqp,ep.carry,ep.id_meter as id_meter,z.zone,z.kind_energy,e.*,
    calend_dt_dec(case when period_indicat = 1 then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 2 and month_indicat = 1 and date_part('month',headind.mmgg) in (1,3,5,7,9,11) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 2 and month_indicat = 2 and date_part('month',headind.mmgg) in (2,4,6,8,10,12) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 1 and date_part('month',headind.mmgg) in (1,4,7,10)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 2 and date_part('month',headind.mmgg) in (2,5,8,11)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 3 and date_part('month',headind.mmgg) in (3,6,9,12)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                         END::date ,2) as dt1 
  from 
    (
     select * from 
       ((select e.*,et.id_client,et.dt_start,et.dt_indicat,et.period_indicat,et.month_indicat from 
          (select * from eqm_equipment_tbl where type_eqp in (12)) as e, 
            ( select e.*,et.id_client,et.dt_start,et.dt_indicat,et.period_indicat,et.month_indicat from eqm_eqp_tree_tbl e,
                   (select t.*,s.dt_start,s.dt_indicat,s.period_indicat,s.month_indicat from eqm_tree_tbl t,clm_statecl_tbl s 
                      where s.id_client=t.id_client and (s.id_kur=headind.id_position or s.id_kur is null or headind.id_position is null)
                   )   et
              where et.id=e.id_tree
             ) et where e.id=et.code_eqp 
           )
           union 
          (select e.*,et.id_client ,et.dt_start,et.dt_indicat,et.period_indicat,et.month_indicat from 
             (select * from eqm_equipment_tbl where type_eqp in (12) ) as e, 
               (select e.*,s.dt_start,s.dt_indicat,s.period_indicat,s.month_indicat  from eqm_eqp_use_tbl e     ,clm_statecl_tbl s 
                 where s.id_client=e.id_client and (s.id_kur=headind.id_position or s.id_kur is null or headind.id_position is null) 
               )   et
               where e.id=et.code_eqp 
              ) 
          ) as e
        ) as e ,
    (select * from eqm_point_tbl  ) as pp,

   ( select ep.*,e.num_eqp,mm.id_type_eqp,m.carry from eqm_meter_point_h ep,eqm_equipment_tbl e,eqm_meter_tbl mm,eqi_meter_tbl m
       where e.id=ep.id_meter and dt_e is null and ep.id_meter=mm.code_eqp and mm.id_type_eqp=m.id 
   ) ep,
   (select e.*,z.zone  from eqd_meter_energy_tbl e,eqd_meter_zone_tbl z where e.code_eqp=z.code_eqp  order by e.code_eqp) as z
   where ep.id_point=e.id and z.code_eqp=ep.id_meter and pp.code_eqp=ep.id_point order by ep.num_eqp
   loop


    raise notice 'res1  ind.id_client %,ind.id_meter %,ind.id_point %,
         ind.num_eqp %,       ind.id_type_eqp %,ind.carry %, ind.kind_energy %,ind.zone %,ind.dt1 %' ,
                         ind.id_client,ind.id_meter,ind.id_point,
        ind.num_eqp,        ind.id_type_eqp,ind.carry,ind.kind_energy,ind.zone,ind.dt1;

   select * into prov_ind from acm_inspectstr_tbl where id_doc=headind.id_doc 
        and id_client=ind.id_client 
       and id_meter=ind.id_meter and id_point=ind.id_point 
    and kind_energy=ind.kind_energy and zone=ind.zone;

   if not found then
    
      insert into acm_inspectstr_tbl (id_doc,id_client,id_meter,id_point,
        id_address,num_eqp,
        type_eqp,carry,koef,kind_energy,zone, dt_insp)
       values (headind.id_doc,ind.id_client,ind.id_meter,ind.id_point,
        ind.id_addres,ind.num_eqp,
        ind.id_type_eqp,ind.carry,0,ind.kind_energy,ind.zone,ind.dt1);
   end if;
   end loop;
*/
delete from acm_inspectstr_tbl where id_doc=doc;

    raise notice ' - deleted - -  ' ;

    insert into acm_inspectstr_tbl (id_doc,id_client,id_meter,id_point, id_address,num_eqp, type_eqp,carry,kind_energy,zone, dt_insp,id_fider)
    select distinct headind.id_doc, id_client,id_meter,id_point,id_addres,num_meter,id_type_eqp,carry,kind_energy,zone, dt1,
    case when id_voltage in (3,31,32) and type_eqp = 15 then code_eqp 
       when id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
       when id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 END
    from (
    select sss.*,   
     calend_dt_dec(case when period_indicat in (0,1) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 2 and month_indicat = 1 and date_part('month',headind.mmgg) in (1,3,5,7,9,11) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 2 and month_indicat = 2 and date_part('month',headind.mmgg) in (2,4,6,8,10,12) then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 1 and date_part('month',headind.mmgg) in (1,4,7,10)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 2 and date_part('month',headind.mmgg) in (2,5,8,11)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                     when period_indicat = 3 and month_indicat = 3 and date_part('month',headind.mmgg) in (3,6,9,12)  then date_trunc('month',headind.mmgg)::date+(text(dt_indicat-1)|| ' days')::interval 
                         END::date ,2) as dt1, 

    gr1.type_eqp, gr1.code_eqp, gr1.id_voltage , 
    gr2.type_eqp as type_eqp2, gr2.code_eqp as code_eqp2, gr2.id_voltage as id_voltage2, 
    gr3.type_eqp as type_eqp3, gr3.code_eqp as code_eqp3, gr3.id_voltage as id_voltage3 
    from (
  
    select c.id as id_client,sc.dt_start,sc.dt_indicat,
    CASE WHEN vgrafic_ignore=1 THEN 1 ELSE  substring(text(sc.month_control)::varchar,1,1)::int END as period_indicat,
    CASE WHEN vgrafic_ignore=1 THEN 1 ELSE CASE WHEN coalesce(substring(text(sc.month_control)::varchar,2,1),'') = '' THEN '1' ELSE substring(text(sc.month_control)::varchar,2,1) END::int END as month_indicat,
      ba.id_point, mp.id_meter , eqm.num_eqp as num_meter, m.id_type_eqp, im.carry, me.kind_energy, mz.zone,
    eq.id_addres, sc.id_position, ba.id_grp as link 
    from 
--    (select id_p_eqp, id_point, id_client from bal_grp_tree_tbl as gr0 where mmgg= vmmgg and type_eqp = 12 and id_client <>-1 order by id_point) as ba 
    bal_abons_tbl as ba 
    join clm_client_tbl as c on (c.id = ba.id_client) 
    join clm_statecl_tbl as sc on (c.id = sc.id_client) 
    join eqm_equipment_tbl as eq on (eq.id = ba.id_point) 
    join eqm_point_tbl as p on (p.code_eqp=ba.id_point ) 
    join (select * from eqm_meter_point_h where dt_e is null order by id_point) as mp on ( mp.id_point = ba.id_point )
--    join eqm_equipment_tbl as eqm on (eqm.id =ba.id_meter) 
    join eqm_equipment_tbl as eqm on (eqm.id =mp.id_meter) 
    join eqm_meter_tbl as m on (m.code_eqp=mp.id_meter ) 
    join eqi_meter_tbl as im on (im.id = m.id_type_eqp) 
    join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter)
    join eqd_meter_zone_tbl as mz on (mz.code_eqp = mp.id_meter)
  
    where c.book = -1 and coalesce(sc.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) 
--     and coalesce(sc.id_section,0) not in (210,211,212,213,214,215)
--    and p.day_control = dayi
    )as sss 
    left join eqm_equipment_tbl as ee on (ee.id = link) 
    left join bal_grp_tree_tbl as gr1 on (gr1.code_eqp = sss.link and gr1.mmgg= vmmgg) 
    left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= vmmgg) 
    left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) 
    left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= vmmgg) 
    left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) 
    ) as ssss,
    ( select code_eqp as id_fider from eqm_fider_tbl where id_position=headind.id_position ) ff where
--   ( bom(dt1)=headind.mmgg  -- not need by date
   ( (dt1 is not null)  -- not need by date
       and case when id_voltage in (3,31,32) and type_eqp = 15 then code_eqp 
       when id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
       when id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 END = ff.id_fider);




 end if;

count1=0;

 raise notice ' - update start  - -  ' ;
for ind in select count(*) as c from acm_inspectstr_tbl where id_doc =doc   loop
 raise notice 'all count, %', ind.c;
end loop;
 for ind in 
   select * from acm_inspectstr_tbl where id_doc =doc 
 loop

 count1=count1+1;

 raise notice 'count1, %', count1 ;
  /*
 update acm_inspectstr_tbl set id_previndic=
  (select id from acd_indication_tbl where id_meter=ind.id_meter 
        and num_eqp=ind.num_eqp and dat_ind<ind.dt_insp
        and id_zone=ind.zone and kind_energy=ind.kind_energy
        order by dat_ind desc limit 1 ) ,
  koef=(select coef_comp from acd_indication_tbl where id_meter=ind.id_meter 
        and num_eqp=ind.num_eqp and dat_ind<ind.dt_insp 
        and id_zone=ind.zone and kind_energy=ind.kind_energy
        order by dat_ind desc limit 1 )
 where id=ind.id ;  

*/

 update acm_inspectstr_tbl set id_previndic= id_prev,koef=coef_comp from
  (select id as id_prev,coef_comp from acd_indication_tbl where id_meter=ind.id_meter 
        and num_eqp=ind.num_eqp and dat_ind<ind.dt_insp
        and id_zone=ind.zone and kind_energy=ind.kind_energy
        order by dat_ind desc limit 1 ) e
 where id=ind.id ;  

 end loop;

end loop;


return true;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION add_inspectindic(integer)
  OWNER TO local;






drop trigger insp_upd_trg_aft on acm_inspectstr_tbl;
drop trigger insp_del_trg_aft on acm_inspectstr_tbl;
--drop function upd_inspectStr_fun();


create or replace function upd_inspectStr_fun() returns trigger as '
declare 
rind record;
eind record;
begin

for rind in select di.* from acd_indication_tbl as di  
 where id_inspect=old.id and flock<>1
loop
raise notice ''upd  id -   %,  num_eqp= %    '',rind.id,rind.num_eqp;
 
update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=rind.id_meter 
        and num_eqp=rind.num_eqp and kind_energy=rind.kind_energy 
       and zone=rind.id_zone and rind.dat_ind>=dt_insp  and value is not null
        order by dt_insp desc limit 1 ) 
where id=rind.id;        


end loop; 

for eind in select di.* from acd_indication_tbl as di  
 where id_meter=old.id_meter and num_eqp=old.num_eqp 
       and id_typemet=old.type_eqp and  carry=old.carry and 
       coef_comp=old.koef and kind_energy=old.kind_energy and id_zone=old.zone 
       and flock<>1     
loop
raise notice ''upd  end id -   %,  num_eqp= %    '',eind.id,eind.num_eqp;
 
update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=eind.id_meter 
        and num_eqp=eind.num_eqp and kind_energy=eind.kind_energy 
       and zone=eind.id_zone and eind.dat_ind>=dt_insp  and value is not null
        order by dt_insp desc limit 1 ) 
where id=eind.id;        


end loop; 
raise notice ''new dt '';
new.dt=now();

raise notice ''new dt  %'',new.dt;
return new;
end;
' language 'plpgsql';



create or replace function del_inspectStr_fun() returns trigger as '
declare 
rind record;
eind record;
begin

for rind in select di.* from acd_indication_tbl as di  
 where id_inspect=old.id and flock<>1
loop
raise notice ''upd  id -   %,  num_eqp= %    '',rind.id,rind.num_eqp;
 
update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=rind.id_meter 
        and num_eqp=rind.num_eqp and kind_energy=rind.kind_energy 
       and zone=rind.id_zone and rind.dat_ind>=dt_insp  and value is not null
        order by dt_insp desc limit 1 ) 
where id=rind.id;        


end loop; 

for eind in select di.* from acd_indication_tbl as di  
 where id_meter=old.id_meter and num_eqp=old.num_eqp 
       and id_typemet=old.type_eqp and  carry=old.carry and 
       coef_comp=old.koef and kind_energy=old.kind_energy and id_zone=old.zone 
       and flock<>1     
loop
raise notice ''upd  end id -   %,  num_eqp= %    '',eind.id,eind.num_eqp;
 
update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=eind.id_meter 
        and num_eqp=eind.num_eqp and kind_energy=eind.kind_energy 
       and zone=eind.id_zone and eind.dat_ind>=dt_insp  and value is not null
        order by dt_insp desc limit 1 ) 
where id=eind.id;        


end loop; 
--raise notice ''new dt '';
--new.dt=now();

--raise notice ''new dt  %'',new.dt;
return old;
end;
' language 'plpgsql';


create trigger insp_upd_trg_aft
    after update ON acm_inspectstr_tbl
    For Each Row Execute Procedure upd_inspectStr_fun();        


create or replace function upd_inspectStrb_fun() returns trigger as '
declare 
rind record;
eind record;
begin
raise notice ''new dt '';
new.dt=now();

raise notice ''new dt  %'',new.dt;
return new;
end;
' language 'plpgsql';


drop trigger insp_upd_trg_bef1 ON acm_inspectstr_tbl;

create trigger insp_upd_trg_bef1
    before update ON acm_inspectstr_tbl
    For Each Row Execute Procedure upd_inspectStrb_fun();        


create trigger insp_del_trg_aft
    after delete ON acm_inspectstr_tbl
    For Each Row Execute Procedure del_inspectStr_fun();        
