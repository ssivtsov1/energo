  -- eqc_bill_addr_fun должна быть вызвана перед для заполнения eqt_bill_addr_tbl
--  DROP FUNCTION  bl_point_order_fun(integer,int,int,int);
  CREATE or replace FUNCTION bl_point_order_fun(integer,int,int,int)
  -- сортировка точек учета по порядку вывода в счет
  -- начальный вызов lvl=0 counter=1 p_point_id =null
  RETURNS int
  AS                                                                                              
  '
  declare
  doc_id Alias for $1;
  p_point_id Alias for $2;
  counter Alias for $3;
  lvl Alias for $4;
  cur_counter int;
  v int;

  point record;
  begin
  cur_counter:=counter;

   Raise notice ''doc_id % , p_point_id % '',doc_id,p_point_id;
  -- Выберем все точки, имеющие данную точку предком
 
  for point in select distinct pb.id_point,pb.id_p_point,coalesce(adr.name_eqp_inst,'''') as name_inst 
--,coalesce(pb2.id_point,0) as point2
  from (select * from acd_point_branch_tbl where id_doc = doc_id and coalesce(num_order,0)=0)  as pb 
--  left join (select * from acd_point_branch_tbl where id_doc = doc_id order by id_p_point) as pb2 on (pb.id_point = pb2.id_p_point ) 
  left join (select distinct id_point from acd_point_branch_tbl where id_doc = doc_id order by id_point) as pb1 on (pb1.id_point = pb.id_p_point ) 
  left join eqt_bill_addr_tbl as adr on (adr.id_doc=pb.id_doc and pb.id_point=adr.code_eqp)
  where  
  (((p_point_id is NULL)and ((pb.id_p_point is NULL) or (pb1.id_point is NULL))) 
  or (pb.id_p_point=p_point_id)) 
  order by name_inst
--, point2 
 loop

--    Raise notice ''point % , point2 %, order % , lvl %;'',point.id_point,point.point2, cur_counter,lvl;
    Raise notice ''point % ,  order % , lvl %;'',point.id_point, cur_counter,lvl;

    update acd_point_branch_tbl set level = lvl, num_order = cur_counter
    where id_doc = doc_id and id_point=point.id_point and ( id_p_point = point.id_p_point or id_p_point is null );
--    and (coalesce(num_order,0)=0 or num_order=-1);

/*
    select into v id_point from act_points_sort_tbl where id_point =point.id_point and id_point is not null;

    if found then 

      update acd_point_branch_tbl set level = lvl, num_order = -1
      where id_doc = doc_id and id_point=point.id_point and id_p_point = point.id_p_point;

    else

      insert into act_points_sort_tbl values (point.id_point);

    end if;
*/
--    -- самая последняя строчка в случае дубля от двух учетов остается, остальные -1
--    update acd_point_branch_tbl set level = lvl, num_order = -1
--    where id_doc = doc_id and id_point=point.id_point and  coalesce(id_p_point,0) <> coalesce(point.id_p_point,0);


    -- рекурсия
    cur_counter:=bl_point_order_fun(doc_id,point.id_point,cur_counter+1,lvl+1);

  end loop;

  RETURN cur_counter;
  end;'                                                                                           
  LANGUAGE 'plpgsql';          
