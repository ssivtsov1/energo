create or replace function rep_file_f32_fun(date) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
  v int;
  r record;
 tabl varchar;
 del varchar; 
 nul varchar;
 SQL text;
 kodres int;
--  vid_pref int;

BEGIN

 delete from rep_f32_tbl ;

 perform rep_f32_fun(pmmgg);

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

 tabl=''/home/local/seb/''||kodres||''f32.TXT'';
 del=''@''; nul='''';

--delete from seb_obr;

--insert into seb_obr select * from seb_obr_all where id_pref=10 and id_client is not null
--order by cod_r,osob_r ;

 SQL=''copy  rep_f32_tbl  to ''
 ||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

 raise notice ''%'',SQL;

 Execute SQL;

RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

--------------------------------------------------------------------------------------------------------
create or replace function rep_file_nds_fun(date,int) returns int
AS                                                                                              
'
declare 
  pmmgg alias for $1; 
  ppref alias for $2;
  v int;
  r record;
 tabl varchar;
 del varchar; 
 nul varchar;
 SQL text;
 kodres int;
--  vid_pref int;

BEGIN

-- delete from rep_f32_tbl ;

 perform rep_nds_fun(pmmgg,ppref,true);

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

 tabl=''/home/local/seb/''||kodres||''NDS.TXT'';
 del=''@''; nul='''';

--delete from seb_obr;

--insert into seb_obr select * from seb_obr_all where id_pref=10 and id_client is not null
--order by cod_r,osob_r ;

 SQL=''copy  rep_nds_tbl  to ''
 ||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

 raise notice ''%'',SQL;

 Execute SQL;

RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          
