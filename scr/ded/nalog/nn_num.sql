ALTER TABLE acm_taxcorrection_tbl ADD COLUMN int_num integer;

-- получение очередного номера НН
--create unique index acm_tax_intnum_idx on acm_tax_tbl (int_num,mmgg);
drop index acm_tax_intnum_idx;
create unique index acm_tax_intnum_idx on acm_tax_tbl (int_num,mmgg) where int_num <> 0;

drop function acm_nexttaxnum();

create or replace function acm_nexttaxnum(date) returns int as'
  declare 
     pmmgg    alias for $1;
     vint_num     int;
     vint_num2     int;

  begin

    select into vint_num coalesce(max(int_num),0) from acm_tax_tbl where mmgg=date_trunc(''month'',pmmgg); 

    select into vint_num2 coalesce(max(int_num),0) from acm_taxcorrection_tbl where mmgg=date_trunc(''month'',pmmgg); 


    if vint_num<vint_num2 then
       vint_num:=vint_num2;
    end if;


    select into vint_num2 to_number(trim(value_ident),''0000000000'') from syi_sysvars_tbl 
                 where ident=''last_tax_num'';


    if vint_num<vint_num2 then
       vint_num:=vint_num2;

    else
       vint_num:=vint_num+1;
    end if;

    return vint_num;

  end;
' LANGUAGE 'plpgsql';

-- смена номера существующей НН (только что выписанной)
create or replace function acm_SetTaxNum(int,int) returns boolean as'
  declare 
     pid_tax    alias for $2;
     pnewnum    alias for $1;
     vreg_num   varchar;
     vnum_end   varchar;
     vmmgg      date;
     vid_doc    int;

  begin

    select into vnum_end value_ident from syi_sysvars_tbl 
    where ident=''tax_num_ending'';

 --   select into vmmgg to_date(value_ident,''dd.mm.yyyy'') from syi_sysvars_tbl 
--    where ident=''mmgg'';

    select into vmmgg mmgg from acm_tax_tbl  where id_doc = pid_tax; 


    -- проверка на существование такого номера в этом году
    select into vid_doc id_doc from acm_tax_tbl where int_num = pnewnum
    and date_trunc(''month'',mmgg)=date_trunc(''month'',vmmgg) and id_doc <> pid_tax and pnewnum<>0; 

    if not found then

--      select into vreg_num value_ident from syi_sysvars_tbl 
--      where ident=''last_tax_num'';

--      if to_number(vreg_num,''0000000000'')<pnewnum then
    
--        update syi_sysvars_tbl set value_ident=Text(pnewnum) where ident=''last_tax_num'';
   
--      end if;

      if pnewnum<>0 then
        update acm_tax_tbl set reg_num = text(pnewnum)||coalesce(vnum_end,''''), int_num = pnewnum
        where id_doc = pid_tax; 
      else
        update acm_tax_tbl set reg_num = '''', int_num = pnewnum
        where id_doc = pid_tax; 
      end if;

    else
      Raise EXCEPTION ''Налоговая накладная с данным номером существует.'';
    end if;
    return true;
  end;
' LANGUAGE 'plpgsql';
