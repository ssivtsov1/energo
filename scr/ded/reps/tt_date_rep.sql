create table eqt_equipment_dt
( id int,
  dt date,
  primary key (id, dt)
);

create table eqt_eqp_tree_dt
( code_eqp int,
  dt date,
  primary key (code_eqp, dt)
);

create table eqt_compensator_i_dt
( code_eqp int,
  dt date,
  primary key (code_eqp, dt)
);

create table eqt_meter_dt
( code_eqp int,
  dt date,
  primary key (code_eqp, dt)
);

create table eqt_point_dt
( code_eqp int,
  dt date,
  primary key (code_eqp, dt)
);


CREATE TABLE eqt_tt_list_tbl
(
  id integer,
  short_name character varying(40),
  code numeric(9),
  code_eqp integer NOT NULL,
  id_type_eqp integer,
  name_eqp character varying(50),
  num_eqp character varying(25),
  tt_type character varying(35),
  koef_i integer,
  date_check_i date,
  num_sti character varying(25),
  disabled integer,
  id_section int,
  section character varying(50),
  "owner" integer,
  next_check_i date,
  dt_install_i date,
  date_rep date,
  id_res integer,
  CONSTRAINT eqt_tt_list_code_eqp PRIMARY KEY (code_eqp,date_rep)
) ;


CREATE TABLE eqt_tt_late_tbl
(
  id_res integer,
  cnt_all integer,
  cnt_abon integer,
  cnt_res integer,
  cnt_late_all integer,
  cnt_late_abon integer,
  cnt_late_res integer,
  cnt_budj integer,
  cnt_late_budj integer,
  cnt_prom integer,
  cnt_late_prom integer,
  cnt_sg integer,
  cnt_late_sg integer,
  cnt_gkh integer,
  cnt_late_gkh integer,
  cnt_other integer,
  cnt_late_other integer
) ;

CREATE TABLE eqt_tt_20_tbl
(
  id_res integer,
  cnt_all integer,
  cnt_abon integer,
  cnt_res integer,
  cnt_20_all integer,
  cnt_20_abon integer,
  cnt_20_res integer,
  cnt_budj integer,
  cnt_20_budj integer,
  cnt_prom integer,
  cnt_20_prom integer,
  cnt_sg integer,
  cnt_20_sg integer,
  cnt_gkh integer,
  cnt_20_gkh integer,
  cnt_other integer,
  cnt_20_other integer
) ;


CREATE TABLE eqt_tt_dynamic_tbl
(
  id_res integer,
  cnt_all_now integer,
  cnt_late_now integer,
  cnt_20_now integer,
  cnt_all_q integer,
  cnt_late_q integer,
  cnt_20_q integer,
  cnt_all_y integer,
  cnt_late_y integer,
  cnt_20_y integer
);


CREATE OR REPLACE FUNCTION rep_tt_list_date_fun(date)
  RETURNS integer AS
