--alter table acd_indication_tbl add column id_inspect int;

ALTER TABLE acd_indication_tbl ADD COLUMN indic_edit_enabled integer;
ALTER TABLE acd_indication_tbl ALTER COLUMN indic_edit_enabled SET DEFAULT 1;

CREATE INDEX ss_pos_num
  ON ss_pok
  USING btree
  (z_num);


ALTER TABLE ss_met
  ADD CONSTRAINT ss_met_pkey PRIMARY KEY(id);

CREATE INDEX ss_met_num
  ON ss_met
  USING btree
  (z_num);


-- Function: inp_ind(integer)

-- DROP FUNCTION inp_ind(integer);

CREATE OR REPLACE FUNCTION inp_ind(integer)
  RETURNS boolean AS
$BODY$
Declare
idind Alias for $1;
dte date;
ddd int; 
dtb date;
client int;
r record;
r1 record;
rr record;
vmeter record;
rs boolean;
strsql text;
ind record;
strsql1 text;
lost_ind int;
lost_ind1 record;
i int;
vid int;
vcnt int;
vid_res int;
vdel_record int;
vedit_enable int;
flag_meter varchar;
begin
---sel calc period
--delete from act_ch_err;
rs:=del_eqtmp_t(0,0);
strsql1:='';
vid_res := syi_resid_fun(); 


for r in select a.*,b.ident from acm_headindication_tbl as a left join 
           dci_document_tbl as b on a.idk_document=b.id where id_doc=idind loop 
Raise Notice 'IDENT - %',r.ident;
dtb:=date_mii(r.date_end::date,1);
dte:=r.date_end;
client=r.id_client;
Raise Notice 'DTB - %',dtb;
Raise Notice 'DTE - %',dte;

for lost_ind1 in select distinct acd_indication_tbl.id_doc 
  from acd_indication_tbl 
    left join acm_headindication_tbl  on 
       (acd_indication_tbl.id_doc=acm_headindication_tbl.id_doc) 
         where acm_headindication_tbl.id_doc is null 
                and acd_indication_tbl.flock<>1  and 
              acd_indication_tbl.id_client=r.id_client
    loop 
    Raise Notice 'doc_ind - %',lost_ind1.id_doc;
    --Raise Notice 'cl - %',lost_ind1.id_client;
    delete from acd_indication_tbl where id_doc= lost_ind1.id_doc;

end loop;

  
  --'beg_ind','kor_ind','rep_pwr','chn_cnt','act_chn','act_pwr','act_check','rep_avg'
if r.ident in ('kor_ind','rep_pwr','rep_bound') then
      rs:=oabn_tree(r.id_client,dtb,dte);
     Raise Notice 'END_SEL_TREE';
    --del
   Execute 'delete from del_ind;';
   insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
--     select coalesce(a.id, nextval('acd_indication_seq') ) as id_ind,
    select a.id as id_ind,
    b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr from 
    (select * from acd_indication_tbl where id_doc=r.id_doc) as a 
      full outer join
    (select r.id_doc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
      ,a.kind_energy as kind_energy,a.id_zone as id_zone,r.date_end as date_end
      ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
      ,a.carry as carry,a.k_tr as k_tr
    from  (select a1.*,a2.carry from act_met_kndzn_tbl as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp) as a ) as b 
      on (a.id_doc=b.id_doc and a.id_meter=b.id_meter and a.num_eqp=b.num_eqp 
          and a.kind_energy=b.kind_energy and a.id_zone=b.id_zone  and a.id_typemet=b.id_type_eqp
          and a.coef_comp=b.k_tr);

     ddd:=1;
       Raise Notice 'ddd - %',ddd;
    
/*for ddd in select id_ind::int from del_ind
       loop
       Raise Notice 'ddd - %',ddd;
       ddd:=1;
     end loop;
  */  
    Raise Notice 'DEL';
    --upd

    update acd_indication_tbl set dat_ind=b.date_end,id_typemet=b.id_type_eqp
          ,carry=b.carry,coef_comp=b.k_tr 
    from del_ind as b 
      where b.id_doc is not null and b.id_ind is not null 
           and acd_indication_tbl.id=b.id_ind;
    Raise Notice 'UPD';
    --ins

    update del_ind set id_prv=a.id 
     from (select a1.*,a2.date_end,a_14.ident 
           from ((select * from acd_indication_tbl where id_client=client) as a1 inner join 
            acm_headindication_tbl as a_13 on (a1.id_doc=a_13.id_doc) inner join 
             dci_document_tbl as a_14 on (a_13.idk_document=a_14.id)) inner join 
          (select * from del_ind where id_doc is not null and id_ind is null) 
      as a2 on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter     and a1.id_typemet=a2.id_type_eqp
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter          and c.id_typemet=a2.id_type_eqp
       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)) 
      left join (select * from acd_indication_tbl where id_client=client) as a3 on (a3.id_previndic=a1.id )
      where a3.id is null) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
     and  a.id_typemet=del_ind.id_type_eqp
       and a.id_zone=del_ind.id_zone 
       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end
       and a.ident='beg_ind'; --in ('beg_ind','chn_cnt');
     --return true;   
