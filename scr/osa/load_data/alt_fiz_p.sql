-- Не запускать в старт
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
      from adm_address_tbl ad where clm_pclient_tbl.id_address=ad.id;

update clm_pclient_tbl set tax_num=st.tax_num,
         doc_num=st.doc_num,
         doc_dat=st.doc_dat,
         dt_indicat=st.dt_indicat,
         id_kur=st.id_kur,
         num_subsid=st.num_subsid 
      from clm_statecl_tbl st where clm_pclient_tbl.id=st.id_client;

update clm_pclient_tbl set id_eqpborder=eqp.id_eqmborder
      from eqm_privmeter_tbl eqp where clm_pclient_tbl.id=eqp.id_client;

*/
drop function load_demand(varchar,varchar,numeric,date) ;
create or replace function load_demand(varchar,varchar,varchar,numeric,date,numeric,int) 
returns boolean as
'
declare 
pbook alias for $1;
pcode alias for $2;
pname  alias for $3 
pdem alias for $4;
pmmgg alias for $5;
ppower alias for $7;
pgek   alias for $8;
vclient record;
begin 

 select into vclient id,id_eqmborder from clm_pclient_tbl where code=pcode and book=pbook;
  if not found then
    Raise Notice ''Not abon %'',pclient;
    insert into tmp_loadindp_err_tbl (book,code,indication) values (pbook,pcode,pdem);
    return false;
 end if;
  -- delete from asm_privdem_tbl where id_client=vclient.id and mmgg=pmmgg;

   insert into acm_privdem_tbl (id_client,id_eqpborder,value,dat_b,dat_e,mmgg)
         values(vclient.id,vclient.id_eqmborder,pdem,pmmgg,eom(pmmgg),pmmgg);
         reg_date,reg_num,idk_document,flag_priv,id_doc_inspect,mmgg)
        values(vid_dc,now(),pmmgg,''startp'',vidk_doc,true,varea,pmmgg);


  return true;
end;
' language 'plpgsql';

update clm_statecl_tbl set for_undef='delete' 
 from clm_client_tbl  c where c.id=clm_statecl_tbl.id_client and c.book>0;
select count(*) from clm_statecl_tbl;
select count(*) from clm_statecl_tbl where for undef='delete';
delete from clm_statecl_tbl where  for_undef='delete';

delete from adm_address_tbl


update adm_address_tbl set short_adr='delete' from  
 (select a.id as id_addres from
   (select id_addres from clm_client_tbl where book<0 
     union 
    select id_addr_main as id_addres from clm_client_tbl where book<0 
     union  
  select id_addres from eqm_equipment_tbl 
   )  s
    right join adm_address_tbl a  on a.id=s.id_addres 
    and s.id_addres is not null)   d 
where   d.id_addres=id;


delete from adm_address_tbl where short adr='delete';

drop function del_fiz();
create or replace function del_fiz() Returns boolean As '
Declare
trg1 smallint;
trg2 smallint;
trg3 smallint;
trg4 smallint;
trg5 smallint;
trg6 smallint;
trg7 smallint;
trg8 smallint;
trg9 smallint;
trg10 smallint;
trg11 smallint;
trg12 smallint;
trg13 smallint;
trg14 smallint;
st1 text;
st2 text;
delr record;
begin

