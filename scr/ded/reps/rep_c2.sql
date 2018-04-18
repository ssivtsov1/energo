DROP TABLE rep_tree_demand_tbl;
CREATE TABLE rep_tree_demand_tbl (
    id_client        int,
    id_point         int,
    id_tree          int,
    id_border        int,
    demand           numeric(14,4),
    sub_demand       numeric(14,4)
--    count_month      int
);		

DROP TABLE rep_avr_demand_tbl;
CREATE TABLE rep_avr_demand_tbl (
    id_client        int,
    month_count      int,
    demand           numeric(14,4),
    avg_demand       numeric(14,4)
);		


CREATE or replace FUNCTION rep_c2_fun (date,date)
  RETURNS int
  AS                                                                                              
  '
  declare
  pdtb Alias for $1;    --\
  pdte Alias for $2;    --\

  r record;
  vtree_demand numeric;
begin

 delete from rep_tree_demand_tbl;
 delete from rep_avr_demand_tbl;

 -- выберем все ветки, начинающиеся не с граници раздела, и не принадлежащие РЕС
 -- (крупные абоненты, не подключенные к схеме РЕС)
 for r in 
  select t.id as tree, t.id_client
  from eqm_tree_tbl as t 
--  join eqm_eqp_tree_tbl as tt on (t.id = tt.id_tree)
--  join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id)
  join eqm_equipment_tbl as eqr on (t.code_eqp=eqr.id)
--  join eqm_borders_tbl as bd  on (eq.id = bd.code_eqp)
  where (eqr.type_eqp<>9) 
  and t.id_client <> syi_resid_fun()
--  and (eq.type_eqp=9)
 loop

  perform rep_tree_demand_fun(NULL,r.tree,r.id_client,pdtb,pdte);

 end loop;

  Raise Notice ''- - - - - - - - - - - part 1 ok'';
 --абоненты, подключенные к схеме РЕС

 for r in 
  select bd.code_eqp as border, eqt.id_tree as tree, bd.id_clientb as id_client
  from eqm_tree_tbl as t 
  join eqm_eqp_tree_tbl as tt on (t.id = tt.id_tree)
  join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id)
  join eqm_borders_tbl as bd  on (eq.id = bd.code_eqp)
  join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>t.id)
  where 
  t.id_client = syi_resid_fun()
  and (eq.type_eqp=9)
  and eqt.code_eqp_e is null
 loop

  perform rep_tree_demand_fun(r.border,r.tree,r.id_client,pdtb,pdte);

 end loop;
  Raise Notice ''- - - - - - - - - - - part 2 ok'';

 --точки учета на стороне РЕС
 for r in 
  select eq.id as point, tt.id_tree as tree, use.id_client
  from eqm_tree_tbl as t 
  join eqm_eqp_tree_tbl as tt on (t.id = tt.id_tree)
  join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id)
  join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id)
  where 
  t.id_client = syi_resid_fun()
  and (eq.type_eqp=12)
 loop

  Raise Notice ''- res point  %  '',r.point;

   select into vtree_demand coalesce(sum(pd.fact_demand+pd.fact_losts),0) 
   from 
   acm_bill_tbl as b  
   join acd_pwr_demand_tbl as pd on (pd.id_doc= b.id_doc and pd.id_point = r.point ) 
   where b.id_client= r.id_client  
   and b.id_pref = 10
   and b.idk_doc = 200
   and b.value <> 0
   and date_trunc(''month'', b.mmgg) >=date_trunc(''month'', pdtb) 
   and date_trunc(''month'', b.mmgg) <=date_trunc(''month'', pdte);


   if (vtree_demand <> 0) then 
    insert into rep_tree_demand_tbl(id_client,id_border,id_tree,demand)
    values (r.id_client,0,r.tree,vtree_demand);
   end if;


 end loop;
  Raise Notice ''- - - - - - - - - - - part 3 ok'';


 insert into rep_avr_demand_tbl(id_client,demand)
 select rt.id_client,sum(rt.demand) from rep_tree_demand_tbl as rt
    left join clm_client_tbl as c on (c.id = rt.id_client)
    left join clm_statecl_tbl as scl on (c.id = scl.id_client)
    where scl.id_section not in (205,206,207,208) 
    and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)
    and c.book=-1
    group by rt.id_client;




 update rep_avr_demand_tbl set month_count = sss.mc
