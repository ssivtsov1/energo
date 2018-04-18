--set client_encoding='koi8';

/*
drop function sel_fullcalc_tree(int,date,date,int);
drop function sel_eqstart(int,date); 
  */


--drop function pnt_tree(int,int,date,date,int,int,int,int,int);
create or replace function pnt_tree(int,int,date,date,int,int,int,int,int) Returns boolean As'
Declare
id_eqp Alias for $1;
idp_eqp Alias for $2;
dtb Alias for $3;
dte Alias for $4;
idcl Alias for $5;
idrcl Alias for $6;
typ Alias for $7;
midcl Alias for $8;
id_tr Alias for $9;
r record;
nidp_eqp int;
rs boolean;
cnt int;
begin

select into cnt count(*) from act_point_branch_tbl where 
    id_point=id_eqp and dat_b=dtb
    and (coalesce(id_p_point,0) = idp_eqp or idp_eqp is null);


if cnt>0  then
 Raise Notice '' cnt % '',cnt;
 Raise Notice ''dtb % '',dtb;
 Raise Notice ''- - - find p point, eqp %'',idp_eqp;
 Raise Notice ''- - - find point, eqp %'',id_eqp;
 Raise Notice ''- - - idcl % idrcl %'',idcl,idrcl;

end if;

Raise Notice ''- - - find point, eqp %'',id_eqp;
 Raise Notice ''dtb % '',dtb;
Raise Notice ''- - - idcl % idrcl %   midkl % '',idcl,idrcl,midcl; 

/*
if ((typ=12) or (typ=13)) then
 if cnt=0 then
  Raise Notice ''dtb % '',dtb;
  Raise Notice ''- - - insert into  act_point_branch_tbl , eqp %  typ  %'',id_eqp,typ;
  if typ=12  then 
    insert into act_point_branch_tbl(id_point,id_p_point,dat_b,dat_e,id_client
      ,id_rclient,id_tree) 
    values(id_eqp,idp_eqp,dtb,dte,idcl,idrcl,id_tr);
  else
    insert into act_2point_branch_tbl(id_2point,id_p_point,dat_b,dat_e,id_client
      ,id_rclient,id_tree) 
    values(id_eqp,idp_eqp,dtb,dte,idcl,idrcl,id_tr);
  end if;
 end if;
  nidp_eqp:=id_eqp;
else
  nidp_eqp:=idp_eqp;
end if;

if not (((typ=12) or (typ=13)) and idcl<>midcl) then
  for r in select code_eqp,id_client,id_rclient,type_eqp,id_tree
    ,case when dat_b<=dtb then dtb else dat_b end as dat_b
    ,case when dat_e>=dte then dte else dat_e end as dat_e
     from act_eqp_branch_tbl where id_p_eqp=id_eqp 
        and (dat_e>dtb and dat_b<dte) loop

     --  raise notice ''id_p_point  -- %'',id_p_eqp;
     --  raise notice ''id_p_point  -- %'',id_eqp;

    rs:=pnt_tree(r.code_eqp,nidp_eqp,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,midcl,r.id_tree);
  end loop;
end if;
*/
if (typ=12 ) then
 if cnt=0 then
  Raise Notice ''dtb % '',dtb;
  Raise Notice ''- - - insert into  act_point_branch_tbl , eqp %  typ  %'',id_eqp,typ;
    insert into act_point_branch_tbl(id_point,id_p_point,dat_b,dat_e,id_client
      ,id_rclient,id_tree) 
    values(id_eqp,idp_eqp,dtb,dte,idcl,idrcl,id_tr);
  end if;
  nidp_eqp:=id_eqp;
else
  nidp_eqp:=idp_eqp;
end if;

if (typ=13) then
 if cnt=0 then
  Raise Notice ''dtb % '',dtb;
  Raise Notice ''- - - insert into  act_point_branch_tbl , eqp %  typ  %'',id_eqp,typ;
    insert into act_2point_branch_tbl(id_2point,id_p_point,dat_b,dat_e,id_client
      ,id_rclient,id_tree) 
    values(id_eqp,idp_eqp,dtb,dte,idcl,idrcl,id_tr);
  end if;  
  end if;  
 
