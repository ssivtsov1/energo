;
set client_encoding = 'win';


create or replace function acm_calc_tarif_prec(numeric) returns int as ' 
  declare 
     pdemand alias for $1;
begin

  if pdemand >= 5000000 then
     return 10;
  end if;

  if pdemand >= 500000 then
     return 9;
  end if;

  if pdemand >= 50000 then
     return 8;
  end if;

  if pdemand >= 5000 then
     return 7;
  end if;

  if pdemand >= 500 then
     return 6;
  end if;

  if pdemand >= 50 then
     return 5;
  end if;

  return 4;

  end;
' LANGUAGE 'plpgsql';

--
-- Учет НН для небюджетных организаций (по первому событию) 
-- 
-- Отчетный период = 1 месяц.
-- Каждый месяц может быть выписа 1 НН на счет, 1 НН на аванс и несколько корректировок
-- При формировании счета автоматически выполняется проверка на наличие аванса 
-- и необходимость формирования корректировки.
-- Суть корректировок в переброске сумм аванса с тарифа, использованного
-- в НН на аванс в прошлом месяце на тарифы из счета. 
-- При этом общая сумма не меняется, меняется  количество кВтч.
-- После формирования счета до конца месяца по нему должна быть выписана НН (в ручную)
-- Перед закрытием месяца необходимо проверить наличие авансовых платежей
-- и выписать НН на них.
------------------------------------------------------------------------


--создание НН на аванс 
-- Выписываем НН на сумму оплаты ,проплаченной в этом месяце 
-- превышающую сумму выставленных счетов 
-- используется тариф, по которому за последние 3 месяца данным абонентом потреблено
-- наибольшее количество кВтч
-- Формируется в конце месяца 1 раз
drop function acm_createTaxAdvance(int,int,date,date,int);

create or replace function acm_createTaxAdvance(int,int,date,date,int) returns int as'
  declare 
     pid_client   alias for $1;
     pid_pref     alias for $2;
     pmmgg        alias for $3;
     preg_date    alias for $4;
     psilent      alias for $5;
--     psplit       alias for $6;

     vsaldo       record;
     vktsaldo     record;
     vktmove      record;
     vktsaldo_old record;
     vpay         record;
     vbill        record;
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
     vint_num     int;
--     vbudjet      int;
     vstcl        record;
     vsumtariff_math numeric;
     vlimit numeric;

     vvalue_all	  numeric(14,4);
     vvalue_tax_all   numeric(14,4);

     vid_new      int;
     vavans_curmmgg record;
     vreg_date2 date;
  begin


  if pmmgg < ''2015-01-01''::date then
     return 0;
  end if;

  select into vpref ident from aci_pref_tbl where id=pid_pref;

  select into vid_tax id_doc from acm_tax_tbl 
  where id_client = pid_client and mmgg = pmmgg and kind_calc = 2 and id_pref = pid_pref and disabled=0;
 
  if found then 
--      Raise EXCEPTION ''Налоговая накладная на аванс для абонента % в этом месяце уже сформирована.'',pid_client;
      Raise Notice ''Налоговая накладная на аванс для абонента % в этом месяце уже сформирована.'',pid_client;
      return 0;
  end if;


  Raise Notice ''Налоговая накладная на аванс для абонента % '',pid_client;
  ------------------------------------------------------------------

  -- режим psilent = 0 для переформирования НН из программы
  if psilent = 0 then 

     perform seb_one( pmmgg ,0 ,pid_client );

  end if;

  select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h where id_client = pid_client and mmgg_b <= pmmgg order by mmgg_b desc limit 1;

  select into vktsaldo coalesce(sum(b_kred),0) as bkt, coalesce(sum(b_kred_tax),0) as bkt_pdv ,
  coalesce(sum(e_kred),0) as ekt, coalesce(sum(e_kred_tax),0) as ekt_pdv,
  coalesce(sum(kr_zpme),0) as bkt_all,  coalesce(sum(kr_zpmpdv),0) as bkt_pdv_all
  from seb_obr_all_tmp 
  where id_client=pid_client and id_pref=pid_pref ;

  Raise Notice '' кредит нач %'',vktsaldo.bkt_all;  
  Raise Notice '' кредит кон %'',vktsaldo.ekt;  

--  select into vktsaldo_old coalesce(sum(b_ktval),0) as bkt, coalesce(sum(b_ktval_tax),0) as bkt_pdv 
--  from seb_obrs_tmp 
--  where id_client=pid_client and id_pref=pid_pref and date_part(''year'',hmmgg)=2005;

/*
  select into vktmove coalesce(sum(p.value),0) as value ,coalesce(sum(p.value_tax),0) as value_tax 
  from  acm_pay_tbl as p 
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg_pay = pmmgg and p.value_pay>0
  and  exists (select id_doc from acm_pay_tbl as p2 where p2.mmgg = p.mmgg and p.id_pref =p2.id_pref
     and p2.id_client = p.id_client and (date_part(''year'',p2.mmgg_pay) < date_part(''year'',p.mmgg_pay)) and p2.value_pay=-p.value_pay  ) ;


  if (vktmove.value > 0) then 
    Raise Notice '' !!!!-> перенос кредита  %'',vktmove.value;  

    vktsaldo.bkt :=vktsaldo.bkt+numeric_smaller(vktmove.value,vktsaldo_old.bkt);
    vktsaldo.bkt_pdv :=vktsaldo.bkt_pdv+numeric_smaller(vktmove.value_tax,vktsaldo_old.bkt_pdv);

--    vktsaldo.bkt :=vktsaldo.bkt+vktmove.value;
--    vktsaldo.bkt_pdv :=vktsaldo.bkt_pdv+vktmove.value_tax;

  end if;

*/
  if (pmmgg < ''2015-08-01'') then

    -- нужно брать только платежи 3 декады, остальное ушло в аванс
    select into vreg_date2 c_date
    from calendar where  date_trunc(''month'', c_date) = pmmgg  
    and c_date >= pmmgg::date+''19 days''::interval
    order by c_date limit 1; 

  else
    -- с августа 2015 1-2 декады отменены, все идет по концу месяца
    vreg_date2 := (pmmgg::date - ''1 days''::interval)::date ;
  end if;


  --платежки тоже нужны только идущие на оплату текущего года (перенос кредита исключаем, он не является реальным платежом) 
  select into vpay numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
  from acm_pay_tbl as p
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg and p.reg_date > vreg_date2
  --p.value_pay>0 and
  and date_part(''year'',p.mmgg_pay)=date_part(''year'',pmmgg);
--  and not exists (select id_doc from acm_pay_tbl as p2 where p2.mmgg = p.mmgg and p.id_pref =p2.id_pref and 
--          p2.id_client = p.id_client and (date_part(''year'',p2.mmgg_pay) < date_part(''year'',p.mmgg_pay)) and p2.value_pay=-p.value_pay ) ;

/*
  -- снять сумму, на которые выписаны НН в 1 и 2 декаде.
  select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
     from acm_tax_tbl as v 
     where v.id_client = pid_client and v.kind_calc = 7
     and v.id_pref=pid_pref and v.mmgg = pmmgg and v.reg_date < preg_date;

  if vavans_curmmgg.value>0 then
     Raise Notice ''+current month avans % '',vavans_curmmgg.value; 

     vpay.pay := numeric_larger(vpay.pay - vavans_curmmgg.value,0);
     vpay.pay_pdv := numeric_larger(vpay.pay_pdv - vavans_curmmgg.value_tax,0);

  end if;
*/


  Raise Notice '' оплата  %'',vpay.pay;  

  select into vbill 
  coalesce(sum( case when value > 0 then value else 0 end ),0) as val,
  coalesce(sum( case when value_tax > 0 then value_tax else 0 end ),0) as tax,
  coalesce(sum( case when value < 0 then -value else 0 end ),0) as val_neg,
  coalesce(sum( case when value_tax < 0 then -value_tax else 0 end ),0) as tax_neg
  from acm_bill_tbl 
  where id_client=pid_client and id_pref=pid_pref and mmgg = pmmgg and 
  date_part(''year'',mmgg_bill)=date_part(''year'',pmmgg);

  Raise Notice '' bill  %'',vbill.val;  

   if vktsaldo.ekt <=0 then --нет кредитового сальдо на конец месяца

    if psilent = 0 then 
       Raise notice ''Нет аванса в %.'',pmmgg;
    end if;

    return 0;
   else

    if vktsaldo.bkt <=0 then --нет кредитового сальдо на начало месяца

--     vvalue:=vktsaldo.ekt;         -- аванс на сумму кредитового сальдо на конец
--     vvalue_tax:=vktsaldo.ekt_pdv;  -- т.к. оно все появилось в этом месяце

        vvalue:=numeric_smaller(vpay.pay,vktsaldo.ekt);        
        vvalue_tax:=numeric_smaller(vpay.pay_pdv,vktsaldo.ekt_pdv);     

    else

     if (vktsaldo.bkt_all<(vbill.val-vbill.val_neg)) then -- сумма всех счетов больше кредитового сальдо на начало
--       vvalue:=vktsaldo.ekt;             --значит счета поглотили всю переплату из прошлого месяца 
--       vvalue_tax:=vktsaldo.ekt_pdv;      --и вся переплата на конец текущего мес. появилась в этом месяце

        vvalue:=numeric_smaller(vpay.pay,vktsaldo.ekt);        
        vvalue_tax:=numeric_smaller(vpay.pay_pdv,vktsaldo.ekt_pdv);     

     else

       if (vstcl.flag_budjet =1 ) then
        vvalue:=numeric_smaller(vpay.pay,vktsaldo.ekt);        -- счета поглотили не всю предоплату прошлого месяца, сумма не может быть больше кредита на конец
        vvalue_tax:=numeric_smaller(vpay.pay_pdv,vktsaldo.ekt_pdv);     -- сальдо на конец = текущая оплата + остаток предоплаты прошлого
       else 
              -- Отрицательные счета работают как оплата только для небюджетников

        -- 07.04.2011
        -- минусовой счет может увеличивать кредит, только если сумма "-" больше суммы "+" счетов в месяце
        if  vbill.val_neg > vbill.val then

          vvalue:=numeric_smaller(vpay.pay+(vbill.val_neg-vbill.val),vktsaldo.ekt);        -- счета поглотили не всю предоплату прошлого месяца, сумма не может быть больше кредита на конец
          vvalue_tax:=numeric_smaller(vpay.pay_pdv+(vbill.tax_neg-vbill.tax),vktsaldo.ekt_pdv);     -- сальдо на конец = текущая оплата + остаток предоплаты прошлого

        else 

          vvalue:=numeric_smaller(vpay.pay,vktsaldo.ekt);        -- счета поглотили не всю предоплату прошлого месяца, сумма не может быть больше кредита на конец
          vvalue_tax:=numeric_smaller(vpay.pay_pdv,vktsaldo.ekt_pdv);     -- сальдо на конец = текущая оплата + остаток предоплаты прошлого
        end if;

       end if;

     end if;

    end if;

    if vvalue = 0 then 

      if psilent = 0 then 
         Raise notice ''Нет аванса в %.'',pmmgg;
      end if;

      return 0;
    end if;

    select into vnum_end value_ident from syi_sysvars_tbl 
    where ident=''tax_num_ending'';

    vreg_date:=preg_date;


    vvalue_all	:=vvalue;
    vvalue_tax_all := vvalue_tax;


