-- справочники    *_ind_tbl
--    вспомогательные (для описания технических устройств):
--       вид счетчиков (индукционный/электронный)      eqk_meter_tbl (kind_meter_ind_tbl)
--       фазность (однофазный/трехфазный)              eqk_phase_tbl (phase_ind_tbl)
--       справочник видов энергии                      eqk_energy_tbl  (kind_energy_ind_tbl)
--       справочник классов напряжений                 eqk_voltage_tbl (voltage_group_ind_tbl) 
--       схема подключения (потребление/генерация)     eqk_schemains_tbl (schema_inst_ind_tbl)
--       способ включения (непосредственный/через тр.тока/
--           через тр.напряжения/через тр.универсальный
--           звезда-звезда/звезда-зигзаг/звезда-треугольник/
--           звезда-треугольник)                       eqk_hookup_tbl (hook_up_ind_tbl
--       тип (синхронный/асинхронный)                  eqk_sync_tbl (sync_ind_tbl 
--       вид линий (воздушная/кабель)                  eqk_air_undegr_tbl (air_undegr_ind_tbl
--       справочник материалов                         eqk_materals_tbl (materals_ind_tbl
--       признак места установки (0=подстанция/1=на подстанции/2самостоятельно) eqk_in_station_tbl (in_station_ind_tbl
-- 	 группы коммутационного оборудования 	   eqk_switchs_gr_tbl (switchs_gr_ind_tbl)	
--       
--    технические устройства:
--       виды технических устройств         eqi_device_kinds_tbl (devices_ind_tbl) 
--       счетчики
--           справочник счетчиков               eqi_meter_tbl (meter_ind_tbl)
--             допустимая погрешность счетчика  eqi_meter_prec_tbl (meter_prec_ind_tbl)
--             виды счетчиков                  eqk_kind_count_tbl (kind_count_ind_tbl)
--             вид учитываемой энергии для типа счетчика
--			eqi_meter_energy_tbl (meter_energy_ind_tbl)
--       справочник трансформаторов         eqi_compensator_tbl (compensator_ind_tbl)
-- 		2-х обмоточные тр-ры 	    eqi_compensator_2_tbl (compensator_2_ind_tbl)
--		3-х обмоточные тр-ры        eqi_compensator_3_tbl (compensator_3_ind_tbl)
--		тр-ры тока     		    eqi_compensator_i_tbl (compensator_i_ind_tbl)
--       справочник коммутационного оборудования  eqi_switchs_tbl (switchs_ind_tbl)
--       справочник компенсаторов           eqi_jack_tbl (jack_ind_tbl)
--       справочник предохранителей         eqi_fuses_tbl (fuses_ind_tbl)
--             справочник кабелей силовых      eqi_cable_tbl  (cable_ind_tbl)
--             справочник кабелей силовых доп  eqi_cable_с_tbl  (cable_с_ind_tbl)
--             справочник проводов             eqi_corde_tbl (corde_ind_tbl)
--нет             справочник удельного реактивного сопротивления  - not resisters_ind_tbl
--нет             справочник расстояний подвески                  - distanceped_ind_tbl
--             справочник опор                 eqi_pillar_tbl  (pillar_ind_tbl)
--             петли заземления                eqi_earth_tbl   (earth_ind_tbl)

-- Описание электрической сети
--нет    общая схема подключения клинета к эл.сетям - eqm_schema_tbl(schema_eqp_tbl)
--
--       Список деревьев                           - eqm_tree_tbl (tree_tbl)   
-- 	 устройства электрической сети 
--			(Узлы дерева)              - eqm_eqp_tree_tbl
--       Перечень родителей узла                   - eqp_schema_tbl
--	 Общий список оборудования 		   - eqm_equipment_tbl (eqp_tbl)
--
--       схема электрической сети
--     
--       замена оборудования                        - eqm_eqp_change_tbl(eqp_change_tbl)
--       описание единиц оборудования, формирующего цепь подключения клиента:
--            счетчики                              - eqm_meter_tbl (meter_eqp_tbl)
--               зоны счетчика                      - eqm_meter_zone_tbl (meter_zone_eq_tbl)
--		 виды энергии                       - eqm_meter_energy_tbl (meter_energy_eq_tbl)
--
--            трансформаторные подстанции           - eqm_compens_station_tbl (compens_station_eqp_tbl)
--            установка трансформаторов на подстанции - eqm_compens_station_inst_tbl (compens_station_inst_eqp_tbl )
--            трансформаторы                        - eqm_compensator_tbl (compensator_eqp_tbl)
--            трансформаторы  тока                  - eqm_compensator_i_tbl (compensator_i_eqp_tbl)
--            линии                                 - eqm_line_a_tbl (line_a_eqp_tbl)
--	      Кабель				    - eqm_line_c_tbl (line_c_eqp_tbl)
--            маршрут прокладки линии               - eqm_line_path_tbl (line_tbl)
--	      компенсаторы                          - eqm_jack_tbl (jack_eqp_tbl)
--            границы разделов                      - eqm_borders_tbl (borders_eqp_tbl)
--            коммутационное оборудование           - eqm_switch_tbl (switch_eqp_tbl)
--            предохранители                        - eqm_fuse_tbl (fuse_eqp_cl_tbl)
--

-- ------------------------------------------------------------------------
-- фазность (однофазный/трехфазный)              eqk_phase_tbl
drop table eqk_phase_tbl;

create table eqk_phase_tbl (
     id		    int,       -- код вида 
     name           varchar(20),   -- описание (однофазный/трехфазный)
     primary key(id)
);

-- что преобр. трансформатор (ток/напряжение)              eqk_conversion_tbl
drop table eqk_conversion_tbl;

create table eqk_conversion_tbl (
     id		    int,       -- код вида 
     name           varchar(20),   -- описание 
     primary key(id)
);

-- справочник видов энергии
drop table eqk_energy_tbl;

create table eqk_energy_tbl (
     id             int,      -- * вид учитываемой энергии 
     name           varchar(20),  --   наименование (активный/реактивный)
     primary key(id)
);

-- справочник классов напряжений
drop table eqk_voltage_tbl;

create table eqk_voltage_tbl (
     id             int,      -- * класс напражения
     voltage_min    numeric(9,1), --   напражение минимальное
     voltage_max    numeric(9,1), --   напражение максимальное
     primary key(id)
);

-- схема подключения (потребление/генерация)     eqk_schemains_tbl
drop table eqk_schemains_tbl;

create table eqk_schemains_tbl (
     id		    int,       -- *код вида 
     name           varchar(20),   --  описание 
     primary key(id)
);

-- способ включения (непосредственный/через тр.тока/
-- через тр.напряжения/через тр.универсальный
-- звезда-звезда/звезда-зигзаг/звезда-треугольник/
--           eqk_hookup_tbl
drop table eqk_hookup_tbl;

create table eqk_hookup_tbl (
     id             int,       -- *код вида 
     name           varchar(25),   --  описание 
     primary key(id)
);

--  тип (синхронный/асинхронный)                  eqk_sync_tbl 
drop table eqk_sync_tbl;

create table eqk_sync_tbl  (
     id             int,       -- *код вида 
     name           varchar(20),   --  описание 
     primary key(id)
);
/*

--  вид линия (воздушная/кабель) Не используется                 eqk_air_undegr_tbl
drop table eqk_air_undegr_tbl;

create table eqk_air_undegr_tbl (
     id             int,       -- *код вида 
     name           varchar(20),   --  описание 
     primary key(id)
);

*/
--  справочник материалов                         eqk_materals_tbl
drop table eqk_materals_tbl;

DROP SEQUENCE eqk_materals_seq;

CREATE SEQUENCE eqk_materals_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;


create table eqk_materals_tbl (
     id             int DEFAULT nextval('"eqk_materals_seq"'::text),       -- *код вида 
     name           varchar(20),   --  описание 
     ro             numeric(10,6), -- удельное Сопротивление (Ом*мм2/м)
     ro_mantis      int,      -- мантисса удельного сопротивления
     primary key(id)
);
-- виды изоляции
drop table eqk_cover_tbl;
DROP SEQUENCE eqk_cover_seq;

CREATE SEQUENCE eqk_cover_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqk_cover_tbl (
     id             int DEFAULT nextval('"eqk_cover_seq"'::text),       -- *код вида 
     name           varchar(20),   -- описание 
     mu             numeric(8,4),  -- магнитная проницаемость, безразмерная
     ro             numeric(12,6), -- удельное Сопротивление, МОм*м
     primary key(id)
);
/*
--       признак места установки (0=подстанция/1=на подстанции/2=самостоятельно) eqk_in_station_tbl
--       (вроде не используется)
drop table eqk_in_station_tbl;

create table eqk_in_station_tbl (
     id int,       -- код
     name varchar(20), -- описание
     primary key(id)
);
  */
-- тангенс фи для точек учета
DROP SEQUENCE eqk_tg_seq;
CREATE SEQUENCE eqk_tg_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

drop table eqk_tg_tbl;
create table eqk_tg_tbl (
     id             int DEFAULT nextval('"eqk_tg_seq"'::text),       -- *код вида 
     name           varchar(20),   --  описание 
     value          numeric(8,5), -- ?
     primary key(id)
);

-- ------------------------------------------------------------------------
-- виды технических устройств         eqi_devices_tbl
 DROP SEQUENCE eqi_device_kinds_seq;

  CREATE SEQUENCE eqi_device_kinds_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;


drop table eqi_device_kinds_tbl;

create table eqi_device_kinds_tbl (
     id              int DEFAULT nextval('"eqi_device_kinds_seq"'::text),  --* код
     name            varchar(35),        --  описание 
     id_table_ind    int,           --  id таблицы справочника устойств
     id_table        int,           --  id таблицы списка устойств
     calc_lost       int default 0, --  участие в расчете потерь (0-не участвует/1-участвует)
     inst_station    int default 0, --  1- подстанции/площадки, 0 - компоненты сети, 2- точки схождения
--     id_icon         int,
--     table_name      varchar(128), --  
--     table_ind       varchar(128), --  
--     field_name      varchar(128), --  имя поля с усл. обозначением
--     field_code_name varchar(128), --  имя поля связи справочника со списком
     primary key (id)
--     , foreign key (id_table) references s_table_tbl (id)
--     , foreign key (id_table_ind) references s_table_tbl (id)
--       , foreign key (inst_station) references eqk_in_station_tbl (id)
);
---------------------------------------------------------------------------
drop table eqi_device_kinds_prop_tbl;

create table eqi_device_kinds_prop_tbl (
     type_eqp        int,     --* код
     id_icon         int,     -- код значка в программе
     form_name       varchar(35),  -- имя класса формы в программе
     primary key (type_eqp),
     foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
);
-- ------------------------------------------------------------------------
-- вид счетчиков (индукционный/электронный)      eqk_meter_tbl
drop table eqk_meter_tbl;

create table eqk_meter_tbl (
     id             int,       -- *код вида 
     name           varchar(20),   --  описание (индукционный/электронный)
     primary key(id)
);
-- Способ учета
drop table eqk_kind_count_tbl;

create table eqk_kind_count_tbl (
     id              int,      --* код
     name            varchar(35),  --  описание  ( накопление показаний, расход за период)
     primary key(id)
); 

-- справочник- родитель для всех справочников оборудования eqi_devices_parent_tbl
----drop table eqi_devices_parent_tbl;
DROP SEQUENCE eqi_devices_seq;

 CREATE SEQUENCE eqi_devices_seq
 INCREMENT 1
 MINVALUE 1
 START 1 ;

----create table eqi_devices_parent_tbl (
----     id           int DEFAULT nextval('"eqi_devices_parent_seq"'::text),    --* код типа 
----     type         varchar(35),   -- тип 
----     normative    varchar(35),   -- ГОСТ, ТУ
----     voltage_nom  int,      -- номинальное напряжение (первичное), v
----     amperage_nom int,      -- номинальный ток (первичный), a
----     voltage_max  int,      -- максимальное напряжение (первичное), v
----     amperage_max int,      -- номинальный ток (первичный), a
----     primary key(id)
----);



-- справочник счетчиков eqi_meter_tbl
drop table eqi_meter_tbl;

create table eqi_meter_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
--   -------------------------------------------------------------------
     kind_meter    int,        --i вид (индукционный/электронный) (eqk_meter_tbl->kinde_meter)
     kind_count    int,        --i вид учета энергии (накопление показаний, расход за период) (eqk_kind_count_tbl->kinde_count)
     phase          int,       --i фазность (однофазный/трехфазный) (eqk_phase_tbl->phase)
     carry          int,       -- разрядность
     schema_inst    int,       --i схема подключения (потребление/генерация)     (eqk_schemains_tbl->schema_inst)
     hook_up        int,       --i способ включения (непосредственный/через тр.тока/через тр.напряжения/через тр.универсальный)
                                   -- eqk_hookup_tbl->hook_up
     amperage_nom_s int,      -- номинальный ток вторичный, a
     voltage_nom_s  int,      -- номинальные напряжения вторичный, v
     zones          int,       -- к-во зон
     zone_time_min  numeric(4,2),  -- минимальный временной интервал, ч
     term_control   int,       -- периодичность поверки (4-трехфазн/8-однофазный),лет
     show_def       int,
     primary key(id)
     , foreign key (kind_meter) references eqk_meter_tbl (id)
     , foreign key (kind_count) references eqk_kind_count_tbl (id)
     , foreign key (phase) references eqk_phase_tbl (id)
     , foreign key (schema_inst) references eqk_schemains_tbl (id)
     , foreign key (hook_up) references eqk_hookup_tbl (id)
);
-- вид учитываемой энергии для типа счетчика
drop table eqi_meter_energy_tbl;

create table eqi_meter_energy_tbl (
     id_type_eqp    int,       --* код типа счетчика
     kind_energy    int,       --i вид учитываемой энергии (активный/реактивный) (eqk_energy_tbl->kind_energy)
     primary key(id_type_eqp,kind_energy)
     , foreign key (id_type_eqp) references eqi_meter_tbl (id)
     , foreign key (kind_energy) references eqk_energy_tbl (id)
);
-- класс точности счетчика eqi_meter_prec_tbl
drop table eqi_meter_prec_tbl;

create table eqi_meter_prec_tbl (
     id_type_eqp     int,      --*i код тип счетчика   eqi_meter_tbl->code_meter
     cl             varchar(10),       -- класс точности ( по справ)
     kind_load      numeric(4,2),  --* Условие нагрузки cosFi
     amperage_load  numeric(6,2),  --* Условие нагрузки ток (% от номинального)
     error          numeric(4,2),  -- относительная погрешность (в %)
     primary key(id_type_eqp,kind_load,amperage_load)
     , foreign key (id_type_eqp) references eqi_meter_tbl (id)
);

-- справочник трансформаторов eqi_compensator_tbl
drop table eqi_compensator_tbl;

create table eqi_compensator_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
   -------------------------------------------------------------------
     voltage2_nom  numeric(9,1),      -- номинальное напряжение (вторичное), v
     amperage2_nom int,      -- номинальный ток (вторичное), a

     phase                  int,      -- i фазность (однофазный/трехфазный)  eqk_phase_tbl->phase
     swathe                 int NOT NULL,      -- количество обмоток
     hook_up                int,      -- i способ соединения (звезда-звезда/звезда-зигзаг/звезда-треугольник/звезда-треугольник)
                                          -- (eqk_hookup_tbl->hook_up)
     power_nom              int,          -- номинальная мощность, кВА
     amperage_no_load       numeric(8,4), -- ток холостого хода , %
     show_def               int,
     primary key(id)
     , foreign key (phase) references eqk_phase_tbl (id)
     , foreign key (hook_up) references eqk_hookup_tbl (id)
);
-- 2-х обмоточные тр-ры
drop table eqi_compensator_2_tbl;

create table eqi_compensator_2_tbl (
     id_type_eqp             int,     --* код типа
     voltage_short_circuit  numeric(8,4), -- напряжение кз, %
     iron                   numeric(8,4), -- потери стали , кВт
     copper                 numeric(8,4), -- потери меди  , кВт
     primary key(id_type_eqp)
     , foreign key (id_type_eqp) references eqi_compensator_tbl (id)
);
-- 3-х обмоточные тр-ры 
drop table eqi_compensator_3_tbl;

create table eqi_compensator_3_tbl (
     id_type_eqp            int,     --* код типа
     voltage3_nom           numeric(9,1),      -- номинальное напряжение (ср), v
     amperage3_nom          int,      -- номинальный ток (ср), a
     power_h                numeric(9,1), -- мощность обмотки ВН,кВА
     power_m                numeric(9,1), -- мощность обмотки СН,кВА
     power_l                numeric(9,1), -- мощность обмотки НН,кВА
     iron                   numeric(8,4), -- потери стали , кВт
     copper_hl              numeric(8,4), -- потери меди В-Н, кВт
     copper_hm              numeric(8,4), -- потери меди В-С, кВт
     copper_ml              numeric(8,4), -- потери меди С-Н, кВт
     voltage_short_hl       numeric(8,4), -- напряжение кз обмоток В-Н, %  
     voltage_short_hm       numeric(8,4), -- напряжение кз обмоток В-С, %  
     voltage_short_ml       numeric(8,4), -- напряжение кз обмоток С-Н, %
     primary key(id_type_eqp)
     , foreign key (id_type_eqp) references eqi_compensator_tbl (id)
);
-- справочник трансформаторов  измерительных eqi_compensator_i_tbl
drop table eqi_compensator_i_tbl;

create table eqi_compensator_i_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
--   -------------------------------------------------------------------
     voltage2_nom  numeric(9,1),      -- номинальное напряжение (вторичное), v
     amperage2_nom int,      -- номинальный ток (вторичное), a

     conversion             int,      -- i что преобразовывает (ток/напряжение)  eqk_conversion_tbl->name
     phase                  int,      -- i фазность (однофазный/трехфазный)  eqk_phase_tbl->phase
     swathe                 int,      -- количество обмоток
     hook_up                int,      -- i способ соединения (звезда-звезда/звезда-зигзаг/звезда-треугольник/звезда-треугольник)
                                          -- (eqk_hookup_tbl->hook_up)
     power_nom              int,          -- номинальная мощность, кВА (справочн)
     amperage_no_load       numeric(8,4), -- ток холостого хода ,%  (справочн)
--     k_compens              int,     -- ??? !!!коэф. трансформации
     accuracy               int,     --- класс точности (погрешность в %)
                                          
     primary key(id)
     , foreign key (phase) references eqk_phase_tbl (id)
     , foreign key (hook_up) references eqk_hookup_tbl (id)
     , foreign key (conversion) references eqk_conversion_tbl(id)
);
-- справочник компенсаторов eqi_jack_tbl
drop table eqi_jack_tbl;

create table eqi_jack_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
--   -------------------------------------------------------------------
     sync                   int,    -- i тип (синхронный/асинхронный) eqk_sync_tbl->sync
     power_nom              int,         -- номинальная мощность, при опережающем токе, ква
     lost_nom               numeric(8,4) -- потери при номинальном режиме,кВт
     ,primary key(id)
     ,foreign key (sync) references eqk_sync_tbl (id)
);

-- группы коммутационного оборудования
drop table eqk_switchs_gr_tbl;

create table eqk_switchs_gr_tbl (
     id int,
     name varchar(45),       --  линейные разъединители, распределительные пункты, шинные разъединители
     shot_name varchar(6),   --  ЛР, РП, ШР
     primary key(id)
);

-- справочник коммутационного оборудования  eqi_switchs_tbl
drop table eqi_switch_tbl;

create table eqi_switch_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
--   -------------------------------------------------------------------
     id_gr                  int,     --i группа
     power_nom              int,          -- номинальная мощность, при опережающем токе, ква
     lost_nom               numeric(8,4), -- потери при номинальном режиме, кВт
     primary key(id)
     ,foreign key (id_gr) references eqk_switchs_gr_tbl (id)
);


-- справочник предохранителей eqi_fuses_tbl
drop table eqi_fuse_tbl;

create table eqi_fuse_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
--   -------------------------------------------------------------------
     power_nom            int    -- номинальная мощность, при опережающем токе, ква
     ,primary key(id)
);

