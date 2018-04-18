  CREATE or replace FUNCTION bal_connect_init_fun ()
  RETURNS int                                                                                     
  AS                                                                                              
  '
   declare
    v int;
   begin       

   select into v id from bal_grp_tree_conn_tbl limit 1;

   if not found then 

     insert into bal_grp_tree_conn_tbl 
     select id_tree, code_eqp, name, id_p_eqp, type_eqp, dat_b, dat_e, lvl, 
     id_client, id_point, coalesce(demand,0), coalesce(demand04,0), coalesce(losts,0), coalesce(fact_losts,0) , losts_coef, 
     id_voltage, mmgg from bal_grp_tree_tbl;

   end if;
         
   RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

  select bal_connect_init_fun();