create table mni_planworks_tbl (
	id serial,
        id_grp int,
	name varchar(100),
	primary key(id)
)
WITH OIDS;


--delete from mni_planworks_tbl;

insert into mni_planworks_tbl (id,name) values (1,'���������� �� ��������� ���������� ��������� ������� ����������  ���������i, ��.');
insert into mni_planworks_tbl (id,name) values (2,'����i��� �����i��� ������������� �����i� ���i�� � ��������� ��������i�, ��. ');
insert into mni_planworks_tbl (id,name) values (3,'����i��� �����i��� ������������� �����i� ���i�� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (4,'����������� ����� �����i� ���i�� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (5,'����������� ����� �����i� ���i�� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (6,'���i�� �����i� ���i�� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (7,'���i�� �����i� ���i�� � �i������ ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (8,'��������� ����� �� �������� ������� ��������i� �� �����i� ���i�� �� �����i����� �����, ��.');
insert into mni_planworks_tbl (id,name) values (9,'������������ �����i� ���i�� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (10,'������������ �����i� ���i�� ��� ����i����� ���i��, ��.');
insert into mni_planworks_tbl (id,name) values (11,'������������ �����i� ���i�� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (12,'�i���i��� ���������� ����i�, ��.');
insert into mni_planworks_tbl (id,name) values (13,'���������� ��������� ������ �������� (���), ��.');
insert into mni_planworks_tbl (id,name) values (14,'�����i��� ���������� ����������� ��������� ������� ����������  ���������i, ��.');
insert into mni_planworks_tbl (id,name) values (15,'�����i��� �����i� ���������� ��������Ϥ ���������i, ��.');
insert into mni_planworks_tbl (id,name) values (16,'��������� ����i�i� ��������� ���������� ���������Ϥ �����i� �� ���������i (���, ���), ��.');
insert into mni_planworks_tbl (id,name) values (17,'�i�������� �� ���������� �������� ���i�i�, ��.');
insert into mni_planworks_tbl (id,name) values (18,'���������� ��������i� 1 �������i�, ��.');
insert into mni_planworks_tbl (id,name) values (19,'������ �����i� �i�������i� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (20,'������ �����i� �i�������i� � ��������� ��������i�, ��.');
insert into mni_planworks_tbl (id,name) values (21,'���������� ������i� �� ������ ��������� ����������, ��.');
insert into mni_planworks_tbl (id,name) values (22,'���������� ������i� ��������� ����������, ��.');
insert into mni_planworks_tbl (id,name) values (23,'���������� ������i� ��������� ����������, ��.');
insert into mni_planworks_tbl (id,name) values (24,'�������� (������������) �������i�, ������������ ����');
insert into mni_planworks_tbl (id,name) values (25,'�������� (������������) �������i�, ������������ �����');
insert into mni_planworks_tbl (id,name) values (26,'������i�i���� �������� (�i���i��� ���������� ��, ��)');
insert into mni_planworks_tbl (id,name) values (27,'���������� �� 10��, ��');
insert into mni_planworks_tbl (id,name) values (28,'���������� �� 0,4 ��, ��');
insert into mni_planworks_tbl (id,name) values (29,'��������� ���i������� ������i� �� (��), ��.');
insert into mni_planworks_tbl (id,name) values (30,'���i�� ���������������� �������������i�, ��.');
insert into mni_planworks_tbl (id,name) values (31,'���i�� �������������� �������������i�, ��.');
insert into mni_planworks_tbl (id,name) values (32,'���i�������� �������� ����������� � �����i 0,4 ��, ��.');
insert into mni_planworks_tbl (id,name) values (33,'���i�� "�������" ������i� �� ��������i, ��');
insert into mni_planworks_tbl (id,name) values (34,'��������� ����i�� ���i��� �������������i� ������ 0,4 �� ');
insert into mni_planworks_tbl (id,name) values (35,'���i�� �i���������� �i� �� 0,4 �� �� ������, ��� i���������� ����i�, ��.');
insert into mni_planworks_tbl (id,name) values (36,'���i�� ����i� �� �������������� �i�i�� 10 ��, ��.');
insert into mni_planworks_tbl (id,name) values (37,'���i�� ����i� �� �������������� �i�i�� 0,4 ��, ��.');


create table mnm_plan_works_tbl 
(
  id serial NOT NULL,
  id_fider integer,
  id_type integer,
  cnt numeric(14,3) ,
  mmgg date,
  PRIMARY KEY (id)
) 
WITH OIDS;
