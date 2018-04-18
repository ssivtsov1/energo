drop function bal_gorup_tree_divide_fun(int,timestamp,int);

create or replace function bal_gorup_tree_divide_fun(int,timestamp,int,int) 
Returns int As'
Declare

 pcode_eqp Alias for $1;
 pdt Alias for $2;
 plvl Alias for $3;
 pid_fider Alias for $4;

 ts record;
 child record;
 v int;
begin

  select into ts * from bal_grp_tree_conn_tmp where code_eqp=pcode_eqp and dat_b <=pdt and dat_e > pdt;

  if (ts.dat_b<pdt) then
--    update bal_grp_tree_conn_tmp set dat_e = pdt-''1 minutes''::interval,  
    update bal_grp_tree_conn_tmp set dat_e = pdt,  
    demand = ts.demand-ts.demand*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
    demand04 = ts.demand04-ts.demand04*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
    losts = ts.losts-ts.losts*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
    fact_losts = ts.fact_losts-ts.fact_losts*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp)
    where id = ts.id;
  end if;

  delete from bal_grp_tree_conn_tmp where code_eqp = ts.code_eqp and dat_b = pdt;

  insert into bal_grp_tree_conn_tmp(id_tree ,code_eqp ,name,id_p_eqp,type_eqp,dat_b,dat_e,lvl,id_client,id_point ,
        demand,demand04,losts,fact_losts,losts_coef,id_voltage,mmgg,id_fider) 
  values(ts.id_tree ,ts.code_eqp ,ts.name,ts.id_p_eqp,ts.type_eqp,pdt,ts.dat_e,plvl,ts.id_client,ts.id_point ,
        ts.demand*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
        ts.demand04*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
        ts.losts*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
        ts.fact_losts*cal_minutes_fun( pdt::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
        ts.losts_coef,ts.id_voltage,ts.mmgg,pid_fider);


  for child in 
    select * from bal_grp_tree_conn_tmp where id_p_eqp = ts.code_eqp
  loop

    Raise Notice ''update2 %'',child.code_eqp;

    v:=bal_gorup_tree_divide_fun(child.code_eqp,pdt,plvl+1,pid_fider);

  end loop;

 return 0;
end;
' Language 'plpgsql';

-----------------------------------------------------------------------------------------

create or replace function bal_grp_tree_connect_fun(int,date) 
Returns boolean As'
Declare

 pid_res Alias for $1;
 pmmgg Alias for $2;

 v   int;
 dtb date;
 dte date;
 r record;
 child record;
 tf record;
 tf_old record;
 ts record;
 vps_name varchar;
 vid_res int;
begin

/*
   select into dte date_end 
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'')) limit 1;

--   select into dtb date_end + ''1 days''::interval 
   select into dtb date_end 
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg- ''1 month''::interval 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'',''beg_ind'')) limit 1;
*/

   select into dte coalesce(max(date_end),pmmgg + ''1 month''::interval - ''1 days''::interval) 
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'')) ;

   select into dtb coalesce(max(date_end),pmmgg)
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg- ''1 month''::interval 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'',''beg_ind''));

   select into vid_res getsysvar(''id_bal'');

   delete from bal_grp_tree_conn_tmp;

   insert into bal_grp_tree_conn_tmp (id_tree, code_eqp, name, id_p_eqp, type_eqp, dat_b, dat_e, lvl, 
            id_client, id_point, demand, demand04, losts, fact_losts, losts_coef, id_voltage, id_fider,mmgg)
   select id_tree, code_eqp, name, id_p_eqp, type_eqp, dat_b, dat_e, lvl, 
    id_client, id_point, coalesce(demand,0), coalesce(demand04,0), coalesce(losts,0), coalesce(fact_losts,0) , losts_coef, 
    id_voltage, id_fider, mmgg  
    from bal_grp_tree_tbl where mmgg = pmmgg and id_bal = vid_res;
	    -- where code_eqp>0 and type_eqp <> 12 ;

   if not found then
      Raise EXCEPTION ''рПЖЙДЕТОЩК БОБМЙЪ ЪБ РЕТЙПД % ОЕ ЧЩРПМОСМУС!'',pmmgg; 
   end if;


   for r in 

   select s.id,1 as operation, s.dt_on as dt_operation, co.* from bal_switching_tbl as s join bal_connector_oper_tbl as co on (s.id = co.id_con)
   where s.dt_on >dtb and s.dt_on <dte 
  union
   select s.id,0 as operation, s.dt_off as dt_operation, co.* from bal_switching_tbl as s join bal_connector_oper_tbl as co on (s.id = co.id_con)
   where dt_off >dtb and dt_off <dte 
  union 
   select s2.id,1 as operation, dtb, co2.* from bal_switching_tbl as s2 join bal_connector_oper_tbl as co2 on (s2.id = co2.id_con)
   where (s2.dt_off is null or s2.dt_off > dtb ) and s2.dt_on <= dtb 
   order by dt_operation,id_st,operation
   loop

    Raise Notice ''date  %'',r.dt_operation;
    Raise Notice ''fider  %'',r.id_fider;
    Raise Notice ''ps  %'',r.id_st;
    Raise Notice ''operation  %'',r.operation;

     if r.operation =1 then --включение

       select into tf * from bal_grp_tree_conn_tmp where code_eqp=r.id_fider and dat_b <=r.dt_operation and dat_e > r.dt_operation;

       if not found then
          select into vps_name name_eqp from eqm_equipment_tbl where id = r.id_fider;
          Raise EXCEPTION ''пЫЙВЛБ РТЙ РЕТЕЛМАЮЕОЙЙ % .жЙДЕТ %(%) ОЕ ОБКДЕО Ч УИЕНЕ!'',r.dt_operation,vps_name,r.id_fider; 
       end if;

       select into ts * from bal_grp_tree_conn_tmp where code_eqp=r.id_st and dat_b <=r.dt_operation and dat_e > r.dt_operation;

       if not found then
          select into vps_name name_eqp from eqm_equipment_tbl where id = r.id_st;
          Raise EXCEPTION ''пЫЙВЛБ РТЙ РЕТЕЛМАЮЕОЙЙ % .фр %(%) ОЕ ОБКДЕОБ Ч УИЕНЕ!'',r.dt_operation,vps_name,r.id_st; 
       end if;

       select into tf_old * from bal_grp_tree_conn_tmp where code_eqp= ts.id_p_eqp and dat_b <=r.dt_operation and dat_e > r.dt_operation;

     else
       -- отключение
       -- в момент отключения КТП не на своем месте, надо вернуть ее в нормальную схему
       select into tf_old * from bal_grp_tree_conn_tmp where code_eqp=r.id_fider and dat_b <=r.dt_operation and dat_e > r.dt_operation;
       select into ts * from bal_grp_tree_conn_tmp where code_eqp=r.id_st and dat_b <=r.dt_operation and dat_e > r.dt_operation;

       if not found then
          select into vps_name name_eqp from eqm_equipment_tbl where id = r.id_st;
          Raise EXCEPTION ''пЫЙВЛБ РТЙ РЕТЕЛМАЮЕОЙЙ % .фр %(%) ОЕ ОБКДЕОБ Ч УИЕНЕ!'',r.dt_operation,vps_name,r.id_st; 
       end if;

       select into tf * from bal_grp_tree_conn_tmp where code_eqp in (select id_p_eqp from bal_grp_tree_tbl where code_eqp = r.id_st and mmgg = pmmgg limit 1) 
            and dat_b <=r.dt_operation and dat_e > r.dt_operation;

     end if;


     -- фидер, куда подключаем
     if (tf.dat_b<r.dt_operation) then

