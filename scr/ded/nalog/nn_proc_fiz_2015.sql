;
set client_encoding = 'win';


----------------------------------------------------------------------------------------------------
--создание НН на сумму оплаты льгот и субсидий 
create or replace function acm_createTaxLgt(date,date) returns boolean as'
  declare 
     pmmgg        alias for $1;
     preg_date    alias for $2;

     vclient       record;
     vreg_num     varchar;
     vnum_end     varchar;
     vvalue	  numeric(14,4);
     vvalue_tax   numeric(14,4);
     vpref        varchar;
     vtariff      numeric(14,4);
     vid_tariff   int;
     vid_sumtariff int;
     vdemand      numeric(14,4);
     vid_tax int;   
     vint_num int;
     vprotocol    record;
     vvalue_tax_math   numeric(14,4);
     vlimit numeric;
     vid_new      int;
  begin


   select into vnum_end value_ident  from syi_sysvars_tbl 
   where ident=''tax_num_ending'';
/*
   if (pmmgg >= ''2012-01-01'') then
    vlimit:=10000;
   else
    vlimit:=100000;
   end if;
*/

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
     and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
     group by cm.code,p.id_client,p.id_pref,cp.doc_num, cp.doc_dat
     having sum(p.value_pay)<>0
     order by p.id_client
   loop


    select into vid_tax id_doc from acm_tax_tbl 
    where id_client = vclient.id_client and mmgg = pmmgg and kind_calc = 3 and id_pref = vclient.id_pref and disabled = 0;

    if found then 

      Raise Notice ''Налоговая накладная на оплату для абонента % в этом месяце уже сформирована.'',vclient.code;

    else

--    select into vpref ident from aci_pref_tbl where id = vclient.id_pref;


      Raise Notice ''НН на оплату (льготы/субсидии) абонент % '',vclient.code;      

      vint_num = acm_nexttaxnum(pmmgg);
      vreg_num:=Text(vint_num)||vnum_end;

/*  
     if (( round(vclient.pay/5,2) >=vlimit ) or (vclient.pay_tax >= vlimit )) and (getsysvar(''tax_div'')=1) then 

       insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,int_num)
       values(10,3,0,preg_date,vreg_num,vclient.id_client,vclient.pay,round(vclient.pay/5,2),1,vint_num);

       if vclient.pay_tax<> round(vclient.pay/5,2) then
  
         vvalue_tax_math:=round(vclient.pay/5,2);
  
         Raise Notice ''&&& Не совпадане НДС НН % и Оборотки %'',vvalue_tax_math,vclient.pay_tax;
  
         insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
         values(vclient.id_client,10,currval(''dcm_doc_seq''),pmmgg,vclient.pay,vvalue_tax_math,vclient.pay_tax);
  
       end if;
     else
*/  
      insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,int_num,decade)
      values(default,10,3,0,preg_date,vreg_num,vclient.id_client,vclient.pay,vclient.pay_tax,1,vint_num,3) returning id_doc into vid_new;

--     end if;

  
      --вся детализация идет одной строкой
      -- количество = 1
      -- единица изм. грн
      -- цена = сумма без НДС

      select into vprotocol * from clm_protocol_tbl where id_client = vclient.id_client and mmgg = pmmgg order by reg_date limit 1;

      if found  then

       insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff)
       values(vid_new,preg_date ,''грн'',''2454'',''2716000000'',''Активна е/е згiдно протоколу погодження ¦ ''||
        vprotocol.reg_num::varchar||'' вiд ''||to_char(vprotocol.reg_date,''DD.MM.YYYY'') , 1,vclient.pay,vclient.pay);

      else

       insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff)
       values(vid_new,preg_date,''грн'',''2454'',''2716000000'',''Активна е/е згiдно протоколу погодження ¦ ''||
        vclient.doc_num::varchar||'' вiд ''||to_char(vclient.doc_dat,''DD.MM.YYYY''), 1,vclient.pay,vclient.pay);

      end if;  

    end if;

   end loop;

   return true;
  end;
' LANGUAGE 'plpgsql';

-----------------------------------------------------------------------------------------

--создание НН для населения (счета и акты) 
-- выписывается 1 НН на общую сумму
--1. Оплаты 2000, 2001 (до 01.08.2001) без списания
--2. Начислено +Кт. конец  -Кт. начало
-- Отдельным документом идет оплата 1999 года
create or replace function acm_createTaxFiz(date,date) returns boolean as'
  declare 
     pmmgg        alias for $1;
     preg_date    alias for $2;
     vclient      int;
     vsaldo       record;
     vreg_num     varchar;
     vnum_end     varchar;
     vvalue	  numeric(14,4);
     vvalue_tax   numeric(14,4);
     vpref        varchar;
     vtariff      numeric(14,4);
     vid_tariff   int;
     vid_sumtariff int;
     vdemand      numeric(14,4);
     vid_tax int;   
     vint_num int;
     vpay99       record;
     vpay00       record;
     vsum_all     numeric(14,2);
     vsum_tax     numeric(14,2);
     vnar_old     record;
     vsumtariff_math numeric;
     vvalue_tax_math numeric(14,4);
     vlimit numeric;
     vid_new      int;
  begin

   Raise Notice '' - - acm_createTaxFiz  - -  '';      

   select into vnum_end value_ident  from syi_sysvars_tbl 
   where ident=''tax_num_ending'';
