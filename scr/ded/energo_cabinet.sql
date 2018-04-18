ALTER TABLE clm_statecl_tbl ADD COLUMN fl_cabinet int;
ALTER TABLE clm_statecl_h ADD COLUMN fl_cabinet int;


ALTER TABLE clm_statecl_tbl ADD COLUMN date_digital date;
ALTER TABLE clm_statecl_h ADD COLUMN date_digital date;





CREATE OR REPLACE FUNCTION fun_statecl_upd()
  RETURNS trigger AS
$BODY$
Declare
stath record;
isnew int;
mg date;
begin
mg=fun_mmgg();
isnew=1;
raise notice 'upd- %',new.id_client;
delete from clm_statecl_h    
where id_client=new.id_client and id=new.id  and mmgg_b>mg and mmgg_e is null;

update  clm_statecl_h set mmgg_e=null   
where id_client=new.id_client and id=new.id  and mmgg_b>mg;

for stath in select * from clm_statecl_h 
  where id_client=new.id_client and id=new.id  and mmgg_e is null loop
if stath.mmgg_b=mg then
 update clm_statecl_h set  tax_num=new.tax_num,flag_taxpay=new.flag_taxpay, e_mail = new.e_mail,
           licens_num=new.licens_num,okpo_num=new.okpo_num, doc_num=new.doc_num,doc_dat=new.doc_dat,
 id_budjet=new.id_budjet,id_kwed=new.id_kwed,id_taxprop=new.id_taxprop,
 doc_ground=new.doc_ground,id_position=new.id_position,id_kur=new.id_kur,flag_reactive=new.flag_reactive,dt_end_rent=new.dt_end_rent,
 period_indicat=new.period_indicat,dt_indicat=new.dt_indicat,month_indicat=new.month_indicat,dt_start=new.dt_start,month_control=new.month_control,
 day_pay_bill=new.day_pay_bill,type_pay=new.type_pay,pre_pay_grn=new.pre_pay_grn,
 pre_pay_day1=new.pre_pay_day1,pre_pay_perc1=new.pre_pay_perc1,
 pre_pay_day2=new.pre_pay_day2,pre_pay_perc2=new.pre_pay_perc2,
 pre_pay_day3=new.pre_pay_day3,pre_pay_perc3=new.pre_pay_perc3,
 type_peni=new.type_peni,count_peni=new.count_peni, flag_budjet=new.flag_budjet,
 phone=new.phone,flag_hlosts=new.flag_hlosts,flag_key=new.flag_key,
 id_section=new.id_section,id_fld_industr=new.id_fld_industr,id_grp_industr=new.id_grp_industr,
id_depart=new.id_depart,
for_undef=new.for_undef,addr_main=new.addr_main,addr_tax=new.addr_tax, addr_local=new.addr_local,
 flag_bank_day=new.flag_bank_day , flag_del2kr = new.flag_del2kr,
 tr_doc_num = new.tr_doc_num,tr_doc_date=new.tr_doc_date,tr_year_price=new.tr_year_price,tr_doc_type = new.tr_doc_type,tr_doc_period = new.tr_doc_period,
 doc_num_tend = new.doc_num_tend,doc_dat_tend=new.doc_dat_tend,flag_ed=new.flag_ed,flag_jur=new.flag_jur, filial_num = new.filial_num, 
 fl_cabinet = new.fl_cabinet,  date_digital = new.date_digital
 where id=new.id and id_client=new.id_client and mmgg_b=mg and mmgg_e is null;

else 

update clm_statecl_h set mmgg_e=mg where id=new.id and id_client=new.id_client and mmgg_e is null;

end if;
--isnew=0;
end loop;

for stath in select * from clm_statecl_h 
  where id_client=new.id_client and id=new.id and mmgg_b=mg  loop
   isnew=0;
end loop;

if isnew=1 then
raise notice 'ins- %',new.id_client;
insert into clm_statecl_h ( id,id_client,tax_num,flag_taxpay,filial_num,   
     licens_num,okpo_num, doc_num,doc_dat,doc_ground, 
     id_budjet,id_kwed,id_taxprop,id_position,id_kur,flag_reactive,dt_end_rent,flag_budjet, 
     period_indicat,dt_indicat,month_indicat,dt_start,day_pay_bill,type_pay,month_control, 
     pre_pay_grn,pre_pay_day1,pre_pay_perc1,pre_pay_day2,pre_pay_perc2,pre_pay_day3,pre_pay_perc3, 
     type_peni,count_peni,phone,flag_hlosts,
     id_section,id_fld_industr,id_grp_industr,id_depart,for_undef,addr_main,addr_tax,addr_local, flag_key,dt,
     flag_bank_day, flag_del2kr, tr_doc_num,tr_doc_date,tr_year_price,tr_doc_type,tr_doc_period,
      doc_num_tend,doc_dat_tend, flag_ed,flag_jur,mmgg_b, e_mail, fl_cabinet, date_digital ) 
      values (new.id,new.id_client,new.tax_num,new.flag_taxpay,new.filial_num,   
      new.licens_num,new.okpo_num,new.doc_num,new.doc_dat,new.doc_ground,  
     new.id_budjet,new.id_kwed,new.id_taxprop,new.id_position,new.id_kur,new.flag_reactive,new.dt_end_rent,new.flag_budjet, 
     new.period_indicat,new.dt_indicat,new.month_indicat,new.dt_start,new.day_pay_bill,new.type_pay,new.month_control, 
     new.pre_pay_grn,new.pre_pay_day1,new.pre_pay_perc1,new.pre_pay_day2,new.pre_pay_perc2,new.pre_pay_day3,new.pre_pay_perc3, 
     new.type_peni,new.count_peni,new.phone,new.flag_hlosts,
     new.id_section,new.id_fld_industr,new.id_grp_industr,new.id_depart,new.for_undef,new.addr_main,new.addr_tax,new.addr_local, new.flag_key, now(),
    new.flag_bank_day,new.flag_del2kr, new.tr_doc_num,new.tr_doc_date,new.tr_year_price,new.tr_doc_type,new.tr_doc_period,
new.doc_num_tend,new.doc_dat_tend,new.flag_ed,new.flag_jur,mg, new.e_mail, new.fl_cabinet, new.date_digital); 
end if;
 
Return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE  ;