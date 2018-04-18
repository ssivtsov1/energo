create or replace function bal_demand_start_fun(int,date) Returns int As'
Declare
ptree Alias for $1;
pmmgg Alias for $2;
vi int;
v boolean;
vreq_check int;
vid_res int;
begin

 select into vid_res getsysvar(''id_bal'');

 delete from bal_demand_tbl where mmgg=pmmgg and id_bal = vid_res;
 delete from bal_meter_demand_tbl where mmgg=pmmgg and id_bal = vid_res;

 delete from bal_demand_tmp;
 delete from bal_meter_demand_tmp;

 vi:=bal_demand_fun(ptree,pmmgg);

 insert into bal_demand_tbl select * from bal_demand_tmp;
 insert into bal_meter_demand_tbl select * from bal_meter_demand_tmp;

 return 1;

end;
' Language 'plpgsql';


------------------------------------



  CREATE or replace FUNCTION bal_demand_fun (int,date)
  RETURNS int
  AS                                                                                              
  '
  declare
  ptree Alias for $1;
  monthdate Alias for $2;
  begindate date;
  enddate date;
  id_res int;
  v int;
  r record;

  begin

  -- select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_bal'';
   select into id_res getsysvar(''id_bal'');

   -- начало и конец периода определяем по отчетам о потреблении за текущий и прошлый месяци


   select into enddate max(date_end) 
   from acm_headindication_tbl where id_client=id_res and mmgg = monthdate 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'')) ;

   if not found then 
     return 0;
   end if;

   select into begindate max(date_end)
   from acm_headindication_tbl where id_client=id_res and mmgg = monthdate- ''1 month''::interval 
   and idk_document in (select id from dci_document_tbl where ident in (''rep_pwr'',''beg_ind''));

   if not found then 
     return 0;
   end if;

   -- процедура заполняет временные таблици, исп. для выписки счетов информацией по учетам РЕС
   -- с учетом истории
   perform bal_katacc_fun(ptree,begindate,enddate);


--   begindate:=monthdate;
--   enddate:=begindate+''1 month''::interval;


   insert into bal_meter_demand_tmp (id_point,id_meter,num_eqp,id_type_eqp,k_tr,dat_b,dat_e,mmgg,met_demand,ktr_demand)
   select id_point,id_meter,num_eqp,id_type_eqp,k_tr,min(dat_b),max(dat_e),monthdate,0,0 
   from act_met_kndzn_tbl
   where kind_energy = 1 
   group by id_point,id_meter,num_eqp,id_type_eqp,k_tr;


-- каждый набор id_meter,num_eqp,coef_comp в течение периода в отчетах о потреблении
-- встречается 2 раза - в начальных и конечных показаниях 
   raise notice ''update bal_meter_demand_tmp start'';


   for r in 
     select a.id_meter, a.num_eqp, a.coef_comp , b.value as b_value, a.value as a_value, c.carry from 
       (select i.* from acd_indication_tbl as i
        join acm_headindication_tbl as h on (h.id_doc = i.id_doc)
        where -- id_cor_doc is null  and 
            id_previndic is not null 
        and kind_energy=1
        and id_zone = 0
        and h.id_client=id_res
        and h.date_end<=enddate and h.date_end>begindate 
        and h.idk_document in (select id from dci_document_tbl where ident 
                 in (''rep_pwr'',''chn_cnt'',''rep_pwr_f''))
        order by id_previndic
        ) as a
       JOIN (select * from acd_indication_tbl as i join acm_headindication_tbl as h on (h.id_doc = i.id_doc) 
             where h.date_end<enddate and h.date_end>=begindate and h.id_client=id_res order by id) as b 
       on (a.id_previndic=b.id)
       join (select id, carry from eqi_meter_tbl order by id ) as c on (a.id_typemet = c.id)
          
   loop
 
     update bal_meter_demand_tmp set b_val=numeric_smaller(coalesce(b_val,999999),r.b_value) ,e_val= numeric_larger(r.a_value,coalesce(e_val,0)),
     met_demand=met_demand+calc_ind_pr(r.a_value,r.b_value,r.carry),ktr_demand=ktr_demand+calc_ind_pr(r.a_value,r.b_value,r.carry)*k_tr
     where id_meter=r.id_meter and num_eqp=r.num_eqp and 
     k_tr  = r.coef_comp ;

   end loop;

/*
   update bal_meter_demand_tmp set b_val=numeric_smaller(coalesce(b_val,999999),b.value) ,e_val= numeric_larger(a.value,coalesce(e_val,0)),
   met_demand=met_demand+calc_ind_pr(a.value,b.value,c.carry),ktr_demand=ktr_demand+calc_ind_pr(a.value,b.value,c.carry)*k_tr
   from 
       (select id, carry from eqi_meter_tbl order by id ) as c,
       (select i.* from acd_indication_tbl as i
        join acm_headindication_tbl as h on (h.id_doc = i.id_doc)
        where id_cor_doc is null 
        and id_previndic is not null 
        and kind_energy=1
        and id_zone = 0
        and h.id_client=id_res
        and h.date_end<=enddate and h.date_end>begindate 
--        and h.mmgg = monthdate
        and h.idk_document in (select id from dci_document_tbl where ident 
                 in (''rep_pwr'',''chn_cnt'',''rep_pwr_f''))
--        and id_doc in 
--             (select id_doc  from acm_headindication_tbl where id_client=id_res 
--              and date_end<=enddate and date_end>begindate
--              and mmgg = monthdate
--              and idk_document in (select id from dci_document_tbl where ident 
--                 in (''rep_pwr'',''chn_cnt'')))
        order by id_previndic
        ) as a
       JOIN (select * from acd_indication_tbl as i join acm_headindication_tbl as h on (h.id_doc = i.id_doc) 
             where h.date_end<enddate and h.date_end>=begindate and h.id_client=id_res order by id) as b 
       on (a.id_previndic=b.id)
   where bal_meter_demand_tmp.id_meter=a.id_meter and bal_meter_demand_tmp.num_eqp=a.num_eqp and 
   bal_meter_demand_tmp.k_tr  = a.coef_comp and bal_meter_demand_tmp.id_type_eqp=c.id;
*/
   raise notice ''update bal_meter_demand_tmp end'';

   insert into bal_demand_tmp(id_point,ktr_demand,mmgg) 
   select id_point,coalesce(sum(ktr_demand),0),monthdate 
   from bal_meter_demand_tmp where mmgg = monthdate group by id_point;



  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
