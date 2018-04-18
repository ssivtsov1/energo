                                   /*
 „«ï ‘¢¥âë

 delete from asm_privdem_tbl where mmgg=¬¥áïæ;
 
select load_demand( ª­¨£ ,«¨æ¥¢®©,”ˆŽ,¤®¬,ª®à¯ãá,ª¢ àâ¨à ,
  ,ãáâ ­®¢«¥­ ï ¬®éì­®áâì,    ª®¤ ¤®¬  ¦¥ª ,   ¤à¥á áâà®ª®©,¯®ª § ­¨ï,¬¥áïæ);

*/
;


alter table clm_pclient_tbl  alter  column book numeric(9);
alter table clm_pclient_tbl  alter column code numeric(9);

CREATE INDEX clm_pclient_bookcod_idx
  ON clm_pclient_tbl
  USING btree
  (book, code);

CREATE INDEX clm_pclient_intcod_idx
  ON clm_pclient_tbl
  USING btree
  (intcod);

alter table clm_pclient_tbl alter column id_state set default 3;

/*update clm_pclient_tbl set id_state=3 from 
  ( select * from clm_pclient_tbl  c
     left join eqm_equipment_tbl e on c.id_eqpborder=e.id where  e.id is null)  n
where clm_pclient_tbl 
  */
update clm_pclient_tbl set id_state=3 where id_state is null and id_eqpborder is null;
update clm_pclient_tbl set id_state=4 where id_state is null and id_eqpborder is not null;



CREATE INDEX clm_pload_ind
  ON clm_pload_tmp
  USING btree
  (intcod);



alter table clm_pclient_tbl add column cbook varchar(10);
alter table clm_pclient_tbl add column ccode varchar(10);
alter table clm_pclient_tbl add column koatu_reg numeric(10);
alter table clm_pclient_tbl add column koatu_town numeric(10);
alter table clm_pclient_tbl add column koatu_street numeric(15);

set client_encoding = 'win';

drop FUNCTION charbook(varchar);


CREATE OR REPLACE FUNCTION charbook(character varying)
  RETURNS numeric AS
$BODY$
Declare
 charcod alias for $1;
 en_code varchar;
 symbols_l varchar;
 symbols_s varchar;
 len int;
 vi int;
 vid int;
 vletter varchar;
 vtire int;
begin

 symbols_l:='ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßI¯ABCDEFGHIJKLMNOPRQSTUVWXYZ';
 symbols_s:='àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿi¿abcdefghijklmnopqstuvwxyz';


  if charcod   ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' then
    en_code :=charcod ;
  else
   en_code :='';
   vtire:=0;
   len:=char_length(charcod );
   vi:=1;

   WHILE vi<= len LOOP

     vletter:= substr(charcod,vi,1);

     if vletter~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' then
        if vtire=1 then
           en_code :=en_code ||'99';
       vtire:=0;
        end if;
    en_code :=en_code ||vletter;
     else
       if vletter = '-'  then
     vtire:=1;
       end if;

       if strpos(symbols_s,vletter) <>0 then

             en_code :=en_code ||trim(to_char(strpos(symbols_s,vletter),'000'));
         vtire:=0;
       end if;

       if strpos(symbols_l,vletter) <>0 then

             en_code :=en_code ||'1'||trim(to_char(strpos(symbols_l,vletter),'00'));
             vtire:=0;
       end if;


     end if;
     vi:=vi+1;
   END LOOP;


  end if;
  if  to_number(en_code,'99999999999')>99999999999 then
   en_code='-1000000000';
 end if;   
return en_code;



end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION charbook(character varying)
  OWNER TO local;


set client_encoding = 'KOI8';



drop table clm_pload_tmp;
CREATE TABLE clm_pload_tmp
( id_dep character varying(3),
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
);

CREATE OR REPLACE FUNCTION expimp_indemand_fun(varchar)
  RETURNS text AS
