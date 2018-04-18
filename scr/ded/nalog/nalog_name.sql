--update clm_client_tbl set idk_work = 1 where book = -1 and code <> 999 and code <>1000000;

--alter table acm_tax_tbl add column auto int;
--alter table acm_tax_tbl add column pay_p int;

--alter table acm_taxcorrection_tbl add column kind_calc int;
--alter table acm_taxcorrection_tbl alter column kind_calc set default 1;

--alter table acm_taxcorrection_tbl add column reason varchar(200);
--alter table acm_taxcorrection_tbl drop column tax_num;           
--alter table acm_taxcorrection_tbl add column tax_num varchar(25);           
--alter table acm_taxcorrection_tbl add column tax_date date;         

--alter table acm_billtax_tbl add column source int;
--alter table acm_billtax_tbl alter column source set default 0;

--alter table acm_billtax_tbl add column zone_koef numeric(14,4);
--alter table acm_billtax_tbl alter column zone_koef set default 1;

--alter table acm_billtax_tbl add column tariff numeric(14,4);

--update acm_billtax_tbl set tariff = value
--from acd_tarif_tbl where id = acm_billtax_tbl.id_sumtariff;


--alter table acd_taxcorrection_tbl add column demand int;           
--alter table acd_taxcorrection_tbl add column cor_tariff numeric(14,4);           

--select altr_colmn('acd_tax_tbl','text','varchar(100)');

--update clm_statecl_tbl set flag_budjet = 1 where id_section in (211,213,214,215,206,207);

--update clm_statecl_tbl set flag_taxpay = 0 where tax_num = 0 ;

--update acm_taxcorrection_tbl set reason = 'Змiна вартiсних показникiв',
--tax_num = t.reg_num, tax_date=t.reg_date
--from acm_tax_tbl as t where t.id_doc = acm_taxcorrection_tbl.id_tax and acm_taxcorrection_tbl.tax_num is null;


--update acm_billtax_tbl set zone_koef =1 where zone_koef is null;
alter table acm_tax_tbl add column flag_transmis int;
alter table acm_taxcorrection_tbl add column flag_transmis int;

ALTER TABLE acm_taxcorrection_tbl ADD COLUMN pay_date date;

CREATE TABLE acm_tax_del
(
  id_doc int4 ,
  dt timestamp ,
  id_person int4 ,
  id_pref int4,
  kind_calc int4,
  budget int4,
  reg_num varchar(25),
  reg_date date,
  id_client int4,
  value numeric(14,4),
  value_tax numeric(14,4),
  id_bill int4,
  mmgg date ,
  flock int4 ,
  int_num int4,
  auto int4,
  pay_p int4,
  flag_transmis int,
  dt_del timestamp DEFAULT now(),
  del_person int4 DEFAULT getsysvar('id_person'::character varying)
);

-- добавить поле flag_reg - Включено до ╫РПН

ALTER TABLE acm_tax_tbl ADD COLUMN flag_reg integer;

ALTER TABLE acm_tax_del ADD COLUMN flag_reg integer;

ALTER TABLE acm_tax_del ADD COLUMN dt_del1 timestamp without time zone;
ALTER TABLE acm_tax_del ALTER COLUMN dt_del1 SET DEFAULT now();

ALTER TABLE acm_tax_del ADD COLUMN del_person1 integer;
ALTER TABLE acm_tax_del ALTER COLUMN del_person1 SET DEFAULT getsysvar('id_person'::character varying);

update acm_tax_del set dt_del1 = dt_del;
update acm_tax_del set del_person1 = del_person;


ALTER TABLE acm_tax_del drop COLUMN dt_del;
ALTER TABLE acm_tax_del drop COLUMN del_person;

ALTER TABLE acm_tax_del RENAME COLUMN dt_del1 to dt_del;
ALTER TABLE acm_tax_del RENAME COLUMN del_person1 to del_person;
-----------------------------------------------------------------

--создание спец.абонента для сводной налоговой для неплательщиков НДС
CREATE OR REPLACE FUNCTION crt_taxnotpay_abon()
  RETURNS integer AS
$BODY$
Declare
 vid int;
begin

select into vid id from clm_client_tbl where code = 1000001;
if found then 
  return 0;
end if;

INSERT INTO clm_client_tbl(code, book, dt, id_department, name, short_name, idk_work, id_addres, 
            id_state, code_okpo, flag_balance )
    VALUES (1000001,-1,now(),syi_resid_fun(),'Кiнцевий споживач неплатник податку','Кiнцевий споживач неплатник податку',0,null,60,'',0);

Insert into clm_statecl_tbl (id_client,flag_taxpay,flag_jur)
values(currval('clm_client_seq'),0,1);

insert into syi_sysvars_tbl(ident,type_ident,value_ident) values('id_abon_taxn','int',currval('clm_client_seq')); 

Return 1; 
end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;



select crt_taxnotpay_abon();

drop FUNCTION crt_taxnotpay_abon();





--------------------------------------------------------------------------------
create or replace function syi_setsysvar_fun(varchar,varchar,int) returns int as ' 
  declare 
     pident alias for $1;
     ptype_ident alias for $2;
     pvalue_ident alias for $3;

     v record;
begin

  select * into v from syi_sysvars_tbl where ident = pident;
  if not found then

   insert into syi_sysvars_tbl(ident,type_ident,value_ident) values(pident,ptype_ident,pvalue_ident); 
   return 1;

  else

   update syi_sysvars_tbl set value_ident = pvalue_ident where ident = pident;
   return 0;

  end if;

  end;
' LANGUAGE 'plpgsql';


