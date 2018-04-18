select DropTable('bal_client_errors_tbl');
create table bal_client_errors_tbl (
     id 	   serial,
     id_client     int,
     id_tree   	   int,
     id_border     int,
     id_parent_eqp int,	
     id_grp	   int,	
     mmgg          date,
     primary key(id)
);