-- справочник кабелей силовых
drop table eqi_cable_tbl;

create table eqi_cable_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),      -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),      -- максимальное напряжение (первичное), v
     amperage_max int,      -- номинальный ток (первичный), a
--   -------------------------------------------------------------------
--     kind           int,    -- ?
     S_nom        numeric(6,2),   -- номинальное сечение
     cords        int,            -- количество жил
     cover        int,            -- i вид изоляции
     ro           numeric(10,6),  -- удельное активное Сопротивление кабеля(Ом*/км)
     xo           numeric(10,6),  -- удельное реактивное Сопротивление кабеля(Ом*/км)
     dpo          numeric(8,4),   -- потери мощности кВт/км
     show_def     int,
     -- идуктивная проводимость, ед/(ом*км)
     -- длительные допустимые нагрузки, а
     ,primary key(id)
     ,foreign key (cover) references eqk_cover_tbl (id)
);
--  Справочник жил кабелей
drop table eqi_cable_c_tbl;

DROP SEQUENCE eqi_cable_c_seq;

 CREATE SEQUENCE eqi_cable_c_seq
 INCREMENT 1
 MINVALUE 1
 START 1 ;

create table eqi_cable_c_tbl (
     id           int DEFAULT nextval('"eqi_cable_c_seq"'::text),   --*идентификатор жилы  
     id_type_eqp  int,   -- код типа 
     materal      int,   -- код вида материала materal_ind_tbl->materal
     calc_diam    numeric(4,2),   -- расчетный диаметр провода, мм
     cord_diam    numeric(4,2),   -- диамертр проволок, мм
     cord_qn      int,   -- количество проволок, ед
     cover        int,   -- i вид изоляции
     primary key(id)
     , foreign key (id_type_eqp) references eqi_cable_tbl (id)
     , foreign key (materal) references eqk_materals_tbl (id)
     ,foreign key (cover) references eqk_cover_tbl (id)
);
--   справочник проводов                eqi_corde_tbl
drop table eqi_corde_tbl;

