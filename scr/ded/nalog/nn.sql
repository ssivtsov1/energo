insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(15,'tax_num_ending','varchar(15)',''); 
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(16,'last_tax_num','int',0); 
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(17,'id_abon_taxn','int',0); 

--��������� ��
--create sequence acm_taxnum_seq maxvalue 32767;
drop view acv_taxadvtariff;
select DropTable('acd_taxcorrection_tbl');
select DropTable('acm_taxadvcor_tbl');
select DropTable('acm_taxcorrection_tbl');
select DropTable('acd_tax_tbl');
select DropTable('acm_tax_tbl');
select DropTable('acm_billtax_tbl');



create table acm_tax_tbl (
     id_doc		int default nextval('dcm_doc_seq'),
     dt			timestamp default now(),
     id_person		int,
     id_pref            int,          -- ��� ������� � ������ (������� ��� 1999���)
     kind_calc          int,          -- ��� ��������� (�� ����� 1 /����� 2/�� ������ 3) 
     budget             int,          -- ��������� ����������� 1
     reg_num            varchar(25),
     reg_date           date,
     id_client          int, -- 
     value		numeric(14,4),
     value_tax          numeric(14,4),
     id_bill            int,     
     mmgg               date default fun_mmgg(),
     flock              int default 0,  
     int_num            int,
     auto 		int, 
     pay_p 		int,
     primary key(id_doc),
     foreign key (id_client) references clm_client_tbl (id),
     foreign key (id_bill) references acm_bill_tbl (id_doc)
);

--������ ��
select DropTable('acd_tax_tbl');
create sequence acd_tax_seq  maxvalue 32767;
create table acd_tax_tbl (
     id			int default nextval('acd_tax_seq') ,
     dt			timestamp default now(),
     id_person		int,
     id_doc		int,
     dt_bill            date,           -- ������� 2
     unit               varchar(10),
     text               varchar(35),
     demand_val         int,            -- ���������� ���
     tariff		numeric(14,4),  -- ����� (����)
     sum_val7		numeric(14,4) default 0,
     sum_val8		numeric(14,4) default 0,  --����� � ��������������� ��������
     sum_val9		numeric(14,4) default 0,
     sum_val10		numeric(14,4) default 0,

     id_tariff		int,  
     id_sumtariff	int,  

     mmgg               date default fun_mmgg(),
     flock              int default 0,
     primary key(id),
     foreign key (id_doc) references acm_tax_tbl (id_doc)
);


--��������� �������������
create sequence acm_taxcornum_seq maxvalue 32767;
select DropTable('acm_taxcorrection_tbl');
create table acm_taxcorrection_tbl (
     id_doc		int default nextval('dcm_doc_seq'),
     dt			timestamp default now(),
     id_person		int,
     id_pref            int,          -- ��� ������� 
     kind_calc          int default 1,          -- ��� ������������� (��������� 0/������ 1/...)
--     budget             int,          -- ��������� �����������
     reg_num            varchar(25),
     reg_date           date,
     id_client          int, -- ref to client
     id_tax             int, -- �������������� �� �� ����� 
     id_bill            int, -- ����, ������� ��������� �������    
     value		numeric(14,4),
     value_tax          numeric(14,4),
     mmgg               date default fun_mmgg(),
     flock              int default 0,  
     reason             varchar(200),     --������� 
     tax_num            varchar(25),              -- ����� �������������� ��
     tax_date           date,             -- ���� �������������� ��
     primary key(id_doc),
     foreign key (id_client) references clm_client_tbl (id),
     foreign key (id_tax) references acm_tax_tbl (id_doc)
);

--������ �������������
select DropTable('acd_taxcorrection_tbl');
create sequence acd_taxcorrection_seq  maxvalue 32767;
create table acd_taxcorrection_tbl (
     id			int default nextval('acd_taxcorrection_seq') ,
     dt			timestamp,
     id_person		int,
     id_doc		int,
     unit               varchar(10),
     tariff		numeric(14,4),  -- ����� (����)
     id_tariff		int,   
     id_sumtariff	int,   
     cor_demand         int,            -- ������������� ���������� ���
     cor_sum_20		numeric(14,4),  --
     cor_sum_0		numeric(14,4),  --������������� ����� 
     cor_sum_free	numeric(14,4),  --
     cor_tax            numeric(14,4),  --������������� ���
     cor_tax_credit     numeric(14,4),  --����. ���������� �������

     mmgg               date default fun_mmgg(),
     flock              int default 0,

     demand             int,               -- ����� "���. ��������"
     cor_tariff         numeric(14,4),     --
     primary key(id),
     foreign key (id_doc) references acm_taxcorrection_tbl (id_doc)
);


-- ��������� ������� ��������������� 
select DropTable('acm_taxadvcor_tbl');
create sequence acm_taxadvcor_seq  maxvalue 32767;
create table acm_taxadvcor_tbl (
     id			int default nextval('acm_taxadvcor_seq') ,
     dt			timestamp,
     id_person		int,

     id_pref            int,           -- ��� ������� � ������ (������� ��� 1999���)
     id_advance		int,           -- �� � �������
     id_correction	int,           -- �������������� (���� ��� �� ������)
     id_bill            int,           -- ����, �� ������� ������������ �������������
     demand_val	        int,            -- ���������� ���
     sum_val		numeric(14,4),

     mmgg               date default fun_mmgg(),
     flock              int default 0,
     primary key(id),
     foreign key (id_advance) references acm_tax_tbl (id_doc),
     foreign key (id_correction) references acm_taxcorrection_tbl (id_doc)
);

--viev, ������� ������ ���������� ���������� ������ � ��������
-- � ������������ ����� �� ������� 
drop view acv_taxadvtariff;
CREATE VIEW acv_taxadvtariff(id_doc,reg_date,reg_num,id_client,id_pref,tariff,id_tariff,id_sumtariff,sum_rest)
AS

 select adv.id_doc,adv.reg_date, adv.reg_num,adv.id_client,adv.id_pref,ads.tariff,ads.id_tariff, ads.id_sumtariff,
 (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0) as sum_rest
-- ads.demand_val-coalesce(ac.demand_cor,0) as demand_rest
            
 -- �� �� ����� ������ �������� ������ ���� ������, ��������� ������ ����� ���� 
 -- ���������
 from 
 (acm_tax_tbl as adv left join acd_tax_tbl as ads on (adv.id_doc=ads.id_doc and kind_calc in (2,21)  ))
 left outer join 
 (select id_advance, sum(demand_val) as demand_cor, sum(sum_val) as sum_cor
 from acm_taxadvcor_tbl group by id_advance) as ac
 on (ac.id_advance=adv.id_doc)
 where (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0)>0 
 order by adv.reg_date;


-- ������� �������� �� ������� ����� �����, �� ������� �������� ������������� ��� ��
select DropTable('acm_billtax_tbl');
create table acm_billtax_tbl (
     id_doc		int,
     id_sumtariff	int default 1, 
     zone_koef          numeric(14,4),
     demand_val         int,            -- ���������� ���
     sum_val		numeric(14,4),
     id_tax             int,      -- ����� ���������� ��������� (�� ��� �������������), ��� �������� �������� ��������� ������
     mmgg               date default fun_mmgg(),
     source             int  default 0      -- ������� ������������� ( 0 - ��, 1 - �������������)
--     primary key(id_doc,id_sumtariff)
);

-- ������� ����������� ����
select DropTable('syi_holidays_tbl');
--create table syi_holidays_tbl (
--     date_h    date,
--     primary key(date_h)
--);

