select * from clm_client_tbl c inner join clm_action_tbl a on c.id=a.id_client
where (a.dt_warning is not null or dt_off is not null ) and (dt_pay is null) and c.idk_work<>0  and c.id_state not in (50,99,49)

select * from clm_client_tbl

select * from cli_state_tbl

select *  from clm_action_tbl

select crt_ttbl()
select seb_one('2017-10-01',0,null);
alter table clm_action_tbl rename column kind_energy to id_pref 

select * from clm_action_tbl 


select s.id_client,s.id_pref,a.id,a.dt_warning,s.deb_kmv,sum(value+value_tax),s.deb_kmv-sum(value+value_tax) as raz 
  from seb_obr_all_tmp s ,  acm_bill_tbl b ,
(select a.* from clm_client_tbl c inner join clm_action_tbl a on c.id=a.id_client
   where (a.dt_warning is not null or dt_off is not null ) and (dt_pay is null) and c.idk_work<>0  and c.id_state not in (50,99,49) ) a
   where a.id_client=b.id_client and a.id_pref=s.id_pref and a.flag_avans=0 and b.id_client=s.id_client and b.id_pref=s.id_pref 
                 and b.reg_date>=a.dt_warning    group by  s.id_client,s.id_pref,s.deb_kmv,a.id,a.dt_warning 
         



create or replace function calc_action() returns boolean as '
declare 
 mg date;
 stat record;
 seb record;
 plat record;
 bill record;
 sumbill numeric;
 sumpay numeric;
 pr boolean;
begin
mg=fun_mmgg(1);
pr=seb_one(mg,0,null);

for stat in 
select s.id_client,s.id_pref,a.id,a.dt_warning,s.deb_kmv,sum(value+value_tax),s.deb_kmv-sum(value+value_tax) as raz 
  from seb_obr_all_tmp s ,  acm_bill_tbl b ,
(select a.* from clm_client_tbl c inner join clm_action_tbl a on c.id=a.id_client
   where (a.dt_warning is not null or dt_off is not null ) and (dt_pay is null) and c.idk_work<>0  and c.id_state not in (50,99,49) ) a
   where a.id_client=b.id_client and a.id_pref=s.id_pref and a.flag_avans=0 and b.id_client=s.id_client and b.id_pref=s.id_pref 
                 and b.reg_date>=a.dt_warning    group by  s.id_client,s.id_pref,s.deb_kmv,a.id,a.dt_warning  having s.deb_kmv-sum(value+value_tax)>=0 loop
/*select a.* from clm_client_tbl c inner join clm_action_tbl a on c.id=a.id_client
where (a.dt_warning is not null or dt_off is not null ) and (dt_pay is null) and c.idk_work<>0  and c.id_state not in (50,99,49) loop
    
*/


          raise notice ''stat  %'',stat;
         for plat in select * from acm_pay_tbl p 
           where p.id_client=stat.id_client and id_pref=stat.id_pref
                 and reg_date>=stat.dt_warnung loop
                sumpay=coalesce(sumpay)+plat.value_pay;
               if sumpay>
         end loop; 
      end if;
  end loop;
end loop;
for stat in 
 select c.id as id_client,s.dt_action,s.action,s.sum_warning 
    from clm_client_tbl c 
     inner join 
      ( select s.id_client,s.action,s.dt_action,s.sum_warning from clm_switching_tbl s 
        where s.dt_action=( select max(i.dt_action) from clm_switching_tbl i
                           where i.id_client=s.id_client)
             and s.id=( select max(i.id) from clm_switching_tbl i
                           where i.id_client=s.id_client)
        ) as s on (c.id=s.id_client)  
  where action=5 order by c.code loop
     raise notice '' cl, %'',stat.id_client;
  for  seb in select * from seb_obr_all_tmp where id_client=stat.id_client 
       and id_pref=10 loop
         sumbill=0.00;
         for bill in select sum(value+value_tax) as val 
            from acm_bill_tbl b
              where b.id_client=stat.id_client and id_pref=10 
                 and reg_date>=stat.dt_action loop
              sumbill=coalesce(bill.val,0);
          end loop;
      if seb.deb_kmv-seb.kr_zkmv+sumbill>=0 then
          raise notice ''id_client %'',seb.id_client;
         for plat in select * from acm_pay_tbl p 
           where p.id_client=stat.id_client and id_pref=10 
                  and reg_date>=stat.dt_action and (mmgg=bom(stat.dt_action) or mmgg=eom(stat.dt_action)+interval ''1 day'') order by reg_date  limit 1 loop
                raise notice ''plat %'',seb.id_client;
               insert into clm_switching_tbl (id_client,dt_action,action) 
                values (stat.id_client,plat.reg_date,4);
         end loop; 
      end if;
  end loop;
end loop;


  return false;
end ' language 'plpgsql';
