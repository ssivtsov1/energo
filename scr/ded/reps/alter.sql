
ALTER TABLE rep_nds2011_tbl ADD COLUMN  deb_b_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  dpdv_b_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  deb_e_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  dpdv_e_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  opl_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  oplpdv_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  sp1_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  sp1pdv_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  sp2_008_5 numeric(14,2) ;
ALTER TABLE rep_nds2011_tbl ADD COLUMN  sp2pdv_008_5 numeric(14,2) ;

ALTER TABLE rep_nds2011_tbl ALTER COLUMN  deb_b_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  dpdv_b_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  deb_e_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  dpdv_e_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  opl_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  oplpdv_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  sp1_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  sp1pdv_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  sp2_008_5 SET DEFAULT 0;
ALTER TABLE rep_nds2011_tbl ALTER COLUMN  sp2pdv_008_5 SET DEFAULT 0;



update rep_nds2011_tbl set deb_b_008_5 =0 where deb_b_008_5 is null;
update rep_nds2011_tbl set dpdv_b_008_5 =0 where dpdv_b_008_5 is null;
update rep_nds2011_tbl set deb_e_008_5 =0 where deb_e_008_5 is null;
update rep_nds2011_tbl set dpdv_e_008_5 =0 where dpdv_e_008_5 is null;
update rep_nds2011_tbl set opl_008_5 =0 where opl_008_5 is null;
update rep_nds2011_tbl set oplpdv_008_5 =0 where oplpdv_008_5 is null;
update rep_nds2011_tbl set sp1_008_5 =0 where sp1_008_5 is null;
update rep_nds2011_tbl set sp1pdv_008_5 =0 where sp1pdv_008_5 is null;
update rep_nds2011_tbl set sp2_008_5 =0 where sp2_008_5 is null;
update rep_nds2011_tbl set sp2pdv_008_5 =0 where sp2pdv_008_5 is null;

