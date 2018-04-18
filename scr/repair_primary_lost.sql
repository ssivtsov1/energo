ALTER TABLE acd_calc_losts_tbl DROP CONSTRAINT acd_calc_losts_tbl_pkey;

ALTER TABLE acd_calc_losts_tbl
  ADD CONSTRAINT acd_calc_losts_tbl_pkey PRIMARY KEY(id_doc, id_point, id_eqp, dat_b,dat_e, kind_energy);
