;
set client_encoding = 'win';
-- Function: eqc_bill_addr_fun(int4, "timestamp")

-- DROP FUNCTION eqc_bill_addr_fun(int4, "timestamp");



CREATE OR REPLACE FUNCTION eqc_bill_addr_fun(integer, timestamp without time zone)
  RETURNS integer AS
$BODY$
  declare
  doc_id Alias for $1;
  dat Alias for $2;
  table_id int;
  field_id int;

  rec record;
  eqp record;
  table_name varchar;
  inst_id integer;

  begin


  delete from eqt_bill_addr_tbl where id_doc = doc_id;

  -- по полной программе
   RAISE NOTICE 'History'; 

    insert into eqt_bill_addr_tbl(id_doc,code_eqp,addr_eqp,name_eqp,code_eqp_inst,name_eqp_inst,addr_eqp_inst)
    select doc_id,eq.id,eq.id_addres,eq.name_eqp
    ,null,null,null --,area.code_eqp_inst,area.name_eqp, area.id_addres
    from 
    (
     select eq1.id,eq1.name_eqp,eq1.id_addres from eqm_equipment_h as eq1  join  
     (select id,max(dt_b) as maxdt from acd_point_branch_tbl as pb 
        join eqm_equipment_h   on (eqm_equipment_h.id=pb.id_point)
      where pb.id_doc = doc_id and dt_b <= dat group by id ) as sdt1 on (sdt1.id = eq1.id and sdt1.maxdt = eq1.dt_b)
    order by eq1.id) as eq;
/*
    left join 
    (
     select sci.code_eqp, sci.code_eqp_inst, null as name_eqp,null as id_addres
     from 
     ( select sci2.code_eqp, sci2.code_eqp_inst from eqm_compens_station_inst_h as sci2  join 
      ( select code_eqp, code_eqp_inst,max(dt_b) as maxdt from  eqm_compens_station_inst_h where dt_b <= dat 
        and ((dt_e>=dat) or (dt_e is null)) group by code_eqp, code_eqp_inst) as sdt2 
        on (sdt2.code_eqp = sci2.code_eqp and sdt2.code_eqp_inst = sci2.code_eqp_inst and sdt2.maxdt = sci2.dt_b)
     order by code_eqp_inst) as sci 
      join 
     (
      select eq3.id,eq3.name_eqp,eq3.id_addres from eqm_equipment_h as eq3 join  
      (select id,max(dt_b) as maxdt from eqm_equipment_h where type_eqp = 11 and dt_b <= dat group by id ) as sdt3 
        on (sdt3.id = eq3.id and sdt3.maxdt = eq3.dt_b) order by id
     ) as eq2  on (sci.code_eqp_inst=eq2.id)
    order by sci.code_eqp 
    ) as area on (area.code_eqp=eq.id)
    ;
*/

RAISE NOTICE 'Update'; 


update eqt_bill_addr_tbl set code_eqp_inst = sci2.code_eqp_inst, name_eqp_inst = eq3.name_eqp, addr_eqp_inst = eq3.id_addres
from 
     eqm_compens_station_inst_h as sci2 
     join eqm_equipment_h as eq3 on (sci2.code_eqp_inst = eq3.id )
     join 
      ( select code_eqp, code_eqp_inst,max(dt_b) as maxdt from  eqm_compens_station_inst_h where dt_b <= dat 
        and ((dt_e>=dat) or (dt_e is null)) group by code_eqp, code_eqp_inst order by code_eqp, code_eqp_inst) as sdt2 
        on (sdt2.code_eqp = sci2.code_eqp and sdt2.code_eqp_inst = sci2.code_eqp_inst and sdt2.maxdt = sci2.dt_b)
     join 
       (select id,max(dt_b) as maxdt from eqm_equipment_h where type_eqp = 11 and dt_b <= dat group by id order by id
        ) as sdt3  on (sdt3.id = eq3.id and sdt3.maxdt = eq3.dt_b) 
     where eqt_bill_addr_tbl.code_eqp = sci2.code_eqp;



raise notice 'all1';
update eqt_bill_addr_tbl set full_adr=a.adr from adv_address_tbl as a 
 where eqt_bill_addr_tbl.addr_eqp=a.id and eqt_bill_addr_tbl.id_doc = doc_id;  
raise notice 'all_all';
  RETURN 0;
  end;$BODY$
  LANGUAGE plpgsql VOLATILE;

