alter table warm_period alter column mmgg set default fun_mmgg(1);
drop function upd_tbl_tmp1();
CREATE function upd_tbl_tmp1() Returns boolean As'
Declare
begin
if (select count(*) from pg_class where relname=''warm_period'')=0 then
 create table warm_period(
     id_client 	int,
     dat_b 	date,
     dat_e 	date,
     mmgg	date default fun_mmgg(1),
     primary key(id_client,dat_b)
 );
Return true;
else 
Return false;
end if;
end;
' Language 'plpgsql';

select upd_tbl_tmp1();
drop function upd_tbl_tmp1();

drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
begin
if (select count(*) from pg_class where relname=''calendar'')=0 then
 create table calendar(
     c_date 	date,
     c_day 	int,
     holiday 	boolean default false,
     notes	text,
     primary key(c_date)
 );
Return true;
else 
Return false;
end if;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();

drop function fill_calend(date);
create function fill_calend(date) Returns boolean As'
Declare
mg Alias for $1;
dt date;
begin
raise notice ''eee'';
dt:=mg;
while dt < date_trunc(''month'',date_mii(mg,-33)) loop
raise notice ''eee1'';
 if (select c_date from calendar where c_date=dt) is null then
raise notice ''eee2'';
  insert into calendar(c_date,c_day,holiday) values(dt,int4(to_char(dt,''d''))
   ,case when to_char(dt,''d'') in (''1'',''7'') then true end);
 end if;
  dt:=date_mii(dt,-1); 
end loop;
 update calendar set holiday=true 
  where to_char(c_date,''mm'')||''-''||to_char(c_date,''dd'') in (''01-01''
    ,''01-07'',''03-08'',''05-01'',''05-02'',''05-09'',''06-28'',''08-24'');
Return true;
end;
' Language 'plpgsql';

drop function fill_calend_global(date,date);
create function fill_calend_global(date,date) Returns boolean As'
Declare
dtb Alias for $1;
dte Alias for $2;
dt date;
begin
dt:=dtb;
while dt <= dte loop
  EXECUTE ''select fill_calend(''||quote_literal(dt)||'');'';
  dt:=date_trunc(''month'',date_mii(dt,-33));
end loop;
Return true;
end;
' Language 'plpgsql';

--select fill_calend_global('2005-05-01'::date,'2006-05-01'::date);
select fill_calend_global('2009-01-01'::date,'2009-12-01'::date);
