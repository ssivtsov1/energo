DROP FUNCTION max (timestamp,timestamp);                                                   
  CREATE FUNCTION max (timestamp,timestamp)
  RETURNS timestamp
  AS                                                                                              
  '
  declare
  date1 Alias for $1;
  date2 Alias for $2;
  begin

  if date1 is NULL then
   RETURN date2;
  end if;

  if date2 is NULL then
   RETURN date1;
  end if;


  if date1>date2 then
   RETURN date1;
  else
   RETURN date2;
  end if;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


drop function min(timestamp,timestamp); 
create function min(timestamp,timestamp) Returns timestamp As'
Declare
dt1 Alias for $1;
dt2 Alias for $2;
dt timestamp;
begin
if dt1 isnull then
  dt:=dt2;
end if;
if (dt2 isnull) then
  dt:=dt1;
end if;
if date_mi(dt1::date,dt2::date)<=0 then
  dt:=dt1;
else 
  dt:=dt2;
end if;
Return dt;
end;
' Language 'plpgsql';

drop function calc_ind_pr(numeric(14,4),numeric(14,4),int);
create function calc_ind_pr(numeric(14,4),numeric(14,4),int) Returns numeric(14,4) As'
Declare
eval Alias for $1;
bval Alias for $2;
carr Alias for $3;
bi int;
ei int;
i int;
st varchar(11);
sti int;
rs numeric;
begin
 bi:=length(cast(cast(trunc(eval) as int) as varchar(25)));
 ei:=length(cast(cast(trunc(bval) as int) as varchar(25)));
 if (bi>carr) or (ei>carr) then
  --ERROR!!!
  rs:=null;
 else
  if (eval>=bval) then
   rs:=eval-bval;
  else
   st:=rpad(''1'',(carr+1),''0'');
   sti:=to_number(st,''9999999999.9999'');
   rs:=(sti-bval)+eval;
  end if;
 end if;
 Return rs;
end;
' Language 'plpgsql';

drop function cnt_time(timestamp,timestamp,int);
create function cnt_time(timestamp,timestamp,int) Returns int As'
Declare
dtb Alias for $1;
dte Alias for $2;
hr Alias for $3;
rs int;
begin
 rs:=hr*date_mi(dte::date,dtb::date);
 if rs>=0 then
 Return rs;
 else
 Return null;
 end if;
end;
' Language 'plpgsql';

drop function del_eqtmp_t(int,int);
create function del_eqtmp_t(int,int) Returns boolean As'
Declare
idcl Alias for $1; -- if 0 then clear all
m_d Alias for $2; -- 1 - all connected clients, 2 - one client
r record;
rs boolean;
begin
if idcl=0 then
 rs=clearadd_ttbl(1);
 delete from act_desclosts_eqm_tbl;
 --delete from del_ind;
 delete from act_res_notice;
 delete from act_pnt_mlost;
 delete from act_pnt_hlosts;
 delete from act_pnt_cntitr;
 delete from act_met_knd;
 delete from act_met_cntmet;
 delete from act_met_warm;
 delete from act_warm_period;
 delete from act_pnt_cntavg;
 delete from act_pnt_cntavgr;
 delete from act_pnt_cntavgg;
 delete from act_pnt_knd;
 delete from act_pnt_lost;
 delete from act_pnt_inlost;
 delete from act_inlosts_eqm_tbl;
 delete from act_pnt_share;
 delete from act_pnt_wtm;
 delete from act_pnt_tg;
 delete from act_pnt_pwr;
 delete from act_pnt_cmp;
 delete from act_pnt_tarif;
 delete from act_pwr_demand_tbl;
 delete from act_2pwr_demand_tbl;

-- delete from act_check_zone;
-- delete from act_check_pnt;
 delete from act_pnt_d;
 delete from act_pnt_un;
-- delete from act_five_per;
-- delete from act_res_msg_tbl;
-- delete from act_ch_err;
 delete from act_demand_tbl;
 delete from act_met_kndzn_tbl;
-- delete from act_eqm_par_tbl;
 delete from act_losts_eqm_tbl;
 delete from act_calc_losts_tbl;
 delete from act_meter_pnt_tbl;
 delete from act_point_branch_tbl;
 delete from act_2point_branch_tbl;
 delete from act_eqp_branch_tbl;
 delete from act_difmetzone_tbl;
 delete from act_pwr_limit_over_tbl;
 delete from act_pwr_limit_pnt_tbl;
