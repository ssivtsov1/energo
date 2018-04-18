delete from acd_tarif_tbl where id_tarif in (select id from aci_tarif_tbl where id_grouptarif = 199);
delete from aci_tarif_tbl where id_grouptarif = 199;
delete from eqi_grouptarif_tbl where id = 199;