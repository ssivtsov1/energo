;
set client_encoding ='WIN';


CREATE TABLE acm_limit_edit_permission_tbl
(
  id serial ,
  month_limit date,
  code integer,
  id_client integer,
  dt timestamp without time zone DEFAULT now(),
  PRIMARY KEY (id)
);


/*
CREATE TABLE acd_demandlimit_del
(
  id integer ,
  dt timestamp without time zone ,
  id_person integer,
  kind_energy integer,
  month_limit date,
  value_dem numeric(14,4),
  id_doc integer,
  mmgg date ,
  flock integer DEFAULT 0,
  id_client integer,
  id_area integer,
  night_day integer,
  
  id_del serial,
  dt_del timestamp without time zone DEFAULT now(),
  id_person_del integer DEFAULT getsysvar('id_person'::character varying),

  PRIMARY KEY (id_del)
);


CREATE TABLE acm_headdemandlimit_del
(
  id_doc integer ,
  dt timestamp without time zone ,
  id_person integer ,
  reg_date date NOT NULL,
  reg_num character varying(20),
  idk_document integer,
  id_client integer,
  date_begin date,
  date_end date,
  mmgg date ,
  flock integer ,

  id_del serial,
  dt_del timestamp without time zone DEFAULT now(),
  id_person_del integer DEFAULT getsysvar('id_person'::character varying),

  PRIMARY KEY (id_del)
) ;

*/
--select * into acd_dellimit_del 
UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'acd_demandlimit_tbl';

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'acm_headdemandlimit_tbl';

-- from acd_demandlimit_tbl where month_limit<mmgg and  dt<='2009-01-01'  order by mmgg;
--DELETE FROM acd_demandlimit_tbl where month_limit<mmgg and  dt<='2009-01-01'; 
--UPDATE  acd_demandlimit_tbl SET FLOCK=1 WHERE (FLOCK=0 OR FLOCK IS NULL) AND MMGG<=FUN_MMGG();

--drop trigger lim_upd_trg on acd_demandlimit_tbl;
--drop function lim_upd_fun();

--ALTER TABLE acm_headdemandlimit_tbl ALTER COLUMN reg_date SET NOT NULL;

--insert into syi_error_tbl (id,name) values(17,'Заявленные объемы потребления превышают допустимые');


ALTER TABLE acd_demandlimit_tbl ADD COLUMN max_dem numeric(14,4);
---------------------------------------------------------

create or replace function hlim_del_fun() returns trigger as'
Declare
  begin 

   if old.flock=1 then 
--     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    

   delete from acd_demandlimit_tbl where id_doc=old.id_doc;

   INSERT INTO acm_headdemandlimit_del( id_doc, dt, id_person, reg_date, reg_num, idk_document, id_client, 
            date_begin, date_end, mmgg, flock)
   values ( OLD.id_doc, OLD.dt, OLD.id_person, OLD.reg_date, OLD.reg_num, OLD.idk_document, OLD.id_client, 
            OLD.date_begin, OLD.date_end, OLD.mmgg, OLD.flock);

  Return old;  
end;     
' Language 'plpgsql';

create trigger hlim_del_trg 
    Before Delete ON  acm_headdemandlimit_tbl
    For Each Row Execute Procedure hlim_del_fun();
--------------------------------------------------------

--drop trigger hlim_upd_trg on acm_headdemandlimit_tbl;
--drop function hlim_upd_fun();

create or replace function hlim_upd_fun() returns trigger as'
Declare

 r record;
 v int;
 vlimit record;  
 vlimit_old record;  
 --vsection int;
 vstcl record;

begin 
   if old.flock=1 then 
--     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    

   if (old.flock=0) and (NEW.flock=1) then 
     Return new;  
   end if;    

     
   if coalesce(NEW.idk_document,0) <> coalesce(OLD.idk_document,0) then 
     RAISE EXCEPTION ''Changeing doc type forbidden! '';
   end if;    
    

   select into vstcl id_section,dt_start from clm_statecl_h where id_client = NEW.id_client and mmgg_b <= NEW.reg_date 
    and (mmgg_e is null or (mmgg_e > NEW.reg_date)) limit 1;
--     and coalesce(mmgg_e,NEW.reg_date) >=NEW.reg_date limit 1;

   if (coalesce(OLD.reg_date,now()::date) <> coalesce(NEW.reg_date,now()::date)) and (NEW.idk_document = 600)  
    -- and (fun_mmgg() >= ''2010-05-01''::date)  
   and (vstcl.id_section not in (210,211,212,213,214,215,203) 
   )
   then
 
--    delete from sys_error_tbl;
     /*
     for r in 
      select * from acd_demandlimit_tbl where id_doc = NEW.id_doc and month_limit >=fun_mmgg() 
      and date_part(''year'',month_limit) <= 2012
      order by month_limit
     loop

      -- проверим, есть ли другой лимит на этот месяц
      select into vlimit value_dem, hl.id_doc 
      from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l
      on(hl.id_doc = l.id_doc)
      where hl.id_client = NEW.id_client and date_trunc(''month'',l.month_limit)  = r.month_limit 
--      and hl.reg_date <= r.month_limit::date + ''1 month - 1 days''::interval and idk_document = 600 and hl.id_doc <> NEW.id_doc
      and hl.reg_date <= NEW.reg_date and idk_document = 600 and hl.id_doc <> NEW.id_doc
      order by hl.reg_date desc limit 1;   

      if found then 
        -- был лимит, и он был меньше
        if vlimit.value_dem < r.value_dem then

          v:= dem2kr_limitcheck_fun(NEW.id_client,r.value_dem,NEW.reg_date,r.month_limit );

          if v = 0 then
            RAISE EXCEPTION ''Нет предоплаты заявленных объемов потребления на %.'',to_char(r.month_limit,''mm.yyyy'');
          end if;

          if v = -1 then
            RAISE EXCEPTION ''Корректировка лимитов производится не поздненее конечной даты расчетного периода .'';
          end if;
        end if;
      end if;

     end loop;
     */
     -- 2013 год

     for r in 
      select month_limit,sum(value_dem) as value_dem from acd_demandlimit_tbl 
      where id_doc = NEW.id_doc and month_limit >=fun_mmgg() 
     -- and date_part(''year'',month_limit) >= 2013
      group by month_limit
      order by month_limit
     loop


      if    (OLD.reg_date <  (r.month_limit::date+(vstcl.dt_start-1)-''1 month''::interval))
        and (NEW.reg_date >= (r.month_limit::date+(vstcl.dt_start-1)-''1 month''::interval))
      then 
      -- смена даты привела к тому, что некоторые месяци из зоны свободной правки попали в зону контролируемой правки

        Raise Notice ''-2kr- check limit for %'',r.month_limit;

        -- триггер After, в запрос попадает и текущий документ
        select into vlimit sum(l3.value_dem) as value_dem
        from
        (
         select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
         from 
         (	
          select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
          from acm_headdemandlimit_tbl as hl 
          join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
          where hl.id_client = NEW.id_client and date_trunc(''month'',l.month_limit) = r.month_limit 
          --and hl.reg_date <= NEW.reg_date 
          and idk_document = 600 -- and hl.id_doc <> NEW.id_doc
          group by hl.id_client,l.id_area
         ) as s
         join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
         join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)

