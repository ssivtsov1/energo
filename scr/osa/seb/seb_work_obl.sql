;;

CREATE OR REPLACE FUNCTION seb_work_obl(date)
  RETURNS bool AS
$BODY$
declare 
pdt alias for $1;
  kodres int;
  path_export text;
  flag_export varchar;
  tabl varchar;
  del varchar; 
  nul varchar;
  SQL text;
  ret boolean;

pr boolean;                                   
begin
raise notice 'start   seb_work_obl';
 select into path_export value_ident from syi_sysvars_tbl where ident='path_exp';
  if path_export is null then
     path_export='/home/local/seb/';
  end if;


select value_ident into kodres from syi_sysvars_tbl where ident='kod_res'; 


insert into seb_work_obl_tmp (kod_res,dt,
       id_ps35,name_ps35,id_f10,name_f10,id_ps10,name_ps10,code,id_point,name_eqp,adr,
       work,dt_work,represent_name,
       requirement_text,requirement_date,  fider_inspector,comment) 
select kind_dep,pdt,
       code_ps35,name_ps35,code_f10,name_f10,code_ps10,name_ps10, code,id_point,name_eqp,adr,
       work,dt_work,represent_name,
       requirement_text,requirement_date,  fider_inspector,comment 
from   
(select ssss.*, cp2.represent_name as fider_inspector, 
case when ssss.id_voltage in (1,2) and type_eqp = 8 then ssss.code_eqp 
     when ssss.id_voltage2 in (1,2) and type_eqp2 = 8 then code_eqp2 
     when ssss.id_voltage3 in (1,2) and type_eqp3 = 8 then code_eqp3 
     when ssss.id_voltage4 in (1,2) and type_eqp4 = 8 then code_eqp4 END as code_ps35, 
case when ssss.id_voltage in (1,2) and type_eqp = 8 then grpname 
     when ssss.id_voltage2 in (1,2) and type_eqp2 = 8 then grpname2 
     when ssss.id_voltage3 in (1,2) and type_eqp3 = 8 then grpname3 
     when ssss.id_voltage4 in (1,2) and type_eqp4 = 8 then grpname4 END as name_ps35, 
case when ssss.id_voltage in (3,31,32) and type_eqp = 15 then ssss.code_eqp 
     when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
     when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 
     when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 15 then code_eqp4 END as code_f10, 
case when ssss.id_voltage in (3,31,32) and type_eqp = 15 then grpname 
     when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 15 then grpname2 
     when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 15 then grpname3 
     when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 15 then grpname4 END as name_f10, 
case when ssss.id_voltage in (3,31,32) and type_eqp = 8 then ssss.code_eqp 
     when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 8 then code_eqp2 
     when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 8 then code_eqp3 
     when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 8 then code_eqp4 END as code_ps10, 
case when ssss.id_voltage in (3,31,32) and type_eqp = 8 then grpname 
     when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 8 then grpname2 
     when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 8 then grpname3 
     when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 8 then grpname4 END as name_ps10 
from 
( 
  select sss.*, ee.name_eqp as grpname , 
  gr1.type_eqp, gr1.code_eqp, gr1.id_voltage , 
  gr2.type_eqp as type_eqp2, gr2.code_eqp as code_eqp2, gr2.id_voltage as id_voltage2, 
  gr3.type_eqp as type_eqp3, gr3.code_eqp as code_eqp3, gr3.id_voltage as id_voltage3, 
  gr4.type_eqp as type_eqp4, gr4.code_eqp as code_eqp4, gr4.id_voltage as id_voltage4, 
  ee2.name_eqp as grpname2,ee3.name_eqp as grpname3,ee4.name_eqp as grpname4 
  from (  select w.*,c.kind_dep,c.code, c.short_name, p.name_eqp, adr.adr::varchar ,wi.name as work, represent_name, ba.id_grp  
    from clm_works_tbl as w 
    join clm_client_tbl as c on (c.id =w.id_client) 
    join eqm_equipment_tbl as p on (w.id_point = p.id ) 
    join bal_abons_tbl as ba on (ba.id_point = w.id_point) 
    join cli_works_tbl as wi on (w.id_type = wi.id ) 
    left join ( 
      select id_client, id_point, max(requirement_ok_date) as max_ok_dt 
      from clm_works_tbl 
      where requirement_date is not null 
      and requirement_ok_date is not null 
      group by id_client, id_point 
    ) as ok on (ok.id_client = w.id_client and ok.id_point = w.id_point) 
    left join clm_position_tbl as cp on (w.id_position = cp.id ) 
    left join adv_address_tbl as adr on (adr.id = p.id_addres ) 
    where w.requirement_date is not null and w.requirement_ok_date is null 
    and w.dt_work >=coalesce(ok.max_ok_dt,w.dt_work) 
    order by c.code, p.name_eqp, w.requirement_date 
   )as sss 
  left join eqm_equipment_tbl as ee on (ee.id = sss.id_grp) 
  left join bal_grp_tree_tbl as gr1 on (gr1.code_eqp = sss.id_grp and gr1.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) 
  left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) 
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) 
  left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) 
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) 
  left join bal_grp_tree_tbl as gr4 on (gr3.id_p_eqp = gr4.code_eqp and gr4.mmgg= (select max(mmgg) from bal_grp_tree_tbl)) 
  left join eqm_equipment_tbl as ee4 on (ee4.id = gr4.code_eqp) 
  ) as ssss 
  left join eqm_fider_tbl as ff on (ff.code_eqp = case when ssss.id_voltage in (3,31,32) and type_eqp = 15 then ssss.code_eqp 
     when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
     when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 
     when ssss.id_voltage4 in (3,31,32) and type_eqp4 = 15 then code_eqp4 END) 
  left join clm_position_tbl as cp2 on (cp2.id = ff.id_position) 
  order by name_ps35, name_f10, name_ps10, code, name_eqp, requirement_date
) ft;

raise notice 'seb_work';
 tabl=path_export||kodres||'term.txt';
 del='@'; nul='';
select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export=''1'' then
  

 SQL='copy seb_work_obl_tmp
 to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul);
 select into flag_export value_ident from syi_sysvars_tbl where ident='flag_exp';
  if flag_export is null or flag_export='1' then
    -- raise notice ' ======== Copy Sql  ======  %',SQL;
--     Execute SQL;
  end if;

end if;




return true;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION seb_work_obl(date) OWNER TO "local";

