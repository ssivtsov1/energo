;
set client_encoding = 'koi8';



 alter table bal_acc_tbl add column fiz_count int;
 alter table bal_acc_tbl add column fiz_power numeric(14,4);

  ALTER TABLE bal_grp_tree_tbl ALTER COLUMN name TYPE  character varying(100);
  ALTER TABLE bal_grp_tree_conn_tbl ALTER COLUMN name TYPE  character varying(100);

-----------------------------------------------------
--Ограничения
--1. Не учитываются изменения в схеме РЕС (схема берется как есть на текущий момент)
--2. Нет коммутации
--3. Схема РЕС не должна разбиваться оборудованием абонентов
--4. Не должны переноситься границы раздела абонентов с дерева на дерево
--5. Не обрабатывает точки учета, удаленные на конец месяца.
--//ЕСТЬ//6. НЕ рассматривается случай, когда счетчик абонента стоит на стороне РЕС
  
--  DROP FUNCTION bal_eqp_fun(date);

                                                                                                 
  CREATE or replace FUNCTION bal_eqp_fun(int,date)
  RETURNS int AS
  '
  declare
  ptree Alias for $1;
  monthdate Alias for $2;

  begindate date;
  enddate date;

  id_res int;

  border record;
  r record;
  r2 record;
  r3 record;
  rr record;
  rrr record;
  fexit int;
  parent int;

  fider  int;
  grp record;
  vppoint_ok int;

  v int;
  vtype int; 
  vborder_eqp int;
  vadd_eqp int;
  vid_tree int;
  vloss_power int;
--  countlost bool;

  begin

   begindate:=date_trunc(''month'',monthdate);
   enddate:=begindate+''1 month''::interval;

--   select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_bal'';
   select into id_res getsysvar(''id_bal'');

   -- оборудование РЕС без счетчиков и изм. тр. 
   --  выбираем без контроля изменений и возможности перекоммутации
   --Берем только те ветки, в которых хотя бы один элемент принадлежит фидеру 
   -- или подстанции

   -- не берем оборудование, которое используется для расчета абонентов
   -- кроме точек учета,  для них id_client ставим абонентский
   -- исходим из того, что первым объектом в ветке, исп. для расчета абонента 
   -- является ТУ, остальное оборудование вплоть до точки учета нам не надо


   insert into  bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
    Select t.id as id_tree, coalesce(use.id_client,t.id_client) as id_client,t.id_client as rclient,tt.code_eqp,tt.code_eqp_e,
    eq.type_eqp,eq.loss_power,tt.lvl,begindate,enddate,begindate 
    From 
    eqm_tree_tbl AS t 
    JOIN eqm_eqp_tree_tbl AS tt on (t.id=tt.id_tree)
    JOIN eqm_equipment_tbl AS eq ON (tt.code_eqp=eq.id)
----    left join eqm_eqp_use_tbl as use on (use.code_eqp=eq.id and use.dt_install<enddate and eq.type_eqp =12)
    left join eqm_eqp_use_tbl as use on (use.code_eqp=eq.id and use.dt_install<enddate)
    WHERE (t.id_client=id_res) 
      and (eq.type_eqp<>1)  -- счетчики
      and (eq.type_eqp<>10) -- изм. тр.
      and (tt.line_no=0) --без дублей точек схождения
     -- пришлось убрать, т.к. может вызвать дыры в схеме (история не используется)--
  --  and (eq.dt_install<enddate)
-------------------------------------------------------------------------------
      and ((( exists (select tt1.id_tree from eqm_eqp_tree_tbl as tt1
           join eqm_compens_station_inst_tbl as st1 using (code_eqp)
           join eqm_equipment_tbl as eq1 on (st1.code_eqp_inst = eq1.id)
           join eqm_tree_tbl AS t1 on (t1.id=tt1.id_tree)
           WHERE (t1.id_client=id_res) 
	   and ((eq1.type_eqp=8) or (eq1.type_eqp=15) or (eq1.type_eqp=17))  -- фидер или подстанция или внутридом сеть
           and tt1.id_tree = t.id)
          ) and ptree is NULL ) or (t.id = ptree))
--      and ((use.id_client is NULL) or (eq.type_eqp=12)) --точка учета или не используется абонентом
    order by id_tree;

    -- найдем граници раздела и их абонентов
