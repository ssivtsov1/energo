
--set client_encoding='win';         
create  table acd_summ_val(
  id_doc        int,
  dt            timestamp,
  id_client 	int,
  dat		date,
  ident		varchar(3),
  summ		numeric(14,4),
  id_p_doc	int,
  ident1	varchar(10)
);


create  table acd_summ_val_del(
  id_doc        int,
  dt            timestamp,
  id_client 	int,
  dat		date,
  ident		varchar(3),
  summ		numeric(14,4),
  id_p_doc	int,
  ident1	varchar(10)
);

alter table acd_summ_val add column dat_transmiss date;
alter table acd_summ_val_del add column dat_transmiss date;

alter table acd_summ_val add column id_pref int;
alter table acd_summ_val_del add column id_pref int;

alter table acd_summ_val add column upd int;
alter table acd_summ_val_del add column upd int;



alter table acd_clc_inf add column id_p_doc int;
alter table acd_clc_inf drop column type_p_doc ;
alter table acd_clc_inf add column type_p_doc varchar(10);
alter table acd_clc_inf add column koeff numeric(10,5);
alter table acd_clc_inf add column calc_day integer;
alter table acd_clc_inf add column id_pref int;

alter table acd_clc_inf_del add column id_p_doc int;
alter table acd_clc_inf_del drop column type_p_doc ;
alter table acd_clc_inf_del add column type_p_doc varchar(10);
alter table acd_clc_inf_del add column koeff numeric(10,5);
alter table acd_clc_inf_del add column calc_day integer;
alter table acd_clc_inf_del add column id_pref int;


delete from cmi_tax_tbl where ident='nbu';

INSERT INTO "cmi_tax_tbl" ("id", "date_inst", "name", "short_name", "idk_tax", "ident") 
       VALUES (3, NULL, 'îâõ', 'îâõ', NULL, 'nbu');


function_all_calc_peninfl;
create or replace function all_calc_peninfl() returns boolean as
$BODY$
declare 
m_g date;
client record;
nr numeric;
begin

select into m_g (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||'-'
    ||substr(value_ident,1,2))::date from syi_sysvars_tmp where ident='mmgg';
for  client in select c.id,c.code, d.type_peni from clm_client_tbl c 
      left join (select * from clm_statecl_tbl where type_peni = 1 ) as d
      on d.id_client=c.id  where d.type_peni=1 order by c.code loop

 raise notice '___________ code _________ = %',client.code;
 raise notice '___________________________ ';
 nr=calc_infl(client.id,m_g); 
 nr=calc_pena(client.id,m_g); 
end loop;
return true;
end

$BODY$
 language 'plpgsql';


function_calc_infl;

--drop function calc_infl(int,date);
create or replace function calc_infl(int,date) Returns numeric As 
$BODY$
Declare
idcl Alias for $1;
mg1 Alias for $2;
mg date;
kinf numeric;
r record; 
s numeric;
mfo_s int;
acc_s numeric;
iddc int;
kdoc int;
m_g date;
reg_dt date;
recact record;
doc_check int;
monthday int;
bill_3 record;
f_pay record;
parclient record;
begin
delete from act_summ_val; -- where id_client=idcl;
delete from act_clc_inf;-- where id_client=idcl;
s:=0;

select into parclient id_client,count_peni,type_peni,dt_indicat,day_pay_bill 
           from clm_statecl_tbl 
           where id_client=idcl;

if not found then
 raise notice 'nema------------ %',idcl;
 return 0;
end if;



select into m_g (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||'-'
    ||substr(value_ident,1,2))::date from syi_sysvars_tmp where ident='mmgg';

if mg1 is null then
mg=m_g;
end if;

if mg1>(m_g) then
 insert into act_res_notice values('not calc infl for future or present period');
raise notice 'not calc peni for future or present period - %',mg1;
Return null;
end if;

if  parclient.type_peni<>1 or parclient.count_peni<=0 or parclient.day_pay_bill<0 then
delete from acm_bill_tbl where id_client=idcl and mmgg=mg1  and id_pref=(
 select id from aci_pref_tbl where ident='inf');
  Raise Notice 'No calc for some client % %',parclient.id_client,mg1;
  insert into act_res_notice values('No calc for some client');
Return null;
end if;



if mg1=(m_g) then
mg=mg1-interval '1 month';
else 
mg=mg1;
end if;
raise notice 'mg- %',mg;