select into trg1 reltriggers from pg_class where relname=''acm_bill_tbl'';
select into trg2 reltriggers from pg_class where relname=''acm_tax_tbl'';
select into trg3 reltriggers from pg_class where relname=''acm_taxcorrection_tbl'';
select into trg4 reltriggers from pg_class where relname=''acm_billtax_tbl'';
select into trg5 reltriggers from pg_class where relname=''acm_headindication_tbl'';
select into trg6 reltriggers from pg_class where relname=''acm_headpay_tbl'';
select into trg7 reltriggers from pg_class where relname=''acm_pay_tbl'';
select into trg8 reltriggers from pg_class where relname=''acm_saldo_tbl'';
select into trg9 reltriggers from pg_class where relname=''acm_salsubs_tbl'';
select into trg10 reltriggers from pg_class where relname=''acm_subs_tbl'';
select into trg11 reltriggers from pg_class where relname=''acm_billpay_tbl'';
select into trg12 reltriggers from pg_class where relname=''acm_headsum_tbl'';
select into trg13 reltriggers from pg_class where relname=''acm_taxadvcor_tbl'';
select into trg14 reltriggers from pg_class where relname=''acd_indication_tbl'';
Raise Notice ''trg1 - %'',trg1;
Raise Notice ''trg2 - %'',trg2;
Raise Notice ''trg3 - %'',trg3;
Raise Notice ''trg4 - %'',trg4;
Raise Notice ''trg5 - %'',trg5;
Raise Notice ''trg6 - %'',trg6;
Raise Notice ''trg7 - %'',trg7;
Raise Notice ''trg8 - %'',trg8;
Raise Notice ''trg9 - %'',trg9;
Raise Notice ''trg10 - %'',trg10;
Raise Notice ''trg11 - %'',trg11;
Raise Notice ''trg12 - %'',trg12;
Raise Notice ''trg13 - %'',trg13;
Raise Notice ''trg14 - %'',trg14;
update pg_class set reltriggers=0 where relname=''acm_bill_tbl'';
update pg_class set reltriggers=0 where relname=''acm_tax_tbl'';
update pg_class set reltriggers=0 where relname=''acm_taxcorrection_tbl'';
update pg_class set reltriggers=0 where relname=''acm_billtax_tbl'';
update pg_class set reltriggers=0 where relname=''acm_headindication_tbl'';
update pg_class set reltriggers=0 where relname=''acm_headpay_tbl'';
update pg_class set reltriggers=0 where relname=''acm_pay_tbl'';
update pg_class set reltriggers=0 where relname=''acm_saldo_tbl'';
update pg_class set reltriggers=0 where relname=''acm_salsubs_tbl'';
update pg_class set reltriggers=0 where relname=''acm_subs_tbl'';
update pg_class set reltriggers=0 where relname=''acm_billpay_tbl'';
update pg_class set reltriggers=0 where relname=''acm_headsum_tbl'';
update pg_class set reltriggers=0 where relname=''acm_taxadvcor_tbl'';
update pg_class set reltriggers=0 where relname=''acd_indication_tbl'';
----bill

Raise Notice ''bill'';
for delr in select id_doc from acm_bill_tbl where flag_priv=true loop
    delete from acd_billsum_tbl where id_doc=delr.id_doc;
    delete from asd_calc_losts_tbl where id_doc=delr.id_doc;
    delete from acd_met_kndzn_tbl where id_doc=delr.id_doc;
    delete from acd_pnt_tarif_tbl where id_doc=delr.id_doc;
    delete from acd_point_branch_tbl where id_doc=delr.id_doc;
    delete from acd_pwr_demand_tbl where id_doc=delr.id_doc;

end loop; 
    delete from acm_bill_tbl where flag_priv=true;

for delr in select id_doc from acm_bill_del where flag_priv=true loop
    delete from acd_billsum_del where id_doc=delr.id_doc;
    delete from asd_calc_losts_del where id_doc=delr.id_doc;
    delete from acd_met_kndzn_del where id_doc=delr.id_doc;
    delete from acd_pnt_tarif_del where id_doc=delr.id_doc;
    delete from acd_point_branch_del where id_doc=delr.id_doc;
    delete from acd_pwr_demand_del where id_doc=delr.id_doc;

end loop; 
    delete from acm_bill_del where flag_priv=true;


Raise Notice ''billdel'';

for delr in select id_doc from acm_bill_tbl where flag_priv=true loop
    delete from acd_billsum_tbl where id_doc=delr.id_doc;
    delete from asd_calc_losts_tbl where id_doc=delr.id_doc;
    delete from acd_met_kndzn_tbl where id_doc=delr.id_doc;
    delete from acd_pnt_tarif_tbl where id_doc=delr.id_doc;
    delete from acd_point_branch_tbl where id_doc=delr.id_doc;
    delete from acd_pwr_demand_tbl where id_doc=delr.id_doc;

end loop; 
    delete from acm_bill_tbl where flag_priv=true;



