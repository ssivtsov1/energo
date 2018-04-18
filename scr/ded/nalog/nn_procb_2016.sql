;
set client_encoding='win';

alter table clm_position_tbl add column inn varchar(10);
ALTER TABLE clm_statecl_tbl ADD COLUMN filial_num character varying(4);
ALTER TABLE clm_statecl_h ADD COLUMN filial_num character varying(4);

ALTER TABLE acd_taxcorrection_tbl ADD COLUMN line_no integer;
ALTER TABLE acd_taxcorrection_tbl ALTER COLUMN line_no SET DEFAULT 1;
select del_notrigger('acd_taxcorrection_tbl','update acd_taxcorrection_tbl set line_no = 1 where line_no is null');


update acd_tax_tbl set uktzed = '35.12' where mmgg= '2017-03-01' and unit = 'грн' and uktzed is null;

create or replace function acm_CloseTaxMonth2016( ) returns boolean as'
  declare

--   pdecade    alias for $1;
   vreg_date    date;
--   vreg_date2    date;
--   vreg_date3    date;
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

    if (vmmgg < ''2016-01-01'') then
       return false;
    end if;


    select into vreg_date c_date
    from calendar where  date_trunc(''month'', c_date) =  vmmgg  
    --and coalesce(holiday,false) = false 
    order by c_date desc limit 1; 
    

    vdate_start = vmmgg;
    vdate_end = vreg_date;


    Raise Notice '' период с % по % mmgg %.'',vdate_start, vdate_end,vmmgg;


--      delete from acm_taxadvcor_tbl where mmgg = vmmgg;

--      if vmmgg =''2015-01-01''::date then
--      v:= acm_tax_correction_restore(null, (vmmgg::date - ''1 month''::interval)::date );
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

--       if (vclient.flag_budjet=0) then

--        vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date3);

--       end if;

--       -- все бюджетники
--       if (vclient.flag_budjet=1) then

         vint:= acm_createTaxPay2016(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

--       end if;
     
--       -- есть кредитовое сальдо на конец месяца
--       if  (vclient.kr_zkme <> 0) then

--        vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date3,1);

