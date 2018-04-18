create or replace function acm_rep() returns boolean as'
  declare

   vreg_date date;
   vmmgg     date; 
   vclient   record;
   vid_pref20 int;
   vid_prefre int;
   vid_pref0 int;
   v boolean;
   vbillpay     record;
  dtt date;
  begin


    vmmgg:=fun_mmgg();

    -- найдем последний рабочий день в месяце
    select into vreg_date c_date
    from calendar where  (date_trunc(''month'', c_date) =  date_trunc(''month'', vmmgg))  and holiday is NULL 
    order by c_date desc limit 1; 

    Raise Notice '' дата % mmgg %.'',vreg_date,vmmgg;

--    delete from acm_tax_tbl where auto = 1 and mmgg= vmmgg;


    perform seb_all(0,vmmgg);

    update seb_obrs_tmp set b_dtval=0,b_ktval=b_ktval-b_dtval,
                    b_dtval_tax=0,b_ktval_tax=b_ktval_tax-b_dtval_tax
             where b_dtval<0;

    update seb_obrs_tmp set e_dtval=0,e_ktval=e_ktval-e_dtval,
                    e_dtval_tax=0,e_ktval_tax=e_ktval_tax-e_dtval_tax
             where e_dtval<0;

--    perform seb_obrr(vmmgg);

    Raise Notice '' - - - -  - -  - -'';

    -- все клиенты-юридические лица
    -- из -за оборотки делаем в 2 захода
    -- активная
    for vclient in 
     select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv
     from clm_client_tbl as cm 
     left join clm_statecl_tbl as cp on (cp.id_client=cm.id)
--     left join acm_saldo_tbl as s on (s.id_client=cm.id and s.mmgg=vmmgg)
     join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
     left join aci_pref_tbl as p on (p.id=s.id_pref)
     where cm.book = -1  and s.id_pref = 10 
     and cm.idk_work = 1
     and cp.id_section not in (206,207,205,208)  
     order by s.id_pref, cm.code
    loop

      Raise Notice '' абонент % вид %.'',vclient.id,vclient.id_pref;

     if (vclient.flag_budjet=0) then
      v:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date);
     end if;

     -- все бюджетники
     if (vclient.flag_budjet=1) then

      v:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

     end if;

     -- есть кредитовое сальдо на конец месяца
     if  (vclient.kr_zkme <> 0) then

      v:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date,1);

     end if;

    end loop;
    -----------------------------------------------------------------------------
  
  --реактив
    for vclient in 
     select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv
     from clm_client_tbl as cm left join clm_statecl_tbl as cp on (cp.id_client=cm.id)
--     left join acm_saldo_tbl as s on (s.id_client=cm.id and s.mmgg=vmmgg)
     join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
     left join aci_pref_tbl as p on (p.id=s.id_pref)
     where cm.book = -1 
     and cm.idk_work = 1 and s.id_pref = 20
     and cp.id_section not in (206,207,205,208)  
     order by s.id_pref, cm.code
    loop

      Raise Notice '' абонент % вид %.'',vclient.id,vclient.id_pref;

     if (vclient.flag_budjet=0) then
      v:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date);
     end if;

     -- все бюджетники
     if (vclient.flag_budjet=1) then

      v:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);

     end if;

     -- есть кредитовое сальдо на конец месяца
     if  (vclient.kr_zkme <> 0) then

      v:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date,1);

     end if;

    end loop;

  --2-кр потребление
    for vclient in 
     select cm.id,cp.flag_budjet,s.id_pref,s.opl_ze, s.kr_zkme,s.kr_zkmpdv
     from clm_client_tbl as cm left join clm_statecl_tbl as cp on (cp.id_client=cm.id)
     join seb_obr_all_tmp as s on (s.id_client=cm.id and s.period=vmmgg)
     left join aci_pref_tbl as p on (p.id=s.id_pref)
     where cm.book = -1  and s.id_pref = 520
     and cm.idk_work = 1
     and cp.id_section not in (206,207,205,208)  
     order by s.id_pref, cm.code
    loop

      Raise Notice '' абонент % вид %.'',vclient.id,vclient.id_pref;

     if (vclient.flag_budjet=0) then
       v:= acm_createTaxBillEnd(vclient.id,vclient.id_pref,vmmgg,vreg_date);
     end if;

     -- все бюджетники
     if (vclient.flag_budjet=1) then
       v:= acm_createTaxPay(vclient.id,vclient.id_pref,vmmgg,vreg_date,0);
     end if;

     -- есть кредитовое сальдо на конец месяца
     if  ((vclient.kr_zkmpdv <> 0) and (vclient.kr_zkme <> 0)) then

      v:= acm_createTaxAdvance(vclient.id,vclient.id_pref,vmmgg,vreg_date,1);

     end if;

    end loop;

    -----------------------------------------------------------------------------------------------------------
    --  НН на оплату старых долгов 1999 -2000 г. небюджетных
    v:= acm_createTaxOldPay(vmmgg,vreg_date);

    --  НН на оплату льгот/субсидий
    v:= acm_createTaxLgt(vmmgg,vreg_date);

    --  НН на физлиц
