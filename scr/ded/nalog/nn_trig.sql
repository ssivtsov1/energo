;
set client_encoding = 'koi8';

DROP TRIGGER acm_deltax_trg ON acm_tax_tbl;
DROP TRIGGER acm_deltaxcor_trg ON acm_taxcorrection_tbl;
DROP TRIGGER acm_delbilltax_trg ON acm_bill_tbl;
DROP TRIGGER acd_edtax_trg  ON acd_tax_tbl;
DROP TRIGGER acd_deltax_trg ON acd_tax_tbl;
DROP TRIGGER acd_edtaxcorr_trg ON acd_taxcorrection_tbl;
DROP TRIGGER acm_edtax_trg ON acm_tax_tbl;


CREATE TABLE acd_tax_del
(
  id integer ,
  dt timestamp without time zone ,
  id_person integer ,
  id_doc integer,
  dt_bill date,
  unit character varying(10),
  demand_val integer,
  tariff numeric(14,4),
  sum_val7 numeric(14,4),
  sum_val8 numeric(14,4),
  sum_val9 numeric(14,4),
  sum_val10 numeric(14,4),
  id_tariff integer,
  id_sumtariff integer,
  mmgg date ,
  flock integer DEFAULT 0,
  text character varying(100),
  dt_del timestamp without time zone DEFAULT now(),
  del_person integer DEFAULT getsysvar('id_person'::character varying)

) 
WITH OIDS;


-- на удалении НН
CREATE or REPLACE FUNCTION acm_deltax_fun ()
  RETURNS trigger
  AS                                                                                              
  '
 begin

 if (OLD.flock = 1) then 
    Raise EXCEPTION ''Закрытый период.'';
 end if;

 if (OLD.flag_transmis = 1) then 
    Raise EXCEPTION ''Налоговая накладная % выдана!'',OLD.reg_num;
 end if;

 update acd_tax_tbl set flock = -1 where id_doc = old.id_doc; 

 delete from acd_tax_tbl where id_doc = old.id_doc;
 delete from acm_billtax_tbl where id_tax = old.id_doc;
 delete from acm_tax_ndserr_tbl where id_doc = old.id_doc;

-- insert into acm_tax_del 
-- select * from acm_tax_tbl where id_doc = OLD.id_doc and coalesce(auto,0) = 0;

 insert into acm_tax_del (id_doc, dt, id_person, id_pref, kind_calc, budget, reg_num, reg_date, 
            id_client, value, value_tax, id_bill, mmgg, flock, int_num, auto, pay_p, flag_transmis, flag_reg)
 select id_doc, dt, id_person, id_pref, kind_calc, budget, reg_num, reg_date, 
            id_client, value, value_tax, id_bill, mmgg, flock, int_num, auto, pay_p, flag_transmis, flag_reg from acm_tax_tbl where id_doc = OLD.id_doc ;

-- delete from acm_taxcorrection_tbl where id_doc in 
--   (select id_correction from acm_taxadvcor_tbl where id_advance = old.id_doc);

 -- если на НН аванса есть погашения, аванс удалять нельзя, попортится структура.
 if ( select count(*) from acm_taxcorrection_tbl where id_tax = old.id_doc ) >0 then
    Raise EXCEPTION ''Нельзя удалить аванс, на который уже есть корректировки.'';
 end if;

 if ( select count(*) from acm_taxadvcor_tbl where id_advance = old.id_doc ) >0 then
    Raise EXCEPTION ''Нельзя удалить аванс, на который уже есть корректировки.'';
 end if;

-- delete from acm_taxcorrection_tbl where id_tax = old.id_doc;
-- delete from acm_taxadvcor_tbl where id_advance = old.id_doc;

 RETURN OLD;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acm_deltax_trg 
before  DELETE 
ON acm_tax_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acm_deltax_fun();

