update clm_renthist_tbl set flag=0 where flag is null;

create or replace function seb_renthist_fun(date) returns boolean as 
'
declare 
  pmmgg Alias for $1;
  p record;
  p1 record;
  pr boolean;
begin
raise notice ''renthist'';

select   into p  * from seb_renthist_tbl where mmgg=pmmgg limit 1;
if found then
 select   into p1  * from seb_renthist_tbl where mmgg=pmmgg and flock=1 limit 1;
 if found then
   raise notice ''all renthist formed'';
   return true;
  end if;
end if;   
delete from seb_renthist_tbl 
where mmgg=pmmgg and (flock<>1 or flock is null) ;

insert into seb_renthist_tbl(mmgg,id_client,id_point,id_addres,name_object,flag)
select  pmmgg,id_client,id_point,id_addres,name_object,flag  from clm_renthist_tbl; 

update seb_renthist_tbl set dt_rent_end=e.dt_rent_end
  from
  (select id_client,id_point,id_addres,name_object,flag,max(dt_rent_end) as dt_rent_end
    from clm_renthist_tbl  group by id_client,id_point,id_addres,name_object,flag
 ) e 
 where seb_renthist_tbl.mmgg=pmmgg
 and seb_renthist_tbl.id_client=e.id_client
  and 
 (seb_renthist_tbl.id_point=e.id_point or seb_renthist_tbl.id_point is null) and 
 (seb_renthist_tbl.id_addres=e.id_addres  or seb_renthist_tbl.id_addres is null)
  and coalesce(seb_renthist_tbl.name_object,'''')=coalesce(e.name_object,'''') and seb_renthist_tbl.flag=e.flag;


update seb_renthist_tbl set comment=e.comment from clm_renthist_tbl e
where seb_renthist_tbl.mmgg=pmmgg and seb_renthist_tbl.id_client=e.id_client
   and (seb_renthist_tbl.id_point=e.id_point or seb_renthist_tbl.id_point is null) and seb_renthist_tbl.id_addres=e.id_addres 
   and seb_renthist_tbl.name_object=e.name_object 
 and seb_renthist_tbl.dt_rent_end=e.dt_rent_end  and seb_renthist_tbl.flag=e.flag;


update seb_renthist_tbl set  dt_last_ind=d_ind 
 from (select id_point,id_client,max(dat_ind)::date as d_ind 
  from
    (select eqv_pnt_met.id_point, eqv_pnt_met.id_client, e.dat_ind  
         from    acd_indication_tbl e left join eqv_pnt_met  
          on eqv_pnt_met.id_meter=e.id_meter
    ) e2 
    group by id_point,id_client
) e1
where seb_renthist_tbl.mmgg=pmmgg 
 and  seb_renthist_tbl.id_client=e1.id_client
 and seb_renthist_tbl.id_point=e1.id_point;
--;

return true;

end;
' language 'plpgsql';
