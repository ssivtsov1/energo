insert into eqi_grouptarif_tbl(id,name,short_name,flag_priv,ident) 
values(900,'����� �� ����������� �����i��ϕ ���������','����������� �����i��� ���������',false,'tgr_pwr');


update ACI_tarif_tbl set id_grouptarif=900 where id_grouptarif=100 and id=100;