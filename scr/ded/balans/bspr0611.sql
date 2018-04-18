

--drop function sel_bal_par(int,int);
create or replace function sel_bal_par(int,int,timestamp) Returns boolean As'
Declare
ide Alias for $1;
tpe Alias for $2;
dtb Alias for $3;
tp_c int;
vh int;

begin
 if (tpe=2) then 
  select into tp_c id_type_eqp from eqm_compensator_tbl where code_eqp=ide;

  update bal_eqp_tmp set id_type_eqp=id,sn_len=power_nom,pxx_r0=iron
  ,pkz_x0=copper,ixx=amperage_no_load,ukz_un=voltage_short_circuit
  ,tt=cnt_time(dat_b,dat_e,24)
  from eqi_compensator_tbl a,eqi_compensator_2_tbl b 
  where a.id=tp_c and b.id_type_eqp=a.id and bal_eqp_tmp.code_eqp=ide and mmgg=dtb::date;
 end if;
---corrrr!!!!!!!!!!!!
 if (tpe=6) then 

  if (select count(*) from eqm_compens_station_inst_tbl as si join eqm_equipment_tbl as eq on (eq.id = si.code_eqp_inst)
     where eq.type_eqp=17 and code_eqp = ide ) <> 0 
  then 
    vh:=10;
  else
    vh:=24;
  end if;

  update bal_eqp_tmp set id_type_eqp=a.id,sn_len=b.length,pxx_r0=a.ro
  ,pkz_x0=a.xo,ukz_un=c.voltage_min*1000,
   tt=cnt_time(dat_b,dat_e,vh)
  from eqi_cable_tbl a, eqm_line_c_tbl b, eqk_voltage_tbl as c  
  where a.id=b.id_type_eqp and b.code_eqp=ide and b.id_voltage=c.id 
   and bal_eqp_tmp.code_eqp=ide and mmgg=dtb::date;
 end if; 

 if (tpe=7) then 

  if (select count(*) from eqm_compens_station_inst_tbl as si join eqm_equipment_tbl as eq on (eq.id = si.code_eqp_inst)
     where eq.type_eqp=17 and code_eqp = ide ) <> 0 
  then 
    vh:=10;
  else
    vh:=24;
  end if;

  update bal_eqp_tmp set id_type_eqp=a.id,sn_len=b.length,pxx_r0=a.ro
  ,pkz_x0=a.xo,ukz_un=c.voltage_min*1000,tt=cnt_time(dat_b,dat_e,vh)
  from eqi_corde_tbl a, eqm_line_a_tbl b, eqk_voltage_tbl as c 
  where a.id=b.id_type_eqp and b.code_eqp=ide and b.id_voltage=c.id 
   and bal_eqp_tmp.code_eqp=ide and mmgg=dtb::date;
---corrrr!!!!!!!!!!!!
 end if;
 Return true;
end;
' Language 'plpgsql';

