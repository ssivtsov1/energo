--set client_encoding='win';
--input - idcl,dtb,dte                         

--drop function mabn_tree(int,date,date);
--drop function mabn_tree(int,date,date,int);
--drop function mabn_tree(int,date,date,int,date);
create  or replace function mabn_tree(int,date,date,int,date) Returns boolean As '
Declare
idcl Alias for $1;
dtb Alias for $2;
dte Alias for $3;
dtadd Alias for $4;
mg Alias for $5;
test record;
fl_up int;
fl_down int;
r record;
r2 record;
r12 record;
rin record;
rl record;
rl1 record;
dtm2 int;
rin_1 record;
i_1 int;
vdat date;
rs boolean;
--test record;
rs1 text;
cdt_b date;
cdt_e date;
w_dtb date;
w_dte date;
r_p record;
idres int;
idbal int;
ppnt int;
cou int;
begin
select into idres int4(value_ident) from syi_sysvars_tbl where ident=''id_res'';
select into idbal int4(value_ident) from syi_sysvars_tbl where ident=''id_bal'';
fl_up:=0;
fl_down:=0;
if date_part(''month'',dte)<12 then
 w_dtb:=((date_part(''year'',dte)-1)||''-12-01'')::date;
 w_dte:=(date_part(''year'',dte)||''-03-01'')::date;
else 
 w_dtb:=(date_part(''year'',dte)||''-12-01'')::date;
 w_dte:=((date_part(''year'',dte)+1)||''-03-01'')::date;
end if;
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
        and (a2.id_client<>idres 
             or a2.id_client not in (select id from clm_client_tbl where flag_balance=1)) 
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
 on (a_12.code_eqp=a4.code_eqp and a_12.dt_b<a4.dt_e and a_12.dt_e>a4.dt_b) ---;
  where coalesce(a4.id_rclient,0)<>idcl; ---31-10-2005
end loop;
----sel up the tree

fl_up:=1;
while (fl_up=1) loop
fl_up:=0;
for r in select distinct b1_2.dat_b as dtb1,b1_2.dat_e as dte1
   ,b1_2.id_tree,b1_2.id_client,b1_2.id_rclient
  from  
(select a2.id_client as id_cclient,a1.id_client,a2.id_tree,a2.code_eqp 
    ,a1.dat_b,a1.dat_e,a2.dt_b,a2.dt_e,a2.code_eqp_e,a2.line_no,a1.id_rclient 
  from  
(select c1.* from (select * from act_eqp_branch_tbl where  type_eqp=9 
  and id_p_eqp is null) as c1 left join (select * from 
  act_eqp_branch_tbl where type_eqp=9 and id_p_eqp is not null) as c2
 on (c1.code_eqp=c2.code_eqp) where c2.code_eqp is null order by c1.code_eqp
    ,c1.id_tree) as a1 
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
    as b1 inner join 
 (select id,code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e
  ,id_client from eqm_tree_h as a inner join (select id as id_cli from clm_client_tbl 
      where book=-1) as b 
    on (a.id_client=b.id_cli) 
  where coalesce(dt_e,dte)>dtb and dt_b<dte)  
  as b2 
   on (b1.id_tree=b2.id and b2.dt_b<b1.dt_e and b2.dt_e>b1.dt_b)
  order by b1.code_eqp,b1.id_tree ) as a2
   on (a1.code_eqp=a2.code_eqp and a1.id_tree<>a2.id_tree and a2.dt_b<a1.dat_e 
    and a2.dt_e>a1.dat_b)) as b1_2 
  left join (select distinct id_tree from act_eqp_branch_tbl where type_eqp=9 
               and id_p_eqp is not null and id_client<>idcl order by id_tree) as b4
  on (b1_2.id_tree=b4.id_tree)
  left join 
 (select code_eqp,case when dt_b<=dtb then dtb else dt_b end as dt_b
  ,case when coalesce(dt_e,dte)>=dte then dte else dt_e end as dt_e,id_client 
  from eqm_eqp_use_h where coalesce(dt_e,dte)>dtb and dt_b<dte 
    order by code_eqp) as b3 
  on (b1_2.code_eqp=b3.code_eqp and b1_2.dt_b<=b3.dt_b and b1_2.dt_e>=b3.dt_e)
     where b4.id_tree is null and not (b1_2.id_cclient in (  (select id from clm_client_tbl where flag_balance=1)) and b3.code_eqp is null) loop


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
 where ((a_12.id_client<>idres     
       or (a_12.id_client=idres and a4.id_rclient=r.id_client))
       or 
     (a_12.id_client not in   (select id from clm_client_tbl where flag_balance=1)     
       or (a_12.id_client in  (select id from clm_client_tbl where flag_balance=1) and a4.id_rclient=r.id_client))
      ) 
       and not (coalesce(a4.id_rclient,a_12.id_client)<>a_12.id_client 
         and coalesce(a4.id_rclient,a_12.id_client)=idcl);

end loop;

end loop; ----while

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
--return false;
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
     where a.code_eqp=b.id_p_eqp and a.id_client<>idcl)) order by b.code_eqp,line_no
loop
   raise notice ''pnt_tree  1 %   %   %'',r.code_eqp,r.dat_b,r.dat_e;
   rs:=pnt_tree(r.code_eqp,null,r.dat_b,r.dat_e,r.id_client,r.id_rclient,r.type_eqp,r.id_client,r.id_tree);
end loop;

--------sel all calc parameters
------------???????---check parameters 

--!!!!!!!!!!!!!!!!!!!!!!!!!------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--¯ëâ ¥¬áï ®¡¬ ­ãâì  «£®à¨â¬, ¯à¨á¢®¨¢ à §­ë¬ ª®¯¨ï¬ â®çª¨ áå®¦¤¥­¨ï à §­ë¥ ¢à¥¬¥­­ë¥ 

-- Checked OSA
for test in select code_eqp,id_tree,line_no,dat_b,dat_e,count(*)
  from act_eqp_branch_tbl group by code_eqp,id_tree,line_no,dat_b,dat_e 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_branch'',100,501,''d_branch'');
   insert into act_res_notice 
   values(''Double in table act_eqp_branch_tbl'');

--- return false;
end loop;

--return false;
--------------------------------------------------------------------------------------------
---act_pnt_lost
delete from act_eqp_branch2_tbl;
insert into act_eqp_branch2_tbl select distinct * from act_eqp_branch_tbl;
delete from act_eqp_branch_tbl;
insert into act_eqp_branch_tbl select distinct * from act_eqp_branch2_tbl;

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


---act_pnt_share
Raise notice ''8'';
insert into act_pnt_share 
select distinct t1.code_eqp,t1.share,t2.zone
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,share,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.share,0) as share
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.share,0)),''share'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.share,0)),''share'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,share,dt_b) as t1
inner join 
(select code_eqp,zone,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.zone,0) as zone
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.zone,0)),''zone'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.zone,0)),''zone'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,zone,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 
------------???????---check parameters 
---------sel up points--------
Raise notice ''9'';
for r in select distinct a.*,d.id_p_eqp,d.line_no from act_point_branch_tbl as a 
 inner join act_pnt_lost as b 
 on (a.id_point=b.id_point and a.dat_b<=b.dat_b and a.dat_e>=b.dat_e) 
 left join act_pnt_share as c 
 on (a.id_point=c.id_point and a.dat_b<=b.dat_b and a.dat_e>=b.dat_e) 
 inner join act_eqp_branch_tbl as d 
 on (a.id_point=d.code_eqp and d.dat_b<=a.dat_b and d.dat_e>=a.dat_e)  
  where id_p_point is null  loop 
 --if r.line_no=0 then
   raise notice ''____________near 9   r.id_p_eqp  %,r.id_point  %,r.dat_b  %,r.dat_e   %'',r.id_p_eqp,r.id_point,r.dat_b,r.dat_e;
 rs:=up_pnt(r.id_p_eqp,r.id_point,r.dat_b,r.dat_e,0);
 --end if;
end loop;
--return 0;
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


for r in select * from act_2point_branch_tbl loop
  insert into act_2point_branch_tbl (id_tree,id_2point,id_point,id_p_point,
 dat_b,dat_e,id_client,id_rclient)
 select b.id_tree,r.id_2point,b.id_point,r.id_p_point,
 b.dat_b,b.dat_e,b.id_client,b.id_rclient
 from act_point_branch_tbl b where r.id_p_point=b.id_p_point; 
