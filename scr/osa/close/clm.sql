

create sequence sys_month_seq increment 30 minvalue 12345 start 12345;
create table sys_month_tbl 
( id          int default nextval('sys_month_seq'),  
  mmgg        date,
  hash_cod    int,
  user_close varchar (30),
  user_open  varchar (30),
  dt_close   timestamp,
  dt_open    timestamp,
 reason_open varchar (254),
  primary key (mmgg,dt_close)

);

insert into sys_month_tbl (mmgg,hash_cod,dt_close) 
 select distinct mmgg, to_number(substr(ltrim(rtrim(to_char(timetz_hash(dt::time),'999999999999999'))),1,8),'99999999')
 ,dt from acm_saldo_tbl where mmgg<='2005-11-01' and dt is not null;


delete from   acd_indication_tbl where id_doc in 
  (select i.id_doc from acd_indication_tbl i 
      left join acm_headindication_tbl h on i.id_doc=h.id_doc 
     where h.id_doc is null)  and flock <>1;  


-- ----------------------------------------------------------------
-- closemonth.sql - 
-- ----------------------------------------------------- 04.01.2003 9:20

drop function clm();
create function clm () returns boolean  as '
declare 
  befmon date;
  nextmon date;
  pr_saldo record;
  sbill record;
  spay record;
  sal record;
  fl_ins int;
  ddd date;
  ddd1 date;
  count_sal record;
  nam_error record;
  maybe_close record;
  monclose date; 
  monclnext date; 
  montime timestamp;
  rec_pref record;
flag_chtax varchar;
  st1 text;
  st2 text;
  ret_check boolean;
  pr boolean;
  pri int;
begin

monclose=fun_mmgg(1);
raise notice ''monclose %'',monclose;
delete from   acd_indication_tbl where id_doc in 
  (select i.id_doc from acd_indication_tbl i 
      left join acm_headindication_tbl h on i.id_doc=h.id_doc 
     where h.id_doc is null);  

 select into flag_chtax value_ident from syi_sysvars_tbl where ident=''flag_chtax'';
  if flag_chtax is null or flag_chtax=''1'' then
     



    select into maybe_close value_ident from syi_sysvars_tbl where ident=''Transit'';
    if not found then
    ret_check=acm_CheckTaxOnClose(monclose);
    select into  maybe_close id_error from sys_error_tbl where ident=''notax''; 
    if found then
     if maybe_close.id_error!=0 then 
      select into nam_error id,name from syi_error_tbl where id=maybe_close.id_error;
      if found then 
       raise exception ''%'',nam_error.name;
       return false;
      else 
         raise exception ''Error close Month'';    
	 return false;
      end if; 
     end if;
    end if;  
   end if;
  end if;


ALTER TABLE acm_bill_tbl            DISABLE TRIGGER user;
ALTER TABLE acm_tax_tbl             DISABLE TRIGGER user;
ALTER TABLE acm_taxcorrection_tbl   DISABLE TRIGGER user;
ALTER TABLE acm_billtax_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_headindication_tbl  DISABLE TRIGGER user;
ALTER TABLE acd_indication_tbl      DISABLE TRIGGER user;
ALTER TABLE acm_headpay_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_pay_tbl             DISABLE TRIGGER user;
ALTER TABLE acm_saldo_tbl           DISABLE TRIGGER user;
ALTER TABLE acm_billpay_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_taxadvcor_tbl       DISABLE TRIGGER user;
ALTER TABLE acm_saldoakt_tbl        DISABLE TRIGGER user;
ALTER TABLE acd_demandlimit_tbl     DISABLE TRIGGER user;
ALTER TABLE acm_headdemandlimit_tbl DISABLE TRIGGER user;


update acm_saldo_tbl set kt_val=0, kt_valtax=0,dt_val=0, dt_valtax=0 
        where  mmgg=monclose;

raise notice ''insert saldo 1'';

