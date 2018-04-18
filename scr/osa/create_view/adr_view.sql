
drop view adv_address_tbl cascade;
alter table adm_address_tbl add column short_adr  varchar (100);

CREATE VIEW adv_address_tbl (id,id_domain,id_region,id_town,id_street,
 full_adr, dom_reg ,adr )
AS
 select distinct adm_address_tbl.id, adm_commadr_tbl.id_domain,adm_commadr_tbl.id_region,
 adm_commadr_tbl.id_town,adm_commadr_tbl.id_street,

 cast(coalesce(adm_address_tbl.post_index,14000) as varchar(5))|| ' '||
 coalesce(adi_domain_tbl.name,' ') || ' ' || coalesce(adi_region_tbl.name, ' ') ||' '||
 coalesce(adk_town_tbl.shot_name,' ')||' '||coalesce(adi_town_tbl.name, ' ')||'  '||
 coalesce(adk_street_tbl.shot_name,' ')||' '||coalesce(adi_street_tbl.name, ' ')||' '
 ||coalesce(adm_address_tbl.short_adr,' '),
 
 cast(coalesce(adm_address_tbl.post_index,14000) as varchar(5))|| ' '||
 coalesce(adi_domain_tbl.name,' ')||' '||coalesce(adi_region_tbl.name,' '),


 coalesce(adk_town_tbl.shot_name,' ')||' '|| coalesce(adi_town_tbl.name,' ')||' '
 || coalesce(adk_street_tbl.shot_name,' ')||' '|| coalesce(adi_street_tbl.name,' ')||' '
 ||coalesce(adm_address_tbl.short_adr,' ')

 from adi_domain_tbl, 
 adi_region_tbl,
 adi_town_tbl left outer join adk_town_tbl on idk_town=adk_town_tbl.id,
 adi_street_tbl left outer join adk_street_tbl on idk_street=adk_street_tbl.id,
 adm_commadr_tbl,
 adm_address_tbl
 where adm_address_tbl.id_street=adm_commadr_tbl.id_street and
 adm_commadr_tbl.id_street=adi_street_tbl.id and
 adm_commadr_tbl.id_town=adi_town_tbl.id and 
 adm_commadr_tbl.id_region=adi_region_tbl.id
 and adm_commadr_tbl.id_domain=adi_domain_tbl.id;


drop view adv_commadr_tbl;
CREATE VIEW ADV_COMMADR_TBL (id_street,id_domain,id_region,id_town,
 full_commadr,dom_reg,town_street)
AS
 select cc.id_street,cc.id_domain,cc.id_region, cc.id_town,
 coalesce(adi_domain_tbl.name) ||' '|| coalesce(adi_region_tbl.name) ||' '||
 coalesce(adi_town_tbl.name )||'  '||coalesce(adi_street_tbl.name),
 coalesce(adi_domain_tbl.name)||' '||coalesce(adi_region_tbl.name),
 adi_town_tbl.name||' '||adi_street_tbl.name
 from (((( adm_commadr_tbl  cc left outer  join adi_domain_tbl on cc.id_domain=adi_domain_tbl.id)
 left join adi_region_tbl on cc.id_region= adi_region_tbl.id)
 left join adi_town_tbl on cc.id_town=adi_town_tbl.id)
 left join adi_street_tbl on cc.id_street=adi_street_tbl.id)
order by id_street;



/*

update adi_region_tbl set name='Козелецький р-н' where id=1;
update adi_region_tbl set name='Коропський р-н' where id=2;
update adi_region_tbl set name='Корюк?вський р-н' where id=3;
update adi_region_tbl set name='Варвинський р-н' where id=4;
update adi_region_tbl set name='Р?пкинський р-н' where id=5;
update adi_region_tbl set name='Кулик?вський р-н' where id=6;
update adi_region_tbl set name='Н-С?верський р-н' where id=7;
update adi_region_tbl set name='Нос?вський р-н' where id=8;
update adi_region_tbl set name='Менський р-н' where id=9;
update adi_region_tbl set name='Н?жинський р-н' where id=10;
update adi_region_tbl set name='?чнянський р-н' where id=11;
update adi_region_tbl set name='Щорський р-н' where id=12;
update adi_region_tbl set name='Черн?г?в ' where id=13;
update adi_region_tbl set name='Черн?г?вський р-н' where id=14;
update adi_region_tbl set name='Борзнянський р-н' where id=15;
update adi_region_tbl set name='Бобровицький р-н' where id=16;
update adi_region_tbl set name='Бахмячський р-н' where id=17;
update adi_region_tbl set name='Прилуцький р-н' where id=18;
update adi_region_tbl set name='Сосницький р-н' where id=19;
update adi_region_tbl set name='Семен?вський р-н' where id=20;
update adi_region_tbl set name='Ср?бнянський р-н' where id=21;
update adi_region_tbl set name='Талала╓вський р-н' where id=22;
update adi_region_tbl set name='Городнянський р-н' where id=23;
*/
      