--    Raise Notice ''tf.dat_b %'',tf.dat_b;
--    Raise Notice ''tf.dat_e %'',tf.dat_e;
--
--    Raise Notice ''ts.dat_b %'',ts.dat_b;
--    Raise Notice ''ts.dat_e %'',ts.dat_e;

--       update bal_grp_tree_conn_tmp set dat_e = r.dt_operation-''1 minutes''::interval,
       update bal_grp_tree_conn_tmp set dat_e = r.dt_operation,
       demand = tf.demand-tf.demand*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp),
       demand04 = tf.demand04-tf.demand04*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp),
       fact_losts = tf.fact_losts-tf.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp), 
       losts = tf.losts-tf.losts*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp) 
      where id = tf.id;

     end if;

     delete from bal_grp_tree_conn_tmp where code_eqp = tf.code_eqp and dat_b = r.dt_operation;

     insert into bal_grp_tree_conn_tmp(id_tree ,code_eqp ,name,id_p_eqp,type_eqp,dat_b,dat_e,lvl,id_client,id_point ,
           demand,demand04,losts,fact_losts,losts_coef,id_voltage,mmgg) 
     values(tf.id_tree ,tf.code_eqp ,tf.name,tf.id_p_eqp,tf.type_eqp,r.dt_operation,tf.dat_e,tf.lvl,tf.id_client,tf.id_point ,
           tf.demand*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp)+
           ts.demand*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           tf.demand04*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp)+
	     ts.demand04*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