monthday= date_mi ( date_trunc('month',(mg+interval '1 month')::date)
                                        ::date,
                              date_trunc('month',mg )::date);
raise notice 'monthday , % ',monthday;

 raise notice 'delete 3 year&';
-- delete 3 year
/*
for  bill_3 in select * from acm_bill_tbl where mmgg_bill=mg-interval '3 year'
        and id_client=idcl and value>0 and id_pref=(
 select id from aci_pref_tbl where ident='inf') order by mmgg loop

raise notice 'found';
select into f_pay * from acm_billpay_tbl where id_bill=bill_3.id_doc;
if not found then
 raise notice 'generate minus bill';
delete from acm_bill_tbl where id_client=idcl and mmgg=m_g  and id_pref=(
 select id from aci_pref_tbl where ident='inf') and value=-bill_3.value; 

select into kdoc id from dci_document_tbl where ident='bill';
 raise notice 'insert bill';
insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident='inf')
  ,now() ,'I-'||(select code::text from clm_client_tbl where id=idcl)||'_'
  ||to_char(mg,'mm')||'-'||to_char(mg,'yyyy')
  ,now()::date,idcl
  ,mfo_s ,acc_s,-bill_3.value,0.0,bill_3.mmgg_bill,kdoc);

end if;



end loop;
*/
-- end delete 3 year

select into kinf (value::numeric-1)/monthday from cmd_tax_tbl as a,cmi_tax_tbl as b 
 where a.id_tax=b.id and b.ident='inf' 
    and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
   where a.date_inst<=mg and b.ident='inf');

raise notice 'kinf  %',kinf;

select into r tt.*, 
   calend_add_hol(tt.dte_doc,coalesce(tt.cnt_day,3)+1) as dt_start
from   
 (select d.dte_doc, d.cnt_day,
     (select count(*)::int from calendar where (c_date 
     between d.dte_doc and date_mii(d.dte_doc,-(d.cnt_day))) 
     and holiday) as add_hol 
    from 
    (select date_mii(mg,-(coalesce(dt_indicat,1)-1)) as dte_doc
       ,coalesce(day_pay_bill,3) as cnt_day
        from (select max(doc_dat) as doc_dat,id_client from clm_statecl_tbl 
        where id_client=idcl and doc_num is not null group by id_client) as a 
       left join clm_statecl_tbl as c 
       on (c.id_client=a.id_client and c.doc_dat=a.doc_dat)
   ) as d
 ) as tt;
if not found then
 raise notice 'nema------------ %',idcl;
 return 0;
end if;
raise notice 'dte %',r.dte_doc;
raise notice 'dtstart,%',r.dt_start;
raise notice 'cnt_day %',r.cnt_day;
raise notice 'add_hol %',r.add_hol;


--date_trunc('month',date_mii(mg,-33))

insert into act_summ_val(id_client,dat,ident,summ,ident1) 
select a.id_client,a.mmgg,'sb',coalesce(a.b_val,0)+coalesce(a.b_valtax,0) ,
  b.ident from acm_saldo_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee','inf')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 

insert into act_summ_val(id_client,dat,ident,summ,ident1) 
select a.id_client,date_trunc('month',date_mii(a.mmgg,-33)),'se',
 coalesce(a.e_val,0)+coalesce(a.e_valtax,0)
 ,b.ident from acm_saldo_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee','inf')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg;

insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,
 case when (b.ident<>'inf'  ) then 
    calend_add_hol(
     (coalesce(a.date_transmis::date,a.reg_date)+interval '1 day')::date,
       r.cnt_day)
     -- r.cnt_day+1)
  else 
    --(coalesce(a.date_transmis::date,a.reg_date)+interval '1 day')::date end as dat
    (coalesce(a.date_transmis::date,a.reg_date))::date end 

  ,'bil',coalesce(a.value,0)+coalesce(a.value_tax,0),a.id_doc,b.ident 
  from acm_bill_tbl as a 
   inner join (select id,ident from aci_pref_tbl where ident
    in ('act_ee','react_ee','inf')) as b on (a.id_pref=b.id) 
   where a.id_client=idcl and a.mmgg=mg;

insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,a.reg_date,'pay',
coalesce(-a.value,0)+coalesce(-a.value_tax,0),a.id_doc,b.ident 
  from acm_pay_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee','inf')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 
------------------------------------------------------------------------

