set client_encoding='win';                                                    
insert into syi_sysvars_tbl (id,ident,type_ident,value_ident)
  values (23,'kod_res','int',0);
update acm_bill_tbl set mmgg_bill=date_trunc('month',dat_e) where date_trunc('month',mmgg)<>date_trunc('month',dat_e)
     and mmgg_bill is null;

update acm_bill_tbl set mmgg_bill=mmgg where  mmgg_bill is null;

alter table seb_obr_all_tbl add column   deb_pm15v  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_pm15e  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_pm15pdv  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_km15v  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_km15e  numeric(16,2); 
alter table seb_obr_all_tbl add column   deb_km15pdv  numeric(16,2); 

alter table seb_obr_all_tbl add column   deb_pm16v  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_pm16e  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_pm16pdv  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_km16v  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_km16e  numeric(16,2); 
alter table seb_obr_all_tbl add column   deb_km16pdv  numeric(16,2); 

alter table seb_obr_all_tbl add column   deb_pm17v  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_pm17e  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_pm17pdv  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_km17v  numeric(16,2);
alter table seb_obr_all_tbl add column   deb_km17e  numeric(16,2); 
alter table seb_obr_all_tbl add column   deb_km17pdv  numeric(16,2); 

update seb_obr_all_tbl   set  idk_work=clm_client_tbl.idk_work 
   from clm_client_tbl where clm_client_tbl.id=seb_obr_all_tbl.id_client and 
seb_obr_all_tbl.idk_work  is null; 

create or replace function seb_all(int, date ) returns boolean as'
declare par alias for $1;
declare pmmgg alias for $2;
pr boolean;
begin
 update clm_client_tbl set id_department=
   (select int8(value_ident) from syi_sysvars_tbl where ident=''id_res'')
    where id_department is null;
 if par=1 then
   pr=seb_spo(pmmgg);
   pr=seb_udog(pmmgg);
   pr=abon_limit_fun(pmmgg);
   pr=area_limit_fun(pmmgg);
 end if;
 pr=seb_work_obl(now()::date);
 pr=seb_one(pmmgg,par,null);
 pr=seb_saldakt(pmmgg,1);
 pr=seb_meter((pmmgg-interval ''1 month'')::date,eom(pmmgg));
 if par=2 then
   pr=rep_4nkre_fun(pmmgg,0);
   pr=abon_lost_fun(pmmgg);
   pr=seb_diftarif(pmmgg,par);
   pr=seb_renthist(pmmgg,par);
   pr=seb_tar(pmmgg);
 end if;
return true;
end;
' language 'plpgsql';
/*  ****************************************************  */
create or replace function seb_all_add( date ) returns boolean as'
declare pmmgg alias for $1;
p record;
p1 record;
pr boolean;
begin
  raise notice ''all_tbl'';
  select   into p  * from seb_obr_all_tbl where mmgg=pmmgg limit 1;
  if found then
    select   into p1  * from seb_obr_all_tbl where mmgg=pmmgg and flock=1 limit 1;
    if found then
       raise notice ''all_tbl closed month'';
      return true;
    end if;
  end if;   
  delete from seb_obr_all_tbl where mmgg=pmmgg and flock=0;
  delete from seb_obrs_tbl where mmgg=pmmgg and flock=0;

  insert into seb_obr_all_tbl select * from seb_obr_all_tmp;
  insert into seb_obrs_tbl select *,0 as flock from seb_obrs_tmp;
  return true;
end ' language 'plpgsql';

 /*  ****************************************************  */


drop function seb_one (date,int,int);
create or replace function seb_one(date,int,int) returns boolean as '
declare 
 pmmgg alias for $1;
 cop  alias for $2;
 clip alias for $3;
 kodres int;
 existt boolean;
 pr boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
 if found then  
   raise notice ''START SEB seb_one'';
   delete from seb_nar_tmp;
  insert into seb_nar_tmp
  select b.mmgg as mmgg,c.kind_dep as cod_r,c.code as osob_r,c.id as id_client,b.id_pref,
    b.reg_num as nom_doc,
    case when ( date_trunc(''month'',b.reg_date )::date=b.mmgg) then b.reg_date else b.mmgg  end 
    as d_doc,
   case when (b.idk_doc=200) then ''Счет''::varchar else ''Счет''::varchar end as vid_doc, 
    case when (b.id_pref=10 or b.id_pref=1099) then ''AE''::varchar else 
     case when (b.id_pref=20 or b.id_pref=2099) then ''PE''::varchar else 
      case when (b.id_pref=901) then ''Пеня''::varchar else 
       case when (b.id_pref=902) then ''Инфл''::varchar else 
        case when (b.id_pref=500) then ''5KR''::varchar else 
         case when (b.id_pref=510) then ''2KRM''::varchar else
          case when (b.id_pref=524) then ''2KRP''::varchar else
           case when (b.id_pref=520) then ''2KROP''::varchar else   ''???''
           end 
          end
         end
        end
       end
      end
     end
    end  as vid_nar,
    b.demand_val as kilk, b.value as suma,b.value_tax as pdv,(b.value+b.value_tax) as suma_zpdv,
    ((coalesce(b.date_transmis,b.reg_date))::date) as dt_trans,b.id_doc,b.idk_doc
    from (select id,code,kind_dep from clm_client_tbl where book<0 and idk_work<>0
             and (clip is null or id=clip)
         ) as c 
         inner join ( select b1.* from acm_bill_tbl b1
                        where  (b1.mmgg=pmmgg or b1.mmgg=pmmgg-interval ''1 month'') 
                       and (clip is null or b1.id_client=clip) 
                    )  as b    
           on  (b.id_client=c.id) order by c.kind_dep,b.mmgg ,c.code;  


 if getsysvar(''kod_res'') = ''310'' then

raise notice ''START  update  seb_nar_tmp'';
if  ((clip is null) or  ( cop=1))  then
update  seb_nar_tmp set kilk_nas= bt.dem from
 
( select  bs.id_doc, coalesce(sum(bs.demand_val),0) as dem
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg =pmmgg   and b.mmgg_bill = pmmgg 
  --and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc = 200 --and (b.id_doc = pid_bill or pid_bill is null)
  and (tgr.ident like ''tgr7%'' or tgr.ident like ''tgr8%'')
group by bs.id_doc) bt
where bt.id_doc=seb_nar_tmp.id_doc;

end if;
end if;


if ((cop=1) and (clip is null)) then
  tabl=path_export||kodres||''NAR.TXT'';
  del='';''; 
  nul='''';
  SQL=''copy  seb_nar_tmp 
     (cod_r,osob_r,nom_doc,d_doc,vid_doc,vid_nar,kilk,suma,pdv,suma_zpdv,dt_trans,idk_doc,kilk_nas)
     to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul) ;
  raise notice ''copy seb_nar'';

 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

  
end if;

  -- delete next month after coping
raise notice ''delete from seb_nar_tmp where mmgg<>pmmgg'';
  delete from seb_nar_tmp where mmgg<>pmmgg;
raise notice ''delete from seb_opl_tmp;'';

  delete from seb_opl_tmp;
raise notice ''insert into seb_opl_tmp'';

  insert into seb_opl_tmp
  select p.mmgg as mmgg,c.kind_dep as cod_r,c.code as osob_r,c.id as id_client,
     p.reg_num as  nom_doc,
      p.reg_date as d_doc,
      p.id_pref, 
      case when (p.idk_doc=100 or p.idk_doc=110 or p.idk_doc=109) then ''Банк'' else
       case when p.idk_doc=120 then ''Авiзо'' else
        case when p.idk_doc=199 then ''Коригування'' else ''???''
        end 
       end 
      end 
     as vid_doc,
     case when (p.id_pref=10 or p.id_pref=1099) then ''AE''::varchar else 
       case when (p.id_pref=20 or p.id_pref=2099) then ''PE''::varchar else 
        case when (p.id_pref=901) then ''Пеня''::varchar else 
         case when (p.id_pref=902) then ''Инфл''::varchar else 
          case when (p.id_pref=5009) then ''5KR''::varchar else
            case when (p.id_pref=510) then ''2KRM''::varchar else 
             case when (p.id_pref=524) then ''2KRP''::varchar else
              case when (p.id_pref=520) then ''2KROP''::varchar else   ''???'' 
           end 
          end
          end
         end
        end
       end
      end
     end   as vid_narobr,
     p.mmgg_pay as period_op,
     p.value as suma,p.value_tax as pdv ,p.value_pay as suma_zpdv
    from (select id,code,kind_dep from clm_client_tbl where book<0 and idk_work<>0 
        and (clip is null or id=clip)
      ) as c 
         inner join ( select p1.*  from acm_pay_tbl p1  where 
                 (p1.mmgg=pmmgg or p1.mmgg=pmmgg-interval ''1 month'') and p1.sign_pay>0  
                   and (clip is null or p1.id_client=clip)
                   )  as p    
           on  (p.id_client=c.id) order by c.kind_dep,p.mmgg ,c.code;  

if ((cop=1) and (clip is null)) then


tabl=path_export||kodres||''OPL.TXT'';
del='';''; nul='''';
SQL=''copy  seb_opl_tmp 
     (cod_r,osob_r,nom_doc,d_doc,vid_doc,vid_nar,period_op,suma,pdv,suma_zpdv) 
      to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

end if;
-- delete next month after coping


raise notice ''delete from seb_opl_tmp where mmgg<>pmmgg;'';
delete from seb_opl_tmp where mmgg<>pmmgg;

raise notice ''delete from seb_obrs_tmp;'';
delete from seb_obrs_tmp;
raise notice ''insert into seb_obrs_tmp'';

insert into seb_obrs_tmp   

