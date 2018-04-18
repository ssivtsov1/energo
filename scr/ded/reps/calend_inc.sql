
create or replace function calend_add_hol(date,int) returns date
AS                                                                                              
'
declare 
  pdt alias for $1; 
  pinc alias for $2;

  c int;
  ci int;
  r record;
 r1 record;
  dtt date; 
BEGIN

select into r1   * from calendar where c_date =pdt;

if coalesce(r1.holiday,false)=true  then
 ci=1;
else  
 ci:=0;
end if;

dtt=pdt+ci;

select into r1  * from calendar where c_date =dtt;

if coalesce(r1.holiday,false)=true  then
 ci=1;
else  
 ci:=0;
end if;
dtt=dtt+ci;
raise notice ''dtt  %'',dtt;
c=0;
for r in select * from calendar where c_date>=dtt order by c_date limit 100
loop

--  Raise Notice ''c_date % '',r.c_date;
-- Raise Notice ''hday % '',r.holiday;

 if (coalesce(r.holiday,false)=false) then
-- Raise Notice ''+++++++++'';
   c:=c+1;
 end if;

 if c=pinc then 
   return r.c_date ;
 end if ;
end loop;

RETURN pdt;
end;'                                                                                           
LANGUAGE 'plpgsql';          


-- 
create or replace function calend_dt_inc(date,int) returns date
AS                                                                                              
'
declare 
  pdt alias for $1; 
  pinc alias for $2;

  c int;
  r record;
   
BEGIN

c=0;
for r in select * from calendar where c_date>pdt order by c_date limit 100
loop

--  Raise Notice ''======'';
--  Raise Notice ''c_date % '',r.c_date;
-- Raise Notice ''hday % '',r.holiday;

 if (coalesce(r.holiday,false)=false) then
-- Raise Notice ''+++++++++'';
   c:=c+1;
 end if;

 if c=pinc then 
   return r.c_date ;
 end if ;
end loop;

RETURN pdt;
end;'                                                                                           
LANGUAGE 'plpgsql';          


-- 
create or replace function calend_dt_dec(date,int) returns date
AS                                                                                              
'
declare 
  pdt alias for $1; 
  pdec alias for $2;

  r record;
  voffs int;

BEGIN


 voffs:=pdec;
 select into r * from calendar 
 where c_date<=pdt and coalesce(holiday,false)=false
 order by c_date DESC offset voffs limit 1;

 if found then  
   return r.c_date ;
 else
  return null;
 end if ;

end;'                                                                                           
LANGUAGE 'plpgsql';   

----------------возвращает банковский день указанного месяца, если второй параметр=1,то будет первый рабочий день
drop function calend_bank_day(date,int);

--------------

create or replace function calend_bank_day(date,int,int,int) returns date
AS                                                                                              
'
declare 
  pdt alias for $1; 
  pinc alias for $2;
  pflag alias for $3; -- признак календ./банк. дней
  pdt_start alias for $4; -- день начала расчетного периода

  r record;
  voffs int;
BEGIN

 if pinc = 0 then 
  return pdt;
 end if;

 if coalesce(pflag,0)=0 then

  if pinc > 0 then
    voffs:=pinc-1;
    return date_trunc(''month'',pdt)::date+voffs;
  else
    -- при отрицательном значении параметра отчсет не от начала месяца, а от начала расчетного периода
    -- если абонент платит за матр 23 числа, апрельский расчетный период начинается с 24 марта.  
    voffs:=pinc;
    return (date_trunc(''month'',pdt)::date-''1 month''::interval)::date+pdt_start-1+voffs;
  end if;


 else

  if pinc > 0 then

   voffs:=pinc-1;
   select into r * from calendar 
   where date_trunc(''month'',c_date) = date_trunc(''month'',pdt)  and coalesce(holiday,false)=false
   order by c_date offset voffs limit 1;

   if found then  
     return r.c_date ;
   else
    return null;
   end if ;

  else

   voffs:=-pinc-1;

   select into r * from calendar 
   where c_date < (date_trunc(''month'',pdt)-''1 month''::interval)::date+pdt_start-1 and coalesce(holiday,false)=false
   order by c_date desc offset voffs limit 1;

   if found then  
     return r.c_date ;
   else
    return null;
   end if ;

  end if ;
 end if ;

end;'                                                                                           
LANGUAGE 'plpgsql'; 
----------------------------------------------------
-- вариант с 3 параметрами.
create or replace function calend_bank_day(date,int,int) returns date
AS                                                                                              
'
declare 
  pdt alias for $1; 
  pinc alias for $2;
  pflag alias for $3; -- признак календ./банк. дней

begin

 return calend_bank_day(pdt,pinc,pflag,1);

end;'                                                                                           
LANGUAGE 'plpgsql'; 

