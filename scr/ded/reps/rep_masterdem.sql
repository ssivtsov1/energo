;
set client_encoding = 'win';

create table rep_point_master_tbl (
	id_client int,
	id_point int,
        id_master_client int
        --primary key (id_point,id_master_client ) 
 );

ALTER TABLE rep_point_master_tbl ADD COLUMN id_point_tree integer;
ALTER TABLE rep_point_master_tbl ADD COLUMN id_master_tree integer;

/*
create or replace function rep_point_master_fun(date) Returns boolean As'
Declare
pdt Alias for $1;

r record;
rr record;
rs boolean;
id_res int;
parent int;
dubl   int;
fider  int;
grp record;
vclient int;
vclient2 int;
vclient_last int;

child record;
child_code int;
v boolean; 

begin


 delete from rep_point_master_tbl;
 

 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
  
 for r in 
   Select distinct t.id as id_tree, cl.id as id_client,tt.code_eqp,tt.code_eqp_e 
    From eqm_point_h AS eq 
    join (select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <=  pdt and coalesce(dt_e, pdt) >=  pdt group by code_eqp order by code_eqp ) as p2 on (eq.code_eqp = p2.code_eqp and p2.dt = eq.dt_b) 
    join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.code_eqp )
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e, pdt) >= pdt group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
    join eqm_tree_h AS t on (t.id=tt.id_tree )
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <=  pdt and coalesce(dt_e,  pdt) >= pdt group by id order by id) as t2 on (t.id = t2.id and t2.dt = t.dt_b) 
    left join  ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h  where dt_b <=  pdt and coalesce(dt_e, pdt) >=  pdt group by code_eqp order by code_eqp ) as u2 
     on (u1.code_eqp = u2.code_eqp and u2.dt = u1.dt_b) 
     where coalesce(dt_b,now()) <>coalesce( dt_e, now())
    ) as use on (use.code_eqp = eq.code_eqp) 
    join clm_client_tbl as cl on (coalesce(use.id_client,t.id_client) = cl.id)
    WHERE cl.id<>id_res and cl.book =-1  
 loop

   Raise Notice ''Start %'',r.code_eqp;

   parent :=r.code_eqp_e;

   dubl :=0; 
   fider:=0;

   -----------------------------------------------------------------------

   if (r.code_eqp_e is not NULL) then

     vclient_last:=0;

     LOOP
    
       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,tt.id_tree,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp
       from eqm_equipment_h as eq 
       join (select id, max(dt_b) as dt from eqm_equipment_h  where  id = parent and dt_b <=  pdt and coalesce(dt_e, pdt) >= pdt group by id order by id ) as eq3 on (eq.id = eq3.id and eq3.dt = eq.dt_b) 
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL )
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where code_eqp = parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt and code_eqp_e is not NULL group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
       left join 
       (select inst.* from eqm_compens_station_inst_h as inst 
          join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where code_eqp = parent and coalesce(dt_e,pdt) >= pdt group by code_eqp_inst,code_eqp order by code_eqp_inst) as inst2 
          on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b) 
       ) as st on (eq.id = st.code_eqp )
       left join 
       (select eq3.* from eqm_equipment_tbl as eq3 join eqm_area_tbl as aa on (aa.code_eqp = eq3.id)
         where type_eqp in (15,8) and aa.id_client = id_res order by eq3.id 
       ) as eq2 on (eq2.id = st.code_eqp_inst )
       where  eq.id = parent 
       ;

       Raise Notice ''-eqp %'',parent;
    
       if grp.type_eqp = 9 then
        
          select into vclient id_clienta from eqm_borders_tbl where code_eqp = parent; 

          if vclient = id_res then

            select into vclient2 id_client from eqm_eqp_use_tbl where code_eqp = parent; 
            
            if found and vclient2 is not null then  
               vclient := vclient2;
            end if;
           
          end if;

	  if ((vclient <> id_res) and (vclient <> vclient_last)) then
	    
            Raise Notice ''--abon %'',vclient;

	    insert into rep_point_master_tbl (id_client,id_point,id_master_client,id_point_tree,id_master_tree) values (r.id_client,r.code_eqp, vclient,r.id_tree,grp.id_tree);
            
            vclient_last :=vclient;
          end if;

       end if;

       if grp.type_grp is not null then
    
        fider:=grp.id_grp;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- ­ âª­ã«¨áì ­  ¤àã£ãî ’“ 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;

     end loop;

   end if;

 end loop;

 Return true;
end;
' Language 'plpgsql';
*/


create or replace function rep_point_master_fun(date) Returns boolean As'
Declare
pdt Alias for $1;

r record;
rr record;
rs boolean;
id_res int;
parent int;
dubl   int;
fider  int;
grp record;
vclient record;
vclient2 int;
vclient_last int;

child record;
child_code int;
v boolean; 

