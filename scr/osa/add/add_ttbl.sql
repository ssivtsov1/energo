create sequence  sys_tmptable_seq;
CREATE TABLE SYS_TMPTABLE
( id int default nextval('sys_tmptable_seq'),
  table_tmp varchar(25) not null,
  table_tbl varchar(25) not null,
  flag int4 not null,
  primary key (id)
) 
WITHOUT OIDS;



delete from sys_tmptable;
insert into sys_tmptable (id,table_tmp,table_tbl,flag) values (1,'act_comp_percent','acd_comp_percent',1);
--insert into sys_tmptable (id,table_tmp,table_tbl,flag) values (2,'act_summ_tbl','acm_summ_tbl',1);
--insert into sys_tmptable (id,table_tmp,table_tbl,flag) values (3,'act_lgt_tbl','acm_lgt_tbl',1);
--insert into sys_tmptable (id,table_tmp,table_tbl,flag) values (4,'act_lgt_summ_tbl','acm_lgt_summ_tbl',1);
--insert into sys_tmptable (id,table_tmp,table_tbl,flag) values (5,'act_subs_tbl','acm_subs_tbl',1);



CREATE OR REPLACE FUNCTION table_exists("varchar")
  RETURNS bool AS
'   declare t_name alias for $1;
    declare t_result varchar;
 begin
    select relname into t_result
       from pg_class
       where relname ~* (''^'' || t_name || ''$'')
             and relkind = ''r'';
       if t_result is null then return false;
            else return true;
       end if;
 end;'
  LANGUAGE 'plpgsql'; 


CREATE OR REPLACE FUNCTION add_ttbl()
  RETURNS bool AS
$BODY$
Declare
dt_rest text;
id_rest date;
rtable record;
SSql text;
begin
if table_exists('sys_basa_tbl') then
select into id_rest value_ident from syi_sysvars_tbl
 where ident='dt_restore';
raise notice '0';
if not found then
raise notice '1';
insert into syi_sysvars_tbl (id,ident,value_ident) 
         values (114,'dt_restore',now()::date);

insert into syi_sysvars_tbl (id,ident,value_ident) 
         values (115,'dt_last', 
        min( max ((select max(dt) from acm_bill_tbl) ::date,
                  (select max(dt) from acm_pay_tbl)::date          
                 )::date,
             now()::date 
           )
          );
else
update syi_sysvars_tbl set value_ident=now() where id=114;
update syi_sysvars_tbl set value_ident= (select min( max ((select max(dt) from acm_bill_tbl) ::date,
                  (select max(dt) from acm_pay_tbl)::date          
                 )::date,        now()::date    )  )  where id=115;


end if;
end if;
--CREATE temp TABLE syi_sysvars_tmp AS select * from syi_sysvars_tbl;

for rtable in select * from  sys_tmptable loop
SSql=' CREATE  temp table ' ||rtable.table_tmp|| ' as select * from '||rtable.table_tbl||' limit 1'; 
raise notice 'SSql %',SSql;
Execute SSQL;

SSql='  delete from '||rtable.table_tmp; 
raise notice 'SSql %',SSql;
Execute SSQL;

end loop;

Return true;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION clearadd_ttbl(int4)
  RETURNS bool AS
$BODY$
Declare
pflag alias for $1;
rtable record;
SSql text;
begin

for rtable in select * from  sys_tmptable where flag=pflag loop
SSql='  delete from '||rtable.table_tmp; 
raise notice 'SSql %',SSql;
Execute SSQL;

end loop;

Return true;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