--       end if;

      end loop;
    -----------------------------------------------------------------------------
    if (vmmgg < ''2016-03-01'') then  
      --реактив пока по старому
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

        vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date);

       end if;

       -- все бюджетники
       if (vclient.flag_budjet=1) then

        vint:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

       end if;

       -- есть кредитовое сальдо на конец месяца
       if  (vclient.kr_zkme <> 0) then

        vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date,1);

       end if;

      end loop;

    else
      --реактив по новому с марта 2016
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

        vint:= acm_createTaxPay2016(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

       /*
       if (vclient.flag_budjet=0) then

        vint:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date);

       end if;

       -- все бюджетники
       if (vclient.flag_budjet=1) then

        vint:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

       end if;

       -- есть кредитовое сальдо на конец месяца
       if  (vclient.kr_zkme <> 0) then

        vint:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date,1);

       end if;
       */
      end loop;


    end if;

      -- льготы
      v:= acm_createTaxLgt2016(vmmgg,vreg_date);

       --  НН на физлиц
      v:= acm_createTaxFiz2016(vmmgg,vreg_date);

--    end if;


    vint:=acm_createTaxNotPayerDecade(vmmgg,10,vdate_start, vdate_end, 3);
    vint:=acm_createTaxNotPayerDecade(vmmgg,20,vdate_start, vdate_end, 3);


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
create or replace function acm_createTaxPay2016(int,int, date, date, int ) returns int as'
  declare 

     pid_client   alias for $1;
     pid_pref     alias for $2;
     pmmgg        alias for $3;
     preg_date    alias for $4;
     prebuild     alias for $5;

     vsaldo       record;
     vktsaldo     record;
     vktmove      record;
     vktsaldo_old record;
     vpay         record;
     vpay_all     record;
     vpay_old     record;
     vpay_pkee    record;
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
    where id_client = pid_client and mmgg = pmmgg and kind_calc = 8 and id_pref = pid_pref and reg_date = preg_date and disabled = 0;

    if found then 

      if prebuild = 0 then 
        Raise notice ''Налоговая накладная на платежи уже сформирована.'';
        return -2;
      end if;
    end if;


  if prebuild = 1 then 
     perform seb_one( pmmgg ,0 ,pid_client );
  end if;


  select into vpref ident from aci_pref_tbl where id=pid_pref;

  select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h 
      where id_client = pid_client and mmgg_b <= pmmgg order by mmgg_b desc limit 1;

 -- дебет на начало периода 15 года и ранее
  select into vsaldo 
  coalesce(-ss.deb_kme,0)-coalesce(-ss.deb_km16e,0) as edt,
  coalesce(-ss.deb_kmpdv,0)-coalesce(-ss.deb_km16pdv,0) as edt_tax,

  coalesce(-ss.deb_zpme,0)-coalesce(-ss.deb_pm16e,0) as bdt,
  coalesce(-ss.deb_zpmpdv,0)-coalesce(-ss.deb_pm16pdv,0) as bdt_tax

  from seb_obr_all_tmp as ss
  join clm_client_tbl as c on (c.id = ss.id_client)
  where id_client=pid_client and id_pref=pid_pref and mmgg = pmmgg ;


  Raise Notice '' дебет нач %'',vsaldo.bdt;  
  Raise Notice '' дебет нач ндс %'',vsaldo.bdt_tax;  


--  Raise Notice ''Налоговая накладная на оплату для абонента % '',pid_client ;
  ------------------------------------------------------------------

  

  if vpref=''act_ee'' then  
    -- актив ввели с начала года 2016
    select into vpay_old  sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     where 
         p.id_client=pid_client
     and p.mmgg = pmmgg
     and p.id_pref = pid_pref
     and bp.value <> 0 
     and p.value > 0 
     and b.mmgg_bill >= ''2001-01-01''
     and date_part(''year'',b.mmgg_bill) < 2016 
     and b.id_pref = pid_pref;


     -- отдельно оплата по актам ПКЕЕ (с октября 2016)
    select into vpay_pkee sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     where 
         p.id_client=pid_client
     and p.mmgg = pmmgg
     and p.id_pref = pid_pref
     and p.value > 0 
     and b.idk_doc = 209
     and bp.value <> 0 
     and date_part(''year'',b.mmgg_bill) >= 2016 
     and b.id_pref = pid_pref;



  end if;

  if vpref=''react_ee'' then 
    -- реактив с марта 2016
    select into vpay_old  sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     where 
         p.id_client=pid_client
     and p.mmgg = pmmgg
     and p.id_pref = pid_pref
     and bp.value <> 0 
     and p.value > 0 
     and b.mmgg_bill >= ''2001-01-01''
     and b.mmgg_bill <= ''2016-02-01''
     and b.id_pref = pid_pref;


  end if;

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
/*
  select into vpay numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
  from acm_pay_tbl as p
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg  
  and p.reg_date >= pstart_date and p.reg_date <= preg_date
  and p.idk_doc = 100
  and p.sign_pay = 1;
*/
  select into vpay numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
  from acm_pay_tbl as p
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg  
  and p.reg_date <= preg_date
  --and p.idk_doc = 100
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
    
--    Raise Notice ''vsaldo.bdt % '',vsaldo.bdt;
--    Raise Notice ''vsaldo.edt % '',vsaldo.edt;

    Raise Notice ''vpay_old.sum_val % '',vpay_old.sum_val;
    Raise Notice ''vpay_old.sum_tax % '',vpay_old.sum_tax;

--    vvalue:=numeric_smaller(vpay.pay, numeric_larger(vpay.pay-coalesce(vsaldo.bdt-vsaldo.edt,0),0));
--    vvalue_tax:=numeric_smaller(vpay.pay_pdv, numeric_larger(vpay.pay_pdv-coalesce(vsaldo.bdt_tax-vsaldo.edt_tax,0),0));

    vvalue:=numeric_smaller(vpay.pay, numeric_larger(vpay.pay-coalesce(vpay_old.sum_val,0),0));
    vvalue_tax:=numeric_smaller(vpay.pay_pdv, numeric_larger(vpay.pay_pdv-coalesce(vpay_old.sum_tax,0),0));

  else
    vvalue:=numeric_larger(vpay.pay, 0);
    vvalue_tax:=numeric_larger(vpay.pay_pdv,0);
  end if;


  if (vpref=''act_ee'') then 
    if (coalesce(vpay_pkee.sum_val,0)<>0) then  

      vvalue    :=numeric_larger(vvalue-numeric_larger(vpay_pkee.sum_val,0), 0);
      vvalue_tax:=numeric_larger(vvalue_tax-numeric_larger(vpay_pkee.sum_tax,0),0);
    end if;
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
   values(default, pid_pref,8,0,vreg_date,vreg_num,pid_client,vvalue,vvalue_tax,vint_num,1,pmmgg,3) returning id_doc into vid_new;


   -- строка
   -- тариф по 2 классу промышленности независимо от обонента 
   if vpref=''react_ee'' then 
     --для реактива есть один спец. тариф
     select into vid_tariff id from aci_tarif_tbl where ident = ''clc_re'' LIMIT 1 ;
   else
     -- для активной берем пром<750.2кл
     select into vid_tariff id from aci_tarif_tbl where ident = ''clc_ae'' LIMIT 1 ;
   end if;


    -- самая свежая сумма тарифа
    select into vsumtariff t.id, t.value 
    from acd_tarif_tbl AS t
    where t.id_tarif=vid_tariff
    and t.dt_begin::date = (select max(dt_begin::date)
                            from acd_tarif_tbl 
                            where id_tarif=vid_tariff and dt_begin::date<(pmmgg+''1 month - 1 day''::interval));

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

     insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff,mmgg)
     values(vid_new,vreg_date,''грн'',''2454'',''35.12'',''Плата за перетiкання реактивної електроенергiї (оплата)'',
     1,vvalue,vvalue,vid_tariff,vsumtariff.id,pmmgg);

    end if;

