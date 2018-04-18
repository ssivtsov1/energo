alter table acd_indication_tbl alter column dt set default now();
alter table acd_indication_tbl add column dt_change timestamp;
alter table acd_indication_tbl add column dt_del timestamp;

--select * into acd_indication_del from  acd_indication_tbl limit 1;
alter table acm_headindication_tbl alter column dt set default now();

alter table acd_indication_del alter column dt_del set default now();
alter table acd_indication_del add column id_del int;

create SEQUENCE acd_indication_del_id_del_seq INCREMENT 1;
alter table acd_indication_del alter column id_del set default nextval('acd_indication_del_id_del_seq');

update acd_indication_del set id_del = nextval('acd_indication_del_id_del_seq') where id_del is null;

alter table acd_indication_del alter column id_del set not null;
alter table acd_indication_del add CONSTRAINT acd_indication_del_pkey primary key(id_del);


ALTER TABLE acd_indication_tbl ADD COLUMN last_work_ind_id integer;
ALTER TABLE acd_indication_del ADD COLUMN last_work_ind_id integer;


drop trigger indhead_del on acm_headindication_tbl;
drop function fun_indhead_del();
create function fun_indhead_del() returns opaque as'
Declare
  begin 
   if old.flock=1 then 
     raise exception ''headind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    
    delete from acm_headindication_tbl where id_main_ind=old.id_doc;
    delete from acd_indication_tbl where id_doc=old.id_doc;
  Return old;  
end;     
' Language 'plpgsql';
create trigger indhead_del
    Before Delete ON acm_headindication_tbl
    For Each Row Execute Procedure fun_indhead_del();




--drop trigger indic_del on acd_indication_tbl;
--drop function fun_indic_del();
 /*--------------------------------------------------------------*/
create or replace function fun_indic_del() returns trigger as'
Declare
bill_d int;
bill_tr date;
id_cl int;

begin

   if old.flock=1 then 
        raise exception ''ind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    


select into id_cl coalesce(h.id_client,i.id_client) from 
  acm_headindication_tbl h,acd_indication_tbl i
  where h.id_doc=i.id_doc and i.id=old.id limit 1;

RAISE NOTICE ''id_del -%'',old.id;
RAISE NOTICE ''id_cl -%'',id_cl;

insert into acd_indication_del (id, dt, id_person, id_meter, num_eqp, kind_energy, id_zone, dat_ind, 
            value, id_previndic, id_doc, id_cor_doc, dat_cor, mmgg, flock, 
            id_client, id_typemet, id_typecompa, id_typecompu, value_dem, 
            carry, value_dev, value_prev, hand_losts, id_main_ind, coef_comp, 
            id_inspect, dt_change)
(select id, dt, id_person, id_meter, num_eqp, kind_energy, id_zone, dat_ind, 
            value, id_previndic, id_doc, id_cor_doc, dat_cor, mmgg, flock, 
            id_client, id_typemet, id_typecompa, id_typecompu, value_dem, 
            carry, value_dev, value_prev, hand_losts, id_main_ind, coef_comp, 
            id_inspect, dt_change from acd_indication_tbl where id=old.id);


--update acd_indication_del set dt_del=now() where id=old.id; 

 delete from acd_inddifzone_tbl where id_doc=old.id_doc 
  and id_meter=old.id_meter and kind_energy=old.kind_energy;

  delete from acm_bill_tbl where id_ind=old.id_doc;


 update acd_indication_tbl set id_previndic=old.id_previndic  
  where id_previndic=old.id;
--RAISE NOTICE ''id_cl -%'',id_cl;
Return old;
end;
' Language 'plpgsql';

create trigger indic_del
    BEFORE Delete ON acd_indication_tbl
    For Each Row Execute Procedure fun_indic_del();

 /*--------------------------------------------------------------*/
--drop trigger indic_upd on acd_indication_tbl;
--drop function fun_indic_upd();
create or replace function fun_indic_upd() returns trigger as'
Declare
bill_d int;
bill_tr date;
id_cl int;

begin
   if (old.flock=1 and new.flock<>0) then
   --if old.flock=1 then 
     RAISE EXCEPTION ''ind_upd %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    

select into id_cl coalesce(h.id_client,i.id_client) from 
  acm_headindication_tbl h,acd_indication_tbl i
  where h.id_doc=i.id_doc and i.id=old.id limit 1;

