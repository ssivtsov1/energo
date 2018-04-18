create table clm_pclient_tbl (
     id                 int default nextval('clm_client_seq'),
     book               numeric(7,0),
     code               numeric(7,0),
     name               varchar (50),
     id_address         int,
     id_street          int,
     build              varchar(5),
     build_add          varchar(5),
     office             varchar(5),
     tax_num            varchar(15),
     doc_num            varchar(15),
     doc_dat            date,
     dt_indicat         int,
     id_kur             int,
     num_subsid         varchar(8),
     id_eqpborder       int,
     primary key(id)
);

create sequence acm_privdem_seq;
create table acm_privdem_tbl(
     id                 int default nextval('acm_privdem_seq'),
     id_client          int,
     id_eqpborder       int,
     dat_b              date,
     dat_e              date,
     value              numeric (10,0),
     mmgg               date default fun_mmgg(),
     flock              int default 0,  
     dt                 timestamp default now(),
     primary key(id)
);
/*
insert into clm_pclient_tbl (id,book,code,name,id_address) 
 select id,book,code,substring(name,1,50),id_addres  from clm_client_tbl where book>0;

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


create or replace function load_demand(varchar,varchar,numeric,date) 
returns boolean as
'
declare 
pbook alias for $1;
pcode alias for $2;
pdem alias for $3;
pmmgg alias for $4;
vclient record;
begin 

 select into vclient id,id_eqpborder from clm_pclient_tbl where code=pcode and book=pbook;

 if not found then
    Raise Notice ''Not abon % %'',pbook,pcode;
    insert into tmp_loadindp_err_tbl (book ,code ,indication) 
       values (to_number(pbook,''9999999''),to_number(pcode,''9999999''),pdem);
    insert into clm_pclient_tbl (book,code) values (to_number(pbook,''9999999''),to_number(pcode,''9999999''));
 select into vclient id,id_eqpborder from clm_pclient_tbl where code=pcode and book=pbook;


 --return false;
 end if;
  -- delete from asm_privdem_tbl where id_client=vclient.id and mmgg=pmmgg;

   insert into acm_privdem_tbl (id_client,id_eqpborder,value,dat_b,dat_e,mmgg)
         values(vclient.id,vclient.id_eqpborder,pdem,pmmgg,eom(pmmgg),pmmgg);

--         reg_date,reg_num,idk_document,flag_priv,id_doc_inspect,mmgg)
--        values(vid_dc,now(),pmmgg,''startp'',vidk_doc,true,varea,pmmgg);


  return true;
end;
' language 'plpgsql';



                                   /*

 delete from asm_privdem_tbl where mmgg=месяц;




select load_demand( книга,лицевой,показания,месяц);

*/