create table eqi_corde_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     voltage_nom  numeric(9,1),  -- номинальное напряжение (первичное), v
     amperage_nom int,      -- номинальный ток (первичный), a
     voltage_max  numeric(9,1),  -- максимальное напряжение (первичное), v
     amperage_max int,      -- максимальный ток (первичный), a
--   -------------------------------------------------------------------
     S_nom        int,      -- номинальное сечение
     materal      int,      -- *код вида материала materal_ind_tbl->materal
     calc_diam    numeric(4,2),  -- расчетный диаметр провода, мм
     cord_diam    numeric(4,2),  -- диамертр проволок, мм
     cord_qn      int,      -- количество проволок, ед
     ro           numeric(10,6), -- удельное активное Сопротивление провода(Ом*/км)
     xo           numeric(10,6), -- удельное реактивное Сопротивление провода(Ом*/км)
     dpo          numeric(8,4), -- потери мощности кВт/км
     show_def     int,
     primary key(id)
     ,foreign key (materal) references eqk_materals_tbl (id)
);
-- справочник расстояний подвески
drop table eqi_pendant_tbl;

create table eqi_pendant_tbl (
     id                int DEFAULT nextval('"eqi_devices_seq"'::text),     --* код типа
     type              varchar(35),  -- марка
     normative         varchar(35),  -- ГОСТ, ТУ
     length             int,     -- расстояние, мм
     primary key (id)
);
-- справочник опор  eqi_pillar_tbl
drop table eqi_pillar_tbl;       