/*
    for border in 
     select eq.id_tree,eq.code_eqp,eq.id_p_eqp,eq.lvl,bd.id_clientB as client 
     from bal_eqp_tbl as eq,eqm_borders_tbl as bd
     where (eq.code_eqp=bd.code_eqp) 
     and type_eqp=9 --граница раздела
     and bd.id_clientA=id_res  loop

--     Raise Notice ''border %'',border.code_eqp;

     v:=bal_sel_sub_fun(border.code_eqp,border.id_tree,border.client,begindate,border.id_p_eqp,border.lvl);

    end loop;
*/

/*
  PERFORM bal_sel_sub_fun(eq.code_eqp,eq.id_tree,bd.id_clientB,begindate,eq.id_p_eqp,eq.lvl)
  from bal_eqp_tbl as eq,eqm_borders_tbl as bd
  where (eq.code_eqp=bd.code_eqp) 
  and type_eqp=9 --граница раздела
  and bd.id_clientA=id_res ;
*/

/*
  PERFORM bal_sel_sub_fun(eq.code_eqp,eqt.id_tree,bd.id_clientB,begindate,eq.id_p_eqp,eq.lvl,b.id_doc)
  from bal_eqp_tbl as eq join eqm_borders_tbl as bd on ((eq.code_eqp=bd.code_eqp)and (eq.type_eqp=9))
  join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=eq.code_eqp and eqt.id_tree<>eq.id_tree)
  join acm_bill_tbl as b on (b.id_client=bd.id_clientB and b.mmgg::date=begindate) 
  where bd.id_clientA=id_res ;
*/

   -- для колхозов, у которых схема частично на стороне РЕС (ТУ и линии), а частично после граници раздела
   -- надо передвинуть границу на самую ТУ
   for border in 
     select eq.id_tree,eq.code_eqp,eq.id_p_eqp,eq0.id_p_eqp as pp_eqp,eq.lvl
     from bal_eqp_tmp as eq join bal_eqp_tmp as eq0 on (eq.id_p_eqp=eq0.code_eqp)
      where 
     eq.type_eqp=9 --граница раздела
     and eq0.type_eqp <> 12
     and (eq0.id_client <> eq0.id_rclient)
   loop

     Raise Notice ''[*] change border %'',border.code_eqp;

     parent:=border.pp_eqp;

     LOOP

      select into rr * from bal_eqp_tmp where code_eqp = parent;

      if (rr.id_client = rr.id_rclient) or (rr.type_eqp=12)  then

          update bal_eqp_tmp set id_p_eqp = rr.code_eqp , lvl =  rr.lvl+1
          where bal_eqp_tmp.code_eqp = border.code_eqp;

          parent:=null;
      else
          parent:=rr.id_p_eqp;
      end if;

      EXIT WHEN ( parent is null );

     end loop;

   end loop;


  update bal_eqp_tmp set id_client = id_rclient where (type_eqp <> 12) and (id_client <> id_rclient);

  --выберем из схемы граници раздела
  --по ним определяем абонента и дерево, кторые находятся за ними,
  --по ним из таблици acd_point_branch_tbl получаем точки учета , по которым  
  --выписаны счета за текущий месяц, и добавляем их в bal_eqp_tbl

  Raise Notice ''insert into bal_eqp_tmp  ... points'';

  insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
  select distinct pb.id_tree,pb.id_client,pb.id_rclient,pb.id_point,eq.id_p_eqp,12,0,eq.lvl,begindate,enddate,begindate
  from 
  bal_eqp_tmp as eq join eqm_borders_tbl as bd on (eq.code_eqp=bd.code_eqp)
  join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=eq.code_eqp and eqt.id_tree<>eq.id_tree)
  join acm_bill_tbl as b on (b.id_client=bd.id_clientB and b.mmgg::date=begindate) 
--  join acd_point_branch_tbl as pb on (pb.id_doc= b.id_doc and pb.id_tree = eqt.id_tree and pb.id_p_point is null)
  join acd_point_branch_tbl as pb on (pb.id_doc= b.id_doc and pb.id_tree = eqt.id_tree)
  where bd.id_clientA=id_res
  and eq.mmgg= begindate
  and (b.id_pref = 10 or b.id_pref = 11 or b.id_pref = 101)
  and b.idk_doc = 200
  and date_trunc(''month'', pb.mmgg) =date_trunc(''month'', pb.dat_e) ;

  -- то же самое, но выбираем абонентов, у кого нет счетов
  Raise Notice ''insert into bal_client_errors_tbl ... '';

  insert into bal_client_errors_tbl ( id_client,id_tree, id_border, id_parent_eqp,mmgg)
  select distinct bd.id_clientB,eq.id_tree,eq.code_eqp,eq.id_p_eqp,begindate
  from 
  bal_eqp_tmp as eq 
  join eqm_borders_tbl as bd on (eq.code_eqp=bd.code_eqp)
