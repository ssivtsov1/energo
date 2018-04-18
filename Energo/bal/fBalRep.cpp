//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fBalRep.h"
#include "main.h";
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma resource "*.dfm"
TfBalansRep *BalansReports;
float e_demand;
float f_demand;
float abn_demand;
TDateTime dat_b;
TDateTime dat_e;

//---------------------------------------------------------------------------
__fastcall TfBalansRep::TfBalansRep(TComponent* Owner)
        : TForm(Owner)
{

//ZQEntryBal->Database=TWTTable::Database;
//ZQNoEntryBal->Database=TWTTable::Database;
ZQFiderBal->Database=TWTTable::Database;
ZQFiderBalXL->Database=TWTTable::Database;
ZQPrepare->Database=TWTTable::Database;
ZQTreeDemand->Database=TWTTable::Database;
ZQTreeLosts->Database=TWTTable::Database;
ZQSummBal->Database=TWTTable::Database;
ZQSummBal->Database=TWTTable::Database;
ZQBalLev1_e->Database=TWTTable::Database;
ZQBalLev1_f->Database=TWTTable::Database;
ZQBalLev2->Database=TWTTable::Database;
ZQBalRoot->Database=TWTTable::Database;
ZQBalMeters->Database=TWTTable::Database;
ZQPSBal->Database=TWTTable::Database;
ZQPSDemand->Database=TWTTable::Database;
ZQPSMeters->Database=TWTTable::Database;
ZQXLReps->Database=TWTTable::Database;
ZQXLReps2->Database=TWTTable::Database;
ZQXLReps3->Database=TWTTable::Database;
ZQXLReps4->Database=TWTTable::Database;
ZQXLRepsSum->Database=TWTTable::Database;
ZQDemandNewSum->Database=TWTTable::Database;
ZQDemandNew->Database=TWTTable::Database;
ZQMidPointBal->Database=TWTTable::Database;
ZQMidPointDemand->Database=TWTTable::Database;
ZQMidPointMeters->Database=TWTTable::Database;

}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::ShowBalansStation(int id_station,TDateTime mmgg,AnsiString name_station,int type_eqp,int show_meters)
{
// Определим, есть ли вводы на ПС

  ZQPrepare->Close();
  ZQFiderBal->Close();
  ZQBalLev1_e->Close();
  ZQBalLev1_f->Close();
  ZQBalLev2->Close();
  ZQBalRoot->Close();
  ZQBalMeters->Close();

  if (type_eqp==8)
  {
   int is_entry;

   ZQPrepare->Sql->Clear();
   ZQPrepare->Sql->Add("select count(gt.code_eqp) as entrys from bal_grp_tree_tmp as gt ");
   ZQPrepare->Sql->Add("where gt.id_p_eqp = :station and gt.type_eqp=3 and gt.mmgg = :dat;");

   ZQPrepare->ParamByName("station")->AsInteger=id_station;
   ZQPrepare->ParamByName("dat")->AsDateTime=mmgg;

   try
   {
    ZQPrepare->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка. ");
    ZQPrepare->Close();
    return;
   }
   if (ZQPrepare->RecordCount!=0)
   {
     ZQPrepare->First();
     is_entry=ZQPrepare->FieldByName("entrys")->AsInteger;
   }
   ZQPrepare->Close();

   qrStationBalans->DataSet=ZQBalRoot;
   qrStationBalans->DataSet->Close();
   ((TZPgSqlQuery *)(qrStationBalans->DataSet))->ParamByName("station")->AsInteger=id_station;
   ((TZPgSqlQuery *)(qrStationBalans->DataSet))->ParamByName("dat")->AsDateTime=mmgg;
   ((TZPgSqlQuery *)(qrStationBalans->DataSet))->Open();


   if (is_entry==0) //нет вводов
   {
    QRMain->Enabled=false;
    QRSubDetail1->Enabled=false;
    QRGroup2->Enabled=false;
    qrEntryFooter->Enabled=false;
    QRStBalSum->Enabled=false;

    QRGroup1->Enabled=true;
    QRSubDetail2->Enabled=true;
    SummaryBand1->Enabled=true;

    QRSubDetail2->DataSet=ZQBalLev1_f;

   ZQBalLev1_f->ParamByName("station")->AsInteger=id_station;
   ZQBalLev1_f->ParamByName("dat")->AsDateTime=mmgg;
   ZQBalLev1_f->Open();

   }
   else
   {
     // Выбрать потребление абонентов  с вводов ПС

    ZQPrepare->Sql->Clear();
    ZQPrepare->Sql->Add("select sum(gt2.demand) as demand from bal_grp_tree_tmp as gt ");
    ZQPrepare->Sql->Add(" left join bal_grp_tree_tmp as gt2 on (gt2.id_p_eqp = gt.code_eqp) ");
    ZQPrepare->Sql->Add(" where gt.id_p_eqp = :station and gt.type_eqp=3 and gt.mmgg = :dat ");
    ZQPrepare->Sql->Add(" and gt2.type_eqp=12 and gt2.mmgg = :dat;");

    ZQPrepare->ParamByName("station")->AsInteger=id_station;
    ZQPrepare->ParamByName("dat")->AsDateTime=mmgg;

    try
    {
     ZQPrepare->Open();
    }
    catch(...)
    {
     ShowMessage("Ошибка. ");
     ZQPrepare->Close();
     return;
    }
    if (ZQPrepare->RecordCount!=0)
    {
      ZQPrepare->First();
      abn_demand=ZQPrepare->FieldByName("demand")->AsFloat;
    }
    ZQPrepare->Close();


   //---------------------------------------------------------------------------

    QRMain->Enabled=false;

    QRSubDetail1->Enabled=true;
    QRSubDetail2->Enabled=true;
    QRGroup2->Enabled=true;
    QRGroup1->Enabled=true;
    qrEntryFooter->Enabled=true;
    SummaryBand1->Enabled=true;
    QRStBalSum->Enabled=true;

    QRSubDetail2->DataSet=ZQBalLev2;

    ZQBalLev2->ParamByName("station")->AsInteger=id_station;
    ZQBalLev2->ParamByName("dat")->AsDateTime=mmgg;
    ZQBalLev2->Open();

    ZQBalLev1_e->ParamByName("station")->AsInteger=id_station;
    ZQBalLev1_e->ParamByName("dat")->AsDateTime=mmgg;
    ZQBalLev1_e->Open();
   }

    if (show_meters==1)
    {
     QRsdMeters->Enabled=true;
     QRsdMeters->Master = QRSubDetail2;
     dsMetersSrc->DataSet=QRSubDetail2->DataSet;
     ZQBalMeters->ParamByName("dat")->AsDateTime=mmgg;
     ZQBalMeters->Open();
    }
    else QRsdMeters->Enabled=false;
  }

  if (type_eqp==15)
  {

    QRSubDetail1->Enabled=false;
    QRSubDetail2->Enabled=false;
    QRGroup2->Enabled=false;
    QRGroup1->Enabled=false;
    qrEntryFooter->Enabled=false;
    QRStBalSum->Enabled=false;
    SummaryBand1->Enabled=false;

    QRMain->Enabled=true;
    qrStationBalans->DataSet=ZQFiderBal;

    qrStationBalans->DataSet->Close();
    ((TZPgSqlQuery *)(qrStationBalans->DataSet))->ParamByName("station")->AsInteger=id_station;
    ((TZPgSqlQuery *)(qrStationBalans->DataSet))->ParamByName("dat")->AsDateTime=mmgg;
    ((TZPgSqlQuery *)(qrStationBalans->DataSet))->Open();


    if (show_meters==1)
    {
     QRsdMeters->Enabled=true;
     QRsdMeters->Master = qrStationBalans;
     dsMetersSrc->DataSet=ZQFiderBal;
     ZQBalMeters->ParamByName("dat")->AsDateTime=mmgg;
     ZQBalMeters->Open();
    }
    else QRsdMeters->Enabled=false;


  }

   qrlStation->Caption=name_station;
   qrlResName->Caption=ResName;
   qrlMMGG->Caption=FormatDateTime("mmmm yyyy", mmgg);

    qrStationBalans->Preview();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::ShowBalansSumm(TDateTime mmgg)
{
   ZQSummBal->Close();
   ZQSummBal->ParamByName("dat")->AsDateTime=mmgg;
   ZQSummBal->Open();

   qrlResName4->Caption=ResName;
   qrlMMGG4->Caption=FormatDateTime("mmmm yyyy", mmgg);

   qrSummBal->Preview();
}
//--------------------------------
void __fastcall TfBalansRep::ShowTreeDemand(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage)
{
ZQTreeDemand->Close();
ZQTreeLosts->Close();

int switch_key=voltage*100+type_eqp;

/*
     switch (type_eqp){
        case 3:
        case 8:
        case 15:
     }
*/


QRGroup_e10->Enabled=true;
QRGroup_s10->Enabled=true;
QRGroup_f10->Enabled=true;
QRGroup_e35->Enabled=true;
QRGroup_s35->Enabled=true;
QRGroup_f35->Enabled=true;
QRGroup_e110->Enabled=true;
QRGroup_s110->Enabled=true;
QRGroup_f110->Enabled=true;

switch (switch_key){

  case 403 :
  case 408 :
  case 415 :   QRGroup_e10->Enabled=false;
  case 303:    QRGroup_s10->Enabled=false;
  case 308:    QRGroup_f10->Enabled=false;
  case 315:    QRGroup_e35->Enabled=false;
  case 203:    QRGroup_s35->Enabled=false;  //e35
  case 208:    QRGroup_f35->Enabled=false;  //s35
  case 215:    QRGroup_e110->Enabled=false; //f35
  case 103:    QRGroup_s110->Enabled=false;   //e110
  case 108:    QRGroup_f110->Enabled=false;  //s110
  case 115:    break;    //f110
}

int level;
level=1;
AnsiString order_str="";

if(QRGroup_f110->Enabled)
 {
  ZQTreeDemand->MacroByName("lev1")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as f110, name"+IntToStr(level)+" as f110_name, dem"+
   IntToStr(level)+" as f110_dem, ktr_dem"+IntToStr(level)+" as f110_ktr_dem, ";
   level++;
   order_str=order_str+"coalesce(f110_name,'')";
 }
else ZQTreeDemand->MacroByName("lev1")->AsString="";

if(QRGroup_s110->Enabled)
 {
  ZQTreeDemand->MacroByName("lev2")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as s110, name"+IntToStr(level)+" as s110_name, dem"+
   IntToStr(level)+" as s110_dem, ktr_dem"+IntToStr(level)+" as s110_ktr_dem, ";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(s110_name,'')";
 }
else ZQTreeDemand->MacroByName("lev2")->AsString="";

if(QRGroup_e110->Enabled)
 {
  ZQTreeDemand->MacroByName("lev3")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as e110, name"+IntToStr(level)+" as e110_name, dem"+
   IntToStr(level)+" as e110_dem, ktr_dem"+IntToStr(level)+" as e110_ktr_dem, ";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(e110_name,'')";

 }
else ZQTreeDemand->MacroByName("lev3")->AsString="";

if(QRGroup_f35->Enabled)
 {
  ZQTreeDemand->MacroByName("lev4")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as f35, name"+IntToStr(level)+" as f35_name, dem"+
   IntToStr(level)+" as f35_dem, ktr_dem"+IntToStr(level)+" as f35_ktr_dem, ";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(f35_name,'')";

 }

else ZQTreeDemand->MacroByName("lev4")->AsString="";

if(QRGroup_s35->Enabled)
 {
  ZQTreeDemand->MacroByName("lev5")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as s35, name"+IntToStr(level)+" as s35_name, dem"+
   IntToStr(level)+" as s35_dem, ktr_dem"+IntToStr(level)+" as s35_ktr_dem, ";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(s35_name,'')";

 }
else ZQTreeDemand->MacroByName("lev5")->AsString="";

if(QRGroup_e35->Enabled)
 {
  ZQTreeDemand->MacroByName("lev6")->AsString=
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN gr_"+IntToStr(level)+
   " ELSE null  END AS e35,"+
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN name"+IntToStr(level)+
   " ELSE null  END AS e35_name,"+
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN dem"+IntToStr(level)+
   " ELSE null  END AS e35_dem,"+
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN ktr_dem"+IntToStr(level)+
   " ELSE null  END AS e35_ktr_dem,";

   level++;

   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(e35_name,'')";

 }
else ZQTreeDemand->MacroByName("lev6")->AsString="";

if(QRGroup_f10->Enabled)
 {
  ZQTreeDemand->MacroByName("lev7")->AsString=
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN gr_"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN gr_"+IntToStr(level-1)))+
  " ELSE null END AS f10,"+
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN name"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN name"+IntToStr(level-1)))+
  " ELSE null END AS f10_name,"+
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN dem"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN dem"+IntToStr(level-1)))+
  " ELSE null END AS f10_dem,"+
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN ktr_dem"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN ktr_dem"+IntToStr(level-1)))+
  " ELSE null END AS f10_ktr_dem,";

   level++;

   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(f10_name,'')";

 }
else ZQTreeDemand->MacroByName("lev7")->AsString="";

if(QRGroup_s10->Enabled)
 {
  ZQTreeDemand->MacroByName("lev8")->AsString=
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN gr_"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN gr_"+IntToStr(level-1)))+
  " ELSE null END AS s10,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN name"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN name"+IntToStr(level-1)))+
  " ELSE null END AS s10_name,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN dem"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN dem"+IntToStr(level-1)))+
  " ELSE null END AS s10_dem,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN ktr_dem"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN ktr_dem"+IntToStr(level-1)))+
  " ELSE null END AS s10_ktr_dem,";

   level++;

   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(s10_name,'')";

 }
else ZQTreeDemand->MacroByName("lev8")->AsString="";

if(QRGroup_e10->Enabled)
 {
  ZQTreeDemand->MacroByName("lev9")->AsString=
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN gr_"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN gr_"+IntToStr(level-1)))+
  " ELSE null END AS e10,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN name"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN name"+IntToStr(level-1)))+
  " ELSE null END AS e10_name,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN dem"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN dem"+IntToStr(level-1)))+
  " ELSE null END AS e10_dem,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN ktr_dem"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN ktr_dem"+IntToStr(level-1)))+
  " ELSE null END AS e10_ktr_dem,";

   level++;

   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(e10_name,'')";

 }
