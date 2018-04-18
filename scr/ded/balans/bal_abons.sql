;
set client_encoding = 'win';


--drop table bal_abons_tbl;
create table bal_abons_tbl (
     id_client  int,
     id_point   int,
     id_grp     int,
     type_grp   int,
     id_p_point	int,
     id_meter   int,
     num_meter  varchar(30),
     flag_priv  int
);


create table bal_abons04_tbl (
     id_client  int,
     id_point   int,
     id_grp     int,
     type_grp   int,
     id_p_point	int,
     id_meter   int,
     num_meter  varchar(30),
     flag_priv  int
);

--drop table bal_fider_st_tbl;
create table bal_fider_st_tbl (
     id_fider   int,
     id_st      int
);


ALTER TABLE bal_fider_st_tbl
  ADD CONSTRAINT bal_fider_st_tbl_pkey PRIMARY KEY(id_st);

--delete from bal_fider_st_tbl;

create or replace function bal_abon_find_fun() Returns boolean As'
Declare
r record;
rr record;
rs boolean;
id_res int;
parent int;
dubl   int;
fider  int;
grp record;

child record;
child_code int;
v boolean; 


begin

-- dtb:=pmmgg;
-- dte:=dtb+''1 month''::interval;

 delete from bal_abons_tbl;
 delete from bal_fider_st_tbl;

 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
  
 for r in 
   Select t.id as id_tree,coalesce(use.id_client,t.id_client) as id_client,t.id_client as rclient,tt.code_eqp,tt.code_eqp_e 
    From eqm_equipment_tbl AS eq 
    join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
    JOIN eqm_tree_tbl AS t ON (t.id=tt.id_tree)
    join clm_client_tbl as cl on (t.id_client = cl.id)
    left join eqm_eqp_use_tbl as use on (use.code_eqp=eq.id )
    WHERE (coalesce(use.id_client,t.id_client)<>id_res) 
      and (eq.type_eqp=12) and cl.book =-1  
 loop

   Raise Notice ''Start %'',r.code_eqp;

   parent :=r.code_eqp_e;

   dubl :=0; 
   fider:=0;

   --для точек учета надо найти счетчик
   -- берем активный счетчик
   -----------------------------------------------------------------------
/*
   child_code:=r.code_eqp;

   LOOP

    select into rr tt.code_eqp, eq.type_eqp, eq.num_eqp
    From eqm_equipment_tbl AS eq 
    join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
    left join eqd_meter_energy_tbl AS en on (tt.code_eqp=en.code_eqp )
    where (tt.code_eqp_e = child_code) and (eq.type_eqp in (1,10)) and (coalesce(en.kind_energy,1) = 1);

--   if not found then

--   end if;

    EXIT WHEN ( rr.type_eqp = 1 or rr.code_eqp is null );   

    child_code:=rr.code_eqp;

   END LOOP;
*/

    select into rr  eq.id as code_eqp, eq.type_eqp, eq.num_eqp
    From eqm_equipment_tbl AS eq 
    join eqm_meter_point_h as mp on (mp.id_meter = eq.id)
    left join eqd_meter_energy_tbl AS en on (eq.id=en.code_eqp )
    where (mp.id_point = r.code_eqp ) and (coalesce(en.kind_energy,1) = 1)
    and mp.dt_e is null;



   -----------------------------------------------------------------------

   if (r.code_eqp_e is not NULL) then


     LOOP
    
       select into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,st.type_eqp as type_grp, st.code_eqp_inst as id_grp
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join 
       (select st.code_eqp, st.code_eqp_inst , eq2.type_eqp
        from eqm_compens_station_inst_tbl as st 
        join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst)
        left join eqm_fider_tbl as f on (f.code_eqp = eq2.id)
        where eq2.type_eqp in (15,8) and coalesce(f.id_voltage,0) not in (4,42)
       ) as st on (eq.id = st.code_eqp)
       where  eq.id = parent;

       Raise Notice ''-eqp %'',parent;
    
       if grp.type_grp is not null then
    
        if (dubl<>0) then
         insert into bal_abons_tbl (id_client,id_point,id_grp,type_grp,id_p_point,id_meter,num_meter) values (r.id_client,r.code_eqp, grp.id_grp,grp.type_grp,dubl,rr.code_eqp,rr.num_eqp);
        else
         insert into bal_abons_tbl (id_client,id_point,id_grp,type_grp,id_meter,num_meter) values (r.id_client,r.code_eqp, grp.id_grp,grp.type_grp,rr.code_eqp,rr.num_eqp);
        end if;
    
        fider:=grp.id_grp;
    
       else
    
        if grp.code_eqp_e is null then
    
         if (dubl<>0) then
          insert into bal_abons_tbl (id_client,id_point,id_p_point,id_meter,num_meter) values (r.id_client,r.code_eqp, dubl,rr.code_eqp,rr.num_eqp);
         else
          insert into bal_abons_tbl (id_client,id_point,id_meter,num_meter) values (r.id_client,r.code_eqp,rr.code_eqp,rr.num_eqp);
         end if;
    
        end if;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- наткнулись на другую ТУ 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;

     end loop;
   else

     insert into bal_abons_tbl (id_client,id_point,id_meter,num_meter) values (r.id_client,r.code_eqp,rr.code_eqp,rr.num_eqp);
   end if;

 end loop;

    


 -- физ лица по ускоренной процедуре через eqm_privmeter_tbl

 for r in 
