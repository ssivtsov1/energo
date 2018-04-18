/*select droptable('seb_spo_tmp');
select droptable('seb_tar_tmp');
select droptable('seb_udog_tmp');
select droptable('seb_spo');
select droptable('seb_tar');
select droptable('seb_udog');
  */
drop function crt_ttbl();
create function crt_ttbl() Returns boolean As'
Declare
dt_rest text;
id_rest date;
ret boolean;
begin
if table_exists(''sys_basa_tbl'') then
select into id_rest value_ident from syi_sysvars_tbl
 where ident=''dt_restore'';
raise notice ''0'';
if not found then
raise notice ''1'';
insert into syi_sysvars_tbl (id,ident,value_ident) 
         values (114,''dt_restore'',now()::date);

insert into syi_sysvars_tbl (id,ident,value_ident) 
         values (115,''dt_last'', 
        min( max ((select max(dt) from acm_bill_tbl) ::date,
                  (select max(dt) from acm_pay_tbl)::date          
                 )::date,
             now()::date 
           )
          );
else
update syi_sysvars_tbl set value_ident=now() where id=114;
update syi_sysvars_tbl set value_ident= (select min( max ((select max(dt) from acm_bill_tbl) ::date,
                  (select max(dt) from acm_pay_tbl)::date          
                 )::date,        now()::date    )  )  where id=115;


end if;
end if;
                            /*
if table_exists(''act_eqp_branch_tbl'') then
raise notice ''====================tmp table created ========================= '';
  return true;
end if;
                          */
--perform DropTable(''act_eqp_branch_tbl''); --ÄÅÒÅ×Ï ÏÂÏÒÕÄÏ×ÁÎÉÑ ËÌÉÅÎÔÁ
create temp table act_eqp_branch_tbl (
     node_oid           oid, -- OID ÚÁĞÉÓÉ × eqm_eqp_tree É × ÔÁÂÌÉÃÁÈ ÚÁÍÅÎÙ
     id_tree    	int, -- tree index
     id_rtree    	int, -- tree index
     code_eqp		int, -- equipment index
     id_p_eqp		int,
     type_eqp		int,
     dat_b		date,
     dat_e		date,
     lvl		int,	
     line_no 		integer default 0,
     id_client		int,            
     id_rclient		int,
     loss_power         int default 0, -- ÕŞÁÓÔ×ÕÅÔ ÌÉ × ÒÁÓŞÅÔÅ ĞÏÔÅÒØ
     state		int
--, primary key(code_eqp,id_tree,line_no,dat_b,dat_e)
);

CREATE temp TABLE act_eqp_branch2_tbl  AS select * from act_eqp_branch_tbl;
    create temp table eqt_change_tbl(
     id_change       integer not null DEFAULT nextval(''"eqm_change_seq"''::text), 
     id_operation    integer,  -- ËÏÄ ÏĞÅÒÁÃÉÉ ÚÁÍÅÎÙ ÇÅÎÅÒÉÔÓÑ ÄÌÑ ÉÄÅÎÔÉÆÉËÁÃÉÉ
                               -- ÏĞÅÒÁÃÉÉ ÚÁÍÅÎÙ × ÃÅÌÏÍ 
     mode            int,
     id_client       integer,   
     id_tree         int,  
     id_usr          int,  --i ËÏÄ ×ÙĞÏÌÎÉ×ÛÅÇÏ 
     code_eqp        integer,
     date_change     timestamp,  --   ÄÁÔÁ ÚÁÍÅÎÙ 
     processing      integer default 0,
     enabled         integer default 1
    );
/*
--perform DropTable(''act_eqm_par_tbl''); --ĞÁÒÁÍÅÔÒÙ ÏÂÏÒÕÄÏ×ÁÎÉÑ ËÌÉÅÎÔÁ
create temp table act_eqm_par_tbl (
     id_eqp		int,
     dat_b		date,
     dat_e		date,
     id_param		int,
     val		numeric(14,4),	
     primary key(id_eqp,dat_b,dat_e,id_param)
);
  */
--perform DropTable(''act_point_branch_tbl''); --ÔÁÂÌÉÃÁ ÔÏŞÅË ÕŞÅÔÁ ËÌÉÅÎÔÁ
create temp table act_point_branch_tbl (
     id_brnch		int, 
     id_tree    	int,  	-- tree index
     id_point		int,		-- meter index
     id_p_point		int,		
     dat_b		date,
     dat_e		date,
     id_client		int,
     id_rclient		int,
     id_border		int,
     count_lost		int,
     wtm		int,
     k_corr		numeric(4,2)
--     ,primary key(id_point,id_p_point,dat_b)
);

create temp table act_2point_branch_tbl (
     id_brnch		int, 
     id_tree    	int,  	-- tree index
     id_2point          int,
     id_point		int,		-- meter index
     id_p_point		int,		
     dat_b		date,
     dat_e		date,
     id_client		int,
     id_rclient		int,
     sum_demand         int,
     fact_demand        int,
     sum_lost           int,
     fact_lost          int 
--     ,primary key(id_point,id_p_point,dat_b)
);

--perform DropTable(''act_meter_pnt_tbl''); --ÓŞÅÔŞÉËÉ ËÌÉÅÎÔÁ (ÄÌÑ ÓÏ×ÍÅÓÔÉÍÏÓÔÉ)
create temp table act_meter_pnt_tbl (
     id_point		int,
     id_meter		int,		-- meter index
     dat_b		date,
     dat_e		date,
     primary key(id_point,id_meter,dat_b)
);

--perform DropTable(''act_demand_tbl''); --ÒÁÓŞÅÔÁ ĞÏÔÒ. ĞÏ ÓŞÅÔŞÉËÁÍ (ÄÌÑ ÓÏ×ÍÅÓÔÉÍÏÓÔÉ)
create temp table act_demand_tbl (
     id_point		int,		-- point index
     id_meter		int,		-- meter index
     num_eqp		varchar(25),
     k_tr		numeric(14,4),-- default 1,
     k_ts		numeric(14,4) default 1,
     i_ts		int,-- default 1,
     id_type_eqp	int,
     dat_b		date,
     dat_e		date,
     primary key(id_meter,num_eqp,dat_b)
);
    /*
--perform DropTable(''act_check_zone'');--ÄÌÑ ĞÒÏ×ÅÒËÉ ÓÏÏÔ×ÅÔÓÔ×ÉÑ ÚÏÎ ĞÏ ÕŞÅÔÁÍ
create temp table act_check_zone (
     id_point		int,		
     id_p_point		int,
     id_meter		int,		
     kind_energy	int,		
     id_zone		int,		
     dat_b		date,
     dat_e		date,
     primary key(id_point,id_meter,kind_energy,id_zone,dat_b,dat_e)
);
      */
--perform DropTable(''act_met_kndzn_tbl'');--ÒÁÓŞÅÔÎÏÅ ĞÏÔÒ. ĞÏ ÓŞÅÔŞÉËÁÍ
create temp table act_met_kndzn_tbl (
     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     id_zone		int,	
     k_tr		numeric(14,4) default 1,
     id_type_eqp	int,
     dat_b		date,
     dat_e		date,
     b_val		numeric(14,4),
     e_val		numeric(14,4),
     id_parent_doc	int,
     met_demand		numeric(14,4),
     ktr_demand		numeric(16,0),
     ident		int default 1,
     id_ind 		int, ----51,52,53 for add_calcs
     meter_demand	int, ---default=ktr_demand
     calc_demand_cnt	int,
     comment_cnt	text,   
     calc_demand_w	int,
     comment_w		text,   
     k_ts		numeric(14,4),
     i_ts		int,
     hand_losts		int,
     calc_demand_nocnt  int,
     p_w                numeric(10,3)
--,
--     primary key(id_meter,num_eqp,kind_energy,id_zone,dat_b)
);

create temp table act_met_kndzn_tbl1 (
     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     id_zone		int,	
     k_tr		numeric(14,4) default 1,
     id_type_eqp	int,
     dat_b		date,
     dat_e		date,
     b_val		numeric(14,4),
     e_val		numeric(14,4),
     id_parent_doc	int,
     met_demand		numeric(14,4),
     ktr_demand		int,
     ident		int default 1,
     id_ind 		int, ----51,52,53 for add_calcs
     meter_demand	int, ---default=ktr_demand
     calc_demand_cnt	int,
     comment_cnt	text,   
     calc_demand_w	int,
     comment_w		text,   
     k_ts		numeric(14,4),
     i_ts		int,
     hand_losts		int,
     calc_demand_nocnt  int,
     p_w                numeric(10,3),
     tt                 int,
     dt1                date,
     dt2                date
--,
--     primary key(id_meter,num_eqp,kind_energy,id_zone,dat_b)
);


create temp table act1_met_kndzn_tbl (
     id_point		bigint,
     id_meter		bigint,
     num_eqp		varchar(25),
     kind_energy	bigint,
     id_zone		bigint,	
     k_tr		numeric(14,4) default 1,
     id_type_eqp	bigint,
     dat_b		date,
     dat_e		date,
     b_val		numeric(14,4),
     e_val		numeric(14,4),
     id_parent_doc	bigint,
     met_demand		numeric(14,4),
     ktr_demand		bigint,
     ident		bigint default 1,
     id_ind 		bigint, ----51,52,53 for add_calcs
     meter_demand	bigint, ---default=ktr_demand
     calc_demand_cnt	bigint,
     comment_cnt	text,   
     calc_demand_w	bigint,
     comment_w		text,   
     k_ts		numeric(14,4),
     i_ts		bigint,
     hand_losts		bigint,
     calc_demand_nocnt  bigint,
     p_w                numeric(10,3)
--,
--     primary key(id_meter,num_eqp,kind_energy,id_zone,dat_b)
);

