select del_notrigger('acd_tarif_tbl','delete from acd_tarif_tbl where id=2617');
select del_notrigger('acd_tarif_tbl','delete from acd_tarif_tbl where id_tarif is null');


CREATE UNIQUE INDEX acd_tarif_ind
  ON acd_tarif_tbl
  USING btree
  (id_tarif, dt_begin, idk_currency);


