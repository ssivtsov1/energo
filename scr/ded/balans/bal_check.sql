-- проверим фидера и ПС на целостность
-- Фидер/ПС должен иметь только одно начало и быть неразрывным
-- в таблицу выдается начало и его предок, в котором, в случае разрыва,
-- и заключается проблема (забыли поставить принадлежность)
  CREATE or replace FUNCTION bal_fider_check_fun(int)
  RETURNS int
  AS                                                                                              
  '
  declare
   ptree Alias for $1;

   vid_res int;
  begin

   delete from bal_fider_errors_tbl;

   select into vid_res getsysvar(''id_bal'');

   insert into bal_fider_errors_tbl (id_area,name_area,roots,code_eqp_root,
                                     name_eqp_root,id_p_eqp,name_p_eqp)
   select bedarea.code_eqp_inst,bedarea.name_eqp,bedarea.roots,eq3.id,eq3.name_eqp,
   eq2.id,eq2.name_eqp
   from
   (  
     select st.code_eqp_inst,eq.name_eqp ,count(bt.code_eqp) as roots
     from eqm_eqp_tree_tbl as bt
     join eqm_tree_tbl as t on (t.id = bt.id_tree)
     join eqm_compens_station_inst_tbl as st on (bt.code_eqp=st.code_eqp) -- оборудование принадлежит подстанции/фидеру
     join eqm_equipment_tbl as eq on (eq.id = st.code_eqp_inst) 
     join eqm_area_tbl as ar on (ar.code_eqp= st.code_eqp_inst)
     where  eq.type_eqp in (15,8) and (ar.id_client=vid_res)
     and ((bt.id_tree = ptree) or (ptree is NULL)) 
     and (t.id_client=vid_res)
     -- а его предок не принадлежит этой подстанции/фидеру
     and
     (
      (not exists (select code_eqp from eqm_compens_station_inst_tbl where code_eqp_inst=st.code_eqp_inst and code_eqp=bt.code_eqp_e))
       or (bt.code_eqp_e is null)
     )
    group by st.code_eqp_inst,eq.name_eqp
    having count(bt.code_eqp)>1
   ) as bedarea 
   left join eqm_compens_station_inst_tbl as st2 on (bedarea.code_eqp_inst=st2.code_eqp_inst)
   join eqm_eqp_tree_tbl as bt2 on (bt2.code_eqp=st2.code_eqp) 
   join eqm_equipment_tbl as eq2 on (bt2.code_eqp_e=eq2.id)
   join eqm_equipment_tbl as eq3 on (bt2.code_eqp=eq3.id)
   where ((bt2.id_tree = ptree) or (ptree is NULL)) 
   and 
   ( not exists (select code_eqp from eqm_compens_station_inst_tbl where code_eqp_inst=st2.code_eqp_inst and code_eqp=bt2.code_eqp_e))
   order by bedarea.name_eqp, bt2.lvl;

   if not found then
     RETURN 0;
   else 
     RETURN -1;
   end if;

  end;'                                                                                           
  LANGUAGE 'plpgsql';          
