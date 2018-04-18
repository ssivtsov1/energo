--input - idcl,dtb,dte
alter table acm_headindication_tbl add column id_main_ind int;
alter table acd_indication_tbl add column id_main_ind int;

drop function conn_tree(int,date,date,int);
drop function conn_tree(int);
create function conn_tree(int) Returns boolean As '
Declare
--idcl Alias for $1;
--dtb Alias for $2;
--dte Alias for $3;
--mg Alias for $4;
id_mind Alias for $1;
fl_up int;
fl_down int;
r record;
r12 record;
r13 record;
rs boolean;
rs1 text;
cdt_b date;
cdt_e date;
w_dtb date;
idcl int;
dtb date;
dte date;
w_dte date;
idres int;
idbal int;
i int;
ppnt int;
begin

rs:=del_eqtmp_t(0,0);

select into idres int4(value_ident) from syi_sysvars_tbl where ident=''id_res'';
select into idbal int4(value_ident) from syi_sysvars_tbl where ident=''id_bal'';

for r13 in select a.*,b.id as idk from acm_headindication_tbl as a left join 
   (select id from dci_document_tbl where ident=''rep_bound'') as b on true 
     where id_doc=id_mind loop 

idcl:=r13.id_client;
dte:=r13.date_end;
dtb:=date_mii(r13.date_end::date,1);

fl_up:=0;
fl_down:=0;
-------------------- ins into act_eqp_branch_tbl
insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 

select distinct a_12.id,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e   
  ,coalesce(a4.id_rclient,a_12.id_client),a_12.id_client,a_12.line_no
  ,0
from 
(select distinct a1.id,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no
     from 
(select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h
  where id_client=idcl and coalesce(dt_e,dte)>dtb and dt_b<dte) as a1
 inner join 
(select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte) as a2 
 on (a1.id=a2.id_tree and (a1.dt_b<a2.dt_e and a1.dt_e>a2.dt_b))
 ) as a_12
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,dte)>dtb and dt_b<dte) as a3
  on (a3.id=a_12.code_eqp)
 left join (select code_eqp,id_client as id_rclient,case when dt_b<=dtb 
  then dtb else dt_b end as dt_b
 ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e 
  from eqm_eqp_use_h where coalesce(dt_e,dte)>dtb and dt_b<dte) as a4
 on (a_12.code_eqp=a4.code_eqp and a_12.dt_b<a4.dt_e and a_12.dt_e>a4.dt_b);

insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 

select  distinct a_12.id_tree,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e 
  ,a_12.id_client,a4.id_client,a_12.line_no 
  ,0
from 
(select  a2.id_tree,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no
 from 
(select code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e,id_client 
  from eqm_eqp_use_h where id_client = idcl 
    and coalesce(dt_e,dte)>dtb and dt_b<dte) as a1 
 inner join 
(select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte) as a2 
 on (a1.code_eqp=a2.code_eqp and (a2.dt_b<a1.dt_e and a2.dt_e>a1.dt_b))
 ) as a_12
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,dte)>dtb and dt_b<dte) as a3
  on (a3.id=a_12.code_eqp)
 inner join
(select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h 
  where id_client<>idcl and coalesce(dt_e,dte)>dtb and dt_b<dte) as a4
 on (a_12.id_tree=a4.id and a4.dt_b<a_12.dt_e and a4.dt_e>a_12.dt_b) 
  where not (a3.type_eqp=9 and a_12.code_eqp_e is null);-----050322
---------sel connected abn id_tree down the scheme

for r in select distinct a1.code_eqp,a1.dat_b as dtb1,a1.dat_e as dte1,a2.id_tree,a1.id_client,a1.id_rclient 
  from  
(select * from act_eqp_branch_tbl where type_eqp=9 
 and id_p_eqp is not null) as a1 
 inner join 
  (select b2.id_client,b1.id_tree,b1.code_eqp 
    ,case when b2.dt_b<=b1.dt_b then b1.dt_b else b2.dt_b end as dt_b
    ,case when b2.dt_e>=b1.dt_e then b1.dt_e else b2.dt_e end as dt_e   
    ,b1.code_eqp_e,b1.line_no
    from 
 (select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)
  as b1 
   inner join 
 (select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli) 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)  
  as b2 
   on (b1.id_tree=b2.id and b2.dt_b<b1.dt_e and b2.dt_e>b1.dt_b)
 ) as a2 
   on (a1.code_eqp=a2.code_eqp and a1.id_tree<>a2.id_tree and a2.dt_b<a1.dat_e 
    and a2.dt_e>a1.dat_b) 
  where a2.id_client<>a1.id_client and a2.id_client<>a1.id_rclient 
        and a2.id_client<>idres and a2.id_client  not in (select id from clm_client_tbl where flag_balance=1)
 loop
Raise notice ''r.code_eqp - %'',r.code_eqp;
   fl_down:=1; 

insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 

select distinct a_12.id,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e 
  ,coalesce(a4.id_rclient,a_12.id_client),a_12.id_client,a_12.line_no
  ,0
