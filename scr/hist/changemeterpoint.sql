CREATE TABLE eqm_meter_point_h (
--    id_client        int,
    id_point         int,
    id_meter         int,
    dt_b	     date,
    dt_e	     date
    ,primary key(id_meter,dt_b)
);		


  CREATE or replace FUNCTION eqm_newmeterpoint_fun()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   veqp record;
   vid  int;
   rr   record;
  begin

  select into veqp eq.*  from  eqm_equipment_tbl as eq where id = NEW.code_eqp;

  if (veqp.type_eqp = 1 ) then

     vid :=NEW.code_eqp_e;


     LOOP

       select into rr tt.code_eqp,tt.code_eqp_e, eq.type_eqp 
       From eqm_equipment_tbl AS eq 
       join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
       where tt.code_eqp = vid  
       limit 1;


--       Raise Notice ''Start2  %'',rr.code_eqp;

       EXIT WHEN ( rr.type_eqp <> 10 or rr.code_eqp_e is null );   

       vid = rr.code_eqp_e;

      END LOOP;


      if (rr.type_eqp = 12) then

        insert into eqm_meter_point_h(id_point,id_meter,dt_b) values(rr.code_eqp,NEW.code_eqp,veqp.dt_install);
 
      end if;


  end if;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

CREATE TRIGGER eqm_newmeterpoint_trg 
after insert 
ON eqm_eqp_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_newmeterpoint_fun();

----------------------------------------------------------------------------

  CREATE or replace FUNCTION eqm_edmeterpoint_fun()
  RETURNS TRIGGER
  AS                                                                                              
  '
  declare
   veqp record;
   vid  int;
   rr   record;
   operation integer;
   change record;

  begin

  if (coalesce(old.code_eqp_e,0)=coalesce(new.code_eqp_e,0)) 
     and (old.id_tree=new.id_tree) 
     and (old.lvl=new.lvl)  then 
    return new;
  end if;

  select into veqp eq.*  from  eqm_equipment_tbl as eq where id = NEW.code_eqp;

  if (veqp.type_eqp = 1 ) then

     select into operation currval(''"eqm_change_oper_seq"''::text);
     select into change * from eqt_change_tbl where id_operation=operation;


     vid :=NEW.code_eqp_e;


     LOOP

       select into rr tt.code_eqp,tt.code_eqp_e, eq.type_eqp 
       From eqm_equipment_tbl AS eq 
       join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
       where tt.code_eqp = vid  
       limit 1;

--       Raise Notice ''Start2  %'',rr.code_eqp;

       EXIT WHEN ( rr.type_eqp <> 10 or rr.code_eqp_e is null );   

       vid = rr.code_eqp_e;

      END LOOP;

      delete from eqm_meter_point_h 
      where id_meter = OLD.code_eqp and dt_b >= change.date_change;
    
      update eqm_meter_point_h set dt_e = change.date_change 
      where id_meter = OLD.code_eqp  and dt_b <= change.date_change 
      and change.date_change <= coalesce (dt_e,change.date_change);


      if (rr.type_eqp = 12) then

          insert into eqm_meter_point_h(id_point,id_meter,dt_b) values(rr.code_eqp,NEW.code_eqp,change.date_change);
 
      else 
        
          insert into eqm_meter_point_h(id_point,id_meter,dt_b) values(NULL,NEW.code_eqp,change.date_change);

      end if;


  end if;


  RETURN NEW;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

drop TRIGGER eqm_edmeterpoint_trg ON eqm_eqp_tree_tbl;

CREATE TRIGGER eqm_edmeterpoint_trg 
after  update
ON eqm_eqp_tree_tbl
FOR EACH ROW 
EXECUTE PROCEDURE eqm_edmeterpoint_fun();
----------------------------------------------------------------------------

  CREATE or replace FUNCTION sel_meterpnt_fun()
  RETURNS int
  AS                                                                                              
  '
  declare
--   pdt Alias for $1;
   veqp int;
   r record;
   rr record;
   vareas_noprom10k int;
   vabons_sh int;
   vabons_noprom10k int;
   vareas record;
   vareas_sh int;
   vpoints record;
   vsh record;
   vpoint_noprom10k record;
   vprom  record;
  begin

   delete from eqm_meter_point_h;


   insert into eqm_meter_point_h (id_meter,dt_b)
    select id, dt_install from eqm_equipment_tbl where type_eqp = 1;


    for r in select h.*, tt.code_eqp_e
     from eqm_meter_point_h as h join eqm_eqp_tree_tbl as tt on (tt.code_eqp = h.id_meter)
    loop

     Raise Notice ''Start %'',r.id_meter;

     veqp :=r.code_eqp_e;


      LOOP

       select into rr tt.code_eqp,tt.code_eqp_e, eq.type_eqp 
       From eqm_equipment_tbl AS eq 
       join eqm_eqp_tree_tbl AS tt on (tt.code_eqp=eq.id )
       where (tt.code_eqp = veqp)  limit 1;


--       Raise Notice ''Start2  %'',rr.code_eqp;

--       EXIT WHEN ( rr.type_eqp = 12 or rr.code_eqp_e is null );   
       EXIT WHEN ( rr.type_eqp <> 10 or rr.code_eqp_e is null );   

       veqp = rr.code_eqp_e;

      END LOOP;


      if (rr.type_eqp = 12) then

        update eqm_meter_point_h set id_point = rr.code_eqp
        where id_meter = r.id_meter;
 
      end if;


    END LOOP;



  RETURN 0;                              
                                       
  end;'                                                                                           
  LANGUAGE 'plpgsql';          

