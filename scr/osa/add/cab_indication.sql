;;


CREATE TABLE acd_cabindication_tbl
(
  id bigint NOT NULL DEFAULT nextval(('acd_cabindication_seq'::text)::regclass),
  id_client integer NOT NULL,
  id_meter integer NOT NULL,
  id_previndic integer NOT NULL,
  id_zone integer DEFAULT 0,
  id_meter_type integer NOT NULL,
  kind_energy integer NOT NULL,
  mmgg date,
  num_eqp character varying(25),
  koef integer,
  kind_energy_name character varying(25),
  zone_name character varying(25),
  meter_type_name character varying(40),
  carry integer,
  dat_ind date,
  value_prev numeric(14,4),
  value_ind numeric(14,4),
  calc_ind_pr numeric(14,4),
  now timestamp without time zone DEFAULT now(),
  koef_i integer,
  koef_u integer,
  CONSTRAINT acd_cabindication_tbl_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE acd_cabindication_tbl
  OWNER TO postgres;

-- Index: acd_cabindication_cl_idx

-- DROP INDEX acd_cabindication_cl_idx;

CREATE INDEX acd_cabindication_cl_idx
  ON acd_cabindication_tbl
  USING btree
  (id_client);

CREATE TABLE acd_cabfeedback_tbl
(
  id bigserial NOT NULL,
  id_client integer NOT NULL,
  email character varying(80),
  feedback text,
  now timestamp without time zone DEFAULT now(),
  CONSTRAINT acd_cabfeedback_tbl_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE acd_cabfeedback_tbl
  OWNER TO local;
COMMENT ON TABLE acd_cabfeedback_tbl
  IS 'created by Oleg';

CREATE TABLE acd_cab_upload_tbl
(
  id serial NOT NULL,
  id_client integer NOT NULL,
  code integer NOT NULL,
  filename character varying(80) NOT NULL,
  mmgg date DEFAULT fun_mmgg(),
  note text,
  act integer DEFAULT 0,
  now timestamp without time zone DEFAULT now(),
  CONSTRAINT acd_cab_upload_tbl_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE acd_cab_upload_tbl
  OWNER TO local;
COMMENT ON TABLE acd_cab_upload_tbl
  IS 'created by Oleg';


-- Index: acd_cabindication_met_idx

-- DROP INDEX acd_cabindication_met_idx;

CREATE INDEX acd_cabindication_met_idx
  ON acd_cabindication_tbl
  USING btree
  (id_meter);



CREATE INDEX acd_cabindication_cl_idx
  ON acd_cabindication_tbl
  USING btree
  (id_client);

  
CREATE INDEX acd_cabindication_met_idx
  ON acd_cabindication_tbl
  USING btree
  (id_meter);

  alter table acd_indication_tbl add column id_cabinet int;
   alter table acd_indication_del add column id_cabinet int; 


CREATE OR REPLACE FUNCTION  clc_cabinet_upd(int,int)   RETURNS int AS
$BODY$
declare
doc alias for $1; 
flag alias for $2; 
begin
if flag=1 then
update acd_indication_tbl set value=c.value_ind from acd_cabindication_tbl c 
 where id_cabinet=c.id and id_doc=doc;
 else
 update acd_indication_tbl set value=c.value_ind from acd_cabindication_tbl c 
 where  id_cabinet=c.id and  id_doc=doc and (acd_indication_tbl.value is null );

end if; 

update acd_indication_tbl set value_dev= calc_ind_pr(acd_indication_tbl.value,p.value,acd_indication_tbl.carry) ,
 value_dem=calc_ind_pr(acd_indication_tbl.value,p.value,acd_indication_tbl.carry)* acd_indication_tbl.coef_comp
from acd_indication_tbl p 
 where p.id=acd_indication_tbl.id_previndic and acd_indication_tbl.id_doc=doc;
 
 
return 1;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 /*

 update acd_indication_tbl set id = 1614023, dt = '2016-01-28 13:37:02', id_person = NULL, id_meter = 1084786, num_eqp = '0037837', kind_energy = 1, id_zone = 0, dat_ind = '2016-01-29', value = 150, id_previndic = 1613332, id_doc = 2318909, id_cor_doc = NULL, dat_cor = NULL, mmgg = '2016-01-01', flock = 0, id_client = 2551, id_typemet = 5032, id_typecompa = NULL, id_typecompu = NULL, value_dem = 1920, carry = 5, value_dev = 48, value_prev = NULL, hand_losts = NULL, id_main_ind = NULL, coef_comp = 40, id_inspect = 992574, dt_change = '2016-01-28 13:37:02', dt_del = NULL, last_work_ind_id = 89240, indic_edit_enabled = 1, id_askue = NULL, id_cabinet = 1, cab_value = 201, cab_dev = 99, cab_dem = 3960 where id = 1614023 

 select distinct i.*,e.name_eqp as name_met,mm.nm as nm,p.value as before_value, p.dat_ind as dat_prev, cab.value as cab_value,
  calc_ind_pr(cab.value,p.value,i.carry) as cab_dev, calc_ind_pr(cab.value,p.value,i.carry)*i.coef_comp as cab_dem, p_insp.value as kontrol_ind,p_insp.dt_insp,
   wi.value as work_ind, w.dt_work, wt.name as worktype from (select i.* from 
    (select * from acm_headindication_tbl where id_client=2477 order by id_doc ) as h
     join ( select i.* from acd_indication_tbl i where i.id_client=2477 order by id_doc ) as i on (h.id_doc=i.id_doc) ) as i 
     left join acd_indication_tbl as p on (p.id=i.id_previndic ) join eqm_equipment_h e on (i.id_meter=e.id and i.num_eqp=e.num_eqp and i.dat_ind>=e.dt_b 
     and (i.dat_ind<=e.dt_e or e.dt_e is null ) ) 
     left join eqm_meter_h mm on (i.id_meter=mm.code_eqp and ((( mm.dt_b < i.dat_ind ) and (mm.dt_e is null or mm.dt_e > i.dat_ind )) or (( mm.dt_b = i.dat_ind ) 
     and i.id_previndic is null ) or (( mm.dt_e = i.dat_ind )and i.id_previndic is not null ) ) )
      left join acm_inspectstr_tbl as p_insp on (p_insp.id=i.id_inspect ) 
      left join acd_cabindication_tbl as cab on (cab.id=i.id_cabinet ) left join clm_work_indications_tbl as wi on (wi.id = i.last_work_ind_id ) left join clm_works_tbl as w on (w.id = wi.id_work) left join cli_works_tbl as wt on (wt.id = w.id_type) WHERE i.mmgg >= '2015-01-01' order by i.id_doc,i.num_eqp,i.kind_energy,i.id_zone
*/
/*
--select * from acd_cabindication_tbl

update  acd_cabindication_tbl set dat_ind='2016-01-29'
-- select code from clm_client_tbl where id=2551

select * from acm_headindication_tbl where id_client=2551

update acd_indication_tbl set id_cabinet=c.id from acd_cabindication_tbl c 
 where acd_indication_tbl.mmgg=c.mmgg and acd_indication_tbl.id_client=c.id_client 
       and acd_indication_tbl.id_meter=c.id_meter and acd_indication_tbl.id_zone=c.id_zone
 and acd_indication_tbl.id_doc=2318902
   and (acd_indication_tbl.dat_ind=c.dat_ind or c.dat_ind is null);



 select clc_cabinet_upd(2318908,0)

 select * from acd_indication_tbl where id_doc>2318904
*/