--         left join eqm_ground_tbl as g on (g.code_eqp = l2.id_area)
         left join ( select distinct g.code_eqp from eqm_ground_tbl as g join eqm_compens_station_inst_tbl as csi on (csi.code_eqp_inst = g.code_eqp) )as g on (g.code_eqp = l2.id_area) 

         where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = r.month_limit
         and (l2.id_area is null or g.code_eqp is not null) 
         group by h2.reg_date, l2.id_area  
        ) as ss
        join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
        join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
        where date_trunc(''month'',l3.month_limit)  = r.month_limit;

        -- возьмем лимит без данного документа
        select into vlimit_old sum(l3.value_dem) as value_dem
        from
        (
         select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
         from 
         (	
          select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
          from acm_headdemandlimit_tbl as hl 
          join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
          where hl.id_client = NEW.id_client and date_trunc(''month'',l.month_limit) = r.month_limit 
          --and hl.reg_date <= NEW.reg_date 
          and idk_document = 600 
          and hl.id_doc <> NEW.id_doc
          group by hl.id_client,l.id_area
         ) as s
         join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
         join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)

--         left join eqm_ground_tbl as g on (g.code_eqp = l2.id_area)
         left join ( select distinct g.code_eqp from eqm_ground_tbl as g join eqm_compens_station_inst_tbl as csi on (csi.code_eqp_inst = g.code_eqp) )as g on (g.code_eqp = l2.id_area) 
         where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = r.month_limit
         and (l2.id_area is null or g.code_eqp is not null) 
         group by h2.reg_date, l2.id_area  
        ) as ss
        join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
        join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
        where date_trunc(''month'',l3.month_limit)  = r.month_limit;


        v:= dem2kr_limitcheck_fun(NEW.id_client,vlimit.value_dem,vlimit_old.value_dem,NEW.reg_date,r.month_limit );
    
        if v = 0 then
           RAISE EXCEPTION ''Нет предоплаты заявленных объемов потребления на %.'',to_char(r.month_limit,''mm.yyyy'');
        end if;

        if v = -1 then
           RAISE EXCEPTION ''Корректировка лимитов производится не поздненее конечной даты расчетного периода .'';
        end if;

      end if;
     end loop;
   end if;

   INSERT INTO acm_headdemandlimit_del( id_doc, dt, id_person, reg_date, reg_num, idk_document, id_client, 
            date_begin, date_end, mmgg, flock)
   values ( OLD.id_doc, OLD.dt, OLD.id_person, OLD.reg_date, OLD.reg_num, OLD.idk_document, OLD.id_client, 
            OLD.date_begin, OLD.date_end, OLD.mmgg, OLD.flock);


  Return new;  
end;     
' Language 'plpgsql';


create trigger hlim_upd_trg 
    after update ON  acm_headdemandlimit_tbl
    For Each Row Execute Procedure hlim_upd_fun();

-------------------------------------------------
--drop trigger lim_del_trg on acd_demandlimit_tbl;
--drop function lim_del_fun();

create or replace function lim_del_fun() returns trigger as'
  Declare
  vdate date;
  vind_date date;
  vstatecl record;
  vhd record;
  v int;
  begin 

   if old.flock=1 then 
--     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    


  select into vhd * from acm_headdemandlimit_tbl as h 
  where h.id_doc = OLD.id_doc;

  select into vstatecl id_section,period_indicat,month_indicat,dt_indicat from clm_statecl_h 
  where id_client = OLD.id_client and mmgg_b <= OLD.month_limit   and (mmgg_e is null or (mmgg_e > OLD.month_limit)) limit 1;


  if (vhd.idk_document = 600) then

    -- по служебке от 15.04.2015 править лимит позднее чем за 5 рабочих дней до конца расчетного периода нельзя
    vdate:=date_trunc(''month'',OLD.month_limit)::date+(text(vstatecl.dt_indicat-1)|| '' days'')::interval;

    vind_date:= case when vstatecl.period_indicat = 1 then vdate
       when vstatecl.period_indicat = 2 and vstatecl.month_indicat = 1 and date_part(''month'',OLD.month_limit) in (1,3,5,7,9,11)  then vdate
       when vstatecl.period_indicat = 2 and vstatecl.month_indicat = 2 and date_part(''month'',OLD.month_limit) in (2,4,6,8,10,12) then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 1 and date_part(''month'',OLD.month_limit) in (1,4,7,10)      then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 2 and date_part(''month'',OLD.month_limit) in (2,5,8,11)      then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 3 and date_part(''month'',OLD.month_limit) in (3,6,9,12)      then vdate  END::date;

    if vind_date is not null then

      if now()::date > calend_dt_dec(vind_date,4)::date then

         select into v id from acm_limit_edit_permission_tbl where OLD.month_limit = month_limit and OLD.id_client = id_client;

         if not found then 

           RAISE EXCEPTION ''Править лимит потребления позднее чем за 5 рабочих дней до конца расчетного периода нельзя!'';
         end if;    
      end if;    

    end if;
  end if;



  INSERT INTO acd_demandlimit_del(
            id, dt, id_person, kind_energy, month_limit, value_dem, id_doc, 
            mmgg, flock, id_client, id_area, night_day)
  values  ( OLD.id, OLD.dt, OLD.id_person, OLD.kind_energy, OLD.month_limit, OLD.value_dem, OLD.id_doc, 
            OLD.mmgg, OLD.flock, OLD.id_client, OLD.id_area, OLD.night_day);


  Return old;  
end;     
' Language 'plpgsql';

create trigger lim_del_trg 
    Before Delete ON  acd_demandlimit_tbl
    For Each Row Execute Procedure lim_del_fun();
--------------------------------------------------------

--drop trigger lim_upd_trg on acd_demandlimit_tbl;
--drop function lim_upd_fun();

create or replace function lim_upd_fun() returns trigger as'
Declare

  v int;
  vhd record;
  vlimit record;
  vstatecl record;
  vvalue_dem numeric;
  varea record;
  r record;
  vdate date;
  vind_date date;
  begin 

   if old.flock=1 then 
--     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    

   if (old.flock=0) and (NEW.flock=1) then 
     Return new;  
   end if;    


   if NEW.id_area is null  then 
     RAISE EXCEPTION ''Empty area!'';
   end if;    

   if NEW.month_limit is null  then 
     RAISE EXCEPTION ''Empty month!'';
   end if;    


     /*
   if month_limit<mmgg then 
     RAISE EXCEPTION ''Check Date'';
   end if;    
   */

  select into vhd * from acm_headdemandlimit_tbl as h 
  where h.id_doc = OLD.id_doc;

  select into vstatecl id_section,period_indicat,month_indicat,dt_indicat from clm_statecl_h 
  where id_client = NEW.id_client and mmgg_b <= NEW.month_limit 
   and (mmgg_e is null or (mmgg_e > NEW.month_limit)) limit 1;