--           tf.losts,
           tf.losts*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp)+
           ts.losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           tf.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, tf.dat_e::timestamp)::numeric/ cal_minutes_fun(tf.dat_b::timestamp, tf.dat_e::timestamp)+
           ts.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           tf.losts_coef,tf.id_voltage,tf.mmgg);

     -- фидер, откуда отключаем
     if (tf_old.dat_b<r.dt_operation) then
--       update bal_grp_tree_conn_tmp set dat_e = r.dt_operation-''1 minutes''::interval,
       update bal_grp_tree_conn_tmp set dat_e = r.dt_operation,
       demand = tf_old.demand-tf_old.demand*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp),
       demand04 = tf_old.demand04-tf_old.demand04*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp),
       fact_losts = tf_old.fact_losts-tf_old.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp),
       losts = tf_old.losts-tf_old.losts*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp)
       where id = tf_old.id;
     end if;

     delete from bal_grp_tree_conn_tmp where code_eqp = tf_old.code_eqp and dat_b = r.dt_operation;

     insert into bal_grp_tree_conn_tmp(id_tree ,code_eqp ,name,id_p_eqp,type_eqp,dat_b,dat_e,lvl,id_client,id_point ,
           demand,demand04,losts,fact_losts,losts_coef,id_voltage,mmgg) 
     values(tf_old.id_tree ,tf_old.code_eqp ,tf_old.name,tf_old.id_p_eqp,tf_old.type_eqp,r.dt_operation,tf_old.dat_e,tf_old.lvl,tf_old.id_client,tf_old.id_point ,
           tf_old.demand*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp)-
           ts.demand*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           tf_old.demand04*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp)-
	     ts.demand04*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
--           tf.losts,
           tf_old.losts*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp)-
           ts.losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           tf_old.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, tf_old.dat_e::timestamp)::numeric/ cal_minutes_fun(tf_old.dat_b::timestamp, tf_old.dat_e::timestamp)-
           ts.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           tf_old.losts_coef,tf_old.id_voltage,tf_old.mmgg);


     -- КТП
     if (ts.dat_b<r.dt_operation) then
--       update bal_grp_tree_conn_tmp set dat_e = r.dt_operation-''1 minutes''::interval,  
       update bal_grp_tree_conn_tmp set dat_e = r.dt_operation,  
       demand = ts.demand-ts.demand*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
       demand04 = ts.demand04-ts.demand04*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
       losts = ts.losts-ts.losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
       fact_losts = ts.fact_losts-ts.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp)
       where id = ts.id;
     end if;

     delete from bal_grp_tree_conn_tmp where code_eqp = ts.code_eqp and dat_b = r.dt_operation;

--    Raise Notice ''ts.dat_b %'',ts.dat_b;
--    Raise Notice ''ts.dat_e %'',ts.dat_e;

--    Raise Notice ''cal_minutes_fun(r.dt_operation, ts.dat_e) %'',cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp);
--    Raise Notice ''cal_minutes_fun(ts.dat_b, ts.dat_e) %'',cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp);

    Raise Notice ''ts.demand %'',ts.demand;

     insert into bal_grp_tree_conn_tmp(id_tree ,code_eqp ,name,id_p_eqp,type_eqp,dat_b,dat_e,lvl,id_client,id_point ,
           demand,demand04,losts,fact_losts,losts_coef,id_voltage,mmgg,is_recon,id_switching,id_fider) 
     values(tf.id_tree ,ts.code_eqp ,ts.name,tf.code_eqp,ts.type_eqp,r.dt_operation,ts.dat_e,tf.lvl+1,ts.id_client,ts.id_point ,
           ts.demand*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           ts.demand04*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           ts.losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           ts.fact_losts*cal_minutes_fun( r.dt_operation::timestamp, ts.dat_e::timestamp)::numeric/ cal_minutes_fun(ts.dat_b::timestamp, ts.dat_e::timestamp),
           ts.losts_coef,ts.id_voltage,ts.mmgg, r.operation,r.id,tf.code_eqp);


     for child in 
       select * from bal_grp_tree_conn_tmp where id_p_eqp = ts.code_eqp
     loop

       Raise Notice '' update  %'',child.code_eqp;

       v:=bal_gorup_tree_divide_fun(child.code_eqp,r.dt_operation::timestamp,tf.lvl+2,tf.code_eqp);

     end loop;


   end loop;


