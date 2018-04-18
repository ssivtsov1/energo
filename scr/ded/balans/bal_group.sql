;
set client_encoding = 'koi8';


--drop function bal_gorup_tree_start_fun(date);
create or replace function bal_gorup_tree_start_fun(date) Returns boolean As'
Declare
pmmgg Alias for $1;
r record;
rs boolean;
id_res int;
id_rres int;
--dtb date;
--dte date;

begin

-- dtb:=pmmgg;
-- dte:=dtb+''1 month''::interval;

-- select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_bal'';
 select into id_res getsysvar(''id_bal'');
 select into id_rres to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

 for r in select * from bal_eqp_tmp where id_p_eqp is null and mmgg = pmmgg loop
   Raise Notice ''Start %'',r.code_eqp;
   rs:=bal_gorup_tree_fun(r.code_eqp,r.id_client,id_res,id_rres,r.type_eqp,r.id_tree,null,0,null,pmmgg);
 end loop;

-- if getsysvar(''kod_res'') in ( ''310'',''320'',''220'',''140'') then
   rs:= bal_group_abontp_fun(pmmgg);
-- end if;

 Return true;
end;
' Language 'plpgsql';
-------------------------------=====================----------------------------

drop function bal_gorup_tree_fun(int,int,int,int,int,int,int,date); 
drop function bal_gorup_tree_fun(int,int,int,int,int,int,int,int,date);

create or replace function bal_gorup_tree_fun(int,int,int,int,int,int,int,int,int,date) 
Returns boolean As'
Declare

 pid_eqp Alias for $1;
 pid_client Alias for $2;
 pid_res Alias for $3;
 pid_rres Alias for $4;
 ptype_eqp Alias for $5;
 pid_tree Alias for $6;
 pid_p_grp Alias for $7;
 pid_grp_lvl Alias for $8;
 pid_fider Alias for $9;
 pmmgg Alias for $10;


 point int;
 child record;
 grp record;
 entry record;
 v boolean; 
 dtb date;
 dte date;
 is_entry boolean;
 vfider record;
 vid_voltage int;
 vlost_04 int;

 vacc  record;
 v_dp  numeric;
 v_k04 numeric;
 v_dn  numeric;
 v_tgf numeric;
 v_kz  numeric;
 v_Lekv numeric;
 v_Days int;
 vlost04_metod int;

begin

   select into dte coalesce(max(date_end),pmmgg + ''1 month''::interval - ''1 days''::interval ) 
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'')) ;

   Raise Notice '' dte %'',dte;

/*
   select into dte date_end 
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'')) limit 1;
*/

   select into dtb coalesce(max(date_end),pmmgg)
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg- ''1 month''::interval 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'',''beg_ind''));

   Raise Notice '' dtb %'',dtb;
/*
--   select into dtb date_end + ''1 days''::interval  
   select into dtb date_end   
   from acm_headindication_tbl where id_client=pid_res and mmgg = pmmgg- ''1 month''::interval 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'',''beg_ind'')) limit 1;
*/
-- dtb:=pmmgg;
-- dte:=dtb+''1 month''::interval;

-- Raise Notice '' eqp  %'',pid_eqp;

