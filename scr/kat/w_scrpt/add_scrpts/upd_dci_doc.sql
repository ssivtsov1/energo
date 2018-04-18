update dci_document_tbl set name='Временное подключение',ident='temp_dem' 
 where id=530;
update dci_document_tbl set name='Перерасчет потребления',ident='add_pntdem' 
 where id=540;
update dci_document_tbl set name='Перерасчет суммы',ident='cor_sum' 
 where id=550;

insert into dci_document_tbl(id,name,ident) 
values(203,'Счет на временное подключение','bill_temp');
insert into dci_document_tbl(id,name,ident) 
values(204,'Счет для перерасчета потребления','bill_addp');
insert into dci_document_tbl(id,name,ident) 
values(205,'Счет для перерасчета суммы начисления','bill_cors');

insert into dci_document_tbl(id,name,idk_document,ident) 
values(140,'Списание',100,'writeoff');