/*
   if (pmmgg >= ''2012-01-01'') then
    vlimit:=10000;
   else
    vlimit:=100000;
   end if;
*/
   -- суммарные значения по населению -счетам и населению-актам.
   for vsaldo in 
    select cp.id_section,coalesce(sum(kr_zkme),0) as ekt, coalesce(sum(kr_zkmpdv),0) as ekt_pdv,
    coalesce(sum(kr_zpme),0) as bkt, coalesce(sum(kr_zpmpdv),0) as bkt_pdv, 
    coalesce(sum(nar_e),0)-coalesce(sum(b_old.val),0) as nar,
    coalesce(sum(nar_pdv),0)-coalesce(sum(b_old.val_tax),0) as nar_pdv,
    coalesce(sum(nar),0)-coalesce(sum(b_old.demand),0) as kvt
    from seb_obr_all_tmp as obr
    join clm_client_tbl as cm on (cm.id = obr.id_client)
    left join clm_statecl_h as cp on (cm.id=cp.id_client)
    left join 
     (select b.id_client, sum(b.value) as val, sum(b.value_tax) as val_tax, sum(b.demand_val) as demand
     from acm_bill_tbl as b 
     where b.mmgg_bill < ''2001-08-01''::date
     and b.mmgg = pmmgg 
     group by b.id_client) as b_old on (b_old.id_client=obr.id_client )
    where cm.book = -1 and obr.id_pref = 10
    and cp.id_section in (205,208) 
    and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
    and period=pmmgg
    group by cp.id_section
   loop

     Raise Notice ''Налоговая накладная для группы % .'',vsaldo.id_section;

     if vsaldo.id_section = 205 then
        vclient:=getsysvar(''id_abon_tax205'');
     end if;

     if vsaldo.id_section = 208 then
        vclient:=getsysvar(''id_abon_tax208'');
     end if;


     -- платеж 99 года отдельно 
     select into vpay99 cp.id_section,coalesce(sum(p.value),0) as pay  
     from acm_pay_tbl as p 
     left join clm_client_tbl as cm on (cm.id = p.id_client)
     left join clm_statecl_h as cp on (p.id_client=cp.id_client)
     left join dci_document_tbl as dci on (p.idk_doc=dci.id)
     where cm.book = -1 and p.mmgg=pmmgg and ((dci.ident<>''writeoff'') and (dci.ident<>''wr_off_act''))
     and date_part(''year'',p.mmgg_pay) = (1999) 
     and cp.id_section = vsaldo.id_section
     and p.sign_pay = 1
     and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
     group by cp.id_section;


     
     if found then 
      if vpay99.pay > 0 then 


       select into vid_tax id_doc from acm_tax_tbl as t 
       left join clm_client_tbl as cm on (cm.id = t.id_client)
       left join clm_statecl_h as cp on (t.id_client=cp.id_client)
       where  mmgg = pmmgg and kind_calc = 4 and id_pref = 10 and t.disabled = 0
       and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
       and cp.id_section = vsaldo.id_section and pay_p = 1999;
  
       if found then 
         Raise Notice ''Налоговая накладная на оплату 1999 для группы % в этом месяце уже сформирована.'',vsaldo.id_section;
       else
  
  
        Raise Notice ''НН на население (счета/акты) оплата 99'';      
  
        vint_num = acm_nexttaxnum(pmmgg);
        vreg_num:=Text(vint_num)||vnum_end;
  
        insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,pay_p,int_num,decade)
        values(default,10,4,0,preg_date,vreg_num,vclient,vpay99.pay,0,1,1999,vint_num,3) returning id_doc into vid_new;
  
        insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val8,tariff, id_tariff,id_sumtariff)
         values(vid_new,''1999-01-01'',''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю (оплата)'',0,vpay99.pay,0,0,0);

       end if; 
      end if;
     end if;


     -- платеж 2000 - 2001 года  
     select into vpay00 cp.id_section,coalesce(sum(p.value),0) as pay ,coalesce(sum(p.value_tax),0) as pay_tax 
     from acm_pay_tbl as p 
     left join clm_client_tbl as cm on (cm.id = p.id_client)
     left join clm_statecl_h as cp on (p.id_client=cp.id_client)
     left join dci_document_tbl as dci on (p.idk_doc=dci.id)
     where cm.book = -1 and p.mmgg=pmmgg and ((dci.ident<>''writeoff'') and (dci.ident<>''wr_off_act''))
     and date_part(''year'',p.mmgg_pay) in (2000,2001)
     and p.mmgg_pay < ''2001-08-01''::date 
     and cp.id_section = vsaldo.id_section
     and p.sign_pay = 1
     and cp.mmgg_b = (select max(mmgg_b) from clm_statecl_h as cp2 where cp2.id_client = cp.id_client and cp2.mmgg_b <= pmmgg ) 
     group by cp.id_section;


     if found then 

      vsum_all = (vsaldo.nar+vsaldo.ekt-vsaldo.bkt )+vpay00.pay;
      Raise Notice ''vsum_all % '',vsum_all;
      Raise Notice ''vsaldo.nar % '',vsaldo.nar;
      Raise Notice ''vsaldo.ekt % '',vsaldo.ekt;
      Raise Notice ''vsaldo.bkt % '',vsaldo.bkt;
      Raise Notice ''vpay00.pay % '',vpay00.pay;
      vsum_tax = (vsaldo.nar_pdv+vsaldo.ekt_pdv-vsaldo.bkt_pdv)+vpay00.pay_tax;
     else 

      vsum_all = (vsaldo.nar+vsaldo.ekt-vsaldo.bkt );
      Raise Notice ''vsum_all % '',vsum_all;
      Raise Notice ''vsaldo.nar % '',vsaldo.nar;
      Raise Notice ''vsaldo.ekt % '',vsaldo.ekt;
      Raise Notice ''vsaldo.bkt % '',vsaldo.bkt;

      vsum_tax = (vsaldo.nar_pdv+vsaldo.ekt_pdv-vsaldo.bkt_pdv);

     end if;

     select into vid_tax id_doc from acm_tax_tbl as t 
     left join clm_client_tbl as cm on (cm.id = t.id_client)
     left join clm_statecl_tbl as cp on (t.id_client=cp.id_client)
     where  mmgg = pmmgg and kind_calc = 4 and id_pref = 10 and t.disabled = 0
     and cp.id_section = vsaldo.id_section;

     if found then 
       Raise Notice ''Налоговая накладная для группы % в этом месяце уже сформирована.'',vsaldo.id_section;
     else

      if vsum_all > 0 then 

        if vsaldo.kvt <>0 then
          vtariff= Round(vsum_all/vsaldo.kvt,acm_calc_tarif_prec(vsaldo.kvt));
        else 
          vtariff=0;
        end if;

        Raise Notice ''НН на население (счета/акты) '';      

        vint_num = acm_nexttaxnum(pmmgg);
        vreg_num:=Text(vint_num)||vnum_end;

