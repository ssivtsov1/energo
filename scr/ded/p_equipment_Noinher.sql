-- �����������    *_ind_tbl
--    ��������������� (��� �������� ����������� ���������):
--       ��� ��������� (������������/�����������)      eqk_meter_tbl (kind_meter_ind_tbl)
--       �������� (����������/����������)              eqk_phase_tbl (phase_ind_tbl)
--       ���������� ����� �������                      eqk_energy_tbl  (kind_energy_ind_tbl)
--       ���������� ������� ����������                 eqk_voltage_tbl (voltage_group_ind_tbl) 
--       ����� ����������� (�����������/���������)     eqk_schemains_tbl (schema_inst_ind_tbl)
--       ������ ��������� (����������������/����� ��.����/
--           ����� ��.����������/����� ��.�������������
--           ������-������/������-������/������-�����������/
--           ������-�����������)                       eqk_hookup_tbl (hook_up_ind_tbl
--       ��� (����������/�����������)                  eqk_sync_tbl (sync_ind_tbl 
--       ��� ����� (���������/������)                  eqk_air_undegr_tbl (air_undegr_ind_tbl
--       ���������� ����������                         eqk_materals_tbl (materals_ind_tbl
--       ������� ����� ��������� (0=����������/1=�� ����������/2��������������) eqk_in_station_tbl (in_station_ind_tbl
-- 	 ������ ��������������� ������������ 	   eqk_switchs_gr_tbl (switchs_gr_ind_tbl)	
--       
--    ����������� ����������:
--       ���� ����������� ���������         eqi_device_kinds_tbl (devices_ind_tbl) 
--       ��������
--           ���������� ���������               eqi_meter_tbl (meter_ind_tbl)
--             ���������� ����������� ��������  eqi_meter_prec_tbl (meter_prec_ind_tbl)
--             ���� ���������                  eqk_kind_count_tbl (kind_count_ind_tbl)
--             ��� ����������� ������� ��� ���� ��������
--			eqi_meter_energy_tbl (meter_energy_ind_tbl)
--       ���������� ���������������         eqi_compensator_tbl (compensator_ind_tbl)
-- 		2-� ���������� ��-�� 	    eqi_compensator_2_tbl (compensator_2_ind_tbl)
--		3-� ���������� ��-��        eqi_compensator_3_tbl (compensator_3_ind_tbl)
--		��-�� ����     		    eqi_compensator_i_tbl (compensator_i_ind_tbl)
--       ���������� ��������������� ������������  eqi_switchs_tbl (switchs_ind_tbl)
--       ���������� �������������           eqi_jack_tbl (jack_ind_tbl)
--       ���������� ���������������         eqi_fuses_tbl (fuses_ind_tbl)
--             ���������� ������� �������      eqi_cable_tbl  (cable_ind_tbl)
--             ���������� ������� ������� ���  eqi_cable_�_tbl  (cable_�_ind_tbl)
--             ���������� ��������             eqi_corde_tbl (corde_ind_tbl)
--���             ���������� ��������� ����������� �������������  - not resisters_ind_tbl
--���             ���������� ���������� ��������                  - distanceped_ind_tbl
--             ���������� ����                 eqi_pillar_tbl  (pillar_ind_tbl)
--             ����� ����������                eqi_earth_tbl   (earth_ind_tbl)

-- �������� ������������� ����
--���    ����� ����� ����������� ������� � ��.����� - eqm_schema_tbl(schema_eqp_tbl)
--
--       ������ ��������                           - eqm_tree_tbl (tree_tbl)   
-- 	 ���������� ������������� ���� 
--			(���� ������)              - eqm_eqp_tree_tbl
--       �������� ��������� ����                   - eqp_schema_tbl
--	 ����� ������ ������������ 		   - eqm_equipment_tbl (eqp_tbl)
--
--       ����� ������������� ����
--     
--       ������ ������������                        - eqm_eqp_change_tbl(eqp_change_tbl)
--       �������� ������ ������������, ������������ ���� ����������� �������:
--            ��������                              - eqm_meter_tbl (meter_eqp_tbl)
--               ���� ��������                      - eqm_meter_zone_tbl (meter_zone_eq_tbl)
--		 ���� �������                       - eqm_meter_energy_tbl (meter_energy_eq_tbl)
--
--            ���������������� ����������           - eqm_compens_station_tbl (compens_station_eqp_tbl)
--            ��������� ��������������� �� ���������� - eqm_compens_station_inst_tbl (compens_station_inst_eqp_tbl )
--            ��������������                        - eqm_compensator_tbl (compensator_eqp_tbl)
--            ��������������  ����                  - eqm_compensator_i_tbl (compensator_i_eqp_tbl)
--            �����                                 - eqm_line_a_tbl (line_a_eqp_tbl)
--	      ������				    - eqm_line_c_tbl (line_c_eqp_tbl)
--            ������� ��������� �����               - eqm_line_path_tbl (line_tbl)
--	      ������������                          - eqm_jack_tbl (jack_eqp_tbl)
--            ������� ��������                      - eqm_borders_tbl (borders_eqp_tbl)
--            �������������� ������������           - eqm_switch_tbl (switch_eqp_tbl)
--            ��������������                        - eqm_fuse_tbl (fuse_eqp_cl_tbl)
--

-- ------------------------------------------------------------------------
-- �������� (����������/����������)              eqk_phase_tbl
drop table eqk_phase_tbl;

create table eqk_phase_tbl (
     id		    int,       -- ��� ���� 
     name           varchar(20),   -- �������� (����������/����������)
     primary key(id)
);

-- ��� ������. ������������� (���/����������)              eqk_conversion_tbl
drop table eqk_conversion_tbl;

create table eqk_conversion_tbl (
     id		    int,       -- ��� ���� 
     name           varchar(20),   -- �������� 
     primary key(id)
);

-- ���������� ����� �������
drop table eqk_energy_tbl;

create table eqk_energy_tbl (
     id             int,      -- * ��� ����������� ������� 
     name           varchar(20),  --   ������������ (��������/����������)
     primary key(id)
);

-- ���������� ������� ����������
drop table eqk_voltage_tbl;

create table eqk_voltage_tbl (
     id             int,      -- * ����� ����������
     voltage_min    numeric(9,1), --   ���������� �����������
     voltage_max    numeric(9,1), --   ���������� ������������
     primary key(id)
);

-- ����� ����������� (�����������/���������)     eqk_schemains_tbl
drop table eqk_schemains_tbl;

create table eqk_schemains_tbl (
     id		    int,       -- *��� ���� 
     name           varchar(20),   --  �������� 
     primary key(id)
);

-- ������ ��������� (����������������/����� ��.����/
-- ����� ��.����������/����� ��.�������������
-- ������-������/������-������/������-�����������/
--           eqk_hookup_tbl
drop table eqk_hookup_tbl;

create table eqk_hookup_tbl (
     id             int,       -- *��� ���� 
     name           varchar(25),   --  �������� 
     primary key(id)
);

--  ��� (����������/�����������)                  eqk_sync_tbl 
drop table eqk_sync_tbl;

create table eqk_sync_tbl  (
     id             int,       -- *��� ���� 
     name           varchar(20),   --  �������� 
     primary key(id)
);
/*

--  ��� ����� (���������/������) �� ������������                 eqk_air_undegr_tbl
drop table eqk_air_undegr_tbl;

create table eqk_air_undegr_tbl (
     id             int,       -- *��� ���� 
     name           varchar(20),   --  �������� 
     primary key(id)
);

*/
--  ���������� ����������                         eqk_materals_tbl
drop table eqk_materals_tbl;

DROP SEQUENCE eqk_materals_seq;

CREATE SEQUENCE eqk_materals_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;


create table eqk_materals_tbl (
     id             int DEFAULT nextval('"eqk_materals_seq"'::text),       -- *��� ���� 
     name           varchar(20),   --  �������� 
     ro             numeric(10,6), -- �������� ������������� (��*��2/�)
     ro_mantis      int,      -- �������� ��������� �������������
     primary key(id)
);
-- ���� ��������
drop table eqk_cover_tbl;
DROP SEQUENCE eqk_cover_seq;

CREATE SEQUENCE eqk_cover_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqk_cover_tbl (
     id             int DEFAULT nextval('"eqk_cover_seq"'::text),       -- *��� ���� 
     name           varchar(20),   -- �������� 
     mu             numeric(8,4),  -- ��������� �������������, ������������
     ro             numeric(12,6), -- �������� �������������, ���*�
     primary key(id)
);
/*
--       ������� ����� ��������� (0=����������/1=�� ����������/2=��������������) eqk_in_station_tbl
--       (����� �� ������������)
drop table eqk_in_station_tbl;

create table eqk_in_station_tbl (
     id int,       -- ���
     name varchar(20), -- ��������
     primary key(id)
);
  */
-- ������� �� ��� ����� �����
DROP SEQUENCE eqk_tg_seq;
CREATE SEQUENCE eqk_tg_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

drop table eqk_tg_tbl;
create table eqk_tg_tbl (
     id             int DEFAULT nextval('"eqk_tg_seq"'::text),       -- *��� ���� 
     name           varchar(20),   --  �������� 
     value          numeric(8,5), -- ?
     primary key(id)
);

-- ------------------------------------------------------------------------
-- ���� ����������� ���������         eqi_devices_tbl
 DROP SEQUENCE eqi_device_kinds_seq;

  CREATE SEQUENCE eqi_device_kinds_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;


drop table eqi_device_kinds_tbl;

create table eqi_device_kinds_tbl (
     id              int DEFAULT nextval('"eqi_device_kinds_seq"'::text),  --* ���
     name            varchar(35),        --  �������� 
     id_table_ind    int,           --  id ������� ����������� ��������
     id_table        int,           --  id ������� ������ ��������
     calc_lost       int default 0, --  ������� � ������� ������ (0-�� ���������/1-���������)
     inst_station    int default 0, --  1- ����������/��������, 0 - ���������� ����, 2- ����� ���������
--     id_icon         int,
--     table_name      varchar(128), --  
--     table_ind       varchar(128), --  
--     field_name      varchar(128), --  ��� ���� � ���. ������������
--     field_code_name varchar(128), --  ��� ���� ����� ����������� �� �������
     primary key (id)
--     , foreign key (id_table) references s_table_tbl (id)
--     , foreign key (id_table_ind) references s_table_tbl (id)
--       , foreign key (inst_station) references eqk_in_station_tbl (id)
);
---------------------------------------------------------------------------
drop table eqi_device_kinds_prop_tbl;

create table eqi_device_kinds_prop_tbl (
     type_eqp        int,     --* ���
     id_icon         int,     -- ��� ������ � ���������
     form_name       varchar(35),  -- ��� ������ ����� � ���������
     primary key (type_eqp),
     foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
);
-- ------------------------------------------------------------------------
-- ��� ��������� (������������/�����������)      eqk_meter_tbl
drop table eqk_meter_tbl;

create table eqk_meter_tbl (
     id             int,       -- *��� ���� 
     name           varchar(20),   --  �������� (������������/�����������)
     primary key(id)
);
-- ������ �����
drop table eqk_kind_count_tbl;

create table eqk_kind_count_tbl (
     id              int,      --* ���
     name            varchar(35),  --  ��������  ( ���������� ���������, ������ �� ������)
     primary key(id)
); 

-- ����������- �������� ��� ���� ������������ ������������ eqi_devices_parent_tbl
----drop table eqi_devices_parent_tbl;
DROP SEQUENCE eqi_devices_seq;

 CREATE SEQUENCE eqi_devices_seq
 INCREMENT 1
 MINVALUE 1
 START 1 ;

----create table eqi_devices_parent_tbl (
----     id           int DEFAULT nextval('"eqi_devices_parent_seq"'::text),    --* ��� ���� 
----     type         varchar(35),   -- ��� 
----     normative    varchar(35),   -- ����, ��
----     voltage_nom  int,      -- ����������� ���������� (���������), v
----     amperage_nom int,      -- ����������� ��� (���������), a
----     voltage_max  int,      -- ������������ ���������� (���������), v
----     amperage_max int,      -- ����������� ��� (���������), a
----     primary key(id)
----);



-- ���������� ��������� eqi_meter_tbl
drop table eqi_meter_tbl;

create table eqi_meter_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
--   -------------------------------------------------------------------
     kind_meter    int,        --i ��� (������������/�����������) (eqk_meter_tbl->kinde_meter)
     kind_count    int,        --i ��� ����� ������� (���������� ���������, ������ �� ������) (eqk_kind_count_tbl->kinde_count)
     phase          int,       --i �������� (����������/����������) (eqk_phase_tbl->phase)
     carry          int,       -- �����������
     schema_inst    int,       --i ����� ����������� (�����������/���������)     (eqk_schemains_tbl->schema_inst)
     hook_up        int,       --i ������ ��������� (����������������/����� ��.����/����� ��.����������/����� ��.�������������)
                                   -- eqk_hookup_tbl->hook_up
     amperage_nom_s int,      -- ����������� ��� ���������, a
     voltage_nom_s  int,      -- ����������� ���������� ���������, v
     zones          int,       -- �-�� ���
     zone_time_min  numeric(4,2),  -- ����������� ��������� ��������, �
     term_control   int,       -- ������������� ������� (4-��������/8-����������),���
     show_def       int,
     primary key(id)
     , foreign key (kind_meter) references eqk_meter_tbl (id)
     , foreign key (kind_count) references eqk_kind_count_tbl (id)
     , foreign key (phase) references eqk_phase_tbl (id)
     , foreign key (schema_inst) references eqk_schemains_tbl (id)
     , foreign key (hook_up) references eqk_hookup_tbl (id)
);
-- ��� ����������� ������� ��� ���� ��������
drop table eqi_meter_energy_tbl;

create table eqi_meter_energy_tbl (
     id_type_eqp    int,       --* ��� ���� ��������
     kind_energy    int,       --i ��� ����������� ������� (��������/����������) (eqk_energy_tbl->kind_energy)
     primary key(id_type_eqp,kind_energy)
     , foreign key (id_type_eqp) references eqi_meter_tbl (id)
     , foreign key (kind_energy) references eqk_energy_tbl (id)
);
-- ����� �������� �������� eqi_meter_prec_tbl
drop table eqi_meter_prec_tbl;

create table eqi_meter_prec_tbl (
     id_type_eqp     int,      --*i ��� ��� ��������   eqi_meter_tbl->code_meter
     cl             varchar(10),       -- ����� �������� ( �� �����)
     kind_load      numeric(4,2),  --* ������� �������� cosFi
     amperage_load  numeric(6,2),  --* ������� �������� ��� (% �� ������������)
     error          numeric(4,2),  -- ������������� ����������� (� %)
     primary key(id_type_eqp,kind_load,amperage_load)
     , foreign key (id_type_eqp) references eqi_meter_tbl (id)
);

-- ���������� ��������������� eqi_compensator_tbl
drop table eqi_compensator_tbl;

create table eqi_compensator_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
   -------------------------------------------------------------------
     voltage2_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage2_nom int,      -- ����������� ��� (���������), a

     phase                  int,      -- i �������� (����������/����������)  eqk_phase_tbl->phase
     swathe                 int NOT NULL,      -- ���������� �������
     hook_up                int,      -- i ������ ���������� (������-������/������-������/������-�����������/������-�����������)
                                          -- (eqk_hookup_tbl->hook_up)
     power_nom              int,          -- ����������� ��������, ���
     amperage_no_load       numeric(8,4), -- ��� ��������� ���� , %
     show_def               int,
     primary key(id)
     , foreign key (phase) references eqk_phase_tbl (id)
     , foreign key (hook_up) references eqk_hookup_tbl (id)
);
-- 2-� ���������� ��-��
drop table eqi_compensator_2_tbl;

create table eqi_compensator_2_tbl (
     id_type_eqp             int,     --* ��� ����
     voltage_short_circuit  numeric(8,4), -- ���������� ��, %
     iron                   numeric(8,4), -- ������ ����� , ���
     copper                 numeric(8,4), -- ������ ����  , ���
     primary key(id_type_eqp)
     , foreign key (id_type_eqp) references eqi_compensator_tbl (id)
);
-- 3-� ���������� ��-�� 
drop table eqi_compensator_3_tbl;

create table eqi_compensator_3_tbl (
     id_type_eqp            int,     --* ��� ����
     voltage3_nom           numeric(9,1),      -- ����������� ���������� (��), v
     amperage3_nom          int,      -- ����������� ��� (��), a
     power_h                numeric(9,1), -- �������� ������� ��,���
     power_m                numeric(9,1), -- �������� ������� ��,���
     power_l                numeric(9,1), -- �������� ������� ��,���
     iron                   numeric(8,4), -- ������ ����� , ���
     copper_hl              numeric(8,4), -- ������ ���� �-�, ���
     copper_hm              numeric(8,4), -- ������ ���� �-�, ���
     copper_ml              numeric(8,4), -- ������ ���� �-�, ���
     voltage_short_hl       numeric(8,4), -- ���������� �� ������� �-�, %  
     voltage_short_hm       numeric(8,4), -- ���������� �� ������� �-�, %  
     voltage_short_ml       numeric(8,4), -- ���������� �� ������� �-�, %
     primary key(id_type_eqp)
     , foreign key (id_type_eqp) references eqi_compensator_tbl (id)
);
-- ���������� ���������������  ������������� eqi_compensator_i_tbl
drop table eqi_compensator_i_tbl;

create table eqi_compensator_i_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
--   -------------------------------------------------------------------
     voltage2_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage2_nom int,      -- ����������� ��� (���������), a

     conversion             int,      -- i ��� ��������������� (���/����������)  eqk_conversion_tbl->name
     phase                  int,      -- i �������� (����������/����������)  eqk_phase_tbl->phase
     swathe                 int,      -- ���������� �������
     hook_up                int,      -- i ������ ���������� (������-������/������-������/������-�����������/������-�����������)
                                          -- (eqk_hookup_tbl->hook_up)
     power_nom              int,          -- ����������� ��������, ��� (��������)
     amperage_no_load       numeric(8,4), -- ��� ��������� ���� ,%  (��������)
--     k_compens              int,     -- ??? !!!����. �������������
     accuracy               int,     --- ����� �������� (����������� � %)
                                          
     primary key(id)
     , foreign key (phase) references eqk_phase_tbl (id)
     , foreign key (hook_up) references eqk_hookup_tbl (id)
     , foreign key (conversion) references eqk_conversion_tbl(id)
);
-- ���������� ������������� eqi_jack_tbl
drop table eqi_jack_tbl;

create table eqi_jack_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
--   -------------------------------------------------------------------
     sync                   int,    -- i ��� (����������/�����������) eqk_sync_tbl->sync
     power_nom              int,         -- ����������� ��������, ��� ����������� ����, ���
     lost_nom               numeric(8,4) -- ������ ��� ����������� ������,���
     ,primary key(id)
     ,foreign key (sync) references eqk_sync_tbl (id)
);

-- ������ ��������������� ������������
drop table eqk_switchs_gr_tbl;

create table eqk_switchs_gr_tbl (
     id int,
     name varchar(45),       --  �������� �������������, ����������������� ������, ������ �������������
     shot_name varchar(6),   --  ��, ��, ��
     primary key(id)
);

-- ���������� ��������������� ������������  eqi_switchs_tbl
drop table eqi_switch_tbl;

create table eqi_switch_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
--   -------------------------------------------------------------------
     id_gr                  int,     --i ������
     power_nom              int,          -- ����������� ��������, ��� ����������� ����, ���
     lost_nom               numeric(8,4), -- ������ ��� ����������� ������, ���
     primary key(id)
     ,foreign key (id_gr) references eqk_switchs_gr_tbl (id)
);


-- ���������� ��������������� eqi_fuses_tbl
drop table eqi_fuse_tbl;

create table eqi_fuse_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
--   -------------------------------------------------------------------
     power_nom            int    -- ����������� ��������, ��� ����������� ����, ���
     ,primary key(id)
);

