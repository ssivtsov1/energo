drop trigger trg_clm_client_upd on clm_client_tbl;
drop function fun_trg_clm_client_upd();

create function trg_clm_client_upd() returns opaque as
$BODY$
Declare
  begin 

if new.dt_close >'2001-01-01' and new.id_state not in (50,99)  then 
  new.id_state=49;
end if;    
  Return new;  
end;     
$BODY$ Language 'plpgsql';


create trigger trg_clm_client_upd
    Before update ON clm_client_tbl
    For Each Row Execute Procedure trg_clm_client_upd();

alter table adi_town_tbl add column id_ptown int;
alter table adi_town_tbl add column koatu  integer;

alter table adi_street_tbl add column id_ptown int;
alter table adi_street_tbl add column koatu  integer;


/*

update clm_client_tbl set dt_close =ddt from  (select c.id,max(b.reg_date) as ddt 
from clm_client_tbl c,acm_bill_tbl b where b.id_client=c.id and c.id_state=3 group by  c.id,c.idk_work ) t
where clm_client_tbl.id_state=3 and clm_client_tbl.id=t.id and t.ddt<='2016-01-01'*/

alter table clm_position_tbl add column inn varchar(10);
alter table clm_position_tbl add column num_tab varchar(10);

update clm_client_tbl set id_state=0 where id_state is null; 
alter table clm_client_tbl alter  column flag_balance set default 0;

alter table clm_client_tbl add column dt_close  date;
alter table clm_client_h add column dt_close  date;


update clm_client_tbl set add_name=short_name from 
 clm_statecl_tbl s where s.id_client=clm_client_tbl.id and 
 s.flag_ed=1 and (s.flag_jur=0 or s.flag_jur is null)
 and add_name is null and getsysvarc('mmgg')='01.03.2012'; 

  
update clm_client_tbl set flag_balance=0 where flag_balance is null;
update clm_client_tbl set flag_balance=1 where id=(select value_ident from syi_sysvars_tbl where ident='id_bal'); 
update clm_client_tbl set flag_balance=1 where id=(select value_ident from syi_sysvars_tbl where ident='id_res'); 

select altr_colmn('eqi_corde_tbl','s_nom','numeric(9,3)');

select altr_colmn('clm_statecl_tbl','licens_num','varchar(14)');
select altr_colmn('clm_statecl_tbl','doc_num','varchar(20)');
select altr_colmn('clm_statecl_tbl','okpo_num','varchar(14)');
select altr_colmn('clm_statecl_tbl','tax_num','varchar(14)');

update clm_statecl_tbl set addr_local=a.adr from 
        clm_client_tbl c, adv_address_tbl a where 
        clm_statecl_tbl.id_client=c.id and c.id_addres=a.id 
        and clm_statecl_tbl.addr_local is null;

drop trigger cli_parb_ins on clm_client_tbl;
drop function cliparb_ins_pr();
drop trigger cli_para_ins on clm_client_tbl;
drop function clipara_ins_pr();

CREATE or replace FUNCTION syi_region_fun () RETURNS integer
    AS '
  declare
  id_res int;
  begin
   select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_region'';
   RETURN id_res;
  end;'
LANGUAGE plpgsql;




alter table clm_statecl_tbl add column month_control int;
alter table clm_statecl_h add column month_control int;


update clm_statecl_tbl set addr_tax=a.full_adr from 
        clm_client_tbl c, adv_address_tbl a where 
        clm_statecl_tbl.id_client=c.id and c.id_addres=a.id 
        and clm_statecl_tbl.addr_tax is null;


update clm_statecl_tbl set addr_main=a.full_adr from 
        clm_client_tbl c, adv_address_tbl a where 
        clm_statecl_tbl.id_client=c.id and c.id_addr_main=a.id 
        and clm_statecl_tbl.addr_main is null;




alter table clm_client_tbl add column kind_dep integer;
alter table clm_client_tbl add column id_addr_main integer;

update clm_client_tbl set book=-1 where book is null;


alter table cmi_tax_tbl add column ident varchar(10);
alter table cmi_bank_tbl add column code_okpo numeric(14);
alter table cli_account_tbl add column ident varchar(10);
alter table acm_pay_tbl add column mmgg_pay date;