$BODY$
  declare
   pdt Alias for $1;
  begin

 set  enable_nestloop  = false ;

  delete from eqt_equipment_dt;
  insert into eqt_equipment_dt (id, dt)
  select id, max(dt_b) as dt from eqm_equipment_h  where dt_b <= pdt and  (dt_e is null or dt_e > pdt ) group by id order by id;

  delete from eqt_eqp_tree_dt;
  insert into eqt_eqp_tree_dt (code_eqp, dt)
  select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and  (dt_e is null or dt_e > pdt )  group by code_eqp order by code_eqp;

  delete from eqt_compensator_i_dt;
  insert into eqt_compensator_i_dt (code_eqp, dt)
  select code_eqp, max(dt_b) as dt from eqm_compensator_i_h  where dt_b <= pdt and  (dt_e is null or dt_e > pdt )  group by code_eqp order by code_eqp;

  delete from eqt_meter_dt;
  insert into eqt_meter_dt (code_eqp, dt)
  select code_eqp, max(dt_b) as dt from eqm_meter_h  where dt_b <= pdt and  (dt_e is null or dt_e > pdt )  group by code_eqp order by code_eqp;

  delete from eqt_point_dt;
  insert into eqt_point_dt (code_eqp, dt)
  select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <= pdt and  (dt_e is null or dt_e > pdt )  group by code_eqp order by code_eqp;

  delete from eqt_tt_list_tbl where date_rep = pdt;

  reindex TABLE eqt_equipment_dt;
  reindex TABLE eqt_eqp_tree_dt;
  reindex TABLE eqt_compensator_i_dt;
  reindex TABLE eqt_meter_dt;
  reindex TABLE eqt_point_dt;

  INSERT INTO eqt_tt_list_tbl( id, short_name, code, code_eqp, id_type_eqp, name_eqp, num_eqp, 
            tt_type, koef_i, date_check_i, num_sti, disabled, id_section, section, owner, next_check_i, dt_install_i, date_rep, id_res)
  select distinct c.id, c.short_name, c.code,m.code_eqp, m.id_type_eqp, 
  eq.name_eqp, eq.num_eqp,   sti.tt_type, sti.koef_i, sti.date_check as date_check_i, 
    sti.num_eqp as num_sti,   
    coalesce(pp.disabled,0) as disabled,
    cla.id as id_section, cla.name as section,   coalesce(sti.is_owner,0) as owner,
    (sti.date_check+'4 year'::interval)::date as next_check_i, sti.dt_install::date as dt_install_i,
     pdt, getsysvar('kod_res')::int as res
    from eqm_tree_h as tr
     join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <= pdt and  (dt_e is null or dt_e > pdt )  group by id order by id) as tr2 on (tr.id = tr2.id and tr2.dt = tr.dt_b)
    join eqm_eqp_tree_h as ttr on (tr.id = ttr.id_tree)
     join eqt_eqp_tree_dt as ttr2 on (ttr.code_eqp = ttr2.code_eqp and ttr2.dt = ttr.dt_b)
    join eqm_meter_h as m on (ttr.code_eqp = m.code_eqp)
     join eqt_meter_dt as m2 on (m.code_eqp = m2.code_eqp and m2.dt = m.dt_b)

    join eqm_equipment_h as eq on (ttr.code_eqp = eq.id)  
     join eqt_equipment_dt as eq2 on (eq.id = eq2.id and eq2.dt = eq.dt_b)

    join eqm_meter_point_h as mp on (mp.id_meter = ttr.code_eqp and mp.dt_b <= pdt and  (mp.dt_e is null or mp.dt_e > pdt ))  

    join eqm_point_h as pp on (pp.code_eqp = mp.id_point )  
     join eqt_point_dt as pp2 on (pp.code_eqp = pp2.code_eqp and pp2.dt = pp.dt_b)
   join  
    (  select CASE WHEN eq2.type_eqp = 1 THEN eq2.id WHEN eq3.type_eqp = 1 THEN eq3.id END as id_meter, c.date_check, ic.amperage_nom, eq.dt_install,  
    ic.conversion , ic.type as tt_type,ic.accuracy, 
    CASE WHEN coalesce(ic.amperage2_nom,0)=0 THEN 0 ELSE ic.amperage_nom/ic.amperage2_nom END as koef_i, eq.num_eqp, eq.is_owner  
    from  
     eqm_compensator_i_h as c  
      join eqt_compensator_i_dt as c1 on (c.code_eqp = c1.code_eqp and c1.dt = c.dt_b)
     join eqm_equipment_h as eq on (eq.id =c.code_eqp )  
      join eqt_equipment_dt as eq1 on (eq.id = eq1.id and eq1.dt = eq.dt_b)
     join eqi_compensator_i_tbl as ic on (ic.id = c.id_type_eqp)  
     join eqm_eqp_tree_h as tt on (tt.code_eqp_e=c.code_eqp )    
      join eqt_eqp_tree_dt as tt1 on (tt.code_eqp = tt1.code_eqp and tt1.dt = tt.dt_b)
     join eqm_equipment_h as eq2 on (eq2.id =tt.code_eqp )  
      join eqt_equipment_dt as eq22 on (eq2.id = eq22.id and eq22.dt = eq2.dt_b)

     left join
     ( select ttt.code_eqp,ttt.code_eqp_e from eqm_eqp_tree_h as ttt
       join eqt_eqp_tree_dt as ttt2 on (ttt.code_eqp = ttt2.code_eqp and ttt2.dt = ttt.dt_b)
       order by ttt.code_eqp_e
     )as tt2 on (tt2.code_eqp_e=tt.code_eqp )  
     left join 
     ( select ee.id, ee.type_eqp from eqm_equipment_h as ee
          join eqt_equipment_dt as ee2 on (ee.id = ee2.id and ee2.dt = ee.dt_b)
          order by ee.id
     )as eq3 on (eq3.id =tt2.code_eqp )  
     where ic.conversion = 1 order by id_meter  
   ) as sti on (sti.id_meter = ttr.code_eqp)  
 
    left join 
    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h  where dt_b <= pdt and coalesce(dt_e,pdt) >= pdt group by code_eqp order by code_eqp ) as u2
       on (u1.code_eqp = u2.code_eqp and u2.dt = u1.dt_b) 
       order by u1.code_eqp
    ) as use on (use.code_eqp = ttr.code_eqp)

    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client))  
    left join clm_statecl_tbl as sc on (c.id = sc.id_client)  
    left join cla_param_tbl as cla on (sc.id_section = cla.id)  
    where c.book=-1 and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)  
    order by c.code,eq.num_eqp;

   set  enable_nestloop  = true ;
    return 1;

  end;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION rep_tt_late_fun(date)
  RETURNS integer AS
