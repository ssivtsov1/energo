drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
begin
if (select count(*) from pg_class where relname=''acm_k_fi_tbl'')=0 then
create table acm_k_fi_tbl (
     tg		numeric(4,2),
     k_fi	numeric(6,4),
     primary key(tg)
);

insert into acm_k_fi_tbl values(0.00,1.0000);
insert into acm_k_fi_tbl values(0.01,1.0000);
insert into acm_k_fi_tbl values(0.02,1.0000);
insert into acm_k_fi_tbl values(0.03,1.0000);
insert into acm_k_fi_tbl values(0.04,1.0000);
insert into acm_k_fi_tbl values(0.05,1.0000);
insert into acm_k_fi_tbl values(0.06,1.0000);
insert into acm_k_fi_tbl values(0.07,1.0000);
insert into acm_k_fi_tbl values(0.08,1.0000);
insert into acm_k_fi_tbl values(0.09,1.0000);
insert into acm_k_fi_tbl values(0.10,1.0000);
insert into acm_k_fi_tbl values(0.11,1.0000);
insert into acm_k_fi_tbl values(0.12,1.0000);
insert into acm_k_fi_tbl values(0.13,1.0000);
insert into acm_k_fi_tbl values(0.14,1.0000);
insert into acm_k_fi_tbl values(0.15,1.0000);
insert into acm_k_fi_tbl values(0.16,1.0000);
insert into acm_k_fi_tbl values(0.17,1.0000);
insert into acm_k_fi_tbl values(0.18,1.0000);
insert into acm_k_fi_tbl values(0.19,1.0000);
insert into acm_k_fi_tbl values(0.20,1.0000);
insert into acm_k_fi_tbl values(0.21,1.0000);
insert into acm_k_fi_tbl values(0.22,1.0000);
insert into acm_k_fi_tbl values(0.23,1.0000);
insert into acm_k_fi_tbl values(0.24,1.0000);
insert into acm_k_fi_tbl values(0.25,1.0000);
insert into acm_k_fi_tbl values(0.26,1.0001);
insert into acm_k_fi_tbl values(0.27,1.0004);
insert into acm_k_fi_tbl values(0.28,1.0009);
insert into acm_k_fi_tbl values(0.29,1.0016);
insert into acm_k_fi_tbl values(0.30,1.0025);
insert into acm_k_fi_tbl values(0.31,1.0036);
insert into acm_k_fi_tbl values(0.32,1.0049);
insert into acm_k_fi_tbl values(0.33,1.0064);
insert into acm_k_fi_tbl values(0.34,1.0081);
insert into acm_k_fi_tbl values(0.35,1.0100);
insert into acm_k_fi_tbl values(0.36,1.0121);
insert into acm_k_fi_tbl values(0.37,1.0144);
insert into acm_k_fi_tbl values(0.38,1.0169);
insert into acm_k_fi_tbl values(0.39,1.0196);
insert into acm_k_fi_tbl values(0.40,1.0225);
insert into acm_k_fi_tbl values(0.41,1.0256);
insert into acm_k_fi_tbl values(0.42,1.0289);
insert into acm_k_fi_tbl values(0.43,1.0324);
insert into acm_k_fi_tbl values(0.44,1.0361);
insert into acm_k_fi_tbl values(0.45,1.0400);
insert into acm_k_fi_tbl values(0.46,1.0441);
insert into acm_k_fi_tbl values(0.47,1.0484);
insert into acm_k_fi_tbl values(0.48,1.0529);
insert into acm_k_fi_tbl values(0.49,1.0576);
insert into acm_k_fi_tbl values(0.50,1.0625);
insert into acm_k_fi_tbl values(0.51,1.0676);
insert into acm_k_fi_tbl values(0.52,1.0729);
insert into acm_k_fi_tbl values(0.53,1.0784);
insert into acm_k_fi_tbl values(0.54,1.0841);
insert into acm_k_fi_tbl values(0.55,1.0900);
insert into acm_k_fi_tbl values(0.56,1.0961);
insert into acm_k_fi_tbl values(0.57,1.1024);
insert into acm_k_fi_tbl values(0.58,1.1089);
insert into acm_k_fi_tbl values(0.59,1.1156);
insert into acm_k_fi_tbl values(0.60,1.1225);
insert into acm_k_fi_tbl values(0.61,1.1296);
insert into acm_k_fi_tbl values(0.62,1.1369);
insert into acm_k_fi_tbl values(0.63,1.1444);
insert into acm_k_fi_tbl values(0.64,1.1521);
insert into acm_k_fi_tbl values(0.65,1.1600);
insert into acm_k_fi_tbl values(0.66,1.1681);
insert into acm_k_fi_tbl values(0.67,1.1764);
insert into acm_k_fi_tbl values(0.68,1.1849);
insert into acm_k_fi_tbl values(0.69,1.1936);
insert into acm_k_fi_tbl values(0.70,1.2025);
insert into acm_k_fi_tbl values(0.71,1.2116);
insert into acm_k_fi_tbl values(0.72,1.2209);
insert into acm_k_fi_tbl values(0.73,1.2304);
insert into acm_k_fi_tbl values(0.74,1.2401);
insert into acm_k_fi_tbl values(0.75,1.2500);
insert into acm_k_fi_tbl values(0.76,1.2601);
insert into acm_k_fi_tbl values(0.77,1.2704);
insert into acm_k_fi_tbl values(0.78,1.2809);
insert into acm_k_fi_tbl values(0.79,1.2916);
insert into acm_k_fi_tbl values(0.80,1.3025);
insert into acm_k_fi_tbl values(0.81,1.3136);
insert into acm_k_fi_tbl values(0.82,1.3249);
insert into acm_k_fi_tbl values(0.83,1.3364);
insert into acm_k_fi_tbl values(0.84,1.3481);
insert into acm_k_fi_tbl values(0.85,1.3600);
insert into acm_k_fi_tbl values(0.86,1.3721);
insert into acm_k_fi_tbl values(0.87,1.3844);
insert into acm_k_fi_tbl values(0.88,1.3969);
insert into acm_k_fi_tbl values(0.89,1.4096);
insert into acm_k_fi_tbl values(0.90,1.4225);
insert into acm_k_fi_tbl values(0.91,1.4356);
insert into acm_k_fi_tbl values(0.92,1.4489);
insert into acm_k_fi_tbl values(0.93,1.4624);
insert into acm_k_fi_tbl values(0.94,1.4761);
insert into acm_k_fi_tbl values(0.95,1.4900);
insert into acm_k_fi_tbl values(0.96,1.5041);
insert into acm_k_fi_tbl values(0.97,1.5184);
insert into acm_k_fi_tbl values(0.98,1.5329);
insert into acm_k_fi_tbl values(0.99,1.5476);
insert into acm_k_fi_tbl values(1.00,1.5625);

