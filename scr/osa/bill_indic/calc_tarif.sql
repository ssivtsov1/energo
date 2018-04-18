drop function Calc_Sum_AddDem(int,date,date,int);
create or replace function Calc_Sum_AddDem(int,date,date,int) returns numeric as
'declare id_tar alias for $1;
         dtb alias for $2;
         dte alias for $3;
         dem alias for $4;
         maxdat record;
         mdat date;
         allday int;
         tarday int;
         summa numeric;
         rectar record;
begin
summa=0.00;
allday=date_mi(dte::date,dtb::date)+1;
raise notice ''allday    %'',allday;

for maxdat in select max(dt_begin)::date as maxd   from  acd_tarif_tbl where id_tarif=id_tar and dt_begin<=dtb group by id_tarif,idk_currency  loop
mdat=maxdat.maxd; 
raise notice ''mdat   %'',mdat;
--max(dtb,dt_begin)::date as dtb, min(dte,dt_end)::date as dte, 
for rectar in  select max(dtb,dt_begin) as dtb1,  min(dte,coalesce(dt_end,now()::date)) as dte1,  value  from acd_tarif_tbl  where id_tarif=id_tar  and dt_begin>= mdat and (dt_end<=dte or dt_end is null)  loop
    tarday=date_mi(rectar.dte1::date,rectar.dtb1::date)+1;
  raise notice ''allday    %'',allday;
  raise notice ''tarday    %'',tarday;
 raise notice ''from    %'',rectar.dtb1;
 raise notice ''to    %'',rectar.dte1;
 raise notice ''value    %'',rectar.value;
raise notice ''demday   %'',dem::numeric/allday::numeric*tarday::numeric;
 raise notice ''addvalue    %'',dem::numeric/allday::numeric*tarday::numeric*rectar.value;
  summa=summa+dem::numeric/allday::numeric*tarday::numeric*rectar.value;
end loop;
end loop;
return round(summa,2);

end;
' language 'plpgsql';

--select Calc_Sum_AddDem(36,'2010-01-11','2010-04-15',1000)
--select Calc_Sum_AddDem(12,'2010-04-01','2010-04-30',2000)::numeric as booch 


--select Calc_Sum_AddDem(12,'2010-01-11','2010-04-15',1000)
/*
select date_mi('2010-01-01'::date,'2010-01-31'::date)
select * from acd_tarif_tbl  where id_tarif in (36,40)

select * from aci_tarif_tbl

select * from acd_tarif_tbl order by id_tarif,dt_begin desc
select * from acd_tarif_tbl where id_tarif in (14) order by id_tarif,dt_begin desc

select max(dt_begin,dt_end) ,min (dt_begin,dt_end) from  acd_tarif_tbl where id_tarif=14 and dt_begin<='2009-01-13' group by id_tarif,idk_currency

select max('2010-01-01',dt_begin)::date as dtb, min('2099-01-01',dt_end)::date as dte,  value

 from acd_tarif_tbl where id_tarif=14 and dt_begin<='2010-01-01' and dt_begin>= '2010-01-01' and dt_end<='2020-01-01'


select dt_begin , dt_end,  value

 from acd_tarif_tbl where id_tarif=21 and dt_begin<='2010-01-01' and dt_begin>= '2010-01-01' and dt_end<='2020-01-01'

*/
 
create  or replace function Calc_tarif_End() returns int as
'declare 
       rectar record;
      rectar1 record;
      dtprev date;
begin
--ALTER TABLE  acd_tarif_tbl  DISABLE TRIGGER user;
for rectar1 in select distinct id_tarif,idk_currency from acd_tarif_tbl order by id_tarif loop
 dtprev=null; 
 for rectar in select  * from acd_tarif_tbl where id_tarif=rectar1.id_tarif and idk_currency=rectar1.idk_currency order by dt_begin desc loop
   update acd_tarif_tbl set dt_end=dtprev where id=rectar.id;
   dtprev=rectar.dt_begin; 
 end loop;
end loop;
--ALTER TABLE acd_tarif_tbl  ENABLE TRIGGER user;

return 1;
end;
' language 'plpgsql';

--select calc_tarif_end();