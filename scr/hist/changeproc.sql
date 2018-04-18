
    create table eqm_changelog_tbl(
     id_change       integer not null, 
     id_operation    integer,  -- ��� ����樨 ������ �������� ��� �����䨪�樨
     mode            int,
     id_client       integer,   
     id_tree         int,  
     id_usr          int,  --i ��� �믮����襣� 
     code_eqp        integer,
     date_change     timestamp,  --   ��� ������ 
     processing      integer default 0,
     enabled         integer default 1,
     dt 	     timestamp without time zone DEFAULT now(),
     PRIMARY KEY (id_change)	
    );



--DROP function eqt_change_fun(int,int,timestamp,integer,integer,integer);
Create or replace function eqt_change_fun(int,int,timestamp,integer,integer,integer) returns integer as'
Declare
 changemode Alias for $1;
-- client Alias for $2;
 t_id Alias for $2;
 dt_change Alias for $3;
 usr_id Alias for $4;
 eqp Alias for $5;
 enable Alias for $6;

 operation integer;
 client    record;
 vcur_user integer;

 is_group  int;
-- nam varchar(31);
----------------------------------------------------------------------------
-- ��। �믮������� ��������� �������� ����� �ਯ� ��� ᮧ����� �६�����
-- ����ᥩ. ��⮬ ��稭��� �࠭�����, eqm_change_tbl,
-- eqa_change_tbl � eqd_change_tbl ����������� �� �ਣ��஢ ⠡���.
-- ��᫥ �ᯥ譮�� �믮������ ��������� ���⪠ �६����� ⠡���.
-- ������� �࠭�����.
---------------------------------------------------------------------------- 
begin
   -- select into nam CURRENT_USER;

--   if not table_exists(''eqt_change_tbl'') then
--    create table eqt_change_tbl(
--   id_change       integer not null DEFAULT nextval(''"eqm_change_seq"''::text), 
--     id_operation    integer,  -- ��� ����樨 ������ �������� ��� �����䨪�樨
                               -- ����樨 ������ � 楫�� 
--     mode            int,
--     id_client       integer,   
--     id_tree         int,  
--     id_usr          int,  --i ��� �믮����襣� 
--     code_eqp        integer,
--     date_change     timestamp,  --   ��� ������ 
--     processing      integer default 0,
--     enabled         integer default 1
--    );
   -- ��� �����䨪�樨 ����樨 �� �ਣ��஢ ����室��� id_client � id_operation
   -- id_change ��� ⠡��� eqa_change_tbl � eqd_change_tbl
   -- code_eqp,id_tree ��� eqa_change_tbl
   -- mode,date_change,id_usr ��� eqm_change_tbl
   -- processing �ਧ��� ᮧ����� ����� eqm_change_tbl
   -- enabled - �������/�몫���� ����� ���������
--   else                         
--   Delete from eqt_change_tbl where (id_usr = usr_id) and (id_client = client_id);
-- ���� � ����� ।���஢��� �����६���� ⮫쪮 ������ �������
--   Delete from eqt_change_tbl where (id_usr = usr_id);
--   end if;

   --����稫� ��� ��� ⥪�饩 ����樨
   select into operation nextval(''"eqm_change_oper_seq"''::text);

   vcur_user:=getsysvar(''last_user''::varchar);

   if eqp is NULL then

    select into client id_client  from eqm_tree_tbl where id=t_id  group by id_client; 

    Insert into eqt_change_tbl(id_operation,mode,id_client,id_usr,code_eqp,date_change,id_tree,enabled)
     values (operation,changemode,client.id_client,vcur_user,eqp,dt_change,t_id,enable);

   else 

    select into is_group dk.inst_station from eqm_equipment_tbl as eq inner join eqi_device_kinds_tbl as dk
     on (dk.id = eq.type_eqp) where eq.id =eqp;
    -- ���頤�� - �� �������� 㦥 �� ������ ����㤮�����, � ��� �ਭ������饣�
    -- (��� �������� �뫮 㤠���� ࠭��), ���⮬� ���� "�������" �� ������塞
    if is_group=1 then 

     Insert into eqt_change_tbl(id_operation,mode,id_usr,code_eqp,date_change,enabled)
      values (operation,changemode,vcur_user,eqp,dt_change,enable);

    else
   
     for client in select distinct id_client  from 
      (select t.id_client from eqm_tree_tbl as t,eqm_eqp_tree_tbl as tt 
      where tt.code_eqp=eqp and t.id=tt.id_tree group by id_client 
      union 
      select id_client from eqm_eqp_use_tbl where code_eqp=eqp
      ) as a
  --    where a.id_client <> syi_resid_fun()
     loop
      -- ������ ����� �墠�뢠�� ��᪮�쪮 ������⮢
      -- ��砩 㤠����� �࠭��

      Insert into eqt_change_tbl(id_operation,mode,id_client,id_usr,code_eqp,date_change,enabled)
      values (operation,changemode,client.id_client,vcur_user,eqp,dt_change,enable);

     end loop;

    end if;
   end if;
   --  
   Insert into eqm_changelog_tbl
   select * from  eqt_change_tbl where id_operation = operation;

   Return operation;  
end;
' language 'plpgsql' ;

--�������/�몫���� ०�� ����� ���������
/*
DROP function eq_change_switch_fun(boolean);
Create function eq_change_switch_fun(boolean) returns int as'
begin
update pg_trigger set tgenabled = $1 where tgname=''eqm_deleqp_write_trg'';
update pg_trigger set tgenabled = $1 where tgname=''eqm_edeqp_write_trg'';

return 0;
end;
' language 'plpgsql' ;
*/