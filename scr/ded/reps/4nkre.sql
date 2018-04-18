;
set client_encoding = 'win';


--drop table rep_4nkre_tbl;

create table rep_4nkre_tbl (
id_department int default getsysvar('kod_res'),
mmgg date,
sum010 numeric(12,5), dem010 numeric(12,3), 
sum015 numeric(12,5), dem015 numeric(12,3), 
sum017 numeric(12,5), dem017 numeric(12,3), 
sum025 numeric(12,5), dem025 numeric(12,3), 
sum030 numeric(12,5), dem030 numeric(12,3), 
sum032 numeric(12,5), dem032 numeric(12,3), 
sum040 numeric(12,5), dem040 numeric(12,3), 
sum045 numeric(12,5), dem045 numeric(12,3), 
sum047 numeric(12,5), dem047 numeric(12,3), 
sum055 numeric(12,5), dem055 numeric(12,3), 
sum060 numeric(12,5), dem060 numeric(12,3), 
sum062 numeric(12,5), dem062 numeric(12,3), 
sum070 numeric(12,5), dem070 numeric(12,3), 
sum075 numeric(12,5), dem075 numeric(12,3), 
sum077 numeric(12,5), dem077 numeric(12,3), 
sum085 numeric(12,5), dem085 numeric(12,3), 
sum090 numeric(12,5), dem090 numeric(12,3), 
sum092 numeric(12,5), dem092 numeric(12,3), 
sum110 numeric(12,5), dem110 numeric(12,3), 
sum115 numeric(12,5), dem115 numeric(12,3), 
sum125 numeric(12,5), dem125 numeric(12,3), 
sum130 numeric(12,5), dem130 numeric(12,3), 
sum140 numeric(12,5), dem140 numeric(12,3), 
sum145 numeric(12,5), dem145 numeric(12,3), 
sum155 numeric(12,5), dem155 numeric(12,3), 
sum160 numeric(12,5), dem160 numeric(12,3), 
sum170 numeric(12,5), dem170 numeric(12,3), 
sum175 numeric(12,5), dem175 numeric(12,3), 
sum185 numeric(12,5), dem185 numeric(12,3), 
sum190 numeric(12,5), dem190 numeric(12,3), 
sum315 numeric(12,5), dem315 numeric(12,3), 
sum320 numeric(12,5), dem320 numeric(12,3), 
sum325 numeric(12,5), dem325 numeric(12,3), 
sum335 numeric(12,5), dem335 numeric(12,3), 
 sum336 numeric(12,5), dem336 numeric(12,3), 
sum340 numeric(12,5), dem340 numeric(12,3), 
 sum341 numeric(12,5), dem341 numeric(12,3), 
sum346 numeric(12,5), dem346 numeric(12,3), 
sum347 numeric(12,5), dem347 numeric(12,3), 
 sum348 numeric(12,5), dem348 numeric(12,3), 
 sum349 numeric(12,5), dem349 numeric(12,3), 
sum405 numeric(12,5), dem405 numeric(12,3), 
sum410 numeric(12,5), dem410 numeric(12,3), 
sum420 numeric(12,5), dem420 numeric(12,3), 
 sum421 numeric(12,5), dem421 numeric(12,3), 
 sum422 numeric(12,5), dem422 numeric(12,3), 
 sum423 numeric(12,5), dem423 numeric(12,3), 
sum425 numeric(12,5), dem425 numeric(12,3), 
 sum446 numeric(12,5), dem446 numeric(12,3), 
 sum447 numeric(12,5), dem447 numeric(12,3), 
 sum448 numeric(12,5), dem448 numeric(12,3), 
sum431 numeric(12,5), dem431 numeric(12,3), 
sum432 numeric(12,5), dem432 numeric(12,3), 
 sum433 numeric(12,5), dem433 numeric(12,3), 
 sum434 numeric(12,5), dem434 numeric(12,3), 
 sum435 numeric(12,5), dem435 numeric(12,3), 
 sum436 numeric(12,5), dem436 numeric(12,3), 
 sum437 numeric(12,5), dem437 numeric(12,3), 
 sum438 numeric(12,5), dem438 numeric(12,3), 
sum460 numeric(12,5), dem460 numeric(12,3), 
sum465 numeric(12,5), dem465 numeric(12,3), 
sum480 numeric(12,5), dem480 numeric(12,3), 
 sum481 numeric(12,5), dem481 numeric(12,3), 
sum485 numeric(12,5), dem485 numeric(12,3), 
 sum486 numeric(12,5), dem486 numeric(12,3), 
sum491 numeric(12,5), dem491 numeric(12,3), 
sum492 numeric(12,5), dem492 numeric(12,3), 
 sum493 numeric(12,5), dem493 numeric(12,3), 
 sum494 numeric(12,5), dem494 numeric(12,3), 
sum554 numeric(12,5), dem554 numeric(12,3), 
sum555 numeric(12,5), dem555 numeric(12,3), 
sum556 numeric(12,5), dem556 numeric(12,3), 
sum558 numeric(12,5), dem558 numeric(12,3), 
sum559 numeric(12,5), dem559 numeric(12,3), 
sum563 numeric(12,5), dem563 numeric(12,3), 
sum564 numeric(12,5), dem564 numeric(12,3), 
sum565 numeric(12,5), dem565 numeric(12,3), 
sum570 numeric(12,5), dem570 numeric(12,3), 
sum572 numeric(12,5), dem572 numeric(12,3), 
sum576 numeric(12,5), dem576 numeric(12,3), 
sum578 numeric(12,5), dem578 numeric(12,3), 
sum610 numeric(12,5), dem610 numeric(12,3), 
sum615 numeric(12,5), dem615 numeric(12,3), 
sum625 numeric(12,5), dem625 numeric(12,3), 
sum630 numeric(12,5), dem630 numeric(12,3), 
sum640 numeric(12,5), dem640 numeric(12,3), 
sum645 numeric(12,5), dem645 numeric(12,3), 
sum655 numeric(12,5), dem655 numeric(12,3), 
sum660 numeric(12,5), dem660 numeric(12,3), 
sum670 numeric(12,5), dem670 numeric(12,3), 
sum675 numeric(12,5), dem675 numeric(12,3), 
sum685 numeric(12,5), dem685 numeric(12,3), 
sum690 numeric(12,5), dem690 numeric(12,3), 
sum700 numeric(12,5), dem700 numeric(12,3), 
sum705 numeric(12,5), dem705 numeric(12,3), 
sum715 numeric(12,5), dem715 numeric(12,3), 
sum720 numeric(12,5), dem720 numeric(12,3), 
sum730 numeric(12,5), dem730 numeric(12,3), 
sum735 numeric(12,5), dem735 numeric(12,3), 
sum745 numeric(12,5), dem745 numeric(12,3), 
sum750 numeric(12,5), dem750 numeric(12,3), 
sum760 numeric(12,5), dem760 numeric(12,3), 
sum765 numeric(12,5), dem765 numeric(12,3), 
sum775 numeric(12,5), dem775 numeric(12,3), 
sum780 numeric(12,5), dem780 numeric(12,3), 
sum777 numeric(12,5), dem777 numeric(12,3), 
sum778 numeric(12,5), dem778 numeric(12,3), 
sum779 numeric(12,5), dem779 numeric(12,3), 
sum781 numeric(12,5), dem781 numeric(12,3), 
sum784 numeric(12,5), dem784 numeric(12,3), 
sum786 numeric(12,5), dem786 numeric(12,3),
sum427 numeric(12,5), dem427 numeric(12,3), 
sum428 numeric(12,5), dem428 numeric(12,3)
); 

