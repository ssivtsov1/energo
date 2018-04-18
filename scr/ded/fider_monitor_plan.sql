create table mni_planworks_tbl (
	id serial,
        id_grp int,
	name varchar(100),
	primary key(id)
)
WITH OIDS;


--delete from mni_planworks_tbl;

insert into mni_planworks_tbl (id,name) values (1,'Визначення та доведення споживачам граничних величин споживання  потужностi, шт.');
insert into mni_planworks_tbl (id,name) values (2,'Технiчна перевiрка розрахункових засобiв облiку у юридичних споживачiв, шт. ');
insert into mni_planworks_tbl (id,name) values (3,'Технiчна перевiрка розрахункових засобiв облiку у побутових споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (4,'Контрольний огляд засобiв облiку у юридичних споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (5,'Контрольний огляд засобiв облiку у побутових споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (6,'Замiна засобiв облiку у юридичних споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (7,'Замiна засобiв облiку у фiзичних споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (8,'Виконання вимог по закриттю доступу споживачiв до засобiв облiку та дооблiкових мереж, шт.');
insert into mni_planworks_tbl (id,name) values (9,'Встановлення засобiв облiку у юридичних споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (10,'Встановлення засобiв облiку для технiчного облiку, шт.');
insert into mni_planworks_tbl (id,name) values (11,'Встановлення засобiв облiку у побутових споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (12,'Кiлькiсть проведених рейдiв, шт.');
insert into mni_planworks_tbl (id,name) values (13,'Обстеження резервних джерел живлення (РДЖ), шт.');
insert into mni_planworks_tbl (id,name) values (14,'Перевiрка дотримання споживачами граничних величин споживання  потужностi, шт.');
insert into mni_planworks_tbl (id,name) values (15,'Перевiрка режимiв споживання реактивно╓ потужностi, шт.');
insert into mni_planworks_tbl (id,name) values (16,'Складання графiкiв обмеження споживання електрично╓ енергi╓ та потужностi (ГОЕ, ГОП), шт.');
insert into mni_planworks_tbl (id,name) values (17,'Пiдготовка та проведення режимних вимiрiв, шт.');
insert into mni_planworks_tbl (id,name) values (18,'Обстеження споживачiв 1 категорi╓, шт.');
insert into mni_planworks_tbl (id,name) values (19,'Зняття показiв лiчильникiв у юридичних споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (20,'Зняття показiв лiчильникiв у побутових споживачiв, шт.');
insert into mni_planworks_tbl (id,name) values (21,'Рознесення рахункiв на оплату побутовим споживачам, шт.');
insert into mni_planworks_tbl (id,name) values (22,'Виставлено рахункiв юридичним споживачам, шт.');
insert into mni_planworks_tbl (id,name) values (23,'Виставлено рахункiв побутовим споживачам, шт.');
insert into mni_planworks_tbl (id,name) values (24,'Укладено (переукладено) договорiв, передбачених ПКЕЕ');
insert into mni_planworks_tbl (id,name) values (25,'Укладено (переукладено) договорiв, передбачених ПКЕЕН');
insert into mni_planworks_tbl (id,name) values (26,'Тепловiзiйний контроль (кiлькiсть обстежених ТП, РП)');
insert into mni_planworks_tbl (id,name) values (27,'Розчищення ПЛ 10кВ, км');
insert into mni_planworks_tbl (id,name) values (28,'Розчищення ПЛ 0,4 кВ, км');
insert into mni_planworks_tbl (id,name) values (29,'Проведено капiтальних ремонтiв ТП (РП), шт.');
insert into mni_planworks_tbl (id,name) values (30,'Замiна недозавантажених трансформаторiв, шт.');
insert into mni_planworks_tbl (id,name) values (31,'Замiна перевантажених трансформаторiв, шт.');
insert into mni_planworks_tbl (id,name) values (32,'Вирiвнювання пофазних навантажень в мережi 0,4 кВ, шт.');
insert into mni_planworks_tbl (id,name) values (33,'Замiна "скруток" проводiв на затискачi, шт');
insert into mni_planworks_tbl (id,name) values (34,'Виконання графiку повiрки трансформаторiв струму 0,4 кВ ');
insert into mni_planworks_tbl (id,name) values (35,'Замiна вiдгалуження вiд ПЛ 0,4 кВ на кабель, або iзольований провiд, шт.');
insert into mni_planworks_tbl (id,name) values (36,'Замiна дротiв на перевантажених лiнiях 10 кВ, км.');
insert into mni_planworks_tbl (id,name) values (37,'Замiна дротiв на перевантажених лiнiях 0,4 кВ, км.');


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