else ZQTreeDemand->MacroByName("lev9")->AsString="";

 ZQTreeDemand->MacroByName("lev10")->AsString=
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN gr_"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN gr_"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN gr_"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN gr_"+IntToStr(level-4)))+
 " ELSE null END AS f04,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN name"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN name"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN name"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN name"+IntToStr(level-4)))+
 " ELSE null END AS f04_name,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN dem"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN dem"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN dem"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN dem"+IntToStr(level-4)))+
 " ELSE null END AS f04_dem,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN ktr_dem"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN ktr_dem"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN ktr_dem"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN ktr_dem"+IntToStr(level-4)))+
 " ELSE null END AS f04_ktr_dem,";

  if (order_str!="") order_str=order_str + ", ";
  order_str=order_str+"coalesce(f04_name,'')";


  if (order_str!="") order_str=order_str + ", ";
  order_str=order_str+" code ";

 ZQTreeDemand->MacroByName("order_val")->AsString= order_str;

 ZQTreeDemand->ParamByName("code_eqp")->AsInteger=id_eqp;
 ZQTreeDemand->ParamByName("mmgg")->AsDateTime=mmgg;
 ZQTreeDemand->ParamByName("res")->AsInteger=ResId; 
 ZQTreeDemand->Open();

 qrlResName2->Caption=ResName;
 qrlStation2->Caption=name_eqp;
 qrlMMGG2->Caption=FormatDateTime("mmmm yyyy", mmgg);

 qrTreeDemand->Preview();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::QRGroup_BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 PrintBand=!(ZQTreeDemand->FieldByName(((TQRGroup*)Sender)->Expression)->IsNull);
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::ShowTreeLosts(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage)
{
ZQTreeLosts->Close();
ZQTreeDemand->Close();

  AnsiString  sqlstr=" select dat_b, dat_e from bal_grp_tree_tmp where mmgg = :mmgg limit 1; ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->Open();

  dat_b = ZQXLReps->FieldByName("dat_b")->AsDateTime;
  dat_e = ZQXLReps->FieldByName("dat_e")->AsDateTime;
  ZQXLReps->Close();


AnsiString order_str="";

int switch_key=voltage*100+type_eqp;

QRGroup2_e10->Enabled=true;
QRGroup2_s10->Enabled=true;
QRGroup2_f10->Enabled=true;
QRGroup2_e35->Enabled=true;
QRGroup2_s35->Enabled=true;
QRGroup2_f35->Enabled=true;
QRGroup2_e110->Enabled=true;
QRGroup2_s110->Enabled=true;
QRGroup2_f110->Enabled=true;

switch (switch_key){

  case 403 :
  case 408 :
  case 415 :   QRGroup2_e10->Enabled=false;
  case 303:    QRGroup2_s10->Enabled=false;
  case 308:    QRGroup2_f10->Enabled=false;
  case 315:    QRGroup2_e35->Enabled=false;
  case 203:    QRGroup2_s35->Enabled=false;  //e35
  case 208:    QRGroup2_f35->Enabled=false;  //s35
  case 215:    QRGroup2_e110->Enabled=false; //f35
  case 103:    QRGroup2_s110->Enabled=false;   //e110
  case 108:    QRGroup2_f110->Enabled=false;  //s110
  case 115:    break;    //f110
}

int level;
level=1;

if(QRGroup2_f110->Enabled)
 {
  ZQTreeLosts->MacroByName("lev1")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as f110, name"+IntToStr(level)+" as f110_name, lost"+
   IntToStr(level)+" as f110_lost, key"+IntToStr(level)+" as f110_key,";
   level++;
   order_str=order_str+"coalesce(f110_name,'')";
 }
else ZQTreeLosts->MacroByName("lev1")->AsString="";

if(QRGroup2_s110->Enabled)
 {
  ZQTreeLosts->MacroByName("lev2")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as s110, name"+IntToStr(level)+" as s110_name, lost"+
   IntToStr(level)+" as s110_lost, key"+ IntToStr(level)+" as s110_key, ";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(s110_name,'')";

 }
else ZQTreeLosts->MacroByName("lev2")->AsString="";

if(QRGroup2_e110->Enabled)
 {
  ZQTreeLosts->MacroByName("lev3")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as e110, name"+IntToStr(level)+" as e110_name, lost"+
   IntToStr(level)+" as e110_lost, key"+IntToStr(level)+" as e110_key, ";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(e110_name,'')";

 }
else ZQTreeLosts->MacroByName("lev3")->AsString="";

if(QRGroup2_f35->Enabled)
 {
  ZQTreeLosts->MacroByName("lev4")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as f35, name"+IntToStr(level)+" as f35_name, lost"+
   IntToStr(level)+" as f35_lost, key"+IntToStr(level)+" as f35_key,";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(f35_name,'')";

 }
else ZQTreeLosts->MacroByName("lev4")->AsString="";

if(QRGroup2_s35->Enabled)
 {
  ZQTreeLosts->MacroByName("lev5")->AsString=
   " bigsel.gr_"+IntToStr(level)+" as s35, name"+IntToStr(level)+" as s35_name, lost"+
   IntToStr(level)+" as s35_lost, key"+IntToStr(level)+" as s35_key,";
   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(s35_name,'')";

 }
else ZQTreeLosts->MacroByName("lev5")->AsString="";

if(QRGroup2_e35->Enabled)
 {
  ZQTreeLosts->MacroByName("lev6")->AsString=
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN gr_"+IntToStr(level)+
   " ELSE null  END AS e35,"+
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN name"+IntToStr(level)+
   " ELSE null  END AS e35_name,"+
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN lost"+IntToStr(level)+
   " ELSE null  END AS e35_lost,"+
   " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=2 THEN key"+IntToStr(level)+
   " ELSE null  END AS e35_key,";

   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(e35_name,'')";

 }
else ZQTreeLosts->MacroByName("lev6")->AsString="";

if(QRGroup2_f10->Enabled)
 {
  ZQTreeLosts->MacroByName("lev7")->AsString=
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN gr_"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN gr_"+IntToStr(level-1)))+
  " ELSE null END AS f10,"+
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN name"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN name"+IntToStr(level-1)))+
  " ELSE null END AS f10_name,"+
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN lost"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN lost"+IntToStr(level-1)))+
  " ELSE null END AS f10_lost,"+
  " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=3 THEN key"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=3 THEN key"+IntToStr(level-1)))+
  " ELSE null END AS f10_key,";

   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(f10_name,''), f10_key";

 }
else ZQTreeLosts->MacroByName("lev7")->AsString="";

if(QRGroup2_s10->Enabled)
 {
  ZQTreeLosts->MacroByName("lev8")->AsString=
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN gr_"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN gr_"+IntToStr(level-1)))+
  " ELSE null END AS s10,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN name"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN name"+IntToStr(level-1)))+
  " ELSE null END AS s10_name,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN lost"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN lost"+IntToStr(level-1)))+
  " ELSE null END AS s10_lost,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN dat_b"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN dat_b"+IntToStr(level-1)))+
  " ELSE null END AS s10_dat_b,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN dat_e"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN dat_e"+IntToStr(level-1)))+
  " ELSE null END AS s10_dat_e,"+
  " CASE WHEN type"+IntToStr(level)+"=8 and volt"+IntToStr(level)+"=3 THEN key"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=8 and volt"+IntToStr(level-1)+"=3 THEN key"+IntToStr(level-1)))+
  " ELSE null END AS s10_key,";


   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(s10_name,''), s10_key ";

 }
else ZQTreeLosts->MacroByName("lev8")->AsString="";

if(QRGroup2_e10->Enabled)
 {
  ZQTreeLosts->MacroByName("lev9")->AsString=
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN gr_"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN gr_"+IntToStr(level-1)))+
  " ELSE null END AS e10,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN name"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN name"+IntToStr(level-1)))+
  " ELSE null END AS e10_name,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN lost"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN lost"+IntToStr(level-1)))+
  " ELSE null END AS e10_lost,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN dat_b"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN dat_b"+IntToStr(level-1)))+
  " ELSE null END AS e10_dat_b,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN dat_e"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN dat_e"+IntToStr(level-1)))+
  " ELSE null END AS e10_dat_e,"+
  " CASE WHEN type"+IntToStr(level)+"=3 and volt"+IntToStr(level)+"=3 THEN key"+IntToStr(level)+
  (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=3 and volt"+IntToStr(level-1)+"=3 THEN key"+IntToStr(level-1)))+
  " ELSE null END AS e10_key,";

   level++;
   if (order_str!="") order_str=order_str + ", ";
   order_str=order_str+"coalesce(e10_name,''), e10_key ";

 }
else ZQTreeLosts->MacroByName("lev9")->AsString="";

 ZQTreeLosts->MacroByName("lev10")->AsString=
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN gr_"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN gr_"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN gr_"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN gr_"+IntToStr(level-4)))+
 " ELSE null END AS f04,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN name"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN name"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN name"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN name"+IntToStr(level-4)))+
 " ELSE null END AS f04_name,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN lost"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN lost"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN lost"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN lost"+IntToStr(level-4)))+
 " ELSE null END AS f04_lost,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN dat_b"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN dat_b"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN dat_b"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN dat_b"+IntToStr(level-4)))+
 " ELSE null END AS f04_dat_b,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN dat_e"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN dat_e"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN dat_e"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN dat_e"+IntToStr(level-4)))+
 " ELSE null END AS f04_dat_e,"+
 " CASE WHEN type"+IntToStr(level)+"=15 and volt"+IntToStr(level)+"=4 THEN key"+IntToStr(level)+
 (level==1 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-1)+"=15 and volt"+IntToStr(level-1)+"=4 THEN key"+IntToStr(level-1)))+
 (level<3 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-2)+"=15 and volt"+IntToStr(level-2)+"=4 THEN key"+IntToStr(level-2)))+
 (level<5 ? AnsiString(" "):AnsiString(" WHEN type"+IntToStr(level-4)+"=15 and volt"+IntToStr(level-4)+"=4 THEN key"+IntToStr(level-4)))+
 " ELSE null END AS f04_key,";


 if (order_str!="") order_str=order_str + ", ";
 order_str=order_str+"coalesce(f04_name,''), f04_key";

  if (order_str!="") order_str=order_str + ", ";
  order_str=order_str+" name_eqp ";


 ZQTreeLosts->MacroByName("order_val")->AsString= order_str;

 ZQTreeLosts->ParamByName("code_eqp")->AsInteger=id_eqp;
 ZQTreeLosts->ParamByName("mmgg")->AsDateTime=mmgg;
 ZQTreeLosts->ParamByName("dt_b")->AsDateTime=dat_b;
 ZQTreeLosts->ParamByName("dt_e")->AsDateTime=dat_e;
 ZQTreeLosts->Open();

 qrlResName3->Caption=ResName;
 qrlStation3->Caption=name_eqp;
 qrlMMGG3->Caption=FormatDateTime("mmmm yyyy", mmgg);

 qrTreeLosts->Preview();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::QRGroup2_f110BeforePrint(
      TQRCustomBand *Sender, bool &PrintBand)
{
 PrintBand=!(ZQTreeLosts->FieldByName(((TQRGroup*)Sender)->Expression)->IsNull);
}
//---------------------------------------------------------------------------


void __fastcall TfBalansRep::QRF10ChildBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
// AnsiString ss = ZQTreeLosts->FieldByName("f10_name")->AsString;
// float i =ZQTreeLosts->FieldByName("f10_coef")->AsFloat;
// PrintBand==((TQRChildBand*)Sender)->ParentBand->Enabled;
 PrintBand=!(ZQTreeLosts->FieldByName("f10_coef")->AsFloat==0);
// PrintBand=!(i==1);
}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::QRGroup2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
  e_demand=0;