from 
(select distinct a1.id,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no 
     from 
(select id,code_eqp,case when dt_b<=r.dtb1 then r.dtb1 else dt_b end as dt_b
  ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli)  
  where id=r.id_tree and ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a1
 inner join 
(select id_tree,code_eqp,case when dt_b<=r.dtb1 then r.dtb1 else dt_b end as dt_b
  ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a2 
  on (a1.id=a2.id_tree and (a1.dt_b<a2.dt_e and a1.dt_e>a2.dt_b))
 ) as a_12 
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,r.dte1)>r.dtb1 and dt_b<r.dte1) as a3
  on (a3.id=a_12.code_eqp)
 left join (select code_eqp,id_client as id_rclient,case when dt_b<=r.dtb1 
  then r.dtb1 else dt_b end as dt_b
 ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e 
  from eqm_eqp_use_h where ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a4
 on (a_12.code_eqp=a4.code_eqp and a_12.dt_b<a4.dt_e and a_12.dt_e>a4.dt_b) --;
  where coalesce(a4.id_rclient,0)<>idcl;

end loop;
----sel up the tree
/*
fl_up:=1;
while (fl_up=1) loop
fl_up:=0;
for r in select distinct --a1.code_eqp,
  a1.dat_b as dtb1,a1.dat_e as dte1,a2.id_tree,a1.id_client,id_rclient 
  from  
(select c1.* from (select * from act_eqp_branch_tbl where  type_eqp=9 
  and id_p_eqp is null) as c1 left join (select * from 
  act_eqp_branch_tbl where type_eqp=9 and id_p_eqp is not null) as c2
 on (c1.code_eqp=c2.code_eqp) where c2.code_eqp is null) as a1 
 inner join 
  (select b1_2.id_client,b1_2.id_tree,b1_2.code_eqp 
    ,case when b1_2.dt_b<=b3.dt_b then b3.dt_b else b1_2.dt_b end as dt_b
    ,case when b1_2.dt_e>=b3.dt_e then b3.dt_e else b1_2.dt_e end as dt_e   
    ,b1_2.code_eqp_e,b1_2.line_no 
  from 

  (select b2.id_client,b1.id_tree,b1.code_eqp 
    ,case when b2.dt_b<=b1.dt_b then b1.dt_b else b2.dt_b end as dt_b
    ,case when b2.dt_e>=b1.dt_e then b1.dt_e else b2.dt_e end as dt_e   
    ,b1.code_eqp_e,b1.line_no
  from
 (select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)
    as b1 inner join 
 (select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli) 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)  
  as b2 
   on (b1.id_tree=b2.id and b2.dt_b<b1.dt_e and b2.dt_e>b1.dt_b)
) as b1_2
     left join 
 (select code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e,id_client 
  from eqm_eqp_use_h where coalesce(dt_e,dte)>dtb and dt_b<dte)
     as b3 
      on (b1_2.code_eqp=b3.code_eqp and b1_2.dt_b<=b3.dt_b and b1_2.dt_e>=b3.dt_e) 
    left join (select distinct id_tree from act_eqp_branch_tbl where type_eqp=9 
                and id_p_eqp is not null and id_client<>idcl) as b4
      on (b1_2.id_tree=b4.id_tree)

     where b4.id_tree is null and not (b1_2.id_client in (idres,idbal) and b3.code_eqp is null)

    ) as a2 
   on (a1.code_eqp=a2.code_eqp and a1.id_tree<>a2.id_tree and a2.dt_b<a1.dat_e 
    and a2.dt_e>a1.dat_b) loop 

Raise notice ''up r.id_tree - %'',r.id_tree;
  fl_up:=1;
insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 

select distinct a_12.id,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e 
  ,coalesce(a4.id_rclient,a_12.id_client),a_12.id_client,a_12.line_no
  ,0
from 
(select distinct a1.id,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no
     from 
(select id,code_eqp,case when dt_b<=r.dtb1 then r.dtb1 else dt_b end as dt_b
  ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli) 
  where id=r.id_tree and ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a1
 inner join 
(select id_tree,code_eqp,case when dt_b<=r.dtb1 then r.dtb1 else dt_b end as dt_b
  ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a2 
 on (a1.id=a2.id_tree and (a1.dt_b<a2.dt_e and a1.dt_e>a2.dt_b))
 ) as a_12
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,r.dte1)>r.dtb1 and dt_b<r.dte1) as a3
  on (a3.id=a_12.code_eqp)
 left join (select code_eqp,id_client as id_rclient,case when dt_b<=r.dtb1 
  then r.dtb1 else dt_b end as dt_b
 ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e 
  from eqm_eqp_use_h where ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a4
 on (a_12.code_eqp=a4.code_eqp and a_12.dt_b<a4.dt_e and a_12.dt_e>a4.dt_b) 
 where ((a_12.id_client<>idres and a_12.id_client<>idbal)  
       or ((a_12.id_client=idres or a_12.id_client=idbal) and a4.id_rclient=r.id_client))
       and not (coalesce(a4.id_rclient,a_12.id_client)<>a_12.id_client 
         and coalesce(a4.id_rclient,a_12.id_client)=idcl);

end loop;

end loop; ----while
  */
-------all down 
fl_down:=1;
while (fl_down=1) loop
   fl_down:=0;
for r in select distinct a1.code_eqp,
  a1.dat_b as dtb1,a1.dat_e as dte1,a2.id_tree,a1.id_client,a1.id_rclient 
  from  
(select * from act_eqp_branch_tbl where type_eqp=9 
 and id_p_eqp is not null and id_client<>idcl) as a1 
 inner join 
  (select b2.id_client,b1.id_tree,b1.code_eqp 
    ,case when b2.dt_b<=b1.dt_b then b1.dt_b else b2.dt_b end as dt_b
    ,case when b2.dt_e>=b1.dt_e then b1.dt_e else b2.dt_e end as dt_e   
    ,b1.code_eqp_e,b1.line_no
    from 
 (select id_tree,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)
  as b1 
   inner join 
 (select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli) 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)  
  as b2 
   on (b1.id_tree=b2.id and b2.dt_b<b1.dt_e and b2.dt_e>b1.dt_b)
    left join (select distinct id_tree from act_eqp_branch_tbl where type_eqp=9 
                and id_p_eqp is null and id_client<>idcl) as b3
      on (b1.id_tree=b3.id_tree)
     where id_client<>idcl and b3.id_tree is null) as a2 

   on (a1.code_eqp=a2.code_eqp and a1.id_tree<>a2.id_tree and a2.dt_b<a1.dat_e 
    and a2.dt_e>a1.dat_b) loop 

Raise Notice ''down2 - %'',r.code_eqp;
  fl_down:=1; 
insert into act_eqp_branch_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,dat_b,dat_e
  ,id_client,id_rclient,line_no,loss_power) 
select distinct a_12.id,a_12.code_eqp,a_12.code_eqp_e,a3.type_eqp
  ,a_12.dt_b,a_12.dt_e
  ,coalesce(a4.id_rclient,a_12.id_client),a_12.id_client,a_12.line_no
  ,0