-- ���������� ������� �������
drop table eqi_cable_tbl;

create table eqi_cable_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),      -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),      -- ������������ ���������� (���������), v
     amperage_max int,      -- ����������� ��� (���������), a
--   -------------------------------------------------------------------
--     kind           int,    -- ?
     S_nom        numeric(6,2),   -- ����������� �������
     cords        int,            -- ���������� ���
     cover        int,            -- i ��� ��������
     ro           numeric(10,6),  -- �������� �������� ������������� ������(��*/��)
     xo           numeric(10,6),  -- �������� ���������� ������������� ������(��*/��)
     dpo          numeric(8,4),   -- ������ �������� ���/��
     show_def     int,
     -- ���������� ������������, ��/(��*��)
     -- ���������� ���������� ��������, �
     ,primary key(id)
     ,foreign key (cover) references eqk_cover_tbl (id)
);
--  ���������� ��� �������
drop table eqi_cable_c_tbl;

DROP SEQUENCE eqi_cable_c_seq;

 CREATE SEQUENCE eqi_cable_c_seq
 INCREMENT 1
 MINVALUE 1
 START 1 ;

create table eqi_cable_c_tbl (
     id           int DEFAULT nextval('"eqi_cable_c_seq"'::text),   --*������������� ����  
     id_type_eqp  int,   -- ��� ���� 
     materal      int,   -- ��� ���� ��������� materal_ind_tbl->materal
     calc_diam    numeric(4,2),   -- ��������� ������� �������, ��
     cord_diam    numeric(4,2),   -- �������� ��������, ��
     cord_qn      int,   -- ���������� ��������, ��
     cover        int,   -- i ��� ��������
     primary key(id)
     , foreign key (id_type_eqp) references eqi_cable_tbl (id)
     , foreign key (materal) references eqk_materals_tbl (id)
     ,foreign key (cover) references eqk_cover_tbl (id)
);
--   ���������� ��������                eqi_corde_tbl
drop table eqi_corde_tbl;

