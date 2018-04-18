--drop function bal_start_fun(int,date);
create or replace function bal_start_fun(int,date) Returns int As'
Declare
ptree Alias for $1;
pmmgg Alias for $2;
vi int;
v boolean;
vreq_check int;
id_res int;
begin

--select into code code_eqp from bal_grp_tree_tbl where  mmgg = pmmgg limit 1;
--if found 

 delete from bal_eqp_tbl where mmgg=pmmgg and id_bal = getsysvar(''id_bal'');
 delete from bal_acc_tbl where mmgg=pmmgg and id_bal = getsysvar(''id_bal'');
 delete from bal_client_errors_tbl where mmgg=pmmgg ;
 delete from bal_demand_tbl where mmgg=pmmgg and id_bal = getsysvar(''id_bal'');
 delete from bal_meter_demand_tbl where mmgg=pmmgg and id_bal = getsysvar(''id_bal'');
 delete from bal_grp_tree_tbl where mmgg=pmmgg and id_bal = getsysvar(''id_bal'');
 delete from bal_losts04_tbl where mmgg=pmmgg and id_bal = getsysvar(''id_bal'');

 delete from bal_eqp_tmp;
 delete from bal_acc_tmp;
 delete from bal_demand_tmp;
 delete from bal_meter_demand_tmp;
 delete from bal_grp_tree_tmp;
 delete from bal_losts04_tmp;

 --select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_bal'';
 select into id_res getsysvar(''id_bal'');

 select into vreq_check to_number(value_ident,''9'') from syi_sysvars_tbl where ident=''fidercontrol'';
 -- надо ли выполнять проверку 
 if vreq_check = 1 then
   
  vi:=bal_fider_check_fun(ptree);

  if (vi=-1) then 
   return -1;
  end if;
 end if;

 vi:=bal_eqp_fun(ptree,pmmgg);
  --return 0;
  --if (vi=0) then 
  -- return -1;
  --end if;

 vi:=bal_demand_fun(ptree,pmmgg);

 v:=sel_bal_par_start(pmmgg,pmmgg+''1 month''::interval);

 v:=bal_gorup_tree_start_fun(pmmgg);

 -- специально для черниговского РЕС делаем записи в таблице поступления
 -- для фидеров, которые начинались с абонентских ТУ
 insert into bal_demand_tmp(id_point,ktr_demand,mmgg) 
 select id_point, demand_full,pmmgg 
 from bal_acc_tmp as a 
 join bal_grp_tree_tmp as g on (g.id_point = a.code_eqp)
 where g.type_eqp = 15 and demand_full is not null;


 insert into bal_eqp_tbl select * from bal_eqp_tmp;
--raise notice ''1'';
 --return 0;
 insert into bal_acc_tbl 
 select code_eqp, dat_b, dat_e, demand, demand04, lst, losts, mmgg, fiz_count, 
            fiz_power, losts_ti, losts_tu, losts_meter, losts_linea, losts_linec, 
            sumlosts_ti, sumlosts_tu, sumlosts_meter, sumlosts_linea, sumlosts_linec, 
            fiz_demand, nolost_demand, losts_kz, losts_xx, sumlosts_kz, sumlosts_xx, 
            losts_air, losts_cable, sumlosts_air, sumlosts_cable, id_un, id_spr_type
 from bal_acc_tmp;


--raise notice ''2'';
 insert into bal_demand_tbl select * from bal_demand_tmp;
--raise notice ''3'';
 insert into bal_meter_demand_tbl select * from bal_meter_demand_tmp;
--raise notice ''4'';
 insert into bal_grp_tree_tbl select * from bal_grp_tree_tmp;
 insert into bal_losts04_tbl select * from bal_losts04_tmp;
--raise notice ''all'';

 perform bal_grp_tree_connect_fun(id_res,pmmgg);

 if (select count(*) from bal_client_errors_tbl where mmgg=pmmgg)>0 then
   return 1;
 else
   return 0;
 end if;

return true;
end;
' Language 'plpgsql';


--------------------------------------------------------------------------------------------
create or replace function bal_setabon_fun(int,date) Returns int As'
Declare
pid Alias for $1;
pmmgg Alias for $2;

id_res int;
begin

  update syi_sysvars_tmp set value_ident= text(pid) where ident = ''id_bal'';

  delete from bal_eqp_tmp;
  delete from bal_acc_tmp;
  delete from bal_demand_tmp;
  delete from bal_meter_demand_tmp;
  delete from bal_grp_tree_tmp;
  delete from bal_losts04_tmp;
  delete from bal_grp_tree_conn_tmp;

  insert into bal_eqp_tmp select id_tree, code_eqp, id_p_eqp, type_eqp, id_type_eqp, dat_b, dat_e, 
       lvl, id_client, id_rclient, loss_power, sn_len, tgfi, tt, pxx_r0, pkz_x0, ixx, ukz_un, mmgg from bal_eqp_tbl where mmgg=pmmgg and id_bal = pid;

  insert into bal_acc_tmp select code_eqp, dat_b, dat_e, demand, demand04, lst, losts, mmgg, fiz_count, 
       fiz_power, losts_ti, losts_tu, losts_meter, losts_linea, losts_linec, 
       sumlosts_ti, sumlosts_tu, sumlosts_meter, sumlosts_linea, sumlosts_linec, 
       fiz_demand, nolost_demand, losts_kz, losts_xx, sumlosts_kz, sumlosts_xx, 
       losts_air, losts_cable, sumlosts_air, sumlosts_cable, id_un, 
       id_spr_type from bal_acc_tbl where mmgg=pmmgg and id_bal = pid;

  insert into bal_demand_tmp select id_point, ktr_demand, mmgg from bal_demand_tbl where mmgg=pmmgg and id_bal = pid;

  insert into bal_meter_demand_tmp select id_point, id_meter, num_eqp, k_tr, id_type_eqp, dat_b, dat_e, 
       b_val, e_val, met_demand, ktr_demand, mmgg from bal_meter_demand_tbl where mmgg=pmmgg and id_bal = pid;

  insert into bal_losts04_tmp select code_eqp, l04_count, l04_length, l04f1_length, l04f3_length, 
       fgcp, fiz_demand, nolost_demand, losts04, mmgg from bal_losts04_tbl where mmgg=pmmgg and id_bal = pid;

  insert into bal_grp_tree_tmp select id_tree, code_eqp, name, id_p_eqp, type_eqp, dat_b, dat_e, lvl, 
       id_client, id_point, demand, demand04, losts, fact_losts, losts_coef, 
       id_voltage, mmgg, lost04_metod, id_fider from bal_grp_tree_tbl where mmgg=pmmgg and id_bal = pid;


  insert into bal_grp_tree_conn_tmp select id_tree, code_eqp, name, id_p_eqp, type_eqp, dat_b, dat_e, lvl, 
       id_client, id_point, demand, demand04, losts, fact_losts, losts_coef, 
       id_voltage, mmgg, is_recon, id_switching, id, id_fider from bal_grp_tree_conn_tbl where mmgg=pmmgg and id_bal = pid;

return 0;
end;
' Language 'plpgsql';