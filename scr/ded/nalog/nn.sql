insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(15,'tax_num_ending','varchar(15)',''); 
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(16,'last_tax_num','int',0); 
insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(17,'id_abon_taxn','int',0); 

--Заголовки НН
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
     id_pref            int,          -- тип енергии и период (текущий или 1999год)
     kind_calc          int,          -- тип наклкдной (по счету 1 /аванс 2/по оплате 3) 
     budget             int,          -- бюджетная организация 1
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

--Строки НН
select DropTable('acd_tax_tbl');
create sequence acd_tax_seq  maxvalue 32767;
create table acd_tax_tbl (
     id			int default nextval('acd_tax_seq') ,
     dt			timestamp default now(),
     id_person		int,
     id_doc		int,
     dt_bill            date,           -- колонка 2
     unit               varchar(10),
     text               varchar(35),
     demand_val         int,            -- количество кВт
     tariff		numeric(14,4),  -- Тариф (цена)
     sum_val7		numeric(14,4) default 0,
     sum_val8		numeric(14,4) default 0,  --суммы в соответствующих столбцах
     sum_val9		numeric(14,4) default 0,
     sum_val10		numeric(14,4) default 0,

     id_tariff		int,  
     id_sumtariff	int,  

     mmgg               date default fun_mmgg(),
     flock              int default 0,
     primary key(id),
     foreign key (id_doc) references acm_tax_tbl (id_doc)
);


--Заголовки корректировок
create sequence acm_taxcornum_seq maxvalue 32767;
select DropTable('acm_taxcorrection_tbl');
create table acm_taxcorrection_tbl (
     id_doc		int default nextval('dcm_doc_seq'),
     dt			timestamp default now(),
     id_person		int,
     id_pref            int,          -- тип енергии 
     kind_calc          int default 1,          -- тип корректировки (автоматом 0/ручная 1/...)
--     budget             int,          -- бюджетная организация
     reg_num            varchar(25),
     reg_date           date,
     id_client          int, -- ref to client
     id_tax             int, -- корректируемая НН на аванс 
     id_bill            int, -- счет, который оплатился авансом    
     value		numeric(14,4),
     value_tax          numeric(14,4),
     mmgg               date default fun_mmgg(),
     flock              int default 0,  
     reason             varchar(200),     --причина 
     tax_num            varchar(25),              -- номер корректироемой НН
     tax_date           date,             -- дата корректируемой НН
     primary key(id_doc),
     foreign key (id_client) references clm_client_tbl (id),
     foreign key (id_tax) references acm_tax_tbl (id_doc)
);

--Строки корректировки
select DropTable('acd_taxcorrection_tbl');
create sequence acd_taxcorrection_seq  maxvalue 32767;
create table acd_taxcorrection_tbl (
     id			int default nextval('acd_taxcorrection_seq') ,
     dt			timestamp,
     id_person		int,
     id_doc		int,
     unit               varchar(10),
     tariff		numeric(14,4),  -- Тариф (цена)
     id_tariff		int,   
     id_sumtariff	int,   
     cor_demand         int,            -- корректировка количество кВт
     cor_sum_20		numeric(14,4),  --
     cor_sum_0		numeric(14,4),  --корректировка суммы 
     cor_sum_free	numeric(14,4),  --
     cor_tax            numeric(14,4),  --корректировка НДС
     cor_tax_credit     numeric(14,4),  --Корр. налогового кредита

     mmgg               date default fun_mmgg(),
     flock              int default 0,

     demand             int,               -- Група "кор. вартости"
     cor_tariff         numeric(14,4),     --
     primary key(id),
     foreign key (id_doc) references acm_taxcorrection_tbl (id_doc)
);


-- погашение авансов корректировками 
select DropTable('acm_taxadvcor_tbl');
create sequence acm_taxadvcor_seq  maxvalue 32767;
create table acm_taxadvcor_tbl (
     id			int default nextval('acm_taxadvcor_seq') ,
     dt			timestamp,
     id_person		int,

     id_pref            int,           -- тип енергии и период (текущий или 1999год)
     id_advance		int,           -- НН с авансом
     id_correction	int,           -- коррректировка (если она не пустая)
     id_bill            int,           -- счет, на который выписывалась корректировка
     demand_val	        int,            -- количество кВт
     sum_val		numeric(14,4),

     mmgg               date default fun_mmgg(),
     flock              int default 0,
     primary key(id),
     foreign key (id_advance) references acm_tax_tbl (id_doc),
     foreign key (id_correction) references acm_taxcorrection_tbl (id_doc)
);

--viev, которое должно показывать незакрытые авансы с тарифами
-- и непогашенную сумму по каждому 
drop view acv_taxadvtariff;
CREATE VIEW acv_taxadvtariff(id_doc,reg_date,reg_num,id_client,id_pref,tariff,id_tariff,id_sumtariff,sum_rest)
AS

 select adv.id_doc,adv.reg_date, adv.reg_num,adv.id_client,adv.id_pref,ads.tariff,ads.id_tariff, ads.id_sumtariff,
 (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0) as sum_rest
-- ads.demand_val-coalesce(ac.demand_cor,0) as demand_rest
            
 -- НН на аванс всегда содержит только одну строку, погашений аванса может быть 
 -- несколько
 from 
 (acm_tax_tbl as adv left join acd_tax_tbl as ads on (adv.id_doc=ads.id_doc and kind_calc in (2,21)  ))
 left outer join 
 (select id_advance, sum(demand_val) as demand_cor, sum(sum_val) as sum_cor
 from acm_taxadvcor_tbl group by id_advance) as ac
 on (ac.id_advance=adv.id_doc)
 where (ads.sum_val7+ads.sum_val8+ads.sum_val9+ads.sum_val10)-coalesce(ac.sum_cor,0)>0 
 order by adv.reg_date;


-- таблица разбивки по тарифам суммы счета, на которую выписана корректировка или НН
select DropTable('acm_billtax_tbl');
create table acm_billtax_tbl (
     id_doc		int,
     id_sumtariff	int default 1, 
     zone_koef          numeric(14,4),
     demand_val         int,            -- количество кВт
     sum_val		numeric(14,4),
     id_tax             int,      -- номер налогового документа (НН или корректировки), при создании которого появилась строка
     mmgg               date default fun_mmgg(),
     source             int  default 0      -- признак происхождения ( 0 - НН, 1 - корректировка)
--     primary key(id_doc,id_sumtariff)
);

-- таблица праздничных дней
select DropTable('syi_holidays_tbl');
--create table syi_holidays_tbl (
--     date_h    date,
--     primary key(date_h)
--);

