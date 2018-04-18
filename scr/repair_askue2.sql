select crt_ttbl();

--select *  from acm_headpowerindication_tbl where bom(reg_date::date)<>mmgg ; 

update acm_headpowerindication_tbl set mmgg=bom(reg_date::date)  
where bom(reg_date::date)<>mmgg and reg_num like 'ask%'; 

update acd_powerindication_tbl set mmgg=bom(time_indic::date) where bom(time_indic::date)<>mmgg;

create or replace function calc_all_powerdemand(date)
  RETURNS bool                                                                                     
  AS                                                                                              
$BODY$
  declare
  pmmgg alias for $1;
cou_h int;
  rec record;

  ret boolean;
begin  
for rec in select distinct id_doc,id_client,mmgg from acm_headpowerindication_tbl where mmgg=pmmgg  loop
  cou_h=crt_pwr2krbill(rec.id_client, rec.id_doc,rec.mmgg);
end loop;
RETURN true;
end;
$BODY$                                                                                          
LANGUAGE 'plpgsql';  

select calc_all_powerdemand('2014-09-01');
select calc_all_powerdemand('2014-10-01');