/*
 if pid_client<>pid_res then  -- не оборудование РЕС = ТУ абононта
-- if ptype_eqp=12 then 

   Raise Notice '' point %'',pid_eqp;

   insert into bal_grp_tree_tmp (id_tree,code_eqp,id_p_eqp,type_eqp, 
    dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,id_fider)
   select pid_tree,pid_eqp,pid_p_grp,ptype_eqp,
     dtb,dte,pid_grp_lvl+1,pid_client,pid_eqp,pmmgg,coalesce(eq.name_eqp,''физ.лица''),acc.demand,acc.demand04,acc.lst,acc.lst,pid_fider
   from bal_acc_tmp as acc left join eqm_equipment_tbl as eq on (acc.code_eqp=eq.id)
   where acc.code_eqp=pid_eqp  and acc.mmgg=pmmgg;

   return true;

--   if found or (pid_client<>pid_res) then
--     return true;
--  end if;

 end if;
*/

 -- ищем, принадлежит ли оборудование подстанции или площадке
 select into grp st.code_eqp_inst,eq.type_eqp,eq.name_eqp
 from eqm_compens_station_inst_tbl as st join eqm_equipment_tbl as eq on (eq.id = st.code_eqp_inst)
 join eqm_area_tbl as a on (a.code_eqp = eq.id)
 where eq.type_eqp in (15,8) and a.id_client = pid_res
 and st.code_eqp = pid_eqp;


 if not found then
  --оборудование не принадлежит фидерам и подстанциям

   -- Специально для Черниговского РЕС !! ---
   --если ТУ находится в голове фидера,и используется в расчетах абонента, ее надо рассматривать как учет фидера и как абонентский одновременно
   -- тут берем только те ТУ, которые не вошли в фидер или ПС
   if (pid_client<>pid_res) and (ptype_eqp=12) then  --  ТУ абононта

     Raise Notice '' point %'',pid_eqp;

     insert into bal_grp_tree_tmp (id_tree,code_eqp,id_p_eqp,type_eqp, 
      dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,id_fider)
     select pid_tree,pid_eqp,pid_p_grp,ptype_eqp,
       dtb,dte,pid_grp_lvl+1,pid_client,pid_eqp,pmmgg,coalesce(eq.name_eqp,''физ.лица''),acc.demand,acc.demand04,acc.lst,acc.lst,pid_fider
     from bal_acc_tmp as acc left join eqm_equipment_tbl as eq on (acc.code_eqp=eq.id)
     where acc.code_eqp=pid_eqp  and acc.mmgg=pmmgg;

     return true;

   end if;
 

  if (ptype_eqp=12) and (pid_res<>pid_rres) then 

    insert into bal_grp_tree_tmp (id_tree,code_eqp,id_p_eqp,type_eqp, 
     dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,id_fider)
    select pid_tree,pid_eqp,pid_p_grp,ptype_eqp,
      dtb,dte,pid_grp_lvl+1,pid_client,pid_eqp,pmmgg,coalesce(eq.name_eqp,''физ.лица''),acc.demand,acc.demand04,acc.lst,acc.lst,pid_fider
    from bal_acc_tmp as acc left join eqm_equipment_tbl as eq on (acc.code_eqp=eq.id)
    where acc.code_eqp=pid_eqp  and acc.mmgg=pmmgg;

    return true;

  end if;

  for child in 
   select bt.code_eqp,bt.id_client,bt.type_eqp,bt.id_tree from bal_eqp_tmp as bt
   where bt.id_p_eqp = pid_eqp
   and bt.mmgg = pmmgg loop

   Raise Notice ''start1 %'',child.code_eqp;

   v:=bal_gorup_tree_fun(child.code_eqp,child.id_client,pid_res,pid_rres,child.type_eqp,child.id_tree,pid_p_grp,pid_grp_lvl,pid_fider,pmmgg);

  end loop;

 else

  Raise Notice ''Grp %'',grp.code_eqp_inst;

  --для тех случаев, когда трудно привести схему в порядок,
  --т.е. устранить проходные подстанции и подстанции с двумя и больше входами
  --правильность работы при этом ложится на инженера  
  if (select count (*) from bal_grp_tree_tmp where code_eqp = grp.code_eqp_inst and mmgg=pmmgg)<>0 then 
  -- такой объект уже встречался, прекращаем данную ветку рекурсии
     Raise Notice ''Repeat  %'',grp.name_eqp;
     return true;
  end if;

  if grp.type_eqp=15 then --фидер (вход в фидер)
     Raise Notice ''Fider'';
  -- фидер имеет одно начало, и в начале должен быть точка учета
  -- если нет ТУ в нчале, считаем фидер не имеющим счетчика 

   if ptype_eqp=12 then 
      point:=pid_eqp;
   else                  
      point:=null;
   end if;
   Raise Notice ''FIder point %'',point;

   select into vfider id_voltage,losts_coef,l04_count,l04_length,l04f1_length,l04f3_length,Fgcp from eqm_fider_tbl
   where code_eqp=grp.code_eqp_inst;

   select into vacc * from bal_acc_tmp as acc  where acc.code_eqp=pid_eqp and acc.mmgg=pmmgg;

   -- с 01.10.2009 вводится новый алгоритм расчета потерь в линиях 0.4 кВ
   if (vfider.l04_count=0 or vfider.l04_length =0 or vfider.Fgcp = 0 ) then
     -- нет данных для нового алгоритма, считаем по старому.
     if vfider.losts_coef <> 0 then
        vlost_04 := ((vacc.demand04::int8)*(vacc.demand04::int8)*coalesce(vfider.losts_coef,0)/1000)::int;
        vlost04_metod:=1;
     else
        vlost_04 :=0;
        vlost04_metod:=0;
     end if;

   else

     if coalesce(vacc.demand04,0)<>0 then
 
      v_dp := vacc.fiz_demand::numeric/vacc.demand04::numeric;
      v_k04 := (7.78-2.67*v_dp-1.48*v_dp*v_dp)*(1.25+0.14*v_dp);
      v_dn  := vacc.nolost_demand::numeric/vacc.demand04::numeric;
      v_tgf:= 0.6;
      v_kz := 0.5;
      v_Lekv := vfider.l04_length+0.44*vfider.l04f3_length+0.22*vfider.l04f1_length;
      v_Days := extract (''epoch'' from vacc.dat_e::timestamp - vacc.dat_b::timestamp)/3600;

      vlost_04 := round(v_k04*((vacc.demand04::numeric/1000)/vfider.l04_count)^2*
                  (((1-v_dn)^2)*(1+v_tgf^2)*v_Lekv/(vfider.Fgcp*v_Days))*(1+2*v_kz)/(3*v_kz));

      vlost04_metod:=2;