from 
(select distinct a1.id,a2.code_eqp,a2.code_eqp_e
  ,case when a1.dt_b<=a2.dt_b then a2.dt_b else a1.dt_b end as dt_b
  ,case when a1.dt_e>=a2.dt_e then a2.dt_e else a1.dt_e end as dt_e
  ,a1.id_client,a2.line_no
     from 
(select id,code_eqp,case when dt_b<=r.dtb1 then r.dtb1 else dt_b end as dt_b
  ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli) 
  where id=r.id_tree and ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a1
 inner join 
(select id_tree,code_eqp,case when dt_b<=r.dtb1 then r.dtb1 else dt_b end as dt_b
  ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e
  ,code_eqp_e,line_no from eqm_eqp_tree_h 
  where ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a2 
 on (a1.id=a2.id_tree and (a1.dt_b<a2.dt_e and a1.dt_e>a2.dt_b))
 ) as a_12
 inner join 
 (select distinct id,type_eqp from eqm_equipment_h where 
 coalesce(dt_e,r.dte1)>r.dtb1 and dt_b<r.dte1) as a3
  on (a3.id=a_12.code_eqp)
 left join (select code_eqp,id_client as id_rclient,case when dt_b<=r.dtb1 
  then r.dtb1 else dt_b end as dt_b
 ,case when coalesce(dt_e,r.dte1)>=r.dte1 then r.dte1 else dt_e end as dt_e 
  from eqm_eqp_use_h where ((dt_e is null or dt_e>=r.dtb1) and dt_b<r.dte1)) as a4
 on (a_12.code_eqp=a4.code_eqp and a_12.dt_b<a4.dt_e and a_12.dt_e>a4.dt_b) 
  where a4.id_rclient is null or a4.id_rclient<>idcl;

end loop;

end loop; ---while

----update loss_power
Raise notice ''1'';
update act_eqp_branch_tbl set loss_power=k.loss_power 
 from (select distinct k1.id,k1.loss_power 
    from eqm_equipment_h as k1 inner join (select * from act_eqp_branch_tbl 
    where type_eqp in (2,6,7)) as k2 on (k1.id=k2.code_eqp 
    and coalesce(k1.dt_e,k2.dat_e)>k2.dat_b 
    and k1.dt_b<k2.dat_e and k1.loss_power=1)) as k 
 where k.id=act_eqp_branch_tbl.code_eqp;

---delete double borders
Raise notice ''2'';
update act_eqp_branch_tbl set id_client=a.id_client,id_rclient=a.id_rclient
 ,id_rtree=a.id_tree 
 from act_eqp_branch_tbl as a where a.id_p_eqp is null and a.type_eqp=9 
   and act_eqp_branch_tbl.code_eqp=a.code_eqp 
   and act_eqp_branch_tbl.id_p_eqp is not null;

Raise notice ''3'';
delete from act_eqp_branch_tbl where type_eqp=9 and id_p_eqp is null and 
 exists (select code_eqp from act_eqp_branch_tbl as a where type_eqp=9 and 
  id_p_eqp is not null and a.code_eqp=act_eqp_branch_tbl.code_eqp);
-----upd up-lvl eqp
Raise notice ''4'';
update act_eqp_branch_tbl set id_p_eqp=null where not exists 
 (select code_eqp from act_eqp_branch_tbl as a 
    where a.code_eqp=act_eqp_branch_tbl.id_p_eqp) and id_p_eqp is not null;

------- sel_point_tree
Raise notice ''5'';
for r in select b.* from act_eqp_branch_tbl as b where (id_p_eqp is null 
   and id_client=idcl) or (id_p_eqp is not null and id_client=idcl and 
    exists (select code_eqp from act_eqp_branch_tbl as a
     where a.code_eqp=b.id_p_eqp and a.id_client<>idcl)) loop
   rs:=pnt_tree(r.code_eqp,null,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,r.id_client,r.id_tree);
end loop;

--------sel all calc parameters
------------???????---check parameters 
---act_pnt_lost
Raise notice ''6'';
insert into act_pnt_lost 
select case when k1.code_eqp is null then k2.code_eqp else k1.code_eqp 
  end as code_eqp
 ,case when k1.code_eqp is null then 0 else 1 end as count_lost
 ,case when k1.code_eqp is null then k2.dat_b else k1.dat_b end as dat_b
 ,case when k1.code_eqp is null then k2.dat_e else k1.dat_e end as dat_e
from 
 (select a.code_eqp,count(*),b.dat_b,b.dat_e from 
 eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.count_lost=1 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k1
  full outer join 
 (select a.code_eqp,count(*),b.dat_b,b.dat_e from 
 eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.count_lost=0 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k2
 on (k1.code_eqp=k2.code_eqp);

---main_losts
Raise notice ''7'';
insert into act_pnt_mlost 
select case when k1.code_eqp is null then k2.code_eqp else k1.code_eqp 
  end as code_eqp
 ,case when k1.code_eqp is null then 0 else 1 end as main_losts
 ,case when k1.code_eqp is null then k2.dat_b else k1.dat_b end as dat_b
 ,case when k1.code_eqp is null then k2.dat_e else k1.dat_e end as dat_e
from 
 (select a.code_eqp,count(*),b.dat_b,b.dat_e from 
 eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.main_losts=1 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k1
  full outer join 
 (select a.code_eqp,count(*),b.dat_b,b.dat_e from 
 eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.main_losts=0 
  or a.main_losts is null 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k2
 on (k1.code_eqp=k2.code_eqp);
---main_losts
------------???????---check parameters 

---------sel up points--------
Raise notice ''9'';
for r in select distinct a.*,d.id_p_eqp from act_point_branch_tbl as a 
 inner join act_pnt_lost as b 
 on (a.id_point=b.id_point and a.dat_b<=b.dat_b and a.dat_e>=b.dat_e) 
 left join act_pnt_share as c 
 on (a.id_point=c.id_point and a.dat_b<=b.dat_b and a.dat_e>=b.dat_e) 
 inner join act_eqp_branch_tbl as d 
 on (a.id_point=d.code_eqp and d.dat_b<=a.dat_b and d.dat_e>=a.dat_e)  
  where id_p_point is null loop 
 rs:=up_pnt(r.id_p_eqp,r.id_point,r.dat_b,r.dat_e,0);
end loop;
------- sel_additional_point_tree
Raise notice ''10'';
for r in select b.* from act_eqp_branch_tbl as b inner join 
   act_point_branch_tbl as a on (a.id_point=b.id_p_eqp) where a.id_client<>idcl 
  and a.id_p_point is null loop
   rs:=pnt_tree(r.code_eqp,r.id_p_eqp,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,r.id_client,r.id_tree);
end loop;
Raise notice ''11'';
for r in select * from act_eqp_branch_tbl where id_client<>idcl 
  and type_eqp=2 and loss_power=1 loop
   rs:=pnt_tree(r.code_eqp,null,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,r.id_client,r.id_tree);
end loop;
------- sel_additional_point_tree

---act_pnt_lost
Raise notice ''12'';
insert into act_pnt_lost 
select case when k1.code_eqp is null then k2.code_eqp else k1.code_eqp 
  end as code_eqp
 ,case when k1.code_eqp is null then 0 else 1 end as count_lost
 ,case when k1.code_eqp is null then k2.dat_b else k1.dat_b end as dat_b
 ,case when k1.code_eqp is null then k2.dat_e else k1.dat_e end as dat_e
from 
 (select a.code_eqp,count(*) as cnt1,b.dat_b,b.dat_e from 
 eqm_point_h as a inner join (select a1.* from act_point_branch_tbl as a1 
  left join (select distinct id_point from act_pnt_lost) as a2 
    on (a1.id_point=a2.id_point) where a2.id_point is null) as b
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.count_lost=1 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k1
  full outer join 
 (select a.code_eqp,count(*) as cnt0,b.dat_b,b.dat_e from 
 eqm_point_h as a inner join (select a1.* from act_point_branch_tbl as a1 
  left join (select distinct id_point from act_pnt_lost) as a2 
    on (a1.id_point=a2.id_point) where a2.id_point is null) as b
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.count_lost=0 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k2
 on (k1.code_eqp=k2.code_eqp);

---main_losts
Raise notice ''13'';
insert into act_pnt_mlost 
select case when k1.code_eqp is null then k2.code_eqp else k1.code_eqp 
  end as code_eqp
 ,case when k1.code_eqp is null then 0 else 1 end as main_losts
 ,case when k1.code_eqp is null then k2.dat_b else k1.dat_b end as dat_b
 ,case when k1.code_eqp is null then k2.dat_e else k1.dat_e end as dat_e
from 
 (select a.code_eqp,count(*),b.dat_b,b.dat_e from 
 eqm_point_h as a inner join (select a1.* from act_point_branch_tbl as a1 
  left join (select distinct id_point from act_pnt_mlost) as a2 
    on (a1.id_point=a2.id_point) where a2.id_point is null) as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.main_losts=1 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k1
  full outer join 
 (select a.code_eqp,count(*),b.dat_b,b.dat_e from 
 eqm_point_h as a inner join (select a1.* from act_point_branch_tbl as a1 
  left join (select distinct id_point from act_pnt_mlost) as a2 
    on (a1.id_point=a2.id_point) where a2.id_point is null) as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) where a.main_losts=0 
  or a.main_losts is null 
   group by a.code_eqp,b.dat_b,b.dat_e having count(*)>0) as k2
 on (k1.code_eqp=k2.code_eqp);
---main_losts
------update act_point_branch_tbl
Raise Notice ''update act_point_branch_tbl begin'';
Raise notice ''15'';
cdt_b:=null;
for r in select b.mdat_b,c.mdat_e,d.* 
      from (select id_point,id_p_point,id_client
       ,id_rclient,count(*) as cnt 
       from act_point_branch_tbl group by id_point,id_p_point,id_client
          ,id_rclient having count(*)>1) as a 
        inner join (select id_point,min(dat_b) as mdat_b,id_p_point,id_client
       ,id_rclient from act_point_branch_tbl 
        group by id_point,id_p_point,id_client
       ,id_rclient) as b on (a.id_point=b.id_point 
         and coalesce(a.id_p_point,0)=coalesce(b.id_p_point,0) 
         and a.id_client=b.id_client and a.id_rclient=b.id_rclient) 
        inner join (select id_point,max(dat_e) as mdat_e,id_p_point,id_client
       ,id_rclient from act_point_branch_tbl 
        group by id_point,id_p_point,id_client
       ,id_rclient) as c on (a.id_point=c.id_point 
         and coalesce(a.id_p_point,0)=coalesce(c.id_p_point,0) 
         and a.id_client=c.id_client and a.id_rclient=c.id_rclient) 
        inner join act_point_branch_tbl as d on (a.id_point=d.id_point 
         and coalesce(a.id_p_point,0)=coalesce(d.id_p_point,0) 
         and a.id_client=d.id_client and a.id_rclient=d.id_rclient)
       order by d.id_point,d.id_p_point,d.id_client,d.id_rclient,d.dat_b
       loop 
 Raise Notice ''id_pnt - %'',r.id_point;
 if r.dat_b=r.mdat_b and cdt_b is null then 
   cdt_b:=r.mdat_b;
   cdt_e:=r.dat_e;
 else 
   if r.dat_b=cdt_e then 
    Raise Notice ''update'';
     update act_point_branch_tbl set dat_e=r.dat_e where id_point=r.id_point 
      and coalesce(id_p_point,0)=coalesce(r.id_p_point,0)  
      and id_client=r.id_client 
      and id_rclient=r.id_rclient and dat_b=cdt_b;
     delete from act_point_branch_tbl where  id_point=r.id_point 
      and coalesce(id_p_point,0)=coalesce(r.id_p_point,0)  
      and id_client=r.id_client 
      and id_rclient=r.id_rclient and dat_b=r.dat_b;
     cdt_e:=r.dat_e;
    if r.dat_e=r.mdat_e then
      cdt_b:=null;
      cdt_e:=null;
    end if;
   end if;
 end if;  
end loop;
Raise Notice ''update act_point_branch_tbl end'';
------update act_point_branch_tbl
--act_meter_pnt_tbl
Raise notice ''16'';
insert into act_meter_pnt_tbl 
select b.id_point,a.code_eqp
 ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
 ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
from (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)=1) as a2 on (a1.code_eqp=a2.code_eqp) 
 ) as a inner join act_point_branch_tbl as b 
 on (a.id_p_eqp=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e)  
 where a.type_eqp=1--;
union
---!!!---------
---insert into act_meter_pnt_tbl 
select a1.id_point,a2.code_eqp
 ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
 ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e 
from 
 (select a.code_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e)  
   where a.type_eqp=10) as a1 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)=1) as a2 on (a1.code_eqp=a2.code_eqp)) as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<=a2.dat_b and a1.dat_e>=a2.dat_e) 
  where a2.type_eqp=1--;