create table eqi_pillar_tbl (
     id                int DEFAULT nextval('"eqi_devices_seq"'::text),     --* код типа
     type              varchar(35),  -- марка
     normative         varchar(35),  -- ГОСТ, ТУ
     materal           int,     -- код вида материала materal_ind_tbl->materal
     name              varchar(80),  -- описание
     primary key(id)
     , foreign key (materal) references eqk_materals_tbl (id)
);

-- петли заземления eqi_earth_tbl
drop table eqi_earth_tbl;

create table eqi_earth_tbl (
     id                int DEFAULT nextval('"eqi_devices_seq"'::text),     --* код типа
     type              varchar(35),  -- марка
     name              varchar(80),
     primary key(id)
);


-- ------------------------------------------------------------
-- ------------------------------------------------------------
-- ------------------------------------------------------------
-- оборудование подключения
-- ------------------------------------------------------------
-- оборудование
drop table eqm_equipment_tbl;

 DROP SEQUENCE eqm_equipment_seq;

  CREATE SEQUENCE eqm_equipment_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqm_equipment_tbl (
     id             integer DEFAULT nextval('"eqm_equipment_seq"'::text),      --* код оборудования (идентификатор точки уст.)
     type_eqp       int,     --+ i код вида оборудования (eqi_devices_tbl->id)
     name_eqp       varchar(25),  --  наименование
     num_eqp        varchar(25),  --+ заводской номер счетчика
     id_addres      integer,    --  i адрес установки      (address_tbl->id)
     dt_install     timestamp,     --  дата установки 
     dt_change      timestamp,     --  дата замены
     loss_power     integer default 0, --  уч в расчете потери
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
--     inst_station   int,      --i признак уст на подстанции (eqk_in_station_tbl->id)
     primary key (id)
--     , foreign key (id_addres)    references address_tbl (id)
     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
    
);