--  if (vhd.idk_document = 600) and (fun_mmgg() >= ''2010-05-01''::date) and (vstatecl.id_section not in (210,211,212,213,214,215,203) ) then
  if (vhd.idk_document = 600) then

    select into v id_doc from acm_headdemandlimit_tbl  
     where id_doc <>  NEW.id_doc and id_client = NEW.id_client and idk_document = 600 limit 1;
    
    if found then -- чтобы разрешить начальный ввод


    -- по служебке от 15.04.2015 править лимит позднее чем за 5 рабочих дней до конца расчетного периода нельзя
    vdate:=date_trunc(''month'',NEW.month_limit)::date+(text(vstatecl.dt_indicat-1)|| '' days'')::interval;

    vind_date:= case when vstatecl.period_indicat = 1 then vdate
       when vstatecl.period_indicat = 2 and vstatecl.month_indicat = 1 and date_part(''month'',NEW.month_limit) in (1,3,5,7,9,11)  then vdate
       when vstatecl.period_indicat = 2 and vstatecl.month_indicat = 2 and date_part(''month'',NEW.month_limit) in (2,4,6,8,10,12) then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 1 and date_part(''month'',NEW.month_limit) in (1,4,7,10)      then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 2 and date_part(''month'',NEW.month_limit) in (2,5,8,11)      then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 3 and date_part(''month'',NEW.month_limit) in (3,6,9,12)      then vdate  END::date;

    if vind_date is not null then

      if now()::date > calend_dt_dec(vind_date,4)::date then

         select into v id from acm_limit_edit_permission_tbl where NEW.month_limit = month_limit and NEW.id_client = id_client;

         if not found then 

           RAISE EXCEPTION ''Править лимит потребления позднее чем за 5 рабочих дней до конца расчетного периода нельзя!'';
         end if;    

      end if;    

    end if;
    end if;



   if (coalesce(NEW.value_dem,0) <> coalesce(OLD.value_dem,0) ) or (coalesce(NEW.id_area,0) <> coalesce(OLD.id_area,0)) 
     or (NEW.month_limit <> OLD.month_limit )
   then  

    delete from sys_error_tbl;

    if date_part(''year'',NEW.month_limit) <= 2012 then

      vvalue_dem:=NEW.value_dem;
    else 

      select into vvalue_dem coalesce(sum(l3.value_dem),0) as value_dem
      from
      (
       select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
       from 
       (	
        select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
        from acm_headdemandlimit_tbl as hl 
        join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
        where hl.id_client = vhd.id_client and date_trunc(''month'',l.month_limit) = NEW.month_limit 
        --and hl.reg_date <= vhd.reg_date 
        and idk_document = 600 
        and coalesce(l.id_area,0) <> NEW.id_area
        group by hl.id_client,l.id_area
       ) as s
       join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
       join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)
--       left join eqm_ground_tbl as g on (g.code_eqp = l2.id_area)
       left join ( select distinct g.code_eqp from eqm_ground_tbl as g join eqm_compens_station_inst_tbl as csi on (csi.code_eqp_inst = g.code_eqp) )as g on (g.code_eqp = l2.id_area) 
       where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = NEW.month_limit
       and (l2.id_area is null or g.code_eqp is not null) 
       group by h2.reg_date, l2.id_area  
      ) as ss
      join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
      join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
      where date_trunc(''month'',l3.month_limit)  = NEW.month_limit;

      vvalue_dem:=vvalue_dem+NEW.value_dem;

      RAISE NOTICE ''You are trying to set demand limit= % '',vvalue_dem; 
    
    end if;
 

    select into varea power, wtm
    from eqm_ground_h as a where a.code_eqp = NEW.id_area and a.dt_b <= vhd.reg_date and (a.dt_e>vhd.reg_date or a.dt_e is null);

     RAISE NOTICE ''varea.power % '',varea.power; 
     RAISE NOTICE ''varea.wtm % '',varea.wtm; 
     RAISE NOTICE ''vstatecl.period_indicat % '',vstatecl.period_indicat; 

--     if (coalesce(varea.power,0)>0 ) and (coalesce(varea.wtm,0)>0 ) then 

       NEW.max_dem:= round(coalesce(varea.power,0)*coalesce(varea.wtm,0)*coalesce(vstatecl.period_indicat,1),0);

       if (coalesce(NEW.value_dem,0) > round(coalesce(varea.power,0)*coalesce(varea.wtm,0)*coalesce(vstatecl.period_indicat,1),0) ) then

        insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_pw'',17);
        RAISE EXCEPTION ''Заявленные объемы потребления превышают допустимые для площадки.'';

       end if;
--    end if;

    --начальный ввод - делается автозаполнением, вставляются строки с площадкой и периодом
    --если нет других документов по данному периоду, это начальный ввод, править можно.
  
    select into vlimit coalesce(sum(l3.value_dem),0) as value_dem
    from
     (
     select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
     from 
     (	
      select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
      from acm_headdemandlimit_tbl as hl 
      join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
      where hl.id_client = vhd.id_client and date_trunc(''month'',l.month_limit) = NEW.month_limit 
      --and hl.reg_date <= vhd.reg_date 
      and idk_document = 600 and hl.id_doc <> vhd.id_doc
      and coalesce(l.id_area,0) = NEW.id_area
      group by hl.id_client,l.id_area
     ) as s
     join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
     join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)
     where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = NEW.month_limit
     group by h2.reg_date, l2.id_area  
    ) as ss
    join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
    join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
    where date_trunc(''month'',l3.month_limit)  = NEW.month_limit;

/*
    select into r coalesce(sum(l.value_dem),0) as old_dem
    from acm_headdemandlimit_tbl as hl 
    join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
    where hl.id_doc <> vhd.id_doc and 
     hl.id_client = vhd.id_client and date_trunc(''month'',l.month_limit) = NEW.month_limit; 
*/

    if found then 

      RAISE NOTICE ''Old demand limit= % '',vlimit.value_dem; 

--(coalesce(NEW.value_dem,0) > coalesce(OLD.value_dem,0) )

      if ( ((vlimit.value_dem < coalesce(NEW.value_dem,0)) and (vlimit.value_dem <>0) ) or (coalesce(NEW.id_area,0) <> coalesce(OLD.id_area,0)) or (NEW.month_limit <> OLD.month_limit)) 
             and (vstatecl.id_section not in (210,211,212,213,214,215,203) )  then  

        v:= dem2kr_limitcheck_fun(NEW.id_client,vvalue_dem,vlimit.value_dem,vhd.reg_date,NEW.month_limit );

        if v = 0 then
         insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_kt'',16);
         RAISE EXCEPTION ''Нет предоплаты заявленных объемов потребления.'';
        end if;

        if v = -1 then
         insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_dt'',16);
         RAISE EXCEPTION ''Корректировка лимитов производится не поздненее конечной даты расчетного периода .'';
        end if;
      end if;
    end if;


   end if;
  end if;


  INSERT INTO acd_demandlimit_del(
            id, dt, id_person, kind_energy, month_limit, value_dem, id_doc, 
            mmgg, flock, id_client, id_area, night_day)
  values  ( OLD.id, OLD.dt, OLD.id_person, OLD.kind_energy, OLD.month_limit, OLD.value_dem, OLD.id_doc, 
            OLD.mmgg, OLD.flock, OLD.id_client, OLD.id_area, OLD.night_day);

  NEW.dt = now();

  Return new;  
end;     
' Language 'plpgsql';

create trigger lim_upd_trg 
    Before update ON  acd_demandlimit_tbl
    For Each Row Execute Procedure lim_upd_fun();


---------------------------------------------------------------------------
--drop trigger lim_new_trg on acd_demandlimit_tbl;
--drop function lim_new_fun();

create or replace function lim_new_fun() returns trigger as'
Declare

  v int;
  vhd record;
  vlimit record;
  vstatecl record;
  vvalue_dem numeric;
  varea record;
  vdate date;
  vind_date date;

  begin 

  select into vhd * from acm_headdemandlimit_tbl as h 
  where h.id_doc = NEW.id_doc;

   if vhd.flock=1 then 
--     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    
     /*
   if month_limit<mmgg then 
     RAISE EXCEPTION ''Check Date'';
   end if;    
   */

   if NEW.id_area is null  then 
     RAISE EXCEPTION ''Empty area!'';
   end if;    

   if NEW.month_limit is null  then 
     RAISE EXCEPTION ''Empty month!'';
   end if;    


  select into vstatecl id_section,period_indicat,month_indicat,dt_indicat from clm_statecl_h where id_client = NEW.id_client and mmgg_b <= NEW.month_limit 
   and (mmgg_e is null or (mmgg_e > NEW.month_limit)) limit 1;
--   and coalesce(mmgg_e,NEW.month_limit) >=NEW.month_limit limit 1;

