
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


INSERT INTO syi_table_tbl (id,name,id_base) values (30,'eqi_des_tbl',1);
INSERT INTO syi_table_tbl (id,name,id_base) values (31,'eqm_des_tbl',1);

INSERT INTO eqi_device_kinds_tbl (id, name, id_table_ind, id_table, calc_lost, inst_station) VALUES (16, '��������� ��������������', 30, 31, 0, 0);
INSERT INTO eqi_device_kinds_prop_tbl (type_eqp, id_icon, form_name) VALUES (16, 13, 'TfSimpleEqpDet');