insert into acm_saldo_tbl (dt,id_client,id_pref,mmgg)
     select distinct now(),coalesce(pp.id_client,bb.id_client) as id_client,
           coalesce(pp.id_pref,bb.id_pref) as id_pref, monclose as mmgg             
     from 
       (select distinct b.id_client,b.id_pref,monclose  as mmgg
             from acm_bill_tbl as b 
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclose and 
                s1.id_client=b.id_client and s1.id_pref=b.id_pref
             )
            where s1.id is null
       ) as bb 
       full join 
        (select p.id_client,p.id_pref,monclose as mmgg
             from acm_pay_tbl as p
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclose and 
                s1.id_client=p.id_client and s1.id_pref=p.id_pref
             )
            where s1.id is null
       ) as pp
      on (pp.id_client=bb.id_client and bb.id_pref=pp.id_pref
           and bb.mmgg=pp.mmgg);

raise notice ''update saldo dt'';

update acm_saldo_tbl set dt_val=coalesce(cnt.dt_val,0),
                         dt_valtax=coalesce(cnt.dt_valtax,0)
       from 
          (select d.id_client as id_client,
           d.id_pref as id_pref ,
           d.mmgg as mmgg,
           sum(d.value) as dt_val,sum(d.value_tax) as dt_valtax
           from acm_bill_tbl as d 
             where d.mmgg=monclose
           group by d.id_client,d.id_pref ,d.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclose; 

raise notice ''update saldo kt'';

update acm_saldo_tbl set  kt_val=coalesce(cnt.kt_val,0),
                         kt_valtax=coalesce(cnt.kt_valtax,0)
       from 
          (select  k.id_client as id_client,
           k.id_pref as id_pref ,
           k.mmgg as mmgg,
           sum(k.value) as kt_val, sum(k.value_tax) as kt_valtax
           from  acm_pay_tbl as k 
            where k.mmgg=monclose
           group by k.id_client,k.id_pref,k.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclose; 

raise notice ''month saldo calc'';

monclnext=monclose+interval ''1 month'' ; 
update acm_saldo_tbl set 
          e_val=coalesce(b_val,0)+coalesce(dt_val,0)-coalesce(kt_val,0), 
          e_valtax=coalesce(b_valtax,0)+coalesce(dt_valtax,0)-coalesce(kt_valtax,0) 
        where  mmgg=monclose;

raise notice ''delete next month saldo'';

delete from acm_saldo_tbl 
        where mmgg=monclnext;

raise notice ''next month saldo calc'';

insert into acm_saldo_tbl (dt,id_client,id_pref,b_val,b_valtax,mmgg) 
     select distinct now(),id_client,id_pref,e_val,e_valtax,monclnext
     from acm_saldo_tbl where mmgg=monclose; 

raise notice ''insert saldo 2'';

insert into acm_saldo_tbl (dt,id_client,id_pref,mmgg)
     select distinct now(),coalesce(pp.id_client,bb.id_client) as id_client,
           coalesce(pp.id_pref,bb.id_pref) as id_pref, monclnext as mmgg             
     from 
       (select distinct b.id_client,b.id_pref,monclnext  as mmgg
             from acm_bill_tbl as b 
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclnext and 
                s1.id_client=b.id_client and s1.id_pref=b.id_pref
             )
            where s1.id is null
       ) as bb 
       full join 
        (select p.id_client,p.id_pref,monclnext as mmgg
             from acm_pay_tbl as p
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclnext and 
                s1.id_client=p.id_client and s1.id_pref=p.id_pref
             )
            where s1.id is null
       ) as pp
      on (pp.id_client=bb.id_client and bb.id_pref=pp.id_pref
           and bb.mmgg=pp.mmgg);

raise notice ''update saldo dt next '';     

