set client_encoding='win';                                                    

create or replace function seb_year(date) returns boolean as '
declare 
 pmmgg alias for $1;
 kodres int;
 existt boolean;
 pr boolean;
 tabl varchar;
 del varchar; nul varchar;
 SQL text;
begin
select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
 if found then  
 raise notice ''START'';
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
            
         ) as c 
         inner join ( select b1.* from acm_bill_tbl b1
                        where  (b1.mmgg>=pmmgg ) 
                      
                    )  as b    
           on  (b.id_client=c.id) order by c.kind_dep,b.mmgg ,c.code;  

 

 if getsysvar(''kod_res'') = ''310'' then

  raise notice ''START  update  seb_nar_tmp'';

 update  seb_nar_tmp set kilk_nas= bt.dem from
( select  bs.id_doc, coalesce(sum(bs.demand_val),0) as dem
  from acm_bill_tbl as b
  join acd_billsum_tbl as bs on (bs.id_doc = b.id_doc)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.mmgg>=pmmgg   and b.mmgg_bill >= pmmgg 
  --and b.id_client = pid_client 
  and b.id_pref = 10 and b.idk_doc = 200 --and (b.id_doc = pid_bill or pid_bill is null)
  and (tgr.ident like ''tgr7%'' or tgr.ident like ''tgr8%'')
 group by bs.id_doc) bt
 where bt.id_doc=seb_nar_tmp.id_doc;

end if;




  tabl=''/home/local/seb/''||kodres||''NAR.TXT'';
  del='';''; 
  nul='''';
  SQL=''copy  seb_nar_tmp 
     (cod_r,osob_r,nom_doc,d_doc,vid_doc,vid_nar,kilk,suma,pdv,suma_zpdv,dt_trans,idk_doc,kilk_nas)
     to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul) ;
  
  raise notice ''copy seb_nar'';
  Execute SQL;
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
       
      ) as c 
         inner join ( select p1.*  from acm_pay_tbl p1  where 
                 (p1.mmgg>=pmmgg ) and p1.sign_pay>0  
                    )  as p    
           on  (p.id_client=c.id) order by c.kind_dep,p.mmgg ,c.code;  



tabl=''/home/local/seb/''||kodres||''OPL.TXT'';
del='';''; nul='''';
SQL=''copy  seb_opl_tmp 
     (cod_r,osob_r,nom_doc,d_doc,vid_doc,vid_nar,period_op,suma,pdv,suma_zpdv) 
      to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
  raise notice ''copy seb_opl'';
 Execute SQL;

-- delete next month after coping


delete from seb_opl_tmp;
end if;

return true;
end ' language 'plpgsql';

set client_encoding='koi8';


select crt_ttbl();
select seb_year('2015-01-01');