--        insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,pay_p,int_num)
--        values(10,4,0,preg_date,vreg_num,vclient,vsum_all,vsum_tax,1,2005,vint_num);
        -- налоговая по населению не подается в электронный реестр, так что можно не контролировать
--        if ( round(vsum_all/5,2) >=vlimit ) or ( vsum_tax >= vlimit ) then 

--          insert into acm_tax_tbl(id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,pay_p,int_num)
--          values(10,4,0,preg_date,vreg_num,vclient,vsum_all,round(vsum_all/5,2),1,2005,vint_num);
--
--          if vsum_tax<> round(vsum_all/5,2) then
--    
--            vvalue_tax_math:=round(vsum_all/5,2);
--    
--            Raise Notice ''&&& Не совпадане НДС НН % и Оборотки %'',vvalue_tax_math,vsum_tax;
--    
--            insert into acm_tax_ndserr_tbl (id_client,id_pref,id_doc,mmgg, sum_nn, tax_nn, tax_real)
--            values(vclient,10,currval(''dcm_doc_seq''),pmmgg,vsum_all,vvalue_tax_math,vsum_tax);
--    
--          end if;
--        else
          insert into acm_tax_tbl(id_doc,id_pref,kind_calc,budget,reg_date,reg_num,id_client,value,value_tax,auto,pay_p,int_num,decade)
          values(default,10,4,0,preg_date,vreg_num,vclient,vsum_all,vsum_tax,1,2005,vint_num,3) returning id_doc into vid_new;
--        end if;


        insert into acd_tax_tbl(id_doc,dt_bill,unit,unit_kod,uktzed,text,demand_val,sum_val7,tariff)
        values(vid_new,preg_date,''кВт·год'',''0415'',''2716000000'',''За активну електроенергiю '',vsaldo.kvt,vsum_all,vtariff);

--        Raise Notice ''НН на население (счета/акты) Ok'';      
      end if;
     end if;
   end loop;

   return true;
  end;
' LANGUAGE 'plpgsql';
