--drop function sel_bal_par(int,int);
create or replace function sel_bal_par(int,int,timestamp) Returns boolean As'
Declare
ide Alias for $1;
tpe Alias for $2;
dtb Alias for $3;
tp_c int;
begin
 if (tpe=2) then 
  select into tp_c id_type_eqp from eqm_compensator_tbl where code_eqp=ide;

  update bal_eqp_tmp set id_type_eqp=id,sn_len=coalesce(power_nom,0),pxx_r0=coalesce(iron,0)
  ,pkz_x0=coalesce(copper,0),ixx=coalesce(amperage_no_load,0),ukz_un=coalesce(voltage_short_circuit,0)
  ,tt=cnt_time(dat_b,dat_e,24)
  from eqi_compensator_tbl a,eqi_compensator_2_tbl b 
  where a.id=tp_c and b.id_type_eqp=a.id and bal_eqp_tmp.code_eqp=ide and mmgg=dtb::date;
 end if;
---corrrr!!!!!!!!!!!!
 if (tpe=6) then 
  update bal_eqp_tmp set id_type_eqp=a.id,sn_len=b.length,pxx_r0=a.ro
  ,pkz_x0=a.xo,ukz_un=c.voltage_min*1000,tt=cnt_time(dat_b,dat_e,24)
  from eqi_cable_tbl a, eqm_line_c_tbl b, eqk_voltage_tbl as c  
  where a.id=b.id_type_eqp and b.code_eqp=ide and b.id_voltage=c.id 
   and bal_eqp_tmp.code_eqp=ide and mmgg=dtb::date;
 end if; 

 if (tpe=7) then 
  update bal_eqp_tmp set id_type_eqp=a.id,sn_len=b.length,pxx_r0=a.ro
  ,pkz_x0=a.xo,ukz_un=c.voltage_min*1000,tt=cnt_time(dat_b,dat_e,24)
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
vmmgg date;
begin

 Raise Notice ''equipment  %'',ide;

 vmmgg:=date_trunc(''month'',dtb)::date;
 -- получить параметры данного екземпляра оборудования
 rs:=sel_bal_par(ide,tpe,dtb);

 --сначала рекурсия опускеается вниз, потом при подьеме считает потери
 --т.к. потребление для ТУ мы получили заранее, и они должны быть терминальными,
 --до ТУ можно не опускаться  
 for r in select * from bal_eqp_tmp where id_p_eqp=ide and mmgg::date = vmmgg 
  and ((type_eqp <> 12) or (id_client=pid_res))
 loop
   rs:=sel_bal_par_desc(r.code_eqp,r.type_eqp,dtb,dte,r.id_client,pid_res);
 end loop;

 if (tpe<>12) then

   if (tpe in (2,6,7)) then

     rs:=calc_bal_lost(ide,dtb);

   else
     -- как сумму потомков
     insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,lst,mmgg) 
     select d.code_eqp,d.dat_b,d.dat_e,c.dem,c.dem04,c.lst,dtb::date from 
      (select sum(demand) as dem,sum(demand04) as dem04,sum(losts+lst) as lst,b.id_p_eqp as code_eqp 
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
      insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,lst,mmgg) 
      select d.code_eqp,d.dat_b,d.dat_e,c.dem,c.dem04,c.lst,dtb::date from 
       (select sum(demand) as dem,sum(demand04) as dem04,sum(losts+lst) as lst,b.id_p_eqp as code_eqp 
        from bal_acc_tmp as a,bal_eqp_tmp as b 
       where a.code_eqp=b.code_eqp and b.id_p_eqp=ide 
       and a.mmgg=b.mmgg and a.mmgg=vmmgg
       group by b.id_p_eqp) as c 
       right join
       (select code_eqp,dat_b,dat_e from bal_eqp_tmp where code_eqp=ide and mmgg=vmmgg limit 1) as d
       on (c.code_eqp=d.code_eqp);
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
vid_res int;
vid_rres int;

