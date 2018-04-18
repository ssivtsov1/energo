
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

alter table acd_clc_inf add column id_p_doc int;
alter table acd_clc_inf drop column type_p_doc ;
alter table acd_clc_inf add column type_p_doc varchar(10);
alter table acd_clc_inf add column koeff numeric(10,5);

alter table acd_clc_inf_del add column id_p_doc int;
alter table acd_clc_inf_del drop column type_p_doc ;
alter table acd_clc_inf_del add column type_p_doc varchar(10);
alter table acd_clc_inf_del add column koeff numeric(10,5);

drop function calc_infl(int,date);
create function calc_infl(int,date) Returns numeric As '
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
begin
delete from act_summ_val; -- where id_client=idcl;
delete from act_clc_inf;-- where id_client=idcl;
s:=0;

select into m_g (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''
    ||substr(value_ident,1,2))::date from syi_sysvars_tmp where ident=''mmgg'';

if mg1 is null then
mg=m_g;
end if;

if mg1>(m_g) then
 insert into act_res_notice values(''not calc infl for future or present period'');
raise notice ''not calc peni for future or present period - %'',mg1;
Return null;
end if;



if mg1=(m_g) then
mg=mg1-interval ''1 month'';
else 
mg=mg1;
end if;
raise notice ''mg- %'',mg;

monthday= date_mi ( date_trunc(''month'',(mg+interval ''1 month'')::date)
                                        ::date,
                              date_trunc(''month'',mg )::date);
raise notice ''monthday , % '',monthday;

select into kinf (value::numeric-1)/monthday from cmd_tax_tbl as a,cmi_tax_tbl as b 
 where a.id_tax=b.id and b.ident=''inf'' 
    and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
   where a.date_inst<=mg and b.ident=''inf'');

raise notice ''kinf  %'',kinf;

select into r tt.*, 
 date_pli(date_pli(tt.dte_doc,coalesce(tt.cnt_day,3)),coalesce(tt.add_hol,0))::date as dt_start 
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
raise notice ''dte %'',r.dte_doc;
raise notice ''dtstart,%'',r.dt_start;
raise notice ''cnt_day %'',r.cnt_day;
raise notice ''add_hol %'',r.add_hol;


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
select a.id_client,case when (b.ident<>''inf'' 
 and a.reg_date<=r.dt_start) then 
     r.dt_start
--  date_mii(r.dte_doc,-(r.cnt_day+r.add_hol+1))
  else 
    a.reg_date end as dat
--date_mii(a.reg_date,-(r.cnt_day+r.add_hol+1)) end as dat
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
insert into act_clc_inf(id_client,id_doc,type_doc,dat_b,dat_e,summ,
                        k_inf,sum_inf,ident1) 
 select c.id_client,c.id_doc,c.ident,c.dat_b,
           date_mii(c.dat_e,1),c.summ, kinf
           ,round(c.summ*kinf*date_mi(c.dat_e,c.dat_b),2) as sum_inf,ident1
 from (select id_client,id_doc,ident,dat as dat_b,ident1
          ,(  select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
              and b1.dat>b.dat
           ) as dat_e
          ,( select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
             and b2.dat<=b.dat 
           ) as summ 
           from act_summ_val b where ident<>''se''

      ) as c 
 where c.summ>0;

--create bill
for r in select * from cli_account_tbl as a left join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=''inf'' loop
  mfo_s:=r.mfo;
  acc_s:=to_number(r.account,''99999999999999'');
end loop;
select into reg_dt eom(mg);
if mfo_s is null then
  Raise Notice ''Account not found'';
 insert into act_res_notice values(''Account INFL not found for 999 client'');

  Return null;
end if;

select into s coalesce(sum(sum_inf),0) from 
 ( select id_client,ident1,dat_b,max(sum_inf) as sum_inf 
 from act_clc_inf where id_client=idcl
 group by id_client, ident1,dat_b) as d
where id_client=idcl;

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
for recact in select * from act_clc_inf where id_client=idcl loop
 select id_doc into doc_check from acd_clc_inf 
 where id_doc=iddc and dat_b=recact.dat_b and  ident1=recact.ident1;
  if not found then
   insert into acd_clc_inf (id_doc,dt,id_p_doc,type_p_doc,
       dat_b,dat_e,summ,k_inf,sum_inf,ident1)  
    values ( iddc,now(),recact.id_doc,recact.type_doc,
      recact.dat_b,recact.dat_e,recact.summ,recact.k_inf,
    recact.sum_inf,recact.ident1);
  end if;
end loop;

insert into acd_summ_val  (  id_doc,dt,id_client,dat,ident,summ,id_p_doc,ident1)
  select iddc,now() as dt ,id_client,dat,ident,summ,id_doc,ident1 
    from act_summ_val;

                                 /*
                                   */
 Return s;