RAISE NOTICE ''id_del -%'',old.id;
RAISE NOTICE ''id_cl -%'',id_cl;

if old.value is not null then

   insert into acd_indication_del (id, dt, id_person, id_meter, num_eqp, kind_energy, id_zone, dat_ind, 
            value, id_previndic, id_doc, id_cor_doc, dat_cor, mmgg, flock, 
            id_client, id_typemet, id_typecompa, id_typecompu, value_dem, 
            carry, value_dev, value_prev, hand_losts, id_main_ind, coef_comp, 
            id_inspect, dt_change)
  (select id, dt, id_person, id_meter, num_eqp, kind_energy, id_zone, dat_ind, 
            value, id_previndic, id_doc, id_cor_doc, dat_cor, mmgg, flock, 
            id_client, id_typemet, id_typecompa, id_typecompu, value_dem, 
            carry, value_dev, value_prev, hand_losts, id_main_ind, coef_comp, 
            id_inspect, dt_change from acd_indication_tbl where id=old.id);
-- insert into acd_indication_del 
--(select * from acd_indication_tbl where id=old.id);
-- update acd_indication_del set dt_del=now() where id=old.id; 


end if;


new.dt_change=now();

--delete from acm_bill_tbl where id_ind=old.id_doc;
Return new;
end;
' Language 'plpgsql';

create trigger indic_upd
    BEFORE update ON acd_indication_tbl
    For Each Row Execute Procedure fun_indic_upd();


drop trigger indheaddem_del on acm_headdem_tbl;
drop function fun_indheaddem_del();

create function fun_indheaddem_del() returns opaque as'
Declare
  begin 
   if old.flock=1 then
    raise exception ''head %'',old.id;
    RAISE EXCEPTION ''Closed Data.'';
   end if;    
    delete from acm_demand_tbl where id_doc=old.id_doc;
  Return old;  
end;     
' Language 'plpgsql';


create trigger indheaddem_del
    Before Delete ON acm_headdem_tbl
    For Each Row Execute Procedure fun_indheaddem_del();



drop trigger indicdem_del on acm_demand_tbl;
drop function fun_indicdem_del();
 /*--------------------------------------------------------------*/
create function fun_indicdem_del() returns opaque as'
Declare
bill_d int;
bill_tr date;
id_cl int;

begin

   if old.flock=1 then 
     raise exception ''ind %'',old.id;
     RAISE EXCEPTION ''Closed Data.'';
   end if;    

select into id_cl distinct(h.id_client) from 
  acm_headdem_tbl h,acm_demand_tbl i
  where h.id_doc=i.id_doc and i.id=old.id;

RAISE NOTICE ''id_del -%'',old.id;
RAISE NOTICE ''id_cl -%'',id_cl;

select into bill_d id_doc from acm_bill_tbl 
where id_ind=old.id_doc  and id_client=id_cl;

delete from acm_bill_tbl where id_doc=bill_d;


Return old;

end;
' Language 'plpgsql';

create trigger indicdem_del
    BEFORE Delete ON acm_demand_tbl
    For Each Row Execute Procedure fun_indicdem_del();


drop trigger saldoakt_del on acm_saldoakt_tbl;
drop trigger saldoakt_upd on acm_saldoakt_tbl;
drop function fun_saldoakt_del();
 /*--------------------------------------------------------------*/
create function fun_saldoakt_del() returns opaque as'
Declare
bill_d int;
bill_tr date;
id_cl int;

begin

   if old.flock=1 then 
     RAISE EXCEPTION ''Период закрыт (acm_saldoakt_tbl)'';
   end if;    

Return old;

end;
' Language 'plpgsql';

drop function fun_saldoakt_upd();
 /*--------------------------------------------------------------*/
create function fun_saldoakt_upd() returns opaque as'
Declare
bill_d int;
bill_tr date;
id_cl int;

begin
   raise notice ''eee'';
   if old.flock=1 then 
     RAISE EXCEPTION ''Период закрыт (acm_saldoakt_tbl)'';
   end if;    

Return new;

end;
' Language 'plpgsql';

create trigger saldoakt_del
    BEFORE Delete ON acm_saldoakt_tbl
    For Each Row Execute Procedure fun_saldoakt_del();

create trigger saldoakt_upd
    BEFORE Update ON acm_saldoakt_tbl
    For Each Row Execute Procedure fun_saldoakt_upd();