//  abn_demand=0;
}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::QRGroup1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
   f_demand=0;           
}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::QRSubDetail1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 e_demand=e_demand+ QRSubDetail1->DataSet->FieldByName("ktr_demand")->AsFloat;
// abn_demand=abn_demand+ QRSubDetail1->DataSet->FieldByName("abn_demand")->AsFloat;

}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::QRSubDetail2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 f_demand=f_demand+ QRSubDetail2->DataSet->FieldByName("f_ktr_demand")->AsFloat;
}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::QRStBalSumBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
//e_ktr_demand-sum(f_ktr_demand)
//IF(e_ktr_demand = 0,0, (e_ktr_demand-sum(f_ktr_demand))/e_ktr_demand*100)
  qrBalPS->Caption = FormatFloat("0",e_demand - f_demand - abn_demand);

  qrlAbonDem->Caption = FormatFloat("0", abn_demand);

  if (e_demand!=0)
    qrBalPSpr->Caption = FormatFloat("0.00",(e_demand - f_demand - abn_demand)/e_demand *100);
  else
    qrBalPSpr->Caption = FormatFloat("0.00",0);
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::FidersToXL(int selected,TDateTime mmgg)
{
// Определим, есть ли вводы на ПС

  ZQFiderBalXL->Close();

  AnsiString sqlstr;

  if (selected==0)
  {
   sqlstr= "  select s.*,  case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name \
   from ( \
   select bd.id_point, gt.name as f_name, gt.code_eqp as f_code_eqp, \
   bd.ktr_demand as f_ktr_demand, \
   gt.demand as f_demand,gt.losts as f_losts, \
   bd.ktr_demand-gt.demand as f_real_losts, \
   round(acc.sumlosts_ti,0) as sumlosts_ti, round(acc.sumlosts_tu,0) as sumlosts_tu , \
   round(acc.sumlosts_meter,0) as sumlosts_meter, round(acc.sumlosts_linea,0) as sumlosts_linea , \
   round(acc.sumlosts_linec,0) as sumlosts_linec, \
   round(acc.sumlosts_xx,0) as sumlosts_xx, round(acc.sumlosts_kz,0) as sumlosts_kz, \
   round(acc.sumlosts_air,0) as sumlosts_air, round(acc.sumlosts_cable,0) as sumlosts_cable, \
   l04.losts04 \
   from \
   ( select code_eqp, coalesce(id_point,101202) as id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from  bal_grp_tree_conn_tmp  where type_eqp=15 and mmgg = :dat group by code_eqp,id_point,name order by id_point) as gt \
    left join bal_demand_tmp as bd  on (bd.id_point=gt.id_point and bd.mmgg = :dat) \
    left join bal_acc_tmp as acc  on (acc.code_eqp=gt.id_point and acc.mmgg = :dat) \
    left join bal_losts04_tmp as l04 on (l04.code_eqp=gt.code_eqp and l04.mmgg = :dat) \
   union \
   select 0, '- С шин ПС 110/35/10'::::varchar,0,sum(gt.demand),sum(gt.demand),0,0,0,0,0,0,0,0,0,0,0,0 \
   from bal_grp_tree_tmp as gt \
   left join bal_grp_tree_tmp as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and gt2.mmgg = :dat \
  and gt.type_eqp=12 and gt.mmgg = :dat \
   order by f_name   )as s \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = s.f_code_eqp and gr1.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :dat::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = s.f_code_eqp) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,f_name ;";

/*
   select 0, '- С шин ПС 110/35/10'::::varchar,0,sum(gt.demand),sum(gt.demand),0,0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt2.id_p_eqp = gt.code_eqp) \
   left join bal_grp_tree_tbl as gt3 on (gt3.id_p_eqp = gt2.code_eqp) \
   where \
   gt.type_eqp=8 and gt.id_voltage <3 and gt.mmgg = :dat \
   and gt2.type_eqp=3 and gt2.mmgg = :dat \
   and gt3.type_eqp=12 and gt3.mmgg = :dat \
*/
  }
  else
  {
   sqlstr= "  select s.*,  case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name  \
    from ( \
   select bd.id_point, gt.name as f_name, gt.code_eqp as f_code_eqp, \
   bd.ktr_demand as f_ktr_demand, \
   gt.demand as f_demand,gt.losts as f_losts, \
   bd.ktr_demand-gt.demand as f_real_losts, \
   round(acc.sumlosts_ti,0) as sumlosts_ti, round(acc.sumlosts_tu,0) as sumlosts_tu , \
   round(acc.sumlosts_meter,0) as sumlosts_meter, round(acc.sumlosts_linea,0) as sumlosts_linea , \
   round(acc.sumlosts_linec,0) as sumlosts_linec, \
   round(acc.sumlosts_xx,0) as sumlosts_xx, round(acc.sumlosts_kz,0) as sumlosts_kz, \
   round(acc.sumlosts_air,0) as sumlosts_air, round(acc.sumlosts_cable,0) as sumlosts_cable, l04.losts04 \
   from \
   ( select code_eqp, coalesce(id_point,101202) as id_point , name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
    from bal_grp_tree_conn_tmp where type_eqp=15 and mmgg = :dat group by code_eqp,id_point,name order by id_point) as gt \
    left join bal_demand_tmp as bd  on (bd.id_point=gt.id_point and bd.mmgg = :dat) \
    left join bal_acc_tmp as acc  on (acc.code_eqp=gt.id_point and acc.mmgg = :dat) \
    left join bal_losts04_tmp as l04 on (l04.code_eqp=gt.code_eqp and l04.mmgg = :dat) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = s.f_code_eqp and gr1.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :dat::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = s.f_code_eqp) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,f_name ;";
  }

  ZQFiderBalXL->Sql->Clear();
  ZQFiderBalXL->Sql->Add(sqlstr);

  ZQFiderBalXL->ParamByName("dat")->AsDateTime=mmgg;

  try
  {
   ZQFiderBalXL->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

 xlReportFiders->XLSTemplate = "XL\\fiders.xls";
 TxlDataSource *Dsr;
 TxlReportParam *Param;
 xlReportFiders->DataSources->Clear();

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQFiderBalXL;
 Dsr->Alias = "ZQXLReps";
 Dsr->Range = "Range";


 xlReportFiders->Params->Clear();
 Param=xlReportFiders->Params->Add();
 Param->Name="lres";
 Param=xlReportFiders->Params->Add();
 Param->Name="lmmgg";
//  Param=xlReport->Params->Add();
//  Param->Name="caption";

 xlReportFiders->ParamByName["lres"]->Value = ResName;
 xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
 ReportName = "Баланс_"+FormatDateTime("mmmm yyyy",mmgg) ;
 xlReportFiders->Report();

 ZQFiderBalXL->Close();

}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::BalansPS_XL(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage)
{
  ZQFiderBalXL->Close();

  if (id_eqp!=0)
    ZQPSBal->ParamByName("obj")->AsInteger = id_eqp;
  else
    ZQPSBal->ParamByName("obj")->Clear();

  ZQPSBal->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQPSDemand->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQPSMeters->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQPSDemand->MasterSource=dsPSBal;
  ZQPSDemand->LinkFields="link = link";

  ZQPSMeters->MasterSource=dsPSBal;
  ZQPSMeters->LinkFields="link = link";

  try
  {
   ZQPSBal->Open();
   ZQPSDemand->Open();
   ZQPSMeters->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

 xlReportFiders->XLSTemplate = "XL\\balans_ktp.xls";
 TxlDataSource *Dsr;
 TxlReportParam *Param;
 xlReportFiders->DataSources->Clear();

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQPSBal;
 Dsr->Alias = "ZQXLRepsPS";
 Dsr->Range = "Range";

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQPSBal;
 Dsr->Alias = "ZQXLRepsPS2";
 Dsr->Range = "Range2";


 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQPSMeters;
 Dsr->Alias = "ZQXLRepsM";
 Dsr->Range = "RangeMeter";
 Dsr->MasterSourceName="ZQXLRepsPS";

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQPSDemand;
 Dsr->Alias = "ZQXLRepsAbon";
 Dsr->Range = "RangeAbon";
 Dsr->MasterSourceName="ZQXLRepsPS";


 xlReportFiders->Params->Clear();
 Param=xlReportFiders->Params->Add();
 Param->Name="lres";
 Param=xlReportFiders->Params->Add();
 Param->Name="lmmgg";
 Param=xlReportFiders->Params->Add();
 Param->Name="lobject";

 xlReportFiders->ParamByName["lres"]->Value = ResName;
 xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
 xlReportFiders->ParamByName["lobject"]->Value = name_eqp;

 ReportName = "Баланс ТП_"+name_eqp;
 xlReportFiders->MacroAfter = "FormatData";
 xlReportFiders->Report();
 xlReportFiders->MacroAfter = "";

 ZQPSBal->Close();
 ZQPSDemand->Close();
 ZQPSMeters->Close();

}
//------------------------------------------------------------------------------

void __fastcall TfBalansRep::NoBillToXL(TDateTime mmgg)
{
  AnsiString  sqlstr1=" select distinct err.id_client, err.id_tree, err.id_parent_eqp, err.id_grp,\
  t.name, cl.id , cl.code, cl.short_name, cl.name as abon_name, eq.name_eqp as fider_name, \
  CASE WHEN cl.book = -1 THEN NULL ELSE cl.book END AS book \
  from bal_client_errors_tbl as err \
  join eqm_tree_tbl as t on (t.id=err.id_tree) \
  join clm_client_tbl as cl on (cl.id= err.id_client) \
  join clm_statecl_tbl as stcl on (stcl.id_client=cl.id ) \
  left join eqm_equipment_tbl as eq on (eq.id = err.id_grp) \
  where err.mmgg = :mmgg \
  and cl.book = -1 and coalesce(stcl.id_section,0) not in (0,205,206,207,208) and cl.idk_work not in (0,99) and coalesce(cl.id_state,0) not in (50,99) \
  order by cl.code,err.id_tree, err.id_grp ";


  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQXLReps->MasterSource=NULL;
  ZQXLReps->LinkFields="";
 
  try
  {
    ZQXLReps->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  xlReportFiders->XLSTemplate = "XL\\fider_nobill.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Range = "Range";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  ReportName = "Не вошедшие в расчет";
  xlReportFiders->Report();

 ZQXLReps->Close();

}
//------------------------------------------------------------------------------
void TfBalansRep::ReconnectDemandXL(TDateTime mmgg )
{

  AnsiString  sqlstr=" select dat_b, dat_e from bal_grp_tree_tmp where mmgg = :mmgg limit 1; ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->Open();

   dat_b = ZQXLReps->FieldByName("dat_b")->AsDateTime;
   dat_e = ZQXLReps->FieldByName("dat_e")->AsDateTime;
  ZQXLReps->Close();

  AnsiString  sqlstr1=" select eq.name_eqp, eq.id as link, ss.name, \
  dat_b,dat_e,demand_all,losts_all,dat_b, dat_e,dt_from, dt_to,id_switching, \
  case when eq.id = ss.id_p_eqp then demand else -demand end  as delta_demand, \
  case when eq.id = ss.id_p_eqp then losts else -losts end  as delta_losts, \
  cal_minutes_fun(dat_b::::timestamp,dat_e::::timestamp) as minutes_switch, \
  cal_minutes_fun(dt_from::::timestamp,dt_to::::timestamp) as minutes_all \
  from ( \
  select tc.code_eqp, tc.name,tc.id_p_eqp,tc.dat_b,tc.dat_e,tc.demand,tc.losts, tc.id_switching, \
  t.id_p_eqp as norm_p_eqp,t.dat_b as dt_from,t.dat_e as dt_to, t.demand as demand_all, t.losts as losts_all \
  from bal_grp_tree_conn_tmp as tc \
  join bal_grp_tree_tmp as t on (tc.code_eqp = t.code_eqp) \
  where tc.is_recon = 1 and tc.type_eqp = 8 \
  and tc.mmgg = :mmgg and t.mmgg = :mmgg  ) as ss \
  join eqm_equipment_tbl as eq on (eq.id = ss.id_p_eqp or eq.id = ss.norm_p_eqp) \
  join bal_switching_tbl as sw on (sw.id = id_switching) \
  order by dat_b; ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  AnsiString  sqlstr2=" select eq.name_eqp, eq.id as link, \
  sum(case when eq.id = ss.id_p_eqp then demand else -demand end ) as delta_demand, \
  sum(case when eq.id = ss.id_p_eqp then losts else -losts end ) as delta_losts \
 from ( \
  select tc.code_eqp, tc.name,tc.id_p_eqp,tc.dat_b,tc.dat_e,tc.demand,tc.losts, tc.id_switching, \
  t.id_p_eqp as norm_p_eqp,t.dat_b as dt_from,t.dat_e as dt_to, t.demand as demand_all, t.losts as losts_all \
  from bal_grp_tree_conn_tmp as tc \
  join bal_grp_tree_tmp as t on (tc.code_eqp = t.code_eqp) \
  where tc.is_recon = 1 and tc.type_eqp = 8 \
  and tc.mmgg = :mmgg and t.mmgg = :mmgg ) as ss \
 join eqm_equipment_tbl as eq on (eq.id = ss.id_p_eqp or eq.id = ss.norm_p_eqp) \
  group by eq.name_eqp, eq.id ; ";


  ZQXLRepsSum->Sql->Clear();
  ZQXLRepsSum->Sql->Add(sqlstr2);
  ZQXLRepsSum->ParamByName("mmgg")->AsDateTime=mmgg;


  ZQXLReps->MasterSource=DSRep;
  ZQXLReps->LinkFields="link = link";

  try
  {
  ZQXLReps->Open();
  ZQXLRepsSum->Open();

  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }


  xlReportFiders->XLSTemplate = "XL\\recon_demand.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLRepsSum;
  Dsr->Alias =  "ZQXLRepsSum";
  Dsr->Range = "GroupRange";

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Alias = "ZQXLReps";
  Dsr->Range = "Range";
  Dsr->MasterSourceName="ZQXLRepsSum";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";

  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;

  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg)+" ("+
   FormatDateTime("dd.mm.yyyy",dat_b)+" - "+ FormatDateTime("dd.mm.yyyy",dat_e)+")";

  ReportName = "Переключения";
  xlReportFiders->Report();

 ZQXLReps->Close();
 ZQXLRepsSum->Close();

 ZQXLReps->MasterSource=NULL;
 ZQXLReps->LinkFields="";
}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::QRGroup2_s10BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 PrintBand=!(ZQTreeLosts->FieldByName(((TQRGroup*)Sender)->Expression)->IsNull);

 if ((ZQTreeLosts->FieldByName("s10_dat_b")->AsDateTime ==dat_b)&&
     (ZQTreeLosts->FieldByName("s10_dat_e")->AsDateTime ==dat_e))
 {
   QRExpr_datb->Enabled =false;
   QRExpr_date->Enabled =false;
 }
 else
 {
   QRExpr_datb->Enabled =true;
   QRExpr_date->Enabled =true;
 }

}
//---------------------------------------------------------------------------
void TfBalansRep::ShowDemandXL(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage, int showpoints)
{

  AnsiString  sqlstr=" select dat_b, dat_e from bal_grp_tree_tmp where mmgg = :mmgg limit 1; ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->Open();

   dat_b = ZQXLReps->FieldByName("dat_b")->AsDateTime;
   dat_e = ZQXLReps->FieldByName("dat_e")->AsDateTime;
  ZQXLReps->Close();

  AnsiString represent_name ;
  if (type_eqp ==15)
  {
   sqlstr=" select cp.represent_name from eqm_fider_tbl as ff  \
    left join clm_position_tbl as cp on (cp.id = ff.id_position) \
    where ff.code_eqp = :eqp ; ";

   ZQXLReps->Sql->Clear();
   ZQXLReps->Sql->Add(sqlstr);
   ZQXLReps->ParamByName("eqp")->AsInteger=id_eqp;
   ZQXLReps->Open();
   represent_name = ZQXLReps->FieldByName("represent_name")->AsString;
   ZQXLReps->Close();
  }

  AnsiString  sqlstr1;

  if (showpoints==0)
  {
  sqlstr1=" select ' ' as code_eqp, p.id_p_eqp,' ' as point_name, clm.short_name as abon_name,clm.code,sum(p.demand)::::numeric as demand_0, \
  int8(sum(p1.demand)::::numeric*cal_minutes_fun(p.dat_b, p.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_1, \
  int8(sum(p2.demand)::::numeric*cal_minutes_fun(p.dat_b, p.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_2, \
  int8(sum(p12.demand)::::numeric*cal_minutes_fun(p.dat_b, p.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_12, \
  p.dat_b, p.dat_e,  sum(mp.power)::::numeric as power, \
  (text(p.id_p_eqp)||text(extract ('epoch' from p.dat_b)::::int))::::varchar as key \
  from bal_grp_tree_conn_tmp as p \
  join clm_client_tbl as clm on (p.id_client = clm.id) \
  left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::date-'1 month'::::interval and type_eqp=12 and id_bal = :res order by id_point) as p1 on (p1.id_point=p.id_point ) \
  left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::date-'2 month'::::interval and type_eqp=12 and id_bal = :res order by id_point) as p2 on (p2.id_point=p.id_point ) \
  left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::date-'12 month'::::interval and type_eqp=12 and id_bal = :res order by id_point) as p12 on (p12.id_point=p.id_point ) \
  left join eqm_point_tbl as mp on (mp.code_eqp = p.id_point) \
  where p.type_eqp=12 and p.mmgg = :mmgg::::date and clm.book = -1 \
  group by p.id_p_eqp,p.dat_b,p.dat_e,clm.short_name,clm.code \
union \
 select ' ', f0.id_p_eqp, ' ', cc.abon_name,f0.code,demand_0, \
 int8(demand_1::::numeric*cal_minutes_fun(f0.dat_b, f0.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_1, \
 int8(demand_2::::numeric*cal_minutes_fun(f0.dat_b, f0.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_2, \
 int8(demand_12::::numeric*cal_minutes_fun(f0.dat_b, f0.dat_e)/cal_minutes_fun(  :dt_b, :dt_e))  as demand_12, \
 f0.dat_b, f0.dat_e, cc.power, \
 (text(f0.id_p_eqp)||text(extract ('epoch' from f0.dat_b)::::int))::::varchar as key \
   from \
 (select 0 as code,sum(p.demand)::::int as demand_0,p.id_p_eqp, p.dat_b, p.dat_e \
  from bal_grp_tree_conn_tmp as p \
  where p.type_eqp=12 and p.mmgg = :mmgg::::date and p.code_eqp < 0 \
  group by p.id_p_eqp, p.dat_b,p.dat_e order by id_p_eqp \
 ) as f0 \
 left join \
 (select sum(p.demand)::::int as demand_1,p.id_p_eqp \
 from bal_grp_tree_tbl as p \
 where p.type_eqp=12 and p.mmgg+'1 month'::::interval = :mmgg::::date and p.code_eqp < 0 and id_bal = :res  \
 group by p.id_p_eqp order by id_p_eqp \
) as f1 using (id_p_eqp) \
 left join \
(select sum(p.demand)::::int as demand_2,p.id_p_eqp \
 from bal_grp_tree_tbl as p \
 where p.type_eqp=12 and p.mmgg+'2 month'::::interval = :mmgg::::date and p.code_eqp < 0 and id_bal = :res \
 group by p.id_p_eqp order by id_p_eqp \
) as f2 using (id_p_eqp) \
left join \
(select sum(p.demand)::::int as demand_12,p.id_p_eqp \
 from bal_grp_tree_tbl as p \
 where p.type_eqp=12 and p.mmgg+'12 month'::::interval = :mmgg::::date and p.code_eqp < 0 and id_bal = :res \
 group by p.id_p_eqp order by id_p_eqp \
)  as f12 using (id_p_eqp) \
left join \
(select 'Бытовые потребители ('||text(coalesce(sum(cc.fiz_count),0))||')'::::varchar as abon_name,p.id_p_eqp, coalesce(sum(cc.fiz_power),0) as power \
 from bal_grp_tree_tmp as p \
 left join bal_acc_tmp as cc on (p.code_eqp = cc.code_eqp and p.mmgg = cc.mmgg) \
 where p.type_eqp=12 and p.mmgg = :mmgg::::date and p.code_eqp < 0 \
 group by p.id_p_eqp order by id_p_eqp \
) as cc using (id_p_eqp)  ; ";
 }

if (showpoints==1)
   {
sqlstr1=" select p.code_eqp ,p.id_p_eqp, p.name as point_name, clm.short_name as abon_name,clm.code,sum(p.demand)::::numeric as demand_0, \
  int8(sum(p1.demand)::::numeric*cal_minutes_fun(p.dat_b, p.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_1, \
  int8(sum(p2.demand)::::numeric*cal_minutes_fun(p.dat_b, p.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_2, \
  int8(sum(p12.demand)::::numeric*cal_minutes_fun(p.dat_b, p.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_12, \
  p.dat_b, p.dat_e,  sum(mp.power)::::numeric as power, mm.num_eqp ,\
  (text(p.id_p_eqp)||text(extract ('epoch' from p.dat_b)::::int))::::varchar as key \
  from bal_grp_tree_conn_tmp as p \
  join clm_client_tbl as clm on (p.id_client = clm.id) \
  left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::date-'1 month'::::interval and type_eqp=12 and id_bal = :res order by id_point) as p1 on (p1.id_point=p.id_point ) \
  left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::date-'2 month'::::interval and type_eqp=12 and id_bal = :res order by id_point) as p2 on (p2.id_point=p.id_point ) \
  left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::date-'12 month'::::interval and type_eqp=12 and id_bal = :res order by id_point) as p12 on (p12.id_point=p.id_point ) \
  left join eqm_point_tbl as mp on (mp.code_eqp = p.id_point) \
  left join ( select mmp.id_point, eqm.num_eqp from eqm_meter_point_h as mmp  \
              join eqm_equipment_tbl as eqm on (eqm.id = mmp.id_meter) \
              join eqd_meter_energy_tbl as mee on (mee.code_eqp = eqm.id) \
              where mmp.dt_e is null and mee.kind_energy = 1 order by mmp.id_point ) as mm \
  on (mm.id_point = p.id_point ) \
  where p.type_eqp=12 and p.mmgg = :mmgg::::date and clm.book = -1 \
  group by p.code_eqp,p.id_p_eqp, p.name, p.dat_b,p.dat_e,clm.short_name,clm.code,mm.num_eqp \
union \
 select f0.id_p_eqp, f0.id_p_eqp, ' ',cc.abon_name,f0.code,demand_0, \
 int8(demand_1::::numeric*cal_minutes_fun(f0.dat_b, f0.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_1, \
 int8(demand_2::::numeric*cal_minutes_fun(f0.dat_b, f0.dat_e)/cal_minutes_fun(  :dt_b, :dt_e ))  as demand_2, \
 int8(demand_12::::numeric*cal_minutes_fun(f0.dat_b, f0.dat_e)/cal_minutes_fun(  :dt_b, :dt_e))  as demand_12, \
 f0.dat_b, f0.dat_e, cc.power, '',  \
 (text(f0.id_p_eqp)||text(extract ('epoch' from f0.dat_b)::::int))::::varchar as key \
   from \
 (select 0 as code,sum(p.demand)::::int as demand_0,p.id_p_eqp, p.dat_b, p.dat_e \
  from bal_grp_tree_conn_tmp as p \
  where p.type_eqp=12 and p.mmgg = :mmgg::::date and p.code_eqp < 0 \
  group by p.id_p_eqp, p.dat_b,p.dat_e order by id_p_eqp \
 ) as f0 \
 left join \
 (select sum(p.demand)::::int as demand_1,p.id_p_eqp \
 from bal_grp_tree_tbl as p \
 where p.type_eqp=12 and p.mmgg+'1 month'::::interval = :mmgg::::date and p.code_eqp < 0 and id_bal = :res \
 group by p.id_p_eqp order by id_p_eqp \
) as f1 using (id_p_eqp) \
 left join \
(select sum(p.demand)::::int as demand_2,p.id_p_eqp \
 from bal_grp_tree_tbl as p \
 where p.type_eqp=12 and p.mmgg+'2 month'::::interval = :mmgg::::date and p.code_eqp < 0 and id_bal = :res \
 group by p.id_p_eqp order by id_p_eqp \
) as f2 using (id_p_eqp) \
left join \
(select sum(p.demand)::::int as demand_12,p.id_p_eqp \
 from bal_grp_tree_tbl as p \
 where p.type_eqp=12 and p.mmgg+'12 month'::::interval = :mmgg::::date and p.code_eqp < 0 and id_bal = :res \
 group by p.id_p_eqp order by id_p_eqp \
)  as f12 using (id_p_eqp) \
left join \
(select 'Бытовые потребители ('||text(coalesce(sum(cc.fiz_count),0))||')'::::varchar as abon_name,p.id_p_eqp, coalesce(sum(cc.fiz_power),0) as power \
 from bal_grp_tree_tmp as p \
 left join bal_acc_tmp as cc on (p.code_eqp = cc.code_eqp and p.mmgg = cc.mmgg) \
 where p.type_eqp=12 and p.mmgg = :mmgg::::date and p.code_eqp < 0 \
 group by p.id_p_eqp order by id_p_eqp \
) as cc using (id_p_eqp)  ; ";
   }

  ZQDemandNew->Sql->Clear();
  ZQDemandNew->Sql->Add(sqlstr1);
  ZQDemandNew->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQDemandNew->ParamByName("dt_b")->AsDateTime=dat_b;
  ZQDemandNew->ParamByName("dt_e")->AsDateTime=dat_e;
  ZQDemandNew->ParamByName("res")->AsInteger=ResId;


  AnsiString  sqlstr2=" select sss.*, norm_location, \
   CASE WHEN code_f04  is not null THEN dem_f04.ktr_demand \
        WHEN code_ps10 is not null THEN dem_s10.ktr_demand \
        WHEN code_f10  is not null THEN dem_f10.ktr_demand \
        WHEN code_vvod  is not null THEN dem_e35.ktr_demand \
        WHEN code_ps35  is not null THEN dem_s35.ktr_demand END as ktr_demand \
   from ( select \
case when volt1 in (1,2) and type1 = 8 then gr_1 \
     when volt2 in (1,2) and type2 = 8 then gr_2 \
     when volt3 in (1,2) and type3 = 8 then gr_3 \
     when volt4 in (1,2) and type4 = 8 then gr_4 \
     when volt5 in (1,2) and type5 = 8 then gr_5  END as code_ps35, \
case when volt1 in (1,2) and type1 = 8 then name1 \
     when volt2 in (1,2) and type2 = 8 then name2 \
     when volt3 in (1,2) and type3 = 8 then name3 \
     when volt4 in (1,2) and type4 = 8 then name4 \
     when volt5 in (1,2) and type5 = 8 then name5  END as name_ps35, \
case when type1 = 3 then gr_1 \
     when type2 = 3 then gr_2 \
     when type3 = 3 then gr_3 \
     when type4 = 3 then gr_4 \
     when type5 = 3 then gr_5 END as code_vvod, \
case when type1 = 3 then name1 \
     when type2 = 3 then name2 \
     when type3 = 3 then name3 \
     when type4 = 3 then name4 \
     when type5 = 3 then name5 END as name_vvod, \
case when volt1 in (3,31,32) and type1 = 15 then gr_1 \
     when volt2 in (3,31,32) and type2 = 15 then gr_2 \
     when volt3 in (3,31,32) and type3 = 15 then gr_3 \
     when volt4 in (3,31,32) and type4 = 15 then gr_4 \
     when volt5 in (3,31,32) and type5 = 15 then gr_5 END as code_f10, \
case when volt1 in (3,31,32) and type1 = 15 then name1 \
     when volt2 in (3,31,32) and type2 = 15 then name2 \
     when volt3 in (3,31,32) and type3 = 15 then name3 \
     when volt4 in (3,31,32) and type4 = 15 then name4 \
     when volt5 in (3,31,32) and type5 = 15 then name5 END as name_f10, \
case when volt1 in (3,31,32) and type1 = 8 then gr_1 \
     when volt2 in (3,31,32) and type2 = 8 then gr_2 \
     when volt3 in (3,31,32) and type3 = 8 then gr_3 \
     when volt4 in (3,31,32) and type4 = 8 then gr_4 \
     when volt5 in (3,31,32) and type5 = 8 then gr_5 END as code_ps10, \
case when volt1 in (3,31,32) and type1 = 8 then name1 \
     when volt2 in (3,31,32) and type2 = 8 then name2 \
     when volt3 in (3,31,32) and type3 = 8 then name3 \
     when volt4 in (3,31,32) and type4 = 8 then name4 \
     when volt5 in (3,31,32) and type5 = 8 then name5 END as name_ps10 , \
case when volt1 in (4,42) and type1 = 15 then gr_1 \
     when volt2 in (4,42) and type2 = 15 then gr_2 \
     when volt3 in (4,42) and type3 = 15 then gr_3 \
     when volt4 in (4,42) and type4 = 15 then gr_4 \
     when volt5 in (4,42) and type5 = 15 then gr_5 END as code_f04, \
case when volt1 in (4,42) and type1 = 15 then name1 \
     when volt2 in (4,42) and type2 = 15 then name2 \
     when volt3 in (4,42) and type3 = 15 then name3 \
     when volt4 in (4,42) and type4 = 15 then name4 \
     when volt5 in (4,42) and type5 = 15 then name5 END as name_f04, \
   dat_b, dat_e, demand, code_eqp, (text(code_eqp)||text(extract ('epoch' from dat_b)::::int))::::varchar as key \
from \
( \
 select \
  s1.code_eqp as gr_1,s1.type_eqp as type1,s1.id_voltage as volt1,s1.name as name1,s1.demand as dem1,s1.dat_b as dat_b1,s1.dat_e as dat_e1, \
  s2.code_eqp as gr_2,s2.type_eqp as type2,s2.id_voltage as volt2,s2.name as name2,s2.demand as dem2,s2.dat_b as dat_b2,s2.dat_e as dat_e2, \
  s3.code_eqp as gr_3,s3.type_eqp as type3,s3.id_voltage as volt3,s3.name as name3,s3.demand as dem3,s3.dat_b as dat_b3,s3.dat_e as dat_e3, \
  s4.code_eqp as gr_4,s4.type_eqp as type4,s4.id_voltage as volt4,s4.name as name4,s4.demand as dem4,s4.dat_b as dat_b4,s4.dat_e as dat_e4, \
  s5.code_eqp as gr_5,s5.type_eqp as type5,s5.id_voltage as volt5,s5.name as name5,s5.demand as dem5,s5.dat_b as dat_b5,s5.dat_e as dat_e5, \
  coalesce(s5.dat_b,s4.dat_b,s3.dat_b,s2.dat_b,s1.dat_b) as dat_b, \
  coalesce(s5.dat_e,s4.dat_e,s3.dat_e,s2.dat_e,s1.dat_e) as dat_e, \
  coalesce(s5.demand,s4.demand,s3.demand,s2.demand,s1.demand) as demand, \
  coalesce(s5.code_eqp,s4.code_eqp,s3.code_eqp,s2.code_eqp,s1.code_eqp) as code_eqp \
  from bal_grp_tree_conn_tmp as s1 \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s2 on (s2.id_p_eqp=s1.code_eqp or s2.code_eqp is null) \
  and ( tintervalov(tinterval(s1.dat_b::::abstime,s1.dat_e::::abstime),tinterval(s2.dat_b::::abstime,s2.dat_e::::abstime)) or s2.dat_b is null) \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s3 on (s3.id_p_eqp=s2.code_eqp or s3.code_eqp is null) \
  and ( tintervalov(tinterval(s2.dat_b::::abstime,s2.dat_e::::abstime),tinterval(s3.dat_b::::abstime,s3.dat_e::::abstime)) or s3.dat_b is null) \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s4 on (s4.id_p_eqp=s3.code_eqp or s4.code_eqp is null) \
  and ( tintervalov(tinterval(s3.dat_b::::abstime,s3.dat_e::::abstime),tinterval(s4.dat_b::::abstime,s4.dat_e::::abstime)) or s4.dat_b is null) \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s5 on (s5.id_p_eqp=s4.code_eqp or s5.code_eqp is null) \
  and ( tintervalov(tinterval(s4.dat_b::::abstime,s4.dat_e::::abstime),tinterval(s5.dat_b::::abstime,s5.dat_e::::abstime)) or s5.dat_b is null) \
  where \
  (s1.code_eqp=:code_eqp  or s2.code_eqp=:code_eqp or s3.code_eqp=:code_eqp or s4.code_eqp=:code_eqp or s5.code_eqp=:code_eqp) and \
   s1.id_p_eqp is null and  s1.mmgg = :mmgg \
  order by gr_1 desc,gr_2 desc,gr_3 desc,gr_4 desc,gr_5 desc \
 ) as ss \
 ) as sss \
 left join \
 (select g0.code_eqp, sum(ktr_demand) as ktr_demand from \
  bal_grp_tree_tmp as g0 \
  join bal_grp_tree_tmp as g on (g.id_p_eqp = g0.code_eqp) \
  join bal_demand_tmp as d \
  on (d.id_point = g.id_point and d.mmgg = g.mmgg) \
  where g.mmgg = :mmgg and g0.mmgg = :mmgg and g.type_eqp = 3 and g0.type_eqp = 8 \
  group by g0.code_eqp \
 ) as dem_s35 on (dem_s35.code_eqp = sss.code_ps35) \
 left join \
 (select code_eqp, ktr_demand from \
  bal_grp_tree_tmp as g join bal_demand_tmp as d \
  on (d.id_point = g.id_point and d.mmgg = g.mmgg) \
  where g.mmgg = :mmgg and g.type_eqp = 3 \
 ) as dem_e35 on (dem_e35.code_eqp = sss.code_vvod) \
 left join \
 (select code_eqp, ktr_demand from \
  bal_grp_tree_tmp as g join bal_demand_tmp as d \
  on (d.id_point = g.id_point and d.mmgg = g.mmgg) \
  where g.mmgg = :mmgg and g.type_eqp = 15 \
 ) as dem_f10 on (dem_f10.code_eqp = sss.code_f10) \
 left join \
 (select code_eqp, ktr_demand from \
  bal_grp_tree_tmp as g join bal_demand_tmp as d \
  on (d.id_point = g.id_point and d.mmgg = g.mmgg) \
  where g.mmgg = :mmgg and g.type_eqp = 15 \
 ) as dem_f04 on (dem_f04.code_eqp = sss.code_f04) \
 left join \
 (select b.code_eqp , sum(bdf.ktr_demand) as ktr_demand \
  from  bal_demand_tmp as bdf \
  join eqm_compens_station_inst_tbl as csi on (csi.code_eqp = bdf.id_point) \
  join bal_grp_tree_tmp as b on (b.code_eqp = csi.code_eqp_inst) \
  where bdf.mmgg = :mmgg and b.type_eqp = 8 and b.mmgg = :mmgg \
  group by  b.code_eqp \
 ) as dem_s10 on (dem_s10.code_eqp = sss.code_ps10) \
 left join \
 (select gps.code_eqp, gf.code_eqp as norm_fider, coalesce(gf.name,'')||','||coalesce(ge.name,'')||' '||coalesce(gs.name,'') as norm_location from \
  bal_grp_tree_tmp as gps \
  join bal_grp_tree_tmp as gf on (gps.id_p_eqp = gf.code_eqp and gf.mmgg = :mmgg) \
  left join bal_grp_tree_tmp as ge on (gf.id_p_eqp = ge.code_eqp and ge.mmgg = :mmgg) \
  left join bal_grp_tree_tmp as gs on (ge.id_p_eqp = gs.code_eqp and gs.mmgg = :mmgg) \
  where gps.mmgg = :mmgg and gps.type_eqp = 8 \
 ) as norm_sel on  (norm_sel.code_eqp = sss.code_ps10) \
  order by coalesce(name_ps35,' '), coalesce(name_vvod,' '), coalesce(name_f10,' '), coalesce(name_ps10,' '), dat_b, dat_e ; ";


  ZQDemandNewSum->Sql->Clear();
  ZQDemandNewSum->Sql->Add(sqlstr2);
  ZQDemandNewSum->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQDemandNewSum->ParamByName("code_eqp")->AsInteger=id_eqp;

   /*
  ZQXLReps->MasterSource=DSRep;
  ZQXLReps->LinkFields="link = link";
*/
  try
  {
  ZQDemandNew->Open();
  ZQDemandNewSum->Open();

  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }


  xlReportFiders->XLSTemplate = "XL\\balans_demand.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQDemandNewSum;
  Dsr->Alias =  "ZQXLRepsSum";
  Dsr->Range = "GroupRange";

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQDemandNew;
  Dsr->Alias = "ZQXLReps";
  Dsr->Range = "Range";
  Dsr->MasterSourceName="ZQXLRepsSum";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";
  Param=xlReportFiders->Params->Add();
  Param->Name="lobject";
  Param=xlReportFiders->Params->Add();
  Param->Name="linspector";


  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lobject"]->Value = name_eqp;

  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg)+" ("+
   FormatDateTime("dd.mm.yyyy",dat_b)+" - "+ FormatDateTime("dd.mm.yyyy",dat_e)+")";

  xlReportFiders->ParamByName["linspector"]->Value = represent_name;

  ReportName = "Полезный отпуск_"+name_eqp;
  xlReportFiders->Report();

 ZQDemandNew->Close();
 ZQDemandNewSum->Close();
      /*
 ZQXLReps->MasterSource=NULL;
 ZQXLReps->LinkFields="";
 */
}
//---------------------------------------------------------------------------