end;
' Language 'plpgsql';


delete from cmi_tax_tbl where ident='nbu';
INSERT INTO "cmi_tax_tbl" ("id", "date_inst", "name", "short_name", "idk_tax", "ident") 
       VALUES (3, NULL, 'îâõ', 'îâõ', NULL, 'nbu');

drop function calc_pena(int,date);
create function calc_pena(int,date) Returns numeric As '
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

recact record;
doc_check int;
begin
delete from act_summ_val; -- where id_client=idcl;
delete from act_clc_inf;-- where id_client=idcl;

s:=0;


select into m_g (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''
    ||substr(value_ident,1,2))::date from syi_sysvars_tmp where ident=''mmgg'';


if mg1 is null then
mg=m_g;
end if;

if mg1>(m_g) then
 insert into act_res_notice values(''not calc peni for future or present period'');
raise notice ''not calc peni for future or present period - %'',mg1;
Return null;
end if;

if mg1=(m_g) then
mg=mg1-interval ''1 month'';
else 
mg=mg1;
end if;

raise notice ''mg- %'',mg;


yearday= date_mi ( date_trunc(''year'',(mg+interval ''1 year'')::date)
                                        ::date,
                              date_trunc(''year'',mg )::date);
raise notice ''yearday , % '',yearday;

select into parclient id_client,count_peni,type_peni,dt_indicat,day_pay_bill 
           from clm_statecl_tbl 
           where id_client=idcl;

if  parclient.type_peni<>1 or parclient.count_peni<0 or parclient.day_pay_bill<0 then
  Raise Notice ''Not found parameter in client card'';
  insert into act_res_notice values(''Not found parameter in client card'');
Return null;
end if;


select into knbu value::numeric/100 from cmd_tax_tbl as a,cmi_tax_tbl as b 
 where a.id_tax=b.id and b.ident=''nbu'' 
    and a.date_inst=(select max(a.date_inst) from 
     cmd_tax_tbl as a right join cmi_tax_tbl as b on (a.id_tax=b.id) 
   where a.date_inst<=mg and b.ident=''nbu'');

raise notice ''knbu  %'',knbu;             

  /*
select max(doc_dat) as doc_dat,id_client,count_peni,type_peni 
           from clm_statecl_tbl 
           where id_client=idcl;
                 

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

*/
select into r tt.*, 
 date_pli(date_pli(tt.dte_doc,coalesce(tt.cnt_day,3)),coalesce(tt.add_hol,0))::date as dt_start 
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
raise notice ''dte %'',r.dte_doc;
raise notice ''dtstart,%'',r.dt_start;
raise notice ''cnt_day %'',r.cnt_day;
raise notice ''add_hol %'',r.add_hol;


insert into act_summ_val(id_client,dat,ident,summ,ident1) 
select a.id_client,a.mmgg,''sb'',a.b_val,b.ident from acm_saldo_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 


insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,case when (b.ident<>''inf'' 
 and a.reg_date<=r.dt_start) then 
     r.dt_start
--  date_mii(r.dte_doc,-(r.cnt_day+r.add_hol+1))
  else 
    a.reg_date end as dat
/*and a.reg_date<=r.dte_doc) then 
  date_mii(r.dte_doc,-(r.cnt_day+r.add_hol+1))
  else date_mii(a.reg_date,-(r.cnt_day+r.add_hol+1)) end as dat*/

  ,''bil'',a.value,a.id_doc,b.ident from acm_bill_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg;

/*
insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,case when (b.ident<>''inf'' and a.reg_date<=r.dte_doc) then 
  date_mii(r.dte_doc,-(r.cnt_day+r.add_hol+1))
  else date_mii(a.reg_date,-(r.cnt_day+r.add_hol+1)) end as dat
  ,''bil'',a.value,a.id_doc,b.ident from acm_bill_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg;
*/
insert into act_summ_val(id_client,dat,ident,summ,id_doc,ident1) 
select a.id_client,a.reg_date,''pay'',-a.value,a.id_doc,b.ident 
  from acm_pay_tbl as a 
  inner join (select id,ident from aci_pref_tbl where ident
   in (''act_ee'',''react_ee'')) as b on (a.id_pref=b.id) 
 where a.id_client=idcl and a.mmgg=mg; 

------------------------------------------------------------------------
if yearday is null then 
 yearday=365;
end if;


insert into act_clc_inf(id_client,id_doc,type_doc,dat_b,dat_e,summ,
                        k_inf,sum_inf,ident1) 
 select c.id_client,c.id_doc,c.ident,c.dat_b,
           coalesce(date_mii(c.dat_e,1),eom(mg)),c.summ, knbu
           ,round(c.summ*knbu*parclient.count_peni*date_mi(coalesce(c.dat_e,eom(mg) ),c.dat_b),2)/yearday as sum_inf,ident1
 from (select id_client,id_doc,ident,dat as dat_b,ident1
          ,(  select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
              and b1.dat>b.dat
           ) as dat_e
          ,( select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
             and b2.dat<=b.dat 
           ) as summ 
           from act_summ_val b where ident<>''se''

      ) as c 
 where c.summ>0;

