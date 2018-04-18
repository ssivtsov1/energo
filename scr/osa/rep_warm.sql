


select c.name,e.name as name_e,z.name as name_z,
t.name as tarif_n, d.*,
     (date_mi(d.dat_e,d.dat_b)+1) as all,
     (date_mi(d.dt_end,d.dt_begin)+1) as part,
round(d.kvt/(date_mi(d.dat_e,d.dat_b)+1)::numeric,2) as tt,
 case when     date_part('month',d.dat_b) in (1,2,12) 
         and   date_part('month',d.dat_e) in (1,2,12)
      then round(round(d.kvt/(date_mi(d.dat_e,d.dat_b)+1)::numeric,2)*(date_mi(d.dt_end,d.dt_begin)+1),0)
      else d.kvt
 end as kvt_calc,
      
 case when     date_part('month',d.dat_b) in (1,2,12) 
         and   date_part('month',d.dat_e) in (1,2,12)
      then round(round(d.kvt/(date_mi(d.dat_e,d.dat_b)+1)::numeric,2)*(date_mi(d.dt_end,d.dt_begin)+1),0)*d.tarif*d.koef
      else d.kvt*d.tarif*d.koef
end  as sum_calc
from
(select kvt.id_doc,kvt.id_client,tar.id_zone,tar.kind_energy, tar.id_tariff,
 tar.id_point,kvt.num_eqp,kvt.dat_b,kvt.dat_e,
tar.dt_begin,tar.dt_end,kvt.kvt,tar.koef,tar.tarif
from 
 (select d.id_doc,d.id_point,b.id_client,d.num_eqp,d.kind_energy,d.id_zone,
    d.dat_b,d.dat_e, d.mmgg,d.calc_demand_w as kvt 
  from acd_met_kndzn_tbl d,
       acm_bill_tbl b  
  where  calc_demand_w is not null
   and d.id_doc=b.id_doc
   and  d.mmgg='2006-01-01' 
  order by d.id_doc,d.id_point
 )  as kvt
 right join 
 ( select bs.id_doc,id_point,bs.dt_begin,bs.dt_end,bs.kind_energy,bs.id_zone,id_zonekoef,z.koef,
         id_tariff,id_sumtariff,t.value as tarif 
   from acd_billsum_tbl bs,acd_zone_tbl z,acd_tarif_tbl t, 
       (select distinct acd_met_kndzn_tbl.id_doc  from acd_met_kndzn_tbl 
         where  calc_demand_w is not null and mmgg='2006-01-01'
       )  as need_s
   where bs.id_zonekoef=z.id and bs.id_sumtariff=t.id  
       and need_s.id_doc=bs.id_doc order by bs.id_doc,bs.id_point
  ) as tar  
 on (tar.id_doc=kvt.id_doc and tar.id_point=kvt.id_point)
) as d
, clm_client_tbl c
, eqk_energy_tbl e
, eqk_zone_tbl z 
, aci_tarif_tbl t
 where  c.id=d.id_client and d.id_zone=z.id and d.kind_energy=e.id 
 and d.id_tariff=t.id  and date_part('month',d.dt_begin) in (1,2,12) and date_part('month',d.dt_end) in (1,2,12)