insert into act_clc_inf(id_client,id_doc,type_doc,dat_b,dat_e,summ,
                        k_inf,sum_inf,ident1,calc_day) 
 select c.id_client,c.id_doc,c.ident,c.dat_b,
           date_mii(c.dat_e,0),c.summ, kinf
           ,round(c.summ*kinf*
                    (date_mi(c.dat_e,--c.dat_b
                     (case when (c.dat_b=bom(c.dat_b)) 
                    then c.dat_b+interval '1 day' 
                    else c.dat_b end 
                    )::date
                    )+1)
               ,2),ident1,
           (date_mi(c.dat_e,
                   (case when (c.dat_b=bom(c.dat_b)) 
                    then c.dat_b+interval '1 day' 
                    else c.dat_b end 
                    )::date)+1) 
 from (select id_client,id_doc,ident,(dat+interval '1 day')::date as dat_b
             ,ident1
          ,(  select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
              and b1.dat>b.dat
           ) as dat_e
          ,( select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
             and b2.dat<=b.dat 
           ) as summ 
           from act_summ_val b where ident<>'se'

      ) as c 
 where c.summ>0 ;

delete from act_clc_inf where dat_b>dat_e;

--create bill
for r in select * from cli_account_tbl as a left join (select int4('0'||value_ident) as val from 
          syi_sysvars_tbl where ident='id_res') as b on (a.id_client=b.val) 
          where a.ident='inf' loop
  mfo_s:=r.mfo;
--  acc_s:=to_number(r.account,'99999999999999');
  acc_s:=r.account;
end loop;
select into reg_dt eom(mg);
if mfo_s is null then
  Raise Notice 'Account not found';
 insert into act_res_notice values('Account INFL not found for 999 client');

  Return null;
end if;

select into s coalesce(sum(sum_inf),0) from 
 ( select id_client,ident1,dat_b,max(sum_inf) as sum_inf 
 from act_clc_inf where id_client=idcl
 group by id_client, ident1,dat_b) as d
where id_client=idcl;

delete from acm_bill_tbl where id_client=idcl and mmgg=m_g  and id_pref=(
 select id from aci_pref_tbl where ident='inf') and value>0; 

select into kdoc id from dci_document_tbl where ident='bill';
if s>0 then 
insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident='inf')
  ,now() ,(select code::text from clm_client_tbl where id=idcl)||'_'
  ||to_char(mg,'mm')||'-'||to_char(mg,'yyyy')
  ,now()::date ,idcl 
  ,mfo_s ,acc_s ,s,0.0,bom(reg_dt),kdoc);

 iddc:=currval('dcm_doc_seq');
 -----detail
 for recact in select * from act_clc_inf where id_client=idcl loop
 select id_doc into doc_check from acd_clc_inf 
 where id_doc=iddc and dat_b=recact.dat_b and  ident1=recact.ident1;
  if not found then
   insert into acd_clc_inf (id_doc,dt,id_p_doc,type_p_doc,
       dat_b,dat_e,summ,k_inf,sum_inf,ident1,calc_day)  
    values ( iddc,now(),recact.id_doc,recact.type_doc,
      recact.dat_b,recact.dat_e,recact.summ,recact.k_inf,
    recact.sum_inf,recact.ident1,recact.calc_day);
  end if;
end loop;

insert into acd_summ_val  (  id_doc,dt,id_client,dat,ident,summ,id_p_doc,ident1)
  select iddc,now() ,id_client,dat,ident,summ,id_doc,ident1 
    from act_summ_val;
end if;
                                 /*
                                   */
 Return s;
end;
$BODY$
 Language 'plpgsql';






function_calc_pena;

create or replace function calc_pena(int,date) Returns numeric As 
$BODY$
Declare
idcl Alias for $1;
mg1 Alias for $2;
mg date;
knbu numeric;
r record; 
s numeric;
mfo_s int;
acc_s numeric;
iddc int;
kdoc int;
m_g date;
yearday int;
reg_dt date;
parclient record;
bill_6  record;
f_pay record;
recact record;
doc_check int;
sal record;
begin
delete from act_summ_val; -- where id_client=idcl;
delete from act_clc_inf;-- where id_client=idcl;

s:=0;


select into m_g (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||'-'
    ||substr(value_ident,1,2))::date from syi_sysvars_tmp where ident='mmgg';


if mg1 is null then
mg=m_g;
end if;

if mg1>(m_g) then
 insert into act_res_notice values('not calc peni for future or present period');
raise notice 'not calc peni for future or present period - %',mg1;
Return null;
end if;

