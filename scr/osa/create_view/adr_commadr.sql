delete from adm_commadr_tbl;
insert into adm_commadr_tbl (id_street ,id_town) select id,id_town from adi_street_tbl;
update adm_commadr_tbl set id_region=(select id_region from adi_town_tbl where adm_commadr_tbl.id_town=adi_town_tbl.id);
update adm_commadr_tbl set id_domain=(select id_domain from adi_region_tbl where adm_commadr_tbl.id_region=adi_region_tbl.id);
