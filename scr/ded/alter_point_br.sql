-- изменение первичного ключа для того, чтобы можно было записать 
-- ТУ потомка от нескольких предков

alter table acd_point_branch_tbl add column p_point2 int;
alter table acd_point_branch_tbl alter column p_point2 set default 0;
alter table acd_point_branch_tbl DROP CONSTRAINT acd_point_branch_tbl_pkey;


update acd_point_branch_tbl set p_point2 = coalesce(id_p_point,0) where p_point2 is null;
alter table acd_point_branch_tbl alter column p_point2 set not null;

alter table acd_point_branch_tbl add CONSTRAINT acd_point_branch_tbl_pkey primary key(id_point,p_point2,id_doc,dat_b);


alter table acd_point_branch_del add column p_point2 int;
alter table acd_point_branch_del alter column p_point2 set default 0;
alter table acd_point_branch_del DROP CONSTRAINT acd_point_branch_del_pkey;

update acd_point_branch_del set p_point2 = coalesce(id_p_point,0) where p_point2 is null;
alter table acd_point_branch_del alter column p_point2 set not null;

alter table acd_point_branch_del add CONSTRAINT acd_point_branch_del_pkey primary key(id_point,p_point2,id_doc,dat_b);