--  if (vhd.idk_document = 600) and (fun_mmgg() >= ''2010-05-01''::date) and (vstatecl.id_section not in (210,211,212,213,214,215,203) )  then
  if (vhd.idk_document = 600)  then

    select into v id_doc from acm_headdemandlimit_tbl  
     where id_doc <>  NEW.id_doc and id_client = NEW.id_client and idk_document = 600 limit 1;
    
    if found then -- чтобы разрешить начальный ввод

    -- по служебке от 15.04.2015 править лимит позднее чем за 5 рабочих дней до конца расчетного периода нельзя
    vdate:=date_trunc(''month'',NEW.month_limit)::date+(text(vstatecl.dt_indicat-1)|| '' days'')::interval;

    vind_date:= case when vstatecl.period_indicat = 1 then vdate
       when vstatecl.period_indicat = 2 and vstatecl.month_indicat = 1 and date_part(''month'',NEW.month_limit) in (1,3,5,7,9,11)  then vdate
       when vstatecl.period_indicat = 2 and vstatecl.month_indicat = 2 and date_part(''month'',NEW.month_limit) in (2,4,6,8,10,12) then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 1 and date_part(''month'',NEW.month_limit) in (1,4,7,10)      then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 2 and date_part(''month'',NEW.month_limit) in (2,5,8,11)      then vdate
       when vstatecl.period_indicat = 3 and vstatecl.month_indicat = 3 and date_part(''month'',NEW.month_limit) in (3,6,9,12)      then vdate  END::date;

--       raise notice ''vind_date %'',vind_date;
--       raise notice ''NEW.month_limit %'',NEW.month_limit;
--       raise notice ''vstatecl.dt_indicat %'',vstatecl.dt_indicat;

    if vind_date is not null then

      if now()::date > calend_dt_dec(vind_date,4)::date then

         select into v id from acm_limit_edit_permission_tbl where NEW.month_limit = month_limit and NEW.id_client = id_client;

         if not found then 

           RAISE EXCEPTION ''Править лимит потребления позднее чем за 5 рабочих дней до конца расчетного периода % нельзя!'',vind_date;

         end if;    
      end if;    

    end if;
    end if;

    if date_part(''year'',NEW.month_limit) <= 2012 then

      -- проверим, есть ли уже лимит на этот месяц
      select into vlimit value_dem, hl.id_doc 
      from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l
      on(hl.id_doc = l.id_doc)
      where hl.id_client = NEW.id_client and date_trunc(''month'',l.month_limit)  = NEW.month_limit 
      --    and hl.reg_date <= NEW.month_limit::date + ''1 month - 1 days''::interval and idk_document = 600
      and hl.reg_date <= vhd.reg_date and idk_document = 600
      order by hl.reg_date desc limit 1;   

      if found then 
        -- был лимит, и он был меньше
        if vlimit.value_dem < NEW.value_dem then

          delete from sys_error_tbl;

          v:= dem2kr_limitcheck_fun(NEW.id_client,NEW.value_dem,vhd.reg_date,NEW.month_limit );

          if v = 0 then
           insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_kt'',16);
           RAISE EXCEPTION ''Нет предоплаты заявленных объемов потребления.'';
          end if;

          if v = -1 then
           insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_dt'',16);
           RAISE EXCEPTION ''Корректировка лимитов производится не поздненее конечной даты расчетного периода .'';
          end if;

        end if;
      end if;
    else
      -- 2013 
      -- проверим лимит на этот месяц по текущей площадке

      select into varea power, wtm
      from eqm_ground_h as a where a.code_eqp = NEW.id_area and a.dt_b <= vhd.reg_date	and (a.dt_e>vhd.reg_date or a.dt_e is null);

--      if (coalesce(varea.power,0)>0 ) and (coalesce(varea.wtm,0)>0 ) then 

        NEW.max_dem:= round(coalesce(varea.power,0)*coalesce(varea.wtm,0)*coalesce(vstatecl.period_indicat,1),0);

        if (NEW.value_dem > round(coalesce(varea.power,0)*coalesce(varea.wtm,0)*coalesce(vstatecl.period_indicat,1),0) ) then

          insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_pw'',17);
          RAISE EXCEPTION ''Заявленные объемы потребления превышают допустимые для площадки.'';

        end if;

--      end if;

      if (vstatecl.id_section not in (210,211,212,213,214,215,203) ) then

        select into vlimit coalesce(sum(l3.value_dem),0) as value_dem
        from
         (
         select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
         from 
         (	
          select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
          from acm_headdemandlimit_tbl as hl 
          join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
          where hl.id_client = vhd.id_client and date_trunc(''month'',l.month_limit) = NEW.month_limit 
          --and hl.reg_date <= vhd.reg_date 
          and idk_document = 600 
          and coalesce(l.id_area,0) = NEW.id_area
          group by hl.id_client,l.id_area
         ) as s
         join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
         join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)
         where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = NEW.month_limit
         group by h2.reg_date, l2.id_area  
        ) as ss
        join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
        join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
        where date_trunc(''month'',l3.month_limit)  = NEW.month_limit;

        if found then 

          RAISE NOTICE ''Old demand limit= % '',vlimit.value_dem; 

          if ((vlimit.value_dem < NEW.value_dem) and (vlimit.value_dem <> 0 )) then

          -- был лимит, и он был меньше

            select into vvalue_dem coalesce(sum(l3.value_dem),0) as value_dem
            from
            (
             select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
             from 
             (	
              select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
              from acm_headdemandlimit_tbl as hl 
              join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
              where hl.id_client = vhd.id_client and date_trunc(''month'',l.month_limit) = NEW.month_limit 
              --and hl.reg_date <= vhd.reg_date 
              and idk_document = 600 
              and coalesce(l.id_area,0) <> NEW.id_area
              group by hl.id_client,l.id_area
             ) as s
             join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
             join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)
             --left join eqm_ground_tbl as g on (g.code_eqp = l2.id_area)
             left join ( select distinct g.code_eqp from eqm_ground_tbl as g join eqm_compens_station_inst_tbl as csi on (csi.code_eqp_inst = g.code_eqp) )as g on (g.code_eqp = l2.id_area) 
             where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = NEW.month_limit
             and (l2.id_area is null or g.code_eqp is not null) 
             group by h2.reg_date, l2.id_area  
            ) as ss
            join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
            join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
            where date_trunc(''month'',l3.month_limit)  = NEW.month_limit;

            vvalue_dem:=vvalue_dem+NEW.value_dem;
    
            RAISE NOTICE ''You are trying to set demand limit= % '',vvalue_dem; 
            delete from sys_error_tbl;


--            v:= dem2kr_limitcheck_fun(NEW.id_client,vvalue_dem,vlimit.value_dem,vhd.reg_date,NEW.month_limit );
            v:= dem2kr_limitcheck_fun(NEW.id_client,vvalue_dem,vhd.reg_date,NEW.month_limit );

            if v = 0 then
             insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_kt'',16);
             RAISE EXCEPTION ''Нет предоплаты заявленных объемов потребления.'';
            end if;

            if v = -1 then
             insert into sys_error_tbl(nam,ident,id_error) values (''2kr'',''2kr_dt'',16);
             RAISE EXCEPTION ''Корректировка лимитов производится не поздненее конечной даты расчетного периода .'';
            end if;

          end if;
        end if;
      end if;

    end if;

  end if;

  Return new;  
end;     
' Language 'plpgsql';

create trigger lim_new_trg 
    Before insert ON  acd_demandlimit_tbl
    For Each Row Execute Procedure lim_new_fun();