end loop;
delete from act_2point_branch_tbl where id_point is null;
---act_pnt_lost
--return 0;
Raise notice ''12'';
insert into act_pnt_lost 
select k.code_eqp,k.count_lost,k.dat_b,k.dat_e from
(select case when k1.code_eqp is null then k2.code_eqp else k1.code_eqp 
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
 on (k1.code_eqp=k2.code_eqp)) k left join act_pnt_lost l on k.code_eqp=l.id_point and k.dat_b=l.dat_b
 where l.id_point is null;
                                           
---act_pnt_share
Raise notice ''14'';
insert into act_pnt_share 
select distinct t1.code_eqp,t1.share,t2.zone
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,share,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.share,0) as share
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.share,0)),''share'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.share,0)),''share'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join (select a1.* from act_point_branch_tbl as a1 
  left join (select distinct id_point from act_pnt_share) as a2 
    on (a1.id_point=a2.id_point) where a2.id_point is null) as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,share,dt_b) as t1 
inner join 
(select code_eqp,zone,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.zone,0) as zone
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.zone,0)),''zone'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.zone,0)),''zone'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join (select a1.* from act_point_branch_tbl as a1 
  left join (select distinct id_point from act_pnt_share) as a2 
    on (a1.id_point=a2.id_point) where a2.id_point is null) as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,zone,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 

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

Raise notice ''17-1  %    %'',r.id_point,r.id_meter;
  update act_meter_pnt_tbl set dat_e=r.dat_e 
  where act_meter_pnt_tbl.id_point=r.id_point 
   and act_meter_pnt_tbl.id_meter=r.id_meter 
   and act_meter_pnt_tbl.dat_e=r.dat_b;

end loop;

for test in select id_point,id_meter,dat_b,count(*)
  from act_meter_pnt_tbl group by id_point,id_meter,dat_b 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_met_pnt'',100,522,''d_met_pnt'');
   insert into act_res_notice 
   values(''Double in table act_meter_pnt'');

 return false;
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
   ,case when c3.conversion=1 then c3.amperage_nom::numeric/c3.amperage2_nom else 1 end as k_tr_i
   ,case when c3.conversion=2 then c3.voltage_nom::numeric/c3.voltage2_nom else 1 end as k_tr_u
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
   ,case when c3.conversion=1 then c3.amperage_nom::numeric/c3.amperage2_nom else 1 end as k_tr_i
   ,case when c3.conversion=2 then c3.voltage_nom::numeric/c3.voltage2_nom else 1 end as k_tr_u
   from act_eqp_branch_tbl as c1 inner join 
    eqm_compensator_i_h as c2 on (c1.code_eqp=c2.code_eqp and 
      c2.dt_b<c1.dat_e and coalesce(c2.dt_e,c1.dat_e)>c1.dat_b) inner join 
    eqi_compensator_i_tbl as c3 on (c2.id_type_eqp=c3.id)
    where type_eqp=10) as d 
  on (d.code_eqp=c.id_p_eqp and c.dat_b<d.dat_e and c.dat_e>d.dat_b)) as c 
  on (c.code_eqp=b.id_p_eqp and b.dat_b<c.dat_e and b.dat_e>c.dat_b);

--act_met_kndzn_tbl
Raise notice ''19'';
--return 0;

insert into act_met_kndzn_tbl(id_point,id_meter,num_eqp,kind_energy,id_zone,k_tr
 ,id_type_eqp,dat_b,dat_e,b_val,e_val,id_parent_doc,met_demand,ktr_demand,id_ind
 ,k_ts,i_ts,hand_losts) 

select distinct k1.id_point,k1.id_meter,k1.num_eqp,k1.kind_energy,k1.id_zone,k1.k_tr
  ,k1.id_type_eqp
  ,date_mii(d2.dat_b,-dtadd) as ddd_b
  ,date_mii(d2.dat_e,-dtadd) as ddd_e
  ,d2.b_val,d2.e_val,d2.id_parent_doc
  ,calc_ind_pr(coalesce(d2.e_val,0),coalesce(d2.b_val,0),d1.carry) as met_demand 
  ,calc_ind_pr(coalesce(d2.e_val,0),coalesce(d2.b_val,0),d1.carry)* k1.k_tr as ktr_demand 
  ,d2.id_ind,k1.k_ts,k1.i_ts,d2.hand_losts   
 from 
     (select d3.value as b_val,d1.value as e_val,d1.id_doc as id_parent_doc
        ,d1.id as id_ind,d3.dat_ind as dat_b,d1.dat_ind as dat_e 
        ,d1.id_meter,d1.num_eqp,d1.kind_energy,d1.id_zone,d1.coef_comp
        ,d1.hand_losts  
         from 
            (select * from acd_indication_tbl, act_eqp_branch_tbl b where b.code_eqp=id_meter order by id_previndic) as d1
              left join 
              (select * from acd_indication_tbl, act_eqp_branch_tbl b where b.code_eqp=id_meter order by id) as d3 on (d1.id_previndic=d3.id) 
              right join 
              ( select id_doc from acm_headindication_tbl as h11  
                       right join  
                       (select distinct id_client from act_eqp_branch_tbl) as br on (br.id_client=h11.id_client) 
                       right join 
                       ( select id from dci_document_tbl     where ident=''rep_pwr'' or ident=''chn_cnt''  or ident=''act_chn''
                           or ident=''act_pwr'' or ident=''act_check'' or ident= ''rep_avg''     or ident=''rep_bound''
                        ) as r1    on (r1.id=h11.idk_document)
                 where date_end::date>date_mii(dtb,dtadd)
                )  as h1 on ( d1.id_doc=h1.id_doc) 
             where  d1.id_previndic=d3.id 
                   and date_mi((select min(reg_date) from acm_headindication_tbl     where id_doc=d3.id_doc)::date,d3.dat_ind::date)>=0 and 
                    date_mi((select min(reg_date) from acm_headindication_tbl     where id_doc=d1.id_doc)::date,d1.dat_ind::date)>=0  order by d1.id_meter 
     )  as d2
   inner join  
    ( (select g1.id_point,g1.id_meter,g1.num_eqp,g1.kind_energy  ,h.zone as id_zone
          ,g1.k_tr,g1.k_ts,g1.i_ts   ,g1.id_type_eqp   ,case when h.dat_b<=g1.dat_b then g1.dat_b     else h.dat_b end as dat_b
          ,case when h.dat_e>=g1.dat_e then g1.dat_e     else h.dat_e end as dat_e 
         from  
       ( select k.id_point,k.id_meter,k.num_eqp,g.kind_energy,k.k_tr
           ,k.id_type_eqp,k.k_ts,k.i_ts   ,case when g.dat_b<=k.dat_b then k.dat_b     else g.dat_b end as dat_b
           ,case when g.dat_e>=k.dat_e then k.dat_e     else g.dat_e end as dat_e 
         from 
          ( select a.id_point,a.id_meter,a.num_eqp,a.id_type_eqp
              ,coalesce(c.k_tr,1) as k_tr,c.k_ts,c.i_ts    ,case when coalesce(c.dat_b,a.dat_b)<=a.dat_b then a.dat_b       else c.dat_b end as dat_b
              ,case when coalesce(c.dat_e,a.dat_e)>=a.dat_e then a.dat_e     else c.dat_e end as dat_e 
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
                   inner join eqm_equipment_h as e    on (e.id=a1.id_meter and e.dt_b<a1.dat_e     and coalesce(e.dt_e,a1.dat_e)>a1.dat_b) 
                  ) as a1 
                 inner join eqm_meter_h as f on (f.code_eqp=a1.id_meter   and f.dt_b<a1.dat_e    and coalesce(f.dt_e,a1.dat_e)>a1.dat_b)
                ) as a 
                inner join act_eqp_branch_tbl as b on  (a.id_meter=b.code_eqp and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
            ) as a
            left join act_demand_tbl as c on (c.id_point=a.id_point    and c.id_meter=a.id_meter    and c.num_eqp=a.num_eqp 
                                                                 and a.dat_b<=c.dat_b and   a.dat_e>=c.dat_e) 
       ) as k
        inner join  
           (select a1.code_eqp,a1.kind_energy     ,case when a1.dt_b<=a2.dat_b then a2.dat_b else a1.dt_b end as dat_b 
               ,case when coalesce(a1.dt_e,a2.dat_e)>=a2.dat_e then a2.dat_e        else a1.dt_e end as dat_e 
             from eqd_meter_energy_h as a1 
             inner join 
              act_meter_pnt_tbl as a2 on (a1.code_eqp=a2.id_meter and a1.dt_b<a2.dat_e     and coalesce(a1.dt_e,a2.dat_e)>a2.dat_b)
           ) as g    on (k.id_meter=g.code_eqp and g.dat_b<k.dat_e     and g.dat_e>k.dat_b)
       ) as g1 
      inner join 
          (select a1.code_eqp,a1.kind_energy,a1.zone    ,case when a1.dt_b<=a2.dat_b then a2.dat_b else a1.dt_b end as dat_b 
            ,case when coalesce(a1.dt_e,a2.dat_e)>=a2.dat_e then a2.dat_e        else a1.dt_e end as dat_e  
              from eqd_meter_zone_h as a1 
              inner join act_meter_pnt_tbl as a2     on (a1.code_eqp=a2.id_meter and a1.dt_b<a2.dat_e     and coalesce(a1.dt_e,a2.dat_e)>a2.dat_b)
           ) as h     on (h.code_eqp=g1.id_meter and h.kind_energy=g1.kind_energy
                              and h.dat_b<g1.dat_e and h.dat_e>g1.dat_b)
  ) as k1
   left join eqi_meter_tbl as d1          on (k1.id_type_eqp=d1.id)
 )     on (d2.id_meter=k1.id_meter and d2.num_eqp=k1.num_eqp 
                and d2.kind_energy=k1.kind_energy and d2.id_zone=k1.id_zone 
                and d2.coef_comp=k1.k_tr 
               and d2.dat_b<date_mii(k1.dat_e,dtadd) and d2.dat_e>date_mii(k1.dat_b,dtadd)
);  


