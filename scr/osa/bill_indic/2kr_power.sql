--set client_encoding ='win'; 


CREATE OR REPLACE FUNCTION crt_pwr2krbill(int4, int4, date)
  RETURNS int4 AS
$BODY$
Declare
 pid_client Alias for $1;
 pid_ind Alias for $2;
 pmmgg Alias for $3;

 mfo_s int;
 acc_s numeric;
 nds numeric;
 r record;
 r1 record;
 kdoc int;
 iddc int;
 ch_val text;
 text_limit text;
 vlimit record;
 head record;
 vtarif record;

 v_bigpower numeric;
 v_sum numeric;
 ret boolean;
begin

-- delete from act_res_notice;
 delete from sys_error_tbl;

 ch_val:='';
 iddc:=null;

 v_bigpower:=0;
 ret=del_notrigger('acd_pwr_limit_over_tbl','delete from acd_pwr_limit_over_tbl where id_doc<0');
 select into head * from acm_headpowerindication_tbl where id_doc = pid_ind;

if pmmgg<(select (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||
      '-'||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident='mmgg') then

  Raise Notice 'Period is closed!!!';
  Return -1;

 end if;


 -- умножение на 2 потому, что засмеры делают с интервалом в полчаса
 -- а надо получить потребление за час 
 for r in 
  select id_area, night_day, max(dem)*2 as max_power from
  (select coalesce(i.id_area,0) as id_area, i.night_day, i.time_indic, sum(i.value_dem) as dem
   from 
   acm_headpowerindication_tbl as h
   join acd_powerindication_tbl as i on (h.id_doc = i.id_doc)
   where h.id_doc = pid_ind
   group by i.id_area,i.time_indic,i.night_day ) as s1 
  group by id_area, night_day
 loop

   -- для найденных замеров найдем лимит по площадке и времени суток

   select into vlimit value_dem, hl.id_doc from acm_headdemandlimit_tbl as hl 
   join acd_demandlimit_tbl as l  on(hl.id_doc = l.id_doc)
   where hl.id_client = pid_client and date_trunc('month',l.month_limit)  = bom(head.reg_date) -- 2014-09-12  pmmgg 
   and hl.reg_date <= head.reg_date and idk_document = 601
   and coalesce(l.id_area,0) = r.id_area and l.night_day = r.night_day
   order by hl.reg_date desc limit 1;   
  
   if not found then
     Raise Notice 'Нет лимита мощности для площадки % времени суток %.',r.id_area,r.night_day;
     text_limit= 'Нет лимита мощности для площадки '||r.id_area  ||' времени суток '||r.night_day;
     update acm_headpowerindication_tbl set comment =text_limit where id_doc=pid_ind;
--     insert into sys_error_tbl(nam,ident,id_error) values ('2krp','2krp_nolim',13);
--     return 0;
   else

    if r.max_power > vlimit.value_dem then
   
     Raise Notice 'Лимит мощности для площадки % времени суток % превышен.',r.id_area,r.night_day;

     v_bigpower:= v_bigpower + (r.max_power - vlimit.value_dem);
     --для вывода в счет
     insert into acd_pwr_limit_over_tbl(id_doc,id_area,night_day,power_limit,power_fact,power_ower)
     values(-pid_ind,r.id_area,r.night_day,vlimit.value_dem,r.max_power,(r.max_power - vlimit.value_dem) );

--     insert into sys_error_tbl(nam,ident,id_error) values ('2kr','2krd',12);
    end if;

   end if;


 end loop;


 if v_bigpower=0 then

--  Raise Notice 'Лимит потребления не превышен.';
   text_limit='Лимит потребления не превышен.'; 
    update acm_headpowerindication_tbl set comment =text_limit where id_doc=pid_ind;
  insert into sys_error_tbl(nam,ident,id_error) values ('2krp','2krp_no',14);
  Return 0;

 else 
  insert into sys_error_tbl(nam,ident,id_error) values ('2krp','2krp_bill',15);
 end if;



 if pmmgg<(select (substr(value_ident,7,4)||'-'||substr(value_ident,4,2)||
      '-'||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident='mmgg') then

  Raise Notice 'Period is closed!!!';
  Return -1;

 end if;


 -- банк для реактивной енергии используется для 2х кр
 ch_val:='act_ee';

 for r1 in select * from cli_account_tbl as a inner join (select int4('0'||value_ident) as val from 
          syi_sysvars_tbl where ident='id_res') as b on (a.id_client=b.val) 
          where a.ident=ch_val loop
    mfo_s:=r1.mfo;
    --acc_s:=to_number(r1.account,'99999999999999');
      acc_s=r1.account;
 end loop;

 if mfo_s is null then
   Raise Notice 'Account not found';
   --insert into act_res_notice values('Account not found');
   ---  Raise Exception '(Account not found)';
   Return -1;
 end if;



 select into kdoc id from dci_document_tbl where ident='bill_2krp';

 delete from acm_bill_tbl where id_client = pid_client and idk_doc = kdoc and 
     mmgg = pmmgg  and reg_date=head.reg_date and id_ind=head.id_doc;


 select into vtarif td.id as id_tarval,td.id_tarif,td.value
    from acd_tarif_tbl as td  
    join aci_tarif_tbl as tar on (tar.id = td.id_tarif)
    join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
    where tgr.ident = 'tgr_pwr' and td.dt_begin <=head.reg_date
    order by td.dt_begin desc limit 1;


 update acd_pwr_limit_over_tbl
  set 
  --id_doc = iddc, 
  tarif = vtarif.value, sum_value = round(power_ower*vtarif.value*2,2)
 where id_doc = -pid_ind;

 select into v_sum sum(sum_value)
  from acd_pwr_limit_over_tbl where id_doc = -pid_ind;

 --create bill
 insert into acm_bill_tbl(id_pref,dt,reg_num, reg_date,id_client
   ,mfo_self,account_self,value,value_tax,demand_val,id_ind,mmgg
   ,mmgg_bill,idk_doc,dat_b,dat_e,flag_priv) 
 values(
   510
   ,now()
   ,(select '2P'||code::text from clm_client_tbl where id=pid_client)||'_'
   ||to_char(pmmgg,'mm')||'-'||to_char(pmmgg,'yyyy') 
   ,head.reg_date
   ,pid_client
   ,mfo_s ,acc_s 
   ,v_sum
   ,0
   ,v_bigpower
   ,head.id_doc
   ,pmmgg
   ,pmmgg
   ,kdoc
   ,pmmgg
   ,pmmgg
   ,false);

 iddc:=currval('dcm_doc_seq');

----acd_billsum_tbl

 insert into acd_billsum_tbl(id_point,kind_energy,dt_begin,dt_end,demand_val,sum_val,id_doc,mmgg,dt)
 values(0,1,pmmgg,pmmgg,v_bigpower,v_sum,iddc,pmmgg,now()::date);

 update acd_pwr_limit_over_tbl
  set  id_doc = iddc 
 where id_doc = -pid_ind;

 ret=del_notrigger('acd_pwr_limit_over_tbl','delete from acd_pwr_limit_over_tbl where id_doc<0');

-- insert into sys_error_tbl(nam,ident,id_error) values ('2kr','2krd_ok',10);

Return iddc;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION crt_pwr2krbill(int4, int4, date) OWNER TO "local";