--    return vid_new;
  else
    vid_new:=0;
--    return 0;
  end if;

  if (vpref=''act_ee'') then

    if (coalesce(vpay_pkee.sum_val,0)<>0) and (prebuild = 0) then  

     perform acm_createTaxPayPKEE2016(pid_client,pid_pref, pmmgg, preg_date, 0 );

    end if;
  end if;


  return vid_new;

  end;
' LANGUAGE 'plpgsql';


-----------------------------------------------------------------------------

create or replace function acm_createTaxPayPKEE2016(int,int, date, date, int ) returns int as'
  declare 

     pid_client   alias for $1;
     pid_pref     alias for $2;
     pmmgg        alias for $3;
     preg_date    alias for $4;
     prebuild     alias for $5;

     vsaldo       record;
     vktsaldo     record;
     vktmove      record;
     vktsaldo_old record;
     vpay         record;
     vpay_all     record;
     vpay_old     record;
     vpay_pkee    record;
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
    where id_client = pid_client and mmgg = pmmgg and kind_calc = 9 and id_pref = pid_pref and reg_date = preg_date and disabled = 0;

    if found then 

      if prebuild = 0 then 
        Raise notice ''Налоговая накладная на оплату акта ПКЕЕ уже сформирована.'';
        return -2;
      end if;
    end if;


  select into vpref ident from aci_pref_tbl where id=pid_pref;

  if vpref<>''act_ee'' then  
        return -2;
  end if;

  if prebuild = 1 then 
     perform seb_one( pmmgg ,0 ,pid_client );
  end if;




  select into vstcl flag_budjet,flag_taxpay  from clm_statecl_h 
      where id_client = pid_client and mmgg_b <= pmmgg order by mmgg_b desc limit 1;



--  Raise Notice ''Налоговая накладная на оплату для абонента % '',pid_client ;
  ------------------------------------------------------------------

    -- отдельно оплата по актам ПКЕЕ
    select into vpay_pkee sum(bp.value) as sum_val, sum(bp.value_tax) as sum_tax
     from acm_billpay_tbl as bp
     join acm_bill_tbl as b on (b.id_doc=bp.id_bill)
     join acm_pay_tbl as p on (p.id_doc=bp.id_pay)
     where 
         p.id_client=pid_client
     and p.mmgg = pmmgg
     and p.id_pref = pid_pref
     and p.value > 0 
     and b.idk_doc = 209
     and bp.value <> 0 
     and date_part(''year'',b.mmgg_bill) >= 2016 
     and b.id_pref = pid_pref;


  select into vpay numeric_larger(coalesce(sum(p.value),0),0) as pay, numeric_larger(coalesce(sum(p.value_tax),0),0) as pay_pdv 
  from acm_pay_tbl as p
  where p.id_client=pid_client and p.id_pref=pid_pref and p.mmgg = pmmgg  
  and p.reg_date <= preg_date
  and p.sign_pay = 1;
  /*
  raise notice '' pid_pref %'',pid_pref;
  raise notice '' preg_date  %'',preg_date;
  raise notice '' pstart_date  %'',pstart_date;
  raise notice ''vstcl.flag_budjet  %'',vstcl.flag_budjet;

   Raise Notice '' сумма оплаты для налоговой1 %'',vvalue;  
   Raise Notice '' сумма оплаты для налоговой1 ПДВ %'',vvalue_tax;  
    */



   vvalue    :=numeric_smaller(numeric_larger(vpay.pay, 0),numeric_larger(vpay_pkee.sum_val,0));
   vvalue_tax:=numeric_smaller(numeric_larger(vpay.pay_pdv,0),numeric_larger(vpay_pkee.sum_tax,0));


  if vvalue >0 or vvalue_tax >0 then

   Raise Notice '' сумма актов ПКЕЕ для налоговой %'',vvalue;  
   Raise Notice '' сумма актов ПКЕЕ для налоговой ПДВ %'',vvalue_tax;  

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
   values(default, pid_pref,9,0,vreg_date,vreg_num,pid_client,vvalue,vvalue_tax,vint_num,1,pmmgg,3) returning id_doc into vid_new;


   -- строка
   -- тариф по 2 классу промышленности независимо от обонента 
   if vpref=''react_ee'' then 
     --для реактива есть один спец. тариф
     select into vid_tariff id from aci_tarif_tbl where ident = ''clc_re'' LIMIT 1 ;
   else
     -- для активной берем пром<750.2кл
     select into vid_tariff id from aci_tarif_tbl where ident = ''clc_ae'' LIMIT 1 ;
   end if;


    -- самая свежая сумма тарифа
    select into vsumtariff t.id, t.value 
    from acd_tarif_tbl AS t
    where t.id_tarif=vid_tariff
    and t.dt_begin::date = (select max(dt_begin::date)
                            from acd_tarif_tbl 
                            where id_tarif=vid_tariff and dt_begin::date<(pmmgg+''1 month - 1 day''::interval));

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

    insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff,
    id_tariff,id_sumtariff,id_zonekoef,mmgg)
     values(vid_new,vreg_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю акт (оплата)'',
      vdemand,vvalue,vsumtariff_math,vid_tariff,vsumtariff.id,1,pmmgg);

    return vid_new;
  else
    return 0;
  end if;

  end;
