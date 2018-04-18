;
set client_encoding = 'win';


CREATE or replace FUNCTION rep_4nkre2017_fun(date,int)
RETURNS int
AS                                                                                              
  '
  declare
   pmmgg Alias for $1;
   pfile Alias for $2;
   r record;
   rr record;
   pr boolean ;
   kodres  int;
   tabl text;
   del text;
   nul text;
   SQL text;
  begin

  raise notice ''4nkre 2017 start..'';

  select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

--  if pmmgg < fun_mmgg() then
--   return 0;
--  end if;

  delete from rep_4nkre2015_tbl where mmgg = pmmgg;
 
  insert into rep_4nkre2015_tbl (mmgg) select pmmgg;


   update rep_4nkre2015_tbl set 
   sum004=s04,dem004=d04, sum012=s12,dem012=d12, sum020=s20,dem020=d20,
   sum028=s28,dem028=d28, sum036=s36,dem036=d36, sum044=s44,dem044=d44,


   sum286 = s286+s302_old, dem286 = d286+d302_old,
   sum288 = s288+s308_old, dem288 = d288+d308_old,


   sum300=s300,dem300=d300, sum298=s298,dem298=d298


   --sum302=s302,dem302=d302, sum306=s306,dem306=d306,sum308=s308,dem308=d308,
--   sum312=s312,dem312=d312, sum314=s314,dem314=d314,

  -- sum286 = s300+s302+s312m+s314m, dem286 = d300+d302+d312m+d314m,