--   LOOP -- сумма ндс не должна превышать лимит - иначе нужно выписывать несколько НН

    -- с марта 2013 года неплатникам налоговая выписывается без номера
    if coalesce(vstcl.flag_taxpay,0)=0  then
      vint_num = 0;
      vreg_num:=''''; 
    else
      vint_num = acm_nexttaxnum(pmmgg);
      vreg_num:=Text(vint_num)||vnum_end; 
    end if;

/*
    if (( round(vvalue_all/5,2) > vlimit ) or ( vvalue_tax_all > vlimit )) and (coalesce(vstcl.flag_taxpay,0)=1) and (psplit = 1)
         --and (getsysvar(''tax_div'')=1) 
    then 

      vvalue:= vlimit*5;
      vvalue_tax := vlimit;

      Raise Notice ''Split mode on '';
    else

     vvalue:= vvalue_all;
     vvalue_tax := vvalue_tax_all;

     Raise Notice ''Split mode off '';

    end if;
*/

--   vvalue:= vvalue_all;
--   vvalue_tax := vvalue_tax_all;

    --заголовок
    insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,int_num,auto,mmgg,decade)
    values(DEFAULT, pid_pref,2,0,preg_date,vreg_num,pid_client,vvalue,vvalue_tax,vint_num,1,pmmgg,3) returning id_doc into vid_new;

--    vvalue_all	:= vvalue_all - vvalue;
--    vvalue_tax_all    := vvalue_tax_all - vvalue_tax;


    -- строка
    
    --как найти тариф для аванса
    -- берем тариф, по которому данный абонент потребил больше всего кВтч 
    -- за последние 3 месяца
    select into vmaintariff sum(bs.demand_val) as max_demand,bs.id_tariff
    from acm_bill_tbl as b left join acd_billsum_tbl as bs using (id_doc)
    where b.id_client=pid_client and (b.mmgg::date)<=(pmmgg::date) and (b.mmgg::date)>=(pmmgg-''3 month''::interval)::date
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

--    vid_tariff:=22;
--    vid_sumtariff=28;

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

    -- медок не пропускает количество=0, ставим минимум 1
    if (vvalue<> 0) and (vdemand =0) then
      vdemand:=1;
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
     values( vid_new, vreg_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (аванс)'',
       vdemand,vvalue,vsumtariff_math,vid_tariff,vsumtariff.id,1,pmmgg);

    end if;

    if vpref=''react_ee'' then 

     insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,text,demand_val,sum_val7,tariff,
       id_tariff,id_sumtariff,mmgg)
     values( vid_new,vreg_date,''грн'',''2454'',''Плата за перетiкання реактивної електроенергiї (аванс)'',
       1,vvalue,vvalue,vid_tariff,vsumtariff.id,pmmgg);

    end if;

/*
    -- по 2-кратке
    if (vpref=''2kr_d'') then

      insert into acd_tax_tbl(id_doc,dt_bill,unit,text,demand_val,sum_val7,tariff,
      id_tariff,id_sumtariff,mmgg)
      values( vid_new, vreg_date,''шт'',''Пiдвищена плата за споживання електроенергiї понад договiрну величину (аванс).'',
      1,vvalue,vvalue,0,0,pmmgg);
 
    end if;
*/
    --EXIT WHEN ((vvalue_tax_all=0) and (vvalue_all=0));

--   END LOOP;

   end if;

  return vid_new;
  end;
' LANGUAGE 'plpgsql';

----------------------------------------------------------------------------------------
--корректировка авансов при создании счета 
-- если была выписана НН на аванс в прошлом месяце, при выписке счета
-- который оплачивается этим авансом необходима корректировка
-- если сумма тарифа в НН на аванс отличается от суммы тарифа по счету
-- на 1 НН аванса выписывается 1 корректировка
-- 1 счет может пораждать несколько документов-корректировок
-- используется также для бюджетников
-----------------------------------------------------------------------------------------
--drop function acm_createTaxCorrect(int,date); 

create or replace function acm_createTaxCorrect(int,date) returns boolean as'
  declare 
     pid_bill   alias for $1;
     pdt        alias for $2;
     vbill      record;
     vsaldo     record;
     vadvance   record;
     v_ok       record;
     vbillstr   record;
     vktsaldo record;
     vktsaldo_old record;
     vktmove record;
     vcorrect   numeric(14,4);
     vbillforcorrect numeric(14,4);
     vcorrect_cur numeric(14,4);
     vsum_ok  numeric(14,4);
     vdemand_ok int;
     vreg_num varchar; 
     vcorrect_billstr numeric(14,4);
     vtariff numeric(14,4);
     vnum_end varchar;
     vpref    varchar;
     vint_num int;
     vlastnum int;
     v_cor_created boolean;
     vprevbill record;
     vold_kor  record;
     vmmgg date;
     vreg_date date;
     vcorrect_pdv numeric(14,2);
     vcorrect_sum numeric(14,2);
     vavans_curmmgg numeric(14,2);
     vrescod int;
     vstcl        record;
     vid_new      int;
     vdemand_str  int; 
     vid_sumtariff int;
  begin

  select into vbill id_pref,mmgg as mmgg,mmgg_bill,id_client,value,value_tax,reg_date, idk_doc,dt 
  from acm_bill_tbl where id_doc =pid_bill;

  if not found then 
      Raise EXCEPTION ''Не найден счет.'';
      return false;    --не найден счет
  end if;

  if (vbill.idk_doc<>200) and (vbill.idk_doc<>204) and (vbill.idk_doc<>205) then 
      Raise Notice ''Неподходящий тип счета для корректировки НН на аванс.'';
      return false;     
  end if;

  select into vpref ident from aci_pref_tbl where id=vbill.id_pref;

  --по реактиву не выписываем
  if (vpref=''react_ee'') then 
      return false;     
  end if;

  v_cor_created :=false;
  vrescod:= getsysvar(''kod_res'') ;


  vmmgg := fun_mmgg();
  select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h where id_client = vbill.id_client and mmgg_b <= vmmgg order by mmgg_b desc limit 1;

  Raise Notice '' - - - - acm_createTaxCorrect - - - - - '';

  delete from act_taxkornums_tbl;

  insert into act_taxkornums_tbl 
  select id_doc,id_tax,id_bill,reg_num,reg_date,int_num 
  from acm_taxcorrection_tbl where id_bill = pid_bill and mmgg = vmmgg;


  delete from acm_taxcorrection_tbl where id_bill = pid_bill and mmgg = vmmgg;


  select into vprevbill coalesce(sum(value),0) as val, coalesce(sum(value_tax),0) as val_tax 
  from acm_bill_tbl 
  where id_client=vbill.id_client and id_pref=vbill.id_pref and mmgg = vbill.mmgg and dt<vbill.dt and value >0;

  Raise Notice ''vprevbill tax %'',vprevbill.val_tax;

  --//-//-//
  select into vktsaldo CASE WHEN c.order_pay =0 THEN coalesce(ss.kr_zkme,0) ELSE coalesce(ss.e_kred,0) END as bkt, 
                       CASE WHEN c.order_pay =0 THEN coalesce(ss.kr_zkmpdv,0) ELSE coalesce(ss.e_kred_tax,0) END as bkt_pdv,
  coalesce(-ss.deb_kme,0) as bdt,   coalesce(-ss.deb_kmpdv,0) as bdt_pdv 
  from seb_obr_all_tbl as ss
  join clm_client_tbl as c on (c.id = ss.id_client)
  where ss.id_client=vbill.id_client and ss.id_pref=vbill.id_pref and ss.mmgg = vbill.mmgg - ''1 month''::interval;

  vktsaldo.bkt:= numeric_larger(vktsaldo.bkt - vprevbill.val,0);
  vktsaldo.bkt_pdv:= numeric_larger(vktsaldo.bkt_pdv - vprevbill.val_tax,0); -- не используется

-------------------------------------------------------

  -- авансовые НН за текущий период, выписанные вручную в начале месяца на текущую оплату
--  select into vavans_curmmgg coalesce(sum(sum_rest),0) from acv_taxadvtariff as v 
--     where v.id_client = vbill.id_client 
--     and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < pdt;

  select into vavans_curmmgg coalesce(sum(value),0) as value 
  from ( 
     select value, value_tax
     from acm_tax_tbl as v 
     where v.id_client = vbill.id_client and v.kind_calc = 7
     and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < pdt and disabled=0
	union all
     select value, value_tax
     from acm_taxcorrection_tbl as v 
     where v.id_client = vbill.id_client 
     and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < pdt
    ) as ss;


  if vavans_curmmgg>0 then
     Raise Notice ''+current month avans % '',vavans_curmmgg; 
     Raise Notice ''+current month dt % '',vktsaldo.bdt; 

     vavans_curmmgg:=numeric_larger(vavans_curmmgg-coalesce(vktsaldo.bdt,0),0);

  end if;


  if coalesce(vktsaldo.bkt,0)+coalesce(vavans_curmmgg,0) >0 then --есть кредитовое сальдо на начало месяца
   -- может быть необходима корректировка 

   vcorrect:=coalesce(vktsaldo.bkt,0)+coalesce(vavans_curmmgg,0);

   vbillforcorrect:=numeric_smaller(vbill.value,vcorrect);

   Raise Notice ''Корректировка на сумму %'',vcorrect;

   --удалить информацию о погашении данным счетом авансов (она будет переформирована)
   delete from acm_taxadvcor_tbl where id_bill = pid_bill;
   --удалить информацию о использовании строк данного счета корректировкой
   delete from acm_billtax_tbl where id_doc=pid_bill and source = 1;

   -- выбираем непогашенные авансы прошлых периодов
   for vadvance in  select v.*,  t.value, t.value_tax
     from acv_taxadvtariff as v 
     join acm_tax_tbl as t on (t.id_doc = v.id_doc)
     where v.id_client = vbill.id_client 
     and v.id_pref=vbill.id_pref 
     and v.mmgg >=''2010-01-01'' 
     and (((v.mmgg < vbill.mmgg) and (vktsaldo.bkt >0 )) or ( (v.mmgg = vbill.mmgg) and (v.reg_date < pdt) and (vavans_curmmgg >0)))
   loop 
    -- по каждой НН на аванс отдельная корректировка
    vcorrect_cur:=numeric_smaller(vbillforcorrect,vadvance.sum_rest);
    select into vtariff value from acd_tarif_tbl where id = vadvance.id_sumtariff;

    Raise Notice ''Обнаружен аванс  %'',vadvance.reg_num;
    Raise Notice ''На сумму %'',vcorrect_cur;
    Raise Notice ''По тарифу  %'',vtariff;

    exit when vcorrect_cur=0;       -- если сумма счета < аванса, будет досрочный выход

    vbillforcorrect:=numeric_larger(vbillforcorrect-vcorrect_cur,0);


    -- проверить на совпадение суммы тарифа аванса и счета
    -- только 0 зона (другие ясно что не совпадут)
    select into v_ok coalesce(sum(bs.sumval)-coalesce(sum(bt.sum_val),0),0) as sum_rest
    from  
       (select sum(b.sum_val) as sumval, b.id_doc ,t.value as tariff
       from acd_billsum_tbl as b 
       join acd_tarif_tbl as t on (b.id_sumtariff = t.id) 
       where b.id_doc =pid_bill 
       --and id_sumtariff=vadvance.id_sumtariff
       and t.value = vtariff and b.id_zone = 0
       group by b.id_doc,tariff) as bs 
--    left outer join acm_billtax_tbl as bt  using(id_doc,tariff);
    left outer join ( select id_doc,tariff, sum(sum_val) as sum_val from acm_billtax_tbl where id_doc =pid_bill group by id_doc,tariff) as bt
     using(id_doc,tariff);


    Raise Notice '' v_ok.sum_rest % '',v_ok.sum_rest; 

    if not found then
     vsum_ok:=0;
     Raise Notice ''Совпадения тарифов нет''; 
    else
     vsum_ok:=numeric_smaller(v_ok.sum_rest,vcorrect_cur);
    end if;

    vdemand_ok:=Round(vsum_ok/vtariff);

    if vsum_ok<>0 then --совпадение есть 

     Raise Notice ''Совпадает тариф  %'',vtariff;
     Raise Notice ''на сумму  %'',vsum_ok;

     -- запишем сумму совпадения в таблицу тарифов
     insert into acm_billtax_tbl(id_doc,id_sumtariff,tariff,sum_val,demand_val,source,zone_koef,id_zonekoef)
     values(pid_bill,vadvance.id_sumtariff,vtariff,vsum_ok,vdemand_ok,1,1,1);

     -- запишем погашение аванса на сумму совпадения 
     insert into acm_taxadvcor_tbl(id_pref,id_advance,id_correction,id_bill,sum_val)
     values(vbill.id_pref,vadvance.id_doc,NULL,pid_bill,vsum_ok);

    end if;

    if vsum_ok<vcorrect_cur then -- не все совпало 
     -- придется таки создавать НН корректировки
     v_cor_created:=true;

     vcorrect_cur:=vcorrect_cur-vsum_ok;

     Raise Notice ''Совпадения не достаточно, осталось %'',vcorrect_cur; 
     --если это переформирование, ставим старые номера корректировок
     select into vold_kor * from act_taxkornums_tbl where id_bill = pid_bill and id_tax = vadvance.id_doc;

     if found then 

        vreg_num :=vold_kor.reg_num;
        vreg_date:=vold_kor.reg_date;
        vint_num :=vold_kor.int_num;

        raise notice ''____ vreg_num ..............  %'', vreg_num;                                                       
     else

        select into vnum_end value_ident  from syi_sysvars_tbl 
        where ident=''tax_num_ending'';

        raise notice ''vadvance.reg_num ...............  %'', vadvance.reg_num;                                                       
        raise notice ''vnum_end ...............  %'', vnum_end;                                                       


        if (coalesce(vstcl.flag_taxpay,0) = 0) or ((vmmgg>=''2015-02-01''::date) and (vadvance.reg_date <''2015-01-01''::date ) ) then
          vint_num = 0;
          vreg_num:=''''; 
        else
          vint_num = acm_nexttaxnum(vmmgg);
          vreg_num:=Text(vint_num)||vnum_end; 
        end if;

        vreg_date:=pdt;

     end if;

     --заголовок
     insert into acm_taxcorrection_tbl(id_doc,id_pref,reg_num,reg_date,id_client,id_tax,id_bill,value,value_tax,reason,tax_num, tax_date,kind_calc,int_num)
     values(default,vbill.id_pref,vreg_num,vreg_date,vbill.id_client,vadvance.id_doc,pid_bill, 0,0,''Змiна вартiсних показникiв'',vadvance.reg_num, vadvance.reg_date,0,vint_num)
       returning id_doc into vid_new;

     -- погашение аванса на сумму выпиываемой корректировки
     insert into acm_taxadvcor_tbl(id_pref,id_advance,id_correction,id_bill,sum_val)
     values(vbill.id_pref,vadvance.id_doc,vid_new,pid_bill,vcorrect_cur);


     vcorrect_sum:=vcorrect_cur;
     vcorrect_pdv:=0;

     for vbillstr in 
      select  bs.sumval-coalesce(sum(bt.sum_val),0) as sum_rest,
      bs.id_tariff,bs.id_sumtariff,bs.zone_koef,bs.id_zonekoef
      from 
      (select sum(sum_val) as sumval, max(b.id_tariff) as id_tariff, max(b.id_sumtariff) as id_sumtariff, 
       b.id_doc,b.id_zonekoef, coalesce(dz.koef,1) as zone_koef ,round(t.value*coalesce(dz.koef,1),4) as tariff
       from acd_billsum_tbl as b
       left join acd_tarif_tbl as t on (b.id_sumtariff = t.id) 
       left join acd_zone_tbl as dz on (b.id_zonekoef = dz.id)
       where b.id_doc =pid_bill and t.value*coalesce(dz.koef,1) <> vtariff
       group by b.id_doc,tariff,b.id_zonekoef,zone_koef) as bs 
      left join acm_billtax_tbl as bt 
      using(id_doc,tariff,zone_koef,id_zonekoef)
      group by bs.id_doc,bs.id_sumtariff,bs.id_tariff,bs.sumval,bs.zone_koef,bs.id_zonekoef
      having bs.sumval-coalesce(sum(bt.sum_val),0) >0
     loop

      vcorrect_billstr:=numeric_smaller(vbillstr.sum_rest,vcorrect_cur);
      vcorrect_cur:=vcorrect_cur-vcorrect_billstr;

      -- данный аванс погашен
      exit when vcorrect_billstr=0;

       select into vtariff round(value*vbillstr.zone_koef,4) from acd_tarif_tbl where id = vbillstr.id_sumtariff;
       vid_sumtariff:=vbillstr.id_sumtariff;

       Raise Notice ''Погашение тарифом %'',vtariff;
       Raise Notice ''Зонный коеф. %'',vbillstr.zone_koef;
       Raise Notice ''на сумму  %'',vcorrect_billstr;
      
      -- зафиксировать использование тарифа текущей сроки
      insert into acm_billtax_tbl(id_doc,id_tax,id_sumtariff,tariff,sum_val,demand_val,source,zone_koef,id_zonekoef)
      values(pid_bill,vid_new,vid_sumtariff,vtariff, vcorrect_billstr,round(vcorrect_billstr/vtariff),1,vbillstr.zone_koef,vbillstr.id_zonekoef);

      -- строка (+) по тарифу  текущей строки счета

      vcorrect_pdv:=vcorrect_pdv+Round(vcorrect_billstr*0.2,2);

      vdemand_str:=round(vcorrect_billstr/vtariff);

      if ((vdemand_str=0) and (vcorrect_billstr<>0)) then
        vdemand_str:=1;
        vtariff:= vcorrect_billstr;
      end if;


      insert into acd_taxcorrection_tbl(id_doc,unit,unit_kod,uktzed,tariff,id_tariff,id_sumtariff,
        cor_demand,cor_sum_20,cor_sum_0,cor_sum_free,cor_tax,cor_tax_credit,mmgg)
      values(vid_new,''кВт·год'',''0415'',''2716000000'',vtariff,vbillstr.id_tariff,vid_sumtariff,
        vdemand_str ,vcorrect_billstr,0,0,Round(vcorrect_billstr*0.2,2),Round(vcorrect_billstr*0.2,2),vbill.mmgg);

     end loop;

     if (vcorrect_sum = vadvance.value) and (vcorrect_pdv <> vadvance.value_tax ) then
        --если в корректировку идет аванс целиком, надо чтобы НДС в + и - строках совпадал с НДС аванса
        update acd_taxcorrection_tbl set cor_tax = cor_tax - (vcorrect_pdv - vadvance.value_tax), 
					 cor_tax_credit = cor_tax_credit - (vcorrect_pdv - vadvance.value_tax) 
        where id = currval(''acd_taxcorrection_seq'');

        Raise Notice '' ++  Pdv correcting!!! ++ '';
        Raise Notice '' ++ All avans pdv % '',vadvance.value_tax;
        Raise Notice '' ++ Calculated pdv % '',vcorrect_pdv;

        vcorrect_pdv := vadvance.value_tax;

     end if;


     vdemand_str:=round(vcorrect_sum/vadvance.tariff);
     vtariff:= vadvance.tariff;

     if ((vdemand_str=0) and (vcorrect_sum<>0)) then
        vdemand_str:=1;
        vtariff:= vcorrect_sum;
     end if;


     -- чтобы НДС по отрицательной строке был равен сумме положительных строк
     insert into acd_taxcorrection_tbl(id_doc,unit,unit_kod,uktzed,tariff,id_tariff,id_sumtariff,
       cor_demand,cor_sum_20,cor_sum_0,cor_sum_free,cor_tax,cor_tax_credit,mmgg)
     values(vid_new,''кВт·год'',''0415'',''2716000000'',vtariff,vadvance.id_tariff,vid_sumtariff,
       -vdemand_str,-vcorrect_sum,0,0,-vcorrect_pdv,-vcorrect_pdv,vbill.mmgg);


    end if;
   end loop;

  end if;
  Raise Notice '' = = = = acm_createTaxCorrect fin = = = = '';
  return v_cor_created;
  end;
' LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------------------------------
-- создание НН по счету при расчете по первому событию
-- возвращает номер НН
-- создает НН на (сумму счета - сумма корректировки)
-- 1 счет - 1 НН
-- корректировки по счету должны формироваться ранее
-------------------------------------------------------------------------------------------------------------
--drop function acm_createTaxBill(int);


create or replace function acm_createTaxBill(int, date) returns int as'
  declare 
     pid_bill alias for $1;
     preg_date    alias for $2;
     vbill  record;
     vsaldo record;
     vpref     varchar;
     vcorrect  numeric;
     vcorrect1 numeric;
     vcorrecttax numeric;
     vreg_num varchar;
     vint_num int;
     vnum_end  varchar;
     vbillstr record;
     vktsaldo record;
     vktsaldo_old record;
     vktmove record;
     vtariff numeric(14,4);
     vid_tax int;   
--     vflag_budjet int;
     vdemand_rest int;
     vsum_rest numeric;
     vbillpay record;
     vexistcor numeric;
     vreg_date date; 
     vreg_date_line date; 
     vbool boolean;
     vprevbill record;
     vvalue_tax_math numeric;
     vsumtariff_math numeric; 
     vvalue_tax numeric;
     vlimit numeric;
     vavans_curmmgg record;
     vrescod int;
     vstcl  record;
     vid_new  int;

  begin


  -- если НН уже есть
  select into vid_tax id_doc from acm_tax_tbl where id_bill = pid_bill and disabled=0;
  if found then 
      Raise EXCEPTION ''Налоговая накладная уже сформирована.'';
      return -2;
  end if;

  select into vbill id_pref,mmgg as mmgg,mmgg_bill,id_client,value,value_tax,reg_date, dat_e,idk_doc,demand_val ,dt
  from acm_bill_tbl where id_doc =pid_bill;

  if not found then 
      Raise EXCEPTION ''Счет не найден.'';
      return 0;
  end if;


  if vbill.mmgg < ''2015-01-01''::date then
     return 0;
  end if;


  select into vstcl flag_budjet,flag_taxpay from clm_statecl_h where id_client = vbill.id_client and mmgg_b <= vbill.mmgg order by mmgg_b desc limit 1;


  if vstcl.flag_budjet=1 then
    Raise EXCEPTION ''Абонент - бюджетная организация.'';
    return -3;
  end if;

  if vbill.idk_doc=201 then 
      Raise EXCEPTION ''Неподходящий тип счета для выписки НН.'';
      return 0;     
  end if;

  if vbill.value<=0 then 
      Raise EXCEPTION ''Счет на сумму <=0.'';
      return 0;     
  end if;


  select into vpref ident from aci_pref_tbl where id=vbill.id_pref;

  vrescod:= getsysvar(''kod_res'') ;

  delete from sys_error_tbl;


  vreg_date = preg_date;

  vreg_date_line:= vreg_date;

  --удалить информацию о использовании строк данного счета НН
  delete from acm_billtax_tbl where id_doc=pid_bill ;


  -- Корректировка перед формированием 
  if vpref=''act_ee'' then
  
    select into vbool acm_createTaxCorrect(pid_bill,vreg_date);

    if (vbool) then
      insert into sys_error_tbl(nam,ident,id_error) values (''tax_corr'',''tax'',21);
    end if;

  end if;


  -- примем, что авансом счета гасятся по порядку фактического времени создания
  select into vprevbill coalesce(sum(value),0) as val, coalesce(sum(value_tax),0) as val_tax 
  from acm_bill_tbl 
  where id_client=vbill.id_client and id_pref=vbill.id_pref and mmgg = vbill.mmgg and dt<vbill.dt and value>0 ;


  Raise Notice ''vprevbill tax %'',vprevbill.val_tax;

  select into vktsaldo CASE WHEN c.order_pay =0 THEN coalesce((ss.kr_zkme),0) ELSE coalesce((ss.e_kred),0) END as bkt, 
                       CASE WHEN c.order_pay =0 THEN coalesce((ss.kr_zkmpdv),0) ELSE coalesce((ss.e_kred_tax),0) END as bkt_pdv 
  from seb_obr_all_tbl as ss
  join clm_client_tbl as c on (c.id = ss.id_client)
  where ss.id_client=vbill.id_client and ss.id_pref=vbill.id_pref and ss.mmgg = vbill.mmgg - ''1 month''::interval;


  Raise Notice ''vktsaldo tax %'',vktsaldo.bkt_pdv;

  ----------------------------------------------------------------------

  -- авансовые НН за текущий период, выписанные вручную в начале месяца на текущую оплату
