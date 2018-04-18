CREATE OR REPLACE FUNCTION seb_bill_del(date)
  RETURNS boolean AS
$BODY$
declare 
 pmmgg alias for $1;
 kodres int;
existt boolean;
 tabl varchar;
 del varchar; 
 nul varchar;
 SQL text;
begin
 select value_ident into kodres from syi_sysvars_tbl where ident='kod_res'; 
 if found then  

 tabl='/home/local/seb/'||kodres||'bill_del.TXT';
 del=';'; nul='';

SQL='copy  (
select c.kind_dep, pr.name as vid_bill, b.reg_num, b.reg_date, b.demand_val, b.value, b.value_tax, (b.value + b.value_tax) as snds, d.name as doc_type, b.mmgg, b.mmgg_bill, b.id_doc, p.represent_name 
from acm_bill_del b
left join clm_client_tbl c on c.id = b.id_client
left join dci_document_tbl d on d.id = b.idk_doc
left join aci_pref_tbl pr on pr.id = b.id_pref
left join ( select p.id as id_person, max(u.id), 
     p.represent_name from syi_user u 
     left join clm_position_tbl as p on p.id = u.id_person 
     where flag_type = 0 and u.id_person is not null and p.id is not null  
     group by p.id, p.represent_name
     order by p.represent_name) p on p.id_person = b.id_person 
where b.mmgg = ''' || pmmgg || '''
) to '||quote_literal(tabl)||' with delimiter as '||quote_literal(del)||' null as '|| quote_literal(nul);

 raise notice '%',SQL;
Execute SQL;

 return true;
else
  raise exception 'Not found kod_res in SYSVARS';
  return false;
end if;
end $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION seb_bill_del(date) OWNER TO "local";