select distinct * from 
(                  select c.code,c.id as id_client,
      sel.id_pref,sel.mmgg as p_mmgg,sel.hmmgg,
        sel.bbrest as b_dtval,sel.bbrest_tax as b_dtval_tax,
        sel.bprest as b_ktval,sel.bprest_tax as b_ktval_tax,
        sel.ebrest as e_dtval, sel.ebrest_tax as e_dtval_tax,
        sel.eprest as e_ktval,sel.eprest_tax as e_ktval_tax  
from (select id, code from clm_client_tbl  where book<0 and idk_work<>0 
       and (clip is null or id=clip)
     ) as c
       right join 
       
    ( select distinct coalesce(bill.id_client,pay.id_client) as id_client,
       coalesce(bill.id_pref,pay.id_pref) as id_pref,
      date_larger(coalesce(bill.mmgg,pay.mmgg)::date,coalesce(pay.mmgg,bill.mmgg)::date) as mmgg,
      coalesce(pay.mmgg_pay,bill.mmgg_bill) as hmmgg,

       bill.bbrest,bill.bbrest_tax,bill.ebrest,bill.ebrest_tax,
       pay.bprest,pay.bprest_tax,pay.eprest,pay.eprest_tax
       from 
         ( select coalesce(bb.id_client,bv.id_client) as id_client,
            coalesce(bb.id_pref,bv.id_pref) as id_pref, 
            coalesce(bb.mmgg,bv.mmgg) as mmgg,
            coalesce(bb.mmgg_bill,bv.mmgg_bill) as mmgg_bill,
            coalesce(bb.bbrest,0) as bbrest,
            coalesce(bb.bbrest_tax,0) as bbrest_tax ,
            coalesce(bv.ebrest,0) as ebrest,
            coalesce(bv.ebrest_tax,0) as ebrest_tax  
            from ( 
            select b.id_client,b.id_pref,date_trunc(''year'',b.mmgg) as mmgg,
             date_trunc(''year'',b.mmgg_bill) as mmgg_bill,
             coalesce(sum(coalesce(b.value,0)::numeric),0)::numeric as val ,
             coalesce(sum(coalesce(b.value_tax,0)::numeric),0)::numeric as val_tax,
             coalesce(sum(coalesce(bp.value,0)::numeric),0)::numeric as pay ,
             coalesce(sum(coalesce(bp.value_tax,0)::numeric),0)::numeric as pay_tax,
             coalesce(sum(coalesce(b.value,0)::numeric),0)::numeric-coalesce(sum(coalesce(bp.value,0)),0)::numeric as bbrest,
             coalesce(sum(coalesce(b.value_tax,0)::numeric),0)::numeric-coalesce(sum(coalesce(bp.value_tax,0)),0)::numeric as bbrest_tax
             from (select * from acm_bill_tbl where mmgg_bill<pmmgg 
                    and mmgg<pmmgg    and (clip is null or id_client=clip)
                  ) b 
             left outer join  (
             select 
                id_bill,
                coalesce(sum(value_tax),0) as value_tax,
                coalesce(sum(value),0) as value  
                from (
                      select * from acm_billpay_tbl where mmgg<pmmgg 
                         and (clip is null or id_client=clip)
                  ) as t
               group by  id_bill 
           ) bp on b.id_doc=bp.id_bill
           group by  date_trunc(''year'',b.mmgg),date_trunc(''year'',b.mmgg_bill),
           b.id_client,b.id_pref
         ) as bb 
          full join  
         ( select   b.id_client,b.id_pref,date_trunc(''year'',b.mmgg) as mmgg,date_trunc(''year'',b.mmgg_bill) as mmgg_bill,
            coalesce(sum(coalesce(b.value,0)),0) as val ,
            coalesce(sum(coalesce(b.value_tax,0)),0)::numeric as val_tax,
            coalesce(sum(coalesce(bp.value,0)),0)::numeric as pay ,
            coalesce(sum(coalesce(bp.value_tax,0)),0)::numeric as pay_tax,
            coalesce(sum(coalesce(b.value,0)),0)-coalesce(sum(coalesce(bp.value,0)),0) as ebrest,
            coalesce(sum(coalesce(b.value_tax,0)),0)-coalesce(sum(coalesce(bp.value_tax,0)),0) as ebrest_tax
           from (select * from acm_bill_tbl 
                where    mmgg_bill<=pmmgg and mmgg<=pmmgg 
                and (clip is null or id_client=clip)
                ) b 
           left outer join  (
             select 
                id_bill,
                coalesce(sum(value_tax),0) as value_tax,
                coalesce(sum(value),0) as value  
             from ( select * from acm_billpay_tbl where mmgg<=pmmgg 
                    and (clip is null or id_client=clip) 
                  ) as t2
               group by  id_bill  
           ) bp 
           on b.id_doc=bp.id_bill
           group by  date_trunc(''year'',b.mmgg),date_trunc(''year'',b.mmgg_bill),
           b.id_client,b.id_pref 
         )     as bv
         on (bb.id_client=bv.id_client and bb.id_pref=bv.id_pref and bb.mmgg=bv.mmgg and bb.mmgg_bill=bv.mmgg_bill)
         ) as bill
         full join 
            (  select  coalesce(pp.id_client,ppe.id_client) as id_client,
               coalesce(pp.id_pref,ppe.id_pref) as id_pref,
               coalesce(pp.mmgg,ppe.mmgg) as mmgg,
               coalesce(pp.mmgg_pay,ppe.mmgg_pay) as mmgg_pay,
               coalesce(pp.bprest,0) as bprest,
               coalesce(pp.bprest_tax,0) as bprest_tax,
               coalesce(ppe.eprest,0) as eprest,
               coalesce(ppe.eprest_tax,0) as eprest_tax   
               from 
                ( select  p.id_client,p.id_pref,
                 date_trunc(''year'',p.mmgg) as mmgg,
                  date_trunc(''year'',coalesce(p.mmgg_pay,p.mmgg_hpay)) as mmgg_pay,
                   coalesce(sum(coalesce(p.value,0)),0) as val ,
                   coalesce(sum(coalesce(p.value_tax,0)),0) as val_tax,
                   coalesce(sum(coalesce(bp.value,0)),0) as pay ,
                   coalesce(sum(coalesce(bp.value_tax,0)),0) as pay_tax,
                   coalesce(sum(coalesce(p.value,0)),0)-coalesce(sum(coalesce(bp.value,0)),0) as bprest,                                                 
                   coalesce(sum(coalesce(p.value_tax,0)),0)-coalesce(sum(coalesce(bp.value_tax,0)),0) as bprest_tax
                  from (select * from acm_pay_tbl 
                  where    mmgg<pmmgg and (clip is null or id_client=clip) 
                       ) p 
                  left outer join  (
                   select 
                         id_pay,
                         coalesce(sum(value_tax),0) as value_tax,
                         coalesce(sum(value),0) as value  
                       from ( select * from acm_billpay_tbl where mmgg<pmmgg 
                             and (clip is null or id_client=clip)
                             ) as pt 
                       group by  id_pay  
                  ) bp on p.id_doc=bp.id_pay
                  group by  p.id_client,p.id_pref,date_trunc(''year'',p.mmgg),
                  date_trunc(''year'',coalesce(p.mmgg_pay,p.mmgg_hpay)) 
                 ) as pp
                 full join 
                 (  select distinct p.id_client,p.id_pref,date_trunc(''year'',p.mmgg) as mmgg,
                  date_trunc(''year'',coalesce(p.mmgg_pay,p.mmgg_hpay)) as mmgg_pay,
                        coalesce(sum(coalesce(p.value,0)),0) as val ,
                        coalesce(sum(coalesce(p.value_tax,0)),0) as val_tax,
                        coalesce(sum(coalesce(bp.value,0)),0) as pay ,
                        coalesce(sum(coalesce(bp.value_tax,0)),0) as pay_tax,
                        coalesce(sum(coalesce(p.value,0)),0)-coalesce(sum(coalesce(bp.value,0)),0) as eprest,                                                 
                        coalesce(sum(coalesce(p.value_tax,0)),0)-coalesce(sum(coalesce(bp.value_tax,0)),0) as eprest_tax
                    from (select * from acm_pay_tbl where mmgg<=pmmgg 
                         and (clip is null or id_client=clip)
                         ) p 
                    left outer join  (
                         select 
                          id_pay,
                          coalesce(sum(value_tax),0) as value_tax,
                          coalesce(sum(value),0) as value  
                        from (select * from acm_billpay_tbl where mmgg<=pmmgg 
                          and (clip is null or id_client=clip)
                             ) as ptt 
                        group by  id_pay 
                     ) bp on p.id_doc=bp.id_pay
                    group by   p.id_client,p.id_pref,date_trunc(''year'',p.mmgg), 
                  date_trunc(''year'',coalesce(p.mmgg_pay,p.mmgg_hpay)) 
                 ) as ppe
                 on (pp.id_client=ppe.id_client and pp.id_pref=ppe.id_pref 
                      and pp.mmgg=ppe.mmgg    and pp.mmgg_pay=ppe.mmgg_pay)
            )  as pay
             on (bill.id_client=pay.id_client and bill.mmgg_bill=pay.mmgg_pay 
          and bill.mmgg=pay.mmgg
            and bill.id_pref=pay.id_pref)) as sel
        on sel.id_client=c.id order by id_client,id_pref
) as tt; 
            /*
update seb_obrs_tmp set b_dtval=b_dtval-b_ktval where b_ktval<0;
update seb_obrs_tmp set b_ktval=0 where b_ktval<0;

update seb_obrs_tmp set b_dtval_tax=b_dtval_tax-b_ktval_tax where b_ktval_tax<0;
update seb_obrs_tmp set b_dtval_tax=0 where b_dtval_tax<0;

update seb_obrs_tmp set b_ktval=b_ktval-b_dtval where b_dtval<0;
update seb_obrs_tmp set b_ktval=0 where b_ktval<0;

update seb_obrs_tmp set b_ktval_tax=b_ktval_tax-b_dtval_tax where b_dtval_tax<0;
update seb_obrs_tmp set b_ktval_tax=0 where b_ktval_tax<0;
              */
/*    
update seb_obrs_tmp set e_dtval=e_dtval-e_ktval where e_ktval<0;
update seb_obrs_tmp set e_ktval=0 where e_ktval<0;

update seb_obrs_tmp set e_dtval_tax=e_dtval_tax-e_ktval_tax where e_ktval_tax<0;
update seb_obrs_tmp set e_dtval_tax=0 where e_dtval_tax<0;

update seb_obrs_tmp set e_ktval=e_ktval-e_dtval where e_dtval<0;
update seb_obrs_tmp set e_ktval=0 where e_ktval<0;

update seb_obrs_tmp set e_ktval_tax=e_ktval_tax-e_dtval_tax where e_dtval_tax<0;
update seb_obrs_tmp set e_ktval_tax=0 where e_ktval_tax<0;
*/     

--update seb_obrs_tmp set e_dtval=0 where e_dtval is null;
--update seb_obrs_tmp set e_dtval_tax=0 where e_dtval_tax is null;


raise notice ''update seb_obrs_tmp set b_dtval=0 where b_dtval is null'';
update seb_obrs_tmp set b_dtval=0 where b_dtval is null;
update seb_obrs_tmp set b_dtval_tax=0 where b_dtval_tax is null;
update seb_obrs_tmp set e_dtval=0 where e_dtval is null;
update seb_obrs_tmp set e_dtval_tax=0 where e_dtval_tax is null;
update seb_obrs_tmp set b_ktval=0 where b_ktval is null;
update seb_obrs_tmp set b_ktval_tax=0 where b_ktval_tax is null;
update seb_obrs_tmp set e_ktval=0 where e_ktval is null;
update seb_obrs_tmp set e_ktval_tax=0 where e_ktval_tax is null;

update seb_obrs_tmp set mmgg=f.mmgg from (select fun_mmgg() as mmgg) as f;  


raise notice ''end_seb_obrs'';

delete from seb_obr_all_tmp;
insert into seb_obr_all_tmp  
       (id_client,cod_r,
         roz, period,
         osob_r,osob_rsk,idk_work,id_pref,
         deb_zpmv,deb_zpme,deb_zpmpdv,
         kr_zpmv,kr_zpme,kr_zpmpdv,
         deb_kmv,deb_kme, deb_kmpdv,
         kr_zkmv, kr_zkme, kr_zkmpdv,
         nar,nar_e,nar_pdv,nar_v,
         opl_ze,opl_zpdv,opl_zv,
         opl_be,opl_bpdv,opl_bv,
         opl_ie,opl_ipdv,opl_iv
) 
     select 
       c.id_client::integer as id_client,
       c.kind_dep as cod_r,
       c.roz  ,
       pmmgg as period,
       c.code  as osob_r,c.short_name as osob_rsk,c.idk_work as idk_work,
       sal.id_pref,
       -(sal.b_dtval+sal.b_dtval_tax) as deb_zpmv,
       -sal.b_dtval as deb_zpme,-sal.b_dtval_tax as deb_zpmpdv,
       sal.b_ktval+sal.b_ktval_tax as kr_zpmv,
       sal.b_ktval as kr_zpme,sal.b_ktval_tax as kr_zpmpdv,
       -(sal.e_dtval+sal.e_dtval_tax) as deb_kmv,
       -sal.e_dtval as deb_kme,-sal.e_dtval_tax as deb_kmpdv,
       sal.e_ktval+sal.e_ktval_tax as kr_zkmv,
       sal.e_ktval as kr_zkme,sal.e_ktval_tax as kr_zkmpdv,
       sal.kilk as nar,sal.nsuma as nar_e,sal.npdv as nar_pdv,sal.nzpdv as nar_v,
       sal.osuma as opl_ze,sal.opdv as opl_zpdv,sal.ozpdv as opl_zv,
       sal.obsuma as opl_be,sal.obpdv as opl_bpdv,sal.obzpdv as opl_bv,
       sal.oisuma as opl_ie,sal.oipdv as opl_ipdv,sal.oizpdv as opl_iv 

from   ( select c.id as id_client,c.kind_dep,c.idk_work,c.code,c.short_name, to_number(s.kod_section,''999'')  as roz 
           from clm_client_tbl c 
             left join  ( select s1.*,p.kod as kod_section from clm_statecl_tbl  s1
                          left join  cla_param_tbl p on p.id=s1.id_section
                         ) s 
           on s.id_client=c.id  where c.book<0 and c.idk_work<>0 
       order by c.id) as c
       right join ( select coalesce(obrs.id_client,nar.id_client,opl.id_client) as id_client,
                      coalesce(obrs.id_pref,nar.id_pref,opl.id_pref) as id_pref,
                      obrs.b_dtval, obrs.b_dtval_tax, 
                       obrs.b_ktval, obrs.b_ktval_tax, 
                       obrs.e_dtval,obrs.e_dtval_tax,
                       obrs.e_ktval,obrs.e_ktval_tax,
                       nar.kilk,nar.suma as nsuma,nar.pdv as npdv,
                       nar.suma_zpdv as nzpdv,
                       opl.suma as osuma,opl.pdv as opdv, 
                       opl.suma_zpdv as ozpdv,
                       opl.bsuma as obsuma,opl.bpdv as obpdv, 
                       opl.bsuma_zpdv as obzpdv,
                       opl.isuma as oisuma,opl.ipdv as oipdv, 
                       opl.isuma_zpdv as oizpdv
                     from  
                       ( select id_client,id_pref,
                           sum(b_dtval) as b_dtval,
                           sum(b_dtval_tax) as b_dtval_tax,         
                           sum(b_ktval) as b_ktval,
                           sum(b_ktval_tax) as b_ktval_tax,         
                           sum(e_dtval) as e_dtval,
                           sum(e_dtval_tax) as e_dtval_tax,         
                           sum(e_ktval) as e_ktval,
                           sum(e_ktval_tax) as e_ktval_tax         
                         from 
                          seb_obrs_tmp s1  
                        group by id_client,id_pref
                        order by id_client,id_pref
                        ) as obrs
                       full join     
                           ( select id_client,id_pref,
                             sum(kilk) as kilk,sum(suma) as suma,sum(pdv) as pdv,
                             sum (suma_zpdv) as suma_zpdv from 
                             seb_nar_tmp  where mmgg=pmmgg group by id_client,id_pref
                               order by id_client,id_pref
                             )  as nar on 
                           (nar.id_client=obrs.id_client and 
                            nar.id_pref=obrs.id_pref)
                       
                       full  join 
                            (  select ob.id_client,ob.id_pref,
                               ob.suma as suma,ob.pdv as pdv,
                               ob.suma_zpdv as suma_zpdv,
                               bank.suma as bsuma,bank.pdv as bpdv,
                               bank.suma_zpdv as bsuma_zpdv ,
                               inb.suma as isuma,inb.pdv as ipdv,
                               inb.suma_zpdv as isuma_zpdv
                              from
                               ( select id_client,id_pref,mmgg,
                                 sum(suma) as suma,sum(pdv) as pdv,
                                 sum(suma_zpdv) as suma_zpdv
                                 from seb_opl_tmp o
                                 where mmgg=pmmgg group by id_client,id_pref,mmgg
                                ) as ob
                                  left join 
                                ( select id_client,id_pref,mmgg,
                                  sum(suma) as suma,sum(pdv) as pdv,
                                  sum(suma_zpdv) as suma_zpdv
                                  from seb_opl_tmp o
                                  where mmgg=pmmgg  and vid_doc=''Банк'' group by id_client,id_pref,mmgg
                                ) as bank
                                  on (ob.id_client=bank.id_client 
                                       and ob.id_pref=bank.id_pref  
                                       and bank.mmgg=pmmgg
                                      )
                                  left join 
                                ( select id_client,id_pref,mmgg,
                                  sum(suma) as suma,sum(pdv) as pdv,
                                  sum(suma_zpdv) as suma_zpdv
                                  from seb_opl_tmp o
                                  where mmgg=pmmgg and vid_doc<>''Банк'' group by id_client,id_pref,mmgg
                                ) as inb
                                  on (ob.id_client=inb.id_client 
                                       and ob.id_pref=inb.id_pref  
                                       and inb.mmgg=pmmgg
                                      )

                              order by ob.id_client,ob.id_pref 
                            )  as opl on (opl.id_client=obrs.id_client 
                          and opl.id_pref=obrs.id_pref)
                   order by coalesce(obrs.id_client,nar.id_client,opl.id_client)) as sal
        on sal.id_client=c.id_client;