--    Raise Notice '' acm_createTaxFiz( % ,% )'',vmmgg,vreg_date;
    v:= acm_createTaxFiz(vmmgg,vreg_date);
--    Raise Notice '' acm_createTaxFiz( % ,% ) Ok'',vmmgg,vreg_date;


    --НН на оплату используютbillpay, поэтому нужна проверка 
    -- для бюджетников сумма оплаты должна совпадать с суммой всех НН (оплата+аванс)
    delete from acm_taxpayerr_tbl;

    insert into acm_taxpayerr_tbl(id_client,id_pref,sum_nn,tax_nn,sum_pay,tax_pay,sum_dif,tax_dif)
    select s1.id_client,s1.id_pref, coalesce(s1.sum_nn,0) as sum_nn, coalesce(s1.tax_nn,0) as tax_nn, coalesce(s2.sum_pay,0) as sum_pay,
    coalesce(s2.tax_pay,0) as tax_pay ,
    coalesce(sum_nn,0)-coalesce(sum_pay,0) as dif_sum, coalesce(tax_nn,0) - coalesce(tax_pay,0) as dif_tax from 
    (select p.id_pref, p.id_client, sum(value) as sum_nn, sum(value_tax) as tax_nn
    from acm_tax_tbl as p 
     join clm_client_tbl as c on (c.id = p.id_client)
     join clm_statecl_tbl as scl on (p.id_client= scl.id_client)
    where  p.mmgg= vmmgg and  flag_budjet = 1
    and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)
     group by p.id_client,p.id_pref ) as s1 
    left join
    (select p.id_pref, p.id_client, sum(value) as sum_pay , sum(value_tax) as tax_pay
    from acm_pay_tbl as p 
     join clm_client_tbl as c on (c.id = p.id_client)
     join clm_statecl_tbl as scl on (p.id_client= scl.id_client)
    where  p.mmgg= vmmgg and flag_budjet = 1 and p.sign_pay = 1
    and c.idk_work not in (0,99) and coalesce(c.id_state,0) not in (50,99)
     group by p.id_client ,p.id_pref
    ) as s2 using (id_client,id_pref)
--    join clm_client_tbl as c on (c.id = s2.id_client)
    where (coalesce(sum_nn,0)-coalesce(sum_pay,0) <>0 )or (coalesce(tax_nn,0) - coalesce(tax_pay,0) <>0);

 dtt=coalesce(getsysvarC(''dt_start_prg''),''2005-08-01'');
 
 -- Raise Notice '':::::::::::::::::::                              %'',dtt;

   delete from acm_taxcorrection_tbl where tax_date<dtt and (flock=0 or flock is null) and mmgg>=''2006-03-01'';

    return true;
  end;
' LANGUAGE 'plpgsql';
