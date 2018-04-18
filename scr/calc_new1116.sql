

-- DROP FUNCTION calc_bill(integer, date, integer, integer);
                       

CREATE OR REPLACE FUNCTION calc_bill(integer, date, integer, integer)
  RETURNS boolean AS
$BODY$
Declare
pid_acc alias for $1; 
pmg   alias for $2;
pflag alias for $3;  -- null - usual demand  -- 2 plan next_month  -- 9 correctirovka 
bill_doc alias for $4; -- need for plan and correct 
tarif_begin date;
pdt_dod date;
pdt_b_heat date;
pdt_e_heat date;
pid_tar int;
flag_calc_lgt int;
flag_calc_lgt_manual int;
tax_in numeric;
day_in_month  int;
allbill int;
allrest int;
allresttar int;
allrestdem int;
allintarif int;
devtarif int;
addsum record;
addsum2 record;
billtarif int;
billrest int;
tarifin int;
alllgtin int;
allin int;
alllgt int;
dictlgt numeric (14,2);
heatarea numeric (14,2);
islgt  numeric (14,2);
tarifdem numeric(14,2);
tarifrest numeric(14,2);
allzone numeric(14,2);
alltarif numeric(14,2);
koefzone numeric (15,4);
tarifzone  numeric(14,2);
restzone  numeric(14,2);
koef_lgt_heat  numeric(10,5);
restsumdem int;
rest_zone_one int;
pid_doc int;
rec record;
rec_tarif record;
rec_dem_tarif record;
rec_demand record;
rec_zones record;
rec_zones_one record;
rec_lgt record;
rec_lgt_tar record;
rec_sum record;
rec_sumz record;
rest_lgt int;
rest_zone int;
check_indic record;
bill_rec record;
rec_subs record;
--subs_rec record;
ret boolean;
reti int;
ptax numeric;
month_pmg int;
mg date;
test record;
delbill record;
  pidk_doc int;
  ppref int;
  bill_corr int;
  flag_exit int;
    flag_exit1 int;
 max_prev int;
    cou int ;
begin
   mg=fun_mmgg();
   raise notice 'clear()';
   ret=clear_ttbl(1);
   --select * from clm_paccnt_tbl
 select into heatarea heat_area from clm_paccnt_tbl where  id=pid_acc;
   ptax=GetSysVarn('nds');
   if pmg<(GetSysVarc('dt_start'))::date then
     raise notice 'Calc bill before start program';
     return false;
   end if; 
   tax_in=(1.00+ptax)/(ptax);
   day_in_month=date_part('day',eom(pmg));
   if pflag<>2 then --delete old bil
     if pflag=9 then  -- delete if not plan
       cou=0;
      for delbill in select * from acm_bill_tbl where id_paccnt=pid_acc and mmgg=pmg and (id_pref=10 ) and (idk_doc=200)loop
           delete from acm_bill_tbl where delbill.id_doc=acm_bill_tbl.id_corr_doc and (idk_doc=220) and flock=0;
           cou=1;
      end loop; 
      if cou=0 then -- no bill in period
   /*
      select b.* from acm_bill_tbl b left join acm_demand_tbl d on b.id_doc=d.id_doc 
        where d.id_doc is not null and b.id_paccnt=250344   and (idk_doc=220) and b.flock=0  and coalesce(reg_num,' ')<>' ' and mmgg_bill='2016-06-01' order by id_doc
        */
       for delbill in select b.id_doc from acm_bill_tbl b left join acm_demand_tbl d on b.id_doc=d.id_doc 
        where d.id_doc is not  null  and (idk_doc=220) and b.id_paccnt=pid_acc and b.flock=0    and coalesce(reg_num,' ')<>' ' and mmgg_bill=pmg order by id_doc loop
        raise notice 'dellbill ---- id_doc % ',delbill.id_doc;
        delete from acm_bill_tbl where delbill.id_doc=acm_bill_tbl.id_doc;
       end loop;
      end if;
      select id_doc into bill_corr from  acm_bill_tbl where id_paccnt=pid_acc and mmgg=pmg and (id_pref=10 or id_pref=12) and (idk_doc=200);
      delete from acm_bill_tbl where id_paccnt=pid_acc and mmgg=pmg and (id_pref=10 ) and (idk_doc=200);
     end if;
     if pflag=0 then
       delete from acm_bill_tbl where id_paccnt=pid_acc and mmgg=pmg and (id_pref=10 or id_pref=12) and (idk_doc=200);
     end if;
     -- check indication big demand
      select * into check_indic  
        from (select c.book,c.code,i.* 
                  from acm_indication_tbl i ,
                 ( select * from clm_meterpoint_tbl 
                   where num_meter in (select num_eqp from acm_indication_tbl where id_paccnt=pid_acc and mmgg=pmg and value_diff>=99999)
                  )  m ,
                  clm_paccnt_tbl c 
             where  i.num_eqp=m.num_meter and m.id_paccnt=c.id order by c.book,c.code,num_eqp,dat_ind) a;
       if found then
         insert into sys_loaderror_tbl (text)    values ( 'big demand '|| check_indic.book||','|| check_indic.code||','||check_indic.value||
          ','||check_indic.value_diff||','||check_indic.num_eqp||','||check_indic.carry||','||check_indic.id|| ');');
         return true;
      end if;
      if pflag=0 then
        select into pdt_dod dt_dod from clm_paccnt_tbl where  id=pid_acc;
         raise notice '=====================calc plandemand  dt_dod % ',pdt_dod;
          if pdt_dod>'2001-01-01' then
           raise notice 'calc plandemand %  % % ',pid_acc,pmg+interval '1 month',pid_doc;
           perform calc_bill(pid_acc,(pmg+interval '1 month')::date,2,pid_doc); 
           ret=clear_ttbl(1);
           end if;
       end if;

     select into test *  from acm_inpdemand_tbl where id_paccnt=pid_acc and mmgg=pmg;
     if not found then
      -- full table demand
      insert into act_demand_tbl 
              (id_paccnt, id_meter ,  id_energy ,  id_zone ,  dat_b ,  dat_e ,  demand ,   losts , dem_nolost,  ident )
        select i.id_paccnt, i.id_meter ,  i.id_energy ,  i.id_zone ,  p.dat_ind ,  i.dat_ind ,  i.value_cons ,0 ,i.value_cons,  pflag
         from acm_indication_tbl i left join acm_indication_tbl p on p.id=i.id_prev 
        where  i.id_zone is not null  and i.mmgg=pmg and i.id_paccnt=pid_acc and i.id_prev is not null; 
     else   -- green tarif
           insert into act_demand_tbl 
              (id_paccnt, id_meter ,  id_energy ,  id_zone ,  dat_b ,  dat_e ,  demand ,   losts , dem_nolost,  ident )
        select i.id_paccnt, i.id_meter ,  i.id_energy ,  i.id_zone ,  i.dat_b ,  i.dat_e ,  i.demand ,0 ,i.demand,  pflag
         from acm_inpdemand_tbl  i   where i.mmgg=pmg and i.id_paccnt=pid_acc; 
     end if;
    else  -- pflag=2 
      raise notice 'delete pflag2 ';
  delete from acm_bill_tbl where id_paccnt=pid_acc and mmgg=pmg-interval '1 month' and (id_pref=12) and (idk_doc=200);
  insert into act_demand_tbl 
     (id_paccnt, id_meter ,  id_energy ,  id_zone ,  dat_b ,  dat_e ,  demand ,   losts , dem_nolost, ident )
     select i.id_paccnt, p.id ,  i.kind_energy ,  i.id_zone ,  bom(pmg) ,  eom(pmg) ,  i.demand ,0 , i.demand , pflag
     from clm_plandemand_tbl i  join clm_meterpoint_tbl p on p.id_paccnt=pid_acc 
     where i.id_zone is not null  and i.mmgg=pmg and i.id_paccnt=pid_acc; 
     

 end if;
   -- full tablr lgot and calc lgot
    select into allbill coalesce(sum(coalesce(demand)),0) from act_demand_tbl   where  ident=pflag;
   for test in select * from eqm_equipment_tbl where id_paccnt=pid_acc limit 1 loop  -- calc_lost
         perform calc_lost(pid_acc,pmg,pflag);
         
         for rec_demand in select * from act_demand_tbl where ident=pflag loop
         if allbill<>0 then
          update act_demand_tbl set losts=round((sum_lost::numeric/allbill::numeric)*demand::numeric ,0)::int 
              from (select sum(coalesce(dw)) as sum_lost from act_lost_tbl where id_paccnt=pid_acc and ident=pflag) a 
              where act_demand_tbl.demand=rec_demand.demand and act_demand_tbl.demand<>0; 
         end if;     
       end loop; 
      end loop;
    update act_demand_tbl set demand=coalesce(dem_nolost,0)+coalesce(losts,0) where ident=pflag;
 raise notice '1';

 update act_demand_tbl set koef_dem=case when z.sumzone<>0 then (demand::numeric)/z.sumzone::numeric else 1.00 end 
 from (select id_paccnt,id_meter,id_energy,dat_b,dat_e,ident,sum(demand) as sumzone from act_demand_tbl group by id_paccnt,id_meter,id_energy,dat_b,dat_e,ident ) z 
 where act_demand_tbl.id_paccnt=z.id_paccnt and act_demand_tbl.id_meter=z.id_meter and act_demand_tbl.id_energy=z.id_energy 
 and act_demand_tbl.dat_b=z.dat_b and act_demand_tbl.dat_e=z.dat_e and act_demand_tbl.ident=z.ident and id_zone<>0;
 update act_demand_tbl set koef_dem=1.00000 where id_zone=0;