--  join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=eq.code_eqp and eqt.id_tree<>eq.id_tree)
  left join acm_bill_tbl as b on (b.id_client=bd.id_clientB and b.mmgg::date=begindate and (b.id_pref = 10 or b.id_pref = 11 or b.id_pref = 101 ) and b.idk_doc = 200) 
  where bd.id_clientA=id_res
  and eq.mmgg= begindate
  and b.id_doc is null;

  -- ТОЛЬКО для юридических лиц.
  -- поиск субабонентов, учеты которых не являются дублями 
  -- и связаны со схемой РЕС через каждую границу
  Raise Notice ''bal_sel_sub_fun start'';

  PERFORM bal_sel_sub_fun(eq.code_eqp,eqt.id_tree,bd.id_clientB,begindate,eq.id_p_eqp,eq.lvl)
  from bal_eqp_tmp as eq join eqm_borders_tbl as bd on (eq.code_eqp=bd.code_eqp)
  join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=eq.code_eqp and eqt.id_tree<>eq.id_tree)
  join clm_client_tbl as cl on (cl.id= bd.id_clientB)
  where bd.id_clientA=id_res 
  and eq.mmgg= begindate
  and (eq.type_eqp=9)
  and cl.book = -1;

  Raise Notice ''duble point select start'';
  -- Выбот ТУ дублей, подключаем парплельно основным ТУ
  vppoint_ok:=0;



 -- отметим ТУ, которые входят в фидера
 update bal_eqp_tmp set id_type_eqp = -1
 from eqm_compens_station_inst_tbl as st 
   join eqm_equipment_tbl as eq on (eq.id = st.code_eqp_inst and eq.type_eqp =15 )
   join eqm_area_tbl as a on (a.code_eqp = eq.id) 
 where a.id_client = id_res and st.code_eqp = bal_eqp_tmp.code_eqp 
 and bal_eqp_tmp.type_eqp = 12 ;


  LOOP
  --при переподключении от одного абонента к другому в течение периода и выписке двух разных счетов имеем проблему

    insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg,tt)   
    select distinct pb.id_tree, pb.id_client, pb.id_rclient, pb.id_point, 
    CASE WHEN coalesce(be.id_type_eqp,0) = -1 THEN be.code_eqp ELSE be.id_p_eqp END as id_p_eqp ,
    12,0,be.lvl,begindate,enddate,begindate , coalesce(be.tt,be.code_eqp) as tt
    from 
    (
     select pb.id_tree, pb.id_client, pb.id_rclient, pb.id_point, max(be.code_eqp) as code_eqp 
     from bal_eqp_tmp as be
     join 
     (
       select pb.id_tree, pb.id_point, pb.id_client, pb.id_rclient , b.id_client as bill_client, max(pb.id_p_point) as id_p_point  from 
       acm_bill_tbl as b join acd_point_branch_tbl as pb on (pb.id_doc = b.id_doc )
       where (b.id_pref = 10 or b.id_pref = 11 or b.id_pref = 101) and b.idk_doc = 200 and b.mmgg = begindate and pb.id_p_point is not null
       group by pb.id_tree, pb.id_point,pb.id_client, pb.id_rclient,b.id_client order by bill_client, id_p_point
     ) as pb
     on (pb.bill_client=be.id_client and pb.id_p_point = be.code_eqp)
    left join bal_eqp_tmp as be2 on (be2.code_eqp =pb.id_point )
    where  be.type_eqp = 12 and be.code_eqp >0
    and be2.code_eqp is null
    group by pb.id_tree, pb.id_client, pb.id_rclient, pb.id_point
   ) as pb
   join (select code_eqp, id_type_eqp, max(id_p_eqp) as id_p_eqp, max(lvl) as lvl, max(tt) as tt 
        from bal_eqp_tmp group by code_eqp, id_type_eqp ) as be on (be.code_eqp = pb.code_eqp);

