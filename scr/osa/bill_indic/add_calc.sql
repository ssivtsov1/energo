create index acd_ind_doc on acd_indication_tbl (column  id_doc);

create sequence acm_headdem_seq  INCREMENT 1   MINVALUE 1  START 1 ;
create table acm_headdem_tbl (
     id_doc 		int DEFAULT nextval('acm_headdem_seq'),
     id_client          int,
     idk_doc		int,
     reg_num            varchar (20),   
     reg_date           date,   
     comment            varchar (254),
     id_bill            int,
     mmgg               date default fun_mmgg(),
     flock              int default 0,
    primary key(id_doc)
);

create sequence acm_demand_seq  INCREMENT 1   MINVALUE 1  START 1 ;
create table acm_demand_tbl (
     id                 int DEFAULT nextval('acm_demand_seq'), 
     id_doc 		int,
     id_point           int,
     id_tariff		int,
     demand             int,
     sum_demand         numeric (14,2),
     dt_b               date,
     dt_e               date,
     comment            varchar (254),
     mmgg               date default fun_mmgg(),
     flock              int default 0,
    primary key(id)
);

alter table acm_demand_tbl add column wtm int;
alter table acm_demand_tbl add column power int;
select altr_colmn('acm_demand_tbl','power','numeric(14,2)');
alter table acm_demand_tbl add column kind_energy int;
alter table acm_headdem_tbl add column kind_energy int;
alter table acm_headdem_tbl add column id_pref int;
alter table acm_demand_tbl add column sum_tax numeric(14,2);
select altr_colmn('acm_demand_tbl','sum_tax','numeric(14,2)');
-- zone;
--zone;
alter table acm_demand_tbl add column id_zone int;
alter table acm_demand_tbl alter column id_zone set default 0;
update acm_demand_tbl set id_zone=0 where id_zone is null;


create or replace function del_table(varchar) returns boolean as 
'
declare 
SSql text;
DSql text;
pr int;
tabl alias for $1;
cou record;
begin
pr=0;
 IF table_exists(tabl) THEN
SSql=''select  count(*) as count1  from ''::varchar||tabl;
for cou in Execute SSql loop
if cou.count1=0 then 
   pr=1;
end if;
end loop;
if pr=1 then

  DSql=''select droptable (''::varchar|| quote_literal(tabl) || '')''::varchar;
  raise notice ''%'',DSql;
  Execute DSql;
  return true;
end if;
end if;
return false;
end;
' language 'plpgsql';



select del_table('acm_saldoakt_tbl');

create sequence acm_saldoakt_seq  INCREMENT 1   MINVALUE 1  START 1 ;

create table acm_saldoakt_tbl (
     id 		int DEFAULT nextval('acm_saldoakt_seq'),
     id_client          int,
     id_pref            int default 10,
     mmgg		date default fun_mmgg(),
     mmgg_p             date default fun_mmgg(),   
     b_val            numeric(14,2) default 0,
     b_valtax        numeric(10,2) default 0,  
     dt_val            numeric(14,2) default 0,
     dt_valtax        numeric(10,2) default 0,  
     kt_val            numeric(14,2) default 0,
     kt_valtax        numeric(10,2) default 0,  
     e_val            numeric(14,2) default 0,
     e_valtax        numeric(10,2) default 0,  
     flock              int default 0,  
     comment_dt            varchar (200),
     comment_kt            varchar (200),
     calc                  int default 0,
     dt                  timestamp default now(),
     id_person           int,
    primary key(id_client,id_pref,mmgg,mmgg_p)
);

alter table  acm_saldoakt_tbl add column kvt numeric (10,0);




create or replace function calc_saldoakt(date) returns boolean as '
declare 

pmmgg alias for $1;
monclose date;
begin
if pmmgg is null then
  monclose=fun_mmgg(1);
else 
monclose=pmmgg;
end if;

insert into acm_saldoakt_tbl (id_client,id_pref,mmgg,mmgg_p)
     select distinct coalesce(pp.id_client,bb.id_client) as id_client,
           coalesce(pp.id_pref,bb.id_pref) as id_pref, coalesce(pp.mmgg,bb.mmgg) as mmgg,             
           coalesce(pp.mmgg_pay,bb.mmgg_bill) as mmgg_p
     from 
       (select distinct b.id_client,b.id_pref, b.mmgg,
              b.mmgg_bill
             from ( select * from acm_bill_tbl where mmgg=monclose and 
                   idk_doc=(select id from dci_document_tbl where ident = ''bill_act'') 
                  ) as b 
               left join acm_saldoakt_tbl  s1 
            on (s1.mmgg=monclose and  
                s1.id_client=b.id_client and s1.id_pref=b.id_pref and
                s1.mmgg_p=b.mmgg_bill
             )
            where s1.id is null
       ) as bb 
       full join 
        (select p.id_client,p.id_pref, p.mmgg,p.mmgg_pay
             from ( select * from acm_pay_tbl where mmgg=monclose 
                   and idk_doc in (select id from dci_document_tbl where (ident = ''pay_act'' or ident=''wr_off_act''))
              ) as p
               left join acm_saldoakt_tbl  s1 
            on (s1.mmgg=monclose and
                s1.id_client=p.id_client and s1.id_pref=p.id_pref and
                s1.mmgg_p=p.mmgg_pay
             )
            where s1.id is null
       ) as pp
      on (pp.id_client=bb.id_client and bb.id_pref=pp.id_pref
           and bb.mmgg=pp.mmgg and  bb.mmgg_bill=pp.mmgg_pay);

