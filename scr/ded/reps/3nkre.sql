create or replace function rep_3nkre_fun(date,date,int) returns int
AS                                                                                              
'
declare 
  pdt_b alias for $1; 
  pdt_e alias for $2;
  pmode alias for $3;

  vdt_b date;
  vdt_e date;

  v int;
  r record;
  vid_pref int;

BEGIN

  delete from rep_3nkre_tbl where mode = pmode;

  vdt_b:=date_trunc(''month'',pdt_b);
  vdt_e:=date_trunc(''month'',pdt_e);

  insert into rep_3nkre_tbl (id_client,class,ident,demand_val,sum_val,sum_tax,mode)
  select cla.id,case when tcl.ident = ''tcl1'' then 1 when  tcl.ident = ''tcl2'' then 2 end,1,
   round(sum(bs.demand_val)::numeric/1000), round(sum(bs.sum_val)::numeric/1000,1), round(sum(bs.sum_val)::numeric/5000,1), pmode 
  from acd_billsum_tbl as bs 
  join acm_bill_tbl as b on (bs.id_doc = b.id_doc)
  join clm_client_tbl as cl on (cl.id = b.id_client)
  join clm_statecl_tbl as stcl on (stcl.id_client = cl.id) 
  join cla_param_tbl as cla on ( stcl.id_section = cla.id and cla.id_group = 200)
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff)
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id)
  join eqi_grouptarif_tbl as tgr on (tar.id_grouptarif=tgr.id)
  where b.id_pref=110 and cl.book = -1
  and bs.mmgg>=vdt_b and bs.mmgg<=vdt_e 
  group by cla.id,tcl.ident;	


  insert into rep_3nkre_tbl (id_client,ident,demand_val,sum_val,sum_tax,mode)
  select id_client, 2, sum(demand_val), sum(sum_val), sum(sum_tax), pmode
  from rep_3nkre_tbl
  where  mode = pmode
  group by id_client 
  having count(*) > 1;

  update rep_3nkre_tbl set ident = 3 
  where ident = 1 
  and id_client not in (select id_client from rep_3nkre_tbl where ident = 2 and mode = pmode);

  perform  seb_all( 0, vdt_b);

  update rep_3nkre_tbl set saldo_b = round((-coalesce(sss.deb_zpmv,0)-coalesce(sss.kr_zpmv,0))/1000,1)
  from ( select cla.id, sum(obr.deb_zpmv) as deb_zpmv, sum(obr.kr_zpmv) as kr_zpmv
   from seb_obr_all_tmp as obr 
   join cla_param_tbl as cla on (obr.roz = cla.kod and cla.id_group = 200)
   where obr.id_pref = 110
   group by cla.id ) as sss
  where sss.id = rep_3nkre_tbl.id_client and rep_3nkre_tbl.ident in (2,3) and mode = pmode;

  insert into rep_3nkre_tbl (id_client,ident,saldo_b,mode)
  select cla.id,3,round((-coalesce(sum(obr.deb_zpmv),0)-coalesce(sum(obr.kr_zpmv),0))/1000,1), pmode
  from seb_obr_all_tmp as obr 
  join cla_param_tbl as cla on (obr.roz = cla.kod and cla.id_group = 200)
  where obr.id_pref = 110 
  and cla.id not in (select id_client from rep_3nkre_tbl where mode = pmode)
  group by cla.id; 

  update rep_3nkre_tbl set sum_pay = round(pay.pay_all/1000,1)
  from 
     (select cla.id, sum(p.value_pay) as pay_all  
      from acm_pay_tbl as p left join clm_client_tbl as c on (c.id= p.id_client) 
      join clm_statecl_tbl as stcl on (stcl.id_client = c.id) 
      join cla_param_tbl as cla on ( stcl.id_section = cla.id and cla.id_group = 200)
       where 
       date_trunc(''month'', p.reg_date) >=vdt_b and date_trunc(''month'', p.reg_date) <= vdt_e 
       and p.id_pref = 110 and c.book = -1 and p.sign_pay = 1 and c.idk_work not in (0,99) 
       group by cla.id order by cla.id ) as pay 
  where pay.id = rep_3nkre_tbl.id_client and rep_3nkre_tbl.ident in (2,3) and mode = pmode;

  insert into rep_3nkre_tbl (id_client,ident,sum_pay,mode)
  select cla.id, 3, round(sum(p.value_pay)/1000,1) as pay_all , pmode 
  from acm_pay_tbl as p left join clm_client_tbl as c on (c.id= p.id_client) 
  join clm_statecl_tbl as stcl on (stcl.id_client = c.id) 
  join cla_param_tbl as cla on ( stcl.id_section = cla.id and cla.id_group = 200)
  where 
  date_trunc(''month'', p.reg_date) >=vdt_b and date_trunc(''month'', p.reg_date) <= vdt_e 
  and p.id_pref = 110 and c.book = -1 and p.sign_pay = 1 and c.idk_work not in (0,99) 
  and cla.id not in (select id_client from rep_3nkre_tbl where mode = pmode) 
  group by cla.id ;

RETURN 0;
end;'                                                                                           
LANGUAGE 'plpgsql';     
