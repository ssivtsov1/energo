//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"

#include "ParamsForm.h"

#include "fDemLimit.h"
#include "SysUser.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;


//----------------------------------------------------------------------
//--------------------------- Лимиты потребления ----------------
//----------------------------------------------------------------------
__fastcall TfDemandLimit::TfDemandLimit(TComponent* AOwner,TDataSet* ZQAbonList) : TWTDoc(AOwner)
{

    int ChLevel =CheckLevel("Табл. Лимиты потребления");

  id_client = ZQAbonList->FieldByName("id")->AsInteger;

 // получим иекущий рабочий период
  TWTQuery * ZQuery = new TWTQuery(Application);
  ZQuery->Options<< doQuickOpen;

  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

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
  mmgg = ZQuery->FieldByName("mmgg")->AsDateTime;

  ZQuery->Close();

  //---------------------------проверить что триггеры на  месте -----------------
  bool is_trigger=false;

  sqlstr="select position('8.2' in version()) as is8,position('9.3' in version())+position('9.4' in version())+position('9.5' in version()) as is9 ;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

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
  AnsiString sql1;
  AnsiString sql2;

  if (ZQuery->FieldByName("is8")->AsInteger > 0)
  {
    sql1 ="select  CASE WHEN reltriggers <3 THEN false ELSE true END as relhastriggers from  pg_class  WHERE relname = 'acd_demandlimit_tbl';";
    sql2 ="select  CASE WHEN reltriggers <2 THEN false ELSE true END as relhastriggers  from  pg_class  WHERE relname = 'acm_headdemandlimit_tbl';";
  }

  if (ZQuery->FieldByName("is9")->AsInteger > 0)
  {
    sql1 ="select  relhastriggers  from  pg_class  WHERE relname = 'acd_demandlimit_tbl';";
    sql2 ="select  relhastriggers  from  pg_class  WHERE relname = 'acm_headdemandlimit_tbl';";
  }
  ZQuery->Close();

  sqlstr=sql1;
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

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

   is_trigger = ZQuery->FieldByName("relhastriggers")->AsBoolean;

  ZQuery->Close();

  if ( !is_trigger  )
  {
   ShowMessage("Таблици лимитов в состоянии 'только для чтения'. \n Необходимо прокатать последнее обновление базы!");
   ChLevel =1;
  }
  else
  {
   sqlstr=sql2;
   ZQuery->Sql->Clear();
   ZQuery->Sql->Add(sqlstr);

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

   is_trigger = ZQuery->FieldByName("relhastriggers")->AsBoolean;

   ZQuery->Close();

   if ( !is_trigger )
   {
    ShowMessage("Таблици лимитов в состоянии 'только для чтения'. \n Необходимо прокатать последнее обновление базы!");
    ChLevel =1;    
   }
  }
//------------------------------------------------------------------------------------------


  TWTPanel* PTax=MainPanel->InsertPanel(100,true,MainForm->Height/4);

  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;


   Query2->Sql->Clear();
   Query2->Sql->Add("select hl.*  from acm_headdemandlimit_tbl as hl " );
   Query2->Sql->Add("where hl.id_client = :client order by hl.mmgg desc,hl.reg_num,hl.reg_num; " );

   Query2->ParamByName("client")->AsInteger = id_client;

   DBGrDoc=new TWTDBGrid(PTax, Query2);

   qDocList = DBGrDoc->Query;

   DBGrDoc->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrDoc, true)->ID="DemLimitH";

   TWTQuery* QuerDci=new TWTQuery(this);
   QuerDci->Sql->Add(" select name,id from dci_document_tbl where idk_document = 600 order by id; " );
   QuerDci->Open();

   qDocList->AddLookupField("Namek_doc","idk_document",QuerDci,"name","id");

  qDocList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
  NList->Add("dt");
  NList->Add("id_person");
  NList->Add("mmgg");
  NList->Add("flock");
 // NList->Add("Namek_doc");

  qDocList->SetSQLModify("acm_headdemandlimit_tbl",WList,NList,true,true,true);
 // TDataSetNotifyEvent OldInsert =
  /////////////////////////qDocList->AfterInsert=  NewDocInsert;
  qDocList->OnNewRecord =  NewDocInsert;
  qDocList->OnApplyUpdateError=NewStrError;

  TWTField *Fieldh;


  Fieldh = DBGrDoc->AddColumn("reg_num", "Номер документа", "Номер документа");
   Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("reg_date", "Дата док.", "Дата документа");
   Fieldh->SetWidth(100);

   Fieldh = DBGrDoc->AddColumn("Namek_doc", "Тип документа", "Тип");
  Fieldh->SetWidth(120);



  Fieldh = DBGrDoc->AddColumn("mmgg", "Месяц", "Месяц");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);

   Fieldh = DBGrDoc->AddColumn("flock", "Зак.", "Закрыт");
  Fieldh->AddFixedVariable("1", "^");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(20);

  if  (ChLevel==1) {
     DBGrDoc->ReadOnly=true;
     DBGrDoc->ToolBar->Enabled=false;
   };

  DBGrDoc->Visible=true;