' LANGUAGE 'plpgsql';


-----------------------------------------------------------------------------

create or replace function acm_rebuildTax2016(int) returns int as'
  declare 

     pid_doc      alias for $1;
     vtax 	  record;

     vreg_date    date;
--     vreg_date2    date;
--     vreg_date3    date;
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


    select into vreg_date c_date
    from calendar where  date_trunc(''month'', c_date) = vmmgg  
    --and coalesce(holiday,false) = false 
    order by c_date desc limit 1; 


    vdate_start = vmmgg;
    vdate_end = vreg_date;


    delete from acm_tax_tbl where id_doc = pid_doc;

    if vtax.kind_calc = 9 then 

      vid_new:= acm_createTaxPayPKEE2016(vtax.id_client, vtax.id_pref, vmmgg, vreg_date, 1 );

    end if;

    if vtax.kind_calc = 8 then 

      vid_new:= acm_createTaxPay2016(vtax.id_client, vtax.id_pref, vmmgg, vreg_date, 1 );

    end if;


    if vtax.kind_calc = 7 then 

      vid_new:= acm_createTaxPayDecade(vtax.id_client, vtax.id_pref, vtax.decade, vmmgg, vdate_start, vdate_end, 1 );

    end if;


    if vtax.kind_calc = 5 then 

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

create or replace function acm_RebuildTaxMonth2016(int) returns boolean as'
  declare

   pid_client   alias for $1;
--   pdecade    alias for $2;
--   pmmgg      alias for $3;

   vreg_date    date;
--   vreg_date2    date;
--   vreg_date3    date;
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

    if (vmmgg < ''2016-01-01'') then
       return false;
    end if;


    select into vreg_date c_date
    from calendar where  date_trunc(''month'', c_date) =  vmmgg  
    --and coalesce(holiday,false) = false 
    order by c_date desc limit 1; 
  
    vdate_start = vmmgg;
    vdate_end = vreg_date;


    Raise Notice '' период с % по % mmgg %.'',vdate_start, vdate_end,vmmgg;


    delete from acm_tax_tbl where id_client = pid_client and mmgg= vmmgg and coalesce(flag_transmis,0) = 0 and disabled = 0;


    if (pid_client=getsysvar(''id_abon_taxn'')) then

      vint:=acm_createTaxNotPayerDecade(vmmgg,10,vdate_start, vdate_end, 3);
      vint:=acm_createTaxNotPayerDecade(vmmgg,20,vdate_start, vdate_end, 3);

    else


      -- третья декада - закрытие месяца практически по старому алгоритму,
      -- оплаты первых декад воспринимаем как авансы
--      if pdecade = 3 then

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


          vint:= acm_createTaxPay2016(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);


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

         if (vmmgg < ''2016-03-01'') then  


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

         else

           vint:= acm_createTaxPay2016(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

         end if;

        end loop;

      --end if;


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



----------------------------------------------------------------------------------------------------
create or replace function acm_CheckTaxOnClose(date) returns boolean as'
  declare 
     pmmgg alias for $1;
  begin

  if (select count(*) from acm_tax_tbl where kind_calc = 8 and auto = 1 and mmgg = pmmgg) = 0 then 

    insert into sys_error_tbl(nam,ident,id_error) values (''notax'',''notax'',22);
    return false;
  end if;

  return true;
  end;
' LANGUAGE 'plpgsql';
----------------------------------------------------------------------------------------------------
