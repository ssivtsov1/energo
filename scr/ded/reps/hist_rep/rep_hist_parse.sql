CREATE OR REPLACE  FUNCTION rep_hist_parse_fun(date,date) 
RETURNS BOOLEAN AS '
DECLARE
    pdt_b ALIAS FOR $1;
    pdt_e ALIAS FOR $2;
 
    vtable record;
    vtablename varchar;
    vkeyfield record; 
    vquerystr varchar;
    vquerystr2 varchar;
    vquerystr3 varchar;
    vquerystr4 varchar;
    vkeystr varchar;
    vhistrecord record; 
    vhistfieldrecord record; 
    vtablefields record; 
    vold_text varchar;
    vnew_text varchar;
    vrecord record;
    vcode_eqp int; 
    vid_client int;
BEGIN
    
    delete from rep_hist_changed_fields_tbl;
    for vtable in
    select * from syi_hist_table_tbl where is_update =true
    loop
    
      select into vtablename name from syi_table_tbl where id = vtable.id_table; 

      vquerystr:= ''select eq.*, eq.oid as oid_new, eq2.oid as oid_old, eq.dt_b::date as date_b from ''||vtablename|| '' as eq join ''||vtablename|| '' as eq2 on ( '';

      vkeystr := '' '';
 
      for vkeyfield in
         select name from syi_field_tbl where id_table = vtable.id_table and coalesce(key,false) = true
      loop
           if vkeystr <> '' '' then
		vkeystr:=vkeystr||'' and '';
           end if;
	   
           vkeystr:=vkeystr||''eq.''||vkeyfield.name||''=eq2.''||vkeyfield.name;
          
      end loop;

      vquerystr:= vquerystr||vkeystr||'' and eq2.dt_b < eq.dt_b and eq2.dt_e = eq.dt_b) where eq.dt_b >=''||quote_literal(pdt_b)|| 
	''and eq.dt_b <= ''||quote_literal(pdt_e);
 
    --  raise notice '' - %'',vquerystr;

      for vhistrecord in  EXECUTE vquerystr
      loop
	--raise notice ''- - %'',vhistrecord.date_b;
          
        for vtablefields in 
        select * from syi_field_tbl where id_table = vtable.id_table 
        loop
         
         if vtablefields.name<>''dt'' and vtablefields.name<>''dt_b'' and vtablefields.name<>''dt_e'' 
            and vtablefields.name<>''mmgg'' and vtablefields.name<>''dt_change'' and vtablefields.name<>''id_user'' then

           vquerystr2:=''select text(new_val) as new_val , text(old_val) as old_val, ((new_val <> old_val) or (new_val is null and old_val is not null) or (new_val is not null and old_val is null) ) as is_changed from (''||
           ''select eq.''||vtablefields.name||'' as new_val,eq2.''||vtablefields.name||'' as old_val  from ''||
           vtablename||'' as eq ,''||vtablename||'' as eq2  where eq.oid = ''||text(vhistrecord.oid_new)||
           '' and eq2.oid = ''||text(vhistrecord.oid_old)||'' ) as ss ;'';

           -- raise notice '' - - - %'',vquerystr2;

           for vhistfieldrecord in  EXECUTE vquerystr2
           loop
              if vhistfieldrecord.is_changed =true then

		  vold_text:='''';
                  vnew_text:='''';

	          if vtablefields.def is not null then

		   if (text(vhistfieldrecord.new_val) is not null) then
			--	raise notice '' - - - %'',vquerystr3;                      
		      vquerystr3:=''select name from ''||vtablefields.def||'' as dd where id = ''||text(vhistfieldrecord.new_val)|| '' limit 1'';
                      
                      for vrecord in  EXECUTE vquerystr3 loop
                         vnew_text := vrecord.name;
                      end loop;
                   end if;

		   if (text(vhistfieldrecord.old_val) is not null) then
		      vquerystr3:=''select name from ''||vtablefields.def||'' as dd where id = ''||text(vhistfieldrecord.old_val)|| '' limit 1'';

                      for vrecord in  EXECUTE vquerystr3 loop
                         vold_text := vrecord.name;
                      end loop;
	           end if;   
		  else
		      vold_text:=text(vhistfieldrecord.old_val);
                      vnew_text:=text(vhistfieldrecord.new_val);
                  end if;
		-- 
		  vid_client:=0;

		  if vtable.abon_path_type = 0 then
			vid_client:=vhistrecord.id_client;
                        vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 5 then
			vid_client:=vhistrecord.id_clientB;
			vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 1 then
			
		       vquerystr4 = ''select coalesce(u1.id_client,t.id_client) as id_client from ''||vtablename||
                              '' as eq join eqm_eqp_tree_h as tt on (tt.code_eqp = eq.code_eqp and eq.dt_b >=tt.dt_b and (tt.dt_e is null or tt.dt_e> eq.dt_b) )
                               join eqm_tree_h as t on (tt.id_tree = t.id and eq.dt_b >=t.dt_b and (t.dt_e is null or t.dt_e> eq.dt_b) )
                               left join eqm_eqp_use_h as u1 on (u1.code_eqp = eq.code_eqp and eq.dt_b >=u1.dt_b and (u1.dt_e is null or u1.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;
		      
                      vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 2 then
			
		       vquerystr4 = ''select coalesce(u1.id_client,t.id_client) as id_client from ''||vtablename||
                              '' as eq join eqm_tree_h as t on (eq.id_tree = t.id and eq.dt_b >=t.dt_b and (t.dt_e is null or t.dt_e> eq.dt_b) )
				left join eqm_eqp_use_h as u1 on (u1.code_eqp = eq.code_eqp and eq.dt_b >=u1.dt_b and (u1.dt_e is null or u1.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;

		      vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 3 then
			
		       vquerystr4 = ''select coalesce(u1.id_client,t.id_client) as id_client from ''||vtablename||
                              '' as eq join eqm_eqp_tree_h as tt on (tt.code_eqp = eq.id and eq.dt_b >=tt.dt_b and (tt.dt_e is null or tt.dt_e> eq.dt_b) )
				join eqm_tree_h as t on (tt.id_tree = t.id and eq.dt_b >=t.dt_b and (t.dt_e is null or t.dt_e> eq.dt_b) )
				left join eqm_eqp_use_h as u1 on (u1.code_eqp = eq.id and eq.dt_b >=u1.dt_b and (u1.dt_e is null or u1.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;

		      vcode_eqp := vhistrecord.id;
		  end if;		

		  if vtable.abon_path_type = 4 then
			
		       vquerystr4 = ''select id_client from ''||vtablename||
                              '' as eq join eqm_area_h as a on (a.code_eqp = eq.code_eqp and eq.dt_b >=a.dt_b and (a.dt_e is null or a.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;

                      vcode_eqp := vhistrecord.code_eqp;
		  end if;		

                  insert into rep_hist_changed_fields_tbl(id_table,id_field,record_oid,dt_change,old_val,new_val,old_text,new_text,code_eqp,id_client,id_usr)
                  values(vtable.id_table, vtablefields.id,vhistrecord.oid_new,vhistrecord.date_b,substr(text(vhistfieldrecord.old_val),1,199)::varchar,
                  substr(text(vhistfieldrecord.new_val),1,199)::varchar,
                   substr(vold_text,1,199)::varchar,substr(vnew_text,1,199)::varchar, vcode_eqp, vid_client, vhistrecord.id_user) ;

 
              end if;
           end loop;
         end if;
        end loop;
      end loop;
    end loop;

    RETURN true;
END;
' LANGUAGE 'plpgsql';    




CREATE OR REPLACE  FUNCTION rep_hist_point_power_parse_fun(date,date) 
RETURNS BOOLEAN AS '
DECLARE
    pdt_b ALIAS FOR $1;
    pdt_e ALIAS FOR $2;
 
    vtable record;
    vtablename varchar;
    vkeyfield record; 
    vquerystr varchar;
    vquerystr2 varchar;
    vquerystr3 varchar;
    vquerystr4 varchar;
    vkeystr varchar;
    vhistrecord record; 
    vhistfieldrecord record; 
    vtablefields record; 
    vold_text varchar;
    vnew_text varchar;
    vrecord record;
    vcode_eqp int; 
    vid_client int;
BEGIN
    
    delete from rep_hist_changed_fields_tbl;

    for vtable in
     select * from syi_hist_table_tbl where id = 12 and is_update =true 
    loop
    
      select into vtablename name from syi_table_tbl where id = vtable.id_table; 

      vquerystr:= ''select eq.*, eq.oid as oid_new, eq2.oid as oid_old, eq.dt_b::date as date_b from ''||vtablename|| '' as eq join ''||vtablename|| '' as eq2 on ( '';

      vkeystr := '' '';
 
      for vkeyfield in
         select name from syi_field_tbl where id_table = vtable.id_table and coalesce(key,false) = true
      loop
           if vkeystr <> '' '' then
		vkeystr:=vkeystr||'' and '';
           end if;
	   
           vkeystr:=vkeystr||''eq.''||vkeyfield.name||''=eq2.''||vkeyfield.name;
          
      end loop;

      vquerystr:= vquerystr||vkeystr||'' and eq2.dt_b < eq.dt_b and eq2.dt_e = eq.dt_b) where eq.dt_b >=''||quote_literal(pdt_b)|| 
	''and eq.dt_b <= ''||quote_literal(pdt_e);
 
    --  raise notice '' - %'',vquerystr;

      for vhistrecord in  EXECUTE vquerystr
      loop
	--raise notice ''- - %'',vhistrecord.date_b;
          
        for vtablefields in 
         select * from syi_field_tbl where id_table = vtable.id_table 
        loop
         
         if vtablefields.name=''power'' or vtablefields.name=''connect_power'' then

           vquerystr2:=''select text(new_val) as new_val , text(old_val) as old_val, ((new_val <> old_val) or (new_val is null and old_val is not null) or (new_val is not null and old_val is null) ) as is_changed from (''||
           ''select eq.''||vtablefields.name||'' as new_val,eq2.''||vtablefields.name||'' as old_val  from ''||
           vtablename||'' as eq ,''||vtablename||'' as eq2  where eq.oid = ''||text(vhistrecord.oid_new)||
           '' and eq2.oid = ''||text(vhistrecord.oid_old)||'' ) as ss ;'';

       --    raise notice '' - - - %'',vquerystr2;

           for vhistfieldrecord in  EXECUTE vquerystr2
           loop
              if vhistfieldrecord.is_changed =true then

		  vold_text:='''';
                  vnew_text:='''';

	          if vtablefields.def is not null then

		   if (text(vhistfieldrecord.new_val) is not null) then
			--	raise notice '' - - - %'',vquerystr3;                      
		      vquerystr3:=''select name from ''||vtablefields.def||'' as dd where id = ''||text(vhistfieldrecord.new_val)|| '' limit 1'';
                      
                      for vrecord in  EXECUTE vquerystr3 loop
                         vnew_text := vrecord.name;
                      end loop;
                   end if;

		   if (text(vhistfieldrecord.old_val) is not null) then
		      vquerystr3:=''select name from ''||vtablefields.def||'' as dd where id = ''||text(vhistfieldrecord.old_val)|| '' limit 1'';

                      for vrecord in  EXECUTE vquerystr3 loop
                         vold_text := vrecord.name;
                      end loop;
	           end if;   
		  else
		      vold_text:=text(vhistfieldrecord.old_val);
                      vnew_text:=text(vhistfieldrecord.new_val);
                  end if;
		-- 
		  vid_client:=0;

		  if vtable.abon_path_type = 0 then
			vid_client:=vhistrecord.id_client;
                        vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 5 then
			vid_client:=vhistrecord.id_clientB;
			vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 1 then
			
		       vquerystr4 = ''select coalesce(u1.id_client,t.id_client) as id_client from ''||vtablename||
                              '' as eq join eqm_eqp_tree_h as tt on (tt.code_eqp = eq.code_eqp and eq.dt_b >=tt.dt_b and (tt.dt_e is null or tt.dt_e> eq.dt_b) )
                               join eqm_tree_h as t on (tt.id_tree = t.id and eq.dt_b >=t.dt_b and (t.dt_e is null or t.dt_e> eq.dt_b) )
                               left join eqm_eqp_use_h as u1 on (u1.code_eqp = eq.code_eqp and eq.dt_b >=u1.dt_b and (u1.dt_e is null or u1.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;
		      
                      vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 2 then
			
		       vquerystr4 = ''select coalesce(u1.id_client,t.id_client) as id_client from ''||vtablename||
                              '' as eq join eqm_tree_h as t on (eq.id_tree = t.id and eq.dt_b >=t.dt_b and (t.dt_e is null or t.dt_e> eq.dt_b) )
				left join eqm_eqp_use_h as u1 on (u1.code_eqp = eq.code_eqp and eq.dt_b >=u1.dt_b and (u1.dt_e is null or u1.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;

		      vcode_eqp := vhistrecord.code_eqp;
		  end if;		

		  if vtable.abon_path_type = 3 then
			
		       vquerystr4 = ''select coalesce(u1.id_client,t.id_client) as id_client from ''||vtablename||
                              '' as eq join eqm_eqp_tree_h as tt on (tt.code_eqp = eq.id and eq.dt_b >=tt.dt_b and (tt.dt_e is null or tt.dt_e> eq.dt_b) )
				join eqm_tree_h as t on (tt.id_tree = t.id and eq.dt_b >=t.dt_b and (t.dt_e is null or t.dt_e> eq.dt_b) )
				left join eqm_eqp_use_h as u1 on (u1.code_eqp = eq.id and eq.dt_b >=u1.dt_b and (u1.dt_e is null or u1.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;

		      vcode_eqp := vhistrecord.id;
		  end if;		

		  if vtable.abon_path_type = 4 then
			
		       vquerystr4 = ''select id_client from ''||vtablename||
                              '' as eq join eqm_area_h as a on (a.code_eqp = eq.code_eqp and eq.dt_b >=a.dt_b and (a.dt_e is null or a.dt_e> eq.dt_b) )
                               where eq.oid =''||text(vhistrecord.oid_new)||'' limit 1'';

                      for vrecord in  EXECUTE vquerystr4 loop
                         vid_client:= vrecord.id_client;
                      end loop;

                      vcode_eqp := vhistrecord.code_eqp;
		  end if;		

                  insert into rep_hist_changed_fields_tbl(id_table,id_field,record_oid,dt_change,old_val,new_val,old_text,new_text,code_eqp,id_client,id_usr)
                  values(vtable.id_table, vtablefields.id,vhistrecord.oid_new,vhistrecord.date_b,text(vhistfieldrecord.old_val),text(vhistfieldrecord.new_val),
                   vold_text,vnew_text, vcode_eqp, vid_client, vhistrecord.id_user) ;

 
              end if;
           end loop;
         end if;
        end loop;
      end loop;
    end loop;

    RETURN true;
END;
' LANGUAGE 'plpgsql';    