--   join bal_eqp_tmp as be on (be.code_eqp = pb.code_eqp);


    if not found then 
      vppoint_ok:=1;
    end if;

    Raise Notice ''duble point select .... '';

    EXIT WHEN ( vppoint_ok=1 );

  end loop;

  -- сделаем фиктивные ТУ для населения
  insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
  select distinct eq.id_tree,-1,-1,-dem.id_eqpborder,dem.id_eqpborder,12,0,eq.lvl+1,begindate,enddate,begindate
  from 
  bal_eqp_tmp as eq join acm_privdem_tbl as dem on (eq.code_eqp = dem.id_eqpborder)
  where dem.mmgg = begindate and eq.mmgg = begindate;
  -------------------------------------------------------------------------------------
  -- население, подключенное к схемам абонентов
 for r in 

   Select distinct pm.id_eqpborder as id_eqmborder  from clm_pclient_tbl as pm 
   join eqm_equipment_tbl as eq on (eq.id = pm.id_eqpborder)
   join eqm_eqp_tree_tbl as tt on (tt.code_eqp = eq.id)
   join eqm_tree_tbl as t on (tt.id_tree = t.id)
   left join bal_eqp_tmp as b on (-b.code_eqp = pm.id_eqpborder)
   where t.id_client <> syi_resid_fun() and b.code_eqp is null

 loop

   vtype:=12;
   vadd_eqp = -r.id_eqmborder;
   vloss_power = 0;

   Raise Notice ''fizborder %'',r.id_eqmborder;

   parent :=r.id_eqmborder;

   fexit :=0; 
--   fider:=0;

-- if (r.id_eqmborder is not NULL) then

     LOOP
    
       select into r2 eq.id, tt.code_eqp_e,eq.type_eqp,b.id_clienta, hnet.code_eqp_inst as code_net, eq.loss_power, bt.code_eqp as code_bal
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join eqm_borders_tbl as b on (eq.id = b.code_eqp)
       left join 
	(select csi.code_eqp, csi.code_eqp_inst from eqm_compens_station_inst_tbl as csi
          join eqm_equipment_tbl as net on (net.id = csi.code_eqp_inst and net.type_eqp = 17)
        ) as hnet on (hnet.code_eqp = eq.id)
       left join bal_eqp_tmp as bt on (eq.id = bt.code_eqp and bt.type_eqp <> 12)
       where  eq.id = parent;


       --if (r2.type_eqp = 12)  then 
       --fexit:=1;
       -- vtype:=12;
       --end if;

       --  если по дороге от точки учета до граници схемы РЕС встретилось оборудование внутридом. сетей (в абонентской схемме),
       --  надо и его занести в дерево, иначе не пройдет расчет внутр.сетей

       if (r2.type_eqp <> 9) and (r2.code_net is not null) and (r2.code_bal is null) then 

          Raise Notice ''fizborder connected to additional equipment %'',r2.code_eqp_e;

          insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
          values(-r.id_eqmborder,-1,-1,vadd_eqp,r2.id,vtype,vloss_power,null,begindate,enddate,begindate);

	  vtype:=r2.type_eqp;
	  vadd_eqp = r2.id;
          vloss_power = r2.loss_power;


       end if;

       if ((r2.type_eqp = 9) and (r2.id_clienta =syi_resid_fun() )) then 

          Raise Notice ''fizborder connected to %'',r2.code_eqp_e;

          insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
          select distinct eq.id_tree,-1,-1,vadd_eqp,eq.code_eqp,vtype,vloss_power,eq.lvl+1,begindate,enddate,begindate
          from 
          bal_eqp_tmp as eq 
          where eq.code_eqp =r2.code_eqp_e and eq.mmgg = begindate;

          select into vid_tree id_tree from bal_eqp_tmp as eq where eq.code_eqp =r2.code_eqp_e;

          update bal_eqp_tmp set id_tree = vid_tree where id_tree = -r.id_eqmborder;

          fexit:=1;

       end if;

       -- оборудование, которое было занесено в схему предыдущими циклами,
       -- просто подключим текущую точку к нему и выйдем из цикла
       if ((r2.code_bal is not null) and (r2.type_eqp <> 9)) then 

          Raise Notice ''fizborder connected to existent %'',r2.id;

          insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
          select distinct eq.id_tree,-1,-1,vadd_eqp,eq.code_eqp,vtype,vloss_power,eq.lvl+1,begindate,enddate,begindate
          from 
          bal_eqp_tmp as eq 
          where eq.code_eqp =r2.id and eq.mmgg = begindate;

          select into vid_tree id_tree from bal_eqp_tmp as eq where eq.code_eqp =r2.id;

          update bal_eqp_tmp set id_tree = vid_tree where id_tree = -r.id_eqmborder;

          fexit:=1;

       end if;

    
       EXIT WHEN ( (fexit<>0) or (r2.code_eqp_e is null) );
    
    
       parent:= r2.code_eqp_e;

     end loop;

 end loop;


 update bal_eqp_tmp set id_p_eqp = b2.id_p_eqp, lvl = b2.lvl
 from bal_eqp_tmp as b2 