begin

 vmmgg:=date_trunc(''month'',dtb)::date;

 select into vid_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_bal'';
 select into vid_rres to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

   Raise Notice ''demand select start '';


   -- выбрать все потребление по точкам учета заранее,
   -- чтобы не выбирать по одному при обходе дерева
   insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,losts,mmgg) 
    select  sdem.code_eqp,sdem.dat_b,sdem.dat_e,
    CASE WHEN sdem.dem>9000 and clm.book <> -1 THEN 0 ELSE sdem.dem END AS dem,
    CASE WHEN p.id_voltage=4 and (sdem.dem<=9000 or clm.book = -1) THEN sdem.dem ELSE 0 END AS dem04,
  --      sdem.lst
    0,dtb::date 
     from
      (
       select b.code_eqp,b.dat_b,b.dat_e,b.id_client,
--       coalesce(c.dem1,0)+coalesce(c.dem2,0) as dem
       --если нет счета за след. месяц, берем весь текущий, иначе пропорционально
       CASE WHEN  c.dem2 is null THEN c.dem1full 
       ELSE (coalesce(c.dem1,0)+coalesce(c.dem2,0)) END as dem
--         (coalesce(c1.lst,0)+coalesce(c2.lst,0)) as lst
       from  
       (
        (
         select id_point,((sum(sum_demand+sum_losts))*cal_days_fun(dtb::date, max(dat_e))/cal_days_fun(min(dat_b), max(dat_e)))::int as dem1,
         sum(sum_demand+sum_losts) as dem1full
         from acd_pwr_demand_tbl as a 
         join (select distinct code_eqp from bal_eqp_tmp where type_eqp=12 order by code_eqp) as e on (a.id_point = e.code_eqp)
         where 
--       a.id_point=ide and 
         a.kind_energy=1 
         and a.mmgg=vmmgg::date
         and a.dat_b<a.dat_e
         group by a.id_point
        ) as c1
        full join
        (
         select id_point,((sum(sum_demand+sum_losts))*cal_days_fun(min(dat_b),dte::date)/cal_days_fun(min(dat_b), max(dat_e)))::int as dem2 
         from acd_pwr_demand_tbl as a 
         join (select distinct code_eqp from bal_eqp_tmp where type_eqp=12 order by code_eqp) as e on (a.id_point = e.code_eqp)
         where 
--      a.id_point=ide and 
         a.kind_energy=1 
         and a.mmgg=(vmmgg::date+''1 month''::interval)
         and a.dat_b<a.dat_e
         and vid_res = vid_rres    --для Славутича берем только первый счет
         group by a.id_point
        ) as c2  using (id_point)
       ) as c
       join  bal_eqp_tmp as b  on (c.id_point = b.code_eqp) 
       where b.mmgg=vmmgg and b.type_eqp = 12 
--       and b.id_client<>vid_res 
      ) as sdem
      join eqm_point_tbl as p on (sdem.code_eqp=p.code_eqp)
      join clm_client_tbl as clm on (sdem.id_client = clm.id);

   Raise Notice ''demand fizzz '';

/*  
   insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,fiz_count,losts,mmgg) 
   select -dem.id_eqpborder,dtb::date,dte::date,sum(value),sum(value),count(distinct dem.id_client),0,dtb::date 
   from bal_eqp_tmp as eq join acm_privdem_tbl as dem on (eq.code_eqp = dem.id_eqpborder)
   where dem.mmgg = vmmgg::date and eq.mmgg = vmmgg::date
   group by dem.id_eqpborder;
*/

   insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,fiz_count,losts,mmgg) 
   select -dem.id_eqpborder,dtb::date,dte::date,sum(value),sum(value),count(distinct dem.id_client),0,dtb::date 
   from bal_eqp_tmp as eq join acm_privdem_tbl as dem on (eq.code_eqp = -dem.id_eqpborder)
   where dem.mmgg = vmmgg::date and eq.mmgg = vmmgg::date
   group by dem.id_eqpborder;

   Raise Notice ''demand select end '';


 
 for r in select * from bal_eqp_tmp where id_p_eqp is null 
   and mmgg = vmmgg 
 loop
   rs:=sel_bal_par_desc(r.code_eqp,r.type_eqp,dtb,dte,r.id_client,vid_res);
 end loop;
  

 Return true;
end;
' Language 'plpgsql';

