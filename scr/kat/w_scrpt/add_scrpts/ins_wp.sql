insert into warm_period(id_client,dat_b,dat_e,mmgg) 
select int4(value_ident) as id_client,'2004-10-15','2005-04-15','2004-10-01' 
 from syi_sysvars_tbl where ident='id_res';