--   update bal_grp_tree_conn_tmp set losts =  fact_losts+ ((demand04::numeric)*(demand04::numeric)*losts_coef/1000)::int
--   where type_eqp = 15;

   delete from bal_grp_tree_conn_tbl where mmgg = pmmgg and id_bal = vid_res;

   -- все кроме фидеров как есть
   insert into bal_grp_tree_conn_tbl select * from bal_grp_tree_conn_tmp where type_eqp <> 15 or id_voltage not in (3,31,32) ;
   --фидера надо обратно сгруппировать
   insert into bal_grp_tree_conn_tbl 
   select id_tree ,code_eqp ,name,id_p_eqp,type_eqp,min(dat_b),max(dat_e),lvl,id_client,id_point ,
           sum(demand),sum(demand04),sum(losts),sum(fact_losts),losts_coef,id_voltage,pmmgg
   from bal_grp_tree_conn_tmp where type_eqp = 15 and id_voltage in (3,31,32) 
   group by 
   id_tree ,code_eqp ,name,id_p_eqp,type_eqp,lvl,id_client,id_point,losts_coef,id_voltage;


 return true;
end;
' Language 'plpgsql';

--------------------------------------------------------------------------------------------------


  CREATE or replace FUNCTION bal_check_sw_fun (date,date)
  RETURNS int
  AS                                                                                              
  '
declare
  pdt_b Alias for $1;
  pdt_e Alias for $2;

  vdt_b date;
  vdt_e date;

  r record;
  rr record;
  vi int;
  vr int;

  begin
  vr:=0;

  vdt_b:=coalesce(pdt_b,(select min(dt_on) from bal_switching_tbl));
  vdt_e:=coalesce(pdt_e,(select max(dt_off) from bal_switching_tbl));
  delete from bal_switch_errors_tmp;

 for r in select *,tinterval((dt_on+''1 minute''::interval)::abstime,dt_off::abstime) as interval
  from bal_switching_tbl as s 
  join bal_connector_oper_tbl as op on (op.id_con = s.id)
  where tintervalov(tinterval(dt_on::abstime,dt_off::abstime),tinterval((vdt_b::timestamp)::abstime,(vdt_e::timestamp)::abstime))
loop
 
  for rr in select *
   from bal_switching_tbl as s 
   join bal_connector_oper_tbl as op on (op.id_con = s.id)
   where tintervalov(tinterval((dt_on+''1 minute''::interval)::abstime,dt_off::abstime),r.interval)
   and tintervalov(tinterval(dt_on::abstime,dt_off::abstime),tinterval((vdt_b::timestamp)::abstime,(vdt_e::timestamp)::abstime))
   and s.id <> r.id and r.id_st = op.id_st
   loop
	raise notice '' r.id- %  r.id_fider %  r.id_st %  r.dt_on %  r.dt_off %'', r.id,r.id_fider,r.id_st,r.dt_on,r.dt_off ;
	raise notice ''rr.id- % rr.id_fider % rr.id_st % rr.dt_on % rr.dt_off %'',rr.id,rr.id_fider,rr.id_st,rr.dt_on,rr.dt_off ;

	select into vi id_sw from bal_switch_errors_tmp where id_sw = r.id and id_fider = r.id_fider and id_st = r.id_st;
        if not found then 
	   insert into bal_switch_errors_tmp(id_sw,id_fider,id_st,dt_on,dt_off) values (r.id,r.id_fider,r.id_st,r.dt_on,r.dt_off);
        end if;

	select into vi id_sw from bal_switch_errors_tmp where id_sw = rr.id and id_fider = rr.id_fider and id_st = rr.id_st;
        if not found then 
          insert into bal_switch_errors_tmp(id_sw,id_fider,id_st,dt_on,dt_off) values (rr.id,rr.id_fider,rr.id_st,rr.dt_on,rr.dt_off);
        end if;
        vr:=1;
   end loop;

end loop;

  RETURN vr;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
