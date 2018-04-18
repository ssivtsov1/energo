drop function calc_penia(int,date);
create function calc_penia(int,date) Returns numeric As '
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
begin
delete from act_summ_val where id_client=idcl;
delete from act_clc_inf where id_client=idcl;
s:=0;
select into m_g (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''
    ||substr(value_ident,1,2))::date from syi_sysvars_tbl where ident=''mmgg'';

if mg1>(m_g) then
Return null;
end if;

if mg1=(m_g) then
mg=mg1-interval ''1 month'';
end if;


select into kinf (value::numeric-100)/100 from cmd_tax_tbl as a,
  cmi_tax_tbl as b 
  where a.id_tax=b.id and b.ident=''inf'' and a.date_inst=
    (select max(date_inst) from cmd_tax_tbl where date_inst<=mg);

select into r d.dte_doc,d.cnt_day,(select count(*)::int from calendar where (c_date 
     between d.dte_doc and date_mii(d.dte_doc,-(d.cnt_day))) 
     and holiday) as add_hol 
    from 
    (select date_mii(mg,-(coalesce(dt_indicat,1)-1)) as dte_doc
       ,coalesce(day_pay_bill,3) as cnt_day
        from (select max(doc_dat) as doc_dat,id_client from clm_statecl_tbl 
        where id_client=idcl and doc_num is not null group by id_client) as a 
       left join clm_statecl_tbl as c 
       on (c.id_client=a.id_client and c.doc_dat=a.doc_dat)) as d;
--date_trunc(''month'',date_mii(mg,-33))

insert into act_summ_val(id_client,dat,ident,summ,ident1) 
select a.id_client,a.mmgg,''sb'',a.b_val,b.ident from acm_saldo_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'',''inf'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 

insert into act_summ_val(id_client,dat,ident,summ,ident1) 
select a.id_client,date_trunc(''month'',date_mii(a.mmgg,-33)),''se'',a.e_val
 ,b.ident from acm_saldo_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'',''inf'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg;

insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,case when (b.ident<>''inf'' and a.reg_date<=r.dte_doc) then 
  date_mii(r.dte_doc,-(r.cnt_day+r.add_hol+1))
  else date_mii(a.reg_date,-(r.cnt_day+r.add_hol+1)) end as dat
  ,''bil'',a.value,a.id_doc,b.ident from acm_bill_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'',''inf'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg;

insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,a.reg_date,''pay'',-a.value,a.id_doc,b.ident 
  from acm_pay_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'',''inf'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 
------------------------------------------------------------------------
insert into act_clc_inf(id_client,dat_b,dat_e,summ,k_inf,sum_inf,ident1) 
 select c.id_client,c.dat_b,date_mii(c.dat_e,1),c.summ,kinf
 ,round(c.summ*kinf*date_mi(c.dat_e,c.dat_b),2) as sum_inf,ident1
 from (select id_client,dat as dat_b,ident1
 ,(select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
     and b1.dat>b.dat) as dat_e
 ,(select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
     and b2.dat<=b.dat) as summ 
 from act_summ_val b where ident<>''se'') as c 
 where c.summ>0;
--create bill
for r in select * from cli_account_tbl as a left join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=''inf'' loop
  mfo_s:=r.mfo;
  acc_s:=to_number(r.account,''99999999999999'');
end loop;
select into reg_dt eom(max(dat_e)) from act_clc_inf;
if mfo_s is null then
  Raise Notice ''Account not found'';
  Return null;
end if;
select into s coalesce(sum(sum_inf),0) from act_clc_inf where id_client=idcl;

delete from acm_bill_tbl where id_client=idcl and mmgg=m_g  and id_pref=(
 select id from aci_pref_tbl where ident=''inf''); 

select into kdoc id from dci_document_tbl where ident=''bill'';
insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident=''inf'') as id_pref
  ,now() as dt,(select code::text from clm_client_tbl where id=idcl)||''_''
  ||to_char(mg,''mm'')||''-''||to_char(mg,''yyyy'') as reg_num
  ,reg_dt as reg_date,idcl as id_client
  ,mfo_s as mfo_self,acc_s as account_self,s,0.0,bom(reg_dt),kdoc);

iddc:=currval(''dcm_doc_seq'');
-----detail
insert into acd_clc_inf(id_doc,dt,dat_b,dat_e,summ,k_inf,sum_inf,ident1)  
 select iddc,now() as dt,dat_b,dat_e,summ,k_inf,sum_inf,ident1
  from act_clc_inf where id_client=idcl;

 Return s;
end;
' Language 'plpgsql';
