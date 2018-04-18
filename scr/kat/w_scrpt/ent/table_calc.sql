create sequence acd_comp_percent_seq;
--drop table acd_comp_percent
create table acd_comp_percent(
     id                 int default nextval('acd_comp_percent_seq'),
     id_doc             int,   
     id_point		int,
     id_eqp		int,
     id_p_point         int,
     dat_b		date,
     dat_e		date,
     sn_len		numeric(14,2),
     sum_wp             int,
     sum_wq             int  ,
     wp_parent          int,
     perc               numeric (10,5),
     add_wp             int,
     all_wp             int, 
     primary key(id)
);

create index acd_comp_percent_i on  acd_comp_percent  (id_doc);