$BODY$
  declare
   pdt Alias for $1;
  begin

    delete from eqt_tt_late_tbl;

    perform rep_tt_list_date_fun(pdt);

    INSERT INTO eqt_tt_late_tbl(
            id_res, cnt_all, cnt_abon, cnt_res, cnt_late_all, cnt_late_abon, 
            cnt_late_res, cnt_budj, cnt_late_budj, cnt_prom, cnt_late_prom, 
            cnt_sg, cnt_late_sg, cnt_gkh, cnt_late_gkh, cnt_other, cnt_late_other)
    select id_res, count(distinct code_eqp)::int as cnt_all,
    count(distinct CASE WHEN owner = 1 THEN code_eqp END)::int as cnt_abon,
    count(distinct CASE WHEN owner = 0 THEN code_eqp END)::int as cnt_res,
    count(distinct case when (next_check_i is not null and next_check_i <= pdt) then code_eqp  end )::int as cnt_late_all, 
    count(distinct case when (next_check_i is not null and next_check_i <= pdt) and owner = 1 then code_eqp end )::int as cnt_late_abon, 
    count(distinct case when (next_check_i is not null and next_check_i <= pdt) and owner = 0 then code_eqp  end )::int as cnt_late_res ,
    count(distinct CASE WHEN id_section in( 211,213,214,215) THEN code_eqp END)::int as cnt_budj,
    count(distinct CASE WHEN id_section in( 211,213,214,215) and (next_check_i is not null and next_check_i <= pdt) THEN code_eqp END)::int as cnt_late_budj,
    count(distinct CASE WHEN id_section =201 THEN code_eqp END)::int as cnt_prom,
    count(distinct CASE WHEN id_section =201 and (next_check_i is not null and next_check_i <= pdt) THEN code_eqp END)::int as cnt_late_prom,
    count(distinct CASE WHEN id_section =202 THEN code_eqp END)::int as cnt_sg,
    count(distinct CASE WHEN id_section =202 and (next_check_i is not null and next_check_i <= pdt) THEN code_eqp END)::int as cnt_late_sg,
    count(distinct CASE WHEN id_section =203 THEN code_eqp END)::int as cnt_gkh,
    count(distinct CASE WHEN id_section =203 and (next_check_i is not null and next_check_i <= pdt) THEN code_eqp END)::int as cnt_late_gkh,
    count(distinct CASE WHEN id_section =204 THEN code_eqp END)::int as cnt_other,
    count(distinct CASE WHEN id_section =204 and (next_check_i is not null and next_check_i <= pdt) THEN code_eqp END)::int as cnt_late_other
    from eqt_tt_list_tbl where date_rep = pdt and disabled = 0
     group by id_res;

    return 1;

  end;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION rep_tt_20_fun(date)
  RETURNS integer AS