----sel indications

-----other parameters
---act_pnt_hlosts
--return false;

Raise notice ''19-1'';
insert into act_pnt_hlosts
select distinct a.code_eqp,a.flag_hlosts from eqm_point_h as a 
 inner join act_point_branch_tbl as b on (a.code_eqp=b.id_point 
  and a.dt_b<b.dat_e and coalesce(a.dt_e,b.dat_e)>b.dat_b) where flag_hlosts=1;
---act_pnt_d
--return 0;
Raise notice ''20'';
insert into act_pnt_d 
select code_eqp,d,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.d,0) as d
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.d,0)),''d'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.d,0)),''d'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,d,dt_b; 
---act_pnt_pwr
Raise notice ''21'';
insert into act_pnt_pwr 
select code_eqp,power,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.power,0) as power
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.power,0)),''power'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.power,0)),''power'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,power,dt_b; 
---act_pnt_tarif
Raise notice ''22'';
insert into act_pnt_tarif 
select code_eqp,id_tarif,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.id_tarif,0) as id_tarif
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_tarif,0)),''id_tarif'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_tarif,0)),''id_tarif'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,id_tarif,dt_b; 
---act_pnt_tg
Raise notice ''23'';
insert into act_pnt_tg 
select code_eqp,id_tg,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.id_tg,0) as id_tg
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_tg,0)),''id_tg'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_tg,0)),''id_tg'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,id_tg,dt_b; 
---act_pnt_un
Raise notice ''24'';
insert into act_pnt_un 
select code_eqp,id_un,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.id_un,0) as id_un
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_un,0)),''id_un'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.id_un,0)),''id_un'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,id_un,dt_b; 


---act_pnt_wtm
Raise notice ''25'';
insert into act_pnt_wtm 
select code_eqp,wtm,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.wtm,0) as wtm
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.wtm,0)),''wtm'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.wtm,0)),''wtm'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,wtm,dt_b; 

---act_pnt_knd
Raise notice ''26'';
insert into act_pnt_knd(id_point,kind_energy,dat_b,dat_e)
select distinct a.code_eqp,a.kind_energy
 ,case when a.dt_b<=b.dat_b then b.dat_b else a.dt_b end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqd_point_energy_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b);

for test in select id_point,kind_energy,dat_b,count(*)
  from act_pnt_knd group by id_point,kind_energy,dat_b 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_pnt_knd'',100,502,''d_pnt_knd'');
   insert into act_res_notice 
   values(''Double in table act_pnt_knd'');

 return false;
end loop;


Raise Notice ''update act_pnt_knd begin'';
Raise notice ''26.1'';
cdt_b:=null;
for r in select b.mdat_b,c.mdat_e,d.* 
      from (select id_point,kind_energy,count(*) as cnt 
       from act_pnt_knd group by id_point,kind_energy 
          having count(*)>1) as a 
        inner join (select id_point,min(dat_b) as mdat_b,kind_energy
          from act_pnt_knd group by id_point,kind_energy) as b 
           on (a.id_point=b.id_point and a.kind_energy=b.kind_energy)
        inner join (select id_point,max(dat_e) as mdat_e,kind_energy
          from act_pnt_knd group by id_point,kind_energy) as c 
           on (a.id_point=c.id_point and a.kind_energy=c.kind_energy) 
        inner join act_pnt_knd as d on (a.id_point=d.id_point 
         and a.kind_energy=c.kind_energy)
       order by d.id_point,d.kind_energy,d.dat_b
       loop 
 Raise Notice ''id_pnt - %'',r.id_point;
 if r.dat_b=r.mdat_b and cdt_b is null then 
   cdt_b:=r.mdat_b;
   cdt_e:=r.dat_e;
 else 
   if r.dat_b=cdt_e then 
    Raise Notice ''update knd'';
     update act_pnt_knd set dat_e=r.dat_e where id_point=r.id_point 
          and kind_energy=r.kind_energy and dat_b=cdt_b;
     delete from act_pnt_knd where id_point=r.id_point 
             and kind_energy=r.kind_energy and dat_b=r.dat_b;
     cdt_e:=r.dat_e;
    if r.dat_e=r.mdat_e then
      cdt_b:=null;
      cdt_e:=null;
    end if;
   end if;
 end if;  
end loop;
Raise Notice ''update act_pnt_knd end'';

Raise notice ''27'';

update act_point_branch_tbl set k_corr=k.k_corr 
 from
 (select a.id_point,b.k_corr 
  from  
      (select case when ((date_mi(mg,date_trunc(''month'',coalesce(dt_b,''1999-01-01''))::date)/365+1<4)  
                          and (mg<''2008-01-01''))
            then date_mi(mg,date_trunc(''month'',coalesce(dt_b,''1999-01-01''))::date)/365+1 
              else 4 end as cnt
          ,id_point  
           from 
        (select min(a1.dt_b) as dt_b,a2.id_point  
            from eqd_point_energy_h as a1 inner join 
          (select * from act_pnt_knd where kind_energy=2) as a2 
          on (a1.code_eqp=a2.id_point and a1.kind_energy=a2.kind_energy) 
             group by a2.id_point) as c) as a 
         inner join acm_k_corr_tbl as b on (b.cnt_year=a.cnt)) as k

where act_point_branch_tbl.id_point=k.id_point;
---act_met_knd
Raise notice ''28'';
insert into act_met_knd 
select distinct a.code_eqp,a.kind_energy
 ,case when a.dt_b<=b.dat_b then b.dat_b else a.dt_b end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqd_meter_energy_h as a inner join act_meter_pnt_tbl as b 
 on (a.code_eqp=b.id_meter and a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b);

for test in select id_meter,kind_energy,dat_b ,count(*)
  from act_met_knd group by id_meter,kind_energy,dat_b  
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_metknd'',100,503,''d_metknd'');
   insert into act_res_notice 
   values(''Double in table act_met_knd'');

 return false;
end loop;

-----act_pnt_cmp
Raise notice ''29'';
insert into act_pnt_cmp 
select code_eqp,cmp,dt_b,max(dt_e) from (
select a.code_eqp,coalesce(a.cmp,0) as cmp
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.cmp,0)),''cmp'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.cmp,0)),''cmp'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a inner join act_point_branch_tbl as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,cmp,dt_b; 
--------act_pnt_cntitr
Raise notice ''30'';
insert into act_pnt_cntitr 
select distinct t1.code_eqp,t1.count_itr,t2.itr_comment
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,count_itr,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.count_itr,0) as count_itr
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.count_itr,0)),''count_itr'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.count_itr,0)),''count_itr'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,count_itr,dt_b) as t1 
inner join 
(select code_eqp,itr_comment,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,text(coalesce(a.itr_comment,''0'')) as itr_comment
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.itr_comment,''0'')),''itr_comment'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.itr_comment,''0'')),''itr_comment'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,itr_comment,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 