create table eqi_corde_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     voltage_nom  numeric(9,1),  -- ����������� ���������� (���������), v
     amperage_nom int,      -- ����������� ��� (���������), a
     voltage_max  numeric(9,1),  -- ������������ ���������� (���������), v
     amperage_max int,      -- ������������ ��� (���������), a
--   -------------------------------------------------------------------
     S_nom        int,      -- ����������� �������
     materal      int,      -- *��� ���� ��������� materal_ind_tbl->materal
     calc_diam    numeric(4,2),  -- ��������� ������� �������, ��
     cord_diam    numeric(4,2),  -- �������� ��������, ��
     cord_qn      int,      -- ���������� ��������, ��
     ro           numeric(10,6), -- �������� �������� ������������� �������(��*/��)
     xo           numeric(10,6), -- �������� ���������� ������������� �������(��*/��)
     dpo          numeric(8,4), -- ������ �������� ���/��
     show_def     int,
     primary key(id)
     ,foreign key (materal) references eqk_materals_tbl (id)
);
-- ���������� ���������� ��������
drop table eqi_pendant_tbl;

create table eqi_pendant_tbl (
     id                int DEFAULT nextval('"eqi_devices_seq"'::text),     --* ��� ����
     type              varchar(35),  -- �����
     normative         varchar(35),  -- ����, ��
     length             int,     -- ����������, ��
     primary key (id)
);
-- ���������� ����  eqi_pillar_tbl
drop table eqi_pillar_tbl;       

