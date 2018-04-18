CREATE or replace FUNCTION sys_replicat_in_fun ()                                                  
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
codepag text;
 res bool;
begin  
 -- first table
del=''@''; nul='''';  
  path=''/home/local/replicat/in/''; 
 codepag=''Koi8'';        
SQLC=''set client_encoding=Koi8''|| quote_literal(codepag)||'' )'';
    Execute SQLC;
  

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
 codepag=''win'';        
SQLC=''set client_encoding=Koi8''|| quote_literal(codepag)|| '')'';
    Execute SQLC;

raise notice ''all - '';
 RETURN true;

end;'                                                                                           
LANGUAGE 'plpgsql';          

                 