----------------------------------------------------------------------------------------------------------------
--вариант с 4 параметрами
create or replace function dem2kr_limitcheck_fun(int,numeric,date,date) Returns int As'
Declare
 pid_client Alias for $1;
 plimit_val Alias for $2;
 pdt Alias for $3;
 plmmgg Alias for $4;    --месяц, за который анализируется лимит

 vavgtar  record;
 voborot  record;

 vmmgg    date;
 vid_bill int;
 vtarif record;
 vtarif_value numeric;
 vstcl record;
 vsum_prepay numeric;
 vbill_dates record;
 vpre_pay_perc numeric;
 vsum_avans numeric;
 vlimit numeric;

begin

   vmmgg := date_trunc(''month'',pdt);

    Raise Notice '' pid_client %'',pid_client;
    Raise Notice '' plimit_val %'',plimit_val;
    Raise Notice '' pdt %'',pdt;
    Raise Notice '' plmmgg %'',plmmgg;

   select into vstcl st.* , 
--     CASE WHEN (coalesce(st.pre_pay_day3,0)<>0 and coalesce(st.flag_bank_day,0) =1) THEN date_part(''day'',calend_bank_day( vmmgg, st.pre_pay_day3)) ELSE st.pre_pay_day3 END as pre_pay_day3, 
--     CASE WHEN (coalesce(st.pre_pay_day2,0)<>0 and coalesce(st.flag_bank_day,0) =1) THEN date_part(''day'',calend_bank_day( vmmgg, st.pre_pay_day2)) ELSE st.pre_pay_day2 END as pre_pay_day2,
--     CASE WHEN (coalesce(st.pre_pay_day1,0)<>0 and coalesce(st.flag_bank_day,0) =1) THEN date_part(''day'',calend_bank_day( vmmgg, st.pre_pay_day1)) ELSE st.pre_pay_day1 END as pre_pay_day1 
     CASE WHEN (coalesce(st.pre_pay_day3,0)<>0 ) THEN calend_bank_day( vmmgg, st.pre_pay_day3,st.flag_bank_day,st.dt_start) ELSE null END as pre_pay_date3, 
     CASE WHEN (coalesce(st.pre_pay_day2,0)<>0 ) THEN calend_bank_day( vmmgg, st.pre_pay_day2,st.flag_bank_day,st.dt_start) ELSE null END as pre_pay_date2,
     CASE WHEN (coalesce(st.pre_pay_day1,0)<>0 ) THEN calend_bank_day( vmmgg, st.pre_pay_day1,st.flag_bank_day,st.dt_start) ELSE null END as pre_pay_date1 

   from clm_statecl_h as st 
   where st.id_client = pid_client and st.mmgg_b <= vmmgg
   order by st.mmgg_b desc limit 1;

   if pdt < (plmmgg::date+(vstcl.dt_start-1)-''1 month''::interval) then 
    -- корректируемый период еще не начался - править можна
    Raise Notice ''-2kr- free limit change '';
    return 1;

   end if;

   -- бюджет идет без ограничения
   if vstcl.id_section in (210,211,212,213,214,215) then
    Raise Notice ''-2kr- free limit change for budget clients'';
    return 1;

   end if;

   if (select count(*) from acm_bill_tbl where id_client = pid_client and mmgg < vmmgg ) = 0 then 
    Raise Notice ''-2kr- first month for abon'';
    return 1;

   end if;

--   if pdt > (plmmgg::date+(vstcl.dt_indicat-1)) then 
--    -- корректировка не позднее конечной даты расчетного периода абонента.
--    Raise Notice ''-2kr- calc perion is ower '';
--    return -1;
--   end if;


   perform seb_one((vmmgg- ''1 month''::interval)::date ,0 ,pid_client );

   -- последний нормальный счет для расчета среднего тарифа
   select into vid_bill id_doc 
    from acm_bill_tbl 
    where mmgg <= vmmgg and mmgg >=vmmgg - ''3 month''::interval 
    and demand_val > 0 and id_pref=10 and idk_doc = 200 
    and id_client = pid_client
    order by mmgg desc limit 1;

   -- средный тариф
   select into vavgtar
    CASE WHEN sum(bs1.demand_val) >0 THEN round(sum(bs1.sum_val)/sum(bs1.demand_val),5) ELSE 0 END as avg_tar, 
    sum(CASE WHEN coalesce(bs1.id_zone ,0)<>0 THEN 1 ELSE 0 END ) as f_zone, 
    sum(CASE WHEN coalesce(bs1.id_tariff ,0) not in (12,14,15,16,21,22,29,30,44,45,28,35,37,48) THEN 1 ELSE 0 END ) as f_othertarif, 
    sum(CASE WHEN coalesce(bs1.id_tariff ,0) in (12,14,15,16,21,22,29,30) THEN 1 ELSE 0 END ) as f_main, 
    sum(CASE WHEN coalesce(bs1.id_tariff ,0) in (28,35,37,48) THEN 1 ELSE 0 END ) as f_fiz ,
    sum(CASE WHEN b.mmgg = vmmgg THEN 1 ELSE 0 END ) as f_currmmgg  
    from acm_bill_tbl as b 
    join acd_billsum_tbl as bs1 on (bs1.id_doc = b.id_doc) 
      where b.id_doc =  vid_bill;


   if (vavgtar.f_currmmgg <> 0) or (vavgtar.f_zone<>0) or (vavgtar.f_othertarif <> 0) or ((vavgtar.f_main =0 ) and (vavgtar.f_fiz <> 0 ) ) then

     vtarif_value:=vavgtar.avg_tar;

   else

     select into vtarif  tt.value as tarif_value , tt_prev.value as tarif_value_prev 
     from 
     (select 
      sum(CASE when tcl1.ident=''tcl1'' then bs1.demand_val else 0 end ) as dem1, 
      sum(CASE when tcl1.ident=''tcl2'' then bs1.demand_val else 0 end ) as dem2, 
      max(CASE when tcl1.ident=''tcl1'' then tcl1.id else 0 end) as tcl1_id, 
      max(CASE when tcl1.ident=''tcl2'' then tcl1.id else 0 end) as tcl2_id 
      from acm_bill_tbl as b 
      join acd_billsum_tbl as bs1 on (bs1.id_doc = b.id_doc)
      join aci_tarif_tbl as tar1 on (tar1.id=bs1.id_tariff) 
      join eqi_classtarif_tbl as tcl1 on (tar1.id_classtarif=tcl1.id) 
      where b.id_doc=vid_bill and bs1.demand_val<>0  
     ) as tss 
     join aci_tarif_tbl as t on (t.id_grouptarif = 12 and t.id_classtarif = CASE when dem1>dem2 then  tcl1_id else tcl2_id end ) 
     join acd_tarif_tbl as tt on (tt.id_tarif = t.id) 
     join (select id_tarif, max(dt_begin) as dtb from acd_tarif_tbl where dt_begin <= vmmgg group by id_tarif  )as ttd on (tt.id_tarif = ttd.id_tarif and tt.dt_begin = ttd.dtb) 
     join acd_tarif_tbl as tt_prev on (tt_prev.id_tarif = t.id) 
     join (select id_tarif, max(dt_begin) as dtb from acd_tarif_tbl where dt_begin <= vmmgg - ''1 month''::interval group by id_tarif  )as ttd_prev on (tt_prev.id_tarif = ttd_prev.id_tarif and tt_prev.dt_begin = ttd_prev.dtb) 
     limit 1; 


     select into vbill_dates
     coalesce(CASE WHEN b.mmgg = vmmgg THEN b.dat_e ELSE null END , vmmgg+(vstcl.dt_indicat-1) )::date as dt_end ,
     coalesce(CASE WHEN b.mmgg = vmmgg THEN b.dat_b WHEN b.mmgg = vmmgg - ''1 month''::interval THEN b.dat_e+''1 day''::interval ELSE null END, vmmgg+vstcl.dt_indicat-''1 month''::interval)::date as dt_start  
     from 
     acm_bill_tbl as b 
     where b.id_doc=vid_bill;


     vtarif_value:= (vtarif.tarif_value*( (vbill_dates.dt_end - vmmgg)+1)+ vtarif.tarif_value_prev*(vmmgg - vbill_dates.dt_start) ) /
       ( (vbill_dates.dt_end - vbill_dates.dt_start )+1  );

   end if;



   Raise Notice ''-2kr- avg tariff %'',vtarif_value;