update act_pnt_cntitr set code_tt=v.code_tt,accuracy=coalesce(ci.accuracy,5) from 
eqv_pnt_met v 
left join eqm_compensator_i_tbl  c on v.code_tt=c.code_eqp
left join eqi_compensator_i_tbl ci on c.id_type_eqp=ci.id 
 where v.id_point=act_pnt_cntitr.id_point;


-------act_pnt_cntavg
Raise notice ''31'';
insert into act_pnt_cntavg 
select distinct t1.code_eqp,t1.ldemand,t2.pdays 
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,ldemand,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.ldemand,0) as ldemand 
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.ldemand,0)),''ldemand'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.ldemand,0)),''ldemand'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,ldemand,dt_b) as t1 
inner join 
(select code_eqp,pdays,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.pdays,''0'') as pdays
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.pdays,''0'')),''pdays'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.pdays,''0'')),''pdays'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,pdays,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 
Raise notice ''31_1'';
insert into act_pnt_cntavgr 
select distinct t1.code_eqp,t1.ldemandr,t2.pdays 
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,ldemandr,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.ldemandr,0) as ldemandr 
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.ldemandr,0)),''ldemandr'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.ldemandr,0)),''ldemandr'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,ldemandr,dt_b) as t1 
inner join 
(select code_eqp,pdays,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.pdays,''0'') as pdays
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.pdays,''0'')),''pdays'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.pdays,''0'')),''pdays'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,pdays,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 
Raise notice ''31_2'';
insert into act_pnt_cntavgg 
select distinct t1.code_eqp,t1.ldemandg,t2.pdays 
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,ldemandg,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.ldemandg,0) as ldemandg 
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.ldemandg,0)),''ldemandg'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.ldemandg,0)),''ldemandg'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,ldemandg,dt_b) as t1 
inner join 
(select code_eqp,pdays,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.pdays,''0'') as pdays
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.pdays,''0'')),''pdays'',''eqm_point_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.pdays,''0'')),''pdays'',''eqm_point_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_point_h as a 
 inner join act_point_branch_tbl  as b 
 on (a.code_eqp=b.id_point and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,pdays,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 
-----act_met_cntmet
Raise notice ''32'';
insert into act_met_cntmet  
select distinct t1.code_eqp,t1.count_met,t2.met_comment
 ,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end
from 
(select code_eqp,count_met,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,coalesce(a.count_met,0) as count_met
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.count_met,0)),''count_met'',''eqm_meter_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.count_met,0)),''count_met'',''eqm_meter_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_meter_h as a 
 inner join act_meter_pnt_tbl  as b 
 on (a.code_eqp=b.id_meter and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,count_met,dt_b) as t1 
inner join 
(select code_eqp,met_comment,dt_b,max(dt_e) as dt_e from (
select a.code_eqp,text(coalesce(a.met_comment,''0'')) as met_comment
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.met_comment,''0'')),''met_comment'',''eqm_meter_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.met_comment,''0'')),''met_comment'',''eqm_meter_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_meter_h as a 
 inner join act_meter_pnt_tbl  as b 
 on (a.code_eqp=b.id_meter and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,met_comment,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 
------act_met_warm
Raise notice ''33'';
Raise notice ''33'';

insert into act_met_warm(id_meter,warm,warm_comment,dat_b,dat_e) 

select distinct t1.code_eqp,t1.warm,t2.warm_comment

,case when t2.dt_b<=t1.dt_b then t1.dt_b else t2.dt_b end
 ,case when t2.dt_e>=t1.dt_e then t1.dt_e else t2.dt_e end

from 
(select code_eqp,dt_b,max(dt_e) as dt_e,warm from (
select a.code_eqp,coalesce(a.warm,0) as warm
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.warm,0)),''warm'',''eqm_meter_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.warm,0)),''warm'',''eqm_meter_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_meter_h as a 
 inner join act_meter_pnt_tbl  as b 
 on (a.code_eqp=b.id_meter and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,warm,dt_b) as t1 
inner join 
(select code_eqp,dt_b,max(dt_e) as dt_e,warm_comment from (
select a.code_eqp,coalesce(a.warm_comment,''0'') as warm_comment
 ,case when mdtb(a.dt_b,b.dat_b,text(coalesce(a.warm_comment,''0'')),''warm_comment'',''eqm_meter_h'',a.code_eqp)<=b.dat_b 
   then b.dat_b else mdtb(a.dt_b,b.dat_b,text(coalesce(a.warm,''0'')),''warm_comment'',''eqm_meter_h'',a.code_eqp) end as dt_b
 ,case when coalesce(a.dt_e,b.dat_e)>=b.dat_e then b.dat_e else a.dt_e end as dt_e 
from eqm_meter_h as a 
 inner join act_meter_pnt_tbl  as b 
 on (a.code_eqp=b.id_meter and (a.dt_b<b.dat_e 
     and coalesce(a.dt_e,b.dat_e)>b.dat_b)) ) as k 
 group by code_eqp,warm_comment,dt_b) as t2 
 on (t1.code_eqp=t2.code_eqp and t2.dt_b<t1.dt_e and t2.dt_e>t1.dt_b); 

----------other parameters
---act_warm_period
Raise notice ''34'';
for r12 in select distinct b.id_client from act_pnt_share as a inner join 
   act_point_branch_tbl as b on (a.id_point=b.id_point) 
      where a.id_zone in (4,5) loop
 insert into act_warm_period 
 select id_client,dat_b,coalesce(dat_e,dte) from warm_period where id_client=r12.id_client and 
   ((dtb between dat_b and coalesce(dat_e,dte)) or (dte between dat_b and coalesce(dat_e,dte)));

 for r in select count(*) from act_warm_period where id_client=r12.id_client 
   having count(*)=0 loop 
   insert into act_warm_period 
   select r12.id_client,dat_b,coalesce(dat_e,dte) from warm_period 
    where (id_client=idres or id_client  in (select id from clm_client_tbl where flag_balance=1))and 
   ((dtb between dat_b and coalesce(dat_e,dte)) or (dte between dat_b and coalesce(dat_e,dte)));
 end loop;
end loop;

---------add_calcs 7.15
---cnt_met ident=51
Raise notice ''35'';

for r in select distinct a.* from (select * from act_met_kndzn_tbl 
    where ktr_demand>0 
   ) as a inner join 
  (select * from act_met_cntmet where count_met=1) as b
  on (a.id_meter=b.id_meter and b.dat_b<a.dat_e and b.dat_e>a.dat_b and  a.kind_energy=1) loop 
 
update act_met_kndzn_tbl set meter_demand=r.ktr_demand 
  ,calc_demand_cnt=k.wp 
  ,comment_cnt=k.comment
  ,ktr_demand=k.wp*k_tr 
  ,ident=51
 from 
