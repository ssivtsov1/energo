drop function del_nall_inf1(date);
drop function del_nall_inf1(date,date);
create or replace function del_nall_inf1(date,date) Returns boolean As '
Declare
mg Alias for $1;
mg_pay Alias for $2;
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
begin

delete from del_ind;
delete from del_doc;
Raise NOtice ''ins1'';
insert into del_ind(id_ind,id_doc,id_prv)
select distinct a.id_doc as id_ind,c.id_doc,1 as id_prv 
  from acm_headindication_tbl as a 
  inner join 
  (select a1.* from clm_client_tbl as a1 where a1.book=-1
    ) as b 
   on (a.id_client=b.id) 
   left join acm_bill_tbl as c on (a.id_doc=c.id_ind and a.id_client=c.id_client) 
  where a.mmgg>=mg;

Raise NOtice ''ins2'';
insert into del_ind(id_ind,id_doc,id_prv)
select distinct a.id as id_ind,c.id_doc,0 as id_prv 
  from acd_indication_tbl as a 
  inner join 
  (select a1.* from clm_client_tbl as a1 where a1.book<>-1
    ) as b 
   on (a.id_client=b.id) 
   left join acm_bill_tbl as c on (a.id=c.id_ind and a.id_client=c.id_client) 
  where a.mmgg>=mg;

Raise NOtice ''ins3'';
insert into del_ind(id_ind,id_prv)
select distinct a.id_doc as id_ind,1 from acd_indication_tbl as a inner join 
  (select a2.* from del_ind as a1 inner join acd_indication_tbl as a2 
    on (a1.id_ind=a2.id_doc) where a1.id_prv=1) as b on (a.id=b.id_previndic) 
  left join del_ind as c on (c.id_ind=a.id_doc) where c.id_ind is null 
    and c.id_prv=1;

Raise NOtice ''ins4'';
insert into del_ind(id_ind,id_prv)
select distinct a.id as id_ind,0 from acd_indication_tbl as a inner join 
  (select a2.* from del_ind as a1 inner join acd_indication_tbl as a2 
    on (a1.id_ind=a2.id_doc) where a1.id_prv=0) as b on (a.id=b.id_previndic) 
  left join del_ind as c on (c.id_ind=a.id) where c.id_ind is null 
    and c.id_prv=0;

Raise NOtice ''ins5_1'';

insert into del_doc(id_doc,id_ind) 
select distinct a2.id_doc,coalesce(a2.id,0) from 
(select distinct b.id_doc,b.id 
  from del_ind as a inner join 
   (select b1.id_doc,b1.id,0 as priv
     from acd_indication_tbl as b1 inner join acm_headindication_tbl as b2 
    on (b1.id_doc=b2.id_doc) where b2.flag_priv) as b
  on (a.id_prv=b.priv and a.id_ind=b.id)) as a1
 right join acd_indication_tbl as a2 on (a1.id_doc=a2.id_doc and a1.id=a2.id) 
  inner join acm_headindication_tbl as a3 on (a3.id_doc=a2.id_doc)
 where a1.id_doc is null and a3.flag_priv; 

Raise NOtice ''ins5_2'';

insert into del_doc(id_doc,id_ind) 
select distinct a2.id_doc,coalesce(a2.id,0) from 
(select distinct b.id_doc,b.id 
  from del_ind as a inner join 
   (select b1.id_doc,b1.id,1 as priv
     from acd_indication_tbl as b1 inner join acm_headindication_tbl as b2 
    on (b1.id_doc=b2.id_doc) where not b2.flag_priv) as b
  on (a.id_prv=b.priv and a.id_ind=b.id_doc)) as a1
 right join acd_indication_tbl as a2 on (a1.id_doc=a2.id_doc and a1.id=a2.id)
  inner join acm_headindication_tbl as a3 on (a3.id_doc=a2.id_doc)
 where a1.id_doc is null and not a3.flag_priv; 

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
delete from acd_billsum_del;
delete from acd_calc_losts_del;
delete from acd_clc_inf_del;
delete from acd_kateg_del;
delete from acd_met_kndzn_del;
delete from acd_pnt_tarif_del;
delete from acd_point_branch_del;
delete from acd_pwr_demand_del;
delete from acm_bill_del;

delete from acm_billtax_tbl;

delete from acm_bill_tbl where not exists (select a.id_doc 
  from del_ind as a where a.id_doc=acm_bill_tbl.id_doc);

delete from acd_billsum_tbl where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_billsum_tbl.id_doc);
delete from acd_calc_losts_tbl where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_calc_losts_tbl.id_doc);
delete from acd_clc_inf where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_clc_inf.id_doc);
delete from acd_kateg_tbl where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_kateg_tbl.id_doc);
delete from acd_met_kndzn_tbl where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_met_kndzn_tbl.id_doc);
delete from acd_pnt_tarif where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_pnt_tarif.id_doc);
delete from acd_point_branch_tbl where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_point_branch_tbl.id_doc);
delete from acd_pwr_demand_tbl where not exists (select a.id_doc 
  from acm_bill_tbl as a where a.id_doc=acd_pwr_demand_tbl.id_doc);
update acd_billsum_tbl set sum_val=0,p1=0,p2=0,p3=0 where mmgg<mg_pay;
update acm_bill_tbl set value=0,value_tax=0 where mmgg<mg_pay;

----indic
Raise Notice ''indic'';
delete from acd_indication_tbl where exists (select id_ind from del_doc as a 
 where a.id_ind=acd_indication_tbl.id);

Raise Notice ''indic1'';
delete from acm_headindication_tbl where exists (select distinct id_doc from del_doc as a 
 where a.id_doc=acm_headindication_tbl.id_doc);
----pays
Raise Notice ''pays'';
delete from acd_acctarsum_tbl;
delete from acd_partarif_tbl;
delete from acd_addsubs_tbl;
delete from acd_subs_tbl;
delete from acm_subs_tbl;
delete from acm_salsubs_tbl;
delete from acm_headsum_tbl;
delete from acm_billpay_tbl;
delete from acm_pay_tbl where mmgg<mg_pay; 
delete from acm_headpay_tbl where mmgg<mg_pay;
-----tax
Raise Notice ''tax'';
delete from acd_tax_tbl;
delete from acd_taxcorrection_tbl;
delete from acm_taxadvcor_tbl;
delete from acm_taxcorrection_tbl;
delete from acm_tax_tbl;
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

select del_nall_inf1('2005-05-01','2005-08-01');
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
select now(); 