--   select into vpre_pay_perc
--     CASE WHEN (coalesce(vstcl.pre_pay_day3,0)<>0 and coalesce(vstcl.pre_pay_day3,0)< date_part(''day'',pdt)) THEN coalesce(vstcl.pre_pay_perc3,0)+coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
--          WHEN (coalesce(vstcl.pre_pay_day2,0)<>0 and coalesce(vstcl.pre_pay_day2,0)< date_part(''day'',pdt)) THEN coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
--          WHEN (coalesce(vstcl.pre_pay_day1,0)<>0 and coalesce(vstcl.pre_pay_day1,0)< date_part(''day'',pdt)) THEN coalesce(vstcl.pre_pay_perc1,0) 
--          ELSE 0 END::numeric/100;    

   select into vpre_pay_perc
     CASE WHEN (vstcl.pre_pay_date3 is not null) and (vstcl.pre_pay_date3 < pdt) THEN coalesce(vstcl.pre_pay_perc3,0)+coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
          WHEN (vstcl.pre_pay_date2 is not null) and (vstcl.pre_pay_date2 < pdt) THEN coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
          WHEN (vstcl.pre_pay_date1 is not null) and (vstcl.pre_pay_date1 < pdt) THEN coalesce(vstcl.pre_pay_perc1,0) 
          ELSE 0 END::numeric/100;    

   Raise Notice ''-2kr- vstcl.pre_pay_date1 %'',vstcl.pre_pay_date1;
   Raise Notice ''-2kr- vstcl.pre_pay_date2 %'',vstcl.pre_pay_date2;
   Raise Notice ''-2kr- vstcl.pre_pay_date3 %'',vstcl.pre_pay_date3;

   Raise Notice ''-2kr- vpre_pay_perc %'',vpre_pay_perc;

--   select into vlimit value_dem 
--    from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l
--    on(hl.id_doc = l.id_doc)
--    where hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = plmmgg 
--    and hl.reg_date <= pdt and idk_document = 600
--    order by hl.reg_date desc limit 1;   

     select into vlimit coalesce(sum(l3.value_dem),0) as value_dem
      from
      (
       select h2.reg_date, l2.id_area, max(h2.id_doc) as id_doc
       from 
       (	
        select  hl.id_client,l.id_area, max(hl.reg_date) as reg_date 
        from acm_headdemandlimit_tbl as hl 
        join acd_demandlimit_tbl as l on(hl.id_doc = l.id_doc)
        where hl.id_client = pid_client and date_trunc(''month'',l.month_limit) = plmmgg 
        --and hl.reg_date <= pdt 
        and idk_document = 600 
        group by hl.id_client,l.id_area
       ) as s
       join acm_headdemandlimit_tbl as h2 on (h2.id_client = s.id_client and h2.reg_date = s.reg_date) 
       join acd_demandlimit_tbl as l2 on(h2.id_doc = l2.id_doc and s.id_area = l2.id_area)
--       left join eqm_ground_tbl as g on (g.code_eqp = l2.id_area)
       left join ( select distinct g.code_eqp from eqm_ground_tbl as g join eqm_compens_station_inst_tbl as csi on (csi.code_eqp_inst = g.code_eqp) )as g on (g.code_eqp = l2.id_area) 
       where h2.idk_document = 600 and date_trunc(''month'',l2.month_limit)  = plmmgg
        and (l2.id_area is null or g.code_eqp is not null) 
       group by h2.reg_date, l2.id_area  
      ) as ss
      join acm_headdemandlimit_tbl as h3 on (h3.id_doc = ss.id_doc) 
      join acd_demandlimit_tbl as l3 on(h3.id_doc = l3.id_doc and ss.id_area = l3.id_area)
      where date_trunc(''month'',l3.month_limit)  = plmmgg;

   vsum_avans:= round(vlimit*vtarif_value*vpre_pay_perc*1.2,2);

   -- текущий кредит
   select into voborot 
     coalesce(s.deb_k,0) as db, CASE WHEN order_pay =0 THEN coalesce(s.kr_zkmv,0) ELSE coalesce(kr_zkmv_now,0) END as kb_now,  
--     coalesce(s.deb_k,0) as db, coalesce(s.kr_zkmv,0) as kb, coalesce(kr_zkmv_now,0) as kb_now,  
     coalesce(bill.sumbill,0) AS sumbill, bill.reg_date as bill_date, bill.transmis_date,
     coalesce(pay.pay_all,0) AS pay_all,  pay.reg_date as pay_date 
--     coalesce(s.deb_k,0) - coalesce(pay.pay_all,0) + coalesce(bill.sumbill,0) - coalesce(s.kr_old_pos,0) - coalesce(s.kr_zkmv_now,0) as dk 
--     numeric_larger(coalesce(s.kr_zkmv_now,0) + coalesce(pay.pay10,0) - coalesce(bill.sumbill10,0) - coalesce(s.deb10_k,0),0 ) as kk_now 
     from 
     (select obr.id_client, c.order_pay,
     -deb_kmv as deb_k,kr_zkmv as kr_zkmv, e_kred+e_kred_tax as kr_zkmv_now,  
     CASE WHEN kr_zkmv > (e_kred+e_kred_tax) THEN kr_zkmv - (e_kred+e_kred_tax) ELSE 0 END as kr_old_pos 
     from seb_obr_all_tmp as obr 
     join clm_client_tbl as c on (c.id = obr.id_client)
     where obr.period = vmmgg- ''1 month''::interval and obr.id_pref = 10 and obr.id_client = pid_client ) as s 
     full outer join 
     ( select b.id_client, sum(b.value+b.value_tax) as sumbill, 
       max(b.date_transmis) as transmis_date, max(b.reg_date) as reg_date,  
       sum(CASE WHEN date_part(''year'',b.mmgg_bill) = date_part(''year'',vmmgg) THEN b.value+b.value_tax ELSE 0 END) as sumbill10 
     from acm_bill_tbl as b 
      where b.mmgg = vmmgg and b.reg_date <= pdt 
      and b.id_pref = 10 and b.id_client = pid_client and b.idk_doc <> 201 group by b.id_client order by b.id_client ) as bill using (id_client) 
     full outer join 
     (select p.id_client, max(p.reg_date) as reg_date,  sum(p.value_pay) as pay_all,  
      sum(CASE WHEN date_part(''year'',p.mmgg_pay) = date_part(''year'',vmmgg) THEN p.value_pay ELSE 0 END) as pay10 
      from acm_pay_tbl as p 
       where p.reg_date <= pdt and ( vmmgg = date_trunc(''month'', p.reg_date))  
       and p.id_pref = 10 and p.id_client = pid_client and p.sign_pay = 1 group by p.id_client order by p.id_client ) as pay using (id_client); 

    if voborot.kb_now+voborot.pay_all-voborot.db >0 then
       vsum_prepay:=voborot.kb_now+voborot.pay_all-voborot.db;
    else
       vsum_prepay:=0;
    end if;

   Raise Notice ''-2kr-4 params- -'';
   Raise Notice ''-2kr- current kt %'',vsum_prepay;
   Raise Notice ''-2kr- vsum_avans %'',vsum_avans;

   Raise Notice ''-2kr- plimit_val %'',plimit_val;
   Raise Notice ''-2kr- vlimit %'',vlimit;
   Raise Notice ''-2kr- calc_pay %'',round((plimit_val-vlimit)*vtarif_value*1.2,2);

   if vlimit < plimit_val then

   if round((plimit_val-vlimit)*vtarif_value*1.2,2) > (vsum_prepay-vsum_avans) then