$BODY$
  declare
  filename alias for $1;
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
if filename is null then
tabl=kod_res||'_poks'||'.txt';
tabl=replace(tabl,' ','');
else
tabl=filename;
end if; 
path='/home/local/replicat/in/';
tabl=path||tabl;          
del='@'; nul='';
set client_encoding='UTF8';
delete from  clm_pload_tmp;
SQL='copy  clm_pload_tmp 
  from '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul);
 Execute SQL;
/*
  delete from clm_pclient_tbl where book is null
   alter table clm_pload_tmp add column ibook numeric(10);
   alter table clm_pload_tmp add column icode numeric(10);
   update clm_pload_tmp set ibook=charbook(book);
   update clm_pload_tmp set icode=charbook(code);
   update clm_pclient_tbl set intcod=l.intcod  from clm_pload_tmp l where clm_pclient_tbl.book=(l.ibook) and  clm_pclient_tbl.code=(l.icode)
   and clm_pclient_tbl.intcod<>l.intcod
  alter table clm_pload_tmp drop column ibook;
  alter table clm_pload_tmp drop column icode;
*/
   
  insert into clm_pclient_tbl (intcod,cbook,ccode,name,koatu_reg ,  koatu_town,  koatu_street ,build,build_add,office,
       dom_gek,address,cod_tarif,cod_zone,set_power) 
     select pl.intcod ,  pl.book ,  pl.code ,  substr(pl.name,1,50) ,  pl.koatu_reg ,  pl.koatu_town,  pl.koatu_street ,
         substring(pl.house,1,5),  substring(pl.korp,1,5) ,  substring(pl.flat,1,5) ,pl.gek,  pl.addr,pl.tarif,pl.zone,pl.power from clm_pload_tmp  pl 
        left join clm_pclient_tbl c on c.intcod=pl.intcod 
        where  substring(pl.id_dep,1,2)=substring(kod_res,1,2) and c.intcod is null and coalesce(pl.archive,0) <> 1;      

 
   update clm_pclient_tbl set cbook=c.book,ccode=c.code, name=  substr(c.name,1,50),koatu_reg=c.koatu_reg,koatu_town=c.koatu_town, koatu_street=c.koatu_street,
   id_state= case when c.archive=1 then 50 else 0 end from clm_pload_tmp c where c.intcod=clm_pclient_tbl.intcod and substring(c.id_dep,1,2)=substring(kod_res,1,2); 
   
   update clm_pclient_tbl set book=charbook(cbook) where book is null and cbook is not null;
   update clm_pclient_tbl set code=charbook(ccode) where code is null and ccode is not null;
  

  select into mg distinct mmgg from clm_pload_tmp;
  delete  from acm_privdem_tbl where mmgg=mg;

  insert into acm_privdem_tbl (id_client,id_eqpborder,value,dat_b,dat_e,mmgg)
     select c.id,id_eqpborder,demand,mmgg,eom(mmgg),mmgg 
    from clm_pload_tmp l,clm_pclient_tbl c where c.intcod=l.intcod
    and (coalesce(l.demand,0)<>0 or coalesce(c.id_state,0)<>50 ) ; 

     set client_encoding='win';
  RETURN tabl;
end;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION expimp_indemand_fun()
  OWNER TO postgres;


drop function load_demand(varchar,varchar,numeric,date) ;
/*
select load_demand( ª­¨£ ,«¨æ¥¢®©,”ˆŽ,
¤®¬,ª®à¯ãá,ª¢ àâ¨à ,
  ,ãáâ ­®¢«¥­ ï ¬®éì­®áâì,    ª®¤ ¤®¬  ¦¥ª ,   ¤à¥á áâà®ª®©,¯®ª § ­¨ï,¬¥áïæ);
*/


