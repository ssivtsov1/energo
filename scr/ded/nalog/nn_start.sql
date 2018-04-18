--viev, которое должно показывать незакрытые авансы с тарифами
-- и непогашенную сумму по каждому 
drop view acv_taxadvtariff;
CREATE VIEW acv_taxadvtariff(id_doc,reg_date,reg_num,id_client,id_pref,tariff,id_tariff,id_sumtariff,sum_rest)
AS

 select adv.id_doc,adv.reg_date, adv.reg_num,adv.id_client,adv.id_pref,ads.tariff,ads.id_tariff, ads.id_sumtariff,
 (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0) as sum_rest
 -- НН на аванс всегда содержит только одну строку, погашений аванса может быть 
 -- несколько
 from 
 (acm_tax_tbl as adv left join acd_tax_tbl as ads on (adv.id_doc=ads.id_doc and kind_calc in (2,21)  ))
 left outer join 
 (select id_advance, sum(demand_val) as demand_cor, sum(sum_val) as sum_cor
 from acm_taxadvcor_tbl group by id_advance) as ac
 on (ac.id_advance=adv.id_doc)
 where (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0)>0 
 order by adv.reg_date;



create or replace function acm_createTaxStartAdvance() returns boolean as'
  declare 
     vsaldo       record;
     vreg_num     varchar;
     vreg_date    date;
     vnum_end     varchar;
     vvalue	  numeric(14,4);
     vvalue_tax   numeric(14,4);
     vpref        varchar;
     vtariff      numeric(14,4);
     vid_tariff   int;
     vsumtariff    record;
     vmaintariff   record;
     vdemand      numeric(14,4);
     vflag_budjet int;
     vid_tax      int;
     vint_num int;
     vmmgg  date;
     vmmgg_1  date;

  begin


    vmmgg = ''2005-08-01''::date;
    vmmgg_1 = vmmgg-''1 month''::interval;

    vreg_date = ''2005-07-31''::date;

    select into vnum_end value_ident from syi_sysvars_tbl 
    where ident=''tax_num_ending'';


    perform seb_obr(vmmgg);
    perform seb_obrr(vmmgg);


    delete from acm_tax_tbl where auto = 1 and kind_calc =21;

    --все, кто имел кредитовое сальдо на начало месяца (АЕ)
    for vsaldo in 
     select cm.id as id_client,s.id_pref,coalesce(s.kr_zpme,0) as kr_zpme, coalesce(s.kr_zpmpdv,0) as kr_zpmpdv, cm.code
     from clm_client_tbl as cm 
     left join clm_statecl_tbl as cp on (cp.id_client=cm.id)
     join seb_obr as s on (s.id_client=cm.id)
     where cm.book = -1 
     and cm.idk_work = 1
     and s.kr_zpme<>0 
     and s.period=vmmgg
     order by cm.code
    loop

      Raise Notice '' kr_start:  абонент % (%) вид % сумма %.'',vsaldo.id_client,vsaldo.code,vsaldo.id_pref,vsaldo.kr_zpme;

      vvalue:=vsaldo.kr_zpme;         
      vvalue_tax:=vsaldo.kr_zpmpdv;  


      vint_num = acm_nexttaxnum(vmmgg_1);
      vreg_num:=Text(vint_num)||vnum_end;


      --заголовок
      insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,int_num,mmgg,auto)
      values(10,21,0,vreg_date,vreg_num,vsaldo.id_client,vvalue,vvalue_tax,vint_num,vmmgg_1,1);

      -- строка


    --как найти тариф для аванса
    -- берем тариф, по которому данный абонент потребил больше всего кВтч в 8 месяце.
    select into vmaintariff sum(bs.demand_val) as max_demand,bs.id_tariff
    from acm_bill_tbl as b left join acd_billsum_tbl as bs using (id_doc)
    where b.id_client=vsaldo.id_client 
    and b.mmgg_bill = vmmgg
    and b.id_pref = 10 
    and bs.id_tariff is not null
    group by bs.id_tariff
    order by max_demand desc LIMIT 1 ;

    if not found then

        --для реактива есть один спец. тариф