from (
  select id_client, count(distinct date_trunc(''month'',b.mmgg)) as mc
  from acm_bill_tbl as b  
  where b.id_pref = 10
   and b.idk_doc = 200
   and b.value <> 0
   and date_trunc(''month'', b.mmgg) >=date_trunc(''month'', pdtb) 
   and date_trunc(''month'', b.mmgg) <=date_trunc(''month'', pdte)
   group by id_client
)  as sss
   where sss.id_client= rep_avr_demand_tbl.id_client ; 

 update rep_avr_demand_tbl set month_count = date_part(''month'', pdte)-date_part(''month'', pdtb)+1
 where month_count is null;

 update rep_avr_demand_tbl set avg_demand = round(demand/month_count);

 RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          

--------------------------------------------------------------------------------------------
-- выборка абонентов с потреблением СУБАБОНЕНТОВ больше 50 000 квтг
CREATE or replace FUNCTION rep_c3_fun (date,date)
  RETURNS int
  AS                                                                                              
  '
  declare
  pdtb Alias for $1;    --\
  pdte Alias for $2;    --\

  r record;
  vtree_demand numeric;
begin

 delete from rep_tree_demand_tbl;
 delete from rep_avr_demand_tbl;

 -- выберем все ветки, начинающиеся не с граници раздела, и не принадлежащие РЕС
 -- (крупные абоненты, не подключенные к схеме РЕС)
 for r in 
  select t.id as tree, t.id_client
  from eqm_tree_tbl as t 
  join eqm_equipment_tbl as eqr on (t.code_eqp=eqr.id)
  where (eqr.type_eqp<>9) 
  and t.id_client <> syi_resid_fun()
 loop

  perform rep_tree_demand_fun(NULL,r.tree,r.id_client,pdtb,pdte);

 end loop;

  Raise Notice ''- - - - - - - - - - - part 1 ok'';
 --абоненты, подключенные к схеме РЕС

 for r in 
  select bd.code_eqp as border, eqt.id_tree as tree, bd.id_clientb as id_client
  from eqm_tree_tbl as t 
  join eqm_eqp_tree_tbl as tt on (t.id = tt.id_tree)
  join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id)
  join eqm_borders_tbl as bd  on (eq.id = bd.code_eqp)
  join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>t.id)
  where 
  t.id_client = syi_resid_fun()
  and (eq.type_eqp=9)
  and eqt.code_eqp_e is null
 loop

  perform rep_tree_demand_fun(r.border,r.tree,r.id_client,pdtb,pdte);

 end loop;
  Raise Notice ''- - - - - - - - - - - part 2 ok'';

 insert into rep_avr_demand_tbl(id_client,demand)
 select rt.id_client,sum(rt.sub_demand) from rep_tree_demand_tbl as rt
    left join clm_client_tbl as c on (c.id = rt.id_client)
    left join clm_statecl_tbl as scl on (c.id = scl.id_client)
    where scl.id_section not in (205,206,207,208) 
    and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)
    and c.book=-1
    group by rt.id_client;




 update rep_avr_demand_tbl set month_count = sss.mc