raise notice ''update__________'';
update seb_obr_all_tmp set mmgg=f.mmgg from (select fun_mmgg() as mmgg) as f;  
raise notice ''update'';
update seb_obr_all_tmp set  
   deb_pm99v=0,
   deb_pm00v=0,   deb_pm00e=0,   deb_pm00pdv=0,
   deb_pm01v=0,   deb_pm01e=0,   deb_pm01pdv=0,
   deb_pm02v=0,   deb_pm02e=0,   deb_pm02pdv=0,
   deb_km99v=0,  
   deb_km00v=0,    deb_km00e=0,    deb_km00pdv=0,
   deb_km01v=0,    deb_km01e=0,    deb_km01pdv=0,
   deb_km02v=0,    deb_km02e=0,    deb_km02pdv=0,
   deb_pm03v=0,    deb_pm03e=0,    deb_pm03pdv=0,
   deb_km03v=0,    deb_km03e=0,    deb_km03pdv=0,
   deb_pm04v=0,    deb_pm04e=0,    deb_pm04pdv=0,
   deb_km04v=0,    deb_km04e=0,    deb_km04pdv=0,
   deb_pm05v=0,   deb_pm05e=0, deb_pm05pdv=0,  deb_km05v=0, deb_km05e=0, deb_km05pdv=0,
   deb_pm06v=0,   deb_pm06e=0, deb_pm06pdv=0,  deb_km06v=0, deb_km06e=0, deb_km06pdv=0,

   b_kred=0,      b_kred_tax=0,e_kred=0,  e_kred_tax=0, 

   deb_pm07v=0,  deb_pm07e=0, deb_pm07pdv=0,  deb_km07v=0, deb_km07e=0, deb_km07pdv=0,
   deb_pm08v=0,  deb_pm08e=0, deb_pm08pdv=0,  deb_km08v=0, deb_km08e=0, deb_km08pdv=0,
   deb_pm09v=0,  deb_pm09e=0, deb_pm09pdv=0,  deb_km09v=0, deb_km09e=0, deb_km09pdv=0,
   deb_pm10v=0,  deb_pm10e=0, deb_pm10pdv=0,  deb_km10v=0, deb_km10e=0, deb_km10pdv=0,
   deb_pm11v=0,  deb_pm11e=0, deb_pm11pdv=0,  deb_km11v=0, deb_km11e=0, deb_km11pdv=0,
   deb_pm12v=0,  deb_pm12e=0, deb_pm12pdv=0,  deb_km12v=0, deb_km12e=0, deb_km12pdv=0,
   deb_pm13v=0,  deb_pm13e=0, deb_pm13pdv=0,  deb_km13v=0, deb_km13e=0, deb_km13pdv=0,
   deb_pm14v=0,  deb_pm14e=0, deb_pm14pdv=0,  deb_km14v=0, deb_km14e=0, deb_km14pdv=0,
   deb_pm15v=0,  deb_pm15e=0, deb_pm15pdv=0,  deb_km15v=0, deb_km15e=0, deb_km15pdv=0,
   deb_pm16v=0,  deb_pm16e=0, deb_pm16pdv=0,  deb_km16v=0, deb_km16e=0, deb_km16pdv=0;