--perform DropTable(''act_pwr_demand_tbl''); --ÒÁÓŞ. ĞÏÔÒ. ĞÏ ÔÏŞËÁÍ ÕŞÅÔÁ
create temp table act_pwr_demand_tbl (
     id_point		int,
     kind_energy	int,
     id_zone		int default 0,	
     dat_b		date,
     dat_e		date,
     sum_demand		int default 0,
     fact_demand	int default 0,
     sum_losts		int default 0,
     fact_losts		int default 0,
     ident		int default 1, 
     id_bill		int, --id_doc for avg calculation from acm_bill_tbl
     doubl2_demand      int default 0
     , in_res_losts	int default 0
     , out_res_losts	int default 0
     , abn_losts	int default 0
    , in_lost   	int default 0
 
--,  ident= 1-indic,2-pwr,3-avrg_indic,4-r_by_active
--     primary key(id_point,kind_energy,dat_b,id_zone) --ident) 
);


create temp table act_2pwr_demand_tbl (
     id_2point          int,
     id_point		int,
     id_p_point         int, 
     kind_energy	int,
     id_zone		int default 0,	
     dat_b		date,
     dat_e		date,
     sum_demand		int default 0,
     fact_demand	int default 0,
     sum_losts		int default 0,
     fact_losts		int default 0,
     ident		int default 1, 
     id_bill		int, --id_doc for avg calculation from acm_bill_tbl
     doubl2_demand      int default 0
     , in_res_losts	int default 0
     , out_res_losts	int default 0
     , abn_losts	int default 0
 
--,  ident= 1-indic,2-pwr,3-avrg_indic,4-r_by_active
--     primary key(id_point,kind_energy,dat_b,id_zone) --ident) 
);

--perform DropTable(''act_losts_eqm_tbl''); --ÏÂÏÒÕÄÏ×ÁÎÉÅ ÄÌÑ ÒÁÓŞÅÔÁ ĞÏÔÅÒØ
create temp table act_losts_eqm_tbl (
     id_point		int,
     id_eqp		int,
     id_p_eqp		int,
     dat_b		date,
     dat_e		date,
     type_eqm		int,	
     id_type_eqp	int,
     sn_len		numeric(14,2),
     tt			int,
     pxx_r0		numeric(14,4),
     pkz_x0		numeric(14,4),
     ixx		numeric,
     ukz_un		numeric,
     sum_wp		int,
     sum_wq		int --,
     , res_l		int default 0  -------ĞÒÉÚÎÁË ËÕÄÁ ÏÔĞÒÁ×ÉÔØ ĞÏÔÅÒÉ: 0 ÎÁ ÁÂÏÎÅÎÔÁ, 
     ,own_wp            int default 0               ---------1 - ×ÎÕÔÒÅÎÎÉÊ ÔÒÁÎÚÉÔ,2 - ×ÎÅÛÎÉÊ ÔÒÁÎÚÉÔ, 
				       ---------3 - ĞÏÔÅÒÉ ÁÂÏÎÅÎÔÁ ÎÁ òüó

--    primary key(id_point,id_eqp,dat_b)
);



CREATE temp TABLE act_losts_eqm2_tbl  AS select * from act_losts_eqm_tbl;
 
create temp table act_desclosts_eqm_tbl(
    id_point 	int,
    id_m_point 	int,
    primary key(id_point,id_m_point)
);

create temp table act_calc_losts_tbl(
     id_point		int,
     id_eqp		int,
     num		int,
     dat_b		date,
     dat_e		date,
     type_eqm		int,	
     id_type_eqp	int,
     sn_len		numeric(14,2),
     tt			int,
     tw			int,
     pxx_r0		numeric(14,4),
     pkz_x0		numeric(14,4),
     ixx		numeric,
     ukz_un		numeric,
     w_p		int,
     w_q		int,
     wp_1		int,
     s_xx_addwp		int,
     s_kz_addwq		int,
     kind_energy	int,
     dw			int
     , res_l		int,
     is_use             int default 0,
     in_demand          int default 0

--,
--     primary key(id_point,id_eqp,dat_b,kind_energy)
);

CREATE  INDEX  act_calc_losts_ind    ON act_calc_losts_tbl ( id_point,id_eqp,num,dat_b,dat_e,type_eqm,id_type_eqp );
CREATE temp TABLE act_calc_losts2_tbl  AS select * from act_calc_losts_tbl;
        /*
--perform DropTable(''act_check_pnt''); --ÄÌÑ ĞÒÏ×ÅÒËÉ ÔÏŞÅË ÕŞÅÔÁ ÎÁ ×ÉÄÙ ÕŞÉÔ. ÜÎÅÒÇÉÉ
create temp table act_check_pnt (
     id_point		int,		
     kind_energy	int,		
     dat_b		date,
     dat_e		date,
     primary key(id_point,kind_energy,dat_b)
);
          */
--perform DropTable(''act_pnt_knd''); --×ÉÄÙ ÜÎÅÒÇÉÉ ĞÏ ÔÏŞËÁÍ ÕŞÅÔÁ
create temp table act_pnt_knd (
     id_point		int,		
     kind_energy	int,		
     dat_b		date,
     dat_e		date--,
    -- primary key(id_point,kind_energy,dat_b)
);

create temp table act_met_knd (
     id_meter		int,		
     kind_energy	int,		
     dat_b		date,
     dat_e		date--,
--     primary key(id_meter,kind_energy,dat_b)
);


