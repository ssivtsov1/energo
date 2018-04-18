\i syi_table.dmp
\i table_sys.sql
\i table_del.sql
\i tablefields.sql
\i replicat_fun.sql
-- select scanfields(); -- is in tablefields.sql
/*update syi_field_tbl set flag_repl=true 
 where id_table in (select id from syi_table_tbl where name='syi_field_tbl');

update syi_field_tbl set flag_repl=true 
 where id_table in (select id from syi_table_tbl where name='syi_table_tbl');
*/