--drop FUNCTION rep_4nkre_fun(date);
CREATE or replace FUNCTION rep_4nkre_fun(date,int)
RETURNS int
AS                                                                                              
  '
  declare
   pmmgg Alias for $1;
   pfile Alias for $2;
   r record;
   rr record;
   pr int ;
   kodres  int;
   tabl text;
   del text;
   nul text;
   SQL text;
  begin

  if pmmgg >=''2017-03-01'' then 
    pr=rep_4nkre2017_fun(pmmgg,pfile);
    return pr;
  end if;

  if pmmgg >=''2015-04-01'' then 
    pr=rep_4nkre2015_fun(pmmgg,pfile);
    return pr;
  end if;

  if pmmgg >=''2012-10-01'' then
    pr=rep_4nkre2012_fun(pmmgg,pfile);
    return pr;
  end if;



--   pr=rep_nkre4(pmmgg);
  select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 

  delete from rep_4nkre_tbl;
 
  insert into rep_4nkre_tbl (mmgg) select pmmgg;

  update rep_4nkre_tbl set sum017=summa,dem017=demand from sebd_nkre4 where code_nkre4=17 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum032=summa,dem032=demand from sebd_nkre4 where code_nkre4=32 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum047=summa,dem047=demand from sebd_nkre4 where code_nkre4=47 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum062=summa,dem062=demand from sebd_nkre4 where code_nkre4=62 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum077=summa,dem077=demand from sebd_nkre4 where code_nkre4=77 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum092=summa,dem092=demand from sebd_nkre4 where code_nkre4=92 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum346=summa,dem346=demand from sebd_nkre4 where code_nkre4=346 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum347=summa,dem347=demand from sebd_nkre4 where code_nkre4=347 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum431=summa,dem431=demand from sebd_nkre4 where code_nkre4=431 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum432=summa,dem432=demand from sebd_nkre4 where code_nkre4=432 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum491=summa,dem491=demand from sebd_nkre4 where code_nkre4=491 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum492=summa,dem492=demand from sebd_nkre4 where code_nkre4=492 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum554=summa,dem554=demand from sebd_nkre4 where code_nkre4=554 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum555=summa,dem555=demand from sebd_nkre4 where code_nkre4=555 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum556=summa,dem556=demand from sebd_nkre4 where code_nkre4=556 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum558=summa,dem558=demand from sebd_nkre4 where code_nkre4=558 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum559=summa,dem559=demand from sebd_nkre4 where code_nkre4=559 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum563=summa,dem563=demand from sebd_nkre4 where code_nkre4=563 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum564=summa,dem564=demand from sebd_nkre4 where code_nkre4=564 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum700=summa,dem700=demand from sebd_nkre4 where code_nkre4=700 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum705=summa,dem705=demand from sebd_nkre4 where code_nkre4=705 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum715=summa,dem715=demand from sebd_nkre4 where code_nkre4=715 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum720=summa,dem720=demand from sebd_nkre4 where code_nkre4=720 and sebd_nkre4.mmgg=pmmgg;

 
  update rep_4nkre_tbl set sum730=summa,dem730=demand from sebd_nkre4 where code_nkre4=730 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum735=summa,dem735=demand from sebd_nkre4 where code_nkre4=735 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum745=summa,dem745=demand from sebd_nkre4 where code_nkre4=745 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum750=summa,dem750=demand from sebd_nkre4 where code_nkre4=750 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum760=summa,dem760=demand from sebd_nkre4 where code_nkre4=760 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum765=summa,dem765=demand from sebd_nkre4 where code_nkre4=765 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum775=summa,dem775=demand from sebd_nkre4 where code_nkre4=775 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum780=summa,dem780=demand from sebd_nkre4 where code_nkre4=780 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum784=summa,dem784=demand from sebd_nkre4 where code_nkre4=784 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum786=summa,dem786=demand from sebd_nkre4 where code_nkre4=786 and sebd_nkre4.mmgg=pmmgg;


  update rep_4nkre_tbl set sum570=summa,dem570=demand from sebd_nkre4 where code_nkre4=570 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum572=summa,dem572=demand from sebd_nkre4 where code_nkre4=572 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum576=summa,dem576=demand from sebd_nkre4 where code_nkre4=576 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum578=summa,dem578=demand from sebd_nkre4 where code_nkre4=578 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum779=summa,dem779=demand from sebd_nkre4 where code_nkre4=779 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum781=summa,dem781=demand from sebd_nkre4 where code_nkre4=781 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum427=summa,dem427=demand from sebd_nkre4 where code_nkre4=427 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum428=summa,dem428=demand from sebd_nkre4 where code_nkre4=428 and sebd_nkre4.mmgg=pmmgg;


  update rep_4nkre_tbl set sum336=summa,dem336=demand from sebd_nkre4 where code_nkre4=336 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum341=summa,dem341=demand from sebd_nkre4 where code_nkre4=341 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum348=summa,dem348=demand from sebd_nkre4 where code_nkre4=348 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum349=summa,dem349=demand from sebd_nkre4 where code_nkre4=349 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum421=summa,dem421=demand from sebd_nkre4 where code_nkre4=421 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum422=summa,dem422=demand from sebd_nkre4 where code_nkre4=422 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum423=summa,dem423=demand from sebd_nkre4 where code_nkre4=423 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum446=summa,dem446=demand from sebd_nkre4 where code_nkre4=446 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum447=summa,dem447=demand from sebd_nkre4 where code_nkre4=447 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum448=summa,dem448=demand from sebd_nkre4 where code_nkre4=448 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum433=summa,dem433=demand from sebd_nkre4 where code_nkre4=433 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum434=summa,dem434=demand from sebd_nkre4 where code_nkre4=434 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum435=summa,dem435=demand from sebd_nkre4 where code_nkre4=435 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum436=summa,dem436=demand from sebd_nkre4 where code_nkre4=436 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum437=summa,dem437=demand from sebd_nkre4 where code_nkre4=437 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum438=summa,dem438=demand from sebd_nkre4 where code_nkre4=438 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum481=summa,dem481=demand from sebd_nkre4 where code_nkre4=481 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum486=summa,dem486=demand from sebd_nkre4 where code_nkre4=486 and sebd_nkre4.mmgg=pmmgg;

  update rep_4nkre_tbl set sum493=summa,dem493=demand from sebd_nkre4 where code_nkre4=493 and sebd_nkre4.mmgg=pmmgg;
  update rep_4nkre_tbl set sum494=summa,dem494=demand from sebd_nkre4 where code_nkre4=494 and sebd_nkre4.mmgg=pmmgg;