raise notice ''ins saldo from previous month'';
insert into acm_saldoakt_tbl (id_client,id_pref,mmgg,mmgg_p,b_val,b_valtax)
     select distinct ss.id_client, ss.id_pref, monclose,  ss.mmgg_p,
     ss.b_val,ss.b_valtax
     from 
       (select distinct s.id_client,s.id_pref, s.mmgg,
              s.mmgg_p,s.b_val,s.b_valtax
             from ( select * from acm_saldoakt_tbl where 
                   mmgg=monclose -interval ''1 month''  
                  ) as s 
               left join acm_saldoakt_tbl  s1 
            on (s1.mmgg=monclose and  
                s1.id_client=s.id_client and s1.id_pref=s.id_pref and
                s1.mmgg_p=s.mmgg_p
             )
            where s1.id is null
       ) as ss ;

update acm_saldoakt_tbl set b_val=s1.e_val,b_valtax=s1.e_valtax 
 from (select * from acm_saldoakt_tbl where mmgg=monclose-interval ''1 month'') s1
 where  s1.id_client=acm_saldoakt_tbl.id_client and
         s1.id_pref=acm_saldoakt_tbl.id_pref and
         s1.mmgg+interval ''1 month''=acm_saldoakt_tbl.mmgg and 
         s1.mmgg_p=acm_saldoakt_tbl.mmgg_p and 
         acm_saldoakt_tbl.mmgg=monclose and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

     

raise notice ''update saldoakt dt'';

update acm_saldoakt_tbl set dt_val=coalesce(cnt.dt_val,0),
                         dt_valtax=coalesce(cnt.dt_valtax,0),
                         kvt=coalesce(cnt.demand_val,0),
                       calc=1
       from 
          (select d.id_client as id_client,
           d.id_pref as id_pref ,
           d.mmgg as mmgg,d.mmgg_bill,
           sum(d.value) as dt_val,sum(d.value_tax) as dt_valtax,
           sum(d.demand_val) as demand_val
           from acm_bill_tbl as d 
             where d.mmgg=monclose and 
             d.idk_doc=(select id from dci_document_tbl where ident = ''bill_act'')
           group by d.id_client,d.id_pref ,d.mmgg,d.mmgg_bill ) as cnt
       where   cnt.id_client=acm_saldoakt_tbl.id_client and
         cnt.id_pref=acm_saldoakt_tbl.id_pref and
         cnt.mmgg=acm_saldoakt_tbl.mmgg and 
         cnt.mmgg_bill=acm_saldoakt_tbl.mmgg_p and 
         acm_saldoakt_tbl.mmgg=monclose and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

raise notice ''update saldo kt'';

update acm_saldoakt_tbl set  kt_val=coalesce(cnt.kt_val,0),
                         kt_valtax=coalesce(cnt.kt_valtax,0),
                         calc=1
       from 
          (select  k.id_client as id_client,
           k.id_pref as id_pref ,
           k.mmgg as mmgg,
           k.mmgg_pay as mmgg_pay,
           sum(k.value) as kt_val, sum(k.value_tax) as kt_valtax
           from  acm_pay_tbl as k 
            where k.mmgg=monclose and k.idk_doc in 
                (select id from dci_document_tbl    where (ident = ''pay_act'' or ident=''wr_off_act'' ))
           group by k.id_client,k.id_pref,k.mmgg,k.mmgg_pay ) as cnt
       where   cnt.id_client=acm_saldoakt_tbl.id_client and
         cnt.id_pref=acm_saldoakt_tbl.id_pref and
         cnt.mmgg=acm_saldoakt_tbl.mmgg and acm_saldoakt_tbl.mmgg=monclose
             and  acm_saldoakt_tbl.mmgg_p=cnt.mmgg_pay
             and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

update acm_saldoakt_tbl set  e_val=b_val+dt_val-kt_val,
                         e_valtax=b_valtax+dt_valtax-kt_valtax,
                         calc=1
       where    acm_saldoakt_tbl.mmgg=monclose
             and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

delete from acm_saldoakt_tbl where mmgg>monclose;