-- на удаление корректировки
CREATE or REPLACE FUNCTION acm_deltaxcor_fun ()
  RETURNS trigger
  AS                                                                                              
  '
 begin

 if (OLD.flock = 1) then 
    Raise EXCEPTION ''Закрытый период.'';
 end if;

 if (OLD.flag_transmis = 1) then 
    Raise EXCEPTION ''Корректировка % выдана!'',OLD.reg_num;
 end if;


 delete from acd_taxcorrection_tbl where id_doc = old.id_doc;
 -- удалить погашения аванса данной корректировкой
 delete from acm_taxadvcor_tbl where id_correction = old.id_doc;

 delete from acm_billtax_tbl where id_tax = old.id_doc;

 RETURN OLD;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acm_deltaxcor_trg 
before  DELETE 
ON acm_taxcorrection_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acm_deltaxcor_fun();

-- удаление НН и корректировок при удалении счета
CREATE or REPLACE FUNCTION acm_delbilltax_fun ()
  RETURNS trigger
  AS                                                                                              
  '
 declare
  vi int;
 begin

 select into vi count(*) from acm_tax_tbl where id_bill = old.id_doc;

 if ( vi<>0) then
   RAISE EXCEPTION ''На данный счет уже выписана налоговая накладная. Невозможно переформировать или удалить счет.'';
 end if;

 select into vi count(*) from acm_taxcorrection_tbl where id_bill = old.id_doc;

 if ( vi<>0) then
   RAISE EXCEPTION ''На данный счет уже выписана корректировка налоговой накладной. Невозможно удалить или переформировать счет.'';
 end if;

-- delete from acm_tax_tbl where id_bill = old.id_doc;
-- delete from acm_taxcorrection_tbl where id_bill = old.id_doc;
 --удалить погашения аванса, на который нет корректировки (тарифы совпали)  
 delete from acm_taxadvcor_tbl where id_bill = old.id_doc;
 --удалить информацию о использовании тарифов при погашении (см.пред)
 delete from acm_billtax_tbl where id_doc = old.id_doc;

 RETURN OLD;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acm_delbilltax_trg 
before  DELETE 
ON acm_bill_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acm_delbilltax_fun();


---------------------------------------------
-- изменение номера НН и другое редактирование
CREATE or REPLACE FUNCTION acm_edtax_fun ()  RETURNS trigger  AS '

 declare 
     vnum_end   varchar;
     vid_doc    int;

 begin

 if ( OLD.value is null)  then 
   return NEW;
 end if;

 if (coalesce(OLD.flock,0) <> coalesce(NEW.flock,0)) then 
   return NEW;
 end if;



 if (coalesce(OLD.disabled,0)=0) and (coalesce(NEW.disabled,0)=1) then 

   if (OLD.flock = 1) then 
       Raise EXCEPTION ''Закрытый период.'';
   end if;

   if ( select count(*) from acm_taxcorrection_tbl where id_tax = old.id_doc ) >0 then
      Raise EXCEPTION ''Нельзя удалить аванс, на который уже есть корректировки.'';
   end if;

   --if ( select count(*) from acm_taxadvcor_tbl where id_advance = old.id_doc ) >0 then
   --   Raise EXCEPTION ''Нельзя удалить аванс, на который уже есть корректировки.'';
   --end if;

   delete from acm_billtax_tbl where id_tax = old.id_doc;
   delete from acm_tax_ndserr_tbl where id_doc = old.id_doc;
   delete from acm_taxadvcor_tbl where id_advance = old.id_doc;

   return NEW;
 end if;

 if (coalesce(OLD.disabled,0)=1) and (coalesce(NEW.disabled,0)=0) then 
      Raise EXCEPTION '' Для того чтобы возобновить неактивную налоговую, переформируйте ее.'';
 end if;
/*
 if (coalesce(OLD.xml_num,0) <> coalesce(NEW.xml_num,0)) then 
   return NEW;
 end if;

 if (coalesce(OLD.flag_reg,0) <> coalesce(NEW.flag_reg,0)) then 
   return NEW;
 end if;
*/