---------------------------------------------------------------------------------------------
--drop function sel_bal_par_desc(int,int,timestamp,timestamp,int);
create or replace function sel_bal_par_desc(int,int,timestamp,timestamp,int,int) Returns boolean As'
Declare
ide Alias for $1;
tpe Alias for $2;
dtb Alias for $3;
dte Alias for $4;
idcl Alias for $5;
pid_res Alias for $6;
r record;
rs boolean;
vid_rres int;
vmmgg date;
begin

 Raise Notice ''equipment  %'',ide;

 vmmgg:=date_trunc(''month'',dtb)::date;

 select into vid_rres to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

 -- получить параметры данного екземпляра оборудования
 rs:=sel_bal_par(ide,tpe,dtb);

 --сначала рекурсия опускеается вниз, потом при подьеме считает потери
 --т.к. потребление для ТУ мы получили заранее, и они должны быть терминальными,
 --до ТУ можно не опускаться  
 for r in select * from bal_eqp_tmp where id_p_eqp=ide and mmgg::date = vmmgg 
  and ((type_eqp not in (12) ) or (id_client=pid_res) or (type_eqp = 12 and id_type_eqp = -1))
 loop
   rs:=sel_bal_par_desc(r.code_eqp,r.type_eqp,dtb,dte,r.id_client,pid_res);
 end loop;

 if (tpe not in (12) ) then

   if (tpe in (2,6,7)) then

     rs:=calc_bal_lost(ide,dtb);

   else
     -- как сумму потомков
     insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,lst,mmgg,sumlosts_ti,sumlosts_tu,sumlosts_meter,sumlosts_linea,sumlosts_linec,
                sumlosts_kz, sumlosts_xx, sumlosts_air, sumlosts_cable, fiz_demand,nolost_demand) 
     select d.code_eqp,d.dat_b,d.dat_e,c.dem,c.dem04,c.lst,dtb::date,
       coalesce(c.sumlosts_ti,0),coalesce(c.sumlosts_tu,0),coalesce(c.sumlosts_meter,0),coalesce(c.sumlosts_linea,0),coalesce(c.sumlosts_linec,0),
       coalesce(c.sumlosts_kz,0), coalesce(c.sumlosts_xx,0), coalesce(c.sumlosts_air,0), coalesce(c.sumlosts_cable,0),
       coalesce(c.fiz_dem,0),coalesce(c.nolost_dem,0)
       from 
      (select sum(demand) as dem,sum(demand04) as dem04,sum(losts+lst) as lst,sum(fiz_demand) as fiz_dem,sum(nolost_demand) as nolost_dem,
       sum(sumlosts_ti) as sumlosts_ti,sum(sumlosts_tu) as sumlosts_tu , sum(sumlosts_meter) as sumlosts_meter ,
       sum(sumlosts_linea) as sumlosts_linea, sum(sumlosts_linec) as sumlosts_linec,
       sum(sumlosts_kz) as sumlosts_kz, sum(sumlosts_xx) as sumlosts_xx,
       sum(sumlosts_air) as sumlosts_air, sum(sumlosts_cable) as sumlosts_cable,
       b.id_p_eqp as code_eqp 
       from bal_acc_tmp as a,bal_eqp_tmp as b 
       where a.code_eqp=b.code_eqp and b.id_p_eqp=ide 
       and a.mmgg=b.mmgg and a.mmgg=vmmgg
       group by b.id_p_eqp
      ) as c 
      right join
      (select code_eqp,dat_b,dat_e from bal_eqp_tmp where code_eqp=ide and mmgg=vmmgg limit 1) as d
      on (c.code_eqp=d.code_eqp);
   end if;
 else --tpe=12
   -- точка учета 
   -- в bal_eqp_tbl могли попасть точки учета, стоящие на стороне РЕС,
   -- но не имеющие счетов
   Raise Notice ''- point  %'',ide;

   if (select id_client from bal_eqp_tmp where code_eqp=ide limit 1)= pid_res then  
     -- Точка РЕС
     -- для Славутича - надо дать возможность выбрать из счета данные по ТУ, принадлежащей абоненту
     -- по которому делается пофидерный анализ