(select r.id_point as id_point,r.id_meter as id_meter,r.num_eqp as num_eqp
   ,r.kind_energy as kind_energy,r.id_zone as id_zone,r.dat_b as dat_b 
   ,a1.met_comment as comment 
   ,round((amperage_nom*buffle*(voltage_nom::numeric/1000)*sqrt(3)::numeric)/100,2) as p_ch 
   ,round(r.met_demand::numeric/(case when r.id_zone=0 then wtm_p 
     else round(wtm_p*round(r.met_demand::numeric/sum_zone,2),0) end),2) as p_w 
   ,case when phase=1 then round(amperage_nom*0.22*buffle*(case when r.id_zone=0 
     then wtm_p else round(wtm_p*round(r.met_demand::numeric/sum_zone,2),0) end) 
    /100::numeric,0) else round(amperage_nom*voltage_nom/1000*cos_p*sqrt(3)::numeric*buffle*
     (case when r.id_zone=0 
     then wtm_p else round(wtm_p*round(r.met_demand::numeric/sum_zone,2),0) end)
    /100::numeric,0) end as wp

 from 
  (select a.id_meter,a.met_comment
   from act_met_cntmet as a where a.id_meter=r.id_meter 
   -- and a.dat_b<r.dat_e and a.dat_e>r.dat_b 
     and a.count_met=1 
     and a.dat_b=(select max(b.dat_b) from act_met_cntmet as b 
     where b.id_meter=r.id_meter and b.dat_b<r.dat_e and b.dat_e>r.dat_b 
      and b.count_met=1)) as a1 
  left join 
   (select a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.dat_b
    ,sum(a.met_demand) as sum_zone from act_met_kndzn_tbl as a 
     where a.id_point=r.id_point and a.id_meter=r.id_meter 
       and a.num_eqp=r.num_eqp and a.kind_energy=r.kind_energy 
       and a.dat_b=r.dat_b and a.id_zone<>0 group by a.id_point,a.id_meter
    ,a.num_eqp,a.kind_energy,a.dat_b) as a2 
   on true 
  inner join (select a.id,a.voltage_nom,a.amperage_nom,a.phase,a.buffle 
     from eqi_meter_tbl as a where a.id=r.id_type_eqp) as a3 
   on true 
  inner join (select sum(round(b.wtm*date_mi(b.dat_e,b.dat_b),0)) as wtm_p  
     from 
     (select a.id_point,a.wtm/date_mi(r.dat_e,r.dat_b)::numeric as wtm  
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
    from act_pnt_wtm as a where a.id_point=r.id_point and a.dat_b<r.dat_e 
    and a.dat_e>r.dat_b) as b 
    ) as a4 
   on true
  left join (select sum(round(c.vcos*date_mi(c.dat_e,c.dat_b),2)) as cos_p 
   from 
    (select a.id_point,b.value_cos::numeric/date_mi(r.dat_e,r.dat_b) as vcos
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
     from act_pnt_tg as a inner join eqk_tg_tbl as b 
    on (a.id_tg=b.id)
    where a.id_point=r.id_point and a.dat_b<r.dat_e and a.dat_e>r.dat_b) as c
   ) as a5
   on true) as k 
 where k.id_meter=act_met_kndzn_tbl.id_meter 
  and k.id_point=act_met_kndzn_tbl.id_point 
  and k.num_eqp=act_met_kndzn_tbl.num_eqp 
  and k.kind_energy=act_met_kndzn_tbl.kind_energy
  and k.id_zone=act_met_kndzn_tbl.id_zone 
  and k.dat_b=act_met_kndzn_tbl.dat_b and k.p_ch>k.p_w;
end loop;
------cnt_itr ident=52
Raise notice ''36'';
for r in select distinct a.*,b.accuracy from (select * from act_met_kndzn_tbl 
    where ktr_demand>0 and kind_energy=1
    and meter_demand is null) as a inner join 
  (select * from act_pnt_cntitr where count_itr=1) as b
  on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) loop 

Raise notice '' r.id_point for 5     %'',r.id_meter;


update act_met_kndzn_tbl set meter_demand=r.ktr_demand 
  ,calc_demand_cnt=k.wp 
  ,comment_cnt=k.comment
  ,ktr_demand=k.wp 
  ,calc_demand_nocnt=coalesce(k.wp,0),
   p_w=k.p_w
  ,ident=52
 from 
(select r.id_point as id_point,r.id_meter as id_meter,r.num_eqp as num_eqp
   ,r.kind_energy as kind_energy,r.id_zone as id_zone,r.dat_b as dat_b 
   ,a1.itr_comment as comment 
   ,round((r.ktr_demand/(sqrt(3)::numeric*un_p*cos_p*r.k_ts*r.i_ts*
     (case when r.id_zone=0 then wtm_p 
     else round(wtm_p*round(r.ktr_demand::numeric/sum_zone,6),5) end)
    ))*100,2) as p_w
   ,round(r.accuracy*(sqrt(3)::numeric*un_p*cos_p*r.k_ts*r.i_ts*
     (case when r.id_zone=0 then wtm_p 
     else round(wtm_p*round(r.ktr_demand::numeric/sum_zone,5),5) end)
    )/100,0) as wp
 from 
  (select a.id_point,a.itr_comment
   from act_pnt_cntitr as a where a.id_point=r.id_point 
    --and a.dat_b<r.dat_e and a.dat_e>r.dat_b 
    and a.count_itr=1 
    and a.dat_b=(select max(b.dat_b) from act_pnt_cntitr as b 
     where b.id_point=r.id_point and b.dat_b<r.dat_e and b.dat_e>r.dat_b 
      and b.count_itr=1))   as a1 
  left join 
   (select a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.dat_b
    ,sum(a.ktr_demand) as sum_zone from act_met_kndzn_tbl as a 
     where a.id_point=r.id_point and a.id_meter=r.id_meter 
       and a.num_eqp=r.num_eqp and a.kind_energy=r.kind_energy 
       and a.dat_b=r.dat_b and a.id_zone<>0 group by a.id_point,a.id_meter
    ,a.num_eqp,a.kind_energy,a.dat_b) as a2 
   on true 
  inner join (select sum(round(b.wtm*date_mi_nol(r.dat_e,r.dat_b),0)) as wtm_p  
     from 
     (select a.id_point,a.wtm/date_mi_nol(a.dat_e,a.dat_b)::numeric as wtm  
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
    from act_pnt_wtm as a where a.id_point=r.id_point and a.dat_b<r.dat_e 
    and a.dat_e>r.dat_b) as b 
    ) as a4 
   on true
  inner join (select sum(round(c.un*date_mi_nol(c.dat_e,c.dat_b),6)) as un_p 
   from 
    (select a.id_point,b.voltage_min::numeric/date_mi_nol(r.dat_e,r.dat_b) as un
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
     from act_pnt_un as a inner join eqk_voltage_tbl as b 
    on (a.id_voltage=b.id)
    where a.id_point=r.id_point and a.dat_b<r.dat_e and a.dat_e>r.dat_b) as c
   ) as a3 
   on true 
  left join (select sum(round(c.vcos*date_mi_nol(c.dat_e,c.dat_b),2)) as cos_p 
   from 
    (select a.id_point,b.value_cos::numeric/date_mi_nol(r.dat_e,r.dat_b) as vcos
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
     from act_pnt_tg as a inner join eqk_tg_tbl as b 
    on (a.id_tg=b.id)
    where a.id_point=r.id_point and a.dat_b<r.dat_e and a.dat_e>r.dat_b) as c
   ) as a5
   on true) as k 
 where k.id_meter=act_met_kndzn_tbl.id_meter 
  and k.id_point=act_met_kndzn_tbl.id_point 
  and k.num_eqp=act_met_kndzn_tbl.num_eqp 
  and k.kind_energy=act_met_kndzn_tbl.kind_energy
  and k.id_zone=act_met_kndzn_tbl.id_zone 
  and k.dat_b=act_met_kndzn_tbl.dat_b and k.p_w<r.accuracy;

 Raise notice '' r.id_point for nedogruz transformatora    %   % % % % '',r.id_meter,r.DAT_B,r.DAT_E,r.I_TS,r.KTR_DEMAND;

end loop;


Raise notice ''36_1'';
for r in select distinct a.*,b.accuracy from (select * from act_met_kndzn_tbl 
    where ktr_demand>0 and kind_energy=1) as a inner join 
  (select * from act_pnt_cntitr where count_itr=0) as b
  on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) loop 

Raise notice '' r.id_point for 5     %   % % % % '',r.id_meter,r.DAT_B,r.DAT_E,r.I_TS,r.KTR_DEMAND;
      
update act_met_kndzn_tbl set   calc_demand_nocnt=coalesce(k.wp,0),  p_w=k.p_w
  , meter_demand=r.ktr_demand 
  ,comment_cnt= (case when k.p_w<r.accuracy then ''^'' else '' '' end)::varchar
 from           