insert into clm_client_tbl(id,name,short_name,code) values(999999999,'Main 1000000','Main 1000000',1000000); 


alter table clm_client_tbl add column id_check int;
alter table clm_statecl_tbl add column dt_create date;
alter table clm_statecl_tbl alter column dt_create set default now();


--update clm_statecl_tbl set dt_create=doc_dat where dt_create is null;
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(121,'dt_start_dog','varchar','2006-07-17');
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(20,'id_chnoe','int',999999999); 
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(31,'penalty','int',2);
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(32,'pay_day','int',5);
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(21,'eqpnamecopy','int',0);
update syi_sysvars_tbl set value_ident=1 where ident='eqpnamecopy'; 

alter table clm_statecl_tbl add column tr_doc_num varchar(20);
alter table clm_statecl_tbl add column tr_doc_date date;
alter table clm_statecl_tbl add column tr_year_price numeric(12,2);
alter table clm_statecl_tbl add column tr_doc_type int;
alter table clm_statecl_tbl add column tr_doc_period int;
alter table clm_statecl_tbl add column doc_num_tend varchar(20);
alter table clm_statecl_tbl add column doc_dat_tend date;
alter table clm_statecl_h add column tr_doc_num varchar(20);
alter table clm_statecl_h add column tr_doc_date date;
alter table clm_statecl_h add column tr_year_price numeric(12,2);
alter table clm_statecl_h add column tr_doc_type int;
alter table clm_statecl_h add column tr_doc_period int;
alter table clm_statecl_h add column doc_num_tend varchar(20);
alter table clm_statecl_h add column doc_dat_tend date;

alter table clm_statecl_tbl add column kosht_date_b date;  -- from yana
alter table clm_statecl_tbl add column kosht_date_e date;  -- from yana
alter table clm_statecl_tbl add column flag_3perc_year int;  -- from yana


CREATE SEQUENCE clm_stateclh_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 32789
  CACHE 1;
alter table clm_statecl_tbl add column mmgg_b date;
alter table clm_statecl_tbl alter column mmgg_b set default fun_mmgg();


select altr_colmn('clm_statecl_tbl','mmgg_b','date');
alter table clm_statecl_tbl alter column mmgg_b set default fun_mmgg();

alter table clm_statecl_h add column id_s int;
alter table clm_statecl_h alter column id_s set default nextval('clm_stateclh_seq');

alter table clm_statecl_tbl add column flag_del2kr int;
alter table clm_statecl_h   add column flag_del2kr int;

alter table clm_statecl_tbl alter column flag_del2kr set default 0;

update clm_statecl_tbl set flag_del2kr = 0 where flag_del2kr is null; 
update clm_statecl_h set flag_del2kr = 0 where flag_del2kr is null; 

ALTER TABLE clm_statecl_tbl ADD COLUMN filial_num character varying(4);
ALTER TABLE clm_statecl_h ADD COLUMN filial_num character varying(4);


drop trigger statecl_upd on clm_statecl_tbl;
drop trigger statecl_ins on clm_statecl_tbl;

drop function fun_statecl_upd();

 /*--------------------------------------------------------------*/


CREATE OR REPLACE FUNCTION fun_statecl_upd()
  RETURNS trigger AS
$BODY$
Declare
stath record;
isnew int;
mg date;
begin
mg=fun_mmgg();
isnew=1;
raise notice 'upd- %',new.id_client;
delete from clm_statecl_h    
where id_client=new.id_client and id=new.id  and mmgg_b>mg and mmgg_e is null;

update  clm_statecl_h set mmgg_e=null   
where id_client=new.id_client and id=new.id  and mmgg_b>mg;

for stath in select * from clm_statecl_h 
  where id_client=new.id_client and id=new.id  and mmgg_e is null loop