create table eqi_pillar_tbl (
     id                int DEFAULT nextval('"eqi_devices_seq"'::text),     --* ��� ����
     type              varchar(35),  -- �����
     normative         varchar(35),  -- ����, ��
     materal           int,     -- ��� ���� ��������� materal_ind_tbl->materal
     name              varchar(80),  -- ��������
     primary key(id)
     , foreign key (materal) references eqk_materals_tbl (id)
);

-- ����� ���������� eqi_earth_tbl
drop table eqi_earth_tbl;

create table eqi_earth_tbl (
     id                int DEFAULT nextval('"eqi_devices_seq"'::text),     --* ��� ����
     type              varchar(35),  -- �����
     name              varchar(80),
     primary key(id)
);


-- ------------------------------------------------------------
-- ------------------------------------------------------------
-- ------------------------------------------------------------
-- ������������ �����������
-- ------------------------------------------------------------
-- ������������
drop table eqm_equipment_tbl;

 DROP SEQUENCE eqm_equipment_seq;

  CREATE SEQUENCE eqm_equipment_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqm_equipment_tbl (
     id             integer DEFAULT nextval('"eqm_equipment_seq"'::text),      --* ��� ������������ (������������� ����� ���.)
     type_eqp       int,     --+ i ��� ���� ������������ (eqi_devices_tbl->id)
     name_eqp       varchar(25),  --  ������������
     num_eqp        varchar(25),  --+ ��������� ����� ��������
     id_addres      integer,    --  i ����� ���������      (address_tbl->id)
     dt_install     timestamp,     --  ���� ��������� 
     dt_change      timestamp,     --  ���� ������
     loss_power     integer default 0, --  �� � ������� ������
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
--     inst_station   int,      --i ������� ��� �� ���������� (eqk_in_station_tbl->id)
     primary key (id)
--     , foreign key (id_addres)    references address_tbl (id)
     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
    
);

