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

  CREATE AGGREGATE sum ( BASETYPE = text,
                         SFUNC = textcat,
                         STYPE = text,
                         INITCOND = '' );


--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name) VALUES (1, 'oborot', 1, '�������� �i���i��� ��', ' �������� �i���i��� ���������� �� ������� ������������i�', 'oborot.rpt', 'ObSaldo');
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name) VALUES (2, 'sales', 1, '���i��� ����. ����. ��', ' ���i��� ��� �������� ����i���i� �� ������� �����i�', 'sales.rpt', 'Sales');



delete from rep_kinds_tbl;

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (100, '_gr', NULL, '�������', '�������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (101, 'oborot', 100, '�������� �i���i���', '�������� �i���i��� ���������� �� ������������i�', 'oborot.xls', 'ObSaldo',10);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (102, 'oborot_r', 100, '�������� �i���i��� ��', '�������� �i���i��� ���������� �� ��������� ������������i�', 'oborot.xls', 'ObSaldo',2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (103, 'oborot_nds', 100, '�������� �i���i��� � ���', '�������� �i���i��� ���������� �� ������������i� (���������� �� ���)', 'oborot_nds.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (104, 'oborot_err', 100, '�����i��� ������. �i���.', '����� ������� � �������i� �i���i��i ���������� �� ������������i� (���������� �� ���)', 'oborot_err.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (105, 'oborot_5kr', 100, '�������� �i���i��� 5/2��', '�������� �i���i��� ���������� �� ������������ �i������ϧ ����� �� ����������� �����i���� �����i� ���������� ������������i� ', 'oborot_5kr.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (106, 'oborot_1', 100, '�������� �i���i��� ����.', '�������� �i���i��� �� ��������. ', 'oborot_1.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (109, 'oborot_akt', 100, '��������  �� ����� ', '��������  �� ����� �� ��������� ������ ����������', 'oborot_akt.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (114, 'sales', 100, '���i��� ����. ����.', '���i��� ��� �������� ����i���i� ', 'sales.xls', 'Sales',10);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (115, 'sales_r', 100, '���i��� ����. ����. ��', '���i��� ��� �������� ����i���i� �� ��������� �����i�', 'sales.xls', 'Sales',2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (116, 'oborot_short', 100, '�������� �i���i��� (����)', '�������� �i���i��� �� 1 ����i���', 'oborot_sh.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (117, 'f24', 100, '����� 24 ������', '����� 24 ������. ���������� ������������i� �� �i�i���������.', 'f24.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (118, 'NDS', 100, '��i� �� ���', '��i� �� ���.', 'nds.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (119, 'abon_volt', 100, '���������� �� ������i', '���������� ������������i� �� �i���� �������.', 'abonvolt.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (120, 'abon_dep', 100, '���������� �� �i�i��.', '���������� ������������i� �� �i�i��������� .', 'abondep.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (121, 'abon_grp', 100, '���������� �� ������.', '���������� ������������i� �� ������ ��������i� .', 'abongrp.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (122, 'prognoz', 100, '�������.', '����i� �����i� ��������� �i������.', 'prognoz.xls', NULL,130);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (13, 'abon_saldo', 10, '������ ��������', '��i� ��� ������ ��������', '', '',3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (200, '_gr', NULL, '���������� i�������i�', '���������� i�������i�', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (201, 'clientlist', 200, '�����i� �������i�', '�����i� �������i�', 'clientlist.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (202, 'ind_now', 200, '������i ������ ��i�� ', '�����i� �������i�, �� ������i ������ ��i� ��� ���������� �� ������� ����', 'ind_now.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (203, 'ind_dates', 200, '���� ������� ��i�i� ', '�����i� �������i� �� ����� ������� ��i�i� ��� ���������� ', 'ind_dates.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (204, 'ind_debtor', 200, '�� ������ ������ ��i�� ', '�����i� �������i�, �� ������ �� ������ ��i� ��� ����������', 'IndicDebtor.xls', NULL,1024+6);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (205, 'bill_debtor', 200, '���������i �������', '�����i� �������i�, �� ����� ���������i ������ �������', 'bill_debtor.xls', NULL,1024+12);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (206, 'bill_list', 200, '������� �� ���i��', '������� �� ���i��', 'billist.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (207, 'pay_list', 200, '������ �� ���i��', '������ �� ���i��', 'paylist.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (208, 'pay_abon', 200, '������ �� ������', '������ �� ������ ��������i�.', 'payabon.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (209, 'debet_list', 200, '�i���i��� ���i���i�', '�i���i��� ���i���i�', 'debetlist.xls', NULL,1024+30);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (210, 'kt_list', 200, '�i���i��� ��������i�', '�i���i��� ��������i�', 'debetlist.xls', NULL,1024+30);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (211, 'nodemand', 200, '������� ����������', '��������, �� ����� ������� ����������', 'nodemand.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (212, 'metnodemand', 200, '�i�������� ��� �����.', '�i��������, �� �� ����� ��������i�.', 'metnodemand.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (213, 'abon_count', 200, '�������i��� �������i�', '��i� ��� �������i��� �������i�.', 'abon_count.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (214, 'pointlist', 200, '�.���i�� ��������', '�������������� ����� ���i�� ���������Ϥ �����i� ��������.', 'pointlist.xls', NULL,5);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (215, 'switch', 200, '�i���������', '���� �������i� (�i���������).', 'switchlist.xls', NULL,1024+0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (216, 'prognozpay', 200, '��������i �������', '���������� ��� ���������� ������.', 'prognozpay.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (217, 'progpayadd', 200, '���������� �������', '���������� ��� ���������� ������ � ����������� �����.', 'progpayadd.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (218, 'progpayad5', 200, '������� �� 5 �������', '���������� ��� ������ � ����������� ����� �� 5-�� ������', 'progpayadd5.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (219, 'progpaydem', 200, '������� c �������', '���������� ��� ������ � ����������� ����� �� 5-�� ������', 'progpaydem5.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (220, 'empty_ind', 200, '������i ��i��', '������i ��i�� ��� ���������� �� �������i �������.', 'empty_ind.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (221, 'avg_area_dem', 200, '�����Τ.������. �� ����.', '���������i����� ���������� �� ����������� �� �i�.', 'avg_area_dem.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (222, 'compens_cnt', 200,  '������������.�����.< 5%', '������������  ������������i� �� ���i���.', 'compens_cnt.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (223, 'doc_revis', 200,  '������������� �������i�', '��i� �� ������������� �������i�', 'doc_revis.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (224, 'check2kr', 200,  '�����i��� ������i� �� 2��', '�����i��� ��������i ������i� �� ����������� �i�i�� ����������', 'check2kr.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (225, 'check2krNoLimit', 200,  '���������� ��� �i�i�i�', '���������� �������i�, ��� ���� �� ������� �i�i� ����������', 'check2kr_nolimit.xls', NULL,2);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (300, '_gr', NULL, '������', '������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (301, 'f32', 300, '����� 32 ������', '����� 32 ������. �������� ������ ��������������', 'f32.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (302, 'for4nkre', 300, '��� 4 ���� ', '�������� ������ �������������� �� �������� ������� � ������� ����������', 'for4nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (303, '4nkre', 300, '4 ���� ', '����� 4 ����.', '4nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (304, 'abon_tar', 300, '���������� �� �������', '���������� ������������i� �� �������.', 'abontarif.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (305, 'all_tar', 300, '����� ���i�� �� �������', '�����i� ����� ���i�� �� ���������� ������������i� �� �������.', 'abonalltarif.xls', NULL,518);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (306, 'abontar_2month', 300, '���i������ ����. �� ���.', '���i������ ���������� ������������i� �� �������.', 'abon_tar_2month.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (307, '9nkre_d1', 300, '9 ���� ���.1', '������� 1 �� 9 ����. �������i ������.', '9nkre_d1.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (308, '9nkre_d2', 300, '9 ���� ���.2', '������� 2 �� 9 ����. ���i�i��i �����i���i�.', '9nkre_d2.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (309, '9nkre_d3', 300, '9 ���� ���.3', '������� 1 �� 9 ����. ������� ���i����i���ϧ �������.', '9nkre_d3.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (400, '_gr', NULL, '���.������', '���.������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (401, 'tar_3zon', 400, '���������� �� �����', '���������� �� ������� i ����� ��� 3-������ �i�������i� ', 'tar_3zon.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (402, 'met_3zon', 400, '���������', '���������� ���� ���������i� ����� �i� ��i������� ���������� ��. �����i� �� ���. �������� ', 'met_3zon.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (403, 'tar_2zon', 400, '�������i', '���������� �� ��������� ���i��� ', 'tar_2zon_new.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (404, 'lighting', 400, '���i������', '���������� ���� ���������i� ����� �i� ��i������� ���������� ��. �����i�,��� ����������դ���� ��� ���Φ������ ��צ������.', 'lighting.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (414, 'lost_nolost', 400, '������i/���������i', '��������� ��������� �i������ (������i/���������i)  ', 'lost_nolost.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (415, 'abon_volt_lst', 400, '���������� �� ���/������.', '���������� ������������i� �� ��������i ��������� �i������.', 'abonvoltlst.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (416, 'rep_forEN', 400, '��i� ��� �������������', '��i� ��� ������������� ', 'repforen.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (417, 'rep_forENR', 400, '��i� �� �����.�i�����.', '��i�  �� ���������� �i���������', 'repforenR.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (500, '_gr', NULL, '���������� ���i�', '���������� ���i�', NULL, NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (501, 'tax_book', 500 , '����� ���i�� �������', '����� ���i�� ������� ', 'tax_book.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (502, 'tax_list', 500 , '������ ��', '������ ���������� ��������� ', 'taxlist.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (503, 'tax_listgrp', 500 , '������ �� � �������', '������ ���������� ��������� ', 'taxlistgrp.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (504, 'tax_reestr', 500 , '��e��� ��', '��e��� ���������� ��������� ', 'tax_reestr.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (505, 'freetaxnum', 500 , '��������i ������', '�����i�  ���������� �����i� ���������� ��������� ', 'freetaxnum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (506, 'taxcheck', 500 , '�����i���', '�����i��� ���������� ��������� ', 'taxchecklist.xls', NULL,10);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (600, '_gr', NULL, '���� ���i�', '���� ���i�', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (601, 'akt1', 600 , '��� ��i���.', '��� ��i��� ���������i� ', 'akt1.xls', NULL,13);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (602, 'akt2', 600 , '��� ��i��� (����.).', '��� ��i��� ���������i� ��� ��������� ��������i� ', 'akt2.xls', NULL,13);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (603, 'akt3', 600 , '��� ��i��� (3 ���.).', '��� ��i��� ���������i� (�� ���. �������) ', 'akt3.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (604, 'akt_2z', 600 , '��� ��i��� (2 ���.).', '��� ��i��� ���������i� (�� 2 ������ ���. �������) ', 'akt_2z.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (605, 'akt4', 600 , '��� �� ���i����.', '��� ��i��� ���������i� (�� ���i����) ', 'akt4.xls', NULL,15);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (606, 'akt5', 600 , '��� ��i��� (���������)', '��� ��i��� ���������i� (�������� i�������i� �� �������� �� �����i) ', 'akt5.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (607, 'akt_tr', 600 , '��� ��i��� (��.������.)', '��� ��i��� ���������i� (�� �i������ �����������������) ', 'akt_trans.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (608, 'akt_him', 600 , '��� ��i��� (�i�. ����.)', '��� ��i��� ���������i� (�� �i�i��i� ������������i) ', 'akt_him.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (609, 'akt_osv', 600 , '��� ��i��� (���.���.)', '��� ��i��� ���������i� (������� ���i������) ', 'akt_osv.xls', NULL,3);

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

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (800, '_gr', NULL, '��������i', '��������i ��i��', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (801, 'r_f32', 800, '4 ���� ��', '�������� ��������Ϥ ������������i� �� �������� ������ ', 'r_f32.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (802, 'r_f49', 800, '����� 49 ������', '����� 49 ������', 'r_f49.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (803, 'r_compens', 800, '���������i� �����.', '��i� �� ���������i� ����� �i� �������i� ��������Ϥ ������������i� ', 'r_compens.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (900, '_gr', NULL, '�i��������', '�i��������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (901, 'meterlist', 900, '�����i�', '�����i� �i�������i� � ����� ���i���.', 'meterlist.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (902, 'metercheck', 900, '����i��� ���i���', '�����i� �i�������i�, ���� ����i��� ���i��� � ��������� ���i��i.', 'meterchecklist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (903, 'worm_meters', 900, '������. ��i��� �7.15 ����', '���������� �� �i���������, ������������ � ������������� ����i����i.', 'worm_meter.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (904, 'print_tt', 900, '���i�������i ��.', '���������� �� ���i��������� ���������������.', 'tt_demand.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1000, '_gr', NULL, '����i����i', '����i����i', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1001, 'gor1', 1000, '����� (�������)', '����� ��� ��i�� �� ���������� ���� �������� ', 'ForGor1.xls', NULL,1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1002, 'cnt05', 1000, '���� 05-39-11/5677', 'I�������i� ��� ���� ���� ����� 05-39-11/5677 �i� 01.12.05 ', 'count2005.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1003, 'rentdates', 1000, '����i� ������', '�����i� �������i�, � ���� ���i��դ���� ����i� ������. ', 'rentdates.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1004, 'point_err', 1000, '������� � i����i� ', '����� ���i��, i�������i� �� ���� �� ���� ������� �� ��i�i� ����� ���������i ���i � i����i�. ', 'point_err.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1005, 'gor_kur', 1000, '���� �����i���', '���� �����i��� ���i�i�. ', 'grafik.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1006, 'kur_meter', 1000, '�i�������� �� ��ҭ���', '�i�������� �� ��ҭ��� ', 'kur_meter.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1007, 'tables', 1000, '��������� ����', '��������� ����. ', 'tablelist.xls', NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1008, 'points_ta2', 1000, '����� ���i�� (�.�.2)', '������� �.2. �������� i�������i� �� ������ ���i�� ��������i�, ��ɭ������ �� �i��� ������� >=6 �� ', 'points_6kv.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1009, 'points_ta2_all', 1000, '����� ���i�� (��i)', '�������� i�������i� �� ������ ���i�� ��������i� (��i �i��i �������) ', 'points_all.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1010, 'abon_point_un', 1000, '���i������ �� ������i', '���i������ �������i� �� ����� ���i�� �� ������i ', 'abon_point_un.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1011, 'clientlist_fps', 1000, '��������i ���� 04/02-1478', ' �����i� ��������i� � ������� ��� �i��������� ( ��i��� ����� 04/02-1478). ', 'clientlist_fps.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1012, 'warning_debet', 1000, '������������(�����)', '���� ����������� ��� ���������� ����������������� ���i�����', 'warning_1.xls', NULL,1+2+4+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1013, 'warning_avans', 1000, '������������(�����)', '���� ����������� ��� ���������� ����������������� ���i����� (�����)', 'warning_2.xls', NULL,1+2+4+1024);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1100, '_gr', NULL, '�i�i��', '�i�i��', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1101, 'limit_list', 1100, '�i�i�� ���������', '�i�i�� ���������� �� �i����', 'limit_list.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1200, '_gr', NULL, '���i������', '���i������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1201, 'abon_point_un', 1200, '���i������ �� ������i', '���i������ �������i� �� ����� ���i�� �� ������i ', 'abon_point_un.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1202, 'monitor_a2', 1200, '����.�.2 (��������)', '������� �.2. �������� i�������i� ���� ��������i�, ��ɭ������ �� ������i ������� 0.4 �� ', 'monitor_a2.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1203, 'monitor_a3', 1200, '����.�.3 (��������)', '������� �.3. �������� i�������i� ���� ��������i�, ��ɭ������ �� �������� ������� 6-154 �� ', 'monitor_a3.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1204, 'monitor_a6', 1200, '����� ���i�� (�.�.6)', '������� �.6. �������� i�������i� �� ������ ���i�� ��������i�, ��ɭ������ �� �i��� ������� >=6 �� ', 'points_6kv.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1205, 'monitor_a4', 1200, '��� ����.�.4 ', 'I�������i� ��� ���������� ������i �.4 ', 'monitor_a4.xls', NULL,2+32);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1206, 'monitor_a2m', 1200, '����.�.2 (���.���)', '������� �.2. �������� i�������i� ���� ��������i�, ��ɭ������ �� ������i ������� 0.4 �� (�i���� ��� ����i�i������ ���)', 'monitor_a2.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1207, 'monitor_a3m', 1200, '����.�.3 (���.���)', '������� �.3. �������� i�������i� ���� ��������i�, ��ɭ������ �� �������� ������� 6-154 �� (�i���� ��� ����i�i������ ���)', 'monitor_a3.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1208, 'monitor_a6m', 1200, '����.�.6 (���.���)', '������� �.6. �������� i�������i� �� ������ ���i�� ��������i�, ��ɭ������ �� �i��� ������� >=6 �� (�i���� ��� ����i�i������ ���) ', 'points_6kv.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1209, 'monitor_a4m', 1200, '��� ����.�.4(���.���)', 'I�������i� ��� ���������� ������i �.4 ( ��� ����i�i������ ���)', 'monitor_a4.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1210, 'ms_voltage', 1200, '������i/��� �� ������i', '�������� i�������i� �� ����������, ��ɭ������ �� �i���� �i���� �������', 'ms_voltage.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1300, '_gr', NULL, '������', '������', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1301, 'plomblistall', 1300, '�����i� ����� �� ����', '�����i� �����, �� ����������i ������ �� ������� ����:', 'plomb_list_now.xls', NULL,1+4+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1302, 'plombinstall', 1300, '����������i ������', '�����i� �����, �� ����������i �� ���i�� ', 'plomb_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1303, 'plombdelete', 1300, '����i ������', '�����i� �����, �� ����i �� ���i�� ', 'plomb_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1304, 'worklist', 1300, '������ �� ���i��', '�����i� ���i�, �� �������i �� ���i�� ', 'work_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1305, 'worktech', 1300, '����i� ���.�����i���', '�����i� ����� ���i��, � ���� ����i� �i� ����i��Ϥ �����i��� ���i��խ���� �� : ', 'worktech.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1306, 'workcontr', 1300, '����i� �����.������', '�����i� ����� ���i��, � ���� ����i� �i� ������������ ������ ���i��խ���� �� : ', 'worktech.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1307, 'workreq', 1300, '����i� ��������� �����', '�����i� ����� ���i��, � ���� ����i� ��������� ����� ������� �� ������� ����', 'workreq.xls', NULL,4);

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

  drop table rep_f32_tbl;
  -- ������� ��� ������ "����� 32 ������"
  create table rep_f32_tbl (

--   dt_b   date,
--   dt_e   date,
   id_department int default getsysvar('kod_res'),
   ident varchar(10),
   caption varchar(100),
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
   mmgg date
  );


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
   mmgg date
  );



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

alter table rep_areas_points_tbl add column un int;

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
