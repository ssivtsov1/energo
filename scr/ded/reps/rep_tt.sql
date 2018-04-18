/*
  create table rep_tt_tmp (
  id_client int,
  id_point int,
  p_date date, 
  id_tt1 int,
  id_tt2 int,
  type_tt1 int,
  type_tt2 int,
  name varchar(25),
  demand_val numeric(12,2) );

*/

  

  CREATE or replace FUNCTION rep_tt_fun(date)
  RETURNS int
  AS                                                                                              
  '
  declare
   pmmgg Alias for $1;

  begin

   delete from rep_tt_tmp;


   insert into rep_tt_tmp (id_client,id_point,p_date,demand_val)
   select b.id_client, bs.id_point, max(bs.dt_end) ,sum(bs.demand_val) from acm_bill_tbl as b
   join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc)
   where b.id_pref = 10 and b.mmgg = pmmgg
   group by b.id_client, bs.id_point;


   update rep_tt_tmp set id_tt1 = ci.code_eqp, type_tt1 = ci.id_type_eqp
   from 
     eqm_compensator_i_h as ci 
     join eqm_eqp_tree_h as pttr on (ci.code_eqp = pttr.code_eqp)
     where 
      pttr.dt_b = (select max(dt_b)  from eqm_eqp_tree_h  where code_eqp = pttr.code_eqp and dt_b <= rep_tt_tmp.p_date and coalesce(dt_e,rep_tt_tmp.p_date) >= rep_tt_tmp.p_date)
      and ci.dt_b = (select max(dt_b)  from eqm_compensator_i_h  where code_eqp = ci.code_eqp and dt_b <= rep_tt_tmp.p_date and coalesce(dt_e,rep_tt_tmp.p_date) >= rep_tt_tmp.p_date)
      and rep_tt_tmp.id_point = pttr.code_eqp_e;

   update rep_tt_tmp set id_tt2 = ci.code_eqp, type_tt2 = ci.id_type_eqp
   from 
     eqm_compensator_i_h as ci 
     join eqm_eqp_tree_h as pttr on (ci.code_eqp = pttr.code_eqp)
     where 
      pttr.dt_b = (select max(dt_b)  from eqm_eqp_tree_h  where code_eqp = pttr.code_eqp and dt_b <= rep_tt_tmp.p_date and coalesce(dt_e,rep_tt_tmp.p_date) >= rep_tt_tmp.p_date)
      and ci.dt_b = (select max(dt_b)  from eqm_compensator_i_h  where code_eqp = ci.code_eqp and dt_b <= rep_tt_tmp.p_date and coalesce(dt_e,rep_tt_tmp.p_date) >= rep_tt_tmp.p_date)
      and rep_tt_tmp.id_tt1 = pttr.code_eqp_e and rep_tt_tmp.id_tt1 is not null;


   delete from rep_tt_tmp where id_tt2 is null and id_tt1 is null;


   update rep_tt_tmp set name = ett.name_eqp
   from 
     eqm_equipment_h as ett 
     where 
      ett.dt_b = (select max(dt_b)  from eqm_equipment_h  where id = ett.id and dt_b <= rep_tt_tmp.p_date and coalesce(dt_e,rep_tt_tmp.p_date) >= rep_tt_tmp.p_date)
      and rep_tt_tmp.id_point = ett.id;



  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