-- ��������
drop table eqm_meter_tbl;

create table eqm_meter_tbl (
     code_eqp       integer not null,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
--   ----------------------------------------------------------
      id_type_eqp    int null,     -- +1/ i ��� ����  (?_ind_tbl->id_type_eqp)
       dt_control     timestamp null,     --  ���� ���.�������
--       begin_count    integer null,      --  ��������� �� ������ ���������
--      d              numeric(5,4) null, -- 1/ ������������� ���������� ���������� ����. ���/���� (��������/�������������� ��������.) -- ��������� � ����� �����
       nm             varchar(255) null, -- 1/ ����������� ������������ ������� ���������
--       account        int null,     --i ������� �������      (saldo_tbl->account)
       main_duble     int null,      --  �����������, ������� �����������,
--      class          int null,      -- 1/ i ����� ����������   (eqk_voltage_tbl->class)
--       code_group     int null,      --i ��� ������ ������� (tariff_e_tbl->code_group) -- ��������� � ����� �����
--       count_lost     int null,      --  ������� ������  -- ��������� � ����� �����
       warm           int null,      --  ��������� � �������������� ��������� (1/0)
--       industry       int,           -- ������� -- ��������� � ����� �����

     count_met      int default 0, -- ���� ������� �� ������������ ������ ���������������� (0/1)
     met_comment    varchar(100) null, --����������� � ����. ����
     warm_comment   varchar(100),
     buffle         numeric(10,2) ,    -- ������ ���������������� �������� � %
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_meter_tbl (id)
);