void __fastcall TfBalansRep::xlReportFidersBeforeWorkbookSave(
      TxlReport *Report, AnsiString &WorkbookName,
      AnsiString &WorkbookPath, bool Save)
{
//
  AnsiString OldName =WorkbookName;
  AnsiString NewName;

  NewName=OldName.SubString(OldName.AnsiPos("   "),OldName.AnsiPos("  xlrtmp ")-OldName.AnsiPos("   "));
  NewName=NewName.Trim();

  TReplaceFlags flags ;
  flags <<rfReplaceAll;
  ReportName = StringReplace(ReportName,"\\","",flags);
  ReportName = StringReplace(ReportName,"/","",flags);
  ReportName = StringReplace(ReportName,";","",flags);
  ReportName = StringReplace(ReportName,"=","",flags);
  ReportName = StringReplace(ReportName,"+","",flags);
  ReportName = StringReplace(ReportName,"<","",flags);
  ReportName = StringReplace(ReportName,">","",flags);
  ReportName = StringReplace(ReportName,"|","",flags);
  ReportName = StringReplace(ReportName,"\"","",flags);
  ReportName = StringReplace(ReportName,"'","",flags);
  ReportName = StringReplace(ReportName,"[","",flags);
  ReportName = StringReplace(ReportName,"]","",flags);
  ReportName = StringReplace(ReportName,":","",flags);
  ReportName = StringReplace(ReportName,"*","",flags);
  ReportName = StringReplace(ReportName,"?","",flags);                      

  ReportName = Trim(ReportName);
  WorkbookName = ReportName+"_"+NewName;

  //WorkbookPath = WorkbookPath+"tmp\\";
  WorkbookPath = ExtractFilePath(Application->ExeName)+"tmp\\";

  Save=false;
//  ShowMessage("WorkbookName : "+WorkbookName +" WorkbookPath: "+WorkbookPath);

}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::BalansMidPoint_XL(int id_eqp,TDateTime mmgg,AnsiString name_eqp)
{
//  ZQFiderBalXL->Close();

  AnsiString  sqlstr1="select bal_midpoint_start_fun (:mmgg);";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  try
  {
    ZQXLReps->ExecSql();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  if (id_eqp!=0)
    ZQMidPointBal->ParamByName("grp")->AsInteger = id_eqp;
  else
    ZQMidPointBal->ParamByName("grp")->Clear();

  ZQMidPointBal->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQMidPointDemand->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQMidPointMeters->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQMidPointDemand->MasterSource=dsMidPointBal;
  ZQMidPointDemand->LinkFields="link = link";

  ZQMidPointMeters->MasterSource=dsMidPointBal;
  ZQMidPointMeters->LinkFields="link = link";

  try
  {
   ZQMidPointBal->Open();
   ZQMidPointDemand->Open();
   ZQMidPointMeters->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

 xlReportFiders->XLSTemplate = "XL\\balans_midpoint.xls";
 TxlDataSource *Dsr;
 TxlReportParam *Param;
 xlReportFiders->DataSources->Clear();

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQMidPointBal;
 Dsr->Alias = "ZQXLReps";
 Dsr->Range = "Range";

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQMidPointBal;
 Dsr->Alias = "ZQXLReps2";
 Dsr->Range = "Range2";

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQMidPointMeters;
 Dsr->Alias = "ZQXLRepsM";
 Dsr->Range = "RangeMeter";
 Dsr->MasterSourceName="ZQXLReps";


 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQMidPointDemand;
 Dsr->Alias = "ZQXLRepsAbon";
 Dsr->Range = "RangeAbon";
 Dsr->MasterSourceName="ZQXLReps";


 xlReportFiders->Params->Clear();
 Param=xlReportFiders->Params->Add();
 Param->Name="lres";
 Param=xlReportFiders->Params->Add();
 Param->Name="lmmgg";
 Param=xlReportFiders->Params->Add();
 Param->Name="lobject";

 xlReportFiders->ParamByName["lres"]->Value = ResName;
 xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
 xlReportFiders->ParamByName["lobject"]->Value = name_eqp;

 ReportName = "Баланс ТУ_"+name_eqp;
 xlReportFiders->MacroAfter = "FormatData";
 xlReportFiders->Report();
 xlReportFiders->MacroAfter = "";

 ZQMidPointBal->Close();
 ZQMidPointDemand->Close();
 ZQMidPointMeters->Close();

}
//------------------------------------------------------------------------------

void __fastcall TfBalansRep::FizAbonInfo(TDateTime mmgg)
{
  AnsiString  sqlstr1=" select * from \
  (select count(*) as cnt_all from clm_pclient_tbl where coalesce(id_state,0)<>50) as s1, \
  (select count(*) as cnt_connect from clm_pclient_tbl where id_eqpborder is not null and coalesce(id_state,0)<>50) as s2, \
  (select count(*) as cnt_load from acm_privdem_tbl where  mmgg = :mmgg) as s3, \
  (select sum(value) as dem_load from acm_privdem_tbl where  mmgg = :mmgg) as s4, \
  (select sum(acc.demand) as dem_fider from bal_grp_tree_tmp as g join bal_acc_tmp as acc on (g.code_eqp = acc.code_eqp) \
   where g.mmgg = :mmgg and acc.mmgg = :mmgg and  g.id_client = -1 ) as s5, \
  (select sum(fiz_count) as cnt_fider from bal_grp_tree_tmp as g join bal_acc_tmp as acc on (g.code_eqp = acc.code_eqp) \
   where g.mmgg = :mmgg and acc.mmgg = :mmgg and  g.id_client = -1 ) as s6, \
  (select count(*) as cnt_load_connect from acm_privdem_tbl where mmgg = :mmgg and id_eqpborder is not null ) as s7, \
  (select sum(value) as dem_load_connect from acm_privdem_tbl where  mmgg = :mmgg and id_eqpborder is not null ) as s8 ;  ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQXLReps->MasterSource=NULL;
  ZQXLReps->LinkFields="";

  try
  {
    ZQXLReps->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  xlReportFiders->XLSTemplate = "XL\\fizabon_summary.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
 // Dsr->Range = "Range";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  ReportName = "Физлица_свод_"+FormatDateTime("mmmm yyyy",mmgg);

  xlReportFiders->MacroAfter = "";
  xlReportFiders->Report();

 ZQXLReps->Close();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::StationReconnectInfo(int id_eqp,TDateTime mmgg)
{
  AnsiString  sqlstr1=" select ps.id,ps.name,ps.id_p_eqp,ps.id_switching,ps.is_recon,ps.demand,ps.dat_b ,ps.dat_e , f.name as fider, \
  cal_minutes_fun(ps.dat_b::::timestamp, ps.dat_e::::timestamp) as minutes, \
  CASE WHEN ps.is_recon = 1 then 'переключена' ELSE '' end as status \
  from bal_grp_tree_conn_tmp as ps \
  join bal_grp_tree_tmp as f on (f.code_eqp = ps.id_p_eqp and f.mmgg=:mmgg ) \
  where ps.type_eqp =8 and ps.mmgg=:mmgg and ps.id_p_eqp is not null \
  order by ps.name,ps.dat_b ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  AnsiString  sqlstr2=" select ps.id,ps.name,ps.demand,ps.dat_b ,ps.dat_e , f.name as fider, f0.name as fider0, \
  ps0.demand as demand0, ps.losts, ps0.losts as losts0, \
  cal_minutes_fun(ps.dat_b::::timestamp, ps.dat_e::::timestamp) as minutes \
  from bal_grp_tree_conn_tmp as ps \
  join bal_grp_tree_tmp as f on (f.code_eqp = ps.id_p_eqp and f.mmgg=:mmgg ) \
  join bal_grp_tree_tmp  as ps0 on (ps.code_eqp = ps0.code_eqp and ps0.mmgg=:mmgg ) \
  join bal_grp_tree_tmp as f0 on (f0.code_eqp = ps0.id_p_eqp and f0.mmgg=:mmgg ) \
  where ps.type_eqp =8 and ps.mmgg=:mmgg and ps.id_p_eqp is not null and ps.is_recon = 1 \
  order by ps.name,ps.dat_b ";

  ZQXLReps2->Sql->Clear();
  ZQXLReps2->Sql->Add(sqlstr2);
  ZQXLReps2->ParamByName("mmgg")->AsDateTime=mmgg;


  ZQXLReps->MasterSource=NULL;
  ZQXLReps->LinkFields="";

  try
  {
    ZQXLReps->Open();
    ZQXLReps2->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  xlReportFiders->XLSTemplate = "XL\\ps_reconnected.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Range = "Range";
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps2;
  Dsr->Range = "Range2";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  ReportName = "Подстанции_"+FormatDateTime("mmmm yyyy",mmgg);

  xlReportFiders->MacroAfter = "";
  xlReportFiders->Report();

 ZQXLReps->Close();
 ZQXLReps2->Close();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::FidersToXLYear(int selected,TDateTime mmgg)
{
// Определим, есть ли вводы на ПС

  ZQFiderBalXL->Close();

  AnsiString sqlstr;

  if (selected==0)
  {

   sqlstr= "  select s1.*, s2.*,s3.*,s4.*,s5.*,s6.*,s7.*,s8.*,s9.*,s10.*,s11.*,s12.*, \
    coalesce(s1.f_name,s2.f_name,s3.f_name,s4.f_name,s5.f_name,s6.f_name,s7.f_name,s8.f_name,s9.f_name,s10.f_name,s11.f_name,s12.f_name) as name, \
    case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name  \
    from \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp,  \
    bd.ktr_demand as f_ktr_demand1,   gt.demand as f_demand1 , bd.ktr_demand-gt.demand - gt.losts as lost1 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 1 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 1  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 1  \
  and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s1 \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand2,   gt.demand as f_demand2 , bd.ktr_demand-gt.demand - gt.losts as lost2 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 2 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 2  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 2  \
  and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s2 on (s1.code_eqp = s2.code_eqp)\
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand3,   gt.demand as f_demand3 , bd.ktr_demand-gt.demand - gt.losts as lost3 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 3 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 3  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 3  \
  and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s3 on (s2.code_eqp = s3.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand4,   gt.demand as f_demand4 , bd.ktr_demand-gt.demand - gt.losts as lost4 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 4 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 4  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 4  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s4 on (s3.code_eqp = s4.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand5,   gt.demand as f_demand5 , bd.ktr_demand-gt.demand - gt.losts as lost5 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 5 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 5  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 5  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s5 on (s4.code_eqp = s5.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand6,   gt.demand as f_demand6 , bd.ktr_demand-gt.demand - gt.losts as lost6 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 6 \
     and id_bal = :res \
     group by code_eqp,id_point,name , mmgg order by id_point) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 6  \
   and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 6  \
     and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s6 on (s5.code_eqp = s6.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand7,   gt.demand as f_demand7 , bd.ktr_demand-gt.demand - gt.losts as lost7 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 7 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 7  \
   and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 7  \
     and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s7 on (s6.code_eqp = s7.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand8,   gt.demand as f_demand8 , bd.ktr_demand-gt.demand - gt.losts as lost8 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 8 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 8  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 8  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s8 on (s7.code_eqp = s8.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand9,   gt.demand as f_demand9 , bd.ktr_demand-gt.demand - gt.losts as lost9 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 9 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 9  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 9  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s9 on (s8.code_eqp = s9.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand10,   gt.demand as f_demand10 , bd.ktr_demand-gt.demand - gt.losts as lost10 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 10 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 10  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 10  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s10 on (s9.code_eqp = s10.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand11,   gt.demand as f_demand11 , bd.ktr_demand-gt.demand - gt.losts as lost11 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 11 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 11  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 11  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s11 on (s10.code_eqp = s11.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand12,   gt.demand as f_demand12 , bd.ktr_demand-gt.demand - gt.losts as lost12 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 12 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   union \
   select -1, '- С шин ПС 110/35/10'::::varchar,-1,sum(gt.demand),sum(gt.demand),0 \
   from bal_grp_tree_tbl as gt \
   left join bal_grp_tree_tbl as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   where \
  ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and date_part('year',gt2.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt2.mmgg::::date) = 12  \
  and gt.type_eqp=12 and date_part('year',gt.mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',gt.mmgg::::date) = 12  \
    and gt.id_bal = :res  and gt2.id_bal = :res \
   order by f_name   )as s12 on (s11.code_eqp = s12.code_eqp) \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = coalesce(s1.code_eqp,s2.code_eqp,s3.code_eqp,s4.code_eqp,s5.code_eqp,s6.code_eqp,s7.code_eqp,s8.code_eqp,s9.code_eqp,s10.code_eqp,s11.code_eqp,s12.code_eqp) and gr1.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :dat::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = coalesce(s1.code_eqp,s2.code_eqp,s3.code_eqp,s4.code_eqp,s5.code_eqp,s6.code_eqp,s7.code_eqp,s8.code_eqp,s9.code_eqp,s10.code_eqp,s11.code_eqp,s12.code_eqp)) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,name ;";

  }
  else
  {
   sqlstr= "  select s1.*, s2.*,s3.*,s4.*,s5.*,s6.*,s7.*,s8.*,s9.*,s10.*,s11.*,s12.*, \
    coalesce(s1.f_name,s2.f_name,s3.f_name,s4.f_name,s5.f_name,s6.f_name,s7.f_name,s8.f_name,s9.f_name,s10.f_name,s11.f_name,s12.f_name) as name, \
    case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name  \
    from \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp,  \
    bd.ktr_demand as f_ktr_demand1,   gt.demand as f_demand1 , bd.ktr_demand-gt.demand - gt.losts as lost1 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 1 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s1 \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand2,   gt.demand as f_demand2 , bd.ktr_demand-gt.demand - gt.losts as lost2 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 2 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s2 on (s1.code_eqp = s2.code_eqp)\
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand3,   gt.demand as f_demand3 , bd.ktr_demand-gt.demand - gt.losts as lost3 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 3 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s3 on (s2.code_eqp = s3.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand4,   gt.demand as f_demand4 , bd.ktr_demand-gt.demand - gt.losts as lost4 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 4 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s4 on (s3.code_eqp = s4.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand5,   gt.demand as f_demand5 , bd.ktr_demand-gt.demand - gt.losts as lost5 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 5 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s5 on (s4.code_eqp = s5.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand6,   gt.demand as f_demand6 , bd.ktr_demand-gt.demand - gt.losts as lost6 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 6 \
     and id_bal = :res \
     group by code_eqp,id_point,name , mmgg order by id_point) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s6 on (s5.code_eqp = s6.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand7,   gt.demand as f_demand7 , bd.ktr_demand-gt.demand - gt.losts as lost7 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 7 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s7 on (s6.code_eqp = s7.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand8,   gt.demand as f_demand8 , bd.ktr_demand-gt.demand - gt.losts as lost8 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 8 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s8 on (s7.code_eqp = s8.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand9,   gt.demand as f_demand9 , bd.ktr_demand-gt.demand - gt.losts as lost9 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 9 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s9 on (s8.code_eqp = s9.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand10,   gt.demand as f_demand10 , bd.ktr_demand-gt.demand - gt.losts as lost10 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 10 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s10 on (s9.code_eqp = s10.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand11,   gt.demand as f_demand11 , bd.ktr_demand-gt.demand - gt.losts as lost11 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 11 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s11 on (s10.code_eqp = s11.code_eqp) \
   full outer join \
    ( select bd.id_point, gt.name as f_name, gt.code_eqp , \
    bd.ktr_demand as f_ktr_demand12,   gt.demand as f_demand12 , bd.ktr_demand-gt.demand - gt.losts as lost12 \
   from \
   ( select mmgg, code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tbl where type_eqp=15 and date_part('year',mmgg::::date) = date_part('year',:dat::::date)  and date_part('month',mmgg::::date) = 12 \
     and id_bal = :res \
     group by code_eqp,id_point,name, mmgg order by id_point ) as gt \
    left join bal_demand_tbl as bd  on (bd.id_point=gt.id_point and bd.mmgg = gt.mmgg and bd.id_bal = :res) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   where  sf.selected = 1 \
   order by f_name   )as s12 on (s11.code_eqp = s12.code_eqp) \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = coalesce(s1.code_eqp,s2.code_eqp,s3.code_eqp,s4.code_eqp,s5.code_eqp,s6.code_eqp,s7.code_eqp,s8.code_eqp,s9.code_eqp,s10.code_eqp,s11.code_eqp,s12.code_eqp) and gr1.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :dat::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = coalesce(s1.code_eqp,s2.code_eqp,s3.code_eqp,s4.code_eqp,s5.code_eqp,s6.code_eqp,s7.code_eqp,s8.code_eqp,s9.code_eqp,s10.code_eqp,s11.code_eqp,s12.code_eqp)) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,name ;";
  }

  ZQFiderBalXL->Sql->Clear();
  ZQFiderBalXL->Sql->Add(sqlstr);

  ZQFiderBalXL->ParamByName("dat")->AsDateTime=mmgg;
  ZQFiderBalXL->ParamByName("res")->AsInteger=ResId;

  try
  {
   ZQFiderBalXL->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

 xlReportFiders->XLSTemplate = "XL\\fiders_year.xls";
 TxlDataSource *Dsr;
 TxlReportParam *Param;
 xlReportFiders->DataSources->Clear();

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQFiderBalXL;
 Dsr->Alias = "ZQXLReps";
 Dsr->Range = "Range";


 xlReportFiders->Params->Clear();
 Param=xlReportFiders->Params->Add();
 Param->Name="lres";
 Param=xlReportFiders->Params->Add();
 Param->Name="lmmgg";
//  Param=xlReport->Params->Add();
//  Param->Name="caption";

 xlReportFiders->ParamByName["lres"]->Value = ResName;
 xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
 ReportName = "Баланс_"+FormatDateTime("mmmm yyyy",mmgg) ;
 xlReportFiders->Report();

 ZQFiderBalXL->Close();

}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::ConnectedToRoot(TDateTime mmgg)
{
  AnsiString  sqlstr1="  select gt.*, \
  coalesce(gt3.name,'')||' '||coalesce(gt2.name,'') as parent, \
  CASE WHEN gt.id_client = -1 THEN 'Бытовые потребители' ELSE c.short_name END as abon_name , c.code , cp.represent_name \
   from bal_grp_tree_tmp as gt \
   left join clm_client_tbl as c on (c.id = gt.id_client) \
   left join bal_grp_tree_tmp as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
   left join bal_grp_tree_tmp as gt3 on (gt2.id_p_eqp = gt3.code_eqp and gt3.mmgg = :mmgg )  \
   left join eqm_point_tbl as p on (p.code_eqp = gt.id_point) \
   left join clm_position_tbl as cp on (cp.id = p.id_position) \
   where ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and gt2.mmgg = :mmgg \
   and gt.type_eqp=12 and gt.mmgg = :mmgg \
   order by c.code, gt.name  ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQXLReps->MasterSource=NULL;
  ZQXLReps->LinkFields="";

  try
  {
    ZQXLReps->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  xlReportFiders->XLSTemplate = "XL\\bal_toroot.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Range = "Range";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  ReportName = "С_шин_ПС_"+FormatDateTime("mmmm yyyy",mmgg);

  xlReportFiders->MacroAfter = "";
  xlReportFiders->Report();

 ZQXLReps->Close();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::FidersToXL_key(int selected,TDateTime mmgg)
{
// Определим, есть ли вводы на ПС

  ZQFiderBalXL->Close();

  AnsiString sqlstr;

  if (selected==0)
  {
   sqlstr= "  select s.*,  case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name \
   from ( \
   select bd.id_point, gt.name as f_name, gt.code_eqp as f_code_eqp, \
   bd.ktr_demand as f_ktr_demand, \
   gt.demand as f_demand,gt.losts as f_losts, \
   bd.ktr_demand-gt.demand as f_real_losts , key.demand_key, key.demand_reactive \
   from \
   ( select code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from  bal_grp_tree_conn_tmp  where type_eqp=15 and mmgg = :dat group by code_eqp,id_point,name order by id_point) as gt \
    left join bal_demand_tmp as bd    on (bd.id_point=gt.id_point and bd.mmgg = :dat) \
    left join \
   ( select sss.fider, sum(case when flag_key = 1 then demand_bill else 0 end ) as demand_key, \
     sum(case when flag_reactive = 5 then demand_bill else 0 end ) as demand_reactive \
     from ( \
      select eq.id,demand_bill, sc.flag_key, sc.flag_reactive, \
      case when gr1.id_voltage in (3,31,32) and gr1.type_eqp = 15 then gr1.code_eqp   when gr2.id_voltage in (3,31,32) and gr2.type_eqp = 15 then gr2.code_eqp  END as fider \
      from eqm_tree_tbl as tr \
      join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
      join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) \
      left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id) \
      left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client)) \
      left join clm_statecl_tbl as sc on (c.id = sc.id_client) \
      left join bal_abons_tbl as ba  on (eq.id = ba.id_point) \
      left join (select id_point, sum(demand_val) as demand_bill from acd_billsum_tbl where kind_energy =1 and mmgg = :dat::::date group by id_point order by id_point) as bs \
    on (bs.id_point = eq.id) \
    left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = ba.id_grp and gr1.mmgg= :dat::::date ) \
    left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date ) \
    where eq.type_eqp = 12 \
    ) as sss \
    where fider is not null \
    group by fider \
   ) as key on (key.fider = gt.code_eqp ) \
   union \
   select 0, '- С шин ПС 110/35/10'::::varchar,0,sum(gdem.demand),sum(gdem.demand),0,0 ,sum(key2.demand_key),sum(key2.demand_reactive) \
   from \
   ( select coalesce(gt3.code_eqp , gt2.code_eqp) as grp, sum(gt.demand) as demand \
    from bal_grp_tree_tmp as gt \
    left join bal_grp_tree_tmp as gt2 on (gt.id_p_eqp = gt2.code_eqp) \
    left join bal_grp_tree_tmp as gt3 on (gt2.id_p_eqp = gt3.code_eqp and gt3.mmgg = :dat::::date ) \
    where \
    ( gt2.type_eqp=3  or (gt2.type_eqp=8 and gt2.id_voltage <3) ) and gt2.mmgg = :dat::::date \
    and gt.type_eqp=12 and gt.mmgg = :dat::::date \
    group by coalesce(gt3.code_eqp , gt2.code_eqp) \
   ) as gdem \
   left join  ( \
     select ba.id_grp, sum(case when flag_key = 1 then demand_bill else 0 end ) as demand_key, \
     sum(case when flag_reactive = 5 then demand_bill else 0 end ) as demand_reactive \
    from eqm_tree_tbl as tr \
    join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
    join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) \
    left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id) \
    left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client)) \
    left join clm_statecl_tbl as sc on (c.id = sc.id_client) \
    left join bal_abons_tbl as ba  on (eq.id = ba.id_point) \
    left join (select id_point, sum(demand_val) as demand_bill from acd_billsum_tbl where kind_energy =1 and mmgg = :dat::::date group by id_point order by id_point) as bs \
    on (bs.id_point = eq.id) \
    where eq.type_eqp = 12 and ba.id_grp is not null and ba.type_grp in (8,3) \
    group by id_grp \
    ) as key2 on (key2.id_grp = gdem.grp ) \
   order by f_name   )as s \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = s.f_code_eqp and gr1.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :dat::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = s.f_code_eqp) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,f_name ;";
  }
  else
  {
   sqlstr= "  select s.*,  case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name  \
    from ( \
   select bd.id_point, gt.name as f_name, gt.code_eqp as f_code_eqp, \
   bd.ktr_demand as f_ktr_demand, \
   gt.demand as f_demand,gt.losts as f_losts, \
   bd.ktr_demand-gt.demand as f_real_losts , key.demand_key, key.demand_reactive \
   from \
   ( select code_eqp, id_point, name, coalesce(sum(demand),0)::::int as demand, coalesce(sum(losts),0)::::int as losts \
     from bal_grp_tree_conn_tmp where type_eqp=15 and mmgg = :dat group by code_eqp,id_point,name order by id_point) as gt \
    left join bal_demand_tmp as bd  on (bd.id_point=gt.id_point and bd.mmgg = :dat) \
   join bal_selfider_tmp as sf on (sf.id_fider = gt.code_eqp) \
   left join \
   ( select sss.fider, sum(case when flag_key = 1 then demand_bill else 0 end ) as demand_key, \
     sum(case when flag_reactive = 5 then demand_bill else 0 end ) as demand_reactive \
     from ( \
      select eq.id,demand_bill, sc.flag_key, sc.flag_reactive, \
      case when gr1.id_voltage in (3,31,32) and gr1.type_eqp = 15 then gr1.code_eqp   when gr2.id_voltage in (3,31,32) and gr2.type_eqp = 15 then gr2.code_eqp  END as fider \
      from eqm_tree_tbl as tr \
      join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
      join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) \
      left join eqm_eqp_use_tbl as use on (use.code_eqp = eq.id) \
      left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client)) \
      left join clm_statecl_tbl as sc on (c.id = sc.id_client) \
      left join bal_abons_tbl as ba  on (eq.id = ba.id_point) \
      left join (select id_point, sum(demand_val) as demand_bill from acd_billsum_tbl where kind_energy =1 and mmgg = :dat::::date group by id_point order by id_point) as bs \
    on (bs.id_point = eq.id) \
    left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = ba.id_grp and gr1.mmgg= :dat::::date ) \
    left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date ) \
    where eq.type_eqp = 12 \
    ) as sss \
    where fider is not null \
    group by fider \
   ) as key on (key.fider = gt.code_eqp ) \
   where  sf.selected = 1 \
   order by f_name   )as s \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = s.f_code_eqp and gr1.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :dat::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :dat::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = s.f_code_eqp) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,f_name ;";
 }

  ZQFiderBalXL->Sql->Clear();
  ZQFiderBalXL->Sql->Add(sqlstr);

  ZQFiderBalXL->ParamByName("dat")->AsDateTime=mmgg;

  try
  {
   ZQFiderBalXL->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }

 xlReportFiders->XLSTemplate = "XL\\fiders_key.xls";
 TxlDataSource *Dsr;
 TxlReportParam *Param;
 xlReportFiders->DataSources->Clear();

 Dsr = xlReportFiders->DataSources->Add();
 Dsr->DataSet = ZQFiderBalXL;
 Dsr->Alias = "ZQXLReps";
 Dsr->Range = "Range";


 xlReportFiders->Params->Clear();
 Param=xlReportFiders->Params->Add();
 Param->Name="lres";
 Param=xlReportFiders->Params->Add();
 Param->Name="lmmgg";