union 
---insert into act_meter_pnt_tbl 
select a3.id_point,a4.code_eqp
 ,case when a4.dat_b<=a3.dat_b then a3.dat_b else a4.dat_b end as dat_b
 ,case when a4.dat_e>=a3.dat_e then a3.dat_e else a4.dat_e end as dat_e 
from 
 (select a2.code_eqp,a2.type_eqp,a1.id_point
   ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e 
  from
 (select a.code_eqp,a.type_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e)  
   where a.type_eqp=10) as a1 inner join act_eqp_branch_tbl as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<=a2.dat_b and a1.dat_e>=a2.dat_e) 
  where a2.type_eqp=10) as a3 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)=1) as a2 on (a1.code_eqp=a2.code_eqp)) as a4 
   on (a4.id_p_eqp=a3.code_eqp and a3.dat_b<=a4.dat_b and a3.dat_e>=a4.dat_e) 
  where a4.type_eqp=1;

Raise notice ''17'';
for r in select * from (
   select b.id_point,a.code_eqp as id_meter
 ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
 ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
from (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)>1) as a2 on (a1.code_eqp=a2.code_eqp) 
 ) as a inner join act_point_branch_tbl as b 
 on (a.id_p_eqp=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e)  
 where a.type_eqp=1
union 
select a1.id_point,a2.code_eqp as id_meter
 ,case when a2.dat_b<=a1.dat_b then a1.dat_b else a2.dat_b end as dat_b
 ,case when a2.dat_e>=a1.dat_e then a1.dat_e else a2.dat_e end as dat_e 
from 
 (select a.code_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e)  
   where a.type_eqp=10) as a1 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)>1) as a2 on (a1.code_eqp=a2.code_eqp)) as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<=a2.dat_b and a1.dat_e>=a2.dat_e) 
  where a2.type_eqp=1
union  
select a3.id_point,a4.code_eqp as id_meter
 ,case when a4.dat_b<=a3.dat_b then a3.dat_b else a4.dat_b end as dat_b
 ,case when a4.dat_e>=a3.dat_e then a3.dat_e else a4.dat_e end as dat_e 
from 
 (select a2.code_eqp,a2.type_eqp,a1.id_point
   ,case when a1.dat_b<=a2.dat_b then a2.dat_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>=a2.dat_e then a2.dat_e else a1.dat_e end as dat_e 
  from
 (select a.code_eqp,a.type_eqp,b.id_point
   ,case when a.dat_b<=b.dat_b then b.dat_b else a.dat_b end as dat_b
   ,case when a.dat_e>=b.dat_e then b.dat_e else a.dat_e end as dat_e 
  from 
   act_eqp_branch_tbl as a inner join act_point_branch_tbl as b 
   on (a.id_p_eqp=b.id_point and b.dat_b<=a.dat_b and b.dat_e>=a.dat_e)  
   where a.type_eqp=10) as a1 inner join act_eqp_branch_tbl as a2 
   on (a2.id_p_eqp=a1.code_eqp and a1.dat_b<=a2.dat_b and a1.dat_e>=a2.dat_e) 
  where a2.type_eqp=10) as a3 inner join (select a1.* from act_eqp_branch_tbl as a1 inner join 
  (select count(*),code_eqp from act_eqp_branch_tbl where type_eqp=1 
   group by code_eqp having count(*)>1) as a2 on (a1.code_eqp=a2.code_eqp)) as a4 
   on (a4.id_p_eqp=a3.code_eqp and a3.dat_b<=a4.dat_b and a3.dat_e>=a4.dat_e) 
  where a4.type_eqp=1 ) as k
 order by k.id_point,k.id_meter,k.dat_b
 loop