-----saldo
Raise Notice ''saldo'';
delete from acm_saldo_tbl;
------------------
update pg_class set reltriggers=trg1 where relname=''acm_bill_tbl'';
update pg_class set reltriggers=trg2 where relname=''acm_tax_tbl'';
update pg_class set reltriggers=trg3 where relname=''acm_taxcorrection_tbl'';
update pg_class set reltriggers=trg4 where relname=''acm_billtax_tbl'';
update pg_class set reltriggers=trg5 where relname=''acm_headindication_tbl'';
update pg_class set reltriggers=trg6 where relname=''acm_headpay_tbl'';
update pg_class set reltriggers=trg7 where relname=''acm_pay_tbl'';
update pg_class set reltriggers=trg8 where relname=''acm_saldo_tbl'';
update pg_class set reltriggers=trg9 where relname=''acm_salsubs_tbl'';
update pg_class set reltriggers=trg10 where relname=''acm_subs_tbl'';
update pg_class set reltriggers=trg11 where relname=''acm_billpay_tbl'';
update pg_class set reltriggers=trg12 where relname=''acm_headsum_tbl'';
update pg_class set reltriggers=trg13 where relname=''acm_taxadvcor_tbl'';
update pg_class set reltriggers=trg14 where relname=''acd_indication_tbl'';

Return true;
end;
' Language 'plpgsql';

                     /*
select now(); 
select * from 
 (select 'acd_billsum_del' as nam,count(*) as t from acd_billsum_del union 
 select 'acd_calc_losts_del' as nam,count(*) as t from acd_calc_losts_del union
 select 'acd_clc_inf_del' as nam,count(*) as t from acd_clc_inf_del union 
 select 'acd_kateg_del' as nam,count(*) as t from acd_kateg_del union 
 select 'acd_met_kndzn_del' as nam,count(*) as t from acd_met_kndzn_del union 
 select 'acd_pnt_tarif_del' as nam,count(*) as t from acd_pnt_tarif_del union
 select 'acd_point_branch_del' as nam,count(*) as t from acd_point_branch_del union
 select 'acd_pwr_demand_del' as nam,count(*) as t from acd_pwr_demand_del union 
 select 'acm_bill_del' as nam,count(*) as t from acm_bill_del union 
 select 'acd_billtax_tbl' as nam,count(*) as t from acm_billtax_tbl union
 select 'acd_billsum_tbl' as nam,count(*) as t from acd_billsum_tbl union 
 select 'acd_calc_losts_tbl' as nam,count(*) as t from acd_calc_losts_tbl union
 select 'acd_clc_inf' as nam,count(*) as t from acd_clc_inf union 
 select 'acd_kateg_tbl' as nam,count(*) as t from acd_kateg_tbl union 
 select 'acd_met_kndzn_tbl' as nam,count(*) as t from acd_met_kndzn_tbl union 
 select 'acd_pnt_tarif' as nam,count(*) as t from acd_pnt_tarif union 
 select 'acd_point_branch_tbl' as nam,count(*) as t from acd_point_branch_tbl union 
 select 'acd_pwr_demand_tbl' as nam,count(*) as t from acd_pwr_demand_tbl union 
 select 'acm_bill_tbl' as nam,count(*) as t from acm_bill_tbl union 
 select 'acd_indication_tbl' as nam,count(*) as t from acd_indication_tbl union
 select 'acm_headindication_tbl' as nam,count(*) as t from acm_headindication_tbl union 
 select 'acd_acctarsum_tbl' as nam,count(*) as t from acd_acctarsum_tbl union 
 select 'acd_partarif_tbl' as nam,count(*) as t from acd_partarif_tbl union 
 select 'acd_addsubs_tbl' as nam,count(*) as t from acd_addsubs_tbl union 
 select 'acd_subs_tbl' as nam,count(*) as t from acd_subs_tbl union 
 select 'acm_subs_tbl' as nam,count(*) as t from acm_subs_tbl union 
 select 'acm_salsubs_tbl' as nam,count(*) as t from acm_salsubs_tbl union 
 select 'acm_headsum_tbl' as nam,count(*) as t from acm_headsum_tbl union 
 select 'acm_billpay_tbl' as nam,count(*) as t from acm_billpay_tbl union 
 select 'acm_pay_tbl' as nam,count(*) as t from acm_pay_tbl union 
 select 'acm_headpay_tbl' as nam,count(*) as t from acm_headpay_tbl union 
 select 'acd_tax_tbl' as nam,count(*) as t from acd_tax_tbl union 
 select 'acd_taxcorrection_tbl' as nam,count(*) as t from acd_taxcorrection_tbl union 
 select 'acm_taxadvcor_tbl' as nam,count(*) as t from acm_taxadvcor_tbl union 
 select 'acm_taxcorrection_tbl' as nam,count(*) as t from acm_taxcorrection_tbl union 
 select 'acm_tax_tbl' as nam,count(*) as t from acm_tax_tbl union 
 select 'acm_saldo_tbl' as nam,count(*) as t from acm_saldo_tbl) as k	;
                       */
