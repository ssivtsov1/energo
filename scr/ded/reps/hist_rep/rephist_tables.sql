drop table syi_hist_table_tbl ;

CREATE TABLE syi_hist_table_tbl (
    id serial NOT NULL,
    id_table integer,
    is_insert boolean,
    is_update boolean,
    is_delete boolean,
    abon_path_type integer DEFAULT 1,
    PRIMARY KEY (id)
);


--
-- Data for TOC entry 5 (OID 3146811598)
-- Name: syi_hist_table_tbl; Type: TABLE DATA; Schema: public; Owner: ded
--

INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (5, 197, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (6, 198, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (7, 203, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (8, 201, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (9, 199, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (10, 200, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (11, 191, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (12, 205, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (13, 202, false, true, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (15, 193, true, false, true, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (16, 192, true, false, true, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (17, 207, true, false, true, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (20, 196, true, false, true, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (21, 206, false, false, false, 1);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (3, 194, false, true, false, 4);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (4, 195, false, true, false, 4);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (18, 188, true, true, true, 0);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (19, 208, true, false, true, 0);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (1, 190, true, true, true, 3);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (2, 189, false, true, false, 2);
INSERT INTO syi_hist_table_tbl (id, id_table, is_insert, is_update, is_delete, abon_path_type) VALUES (14, 204, false, true, false, 5);



drop table rep_hist_changed_fields_tbl;

create table rep_hist_changed_fields_tbl
(
 id serial,
 id_table   int,
 id_field   int,
 record_oid oid,
 dt_change  date,
 old_val    varchar(200),
 new_val    varchar(200), 
 old_text   varchar(200),
 new_text   varchar(200), 
 code_eqp   int,
 id_client  int,
 id_usr     int,
 primary key (id)
);

delete from syi_field_tbl where name ~'pg.dropped';

update eqm_changelog_tbl set id_usr = null where dt <'2011-04-15';