-- left join (select st.code_eqp from eqm_compens_station_inst_tbl as st 
--   join eqm_equipment_tbl as eq on (eq.id = st.code_eqp_inst and eq.type_eqp =15 )
--   join eqm_area_tbl as a on (a.code_eqp = eq.id) where a.id_client = id_res  ) as ss on (ss.code_eqp = b2.code_eqp )
 where b2.code_eqp = bal_eqp_tmp.id_p_eqp
 --and bal_eqp_tmp.code_eqp <0 
 and b2.type_eqp = 12 and bal_eqp_tmp.type_eqp = 12 
 and b2.id_client <> id_res and bal_eqp_tmp.id_client <> id_res
 and coalesce(b2.id_type_eqp,0) <> -1;
-- and ss.code_eqp is null;


  -------------------------------------------------------------------------------------
   -- если есть фрагмент схемы РЕС (внутридомовая сеть), который подключен к схеме абонента (абонентская ТП),
   -- пытаемся связать с остальной схемой рес

   for r3 in select eq2.*
     from bal_eqp_tmp as eq 
     join bal_eqp_tmp as eq2 on (eq2.id_p_eqp = eq.code_eqp)
     join eqm_tree_tbl as t on (t.id = eq.id_tree and t.code_eqp=eq.code_eqp)
     where eq.type_eqp=9 and t.id_client = syi_resid_fun()
   loop 

     parent :=r3.id_p_eqp;

       Raise Notice ''- lost tree reconnect %'',parent;
     
     LOOP
    
       select into rrr tt.code_eqp_e, tt.code_eqp, tt.id_tree, t.id_client, eq.type_eqp, tt.lvl
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join eqm_tree_tbl as t on (t.id = tt.id_tree)
       where  eq.id = parent;

       Raise Notice ''- lost tree reconnect eqp %'',parent;
    
       if rrr.id_client = syi_resid_fun() then

	update bal_eqp_tmp set lvl = lvl+ rrr.lvl - 1, id_tree = rrr.id_tree where id_tree = r3.id_tree;
        update bal_eqp_tmp set id_p_eqp = rrr.code_eqp_e where code_eqp = r3.code_eqp;
    
        Raise Notice ''- lost tree reconnect found '';

       end if;
    
       EXIT WHEN ( (rrr.id_client = syi_resid_fun()) or (rrr.code_eqp_e is null) );
    
       parent:= rrr.code_eqp_e;

     end loop;

   end loop;


  -------------------------------------------------------------------------------------
  -- дополнительный поиск по точкам учета, который по каким то причинам не были выбраны через счета
  for r3 in 
	select ba.* from bal_abons_tbl as ba 
	join clm_client_tbl as cl on (cl.id = ba.id_client)
	left join bal_eqp_tmp as eq on (eq.code_eqp = ba.id_point )
	where ba.id_point is not null and ba.id_grp is not null and eq.code_eqp is null
        and cl.idk_work not in (0,99) and coalesce(cl.id_state,0) not in (50,99)
        order by id_point
  loop

     vborder_eqp:=bal_points_find_one_fun(r3.id_point,enddate);

     if vborder_eqp is not null then

       insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
       select distinct eq.id_tree,r3.id_client,r3.id_client,r3.id_point,eq.id_p_eqp,12,0,eq.lvl,begindate,enddate,begindate
       from 
        bal_eqp_tmp as eq 
       where eq.code_eqp = vborder_eqp;

     end if;

  end loop;
  -------------------------------------------------------------------------------------

  update bal_eqp_tmp set id_p_eqp = null where id_p_eqp in (select code_eqp from bal_eqp_tmp where type_eqp=9);  --!!

  delete from bal_eqp_tmp where type_eqp=9; --снесем граници раздела
  

  Raise Notice ''bal_client_errors_tbl upd start'';

  update bal_client_errors_tbl set id_grp = st.code_eqp_inst 
  from eqm_compens_station_inst_tbl as st,eqm_equipment_tbl as eq
  where eq.id = st.code_eqp_inst and eq.type_eqp in (15,8) and mmgg = begindate
  and st.code_eqp = bal_client_errors_tbl.id_parent_eqp;


  for r3 in 
   select * from bal_client_errors_tbl where id_grp is null and mmgg = begindate
  loop

     parent :=r3.id_parent_eqp;

     fider:=0;


     LOOP

       select into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp
       from eqm_equipment_tbl as eq 
       left join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL)
       left join eqm_compens_station_inst_tbl as st on (eq.id = st.code_eqp)
       left join eqm_equipment_tbl as eq2 on (eq2.id = st.code_eqp_inst and eq2.type_eqp in (15,8))
       where  eq.id = parent;

       if grp.type_grp is not null then
    
        update bal_client_errors_tbl set id_grp  = grp.id_grp
        where id = r3.id;

        fider:=grp.id_grp;
    
       end if;


       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       parent:= grp.code_eqp_e;

     end loop;


  end loop;

  Raise Notice ''bal_client_errors_tbl upd end'';

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
--------------------------------===============---------------------------