-- ���� �������� eqm_meter_zone_tbl
drop table eqd_meter_zone_tbl;

create table eqd_meter_zone_tbl (
     code_eqp       integer,       --*i ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     dt_zone_install timestamp,     --*  ���� ��������� ����
     kind_energy     int,      --*i ��� ����������� ������� 
     zone            int,     -- ����� ���� 
     time_begin      numeric(4,2), --* ������ ���������
     time_end        numeric(4,2), --* ����� ���������

     primary key(code_eqp,kind_energy,zone,dt_zone_install)
     , foreign key (code_eqp) references eqm_meter_tbl (code_eqp)
     , foreign key (zone) references eqk_zone_tbl (id)
);
-- ------------------------------------------------------------------------
-- ���� �������
drop table eqd_meter_energy_tbl;

create table eqd_meter_energy_tbl (
     code_eqp       integer,       --*i ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     kind_energy    int,      --*i ��� ����������� ������� (��������/����������) (eqk_energy_tbl->kind_energy)
     date_inst      timestamp,      --*
     primary key(code_eqp,kind_energy,date_inst)
     , foreign key (code_eqp) references eqm_meter_tbl (code_eqp)
     , foreign key (kind_energy) references eqk_energy_tbl (id)
);
-- ------------------------------------------------------------------------
--if exists (select * from sysobjects where name='eqm_meter_client_tbl' and xtype='U')
--  drop table eqm_meter_client_tbl
--go
--create table eqm_meter_client_tbl(
--   id_client varchar(10),
--   kinde_meter int,
--   primary key(id_client)
--);
-- ------------------------------------------------------------------------
-- ���������������� ����������
drop table eqm_compens_station_tbl;

create table eqm_compens_station_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
--   ----------------------------------------------------------
     h_boxes          int,    --  �-�� ����� ������� �������
     l_boxes          int,    --  �-�� ����� ������ �������
     h_points         int,    --  �-�� ����������� ������� �������
     l_points         int,    --  �-�� ����������� ������ �������
     id_voltage       int,
     primary key (code_eqp)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
--     , foreign key (id_type_eqp)  references compens_station_ind_tbl (id_type_eqp)
);
-- ------------------------------------------------------------------------
-- ������
drop table eqm_fider_tbl;
create table eqm_fider_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
--   ----------------------------------------------------------
     id_voltage   int,    
     losts_coef   numeric(12,10) default 0,
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)

);

--  �������������� �� ���������������� ����������� � ���������
drop table eqm_compens_station_inst_tbl;

create table eqm_compens_station_inst_tbl (
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     code_eqp_inst   integer,      --* ��� ������������ (������������� ����� ���.)
     primary key(code_eqp,code_eqp_inst)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_inst)  references eqm_equipment_tbl (id)
);
-- -------------------------------------------------------------------------
-- ��������������
drop table eqm_compensator_tbl;

create table eqm_compensator_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_compensator_tbl (id)
--     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
--     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- �������������� ����
drop table eqm_compensator_i_tbl;

create table eqm_compensator_i_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_compensator_i_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- �����
drop table eqm_line_a_tbl;

create table eqm_line_a_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     length         int,     --  �������������,�
     pillar         int,     --i ��� �����            (eqi_pillar_tbl->id_type_eqp)
     pillar_step    int,     --  ��� �����,�
     pendant        int,
     earth          int,     --i ��� ����� ���������� (eqi_earth_tbl->id_type_eqp)
     id_voltage   int,    
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_corde_tbl (id)
     , foreign key (pillar)  references eqi_pillar_tbl  (id)
     , foreign key (pendant) references eqi_pendant_tbl (id)
     , foreign key (earth)   references eqi_earth_tbl   (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

--������
drop table eqm_line_c_tbl;

create table eqm_line_c_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     length         int,     --  �������������,�
     id_voltage   int,    
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_cable_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);
--  ������� ��������� �����   (��� ������ ������� � eqm_equipment_tbl)
drop table eqm_line_path_tbl;

create table eqm_line_path_tbl (
     code_eqp       integer,      --*i ��� ������������   (line_eqp_tbl->code_eqp)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     id_addres      integer,      --i ����� ���������      (address_tbl->id)
     pathorder      int default 0,
     primary key (code_eqp,id_addres)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
--     , foreign key (id_addres) references address_tbl (id)
);
-- ������������
drop table eqm_jack_tbl;

create table eqm_jack_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     quantity         int,       --  ����������
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_jack_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- �������������� ������������
drop table eqm_switch_tbl;

create table eqm_switch_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     folk           int,       --  ���������� ������
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_switch_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- ��������������
drop table eqm_fuse_tbl;