if mg1=(m_g) then
mg=mg1-interval '1 month';
else 
mg=mg1;
end if;

raise notice 'mg- %',mg;


yearday= date_mi ( date_trunc('year',(mg+interval '1 year')::date)
                                        ::date,
                              date_trunc('year',mg )::date);
raise notice 'yearday , % ',yearday;
raise notice 'id_client , % ',idcl;
/*
select into bill_6 * from acm_bill_tbl where mmgg=mg-interval '6 month'
        and id_client=idcl and value>0 and id_pref=(
 select id from aci_pref_tbl where ident='pena');
*/
/*
 raise notice 'delete 6 month &';
-- delete >6 year
for  bill_6 in select * from acm_bill_tbl where mmgg_bill=mg-interval '6 month'
        and id_client=idcl and value>0 and id_pref=(
 select id from aci_pref_tbl where ident='pena') order by mmgg loop

raise notice 'found';

select into f_pay * from acm_billpay_tbl where id_bill=bill_6.id_doc;
if not found then
 raise notice 'generate minus bill';
delete from acm_bill_tbl where id_client=idcl and mmgg=m_g  and id_pref=(
 select id from aci_pref_tbl where ident='pena') and value=-bill_6.value; 

select into kdoc id from dci_document_tbl where ident='bill';
 raise notice 'insert bill';

insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident='pena')
  ,now() ,'I-'||(select code::text from clm_client_tbl where id=idcl)||'_'
  ||to_char(mg,'mm')||'-'||to_char(mg,'yyyy')
  ,now()::date,idcl
  ,mfo_s ,acc_s,-bill_6.value,0.0,bill_6.mmgg_bill,kdoc);

end if;



end loop;
-- end delete 6 month
*/
/*

select into bill_6 * from acm_bill_tbl where mmgg_bill=mg-interval '6 month'
        and id_client=idcl and value>0 and id_pref=(
 select id from aci_pref_tbl where ident='pena');


if found then
 raise notice 'found';
select into f_pay * from acm_billpay_tbl where id_bill=bill_6.id_doc;
if not found then
 raise notice 'generate minus bill';
delete from acm_bill_tbl where id_client=idcl and mmgg=m_g  and id_pref=(
 select id from aci_pref_tbl where ident='pena' and value=-bill_6.value); 

select into kdoc id from dci_document_tbl where ident='bill';
 raise notice 'insert bill';
insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident='pena')
  ,now() ,'R-'||(select code::text from clm_client_tbl where id=idcl)||'_'
  ||to_char(mg,'mm')||'-'||to_char(mg,'yyyy')
  ,now()::date,idcl
  ,mfo_s ,acc_s,-bill_6.value,0.0,bill_6.mmgg_bill,kdoc);

end if;

end if;
*/

select into parclient id_client,count_peni,type_peni,dt_indicat,day_pay_bill 
           from clm_statecl_tbl 
           where id_client=idcl;

if not found then
 raise notice 'nema------------ %',idcl;
 return 0;
end if;

if  parclient.type_peni<>1 or parclient.count_peni<0 or parclient.day_pay_bill<0 then
  Raise Notice 'Not found parameter in client card %',parclient.id_client;
  insert into act_res_notice values('Not found parameter in client card');
Return null;
end if;


select into knbu value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
 where a.id_tax=b.id and b.ident='nbu' 
    and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
   where a.date_inst<=mg and b.ident='nbu');

raise notice 'knbu  %',knbu;             

select into r tt.*, 
-- date_pli(date_pli(tt.dte_doc,coalesce(tt.cnt_day,3)),coalesce(tt.add_hol,0))::date as dt_start 
   calend_add_hol(tt.dte_doc,coalesce(tt.cnt_day,3)+1) as dt_start
from   
 (select d.dte_doc,d.cnt_day,(select count(*)::int from calendar where (c_date 
     between d.dte_doc and date_mii(d.dte_doc,-(d.cnt_day))) 
     and holiday) as add_hol 
    from 
    (select date_mii(mg,-(coalesce(dt_indicat,1)-1)) as dte_doc
       ,coalesce(day_pay_bill,3) as cnt_day
        from (select max(doc_dat) as doc_dat,id_client from clm_statecl_tbl 
        where id_client=idcl and doc_num is not null group by id_client) as a 
       left join clm_statecl_tbl as c 
       on (c.id_client=a.id_client and c.doc_dat=a.doc_dat)
   ) as d
 ) as tt;