--        select into vid_tariff id from aci_tarif_tbl where ident = ''clc_re'' LIMIT 1 ;
        -- для активной берем пром<750.2кл
        select into vid_tariff id from aci_tarif_tbl where ident = ''clc_ae'' LIMIT 1 ;
      Raise Notice '' kr_start:  тариф по умолчанию'';
    else
      vid_tariff:=vmaintariff.id_tariff;
      Raise Notice '' kr_start:  тариф %. '',vid_tariff;
    end if;

    -- самая свежая сумма тарифа (на конец 7 месяца)
    select into vsumtariff t.id, t.value 
    from acd_tarif_tbl AS t
    where t.id_tarif=vid_tariff
    and t.dt_begin::date = (select max(dt_begin::date)              
                            from acd_tarif_tbl 
                            where id_tarif=vid_tariff and dt_begin::date<=vreg_date );



    vdemand:= Round(vvalue/vsumtariff.value) ;  


     insert into acd_tax_tbl(id_doc,unit,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff)
     values(currval(''dcm_doc_seq''),''кВтг'',''За активну електроенергiю (кредит 07)'',
     vdemand,vvalue,vsumtariff.value,vid_tariff,vsumtariff.id);


/*
     insert into acd_tax_tbl(id_doc,unit,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff)
     values(currval(''dcm_doc_seq''),''кВАрг'',''За реактивну електроенергiю (аванс)'',
     vdemand,vvalue,vsumtariff.value,vid_tariff,vsumtariff.id);
*/

    end loop;


    --все, кто имел кредитовое сальдо на начало месяца (РЕ)
    for vsaldo in 
     select cm.id as id_client,s.id_pref,coalesce(s.kr_zpme,0) as kr_zpme, coalesce(s.kr_zpmpdv,0) as kr_zpmpdv, cm.code
     from clm_client_tbl as cm 
     left join clm_statecl_tbl as cp on (cp.id_client=cm.id)
     join seb_obrr as s on (s.id_client=cm.id)
     where cm.book = -1 
     and cm.idk_work = 1
     and s.kr_zpme<>0 
     and s.period=vmmgg
     order by cm.code
    loop

      Raise Notice '' kr_start:  абонент % (%) вид % сумма %.'',vsaldo.id_client,vsaldo.code,vsaldo.id_pref,vsaldo.kr_zpme;

      vvalue:=vsaldo.kr_zpme;         
      vvalue_tax:=vsaldo.kr_zpmpdv;  


      vint_num = acm_nexttaxnum(vmmgg_1);
      vreg_num:=Text(vint_num)||vnum_end;


      --заголовок
      insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,int_num,mmgg,auto)
      values(20,21,0,vreg_date,vreg_num,vsaldo.id_client,vvalue,vvalue_tax,vint_num,vmmgg_1,1);

      -- строка


      --как найти тариф для аванса
      -- берем тариф, по которому данный абонент потребил больше всего кВтч в 8 месяце.
      select into vmaintariff sum(bs.demand_val) as max_demand,bs.id_tariff
      from acm_bill_tbl as b left join acd_billsum_tbl as bs using (id_doc)
      where b.id_client=vsaldo.id_client 
      and b.mmgg_bill = vmmgg
      and b.id_pref = 20 
      and bs.id_tariff is not null
      group by bs.id_tariff
      order by max_demand desc LIMIT 1 ;

      if not found then

        --для реактива есть один спец. тариф
        select into vid_tariff id from aci_tarif_tbl where ident = ''clc_re'' LIMIT 1 ;
        -- для активной берем пром<750.2кл
--        select into vid_tariff id from aci_tarif_tbl where ident = ''clc_ae'' LIMIT 1 ;
      Raise Notice '' kr_start:  тариф по умолчанию'';
     else
       vid_tariff:=vmaintariff.id_tariff;
       Raise Notice '' kr_start:  тариф %. '',vid_tariff;
     end if;

     -- самая свежая сумма тарифа (на конец 7 месяца)
     select into vsumtariff t.id, t.value 
     from acd_tarif_tbl AS t
     where t.id_tarif=vid_tariff
     and t.dt_begin::date = (select max(dt_begin::date)              
                            from acd_tarif_tbl 
                            where id_tarif=vid_tariff and dt_begin::date<=vreg_date );



     vdemand:= Round(vvalue/vsumtariff.value) ;  

/*
     insert into acd_tax_tbl(id_doc,unit,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff)
     values(currval(''dcm_doc_seq''),''кВтг'',''За активну електроенергiю (кредит 07)'',
     vdemand,vvalue,vsumtariff.value,vid_tariff,vsumtariff.id);
*/


     insert into acd_tax_tbl(id_doc,unit,text,demand_val,sum_val7,tariff,
     id_tariff,id_sumtariff)
     values(currval(''dcm_doc_seq''),''кВАрг'',''За реактивну електроенергiю (кредит 07)'',
     vdemand,vvalue,vsumtariff.value,vid_tariff,vsumtariff.id);


    end loop;

  return true;
  end;
' LANGUAGE 'plpgsql';


--select acm_createTaxStartAdvance();