raise notice ''update 9'';
update seb_obr_all_tmp set deb_pm99v=-(h.b_dtval+h.b_dtval_tax),
                   deb_km99v=-(h.e_dtval+h.e_dtval_tax)
              from ( select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''1999-01-01'';

update seb_obr_all_tmp set deb_pm00v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm00e=-h.b_dtval, deb_pm00pdv=-h.b_dtval_tax,
                   deb_km00v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km00e=-h.e_dtval, deb_km00pdv=-h.e_dtval_tax
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2000-01-01'';

update seb_obr_all_tmp set deb_pm01v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm01e=-h.b_dtval, deb_pm01pdv=-h.b_dtval_tax,
                   deb_km01v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km01e=-h.e_dtval, deb_km01pdv=-h.e_dtval_tax
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2001-01-01'';

update seb_obr_all_tmp set deb_pm02v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm02e=-h.b_dtval, deb_pm02pdv=-h.b_dtval_tax,
                   deb_km02v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km02e=-h.e_dtval, deb_km02pdv=-h.e_dtval_tax
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2002-01-01'';

update seb_obr_all_tmp set deb_pm03v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm03e=-h.b_dtval, deb_pm03pdv=-h.b_dtval_tax,
                   deb_km03v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km03e=-h.e_dtval, deb_km03pdv=-h.e_dtval_tax
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2003-01-01'';

update seb_obr_all_tmp set deb_pm04v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm04e=-h.b_dtval, deb_pm04pdv=-h.b_dtval_tax,
                   deb_km04v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km04e=-h.e_dtval, deb_km04pdv=-h.e_dtval_tax
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2004-01-01'';

update seb_obr_all_tmp set deb_pm05v=(-(h.b_dtval+h.b_dtval_tax)),
                   deb_pm05e=(-h.b_dtval), deb_pm05pdv=(-h.b_dtval_tax),
                   deb_km05v=(-(h.e_dtval+h.e_dtval_tax)),
                   deb_km05e=(-h.e_dtval), deb_km05pdv=(-h.e_dtval_tax)
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2005-01-01'';

update seb_obr_all_tmp set deb_pm06v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm06e=-h.b_dtval, deb_pm06pdv=-h.b_dtval_tax,
                   deb_km06v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km06e=-h.e_dtval, deb_km06pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end    
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2006-01-01'';

update seb_obr_all_tmp set deb_pm07v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm07e=-h.b_dtval, deb_pm07pdv=-h.b_dtval_tax,
                   deb_km07v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km07e=-h.e_dtval, deb_km07pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2007-01-01'';

update seb_obr_all_tmp set deb_pm08v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm08e=-h.b_dtval, deb_pm08pdv=-h.b_dtval_tax,
                   deb_km08v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km08e=-h.e_dtval, deb_km08pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2008-01-01'';
raise notice ''update 2009'';
-- 2009
update seb_obr_all_tmp set deb_pm09v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm09e=-h.b_dtval, deb_pm09pdv=-h.b_dtval_tax,
                   deb_km09v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km09e=-h.e_dtval, deb_km09pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2009-01-01'';

raise notice ''update 2010'';
-- 2010
update seb_obr_all_tmp set deb_pm10v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm10e=-h.b_dtval, deb_pm10pdv=-h.b_dtval_tax,
                   deb_km10v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km10e=-h.e_dtval, deb_km10pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2010-01-01'';

raise notice ''update 2011'';
-- 2011
update seb_obr_all_tmp set deb_pm11v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm11e=-h.b_dtval, deb_pm11pdv=-h.b_dtval_tax,
                   deb_km11v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km11e=-h.e_dtval, deb_km11pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2011-01-01'';
                                  

raise notice ''update 2012'';
-- 2012
update seb_obr_all_tmp set deb_pm12v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm12e=-h.b_dtval, deb_pm12pdv=-h.b_dtval_tax,
                   deb_km12v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km12e=-h.e_dtval, deb_km12pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2012-01-01'';

raise notice ''update 2013'';
-- 2013
update seb_obr_all_tmp set deb_pm13v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm13e=-h.b_dtval, 
                   deb_pm13pdv=-h.b_dtval_tax,
                   deb_km13v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km13e=-h.e_dtval, 
                   deb_km13pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2013-01-01'';

raise notice ''update 2014'';
-- 2013
update seb_obr_all_tmp set deb_pm14v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm14e=-h.b_dtval, 
                   deb_pm14pdv=-h.b_dtval_tax,
                   deb_km14v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km14e=-h.e_dtval, 
                   deb_km14pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2014-01-01'';

-- update 2015

update seb_obr_all_tmp set deb_pm15v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm15e=-h.b_dtval, 
                   deb_pm15pdv=-h.b_dtval_tax,
                   deb_km15v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km15e=-h.e_dtval, 
                   deb_km15pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2015-01-01'';

update seb_obr_all_tmp set deb_pm16v=-(h.b_dtval+h.b_dtval_tax),
                   deb_pm16e=-h.b_dtval, 
                   deb_pm16pdv=-h.b_dtval_tax,
                   deb_km16v=-(h.e_dtval+h.e_dtval_tax),
                   deb_km16e=-h.e_dtval, 
                   deb_km16pdv=-h.e_dtval_tax,
                    b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,hmmgg,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax

                    from seb_obrs_tmp 
                    group by  id_client,id_pref,hmmgg
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref 
        and h.hmmgg=''2016-01-01'';


   /*
update seb_obr_all_tmp set 
 b_kred= case when ( h.b_ktval<>0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 
                             case when ( h.b_ktval=0 and h.b_dtval<0) then (h.b_ktval-coalesce(h.b_dtval,0)) else 0  end 
                           end ,
                   b_kred_tax=case when ( h.b_ktval_tax<>0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 
                                    case when ( h.b_ktval_tax=0 and h.b_dtval_tax<0) then (h.b_ktval_tax-coalesce(h.b_dtval_tax,0)) else 0 end 
                       end ,
                   e_kred=case when ( h.e_ktval<>0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 
                                case when ( h.e_ktval=0 and h.e_dtval<0) then (h.e_ktval-coalesce(h.e_dtval,0)) else 0 end
                  end , 
                   e_kred_tax=case when ( h.e_ktval_tax<>0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 
                                    case when ( h.e_ktval_tax=0 and h.e_dtval_tax<0) then (h.e_ktval_tax-coalesce(h.e_dtval_tax,0)) else 0 end 
                       end 
              from ( 
                    select id_client,id_pref,
                     sum(b_dtval) as b_dtval,
                     sum(b_dtval_tax) as b_dtval_tax,
                     sum(e_dtval) as e_dtval,
                     sum(e_dtval_tax) as e_dtval_tax,
                     sum(b_ktval) as b_ktval,
                     sum(b_ktval_tax) as b_ktval_tax,
                     sum(e_ktval) as e_ktval,
                     sum(e_ktval_tax) as e_ktval_tax
                    from seb_obrs_tmp where hmmgg>= ''2006-01-01''
                    group by  id_client,id_pref
                   ) h 
   where h.id_client=seb_obr_all_tmp.id_client and h.id_pref=seb_obr_all_tmp.id_pref; 
                                   
 */
--                    from seb_obrs_tmp where hmmgg>= ''2007-01-01''
               
raise notice ''update all '';
raise notice ''pmmgg %'',pmmgg;

                                  
update seb_obr_all_tmp set deb_zpmv=0,kr_zpmv=kr_zpmv+deb_zpmv,
                       deb_zpme=0,kr_zpme=kr_zpme+deb_zpme,
                       deb_zpmpdv=0,kr_zpmpdv=kr_zpmpdv+deb_zpmpdv
             where deb_zpmv>0;
 
if date_part(''year'',pmmgg) = 2009 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm09v=deb_pm09v+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm09e=deb_pm09e+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm09pdv=deb_pm09pdv+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km09v=deb_km09v+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km09e=deb_km09e+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km09pdv=deb_km09pdv+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm09v=coalesce(deb_pm09v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm09e=coalesce(deb_pm09e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm09pdv=deb_pm09pdv+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km09v=coalesce(deb_km09v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km09e=coalesce(deb_km09e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km09pdv=deb_km09pdv+kr_zkmpdv
             where kr_zkmv<0;


end if;

if date_part(''year'',pmmgg) = 2010 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm10v=coalesce(deb_pm10v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm10e=coalesce(deb_pm10e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm10pdv=coalesce(deb_pm10pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km10v=coalesce(deb_km10v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km10e=coalesce(deb_km10e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km10pdv=coalesce(deb_km10pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm10v=coalesce(deb_pm10v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm10e=coalesce(deb_pm10e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm10pdv=coalesce(deb_pm10pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km10v=coalesce(deb_km10v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km10e=coalesce(deb_km10e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km10pdv=coalesce(deb_km10pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;

if date_part(''year'',pmmgg) = 2011 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm11v=coalesce(deb_pm11v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm11e=coalesce(deb_pm11e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm11pdv=coalesce(deb_pm11pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km11v=coalesce(deb_km11v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km11e=coalesce(deb_km11e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km11pdv=coalesce(deb_km11pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm11v=coalesce(deb_pm11v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm11e=coalesce(deb_pm11e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm11pdv=coalesce(deb_pm11pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km11v=coalesce(deb_km11v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km11e=coalesce(deb_km11e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km11pdv=coalesce(deb_km11pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;

if date_part(''year'',pmmgg) = 2012 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm12v=coalesce(deb_pm12v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm12e=coalesce(deb_pm12e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm12pdv=coalesce(deb_pm12pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km12v=coalesce(deb_km12v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km12e=coalesce(deb_km12e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km12pdv=coalesce(deb_km12pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm12v=coalesce(deb_pm12v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm12e=coalesce(deb_pm12e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm12pdv=coalesce(deb_pm12pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km12v=coalesce(deb_km12v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km12e=coalesce(deb_km12e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km12pdv=coalesce(deb_km12pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;

if date_part(''year'',pmmgg) = 2013 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm13v=coalesce(deb_pm13v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm13e=coalesce(deb_pm13e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm13pdv=coalesce(deb_pm13pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km13v=coalesce(deb_km13v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km13e=coalesce(deb_km13e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km13pdv=coalesce(deb_km13pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm13v=coalesce(deb_pm13v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm13e=coalesce(deb_pm13e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm13pdv=coalesce(deb_pm13pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km13v=coalesce(deb_km13v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km13e=coalesce(deb_km13e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km13pdv=coalesce(deb_km13pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;

if date_part(''year'',pmmgg) = 2014 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm14v=coalesce(deb_pm14v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm14e=coalesce(deb_pm14e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm14pdv=coalesce(deb_pm14pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km14v=coalesce(deb_km14v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km14e=coalesce(deb_km14e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km14pdv=coalesce(deb_km14pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm14v=coalesce(deb_pm14v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm14e=coalesce(deb_pm14e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm14pdv=coalesce(deb_pm14pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km14v=coalesce(deb_km14v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km14e=coalesce(deb_km14e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km14pdv=coalesce(deb_km14pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;


if date_part(''year'',pmmgg) = 2015 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm15v=coalesce(deb_pm15v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm15e=coalesce(deb_pm15e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm15pdv=coalesce(deb_pm15pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km15v=coalesce(deb_km15v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km15e=coalesce(deb_km15e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km15pdv=coalesce(deb_km15pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm15v=coalesce(deb_pm15v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm15e=coalesce(deb_pm15e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm15pdv=coalesce(deb_pm15pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km15v=coalesce(deb_km15v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km15e=coalesce(deb_km15e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km15pdv=coalesce(deb_km15pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;

if date_part(''year'',pmmgg) = 2016 then
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm16v=coalesce(deb_pm16v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm16e=coalesce(deb_pm16e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm16pdv=coalesce(deb_pm16pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km16v=coalesce(deb_km16v,0)+kr_zkmv,
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km16e=coalesce(deb_km16e,0)+kr_zkme,
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km16pdv=coalesce(deb_km16pdv,0)+kr_zkmpdv
             where kr_zkmv<0;
                         
update seb_obr_all_tmp set kr_zpmv=0,deb_zpmv=deb_zpmv+kr_zpmv,deb_pm16v=coalesce(deb_pm16v,0)+kr_zpmv,
                       kr_zpme=0,deb_zpme=deb_zpme+kr_zpme, deb_pm16e=coalesce(deb_pm16e,0)+kr_zpme,
                       kr_zpmpdv=0,deb_zpmpdv=deb_zpmpdv+kr_zpmpdv,deb_pm16pdv=coalesce(deb_pm16pdv,0)+kr_zpmpdv
             where kr_zpmv<0;


update seb_obr_all_tmp set kr_zkmv=0, deb_kmv=deb_kmv+kr_zkmv,deb_km16v=coalesce(deb_km16v,0)+coalesce(kr_zkmv,0),
                           kr_zkme=0,deb_kme=deb_kme+kr_zkme, deb_km16e=coalesce(deb_km16e,0)+coalesce(kr_zkme,0),
                           kr_zkmpdv=0,deb_kmpdv=deb_kmpdv+kr_zkmpdv,deb_km16pdv=coalesce(deb_km16pdv,0)+coalesce(kr_zkmpdv,0)
             where kr_zkmv<0;


end if;

--15
                                            
update seb_obr_all_tmp set b_kred=0, b_kred_tax=0
             where b_kred<0;


update seb_obr_all_tmp set e_kred=0, e_kred_tax=0
             where e_kred<0;
                                              
update seb_obr_all_tmp set deb_kmv=0,kr_zkmv=kr_zkmv+deb_kmv,
                       deb_kme=0,kr_zkme=kr_zkme+deb_kme,
                       deb_kmpdv=0,kr_zkmpdv=kr_zkmpdv+deb_kmpdv
             where deb_kmv>0;
               
update seb_obr_all_tmp set deb_pm05v=0,
                       deb_pm05e=0,
                       deb_pm05pdv=0
             where deb_pm05v>0;
                 

update seb_obr_all_tmp set deb_km05v=0,
                       deb_km05e=0,
                       deb_km05pdv=0
             where deb_km05v>0; 

update seb_obr_all_tmp set deb_pm06v=0,
                       deb_pm06e=0,
                       deb_pm06pdv=0
             where deb_pm06v>0;
                 

update seb_obr_all_tmp set deb_km06v=0,
                       deb_km06e=0,
                       deb_km06pdv=0
             where deb_km06v>0; 
                             
update seb_obr_all_tmp set deb_pm07v=0,
                       deb_pm07e=0,
                       deb_pm07pdv=0
             where deb_pm07v>0;
                 

update seb_obr_all_tmp set deb_km07v=0,
                       deb_km07e=0,
                       deb_km07pdv=0
             where deb_km07v>0; 

update seb_obr_all_tmp set deb_pm08v=0,
                       deb_pm08e=0,
                       deb_pm08pdv=0
             where deb_pm08v>0;
                 

update seb_obr_all_tmp set deb_km08v=0,
                       deb_km08e=0,
                       deb_km08pdv=0
             where deb_km08v>0; 


if pmmgg=''2008-01-01'' then
raise notice ''update all 2008-01-01'';

update seb_obr_all_tmp set deb_pm07v=deb_pm07v+deb_pm08v,
                   deb_pm07e=deb_pm07e+deb_pm08e, 
                   deb_pm07pdv=deb_pm07pdv+deb_pm08pdv;

update seb_obr_all_tmp set deb_pm08v=0,
                   deb_pm08e=0, deb_pm08pdv=0;
end if;


if pmmgg=''2009-01-01'' then
raise notice ''update all 2009-01-01'';

update seb_obr_all_tmp set deb_pm08v=deb_pm08v+deb_pm09v,
                   deb_pm08e=deb_pm08e+deb_pm09e, 
                   deb_pm08pdv=deb_pm08pdv+deb_pm09pdv;

update seb_obr_all_tmp set deb_pm09v=0,
                   deb_pm09e=0, deb_pm09pdv=0;
end if;

if pmmgg=''2010-01-01'' then
raise notice ''update all 2010-01-01'';

update seb_obr_all_tmp set deb_pm09v=deb_pm09v+deb_pm10v,
                   deb_pm09e=deb_pm09e+deb_pm10e, 
                   deb_pm09pdv=deb_pm09pdv+deb_pm10pdv;

update seb_obr_all_tmp set deb_pm10v=0,
                   deb_pm10e=0, deb_pm10pdv=0;
end if;


if pmmgg=''2011-01-01'' then
 raise notice ''update all 2011-01-01'';
 update seb_obr_all_tmp set deb_pm10v=deb_pm10v+deb_pm11v,
                   deb_pm10e=deb_pm10e+deb_pm11e, 
                   deb_pm10pdv=deb_pm10pdv+deb_pm11pdv;

 update seb_obr_all_tmp set deb_pm11v=0,
                   deb_pm11e=0, deb_pm11pdv=0;
end if;

if pmmgg=''2012-01-01'' then
 raise notice ''update all 2012-01-01'';
 update seb_obr_all_tmp set deb_pm11v=deb_pm11v+deb_pm12v,
                   deb_pm11e=deb_pm11e+deb_pm12e, 
                   deb_pm11pdv=deb_pm11pdv+deb_pm12pdv;

 update seb_obr_all_tmp set deb_pm12v=0,
                   deb_pm12e=0, deb_pm12pdv=0;
end if;

if pmmgg=''2013-01-01'' then
 raise notice ''update all 2013-01-01'';
 update seb_obr_all_tmp set deb_pm12v=deb_pm12v+deb_pm13v,
                   deb_pm12e=deb_pm12e+deb_pm13e, 
                   deb_pm12pdv=deb_pm12pdv+deb_pm13pdv;

 update seb_obr_all_tmp set deb_pm13v=0,
                   deb_pm13e=0, deb_pm13pdv=0;
end if;

if pmmgg=''2014-01-01'' then
 raise notice ''update all 2013-01-01'';
 update seb_obr_all_tmp set deb_pm13v=deb_pm13v+deb_pm14v,
                   deb_pm13e=deb_pm13e+deb_pm14e, 
                   deb_pm13pdv=deb_pm13pdv+deb_pm14pdv;

 update seb_obr_all_tmp set deb_pm14v=0,
                   deb_pm14e=0, deb_pm14pdv=0;
end if;

if pmmgg=''2015-01-01'' then
 raise notice ''update all 2015-01-01'';
 update seb_obr_all_tmp set deb_pm14v=deb_pm14v+deb_pm15v,
                   deb_pm14e=deb_pm14e+deb_pm15e, 
                   deb_pm14pdv=deb_pm14pdv+deb_pm15pdv;

 update seb_obr_all_tmp set deb_pm15v=0,
                   deb_pm15e=0, deb_pm15pdv=0;
end if;

if pmmgg=''2016-01-01'' then
 raise notice ''update all 2016-01-01'';
 update seb_obr_all_tmp set deb_pm15v=deb_pm15v+deb_pm16v,
                   deb_pm15e=deb_pm15e+deb_pm16e, 
                   deb_pm15pdv=deb_pm15pdv+deb_pm16pdv;

 update seb_obr_all_tmp set deb_pm16v=0,
                   deb_pm16e=0, deb_pm16pdv=0;
end if;


                               
update seb_obr_all_tmp set mmgg=period;
-- delete tranzit;
delete from seb_obr_all_tmp  where roz=100 and id_pref=10;
-- -- delete arhiv,delete 

update   seb_obr_all_tmp set roz=-100 from clm_client_tbl c
where c.id=seb_obr_all_tmp.id_client and (c.id_state=50 or c.id_state=99) and 
  abs(coalesce(deb_zpmv,0.00))+abs(coalesce(deb_zpme,0.00))+abs(coalesce(deb_zpmpdv,0.00))
  +abs(coalesce(kr_zpmv,0.00))+abs(coalesce(kr_zpme,0.00))+abs(coalesce(kr_zpmpdv,0.00))+
  abs(coalesce(nar,0.00))+abs(coalesce(nar_v,0.00))+abs(coalesce(nar_e,0.00))+abs(coalesce(nar_pdv,0.00))
  +abs(coalesce(opl_zv,0.00))+abs(coalesce(opl_ze,0.00))+abs(coalesce(opl_zpdv,0.00))=0.00; 
  delete from  seb_obr_all_tmp where roz=-100;

-- delete emty row exepr activ ee
update   seb_obr_all_tmp set roz=-100 from clm_client_tbl c
where id_pref<>10 and c.id=seb_obr_all_tmp.id_client  and 
abs(coalesce(deb_zpmv,0.00))+abs(coalesce(deb_zpme,0.00))+abs(coalesce(deb_zpmpdv,0.00))
  +abs(coalesce(kr_zpmv,0.00))+abs(coalesce(kr_zpme,0.00))+abs(coalesce(kr_zpmpdv,0.00))+
  abs(coalesce(nar,0.00))+abs(coalesce(nar_v,0.00))+abs(coalesce(nar_e,0.00))+abs(coalesce(nar_pdv,0.00))
  +abs(coalesce(opl_zv,0.00))+abs(coalesce(opl_ze,0.00))+abs(coalesce(opl_zpdv,0.00))=0.00; 
   delete from  seb_obr_all_tmp where roz=-100;


  
if ((cop=2) and (clip is null)) then
 tabl=path_export||kodres||''OBR.TXT'';
 del=''@''; nul='''';
 raise notice ''OBR'';
 delete from seb_obr_tmp;
  insert into seb_obr_tmp select * from seb_obr_all_tmp where id_pref=10 and 
 id_client is not null
 order by cod_r,osob_r ;
-- delete tranzit;
 delete from seb_obr_tmp where roz=100 and id_pref=10;

SQL=''copy  seb_obr_tmp 
 ( cod_r, roz, cod_pidr, period ,  osob_r, osob_rsk ,  deb_zpmv ,  deb_zpme ,  deb_zpmpdv ,  kr_zpmv ,  kr_zpme ,  kr_zpmpdv ,  deb_pm99v ,  deb_pm00v ,  deb_pm00e ,  deb_pm00pdv ,  deb_pm01v ,  deb_pm01e ,  deb_pm01pdv ,  deb_pm02v ,  deb_pm02e ,  deb_pm02pdv ,  nar ,  nar_v ,  nar_e ,  nar_pdv ,  opl_zv ,  opl_ze ,  opl_zpdv ,  opl_bv ,  opl_be ,  opl_bpdv ,  opl_iv ,  opl_ie ,  opl_ipdv ,  deb_kmv ,  deb_kme ,  deb_kmpdv ,  kr_zkmv ,  kr_zkme ,  kr_zkmpdv ,  deb_km99v ,  deb_km00v ,  deb_km00e ,  deb_km00pdv ,  deb_km01v ,  deb_km01e ,  deb_km01pdv ,  deb_km02v ,  deb_km02e ,  deb_km02pdv ,  deb_pm03v ,  deb_pm03e ,  deb_pm03pdv ,  deb_km03v ,  deb_km03e ,  deb_km03pdv ,  deb_pm04v ,  deb_pm04e ,  deb_pm04pdv ,  deb_km04v ,  deb_km04e ,  deb_km04pdv ,  deb_pm05v ,  deb_pm05e ,  deb_pm05pdv ,  deb_km05v ,  deb_km05e ,  deb_km05pdv ,  deb_pm06v ,  deb_pm06e ,  deb_pm06pdv ,  deb_km06v ,  deb_km06e ,  deb_km06pdv , deb_pm07v ,  deb_pm07e ,  deb_pm07pdv ,  deb_km07v ,  deb_km07e ,  deb_km07pdv
, deb_pm08v ,  deb_pm08e ,  deb_pm08pdv ,  deb_km08v ,  deb_km08e ,  deb_km08pdv
, deb_pm09v ,  deb_pm09e ,  deb_pm09pdv ,  deb_km09v ,  deb_km09e ,  deb_km09pdv
, deb_pm10v ,  deb_pm10e ,  deb_pm10pdv ,  deb_km10v ,  deb_km10e ,  deb_km10pdv
, deb_pm11v ,  deb_pm11e ,  deb_pm11pdv ,  deb_km11v ,  deb_km11e ,  deb_km11pdv
, deb_pm12v ,  deb_pm12e ,  deb_pm12pdv ,  deb_km12v ,  deb_km12e ,  deb_km12pdv
, deb_pm13v ,  deb_pm13e ,  deb_pm13pdv ,  deb_km13v ,  deb_km13e ,  deb_km13pdv
, deb_pm14v ,  deb_pm14e ,  deb_pm14pdv ,  deb_km14v ,  deb_km14e ,  deb_km14pdv
, deb_pm15v ,  deb_pm15e ,  deb_pm15pdv ,  deb_km15v ,  deb_km15e ,  deb_km15pdv
, deb_pm16v ,  deb_pm16e ,  deb_pm16pdv ,  deb_km16v ,  deb_km16e ,  deb_km16pdv
)
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;
 


 raise notice ''OBRR'';
 tabl=path_export||kodres||''OBRR.TXT'';
 delete from seb_obr_tmp;
 insert into seb_obr_tmp select * from seb_obr_all_tmp where id_pref=20  and id_client is not null
 order by cod_r,osob_r ;
 SQL=''copy  seb_obr_tmp 
 ( cod_r, roz, cod_pidr, period ,  osob_r, osob_rsk ,  deb_zpmv ,  deb_zpme ,  deb_zpmpdv ,  kr_zpmv ,  kr_zpme ,  kr_zpmpdv ,  deb_pm99v ,  deb_pm00v ,  deb_pm00e ,  deb_pm00pdv ,  deb_pm01v ,  deb_pm01e ,  deb_pm01pdv ,  deb_pm02v ,  deb_pm02e ,  deb_pm02pdv ,  nar ,  nar_v ,  nar_e ,  nar_pdv ,  opl_zv ,  opl_ze ,  opl_zpdv ,  opl_bv ,  opl_be ,  opl_bpdv ,  opl_iv ,  opl_ie ,  opl_ipdv ,  deb_kmv ,  deb_kme ,  deb_kmpdv ,  kr_zkmv ,  kr_zkme ,  kr_zkmpdv ,  deb_km99v ,  deb_km00v ,  deb_km00e ,  deb_km00pdv ,  deb_km01v ,  deb_km01e ,  deb_km01pdv ,  deb_km02v ,  deb_km02e ,  deb_km02pdv ,  deb_pm03v ,  deb_pm03e ,  deb_pm03pdv ,  deb_km03v ,  deb_km03e ,  deb_km03pdv ,  deb_pm04v ,  deb_pm04e ,  deb_pm04pdv ,  deb_km04v ,  deb_km04e ,  deb_km04pdv ,  deb_pm05v ,  deb_pm05e ,  deb_pm05pdv ,  deb_km05v ,  deb_km05e ,  deb_km05pdv ,  deb_pm06v ,  deb_pm06e ,  deb_pm06pdv ,  deb_km06v ,  deb_km06e ,  deb_km06pdv , deb_pm07v ,  deb_pm07e ,  deb_pm07pdv ,  deb_km07v ,  deb_km07e ,  deb_km07pdv
, deb_pm08v ,  deb_pm08e ,  deb_pm08pdv ,  deb_km08v ,  deb_km08e ,  deb_km08pdv
, deb_pm09v ,  deb_pm09e ,  deb_pm09pdv ,  deb_km09v ,  deb_km09e ,  deb_km09pdv
, deb_pm10v ,  deb_pm10e ,  deb_pm10pdv ,  deb_km10v ,  deb_km10e ,  deb_km10pdv
, deb_pm11v ,  deb_pm11e ,  deb_pm11pdv ,  deb_km11v ,  deb_km11e ,  deb_km11pdv
, deb_pm12v ,  deb_pm12e ,  deb_pm12pdv ,  deb_km12v ,  deb_km12e ,  deb_km12pdv
, deb_pm13v ,  deb_pm13e ,  deb_pm13pdv ,  deb_km13v ,  deb_km13e ,  deb_km13pdv
, deb_pm14v ,  deb_pm14e ,  deb_pm14pdv ,  deb_km14v ,  deb_km14e ,  deb_km14pdv
, deb_pm15v ,  deb_pm15e ,  deb_pm15pdv ,  deb_km15v ,  deb_km15e ,  deb_km15pdv
, deb_pm16v ,  deb_pm16e ,  deb_pm16pdv ,  deb_km16v ,  deb_km16e ,  deb_km16pdv
)
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

raise notice ''222'';
 tabl=path_export||kodres||''OBR2M.TXT'';
 delete from seb_obr_tmp;
 insert into seb_obr_tmp select * from seb_obr_all_tmp where id_pref=510  and id_client is not null
 order by cod_r,osob_r ;
 SQL=''copy  seb_obr_tmp 
 ( cod_r, roz, cod_pidr, period ,  osob_r, osob_rsk ,  deb_zpmv ,  deb_zpme ,  deb_zpmpdv ,  kr_zpmv ,  kr_zpme ,  kr_zpmpdv ,  deb_pm99v ,  deb_pm00v ,  deb_pm00e ,  deb_pm00pdv ,  deb_pm01v ,  deb_pm01e ,  deb_pm01pdv ,  deb_pm02v ,  deb_pm02e ,  deb_pm02pdv ,  nar ,  nar_v ,  nar_e ,  nar_pdv ,  opl_zv ,  opl_ze ,  opl_zpdv ,  opl_bv ,  opl_be ,  opl_bpdv ,  opl_iv ,  opl_ie ,  opl_ipdv ,  deb_kmv ,  deb_kme ,  deb_kmpdv ,  kr_zkmv ,  kr_zkme ,  kr_zkmpdv ,  deb_km99v ,  deb_km00v ,  deb_km00e ,  deb_km00pdv ,  deb_km01v ,  deb_km01e ,  deb_km01pdv ,  deb_km02v ,  deb_km02e ,  deb_km02pdv ,  deb_pm03v ,  deb_pm03e ,  deb_pm03pdv ,  deb_km03v ,  deb_km03e ,  deb_km03pdv ,  deb_pm04v ,  deb_pm04e ,  deb_pm04pdv ,  deb_km04v ,  deb_km04e ,  deb_km04pdv ,  deb_pm05v ,  deb_pm05e ,  deb_pm05pdv ,  deb_km05v ,  deb_km05e ,  deb_km05pdv,  deb_pm06v ,  deb_pm06e ,  deb_pm06pdv ,  deb_km06v ,  deb_km06e ,  deb_km06pdv , deb_pm07v ,  deb_pm07e ,  deb_pm07pdv ,  deb_km07v ,  deb_km07e ,  deb_km07pdv 
, deb_pm08v ,  deb_pm08e ,  deb_pm08pdv ,  deb_km08v ,  deb_km08e ,  deb_km08pdv
, deb_pm09v ,  deb_pm09e ,  deb_pm09pdv ,  deb_km09v ,  deb_km09e ,  deb_km09pdv
, deb_pm10v ,  deb_pm10e ,  deb_pm10pdv ,  deb_km10v ,  deb_km10e ,  deb_km10pdv
, deb_pm11v ,  deb_pm11e ,  deb_pm11pdv ,  deb_km11v ,  deb_km11e ,  deb_km11pdv
, deb_pm12v ,  deb_pm12e ,  deb_pm12pdv ,  deb_km12v ,  deb_km12e ,  deb_km12pdv
, deb_pm13v ,  deb_pm13e ,  deb_pm13pdv ,  deb_km13v ,  deb_km13e ,  deb_km13pdv
, deb_pm14v ,  deb_pm14e ,  deb_pm14pdv ,  deb_km14v ,  deb_km14e ,  deb_km14pdv
, deb_pm15v ,  deb_pm15e ,  deb_pm15pdv ,  deb_km15v ,  deb_km15e ,  deb_km15pdv
, deb_pm16v ,  deb_pm16e ,  deb_pm16pdv ,  deb_km16v ,  deb_km16e ,  deb_km16pdv
)

 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;


raise notice ''333'';
 tabl=path_export||kodres||''OBR2P.TXT'';
 delete from seb_obr_tmp;
 insert into seb_obr_tmp select * from seb_obr_all_tmp where id_pref in (524,520)  and id_client is not null
 order by cod_r,osob_r ;
 SQL=''copy  seb_obr_tmp  
 ( cod_r, roz, cod_pidr, period ,  osob_r, osob_rsk ,  deb_zpmv ,  deb_zpme ,  deb_zpmpdv ,  kr_zpmv ,  kr_zpme ,  kr_zpmpdv ,  deb_pm99v ,  deb_pm00v ,  deb_pm00e ,  deb_pm00pdv ,  deb_pm01v ,  deb_pm01e ,  deb_pm01pdv ,  deb_pm02v ,  deb_pm02e ,  deb_pm02pdv ,  nar ,  nar_v ,  nar_e ,  nar_pdv ,  opl_zv ,  opl_ze ,  opl_zpdv ,  opl_bv ,  opl_be ,  opl_bpdv ,  opl_iv ,  opl_ie ,  opl_ipdv ,  deb_kmv ,  deb_kme ,  deb_kmpdv ,  kr_zkmv ,  kr_zkme ,  kr_zkmpdv ,  deb_km99v ,  deb_km00v ,  deb_km00e ,  deb_km00pdv ,  deb_km01v ,  deb_km01e ,  deb_km01pdv ,  deb_km02v ,  deb_km02e ,  deb_km02pdv ,  deb_pm03v ,  deb_pm03e ,  deb_pm03pdv ,  deb_km03v ,  deb_km03e ,  deb_km03pdv ,  deb_pm04v ,  deb_pm04e ,  deb_pm04pdv ,  deb_km04v ,  deb_km04e ,  deb_km04pdv ,  deb_pm05v ,  deb_pm05e ,  deb_pm05pdv ,  deb_km05v ,  deb_km05e ,  deb_km05pdv,  deb_pm06v ,  deb_pm06e ,  deb_pm06pdv ,  deb_km06v ,  deb_km06e ,  deb_km06pdv , deb_pm07v ,  deb_pm07e ,  deb_pm07pdv ,  deb_km07v ,  deb_km07e ,  deb_km07pdv 
, deb_pm08v ,  deb_pm08e ,  deb_pm08pdv ,  deb_km08v ,  deb_km08e ,  deb_km08pdv
, deb_pm09v ,  deb_pm09e ,  deb_pm09pdv ,  deb_km09v ,  deb_km09e ,  deb_km09pdv
, deb_pm10v ,  deb_pm10e ,  deb_pm10pdv ,  deb_km10v ,  deb_km10e ,  deb_km10pdv
, deb_pm11v ,  deb_pm11e ,  deb_pm11pdv ,  deb_km11v ,  deb_km11e ,  deb_km11pdv
, deb_pm12v ,  deb_pm12e ,  deb_pm12pdv ,  deb_km12v ,  deb_km12e ,  deb_km12pdv
, deb_pm13v ,  deb_pm13e ,  deb_pm13pdv ,  deb_km13v ,  deb_km13e ,  deb_km13pdv
, deb_pm14v ,  deb_pm14e ,  deb_pm14pdv ,  deb_km14v ,  deb_km14e ,  deb_km14pdv
, deb_pm15v ,  deb_pm15e ,  deb_pm15pdv ,  deb_km15v ,  deb_km15e ,  deb_km15pdv
, deb_pm16v ,  deb_pm16e ,  deb_pm16pdv ,  deb_km16v ,  deb_km16e ,  deb_km16pdv
)
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;



 raise notice ''555'';
 tabl=path_export||kodres||OBRP.TXT'';
 delete from seb_obr_tmp;

 insert into seb_obr_tmp select * from seb_obr_all_tmp where id_pref=901  and id_client is not null
 order by cod_r,osob_r ;
 SQL=''copy  seb_obr_tmp 
 ( cod_r, roz, cod_pidr, period ,  osob_r, osob_rsk ,  deb_zpmv ,  deb_zpme ,  deb_zpmpdv ,  kr_zpmv ,  kr_zpme ,  kr_zpmpdv ,  deb_pm99v ,  deb_pm00v ,  deb_pm00e ,  deb_pm00pdv ,  deb_pm01v ,  deb_pm01e ,  deb_pm01pdv ,  deb_pm02v ,  deb_pm02e ,  deb_pm02pdv ,  nar ,  nar_v ,  nar_e ,  nar_pdv ,  opl_zv ,  opl_ze ,  opl_zpdv ,  opl_bv ,  opl_be ,  opl_bpdv ,  opl_iv ,  opl_ie ,  opl_ipdv ,  deb_kmv ,  deb_kme ,  deb_kmpdv ,  kr_zkmv ,  kr_zkme ,  kr_zkmpdv ,  deb_km99v ,  deb_km00v ,  deb_km00e ,  deb_km00pdv ,  deb_km01v ,  deb_km01e ,  deb_km01pdv ,  deb_km02v ,  deb_km02e ,  deb_km02pdv ,  deb_pm03v ,  deb_pm03e ,  deb_pm03pdv ,  deb_km03v ,  deb_km03e ,  deb_km03pdv ,  deb_pm04v ,  deb_pm04e ,  deb_pm04pdv ,  deb_km04v ,  deb_km04e ,  deb_km04pdv ,  deb_pm05v ,  deb_pm05e ,  deb_pm05pdv ,  deb_km05v ,  deb_km05e ,  deb_km05pdv ,  deb_pm06v ,  deb_pm06e ,  deb_pm06pdv ,  deb_km06v ,  deb_km06e ,  deb_km06pdv , deb_pm07v ,  deb_pm07e ,  deb_pm07pdv ,  deb_km07v ,  deb_km07e ,  deb_km07pdv
, deb_pm08v ,  deb_pm08e ,  deb_pm08pdv ,  deb_km08v ,  deb_km08e ,  deb_km08pdv
, deb_pm09v ,  deb_pm09e ,  deb_pm09pdv ,  deb_km09v ,  deb_km09e ,  deb_km09pdv
, deb_pm10v ,  deb_pm10e ,  deb_pm10pdv ,  deb_km10v ,  deb_km10e ,  deb_km10pdv
, deb_pm11v ,  deb_pm11e ,  deb_pm11pdv ,  deb_km11v ,  deb_km11e ,  deb_km11pdv
, deb_pm12v ,  deb_pm12e ,  deb_pm12pdv ,  deb_km12v ,  deb_km12e ,  deb_km12pdv
, deb_pm13v ,  deb_pm13e ,  deb_pm13pdv ,  deb_km13v ,  deb_km13e ,  deb_km13pdv
, deb_pm14v ,  deb_pm14e ,  deb_pm14pdv ,  deb_km14v ,  deb_km14e ,  deb_km14pdv
, deb_pm15v ,  deb_pm15e ,  deb_pm15pdv ,  deb_km15v ,  deb_km15e ,  deb_km15pdv
, deb_pm16v ,  deb_pm16e ,  deb_pm16pdv ,  deb_km16v ,  deb_km16e ,  deb_km16pdv
)
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

raise notice ''IIII'';
raise notice ''obri'';
 tabl=path_export||kodres||''OBRI.TXT'';
 delete from seb_obr_tmp;
 insert into seb_obr_tmp select * from seb_obr_all_tmp where id_pref=902  and id_client is not null
 order by cod_r,osob_r ;
 SQL=''copy  seb_obr_tmp 
 ( cod_r, roz, cod_pidr, period ,  osob_r, osob_rsk ,  deb_zpmv ,  deb_zpme ,  deb_zpmpdv ,  kr_zpmv ,  kr_zpme ,  kr_zpmpdv ,  deb_pm99v ,  deb_pm00v ,  deb_pm00e ,  deb_pm00pdv ,  deb_pm01v ,  deb_pm01e ,  deb_pm01pdv ,  deb_pm02v ,  deb_pm02e ,  deb_pm02pdv ,  nar ,  nar_v ,  nar_e ,  nar_pdv ,  opl_zv ,  opl_ze ,  opl_zpdv ,  opl_bv ,  opl_be ,  opl_bpdv ,  opl_iv ,  opl_ie ,  opl_ipdv ,  deb_kmv ,  deb_kme ,  deb_kmpdv ,  kr_zkmv ,  kr_zkme ,  kr_zkmpdv ,  deb_km99v ,  deb_km00v ,  deb_km00e ,  deb_km00pdv ,  deb_km01v ,  deb_km01e ,  deb_km01pdv ,  deb_km02v ,  deb_km02e ,  deb_km02pdv ,  deb_pm03v ,  deb_pm03e ,  deb_pm03pdv ,  deb_km03v ,  deb_km03e ,  deb_km03pdv ,  deb_pm04v ,  deb_pm04e ,  deb_pm04pdv ,  deb_km04v ,  deb_km04e ,  deb_km04pdv ,  deb_pm05v ,  deb_pm05e ,  deb_pm05pdv ,  deb_km05v ,  deb_km05e ,  deb_km05pdv,  deb_pm06v ,  deb_pm06e ,  deb_pm06pdv ,  deb_km06v ,  deb_km06e ,  deb_km06pdv , deb_pm07v ,  deb_pm07e ,  deb_pm07pdv ,  deb_km07v ,  deb_km07e ,  deb_km07pdv 
, deb_pm08v ,  deb_pm08e ,  deb_pm08pdv ,  deb_km08v ,  deb_km08e ,  deb_km08pdv
, deb_pm09v ,  deb_pm09e ,  deb_pm09pdv ,  deb_km09v ,  deb_km09e ,  deb_km09pdv
, deb_pm10v ,  deb_pm10e ,  deb_pm10pdv ,  deb_km10v ,  deb_km10e ,  deb_km10pdv
, deb_pm11v ,  deb_pm11e ,  deb_pm11pdv ,  deb_km11v ,  deb_km11e ,  deb_km11pdv
, deb_pm12v ,  deb_pm12e ,  deb_pm12pdv ,  deb_km12v ,  deb_km12e ,  deb_km12pdv
, deb_pm13v ,  deb_pm13e ,  deb_pm13pdv ,  deb_km13v ,  deb_km13e ,  deb_km13pdv
, deb_pm14v ,  deb_pm14e ,  deb_pm14pdv ,  deb_km14v ,  deb_km14e ,  deb_km14pdv
, deb_pm15v ,  deb_pm15e ,  deb_pm15pdv ,  deb_km15v ,  deb_km15e ,  deb_km15pdv
, deb_pm16v ,  deb_pm16e ,  deb_pm16pdv ,  deb_km16v ,  deb_km16e ,  deb_km16pdv
)
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;


raise notice ''BANK'';

 delete from seb_bank_tmp;
 insert into seb_bank_tmp (cod_r,mmgg) values  (kodres,pmmgg);
 insert into seb_bank_tmp (cod_r,mmgg) values  (kodres,pmmgg);

 insert into seb_bank_tmp ( cod_r , mmgg ,id,hash_cod,dt_close,dt_open, reason_open
                      , user_close ,  user_open )
 select kodres,c.mmgg,c.id,c.hash_cod,c.dt_close,c.dt_open,c.reason_open,
       c.user_close,c.user_open 
  from sys_month_tbl c order by c.mmgg,c.id,c.dt_close,c.dt_open;
 tabl=path_export||kodres||''BANK.TXT'';
 SQL=''copy  seb_bank_tmp
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;


 

end if;

if ((cop=1) and (clip is null)) then
delete from seb_vsp_tmp;
 insert into seb_vsp_tmp 
  select c.kind_dep , c.osob_r,c.dt_action,c.dt_fall,c.perc_fall,c.comment,c.dt_warning,
 c.place_off,c.reason_off,c.dt_transmiss,c.mode_transmiss,
 c.dt_pay,c.dt_podkl,0
 from 
 ( 
 select c.kind_dep ,c.osob_r,s.dt_action,s.dt_fall,s.comm_fall,s.perc_fall,s.comment,s.dt_warning,
 s.place_off,s.reason_off,s.dt_transmiss,s.mode_transmiss,
 s.dt_pay,s.dt_podkl
    from (select kind_dep,id,code as osob_r from clm_client_tbl where idk_work<>0) as c
    inner join 
      (
       select a.* from 
           (
            select c.id_client,c.action,c.dt_action,
                 ( select min(dt_action)  
                   from clm_switching_tbl
                   where action=1 and id_client=c.id_client 
                        and dt_action>c.dt_action 
                 ) as dt_fall, 
                 (select min(dt_action)  from clm_switching_tbl
                   where action in (3) and id_client=c.id_client 
                         and dt_action>=c.dt_action 
                 ) as dt_podkl,
                 (select min(dt_action)  from clm_switching_tbl
                   where action in (4) and id_client=c.id_client 
                         and dt_action>=c.dt_action 
                 ) as dt_pay,

                 (select comment from clm_switching_tbl
                  where action= 1   and id_client=c.id_client  
                  and dt_action=( select min(dt_action) 
                                  from clm_switching_tbl
                                  where action=1 and id_client=c.id_client
                                  and dt_action>=c.dt_action 
                                 )
                 ) as  comm_fall,
                (select percent from clm_switching_tbl
                 where action= 1   and id_client=c.id_client  
                      and dt_action=(select min(dt_action)
                                     from clm_switching_tbl
                                     where action=1 and id_client=c.id_client 
                                        and dt_action>=c.dt_action
                                    )
                ) as  perc_fall ,
                c.comment,c.dt_warning ,  c.place_off,c.reason_off,c.dt_transmiss,c.mode_transmiss
            from  (select * from clm_switching_tbl where action=2) c 
             order by id_client) as a 
         right join (select id_client,max(dt_action) as dt_action 
                      from ( select * from clm_switching_tbl where action=2) 
                      as d group by id_client
                    )  as b 
         on (a.id_client=b.id_client and a.dt_action=b.dt_action) 
        where dt_podkl is null
      ) as s 
  on c.id=s.id_client
 ) as c where c.dt_pay is null order by osob_r,dt_action;     

raise notice ''otcl.'';
 insert into seb_vsp_tmp 
  select c.kind_dep , c.osob_r,c.dt_action,c.dt_fall,c.perc_fall,c.comment,c.dt_warning,
 c.place_off,c.reason_off,c.dt_transmiss,c.mode_transmiss,
 c.dt_pay,c.dt_podkl,1
 from 
 ( 

Select otkl.* from
  (select  c.kind_dep,c.osob_r,null::date as dt_action,c.dt_action as dt_fall,c.perc_fall,c.comment,
   c.place_off,c.reason_off,c.dt_transmiss,c.mode_transmiss,
   c.dt_warning,c.dt_pay,c.dt_podkl
 from 
 ( 
 select c.kind_dep ,c.osob_r,s.dt_action,s.dt_fall,s.perc_fall,s.comment,s.dt_warning,
  s.place_off,s.reason_off,s.dt_transmiss,s.mode_transmiss,
  s.dt_pay,s.dt_podkl
    from (select kind_dep,id,code as osob_r from clm_client_tbl where idk_work<>0) as c
    inner join 
      (
       select a.* from 
           (
            select c.id_client,c.action,c.dt_action,
                 null as dt_fall, 
                 (select min(dt_action)  from clm_switching_tbl
                   where action in (3) and id_client=c.id_client 
                         and dt_action>=c.dt_action 
                 ) as dt_podkl,
                 (select min(dt_action)  from clm_switching_tbl
                   where action in (4) and id_client=c.id_client 
                         and dt_action>=c.dt_action 
                 ) as dt_pay,   c.percent as  perc_fall ,
                c.comment , c.dt_warning ,
                 c.place_off,c.reason_off,c.dt_transmiss,c.mode_transmiss
            from  (select * from clm_switching_tbl where action=1) c 
             order by id_client) as a 
         right join (select id_client,max(dt_action) as dt_action 
                      from ( select * from clm_switching_tbl where action=1) 
                      as d group by id_client
                    )  as b 
         on (a.id_client=b.id_client and a.dt_action=b.dt_action) 
        where dt_podkl is null
      ) as s 
  on c.id=s.id_client
 ) as c 
) as otkl 
left join
seb_vsp_tmp vsp on (vsp.osob_r=otkl.osob_r and otkl.dt_fall=vsp.dt_fall) where vsp.osob_r is null 
and otkl.dt_pay is null  
 ) as c;

 tabl=path_export||kodres||''VSP.TXT'';
 del='';''; nul='''';


 SQL=''copy  seb_vsp_tmp
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

end if;
if (((cop=2) or (cop=3)) and (clip is null)) then
pr= seb_all_add(pmmgg);
end if;
return true;
else
  raise exception ''Not found kod_res in SYSVARS'';
  return false;
end if;


end ' language 'plpgsql';

create or replace function seb_tar(date) returns boolean as '
declare 
 pmmgg alias for $1;
 kodres int;
 existt boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; 
 nul varchar;
 SQL text;
begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
 if found then  
 delete from seb_tar_tmp;
 
insert into seb_tar_tmp
select c.kind_dep,b.mmgg,c.code,c.id as id_client,b.reg_date,bd.id_grouptarif,
         bd.id_tariff,bd.id_classtarif, bd.kvt, bd.val
    from (select id,code,kind_dep from clm_client_tbl where book<0 and idk_work<>0) as c 
        join ( select b1.* from acm_bill_tbl b1                      
                   where b1.mmgg=pmmgg )  as b    
           on  (b.id_client=c.id)  
          left join ( select bb.id_doc,bb.id_tariff,ac.id_grouptarif,ac.id_classtarif,sum(demand_val) as kvt,
                     sum(sum_val) as val
                      from acd_billsum_tbl bb,aci_tarif_tbl ac where 
                         ac.id=bb.id_tariff
                      group by bb.id_doc,bb.id_tariff,ac.id_classtarif,ac.id_grouptarif 
                   ) as bd     
                    on (bd.id_doc=b.id_doc); 


   tabl=path_export||kodres||''TAR.TXT'';
   del='';''; nul='''';
SQL=''copy  seb_tar_tmp (kind_dep,code,id_grouptarif,mmgg,id_tariff,id_classtarif, kvt,val) to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;


 return true;
else
  raise exception ''Not found kod_res in SYSVARS'';
  return false;
end if;
end ' language 'plpgsql';




create or replace function seb_spo(date) returns boolean as '
declare 
 pmmgg alias for $1;
 kodres int;
 existt boolean;
 pr boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
 if found then  

  delete from seb_spo_tmp;

insert into  seb_spo_tmp  
 select c.kind_dep as cod_r,
       s.kod_section  as roz,0  as roz1,c.code as osob_r,c.id as id_client,
       c.name,c.short_name as name_sk,a.full_adr as adr, '''' as cod_sp,
       s.doc_num as nom_dog,s.doc_dat as d_dog,
       s.period_indicat as period_r,s.month_indicat as mes_r,s.dt_indicat as den_r,
       s.day_pay_bill as srok_opl,
       s.id_fld_industr as cod_gal ,s.id_depart as cod_m,s.id_grp_industr as cod_gr,
       s.count_peni as penya,s.flag_reactive as priz_zvit,s.type_peni as priz_nar_penyi,
       0 as potuz,  s.phone as telbuh, 100 as prots_opl,
       s.pre_pay_day1 as avans1d,s.pre_pay_perc1 as avans1pr,
       s.pre_pay_day2 as avans2d,s.pre_pay_perc2 as avans2pr,
       s.pre_pay_day3 as avans3d,s.pre_pay_perc3 as avans3pr,c.id_state,s.okpo_num,s.licens_num,s.tax_num
from (select id,kind_dep,id_addres,code,short_name,name,id_state from clm_client_tbl where book<0 and idk_work<>0) as c 
        left join ( select id,full_adr from adv_address_tbl ) as a on c.id_addres=a.id
        left join (select s1.*,p.kod as kod_section from clm_statecl_tbl s1 
              left join   cla_param_tbl p  on  s1.id_section=p.id) as s on s.id_client=c.id; 
                   
   tabl=path_export||kodres||''SPO.TXT'';
   del=''@''; nul='''';
SQL=''copy  seb_spo_tmp    (  cod_r,roz,roz1,osob_r,name,name_sk, adr, cod_sp,
       nom_dog, d_dog, period_r, mes_r, den_r,srok_opl,
       cod_gal ,cod_m, cod_gr,
       penya, priz_zvit, priz_nar_penyi,
       potuz,  telbuh, prots_opl,
       avans1d, avans1pr,
       avans2d, avans2pr,
       avans3d, avans3pr,id_state,okpo_num,licens_num,tax_num)
       to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;
 
       return true;
else
  raise exception ''Not found kod_res in SYSVARS'';
  return false;
end if;
end ' language 'plpgsql';

create or replace function seb_udog(date) returns boolean as '
declare
 pmmgg alias for $1;
 kodres int;
 existt boolean;
 pr boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res'';
 if found then

delete from seb_udog_tmp;
insert into seb_udog_tmp
   select c.kind_dep as cod_r,
       c.code as osob_r,c.id as id_client,  0 as umopl  ,
       null as add_dog ,null as add_dat1, null as add_dat2,
       s.dt_start as start_period, s.dt_start -1 as end_period,
       s.dt_indicat-s.pre_pay_day1 as perv_oplata,
       0 as avar_day,0 as avar_kvt,
       0 as techn_day,0 as techn_kvt,
       0 as ecol_day,0 as ecol_kvt,
       s.pre_pay_day1 as avans1d,s.pre_pay_perc1 as avans1pr,
       s.pre_pay_day2 as avans2d,s.pre_pay_perc2 as avans2pr,
       s.pre_pay_day3 as avans3d,s.pre_pay_perc3 as avans3pr,
       s.day_pay_bill as kill_dniv,
       0 as priz_arh,s.flag_reactive as priz_zvit

from (select id,code,kind_dep from clm_client_tbl where book<0 and idk_work<>0) as c
        left join (select s1.*,p.kod as rozd from clm_statecl_tbl s1,cla_param_tbl p
                   where s1.id_section=p.id) as s on s.id_client=c.id;
   tabl=path_export||kodres||''UDOG.TXT'';
   del=''@''; nul='''';
SQL=''copy  seb_udog_tmp
       (cod_r, osob_r,  umopl,  add_dog, add_dat1, add_dat2,  start_period,  end_period,  perv_oplata,
	avar_day,avar_kvt,techn_day,techn_kvt,ecol_day,	ecol_kvt,avans1d,avans1pr,    avans2d,avans2pr, avans3d, avans3pr,
       kill_dniv,    priz_arh,     priz_zvit
)
 to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

       return true;
else
  raise exception ''Not found kod_res in SYSVARS'';
  return false;
end if;

end ' language 'plpgsql';






drop function seb_saldakt(date,int);
create or replace function seb_saldakt(date,int) returns boolean as '
declare 
 pmmgg alias for $1;
 cop  alias for $2;
 kodres int;
 existt boolean;
 pr boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
 SSQL text;
 mg date;
 mgs date;
 smg varchar;
 cou_year int;
 interval_year varchar;
  res boolean;

begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
 if found then  
 raise notice ''START_akt '';
  mgs=fun_mmgg(0);
  raise notice ''mgs  %'',mgs;
  raise notice ''pmmgg  %'',pmmgg;
  if mgs<=pmmgg then
  raise notice ''mgs --- %'',mgs;
  raise notice ''pmmgg --- %'',pmmgg;
  
   res=calc_saldoakt(pmmgg);
  end if;

delete from seb_saldakt_tmp;

raise notice ''FIRST'';
insert into seb_saldakt_tmp  
       (id_client,cod_department,
         cod_section,idk_work,mmgg_p, mmgg,
         code,short_name,id_pref
       ) 
       select 
        c.id_client::integer as id_client,
        c.kind_dep, c.roz  , c.idk_work ,pmmgg as mmgg_p,pmmgg as mmgg, c.code,  c.short_name , 10 as id_pref
        from   ( select c.id as id_client,c.kind_dep,c.code,c.idk_work,c.short_name, to_number(s.kod_section,''999'')  as roz 
                 from clm_client_tbl c 
                 left join  ( select s1.*,p.kod as kod_section from clm_statecl_tbl  s1
                          left join  cla_param_tbl p on p.id=s1.id_section
                ) s 
                on s.id_client=c.id  where c.book<0 and c.idk_work<>0 
             ) as c

          right join
          ( select  distinct id_client from acm_saldoakt_tbl 
               where mmgg=pmmgg
          ) as sal 
          on sal.id_client= c.id_client;
raise notice ''UPD'';

update seb_saldakt_tmp set b_dtval=s.bdtval,b_dtvaltax=s.bdtvaltax,
         b_ktval=s.bktval,b_ktvaltax=s.bktvaltax,
         e_dtval=s.edtval,e_dtvaltax=s.edtvaltax,
         e_ktval=s.ektval,e_ktvaltax=s.ektvaltax,
         kvt=s.kvt,
         dt_val=s.dtval,dt_valtax=s.dtvaltax,
         kt_val=s.ktval,kt_valtax=s.ktvaltax
  from  (select id_client,id_pref,
          sum(case when (b_val>=0) then b_val else 0 end ) as bdtval,
          sum(case when (b_valtax>=0) then b_valtax else 0 end ) as bdtvaltax,
          sum(case when (b_val<0) then b_val else 0 end ) as bktval,
          sum(case when (b_valtax<0) then b_valtax else 0 end ) as bktvaltax,
          sum(case when (e_val>=0) then e_val else 0 end ) as edtval,
          sum(case when (e_valtax>=0) then e_valtax else 0 end ) as edtvaltax,
          sum(case when (e_val<0) then e_val else 0 end ) as ektval,
          sum(case when (e_valtax<0) then e_valtax else 0 end ) as ektvaltax,
          sum(kvt) as kvt, 
          sum(dt_val) as dtval, sum(dt_valtax) as dtvaltax,
          sum(kt_val) as ktval, sum(kt_valtax) as ktvaltax
          from acm_saldoakt_tbl where mmgg=pmmgg 
         group by id_client,id_pref
         order by id_client
         )  as s
        where seb_saldakt_tmp.id_client=s.id_client 
         and s.id_pref= seb_saldakt_tmp.id_pref;

  
cou_year=1;     

mg=date_trunc(''year'',pmmgg);
while cou_year<=16 loop 
 raise notice ''-------- %'',sql;
 raise notice ''mg %'',mg;
 smg=substring(date_part(''year'',mg::date)::varchar,3);
 raise notice ''smg %'',smg;
 cou_year=cou_year+1;
 SSQL=''
 
--
 update seb_saldakt_tmp set b_dtval''||smg||'' =s.bdtval,
                           b_dtvaltax''||smg||'' =s.bdtvaltax,
                           e_dtval''||smg||'' =s.edtval,
                           e_dtvaltax''||smg||'' =s.edtvaltax
  from  (select id_client,id_pref,
          sum(case when (b_val>=0) then b_val else 0 end ) as bdtval,
           sum(case when (b_valtax>=0) then b_valtax else 0 end ) as bdtvaltax,
           sum(case when (b_val<0) then b_val else 0 end ) as bktval,
           sum(case when (b_valtax<0) then b_valtax else 0 end ) as bktvaltax,
           sum(case when (e_val>=0) then e_val else 0 end ) as edtval,
           sum(case when (e_valtax>=0) then e_valtax else 0 end ) as edtvaltax,
           sum(case when (e_val<0) then e_val else 0 end ) as ektval,
           sum(case when (e_valtax<0) then e_valtax else 0 end ) as ektvaltax
         from acm_saldoakt_tbl where mmgg=''||quote_literal(pmmgg)||'' and
           date_trunc(''||quote_literal(''year'')|| '',mmgg_p)=''||quote_literal(mg)||
        '' group by id_client,id_pref order by id_client
         )  as s
        where seb_saldakt_tmp.id_client=s.id_client ;
--         and s.id_pref= seb_saldakt_tmp.id_pref'';

-- raise notice ''SSQL %'',SSQL;

if smg>''98'' then
  Execute SSQL;
end if;

mg=date_trunc(''year'',(mg-interval ''1 year'')::date);
end loop;

if cop=1 then
raise notice ''333'';
 tabl=path_export||kodres||''AKT.TXT'';
 del='';''; nul='''';
 SQL=''copy  seb_saldakt_tmp   to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;
 
end if;

--end loop;
end if;
raise notice ''seb_all_ ALLLLLLLLLLLLLLLLLLLLLLLLLL'';
return true;
end ' language 'plpgsql';


/*                                     0

*/
 

create or replace function seb_diftarif(date,int) returns boolean as '
declare 
 pmmgg alias for $1;
 cop  alias for $2;
 kodres int;
 existt boolean;
 pr boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
 SSQL text;
 mg date;
 mgs date;
 smg varchar;
 pr_fun int;
 interval_year varchar;
 res boolean;

begin
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
 if found then  
 raise notice ''DIFTARIF '';
  
   pr_fun=rep_3zone_fun(pmmgg);
   pr_fun=rep_2zone_fun(pmmgg);
 end if;

delete from seb_diftarif_tmp;

raise notice ''FIRST'';
insert into seb_diftarif_tmp  
       ( Cod_r,Mmgg,kind,code,id_point,
         Eqp_name,Eqp_type,Eqp_num,
         Id_group,Name_group,Class,
         id_tarif,
         Kvt0,
         Sum0,
         Kvt1,Kvt2,Kvt3,
         Tar0,
         Sum123,
         Sum1,Sum2,Sum3
       ) 
 select clm.kind_dep,pmmgg,3, clm.code,z.id_point,
 substr(m.type||''  ''||z.num_eqp,1,35),m.type,z.num_eqp,
 CASE WHEN tgr.ident = ''tgr1'' then 1 WHEN tgr.ident = ''tgr2'' then 2 
 WHEN tgr.ident = ''tgr3'' then 5 WHEN tgr.ident = ''tgr4'' then 6 
 WHEN tgr.ident = ''tgr5'' then 7 WHEN tgr.ident = ''tgr6'' then 4 
 WHEN tgr.ident like ''tgr7%'' then 8 WHEN tgr.ident like ''tgr8%'' then 9  end ,
 tgr.ident,  substr(tcl.ident,4,1),
 z.id_tariff,
 coalesce(demand_z1,0)+coalesce(demand_z2,0)+coalesce(demand_z3,0),
 (coalesce(demand_z1,0)+coalesce(demand_z2,0)+coalesce(demand_z3,0))*tar0 ,
 coalesce(demand_z1,0), coalesce(demand_z2,0), coalesce(demand_z3,0), 
 tar0,
 coalesce(sum_z1,0)+ coalesce(sum_z2,0)+ coalesce(sum_z3,0),
 coalesce(sum_z1,0), 
 coalesce(sum_z2,0), 
 coalesce(sum_z3,0) 
 from rep_3zone_tbl as z left join clm_client_tbl as clm on (clm.id=z.id_client) 
 left join aci_tarif_tbl as tar on (tar.id=z.id_tariff) 
 join eqi_grouptarif_tbl as tgr on (tgr.id=tar.id_grouptarif) 
 join eqi_classtarif_tbl as tcl on (tcl.id=tar.id_classtarif) 
 join eqi_meter_tbl as m on (z.id_type_meter=m.id) 
 where (tgr.ident not like ''tgr9%'')
 and z.mmgg = pmmgg and clm.book = -1;

raise notice ''FIRST 1'';
insert into seb_diftarif_tmp  
       ( Cod_r,Mmgg,kind,code,id_point,
         Eqp_name,Eqp_type,Eqp_num,
         Id_group,Name_group,Class,
         id_tarif, 
         Kvt0,
         Sum0,
         Kvt1,Kvt2,Kvt3,
         Tar0,
         Sum123,
         Sum1,Sum2,Sum3
       ) 
 select clm.kind_dep,pmmgg,2, clm.code,z.id_point,
 m.type||''  ''||z.num_eqp,m.type,z.num_eqp,
 CASE WHEN tgr.ident = ''tgr1'' then 1 WHEN tgr.ident = ''tgr2'' then 2 
 WHEN tgr.ident = ''tgr3'' then 5 WHEN tgr.ident = ''tgr4'' then 6 
 WHEN tgr.ident = ''tgr5'' then 7 WHEN tgr.ident = ''tgr6'' then 4 
 WHEN tgr.ident like ''tgr7%'' then 8 WHEN tgr.ident like ''tgr8%'' then 9  end,
 tgr.ident ,substr(tcl.ident,4,1),
 z.id_tariff,
 coalesce(demand_z1,0)+coalesce(demand_z2,0),
 (coalesce(demand_z1,0)+coalesce(demand_z2,0))*tar0,
 coalesce(demand_z1,0), coalesce(demand_z2,0), 0::numeric,
  tar0, 
 coalesce(sum_z1,0)+ coalesce(sum_z2,0),
 coalesce(sum_z1,0), 
 coalesce(sum_z2,0),
  0::numeric
 from rep_2zone_tbl as z left join clm_client_tbl as clm on (clm.id=z.id_client) 
 left join aci_tarif_tbl as tar on (tar.id=z.id_tariff) 
 join eqi_grouptarif_tbl as tgr on (tgr.id=tar.id_grouptarif) 
 join eqi_classtarif_tbl as tcl on (tcl.id=tar.id_classtarif) 
 join eqi_meter_tbl as m on (z.id_type_meter=m.id) 
 where (tgr.ident not like ''tgr9%'') 
 and z.mmgg = pmmgg and clm.book = -1;

----------------------------------------- fiz zones ----------------------------

 raise notice ''fiz zone'';
 pr_fun=rep_2zone_fiz_fun(pmmgg);
 pr_fun=rep_3zone_fiz_fun(pmmgg);


insert into seb_diftarif_tmp  
       ( Cod_r,Mmgg,kind,code,id_point,
         Eqp_name,Eqp_type,Eqp_num,
         Id_group,Name_group,Class,
         id_tarif, 
         Kvt0,
         Sum0,
         Kvt1,Kvt2,Kvt3,
         Tar0,
         Sum123,
         Sum1,Sum2,Sum3
       ) 
 select clm.kind_dep,pmmgg,4, clm.code,z.id_point,
 m.type||''  ''||z.num_eqp,m.type,z.num_eqp,
 CASE WHEN tgr.ident = ''tgr1'' then 1 WHEN tgr.ident = ''tgr2'' then 2 
 WHEN tgr.ident = ''tgr3'' then 5 WHEN tgr.ident = ''tgr4'' then 6 
 WHEN tgr.ident = ''tgr5'' then 7 WHEN tgr.ident = ''tgr6'' then 4 
 WHEN tgr.ident like ''tgr7%'' then 8 WHEN tgr.ident like ''tgr8%'' then 9  end,
 tgr.ident ,substr(tcl.ident,4,1),
 z.id_tariff,
 coalesce(demand_z1,0)+coalesce(demand_z2,0),
 (coalesce(demand_z1,0)+coalesce(demand_z2,0))*tar0,
 coalesce(demand_z1,0), coalesce(demand_z2,0), 0::numeric,
  tar0, 
 coalesce(sum_z1,0)+ coalesce(sum_z2,0),
 coalesce(sum_z1,0), 
 coalesce(sum_z2,0),
  0::numeric
 from rep_2zone_tbl as z 
 left join clm_client_tbl as clm on (clm.id=z.id_client) 
 left join aci_tarif_tbl as tar on (tar.id=z.id_tariff) 
 join eqi_grouptarif_tbl as tgr on (tgr.id=tar.id_grouptarif) 
 join eqi_classtarif_tbl as tcl on (tcl.id=tar.id_classtarif) 
 join eqi_meter_tbl as m on (z.id_type_meter=m.id) 
 where (tgr.ident not like ''tgr9%'') 
 and z.mmgg = pmmgg and clm.book = -1;



insert into seb_diftarif_tmp  
       ( Cod_r,Mmgg,kind,code,id_point,
         Eqp_name,Eqp_type,Eqp_num,
         Id_group,Name_group,Class,
         id_tarif,
         Kvt0,
         Sum0,
         Kvt1,Kvt2,Kvt3,
         Tar0,
         Sum123,
         Sum1,Sum2,Sum3
       ) 
 select clm.kind_dep,pmmgg,5, clm.code,z.id_point,
 substr(m.type||''  ''||z.num_eqp,1,35),m.type,z.num_eqp,
 CASE WHEN tgr.ident = ''tgr1'' then 1 WHEN tgr.ident = ''tgr2'' then 2 
 WHEN tgr.ident = ''tgr3'' then 5 WHEN tgr.ident = ''tgr4'' then 6 
 WHEN tgr.ident = ''tgr5'' then 7 WHEN tgr.ident = ''tgr6'' then 4 
 WHEN tgr.ident like ''tgr7%'' then 8 WHEN tgr.ident like ''tgr8%'' then 9  end ,
 tgr.ident,  substr(tcl.ident,4,1),
 z.id_tariff,
 coalesce(demand_z1,0)+coalesce(demand_z2,0)+coalesce(demand_z3,0),
 (coalesce(demand_z1,0)+coalesce(demand_z2,0)+coalesce(demand_z3,0))*tar0 ,
 coalesce(demand_z1,0), coalesce(demand_z2,0), coalesce(demand_z3,0), 
 tar0,
 coalesce(sum_z1,0)+ coalesce(sum_z2,0)+ coalesce(sum_z3,0),
 coalesce(sum_z1,0), 
 coalesce(sum_z2,0), 
 coalesce(sum_z3,0) 
 from rep_3zone_tbl as z left join clm_client_tbl as clm on (clm.id=z.id_client) 
 left join aci_tarif_tbl as tar on (tar.id=z.id_tariff) 
 join eqi_grouptarif_tbl as tgr on (tgr.id=tar.id_grouptarif) 
 join eqi_classtarif_tbl as tcl on (tcl.id=tar.id_classtarif) 
 join eqi_meter_tbl as m on (z.id_type_meter=m.id) 
 where (tgr.ident not like ''tgr9%'')
 and z.mmgg = pmmgg and clm.book = -1;

-----------------------------------------


 insert into seb_diftarif_tmp  
       ( Cod_r,Mmgg,kind,code,id_point,
         Eqp_name,Eqp_type,Eqp_num,
         Id_group,Name_group,Class,
         id_tarif,
         Kvt0,
         Sum0,
         Kvt1,Kvt2,Kvt3,
         Tar0, Sum123,
         Sum1,Sum2,Sum3
       ) 
 select clm.kind_dep,pmmgg,9, clm.code,sss.id_point,
  to_char(billdt,''dd.mm.yyyy''),
  -- m.type||''   ''||sss.num_eqp,
  m.type,sss.num_eqp,
    CASE WHEN tgr.ident = ''tgr1'' then 1 
 WHEN tgr.ident = ''tgr2'' then 2 WHEN tgr.ident = ''tgr3'' then 5
 WHEN tgr.ident = ''tgr4'' then 6 WHEN tgr.ident = ''tgr5'' then 7 
 WHEN tgr.ident = ''tgr6'' then 4 end as grtar_cod, tgr.ident as grtar,
 substr(tcl.ident,4,1)::varchar as cltar,
 51,
 sss.demand_n+coalesce(sss2.demand_d,0),
 sss.sum_n+coalesce(sss2.sum_d,0),
 sss.demand_n,sss2.demand_d,null,
 null, sss.sum_n+coalesce(sss2.sum_d,0),
 sss2.sum_d, sss.sum_n,null
 from (select b.id_client, mm.id_type_eqp as id_type_meter ,max(mp.id_point) as id_point,trim(regexp_replace(trim(eq.num_eqp),''(н|д)$'',''''))::varchar as num_eqp,
        tar.id_grouptarif,tar.id_classtarif, sum(bs.demand_val) as demand_n, 
        sum(bs.sum_val) as sum_n, min(b.dat_e) as billdt 
       from acm_bill_tbl as b 
       join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
       join clm_client_tbl as clm on (clm.id=b.id_client) 
       join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
       left join eqm_meter_point_h as mp on (mp.id_point = bs.id_point and mp.dt_b <= bs.dt_begin and ( mp.dt_e is null or mp.dt_e > bs.dt_begin ) ) 
       left join eqm_equipment_h as eq on (eq.id = mp.id_meter and eq.dt_b <= bs.dt_begin and ( eq.dt_e is null or eq.dt_e > bs.dt_begin ) ) 
       left join eqm_meter_h as mm on (mm.code_eqp = mp.id_meter and mm.dt_b <= bs.dt_begin and ( mm.dt_e is null or mm.dt_e > bs.dt_begin ) ) 
            where bs.id_tariff = 51 and bs.id_zone = 0  and b.id_pref = 10 and b.mmgg = pmmgg 
                   and clm.book = -1 
            group by b.id_client, id_type_meter,
                   num_eqp,tar.id_grouptarif,tar.id_classtarif 
            order by b.id_client, num_eqp
        ) as sss 
        left join (select b.id_client, trim(regexp_replace(trim(eq.num_eqp),''(н|д)$'',''''))::varchar as num_eqp,
                    sum(bs.demand_val) as demand_d, sum(bs.sum_val) as sum_d 
                   from acm_bill_tbl as b 
                   join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
                   join clm_client_tbl as clm on (clm.id=b.id_client) 

		   left join eqm_meter_point_h as mp on (mp.id_point = bs.id_point and mp.dt_b <= bs.dt_begin and ( mp.dt_e is null or mp.dt_e > bs.dt_begin ) ) 
	           left join eqm_equipment_h as eq on (eq.id = mp.id_meter and eq.dt_b <= bs.dt_begin and ( eq.dt_e is null or eq.dt_e > bs.dt_begin ) ) 
                   where bs.id_tariff <> 51 and bs.id_zone = 0 and b.id_pref = 10 
                       and b.mmgg = pmmgg and clm.book = -1 
                    group by b.id_client, num_eqp 
                   order by b.id_client, num_eqp
                   ) as sss2 on (sss.id_client = sss2.id_client and sss.num_eqp = sss2.num_eqp) 
         left join eqi_grouptarif_tbl as tgr on (tgr.id=sss.id_grouptarif) 
         left join eqi_classtarif_tbl as tcl on (tcl.id=sss.id_classtarif) 
         left join clm_client_tbl as clm on (clm.id=sss.id_client) 
         left join eqi_meter_tbl as m on (sss.id_type_meter=m.id)  
order by clm.code,sss.num_eqp; 


if cop=2 then
raise notice ''333'';
 tabl=path_export||kodres||''Difact.TXT'';
 del='';''; nul='''';
 SQL=''copy  seb_diftarif_tmp (Cod_r,kind,code,Mmgg,
         Eqp_name,Eqp_type,Eqp_num,
         Id_group,Name_group,Class,
         Kvt0,
         Sum0,
         Kvt1,Kvt2,Kvt3,
         Tar0,
         Sum123,
         Sum1,Sum2,Sum3)  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

end if;


raise notice ''seb_all_ ALLLLLLLLLLLLLLLLLLLLLLLLLL'';
return true;
end ' language 'plpgsql';


create or replace function seb_renthist(date,int) returns boolean as '
declare 
 pmmgg alias for $1;
 cop  alias for $2;
 kodres int;
 existt boolean;
 pr boolean;
 path_export text;
 flag_export varchar;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
 SSQL text;
 res boolean;

begin
   raise notice ''seb_rent_hist begin'';
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;

 res=seb_renthist_fun(pmmgg);
 select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

delete from seb_renthist_tmp;
raise notice ''seb_rent_hist func '';

insert into seb_renthist_tmp (cod_r,mmgg,id_client,code,id_point,id_addres,name_object
 ,dt_rent_end,dt_last_ind,flag,comment)
select c.kind_dep,pmmgg,h.id_client,c.code,h.id_point,h.id_addres,h.name_object
,(h.dt_rent_end),(h.dt_last_ind),h.flag,h.comment
 from
   clm_client_tbl c,seb_renthist_tbl h where c.id=h.id_client and h.mmgg=pmmgg;


update seb_renthist_tmp set name_point=p.name_point,name_addres=a.adr
from eqv_pnt_met p, adv_address_tbl a where seb_renthist_tmp.id_point=p.id_point
and  seb_renthist_tmp.id_addres=a.id;

Delete from  seb_renthist_tmp where flag=9;


if cop=2 then
raise notice ''333'';
 tabl=path_export||kodres||''Renthist.TXT'';
 del=''@''; nul='''';
 SQL=''copy  seb_renthist_tmp (Cod_r,code,
         name_point,mmgg,name_object,
         dt_rent_end,dt_last_ind,name_addres,comment
)  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

  select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export='1' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

end if;


raise notice ''seb_rent_hist all'';
return true;
end ' language 'plpgsql';


set client_encoding='koi8';