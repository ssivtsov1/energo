CREATE OR REPLACE FUNCTION altr_colmn_repl(text, text, text)
  RETURNS boolean AS
$BODY$
Declare
n_tbl Alias for $1;
n_clmn Alias for $2;
c_str Alias for $3;
st text;

begin
if altr_colmn_type(n_tbl,n_clmn)<>c_str and altr_colmn_type(n_tbl,n_clmn)<>'empty' then
st:='alter table '||n_tbl||' add column '||n_clmn||'1 '||c_str||';';
 Execute 'alter table '||n_tbl||' add column '||n_clmn||'1 '||c_str||';';
 Execute 'update '||n_tbl||' set '||n_clmn||'1='||n_clmn||';';
 Execute 'alter table '||n_tbl||' drop column '||n_clmn||';';
 Execute 'alter table '||n_tbl||' rename column '||n_clmn||'1 to '||n_clmn||';';
 Return true;
else
 if altr_colmn_type(n_tbl,n_clmn)='empty' then
  st:='alter table '||n_tbl||' add column '||n_clmn||' '||c_str||';';
 Execute 'alter table '||n_tbl||' add column '||n_clmn||' '||c_str||';';
 raise notice 'st     % ',st;
   Return true;
 end if;
 Return false;
end if;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION altr_colmn(text, text, text)
  OWNER TO local;


CREATE OR REPLACE FUNCTION altr_colmn_type(text, text)
  RETURNS text AS
$BODY$
Declare
ntbl Alias for $1;
natt Alias for $2;
res text;
r record;
t1 int;
t2 int;
begin
res:='';
for r in select b.attname,b.atttypmod,c.typname from (pg_class as a 
  inner join pg_attribute as b on b.attrelid=a.oid) left join pg_type as c 
  on (b.atttypid=c.oid) where a.relname=ntbl and b.attname=natt loop
if r.attname is null then
 res:='empty';
else
 if r.typname='numeric' then
  t1=trunc(r.atttypmod/65536,0);
  t2=r.atttypmod-(65536*t1+4);
  res:=r.typname||'('||t1::text||','||t2::text||')';
 else
  if r.typname='varchar' then
   res:=r.typname||'('||(r.atttypmod-4)||')';
  else
   res:=r.typname;
  end if;
 end if;
end if;
end loop;
if res='' then
 res:='empty';
end if;
Return res;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION calc_type(text, text)
  OWNER TO local;


drop function calc_type(text,text);
create function calc_type(text,text) Returns text As '
Declare
ntbl Alias for $1;
natt Alias for $2;
res text;
r record;
t1 int;
t2 int;
begin
res:='''';
for r in select b.attname,b.atttypmod,c.typname from (pg_class as a 
  inner join pg_attribute as b on b.attrelid=a.oid) left join pg_type as c 
  on (b.atttypid=c.oid) where a.relname=ntbl and b.attname=natt loop
if r.attname is null then
 res:=''empty'';
else
 if r.typname=''numeric'' then
  t1=trunc(r.atttypmod/65536,0);
  t2=r.atttypmod-(65536*t1+4);
  res:=r.typname||''(''||t1::text||'',''||t2::text||'')'';
 else
  if r.typname=''varchar'' then
   res:=r.typname||''(''||(r.atttypmod-4)||'')'';
  else
   res:=r.typname;
  end if;
 end if;
end if;
end loop;
if res='''' then
 res:=''empty'';
end if;
Return res;
end;
' Language 'plpgsql';

drop function altr_colmn(text,text,text);
CREATE function altr_colmn(text,text,text) Returns boolean As'
Declare
n_tbl Alias for $1;
n_clmn Alias for $2;
c_str Alias for $3;
st text;

begin
if calc_type(n_tbl,n_clmn)<>c_str and calc_type(n_tbl,n_clmn)<>''empty'' then
st:=''alter table ''||n_tbl||'' add column ''||n_clmn||''1 ''||c_str||'';'';
 Execute ''alter table ''||n_tbl||'' add column ''||n_clmn||''1 ''||c_str||'';'';
 Execute ''update ''||n_tbl||'' set ''||n_clmn||''1=''||n_clmn||'';'';
 Execute ''alter table ''||n_tbl||'' drop column ''||n_clmn||'';'';
 Execute ''alter table ''||n_tbl||'' rename column ''||n_clmn||''1 to ''||n_clmn||'';'';
 Return true;
else
st:=''alter table ''||n_tbl||'' add column ''||n_clmn||''1 ''||c_str||'';'';
 raise notice ''st     % '',st;
 Return false;
end if;
end;
' Language 'plpgsql';

drop function drp_tbl(text);
CREATE function drp_tbl(text) Returns text As'
Declare
ntbl Alias for $1;
res text;
begin
if (select count(*) from pg_class where relname=ntbl)<>0 then
 EXECUTE ''drop table ''||ntbl||'';'';
 res:=''drop tbl ''||ntbl||'' returns TRUE'';
else 
 res:=''drop tbl ''||ntbl||'' returns FALSE'';
end if;
Return res;
end;
' Language 'plpgsql';

drop function drp_fun(text);
CREATE function drp_fun(text) Returns text As'
Declare
nfun Alias for $1;
res text;
begin
if (select count(*) from pg_class where relname=nfun)<>0 then
 EXECUTE ''drop function ''||nfun||'';'';
 res:=''drop func ''||nfun||'' returns TRUE'';
else 
 res:=''drop func ''||nfun||'' returns FALSE'';
end if;
Return res;
end;
' Language 'plpgsql';