--      insert into bal_losts04_tmp ( code_eqp, l04_count, l04_length, l04f1_length, l04f3_length, fgcp, fiz_demand, nolost_demand, losts04, mmgg)
--      values (grp.code_eqp_inst,vfider.l04_count, vfider.l04_length, vfider.l04f1_length, vfider.l04f3_length, vfider.fgcp,vacc.fiz_demand,vacc.nolost_demand,vlost_04,pmmgg);

     else
        vlost_04 :=0;
        vlost04_metod:=0;
     end if;

   end if;

   insert into bal_losts04_tmp ( code_eqp, l04_count, l04_length, l04f1_length, l04f3_length, fgcp, fiz_demand, nolost_demand, losts04, mmgg)
   values (grp.code_eqp_inst,vfider.l04_count, vfider.l04_length, vfider.l04f1_length, vfider.l04f3_length, vfider.fgcp,vacc.fiz_demand,vacc.nolost_demand,vlost_04,pmmgg);

   if(vacc.demand_full is not null) then
    -- в голове фидера абонентская ТУ - потери равны 0 
    insert into bal_grp_tree_tmp(id_tree,code_eqp,id_p_eqp,type_eqp,
      dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,losts_coef,id_voltage,lost04_metod)
    values (pid_tree,grp.code_eqp_inst,pid_p_grp,grp.type_eqp,
      dtb,dte,pid_grp_lvl+1,pid_res,point,pmmgg,grp.name_eqp,coalesce(vacc.demand_bill,vacc.demand),vacc.demand04,
      0,0,coalesce(vfider.losts_coef,0),vfider.id_voltage,vlost04_metod);

   else

    insert into bal_grp_tree_tmp(id_tree,code_eqp,id_p_eqp,type_eqp,
      dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,losts_coef,id_voltage,lost04_metod)
    values (pid_tree,grp.code_eqp_inst,pid_p_grp,grp.type_eqp,
      dtb,dte,pid_grp_lvl+1,pid_res,point,pmmgg,grp.name_eqp,vacc.demand,vacc.demand04,
      (vacc.lst+vacc.losts)+vlost_04::int,
      (vacc.lst+vacc.losts),coalesce(vfider.losts_coef,0),vfider.id_voltage,vlost04_metod);

   end if;

     --------------------------------------------------------------------------------------------------------------
     -- Специально для Черниговского РЕС !! ---
     -- если ТУ находится в голове фидера,и используется в расчетах абонента, ее надо рассматривать как учет фидера и как абонентский одновременно
     -- в голове данного фидера находится ТУ абонента, ее надо добавить в ТУ, подключенные к данному фидеру

     if (ptype_eqp=12) and ( pid_client<>pid_res ) then  -- не оборудование РЕС = ТУ абононта

       Raise Notice '' special point %'',pid_eqp;

       insert into bal_grp_tree_tmp (id_tree,code_eqp,id_p_eqp,type_eqp, 
        dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,id_fider)
       select pid_tree,pid_eqp,grp.code_eqp_inst,ptype_eqp,
        dtb,dte,pid_grp_lvl+2,pid_client,pid_eqp,pmmgg,eq.name_eqp,acc.demand,acc.demand04,acc.lst,acc.lst,grp.code_eqp_inst
       from bal_acc_tmp as acc left join eqm_equipment_tbl as eq on (acc.code_eqp=eq.id)
       where acc.code_eqp=pid_eqp  and acc.mmgg=pmmgg;

     --  return true;

     end if;
     ------------------------------------------------------------------------------------------------------------