-- счетчики
drop table eqm_meter_tbl;

create table eqm_meter_tbl (
     code_eqp       integer not null,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
--   ----------------------------------------------------------
      id_type_eqp    int null,     -- +1/ i код типа  (?_ind_tbl->id_type_eqp)
       dt_control     timestamp null,     --  дата гос.поверки
--       begin_count    integer null,      --  показания на начало установки
--      d              numeric(5,4) null, -- 1/ экономический эквивалент реактивной мощн. кВт/кВАр (киловатт/киловольтампер реактивн.) -- перенесен в точку учета
       nm             varchar(255) null, -- 1/ устоявшееся наименование объекта установки
--       account        int null,     --i субсчет клиента      (saldo_tbl->account)
       main_duble     int null,      --  вложенность, глубина вложенности,
--      class          int null,      -- 1/ i класс напражения   (eqk_voltage_tbl->class)
--       code_group     int null,      --i код группы тарифов (tariff_e_tbl->code_group) -- перенесен в точку учета
--       count_lost     int null,      --  считать потери  -- перенесен в точку учета
       warm           int null,      --  установка в неотапливаемом помещении (1/0)
--       industry       int,           -- отрасль -- перенесен в точку учета

     count_met      int default 0, -- флаг расчета за недостижение порога чувствительности (0/1)
     met_comment    varchar(100) null, --комментарий к пред. полю
     warm_comment   varchar(100),
     buffle         numeric(10,2) ,    -- предел чувствительности счетчика в %
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_meter_tbl (id)
);