--   Select pm.id_point, pm.id_eqp, pm.id_eqmborder, pm.id_client, pm.num_eqp    
--    from eqm_privmeter_tbl as pm 
--   Select distinct pm.id_eqmborder    from eqm_privmeter_tbl as pm 
   Select distinct pm.id_eqpborder as id_eqmborder  from clm_pclient_tbl as pm 

 loop

   Raise Notice ''Start %'',r.id_eqmborder;

   parent :=r.id_eqmborder;

   dubl :=0; 
   fider:=0;

   if (r.id_eqmborder is not NULL) then

     LOOP
    
       select into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,st.type_eqp as type_grp, st.code_eqp_inst as id_grp
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join 
       (select st.code_eqp, st.code_eqp_inst, eq2.type_eqp 
        from eqm_compens_station_inst_tbl as st 
        join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst)
        left join eqm_fider_tbl as f on (f.code_eqp = eq2.id)
        where eq2.type_eqp in (15,8) and coalesce(f.id_voltage,0) not in (4,42)
       ) as st on (eq.id = st.code_eqp)
--       left join eqm_compens_station_inst_tbl as st on (eq.id = st.code_eqp)
--       left join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst and eq2.type_eqp in (15,8))
       where  eq.id = parent;
    
       if grp.type_grp is not null then
    
        if (dubl<>0) then
         insert into bal_abons_tbl (id_client,id_point,id_grp,type_grp,id_p_point,id_meter,num_meter,flag_priv)
          select pc.id,NULL,grp.id_grp,grp.type_grp,dubl,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;
        else
         insert into bal_abons_tbl (id_client,id_point,id_grp,type_grp,id_meter,num_meter,flag_priv) 
          select pc.id,NULL,grp.id_grp,grp.type_grp,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;

        end if;
    
        fider:=grp.id_grp;
    
       else
    
        if grp.code_eqp_e is null then
    
         if (dubl<>0) then
          insert into bal_abons_tbl (id_client,id_point,id_p_point,id_meter,num_meter,flag_priv) 
          select pc.id,NULL,dubl,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;

         else
          insert into bal_abons_tbl (id_client,id_point,id_meter,num_meter,flag_priv) 
          select pc.id,NULL,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;

         end if;
    
        end if;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- наткнулись на другую ТУ 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;
     end loop;

   else

     insert into bal_abons_tbl (id_client,id_point,id_meter,num_meter,flag_priv ) 
     select pc.id,id_point,id_eqp, num_eqp,1 
     from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
     where pc.id_eqpborder is null and coalesce(pc.id_state,0)<>50;

   end if;                                        

 end loop;

 -- построим таблицу принадлежности ПС 10/04 к фидерам    

   -- все ветви, исходящие из фидеров
   for child in 