if not (typ=12 and idcl<>midcl) then
  for r in select code_eqp,id_client,id_rclient,type_eqp,id_tree
    ,case when dat_b<=dtb then dtb else dat_b end as dat_b
    ,case when dat_e>=dte then dte else dat_e end as dat_e
     from act_eqp_branch_tbl where id_p_eqp=id_eqp 
        and (dat_e>dtb and dat_b<dte) loop

     --raise notice ''id_p_point   %'',id_p_eqp;
     --  raise notice ''++++++++++id_p_point   %'',id_eqp;
     raise notice ''pnt_tree(r.code_eqp,nidp_eqp,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,midcl,r.id_tree)'';
     raise notice ''pnt_tree(%,%,%,%,%,%,%,%,%)'',r.code_eqp,nidp_eqp,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,midcl,r.id_tree;
    rs:=pnt_tree(r.code_eqp,nidp_eqp,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,midcl,r.id_tree);
  end loop;
end if;

RETURN True;
end;
' Language 'plpgsql';


--drop function up_pnt(int,int,date,date);
---------------------------------------------------------------------------
create  or replace function up_pnt(int,int,date,date,int) Returns boolean As'
Declare
id_eqp Alias for $1;
id_deqp Alias for $2;
dtb Alias for $3;
dte Alias for $4;
cou alias for $5;
r record;
rs boolean;
pnt int;
cnt int;
begin
pnt:=id_deqp;

  Raise Notice ''-   find p point, eqp %'',id_eqp;
  Raise Notice ''-   find p point, count %'',cou;
if cou>10000 then
Return false;
end if;

for r in select code_eqp,id_p_eqp,id_client,id_rclient,type_eqp,line_no
   ,case when dat_b<=dtb then dtb else dat_b end as dat_b
   ,case when dat_e>=dte then dte else dat_e end as dat_e 
   ,id_tree
   from act_eqp_branch_tbl where code_eqp=id_eqp and dat_b<dte 
   and dat_e>dtb and line_no=0 order by code_eqp,line_no

loop

   select into cnt count(*) from act_point_branch_tbl where 
    id_point=r.code_eqp and dat_b<=r.dat_b and dat_e>=r.dat_e;

if cnt>0  then
if r.line_no<>0 then
 Raise Notice '' ***************** cnt % '',cnt;
 Raise Notice ''dtb % '',dtb;
 Raise Notice ''- - - find p point, eqp %'',r.id_p_eqp;
 Raise Notice ''- - - find point, eqp %'',r.code_eqp;
 Raise Notice ''- - - idcl % idrcl %'',r.id_client,r.id_rclient;
end if;
end if;

 
   if r.type_eqp=12 then
    if cnt<=0 then
     insert into act_point_branch_tbl(id_point,id_p_point,dat_b,dat_e,id_client
      ,id_rclient,id_tree) 
     values(r.code_eqp,null,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.id_tree); 
   end if;

   if r.line_no=0 then
     Raise Notice ''-  upd  p point, eqp %  p_eqp %'',id_eqp,id_deqp;
    update act_point_branch_tbl set id_p_point=id_eqp where id_point=id_deqp; 
   end if;
    pnt:=id_eqp;
  end if;
  if r.id_p_eqp is not null then
    Raise Notice ''- - - r_id_p_eqp %'',r.id_p_eqp;
    rs:=up_pnt(r.id_p_eqp,pnt,r.dat_b,r.dat_e,cou+1);
  end if; 
end loop;


Return true;
end;
' Language 'plpgsql';