if stath.mmgg_b=mg then
 update clm_statecl_h set  tax_num=new.tax_num,flag_taxpay=new.flag_taxpay, e_mail = new.e_mail,
           licens_num=new.licens_num,okpo_num=new.okpo_num, doc_num=new.doc_num,doc_dat=new.doc_dat,
 id_budjet=new.id_budjet,id_kwed=new.id_kwed,id_taxprop=new.id_taxprop,
 doc_ground=new.doc_ground,id_position=new.id_position,id_kur=new.id_kur,flag_reactive=new.flag_reactive,dt_end_rent=new.dt_end_rent,
 period_indicat=new.period_indicat,dt_indicat=new.dt_indicat,month_indicat=new.month_indicat,dt_start=new.dt_start,month_control=new.month_control,
 day_pay_bill=new.day_pay_bill,type_pay=new.type_pay,pre_pay_grn=new.pre_pay_grn,
 pre_pay_day1=new.pre_pay_day1,pre_pay_perc1=new.pre_pay_perc1,
 pre_pay_day2=new.pre_pay_day2,pre_pay_perc2=new.pre_pay_perc2,
 pre_pay_day3=new.pre_pay_day3,pre_pay_perc3=new.pre_pay_perc3,
 type_peni=new.type_peni,count_peni=new.count_peni, flag_budjet=new.flag_budjet,
 phone=new.phone,flag_hlosts=new.flag_hlosts,flag_key=new.flag_key,
 id_section=new.id_section,id_fld_industr=new.id_fld_industr,id_grp_industr=new.id_grp_industr,
id_depart=new.id_depart,
for_undef=new.for_undef,addr_main=new.addr_main,addr_tax=new.addr_tax, addr_local=new.addr_local,
 flag_bank_day=new.flag_bank_day , flag_del2kr = new.flag_del2kr,
 tr_doc_num = new.tr_doc_num,tr_doc_date=new.tr_doc_date,tr_year_price=new.tr_year_price,tr_doc_type = new.tr_doc_type,tr_doc_period = new.tr_doc_period,
 doc_num_tend = new.doc_num_tend,doc_dat_tend=new.doc_dat_tend,flag_ed=new.flag_ed,flag_jur=new.flag_jur, filial_num = new.filial_num, 
 fl_cabinet = new.fl_cabinet,  date_digital = new.date_digital
 where id=new.id and id_client=new.id_client and mmgg_b=mg and mmgg_e is null;

else 

update clm_statecl_h set mmgg_e=mg where id=new.id and id_client=new.id_client and mmgg_e is null;

end if;
--isnew=0;
end loop;

for stath in select * from clm_statecl_h 
  where id_client=new.id_client and id=new.id and mmgg_b=mg  loop
   isnew=0;
end loop;

if isnew=1 then
raise notice 'ins- %',new.id_client;
insert into clm_statecl_h ( id,id_client,tax_num,flag_taxpay,filial_num,   
     licens_num,okpo_num, doc_num,doc_dat,doc_ground, 
     id_budjet,id_kwed,id_taxprop,id_position,id_kur,flag_reactive,dt_end_rent,flag_budjet, 
     period_indicat,dt_indicat,month_indicat,dt_start,day_pay_bill,type_pay,month_control, 
     pre_pay_grn,pre_pay_day1,pre_pay_perc1,pre_pay_day2,pre_pay_perc2,pre_pay_day3,pre_pay_perc3, 
     type_peni,count_peni,phone,flag_hlosts,
     id_section,id_fld_industr,id_grp_industr,id_depart,for_undef,addr_main,addr_tax,addr_local, flag_key,dt,
     flag_bank_day, flag_del2kr, tr_doc_num,tr_doc_date,tr_year_price,tr_doc_type,tr_doc_period,
      doc_num_tend,doc_dat_tend, flag_ed,flag_jur,mmgg_b, e_mail, fl_cabinet, date_digital ) 
      values (new.id,new.id_client,new.tax_num,new.flag_taxpay,new.filial_num,   
      new.licens_num,new.okpo_num,new.doc_num,new.doc_dat,new.doc_ground,  
     new.id_budjet,new.id_kwed,new.id_taxprop,new.id_position,new.id_kur,new.flag_reactive,new.dt_end_rent,new.flag_budjet, 
     new.period_indicat,new.dt_indicat,new.month_indicat,new.dt_start,new.day_pay_bill,new.type_pay,new.month_control, 
     new.pre_pay_grn,new.pre_pay_day1,new.pre_pay_perc1,new.pre_pay_day2,new.pre_pay_perc2,new.pre_pay_day3,new.pre_pay_perc3, 
     new.type_peni,new.count_peni,new.phone,new.flag_hlosts,
     new.id_section,new.id_fld_industr,new.id_grp_industr,new.id_depart,new.for_undef,new.addr_main,new.addr_tax,new.addr_local, new.flag_key, now(),
    new.flag_bank_day,new.flag_del2kr, new.tr_doc_num,new.tr_doc_date,new.tr_year_price,new.tr_doc_type,new.tr_doc_period,
new.doc_num_tend,new.doc_dat_tend,new.flag_ed,new.flag_jur,mg, new.e_mail, new.fl_cabinet, new.date_digital); 
end if;
 
