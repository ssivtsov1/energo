drop function start_calc(int,int,date);
create function start_calc(int,int,date) Returns boolean As'
Declare
id_cl Alias for $1;
iddc Alias for $2;
m_g Alias for $3;
r record;
r1 record;
rs boolean;
rs1 boolean;
dte date;
dtb date;
dt_add int;
mg date;
idind int;
idcl int;
s int;
idres int;
idbal int;
cnt int;
begin
rs:=false;
delete from act_res_notice;

delete from sys_error_tmp;
select into idres int4(value_ident) from syi_sysvars_tbl where ident=''id_res'';
select into idbal int4(value_ident) from syi_sysvars_tbl where ident=''id_bal'';

if ((idres<>id_cl)  and (id_cl  not in (select id from clm_client_tbl where flag_balance=1))) then
-----go
if iddc is not null then
  for r in select * from acm_headindication_tbl where id_doc=iddc and 
             id_client=id_cl and idk_document=(select id from dci_document_tbl 
             where ident=''rep_pwr'') limit 1 loop
    mg:=r.mmgg;
    idind:=r.id_doc;
    idcl:=r.id_client;
    dte:=r.date_end;
    select into dtb max(date_end) from (select * from acm_headindication_tbl 
      where id_client=idcl) as a left join (select * from acm_bill_tbl 
      where id_client=idcl) as b on a.id_doc=b.id_ind 
      where a.date_end<dte and ((a.idk_document in (select id from dci_document_tbl 
       where ident in (''rep_pwr'',''kor_ind'')) and b.id_ind notnull) 
       or a.idk_document in (select id from dci_document_tbl where ident=''beg_ind''));
    if (dtb is null) then --min(date_end)
      select into dtb max(dat_e) 
               from (select min(date_end) as dat_e,a.idk_document from (select * from 
       acm_headindication_tbl where id_client=idcl) as a left join 
       (select * from acm_bill_tbl where id_client=idcl) as b 
        on a.id_doc=b.id_ind where a.date_end<dte and a.idk_document in 
         (select id from dci_document_tbl where ident in (''rep_pwr''
            ,''kor_ind'')) group by a.idk_document) as k; 
   end if;
   if dtb is not null then
     select into dt_add coalesce((coalesce(case when dt_start=0 then null 
       else dt_start end,dt_indicat)-case when (dt_indicat=31 
           and coalesce(dt_start,dt_indicat)<>dt_indicat)
          then 0 else dt_indicat end),0)  from (select max(doc_dat) 
         as doc_dat,id_client from clm_statecl_tbl where id_client=idcl 
         and doc_num is not null group by id_client) as a left join 
         clm_statecl_tbl as c on (c.id_client=a.id_client 
         and c.doc_dat=a.doc_dat);
     if dt_add is null then
       dt_add:=0;
     end if;
     if (select (substr(value_ident,7,4)||''-''||substr(value_ident,4,2)||
      ''-''||substr(value_ident,1,2))::date as mmgg 
         from syi_sysvars_tbl where ident=''mmgg'')<=mg then
      select into cnt count(*) from acm_bill_tbl as a where a.id_client=idcl 
        and a.id_ind<>idind and a.mmgg>=mg and dat_e>dte and idk_doc=200;
      if cnt=0 then 
       delete from acm_bill_tbl where id_ind=idind and id_client=idcl;

       Execute ''select del_eqtmp_t(0,0);'';

       if dt_add>31 then
         dt_add=1;
       end if;          
       dte:=date_mii(dte,-dt_add); 
       dtb:=date_mii(dtb,-dt_add);
Raise Notice ''dte - %'',dte;
Raise Notice ''dtb - %'',dtb;
Raise Notice ''dt_add - %'',dt_add;
       rs:=mabn_tree(idcl,dtb,dte,dt_add,mg);
       if rs then
       rs:=clc_abn(idcl,dtb,dte);
       RAISE NOTICE ''idcl %  dt_b  % dte % '',idcl,dtb,dte;
       RAISE NOTICE ''RS %'',RS;
       if rs then 


         rs:=false;
        for r1 in select distinct case when kind_energy in (2,4) then 2 
           else kind_energy end as kind_energy from act_pwr_demand_tbl as a inner join 
           act_point_branch_tbl as b on (a.id_point=b.id_point) where b.id_client=idcl loop

          s:=abn_bill(idcl,idind,r1.kind_energy,mg,dtb,dte,dt_add);
          RAISE NOTICE ''idcl % idind %, r1.kind_energy %, mg %,dtb %,dte %, dt_add %'',idcl,idind,r1.kind_energy,mg,dtb,dte,dt_add;
          RAISE NOTICE ''S %'',S;
 
         if s is null then
            Raise Notice ''Bill was not created'';
            insert into act_res_notice values(''Bill was not created with energy - ''||r1.kind_energy);
           -- rs:=false;
          else
            Raise Notice ''Was created bill with energy - %'',r1.kind_energy;
            insert into act_res_notice values(''Bill was created with energy - ''||r1.kind_energy);
--            perform acm_createtaxcorrect(s);
            rs:=true;
          end if;
        end loop;
       else 
         Raise notice ''Calc not complited'';
         insert into act_res_notice values(''Calc not complited'');
         Return false;
       end if;
      else
       Raise Notice ''False'';
        Return false;
      end if;
     else      
       Raise notice ''NEXT BILL FOR THIS CLIENT EXISTS!!! CANT DO THE CALCULATION!!!'';
       insert into act_res_notice values(''NEXT BILL FOR THIS CLIENT EXISTS!!! CANT DO THE CALCULATION!!!'');
       Return false;
     end if;

     else 
     Raise Notice ''Period is closed!'';
     insert into act_res_notice values(''Period is closed!'');
     Return false;
     end if;
   else
     Raise Notice ''Begin indications not present!!!'';
     insert into act_res_notice values(''Begin indications not present!!!'');
     Return false;
   end if; 
  end loop;

else 
  if m_g is null then
    Raise Notice ''Not full parameters for calc!!!'';
    insert into act_res_notice values(''Not full parameters for calc!!!'');
    Return false;
  else 
  end if;
end if;
else 
 rs:=false;
 Raise Notice ''no bill for RES!!!'';
 insert into act_res_notice values(''no bill for RES!!!'');
end if;
Return rs;
end;
' Language 'plpgsql'; 