--drop function desc_border(int,int,date,date);
create or replace function desc_border(int,int,date,date) Returns Text As '
Declare
idp Alias for $1;
id_peqp Alias for $2;
dtb Alias for $3;
dte Alias for $4;
r record;
rs text;
st text;
r1 record;
id_desc int;
id_p int;
begin
rs:='''';
for r in select a.code_eqp,a.id_p_eqp,a.id_client,a.id_rclient,a.type_eqp
   ,a.loss_power
   ,case when a.dat_b<=dtb then dtb else a.dat_b end as dat_b
   ,case when a.dat_e>=dte then dte else a.dat_e end as dat_e 
    from act_eqp_branch_tbl as a 
   where a.id_p_eqp=id_peqp and a.dat_b<dte and a.dat_e>dtb 
   and a.type_eqp not in (1,10)  order by a.type_eqp loop
raise notice '' OSA Descborder r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %'',  id_peqp,r.code_eqp,r.type_eqp;
 if r.type_eqp=9 then 
   for r1 in select c.code_eqp,a.code_eqp as c_eqp,b.id_point,b1.count_lost
       from 
       (select * from act_eqp_branch_tbl where code_eqp=r.code_eqp) as c 
       left join 
       (select * from act_eqp_branch_tbl where type_eqp=12) as a 
         on (c.id_rtree=a.id_tree)
        left join (select distinct id_point from act_meter_pnt_tbl) as b 
          on (a.code_eqp=b.id_point) 
        left join (select distinct id_point,count_lost from act_pnt_lost) as b1 
          on (a.code_eqp=b1.id_point)     
        
    loop

     if r1.c_eqp is null then
       rs:=text(idp)||'';'';
     else 
       if r1.id_point is null  then  --or coalesce(r1.count_lost,0)=1 
        rs:=text(r1.c_eqp)||'';'';
       else 
         rs:=null;
       end if;
     end if;                 	
   end loop;
 end if;

if rs='''' then
    rs:=desc_border(idp,r.code_eqp,r.dat_b,r.dat_e);
 raise notice '' rs ___  idp - %,  r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %'',  idp,id_peqp,r.code_eqp,r.type_eqp;

  /*   
    if rs is null or rs='''' then
      Raise NOtice ''Error in eqp on RES site for id_point - %'',idp;
      insert into act_res_notice values(''Error in eqp on RES site for id_point - ''||idp||''code_eqp - ''||r.code_eqp);
      Return null;
    end if;
  */     

