update dci_document_tbl set name='��������� �����������',ident='temp_dem' 
 where id=530;
update dci_document_tbl set name='���������� �����������',ident='add_pntdem' 
 where id=540;
update dci_document_tbl set name='���������� �����',ident='cor_sum' 
 where id=550;

insert into dci_document_tbl(id,name,ident) 
values(203,'���� �� ��������� �����������','bill_temp');
insert into dci_document_tbl(id,name,ident) 
values(204,'���� ��� ����������� �����������','bill_addp');
insert into dci_document_tbl(id,name,ident) 
values(205,'���� ��� ����������� ����� ����������','bill_cors');

insert into dci_document_tbl(id,name,idk_document,ident) 
values(140,'��������',100,'writeoff');