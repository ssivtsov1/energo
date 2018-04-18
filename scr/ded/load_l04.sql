CREATE TABLE load_fider04_tmp
(
  num character varying(20),
  lname character varying(100),
  tpname character varying(100),
  length character varying(20),
  create_dt character varying(20)
) 
WITHOUT OIDS;


CREATE OR REPLACE FUNCTION load_fider04(character varying)
  RETURNS boolean AS
$BODY$
  declare
  pname_file alias for $1;
  r record;
  SSQL text;
  fil text;
  path text;
  skod_res varchar;
  fl_ins int;
  vid int;
begin  
  set client_encoding = 'win';

  path='/home/local/replicat/in/';     

  fil=path||pname_file;   

  delete from load_fider04_tmp;

  SSQL=' copy load_fider04_tmp   from '||quote_literal(fil)|| '  with delimiter as '';'' null as ''''  CSV  HEADER ';
  raise notice 'SQL % ',SSQL;
  Execute  SSQL;

  delete from load_fider04_tmp where lname is null;

  skod_res=getsysvar('id_res');

  for r in select t.* from load_fider04_tmp as t 
  left join eqm_equipment_tbl as eq on (eq.name_eqp = trim(t.lname) )
  where eq.name_eqp is null
  loop

    raise notice ' new line %', r.lname;

    select into fl_ins eqt_change_fun(2,null,null,null,null,0); 

    insert into eqm_equipment_tbl  (id,type_eqp,num_eqp,name_eqp,dt_install) 
    values (default, 15, trim(r.num), trim(r.lname), to_date(r.create_dt, 'DD.MM.YYYY') ) returning id into vid ;
   
    insert into eqm_fider_tbl (code_eqp,id_voltage,l04_length) 
    values (vid, 4, r.length::int  ) ; 
 
    insert into eqm_area_tbl (code_eqp,id_client) 
    values (vid, skod_res::int);

  end loop;

RETURN true;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;




CREATE TABLE load_fiz_reconnect_tmp
(
  num character varying(20),
  tp35 character varying(100),
  f10 character varying(100),
  tp10 character varying(100),
  f04 character varying(100),
  connect character varying(100),
  id_connect int,
  id_new_connect int,
  voltage character varying(10),
  book int,
  code int,
  name character varying(100),
  addr character varying(100),
  tu int,
  num_eqp character varying(20),
  power character varying(10),
  state character varying(50)
) 
WITHOUT OIDS;



CREATE OR REPLACE FUNCTION load_fiz_reconnect(character varying)
  RETURNS boolean AS
$BODY$
  declare
  pname_file alias for $1;
  r record;
  SSQL text;
  fil text;
  path text;
  skod_res varchar;
  fl_ins int;
  vid int;
begin  
  set client_encoding = 'win';

  path='/home/local/replicat/in/';     

  fil=path||pname_file;   

  delete from load_fiz_reconnect_tmp;

  SSQL=' copy load_fiz_reconnect_tmp   from '||quote_literal(fil)|| '  with delimiter as '';'' null as ''''  CSV  HEADER ';
  raise notice 'SQL % ',SSQL;
  Execute  SSQL;


  delete from load_fiz_reconnect_tmp where id_new_connect is null;

  skod_res=getsysvar('id_res');

  for r in select * from load_fiz_reconnect_tmp
  loop

    select into vid id_eqpborder from clm_pclient_tbl where book = r.book and code = r.code;
    
    if vid <> r.id_new_connect then 

        update clm_pclient_tbl set id_eqpborder = r.id_new_connect where book = r.book and code = r.code;
	

    end if;

  end loop;

RETURN true;

end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


/*
select load_fiz_reconnect('reconnect7.csv');

select * from load_fiz_reconnect_tmp;

select getsysvar('id_res');

select * from clm_pclient_tbl limit 100
*/