raise notice '' split01    r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %'', id_peqp,r.code_eqp,r.type_eqp;

 if r.type_eqp in (2,6,7) then
     raise notice '' split1    r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %, rs-  -%,ooo'',   id_peqp,r.code_eqp,r.type_eqp,rs;
   if rs='''' or rs is null then
      raise notice '' split -  -  -  error!!!    r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %, rs -% '',   id_peqp,r.code_eqp,r.type_eqp,rs;
          raise notice ''Ошибка возле  Т.У с кодом - %. Оборудование код - % не имеет вхождения в схему или нет границы раздела.'', id_peqp,r.code_eqp;
          return null;
          raise exception ''Ошибка возле  Т.У с кодом - %. Оборудование код - % не имеет вхождения в схему или нет границы раздела.'', id_peqp,r.code_eqp;
--     raise exception ''error  near point  Проверьте Т.У ''||r.code_eqp||'' Оборудование должно иметь вхождение в схему ''|| id_p_eqp;
   end if;
    id_p:=int4(split_part(rs,'';'',1)); 
    raise notice '' split    r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %'',id_peqp,r.code_eqp,r.type_eqp;
--end if;
-----27.10.2005
 if id_p is not null then
  raise notice '' id_p    r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %'',id_peqp,r.code_eqp,r.type_eqp;
-----27.10.2005
  if r.type_eqp=2 and r.loss_power=1 then
    insert into act_losts_eqm_tbl(id_point,id_eqp,id_p_eqp,dat_b
      ,dat_e,type_eqm,id_type_eqp,sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,res_l) 
    select id_p,r.code_eqp,null,c.dt_b,c.dt_e,r.type_eqp 
     ,a.id,coalesce(power_nom,0),cnt_time(c.dt_b,c.dt_e,24),coalesce(iron,0)
     ,coalesce(copper,0),coalesce(amperage_no_load,0)
     ,coalesce(voltage_short_circuit,0),1  
    from (select id_type_eqp
                 ,case when dt_b<=r.dat_b then r.dat_b else dt_b end as dt_b
                 ,case when coalesce(dt_e,r.dat_e)>=r.dat_e then r.dat_e else dt_e end as dt_e
           from eqm_compensator_h where code_eqp=r.code_eqp 
            and dt_b<r.dat_e and coalesce(dt_e,r.dat_e)>r.dat_b) as c 
        inner join eqi_compensator_tbl as a on (a.id=c.id_type_eqp) 
        inner join eqi_compensator_2_tbl as b on (b.id_type_eqp=a.id);
---    sum_wp
  end if;
  if r.type_eqp=6 and r.loss_power=1 then
    insert into act_losts_eqm_tbl(id_point,id_eqp,id_p_eqp,dat_b
      ,dat_e,type_eqm,id_type_eqp,sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,res_l) 
    select id_p,r.code_eqp,null,a.dt_b,a.dt_e,r.type_eqp 
      ,c.id,coalesce(a.length,0),0,coalesce(c.ro,0),coalesce(c.xo,0),0
      ,coalesce(b.voltage_min*1000,0),1
    from (select id_type_eqp,id_voltage,length,case when dt_b<=r.dat_b then r.dat_b else dt_b end as dt_b
                 ,case when coalesce(dt_e,r.dat_e)>=r.dat_e then r.dat_e else dt_e end as dt_e
           from eqm_line_c_h where code_eqp=r.code_eqp 
            and dt_b<r.dat_e and coalesce(dt_e,r.dat_e)>r.dat_b) as a 
         left join eqk_voltage_tbl as b on (b.id=a.id_voltage) 
         left join eqi_cable_tbl as c on (c.id=a.id_type_eqp);
  end if;
  if r.type_eqp=7 and r.loss_power=1 then
    insert into act_losts_eqm_tbl(id_point,id_eqp,id_p_eqp,dat_b
      ,dat_e,type_eqm,id_type_eqp,sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,res_l) 
    select id_p,r.code_eqp,null,a.dt_b,a.dt_e,r.type_eqp 
       ,c.id,coalesce(a.length,0),0,coalesce(c.ro,0),coalesce(c.xo,0),0
       ,coalesce(b.voltage_min*1000,0),1 
    from (select id_type_eqp,id_voltage,length,case when dt_b<=r.dat_b then r.dat_b else dt_b end as dt_b
                 ,case when coalesce(dt_e,r.dat_e)>=r.dat_e then r.dat_e else dt_e end as dt_e
           from eqm_line_a_h where code_eqp=r.code_eqp 
            and dt_b<r.dat_e and coalesce(dt_e,r.dat_e)>r.dat_b) as a 
         left join eqk_voltage_tbl as b on (b.id=a.id_voltage) 
         left join eqi_corde_tbl as c on (c.id=a.id_type_eqp);
  end if;
       if rs='''' or rs is null then
      raise notice '' split -  -  -  error!!!    r.code_eqp - %,  id_p_eqp - %, r.type_eqp - %, rs -% '',    id_peqp,r.code_eqp,r.type_eqp,rs;
          raise exception ''Ошибка возле  Т.У с кодом - %. Оборудование код - % не имеет вхождения в схему или нет границы раздела.'', id_peqp,r.code_eqp;