$BODY$
  declare
   pdt Alias for $1;
  begin

    delete from eqt_tt_20_tbl;

    perform rep_tt_list_date_fun(pdt);

    INSERT INTO eqt_tt_20_tbl(
            id_res, cnt_all, cnt_abon, cnt_res, cnt_20_all, cnt_20_abon, 
            cnt_20_res, cnt_budj, cnt_20_budj, cnt_prom, cnt_20_prom, cnt_sg, 
            cnt_20_sg, cnt_gkh, cnt_20_gkh, cnt_other, cnt_20_other)   
   select id_res, count(distinct code_eqp)::int as cnt_all,
   count(distinct CASE WHEN owner = 1 THEN code_eqp END)::int as cnt_abon,
   count(distinct CASE WHEN owner = 0 THEN code_eqp END)::int as cnt_res,
   count(distinct case when (koef_i<=20) then code_eqp  end )::int as cnt_20_all, 
   count(distinct case when (koef_i<=20) and owner = 1 then code_eqp end )::int as cnt_20_abon, 
   count(distinct case when (koef_i<=20) and owner = 0 then code_eqp  end )::int as cnt_20_res ,
   count(distinct CASE WHEN id_section in( 211,213,214,215) THEN code_eqp END)::int as cnt_budj,
   count(distinct CASE WHEN id_section in( 211,213,214,215) and (koef_i<=20) THEN code_eqp END)::int as cnt_20_budj,
   count(distinct CASE WHEN id_section =201 THEN code_eqp END)::int as cnt_prom,
   count(distinct CASE WHEN id_section =201 and (koef_i<=20) THEN code_eqp END)::int as cnt_20_prom,
   count(distinct CASE WHEN id_section =202 THEN code_eqp END)::int as cnt_sg,
   count(distinct CASE WHEN id_section =202 and (koef_i<=20) THEN code_eqp END)::int as cnt_20_sg,
   count(distinct CASE WHEN id_section =203 THEN code_eqp END)::int as cnt_gkh,
   count(distinct CASE WHEN id_section =203 and (koef_i<=20) THEN code_eqp END)::int as cnt_20_gkh,
   count(distinct CASE WHEN id_section =204 THEN code_eqp END)::int as cnt_other,
   count(distinct CASE WHEN id_section =204 and (koef_i<=20) THEN code_eqp END)::int as cnt_20_other
   from eqt_tt_list_tbl where date_rep = pdt and disabled = 0
  group by id_res;

    return 1;

  end;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;



CREATE OR REPLACE FUNCTION rep_tt_dynamic_fun(date)
  RETURNS integer AS
$BODY$
  declare
   pdt Alias for $1;
  begin

    delete from eqt_tt_dynamic_tbl;

    perform rep_tt_list_date_fun(pdt);
    perform rep_tt_list_date_fun(date_trunc('year',pdt::date)::date);
    perform rep_tt_list_date_fun(date_trunc('quarter',pdt::date)::date);

    INSERT INTO eqt_tt_dynamic_tbl( id_res, cnt_all_now, cnt_late_now, cnt_20_now, cnt_all_q, cnt_late_q, 
            cnt_20_q, cnt_all_y, cnt_late_y, cnt_20_y)
    select * from 
    (select id_res, count(distinct code_eqp)::int as cnt_all_now,
    count(distinct case when (next_check_i is not null and next_check_i <= pdt) then code_eqp  end )::int as cnt_late_now, 
    count(distinct case when (koef_i<=20) then code_eqp  end )::int as cnt_20_now 
    from eqt_tt_list_tbl where date_rep = pdt and disabled = 0
    group by id_res
    ) as snow
    join
    (select id_res, count(distinct code_eqp)::int as cnt_all_q,
     count(distinct case when (next_check_i is not null and next_check_i <= pdt) then code_eqp  end )::int as cnt_late_q, 
     count(distinct case when (koef_i<=20) then code_eqp  end )::int as cnt_20_q 
    from eqt_tt_list_tbl where date_rep = date_trunc('quarter',pdt::date)::date and disabled = 0
    group by id_res
    ) as sq using(id_res)
    join
    (select id_res, count(distinct code_eqp)::int as cnt_all_y,
    count(distinct case when (next_check_i is not null and next_check_i <= pdt) then code_eqp  end )::int as cnt_late_y, 
    count(distinct case when (koef_i<=20) then code_eqp  end )::int as cnt_20_y 
    from eqt_tt_list_tbl where date_rep = date_trunc('year',pdt::date)::date and disabled = 0
    group by id_res
   ) as sy using(id_res);

    return 1;

  end;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

/*
select rep_tt_list_date_fun('2015-10-15');

select rep_tt_late_fun('2015-10-15');
select * from eqt_tt_late_tbl;

select rep_tt_20_fun('2015-10-15');
select * from eqt_tt_20_tbl;

select rep_tt_dynamic_fun('2015-10-15');
select * from eqt_tt_dynamic_tbl
*/


-- select res.short_name from clm_client_tbl as res  where res.id = syi_resid_fun();