Raise notice ''17-1  %    %'',r.id_point,r.id_meter;
  insert into act_meter_pnt_tbl 
  select r.id_point,r.id_meter,r.dat_b,r.dat_e from (select 1) as a left join 
   (select * from act_meter_pnt_tbl where id_point=r.id_point 
   and id_meter=r.id_meter) as b on true where b.id_point is null or 
   (b.id_point is not null and b.dat_e<>r.dat_b);

Raise notice ''17-2  %    %'',r.id_point,r.id_meter;
  update act_meter_pnt_tbl set dat_e=r.dat_e 
  where act_meter_pnt_tbl.id_point=r.id_point 
   and act_meter_pnt_tbl.id_meter=r.id_meter 
   and act_meter_pnt_tbl.dat_e=r.dat_b;

end loop;

--act_demand_tbl
Raise notice ''18'';
insert into act_demand_tbl 
select distinct b.id_point,b.id_meter,b.num_eqp,c.k_tr,c.k_tr_i,c.i_ts
   ,b.id_type_eqp 
   ,case when c.dat_b<=b.dat_b then b.dat_b else c.dat_b end as dat_b
   ,case when c.dat_e>b.dat_e then b.dat_e else c.dat_e end as dat_e 
from (select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp,b.id_p_eqp  
   ,case when b.dat_b<=a.dat_b then a.dat_b else b.dat_b end as dat_b
   ,case when b.dat_e>a.dat_e then a.dat_e else b.dat_e end as dat_e 
 from  
 (select a1.id_point,a1.id_meter,a1.num_eqp,f.id_type_eqp 
   ,case when a1.dat_b<=f.dt_b then f.dt_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>coalesce(f.dt_e,a1.dat_e) then f.dt_e else a1.dat_e end as dat_e 
from 
(select a1.id_point,a1.id_meter,e.num_eqp
     ,case when e.dt_b<=a1.dat_b then a1.dat_b else e.dt_b end as dat_b
     ,case when coalesce(e.dt_e,a1.dat_e)>=a1.dat_e then a1.dat_e else e.dt_e end as dat_e   
  from act_meter_pnt_tbl as a1 
  inner join eqm_equipment_h as e 
   on (e.id=a1.id_meter and e.dt_b<a1.dat_e 
   and coalesce(e.dt_e,a1.dat_e)>a1.dat_b) ) as a1 
  inner join eqm_meter_h as f on (f.code_eqp=a1.id_meter
   and f.dt_b<a1.dat_e 
   and coalesce(f.dt_e,a1.dat_e)>a1.dat_b) ) as a 
  inner join act_eqp_branch_tbl as b on 
 (a.id_meter=b.code_eqp and b.dat_b<a.dat_e and b.dat_e>a.dat_b) ) as b 
  inner join  
 (select c.code_eqp
   ,case when coalesce(d.dat_b,c.dat_b)<=c.dat_b then c.dat_b 
     else d.dat_b end as dat_b
   ,case when coalesce(d.dat_e,c.dat_e)>=c.dat_e then c.dat_e 
     else d.dat_e end as dat_e 
   ,(case when c.conversion=1 then c.k_tr_i else c.k_tr_u end)*(
    case when d.conversion=1 then coalesce(d.k_tr_i,1) else 
     coalesce(d.k_tr_u,1) end) as k_tr
   ,case when c.conversion=1 then c.i_ts else case when d.conversion=1 
    then d.i_ts end end as i_ts
   ,case when c.conversion=1 then c.k_tr_i else 
    case when d.conversion=1 then d.k_tr_i end end as k_tr_i
 from 
  (select c1.code_eqp,c1.id_p_eqp,c2.id_type_eqp,c3.conversion
   ,case when c2.dt_b<=c1.dat_b then c1.dat_b else c2.dt_b end as dat_b
   ,case when coalesce(c2.dt_e,c1.dat_e)>c1.dat_e then c1.dat_e 
    else coalesce(c2.dt_e,c1.dat_e) end as dat_e
   ,coalesce(c3.amperage2_nom,0) as i_ts
   ,case when c3.conversion=1 then c3.amperage_nom/c3.amperage2_nom else 1 end as k_tr_i
   ,case when c3.conversion=2 then c3.voltage_nom/c3.voltage2_nom else 1 end as k_tr_u
   from act_eqp_branch_tbl as c1 inner join 
    eqm_compensator_i_h as c2 on (c1.code_eqp=c2.code_eqp and 
      c2.dt_b<c1.dat_e and coalesce(c2.dt_e,c1.dat_e)>c1.dat_b) inner join 
    eqi_compensator_i_tbl as c3 on (c2.id_type_eqp=c3.id)
    where type_eqp=10) as c 
  left join (select c1.code_eqp,c2.id_type_eqp,c3.conversion
   ,case when c2.dt_b<=c1.dat_b then c1.dat_b else c2.dt_b end as dat_b
   ,case when coalesce(c2.dt_e,c1.dat_e)>c1.dat_e then c1.dat_e 
    else coalesce(c2.dt_e,c1.dat_e) end as dat_e
   ,coalesce(c3.amperage2_nom,0) as i_ts
   ,case when c3.conversion=1 then c3.amperage_nom/c3.amperage2_nom else 1 end as k_tr_i
   ,case when c3.conversion=2 then c3.voltage_nom/c3.voltage2_nom else 1 end as k_tr_u
   from act_eqp_branch_tbl as c1 inner join 
    eqm_compensator_i_h as c2 on (c1.code_eqp=c2.code_eqp and 
      c2.dt_b<c1.dat_e and coalesce(c2.dt_e,c1.dat_e)>c1.dat_b) inner join 
    eqi_compensator_i_tbl as c3 on (c2.id_type_eqp=c3.id)
    where type_eqp=10) as d 
  on (d.code_eqp=c.id_p_eqp and c.dat_b<d.dat_e and c.dat_e>d.dat_b)) as c 
  on (c.code_eqp=b.id_p_eqp and b.dat_b<c.dat_e and b.dat_e>c.dat_b);

--act_met_kndzn_tbl
Raise notice ''19'';
insert into act_met_kndzn_tbl(id_point,id_meter,num_eqp,kind_energy,id_zone,k_tr
 ,id_type_eqp,dat_b,dat_e) 
select k.id_point,k.id_meter,k.num_eqp,g.kind_energy,h.zone as id_zone,k.k_tr
  ,k.id_type_eqp
  ,case when coalesce(h.dt_b,k.dat_b)<=k.dat_b then k.dat_b 
   else h.dt_b end as dat_b
  ,case when coalesce(h.dt_e,k.dat_e)>=k.dat_e then k.dat_e 
   else h.dt_e end as dat_e 