/*
  select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
     from acm_tax_tbl as v 
     where v.id_client = vbill.id_client and v.kind_calc = 7 and disabled=0
     and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < vreg_date;
*/

  select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
  from ( 
     select value, value_tax
     from acm_tax_tbl as v 
     where v.id_client = vbill.id_client and v.kind_calc = 7 and disabled=0
     and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < vreg_date
	union all
     select value, value_tax
     from acm_taxcorrection_tbl as v 
     where v.id_client = vbill.id_client 
     and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < vreg_date
     ) as ss;

  if vavans_curmmgg.value>0 then
     Raise Notice ''+current month avans % '',vavans_curmmgg.value; 
  end if;


  vktsaldo.bkt := numeric_larger(coalesce(vktsaldo.bkt,0)+coalesce(vavans_curmmgg.value,0) - coalesce(vprevbill.val,0),0);
  vktsaldo.bkt_pdv := numeric_larger(coalesce(vktsaldo.bkt_pdv,0)+coalesce(vavans_curmmgg.value_tax,0) - coalesce(vprevbill.val_tax,0),0);


  Raise Notice ''- - -vktsaldo.bkt %'',vktsaldo.bkt;

  if (vktsaldo.bkt > 0) then

    Raise Notice ''сумма счета %'',vbill.value;
    Raise Notice ''vktsaldo.bkt %'',vktsaldo.bkt;

    if (vbill.value <= vktsaldo.bkt) then 

       Raise NOTICE ''Счет был погашен авансом.'';
       insert into sys_error_tbl(nam,ident,id_error) values (''tax_non'',''tax'',20);
       return -5;
  
    else
       -- полная сумма погашения данного счета кредитом

       vcorrect:=numeric_smaller(vktsaldo.bkt,vbill.value);

       Raise Notice ''Погашение авансом %'',vcorrect;

       vcorrecttax:=numeric_smaller(vktsaldo.bkt_pdv,vbill.value_tax);

       --сумма прошедших корректировок по данному счету 
       select into vexistcor coalesce(sum(sum_val),0) from acm_billtax_tbl where id_doc = pid_bill; 
       -- сумма погашения, не охваченная корректировками 
       vcorrect1:=vcorrect - vexistcor;
    end if;
  else
   vcorrect1:=0;
   vcorrect:=0;
   vcorrecttax:=0;
  end if;

  Raise Notice ''Формирование НН по счету % '',pid_bill;
  --формируем НН на сумму счета, не покрытую авансом

  select into vnum_end value_ident  from syi_sysvars_tbl 
  where ident=''tax_num_ending'';

  if coalesce(vstcl.flag_taxpay,0) = 0  then
     vint_num = 0;
     vreg_num:=''''; 
  else
     vint_num = acm_nexttaxnum(vbill.mmgg);
     vreg_num:=Text(vint_num)||vnum_end; 
  end if;

/*
  --заголовок
  if (vpref=''act_ee'') or (vpref=''react_ee'') or (vpref=''2kr_d'') then 

   Raise Notice ''Заголовок'';  

--   if round((vbill.value-vcorrect)/5,2) >= 100000 then 
    --если сумма НДС больше 100000, НН должна проходить через программу, и НДС должен по любому быть 20 %,
    -- иначе пока по старому

    if (( round((vbill.value-vcorrect)/5,2) >= vlimit ) or ( (vbill.value_tax-vcorrecttax) >= vlimit )) and (getsysvar(''tax_div'')=1) then 

       insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,id_bill,int_num,mmgg)
       values(vbill.id_pref,1,0,vreg_date,vreg_num,vbill.id_client,(vbill.value-vcorrect),round((vbill.value-vcorrect)/5,2),pid_bill,vint_num,vbill.mmgg);


       if (vbill.value_tax-vcorrecttax) <> round((vbill.value-vcorrect)/5,2) then

         vvalue_tax_math:=round((vbill.value-vcorrect)/5,2);

  --      Raise Notice ''&&& Не совпадане НДС НН % и Оборотки %'',vvalue_tax_math,vvalue_tax;

         insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
         values(vbill.id_client,vbill.id_pref,currval(''dcm_doc_seq''),vbill.mmgg,vbill.value-vcorrect,vvalue_tax_math,vbill.value_tax-vcorrecttax);

       end if;

     --  vvalue_tax := round((vbill.value-vcorrect)/5,2);
    else
*/
     --  vvalue_tax := vbill.value_tax-vcorrecttax;
      insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,id_bill,int_num,mmgg,decade)
      values(default, vbill.id_pref,1,0,vreg_date,vreg_num,vbill.id_client,(vbill.value-vcorrect),(vbill.value_tax-vcorrecttax),pid_bill,vint_num,vbill.mmgg,3)
       returning id_doc into vid_new;

--    end if;

--  end if;


--  Raise Notice ''Заголовок'';
  --строки счета, не потраченные на корректировку, полностью идут в НН
  --спец. счета (акты и др.) не имеют id_sumtariff, на них нет корректировок


  if (vpref=''act_ee'') then

    for vbillstr in 
        select  bs.sumval-coalesce(sum(bt.sum_val),0) as sum_rest,
        bs.demandval-Coalesce(sum(bt.demand_val),0) as demand_rest,
        bs.id_tariff,bs.id_sumtariff,bs.id_zonekoef,bs.zone_koef

        from (select sum(bs1.sum_val) as sumval,sum(bs1.demand_val) as demandval, 
        max(bs1.id_tariff) as id_tariff, max(bs1.id_sumtariff) as id_sumtariff, bs1.id_doc,bs1.id_zonekoef,
        coalesce(dz.koef,1) as zone_koef, round(t.value*coalesce(dz.koef,1),4) as tariff
         from acd_billsum_tbl as bs1 
         left join acd_zone_tbl as dz on (bs1.id_zonekoef = dz.id)
         left join acd_tarif_tbl as t on (bs1.id_sumtariff = t.id) 
         where bs1.id_doc =pid_bill and bs1.sum_val<>0
         group by bs1.id_doc,tariff,bs1.id_zonekoef,zone_koef) as bs 
        left join acm_billtax_tbl as bt 
        using(id_doc,tariff,zone_koef,id_zonekoef)
        group by bs.id_doc,bs.id_sumtariff,bs.id_tariff,bs.id_zonekoef,bs.zone_koef,bs.demandval,bs.sumval
        having bs.sumval-coalesce(sum(bt.sum_val),0)<>0
        order by bs.id_sumtariff 
    loop


       Raise Notice ''Строка'';
  
       vsum_rest = numeric_larger(vbillstr.sum_rest-vcorrect1,0) ;
       vcorrect1 = vcorrect1 - numeric_smaller(vbillstr.sum_rest,vcorrect1) ;
  
       if (vsum_rest > 0 )  then
  
         -- тариф из таблици, если указан, иначе попробуем посчитать
         if (vbillstr.id_sumtariff is not null ) then
           select into vtariff round(value*vbillstr.zone_koef,4) from acd_tarif_tbl where id = vbillstr.id_sumtariff;

         else 
  
          if (vbillstr.demand_rest is not null) and (vbillstr.demand_rest<>0 ) then 
  
             vtariff = round(vbillstr.sum_rest/vbillstr.demand_rest,4);
          end if;
         end if;
  
  
         if (vsum_rest <>vbillstr.sum_rest) then
            --если уменьшали сумму, пересчитаем киловаты
            vdemand_rest =  round(vsum_rest/vtariff);
         else
            vdemand_rest = vbillstr.demand_rest;
         end if;
   
         -- запишем построчную информацию 
         -- Хотя обработка данного счета на этом заканчивается, удалять его строки из 
         -- acm_billtax_tbl нельзя (на случай удаления НН)
         insert into acm_billtax_tbl(id_doc,id_tax,id_sumtariff,tariff,zone_koef,id_zonekoef,sum_val,demand_val)
         values(pid_bill,vid_new,vbillstr.id_sumtariff,vtariff,vbillstr.zone_koef,vbillstr.id_zonekoef,vsum_rest,vdemand_rest);
    
    
	 -- пересчет цены от полученных киловат
	 if (vdemand_rest <>0 ) then
	   vsumtariff_math := Round(vsum_rest/vdemand_rest,acm_calc_tarif_prec(vdemand_rest));
	 else
	   vsumtariff_math := vtariff;
	 end if;


         insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,
            id_tariff,id_sumtariff,id_zonekoef,mmgg)
         values(vid_new,vreg_date_line,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (рахунок)'',
            vdemand_rest,vsum_rest,vsumtariff_math,vbillstr.id_tariff,vbillstr.id_sumtariff,vbillstr.id_zonekoef,vbill.mmgg);
    

         Raise Notice ''тариф %'',vtariff;
         Raise Notice ''на сумму  %'',vsum_rest;
  
       end if;
  
    end loop;
  end if;

  -- по реактиву НН выписываем без тарифов одной строкой
  if (vpref=''react_ee'') then

     insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,text,demand_val,sum_val7,tariff,
       id_tariff,id_sumtariff,mmgg)
     values(vid_new,vreg_date_line,''грн'',''2454'',''Плата за перетiкання реактивної електроенергiї (рахунок)'',
       1,vbill.value-vcorrect,vbill.value-vcorrect,0,0,vbill.mmgg);
 
  end if;


  return vid_new;
  end;
' LANGUAGE 'plpgsql';

-----------------------------------------------------------------------------------------
-- создание НН по счету в конце месяца
-- создает НН на (сумму счета - сумма корректировки)
-- корректировки по счету должны формироваться ранее

drop function acm_createTaxBillEnd(int,int,date,date);
create or replace function acm_createTaxBillEnd(int,int,date,date) returns int as'
  declare 
     pid_client   alias for $1;
     pid_pref     alias for $2;
     pmmgg        alias for $3;
     preg_date    alias for $4;

     vbill  record;
     vsaldo record;
     vktsaldo record;
     vktsaldo_old record;
     vktmove record;

     vpref     varchar;
     vcorrect  numeric;
     vcorrect1 numeric;
     vcorrecttax numeric;
     vreg_num varchar;
     vint_num int;
     vnum_end  varchar;
     vbillstr record;
     vtariff numeric(14,4);
     vid_tax int;   
     vflag_budjet int;
     vdemand_rest int;
     vsum_rest numeric;
     vbillpay record;
     vexistcor numeric;
     v_go int;
     vbigtax record;
     vprevbill record;
     vvalue_tax_math numeric;
     vsumtariff_math numeric;
     vlimit numeric;
     vavans_curmmgg record;
     vrescod int;
     vstcl        record;
     vreg_date_line date;
     vid_new  int;

  begin

  --может быть несколько активных счетов (с учетом актов и прочих)

    if pmmgg < ''2015-01-01''::date then
       return 0;
    end if;


    vrescod:= getsysvar(''kod_res'') ;

  for vbill in 
   select id_doc,id_pref,mmgg as mmgg,id_client,value,value_tax,reg_date, dat_e, idk_doc ,demand_val,mmgg_bill,dt
   from acm_bill_tbl where id_client = pid_client and mmgg = pmmgg and id_pref = pid_pref 
   and idk_doc <> 201 
   and value <> 0 
   order by dt
  loop
  

   Raise Notice '' Счет %.'',vbill.id_doc;
   v_go:=1;  

 
    -- если НН уже есть
   select into vid_tax id_doc from acm_tax_tbl where id_bill = vbill.id_doc and disabled=0;
   if found then 
        Raise Notice ''Налоговая накладная уже сформирована.'';
--        return false;
        v_go:=0;  
   end if;
  
  
   select into vpref ident from aci_pref_tbl where id=vbill.id_pref;
   select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h where id_client = pid_client and mmgg_b <= pmmgg order by mmgg_b desc limit 1;

   vreg_date_line:= preg_date;


   if vbill.value > 0 then      
   -- нормальная НН 
  
      if (v_go = 1) then

        --удалить информацию о использовании строк данного счета 
        delete from acm_billtax_tbl where id_doc=vbill.id_doc;
  
        if vpref=''act_ee'' then
     
          perform acm_createTaxCorrect(vbill.id_doc,preg_date);
   
        end if;
  

	select into vprevbill coalesce(sum(value),0) as val, coalesce(sum(value_tax),0) as val_tax 
	from acm_bill_tbl 
	where id_client=vbill.id_client and id_pref=vbill.id_pref and mmgg = vbill.mmgg and dt < vbill.dt and value >0 ;

        Raise Notice ''vprevbill tax %'',vprevbill.val_tax;

        select into vktsaldo CASE WHEN c.order_pay =0 THEN coalesce((ss.kr_zkme),0) ELSE coalesce((ss.e_kred),0) END as bkt, 
                             CASE WHEN c.order_pay =0 THEN coalesce((ss.kr_zkmpdv),0) ELSE coalesce((ss.e_kred_tax),0) END as bkt_pdv 
        from seb_obr_all_tbl as ss
        join clm_client_tbl as c on (c.id = ss.id_client)
        where ss.id_client=vbill.id_client and ss.id_pref=vbill.id_pref and ss.mmgg = vbill.mmgg - ''1 month''::interval;

        ----------------------------------------------------------------------
        -- авансовые НН за текущий период, выписанные вручную в начале месяца на текущую оплату
/*
        select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
         from acm_tax_tbl as v 
         where v.id_client = vbill.id_client and v.kind_calc = 7 and disabled = 0
         and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < preg_date;
*/

	 select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
	 from ( 
	   select value, value_tax
	   from acm_tax_tbl as v 
	   where v.id_client = vbill.id_client and v.kind_calc = 7 and disabled=0
	   and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < preg_date
	union all
	   select value, value_tax
	   from acm_taxcorrection_tbl as v 
	   where v.id_client = vbill.id_client 
	   and v.id_pref=vbill.id_pref and v.mmgg = vbill.mmgg and v.reg_date < preg_date
         ) as ss;

        if vavans_curmmgg.value>0 then
          Raise Notice ''+current month avans % '',vavans_curmmgg.value; 
        end if;

--        vktsaldo.bkt := numeric_larger(vktsaldo.bkt+vavans_curmmgg.value - vprevbill.val,0);
--        vktsaldo.bkt_pdv := numeric_larger(vktsaldo.bkt_pdv+vavans_curmmgg.value_tax - vprevbill.val_tax,0);

        vktsaldo.bkt := numeric_larger(coalesce(vktsaldo.bkt,0)+coalesce(vavans_curmmgg.value,0) - coalesce(vprevbill.val,0),0);
        vktsaldo.bkt_pdv := numeric_larger(coalesce(vktsaldo.bkt_pdv,0)+coalesce(vavans_curmmgg.value_tax,0) - coalesce(vprevbill.val_tax,0),0);

  
        if (vktsaldo.bkt > 0) then

    
--          Raise Notice ''Погашение авансом %'',numeric_smaller(vktsaldo.bkt,vbill.value);

            if (vbill.value <= vktsaldo.bkt) then 
--              Raise Notice ''Погашение авансом %'',vbillpay.value;
 
              Raise Notice ''Счет был погашен авансом.'';
              --return false;
              v_go:=0;
      
            else
             -- полная сумма погашения данного счета кредитом

             vcorrect:=numeric_smaller(vktsaldo.bkt,vbill.value);

   	     Raise Notice ''Погашение авансом %'',vcorrect;

             vcorrecttax:=numeric_smaller(vktsaldo.bkt_pdv,vbill.value_tax);    
             --сумма прошедших корректировок по данному счету 
              select into vexistcor coalesce(sum(sum_val),0) from acm_billtax_tbl where id_doc = vbill.id_doc; 
             -- сумма погашения, не охваченная корректировками 
              vcorrect1:=vcorrect - vexistcor;
            end if;
          else
          vcorrect1:=0;
          vcorrect:=0;
          vcorrecttax:=0;
        end if;
      end if;  

      if (v_go = 1) then
  
        Raise Notice ''Формирование НН по счету'';
        --формируем НН на сумму счета, не покрытую авансом
    
        select into vnum_end value_ident  from syi_sysvars_tbl 
        where ident=''tax_num_ending'';
    
--        vreg_num:=acm_nexttaxnum(vbill.mmgg);
        -- с марта 2013 года неплатникам налоговая выписывается без номера
        if coalesce(vstcl.flag_taxpay,0) = 0  then
          vint_num = 0;
          vreg_num:=''''; 
        else
          vint_num = acm_nexttaxnum(pmmgg);
          vreg_num:=Text(vint_num)||vnum_end; 
        end if;