/*
   insert into bal_grp_tree_tmp(id_tree,code_eqp,id_p_eqp,type_eqp,
     dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,losts_coef,id_voltage)
   select pid_tree,grp.code_eqp_inst,pid_p_grp,grp.type_eqp,
     dtb,dte,pid_grp_lvl+1,pid_client,point,pmmgg,grp.name_eqp,acc.demand,acc.demand04,
     (acc.lst+acc.losts)+((acc.demand04::int8)*(acc.demand04::int8)*coalesce(vfider.losts_coef,0)/1000)::int,
     (acc.lst+acc.losts),coalesce(vfider.losts_coef,0),vfider.id_voltage
   from bal_acc_tmp as acc 
   where acc.code_eqp=pid_eqp and acc.mmgg=pmmgg;
*/

   -- все ветви, исходящие из фидера
   for child in 
    select bt.code_eqp,bt.id_client,bt.type_eqp,bt.id_tree 
    from bal_eqp_tmp as bt,eqm_compens_station_inst_tbl as st
    where bt.id_p_eqp=st.code_eqp and st.code_eqp_inst=grp.code_eqp_inst 
    and bt.code_eqp not in (select code_eqp from eqm_compens_station_inst_tbl where code_eqp_inst=grp.code_eqp_inst)
    and bt.mmgg = pmmgg loop

    Raise Notice ''start2 %'',child.code_eqp;

    v:=bal_gorup_tree_fun(child.code_eqp,child.id_client,pid_res,pid_rres,child.type_eqp,child.id_tree,grp.code_eqp_inst,pid_grp_lvl+1,grp.code_eqp_inst,pmmgg); 
   end loop;
   return true;
  end if;
  

  if grp.type_eqp=8 then --подстанция

  Raise Notice ''station '';  

   select into vid_voltage id_voltage from eqm_compens_station_tbl
   where code_eqp=grp.code_eqp_inst;

  -- запишем сначала саму подстанцию