//----------------------------------------------------------------------------

  TWTPanel* PTaxLines=MainPanel->InsertPanel(300,true,MainForm->Height/4*3);

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options << doQuickOpen;

   Query3->Sql->Clear();
   Query3->Sql->Add("select l.*,coalesce(aaa.name_eqp,'') as area_sort_name from acd_demandlimit_tbl as l \
   left join \
   ( select distinct eq.id,eq.name_eqp from eqm_area_h as a join \
                   (select  id, name_eqp from eqm_equipment_h where dt_e is null and type_eqp = 11 ) as eq \
                    on (eq.id = a.code_eqp) \
                    where a.id_client = :client and a.dt_e is null order by eq.id \
   ) as aaa on (aaa.id = l.id_area) \
   where id_client = :client order by id_doc,area_sort_name,month_limit;" );

   Query3->ParamByName("client")->AsInteger = id_client;

   //Query3->AutoRefresh = true;
   //Query3->Open();
   //Query3->Close();

   //Query3->GetTField("max_dem")->Field->AutoGenerateValue = Db::arAutoInc ;

   DBGrDocLines=new TWTDBGrid(PTaxLines, Query3);

   qDocLines = DBGrDocLines->Query;

   //qDocLines->GetTField("max_dem")->Field->AutoGenerateValue = Db::arAutoInc ;

   DBGrDocLines->SetReadOnly(false);
   PTaxLines->Params->AddGrid(DBGrDocLines, true)->ID="DocLines";

   TWTToolButton* btn2=DBGrDocLines->ToolBar->AddButton("AddCond", "Заполнить", AutoFill);

   TWTQuery* QueryAreas=new TWTQuery(this);
   QueryAreas->Sql->Add("   select distinct eq.id,eq.name_eqp, (eq.name_eqp||coalesce(' ('||adr.adr||')',''))::::varchar as name \
                    from eqm_area_h as a join \
                   (select  id, name_eqp,id_addres from eqm_equipment_h where dt_e is null and type_eqp = 11 ) as eq \
                    on (eq.id = a.code_eqp) \
                    left join adv_address_tbl as adr on (adr.id = eq.id_addres) \
                    where a.id_client = :client  and a.dt_e is null order by eq.name_eqp ; ");

   QueryAreas->ParamByName("client")->AsInteger = id_client;
   QueryAreas->Open();
   qDocLines->AddLookupField("name_area","id_area",QueryAreas,"name","id");


//   DBGrDocLines->SetReadOnly(true);
  qDocLines->Open();

  WList=new TStringList();
  WList->Add("id");

  NList=new TStringList();
  NList->Add("mmgg");
  NList->Add("dt");
  NList->Add("flock");
  NList->Add("id_person");
  NList->Add("area_sort_name");
  NList->Add("max_dem");


  qDocLines->SetSQLModify("acd_demandlimit_tbl",WList,NList,true,true,true);
  qDocLines->OnNewRecord=NewStrInsert;
  qDocLines->OnApplyUpdateError=NewStrError;
  DBGrDocLines->AfterPost=LineAfterPost;

//  ((TZPgSqlQuery *)qDocLines)->OnPostError=NewStrError;



  qDocLines->LinkFields = "id_doc=id_doc";
  qDocLines->MasterSource = DBGrDoc->DataSource;

  qDocLines->IndexFieldNames = "id_doc;area_sort_name; month_limit";
 // TWTField *Fieldh;
//   Fieldh = DBGrDocLines->AddColumn("dt_bill", "Дата", "");

//  Fieldh = DBGrDocLines->AddColumn("text", "Товар", "");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrDocLines->AddColumn("month_limit", "Период", "");
  Fieldh = DBGrDocLines->AddColumn("name_area", "Площадка", "");
  Fieldh->OnChange=OnChangeArea;

  Fieldh = DBGrDocLines->AddColumn("value_dem", "Лимит", "  ");
  Fieldh->Precision=0;

  Fieldh = DBGrDocLines->AddColumn("night_day", "Время суток", "");
  Fieldh->AddFixedVariable("1", "Утро");
  Fieldh->AddFixedVariable("2", "Вечер");
  Fieldh->SetDefValue("1");
  Fieldh->SetWidth(70);

  Fieldh = DBGrDocLines->AddColumn("max_dem", "Макс.лимит площадки", "");
  Fieldh->Precision=0;
