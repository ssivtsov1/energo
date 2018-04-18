;
set client_encoding = 'win';

-- абоненты разбиваются на город и село по адресу в карточке,
-- площадки и точки учета по адресу площадки
/*
begin;

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_point_tbl';

update eqm_point_h set share = null 
where share is not null and dt_e is null and 
exists
(select code_eqp from eqm_eqp_tree_tbl as tt  join  eqm_equipment_tbl as eq on (eq.id = tt.code_eqp)
 where tt.code_eqp_e = eqm_point_h.code_eqp and eq.type_eqp in (1,10));
 
update eqm_point_tbl set share = null 
where share is not null and 
exists
(select code_eqp from eqm_eqp_tree_tbl as tt  join  eqm_equipment_tbl as eq on (eq.id = tt.code_eqp)
 where tt.code_eqp_e = eqm_point_tbl.code_eqp and eq.type_eqp in (1,10));


UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_point_tbl';

commit;
*/

  drop FUNCTION rep_abon_count_fun(date);

  alter table rep_areas_points_tbl add column del_abon int;

-----------
  CREATE or replace FUNCTION rep_abon_count_fun(date)
  RETURNS int
  AS                                                                                              
  '
  declare
   pdt Alias for $1;
  begin

    if (select getsysvar(''kod_res'')) = 310 then
      return rep_abon_count_fun(pdt,0);
    else
      return rep_abon_count_fun(pdt,1);
    end if;

  end;'                                                                                           
  LANGUAGE 'plpgsql';          
-------------------
  CREATE or replace FUNCTION rep_abon_count_fun(date, int )
  RETURNS int
  AS                                                                                              
  '
  declare
   pdt Alias for $1;
   pallpoint Alias for $2;

   veqp int;
   r record;
   rr record;
   vareas_noprom10k int;
   vabons_sh int;
   vabons_noprom10k int;
   vareas record;
   vareas_sh int;
   vpoints record;
   vsh record;
   vnp record;
   vp record;
   vpoint_noprom10k record;
   vprom  record;
   vabons_p record;
   vareas_p record;
   vdef_addr_type bool;
   vid_res int; 
  begin
   raise notice ''delete'';
   delete from rep_areas_points_tbl;
   delete from rep_count_tbl ; --where mmgg = pdt;
    raise notice ''delete end'';

   vid_res:= syi_resid_fun() ;

   insert into rep_areas_points_tbl (id_client,id_point,voltage,un,is_subabon,del_abon )
    select distinct c.id, p.code_eqp, p.id_voltage,coalesce(p.id_un,0) , CASE WHEN (use.id_client is null) and (coalesce(border.id_clienta,vid_res)<>vid_res ) THEN 1 ELSE 0 END ,
    CASE WHEN coalesce(c.id_state,0) = 3 THEN 1 ELSE 0 END 
    from eqm_tree_h as tr
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by id order by id) as tr2 on (tr.id = tr2.id and tr2.dt = tr.dt_b)
    join eqm_eqp_tree_h as ttr on (tr.id = ttr.id_tree)
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp) as ttr2 on (ttr.code_eqp = ttr2.code_eqp and ttr2.dt = ttr.dt_b)
    join eqm_point_h as p on (ttr.code_eqp = p.code_eqp)
    join (select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp) as p2 on (p.code_eqp = p2.code_eqp and p2.dt = p.dt_b)
    left join 
    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp ) as u2
     on (u1.code_eqp = u2.code_eqp and u2.dt = u1.dt_b) 
    ) as use on (use.code_eqp = p.code_eqp)
    left join 
    ( select b1.code_eqp,b1.id_clienta,b1.id_clientb  from eqm_borders_h as b1 
       join (select code_eqp, max(dt_b) as dt from eqm_borders_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp ) as b2
     on (b1.code_eqp = b2.code_eqp and b2.dt = b1.dt_b) 
    ) as border on (border.code_eqp = tr.code_eqp)
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))
    left join clm_statecl_tbl as scl on (c.id = scl.id_client)
    where scl.id_section not in (205,206,207,208,209) 
    and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99) and c.id <> vid_res
    and coalesce(p.share,0) = 0
    and c.book=-1;

    raise notice ''insert areas end'';

    if (select getsysvar(''kod_res'')) = 310 then
      vdef_addr_type :=true;
    else
      vdef_addr_type :=false;
    end if;

    update rep_areas_points_tbl set id_area = area.id,  is_town = coalesce(kt.flag_type , vdef_addr_type)
    from eqm_compens_station_inst_h as inst 
    join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt 
          group by code_eqp, code_eqp_inst order by code_eqp, code_eqp_inst ) as inst2 on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b)
    join eqm_equipment_h as area on (inst.code_eqp_inst = area.id and area.type_eqp = 11)
    join (select id, max(dt_b) as dt from eqm_equipment_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt and type_eqp = 11 group by id order by id) as area2 on (area.id = area2.id and area2.dt = area.dt_b)
    left join eqm_area_tbl as aa on (aa.code_eqp = area.id )
    left join clm_client_tbl as c on (c.id = aa.id_client)
    left join adm_address_tbl as a on (a.id = CASE WHEN coalesce(area.id_addres,0) = 0 THEN c.id_addres ELSE area.id_addres END )
    left join adi_street_tbl as s on (s.id = a.id_street)
    left join adi_town_tbl as t on (t.id = s.id_town)
    left join adk_town_tbl as kt on (kt.id = t.idk_town)
    where inst.code_eqp= rep_areas_points_tbl.id_point;

    update rep_areas_points_tbl set id_area = 0 , is_town = vdef_addr_type where id_area is null;
    update rep_areas_points_tbl set is_town = vdef_addr_type where is_town is null;
    update rep_areas_points_tbl set voltage = null where voltage = 0;

    --найти счетчик, чтобы по справочнику определить 1 или 3 фазное подключение.
/*
    for r in select * from rep_areas_points_tbl order by id_point
    loop

     Raise Notice ''Start %'',r.id_point;

     veqp :=r.id_point;


      LOOP

       select into rr tt.code_eqp, eq.type_eqp, m.id_type_eqp
       From eqm_equipment_h AS eq 
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id )
       left join eqm_meter_h as m on (m.code_eqp=eq.id  and m.dt_b <= pdt and coalesce(m.dt_e,pdt) >= pdt)
       where (tt.code_eqp_e = veqp) and (eq.type_eqp in (1,10)) 
       and eq.dt_b <= pdt and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt and coalesce(eq.dt_e,pdt) >= pdt
       order by tt.dt_b,eq.dt_b,m.dt_b limit 1;


      -- Raise Notice ''Start2  %'',rr.code_eqp;

       EXIT WHEN ( rr.type_eqp = 1 or rr.code_eqp is null );   

       veqp = rr.code_eqp;

      END LOOP;


      if (rr.type_eqp = 1) then

        update rep_areas_points_tbl set phase = m.phase
        from eqi_meter_tbl as m where m.id = rr.id_type_eqp and rep_areas_points_tbl.id_point=r.id_point  ;
 
      end if;


    END LOOP;
*/

  update rep_areas_points_tbl set phase = im.phase
  from eqm_meter_point_h as mp 
  join eqm_meter_h as m on (m.code_eqp=mp.id_meter )
  join eqi_meter_tbl as im on (im.id = m.id_type_eqp) 
  where rep_areas_points_tbl.id_point=mp.id_point  
  and m.dt_b <= pdt and coalesce(m.dt_e,pdt) >= pdt and mp.dt_b <= pdt and coalesce(mp.dt_e,pdt) >= pdt;

  if pallpoint = 1 then
   update rep_areas_points_tbl set phase= 1 where phase is null and coalesce(voltage,4) in (4,42);
   update rep_areas_points_tbl set phase= 2 where phase is null and coalesce(voltage,4) not in (4,42);
  end if;

  
     raise notice ''neprom '';
  --непром до 1000В
  -- если есть ТУ 10 и 0.4 , то 10.02.2009 решили относит в 10 кВ
  insert into rep_count_tbl(mmgg,abons_budjet_t,abons_budjet_v,abons_jkh_t,abons_jkh_v,abons_other_t,abons_other_v)
  select pdt,
  sum(case when scl.id_section in (211,213,214,215) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_budjet_t,
  sum(case when scl.id_section in (211,213,214,215) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_budjet_v,
  sum(case when scl.id_section in (203) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_jkh_t,
  sum(case when scl.id_section in (203) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_jkh_v,
  sum(case when scl.id_section in (204) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_other_t,
  sum(case when scl.id_section in (204) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_other_v

  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section not in (205,206,207,208) and c.idk_work not in (0,99) and c.book=-1
  and coalesce(c.id_state,0) not in (50,99)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) not in (4,42) );

    raise notice ''neprom end'';

  --с/х
/*
  update rep_count_tbl set abons_sh = count(c.id)
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  where scl.id_section = 202 and c.idk_work <> 0 and c.book=-1 and coalesce(c.id_state,0) not in (50,99);
*/
  select into vabons_sh  count(c.id)
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  where scl.id_section = 202 and c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id );

  update rep_count_tbl set abons_sh = vabons_sh;
-- return 0;
  --непром больше 1000 В
/*
  update rep_count_tbl set abons_noprom10k = count(c.id)
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  where scl.id_section not in (205,206,207,208,202,201) and c.idk_work <> 0 and c.book=-1
  and coalesce(c.id_state,0) not in (50,99)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and voltage = 4 );
*/
  select into vabons_noprom10k  count(c.id)
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  where scl.id_section not in (205,206,207,208,202,201) and c.idk_work not in (0,99) and c.book=-1
  and coalesce(c.id_state,0) not in (50,99)
--  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id )
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) not in  (4,42) );

  update rep_count_tbl set abons_noprom10k = vabons_noprom10k;

