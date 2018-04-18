-----------///////////////////////////////---------------------
-- ÏÂÒÅÚËÁ ĞÏ enddate
--  DROP FUNCTION eqc_trim_end_fun (integer,timestamp,timestamp);                                                   
                                                                                                  
  CREATE or replace FUNCTION eqc_trim_end_fun (integer,timestamp,timestamp)
  RETURNS int
  AS                                                                                              
  '
  declare
  client Alias for $1;
  begindate Alias for $2;
  enddate Alias for $3;

  begin
  -- ÓŞÅÔŞÉËÉ
--  delete from act_demand_tbl where dat_b>enddate and 
--   id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  delete from act_demand_tbl where oid not in
  (
   select act.oid from act_demand_tbl as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_meter) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);


--  update act_demand_tbl set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  update act_demand_tbl  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_demand_tbl.id_meter) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_demand_tbl.id_meter) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  -- ĞÁÒÁÍÅÔÒÙ
--  delete from act_eqm_par_tbl where dat_b>enddate and
--   id_eqp in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  delete from act_eqm_par_tbl where oid not in
  (
   select act.oid from act_eqm_par_tbl as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_eqp) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_eqp in (select code_eqp from act_eqp_branch_tbl where id_client=client);


--  update act_eqm_par_tbl set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and 
--   id_eqp in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_eqm_par_tbl  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_eqm_par_tbl.id_eqp) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_eqm_par_tbl.id_eqp) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_eqp in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  -- ÚÏÎÙ É ÜÎÅÒÇÉÑ
--  delete from act_met_kndzn_tbl where dat_b>enddate and 
--   id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  delete from act_met_kndzn_tbl where oid not in
  (
   select act.oid from act_met_kndzn_tbl as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_meter) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);


--  update act_met_kndzn_tbl set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and 
--   id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_met_kndzn_tbl  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_met_kndzn_tbl.id_meter) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_met_kndzn_tbl.id_meter) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_meter in (select code_eqp from act_eqp_branch_tbl where id_client=client);


  --ÔÏŞËÉ ÕŞÅÔÁ
--  delete from act_pnt_pwr where dat_b>enddate and 
--   id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  delete from act_pnt_pwr where oid not in
  (
   select act.oid from act_pnt_pwr as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_point) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

--  update act_pnt_pwr set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_pnt_pwr  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_pwr.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_pwr.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

--  delete from act_pnt_knd where dat_b>enddate and 
--   id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  delete from act_pnt_knd where oid not in
  (
   select act.oid from act_pnt_knd as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_point) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

--  update act_pnt_knd set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_pnt_knd  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_knd.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_knd.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

--  delete from act_pnt_tarif where dat_b>enddate and 
--   id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  delete from act_pnt_tarif where oid not in
  (
   select act.oid from act_pnt_tarif as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_point) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);


--  update act_pnt_tarif set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_pnt_tarif
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_tarif.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_tarif.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

--  delete from act_pnt_wtm where dat_b>enddate and 
--   id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  delete from act_pnt_wtm where oid not in
  (
   select act.oid from act_pnt_wtm as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_point) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);


--  update act_pnt_wtm set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_pnt_wtm  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_wtm.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_wtm.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);


--  delete from act_pnt_tg where dat_b>enddate and 
--   id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  delete from act_pnt_tg where oid not in
  (
   select act.oid from act_pnt_tg as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_point) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

--  update act_pnt_tg set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);
  update act_pnt_tg  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_tg.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_tg.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);


  delete from act_pnt_share where oid not in
  (
   select act.oid from act_pnt_share as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.id_point) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
   where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  ) and id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  update act_pnt_share  
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_tg.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_pnt_tg.id_point) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
  where id_point in (select code_eqp from act_eqp_branch_tbl where id_client=client);

  --ÄÅÒÅ×Ï
  delete from act_eqp_branch_tbl where oid not in
  (
  select act.oid from act_eqp_branch_tbl as act  
      left join eqv_eqp_use as eu on ((eu.code_eqp=act.code_eqp) and (eu.id_client=client) and
       tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))
  where tintervalov(tinterval(abstime(act.dat_b),abstime(act.dat_e)),
                    tinterval(abstime(max(begindate,eu.dt_b)),abstime(min(eu.dt_e,enddate))))
  and act.id_client=client
  ) and id_client=client;


--  update act_eqp_branch_tbl set dat_e=enddate where 
--  dat_e>enddate and dat_b<=enddate and id_client=client;

  update act_eqp_branch_tbl   
  set dat_b=max(dat_b, 
   (select dt_b from eqv_eqp_use as eu where (eu.code_eqp=act_eqp_branch_tbl.code_eqp) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate)))))),
 
   dat_e=min(min(dat_e,enddate),
   (select dt_e from eqv_eqp_use as eu where (eu.code_eqp=act_eqp_branch_tbl.code_eqp) and (eu.id_client=client) and
   tintervalov(tinterval(abstime(begindate),abstime(enddate)),
                   tinterval(abstime(coalesce(eu.dt_b,begindate)),abstime(coalesce(eu.dt_e,enddate))))))
   where id_client=client;
  
  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