update acm_saldo_tbl set dt_val=coalesce(cnt.dt_val,0),
                         dt_valtax=coalesce(cnt.dt_valtax,0)
       from 
          (select d.id_client as id_client,
           d.id_pref as id_pref ,
           d.mmgg as mmgg,
           sum(d.value) as dt_val,sum(d.value_tax) as dt_valtax
           from acm_bill_tbl as d 
             where d.mmgg=monclnext
           group by d.id_client,d.id_pref ,d.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclnext; 

raise notice ''update saldo kt next'';

update acm_saldo_tbl set  kt_val=coalesce(cnt.kt_val,0),
                         kt_valtax=coalesce(cnt.kt_valtax,0)
       from 
          (select  k.id_client as id_client,
           k.id_pref as id_pref ,
           k.mmgg as mmgg,
           sum(k.value) as kt_val, sum(k.value_tax) as kt_valtax
           from  acm_pay_tbl as k 
            where k.mmgg=monclnext
           group by k.id_client,k.id_pref,k.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclnext;
raise notice ''on next month saldo calc'';

update acm_saldo_tbl set 
          e_val=coalesce(b_val,0)+coalesce(dt_val,0)-coalesce(kt_val,0), 
          e_valtax=coalesce(b_valtax,0)+coalesce(dt_valtax,0)-coalesce(kt_valtax,0) 
                where  mmgg=monclnext;


 pr=calc_saldoakt(monclose);                    

 pr=seb_all(2,monclose);

/*
 for rec_pref in select * from aci_pref_tbl where in_acc=1 loop
  raise notice ''calc rep_nds2011 - %'',rec_pref.id;
  pri=rep_nds2011_fun(monclose,rec_pref.id,false);
 end loop;
*/

 update syi_sysvars_tbl set value_ident=0 where ident=''trigs_pay'';       
  raise notice ''upd'';
 
 update acm_saldo_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_saldoakt_tbl set flock=1 where (flock=0 or flock is NULL)  and mmgg<=monclose;                                                                     

 update acm_pay_tbl set flock=1 where (flock=0 or flock is NULL) and  mmgg<=monclose;   

 update acm_headpay_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_bill_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_billpay_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;  

 update acd_pwr_demand_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_pnt_tarif set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_met_kndzn_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_point_branch_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_billsum_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   


 update acm_bill_del set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_pwr_demand_del set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_pnt_tarif_del set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_met_kndzn_del set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_point_branch_del set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_billsum_del set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_billpay_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_headsum_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_tax_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_tax_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_taxcorrection_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;      
 update acd_taxcorrection_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 
 update rep_nds2011_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;      
 update seb_obr_all_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;      
 update seb_obrs_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update seb_renthist_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;      
 
 update acm_headindication_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_indication_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acm_headdemandlimit_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   
 update acd_demandlimit_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<=monclose;   

insert into sys_month_tbl (mmgg,hash_cod,dt_close) 
 values (monclose,
  to_number(substr(ltrim(rtrim(to_char(timetz_hash(now()::time),''999999999999999''))),1,8),''99999999'')
,now()) ;

update syi_sysvars_tmp set value_ident=to_char(monclose+interval ''1 month'' ,''dd.mm.yyyy'')
 where ident=''mmgg'';

update syi_sysvars_tbl set value_ident=to_char(monclose+interval ''1 month'' ,''dd.mm.yyyy'')
 where ident=''mmgg'';


ALTER TABLE acm_bill_tbl            ENABLE TRIGGER user;
ALTER TABLE acm_tax_tbl             ENABLE TRIGGER user;
ALTER TABLE acm_taxcorrection_tbl   ENABLE TRIGGER user;
ALTER TABLE acm_billtax_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_headindication_tbl  ENABLE TRIGGER user;
ALTER TABLE acd_indication_tbl      ENABLE TRIGGER user;
ALTER TABLE acm_headpay_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_pay_tbl             ENABLE TRIGGER user;
ALTER TABLE acm_saldo_tbl           ENABLE TRIGGER user;
ALTER TABLE acm_billpay_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_taxadvcor_tbl       ENABLE TRIGGER user;
ALTER TABLE acm_saldoakt_tbl        ENABLE TRIGGER user;
ALTER TABLE acd_demandlimit_tbl     ENABLE TRIGGER user;
ALTER TABLE acm_headdemandlimit_tbl ENABLE TRIGGER user;



return true;
end;



' LANGUAGE 'plpgsql';




drop function clm2();
drop function clmd2();


drop function clopcur();
create function clopcur 
() returns boolean  as '
declare 
 mon date;
e boolean;
count_trigs int;
begin
mon=fun_mmgg(1);
raise notice ''open _month % '',mon;


 e=clopm(mon,null);

return true;
end;
' LANGUAGE 'plpgsql';




drop function clopm(date);
drop function clopm(date,int);


create or replace function clopm(date,int,text) returns boolean  as '
declare
  mon alias for $1;
  hcode alias for $2;
  reason alias for $3;
  befmon date;
  pr boolean;
  nextmon date;
  pr_saldo record;
  sbill record;
  spay record;
  sal record;
  count_sal record;
  nam_error record;
  monclose date; 
  monclnext date; 
  sysm record;
  syserr text;

st1 text;
st2 text;
begin

 monclose=mon;
 select into sysm * from sys_month_tbl where id=
 (select max(id) from sys_month_tbl where mmgg=monclose);
 if found then
   raise notice ''%,%'',sysm.mmgg,sysm.hash_cod;
  if sysm.hash_cod<>hcode then
   select into syserr  name from syi_error_tbl where id=90;
   syserr='' ''||coalesce(syserr,''Error code for open month!!'');
    raise exception ''%'',syserr ;

  end if;
 end if;
 raise notice ''monclose %'',monclose;

ALTER TABLE acm_bill_tbl            DISABLE TRIGGER user;
ALTER TABLE acm_tax_tbl             DISABLE TRIGGER user;
ALTER TABLE acm_taxcorrection_tbl   DISABLE TRIGGER user;
ALTER TABLE acm_billtax_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_headindication_tbl  DISABLE TRIGGER user;
ALTER TABLE acd_indication_tbl      DISABLE TRIGGER user;
ALTER TABLE acm_headpay_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_pay_tbl             DISABLE TRIGGER user;
ALTER TABLE acm_saldo_tbl           DISABLE TRIGGER user;
ALTER TABLE acm_billpay_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_taxadvcor_tbl       DISABLE TRIGGER user;
ALTER TABLE acm_saldoakt_tbl        DISABLE TRIGGER user;
ALTER TABLE acd_demandlimit_tbl     DISABLE TRIGGER user;
ALTER TABLE acm_headdemandlimit_tbl DISABLE TRIGGER user;



 update sys_month_tbl set dt_open=now(),reason_open=reason where mmgg=monclose 
 and dt_open is null;

 update acm_headpay_tbl set flock=0 where mmgg>=monclose and flock=1;
 update acm_pay_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acm_billpay_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acm_bill_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acd_pwr_demand_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acd_pnt_tarif set flock=0 where  mmgg>=monclose and flock=1;
 update acd_met_kndzn_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acd_point_branch_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acd_billsum_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acm_bill_del set flock=0 where mmgg>=monclose and flock=1;
 update acd_pwr_demand_del set flock=0 where mmgg>=monclose and flock=1;
 update acd_pnt_tarif_del set flock=0 where  mmgg>=monclose and flock=1;
 update acd_met_kndzn_del set flock=0 where  mmgg>=monclose and flock=1;
 update acd_point_branch_del set flock=0 where  mmgg>=monclose and flock=1;
 update acd_billsum_del set flock=0 where  mmgg>=monclose and flock=1;
 update acm_billpay_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acm_headsum_tbl set flock=0 where  mmgg>=monclose and flock=1;

 update acm_tax_tbl set flock=0 where   mmgg>=monclose and flock=1;   
 update acd_tax_tbl set flock=0 where   mmgg>=monclose and flock=1;  
 update acm_taxcorrection_tbl set flock=0 where   mmgg>=monclose and flock=1;      
 update acd_taxcorrection_tbl set flock=0 where   mmgg>=monclose and flock=1;   
 update seb_obr_all_tbl set flock=0 where    mmgg>=monclose and flock=1;         
 update rep_nds2011_tbl set flock=0 where    mmgg>=monclose and flock=1;          
 update seb_obrs_tbl set flock=0 where   mmgg>=monclose and flock=1;      
 update seb_renthist_tbl set flock=0 where    mmgg>=monclose and flock=1;         
 update acm_saldoakt_tbl set flock=0 where   mmgg>=monclose and flock=1;   

 update acm_headindication_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acd_indication_tbl set flock=0 where mmgg>=monclose and flock=1; 
 update acm_headdemandlimit_tbl set flock=0 where  mmgg>=monclose and flock=1;
 update acd_demandlimit_tbl set flock=0 where mmgg>=monclose and flock=1; 


raise notice ''mmgg %'',monclose;


ALTER TABLE acm_bill_tbl            ENABLE TRIGGER user;
ALTER TABLE acm_tax_tbl             ENABLE TRIGGER user;
ALTER TABLE acm_taxcorrection_tbl   ENABLE TRIGGER user;
ALTER TABLE acm_billtax_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_headindication_tbl  ENABLE TRIGGER user;
ALTER TABLE acd_indication_tbl      ENABLE TRIGGER user;
ALTER TABLE acm_headpay_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_pay_tbl             ENABLE TRIGGER user;
ALTER TABLE acm_saldo_tbl           ENABLE TRIGGER user;
ALTER TABLE acm_billpay_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_taxadvcor_tbl       ENABLE TRIGGER user;
ALTER TABLE acm_saldoakt_tbl        ENABLE TRIGGER user;
ALTER TABLE acd_demandlimit_tbl     ENABLE TRIGGER user;
ALTER TABLE acm_headdemandlimit_tbl ENABLE TRIGGER user;



update syi_sysvars_tbl set value_ident=to_char(monclose ,''dd.mm.yyyy'')  where ident=''mmgg'';
update syi_sysvars_tmp set value_ident=to_char(monclose ,''dd.mm.yyyy'')  where ident=''mmgg'';


return true;
end;



' LANGUAGE 'plpgsql';




drop function close();
-- OSA for close open data during settings news
create function close() returns boolean  as '
declare 
  befmon date;
  nextmon date;
  pr_saldo record;
  sbill record;
  spay record;
  sal record;
  fl_ins int;
  ddd date;
  ddd1 date;
  count_sal record;
  nam_error record;
  monclose date; 
  monclnext date; 
  montime timestamp;
  pr boolean;
  rec_pref record;
  pri int;
st1 text;
st2 text;
begin




ALTER TABLE acm_bill_tbl            DISABLE TRIGGER user;
ALTER TABLE acm_tax_tbl             DISABLE TRIGGER user;
ALTER TABLE acm_taxcorrection_tbl   DISABLE TRIGGER user;
ALTER TABLE acm_billtax_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_headindication_tbl  DISABLE TRIGGER user;
ALTER TABLE acd_indication_tbl      DISABLE TRIGGER user;
ALTER TABLE acm_headpay_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_pay_tbl             DISABLE TRIGGER user;
ALTER TABLE acm_saldo_tbl           DISABLE TRIGGER user;
ALTER TABLE acm_billpay_tbl         DISABLE TRIGGER user;
ALTER TABLE acm_taxadvcor_tbl       DISABLE TRIGGER user;
ALTER TABLE acm_saldoakt_tbl        DISABLE TRIGGER user;
ALTER TABLE acd_demandlimit_tbl     DISABLE TRIGGER user;
ALTER TABLE acm_headdemandlimit_tbl DISABLE TRIGGER user;


monclose=fun_mmgg(1);
raise notice ''check_close %'',monclose;

update acm_saldo_tbl set kt_val=0, kt_valtax=0,dt_val=0, dt_valtax=0 
        where  mmgg=monclose;

raise notice ''insert saldo 1'';

insert into acm_saldo_tbl (dt,id_client,id_pref,mmgg)
     select distinct now(),coalesce(pp.id_client,bb.id_client) as id_client,
           coalesce(pp.id_pref,bb.id_pref) as id_pref, monclose as mmgg             
     from 
       (select distinct b.id_client,b.id_pref,monclose  as mmgg
             from acm_bill_tbl as b 
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclose and 
                s1.id_client=b.id_client and s1.id_pref=b.id_pref
             )
            where s1.id is null
       ) as bb 
       full join 
        (select p.id_client,p.id_pref,monclose as mmgg
             from acm_pay_tbl as p
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclose and 
                s1.id_client=p.id_client and s1.id_pref=p.id_pref
             )
            where s1.id is null
       ) as pp
      on (pp.id_client=bb.id_client and bb.id_pref=pp.id_pref
           and bb.mmgg=pp.mmgg);