/*    Raise Notice 'UPD1';
    update del_ind set id_prv=a.id 
     from (select a1.*,a2.date_end from 
      (select * from acd_indication_tbl where id_client=client) as a1 inner join 
          (select * from del_ind where id_doc is not null and id_ind is null) 
      as a2 on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter 
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from (select * from acd_indication_tbl where id_client=client) as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)) 
      left join (select * from acd_indication_tbl where id_client=client) as a3 on (a3.id_previndic=a1.id)
      where a3.id is null) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end 
       and del_ind.id_prv is null;   
  */
Raise Notice 'UPD1- -';
    update del_ind set id_prv=a.id 
     from (select a1.*,a2.date_end from 
      (select * from acd_indication_tbl where id_client=client and id_cor_doc is null order by id_meter ) as a1 
       join (select * from del_ind where id_doc is not null and id_ind is null order by id_meter) as a2 
       on (a1.id_client=a2.id_client and a1.id_meter=a2.id_meter   and a1.id_typemet=a2.id_type_eqp
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy 
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
 --       and a1.id_cor_doc is null 
 --       and a1.dat_ind=(select max(c.dat_ind) from (select * from acd_indication_tbl where id_client=client order by id_meter) as c 
 --        where c.id_client=a2.id_client and c.id_meter=a2.id_meter 
 --       and c.num_eqp=a2.num_eqp and c.kind_energy=a2.kind_energy 
 --       and c.id_zone=a2.id_zone and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end)
)
 --     join   (select id_client,id_meter,num_eqp,kind_energy,id_zone,mmgg,max(dat_ind) as dat_ind from acd_indication_tbl 
 --        where id_client=client group by id_client,id_meter,num_eqp,kind_energy,id_zone,mmgg order by id_meter) as c
  --    on (c.id_meter=a2.id_meter and c.num_eqp=a2.num_eqp and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end and a1.dat_ind= c.dat_ind )
      left join (select * from acd_indication_tbl where id_client=client order by id_previndic) as a3 on (a3.id_previndic=a1.id)
      where a3.id is null
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl  as c 
        where 
       --c.id_client=a2.id_client and 
       c.id_meter=a2.id_meter 
      and c.num_eqp=a2.num_eqp 
       and c.kind_energy=a2.kind_energy  and c.id_zone=a2.id_zone          and c.id_typemet=a2.id_type_eqp
       and c.mmgg<=a2.mmgg and c.dat_ind<a2.date_end and c.id_client=client)
        
    ) as a 
    where a.id_client=del_ind.id_client 
       and a.id_meter=del_ind.id_meter 
       and a.num_eqp=del_ind.num_eqp 
       and a.kind_energy=del_ind.kind_energy 
       and a.id_zone=del_ind.id_zone 
     and  a.id_typemet=del_ind.id_type_eqp

       and a.coef_comp=del_ind.k_tr 
       and a.date_end=del_ind.date_end 
       and del_ind.id_prv is null;   
    
     Raise Notice 'UPD2';
    insert into acd_indication_tbl(id_doc,id_meter,num_eqp,kind_energy,id_zone
      ,dat_ind,mmgg,id_client,id_typemet,carry,coef_comp,id_previndic)
    select id_doc,id_meter,num_eqp,kind_energy,id_zone,date_end,mmgg,id_client
      ,id_type_eqp,carry,k_tr,id_prv from del_ind where id_doc is not null 
      and id_ind is null;
    Raise Notice 'END_....';