(select r.id_point as id_point,r.id_meter as id_meter,r.num_eqp as num_eqp
   ,r.kind_energy as kind_energy,r.id_zone as id_zone,r.dat_b as dat_b 
   ,a1.itr_comment as comment 
   ,round((r.ktr_demand/(sqrt(3)::numeric
    *case when coalesce(un_p,0)<>0 then un_p else 0.4 end
    *case when coalesce(cos_p,0)<>0 then cos_p else 0.78 end
    *r.k_ts*r.i_ts*
     (case when r.id_zone=0 then case when coalesce(wtm_p,0)<>0 then wtm_p else 176 end
     else round((case when coalesce(wtm_p,0)<>0 then wtm_p else 176 end)*
    round(r.ktr_demand::numeric/sum_zone,5),5) end)
    ))*100,2) as p_w
   ,round(r.accuracy*(sqrt(3)::numeric
     *case when coalesce(un_p,0)<>0 then un_p else 0.4 end
     *case when coalesce(cos_p,0)<>0 then cos_p else 0.78 end
     *r.k_ts*r.i_ts*
     (case when r.id_zone=0 then (case when coalesce(wtm_p,0)<>0 then wtm_p else 176 end)
     else round((case when coalesce(wtm_p,0)<>0 then wtm_p else 176 end)*
      round(r.ktr_demand::numeric/sum_zone,5),5) end)
    )/100,0) as wp
 from 
  (select a.id_point,a.itr_comment
   from act_pnt_cntitr as a where a.id_point=r.id_point 
    --and a.dat_b<r.dat_e and a.dat_e>r.dat_b 
    and a.count_itr=0 
    and a.dat_b=(select max(b.dat_b) from act_pnt_cntitr as b 
     where b.id_point=r.id_point and b.dat_b<r.dat_e and b.dat_e>r.dat_b 
      and b.count_itr=0))   as a1 
  left join 
   (select a.id_point,a.id_meter,a.num_eqp,a.kind_energy,a.dat_b
    ,sum(a.ktr_demand) as sum_zone from act_met_kndzn_tbl as a 
     where a.id_point=r.id_point and a.id_meter=r.id_meter 
       and a.num_eqp=r.num_eqp and a.kind_energy=r.kind_energy 
       and a.dat_b=r.dat_b and a.id_zone<>0 group by a.id_point,a.id_meter
    ,a.num_eqp,a.kind_energy,a.dat_b) as a2 
   on true 
  inner join (select sum(round(b.wtm*date_mi_nol(r.dat_e,r.dat_b),0)) as wtm_p  
     from 
     (select a.id_point,a.wtm/date_mi_nol(a.dat_e,a.dat_b)::numeric as wtm  
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
    from act_pnt_wtm as a where a.id_point=r.id_point and a.dat_b<r.dat_e 
    and a.dat_e>r.dat_b) as b 
    ) as a4 
   on true
  inner join (select sum(round(c.un*date_mi_nol(c.dat_e,c.dat_b),6)) as un_p 
   from 
    (select a.id_point,b.voltage_min::numeric/date_mi_nol(r.dat_e,r.dat_b) as un
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
     from act_pnt_un as a inner join eqk_voltage_tbl as b 
    on (a.id_voltage=b.id)
    where a.id_point=r.id_point and a.dat_b<r.dat_e and a.dat_e>r.dat_b) as c
   ) as a3 
   on true 
  left join (select sum(round(c.vcos*date_mi_nol(c.dat_e,c.dat_b),2)) as cos_p 
   from 
    (select a.id_point,b.value_cos::numeric/date_mi_nol(r.dat_e,r.dat_b) as vcos
     ,case when a.dat_b<=r.dat_b then r.dat_b else a.dat_b end as dat_b
     ,case when a.dat_e>=r.dat_e then r.dat_e else a.dat_e end as dat_e
     from act_pnt_tg as a inner join eqk_tg_tbl as b 
    on (a.id_tg=b.id)
    where a.id_point=r.id_point and a.dat_b<r.dat_e and a.dat_e>r.dat_b) as c
   ) as a5
   on true) as k 
where  k.id_meter=act_met_kndzn_tbl.id_meter
 and k.id_point=act_met_kndzn_tbl.id_point 
 and k.num_eqp=act_met_kndzn_tbl.num_eqp 
 and k.kind_energy=act_met_kndzn_tbl.kind_energy
 and k.id_zone=act_met_kndzn_tbl.id_zone 
 and k.dat_b=act_met_kndzn_tbl.dat_b 
 and act_met_kndzn_tbl.i_ts*act_met_kndzn_tbl.i_ts>1; -- and k.p_w>=5;
  


end loop;

--act_met_warm
Raise notice ''37'';
for r in select distinct a.* from (select a11.*
   ,case when a11.dat_b<=w_dtb then w_dtb else a11.dat_b end as wdtb 
   ,case when a11.dat_e>=w_dte then w_dte else a11.dat_e end as wdte 
    from act_met_kndzn_tbl as a11
    where a11.ktr_demand>0 and (a11.dat_b<w_dte and a11.dat_e>w_dtb) 
   ) as a inner join 
  (select * from act_met_warm where warm=1) as b
  on (a.id_meter=b.id_meter and b.dat_b<a.dat_e and b.dat_e>a.dat_b) loop 
 Raise Notice ''Warm_calc'';
update act_met_kndzn_tbl set calc_demand_w=warm_dem  
  ,comment_w=comment
  ,ktr_demand=ktr_demand+warm_dem  
 from 
(select r.id_point as id_point,r.id_meter as id_meter,r.num_eqp as num_eqp
   ,r.kind_energy as kind_energy,r.id_zone as id_zone,r.dat_b as dat_b 
   ,a1.warm_comment as comment 
   ,round(round((r.ktr_demand::numeric/date_mi_nol(r.dat_e,r.dat_b))*
    date_mi_nol(r.wdte,r.wdtb),0)*0.05,0) as warm_dem
 from 
  (select a.id_meter,a.warm_comment
   from act_met_warm as a where a.id_meter=r.id_meter and a.warm=1 and 
    a.dat_b=(select max(dat_b) from act_met_warm as b where b.id_meter=r.id_meter
    and b.dat_b<r.dat_e and b.dat_e>r.dat_b and b.warm=1)) as a1 
) as k
 where k.id_meter=act_met_kndzn_tbl.id_meter 
  and k.id_point=act_met_kndzn_tbl.id_point 
  and k.num_eqp=act_met_kndzn_tbl.num_eqp 
  and k.kind_energy=act_met_kndzn_tbl.kind_energy
  and k.id_zone=act_met_kndzn_tbl.id_zone 
  and k.dat_b=act_met_kndzn_tbl.dat_b;

end loop;
---------add_calcs 7.15



--act_losts_eqm_tbl
Raise notice ''38'';
for r in select distinct a.*,b.count_lost as cnt_lost from act_point_branch_tbl as a 
   inner join act_pnt_lost as b on (a.id_point=b.id_point) 
   left join act_pnt_hlosts as c on (c.id_point=a.id_point)
   where c.id_point is null 

----24.01.2011 òåïåðü îáîðóäîâàíèå äëÿ ðàñ÷åòà ïîòåðü âûáèðàåì äëÿ âñåõ, ó êîãî îíî åñòü

  and (id_client=id_rclient or (id_client<>id_rclient and id_rclient<>idres
     ) or (id_client<>id_rclient and id_rclient  not in (select id from clm_client_tbl where flag_balance=1)
     )) 
    loop 

    if  (r.id_p_point is null) then
       ppnt:=0;
    else
       ppnt:=1;
    end if;
 --- --rs:=lost_eqm(r.id_point,r.id_point,null,r.dat_b,r.dat_e,r.count_lost,r.id_client);
   Raise notice ''r.id_point - %'',r.id_point; 
   Raise notice ''r.count_lost - %'',r.cnt_lost; 
    rs:=inlost_eqm(r.id_point,r.id_point,null::int,r.dat_b,r.dat_e,r.id_client,r.cnt_lost,ppnt,0);
end loop;


---act_pnt_inlost

--- act_losts_eqm_tbl 
for rin in select count(*) as cnt,id_point,dat_b,dat_e 
  from act_point_branch_tbl  
   group by id_point,dat_b,dat_e having count(*)=2
 loop
   i_1:=1;
   for rin_1 in select * from act_point_branch_tbl where id_point=rin.id_point 
     loop 
     dtm2=(rin_1.dat_e-rin_1.dat_b)/2;
     if i_1=1 then
       raise notice ''RIN 1 %'',rin_1.id_point;
       raise notice ''RIN 1 %'',rin_1.id_p_point;
       raise notice ''RIN 1 %'',rin_1.dat_b;
       raise notice ''RIN 1 %'',rin_1.dat_e;
 raise notice ''RIN 1  dtm2  %'',dtm2;
     
      update act_point_branch_tbl set dat_e=date_mii(rin_1.dat_b,-dtm2)  
        where id_point=rin_1.id_point and 
          coalesce(id_p_point,0)=coalesce(rin_1.id_p_point,0)  
          and dat_b=rin_1.dat_b and dat_e=rin_1.dat_e;
      i_1:=2;
     end if;

     if i_1=2 then
      update act_point_branch_tbl set dat_b=date_mii(rin_1.dat_b,-dtm2)  
        where id_point=rin_1.id_point and 
          coalesce(id_p_point,0)=coalesce(rin_1.id_p_point,0)  
          and dat_b=rin_1.dat_b and dat_e=rin_1.dat_e;
     end if;
   end loop;