insert into acm_k_fi_tbl values(1.01,1.5776);
insert into acm_k_fi_tbl values(1.02,1.5929);
insert into acm_k_fi_tbl values(1.03,1.6084);
insert into acm_k_fi_tbl values(1.04,1.6241);
insert into acm_k_fi_tbl values(1.05,1.6400);
insert into acm_k_fi_tbl values(1.06,1.6561);
insert into acm_k_fi_tbl values(1.07,1.6724);
insert into acm_k_fi_tbl values(1.08,1.6889);
insert into acm_k_fi_tbl values(1.09,1.7056);
insert into acm_k_fi_tbl values(1.10,1.7225);
insert into acm_k_fi_tbl values(1.11,1.7396);
insert into acm_k_fi_tbl values(1.12,1.7569);
insert into acm_k_fi_tbl values(1.13,1.7744);
insert into acm_k_fi_tbl values(1.14,1.7921);
insert into acm_k_fi_tbl values(1.15,1.8100);
insert into acm_k_fi_tbl values(1.16,1.8281);
insert into acm_k_fi_tbl values(1.17,1.8464);
insert into acm_k_fi_tbl values(1.18,1.8649);
insert into acm_k_fi_tbl values(1.19,1.8836);
insert into acm_k_fi_tbl values(1.20,1.9025);
insert into acm_k_fi_tbl values(1.21,1.9216);
insert into acm_k_fi_tbl values(1.22,1.9409);
insert into acm_k_fi_tbl values(1.23,1.9604);
insert into acm_k_fi_tbl values(1.24,1.9801);
insert into acm_k_fi_tbl values(1.25,2.0000);
insert into acm_k_fi_tbl values(1.26,2.0201);
insert into acm_k_fi_tbl values(1.27,2.0404);
insert into acm_k_fi_tbl values(1.28,2.0609);
insert into acm_k_fi_tbl values(1.29,2.0816);
insert into acm_k_fi_tbl values(1.30,2.1025);
insert into acm_k_fi_tbl values(1.31,2.1236);
insert into acm_k_fi_tbl values(1.32,2.1449);
insert into acm_k_fi_tbl values(1.33,2.1664);
insert into acm_k_fi_tbl values(1.34,2.1881);
insert into acm_k_fi_tbl values(1.35,2.2100);
insert into acm_k_fi_tbl values(1.36,2.2321);
insert into acm_k_fi_tbl values(1.37,2.2544);
insert into acm_k_fi_tbl values(1.38,2.2769);
insert into acm_k_fi_tbl values(1.39,2.2996);
insert into acm_k_fi_tbl values(1.40,2.3225);
insert into acm_k_fi_tbl values(1.41,2.3456);
insert into acm_k_fi_tbl values(1.42,2.3689);
insert into acm_k_fi_tbl values(1.43,2.3924);
insert into acm_k_fi_tbl values(1.44,2.4161);
insert into acm_k_fi_tbl values(1.45,2.4400);
insert into acm_k_fi_tbl values(1.46,2.4641);
insert into acm_k_fi_tbl values(1.47,2.4884);
insert into acm_k_fi_tbl values(1.48,2.5129);
insert into acm_k_fi_tbl values(1.49,2.5376);
insert into acm_k_fi_tbl values(1.50,2.5625);
insert into acm_k_fi_tbl values(1.51,2.5876);
insert into acm_k_fi_tbl values(1.52,2.6129);
insert into acm_k_fi_tbl values(1.53,2.6384);
insert into acm_k_fi_tbl values(1.54,2.6641);
insert into acm_k_fi_tbl values(1.55,2.6900);
insert into acm_k_fi_tbl values(1.56,2.7161);
insert into acm_k_fi_tbl values(1.57,2.7424);
insert into acm_k_fi_tbl values(1.58,2.7689);
insert into acm_k_fi_tbl values(1.59,2.7956);
insert into acm_k_fi_tbl values(1.60,2.8225);
insert into acm_k_fi_tbl values(1.61,2.8496);
insert into acm_k_fi_tbl values(1.62,2.8769);
insert into acm_k_fi_tbl values(1.63,2.9044);
insert into acm_k_fi_tbl values(1.64,2.9321);
insert into acm_k_fi_tbl values(1.65,2.9600);
insert into acm_k_fi_tbl values(1.66,2.9881);
insert into acm_k_fi_tbl values(1.67,3.0164);
insert into acm_k_fi_tbl values(1.68,3.0449);
insert into acm_k_fi_tbl values(1.69,3.0736);
insert into acm_k_fi_tbl values(1.70,3.1025);
insert into acm_k_fi_tbl values(1.71,3.1316);
insert into acm_k_fi_tbl values(1.72,3.1609);
insert into acm_k_fi_tbl values(1.73,3.1904);
insert into acm_k_fi_tbl values(1.74,3.2201);
insert into acm_k_fi_tbl values(1.75,3.2500);
insert into acm_k_fi_tbl values(1.76,3.2801);
insert into acm_k_fi_tbl values(1.77,3.3104);
insert into acm_k_fi_tbl values(1.78,3.3409);
insert into acm_k_fi_tbl values(1.79,3.3716);
insert into acm_k_fi_tbl values(1.80,3.4025);
insert into acm_k_fi_tbl values(1.81,3.4336);
insert into acm_k_fi_tbl values(1.82,3.4649);
insert into acm_k_fi_tbl values(1.83,3.4964);
insert into acm_k_fi_tbl values(1.84,3.5281);
insert into acm_k_fi_tbl values(1.85,3.5600);
insert into acm_k_fi_tbl values(1.86,3.5921);
insert into acm_k_fi_tbl values(1.87,3.6244);
insert into acm_k_fi_tbl values(1.88,3.6569);
insert into acm_k_fi_tbl values(1.89,3.6896);
insert into acm_k_fi_tbl values(1.90,3.7225);
insert into acm_k_fi_tbl values(1.91,3.7556);
insert into acm_k_fi_tbl values(1.92,3.7889);
insert into acm_k_fi_tbl values(1.93,3.8224);
insert into acm_k_fi_tbl values(1.94,3.8561);
insert into acm_k_fi_tbl values(1.95,3.8900);
insert into acm_k_fi_tbl values(1.96,3.9241);
insert into acm_k_fi_tbl values(1.97,3.9584);
insert into acm_k_fi_tbl values(1.98,3.9929);
insert into acm_k_fi_tbl values(1.99,4.0276);
insert into acm_k_fi_tbl values(2.00,4.0625);
 Return true;
else
 Return false;
end if;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();


drop function upd_tbl_tmp();
CREATE function upd_tbl_tmp() Returns boolean As'
Declare
begin
if (select count(*) from pg_class where relname=''acm_k_corr_tbl'')=0 then
create table acm_k_corr_tbl (
     cnt_year	int,
     k_corr	numeric(4,2),
     primary key(cnt_year)
);

 insert into acm_k_corr_tbl(cnt_year,k_corr) 
 values(1,0.25);
 insert into acm_k_corr_tbl(cnt_year,k_corr) 
 values(2,0.5);
 insert into acm_k_corr_tbl(cnt_year,k_corr) 
 values(3,0.75);
 insert into acm_k_corr_tbl(cnt_year,k_corr) 
 values(4,1);
 Return true;
else
 Return false;
end if;
end;
' Language 'plpgsql';

select upd_tbl_tmp();
drop function upd_tbl_tmp();

alter table clm_statecl_tbl add column dt_re_start date;
