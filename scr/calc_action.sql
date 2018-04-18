
CREATE OR REPLACE FUNCTION calc_action()
  RETURNS boolean AS
$BODY$
declare 
 mg date;
 stat record;
 mg_dt date; 
 seb record;
 plat record;
 bill record;
 sumbill numeric;
 sumpay numeric;
  dtpay date;
 pr boolean;
begin
--

mg=fun_mmgg(1)-interval '1 month';
mg_dt=fun_mmgg();


while mg<=mg_dt loop


 raise notice '+++++++++++++++++++++++++++++++++++++++mg, %',mg;
pr=seb_one(mg,0,null);
  

for stat in 
select a.* from clm_client_tbl c inner join clm_action_tbl a on c.id=a.id_client
where (a.dt_warning is not null or dt_off is not null ) and (dt_pay is null) and c.idk_work<>0  and c.id_state not in (50,99,49) and flag_avans=0  loop
    if stat.id_client=2379 then
     raise notice '1 cl, %',stat.id_client;
    end if;
  for  seb in select * from seb_obr_all_tmp where id_client=stat.id_client        and id_pref=stat.id_pref loop
    if stat.id_client=2379 then
     raise notice '2 cl, %',stat.id_client;
    end if;
    
         sumbill=0.00;
         for bill in select sum(value+value_tax) as val 
            from acm_bill_tbl b
              where b.id_client=stat.id_client and id_pref=stat.id_pref 
                 and reg_date>=coalesce(stat.dt_off,stat.dt_warning) loop

              sumbill=coalesce(bill.val,0);
           if stat.id_client=2379 then
            raise notice '3 bill cl, %,%',stat.id_client,sumbill;
            end if;
          end loop;

           if stat.id_client=2379 then
            raise notice '40 seb.deb_kmv-sumbill cl, %,%',stat.id_client,seb.deb_kmv-sumbill;
            end if;
      --if seb.deb_kmv-sumbill>=0 then
           if stat.id_client=2379 then
            raise notice '4 seb.deb_kmv-sumbill cl, %,%',stat.id_client,seb.deb_kmv-sumbill;
            end if;
         -- raise notice 'id_client %',seb.id_client;
         sumpay=0;
         for plat in select * from acm_pay_tbl p 
           where p.id_client=stat.id_client and id_pref=stat.id_pref 
                 and reg_date>=coalesce(stat.dt_off,stat.dt_warning  ) loop
                    if stat.id_client=2379 then
                     raise notice '5 plat cl, %,%',stat.id_client,plat;
                    end if;
               sumpay=sumpay+plat.value_pay;
               dtpay=plat.reg_date;
         end loop;
       if sumpay-sumbill>=stat.summ_warning then
          update clm_action_tbl set dt_pay=dtpay where id=stat.id; 
      end if;
  end loop;
end loop;
raise notice 'rrr';
for stat in 
select a.* from clm_client_tbl c inner join clm_action_tbl a on c.id=a.id_client
where (a.dt_warning is not null or dt_off is not null ) and (dt_pay is null) and c.idk_work<>0  and c.id_state not in (50,99,49) and flag_avans=1  order by c.code loop
    -- raise notice ' cl, %',stat.id_client;
  for  seb in select * from seb_obr_all_tmp where id_client=stat.id_client 
       and id_pref=stat.id_pref loop
         sumbill=0.00;
         for bill in select sum(value+value_tax) as val 
            from acm_bill_tbl b
              where b.id_client=stat.id_client and id_pref=stat.id_pref 
                 and reg_date>=coalesce(stat.dt_off,stat.dt_warning) loop
              sumbill=coalesce(bill.val,0);
          end loop;
      if seb.deb_kmv-seb.kr_zkmv+sumbill>=0 then
       --   raise notice 'id_client %',seb.id_client;
         for plat in select * from acm_pay_tbl p 
           where p.id_client=stat.id_client and id_pref=stat.id_pref 
                  and reg_date>=coalesce(stat.dt_off,stat.dt_warning) and (mmgg=bom(coalesce(stat.dt_off,stat.dt_warning)) or mmgg=eom(coalesce(stat.dt_off,stat.dt_warning))+interval '1 day') order by reg_date  limit 1 loop
      --          raise notice 'plat %',seb.id_client;
              update clm_action_tbl set dt_pay=plat.reg_date where id=stat.id;
         end loop; 
      end if;
  end loop;
end loop;
mg=mg+interval '1 month';
end loop;

  return false;
end $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION calc_action()
  OWNER TO local;


select crt_ttbl();
select calc_action()
