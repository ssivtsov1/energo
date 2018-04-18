//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"

#include "ParamsForm.h"

#include "fmonFiderWorks.h"
#include "fmonFiderWorkEdit.h"
#include "fPeriodSel.h"
#include "xlcClasses.hpp"
#include "xlReport.hpp"

//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;

//----------------------------------------------------------------------
//--------------------------- журнал работ на оборудовании фидера -----
//----------------------------------------------------------------------
__fastcall TfMonitorFiderWorks::TfMonitorFiderWorks( TComponent* AOwner, int id ) : TWTDoc(AOwner)
{

  id_fider = id;
 // получим иекущий рабочий период
  TWTQuery * ZQuery = new TWTQuery(Application);
  ZQuery->Options<< doQuickOpen;

  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

  if (id_fider !=0)
  {
   AnsiString sqlstr="select name_eqp from eqm_equipment_tbl where id = :id ;";
   ZQuery->Sql->Clear();
   ZQuery->Sql->Add(sqlstr);
   ZQuery->ParamByName("id")->AsInteger = id_fider;

   try
   {
    ZQuery->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка "+e.Message.SubString(8,200));
    ZQuery->Close();
    delete ZQuery;
    return;
   }
   ZQuery->First();
   fidername = ZQuery->FieldByName("name_eqp")->AsString;

   ZQuery->Close();
  }

//  TWTPanel* PCaption=MainPanel->InsertPanel(10,true,10);

  TWTPanel* PTax=MainPanel->InsertPanel(200,true,200);
/*
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PCaption->Params->AddText("Отключения "+ ZQAbonList->FieldByName("short_name")->AsString,10,F,Classes::taCenter,false);
*/
  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;

   Query2->Sql->Clear();
   Query2->Sql->Add("select fw.*, i.name as type, eq.name_eqp as fider , c.short_name \
   from mnm_fider_works_tbl as fw \
   join mni_works_tbl as i on (i.id = fw.id_type) \
   left join eqm_equipment_tbl as eq on (fw.id_fider = eq.id) \
   left join clm_client_tbl as c on (c.id=fw.id_client) ");

   if (id_fider !=0)
    Query2->Sql->Add(" where fw.id_fider = "+ IntToStr(id_fider));

   Query2->Sql->Add("  order by fw.dt_work ; " );

   DBGrDoc=new TWTDBGrid(PTax, Query2);

   qDocList = DBGrDoc->Query;

   DBGrDoc->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrDoc, true)->ID="SwGrid";
/*
   TWTQuery* QuerDci=new TWTQuery(this);
   QuerDci->Sql->Add(" select name,id from dci_document_tbl where idk_document = 600 order by id; " );
   QuerDci->Open();

   qDocList->AddLookupField("Namek_doc","idk_document",QuerDci,"name","id");
*/
//  qDocList->AddLookupField("CONNAME", "id_con", "bal_connector_tbl", "name","id");

  qDocList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("type");
  NList->Add("fider");
  NList->Add("short_name");

  qDocList->SetSQLModify("mnm_fider_works_tbl",WList,NList,true,false,true);
 // TDataSetNotifyEvent OldInsert =
  /////////////////////////qDocList->AfterInsert=  NewDocInsert;
  qDocList->OnNewRecord =  NewDocInsert;
  qDocList->AfterInsert=CancelInsert;

  qDocList->FieldByName("dt_work")->EditMask = "90.90.0000";
  ((TDateTimeField*)(qDocList->FieldByName("dt_work")))->DisplayFormat = "dd.mm.yyyy";

  //qDocList->FieldByName("dt_work")->EditMask = "90.90.0000 00:00";
  //((TDateTimeField*)(qDocList->FieldByName("dt_work")))->DisplayFormat = "dd.mm.yyyy hh:nn";

  TWTField *Fieldh;

  Fieldh = DBGrDoc->AddColumn("fider", "Фидер", "Фидер");
  Fieldh->SetWidth(150);
  Fieldh->SetReadOnly();

  Fieldh = DBGrDoc->AddColumn("dt_work", "Дата работы.", "Дата работы");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("type", "Работа", "Работа");
  Fieldh->SetWidth(250);
  Fieldh->SetReadOnly();

  Fieldh = DBGrDoc->AddColumn("short_name", "Абонент", "Абонент");
  Fieldh->SetWidth(250);
  Fieldh->SetReadOnly();

  Fieldh = DBGrDoc->AddColumn("cnt", "Количество", "Количество");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("object_name", "Объекты", "Объекты");
  Fieldh->SetWidth(200);

  Fieldh = DBGrDoc->AddColumn("comment", "Комментарий", "Комментарий");
  Fieldh->SetWidth(200);

  DBGrDoc->BeforeInsert=WorkNewGr;
  DBGrDoc->OnAccept=SwitchEdit;

  DBGrDoc->Visible=true;
  DBGrDoc->Query->Filtered=false;

  SetCaption("Тех. и сбытовые работы. "+fidername);

  //---------------------------------------------
  TWTToolBar* tb=DBGrDoc->ToolBar;

  TWTToolButton* btAll=tb->AddButton("dateinterval", "Выбор периода", PeriodSel);
  TWTToolButton* btnPrint=tb->AddButton("print", "Печать", PrintList);

  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=SwitchEdit;
    if ( btn->ID=="NewRecord")
       {
//       if (IsInsert)
         tb->Buttons[i]->OnClick=WorkNew;
//       else
//         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
     {
//     if (IsInsert)
//       {
//        OldDelEqp=tb->Buttons[i]->OnClick;
//        tb->Buttons[i]->OnClick=DelEqp;
//       }
//     else
//       tb->Buttons[i]->OnClick=NULL;
     }
   }

  DateTo = Now();
  DateFrom = Now();
 };
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorks::NewDocInsert(TDataSet* DataSet)
{
// if (id_fider!=0)
//   DataSet->FieldByName("id_fider")->AsInteger=id_fider;
}
//----------------------------------------------------------------------