/*
insert into act_clc_inf(id_client,id_doc,type_doc,dat_b,dat_e,summ,
                        k_inf,sum_inf,ident1) 
 select c.id_client,c.id_doc,c.ident,c.dat_b,
           date_mii(c.dat_e,1),c.summ,knbu
           ,round(c.summ*knbu*date_mi(c.dat_e,c.dat_b),2)/yearday as sum_inf,ident1
 from (select id_client,id_doc,ident,dat as dat_b,ident1
          ,(  select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
              and b1.dat>b.dat
           ) as dat_e
          ,( select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
             and b2.dat<=b.dat 
           ) as summ 
           from act_summ_val b where ident<>''se''

      ) as c 
 where c.summ>0;


insert into act_clc_inf(id_client,id_doc,type_doc,dat_b,dat_e,summ,nbu,sum_inf,ident1) 
 select c.id_client,c.id_doc,c.ident,c.dat_b,date_mii(c.dat_e,1),c.summ,knbu
 ,round(c.summ*kinf*date_mi(c.dat_e,c.dat_b)/yearday,2) as sum_inf,ident1
 from (select id_client,dat as dat_b,ident1,
 ,(select min(dat) from act_summ_val b1 where b1.ident1=b.ident1 
     and b1.dat>b.dat) as dat_e
 ,(select sum(summ) from act_summ_val as b2 where b2.ident1=b.ident1 
     and b2.dat<=b.dat) as summ 
 from act_summ_val b where ident<>''se'') as c 
 where c.summ>0;
*/
--create bill

for r in select * from cli_account_tbl as a 
     left join (select int4(''0''||value_ident) as val from 
          syi_sysvars_tbl where ident=''id_res'') as b on (a.id_client=b.val) 
          where a.ident=''pena'' loop
  mfo_s:=r.mfo;
  acc_s:=to_number(r.account,''99999999999999'');
end loop;

select into reg_dt eom(mg);
if mfo_s is null then
  Raise Notice ''Account not found'';
 insert into act_res_notice values(''Account PENI not found for 999 client'');
  Return null;
end if;

select into s 
coalesce(sum(sum_inf),0) from 
 ( select id_client,ident1,dat_b,max(sum_inf) as sum_inf 
 from act_clc_inf where id_client=idcl
 group by id_client, ident1,dat_b) as d
where id_client=idcl;

delete from acm_bill_tbl where id_client=idcl and mmgg=m_g  and id_pref=(
 select id from aci_pref_tbl where ident=''pena''); 

select into kdoc id from dci_document_tbl where ident=''bill'';

if s>=0 then
insert into acm_bill_tbl(id_pref,dt,reg_num,reg_date,id_client
                         ,mfo_self,account_self,value,value_tax,mmgg_bill,idk_doc) 

values((select id from aci_pref_tbl where ident=''pena'') as id_pref
  ,now() as dt,(select code::text from clm_client_tbl where id=idcl)||''_''
  ||to_char(mg,''mm'')||''-''||to_char(mg,''yyyy'') as reg_num
  ,reg_dt as reg_date,idcl as id_client
  ,mfo_s as mfo_self,acc_s as account_self,s,0.0,bom(reg_dt),kdoc);

iddc:=currval(''dcm_doc_seq'');
-----detail
for recact in select * from act_clc_inf where id_client=idcl loop
 select id_doc into doc_check from acd_clc_inf 
 where id_doc=iddc and dat_b=recact.dat_b and  ident1=recact.ident1;
  if not found then
   insert into acd_clc_inf (id_doc,dt,id_p_doc,type_p_doc,
       dat_b,dat_e,summ,k_inf,sum_inf,ident1)  
    values ( iddc,now(),recact.id_doc,recact.type_doc,
      recact.dat_b,recact.dat_e,recact.summ,recact.k_inf,
    recact.sum_inf,recact.ident1);
  end if;

end loop;

insert into acd_summ_val  (  id_doc,dt,id_client,dat,ident,summ,id_p_doc,ident1)
  select iddc,now() as dt ,id_client,dat,ident,summ,id_doc,ident1 
    from act_summ_val;
end if;

/*insert into acd_clc_inf(id_doc,dt,id_p_doc,type_p_doc,dat_b,dat_e,summ,k_inf,sum_inf,ident1)  
 select iddc,now() as dt,id_p_doc,type_p_doc,dat_b,dat_e,summ,k_inf,sum_inf,ident1
  from act_clc_inf where id_client=idcl;
*/
 Return s;
end;
' Language 'plpgsql';
