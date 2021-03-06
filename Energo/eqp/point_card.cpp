//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "point_card.h"
#include "WorkList.h"
#include "PlombList.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma resource "*.dfm"
TfPointCard *fPointCard;
//---------------------------------------------------------------------------
__fastcall TfPointCard::TfPointCard(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  ZQMeters->Database=TWTTable::Database;
  ZQCompI->Database=TWTTable::Database;
  ZQPoint->Database=TWTTable::Database;
  ZQWorks->Database=TWTTable::Database;
  ZQPlombs->Database=TWTTable::Database;
  
  DateTimePicker->Date = Date();
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::FormClose(TObject *Sender,
      TCloseAction &Action)
{
  ZQCompI->Close();
  ZQMeters->Close();

 TfTWTCompForm::FormClose(Sender,Action);

 Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::FormShow(TObject *Sender)
{
//
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::ShowData(int id)
{
  id_point = id;
  ZQMeters->ParamByName("point")->AsInteger = id;
  ZQMeters->ParamByName("client")->AsInteger = id_client;
  ZQMeters->ParamByName("dt")->AsDateTime = DateTimePicker->Date;

  ZQCompI->ParamByName("point")->AsInteger = id;
  ZQCompI->ParamByName("dt")->AsDateTime = DateTimePicker->Date;

  ZQPoint->ParamByName("point")->AsInteger = id;
  ZQPoint->ParamByName("dt")->AsDateTime = DateTimePicker->Date;

  ZQWorks->ParamByName("point")->AsInteger = id;
  ZQWorks->ParamByName("dt")->AsDateTime = DateTimePicker->Date;

  ZQPlombs->ParamByName("point")->AsInteger = id;
  ZQPlombs->ParamByName("dt")->AsDateTime = DateTimePicker->Date;

  ZQCompI->Open();
  ZQMeters->Open();
  ZQPoint->Open();
  ZQWorks->Open();
  ZQPlombs->Open();

  lPointName->Caption =ZQPoint->FieldByName("name_eqp")->AsString;
  lAreaName->Caption =ZQPoint->FieldByName("name_area")->AsString;
  lAddress->Caption =ZQPoint->FieldByName("adr")->AsString;

  TDateTime last_date =ZQPoint->FieldByName("dt_last")->AsDateTime;

  for(int i=0;i<ZQMeters->RecordCount;i++)
  {
    if(ZQMeters->FieldByName("dt_last")->AsDateTime >last_date)
      last_date =ZQMeters->FieldByName("dt_last")->AsDateTime;
    ZQMeters->Next();
  }

  for(int i=0;i<ZQCompI->RecordCount;i++)
  {
    if(ZQCompI->FieldByName("dt_last")->AsDateTime >last_date)
      last_date =ZQCompI->FieldByName("dt_last")->AsDateTime;
    ZQCompI->Next();
  }

  lLastDate->Caption = FormatDateTime("dd.mm.yyyy",last_date);

  ZQPoint->Close();

//
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::btCancelClick(TObject *Sender)
{
 Close();
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::DateTimePickerChange(TObject *Sender)
{
  ZQCompI->Close();
  ZQMeters->Close();
  ZQPoint->Close();
  ZQWorks->Close();
  ZQPlombs->Close();

  ZQMeters->ParamByName("dt")->AsDateTime = DateTimePicker->Date;
  ZQCompI->ParamByName("dt")->AsDateTime = DateTimePicker->Date;
  ZQPoint->ParamByName("dt")->AsDateTime = DateTimePicker->Date;
  ZQWorks->ParamByName("dt")->AsDateTime = DateTimePicker->Date;
  ZQPlombs->ParamByName("dt")->AsDateTime = DateTimePicker->Date;

  ZQCompI->Open();
  ZQMeters->Open();
  ZQPoint->Open();
  ZQWorks->Open();
  ZQPlombs->Open();

  lPointName->Caption =ZQPoint->FieldByName("name_eqp")->AsString;
  lAreaName->Caption =ZQPoint->FieldByName("name_area")->AsString;
  lAddress->Caption =ZQPoint->FieldByName("adr")->AsString;

  ZQPoint->Close();
  
}
//---------------------------------------------------------------------------

void __fastcall TfPointCard::sbWorkListClick(TObject *Sender)
{
  TWinControl *Owner = this ;
  // ���� ����� ���� ���� - ������������ � �������
  if (MainForm->ShowMDIChild("������ �����", Owner)) {
    return;
  }
/*
  ZQWorksList = new  TWTQuery(this);
  ZQWorksList->Options << doQuickOpen;

  ZQWorksList->Sql->Clear();
  ZQWorksList->Sql->Add(" select * from clm_works_tbl where id_point = :point order by dt_work; ");

  ZQWorksList->ParamByName("point")->AsInteger=id_point;
*/
//  TfWorkList *fWorkList = new TfWorkList(this, ZQWorksList,false, id_client,id_point);
  TfWorkList *fWorkList = new TfWorkList(this,id_client,id_point);
  fWorkList->Abon_name = AbonName;
  fWorkList->Point_name = lPointName->Caption;

  fWorkList->SetCaption("������ �����");
  fWorkList->ShowAs("������ �����");

  fWorkList->MainPanel->ParamByID("Indications")->Control->SetFocus();
  fWorkList->MainPanel->ParamByID("Works")->Control->SetFocus();
  
  fWorkList->OnCloseQuery=WorkListClose;
}
//---------------------------------------------------------------------------

void __fastcall TfPointCard::WorkListClose(TObject *Sender, bool &CanClose)
{
  ZQWorks->Refresh();
}
//--------------------------------------------------------------------


void __fastcall TfPointCard::dgWorksDblClick(TObject *Sender)
{

  TWinControl *Owner = this ;
  // ���� ����� ���� ���� - ������������ � �������
  if (MainForm->ShowMDIChild("������ �����", Owner)) {
    return;
  }
/*
  ZQWorksList = new  TWTQuery(this);
  ZQWorksList->Options << doQuickOpen;

  ZQWorksList->Sql->Clear();
  ZQWorksList->Sql->Add(" select * from clm_works_tbl where id_point = :point and id_type  = :type order by dt_work; ");

  ZQWorksList->ParamByName("point")->AsInteger=id_point;
  ZQWorksList->ParamByName("type")->AsInteger=ZQWorks->FieldByName("id_w")->AsInteger;
*/
//  TfWorkList *fWorkList = new TfWorkList(this, ZQWorksList,false, id_client,id_point);
  TfWorkList *fWorkList = new TfWorkList(this,id_client,id_point);
  fWorkList->SetCaption("������ ����� ("+ZQWorks->FieldByName("name")->AsString+")");
  fWorkList->id_type =ZQWorks->FieldByName("id_w")->AsInteger;
  fWorkList->Abon_name = AbonName;
  fWorkList->Point_name = lPointName->Caption;
  
  fWorkList->ShowAs("������ �����");

  fWorkList->MainPanel->ParamByID("Indications")->Control->SetFocus();
  fWorkList->MainPanel->ParamByID("Works")->Control->SetFocus();
  
  fWorkList->OnCloseQuery=WorkListClose;
}
//---------------------------------------------------------------------------

void __fastcall TfPointCard::sbRefreshClick(TObject *Sender)
{
  ZQWorks->Refresh();
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::sbPlombsRefreshClick(TObject *Sender)
{
  ZQPlombs->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TfPointCard::sbPlombsListClick(TObject *Sender)
{

  TWinControl *Owner = this ;
  // ���� ����� ���� ���� - ������������ � �������
  if (MainForm->ShowMDIChild("������ �����", Owner)) {
    return;
  }

  ZQPlombList = new  TWTQuery(this);
 // ZQPlombList->Options << doQuickOpen;

  ZQPlombList->Sql->Clear();
  ZQPlombList->Sql->Add(" select * from clm_plomb_tbl where id_point = :point order by CASE WHEN dt_e is null then 0 else 1 end, object_name, dt_b ; ");

  ZQPlombList->ParamByName("point")->AsInteger=id_point;

  TfPlombList *fPlombList = new TfPlombList(this, ZQPlombList,false, id_client,id_point);
  fPlombList->Abon_name = AbonName;
  fPlombList->Point_name = lPointName->Caption;
  fPlombList->SetCaption("������ �����");
  fPlombList->ShowAs("������ �����");

  fPlombList->OnCloseQuery=PlombListClose;
}
//---------------------------------------------------------------------------
void __fastcall TfPointCard::PlombListClose(TObject *Sender, bool &CanClose)
{
  ZQPlombs->Refresh();
}
//--------------------------------------------------------------------

void __fastcall TfPointCard::btOkClick(TObject *Sender)
{
  xlReport->XLSTemplate = "XL\\point_card.xls";

  TxlDataSource *Dsr;
  TxlReportParam *Param;

  ZQPoint->Open();

  xlReport->DataSources->Clear();

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQPoint;
  Dsr->Alias =  "ZQXLReps";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQWorks;
  Dsr->Alias =  "ZQXLRepsWorks";
  Dsr->Range = "RangeWorks";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQMeters;
  Dsr->Alias =  "ZQXLRepsMeters";
  Dsr->Range = "RangeMeters";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQCompI;
  Dsr->Alias =  "ZQXLRepsCompI";
  Dsr->Range = "RangeCompI";

  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQPlombs;
  Dsr->Alias =  "ZQXLRepsPlombs";
  Dsr->Range = "RangePlombs";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lnow";
  Param=xlReport->Params->Add();
  Param->Name="labon";
  Param=xlReport->Params->Add();
  Param->Name="user";
  Param=xlReport->Params->Add();
  Param->Name="ldt";



  TWTQuery* ZQuery = new TWTQuery(this);
  ZQuery->Options.Clear();
  ZQuery->Options<< doQuickOpen;
  ZQuery->RequestLive=false;

  AnsiString sqlstr="select c.id,c.name  from clm_client_tbl as c where c.id = syi_resid_fun() ";

  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  try
   {
    ZQuery->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }
   if (ZQuery->RecordCount>0)
   {
    ZQuery->First();
    ResName=ZQuery->FieldByName("name")->AsString;
   }
  ZQuery->Close();

  sqlstr="select  users.represent_name as usrname  from  clm_position_tbl as users where users.id = getsysvar('id_person'::::varchar) ";

  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  try
   {
    ZQuery->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }
   if (ZQuery->RecordCount>0)
   {
    ZQuery->First();
    CurUserName=ZQuery->FieldByName("usrname")->AsString;
   }
  ZQuery->Close();



  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReport->ParamByName["lres"]->Value = ResName;
  xlReport->ParamByName["labon"]->Value = AbonName;
  xlReport->ParamByName["user"]->Value = CurUserName;
  xlReport->ParamByName["ldt"]->Value = FormatDateTime("dd.mm.yyyy",DateTimePicker->Date);


  xlReport->Report();

}
//---------------------------------------------------------------------------

void __fastcall TfPointCard::DateTimePickerKeyPress(TObject *Sender,
      char &Key)
{
 if(Key==13)
 {
  DateTimePickerChange(Sender);
  Key=0;
 }

}
//---------------------------------------------------------------------------