/*
   insert into bal_grp_tree_tbl(id_tree,code_eqp,id_p_eqp,type_eqp,
     dat_b,dat_e,lvl,id_client,mmgg,name,demand,demand04,losts,fact_losts,id_voltage)
   select pid_tree,grp.code_eqp_inst,pid_p_grp,grp.type_eqp,
     dtb,dte,pid_grp_lvl+1,pid_client,pmmgg,grp.name_eqp,acc.demand,acc.demand04,(acc.lst+acc.losts),(acc.lst+acc.losts),vid_voltage
   from bal_acc_tbl as acc 
   where acc.code_eqp=pid_eqp and acc.mmgg=pmmgg;
*/                              
   --если ПС имеет >1 начала, потребление и потери суммируем по всем началам
   --если в ПС есть ошибочный разрыв, это может привести к неправильным результатам 
   --Все начала должны быть в одном дереве 

   -- Для проходной подстанции просто брать данные по всем входам нельзя
   -- Нужно вычесть данные по выходам из ПС по фидерам 10кВ
   Raise Notice '' - - - ++'';  
   insert into bal_grp_tree_tmp(id_tree,code_eqp,id_p_eqp,type_eqp,
     dat_b,dat_e,lvl,id_client,mmgg,name,demand,demand04,losts,fact_losts,id_voltage,id_fider)
   select pid_tree,grp.code_eqp_inst,pid_p_grp,grp.type_eqp, 
     dtb,dte,pid_grp_lvl+1,pid_client,pmmgg,grp.name_eqp,
     i.demandi-coalesce(o.demando,0),
     i.demand04i-coalesce(o.demand04o,0),
     i.lsti-coalesce(o.lsto,0),
     i.lsti-coalesce(o.lsto,0),
     vid_voltage,pid_fider
    from
    (select st.code_eqp_inst, sum(acc.demand) as demandi ,sum(acc.demand04) as demand04i ,sum(acc.lst+acc.losts) as lsti
     from bal_eqp_tmp as bt join bal_acc_tmp as acc using (code_eqp,mmgg)
     join eqm_compens_station_inst_tbl as st on (bt.code_eqp = st.code_eqp)  
     left join eqm_compens_station_inst_tbl as stp on (bt.id_p_eqp = stp.code_eqp)  
     left join eqm_equipment_tbl as eg on (eg.id = stp.code_eqp_inst)  
     where st.code_eqp_inst=grp.code_eqp_inst and bt.mmgg=pmmgg
     and ((coalesce(stp.code_eqp_inst,0)<>grp.code_eqp_inst)or(bt.id_p_eqp is null))
     and ((eg.type_eqp <> 11) or (eg.type_eqp is null))
     group by st.code_eqp_inst
    ) as i
    left join
    (select st1.code_eqp_inst, sum(acco.demand) as demando,sum(acco.demand04) as demand04o,sum(acco.lst+acco.losts) as lsto
     from bal_eqp_tmp as bto join bal_acc_tmp as acco using (code_eqp,mmgg)
     join eqm_compens_station_inst_tbl as sto on (bto.code_eqp = sto.code_eqp)  
     join eqm_fider_tbl as fo on (fo.code_eqp = sto.code_eqp_inst)
     join eqm_compens_station_inst_tbl as st1 on (bto.id_p_eqp = st1.code_eqp)  
     where fo.id_voltage = vid_voltage and bto.mmgg=pmmgg
     and st1.code_eqp_inst=grp.code_eqp_inst 
     group by st1.code_eqp_inst
    ) as o on (o.code_eqp_inst = i.code_eqp_inst);  
   Raise Notice '' - - - - - - ++'';  

   is_entry:=false;

   if (vid_voltage < 3) then -- подстанции 10/04 не имеют вводов и счетчиков
   -- поищем вводы  и их счетчики
    for entry in 
     select bt.code_eqp,bt.id_p_eqp,pbt.type_eqp as parent_type,bt.type_eqp,eq.name_eqp
     from bal_eqp_tmp as bt,eqm_compens_station_inst_tbl as st,
     eqm_switch_tbl as sm, eqi_switch_tbl as si,
     bal_eqp_tmp as pbt,eqm_equipment_tbl as eq
     where bt.code_eqp=st.code_eqp and st.code_eqp_inst=grp.code_eqp_inst 
     and bt.type_eqp=3 and sm.code_eqp=bt.code_eqp and eq.id=bt.code_eqp
     and si.id=sm.id_type_eqp
     and pbt.code_eqp=bt.id_p_eqp --and pbt.type_eqp=12
     and si.id_gr = 10 and bt.mmgg = pmmgg and pbt.mmgg = pmmgg loop --id_gr надо создать

     is_entry:=true; -- есть вводы

     Raise Notice ''entry %'',entry.code_eqp;

     if entry.parent_type=12 then point:=entry.id_p_eqp;
     else                    point:=null;
     end if;
 
    -- запишем ввод
     insert into bal_grp_tree_tmp(id_tree,code_eqp,id_p_eqp,type_eqp,
       dat_b,dat_e,lvl,id_client,id_point,mmgg,name,demand,demand04,losts,fact_losts,id_voltage,id_fider)
      select pid_tree,entry.code_eqp,grp.code_eqp_inst,entry.type_eqp,
       dtb,dte,pid_grp_lvl+2,pid_client,point,pmmgg,entry.name_eqp,acc.demand,acc.demand04,acc.lst,acc.lst,vid_voltage,pid_fider
      from bal_acc_tmp as acc
      where acc.code_eqp=entry.code_eqp and acc.mmgg=pmmgg;
 
    -- потомки вводов
     for child in 
      select bt.code_eqp,bt.id_client,bt.type_eqp,bt.id_tree from bal_eqp_tmp as bt
      where bt.id_p_eqp =entry.code_eqp
      and bt.mmgg = pmmgg loop

      Raise Notice ''start3 %'',child.code_eqp;

      v:=bal_gorup_tree_fun(child.code_eqp,child.id_client,pid_res,pid_rres,child.type_eqp,child.id_tree,entry.code_eqp,pid_grp_lvl+2,pid_fider,pmmgg);
     end loop;

    end loop;

   end if;

   --если не было вводов, все потомки к подстанции напрямую
   if not is_entry then

    Raise Notice ''No entry '';

    for child in 
     select bt.code_eqp,bt.id_client,bt.type_eqp,bt.id_tree
     from bal_eqp_tmp as bt,eqm_compens_station_inst_tbl as st
     where bt.id_p_eqp=st.code_eqp and st.code_eqp_inst=grp.code_eqp_inst 
     and bt.code_eqp not in (select code_eqp from eqm_compens_station_inst_tbl where code_eqp_inst=grp.code_eqp_inst)
     and bt.mmgg = pmmgg loop

     Raise Notice ''start4 %'',child.code_eqp;

     v:=bal_gorup_tree_fun(child.code_eqp,child.id_client,pid_res,pid_rres,child.type_eqp,child.id_tree,grp.code_eqp_inst,pid_grp_lvl+1,pid_fider,pmmgg);

    end loop;
   end if;
  end if;
  
 end if;

 return true;