--    select bt.code_eqp, bt.id_tree, grp.code_eqp as fider 
    select bt.code_eqp, bt.id_tree, st.code_eqp_inst 
    from eqm_eqp_tree_tbl as bt
    join eqm_equipment_tbl as eq on (eq.id = bt.code_eqp)
    join eqm_compens_station_inst_tbl as st on (bt.code_eqp_e=st.code_eqp)
    join eqm_fider_tbl as f on (st.code_eqp_inst=f.code_eqp and f.id_voltage not in (4,42) )
    left join eqk_voltage_tbl as vlt on (vlt.id = f.id_voltage)
--    where eq.type_eqp <> 9 
--    and f.id_voltage = 3 
    where vlt.voltage_max >1 and vlt.voltage_max <=10 
    and not exists (select st2.code_eqp from eqm_compens_station_inst_tbl as st2  join eqm_fider_tbl as f2 on (f2.code_eqp=st2.code_eqp_inst and f2.id_voltage not in (4,42) ) 
         where st2.code_eqp = bt.code_eqp)
  loop


--    Raise Notice ''start2 %'',child.code_eqp;

    v:=bal_fider_st_fun(child.code_eqp,child.id_tree,child.code_eqp_inst);
  end loop;


 Return true;
end;
' Language 'plpgsql';
-------------------------------=====================----------------------------
-- с учетом линий 0.4 кВ
create or replace function bal_abon_find04_fun() Returns boolean As'
Declare
r record;
rr record;
rs boolean;
id_res int;
parent int;
dubl   int;
fider  int;
grp record;

child record;
child_code int;
v boolean; 


begin

-- dtb:=pmmgg;
-- dte:=dtb+''1 month''::interval;

 delete from bal_abons04_tbl;
 delete from bal_fider_st_tbl;

 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
  
 for r in 
   Select t.id as id_tree,coalesce(use.id_client,t.id_client) as id_client,t.id_client as rclient,tt.code_eqp,tt.code_eqp_e 
    From eqm_equipment_tbl AS eq 
    join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
    JOIN eqm_tree_tbl AS t ON (t.id=tt.id_tree)
    join clm_client_tbl as cl on (t.id_client = cl.id)
    left join eqm_eqp_use_tbl as use on (use.code_eqp=eq.id )
    WHERE (coalesce(use.id_client,t.id_client)<>id_res) 
      and (eq.type_eqp=12) and cl.book =-1  
 loop

   Raise Notice ''Start %'',r.code_eqp;

   parent :=r.code_eqp_e;

   dubl :=0; 
   fider:=0;

   --для точек учета надо найти счетчик
   -- берем активный счетчик
   -----------------------------------------------------------------------

    select into rr  eq.id as code_eqp, eq.type_eqp, eq.num_eqp
    From eqm_equipment_tbl AS eq 
    join eqm_meter_point_h as mp on (mp.id_meter = eq.id)
    left join eqd_meter_energy_tbl AS en on (eq.id=en.code_eqp )
    where (mp.id_point = r.code_eqp ) and (coalesce(en.kind_energy,1) = 1)
    and mp.dt_e is null;

   -----------------------------------------------------------------------

   if (r.code_eqp_e is not NULL) then


     LOOP
    
       select into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,st.type_eqp as type_grp, st.code_eqp_inst as id_grp
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join 
       (select st.code_eqp, st.code_eqp_inst , eq2.type_eqp
        from eqm_compens_station_inst_tbl as st 
        join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst)