--     raise exception ''error  near point  Проверьте Т.У ''||r.code_eqp||'' Оборудование должно иметь вхождение в схему ''|| id_p_eqp;
   end if;

    if split_part(rs,'';'',2)<>'''' then
      id_desc:=int4(split_part(rs,'';'',2));
      update act_losts_eqm_tbl set id_p_eqp=r.code_eqp where id_point=id_p 
       and id_eqp=id_desc and dat_b<r.dat_e and dat_e>r.dat_b;
    end if;
    rs:=id_p||'';''||text(r.code_eqp)||'';'';
-----27.10.2005
  else 
    rs:=null;
  end if;
-----27.10.2005
 end if; 
end if;
end loop;
Return rs;
end;
' Language 'plpgsql';


drop function inp_losteqm(int);

--drop function mdtb(date,date,text,text,text,int);
create  or replace function mdtb(date,date,text,text,text,int) Returns date As'
Declare
dtb Alias for $1;
dtb1 Alias for $2;
par Alias for $3;
nam Alias for $4;
namt Alias for $5;
cod_e Alias for $6;
r record;
datb date;
st text;
begin
datb:=dtb;
st:=''select code_eqp,case when dt_b<=''||quote_literal(dtb1)||'' then ''
   ||quote_literal(dtb1)||'' else dt_b end as dt_b,dt_e,coalesce(text(''||
   nam||''),''||chr(39)||''0''||chr(39)
   ||'') as param from ''||namt||'' where dt_e<=''||quote_literal(dtb)
   ||'' and dt_e>''||quote_literal(dtb1)||'' and code_eqp=''||cod_e||'' order by dt_b Desc '';
for r in EXECUTE st loop
 if r.param=par then 
   datb:=r.dt_b;
 else
  Return datb;
 end if;
end loop;
Return datb;
end;
' Language 'plpgsql';


--drop function mdtb_kndzn(date,date,int,int,int);
create or replace function mdtb_kndzn(date,date,int,int,int) Returns date As'
Declare
dtb Alias for $1;
dtb1 Alias for $2;
idp Alias for $3;
knde Alias for $4;
zn Alias for $5;
r record;
datb date;
begin
datb:=dtb;
for r in select id_point,kind_energy,id_zone,case when dat_b<=dtb1 then dtb1 
    else dat_b end as dat_b,dat_e from act_met_kndzn_tbl where dat_e<=dtb 
     and dat_e>dtb1 and id_point=idp and kind_energy=knde and id_zone=zn order by dat_b Desc loop
 if r.id_zone=zn then 
   datb:=r.dat_b;
 else
  Return datb;
 end if;
end loop;
Return datb;
end;
' Language 'plpgsql';


--drop function desc_hlosts(int);
create or replace function desc_hlosts(int) Returns boolean As'
Declare
idpnt Alias for $1;
r record;
rs boolean;
begin

   update act_pwr_demand_tbl set 
     sum_losts=round(suml::numeric*round(sum_dem1::numeric/sum_dem,2),0)
    ,fact_losts=round(suml::numeric*round(sum_dem1::numeric/sum_dem,2),0) 
    from 
    (select k12.sum_dem,k1.suml,k1.kind_energy,k2.sum_dem1,k1.dat_b,k2.id_point 
     from 
      (select sum(sum_losts) as suml,id_point
       ,kind_energy,dat_b from act_pwr_demand_tbl where id_point=idpnt 
        group by id_point,kind_energy,dat_b) as k1 
      inner join
      (select sum(sum_demand) as sum_dem,id_point
       ,kind_energy,dat_b from act_pwr_demand_tbl where id_point=idpnt 
         and kind_energy=1
        group by id_point,kind_energy,dat_b) as k12 
      on (k1.id_point=k12.id_point and k1.dat_b=k12.dat_b)
      inner join 
      (select k2.id_point,k2.dat_b,k1.kind_energy,sum(k1.sum_demand) as sum_dem1 
       from (select * from act_pwr_demand_tbl where kind_energy=1) as k1 
       inner join 
      (select distinct a.* from act_point_branch_tbl as a 
       inner join act_pnt_lost as b on (a.id_point=b.id_point) 
         where b.count_lost=1 and id_p_point=idpnt) as k2
         on (k1.id_point=k2.id_point and k1.dat_b<k2.dat_e 
               and k1.dat_e>k2.dat_b) 
         group by k2.id_point,k2.dat_b,k1.kind_energy
       ) as k2 
      on true 
     ) as k 
     where act_pwr_demand_tbl.id_point=k.id_point 
      and act_pwr_demand_tbl.kind_energy=k.kind_energy 
      and act_pwr_demand_tbl.dat_b=k.dat_b and k.kind_energy<>4 and k.suml<>0;

  update act_pwr_demand_tbl set 
   fact_losts=round((k.sum_lost-k.suml)::numeric*round(sum_demand::numeric
     /k.sum_dem,2),0) 
  from (select k1.sum_dem,k3.suml,k1.sum_lost,k1.kind_energy,k1.dat_b,k1.id_point 
     from 
      (select sum(a.sum_demand) as sum_dem,sum(a.fact_losts) as sum_lost
       ,a.id_point
       ,a.kind_energy,a.dat_b from act_pwr_demand_tbl as a where a.id_point=idpnt 
        group by a.id_point,a.kind_energy,a.dat_b) as k1 
      inner join 
     (select sum(k4.sum_losts) as suml,k4.kind_energy,k4.dat_b --,k2.id_point  
      from act_pwr_demand_tbl as k4 inner join 
      (select distinct a.id_point from act_point_branch_tbl as a 
       inner join act_pnt_lost as b on (a.id_point=b.id_point) 
         where b.count_lost=1 and a.id_p_point=idpnt) as k2 
         on (k4.id_point=k2.id_point) group by k4.kind_energy,k4.dat_b
           --  ,k2.id_point
           ) as k3
      on (k1.kind_energy=k3.kind_energy and k1.dat_b=k3.dat_b) 
     ) as k
     where act_pwr_demand_tbl.id_point=k.id_point 
      and act_pwr_demand_tbl.kind_energy=k.kind_energy 
      and act_pwr_demand_tbl.dat_b=k.dat_b and k.kind_energy<>4 and k.sum_lost<>0;

  update act_pwr_demand_tbl set 
   fact_losts=round((k.sum_lost-k.suml)::numeric*round(sum_demand::numeric
     /k.sum_dem,2),0) 
  from (select k1.sum_dem,k3.suml,k1.sum_lost,k1.kind_energy,k1.dat_b,k1.id_point 
     from 
      (select sum(a.sum_demand) as sum_dem,sum(a.fact_losts) as sum_lost
       ,a.id_point
       ,a.kind_energy,a.dat_b from act_pwr_demand_tbl as a where a.id_point=idpnt 
        group by a.id_point,a.kind_energy,a.dat_b) as k1 
      inner join 
 (select sum(round(k.suml::numeric*round(k.sum_dem1::numeric/k.sum_dem,2),0)) as suml
   ,2 as kind_energy,idpnt as id_point,k.dat_b   
    from 
    (select k12.sum_dem,k1.suml,k1.kind_energy,k2.sum_dem1,k1.dat_b,k2.id_point 
     from 
      (select sum(sum_losts) as suml,id_point
       ,kind_energy,dat_b from act_pwr_demand_tbl where id_point=idpnt 
         and kind_energy=2
        group by id_point,kind_energy,dat_b) as k1 
      inner join 
      (select sum(sum_demand) as sum_dem,id_point
       ,kind_energy,dat_b from act_pwr_demand_tbl where id_point=idpnt 
         and kind_energy=1
        group by id_point,kind_energy,dat_b) as k12 
      on (k1.id_point=k12.id_point and k1.dat_b=k12.dat_b)
      inner join 
      (select k2.id_point,k2.dat_b,k1.kind_energy,sum(k1.sum_demand) as sum_dem1 
       from (select * from act_pwr_demand_tbl where kind_energy=1) as k1 
       inner join 
      (select distinct a.* from act_point_branch_tbl as a 
       inner join act_pnt_lost as b on (a.id_point=b.id_point) 
         where b.count_lost=1 and id_p_point=idpnt) as k2
         on (k1.id_point=k2.id_point and k1.dat_b<k2.dat_e 
               and k1.dat_e>k2.dat_b) 
        left join (select * from act_pwr_demand_tbl where kind_energy=2) as c 
          on (c.id_point=k2.id_point and c.dat_b<k2.dat_e and c.dat_e>k2.dat_b)
       where c.id_point is null 
         group by k2.id_point,k2.dat_b,k1.kind_energy
       ) as k2 
      on true 
    ) as k 
   group by k.dat_b)  as k3
      on (k1.kind_energy=k3.kind_energy and k1.dat_b=k3.dat_b) 
     ) as k
     where act_pwr_demand_tbl.id_point=k.id_point 
      and act_pwr_demand_tbl.kind_energy=k.kind_energy 
      and act_pwr_demand_tbl.dat_b=k.dat_b and k.kind_energy<>4 and k.sum_lost<>0;


for r in select distinct a.* from (select * from act_point_branch_tbl where 
    id_p_point=idpnt) as a  
   inner join act_pnt_lost as b on (a.id_point=b.id_point) 
    where b.count_lost=1 loop 
  rs:=desc_hlosts(r.id_point);  
end loop;
Return true;
end;
' Language 'plpgsql';



----Last update 24.01.2011
drop function lost_eqm(int,int,int,date,date,int,int);
drop function lost_eqm(int,int,int,date,date);
drop function lost_eqm(int,int,int,date,date,int);


----Last update 24.01.2011
--drop function inlost_eqm(int,int,int,date,date,int,int);
drop function inlost_eqm(int,int,int,date,date,int,int);
drop function inlost_eqm(int,int,int,date,date);
create or replace function inlost_eqm(int,int,int,date,date,int,int,int,int) Returns boolean As'
Declare
id_p Alias for $1;
ideqp Alias for $2;
id_deqp Alias for $3;
dtb Alias for $4;
dte Alias for $5;
idcl Alias for $6;
cnt_lost Alias for $7;
ppnt Alias for $8; ----- 0 if no parent point exists else 1 
idppnt Alias for $9;------- 0 if no point else id_p_point

r record;
rs boolean;
d_eqp int;
test record;
r_p record;
id_peqp int;
r_l int;
idres int;
id_p_pnt int;
cou int;
begin


d_eqp:=id_deqp;
select into idres int4(value_ident) from syi_sysvars_tbl where ident=''id_res'';
id_p_pnt:=idppnt;
for r in select  code_eqp,id_p_eqp,id_client,id_rclient,type_eqp,loss_power
   ,case when dat_b<=dtb then dtb else dat_b end as dat_b
   ,case when dat_e>=dte then dte else dat_e end as dat_e 
  from act_eqp_branch_tbl where code_eqp=ideqp and dat_b<dte 
   and dat_e>dtb loop
 -- raise notice ''!!!! function inlost_eqm cnt_lost %'',cnt_lost; 
  --  raise notice ''!!!! function inlost_eqm r_l %'',r_l; 

  if (r.id_client=r.id_rclient and r.id_client=idcl) then
    if cnt_lost=1 then 
     r_l:=0;
    else
     r_l:=3;
    end if;
  else
  if (r.id_client<>r.id_rclient and r.id_client=idcl) then
     r_l:=1;
  else
   if (r.id_client=r.id_rclient and r.id_client<>idcl) then
     if ppnt=0 then
       r_l:=2;
     else
       if id_p_pnt=0 then
         r_l:=1;
       else
         r_l:=2;
       end if; 
     end if;
   else
    if (r.id_client<>r.id_rclient and r.id_client<>idcl) then
       r_l:=1;
   end if;
  end if;
  end if;
  end if;

  --  raise notice ''!!!! function inlost_eqm r_l after if %'',r_l; 

  if r.type_eqp=2 and r.loss_power=1 then
   raise notice ''!!!! insert typee %  - code -% '',r.type_eqp,r.code_eqp; 
   insert into act_losts_eqm_tbl(id_point,id_eqp,id_p_eqp,dat_b
      ,dat_e,type_eqm,id_type_eqp,sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,res_l) 
    select id_p,r.code_eqp,null ---d_eqp --,
     ,c.dt_b,c.dt_e,r.type_eqp 
     ,a.id,coalesce(power_nom,0),cnt_time(c.dt_b,c.dt_e,24),coalesce(iron,0)
     ,coalesce(copper,0),coalesce(amperage_no_load,0)
     ,coalesce(voltage_short_circuit,0),r_l  
    from (select id_type_eqp
                 ,case when dt_b<=r.dat_b then r.dat_b else dt_b end as dt_b
                 ,case when coalesce(dt_e,r.dat_e)>=r.dat_e then r.dat_e else dt_e end as dt_e
           from eqm_compensator_h where code_eqp=r.code_eqp 
            and dt_b<r.dat_e and coalesce(dt_e,r.dat_e)>r.dat_b) as c 
        inner join eqi_compensator_tbl as a on (a.id=c.id_type_eqp) 
        inner join eqi_compensator_2_tbl as b on (b.id_type_eqp=a.id);

    update act_losts_eqm_tbl set id_p_eqp=r.code_eqp where id_point=id_p 
     and id_eqp=d_eqp and dat_b<r.dat_e and dat_e>r.dat_b;
    d_eqp:=r.code_eqp;
   select into cou count(*) from  act_losts_eqm_tbl;
   raise notice ''!!!! count typee %  - code -% , strok -%'',r.type_eqp,r.code_eqp,cou; 
  end if;
  if r.type_eqp=6 and r.loss_power=1 then
 raise notice ''!!!! insert typee %  - code -% '',r.type_eqp,r.code_eqp; 
    insert into act_losts_eqm_tbl(id_point,id_eqp,id_p_eqp,dat_b
      ,dat_e,type_eqm,id_type_eqp,sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,res_l) 
    select id_p,r.code_eqp,null -----d_eqp --,
      ,a.dt_b,a.dt_e,r.type_eqp 
      ,c.id,coalesce(a.length,0),0,coalesce(c.ro,0),coalesce(c.xo,0),0
      ,coalesce(b.voltage_min*1000,0),r_l 
    from (select id_type_eqp,id_voltage,length,case when dt_b<=r.dat_b then r.dat_b else dt_b end as dt_b
                 ,case when coalesce(dt_e,r.dat_e)>=r.dat_e then r.dat_e else dt_e end as dt_e
           from eqm_line_c_h where code_eqp=r.code_eqp 
            and dt_b<r.dat_e and coalesce(dt_e,r.dat_e)>r.dat_b) as a 
         left join eqk_voltage_tbl as b on (b.id=a.id_voltage) 
         left join eqi_cable_tbl as c on (c.id=a.id_type_eqp);

    update act_losts_eqm_tbl set id_p_eqp=r.code_eqp where id_point=id_p 
    and id_eqp=d_eqp and dat_b<r.dat_e and dat_e>r.dat_b;
    d_eqp:=r.code_eqp;
   select into cou count(*) from  act_losts_eqm_tbl;
   raise notice ''!!!! count typee %  - code -% , strok -%'',r.type_eqp,r.code_eqp,cou; 

  end if;
  if r.type_eqp=7 and r.loss_power=1 then
    raise notice ''!!!! insert typee %  - code -% '',r.type_eqp,r.code_eqp; 
    insert into act_losts_eqm_tbl(id_point,id_eqp,id_p_eqp,dat_b
      ,dat_e,type_eqm,id_type_eqp,sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,res_l) 
    select id_p,r.code_eqp,null ------------d_eqp --,
       ,a.dt_b,a.dt_e,r.type_eqp 
       ,c.id,coalesce(a.length,0),0,coalesce(c.ro,0),coalesce(c.xo,0),0
       ,coalesce(b.voltage_min*1000,0),r_l 
    from (select id_type_eqp,id_voltage,length,case when dt_b<=r.dat_b then r.dat_b else dt_b end as dt_b
                 ,case when coalesce(dt_e,r.dat_e)>=r.dat_e then r.dat_e else dt_e end as dt_e
           from eqm_line_a_h where code_eqp=r.code_eqp 
            and dt_b<r.dat_e and coalesce(dt_e,r.dat_e)>r.dat_b) as a 
         left join eqk_voltage_tbl as b on (b.id=a.id_voltage) 
         left join eqi_corde_tbl as c on (c.id=a.id_type_eqp);

    update act_losts_eqm_tbl set id_p_eqp=r.code_eqp where id_point=id_p 
     and id_eqp=d_eqp and dat_b<r.dat_e and dat_e>r.dat_b;
    d_eqp:=r.code_eqp;
   select into cou count(*) from  act_losts_eqm_tbl;
   raise notice ''!!!! count typee %  - code -% , strok -%'',r.type_eqp,r.code_eqp,cou; 

  end if;

 for r_p in select distinct code_eqp,type_eqp,id_client,id_rclient from act_eqp_branch_tbl 
      where code_eqp=r.id_p_eqp loop

   if r_p.type_eqp=12 then 
     id_p_pnt:=r.id_p_eqp; 
   end if;

  if (r_p.id_client=r_p.id_rclient and r_p.id_client=idres) then
    id_peqp:=null;
  else
    id_peqp:=r.id_p_eqp;
  end if;
  
 end loop;

  if id_peqp is not null then  
   rs:=inlost_eqm(id_p,r.id_p_eqp,d_eqp,r.dat_b,r.dat_e,idcl,cnt_lost,ppnt,id_p_pnt);
  end if; 

end loop;

for test in select id_point,id_eqp,dat_b ,count(*)
  from act_losts_eqm_tbl group by id_point,id_eqp,dat_b  
  having count(*) >1 loop
 
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_lostse'',100,509,''d_lostse'');
   insert into act_res_notice 
   values(''Double in table act_losts_eqm_tbl p''||test.id_point||'' e ''||test.id_eqp||'' d ''||test.dat_b);
 return false;
end loop;



Return true;
--Return false;

end;
' Language 'plpgsql';
----Last update 24.01.2011