/*
insert into clm_pclient_tbl (id,book,code,name,id_address) 
 select id,book,code,substring(name,1,50),id_addres  
from clm_client_tbl where book>0;

update clm_pclient_tbl set id_street=ad.id_street,
         build=cast(ad.building as varchar(5)),
         build_add=cast(ad.building_add as varchar(5)),
         office=cast(ad.office as varchar(5)) 
      from adm_address_tbl ad where clm_pclient_tbl.id_address=ad.id 
 and clm_pclient_tbl.id_street is null;

update clm_client_tbl set id_addres=NULL where book>0;

update clm_pclient_tbl set tax_num=st.tax_num,
         doc_num=st.doc_num,
         doc_dat=st.doc_dat,
         dt_indicat=st.dt_indicat,
         id_kur=st.id_kur,
         num_subsid=st.num_subsid 
      from clm_statecl_tbl st where clm_pclient_tbl.id=st.id_client 
 and clm_pclient_tbl.doc_dat is null;
;


update clm_pclient_tbl set id_eqpborder=eqp.id_eqmborder
      from eqm_privmeter_tbl eqp where clm_pclient_tbl.id=eqp.id_client 
and clm_pclient_tbl.id_eqpborder is null;


*/



drop function load_demand(numeric,int,numeric,varchar,varchar,varchar,varchar,numeric,numeric,varchar,int,int,int,date); 


create or replace function load_demand(
numeric,int,numeric,varchar,
varchar,varchar,varchar,
numeric,numeric,varchar,int,int,int,date) 
returns boolean as
'
declare 
pintcod alias for $1;
pbook alias for $2;  
pcode alias for $3;
pname  alias for $4; 
pbuild alias for $5;
pbuild_add alias for $6;
poffice alias for $7;
ppower alias for $8;
pgek   alias for $9;
paddress alias for $10;
pdem alias for $11;
ptar  alias for $12;
pzone alias for $13;
pmmgg alias for $14;

vclient record;
pcl int;
ccl varchar;

begin 
 -- pcl=to_number(pcode,''9999999'');
 Raise Notice ''ÁÂÏÎ %  %'',pbook,pcode;
if pcode>9999999 then
  raise notice '' ******* ïÛÉÂËÁ ÚÁÇÒÕÚËÉ  %      %       % '',pbook,pcode,pname;
  return true;
end if;
  select into vclient id,id_eqpborder from clm_pclient_tbl 
    where code=pcode and book=pbook;

  if not found then
   -- insert into tmp_loadindp_err_tbl (book ,code ,indication) 
  --     values (to_number(pbook,''9999999''),to_number(pcode,''9999999''),pdem);
    insert into clm_pclient_tbl (intcod,book,code,name,build,build_add,office,
        set_power,dom_gek,address,cod_tarif,cod_zone) 
   values (pintcod,pbook,pcode,   substring( pname,1,50) ,substring(pbuild,1,5) ,substring(pbuild_add,1,5) ,substring(poffice,1,5) ,
     ppower ,pgek,paddress,ptar,pzone);


    select into vclient id,id_eqpborder from clm_pclient_tbl where code=pcode and book=pbook;
  end if;
    
    update clm_pclient_tbl set intcod=pintcod,name=pname,
    build=substring(pbuild,1,5),build_add=substring(pbuild_add,1,5),office=substring(poffice,1,5),
    set_power=ppower,     dom_gek=pgek,address=paddress,cod_tarif=ptar,cod_zone=pzone 
   where book=pbook and code=pcode;
      
   -- delete from asm_privdem_tbl where id_client=vclient.id and mmgg=pmmgg;
 
   insert into acm_privdem_tbl (id_client,id_eqpborder,value,dat_b,dat_e,mmgg)
         values(vclient.id,vclient.id_eqpborder,pdem,pmmgg,eom(pmmgg),pmmgg);

--         reg_date,reg_num,idk_document,flag_priv,id_doc_inspect,mmgg)
--        values(vid_dc,now(),pmmgg,''startp'',vidk_doc,true,varea,pmmgg);

  
  return true;
end;
' language 'plpgsql';


