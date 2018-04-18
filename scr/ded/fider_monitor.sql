CREATE INDEX privdem_client_idx
  ON acm_privdem_tbl
  USING btree
  (id_client);

ALTER TABLE eqm_compens_station_tbl ADD COLUMN abon_ps integer;
ALTER TABLE eqm_compens_station_h ADD COLUMN abon_ps integer;

UPDATE "pg_class" SET "reltriggers" = 0 WHERE "relname" = 'eqm_compens_station_tbl';

 update eqm_compens_station_tbl set abon_ps=0 where abon_ps is null;
 update eqm_compens_station_h set abon_ps=0 where abon_ps is null;

UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) 
WHERE relname = 'eqm_compens_station_tbl';


create table mni_works_tbl (
	id serial,
        id_grp int,
	name varchar(100),
	primary key(id)
);

--insert into mni_works_tbl (name) values ('Теплов?з?йний контроль (к?льк?сть обстежених ТП, РП)')

--insert into mni_works_tbl (name) values ('К-сть виявлених дефект?в електрообладнання ТП, РП, од.')

--insert into mni_works_tbl (name) values ('у т.ч. к-сть авар?йних дефект?в електрообладнання ТП, РП, од.')

--insert into mni_works_tbl (name) values ('у т.ч. к-сть розвинутих дефект?в електрообладнання ТП, РП, од.')

--insert into mni_works_tbl (name) values ('Виправлення недол?к?в по результатах теплов?з?йного обстеження')

delete from mni_works_tbl;