//  Param=xlReport->Params->Add();
//  Param->Name="caption";

 xlReportFiders->ParamByName["lres"]->Value = ResName;
 xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
 ReportName = "Баланс_"+FormatDateTime("mmmm yyyy",mmgg) ;
 xlReportFiders->Report();

 ZQFiderBalXL->Close();

}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::Losts04(TDateTime mmgg)
{

     AnsiString  sqlstr1= "  select s.*,  case when gr2.id_voltage in (1,2) and gr2.type_eqp = 8 then ee2.name_eqp \
     when gr3.id_voltage in (1,2) and gr3.type_eqp = 8 then ee3.name_eqp END as name_ps35, cp.represent_name , \
     CASE WHEN s.lost04_metod =1 THEN 'Старий' WHEN s.lost04_metod =2 THEN 'Новий' ELSE '' END as metod    \
    from ( \
   select gt.name as f_name, gt.code_eqp as f_code_eqp, \
   l04.l04_count, l04.l04_length, l04.l04f1_length, l04.l04f3_length, l04.fgcp, l04.fiz_demand, l04.nolost_demand, l04.losts04, \
   gt.demand04, gt.lost04_metod , gt.losts_coef \
   from \
   ( select code_eqp, id_point, name, demand,demand04,losts,fact_losts,losts_coef,lost04_metod \
     from bal_grp_tree_tmp where type_eqp=15 and mmgg = :mmgg order by code_eqp) as gt \
    left join bal_losts04_tmp as l04 on (l04.code_eqp=gt.code_eqp and l04.mmgg = :mmgg) \
   order by gt.code_eqp   )as s \
  left join bal_grp_tree_tmp as gr1 on (gr1.code_eqp = s.f_code_eqp and gr1.mmgg= :mmgg::::date) \
  left join bal_grp_tree_tmp as gr2 on (gr1.id_p_eqp = gr2.code_eqp and gr2.mmgg= :mmgg::::date) \
  left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eqp and gr3.mmgg= :mmgg::::date) \
  left join eqm_equipment_tbl as ee2 on (ee2.id = gr2.code_eqp) \
  left join eqm_equipment_tbl as ee3 on (ee3.id = gr3.code_eqp) \
  left join eqm_fider_tbl as ff on (ff.code_eqp = s.f_code_eqp) \
  left join clm_position_tbl as cp on (cp.id = ff.id_position) \
  order by name_ps35,f_name ;";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQXLReps->MasterSource=NULL;
  ZQXLReps->LinkFields="";

  try
  {
    ZQXLReps->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  xlReportFiders->XLSTemplate = "XL\\fiders_04.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Range = "Range";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  ReportName = "Втрати_04"+FormatDateTime("mmmm yyyy",mmgg);

  xlReportFiders->MacroAfter = "";
  xlReportFiders->Report();

 ZQXLReps->Close();
}
//---------------------------------------------------------------------------
void __fastcall TfBalansRep::LostSummary(TDateTime mmgg)
{

     AnsiString  sqlstr1= "select  'ТС' as ttype, voltage_min, power_lost, max(days) as days , count(code_eqp) as cnt_ti, sum(losts_ti) as losts_ti \
      from ( \
      select acc.code_eqp, acc.losts_ti, acc.id_un, extract ('epoch' from acc.dat_e::::timestamp - acc.dat_b::::timestamp)/3600 as days     , \
     CASE WHEN  coalesce(id_un) in (4,41) THEN 50::::numeric/8784 \
          WHEN  coalesce(id_un) in (31,32) THEN 60::::numeric/8784 \
          WHEN  coalesce(id_un) = 3 THEN 100::::numeric/8784 \
          WHEN  coalesce(id_un) in (2,21) THEN 400::::numeric/8784 \
          WHEN  coalesce(id_un) = 1 THEN 1100::::numeric/8784 \
          WHEN  coalesce(id_un) = 11 THEN 1500::::numeric/8784  \
     END::::numeric as power_lost \
     from bal_acc_tmp as acc \
     where  acc.mmgg = :mmgg and coalesce(losts_ti,0)<>0 \
    ) as sss \
   join eqk_voltage_tbl as v on (v.id = id_un) \
   group by voltage_min, power_lost \
   union \
   select 'ТН' as ttype, voltage_min, power_lost, max(days) as days , count(code_eqp) as cnt_tu, sum(losts_tu) as losts_tu from \
   (select acc.code_eqp, acc.losts_tu, acc.id_un, extract ('epoch' from acc.dat_e::::timestamp - acc.dat_b::::timestamp)/3600 as days , \
     CASE WHEN  coalesce(id_un) in (31,32) THEN 1530::::numeric/8784 \
          WHEN  coalesce(id_un) = 3 THEN 1900::::numeric/8784 \
          WHEN  coalesce(id_un) in (2,21) THEN 3600::::numeric/8784 \
          WHEN  coalesce(id_un) = 1 THEN 11000::::numeric/8784 \
          WHEN  coalesce(id_un) = 11 THEN 11800::::numeric/8784 \
     END::::numeric as power_lost \
    from  bal_acc_tmp as acc \
    where  acc.mmgg = :mmgg and coalesce(losts_tu,0)<>0 \
    ) as sss \
   join eqk_voltage_tbl as v on (v.id = id_un) \
   group by voltage_min, power_lost   ;";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr1);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;

     AnsiString  sqlstr2= " select ssss.*, ph.name as phasename, m.name as kind from \
     ( \
   select kind_meter,phase,class, power_lost, max(days) as days, count(code_eqp) as cnt_meter, sum(losts_meter) as losts_meter  from \
   (select acc.code_eqp, acc.losts_meter, ml.power_lost, ss.*, extract ('epoch' from acc.dat_e::::timestamp - acc.dat_b::::timestamp)/3600 as days \
    from   bal_acc_tmp as acc join \
     (select im.id, im.kind_meter,im.phase, coalesce(rtrim(mp.cl,'0. '),'2') as class \
      from eqi_meter_tbl as im \
      left join eqi_meter_prec_tbl as mp on (mp.id_type_eqp = im.id) order by im.id \
     ) as ss \
     on (acc.id_spr_type = ss.id) \
     join eqi_meter_losts_tbl as ml on (ss.kind_meter = ml.kind_meter and ss.phase = ml.phase and ss.class = ml.class) \
     where  acc.mmgg = :mmgg \
   ) as sss \
   group by kind_meter,phase,class, power_lost \
   union \
   select 1,1,'Населення',(select max(power_lost) as max_lost from eqi_meter_losts_tbl where kind_meter = 1 and phase = 1) as ml, \
   extract ('epoch' from max(acc.dat_e)::::timestamp - min(acc.dat_b)::::timestamp)/3600 as days,   sum(fiz_count), sum(losts_meter) \
   from bal_acc_tmp as acc \
   where  acc.mmgg = :mmgg  and code_eqp <0 \
   ) as ssss \
   join eqk_phase_tbl as ph on (ph.id = phase) \
   join eqk_meter_tbl as m on (m.id = kind_meter) \
   order by kind,ph.name,class; ";

  ZQXLReps2->Sql->Clear();
  ZQXLReps2->Sql->Add(sqlstr2);
  ZQXLReps2->ParamByName("mmgg")->AsDateTime=mmgg;

     AnsiString  sqlstr3= "select c.s_nom ,cc.g0,eqp.ukz_un, \
      extract ('epoch' from max(acc.dat_e)::::timestamp - min(acc.dat_b)::::timestamp)/3600 as days, \
      sum(eqp.sn_len) as length, sum(losts_linec) as losts \
      from bal_acc_tmp as acc \
      join bal_eqp_tmp as eqp on (acc.code_eqp = eqp.code_eqp) \
      join eqi_cable_tbl as c on (c.id = eqp.id_type_eqp) \
      left join bal_cable_coef_tbl as cc on (s_min<= c.s_nom and s_max>= c.s_nom and voltage = eqp.ukz_un) \
      where  acc.mmgg = :mmgg and eqp.mmgg = :mmgg \
      and eqp.type_eqp = 6 and ukz_un >=1000 \
      group by c.s_nom , cc.g0, eqp.ukz_un  ; ";

  ZQXLReps3->Sql->Clear();
  ZQXLReps3->Sql->Add(sqlstr3);
  ZQXLReps3->ParamByName("mmgg")->AsDateTime=mmgg;

     AnsiString  sqlstr4= "select w.weather, wc.power_lost ,eqp.ukz_un as un, \
      extract ('epoch' from max(acc.dat_e)::::timestamp - min(acc.dat_b)::::timestamp)/3600 as days,    \
      sum(eqp.sn_len) as length, sum(losts_linea) as losts \
      from bal_acc_tmp as acc \
      join bal_eqp_tmp as eqp on (acc.code_eqp = eqp.code_eqp) \
      left join bal_weather_calendar_tbl as w on (w.mmgg = :mmgg) \
      left join bal_weather_coef_tbl as wc on (wc.weather = w.weather and wc.voltage = eqp.ukz_un) \
      where  acc.mmgg = :mmgg and eqp.mmgg = :mmgg \
      and eqp.type_eqp = 7 and ukz_un >=1000 \
      group by w.weather, wc.power_lost ,eqp.ukz_un ; ";

  ZQXLReps4->Sql->Clear();
  ZQXLReps4->Sql->Add(sqlstr4);
  ZQXLReps4->ParamByName("mmgg")->AsDateTime=mmgg;

  ZQXLReps->MasterSource=NULL;
  ZQXLReps->LinkFields="";

  try
  {
    ZQXLReps->Open();
    ZQXLReps2->Open();
    ZQXLReps3->Open();
    ZQXLReps4->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка SQL :"+sqlstr1);
    return;
  }

  xlReportFiders->XLSTemplate = "XL\\lost_sum.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();
  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps;
  Dsr->Range = "Range";
  Dsr->Alias = "ZQXLReps1";

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps2;
  Dsr->Range = "Range2";
  Dsr->Alias = "ZQXLReps2";

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps3;
  Dsr->Range = "Range3";
  Dsr->Alias = "ZQXLReps3";

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQXLReps4;
  Dsr->Range = "Range4";
  Dsr->Alias = "ZQXLReps4";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg);
  ReportName = "Втрати_розрахунок"+FormatDateTime("mmmm yyyy",mmgg);

  xlReportFiders->MacroAfter = "";
  xlReportFiders->Report();

 ZQXLReps->Close();
 ZQXLReps2->Close();
 ZQXLReps3->Close();
 ZQXLReps4->Close();
}
//---------------------------------------------------------------------------