/*    
        --заголовок
        if (vpref=''act_ee'') or (vpref=''react_ee'') or (vpref=''2kr_d'') then 
    
         if ((round((vbill.value-vcorrect)/5,2) >=vlimit ) or ((vbill.value_tax-vcorrecttax) >= vlimit )) and (getsysvar(''tax_div'')=1) then 

          insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,id_bill,int_num,auto)
  --         values(vbill.id_pref,1,0,preg_date::date,text(vreg_num)||vnum_end,vbill.id_client,vbill.value-vcorrect,vbill.value_tax-vcorrecttax,vbill.id_doc,vreg_num,1);
           values(vbill.id_pref,1,0,preg_date::date,vreg_num,vbill.id_client,vbill.value-vcorrect,round((vbill.value-vcorrect)/5,2),vbill.id_doc,vint_num,1);


  	   if (vbill.value_tax-vcorrecttax) <> round((vbill.value-vcorrect)/5,2) then

	     vvalue_tax_math:=round((vbill.value-vcorrect)/5,2);

	     insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
	     values(vbill.id_client,vbill.id_pref,currval(''dcm_doc_seq''),vbill.mmgg,vbill.value-vcorrect,vvalue_tax_math,vbill.value_tax-vcorrecttax);

	   end if;
	 else
*/
        insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,id_bill,int_num,auto,decade)
        values(default,vbill.id_pref,1,0,preg_date::date,vreg_num,vbill.id_client,vbill.value-vcorrect,vbill.value_tax-vcorrecttax,vbill.id_doc,vint_num,1,3) 
         returning id_doc into vid_new;
 
--         end if;

--        end if;

        --строки счета, не потраченные на корректировку, полностью идут в НН
        if (vpref=''act_ee'') then
  
          for vbillstr in 
             select  bs.sumval-coalesce(sum(bt.sum_val),0) as sum_rest,
             bs.demandval-Coalesce(sum(bt.demand_val),0) as demand_rest,
             bs.id_tariff,bs.id_sumtariff,bs.id_zonekoef,bs.zone_koef
             from (select sum(bs1.sum_val) as sumval,sum(bs1.demand_val) as demandval, 
             max(bs1.id_tariff) as id_tariff, max(bs1.id_sumtariff) as id_sumtariff, bs1.id_doc,
             bs1.id_zonekoef, coalesce(dz.koef,1) as zone_koef,round(t.value*coalesce(dz.koef,1),4) as tariff
             from acd_billsum_tbl as bs1 
             left join acd_zone_tbl as dz on (bs1.id_zonekoef = dz.id)
             left join acd_tarif_tbl as t on (bs1.id_sumtariff = t.id) 
             where bs1.id_doc =vbill.id_doc and bs1.sum_val<>0
             group by bs1.id_doc,tariff,bs1.id_zonekoef,zone_koef) as bs 
            left join acm_billtax_tbl as bt 
            using(id_doc,tariff,zone_koef,id_zonekoef)
            group by bs.id_doc,bs.id_sumtariff,bs.id_tariff,bs.id_zonekoef,bs.zone_koef,bs.demandval,bs.sumval
            having bs.sumval-coalesce(sum(bt.sum_val),0)<>0
            order by bs.id_sumtariff 
          loop

           Raise Notice ''Строка %'',vbillstr.sum_rest;    

           vsum_rest = numeric_larger(vbillstr.sum_rest-vcorrect1,0) ;
           vcorrect1 = vcorrect1 - numeric_smaller(vbillstr.sum_rest,vcorrect1) ;
       
           if (vsum_rest > 0 )  then
       
             -- тариф из таблици, если указан, иначе попробуем посчитать
             if (vbillstr.id_sumtariff is not null ) then
               select into vtariff round(value*vbillstr.zone_koef,4) from acd_tarif_tbl where id = vbillstr.id_sumtariff;
    
             else 
       
              if (vbillstr.demand_rest is not null) and (vbillstr.demand_rest<>0 ) then 
       
                 vtariff = round(vbillstr.sum_rest/vbillstr.demand_rest,4);
              end if;
             end if;
       
       
             if (vsum_rest <>vbillstr.sum_rest) then
                --если уменьшали сумму, пересчитаем киловаты
                vdemand_rest =  round(vsum_rest/vtariff);
             else
                vdemand_rest = vbillstr.demand_rest;
             end if;
    
             -- запишем построчную информацию 
             -- Хотя обработка данного счета на этом заканчивается, удалять его строки из 
             -- acm_billtax_tbl нельзя (на случай удаления НН)
             insert into acm_billtax_tbl(id_doc,id_tax,id_sumtariff,tariff,sum_val,demand_val,zone_koef,id_zonekoef)
             values(vbill.id_doc,vid_new,vbillstr.id_sumtariff,vtariff, vsum_rest,vdemand_rest,vbillstr.zone_koef,vbillstr.id_zonekoef);
        
 	      -- пересчет цены от полученных киловат
	      if (vdemand_rest <>0 ) then
	       vsumtariff_math := Round(vsum_rest/vdemand_rest,acm_calc_tarif_prec(vdemand_rest));
	      else
	       vsumtariff_math := vtariff;
	      end if;

              insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,
                id_tariff,id_sumtariff,id_zonekoef)
              values(vid_new,vreg_date_line,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (рахунок)'',
                vdemand_rest,vsum_rest,vsumtariff_math,vbillstr.id_tariff,vbillstr.id_sumtariff,vbillstr.id_zonekoef);
      
           end if;
          end loop;
        end if;
  
        -- по реактиву НН выписываем без тарифов одной строкой
        if (vpref=''react_ee'') then
  
          insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,text,demand_val,sum_val7,tariff,
            id_tariff,id_sumtariff)
          values(vid_new,vreg_date_line,''грн'',''2454'',''Плата за перетiкання реактивної електроенергiї (рахунок)'',
            1,vbill.value-vcorrect,vbill.value-vcorrect,0,0);
   
        end if;
  
      end if;

   end if;

  end loop;


  return vid_new;
  end;
' LANGUAGE 'plpgsql';
----------------------------------------------------------------------------------------------------


drop function acm_createTaxPay(int,int,date,date,int);
create or replace function acm_createTaxPay(int,int,date,date,int) returns int as'
  declare 
     pid_client   alias for $1;
     pid_pref     alias for $2;
     pmmgg        alias for $3;
     preg_date    alias for $4;
     prebuild     alias for $5;
--     psplit       alias for $6;

     vsaldo       record;
     vktsaldo     record;
     vbill        record;
     vpay         record;
     vreg_num     varchar;
     vnum_end     varchar;
     vvalue	  numeric(14,4);
     vvalue_tax   numeric(14,4);
     vpref        varchar;
     vtariff      numeric(14,4);
     vid_tariff   int;
     vid_sumtariff int;
     vdemand      numeric(14,4);
     vbillpay     record;
     vbillstr     record;
     vheader int;
     vsum_pay      numeric(14,4);
     vsum_pay_tax  numeric(14,4);
     vsum_pay_bill numeric(14,4);
     vsum_pay_cur  numeric(14,4);
     vid_tax       int;
     vint_num      int;
     vid_newtax    int;
--     vreg_date     date;
     vvalue_tax_math numeric;
     vsumtariff_math numeric;
     vpay_date date;
     -- переменные из процедуры корректировки

     vadvance   record;
     v_ok       record;
     vcorrect   numeric(14,4);
     vbillforcorrect numeric(14,4);
     vcorrect_cur numeric(14,4);
     vsum_ok  numeric(14,4);
     vdemand_ok int;
     vcorrect_billstr numeric(14,4);
     vlastnum int;
     v_cor_created boolean;
     vold_kor   record; 

     vclient    record;
     vprotocol  record;

     vcorrect_pdv numeric(14,2);
     vcorrect_sum numeric(14,2);
     vlimit numeric;
     vrescod int;
     vstcl        record;
 
     vsplit_tax int;
     vid_new  int;

     vavans_curmmgg record;
     vreg_date2     date;
     vdemand_str    int;
  begin

    if pmmgg < ''2015-01-01''::date then
       return 0;
    end if;



   select into vid_tax id_doc from acm_tax_tbl 
   where id_client = pid_client and mmgg = pmmgg and kind_calc = 3 and id_pref = pid_pref and disabled = 0;

   if found then 
--      Raise EXCEPTION ''Налоговая накладная на оплату для абонента % в этом месяце уже сформирована.'',pid_client;
      Raise Notice ''Налоговая накладная на оплату для абонента % в этом месяце уже сформирована.'',pid_client;
      return 0;
   end if;