/*
  update rep_count_tbl set abons_noprom10k = count(c.id)
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join rep_areas_points_tbl as ap4 on (ap4.id_client  = c.id and ap4.voltage = 4)
  where scl.id_section not in (205,206,207,208,202,201) and c.idk_work <> 0 and c.book=-1
  and coalesce(c.id_state,0) not in (50,99)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id )
  and ap4.id_point is null;
*/
  -- площадки

/*
  update rep_count_tbl 
  set 
      areas_budjet_t = sum(case when id_section in (211,213,214,215) and is_town =true then 1 else 0 end) ,
      areas_budjet_v = sum(case when id_section in (211,213,214,215) and is_town =false then 1 else 0 end) ,
      areas_jkh_t = sum(case when id_section in (203) and is_town =true then 1 else 0 end) ,
      areas_jkh_v = sum(case when id_section in (203) and is_town =false then 1 else 0 end) ,
      areas_other_t = sum(case when id_section in (204) and is_town =true then 1 else 0 end) ,
      areas_other_v = sum(case when id_section in (204) and is_town =false then 1 else 0 end) 
  from
  (select distinct ap.id_client,ap.id_area,coalesce(ap.is_town ,false) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208) 
   and exists (select id_point from rep_areas_points_tbl where id_client  = ap.id_client and voltage = 4 )
  ) as s;
*/

  -- село/город определяем по адресу площадки, по умолчанию село
  -- в 0.4 идут площадки, на которых нет 10 кВ
  select into vareas sum(case when id_section in (211,213,214,215) and is_town =true then 1 else 0 end) as areas_budjet_t,
       sum(case when id_section in (211,213,214,215) and is_town =false then 1 else 0 end) as areas_budjet_v,
       sum(case when id_section in (203) and is_town =true then 1 else 0 end) as areas_jkh_t,
       sum(case when id_section in (203) and is_town =false then 1 else 0 end) as areas_jkh_v,
       sum(case when id_section in (204) and is_town =true then 1 else 0 end) as areas_other_t,
       sum(case when id_section in (204) and is_town =false then 1 else 0 end) as areas_other_v 
  from
  (select distinct ap.id_client,ap.id_area ,coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208) and ap.del_abon = 0
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) not in (4,42) )
  ) as s;

  update rep_count_tbl 
  set 
      areas_budjet_t 	= vareas.areas_budjet_t,
      areas_budjet_v 	= vareas.areas_budjet_v,
      areas_jkh_t 	= vareas.areas_jkh_t ,
      areas_jkh_v 	= vareas.areas_jkh_v ,
      areas_other_t 	= vareas.areas_other_t ,
      areas_other_v 	= vareas.areas_other_v ;

/*
  update rep_count_tbl 
  set areas_sh = count(*) 
  from
  (select distinct ap.id_client,ap.id_area 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =202  
  ) as s;
*/

  select into vareas_sh  count(*) 
  from
  (select distinct ap.id_client,ap.id_area 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =202  and ap.del_abon = 0 
  ) as s;

  update rep_count_tbl  set areas_sh =vareas_sh;
/*
  update rep_count_tbl 
  set areas_noprom10k = count(*) 
  from
  (select distinct ap.id_client,ap.id_area 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208,202,201)  
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.voltage = 4 )
  ) as s;
*/
  -- в 10кВ идут площадки, в которых существуют ТУ 10кВ
  select into vareas_noprom10k count(*) 
  from
  (select distinct ap.id_client,ap.id_area 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208,202,201)  and ap.del_abon = 0 
   and exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) not in (4,42) )
  ) as s;

  update rep_count_tbl set areas_noprom10k = vareas_noprom10k; 


  -- точки учета
/*
  update rep_count_tbl 
  set 
      point1_budjet_t = sum(case when id_section in (211,213,214,215) and is_town =true and phase = 1 then 1 else 0 end) ,
      point1_budjet_v = sum(case when id_section in (211,213,214,215) and is_town =false and phase = 1  then 1 else 0 end) ,
      point1_jkh_t = sum(case when id_section in (203) and is_town =true  and phase = 1 then 1 else 0 end) ,
      point1_jkh_v = sum(case when id_section in (203) and is_town =false  and phase = 1 then 1 else 0 end) ,
      point1_other_t = sum(case when id_section in (204) and is_town =true  and phase = 1 then 1 else 0 end) ,
      point1_other_v = sum(case when id_section in (204) and is_town =false  and phase = 1 then 1 else 0 end) ,

      point3_budjet_t = sum(case when id_section in (211,213,214,215) and is_town =true and phase = 2 then 1 else 0 end) ,
      point3_budjet_v = sum(case when id_section in (211,213,214,215) and is_town =false and phase = 2  then 1 else 0 end) ,
      point3_jkh_t = sum(case when id_section in (203) and is_town =true  and phase = 2 then 1 else 0 end) ,
      point3_jkh_v = sum(case when id_section in (203) and is_town =false  and phase = 2 then 1 else 0 end) ,
      point3_other_t = sum(case when id_section in (204) and is_town =true  and phase = 2 then 1 else 0 end) ,
      point3_other_v = sum(case when id_section in (204) and is_town =false  and phase = 2 then 1 else 0 end) 

  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,false) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208) 
   and exists (select id_point from rep_areas_points_tbl where id_client  = ap.id_client and voltage = 4 )
  ) as s;
*/
  -- точки учета по их собственному напряжению (только 0.4 кВ)
  select into vpoints 
         sum(case when id_section in (211,213,214,215) and is_town =true and phase = 1 then 1 else 0 end) as point1_budjet_t,
         sum(case when id_section in (211,213,214,215) and is_town =false and phase = 1  then 1 else 0 end) as point1_budjet_v,
         sum(case when id_section in (203) and is_town =true  and phase = 1 then 1 else 0 end) as point1_jkh_t,
         sum(case when id_section in (203) and is_town =false  and phase = 1 then 1 else 0 end) as point1_jkh_v,
         sum(case when id_section in (204) and is_town =true  and phase = 1 then 1 else 0 end) as point1_other_t,
         sum(case when id_section in (204) and is_town =false  and phase = 1 then 1 else 0 end) as point1_other_v,

         sum(case when id_section in (211,213,214,215) and is_town =true and phase = 2 then 1 else 0 end) as point3_budjet_t,
         sum(case when id_section in (211,213,214,215) and is_town =false and phase = 2  then 1 else 0 end) as point3_budjet_v,
         sum(case when id_section in (203) and is_town =true  and phase = 2 then 1 else 0 end) as point3_jkh_t,
         sum(case when id_section in (203) and is_town =false  and phase = 2 then 1 else 0 end) as point3_jkh_v,
         sum(case when id_section in (204) and is_town =true  and phase = 2 then 1 else 0 end) as point3_other_t,
         sum(case when id_section in (204) and is_town =false  and phase = 2 then 1 else 0 end) as point3_other_v 

  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208) 
   and coalesce(voltage,4) in (4,42)  and ap.del_abon = 0
--   and exists (select id_point from rep_areas_points_tbl where id_client  = ap.id_client and voltage = 4 )
  ) as s;


  update rep_count_tbl 
  set 
      point1_budjet_t = vpoints. point1_budjet_t,
      point1_budjet_v = vpoints. point1_budjet_v,
      point1_jkh_t    = vpoints. point1_jkh_t   ,
      point1_jkh_v    = vpoints. point1_jkh_v   ,
      point1_other_t  = vpoints. point1_other_t ,
      point1_other_v  = vpoints. point1_other_v ,
                                                
      point3_budjet_t = vpoints. point3_budjet_t,
      point3_budjet_v = vpoints. point3_budjet_v,
      point3_jkh_t    = vpoints. point3_jkh_t   ,
      point3_jkh_v    = vpoints. point3_jkh_v   ,
      point3_other_t  = vpoints. point3_other_t ,
      point3_other_v  = vpoints. point3_other_v ;


