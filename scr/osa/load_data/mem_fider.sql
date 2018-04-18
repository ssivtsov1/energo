;

CREATE TABLE clm_pload_tmp
(
  mmgg date,
  intcod numeric(15,0),
  book character varying(10),
  code character varying(10),
  name character varying(150),
  archive integer,
  koatu_reg numeric(10,0),
  koatu_town numeric(10,0),
  koatu_street numeric(15,0),
  house character varying(10),
  korp character varying(10),
  flat character varying(10),
  addr character varying(200),
  gek numeric(15,0),
  power numeric(10,4),
  tarif integer,
  zone integer,
  demand integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE clm_pload_tmp
  OWNER TO postgres;

-- Index: clm_pload_ind

-- DROP INDEX clm_pload_ind;

CREATE INDEX clm_pload_ind
  ON clm_pload_tmp
  USING btree
  (intcod);

alter table clm_pclient_tbl add column cbook varchar(10);
alter table clm_pclient_tbl add column ccode varchar(10);
alter table clm_pclient_tbl add column koatu_reg numeric(10);
alter table clm_pclient_tbl add column koatu_town numeric(10);
alter table clm_pclient_tbl add column koatu_street numeric(15);


CREATE OR REPLACE FUNCTION expimp_indemand_fun()
  RETURNS text AS
$BODY$
  declare
  rec record;
  mg date;
  SQL text;
  tabl text;
  del text;
  path text;
  nul text;
  res bool;
  recbase record;
  kod_res varchar;
begin  

select into kod_res value_ident from syi_sysvars_tbl where ident='kod_res' ;
tabl=kod_res||'_poks'||'.txt';
tabl=replace(tabl,' ','');
path='/home/local/replicat/in/';
tabl=path||tabl;          
del='@'; nul='';
delete from  clm_pload_tmp;
SQL='copy  clm_pload_tmp 
  from '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul);
 Execute SQL;

  insert into clm_pclient_tbl (intcod,cbook,ccode,name,koatu_reg ,  koatu_town,  koatu_street ,build,build_add,office,
       dom_gek,address,cod_tarif,cod_zone,set_power) 
     select pl.intcod ,  pl.book ,  pl.code ,  pl.name ,  pl.koatu_reg ,  pl.koatu_town,  pl.koatu_street ,
         pl.house,  pl.korp ,  pl.flat ,pl.gek,  pl.addr,pl.tarif,pl.zone,pl.power from clm_pload_tmp  pl 
        left join clm_pclient_tbl c on c.intcod=pl.intcod where c.intcod is null;      

   update clm_pclient_tbl set cbook=c.book,ccode=c.code, name=c.name,koatu_reg=c.koatu_reg,koatu_town=c.koatu_town, koatu_street=c.koatu_street,
   id_state= case when c.archive=1 then 50 else 0 end from clm_pload_tmp c where c.intcod=clm_pclient_tbl.intcod;        


  select into mg distinct mmgg from clm_pload_tmp;
  delete  from acm_privdem_tbl where mmgg=mg;

   insert into acm_privdem_tbl (id_client,id_eqpborder,value,dat_b,dat_e,mmgg)
     select c.id,id_eqpborder,demand,mmgg,eom(mmgg),mmgg from clm_pload_tmp l,clm_pclient_tbl c where c.intcod=l.intcod; 
  RETURN tabl;
end;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION expimp_indemand_fun()
  OWNER TO postgres;



select expimp_indemand_fun();