-- зоны счетчика eqm_meter_zone_tbl
drop table eqd_meter_zone_tbl;

create table eqd_meter_zone_tbl (
     code_eqp       integer,       --*i код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     dt_zone_install timestamp,     --*  дата установки зоны
     kind_energy     int,      --*i вид учитываемой энергии 
     zone            int,     -- номер зоны 
     time_begin      numeric(4,2), --* начало интервала
     time_end        numeric(4,2), --* конец интервала

     primary key(code_eqp,kind_energy,zone,dt_zone_install)
     , foreign key (code_eqp) references eqm_meter_tbl (code_eqp)
     , foreign key (zone) references eqk_zone_tbl (id)
);
-- ------------------------------------------------------------------------
-- виды энергии
drop table eqd_meter_energy_tbl;

create table eqd_meter_energy_tbl (
     code_eqp       integer,       --*i код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     kind_energy    int,      --*i вид учитываемой энергии (активный/реактивный) (eqk_energy_tbl->kind_energy)
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
-- трансформаторные подстанции
drop table eqm_compens_station_tbl;

create table eqm_compens_station_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
--   ----------------------------------------------------------
     h_boxes          int,    --  к-во ячеек высокой стороны
     l_boxes          int,    --  к-во ячеек низкой стороны
     h_points         int,    --  к-во подключений высокой стороны
     l_points         int,    --  к-во подключений низкой стороны
     id_voltage       int,
     primary key (code_eqp)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
--     , foreign key (id_type_eqp)  references compens_station_ind_tbl (id_type_eqp)
);
-- ------------------------------------------------------------------------
-- фидера
drop table eqm_fider_tbl;
create table eqm_fider_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
--   ----------------------------------------------------------
     id_voltage   int,    
     losts_coef   numeric(12,10) default 0,
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)

);

--  трансформаторы на трансформаторных подстанциях и площадках
drop table eqm_compens_station_inst_tbl;

create table eqm_compens_station_inst_tbl (
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     code_eqp_inst   integer,      --* код оборудования (идентификатор точки уст.)
     primary key(code_eqp,code_eqp_inst)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_inst)  references eqm_equipment_tbl (id)
);
-- -------------------------------------------------------------------------
-- трансформаторы
drop table eqm_compensator_tbl;

create table eqm_compensator_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_compensator_tbl (id)
--     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
--     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- трансформаторы тока
drop table eqm_compensator_i_tbl;

create table eqm_compensator_i_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_compensator_i_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- линии
drop table eqm_line_a_tbl;

create table eqm_line_a_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     length         int,     --  протяженность,м
     pillar         int,     --i тип опоры            (eqi_pillar_tbl->id_type_eqp)
     pillar_step    int,     --  шаг опоры,м
     pendant        int,
     earth          int,     --i тип петли заземления (eqi_earth_tbl->id_type_eqp)
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

--Кабель
drop table eqm_line_c_tbl;

create table eqm_line_c_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     length         int,     --  протяженность,м
     id_voltage   int,    
     primary key (code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_cable_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);
--  маршрут прокладки линии   (или массив адресов в eqm_equipment_tbl)
drop table eqm_line_path_tbl;

create table eqm_line_path_tbl (
     code_eqp       integer,      --*i код оборудования   (line_eqp_tbl->code_eqp)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     id_addres      integer,      --i адрес установки      (address_tbl->id)
     pathorder      int default 0,
     primary key (code_eqp,id_addres)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
--     , foreign key (id_addres) references address_tbl (id)
);
-- компенсаторы
drop table eqm_jack_tbl;

create table eqm_jack_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     quantity         int,       --  количество
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_jack_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- коммутационное оборудование
drop table eqm_switch_tbl;

create table eqm_switch_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     folk           int,       --  количество ветвей
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_switch_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- предохранители
drop table eqm_fuse_tbl;

create table eqm_fuse_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  (?_ind_tbl->id_type_eqp)
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp) references eqi_fuse_tbl (id)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

);

-- границы разделов
drop table eqm_borders_tbl;

