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
  flag_param int,        -- 123 (биты) 1-дата, 2-период, 3 -абонент ... 
  primary key(id)           
);

*/
  CREATE AGGREGATE sum ( BASETYPE = text,
                         SFUNC = textcat,
                         STYPE = text,
                         INITCOND = '' );


--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name) VALUES (1, 'oborot', 1, 'Оборотна вiдомiсть АЕ', ' Оборотна вiдомiсть розрахунку за активну електроенергiю', 'oborot.rpt', 'ObSaldo');
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name) VALUES (2, 'sales', 1, 'Довiдка факт. реал. АЕ', ' Довiдка про фактичну реалiзацiю за активну енергiю', 'sales.rpt', 'Sales');


--alter table rep_kinds_tbl alter column name TYPE varchar(50);

delete from rep_kinds_tbl;

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (100, '_gr', NULL, 'Обороти', 'Обороти', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (101, 'oborot', 100, 'Оборотна вiдомiсть', 'Оборотна вiдомiсть розрахунку за електроенергiю', 'oborot.xls', 'ObSaldo',10);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (102, 'oborot_r', 100, 'Оборотна вiдомiсть РЕ', 'Оборотна вiдомiсть розрахунку за реактивну електроенергiю', 'oborot.xls', 'ObSaldo',2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (103, 'oborot_nds', 100, 'Оборотна вiдомiсть з ПДВ', 'Оборотна вiдомiсть розрахунку за електроенергiю (розгорнуто по ПДВ)', 'oborot_nds.xls', NULL,10+128);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (104, 'oborot_err', 100, 'Перевiрка оборот. вiдом.', 'Пошук помилок в оборотнiй вiдомiстi розрахунку за електроенергiю (розгорнуто по ПДВ)', 'oborot_err.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (105, 'oborot_5kr', 100, 'Оборотна вiдомiсть 2кр факт', 'Оборотна вiдомiсть розрахунку по застосуванню пiдвищеної плати за перевищення договiрних обсягiв споживання електроенергiї ', 'oborot_5kr.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (106, 'oborot_2kr2014', 100, 'Оборотна вiдомiсть 2кр 2014', 'Оборотна вiдомiсть плати за перевищення договiрних обсягiв споживання електроенергiї (по оплатi)', 'oborot_2kr2014.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (107, 'oborot_1', 100, 'Оборотна вiдомiсть абон.', 'Оборотна вiдомiсть по абоненту. ', 'oborot_1.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (109, 'oborot_akt', 100, 'Оборотна  по актам ', 'Оборотна  по актам за порушення режиму споживання', 'oborot_akt.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (114, 'sales', 100, 'Довiдка факт. реал.', 'Довiдка про фактичну реалiзацiю ', 'sales.xls', 'Sales',10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (115, 'sales_abon', 100, 'Довiдка факт. реал. абон.', 'Довiдка про фактичну реалiзацiю розгорнута по абонентах', 'sales_abon.xls', null,10+1024);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (115, 'sales_r', 100, 'Довiдка факт. реал. РЕ', 'Довiдка про фактичну реалiзацiю за реактивну енергiю', 'sales.xls', 'Sales',2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (116, 'oborot_short', 100, 'Оборотна вiдомiсть (свод)', 'Оборотна вiдомiсть на 1 сторiнку', 'oborot_sh.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (117, 'f24', 100, 'Форма 24 енерго', 'Форма 24 енерго. Споживання електроенергiї по мiнiстерствах.', 'f24.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (118, 'NDS', 100, 'Звiт по ПДВ', 'Звiт по ПДВ (до березня 2011 року включно).', 'nds.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (119, 'NDS2011', 100, 'Звiт по ПДВ(квiтень 2011)', 'Звiт по ПДВ (з квiтня 2011 року).', 'nds2011.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (120, 'NDS2016', 100, 'Звiт по ПДВ(2016)', 'Звiт по ПДВ -  2016 року ', 'nds2016.xls', NULL,10);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (121, 'NDS2016_inf', 100, 'Звiт по ПДВ(деталiзацiя 2016)', 'Деталiзацiя оплати та нарахування 2016 року та попереднiх перiодiв (РЕ).', 'nds2016_billpay.xls', NULL,10);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (122, 'abon_volt', 100, 'Споживання по напрузi', 'Споживання електроенергiї по рiвням напруги.', 'abonvolt.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (123, 'abon_dep', 100, 'Споживання по мiнiст.', 'Споживання електроенергiї по мiнiстерствах .', 'abondep.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (124, 'abon_grp', 100, 'Споживання по групам.', 'Споживання електроенергiї по групах споживачiв .', 'abongrp.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (125, 'prognoz', 100, 'Прогноз.', 'Аналiз обсягiв корисного вiдпуску.', 'prognoz.xls', NULL,130+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (126, 'oborot_year', 100, 'Споживання за рiк', 'Оборотна вiдомiсть (споживання за рiк)', 'oborot_year.xls', Null,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (127, 'point_dem_year', 100, 'Споживання за рiк по ТУ.', 'Споживання за рiк по точкам облiку', 'point_dem_year.xls', Null,2+8);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (128, 'abon_extra', 100, 'Споживання по дод.параметрам', 'Споживання електроенергiї по додатковим параметрам облiкiв.', 'abonextra.xls', NULL,10);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (13, 'abon_saldo', 10, 'Сальдо абонента', 'Звiт про сальдо абонента', '', '',3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (200, '_gr', NULL, 'Оперативна iнформацiя', 'Оперативна iнформацiя', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (201, 'clientlist', 200, 'Перелiк абонентiв', 'Перелiк абонентiв', 'clientlist.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (202, 'ind_now', 200, 'Повиннi надати звiти ', 'Перелiк абонентiв, що повиннi надати звiт про споживання на вказану дату', 'ind_now.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (203, 'ind_dates', 200, 'Дати надання звiтiв ', 'Перелiк абонентiв по датам надання звiтiв про споживання ', 'ind_dates.xls', NULL,16384+1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (204, 'ind_debtor', 200, 'Не надали вчасно звiти ', 'Перелiк абонентiв, що вчасно не надали звiт про споживання', 'IndicDebtor.xls', NULL,16384+1024+6);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (205, 'bill_debtor', 200, 'Неоплаченi рахунки', 'Перелiк абонентiв, що мають неоплаченi вчасно рахунки', 'bill_debtor.xls', NULL,1024+12);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (206, 'bill_list', 200, 'Рахунки за перiод', 'Рахунки за перiод', 'billist.xls', NULL,16384+1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (207, 'pay_list', 200, 'Оплата за перiод', 'Оплата за перiод', 'paylist.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (208, 'pay_abon', 200, 'Оплата по групам', 'Оплата по групах споживачiв.', 'payabon.xls', NULL,1024+10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (209, 'debet_list', 200, 'Вiдомiсть дебiторiв', 'Вiдомiсть дебiторiв', 'debetlist.xls', NULL,1024+30);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (210, 'kt_list', 200, 'Вiдомiсть кредиторiв', 'Вiдомiсть кредиторiв', 'debetlist.xls', NULL,1024+30);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (211, 'nodemand', 200, 'Нульове споживання', 'Абоненти, що мають нульове споживання', 'nodemand.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (212, 'metnodemand', 200, 'Лiчильники без показ.', 'Лiчильники, що не мають показникiв.', 'metnodemand.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (213, 'abon_count', 200, 'Чисельнiсть абонентiв', 'Звiт про чисельнiсть абонентiв.', 'abon_count.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (214, 'pointlist', 200, 'Т.облiку абонента', 'Характеристики точок облiку електричної енергiї абонента.', 'pointlist.xls', NULL,5);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (215, 'switch_new', 200, 'Вiдключення(новi)', 'Стан абонентiв (вiдключення) Нова методика.', 'switchlistnew.xls', NULL,1024+0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (216, 'switch_period_new', 200, 'Вiдключення за перiод (новi) ', 'Змiна стану абонентiв (вiдключення) за перiод. Нова методика', 'switchlistnew.xls', NULL,1024+2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (217, 'switch', 200, 'Вiдключення(стар)', 'Стан абонентiв (вiдключення).', 'switchlist.xls', NULL,1024+0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (218, 'switch_period', 200, 'Вiдключення за перiод(стар) ', 'Змiна стану абонентiв (вiдключення) за перiод.', 'switchlist.xls', NULL,1024+2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (219, 'prognozpay', 200, 'Подекаднi виплати', 'Розрахунок сум подекадних виплат.', 'prognozpay.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (220, 'progpayadd', 200, 'Подекадний прогноз', 'Розрахунок сум подекадних виплат з врахуванням оплат.', 'progpayadd.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (221, 'progpayad5', 200, 'Прогноз по 5 дневкам', 'Розрахунок сум виплат з врахуванням оплат по 5-ти денкам', 'progpayadd5.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (222, 'progpaydem', 200, 'Прогноз c тарифом', 'Розрахунок сум виплат з врахуванням оплат по 5-ти денкам', 'progpaydem5.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (223, 'empty_ind', 200, 'Порожнi звiти', 'Порожнi звiти про споживання та авансовi рахунки.', 'empty_ind.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (224, 'avg_area_dem', 200, 'Середнї.спожив. по майд.', 'Середньомiсячне споживання по майданчикам за 6 мiс.', 'avg_area_dem.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (225, 'avg_area_dem12', 200, 'Сер.спож.по майд.12 мiс', 'Середньомiсячне споживання по майданчикам за 12 мiс.', 'avg_area_dem12.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (226, 'compens_cnt', 200,  'Завантаження.трасф.< 5%', 'Завантаження  трасформаторiв на облiках.', 'compens_cnt.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (227, 'abonfider_compens', 200,  'Завант.трасф.<5%(2 мiс)', 'Облiк недоврахованої електроенергiї при споживаннi менше 5% завантаженостi облiкового трансформатора (поточний та попереднiй перiоди).', 'abonfider_compens.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (228, 'doc_revis', 200,  'Переукладання договорiв', 'Звiт по переукладанню договорiв', 'doc_revis.xls', NULL,1024+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (229, 'check2kr', 200,  'Споживання,лiмiти та 2кр', 'Лiмiти споживання активної енергiї та фактичне споживання', 'check2kr.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (230, 'check2kr_area', 200,  'Перевiрка рахункiв по 2кр', 'Перевiрка наявностi рахункiв за перевищення лiмiту споживання', 'check2kr_sum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (231, 'check2krNoLimit', 200,  'Споживання без лiмiтiв', 'Споживання абонентiв, для яких не вказано лiмiт споживання', 'check2kr_nolimit.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (232, 'abonpower', 200, 'Потужнiсть абонентiв', 'Перелiк абонентiв (дозволена потужнiсть)', 'clientlist_power.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (233, 'abonpointpower', 200, 'Приєднана потужнiсть по об`єктам', 'Точки облiку абонентiв (приєднана потужнiсть)', 'clientpointlist_power.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (234, 'unif_fiz', 200, 'Единий податок', 'Перелiк доходiв у розрiзi контрагентiв - платникiв єдиного податку', 'unif_fiz_sum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (235, 'point_procent', 200, 'Змiна споживання по ТУ %.', 'Змiна споживання по точкам облiку', 'point_dem_procent.xls', Null,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (236, 'debet_pay', 200, 'Погашення дебет.заборг.', 'Погашення дебеторської заборгованостi', 'debet_pay.xls', Null,2+8);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (237, 'oborot_1_all', 200, 'Кредит попереднiх рокiв.', 'Кредит попереднiх рокiв.', 'kt_years_all.xls', NULL,10+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (238, 'old_kt', 200, 'Невикористанi платежi', 'Протермiнованi невикористанi платежi. Вкажiть дату, з якої вважати платежi протермiнованими ', 'old_kt.xls', NULL,4+8+4096);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (300, '_gr', NULL, 'Тарифы', 'Тарифы', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (301, 'f32', 300, 'Форма 32 енерго', 'Форма 32 енерго. Полезный отпуск електроенергии', 'f32.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (302, 'for4nkre', 300, 'Для 4 НКРЕ ', 'Полезный отпуск електроенергии по тарифным группам и классам напряжения', 'for4nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (303, '4nkre', 300, '4 НКРЕ ', 'Форма 4 НКРЕ.', '4nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (304, 'abon_tar', 300, 'Споживання по тарифах', 'Споживання електроенергiї по тарифах.', 'abontarif.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (305, 'all_tar', 300, 'Точки облiку по тарифах', 'Перелiк точок облiку та споживання електроенергiї по тарифах.', 'abonalltarif.xls', NULL,518);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (306, 'abontar_2month', 300, 'Порiвняння спож. по тар.', 'Порiвняння споживання електроенергiї по тарифах.', 'abon_tar_2month.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (307, '9nkre_d1', 300, '9 НКРЕ дод.1', 'Додаток 1 до 9 НКРЕ. Населенi пункти.', '9nkre_d1.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (308, '9nkre_d2', 300, '9 НКРЕ дод.2', 'Додаток 2 до 9 НКРЕ. Релiгiйнi органiзацiї.', '9nkre_d2.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (309, '9nkre_d3', 300, '9 НКРЕ дод.3', 'Додаток 1 до 9 НКРЕ. Заклади пенiтенцiарної системи.', '9nkre_d3.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (310, '8nkre', 300, '8 НКРЕ', 'Форма 8 НКРЕ (Додаток 1-3)', '8nkre.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (311, 'nasp_demand', 300, 'По насел. та нас. пунктах', 'Споживання за тарифами населення та нас.пунктiв', 'nasp_demand.xls',NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (312, 'common_account', 300, 'Насел.за загальним лiч.', 'Споживання населення, яке розраховується за загальним засобом облiку', 'common_account.xls',NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (313, 'own_needs', 300, 'Власнi потреби', 'Довiдка про використання електроенергiї на господарчi потреби', 'own_needs.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (400, '_gr', NULL, 'Диф.тарифы', 'Диф.тарифы', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (401, 'tar_3zon', 400, 'Споживання по зонам', 'Споживання по тарифам i зонам для 3-зонних лiчильникiв ', 'tar_3zon.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (402, 'met_3zon', 400, 'Дифтарифи', 'Розрахунок суми компенсацiї втрат вiд здiйснення постачання ел. енергiї за диф. тарифами ', 'met_3zon.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (403, 'tar_2zon', 400, 'Двозоннi', 'Споживання по двозонним облiкам ', 'tar_2zon_new.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (404, 'met_3zonfiz', 400, 'Тризоннi (фiз)', 'Розрахунок суми компенсацiї втрат вiд здiйснення постачання ел. енергiї за диф. тарифами населення', 'met_3zonfiz.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (405, 'tar_2zonfiz', 400, 'Двозоннi (фiз)', 'Споживання по двозонним облiкам за диф. тарифами населення', 'tar_2zonfiz.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (406, 'lighting', 400, 'Освiтлення', 'Розрахунок суми компенсацiї втрат вiд здiйснення постачання ел. енергiї,яка використовуїться для зовнішнього освітлення.', 'lighting.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (414, 'lost_nolost', 400, 'Втратнi/Безвтратнi', 'Структура корисного вiдпуску (Втратнi/Безвтратнi)  ', 'lost_nolost.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (415, 'abon_volt_lst', 400, 'Споживання по втр/безвтр.', 'Споживання електроенергiї по структурi корисного вiдпуску.', 'abonvoltlst.xls', NULL,10+8192);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (416, 'rep_forEN', 400, 'Звiт для Енергонагляду', 'Звiт для Енергонагляду ', 'repforen.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (417, 'rep_forENR', 400, 'Звiт по реакт.лiчильн.', 'Звiт  по реактивним лiчильникам', 'repforenR.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (418, 'zone_meters', 400, 'Споживання по зонним лiч.', 'Iнформацiя щодо обсягiв споживання по споживачах, якi розраховуються за тарифами, диференцiованими за перiодами часу', 'zone_meters_all.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (500, '_gr', NULL, 'Податковий облiк', 'Податковий облiк', NULL, NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (501, 'tax_book', 500 , 'Книга облiку продажу', 'Книга облiку продажу ', 'tax_book.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (502, 'tax_list', 500 , 'Журнал ПН', 'Журнал податкових накладних ', 'taxlist.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (503, 'tax_listgrp', 500 , 'Журнал ПН с групами', 'Журнал податкових накладних ', 'taxlistgrp.xls', NULL,10);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (504, 'tax_reestr', 500 , 'Реeстр ПН', 'Реeстр податкових накладних ', 'tax_reestr.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (505, 'tax_reestr_2010', 500 , 'Реeстр ПН (2010)', 'Реeстр податкових накладних (з сiчня 2010 р.)', 'tax_reestr2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (505, 'tax_reestr_2011', 500 , 'Реeстр ПН (2011)', 'Реeстр виданих та отриманих податкових накладних (з сiчня 2011 р.)', 'tax_reestr2011.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (506, 'tax_reestr_fast', 500 , 'Реeстр ПН (для 1С)', 'Реeстр виданих та отриманих податкових накладних (для завантаження в 1С бухгалтерiю)', 'tax_reestr2011s.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (507, 'freetaxnum', 500 , 'Пропущенi номери', 'Перелiк  пропущених номерiв податкових накладних ', 'freetaxnum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (508, 'taxcheck', 500 , 'Перевiрка', 'Перевiрка податкових накладних ', 'taxchecklist.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (509, 'taxcheckdecade', 500 , 'Перевiрка по декадам', 'Перевiрка податкових накладних по декадам (2015 р.)', 'taxchecklist_decade.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (510, 'taxcheckstr', 500 , 'Перевiрка рядкiв ПН', 'Перевiрка податкових накладних на вiдповiднiсть суми в реєстрi та сум в табличнiй частинi ПН', 'taxcheckstr.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (511, 'taxchecknopay', 500 , 'Перевiрка ПН неплатникiв', 'Перевiрка пiдсумкових податкових накладних по неплатникам ПДВ', 'taxchecknopay.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (512, 'tax_list_abon', 500 , 'ПН абонента', 'Журнал податкових накладних абонента за перiод', 'taxlist_abon.xls', NULL,1+2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (510, 'tax_nds_err', 500 , 'Рiзниця ПДВ', ' Рiзниця розрахованого та фактичного ПДВ в податкових накладних ', 'tax_nds_err.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (513, 'taxcor_reestr', 500 , 'Перелiк коригувань (додаток 1)', 'Перелiк коригувань податкових накладних (для завантаження в 1С бухгалтерiю)', 'taxcor_reestr.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (600, '_gr', NULL, 'Друк актiв', 'Друк актiв', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (601, 'akt1', 600 , 'Акт звiрки.', 'Акт звiрки розрахункiв ', 'akt1.xls', NULL,13);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (602, 'bill_saldo', 600, 'Довiдка по розр.', 'Довiдка про стан розрахункiв', 'bill_saldo.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (603, 'akt2', 600 , 'Акт звiрки (бюдж.).', 'Акт звiрки розрахункiв для бюджетних споживачiв ', 'akt2.xls', NULL,13);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (604, 'akt3', 600 , 'Акт звiрки (3 зон.).', 'Акт звiрки розрахункiв (по диф. тарифам) ', 'akt3.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (605, 'akt_2z', 600 , 'Акт звiрки (2 зон.).', 'Акт звiрки розрахункiв (по 2 зонним диф. тарифам) ', 'akt_2z.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (606, 'akt4', 600 , 'Акт по перiодах.', 'Акт звiрки розрахункiв (по перiодах) ', 'akt4.xls', NULL,15);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (607, 'akt4list', 600 , 'Звiрка по перiодах.', 'Звiрка розрахункiв (по перiодах) ', 'akt4list.xls', NULL,4+8);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (608, 'akt5', 600 , 'Акт звiрки (докладний)', 'Акт звiрки розрахункiв (докладна iнформацiя по рахункам та оплатi) ', 'akt5.xls', NULL,11);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (609, 'akt_tr', 600 , 'Акт звiрки (ел.трансп.)', 'Акт звiрки розрахункiв (по мiському електротранспорту) ', 'akt_trans.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (610, 'akt_him', 600 , 'Акт звiрки (хiм. пром.)', 'Акт звiрки розрахункiв (по хiмiчнiй промисловостi) ', 'akt_him.xls', NULL,3);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (611, 'akt_osv', 600 , 'Акт звiрки (вул.осв.)', 'Акт звiрки розрахункiв (Вуличне освiтлення) ', 'akt_osv.xls', NULL,3);



INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (700, '_gr', NULL, 'Пiдключення', 'Звiти про пiдключення абонентiв до мережi РЕМ', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (701, 'abonfider', 700 , 'Пiдключенi абоненти.', 'Абоненти згрупованi за мiсцем пiдключення. ', 'abonfider.xls', NULL,96);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (702, 'abonfider_mem', 700 , 'Пiдключенi абоненти(MEM)', 'Абоненти згрупованi за мiсцем пiдключення (Варiант для Чернiгiвських МЕМ). ', 'abonfider_mem.xls', NULL,96+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (703, 'abonfider_inf', 700 , 'Пiдключ.абоненти докл.', 'Абоненти згрупованi за мiсцем пiдключення (докладна iнформацiя по точкам та лiчильникам). ', 'abonfider_info.xls', NULL,32+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (704, 'psfider_mem', 700 , 'Пофiдерна структура(MEM)', 'Пофiдерна структура мереж з кiлькiстю пiдключених абонентiв. ', 'psfider_mem.xls', NULL,32+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (705, 'abonnofider', 700 , 'Непiдключенi абоненти.', 'Абоненти, не пiдключенi до мережi РЕМ. ', 'abonnofider.xls', NULL,64);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (706, 'abonps', 700 , 'По пiдстанцiям.', 'Абоненти,  пiдключенi до пiдтанцiї (Потужнiсть). ', 'abonps.xls', NULL, 288);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (707, 'fizabonfiderdem', 700 , 'Спожив. населення по ПС', 'Споживання населення за мiсцем пiдключення. ', 'fizabonfiderdem.xls', NULL,34);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (708, 'border', 700 , 'Границя з РЕМ', 'Перелiк абонентiв, що пiдключенi безпосередньо до мереж РЕМ.', 'border.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (709, 'abonconnect', 700 , 'Перевiрка фiз. осiб', 'Перелiк абонентiв з мiсцем пiдключення ', 'abonconnect.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (710, 'pointnometer', 700,'Без приладiв облiку', 'Перелiк точек облiку не обладнаних приладами облiку ', 'pointnometer.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (711, 'rep_con_abon', 700,'Новi пiдключення', 'Звiт по новим пiдключеним абонентам', 'newconnect.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (712, 'border2', 700 , 'Що мають субабонентiв', 'Перелiк абонентiв, що мають субабонентiв.', 'border2.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (713, 'subabons', 700 , 'Перелiк субабонентiв', 'Перелiк абонентiв з субабонентами.', 'subabons.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (714, 'master_demand', 700,'Обсяг передачi субабон.', 'Обсяг передачi електроенергii субабонентам ', 'client_masterdemand.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (715, 'homenets_demand', 700 , 'Внутрiшньобуд. мережi', 'Баланс надходження та споживання електроенергiї у внутришньобудинкових мережах .', 'homenets.xls', NULL,2+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (716, 'homenet_lines', 700 , 'Лiнii внутрiшньобуд.мереж', 'Параметри кабельних лiнiй у внутришньобудинкових мережах .', 'homenet_lines.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (717, 'prognoz_fider', 700 , 'План-завдання', 'План-завдвння (перед формуванням плановi показники занести в таблицю "Расчеты" -"Плановые показатели" )', 'prognoz_fider.xls', NULL,2+32+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (718, 'fact_fider', 700 , 'Виконання плану', 'Фактичне виконання плану-завдвння (перед формуванням плановi показники занести в таблицю "Расчеты" -"Плановые показатели" )', 'prognoz+fact_fider.xls', NULL,2+32+1024);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (719, 'fact_fider_insp', 700 , 'Виконання плану (пiдсумок)', 'Фактичне виконання плану-завдвння ', 'prognoz+fact_insp.xls', NULL,2+32+1024);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (720, 'fidersdemand', 700 , 'Споживання по ТУ', 'Споживання абонента по точкам облiку за мiсцем пiдключення', 'abonfider_dem.xls', NULL,1+2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (721, 'ps10_load', 700 , 'Завантаження ПТ10/0.4', 'Iнформацiя щодо завантаження та резерву потужностi трансформаторних пiдстанцiй 10/0.4 кВ', 'ps10_load.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (722, 'ps10_rezerv', 700 , 'Резерв потужн.ПТ10/0.4', 'Iнформацiя щодо резерву потужностi трансформаторних пiдстанцiй 10/0.4 кВ', 'ps10_rezerv.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (723, 'ps35_load', 700 , 'Завантаження ПТ110-35/10', 'Iнформацiя щодо завантаження та резерву потужностi трансформаторних пiдстанцiй 110-35/10 кВ', 'ps35_load.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (724, 'ps35_rezerv', 700 , 'Резерв потужн.ПТ110-35/10', 'Iнформацiя щодо резерву потужностi трансформаторних пiдстанцiй ПТ110-35/10 кВ', 'ps35_rezerv.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (725, 'switch_list', 700 , 'Комутацiйне обладнання', 'Перелiк комутацiйного обладнання', 'switch_list.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (726, 'ps35_summary', 700 , 'Кiлькiсть абон. по ПТ110-35/10', 'Iнформацiя щодо cпоживачiв електричної енергiї з прив''язкою їх до пiдстанцiй 110/35/10 кВ, 110/10 кВ та 35/10 кВ', 'ps35_abon_summary.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (727, 'compens_tp_abon', 700 , 'Трансформатори абонентських ТП', 'Трансформатори абонентських ТП', 'compens_tp_abon.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (728, 'ps10_demand', 700 , 'Споживання по ПТ10/0.4', 'Споживання по трансформаторних пiдстанцiях 10/0.4 кВ', 'ps10_demand.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (729, 'abonfider04', 700 , 'Пiдключення до Л0.4', 'Абоненти згрупованi за мiсцем пiдключення (з урахуванням лiнiй 0.4 кВ). ', 'abonfider_04.xls', NULL,96+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (730, 'abonfider04sum', 700 , 'Iнформацiя по Л0.4', 'Iнформацiя щодо завантаження лiнiй 0.4 кВ. ', 'abonfider_04_sum.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (731, 'psfider_new', 700 , 'Фiз абоненти по пiдст.', 'Кiлькiсть пiдключених абонентiв (фiз осiб). ', 'psfider_new.xls', NULL,32+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (732, 'psfider_dem', 700 , 'Спожив фiз.абон по пiдст.',  'Рiчне споживання пiдключених абонентiв (фiз осiб). ', 'psfider_dem.xls', NULL,32+2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (800, '_gr', NULL, 'Реактивнi', 'Реактивнi звiти', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (801, 'r_f32', 800, '4 НКРЕ РЕ', 'Перетоки реактивної електроенергiї по тарифним групам ', 'r_f32.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (802, 'r_f49', 800, 'Форма 49 енерго', 'Форма 49 енерго', 'r_f49.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (803, 'r_compens', 800, 'Компенсацiя втрат.', 'Звiт по компенсацiї втрат вiд перетокiв реактивної електроенергiї ', 'r_compens.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (804, 'reactiv_2010', 800, 'Розрахунок по ТУ.', 'Iнформацiя щодо розрахункiв плати за перетiкання реактивної електроенергiї', 'reactiv2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (805, 'reactiv_2014', 800, 'Спожив. та генерацiя РЕ по ТУ.', 'Споживання та генерацiя РЕ по точкам облiку за перiод', 'reactiv2014.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (900, '_gr', NULL, 'Лiчильники', 'Лiчильники', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (901, 'meterlist', 900, 'Перелiк', 'Перелiк лiчильникiв з датою повiрки.', 'meterlist.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (902, 'meter_indications', 900, 'Поточнi показники', 'Поточнi показники лiчильникiв .', 'meter_indication.xls', NULL, 1+4+32+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (903, 'metercheck', 900, 'Потрiбна повiрка (перiод)', 'Перелiк лiчильникiв, яким потрiбна повiрка у вказаному перiодi.', 'meterchecklist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (904, 'meterchecklate', 900, 'Потрiбна повiрка(дата)', 'Перелiк лiчильникiв, по яким настала дата повiрки.', 'meterchecklist2.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (905, 'worm_meters', 900, 'Лiч.у неопалюваному примiщеннi', 'Споживання по лiчильникам, встановленим у неопалюваному примiщеннi.', 'worm_meter.xls', NULL,10);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (906, 'print_tt', 900, 'Вимiрювальнi тр.', 'Споживання по вимiрювальним трансформаторам.', 'tt_demand.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (907, 'inspect_control', 900, 'Контрольнi зйоми', 'Звiт по контрольному зйому показникiв.', 'inspectcontrol.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (908, 'meter_unchecked', 900, 'Нема контр. зйомiв', 'Перелiк лiчильникiв, на яких не проводився контрольний зйом показникiв', 'meter_unchecked.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (909, 'meter_change', 900, 'Замiни лiчильникiв', 'Замiни лiчильникiв за перiод', 'meter_changes.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (910, 'meter_change2', 900, 'Замiни (повiрка)', 'Замiни лiчильникiв, яким потрiбна повiрка.', 'meter_changes2.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (911, 'meter_change_avgdem', 900, 'Знятi лiчильники', 'Знятi лiчильники за перiод', 'meter_changes_avgdem.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (912, 'meter_indic_hist', 900, 'Iсторiя лiчильникiв', 'Iсторiя зняття показникiв та iнших подiй лiчильникiв за перiод', 'meter_indic_hist.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (913, 'bad_indic_list', 900, 'Контроль показань', 'Перелiк лiчильникiв, на яких знайденi неспiвпадiння поточних показань з контрольними', 'bad_indication.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (914, 'dub_meterlist', 900, 'Пошук дублiв', 'Пошук дублiв номерiв лiчильникiв.', 'meterdubl.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (915, 'metnodemand3', 900, 'Без споживання >2 мiс.', 'Лiчильники, що не мають показникiв або мають нульове споживання бiльше 2 мiсяцiв.', 'metnodemand3.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (916, 'meter_area_dem', 900, 'Спожив.по лiч./майд.', 'Споживання по лiчильникам та майданчикам за мiс.', 'meter_area_dem.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (917, 'meterlistavg', 900, 'Перелiк+споживання ', 'Перелiк лiчильникiв та середнє споживання.', 'meterlistavg.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (918, 'ttchecklate', 900, 'Потрiбна повiрка ТТ', 'Перелiк лiчильникiв, по яким настала дата повiрки вимiрювальних трансформаторiв.', 'ttcheck_date.xls', NULL,4+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (919, 'meter2_5', 900, 'Лiч. класа точностi 2.5', 'Перелiк лiчильникiв, якi мають клас точностi 2.5 (Лист-вимога)', 'meter2_5list.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (920, 'meter_tt_check', 900, 'Потрiбна повiрка(вимога)', 'Перелiк облiкiв, по яким настала дата повiрки лiчильникiв або вимiрювальних трансформаторiв (Лист-вимога).', 'meterchecklist_new.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (921, 'tt_summary', 900, 'Кiлькiсть ТС по групам', 'Кiлькiсть вимiрювальних трансформаторiв струму по групам.', 'tt_summary.xls', NULL,4);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1000, '_gr', NULL, 'Спецiальнi', 'Спецiальнi', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1001, 'gor1', 1000, 'Угода (горсети)', 'Угода про змiни та доповнення умов договору ', 'ForGor1.xls', NULL,1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1002, 'cnt05', 1000, 'Лист 05-39-11/5677', 'Iнформацiя для НКРЕ щодо листа 05-39-11/5677 вiд 01.12.05 ', 'count2005.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1003, 'rentdates', 1000, 'Термiн оренди', 'Перелiк абонентiв, у яких закiнчуїться термiн оренди. ', 'rentdates.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1004, 'rentdates_all', 1000, 'Термiн оренди (перелiк)', 'Дати закiнчення термiну договорiв оренди', 'rentdates_all.xls', NULL,4+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1005, 'point_err', 1000, 'Помилки в iсторiї ', 'Точки облiку, iнформацiя по яким не буде вибрана до звiтiв через некоректнi данi в iсторiї. ', 'point_err.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1006, 'gor_kur', 1000, 'План перевiрок', 'План перевiрок облiкiв. ', 'grafik.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1007, 'kur_meter', 1000, 'Лiчильники по курєрам', 'Лiчильники по курєрам ', 'kur_meter.xls', NULL,1024+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1008, 'tables', 1000, 'Структура бази', 'Структура бази. ', 'tablelist.xls', NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1008, 'points_ta2', 1000, 'Точки облiку (Т.А.2)', 'Таблиця А.2. Загальна iнформацiя по точкам облiку споживачiв, приєднаних до рiвня напруги >=6 кВ ', 'points_6kv.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1009, 'points_ta2_all', 1000, 'Точки облiку (всi)', 'Загальна iнформацiя по точкам облiку споживачiв (всi рiвнi напруги) ', 'points_all.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1010, 'abon_point_un', 1000, 'Монiторинг по напрузi', 'Монiторинг абонентiв та точок облiку по напрузi ', 'abon_point_un.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1011, 'clientlist_fps', 1000, 'Споживачi лист 04/02-1478', ' Перелiк споживачiв з данними про пiдключення ( згiдно листа 04/02-1478). ', 'clientlist_fps.xls', NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1012, 'warning_debet', 1000, 'Попередження(дебет)', 'Друк попереджень про припинення електропостачання дебiторам', 'warning_1.xls', NULL,1+2+4+1024);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1013, 'warning_avans', 1000, 'Попередження(аванс)', 'Друк попереджень про припинення електропостачання дебiторам (аванс)', 'warning_2.xls', NULL,1+2+4+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1014, 'warning_debet_list', 1000, 'Перелiк попередж.(дебет)', 'Перелiк для попереджень про припинення електропостачання дебiторам', 'warning_list1.xls', NULL,2+4+1024+16384);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1015, 'warning_avans_list', 1000, 'Перелiк попередж.(аванс)', 'Перелiк для попереджень про припинення електропостачання дебiторам (аванс)', 'warning_list2.xls', NULL,2+4+1024+4096+16384);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1016, 'eqp_change', 1000, 'Змiни в схемi', 'Змiни в схемi за перiод', 'eqp_change.xls', NULL,1+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1017, 'point_change', 1000, 'Змiни потужностi', 'Змiни потужностi на точках облiку за перiод', 'point_change.xls', NULL,2+4096);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1018, 'renthist', 1000, 'Тимчасовi договори', 'Тимчасовi договори про постачання електроенергii, термiн яких закiнчуїться', 'renthist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1019, 'point_count', 1000, 'Чисельнiсть точок', 'Звiт про чисельнiсть точок облiку.', 'abon_count_dem.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1020, 'abon_area_dem', 1000, 'Майданчики абонентiв', 'Обсяги постачання електричної енергiї споживачу по майданчикам', 'abon_area_dem.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1021, 'abon_tar_year', 1000, 'Рiчне споживання (АЕ+РЕ)', 'Iнформацiя щодо рiчного споживання активної та реактивної енергiї по абоненту', 'abon_tar_year.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1022, 'abon_area_summary', 1000, 'Майданчики(потужн.+категор.)', 'Приєднана, дозволена потужнiсть та категорiйнiсть по майданчикам абонентiв', 'clientlist_area_power.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1023, 'saldo_dt_kt', 1000, 'Дт/Кт заборгованiсть', 'Дебiторська та кредиторська заборгованiсть', 'saldo_dt_kt.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1024, 'avans_analiz', 1000, 'Перевiрка аванса (-3) ', 'Перевiрка сплати авансових платежiв абонентами, якi повиннi платити аванс до початку розрахункового перiода', 'avansanaliz.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1025, 'abon_lines', 1000 , 'Лiнii абонентських мереж', 'Параметри лiнiй абонентських мережа .', 'abonlines.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1026, 'abon_points', 1000 , 'Точки облiку (параметри)', 'Точки облiку абонентiв', 'abonpoints.xls', NULL,1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1027, 'bill_deleted', 1000 , 'Видаленi рахунки', 'Видаленi рахунки', 'bill_deleted.xls', NULL,2);


INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1100, '_gr', NULL, 'Лiмiти', 'Лiмiти', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1101, 'limit_list', 1100, 'Лiмiти споживння', 'Лiмiти споживання на мiсяць', 'limit_list.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1102, 'limit_year', 1100, 'Лiмiти споживння на рiк', 'Лiмiти споживання на рiк', 'limit_year.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1103, 'limit_area_year', 1100, 'Лiмiти спож.по майданчикам на рiк', 'Лiмiти споживання на рiк по майданчикам', 'limitarea_year.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1104, 'limit2kr_calc', 1100, 'Розрах. макс. лiмiта', 'Розрахунок максимально можливого лiмiту споживання, виходячи з наявностi передоплати. ', 'limit_calc.xls', NULL,2+4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1105, 'area_check', 1100, 'Перевiрка майданчикiв', 'Перевiрка годин роботи та потужностi майданчикiв ', 'area_check.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1106, 'check_limit_power', 1100, 'Перевiрка лiмiтiв(потужн*годин)', 'Перевiрка лiмiту споживання, виходячи з годин роботи та потужностi майданчикiв ', 'check2kr_area_power.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1107, 'limit_area_change', 1100, 'Коригування лiмiтiв', 'Коригування лiмiтiв за перiод ', 'limit_area_change.xls', NULL,2);


--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1200, '_gr', NULL, 'Монiторинг 2009', 'Монiторинг 2009', NULL, NULL,0);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1201, 'abon_point_un', 1200, 'Монiторинг по напрузi', 'Монiторинг абонентiв та точок облiку по напрузi ', 'abon_point_un.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1202, 'monitor_a2', 1200, 'Табл.А.2 (загальна)', 'Таблиця А.2. Загальна iнформацiя щодо споживачiв, приєднаних на ступенi напруги 0.4 кВ ', 'monitor_a2.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1203, 'monitor_a3', 1200, 'Табл.А.3 (загальна)', 'Таблиця А.3. Загальна iнформацiя щодо споживачiв, приєднаних на ступенях напруги 6-154 кВ ', 'monitor_a3.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1204, 'monitor_a6', 1200, 'Точки облiку (Т.А.6)', 'Таблиця А.6. Загальна iнформацiя по точкам облiку споживачiв, приєднаних до рiвня напруги >=6 кВ ', 'points_6kv.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1205, 'monitor_a4', 1200, 'Для Табл.А.4 ', 'Iнформацiя для формування Таблицi А.4 ', 'monitor_a4.xls', NULL,2+32);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1206, 'monitor_a2m', 1200, 'Табл.А.2 (Чер.МЕМ)', 'Таблиця А.2. Загальна iнформацiя щодо споживачiв, приєднаних на ступенi напруги 0.4 кВ (Тiльки для Чернiгiвських МЕМ)', 'monitor_a2.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1207, 'monitor_a3m', 1200, 'Табл.А.3 (Чер.МЕМ)', 'Таблиця А.3. Загальна iнформацiя щодо споживачiв, приєднаних на ступенях напруги 6-154 кВ (Тiльки для Чернiгiвських МЕМ)', 'monitor_a3.xls', NULL,2);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1208, 'monitor_a6m', 1200, 'Табл.А.6 (Чер.МЕМ)', 'Таблиця А.6. Загальна iнформацiя по точкам облiку споживачiв, приєднаних до рiвня напруги >=6 кВ (Тiльки для Чернiгiвських МЕМ) ', 'points_6kv.xls', NULL,2);

--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1209, 'monitor_a4m', 1200, 'Для Табл.А.4(Чер.МЕМ)', 'Iнформацiя для формування Таблицi А.4 ( Для Чернiгiвських МЕМ)', 'monitor_a4.xls', NULL,2+32);
--INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1210, 'ms_voltage', 1200, 'Основнi/суб по напрузi', 'Загальна iнформацiя по споживачам, приєднаним на рiзних рiвнях напруги', 'ms_voltage.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1300, '_gr', NULL, 'Монiторинг 2010', 'Монiторинг 2010', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1301, 'abon_count_volt', 1300, 'Чисельнiсть абон.докл(Т5)', 'Звiт про чисельнiсть абонентiв докладний.', 'abon_count_volt.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1302, 'monitor2010_ps10', 1300, 'Звiт по ТП 10 кВ ', ' Перелiк та технiчнi данi  власних ТП 10/6 кВ', 'monitor2010_ps10.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1303, 'monitor_a4_2010', 1300, 'Розгорнутий звiт по ТП10', ' Розгорнута iнформацыя для формування звiту "Перелiк та технiчнi данi  власних ТП 10/6 кВ"', 'monitor_a4_2010.xls', NULL,2+32);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1304, 'monitor_a2_2010', 1300, 'Табл.А.2 (2010)', 'Таблиця А.2. Загальна iнформацiя щодо споживачiв, приєднаних на ступенi напруги 0.4 кВ ', 'monitor_a2_2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1305, 'monitor_a3_2010', 1300, 'Табл.А.3 (2010)', 'Таблиця А.3. Загальна iнформацiя щодо споживачiв, приєднаних на ступенях напруги 6-154 кВ ', 'monitor_a3_2010.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1306, 'monitor_10k', 1300, 'Точки облiку межа >1к', 'Загальна iнформацiя по точкам облiку споживачiв, межа розподiлу  рiвня напруги >=6 кВ ', 'points_6kv.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1400, '_gr', NULL, 'Роботи', 'Роботи', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1401, 'plomblistall', 1400, 'Перелiк пломб на дату', 'Перелiк пломб, що встановленi станом на вказану дату:', 'plomb_list_now.xls', NULL,1+4+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1402, 'plombinstall', 1400, 'Встановленi пломби', 'Перелiк пломб, що встановленi за перiод ', 'plomb_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1403, 'plombdelete', 1400, 'Снятi пломби', 'Перелiк пломб, що снятi за перiод ', 'plomb_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1404, 'worklist', 1400, 'Роботи за перiод', 'Перелiк робiт, що виконанi за перiод ', 'work_list_all.xls', NULL,1+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1405, 'worktech', 1400, 'Термiн тех.перевiрки', 'Перелiк точок облiку, в яких термiн дiї технiчної перевiрки закiнчується до : ', 'worktech.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1406, 'workcontr', 1400, 'Термiн контр.огляду', 'Перелiк точок облiку, в яких термiн дiї контрольного огляду закiнчується до : ', 'worktech.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1407, 'workreq', 1400, 'Термiн виконання вимог', 'Перелiк точок облiку, в яких термiн виконання вимог спливає на вказану дату', 'workreq.xls', NULL,4);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1408, 'noplombnowork', 1400, 'ТУ без паспорта', 'Перелiк точок облiку, для яких не заведено даних про пломби та роботи.', 'noplombnowork.xls', NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1409, 'grafic_work1', 1400 , 'Графiк тех. перевiрок', 'Графiк технiчних перевiрок', 'grafic_work1.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1410, 'grafic_work2', 1400 , 'Графiк контр. оглядiв', 'Графiк контрольних оглядiв', 'grafic_work2.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1411, 'grafic3', 1400, 'Графiк зйому показнь(МЕМ)', 'Графiк зйому контрольних показникiв (МЕМ)', 'abonfider_grafic.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1412, 'grafic_work1_f', 1400 , 'Виконання тех. перевiрок', 'Виконання графiку технiчних перевiрок', 'grafic_work1_fact.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1413, 'grafic_work2_f', 1400 , 'Виконання контр. оглядiв', 'Виконання графiку контрольних оглядiв', 'grafic_work2_fact.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1414, 'grafic3_f', 1400, 'Виконання зйому показнь', 'Виконання графiка зйому контрольних показникiв (МЕМ)', 'abonfider_grafic_fact.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1415, 'grafic_summary', 1400, 'Пiдсумки по роботам', 'Пiдсумки виконання графiкiв контрольних оглядiв,технiчних перевiрок та зйому контрольних показникiв', 'grafic_work_summary.xls', NULL,32+2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1416, 'worklist_dt', 1400, 'Роботи внесенi за перiод', 'Перелiк робiт, що внесенi в базу за перiод ', 'work_list_dt.xls', NULL,2+1024);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1417, 'worklistnone', 1400, 'ТУ де нема робiт', 'Перелiк ТУ, де не виконувались роботи за перiод ', 'work_list_none.xls', NULL,1+2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1418, 'point_dem_magnet', 1400, 'Магнiтнi пломби (спожив. за рiк).', 'Споживання за поточний та попереднiй роки по точкам облiку, де встановлено магнiтнi пломби', 'point_dem_year_magnet.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1419, 'plombfast', 1400, 'Часте перепломбування.', 'Точки облiку, на яких проводилося пломбування 3 чи бiльше разiв', 'plombfast.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1500, '_gr', NULL, 'Транзит', 'Транзит', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1501, '3nkre', 1500, '3 НКРЕ', 'Форма 3-НКРЕ', '3nkre.xls', NULL,2);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1600, '_gr', NULL, 'Монiторинг робiт', 'Монiторинг проведення енергозбутових робiт по дiльницям енергозбуту', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1601, 'fider_monitoring', 1600 , 'Монiтор. робiт по фiдеру', 'Монiторинг проведення енергозбутових робiт по дiльницям енергозбуту', 'monitoring.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1602, 'fider_monitoring_2', 1600 , 'Монiтор. робiт (2 пер.)', 'Монiторинг проведення енергозбутових робiт по дiльницям енергозбуту (порiвняння 2 перiодiв)', 'monitoring_2month.xls', NULL,2+2048);

INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1700, '_gr', NULL, 'Спiльне використання', 'Спiльне використання', NULL, NULL,0);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1701, 'masters_demand', 1700 , 'Обсяги вiддачi', 'Обсяги вiддачi електроенергii з технологiчних мереж спiльного використання', 'masterdemandlist.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1702, 'masters_akt', 1700 , 'Акт (кошторис)', 'Акт прийому - здачi по кошторису (використовуйте кнопку "Печать", щоб отримати акт швидше)', 'masterdemandakt.xls', NULL,2+1);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1703, 'masters_demand_det', 1700 , 'Обсяги вiддачi-деталi', 'Обсяги вiддачi електроенергii з технологiчних мереж спiльного використання - деталiзацiя ', 'masterdemandlistdet.xls', NULL,2);
INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1704, 'masters_losts_det', 1700 , 'Втрати-деталi', 'Значення розрахункових втрат електроенергiї в елементах електричних мереж спiльного використання - деталiзацiя ', 'masterlostsdet.xls', NULL,2);
-- INSERT INTO rep_kinds_tbl (id, ident, id_group, name, full_name, file_name, proc_name,flag_param) VALUES (1705, 'slav_special', 1700 , 'Спiльне викор. КП УЖКХ', 'Спiльне використання КП УЖКХ ', '', NULL,2);

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
  -- таблица для выбора задолженности за предыдущие годы
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
  -- таблица для дополнительной группировки тарифов в отчетах
  create table rep_tarifaddgr_tbl (
  ident varchar(10),
  addgroupid   int,
  addgroupname varchar(50)
  );
*/
/*
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7_1',7 ,'Населення-всього');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7_2',7 ,'Населення-всього');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7_3',7 ,'Населення-всього');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8_1',8 ,'Населенi пункти-всього');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8_2',8 ,'Населенi пункти-всього');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8_3',8 ,'Населенi пункти-всього');
*/
/*
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr7', 7, 'Населення-всього');
INSERT INTO rep_tarifaddgr_tbl (ident, addgroupid, addgroupname) VALUES ('tgr8', 8, 'Населенi пункти-всього');
*/

--  drop table rep_f32_tbl;
  -- таблица для отчета "Форма 32 енерго"
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
  -- таблица для отчетов по 3 зонным счетчикам
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
  -- таблица для отчетов по 2 зонным счетчикам
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
  -- таблица для отчета "Форма 32 енерго"
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