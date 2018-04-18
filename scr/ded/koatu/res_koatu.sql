--
-- PostgreSQL database dump
--

-- Started on 2015-04-03 09:00:13

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1743 (class 1259 OID 355107455)
-- Dependencies: 6
-- Name: tmp_res_koatu_tbl; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

DROP TABLE tmp_res_koatu_tbl;
 
CREATE TABLE tmp_res_koatu_tbl (
    code integer,
    name character varying(100),
    ident character varying(20)
);


--
-- TOC entry 2077 (class 0 OID 355107455)
-- Dependencies: 1743
-- Data for Name: tmp_res_koatu_tbl; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (110, 'Бобровицький РЕМ', '7420600000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (120, 'Борзнянський РЕМ', '7420800000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (130, 'Варвинський РЕМ', '7421100000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (140, 'Городнянський РЕМ', '7421400000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (150, 'Ічнянський РЕМ', '7421700000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (160, 'Козелецький РЕМ', '7422000000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (180, 'Коропський РЕМ', '7422200000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (170, 'Корюківський РЕМ', '7422400000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (190, 'Куликівський РЕМ', '7422700000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (200, 'Менський РЕМ', '7423000000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (210, 'Ніжинський РЕМ', '7423300000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (220, 'Новгород-Сіверський РЕМ', '7423600000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (230, 'Носівський РЕМ', '7423800000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (240, 'Прилуцький РЕМ', '7424100000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (250, 'Ріпкинський РЕМ', '7424400000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (270, 'Семенівський РЕМ', '7424700000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (260, 'Сосницький РЕМ', '7424900000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (280, 'Срібнянський РЕМ', '7425100000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (100, 'Бахмацький РЕМ', '7420300000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (290, 'Талалаївський РЕМ', '7425300000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (320, 'Чернігівський РЕМ', '7425500000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (300, 'Щорський РЕМ', '7425800000000');
INSERT INTO tmp_res_koatu_tbl (code, name, ident) VALUES (310, 'Чернігівські міські електромережі', '7410100000000');


-- Completed on 2015-04-03 09:00:13

--
-- PostgreSQL database dump complete
--