from (
  select id_client, count(distinct date_trunc(''month'',b.mmgg)) as mc
  from acm_bill_tbl as b  
  where b.id_pref = 10
   and b.idk_doc = 200
   and b.value <> 0
   and date_trunc(''month'', b.mmgg) >=date_trunc(''month'', pdtb) 
   and date_trunc(''month'', b.mmgg) <=date_trunc(''month'', pdte)
   group by id_client
)  as sss
   where sss.id_client= rep_avr_demand_tbl.id_client ; 

 update rep_avr_demand_tbl set month_count = date_part(''month'', pdte)-date_part(''month'', pdtb)+1
 where month_count is null;

 update rep_avr_demand_tbl set avg_demand = round(demand/month_count);

 RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';          



--------------------------------------------------------------------------------------------
--  CREATE or replace FUNCTION rep_tree_demand_fun (int,int,int,date,int,int)
CREATE or replace FUNCTION rep_tree_demand_fun (int,int,int,date,date)
  RETURNS numeric
  AS                                                                                              
  '
  declare
  pborder Alias for $1;  -- граница раздела
  pid_tree Alias for $2; -- дерево после граници раздала
  pabonent Alias for $3; -- абонент после граници раздела
  pdtb Alias for $4;    --\
  pdte Alias for $5;    --\
--  pparent Alias for $5;  -- дата, предок граници и уровень для занесения в
--  plvl Alias for $6;     -- таблицу bal_eqp_tbl
--  pid_doc Alias for $7;

  new_border record;
  vid_tree  int;
  v int;
  vtree_demand numeric;
  vsub_demand numeric;
  vsumsub_demand numeric;
  vtree_data record;
--  vid_doc int;
  begin

  Raise Notice ''-border % - tree % '',pborder,pid_tree;

   --суммарное потребление по тУ - в текущем дереве за указанный период

--   select into vtree_data coalesce(sum(pd.sum_demand),0) as vtree_demand
--   count(distinct date_trunc(''month'',b.mmgg)) as m_count
   select into vtree_demand coalesce(sum(pd.fact_demand+pd.fact_losts),0) 
   from 
--   eqm_borders_tbl as bd 
--   join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>pid_tree)
   acm_bill_tbl as b  
   join acd_point_branch_tbl as pb on (pb.id_doc= b.id_doc and pb.id_tree = pid_tree )
   join acd_pwr_demand_tbl as pd on (pd.id_doc= b.id_doc and pd.id_point = pb.id_point ) 
--   left join eqm_eqp_tree_tbl as eqt2 on (eqt2.code_eqp=pb.id_p_point and eqt2.id_tree = pid_tree)
   where  b.id_client=pabonent  
   and b.id_pref = 10
   and b.idk_doc = 200
   and b.value <> 0
--   and eqt2.id_tree is null
   and date_trunc(''month'', b.mmgg) >=date_trunc(''month'', pdtb) 
   and date_trunc(''month'', b.mmgg) <=date_trunc(''month'', pdte);


--   vtree_demand:= vtree_data.vtree_demand;

  -- все граници раздела, кроме начальной, из текущего дерева
  vsumsub_demand:=0;
  for new_border in
   select tt.code_eqp
   from
   eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id )
   where tt.code_eqp<>coalesce(pborder ,0)
   and (eq.type_eqp=9)
   and tt.id_tree =pid_tree 
  loop

   Raise Notice ''- - border %'',new_border.code_eqp;


   select into vsub_demand rep_tree_demand_fun(new_border.code_eqp,eqt.id_tree,bd.id_clientB,pdtb,pdte)
   from
   eqm_borders_tbl as bd  
   join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>pid_tree)
   where (new_border.code_eqp=bd.code_eqp);

   --прибавим к собственному потреблению ветки потребление веток - субабонентов
   --vtree_demand:=vtree_demand+vsub_demand;
   vsumsub_demand:=vsumsub_demand+vsub_demand;

  end loop;

  vtree_demand:=vtree_demand+vsumsub_demand;

  if (vtree_demand <> 0) then 
   insert into rep_tree_demand_tbl(id_client,id_border,id_tree,demand,sub_demand)
   values (pabonent,pborder,pid_tree,vtree_demand,vsumsub_demand);
  end if;

  RETURN vtree_demand;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

