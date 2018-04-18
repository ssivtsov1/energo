
create table rep_work_grafic_tbl (
id serial,
id_client int,
id_point  int, 
id_meter  int,
id_inspector int,
id_work_type int,
id_parent_work int,
date_work date,
is_real   int default 0,
primary key (id)
); 


create or replace function rep_work_grafic_build(date,date,int) Returns int As'
Declare
 pdt_b Alias for $1;
 pdt_e Alias for $2;
 ptype Alias for $3;

 r record;
 r2 record;

 vdt_b date;
 vdt_e date;

 vmonth_cnt int;
 vdays int;
 vday_cnt int;
 vdelta_day numeric;

 vcur_date date;
 vcur_works_cnt int;
 vcur_day_cnt int;
 vcur_delta_day numeric;

begin


 select into vdt_b min(c_date) from calendar where c_date >= date_trunc(''month'',pdt_b) and coalesce(holiday,false)=false;

 if ptype = 1 then
   vdt_e =  date_trunc(''month'',pdt_b) +''3 year - 1 day ''::interval ;
 end if;

 if ptype = 2 then
   vdt_e =  date_trunc(''month'',pdt_b) +''6 month - 1 day ''::interval ;
 end if;

 select into vdays count(*) from calendar where coalesce(holiday,false)=false and c_date >=vdt_b and c_date <=vdt_e;


 delete from rep_work_grafic_tbl where id_work_type = ptype and date_work >=vdt_b and date_work <=vdt_e;

 for r in 
    select p.id_position, count(*) as meter_cnt
    from eqm_tree_tbl as tr
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)
    join eqm_point_tbl as p on (ttr.code_eqp = p.code_eqp)
    join eqm_meter_point_h as mp on (mp.id_point = p.code_eqp and mp.id_meter is not null and mp.dt_e is null)
    join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter) 
    left join 
    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_tbl as u1 order by u1.code_eqp ) as use on (use.code_eqp = p.code_eqp)
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))
    left join clm_statecl_tbl as scl on (c.id = scl.id_client)
    where scl.id_section not in (205,206,207,208) 
    and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
    and coalesce(p.share,0) = 0
    and c.book=-1
    and p.id_position is not null
    and me.kind_energy = 1
    group by p.id_position
 loop

--  if ptype = 2 then

--     vmonth_cnt :=r.meter_cnt /6;
  vday_cnt := round(r.meter_cnt::numeric/vdays,0);
  vdelta_day:=  r.meter_cnt::numeric/vdays -round(r.meter_cnt::numeric/vdays,0);
--  end if;

  vcur_date:=vdt_b;
  vcur_works_cnt :=0;
  vcur_day_cnt := vday_cnt;
  vcur_delta_day:=0;

  for r2 in 

    select p.id_position, mp.id_point, mp.id_meter, adr.id_street,c.id as id_client, 
    to_number(CASE WHEN coalesce(trim(adr.building),''0'') = '''' THEN ''0'' ELSE coalesce(trim(adr.building),''0'') END, ''00000'') as build_num , c.code , ww.dt_work
    from eqm_tree_tbl as tr
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)
    join eqm_point_tbl as p on (ttr.code_eqp = p.code_eqp)
    join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id)
    join eqm_meter_point_h as mp on (mp.id_point = p.code_eqp and mp.id_meter is not null and mp.dt_e is null)
    join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter) 
    left join adm_address_tbl as adr on (adr.id = eq.id_addres)
    left join adi_street_tbl as ads on (ads.id = adr.id_street)
    left join 
    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_tbl as u1 order by u1.code_eqp ) as use on (use.code_eqp = p.code_eqp)
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))
    left join clm_statecl_tbl as scl on (c.id = scl.id_client)
    left join
    ( select w.id_point,max(w.dt_work) as dt_work 
      from clm_works_tbl as w 
--      where id_type = ptype and dt_work >= ''2009-07-01''
      where 
      (
       (ptype = 2 and id_type in (1,2,3,4) ) or
       (id_type = ptype )
      )
      and dt_work >= ''2008-01-01''
      group by w.id_point order by w.id_point
    ) as ww on (ww.id_point = p.code_eqp) 
--    ( select adr2.id_street ,max(w.dt_work) as dt_work 
--      from clm_works_tbl as w 
--      join eqm_equipment_tbl as eq2 on (w.id_point = eq2.id)
--      left join adm_address_tbl as adr2 on (adr2.id = eq2.id_addres)
--      where id_type = ptype and dt_work >= ''2009-07-01''
--      group by adr2.id_street order by adr2.id_street
--    ) as ww on (ww.id_street = adr.id_street) 
    where scl.id_section not in (205,206,207,208) 
    and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
    and coalesce(p.share,0) = 0
    and c.book=-1
    and me.kind_energy = 1
    and p.id_position = r.id_position
    --group by p.id_position
--    order by id_street, build_num, code
    order by date_trunc(''month'',coalesce(ww.dt_work,''2000-01-01'')) ,ads.id_town, ads.name,  build_num, code
  loop

    insert into rep_work_grafic_tbl(id_client,id_point,id_meter,id_inspector,id_work_type,date_work)
    values(r2.id_client,r2.id_point,r2.id_meter,r.id_position,ptype,vcur_date);

    vcur_works_cnt := vcur_works_cnt +1;


    if (vcur_works_cnt >= vcur_day_cnt ) then

-----------------------------------------------
       if (calend_dt_inc(vcur_date,1) <= vdt_e) then

         LOOP
          vcur_date:= calend_dt_inc(vcur_date,1);
     
          vcur_works_cnt :=0;
          vcur_day_cnt := vday_cnt;
     
          vcur_delta_day :=vcur_delta_day+vdelta_day;
      
          if vcur_delta_day > 1 then
     
            vcur_day_cnt:=vcur_day_cnt+1;
            vcur_delta_day := vcur_delta_day-1;
     
          end if;
     
          if vcur_delta_day < -1  then
      
            vcur_day_cnt:=vcur_day_cnt-1;
            vcur_delta_day := vcur_delta_day+1;
     
          end if;

         EXIT WHEN ((vcur_day_cnt>0) or (calend_dt_inc(vcur_date,1) > vdt_e) );
         END LOOP;
       end if; 
------------------------------------------------
    end if;

  end loop;

 end loop;


Return 0;
end;
' Language 'plpgsql'; 