--if round(plimit_val*vtarif_value*1.2,2) > (vsum_prepay-vsum_avans) then 
       Raise Notice ''-2kr- return 0'';
       return 0;
    else
       Raise Notice ''-2kr- return 1'';
       return 1;

    end if;
   else
     Raise Notice ''-2kr- return 1'';
     return 1;
   end if;

end;
' Language 'plpgsql'; 


----------------------------------------------------------------------------------------------
--вариант с 5 параметрами - передается старое и новое значение лимита
create or replace function dem2kr_limitcheck_fun(int,numeric,numeric,date,date) Returns int As'
Declare
 pid_client Alias for $1;
 plimit_val Alias for $2;
 plimit_old Alias for $3;
 pdt Alias for $4;
 plmmgg Alias for $5;    --месяц, за который анализируется лимит

 vavgtar  record;
 voborot  record;

 vmmgg    date;
 vid_bill int;
 vtarif record;
 vtarif_value numeric;
 vstcl record;
 vsum_prepay numeric;
 vbill_dates record;
 vpre_pay_perc numeric;
 vsum_avans numeric;
-- vlimit numeric;

begin

   vmmgg := date_trunc(''month'',pdt);

    Raise Notice '' pid_client %'',pid_client;
    Raise Notice '' plimit_val %'',plimit_val;
    Raise Notice '' plimit_old %'',plimit_old;
    Raise Notice '' pdt %'',pdt;
    Raise Notice '' plmmgg %'',plmmgg;

   select into vstcl st.* , 
--     CASE WHEN (coalesce(st.pre_pay_day3,0)<>0 and coalesce(st.flag_bank_day,0) =1) THEN date_part(''day'',calend_bank_day( vmmgg, st.pre_pay_day3)) ELSE st.pre_pay_day3 END as pre_pay_day3, 
--     CASE WHEN (coalesce(st.pre_pay_day2,0)<>0 and coalesce(st.flag_bank_day,0) =1) THEN date_part(''day'',calend_bank_day( vmmgg, st.pre_pay_day2)) ELSE st.pre_pay_day2 END as pre_pay_day2,
--     CASE WHEN (coalesce(st.pre_pay_day1,0)<>0 and coalesce(st.flag_bank_day,0) =1) THEN date_part(''day'',calend_bank_day( vmmgg, st.pre_pay_day1)) ELSE st.pre_pay_day1 END as pre_pay_day1 
     CASE WHEN (coalesce(st.pre_pay_day3,0)<>0 ) THEN calend_bank_day( vmmgg, st.pre_pay_day3,st.flag_bank_day,st.dt_start) ELSE null END as pre_pay_date3, 
     CASE WHEN (coalesce(st.pre_pay_day2,0)<>0 ) THEN calend_bank_day( vmmgg, st.pre_pay_day2,st.flag_bank_day,st.dt_start) ELSE null END as pre_pay_date2,
     CASE WHEN (coalesce(st.pre_pay_day1,0)<>0 ) THEN calend_bank_day( vmmgg, st.pre_pay_day1,st.flag_bank_day,st.dt_start) ELSE null END as pre_pay_date1 

   from clm_statecl_h as st 
   where st.id_client = pid_client and st.mmgg_b <= vmmgg
   order by st.mmgg_b desc limit 1;

   if pdt < (plmmgg::date+(vstcl.dt_start-1)-''1 month''::interval) then 
    -- корректируемый период еще не начался - править можна
    Raise Notice ''-2kr- free limit change '';
    return 1;

   end if;

   -- бюджет идет без ограничения
   if vstcl.id_section in (210,211,212,213,214,215) then
    Raise Notice ''-2kr- free limit change for budget clients'';
    return 1;

   end if;

   if (select count(*) from acm_bill_tbl where id_client = pid_client and mmgg < vmmgg ) = 0 then 
    Raise Notice ''-2kr- first month for abon'';
    return 1;

   end if;

--   if pdt > (plmmgg::date+(vstcl.dt_indicat-1)) then 
--    -- корректировка не позднее конечной даты расчетного периода абонента.
--    Raise Notice ''-2kr- calc perion is ower '';
--    return -1;
--   end if;


   perform seb_one((vmmgg- ''1 month''::interval)::date ,0 ,pid_client );

   -- последний нормальный счет для расчета среднего тарифа
   select into vid_bill id_doc 
    from acm_bill_tbl 
    where mmgg <= vmmgg and mmgg >=vmmgg - ''3 month''::interval 
    and demand_val > 0 and id_pref=10 and idk_doc = 200 
    and id_client = pid_client
    order by mmgg desc limit 1;

   -- средный тариф
   select into vavgtar
    CASE WHEN sum(bs1.demand_val) >0 THEN round(sum(bs1.sum_val)/sum(bs1.demand_val),5) ELSE 0 END as avg_tar, 
    sum(CASE WHEN coalesce(bs1.id_zone ,0)<>0 THEN 1 ELSE 0 END ) as f_zone, 
    sum(CASE WHEN coalesce(bs1.id_tariff ,0) not in (12,14,15,16,21,22,29,30,44,45,28,35,37,48) THEN 1 ELSE 0 END ) as f_othertarif, 
    sum(CASE WHEN coalesce(bs1.id_tariff ,0) in (12,14,15,16,21,22,29,30) THEN 1 ELSE 0 END ) as f_main, 
    sum(CASE WHEN coalesce(bs1.id_tariff ,0) in (28,35,37,48) THEN 1 ELSE 0 END ) as f_fiz ,
    sum(CASE WHEN b.mmgg = vmmgg THEN 1 ELSE 0 END ) as f_currmmgg  
    from acm_bill_tbl as b 
    join acd_billsum_tbl as bs1 on (bs1.id_doc = b.id_doc) 
      where b.id_doc =  vid_bill;


   if (vavgtar.f_currmmgg <> 0) or (vavgtar.f_zone<>0) or (vavgtar.f_othertarif <> 0) or ((vavgtar.f_main =0 ) and (vavgtar.f_fiz <> 0 ) ) then

     vtarif_value:=vavgtar.avg_tar;

   else

     select into vtarif  tt.value as tarif_value , tt_prev.value as tarif_value_prev 
     from 
     (select 
      sum(CASE when tcl1.ident=''tcl1'' then bs1.demand_val else 0 end ) as dem1, 
      sum(CASE when tcl1.ident=''tcl2'' then bs1.demand_val else 0 end ) as dem2, 
      max(CASE when tcl1.ident=''tcl1'' then tcl1.id else 0 end) as tcl1_id, 
      max(CASE when tcl1.ident=''tcl2'' then tcl1.id else 0 end) as tcl2_id 
      from acm_bill_tbl as b 
      join acd_billsum_tbl as bs1 on (bs1.id_doc = b.id_doc)
      join aci_tarif_tbl as tar1 on (tar1.id=bs1.id_tariff) 
      join eqi_classtarif_tbl as tcl1 on (tar1.id_classtarif=tcl1.id) 
      where b.id_doc=vid_bill and bs1.demand_val<>0  
     ) as tss 
     join aci_tarif_tbl as t on (t.id_grouptarif = 12 and t.id_classtarif = CASE when dem1>dem2 then  tcl1_id else tcl2_id end ) 
     join acd_tarif_tbl as tt on (tt.id_tarif = t.id) 
     join (select id_tarif, max(dt_begin) as dtb from acd_tarif_tbl where dt_begin <= vmmgg group by id_tarif  )as ttd on (tt.id_tarif = ttd.id_tarif and tt.dt_begin = ttd.dtb) 
     join acd_tarif_tbl as tt_prev on (tt_prev.id_tarif = t.id) 
     join (select id_tarif, max(dt_begin) as dtb from acd_tarif_tbl where dt_begin <= vmmgg - ''1 month''::interval group by id_tarif  )as ttd_prev on (tt_prev.id_tarif = ttd_prev.id_tarif and tt_prev.dt_begin = ttd_prev.dtb) 
     limit 1; 


     select into vbill_dates
     coalesce(CASE WHEN b.mmgg = vmmgg THEN b.dat_e ELSE null END , vmmgg+(vstcl.dt_indicat-1) )::date as dt_end ,
     coalesce(CASE WHEN b.mmgg = vmmgg THEN b.dat_b WHEN b.mmgg = vmmgg - ''1 month''::interval THEN b.dat_e+''1 day''::interval ELSE null END, vmmgg+vstcl.dt_indicat-''1 month''::interval)::date as dt_start  
     from 
     acm_bill_tbl as b 
     where b.id_doc=vid_bill;


     vtarif_value:= (vtarif.tarif_value*( (vbill_dates.dt_end - vmmgg)+1)+ vtarif.tarif_value_prev*(vmmgg - vbill_dates.dt_start) ) /
       ( (vbill_dates.dt_end - vbill_dates.dt_start )+1  );

   end if;



   Raise Notice ''-2kr- avg tariff %'',vtarif_value;