/*
 update act_demand_tbl set koef_dem=case when z.sumzone<>0 then (demand::numeric)/z.sumzone::numeric else 1.00 end 
 from (select id_paccnt,id_meter,id_energy,ident,sum(demand) as sumzone from act_demand_tbl group by id_paccnt,id_meter,id_energy,ident ) z 
 where act_demand_tbl.id_paccnt=z.id_paccnt and act_demand_tbl.id_meter=z.id_meter and act_demand_tbl.id_energy=z.id_energy and act_demand_tbl.ident=z.ident and id_zone<>0;
 update act_demand_tbl set koef_dem=1.00000 where id_zone=0; -- 1 for zone 0
*/
  -- 1 for zone 0
 raise notice '2';
 flag_calc_lgt=1;  
 select into allbill coalesce(sum(coalesce(demand)),0) from act_demand_tbl   where  ident=pflag; -- all demand from demand
 -----------------------------------------------------------------------


 if pmg>='2016-05-01' then -- not lgot if subsid is after '2016-05-01'
   flag_calc_lgt_manual:=null;
   
   --select into flag_calc_lgt_manual id_action from clm_lgt_manual_tbl   where  mmgg_bill=pmg and id_paccnt=pid_acc ;
  select into flag_calc_lgt_manual m.id_action from clm_lgt_manual_tbl as m join 
   (select id_paccnt, mmgg_bill, max(mmgg) as max_mmgg from clm_lgt_manual_tbl group by id_paccnt, mmgg_bill ) as mm
   on (mm.id_paccnt = m.id_paccnt and mm.mmgg_bill = m.mmgg_bill and mm.max_mmgg = m.mmgg )
     where  m.mmgg_bill=pmg and m.id_paccnt=pid_acc ;
   
   if found then 
     flag_calc_lgt_manual = coalesce(flag_calc_lgt_manual,0);
     if flag_calc_lgt_manual = 1 then 
	flag_calc_lgt=1; 
     end if; 
     if flag_calc_lgt_manual = 2 then 
	flag_calc_lgt=0; 
     end if; 
   else 
      select into flag_calc_lgt  id from acm_subs_tbl   where  mmgg=pmg and id_paccnt=pid_acc and subs_all>0 ;
      if  found  then
         flag_calc_lgt=0; 
      else 
         flag_calc_lgt=1; 
      end if;
   end if;
 end if;
 raise notice 'flag_calc_lgt  %',flag_calc_lgt;