create table eqm_fuse_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  (?_ind_tbl->id_type_eqp)
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_fuse_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- ������� ��������
drop table eqm_borders_tbl;

create table eqm_borders_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_clientA     integer,   --i ������������� �������   (client_tbl->id_client)
     id_clientB     integer,   --i ������������� �������   (client_tbl->id_client)
     inf            varchar(255),  -- �������� ������� �� ���� ������������� ���������� ��������������
                                   -- ������� ��������������� 
     primary key(code_eqp)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_clientA) references clm_client_tbl (id)
     , foreign key (id_clientB) references clm_client_tbl (id)
--     , foreign key (id_clientA) references client_tbl (id_client)
--     , foreign key (id_clientB) references client_tbl (id_client)
);

-- ����� �����
drop table eqm_point_tbl;

create table eqm_point_tbl (
     code_eqp       int,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     power          numeric(14,3),  -- ������������� ��������
     id_tarif       int,      --i ��� ������ ������� (aci_tarif_tbl)
     industry       int,      -- ������� 
     count_lost     int,
     d              numeric(5,4) null, -- ������������� ���������� ���������� ����. ���/���� (��������/�������������� ��������.)
     wtm            int, --������� ����� �� ����� (�����)
     id_tg          int, -- ������ �� ���������� eqk_tg_tbl
     id_voltage     int,
     share          numeric (5,2), -- ������� ������������� ����������� ��� �������� 

     ldemand        numeric (14,2), -- ����������� �� ����. ������
     ldemandr       numeric (14,2), -- ����������� �� ����. ������ �������
     ldemandg       numeric (14,2), -- ����������� �� ����. ������ ���������
     pdays          int,            -- ���. ���� -.- 

     count_itr      int default 0, -- ���� ������� �� �������� (0/1)
     itr_comment    varchar(100) null, --����������� � ����. ����

     cmp            numeric (14,2), --�������� �������������� ���������
     zone           int,
     flag_hlosts    int,  -- ��������� ������ ���� ������ 
     id_depart      int,  -- ������������
     main_losts     int,  -- �� ������ ������ ��������� ��������
     lost_nolost    int default 0,  
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_tarif)  references aci_tarif_tbl (id)
     , foreign key (industry)  references cla_param_tbl (id)
     , foreign key (id_tg)  references eqk_tg_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
);

create table eqm_area_tbl (   --��������
     code_eqp       int,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_client      integer,   --i ������������� �������   
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_client) references clm_client_tbl (id)

);

-- ------------------------------------------------------------------------
-- ���� ������� ��� ���� �����
drop table eqd_point_energy_tbl;

create table eqd_point_energy_tbl (
     code_eqp       integer,       --*i ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     kind_energy    int,      --*i ��� ����������� ������� (��������/����������) (eqk_energy_tbl->kind_energy)
     dt_instal      date,      --*
     primary key(code_eqp,kind_energy,dt_instal)
     , foreign key (code_eqp) references eqm_point_tbl (code_eqp)
     , foreign key (kind_energy) references eqk_energy_tbl (id)
);
-- ------------------------------------------------------------------------

-- ������ ���� ����������� (������ ��������)
drop table eqm_tree_tbl;

 DROP SEQUENCE eqm_tree_seq;

  CREATE SEQUENCE eqm_tree_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqm_tree_tbl (
     id       int not null DEFAULT nextval('"eqm_tree_seq"'::text),            --* �������������� ����� �����������
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     name     varchar(35),
     code_eqp integer ,
     tranzit        int default 0,             -- 0-not/[1..level]-yes
     id_client      integer not null,-- references client_tbl(id_client), --* ������������� �������
     file_path varchar(255); 
     primary key(id),
     foreign key (code_eqp)  references eqm_equipment_tbl (id),
     foreign key (id_client) references clm_client_tbl (id)
--     , foreign key (id_client)  references client_tbl (id_client)
);

-- -----------------------------------------------------------------------
-- ���������� ������������� ����  eqm_eqp_tree_tbl
drop table eqm_eqp_tree_tbl;

-- ����� ����� =0 ��� ���� �����, ����� ����� ����� ���������, 
-- ��� ��� �� ���� �� autoinc.
-- ������� ����� ���� ������ � ����� � ����� ����� =0
-- ���������� ������� ��� ����� =0, ��� ��������� �� 1, ����� ����� ���������
create table eqm_eqp_tree_tbl (
     id_tree    int not null,         --i ��� ����� ����� �����������
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     code_eqp   integer not null,   --*i ��� ������������ (������������� �����
                          -- ��������� � ����, ��������� � �������� ���� ����)
                          -- (*_eqm_equipment_tbl->code_eqp)
     code_eqp_e integer NULL,          --i ��� ������������ parent!
                          -- (*_eqm_equipment_tbl->code_eqp)
     name       varchar(50),                 -- �������� ����������� �� �����
     tranzit    int,                     -- �-�� �����������
     lvl        int,
     parents    int,       -- ���. ������� 
     line_no    int default 0,       -- ����� ����� (����� ����� ����)

--     terminal   int default 0,           -- 1 - leave //���� ������� ������
     primary key(id_tree,code_eqp,line_no)
     , foreign key (id_tree)  references eqm_tree_tbl (id)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_e)  references eqm_equipment_tbl (id) 
);
/*
--��������������� ������� �������� � ������� (�������� �� �����)

drop table eqm_schema_parents_tbl;

create table eqm_schema_parents_tbl (
     code_eqp_b integer not null,  --*i ��� ������������
     code_eqp_e integer not null,  --*i ��� ������������ ������
     primary key(code_eqp_b,code_eqp_e)
     , foreign key (code_eqp_b)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_e)  references eqm_equipment_tbl (id)
);

drop table eqm_schema_child_tbl;

create table eqm_schema_child_tbl (
     code_eqp_b integer not null,  --*i ��� ������������
     code_eqp_e integer not null,  --*i ��� ������������ �������
     primary key(code_eqp_b,code_eqp_e)
     , foreign key (code_eqp_b)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_e)  references eqm_equipment_tbl (id)
);
 */
