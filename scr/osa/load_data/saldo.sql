
drop function del_inf();

drop function inp_start_ind(); 
create function inp_start_ind() Returns boolean As'
Declare
dtind date;
r record;
rs boolean;
pind record;
mmgg1 date;
dtb date;
dte date;
vidk_doc int;
vid_dc int;
idres int;
begin
select into idres int4(value_ident) from syi_sysvars_tbl where ident=''id_res'';
for r in select distinct id_client
  ,date_trunc(''month'',date_mii(mmgg,-32))::date as mmgg from tmp_loadind_tbl t 
  where id_client<>idres order by id_client loop
rs:=del_eqtmp_t(0,0);
select into pind dt_indicat,coalesce(period_indicat,1),month_indicat 
   ,month_indicat-(month_indicat-case 
    when mod(month_indicat,coalesce(period_indicat,1))=0 then coalesce(period_indicat,1) 
    else mod(month_indicat,coalesce(period_indicat,1)) end) as mnth 
   from clm_statecl_tbl where id_client=r.id_client; 
  mmgg1:=date_trunc(''month'',date_mii(r.mmgg,27));
  if pind.dt_indicat is null then 
    dtind:=mmgg1;
  else 
    if pind.month_indicat=pind.mnth then
      dtind:=date_mii(mmgg1,-(pind.dt_indicat-1));
    else
      if pind.month_indicat<pind.mnth then
        dtind:=date_mii(date_trunc(''month'',date_mii(mmgg1,(pind.mnth-pind.month_indicat)*32))::date,-(pind.dt_indicat-1));  
      end if;
      if pind.month_indicat>pind.mnth then
        dtind:=date_mii(date_trunc(''month'',date_mii(mmgg1,((pind.period_indicat-pind.month_indicat)+pind.mnth)*32))::date,-(pind.dt_indicat-1));           
      end if;
    end if;
  end if;

vid_dc:=nextval(''dcm_doc_seq'');
select into vidk_doc id from dci_document_tbl where ident=''beg_ind'';

insert into acm_headindication_tbl (id_doc,dt,
         reg_date,reg_num,idk_document,id_client,date_end,mmgg)
        values(vid_dc,now(),dtind,''start'',vidk_doc,r.id_client,dtind,r.mmgg);
   
dtb:=date_mii(dtind::date,1);
dte:=dtind;
Raise Notice ''Id_cl - %'',r.id_client;
Raise Notice ''MMGG - %'',r.mmgg;
Raise Notice ''MMGG1 - %'',mmgg1;
--Raise Notice ''pind.mnth - %'',pind.mnth;
--Raise Notice ''pind.month_indicat - %'',pind.month_indicat;
--Raise Notice ''pind.period_indicat - %'',pind.period_indicat;
Raise Notice ''DTIND - %'',dtind;
rs:=oabn_tree(r.id_client,dtb,dte);
--ins
        insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
          ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp,id_previndic,value)
        select vid_dc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
          ,a.kind_energy as kind_energy,a.id_zone as id_zone,dtind as date_end
          ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
          ,a.carry as carry,a.k_tr as k_tr,null as id_previndic
          ,f.val
        from  (select a1.*,a2.carry from act_met_kndzn_tbl as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp) as a
          left join (select * from acd_indication_tbl where id_doc=vid_dc) as g
          on (a.id_meter=g.id_meter and a.num_eqp=g.num_eqp 
            and a.kind_energy=g.kind_energy and a.id_zone=g.id_zone)
         left join tmp_loadind_tbl as f on (f.num_eqp=a.num_eqp 
	      and f.id_energy=a.kind_energy)
         where g.id is null and f.id_client=r.id_client;

end loop;
Return true;
end;
' Language 'plpgsql';

drop table tmp_err_saldo_tbl;
create table tmp_err_saldo_tbl (
  id_client int,
  code_client int,
  dat_sal   date,
  energy    int,
  val       numeric,
  val_tax   numeric,
  id_pref   int,
  nam_err varchar(50)
);

alter table acm_saldo_tbl add column dat_sal date;