------------------------------------------------------------------------------------------------
 if flag_calc_lgt=1 then
   insert into act_lgt_tbl 
     ( id_lgm,   id_paccnt,  famyly_cnt,
       dt_start,dt_end,   dt_b,dt_e,  dt_beg,dt_fin,
       id_grp_lgt,lg_dtb,lg_dte,  id_calc,calc_dtb,calc_dte,
       id_ln,id_tar_grp,percent,ln_dtb,ln_dte,
       norm_min,norm_one,norm_max,norm_heat_demand,norm_heat_one,norm_heat_family,
       norm_abon,  norm_abon_heat,ident
      ) 
    select l.id,  l.id_paccnt,  family_cnt,
       l.dt_start,l.dt_end,  l.dt_b,l.dt_e,  date_larger(l.dt_beg,bom( pmg)),date_smaller(coalesce(l.dt_fin,eom( pmg)),eom( pmg)),
       id_grp_lgt,lg_dtb,lg_dte,  id_calc,calc_dtb,calc_dte,
       id_ln,id_tar_grp,percent,ln_dtb,ln_dte,
       norm_min,norm_one,norm_max,norm_heat_demand,norm_heat_one,norm_heat_family,
       norm_abon,  norm_abon_heat,pflag
    from 
       (select lh.id,lh.id_paccnt,lh.family_cnt, lg.name as lg_name,c.name as calc_name, 
           lh.dt_start ,lh.dt_end,la.dt_start as la_dtb,la.dt_end as ladte,lh.dt_b , lh.dt_e,     date_larger(lh.dt_start,lh.dt_b) as dt_beg,
           date_smaller( date_smaller( coalesce(lh.dt_end,lh.dt_e ) , coalesce(lh.dt_e,lh.dt_end) ), coalesce(la.dt_end,eom(pmg) )) as dt_fin,
           lh.id_grp_lgt,lg.dt_b as lg_dtb,lg.dt_e as lg_dte,
           lh.id_calc,c.dt_b as calc_dtb,c.dt_e as calc_dte,
           ln.id as id_ln,id_tar_grp,percent,ln.dt_b as ln_dtb,ln.dt_e as ln_dte,
           norm_min,norm_one,norm_max,norm_heat_demand,norm_heat_one,norm_heat_family,
           int4smaller(norm_min+norm_one*(case when lh.family_cnt <3 then lh.family_cnt-1 else lh.family_cnt-1 end) ,norm_max) as norm_abon,    0  as norm_abon_heat
         from  lgm_abon_h lh,lgm_abon_tbl la,lgi_calc_header_tbl c,lgi_group_tbl lg,lgi_norm_tbl ln   
         where  lh.id_paccnt=pid_acc  and  la.id_paccnt=pid_acc and la.id=lh.id and
              c.id=lh.id_calc and lh.id_grp_lgt=lg.id and ln.id_calc=c.id and coalesce(lh.dt_e, pmg)>= pmg -- and id_tar_grp=1
       ) l, 
       clm_paccnt_tbl cl, aqi_grptar_tbl gt
    where cl.id_gtar= gt.id and l.id_paccnt=cl.id and l.id_tar_grp=gt.id_lgt_group 
           and date_larger(dt_start,bom( pmg)) between bom( pmg) and eom( pmg) 
           and   date_smaller(coalesce(dt_end,eom( pmg)),eom( pmg))  between bom( pmg) and eom( pmg); 
   pdt_dod=NULL;
   delete from  act_lgt_tbl where dt_beg=dt_fin   and act_lgt_tbl.ident=pflag;
   
    update act_lgt_tbl set id= t.numb from 
(select row_number() OVER () as numb, *   from act_lgt_tbl ) t 
where    act_lgt_tbl.id_paccnt=t.id_paccnt and act_lgt_tbl.famyly_cnt=t.famyly_cnt and act_lgt_tbl.dt_start=t.dt_start 
        and coalesce(act_lgt_tbl.dt_end,'2099-01-01')=coalesce(t.dt_end,'2099-01-01') and act_lgt_tbl.dt_b=t.dt_b 
        and coalesce(act_lgt_tbl.dt_e,'2099-01-01')=coalesce(t.dt_e,'2099-01-01') 
        and act_lgt_tbl.dt_beg=t.dt_beg and act_lgt_tbl.dt_fin=t.dt_fin and act_lgt_tbl.id_grp_lgt=t.id_grp_lgt 
         and act_lgt_tbl.lg_dtb=t.lg_dtb and coalesce(act_lgt_tbl.lg_dte,'2099-01-01')=coalesce(t.lg_dte,'2099-01-01') and act_lgt_tbl.id_calc=t.id_calc 
         and act_lgt_tbl.calc_dtb=t.calc_dtb and coalesce(act_lgt_tbl.calc_dte,'2099-01-01')=coalesce(t.calc_dte,'2099-01-01') 
         and act_lgt_tbl.id_ln=t.id_ln and act_lgt_tbl.id_tar_grp=t.id_tar_grp and act_lgt_tbl.percent=t.percent and act_lgt_tbl.ln_dtb=t.ln_dtb 
         and coalesce(act_lgt_tbl.ln_dte,'2099-01-01')=coalesce(t.ln_dte,'2099-01-01') 
         and act_lgt_tbl.norm_min=t.norm_min and act_lgt_tbl.norm_one=t.norm_one and act_lgt_tbl.norm_max=t.norm_max and act_lgt_tbl.norm_heat_demand=t.norm_heat_demand 
         and act_lgt_tbl.norm_heat_one=t.norm_heat_one and act_lgt_tbl.norm_heat_family=t.norm_heat_family and act_lgt_tbl.norm_abon=t.norm_abon 
         and act_lgt_tbl.norm_abon_heat=t.norm_abon_heat and act_lgt_tbl.norm_lgt=t.norm_lgt 
         and act_lgt_tbl.id_lgm=t.id_lgm  and act_lgt_tbl.ident=t.ident;
   for test in select * from act_lgt_tbl order by dt_beg loop
    if    pdt_dod is not NULL then
    update act_lgt_tbl set dt_beg=pdt_dod+interval '1 day' where act_lgt_tbl.id=test.id;
    end if;
    
    pdt_dod=test.dt_fin;
   end loop; 
   update act_lgt_tbl set id=null;
  -- if heatarea<>0 then
    if (( date_part('month',pmg)<=4 or date_part('month',pmg)>9) and heatarea<>0) then    -- heat perood  
     if date_part('month',pmg)=10 then    -- heat perood start 
        update act_lgt_tbl set dt_beg=heat_period.dt_b from heat_period where id_tar_grp=3 and bom(pmg)=bom(heat_period.dt_b);
        koef_lgt_heat=(date_mi_nol((select max(dat_e) from act_demand_tbl where ident=pflag)::date,(select dt_b from heat_period where bom(pmg)=bom(dt_b))::date)-1.00::numeric) /
            ( case when               date_mi_nol( (select max(dat_e) from act_demand_tbl where ident=pflag)::date, (select min(dat_b) from act_demand_tbl where ident=pflag)::date)-1.00::numeric<>0 then
              date_mi_nol( (select max(dat_e) from act_demand_tbl where ident=pflag)::date, (select min(dat_b) from act_demand_tbl where ident=pflag)::date)-1.00::numeric
             else
             1
             end  
            );
         raise notice 'koef_lgt_heat 1 %',koef_lgt_heat;
      end if;
      if date_part('month',pmg)=4 then    -- heat perood start 
      update act_lgt_tbl set dt_end=heat_period.dt_e from heat_period where id_tar_grp=3 and  bom(pmg)=bom(heat_period.dt_e);
      
      koef_lgt_heat=(date_mi_nol((select min(dat_b) from act_demand_tbl where ident=pflag)::date,(select dt_e from heat_period where bom(pmg)=bom(dt_e))::date)-1.00::numeric) /
       (  case when date_mi_nol( (select max(dat_e) from act_demand_tbl where ident=pflag)::date,(select min(dat_b) from act_demand_tbl where ident=pflag)::date)-1.00::numeric<>0 then
          date_mi_nol( (select max(dat_e) from act_demand_tbl where ident=pflag)::date,(select min(dat_b) from act_demand_tbl where ident=pflag)::date)-1.00::numeric
          else 
            1 
          end);
        --   select * from heat_period;
      end if;
   
      if koef_lgt_heat is null   then 
        koef_lgt_heat=1;
       end if;
    
     update act_lgt_tbl set norm_abon_heat=round((norm_heat_demand* numeric_smaller(norm_heat_one*(famyly_cnt) 
       +norm_heat_family,c.heat_area ))*coalesce(floorkoef,0.44),2) 
      from  clm_paccnt_tbl c 
     left join adi_multifloor_tbl as m  on  (c.addr).house=m.build    
     left  join lgi_multfloor_koef_tbl mk on mk.floor=m.floors
     left join adt_addr_tbl as adr on (adr.id = m.id_street) and (c.addr).id_class=adr.id 
     where  id_tar_grp=3 and act_lgt_tbl.id_paccnt=c.id   and pflag=act_lgt_tbl.ident; 

     if date_part('month',pmg)<>4 and date_part('month',pmg)<>10 then
       update act_lgt_tbl set norm_lgt=round((int8smaller(coalesce(norm_abon_heat,0),allbill)+0.00 )*
         (1+date_mi_nol(date_smaller(dt_fin,eom(pmg)),date_larger(dt_beg,bom(pmg))))/day_in_month ,0) where  id_tar_grp=3 and act_lgt_tbl.ident=pflag;
           raise notice 'koef_lgt_heat 3333333333333333 %',koef_lgt_heat;
     else
      raise notice 'koef_lgt_heat 6666666666666 %',koef_lgt_heat;
       update act_lgt_tbl set norm_lgt=round((int8smaller(( ((coalesce(norm_abon_heat,0)+0.00)*koef_lgt_heat) +(coalesce(norm_abon,0)+0.00)*(1.00-koef_lgt_heat))::int ,allbill) ),0)
         where  id_tar_grp=3 and act_lgt_tbl.ident=pflag;

     end if;
     update act_lgt_tbl set norm_lgt=round((int8smaller(coalesce(norm_abon,0),allbill)+0.00 )*
     (1+date_mi_nol(date_smaller(dt_fin,eom(pmg)),date_larger(dt_beg,bom(pmg))))/day_in_month ,0)  where  id_tar_grp<>3  and act_lgt_tbl.ident=pflag; 

     
  else
    update act_lgt_tbl set norm_lgt=round( (int8smaller(coalesce(norm_abon,0),allbill)+0.00 ) *
     (1+date_mi_nol(date_smaller(dt_fin,eom(pmg)),date_larger(dt_beg,bom(pmg))))/day_in_month ,0)
      where act_lgt_tbl.ident=pflag;  
  end if;
    --- not area 
  delete from  act_lgt_tbl where dt_beg>=dt_fin   and act_lgt_tbl.ident=pflag;

 end if;

 -- callc total demand for    proportion on tarif lines
 select into allbill coalesce(sum(coalesce(demand)),0) from act_demand_tbl   where  ident=pflag;
 raise notice 'pflag % , allbill %',pflag,allbill;
 allrest=allbill;