else
  if r.ident='chn_cnt' then
    dtb:=date_mii(r.date_end::date,1);
    dte:=date_mii(r.date_end::date,-1);
     rs:=oabn_tree(r.id_client,dtb,dte);
    --del
   Execute 'delete from del_ind;';
    insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
    select a.id as id_ind,b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr from 
    (select * from acd_indication_tbl where id_doc=r.id_doc) as a 
      full outer join
    (select r.id_doc as id_doc,a.id_meter as id_meter,a.num_eqp as num_eqp
      ,a.kind_energy as kind_energy,a.id_zone as id_zone,r.date_end as date_end
      ,r.mmgg as mmgg,r.id_client as id_client,a.id_type_eqp as id_type_eqp
      ,a.carry as carry,a.k_tr as k_tr
    from  (select a1.*,a2.carry from act_met_kndzn_tbl as a1 left join 
          eqi_meter_tbl as a2 on a2.id=a1.id_type_eqp) as a 
         where not (a.dat_b=dtb and a.dat_e=dte)) as b 
      on (a.id_doc=b.id_doc and a.id_meter=b.id_meter and a.num_eqp=b.num_eqp 
          and a.kind_energy=b.kind_energy and a.id_zone=b.id_zone     and a.id_typemet=b.id_type_eqp
         and a.coef_comp=b.k_tr);