void __fastcall TfMonitorFiderWorks::ShowData(void)
{
 MainPanel->ParamByID("SwGrid")->Control->SetFocus();
// MainPanel->ParamByID("DocLines")->Control->SetFocus();
// MainPanel->ParamByID("DemLimitH")->Control->SetFocus();
};

//----------------------------------------------------------

void _fastcall TfMonitorFiderWorks::WorkNewGr(TWTDBGrid *Sender) {

  //if (!ReadOnly)
  WorkNew(Sender);
 // DBGrDoc->Query->Refresh();
  DBGrDoc->Query->Cancel();
};
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorks::WorkNew(TObject* Sender)
{

  Application->CreateForm(__classid(TfMonitorFiderWorkEdit), &fMonitorFiderWorkEdit);
  fMonitorFiderWorkEdit->FiderId = id_fider;
  fMonitorFiderWorkEdit->ShowNew();
  fMonitorFiderWorkEdit->qParent = DBGrDoc->Query;

}
//---------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorks::SwitchEdit (TObject* Sender)
{
  TWinControl *Owner = NULL;

  Application->CreateForm(__classid(TfMonitorFiderWorkEdit), &fMonitorFiderWorkEdit);

  if(DBGrDoc->Query->FieldByName("id")->AsInteger!=0)
    fMonitorFiderWorkEdit->ShowData(DBGrDoc->Query->FieldByName("id")->AsInteger);
  else
    fMonitorFiderWorkEdit->ShowNew();

  fMonitorFiderWorkEdit->qParent = DBGrDoc->Query;

}
//---------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorks::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorks::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;

//    if (qTaxList->FieldByName("mmgg")->AsDateTime != ZeroTime)
//        fPeriodSelect->FormShow(qTaxList->FieldByName("mmgg")->AsDateTime,qTaxList->FieldByName("mmgg")->AsDateTime);
//    else
    fPeriodSelect->FormShow(DateFrom,DateTo);


    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };


   if (rez == mrOk)
   {
     DBGrDoc->Query->Filtered=false;
     DBGrDoc->Query->DefaultFilter="dt_work >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and dt_work <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     DBGrDoc->Query->Filtered=true;
     DBGrDoc->Query->Refresh();

     SetCaption("Тех. и сбытовые работы ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");

     DateFrom=fPeriodSelect->DateFrom;
     DateTo = fPeriodSelect->DateTo;
    }
   else
   {
     //qTaxList->Filtered=false;
     DBGrDoc->Query->DefaultFilter="";
     DBGrDoc->Query->Refresh();
     DBGrDoc->Query->Refresh();
     SetCaption("Тех. и сбытовые работы. ");
   }

//    delete fPeriodSelect;
//    ReBuildGrid();
};

//--------------------------------------------------
void __fastcall TfMonitorFiderWorks::PrintList(TObject *Sender)
{
 TxlReport* xlReport = new TxlReport(this);

  xlReport->XLSTemplate = "XL\\fiderwork_list.xls";

  TxlDataSource *Dsr;

  TxlReportParam *Param;
  xlReport->DataSources->Clear();
  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = DBGrDoc->Query;
  Dsr->Alias =  "ZQXLReps";
  Dsr->Range = "Range";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lnow";
  Param=xlReport->Params->Add();
  Param->Name="lperiod";
  Param=xlReport->Params->Add();
  Param->Name="lfider";


  TWTQuery* ZQueryRes = new TWTQuery(this);
  ZQueryRes->Options.Clear();
  ZQueryRes->Options<< doQuickOpen;
  ZQueryRes->RequestLive=false;

  AnsiString ResName;
  sqlstr="select id,name from clm_client_tbl where id = syi_resid_fun();";
  ZQueryRes->Sql->Clear();
  ZQueryRes->Sql->Add(sqlstr);
  try
   {
    ZQueryRes->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQueryRes->Close();
    return;
   }
   if (ZQueryRes->RecordCount>0)
   {
    ZQueryRes->First();
    ResName=ZQueryRes->FieldByName("name")->AsString;
   }
  ZQueryRes->Close();

  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReport->ParamByName["lres"]->Value = ResName;

  if (DBGrDoc->Query->Filtered==true)
  {
     xlReport->ParamByName["lperiod"]->Value = FormatDateTime("dd.mm.yyyy",DateFrom)+" - "+
     FormatDateTime("dd.mm.yyyy",DateTo);
  }
  else
     xlReport->ParamByName["lperiod"]->Value ="";

  if(id_fider !=0)
  {
     xlReport->ParamByName["lfider"]->Value =fidername;
  }

  xlReport->Report();

  delete xlReport;
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void __fastcall TMainForm::ShowFiderWorksList(TObject *Sender)
{
  TWinControl *Owner = NULL;
  /*
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild("Журнал налоговых накладных", Owner)) {
    return;
  }
  */
  TfMonitorFiderWorks * fMonitorFiderWorks=new TfMonitorFiderWorks(this);

  fMonitorFiderWorks->ShowAs("Журнал тех. работ");

  fMonitorFiderWorks->ID="Журнал тех. работ";

  fMonitorFiderWorks->ShowData();

}
//----------------------------------------------------------

