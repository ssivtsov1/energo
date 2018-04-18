--drop function calc_bal_lost(int);
create or replace function calc_bal_lost(int,timestamp) Returns boolean As'
Declare
ide Alias for $1;
dtb Alias for $2;
r record;
rs boolean;
wp numeric;
wq numeric;
wp1 record;
tgfi numeric;
sumlta_xx int;
sumlta_kz int;
/*
sumla numeric;
vlost_linea numeric;
vlost_linec numeric;
vlost_air numeric;
vlost_cable numeric;
*/

sumla int;
vlost_linea int;
vlost_linec int;
vlost_air int;
vlost_cable int;

vweather int;
vweather_coef numeric;
vs numeric;
vg0 numeric;
begin

vlost_linea:=0;
vlost_linec:=0;
vlost_air :=0;
vlost_cable :=0;

sumlta_xx:=0;
sumlta_kz:=0;

--rs:=false;
tgfi:=0.8;
select into wp1 coalesce(sum(demand),0) as wps,coalesce(sum(demand04),0) as wps04,
 coalesce(sum(lst+losts),0) as lst,
 coalesce(sum(sumlosts_ti),0) as sumlosts_ti,coalesce(sum(sumlosts_tu),0) as sumlosts_tu , coalesce(sum(sumlosts_meter),0) as sumlosts_meter ,
 coalesce(sum(sumlosts_linea),0) as sumlosts_linea, coalesce(sum(sumlosts_linec),0) as sumlosts_linec,
 coalesce(sum(sumlosts_kz),0) as sumlosts_kz, coalesce(sum(sumlosts_xx),0) as sumlosts_xx,
 coalesce(sum(sumlosts_air),0) as sumlosts_air, coalesce(sum(sumlosts_cable),0) as sumlosts_cable,
 coalesce(sum(fiz_demand),0) as fiz_demand, coalesce(sum(nolost_demand),0) as nolost_demand
from bal_acc_tmp as a,bal_eqp_tmp as b 
where a.code_eqp=b.code_eqp and b.id_p_eqp=ide and a.mmgg=b.mmgg and a.mmgg=dtb::date;

select into r * from bal_eqp_tmp where code_eqp=ide and mmgg=dtb::date;

if r.loss_power <>0 then 

 wp:=wp1.wps+wp1.lst;
 wq:=round(wp*tgfi,0);


 if r.type_eqp=2 then
   sumlta_xx:=round(r.pxx_r0::numeric*r.tt,0)::int;
   sumlta_kz:=round((wp::bigint*wp::bigint+wq::bigint*wq::bigint)/(r.sn_len::bigint*r.sn_len::bigint*r.tt)::numeric*r.pkz_x0,0)::int;
   sumla:=coalesce((sumlta_xx+sumlta_kz),0);
 --  rs:=true;
 end if;
 if r.type_eqp in (6,7) then
   sumla:=coalesce(round((wp::bigint*wp::bigint+wq::bigint*wq::bigint)/(r.ukz_un::bigint*r.ukz_un::bigint*r.tt)::numeric*r.pxx_r0*r.sn_len,0)::int,0); 
 --  rs:=true;
   if r.type_eqp = 7 then
     vlost_air :=sumla;
     --расчет доп потерь в изоляции воздушных линий. Зависит от погоды, уровня напряжения и длины линии
     select into vweather weather from bal_weather_calendar_tbl where mmgg = dtb::date;
     select into vweather_coef power_lost from bal_weather_coef_tbl where weather = vweather and voltage = r.ukz_un;

     if found then

	vlost_linea=round(coalesce(vweather_coef*r.sn_len*r.tt/1000,0),0);
        sumla:=sumla+vlost_linea;
     end if;
   end if;

   if r.type_eqp = 6 then
      vlost_cable :=sumla;  
      select into vs s_nom from eqi_cable_tbl where id = r.id_type_eqp;
      select into vg0 g0 from bal_cable_coef_tbl where s_min<= vs and s_max>= vs and voltage = r.ukz_un;

     if found then

	vlost_linec=round(coalesce(vg0*0.02*r.sn_len*r.tt/1000,0),0);
        sumla:=sumla+vlost_linec;
     end if;


   end if;

 end if;
else
 sumla:=0;
end if;
--if rs then
insert into bal_acc_tmp(code_eqp,dat_b,dat_e,demand,demand04,lst,losts,losts_linea,losts_linec,sumlosts_ti,sumlosts_tu,
   sumlosts_meter,sumlosts_linea,sumlosts_linec,fiz_demand,nolost_demand,losts_kz,losts_xx,sumlosts_kz,sumlosts_xx,
   losts_air,losts_cable, sumlosts_air, sumlosts_cable, mmgg) 
values(ide,r.dat_b,r.dat_e,wp1.wps,wp1.wps04,wp1.lst,sumla,vlost_linea,vlost_linec,
wp1.sumlosts_ti,wp1.sumlosts_tu,wp1.sumlosts_meter,wp1.sumlosts_linea+vlost_linea,wp1.sumlosts_linec+vlost_linec,wp1.fiz_demand,wp1.nolost_demand,
sumlta_kz,sumlta_xx,wp1.sumlosts_kz+sumlta_kz,wp1.sumlosts_xx+sumlta_xx,vlost_air,vlost_cable,wp1.sumlosts_air+vlost_air,wp1.sumlosts_cable +vlost_cable,
dtb::date);
--end if;
Return rs;
end;
' Language 'plpgsql';
