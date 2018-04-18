create sequence sebi_nkre4_seq;
CREATE TABLE sebi_nkre4 (
    id integer default nextval('sebi_nkre4_seq'),
    group_code numeric(3,0),
    code integer,
    name character varying(90),
    flag_hand integer,
    full_name varchar (120),
    flag_calc integer,  
 primary key (id)
);

alter table sebi_nkre4 add column flag_calc integer;
select altr_colmn('sebi_nkre4','flag_calc','integer');

CREATE TABLE sebd_nkre4 (
    mmgg date,
    flock int,
    id_nkre4 int,
    code_nkre4 numeric(3),
    demand    numeric (14,3),
    summa      numeric (14,5),
    tariff    numeric (5,2),
   primary key (mmgg,id_nkre4)
);

update sebi_nkre4 set flag_hand=1 where code in 
 (1,5,20,35,50,65,80,
   245,310,345,379,400,430,490,513,540,567);
      
--update sebi_nkre4 set flag_hand=1 where code in (17,32,47,62,77,92);

update sebi_nkre4 set flag_hand=0 where code in (346,347,431,432,491,492);

update sebi_nkre4 set flag_hand=1 where code between 544 and 564;

update sebi_nkre4 set flag_hand=0 where code between 694 and 780;
update sebi_nkre4 set flag_hand=0 where code between 782 and 786;

update sebi_nkre4 set full_name=name where full_name is null;
update sebi_nkre4 set flag_hand=0 where flag_hand is null ;

update sebi_nkre4 set flag_calc=1 where code 
 in (1,94,245,370,567);

update sebi_nkre4 set flag_calc=2 where code 
 in (5,20,35,50,65,80,105,120,135,150,165,180,195,
 250,265,277,280,292,310,330,345,350,365,
 400,415,430,435,450,455,475,490,495,510,513,540,544,552,562,563,
 557,566,568,574,604,605,620,634,635,650,664,665,680,694,695,710,
 724,725,740,755,770,776,782
);


update sebi_nkre4 set flag_calc=0 where flag_calc is null ;

create or replace function rep_nkre4(date) returns boolean as '
declare mg alias for $1;
path_export text;
flag_export varchar;
tabl text;
del text;
nul text;
SQL text;
kodres  int;
begin 
 select into path_export value_ident from syi_sysvars_tbl where ident=''path_exp'';
  if path_export is null then
     path_export=''/home/local/seb/'';
  end if;


select value_ident into kodres from syi_sysvars_tbl where ident=''kod_res''; 
delete from rep_4nkre_tbl;
raise notice ''sa'';
insert into rep_4nkre_tbl (mmgg) select mg;

raise notice ''sa1'';
update rep_4nkre_tbl set sum017=summa,dem017=demand from sebd_nkre4 where code_nkre4=17 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum032=summa,dem032=demand from sebd_nkre4 where code_nkre4=32 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum047=summa,dem047=demand from sebd_nkre4 where code_nkre4=47 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum062=summa,dem062=demand from sebd_nkre4 where code_nkre4=62 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum077=summa,dem077=demand from sebd_nkre4 where code_nkre4=77 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum092=summa,dem092=demand from sebd_nkre4 where code_nkre4=92 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum346=summa,dem346=demand from sebd_nkre4 where code_nkre4=346 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum347=summa,dem347=demand from sebd_nkre4 where code_nkre4=347 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum431=summa,dem431=demand from sebd_nkre4 where code_nkre4=431 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum432=summa,dem432=demand from sebd_nkre4 where code_nkre4=432 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum491=summa,dem491=demand from sebd_nkre4 where code_nkre4=491 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum492=summa,dem492=demand from sebd_nkre4 where code_nkre4=492 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum554=summa,dem554=demand from sebd_nkre4 where code_nkre4=554 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum555=summa,dem555=demand from sebd_nkre4 where code_nkre4=555 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum556=summa,dem556=demand from sebd_nkre4 where code_nkre4=556 and sebd_nkre4.mmgg=mg;

update rep_4nkre_tbl set sum558=summa,dem558=demand from sebd_nkre4 where code_nkre4=558 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum559=summa,dem559=demand from sebd_nkre4 where code_nkre4=559 and sebd_nkre4.mmgg=mg;

update rep_4nkre_tbl set sum563=summa,dem563=demand from sebd_nkre4 where code_nkre4=563 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum564=summa,dem564=demand from sebd_nkre4 where code_nkre4=562 and sebd_nkre4.mmgg=mg;

update rep_4nkre_tbl set sum700=summa,dem700=demand from sebd_nkre4 where code_nkre4=700 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum705=summa,dem705=demand from sebd_nkre4 where code_nkre4=705 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum715=summa,dem715=demand from sebd_nkre4 where code_nkre4=715 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum720=summa,dem720=demand from sebd_nkre4 where code_nkre4=720 and sebd_nkre4.mmgg=mg;


update rep_4nkre_tbl set sum730=summa,dem730=demand from sebd_nkre4 where code_nkre4=730 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum735=summa,dem735=demand from sebd_nkre4 where code_nkre4=735 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum745=summa,dem745=demand from sebd_nkre4 where code_nkre4=745 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum750=summa,dem750=demand from sebd_nkre4 where code_nkre4=750 and sebd_nkre4.mmgg=mg;

update rep_4nkre_tbl set sum760=summa,dem760=demand from sebd_nkre4 where code_nkre4=760 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum765=summa,dem765=demand from sebd_nkre4 where code_nkre4=765 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum775=summa,dem775=demand from sebd_nkre4 where code_nkre4=775 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum780=summa,dem780=demand from sebd_nkre4 where code_nkre4=780 and sebd_nkre4.mmgg=mg;

update rep_4nkre_tbl set sum784=summa,dem784=demand from sebd_nkre4 where code_nkre4=784 and sebd_nkre4.mmgg=mg;
update rep_4nkre_tbl set sum786=summa,dem786=demand from sebd_nkre4 where code_nkre4=786 and sebd_nkre4.mmgg=mg;

tabl=path_export||kodres||''NKRE4.TXT'';
del=''@''; nul='''';
SQL=''copy  rep_4nkre_tbl  to ''||quote_literal(tabl)||'' with delimiter as ''||quote_literal(del)||'' null as ''|| quote_literal(nul);
select into flag_export value_ident from syi_sysvars_tbl where ident=''flag_exp'';
  if flag_export is null or flag_export=''1'' then
     raise notice '' ======== Copy Sql  ======  %'',SQL;
     Execute SQL;
  end if;

return true;
end'
language 'plpgsql'