--  DROP FUNCTION bal_sel_sub_fun (int,int,int,date,int,int);                                                   
                                                                                                  
  CREATE or replace FUNCTION bal_sel_sub_fun (int,int,int,date,int,int)
  RETURNS int
  AS                                                                                              
  '
  declare
  pborder Alias for $1;  -- граница раздела
  pid_tree Alias for $2; -- дерево выше граници раздела
  pabonent Alias for $3; -- абонент после граници раздела
  pdate Alias for $4;    --
  pparent Alias for $5;  -- дата, предок граници и уровень для занесения в
  plvl Alias for $6;     -- таблицу bal_eqp_tbl
--  pid_doc Alias for $7;

  new_border record;
  vid_tree  int;
  vparent_tree int;
  v int;
--  vid_doc int;
  begin

  Raise Notice ''-border % - tree % '',pborder,pid_tree;
  select into vparent_tree id_tree from eqm_eqp_tree_tbl where code_eqp = pparent;
---------  Raise Notice ''abon %'',pabonent;
  -- данная граница в дереве, отличном от дерева реса

--  select into vid_tree id_tree from eqm_eqp_tree_tbl 
--  where code_eqp=pborder and id_tree<>pid_tree;

--  select into vid_doc id_doc from acm_bill_tbl 
--   where id_client=pabonent and mmgg::date=pdate;

  
--  if not found then
--   if pid_doc is not NULL then

--------   Raise Notice ''Not found '';
--   insert into bal_client_errors_tbl ( id_client,id_tree, id_border, id_parent_eqp)
--   values(pabonent,vid_tree,pborder,pparent);

   -- запишем в таблицу ошибок и перейдем к следующей границе раздела
   --   continue;
--  else

-------     Raise Notice ''doc %'',vid_doc;
/*   
     insert into bal_eqp_tbl (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
     select pid_tree,id_client,id_rclient,id_point,pparent,12,0,plvl,dat_b,dat_e,pdate
     from acd_point_branch_tbl  
     where id_doc = pid_doc 
     and id_tree = pid_tree     -- точки учета абонента из дерева, начинающегося после граници раздела
     and id_p_point is null; -- не имеет счетчика -предка
*/
--  end if;

  -- все граници раздела, кроме начальной, из текущего дерева
  -- у большинства абонентов нет субабонентов
  -- поетому цикл сделан максимально облегченным
  for new_border in
   select tt.code_eqp
   from
   eqm_eqp_tree_tbl as tt join eqm_equipment_tbl as eq on (tt.code_eqp=eq.id )
   where tt.code_eqp<>pborder 
   and (eq.type_eqp=9)
   and tt.id_tree =pid_tree 
  loop

   Raise Notice ''- - border %'',new_border.code_eqp;

   insert into bal_eqp_tmp (id_tree,id_client,id_rclient,code_eqp,id_p_eqp,type_eqp,loss_power,lvl,dat_b,dat_e,mmgg)
   select distinct pb.id_tree,pb.id_client,pb.id_rclient,pb.id_point,pparent,12,0,plvl,pdate,pdate+''1 month''::interval,pdate
   from 