-- if (coalesce(new.flag_transmis,0) =coalesce(old.flag_transmis,0)) then 

  if (OLD.flock = 1) and (NEW.flock<>0) then 

   if (coalesce(OLD.int_num,0)<>coalesce(NEW.int_num,0)) or
      (coalesce(OLD.value,0)<>coalesce(NEW.value,0)) or
      (coalesce(OLD.value_tax,0)<>coalesce(NEW.value_tax,0)) or 
      (coalesce(OLD.reg_num,'''')<>coalesce(NEW.reg_num,'''')) or
      (OLD.reg_date<>NEW.reg_date) then

       Raise EXCEPTION ''Закрытый период.'';

       return OLD;

    end if;

  end if;

 if (OLD.flag_transmis = 1)and (NEW.flag_transmis = 1) then 

   if (coalesce(OLD.int_num,0)<>coalesce(NEW.int_num,0)) or
      (coalesce(OLD.value,0)<>coalesce(NEW.value,0)) or
      (coalesce(OLD.value_tax,0)<>coalesce(NEW.value_tax,0)) or 
      (coalesce(OLD.reg_num,'''')<>coalesce(NEW.reg_num,'''')) or
      (OLD.reg_date<>NEW.reg_date) then

      Raise EXCEPTION ''Налоговая накладная % выдана!'',OLD.reg_num;

      return OLD;

    end if;

 end if;

 if (coalesce(OLD.value,0)<>coalesce(NEW.value,0)) then

   if ( OLD.kind_calc =2 ) then
      Raise EXCEPTION ''Нельзя изменить сумму авансовой налоговой накладной.'';
      return OLD;
   end if;

 end if;

 --правка номера
 if (NEW.int_num <> OLD.int_num) and (NEW.int_num<>0 ) then

  select into vid_doc id_doc from 
  (select id_doc from acm_tax_tbl where int_num = NEW.int_num
   and mmgg= NEW.mmgg and id_doc <> NEW.id_doc
   union 
   select id_doc from acm_taxcorrection_tbl where int_num = NEW.int_num
   and mmgg= NEW.mmgg 
  ) as ss;
   

  if found then

    Raise EXCEPTION ''Номер не уникальный в этом месяце!!!'';
    return OLD;

  else
 
   select into vnum_end value_ident from syi_sysvars_tbl  where ident=''tax_num_ending'';

   NEW.reg_num = text(NEW.int_num)||coalesce(vnum_end,'''');

  end if;
 end if;
 --------------------

 if OLD.reg_date <> NEW.reg_date then

  update acd_tax_tbl set dt_bill = NEW.reg_date
  where acd_tax_tbl.id_doc = OLD.id_doc and acd_tax_tbl.dt_bill = OLD.reg_date;
 
 end if;
  
 insert into acm_tax_del(id_doc, dt, id_person, id_pref, kind_calc, budget, reg_num, reg_date, 
            id_client, value, value_tax, id_bill, mmgg, flock, int_num, auto, pay_p, flag_transmis, flag_reg) 
 select id_doc, dt, id_person, id_pref, kind_calc, budget, reg_num, reg_date, 
            id_client, value, value_tax, id_bill, mmgg, flock, int_num, auto, pay_p, flag_transmis, flag_reg from acm_tax_tbl where id_doc = OLD.id_doc;


 RETURN NEW;
 end;'                                                                                           
LANGUAGE 'plpgsql';          

CREATE TRIGGER acm_edtax_trg 
before  UPDATE 
ON acm_tax_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acm_edtax_fun();

------------------------------------------------------------------
CREATE or REPLACE FUNCTION acd_edtax_fun()  RETURNS trigger  AS '
 declare 
  vtax record;

 begin

  if (OLD.flock = 1) and (NEW.flock<>0) then 

   Raise EXCEPTION ''Закрытый период.'';
   return OLD;

  end if;

  if (coalesce(OLD.flock,0) <> coalesce(NEW.flock,0)) then 

   return NEW;

  end if;


  select into vtax * from acm_tax_tbl where id_doc = OLD.id_doc;

  if (vtax.flag_transmis = 1) then 
    Raise EXCEPTION ''Налоговая накладная % выдана!'',vtax.reg_num;
  end if;

  --if ( vtax.kind_calc =2 ) then
  --   Raise EXCEPTION ''Нельзя изменить строки авансовой налоговой накладной.'';
  --   return OLD;
  --end if;


 insert into acd_tax_del (id, dt, id_person, id_doc, dt_bill, unit, demand_val, sum_val7, 
            sum_val8, sum_val9, sum_val10, id_tariff, id_sumtariff, mmgg, 
            flock, text, tariff,id_zonekoef)
 select id, dt, id_person, id_doc, dt_bill, unit, demand_val, sum_val7, 
            sum_val8, sum_val9, sum_val10, id_tariff, id_sumtariff, mmgg, 
            flock, text, tariff,id_zonekoef from acd_tax_tbl where id = OLD.id;


 RETURN NEW;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acd_edtax_trg 
before  UPDATE 
ON acd_tax_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acd_edtax_fun();

------------------------------------------------------------------
CREATE or REPLACE FUNCTION acd_deltax_fun()  RETURNS trigger  AS '
 declare 
  vtax record;

 begin

  if (OLD.flock = 1) then 

   Raise EXCEPTION ''Закрытый период.'';
   return NULL;

  end if;

--  select into vtax * from acm_tax_tbl where id_doc = OLD.id_doc;

--  if found then

--    if (vtax.flag_transmis = 1) then 
--      Raise EXCEPTION ''Налоговая накладная % выдана!'',vtax.reg_num;
--    return NULL;
--    end if;

--    if ( vtax.kind_calc =2 ) then
--      Raise EXCEPTION ''Нельзя изменить строки авансовой налоговой накладной.'';
--    return NULL;
--    end if;
--  end if;


 insert into acd_tax_del (id, dt, id_person, id_doc, dt_bill, unit, demand_val, sum_val7, 
            sum_val8, sum_val9, sum_val10, id_tariff, id_sumtariff, mmgg, 
            flock, text, tariff,id_zonekoef)
 select id, dt, id_person, id_doc, dt_bill, unit, demand_val, sum_val7, 
            sum_val8, sum_val9, sum_val10, id_tariff, id_sumtariff, mmgg, 
            flock, text, tariff,id_zonekoef from acd_tax_tbl where id = OLD.id;


 RETURN OLD;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acd_deltax_trg 
before  DELETE 
ON acd_tax_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acd_deltax_fun();

------------------------------------------------------------------

CREATE or REPLACE FUNCTION acd_deltaxafter_fun()  RETURNS trigger  AS '
 declare 
  vtax record;

 begin


  select into vtax * from acm_tax_tbl where id_doc = OLD.id_doc;

  if found then

   if OLD.flock<>-1 then

     if (vtax.flag_transmis = 1) then 
       Raise EXCEPTION ''Налоговая накладная % выдана!'',vtax.reg_num;
     return NULL;
     end if;

     if ( vtax.kind_calc =2 ) then
       Raise EXCEPTION ''Нельзя изменить строки авансовой налоговой накладной.'';
       return NULL;
     end if;

   end if;
  end if;


 RETURN OLD;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


DROP TRIGGER acd_deltaxafter_trg ON acd_tax_tbl;

CREATE TRIGGER acd_deltaxafter_trg 
after  DELETE 
ON acd_tax_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acd_deltaxafter_fun();

------------------------------------------------------------------


CREATE or REPLACE FUNCTION acd_edtaxcorr_fun()  RETURNS trigger  AS '
 begin

  if (OLD.flock = 1) and (NEW.flock<>0) then 

   Raise EXCEPTION ''Закрытый период.'';
   return OLD;

  end if;

  new.cor_tax_credit = new.cor_tax;

 RETURN NEW;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acd_edtaxcorr_trg 
before  UPDATE 
ON acd_taxcorrection_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acd_edtaxcorr_fun();

--------------------------------------------------------------------


CREATE or REPLACE FUNCTION acm_edtaxcorr_fun()  RETURNS trigger  AS '
 declare 
     vnum_end   varchar;
     vid_doc    int;

 begin

  if (OLD.flock = 1) and (NEW.flock<>0) then 

   Raise EXCEPTION ''Закрытый период.'';
   return OLD;

  end if;

  if (old.mmgg <> new.mmgg) then 
    update acd_taxcorrection_tbl set mmgg = new.mmgg where id_doc = NEW.id_doc;
  end if;


 --правка номера

 if (NEW.reg_num <> coalesce(OLD.reg_num,'''')) and (NEW.reg_num<>'''' ) then

  select into vid_doc id_doc from 
  (select id_doc from acm_tax_tbl where reg_num = NEW.reg_num
   and mmgg= NEW.mmgg 
   union 
   select id_doc from acm_taxcorrection_tbl where reg_num = NEW.reg_num
   and mmgg= NEW.mmgg and id_doc <> NEW.id_doc
  ) as ss;
   

  if found then

    Raise EXCEPTION ''Номер не уникальный в этом месяце!!!'';
    return OLD;
  end if;
 end if;


 if (NEW.int_num <> coalesce(OLD.int_num,0)) and (NEW.int_num<>0 ) then

  select into vid_doc id_doc from 
  (select id_doc from acm_tax_tbl where int_num = NEW.int_num
   and mmgg= NEW.mmgg 
   union 
   select id_doc from acm_taxcorrection_tbl where int_num = NEW.int_num
   and mmgg= NEW.mmgg and id_doc <> NEW.id_doc
  ) as ss;
   

  if found then

    Raise EXCEPTION ''Номер не уникальный в этом месяце!!!'';
    return OLD;

  else
 
   select into vnum_end value_ident from syi_sysvars_tbl  where ident=''tax_num_ending'';

   NEW.reg_num = text(NEW.int_num)||coalesce(vnum_end,'''');

  end if;
 end if;


 RETURN NEW;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acm_edtaxcorr_trg 
before  UPDATE 
ON acm_taxcorrection_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acm_edtaxcorr_fun();



CREATE or REPLACE FUNCTION acm_newtaxcorr_fun()  RETURNS trigger  AS '
 declare 
     vnum_end   varchar;
     vid_doc    int;

 begin

 --правка номера

 if (NEW.reg_num<>'''' ) then

  select into vid_doc id_doc from 
  (select id_doc from acm_tax_tbl where reg_num = NEW.reg_num
   and mmgg= NEW.mmgg 
   union 
   select id_doc from acm_taxcorrection_tbl where reg_num = NEW.reg_num
   and mmgg= NEW.mmgg 
  ) as ss;
   

  if found then
    Raise EXCEPTION ''Номер не уникальный в этом месяце!!!'';
  end if;
 end if;


 if (NEW.int_num<>0 ) then

  select into vid_doc id_doc from 
  (select id_doc from acm_tax_tbl where int_num = NEW.int_num
   and mmgg= NEW.mmgg 
   union 
   select id_doc from acm_taxcorrection_tbl where int_num = NEW.int_num
   and mmgg= NEW.mmgg
  ) as ss;
   

  if found then

    Raise EXCEPTION ''Номер не уникальный в этом месяце!!!'';

  else
 
   select into vnum_end value_ident from syi_sysvars_tbl  where ident=''tax_num_ending'';

   NEW.reg_num = text(NEW.int_num)||coalesce(vnum_end,'''');

  end if;
 end if;


 RETURN NEW;
 end;'                                                                                           
LANGUAGE 'plpgsql';          


CREATE TRIGGER acm_newtaxcorr_trg 
before  INSERT 
ON acm_taxcorrection_tbl
FOR EACH ROW 
EXECUTE PROCEDURE acm_newtaxcorr_fun();

