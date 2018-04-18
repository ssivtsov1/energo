--последовательность 1,2,3...н
create table syi_taxsequence_tbl
( num	int,
  primary key(num));


create or replace function syi_fillseq(int) returns int as'
  declare 
  v int;
  begin

  delete from syi_taxsequence_tbl;
  v:=1;
  LOOP
    insert into syi_taxsequence_tbl values (v);
    
    EXIT  WHEN v = $1;
    v:=v+1;  
  END LOOP;
  return v;
  end;
' LANGUAGE 'plpgsql';

select syi_fillseq(7000::int);