--   eqm_borders_tbl as bd 
   (select * from eqm_borders_tbl where code_eqp = new_border.code_eqp order by code_eqp) as bd 
   join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>pid_tree)
   join acm_bill_tbl as b on (b.id_client=bd.id_clientB and b.mmgg::date=pdate) 
   join acd_point_branch_tbl as pb on (pb.id_doc= b.id_doc and pb.id_tree = eqt.id_tree and pb.id_p_point is null)
---   join acd_point_branch_tbl as pb on (pb.id_doc= b.id_doc and pb.id_tree = eqt.id_tree)
--   where (new_border.code_eqp=bd.code_eqp)
   where (b.id_pref = 10 or b.id_pref = 11 or b.id_pref = 101)
   and b.idk_doc = 200
   and date_trunc(''month'', pb.mmgg) =date_trunc(''month'', pb.dat_e) ;
--   and date_trunc(''month'', pb.dat_e) = pdate;


--     !!!!!!!!!!!!!!!!!!!!!!!!!!
   insert into bal_client_errors_tbl ( id_client,id_tree, id_border, id_parent_eqp,mmgg)
   select distinct bd.id_clientB,vparent_tree,pborder,pparent,pdate
   from 
   eqm_borders_tbl as bd 
   join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>pid_tree)
   left join acm_bill_tbl as b on (b.id_client=bd.id_clientB and b.mmgg::date=pdate 
   and (b.id_pref = 10 or b.id_pref = 11 or b.id_pref = 101) and b.idk_doc = 200) 
   where b.id_doc is null 
   and (new_border.code_eqp=bd.code_eqp);



   PERFORM bal_sel_sub_fun(new_border.code_eqp,eqt.id_tree,bd.id_clientB,pdate,pparent,plvl)
   from
   eqm_borders_tbl as bd  
   join eqm_eqp_tree_tbl as eqt on (eqt.code_eqp=bd.code_eqp and eqt.id_tree<>pid_tree)
   left join (select distinct id_tree from bal_eqp_tmp ) as be on (be.id_tree = eqt.id_tree)
   where new_border.code_eqp=bd.code_eqp and be.id_tree is null;


  end loop;
  RETURN 0;
  end;'
  LANGUAGE 'plpgsql';


------------------------------------------------------------------------------------------
create or replace function bal_points_find_one_fun(int,date) Returns int As'
Declare

pid_point Alias for $1;
pdt Alias for $2;

r record;
rr record;
rs boolean;
id_res int;
parent int;

v boolean; 
vid_border int;

begin


 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
  
   Raise Notice ''Start bal_points_find_one_fun %'',pid_point;

   parent :=pid_point;

   vid_border := null;
   -----------------------------------------------------------------------

     LOOP
    
       select distinct into rr tt.code_eqp, tt.code_eqp_e, eq.type_eqp, t.id as id_tree, t.id_client 
       from eqm_equipment_h as eq 
       join (select id, max(dt_b) as dt from eqm_equipment_h  where  id = parent and dt_b <=  pdt and coalesce(dt_e, pdt) >= pdt group by id order by id ) as eq3 on (eq.id = eq3.id and eq3.dt = eq.dt_b) 
--       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL and tt.dt_b <= pdt and coalesce(tt.dt_e,pdt) >= pdt)
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL )
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where code_eqp = parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt and code_eqp_e is not NULL group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 

       join eqm_tree_h AS t on (t.id=tt.id_tree )
       join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <=  pdt and coalesce(dt_e,  pdt) >= pdt group by id order by id) as t2 on (t.id = t2.id and t2.dt = t.dt_b) 


--       left join eqm_compens_station_inst_h as st on (eq.id = st.code_eqp and st.dt_b <= pdt and coalesce(st.dt_e,pdt) >= pdt)
       where  eq.id = parent 
--       and eq.dt_b <= pdt and coalesce(eq.dt_e,pdt) >= pdt
       ;

       Raise Notice ''-eqp %'',parent;
    
       if rr.id_client = id_res then
    
        vid_border := rr.code_eqp; 
    
       end if;
    
       EXIT WHEN ( (rr.id_client =id_res) or (rr.code_eqp_e is null) );
    
       parent:= rr.code_eqp_e;

     end loop;


 Return vid_border;
end;
' Language 'plpgsql';