/*
  update rep_count_tbl 
  set 
      point1_sh = sum(case when phase = 1 then 1 else 0 end) ,
      point3_sh = sum(case when  phase = 2 then 1 else 0 end) 

  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,false) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section  =202 
  ) as s;
*/
  select into vsh
       sum(case when phase = 1 then 1 else 0 end) as point1_sh,
       sum(case when phase = 2 then 1 else 0 end) as point3_sh 

  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,
   ap.voltage,coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section  =202  and ap.del_abon = 0
  ) as s;

  update rep_count_tbl 
  set 
      point1_sh = vsh.point1_sh,
      point3_sh = vsh.point3_sh;


/*
  update rep_count_tbl 
  set 
      point1_noprom10k = sum(case when phase = 1 then 1 else 0 end) ,
      point3_noprom10k = sum(case when  phase = 2 then 1 else 0 end) 

  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,false) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section  in (211,213,214,215,203,204)  
   and not exists (select id_point from rep_areas_points_tbl where id_client  = ap.id_client and voltage = 4 )

  ) as s;
*/
  select into vpoint_noprom10k
       sum(case when phase = 1 then 1 else 0 end) as point1_noprom10k,
       sum(case when  phase = 2 then 1 else 0 end) as point3_noprom10k
  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section  in (211,213,214,215,203,204)  
   and  coalesce(voltage,4) not in (4,42)  and ap.del_abon = 0
--   and not exists (select id_point from rep_areas_points_tbl where id_client  = ap.id_client and voltage = 4 )
  ) as s;


  update rep_count_tbl 
  set 
      point1_noprom10k = vpoint_noprom10k.point1_noprom10k,
      point3_noprom10k = vpoint_noprom10k.point3_noprom10k;
    
  -- промышленные
/*
  update rep_count_tbl 
  set 
     abons_comp1 = sum(case when power <=100 then 1 else 0 end),
     abons_comp2 = sum(case when power <=750  and power >100 then 1 else 0 end),
     abons_comp3 = sum(case when power >750 then 1 else 0 end),
     areas_comp1 = sum(case when power <=100 then areas else 0 end),
     areas_comp2 = sum(case when power <=750  and power >100 then areas else 0 end),
     areas_comp3 = sum(case when power >750 then areas else 0 end),
     point1_comp1 = sum(case when power <=100 then points1 else 0 end),
     point1_comp2 = sum(case when power <=750  and power >100 then points1 else 0 end),
     point1_comp3 = sum(case when power >750 then points1 else 0 end),
     point3_comp1 = sum(case when power <=100 then points3 else 0 end),
     point3_comp2 = sum(case when power <=750  and power >100 then points3 else 0 end),
     point3_comp3 = sum(case when power >750 then points3 else 0 end)
    from

    (select id,power,areas,coalesce(points1,0) as points1 ,coalesce(points3,0) as points3 from  
    (
select c2.id, sum(coalesce(a.power_nom,0)) as power from
   (select tr.id_client,eqi.power_nom from  
     eqm_tree_h  as tr
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by id) as tr2 on (tr.id = tr2.id and tr2.dt = tr.dt_b)
    join (select * from eqm_eqp_tree_h order by id_tree) as ttr on (tr.id = ttr.id_tree)
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp) as ttr2 on (ttr.code_eqp = ttr2.code_eqp and ttr2.dt = ttr.dt_b)
    join eqm_compensator_h as p on (ttr.code_eqp = p.code_eqp)
    join (select code_eqp, max(dt_b) as dt from eqm_compensator_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp) as p2 on (p.code_eqp = p2.code_eqp and p2.dt = p.dt_b)
    join eqi_compensator_tbl as eqi on (eqi.id = p.id_type_eqp)
--    join eqm_compens_station_inst_h as csi on (csi.code_eqp = p.code_eqp)
--    join (select code_eqp, max(dt_b) as dt from eqm_compens_station_inst_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp) as csi2 on (csi.code_eqp = csi2.code_eqp and csi2.dt = csi.dt_b)
    join eqm_compens_station_inst_tbl as csi on (csi.code_eqp = p.code_eqp)
    join eqm_equipment_tbl as eq_inst on (csi.code_eqp_inst = eq_inst.id and eq_inst.type_eqp = 11)
      order by tr.id_client ) as a
    right join 
    (select cl.id from clm_client_tbl as cl 
     left join clm_statecl_tbl as scl on (cl.id = scl.id_client)
     where scl.id_section =201 and cl.idk_work <> 0 and cl.book=-1
     and coalesce(cl.id_state,0) not in (50,99) ) as c2
    on (c2.id = a.id_client)
--    where coalesce(p.code_eqp,0) in (select code_eqp from eqm_compens_station_inst_tbl )
    group by c2.id
    ) as s1 
   join 
   (select id_client, count( distinct coalesce(id_area,0) )  as areas from rep_areas_points_tbl group by id_client) as s2 
   on (s1.id  = s2.id_client)
   left join 
   (select id_client, count( distinct id_point )  as points1 from rep_areas_points_tbl 
   where phase = 1 group by id_client) as s3 
   on (s1.id  = s3.id_client)
   left join 
   (select id_client, count( distinct id_point )  as points3 from rep_areas_points_tbl 
   where phase = 2 group by id_client) as s4 
   on (s1.id  = s4.id_client)
   ) as sss;
*/  

   raise notice ''prom'';

   delete from rep_count_prom_power_tbl;

   if (select getsysvar(''kod_res'')) = 310 then

    insert into rep_count_prom_power_tbl
     select c2.id, sum(coalesce(p.connect_power,p.power,0)) as power 
     from rep_areas_points_tbl as ap join 
     (select cl.id from clm_client_tbl as cl 
      left join clm_statecl_tbl as scl on (cl.id = scl.id_client)
      where scl.id_section =201 and cl.idk_work not in (0,99) and cl.book=-1
      and coalesce(cl.id_state,0) not in (50,99) ) as c2
     on (c2.id = ap.id_client)
    join eqm_point_h as p on (ap.id_point = p.code_eqp)
    join (select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp) as p2 on (p.code_eqp = p2.code_eqp and p2.dt = p.dt_b)
    group by c2.id order by c2.id;

   else

    insert into rep_count_prom_power_tbl
    select c2.id, sum(coalesce(a.power_nom,0)) as power from
    (select tr.id_client,eqi.power_nom from  
      eqm_tree_h  as tr
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by id order by id) as tr2 on (tr.id = tr2.id and tr2.dt = tr.dt_b)
     join (select * from eqm_eqp_tree_h order by id_tree) as ttr on (tr.id = ttr.id_tree)
     join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp) as ttr2 on (ttr.code_eqp = ttr2.code_eqp and ttr2.dt = ttr.dt_b)
     join eqm_compensator_h as p on (ttr.code_eqp = p.code_eqp)
     join (select code_eqp, max(dt_b) as dt from eqm_compensator_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp) as p2 on (p.code_eqp = p2.code_eqp and p2.dt = p.dt_b)
     join eqi_compensator_tbl as eqi on (eqi.id = p.id_type_eqp)
     join
     (select inst.code_eqp, inst.code_eqp_inst from eqm_compens_station_inst_h as inst 
      join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt 
           group by code_eqp, code_eqp_inst order by  code_eqp, code_eqp_inst) as inst2 
           on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b) 
      join eqm_equipment_tbl as eq_inst on (inst.code_eqp_inst = eq_inst.id and eq_inst.type_eqp = 11) 
     ) as csi on (csi.code_eqp = p.code_eqp) 
    order by tr.id_client ) as a
     right join 
     (select cl.id from clm_client_tbl as cl 
      left join clm_statecl_tbl as scl on (cl.id = scl.id_client)
      where scl.id_section =201 and cl.idk_work not in (0,99) and cl.book=-1
      and coalesce(cl.id_state,0) not in (50,99) ) as c2
     on (c2.id = a.id_client)
     group by c2.id;

   end if;


  select into vprom 
       sum(case when power <=100 then 1 else 0 end) as abons_comp1,
       sum(case when power <=750  and power >100 then 1 else 0 end) as abons_comp2, 
       sum(case when power >750 then 1 else 0 end) as abons_comp3 ,
       sum(case when power <=100 then areas else 0 end) as areas_comp1,
       sum(case when power <=750  and power >100 then areas else 0 end) as areas_comp2,
       sum(case when power >750 then areas else 0 end) as areas_comp3, 
       sum(case when power <=100 then points1 else 0 end) as point1_comp1,
       sum(case when power <=750  and power >100 then points1 else 0 end) as point1_comp2,
       sum(case when power >750 then points1 else 0 end) as point1_comp3,
       sum(case when power <=100 then points3 else 0 end) as point3_comp1,
       sum(case when power <=750  and power >100 then points3 else 0 end) as point3_comp2,
       sum(case when power >750 then points3 else 0 end) as point3_comp3
    from
    (select s1.id_client,s1.power,areas,coalesce(points1,0) as points1 ,coalesce(points3,0) as points3 from  
     rep_count_prom_power_tbl as s1 
     left join 
     (select id_client, count( distinct coalesce(id_area,0) ) as areas from rep_areas_points_tbl where del_abon = 0 group by id_client order by id_client) as s2 
     on (s1.id_client  = s2.id_client)
     left join 
     (select id_client, count( distinct id_point )  as points1 from rep_areas_points_tbl 
     where coalesce(phase,2) = 1  and del_abon = 0 group by id_client order by id_client) as s3 
     on (s1.id_client  = s3.id_client)
     left join 
     (select id_client, count( distinct id_point )  as points3 from rep_areas_points_tbl 
     where coalesce(phase,2) = 2  and del_abon = 0 group by id_client order by id_client) as s4 
     on (s1.id_client  = s4.id_client)
   ) as sss;

     raise notice ''prom end'';

  update rep_count_tbl 
  set 
     abons_comp1  = vprom.abons_comp1, 
     abons_comp2  = vprom.abons_comp2,
     abons_comp3  = vprom.abons_comp3, 
     areas_comp1  = vprom.areas_comp1, 
     areas_comp2  = vprom.areas_comp2, 
     areas_comp3  = vprom.areas_comp3, 
     point1_comp1 = vprom.point1_comp1,
     point1_comp2 = vprom.point1_comp2,
     point1_comp3 = vprom.point1_comp3,
     point3_comp1 = vprom.point3_comp1,
     point3_comp2 = vprom.point3_comp2,
     point3_comp3 = vprom.point3_comp3;


  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          