--select del_nall_inf3('2005-05-01','2005-09-01');
                         /*
select * from 
 (select 'acd_billsum_del' as nam,count(*) as t from acd_billsum_del union 
 select 'acd_calc_losts_del' as nam,count(*) as t from acd_calc_losts_del union
 select 'acd_clc_inf_del' as nam,count(*) as t from acd_clc_inf_del union 
 select 'acd_kateg_del' as nam,count(*) as t from acd_kateg_del union 
 select 'acd_met_kndzn_del' as nam,count(*) as t from acd_met_kndzn_del union 
 select 'acd_pnt_tarif_del' as nam,count(*) as t from acd_pnt_tarif_del union
 select 'acd_point_branch_del' as nam,count(*) as t from acd_point_branch_del union
 select 'acd_pwr_demand_del' as nam,count(*) as t from acd_pwr_demand_del union 
 select 'acm_bill_del' as nam,count(*) as t from acm_bill_del union 
 select 'acd_billtax_tbl' as nam,count(*) as t from acm_billtax_tbl union
 select 'acd_billsum_tbl' as nam,count(*) as t from acd_billsum_tbl union 
 select 'acd_calc_losts_tbl' as nam,count(*) as t from acd_calc_losts_tbl union
 select 'acd_clc_inf' as nam,count(*) as t from acd_clc_inf union 
 select 'acd_kateg_tbl' as nam,count(*) as t from acd_kateg_tbl union 
 select 'acd_met_kndzn_tbl' as nam,count(*) as t from acd_met_kndzn_tbl union 
 select 'acd_pnt_tarif' as nam,count(*) as t from acd_pnt_tarif union 
 select 'acd_point_branch_tbl' as nam,count(*) as t from acd_point_branch_tbl union 
 select 'acd_pwr_demand_tbl' as nam,count(*) as t from acd_pwr_demand_tbl union 
 select 'acm_bill_tbl' as nam,count(*) as t from acm_bill_tbl union 
 select 'acd_indication_tbl' as nam,count(*) as t from acd_indication_tbl union
 select 'acm_headindication_tbl' as nam,count(*) as t from acm_headindication_tbl union 
 select 'acd_acctarsum_tbl' as nam,count(*) as t from acd_acctarsum_tbl union 
 select 'acd_partarif_tbl' as nam,count(*) as t from acd_partarif_tbl union 
 select 'acd_addsubs_tbl' as nam,count(*) as t from acd_addsubs_tbl union 
 select 'acd_subs_tbl' as nam,count(*) as t from acd_subs_tbl union 
 select 'acm_subs_tbl' as nam,count(*) as t from acm_subs_tbl union 
 select 'acm_salsubs_tbl' as nam,count(*) as t from acm_salsubs_tbl union 
 select 'acm_headsum_tbl' as nam,count(*) as t from acm_headsum_tbl union 
 select 'acm_billpay_tbl' as nam,count(*) as t from acm_billpay_tbl union 
 select 'acm_pay_tbl' as nam,count(*) as t from acm_pay_tbl union 
 select 'acm_headpay_tbl' as nam,count(*) as t from acm_headpay_tbl union 
 select 'acd_tax_tbl' as nam,count(*) as t from acd_tax_tbl union 
 select 'acd_taxcorrection_tbl' as nam,count(*) as t from acd_taxcorrection_tbl union 
 select 'acm_taxadvcor_tbl' as nam,count(*) as t from acm_taxadvcor_tbl union 
 select 'acm_taxcorrection_tbl' as nam,count(*) as t from acm_taxcorrection_tbl union 
 select 'acm_tax_tbl' as nam,count(*) as t from acm_tax_tbl union 
 select 'acm_saldo_tbl' as nam,count(*) as t from acm_saldo_tbl) as k	;
*/
select now(); 



                                   /*

 delete from asm_privdem_tbl where mmgg=месяц;




select load_demand( книга,лицевой,показания,месяц);

*/