/*    delete from acd_indication_tbl where exists (select a.id_ind from del_ind as a 
     where a.id_doc is null and a.id_ind=acd_indication_tbl.id);
  */
    update acd_indication_tbl set dt_del = '2000-01-01' 
    from del_ind as a 
     where a.id_doc is null and a.id_ind=acd_indication_tbl.id;

 Raise Notice 'DEL start..';
    delete from acd_indication_tbl where dt_del = '2000-01-01'; 

    Raise Notice 'DEL_chn';
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
       and a1.num_eqp=a2.num_eqp and a1.kind_energy=a2.kind_energy and a1.id_typemet=a2.id_type_eqp
       and a1.id_zone=a2.id_zone and a1.mmgg<=a2.mmgg 
       and a1.id_cor_doc is null 
       and a1.dat_ind=(select max(c.dat_ind) from acd_indication_tbl as c 
        where c.id_client=a2.id_client and c.id_meter=a2.id_meter          and c.id_typemet=a2.id_type_eqp
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
   -- if meter new - previndic not is able

raise notice 'not prewindic for install meter';
update del_ind set id_prv=null from 
 (select del_ind.* from del_ind  join (select e.* from eqm_meter_h m,eqm_equipment_h e where  e.id=m.code_eqp  and e.dt_b=m.dt_b) c
 on del_ind.id_meter=c.id and c.num_eqp=del_ind.num_eqp and del_ind.date_end=c.dt_b and c.dt_e is null
 ) n where n.id_meter=del_ind.id_meter and n.num_eqp=del_ind.num_eqp and 
   n.kind_energy=del_ind.kind_energy and n.id_zone=del_ind.id_zone;  

 delete from del_ind where 
   exists (select id_meter from 
            (select count(a.*),a.id_client,a.id_meter,a.num_eqp,a.kind_energy
              ,a.id_zone,a.date_end,a.k_tr,a.id_prv 
              from del_ind as a group by a.id_client 
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
    else 
      if r.ident='beg_ind' then
        rs:=oabn_tree(r.id_client,dtb,dte);
--del
   Execute 'delete from del_ind;';
    insert into del_ind(id_ind,id_doc,id_meter,num_eqp,kind_energy,id_zone
     ,date_end,mmgg,id_client,id_type_eqp,carry,k_tr) 
    select a.id as id_ind,b.id_doc,b.id_meter,b.num_eqp,b.kind_energy,b.id_zone
     ,b.date_end,b.mmgg,b.id_client,b.id_type_eqp,b.carry,b.k_tr from 
    (select * from acd_indication_tbl where id_doc=r.id_doc) as a 
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

    delete from acd_indication_tbl where exists (select a.id_ind from del_ind as a 
     where a.id_doc is null and a.id_ind=acd_indication_tbl.id);
Raise Notice 'DEL_beg';
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
raise notice 'add_inddifzone';
i=add_inddifzone(idind,dte);


for ind in select di.* from acd_indication_tbl as di  join del_ind 
 on( di.id_doc=del_ind.id_doc and 
       di.id_meter=del_ind.id_meter  and  di.num_eqp=del_ind.num_eqp and 
       di.kind_energy=del_ind.kind_energy 
       and del_ind.id_zone=di.id_zone
      --di.id = del_ind.id_ind 

)
loop
raise notice 'add_in_2221';
 
 update acd_indication_tbl set id_inspect=
  (select id from acm_inspectstr_tbl where id_meter=ind.id_meter 
        and num_eqp=ind.num_eqp and kind_energy=ind.kind_energy 
       and zone=ind.id_zone and ind.dat_ind>=dt_insp  and value is not null
        order by dt_insp desc limit 1 ) 
 where id=ind.id;        

 update acd_indication_tbl set last_work_ind_id = 
  (select wi.id from clm_work_indications_tbl as wi join clm_works_tbl as w on (w.id = wi.id_work)
       where wi.id_meter=ind.id_meter 
       and wi.num_eqp=ind.num_eqp and wi.kind_energy=ind.kind_energy 
       and wi.id_zone=ind.id_zone and w.dt_work<=ind.dat_ind  
        order by w.dt_work desc limit 1 ) 
 where id=ind.id;        


end loop; 

if r.ident in ('kor_ind','rep_pwr','rep_bound') then
update acd_indication_tbl set value=a.indic,
      value_dev=calc_ind_pr(coalesce(a.indic,0),coalesce(a1.value,0),acd_indication_tbl.carry),  
      value_dem=case when calc_ind_pr(coalesce(a.indic,0),coalesce(a1.value,0),acd_indication_tbl.carry)*acd_indication_tbl.coef_comp<9999999999 then 
              calc_ind_pr(coalesce(a.indic,0),coalesce(a1.value,0),acd_indication_tbl.carry)*acd_indication_tbl.coef_comp 
        else  -9999999999 end
,
        id_askue=a.id  
  from ask_indic_tbl a,acd_indication_tbl a1

 where acd_indication_tbl.id_meter=a.id_meter 
       and acd_indication_tbl.id_previndic=a1.id 
    and  acd_indication_tbl.num_eqp=a.num_meter
    and acd_indication_tbl.kind_energy=a.kind_energy and acd_indication_tbl.id_zone=a.id_zone
    and a.id_time=0 and acd_indication_tbl.dat_ind=a.date_ind and 
     acd_indication_tbl.id_client=a.id_client 
     AND acd_indication_tbl.value is null
     AND acd_indication_tbl.id_DOC=idind;

update acd_indication_tbl set value=a.indic,
        id_askue=a.id  
  from ask_indic_tbl a

 where acd_indication_tbl.id_meter=a.id_meter 
    and  translate(trim(acd_indication_tbl.num_eqp),'[,._-=]','')=a.num_meter
    and acd_indication_tbl.kind_energy=a.kind_energy and acd_indication_tbl.id_zone=a.id_zone
    and a.id_time=0 and acd_indication_tbl.dat_ind=a.date_ind and 
     acd_indication_tbl.id_client=a.id_client 
     AND acd_indication_tbl.value is null
     AND acd_indication_tbl.id_DOC=idind;

end if;

delete from acd_indication_tbl where id_doc= idind and id_zone is null; 




if (r.ident ='chn_cnt') and (r.id_client <> vid_res ) then

  raise notice 'rrrr';
/*
  update acd_indication_tbl set value =m.val_pokaz, indic_edit_enabled = 0 from 
  (select m.*,p.kind_energy,p.id_zone,p.val_pokaz from ss_met m join ss_pok p on (m.id=p.state_met)
   join (select z_num,kind_energy,id_zone,met_type,max(dt_pokaz) as dt_pokaz from ss_pok group by z_num,kind_energy,id_zone,met_type) as p2
   on (p.z_num = p2.z_num and p.kind_energy = p2.kind_energy and p.id_zone = p2.id_zone and p.met_type=p2.met_type and p.dt_pokaz = p2.dt_pokaz )
  ) as m 
   where acd_indication_tbl.id_doc= idind 
   and acd_indication_tbl.id_previndic is null 
  and trim(regexp_replace(trim(acd_indication_tbl.num_eqp),'(\\.|,|-|_)$',''))::varchar =m.z_num 
  and acd_indication_tbl.kind_energy=m.kind_energy and acd_indication_tbl.id_zone=m.id_zone;
*/
  update acd_indication_tbl set value =m.val_pokaz, indic_edit_enabled = 0 from 
  (select m.*,p.kind_energy,p.id_zone,p.val_pokaz from ss_met m join ss_pok p on (m.id=p.state_met)
   join (select z_num,kind_energy,id_zone,met_type,max(dt_pokaz) as dt_pokaz from ss_pok group by z_num,kind_energy,id_zone,met_type) as p2
   on (p.z_num = p2.z_num and p.kind_energy = p2.kind_energy and p.id_zone = p2.id_zone and p.met_type=p2.met_type and p.dt_pokaz = p2.dt_pokaz ) order by m.z_num
  ) as m 
   where acd_indication_tbl.id_doc= idind 
   and acd_indication_tbl.id_previndic is null 
  and ( trim(acd_indication_tbl.num_eqp) =m.z_num 
       or trim(acd_indication_tbl.num_eqp) =(m.z_num||'.')::varchar 
       or trim(acd_indication_tbl.num_eqp) =(m.z_num||',')::varchar
       or trim(acd_indication_tbl.num_eqp) =(m.z_num||'_')::varchar
       or trim(acd_indication_tbl.num_eqp) =(m.z_num||'-')::varchar   
        )
  and acd_indication_tbl.kind_energy=m.kind_energy and acd_indication_tbl.id_zone=m.id_zone and met_type=acd_indication_tbl.id_typemet;

  raise notice 'rrrr2';

  for rr in 
   select * from acd_indication_tbl where id_doc= idind and id_previndic is null --and value is null
  loop 

   vdel_record:=0;
   vedit_enable:=0;

   select into vmeter * from eqm_equipment_h 
   where id = rr.id_meter and dt_e = rr.dat_ind;

   if found then 
 
     if trim(regexp_replace(trim(vmeter.num_eqp),'(\\.|,|-|_)$',''))::varchar <> trim(regexp_replace(trim(rr.num_eqp),'(\\.|,|-|_)$',''))::varchar 
     then 

--        update acd_indication_tbl set flock=-1 where id = rr.id and value is null;
       vdel_record:=1;
     else
       vedit_enable:=1;	
     end if;
   else
    vedit_enable:=1;
   end if;



   select into vid id from ss_met where ss_met.z_num = trim(regexp_replace(trim(rr.num_eqp),'(\\.|,|-|_)$',''))::varchar and 
	ss_met.met_type= rr.id_typemet;

   if found then

     select into vcnt count(*) as cnt from ss_pok 
       where ss_pok.z_num = trim(regexp_replace(trim(rr.num_eqp),'(\\.|,|-|_)$',''))::varchar and 
       ss_pok.met_type= rr.id_typemet and ss_pok.id_zone <> 0;

     if (vcnt>0) or (rr.id_zone<>0) then
       vdel_record:=0;
       vedit_enable:=1;
     end if;


   end if; 

   if rr.id_typemet in (10623,7082,10630,10625,10624,7083,10626) then
       vedit_enable:=1;
   end if;    



   if (vdel_record=1) then
        update acd_indication_tbl set flock=-1 where id = rr.id and value is null;
   else

     if (vedit_enable=1) then
	update acd_indication_tbl set indic_edit_enabled=1 where id = rr.id;
     end if;

   end if;


  end loop;
raise notice ' chmeter '; 
 select into flag_meter value_ident from syi_sysvars_tbl where ident='flag_chmeter';
raise notice ' chmeter % ',flag_meter; 
  if flag_meter is null or flag_meter='1' then

  delete from acd_indication_tbl where id_doc= idind  and id_previndic is null and value is null and flock=-1;
  end if;
end if;

end loop;


update acd_indication_tbl set id_cabinet=c.id from acd_cabindication_tbl c 
 where acd_indication_tbl.mmgg=c.mmgg and acd_indication_tbl.id_client=c.id_client 
       and acd_indication_tbl.id_meter=c.id_meter and acd_indication_tbl.id_zone=c.id_zone
 and acd_indication_tbl.kind_energy=c.kind_energy
 and acd_indication_tbl.id_doc=idind
   and (acd_indication_tbl.dat_ind=c.dat_ind or c.dat_ind is null);

Return true;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION inp_ind(integer) OWNER TO "local";


drop function inp_ind_add(int);

create or replace function inp_ind_add(int) Returns boolean As'
Declare
idind Alias for $1;
r record;
r1 record;
r2 record;
begin
for r in select * from acm_headdem_tbl where id_doc=idind loop
raise notice ''1'';
 select * into r1 from acm_demand_tbl where id_doc=idind;
 if not found then
  select * into r2 from clm_statecl_h 
   where id_client=r.id_client and mmgg_b<=bom(r.reg_date) 
   and (mmgg_e>=eom(r.reg_date) or mmgg_e is null )order by mmgg_b;
  if found then
  raise notice ''2'';
   insert into acm_demand_tbl (id_doc,dt_b,dt_e,sum_demand,sum_tax ) values 
     (idind,bom(r.reg_date),eom(r.reg_date),r2.pre_pay_grn,round(r2.pre_pay_grn/5.00,2));
  end if;
raise notice ''3'';
 end if;
raise notice ''4'';
end loop;
Return true;
end;
' Language 'plpgsql';
 