insert into acm_saldoakt_tbl  (dt,id_client,id_pref,mmgg,mmgg_p,b_val,b_valtax)
     select distinct now(), id_client, id_pref, 
      monclose+interval ''1 month'' as mmgg, mmgg_p,e_val,e_valtax 
      from acm_saldoakt_tbl s where mmgg=monclose;

raise notice ''===========next month============='';

insert into acm_saldoakt_tbl (id_client,id_pref,mmgg,mmgg_p)
     select distinct coalesce(pp.id_client,bb.id_client) as id_client,
           coalesce(pp.id_pref,bb.id_pref) as id_pref, 
           coalesce(pp.mmgg,bb.mmgg) as mmgg,             
           coalesce(pp.mmgg_pay,bb.mmgg_bill) as mmgg_p
     from 
       (select distinct b.id_client,b.id_pref, b.mmgg,
              b.mmgg_bill
             from ( select * from acm_bill_tbl where mmgg=monclose +interval ''1 month'' 
                  and 
                   idk_doc=(select id from dci_document_tbl where ident = ''bill_act'' )
                  ) as b 
               left join acm_saldoakt_tbl  s1 
            on (s1.mmgg=monclose +interval ''1 month'' and  
                s1.id_client=b.id_client and s1.id_pref=b.id_pref and
                s1.mmgg_p=b.mmgg_bill
             )
            where s1.id is null
       ) as bb 
       full join 
        (select p.id_client,p.id_pref, p.mmgg,p.mmgg_pay
             from ( select * from acm_pay_tbl where mmgg=monclose +interval ''1 month'' 
and 
                   idk_doc in 
                (select id from dci_document_tbl    where (ident = ''pay_act'' or ident=''wr_off_act'' ))
                  ) as p
               left join acm_saldoakt_tbl  s1 
            on (s1.mmgg=monclose +interval ''1 month'' and
                s1.id_client=p.id_client and s1.id_pref=p.id_pref and
                s1.mmgg_p=p.mmgg_pay
             )
            where s1.id is null
       ) as pp
      on (pp.id_client=bb.id_client and bb.id_pref=pp.id_pref
           and bb.mmgg=pp.mmgg and  bb.mmgg_bill=pp.mmgg_pay);


raise notice ''update saldoakt dt'';

update acm_saldoakt_tbl set dt_val=coalesce(cnt.dt_val,0),
                         dt_valtax=coalesce(cnt.dt_valtax,0),
                         kvt=coalesce(cnt.demand_val,0)
       from 
          (select d.id_client as id_client,
           d.id_pref as id_pref ,
           d.mmgg as mmgg,d.mmgg_bill,
           sum(d.value) as dt_val,sum(d.value_tax) as dt_valtax,
           sum(d.demand_val) as demand_val
           from acm_bill_tbl as d 
             where d.mmgg=monclose+ interval ''1 month '' and d.idk_doc   in 
                (select id from dci_document_tbl    where (ident = ''pay_act'' or ident=''wr_off_act'' ))
           group by d.id_client,d.id_pref ,d.mmgg,d.mmgg_bill ) as cnt
       where   cnt.id_client=acm_saldoakt_tbl.id_client and
         cnt.id_pref=acm_saldoakt_tbl.id_pref and
         cnt.mmgg=acm_saldoakt_tbl.mmgg and 
         cnt.mmgg_bill=acm_saldoakt_tbl.mmgg_p and 
         acm_saldoakt_tbl.mmgg=monclose +interval ''1 month''
       and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

raise notice ''update saldo kt'';

update acm_saldoakt_tbl set  kt_val=coalesce(cnt.kt_val,0),
                         kt_valtax=coalesce(cnt.kt_valtax,0)
       from 
          (select  k.id_client as id_client,
           k.id_pref as id_pref ,
           k.mmgg as mmgg,
           k.mmgg_pay as mmgg_pay,
           sum(k.value) as kt_val, sum(k.value_tax) as kt_valtax
           from  acm_pay_tbl as k 
            where k.mmgg=monclose + interval ''1 month'' and k.idk_doc in 
                (select id from dci_document_tbl    where (ident = ''pay_act'' or ident=''wr_off_act'' ))
           group by k.id_client,k.id_pref,k.mmgg,k.mmgg_pay ) as cnt
       where   cnt.id_client=acm_saldoakt_tbl.id_client and
         cnt.id_pref=acm_saldoakt_tbl.id_pref and
         cnt.mmgg=acm_saldoakt_tbl.mmgg 
           and  acm_saldoakt_tbl.mmgg=monclose +interval ''1 month''
             and acm_saldoakt_tbl.mmgg_p = cnt.mmgg_pay
             and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

update acm_saldoakt_tbl set  e_val=b_val+dt_val-kt_val,
                         e_valtax=b_valtax+dt_valtax-kt_valtax,
                         calc=1
       where    acm_saldoakt_tbl.mmgg=monclose +interval ''1 month''
             and acm_saldoakt_tbl.mmgg>''2006-08-01''; 

return true;
end;
' language 'plpgsql';