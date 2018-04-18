
--INSERT INTO dci_document_tbl(id, name, idk_document,  ident)  VALUES (311, 'ðÏ ëôð/ÆÉÄÅÒÕ',300, 'rep_pwr_f');
alter table acm_headindication_tbl add column id_grp int;

create or replace function res_inp_ind(int) Returns boolean As'
Declare
idind Alias for $1;
dte date;
dtb date;
client int;
r record;
r1 record;
rs boolean;
strsql text;
ind record;
strsql1 text;
lost_ind int;
lost_ind1 record;
i int;
begin
---sel calc period
--delete from act_ch_err;
rs:=del_eqtmp_t(0,0);
strsql1:='''';


for r in select a.*,b.ident from acm_headindication_tbl as a left join 
           dci_document_tbl as b on a.idk_document=b.id where id_doc=idind 
loop 

Raise Notice ''IDENT - %'',r.ident;

  dtb:=date_mii(r.date_end::date,1);
  dte:=r.date_end;

client=r.id_client;

Raise Notice ''DTB - %'',dtb;
Raise Notice ''DTE - %'',dte;

 for lost_ind1 in select distinct acd_indication_tbl.id_doc 
  from acd_indication_tbl 
    left join acm_headindication_tbl on 
        (acd_indication_tbl.id_doc=acm_headindication_tbl.id_doc) 
    where acm_headindication_tbl.id_doc is null and acd_indication_tbl.flock<>1  and acd_indication_tbl.id_client=r.id_client
 loop 
   Raise Notice ''doc_ind - %'',lost_ind1.id_doc;

   delete from acd_indication_tbl where id_doc= lost_ind1.id_doc;
 end loop;

  
--''beg_ind'',''kor_ind'',''rep_pwr'',''chn_cnt'',''act_chn'',''act_pwr'',''act_check'',''rep_avg''
  if r.ident in (''kor_ind'',''rep_pwr'',''rep_bound'', ''rep_pwr_f'') then


    Raise Notice '' old act_met_kndzn_tbl select'';

    rs:=oabn_tree_res(r.id_client,dtb,dte,r.id_grp);

/*
    delete from act_met_kndzn_tbl;

    insert into act_met_kndzn_tbl (id_point,id_meter,num_eqp,kind_energy,id_zone,k_tr,id_type_eqp,dat_b,dat_e)

    select mp.id_point, mp.id_meter, e.num_eqp, 1 as kind_energy,0 as id_zone, koef_tt*koef_tu as k_tr, m.id_type_eqp,dtb,dte


    from eqm_tree_h as tr
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <= dte and coalesce(dt_e,dte) >= dte group by id) as tr2 on (tr.id = tr2.id and tr2.dt = tr.dt_b)
    join eqm_eqp_tree_h as ttr on (tr.id = ttr.id_tree)
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= dte and coalesce(dt_e,dte) >= dte group by code_eqp) as ttr2 on (ttr.code_eqp = ttr2.code_eqp and ttr2.dt = ttr.dt_b)
    join eqm_point_h as p on (ttr.code_eqp = p.code_eqp)
    join (select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <= dte and coalesce(dt_e,dte) >= dte group by code_eqp) as p2 on (p.code_eqp = p2.code_eqp and p2.dt = p.dt_b)
    join eqm_meter_point_h as mp on (mp.id_point = p.code_eqp)
    join (select id_meter ,max(dt_b) as dt from eqm_meter_point_h where dt_b <= dte and coalesce(dt_e,dte) >= dte group by id_meter) as mp2 
        on (mp.id_meter = mp2.id_meter and mp2.dt = mp.dt_b)
    join eqm_meter_h as m on (m.code_eqp=mp.id_meter )
    join (select code_eqp, max(dt_b) as dt from eqm_meter_h where dt_b <= dte and coalesce(dt_e,dte) >= dte group by code_eqp) as m2 on (m.code_eqp = m2.code_eqp and m2.dt = m.dt_b)
    join eqm_equipment_h as e on (e.id=mp.id_meter )
    join (select id, max(dt_b) as dt from eqm_equipment_h where dt_b <= dte and coalesce(dt_e,dte) >= dte group by id) as e2 on (e.id = e2.id and e2.dt = e.dt_b)

    left join eqm_compens_station_inst_tbl as sci on ( mp.id_point = sci.code_eqp)
    where tr.id_client = r.id_client and (coalesce(sci.code_eqp_inst,0) = r.id_grp or r.id_grp is null);



    from eqv_pnt_met as pm
    join eqm_meter_tbl as m on (m.code_eqp=pm.id_meter ) 
    left join eqm_compens_station_inst_tbl as sci on ( pm.id_point = sci.code_eqp)
    where pm.id_client = r.id_client and (coalesce(sci.code_eqp_inst,0) = r.id_grp or r.id_grp is null);
*/
    Raise Notice ''END_SEL_TREE'';


--del
   Execute ''delete from del_ind;'';


    insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
 
   select a.id as id_ind,b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr 
   from 
    (select * from acd_indication_tbl where id_doc=r.id_doc order by id_meter) as a 
      full outer join
    (select r.id_doc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
      ,a.kind_energy as kind_energy,a.id_zone as id_zone,r.date_end as date_end
      ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
      ,a.carry as carry,a.k_tr as k_tr
      from  (select a1.*,a2.carry from act_met_kndzn_tbl as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp order by id_meter) as a order by id_meter
    ) as b 
      on (a.id_doc=b.id_doc and a.id_meter=b.id_meter and a.num_eqp=b.num_eqp 
          and a.kind_energy=b.kind_energy and a.id_zone=b.id_zone 
          and a.coef_comp=b.k_tr);

Raise Notice ''INS 0'';

    update acd_indication_tbl set dt_del = ''2000-01-01'' 
    from del_ind as a 
     where a.id_doc is null and a.id_ind=acd_indication_tbl.id;

 Raise Notice ''DEL start..'';
    delete from acd_indication_tbl where dt_del = ''2000-01-01''; 

--    delete from acd_indication_tbl where exists (select a.id_ind from del_ind as a 
--     where a.id_doc is null and a.id_ind=acd_indication_tbl.id);

Raise Notice ''DEL'';
--upd
    update acd_indication_tbl set dat_ind=b.date_end,id_typemet=b.id_type_eqp
          ,carry=b.carry,coef_comp=b.k_tr 
    from del_ind as b 
      where b.id_doc is not null and b.id_ind is not null 
           and acd_indication_tbl.id=b.id_ind;

Raise Notice ''UPD-'';
--ins
    update del_ind set id_prv=a.id 
     from (select a1.*,a2.date_end--,a_14.ident 
           from ( select a1.* from 
              (select * from acd_indication_tbl where id_client=client order by id_doc) as a1 
               join (select id_doc from acm_headindication_tbl as a_13 
                join dci_document_tbl as a_14 on (a_13.idk_document=a_14.id) where ident=''beg_ind'' and id_client=client order by id_doc ) as a_13
                 on (a1.id_doc=a_13.id_doc) 
              ) as a1 
            join  (select * from del_ind where id_doc is not null and id_ind is null order by id_meter) as a2 
              on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter 
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)) 
      left join (select * from acd_indication_tbl where id_client=client order by id_previndic) as a3 on (a3.id_previndic=a1.id )
      where a3.id is null) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end;
--       and a.ident=''beg_ind''; --in (''beg_ind'',''chn_cnt'');
--return true;   
Raise Notice ''UPD1- -'';
    update del_ind set id_prv=a.id 
     from (select a1.*,a2.date_end from 
      (select * from acd_indication_tbl where id_client=client and id_cor_doc is null order by id_meter ) as a1 
       join (select * from del_ind where id_doc is not null and id_ind is null order by id_meter) as a2 
       on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter 
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
 --       and a1.id_cor_doc is null 
 --       and a1.dat_ind=(select max(c.dat_ind) from (select * from acd_indication_tbl where id_client=client order by id_meter) as c 
 --        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
 --       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
 --       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)
)
--      join   (select id_client,id_meter,num_eqp,kind_energy,id_zone,mmgg,max(dat_ind) as dat_ind from acd_indication_tbl 
--         where id_client=client group by id_client,id_meter,num_eqp,kind_energy,id_zone,mmgg order by id_meter) as c
--      on (c.id_meter=a2.id_meter and c.num_eqp=a2.num_eqp and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end and a1.dat_ind= c.dat_ind )

      left join (select * from acd_indication_tbl where id_client=client order by id_previndic) as a3 on (a3.id_previndic=a1.id)
      where a3.id is null
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl  as c 
        where 
       --c.id_client=a2.id_client and 
       c.id_meter=a2.id_meter 
       and c.num_eqp=a2.num_eqp 
       --and c.kind_energy=a2.kind_energy  and c.id_zone=a2.id_zone 
       and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end and c.id_client=client)
        
    ) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end 
       and del_ind.id_prv is null;   

Raise Notice ''UPD2'';
    insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
      ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp,id_previndic)
    select id_doc,id_meter,num_eqp,kind_energy,id_zone,date_end,mmgg,id_client
      ,id_type_eqp,carry,k_tr,id_prv from del_ind where id_doc is not null 
      and id_ind is null;
 Raise Notice ''END_....'';
--------------------------------------change------------------------------------------
else
  if r.ident=''chn_cnt'' then
    dtb:=date_mii(r.date_end::date,1);
    dte:=date_mii(r.date_end::date,-1);

      rs:=oabn_tree(r.id_client,dtb,dte); -- § ¬¥­ , ­¥ ¬¥­ïâì !!!

--del
   Execute ''delete from del_ind;'';
    insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
    select a.id as id_ind,b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr from 
    (select * from acd_indication_tbl where id_doc=r.id_doc order by id) as a 
      full outer join
    (select r.id_doc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
      ,a.kind_energy as kind_energy,a.id_zone as id_zone,r.date_end as date_end
      ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
      ,a.carry as carry,a.k_tr as k_tr
    from  (select a1.*,a2.carry from act_met_kndzn_tbl as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp order by a1.id_meter) as a 
         where not (a.dat_b=dtb and a.dat_e=dte)) as b 
      on (a.id_doc=b.id_doc and a.id_meter=b.id_meter and a.num_eqp=b.num_eqp 
          and a.kind_energy=b.kind_energy and a.id_zone=b.id_zone 
         and a.coef_comp=b.k_tr);

--    delete from acd_indication_tbl where exists (select a.id_ind from del_ind as a 
--     where a.id_doc is null and a.id_ind=acd_indication_tbl.id);

    update acd_indication_tbl set dt_del = ''2000-01-01'' 
    from del_ind as a 
     where a.id_doc is null and a.id_ind=acd_indication_tbl.id;

    delete from acd_indication_tbl where dt_del = ''2000-01-01''; 


Raise Notice ''DEL_chn'';
--upd
    update acd_indication_tbl set dat_ind=b.date_end,id_typemet=b.id_type_eqp
          ,carry=b.carry,coef_comp=b.k_tr 
    from del_ind as b 
      where b.id_doc is not null and b.id_ind is not null 
           and acd_indication_tbl.id=b.id_ind;
--ins
    update del_ind set id_prv=a.id 
     from (select a1.*,a2.date_end from acd_indication_tbl as a1 inner join 
          (select * from del_ind where id_doc is not null and id_ind is null) 
      as a2 on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter 
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)) 
      left join acd_indication_tbl as a3 on (a3.id_previndic=a1.id)
      where a3.id is null) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
       and a.date_end=del_ind.date_end 
       and a.coef_comp=del_ind.k_tr;   

 delete from del_ind where 
   exists (select id_meter from (select count(a.*),a.id_client,a.id_meter,a.num_eqp,a.kind_energy
     ,a.id_zone,a.date_end,a.k_tr,a.id_prv from del_ind as a group by a.id_client 
        ,a.id_meter,a.num_eqp,a.kind_energy
        ,a.id_zone,a.date_end,a.k_tr,a.id_prv 
       having count(a.*)>1) as a where a.id_client=del_ind.id_client 
      and a.id_meter=del_ind.id_meter and a.num_eqp=del_ind.num_eqp 
      and a.kind_energy=del_ind.kind_energy and a.id_zone=del_ind.id_zone 
      and a.date_end=del_ind.date_end and a.k_tr=del_ind.k_tr 
      and coalesce(a.id_prv,0)=coalesce(del_ind.id_prv,0));


    insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
      ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp,id_previndic)
    select id_doc,id_meter,num_eqp,kind_energy,id_zone,date_end,mmgg,id_client
      ,id_type_eqp,carry,k_tr,id_prv from del_ind where id_doc is not null 
      and id_ind is null;

---del needless records
/*
    delete from acd_indication_tbl where id_previndic is null 
     and id in (select id from acd_indication_tbl as a inner join (select count(id) as cnt
     ,id_meter,num_eqp,id_doc from acd_indication_tbl where id_doc=r.id_doc 
     group by id_meter,num_eqp,id_doc having count(id)>1) as b on (a.id_meter=b.id_meter 
     and a.num_eqp=b.num_eqp and a.id_doc=b.id_doc)); 
  */
    else 
      if r.ident=''beg_ind'' then

        rs:=oabn_tree_res(r.id_client,dtb,dte,r.id_grp);
/*
    delete from act_met_kndzn_tbl;

    insert into act_met_kndzn_tbl (id_point,id_meter,num_eqp,kind_energy,id_zone,k_tr,id_type_eqp,dat_b,dat_e)
    select id_point, id_meter, num_eqp,1 as kind_energy,0 as id_zone,koef_tt*koef_tu as k_tr, m.id_type_eqp,dtb,dte
    from eqv_pnt_met as pm
    join eqm_meter_tbl as m on (m.code_eqp=pm.id_meter ) 
    left join eqm_compens_station_inst_tbl as sci on ( pm.id_point = sci.code_eqp)
    where pm.id_client = r.id_client and (coalesce(sci.code_eqp_inst,0) = r.id_grp or r.id_grp is null);
*/
    Raise Notice ''END_SEL_TREE'';

--del
   Execute ''delete from del_ind;'';
    insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
    select a.id as id_ind,b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr from 
    (select * from acd_indication_tbl where id_doc=r.id_doc order by id) as a 
      full outer join
    (select r.id_doc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
      ,a.kind_energy as kind_energy,a.id_zone as id_zone,r.date_end as date_end
      ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
      ,a.carry as carry,a.k_tr as k_tr
    from  (select a1.*,a2.carry from act_met_kndzn_tbl as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp) as a ) as b 
      on (a.id_doc=b.id_doc and a.id_meter=b.id_meter and a.num_eqp=b.num_eqp 
          and a.kind_energy=b.kind_energy and a.id_zone=b.id_zone 
           and a.coef_comp=b.k_tr);

--    delete from acd_indication_tbl where exists (select a.id_ind from del_ind as a 
--     where a.id_doc is null and a.id_ind=acd_indication_tbl.id);

    update acd_indication_tbl set dt_del = ''2000-01-01'' 
    from del_ind as a 
     where a.id_doc is null and a.id_ind=acd_indication_tbl.id;

    delete from acd_indication_tbl where dt_del = ''2000-01-01''; 


Raise Notice ''DEL_beg'';
--upd
    update acd_indication_tbl set dat_ind=b.date_end,id_typemet=b.id_type_eqp
          ,carry=b.carry,coef_comp=b.k_tr 
    from del_ind as b 
      where b.id_doc is not null and b.id_ind is not null 
           and acd_indication_tbl.id=b.id_ind;
--ins
    insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
      ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp,id_previndic)
    select id_doc,id_meter,num_eqp,kind_energy,id_zone,date_end,mmgg,id_client
      ,id_type_eqp,carry,k_tr,id_prv from del_ind where id_doc is not null 
      and id_ind is null;

      end if;
    end if;
  end if;

--raise notice ''add_inddifzone'';
--i=add_inddifzone(idind,dte);

/*          
for ind in select acd_indication_tbl.* from acd_indication_tbl  ,del_ind   
 where acd_indication_tbl.id_doc=del_ind.id_doc loop
raise notice ''add_in_222'';
 
update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=ind.id_meter 
        and num_eqp=ind.num_eqp and kind_energy=ind.kind_energy 
       and id_zone=ind.id_zone and ind.dat_ind>=dt_insp 
        order by dat_ind desc limit 1 ) 
where id=ind.id;  
end loop;
*/

/*
for ind in select di.* from acd_indication_tbl as di  join del_ind   
 on( di.id_doc=del_ind.id_doc and di.id = del_ind.id_ind )
loop
raise notice ''add_in_2221'';
 
update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=ind.id_meter 
        and num_eqp=ind.num_eqp and kind_energy=ind.kind_energy 
       and zone=ind.id_zone and ind.dat_ind>=dt_insp 
        order by dat_ind desc limit 1 ) 
where id=ind.id;  
end loop; 
*/

end loop;
Return true;
end;
' Language 'plpgsql';
