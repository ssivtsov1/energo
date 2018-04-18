//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "point_blank.h"
#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPointAct *fPointAct;
//---------------------------------------------------------------------------
__fastcall TfPointAct::TfPointAct(TComponent* Owner)
        : TForm(Owner)
{
  ZQPoint ->Database=TWTTable::Database;
  ZQCompI ->Database=TWTTable::Database;
  ZQCompU ->Database=TWTTable::Database;
  ZQMeterA->Database=TWTTable::Database;
  ZQMeterR->Database=TWTTable::Database;
  ZQMeterG->Database=TWTTable::Database;
  ZQPlombs->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------
void __fastcall TfPointAct::PrintData(int id)
{
//  id_point = id;
  ZQPoint->Close();
  ZQCompI->Close();
  ZQCompU->Close();
  ZQMeterA->Close();
  ZQMeterR->Close();
  ZQMeterG->Close();
  ZQPlombs->Close();

  ZQPoint->ParamByName("point")->AsInteger = id;
  ZQCompI->ParamByName("point")->AsInteger = id;
  ZQCompU->ParamByName("point")->AsInteger = id;
  ZQMeterA->ParamByName("point")->AsInteger = id;
  ZQMeterR->ParamByName("point")->AsInteger = id;
  ZQMeterG->ParamByName("point")->AsInteger = id;
  ZQPlombs->ParamByName("point")->AsInteger = id;

  ZQPoint->Open();
  ZQCompI->Open();
  ZQCompU->Open();
  ZQMeterA->Open();
  ZQMeterR->Open();
  ZQMeterG->Open();
  ZQPlombs->Open();
                                                                              

  xlReport->XLSTemplate = "XL\\point_oglad.xls";

  TxlDataSource *Dsr;
  TxlReportParam *Param;

  xlReport->DataSources->Clear();

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQPoint;
  Dsr->Alias =  "ZQXLReps";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQCompI;
  Dsr->Alias =  "ZQXLRepsCompI";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQCompU;
  Dsr->Alias =  "ZQXLRepsCompU";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQMeterA;
  Dsr->Alias =  "ZQXLRepsMeterA";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQMeterR;
  Dsr->Alias =  "ZQXLRepsMeterR";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQMeterG;
  Dsr->Alias =  "ZQXLRepsMeterG";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQPlombs;
  Dsr->Alias =  "ZQXLRepsPlombs";


  xlReport->Params->Clear();
/*
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lnow";
  Param=xlReport->Params->Add();
  Param->Name="labon";
  Param=xlReport->Params->Add();
  Param->Name="user";
  */
  Param=xlReport->Params->Add();
  Param->Name="ldt";


//  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
//  xlReport->ParamByName["lres"]->Value = ResName;
//  xlReport->ParamByName["labon"]->Value = AbonName;
//  xlReport->ParamByName["user"]->Value = CurUserName;
  xlReport->ParamByName["ldt"]->Value = FormatDateTime("dd.mm.yyyy",Now());


  xlReport->Report();

  ZQPoint->Close();
  ZQCompI->Close();
  ZQCompU->Close();
  ZQMeterA->Close();
  ZQMeterR->Close();
  ZQMeterG->Close();
  ZQPlombs->Close();

//
}
//---------------------------------------------------------------------------