raise notice 'dte %',r.dte_doc;
raise notice 'dtstart,%',r.dt_start;
raise notice 'cnt_day %',r.cnt_day;
raise notice 'add_hol %',r.add_hol;


insert into act_summ_val(id_client,dat,ident,summ,ident1) 
 select a.id_client,a.mmgg,'sb',
   coalesce(a.b_val,0)+coalesce(a.b_valtax,0),
  b.ident from acm_saldo_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 


update act_summ_val set summ=summ-bo.value,upd=1 from
--select act_summ_val.*,p.*,bo.* from act_summ_val act_summ_val,
 ( select id_client,id_pref,sum(value+value_tax)  as value
    from     (select id_doc,reg_date,id_pref,id_client,value,value_tax 
               from  (select * from acm_bill_tbl where mmgg=mg-interval '1 month' and  id_client=idcl )  b
                 inner join (select id,ident from aci_pref_tbl where ident   in ('act_ee','react_ee')) as p on (id_pref=p.id)   
               where  calend_add_hol(coalesce (date_transmis,reg_date)::date,parclient.day_pay_bill)>=mg
              )  b group by id_client, id_pref
  ) as bo, 
 aci_pref_tbl p 
 where act_summ_val.ident='sb' and p.id=bo.id_pref  and 
  act_summ_val.id_client=bo.id_client  and act_summ_val.ident1=p.ident; 



insert into act_summ_val(id_client,dat,dat_transmiss,ident,summ,id_doc,ident1) 
select a.id_client,
 case when (b.ident<>'inf'  ) then 
    calend_add_hol(
     (coalesce(a.date_transmis::date,a.reg_date)+interval '1 day')::date,
       r.cnt_day)
     -- r.cnt_day+1)
  else 
    --(coalesce(a.date_transmis::date,a.reg_date)+interval '1 day')::date end as dat
    (coalesce(a.date_transmis::date,a.reg_date))::date end,
    coalesce(a.date_transmis::date,a.reg_date)
    ,'bil',
     coalesce(a.value,0)+coalesce(a.value_tax,0),
  a.id_doc,b.ident from acm_bill_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg-interval '1 month' and 
calend_add_hol(coalesce (a.date_transmis,reg_date)::date,parclient.day_pay_bill)>=mg;

                            
  raise notice 'sal ident r';
for sal in select * from  act_summ_val where ident='sb' loop
  raise notice ' ..............bill_sal ident1 %  ,% ',sal.ident1,sal.summ;
  --select crt_ttbl();
  --drop function calc_pena(int,date);
/*
  update act_summ_val
   set summ=0 --summ - (coalesce(s.b_val,0)+coalesce(s.b_valtax,0)+0)  
    from (select s.*, p.ident as ident_sal from acm_saldo_tbl  s, aci_pref_tbl p 
           where p.id=s.id_pref --and s.mmgg=mg and s.id_client=idcl
         ) s    
   where --act_summ_val.ident='bil'   and sal.ident1=act_summ_val.ident1    and 
    s.ident_sal=act_summ_val.ident1; 
select * from act_summ_val
select * from acm_saldo_tbl
*/

 update act_summ_val   set upd=1,summ=summ + (coalesce(b_val,0)+coalesce(b_valtax,0))   
 from   acm_saldo_tbl ,aci_pref_tbl p  
 where p.id=acm_saldo_tbl.id_pref and p.ident=act_summ_val.ident1 and sal.ident1=act_summ_val.ident1 and p.ident=sal.ident1 
and act_summ_val.ident='bil'   and  mmgg=mg and acm_saldo_tbl.id_client=idcl and (coalesce(b_val,0)+coalesce(b_valtax,0))<0;



end loop;
                           
--update act_summ_val set summ=0 where ident='sb'  and  id_client=idcl and summ<0; 

/* osa 2014-09-18  bobr 40*/                            
--update act_summ_val set summ=0 where ident='sb' and upd=1 and  id_client=idcl and summ<0; 
                              



insert into act_summ_val(id_client,dat,dat_transmiss,ident,summ,id_doc,ident1) 
select a.id_client,
 case when (b.ident<>'inf'  ) then 
    calend_add_hol(
     (coalesce(a.date_transmis::date,a.reg_date)+interval '1 day')::date,

       r.cnt_day)
     -- r.cnt_day+1)
  else 
    --(coalesce(a.date_transmis::date,a.reg_date)+interval '1 day')::date end as dat
    (coalesce(a.date_transmis::date,a.reg_date))::date end,
    coalesce(a.date_transmis::date,a.reg_date)
  ,'bil',
     coalesce(a.value,0)+coalesce(a.value_tax,0),
  a.id_doc,b.ident from acm_bill_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg;



insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,a.reg_date,'pay',
     coalesce(-a.value,0)+coalesce(-a.value_tax,0),
  a.id_doc,b.ident 
  from acm_pay_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in ('act_ee','react_ee')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 

delete from act_summ_val where dat>eom(mg);
delete from act_summ_val where summ=0;

------------------------------------------------------------------------
if yearday is null then 
 yearday=365;
end if;

insert into act_clc_inf(id_client,id_doc,type_doc,dat_b,
            dat_e,summ,  k_inf,
            sum_inf,ident1,calc_day) 
 select c.id_client,c.id_doc,c.ident,c.dat_b,
           coalesce(date_mii(c.dat_e,0),eom(date_larger(mg,c.dat_b))),c.summ, knbu
           ,round(c.summ*knbu*parclient.count_peni
                   *( date_mi( coalesce(c.dat_e::date,(eom(date_larger(mg,c.dat_b)))::date )
                              ,c.dat_b
                             )
                     +1
                 ),2)
          /yearday as sum_inf,ident1,
           (date_mi(c.dat_e,
                   (case when (c.dat_b=bom(c.dat_b)) 
                    then c.dat_b+interval '1 day' 
                    else c.dat_b end 
                    )::date )+1)
 from (select id_client,id_doc,ident,(
              case when (dat=bom(dat)  ) then 
               dat
               else
                 dat+interval '1 day' end)::date as dat_b
          ,ident1
          ,(  select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
              and b1.dat>b.dat
           ) as dat_e
          ,( select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
             and b2.dat<=b.dat 
           ) as summ 
           from act_summ_val b where ident<>'se' 

      ) as c 
 where c.summ>0;

delete from act_clc_inf where dat_b>dat_e;
delete from act_clc_inf where eom(dat_b)>eom(mg);

--create bill

for r in select * from cli_account_tbl as a 
     left join (select int4('0'||value_ident) as val from 
          syi_sysvars_tbl where ident='id_res') as b on (a.id_client=b.val) 
          where a.ident='pena' loop
  mfo_s:=r.mfo;
 -- acc_s:=to_number(r.account,'99999999999999');
    acc_s:=r.account;
end loop;

select into reg_dt eom(mg);
if mfo_s is null then
  Raise Notice 'Account not found';
 insert into act_res_notice values('Account PENI not found for 999 client');
  Return null;
end if;

select into s 
coalesce(sum(sum_inf),0) from 
 ( select id_client,ident1,dat_b,max(sum_inf) as sum_inf 
 from act_clc_inf where id_client=idcl
 group by id_client, ident1,dat_b) as d
where id_client=idcl;

delete from acm_bill_tbl where id_client=idcl and mmgg=m_g and value>0 and id_pref=(
 select id from aci_pref_tbl where ident='pena'); 

select into kdoc id from dci_document_tbl where ident='bill';

if s>0 then
insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident='pena')
  ,now() ,(select code::text from clm_client_tbl where id=idcl)||'_'
  ||to_char(mg,'mm')||'-'||to_char(mg,'yyyy')
  ,now()::date ,idcl 
  ,mfo_s,acc_s ,s,0.0,bom(reg_dt),kdoc);

iddc:=currval('dcm_doc_seq');
-----detail
for recact in select * from act_clc_inf where id_client=idcl loop
 select id_doc into doc_check from acd_clc_inf 
 where id_doc=iddc and dat_b=recact.dat_b and  ident1=recact.ident1;
  if not found then
   insert into acd_clc_inf (id_doc,dt,id_p_doc,type_p_doc,
       dat_b,dat_e,summ,k_inf,sum_inf,ident1,calc_day)  
    values ( iddc,now(),recact.id_doc,recact.type_doc,
      recact.dat_b,recact.dat_e,recact.summ,recact.k_inf,
    recact.sum_inf,recact.ident1,recact.calc_day);
  end if;

end loop;

insert into acd_summ_val  (  id_doc,dt,id_client,dat,dat_transmiss,ident,summ,id_p_doc,ident1)
  select iddc,now()  ,id_client,dat,dat_transmiss,ident,summ,id_doc,ident1 
    from act_summ_val;
end if;

 Return s;
end;
$BODY$ 
Language 'plpgsql';




