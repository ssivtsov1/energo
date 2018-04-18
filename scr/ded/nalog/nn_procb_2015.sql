;
set client_encoding='win';

update clm_client_tbl set add_name = null where add_name = '';

--select fill_calend_global('2015-01-01'::date,'2015-12-31'::date);

--drop function acm_CloseTaxDecade2015(int);
/*
ALTER TABLE acm_tax_tbl ADD COLUMN decade integer;
ALTER TABLE acm_taxcorrection_tbl ADD COLUMN decade integer;

ALTER TABLE acd_tax_tbl ADD COLUMN unit_kod character varying(10);
ALTER TABLE acd_tax_tbl ADD COLUMN uktzed character varying(10);

ALTER TABLE acd_taxcorrection_tbl ADD COLUMN unit_kod character varying(10);
ALTER TABLE acd_taxcorrection_tbl ADD COLUMN uktzed character varying(10);


ALTER TABLE acd_tax_tbl disable trigger all;
ALTER TABLE acd_taxcorrection_tbl disable trigger all;

ALTER TABLE acm_tax_tbl ADD COLUMN disabled integer;
ALTER TABLE acm_tax_tbl ALTER COLUMN disabled SET DEFAULT 0;

ALTER TABLE acm_tax_tbl disable trigger all;
update acm_tax_tbl set disabled = 0 where disabled is null;
ALTER TABLE acm_tax_tbl enable trigger all;
*/

--update acd_tax_tbl set unit_kod = CASE WHEN unit='кВт.год' then '0415' WHEN unit='грн' then '2454' END 
--where mmgg >= '2015-01-01' and unit_kod is null;

--update acd_taxcorrection_tbl set unit_kod = CASE WHEN unit='кВт.год' then '0415' WHEN unit='грн' then '2454' END 
--where mmgg >= '2015-01-01' and unit_kod is null;

--update acd_tax_tbl set uktzed = '2716000000'
--from acm_tax_tbl as t where t.id_doc = acd_tax_tbl.id_doc and 
--t.id_pref = 10 and t.mmgg >= '2015-01-01' and uktzed is null;

--update acd_taxcorrection_tbl set uktzed = '2716000000'
--from acm_taxcorrection_tbl as t where t.id_doc = acd_taxcorrection_tbl.id_doc and 
--t.id_pref = 10 and t.mmgg >= '2015-01-01' and uktzed is null;


ALTER TABLE acd_tax_tbl enable trigger all;
ALTER TABLE acd_taxcorrection_tbl enable trigger all;

create or replace function acm_CloseTaxDecade2015(int) returns boolean as'
  declare

   pdecade    alias for $1;

   vreg_date1    date;
   vreg_date2    date;
   vreg_date3    date;
   vdate_start   date;
   vdate_end     date; 

   vmmgg        date; 
   vclient      record;
   vid_pref20   int;
   vid_prefre   int;
   vid_pref0    int;
   vsplit_mode  int;
   v            boolean;
   vint         int;
   vbillpay     record;
   vcnt int;
   vint_num     int;
   vint_num2    int;
  begin



    vmmgg:=fun_mmgg();

    if (vmmgg >= ''2015-08-01'') and (pdecade <> 3) then
       return false;
    end if;

    if (vmmgg >= ''2016-01-01'') then
       return false;
    end if;


    select into vreg_date1 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
--    and coalesce(holiday,false) = false 
    and c_date >= vmmgg::date+''9 days''::interval
    order by c_date limit 1; 


    select into vreg_date2 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
--    and coalesce(holiday,false) = false 
    and c_date >= vmmgg::date+''19 days''::interval
    order by c_date limit 1; 


    select into vreg_date3 c_date
    from calendar where  date_trunc(''month'', c_date) =  vmmgg  
    --and coalesce(holiday,false) = false 
    order by c_date desc limit 1; 
    


    if pdecade = 1 then

      vdate_start = vmmgg;
      vdate_end = vreg_date1;

    end if;


    if pdecade = 2 then

      vdate_start = vreg_date1+''1 days''::interval;
      vdate_end = vreg_date2;

      select into vcnt coalesce(count(*),0) from acm_tax_tbl where mmgg = vmmgg and reg_date = vreg_date1 and kind_calc = 7;

      if vcnt=0 then
         Raise EXCEPTION ''Налоговые накладные за предыдущую декаду не сформированы!'';
      end if;        

    end if;


    if pdecade = 3 then

     if (vmmgg < ''2015-08-01'') then

      vdate_start = vreg_date2+''1 days''::interval;
      vdate_end = vreg_date3;

      select into vcnt coalesce(count(*),0) from acm_tax_tbl where mmgg = vmmgg and reg_date = vreg_date2 and kind_calc = 7;

      if vcnt=0 then
         Raise EXCEPTION ''Налоговые накладные за предыдущую декаду не сформированы!'';
      end if;        
     else

      vdate_start = vmmgg;
      vdate_end = vreg_date3;

     end if;

    end if;


    Raise Notice '' период с % по % mmgg %.'',vdate_start, vdate_end,vmmgg;

/*
    select into vcnt count(*) from acm_tax_tbl 
    where mmgg = vmmgg and kind_calc = 7 and reg_date = vdate_end;

    if vcnt>0 then 
        Raise EXCEPTION ''Налоговые накладные на платежи квартала уже сформированы.'';
        return false;
    end if;
*/