/*
insert into clm_pclient_tbl (id,book,code,name,id_address) 
 select id,book,code,substring(name,1,50),id_addres  
from clm_client_tbl where book>0;

update clm_pclient_tbl set id_street=ad.id_street,
         build=cast(ad.building as varchar(5)),
         build_add=cast(ad.building_add as varchar(5)),
         office=cast(ad.office as varchar(5)) 
      from adm_address_tbl ad where clm_pclient_tbl.id_address=ad.id 
 and clm_pclient_tbl.id_street is null;

update clm_client_tbl set id_addres=NULL where book>0;

update clm_pclient_tbl set tax_num=st.tax_num,
         doc_num=st.doc_num,
         doc_dat=st.doc_dat,
         dt_indicat=st.dt_indicat,
         id_kur=st.id_kur,
         num_subsid=st.num_subsid 
      from clm_statecl_tbl st where clm_pclient_tbl.id=st.id_client 
 and clm_pclient_tbl.doc_dat is null;
;


update clm_pclient_tbl set id_eqpborder=eqp.id_eqmborder
      from eqm_privmeter_tbl eqp where clm_pclient_tbl.id=eqp.id_client 
and clm_pclient_tbl.id_eqpborder is null;


*/

drop function load_demand_all(int); 
create or replace function load_demand_all(int) 
returns boolean as
'
declare 
par alias for $1;
rec record;
i int;
t boolean; 
sq text;
exc integer;
begin 
i=1;
exc=1;
if par=1  then
 for rec in select * from tmp_load where str_sql like ''delete%'' loop
  sq=rec.str_sql; 
  execute(sq);
 end loop;
 return true;
end if;
if par=0 then 
 for rec in select * from tmp_load where str_sql like ''select%'' loop
  sq=rec.str_sql;
  execute(sq);
  i=i+1;
  raise notice '' %  ,   % '',i,sq;
 end loop;
 return true;
end if;
end;
' language 'plpgsql';

  
drop function upd_privarch(int,int); 
create or replace function upd_privarch(int,int)  
returns boolean as
'
declare 
pbook alias for $1;  
pcode alias for $2;
begin 
-- set status archive for archive abon

    update clm_pclient_tbl set id_state=50   where book=pbook and code=pcode;
 return true;
end;
' language 'plpgsql';


drop function upd_privarch(int,numeric); 
create or replace function upd_privarch(int,numeric)  
returns boolean as
'
declare 
pbook alias for $1;  
pcode alias for $2;
begin 
-- set status archive for archive abon

    update clm_pclient_tbl set id_state=50   where book=pbook and code=pcode;
 return true;
end;
' language 'plpgsql';



drop function upd_privarch(int,varchar); 
create or replace function upd_privarch(int,varchar)  
returns boolean as
'
declare 
pbook alias for $1;  
pcode alias for $2;
begin 
-- set status archive for archive abon

  --  update clm_pclient_tbl set id_state=50   where book=pbook and code=pcode;
 return true;
end;
' language 'plpgsql';



create table tmp_load 
(str_sql varchar(500));

----------------------------------------------------------------------------------------------
--update acm_privdem_tbl when edit clm_pclient_tbl

  CREATE or replace FUNCTION clm_pclient_edit_fun ()
  RETURNS TRIGGER
  AS                                                                                              
$BODY$
  declare
    vid_tree int;
    v        int;
    vparent  record;
    vid_old_tree int;
    olduse   int;
    newuse   int;

  begin

   if (coalesce(OLD.id_eqpborder,0)<> coalesce(NEW.id_eqpborder,0)) then

     update acm_privdem_tbl set id_eqpborder  = NEW.id_eqpborder
     where id_client = NEW.id  
     and mmgg = fun_mmgg();

   end if;  

  RETURN NEW;                                                       
  end;
  $BODY$                                                                                           
  LANGUAGE 'plpgsql';          


 CREATE TRIGGER clm_pclient_edit_trg
 after  UPDATE 
 ON clm_pclient_tbl
 FOR EACH ROW 
 EXECUTE PROCEDURE clm_pclient_edit_fun();
