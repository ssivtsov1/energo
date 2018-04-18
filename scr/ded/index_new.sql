--drop INDEX acd_indication_prev_idx;
CREATE INDEX acd_indication_prev_idx
  ON acd_indication_tbl
  USING btree
  (id_previndic);

--drop INDEX acm_headindication_client_idx;
CREATE INDEX acm_headindication_client_idx
  ON acm_headindication_tbl
  USING btree
  (id_client);

--drop INDEX acd_indication_client_idx;
CREATE INDEX acd_indication_client_idx
  ON acd_indication_tbl
  USING btree
  (id_client);


CREATE INDEX acm_inspectstr_client_idx
  ON acm_inspectstr_tbl
  USING btree
  (id_client);

