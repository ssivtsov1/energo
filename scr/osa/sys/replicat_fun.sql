insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(901,'flag_main','int',999999999); 



 drop FUNCTION sys_replicat_out_fun ();                                                                                                                                         
  CREATE FUNCTION sys_replicat_out_fun ()                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
  '
  declare
  tablerec record;
  fieldrec record;
  first int ;
  SQL text;
  SQLI text;
  SQLU text;
tabl text;
del text;
nul text;
path text;
begin  
 -- first table
  del=''@''; nul='''';  
  path=''/home/local/replicat/out/'';          
  for tablerec in select t.* from syi_table_tbl t   where t.flag_repl   order by ord,id loop
    raise notice ''table - %'',tablerec.name;
    SQL=''copy ''||tablerec.name||''('';
    first=1;
    for fieldrec in select f.* from syi_field_tbl f  
       where f.flag_repl and f.id_table=tablerec.id order by ord,name loop
       raise notice ''     field - %'',fieldrec.name;
        if first<>1 then 
          SQL=SQL||'','';
        end if;
        first=2;
        SQL=SQL||(fieldrec.name);
    end loop;
    tabl=path||''repl_''||tablerec.name||''.TXT'';
    SQL=SQL||'') to ''||quote_literal(tabl)||'' 
      with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
    raise notice ''SQL - %'',SQL;
    Execute SQL;
  end loop;


 RETURN true;
end;'                                                                                           
LANGUAGE 'plpgsql';          


drop FUNCTION sys_replicat_sys_in_fun ();                                                                                                                                         
  CREATE FUNCTION sys_replicat_sys_in_fun ()                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
  '
  declare
  tablerec record;
  fieldrec record;
  first int ;
  SQL text;
  SQLI text;
  SQLIS text;
  SQLU text;
  SQLC text;
  key_field text;
tabl text;
del text;
nul text;
path text;
 res bool;
begin  
 -- first table
  del=''@''; nul='''';  
  path=''/home/local/replicat/in/'';          
  
  del=''@''; nul='''';  
  path=''/home/local/replicat/in/'';          
   delete from  syi_table_tbl_tmp;
   delete from syi_field_tbl_tmp;
   copy syi_table_tbl_tmp(act,flag_ins,flag_repl,flag_upd,id,id_base,id_task,name,note,ord,tbl_owner) 
         from ''/home/local/replicat/in/repl_syi_table_tbl.TXT'' 
      with delimiter as ''@'' null as '''';