----------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION res_include_fun(numeric,numeric)
  RETURNS numeric AS
'
  declare
  p1 alias for $1; 
  p2 alias for $2; 
  begin
--   raise notice ''%'',p1;
--   raise notice ''%'',p2;
   
   if (p1 = 1 ) then
     RETURN 1;
   end if;
  
   if (p2 = (select value_ident from syi_sysvars_tbl where ident=''id_res'') or (p2 is null) ) then
     RETURN 1;
   else
     RETURN 0;
   end if;
  end;
'
  LANGUAGE 'plpgsql' VOLATILE;


  CREATE AGGREGATE res_include (BASETYPE = numeric,
                         SFUNC = res_include_fun,
                         STYPE = numeric,
                         INITCOND = 0 );


------------------------------------------------------------------------------------------
  CREATE or replace FUNCTION rep_abon_count_volt_fun(date)
  RETURNS int
  AS                                                                                              
  '
  declare
   pdt Alias for $1;

   vareas record;
   vabons record;
   vabons_sh record;
   vareas_sh record;
   vrep_count record;
   vdef_addr_type bool;
   vsh record;
   vnp record;
   vp record;
   vabons_p record;
   vareas_p record;

  begin

   delete from rep_count_volt_tbl;

    if (select getsysvar(''kod_res'')) = 310 then
      vdef_addr_type :=true;
    else
      vdef_addr_type :=false;
    end if;


   perform rep_abon_count_fun(pdt,1);

   select into vrep_count * from rep_count_tbl ;

   insert into rep_count_volt_tbl(mmgg,point_budjet03_t,point_jkh03_t,point_other03_t,point_budjet03_v,point_jkh03_v,point_other03_v,point_budjet02_t,
    point_jkh02_t,point_other02_t,point_budjet02_v,point_jkh02_v,point_other02_v )
   select pdt,point3_budjet_t,point3_jkh_t,point3_other_t,point3_budjet_v,point3_jkh_v,point3_other_v,point1_budjet_t,point1_jkh_t,point1_other_t,point1_budjet_v,
    point1_jkh_v,point1_other_v
   from rep_count_tbl ;

  -- Площадки с 3 - зонными

  raise notice '' areas nopron<1000 '';

  select into vareas sum(case when id_section in (211,213,214,215) and is_town =true then 1 else 0 end) as areas_budjet_t,
       sum(case when id_section in (211,213,214,215) and is_town =false then 1 else 0 end) as areas_budjet_v,
       sum(case when id_section in (203) and is_town =true then 1 else 0 end) as areas_jkh_t,
       sum(case when id_section in (203) and is_town =false then 1 else 0 end) as areas_jkh_v,
       sum(case when id_section in (204) and is_town =true then 1 else 0 end) as areas_other_t,
       sum(case when id_section in (204) and is_town =false then 1 else 0 end) as areas_other_v 
  from
  (select distinct ap.id_client,ap.id_area ,ap.is_town ,scl.id_section 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section not in (205,206,207,208)  and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) not in (4,42) )
   and exists (select ap3.id_point from rep_areas_points_tbl as ap3 where ap3.id_client  = ap.id_client and ap3.id_area = ap.id_area and coalesce(ap3.phase,1) = 2 )
  ) as s;

  update rep_count_volt_tbl
  set 
      areas_budjet03_t 	= vareas.areas_budjet_t,
      areas_budjet03_v 	= vareas.areas_budjet_v,
      areas_jkh03_t 	= vareas.areas_jkh_t ,
      areas_jkh03_v 	= vareas.areas_jkh_v ,
      areas_other03_t 	= vareas.areas_other_t ,
      areas_other03_v 	= vareas.areas_other_v ,
      areas_budjet02_t 	= vrep_count.areas_budjet_t - vareas.areas_budjet_t,
      areas_budjet02_v 	= vrep_count.areas_budjet_v - vareas.areas_budjet_v,
      areas_jkh02_t 	= vrep_count.areas_jkh_t - vareas.areas_jkh_t ,
      areas_jkh02_v 	= vrep_count.areas_jkh_v - vareas.areas_jkh_v ,
      areas_other02_t 	= vrep_count.areas_other_t - vareas.areas_other_t ,
      areas_other02_v 	= vrep_count.areas_other_v - vareas.areas_other_v ;


  --абоненты непром до 1000В с 3-зонными

  raise notice '' abons nopron<1000 '';

  select into vabons
  sum(case when scl.id_section in (211,213,214,215) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_budjet_t,
  sum(case when scl.id_section in (211,213,214,215) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_budjet_v,
  sum(case when scl.id_section in (203) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_jkh_t,
  sum(case when scl.id_section in (203) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_jkh_v,
  sum(case when scl.id_section in (204) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_other_t,
  sum(case when scl.id_section in (204) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_other_v

  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section not in (205,206,207,208) and c.idk_work not in (0,99) and c.book=-1
  and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(phase,1) = 2 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) not in (4,42) );


  update rep_count_volt_tbl
  set 
      abons_budjet03_t 	= vabons.abons_budjet_t,
      abons_budjet03_v 	= vabons.abons_budjet_v,
      abons_jkh03_t 	= vabons.abons_jkh_t ,
      abons_jkh03_v 	= vabons.abons_jkh_v ,
      abons_other03_t 	= vabons.abons_other_t ,
      abons_other03_v 	= vabons.abons_other_v ,
      abons_budjet02_t 	= vrep_count.abons_budjet_t - vabons.abons_budjet_t,
      abons_budjet02_v 	= vrep_count.abons_budjet_v - vabons.abons_budjet_v,
      abons_jkh02_t 	= vrep_count.abons_jkh_t - vabons.abons_jkh_t ,
      abons_jkh02_v 	= vrep_count.abons_jkh_v - vabons.abons_jkh_v ,
      abons_other02_t 	= vrep_count.abons_other_t - vabons.abons_other_t ,
      abons_other02_v 	= vrep_count.abons_other_v - vabons.abons_other_v ;


  --110 

  raise notice '' sh 110 '';

  select into vabons_sh 
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_sh_t,
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_sh_v,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_np_t,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_np_v
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where --scl.id_section = 202 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12) );

  update rep_count_volt_tbl set abons_sh_110_t = coalesce(vabons_sh.abons_sh_t,0), 
                                abons_sh_110_v = coalesce(vabons_sh.abons_sh_v,0) ,
				abons_nopr_110_t = coalesce(vabons_sh.abons_np_t,0),
				abons_nopr_110_v = coalesce(vabons_sh.abons_np_v,0);
            
  select into vareas_sh  
  sum(case when id_section = 202 and is_town =true then 1 else 0 end) as areas_sh_t,
  sum(case when id_section = 202 and is_town =false then 1 else 0 end) as areas_sh_v,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =true then 1 else 0 end) as areas_np_t,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =false then 1 else 0 end) as areas_np_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where --scl.id_section =202 and 
   coalesce(ap.voltage,4) in (1,11,12)  and ap.del_abon = 0 
  ) as s;

  update rep_count_volt_tbl set areas_sh_110_t = coalesce(vareas_sh.areas_sh_t,0), 
                                areas_sh_110_v = coalesce(vareas_sh.areas_sh_v,0),
				areas_nopr_110_t = coalesce(vareas_sh.areas_np_t,0) , 
				areas_nopr_110_v = coalesce(vareas_sh.areas_np_v,0) ;


  --35 

  raise notice '' sh 35 '';

  select into vabons_sh 
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_sh_t,
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_sh_v,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_np_t,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_np_v
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where --scl.id_section = 202 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (2,21) )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12) );

  update rep_count_volt_tbl set abons_sh_35_t = coalesce(vabons_sh.abons_sh_t,0), 
                                abons_sh_35_v = coalesce(vabons_sh.abons_sh_v,0),
				abons_nopr_35_t = coalesce(vabons_sh.abons_np_t,0),
				abons_nopr_35_v = coalesce(vabons_sh.abons_np_v,0);


  select into vareas_sh  
  sum(case when id_section = 202 and is_town =true then 1 else 0 end) as areas_sh_t,
  sum(case when id_section = 202 and is_town =false then 1 else 0 end) as areas_sh_v,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =true then 1 else 0 end) as areas_np_t,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =false then 1 else 0 end) as areas_np_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where --scl.id_section =202 and 
   coalesce(ap.voltage,4) in (2,21)
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12) )
  ) as s;

  update rep_count_volt_tbl set areas_sh_35_t = coalesce(vareas_sh.areas_sh_t,0), 
                                areas_sh_35_v = coalesce(vareas_sh.areas_sh_v,0),
				areas_nopr_35_t = coalesce(vareas_sh.areas_np_t,0) , 
				areas_nopr_35_v = coalesce(vareas_sh.areas_np_v,0) ;

  --10 
  raise notice '' sh 10 '';

  select into vabons_sh 
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_sh_t,
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_sh_v,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_np_t,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_np_v

  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where --pscl.id_section = 202 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) = 3 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12,2,21) );

  update rep_count_volt_tbl set abons_sh_10_t = coalesce(vabons_sh.abons_sh_t,0), 
                                abons_sh_10_v = coalesce(vabons_sh.abons_sh_v,0), 
				abons_nopr_10_t = coalesce(vabons_sh.abons_np_t,0),
				abons_nopr_10_v = coalesce(vabons_sh.abons_np_v,0);


  select into vareas_sh  
  sum(case when id_section = 202 and is_town =true then 1 else 0 end) as areas_sh_t,
  sum(case when id_section = 202 and is_town =false then 1 else 0 end) as areas_sh_v,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =true then 1 else 0 end) as areas_np_t,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =false then 1 else 0 end) as areas_np_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where --scl.id_section =202 and 
   coalesce(ap.voltage,4) =3  and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21) )
  ) as s;

  update rep_count_volt_tbl set areas_sh_10_t = coalesce(vareas_sh.areas_sh_t,0), 
                                areas_sh_10_v = coalesce(vareas_sh.areas_sh_v,0),
				areas_nopr_10_t = coalesce(vareas_sh.areas_np_t,0) , 
				areas_nopr_10_v = coalesce(vareas_sh.areas_np_v,0) ;
 

  --6 

  raise notice '' sh 6 '';

  select into vabons_sh 
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_sh_t,
  sum(case when scl.id_section = 202 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_sh_v,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_np_t,
  sum(case when scl.id_section in (211,213,214,215,203,204,209) and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_np_v

  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where --scl.id_section = 202 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in( 31,32) )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12,2,21,3) );

  update rep_count_volt_tbl set abons_sh_6_t = coalesce(vabons_sh.abons_sh_t,0), 
                                abons_sh_6_v = coalesce(vabons_sh.abons_sh_v,0),
				abons_nopr_6_t = coalesce(vabons_sh.abons_np_t,0),
				abons_nopr_6_v = coalesce(vabons_sh.abons_np_v,0);
 


  select into vareas_sh  
  sum(case when id_section = 202 and is_town =true then 1 else 0 end) as areas_sh_t,
  sum(case when id_section = 202 and is_town =false then 1 else 0 end) as areas_sh_v,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =true then 1 else 0 end) as areas_np_t,
  sum(case when id_section in (211,213,214,215,203,204,209) and is_town =false then 1 else 0 end) as areas_np_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where --scl.id_section =202 and 
   coalesce(ap.voltage,4) in (31,32) and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21,3) )
  ) as s;

  update rep_count_volt_tbl set areas_sh_6_t = coalesce(vareas_sh.areas_sh_t,0), 
                                areas_sh_6_v = coalesce(vareas_sh.areas_sh_v,0) ,
				areas_nopr_6_t = coalesce(vareas_sh.areas_np_t,0) , 
				areas_nopr_6_v = coalesce(vareas_sh.areas_np_v,0) ;


  --0.3 

  raise notice '' sh 03 '';

  select into vabons_sh 
  sum(case when coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_sh_t,
  sum(case when coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_sh_v
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 202 and c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (4,42) and coalesce(phase,1) = 2 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12,2,21,3,31,32) );

  update rep_count_volt_tbl set abons_sh_03_t = coalesce(vabons_sh.abons_sh_t,0), 
                           abons_sh_03_v = coalesce(vabons_sh.abons_sh_v,0) ;


  select into vareas_sh  
  sum(case when is_town =true then 1 else 0 end) as areas_sh_t,
  sum(case when is_town =false then 1 else 0 end) as areas_sh_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =202  and ap.del_abon = 0  
   and coalesce(ap.voltage,4) in (4,42) and coalesce(ap.phase,1) = 2  
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21,3,31,32) )
  ) as s;

  update rep_count_volt_tbl set areas_sh_03_t = coalesce(vareas_sh.areas_sh_t,0), 
                           areas_sh_03_v = coalesce(vareas_sh.areas_sh_v,0) ;

  --0.2 

  raise notice '' sh 02 '';

  select into vabons_sh 
  sum(case when coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons_sh_t,
  sum(case when coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons_sh_v
  from clm_client_tbl as c 
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 202 and c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (4,42) and coalesce(phase,1) = 1 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and (coalesce(voltage,4) in (1,11,12,2,21,3,31,32) or coalesce(phase,1) = 2) );

  update rep_count_volt_tbl set abons_sh_02_t =coalesce(vabons_sh.abons_sh_t,0), 
                           abons_sh_02_v = coalesce(vabons_sh.abons_sh_v,0) ;


  select into vareas_sh  
  sum(case when is_town =true then 1 else 0 end) as areas_sh_t,
  sum(case when is_town =false then 1 else 0 end) as areas_sh_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =202  and ap.del_abon = 0  
   and coalesce(ap.voltage,4) in (4,42) and coalesce(ap.phase,1) = 1  
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and (coalesce(ap2.voltage,4) in (1,11,12,2,21,3,31,32) or coalesce(ap2.phase,1) = 2) )
  ) as s;

  update rep_count_volt_tbl set areas_sh_02_t = coalesce(vareas_sh.areas_sh_t,0), 
                           areas_sh_02_v = coalesce(vareas_sh.areas_sh_v,0) ;

  ----------------

  raise notice '' points sh '';

  select into vsh
       sum(case when is_town = true and voltage in (1,11,12) then 1 else 0 end) as sh_110_t,
       sum(case when is_town = true and voltage in (2,21) then 1 else 0 end) as sh_35_t,
       sum(case when is_town = true and voltage =3 then 1 else 0 end) as sh_10_t,
       sum(case when is_town = true and voltage in (31,32) then 1 else 0 end) as sh_6_t,
       sum(case when is_town = true and voltage in (4,42) and phase = 2 then 1 else 0 end) as sh_03_t,
       sum(case when is_town = true and voltage in (4,42) and phase = 1 then 1 else 0 end) as sh_02_t, 
       sum(case when is_town = false and voltage in (1,11,12) then 1 else 0 end) as sh_110_v,
       sum(case when is_town = false and voltage in (2,21) then 1 else 0 end) as sh_35_v,
       sum(case when is_town = false and voltage =3 then 1 else 0 end) as sh_10_v,
       sum(case when is_town = false and voltage in (31,32) then 1 else 0 end) as sh_6_v,
       sum(case when is_town = false and voltage in (4,42) and phase = 2 then 1 else 0 end) as sh_03_v,
       sum(case when is_town = false and voltage in (4,42) and phase = 1 then 1 else 0 end) as sh_02_v 
  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,
   coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section, coalesce(ap.voltage,4) as voltage 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section  =202  and ap.del_abon = 0 
  ) as s;

  update rep_count_volt_tbl
  set 
      point_sh_110_t = vsh.sh_110_t,
      point_sh_35_t = vsh.sh_35_t,
      point_sh_10_t = vsh.sh_10_t,
      point_sh_6_t = vsh.sh_6_t,
      point_sh_03_t = vsh.sh_03_t,
      point_sh_02_t = vsh.sh_02_t,
      point_sh_110_v = vsh.sh_110_v,
      point_sh_35_v = vsh.sh_35_v,
      point_sh_10_v = vsh.sh_10_v,
      point_sh_6_v = vsh.sh_6_v,
      point_sh_03_v = vsh.sh_03_v,
      point_sh_02_v = vsh.sh_02_v;


  raise notice '' points noprom '';

  select into vnp
       sum(case when is_town = true and voltage in (1,11,12) then 1 else 0 end) as np_110_t,
       sum(case when is_town = true and voltage in (2,21) then 1 else 0 end) 	as np_35_t,
       sum(case when is_town = true and voltage =3 then 1 else 0 end) 		as np_10_t,
       sum(case when is_town = true and voltage in (31,32) then 1 else 0 end) 	as np_6_t,
       sum(case when is_town = true and voltage in (4,42) and phase = 2 then 1 else 0 end) as np_03_t,
       sum(case when is_town = true and voltage in (4,42) and phase = 1 then 1 else 0 end) as np_02_t, 
       sum(case when is_town = false and voltage in (1,11,12) then 1 else 0 end)    as np_110_v,
       sum(case when is_town = false and voltage in (2,21) then 1 else 0 end) 	as np_35_v,
       sum(case when is_town = false and voltage =3 then 1 else 0 end) 		as np_10_v,
       sum(case when is_town = false and voltage in (31,32) then 1 else 0 end)  as np_6_v,
       sum(case when is_town = false and voltage in (4,42) and phase = 2 then 1 else 0 end) as np_03_v,
       sum(case when is_town = false and voltage in (4,42) and phase = 1 then 1 else 0 end) as np_02_v 
  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section, coalesce(ap.voltage,4) as voltage 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section  in (211,213,214,215,203,204,209)  and ap.del_abon = 0 
  ) as s;

  update rep_count_volt_tbl
  set 
      point_nopr_110_t = vnp.np_110_t,
      point_nopr_35_t =  vnp.np_35_t,
      point_nopr_10_t =  vnp.np_10_t,
      point_nopr_6_t =   vnp.np_6_t,
      point_nopr_03_t =  vnp.np_03_t,
      point_nopr_02_t =  vnp.np_02_t,
      point_nopr_110_v = vnp.np_110_v,
      point_nopr_35_v =  vnp.np_35_v,
      point_nopr_10_v =  vnp.np_10_v,
      point_nopr_6_v =   vnp.np_6_v,
      point_nopr_03_v =  vnp.np_03_v,
      point_nopr_02_v =  vnp.np_02_v;


  -- промышленные 
  raise notice '' points prom '';

  select into vp
       sum(case when power <=100 and is_town = true and voltage in (1,11,12) then 1 else 0 end) as p1_110_t,
       sum(case when power <=100 and is_town = true and voltage in (2,21) then 1 else 0 end) 	as p1_35_t,
       sum(case when power <=100 and is_town = true and voltage =3 then 1 else 0 end) 		as p1_10_t,
       sum(case when power <=100 and is_town = true and voltage in (31,32) then 1 else 0 end) 	as p1_6_t,
       sum(case when power <=100 and is_town = true and voltage in (4,42) and phase = 2 then 1 else 0 end) as p1_03_t,
       sum(case when power <=100 and is_town = true and voltage in (4,42) and phase = 1 then 1 else 0 end) as p1_02_t, 
       sum(case when power <=100 and is_town = false and voltage in (1,11,12) then 1 else 0 end)    as p1_110_v,
       sum(case when power <=100 and is_town = false and voltage in (2,21) then 1 else 0 end) 	as p1_35_v,
       sum(case when power <=100 and is_town = false and voltage =3 then 1 else 0 end) 		as p1_10_v,
       sum(case when power <=100 and is_town = false and voltage in (31,32) then 1 else 0 end)  as p1_6_v,
       sum(case when power <=100 and is_town = false and voltage in (4,42) and phase = 2 then 1 else 0 end) as p1_03_v,
       sum(case when power <=100 and is_town = false and voltage in (4,42) and phase = 1 then 1 else 0 end) as p1_02_v, 

       sum(case when power <=750  and power >100 and is_town = true and voltage in (1,11,12) then 1 else 0 end) as p2_110_t,
       sum(case when power <=750  and power >100 and is_town = true and voltage in (2,21) then 1 else 0 end) 	as p2_35_t,
       sum(case when power <=750  and power >100 and is_town = true and voltage =3 then 1 else 0 end) 		as p2_10_t,
       sum(case when power <=750  and power >100 and is_town = true and voltage in (31,32) then 1 else 0 end) 	as p2_6_t,
       sum(case when power <=750  and power >100 and is_town = true and voltage in (4,42) and phase = 2 then 1 else 0 end) as p2_03_t,
       sum(case when power <=750  and power >100 and is_town = true and voltage in (4,42) and phase = 1 then 1 else 0 end) as p2_02_t, 
       sum(case when power <=750  and power >100 and is_town = false and voltage in (1,11,12) then 1 else 0 end)    as p2_110_v,
       sum(case when power <=750  and power >100 and is_town = false and voltage in (2,21) then 1 else 0 end) 	as p2_35_v,
       sum(case when power <=750  and power >100 and is_town = false and voltage =3 then 1 else 0 end) 		as p2_10_v,
       sum(case when power <=750  and power >100 and is_town = false and voltage in (31,32) then 1 else 0 end)  as p2_6_v,
       sum(case when power <=750  and power >100 and is_town = false and voltage in (4,42) and phase = 2 then 1 else 0 end) as p2_03_v,
       sum(case when power <=750  and power >100 and is_town = false and voltage in (4,42) and phase = 1 then 1 else 0 end) as p2_02_v, 

       sum(case when power >750 and is_town = true and voltage in (1,11,12) then 1 else 0 end) as p3_110_t,
       sum(case when power >750 and is_town = true and voltage in (2,21) then 1 else 0 end) 	as p3_35_t,
       sum(case when power >750 and is_town = true and voltage =3 then 1 else 0 end) 		as p3_10_t,
       sum(case when power >750 and is_town = true and voltage in (31,32) then 1 else 0 end) 	as p3_6_t,
       sum(case when power >750 and is_town = true and voltage in (4,42) and phase = 2 then 1 else 0 end) as p3_03_t,
       sum(case when power >750 and is_town = true and voltage in (4,42) and phase = 1 then 1 else 0 end) as p3_02_t, 
       sum(case when power >750 and is_town = false and voltage in (1,11,12) then 1 else 0 end)    as p3_110_v,
       sum(case when power >750 and is_town = false and voltage in (2,21) then 1 else 0 end) 	as p3_35_v,
       sum(case when power >750 and is_town = false and voltage =3 then 1 else 0 end) 		as p3_10_v,
       sum(case when power >750 and is_town = false and voltage in (31,32) then 1 else 0 end)  as p3_6_v,
       sum(case when power >750 and is_town = false and voltage in (4,42) and phase = 2 then 1 else 0 end) as p3_03_v,
       sum(case when power >750 and is_town = false and voltage in (4,42) and phase = 1 then 1 else 0 end) as p3_02_v 

  from
  (select distinct ap.id_client,ap.id_area,ap.id_point,ap.phase,coalesce(ap.is_town ,vdef_addr_type) as is_town,scl.id_section, coalesce(ap.voltage,4) as voltage , pp.power
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   where scl.id_section  = 201  and ap.del_abon = 0 
  ) as s;

  update rep_count_volt_tbl
  set 
      point_comp1_110_t = vp.p1_110_t,
      point_comp1_35_t =  vp.p1_35_t,
      point_comp1_10_t =  vp.p1_10_t,
      point_comp1_6_t =   vp.p1_6_t,
      point_comp1_03_t =  vp.p1_03_t,
      point_comp1_02_t =  vp.p1_02_t,
      point_comp1_110_v = vp.p1_110_v,
      point_comp1_35_v =  vp.p1_35_v,
      point_comp1_10_v =  vp.p1_10_v,
      point_comp1_6_v =   vp.p1_6_v,
      point_comp1_03_v =  vp.p1_03_v,
      point_comp1_02_v =  vp.p1_02_v,

      point_comp2_110_t = vp.p2_110_t,
      point_comp2_35_t =  vp.p2_35_t,
      point_comp2_10_t =  vp.p2_10_t,
      point_comp2_6_t =   vp.p2_6_t,
      point_comp2_03_t =  vp.p2_03_t,
      point_comp2_02_t =  vp.p2_02_t,
      point_comp2_110_v = vp.p2_110_v,
      point_comp2_35_v =  vp.p2_35_v,
      point_comp2_10_v =  vp.p2_10_v,
      point_comp2_6_v =   vp.p2_6_v,
      point_comp2_03_v =  vp.p2_03_v,
      point_comp2_02_v =  vp.p2_02_v,

      point_comp3_110_t = vp.p3_110_t,
      point_comp3_35_t =  vp.p3_35_t,
      point_comp3_10_t =  vp.p3_10_t,
      point_comp3_6_t =   vp.p3_6_t,
      point_comp3_03_t =  vp.p3_03_t,
      point_comp3_02_t =  vp.p3_02_t,
      point_comp3_110_v = vp.p3_110_v,
      point_comp3_35_v =  vp.p3_35_v,
      point_comp3_10_v =  vp.p3_10_v,
      point_comp3_6_v =   vp.p3_6_v,
      point_comp3_03_v =  vp.p3_03_v,
      point_comp3_02_v =  vp.p3_02_v;



  --110 

  raise notice '' abons prom 110'';

  select into vabons_p 
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons1_t,
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons1_v,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons2_t,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons2_v,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons3_t,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons3_v
  from clm_client_tbl as c 
  left join rep_count_prom_power_tbl as pp on (pp.id_client = c.id)
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 201 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12) );

  update rep_count_volt_tbl set abons_comp1_110_t = coalesce(vabons_p.abons1_t,0), 
                                abons_comp1_110_v = coalesce(vabons_p.abons1_v,0),
				abons_comp2_110_t = coalesce(vabons_p.abons2_t,0),
				abons_comp2_110_v = coalesce(vabons_p.abons2_v,0),
				abons_comp3_110_t = coalesce(vabons_p.abons3_t,0),
				abons_comp3_110_v = coalesce(vabons_p.abons3_v,0);

            
  raise notice '' areas prom 110'';

  select into vareas_p  
  sum(case when power <=100 and is_town =true then 1 else 0 end) as areas1_t,
  sum(case when power <=100 and is_town =false then 1 else 0 end) as areas1_v,
  sum(case when power <=750 and power >100 and is_town =true then 1 else 0 end) as areas2_t,
  sum(case when power <=750 and power >100 and is_town =false then 1 else 0 end) as areas2_v,
  sum(case when power >750 and is_town =true then 1 else 0 end) as areas3_t,
  sum(case when power >750 and is_town =false then 1 else 0 end) as areas3_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section ,pp.power
   from rep_areas_points_tbl as ap
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =201 and coalesce(ap.voltage,4) in (1,11,12)
   and ap.del_abon = 0 
  ) as s;

  update rep_count_volt_tbl set areas_comp1_110_t = coalesce(vareas_p.areas1_t,0), 
                                areas_comp1_110_v = coalesce(vareas_p.areas1_v,0),
				areas_comp2_110_t = coalesce(vareas_p.areas2_t,0), 
				areas_comp2_110_v = coalesce(vareas_p.areas2_v,0),
				areas_comp3_110_t = coalesce(vareas_p.areas3_t,0), 
				areas_comp3_110_v = coalesce(vareas_p.areas3_v,0);

  --35 

  raise notice '' abons prom 35'';

  select into vabons_p 
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons1_t,
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons1_v,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons2_t,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons2_v,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons3_t,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons3_v
  from clm_client_tbl as c 
  left join rep_count_prom_power_tbl as pp on (pp.id_client = c.id)
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 201 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (2,21) )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12) );

  update rep_count_volt_tbl set abons_comp1_35_t = coalesce(vabons_p.abons1_t,0), 
                                abons_comp1_35_v = coalesce(vabons_p.abons1_v,0),
				abons_comp2_35_t = coalesce(vabons_p.abons2_t,0),
				abons_comp2_35_v = coalesce(vabons_p.abons2_v,0),
				abons_comp3_35_t = coalesce(vabons_p.abons3_t,0),
				abons_comp3_35_v = coalesce(vabons_p.abons3_v,0);

  raise notice '' areas prom 35'';

  select into vareas_p  
  sum(case when power <=100 and is_town =true then 1 else 0 end) as areas1_t,
  sum(case when power <=100 and is_town =false then 1 else 0 end) as areas1_v,
  sum(case when power <=750 and power >100 and is_town =true then 1 else 0 end) as areas2_t,
  sum(case when power <=750 and power >100 and is_town =false then 1 else 0 end) as areas2_v,
  sum(case when power >750 and is_town =true then 1 else 0 end) as areas3_t,
  sum(case when power >750 and is_town =false then 1 else 0 end) as areas3_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section ,pp.power
   from rep_areas_points_tbl as ap
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where --scl.id_section =202 and 
   coalesce(ap.voltage,4) in (2,21) and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12) )
  ) as s;

  update rep_count_volt_tbl set areas_comp1_35_t = coalesce(vareas_p.areas1_t,0), 
                                areas_comp1_35_v = coalesce(vareas_p.areas1_v,0),
				areas_comp2_35_t = coalesce(vareas_p.areas2_t,0), 
				areas_comp2_35_v = coalesce(vareas_p.areas2_v,0),
				areas_comp3_35_t = coalesce(vareas_p.areas3_t,0), 
				areas_comp3_35_v = coalesce(vareas_p.areas3_v,0);

  --10 

  raise notice '' abons prom 10'';

  select into vabons_p 
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons1_t,
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons1_v,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons2_t,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons2_v,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons3_t,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons3_v
  from clm_client_tbl as c 
  left join rep_count_prom_power_tbl as pp on (pp.id_client = c.id)
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 201 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) = 3 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12,2,21) );

  update rep_count_volt_tbl set abons_comp1_10_t = coalesce(vabons_p.abons1_t,0), 
                                abons_comp1_10_v = coalesce(vabons_p.abons1_v,0),
				abons_comp2_10_t = coalesce(vabons_p.abons2_t,0),
				abons_comp2_10_v = coalesce(vabons_p.abons2_v,0),
				abons_comp3_10_t = coalesce(vabons_p.abons3_t,0),
				abons_comp3_10_v = coalesce(vabons_p.abons3_v,0);

  raise notice '' areas prom 10'';

  select into vareas_p  
  sum(case when power <=100 and is_town =true then 1 else 0 end) as areas1_t,
  sum(case when power <=100 and is_town =false then 1 else 0 end) as areas1_v,
  sum(case when power <=750 and power >100 and is_town =true then 1 else 0 end) as areas2_t,
  sum(case when power <=750 and power >100 and is_town =false then 1 else 0 end) as areas2_v,
  sum(case when power >750 and is_town =true then 1 else 0 end) as areas3_t,
  sum(case when power >750 and is_town =false then 1 else 0 end) as areas3_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section ,pp.power
   from rep_areas_points_tbl as ap
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =201 and 
   coalesce(ap.voltage,4) =3  and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21) )
  ) as s;

  update rep_count_volt_tbl set areas_comp1_10_t = coalesce(vareas_p.areas1_t,0), 
                                areas_comp1_10_v = coalesce(vareas_p.areas1_v,0),
				areas_comp2_10_t = coalesce(vareas_p.areas2_t,0), 
				areas_comp2_10_v = coalesce(vareas_p.areas2_v,0),
				areas_comp3_10_t = coalesce(vareas_p.areas3_t,0), 
				areas_comp3_10_v = coalesce(vareas_p.areas3_v,0);
 

  --6 
  raise notice '' abons prom 6'';

  select into vabons_p 
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons1_t,
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons1_v,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons2_t,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons2_v,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons3_t,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons3_v
  from clm_client_tbl as c 
  left join rep_count_prom_power_tbl as pp on (pp.id_client = c.id)
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 201 and
  c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in( 31,32) )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12,2,21,3) );

  update rep_count_volt_tbl set abons_comp1_6_t = coalesce(vabons_p.abons1_t,0), 
                                abons_comp1_6_v = coalesce(vabons_p.abons1_v,0),
				abons_comp2_6_t = coalesce(vabons_p.abons2_t,0),
				abons_comp2_6_v = coalesce(vabons_p.abons2_v,0),
				abons_comp3_6_t = coalesce(vabons_p.abons3_t,0),
				abons_comp3_6_v = coalesce(vabons_p.abons3_v,0);
 
  raise notice '' areas prom 6'';

  select into vareas_p  
  sum(case when power <=100 and is_town =true then 1 else 0 end) as areas1_t,
  sum(case when power <=100 and is_town =false then 1 else 0 end) as areas1_v,
  sum(case when power <=750 and power >100 and is_town =true then 1 else 0 end) as areas2_t,
  sum(case when power <=750 and power >100 and is_town =false then 1 else 0 end) as areas2_v,
  sum(case when power >750 and is_town =true then 1 else 0 end) as areas3_t,
  sum(case when power >750 and is_town =false then 1 else 0 end) as areas3_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town , scl.id_section,pp.power
   from rep_areas_points_tbl as ap
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =201 and 
   coalesce(ap.voltage,4) in (31,32)  and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21,3) )
  ) as s;

  update rep_count_volt_tbl set areas_comp1_6_t = coalesce(vareas_p.areas1_t,0), 
                                areas_comp1_6_v = coalesce(vareas_p.areas1_v,0),
				areas_comp2_6_t = coalesce(vareas_p.areas2_t,0), 
				areas_comp2_6_v = coalesce(vareas_p.areas2_v,0),
				areas_comp3_6_t = coalesce(vareas_p.areas3_t,0), 
				areas_comp3_6_v = coalesce(vareas_p.areas3_v,0);


  --0.3 
  raise notice '' abons prom 0.3'';

  select into vabons_p 
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons1_t,
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons1_v,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons2_t,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons2_v,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons3_t,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons3_v
  from clm_client_tbl as c 
  left join rep_count_prom_power_tbl as pp on (pp.id_client = c.id)
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 201 and c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (4,42) and coalesce(phase,1) = 2 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (1,11,12,2,21,3,31,32) );

  update rep_count_volt_tbl set abons_comp1_03_t = coalesce(vabons_p.abons1_t,0), 
                                abons_comp1_03_v = coalesce(vabons_p.abons1_v,0),
				abons_comp2_03_t = coalesce(vabons_p.abons2_t,0),
				abons_comp2_03_v = coalesce(vabons_p.abons2_v,0),
				abons_comp3_03_t = coalesce(vabons_p.abons3_t,0),
				abons_comp3_03_v = coalesce(vabons_p.abons3_v,0);


  raise notice '' areas prom 0.3'';

  select into vareas_p  
  sum(case when power <=100 and is_town =true then 1 else 0 end) as areas1_t,
  sum(case when power <=100 and is_town =false then 1 else 0 end) as areas1_v,
  sum(case when power <=750 and power >100 and is_town =true then 1 else 0 end) as areas2_t,
  sum(case when power <=750 and power >100 and is_town =false then 1 else 0 end) as areas2_v,
  sum(case when power >750 and is_town =true then 1 else 0 end) as areas3_t,
  sum(case when power >750 and is_town =false then 1 else 0 end) as areas3_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town ,pp.power 
   from rep_areas_points_tbl as ap
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =201  and ap.del_abon = 0  
   and coalesce(ap.voltage,4) in (4,42) and coalesce(ap.phase,1) = 2  
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21,3,31,32) )
  ) as s;

  update rep_count_volt_tbl set areas_comp1_03_t = coalesce(vareas_p.areas1_t,0), 
                                areas_comp1_03_v = coalesce(vareas_p.areas1_v,0),
				areas_comp2_03_t = coalesce(vareas_p.areas2_t,0), 
				areas_comp2_03_v = coalesce(vareas_p.areas2_v,0),
				areas_comp3_03_t = coalesce(vareas_p.areas3_t,0), 
				areas_comp3_03_v = coalesce(vareas_p.areas3_v,0);

  --0.2 
  raise notice '' abons prom 0.2'';

  select into vabons_p 
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons1_t,
  sum(case when power <=100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons1_v,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons2_t,
  sum(case when power <=750 and power >100 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons2_v,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =true then 1 else 0 end) as abons3_t,
  sum(case when power >750 and coalesce(kt.flag_type ,vdef_addr_type) =false then 1 else 0 end) as abons3_v
  from clm_client_tbl as c 
  left join rep_count_prom_power_tbl as pp on (pp.id_client = c.id)
  left join clm_statecl_tbl as scl on (c.id = scl.id_client)
  left join adm_address_tbl as a on (a.id = c.id_addres)
  left join adi_street_tbl as s on (s.id = a.id_street)
  left join adi_town_tbl as t on (t.id = s.id_town)
  left join adk_town_tbl as kt on (kt.id = t.idk_town)
  where scl.id_section = 201 and c.idk_work not in (0,99) and c.book=-1 and coalesce(c.id_state,0) not in (50,99,3)
  and exists (select id_point from rep_areas_points_tbl where id_client  = c.id and coalesce(voltage,4) in (4,42) and coalesce(phase,1) = 1 )
  and not exists (select id_point from rep_areas_points_tbl where id_client  = c.id and (coalesce(voltage,4) in (1,11,12,2,21,3,31,32) or coalesce(phase,1) = 2) );

  update rep_count_volt_tbl set abons_comp1_02_t = coalesce(vabons_p.abons1_t,0), 
                                abons_comp1_02_v = coalesce(vabons_p.abons1_v,0),
				abons_comp2_02_t = coalesce(vabons_p.abons2_t,0),
				abons_comp2_02_v = coalesce(vabons_p.abons2_v,0),
				abons_comp3_02_t = coalesce(vabons_p.abons3_t,0),
				abons_comp3_02_v = coalesce(vabons_p.abons3_v,0);


  raise notice '' areas prom 0.2'';

  select into vareas_p  
  sum(case when power <=100 and is_town =true then 1 else 0 end) as areas1_t,
  sum(case when power <=100 and is_town =false then 1 else 0 end) as areas1_v,
  sum(case when power <=750 and power >100 and is_town =true then 1 else 0 end) as areas2_t,
  sum(case when power <=750 and power >100 and is_town =false then 1 else 0 end) as areas2_v,
  sum(case when power >750 and is_town =true then 1 else 0 end) as areas3_t,
  sum(case when power >750 and is_town =false then 1 else 0 end) as areas3_v
  from
  (select distinct ap.id_client,ap.id_area,ap.is_town,pp.power  
   from rep_areas_points_tbl as ap
   left join rep_count_prom_power_tbl as pp on (pp.id_client = ap.id_client)
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where scl.id_section =201  and ap.del_abon = 0  
   and coalesce(ap.voltage,4) in (4,42) and coalesce(ap.phase,1) = 1  
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and (coalesce(ap2.voltage,4) in (1,11,12,2,21,3,31,32) or coalesce(ap2.phase,1) = 2) )
  ) as s;

  update rep_count_volt_tbl set areas_comp1_02_t = coalesce(vareas_p.areas1_t,0), 
                                areas_comp1_02_v = coalesce(vareas_p.areas1_v,0),
				areas_comp2_02_t = coalesce(vareas_p.areas2_t,0), 
				areas_comp2_02_v = coalesce(vareas_p.areas2_v,0),
				areas_comp3_02_t = coalesce(vareas_p.areas3_t,0), 
				areas_comp3_02_v = coalesce(vareas_p.areas3_v,0);

  -----------------------------------------------------------------------------------------
  -- подбить итоги по площадкам 
  delete from rep_areas_tbl;

  --0.2
  insert into rep_areas_tbl(id_client,id_area,phase,voltage,is_town)
  select distinct ap.id_client,ap.id_area,coalesce(ap.phase,1) as phase,coalesce(ap.voltage,4),ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where coalesce(ap.voltage,4) in (4,42) and coalesce(ap.phase,1) = 1  and ap.del_abon = 0  
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and (coalesce(ap2.voltage,4) in (1,11,12,2,21,3,31,32) or coalesce(ap2.phase,1) = 2) );

  --0.3
  insert into rep_areas_tbl(id_client,id_area,phase,voltage,is_town)
  select distinct ap.id_client,ap.id_area,coalesce(ap.phase,1) as phase,coalesce(ap.voltage,4),ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where coalesce(ap.voltage,4) in (4,42) and coalesce(ap.phase,1) = 2   and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21,3,31,32) );

  --6
  insert into rep_areas_tbl(id_client,id_area,phase,voltage,is_town)
  select distinct ap.id_client,ap.id_area,2,coalesce(ap.voltage,4),ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where  coalesce(ap.voltage,4) in (31,32)  and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21,3) );

  --10
  insert into rep_areas_tbl(id_client,id_area,phase,voltage,is_town)
  select distinct ap.id_client,ap.id_area,2,coalesce(ap.voltage,4),ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where  coalesce(ap.voltage,4) =3  and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12,2,21) );

  --35
  insert into rep_areas_tbl(id_client,id_area,phase,voltage,is_town)
  select distinct ap.id_client,ap.id_area,2,coalesce(ap.voltage,4),ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where  coalesce(ap.voltage,4) in (2,21) and ap.del_abon = 0 
   and not exists (select ap2.id_point from rep_areas_points_tbl as ap2 where ap2.id_client  = ap.id_client and ap2.id_area = ap.id_area and coalesce(ap2.voltage,4) in (1,11,12) );

  --110
  insert into rep_areas_tbl(id_client,id_area,phase,voltage,is_town)
  select distinct ap.id_client,ap.id_area,2,coalesce(ap.voltage,4),ap.is_town 
   from rep_areas_points_tbl as ap
   left join clm_statecl_tbl as scl on (ap.id_client = scl.id_client)
   where coalesce(ap.voltage,4) in (1,11,12)  and ap.del_abon = 0 ;


  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