end loop;


------update act_losts_eqm_tbl
Raise Notice ''update act_losts_eqm_tbl begin'';
Raise notice ''38_1_1_upd'';
cdt_b:=null;

for r in select b.mdat_b,c.mdat_e,d.* 
      from (select id_point,id_eqp,id_p_eqp,count(*) as cnt 
       from act_losts_eqm_tbl group by id_point,id_eqp,id_p_eqp
           having count(*)>1) as a 
        inner join (select id_point,min(dat_b) as mdat_b,id_eqp,id_p_eqp
          from act_losts_eqm_tbl 
        group by id_point,id_eqp,id_p_eqp) as b on (a.id_point=b.id_point 
         and coalesce(a.id_p_eqp,0)=coalesce(b.id_p_eqp,0) 
         and a.id_eqp=b.id_eqp) 
        inner join (select id_point,max(dat_e) as mdat_e,id_eqp,id_p_eqp
          from act_losts_eqm_tbl 
        group by id_point,id_eqp,id_p_eqp) as c on (a.id_point=c.id_point 
         and coalesce(a.id_p_eqp,0)=coalesce(c.id_p_eqp,0) 
         and a.id_eqp=c.id_eqp) 
        inner join act_losts_eqm_tbl as d on (a.id_point=d.id_point 
         and coalesce(a.id_p_eqp,0)=coalesce(d.id_p_eqp,0) 
         and a.id_eqp=d.id_eqp)
       order by d.id_point,d.id_eqp,d.id_p_eqp,d.dat_b
       loop 
 Raise Notice ''id_eqp - %   dat_b=  % mdat_b= % cdt_b=%'',r.id_eqp,r.dat_b,r.mdat_b,cdt_b;
 if r.dat_b=r.mdat_b and cdt_b is null then 

   cdt_b:=r.mdat_b;
   cdt_e:=r.dat_e;
   Raise Notice ''cdt_b - % cdt_e -% '',cdt_b,cdt_b;
 else 
   if r.dat_b=cdt_e then 
    Raise Notice ''update'';
     update act_losts_eqm_tbl set dat_e=r.dat_e,tt=tt+r.tt 
      where id_point=r.id_point 
      and coalesce(id_p_eqp,0)=coalesce(r.id_p_eqp,0)  
      and id_eqp=r.id_eqp and dat_b=cdt_b;
 
    delete from act_losts_eqm_tbl where  id_point=r.id_point 
      and coalesce(id_p_eqp,0)=coalesce(r.id_p_eqp,0)  
      and id_eqp=r.id_eqp and dat_b=r.dat_b;

     cdt_e:=r.dat_e;

    if r.dat_e=r.mdat_e then
      cdt_b:=null;
      cdt_e:=null;
    end if;
   end if;
 end if;  
end loop;
Raise Notice ''update act_losts_eqm_tbl end'';
------update act_losts_eqm_tbl

----desc_border
Raise notice ''39'';
for r in select distinct a.* from act_point_branch_tbl  as a 
   inner join act_pnt_lost as b on (a.id_point=b.id_point) 
   where a.id_p_point is null 
  and id_client<>id_rclient and (id_rclient=idres or id_rclient  in (select id from clm_client_tbl where flag_balance=1)) 
 loop 

 rs1:=desc_border(r.id_point,r.id_point,r.dat_b,r.dat_e); 
 if rs1 is null then 
  raise notice ''---Not correct lost equipment for point %'',r.id_point;
   insert into act_res_notice 
   values(''Not correct lost equipment for point ''||r.id_point);
   --Return false;
 end if;
end loop;
------desc_border
/* 
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

--   no there  after calc 
update act_comp_percent set wp_parent =fact_par.fact,add_wp=(perc/100)*fact_par.fact from  
 (select id_point,sum(sum_demand) as fact from act_pwr_demand_tbl where kind_energy=1 group by id_point) fact_par
 where fact_par.id_point=act_comp_percent.id_p_point;

update act_losts_eqm_tbl set own_wp=c.add_wp 
from  act_comp_percent c 
where c.id_point=act_losts_eqm_tbl.id_point
-- and  c.id_p_point=act_losts_eqm_tbl.id_p_point
and c.id_eqp=act_losts_eqm_tbl.id_eqp
and c.dat_b=act_losts_eqm_tbl.dat_b
and c.dat_e=act_losts_eqm_tbl.dat_e;

update act_losts_eqm_tbl set own_wp=0.00 where own_wp is null;

 for test in select * from act_comp_percent order by id_point,dat_b,dat_e loop
      raise notice ''41 test.id_point  % ,id_p_point  %, id_eqp %, 
        sum_wp  % sum_wq %,wp_parent %,perc %,add_wp %'',
     test.id_point,test.id_p_point,test.id_eqp,
     test.sum_wp,test.sum_wq,test.wp_parent,test.perc,test.add_wp;

 end loop;

*/
Raise notice ''41'';
 --return 0;
 for test in select * from act_losts_eqm_tbl order by id_point,dat_b,dat_e loop
      raise notice ''41 test.id_point  % ,DAT_B  %, DAT_E %, sum_wp  % sum_wq %'',
     test.id_point,test.dat_b,test.dat_e,test.sum_wp,test.sum_wq;

 end loop;

for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) --inner join act_desclosts_eqm_tbl as c 
--     on (a.id_point=c.id_point) 
     where a.type_eqm=2 and ((b.id_client=idcl 
       and a1.id_client=b.id_client) or (a1.id_client=idcl 
       and b.id_client<>idcl)) loop
Raise NOtice ''sum_wp 1++++++++++++++++++++++++++++++++++'';

  update act_losts_eqm_tbl set sum_wp=(select sum(k.ktr_demand) 
    from (select distinct a.id_meter,a.num_eqp,a.kind_energy
     ,a.dat_b,a.id_zone,ktr_demand  
    from act_met_kndzn_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
   where b.id_eqp=r.id_eqp and a.kind_energy=1 and c.id_p_point is null) as k)
       where act_losts_eqm_tbl.id_eqp=r.id_eqp;

  update act_losts_eqm_tbl set sum_wq=(select sum(k.ktr_demand) 
    from (select distinct a.id_meter,a.num_eqp,a.kind_energy
     ,a.dat_b,a.id_zone,ktr_demand  
    from act_met_kndzn_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
   where b.id_eqp=r.id_eqp and a.kind_energy=2 and c.id_p_point is null) as k)
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;

end loop;

 for test in select * from act_losts_eqm_tbl order by id_point,dat_b,dat_e loop
      raise notice ''41/ test.id_point  % ,DAT_B  %, DAT_E %, sum_wp  % sum_wq %'',test.id_point,test.dat_b,test.dat_e,test.sum_wp,test.sum_wq;

 end loop;

Raise notice ''42'';
for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm,a1.id_client  
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and not (b.id_client=idcl 
       and a1.id_client=b.id_client)  
  -- ch_osa 2014-06-01 
  and sum_wp is null
 loop
Raise NOtice ''sum_wp 2'';
  update act_losts_eqm_tbl set sum_wp=a.wp1 
    from (select distinct k1.id_eqp,k1.kind_energy,k1.wp1 
     from (select ''1'' as k) as k left join (select a1.*,a2.id_client from 
      acd_calc_losts_tbl as a1 inner join acm_bill_tbl as a2 
       on (a1.id_doc=a2.id_doc) where a1.id_eqp=r.id_eqp 
       and a2.id_client=r.id_client 
       and date_trunc(''month'',a1.dat_e)=date_trunc(''month'',r.dat_e) limit 1) 
     as k1 on true) as a where act_losts_eqm_tbl.id_eqp=a.id_eqp 
      and a.kind_energy=1; 

  update act_losts_eqm_tbl set sum_wq=a.wp1 
    from (select distinct k1.id_eqp,k1.kind_energy,k1.wp1  
     from (select ''1'' as k) as k left join (select a1.*,a2.id_client from 
      acd_calc_losts_tbl as a1 inner join acm_bill_tbl as a2 
       on (a1.id_doc=a2.id_doc) where a1.id_eqp=r.id_eqp 
       and a2.id_client=r.id_client 
       and date_trunc(''month'',a1.dat_e)=date_trunc(''month'',r.dat_e) limit 1) 
     as k1 on true) as a where act_losts_eqm_tbl.id_eqp=a.id_eqp 
      and a.kind_energy=2; 

