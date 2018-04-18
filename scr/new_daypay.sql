
select * into table clm_daypay_tmp  from clm_daypay_tbl ;

CREATE TABLE clm_daypay_tmp( id int default nextval('clm_client_seq'),
 id_client int ,
  day int,
  perc int,
  flag int default 0,
  primary key (id)
);

drop table clm_daypay_tbl;
create sequence clm_daypay_seq; 
CREATE TABLE clm_daypay_tbl ( id int default nextval('clm_client_seq'),
 id_client int ,
  day int,
  perc int,
  flag int default 0,
  primary key (id)
);

create unique index clm_daypay_ind on clm_daypay_tbl (id_client,day,flag); 
/*----------------------------------*/
create or replace function sys_restruct() returns int AS
$BODY$
Begin

insert into clm_daypay_tbl (id_client,day,perc,flag) select s.id_client, sday ,spers,0 
    from ( select id_client,pre_pay_day1 as sday,pre_pay_perc1 as spers
             from clm_statecl_tbl where  pre_pay_perc1>0 and pre_pay_day1>0
          ) s 
         left join clm_daypay_tbl c on c.id_client=s.id_client and s.sday=c.day where c.id_client is null ;

insert into clm_daypay_tbl (id_client,day,perc,flag) select s.id_client, sday ,spers,-1 
   from ( select id_client,dt_indicat+1+pre_pay_day1 as sday,pre_pay_perc1 as spers
             from clm_statecl_tbl where  pre_pay_perc1>0 and pre_pay_day1<0
          ) s 
         left join clm_daypay_tbl c on c.id_client=s.id_client and s.sday=c.day where c.id_client is null;

insert into clm_daypay_tbl (id_client,day,perc,flag) select s.id_client, sday ,spers,0 
    from ( select id_client,pre_pay_day2 as sday,pre_pay_perc2 as spers
             from clm_statecl_tbl where  pre_pay_perc2>0 and pre_pay_day2>0
          ) s 
         left join clm_daypay_tbl c on c.id_client=s.id_client and s.sday=c.day where c.id_client is null ;
   
insert into clm_daypay_tbl (id_client,day,perc,flag) select s.id_client, sday ,spers,0 
    from ( select id_client,pre_pay_day3 as sday,pre_pay_perc3 as spers
             from clm_statecl_tbl where  pre_pay_perc3>0 and pre_pay_day3>0
          ) s 
         left join clm_daypay_tbl c on c.id_client=s.id_client and s.sday=c.day where c.id_client is null;

 insert into clm_daypay_tbl (id_client,day,perc,flag) select * from (select tc.id_client,tc.day,tc.perc,0 
  from clm_daypay_tmp tc 
   left join clm_daypay_tbl c on tc.id_client=c.id_client and tc.day=c.day and tc.day>0 where  c.id_client is null ) as a;

   insert into clm_daypay_tbl (id_client,day,perc,flag) select * from (select tc.id_client,dt_indicat+1+tc.day,tc.perc,0 
  from clm_daypay_tmp tc
      left join clm_daypay_tbl c on tc.id_client=c.id_client,
      clm_statecl_tbl st 
   where  st.id_client=tc.id_client and c.id_client is null  and tc.day=c.day and tc.day<0 ) as a;


return 0;
end;
$BODY$ language 'plpgsql';

select sys_restruct();
/*
select * from clm_daypay_tbl;

delete from clm_daypay_tbl;

select id_client,sum(perc) from clm_daypay_tbl group by id_client

select tc.id_client,dt_indicat+1+tc.day,tc.perc,0 ,c.*
  from clm_daypay_tmp tc
      left join clm_daypay_tbl c on tc.id_client=c.id_client and tc.day=c.day and tc.day<0,
      clm_statecl_tbl st 
   where  st.id_client=tc.id_client and c.id_client is null
*/