--        left join eqm_fider_tbl as f on (f.code_eqp = eq2.id)
        where eq2.type_eqp in (15,8) --and coalesce(f.id_voltage,0) not in (4,42)
       ) as st on (eq.id = st.code_eqp)
       where  eq.id = parent;

       Raise Notice ''-eqp %'',parent;
    
       if grp.type_grp is not null then
    
        if (dubl<>0) then
         insert into bal_abons04_tbl (id_client,id_point,id_grp,type_grp,id_p_point,id_meter,num_meter) values (r.id_client,r.code_eqp, grp.id_grp,grp.type_grp,dubl,rr.code_eqp,rr.num_eqp);
        else
         insert into bal_abons04_tbl (id_client,id_point,id_grp,type_grp,id_meter,num_meter) values (r.id_client,r.code_eqp, grp.id_grp,grp.type_grp,rr.code_eqp,rr.num_eqp);
        end if;
    
        fider:=grp.id_grp;
    
       else
    
        if grp.code_eqp_e is null then
    
         if (dubl<>0) then
          insert into bal_abons04_tbl (id_client,id_point,id_p_point,id_meter,num_meter) values (r.id_client,r.code_eqp, dubl,rr.code_eqp,rr.num_eqp);
         else
          insert into bal_abons04_tbl (id_client,id_point,id_meter,num_meter) values (r.id_client,r.code_eqp,rr.code_eqp,rr.num_eqp);
         end if;
    
        end if;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- наткнулись на другую ТУ 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;

     end loop;
   else

     insert into bal_abons04_tbl (id_client,id_point,id_meter,num_meter) values (r.id_client,r.code_eqp,rr.code_eqp,rr.num_eqp);
   end if;

 end loop;

    


 -- физ лица по ускоренной процедуре через eqm_privmeter_tbl

 for r in 
--   Select pm.id_point, pm.id_eqp, pm.id_eqmborder, pm.id_client, pm.num_eqp    
--    from eqm_privmeter_tbl as pm 
--   Select distinct pm.id_eqmborder    from eqm_privmeter_tbl as pm 
   Select distinct pm.id_eqpborder as id_eqmborder  from clm_pclient_tbl as pm 

 loop

   Raise Notice ''Start %'',r.id_eqmborder;

   parent :=r.id_eqmborder;

   dubl :=0; 
   fider:=0;

   if (r.id_eqmborder is not NULL) then

     LOOP
    
       select into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,st.type_eqp as type_grp, st.code_eqp_inst as id_grp
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join 
       (select st.code_eqp, st.code_eqp_inst, eq2.type_eqp 
        from eqm_compens_station_inst_tbl as st 
        join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst)
--        left join eqm_fider_tbl as f on (f.code_eqp = eq2.id)
        where eq2.type_eqp in (15,8) --and coalesce(f.id_voltage,0) not in (4,42)
       ) as st on (eq.id = st.code_eqp)
--       left join eqm_compens_station_inst_tbl as st on (eq.id = st.code_eqp)
--       left join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst and eq2.type_eqp in (15,8))
       where  eq.id = parent;
    
       if grp.type_grp is not null then
    
        if (dubl<>0) then
         insert into bal_abons04_tbl (id_client,id_point,id_grp,type_grp,id_p_point,id_meter,num_meter,flag_priv)
          select pc.id,NULL,grp.id_grp,grp.type_grp,dubl,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;
        else
         insert into bal_abons04_tbl (id_client,id_point,id_grp,type_grp,id_meter,num_meter,flag_priv) 
          select pc.id,NULL,grp.id_grp,grp.type_grp,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;

        end if;
    
        fider:=grp.id_grp;
    
       else
    
        if grp.code_eqp_e is null then
    
         if (dubl<>0) then
          insert into bal_abons04_tbl (id_client,id_point,id_p_point,id_meter,num_meter,flag_priv) 
          select pc.id,NULL,dubl,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;

         else
          insert into bal_abons04_tbl (id_client,id_point,id_meter,num_meter,flag_priv) 
          select pc.id,NULL,NULL, pm.num_eqp,1 
          from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
          where pc.id_eqpborder = r.id_eqmborder and coalesce(pc.id_state,0)<>50;

         end if;
    
        end if;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- наткнулись на другую ТУ 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;
     end loop;

   else

     insert into bal_abons04_tbl (id_client,id_point,id_meter,num_meter,flag_priv ) 
     select pc.id,id_point,id_eqp, num_eqp,1 
     from clm_pclient_tbl as pc left join eqm_privmeter_tbl as pm  on (pc.id =pm.id_client) 
     where pc.id_eqpborder is null and coalesce(pc.id_state,0)<>50;

   end if;                                        

 end loop;

 -- построим таблицу принадлежности ПС 10/04 к фидерам    

   -- все ветви, исходящие из фидеров
   for child in 