void TfBalansRep::ShowLostsXL(int id_eqp,TDateTime mmgg,AnsiString name_eqp,int type_eqp, int voltage, int showpoints)
{

  AnsiString  sqlstr=" select dat_b, dat_e from bal_grp_tree_tmp where mmgg = :mmgg limit 1; ";

  ZQXLReps->Sql->Clear();
  ZQXLReps->Sql->Add(sqlstr);
  ZQXLReps->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQXLReps->Open();

   dat_b = ZQXLReps->FieldByName("dat_b")->AsDateTime;
   dat_e = ZQXLReps->FieldByName("dat_e")->AsDateTime;
  ZQXLReps->Close();

  AnsiString represent_name ;
  if (type_eqp ==15)
  {
   sqlstr=" select cp.represent_name from eqm_fider_tbl as ff  \
    left join clm_position_tbl as cp on (cp.id = ff.id_position) \
    where ff.code_eqp = :eqp ; ";

   ZQXLReps->Sql->Clear();
   ZQXLReps->Sql->Add(sqlstr);
   ZQXLReps->ParamByName("eqp")->AsInteger=id_eqp;
   ZQXLReps->Open();
   represent_name = ZQXLReps->FieldByName("represent_name")->AsString;
   ZQXLReps->Close();
  }

  AnsiString  sqlstr1;


sqlstr1=" select sss.*, coalesce(code_eqp_inst,-1) as key, \
case when ukz_un < 1000 then losts_linea else 0 end as losts_linea04, \
case when ukz_un >= 1000 then losts_linea else 0 end as losts_linea10, \
case when ukz_un < 1000 then losts_linec else 0 end as losts_linec04, \
case when ukz_un >= 1000 then losts_linec else 0 end as losts_linec10, \
case when ukz_un < 1000 then losts_air else 0 end as losts_air04, \
case when ukz_un >= 1000 then losts_air else 0 end as losts_air10, \
case when ukz_un < 1000 then losts_cable else 0 end as losts_cable04, \
case when ukz_un >= 1000 then losts_cable else 0 end as losts_cable10 \
 from \
( select eq.type_eqp, eq.code_eqp, e.name_eqp, 'Трансформатор' as name , c.type,eq.loss_power,  sn_len, pxx_r0,pkz_x0,ukz_un,demand+lst as demand,losts, \
losts_linea,losts_linec,losts_kz,losts_xx,losts_air,losts_cable \
from bal_eqp_tmp as eq \
join bal_acc_tmp as acc on (eq.code_eqp = acc.code_eqp) \
join eqi_compensator_tbl as c on (c.id = id_type_eqp) \
join eqm_equipment_tbl as e on (e.id = eq.code_eqp) \
where eq.mmgg = :mmgg and acc.mmgg = :mmgg \ \
and eq.type_eqp =2 \
union \
select eq.type_eqp, eq.code_eqp, e.name_eqp,'Линия воздушная' as name , c.type,eq.loss_power,  sn_len, pxx_r0, null as pkz_x0,ukz_un,demand+lst as demand,losts, \
losts_linea,losts_linec,losts_kz,losts_xx,losts_air,losts_cable \
from bal_eqp_tmp as eq \
join bal_acc_tmp as acc on (eq.code_eqp = acc.code_eqp) \
join eqi_corde_tbl as c on (c.id = id_type_eqp) \
join eqm_equipment_tbl as e on (e.id = eq.code_eqp) \
where eq.mmgg = :mmgg and acc.mmgg = :mmgg \
and eq.type_eqp =7 \
union \
select eq.type_eqp, eq.code_eqp, e.name_eqp, 'Линия кабельная' as name , c.type,eq.loss_power,  sn_len, pxx_r0, null as pkz_x0,ukz_un,demand+lst as demand,losts, \
losts_linea,losts_linec,losts_kz,losts_xx,losts_air,losts_cable \
from bal_eqp_tmp as eq \
join bal_acc_tmp as acc on (eq.code_eqp = acc.code_eqp) \
join eqi_cable_tbl as c on (c.id = id_type_eqp) \
join eqm_equipment_tbl as e on (e.id = eq.code_eqp) \
where eq.mmgg = :mmgg and acc.mmgg = :mmgg \
and eq.type_eqp =6 \
order by type_eqp, name_eqp \
) as sss \
left join \
eqm_compens_station_inst_tbl as cs on (cs.code_eqp =sss.code_eqp) ; ";


  ZQDemandNew->Sql->Clear();
  ZQDemandNew->Sql->Add(sqlstr1);
  ZQDemandNew->ParamByName("mmgg")->AsDateTime=mmgg;
//  ZQDemandNew->ParamByName("dt_b")->AsDateTime=dat_b;
//  ZQDemandNew->ParamByName("dt_e")->AsDateTime=dat_e;
//  ZQDemandNew->ParamByName("res")->AsInteger=ResId;


  AnsiString  sqlstr2=" select * \
   from ( select \
case when volt1 in (1,2) and type1 = 8 then gr_1 \
     when volt2 in (1,2) and type2 = 8 then gr_2 \
     when volt3 in (1,2) and type3 = 8 then gr_3 \
     when volt4 in (1,2) and type4 = 8 then gr_4 \
     when volt5 in (1,2) and type5 = 8 then gr_5  END as code_ps35, \
case when volt1 in (1,2) and type1 = 8 then name1 \
     when volt2 in (1,2) and type2 = 8 then name2 \
     when volt3 in (1,2) and type3 = 8 then name3 \
     when volt4 in (1,2) and type4 = 8 then name4 \
     when volt5 in (1,2) and type5 = 8 then name5  END as name_ps35, \
case when type1 = 3 then gr_1 \
     when type2 = 3 then gr_2 \
     when type3 = 3 then gr_3 \
     when type4 = 3 then gr_4 \
     when type5 = 3 then gr_5 END as code_vvod, \
case when type1 = 3 then name1 \
     when type2 = 3 then name2 \
     when type3 = 3 then name3 \
     when type4 = 3 then name4 \
     when type5 = 3 then name5 END as name_vvod, \
case when volt1 in (3,31,32) and type1 = 15 then gr_1 \
     when volt2 in (3,31,32) and type2 = 15 then gr_2 \
     when volt3 in (3,31,32) and type3 = 15 then gr_3 \
     when volt4 in (3,31,32) and type4 = 15 then gr_4 \
     when volt5 in (3,31,32) and type5 = 15 then gr_5 END as code_f10, \
case when volt1 in (3,31,32) and type1 = 15 then name1 \
     when volt2 in (3,31,32) and type2 = 15 then name2 \
     when volt3 in (3,31,32) and type3 = 15 then name3 \
     when volt4 in (3,31,32) and type4 = 15 then name4 \
     when volt5 in (3,31,32) and type5 = 15 then name5 END as name_f10, \
case when volt1 in (3,31,32) and type1 = 8 then gr_1 \
     when volt2 in (3,31,32) and type2 = 8 then gr_2 \
     when volt3 in (3,31,32) and type3 = 8 then gr_3 \
     when volt4 in (3,31,32) and type4 = 8 then gr_4 \
     when volt5 in (3,31,32) and type5 = 8 then gr_5 END as code_ps10, \
case when volt1 in (3,31,32) and type1 = 8 then name1 \
     when volt2 in (3,31,32) and type2 = 8 then name2 \
     when volt3 in (3,31,32) and type3 = 8 then name3 \
     when volt4 in (3,31,32) and type4 = 8 then name4 \
     when volt5 in (3,31,32) and type5 = 8 then name5 END as name_ps10 , \
   dat_b, dat_e, losts, code_eqp, code_eqp as key \
from \
( \
 select \
  s1.code_eqp as gr_1,s1.type_eqp as type1,s1.id_voltage as volt1,s1.name as name1,s1.losts as lost1,s1.dat_b as dat_b1,s1.dat_e as dat_e1, \
  s2.code_eqp as gr_2,s2.type_eqp as type2,s2.id_voltage as volt2,s2.name as name2,s2.losts as lost2,s2.dat_b as dat_b2,s2.dat_e as dat_e2, \
  s3.code_eqp as gr_3,s3.type_eqp as type3,s3.id_voltage as volt3,s3.name as name3,s3.losts as lost3,s3.dat_b as dat_b3,s3.dat_e as dat_e3, \
  s4.code_eqp as gr_4,s4.type_eqp as type4,s4.id_voltage as volt4,s4.name as name4,s4.losts as lost4,s4.dat_b as dat_b4,s4.dat_e as dat_e4, \
  s5.code_eqp as gr_5,s5.type_eqp as type5,s5.id_voltage as volt5,s5.name as name5,s5.losts as lost5,s5.dat_b as dat_b5,s5.dat_e as dat_e5, \
  coalesce(s5.dat_b,s4.dat_b,s3.dat_b,s2.dat_b,s1.dat_b) as dat_b, \
  coalesce(s5.dat_e,s4.dat_e,s3.dat_e,s2.dat_e,s1.dat_e) as dat_e, \
  coalesce(s5.losts,s4.losts,s3.losts,s2.losts,s1.losts) as losts, \
  coalesce(s5.code_eqp,s4.code_eqp,s3.code_eqp,s2.code_eqp,s1.code_eqp) as code_eqp \
  from bal_grp_tree_conn_tmp as s1 \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s2 on (s2.id_p_eqp=s1.code_eqp or s2.code_eqp is null) \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s3 on (s3.id_p_eqp=s2.code_eqp or s3.code_eqp is null) \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s4 on (s4.id_p_eqp=s3.code_eqp or s4.code_eqp is null) \
  left join \
  (select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,demand,losts,dat_b,dat_e from bal_grp_tree_tmp where type_eqp<>12 and mmgg = :mmgg \
  union \
  select null, null ,null ,null ,null,null,null,null,null,null) as s5 on (s5.id_p_eqp=s4.code_eqp or s5.code_eqp is null) \
  where \
  (s1.code_eqp=:code_eqp  or s2.code_eqp=:code_eqp or s3.code_eqp=:code_eqp or s4.code_eqp=:code_eqp or s5.code_eqp=:code_eqp or :code_eqp = 0) and \
   s1.id_p_eqp is null and  s1.mmgg = :mmgg \
  order by gr_1 desc,gr_2 desc,gr_3 desc,gr_4 desc,gr_5 desc \
 ) as ss \
 union \
  ( select -1,'Явно не указано',null,null,null,null,null,null,null,null,0,-1,-1 where :code_eqp = 0 ) \
 ) as sss \
  order by coalesce(name_ps35,' '), coalesce(name_vvod,' '), coalesce(name_f10,' '), coalesce(name_ps10,' '), dat_b, dat_e ; ";


  ZQDemandNewSum->Sql->Clear();
  ZQDemandNewSum->Sql->Add(sqlstr2);
  ZQDemandNewSum->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQDemandNewSum->ParamByName("code_eqp")->AsInteger=id_eqp;

   /*
  ZQXLReps->MasterSource=DSRep;
  ZQXLReps->LinkFields="link = link";
*/
  try
  {
  ZQDemandNew->Open();
  ZQDemandNewSum->Open();

  }
  catch(EDatabaseError &e)
  {
    ShowMessage("Ошибка : "+e.Message.SubString(8,200));
    return;
  }


  xlReportFiders->XLSTemplate = "XL\\balans_losts.xls";
  TxlDataSource *Dsr;
  TxlReportParam *Param;
  xlReportFiders->DataSources->Clear();

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQDemandNewSum;
  Dsr->Alias =  "ZQXLRepsSum";
  Dsr->Range = "GroupRange";

  Dsr = xlReportFiders->DataSources->Add();
  Dsr->DataSet = ZQDemandNew;
  Dsr->Alias = "ZQXLReps";
  Dsr->Range = "Range";
  Dsr->MasterSourceName="ZQXLRepsSum";

  xlReportFiders->Params->Clear();
  Param=xlReportFiders->Params->Add();
  Param->Name="lres";
  Param=xlReportFiders->Params->Add();
  Param->Name="lmmgg";
  Param=xlReportFiders->Params->Add();
  Param->Name="lobject";
  Param=xlReportFiders->Params->Add();
  Param->Name="linspector";


  Param=xlReportFiders->Params->Add();
  Param->Name="lnow";


  xlReportFiders->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReportFiders->ParamByName["lres"]->Value = ResName;
  xlReportFiders->ParamByName["lobject"]->Value = name_eqp;

  xlReportFiders->ParamByName["lmmgg"]->Value = FormatDateTime("mmmm yyyy",mmgg)+" ("+
   FormatDateTime("dd.mm.yyyy",dat_b)+" - "+ FormatDateTime("dd.mm.yyyy",dat_e)+")";

  xlReportFiders->ParamByName["linspector"]->Value = represent_name;

  ReportName = "Расчет потерь_"+name_eqp;

  xlReportFiders->MacroAfter = "FormatData";
  xlReportFiders->Report();
  xlReportFiders->MacroAfter = "";



 ZQDemandNew->Close();
 ZQDemandNewSum->Close();
      /*
 ZQXLReps->MasterSource=NULL;
 ZQXLReps->LinkFields="";
 */
}
//---------------------------------------------------------------------------