-- ������ ������������
 drop table eqm_change_tbl;
 DROP SEQUENCE eqm_change_seq;

  CREATE SEQUENCE eqm_change_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

 DROP SEQUENCE eqm_change_oper_seq;

  CREATE SEQUENCE eqm_change_oper_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqm_change_tbl (
     id              integer not null DEFAULT nextval('"eqm_change_seq"'::text),   --   *id
     mode            int,  --   ����� (��� ���. ��������� 1/� ���. 2/�������� ������ 3/���.���. ������ 4/���(��������). ���. ������������ ������ ����. 5)
                                ----              equipment  /eqp_tree/tree
     id_client       integer,   --   i ��� ��������(1-4 ���������, 5 -������������)
--     id_tree         int,  --   i ��� ����� ����� �����������
     date_change     timestamp,  --   ���� ������ 
     dt              timestamp,  --   ���� �������� ������ (�����������)
     id_usr          int,  --i ��� ���������� ������������ ������ (person_workers_tbl->code_person)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
     primary key(id)
     , foreign key (id_client) references clm_client_tbl (id)
--     , foreign key (id_tree)  references eqm_tree_tbl (id)
--     , foreign key (id_usr)  references client_tbl (id_client)
);


drop table eqa_change_tbl;

create table eqa_change_tbl (
     id_change       integer not null,  -- *id
     id_record       oid,               -- *oid
     id_table        int ,              -- ��� ������� (NEW!!!)
     code_eqp        integer ,  -- i ��� ������������
--     line_no         int           -- ����� ����� (NEW!!!) 
     -- ����� ����� �����������, ��� ��� ��� ������� � ����� ������ ����
     -- ����������� ������ ��������� � ������ �������� ������ �� ��� 
     -- ���������� ������, � ������ ��������� ���������
     -- � OID �����!!!!!!!!!
     id_tree         int,  	-- i ��� ����� ����� �����������
     idk_operation   int,  	-- ��� �������� (��������� 0/�������� 1)
     id_department  int default syi_resid_fun(),      -- ��� ������������ �������������
     primary key(id_change,id_record)
     , foreign key (id_change)  references eqm_change_tbl (id)
--     , foreign key (id_tree)  references eqm_tree_tbl (id)
--     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_table)  references syi_table_tbl (id)
);

drop table eqd_change_tbl;

create table eqd_change_tbl (
        id_change  int,      -- *id
--        id_table   int ,     -- *��� �������
        id_field   int ,     -- *����
        id_record  oid,     -- *oid
        old_value  varchar,  -- ������ ��������
        id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
--        idk_operation   int,  --  ��� �������� 
     primary key(id_change,id_field,id_record)
--     , foreign key (id_table)  references syi_table_tbl (id)
     , foreign key (id_field) references syi_field_tbl (id)
     , foreign key (id_change)  references eqm_change_tbl (id)
);

--create table eqm_eqp_change_tbl (
--     code_eqp          integer,   --*i ��� ������������   
--     date_change     timestamp,  --*i ���� ������
--     id_type_eqp_o int,   --i ��� ���� (������)
--     num_eqp_o     varchar(25),-- ��������� ����� (������)
--     id_type_eqp_n int,   --*i ��� ����                   .
--     num_eqp_n     varchar(25),--i ��������� �����
--      --(������������� ����� ��������� � ����, ��������� � �������� ���� ����)
--     id_department     int,   --i ��� ������������ �������������  (client_tbl->id_department)
--     id_person         int,   --i ��� ���������� ������������ ������ (person_workers_tbl->code_person)
--     primary key(code_eqp,date_change)
--     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
--);

-- -------------------------------------------------------------
drop table eqm_eqp_use_tbl;

create table eqm_eqp_use_tbl(
	code_eqp       int,   --*i ��� ������������   
	id_client      int,   --*i ������������� �������
        dt_install     date,
	primary key(code_eqp,id_client,dt_install)
     , foreign key (id_client) references clm_client_tbl (id)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
);

-- ���������� ��������� ��������������
drop table eqi_des_tbl;
create table eqi_des_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* ��� ���� 
     type         varchar(35),   -- ��� 
     normative    varchar(35),   -- ����, ��
     primary key(id)
);

-- ���
drop table eqm_des_tbl;

create table eqm_des_tbl (
     code_eqp       integer,      --* ��� ������������ (������������� ����� ���.)
     id_department  int default syi_resid_fun(),          --  ��� ������������ �������������
-- -----------------------------------------------------------
     id_type_eqp    int,     --i ��� ����  
     power          int,     -- ��������
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_des_tbl (id)

);