select into tarif_begin bom(min(dat_b)) from act_demand_tbl where ident=pflag;
tarif_begin=date_larger(tarif_begin,(GetSysVarc('dt_start'))::date);
 -- divide demand on tarif
 insert into act_tarif_tbl  (id_paccnt ,  id_tarif ,  id_summtarif ,   all_demand , 
    lim_min_t ,  lim_max_t ,
    dt_b_tar ,  dt_e_tar ,  dt_b_dem ,  dt_e_dem ,
    per_demand ,  per_tarif ,
    lim_min ,  lim_max ,ident)
    select c.id,t.id,td.id as id_summtarif, allbill,
     coalesce(coalesce(tl.lim_min,t.lim_min),allbill) as lim_min_t,coalesce(coalesce(tl.lim_max,t.lim_max),allbill)  as lim_max_t,
     date_larger(d.dat_b,dt_begin),date_smaller(d.dat_e,dt_end) ,d.dat_b,d.dat_e,
     date_mi(d.dat_e,d.dat_b),date_mi(date_smaller(d.dat_e,dt_end),date_larger(d.dat_b,dt_begin)),
     round(int8smaller(coalesce(tl.lim_min,t.lim_min),allbill)::numeric/date_mi(d.dat_e,d.dat_b)::numeric*(date_mi(date_smaller(d.dat_e,dt_end),date_larger(d.dat_b,dt_begin))),0) as lim_min,
     round(int8smaller(coalesce(coalesce(tl.lim_max,t.lim_max),allbill),allbill)::numeric/date_mi(d.dat_e,d.dat_b)::numeric*(date_mi(date_smaller(d.dat_e,dt_end),date_larger(d.dat_b,dt_begin))),0) as lim_max,
     pflag
    from aqm_tarif_tbl t 
     left join aqm_tarif_seasonlimit_tbl tl on tl.id_tarif=t.id
     full join  aqv_tarif td on td.id_tarif=t.id,
        clm_paccnt_tbl c,(   select min(dat_b) as dat_b ,max(dat_e) as dat_e from act_demand_tbl where ident=pflag) d 
    where c.id=pid_acc  and c.id_gtar=t.id_grptar  
        and allbill>=coalesce(tl.lim_min,t.lim_min) 
        and pmg>=coalesce(tl.dt_b,pmg) and pmg<=coalesce(tl.dt_e,pmg)
        and  pmg>=coalesce(t.dt_b,pmg) and pmg<=coalesce(t.dt_e,pmg)
        and  td.dt_begin<=pmg -- and (td.dt_end-interval '1 day')::date>=pmg 
        --and td.dt_end>=pmg
        and td.dt_end>=tarif_begin
        and int4smaller(coalesce(tl.lim_min,t.lim_min), allbill) >=coalesce(tl.lim_min,t.lim_min)
   order by t.id,td.id,coalesce(tl.lim_min,t.lim_min);


   
  update act_tarif_tbl set dt_b_tar=dt_b_dem , per_tarif=per_demand,lim_min=lim_min_t,lim_max=lim_max_t where dt_e_tar<dt_b_tar;
  
  update act_tarif_tbl set lim_raz=lim_max-lim_min;

  insert into act_dem_tarif_tbl (  id_paccnt ,  id_meter ,  id_energy ,  id_zone , 
       dat_b ,  dat_e ,  demand ,koef_dem,
       demand_all ,  dat_b_all ,  dat_e_all ,  ident )
    select  distinct pid_acc,d.id_meter,d.id_energy,d.id_zone,  
       date_larger(dt_b_tar,dat_b),date_smaller(dt_e_tar,dat_e),  round(demand::numeric/date_mi(dat_e,dat_b)::numeric*date_mi(date_smaller(dt_e_tar,dat_e),date_larger(dt_b_tar,dat_b))::numeric,0)
       ,koef_dem,demand ,dt_b_dem,dt_e_dem, pflag
    from  act_tarif_tbl dt join act_demand_tbl  d     on true  and date_smaller(dt_e_tar,dat_e)>date_larger(dt_b_tar,dat_b);
  --and dt_b_tar>=dat_b    -- and  dt_e_tar<=dat_e 
  --and  date_smaller(dt_e_tar,dat_e)>=dt_b_tar