--     if (select coalesce(sum(demand),0) from bal_acc_tmp where code_eqp = ide) = 0 then
     if (select COUNT(*) from bal_acc_tmp where code_eqp = ide) = 0 then

      Raise Notice ''- - -  '';
      -- как сумму потомков, хотя вообще это не очень правильно (у точки учета есть свое потребление, хоть и нет счета)
      insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,lst,mmgg,sumlosts_ti,sumlosts_tu,sumlosts_meter,sumlosts_linea,sumlosts_linec,
      sumlosts_kz, sumlosts_xx, sumlosts_air, sumlosts_cable,fiz_demand,nolost_demand) 
      select d.code_eqp,d.dat_b,d.dat_e,c.dem,c.dem04,c.lst,dtb::date,
       c.sumlosts_ti,c.sumlosts_tu,c.sumlosts_meter,c.sumlosts_linea,c.sumlosts_linec, 
       coalesce(c.sumlosts_kz,0), coalesce(c.sumlosts_xx,0), coalesce(c.sumlosts_air,0), coalesce(c.sumlosts_cable,0),
       coalesce(c.fiz_dem,0),coalesce(c.nolost_dem,0)
       from 
       (select sum(demand) as dem,sum(demand04) as dem04,sum(losts+lst) as lst, sum(fiz_demand) as fiz_dem,sum(nolost_demand) as nolost_dem,
       sum(sumlosts_ti) as sumlosts_ti,sum(sumlosts_tu) as sumlosts_tu , sum(sumlosts_meter) as sumlosts_meter ,
       sum(sumlosts_linea) as sumlosts_linea, sum(sumlosts_linec) as sumlosts_linec,
       sum(sumlosts_kz) as sumlosts_kz, sum(sumlosts_xx) as sumlosts_xx,
       sum(sumlosts_air) as sumlosts_air, sum(sumlosts_cable) as sumlosts_cable,
        b.id_p_eqp as code_eqp 
        from bal_acc_tmp as a,bal_eqp_tmp as b 
       where a.code_eqp=b.code_eqp and b.id_p_eqp=ide 
       and a.mmgg=b.mmgg and a.mmgg=vmmgg
       group by b.id_p_eqp) as c 
       right join
       (select code_eqp,dat_b,dat_e from bal_eqp_tmp where code_eqp=ide and mmgg=vmmgg limit 1) as d
       on (c.code_eqp=d.code_eqp);

       if pid_res = vid_rres then

       --потери в счетчике
       update bal_acc_tmp set losts_meter = ml.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600 * 1000 ,
       sumlosts_meter = sumlosts_meter+ coalesce(ml.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600 * 1000 ,0),
       losts = losts+ coalesce(round(ml.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600 * 1000),0),
       id_spr_type = id_type_eqp
       from 
        (select kz.id_point, kz.id_meter, kz.id_type_eqp,im.kind_meter,im.phase, coalesce(rtrim(mp.cl,''0. ''),''2'') as class
         from bal_meter_demand_tmp as kz join eqi_meter_tbl as im on (im.id = kz.id_type_eqp)
         left join eqi_meter_prec_tbl as mp on (mp.id_type_eqp = im.id)
         where  kz.id_point = ide
        ) as ss
        join eqi_meter_losts_tbl as ml on (ss.kind_meter = ml.kind_meter and ss.phase = ml.phase and ss.class = ml.class)
        where bal_acc_tmp.code_eqp = ss.id_point ; 


       -- потери в тр. тока.
       update bal_acc_tmp set losts_ti =ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600  ,
       sumlosts_ti =sumlosts_ti + coalesce(ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600,0)  ,
       losts = losts+ coalesce(ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600,0) ,
       id_un = un
       from 
        ( select id_point,p.id_un, coalesce(p.id_un,p.id_voltage) as un, 
        CASE WHEN  coalesce(p.id_un,p.id_voltage,3) in (4,41) THEN 50::numeric/8784 
             WHEN  coalesce(p.id_un,p.id_voltage,3) in (31,32) THEN 60::numeric/8784 
             WHEN  coalesce(p.id_un,p.id_voltage,3) = 3 THEN 100::numeric/8784 
             WHEN  coalesce(p.id_un,p.id_voltage,3) in (2,21) THEN 400::numeric/8784 
             WHEN  coalesce(p.id_un,p.id_voltage,3) = 1 THEN 1100::numeric/8784 
             WHEN  coalesce(p.id_un,p.id_voltage,3) = 11 THEN 1500::numeric/8784 
        END::numeric as power_lost
        from bal_meter_demand_tmp as kz 
        join eqm_point_tbl as p on (p.code_eqp = kz.id_point)
        where coalesce(kz.met_demand,0)<coalesce(kz.ktr_demand,0)
        and id_point = ide
        ) as ss
        where bal_acc_tmp.code_eqp = ss.id_point;  

       end if;
     end if;
   else

     if (select coalesce(id_type_eqp,0) from bal_eqp_tmp where code_eqp=ide limit 1)= -1 then  
     -- для абонентских ТУ, которые помечены как входящие в фидера, надо прибавить потребление потомков 
     -- к потреблению самой точки

      Raise Notice ''- - - - - - - special point  %'',ide;

      update bal_acc_tmp set demand_bill = coalesce(demand,0)+coalesce(c.dem,0) , demand04 = coalesce(demand04,0)+coalesce(c.dem04,0),
                fiz_demand = fiz_demand+ coalesce(c.fiz_dem,0), nolost_demand = nolost_demand +coalesce(c.nolost_dem,0)
        from 
       (select sum(demand) as dem,sum(demand04) as dem04,sum(losts+lst) as lst,sum(fiz_demand) as fiz_dem,sum(nolost_demand) as nolost_dem,
        sum(sumlosts_ti) as sumlosts_ti,sum(sumlosts_tu) as sumlosts_tu , sum(sumlosts_meter) as sumlosts_meter ,
        sum(sumlosts_linea) as sumlosts_linea, sum(sumlosts_linec) as sumlosts_linec,
        sum(sumlosts_kz) as sumlosts_kz, sum(sumlosts_xx) as sumlosts_xx,
        sum(sumlosts_air) as sumlosts_air, sum(sumlosts_cable) as sumlosts_cable,
        b.id_p_eqp as code_eqp 
        from bal_acc_tmp as a,bal_eqp_tmp as b 
        where a.code_eqp=b.code_eqp and b.id_p_eqp=ide 
        and a.mmgg=b.mmgg and a.mmgg=vmmgg
        group by b.id_p_eqp
       ) as c 
       right join
       (select code_eqp,dat_b,dat_e from bal_eqp_tmp where code_eqp=ide and mmgg=vmmgg limit 1) as d on (c.code_eqp=d.code_eqp)
       where d.code_eqp = bal_acc_tmp.code_eqp;

     end if;
 
   end if;

 end if;
 Return true;