--   sum288 = s306+s308+s312s+s314s, dem288 = d306+d308+d312s+d314s

  from
  (select 
         coalesce(sum(CASE WHEN ident =''tgr1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d04,
         coalesce(sum(CASE WHEN ident =''tgr2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d12,
         coalesce(sum(CASE WHEN ident =''tgr6'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d20,
         coalesce(sum(CASE WHEN ident =''tgr3'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d28,
         coalesce(sum(CASE WHEN ident =''tgr4'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d36,
         coalesce(sum(CASE WHEN (ident =''tgr5'') or (ident = ''tgr8_62'') or (ident = ''tgr8_63'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d44,

	 coalesce(sum(CASE WHEN ident =''tgr1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s04,
         coalesce(sum(CASE WHEN ident =''tgr2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s12,
         coalesce(sum(CASE WHEN ident =''tgr6'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s20,
         coalesce(sum(CASE WHEN ident =''tgr3'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s28,
         coalesce(sum(CASE WHEN ident =''tgr4'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s36,
         coalesce(sum(CASE WHEN (ident =''tgr5'') or (ident = ''tgr8_62'') or (ident = ''tgr8_63'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s44,


         coalesce(sum(CASE WHEN ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'',''tgr8_4'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d300,
         coalesce(sum(CASE WHEN ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'',''tgr8_4'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s300,

         coalesce(sum(CASE WHEN ident in (''tgr8_10'',''tgr8_30'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d298,
         coalesce(sum(CASE WHEN ident in (''tgr8_10'',''tgr8_30'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s298,


         coalesce(sum(CASE WHEN coalesce(section,1009) in (1009,1017,1018,1019,1020,1021) and 
                       ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d286,

         coalesce(sum(CASE WHEN coalesce(section,1009) in (1009,1017,1018,1019,1020,1021) and 
                      ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s286,


         coalesce(sum(CASE WHEN coalesce(section,1009) =1010 and 
                       ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d288,

         coalesce(sum(CASE WHEN coalesce(section,1009) =1010 and 
                      ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s288,


         coalesce(sum(CASE WHEN ident = ''tgr8_12'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d302_old,
         coalesce(sum(CASE WHEN ident = ''tgr8_12'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s302_old,

         coalesce(sum(CASE WHEN ident = ''tgr8_22'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d308_old,
         coalesce(sum(CASE WHEN ident = ''tgr8_22'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s308_old


--         coalesce(sum(CASE WHEN ident = ''tgr8_32'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d314,
--         coalesce(sum(CASE WHEN ident = ''tgr8_32'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s314,

--         coalesce(sum(CASE WHEN ident = ''tgr8_30'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d312,
--         coalesce(sum(CASE WHEN ident = ''tgr8_30'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s312,

--         coalesce(sum(CASE WHEN coalesce(section,1009) in (1009,1017,1018,1019,1020,1021) and ident = ''tgr8_10'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d300,
--         coalesce(sum(CASE WHEN coalesce(section,1009) in (1009,1017,1018,1019,1020,1021) and ident = ''tgr8_10'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s300,

--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1010 and ident = ''tgr8_10'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d306,
--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1010 and ident = ''tgr8_10'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s306,


--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1009 and ident = ''tgr8_32'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d314m,
--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1009 and ident = ''tgr8_32'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s314m,

--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1009 and ident = ''tgr8_30'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d312m,
--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1009 and ident = ''tgr8_30'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s312m,


--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1010 and ident = ''tgr8_32'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d314s,
--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1010 and ident = ''tgr8_32'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s314s,

--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1010 and ident = ''tgr8_30'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d312s,
--         coalesce(sum(CASE WHEN coalesce(section,1009) = 1010 and ident = ''tgr8_30'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s312s


  from
  (select tgr.ident, ph.id_extra AS section,
--  sum(case when ( (ph.id_extra=1014 or ph.id_extra=1011) and (vv.voltage_min=0.4 or vv.voltage_min=10.0 ))  then 0 else  bs.demand_val end ) as demand_tcl1, 
--  round(sum( case when  ((ph.id_extra=1014 or ph.id_extra=1011) and (vv.voltage_min=0.4 or vv.voltage_min=10.0 )) then  0 else bs.sum_val end),2) as sum_tcl1 
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
--  left join cla_param_tbl as p on (p.id=ph.id_extra)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
 where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg=pmmgg 
  and tar.id not in (900001,999999) 
  and cl.idk_work <> 0 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by tgr.ident,ph.id_extra ) as s1
  ) as s11 
 where rep_4nkre2015_tbl.mmgg = pmmgg;

/*

raise notice ''tec'';

   update rep_4nkre2015_tbl set 
   sum004=sum004+s04,dem004=dem004+d04, sum012=sum012+s12,dem012=dem012+d12, sum020=sum020+s20,dem020=dem020+d20,
   sum028=sum028+s28,dem028=dem028+d28, sum036=sum036+s36,dem036=dem036+d36, sum044=sum044+s44,dem044=dem044+d44

  from
  (select 

         coalesce(sum(CASE WHEN ident =''tgr1'' and (section =1014 or section =1011)  THEN demand_tcl1 ELSE 0 END )/1000,0) as d17,
         coalesce(sum(CASE WHEN ident =''tgr2'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d32,
         coalesce(sum(CASE WHEN ident =''tgr6'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d47,
         coalesce(sum(CASE WHEN ident =''tgr3'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d62,
         coalesce(sum(CASE WHEN ident =''tgr4'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d77,
         coalesce(sum(CASE WHEN ident =''tgr5'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d92,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s17,
         coalesce(sum(CASE WHEN ident =''tgr2'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s32,
         coalesce(sum(CASE WHEN ident =''tgr6'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s47,
         coalesce(sum(CASE WHEN ident =''tgr3'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s62,
         coalesce(sum(CASE WHEN ident =''tgr4'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s77,
         coalesce(sum(CASE WHEN ident =''tgr5'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s92,


  from
  (select tgr.id as id_tgr, tgr.ident, p.id AS section, 
   sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 
  and bs.mmgg= pmmgg 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.id, tgr.ident, section ) as s1
  ) as s11
 where rep_4nkre2015_tbl.mmgg = pmmgg;

*/



 ---------------------------------------------------------------
raise notice ''update 2 kl '';

   update rep_4nkre2015_tbl set 

   sum054=s54,dem054=d54, sum060=s60,dem060=d60, sum066=s66,dem066=d66,
   sum072=s72,dem072=d72, sum078=s78,dem078=d78, sum084=s84,dem084=d84,

   sum494 = s286+s302_old, dem494 = d286+d302_old,
   sum496 = s288+s308_old, dem496 = d288+d308_old,
   sum506=s300,dem506=d300, sum504=s298,dem504=d298,


   sum352=s352,dem352=d352, sum354=s354,dem354=d354, -- sum356=s356,dem356=d356,

--   sum362=s362,dem362=d362, sum364=s364,dem364=d364, sum366=s366,dem366=d366, 
   sum384=s384,dem384=d384, sum385=s385,dem385=d385, 
-- sum386=s386,dem386=d386,

--   sum388=s388,dem388=d388, sum389=s389,dem389=d389, sum390=s390,dem390=d390,


   sum392=s392,dem392=d392, sum394=s394,dem394=d394, 

   sum402=s402,dem402=d402, sum403=s403,dem403=d403, 
--sum404=s404,dem404=d404,

--   sum406=s406,dem406=d406, sum407=s407,dem407=d407, sum408=s408,dem408=d408,


   sum410=s410,dem410=d410, sum412=s412,dem412=d412, sum414=s414,dem414=d414,


   sum340=s352+s354 +s384+s385+ s402+s403+ s391m +s409m+s414m,
   dem340=d352+d354 +d384+d385+ d402+d403+ d391m +d409m+d414m

--   sum342=s362+s364+s366 +s388+s389+s390 +s406+s407+s408 +s391s +s409s+s414s,
--   dem342=d362+d364+d366 +d388+d389+d390 +d406+d407+d408 +d391s +d409s+d414s

  from
  (select 
         coalesce(sum(CASE WHEN ident =''tgr1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d54,
         coalesce(sum(CASE WHEN ident =''tgr2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d60,
         coalesce(sum(CASE WHEN ident =''tgr6'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d66,
         coalesce(sum(CASE WHEN ident =''tgr3'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d72,
         coalesce(sum(CASE WHEN ident =''tgr4'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d78,
         coalesce(sum(CASE WHEN (ident =''tgr5'') or (ident = ''tgr8_62'') or (ident = ''tgr8_63'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d84,

	 coalesce(sum(CASE WHEN ident =''tgr1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s54,
         coalesce(sum(CASE WHEN ident =''tgr2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s60,
         coalesce(sum(CASE WHEN ident =''tgr6'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s66,
         coalesce(sum(CASE WHEN ident =''tgr3'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s72,
         coalesce(sum(CASE WHEN ident =''tgr4'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s78,
         coalesce(sum(CASE WHEN (ident =''tgr5'') or (ident = ''tgr8_62'') or (ident = ''tgr8_63'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s84,


---------------------

         coalesce(sum(CASE WHEN ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'',''tgr8_4'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d300,
         coalesce(sum(CASE WHEN ident in (''tgr8_12'',''tgr8_22'',''tgr8_32'',''tgr8_4'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s300,

         coalesce(sum(CASE WHEN ident in (''tgr8_10'',''tgr8_30'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d298,
         coalesce(sum(CASE WHEN ident in (''tgr8_10'',''tgr8_30'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s298,


         coalesce(sum(CASE WHEN coalesce(section,1009) in (1009,1017,1018,1019,1020,1021,1001) and 
                       ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d286,

         coalesce(sum(CASE WHEN coalesce(section,1009) in (1009,1017,1018,1019,1020,1021,1001) and 
                      ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s286,


         coalesce(sum(CASE WHEN coalesce(section,1009) =1010 and 
                       ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d288,

         coalesce(sum(CASE WHEN coalesce(section,1009) =1010 and 
                      ident in (''tgr8_32'',''tgr8_4'',''tgr8_10'',''tgr8_30'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s288,


         coalesce(sum(CASE WHEN ident = ''tgr8_12'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d302_old,
         coalesce(sum(CASE WHEN ident = ''tgr8_12'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s302_old,

         coalesce(sum(CASE WHEN ident = ''tgr8_22'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d308_old,
         coalesce(sum(CASE WHEN ident = ''tgr8_22'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s308_old,

---------------------

         coalesce(sum(CASE WHEN ident in (''tgr7_1'',''tgr7_11'',''tgr7_21'',''tgr7_211'',''tgr7_21'',''tgr7_211'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d352,
         coalesce(sum(CASE WHEN ident in (''tgr7_1'',''tgr7_11'',''tgr7_21'',''tgr7_211'',''tgr7_21'',''tgr7_211'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s352,

         coalesce(sum(CASE WHEN  (ident ~ ''tgr7_12'') or (ident ~ ''tgr7_22'') or (ident = ''tgr7_13'') or (ident = ''tgr7_23'') or (ident = ''tgr8_101'') or (ident = ''tgr8_61'')  THEN demand_tcl1 ELSE 0 END )/1000,0) as d354,
         coalesce(sum(CASE WHEN  (ident ~ ''tgr7_12'') or (ident ~ ''tgr7_22'') or (ident = ''tgr7_13'') or (ident = ''tgr7_23'') or (ident = ''tgr8_101'') or (ident = ''tgr8_61'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s354,

--         coalesce(sum(CASE WHEN ident = ''tgr7_121'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d356,
--         coalesce(sum(CASE WHEN ident = ''tgr7_121'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s356,

--
         coalesce(sum(CASE WHEN ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d414,
         coalesce(sum(CASE WHEN ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s414,


         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1007) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d414m,
         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1007) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s414m,


         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1008) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d414s,
         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1008) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s414s,

--

--         coalesce(sum(CASE WHEN ident = ''tgr7_21'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d362,
--         coalesce(sum(CASE WHEN ident = ''tgr7_21'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s362,

--         coalesce(sum(CASE WHEN ident = ''tgr7_22'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d364,
--         coalesce(sum(CASE WHEN ident = ''tgr7_22'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s364,

--         coalesce(sum(CASE WHEN ident = ''tgr7_221'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d366,
--         coalesce(sum(CASE WHEN ident = ''tgr7_221'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s366,


         coalesce(sum(CASE WHEN ident in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d384,
         coalesce(sum(CASE WHEN ident in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s384,

         coalesce(sum(CASE WHEN (ident ~ ''tgr7_51'') and ident not in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d385,
         coalesce(sum(CASE WHEN (ident ~ ''tgr7_51'') and ident not in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s385,

--         coalesce(sum(CASE WHEN ident = ''tgr7_513'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d386,
--         coalesce(sum(CASE WHEN ident = ''tgr7_513'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s386,

--//

--         coalesce(sum(CASE WHEN ident = ''tgr7_514'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d388,
--         coalesce(sum(CASE WHEN ident = ''tgr7_514'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s388,

--         coalesce(sum(CASE WHEN ident = ''tgr7_515'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d389,
--         coalesce(sum(CASE WHEN ident = ''tgr7_515'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s389,

--         coalesce(sum(CASE WHEN ident = ''tgr7_516'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d390,
--         coalesce(sum(CASE WHEN ident = ''tgr7_516'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s390,

--//


         coalesce(sum(CASE WHEN ident ~ ''tgr7_521'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d392,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_521'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s392,

         coalesce(sum(CASE WHEN ident ~ ''tgr7_522'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d394,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_522'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s394,



         coalesce(sum(CASE WHEN ident in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d402,
         coalesce(sum(CASE WHEN ident in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s402,

         coalesce(sum(CASE WHEN (ident ~ ''tgr7_61'') and ident not in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d403,
         coalesce(sum(CASE WHEN (ident ~ ''tgr7_61'') and ident not in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s403,

--         coalesce(sum(CASE WHEN ident = ''tgr7_613'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d404,
--         coalesce(sum(CASE WHEN ident = ''tgr7_613'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s404,


--**
--         coalesce(sum(CASE WHEN ident = ''tgr7_614'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d406,
--         coalesce(sum(CASE WHEN ident = ''tgr7_614'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s406,

--         coalesce(sum(CASE WHEN ident = ''tgr7_615'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d407,
--         coalesce(sum(CASE WHEN ident = ''tgr7_615'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s407,

--         coalesce(sum(CASE WHEN ident = ''tgr7_616'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d408,
--         coalesce(sum(CASE WHEN ident = ''tgr7_616'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s408,

--**

         coalesce(sum(CASE WHEN ident ~ ''tgr7_621'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d410,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_621'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s410,

         coalesce(sum(CASE WHEN ident ~ ''tgr7_622'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d412,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_622'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s412,



         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1007) and (ident ~ ''tgr7_52'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d391m,
         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1007) and (ident ~ ''tgr7_52'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s391m,


         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1008) and (ident ~ ''tgr7_52'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d391s,
         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1008) and (ident ~ ''tgr7_52'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s391s,


         coalesce(sum(CASE WHEN coalesce(section,1015) in (1015,1007) and (ident ~ ''tgr7_62'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d409m,
         coalesce(sum(CASE WHEN coalesce(section,1015) in (1015,1007) and (ident ~ ''tgr7_62'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s409m,

         coalesce(sum(CASE WHEN coalesce(section,1015) in (1016,1008) and (ident ~ ''tgr7_62'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d409s,
         coalesce(sum(CASE WHEN coalesce(section,1015) in (1016,1008) and (ident ~ ''tgr7_62'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s409s



  from
  (select tgr.ident, ph.id_extra AS section,
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
--  join eqk_voltage_tbl as vv on (vv.id=coalesce(ph.id_voltage,4)) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg= pmmgg 
  and cl.idk_work <> 0 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by tgr.ident,ph.id_extra ) as s1
  ) as s11
 where rep_4nkre2015_tbl.mmgg = pmmgg;



-----------------------------------------------------------------------------------------------
  -- по населению дополнительно по счетам без точек учета
raise notice ''update naselen nopoint'';

  update rep_4nkre2015_tbl set 

   sum352=sum352+s352,dem352=dem352+d352, sum354=sum354+s354,dem354=dem354+d354, -- sum356=sum356+s356,dem356=dem356+d356,

--   sum362=sum362+s362,dem362=dem362+d362, 
--sum364=sum364+s364,dem364=dem364+d364, sum366=sum366+s366,dem366=dem366+d366, 

   sum384=sum384+s384,dem384=dem384+d384, sum385=sum385+s385,dem385=dem385+d385, 
--sum386=sum386+s386,dem386=dem386+d386,

--   sum388=sum388+s388,dem388=dem388+d388, sum389=sum389+s389,dem389=dem389+d389, sum390=sum390+s390,dem390=dem390+d390,

   sum392=sum392+s392,dem392=dem392+d392, sum394=sum394+s394,dem394=dem394+d394,

   sum402=sum402+s402,dem402=dem402+d402, sum403=sum403+s403,dem403=dem403+d403, 
--sum404=sum404+s404,dem404=dem404+d404,

--   sum406=sum406+s406,dem406=dem406+d406, sum407=sum407+s407,dem407=dem407+d407, sum408=sum408+s408,dem408=dem408+d408,

   sum410=sum410+s410,dem410=dem410+d410, sum412=sum412+s412,dem412=dem412+d412,
   sum414=sum414+s414,dem414=dem414+d414,

   sum340=sum340+ s352+s354 +s384+s385+ s402+s403+ s392+ s394 +s410+s412+s414,
   dem340=dem340+ d352+d354 +d384+d385+ d402+d403+ d392+ d394 +d410+d412+d414
--   sum342=sum342+ s362+s364+s366 +s388+s389+s390 +s406+s407+s408 ,
--   dem342=dem342+ d362+d364+d366 +d388+d389+d390 +d406+d407+d408 


  from
  (
  select 

         coalesce(sum(CASE WHEN ident in (''tgr7_1'',''tgr7_11'',''tgr7_21'',''tgr7_211'',''tgr7_21'',''tgr7_211'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d352,
         coalesce(sum(CASE WHEN ident in (''tgr7_1'',''tgr7_11'',''tgr7_21'',''tgr7_211'',''tgr7_21'',''tgr7_211'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s352,

         coalesce(sum(CASE WHEN  (ident ~ ''tgr7_12'') or (ident ~ ''tgr7_22'') or (ident = ''tgr7_13'') or (ident = ''tgr7_23'') or (ident = ''tgr8_101'') or (ident = ''tgr8_61'')  THEN demand_tcl1 ELSE 0 END )/1000,0) as d354,
         coalesce(sum(CASE WHEN  (ident ~ ''tgr7_12'') or (ident ~ ''tgr7_22'') or (ident = ''tgr7_13'') or (ident = ''tgr7_23'') or (ident = ''tgr8_101'') or (ident = ''tgr8_61'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s354,

--         coalesce(sum(CASE WHEN ident = ''tgr7_121'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d356,
--         coalesce(sum(CASE WHEN ident = ''tgr7_121'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s356,

--
         coalesce(sum(CASE WHEN ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d414,
         coalesce(sum(CASE WHEN ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s414,


--         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1007) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d414m,
--         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1007) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s414m,


--         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1008) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d414s,
--         coalesce(sum(CASE WHEN (coalesce(section,1007) = 1008) and ident in ( ''tgr7_15'',''tgr7_25'',''tgr7_35'',''tgr7_53'',''tgr7_63'',''tgr7_7'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s414s,

--

--         coalesce(sum(CASE WHEN ident = ''tgr7_21'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d362,
--         coalesce(sum(CASE WHEN ident = ''tgr7_21'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s362,

--         coalesce(sum(CASE WHEN ident = ''tgr7_22'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d364,
--         coalesce(sum(CASE WHEN ident = ''tgr7_22'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s364,

--         coalesce(sum(CASE WHEN ident = ''tgr7_221'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d366,
--         coalesce(sum(CASE WHEN ident = ''tgr7_221'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s366,


         coalesce(sum(CASE WHEN ident in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d384,
         coalesce(sum(CASE WHEN ident in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s384,

         coalesce(sum(CASE WHEN (ident ~ ''tgr7_51'') and ident not in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d385,
         coalesce(sum(CASE WHEN (ident ~ ''tgr7_51'') and ident not in (''tgr7_511'',''tgr7_514'',''tgr7_5141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s385,

--         coalesce(sum(CASE WHEN ident = ''tgr7_513'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d386,
--         coalesce(sum(CASE WHEN ident = ''tgr7_513'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s386,

--//

--         coalesce(sum(CASE WHEN ident = ''tgr7_514'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d388,
--         coalesce(sum(CASE WHEN ident = ''tgr7_514'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s388,

--         coalesce(sum(CASE WHEN ident = ''tgr7_515'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d389,
--         coalesce(sum(CASE WHEN ident = ''tgr7_515'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s389,

--         coalesce(sum(CASE WHEN ident = ''tgr7_516'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d390,
--         coalesce(sum(CASE WHEN ident = ''tgr7_516'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s390,

--//

         coalesce(sum(CASE WHEN ident ~ ''tgr7_521'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d392,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_521'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s392,

         coalesce(sum(CASE WHEN ident ~ ''tgr7_522'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d394,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_522'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s394,



         coalesce(sum(CASE WHEN ident in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d402,
         coalesce(sum(CASE WHEN ident in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s402,

         coalesce(sum(CASE WHEN (ident ~ ''tgr7_61'') and ident not in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d403,
         coalesce(sum(CASE WHEN (ident ~ ''tgr7_61'') and ident not in (''tgr7_611'',''tgr7_614'',''tgr7_6141'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s403,

--         coalesce(sum(CASE WHEN ident = ''tgr7_613'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d404,
--         coalesce(sum(CASE WHEN ident = ''tgr7_613'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s404,


--**
--         coalesce(sum(CASE WHEN ident = ''tgr7_614'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d406,
--         coalesce(sum(CASE WHEN ident = ''tgr7_614'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s406,

--         coalesce(sum(CASE WHEN ident = ''tgr7_615'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d407,
--         coalesce(sum(CASE WHEN ident = ''tgr7_615'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s407,

--         coalesce(sum(CASE WHEN ident = ''tgr7_616'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d408,
--         coalesce(sum(CASE WHEN ident = ''tgr7_616'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s408,

--**

         coalesce(sum(CASE WHEN ident ~ ''tgr7_621'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d410,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_621'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s410,

         coalesce(sum(CASE WHEN ident ~ ''tgr7_622'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d412,
         coalesce(sum(CASE WHEN ident ~ ''tgr7_622'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s412

  from
  (select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and coalesce(bs.id_point,0) =0
  and cl.idk_work <> 0 
  group by tgr.ident ) as s1
  ) as s11
 where rep_4nkre2015_tbl.mmgg = pmmgg;
--------------------------------------------------------------------------------------------------

 raise notice ''update groups 2 class'';

  update rep_4nkre2015_tbl set 
   sum628=s628,dem628=d628, sum622=s622,dem622=d622, sum616=s616,dem616=d616

  from
  (select 
   coalesce(sum(CASE WHEN section =203 THEN demand_tcl1 ELSE 0 END )/1000,0) as d628, --ЖКХ
   coalesce(sum(CASE WHEN section =203 THEN sum_tcl1 ELSE 0 END )/1000,0) as s628,

   coalesce(sum(CASE WHEN section =212 THEN demand_tcl1 ELSE 0 END )/1000,0) as d622,  --местный бюджет
   coalesce(sum(CASE WHEN section =212 THEN sum_tcl1 ELSE 0 END )/1000,0) as s622,

   coalesce(sum(CASE WHEN section =211 THEN demand_tcl1 ELSE 0 END )/1000,0) as d616,  --гос бюджет
   coalesce(sum(CASE WHEN section =211 THEN sum_tcl1 ELSE 0 END )/1000,0) as s616

   from 
  ( select CASE WHEN p.lev=4 THEN p.id_parent  ELSE p.id END AS section , 
   sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join cla_param_tbl as p on (stcl.id_section=p.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
--  join eqk_voltage_tbl as vv on (vv.id=coalesce(ph.id_voltage,4)) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg= pmmgg 
  and  p.id in (211,213,214,215,203)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by section 
 ) as tcl1 ) as s22
 where rep_4nkre2015_tbl.mmgg = pmmgg;


 raise notice ''update groups 1 class'';

  update rep_4nkre2015_tbl set 
   sum626=s626,dem626=d626, sum620=s620,dem620=d620, sum614=s614,dem614=d614
  from
  (select 
   coalesce(sum(CASE WHEN section =203 THEN demand_tcl1 ELSE 0 END )/1000,0) as d626, --ЖКХ
   coalesce(sum(CASE WHEN section =203 THEN sum_tcl1 ELSE 0 END )/1000,0) as s626,

   coalesce(sum(CASE WHEN section =212 THEN demand_tcl1 ELSE 0 END )/1000,0) as d620,  --местный бюджет
   coalesce(sum(CASE WHEN section =212 THEN sum_tcl1 ELSE 0 END )/1000,0) as s620,

   coalesce(sum(CASE WHEN section =211 THEN demand_tcl1 ELSE 0 END )/1000,0) as d614,  --гос бюджет
   coalesce(sum(CASE WHEN section =211 THEN sum_tcl1 ELSE 0 END )/1000,0) as s614

   from 
  ( select CASE WHEN p.lev=4 THEN p.id_parent  ELSE p.id END AS section , 
   sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join cla_param_tbl as p on (stcl.id_section=p.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
--  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg= pmmgg 
  and p.id in (211,213,214,215,203)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by section
 ) as tcl1 ) as s22
 where rep_4nkre2015_tbl.mmgg = pmmgg;


 --собственные нужды
raise notice ''hoznuj'';

  --if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 578)=0 then 
  
    update rep_4nkre2015_tbl set sum604=s604,dem604=d604, sum606=s606,dem606=d606

    from
    (select 

       coalesce(sum(CASE WHEN voltage>10 THEN demand_tcl1 ELSE 0 END )/1000,0) as d604,
       coalesce(sum(CASE WHEN voltage<=10  THEN demand_tcl1 ELSE 0 END )/1000,0) as d606,

       coalesce(sum(CASE WHEN voltage>10 THEN sum_tcl1 ELSE 0 END )/1000,0) as s604,
       coalesce(sum(CASE WHEN voltage<=10 THEN sum_tcl1 ELSE 0 END )/1000,0) as s606
  
    from
    (select vv.voltage_min as voltage, 
    sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
    from acd_billsum_tbl as bs 
    join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
    join clm_client_tbl as cl on (cl.id = b.id_client) 
    join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
    join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
    where b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
    and bs.mmgg= pmmgg 
    and tar.id = 900002 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
    group by vv.voltage_min ) as s1
    ) as s11
   where rep_4nkre2015_tbl.mmgg = pmmgg;

  --end if;

  raise notice ''lighting'';
 --освещение
--  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 781)=0 then 
/*
    update rep_4nkre2015_tbl set sum656=s656,dem656=d656, sum658=s658,dem658=d658,
    sum652=0,dem652=0, sum654=0,dem654=0

    from
   (select 
     sum(sss.sum_n)/1000 as s658, 
     sum(sss.demand_n)/1000 as d658, 
     sum(sss.demand_n+coalesce(sss2.demand_d,0))/1000 as d656, 
     sum(sss.sum_n+coalesce(sss2.sum_d,0))/1000 as s656
   from 
   (select b.id_client, mkz.num_eqp::varchar, sum(bs.demand_val) as demand_n, sum(bs.sum_val) as sum_n 
   from acm_bill_tbl as b join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
   join clm_client_tbl as clm on (clm.id=b.id_client) 
   join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
   left join (select id_point,id_doc,  
  	     trim(regexp_replace(trim(max(num_eqp)),''(О|Д)$'',''''))::varchar as num_eqp 
             from acd_met_kndzn_tbl where id_zone = 0 and kind_energy=1 and mmgg = pmmgg  group by id_point,id_doc order by  id_point,id_doc) as mkz 
             on (bs.id_point = mkz.id_point and b.id_doc = mkz.id_doc ) 
   where bs.id_tariff = 51 and bs.id_zone = 0 and b.id_pref in (10,101)  and (b.idk_doc <> 280) 
   and b.mmgg = pmmgg and clm.book = -1 
   group by b.id_client, mkz.num_eqp order by b.id_client, mkz.num_eqp) as sss 
   left join 
   (select b.id_client, mkz.num_eqp::varchar, sum(bs.demand_val) as demand_d, sum(bs.sum_val) as sum_d 
   from acm_bill_tbl as b join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
   join clm_client_tbl as clm on (clm.id=b.id_client) 
   join (select id_point,id_doc,
         trim(regexp_replace(trim(max(num_eqp)),''(О|Д)$'',''''))::varchar as num_eqp 
         from acd_met_kndzn_tbl where id_zone = 0 and kind_energy=1 and mmgg = pmmgg group by id_point,id_doc order by  id_point,id_doc) as mkz 
         on (bs.id_point = mkz.id_point and b.id_doc = mkz.id_doc ) 
   where bs.id_tariff <> 51 and bs.id_zone = 0 and b.id_pref in (10,101)  and (b.idk_doc <> 280) 
   and b.mmgg = pmmgg and clm.book = -1 
   group by b.id_client, mkz.num_eqp order by b.id_client, mkz.num_eqp) as sss2 on (sss.id_client = sss2.id_client and sss.num_eqp = sss2.num_eqp) 
   ) as light
  where rep_4nkre2015_tbl.mmgg = pmmgg;
*/
--  end if;

    update rep_4nkre2015_tbl set sum656=s656,dem656=d656, sum658=s658,dem658=d658,
    sum652=0,dem652=0, sum654=0,dem654=0

    from
   (select 
     sum(sss.sum_n)/1000 as s658, 
     sum(sss.demand_n)/1000 as d658, 
     sum(sss.demand_n+coalesce(sss2.demand_d,0))/1000 as d656, 
     sum(sss.sum_n+coalesce(sss2.sum_d,0))/1000 as s656
   from 
   (select b.id_client, trim(regexp_replace(trim(eq.num_eqp),''(н|д)$'',''''))::varchar as num_eqp, sum(bs.demand_val) as demand_n, sum(bs.sum_val) as sum_n 
   from acm_bill_tbl as b 
   join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
   join clm_client_tbl as clm on (clm.id=b.id_client) 
   join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 

   left join eqm_meter_point_h as mp on (mp.id_point = bs.id_point and mp.dt_b <= bs.dt_begin and ( mp.dt_e is null or mp.dt_e > bs.dt_begin ) ) 
   left join eqm_equipment_h as eq on (eq.id = mp.id_meter and eq.dt_b <= bs.dt_begin and ( eq.dt_e is null or eq.dt_e > bs.dt_begin ) ) 

   where bs.id_tariff = 51 and bs.id_zone = 0 and b.id_pref in (10,101)  and (b.idk_doc <> 280) 
   and b.mmgg = pmmgg and clm.book = -1 
   group by b.id_client, trim(regexp_replace(trim(eq.num_eqp),''(н|д)$'',''''))::varchar order by b.id_client, num_eqp) as sss 
   left join 
   (select b.id_client, trim(regexp_replace(trim(eq.num_eqp),''(н|д)$'',''''))::varchar as num_eqp, sum(bs.demand_val) as demand_d, sum(bs.sum_val) as sum_d 
   from acm_bill_tbl as b 
   join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
   join clm_client_tbl as clm on (clm.id=b.id_client) 
   left join eqm_meter_point_h as mp on (mp.id_point = bs.id_point and mp.dt_b <= bs.dt_begin and ( mp.dt_e is null or mp.dt_e > bs.dt_begin ) ) 
   left join eqm_equipment_h as eq on (eq.id = mp.id_meter and eq.dt_b <= bs.dt_begin and ( eq.dt_e is null or eq.dt_e > bs.dt_begin ) ) 
   where bs.id_tariff <> 51 and bs.id_zone = 0 and b.id_pref in (10,101)  and (b.idk_doc <> 280) 
   and b.mmgg = pmmgg and clm.book = -1 
   group by b.id_client, trim(regexp_replace(trim(eq.num_eqp),''(н|д)$'',''''))::varchar  order by b.id_client, num_eqp) as sss2 on (sss.id_client = sss2.id_client and sss.num_eqp = sss2.num_eqp) 
   ) as light
  where rep_4nkre2015_tbl.mmgg = pmmgg;


raise notice ''religia '';
 --религиозные организации
--  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 700)=0 then 

  update rep_4nkre2015_tbl set sum632=s632,dem632=d632, sum634=s634,dem634=d634
   from
  (select 
   coalesce(sum(CASE WHEN ident=''tcl1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d632,
   coalesce(sum(CASE WHEN ident=''tcl2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d634,
   coalesce(sum(CASE WHEN ident=''tcl1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s632,
   coalesce(sum(CASE WHEN ident=''tcl2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s634
   from 
  ( select p.id AS section , tcl.ident ,
    sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and p.id =1003
  and bs.mmgg= pmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by section, tcl.ident 
 ) as tcl1 ) as s22
  where rep_4nkre2015_tbl.mmgg = pmmgg;

--  end if;

raise notice ''turmi '';

 -- Заклади пен?тенц?арної системи   
--  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 730)=0 then 

  update rep_4nkre2015_tbl set sum638=s638,dem638=d638, sum640=s640,dem640=d640,
                           sum644=s644,dem644=d644, sum648=s648,dem648=d648
   from
  (select 

   coalesce(sum(CASE WHEN ident=''tcl1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d638,
   coalesce(sum(CASE WHEN ident=''tcl2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d640,
   coalesce(sum(CASE WHEN ident=''tcl1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s638,
   coalesce(sum(CASE WHEN ident=''tcl2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s640,

   coalesce(sum(CASE WHEN section <> 1002 and ident=''tcl1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d644,
   coalesce(sum(CASE WHEN section <> 1002 and ident=''tcl2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d648,
   coalesce(sum(CASE WHEN section <> 1002 and ident=''tcl1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s644,
   coalesce(sum(CASE WHEN section <> 1002 and ident=''tcl2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s648

   from 
  ( select p.id AS section , tcl.ident ,
    sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
--  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and  p.id in (1001,1002,1012,1013)
  and bs.mmgg= pmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by section, tcl.ident  
 ) as tcl1 ) as s22
  where rep_4nkre2015_tbl.mmgg = pmmgg;


--  end if;

raise notice ''tech purposes'';
  -- на тех.цели   
--  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 784)=0 then 

  update rep_4nkre2015_tbl set 

    --sum662=s662,dem662=d662, sum664=s664,dem664=d664,
    sum660=s662+s664,dem660=d662+d664,

    sum666=s666,dem666=d666
   from
  (select 
   coalesce(sum(CASE WHEN ident = ''tgr7_13''  THEN demand_tcl1 ELSE 0 END )/1000,0) as d662,
   coalesce(sum(CASE WHEN ident = ''tgr7_23''  THEN demand_tcl1 ELSE 0 END )/1000,0) as d664,
   coalesce(sum(CASE WHEN ident = ''tgr8_101'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d666,

   coalesce(sum(CASE WHEN ident = ''tgr7_13''  THEN sum_tcl1 ELSE 0 END )/1000,0) as s662,
   coalesce(sum(CASE WHEN ident = ''tgr7_23''  THEN sum_tcl1 ELSE 0 END )/1000,0) as s664,
   coalesce(sum(CASE WHEN ident = ''tgr8_101'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s666

   from 
  ( select tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
--  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
--  join cla_param_tbl as p on (p.id=ph.id_extra) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  where b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and tgr.ident  in (''tgr7_13'',''tgr7_23'',''tgr8_101'')
--  and p.id  = 1005
  and bs.mmgg= pmmgg 
--  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.ident 
 ) as tcl2 ) as s22
  where rep_4nkre2015_tbl.mmgg = pmmgg;

--  end if;
/*

 -- ТВЕ/Тяга
  raise notice ''taga'';
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 564)=0 then 

  update rep_4nkre2015_tbl set  sum564=s564,dem564=d564
  from
  (select 
         coalesce(sum(demand_tcl1)/1000,0) as d564,
         coalesce(sum(sum_tcl1)/1000,0) as s564
  from
  (select sum(bs.demand_val) as demand_tcl1, 0 as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  where b.id_pref in (10,101)  and cl.book = -1 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and stcl.id_section = 217
  ) as s1
  ) as s11
  where rep_4nkre2015_tbl.mmgg = pmmgg;

  end if;
*/

raise notice ''transit'';

--Транзит
--  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 554)=0 then 

  update rep_4nkre2015_tbl set  sum574=s574,dem574=d574
  from
  (select 
         coalesce(sum(demand_tcl1)/1000,0) as d574,
         coalesce(sum(sum_tcl1)/1000,0) as s574
  from
  (select sum(bs.demand_val) as demand_tcl1, 0 as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and stcl.id_section = 209
  ) as s1
  ) as s11
  where rep_4nkre2015_tbl.mmgg = pmmgg;



  update rep_4nkre2015_tbl set  sum582=s582,dem582=d582
  from
  (select 
         coalesce(sum(demand_tcl1)/1000,0) as d582,
         coalesce(sum(sum_tcl1)/1000,0) as s582
  from
  (select sum(bs.demand_val) as demand_tcl1, 0 as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  where tcl.ident=''tcl2'' and b.id_pref in (10,101)  and cl.book = -1 and (b.idk_doc <> 280) 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and stcl.id_section = 209
  ) as s1
  ) as s11
  where rep_4nkre2015_tbl.mmgg = pmmgg;

--  end if;

/*
raise notice ''tec'';
 -- С шин ТЕЦ (Чернмгов МЕМ)  и З шин ПС ЕЕС (Нежин)
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 17)=0 then 

  update rep_4nkre2015_tbl set 
   sum017=s17,dem017=d17, sum032=s32,dem032=d32, sum047=s47,dem047=d47,sum062=s62,dem062=d62,sum077=s77,dem077=d77,
   sum092=s92,dem092=d92, sum325=s325,dem325=d325
  from
  (select 

         coalesce(sum(CASE WHEN ident =''tgr1'' and (section =1014 or section =1011)  THEN demand_tcl1 ELSE 0 END )/1000,0) as d17,
         coalesce(sum(CASE WHEN ident =''tgr2'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d32,
         coalesce(sum(CASE WHEN ident =''tgr6'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d47,
         coalesce(sum(CASE WHEN ident =''tgr3'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d62,
         coalesce(sum(CASE WHEN ident =''tgr4'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d77,
         coalesce(sum(CASE WHEN ident =''tgr5'' and (section =1014 or section =1011) THEN demand_tcl1 ELSE 0 END )/1000,0) as d92,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s17,
         coalesce(sum(CASE WHEN ident =''tgr2'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s32,
         coalesce(sum(CASE WHEN ident =''tgr6'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s47,
         coalesce(sum(CASE WHEN ident =''tgr3'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s62,
         coalesce(sum(CASE WHEN ident =''tgr4'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s77,
         coalesce(sum(CASE WHEN ident =''tgr5'' and (section =1014 or section =1011) THEN sum_tcl1 ELSE 0 END )/1000,0) as s92,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (section =1014 or section =1011)  THEN demand_tcl1 ELSE 0 END )/1000,0) as d325,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (section =1014 or section =1011)  THEN sum_tcl1 ELSE 0 END )/1000,0) as s325


  from
  (select tgr.id as id_tgr, tgr.ident, p.id AS section, 
   sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where tcl.ident=''tcl1'' and b.id_pref in (10,101)  and cl.book = -1 
  and bs.mmgg= pmmgg 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.id, tgr.ident, section ) as s1
  ) as s11;


  end if;
*/


-- if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 670)=1 then 
-- update rep_4nkre2015_tbl set sum670=summa,dem670=demand from sebd_nkre4 where code_nkre4=670 and sebd_nkre4.mmgg=pmmgg;
--end if;
 -----------------------------------------------------------------------------------------

 if (pfile = 1) then

  CREATE temp TABLE rep_4nkre2012_tmp AS select * from rep_4nkre2015_tbl where mmgg = pmmgg;

  tabl=''/home/local/seb/''||kodres||''NKRE4.TXT'';
  del=''@''; nul='''';
  SQL=''copy  rep_4nkre2012_tmp  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

  raise notice ''%'',SQL;

  Execute SQL;
 end if;


return 1;
end'
language 'plpgsql';