--  update  act_dem_tarif_tbl set koef_dem=1.00/(demand_all::numeric) *(demand::numeric)  where id_zone<>0 and demand<>demand_all and ident=pflag;
  flag_exit=0;
  select into max_prev count(*) from act_dem_tarif_tbl where pflag=ident;
  cou=0;
  while true loop
     if cou>max_prev then
         raise notice 'exit  while true *** cou % ****   max_prev %    exit',cou,max_prev; 
     exit;
   end if;
   cou=cou+1;
   select into allin coalesce(sum(coalesce(demand,0)),0) from act_summ_tbl d where d.ident=pflag;
   allrest=allbill-allin;
   raise notice 'while true *** cou % **** ostatok %',cou,allrest;
   if allrest<=0 then
      exit;
   end if;

   for rec_dem_tarif in select *  from act_dem_tarif_tbl dt 
      where dt.ident=pflag   order by dt.id_paccnt,dt.id_meter,dt.id_meter,dt.dat_b,dt.id_zone  loop
/* 
     for rec_dem_tarif in select dt.* ,dt.demand-coalesce(dsum,0)  as dsum from act_dem_tarif_tbl dt left join (select id_meter,id_energy,id_zone,dat_b,dat_e,sum(demand) as dsum 
 from act_summ_tbl  group by  id_meter,id_energy,id_zone,dat_b,dat_e) s 
 on s.id_meter=dt.id_meter and s.id_zone=dt.id_zone and s.dat_b=dt.dat_b and s.dat_e=dt.dat_e 
     where dt.demand-coalesce(dsum,0)>0 
      order by dt.id_paccnt,dt.id_meter,dt.id_meter,dt.dat_b,dt.id_zone
       loop
     */
      raise notice '   ***** for rec_dem tarif new %',rec_dem_tarif;
      
      select into allin coalesce(sum(coalesce(demand,0)),0) from act_summ_tbl d where d.ident=pflag;
      allrest=allbill-allin;
      raise notice       '      ******ostatok  in rec_dem_tarif  %',allrest;
      if allrest<=0 then
          raise notice   '      *****exit ostatok  in rec_dem_tarif <0   exit %',allrest;
         -- exit;
      end if;
      
      select into allin coalesce(sum(coalesce(demand,0)),0) 
       from act_summ_tbl d where d.ident=pflag and rec_dem_tarif.dat_b=dat_b and rec_dem_tarif.dat_e=dat_e   and rec_dem_tarif.id_zone=id_zone;
       allrestdem=rec_dem_tarif.demand-allin;
       raise notice '              *******rec_dem_tarif allrestdem %',allrestdem;
       if allrestdem<=0 then
          raise notice '           *******rec_dem_tarif allrestdem %    continue',allrestdem;
        -- continue;
       end if;