insert into mni_works_tbl (id,id_grp,name) values (1,1,'1.1.Розчищення ПЛ 10кВ, км');
insert into mni_works_tbl (id,id_grp,name) values (2,1,'1.2.Розчищення ПЛ 0,4 кВ, км');
insert into mni_works_tbl (id,id_grp,name) values (3,1,'1.3.Капiтальний ремонт ТП(РП), шт.');
insert into mni_works_tbl (id,id_grp,name) values (4,1,'1.4.Замiна недозавантажених трансформаторiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (5,1,'1.5.Замiна перевантажених трансформаторiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (6,1,'1.6.Вирiвнювання пофазних навантажень в мережi 0,4 кВ, шт.');
insert into mni_works_tbl (id,id_grp,name) values (7,1,'1.7.Замiна "скруток" проводiв на затискачi, шт');
insert into mni_works_tbl (id,id_grp,name) values (8,1,'1.8.Виконання графiку повiрки трансформаторiв струму 0,4 кВ, шт.');
insert into mni_works_tbl (id,id_grp,name) values (9,1,'1.9.Замiна вiдгалуження вiд ПЛ 0,4 кВ на кабель або iзольований провiд, шт.');
insert into mni_works_tbl (id,id_grp,name) values (10,1,'1.10.Замiна дротiв на перевантажених лiнiях 10 кВ, км.');
insert into mni_works_tbl (id,id_grp,name) values (11,1,'1.11.Замiна дротiв на перевантажених лiнiях 0,4 кВ, км.');
insert into mni_works_tbl (id,id_grp,name) values (12,1,'1.12.Аварiйнi вiдключення в мережi 0.4 кВ фiдеру, шт');
insert into mni_works_tbl (id,id_grp,name) values (13,1,'1.13.Аварiйнi вiдключення в мережi 10 кВ фiдеру, шт');

insert into mni_works_tbl (id,id_grp,name) values (14,1,'1.14.Тепловiзiйний контроль (кiлькiсть обстежених ТП, РП), шт');
insert into mni_works_tbl (id,id_grp,name) values (15,1,'1.15.Виявлено дефектiв електрообладнання ТП, РП, од.');
insert into mni_works_tbl (id,id_grp,name) values (16,1,'1.16.Виявлено аварiйних дефектiв електрообладнання ТП, РП, од.');
insert into mni_works_tbl (id,id_grp,name) values (17,1,'1.17.Виявлено розвинутих дефектiв електрообладнання ТП, РП, од.');
insert into mni_works_tbl (id,id_grp,name) values (18,1,'1.18.Виправлено недолiкiв по результатах тепловiзiйного обстеження, од.');


insert into mni_works_tbl (id,id_grp,name) values (120,2,'2.1.Технiчна перевiрка засобiв облiку у побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (130,2,'2.2.Контрольний огляд засобiв облiку у побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (140,2,'2.3.Замiна засобiв облiку у побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (150,2,'2.4.Встановлення засобiв облiку у побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (160,2,'2.5.Зняття показiв лiчильникiв у побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (170,2,'2.6.Рознесення рахункiв на оплату побутовим споживачам, шт.');
insert into mni_works_tbl (id,id_grp,name) values (180,2,'2.7.Допуск в експлуатацiю нових електроустановок побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (190,2,'2.8.Допуск в експлуатацiю реконструйованих електроустановок побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (200,2,'2.9.Попередження про вiдключення побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (210,2,'2.10.Проведення  вiдключень побутових споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (220,2,'2.11.Проведено повторних пiдключень побутових споживачiв, шт.');

insert into mni_works_tbl (id,id_grp,name) values (290,3,'3.1.Визначення граничних величин споживання електричноi потужностi, шт.');
insert into mni_works_tbl (id,id_grp,name) values (300,3,'3.2.Обстеження резервних джерел живлення (РДЖ), шт.');
insert into mni_works_tbl (id,id_grp,name) values (310,3,'3.3.Перевiрка дотримання граничних величин споживання потужностi, шт.');
insert into mni_works_tbl (id,id_grp,name) values (320,3,'3.4.Перевiрка режимiв споживання реактивноi потужностi, шт.');
insert into mni_works_tbl (id,id_grp,name) values (330,3,'3.5.Складання графiкiв обмеження споживання ел.енергii та потужностi (ГОЕ, ГОП), шт.');
insert into mni_works_tbl (id,id_grp,name) values (340,3,'3.6.Пiдготовка та проведення режимних вимiрiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (350,3,'3.7.Обстеження споживачiв 1 категорii, шт.');
insert into mni_works_tbl (id,id_grp,name) values (360,3,'3.8.Обстеження споживачiв з питання складання актiв ЕАТ бронi, шт.');
insert into mni_works_tbl (id,id_grp,name) values (370,3,'3.9.Обстеження споживачiв з метою укладення додаткiв до Договорiв, передбачених ПКЕЕ, ПКЕЕН, шт.');

insert into mni_works_tbl (id,id_grp,name) values (371,3,'3.10.Обстеження споживачiв з метою переукладання договорiв, передбачених ПКЕЕ, шт.');
insert into mni_works_tbl (id,id_grp,name) values (372,3,'3.11.Укладання (переукладання) договорiв, передбачених ПКЕЕН, шт.');

insert into mni_works_tbl (id,id_grp,name) values (380,3,'3.12.Допуск в експлуатацiю нових електроустановок юридичних споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (390,3,'3.13.Допуск в експлуатацiю реконструйованих електроустановок юридичних споживачiв, шт.');
insert into mni_works_tbl (id,id_grp,name) values (400,3,'3.14.Виконання вимог по закриттю доступу споживачiв до засобiв облiку та дооблiкових мереж, шт.');
insert into mni_works_tbl (id,id_grp,name) values (410,3,'3.15.Проведених рейдiв, шт.');


create table mnm_fider_works_tbl 
(
  id serial NOT NULL,
  id_fider integer,
  id_type integer,
  id_client int,
  object_name character varying(250),
  dt_work date,
  cnt numeric(14,3) ,
  id_position integer,
  "comment" character varying(205),
  dt timestamp without time zone DEFAULT now(),
  id_person integer DEFAULT getsysvar('id_person'::character varying),
  PRIMARY KEY (id)
) 
WITH OIDS;



create table mni_eqp_params_tbl (
	id serial,
        type_eqp int, 
	name varchar(100),
	primary key(id)
);


insert into mni_eqp_params_tbl (id,type_eqp,name) values (1,15,'Сумарна довжина ПЛ 0,4 кВ, км');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (2,15,'Сумарна довжина КЛ 0,4 кВ, км');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (3,15,'Ступiнь зношеностi КЛ 10 кВ, %');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (4,15,'Ступiнь зношеностi КЛ 0,4 кВ, %');
--insert into mni_eqp_params_tbl (id,type_eqp,name) values (5,15,'Ступiнь зношеностi КЛ 0,4 кВ, %');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (6,15,'Кiлькiсть  РП, шт.');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (7,15,'Кiлькiсть недозавантажених трансформаторiв, шт.');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (8,15,'Кiлькiсть перевантажених трансформаторiв, шт.');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (9,15,'Кiлькiсть лiнй 0,4 кВ з "перекосом навантаження", шт.');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (10,15,'Кiлькiсть ТП(РП), де потрiбно проводити капiльний ремонт, шт.');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (11,15,'Довжина траси 10 кВ, де потрiбно проводити чищення, км.');
insert into mni_eqp_params_tbl (id,type_eqp,name) values (12,15,'Сумарна довжина трас 0,4 кВ, де потрiбно проводити чищення, км.');


create table mnm_eqp_params_tbl (
	id serial,
        code_eqp int,
        id_param int,
        value numeric(16,2),
	primary key(id)
);


create table mnm_eqp_params_h (
	id serial,
        code_eqp int,
        id_param int,
        value numeric(16,2),
	dt_b date NOT NULL,
	dt_e date,
	mmgg date DEFAULT fun_mmgg(),
	dt timestamp without time zone DEFAULT now(),
	primary key(id,dt_b)
);

-----------------------------------------------------------------------------------

CREATE or replace FUNCTION mnm_eqp_params_ed_fun(int,int,numeric,date)                                                  
    RETURNS int                                                                                     
  AS
  '
   declare

   pcode_eqp     alias for $1; 
   pid_param     alias for $2; 
   pvalue        alias for $3; 
   pdt           alias for $4; 

   vold   numeric;     

begin                                                                                          
     select into vold value from mnm_eqp_params_h where code_eqp = pcode_eqp and id_param = pid_param and dt_b <=pdt and (dt_e is null or dt_e > pdt);
    
     if found then
	if (vold is null) or (vold <>pvalue) then 
		delete from mnm_eqp_params_h where code_eqp = pcode_eqp and id_param = pid_param and (dt_b >= pdt)  ;

		update mnm_eqp_params_h set dt_e = pdt where code_eqp = pcode_eqp and id_param = pid_param and 
		dt_b <= pdt and pdt <= coalesce (dt_e,pdt);

		insert into mnm_eqp_params_h(code_eqp,id_param,value,dt_b) values (pcode_eqp, pid_param,pvalue,pdt); 

	end if;	
     else

        delete from mnm_eqp_params_h where code_eqp = pcode_eqp and id_param = pid_param and (dt_b >= pdt)  ;

        update mnm_eqp_params_h set dt_e = pdt where code_eqp = pcode_eqp and id_param = pid_param and 
        dt_b <= pdt and pdt <= coalesce (dt_e,pdt);

	insert into mnm_eqp_params_h(code_eqp,id_param,value,dt_b) values (pcode_eqp, pid_param,pvalue,pdt); 

     end if;

  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          


insert into mnm_eqp_params_tbl(code_eqp,id_param)
select sss.* from  
(
select f.code_eqp, i.id from eqm_fider_tbl as f , mni_eqp_params_tbl as i 
where i.type_eqp = 15 
order by f.code_eqp, i.id
) as sss
left join mnm_eqp_params_tbl as p on (p.code_eqp = sss.code_eqp and  p.id_param = sss.id)
where p.code_eqp is null;


/*

drop table rep_fider_monitor_tmp;

create table rep_fider_monitor_tmp (
mmgg 		date,
id_position 	int,
id_fider 	int,
length_al10 	numeric(12,2) default 0,
length_cl10 	numeric(12,2) default 0,
length_al04 	numeric(12,2) default 0,
length_cl04 	numeric(12,2) default 0,
wearing_cl10 	numeric(10,2) default 0,
wearing_cl04 	numeric(10,2) default 0,
rp_count 	int default 0,
ps_count 	int default 0,
ps_count_res	int default 0,
ps_count_abon	int default 0,
fiz_count	int default 0,
fiz_count_1f	int default 0,
fiz_count_3f	int default 0,
fiz_count_1fu	int default 0,
fiz_count_3fu	int default 0,
point_count	int default 0,
point_count1f	int default 0,
point_count3f	int default 0,
point_count_noti int default 0,
point_count_ti	int default 0,
point_count1fu	int default 0,
point_count3fu	int default 0,
ti_count_u	int default 0,
ti_count_5p	int default 0,
point_count_tpu	int default 0,
fiz_count_tpu	int default 0,
point_count_cou	int default 0,
fiz_count_cou	int default 0,
ps_count_pwr_s	int default 0,
ps_count_pwr_g	int default 0,	
line_count_shift int default 0,
ps_count_kap	int default 0,
length_line10_clear numeric(12,2) default 0,
length_line04_clear numeric(12,2) default 0,
disconnect_count_04 int default 0,
disconnect_count_10 int default 0,
pwr_limit_set	int default 0,
work_tp		int default 0,
work_tp_fiz	int default 0,
work_co		int default 0,
work_co_fiz	int default 0,
work_meterch	int default 0,
work_meterch_fiz int default 0,
work_closing	int default 0,
work_meter_new	int default 0,
work_meter_new_res int default 0,
work_meter_new_fiz int default 0,
raid_count	int default 0,
pkee_count	int default 0,
pkee_count_fiz	int default 0,
pkee_demand	int default 0,
work_reserve_inspect int default 0,
work_pwr_inspect int default 0,
work_pwrre_inspect int default 0,
work_limit_plan	int default 0,
work_measurings	int default 0,
work_1kcheck	int default 0,
work_indication	int default 0,
work_indication_fiz int default 0,
work_bill_fiz	int default 0,
work_inspect_EAT int default 0,
work_inspect_PKEE int default 0,
work_new_obj	int default 0,
work_repair_obj	int default 0,
work_new_obj_fiz int default 0,
work_repair_obj_fiz int default 0,
work_warning	int default 0,
work_warning_fiz int default 0,
work_disconnect	int default 0,
work_disconnect_fiz int default 0,
work_reconnect	int default 0,
work_reconnect_fiz int default 0,
bill_count	int default 0,
bill_count_fiz  int default 0,
work_doc_PKEE	int default 0,
work_doc_PKEE_fiz int default 0,
work_ps_teplo	int default 0,
work_ps_defect	int default 0,
work_ps_defect_fail int default 0,
work_ps_defect_adv int default 0,
work_repair_teplo int default 0,
work_clear_al10	numeric(12,2) default 0,
work_clear_al04	numeric(12,2) default 0,
work_ps_kap	int default 0,
work_comp_change_s int default 0,
work_comp_change_g int default 0,
work_phase_meas	int default 0,
work_clamp	int default 0,
work_ti_check	int default 0,
work_cable_repl	int default 0,
work_al10_repl	numeric(12,2) default 0,
work_al04_repl	numeric(12,2) default 0,
primary key (id_fider)
);


  */


CREATE or replace FUNCTION rep_fidermonitor_fun(date,date)                                                  
    RETURNS int                                                                                     
  AS
  '
   declare

 --  pmmgg_b     alias for $1; 
 --  pmmgg_e     alias for $2; 

   pdt_b     alias for $1; 
   pdt_e     alias for $2; 

   vmmgg_bal date;	

begin                                                                                          

  select into vmmgg_bal max(mmgg) from bal_grp_tree_tbl where mmgg <=pdt_e and code_eqp <0;

  Raise Notice ''vmmgg_bal %'', vmmgg_bal;

  delete from rep_fider_monitor_tmp where mmgg = pdt_b;

  insert into rep_fider_monitor_tmp(id_fider, id_position, mmgg)
  select gr.code_eqp,ff.id_position, pdt_b
  from
  bal_grp_tree_tbl as gr 
  join eqm_fider_tbl as ff on (ff.code_eqp = gr.code_eqp)
  where type_eqp = 15 and mmgg = vmmgg_bal;

  Raise Notice ''-1-'';
  update rep_fider_monitor_tmp set length_al10 = sum_a::numeric/1000 , 
                                   length_cl10 = sum_c::numeric/1000
  from 
  (
     select csi.code_eqp_inst, sum(case when eq.type_eqp = 7 then sn_len else 0 end) as sum_a, sum(case when eq.type_eqp = 6 then sn_len else 0 end) as sum_c 
     from bal_eqp_tbl as eq 
     join eqm_compens_station_inst_tbl as csi on (eq.code_eqp=csi.code_eqp) 
     where (eq.type_eqp = 6 or eq.type_eqp = 7) 
     and eq.mmgg = vmmgg_bal group by code_eqp_inst
  ) as sss     
  where sss.code_eqp_inst = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  Raise Notice ''-2-'';
  update rep_fider_monitor_tmp set fiz_count = cnt_all , 
                                   fiz_count_3f =cnt_3f,
				   fiz_count_1f = cnt_all - cnt_3f
  from 
  (
    select gr.id_fider, sum(case when coalesce(c.cod_zone,0)=0 then 1 else 0 end ) as cnt_all,
    sum(case when coalesce(c.cod_zone,0)<>0 then 1 else 0 end) as cnt_3f
    from bal_grp_tree_tbl as gr
    join clm_pclient_tbl as c on (c.id_eqpborder = -gr.code_eqp)
    where code_eqp<0 and type_eqp = 12 and coalesce(c.id_state,0)<>50
    and gr.mmgg =vmmgg_bal 
    group by id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  Raise Notice ''-3-'';
  update rep_fider_monitor_tmp set point_count =  cnt, 
                                   point_count1f = cnt_1ph,
				   point_count3f = cnt_3ph,
				   point_count_ti = cnt_tt, 	
				   point_count_noti = cnt_3ph+cnt_1ph-cnt_tt,
				   point_count1fu = cnt_1phu,
				   point_count3fu = cnt_3phu
  from 
  ( select gr.id_fider, count(distinct gr.code_eqp) as cnt, 
    sum(case when coalesce(phase,0)=1 then 1 else 0 end) as cnt_1ph,
    sum(case when coalesce(phase,0)=2 then 1 else 0 end) as cnt_3ph,
    sum(case when m.code_eqp_e is not null and m.code_eqp_e <> mp.id_point then 1 else 0 end) as cnt_tt,
    sum(case when coalesce(phase,0)=1 and newcontrol < pdt_b then 1 else 0 end) as cnt_1phu,
    sum(case when coalesce(phase,0)=2 and newcontrol < pdt_b then 1 else 0 end) as cnt_3phu
    from (select * from bal_grp_tree_tbl as gr where mmgg = vmmgg_bal  order by code_eqp) as gr
    join clm_client_tbl as c on (c.id = gr.id_client)
    join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
    join eqm_meter_point_h as mp on (mp.id_point = gr.code_eqp) 
    left join 
    ( select m1.code_eqp,m1.id_type_eqp,im.phase,tt.code_eqp_e,m1.dt_control,im.term_control,
      CASE WHEN dt_control is not null THEN dt_control + (text(im.term_control)||'' year'')::interval ELSE NULL END as newcontrol
      from eqm_meter_h as m1 
      join eqm_eqp_tree_h as tt on (tt.code_eqp = m1.code_eqp)
      join eqd_meter_energy_h as me on (me.code_eqp = m1.code_eqp)
      join eqi_meter_tbl as im on (im.id = m1.id_type_eqp) 
      where me.kind_energy  = 1
      and me.dt_b <= pdt_e and (coalesce(me.dt_e,pdt_e) > pdt_e or me.dt_e is null)
      and tt.dt_b <= pdt_e and (coalesce(tt.dt_e,pdt_e) > pdt_e or tt.dt_e is null)
      and m1.dt_b <= pdt_e and (coalesce(m1.dt_e,pdt_e) > pdt_e or m1.dt_e is null)
      order by m1.code_eqp
    ) as m on (m.code_eqp = mp.id_meter)
    where c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
    and mp.dt_b <= pdt_e and (coalesce(mp.dt_e,pdt_e) > pdt_e or mp.dt_e is null)
    group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

--  завантаження т/с<5%
  Raise Notice ''-4-'';
  update rep_fider_monitor_tmp set ti_count_5p = cnt  
  from 
  (
   select gr.id_fider,count(*) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg = vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join (select distinct id_point from acd_met_kndzn_tbl where mmgg = vmmgg_bal and k_tr >1 and p_w < 5 and kind_energy = 1) as p5 on (p5.id_point = gr.code_eqp)
   where c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  Raise Notice ''-5-'';
--К-сть т.о. з протермнованими термнами проведення тех переврки 
  update rep_fider_monitor_tmp set point_count_tpu = work_cnt
  from 
  (
   select gr.id_fider,count(*) as work_cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_works_tbl as w on (w.id_point = gr.code_eqp)
   join (select id_client, id_point, id_type, max(dt_work) as dt_work from clm_works_tbl where dt_work <=  pdt_b 
         group by id_client, id_point, id_type) as w2 
    on (w.id_client = w2.id_client and w.id_point = w2.id_point and w.id_type = w2.id_type and w.dt_work  = w2.dt_work ) 
    join cli_works_tbl as wi on (w.id_type = wi.id ) 
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and wi.ident = ''work1'' and coalesce(w.next_work_date,w.dt_work+''3 year''::interval) <= pdt_b
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  Raise Notice ''-6-'';
-- К-сть т.о. з протермнованими термнами проведення контрольного огляду 
  update rep_fider_monitor_tmp set point_count_cou = work_cnt
  from 
  (
   select gr.id_fider,count(*) as work_cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_works_tbl as w on (w.id_point = gr.code_eqp)
   join (select id_client, id_point, id_type, max(dt_work) as dt_work from clm_works_tbl where dt_work <=  pdt_b 
         group by id_client, id_point, id_type) as w2 
    on (w.id_client = w2.id_client and w.id_point = w2.id_point and w.id_type = w2.id_type and w.dt_work  = w2.dt_work ) 
    join cli_works_tbl as wi on (w.id_type = wi.id ) 
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and wi.ident = ''work2'' and coalesce(w.next_work_date,w.dt_work+''6 month''::interval) <= pdt_b
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  -- доп параметры фидера
  Raise Notice ''-7-'';
  update rep_fider_monitor_tmp set length_al04 = value
  from mnm_eqp_params_h 
  where id_param = 1 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set length_cl04 = value
  from mnm_eqp_params_h 
  where id_param = 2 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set wearing_cl10 = value
  from mnm_eqp_params_h 
  where id_param = 3 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set wearing_cl04 = value
  from mnm_eqp_params_h 
  where id_param = 4 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set rp_count = value
  from mnm_eqp_params_h 
  where id_param = 6 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set ps_count_pwr_s = value
  from mnm_eqp_params_h 
  where id_param = 7 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set ps_count_pwr_g = value
  from mnm_eqp_params_h 
  where id_param = 8 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set line_count_shift = value
  from mnm_eqp_params_h 
  where id_param = 9 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set ps_count_kap = value
  from mnm_eqp_params_h 
  where id_param = 10 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set length_line10_clear = value
  from mnm_eqp_params_h 
  where id_param = 11 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

  update rep_fider_monitor_tmp set length_line04_clear = value
  from mnm_eqp_params_h 
  where id_param = 12 and code_eqp = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b
  and dt_b <= pdt_e and (coalesce(dt_e,pdt_e) > pdt_e or dt_e is null) ;

--работы по фидеру 
  Raise Notice ''-8-'';
update rep_fider_monitor_tmp set 
	work_clear_al10 = coalesce(sum1,0),
	work_clear_al04 = coalesce(sum2,0),
	work_ps_kap     = coalesce(sum3,0),
	work_comp_change_s = coalesce(sum4,0),
	work_comp_change_g = coalesce(sum5,0),
	work_phase_meas = coalesce(sum6,0), 
	work_clamp      = coalesce(sum7,0),
	work_ti_check   = coalesce(sum8,0),
	work_cable_repl = coalesce(sum9,0),
	work_al10_repl  = coalesce(sum10,0),
	work_al04_repl  = coalesce(sum11,0),
	disconnect_count_04 = coalesce(sum12,0),
	disconnect_count_10 = coalesce(sum13,0),
	work_ps_teplo	= coalesce(sum14,0),
	work_ps_defect	= coalesce(sum15,0),
	work_ps_defect_fail = coalesce(sum16,0),
	work_ps_defect_adv = coalesce(sum17,0),
	work_repair_teplo = coalesce(sum18,0),	
	work_tp_fiz 	= coalesce(sum120,0),
	work_co_fiz 	= coalesce(sum130,0),
	work_meterch_fiz = coalesce(sum140,0),
	work_meter_new_fiz = coalesce(sum150,0),
	work_indication_fiz = coalesce(sum160,0),
	work_bill_fiz 	= coalesce(sum170,0),
	work_new_obj_fiz = coalesce(sum180,0),
	work_repair_obj_fiz = coalesce(sum190,0),
	work_warning_fiz = coalesce(sum200,0),
	work_disconnect_fiz = coalesce(sum210,0),
	work_reconnect_fiz = coalesce(sum220,0),
	work_reserve_inspect = coalesce(sum300,0),
	work_pwr_inspect = coalesce(sum310,0),
	work_pwrre_inspect = coalesce(sum320,0),
	work_limit_plan = coalesce(sum330,0),
	work_measurings = coalesce(sum340,0),
	work_1kcheck = coalesce(sum350,0),
	work_inspect_EAT = coalesce(sum360,0),
	work_inspect_PKEE = coalesce(sum370,0),
	work_new_obj = coalesce(sum380,0),
	work_repair_obj = coalesce(sum390,0), 
	pwr_limit_set = coalesce(sum290,0), 
	work_closing = coalesce(sum400,0), 
	raid_count = coalesce(sum410,0),
        work_doc_PKEE  = coalesce(sum371,0),
	work_doc_PKEE_fiz = coalesce(sum372,0)
 
from (
	select id_fider, 
	sum(CASE WHEN id_type = 1 then cnt else 0 end ) as sum1,
	sum(CASE WHEN id_type = 2 then cnt else 0 end ) as sum2,
	sum(CASE WHEN id_type = 3 then cnt else 0 end ) as sum3,
	sum(CASE WHEN id_type = 4 then cnt else 0 end ) as sum4,
	sum(CASE WHEN id_type = 5 then cnt else 0 end ) as sum5,
	sum(CASE WHEN id_type = 6 then cnt else 0 end ) as sum6,
	sum(CASE WHEN id_type = 7 then cnt else 0 end ) as sum7,
	sum(CASE WHEN id_type = 8 then cnt else 0 end ) as sum8,
	sum(CASE WHEN id_type = 9 then cnt else 0 end ) as sum9,
	sum(CASE WHEN id_type = 10 then cnt else 0 end ) as sum10,
	sum(CASE WHEN id_type = 11 then cnt else 0 end ) as sum11,
	sum(CASE WHEN id_type = 12 then cnt else 0 end ) as sum12,
	sum(CASE WHEN id_type = 13 then cnt else 0 end ) as sum13,
	sum(CASE WHEN id_type = 14 then cnt else 0 end ) as sum14,
	sum(CASE WHEN id_type = 15 then cnt else 0 end ) as sum15,
	sum(CASE WHEN id_type = 16 then cnt else 0 end ) as sum16,
	sum(CASE WHEN id_type = 17 then cnt else 0 end ) as sum17,
	sum(CASE WHEN id_type = 18 then cnt else 0 end ) as sum18,
	sum(CASE WHEN id_type = 120 then cnt else 0 end ) as sum120,
	sum(CASE WHEN id_type = 130 then cnt else 0 end ) as sum130,
	sum(CASE WHEN id_type = 140 then cnt else 0 end ) as sum140,
	sum(CASE WHEN id_type = 150 then cnt else 0 end ) as sum150,
	sum(CASE WHEN id_type = 160 then cnt else 0 end ) as sum160,
	sum(CASE WHEN id_type = 170 then cnt else 0 end ) as sum170,
	sum(CASE WHEN id_type = 180 then cnt else 0 end ) as sum180,
	sum(CASE WHEN id_type = 190 then cnt else 0 end ) as sum190,
	sum(CASE WHEN id_type = 200 then cnt else 0 end ) as sum200,
	sum(CASE WHEN id_type = 210 then cnt else 0 end ) as sum210,
	sum(CASE WHEN id_type = 220 then cnt else 0 end ) as sum220,
	sum(CASE WHEN id_type = 300 then cnt else 0 end ) as sum300,
	sum(CASE WHEN id_type = 310 then cnt else 0 end ) as sum310,
	sum(CASE WHEN id_type = 320 then cnt else 0 end ) as sum320,
	sum(CASE WHEN id_type = 330 then cnt else 0 end ) as sum330,
	sum(CASE WHEN id_type = 340 then cnt else 0 end ) as sum340,
	sum(CASE WHEN id_type = 350 then cnt else 0 end ) as sum350,
	sum(CASE WHEN id_type = 360 then cnt else 0 end ) as sum360,
	sum(CASE WHEN id_type = 370 then cnt else 0 end ) as sum370,
	sum(CASE WHEN id_type = 380 then cnt else 0 end ) as sum380,
	sum(CASE WHEN id_type = 390 then cnt else 0 end ) as sum390,
	sum(CASE WHEN id_type = 290 then cnt else 0 end ) as sum290,
	sum(CASE WHEN id_type = 400 then cnt else 0 end ) as sum400,	
	sum(CASE WHEN id_type = 410 then cnt else 0 end ) as sum410,
	sum(CASE WHEN id_type = 371 then cnt else 0 end ) as sum371,
	sum(CASE WHEN id_type = 372 then cnt else 0 end ) as sum372
	from mnm_fider_works_tbl
	where dt_work >=pdt_b and dt_work <= pdt_e
	group by id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;


  Raise Notice ''-8-1-'';
--для работ по абонентам, где не указан фидер

update rep_fider_monitor_tmp set 
	work_reserve_inspect = work_reserve_inspect+coalesce(sum300,0),
	work_pwr_inspect = work_pwr_inspect+coalesce(sum310,0),
	work_pwrre_inspect = work_pwrre_inspect+coalesce(sum320,0),
	work_limit_plan = work_limit_plan+coalesce(sum330,0),
	work_measurings = work_measurings+coalesce(sum340,0),
	work_1kcheck = work_1kcheck+coalesce(sum350,0),
	work_inspect_EAT = work_inspect_EAT+coalesce(sum360,0),
	work_inspect_PKEE = work_inspect_PKEE+coalesce(sum370,0),
	work_new_obj = work_new_obj+coalesce(sum380,0),
	work_repair_obj = work_repair_obj+coalesce(sum390,0), 
	pwr_limit_set = pwr_limit_set+coalesce(sum290,0), 
	work_closing = work_closing+coalesce(sum400,0) 
from (
	select gr.id_fider, 
	sum(CASE WHEN id_type = 300 then cnt else 0 end ) as sum300,
	sum(CASE WHEN id_type = 310 then cnt else 0 end ) as sum310,
	sum(CASE WHEN id_type = 320 then cnt else 0 end ) as sum320,
	sum(CASE WHEN id_type = 330 then cnt else 0 end ) as sum330,
	sum(CASE WHEN id_type = 340 then cnt else 0 end ) as sum340,
	sum(CASE WHEN id_type = 350 then cnt else 0 end ) as sum350,
	sum(CASE WHEN id_type = 360 then cnt else 0 end ) as sum360,
	sum(CASE WHEN id_type = 370 then cnt else 0 end ) as sum370,
	sum(CASE WHEN id_type = 380 then cnt else 0 end ) as sum380,
	sum(CASE WHEN id_type = 390 then cnt else 0 end ) as sum390,
	sum(CASE WHEN id_type = 290 then cnt else 0 end ) as sum290,
	sum(CASE WHEN id_type = 400 then cnt else 0 end ) as sum400	
        from (select distinct id_fider, id_client from bal_grp_tree_tbl where mmgg =  vmmgg_bal and type_eqp=12 and id_client <> -1 order by id_client) as gr
	join mnm_fider_works_tbl as w on (w.id_client = gr.id_client)
	where w.dt_work >=pdt_b and w.dt_work <= pdt_e
        and w.id_fider is null
       	group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- счета 
  Raise Notice ''-9-'';
  update rep_fider_monitor_tmp set bill_count = cnt
  from 
  (
   select gr.id_fider,count(distinct b.id_doc) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join acm_bill_tbl as b on (b.id_client = c.id )
   join dci_document_tbl as d on (d.id = b.idk_doc) 
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and b.id_pref = 10 
   and coalesce(b.dat_e,b.reg_date) >= pdt_b and coalesce(b.dat_e,b.reg_date) <= pdt_e
   and gr.type_eqp = 12 and d.ident <>''bill_act''
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- счета физ
  Raise Notice ''-10-'';
  update rep_fider_monitor_tmp set bill_count_fiz = cnt_all  
  from 
  (
    select gr.id_fider, sum(case when coalesce(c.cod_zone,0)=0 then 1 else 0 end ) as cnt_all
    from bal_grp_tree_tbl as gr
    join clm_pclient_tbl as c on (c.id_eqpborder = -gr.code_eqp)
    join acm_privdem_tbl as pd on (pd.id_client = c.id and pd.mmgg = gr.mmgg)
    where code_eqp<0 and type_eqp = 12
    and gr.mmgg >=date_trunc(''month'',pdt_b) and gr.mmgg <= date_trunc(''month'',pdt_e)
    group by id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

--предупреждения/отключения/подключения
  Raise Notice ''-11-'';
  update rep_fider_monitor_tmp set work_warning = cnt
  from 
  (
   select gr.id_fider,count(distinct sw.id) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_switching_tbl as sw on (sw.id_client = c.id)
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and (action = 2 or action = 5) and sw.dt_action >=pdt_b and sw.dt_action <= pdt_e
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  update rep_fider_monitor_tmp set work_disconnect = cnt
  from 
  (
   select gr.id_fider,count(distinct sw.id) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_switching_tbl as sw on (sw.id_client = c.id)
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and action = 1 and sw.dt_action >=pdt_b and sw.dt_action <= pdt_e
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  update rep_fider_monitor_tmp set work_reconnect = cnt
  from 
  (
   select gr.id_fider,count(distinct sw.id) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_switching_tbl as sw on (sw.id_client = c.id)
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and action = 3 and sw.dt_action >=pdt_b and sw.dt_action <= pdt_e
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- работы
  Raise Notice ''-12-'';
  update rep_fider_monitor_tmp set work_tp = cnt_tp,
				   work_co = cnt_co,
				   work_meterch = cnt_meterch
  from 
  (
   select gr.id_fider,sum(CASE WHEN wi.ident = ''work1'' THEN 1 ELSE 0 END ) as cnt_tp,
	              sum(CASE WHEN wi.ident = ''work2'' THEN 1 ELSE 0 END ) as cnt_co,
		      sum(CASE WHEN wi.ident = ''work3'' THEN 1 ELSE 0 END ) as cnt_meterch		
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_works_tbl as w on (w.id_point = gr.code_eqp)
   join cli_works_tbl as wi on (w.id_type = wi.id ) 
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and w.dt_work >=pdt_b and w.dt_work <= pdt_e
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- снято показаний
  Raise Notice ''-13-'';
  update rep_fider_monitor_tmp set work_indication = coalesce(cnt,0)
  from 
  (
   select gr.id_fider,count(distinct wi.id_work ) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join clm_works_tbl as w on (w.id_point = gr.code_eqp)
   join clm_work_indications_tbl as wi on (wi.id_work = w.id)
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and w.dt_work >=pdt_b and w.dt_work <= pdt_e
   and wi.kind_energy = 1 and wi.value is not null and wi.value <>0
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- для МЕМ добавить показания из обходных листов
  Raise Notice ''-14-'';
  update rep_fider_monitor_tmp set work_indication =work_indication+ coalesce(cnt,0)
  from 
  (
   select gr.id_fider,count(distinct s.id ) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg =  vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join acm_inspectstr_tbl as s on (s.id_point = gr.code_eqp)
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and s.dt_insp >=pdt_b and s.dt_insp <= pdt_e
   and s.kind_energy = 1 and s.zone in (0,3,5) and s.value is not null and s.value <>0
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- количество ТП

  update rep_fider_monitor_tmp set ps_count = cnt ,
				   ps_count_abon = cnt_abonps,
				   ps_count_res = cnt - cnt_abonps
  from (
  select gr.id_p_eqp as id_fider, count(gr.code_eqp) as cnt , sum(coalesce(cs.abon_ps,0)) as cnt_abonps
  from bal_grp_tree_tbl as gr
  join eqm_compens_station_tbl as cs on (cs.code_eqp = gr.code_eqp)
  where gr.mmgg =  vmmgg_bal and gr.type_eqp = 8
  group by gr.id_p_eqp
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- установка новых счетчиков абонентов
  update rep_fider_monitor_tmp set work_meter_new = cnt
  from (
select id_fider, count(distinct id_meter) as cnt
from(
select ssss.*,   
case when ssss.id_voltage in (3,31,32) and type_eqp = 15 then ssss.code_eqp 
     when ssss.id_voltage2 in (3,31,32) and type_eqp2 = 15 then code_eqp2 
     when ssss.id_voltage3 in (3,31,32) and type_eqp3 = 15 then code_eqp3 END as id_fider
from  
(  
  select mainss.*, 
  gr1.type_eqp, gr1.code_eqp, gr1.id_voltage ,  
  gr2.type_eqp as type_eqp2, gr2.code_eqp as code_eqp2, gr2.id_voltage as id_voltage2,  
  gr3.type_eqp as type_eqp3, gr3.code_eqp as code_eqp3, gr3.id_voltage as id_voltage3
  from  
(  
  select sss1.*,  c.code, c.short_name  
  from  
 ( select id_client, id_doc, id_meter, id_point, kind_energy, id_zone , ss1.num_eqp, ss1.id_typemet, ss1.value, ss1.prev_value  , ss1.coef_comp,  
     ss2.num_eqp as num_eqp2, ss2.id_typemet as id_typemet2, ss2.value as value2, ss2.coef_comp as coef_comp2 , coalesce(ss1.date_end,ss2.date_end) as date_end  
     from  
(  select distinct i.id_doc,i.id_client, i.date_end,dind.id_meter, mp.id_point, dind.id_previndic, dind.num_eqp, dind.id_typemet,dind.kind_energy, dind.id_zone, dind.value, prind.value as prev_value , dind.coef_comp  
  from acm_headindication_tbl as i  
  join dci_document_tbl as dk on (i.idk_document = dk.id)  
  join acd_indication_tbl as dind on (i.id_doc = dind.id_doc)  
  join eqm_meter_point_h as mp on (mp.id_meter = dind.id_meter and mp.dt_b<=i.reg_date and coalesce(mp.dt_e,i.date_end) >= i.date_end)  
  left join acd_indication_tbl as prind on (prind.id = dind.id_previndic)  
  left join eqm_equipment_h as eq on (eq.id = dind.id_meter and eq.num_eqp  = dind.num_eqp and eq.dt_e = i.date_end)  
  where dk.ident = ''chn_cnt'' and i.date_end >= pdt_b and i.date_end <= pdt_e and (dind.id_previndic is not null or eq.id is not null )  
) as ss1  
right join  
(  select distinct i.id_doc,i.id_client , i.date_end ,dind.id_meter, mp.id_point, dind.num_eqp, dind.id_typemet, dind.kind_energy, dind.id_zone, dind.value, dind.coef_comp   
  from acm_headindication_tbl as i  
  join dci_document_tbl as dk on (i.idk_document = dk.id)  
  join acd_indication_tbl as dind on (i.id_doc = dind.id_doc)  
  join eqm_meter_point_h as mp on (mp.id_meter = dind.id_meter and mp.dt_b<=i.reg_date and coalesce(mp.dt_e,i.date_end) >= i.date_end)  
  join eqm_equipment_h as eq on (eq.id = dind.id_meter and eq.num_eqp  = dind.num_eqp and eq.dt_b = i.date_end)  
  where dk.ident = ''chn_cnt'' and i.date_end >= pdt_b and i.date_end <= pdt_e and dind.id_previndic is null  
  and i.id_client <> eq.id_department 
) as ss2  
 using(id_client,id_doc, id_meter, id_point, kind_energy, id_zone)  
  where ss1.id_doc is null
) as sss1  
join clm_client_tbl as c on (c.id = sss1.id_client)  
) as mainss  
  left join bal_abons_tbl as ba on (ba.id_point = mainss.id_point)  
  left join bal_grp_tree_tbl as gr1 on (gr1.code_eqp = ba.id_grp and gr1.mmgg= vmmgg_bal)  
  left join bal_grp_tree_tbl as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg=vmmgg_bal)  
  left join bal_grp_tree_tbl as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg=vmmgg_bal)  
  ) as ssss  
) as allss
group by id_fider
  ) as finalsss
  where finalsss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;


  update rep_fider_monitor_tmp set work_meter_new_res = cnt
  from (
select id_fider, count(distinct id_meter) as cnt
from
(  
  select mainss.*,ff.* 
  from  
(  
 select id_client, id_doc, id_meter, id_point, kind_energy, id_zone , ss1.num_eqp, ss1.id_typemet, ss1.value, ss1.prev_value  , ss1.coef_comp,  
     ss2.num_eqp as num_eqp2, ss2.id_typemet as id_typemet2, ss2.value as value2, ss2.coef_comp as coef_comp2 , coalesce(ss1.date_end,ss2.date_end) as date_end 
     from  
(  select distinct i.id_doc,i.id_client, i.date_end,dind.id_meter, mp.id_point, dind.id_previndic, dind.num_eqp, dind.id_typemet,dind.kind_energy, dind.id_zone, dind.value, prind.value as prev_value , dind.coef_comp  
  from acm_headindication_tbl as i  
  join dci_document_tbl as dk on (i.idk_document = dk.id)  
  join acd_indication_tbl as dind on (i.id_doc = dind.id_doc)  
  join eqm_meter_point_h as mp on (mp.id_meter = dind.id_meter and mp.dt_b<=i.reg_date and coalesce(mp.dt_e,i.date_end) >= i.date_end)  
  left join acd_indication_tbl as prind on (prind.id = dind.id_previndic)  
  left join eqm_equipment_h as eq on (eq.id = dind.id_meter and eq.num_eqp  = dind.num_eqp and eq.dt_e = i.date_end)  
  where dk.ident = ''chn_cnt'' and i.date_end >= pdt_b and i.date_end <= pdt_e and (dind.id_previndic is not null or eq.id is not null )  
) as ss1  
right join  
(  select distinct i.id_doc,i.id_client , i.date_end ,dind.id_meter, mp.id_point, dind.num_eqp, dind.id_typemet, dind.kind_energy, dind.id_zone, dind.value, dind.coef_comp   
  from acm_headindication_tbl as i  
  join dci_document_tbl as dk on (i.idk_document = dk.id)  
  join acd_indication_tbl as dind on (i.id_doc = dind.id_doc)  
  join eqm_meter_point_h as mp on (mp.id_meter = dind.id_meter and mp.dt_b<=i.reg_date and coalesce(mp.dt_e,i.date_end) >= i.date_end)  
  join eqm_equipment_h as eq on (eq.id = dind.id_meter and eq.num_eqp  = dind.num_eqp and eq.dt_b = i.date_end)  
  where dk.ident = ''chn_cnt'' and i.date_end >= pdt_b and i.date_end <= pdt_e and dind.id_previndic is null  
  and i.id_client = eq.id_department 
) as ss2  
 using(id_client,id_doc, id_meter, id_point, kind_energy, id_zone)  
  where ss1.id_doc is null
) as mainss  
left join 
(
  select p.code_eqp ,
  CASE WHEN bg.type_eqp = 15 THEN bg.code_eqp WHEN bg.type_eqp = 8 THEN bg.id_fider END as id_fider 
  from bal_eqp_tbl as p
   join eqm_compens_station_inst_tbl as st on (p.code_eqp = st.code_eqp)
   join bal_grp_tree_tbl as bg on (bg.code_eqp =  st.code_eqp_inst and bg.type_eqp in (8,15) ) 
   where p.type_eqp =12 and p.mmgg=vmmgg_bal and bg.mmgg=vmmgg_bal 
   and p.id_client = syi_resid_fun() and  p.id_client = p.id_rclient
) as ff 
on (ff.code_eqp = mainss.id_point)  
) as allss
group by id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- акты ПКЕЕ физ
  Raise Notice ''-15-'';
  update rep_fider_monitor_tmp set pkee_count_fiz = cnt_all  
  from 
  (
    select gr.id_fider, count( distinct akt.id_doc ) as cnt_all
    from bal_grp_tree_tbl as gr
    join clm_pclient_tbl as c on (c.id_eqpborder = -gr.code_eqp)
    join ( select * from akt_hdata as h join akt_client as ac on (ac.id = h.id_client and ac.typ=1) 
          where h.reg_date >= pdt_b and h.reg_date <= pdt_e
         ) as akt on (akt.id_clm = c.id and akt.mmgg = gr.mmgg )
    where code_eqp<0 and type_eqp = 12
    and gr.mmgg >=date_trunc(''month'',pdt_b) and gr.mmgg <= date_trunc(''month'',pdt_e)
    group by id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

-- акты ПКЕЕ юр
  Raise Notice ''-16-1-''; --без указания конкретного счетчика
  update rep_fider_monitor_tmp set pkee_count = cnt
  from 
  (
   select gr.id_fider,count(distinct akt.id_doc) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg = vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join (
     select h.id_doc, ac.id_clm as id_client from akt_hdata as h join akt_client as ac on (ac.id = h.id_client and ac.typ=0)
     left join  (select id_doc, value as id_meter from akt_data where id_par = 180 ) as m on (m.id_doc = h.id_doc)
     where m.id_doc is null and h.reg_date >= pdt_b and h.reg_date <= pdt_e
     ) as akt on (akt.id_client  = c.id) 
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   and gr.type_eqp = 12
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;

  Raise Notice ''-16-2-''; --указан счетчика
  update rep_fider_monitor_tmp set pkee_count = pkee_count+ cnt
  from 
  (
   select gr.id_fider,count(distinct akt.id_doc) as cnt
   from (select * from bal_grp_tree_tbl as gr where mmgg = vmmgg_bal order by code_eqp) as gr
   join clm_client_tbl as c on (c.id = gr.id_client)
   join clm_statecl_tbl as stcl on (stcl.id_client=c.id ) 
   join (
	select h.id_doc, ac.id_clm as id_client, mp.id_point
        from akt_hdata as h join akt_client as ac on (ac.id = h.id_client and ac.typ=0)
	join  (select id_doc, value::int as id_meter from akt_data where id_par = 180 ) as m on (m.id_doc = h.id_doc)
	join eqm_meter_point_h as mp on (mp.id_meter = m.id_meter and mp.dt_b <= pdt_e and  (mp.dt_e is null or mp.dt_e >= pdt_e ) )
        where h.reg_date >= pdt_b and h.reg_date <= pdt_e
   ) as akt on (akt.id_point = gr.code_eqp)
   where 
   c.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and c.idk_work not in (0) and coalesce(c.id_state,0) not in (50,99)
   group by gr.id_fider
  ) as sss     
  where sss.id_fider = rep_fider_monitor_tmp.id_fider and rep_fider_monitor_tmp.mmgg = pdt_b;


  RETURN 0;
  end;'                                                                                           
  LANGUAGE 'plpgsql';    