from 
(select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
  ,coalesce(c.k_tr,1) as k_tr
  ,case when coalesce(c.dat_b,a.dat_b)<=a.dat_b then a.dat_b 
   else c.dat_b end as dat_b
  ,case when coalesce(c.dat_e,a.dat_e)>=a.dat_e then a.dat_e 
   else c.dat_e end as dat_e 
from 

(select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
  ,case when b.dat_b<=a.dat_b then a.dat_b else b.dat_b end as dat_b
  ,case when b.dat_e>=a.dat_e then a.dat_e else b.dat_e end as dat_e 
 from 
 (select a1.id_point,a1.id_meter,a1.num_eqp,f.id_type_eqp 
   ,case when a1.dat_b<=f.dt_b then f.dt_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>coalesce(f.dt_e,a1.dat_e) then f.dt_e else a1.dat_e end as dat_e 
from 
(select a1.id_point,a1.id_meter,e.num_eqp
     ,case when e.dt_b<=a1.dat_b then a1.dat_b else e.dt_b end as dat_b
     ,case when coalesce(e.dt_e,a1.dat_e)>=a1.dat_e then a1.dat_e else e.dt_e end as dat_e   
  from act_meter_pnt_tbl as a1 
  inner join eqm_equipment_h as e 
   on (e.id=a1.id_meter and e.dt_b<a1.dat_e 
   and coalesce(e.dt_e,a1.dat_e)>a1.dat_b) ) as a1 
  inner join eqm_meter_h as f on (f.code_eqp=a1.id_meter
   and f.dt_b<a1.dat_e 
   and coalesce(f.dt_e,a1.dat_e)>a1.dat_b)) as a 

  inner join act_eqp_branch_tbl as b on 
 (a.id_meter=b.code_eqp and b.dat_b<a.dat_e and b.dat_e>a.dat_b) ) as a

  left join act_demand_tbl as c on (c.id_point=a.id_point and c.id_meter=a.id_meter 
  and c.num_eqp=a.num_eqp and a.dat_b<=c.dat_b and a.dat_e>=c.dat_e) ) as k
 inner join eqd_meter_energy_h as g on (k.id_meter=g.code_eqp and g.dt_b<k.dat_e 
   and coalesce(g.dt_e,k.dat_e)>k.dat_b)
 inner join eqd_meter_zone_h as h on (h.code_eqp=g.code_eqp and 
   h.kind_energy=g.kind_energy and h.dt_b<k.dat_e 
   and coalesce(h.dt_e,k.dat_e)>k.dat_b)  ;

/*
insert into act_met_kndzn_tbl(id_point,id_meter,num_eqp,kind_energy,id_zone,k_tr
 ,id_type_eqp,dat_b,dat_e,b_val,e_val,id_parent_doc,met_demand,ktr_demand,id_ind
 ,k_ts,i_ts,hand_losts) 

select distinct k1.id_point,k1.id_meter,k1.num_eqp,k1.kind_energy,k1.id_zone,k1.k_tr
  ,k1.id_type_eqp
  ,date_mii(d2.dat_b,-dtadd)
  ,date_mii(d2.dat_e,-dtadd)
  ,d2.b_val,d2.e_val,d2.id_parent_doc
  ,calc_ind_pr(coalesce(d2.e_val,0),coalesce(d2.b_val,0),d1.carry) as met_demand 
  ,calc_ind_pr(coalesce(d2.e_val,0),coalesce(d2.b_val,0),d1.carry)*k1.k_tr as ktr_demand 
  ,d2.id_ind,k1.k_ts,k1.i_ts,d2.hand_losts   
 from (select d3.value as b_val,d1.value as e_val,d1.id_doc as id_parent_doc
        ,d1.id as id_ind,d3.dat_ind as dat_b,d1.dat_ind as dat_e 
        ,d1.id_meter,d1.num_eqp,d1.kind_energy,d1.id_zone,d1.coef_comp
        ,d1.hand_losts  
       
          from acd_indication_tbl as d1 Left JOIN acd_indication_tbl as d3 
          on (d1.id_previndic=d3.id) 
          right join (
             select id_doc from acm_headindication_tbl as h11  
               right join  (select distinct id_client from act_eqp_branch_tbl) as br on (br.id_client=h11.id_client) 
               right join ( select id from dci_document_tbl 
                where ident=''rep_pwr'' or ident=''chn_cnt''  or ident=''act_chn''
                 or ident=''act_pwr'' or ident=''act_check'' or ident= ''rep_avg''
                 or ident=''rep_bound'') as r1 
               on (r1.id=h11.idk_document)
          --         where flock=0  
               where date_end::date>date_mii(dtb,dtadd)
          ) as h1
           on ( d1.id_doc=h1.id_doc) 
          where d1.id_cor_doc is null and d1.id_previndic is not null and date_mi((select reg_date from acm_headindication_tbl 
                      where id_doc=d3.id_doc)::date,d3.dat_ind::date)>=0 and 
            date_mi((select reg_date from acm_headindication_tbl 
                      where id_doc=d1.id_doc)::date,d1.dat_ind::date)>=0   )  as d2

   inner join  
    ((select g1.id_point,g1.id_meter,g1.num_eqp,g1.kind_energy
 ,h.zone as id_zone
  ,g1.k_tr,g1.k_ts,g1.i_ts
  ,g1.id_type_eqp
  ,case when h.dat_b<=g1.dat_b then g1.dat_b 
   else h.dat_b end as dat_b
  ,case when h.dat_e>=g1.dat_e then g1.dat_e 
   else h.dat_e end as dat_e 
from  
(
select k.id_point,k.id_meter,k.num_eqp,g.kind_energy,k.k_tr
  ,k.id_type_eqp,k.k_ts,k.i_ts
  ,case when g.dat_b<=k.dat_b then k.dat_b 
   else g.dat_b end as dat_b
  ,case when g.dat_e>=k.dat_e then k.dat_e 
   else g.dat_e end as dat_e 
from 
(select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
  ,coalesce(c.k_tr,1) as k_tr,c.k_ts,c.i_ts 
  ,case when coalesce(c.dat_b,a.dat_b)<=a.dat_b then a.dat_b 
   else c.dat_b end as dat_b
  ,case when coalesce(c.dat_e,a.dat_e)>=a.dat_e then a.dat_e 
   else c.dat_e end as dat_e 
from 
(select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
  ,case when b.dat_b<=a.dat_b then a.dat_b else b.dat_b end as dat_b
  ,case when b.dat_e>=a.dat_e then a.dat_e else b.dat_e end as dat_e 
 from 
(select a1.id_point,a1.id_meter,a1.num_eqp,f.id_type_eqp 
   ,case when a1.dat_b<=f.dt_b then f.dt_b else a1.dat_b end as dat_b
   ,case when a1.dat_e>coalesce(f.dt_e,a1.dat_e) then f.dt_e else a1.dat_e end as dat_e 
from 
(select a1.id_point,a1.id_meter,e.num_eqp
     ,case when e.dt_b<=a1.dat_b then a1.dat_b else e.dt_b end as dat_b
     ,case when coalesce(e.dt_e,a1.dat_e)>=a1.dat_e then a1.dat_e else e.dt_e end as dat_e   
  from act_meter_pnt_tbl as a1 
  inner join eqm_equipment_h as e 
   on (e.id=a1.id_meter and e.dt_b<a1.dat_e 
   and coalesce(e.dt_e,a1.dat_e)>a1.dat_b) ) as a1 
  inner join eqm_meter_h as f on (f.code_eqp=a1.id_meter
   and f.dt_b<a1.dat_e 
   and coalesce(f.dt_e,a1.dat_e)>a1.dat_b)) as a 
  inner join act_eqp_branch_tbl as b on 
 (a.id_meter=b.code_eqp and b.dat_b<a.dat_e and b.dat_e>a.dat_b) ) as a
 
 left join act_demand_tbl as c on (c.id_point=a.id_point 
  and c.id_meter=a.id_meter 
  and c.num_eqp=a.num_eqp and a.dat_b<=c.dat_b and a.dat_e>=c.dat_e) 
 ) as k

 inner join (select a1.code_eqp,a1.kind_energy
    ,case when a1.dt_b<=a2.dat_b then a2.dat_b else a1.dt_b end as dat_b 
    ,case when coalesce(a1.dt_e,a2.dat_e)>=a2.dat_e then a2.dat_e 
      else a1.dt_e end as dat_e 
    from eqd_meter_energy_h as a1 inner join 
    act_meter_pnt_tbl as a2 on (a1.code_eqp=a2.id_meter and a1.dt_b<a2.dat_e 
   and coalesce(a1.dt_e,a2.dat_e)>a2.dat_b)) as g 
  on (k.id_meter=g.code_eqp and g.dat_b<k.dat_e 
   and g.dat_e>k.dat_b)
) as g1 

 inner join (select a1.code_eqp,a1.kind_energy,a1.zone
   ,case when a1.dt_b<=a2.dat_b then a2.dat_b else a1.dt_b end as dat_b 
    ,case when coalesce(a1.dt_e,a2.dat_e)>=a2.dat_e then a2.dat_e 
      else a1.dt_e end as dat_e  
   from eqd_meter_zone_h as a1 inner join act_meter_pnt_tbl as a2 
   on (a1.code_eqp=a2.id_meter and a1.dt_b<a2.dat_e 
   and coalesce(a1.dt_e,a2.dat_e)>a2.dat_b)) as h 

   on (h.code_eqp=g1.id_meter and h.kind_energy=g1.kind_energy
   and h.dat_b<g1.dat_e and h.dat_e>g1.dat_b)

     ) as k1
     left join eqi_meter_tbl as d1 
        on (k1.id_type_eqp=d1.id)) 
    on (d2.id_meter=k1.id_meter and d2.num_eqp=k1.num_eqp 
        and d2.kind_energy=k1.kind_energy and d2.id_zone=k1.id_zone 
        and d2.coef_comp=k1.k_tr 
        and d2.dat_b<date_mii(k1.dat_e,dtadd) and d2.dat_e>date_mii(k1.dat_b,dtadd));  
*/
----sel indications