/*
       for rec_tarif in  select t.*    from  act_tarif_tbl t where dt_b_tar<=rec_dem_tarif.dat_b and dt_e_tar>=rec_dem_tarif.dat_e
         order by dt_b_tar,id_tarif,id_summtarif    loop
      

        */
       for rec_tarif in select t.lim_raz-coalesce(s.dsum,0) as dsum,t.* from act_tarif_tbl t left join 
            ( select id_tarif,id_summtarif,sum(demand) as dsum from act_summ_tbl group by id_tarif,id_summtarif ) s on t.id_tarif=s.id_tarif and t.id_summtarif=s.id_summtarif 
           where dt_b_tar<=rec_dem_tarif.dat_b and dt_e_tar>=rec_dem_tarif.dat_e and t.lim_raz-coalesce(s.dsum,0)>0
         order by dt_b_tar,id_tarif,id_summtarif    loop
           raise notice '               === rec_tarif %',rec_tarif;
           select into allin coalesce(sum(coalesce(demand,0)),0) from act_summ_tbl d where d.ident=pflag;
           allrest=allbill-allin;
           raise notice '                  rec_tarif ostatok %',allrest;
           if allrest<=0 then
                raise notice '             rec_tarif ostatok %   exit',allrest;
               exit;
           end if;
  
          select into allin coalesce(sum(coalesce(demand,0)),0) 
            from act_summ_tbl d where d.ident=pflag and rec_tarif.id_tarif=id_tarif and rec_tarif.id_summtarif=id_summtarif 
              and rec_tarif.dt_b_tar=dt_b_tar and rec_tarif.dt_e_tar=dt_e_tar and rec_dem_tarif.id_zone=id_zone;
         -- allresttar=round(rec_tarif.lim_raz*rec_dem_tarif.koef_dem,0)-allin;
           allresttar=round(rec_tarif.lim_raz*rec_dem_tarif.koef_dem,0)-allin;
              raise notice '                        rec_tarif allresttar new1 %',rec_dem_tarif;
              raise notice '                        rec_tarif allresttar rec_tarif %',rec_tarif;
          raise notice '                            rec_tarif allresttar %  rec_tarif.lim_raz  % rec_dem_tarif.koef_dem  %,allin %',allresttar,rec_tarif.lim_raz,rec_dem_tarif.koef_dem,allin;
          if allresttar<=0 then
              raise notice '                         rec_tarif allresttar %   continue',allresttar;
            if rec_dem_tarif.id_zone=0 then
              continue;
            end if;
          end if;
          select into allin coalesce(sum(coalesce(demand,0)),0) 
          from act_summ_tbl d where d.ident=pflag and rec_dem_tarif.dat_b=dat_b and rec_dem_tarif.dat_e=dat_e
               and rec_dem_tarif.id_zone=id_zone;
          allrestdem=coalesce(rec_dem_tarif.demand,0)-coalesce(allin,0);
          raise notice '                               rec_dem_tarif allrestdem   2 %',allrestdem;
          if allrestdem<=0 and allrest<=0 then
              raise notice ' exit                          allrestdem<=0 and allrest<=0   2 % allrest  %   exit',allrestdem,allrest;
              exit;
          end if;
         if allrestdem<=0 and allrest>0 then
            raise notice '                             allrestdem<=0 and allrest>0   allrestdem % allrest  %   continue',allrestdem,allrest;
            continue;
         end if;
                 raise notice '                               0000   allresttar  %,allrestdem %',allresttar,allrestdem;

          if allresttar<0 and allrestdem>0 then
              raise notice '                                        ++++++++++++++++++++++++++++++                     rec_tarif allresttar %  = 0 continue',allresttar;
             allresttar=0; 
          -- allresttar=allrestdem;
          end if; 

         if int8smaller( allresttar,allrestdem)>0 then      
              insert into act_summ_tbl (  id_paccnt , id_meter ,  id_energy ,  id_zone ,
             id_tarif   ,  id_summtarif ,  dat_b ,  dat_e ,dt_b_tar,dt_e_tar,demand,  summ,koef_lgt_zon, ident )
              values(rec_dem_tarif.id_paccnt , rec_dem_tarif.id_meter ,  rec_dem_tarif.id_energy ,  rec_dem_tarif.id_zone , 
               rec_tarif.id_tarif,rec_tarif.id_summtarif , rec_dem_tarif.dat_b, rec_dem_tarif.dat_e, rec_tarif.dt_b_tar,rec_tarif.dt_e_tar,
               int8smaller( allresttar,allrestdem),0,rec_dem_tarif.koef_dem,pflag );
         end if;
               
         /*  for  test in select  * from    act_summ_tbl  where ident=pflag loop
             raise notice '      ===== act_summ_tbl  %',test;
           end loop;
        */
       end loop;
   end loop;
 end loop;
 cou=0;

 while true loop
    for rec_dem_tarif in    select * 
     from  act_summ_tbl s,
     (select s.dat_b,s.dat_e,s.id_zone,sum(s.demand) as sdem,d.demand, d.demand-coalesce(sum(s.demand),0) as raz 
      from act_summ_tbl s,act_dem_tarif_tbl d  
       where s.id_zone=d.id_zone and   d.dat_b=s.dat_b and s.dat_e=d.dat_e group by s.id_zone, s.dat_b,s.dat_e,d.demand having d.demand-coalesce(sum(s.demand),0) <>0
      ) ss
      where s.dat_b=ss.dat_b and s.dat_e=ss.dat_e and s.id_zone=ss.id_zone  order by s.dat_b,s.dat_e,s.id_zone,s.id_summtarif desc ,s.id_tarif desc limit 1 loop
      raise notice '=====  zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz est ';
      raise notice '=====  zzzzzzzzzzzzzzzzzz cou   % rec_dem_tarif % ',cou,rec_dem_tarif;
     update act_summ_tbl set demand=demand+rec_dem_tarif.raz where dat_b=rec_dem_tarif.dat_b and dat_e=rec_dem_tarif.dat_e and id_zone=rec_dem_tarif.id_zone 
       and id_tarif=rec_dem_tarif.id_tarif and id_summtarif=rec_dem_tarif.id_summtarif and demand=rec_dem_tarif.demand; 
      exit;
    end loop; -- for rec_dem_tarif
    if cou>6 then 
      exit;
    end if;
    cou=cou+1; 
 end loop;

  update act_summ_tbl set summ=round(demand*t.value*z.koef,2) from
        aqv_tarif t , eqk_zone_tbl z 
      where t.id=act_summ_tbl.id_summtarif and t.dt_begin<=pmg and t.dt_end>=pmg and act_summ_tbl.id_zone=z.id and z.id=act_summ_tbl.id_zone 
      and act_summ_tbl.ident=pflag;  
      