raise notice ''update 1 kl 110'';
  -- все что 1 класс и не 35 кВ, бросим в 110 (для Чер МЕМ, у которых есть 1 кл 10 кВ)
  update rep_4nkre_tbl set sum010=s10,dem010=d10, sum025=s25,dem025=d25, sum040=s40,dem040=d40,
   sum055=s55,dem055=d55, sum070=s70,dem070=d70, sum085=s85,dem085=d85,sum015=s15,dem015=d15,
   sum030=s30,dem030=d30, sum045=s45,dem045=d45, sum060=s60,dem060=d60,sum075=s75,dem075=d75,
   sum090=s90,dem090=d90,
   sum340=s340,dem340=d340, sum335=s335,dem335=d335, sum320=s320,dem320=d320,sum315=s315,dem315=d315,
   sum341=s341,dem341=d341, sum336=s336,dem336=d336

  from
  (select 
         coalesce(sum(CASE WHEN ident =''tgr1'' and (voltage>35 or voltage<27) THEN demand_tcl1 ELSE 0 END )/1000,0) as d10,
         coalesce(sum(CASE WHEN ident =''tgr2'' and (voltage>35 or voltage<27) THEN demand_tcl1 ELSE 0 END )/1000,0) as d25,
         coalesce(sum(CASE WHEN ident =''tgr6'' and (voltage>35 or voltage<27) THEN demand_tcl1 ELSE 0 END )/1000,0) as d40,
         coalesce(sum(CASE WHEN ident =''tgr3'' and (voltage>35 or voltage<27) THEN demand_tcl1 ELSE 0 END )/1000,0) as d55,
         coalesce(sum(CASE WHEN ident =''tgr4'' and (voltage>35 or voltage<27) THEN demand_tcl1 ELSE 0 END )/1000,0) as d70,
         coalesce(sum(CASE WHEN ident =''tgr5'' and (voltage>35 or voltage<27) THEN demand_tcl1 ELSE 0 END )/1000,0) as d85,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and (voltage>35 or voltage<27) THEN sum_tcl1 ELSE 0 END )/1000,0) as s10,
         coalesce(sum(CASE WHEN ident =''tgr2'' and (voltage>35 or voltage<27) THEN sum_tcl1 ELSE 0 END )/1000,0) as s25,
         coalesce(sum(CASE WHEN ident =''tgr6'' and (voltage>35 or voltage<27) THEN sum_tcl1 ELSE 0 END )/1000,0) as s40,
         coalesce(sum(CASE WHEN ident =''tgr3'' and (voltage>35 or voltage<27) THEN sum_tcl1 ELSE 0 END )/1000,0) as s55,
         coalesce(sum(CASE WHEN ident =''tgr4'' and (voltage>35 or voltage<27) THEN sum_tcl1 ELSE 0 END )/1000,0) as s70,
         coalesce(sum(CASE WHEN ident =''tgr5'' and (voltage>35 or voltage<27) THEN sum_tcl1 ELSE 0 END )/1000,0) as s85,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d15,
         coalesce(sum(CASE WHEN ident =''tgr2'' and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d30,
         coalesce(sum(CASE WHEN ident =''tgr6'' and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d45,
         coalesce(sum(CASE WHEN ident =''tgr3'' and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d60,
         coalesce(sum(CASE WHEN ident =''tgr4'' and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d75,
         coalesce(sum(CASE WHEN ident =''tgr5'' and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d90,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s15,
         coalesce(sum(CASE WHEN ident =''tgr2'' and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s30,
         coalesce(sum(CASE WHEN ident =''tgr6'' and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s45,
         coalesce(sum(CASE WHEN ident =''tgr3'' and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s60,
         coalesce(sum(CASE WHEN ident =''tgr4'' and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s75,
         coalesce(sum(CASE WHEN ident =''tgr5'' and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s90,

         coalesce(sum(CASE WHEN ident like ''tgr8_1%'' and ident <> ''tgr8_101'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d335,
         coalesce(sum(CASE WHEN ident like ''tgr8_1%'' and ident <> ''tgr8_101'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s335,

         coalesce(sum(CASE WHEN ident =''tgr8_11'' or ident =''tgr8_12'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d336,
         coalesce(sum(CASE WHEN ident =''tgr8_11'' or ident =''tgr8_12'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s336,

         coalesce(sum(CASE WHEN ident like ''tgr8_2%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d340,
         coalesce(sum(CASE WHEN ident like ''tgr8_2%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s340,

         coalesce(sum(CASE WHEN ident =''tgr8_21'' or ident =''tgr8_22'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d341,
         coalesce(sum(CASE WHEN ident =''tgr8_21'' or ident =''tgr8_22'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s341,

         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d315,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage<=160 and voltage>=100 THEN sum_tcl1 ELSE 0 END )/1000,0) as s315,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d320,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s320

  from
  (select tgr.id as id_tgr, tgr.ident,vv.voltage_min as voltage, 
  sum(case when ( (p.id=1014 or p.id=1011) and (vv.voltage_min=0.4 or vv.voltage_min=10.0 ))  then 0 else  bs.demand_val end ) as demand_tcl1, 
  round(sum( case when  ((p.id=1014 or p.id=1011) and (vv.voltage_min=0.4 or vv.voltage_min=10.0 )) then  0 else bs.sum_val end),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  left join cla_param_tbl as p on (p.id=ph.id_extra)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
 where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg=pmmgg 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by tgr.id, tgr.ident,vv.voltage_min ) as s1
  ) as s11;

raise notice ''update 1 kl 110__-2'';

      update rep_4nkre_tbl set sum110=s110,dem110=d110, sum125=s125,dem125=d125, sum140=s140,dem140=d140,
   sum155=s155,dem155=d155, sum170=s170,dem170=d170, sum185=s185,dem185=d185,sum115=s115,dem115=d115,
   sum130=s130,dem130=d130, sum145=s145,dem145=d145, sum160=s160,dem160=d160,sum175=s175,dem175=d175,
   sum190=s190,dem190=d190,
   sum480=s480,dem480=d480, sum485=s485,dem485=d485, sum460=s460,dem460=d460,sum465=s465,dem465=d465,
   sum420=s420,dem420=d420, sum425=s425,dem425=d425, sum410=s410,dem410=d410,sum405=s405,dem405=d405,
   sum421=s421,dem421=d421, sum422=s422,dem422=d422, sum423=s423,dem423=d423,
   sum446=s446,dem446=d446, sum447=s447,dem447=d447, sum448=s448,dem448=d448,
   sum481=s481,dem481=d481, sum486=s486,dem486=d486

  from
  (select coalesce(sum(CASE WHEN ident =''tgr1'' and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d110,
         coalesce(sum(CASE WHEN ident =''tgr2'' and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d125,
         coalesce(sum(CASE WHEN ident =''tgr6'' and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d140,
         coalesce(sum(CASE WHEN ident =''tgr3'' and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d155,
         coalesce(sum(CASE WHEN ident =''tgr4'' and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d170,
         coalesce(sum(CASE WHEN ident =''tgr5'' and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d185,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s110,
         coalesce(sum(CASE WHEN ident =''tgr2'' and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s125,
         coalesce(sum(CASE WHEN ident =''tgr6'' and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s140,
         coalesce(sum(CASE WHEN ident =''tgr3'' and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s155,
         coalesce(sum(CASE WHEN ident =''tgr4'' and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s170,
         coalesce(sum(CASE WHEN ident =''tgr5'' and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s185,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d115,
         coalesce(sum(CASE WHEN ident =''tgr2'' and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d130,
         coalesce(sum(CASE WHEN ident =''tgr6'' and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d145,
         coalesce(sum(CASE WHEN ident =''tgr3'' and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d160,
         coalesce(sum(CASE WHEN ident =''tgr4'' and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d175,
         coalesce(sum(CASE WHEN ident =''tgr5'' and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d190,

	 coalesce(sum(CASE WHEN ident =''tgr1'' and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s115,
         coalesce(sum(CASE WHEN ident =''tgr2'' and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s130,
         coalesce(sum(CASE WHEN ident =''tgr6'' and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s145,
         coalesce(sum(CASE WHEN ident =''tgr3'' and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s160,
         coalesce(sum(CASE WHEN ident =''tgr4'' and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s175,
         coalesce(sum(CASE WHEN ident =''tgr5'' and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s190,

         coalesce(sum(CASE WHEN (ident like ''tgr8_1%'') and ident <> ''tgr8_101'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d480,
         coalesce(sum(CASE WHEN (ident like ''tgr8_1%'') and ident <> ''tgr8_101'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s480,
         coalesce(sum(CASE WHEN ident = ''tgr8_11'' or ident = ''tgr8_12'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d481,
         coalesce(sum(CASE WHEN ident = ''tgr8_11'' or ident = ''tgr8_12'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s481,

         coalesce(sum(CASE WHEN ident like ''tgr8_2%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d485,
         coalesce(sum(CASE WHEN ident like ''tgr8_2%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s485,
         coalesce(sum(CASE WHEN ident = ''tgr8_21'' or ident = ''tgr8_22'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d486,
         coalesce(sum(CASE WHEN ident = ''tgr8_21'' or ident = ''tgr8_22'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s486,

         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d460,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s460,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage=0.4 THEN demand_tcl1 ELSE 0 END )/1000,0) as d465,
         coalesce(sum(CASE WHEN ident like ''tgr8%'' and ident not like ''tgr8_6%'' and (ident <> ''tgr8_101'') and voltage=0.4 THEN sum_tcl1 ELSE 0 END )/1000,0) as s465,

         coalesce(sum(CASE WHEN ident like ''tgr7_1%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d420,
         coalesce(sum(CASE WHEN ident like ''tgr7_1%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s420,

         coalesce(sum(CASE WHEN ident = ''tgr7_1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d421,
         coalesce(sum(CASE WHEN ident = ''tgr7_1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s421,

         coalesce(sum(CASE WHEN (ident = ''tgr7_12'') or (ident = ''tgr7_121'') or (ident = ''tgr7_13'') or (ident = ''tgr8_101'') or (ident like ''tgr8_6%'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d422,
         coalesce(sum(CASE WHEN (ident = ''tgr7_12'') or (ident = ''tgr7_121'') or (ident = ''tgr7_13'') or (ident = ''tgr8_101'') or (ident like ''tgr8_6%'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s422,

         coalesce(sum(CASE WHEN ident = ''tgr7_15'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d423,
         coalesce(sum(CASE WHEN ident = ''tgr7_15'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s423,


         coalesce(sum(CASE WHEN ident like ''tgr7_2%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d425,
         coalesce(sum(CASE WHEN ident like ''tgr7_2%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s425,

         coalesce(sum(CASE WHEN ident = ''tgr7_2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d446,
         coalesce(sum(CASE WHEN ident = ''tgr7_2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s446,

         coalesce(sum(CASE WHEN (ident = ''tgr7_22'') or (ident = ''tgr7_221'') or (ident = ''tgr7_23'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d447,
         coalesce(sum(CASE WHEN (ident = ''tgr7_22'') or (ident = ''tgr7_221'') or (ident = ''tgr7_23'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s447,

         coalesce(sum(CASE WHEN ident = ''tgr7_25'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d448,
         coalesce(sum(CASE WHEN ident = ''tgr7_25'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s448,


         coalesce(sum(CASE WHEN ((ident like ''tgr7%'') or (ident like ''tgr8_6%'') or (ident = ''tgr8_101'')) and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d405,
         coalesce(sum(CASE WHEN ((ident like ''tgr7%'') or (ident like ''tgr8_6%'') or (ident = ''tgr8_101'')) and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s405,
         coalesce(sum(CASE WHEN ((ident like ''tgr7%'') or (ident like ''tgr8_6%'') or (ident = ''tgr8_101'')) and voltage=0.4 THEN demand_tcl1 ELSE 0 END )/1000,0) as d410,
         coalesce(sum(CASE WHEN ((ident like ''tgr7%'') or (ident like ''tgr8_6%'') or (ident = ''tgr8_101'')) and voltage=0.4 THEN sum_tcl1 ELSE 0 END )/1000,0) as s410

  from
  (select tgr.id as id_tgr, tgr.ident,vv.voltage_min as voltage, 
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=coalesce(ph.id_voltage,4)) 
  where tcl.ident=''tcl2'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by tgr.id, tgr.ident,vv.voltage_min ) as s1
  ) as s11;
-----------------------------------------------------------------------------------------------
  -- по населению дополнительно по счетам без точек учета
raise notice ''update naselen '';
  update rep_4nkre_tbl set 
   sum420=sum420+s420,dem420=dem420+d420, sum425=sum425+s425,dem425=dem425+d425, sum410=sum410+s410,dem410=dem410+d410,
   sum421=sum421+s421,dem421=dem421+d421,
   sum422=sum422+s422,dem422=dem422+d422,
   sum423=sum423+s423,dem423=dem423+d423,
   sum446=sum446+s446,dem446=dem446+d446,
   sum447=sum447+s447,dem447=dem447+d447,
   sum448=sum448+s448,dem448=dem448+d448

  from
  (
  select coalesce(sum(CASE WHEN ident like ''tgr7_1%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d420,
         coalesce(sum(CASE WHEN ident like ''tgr7_1%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s420,
         coalesce(sum(CASE WHEN ident like ''tgr7_2%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d425,
         coalesce(sum(CASE WHEN ident like ''tgr7_2%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s425,
         coalesce(sum(CASE WHEN ident like ''tgr7%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d410,
         coalesce(sum(CASE WHEN ident like ''tgr7%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s410,

         coalesce(sum(CASE WHEN ident = ''tgr7_1'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d421,
         coalesce(sum(CASE WHEN ident = ''tgr7_1'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s421,
         coalesce(sum(CASE WHEN (ident = ''tgr7_12'') or (ident = ''tgr7_13'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d422,
         coalesce(sum(CASE WHEN (ident = ''tgr7_12'') or (ident = ''tgr7_13'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s422,
         coalesce(sum(CASE WHEN ident = ''tgr7_15'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d423,
         coalesce(sum(CASE WHEN ident = ''tgr7_15'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s423,

         coalesce(sum(CASE WHEN ident = ''tgr7_2'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d446,
         coalesce(sum(CASE WHEN ident = ''tgr7_2'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s446,
         coalesce(sum(CASE WHEN (ident = ''tgr7_22'') or (ident = ''tgr7_23'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d447,
         coalesce(sum(CASE WHEN (ident = ''tgr7_22'') or (ident = ''tgr7_23'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s447,
         coalesce(sum(CASE WHEN ident = ''tgr7_25'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d448,
         coalesce(sum(CASE WHEN ident = ''tgr7_25'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s448


  from
  (select tgr.id as id_tgr, tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  where tcl.ident=''tcl2'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and coalesce(bs.id_point,0) =0
  group by tgr.id, tgr.ident ) as s1
  ) as s11;
--------------------------------------------------------------------------------------------------

raise notice ''update naselen ____2'';
  update rep_4nkre_tbl set sum685=s685,dem685=d685, sum690=s690,dem690=d690, sum655=s655,dem655=d655,
   sum660=s660,dem660=d660, sum625=s625,dem625=d625, sum630=s630,dem630=d630
  from
  (select 
   coalesce(sum(CASE WHEN section =203 and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d685,
   coalesce(sum(CASE WHEN section =203 and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d690,
   coalesce(sum(CASE WHEN section =203 and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s685,
   coalesce(sum(CASE WHEN section =203 and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s690,

   coalesce(sum(CASE WHEN section =212 and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d655,
   coalesce(sum(CASE WHEN section =212 and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d660,
   coalesce(sum(CASE WHEN section =212 and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s655,
   coalesce(sum(CASE WHEN section =212 and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s660,

   coalesce(sum(CASE WHEN section =211 and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d625,
   coalesce(sum(CASE WHEN section =211 and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d630,
   coalesce(sum(CASE WHEN section =211 and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s625,
   coalesce(sum(CASE WHEN section =211 and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s630
   from 
  ( select CASE WHEN p.lev=4 THEN p.id_parent  ELSE p.id END AS section , 
  vv.voltage_min as voltage, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join cla_param_tbl as p on (stcl.id_section=p.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=coalesce(ph.id_voltage,4)) 
  where tcl.ident=''tcl2'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg 
  and  p.id in (211,213,214,215,203)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by section, vv.voltage_min 
 ) as tcl1 ) as s22;


raise notice ''update naselen ____3'';
  update rep_4nkre_tbl set sum670=s670,dem670=d670, sum675=s675,dem675=d675, sum645=s645,dem645=d645,
   sum640=s640,dem640=d640, sum615=s615,dem615=d615, sum610=s610,dem610=d610
  from
  (select 
   coalesce(sum(CASE WHEN section =203 and voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d670,
   coalesce(sum(CASE WHEN section =203 and voltage<=35 and voltage>=27  THEN demand_tcl1 ELSE 0 END )/1000,0) as d675,
   coalesce(sum(CASE WHEN section =203 and voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s670,
   coalesce(sum(CASE WHEN section =203 and voltage<=35 and voltage>=27  THEN sum_tcl1 ELSE 0 END )/1000,0) as s675,

   coalesce(sum(CASE WHEN section =212 and voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d640,
   coalesce(sum(CASE WHEN section =212 and voltage<=35 and voltage>=27  THEN demand_tcl1 ELSE 0 END )/1000,0) as d645,
   coalesce(sum(CASE WHEN section =212 and voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s640,
   coalesce(sum(CASE WHEN section =212 and voltage<=35 and voltage>=27  THEN sum_tcl1 ELSE 0 END )/1000,0) as s645,

   coalesce(sum(CASE WHEN section =211 and voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d610,
   coalesce(sum(CASE WHEN section =211 and voltage<=35 and voltage>=27  THEN demand_tcl1 ELSE 0 END )/1000,0) as d615,
   coalesce(sum(CASE WHEN section =211 and voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s610,
   coalesce(sum(CASE WHEN section =211 and voltage<=35 and voltage>=27  THEN sum_tcl1 ELSE 0 END )/1000,0) as s615
   from 
  ( select CASE WHEN p.lev=4 THEN p.id_parent  ELSE p.id END AS section , 
  vv.voltage_min as voltage, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join cla_param_tbl as p on (stcl.id_section=p.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg 
  and  p.id in (211,213,214,215,203)
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by section, vv.voltage_min 
 ) as tcl1 ) as s22;


 --собственные нужды
raise notice ''hoznuj    '';

  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 578)=0 then 
  
  
    update rep_4nkre_tbl set sum570=s570,dem570=d570, sum572=s572,dem572=d572, sum576=s576,dem576=d576,
     sum578=s577,dem578=d577
    from
    (select coalesce(sum(CASE WHEN voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d570,
    	  coalesce(sum(CASE WHEN voltage<=35 and voltage>=27 THEN demand_tcl1 ELSE 0 END )/1000,0) as d572,
            coalesce(sum(CASE WHEN voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d576,
            coalesce(sum(CASE WHEN voltage<=0.4 THEN demand_tcl1 ELSE 0 END )/1000,0) as d577,
	  coalesce(sum(CASE WHEN voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s570,
    	  coalesce(sum(CASE WHEN voltage<=35 and voltage>=27 THEN sum_tcl1 ELSE 0 END )/1000,0) as s572,
            coalesce(sum(CASE WHEN voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s576,
            coalesce(sum(CASE WHEN voltage<=0.4 THEN sum_tcl1 ELSE 0 END )/1000,0) as s577
  
    from
    (select vv.voltage_min as voltage, 
    sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
    from acd_billsum_tbl as bs 
    join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
    join clm_client_tbl as cl on (cl.id = b.id_client) 
    join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
    join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
    join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
    where b.id_pref=10 and cl.book = -1 
    and bs.mmgg= pmmgg 
    and tar.id = 900002 
    and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
    group by vv.voltage_min ) as s1
    ) as s11;

  end if;

raise notice ''osvecctnie'';
 --освещение
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 781)=0 then 

    update rep_4nkre_tbl set sum779=s779,dem779=d779, sum781=s781,dem781=d781
    from
   (select 
     sum(sss.sum_n)/1000 as s781, sum(sss.demand_n)/1000 as d781, 
     sum(sss.demand_n+coalesce(sss2.demand_d,0))/1000 as d779, 
     sum(sss.sum_n+coalesce(sss2.sum_d,0))/1000 as s779
   from 
   (select b.id_client, mkz.num_eqp::varchar, sum(bs.demand_val) as demand_n, sum(bs.sum_val) as sum_n 
   from acm_bill_tbl as b join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
   join clm_client_tbl as clm on (clm.id=b.id_client) 
   join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
   left join (select id_point,id_doc,  
--             max(id_meter) as id_meter,max(id_type_eqp) as id_type_meter,
  	     trim(regexp_replace(trim(max(num_eqp)),''(+|-)$'',''''))::varchar as num_eqp 
             from acd_met_kndzn_tbl where id_zone = 0 and kind_energy=1 and mmgg = pmmgg  group by id_point,id_doc order by  id_point,id_doc) as mkz 
             on (bs.id_point = mkz.id_point and b.id_doc = mkz.id_doc ) 
   where bs.id_tariff = 51 and bs.id_zone = 0 and b.id_pref = 10 
   and b.mmgg = pmmgg and clm.book = -1 
   group by b.id_client, mkz.num_eqp order by b.id_client, mkz.num_eqp) as sss 
   left join 
   (select b.id_client, mkz.num_eqp::varchar, sum(bs.demand_val) as demand_d, sum(bs.sum_val) as sum_d 
   from acm_bill_tbl as b join acd_billsum_tbl as bs on (b.id_doc = bs.id_doc) 
   join clm_client_tbl as clm on (clm.id=b.id_client) 
   join (select id_point,id_doc,
         trim(regexp_replace(trim(max(num_eqp)),''(+|-)$'',''''))::varchar as num_eqp 
         from acd_met_kndzn_tbl where id_zone = 0 and kind_energy=1 and mmgg = pmmgg group by id_point,id_doc order by  id_point,id_doc) as mkz 
         on (bs.id_point = mkz.id_point and b.id_doc = mkz.id_doc ) 
   where bs.id_tariff <> 51 and bs.id_zone = 0 and b.id_pref = 10 
   and b.mmgg = pmmgg and clm.book = -1 
   group by b.id_client, mkz.num_eqp order by b.id_client, mkz.num_eqp) as sss2 on (sss.id_client = sss2.id_client and sss.num_eqp = sss2.num_eqp) 
   ) as light;

  end if;


raise notice ''religia  '';
 --религиозные организации
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 700)=0 then 

  update rep_4nkre_tbl set sum700=s700,dem700=d700, sum705=s705,dem705=d705
   from
  (select 
   coalesce(sum(CASE WHEN  voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d700,
   coalesce(sum(CASE WHEN  voltage<=35 and voltage>=27  THEN demand_tcl1 ELSE 0 END )/1000,0) as d705,
   coalesce(sum(CASE WHEN  voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s700,
   coalesce(sum(CASE WHEN  voltage<=35 and voltage>=27  THEN sum_tcl1 ELSE 0 END )/1000,0) as s705
   from 
  ( select p.id AS section , 
  vv.voltage_min as voltage, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and  p.id =1003
  and bs.mmgg= pmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by section, vv.voltage_min 
 ) as tcl1 ) as s22;

raise notice ''religia 2'';

  update rep_4nkre_tbl set sum715=s715,dem715=d715, sum720=s720,dem720=d720
   from
  (select 
   coalesce(sum(CASE WHEN voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d715,
   coalesce(sum(CASE WHEN voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d720,
   coalesce(sum(CASE WHEN voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s715,
   coalesce(sum(CASE WHEN voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s720
   from 
  ( select p.id AS section , 
  vv.voltage_min as voltage, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where tcl.ident=''tcl2'' and b.id_pref=10 and cl.book = -1 
  and  p.id =1003
  and bs.mmgg= pmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by section, vv.voltage_min 
 ) as tcl2 ) as s22;

  end if;

raise notice ''turmi '';
 -- Заклади пен?тенц?арної системи   
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 730)=0 then 

  update rep_4nkre_tbl set sum730=s730,dem730=d730, sum735=s735,dem735=d735,
                           sum760=s760,dem760=d760, sum765=s765,dem765=d765
   from
  (select 
   coalesce(sum(CASE WHEN voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d730,
   coalesce(sum(CASE WHEN voltage<=35 and voltage>=27  THEN demand_tcl1 ELSE 0 END )/1000,0) as d735,
   coalesce(sum(CASE WHEN voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s730,
   coalesce(sum(CASE WHEN voltage<=35 and voltage>=27  THEN sum_tcl1 ELSE 0 END )/1000,0) as s735,
   coalesce(sum(CASE WHEN section =1002 and voltage<=160 and voltage>=110 THEN demand_tcl1 ELSE 0 END )/1000,0) as d760,
   coalesce(sum(CASE WHEN section =1002 and voltage<=35 and voltage>=27  THEN demand_tcl1 ELSE 0 END )/1000,0) as d765,
   coalesce(sum(CASE WHEN section =1002 and voltage<=160 and voltage>=110 THEN sum_tcl1 ELSE 0 END )/1000,0) as s760,
   coalesce(sum(CASE WHEN section =1002 and voltage<=35 and voltage>=27  THEN sum_tcl1 ELSE 0 END )/1000,0) as s765

   from 
  ( select p.id AS section , 
  vv.voltage_min as voltage, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and  p.id in (1001,1002,1012,1013)
  and bs.mmgg= pmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by section, vv.voltage_min 
 ) as tcl1 ) as s22;

raise notice ''turmi   222'';

  update rep_4nkre_tbl set sum745=s745,dem745=d745, sum750=s750,dem750=d750,
                           sum775=s775,dem775=d775, sum780=s780,dem780=d780
   from
  (select 
   coalesce(sum(CASE WHEN voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d745,
   coalesce(sum(CASE WHEN voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d750,
   coalesce(sum(CASE WHEN voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s745,
   coalesce(sum(CASE WHEN voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s750,
   coalesce(sum(CASE WHEN section =1002 and voltage<=10 and voltage>=3 THEN demand_tcl1 ELSE 0 END )/1000,0) as d775,
   coalesce(sum(CASE WHEN section =1002 and voltage=0.4  THEN demand_tcl1 ELSE 0 END )/1000,0) as d780,
   coalesce(sum(CASE WHEN section =1002 and voltage<=10 and voltage>=3 THEN sum_tcl1 ELSE 0 END )/1000,0) as s775,
   coalesce(sum(CASE WHEN section =1002 and voltage=0.4  THEN sum_tcl1 ELSE 0 END )/1000,0) as s780

   from 
  ( select p.id AS section , 
  vv.voltage_min as voltage, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  where tcl.ident=''tcl2'' and b.id_pref=10 and cl.book = -1 
  and  p.id in (1001,1002,1012,1013)
  and bs.mmgg= pmmgg  
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by section, vv.voltage_min 
 ) as tcl2 ) as s22;

  end if;

raise notice ''osveccenie nasel punkt'';
 -- Освещение населенных пунктов   
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 784)=0 then 

  update rep_4nkre_tbl set sum784=s784,dem784=d784, sum786=s786,dem786=d786
   from
  (select 
   coalesce(sum(CASE WHEN ident like ''tgr7_1%''  THEN demand_tcl1 ELSE 0 END )/1000,0) as d784,
   coalesce(sum(CASE WHEN ident like ''tgr7_2%''  THEN demand_tcl1 ELSE 0 END )/1000,0) as d786,
   coalesce(sum(CASE WHEN ident like ''tgr7_1%''  THEN sum_tcl1 ELSE 0 END )/1000,0) as s784,
   coalesce(sum(CASE WHEN ident like ''tgr7_2%''  THEN sum_tcl1 ELSE 0 END )/1000,0) as s786
   from 
  ( select tgr.id as id_tgr, tgr.ident, sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  join cla_param_tbl as p on (p.id=ph.id_extra) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  where b.id_pref=10 and cl.book = -1 
  and p.id  = 1005
  and bs.mmgg= pmmgg 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.id , tgr.ident 
 ) as tcl2 ) as s22;

  end if;

raise notice ''electropliti'';
 -- население с єлектроплитами
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 431)=0 then 

  update rep_4nkre_tbl set 
   sum431=s431,dem431=d431, sum432=s432,dem432=d432, sum491=s491,dem491=d491,sum492=s492,dem492=d492,
   sum427=s427,dem427=d427,sum428=s428,dem428=d428,
   sum433=s433,dem433=d433, sum435=s435,dem435=d435, sum437=s437,dem437=d437,
   sum434=s434,dem434=d434, sum436=s436,dem436=d436, sum438=s438,dem438=d438,
   sum493=s493,dem493=d493,sum494=s494,dem494=d494
  from
  (select 

         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019,1012) and (ident like ''tgr8_3%'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d491,
         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019,1012) and (ident like ''tgr8_3%'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s491,
         coalesce(sum(CASE WHEN section in (1010,1013) and (ident like ''tgr8_3%'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d492,
         coalesce(sum(CASE WHEN section in (1010,1013) and (ident like ''tgr8_3%'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s492,

         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019,1012) and (ident = ''tgr8_31'' or ident = ''tgr8_32'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d493,
         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019,1012) and (ident = ''tgr8_31'' or ident = ''tgr8_32'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s493,

         coalesce(sum(CASE WHEN section in (1010,1013) and (ident = ''tgr8_31'' or ident = ''tgr8_32'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d494,
         coalesce(sum(CASE WHEN section in (1010,1013) and (ident = ''tgr8_31'' or ident = ''tgr8_32'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s494,

         coalesce(sum(CASE WHEN section =1007 and ident like ''tgr7_3%'' and ident <>''tgr7_33'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d431,
         coalesce(sum(CASE WHEN section =1007 and ident like ''tgr7_3%'' and ident <>''tgr7_33'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s431,
         coalesce(sum(CASE WHEN section =1008 and ident like ''tgr7_3%'' and ident <>''tgr7_33'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d432,
         coalesce(sum(CASE WHEN section =1008 and ident like ''tgr7_3%'' and ident <>''tgr7_33'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s432,

         coalesce(sum(CASE WHEN section =1007 and ((ident = ''tgr7_3'') or (ident = ''tgr7_511'') or (ident = ''tgr7_521'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d433,
         coalesce(sum(CASE WHEN section =1007 and ((ident = ''tgr7_3'') or (ident = ''tgr7_511'') or (ident = ''tgr7_521'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s433,

         coalesce(sum(CASE WHEN section =1007 and ((ident = ''tgr7_32'') or (ident = ''tgr7_321'') or (ident = ''tgr7_512'') or (ident = ''tgr7_513'')
		or (ident = ''tgr7_522'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d435,
         coalesce(sum(CASE WHEN section =1007 and ((ident = ''tgr7_32'') or (ident = ''tgr7_321'') or (ident = ''tgr7_512'') or (ident = ''tgr7_513'')
		or (ident = ''tgr7_522'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s435,

         coalesce(sum(CASE WHEN section =1007 and ((ident = ''tgr7_35'') or (ident = ''tgr7_53'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d437,
         coalesce(sum(CASE WHEN section =1007 and ((ident = ''tgr7_35'') or (ident = ''tgr7_53'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s437,

         coalesce(sum(CASE WHEN section =1008 and ((ident = ''tgr7_3'') or (ident = ''tgr7_511'') or (ident = ''tgr7_521'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d434,
         coalesce(sum(CASE WHEN section =1008 and ((ident = ''tgr7_3'') or (ident = ''tgr7_511'') or (ident = ''tgr7_521'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s434,

         coalesce(sum(CASE WHEN section =1008 and ((ident = ''tgr7_32'') or (ident = ''tgr7_321'') or (ident = ''tgr7_512'') or (ident = ''tgr7_513'')
		or (ident = ''tgr7_522'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d436,
         coalesce(sum(CASE WHEN section =1008 and ((ident = ''tgr7_32'') or (ident = ''tgr7_321'') or (ident = ''tgr7_512'') or (ident = ''tgr7_513'')
		or (ident = ''tgr7_522'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s436,

         coalesce(sum(CASE WHEN section =1008 and ((ident = ''tgr7_35'') or (ident = ''tgr7_53'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d438,
         coalesce(sum(CASE WHEN section =1008 and ((ident = ''tgr7_35'') or (ident = ''tgr7_53'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s438,

         coalesce(sum(CASE WHEN section =1015 and ((ident =''tgr7_4'') or (ident like ''tgr7_6%'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d427,
         coalesce(sum(CASE WHEN section =1015 and ((ident =''tgr7_4'') or (ident like ''tgr7_6%'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s427,
         coalesce(sum(CASE WHEN section =1016 and ((ident =''tgr7_4'') or (ident like ''tgr7_6%'')) THEN demand_tcl1 ELSE 0 END )/1000,0) as d428,
         coalesce(sum(CASE WHEN section =1016 and ((ident =''tgr7_4'') or (ident like ''tgr7_6%'')) THEN sum_tcl1 ELSE 0 END )/1000,0) as s428

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
  where tcl.ident=''tcl2'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.id, tgr.ident, section ) as s1
  ) as s11;

raise notice ''electropliti 2'';

  update rep_4nkre_tbl set 
   sum346=s346,dem346=d346, sum347=s347,dem347=d347,sum348=s348,dem348=d348, sum349=s349,dem349=d349
  from
  (select 

         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019) and ident like ''tgr8_3%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d346,
         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019) and ident like ''tgr8_3%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s346,
         coalesce(sum(CASE WHEN section =1010 and ident like ''tgr8_3%'' THEN demand_tcl1 ELSE 0 END )/1000,0) as d347,
         coalesce(sum(CASE WHEN section =1010 and ident like ''tgr8_3%'' THEN sum_tcl1 ELSE 0 END )/1000,0) as s347,

         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019) and (ident =''tgr8_31'' or ident =''tgr8_32'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d348,
         coalesce(sum(CASE WHEN section in (1009,1017,1018,1019) and (ident =''tgr8_31'' or ident =''tgr8_32'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s348,

         coalesce(sum(CASE WHEN section =1010 and (ident =''tgr8_31'' or ident =''tgr8_32'') THEN demand_tcl1 ELSE 0 END )/1000,0) as d349,
         coalesce(sum(CASE WHEN section =1010 and (ident =''tgr8_31'' or ident =''tgr8_32'') THEN sum_tcl1 ELSE 0 END )/1000,0) as s349

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
  where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.id, tgr.ident, section ) as s1
  ) as s11;

  end if;


 -- ТВЕ/Тяга
raise notice ''taga'';
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 564)=0 then 

  update rep_4nkre_tbl set  sum564=s564,dem564=d564
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
  where b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and stcl.id_section = 217
  ) as s1
  ) as s11;


  end if;

raise notice ''transit'';

--Транзит
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 554)=0 then 

  update rep_4nkre_tbl set  sum554=s554,dem554=d554
  from
  (select 
         coalesce(sum(demand_tcl1)/1000,0) as d554,
         coalesce(sum(sum_tcl1)/1000,0) as s554
  from
  (select sum(bs.demand_val) as demand_tcl1, 0 as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  where tcl.ident=''tcl1'' and b.id_pref = 10 and cl.book = -1 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and stcl.id_section = 209
  ) as s1
  ) as s11;

  update rep_4nkre_tbl set  sum558=s558,dem558=d558
  from
  (select 
         coalesce(sum(demand_tcl1)/1000,0) as d558,
         coalesce(sum(sum_tcl1)/1000,0) as s558
  from
  (select sum(bs.demand_val) as demand_tcl1, 0 as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client=b.id_client) 
  where tcl.ident=''tcl2'' and b.id_pref = 10 and cl.book = -1 
  and bs.mmgg= pmmgg  
  and tar.id not in (900001,999999) 
  and stcl.id_section = 209
  ) as s1
  ) as s11;

  end if;


raise notice ''tec'';
 -- С шин ТЕЦ (Чернмгов МЕМ)  и З шин ПС ЕЕС (Нежин)
  if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 17)=0 then 

  update rep_4nkre_tbl set 
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
  where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and bs.mmgg= pmmgg 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(b.dat_e,p2.dt_b) ) 
  group by tgr.id, tgr.ident, section ) as s1
  ) as s11;


  end if;
 if (select coalesce(flag_hand,0) from sebi_nkre4 where code = 670)=1 then 
 update rep_4nkre_tbl set sum670=summa,dem670=demand from sebd_nkre4 where code_nkre4=670 and sebd_nkre4.mmgg=pmmgg;
end if;
 -----------------------------------------------------------------------------------------

 if (pfile = 1) then
  tabl=''/home/local/seb/''||kodres||''NKRE4.TXT'';
  del=''@''; nul='''';
  SQL=''copy  rep_4nkre_tbl  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);

  raise notice ''%'',SQL;

  Execute SQL;
 end if;


return 1;
end'
language 'plpgsql';

 /*select tgr.id as id_tgr, tgr.ident,vv.voltage_min as voltage,p.id as section, 
  sum(bs.demand_val) as demand_tcl1, round(sum(bs.sum_val),2) as sum_tcl1 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc) 
  join clm_client_tbl as cl on (cl.id = b.id_client) 
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) 
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) 
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id) 
  join eqm_point_h as ph on (ph.code_eqp = bs.id_point) 
  left join cla_param_tbl as p on (p.id=ph.id_extra)
  join eqk_voltage_tbl as vv on (vv.id=ph.id_voltage) 
  where tcl.ident=''tcl1'' and b.id_pref=10 and cl.book = -1 
  and to_char(bs.mmgg,''YYYY-MM'')=to_char( pmmgg ,''YYYY-MM'') 
  and tar.id not in (900001,999999) 
  and ph.dt_b = (select max(dt_b) from eqm_point_h as p2 where p2.code_eqp = bs.id_point and p2.dt_b <= coalesce(bs.dt_end,p2.dt_b) ) 
  group by tgr.id, tgr.ident,vv.voltage_min,p.id having p.id<>1014 ) as s1
 */