--act_losts_eqm_tbl
Raise notice ''38'';
/*for r in select distinct a.* from act_point_branch_tbl as a 
   inner join act_pnt_lost as b on (a.id_point=b.id_point) 
   left join act_pnt_hlosts as c on (c.id_point=a.id_point)
   inner join act_pnt_mlost as d on (d.id_point=a.id_point)
   where a.id_p_point is null and c.id_point is null 
  and (b.count_lost=1 or d.main_losts=1) 
  and id_client=id_rclient or (id_client<>id_rclient and id_rclient<>idres and id_rclient not in (select id from clm_client_tbl where flag_balance=1)) 
    loop 
  rs:=lost_eqm(r.id_point,r.id_point,null,r.dat_b,r.dat_e);
*/

for r in select distinct a.*,b.count_lost as cnt_lost from act_point_branch_tbl as a 
   inner join act_pnt_lost as b on (a.id_point=b.id_point) 
   left join act_pnt_hlosts as c on (c.id_point=a.id_point)
   where c.id_point is null 
loop
    if  (r.id_p_point is null) then
       ppnt:=0;
    else
       ppnt:=1;
    end if;


 rs:=inlost_eqm(r.id_point,r.id_point,null::int,r.dat_b,r.dat_e,r.id_client,r.cnt_lost,ppnt,0);
end loop;


for r in select distinct a.* from act_point_branch_tbl  as a 
   inner join act_pnt_lost as b on (a.id_point=b.id_point) 
   left join act_pnt_hlosts as c on (c.id_point=a.id_point)
   inner join act_pnt_mlost as d on (d.id_point=a.id_point)
   where a.id_p_point is null and c.id_point is null 
  and (b.count_lost=1 or d.main_losts=1) 
  and id_client<>id_rclient and (id_rclient=idres or id_rclient  in (select id from clm_client_tbl where flag_balance=1)) loop 
Raise notice ''39   point  %'',r.id_point;
 rs1:=desc_border(r.id_point,r.id_point,r.dat_b,r.dat_e); 
Raise notice ''39 end  point  %'',r.id_point;
 

if rs1 is null then 
   insert into act_res_notice 
   values(''Not correct lost equipment for point ''||r.id_point);
   ---Return false;
 end if;
end loop;
---------calc all losts on main client 
insert into  act_comp_percent (id_point,id_eqp,id_p_point,sn_len,sum_wp,sum_wq,dat_b,dat_e,
  wp_parent,perc,add_wp,all_wp)
select l.id_point,l.id_eqp,p.id_p_point,sn_len,sum_wp,sum_wq,l.dat_b,l.dat_e ,0as wq_parent,0 as perc,0 as add_wq,0 as all_wq
from act_losts_eqm_tbl l,act_point_branch_tbl p 
where l.type_eqm=2 and p.id_point=l.id_point and p.id_p_point is not null
order by l.id_point ;

update act_comp_percent set perc=cc from
(select c.*,100.00/pr.ssn*c.sn_len as cc  from act_comp_percent c, 
(
 select id_p_point,dat_b,dat_e,sum(sn_len)  as ssn from 
 (select  distinct id_p_point,id_eqp,dat_b,dat_e,sn_len from act_comp_percent )  d
 group by id_p_point,dat_b,dat_e
) pr
where  c.id_p_point=pr.id_p_point) pers
where pers.id_p_point=act_comp_percent.id_p_point and pers.id_eqp=act_comp_percent.id_eqp
  and pers.id_point=act_comp_percent.id_point;

update act_comp_percent set wp_parent =fact_par.fact,add_wp=(perc/100)*fact_par.fact from  
 (select id_point,sum(fact_demand) as fact from act_pwr_demand_tbl where kind_energy=1 group by id_point) fact_par
 where fact_par.id_point=act_comp_percent.id_p_point;

update act_losts_eqm_tbl set own_wp=c.add_wp 
from  act_comp_percent c 
where c.id_point=act_losts_eqm_tbl.id_point
 and  c.id_p_point=act_losts_eqm_tbl.id_p_point
and c.id_eqm=act_losts_eqm_tbl.id_eqm
and c.dat_b=act_losts_eqm_tbl.dat_b
and c.dat_e=act_losts_eqm_tbl.dat_e;

update act_losts_eqm_tbl set own_wp=0.00 where own_wp is null;



