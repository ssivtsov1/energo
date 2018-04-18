  drop FUNCTION scanfields ();                                                                                                                                         
  CREATE FUNCTION scanfields ()                                                  
  RETURNS bool                                                                                     
  AS                                                                                              
  '
  declare
  tablerec record;
  fieldrec record;
  tableoid  oid;
  typeid   integer;
  typename varchar;
  newoid int;
  v int ;
  begin                
 
  select into newoid coalesce(max(id),0)+1 from syi_field_tbl;
 --  newoid:=1;

  for tablerec in select * from syi_table_tbl loop

  select into tableoid oid from pg_class where relname= cast (tablerec.name AS name);

  if found then

--    raise notice '''';

    for fieldrec in select Attname,Atttypid from pg_attribute where Attrelid = tableoid loop

    if (fieldrec.Attname<>''ctid'') and (fieldrec.Attname<>''oid'') and
     (fieldrec.Attname<>''xmin'') and (fieldrec.Attname<>''cmin'') and
     (fieldrec.Attname<>''xmax'') and (fieldrec.Attname<>''cmax'') and
     (fieldrec.Attname<>''tableoid'') 
     and not (fieldrec.Attname ~''pg.dropped'' )then 

     select into typename typname from pg_type where oid = fieldrec.Atttypid;
     select into typeid id from syi_type_tbl where name = typename;

     select into v id from syi_field_tbl where id_table = tablerec.id and text(name) = text(fieldrec.Attname);
 
     if not found then

      insert into syi_field_tbl(id,id_table,id_type,name) values (newoid,tablerec.id,typeid,fieldrec.Attname);
      newoid:=newoid+1;
     end if;
    end if;
   end loop;
  end if;
  end loop;
  RETURN true;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

  select scanfields ();                                                                                                                                         