/*
select c.id,c.book,c.code,c.name,c.id_addres,num_subsid,c.id_addres,a.adr,
    aaa.id_met,aaa.num_eqp,aaa.anam as nam_eqp, aaa.id_typemet,aaa.type,aaa.met_carry,aaa.met_coef_comp,
    met_tariff,name_tar  
   from 
         clm_client_tbl c  left outer join clm_statecl_tbl s on s.id_client=c.id
         left outer join adv_address_tbl a on c.id_addres=a.id,  
         ( select aab.*,at.name as name_tar from
          (  select aa.*,tm.type from (select cm.id,m.id_eqp as id_met,m.id_tariff as met_tariff,m.name as anam,m.num_eqp,m.id_typemet,
               m.carry as met_carry,m.coef_compa*m.coef_compu as met_coef_comp
             from  clm_client_tbl cm 
               left outer join eqm_privmeter_tbl m on cm.id=m.id_client) as aa
           left outer join eqi_meter_tbl tm on aa.id_typemet=tm.id
          ) as aab left outer join aci_tarif_tbl at on aab.met_tariff=at.id
         ) as aaa
     where aaa.id=c.id and c.book is not null 
     
select c.id,c.book,c.code,kk.id_k,c.name,c.id_addres,num_subsid,c.id_addres,a.adr,
    aaa.id_met,aaa.num_eqp,aaa.anam as nam_eqp, aaa.id_typemet,aaa.type,aaa.met_carry,aaa.met_coef_comp,
    met_tariff,name_tar,kk.id_k,kk.name_kat,kk.persent,kk.p_number  
   from 
         clm_client_tbl c  left outer join clm_statecl_tbl s on s.id_client=c.id
          left outer join (select  k.id_client,k.id_k,k.p_number,ka.name as name_kat,ka.persent
                           from clm_addon_tbl k,cla_kateg_tbl ka 
                            where k.id_k=ka.id 
                           ) as kk 
                  on kk.id_client=c.id
         left outer join adv_address_tbl a on c.id_addres=a.id,  
         ( select aab.*,at.name as name_tar from
          (  select aa.*,tm.type from (select cm.id,m.id_eqp as id_met,m.id_tariff as met_tariff,m.name as anam,m.num_eqp,m.id_typemet,
               m.carry as met_carry,m.coef_compa*m.coef_compu as met_coef_comp
             from  clm_client_tbl cm 
               left outer join eqm_privmeter_tbl m on cm.id=m.id_client) as aa
           left outer join eqi_meter_tbl tm on aa.id_typemet=tm.id
          ) as aab left outer join aci_tarif_tbl at on aab.met_tariff=at.id
         ) as aaa
     where aaa.id=c.id and c.book is not null 


  */ 
/*
select c.id,c.book,c.code,c.name,c.id_addres,num_subsid,c.id_addres,a.adr,
    aaa.id_met,aaa.num_eqp,aaa.anam as nam_eqp, aaa.id_typemet,aaa.type,aaa.met_carry,aaa.met_coef_comp
     from 
         clm_client_tbl c  left outer join clm_statecl_tbl s on s.id_client=c.id,
         clm_client_tbl cl left outer join adv_address_tbl a on cl.id_addres=a.id,  
         (select aa.*,tm.type from (select cm.id,m.id_eqp as id_met,m.name as anam,m.num_eqp,m.id_typemet,
               m.carry as met_carry,m.coef_compa*m.coef_compu as met_coef_comp
             from  clm_client_tbl cm 
               left outer join eqm_privmeter_tbl m on cm.id=m.id_client) as aa
           left outer join eqi_meter_tbl tm on aa.id_typemet=tm.id
         ) as aaa
     where c.id=cl.id and aaa.id=c.id and c.book is not null 
  */      
/*
select c.id,c.book,c.code,c.name,c.id_addres,num_subsid,c.id_addres,a.adr,
    aaa.id_met,aaa.num_eqp,aaa.anam as nam_eqp, aaa.id_typemet,aaa.type
     from 
         clm_client_tbl c  left outer join clm_statecl_tbl s on s.id_client=c.id,
         clm_client_tbl cl left outer join adv_address_tbl a on cl.id_addres=a.id,  
         (select aa.*,tm.type from (select cm.id,m.id_eqp as id_met,m.name as anam,m.num_eqp,m.id_typemet from  clm_client_tbl cm 
               left outer join eqm_privmeter_tbl m on cm.id=m.id_client) as aa
           left outer join eqi_meter_tbl tm on aa.id_typemet=tm.id
         ) as aaa
     where c.id=cl.id and aaa.id=c.id and c.book is not null 
*/        
   
        