create table eqm_borders_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_clientA     integer,   --i идентификатор клиента   (client_tbl->id_client)
     id_clientB     integer,   --i идентификатор клиента   (client_tbl->id_client)
     inf            varchar(255),  -- описание границы по акту разграничение балансовой принадлежности
                                   -- граница ответственности 
     primary key(code_eqp)
---     , foreign key (type_eqp)     references eqi_device_kinds_tbl (id)
---     , foreign key (inst_station) references eqk_in_station_tbl (id)

     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_clientA) references clm_client_tbl (id)
     , foreign key (id_clientB) references clm_client_tbl (id)
--     , foreign key (id_clientA) references client_tbl (id_client)
--     , foreign key (id_clientB) references client_tbl (id_client)
);

-- точки учета
drop table eqm_point_tbl;

create table eqm_point_tbl (
     code_eqp       int,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     power          numeric(14,3),  -- установленная мощность
     id_tarif       int,      --i код группы тарифов (aci_tarif_tbl)
     industry       int,      -- отрасль 
     count_lost     int,
     d              numeric(5,4) null, -- экономический эквивалент реактивной мощн. кВт/кВАр (киловатт/киловольтампер реактивн.)
     wtm            int, --рабочее время за месяц (часов)
     id_tg          int, -- ссылка на справочник eqk_tg_tbl
     id_voltage     int,
     share          numeric (5,2), -- процент распределения потребления для колхозов 

     ldemand        numeric (14,2), -- потребление за пред. период
     ldemandr       numeric (14,2), -- потребление за пред. период реактив
     ldemandg       numeric (14,2), -- потребление за пред. период генерация
     pdays          int,            -- кол. дней -.- 

     count_itr      int default 0, -- флаг расчета за недогруз (0/1)
     itr_comment    varchar(100) null, --комментарий к пред. полю

     cmp            numeric (14,2), --мощность компенсирующих установок
     zone           int,
     flag_hlosts    int,  -- разрешить ручной ввод потерь 
     id_depart      int,  -- министерство
     main_losts     int,  -- не делить потери основного абонента
     lost_nolost    int default 0,  
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_tarif)  references aci_tarif_tbl (id)
     , foreign key (industry)  references cla_param_tbl (id)
     , foreign key (id_tg)  references eqk_tg_tbl (id)
     , foreign key (id_voltage) references eqk_voltage_tbl (id)
);

create table eqm_area_tbl (   --площадки
     code_eqp       int,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_client      integer,   --i идентификатор клиента   
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_client) references clm_client_tbl (id)

);

-- ------------------------------------------------------------------------
-- виды энергии для тчек учета
drop table eqd_point_energy_tbl;

create table eqd_point_energy_tbl (
     code_eqp       integer,       --*i код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     kind_energy    int,      --*i вид учитываемой энергии (активный/реактивный) (eqk_energy_tbl->kind_energy)
     dt_instal      date,      --*
     primary key(code_eqp,kind_energy,dt_instal)
     , foreign key (code_eqp) references eqm_point_tbl (code_eqp)
     , foreign key (kind_energy) references eqk_energy_tbl (id)
);
-- ------------------------------------------------------------------------

-- список схем подключения (список деревьев)
drop table eqm_tree_tbl;

 DROP SEQUENCE eqm_tree_seq;

  CREATE SEQUENCE eqm_tree_seq
  INCREMENT 1
  MINVALUE 1
  START 1 ;

create table eqm_tree_tbl (
     id       int not null DEFAULT nextval('"eqm_tree_seq"'::text),            --* иденитификатор ветки подключения
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     name     varchar(35),
     code_eqp integer ,
     tranzit        int default 0,             -- 0-not/[1..level]-yes
     id_client      integer not null,-- references client_tbl(id_client), --* идентификатор клиента
     file_path varchar(255); 
     primary key(id),
     foreign key (code_eqp)  references eqm_equipment_tbl (id),
     foreign key (id_client) references clm_client_tbl (id)
--     , foreign key (id_client)  references client_tbl (id_client)
);

-- -----------------------------------------------------------------------
-- устройства электрической сети  eqm_eqp_tree_tbl
drop table eqm_eqp_tree_tbl;

-- Номер ветви =0 для всех узлов, кроме копий точки схождения, 
-- для них он идет по autoinc.
-- Потомки могут быть только у узлов с Номер ветви =0
-- Количество предков для корня =0, для остальных по 1, кроме точек схождения
create table eqm_eqp_tree_tbl (
     id_tree    int not null,         --i код ветки схемы подключения
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     code_eqp   integer not null,   --*i код оборудования (идентификатор точки
                          -- установки в сети, уникальна в пределах всей сети)
                          -- (*_eqm_equipment_tbl->code_eqp)
     code_eqp_e integer NULL,          --i код оборудования parent!
                          -- (*_eqm_equipment_tbl->code_eqp)
     name       varchar(50),                 -- условное обозначение на счеме
     tranzit    int,                     -- к-во прохождений
     lvl        int,
     parents    int,       -- кол. предков 
     line_no    int default 0,       -- номер ветви (номер копии узла)

--     terminal   int default 0,           -- 1 - leave //Катя сказала убрать
     primary key(id_tree,code_eqp,line_no)
     , foreign key (id_tree)  references eqm_tree_tbl (id)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_e)  references eqm_equipment_tbl (id) 
);
/*
--Вспомогательные таблици потомков и предков (возможно не нужны)

drop table eqm_schema_parents_tbl;

create table eqm_schema_parents_tbl (
     code_eqp_b integer not null,  --*i код оборудования
     code_eqp_e integer not null,  --*i код оборудования предка
     primary key(code_eqp_b,code_eqp_e)
     , foreign key (code_eqp_b)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_e)  references eqm_equipment_tbl (id)
);

drop table eqm_schema_child_tbl;

create table eqm_schema_child_tbl (
     code_eqp_b integer not null,  --*i код оборудования
     code_eqp_e integer not null,  --*i код оборудования потомка
     primary key(code_eqp_b,code_eqp_e)
     , foreign key (code_eqp_b)  references eqm_equipment_tbl (id)
     , foreign key (code_eqp_e)  references eqm_equipment_tbl (id)
);
 */
