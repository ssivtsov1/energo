--drop function eqm_set_use_fun(int,int,date);
-- расстановка записей об использовании оборудвания одного обонента (РЕС)
-- в расчетах другого обонента в eqm_eqp_use_tbl 
-- от указанного узла вниз по дереву
create or replace function eqm_set_use_fun(int,int,int,date) Returns boolean As'
Declare
--idpnt Alias for $1;
pidp Alias for $1;
pclient Alias for $2;
powner Alias for $3;
pdate Alias for $4;

v int;
r record;
rs boolean;
begin

 for r in  select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq ,eqm_tree_tbl as et
 where  eq.id = eqt.code_eqp  and et.id=eqt.id_tree and
 code_eqp_e=pidp and et.id_client=powner and eqt.line_no =0 loop


--     RAISE NOTICE ''set''; 
     select into v id_client from eqm_eqp_use_tbl
     where code_eqp = r.code_eqp limit 1;

     if not found then
 
      insert into eqm_eqp_use_tbl(code_eqp,id_client,dt_install) values
      (r.code_eqp,pclient,pdate);
     end if;

     rs:=eqm_set_use_fun(r.code_eqp,pclient,powner,pdate);

 end loop;
 RETURN True;
end;
' Language 'plpgsql';


----------------------------------------------------------------------------
-- расстановка записей об принадлежности оборудования фидеру
-- от указанного узла вниз по дереву
create or replace function eqm_set_inst_fun(int,int,int) Returns boolean As'
Declare
--idpnt Alias for $1;
pidp Alias for $1;
pfider Alias for $2;
powner Alias for $3;
--pdate Alias for $4;

v int;
r record;
rs boolean;
begin

 for r in  select * from eqm_eqp_tree_tbl as eqt , eqm_equipment_tbl as eq ,eqm_tree_tbl as et
  where  eq.id = eqt.code_eqp  and et.id=eqt.id_tree and
  code_eqp_e=pidp and et.id_client=powner and eqt.line_no =0 
  and eq.type_eqp <> 9 and not exists (select code_eqp from eqm_eqp_use_tbl where code_eqp = eq.id )
 loop

/*
--     RAISE NOTICE ''set''; 
     select into v code_eqp_inst from eqm_compens_station_inst_tbl
     where code_eqp = r.code_eqp limit 1;

     if not found then
      -- оборудование не имеет фидеров/площадок, ставим
      insert into eqm_compens_station_inst_tbl(code_eqp,code_eqp_inst) values
      (r.code_eqp,pfider);

     else

       EXIT  WHEN (v<>pfider); --имеет другой - завершаем, тот же - просто идем дальше

     end if;
     rs:=eqm_set_inst_fun(r.code_eqp,pfider,powner);
*/

     select into v code_eqp_inst from eqm_compens_station_inst_tbl
     where code_eqp = r.code_eqp limit 1;

     if not found then
      -- оборудование не имеет фидеров/площадок, ставим
      insert into eqm_compens_station_inst_tbl(code_eqp,code_eqp_inst) values
      (r.code_eqp,pfider);

       rs:=eqm_set_inst_fun(r.code_eqp,pfider,powner);

     else

       if (v=pfider) then
           rs:=eqm_set_inst_fun(r.code_eqp,pfider,powner);
       else
          RAISE NOTICE '' EXIT  WHEN (v<>pfider) ''; 
       end if;
       
       --EXIT  WHEN (v<>pfider); --имеет другой - завершаем, тот же - просто идем дальше

     end if;

 end loop;
 RETURN True;
end;
' Language 'plpgsql';