end;
' Language 'plpgsql';

--------------------------------------------------------------------------------------------------
create or replace function bal_group_abontp_fun(date) Returns boolean As'
Declare
 pmmgg Alias for $1;
 r record;
 grp record;
 rs boolean;
 id_res int;
 id_rres int;
 parent int;
 station int;
 v int;
 dtb date;
 dte date;

begin


 select into id_res getsysvar(''id_bal'');
 select into id_rres to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';

 select into dte coalesce(max(date_end),pmmgg + ''1 month''::interval - ''1 days''::interval ) 
 from acm_headindication_tbl where id_client=id_res and mmgg = pmmgg 
 and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'')) ;

 select into dtb coalesce(max(date_end),pmmgg)
 from acm_headindication_tbl where id_client=id_res and mmgg = pmmgg- ''1 month''::interval 
 and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'',''beg_ind''));



 for r in select p.*, f.id_tree as tree from 
  bal_grp_tree_tmp as p join bal_grp_tree_tmp as f on (p.id_p_eqp = f.code_eqp)
  where p.type_eqp = 12 and ((f.type_eqp  <> 8 ) or (coalesce(f.id_voltage,0) <> 3))
 loop


   Raise Notice ''||||Point reconnect Start % ||||'',r.code_eqp;

   parent :=r.code_eqp;

   if parent < 0 then 
     parent = -parent;
   end if;

   station:=0;

     LOOP
    
       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp, st.type_grp, st.id_grp ,st.id_client, st.name_grp
--       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp ,eq2.id_client, eq2.name_eqp as name_grp
       from eqm_equipment_h as eq 
       join (select id, max(dt_b) as dt from eqm_equipment_h  where  id = parent and dt_b <=  r.dat_b and coalesce(dt_e, r.dat_b) >= r.dat_b group by id order by id ) as eq3 on (eq.id = eq3.id and eq3.dt = eq.dt_b) 
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL )
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where code_eqp = parent and dt_b <= r.dat_b and coalesce(dt_e, r.dat_b) >= r.dat_b and code_eqp_e is not NULL group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
       left join 
       (select inst.* , eq2.type_eqp as type_grp, eq2.id as id_grp ,eq2.id_client, eq2.name_eqp as name_grp
          from eqm_compens_station_inst_h as inst 
          join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where code_eqp = parent and coalesce(dt_e,r.dat_b) >= r.dat_b group by code_eqp_inst,code_eqp order by code_eqp_inst) as inst2 
          on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b) 
          join 
          (select eq3.*, aa.id_client from eqm_equipment_tbl as eq3 join eqm_area_tbl as aa on (aa.code_eqp = eq3.id)
            where type_eqp in (15,8) 
            order by eq3.id 
          ) as eq2 on (eq2.id = inst.code_eqp_inst )
       ) as st on (eq.id = st.code_eqp )
       where  eq.id = parent  ;

       Raise Notice ''-eqp %'',parent;
    
       if grp.type_grp is not null then
    
        if (grp.type_grp = 8) and (grp.id_client <> id_res ) then
         station:=grp.id_grp;
        else
         station:=-1;
        end if;
    
       end if;
    
       EXIT WHEN ( (station<>0) or (grp.code_eqp_e is null) );
    
       parent:= grp.code_eqp_e;

     end loop;

   if station > 0 then

    select into v code_eqp from bal_grp_tree_tmp where code_eqp = station;

    if not found then 

     insert into bal_grp_tree_tmp(id_tree,code_eqp,id_p_eqp,type_eqp, dat_b,dat_e,lvl,id_client,mmgg,name,demand,demand04,
      losts,fact_losts,id_voltage,id_fider)
     values(r.tree,station,r.id_p_eqp,8, dtb,dte,r.lvl, grp.id_client,pmmgg,grp.name_grp, 0,0,0,0,3,r.id_p_eqp);

     Raise Notice ''||||Create abon station % ++++ '',station;

    end if;

    update bal_grp_tree_tmp set id_p_eqp = station, lvl = lvl+1 where code_eqp = r.code_eqp; 

    update bal_grp_tree_tmp set demand = demand+r.demand, demand04 = demand04+r.demand04 where code_eqp = station; 

    Raise Notice ''||||Point % reconnected! ****'',r.code_eqp;

   end if;

  end loop;


 Return true;
end;
' Language 'plpgsql';
-------------------------------=====================----------------------------