raise notice ''1 tabl '';
    copy syi_field_tbl_tmp(act,def,flag_repl,id,id_table,id_type,key,length,link_table,name,note,ord,uniq) 
     from ''/home/local/replicat/in/repl_syi_field_tbl.TXT'' 
         with delimiter as ''@'' null as '''';

raise notice ''2 tabl '';
delete from syi_field_tbl;
delete from syi_table_tbl;

-- doing first table
insert into syi_table_tbl select * 
  from syi_table_tbl_tmp;
/*(select distinct * from (select t.*   from syi_table_tbl_tmp t 
                       left join syi_table_tbl i on i.id=t.id 
        where i.id is null) as a) as a;
*/
/*
update syi_table_tbl set name=i.name,id_base =i.id_base,  note=i.note ,  
            tbl_owner=i.tbl_owner ,  id_task=i.id_task ,  act=i.act ,
  flag_repl=i.flag_repl,  ord =i.ord 
from syi_table_tbl_tmp i where syi_table_tbl.id=i.id;
*/


insert into syi_field_tbl select *
  from   syi_field_tbl_tmp;
/*(select distinct * from (select t.*   from syi_field_tbl_tmp t 
                       left join syi_field_tbl i on i.id=t.id 
        where i.id is null) as a) as a;
  */
/*
update syi_field_tbl set name=i.name,id_table =i.id_table,  id_type=i.id_type ,  
            length=i.length ,  key=i.key ,  link_table=i.link_table ,
  def=i.def,  note =i.note, uniq=i.uniq,  act =i.act, flag_repl =i.flag_repl 
from syi_field_tbl_tmp i where syi_field_tbl.name=i.name;
*/



  RETURN true;

end;'                                                                                           
LANGUAGE 'plpgsql';          



drop FUNCTION sys_replicat_in_fun ();                                                                                                                                         
CREATE FUNCTION sys_replicat_in_fun ()                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
  '
  declare
  tablerec record;
  fieldrec record;
  first int ;
  SQL text;
  SQLI text;
  SQLIW text;
  SQLIS text;
  SQLU text;
  SQLUW text;
  SQLC text;
  key_field text;
tabl text;
del text;
nul text;
path text;
 res bool;
begin  
 -- first table
del=''@''; nul='''';  
  path=''/home/local/replicat/in/'';          
  

  for tablerec in select t.* from syi_table_tbl t   
      where t.flag_repl and coalesce(ord,0)>0 order by ord,id loop
    raise notice ''table 2 - %'',tablerec.name;

    SQL=''copy ''||tablerec.name||''_tmp('';
raise notice ''SQL1 - %'',SQL;
    SQLI=''insert into ''||tablerec.name||'' ( '';
    SQLIS='''';
    SQLU=''update ''||tablerec.name||'' set '';
    SQLIW='' '';
    SQLUW='' '';
    SQLC=''select droptable(''||quote_literal(tablerec.name||''_tmp'')||'')'';
    Execute SQLC;
--    SQLC=''select * into  ''||tablerec.name||''_tmp from ''||tablerec.name||'' limit 0   '';
  SQLC=''create table   ''||tablerec.name||''_tmp as select * from ''||tablerec.name||'' limit 0   '';
    Execute SQLC;
    first=1;
    key_field=''id'';
    for fieldrec in select f.* from syi_field_tbl f  
       where f.flag_repl and f.id_table=tablerec.id order by ord,name loop
       raise notice ''     field - %'',fieldrec.name;
       if fieldrec.key then
        key_field=fieldrec.name;
         if length(SQLIW)>2 then 
             SQLIW=SQLIW||'' and '';
         end if;
         if length(SQLUW)>2 then 
             SQLUW=SQLUW||'' and '';
         end if;
        SQLIW=SQLIW||'' i.''||key_field||''=t.''||key_field;
        SQLUW=SQLUW||tablerec.name||''.''||key_field||''=i.''||key_field;

        raise notice '' key    field   -  %     !!!'',fieldrec.name;
       end if;
        if first<>1 then 
          SQL=SQL||'','';
        --  raise notice ''SQL 2 - %'',SQL;
          SQLU=SQLU||'','';
          SQLIS=SQLIS||'','';
        end if;
        first=2;
        SQL=SQL||(fieldrec.name);
        --raise notice ''SQL 3 - %'',SQL;
        SQLU=SQLU||(fieldrec.name)||''=i.''||fieldrec.name;
        SQLIS=SQLIS||(fieldrec.name);

    end loop;

         if length(SQLUW)=1 then 
             SQLUW=SQLUW|| tablerec.name||''.''||key_field||''=i.''||key_field;
         end if;
        if length(SQLIW)=1 then 
             SQLIW=SQLIW||'' i.''||key_field||''=t.''||key_field;
         end if;
   
   

    tabl=path||''repl_''||tablerec.name||''.TXT'';
    SQL=SQL||'') from ''||quote_literal(tabl)||'' 
    with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
       raise notice ''SQL - %'',SQL;
   --raise notice '' key    field   -  %     !!!'',key_field;
 
   SQLU=SQLU||'' from ''||tablerec.name||''_tmp i where  ''||SQLUW; 

--    ||tablerec.name||''.''||key_field||''=i.''||key_field;
      -- raise notice ''SQLU - %'',SQLU;

     SQLI=SQLI||SQLIS||'') select ''||SQLIS||'' '';
    SQLI=SQLI||'' from (select * from 
                         (select t.*   from ''||tablerec.name||''_tmp t 
                       left join ''|| tablerec.name|| '' i
                         on ''||SQLIW ||  
                        '' where i.''||key_field||'' is null) as a) as a'';
--raise notice ''SQLI - %'',SQLI;

--i.''||key_field||''=t.''||key_field|| 
    EXECUTE ''ALTER TABLE ''||tablerec.name||'' DISABLE TRIGGER user'';
    Execute SQL;
  raise notice ''11 - '';
   if tablerec.flag_upd then
    raise notice ''SQLU - %'',SQLu;
    Execute SQLU;
    raise notice ''sqlu end - '';
   end if;
   if tablerec.flag_ins then
     raise notice ''SQLI - %'',SQLI;
     Execute SQLI;
     raise notice ''sqli end - '';
   end if;
 EXECUTE ''ALTER TABLE ''||tablerec.name||'' ENABLE TRIGGER user'';
end loop;
raise notice ''all - '';
 RETURN true;

end;'                                                                                           
LANGUAGE 'plpgsql';          

