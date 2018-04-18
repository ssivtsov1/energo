drop table  table_counter;
CREATE TABLE table_counter (
    tabl varchar(80),
    own name,
    trig boolean,
    fdel integer,
    ftype integer default 1,
    cnt integer ,
 primary key (tabl)
);

drop function droptable(varchar,int);
CREATE FUNCTION droptable(varchar,int) RETURNS BOOLEAN AS '
DECLARE
    TableName ALIAS FOR $1;
    casc  ALIAS FOR $2;
    T varchar;
BEGIN
    IF table_exists(TableName) THEN
        T:=lower(TableName);
        EXECUTE ''DROP TABLE ''
	       || quote_ident(T)|| '' Cascade'';
	RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
' LANGUAGE 'plpgsql' WITH (isstrict);    