--    select bt.code_eqp, bt.id_tree, grp.code_eqp as fider 
    select bt.code_eqp, bt.id_tree, st.code_eqp_inst 
    from eqm_eqp_tree_tbl as bt
    join eqm_equipment_tbl as eq on (eq.id = bt.code_eqp)
    join eqm_compens_station_inst_tbl as st on (bt.code_eqp_e=st.code_eqp)
    join eqm_fider_tbl as f on (st.code_eqp_inst=f.code_eqp and f.id_voltage not in (4,42) )
    left join eqk_voltage_tbl as vlt on (vlt.id = f.id_voltage)
--    where eq.type_eqp <> 9 
--    and f.id_voltage = 3 
    where vlt.voltage_max >1 and vlt.voltage_max <=10 
    and not exists (select st2.code_eqp from eqm_compens_station_inst_tbl as st2  join eqm_fider_tbl as f2 on (f2.code_eqp=st2.code_eqp_inst and f2.id_voltage not in (4,42) ) 
         where st2.code_eqp = bt.code_eqp)
  loop


--    Raise Notice ''start2 %'',child.code_eqp;

    v:=bal_fider_st_fun(child.code_eqp,child.id_tree,child.code_eqp_inst);
  end loop;


 Return true;
end;
' Language 'plpgsql';
-------------------------------=====================----------------------------





create or replace function bal_fider_st_fun(int,int,int) 
Returns boolean As'
Declare

 pid_eqp Alias for $1;
-- pid_client Alias for $2;
-- pid_res Alias for $3;
-- ptype_eqp Alias for $4;
 pid_tree Alias for $2;
 pid_p_grp Alias for $3;
-- pid_grp_lvl Alias for $7;
-- pmmgg Alias for $8;

 point int;
 child record;
 grp record;
 entry record;
 v boolean; 
 dtb date;
 dte date;
 is_entry boolean;
 vfider record;
 vid_voltage int;

begin
 -- ищем, принадлежит ли оборудование подстанции или площадке
 select into grp st.code_eqp_inst,eq.type_eqp
 from eqm_compens_station_inst_tbl as st join eqm_equipment_tbl as eq on (eq.id = st.code_eqp_inst)
 left join eqm_fider_tbl as f on (f.code_eqp = eq.id)
 where  eq.type_eqp in (15,8) and coalesce(f.id_voltage,0) not in (4,42)
 and st.code_eqp = pid_eqp;

 Raise Notice ''Grp %'',grp.code_eqp_inst;

 if not found then
  --оборудование не принадлежит фидерам и подстанциям

  for child in 
   select tt.code_eqp 
   from eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (eq.id = tt.code_eqp)
 
   where tt.code_eqp_e = pid_eqp
--   and tt.id_tree = pid_tree
--   and eq.type_eqp <> 9   --на границах останавливаемся
  loop

   Raise Notice ''start1 %'',child.code_eqp;

   v:=bal_fider_st_fun(child.code_eqp,pid_tree,pid_p_grp);

  end loop;

 else
  --для тех случаев, когда трудно привести схему в порядок,
  --т.е. устранить проходные подстанции и подстанции с двумя и больше входами
  --правильность работы при этом ложится на инженера  
  if grp.type_eqp=15 then --фидер (вход в фидер)
     Raise Notice ''Fider ??'';
     return true;
  end if;
  -- фидер имеет одно начало, и в начале должен быть точка учета
  -- если нет ТУ в нчале, считаем фидер не имеющим счетчика 

  if grp.type_eqp=8 then --подстанция Запишем в таблицу и выходим

   Raise Notice ''station '';  

   if (select count (*) from bal_fider_st_tbl where id_st = grp.code_eqp_inst)=0  then 
 
    insert into bal_fider_st_tbl (id_fider,id_st) values (pid_p_grp,grp.code_eqp_inst);

   end if;
 
   return true;

  end if;
--   select into vid_voltage id_voltage from eqm_compens_station_tbl
--   where code_eqp=grp.code_eqp_inst;


 end if;

 return true;
end;
' Language 'plpgsql';