drop function load_saldo_fun(int,int,date,numeric,numeric);
create or replace function load_saldo_fun(int,date,int,numeric,numeric) 
returns integer As '
Declare
 pclient Alias for $1;
 pmmgg   Alias for $2;
 penergy Alias for $3;
 pval Alias for $4;
 pvaltax Alias for $5;
 vid_dc integer;
 vid_pref record;
 err int;
 namerror varchar(50);
 vid_headpay record;
 vidk_doc record;
 vclient record;
 pid_head int;
  resf numeric;
 mg date;
 vid_doc int;
begin 
select into mg (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||''-''||substr(value_ident,1,2))::date 
 from syi_sysvars_tmp where ident=''mmgg'';
 
select into vclient id from clm_client_tbl where code=pclient and book<0;
 if not found then
    Raise Notice ''Not abon %'',pclient;
    insert into tmp_err_saldo_tbl (code_client,dat_sal,energy,val,val_tax,nam_err)
    values (pclient,pmmgg,penergy,pval,pvaltax,''ÎÅÔ ÁÂÏÎÅÎÔÁ'') ;
    return 0;
 end if;

select into vid_doc id from dci_document_tbl where ident=''saldo'';
 if not found then
    Raise Exception ''Not found kind doc saldo '';
 end if;
     Raise Notice ''kind_doc %'',vid_doc;

  err=0;
  vid_dc:=nextval(''dcm_doc_seq'');
  select into vid_pref id from  aci_pref_tbl a
   where a.id = ( select min(id) from aci_pref_tbl b 
         where  kind_energy=penergy and 
         (dt_pref is null  or pmmgg>=dt_pref));  
  if not found then
    insert into tmp_err_saldo_tbl (id_client,dat_sal,energy,val,val_tax,id_pref,nam_err)
    values (vclient.id,pmmgg,penergy,pval,pvaltax,null,''ÎÅ ÎÁÊÄÅÎ ÐÒÅÆÉËÓ'') ;
    raise notice ''Problem in %'',pclient;
    return;
   end if;
  if pval<=0 then

   insert into acm_bill_tbl(id_doc,id_pref, idk_doc,
                reg_num, reg_date,
                id_client, value,value_tax, dat_b,dat_e,mmgg_bill,mmgg) 
           values 
                 (vid_dc, vid_pref.id ,
                   vid_doc, 
                 ''saldo_deb'', pmmgg, 
                 vclient.id ,-pval, -pvaltax,pmmgg,pmmgg, bom(pmmgg) ,mg);

    resf=acc_payments_bill (vid_dc);

  end if;
if pval>0 then
   --ªà¥¤¨â 
   -- á®§¤ ¤¨¬ § £®«®¢®ª ¯« â¥¦ª¨ 
  select into vid_headpay id from acm_headpay_tbl where 
                  reg_num=''saldo_kred'';
    if not found then
       select into vid_headpay nextval(''acm_headpay_seq'') as id;

     insert into acm_headpay_tbl (id,dt,reg_num,reg_date,mmgg_hpay,mmgg)
     values (vid_headpay.id,now(),''saldo_kred'',pmmgg,bom(pmmgg),mg);
     raise notice ''not head %'',vid_headpay.id;
     pid_head=vid_headpay.id;
     raise notice ''n head %'',pid_head;
   else
     pid_head=vid_headpay.id;
     raise notice ''yes head %'',pid_head;
     

 end if;
   
--  select into vidk_doc id from dci_document_tbl    where ident=''saldo'';

    insert into acm_pay_tbl (id_headpay,id_pref,reg_num,reg_date,id_client,
                            value_pay,value_tax,value,sign_pay,idk_doc,mmgg_hpay,mmgg)
    values(pid_head ,vid_pref.id,''saldo_kred'',pmmgg,vclient.id,
                            (pval+pvaltax),pvaltax, pval,1,vid_doc,bom(pmmgg),mg);
end if;
raise notice '' all '';
return 0;
end;
' Language 'plpgsql';
                                                       	