else
 if m_d=2 then
--   delete from act_res_msg_tbl where id_client=idcl;
--   delete from act_ch_err
--          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_knd
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_share
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_pwr
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_cmp
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_wtm
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_tg
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pnt_tarif
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_pwr_demand_tbl
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_check_pnt
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_check_zone 
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_eqm_par_tbl 
          where id_eqp in (select code_eqp from act_eqp_branch_tbl where id_client=idcl);
   delete from act_demand_tbl 
          where id_meter in (select id_meter from act_meter_pnt_tbl where id_point in
	  (select id_point from act_point_branch_tbl where id_client=idcl));
   delete from act_met_kndzn_tbl 
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_losts_eqm_tbl
          where id_point in (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_meter_pnt_tbl where id_point in
	  (select id_point from act_point_branch_tbl where id_client=idcl);
   delete from act_point_branch_tbl where id_client=idcl;
   delete from act_eqp_branch_tbl where id_client=idcl;
 delete from act_difmetzone_tbl where id_point in
	  (select id_point_p from act_point_branch_tbl where id_client=idcl);


 else
  if m_d=1 then
   rs:=del_eqtmp_t(idcl,2);
   for r in select * from eqm_borders_tbl where (id_clientB=idcl) 
                     and (id_clientA<>id_department) loop
   if (select code_eqp from act_eqp_branch_tbl where id_client=r.id_clientA limit 1) is not null then
    rs:=del_eqtmp_t(r.id_clientA,1);
   end if;
   end loop;
   for r in select * from eqm_borders_tbl where (id_clientA=idcl) 
                     and (id_clientB<>id_department) loop
    if (select code_eqp from act_eqp_branch_tbl where id_client=r.id_clientB limit 1) is not null then
     rs:=del_eqtmp_t(r.id_clientB,1);
    end if;
   end loop;  
  end if;
 end if;
end if;
Return true;
end;
' Language 'plpgsql';

drop function sel_clpar(int,int,int);
create function sel_clpar(int,int,int) Returns int As'
Declare
idcl Alias for $1;
ide Alias for $2;
tp_m Alias for $3;
r record;
rs int;
cnt int;
begin
 rs:=null;
 for r in select * from act_eqp_branch_tbl where code_eqp=ide and id_client=idcl loop
  if (r.type_eqp<>tp_m) then
   rs:=sel_clpar(idcl,r.id_p_eqp,tp_m);
  else
   rs:=r.code_eqp;
  end if;
end loop;
 Return rs;
end;
' Language 'plpgsql';


drop function sel_warm_period(date,date,date);
create function sel_warm_period(date,date,date) Returns text As'
Declare
dtb Alias for $1;
dte Alias for $2;
mmgg Alias for $3;
res text;
dt_b date;
dt_e date;
begin
--to_date(text,text)=date
--to_char(date,text)=text
 if to_char(mmgg,''MM'')::int<12 then
   dt_b:=(text(to_char(mmgg,''YYYY'')::int-1)||''-12-01'')::date;
   dt_e:=(to_char(mmgg,''YYYY'')||''-03-01'')::date;
 else
   dt_b:=(to_char(mmgg,''YYYY'')||''-12-01'')::date;
   dt_e:=(text(to_char(mmgg,''YYYY'')::int+1)||''-03-01'')::date;
 end if;
 if (dtb<dt_e and dte>dt_b) then 
   res:=to_char(max(dt_b,dtb),''YYYY-MM-DD'')||'';''||to_char(min(dt_e,dte),''YYYY-MM-DD'');
 else 
   res:=null; 
 end if;
raise notice ''warm   - %'',res;
Return res;
end;
' Language 'plpgsql';


create or replace function upd_point() returns int as '
declare trg1 int;
begin
select into trg1 reltriggers from pg_class where relname=''eqm_point_tbl'';
raise notice ''trg1    % '',trg1;
update pg_class set reltriggers=0 where relname=''eqm_point_tbl'';
update eqm_point_tbl set in_lost=0 where in_lost is null;

update eqm_point_h set in_lost=0 where in_lost is null;
update pg_class set reltriggers=trg1 where relname=''eqm_point_tbl'';
return 0;
end;
' Language 'plpgsql';