end loop;
 for test in select * from act_losts_eqm_tbl order by id_point,dat_b,dat_e loop
      raise notice ''42. test.id_point  % ,DAT_B  %, DAT_E %, sum_wp  % sum_wq %'',test.id_point,test.dat_b,test.dat_e,test.sum_wp,test.sum_wq;

 end loop;


Raise notice ''43'';
for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and sum_wp is null loop
----dates????
Raise NOtice ''sum_wp 3'';

  update act_losts_eqm_tbl set sum_wp=(select sum(k.ktr_demand) 
    from (select distinct a.id_meter,a.num_eqp,a.kind_energy
     ,a.dat_b,a.id_zone,ktr_demand  
    from act_met_kndzn_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
   where b.id_eqp=r.id_eqp and a.kind_energy=1 and c.id_p_point is null) as k)
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;
end loop;
 for test in select * from act_losts_eqm_tbl order by id_point,dat_b,dat_e loop
      raise notice ''43 test.id_point  % ,DAT_B  %, DAT_E %, sum_wp  % sum_wq %'',test.id_point,test.dat_b,test.dat_e,test.sum_wp,test.sum_wq;

 end loop;


Raise notice ''44'';
for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join act_point_branch_tbl as b 
     on (a.id_point=b.id_point) where a.type_eqm=2 and sum_wq is null loop

Raise NOtice ''sum_wq 3'';

  update act_losts_eqm_tbl set sum_wq=(select sum(k.ktr_demand) 
    from (select distinct a.id_meter,a.num_eqp,a.kind_energy
     ,a.dat_b,a.id_zone,ktr_demand  
    from act_met_kndzn_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
     inner join act_point_branch_tbl as c on (c.id_point=a.id_point)
   where b.id_eqp=r.id_eqp and a.kind_energy=2 and c.id_p_point is null) as k)
    where act_losts_eqm_tbl.id_eqp=r.id_eqp;

end loop;
 for test in select * from act_losts_eqm_tbl order by id_point,dat_b,dat_e loop
      raise notice ''44. test.id_point  % ,DAT_B  %, DAT_E %, sum_wp  % sum_wq %'',test.id_point,test.dat_b,test.dat_e,test.sum_wp,test.sum_wq;

 end loop;


Raise notice ''38_1_2'';

for r in select distinct a.id_eqp,a.dat_b,a.dat_e,a.type_eqm 
     from (act_losts_eqm_tbl as a inner join act_eqp_branch_tbl as a1 
     on (a.id_eqp=a1.code_eqp)) inner join (select distinct id_point,id_client
         ,id_rclient from act_point_branch_tbl) as b 
     on (a.id_point=b.id_point) --inner join act_inlosts_eqm_tbl as c 
    -- on (a.id_point=c.id_point) 
     where a.type_eqm=2 and ((b.id_client=idcl 
      -- and a1.id_client=b.id_client
      ) or (a1.id_client=idcl 
       and b.id_client<>idcl)) loop

Raise NOtice ''sum_wp 11111111'';
Raise NOtice ''id_eqp - %'',r.id_eqp;

  update act_losts_eqm_tbl set sum_wp=(select sum(k.ktr_demand) 
    from (select distinct a.id_meter,a.num_eqp,a.kind_energy
     ,a.dat_b,a.id_zone,ktr_demand  
    from act_met_kndzn_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
   where b.id_eqp=r.id_eqp and a.kind_energy=1 
        ) as k)
       where act_losts_eqm_tbl.id_eqp=r.id_eqp and res_l=1;

  update act_losts_eqm_tbl set sum_wq=(select sum(k.ktr_demand) 
    from (select distinct a.id_meter,a.num_eqp,a.kind_energy
     ,a.dat_b,a.id_zone,ktr_demand  
    from act_met_kndzn_tbl as a inner join act_losts_eqm_tbl as b 
     on (a.id_point=b.id_point and b.dat_b<a.dat_e and b.dat_e>a.dat_b) 
   where b.id_eqp=r.id_eqp and a.kind_energy=2 
        ) as k)
    where act_losts_eqm_tbl.id_eqp=r.id_eqp and res_l=1;

end loop;

 for test in select * from act_losts_eqm_tbl order by id_point,dat_b,dat_e loop
      raise notice ''45. test.id_point  % ,DAT_B  %, DAT_E %, sum_wp  % sum_wq %'',test.id_point,test.dat_b,test.dat_e,test.sum_wp,test.sum_wq;

 end loop;

---delete from sys_errorlog_tb;
----------calc all losts on main client 

delete from act_losts_eqm2_tbl;
insert into act_losts_eqm2_tbl select distinct *  from act_losts_eqm_tbl order by id_point,id_eqp,id_p_eqp,dat_b,dat_e;
delete from act_losts_eqm_tbl;
insert into act_losts_eqm_tbl select distinct *  from act_losts_eqm2_tbl order by id_point,id_eqp,id_p_eqp,dat_b,dat_e;
/*for rl in select * from act_losts_eqm2_tbl loop
insert into act_losts_eqm_tbl  (id_point,id_eqp,id_p_eqp,dat_b,dat_e,type_eqm,id_type_eqp,
sn_len,tt,pxx_r0,pkz_x0,ixx,ukz_un,sum_wp,sum_wq,res_l)
values  (rl.id_point,rl.id_eqp,rl.id_p_eqp,rl.dat_b,rl.dat_e,rl.type_eqm,rl.id_type_eqp,
rl.sn_len,rl.tt,rl.pxx_r0,rl.pkz_x0,rl.ixx,rl.ukz_un,rl.sum_wp,rl.sum_wq,rl.res_l);
end loop;
*/
-- Checked OSA
insert into  act_comp_percent (id_point,id_eqp,id_p_point,sn_len,sum_wp,sum_wq,dat_b,dat_e,
  wp_parent,perc,add_wp,all_wp)
select l.id_point,l.id_eqp,p.id_p_point,sn_len,sum_wp,sum_wq,l.dat_b,l.dat_e ,0 as wq_parent,0 as perc,0 as add_wq,0 as all_wq
from act_losts_eqm_tbl l,act_point_branch_tbl p 
where l.type_eqm=2 and p.id_point=l.id_point 
     and p.id_p_point is not null and l.res_l<>2
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
    /*
--   no there  after calc 
update act_comp_percent set wp_parent =fact_par.fact,add_wp=(perc/100)*fact_par.fact from  
 (select id_point,sum(sum_demand) as fact from act_pwr_demand_tbl where kind_energy=1 group by id_point) fact_par
 where fact_par.id_point=act_comp_percent.id_p_point;

update act_losts_eqm_tbl set own_wp=c.add_wp 
from  act_comp_percent c 
where c.id_point=act_losts_eqm_tbl.id_point
-- and  c.id_p_point=act_losts_eqm_tbl.id_p_point
and c.id_eqp=act_losts_eqm_tbl.id_eqp
and c.dat_b=act_losts_eqm_tbl.dat_b
and c.dat_e=act_losts_eqm_tbl.dat_e;

update act_losts_eqm_tbl set own_wp=0.00 where own_wp is null;

 for test in select * from act_comp_percent order by id_point,dat_b,dat_e loop
      raise notice ''41 test.id_point  % ,id_p_point  %, id_eqp %, 
        sum_wp  % sum_wq %,wp_parent %,perc %,add_wp %'',
     test.id_point,test.id_p_point,test.id_eqp,
     test.sum_wp,test.sum_wq,test.wp_parent,test.perc,test.add_wp;

 end loop;
*/

raise notice ''Checked OSA'';
for test in select id_point,id_eqp,id_p_eqp,dat_b,dat_e,count(*)
  from act_losts_eqm_tbl group by id_point,id_eqp,id_p_eqp,dat_b,dat_e 
  having count(*) >1 loop
 insert into sys_error_tmp (nam,res,id_error,ident) values 
  (''d_loste'',100,523,''d_loste'');
   insert into act_res_notice 
   values(''Double in table act_losts_eqm_tbl'');

 return false;
end loop;


--act_pwr_demand_tbl
--act_calc_losts_tbl

Return true;

end;
' Language 'plpgsql';




   

  