/*   devision lgt   */

  raise notice 'insert into act_lgt_summ_tbl';
  cou=0;
  select into alltarif coalesce(sum(coalesce(norm_lgt,0)),0) from act_lgt_tbl d where d.ident=pflag;
  select into alllgt coalesce(sum(coalesce(norm_lgt,0)),0) from act_lgt_tbl d where d.ident=pflag;
 
  while true loop
    for rec_sum in  
            select distinct d.id_paccnt ,  d.id_energy ,  d.id_zone ,  d.id_tarif,d.id_summtarif , d.dat_b,d.dat_e,
             d.demand  as demand ,coalesce(l.demand_lgt,0) as demand_lgt,d.demand-coalesce(l.demand_lgt,0) as raz_lgt,d.koef_lgt_zon
       from     ( select   d.id_paccnt ,  d.id_energy ,  d.id_zone ,  d.id_tarif,d.id_summtarif , d.dat_b,d.dat_e,
                sum(d.demand)  as demand,d.koef_lgt_zon from act_summ_tbl d    where d.ident=pflag
             group by d.id_paccnt ,  d.id_energy ,  d.id_zone ,  d.id_tarif,d.id_summtarif,d.dat_b,d.dat_e,d.koef_lgt_zon ) d
       left join    ( select l.id_tarif,l.id_summtarif,l.id_zone,sum(l.demand_lgt) as demand_lgt from act_lgt_summ_tbl l
                      where l.ident=pflag
             group by id_paccnt ,  id_energy ,  id_zone ,  id_tarif,id_summtarif
        ) l   on (l.id_tarif=d.id_tarif and l.id_summtarif=d.id_summtarif and l.id_zone=d.id_zone  ) ,
       act_tarif_tbl t 
       where   t.id_tarif=d.id_tarif   and ( (alltarif>t.lim_min or t.lim_min=0) and (alltarif>t.lim_min_t or t.lim_min_t=0) ) 
       -- and (d.demand)-(coalesce(l.demand_lgt,0))>0
       order by  d.id_paccnt ,  d.id_energy , d.id_zone ,  d.id_tarif, d.id_summtarif,d.dat_b,d.dat_e
      loop
       raise notice ' for lgt cou % rec_sum  %',cou,rec_sum;
       
     for rec_lgt in select * from act_lgt_tbl  where ident=pflag order by dt_beg  loop
       raise notice '33  cou % rec_lgt  %',cou,rec_lgt;

       select into alllgtin coalesce(sum(demand_lgt),0) 
       from    act_lgt_summ_tbl 
              where id_lgm=rec_lgt.id_lgm and dt_beg=rec_lgt.dt_beg and dt_fin=rec_lgt.dt_fin   and act_lgt_summ_tbl.ident=pflag; 
       if not found then
         continue;
       end if;
        raise notice '1 cou % rest_lgt %',cou,rest_lgt;
        rest_lgt= rec_lgt.norm_lgt-alllgtin;     
        raise notice '2 cou % rest_lgt %',cou,rest_lgt;
       if rest_lgt<=0 then
          raise notice '2 cou % rest_lgt %   continue ',cou,rest_lgt;
       
         continue;
       end if;
       if rec_sum.id_zone=0 then
          select into alllgtin coalesce(sum(demand_lgt),0) 
           from   act_lgt_summ_tbl where id_lgm=rec_lgt.id_lgm   and dt_beg=rec_lgt.dt_beg and dt_fin=rec_lgt.dt_fin and ident=pflag; 
            rest_lgt= rec_lgt.norm_lgt-coalesce(alllgtin,0); 
              raise notice '3 cou % rest_lgt %',cou,rest_lgt;
        else
          if rec_lgt.id_tar_grp=3 then
              if alllgt<allbill then
                select into koefzone  koef_lgt_zone from  eqk_zone_tbl  where id=rec_sum.id_zone and koef_lgt_zone is not null; 
              else 
                    koefzone=1.00;
              end if;

          else 
            select into allzone sum(coalesce(d.demand,0)) from act_summ_tbl  d 
                where d.id_paccnt=rec_sum.id_paccnt  and  d.id_energy=rec_sum.id_energy  and d.id_zone>0; --and d.id_zone=rec_sum.id_zone;
                -- select int4smaller(34343,34)
               koefzone=round( rec_lgt.norm_lgt::numeric/(int4smaller(allzone::int,rec_lgt.norm_lgt)::numeric)::numeric,4)::numeric;
               raise notice 'koefzone %  ',koefzone; 
           end if; 
          select into alllgtin coalesce(sum(demand_lgt),0) 
              from   act_lgt_summ_tbl where id_zone=rec_sum.id_zone   and  id_lgm=rec_lgt.id_lgm  and ident=pflag; 
                raise notice '4 cou % rest_lgt %',cou,rest_lgt;
              if (rest_lgt>((rec_lgt.norm_lgt-coalesce(alllgtin,0))*koefzone*rec_sum.koef_lgt_zon)::int) then
                 rest_lgt= ((rec_lgt.norm_lgt-coalesce(alllgtin,0))*koefzone*rec_sum.koef_lgt_zon)::int; 
                 end if;
                 if rec_sum.raz_lgt<rest_lgt then
                 rest_lgt=rec_sum.raz_lgt;
                 end if;
                 raise notice '5 cou % rest_lgt %',cou,rest_lgt;
        end if;  
        
 
              raise notice '7 cou % rest_lgt %',cou,rest_lgt;
       if rec_sum.id_zone=0 then 
        if rest_lgt>rec_sum.demand then
        if rest_lgt>round(rec_sum.demand /(day_in_month::numeric)*(date_mi(rec_lgt.dt_fin,rec_lgt.dt_beg)+1)::numeric,0)::int then
         rest_lgt=round(rec_sum.demand /(day_in_month::numeric)*(date_mi(rec_lgt.dt_fin,rec_lgt.dt_beg)+1)::numeric,0)::int;
        end if; 
        end if;
       end if;
            raise notice '8 cou % if rec_sum.id_zone>0  rest_lgt %',cou,rest_lgt;
       if rec_sum.id_zone>0 then 
          if rest_lgt>=rec_sum.demand then
              rest_lgt=rec_sum.demand ;
            end if;  
       end if;
           raise notice ' insert cou % 0000000000000 alllgtin %',cou,alllgtin;
        raise notice ' insert cou % 0000000000000rest_lgt  %',cou,rest_lgt;

        if rest_lgt is not null and rest_lgt>0 then
       insert into act_lgt_summ_tbl (  id_lgm, id_paccnt ,   id_energy ,  id_zone ,
           id_tarif   ,  id_summtarif , id_grp_lgt, percent,dat_b,dat_e,
           demand,demand_lgt,summ_lgt,dt_beg,dt_fin,ident)
         values (rec_lgt.id_lgm,  rec_sum.id_paccnt ,  rec_sum.id_energy ,  rec_sum.id_zone , 
              rec_sum.id_tarif,rec_sum.id_summtarif ,rec_lgt.id_grp_lgt,rec_lgt.percent,rec_sum.dat_b,rec_sum.dat_e,
              rec_sum.demand, rest_lgt ,0,rec_lgt.dt_beg,rec_lgt.dt_fin,pflag);
          update act_lgt_summ_tbl set demand_lgt=demand where demand_lgt>demand and ident=pflag;
        for test in select * from act_lgt_summ_tbl loop
           raise notice ' test 0000000000000 %',test;
        end loop;
      end if;
    end loop; -- rec_sum
   end loop;   --rec_lgt
       if cou>3 then 
      exit;
    end if;
    cou=cou+1; 
   end loop;

  --741/138A
  -- if summ lgota>raspredelennoy
  for rec_lgt in select id_grp_lgt,id_lgm,sum(coalesce(norm_lgt,0)) as norm from act_lgt_tbl  where ident=pflag group by id_grp_lgt,id_lgm  loop
    select into rest_lgt rec_lgt.norm-coalesce(sum(demand_lgt),0) 
     from  act_lgt_summ_tbl 
     where id_lgm=rec_lgt.id_lgm and id_grp_lgt=rec_lgt.id_grp_lgt     and act_lgt_summ_tbl.ident=pflag and id_summtarif is not null; 
     if not found then
       continue;
     end if;
     raise notice 'deviziom rest lgt lgt %',rest_lgt;
    if rest_lgt<>0 then
      for addsum in select * 
       from act_lgt_summ_tbl where  id_grp_lgt=rec_lgt.id_grp_lgt and id_lgm=rec_lgt.id_lgm and demand-demand_lgt>rest_lgt  
        and ident=pflag and id_summtarif is not null limit 1 loop
        raise notice 'deviziom lgt %',addsum;
        update act_lgt_summ_tbl set demand_lgt=demand_lgt+rest_lgt
         where id_paccnt=addsum.id_paccnt  and id_grp_lgt=addsum.id_grp_lgt and id_lgm=addsum.id_lgm and  id_energy =addsum.id_energy
               and   id_zone=addsum.id_zone  and      id_tarif=addsum.id_tarif   and  id_summtarif=addsum.id_summtarif  
               and dt_beg=addsum.dt_beg  and  dt_fin=addsum.dt_fin  and demand=addsum.demand  and ident=addsum.ident and demand_lgt=addsum.demand_lgt;
      end loop;     
    end if;  
  end loop;
    
  update act_lgt_summ_tbl set demand_lgt=demand where demand_lgt>demand and ident=pflag;
  update act_lgt_summ_tbl set summ_lgt=round(demand_lgt*t.value*z.koef*(percent)/100,2)  
    from aqv_tarif t,eqk_zone_tbl z  where t.id=id_summtarif and z.id=act_lgt_summ_tbl.id_zone and ident=pflag;
   -- dop lgota from acm_dop_lgt_tbl
  if pmg>'2016-02-01' or (pflag=9 and pmg>'2016-02-01') then
     raise notice ' add_lgt   pmg>2016-02-01 or pflag=2';
     insert into act_lgt_summ_tbl (id_doc,id_paccnt,id_energy,id_zone,id_grp_lgt,summ_lgt,mmgg_corr,ident) 
      select pid_doc,id_paccnt,10,0,id_grp_lgt,sum_val,mmgg_lgt,pflag 
      from (select d.* from acm_dop_lgt_tbl d,lgi_group_tbl l where l.id=d.id_grp_lgt  --and id_calc in (7,18)
           ) dl 
      where mmgg=pmg and id_paccnt=pid_acc and id_grp_lgt is not null and sum_val<>0;  
  end if;
   pidk_doc=200;
   ppref=10;
  if pflag=2 then
    ppref=12; --planov
  end if;
  if pflag=9 then
   pidk_doc=220; --korrect
  end if;
  insert into acm_bill_tbl 
      (     idk_doc ,  id_pref ,  reg_num ,  reg_date ,  id_paccnt ,   id_bill ,    mmgg_bill,id_corr_doc ) 
   values(  pidk_doc,ppref,'',eom(pmg)+ interval '1 day',pid_acc,null,pmg,bill_corr);

   pid_doc:=currval('acm_bill_seq');

  insert into acm_demand_tbl (id_doc ,  id_paccnt ,  id_meter,  id_energy ,  id_zone ,  dat_b ,  dat_e ,  
     demand ,  losts , dem_nolost, ident ) select pid_doc, id_paccnt ,  id_meter,  id_energy ,  id_zone ,  dat_b ,  dat_e ,   demand ,  losts,dem_nolost ,ident 
     from act_demand_tbl where ident=pflag;

  insert into acm_dem_tarif_tbl (id_doc, id_paccnt ,  id_meter ,  id_energy,  id_zone ,  dat_b ,  dat_e ,
     demand ,  day ,  day_all ,  demand_all ,  dat_b_all ,  dat_e_all ,  ident ,    koef_dem )
  select  pid_doc ,id_paccnt ,  id_meter ,  id_energy,  id_zone ,  dat_b ,  dat_e ,
     demand ,  day ,  day_all ,  demand_all ,  dat_b_all ,  dat_e_all ,  ident ,    koef_dem 
     from act_dem_tarif_tbl where ident=pflag;

  insert into acm_lost_tbl (id_doc ,  id_paccnt ,  dat_b ,  dat_e ,  lvl ,  id_voltage ,  id_energy ,  id_eqp ,  type_eqp ,  id_type_eqp ,
  sn_len ,  tt ,  tw ,  pxx_r0 ,  pkz_x0 ,  ixx,  ukz_un ,  wp ,  wq ,  wp_summ ,  s_xx_addwp ,  s_kz_addwq ,  dw ,  ident )
  select  pid_doc , id_paccnt ,  dat_b ,  dat_e ,  lvl ,  id_voltage ,  id_energy ,  id_eqp ,  type_eqp ,  id_type_eqp ,
  sn_len ,  tt ,  tw ,  pxx_r0 ,  pkz_x0 ,  ixx,  ukz_un ,  wp ,  wq ,  wp_summ ,  s_xx_addwp ,  s_kz_addwq ,  dw ,  ident 
   from act_lost_tbl where ident=pflag;

    insert into acm_demandlost_tbl (id_doc ,  id_paccnt ,  id_energy ,  id_meter ,  num_eqp ,  id_zone ,  id_prev ,  dat_ind ,  value ,
  coef_comp ,  value_diff ,  value_cons ,  ident)
  select  pid_doc , id_paccnt ,  id_energy ,  id_meter ,  num_eqp ,  id_zone ,  id_prev ,  dat_ind ,  value ,
  coef_comp ,  value_diff ,  value_cons ,  ident
   from act_demandlost_tbl where ident=pflag;

  
   insert into acm_summ_tbl (id_doc ,  id_paccnt ,  id_meter,  id_energy ,  id_zone ,  id_tarif ,  id_summtarif,
     dat_b ,  dat_e ,  demand ,  summ ,  ident ) 
    select pid_doc,   id_paccnt ,  id_meter,  id_energy ,  id_zone ,  id_tarif ,  id_summtarif,  dat_b ,  dat_e ,  demand ,  summ ,  ident 
    from act_summ_tbl where ident=pflag;

   insert into acm_lgt_tbl ( id_doc, id_paccnt,  famyly_cnt,dt_start,dt_end,dt_beg,dt_fin,
      id_grp_lgt,lg_dtb,lg_dte,   id_calc,calc_dtb,calc_dte,
      id_ln,id_tar_grp,percent,ln_dtb,ln_dte,
      norm_min,norm_one,norm_max,norm_heat_demand,norm_heat_one,norm_heat_family,
      norm_abon,  norm_lgt,  norm_abon_heat,ident )  
    select  pid_doc,id_paccnt,  famyly_cnt,dt_start,dt_end,dt_beg,dt_fin,
      id_grp_lgt,lg_dtb,lg_dte,  id_calc,calc_dtb,calc_dte,
      id_ln,id_tar_grp,percent,ln_dtb,ln_dte,
      norm_min,norm_one,norm_max,norm_heat_demand,norm_heat_one,norm_heat_family,
      norm_abon, norm_lgt,   norm_abon_heat,ident
     from act_lgt_tbl where ident=pflag;

    insert into acm_lgt_summ_tbl ( id_doc,id_paccnt , id_meter ,  id_energy ,  id_zone ,
           id_tarif   ,  id_summtarif , id_grp_lgt, percent,dat_b ,  dat_e ,dt_beg,dt_fin,demand,demand_lgt,
           summ_lgt,mmgg_corr,ident)
       select pid_doc,id_paccnt , id_meter ,  id_energy ,  id_zone ,
           id_tarif   ,  id_summtarif ,id_grp_lgt, percent, dat_b ,  dat_e ,dt_beg,dt_fin,demand,demand_lgt,
           summ_lgt,mmgg_corr,ident
      from act_lgt_summ_tbl where  ident=pflag and summ_lgt<>0.00;
      
  

 update acm_bill_tbl set demand=coalesce(t.dem,0.00),value_calc=coalesce(t.summ,0.00),value_lgt=coalesce(tl.summ,0.00), 
                         value=coalesce(t.summ,0.00)-coalesce(tl.summ,0.00), value_tax=round((coalesce(t.summ,0.00)-coalesce(tl.summ,0.00))/tax_in,2)
  from ( select coalesce(sum(demand),0.00) as dem,coalesce(sum(coalesce(summ,0.00)),0.00) as summ  from act_summ_tbl  where ident=pflag) t,
       ( select sum(coalesce(summ_lgt,0.00)) as summ  from act_lgt_summ_tbl   where ident=pflag) tl
  where id_doc=pid_doc ; 

 Return true;
end;
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION calc_bill(integer, date, integer, integer)
  OWNER TO postgres;



  