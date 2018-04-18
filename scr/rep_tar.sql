;

select del_notrigger('acd_tarif_tbl','delete from acd_tarif_tbl where id=2603');
select del_notrigger('acd_billsum_tbl','delete from acd_billsum_tbl where id_sumtariff=2603 and flock<>1');