raise notice ''update saldo dt'';

update acm_saldo_tbl set dt_val=coalesce(cnt.dt_val,0),
                         dt_valtax=coalesce(cnt.dt_valtax,0)
       from 
          (select d.id_client as id_client,
           d.id_pref as id_pref ,
           d.mmgg as mmgg,
           sum(d.value) as dt_val,sum(d.value_tax) as dt_valtax
           from acm_bill_tbl as d 
             where d.mmgg=monclose
           group by d.id_client,d.id_pref ,d.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclose; 

raise notice ''update saldo kt'';

update acm_saldo_tbl set  kt_val=coalesce(cnt.kt_val,0),
                         kt_valtax=coalesce(cnt.kt_valtax,0)
       from 
          (select  k.id_client as id_client,
           k.id_pref as id_pref ,
           k.mmgg as mmgg,
           sum(k.value) as kt_val, sum(k.value_tax) as kt_valtax
           from  acm_pay_tbl as k 
            where k.mmgg=monclose
           group by k.id_client,k.id_pref,k.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclose; 

raise notice ''month saldo calc'';

monclnext=monclose+interval ''1 month'' ; 
update acm_saldo_tbl set 
          e_val=coalesce(b_val,0)+coalesce(dt_val,0)-coalesce(kt_val,0), 
          e_valtax=coalesce(b_valtax,0)+coalesce(dt_valtax,0)-coalesce(kt_valtax,0) 
        where  mmgg=monclose;

raise notice ''delete next month saldo'';

delete from acm_saldo_tbl 
        where mmgg=monclnext;

raise notice ''next month saldo calc'';

insert into acm_saldo_tbl (dt,id_client,id_pref,b_val,b_valtax,mmgg) 
     select distinct now(),id_client,id_pref,e_val,e_valtax,monclnext
     from acm_saldo_tbl where mmgg=monclose; 

raise notice ''insert saldo 2'';

insert into acm_saldo_tbl (dt,id_client,id_pref,mmgg)
     select distinct now(),coalesce(pp.id_client,bb.id_client) as id_client,
           coalesce(pp.id_pref,bb.id_pref) as id_pref, monclnext as mmgg             
     from 
       (select distinct b.id_client,b.id_pref,monclnext  as mmgg
             from acm_bill_tbl as b 
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclnext and 
                s1.id_client=b.id_client and s1.id_pref=b.id_pref
             )
            where s1.id is null
       ) as bb 
       full join 
        (select p.id_client,p.id_pref,monclnext as mmgg
             from acm_pay_tbl as p
               left join acm_saldo_tbl  s1 
            on (s1.mmgg=monclnext and 
                s1.id_client=p.id_client and s1.id_pref=p.id_pref
             )
            where s1.id is null
       ) as pp
      on (pp.id_client=bb.id_client and bb.id_pref=pp.id_pref
           and bb.mmgg=pp.mmgg);

raise notice ''update saldo dt next '';     

update acm_saldo_tbl set dt_val=coalesce(cnt.dt_val,0),
                         dt_valtax=coalesce(cnt.dt_valtax,0)
       from 
          (select d.id_client as id_client,
           d.id_pref as id_pref ,
           d.mmgg as mmgg,
           sum(d.value) as dt_val,sum(d.value_tax) as dt_valtax
           from acm_bill_tbl as d 
             where d.mmgg=monclnext
           group by d.id_client,d.id_pref ,d.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclnext; 

raise notice ''update saldo kt next'';

update acm_saldo_tbl set  kt_val=coalesce(cnt.kt_val,0),
                         kt_valtax=coalesce(cnt.kt_valtax,0)
       from 
          (select  k.id_client as id_client,
           k.id_pref as id_pref ,
           k.mmgg as mmgg,
           sum(k.value) as kt_val, sum(k.value_tax) as kt_valtax
           from  acm_pay_tbl as k 
            where k.mmgg=monclnext
           group by k.id_client,k.id_pref,k.mmgg ) as cnt
       where   cnt.id_client=acm_saldo_tbl.id_client and
         cnt.id_pref=acm_saldo_tbl.id_pref and
         cnt.mmgg=acm_saldo_tbl.mmgg and acm_saldo_tbl.mmgg=monclnext;
raise notice ''on next month saldo calc'';

update acm_saldo_tbl set 
          e_val=coalesce(b_val,0)+coalesce(dt_val,0)-coalesce(kt_val,0), 
          e_valtax=coalesce(b_valtax,0)+coalesce(dt_valtax,0)-coalesce(kt_valtax,0) 
                where  mmgg=monclnext;

                                                                      
                    
                                                                  
 raise notice ''upd'';

 update syi_sysvars_tbl set value_ident=0 where ident=''trigs_pay'';       


pr=calc_saldoakt(monclose);                    


 pr=seb_all(2,monclose);
/*
 for rec_pref in select * from aci_pref_tbl where in_acc=1 loop
  raise notice ''calc rep_nds2011 - %'',rec_pref.id;
  pri=rep_nds2011_fun(monclose,rec_pref.id,false);
 end loop;
*/
 update syi_sysvars_tbl set value_ident=0 where ident=''trigs_pay'';       
  raise notice ''upd'';
 
 update acm_saldo_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_saldoakt_tbl set flock=1 where (flock=0 or flock is NULL)  and mmgg<monclose;                                                                     

 update acm_pay_tbl set flock=1 where (flock=0 or flock is NULL) and  mmgg<monclose;   

 update acm_headpay_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_bill_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_billpay_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;  

 update acd_pwr_demand_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_pnt_tarif set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_met_kndzn_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_point_branch_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_billsum_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   


 update acm_bill_del set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_pwr_demand_del set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_pnt_tarif_del set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_met_kndzn_del set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_point_branch_del set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_billsum_del set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_billpay_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_headsum_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_tax_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_tax_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_taxcorrection_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;      
 update acd_taxcorrection_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 
 update rep_nds2011_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;      
 update seb_obr_all_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;      
 update seb_obrs_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update seb_renthist_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;      
 
 update acm_headindication_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_indication_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acm_headdemandlimit_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   
 update acd_demandlimit_tbl set flock=1 where (flock=0 or flock is NULL) and mmgg<monclose;   



                    
raise notice ''mmgg %'',monclose;

ALTER TABLE acm_bill_tbl            ENABLE TRIGGER user;
ALTER TABLE acm_tax_tbl             ENABLE TRIGGER user;
ALTER TABLE acm_taxcorrection_tbl   ENABLE TRIGGER user;
ALTER TABLE acm_billtax_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_headindication_tbl  ENABLE TRIGGER user;
ALTER TABLE acd_indication_tbl      ENABLE TRIGGER user;
ALTER TABLE acm_headpay_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_pay_tbl             ENABLE TRIGGER user;
ALTER TABLE acm_saldo_tbl           ENABLE TRIGGER user;
ALTER TABLE acm_billpay_tbl         ENABLE TRIGGER user;
ALTER TABLE acm_taxadvcor_tbl       ENABLE TRIGGER user;
ALTER TABLE acm_saldoakt_tbl        ENABLE TRIGGER user;
ALTER TABLE acd_demandlimit_tbl     ENABLE TRIGGER user;
ALTER TABLE acm_headdemandlimit_tbl ENABLE TRIGGER user;

return true;
end;



' LANGUAGE 'plpgsql';