--    delete from acm_tax_tbl where auto = 1 and mmgg= vmmgg;
/*
    perform seb_all(0,vmmgg);

    update seb_obrs_tmp set b_dtval=0,b_ktval=b_ktval-b_dtval,
                    b_dtval_tax=0,b_ktval_tax=b_ktval_tax-b_dtval_tax
             where b_dtval<0;

    update seb_obrs_tmp set e_dtval=0,e_ktval=e_ktval-e_dtval,
                    e_dtval_tax=0,e_ktval_tax=e_ktval_tax-e_dtval_tax
             where e_dtval<0;
*/
    -- по оплатам за декаду

    if pdecade in (1,2) then

      for vclient in 
       select cm.id,cm.code,cp.flag_budjet, p.id_pref, sum(p.value) as value, sum(p.value_tax) as value_tax   

       from clm_client_tbl as cm 
       join clm_statecl_h as cp on (cp.id_client=cm.id)
       join acm_pay_tbl  as p on (p.id_client = cm.id)
       where cm.book = -1  
   	--and s.id_pref = 10 
       and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= vmmgg ) 
       and cm.idk_work = 1
       and cp.id_section not in (206,207,205,208)  
       and p.reg_date >= vdate_start and p.reg_date <= vdate_end and p.mmgg = vmmgg
       and p.idk_doc = 100
       and p.sign_pay = 1
  --     and cp.flag_budjet = 0
       and p.id_pref in (10,20,520)
       and (p.value <>0 or p.value_tax <>0 )
       group by cm.id,cm.code,cp.flag_budjet, p.id_pref
       order by p.id_pref, cm.code 
      loop

        Raise Notice '' оплата - абонент % вид %. code %'',vclient.id,vclient.id_pref,vclient.code;

        vint:= acm_createTaxPayDecade(vclient.id, vclient.id_pref, pdecade, vmmgg, vdate_start, vdate_end, 0 );
  
      end loop;

    end if; 



    -- третья декада - закрытие месяца практически по старому алгоритму,
    -- оплаты первых декад воспринимаем как авансы
    if pdecade = 3 then

      delete from acm_taxadvcor_tbl where mmgg = vmmgg;

--      if vmmgg =''2015-01-01''::date then
      v:= acm_tax_correction_restore(null, (vmmgg::date - ''1 month''::interval)::date );
--      end if;

      perform seb_all(0,vmmgg);

      update seb_obrs_tmp set b_dtval=0,b_ktval=b_ktval-b_dtval,
                    b_dtval_tax=0,b_ktval_tax=b_ktval_tax-b_dtval_tax
             where b_dtval<0;

      update seb_obrs_tmp set e_dtval=0,e_ktval=e_ktval-e_dtval,
                    e_dtval_tax=0,e_ktval_tax=e_ktval_tax-e_dtval_tax
             where e_dtval<0;



     -- все клиенты-юридические лица
     -- активная
      for vclient in 
       select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv, cm.code
       from clm_client_tbl as cm 
       join clm_statecl_h as cp on (cp.id_client=cm.id)
       join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
--       left join aci_pref_tbl as p on (p.id=s.id_pref)
       where cm.book = -1  and s.id_pref = 10 
       and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= vmmgg ) 
       and cm.idk_work = 1
       and cp.id_section not in (206,207,205,208)  
       order by s.id_pref, cm.code
      loop

        Raise Notice '' абонент % (%) вид %.'',vclient.code,vclient.id, vclient.id_pref;

       if (vclient.flag_budjet=0) then

        vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date3);

       end if;

       -- все бюджетники
       if (vclient.flag_budjet=1) then

        vint:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date3,0);

       end if;
     
       -- есть кредитовое сальдо на конец месяца
       if  (vclient.kr_zkme <> 0) then

        vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date3,1);

       end if;

      end loop;
    -----------------------------------------------------------------------------
  
      --реактив
      for vclient in 
       select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv, cm.code
       from clm_client_tbl as cm 
       join clm_statecl_h as cp on (cp.id_client=cm.id)
       join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
  --     left join aci_pref_tbl as p on (p.id=s.id_pref)
       where cm.book = -1 
       and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= vmmgg ) 
       and cm.idk_work = 1 and s.id_pref = 20
       and cp.id_section not in (206,207,205,208)  
       order by s.id_pref, cm.code
      loop

        Raise Notice '' абонент % (%) вид %.'',vclient.code,vclient.id, vclient.id_pref;

       if (vclient.flag_budjet=0) then

        vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date3);

       end if;

       -- все бюджетники
       if (vclient.flag_budjet=1) then

        vint:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date3,0);

       end if;

       -- есть кредитовое сальдо на конец месяца
       if  (vclient.kr_zkme <> 0) then

        vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date3,1);

       end if;

      end loop;

      v:= acm_createTaxLgt(vmmgg,vreg_date3);
       --  НН на физлиц
      v:= acm_createTaxFiz(vmmgg,vreg_date3);

    end if;


    vint:=acm_createTaxNotPayerDecade(vmmgg,10,vdate_start, vdate_end, pdecade);
    vint:=acm_createTaxNotPayerDecade(vmmgg,20,vdate_start, vdate_end, pdecade);


    select into vint_num coalesce(max(int_num),0) from acm_tax_tbl where mmgg=vmmgg and disabled = 0 ; 
    select into vint_num2 coalesce(max(int_num),0) from acm_taxcorrection_tbl where mmgg=vmmgg; 


    if vint_num<vint_num2 then
       vint_num:=vint_num2;
    end if;

    update syi_sysvars_tbl set value_ident= text(vint_num+1)::varchar  where ident=''last_tax_num'';

    return true;
  end;
' LANGUAGE 'plpgsql';


