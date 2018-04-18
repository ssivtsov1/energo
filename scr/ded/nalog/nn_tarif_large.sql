drop view acv_taxadvtariff ;
UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'acd_tax_tbl';

select altr_colmn('acd_tax_tbl','tariff','numeric(18,10)');
select altr_colmn('acd_tax_del','tariff','numeric(18,10)');

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'acd_tax_tbl';

ALTER TABLE acm_tax_tbl ADD COLUMN xml_num integer;

ALTER TABLE acm_taxcorrection_tbl ADD COLUMN flag_reg integer;
ALTER TABLE acm_taxcorrection_tbl ADD COLUMN xml_num integer;