begin


 delete from rep_point_master_tbl;
 

 select into id_res to_number(value_ident,''9999999999'') from syi_sysvars_tbl where ident=''id_res'';
  
 for r in 
   Select distinct t.id as id_tree, cl.id as id_client,tt.code_eqp,tt.code_eqp_e 
    From eqm_point_h AS eq 
    join (select code_eqp, max(dt_b) as dt from eqm_point_h  where dt_b <=  pdt and coalesce(dt_e, pdt) >=  pdt group by code_eqp order by code_eqp ) as p2 on (eq.code_eqp = p2.code_eqp and p2.dt = eq.dt_b) 
    join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.code_eqp )
    join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where dt_b <= pdt and coalesce(dt_e, pdt) >= pdt group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
    join eqm_tree_h AS t on (t.id=tt.id_tree )
    join (select id, max(dt_b) as dt from eqm_tree_h  where dt_b <=  pdt and coalesce(dt_e,  pdt) >= pdt group by id order by id) as t2 on (t.id = t2.id and t2.dt = t.dt_b) 
    left join  ( select u1.code_eqp,u1.id_client  from eqm_eqp_use_h as u1 
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h  where dt_b <=  pdt and coalesce(dt_e, pdt) >=  pdt group by code_eqp order by code_eqp ) as u2 
     on (u1.code_eqp = u2.code_eqp and u2.dt = u1.dt_b) 
     where coalesce(dt_b,now()) <>coalesce( dt_e, now())
    ) as use on (use.code_eqp = eq.code_eqp) 
    join clm_client_tbl as cl on (coalesce(use.id_client,t.id_client) = cl.id)
    WHERE cl.id<>id_res and cl.book =-1 and coalesce(cl.flag_balance,0) <> 1 
 loop

   Raise Notice ''Start %'',r.code_eqp;

   parent :=r.code_eqp_e;

   dubl :=0; 
   fider:=0;

   -----------------------------------------------------------------------

   if (r.code_eqp_e is not NULL) then

     vclient_last:=0;

     LOOP
    
       select distinct into grp st.code_eqp_inst,tt.code_eqp_e,tt.id_tree,eq.type_eqp,eq2.type_eqp as type_grp, eq2.id as id_grp
       from eqm_equipment_h as eq 
       join (select id, max(dt_b) as dt from eqm_equipment_h  where  id = parent and dt_b <=  pdt and coalesce(dt_e, pdt) >= pdt group by id order by id ) as eq3 on (eq.id = eq3.id and eq3.dt = eq.dt_b) 
       join eqm_eqp_tree_h AS tt on (tt.code_eqp=eq.id and tt.code_eqp_e is not NULL )
       join (select code_eqp, max(dt_b) as dt from eqm_eqp_tree_h  where code_eqp = parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt and code_eqp_e is not NULL group by code_eqp order by code_eqp) as tt2 on (tt.code_eqp = tt2.code_eqp and tt2.dt = tt.dt_b) 
       left join 
       (select inst.* from eqm_compens_station_inst_h as inst 
          join (select code_eqp, code_eqp_inst, max(dt_b) as dt from eqm_compens_station_inst_h where code_eqp = parent and coalesce(dt_e,pdt) >= pdt group by code_eqp_inst,code_eqp order by code_eqp_inst) as inst2 
          on (inst.code_eqp = inst2.code_eqp and inst.code_eqp_inst = inst2.code_eqp_inst and inst2.dt = inst.dt_b) 
       ) as st on (eq.id = st.code_eqp )
       left join 
       (select eq3.* from eqm_equipment_tbl as eq3 join eqm_area_tbl as aa on (aa.code_eqp = eq3.id)
          join clm_client_tbl as cm on (aa.id_client = cm.id)
         where type_eqp in (15,8) and 
        ((aa.id_client = id_res ) or (coalesce(cm.flag_balance,0) = 1))
order by eq3.id 
       ) as eq2 on (eq2.id = st.code_eqp_inst )
       where  eq.id = parent 
       ;

       Raise Notice ''-eqp %'',parent;
    
       if grp.type_eqp = 9 then
        
          select into vclient id_clienta, flag_balance
           from eqm_borders_h as b 
          join (select code_eqp, max(dt_b) as dt from eqm_borders_h where code_eqp = parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt group by code_eqp order by code_eqp) as b2 on (b.code_eqp = b2.code_eqp and b2.dt = b.dt_b) 
          join clm_client_tbl as cm on (b.id_clienta = cm.id)
          where b.code_eqp = parent; 

          if (vclient.id_clienta = id_res) or (coalesce(vclient.flag_balance,0) = 1) then

            select into vclient2 id_client 
            from eqm_eqp_use_h as us 
            join (select code_eqp, max(dt_b) as dt from eqm_eqp_use_h where code_eqp = parent and dt_b <= pdt and coalesce(dt_e, pdt) >= pdt group by code_eqp order by code_eqp) as us2 on (us.code_eqp = us2.code_eqp and us2.dt = us.dt_b) 
            where us.code_eqp = parent; 

            if found and vclient2 is not null then  
               vclient.id_clienta := vclient2;
            end if;
           
          end if;

	  if ((vclient.id_clienta <> id_res) and (coalesce(vclient.flag_balance,0) = 0) and (vclient.id_clienta <> vclient_last)) then
	    
            Raise Notice ''--abon %'',vclient.id_clienta;

	    insert into rep_point_master_tbl (id_client,id_point,id_master_client,id_point_tree,id_master_tree) values (r.id_client,r.code_eqp, vclient.id_clienta,r.id_tree,grp.id_tree);
            
            vclient_last :=vclient.id_clienta;
          end if;

       end if;

       if grp.type_grp is not null then
    
        fider:=grp.id_grp;
    
       end if;
    
       EXIT WHEN ( (fider<>0) or (grp.code_eqp_e is null) );
    
    
       -- íàòêíóëèñü íà äðóãóþ ÒÓ 
       if (grp.type_eqp = 12) and (dubl=0) then 
        dubl:=parent;
       end if;
    
       parent:= grp.code_eqp_e;

     end loop;

   end if;

 end loop;

 Return true;
end;
' Language 'plpgsql';