-- замена оборудования
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
     mode            int,  --   режим (без изм. топологии 1/с изм. 2/удаление дерева 3/изм.доп. данных 4/изм(удаление). исп. оборудования другим абон. 5)
                                ----              equipment  /eqp_tree/tree
     id_client       integer,   --   i код обонента(1-4 владельца, 5 -пользователя)
--     id_tree         int,  --   i код ветки схемы подключения
     date_change     timestamp,  --   дата замены 
     dt              timestamp,  --   дата внесения замены (компютерная)
     id_usr          int,  --i код вносившего выполнившего замену (person_workers_tbl->code_person)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
     primary key(id)
     , foreign key (id_client) references clm_client_tbl (id)
--     , foreign key (id_tree)  references eqm_tree_tbl (id)
--     , foreign key (id_usr)  references client_tbl (id_client)
);


drop table eqa_change_tbl;

create table eqa_change_tbl (
     id_change       integer not null,  -- *id
     id_record       oid,               -- *oid
     id_table        int ,              -- код таблицы (NEW!!!)
     code_eqp        integer ,  -- i код оборудования
--     line_no         int           -- номер линии (NEW!!!) 
     -- номер линии понадобился, так как при наличии в одном дереве двух
     -- экземпляров точеки схождения в случае переноса одного из них 
     -- невозможно понять, к какому относятся изменения
     -- А OID зачем!!!!!!!!!
     id_tree         int,  	-- i код ветки схемы подключения
     idk_operation   int,  	-- код операции (Изменение 0/удаление 1)
     id_department  int default syi_resid_fun(),      -- код структурного подразделения
     primary key(id_change,id_record)
     , foreign key (id_change)  references eqm_change_tbl (id)
--     , foreign key (id_tree)  references eqm_tree_tbl (id)
--     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_table)  references syi_table_tbl (id)
);

drop table eqd_change_tbl;

create table eqd_change_tbl (
        id_change  int,      -- *id
--        id_table   int ,     -- *код таблицы
        id_field   int ,     -- *поле
        id_record  oid,     -- *oid
        old_value  varchar,  -- старое значение
        id_department  int default syi_resid_fun(),          --  код структурного подразделения
--        idk_operation   int,  --  код операции 
     primary key(id_change,id_field,id_record)
--     , foreign key (id_table)  references syi_table_tbl (id)
     , foreign key (id_field) references syi_field_tbl (id)
     , foreign key (id_change)  references eqm_change_tbl (id)
);

--create table eqm_eqp_change_tbl (
--     code_eqp          integer,   --*i код оборудования   
--     date_change     timestamp,  --*i дата замены
--     id_type_eqp_o int,   --i код типа (старый)
--     num_eqp_o     varchar(25),-- заводской номер (старый)
--     id_type_eqp_n int,   --*i код типа                   .
--     num_eqp_n     varchar(25),--i заводской номер
--      --(идентификатор точки установки в сети, уникальна в пределах всей сети)
--     id_department     int,   --i код структурного подразделения  (client_tbl->id_department)
--     id_person         int,   --i код вносившего выполнившего замену (person_workers_tbl->code_person)
--     primary key(code_eqp,date_change)
--     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
--);

-- -------------------------------------------------------------
drop table eqm_eqp_use_tbl;

create table eqm_eqp_use_tbl(
	code_eqp       int,   --*i код оборудования   
	id_client      int,   --*i идентификатор клиента
        dt_install     date,
	primary key(code_eqp,id_client,dt_install)
     , foreign key (id_client) references clm_client_tbl (id)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
);

-- справочник Дизельних электростанций
drop table eqi_des_tbl;
create table eqi_des_tbl (
     id           int DEFAULT nextval('"eqi_devices_seq"'::text),    --* код типа 
     type         varchar(35),   -- тип 
     normative    varchar(35),   -- ГОСТ, ТУ
     primary key(id)
);

-- ДЕС
drop table eqm_des_tbl;

create table eqm_des_tbl (
     code_eqp       integer,      --* код оборудования (идентификатор точки уст.)
     id_department  int default syi_resid_fun(),          --  код структурного подразделения
-- -----------------------------------------------------------
     id_type_eqp    int,     --i код типа  
     power          int,     -- мощность
     primary key(code_eqp)
     , foreign key (code_eqp)  references eqm_equipment_tbl (id)
     , foreign key (id_type_eqp)  references eqi_des_tbl (id)

);