--perform DropTable(''act_pnt_pwr''); --ÕÓÔÁÎÏ×ÌÅÎÎÁÑ ÍÏİÎÏÓÔØ ĞÏ ÔÏŞËÁÍ ÕŞÅÔÁ
create temp table act_pnt_pwr (
     id_point		int,		
     power		numeric(14,4),
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

--perform DropTable(''act_pnt_cmp''); --ÍÏİÎÏÓÔØ ËÏÍĞÅÎÓ. ÕÓÔÁÎÏ×ÏË ĞÏ Ô. ÕŞÅÔÁ???
create temp table act_pnt_cmp (
     id_point		int,		
     comp		numeric(14,4), 
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

--perform DropTable(''act_pnt_wtm''); --×ÒÅÍÑ ÒÁÂÏÔÙ ÚÁ ĞÅÒÉÏÄ ĞÏ ÔÏŞËÁÍ ÕŞÅÔÁ
create temp table act_pnt_wtm (
     id_point		int,		
     wtm		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

--perform DropTable(''act_pnt_tg''); --ÔÁÎÇÅÎÓ ÄÌÑ ÒÁÓŞ. ÒÅÁËÔ. ÓÏÓÔÁ×Ì. ĞÏ Ô. ÕŞÅÔÁ
create temp table act_pnt_tg (
     id_point		int,		
     id_tg		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_pnt_share (
     id_point		int,		
     share		numeric(10,5),
     id_zone		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_pnt_lost (
     id_point		int,		
     count_lost		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_pnt_mlost (
     id_point		int,		
     main_losts		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_inlosts_eqm_tbl (
    id_point 	int,
    id_p_point 	int,
    primary key(id_point,id_p_point)
);


create temp table act_pnt_inlost (
     id_point		int,		
     in_lost		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_pnt_cntitr (
     id_point		int,		
     count_itr		int,
     itr_comment	text,
     dat_b		date,
     dat_e		date,
     code_tt            int,
     accuracy           int,
     primary key(id_point,dat_b)
);
create temp table act_met_cntmet (
     id_meter		int,		
     count_met		int,
     met_comment	text,
     dat_b		date,
     dat_e		date,
     primary key(id_meter,dat_b)
);

create temp table act_met_warm (
     id_meter		int,
     dat_b		date,
     dat_e		date,
     warm		int,
     warm_comment	text,
  primary key(id_meter,dat_b)
);

create temp table act_pnt_cntavg (
     id_point		int,		
     ldemand		int,
     pdays		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);
create temp table act_pnt_cntavgr (
     id_point		int,		
     ldemandr		int,
     pdays		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);
create temp table act_pnt_cntavgg (
     id_point		int,		
     ldemandg		int,
     pdays		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_pnt_d (
     id_point		int,		
     d			numeric(6,4),
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

create temp table act_pnt_un (
     id_point		int,		
     id_voltage		int,
     dat_b		date,
     dat_e		date,
     primary key(id_point,dat_b)
);

/*
create temp table act_five_per(
  id_point	int,
  kind_energy	int,
  percent	int,
  dat_b		date,
  dat_e		date,
  wp_calc	int,
  primary key(id_point)
);
  */
--perform DropTable(''act_pnt_tarif''); --ÔÁÒÉÆÙ ĞÏ ÔÏŞËÁÍ ÕŞÅÔÁ
create temp table act_pnt_tarif (
     id_point		int,		
     id_tarif		int default 0,		
     dat_b		date,
     dat_e		date,
     primary key(id_point,id_tarif,dat_b)
);
        /*
--perform DropTable(''act_ch_err''); --ÏÛÉÂËÉ ĞÒÉ ÒÁÓŞÅÔÅ
create temp table act_ch_err (
     step		varchar(55),
     err_msg		varchar(255),
     idcl_idpnt		varchar(255)
);         
--perform DropTable(''act_ch_all''); --ÏÛÉÂËÉ ĞÒÉ ÒÁÓŞÅÔÅ
create temp table act_ch_all (
     msg		varchar(255),
     add_par		varchar(255)
);         
--perform DropTable(''act_met_knd_tbl''); --ÄÌÑ ×ÙÂÏÒËÉ ×ÉÄÏ× ÜÎÅÒÇÉÉ
create temp table act_met_knd_tbl (
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     dat_b_energy	timestamp,
     dat_e		timestamp
);

--perform DropTable(''act_met_zn_tbl''); --ÄÌÑ ×ÙÂÏÒËÉ ÚÏÎ
create temp table act_met_zn_tbl (
     id_meter		int,
     num_eqp		varchar(25),
     id_zone		int,	
     dat_b_zone		timestamp,
     dat_e		timestamp
);

create temp table act_type_err (
     id			int,
     descript		varchar(254)
);

insert into act_type_err(id,descript) values(1,''?Š©¥¸ ˆŠ‚ ©¹¸¥ ¢Š©‰'');
insert into act_type_err(id,descript) values(2,''Ù ©¹¸Š ¢Š©‰ ¾Š º¹€¸±„Š¾ ¾¥ ¹€¥¾ ªŠ©¥¸'');
insert into act_type_err(id,descript) values(3,''À‰ ©¹¸¢ ¢Š©‰ ¾Š ‚‰¾ŠªŠ¾ ½¥€ ¢¥©…½‰Š ¹» Œ¾Š·°¥¥'');
insert into act_type_err(id,descript) values(4,''À‰ ©¹¸¢ ¢Š©‰ ¾Š ‚‰¾ŠªŠ¾ ½¥€ Œ¾Š·°¥¥, ¸¹©¹·…» ¢¸‰‚‰¾ ¾‰ ªŠ©¥¸Š'');
insert into act_type_err(id,descript) values(5,''À‰ ©¹¸¢ ¢Š©‰ º¹€¸±„Š¾¹ €½‰ ªŠ©¥¸‰ ª ¹€¥¾‰¸¹½…  ½¥€¹  Œ¾Š·°¥¥ ¾‰ ¹€¥¾ ºŠ·¥¹€'');
insert into act_type_err(id,descript) values(6,''Ñ© ªŠ©¥¸‰ º¹€¸±„Š¾¹ ¹ˆ¹·¢€¹½‰¾¥Š, ©¹ ¾Š€¹º¢ª©¥ ¹'');
insert into act_type_err(id,descript) values(7,''Ñ© ¥‚ Š·¥©Š±¼¾¹°¹ ©·‰¾ª¯¹· ‰©¹·‰ º¹€¸±„Š¾¹ ¾Š ·‰‚·ŠŠ¾¾¹Š ¹ˆ¹·¢€¹½‰¾¥Š'');
insert into act_type_err(id,descript) values(8,''Ñ© ¥‚ Š·¥©Š±¼¾¹°¹ ©·‰¾ª¯¹· ‰©¹·‰ ¾Š º¹€¸±„Š¾¹ ¾¥¸‰¸¹Š ¹ˆ¹·¢€¹½‰¾¥Š'');
insert into act_type_err(id,descript) values(9,''Ñ© ¥‚ Š·¥©Š±¼¾¹°¹ ©·‰¾ª¯¹· ‰©¹·‰ ¾Š º¹€¸±„Š¾ ¾¥ ªŠ©¥¸ ¾¥ ©·‰¾ª¯¹· ‰©¹·'');
insert into act_type_err(id,descript) values(10,''¹¾… ¾‰ ¹€¾¹  ¥‚ €¢ˆ±¥·¢„¥« ¢Š©¹½ ¾Š ª¹¹©½Š©ª©½¢„© ‚¹¾‰  ¾‰ ¢¸‰‚‰¾¾¹  ¹ª¾¹½¾¹  ¢Š©Š'');
insert into act_type_err(id,descript) values(11,''Æ±¶ €‰¾¾¹°¹ ©¥º‰ ªŠ©¥¸‰ ½ ªº·‰½¹¾¥¸Š ¾Š º·¹ª©‰½±Š¾‰ ·‰‚·¶€¾¹ª©¼'');
insert into act_type_err(id,descript) values(12,''Æ±¶ €‰¾¾¹°¹ ©¥º‰ ©·-·‰,½¹‚€. ±¥¾¥¥, ¸‰ˆŠ±¶ ¾Š «‰½‰©‰Š© º‰·‰ Š©·¹½ €±¶ ·‰ªŠ©‰ º¹©Š·¼'');
insert into act_type_err(id,descript) values(13,''Æ±¶ ªŠ©¥¸‰ ¾Šº¹±¾…Š º‰·‰ Š©·… ¥‚ Š·¥©Š±¼¾…« ©·-·¹½, ¸¹©¹·…Š ¾Š¹ˆ«¹€¥ … €±¶ ½…¥ª±Š¾¥¶ ¸¹Œ¯. ©·-†¥¥'');
insert into act_type_err(id,descript) values(14,''? ªº·‰½¹¾¥¸Š ª©‰½¹¸ ¾Š© €‰¾¾…« ¹ ÀÆ?'');
insert into act_type_err(id,descript) values(15,''? ªº·‰½¹¾¥¸Š ©‰·¥¯¹½ ¾Š© ‚¾‰Š¾¥» €±¶ ¢¸‰‚‰¾¾¹°¹ ©‰·¥¯‰ ¾‰ ½Šª¼ ¢¸‰‚‰¾¾…» ºŠ·¥¹€'');
insert into act_type_err(id,descript) values(16,''? ªº·‰½¹¾¥¸Š ©‰·¥¯¹½ €±¶ ¢¸‰‚‰¾¾¹°¹ ©‰·¥¯‰ ‚‰¾ŠªŠ¾¹ €½‰ ‚¾‰Š¾¥¶ ¾‰ ¹€¾¢ ¥ ©¢ ¤Š €‰©¢'');
insert into act_type_err(id,descript) values(17,''Æ±¶ ¢¸‰‚‰¾¾¹°¹ ©‰·¥¯‰ º·¥ ½½¹€Š ‚¾‰Š¾¥¶ ¾Š º·¹ª©‰½±Š¾ ½¥€ ½‰±„©…'');
insert into act_type_err(id,descript) values(18,''À‰ ©¹¸Š ¢Š©‰ ¾Š º·¹ª©‰½±Š¾¹ ½·Š ¶ ·‰ˆ¹©…, ¾Š¹ˆ«¹€¥ ¹Š €±¶ ·‰ªŠ©‰ º¹©Š·¼'');
insert into act_type_err(id,descript) values(19,''À‰ ©¹¸Š ¢Š©‰ ¾Š º·¹ª©‰½±Š¾ ©‰¾°Š¾ª ¯¥, ¾Š¹ˆ«¹€¥ ¹Š €±¶ ·‰ªŠ©‰ º¹©Š·¼'');
insert into act_type_err(id,descript) values(20,''À‰ ªŠ©¥¸Š ¾Š ¢¸‰‚‰¾ ½¥€ ¢¥©…½‰Š ¹» Œ¾Š·°¥¥'');
insert into act_type_err(id,descript) values(21,''À‰ ªŠ©¥¸Š ¾Š ¢¸‰‚‰¾… ‚¹¾…'');
insert into act_type_err(id,descript) values(22,''Æ±¶ €‰¾¾¹» ½¹‚€. ±¥¾¥¥, ¸‰ˆŠ±¶ ¾Š ‚‰¾ŠªŠ¾‰ €±¥¾‰ ¥±¥ ¸±‰ªª ¾‰º·¶¤Š¾¥¶'');
insert into act_type_err(id,descript) values(23,''Æ±¶ €‰¾¾¹» ©¹¸¥ ¢Š©‰ ¾Š ‚‰¾ŠªŠ¾ Œ¸½¥½‰±Š¾© Œ¸¹¾¹ .  ¹¾¹ª©¥ D, ©·Šˆ. €±¶ ·‰ªŠ©‰ º±‰©… ‚‰ ·Š‰¸©¥½¾¢„ Œ¾.'');


create temp table act_ch_eqp_err (
     code_eqp		int,
     id_client		int,
     id_p_eqp		int,
     id_err		int	
);
        */
create temp table act_summ_val(
  id_client 	int,
  dat		date,
  ident		varchar(3),
  summ		numeric(14,4),
  id_doc	int,
  ident1	varchar(10),
  dat_transmiss date,
  id_pref       integer,
  upd           integer
);


create temp table act_clc_inf(
  id_client 	int,
  dat_b		date,
  dat_e		date,
  id_doc        int,
  type_doc      varchar(10),
  summ		numeric(14,4),
  k_inf		numeric(14,8),
  sum_inf	numeric(14,2),
  ident1	varchar(10),
  calc_day      integer,
  id_pref       integer 
);

        /*
create temp table act_res_eqp_err (
     code_eqp		int,
     nam_eqp		varchar(254),
     code		numeric(9,0),
     short_name		varchar(40),
     txt		varchar(254)	
);
        */
create temp table sys_error_tbl (
     nam varchar(15),
     res integer,
     id_error integer,
     ident varchar(10)--,
    -- primary key (nam)
);
        /*
create temp table sys_cllist_tbl(
	w_idcl 	int,
	c_idcl	int,
   primary key (c_idcl)
);
          */
/*
create temp table act_met_warm_calc (
     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     id_zone		int,	
     dat_b		date,
     dat_e		date,
     ktr_demand		int,
     calc_demand	int,
  primary key(id_point,id_meter,num_eqp,kind_energy,id_zone,dat_b)
);
*/
        /*
create temp table total_ch(
 code_eqp	int,
 id_client 	int,
 id_p_eqp	int,
 id_err		int,
 nam_eqp	varchar(254),
 code		numeric(9,0),
 short_name	varchar(40),
 txt		varchar(254) 
);
        */

create temp table del_ind(
     id_ind 		int,
     id_doc 		int,
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     id_zone		int,	
     date_end 		date,
     mmgg		date,
     id_client		int,
     id_type_eqp	int,
     carry		int,
     k_tr		numeric(14,4),
     id_prv		int,     
     id_next		int     
);

create temp table act_warm_period(
     id_client 	int,
     dat_b 	date,
     dat_e 	date,
     primary key(id_client,dat_b)
 );

create temp table act_add_calc (
     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     kind_energy	int,
     id_zone		int,	
     k_ts		numeric(14,4) default 1,
     i_ts		int,-- default 1,
     dat_b		date,
     dat_e		date,
     ktr_demand		int,
     calc_demand	int,
     ident		int,
  primary key(id_point,id_meter,num_eqp,kind_energy,id_zone,dat_b)
);

create temp table act_res_notice(
     res  varchar(254)
);

create temp table act_pnt_hlosts (
     id_point		int,		
     flag_hlosts	int,		
     primary key(id_point)
);

create temp table del_doc (
     id_doc		int,		
     id_ind 		int,		
     primary key(id_ind)
);


create temp table act_difmetzone_tbl (
     kind_energy        int,
     id_point_p   	int,
     --id_meter_p         int,
     zone_p   	        int, 
     id_point           int,
    -- id_meter           int,
     zone               int,
     dt_b               date,
     dt_e               date,
     percent            numeric(10,5),
     demand_p           int,
     demand_calc        int,
     fact_demand_p      int,
     demand_do          int

    -- primary key(id_point_p,zone_p,id_point,zone,kind_energy,dt_e)
);

--select * into temp syi_sysvars_tmp from syi_sysvars_tbl;
CREATE temp TABLE syi_sysvars_tmp AS select * from syi_sysvars_tbl;

CREATE temp TABLE sys_error_tmp AS select * from sys_error_tbl;
delete from sys_error_tmp;
CREATE temp TABLE syi_field_tbl_tmp AS select * from syi_field_tbl;
CREATE temp TABLE syi_table_tbl_tmp AS select * from syi_table_tbl;
CREATE temp TABLE  act_pwr_limit_over_tbl as select * from acd_pwr_limit_over_tbl;
delete from  act_pwr_limit_over_tbl;
CREATE temp TABLE  act_pwr_limit_pnt_tbl as select * from acd_pwr_limit_pnt_tbl;
delete from  act_pwr_limit_pnt_tbl;


CREATE temp TABLE  seb_obr_all_tmp  (
    id  int  default nextval(''"obr_all_seq"''::text),
    id_client int,
   id_pref int default 0,
   cod_n  int  default ''0'',
   roz  int  default ''0'',
   cod_r  int  default ''0'',
   cod_roz  int  default ''0'',
   cod_pidr  int  default ''0'',
   period  date  ,
   osob_r  int  default ''0'',
   osob_rsk  varchar(200)  default '''',
   deb_zpmv  numeric(16,2)  default  0 ,
   deb_zpme  numeric(16,2)  default  0 ,
   deb_zpmpdv  numeric(16,2)  default  0 ,
   kr_zpmv  numeric(16,2)  default  0 ,
   kr_zpme  numeric(16,2)  default  0 ,
   kr_zpmpdv  numeric(16,2)  default  0 ,
   deb_pm99v  numeric(16,2)  ,
   deb_pm00v  numeric(16,2)  ,
   deb_pm00e  numeric(16,2)  ,
   deb_pm00pdv  numeric(16,2) ,
   deb_pm01v  numeric(16,2)   ,
   deb_pm01e  numeric(16,2)   ,
   deb_pm01pdv  numeric(16,2)  ,
   deb_pm02v  numeric(16,2)   ,
   deb_pm02e  numeric(16,2)   ,
   deb_pm02pdv  numeric(16,2)   ,
   nar  numeric(16,2)   ,
   nar_v  numeric(16,2)  ,
   nar_e  numeric(16,2)  ,
   nar_pdv  numeric(16,2)  ,
   opl_zv  numeric(16,2)   ,
   opl_ze  numeric(16,2)   ,
   opl_zpdv  numeric(16,2)  ,
   opl_bv  numeric(16,2)    ,
   opl_be  numeric(16,2)   ,
   opl_bpdv  numeric(16,2)  ,
   opl_iv  numeric(16,2)   ,
   opl_ie  numeric(16,2)   ,
   opl_ipdv  numeric(16,2)  ,
   deb_kmv  numeric(16,2)   ,
   deb_kme  numeric(16,2)   ,
   deb_kmpdv  numeric(16,2)   ,
   kr_zkmv  numeric(16,2)  ,
   kr_zkme  numeric(16,2)  ,
   kr_zkmpdv  numeric(16,2)  ,
   deb_km99v  numeric(16,2)  ,
   deb_km00v  numeric(16,2)  ,
   deb_km00e  numeric(16,2)  ,
   deb_km00pdv  numeric(16,2) ,
   deb_km01v  numeric(16,2)  ,
   deb_km01e  numeric(16,2)   ,
   deb_km01pdv  numeric(16,2) ,
   deb_km02v  numeric(16,2)   ,
   deb_km02e  numeric(16,2)   ,
   deb_km02pdv  numeric(16,2) ,
   deb_pm03v  numeric(16,2)   ,
   deb_pm03e  numeric(16,2)   ,
   deb_pm03pdv  numeric(16,2) ,
   deb_km03v  numeric(16,2)   ,
   deb_km03e  numeric(16,2)   ,
   deb_km03pdv  numeric(16,2) ,
   deb_pm04v  numeric(16,2)   ,
   deb_pm04e  numeric(16,2)   ,
   deb_pm04pdv  numeric(16,2) ,
   deb_km04v  numeric(16,2)   ,
   deb_km04e  numeric(16,2)   ,
   deb_km04pdv  numeric(16,2) ,
   deb_pm05v  numeric(16,2)   ,
   deb_pm05e  numeric(16,2)   ,
   deb_pm05pdv  numeric(16,2) ,
   deb_km05v  numeric(16,2)   ,
   deb_km05e  numeric(16,2)   ,
   deb_km05pdv  numeric(16,2) ,
   deb_pm06v  numeric(16,2)   ,
   deb_pm06e  numeric(16,2)   ,
   deb_pm06pdv  numeric(16,2) ,
   deb_km06v  numeric(16,2)   ,
   deb_km06e  numeric(16,2)   ,
   deb_km06pdv  numeric(16,2) ,
   mmgg         date ,  --default fun_mmgg(),
   flock        int default 0,
   b_kred  numeric(16,2)   ,
   b_kred_tax  numeric(16,2)  ,
   e_kred  numeric(16,2)   ,
   e_kred_tax  numeric(16,2)  ,
   deb_pm07v  numeric(16,2)   ,
   deb_pm07e  numeric(16,2)   ,
   deb_pm07pdv  numeric(16,2) ,
   deb_km07v  numeric(16,2)   ,
   deb_km07e  numeric(16,2)   ,
   deb_km07pdv  numeric(16,2), 
   idk_work  numeric(3,0), 
   deb_pm08v  numeric(16,2)   ,
   deb_pm08e  numeric(16,2)   ,
   deb_pm08pdv  numeric(16,2) ,
   deb_km08v  numeric(16,2)   ,
   deb_km08e  numeric(16,2)   ,
   deb_km08pdv  numeric(16,2), 
   deb_pm09v  numeric(16,2)   ,
   deb_pm09e  numeric(16,2)   ,
   deb_pm09pdv  numeric(16,2) ,
   deb_km09v  numeric(16,2)   ,
   deb_km09e  numeric(16,2)   ,
   deb_km09pdv  numeric(16,2),
   deb_pm10v  numeric(16,2)   ,
   deb_pm10e  numeric(16,2)   ,
   deb_pm10pdv  numeric(16,2) ,
   deb_km10v  numeric(16,2)   ,
   deb_km10e  numeric(16,2)   ,
   deb_km10pdv  numeric(16,2),
   deb_pm11v  numeric(16,2)   ,
   deb_pm11e  numeric(16,2)   ,
   deb_pm11pdv  numeric(16,2) ,
   deb_km11v  numeric(16,2)   ,
   deb_km11e  numeric(16,2)   ,
   deb_km11pdv  numeric(16,2),
   deb_pm12v  numeric(16,2)   ,
   deb_pm12e  numeric(16,2)   ,
   deb_pm12pdv  numeric(16,2) ,
   deb_km12v  numeric(16,2)   ,
   deb_km12e  numeric(16,2)   ,
   deb_km12pdv  numeric(16,2),
   deb_pm13v  numeric(16,2)   ,
   deb_pm13e  numeric(16,2)   ,
   deb_pm13pdv  numeric(16,2) ,
   deb_km13v  numeric(16,2)   ,
   deb_km13e  numeric(16,2)   ,
   deb_km13pdv  numeric(16,2),
   deb_pm14v  numeric(16,2)   ,
   deb_pm14e  numeric(16,2)   ,
   deb_pm14pdv  numeric(16,2) ,
   deb_km14v  numeric(16,2)   ,
   deb_km14e  numeric(16,2)   ,
   deb_km14pdv  numeric(16,2),
   deb_pm15v  numeric(16,2)   ,
   deb_pm15e  numeric(16,2)   ,
   deb_pm15pdv  numeric(16,2) ,
   deb_km15v  numeric(16,2)   ,
   deb_km15e  numeric(16,2)   ,
   deb_km15pdv  numeric(16,2),
   deb_pm16v  numeric(16,2)   ,
   deb_pm16e  numeric(16,2)   ,
   deb_pm16pdv  numeric(16,2) ,
   deb_km16v  numeric(16,2)   ,
   deb_km16e  numeric(16,2)   ,
   deb_km16pdv  numeric(16,2),
   deb_pm17v  numeric(16,2)   ,
   deb_pm17e  numeric(16,2)   ,
   deb_pm17pdv  numeric(16,2) ,
   deb_km17v  numeric(16,2)   ,
   deb_km17e  numeric(16,2)   ,
   deb_km17pdv  numeric(16,2),
   deb_pm18v  numeric(16,2)   ,
   deb_pm18e  numeric(16,2)   ,
   deb_pm18pdv  numeric(16,2) ,
   deb_km18v  numeric(16,2)   ,
   deb_km18e  numeric(16,2)   ,
   deb_km18pdv  numeric(16,2),
  PRIMARY KEY  ( id )
) ; 

CREATE temp TABLE  seb_obr_tmp  (
   id  int  default nextval(''"obr_seq"''::text),
   id_client int,
   id_pref int default 0,
   cod_n  int  default ''0'',
   roz  int  default ''0'',
   cod_r  int  default ''0'',
   cod_roz  int  default ''0'',
   cod_pidr  int  default ''0'',
   period  date  ,
   osob_r  int  default ''0'',
   osob_rsk  varchar(200)  default '''',
   deb_zpmv  numeric(16,2)  default  0 ,
   deb_zpme  numeric(16,2)  default  0 ,
   deb_zpmpdv  numeric(16,2)  default  0 ,
   kr_zpmv  numeric(16,2)  default  0 ,
   kr_zpme  numeric(16,2)  default  0 ,
   kr_zpmpdv  numeric(16,2)  default  0 ,
   deb_pm99v  numeric(16,2)  default  0 ,
   deb_pm00v  numeric(16,2)  default  0 ,
   deb_pm00e  numeric(16,2)  default  0 ,
   deb_pm00pdv  numeric(16,2)  default  0 ,
   deb_pm01v  numeric(16,2)  default  0 ,
   deb_pm01e  numeric(16,2)  default  0 ,
   deb_pm01pdv  numeric(16,2)  default  0 ,
   deb_pm02v  numeric(16,2)  default  0 ,
   deb_pm02e  numeric(16,2)  default  0 ,
   deb_pm02pdv  numeric(16,2)  default  0 ,
   nar  numeric(16,2)  default  0 ,
   nar_v  numeric(16,2)  default  0 ,
   nar_e  numeric(16,2)  default  0 ,
   nar_pdv  numeric(16,2)  default  0 ,
   opl_zv  numeric(16,2)  default  0 ,
   opl_ze  numeric(16,2)  default  0 ,
   opl_zpdv  numeric(16,2)  default  0 ,
   opl_bv  numeric(16,2)  default  0 ,
   opl_be  numeric(16,2)  default  0 ,
   opl_bpdv  numeric(16,2)  default  0 ,
   opl_iv  numeric(16,2)  default  0 ,
   opl_ie  numeric(16,2)  default  0 ,
   opl_ipdv  numeric(16,2)  default  0 ,
   deb_kmv  numeric(16,2)  default  0 ,
   deb_kme  numeric(16,2)  default  0 ,
   deb_kmpdv  numeric(16,2)  default  0 ,
   kr_zkmv  numeric(16,2)  default  0 ,
   kr_zkme  numeric(16,2)  default  0 ,
   kr_zkmpdv  numeric(16,2)  default  0 ,
   deb_km99v  numeric(16,2)  default  0 ,
   deb_km00v  numeric(16,2)  default  0 ,
   deb_km00e  numeric(16,2)  default  0 ,
   deb_km00pdv  numeric(16,2)  default  0 ,
   deb_km01v  numeric(16,2)  default  0 ,
   deb_km01e  numeric(16,2)  default  0 ,
   deb_km01pdv  numeric(16,2)  default  0 ,
   deb_km02v  numeric(16,2)  default  0 ,
   deb_km02e  numeric(16,2)  default  0 ,
   deb_km02pdv  numeric(16,2)  default  0 ,
   deb_pm03v  numeric(16,2)  default  0 ,
   deb_pm03e  numeric(16,2)  default  0 ,
   deb_pm03pdv  numeric(16,2)  default  0 ,
   deb_km03v  numeric(16,2)  default  0 ,
   deb_km03e  numeric(16,2)  default  0 ,
   deb_km03pdv  numeric(16,2)  default  0 ,
   deb_pm04v  numeric(16,2)  default  0 ,
   deb_pm04e  numeric(16,2)  default  0 ,
   deb_pm04pdv  numeric(16,2)  default  0 ,
   deb_km04v  numeric(16,2)  default  0 ,
   deb_km04e  numeric(16,2)  default  0 ,
   deb_km04pdv  numeric(16,2)  default  0 ,
   deb_pm05v  numeric(16,2)  default  0 ,
   deb_pm05e  numeric(16,2)  default  0 ,
   deb_pm05pdv  numeric(16,2)  default  0 ,
   deb_km05v  numeric(16,2)  default  0 ,
   deb_km05e  numeric(16,2)  default  0 ,
   deb_km05pdv  numeric(16,2)  default  0 ,
   deb_pm06v  numeric(16,2)  default  0 ,
   deb_pm06e  numeric(16,2)  default  0 ,
   deb_pm06pdv  numeric(16,2)  default  0 ,
   deb_km06v  numeric(16,2)  default  0 ,
   deb_km06e  numeric(16,2)  default  0 ,
   deb_km06pdv  numeric(16,2)  default  0 ,
   mmgg         date,
   flock        int default 0,
   b_kred  numeric(16,2)  default  0 ,
   b_kred_tax  numeric(16,2)  default  0 ,
   e_kred  numeric(16,2)  default  0 ,
   e_kred_tax  numeric(16,2)  default  0 ,
   deb_pm07v  numeric(16,2)  default  0 ,
   deb_pm07e  numeric(16,2)  default  0 ,
   deb_pm07pdv  numeric(16,2)  default  0 ,
   deb_km07v  numeric(16,2)  default  0 ,
   deb_km07e  numeric(16,2)  default  0 ,
   deb_km07pdv  numeric(16,2)  default  0 ,
      idk_work  numeric(3,0), 
   deb_pm08v  numeric(16,2)   ,
   deb_pm08e  numeric(16,2)   ,
   deb_pm08pdv  numeric(16,2) ,
   deb_km08v  numeric(16,2)   ,
   deb_km08e  numeric(16,2)   ,
   deb_km08pdv  numeric(16,2), 
   deb_pm09v  numeric(16,2)   ,
   deb_pm09e  numeric(16,2)   ,
   deb_pm09pdv  numeric(16,2) ,
   deb_km09v  numeric(16,2)   ,
   deb_km09e  numeric(16,2)   ,
   deb_km09pdv  numeric(16,2), 
   deb_pm10v  numeric(16,2)   ,
   deb_pm10e  numeric(16,2)   ,
   deb_pm10pdv  numeric(16,2) ,
   deb_km10v  numeric(16,2)   ,
   deb_km10e  numeric(16,2)   ,
   deb_km10pdv  numeric(16,2), 
   deb_pm11v  numeric(16,2)   ,
   deb_pm11e  numeric(16,2)   ,
   deb_pm11pdv  numeric(16,2) ,
   deb_km11v  numeric(16,2)   ,
   deb_km11e  numeric(16,2)   ,
   deb_km11pdv  numeric(16,2),
   deb_pm12v  numeric(16,2)   ,
   deb_pm12e  numeric(16,2)   ,
   deb_pm12pdv  numeric(16,2) ,
   deb_km12v  numeric(16,2)   ,
   deb_km12e  numeric(16,2)   ,
   deb_km12pdv  numeric(16,2),
   deb_pm13v  numeric(16,2)   ,
   deb_pm13e  numeric(16,2)   ,
   deb_pm13pdv  numeric(16,2) ,
   deb_km13v  numeric(16,2)   ,
   deb_km13e  numeric(16,2)   ,
   deb_km13pdv  numeric(16,2),
   deb_pm14v  numeric(16,2)   ,
   deb_pm14e  numeric(16,2)   ,
   deb_pm14pdv  numeric(16,2) ,
   deb_km14v  numeric(16,2)   ,
   deb_km14e  numeric(16,2)   ,
   deb_km14pdv  numeric(16,2),
   deb_pm15v  numeric(16,2)   ,
   deb_pm15e  numeric(16,2)   ,
   deb_pm15pdv  numeric(16,2) ,
   deb_km15v  numeric(16,2)   ,
   deb_km15e  numeric(16,2)   ,
   deb_km15pdv  numeric(16,2),
   deb_pm16v  numeric(16,2)   ,
   deb_pm16e  numeric(16,2)   ,
   deb_pm16pdv  numeric(16,2) ,
   deb_km16v  numeric(16,2)   ,
   deb_km16e  numeric(16,2)   ,
   deb_km16pdv  numeric(16,2),
   deb_pm17v  numeric(16,2)   ,
   deb_pm17e  numeric(16,2)   ,
   deb_pm17pdv  numeric(16,2) ,
   deb_km17v  numeric(16,2)   ,
   deb_km17e  numeric(16,2)   ,
   deb_km17pdv  numeric(16,2),
   deb_pm18v  numeric(16,2)   ,
   deb_pm18e  numeric(16,2)   ,
   deb_pm18pdv  numeric(16,2) ,
   deb_km18v  numeric(16,2)   ,
   deb_km18e  numeric(16,2)   ,
   deb_km18pdv  numeric(16,2),
  PRIMARY KEY  ( id )
) ; 







CREATE temp TABLE  seb_obrs_tmp  (
        code numeric(9),
        id_client int,
        id_pref   int,
        mmgg      date,
        hmmgg     date,
        b_dtval     numeric(14,4),
        b_dtval_tax  numeric(14,4),
        b_ktval      numeric(14,4),
        b_ktval_tax  numeric (14,4),
        e_dtval      numeric(14,4),
        e_dtval_tax  numeric(14,4),
        e_ktval      numeric(14,4),
        e_ktval_tax  numeric(14,4)


) ; 
CREATE temp TABLE seb_nar_tmp (
    mmgg date,
    cod_r integer,
    osob_r numeric(9,0),
    id_client integer,
    id_pref integer,
    nom_doc character varying(25),
    d_doc date,
    vid_doc character varying (25),
    vid_nar character varying(25),
    kilk bigint,
    suma numeric(14,4),
    pdv numeric(14,4),
    suma_zpdv numeric,
    dt_trans date,
    id_doc integer,
    idk_doc integer,
    kilk_nas  bigint default 0
);


CREATE temp TABLE seb_opl_tmp (
    mmgg date,
    cod_r integer,
    osob_r numeric(9,0),
    id_client integer,
    nom_doc character varying(25),
    d_doc date,
    id_pref integer,
    vid_doc varchar(25),
    vid_nar character varying,
    period_op date,
    suma numeric(14,2),
    pdv numeric(14,2),
    suma_zpdv numeric(14,2)
);

CREATE temp TABLE seb_bank_tmp (
    cod_r integer,
    mmgg date,
    id   integer default nextval(''"seb_bank_seq"''::text),
    hash_cod integer,
    dt_close  timestamp,
    dt_open   timestamp,
    reason_open varchar(254),
    user_close varchar(50),
    user_open varchar(50)
);

CREATE temp TABLE seb_vsp_tmp (
    cod_r integer,
    osob_r integer,
    dt_att   date,
    dt_fall   date,
    perc_fall numeric(10,5),
    comment varchar(200),
    dt_warning  date,
    place_off varchar(50),
    reason_off varchar(50),
    dt_transmiss date,
    mode_transmiss varchar(50),
    dt_pay      date,
    dt_podkl    date,
    code        int
);

create temp table seb_plan_tmp (
     mmgg               date, 
     id_section    	int, 
     id_pref            int default 10,
     id_client    	int default 0, 
 
     ym13		int default 0,
     ym12		int default 0,
     ym11		int default 0,
     ym10               int default 0,
     s31                int default 0,

     ym03               int default 0,
     ym02               int default 0,
     ym01               int default 0,
     s30                int default 0,
     ym00               int default 0,


     pr_13_03           numeric(10,3) default 0,
     pr_12_02           numeric(10,3) default 0,
     pr_11_01           numeric(10,3) default 0,
                                     
     pr_31_30           numeric(10,3) default 0,

     pr_03_02           numeric(10,3) default 0,
     pr_02_01           numeric(10,3) default 0,
     
     ym_calc            int  default 0,
     ym_plan            int  default 0,
     ym_fact            int  default 0,
     deflect            int  default 0,
     pr_deflect         numeric(10,3)  default 0

);


CREATE temp TABLE seb_renthist_tmp (
    cod_r integer,
    mmgg date,
    dt   date,
    id_client int,
    code numeric(9,0),
    id_point int,
    id_addres int,
    dt_rent_end date,
    dt_last_ind date,
    flag        int,
    comment   varchar(150),
    name_point varchar(50),
    name_object varchar(50),
    name_addres varchar(250)
);



  create temp table eqt_bill_addr_tbl (
     id_doc         int,
     code_eqp       int,   
     code_eqp_inst  int, 
     name_eqp       varchar(50),
     name_eqp_inst  varchar(50),
     addr_eqp       int,
     addr_eqp_inst  int,
     full_adr       varchar(254)
     ); 



 create temp table bal_eqp_tmp (
     id_tree    	int,  	
     code_eqp		int,	
     id_p_eqp		int,	
     type_eqp		int,
     id_type_eqp	int,
     dat_b		timestamp,
     dat_e		timestamp,
     lvl		int,	
     id_client		int,
     id_rclient		int,
     loss_power         int,
     sn_len		numeric(14,2),
     tgfi		numeric(5,2),
     tt			int,
     pxx_r0		numeric(14,4),
     pkz_x0		numeric(14,4),
     ixx		numeric,
     ukz_un		numeric,
     mmgg               date
     ,primary key(code_eqp,id_tree,mmgg)
 );

/*
 create temp table bal_acc_tmp (
     code_eqp		int,		-- equipment index
     dat_b		timestamp,
     dat_e		timestamp,
     demand		int,
     demand04           int,          -- º¹©·Šˆ±Š¾¥Š º¹ 0.4 ¸? 
     lst		numeric(14,4) default 0, -- ª¢  ‰ º¹©Š·¼ º·Š€¸¹½ 
     losts		numeric(14,4) default 0, -- ª¹ˆª©½Š¾¾…Š º¹©Š·¥ ¹ˆ¹·¢€¹½‰¾¥¶ 
     mmgg               date,
     fiz_count          int,
     fiz_power 		numeric(14,4),
     losts_ti 		numeric(14,4) DEFAULT 0,
     losts_tu 		numeric(14,4) DEFAULT 0,
     losts_meter	numeric(14,4) DEFAULT 0,
     losts_linea	numeric(14,4) DEFAULT 0,
     losts_linec	numeric(14,4) DEFAULT 0,
     sumlosts_ti	numeric(14,4) DEFAULT 0,
     sumlosts_tu	numeric(14,4) DEFAULT 0,
     sumlosts_meter	numeric(14,4) DEFAULT 0,
     sumlosts_linea	numeric(14,4) DEFAULT 0,
     sumlosts_linec	numeric(14,4) DEFAULT 0,
     fiz_demand 	integer DEFAULT 0,
     nolost_demand 	integer DEFAULT 0,
     losts_kz 		numeric(14,4) DEFAULT 0,
     losts_xx 		numeric(14,4) DEFAULT 0,
     sumlosts_kz	numeric(14,4) DEFAULT 0,
     sumlosts_xx	numeric(14,4) DEFAULT 0,
     losts_air		numeric(14,4) DEFAULT 0,
     losts_cable	numeric(14,4) DEFAULT 0,
     sumlosts_air	numeric(14,4) DEFAULT 0,
     sumlosts_cable	numeric(14,4) DEFAULT 0,

     primary key(code_eqp,mmgg)
 );
*/

 create temp table bal_acc_tmp (
     code_eqp		int,		-- equipment index
     dat_b		timestamp,
     dat_e		timestamp,
     demand		int,
     demand04           int,          -- º¹©·Šˆ±Š¾¥Š º¹ 0.4 ¸? 
     lst		int default 0, -- ª¢  ‰ º¹©Š·¼ º·Š€¸¹½ 
     losts		int default 0, -- ª¹ˆª©½Š¾¾…Š º¹©Š·¥ ¹ˆ¹·¢€¹½‰¾¥¶ 
     mmgg               date,
     fiz_count          int,
     fiz_power 		numeric(14,4),
     losts_ti 		int DEFAULT 0,
     losts_tu 		int DEFAULT 0,
     losts_meter	int DEFAULT 0,
     losts_linea	int DEFAULT 0,
     losts_linec	int DEFAULT 0,
     sumlosts_ti	int DEFAULT 0,
     sumlosts_tu	int DEFAULT 0,
     sumlosts_meter	int DEFAULT 0,
     sumlosts_linea	int DEFAULT 0,
     sumlosts_linec	int DEFAULT 0,
     fiz_demand 	int DEFAULT 0,
     nolost_demand 	int DEFAULT 0,
     losts_kz 		int DEFAULT 0,
     losts_xx 		int DEFAULT 0,
     sumlosts_kz	int DEFAULT 0,
     sumlosts_xx	int DEFAULT 0,
     losts_air		int DEFAULT 0,
     losts_cable	int DEFAULT 0,
     sumlosts_air	int DEFAULT 0,
     sumlosts_cable	int DEFAULT 0,
     id_un 		int,
     id_spr_type 	int,
     demand_full	int,     -- º¹±¾¹Š º¹©·Šˆ±Š¾¥Š º¹ ªŠ©¥¸¢ (¥ª«¹€¾…Š º¹¸‰‚‰¾¥¶)
     demand_bill	int,     -- º¹©·Šˆ±Š¾¥Š º¹ ªŠ©¢ €‰¾¾¹» ?? ¥ ½ªŠ« €¢ˆ±Š»
--     fact_demand        int, -- ª¹ˆª©½Š¾¾¹Š º¹©·Šˆ±Š¾¥Š º¹ ?? ‰ˆ¹¾Š¾©‰ (‚‰ ½…Š©¹  ª¢ˆ‰ˆ¹¾Š¾©¹½)
     primary key(code_eqp,mmgg)
 );

CREATE temp TABLE bal_grp_tree_conn_tmp
(
  id_tree  integer ,
  code_eqp integer ,
  name     character varying(100),
  id_p_eqp integer,
  type_eqp integer,
  dat_b    timestamp without time zone,
  dat_e    timestamp without time zone,
  lvl      integer,
  id_client integer,
  id_point integer,
  demand   numeric(14,4),
  demand04 numeric(14,4),
  losts    numeric(14,4),
  fact_losts numeric(14,4),
  losts_coef numeric(12,10) DEFAULT 0,
  id_voltage integer,
  mmgg     date NOT NULL,
  is_recon int default 0,
  id_switching int,
  id integer NOT NULL DEFAULT nextval(''bal_grp_tree_conn_seq''),
  id_fider int,
  PRIMARY KEY (id)
); 


 create temp table bal_client_errors_tmp (
     
     id_client     int,
     id_tree   	   int,
     id_border     int,
     id_parent_eqp int	
--     primary key(code_eqp,id_tree,dat_b,dat_e)
 );



 create temp table bal_meter_demand_tmp (
     id_point		int,
     id_meter		int,
     num_eqp		varchar(25),
     k_tr		int default 1,
     id_type_eqp	int,
     dat_b		timestamp,
     dat_e		timestamp,
     b_val		numeric(14,4),
     e_val		numeric(14,4),
     met_demand		numeric(14,4),
     ktr_demand		int,
     mmgg               date,
     primary key(id_meter,num_eqp,k_tr,mmgg)
 );



 create temp table bal_demand_tmp (
     id_point		int,
     ktr_demand		int,
     mmgg               date,
     primary key(id_point,mmgg)
 );



 create temp table bal_grp_tree_tmp(
     id_tree    	int,  	-- tree index
     code_eqp		int,		-- equipment index
     name               varchar(100),
     id_p_eqp		int,		--
     type_eqp		int,
     dat_b		timestamp,
     dat_e		timestamp,
     lvl		int,	
     id_client		int,
     id_point           int, --©¹¸‰ ¢Š©‰ €±¶ ¯¥€Š·¹½, ½½¹€¹½, ‰ˆ¹¾Š¾©¹½
     demand		int, -- º¹±Š‚¾…» ¹©º¢ª¸ º¹ ¯¥€Š·¢
     demand04           int, -- º¹©·Šˆ±Š¾¥Š º¹ 0.4 
     losts		int, -- º¹©Š·¥ º¹ ¯¥€Š·¢ 
     fact_losts         int, -- ¯‰¸©¥Šª¸¥Š º¹©Š·¥ (ˆŠ‚ ¾‰¸·¢©¹¸)
     losts_coef         numeric(12,10) default 0,
     id_voltage         int,
     mmgg               date,
     lost04_metod       int default 0,
     id_fider           int,  
     primary key(code_eqp,id_tree,mmgg)
 );

create temp table bal_losts04_tmp(
     code_eqp		int,		
     l04_count 		int,
     l04_length 	int,
     l04f1_length 	int,
     l04f3_length 	int   ,
     fgcp 		numeric(12,4) ,
     fiz_demand         int,
     nolost_demand	int,
--     lost04_metod 	int,
     losts04		int,
     mmgg               date,
     primary key(code_eqp,mmgg)
);


create temp table seb_saldakt_tmp   (
   id  int  default nextval(''"obr_all_seq"''::text),

   id_client int,
   id_pref int default ''10'',
   cod_department int  default ''0'',
   cod_section int  default ''0'',
   mmgg date    default fun_mmgg(),
   mmgg_p date,
   code int  default ''0'',
   short_name varchar(200)  default '''',
    
   b_dtval    numeric(16,2)  default  0 ,
   b_dtvaltax  numeric(16,2)  default  0 ,
   b_ktval    numeric(16,2)  default  0 ,
   b_ktvaltax  numeric(16,2)  default  0 ,


   e_dtval    numeric(16,2)  default  0 ,
   e_dtvaltax  numeric(16,2)  default  0 ,
   e_ktval    numeric(16,2)  default  0 ,
   e_ktvaltax  numeric(16,2)  default  0 ,

   b_dtval99  numeric(16,2)  default  0 ,
   b_dtvaltax99  numeric(16,2)  default  0 ,
   e_dtval99  numeric(16,2)  default  0 ,
   e_dtvaltax99  numeric(16,2)  default  0 ,

   b_dtval00  numeric(16,2)  default  0 ,
   b_dtvaltax00  numeric(16,2)  default  0 ,
   e_dtval00  numeric(16,2)  default  0 ,
   e_dtvaltax00  numeric(16,2)  default  0 ,

   b_dtval01  numeric(16,2)  default  0 ,
   b_dtvaltax01  numeric(16,2)  default  0 ,
   e_dtval01  numeric(16,2)  default  0 ,
   e_dtvaltax01  numeric(16,2)  default  0 ,

   b_dtval02  numeric(16,2)  default  0 ,
   b_dtvaltax02  numeric(16,2)  default  0 ,
   e_dtval02  numeric(16,2)  default  0 ,
   e_dtvaltax02  numeric(16,2)  default  0 ,


   b_dtval03  numeric(16,2)  default  0 ,
   b_dtvaltax03  numeric(16,2)  default  0 ,
   e_dtval03  numeric(16,2)  default  0 ,
   e_dtvaltax03  numeric(16,2)  default  0 ,

   b_dtval04  numeric(16,2)  default  0 ,
   b_dtvaltax04  numeric(16,2)  default  0 ,
   e_dtval04  numeric(16,2)  default  0 ,
   e_dtvaltax04  numeric(16,2)  default  0 ,

   b_dtval05  numeric(16,2)  default  0 ,
   b_dtvaltax05  numeric(16,2)  default  0 ,
   e_dtval05  numeric(16,2)  default  0 ,
   e_dtvaltax05  numeric(16,2)  default  0 ,

   b_dtval06  numeric(16,2)  default  0 ,
   b_dtvaltax06  numeric(16,2)  default  0 ,
   e_dtval06  numeric(16,2)  default  0 ,
   e_dtvaltax06  numeric(16,2)  default  0 ,

   kvt     numeric(16,2)  default  0 ,   
   dt_val  numeric(16,2)  default  0 ,
   dt_valtax  numeric(16,2)  default  0 ,
   kt_val  numeric(16,2)  default  0 ,
   kt_valtax  numeric(16,2)  default  0 ,
   b_dtval07  numeric(16,2)  default  0 ,
   b_dtvaltax07  numeric(16,2)  default  0 ,
   e_dtval07  numeric(16,2)  default  0 ,
   e_dtvaltax07  numeric(16,2)  default  0 ,
   idk_work   numeric(3,0),
   b_dtval08  numeric(16,2)  default  0 ,
   b_dtvaltax08  numeric(16,2)  default  0 ,
   e_dtval08  numeric(16,2)  default  0 ,
   e_dtvaltax08  numeric(16,2)  default  0 ,
   b_dtval09  numeric(16,2)  default  0 ,
   b_dtvaltax09  numeric(16,2)  default  0 ,
   e_dtval09  numeric(16,2)  default  0 ,
   e_dtvaltax09  numeric(16,2)  default  0 ,

   b_dtval10  numeric(16,2)  default  0 ,
   b_dtvaltax10  numeric(16,2)  default  0 ,
   e_dtval10  numeric(16,2)  default  0 ,
   e_dtvaltax10  numeric(16,2)  default  0 ,

   b_dtval11  numeric(16,2)  default  0 ,
   b_dtvaltax11  numeric(16,2)  default  0 ,
   e_dtval11  numeric(16,2)  default  0 ,
   e_dtvaltax11  numeric(16,2)  default  0 ,

   b_dtval12  numeric(16,2)  default  0 ,
   b_dtvaltax12  numeric(16,2)  default  0 ,
   e_dtval12  numeric(16,2)  default  0 ,
   e_dtvaltax12  numeric(16,2)  default  0 ,

   b_dtval13  numeric(16,2)  default  0 ,
   b_dtvaltax13  numeric(16,2)  default  0 ,
   e_dtval13  numeric(16,2)  default  0 ,
   e_dtvaltax13  numeric(16,2)  default  0 ,

   b_dtval14  numeric(16,2)  default  0 ,
   b_dtvaltax14  numeric(16,2)  default  0 ,
   e_dtval14  numeric(16,2)  default  0 ,
   e_dtvaltax14  numeric(16,2)  default  0 ,

   b_dtval15  numeric(16,2)  default  0 ,
   b_dtvaltax15  numeric(16,2)  default  0 ,
   e_dtval15  numeric(16,2)  default  0 ,
   e_dtvaltax15  numeric(16,2)  default  0 ,
   b_dtval16  numeric(16,2)  default  0 ,
   b_dtvaltax16  numeric(16,2)  default  0 ,
   e_dtval16  numeric(16,2)  default  0 ,
   e_dtvaltax16  numeric(16,2)  default  0 ,
   b_dtval17  numeric(16,2)  default  0 ,
   b_dtvaltax17  numeric(16,2)  default  0 ,
   e_dtval17  numeric(16,2)  default  0 ,
   e_dtvaltax17  numeric(16,2)  default  0 ,
   b_dtval18  numeric(16,2)  default  0 ,
   b_dtvaltax18  numeric(16,2)  default  0 ,
   e_dtval18  numeric(16,2)  default  0 ,
   e_dtvaltax18  numeric(16,2)  default  0 ,


  PRIMARY KEY  ( id )
); 


CREATE temp TABLE seb_spo_tmp (
    cod_r integer,
    roz varchar(10),
    roz1 integer,
    osob_r numeric(9,0),
    id_client integer,
    name varchar(255),
    name_sk varchar(50),
    adr varchar(200),
    cod_sp varchar(15),
    nom_dog varchar(20),
    d_dog date,
    period_r integer,
    mes_r integer,
    den_r integer,
    srok_opl integer,
    cod_gal integer,
    cod_m integer,
    cod_gr integer,
    penya integer,
    priz_zvit integer,
    priz_nar_penyi integer,
    potuz integer,
    telbuh varchar(55),
    prots_opl integer,
    avans1d integer,
    avans1pr integer,
    avans2d integer,
    avans2pr integer,
    avans3d integer,
    avans3pr integer,
    id_state integer,
    okpo_num varchar(14),
    licens_num varchar(14),
    tax_num varchar(14)

);


CREATE temp TABLE seb_udog_tmp (
    cod_r integer,
    osob_r numeric(9,0),
    id_client integer,
    umopl integer,
    add_dog varchar(20),
    add_dat1 date,
    add_dat2 date,
    start_period integer,
    end_period integer,
    perv_oplata integer,
    avar_day integer,
    avar_kvt integer,
    techn_day integer,
    techn_kvt integer,
    ecol_day integer,
    ecol_kvt integer,
    avans1d integer,
    avans1pr integer,
    avans2d integer,
    avans2pr integer,
    avans3d integer,
    avans3pr integer,
    kill_dniv integer,
    priz_arh integer,
    priz_zvit integer
);


CREATE temp TABLE seb_tar_tmp (
    kind_dep integer,
    mmgg      date,
    code numeric(9,0),
    id_client integer,
    reg_date date,
    id_grouptarif integer,
    id_tariff integer,
    id_classtarif integer,
    kvt bigint,
    val numeric
);

CREATE temp TABLE seb_abon_lost_tmp (
    kind_dep    integer,
    mmgg        date,
    losts       int,
    voltage     int,
    code        numeric(9,0),
    id_client   integer,
    id_fider    integer,
    fider       varchar(50),
    id_point    integer,
    point_name  varchar(50),
    num_eqp     varchar(50),
    demand      numeric(10,0),
    sum_demand  numeric(12,2),
    set_power     numeric(12,5),
    connect_power  numeric(12,5)
);

CREATE temp TABLE  seb_abon_limit_tmp 
 (   kind_dep      integer,
     mmgg          date, 
     reg_num       varchar (30),
     reg_date      date,
     idk_document  integer, 
     code          numeric(9,0),
     dt            date,
     id_area       integer,
     id_point      integer,
     month_limit   date,
     value_dem     numeric(15,5)
 );



create temp table act_taxkornums_tbl
(
  id_doc  int, 
  id_tax  int, 
  id_bill int,
  reg_num varchar(25),
  reg_date date,
  int_num int
);


  create temp table rep_tt_tmp (
  id_client int,
  id_point int,
  p_date date, 
  id_tt1 int,
  id_tt2 int,
  type_tt1 int,
  type_tt2 int,
  name varchar(80),
  demand_val numeric(12,2) );

  create temp table rep_prognoz5_tmp (
  id_section int,
  id_client int,
  code      numeric(9,0),
  name     varchar(100),
  dt_indicat int,
  tar numeric (10,5),
  sum_credit numeric (15,2),
  id_represent int,
  represent_name varchar(100),
  demand int,
  value_all numeric (15,2),
  dem int,
  val  numeric (15,2),
  pay_all numeric(15,2),
  pre_pay_day5 int,
  pre_pay_perc5  int,
  pre_pay_dem5   int,
  pre_pay_sum5   numeric(15,2),
  pay5           numeric(15,2),
  pre_pay_day10 int,
  pre_pay_perc10  int,
  pre_pay_dem10   int,
  pre_pay_sum10   numeric(15,2),
  pay10           numeric(15,2),
  pre_pay_day15 int,
  pre_pay_perc15  int,
  pre_pay_dem15   int,
  pre_pay_sum15   numeric(15,2),
  pay15           numeric(15,2),
  pre_pay_day20 int,
  pre_pay_perc20  int,
  pre_pay_dem20   int,
  pre_pay_sum20   numeric(15,2),
  pay20           numeric(15,2),
  pre_pay_day25 int,
  pre_pay_perc25  int,
  pre_pay_dem25   int,
  pre_pay_sum25   numeric(15,2),
  pay25           numeric(15,2),
  pre_pay_day30 int,
  pre_pay_perc30  int,
  pre_pay_dem30   int,
  pre_pay_sum30   numeric(15,2),
  pay30           numeric(15,2) 
);


create temp table tree_volt_tmp (
id_client int,
id_border int,
id_tree   int,
id_voltage int ,
primary key (id_client,id_tree)
);


create temp table bal_selfider_tmp (
     id_fider		int,
     selected		int  default 1,
     primary key (id_fider)
);


create temp table bal_selstation_tmp (
     id_st		int,
     selected		int  default 0,
     correct		int  default 1,
     primary key (id_st)
);


create temp table bal_midpoint_demand_tmp(

 id_midpoint int,
 id_client int,
 id_point  int,
 demand    int,
 id_grp    int,
 primary key (id_midpoint,id_point)

);

--  drop table seb_diftarif_tmp;
  create temp table seb_diftarif_tmp (
Cod_r	Int,
Mmgg	Date,
kind 	Int,
code 	Numeric(9,0),
id_point int,
Eqp_name	varchar(50),
Eqp_type	varchar(35),
Eqp_num	varchar(35),
Id_group	Int,
Name_group	varchar(10),
Class 	varchar(1),
id_tarif int,
Kvt0 	numeric(12,2),
Sum0 	numeric(12,2),
Kvt1 	numeric(12,2),
Kvt2 	numeric(12,2),
Kvt3 	numeric(12,2),
Tar0 	numeric(12,5),
Sum123	numeric(12,2),
Sum1 	numeric(12,2),
Sum2 	numeric(12,2),
Sum3	numeric(12,2)  );


create temp TABLE rep_meter_indic_hist_tmp (
    id_client        int,
    id_point         int,
    id_meter         int,
    num_eqp          character varying(25),
    kind_energy      int,
    type_eqp         int,
    work_type        int,
    work_name        varchar(50),
    id_doc           int, 
    id_position      int,
    reg_date         date, 
    value1           numeric(14,4), 
    value2           numeric(14,4), 
    value3           numeric(14,4), 
    zone1            int, 
    zone2            int, 
    zone3            int 
);	


CREATE temp TABLE rep_points_info_tmp
(
  id_client integer NOT NULL,
  id_point integer NOT NULL,
  id_area integer,
  voltage integer,
  is_town boolean,
  is_subabon integer,
  demand     int,
  dat_e  date,
  PRIMARY KEY (id_client, id_point)
) ;

CREATE temp TABLE rep_last_bill_tmp
(
  id_client integer NOT NULL,
  mmgg  date,
  PRIMARY KEY (id_client)
) ;

create temp table rep_point_tarif_tmp
( code_eqp int,
  id_tarif int,
  primary key(code_eqp)
);

create temp table rep_point_tarif_year_tmp
( id_doc int,
  id_billsum int,
  code_eqp int,
  id_tarif int,
  primary key(id_doc,id_billsum,code_eqp)
);

create temp table seb_meter_tmp 
( mmgg date,
  kod_res int,
  code numeric(9,0),
  name varchar(150),
  dt_zam date,
  name_eqp varchar (50),
  adress  varchar(100),
  num_old varchar(25),
  type_old varchar(50),
  energy varchar (25),
  zone varchar(20),
  coef_old int,
  value_old numeric(15,4),
  num_new varchar(50),
  type_new varchar(50),
  coef_new int,
  value_new numeric(15,4)
);

create temp table rep_fider_monitor_tmp (
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
primary key (id_fider,mmgg)
);

CREATE temp TABLE  seb_area_limit_tmp 
 (   kind_dep      integer,
     mmgg          date, 
     code          numeric(9),
     id_client     integer,
     id_area       integer,
     bill_kvt      integer default 0,
     id_limit      integer,
     value_limit   integer default 0,
     doc_limit     varchar (70),
     date_limit    date,
     d_kvt        integer default 0,
     name_area    varchar(50),
     adr_area     varchar(250)
 );

CREATE temp TABLE  seb_limit_tarif_tmp 
 (   kind_dep      integer,
     mmgg          date, 
     id_client     integer,
     value_limit   integer,
     tarif_value   numeric(10,4)
 );


create temp table rep_lighting_points_tmp
(
id_point int,
id_tarif int,
power numeric(12,2),
num_eqp varchar(25),
primary key (id_point)
);


create temp table bal_switch_errors_tmp
(
 id_sw int,
 id_fider int,
 id_st int,
 dt_on timestamp without time zone,
 dt_off timestamp without time zone,
 primary key (id_sw,id_fider,id_st)
);


CREATE temp TABLE rep_abons_connect_tmp
(
  id serial,
  id_client integer,
  id_point integer,
  id_ps10 integer,
  id_fider integer,
  id_ps35 integer  ,
 primary key (id)
) ;


create temp table rep_switch_area_tmp
(
 id_switch int,
 id_area int,
 PRIMARY KEY(id_switch,id_area)
);

create temp table seb_work_obl_tmp 
 (kod_res integer,
  dt date default now(),
  id_ps35 int,
  name_ps35 varchar(80),
  id_f10   int,
  name_f10  varchar(80),
  id_ps10  int,
  name_ps10 varchar(80),
  code numeric(9,0),
  id_point   integer ,
  name_eqp varchar(50),
  adr      varchar(200),
  work     varchar(50),
  dt_work   date,
  represent_name varchar(50),
  requirement_text varchar(250),
  requirement_date date, 
  fider_inspector varchar(50),
  comment       varchar(250)
); 


create temp table rep_limit_area_change_tbl
(
 id_doc int, 
 id_client int, 
 id_area int,
 reg_date date,
 reg_num varchar(50),
 month_limit date,
 name_area varchar(100),
 value_new numeric(14,4),
 value_old numeric(14,4),
 dt timestamp without time zone,
 primary key (id_doc,id_area,month_limit )
);


CREATE temp TABLE rep_calc_compens5_tbl
(
  id_client integer,
  id_rclient integer,
  abon_adr character varying,
  id_point integer,
  id_meter integer,
  id_zone integer,
  name_eqp character varying(50),
  num_meter character varying(30),
  power numeric(14,4),
  adr character varying,
  type_meter character varying(35),
  carry integer,
  amperage_nom integer,
  dt_control timestamp without time zone,
  phase character varying(20),
  kind character varying(20),
  link integer,
  k_ts numeric(14,4),
  wtml integer,
  calc_demand_nocnt integer,
  ktr_demand integer,
  p_w numeric(10,3),
  minus integer,
  ktr_demand_old integer,
  p_w_old numeric(10,3),
  calc_demand_nocnt_old integer,
  minus_old integer,
  volt_name character varying,
  tt_type character varying(35),
  tt_accuracy numeric(5,2),
  tt_control date,
  meter_accuracy character varying(10),
  grp_name character varying(50),
  is_owner integer
) ;

--SET client_min_messages TO WARNING; 
ret=add_ttbl();
ret=calc_tarif_end();

Return true;
end;
' Language 'plpgsql';


select crt_ttbl();

select * from seb_tar_tmp;
