/*
create or replace function acm_tax_correction_restore(int,date) returns boolean as'
  declare 
     pid_client alias for $1;
     pmmgg      alias for $2;
     vktsaldo   record;
     vadvance   record;
     v_ok       record;
     vbad_avans numeric;
     vsum_repair numeric;
     vtaxadv    record;
     r record;
     vv record;

  begin

  select into vv * from acm_taxadvcor_tbl where flock = -1 and mmgg = pmmgg;
  if found then
     return false;
  end if;

  select into vv * from seb_obr_all_tbl where mmgg = pmmgg;
  if not found then
     return false;
  end if;

  for r in 
	select id_client,id_pref, sum(sum_rest) as sum_avans from acv_taxadvtariff
	where date_trunc(''month'',reg_date) <= pmmgg and ( (id_client = pid_client) or (pid_client is null))
	group by id_client,id_pref
	order by id_client
  loop

    vbad_avans = r.sum_avans;
 
    select into vktsaldo coalesce(sum(e_kred),0) as ekt, coalesce(sum(e_kred_tax),0) as ekt_pdv 
    from seb_obr_all_tbl 
    where id_client=r.id_client and id_pref=r.id_pref and mmgg = pmmgg ;

   Raise Notice ''client  % '',r.id_client;
   Raise Notice ''bad_avans  % '',vbad_avans;
   Raise Notice ''vktsaldo  % '',vktsaldo.ekt;

    for vtaxadv in
	select * from acv_taxadvtariff
	where date_trunc(''month'',reg_date) <= pmmgg
        and id_client=r.id_client and id_pref=r.id_pref
	order by reg_date
    loop

      if vbad_avans > vktsaldo.ekt then

        
        if (vbad_avans - vktsaldo.ekt)>=vtaxadv.sum_rest then
	   
           vsum_repair:=vtaxadv.sum_rest;	
        else 
           vsum_repair:=vbad_avans - vktsaldo.ekt;	
        end if;

	Raise Notice ''- - - sum_repair %'',vsum_repair;

        insert into acm_taxadvcor_tbl(id_pref,id_advance,id_correction,id_bill,sum_val,dt,flock,mmgg)
         values(r.id_pref,vtaxadv.id_doc,NULL,NULL,vsum_repair,now(),-1,pmmgg);

        vbad_avans:=vbad_avans  -vsum_repair;
      end if;    

    end loop;


 end loop;

  return true;
  end;
' LANGUAGE 'plpgsql';
*/


--select acm_tax_correction_restore(null, '2012-02-01');


create or replace function acm_tax_correction_restore(int,date) returns boolean as'
  declare 
     pid_client alias for $1;
     pmmgg      alias for $2;
     vktsaldo   record;
     vadvance   record;
     v_ok       record;
     vbad_avans numeric;
     vsum_repair numeric;
     vtaxadv    record;
     r record;
     vv record;

  begin

  --select into vv * from acm_taxadvcor_tbl where flock = -1 and mmgg = pmmgg;
  --if found then
  --   return false;
  -- end if;

  delete from acm_taxadvcor_tbl where flock = -1 and mmgg = pmmgg;

  perform seb_all( 0, pmmgg);

  select into vv * from seb_obr_all_tmp where mmgg = pmmgg limit 1;
  if not found then
     return false;
  end if;

  for r in 
	select t.id_client,t.id_pref, sum(t.sum_rest) as sum_avans 
        from acv_taxadvtariff as t
        join clm_client_tbl as c on (c.id = t.id_client)
	where date_trunc(''month'',t.reg_date) <= pmmgg 
--and ( (t.id_client = pid_client) or (pid_client is null))
        and c.id_state<>50 and c.id_state<>99 and c.idk_work<>0
	and t.id_pref = 10
	group by t.id_client,t.id_pref
	order by t.id_client
  loop

    vbad_avans = r.sum_avans;
 
    --select into vktsaldo coalesce(sum(e_kred),0) as ekt, coalesce(sum(e_kred_tax),0) as ekt_pdv 

   select into vktsaldo coalesce(sum(kr_zkme),0) as ekt, coalesce(sum(kr_zkmpdv),0) as ekt_pdv 
    from seb_obr_all_tmp 
    where id_client=r.id_client and id_pref=r.id_pref and mmgg = pmmgg ;

   if r.sum_avans<>vktsaldo.ekt then 

     Raise Notice ''client  % '',r.id_client;
     Raise Notice ''bad_avans  % '',vbad_avans;
     Raise Notice ''vktsaldo  % '',vktsaldo.ekt;

    for vtaxadv in
	select * from acv_taxadvtariff
	where date_trunc(''month'',reg_date) <= pmmgg
        and id_client=r.id_client and id_pref=r.id_pref
	order by reg_date
    loop

      if vbad_avans > vktsaldo.ekt then

        
        if (vbad_avans - vktsaldo.ekt)>=vtaxadv.sum_rest then
	   
           vsum_repair:=vtaxadv.sum_rest;	
        else 
           vsum_repair:=vbad_avans - vktsaldo.ekt;	
        end if;

	Raise Notice ''- - - sum_repair %'',vsum_repair;

        insert into acm_taxadvcor_tbl(id_pref,id_advance,id_correction,id_bill,sum_val,dt,flock,mmgg)
        values(r.id_pref,vtaxadv.id_doc,NULL,NULL,vsum_repair,now(),-1,pmmgg);

        vbad_avans:=vbad_avans  -vsum_repair;
      end if;    

    end loop;

   end if;    
 end loop;

  return true;
  end;
' LANGUAGE 'plpgsql';