------------------------------------------------------------------------------------
--drop function acm_createTaxPayDecade(int,int, date, date, date, int );
-- использовался для оплаты 1-2 декады, с августа 2015 не нужен
create or replace function acm_createTaxPayDecade(int,int, int,date, date, date, int ) returns int as'
  declare 

     pid_client   alias for $1;
     pid_pref     alias for $2;
     pdecade      alias for $3;
     pmmgg        alias for $4;
     pstart_date  alias for $5;
     preg_date    alias for $6;
     prebuild     alias for $7;

     vsaldo       record;
     vktsaldo     record;
     vktmove      record;
     vktsaldo_old record;
     vpay         record;
     vpay_all     record;
     vreg_num     varchar;
     vreg_date    date;
     vnum_end     varchar;
     vvalue	  numeric(14,4);
     vvalue_tax   numeric(14,4);
     vvalue_tax_math   numeric(14,4);
     vpref        varchar;
     vtariff      numeric(14,4);
     vid_tariff   int;
     vsumtariff    record;
     vmaintariff   record;
     vdemand      numeric(14,4);
     vflag_budjet int;
     vid_tax      int;
     vid_new      int;
     vint_num     int;
--     vbudjet      int;
     vstcl        record;
     vsumtariff_math numeric;
     vlimit numeric;

     vvalue_all	  numeric(14,4);
     vvalue_tax_all   numeric(14,4);


  begin


    select into vid_tax id_doc from acm_tax_tbl 
    where id_client = pid_client and mmgg = pmmgg and kind_calc = 7 and id_pref = pid_pref and reg_date = preg_date and disabled = 0;

    if found then 

      if prebuild = 0 then 
        --Raise EXCEPTION ''Налоговая накладная на платежи квартала уже сформирована.'';
        Raise notice ''Налоговая накладная на платежи квартала уже сформирована.'';
        return -2;
      end if;
    end if;


/*
  if prebuild = 1 then 

     perform seb_one( pmmgg ,0 ,pid_client );

  end if;
*/

  select into vpref ident from aci_pref_tbl where id=pid_pref;

  select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h 
      where id_client = pid_client and mmgg_b <= pmmgg order by mmgg_b desc limit 1;

 -- среди года ок, в начале года может быть нужно более сложно вычислять код колонки
  select into vsaldo 
  CASE WHEN c.order_pay =0 THEN coalesce(-ss.deb_kme,0) ELSE coalesce(-deb_km15e,0) END as bdt,
  CASE WHEN c.order_pay =0 THEN coalesce(-ss.deb_kmpdv,0) ELSE coalesce(-deb_km15pdv,0) END as bdt_tax
--  coalesce(-sum(deb_kme),0) as bdt, coalesce(sum(kr_zkme),0) as bkt,
--  coalesce(-sum(deb_kmpdv),0) as bdt_tax, coalesce(sum(kr_zkmpdv),0) as bkt_tax
  from seb_obr_all_tbl as ss
  join clm_client_tbl as c on (c.id = ss.id_client)
  where id_client=pid_client and id_pref=pid_pref and mmgg = pmmgg - ''1 month''::interval ;


  Raise Notice '' дебет нач %'',vsaldo.bdt;  
  Raise Notice '' дебет нач ндс кон %'',vsaldo.bdt_tax;  


--  Raise Notice ''Налоговая накладная на оплату для абонента % '',pid_client ;
  ------------------------------------------------------------------

  -- берем платежки только положительные, и только идущие на оплату текущего года 
  -- остальное пусть правят корректировками
