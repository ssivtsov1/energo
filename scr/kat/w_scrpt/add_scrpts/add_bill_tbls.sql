drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
f int;
begin
f:=0;
if (select count(*) from pg_class where relname=''acd_clc_inf'')=0 then

create table acd_clc_inf(
  id_doc        int,
  dt            timestamp,
  dat_b		date,
  dat_e		date,
  id_p_doc      int,
  type_p_doc    varchar(10),
  summ		numeric(14,4),
  k_inf		numeric(14,8),
  sum_inf	numeric(14,2),
  ident1	varchar(10),
  flock		int default 0,
  mmgg		date default fun_mmgg(),
  primary key(id_doc,ident1,dat_b)
);
if (select count(*) from pg_class where relname=''acd_clc_inf_del'')=0 then
create table acd_clc_inf_del(
  id_doc        int,
  dt            timestamp,
  dat_b		date,
  dat_e		date,
  id_p_doc      int,
  type_p_doc    varchar(10),
  summ		numeric(14,4),
  k_inf		numeric(14,8),
  sum_inf	numeric(14,2),
  ident1	varchar(10),
  flock		int default 0,
  mmgg		date default fun_mmgg(),
  primary key(id_doc,ident1,dat_b)
);
end if;
f:=1;
end if;


if (select count(*) from pg_class where relname=''acd_calc_losts_tbl'')=0 then
create table acd_calc_losts_tbl(
     id_doc             int,
     dt                 timestamp,
     id_point		int,
     id_eqp		int,
     num		int,
     dat_b		date,
     dat_e		date,
     type_eqm		int,	
     id_type_eqp	int,
     sn_len		numeric(14,2),
     tt			int,
     tw			int,
     pxx_r0		numeric(14,4),
     pkz_x0		numeric(14,4),
     ixx		numeric,
     ukz_un		numeric,
     wp			int,
     wq			int,
     wp1		int,
     s_xx_addwp		int,
     s_kz_addwq		int,
     kind_energy	int,
     dw			int,
     flock		int default 0,
     mmgg		date default fun_mmgg(),
     primary key(id_doc,id_point,id_eqp,dat_b,kind_energy)
);
if (select count(*) from pg_class where relname=''acd_calc_losts_del'')=0 then
create table acd_calc_losts_del(
     id_doc             int,
     dt                 timestamp,
     id_point		int,
     id_eqp		int,
     num		int,
     dat_b		date,
     dat_e		date,
     type_eqm		int,	
     id_type_eqp	int,
     sn_len		numeric(14,2),
     tt			int,
     tw			int,
     pxx_r0		numeric(14,4),
     pkz_x0		numeric(14,4),
     ixx		numeric,
     ukz_un		numeric,
     wp			int,
     wq			int,
     wp1		int,
     s_xx_addwp		int,
     s_kz_addwq		int,
     kind_energy	int,
     dw			int,
     flock		int default 0,
     mmgg		date default fun_mmgg(),
     primary key(id_doc,id_point,id_eqp,dat_b,kind_energy)
);
end if;
f:=1;
end if;
if f>0 then
  Return true;
else 
  Return false;
end if;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();

drop trigger bill_del on acm_bill_tbl;
drop function fun_bill_del();

create function fun_bill_del() returns opaque as '
Declare 
pay record;
fl_ins int;
begin
 fl_ins:=1;
 if old.flock=1 then
   RAISE EXCEPTION ''CLOSED DATA'';
 end if;

 if (OLD.flag_transmis = 1) then 
    Raise EXCEPTION ''Счет уже вручен!'';
 end if;


   --- refresh saldo
   raise notice ''Start'';
  for pay in select id from acm_saldo_tbl where  
   id_client=old.id_client and id_pref=old.id_pref   and mmgg=old.mmgg
   loop
    fl_ins:=0;
  end loop;
  
  if fl_ins=1 then
    insert into acm_saldo_tbl(id_client,mmgg,id_pref) 
     values (old.id_client,old.mmgg,old.id_pref);
  end if;
   update acm_saldo_tbl 
     set dt_val=dt_val-old.value,
        dt_valtax=dt_valtax-old.value_tax,
	e_val=e_val-old.value,
	e_valtax=e_valtax-old.value_tax 
   where id_client=old.id_client and id_pref=old.id_pref  and mmgg=old.mmgg;