//  Fieldh->Field->AutoGenerateValue = Db::arAutoInc ;
//  Fieldh->SetWidth(20);
  Fieldh->SetReadOnly();

  Fieldh = DBGrDocLines->AddColumn("dt", "Дата занесения", "");
  Fieldh->SetReadOnly();

  //QueryI->IndexFieldNames = "id_doc;num_eqp;kind_energy;id_zone";

   TWTToolBar* tb=DBGrDocLines->ToolBar;
  TWTToolButton* btn;
  /*for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
      if ( btn->ID=="NewRecord")
            tb->Buttons[i]->OnClick=LimitIns;
     };
    */
   if  (ChLevel==1) {
     DBGrDocLines->ReadOnly=true;
     DBGrDocLines->ToolBar->Enabled=false;
   };
  DBGrDocLines->Visible=true;


//----------------------------------------------------------------------------
  SetCaption("Лимиты по абоненту "+ ZQAbonList->FieldByName("short_name")->AsString);

 };

//---------------------------------------------------------------------------
void __fastcall TfDemandLimit::LimitIns(TObject *Sender)
{    TWTDoc *TDoc;
  TDoc=(( TWTDoc *)(((TWinControl *)Sender)->Parent->Parent->Parent));
  TWTPanel *MPanel= ( TWTPanel *)TDoc->MainPanel;
  TWTDBGrid *GrPay= ((TWTDBGrid *)MPanel->ParamByID("DocLines")->Control);
  TWTDBGrid *GrHeadPay= ((TWTDBGrid *)MPanel->ParamByID("DemLimitH")->Control);
  if (GrHeadPay->Query->FieldByName("flock")->AsInteger==1)
  {    ShowMessage("Запрещено добавлять в закрытый период!");
       return;
  };
};
//---------------------------------------------------------------------------
void __fastcall TfDemandLimit::LineAfterPost(TWTDBGrid *Sender)
{
//   Sender->Refresh();
}
//--------------------------------------------------------------------
void _fastcall  TfDemandLimit::OnChangeArea(TWTField *Sender)
{
  if (Sender->Field->IsNull) return;
  if (Sender->Field->FieldName != "NAME_AREA") return;

  int id_area = qDocLines->FieldByName("id_area")->AsInteger;
  if (id_area==0) return;

  TWTQuery * Query2=new TWTQuery(this);
     Query2->Sql->Clear();
   Query2->Sql->Add("select round(coalesce(varea.power,0)*coalesce(varea.wtm,0)*coalesce(vstatecl.period_indicat,1),0) as max_limit \
    from eqm_ground_tbl as varea, clm_statecl_tbl as vstatecl where varea.code_eqp = :area \
    and vstatecl.id_client = :client ; " );

   Query2->ParamByName("area")->AsInteger = id_area;
   Query2->ParamByName("client")->AsInteger = id_client;
   Query2->Open();

   int max_lim =Query2->FieldByName("max_limit")->AsInteger;
   Query2->Close();

   if(qDocLines->FieldByName("max_dem")->AsInteger !=max_lim)
      qDocLines->FieldByName("max_dem")->AsInteger =max_lim;

}
//--------------------------------------------------------------------
void __fastcall TfDemandLimit::NewStrInsert(TDataSet* DataSet)
{  TWTQuery * Query2=new TWTQuery(this);
     Query2->Sql->Clear();
   Query2->Sql->Add("select hl.*  from acm_headdemandlimit_tbl as hl " );
   Query2->Sql->Add("where hl.id_doc = :doc  " );

   Query2->ParamByName("doc")->AsInteger = qDocList->FieldByName("id_doc")->AsInteger;
   Query2->Open();
  if (Query2->FieldByName("flock")->AsInteger==1)
  {    ShowMessage("Запрещено добавлять в закрытый период!");
       DataSet->Cancel();
       return;
  };
 DataSet->FieldByName("id_doc")->AsInteger = qDocList->FieldByName("id_doc")->AsInteger;
 DataSet->FieldByName("mmgg")->AsDateTime = qDocList->FieldByName("mmgg")->AsDateTime;
 DataSet->FieldByName("id_client")->AsInteger=id_client;
 DataSet->FieldByName("night_day")->AsInteger = 1;
}
//----------------------------------------------------------------------
void __fastcall TfDemandLimit::NewDocInsert(TDataSet* DataSet)
{
 DataSet->FieldByName("reg_date")->AsDateTime=Date();
 DataSet->FieldByName("mmgg")->AsDateTime = mmgg;
 DataSet->FieldByName("id_client")->AsInteger=id_client;
 DataSet->FieldByName("idk_document")->AsInteger=600;
// DataSet->FieldByName("night_day")->AsInteger = 1;
}
//---------------------------------------------------------------------------
void __fastcall TfDemandLimit::AutoFill(TObject *Sender)
{
  if (qDocList->FieldByName("flock")->AsInteger==1)
  {    ShowMessage("Запрещено добавлять в закрытый период!");
       return;
  };

  int r = MessageDlg("Заполнить строки до конца года?", mtConfirmation, TMsgDlgButtons() << mbYes <<mbCancel, 0);
  if ( r==mrCancel ) return;

 TWTQuery * Query2=new TWTQuery(this);


 Word year;
 Word month;
 Word day;

  Query2->Sql->Clear();
  Query2->Sql->Add("select * from acd_demandlimit_tbl as l " );
  Query2->Sql->Add("where l.id_doc = :doc order by month_limit desc" );

  Query2->ParamByName("doc")->AsInteger = qDocList->FieldByName("id_doc")->AsInteger;
  Query2->Open();

  TDateTime cur_month;
  TDateTime start_month;
  TDateTime end_month;

  if (Query2->RecordCount == 0 )
  {
    DecodeDate(qDocList->FieldByName("mmgg")->AsDateTime,year,month,day);
    if (month>=9) year=year+1;

    start_month = EncodeDate(year,1,1);
  }
  else
  {
    DecodeDate(Query2->FieldByName("month_limit")->AsDateTime,year,month,day);

    if(month==12) return;

    start_month = EncodeDate(year,month+1,1);
  }

  end_month =EncodeDate(year,12,1);

  Query2->Close();
  Query2->Sql->Clear();
  Query2->Sql->Add("INSERT INTO acd_demandlimit_tbl( month_limit, id_doc, id_client, id_area, night_day) \
    VALUES (:month, :doc, :client, :area, 1); " );

  Query2->ParamByName("doc")->AsInteger = qDocList->FieldByName("id_doc")->AsInteger;
  Query2->ParamByName("client")->AsInteger = id_client;


  TWTQuery* QueryAreas=new TWTQuery(this);
  QueryAreas->Sql->Add("   select distinct eq.id,eq.name_eqp as name from eqm_area_tbl as a join \
                   (select id, name_eqp from eqm_equipment_tbl where type_eqp = 11 order by id) as eq \
                    on (eq.id = a.code_eqp) \
                    join eqm_compens_station_inst_tbl as i on (i.code_eqp_inst = eq.id) \
                    where a.id_client = :client order by eq.name_eqp, eq.id ; ");

  QueryAreas->ParamByName("client")->AsInteger = id_client;
  QueryAreas->Open();
  QueryAreas->First();
  for (int i=0; i<QueryAreas->RecordCount;i++)
  {
    cur_month = start_month;
    while (cur_month<=end_month)
    {
     Query2->ParamByName("month")->AsDateTime =cur_month;
     Query2->ParamByName("area")->AsInteger = QueryAreas->FieldByName("id")->AsInteger;
     Query2->ExecSql();

     cur_month = IncMonth(cur_month,1);
    }
    QueryAreas->Next();
  }

  QueryAreas->Close();

  qDocLines->Refresh();
//  Sleep(100);
//  qDocLines->Refresh();


}
//----------------------------------------------------------------------

