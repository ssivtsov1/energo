ALTER TABLE eqi_meter_tbl ADD COLUMN dt timestamp without time zone;
ALTER TABLE eqi_meter_tbl ALTER COLUMN dt SET DEFAULT now();

ALTER TABLE eqi_meter_tbl ADD COLUMN id_user integer;
ALTER TABLE eqi_meter_tbl ALTER COLUMN id_user SET DEFAULT getsysvar('last_user'::character varying);

delete from eqi_meter_tbl where id > 999999 and id not in (1000005,1000004,1000015,1000024,1000054);
