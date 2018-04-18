CREATE or replace FUNCTION substr_word (varchar,int,int)
  RETURNS varchar
  AS                                                                                              
  '
  declare
  pstr Alias for $1;    
  pfrom Alias for $2;    
  pcnt  Alias for $3;    

  vlastpos int;
begin

 vlastpos =0;

 if length(pstr) < pfrom then
  return '''';
 end if;

 if length(pstr) <= pfrom+pcnt then
  RETURN substr(pstr,pfrom,pcnt);
 end if;


 FOR vi IN pfrom..pfrom+pcnt LOOP
     
    if substr(pstr,vi,1)= '' '' then 
       vlastpos:=vi;
    end if;
    RAISE NOTICE ''i is %'', vi;
 END LOOP;

 if vlastpos<>0 then 
   RETURN substr(pstr,pfrom,vlastpos - pfrom);
 else 
   RETURN '''';
 end if;

end;'                                                                                           
LANGUAGE 'plpgsql' IMMUTABLE ;