Return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE  ;



create trigger statecl_upd   BEFORE update ON clm_statecl_tbl
    For Each Row Execute Procedure fun_statecl_upd();

create trigger statecl_ins
    BEFORE insert ON clm_statecl_tbl
    For Each Row Execute Procedure fun_statecl_upd();


drop trigger statecl_del on clm_statecl_tbl;

drop function fun_statecl_del();

 /*--------------------------------------------------------------*/
create function fun_statecl_del() returns opaque as'
Declare
stath record;
mg date;
begin
mg=fun_mmgg();
update clm_statecl_h set 
mmgg_e=mg
 where id=new.id and id_client=new.id_client and mmgg_e is null;

Return new;
end;
' Language 'plpgsql';

create trigger statecl_del
    BEFORE delete ON clm_statecl_tbl
    For Each Row Execute Procedure fun_statecl_del();

select crt_ttbl();
update syi_syswars_tmp set value_ident='01.01.2004' where id=7;
update clm_statecl_tbl set mmgg_b='2004-01-01' where mmgg_b is null;
update syi_syswars_tmp set value_ident='01.01.2009' where id=7;



update acd_demandlimit_tbl set month_limit= acd_demandlimit_tbl.month_limit- '10 year'::interval 
from 
( select l.* from acd_demandlimit_tbl l  join 
 (select id_doc,mmgg,month_limit,id_client,coalesce(id_area,0) as id_area,night_day,max(id) as id from acd_demandlimit_tbl l group by id_doc,mmgg,month_limit,id_client,coalesce(id_area,0),night_day) ml
 on l.id_doc=ml.id_doc and l.mmgg=ml.mmgg and l.month_limit=ml.month_limit and l.id_client=ml.id_client and coalesce(l.id_area,0)=coalesce(ml.id_area,0)and l.night_day=ml.night_day and 
 l.id<ml.id ) as u
where u.id=acd_demandlimit_tbl.id;

create unique index acd_demandlimit on acd_demandlimit_tbl (id_doc,mmgg,month_limit,id_client,id_area,night_day);

update acm_headdemandlimit_tbl set reg_date= acm_headdemandlimit_tbl.reg_date- '1 day'::interval 
from 
( select l.* from acm_headdemandlimit_tbl l  join 
 (select idk_document,reg_date,mmgg,id_client,max(id_doc) as id_doc from acm_headdemandlimit_tbl l group by idk_document,reg_date,mmgg,id_client) ml
 on l.mmgg=ml.mmgg and l.id_client=ml.id_client and l.reg_date=ml.reg_date and 
 l.id_doc<ml.id_doc ) as u
where u.id_doc=acm_headdemandlimit_tbl.id_doc;

--create unique index acm_headdemandlimit on acm_headdemandlimit_tbl (mmgg,id_client,reg_date);

DROP INDEX acm_headdemandlimit;

CREATE UNIQUE INDEX acm_headdemandlimit
  ON acm_headdemandlimit_tbl
  USING btree
  (mmgg, id_client, reg_date,idk_document);


update clm_client_tbl set kind_dep=a.a 
 from
    (select int8(value_ident)  as a from syi_sysvars_tbl 
     where ident='kod_res') as a
    where kind_dep is null and book=-1;