/*
   if (pmmgg >= ''2012-01-01'') then
    vlimit:=10000;
   else
    vlimit:=100000;
   end if;
*/
--   Raise Notice ''- - ((((((((((((((((((((((((((((((((((((((((((((((( -  - - '';
   Raise Notice ''Налоговая накладная на оплату для абонента % '',pid_client;
   ------------------------------------------------------------

   select into vpref ident from aci_pref_tbl where id=pid_pref;

   select into vnum_end value_ident  from syi_sysvars_tbl 
   where ident=''tax_num_ending'';

   vrescod:= getsysvar(''kod_res'') ;

   vpay_date:= preg_date;

   select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h where id_client = pid_client and mmgg_b <= pmmgg order by mmgg_b desc limit 1;

  if prebuild = 1 then 


     -- чтобы можно было переформировать нн по льготам
     ---------------------------------------------------------------------------
     for vclient in 
       select cm.code,p.id_client,p.id_pref,sum(p.value) as pay ,sum(p.value_tax) as pay_tax ,sum(p.value_pay) as pay_all,
       cp.doc_num, cp.doc_dat
       from  acm_pay_tbl as p 
       left join clm_client_tbl as cm on (cm.id = p.id_client)
       left join clm_statecl_h as cp on (p.id_client=cp.id_client)
       left join dci_document_tbl as dci on (p.idk_doc=dci.id)
       where cm.book = -1 and p.mmgg=pmmgg 
       and cp.flag_budjet = 1 
       and cp.id_section in (206,207)  
       and p.sign_pay = 1
       and ((dci.ident<>''writeoff'') and (dci.ident<>''wr_off_act''))  
       and cm.id = pid_client
       and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
       group by cm.code,p.id_client,p.id_pref,cp.doc_num, cp.doc_dat
       having sum(p.value_pay)<>0
       order by p.id_client
     loop
  
        Raise Notice ''НН на оплату (льготы/субсидии) абонент % '',vclient.code;      
  
        vint_num = acm_nexttaxnum(pmmgg);
        vreg_num:=Text(vint_num)||vnum_end;

/*
        if (( round(vclient.pay/5,2) >=vlimit ) or (vclient.pay_tax >= vlimit )) and (getsysvar(''tax_div'')=1) then 

    
          insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,int_num,decade)
          values(default,10,3,0,preg_date,vreg_num,vclient.id_client,vclient.pay,round(vclient.pay/5,2),1,vint_num,3) returning id_doc into vid_new;
    

          if vclient.pay_tax <> round(vclient.pay/5,2) then

           vvalue_tax_math:=round(vclient.pay/5,2);
         
           insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
           values(vclient.id_client,pid_pref,vid_new,pmmgg,vclient.pay,vvalue_tax_math,vclient.pay_tax);

          end if;

        else
*/
          insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,int_num, decade)
          values(default,10,3,0,preg_date,vreg_num,vclient.id_client,vclient.pay,vclient.pay_tax,1,vint_num,3) returning id_doc into vid_new;
--        end if;

        --вся детализация идет одной строкой
        -- количество = 1
        -- единица изм. грн
        -- цена = сумма без НДС
  
        select into vprotocol * from clm_protocol_tbl where id_client = vclient.id_client and mmgg = pmmgg order by reg_date limit 1;
  
        if found  then
  
         insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff)
         values(vid_new,preg_date,''грн'',''2454'',''2716000000'',''Активна е/е згiдно протоколу погодження ¦ ''||
          vprotocol.reg_num::varchar||'' вiд ''||to_char(vprotocol.reg_date,''DD.MM.YYYY'') , 1,vclient.pay,vclient.pay);
  
        else
  
         insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff)
         values(vid_new,preg_date,''грн'',''2454'',''2716000000'',''Активна е/е згiдно протоколу погодження ¦ ''||
          vclient.doc_num::varchar||'' вiд ''||to_char(vclient.doc_dat,''DD.MM.YYYY''), 1,vclient.pay,vclient.pay);
  
        end if;  

        return vid_new;
  
     end loop;
     -------------------------------------------------------------------------------

     perform seb_one( pmmgg ,0 ,pid_client );

     update seb_obrs_tmp set b_dtval=0,b_ktval=b_ktval-b_dtval,
                    b_dtval_tax=0,b_ktval_tax=b_ktval_tax-b_dtval_tax
             where b_dtval<0;

     update seb_obrs_tmp set e_dtval=0,e_ktval=e_ktval-e_dtval,
                    e_dtval_tax=0,e_ktval_tax=e_ktval_tax-e_dtval_tax
             where e_dtval<0;


  end if;


    vheader:=0;
    vsum_pay:=0;
    vsum_pay_tax:=0;
    ---------------------------------------------------------------------------------------------
    -- 2000-20XX года 
    vheader:=0;
    vsum_pay:=0;
    vsum_pay_tax:=0;


    select into vsaldo  coalesce(-deb_zpmv,0) as bdt,  coalesce(-deb_zpmpdv,0) as bdt_tax, 
    coalesce(kr_zpmpdv,0) as bkt_tax, coalesce(nar_pdv,0) as bill_tax, coalesce(opl_zpdv,0) as pay_tax
    from seb_obr_all_tmp
    where id_client=pid_client and id_pref=pid_pref and period=pmmgg;


      Raise Notice ''vsaldo.pay_tax %'',vsaldo.pay_tax;
      Raise Notice ''vsaldo.bdt_tax %'',vsaldo.bdt_tax;
      Raise Notice ''vsaldo.bkt_tax %'',vsaldo.bkt_tax;
      Raise Notice ''vsaldo.bill_tax %'',vsaldo.bill_tax;


    vsplit_tax:=0;
/*
    --март 2013. Налоговые накладные не должны превышать лимит по НДС, иначе выписываем отдельно на каждый оплачиваемый счет
    if (LEAST( vsaldo.pay_tax , (vsaldo.bdt_tax - vsaldo.bkt_tax +vsaldo.bill_tax)) >= vlimit) and (coalesce(vstcl.flag_taxpay,0)=1) and (psplit = 1) then
       vsplit_tax:=1;
       Raise Notice ''Split mode on '';
    else 
       vsplit_tax:=0;
       Raise Notice ''Split mode off '';
    end if;
*/
    if (vsaldo.bdt = 0) and (vsplit_tax = 0) then
    ----------------------------------!!!!!!!!! упрощенный вариант !!!!!!--------------
    --если нет дебета, вся оплата тек. периода пойдет полюбому на счета текущего периода, И МОЖНО ОБОЙТИСЬ БЕЗ acm_billpay_tbl

      Raise Notice ''{{{{ -Упрощенный вариант- }}}}'' ;


--      select into vktsaldo coalesce(sum(b_ktval),0) as bkt, coalesce(sum(b_ktval_tax),0) as bkt_pdv 
--      from seb_obrs_tmp 
--      where id_client=pid_client and id_pref=pid_pref and date_part(''year'',hmmgg) in (date_part(''year'',pmmgg),date_part(''year'',pmmgg)-1) ;


      select into vktsaldo CASE WHEN c.order_pay =0 THEN coalesce((ss.kr_zkme),0) ELSE coalesce((ss.e_kred),0) END as bkt, 
                           CASE WHEN c.order_pay =0 THEN coalesce((ss.kr_zkmpdv),0) ELSE coalesce((ss.e_kred_tax),0) END as bkt_pdv 
      from seb_obr_all_tbl as ss
      join clm_client_tbl as c on (c.id = ss.id_client)
      where ss.id_client=pid_client and ss.id_pref=pid_pref and ss.mmgg = pmmgg - ''1 month''::interval;




--      select into vavans_curmmgg coalesce(sum(sum_rest),0) from acv_taxadvtariff as v 
--       where v.id_client = pid_client 
--       and v.id_pref=pid_pref and v.mmgg = pmmgg and v.reg_date < preg_date;

--       select into vavans_curmmgg coalesce(sum(value),0) as value 
--        from acm_tax_tbl as v 
--        where v.id_client = pid_client and v.kind_calc = 7
--        and v.id_pref=pid_pref and v.mmgg = pmmgg and v.reg_date < preg_date;
/*
      select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
        from acm_tax_tbl as v 
        where v.id_client = pid_client and v.kind_calc = 7 and disabled = 0
        and v.id_pref=pid_pref and v.mmgg = pmmgg and v.reg_date < preg_date;
*/

      select into vavans_curmmgg coalesce(sum(value),0) as value, coalesce(sum(value_tax),0) as value_tax 
      from ( 
         select value, value_tax
         from acm_tax_tbl as v 
         where v.id_client = pid_client and v.kind_calc = 7 and disabled=0
         and v.id_pref=pid_pref and v.mmgg = pmmgg and v.reg_date < preg_date
	union all
         select value, value_tax
         from acm_taxcorrection_tbl as v 
         where v.id_client = pid_client 
         and v.id_pref=pid_pref and v.mmgg = pmmgg and v.reg_date < preg_date
       ) as ss;


      vktsaldo.bkt := coalesce(vktsaldo.bkt,0);
      vktsaldo.bkt_pdv := coalesce(vktsaldo.bkt_pdv,0);
  
      if vavans_curmmgg.value>0 then
         Raise Notice ''+current month avans % '',vavans_curmmgg.value; 
         vktsaldo.bkt := coalesce(vktsaldo.bkt,0)+coalesce(vavans_curmmgg.value,0);
         vktsaldo.bkt_pdv := coalesce(vktsaldo.bkt_pdv,0)+coalesce(vavans_curmmgg.value_tax,0);
     
      end if;


      Raise Notice ''{{{{{{ кредит % }}}}}}}'',vktsaldo.bkt;


      if (pmmgg < ''2015-08-01'') then

        -- нужно брать только платежи 3 декады, остальное ушло в аванс
        select into vreg_date2 c_date
        from calendar where  date_trunc(''month'', c_date) = pmmgg  
        -- and coalesce(holiday,false) = false 
        and c_date >= pmmgg::date+''19 days''::interval
        order by c_date limit 1; 

      else
        -- с августа 2015 1-2 декады отменены, все идет по концу месяца
        vreg_date2 := (pmmgg::date - ''1 days''::interval)::date ;
      end if;


     select into vpay numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
     from acm_pay_tbl as p
     where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg and p.reg_date > vreg_date2; 
--     and date_part(''year'',p.mmgg_pay)=date_part(''year'',pmmgg);


      for vbill in 
       select id_doc,id_pref,mmgg as mmgg,id_client,value,value_tax,reg_date, dat_e, idk_doc ,demand_val,mmgg_bill
       from acm_bill_tbl where id_client = pid_client and mmgg = pmmgg and id_pref = pid_pref 
       and idk_doc <> 201 
       and value > 0 
       order by reg_date
      loop

        Raise Notice ''{{{{ -Счет % на сумму %-  }}}}'',vbill.id_doc,vbill.value ;
        exit when vpay.pay=0;   --обработана вся оплата

        --удалить информацию о использовании строк данного счета 
        delete from acm_billtax_tbl where id_doc=vbill.id_doc;

        if (vpref=''act_ee'' and vbill.idk_doc=200 )then
        
--           perform acm_createTaxCorrect(vbill.id_doc,preg_date);        !!!!!!!!!!!!!!!

          ---------------------------------============================-------------------------------------

          --измененный код корректировки, не пользуется acm_billpay_tbl,
          -- но всех проблем не решает. Если были неправильно выписанные авансы или списание аванса -платежкой,
          -- прицепится не к тому авансу

          if vktsaldo.bkt >0 then --есть кредитовое сальдо на начало месяца
        
           -- может быть необходима корректировка 
        
           vcorrect:=vktsaldo.bkt;
        
           vbillforcorrect:=numeric_smaller(vbill.value,vcorrect);
        
           Raise Notice '' {{{{{{ Корректировка на сумму % }}}}}}}'',vbillforcorrect;
        

           delete from act_taxkornums_tbl;

           insert into act_taxkornums_tbl 
           select id_doc,id_tax,id_bill,reg_num,reg_date ,int_num
           from acm_taxcorrection_tbl where id_bill = vbill.id_doc and mmgg = pmmgg;

           delete from acm_taxcorrection_tbl where id_bill = vbill.id_doc and mmgg = pmmgg;
           --удалить информацию о погашении данным счетом авансов (она будет переформирована)
           delete from acm_taxadvcor_tbl where id_bill = vbill.id_doc;
        
           -- непогашенные авансы прошлых периодов могут содержать неверную информацию, 
           for vadvance in  select * from acv_taxadvtariff where id_client = vbill.id_client 
             and id_pref=vbill.id_pref and mmgg <= vbill.mmgg
             and mmgg >=''2010-01-01'' 
           loop 
            -- по каждой НН на аванс отдельная корректировка
            vcorrect_cur:=numeric_smaller(vbillforcorrect,vadvance.sum_rest);
        
            select into vtariff value from acd_tarif_tbl where id = vadvance.id_sumtariff;
        
            Raise Notice ''Обнаружен аванс  %'',vadvance.reg_num;
            Raise Notice ''На сумму %'',vcorrect_cur;
            Raise Notice ''По тарифу  %'',vtariff;
        
            exit when vcorrect_cur=0;       -- если сумма счета < аванса, будет досрочный выход
        
            vbillforcorrect:=numeric_larger(vbillforcorrect-vcorrect_cur,0);
        
        
            -- проверить на совпадение суммы тарифа аванса и счета
            -- только 0 зона (другие ясно что не совпадут)
            select into v_ok coalesce(sum(bs.sumval)-coalesce(sum(bt.sum_val),0),0) as sum_rest
            from  
               (select sum(b.sum_val) as sumval, b.id_doc ,t.value as tariff
               from acd_billsum_tbl as b 
               join acd_tarif_tbl as t on (b.id_sumtariff = t.id) 
               where b.id_doc =vbill.id_doc 
               and t.value = vtariff and b.id_zone = 0
               group by b.id_doc,tariff) as bs 
            left outer join ( select id_doc,tariff, sum(sum_val) as sum_val from acm_billtax_tbl where id_doc =vbill.id_doc  group by id_doc,tariff) as bt  
             using(id_doc,tariff);
        
               
            Raise Notice '' v_ok.sum_rest % '',v_ok.sum_rest; 
        
            if not found then
             vsum_ok:=0;
             Raise Notice ''Совпадения тарифов нет''; 
            else
             vsum_ok:=numeric_smaller(v_ok.sum_rest,vcorrect_cur);
            end if;
        
     
            vdemand_ok:=Round(vsum_ok/vtariff);
        
            if vsum_ok<>0 then --совпадение есть 
        
             Raise Notice ''Совпадает тариф  %'',vtariff;
             Raise Notice ''на сумму  %'',vsum_ok;
        
             -- запишем сумму совпадения в таблицу тарифов
             insert into acm_billtax_tbl(id_doc,id_sumtariff,tariff,sum_val,demand_val,source,zone_koef,id_zonekoef)
             values(vbill.id_doc,vadvance.id_sumtariff,vtariff,vsum_ok,vdemand_ok,1,1,1);
        
             -- запишем погашение аванса на сумму совпадения 
             insert into acm_taxadvcor_tbl(id_pref,id_advance,id_correction,id_bill,sum_val)
             values(vbill.id_pref,vadvance.id_doc,NULL,vbill.id_doc,vsum_ok);
        
            end if;
        
            if vsum_ok<vcorrect_cur then -- не все совпало 
             -- придется таки создавать НН корректировки
             v_cor_created:=true;
        
             vcorrect_cur:=vcorrect_cur-vsum_ok;
        
             Raise Notice ''Совпадения не достаточно, осталось %'',vcorrect_cur; 
        
             --если это переформирование, ставим старые номера корректировок
             select into vold_kor * from act_taxkornums_tbl where id_bill = vbill.id_doc and id_tax = vadvance.id_doc;

             if found then 

                vreg_num:=vold_kor.reg_num;
	        vint_num:=vold_kor.int_num;
             else

               -- с марта 2013 года неплатникам налоговая выписывается без номера
--               if (coalesce(vstcl.flag_taxpay,0) = 0) or (pmmgg>=''2015-02-01''::date)  then
               if (coalesce(vstcl.flag_taxpay,0) = 0) or ((pmmgg>=''2015-02-01''::date) and (vadvance.reg_date <''2015-01-01''::date ) ) then
                 vint_num = 0;
                 vreg_num:=''''; 
               else
                 vint_num = acm_nexttaxnum(pmmgg);
                 vreg_num:=Text(vint_num)||vnum_end; 
               end if;

             end if;

             --заголовок
             insert into acm_taxcorrection_tbl(id_pref,reg_num,reg_date,id_client,id_tax,id_bill,value,value_tax,reason,tax_num, tax_date,kind_calc,int_num)
             values(vbill.id_pref,vreg_num,preg_date,vbill.id_client,vadvance.id_doc,vbill.id_doc, 0,0,''Змiна вартiсних показникiв'',vadvance.reg_num, vadvance.reg_date,0,vint_num);
 
             -- погашение аванса на сумму выпиываемой корректировки
             insert into acm_taxadvcor_tbl(id_pref,id_advance,id_correction,id_bill,sum_val)
             values(vbill.id_pref,vadvance.id_doc,currval(''dcm_doc_seq''),vbill.id_doc,vcorrect_cur);
        

             vcorrect_sum:=vcorrect_cur;
             vcorrect_pdv:=0;

             -- получить тарифы счета , отличающиеся от тарифа аванса по сумме 
        
             for vbillstr in 
              select  bs.sumval-coalesce(sum(bt.sum_val),0) as sum_rest,
              bs.id_tariff,bs.id_sumtariff,bs.zone_koef,bs.id_zonekoef
              from 
        
               (select sum(sum_val) as sumval, max(b.id_tariff) as id_tariff, max(b.id_sumtariff) as id_sumtariff, 
                b.id_doc,b.id_zonekoef, coalesce(dz.koef,1) as zone_koef ,round(t.value*coalesce(dz.koef,1),4) as tariff
               from acd_billsum_tbl as b
               join acd_tarif_tbl as t on (b.id_sumtariff = t.id) 
               left join acd_zone_tbl as dz on (b.id_zonekoef = dz.id)
               where b.id_doc =vbill.id_doc and t.value*coalesce(dz.koef,1) <> vtariff
               group by b.id_doc,tariff,b.id_zonekoef,zone_koef) as bs 
        
              left join acm_billtax_tbl as bt 
              using(id_doc,tariff,zone_koef,id_zonekoef)
              group by bs.id_doc,bs.id_sumtariff,bs.id_tariff,bs.sumval,bs.zone_koef,bs.id_zonekoef
              having bs.sumval-coalesce(sum(bt.sum_val),0) >0
             loop
        
              vcorrect_billstr:=numeric_smaller(vbillstr.sum_rest,vcorrect_cur);
              vcorrect_cur:=vcorrect_cur-vcorrect_billstr;
        
              -- данный аванс погашен
              exit when vcorrect_billstr=0;
        
              select into vtariff round(value*vbillstr.zone_koef,4) from acd_tarif_tbl where id = vbillstr.id_sumtariff;
        
              Raise Notice ''Погашение тарифом %'',vtariff;
              Raise Notice ''Зонный коеф. %'',vbillstr.zone_koef;
              Raise Notice ''на сумму  %'',vcorrect_billstr;
              
              -- зафиксировать использование тарифа текущей сроки
              insert into acm_billtax_tbl(id_doc,id_tax,id_sumtariff,tariff,sum_val,demand_val,source,zone_koef,id_zonekoef)
              values(vbill.id_doc,currval(''dcm_doc_seq''),vbillstr.id_sumtariff,vtariff, vcorrect_billstr,round(vcorrect_billstr/vtariff),1,vbillstr.zone_koef,vbillstr.id_zonekoef);
        
              -- строка (+) по тарифу  текущей строки счета

              vcorrect_pdv:=vcorrect_pdv+Round(vcorrect_billstr*0.2,2);        


	      vdemand_str:=round(vcorrect_billstr/vtariff);

	      if ((vdemand_str=0) and (vcorrect_billstr<>0)) then
	        vdemand_str:=1;
	        vtariff:= vcorrect_billstr;
	      end if;



              insert into acd_taxcorrection_tbl(id_doc,unit,unit_kod,uktzed,tariff,id_tariff,id_sumtariff,
               cor_demand,cor_sum_20,cor_sum_0,cor_sum_free,cor_tax,cor_tax_credit,mmgg)
              values(currval(''dcm_doc_seq''),''кВт·год'',''0415'',''2716000000'',vtariff,vbillstr.id_tariff,vbillstr.id_sumtariff,
               vdemand_str ,vcorrect_billstr,0,0,Round(vcorrect_billstr*0.2,2),Round(vcorrect_billstr*0.2,2),vbill.mmgg);
        
             end loop;


	     vdemand_str:=round(vcorrect_sum/vadvance.tariff);
	     vtariff:= vadvance.tariff;

	     if ((vdemand_str=0) and (vcorrect_sum<>0)) then
	        vdemand_str:=1;
	        vtariff:= vcorrect_sum;
	     end if;

             insert into acd_taxcorrection_tbl(id_doc,unit,unit_kod,uktzed,tariff,id_tariff,id_sumtariff,
             cor_demand,cor_sum_20,cor_sum_0,cor_sum_free,cor_tax,cor_tax_credit,mmgg)
             values(currval(''dcm_doc_seq''),''кВт·год'',''0415'',''2716000000'',vtariff,vadvance.id_tariff,vadvance.id_sumtariff,
             -vdemand_str,-vcorrect_sum,0,0,-vcorrect_pdv,-vcorrect_pdv,vbill.mmgg);

            end if;
           end loop;
        
          end if;

          ---------------------------------============================-------------------------------------
        end if;

  
        if vbill.value <= vktsaldo.bkt then

          Raise Notice ''{{{{ счет % полностью погашен авансом }}}}'',vbill.id_doc ;
   
          vktsaldo.bkt:=vktsaldo.bkt-vbill.value;
          vktsaldo.bkt_pdv:=vktsaldo.bkt_pdv-vbill.value_tax;

        else

         vsum_pay_bill:=numeric_smaller(vbill.value-vktsaldo.bkt,vpay.pay);

         vsum_pay:=vsum_pay+vsum_pay_bill;
         vsum_pay_tax:=vsum_pay_tax+numeric_smaller(vbill.value_tax-vktsaldo.bkt_pdv,vpay.pay_pdv);
--!!  
         vpay.pay:=vpay.pay-numeric_smaller(vbill.value-vktsaldo.bkt,vpay.pay);
         vpay.pay_pdv:=vpay.pay_pdv-numeric_smaller(vbill.value_tax-vktsaldo.bkt_pdv,vpay.pay_pdv);

         vktsaldo.bkt:=0;
         vktsaldo.bkt_pdv:=0;
  
  
         if vheader=0 then
  
           --заголовок, пока без суммы
 
           -- с марта 2013 года неплатникам налоговая выписывается без номера
           if coalesce(vstcl.flag_taxpay,0) = 0 then
             vint_num = 0;
             vreg_num:=''''; 
           else
             vint_num = acm_nexttaxnum(pmmgg);
             vreg_num:=Text(vint_num)||vnum_end; 
           end if;

  
           insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_num,reg_date,id_client,int_num,auto,pay_p,decade)
           values(default,pid_pref,3,1,vreg_num,preg_date,pid_client,vint_num,1,2000,3) returning id_doc into vid_newtax;
  
           --   Raise Notice ''!!! Заголовок '';
  
           vheader:=1;
         end if;
  
         Raise Notice ''{{{- - Формирование строк НН по счету % }}}}'',vbill.id_doc;
   
         if vpref=''act_ee'' then 
         --строки счета, не погашенные корректировками
           for vbillstr in 
             select  bs.sumval-coalesce(sum(bt.sum_val),0) as sum_rest,
             bs.demandval-Coalesce(sum(bt.demand_val),0) as demand_rest,
             bs.id_tariff,bs.id_sumtariff,bs.id_zonekoef,bs.zone_koef
             from (select sum(bs1.sum_val) as sumval,sum(bs1.demand_val) as demandval, 
              max(bs1.id_tariff) as id_tariff, max(bs1.id_sumtariff) as id_sumtariff, 
              bs1.id_doc,bs1.id_zonekoef,coalesce(dz.koef,1) as zone_koef,round(t.value*coalesce(dz.koef,1),4) as tariff
              from acd_billsum_tbl as bs1 
              left join acd_zone_tbl as dz on (bs1.id_zonekoef = dz.id)
              left join acd_tarif_tbl as t on (bs1.id_sumtariff = t.id) 
              where bs1.id_doc =vbill.id_doc and bs1.sum_val<>0
              group by bs1.id_doc,tariff,bs1.id_zonekoef,zone_koef) as bs 
             left outer join acm_billtax_tbl as bt 
             using(id_doc,tariff,zone_koef,id_zonekoef)
             group by bs.id_doc,bs.id_sumtariff,bs.id_tariff,bs.id_zonekoef,bs.zone_koef,bs.demandval,bs.sumval
             having bs.sumval-coalesce(sum(bt.sum_val),0)<>0
             order by bs.id_sumtariff 
           loop
    
     
            vsum_pay_cur:=numeric_smaller(vsum_pay_bill,vbillstr.sum_rest);
            vsum_pay_bill:=vsum_pay_bill-vsum_pay_cur;
            exit when vsum_pay_cur=0;
      
            if vbillstr.id_sumtariff is not null then 
    
               select into vtariff round(value*vbillstr.zone_koef,4) from acd_tarif_tbl where id = vbillstr.id_sumtariff;
    
              if vtariff = 0 then 
                vdemand:=0;
              else
                vdemand:=round(vsum_pay_cur/vtariff);
              end if;
            else
             
              if (vbillstr.demand_rest is not null) and (vbillstr.demand_rest<>0 ) then 
  
                 vtariff = round(vbillstr.sum_rest/vbillstr.demand_rest,4);
              end if;

              if vtariff = 0 then 
                vdemand:=0;
              else
                vdemand:=round(vsum_pay_cur/vtariff);
              end if;
    
            end if;
    
      
            if vpref=''act_ee'' then 
      
             -- пересчет цены от полученных киловат
             if (vdemand <>0 ) then
               vsumtariff_math := Round(vsum_pay_cur/vdemand,acm_calc_tarif_prec(vdemand));
             else
               vsumtariff_math := vtariff;
             end if;

             insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,id_tariff,id_sumtariff,id_zonekoef)
             values(vid_newtax,vpay_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (оплата)'',
             vdemand,vsum_pay_cur,vsumtariff_math,vbillstr.id_tariff,vbillstr.id_sumtariff,vbillstr.id_zonekoef);

            end if;
     
------        Raise Notice ''тариф %'',vtariff;
------        Raise Notice ''на сумму  %'',vsum_pay_cur;
            -- запишем построчную информацию 
            insert into acm_billtax_tbl(id_doc,id_tax,id_sumtariff,tariff,sum_val,demand_val,zone_koef,id_zonekoef)
            values(vbill.id_doc,vid_newtax,vbillstr.id_sumtariff,vtariff,vsum_pay_cur,vdemand,vbillstr.zone_koef,vbillstr.id_zonekoef);
      
           end loop;
         end if;
        end if;
      end loop;
    else

    --------------- !!!!!!!!! обычный вариант !!!!!!!!!-------------------------------

      -- получим список оплаченных в этом месяце счетов и сумму, 
      -- на которую проплачен КАЖДЫЙ счет платежками текущего месяца
  
      -- нужно брать только платежи 3 декады, остальное ушло в аванс
      if (pmmgg < ''2015-08-01'') then
        select into vreg_date2 c_date
        from calendar where  date_trunc(''month'', c_date) = pmmgg  
        -- and coalesce(holiday,false) = false 
        and c_date >= pmmgg::date+''19 days''::interval
        order by c_date limit 1; 
      else
        -- с августа 2015 1-2 декады отменены, все идет по концу месяца
        vreg_date2 := (pmmgg::date - ''1 days''::interval)::date ;
      end if;


      for vbillpay in 
       select b.id_doc,coalesce(b.idk_doc,0) as idk_doc,b.reg_date,b.mmgg,b.mmgg_bill,sum(bp.value) as pay ,sum(bp.value_tax) as pay_tax, max(p.reg_date) as pay_date 
       from acm_billpay_tbl as bp 
       join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
       join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
       left join dci_document_tbl as dci on (p.idk_doc=dci.id)
       where b.id_client=pid_client and b.id_pref=pid_pref and b.idk_doc <> 201
       and bp.mmgg=pmmgg and p.mmgg=pmmgg
       and not exists (select id_doc from acm_pay_tbl as p2 where p2.mmgg = p.mmgg and p2.id_client = p.id_client and (date_part(''year'',p2.mmgg_pay) < date_part(''year'',p.mmgg_pay)) and p2.value_pay=-p.value_pay and p.value_pay>0) 
       and date_part(''year'',b.mmgg_bill) <> 1999 
       and dci.ident<>''writeoff''
       and b.value > 0
       and p.sign_pay = 1
       and p.reg_date > vreg_date2 
       group by b.id_doc,b.reg_date,b.mmgg,b.mmgg_bill,b.idk_doc
       order by b.mmgg, b.reg_date
      loop
  
       vsum_pay:=vsum_pay+vbillpay.pay;
       vsum_pay_tax:=vsum_pay_tax+vbillpay.pay_tax;
  
       vsum_pay_bill:=vbillpay.pay;

 
       if vheader=0 then
  
         --заголовок, пока без суммы
        -- с марта 2013 года неплатникам налоговая выписывается без номера
         if coalesce(vstcl.flag_taxpay,0) = 0  then
           vint_num = 0;
           vreg_num:=''''; 
         else
           vint_num = acm_nexttaxnum(pmmgg);
           vreg_num:=Text(vint_num)||vnum_end; 
         end if;
  
         insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_num,reg_date,id_client,int_num,auto,pay_p,decade)
         values(default,pid_pref,3,1,vreg_num,preg_date,pid_client,vint_num,1,2000,3) returning id_doc into vid_newtax;
  
  
         vheader:=1;
       end if;
  
       Raise Notice ''- - Формирование строк НН по счету %'',vbillpay.id_doc;
   
  
        --удалить информацию о использовании строк данного счета 
        delete from acm_billtax_tbl where id_doc=vbillpay.id_doc;
  
        if vpref=''act_ee'' then
           perform acm_createTaxCorrect(vbillpay.id_doc,preg_date);
        end if;
  
   
        if vpref=''act_ee'' then 
         --строки счета, не погашенные корректировками
         for vbillstr in 
           select  bs.sumval-coalesce(sum(bt.sum_val),0) as sum_rest,
           bs.demandval-Coalesce(sum(bt.demand_val),0) as demand_rest,
           bs.id_tariff,bs.id_sumtariff,bs.id_zonekoef,bs.zone_koef
           from (select sum(bs1.sum_val) as sumval,sum(bs1.demand_val) as demandval, 
            max(bs1.id_tariff) as id_tariff, max(bs1.id_sumtariff) as id_sumtariff, 
            bs1.id_doc,bs1.id_zonekoef,coalesce(dz.koef,1) as zone_koef,round(t.value*coalesce(dz.koef,1),4) as tariff
            from acd_billsum_tbl as bs1 
            left join acd_zone_tbl as dz on (bs1.id_zonekoef = dz.id)
            left join acd_tarif_tbl as t on (bs1.id_sumtariff = t.id) 
            where bs1.id_doc =vbillpay.id_doc and bs1.sum_val<>0
            group by bs1.id_doc,tariff,bs1.id_zonekoef,zone_koef) as bs 
           left outer join acm_billtax_tbl as bt 
           using(id_doc,tariff,zone_koef,id_zonekoef)
           group by bs.id_doc,bs.id_sumtariff,bs.id_tariff,bs.id_zonekoef,bs.zone_koef,bs.demandval,bs.sumval
           having bs.sumval-coalesce(sum(bt.sum_val),0)<>0
           order by bs.id_sumtariff 
         loop
  
  
          vsum_pay_cur:=numeric_smaller(vsum_pay_bill,vbillstr.sum_rest);
          vsum_pay_bill:=vsum_pay_bill-vsum_pay_cur;

           Raise Notice '' строка счета : vsum_pay_cur %, vsum_pay_bill % '',vsum_pay_cur , vsum_pay_bill;

          exit when vsum_pay_cur=0;
    
          if vbillstr.id_sumtariff is not null then 
  
             select into vtariff round(value*vbillstr.zone_koef,4) from acd_tarif_tbl where id = vbillstr.id_sumtariff;
  
            if vtariff = 0 then 
              vdemand:=0;
            else
              vdemand:=round(vsum_pay_cur/vtariff);
            end if;
          else

            if (vbillstr.demand_rest is not null) and (vbillstr.demand_rest<>0 ) then 
                vtariff = round(vbillstr.sum_rest/vbillstr.demand_rest,4);
            end if;

            if vtariff = 0 then 
              vdemand:=0;
            else
              vdemand:=round(vsum_pay_cur/vtariff);
            end if;

 
          end if;
  
    
          if vpref=''act_ee'' then 
    
  
      --     Raise Notice '' !!!! vheader % '',vheader;

             -- пересчет цены от полученных киловат
           if (vdemand <>0 ) then
             vsumtariff_math := Round(vsum_pay_cur/vdemand,acm_calc_tarif_prec(vdemand));
           else
             vsumtariff_math := vtariff;
           end if;

  
           insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,
           id_tariff,id_sumtariff,id_zonekoef)
           values(vid_newtax,vpay_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (оплата)'',
           vdemand,vsum_pay_cur,vsumtariff_math,vbillstr.id_tariff,vbillstr.id_sumtariff,vbillstr.id_zonekoef);
  
          end if;
   
          -- запишем построчную информацию 
          insert into acm_billtax_tbl(id_doc,id_tax,id_sumtariff,tariff,sum_val,demand_val,zone_koef,id_zonekoef)
          values(vbillpay.id_doc,vid_newtax,vbillstr.id_sumtariff,vtariff,vsum_pay_cur,vdemand,vbillstr.zone_koef,vbillstr.id_zonekoef);
    
         end loop;
        end if;
       --end if;
       ----------для абонента 3132 ДСП ЧАЕС в мае 2012 надо выписать отдельную НН на каждый оплачиваемый месяц
/*
       if ((vrescod=330) and (pid_client=2675)) or (vsplit_tax=1) then

        if vheader=1 then

         Raise Notice ''Split mode - creating new NN '';
         if ((round(vsum_pay/5,2) >=vlimit) or (vsum_pay_tax >vlimit )) and (getsysvar(''tax_div'')=1) then
           update acm_tax_tbl set value=vsum_pay ,value_tax=round(vsum_pay/5,2)
           where id_doc=vid_newtax;
     
           if vsum_pay_tax <> round(vsum_pay/5,2) then
       
             vvalue_tax_math:=round(vsum_pay/5,2);
         
             insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
             values(pid_client,pid_pref,vid_newtax,pmmgg,vsum_pay,vvalue_tax_math,vsum_pay_tax);
   
           end if;
         else
      
           update acm_tax_tbl set value=vsum_pay ,value_tax=vsum_pay_tax
           where id_doc=vid_newtax;
         end if;


         if vpref=''react_ee'' then 
           --Для реактива запишем одну сторку, т.к. там нет тарифов.
           insert into acd_tax_tbl(id_doc,dt_bill,unit,text,demand_val,sum_val7,tariff,id_tariff,id_sumtariff)
           values(vid_newtax,vpay_date,''послуга'',''Плата за перетiкання реактивної електроенергiї (оплата)'',
           1,vsum_pay,vsum_pay,0,0);

         end if;


         if (vpref=''2kr_d'') then

           insert into acd_tax_tbl(id_doc,dt_bill,unit,text,demand_val,sum_val7,tariff, id_tariff,id_sumtariff)
           values(vid_newtax,vpay_date,''шт'',''Пiдвищена плата за споживання електроенергiї понад договiрну величину.'',
           1,vsum_pay,vsum_pay, 0,0);
 
         end if;

         vheader:=0;
         vsum_pay:=0;
         vsum_pay_tax:=0;
        end if;
       end if;
*/
        -------------------------------------------------------------

      end loop;

    end if;

    -- запишем посчитанную общую сумму

    if vheader=1 then
/*
     if ((round(vsum_pay/5,2) >=vlimit) or (vsum_pay_tax >vlimit )) and (getsysvar(''tax_div'')=1) then

       update acm_tax_tbl set value=vsum_pay ,value_tax=round(vsum_pay/5,2)
       where id_doc=vid_newtax;

       if vsum_pay_tax <> round(vsum_pay/5,2) then

         vvalue_tax_math:=round(vsum_pay/5,2);

         insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
         values(pid_client,pid_pref,vid_newtax,pmmgg,vsum_pay,vvalue_tax_math,vsum_pay_tax);

       end if;
     else
*/
       update acm_tax_tbl set value=vsum_pay ,value_tax=vsum_pay_tax
       where id_doc=vid_newtax;

--     end if;

     if vpref=''react_ee'' then 
     --Для реактива запишем одну сторку, т.к. там нет тарифов.
      insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,text,demand_val,sum_val7,tariff,
      id_tariff,id_sumtariff)
      values(vid_newtax,vpay_date,''грн'',''2454'',''Плата за перетiкання реактивної електроенергiї (оплата)'',
      1,vsum_pay,vsum_pay,0,0);

     end if;


     if (vpref=''2kr_d'') then

      insert into acd_tax_tbl(id_doc,dt_bill,unit,text,demand_val,sum_val7,tariff,
      id_tariff,id_sumtariff)
      values(vid_newtax,vpay_date,''шт'',''Пiдвищена плата за споживання електроенергiї понад договiрну величину.'',
      1,vsum_pay,vsum_pay, 0,0);
 
     end if;


    end if;

--   end if;
     Raise Notice ''- - )))))))))))))))))))) pay fin ))))))))))))))))))))))) -  - - '';
   return vid_newtax;
  end;
' LANGUAGE 'plpgsql';


----------------------------------------------------------------------------------------------------



drop view acv_taxadvtariff;

CREATE VIEW acv_taxadvtariff(id_doc,reg_date,reg_num,id_client,id_pref,tariff,id_tariff,id_sumtariff,sum_rest,mmgg)
AS

 select adv.id_doc,adv.reg_date, adv.reg_num,adv.id_client,adv.id_pref,ads.tariff,ads.id_tariff, ads.id_sumtariff,
 (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0) as sum_rest,adv.mmgg
            
 -- НН на аванс всегда содержит только одну строку, погашений аванса может быть 
 -- несколько
 from 
 (select * from acm_tax_tbl  where kind_calc in (2,21,7) and disabled = 0 order by id_doc ) as adv 
 join acd_tax_tbl as ads on (adv.id_doc=ads.id_doc )
 left join 
 (select id_advance, sum(sum_val) as sum_cor
 from acm_taxadvcor_tbl group by id_advance order by id_advance) as ac
 on (ac.id_advance=adv.id_doc)
 where (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0)>0 
  order by adv.reg_date;

-----------------------------------------------------------------------------------------

