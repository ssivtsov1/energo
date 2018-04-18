
;

CREATE TABLE clm_action_tbl
(
  id  serial,
  dt timestamp DEFAULT now(),
  id_person integer DEFAULT getsysvar('id_person'::character varying),
  mmgg date  DEFAULT fun_mmgg(),
  id_client integer,
  kind_energy int,
  flag_avans  int,
  dt_warning date,
  dt_warning_to date,
  dt_trans_warning date,
  id_trans_mode int,
  add_trans_mode varchar(50),
  summ_warning   numeric (15,5)  DEFAULT 0.00,
  comment_warning varchar (255),
  dt_off date,
  id_person_off int,
  id_eqp_off int,
  place_off varchar(50),
  reason_off varchar(50), 
  order_off varchar(25), 
  dt_pay date,
  summ_pay  numeric (15,5)  DEFAULT 0.00,
  dt_on date,
  order_on varchar(25), 
  id_person_on int,
  PRIMARY KEY (id)
);



CREATE TABLE clm_action_h
(
  id int,
  dt timestamp DEFAULT now(),
  id_person integer DEFAULT getsysvar('id_person'::character varying),
  mmgg date,
  id_client integer,
  kind_energy int,
  flag_avans  int,
  dt_warning date,
  dt_warning_to date,
  dt_trans_warning date,
  id_trans_mode int,
  add_trans_mode varchar(50),
  summ_warning   numeric (15,5)  DEFAULT 0.00,
  comment_warning varchar (255),
  dt_off date,
  id_person_off int,
  id_eqp_off int,
  place_off varchar(50),
  reason_off varchar(50), 
  order_off varchar(25), 
  dt_pay date,
  summ_pay  numeric (15,5)  DEFAULT 0.00,
  dt_on date,
  order_on varchar(25), 
  id_person_on int,
  id_change serial ,
  dt_change timestamp without time zone DEFAULT now(),
  id_person_change integer DEFAULT getsysvar('id_person'::character varying),
  mmgg_change date  DEFAULT fun_mmgg(),
  PRIMARY KEY (id_change)
);

alter table clm_action_tbl rename column kind_energy to id_pref;
create or replace function calc_switching() returns boolean as '
declare 
 mg date;
 stat record;
 seb record;
 plat record;
 bill record;
 sumbill numeric;
 pr boolean;
begin
mg=fun_mmgg(1);
pr=seb_one(mg,0,null);
for stat in 
 select c.id as id_client,s.dt_action,s.action 
    from clm_client_tbl c 
     inner join 
      ( select s.id_client,s.action,s.dt_action from clm_switching_tbl s 
        where s.dt_action=( select max(i.dt_action) from clm_switching_tbl i
                           where i.id_client=s.id_client)
             and s.id=( select max(i.id) from clm_switching_tbl i
                           where i.id_client=s.id_client)
        ) as s on (c.id=s.id_client)  
  where action in (1,2) order by c.code loop
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

      if seb.deb_kmv-sumbill>=0 then
          raise notice ''id_client %'',seb.id_client;
         for plat in select * from acm_pay_tbl p 
           where p.id_client=stat.id_client and id_pref=10 
                 and reg_date>=stat.dt_action loop
                raise notice ''plat %'',seb.id_client;
               insert into clm_switching_tbl (id_client,dt_action,action) 
                values (stat.id_client,plat.reg_date,4);
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