/*
  if date_part(''year'',vpay.mmgg_pay) <> date_part(''year'',vpay.mmgg) then
     Raise NOTICE ''Оплата прошлых годов. Не обрабатываем.'';
     return 0;
  end if;

  if vpay.value < 0 or vpay.value_tax < 0 then
     Raise NOTICE ''Отрицательный платеж.  Не обрабатываем.'';
     return 0;
  end if;
*/

  select into vpay numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
  from acm_pay_tbl as p
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg  
  and p.reg_date >= pstart_date and p.reg_date <= preg_date
  and p.idk_doc = 100
  and p.sign_pay = 1;

  select into vpay_all numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
  from acm_pay_tbl as p
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg  
  and p.reg_date <= preg_date
  and p.idk_doc = 100
  and p.sign_pay = 1;
  /*
  raise notice '' pid_pref %'',pid_pref;
  raise notice '' preg_date  %'',preg_date;
raise notice '' pstart_date  %'',pstart_date;
  raise notice ''vstcl.flag_budjet  %'',vstcl.flag_budjet;

   Raise Notice '' сумма оплаты для налоговой1 %'',vvalue;  
   Raise Notice '' сумма оплаты для налоговой1 ПДВ %'',vvalue_tax;  
    */
  if vstcl.flag_budjet = 0 then
    
    vvalue:=numeric_smaller(vpay.pay, numeric_larger(vpay_all.pay-coalesce(vsaldo.bdt,0),0));
    vvalue_tax:=numeric_smaller(vpay.pay_pdv, numeric_larger(vpay_all.pay_pdv-coalesce(vsaldo.bdt_tax,0),0));
  else
    vvalue:=numeric_larger(vpay.pay, 0);
    vvalue_tax:=numeric_larger(vpay.pay_pdv,0);
   
  --  vvalue:=coalesce(vpay.pay, 0);
  --  vvalue_tax:=coalesce(vpay.pay_pdv,0);


  end if;
  /* Raise Notice '' сумма оплаты для налоговой %'',vvalue;  
   Raise Notice '' сумма оплаты для налоговой ПДВ %'',vvalue_tax;  

  */


  if vvalue >0 or vvalue_tax >0 then

   Raise Notice '' сумма оплаты для налоговой %'',vvalue;  
   Raise Notice '' сумма оплаты для налоговой ПДВ %'',vvalue_tax;  


   select into vnum_end value_ident from syi_sysvars_tbl 
   where ident=''tax_num_ending'';

   vreg_date:=preg_date;

   if (coalesce(vstcl.flag_taxpay,0)=0)  then
     vint_num = 0;
     vreg_num:=''''; 
   else
     vint_num = acm_nexttaxnum(pmmgg);
     vreg_num:=Text(vint_num)||vnum_end; 
   end if;


   --заголовок
   insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,int_num,auto,mmgg,decade)
   values(default, pid_pref,7,0,vreg_date,vreg_num,pid_client,vvalue,vvalue_tax,vint_num,1,pmmgg,pdecade) returning id_doc into vid_new;


   -- строка
    
   --как найти тариф для аванса
   -- берем тариф, по которому данный абонент потребил больше всего кВтч 
   -- за последние 3 месяца
    select into vmaintariff sum(bs.demand_val) as max_demand,bs.id_tariff
    from acm_bill_tbl as b 
    join acd_billsum_tbl as bs using (id_doc)
    where b.id_client=pid_client and b.mmgg<=pmmgg and (b.mmgg::date)>=(pmmgg-''3 month''::interval)::date
    and b.id_pref = pid_pref and bs.id_tariff is not null and bs.sum_val <> 0
    group by bs.id_tariff
    order by max_demand desc LIMIT 1 OFFSET 0;

    if not found then

      if vpref=''react_ee'' then 
        --для реактива есть один спец. тариф
        select into vid_tariff id from aci_tarif_tbl where ident = ''clc_re'' LIMIT 1 ;
      else
        -- для активной берем пром<750.2кл
        select into vid_tariff id from aci_tarif_tbl where ident = ''clc_ae'' LIMIT 1 ;
      end if;

    else
      vid_tariff:=vmaintariff.id_tariff;
    end if;

    -- самая свежая сумма тарифа
    select into vsumtariff t.id, t.value 
    from acd_tarif_tbl AS t
    where t.id_tarif=vid_tariff
    and t.dt_begin::date = (select max(dt_begin::date)
                            from acd_tarif_tbl 
                            where id_tarif=vid_tariff and dt_begin::date<(pmmgg+''1 month - 1 day''::interval));

    -- как посчитать кВтч по тарифу, чтобы не изменилась сумма ?

    -- кВтч расчитываются с погрешностью. Вроде бы за это не наказывают (устарело)
    -- с мая 2011 требуется арифметическая точность 
    if vsumtariff.value <> 0 then 
      vdemand:= Round(vvalue/vsumtariff.value) ;  
    else 
      vdemand:= 0;
    end if;

    -- пересчет цены от полученных киловат
    if (vdemand <>0 ) then
      vsumtariff_math := Round(vvalue/vdemand,acm_calc_tarif_prec(vdemand));
    else
      vsumtariff_math := vsumtariff.value;
    end if;

    if vpref=''act_ee'' then 

     insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff,id_zonekoef,mmgg)
     values(vid_new,vreg_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (оплата)'',
      vdemand,vvalue,vsumtariff_math,vid_tariff,vsumtariff.id,1,pmmgg);

    end if;

    if vpref=''react_ee'' then 

     insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff,mmgg)
     values(vid_new,vreg_date,''грн'',''2454'',''Плата за перетiкання реактивної електроенергiї (оплата)'',
     1,vvalue,vvalue,vid_tariff,vsumtariff.id,pmmgg);

    end if;

    -- по 2-кратке
    if (vpref=''2kr_d'') then

      insert into acd_tax_tbl(id_doc,dt_bill,unit,text,demand_val,sum_val7,tariff,
      id_tariff,id_sumtariff,mmgg)
      values(vid_new,vreg_date,''шт'',''Пiдвищена плата за споживання електроенергiї понад договiрну величину (оплата).'',
      1,vvalue,vvalue,0,0,pmmgg);
 
    end if;

    return vid_new;
  else
    return 0;
  end if;

  end;
' LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------------------------------------------------------------


--создание сводной НН для неплательщиков НДС 
--drop function acm_createTaxNotPayerDecade(date,int,date,date,int);

create or replace function acm_createTaxNotPayerDecade(date,int,date,date,int) returns int as'
  declare 
     pmmgg        alias for $1;
     pid_pref     alias for $2;
     pstart_date  alias for $3;
     preg_date    alias for $4;
     pdecade      alias for $5;

     vpref        varchar;
     vtarif       record;
     vsummary     record;
     vsummarystr  record;
     vsummarycor  record;

     vreg_num     varchar;
     vnum_end     varchar;
     vint_num     int;

     vid_client   int;
     vid_tax      int;   

     vsumtariff_math numeric;

    demand_all  numeric;
    sum_val_all numeric;

    demand_pkee  numeric;
    sum_val_pkee numeric;

    vstart_date date;

  begin

   if (pmmgg < ''2015-01-01'')  then
     return -2;
   end if;

   vstart_date:= pstart_date;

   if (pmmgg >= ''2015-07-01'')  then -- решили не регистрировать неплательщиков 1 - 2 декаду, всех в одну сводную 3 декады
     if (pdecade <> 3 ) then
       return -2;
     else
       vstart_date:= date_trunc(''month'',pstart_date);
     end if;
   end if;

   Raise Notice ''Налоговая накладная для неплательщиков НДС % % % % %.'', $1, $2, vstart_date, $4, $5;

   vid_client:=getsysvar(''id_abon_taxn'');

   select into vid_tax id_doc from acm_tax_tbl 
    where id_client = vid_client and mmgg = pmmgg and kind_calc = 5 and id_pref = pid_pref and reg_date = preg_date and disabled = 0;

   if found then 
      Raise Notice ''Налоговая накладная для неплательщиков НДС в этом месяце уже сформирована.'';
      return -2;
   end if;

   select into vpref ident from aci_pref_tbl where id=pid_pref;

   --сводная сумма по заголовкам НН
   select into vsummary sum(t.value) as sum_all, sum(t.value_tax) as sum_tax
   from acm_tax_tbl as t 
   join clm_client_tbl as cm on (cm.id = t.id_client)
   left join clm_statecl_h as cp on (cm.id=cp.id_client)
   where t.mmgg=pmmgg and t.reg_date >= vstart_date and t.reg_date <= preg_date
   and coalesce(cp.flag_taxpay,0)=0 
   and cp.id_section not in (205,206,207,208)
   and t.id_pref = pid_pref and t.disabled = 0
   and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) ;


   Raise Notice '' vsummary.sum_all %, vsummary.sum_tax % '',vsummary.sum_all , vsummary.sum_tax;
   if not found then 
     return 0;
   end if;

   -- сумма корректировок 
   select into vsummarycor sum(t.value) as sum_all, sum(t.value_tax) as sum_tax
   from acm_taxcorrection_tbl as t 
--   join acd_taxcorrection_tbl as d on (d.id_doc = t.id_doc)  
   join clm_client_tbl as cm on (cm.id = t.id_client)
   left join clm_statecl_h as cp on (cm.id=cp.id_client)
   where t.mmgg=pmmgg and t.reg_date >= vstart_date and t.reg_date <= preg_date
   and coalesce(cp.flag_taxpay,0)=0 
   and cp.id_section not in (205,206,207,208)
   and t.id_pref = pid_pref
   and t.value <> 0
   and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) ;

   if found then 

     Raise Notice '' vsummarycor.sum_all %, vsummarycor.sum_tax % '',vsummarycor.sum_all , vsummarycor.sum_tax;
  
     vsummary.sum_all:=vsummary.sum_all+coalesce(vsummarycor.sum_all,0);
     vsummary.sum_tax:=vsummary.sum_tax+coalesce(vsummarycor.sum_tax,0);
   end if;


   --сводная сумма по строкам НН
   select into vsummarystr sum(d.demand_val) as demand, sum(d.sum_val7) as sum_val7
   from acm_tax_tbl as t 
   join acd_tax_tbl as d on (d.id_doc = t.id_doc)  
   join clm_client_tbl as cm on (cm.id = t.id_client)
   left join clm_statecl_h as cp on (cm.id=cp.id_client)
   where t.mmgg=pmmgg and t.reg_date >= vstart_date and t.reg_date <= preg_date
   and coalesce(cp.flag_taxpay,0)=0 
   and cp.id_section not in (205,206,207,208)
   and t.id_pref = pid_pref and t.disabled = 0
   and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) ;

   if not found then 
     return 0;
   end if;

   Raise Notice '' vsummarystr.demand %, vsummarystr.sum_val7 % '',vsummarystr.demand , vsummarystr.sum_val7;

   if coalesce(vsummary.sum_tax,0)=0 then 
     return 0;
   end if;


   Raise Notice ''сводная НН для неплательщиков НДС '';      

   select into vnum_end value_ident from syi_sysvars_tbl 
   where ident=''tax_num_ending'';

   vint_num = acm_nexttaxnum(pmmgg);
   vreg_num:=Text(vint_num)||vnum_end;


   insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,int_num,decade)
   values(DEFAULT,pid_pref,5,0,preg_date,vreg_num,vid_client,vsummary.sum_all,vsummary.sum_tax,1,vint_num,pdecade) returning id_doc into vid_tax;


   if (vpref=''react_ee'') then

     insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,mmgg)
     values(vid_tax,preg_date,''грн'',''2454'',''35.12'',''Плата за перетiкання реактивної електроенергiї'',
     1,vsummarystr.sum_val7,vsummarystr.sum_val7,0,0,pmmgg);
 
   end if;

   -- по 2-кратке
   if (vpref=''2kr_d'') then

     insert into acd_tax_tbl(id_doc,dt_bill,unit,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,mmgg)
     values(vid_tax,preg_date,''шт'',''Пiдвищена плата за споживання електроенергiї понад договiрну величину.'',
     1,vsummarystr.sum_val7,vsummarystr.sum_val7, 0,0,pmmgg);
 
   end if;

   --активную енергию разбираем по тарифам
   if (vpref=''act_ee'') then

    demand_all:=0;
    sum_val_all:=0;

    demand_pkee:=0;
    sum_val_pkee:=0;


    for vtarif in 
      select d.id_tariff, d.id_sumtariff, d.id_zonekoef, sum(demand_val) as demand, sum(sum_val7) as sum_val
      from acm_tax_tbl as t 
      join acd_tax_tbl as d on (d.id_doc = t.id_doc)  
      join clm_client_tbl as cm on (cm.id = t.id_client)
      left join clm_statecl_h as cp on (cm.id=cp.id_client)
      where t.mmgg=pmmgg and t.reg_date >= vstart_date and t.reg_date <= preg_date
      and coalesce(cp.flag_taxpay,0)=0 
      and cp.id_section not in (205,206,207,208)
      and t.id_pref = pid_pref and t.disabled = 0
      and t.kind_calc <> 9 
      and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
      group by d.id_tariff, d.id_sumtariff, d.id_zonekoef
      order by d.id_tariff,d.id_zonekoef
    loop

      demand_all:=demand_all+coalesce(vtarif.demand,0);
      sum_val_all:= sum_val_all+coalesce(vtarif.sum_val,0);
/*
      -- пересчет цены
      if (vtarif.demand <>0 ) then
         vsumtariff_math := Round(vtarif.sum_val/vtarif.demand,acm_calc_tarif_prec(vtarif.demand));
      else
         vsumtariff_math := 0;
      end if;
 
      insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,id_zonekoef,mmgg)
      values(vid_tax,preg_date,''кВт.год'',''0415'',''2716000000'',''За активну електроенергiю'',
          vtarif.demand,vtarif.sum_val,vsumtariff_math,vtarif.id_tariff,vtarif.id_sumtariff,vtarif.id_zonekoef,pmmgg);
*/

    end loop;

    -- отдельно строка по актам
    for vtarif in 
      select d.id_tariff, d.id_sumtariff, d.id_zonekoef, sum(demand_val) as demand, sum(sum_val7) as sum_val
      from acm_tax_tbl as t 
      join acd_tax_tbl as d on (d.id_doc = t.id_doc)  
      join clm_client_tbl as cm on (cm.id = t.id_client)
      left join clm_statecl_h as cp on (cm.id=cp.id_client)
      where t.mmgg=pmmgg and t.reg_date >= vstart_date and t.reg_date <= preg_date
      and coalesce(cp.flag_taxpay,0)=0 
      and cp.id_section not in (205,206,207,208)
      and t.id_pref = pid_pref and t.disabled = 0
      and t.kind_calc = 9 
      and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
      group by d.id_tariff, d.id_sumtariff, d.id_zonekoef
      order by d.id_tariff,d.id_zonekoef
    loop

      demand_pkee:=demand_pkee+coalesce(vtarif.demand,0);
      sum_val_pkee:= sum_val_pkee+coalesce(vtarif.sum_val,0);

    end loop;


    --по корректировкам (не нулевым)
    for vtarif in 
      select t.id_doc, d.id, sum(cor_demand) as demand, sum(cor_sum_20) as sum_val
      from acm_taxcorrection_tbl as t 
      join acd_taxcorrection_tbl as d on (d.id_doc = t.id_doc)  
      join clm_client_tbl as cm on (cm.id = t.id_client)
      left join clm_statecl_h as cp on (cm.id=cp.id_client)
      where t.mmgg=pmmgg and t.reg_date >= vstart_date and t.reg_date <= preg_date
      and coalesce(cp.flag_taxpay,0)=0 
      and cp.id_section not in (205,206,207,208)
      and t.id_pref = pid_pref
      and t.value <> 0
      and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
      group by t.id_doc, d.id
      order by t.id_doc, d.id
    loop


      demand_all:=demand_all+coalesce(vtarif.demand,0);
      sum_val_all:= sum_val_all+coalesce(vtarif.sum_val,0);

/*
      -- пересчет цены
      if (vtarif.demand <>0 ) then
         vsumtariff_math := Round(vtarif.sum_val/vtarif.demand,acm_calc_tarif_prec(vtarif.demand));
      else
         vsumtariff_math := 0;
      end if;
 
      insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,id_zonekoef,mmgg)
      values(vid_tax,preg_date,''кВт.год'',''0415'',''2716000000'',''За активну електроенергiю'',
          vtarif.demand,vtarif.sum_val,vsumtariff_math,null,null,null,pmmgg);
*/

    end loop;


    -- пересчет цены
    if (demand_all <>0 ) then
       vsumtariff_math := Round(sum_val_all/demand_all,acm_calc_tarif_prec(demand_all));
    else
       vsumtariff_math := 0;
    end if;
 
    insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,id_zonekoef,mmgg)
    values(vid_tax,preg_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю'',
        demand_all,sum_val_all,vsumtariff_math,null,null,null,pmmgg);


    if sum_val_pkee <> 0 then

      if (demand_pkee <>0 ) then
         vsumtariff_math := Round(sum_val_pkee/demand_pkee,acm_calc_tarif_prec(demand_pkee));
      else
         vsumtariff_math := 0;
      end if;
   
      insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,id_zonekoef,mmgg)
      values(vid_tax,preg_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю акт'',
        demand_pkee,sum_val_pkee,vsumtariff_math,null,null,null,pmmgg);


    end if; 


   end if;

   return vid_tax;
  end;
' LANGUAGE 'plpgsql';



-----------------------------------------------------------------------------

create or replace function acm_rebuildTax2015(int) returns int as'
  declare 

     pid_doc      alias for $1;
     vtax 	  record;

     vreg_date1    date;
     vreg_date2    date;
     vreg_date3    date;
     vdate_start   date;
     vdate_end     date; 

     vmmgg         date; 
     vid_new       int;
     vid           int;
  begin


    select into vtax * from acm_tax_tbl  where id_doc = pid_doc;


    vmmgg:=vtax.mmgg;

    if vmmgg <> fun_mmgg() then
        Raise EXCEPTION ''Нельзя переформировать НН прошлого расчетного периода!'';
    end if;


    select into vreg_date1 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
    --and coalesce(holiday,false) = false 
    and c_date >= vmmgg::date+''9 days''::interval
    order by c_date limit 1; 

    select into vreg_date2 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
    --and coalesce(holiday,false) = false 
    and c_date >= vmmgg::date+''19 days''::interval
    order by c_date limit 1; 

    select into vreg_date3 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
    --and coalesce(holiday,false) = false 
    order by c_date desc limit 1; 


    if vtax.decade = 1 then

      vdate_start = vmmgg;
      vdate_end = vreg_date1;

    end if;


    if vtax.decade = 2 then

      vdate_start = vreg_date1+''1 days''::interval;
      vdate_end = vreg_date2;

    end if;


    if vtax.decade = 3 then

     if (vmmgg < ''2015-08-01'') then
      vdate_start = vreg_date2+''1 days''::interval;
      vdate_end = vreg_date3;
     else
      vdate_start = vmmgg;
      vdate_end = vreg_date3;
     end if;
    end if;


    delete from acm_tax_tbl where id_doc = pid_doc;


    if vtax.kind_calc = 7 then 

      vid_new:= acm_createTaxPayDecade(vtax.id_client, vtax.id_pref, vtax.decade, vmmgg, vdate_start, vdate_end, 1 );

    end if;


    if vtax.kind_calc = 5 then 

      -- Для Славутича и прочих, у кторых нет сводных по декадам, перевыпишем за весь месяц
      if (vdate_start > vmmgg ) then
 
        select into vid id_doc 
        from acm_tax_tbl 
        where id_client = vtax.id_client and kind_calc = 5
        and id_pref=vtax.id_pref and mmgg = vmmgg and decade < vtax.decade limit 1;


        if not found then 
          vdate_start:=vmmgg;
        end if;

      end if;

      vid_new:=acm_createTaxNotPayerDecade(vmmgg,vtax.id_pref,vdate_start, vdate_end, vtax.decade);

    end if;


    if vtax.kind_calc = 2 then 

      vid_new:= acm_createTaxAdvance(vtax.id_client,vtax.id_pref,vmmgg,vtax.reg_date,0); 

    end if;


    if vtax.kind_calc = 1 then 

      vid_new:= acm_createTaxBill(vtax.id_bill,vtax.reg_date); 

    end if;


    if vtax.kind_calc = 3 then 

      vid_new:= acm_createTaxPay(vtax.id_client, vtax.id_pref, vmmgg, vdate_end, 1 );

    end if;


    if vtax.kind_calc = 4 then 

        Raise EXCEPTION ''Нельзя переформировать НН по населению таким способом. Используйте кнопку "Переформировать население"!'';

    end if;


    if (vid_new > 0 ) and (vtax.int_num <>0 ) then 

      update acm_tax_tbl set reg_num = vtax.reg_num, int_num = vtax.int_num where id_doc = vid_new and mmgg = vtax.mmgg; 

    end if;

   return vid_new;
  end;
' LANGUAGE 'plpgsql';


------------------------------------------------------------

create or replace function acm_RebuildTaxDecade(int,int) returns boolean as'
  declare

   pid_client   alias for $1;
   pdecade    alias for $2;
--   pmmgg      alias for $3;

   vreg_date1    date;
   vreg_date2    date;
   vreg_date3    date;
   vdate_start   date;
   vdate_end     date; 

   vmmgg        date; 
   vclient      record;
   vid_pref20   int;
   vid_prefre   int;
   vid_pref0    int;
   vsplit_mode  int;
   v            boolean;
   vint         int;
   vbillpay     record;
   vcnt int;
   vint_num     int;
   vint_num2    int;
  begin


--    if pmmgg <> fun_mmgg() then
--        Raise EXCEPTION ''Нельзя переформировать НН прошлого расчетного периода!'';
--    end if;

    vmmgg:=fun_mmgg();

    if (vmmgg >= ''2015-08-01'') and (pdecade <> 3) then
       return false;
    end if;


    select into vreg_date1 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
--    and coalesce(holiday,false) = false 
    and c_date >= vmmgg::date+''9 days''::interval
    order by c_date limit 1; 


    select into vreg_date2 c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
--    and coalesce(holiday,false) = false 
    and c_date >= vmmgg::date+''19 days''::interval
    order by c_date limit 1; 


    select into vreg_date3 c_date
    from calendar where  date_trunc(''month'', c_date) =  vmmgg  
    --and coalesce(holiday,false) = false 
    order by c_date desc limit 1; 
  
    if pdecade = 1 then

      vdate_start = vmmgg;
      vdate_end = vreg_date1;

    end if;


    if pdecade = 2 then

      vdate_start = vreg_date1+''1 days''::interval;
      vdate_end = vreg_date2;

    end if;


    if pdecade = 3 then

     if (vmmgg < ''2015-08-01'') then
      vdate_start = vreg_date2+''1 days''::interval;
      vdate_end = vreg_date3;
     else
      vdate_start = vmmgg;
      vdate_end = vreg_date3;
     end if;

    end if;


    Raise Notice '' период с % по % mmgg %.'',vdate_start, vdate_end,vmmgg;


    delete from acm_tax_tbl where id_client = pid_client and decade = pdecade and mmgg= vmmgg and coalesce(flag_transmis,0) = 0 and disabled = 0;


    if (pid_client=getsysvar(''id_abon_taxn'')) then

      vint:=acm_createTaxNotPayerDecade(vmmgg,10,vdate_start, vdate_end, pdecade);
      vint:=acm_createTaxNotPayerDecade(vmmgg,20,vdate_start, vdate_end, pdecade);

    else

      -- по оплатам за декаду

      if pdecade in (1,2) then
  
        for vclient in 
         select cm.id,cm.code,cp.flag_budjet, p.id_pref, sum(p.value) as value, sum(p.value_tax) as value_tax   
  
         from clm_client_tbl as cm 
         join clm_statecl_h as cp on (cp.id_client=cm.id)
         join acm_pay_tbl  as p on (p.id_client = cm.id)
         where cm.book = -1  
         and cm.id = pid_client
         and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= vmmgg ) 
         and cm.idk_work = 1
         and cp.id_section not in (206,207,205,208)  
         and p.reg_date >= vdate_start and p.reg_date <= vdate_end and p.mmgg = vmmgg
         and p.idk_doc = 100
         and p.sign_pay = 1
         and p.id_pref in (10,20,520)
         and (p.value <>0 or p.value_tax <>0 )
         group by cm.id,cm.code,cp.flag_budjet, p.id_pref
         order by p.id_pref, cm.code 
        loop

          Raise Notice '' оплата - абонент % вид %. code %'',vclient.id,vclient.id_pref,vclient.code;

          vint:= acm_createTaxPayDecade(vclient.id, vclient.id_pref, pdecade, vmmgg, vdate_start, vdate_end, 0 );
    
        end loop;

      end if; 



      -- третья декада - закрытие месяца практически по старому алгоритму,
      -- оплаты первых декад воспринимаем как авансы
      if pdecade = 3 then

        perform seb_all(0,vmmgg);

        update seb_obrs_tmp set b_dtval=0,b_ktval=b_ktval-b_dtval,
                    b_dtval_tax=0,b_ktval_tax=b_ktval_tax-b_dtval_tax
               where b_dtval<0;

        update seb_obrs_tmp set e_dtval=0,e_ktval=e_ktval-e_dtval,
                    e_dtval_tax=0,e_ktval_tax=e_ktval_tax-e_dtval_tax
             where e_dtval<0;


       -- активная
        for vclient in 
         select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv, cm.code
         from clm_client_tbl as cm 
         join clm_statecl_h as cp on (cp.id_client=cm.id)
         join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
         where cm.book = -1  and s.id_pref = 10 
         and cm.id = pid_client
         and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= vmmgg ) 
         and cm.idk_work = 1
         and cp.id_section not in (206,207,205,208)  
         order by s.id_pref, cm.code
        loop

          Raise Notice '' абонент % (%) вид %.'',vclient.code,vclient.id, vclient.id_pref;

         if (vclient.flag_budjet=0) then

          vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date3);

         end if;

         -- все бюджетники
         if (vclient.flag_budjet=1) then

          vint:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date3,0);

         end if;
     
         -- есть кредитовое сальдо на конец месяца
         if  (vclient.kr_zkme <> 0) then

          vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date3,1);

         end if;

        end loop;
      -----------------------------------------------------------------------------
  
        --реактив
        for vclient in 
         select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv, cm.code
         from clm_client_tbl as cm 
         join clm_statecl_h as cp on (cp.id_client=cm.id)
         join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
         where cm.book = -1 
         and cm.id = pid_client
         and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= vmmgg ) 
         and cm.idk_work = 1 and s.id_pref = 20
         and cp.id_section not in (206,207,205,208)  
         order by s.id_pref, cm.code
        loop
   
          Raise Notice '' абонент % (%) вид %.'',vclient.code,vclient.id, vclient.id_pref;

         if (vclient.flag_budjet=0) then

          vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date3);

         end if;

         -- все бюджетники
         if (vclient.flag_budjet=1) then

          vint:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date3,0);

         end if;

         -- есть кредитовое сальдо на конец месяца
         if  (vclient.kr_zkme <> 0) then

          vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date3,1);

         end if;

        end loop;

      end if;


    end if ;

    select into vint_num coalesce(max(int_num),0) from acm_tax_tbl where mmgg=vmmgg and disabled = 0; 
    select into vint_num2 coalesce(max(int_num),0) from acm_taxcorrection_tbl where mmgg=vmmgg; 


    if vint_num<vint_num2 then
       vint_num:=vint_num2;
    end if;

    update syi_sysvars_tbl set value_ident= text(vint_num+1)::varchar  where ident=''last_tax_num'';

    return true;
  end;
' LANGUAGE 'plpgsql';



create or replace function acm_CopyToNotPayer(int) returns int as'
  declare 

     pid_doc      alias for $1;
     vtax 	  record;

     vreg_date1    date;
     vreg_date2    date;
     vreg_date3    date;
     vdate_start   date;
     vdate_end     date; 

     vmmgg         date; 
     vid_new       int;
     vid           int;
     vid_client    int;

     vreg_num     varchar;
     vnum_end     varchar;
     vint_num     int;

  begin


    select into vtax * from acm_tax_tbl  where id_doc = pid_doc;


    vmmgg:=vtax.mmgg;

    if vmmgg <> fun_mmgg() then
        Raise EXCEPTION ''Нельзя использовать НН прошлого расчетного периода!'';
    end if;
 
    vid_client:=getsysvar(''id_abon_taxn'');


    Raise Notice ''сводная НН для неплательщиков НДС '';      

    select into vnum_end value_ident from syi_sysvars_tbl 
    where ident=''tax_num_ending'';

    vint_num = acm_nexttaxnum(vmmgg);
    vreg_num:=Text(vint_num)||vnum_end;
  
    insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,int_num,decade)
    values(DEFAULT,vtax.id_pref,5,0,vtax.reg_date,vreg_num,vid_client,vtax.value,vtax.value_tax,1,vint_num,vtax.decade) returning id_doc into vid_new;

    insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff,id_zonekoef,mmgg)
    select vid_new, t.dt_bill,t.unit,t.unit_kod,t.uktzed,t.text,t.demand_val,t.sum_val7,t.tariff, t.id_tariff,t.id_sumtariff,t.id_zonekoef,t.mmgg
    from acd_tax_tbl as t where id_doc = pid_doc;


   return vid_new;
  end;
' LANGUAGE 'plpgsql';