void __fastcall TfDemandLimit::ShowData(void)
{

 MainPanel->ParamByID("DemLimitH")->Control->SetFocus();
 MainPanel->ParamByID("DocLines")->Control->SetFocus();
 MainPanel->ParamByID("DemLimitH")->Control->SetFocus();
};
//------------------------------------------------------

void __fastcall TfDemandLimit::NewStrError (TDataSet* DataSet, EDatabaseError* E, TDataAction &Action)
{
    ShowMessage(" "+E->Message.SubString(8,200)  );
//    E->Message = "";
//    qDocLines->Cancel();
//    Action=daAbort;
//    qDocLines->CancelUpdates();
//    DatabaseError("",qDocLines);
}
//----------------------------------------------------------------------
//--------------------------------------------------

void __fastcall TMainForm::ShowLimitList(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild("Лимиты потребления", Owner)) {
    return;
  }
    int ChLevel =CheckLevel("Табл. Лимиты потребления");
  if  (ChLevel==0) {
     return;
   };
  TWTPanel *TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);

  TfDemandLimit* fLimitList=new TfDemandLimit(this,GrClient->DataSource->DataSet);

  fLimitList->ShowAs("Лимиты потребления");
 // fTaxListFull->SetCaption("Журнал налоговых накладных");

  fLimitList->ID="Лимиты потребления";

  fLimitList->ShowData();

}
//----------------------------------------------------------