--   select into vpre_pay_perc
--     CASE WHEN (coalesce(vstcl.pre_pay_day3,0)<>0 and coalesce(vstcl.pre_pay_day3,0)< date_part(''day'',pdt)) THEN coalesce(vstcl.pre_pay_perc3,0)+coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
--          WHEN (coalesce(vstcl.pre_pay_day2,0)<>0 and coalesce(vstcl.pre_pay_day2,0)< date_part(''day'',pdt)) THEN coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
--          WHEN (coalesce(vstcl.pre_pay_day1,0)<>0 and coalesce(vstcl.pre_pay_day1,0)< date_part(''day'',pdt)) THEN coalesce(vstcl.pre_pay_perc1,0) 
--          ELSE 0 END::numeric/100;    

   select into vpre_pay_perc
     CASE WHEN (vstcl.pre_pay_date3 is not null) and (vstcl.pre_pay_date3 < pdt) THEN coalesce(vstcl.pre_pay_perc3,0)+coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
          WHEN (vstcl.pre_pay_date2 is not null) and (vstcl.pre_pay_date2 < pdt) THEN coalesce(vstcl.pre_pay_perc2,0)+coalesce(vstcl.pre_pay_perc1,0) 
          WHEN (vstcl.pre_pay_date1 is not null) and (vstcl.pre_pay_date1 < pdt) THEN coalesce(vstcl.pre_pay_perc1,0) 
          ELSE 0 END::numeric/100;    

--   select into vlimit value_dem 
--    from acm_headdemandlimit_tbl as hl join acd_demandlimit_tbl as l
--    on(hl.id_doc = l.id_doc)
--    where hl.id_client = pid_client and date_trunc(''month'',l.month_limit)  = plmmgg 
--    and hl.reg_date <= pdt and idk_document = 600
--    order by hl.reg_date desc limit 1;   


   vsum_avans:= round(plimit_old*vtarif_value*vpre_pay_perc*1.2,2);

   -- текущий кредит
   select into voborot 
     coalesce(s.deb_k,0) as db, CASE WHEN order_pay =0 THEN coalesce(s.kr_zkmv,0) ELSE coalesce(kr_zkmv_now,0) END as kb_now,  
     coalesce(bill.sumbill,0) AS sumbill, bill.reg_date as bill_date, bill.transmis_date,
     coalesce(pay.pay_all,0) AS pay_all,  pay.reg_date as pay_date 
--     coalesce(s.deb_k,0) - coalesce(pay.pay_all,0) + coalesce(bill.sumbill,0) - coalesce(s.kr_old_pos,0) - coalesce(s.kr_zkmv_now,0) as dk 
--     numeric_larger(coalesce(s.kr_zkmv_now,0) + coalesce(pay.pay10,0) - coalesce(bill.sumbill10,0) - coalesce(s.deb10_k,0),0 ) as kk_now 
     from 
     (select obr.id_client, c.order_pay,
     -deb_kmv as deb_k,kr_zkmv as kr_zkmv, e_kred+e_kred_tax as kr_zkmv_now,  
     CASE WHEN kr_zkmv > (e_kred+e_kred_tax) THEN kr_zkmv - (e_kred+e_kred_tax) ELSE 0 END as kr_old_pos 
     from seb_obr_all_tmp as obr 
     join clm_client_tbl as c on (c.id = obr.id_client)
     where obr.period = vmmgg- ''1 month''::interval and obr.id_pref = 10 and obr.id_client = pid_client ) as s 
     full outer join 
     ( select b.id_client, sum(b.value+b.value_tax) as sumbill, 
       max(b.date_transmis) as transmis_date, max(b.reg_date) as reg_date,  
       sum(CASE WHEN date_part(''year'',b.mmgg_bill) = date_part(''year'',vmmgg) THEN b.value+b.value_tax ELSE 0 END) as sumbill10 
     from acm_bill_tbl as b 
      where b.mmgg = vmmgg and b.reg_date <= pdt 
      and b.id_pref = 10 and b.id_client = pid_client and b.idk_doc <> 201 group by b.id_client order by b.id_client ) as bill using (id_client) 
     full outer join 
     (select p.id_client, max(p.reg_date) as reg_date,  sum(p.value_pay) as pay_all,  
      sum(CASE WHEN date_part(''year'',p.mmgg_pay) = date_part(''year'',vmmgg) THEN p.value_pay ELSE 0 END) as pay10 
      from acm_pay_tbl as p 
       where p.reg_date <= pdt and ( vmmgg = date_trunc(''month'', p.reg_date))  
       and p.id_pref = 10 and p.id_client = pid_client and p.sign_pay = 1 group by p.id_client order by p.id_client ) as pay using (id_client); 

    if voborot.kb_now+voborot.pay_all-voborot.db >0 then
       vsum_prepay:=voborot.kb_now+voborot.pay_all-voborot.db;
    else
       vsum_prepay:=0;
    end if;


   Raise Notice ''-2kr-5 params- -'';
   Raise Notice ''-2kr- current kt %'',vsum_prepay;

   Raise Notice ''-2kr- vsum_avans %'',vsum_avans;

   Raise Notice ''-2kr- plimit_val %'',plimit_val;
   Raise Notice ''-2kr- calc_pay %'',round((plimit_val-plimit_old)*vtarif_value*1.2,2);


   if plimit_old < plimit_val then

    if round((plimit_val-plimit_old)*vtarif_value*1.2,2) > (vsum_prepay-vsum_avans) then
--   if round(plimit_val*vtarif_value*1.2,2) > (vsum_prepay-vsum_avans) then 
       return 0;
    else
       return 1;
    end if;
   else
     return 1;
   end if;

end;
' Language 'plpgsql'; 

