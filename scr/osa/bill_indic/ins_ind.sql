

drop function ins_indchange(int,date,varchar);

create function ins_indchange(int,date,varchar) Returns boolean As'
Declare

idcl Alias for $1;
dtchange Alias for $2;
kindrep  Alias for $3;
id_kindrep int;
rep record; 
id_headdoc int;
id_ind int;
id_newind int;
begin

select into id_kindrep b.id from  dci_document_tbl b  where  b.ident=kindrep;

if not found then
 Raise exception ''Not found report -- % '',kindrep;
 return false;
end if;

select into rep h.* ,b.ident from acm_headindication_tbl as h left join 
           dci_document_tbl as b on (h.idk_document=b.id)
        where   b.ident=kindrep  and h.reg_num=''ch_meter'' and 
                h.reg_date=eom(dtchange);  

if not found then

     --raise notice ''1'';
     
     insert into acm_headindication_tbl 
        (reg_num,reg_date,idk_document,mmgg,
         flag_priv,date_begin,date_end)
         values (''ch_meter'',eom(dtchange),id_kindrep,fun_mmgg(),
         true,bom(dtchange), eom(dtchange) );
         
         id_headdoc=currval(''dcm_doc_seq'');
   
        raise notice ''insert headreport --  yes'';
  else
    id_headdoc=rep.id_doc;
    raise notice ''found headreport --  yes'';
  end if;

    insert into acd_indication_tbl
      (id_doc,id_meter,num_eqp,kind_energy,id_zone
        ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp)

    select id_headdoc as id_doc, his.id_eqp as id_meter, his.num_eqp as num_eqp
      ,1 as kind_energy, his.id_zone as id_zone, dtchange as date_end
      ,fun_mmgg(0),his.id_client as id_client,his.id_typemet as id_typemet
      ,his.carry as carry
      ,  coalesce(his.coef_compa,1)*coalesce(his.coef_compu,1) as k_tr
        from (select p.*,coalesce(z.zone,0) as id_zone 
              from eqm_privmeter_h as p  
                left join eqd_meter_zone_tbl as z on 
                 (z.code_eqp=p.id_eqp and z.dt_zone_install<=dtchange) 
                where dte=dtchange and id_client=idcl ) as his; 
          
        id_ind=currval(''acd_indication_seq'');
     
        update acd_indication_tbl set id_previndic= 
        (select max(id) from acd_indication_tbl h where 
                  acd_indication_tbl.id_meter=h.id_meter 
                  and acd_indication_tbl.num_eqp=h.num_eqp 
                  and acd_indication_tbl.kind_energy=1 
                  and acd_indication_tbl.id_zone=h.id_zone
                  and h.mmgg<=fun_mmgg(0) and h.id_cor_doc is null
                  and h.dat_ind<dtchange and h.id_client=idcl) 
        where   dat_ind=dtchange and id_client=idcl; 
  
        update acd_indication_tbl set id_previndic=id_ind  
           where   id_previndic=
            (select id_previndic from acd_indication_tbl where id=id_ind)
               and id<>id_ind ; 



 raise notice ''insert from history'';


   
 insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
    ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp)
       
    select id_headdoc as id_doc, met.id_eqp as id_meter, met.num_eqp as num_eqp
      ,1 as kind_energy, met.id_zone as id_zone, dtchange as date_end
      ,fun_mmgg(0),met.id_client as id_client,met.id_typemet as id_typemet
      ,met.carry as carry, coalesce(met.coef_compa,1)*coalesce(met.coef_compu,1) as k_tr
    
       from (select p.*, coalesce(z.zone,0) as id_zone 
                from eqm_privmeter_tbl  as p
                  left join eqd_meter_zone_tbl as z on 
                 (z.code_eqp=p.id_eqp and z.dt_zone_install<=dtchange)
                 where num_eqp is not null 
              and id_typemet is not null and carry>0  
              and p.id_client=idcl) 
         as met;
  
     id_newind=currval(''acd_indication_seq'');
     
      raise notice ''insert from meter'';


     update acd_indication_tbl set value=0,value_dev=0,value_dem=0,
              num_eqp=n.num_eqp,
              id_typemet=n.id_typemet,carry=n.carry,coef_comp=n.coef_comp    
            from (select * from acd_indication_tbl where id=id_newind) as n
            where   acd_indication_tbl.dat_ind>dtchange and acd_indication_tbl.id_client=idcl;  
 
 raise notice ''update old typemeter'';

       Return true;
end;
' Language 'plpgsql';