end;
' Language 'plpgsql';
-----------------------------------------------------------------------------------------------
--drop function sel_bal_par_start(timestamp,timestamp);


create or replace function sel_bal_par_start(timestamp,timestamp) Returns boolean As'
Declare
dtb Alias for $1;
dte Alias for $2;
r record;
rs boolean;
vmmgg date;
vmmgg_next date;
vid_res int;
vid_rres int;
vmode int; 
begin

 vmmgg:=date_trunc(''month'',dtb)::date;

 vmmgg_next:= vmmgg::date+''1 month''::interval;
 
 Raise Notice ''sel_bal_par_start start .....'';

-- select into vid_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_bal'';
 select into vid_res getsysvar(''id_bal'');
 select into vid_rres to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
 select into vmode to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''fider_2month'';

   Raise Notice ''demand select start '';


   -- выбрать все потребление по точкам учета заранее,
   -- чтобы не выбирать по одному при обходе дерева
   insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,nolost_demand, demand_full, losts,mmgg) 
    select  sdem.code_eqp,sdem.dat_b,sdem.dat_e,
    CASE WHEN (sdem.dem>9000 and clm.book <> -1) THEN 0 ELSE sdem.dem END AS dem,
    CASE WHEN (p.id_voltage=4 and (sdem.dem<=9000 or clm.book = -1)) THEN sdem.dem ELSE 0 END AS dem04,
    CASE WHEN (coalesce(p.lost_nolost,1) = 0) THEN sdem.dem ELSE 0 END as nolost_dem,
    sdem.full_dem,
    0,dtb::date 
     from
      (
       select b.code_eqp,b.dat_b,b.dat_e,b.id_client,b.type_eqp,
       CASE WHEN  c.dem2 is null THEN c.dem1full 
       ELSE (coalesce(c.dem1,0)+coalesce(c.dem2,0)) END as full_dem,
       CASE WHEN  c.fact_dem2 is null THEN c.fact_dem1full 
       ELSE (coalesce(c.fact_dem1,0)+coalesce(c.fact_dem2,0)) END as dem
       from  
       (
        (
         select a.id_point,((sum(sum_demand+sum_losts))*cal_days_fun(dtb::date, max(a.dat_e))/cal_days_fun(min(a.dat_b), max(a.dat_e)))::int as dem1,
         ((sum(fact_demand+fact_losts))*cal_days_fun(dtb::date, max(a.dat_e))/cal_days_fun(min(a.dat_b), max(a.dat_e)))::int as fact_dem1,
         sum(sum_demand+sum_losts) as dem1full,
         sum(fact_demand+fact_losts) as fact_dem1full
         from acd_pwr_demand_tbl as a 
         join acm_bill_tbl as bill on (a.id_doc = bill.id_doc )
         join (select distinct id_client,code_eqp from bal_eqp_tmp where type_eqp = 12 and id_client <> vid_res order by id_client, code_eqp ) as e on (a.id_point = e.code_eqp and bill.id_client = e.id_client)
--         join (select id_client,code_eqp from bal_eqp_tmp where type_eqp = 12 and id_client <> vid_res order by id_client, code_eqp ) as e on (a.id_point = e.code_eqp and bill.id_client = e.id_client)
         where 

         a.kind_energy=1 
         and (bill.idk_doc <> 280) 
         --and a.mmgg=vmmgg::date
	 and bill.mmgg=vmmgg::date
         group by a.id_point
         order by a.id_point         
        ) as c1
        full join
        (
         select a.id_point,((sum(sum_demand+sum_losts))*cal_days_fun(min(a.dat_b),dte::date)/cal_days_fun(min(a.dat_b), max(a.dat_e)))::int as dem2,
                           ((sum(fact_demand+fact_losts))*cal_days_fun(min(a.dat_b),dte::date)/cal_days_fun(min(a.dat_b), max(a.dat_e)))::int as fact_dem2 
         from acd_pwr_demand_tbl as a 
         join acm_bill_tbl as bill on (a.id_doc = bill.id_doc )
         join (select distinct id_client, code_eqp from bal_eqp_tmp where type_eqp = 12 and id_client <> vid_res order by id_client, code_eqp) as e on (a.id_point = e.code_eqp and bill.id_client = e.id_client)
--         join (select id_client, code_eqp from bal_eqp_tmp where type_eqp = 12 and id_client <> vid_res order by id_client, code_eqp) as e on (a.id_point = e.code_eqp and bill.id_client = e.id_client)
         where 
         a.kind_energy=1 
         and (bill.idk_doc <> 280) 
         --and a.mmgg=vmmgg_next
         and bill.mmgg=vmmgg_next
         and vid_res = vid_rres    --для Славутича берем только первый счет
         and vmode = 1  
         group by a.id_point
         order by a.id_point
        ) as c2  using (id_point)
       ) as c
       join  (select distinct code_eqp, dat_b, dat_e, id_client, type_eqp from bal_eqp_tmp where type_eqp = 12 order by code_eqp ) as b  on (c.id_point = b.code_eqp) 
      ) as sdem
      join eqm_point_tbl as p on (sdem.code_eqp=p.code_eqp)
      join clm_client_tbl as clm on (sdem.id_client = clm.id);

     Raise Notice ''demand select .. '';

   if vid_res = vid_rres then
    -- только для пофидерного анализа, для Славутича не считаем
    --потери в счетчике
    update bal_acc_tmp set losts_meter = ml.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600 * 1000 ,
    sumlosts_meter = ml.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600 * 1000 ,
    losts = coalesce(round(ml.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600 * 1000),0),
    id_spr_type = id_type_eqp
    from 
     (select kz.id_point, kz.id_meter, kz.id_type_eqp,im.kind_meter,im.phase, coalesce(rtrim(mp.cl,''0. ''),''2'') as class
     from acd_met_kndzn_tbl as kz join eqi_meter_tbl as im on (im.id = kz.id_type_eqp)
     left join eqi_meter_prec_tbl as mp on (mp.id_type_eqp = im.id)
     where kz.kind_energy = 1 and kz.dat_b<kz.dat_e
     and kz.mmgg = vmmgg::date
     ) as ss
     join eqi_meter_losts_tbl as ml on (ss.kind_meter = ml.kind_meter and ss.phase = ml.phase and ss.class = ml.class)
     where bal_acc_tmp.code_eqp = ss.id_point; 

    -- потери в тр. тока.
    update bal_acc_tmp set losts_ti =ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600  ,
    sumlosts_ti =ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600  ,
    losts = losts+ coalesce(ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600,0) ,
    id_un = un
    from 
     ( select id_point,p.id_un, coalesce(p.id_un,p.id_voltage) as un,
     CASE WHEN  coalesce(p.id_un,p.id_voltage) in (4,41) THEN 50::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) in (31,32) THEN 60::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) = 3 THEN 100::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) in (2,21) THEN 400::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) = 1 THEN 1100::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) = 11 THEN 1500::numeric/8784 
     END::numeric as power_lost
     from acd_met_kndzn_tbl as kz 
     join eqm_point_tbl as p on (p.code_eqp = kz.id_point)
     where kz.kind_energy = 1 and kz.dat_b<kz.dat_e
     and kz.mmgg = vmmgg::date
     and coalesce(kz.k_ts,1)<>1
     ) as ss
     where bal_acc_tmp.code_eqp = ss.id_point; 

    Raise Notice ''demand select ... '';

    -- потери в тр. напряжения
    update bal_acc_tmp set losts_tu =ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600  ,
    sumlosts_tu =ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600  ,
    losts = losts+ coalesce(ss.power_lost*extract (''epoch'' from bal_acc_tmp.dat_e::timestamp - bal_acc_tmp.dat_b::timestamp)/3600,0) ,
    id_un = un
    from 
     ( select id_point,p.id_un,coalesce(p.id_un,p.id_voltage) as un, 
     CASE WHEN  coalesce(p.id_un,p.id_voltage) in (31,32) THEN 1530::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) = 3 THEN 1900::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) in (2,21) THEN 3600::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) = 1 THEN 11000::numeric/8784 
          WHEN  coalesce(p.id_un,p.id_voltage) = 11 THEN 11800::numeric/8784 
     END::numeric as power_lost
     from acd_met_kndzn_tbl as kz 
     join eqm_point_tbl as p on (p.code_eqp = kz.id_point)
     where kz.kind_energy = 1 and kz.dat_b<kz.dat_e
     and kz.mmgg = vmmgg::date
     and coalesce(kz.k_ts,1)<coalesce(kz.k_tr,1)
     ) as ss
     where bal_acc_tmp.code_eqp = ss.id_point; 
   

   Raise Notice ''demand fizzz '';


   insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,fiz_count,fiz_power,fiz_demand,losts,losts_meter,sumlosts_meter,mmgg) 
   select -dem.id_eqpborder,dtb::date,dte::date,sum(value),sum(value),count(distinct dem.id_client),sum(pc.set_power), sum(value),
   max(ml.max_lost)*count(distinct dem.id_client)*extract (''epoch'' from dte::timestamp - dtb::timestamp)/3600 * 1000,
   max(ml.max_lost)*count(distinct dem.id_client)*extract (''epoch'' from dte::timestamp - dtb::timestamp)/3600 * 1000,
   max(ml.max_lost)*count(distinct dem.id_client)*extract (''epoch'' from dte::timestamp - dtb::timestamp)/3600 * 1000,
   dtb::date 
   from bal_eqp_tmp as eq join acm_privdem_tbl as dem on (eq.code_eqp = -dem.id_eqpborder)
   join clm_pclient_tbl as pc on (pc.id = dem.id_client)
   ,(select max(power_lost) as max_lost from eqi_meter_losts_tbl where kind_meter = 1 and phase = 1) as ml
   where dem.mmgg = vmmgg::date and eq.mmgg = vmmgg::date
   group by dem.id_eqpborder;

  else
   Raise Notice ''demand fizzz '';

   insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,fiz_count,fiz_power,losts,mmgg) 
   select -dem.id_eqpborder,dtb::date,dte::date,sum(value),sum(value),count(distinct dem.id_client),sum(pc.set_power), 0,dtb::date 
   from bal_eqp_tmp as eq join acm_privdem_tbl as dem on (eq.code_eqp = -dem.id_eqpborder)
   join clm_pclient_tbl as pc on (pc.id = dem.id_client)
   where dem.mmgg = vmmgg::date and eq.mmgg = vmmgg::date
   group by dem.id_eqpborder;

  end if;

   Raise Notice ''demand select end '';
 
 for r in select * from bal_eqp_tmp where id_p_eqp is null 
   and mmgg = vmmgg 
 loop
   rs:=sel_bal_par_desc(r.code_eqp,r.type_eqp,dtb,dte,r.id_client,vid_res);
 end loop;

 -- добавить нулевые записи для ТУ, по которым не было никакого потребления 
 insert into bal_acc_tmp (code_eqp,dat_b,dat_e,demand,demand04,fiz_count,fiz_power,losts,mmgg)
 select eq.code_eqp,dtb::date,dte::date,0,0,0,0,0,vmmgg 
 from bal_eqp_tmp as eq 
 where eq.type_eqp = 12 and eq.id_client <> vid_res 
 and not exists (select ac2.code_eqp from bal_acc_tmp as ac2 where ac2.code_eqp = eq.code_eqp);


 Return true;
end;
' Language 'plpgsql';