--  raise notice ''salend'';
    -- delete payments
    delete from acm_billpay_tbl where id_bill=old.id_doc;
    
    --delete lines
    delete from acm_pay_tbl where id_client=old.id_client 
      and id_bill=old.id_doc and id_headpay=(select id from acm_headpay_tbl 
                                where flag_priv and flag_type=3 and flock=0);
    delete from acd_difmetzone_tbl where id_doc=old.id_doc;
    delete from acm_tax_tbl where id_bill=old.id_doc;
    delete from acm_taxcorrection_tbl where id_bill=old.id_doc;

    insert into acd_clc_inf_del select * 
       from  acd_clc_inf where id_doc=old.id_doc;
    delete from acd_clc_inf where id_doc=old.id_doc;
                           /*
    insert into acd_kateg_del select * 
       from  acd_kateg_tbl where id_doc=old.id_doc;
    delete from acd_kateg_tbl where id_doc=old.id_doc;
                             */
    insert into acd_pnt_tarif_del select * 
       from  acd_pnt_tarif where id_doc=old.id_doc;
    delete from acd_pnt_tarif where id_doc=old.id_doc;

    insert into acd_met_kndzn_del select * 
       from  acd_met_kndzn_tbl where id_doc=old.id_doc;
    delete from acd_met_kndzn_tbl where id_doc=old.id_doc;

    insert into acd_calc_losts_del select * 
       from  acd_calc_losts_tbl where id_doc=old.id_doc;
    delete from acd_calc_losts_tbl where id_doc=old.id_doc;

    insert into acd_pwr_demand_del select * 
       from  acd_pwr_demand_tbl where id_doc=old.id_doc;
    delete from acd_pwr_demand_tbl where id_doc=old.id_doc;

    insert into acd_point_branch_del select * 
       from  acd_point_branch_tbl where id_doc=old.id_doc;
    delete from acd_point_branch_tbl where id_doc=old.id_doc;

    insert into acd_billsum_del select * 
       from  acd_billsum_tbl where id_doc=old.id_doc;
    delete from acd_billsum_tbl where id_doc=old.id_doc;

    insert into acd_summ_val_del select * 
       from  acd_summ_val where id_doc=old.id_doc;

   delete from acd_summ_val where id_doc=old.id_doc;

   if old.id_pref=520 then
    raise notice ''del 520  %'',old.id_doc;
    insert into acd_pwr_limit_over_del (id_doc ,  dt ,  id_area ,  night_day ,
       power_limit ,  power_fact ,   power_ower ,  power_trans ,  power_bill ,  tarif ,  sum_value ,
       dat_b ,  dat_e ,  mmgg ,  flock )
     select id_doc ,  dt ,  id_area ,  night_day ,
      power_limit ,  power_fact ,   power_ower ,  power_trans ,  power_bill ,  tarif ,  sum_value ,
      dat_b ,  dat_e ,  mmgg ,  flock 
      from  acd_pwr_limit_over_tbl where id_doc=old.id_doc;

    delete from acd_pwr_limit_over_tbl where id_doc=old.id_doc;
    insert into acd_pwr_limit_pnt_del  (id ,  id_doc ,  dt ,  
      id_area ,  id_point ,  demand ,  dat_b ,  dat_e,  mmgg ,  flock )
    select   id ,  id_doc ,  dt ,  
        id_area ,  id_point ,  demand ,  dat_b ,  dat_e,  mmgg ,  flock
     from  acd_pwr_limit_pnt_tbl where id_doc=old.id_doc;
     delete from acd_pwr_limit_pnt_tbl where id_doc=old.id_doc;
    end if;
  
  insert into acm_bill_del select * 
     from  acm_bill_tbl where id_doc=old.id_doc;
   
    Return old;
end;'
 Language 'plpgsql';

create trigger bill_del
    BEFORE Delete ON acm_bill_tbl
    For Each Row Execute Procedure fun_bill_del();

alter table acd_met_kndzn_tbl add column id_ind int;
alter table acd_met_kndzn_del add column id_ind int;
alter table acd_met_kndzn_tbl add column calc_demand_nocnt int;
alter table acd_met_kndzn_del add column calc_demand_nocnt int;
alter table acd_met_kndzn_tbl add column p_w                numeric(10,3);
alter table acd_met_kndzn_del add column p_w                numeric(10,3);


alter table acm_bill_tbl add column dat_b date;
alter table acm_bill_del add column dat_b date;
alter table acm_bill_tbl add column dat_e date;
alter table acm_bill_del add column dat_e date;
alter table acd_billsum_tbl add column k_corr numeric(4,2);
alter table acd_billsum_del add column k_corr numeric(4,2);
alter table acd_billsum_tbl add column cdemand_val int;
alter table acd_billsum_del add column cdemand_val int;