Raise notice ''40'';
for r in select distinct a.id_point,c.id_m_point from act_point_branch_tbl as a 
   inner join act_pnt_mlost as b on (a.id_point=b.id_point)  
   inner join (select a1.id_point,a1.id_eqp,a3.id_point as id_m_point 
    from act_losts_eqm_tbl as a1 
    inner join (select distinct code_eqp,id_client from act_eqp_branch_tbl 
--     where id_client=idcl
    ) as a2 on (a1.id_eqp=a2.code_eqp) 
      inner join (select b1.id_point,b1.id_eqp,b2.id_client from act_losts_eqm_tbl as b1 
     inner join (select c1.* from act_point_branch_tbl as c1 
       inner join act_pnt_lost as c2 on (c1.id_point=c2.id_point)
         where c2.count_lost=1) as b2 on (b1.id_point=b2.id_point) 
--       where b2.id_client=idcl
       ) as a3 on (a2.code_eqp=a3.id_eqp 
         and a1.id_point<>a3.id_point and a3.id_client=a2.id_client)) as c 
     on (c.id_point=a.id_point) 
   where a.id_p_point is null and b.main_losts=1  loop 
 insert into act_desclosts_eqm_tbl values(r.id_point,r.id_m_point);
end loop;

/*
for r12 in select a.*,b.id as idk from acm_headindication_tbl as a left join 
   (select id from dci_document_tbl where ident=''rep_bound'') as b on true 
     where id_doc=id_mind loop
  */
 delete from acm_headindication_tbl where id_main_ind=id_mind and idk_document=r13.idk; 

  for r in select distinct a.id_client from (select * from act_point_branch_tbl 
   where id_client<>idcl) as a inner join (select * from act_point_branch_tbl 
    where id_client=idcl) as b on (a.id_p_point=b.id_point) union 
     select distinct a.id_client from (select * from 
      act_point_branch_tbl where id_client<>idcl) as a 
    inner join (select a1.* from act_losts_eqm_tbl as a1 inner join 
     act_eqp_branch_tbl as a2 on (a1.id_eqp=a2.code_eqp) 
       where a2.id_client=idcl) as b on (a.id_point=b.id_point) loop

    rs:=inp_cind(r.id_client,id_mind,r13.date_end::date,r13.reg_date::date,r13.mmgg::date,r13.idk,idcl);

  end loop;

end loop;

Return true;
end;
' Language 'plpgsql';

drop function inp_cind(int,int,date,date,date,int,int);
create function inp_cind(int,int,date,date,date,int,int) Returns boolean As '
Declare
idcl Alias for $1;
idmind Alias for $2;
dte Alias for $3;
regdt Alias for $4;
mg Alias for $5;
idk Alias for $6;
idclm Alias for $7;
iddc int;
r record;
cnt int;
cod text;
mg1 date;
mg_dt date;
i int;
begin
select into cnt count(*) from acm_headindication_tbl where id_client=idcl 
--  and mmgg=mg 
  and date_end=dte and (idk_document<>idk 
   or (idk_document=idk and id_main_ind=idmind));
select into mg1 (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||
      ''-''||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident=''mmgg'';
if mg>=mg1 then
 mg_dt:=mg;
else
 mg_dt:=mg1; 
end if;
select into cod code::text from clm_client_tbl as a where id=(select id_client 
  from acm_headindication_tbl where id_doc=idmind);
if cnt=0 then
insert into acm_headindication_tbl(dt,reg_num,reg_date,idk_document
  ,id_client,date_end,mmgg,flag_priv,id_main_ind) 
values(now()::date,cod||''_c'',regdt,idk,idcl,dte,mg_dt,false,idmind);

iddc:=currval(''dcm_doc_seq'');

for r in select * from acm_headindication_tbl where id_doc=iddc loop 

  Raise Notice ''idcl - %'',idcl;
  Raise Notice ''iddc - %'',iddc;

   Execute ''delete from del_ind;'';
    insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
    select a.id as id_ind,b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr from 
    (select * from acd_indication_tbl where id_doc=r.id_doc) as a 
      full outer join
    (select r.id_doc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
      ,a.kind_energy as kind_energy,a.id_zone as id_zone,r.date_end as date_end
      ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
      ,a.carry as carry,a.k_tr as k_tr
    from  (select a1.*,a2.carry from 
      (select k1.* from act_met_kndzn_tbl as k1 inner join 
      (select distinct a.id_point from (select * from act_point_branch_tbl 
   where id_client<>idclm and id_client=idcl) as a 
    inner join (select * from act_point_branch_tbl 
    where id_client=idclm) as b on (a.id_p_point=b.id_point) union 
     select distinct a.id_point from (select * from 
      act_point_branch_tbl where id_client<>idclm and id_client=idcl) as a 
    inner join (select a1.* from act_losts_eqm_tbl as a1 inner join 
     act_eqp_branch_tbl as a2 on (a1.id_eqp=a2.code_eqp) 
       where a2.id_client=idclm) as b on (a.id_point=b.id_point)) as k2 
    on (k1.id_point=k2.id_point)
) as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp) as a ) as b 
      on (a.id_doc=b.id_doc and a.id_meter=b.id_meter and a.num_eqp=b.num_eqp 
          and a.kind_energy=b.kind_energy and a.id_zone=b.id_zone 
          and a.coef_comp=b.k_tr);

--ins
    update del_ind set id_prv=a.id, id_next=a.id_next 
     from (select a1.*,a2.date_end,a_14.ident,a3.id as id_next from (acd_indication_tbl as a1 inner join 
      acm_headindication_tbl as a_13 on (a1.id_doc=a_13.id_doc) inner join 
       dci_document_tbl as a_14 on (a_13.idk_document=a_14.id)) inner join 
          (select * from del_ind where id_doc is not null and id_ind is null) 
      as a2 on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter 
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)) 
      left join acd_indication_tbl as a3 on (a3.id_previndic=a1.id)
---      where a3.id is null
       ) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end
       and a.ident=''beg_ind''; --in (''beg_ind'',''chn_cnt'');   

    update del_ind set id_prv=a.id,id_next=a.id_next 
     from (select a1.*,a2.date_end,a3.id as id_next from acd_indication_tbl as a1 inner join 
          (select * from del_ind where id_doc is not null and id_ind is null) 
      as a2 on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter 
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)) 
      left join acd_indication_tbl as a3 on (a3.id_previndic=a1.id)
--      where a3.id is null
  ) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end 
       and del_ind.id_prv is null;   

    insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
      ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp,id_previndic,id_main_ind)
    select id_doc,id_meter,num_eqp,kind_energy,id_zone,date_end,mmgg,id_client
      ,id_type_eqp,carry,k_tr,id_prv,idmind from del_ind 
      where id_doc is not null 
      and id_ind is null;

    update del_ind set id_ind=a.id from acd_indication_tbl as a 
     where a.id_doc=del_ind.id_doc and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone and a.dat_ind=del_ind.date_end 
       and a.id_client=del_ind.id_client and a.coef_comp=del_ind.k_tr 
       and a.id_previndic=del_ind.id_prv;

    update acd_indication_tbl set id_previndic=a.id_ind from del_ind as a 
     where  a.id_ind<>acd_indication_tbl.id 
       and a.id_prv=acd_indication_tbl.id_previndic and acd_indication_tbl.flock<>1;
--- */
i=add_inddifzone(iddc,dte);
end loop;
end if;
Return true;
end;
' Language 'plpgsql';

   

