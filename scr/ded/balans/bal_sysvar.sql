insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) 
select 25,'id_bal','int',s.value_ident from syi_sysvars_tbl as s 
where s.ident = 'id_res';