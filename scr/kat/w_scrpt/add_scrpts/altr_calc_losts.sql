drop function upd_losts();
create function upd_losts() Returns boolean As'
Declare
begin
alter table acd_calc_losts_del alter column kind_energy set not null;
alter table acd_calc_losts_tbl alter column kind_energy set not null;
Return true;
end;
' Language 'plpgsql';

select upd_losts();

drop function altr_pkey(text,text);
create function altr_pkey(text,text) Returns boolean As'
Declare
nam Alias for $1;
nkey Alias for $2;
cnam text;
st text;
begin
select into cnam conname from pg_constraint as a inner join pg_class as b 
  on (a.conrelid=b.oid) where b.relname=nam and a.contype=''p'';
st:=''alter table ''||nam||'' drop constraint ''||cnam||'';'';
 Execute st;
st:=''alter table ''||nam||'' add primary key(''||nkey||'');'';
 Execute st;
Return true;
end;
' Language 'plpgsql';

select altr_pkey('acd_calc_losts_del','id_doc,id_point,id_eqp,dat_b,kind_energy');
select altr_pkey('acd_calc_losts_tbl','id_doc,id_point,id_eqp,dat_b,kind_energy');

