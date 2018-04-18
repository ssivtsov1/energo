;
set client_encoding='WIN';

/*
 drop table rep_kinds_tbl;
 create table rep_kinds_tbl (
  id int,
  ident varchar(25),
  id_group int,
  name varchar(25),
  full_name varchar(256),
  file_name varchar(25),
  proc_name varchar(25),
  flag_param int,        -- 123 (����) 1-����, 2-������, 3 -������� ... 
  primary key(id)           
);

*/
  CREATE AGGREGATE sum ( BASETYPE = text,
                         SFUNC = textcat,
                         STYPE = text,
                         INITCOND = '' );


--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name) VALUES (1, 'oborot', 1, '�������� �i���i��� ��', ' �������� �i���i��� ���������� �� ������� ������������i�', 'oborot.rpt', 'ObSaldo');
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name) VALUES (2, 'sales', 1, '���i��� ����. ����. ��', ' ���i��� ��� �������� ����i���i� �� ������� �����i�', 'sales.rpt', 'Sales');


--alter table rep_kinds_tbl alter column name TYPE varchar(50);

delete from rep_kinds_tbl;

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (100, '_gr', NULL, '�������', '�������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (101, 'oborot', 100, '�������� �i���i���', '�������� �i���i��� ���������� �� ������������i�', 'oborot.xls', 'ObSaldo',10);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (102, 'oborot_r', 100, '�������� �i���i��� ��', '�������� �i���i��� ���������� �� ��������� ������������i�', 'oborot.xls', 'ObSaldo',2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (103, 'oborot_nds', 100, '�������� �i���i��� � ���', '�������� �i���i��� ���������� �� ������������i� (���������� �� ���)', 'oborot_nds.xls', NULL,10+128);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (104, 'oborot_err', 100, '�����i��� ������. �i���.', '����� ������� � �������i� �i���i��i ���������� �� ������������i� (���������� �� ���)', 'oborot_err.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (105, 'oborot_5kr', 100, '�������� �i���i��� 2�� ����', '�������� �i���i��� ���������� �� ������������ �i������� ����� �� ����������� �����i���� �����i� ���������� ������������i� ', 'oborot_5kr.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (106, 'oborot_2kr2014', 100, '�������� �i���i��� 2�� 2014', '�������� �i���i��� ����� �� ����������� �����i���� �����i� ���������� ������������i� (�� �����i)', 'oborot_2kr2014.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (107, 'oborot_1', 100, '�������� �i���i��� ����.', '�������� �i���i��� �� ��������. ', 'oborot_1.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (109, 'oborot_akt', 100, '��������  �� ����� ', '��������  �� ����� �� ��������� ������ ����������', 'oborot_akt.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (114, 'sales', 100, '���i��� ����. ����.', '���i��� ��� �������� ����i���i� ', 'sales.xls', 'Sales',10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (115, 'sales_abon', 100, '���i��� ����. ����. ����.', '���i��� ��� �������� ����i���i� ���������� �� ���������', 'sales_abon.xls', null,10+1024);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (115, 'sales_r', 100, '���i��� ����. ����. ��', '���i��� ��� �������� ����i���i� �� ��������� �����i�', 'sales.xls', 'Sales',2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (116, 'oborot_short', 100, '�������� �i���i��� (����)', '�������� �i���i��� �� 1 ����i���', 'oborot_sh.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (117, 'f24', 100, '����� 24 ������', '����� 24 ������. ���������� ������������i� �� �i�i���������.', 'f24.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (118, 'NDS', 100, '��i� �� ���', '��i� �� ��� (�� ������� 2011 ���� �������).', 'nds.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (119, 'NDS2011', 100, '��i� �� ���(��i���� 2011)', '��i� �� ��� (� ��i��� 2011 ����).', 'nds2011.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (120, 'NDS2016', 100, '��i� �� ���(2016)', '��i� �� ��� -  2016 ���� ', 'nds2016.xls', NULL,10);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (121, 'NDS2016_inf', 100, '��i� �� ���(�����i���i� 2016)', '�����i���i� ������ �� ����������� 2016 ���� �� ��������i� ���i��i� (��).', 'nds2016_billpay.xls', NULL,10);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (122, 'abon_volt', 100, '���������� �� ������i', '���������� ������������i� �� �i���� �������.', 'abonvolt.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (123, 'abon_dep', 100, '���������� �� �i�i��.', '���������� ������������i� �� �i�i��������� .', 'abondep.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (124, 'abon_grp', 100, '���������� �� ������.', '���������� ������������i� �� ������ ��������i� .', 'abongrp.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (125, 'prognoz', 100, '�������.', '����i� �����i� ��������� �i������.', 'prognoz.xls', NULL,130+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (126, 'oborot_year', 100, '���������� �� �i�', '�������� �i���i��� (���������� �� �i�)', 'oborot_year.xls', Null,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (127, 'point_dem_year', 100, '���������� �� �i� �� ��.', '���������� �� �i� �� ������ ���i��', 'point_dem_year.xls', Null,2+8);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (128, 'abon_extra', 100, '���������� �� ���.����������', '���������� ������������i� �� ���������� ���������� ���i�i�.', 'abonextra.xls', NULL,10);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (13, 'abon_saldo', 10, '������ ��������', '��i� ��� ������ ��������', '', '',3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (200, '_gr', NULL, '���������� i�������i�', '���������� i�������i�', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (201, 'clientlist', 200, '�����i� �������i�', '�����i� �������i�', 'clientlist.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (202, 'ind_now', 200, '������i ������ ��i�� ', '�����i� �������i�, �� ������i ������ ��i� ��� ���������� �� ������� ����', 'ind_now.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (203, 'ind_dates', 200, '���� ������� ��i�i� ', '�����i� �������i� �� ����� ������� ��i�i� ��� ���������� ', 'ind_dates.xls', NULL,16384+1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (204, 'ind_debtor', 200, '�� ������ ������ ��i�� ', '�����i� �������i�, �� ������ �� ������ ��i� ��� ����������', 'IndicDebtor.xls', NULL,16384+1024+6);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (205, 'bill_debtor', 200, '���������i �������', '�����i� �������i�, �� ����� ���������i ������ �������', 'bill_debtor.xls', NULL,1024+12);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (206, 'bill_list', 200, '������� �� ���i��', '������� �� ���i��', 'billist.xls', NULL,16384+1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (207, 'pay_list', 200, '������ �� ���i��', '������ �� ���i��', 'paylist.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (208, 'pay_abon', 200, '������ �� ������', '������ �� ������ ��������i�.', 'payabon.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (209, 'debet_list', 200, '�i���i��� ���i���i�', '�i���i��� ���i���i�', 'debetlist.xls', NULL,1024+30);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (210, 'kt_list', 200, '�i���i��� ��������i�', '�i���i��� ��������i�', 'debetlist.xls', NULL,1024+30);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (211, 'nodemand', 200, '������� ����������', '��������, �� ����� ������� ����������', 'nodemand.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (212, 'metnodemand', 200, '�i�������� ��� �����.', '�i��������, �� �� ����� ��������i�.', 'metnodemand.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (213, 'abon_count', 200, '�������i��� �������i�', '��i� ��� �������i��� �������i�.', 'abon_count.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (214, 'pointlist', 200, '�.���i�� ��������', '�������������� ����� ���i�� ���������� �����i� ��������.', 'pointlist.xls', NULL,5);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (215, 'switch_new', 200, '�i���������(���i)', '���� �������i� (�i���������) ���� ��������.', 'switchlistnew.xls', NULL,1024+0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (216, 'switch_period_new', 200, '�i��������� �� ���i�� (���i) ', '��i�� ����� �������i� (�i���������) �� ���i��. ���� ��������', 'switchlistnew.xls', NULL,1024+2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (217, 'switch', 200, '�i���������(����)', '���� �������i� (�i���������).', 'switchlist.xls', NULL,1024+0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (218, 'switch_period', 200, '�i��������� �� ���i��(����) ', '��i�� ����� �������i� (�i���������) �� ���i��.', 'switchlist.xls', NULL,1024+2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (219, 'prognozpay', 200, '��������i �������', '���������� ��� ���������� ������.', 'prognozpay.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (220, 'progpayadd', 200, '���������� �������', '���������� ��� ���������� ������ � ����������� �����.', 'progpayadd.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (221, 'progpayad5', 200, '������� �� 5 �������', '���������� ��� ������ � ����������� ����� �� 5-�� ������', 'progpayadd5.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (222, 'progpaydem', 200, '������� c �������', '���������� ��� ������ � ����������� ����� �� 5-�� ������', 'progpaydem5.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (223, 'empty_ind', 200, '������i ��i��', '������i ��i�� ��� ���������� �� �������i �������.', 'empty_ind.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (224, 'avg_area_dem', 200, '������.������. �� ����.', '���������i����� ���������� �� ����������� �� 6 �i�.', 'avg_area_dem.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (225, 'avg_area_dem12', 200, '���.����.�� ����.12 �i�', '���������i����� ���������� �� ����������� �� 12 �i�.', 'avg_area_dem12.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (226, 'compens_cnt', 200,  '������������.�����.< 5%', '������������  ������������i� �� ���i���.', 'compens_cnt.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (227, 'abonfider_compens', 200,  '������.�����.<5%(2 �i�)', '���i� ������������� ������������i� ��� ���������i ����� 5% �������������i ���i������ �������������� (�������� �� ��������i� ���i���).', 'abonfider_compens.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (228, 'doc_revis', 200,  '������������� �������i�', '��i� �� ������������� �������i�', 'doc_revis.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (229, 'check2kr', 200,  '����������,�i�i�� �� 2��', '�i�i�� ���������� ������� �����i� �� �������� ����������', 'check2kr.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (230, 'check2kr_area', 200,  '�����i��� ������i� �� 2��', '�����i��� ��������i ������i� �� ����������� �i�i�� ����������', 'check2kr_sum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (231, 'check2krNoLimit', 200,  '���������� ��� �i�i�i�', '���������� �������i�, ��� ���� �� ������� �i�i� ����������', 'check2kr_nolimit.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (232, 'abonpower', 200, '������i��� �������i�', '�����i� �������i� (��������� ������i���)', 'clientlist_power.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (233, 'abonpointpower', 200, '�������� ������i��� �� ��`�����', '����� ���i�� �������i� (�������� ������i���)', 'clientpointlist_power.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (234, 'unif_fiz', 200, '������ �������', '�����i� �����i� � ����i�i ����������i� - �������i� ������� �������', 'unif_fiz_sum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (235, 'point_procent', 200, '��i�� ���������� �� �� %.', '��i�� ���������� �� ������ ���i��', 'point_dem_procent.xls', Null,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (236, 'debet_pay', 200, '��������� �����.������.', '��������� ����������� �������������i', 'debet_pay.xls', Null,2+8);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (237, 'oborot_1_all', 200, '������ ��������i� ���i�.', '������ ��������i� ���i�.', 'kt_years_all.xls', NULL,10+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (238, 'old_kt', 200, '������������i ������i', '�������i�����i ������������i ������i. ����i�� ����, � ��� ������� ������i �������i�������� ', 'old_kt.xls', NULL,4+8+4096);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (300, '_gr', NULL, '������', '������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (301, 'f32', 300, '����� 32 ������', '����� 32 ������. �������� ������ ��������������', 'f32.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (302, 'for4nkre', 300, '��� 4 ���� ', '�������� ������ �������������� �� �������� ������� � ������� ����������', 'for4nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (303, '4nkre', 300, '4 ���� ', '����� 4 ����.', '4nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (304, 'abon_tar', 300, '���������� �� �������', '���������� ������������i� �� �������.', 'abontarif.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (305, 'all_tar', 300, '����� ���i�� �� �������', '�����i� ����� ���i�� �� ���������� ������������i� �� �������.', 'abonalltarif.xls', NULL,518);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (306, 'abontar_2month', 300, '���i������ ����. �� ���.', '���i������ ���������� ������������i� �� �������.', 'abon_tar_2month.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (307, '9nkre_d1', 300, '9 ���� ���.1', '������� 1 �� 9 ����. �������i ������.', '9nkre_d1.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (308, '9nkre_d2', 300, '9 ���� ���.2', '������� 2 �� 9 ����. ���i�i��i �����i���i�.', '9nkre_d2.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (309, '9nkre_d3', 300, '9 ���� ���.3', '������� 1 �� 9 ����. ������� ���i����i���� �������.', '9nkre_d3.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (310, '8nkre', 300, '8 ����', '����� 8 ���� (������� 1-3)', '8nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (311, 'nasp_demand', 300, '�� �����. �� ���. �������', '���������� �� �������� ��������� �� ���.�����i�', 'nasp_demand.xls',NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (312, 'common_account', 300, '�����.�� ��������� �i�.', '���������� ���������, ��� ������������� �� ��������� ������� ���i��', 'common_account.xls',NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (313, 'own_needs', 300, '�����i �������', '���i��� ��� ������������ ������������i� �� ���������i �������', 'own_needs.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (400, '_gr', NULL, '���.������', '���.������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (401, 'tar_3zon', 400, '���������� �� �����', '���������� �� ������� i ����� ��� 3-������ �i�������i� ', 'tar_3zon.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (402, 'met_3zon', 400, '���������', '���������� ���� ���������i� ����� �i� ��i������� ���������� ��. �����i� �� ���. �������� ', 'met_3zon.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (403, 'tar_2zon', 400, '�������i', '���������� �� ��������� ���i��� ', 'tar_2zon_new.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (404, 'met_3zonfiz', 400, '�������i (�i�)', '���������� ���� ���������i� ����� �i� ��i������� ���������� ��. �����i� �� ���. �������� ���������', 'met_3zonfiz.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (405, 'tar_2zonfiz', 400, '�������i (�i�)', '���������� �� ��������� ���i��� �� ���. �������� ���������', 'tar_2zonfiz.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (406, 'lighting', 400, '���i������', '���������� ���� ���������i� ����� �i� ��i������� ���������� ��. �����i�,��� ��������������� ��� ���������� ���������.', 'lighting.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (414, 'lost_nolost', 400, '������i/���������i', '��������� ��������� �i������ (������i/���������i)  ', 'lost_nolost.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (415, 'abon_volt_lst', 400, '���������� �� ���/������.', '���������� ������������i� �� ��������i ��������� �i������.', 'abonvoltlst.xls', NULL,10+8192);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (416, 'rep_forEN', 400, '��i� ��� �������������', '��i� ��� ������������� ', 'repforen.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (417, 'rep_forENR', 400, '��i� �� �����.�i�����.', '��i�  �� ���������� �i���������', 'repforenR.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (418, 'zone_meters', 400, '���������� �� ������ �i�.', 'I�������i� ���� �����i� ���������� �� ����������, ��i �������������� �� ��������, ��������i������� �� ���i����� ����', 'zone_meters_all.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (500, '_gr', NULL, '���������� ���i�', '���������� ���i�', NULL, NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (501, 'tax_book', 500 , '����� ���i�� �������', '����� ���i�� ������� ', 'tax_book.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (502, 'tax_list', 500 , '������ ��', '������ ���������� ��������� ', 'taxlist.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (503, 'tax_listgrp', 500 , '������ �� � �������', '������ ���������� ��������� ', 'taxlistgrp.xls', NULL,10);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (504, 'tax_reestr', 500 , '��e��� ��', '��e��� ���������� ��������� ', 'tax_reestr.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (505, 'tax_reestr_2010', 500 , '��e��� �� (2010)', '��e��� ���������� ��������� (� �i��� 2010 �.)', 'tax_reestr2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (505, 'tax_reestr_2011', 500 , '��e��� �� (2011)', '��e��� ������� �� ��������� ���������� ��������� (� �i��� 2011 �.)', 'tax_reestr2011.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (506, 'tax_reestr_fast', 500 , '��e��� �� (��� 1�)', '��e��� ������� �� ��������� ���������� ��������� (��� ������������ � 1� ���������i�)', 'tax_reestr2011s.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (507, 'freetaxnum', 500 , '��������i ������', '�����i�  ���������� �����i� ���������� ��������� ', 'freetaxnum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (508, 'taxcheck', 500 , '�����i���', '�����i��� ���������� ��������� ', 'taxchecklist.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (509, 'taxcheckdecade', 500 , '�����i��� �� �������', '�����i��� ���������� ��������� �� ������� (2015 �.)', 'taxchecklist_decade.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (510, 'taxcheckstr', 500 , '�����i��� ����i� ��', '�����i��� ���������� ��������� �� �i����i��i��� ���� � �����i �� ��� � �������i� ������i ��', 'taxcheckstr.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (511, 'taxchecknopay', 500 , '�����i��� �� ���������i�', '�����i��� �i��������� ���������� ��������� �� ����������� ���', 'taxchecknopay.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (512, 'tax_list_abon', 500 , '�� ��������', '������ ���������� ��������� �������� �� ���i��', 'taxlist_abon.xls', NULL,1+2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (510, 'tax_nds_err', 500 , '�i����� ���', ' �i����� ������������� �� ���������� ��� � ���������� ��������� ', 'tax_nds_err.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (513, 'taxcor_reestr', 500 , '�����i� ���������� (������� 1)', '�����i� ���������� ���������� ��������� (��� ������������ � 1� ���������i�)', 'taxcor_reestr.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (600, '_gr', NULL, '���� ���i�', '���� ���i�', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (601, 'akt1', 600 , '��� ��i���.', '��� ��i��� ���������i� ', 'akt1.xls', NULL,13);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (602, 'bill_saldo', 600, '���i��� �� ����.', '���i��� ��� ���� ���������i�', 'bill_saldo.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (603, 'akt2', 600 , '��� ��i��� (����.).', '��� ��i��� ���������i� ��� ��������� ��������i� ', 'akt2.xls', NULL,13);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (604, 'akt3', 600 , '��� ��i��� (3 ���.).', '��� ��i��� ���������i� (�� ���. �������) ', 'akt3.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (605, 'akt_2z', 600 , '��� ��i��� (2 ���.).', '��� ��i��� ���������i� (�� 2 ������ ���. �������) ', 'akt_2z.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (606, 'akt4', 600 , '��� �� ���i����.', '��� ��i��� ���������i� (�� ���i����) ', 'akt4.xls', NULL,15);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (607, 'akt4list', 600 , '��i��� �� ���i����.', '��i��� ���������i� (�� ���i����) ', 'akt4list.xls', NULL,4+8);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (608, 'akt5', 600 , '��� ��i��� (���������)', '��� ��i��� ���������i� (�������� i�������i� �� �������� �� �����i) ', 'akt5.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (609, 'akt_tr', 600 , '��� ��i��� (��.������.)', '��� ��i��� ���������i� (�� �i������ �����������������) ', 'akt_trans.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (610, 'akt_him', 600 , '��� ��i��� (�i�. ����.)', '��� ��i��� ���������i� (�� �i�i��i� ������������i) ', 'akt_him.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (611, 'akt_osv', 600 , '��� ��i��� (���.���.)', '��� ��i��� ���������i� (������� ���i������) ', 'akt_osv.xls', NULL,3);



INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (700, '_gr', NULL, '�i���������', '��i�� ��� �i��������� �������i� �� �����i ���', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (701, 'abonfider', 700 , '�i�������i ��������.', '�������� ���������i �� �i���� �i���������. ', 'abonfider.xls', NULL,96);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (702, 'abonfider_mem', 700 , '�i�������i ��������(MEM)', '�������� ���������i �� �i���� �i��������� (���i��� ��� ����i�i������ ���). ', 'abonfider_mem.xls', NULL,96+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (703, 'abonfider_inf', 700 , '�i�����.�������� ����.', '�������� ���������i �� �i���� �i��������� (�������� i�������i� �� ������ �� �i���������). ', 'abonfider_info.xls', NULL,32+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (704, 'psfider_mem', 700 , '���i����� ���������(MEM)', '���i����� ��������� ����� � �i���i��� �i��������� �������i�. ', 'psfider_mem.xls', NULL,32+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (705, 'abonnofider', 700 , '���i�������i ��������.', '��������, �� �i�������i �� �����i ���. ', 'abonnofider.xls', NULL,64);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (706, 'abonps', 700 , '�� �i������i��.', '��������,  �i�������i �� �i�����i� (������i���). ', 'abonps.xls', NULL, 288);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (707, 'fizabonfiderdem', 700 , '������. ��������� �� ��', '���������� ��������� �� �i���� �i���������. ', 'fizabonfiderdem.xls', NULL,34);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (708, 'border', 700 , '������� � ���', '�����i� �������i�, �� �i�������i ������������� �� ����� ���.', 'border.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (709, 'abonconnect', 700 , '�����i��� �i�. ��i�', '�����i� �������i� � �i���� �i��������� ', 'abonconnect.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (710, 'pointnometer', 700,'��� ������i� ���i��', '�����i� ����� ���i�� �� ���������� ��������� ���i�� ', 'pointnometer.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (711, 'rep_con_abon', 700,'���i �i���������', '��i� �� ����� �i��������� ���������', 'newconnect.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (712, 'border2', 700 , '�� ����� ����������i�', '�����i� �������i�, �� ����� ����������i�.', 'border2.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (713, 'subabons', 700 , '�����i� ����������i�', '�����i� �������i� � �������������.', 'subabons.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (714, 'master_demand', 700,'����� �������i �������.', '����� �������i ������������ii ������������ ', 'client_masterdemand.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (715, 'homenets_demand', 700 , '�����i�������. �����i', '������ ����������� �� ���������� ������������i� � �������������������� ������� .', 'homenets.xls', NULL,2+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (716, 'homenet_lines', 700 , '�i�ii �����i�������.�����', '��������� ��������� �i�i� � �������������������� ������� .', 'homenet_lines.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (717, 'prognoz_fider', 700 , '����-��������', '����-�������� (����� ����������� ������i ��������� ������� � ������� "�������" -"�������� ����������" )', 'prognoz_fider.xls', NULL,2+32+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (718, 'fact_fider', 700 , '��������� �����', '�������� ��������� �����-�������� (����� ����������� ������i ��������� ������� � ������� "�������" -"�������� ����������" )', 'prognoz+fact_fider.xls', NULL,2+32+1024);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (719, 'fact_fider_insp', 700 , '��������� ����� (�i������)', '�������� ��������� �����-�������� ', 'prognoz+fact_insp.xls', NULL,2+32+1024);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (720, 'fidersdemand', 700 , '���������� �� ��', '���������� �������� �� ������ ���i�� �� �i���� �i���������', 'abonfider_dem.xls', NULL,1+2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (721, 'ps10_load', 700 , '������������ ��10/0.4', 'I�������i� ���� ������������ �� ������� ���������i ���������������� �i������i� 10/0.4 ��', 'ps10_load.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (722, 'ps10_rezerv', 700 , '������ ������.��10/0.4', 'I�������i� ���� ������� ���������i ���������������� �i������i� 10/0.4 ��', 'ps10_rezerv.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (723, 'ps35_load', 700 , '������������ ��110-35/10', 'I�������i� ���� ������������ �� ������� ���������i ���������������� �i������i� 110-35/10 ��', 'ps35_load.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (724, 'ps35_rezerv', 700 , '������ ������.��110-35/10', 'I�������i� ���� ������� ���������i ���������������� �i������i� ��110-35/10 ��', 'ps35_rezerv.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (725, 'switch_list', 700 , '�������i��� ����������', '�����i� �������i����� ����������', 'switch_list.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (726, 'ps35_summary', 700 , '�i���i��� ����. �� ��110-35/10', 'I�������i� ���� c�������i� ���������� �����i� � ����''����� �� �� �i������i� 110/35/10 ��, 110/10 �� �� 35/10 ��', 'ps35_abon_summary.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (727, 'compens_tp_abon', 700 , '�������������� ������������ ��', '�������������� ������������ ��', 'compens_tp_abon.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (728, 'ps10_demand', 700 , '���������� �� ��10/0.4', '���������� �� ���������������� �i������i�� 10/0.4 ��', 'ps10_demand.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (729, 'abonfider04', 700 , '�i��������� �� �0.4', '�������� ���������i �� �i���� �i��������� (� ����������� �i�i� 0.4 ��). ', 'abonfider_04.xls', NULL,96+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (730, 'abonfider04sum', 700 , 'I�������i� �� �0.4', 'I�������i� ���� ������������ �i�i� 0.4 ��. ', 'abonfider_04_sum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (731, 'psfider_new', 700 , '�i� �������� �� �i���.', '�i���i��� �i��������� �������i� (�i� ��i�). ', 'psfider_new.xls', NULL,32+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (732, 'psfider_dem', 700 , '������ �i�.���� �� �i���.',  '�i��� ���������� �i��������� �������i� (�i� ��i�). ', 'psfider_dem.xls', NULL,32+2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (800, '_gr', NULL, '��������i', '��������i ��i��', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (801, 'r_f32', 800, '4 ���� ��', '�������� ��������� ������������i� �� �������� ������ ', 'r_f32.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (802, 'r_f49', 800, '����� 49 ������', '����� 49 ������', 'r_f49.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (803, 'r_compens', 800, '���������i� �����.', '��i� �� ���������i� ����� �i� �������i� ��������� ������������i� ', 'r_compens.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (804, 'reactiv_2010', 800, '���������� �� ��.', 'I�������i� ���� ���������i� ����� �� �����i����� ��������� ������������i�', 'reactiv2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (805, 'reactiv_2014', 800, '������. �� �������i� �� �� ��.', '���������� �� �������i� �� �� ������ ���i�� �� ���i��', 'reactiv2014.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (900, '_gr', NULL, '�i��������', '�i��������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (901, 'meterlist', 900, '�����i�', '�����i� �i�������i� � ����� ���i���.', 'meterlist.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (902, 'meter_indications', 900, '������i ���������', '������i ��������� �i�������i� .', 'meter_indication.xls', NULL, 1+4+32+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (903, 'metercheck', 900, '����i��� ���i��� (���i��)', '�����i� �i�������i�, ���� ����i��� ���i��� � ��������� ���i��i.', 'meterchecklist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (904, 'meterchecklate', 900, '����i��� ���i���(����)', '�����i� �i�������i�, �� ���� ������� ���� ���i���.', 'meterchecklist2.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (905, 'worm_meters', 900, '�i�.� ������������� ����i����i', '���������� �� �i���������, ������������ � ������������� ����i����i.', 'worm_meter.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (906, 'print_tt', 900, '���i�������i ��.', '���������� �� ���i��������� ���������������.', 'tt_demand.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (907, 'inspect_control', 900, '���������i �����', '��i� �� ������������ ����� ��������i�.', 'inspectcontrol.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (908, 'meter_unchecked', 900, '���� �����. ����i�', '�����i� �i�������i�, �� ���� �� ���������� ����������� ���� ��������i�', 'meter_unchecked.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (909, 'meter_change', 900, '���i�� �i�������i�', '���i�� �i�������i� �� ���i��', 'meter_changes.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (910, 'meter_change2', 900, '���i�� (���i���)', '���i�� �i�������i�, ���� ����i��� ���i���.', 'meter_changes2.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (911, 'meter_change_avgdem', 900, '����i �i��������', '����i �i�������� �� ���i��', 'meter_changes_avgdem.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (912, 'meter_indic_hist', 900, 'I����i� �i�������i�', 'I����i� ������ ��������i� �� i���� ���i� �i�������i� �� ���i��', 'meter_indic_hist.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (913, 'bad_indic_list', 900, '�������� ��������', '�����i� �i�������i�, �� ���� �������i ����i����i��� �������� �������� � ������������', 'bad_indication.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (914, 'dub_meterlist', 900, '����� ����i�', '����� ����i� �����i� �i�������i�.', 'meterdubl.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (915, 'metnodemand3', 900, '��� ���������� >2 �i�.', '�i��������, �� �� ����� ��������i� ��� ����� ������� ���������� �i���� 2 �i���i�.', 'metnodemand3.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (916, 'meter_area_dem', 900, '������.�� �i�./����.', '���������� �� �i��������� �� ����������� �� �i�.', 'meter_area_dem.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (917, 'meterlistavg', 900, '�����i�+���������� ', '�����i� �i�������i� �� ������ ����������.', 'meterlistavg.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (918, 'ttchecklate', 900, '����i��� ���i��� ��', '�����i� �i�������i�, �� ���� ������� ���� ���i��� ���i��������� �������������i�.', 'ttcheck_date.xls', NULL,4+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (919, 'meter2_5', 900, '�i�. ����� �������i 2.5', '�����i� �i�������i�, ��i ����� ���� �������i 2.5 (����-������)', 'meter2_5list.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (920, 'meter_tt_check', 900, '����i��� ���i���(������)', '�����i� ���i�i�, �� ���� ������� ���� ���i��� �i�������i� ��� ���i��������� �������������i� (����-������).', 'meterchecklist_new.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (921, 'tt_summary', 900, '�i���i��� �� �� ������', '�i���i��� ���i��������� �������������i� ������ �� ������.', 'tt_summary.xls', NULL,4);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1000, '_gr', NULL, '����i����i', '����i����i', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1001, 'gor1', 1000, '����� (�������)', '����� ��� ��i�� �� ���������� ���� �������� ', 'ForGor1.xls', NULL,1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1002, 'cnt05', 1000, '���� 05-39-11/5677', 'I�������i� ��� ���� ���� ����� 05-39-11/5677 �i� 01.12.05 ', 'count2005.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1003, 'rentdates', 1000, '����i� ������', '�����i� �������i�, � ���� ���i������� ����i� ������. ', 'rentdates.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1004, 'rentdates_all', 1000, '����i� ������ (�����i�)', '���� ���i������ ����i�� �������i� ������', 'rentdates_all.xls', NULL,4+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1005, 'point_err', 1000, '������� � i����i� ', '����� ���i��, i�������i� �� ���� �� ���� ������� �� ��i�i� ����� ���������i ���i � i����i�. ', 'point_err.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1006, 'gor_kur', 1000, '���� �����i���', '���� �����i��� ���i�i�. ', 'grafik.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1007, 'kur_meter', 1000, '�i�������� �� ������', '�i�������� �� ������ ', 'kur_meter.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1008, 'tables', 1000, '��������� ����', '��������� ����. ', 'tablelist.xls', NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1008, 'points_ta2', 1000, '����� ���i�� (�.�.2)', '������� �.2. �������� i�������i� �� ������ ���i�� ��������i�, ��������� �� �i��� ������� >=6 �� ', 'points_6kv.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1009, 'points_ta2_all', 1000, '����� ���i�� (��i)', '�������� i�������i� �� ������ ���i�� ��������i� (��i �i��i �������) ', 'points_all.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1010, 'abon_point_un', 1000, '���i������ �� ������i', '���i������ �������i� �� ����� ���i�� �� ������i ', 'abon_point_un.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1011, 'clientlist_fps', 1000, '��������i ���� 04/02-1478', ' �����i� ��������i� � ������� ��� �i��������� ( ��i��� ����� 04/02-1478). ', 'clientlist_fps.xls', NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1012, 'warning_debet', 1000, '������������(�����)', '���� ����������� ��� ���������� ����������������� ���i�����', 'warning_1.xls', NULL,1+2+4+1024);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1013, 'warning_avans', 1000, '������������(�����)', '���� ����������� ��� ���������� ����������������� ���i����� (�����)', 'warning_2.xls', NULL,1+2+4+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1014, 'warning_debet_list', 1000, '�����i� ��������.(�����)', '�����i� ��� ����������� ��� ���������� ����������������� ���i�����', 'warning_list1.xls', NULL,2+4+1024+16384);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1015, 'warning_avans_list', 1000, '�����i� ��������.(�����)', '�����i� ��� ����������� ��� ���������� ����������������� ���i����� (�����)', 'warning_list2.xls', NULL,2+4+1024+4096+16384);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1016, 'eqp_change', 1000, '��i�� � ����i', '��i�� � ����i �� ���i��', 'eqp_change.xls', NULL,1+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1017, 'point_change', 1000, '��i�� ���������i', '��i�� ���������i �� ������ ���i�� �� ���i��', 'point_change.xls', NULL,2+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1018, 'renthist', 1000, '��������i ��������', '��������i �������� ��� ���������� ������������ii, ����i� ���� ���i�������', 'renthist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1019, 'point_count', 1000, '�������i��� �����', '��i� ��� �������i��� ����� ���i��.', 'abon_count_dem.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1020, 'abon_area_dem', 1000, '���������� �������i�', '������ ���������� ���������� �����i� ��������� �� �����������', 'abon_area_dem.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1021, 'abon_tar_year', 1000, '�i��� ���������� (��+��)', 'I�������i� ���� �i����� ���������� ������� �� ��������� �����i� �� ��������', 'abon_tar_year.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1022, 'abon_area_summary', 1000, '����������(������.+�������.)', '��������, ��������� ������i��� �� �������i��i��� �� ����������� �������i�', 'clientlist_area_power.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1023, 'saldo_dt_kt', 1000, '��/�� ����������i���', '���i������� �� ������������ ����������i���', 'saldo_dt_kt.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1024, 'avans_analiz', 1000, '�����i��� ������ (-3) ', '�����i��� ������ ��������� ������i� ����������, ��i ������i ������� ����� �� ������� �������������� ���i���', 'avansanaliz.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1025, 'abon_lines', 1000 , '�i�ii ������������ �����', '��������� �i�i� ������������ ������ .', 'abonlines.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1026, 'abon_points', 1000 , '����� ���i�� (���������)', '����� ���i�� �������i�', 'abonpoints.xls', NULL,1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1027, 'bill_deleted', 1000 , '�������i �������', '�������i �������', 'bill_deleted.xls', NULL,2);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1100, '_gr', NULL, '�i�i��', '�i�i��', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1101, 'limit_list', 1100, '�i�i�� ���������', '�i�i�� ���������� �� �i����', 'limit_list.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1102, 'limit_year', 1100, '�i�i�� ��������� �� �i�', '�i�i�� ���������� �� �i�', 'limit_year.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1103, 'limit_area_year', 1100, '�i�i�� ����.�� ����������� �� �i�', '�i�i�� ���������� �� �i� �� �����������', 'limitarea_year.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1104, 'limit2kr_calc', 1100, '������. ����. �i�i��', '���������� ����������� ��������� �i�i�� ����������, �������� � ��������i �����������. ', 'limit_calc.xls', NULL,2+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1105, 'area_check', 1100, '�����i��� ���������i�', '�����i��� ����� ������ �� ���������i ���������i� ', 'area_check.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1106, 'check_limit_power', 1100, '�����i��� �i�i�i�(������*�����)', '�����i��� �i�i�� ����������, �������� � ����� ������ �� ���������i ���������i� ', 'check2kr_area_power.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1107, 'limit_area_change', 1100, '����������� �i�i�i�', '����������� �i�i�i� �� ���i�� ', 'limit_area_change.xls', NULL,2);


--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1200, '_gr', NULL, '���i������ 2009', '���i������ 2009', NULL, NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1201, 'abon_point_un', 1200, '���i������ �� ������i', '���i������ �������i� �� ����� ���i�� �� ������i ', 'abon_point_un.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1202, 'monitor_a2', 1200, '����.�.2 (��������)', '������� �.2. �������� i�������i� ���� ��������i�, ��������� �� ������i ������� 0.4 �� ', 'monitor_a2.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1203, 'monitor_a3', 1200, '����.�.3 (��������)', '������� �.3. �������� i�������i� ���� ��������i�, ��������� �� �������� ������� 6-154 �� ', 'monitor_a3.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1204, 'monitor_a6', 1200, '����� ���i�� (�.�.6)', '������� �.6. �������� i�������i� �� ������ ���i�� ��������i�, ��������� �� �i��� ������� >=6 �� ', 'points_6kv.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1205, 'monitor_a4', 1200, '��� ����.�.4 ', 'I�������i� ��� ���������� ������i �.4 ', 'monitor_a4.xls', NULL,2+32);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1206, 'monitor_a2m', 1200, '����.�.2 (���.���)', '������� �.2. �������� i�������i� ���� ��������i�, ��������� �� ������i ������� 0.4 �� (�i���� ��� ����i�i������ ���)', 'monitor_a2.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1207, 'monitor_a3m', 1200, '����.�.3 (���.���)', '������� �.3. �������� i�������i� ���� ��������i�, ��������� �� �������� ������� 6-154 �� (�i���� ��� ����i�i������ ���)', 'monitor_a3.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1208, 'monitor_a6m', 1200, '����.�.6 (���.���)', '������� �.6. �������� i�������i� �� ������ ���i�� ��������i�, ��������� �� �i��� ������� >=6 �� (�i���� ��� ����i�i������ ���) ', 'points_6kv.xls', NULL,2);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1209, 'monitor_a4m', 1200, '��� ����.�.4(���.���)', 'I�������i� ��� ���������� ������i �.4 ( ��� ����i�i������ ���)', 'monitor_a4.xls', NULL,2+32);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1210, 'ms_voltage', 1200, '������i/��� �� ������i', '�������� i�������i� �� ����������, ��������� �� �i���� �i���� �������', 'ms_voltage.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1300, '_gr', NULL, '���i������ 2010', '���i������ 2010', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1301, 'abon_count_volt', 1300, '�������i��� ����.����(�5)', '��i� ��� �������i��� �������i� ���������.', 'abon_count_volt.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1302, 'monitor2010_ps10', 1300, '��i� �� �� 10 �� ', ' �����i� �� ����i��i ���i  ������� �� 10/6 ��', 'monitor2010_ps10.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1303, 'monitor_a4_2010', 1300, '����������� ��i� �� ��10', ' ���������� i��������� ��� ���������� ��i�� "�����i� �� ����i��i ���i  ������� �� 10/6 ��"', 'monitor_a4_2010.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1304, 'monitor_a2_2010', 1300, '����.�.2 (2010)', '������� �.2. �������� i�������i� ���� ��������i�, ��������� �� ������i ������� 0.4 �� ', 'monitor_a2_2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1305, 'monitor_a3_2010', 1300, '����.�.3 (2010)', '������� �.3. �������� i�������i� ���� ��������i�, ��������� �� �������� ������� 6-154 �� ', 'monitor_a3_2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1306, 'monitor_10k', 1300, '����� ���i�� ���� >1�', '�������� i�������i� �� ������ ���i�� ��������i�, ���� ������i��  �i��� ������� >=6 �� ', 'points_6kv.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1400, '_gr', NULL, '������', '������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1401, 'plomblistall', 1400, '�����i� ����� �� ����', '�����i� �����, �� ����������i ������ �� ������� ����:', 'plomb_list_now.xls', NULL,1+4+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1402, 'plombinstall', 1400, '����������i ������', '�����i� �����, �� ����������i �� ���i�� ', 'plomb_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1403, 'plombdelete', 1400, '����i ������', '�����i� �����, �� ����i �� ���i�� ', 'plomb_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1404, 'worklist', 1400, '������ �� ���i��', '�����i� ���i�, �� �������i �� ���i�� ', 'work_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1405, 'worktech', 1400, '����i� ���.�����i���', '�����i� ����� ���i��, � ���� ����i� �i� ����i��� �����i��� ���i������� �� : ', 'worktech.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1406, 'workcontr', 1400, '����i� �����.������', '�����i� ����� ���i��, � ���� ����i� �i� ������������ ������ ���i������� �� : ', 'worktech.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1407, 'workreq', 1400, '����i� ��������� �����', '�����i� ����� ���i��, � ���� ����i� ��������� ����� ������ �� ������� ����', 'workreq.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1408, 'noplombnowork', 1400, '�� ��� ��������', '�����i� ����� ���i��, ��� ���� �� �������� ����� ��� ������ �� ������.', 'noplombnowork.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1409, 'grafic_work1', 1400 , '����i� ���. �����i���', '����i� ����i���� �����i���', 'grafic_work1.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1410, 'grafic_work2', 1400 , '����i� �����. �����i�', '����i� ����������� �����i�', 'grafic_work2.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1411, 'grafic3', 1400, '����i� ����� �������(���)', '����i� ����� ����������� ��������i� (���)', 'abonfider_grafic.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1412, 'grafic_work1_f', 1400 , '��������� ���. �����i���', '��������� ����i�� ����i���� �����i���', 'grafic_work1_fact.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1413, 'grafic_work2_f', 1400 , '��������� �����. �����i�', '��������� ����i�� ����������� �����i�', 'grafic_work2_fact.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1414, 'grafic3_f', 1400, '��������� ����� �������', '��������� ����i�� ����� ����������� ��������i� (���)', 'abonfider_grafic_fact.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1415, 'grafic_summary', 1400, '�i������ �� �������', '�i������ ��������� ����i�i� ����������� �����i�,����i���� �����i��� �� ����� ����������� ��������i�', 'grafic_work_summary.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1416, 'worklist_dt', 1400, '������ ������i �� ���i��', '�����i� ���i�, �� ������i � ���� �� ���i�� ', 'work_list_dt.xls', NULL,2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1417, 'worklistnone', 1400, '�� �� ���� ���i�', '�����i� ��, �� �� ������������ ������ �� ���i�� ', 'work_list_none.xls', NULL,1+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1418, 'point_dem_magnet', 1400, '����i��i ������ (������. �� �i�).', '���������� �� �������� �� ��������i� ���� �� ������ ���i��, �� ����������� ����i��i ������', 'point_dem_year_magnet.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1419, 'plombfast', 1400, '����� ���������������.', '����� ���i��, �� ���� ����������� ����������� 3 �� �i���� ���i�', 'plombfast.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1500, '_gr', NULL, '�������', '�������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1501, '3nkre', 1500, '3 ����', '����� 3-����', '3nkre.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1600, '_gr', NULL, '���i������ ���i�', '���i������ ���������� �������������� ���i� �� �i������� �����������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1601, 'fider_monitoring', 1600 , '���i���. ���i� �� �i����', '���i������ ���������� �������������� ���i� �� �i������� �����������', 'monitoring.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1602, 'fider_monitoring_2', 1600 , '���i���. ���i� (2 ���.)', '���i������ ���������� �������������� ���i� �� �i������� ����������� (���i������ 2 ���i��i�)', 'monitoring_2month.xls', NULL,2+2048);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1700, '_gr', NULL, '��i���� ������������', '��i���� ������������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1701, 'masters_demand', 1700 , '������ �i����i', '������ �i����i ������������ii � ��������i���� ����� ��i������ ������������', 'masterdemandlist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1702, 'masters_akt', 1700 , '��� (��������)', '��� ������� - ����i �� ��������� (�������������� ������ "������", ��� �������� ��� ������)', 'masterdemandakt.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1703, 'masters_demand_det', 1700 , '������ �i����i-�����i', '������ �i����i ������������ii � ��������i���� ����� ��i������ ������������ - �����i���i� ', 'masterdemandlistdet.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1704, 'masters_losts_det', 1700 , '������-�����i', '�������� ������������� ����� ������������i� � ��������� ����������� ����� ��i������ ������������ - �����i���i� ', 'masterlostsdet.xls', NULL,2);
-- INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1705, 'slav_special', 1700 , '��i���� �����. �� ����', '��i���� ������������ �� ���� ', '', NULL,2);

 drop table rep_ob_sal_tbl;
/*
 create table rep_ob_sal_tbl (
  dt_b   date,
  dt_e   date,
--  id_client int,
  potr numeric(12,2) ,
  debet numeric(12,2),
  kt numeric(12,2),
  bdt numeric(12,2),
  bkt numeric(12,2),
  kdt numeric(12,2),
  kkt numeric(12,2),
  id_client int,
  bs numeric(12,2),
  bs1 numeric(12,2),
  bs2 numeric(12,2),
  bs3 numeric(12,2),
  bsold numeric(12,2),
  es numeric(12,2),
  es1 numeric(12,2),
  es2 numeric(12,2),
  es3 numeric(12,2),
  esold numeric(12,2),
  abon_name varchar(50),
  abon_code int,
--  id_kwed   int,
  gr_lvl    int default 0,
  gr_kod        varchar(10)
--  industry1 varchar(50) ,
--  industry2 varchar(50) 
 );
*/
 drop table rep_sales_tbl;
/*
 create table rep_sales_tbl (
  dt_b   date,
  dt_e   date,
  potr numeric(12,2) ,
  debet numeric(12,2),
  debet_tax numeric(12,2),
  kt numeric(12,2),
  kt_tax numeric(12,2),
  bdt numeric(12,2),
  bdt_tax numeric(12,2),
  bkt numeric(12,2),
  bkt_tax numeric(12,2),
  kdt numeric(12,2),
  kdt_tax numeric(12,2),
  kkt numeric(12,2),
  kkt_tax numeric(12,2),
  bank numeric(12,2),
  bank_tax numeric(12,2),
  fact numeric(12,2),
  fact_tax numeric(12,2),
  gr_id    int,
  gr_name  varchar(50),
  gr_lvl   int ,
  gr_kod   varchar(10)

--  id_ind1 int ,
--  indname1 varchar(50),
--  id_ind2 varchar(50), 
--  indname2 varchar(50) 
 );
*/

drop table rep_param_tbl;
--create table rep_param_tbl(
--         id_rep int,
--         id_param int,
--         id_root int,
--         id_parent int,
--         primary key(id_rep,id_param)
--);


drop  table rep_abon_sales_tbl;
create  table rep_abon_sales_tbl (
   dt_b   date,
   dt_e   date,
   id_client int,
   potr numeric(12,2) ,
   debet numeric(12,2),
   debet_tax numeric(12,2),
   kt numeric(12,2),
   kt_tax numeric(12,2),
   bdt numeric(12,2),
   bdt_tax numeric(12,2),
   bkt numeric(12,2),
   bkt_tax numeric(12,2),
   kdt numeric(12,2),
   kdt_tax numeric(12,2),
   kkt numeric(12,2),
   kkt_tax numeric(12,2),
   bank numeric(12,2),
   bank_tax numeric(12,2),
   fact numeric(12,2),
   fact_tax numeric(12,2),
   gr_id        int
--   id_ind1 int ,
--   id_ind2 int 
); 

  drop table rep_saldo_tmp;
  -- ������� ��� ������ ������������� �� ���������� ����
  create table rep_saldo_tmp (
  id_client int,
  id_pref int,
  year_rep int,
  begs numeric(12,2),
  minus numeric(12,2),
  plus numeric(12,2),
  ends numeric(12,2) );
/*
  drop table rep_tarifaddgr_tbl;
  -- ������� ��� �������������� ����������� ������� � �������
  create table rep_tarifaddgr_tbl (
  ident varchar(10),
  addgroupid   int,
  addgroupname varchar(50)
  );
*/
/*
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7_1',7 ,'���������-������');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7_2',7 ,'���������-������');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7_3',7 ,'���������-������');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8_1',8 ,'�������i ������-������');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8_2',8 ,'�������i ������-������');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8_3',8 ,'�������i ������-������');
*/
/*
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7', 7, '���������-������');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8', 8, '�������i ������-������');
*/

--  drop table rep_f32_tbl;
  -- ������� ��� ������ "����� 32 ������"
  create table rep_f32_tbl (

--   dt_b   date,
--   dt_e   date,
   id_department int default getsysvar('kod_res'),
   ident varchar(10),
   caption varchar(250),
   num varchar(10),
   demand_tcl1 numeric(12,2),
   sum_tcl1 numeric(12,2),
   demand_tcl2 numeric(12,2),
   sum_tcl2 numeric(12,2),
   gr_lvl int,
   part_code int,
   mmgg date
  );

--  drop table rep_param_trace_tbl;

--  create table rep_param_trace_tbl
---  (
--    id_param int,
--    id_parent int,
--    id_group int,
--    primary key(id_param,id_parent,id_group)           
--   );
  
 drop table rep_3zone_tbl;
  -- ������� ��� ������� �� 3 ������ ���������
  create table rep_3zone_tbl (
  id_client int,
  id_tariff int,
  id_meter int,
  id_type_meter int,
  num_eqp varchar(25),
  demand_z1 numeric(12,2),
  demand_z2 numeric(12,2),
  demand_z3 numeric(12,2),
  sum_z1 numeric(12,2),
  sum_z2 numeric(12,2),
  sum_z3 numeric(12,2),
  tar0 numeric(12,5),
  sum_01 numeric(12,2),
  sum_02 numeric(12,2),
  sum_03 numeric(12,2),
  mmgg date
  );

  alter table rep_3zone_tbl add column id_point int;


 drop table rep_2zone_tbl;
  -- ������� ��� ������� �� 2 ������ ���������
  create table rep_2zone_tbl (
  id_client int,
  id_tariff int,
  id_meter int,
  id_type_meter int,
  num_eqp varchar(25),
  demand_z1 numeric(12,2),
  demand_z2 numeric(12,2),
  sum_z1 numeric(12,2),
  sum_z2 numeric(12,2),
  tar0 numeric(12,5),
  sum_01 numeric(12,2),
  sum_02 numeric(12,2),
  mmgg date
  );

  alter table rep_2zone_tbl add column id_point int;



DROP TABLE rep_nds_tbl;
CREATE TABLE rep_nds_tbl (
    mmgg date,
    id_pref integer,
    deb_b_01_1 numeric(14,2) default 0,
    dpdv_b_01_1 numeric(14,2) default 0,
    kr_b_01_1 numeric(14,2) default 0,
    kpdv_b_01_1 numeric(14,2) default 0,
    deb_e_01_1 numeric(14,2) default 0,
    dpdv_e_01_1 numeric(14,2) default 0,
    kr_e_01_1 numeric(14,2) default 0,
    kpdv_e_01_1 numeric(14,2) default 0,
    kvt_01_1 numeric(14,2) default 0,
    dem_01_1 numeric(14,2) default 0,
    dempdv_01_1 numeric(14,2) default 0,
    opl_01_1 numeric(14,2) default 0,
    oplpdv_01_1 numeric(14,2) default 0,
    sp1_01_1 numeric(14,2) default 0,
    sp1pdv_01_1 numeric(14,2) default 0,
    sp2_01_1 numeric(14,2) default 0,
    sp2pdv_01_1 numeric(14,2) default 0,
    billkt_01_1 numeric(14,2) default 0,
    billktpdv_01_1 numeric(14,2) default 0,
    deb_b_01_2 numeric(14,2) default 0,
    dpdv_b_01_2 numeric(14,2) default 0,
    kr_b_01_2 numeric(14,2) default 0,
    kpdv_b_01_2 numeric(14,2) default 0,
    deb_e_01_2 numeric(14,2) default 0,
    dpdv_e_01_2 numeric(14,2) default 0,
    kr_e_01_2 numeric(14,2) default 0,
    kpdv_e_01_2 numeric(14,2) default 0,
    kvt_01_2 numeric(14,2) default 0,
    dem_01_2 numeric(14,2) default 0,
    dempdv_01_2 numeric(14,2) default 0,
    opl_01_2 numeric(14,2) default 0,
    oplpdv_01_2 numeric(14,2) default 0,
    sp1_01_2 numeric(14,2) default 0,
    sp1pdv_01_2 numeric(14,2) default 0,
    sp2_01_2 numeric(14,2) default 0,
    sp2pdv_01_2 numeric(14,2) default 0,
    billkt_01_2 numeric(14,2) default 0,
    billktpdv_01_2 numeric(14,2) default 0,
    deb_b_01_3 numeric(14,2) default 0,
    dpdv_b_01_3 numeric(14,2) default 0,
    kr_b_01_3 numeric(14,2) default 0,
    kpdv_b_01_3 numeric(14,2) default 0,
    deb_e_01_3 numeric(14,2) default 0,
    dpdv_e_01_3 numeric(14,2) default 0,
    kr_e_01_3 numeric(14,2) default 0,
    kpdv_e_01_3 numeric(14,2) default 0,
    kvt_01_3 numeric(14,2) default 0,
    dem_01_3 numeric(14,2) default 0,
    dempdv_01_3 numeric(14,2) default 0,
    opl_01_3 numeric(14,2) default 0,
    oplpdv_01_3 numeric(14,2) default 0,
    sp1_01_3 numeric(14,2) default 0,
    sp1pdv_01_3 numeric(14,2) default 0,
    sp2_01_3 numeric(14,2) default 0,
    sp2pdv_01_3 numeric(14,2) default 0,
    billkt_01_3 numeric(14,2) default 0,
    billktpdv_01_3 numeric(14,2) default 0,
    deb_b_01_4 numeric(14,2) default 0,
    dpdv_b_01_4 numeric(14,2) default 0,
    kr_b_01_4 numeric(14,2) default 0,
    kpdv_b_01_4 numeric(14,2) default 0,
    deb_e_01_4 numeric(14,2) default 0,
    dpdv_e_01_4 numeric(14,2) default 0,
    kr_e_01_4 numeric(14,2) default 0,
    kpdv_e_01_4 numeric(14,2) default 0,
    kvt_01_4 numeric(14,2) default 0,
    dem_01_4 numeric(14,2) default 0,
    dempdv_01_4 numeric(14,2) default 0,
    opl_01_4 numeric(14,2) default 0,
    oplpdv_01_4 numeric(14,2) default 0,
    sp1_01_4 numeric(14,2) default 0,
    sp1pdv_01_4 numeric(14,2) default 0,
    sp2_01_4 numeric(14,2) default 0,
    sp2pdv_01_4 numeric(14,2) default 0,
    depozit1_01  numeric(14,2) default 0,
    depozit1pdv_01  numeric(14,2) default 0,
    depozit2_01  numeric(14,2) default 0,
    depozit2pdv_01  numeric(14,2) default 0,
    billkt_01_4 numeric(14,2) default 0,
    billktpdv_01_4 numeric(14,2) default 0,
    deb_b_01_5 numeric(14,2) default 0,
    dpdv_b_01_5 numeric(14,2) default 0,
    kr_b_01_5 numeric(14,2) default 0,
    kpdv_b_01_5 numeric(14,2) default 0,
    deb_e_01_5 numeric(14,2) default 0,
    dpdv_e_01_5 numeric(14,2) default 0,
    kr_e_01_5 numeric(14,2) default 0,
    kpdv_e_01_5 numeric(14,2) default 0,
    kvt_01_5 numeric(14,2) default 0,
    dem_01_5 numeric(14,2) default 0,
    dempdv_01_5 numeric(14,2) default 0,
    opl_01_5 numeric(14,2) default 0,
    oplpdv_01_5 numeric(14,2) default 0,
    sp1_01_5 numeric(14,2) default 0,
    sp1pdv_01_5 numeric(14,2) default 0,
    sp2_01_5 numeric(14,2) default 0,
    sp2pdv_01_5 numeric(14,2) default 0,
    billkt_01_5 numeric(14,2) default 0,
    billktpdv_01_5 numeric(14,2) default 0,

    deb_b_00_1 numeric(14,2) default 0,
    dpdv_b_00_1 numeric(14,2) default 0,
    deb_e_00_1 numeric(14,2) default 0,
    dpdv_e_00_1 numeric(14,2) default 0,
    opl_00_1 numeric(14,2) default 0,
    oplpdv_00_1 numeric(14,2) default 0,
    sp1_00_1 numeric(14,2) default 0,
    sp1pdv_00_1 numeric(14,2) default 0,
    sp2_00_1 numeric(14,2) default 0,
    sp2pdv_00_1 numeric(14,2) default 0,
    deb_b_00_2 numeric(14,2) default 0,
    dpdv_b_00_2 numeric(14,2) default 0,
    deb_e_00_2 numeric(14,2) default 0,
    dpdv_e_00_2 numeric(14,2) default 0,
    opl_00_2 numeric(14,2) default 0,
    oplpdv_00_2 numeric(14,2) default 0,
    sp1_00_2 numeric(14,2) default 0,
    sp1pdv_00_2 numeric(14,2) default 0,
    sp2_00_2 numeric(14,2) default 0,
    sp2pdv_00_2 numeric(14,2) default 0,
    deb_b_00_3 numeric(14,2) default 0,
    dpdv_b_00_3 numeric(14,2) default 0,
    deb_e_00_3 numeric(14,2) default 0,
    dpdv_e_00_3 numeric(14,2) default 0,
    opl_00_3 numeric(14,2) default 0,
    oplpdv_00_3 numeric(14,2) default 0,
    sp1_00_3 numeric(14,2) default 0,
    sp1pdv_00_3 numeric(14,2) default 0,
    sp2_00_3 numeric(14,2) default 0,
    sp2pdv_00_3 numeric(14,2) default 0,
    deb_b_00_4 numeric(14,2) default 0,
    dpdv_b_00_4 numeric(14,2) default 0,
    deb_e_00_4 numeric(14,2) default 0,
    dpdv_e_00_4 numeric(14,2) default 0,
    opl_00_4 numeric(14,2) default 0,
    oplpdv_00_4 numeric(14,2) default 0,
    sp1_00_4 numeric(14,2) default 0,
    sp1pdv_00_4 numeric(14,2) default 0,
    sp2_00_4 numeric(14,2) default 0,
    sp2pdv_00_4 numeric(14,2) default 0,
    depozit1_00  numeric(14,2) default 0,
    depozit1pdv_00  numeric(14,2) default 0,
    depozit2_00  numeric(14,2) default 0,
    depozit2pdv_00  numeric(14,2) default 0,
    deb_b_00_5 numeric(14,2) default 0,
    dpdv_b_00_5 numeric(14,2) default 0,
    deb_e_00_5 numeric(14,2) default 0,
    dpdv_e_00_5 numeric(14,2) default 0,
    opl_00_5 numeric(14,2) default 0,
    oplpdv_00_5 numeric(14,2) default 0,
    sp1_00_5 numeric(14,2) default 0,
    sp1pdv_00_5 numeric(14,2) default 0,
    sp2_00_5 numeric(14,2) default 0,
    sp2pdv_00_5 numeric(14,2) default 0,

    deb_b_99_1 numeric(14,2) default 0,
    deb_e_99_1 numeric(14,2) default 0,
    opl_99_1 numeric(14,2) default 0,
    sp1_99_1 numeric(14,2) default 0,
    sp2_99_1 numeric(14,2) default 0,
    deb_b_99_2 numeric(14,2) default 0,
    deb_e_99_2 numeric(14,2) default 0,
    opl_99_2 numeric(14,2) default 0,
    sp1_99_2 numeric(14,2) default 0,
    sp2_99_2 numeric(14,2) default 0,
    deb_b_99_3 numeric(14,2) default 0,
    deb_e_99_3 numeric(14,2) default 0,
    opl_99_3 numeric(14,2) default 0,
    sp1_99_3 numeric(14,2) default 0,
    sp2_99_3 numeric(14,2) default 0,
    deb_b_99_4 numeric(14,2) default 0,
    deb_e_99_4 numeric(14,2) default 0,
    opl_99_4 numeric(14,2) default 0,
    sp1_99_4 numeric(14,2) default 0,
    sp2_99_4 numeric(14,2) default 0,
    depozit1_99  numeric(14,2) default 0,
    depozit2_99  numeric(14,2) default 0,
    deb_b_99_5 numeric(14,2) default 0,
    deb_e_99_5 numeric(14,2) default 0,
    opl_99_5 numeric(14,2) default 0,
    sp1_99_5 numeric(14,2) default 0,
    sp2_99_5 numeric(14,2) default 0,

--    deb_b_008_1 numeric(14,2) default 0,
--    dpdv_b_008_1 numeric(14,2) default 0,
--  deb_e_008_1 numeric(14,2) default 0,
--    dpdv_e_008_1 numeric(14,2) default 0,
--    opl_008_1 numeric(14,2) default 0,
--    oplpdv_008_1 numeric(14,2) default 0,
--    sp1_008_1 numeric(14,2) default 0,
--    sp1pdv_008_1 numeric(14,2) default 0,
--    sp2_008_1 numeric(14,2) default 0,
--    sp2pdv_008_1 numeric(14,2) default 0,
--    deb_b_008_2 numeric(14,2) default 0,
--    dpdv_b_008_2 numeric(14,2) default 0,
--    deb_e_008_2 numeric(14,2) default 0,
--    dpdv_e_008_2 numeric(14,2) default 0,
--    opl_008_2 numeric(14,2) default 0,
--    oplpdv_008_2 numeric(14,2) default 0,
--    sp1_008_2 numeric(14,2) default 0,
--    sp1pdv_008_2 numeric(14,2) default 0,
--    sp2_008_2 numeric(14,2) default 0,
--    sp2pdv_008_2 numeric(14,2) default 0,
--    deb_b_008_3 numeric(14,2) default 0,
--    dpdv_b_008_3 numeric(14,2) default 0,
--    deb_e_008_3 numeric(14,2) default 0,
--    dpdv_e_008_3 numeric(14,2) default 0,
--    opl_008_3 numeric(14,2) default 0,
--    oplpdv_008_3 numeric(14,2) default 0,
--    sp1_008_3 numeric(14,2) default 0,
--    sp1pdv_008_3 numeric(14,2) default 0,
--    sp2_008_3 numeric(14,2) default 0,
--    sp2pdv_008_3 numeric(14,2) default 0,
    deb_b_008_4 numeric(14,2) default 0,
    dpdv_b_008_4 numeric(14,2) default 0,
    deb_e_008_4 numeric(14,2) default 0,
    dpdv_e_008_4 numeric(14,2) default 0,
    opl_008_4 numeric(14,2) default 0,
    oplpdv_008_4 numeric(14,2) default 0,
    sp1_008_4 numeric(14,2) default 0,
    sp1pdv_008_4 numeric(14,2) default 0,
    sp2_008_4 numeric(14,2) default 0,
    sp2pdv_008_4 numeric(14,2) default 0,
    depozit1_008  numeric(14,2) default 0,
    depozit1pdv_008  numeric(14,2) default 0,
    depozit2_008  numeric(14,2) default 0,
    depozit2pdv_008 numeric(14,2) default 0,
--    deb_b_008_5 numeric(14,2) default 0,
--    dpdv_b_008_5 numeric(14,2) default 0,
--    deb_e_008_5 numeric(14,2) default 0,
--    dpdv_e_008_5 numeric(14,2) default 0,
--    opl_008_5 numeric(14,2) default 0,
--    oplpdv_008_5 numeric(14,2) default 0,
--    sp1_008_5 numeric(14,2) default 0,
--    sp1pdv_008_5 numeric(14,2) default 0,
--    sp2_008_5 numeric(14,2) default 0,
--    sp2pdv_008_5 numeric(14,2) default 0,
    id_department int default  getsysvar('kod_res')
);


--DROP TABLE rep_nds2011_tbl;
CREATE TABLE rep_nds2011_tbl (
    mmgg date,
    id_pref integer,

    deb_b_11_1 	numeric(14,2) default 0,
    dpdv_b_11_1 numeric(14,2) default 0,
    kr_b_11_1 	numeric(14,2) default 0,
    kpdv_b_11_1 numeric(14,2) default 0,
    deb_e_11_1 	numeric(14,2) default 0,
    dpdv_e_11_1 numeric(14,2) default 0,
    kr_e_11_1 	numeric(14,2) default 0,
    kpdv_e_11_1 numeric(14,2) default 0,
    kvt_11_1 	numeric(14,2) default 0,
    dem_11_1 	numeric(14,2) default 0,
    dempdv_11_1 numeric(14,2) default 0,
    opl_11_1 	numeric(14,2) default 0,
    oplpdv_11_1 numeric(14,2) default 0,
    sp1_11_1 	numeric(14,2) default 0,
    sp1pdv_11_1 numeric(14,2) default 0,
    sp2_11_1 	numeric(14,2) default 0,
    sp2pdv_11_1 numeric(14,2) default 0,
    billkt_11_1 numeric(14,2) default 0,
    billktpdv_11_1 numeric(14,2) default 0,
    deb_b_11_2 	numeric(14,2) default 0,
    dpdv_b_11_2 numeric(14,2) default 0,
    kr_b_11_2 	numeric(14,2) default 0,
    kpdv_b_11_2 numeric(14,2) default 0,
    deb_e_11_2 	numeric(14,2) default 0,
    dpdv_e_11_2 numeric(14,2) default 0,
    kr_e_11_2 	numeric(14,2) default 0,
    kpdv_e_11_2 numeric(14,2) default 0,
    kvt_11_2 	numeric(14,2) default 0,
    dem_11_2 	numeric(14,2) default 0,
    dempdv_11_2 numeric(14,2) default 0,
    opl_11_2 	numeric(14,2) default 0,
    oplpdv_11_2 numeric(14,2) default 0,
    sp1_11_2 	numeric(14,2) default 0,
    sp1pdv_11_2 numeric(14,2) default 0,
    sp2_11_2 	numeric(14,2) default 0,
    sp2pdv_11_2 numeric(14,2) default 0,
    billkt_11_2 numeric(14,2) default 0,
    billktpdv_11_2 numeric(14,2) default 0,
    deb_b_11_3 	numeric(14,2) default 0,
    dpdv_b_11_3 numeric(14,2) default 0,
    kr_b_11_3 	numeric(14,2) default 0,
    kpdv_b_11_3 numeric(14,2) default 0,
    deb_e_11_3 	numeric(14,2) default 0,
    dpdv_e_11_3 numeric(14,2) default 0,
    kr_e_11_3 	numeric(14,2) default 0,
    kpdv_e_11_3 numeric(14,2) default 0,
    kvt_11_3 	numeric(14,2) default 0,
    dem_11_3 	numeric(14,2) default 0,
    dempdv_11_3 numeric(14,2) default 0,
    opl_11_3 	numeric(14,2) default 0,
    oplpdv_11_3 numeric(14,2) default 0,
    sp1_11_3 	numeric(14,2) default 0,
    sp1pdv_11_3 numeric(14,2) default 0,
    sp2_11_3 	numeric(14,2) default 0,
    sp2pdv_11_3 numeric(14,2) default 0,
    billkt_11_3 numeric(14,2) default 0,
    billktpdv_11_3 numeric(14,2) default 0,
    deb_b_11_4 	numeric(14,2) default 0,
    dpdv_b_11_4 numeric(14,2) default 0,
    kr_b_11_4 	numeric(14,2) default 0,
    kpdv_b_11_4 numeric(14,2) default 0,
    deb_e_11_4 	numeric(14,2) default 0,
    dpdv_e_11_4 numeric(14,2) default 0,
    kr_e_11_4 	numeric(14,2) default 0,
    kpdv_e_11_4 numeric(14,2) default 0,
    kvt_11_4 	numeric(14,2) default 0,
    dem_11_4 	numeric(14,2) default 0,
    dempdv_11_4 numeric(14,2) default 0,
    opl_11_4 	numeric(14,2) default 0,
    oplpdv_11_4 numeric(14,2) default 0,
    sp1_11_4 	numeric(14,2) default 0,
    sp1pdv_11_4 numeric(14,2) default 0,
    sp2_11_4 	numeric(14,2) default 0,
    sp2pdv_11_4 numeric(14,2) default 0,
    depozit1_11 numeric(14,2) default 0,
    depozit1pdv_11  numeric(14,2) default 0,
    depozit2_11 numeric(14,2) default 0,
    depozit2pdv_11  numeric(14,2) default 0,
    billkt_11_4 numeric(14,2) default 0,
    billktpdv_11_4 numeric(14,2) default 0,
    deb_b_11_5 	numeric(14,2) default 0,
    dpdv_b_11_5 numeric(14,2) default 0,
    kr_b_11_5 	numeric(14,2) default 0,
    kpdv_b_11_5 numeric(14,2) default 0,
    deb_e_11_5 	numeric(14,2) default 0,
    dpdv_e_11_5 numeric(14,2) default 0,
    kr_e_11_5 	numeric(14,2) default 0,
    kpdv_e_11_5 numeric(14,2) default 0,
    kvt_11_5 	numeric(14,2) default 0,
    dem_11_5 	numeric(14,2) default 0,
    dempdv_11_5 numeric(14,2) default 0,
    opl_11_5 	numeric(14,2) default 0,
    oplpdv_11_5 numeric(14,2) default 0,
    sp1_11_5 	numeric(14,2) default 0,
    sp1pdv_11_5 numeric(14,2) default 0,
    sp2_11_5 	numeric(14,2) default 0,
    sp2pdv_11_5 numeric(14,2) default 0,
    billkt_11_5 numeric(14,2) default 0,
    billktpdv_11_5 numeric(14,2) default 0,

    deb_b_01_1 numeric(14,2) default 0,
    dpdv_b_01_1 numeric(14,2) default 0,
    kr_b_01_1 numeric(14,2) default 0,
    kpdv_b_01_1 numeric(14,2) default 0,
    --deb_e_01_1 numeric(14,2) default 0,
    --dpdv_e_01_1 numeric(14,2) default 0,
    --kr_e_01_1 numeric(14,2) default 0,
    --kpdv_e_01_1 numeric(14,2) default 0,
    kvt_01_1 numeric(14,2) default 0,
    dem_01_1 numeric(14,2) default 0,
    dempdv_01_1 numeric(14,2) default 0,
    opl_01_1 numeric(14,2) default 0,
    oplpdv_01_1 numeric(14,2) default 0,
    sp1_01_1 numeric(14,2) default 0,
    sp1pdv_01_1 numeric(14,2) default 0,
    sp2_01_1 numeric(14,2) default 0,
    sp2pdv_01_1 numeric(14,2) default 0,
    billkt_01_1 numeric(14,2) default 0,
    billktpdv_01_1 numeric(14,2) default 0,
    deb_b_01_2 numeric(14,2) default 0,
    dpdv_b_01_2 numeric(14,2) default 0,
    kr_b_01_2 numeric(14,2) default 0,
    kpdv_b_01_2 numeric(14,2) default 0,
    deb_e_01_2 numeric(14,2) default 0,
    dpdv_e_01_2 numeric(14,2) default 0,
    kr_e_01_2 numeric(14,2) default 0,
    kpdv_e_01_2 numeric(14,2) default 0,
    kvt_01_2 numeric(14,2) default 0,
    dem_01_2 numeric(14,2) default 0,
    dempdv_01_2 numeric(14,2) default 0,
    opl_01_2 numeric(14,2) default 0,
    oplpdv_01_2 numeric(14,2) default 0,
    sp1_01_2 numeric(14,2) default 0,
    sp1pdv_01_2 numeric(14,2) default 0,
    sp2_01_2 numeric(14,2) default 0,
    sp2pdv_01_2 numeric(14,2) default 0,
    billkt_01_2 numeric(14,2) default 0,
    billktpdv_01_2 numeric(14,2) default 0,
    deb_b_01_3 numeric(14,2) default 0,
    dpdv_b_01_3 numeric(14,2) default 0,
    kr_b_01_3 numeric(14,2) default 0,
    kpdv_b_01_3 numeric(14,2) default 0,
    deb_e_01_3 numeric(14,2) default 0,
    dpdv_e_01_3 numeric(14,2) default 0,
    kr_e_01_3 numeric(14,2) default 0,
    kpdv_e_01_3 numeric(14,2) default 0,
    kvt_01_3 numeric(14,2) default 0,
    dem_01_3 numeric(14,2) default 0,
    dempdv_01_3 numeric(14,2) default 0,
    opl_01_3 numeric(14,2) default 0,
    oplpdv_01_3 numeric(14,2) default 0,
    sp1_01_3 numeric(14,2) default 0,
    sp1pdv_01_3 numeric(14,2) default 0,
    sp2_01_3 numeric(14,2) default 0,
    sp2pdv_01_3 numeric(14,2) default 0,
    billkt_01_3 numeric(14,2) default 0,
    billktpdv_01_3 numeric(14,2) default 0,
    deb_b_01_4 numeric(14,2) default 0,
    dpdv_b_01_4 numeric(14,2) default 0,
    kr_b_01_4 numeric(14,2) default 0,
    kpdv_b_01_4 numeric(14,2) default 0,
    deb_e_01_4 numeric(14,2) default 0,
    dpdv_e_01_4 numeric(14,2) default 0,
    kr_e_01_4 numeric(14,2) default 0,
    kpdv_e_01_4 numeric(14,2) default 0,
    kvt_01_4 numeric(14,2) default 0,
    dem_01_4 numeric(14,2) default 0,
    dempdv_01_4 numeric(14,2) default 0,
    opl_01_4 numeric(14,2) default 0,
    oplpdv_01_4 numeric(14,2) default 0,
    sp1_01_4 numeric(14,2) default 0,
    sp1pdv_01_4 numeric(14,2) default 0,
    sp2_01_4 numeric(14,2) default 0,
    sp2pdv_01_4 numeric(14,2) default 0,
    depozit1_01  numeric(14,2) default 0,
    depozit1pdv_01  numeric(14,2) default 0,
    depozit2_01  numeric(14,2) default 0,
    depozit2pdv_01  numeric(14,2) default 0,
    billkt_01_4 numeric(14,2) default 0,
    billktpdv_01_4 numeric(14,2) default 0,
    deb_b_01_5 numeric(14,2) default 0,
    dpdv_b_01_5 numeric(14,2) default 0,
    kr_b_01_5 numeric(14,2) default 0,
    kpdv_b_01_5 numeric(14,2) default 0,
    --deb_e_01_5 numeric(14,2) default 0,
    --dpdv_e_01_5 numeric(14,2) default 0,
    --kr_e_01_5 numeric(14,2) default 0,
    --kpdv_e_01_5 numeric(14,2) default 0,
    kvt_01_5 numeric(14,2) default 0,
    dem_01_5 numeric(14,2) default 0,
    dempdv_01_5 numeric(14,2) default 0,
    opl_01_5 numeric(14,2) default 0,
    oplpdv_01_5 numeric(14,2) default 0,
    sp1_01_5 numeric(14,2) default 0,
    sp1pdv_01_5 numeric(14,2) default 0,
    sp2_01_5 numeric(14,2) default 0,
    sp2pdv_01_5 numeric(14,2) default 0,
    billkt_01_5 numeric(14,2) default 0,
    billktpdv_01_5 numeric(14,2) default 0,

    deb_b_00_1 numeric(14,2) default 0,
    dpdv_b_00_1 numeric(14,2) default 0,
    deb_e_00_1 numeric(14,2) default 0,
    dpdv_e_00_1 numeric(14,2) default 0,
    opl_00_1 numeric(14,2) default 0,
    oplpdv_00_1 numeric(14,2) default 0,
    sp1_00_1 numeric(14,2) default 0,
    sp1pdv_00_1 numeric(14,2) default 0,
    sp2_00_1 numeric(14,2) default 0,
    sp2pdv_00_1 numeric(14,2) default 0,
    deb_b_00_2 numeric(14,2) default 0,
    dpdv_b_00_2 numeric(14,2) default 0,
    deb_e_00_2 numeric(14,2) default 0,
    dpdv_e_00_2 numeric(14,2) default 0,
    opl_00_2 numeric(14,2) default 0,
    oplpdv_00_2 numeric(14,2) default 0,
    sp1_00_2 numeric(14,2) default 0,
    sp1pdv_00_2 numeric(14,2) default 0,
    sp2_00_2 numeric(14,2) default 0,
    sp2pdv_00_2 numeric(14,2) default 0,
    deb_b_00_3 numeric(14,2) default 0,
    dpdv_b_00_3 numeric(14,2) default 0,
    deb_e_00_3 numeric(14,2) default 0,
    dpdv_e_00_3 numeric(14,2) default 0,
    opl_00_3 numeric(14,2) default 0,
    oplpdv_00_3 numeric(14,2) default 0,
    sp1_00_3 numeric(14,2) default 0,
    sp1pdv_00_3 numeric(14,2) default 0,
    sp2_00_3 numeric(14,2) default 0,
    sp2pdv_00_3 numeric(14,2) default 0,
    deb_b_00_4 numeric(14,2) default 0,
    dpdv_b_00_4 numeric(14,2) default 0,
    deb_e_00_4 numeric(14,2) default 0,
    dpdv_e_00_4 numeric(14,2) default 0,
    opl_00_4 numeric(14,2) default 0,
    oplpdv_00_4 numeric(14,2) default 0,
    sp1_00_4 numeric(14,2) default 0,
    sp1pdv_00_4 numeric(14,2) default 0,
    sp2_00_4 numeric(14,2) default 0,
    sp2pdv_00_4 numeric(14,2) default 0,
    depozit1_00  numeric(14,2) default 0,
    depozit1pdv_00  numeric(14,2) default 0,
    depozit2_00  numeric(14,2) default 0,
    depozit2pdv_00  numeric(14,2) default 0,
    deb_b_00_5 numeric(14,2) default 0,
    dpdv_b_00_5 numeric(14,2) default 0,
    deb_e_00_5 numeric(14,2) default 0,
    dpdv_e_00_5 numeric(14,2) default 0,
    opl_00_5 numeric(14,2) default 0,
    oplpdv_00_5 numeric(14,2) default 0,
    sp1_00_5 numeric(14,2) default 0,
    sp1pdv_00_5 numeric(14,2) default 0,
    sp2_00_5 numeric(14,2) default 0,
    sp2pdv_00_5 numeric(14,2) default 0,

    deb_b_99_1 numeric(14,2) default 0,
    deb_e_99_1 numeric(14,2) default 0,
    opl_99_1 numeric(14,2) default 0,
    sp1_99_1 numeric(14,2) default 0,
    sp2_99_1 numeric(14,2) default 0,
    deb_b_99_2 numeric(14,2) default 0,
    deb_e_99_2 numeric(14,2) default 0,
    opl_99_2 numeric(14,2) default 0,
    sp1_99_2 numeric(14,2) default 0,
    sp2_99_2 numeric(14,2) default 0,
    deb_b_99_3 numeric(14,2) default 0,
    deb_e_99_3 numeric(14,2) default 0,
    opl_99_3 numeric(14,2) default 0,
    sp1_99_3 numeric(14,2) default 0,
    sp2_99_3 numeric(14,2) default 0,
    deb_b_99_4 numeric(14,2) default 0,
    deb_e_99_4 numeric(14,2) default 0,
    opl_99_4 numeric(14,2) default 0,
    sp1_99_4 numeric(14,2) default 0,
    sp2_99_4 numeric(14,2) default 0,
    depozit1_99  numeric(14,2) default 0,
    depozit2_99  numeric(14,2) default 0,
    deb_b_99_5 numeric(14,2) default 0,
    deb_e_99_5 numeric(14,2) default 0,
    opl_99_5 numeric(14,2) default 0,
    sp1_99_5 numeric(14,2) default 0,
    sp2_99_5 numeric(14,2) default 0,

    deb_b_008_4 numeric(14,2) default 0,
    dpdv_b_008_4 numeric(14,2) default 0,
    deb_e_008_4 numeric(14,2) default 0,
    dpdv_e_008_4 numeric(14,2) default 0,
    opl_008_4 numeric(14,2) default 0,
    oplpdv_008_4 numeric(14,2) default 0,
    sp1_008_4 numeric(14,2) default 0,
    sp1pdv_008_4 numeric(14,2) default 0,
    sp2_008_4 numeric(14,2) default 0,
    sp2pdv_008_4 numeric(14,2) default 0,
    depozit1_008  numeric(14,2) default 0,
    depozit1pdv_008  numeric(14,2) default 0,
    depozit2_008  numeric(14,2) default 0,
    depozit2pdv_008 numeric(14,2) default 0,
    id_department int default  getsysvar('kod_res'),
    flock         int default 0 ,
    primary key (mmgg, id_pref)
);


DROP TABLE rep_count_tbl;

CREATE TABLE rep_count_tbl (
     id_department int default  getsysvar('kod_res'),
     mmgg date,

     abons_budjet_t  int default 0,
     abons_jkh_t     int default 0,
     abons_other_t   int default 0,
     abons_budjet_v  int default 0,
     abons_jkh_v     int default 0,
     abons_other_v   int default 0,
     abons_comp1     int default 0,
     abons_comp2     int default 0,
     abons_comp3     int default 0,
     abons_sh        int default 0,
     abons_noprom10k int default 0,
    
     areas_budjet_t  int default 0,
     areas_jkh_t     int default 0,
     areas_other_t   int default 0,
     areas_budjet_v  int default 0,
     areas_jkh_v     int default 0,
     areas_other_v   int default 0,
     areas_comp1     int default 0,
     areas_comp2     int default 0,
     areas_comp3     int default 0,
     areas_sh        int default 0,
     areas_noprom10k int default 0,
    
     point1_budjet_t  int default 0,
     point1_jkh_t     int default 0,
     point1_other_t   int default 0,
     point1_budjet_v  int default 0,
     point1_jkh_v     int default 0,
     point1_other_v   int default 0,
     point1_comp1     int default 0,
     point1_comp2     int default 0,
     point1_comp3     int default 0,
     point1_sh        int default 0,
     point1_noprom10k int default 0,
    
     point3_budjet_t  int default 0,
     point3_jkh_t     int default 0,
     point3_other_t   int default 0,
     point3_budjet_v  int default 0,
     point3_jkh_v     int default 0,
     point3_other_v   int default 0,
     point3_comp1     int default 0,
     point3_comp2     int default 0,
     point3_comp3     int default 0,
     point3_sh        int default 0,
     point3_noprom10k int default 0

);		


CREATE TABLE rep_count_volt_tbl (
     id_department int default  getsysvar('kod_res'),
     mmgg date,
     abons_budjet03_t  int default 0,
     abons_jkh03_t     int default 0,
     abons_other03_t   int default 0,
     abons_budjet03_v  int default 0,
     abons_jkh03_v     int default 0,
     abons_other03_v   int default 0,
     abons_budjet02_t  int default 0,
     abons_jkh02_t     int default 0,
     abons_other02_t   int default 0,
     abons_budjet02_v  int default 0,
     abons_jkh02_v     int default 0,
     abons_other02_v   int default 0,

     areas_budjet03_t  int default 0,
     areas_jkh03_t     int default 0,
     areas_other03_t   int default 0,
     areas_budjet03_v  int default 0,
     areas_jkh03_v     int default 0,
     areas_other03_v   int default 0,
     areas_budjet02_t  int default 0,
     areas_jkh02_t     int default 0,
     areas_other02_t   int default 0,
     areas_budjet02_v  int default 0,
     areas_jkh02_v     int default 0,
     areas_other02_v   int default 0,

     point_budjet03_t  int default 0,
     point_jkh03_t     int default 0,
     point_other03_t   int default 0,
     point_budjet03_v  int default 0,
     point_jkh03_v     int default 0,
     point_other03_v   int default 0,
     point_budjet02_t  int default 0,
     point_jkh02_t     int default 0,
     point_other02_t   int default 0,
     point_budjet02_v  int default 0,
     point_jkh02_v     int default 0,
     point_other02_v   int default 0,

     abons_comp1_110_t int default 0,
     abons_comp1_35_t  int default 0,
     abons_comp1_10_t  int default 0,
     abons_comp1_6_t   int default 0,
     abons_comp1_03_t  int default 0,
     abons_comp1_02_t  int default 0,

     abons_comp2_110_t int default 0,
     abons_comp2_35_t  int default 0,
     abons_comp2_10_t  int default 0,
     abons_comp2_6_t   int default 0,
     abons_comp2_03_t  int default 0,
     abons_comp2_02_t  int default 0,

     abons_comp3_110_t int default 0,
     abons_comp3_35_t  int default 0,
     abons_comp3_10_t  int default 0,
     abons_comp3_6_t   int default 0,
     abons_comp3_03_t  int default 0,
     abons_comp3_02_t  int default 0,

     abons_comp1_110_v int default 0,
     abons_comp1_35_v  int default 0,
     abons_comp1_10_v  int default 0,
     abons_comp1_6_v   int default 0,
     abons_comp1_03_v  int default 0,
     abons_comp1_02_v  int default 0,

     abons_comp2_110_v int default 0,
     abons_comp2_35_v  int default 0,
     abons_comp2_10_v  int default 0,
     abons_comp2_6_v   int default 0,
     abons_comp2_03_v  int default 0,
     abons_comp2_02_v  int default 0,

     abons_comp3_110_v int default 0,
     abons_comp3_35_v  int default 0,
     abons_comp3_10_v  int default 0,
     abons_comp3_6_v   int default 0,
     abons_comp3_03_v  int default 0,
     abons_comp3_02_v  int default 0,


     areas_comp1_110_t int default 0,
     areas_comp1_35_t  int default 0,
     areas_comp1_10_t  int default 0,
     areas_comp1_6_t   int default 0,
     areas_comp1_03_t  int default 0,
     areas_comp1_02_t  int default 0,

     areas_comp2_110_t int default 0,
     areas_comp2_35_t  int default 0,
     areas_comp2_10_t  int default 0,
     areas_comp2_6_t   int default 0,
     areas_comp2_03_t  int default 0,
     areas_comp2_02_t  int default 0,

     areas_comp3_110_t int default 0,
     areas_comp3_35_t  int default 0,
     areas_comp3_10_t  int default 0,
     areas_comp3_6_t   int default 0,
     areas_comp3_03_t  int default 0,
     areas_comp3_02_t  int default 0,

     areas_comp1_110_v int default 0,
     areas_comp1_35_v  int default 0,
     areas_comp1_10_v  int default 0,
     areas_comp1_6_v   int default 0,
     areas_comp1_03_v  int default 0,
     areas_comp1_02_v  int default 0,

     areas_comp2_110_v int default 0,
     areas_comp2_35_v  int default 0,
     areas_comp2_10_v  int default 0,
     areas_comp2_6_v   int default 0,
     areas_comp2_03_v  int default 0,
     areas_comp2_02_v  int default 0,

     areas_comp3_110_v int default 0,
     areas_comp3_35_v  int default 0,
     areas_comp3_10_v  int default 0,
     areas_comp3_6_v   int default 0,
     areas_comp3_03_v  int default 0,
     areas_comp3_02_v  int default 0,


     point_comp1_110_t int default 0,
     point_comp1_35_t  int default 0,
     point_comp1_10_t  int default 0,
     point_comp1_6_t   int default 0,
     point_comp1_03_t  int default 0,
     point_comp1_02_t  int default 0,

     point_comp2_110_t int default 0,
     point_comp2_35_t  int default 0,
     point_comp2_10_t  int default 0,
     point_comp2_6_t   int default 0,
     point_comp2_03_t  int default 0,
     point_comp2_02_t  int default 0,

     point_comp3_110_t int default 0,
     point_comp3_35_t  int default 0,
     point_comp3_10_t  int default 0,
     point_comp3_6_t   int default 0,
     point_comp3_03_t  int default 0,
     point_comp3_02_t  int default 0,

     point_comp1_110_v int default 0,
     point_comp1_35_v  int default 0,
     point_comp1_10_v  int default 0,
     point_comp1_6_v   int default 0,
     point_comp1_03_v  int default 0,
     point_comp1_02_v  int default 0,

     point_comp2_110_v int default 0,
     point_comp2_35_v  int default 0,
     point_comp2_10_v  int default 0,
     point_comp2_6_v   int default 0,
     point_comp2_03_v  int default 0,
     point_comp2_02_v  int default 0,

     point_comp3_110_v int default 0,
     point_comp3_35_v  int default 0,
     point_comp3_10_v  int default 0,
     point_comp3_6_v   int default 0,
     point_comp3_03_v  int default 0,
     point_comp3_02_v  int default 0,

     abons_sh_110_t int default 0,
     abons_sh_35_t  int default 0,
     abons_sh_10_t  int default 0,
     abons_sh_6_t   int default 0,
     abons_sh_03_t  int default 0,
     abons_sh_02_t  int default 0,

     abons_sh_110_v int default 0,
     abons_sh_35_v  int default 0,
     abons_sh_10_v  int default 0,
     abons_sh_6_v   int default 0,
     abons_sh_03_v  int default 0,
     abons_sh_02_v  int default 0,

     areas_sh_110_t int default 0,
     areas_sh_35_t  int default 0,
     areas_sh_10_t  int default 0,
     areas_sh_6_t   int default 0,
     areas_sh_03_t  int default 0,
     areas_sh_02_t  int default 0,

     areas_sh_110_v int default 0,
     areas_sh_35_v  int default 0,
     areas_sh_10_v  int default 0,
     areas_sh_6_v   int default 0,
     areas_sh_03_v  int default 0,
     areas_sh_02_v  int default 0,

     point_sh_110_t int default 0,
     point_sh_35_t  int default 0,
     point_sh_10_t  int default 0,
     point_sh_6_t   int default 0,
     point_sh_03_t  int default 0,
     point_sh_02_t  int default 0,

     point_sh_110_v int default 0,
     point_sh_35_v  int default 0,
     point_sh_10_v  int default 0,
     point_sh_6_v   int default 0,
     point_sh_03_v  int default 0,
     point_sh_02_v  int default 0,


     abons_nopr_110_t int default 0,
     abons_nopr_35_t  int default 0,
     abons_nopr_10_t  int default 0,
     abons_nopr_6_t   int default 0,
     abons_nopr_03_t  int default 0,
     abons_nopr_02_t  int default 0,

     abons_nopr_110_v int default 0,
     abons_nopr_35_v  int default 0,
     abons_nopr_10_v  int default 0,
     abons_nopr_6_v   int default 0,
     abons_nopr_03_v  int default 0,
     abons_nopr_02_v  int default 0,

     areas_nopr_110_t int default 0,
     areas_nopr_35_t  int default 0,
     areas_nopr_10_t  int default 0,
     areas_nopr_6_t   int default 0,
     areas_nopr_03_t  int default 0,
     areas_nopr_02_t  int default 0,

     areas_nopr_110_v int default 0,
     areas_nopr_35_v  int default 0,
     areas_nopr_10_v  int default 0,
     areas_nopr_6_v   int default 0,
     areas_nopr_03_v  int default 0,
     areas_nopr_02_v  int default 0,

     point_nopr_110_t int default 0,
     point_nopr_35_t  int default 0,
     point_nopr_10_t  int default 0,
     point_nopr_6_t   int default 0,
     point_nopr_03_t  int default 0,
     point_nopr_02_t  int default 0,

     point_nopr_110_v int default 0,
     point_nopr_35_v  int default 0,
     point_nopr_10_v  int default 0,
     point_nopr_6_v   int default 0,
     point_nopr_03_v  int default 0,
     point_nopr_02_v  int default 0
);		

--DROP TABLE rep_areas_points_tbl;
CREATE TABLE rep_areas_points_tbl (
    id_client        int,
    id_point         int,
    id_area          int,
    phase            int,
    voltage          int,
    is_town	     bool default false,
    primary key(id_client,id_point)
);		


CREATE TABLE rep_areas_tbl (
    id_client        int,
    id_area          int,
    phase            int,
    voltage          int,
    is_town	     bool default false,
    primary key(id_client,id_area)
);		

CREATE TABLE rep_count_prom_power_tbl (
    id_client        int,
    power            int,
    primary key(id_client)
);		


alter table rep_areas_points_tbl add column un int;
alter table rep_areas_points_tbl add column is_subabon int;
alter table rep_areas_points_tbl add column del_abon int;

--DROP TABLE rep_meter_points_tbl;
CREATE TABLE rep_meter_points_tbl (
    id_client        int,
    id_point         int,
    id_meter         int,
    id_area          int,
    id_type_meter    int
    ,primary key(id_client,id_meter)
);		


  drop table rep_lost_tbl;
  -- ������� ��� ������ "����� 32 ������"
  create table rep_lost_tbl (
   id_department int default getsysvar('kod_res'),
   ident varchar(10),
   caption varchar(100),
   d110 numeric(12,2),
   d35 numeric(12,2),
   d10 numeric(12,2),
   d04 numeric(12,2),
   gr_lvl int default 0,
   ordr int,
   mmgg date
  );

  create table rep_3nkre_tbl (
   id_client int,
   class     int,
   ident     int, 
   demand_val numeric(12,2),
   sum_val    numeric(12,2),
   sum_pay    numeric(12,2),
   saldo_b    numeric(12,2),
   mode       int
  );


create table rep_noindic_mmgg_tbl (
	id_client int,
	id_meter int,
	id_point int,
	num_meter varchar(50),
	point_name varchar (100),
	mmgg date,
	primary key (id_meter,mmgg)
);


set client_encoding='KOI8';