alter table acd_met_kndzn_tbl add column meter_demand int;
alter table acd_met_kndzn_tbl add column calc_demand_cnt int;
alter table acd_met_kndzn_tbl add column comment_cnt text;
alter table acd_met_kndzn_tbl add column calc_demand_w int;
alter table acd_met_kndzn_tbl add column comment_w text;
alter table acd_met_kndzn_tbl add column k_ts int;
alter table acd_met_kndzn_tbl add column i_ts int;
alter table acd_met_kndzn_tbl add column hand_losts int;
alter table acd_met_kndzn_del add column meter_demand int;
alter table acd_met_kndzn_del add column calc_demand_cnt int;
alter table acd_met_kndzn_del add column comment_cnt text;
alter table acd_met_kndzn_del add column calc_demand_w int;
alter table acd_met_kndzn_del add column comment_w text;
alter table acd_met_kndzn_del add column k_ts int;
alter table acd_met_kndzn_del add column i_ts int;
alter table acd_met_kndzn_del add column hand_losts int;
alter table acd_point_branch_tbl add column k_corr numeric(4,2);
alter table acd_point_branch_del add column k_corr numeric(4,2);

-----------!!!!!!!!!!!!!!!
'upd dat acm_bill_tbl';
select del_notrigger('acm_bill_tbl','update acm_bill_tbl set dat_b=a.dat_b,dat_e=b.dat_e from 
  (select min(dat_b) as dat_b,id_doc from acd_pwr_demand_tbl 
    group by id_doc) as a inner join 
  (select max(dat_e) as dat_e,id_doc from acd_pwr_demand_tbl 
    group by id_doc) as b on (a.id_doc=b.id_doc) 
  where acm_bill_tbl.id_doc=a.id_doc and (acm_bill_tbl.dat_b is null 
   or acm_bill_tbl.dat_e is null)');

update syi_sysvars_tbl set value_ident='1' where ident='trigs_pay';
-----------!!!!!!!!!!!!!!!
alter table acm_saldo_tbl add column dat_sal date;


select altr_colmn('acd_billsum_tbl','tg_fi','numeric(14,2)');
select altr_colmn('acd_billsum_del','tg_fi','numeric(14,2)');


--insert into dci_document_tbl(id,name,idk_document,ident) 
-- values(360,'О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫',300,'nul_poks');
--update dci_document_tbl set idk_document=null 
-- where id in (320,330,340,350,351,352,354);

alter table acm_bill_tbl add column demand_val integer;
alter table acm_bill_del add column demand_val integer;
alter table acm_bill_tbl add column flag_priv  boolean;
alter table acm_bill_del add column flag_priv  boolean; 
/*
select del_notrigger('acm_bill_tbl'
 ,'update acm_bill_tbl set demand_val=(select sum(demand_val) 
    from acd_billsum_tbl as a where a.id_doc=acm_bill_tbl.id_doc) 
   where acm_bill_tbl.demand_val is null');
  */
select del_notrigger('acm_bill_tbl'
 ,'update acm_bill_tbl set flag_priv=flag from (select id
  ,case when book=-1 then false else true end as flag from clm_client_tbl) as a 
  where a.id=acm_bill_tbl.id_client and acm_bill_tbl.flag_priv is null');


drop trigger bill_del_aft on acm_bill_tbl;
drop function fun_bill_del_aft();
 /*--------------------------------------------------------------*/
create function fun_bill_del_aft() returns opaque as '
Declare 
psection int;
res boolean;
begin

   res=repayment(old.id_client,old.id_pref);

    select into psection id_section from clm_statecl_h 
  where id_client=old.id_client and
  mmgg_b=(select max(mmgg_b)  from clm_statecl_h as scl2 
           where scl2.id_client = old.id_client and scl2.mmgg_b <= date_trunc(''month'', old.mmgg )
         );

if psection=201 or psection=202 or psection=204 then

   if OLD.id_pref = 10 and OLD.idk_doc in (200,204) then 
     if old.mmgg>=''2013-01-01'' then
      raise notice ''fun_bill_del_aft() perform 2-tka'';
      perform crt_dem2krmmgg_area(OLD.id_client,OLD.mmgg); 
     else
      if old.mmgg>=''2005-01-01'' then
         perform crt_dem2krmmgg(OLD.id_client,OLD.mmgg); 
      end if;
     end if;

   end if;
end if;
return old;
end;'
 Language 'plpgsql';

create trigger bill_del_aft
    after Delete ON acm_bill_tbl
    For Each Row Execute Procedure fun_bill_del_aft();
