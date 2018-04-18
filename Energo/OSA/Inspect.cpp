//---------------------------------------------------------------------------
//#include <vcl.h>
#include <vcl.h>
#pragma hdrstop
#include "RepInspect.h"
#include "Inspect.h"
#include "Main.h"
#include "fDemandPrint.h"
#include "fBillPrint.h"
#include "CliPowerIndic.h"
#include "fPeriodSel.h"
#define WinName "Отчеты по потреблению"

_fastcall TfInspect::TfInspect(TWinControl *owner)  : TWTDoc(owner)
{


    //TWinControl *Owner = Owner;
/* if ( TMainForm->ShowMDIChild(WinName, Owner)) {
    return ;
  } */
   TWTPanel* PHIndic=MainPanel->InsertPanel(200,true,200);
   TFont *F;
   F=new TFont();
   F ->Size=10;
   F->Style=F->Style << fsBold;
   F->Color=clBlue;

 // получим иекущий рабочий период
  TWTQuery * ZQuery = new TWTQuery(Application);
//  ZQuery->Options<< doQuickOpen;

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


   QuerH=new TWTQuery(this);
   QuerH->Sql->Add("select id_doc,reg_num,reg_date,id_position,id_fider,comment,mmgg,flock \
    from acm_inspecth_tbl h  order by h.reg_date desc ");

    DBGrHInd=new TWTDBGrid(this, QuerH);
    PHIndic->Params->AddGrid(DBGrHInd, true)->ID="HIndic";
    TWTQuery * Query = DBGrHInd->Query;

    TWTQuery *QuerPos=new TWTQuery(this);
    QuerPos->Sql->Add(" \
    select p.id,p.id_position,(pn.name||'  '|| p.represent_name)::::varchar as represent_name from clm_position_tbl p, cli_position_tbl pn\
       where p.id_position=pn.id and p.id_client= (select value_ident from syi_sysvars_tbl where ident='id_res')::::int");
    QuerPos->Open();
    Query->AddLookupField("inspect","id_position",QuerPos,"represent_name","id");

    QuerFid=new TWTQuery(this);
    QuerFid->Sql->Add("select * from eqm_equipment_tbl as eq join eqm_fider_tbl as f on (f.code_eqp = eq.id) where type_eqp=15 order by name_eqp");
    QuerFid->Open();

    Query->AddLookupField("fider","id_fider",QuerFid,"name_eqp","id");

 //   Query->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";

    Query->DefaultFilter="date_trunc('month',reg_date) = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";

    Query->Filtered=true;
    Query->Open();

    Query->BeforeInsert = DataSetBeforeInsert;
    Query->BeforeEdit   = DataSetBeforeUpdate;

  TStringList *WList=new TStringList();
  WList->Add("id_doc");


  TStringList *NList=new TStringList();
  // NList->Add("inspect");

  Query->SetSQLModify("acm_inspecth_tbl",WList,NList,true,true,true);
  TWTField *Fieldh;

  Fieldh = DBGrHInd->AddColumn("reg_num", "Номер отчета", "Номер отчета");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("reg_date", "Дата отчета", "Дата отчета");
   Fieldh->SetWidth(100);


   Fieldh = DBGrHInd->AddColumn("inspect", "Инспектор", "Инспектор");

   Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClientPositionResSpr);
   Fieldh->SetWidth(150);

   Fieldh = DBGrHInd->AddColumn("fider", "Фидер", "Фидер");
   Fieldh->SetWidth(150);
   Fieldh->OnChange=OnChangeFider;

   Fieldh = DBGrHInd->AddColumn("comment", "Примечание", "Примечание");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("mmgg", "Месяц", "Месяц");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);

  Fieldh = DBGrHInd->AddColumn("flock", "Зак.", "Закрыт");
  Fieldh->AddFixedVariable("1", "^");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(20);


  // DBGrHInd->BeforePost=CheckIndic;
  DBGrHInd->AfterPost=IndicAddNew;
 // DBGrHInd->AfterInsert=IndicAddCl;
 /*
  TButton *BtnCalc=new TButton(this);
  BtnCalc->Caption="Расчет";
  BtnCalc->OnClick=ClientCalcPotr;
  BtnCalc->Width=100;
  BtnCalc->Top=2;
  BtnCalc->Left=2;
   */
  TButton *BtnPrn=new TButton(this);
  BtnPrn->Caption="Печать задания на обход";
  BtnPrn->OnClick=ClientBillPrintP;
  BtnPrn->Width=200;
  BtnPrn->Top=2;
  BtnPrn->Left=2;


  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=102;
  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnPrn,false)->ID="BtnPrn";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";
  TWTPanel* PIndicGr=MainPanel->InsertPanel(200,true,200);

  QuerI=new TWTQuery(this);
  /*
  QuerI->Sql->Add(" \
         select  i.id,i.id_doc,i.id_client,cl.code,cl.short_name as name_client, scl.doc_num,  \
       i.id_point,ep.name_eqp as name_point, i.id_meter,i.num_eqp, \
                i.id_address,ad.adr,                                \
             i.type_eqp,i.carry,i.kind_energy,                      \
             i.zone,i.value,i.value_dev,i.dt_insp,i.koef,i.id_previndic,ii.value as before_indic,ii.dat_ind,ii.value_dem    \
             from acm_inspectstr_tbl i left join                    \
             (select id,adr from adv_address_tbl  order by id) ad  on  i.id_address=ad.id \
              left  join ( select  i.id,i.value,i.value_dem,i.dat_ind from  acd_indication_tbl i where mmgg>='2007-01-01' order by id) as ii \
                   on (ii.id=i.id_previndic )    \
                       ,  clm_client_tbl cl join clm_statecl_tbl as scl on (scl.id_client = cl.id),                                        \
                  (select distinct id,name_eqp from \
                       ( select h.* from eqm_equipment_h as h           \
                         where dt_b=(select max(dt_b) from eqm_equipment_h hh where hh.id=h.id) \
                               and type_eqp=12 order by id ) as h2                                    \
                       ) as ep    \
                 where i.id_point=ep.id and i.id_client=cl.id \
                order by i.id_doc,i.id_client,i.num_eqp;    ");
*/

  QuerI->Sql->Add(" \
         select  i.id,i.id_doc,i.id_client,cl.code,cl.short_name as name_client, scl.doc_num,  \
       i.id_point,ep.name_eqp as name_point, i.id_meter,i.num_eqp, \
             i.type_eqp,i.carry,i.kind_energy,i.dt,                     \
             i.zone,i.value,i.value_dev,i.dt_insp,i.koef,i.id_previndic,ii.value as before_indic,ii.dat_ind,i.value_dem, i.mmgg , h.reg_date   \
             from (select * from acm_inspectstr_tbl  order by id_previndic ) as i                    \
             join acm_inspecth_tbl as h on (h.id_doc = i.id_doc ) \
            join  clm_client_tbl cl on ( i.id_client=cl.id ) \
            join clm_statecl_tbl as scl on (scl.id_client = cl.id)                                        \
            join ( select h.* from eqm_equipment_h as h \
                   join (select id, max(dt_b) as maxdtb from eqm_equipment_h hh where type_eqp=12 group by id order by id ) as h2 \
                   on (h.id = h2.id and h.dt_b = h2.maxdtb )  order by id \
                  ) as ep on (i.id_point=ep.id) \
            left  join ( select  i.id,i.value,i.value_dem,i.dat_ind from  acd_indication_tbl i where mmgg>='2009-01-01' order by id) as ii \
             on (ii.id=i.id_previndic )    \
            order by i.id_doc,i.id_client,i.num_eqp   ");

  DBGrInd=new TWTDBGrid(this, QuerI);

  PIndicGr->Params->AddText("Показания оборудования ",18,F,Classes::taCenter,false);
  PIndicGr->Params->AddGrid(DBGrInd, true)->ID="Indic";


  TWTQuery* QueryI = DBGrInd->Query;
  QueryI->AddLookupField("type_met","type_eqp","eqi_meter_tbl","type","id");
  QueryI->AddLookupField("name_energy","KIND_ENERGY","eqk_energy_tbl","name","id");
  QueryI->AddLookupField("iZone","ZONE","eqk_zone_tbl","name","id"); // Потом Name

//   QueryI->DefaultFilter="i.mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   QueryI->DefaultFilter="date_trunc('month',reg_date) = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   QueryI->Filtered=true;
//   QueryI->MacroByName("whr")->AsString ="where mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";

   QueryI->Open();

  TStringList *WListI=new TStringList();

  WListI->Add("id");

  TStringList *NListI=new TStringList();
//  NListI->Add("adr");
      NListI->Add("code");
    NListI->Add("name_client");
  NListI->Add("name_point");
    NListI->Add("before_indic");
      NListI->Add("dat_ind");
        NListI->Add("doc_num");
          NListI->Add("reg_date");


  QueryI->SetSQLModify("acm_inspectstr_tbl",WListI,NListI,true,true,true);

  QueryI->IndexFieldNames = "id_doc;id_client;num_eqp;kind_energy;zone";
  QueryI->LinkFields = "id_doc=id_doc";
  QueryI->MasterSource = DBGrHInd->DataSource;

  TWTField *Field;


  Field = DBGrInd->AddColumn("code", "Лиц.", "Лицевой");
   Field->SetWidth(50);
   Field->SetReadOnly();

   Field = DBGrInd->AddColumn("name_client", "Клиент", "Клиент");
   Field->SetReadOnly();

   Field = DBGrInd->AddColumn("doc_num", "Договор", "Договор");
   Field->SetReadOnly();
   Field->SetWidth(50);

  Field = DBGrInd->AddColumn("name_point", "Учет", "Учет");
  Field->SetReadOnly();
  Field->SetWidth(120);

  Field = DBGrInd->AddColumn("num_eqp", "Номер", "Номер");
  Field->SetWidth(80);

   Field = DBGrInd->AddColumn("type_met", "Тип", "Тип");
   Field->SetReadOnly();
   Field->SetWidth(120);

   Field = DBGrInd->AddColumn("carry", "Разр.", "Разрядность");
   Field->SetWidth(50);
   Field->SetReadOnly();


  Field = DBGrInd->AddColumn("name_energy", "Енергия", "Вид енергии");
  Field->SetWidth(80);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("iZone", "Зона", "Зона");
    Field->SetWidth(50);
  Field->SetReadOnly();


     Field = DBGrInd->AddColumn("dat_ind", "Дата пред", "Дата пред");
  Field->Column->ButtonStyle=cbsNone;

  Field = DBGrInd->AddColumn("before_indic", "Пред.показания", "Предыдущие показания");
  Field->Column->ButtonStyle=cbsNone;
  Field->SetReadOnly();

    Field = DBGrInd->AddColumn("dt_insp", "Дата контроль", "Дата контроль");
  Field->Column->ButtonStyle=cbsNone;
 // Field->SetReadOnly();

 //
  Field = DBGrInd->AddColumn("value", "Контрольные", "Зафиксированые показания");
  Field->OnChange=OnChangeIndic;
 // Field->Precision=4;

  Field = DBGrInd->AddColumn("value_dev", "Разность", "Разность");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("koef", "Коеф.транс", "");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("value_dem", "Потребление", "Потребление");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("dt", "Дата изменения", "Дата изменения");
  Field->SetReadOnly();

  DBGrInd->Visible = true;
  DBGrInd->Visible = true;
 // DBGrHInd->OnDrawColumnCell=HIndDrawColumnCell;
 // DBGrInd->OnDrawColumnCell= HeadDrawColumnCell;

  TWTToolBar* tb=DBGrHInd->ToolBar;
  TWTToolButton* btAll=tb->AddButton("dateinterval", "Выбор периода", PeriodSel);

  SetCaption("Отчеты контролера ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

  ShowAs(WinName);
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
  MainPanel->ParamByID("Indic")->Control->SetFocus();
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
 }
#undef WinName
//--------------------------------------------------------------------------
__fastcall TfInspect::~TfInspect()
{
  Close();
};
//--------------------------------------------------------------------------
void __fastcall TfInspect::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;

    fPeriodSelect->FormShow(mmgg,mmgg);

    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };


   if (rez == mrOk)
   {
//     QuerI->Close();
//     QuerH->Close();

     QuerH->DefaultFilter="reg_date >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and reg_date <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     QuerH->Filtered=true;

     QuerI->DefaultFilter="reg_date >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and reg_date <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     QuerI->Filtered=true;

//     QuerH->Refresh();
//     QuerI->Refresh();

     SetCaption("Отчеты контролера ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
/*
   else
   {
     //qTaxList->Filtered=false;
     qTaxList->DefaultFilter="";
     qTaxList->Refresh();
     qTaxLines->DefaultFilter="";
     qTaxLines->Refresh();
     SetCaption("Налоговые накладные ");
   }
*/
//    delete fPeriodSelect;
//    ReBuildGrid();
};

//----------------------------------------------------------------------------
void _fastcall TfInspect::IndicAddNew(TWTDBGrid *Sender) {
  int i=0;
  int id_clientp=0;
  Word yearr;
  Word yearp;
  Word monthr;
  Word monthp;
  Word dayr;
  Word dayp;
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndic= Sender;
  TWTDBGrid *GrDetIndic= DBGrInd;

  /// вставляем заголовок
   int id_docp=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
       TDateTime reg_date=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;

    DecodeDate(reg_date,yearr,monthr,dayr);
   if ((yearr>2099)||(yearr<2006))
  { ShowMessage("Некорректный год в дате отчета! Проверьте!");
     return;
  };

   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select add_inspectindic("+ToStrSQL(id_docp)+") ");
   QueryMet->ExecSql();
   //GrDetIndic->DataSource->DataSet->FieldByName("before_value")->LookupDataSet->Refresh();
   GrDetIndic->DataSource->DataSet->Refresh();
   GrDetIndic->Refresh();

};

void _fastcall TfInspect::CheckIndic(TWTDBGrid *Sender)
{
  int i=0;
  int fid_doc=0;
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndic= Sender;
  /// вставляем заголовок
   fid_doc=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   TDateTime reg_datep=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
   QueryMet->Sql->Clear();
    QueryMet->Sql->Add("Select * from acm_inspectstr_tbl where \
          id_doc=:pid_doc ");
      QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
      QueryMet->Open();
       if (!(QueryMet->Eof))
       {   if  (Sender->DataSource->DataSet->FieldByName("dt_insp")->AsDateTime!=
         QueryMet->FieldByName("reg_date")->AsDateTime)
           { if (!Ask("Вы изменили дату съема показаний. Изменить в строках контрольных обходов. Продолжить ?"))
                   Sender->DataSource->DataSet->Cancel();
             else
              { QueryMet->Sql->Clear();
              QueryMet->Sql->Add("update acm_inspectstr_tbl set dt_insp= : pdat where \
                   id_doc=:pid_doc ");
               QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
               QueryMet->ParamByName("pdat")->AsDateTime=QueryMet->FieldByName("reg_date")->AsDateTime;
               QueryMet->ExecSql();

           };
           };
    };
};




void _fastcall   TfInspect::ClientBillPrintP(TObject *Sender)
{
      Application->CreateForm(__classid(TfRepInspect), &fRepInspect);
       fRepInspect->id_head= DBGrHInd->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
};


void _fastcall  TfInspect::OnChangeIndic(TWTField *Sender)
{
  TWTTable *Table = (TWTTable *)Sender->Field->DataSet;
  TWTQuery * QuerDat=new TWTQuery(this);
  QuerDat->Sql->Clear();
  int pind;
  int car,c_comp=1;
  bool c_ind=true;
  float prev_ind;
  prev_ind=0,00;
  try {
   pind=Table->FieldByName("id_previndic")->AsInteger;
    QuerDat->Sql->Add("select value from acd_indication_tbl where id="+ToStrSQL(pind));
    QuerDat->Open();
    prev_ind=Round(QuerDat->Fields->Fields[0]->AsFloat,4);
    AnsiString prev_char= QuerDat->Fields->Fields[0]->AsString;
    AnsiString next_char=Sender->Field->AsString;
    if (prev_char==next_char)  c_ind=false;
    }
    catch (...) {
       c_ind=false;
    };
    try {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry,koef from acm_inspectstr_tbl where id="+ToStrSQL(Table->FieldByName("id")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=QuerDat->Fields->Fields[1]->AsFloat;
   if (car==0){
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("type_eqp")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   };
     }
  catch (...) {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("type_eqp")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=1;
  };

  if (c_ind){
   TWTQuery *QuerDev=new TWTQuery(this);
//   QuerDev->Options << doQuickOpen;
   QuerDev->Sql->Add("select calc_ind_pr(:eind,:bind,:car)");
   QuerDev->ParamByName("eind")->AsFloat=Round(Sender->Field->AsFloat,4);
   QuerDev->ParamByName("bind")->AsFloat=Round(prev_ind,4);
   QuerDev->ParamByName("car")->AsInteger=car;
   QuerDev->Open();
   if (!QuerDev->Fields->Fields[0]->AsString.IsEmpty())
   {     Table->FieldByName("value_dev")->AsFloat=Round(QuerDev->Fields->Fields[0]->AsFloat,4);
    if ( c_comp!=0)
    Table->FieldByName("value_dem")->AsFloat=Round(Round(QuerDev->Fields->Fields[0]->AsFloat,4)*c_comp,0);
    else
    Table->FieldByName("value_dem")->AsFloat=Round(QuerDev->Fields->Fields[0]->AsFloat,0);
   }
   else
   {  ShowMessage("Ошибка вычисления потребления! Проверте разрядность!");
     return;
   };
  }
  else
  { //Table->FieldByName("value_dem")->AsFloat=0;
    Table->FieldByName("value_dev")->AsFloat=0;
  };

   return;

}

void __fastcall  TfInspect::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}


void __fastcall TfInspect::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   float t_ind;
    float p_ind;


 TDBGrid* t=(TDBGrid*)Sender;
 t_ind =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 p_ind =t->DataSource->DataSet->FieldByName("before_value")->AsFloat;
  if ( (p_ind>t_ind)  )
   {  if (t_ind!=0)
      { t->Canvas->Brush->Color=0x00caffff;
   // t->Canvas->Brush->Color=0x000affff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
       };
   };

}

void __fastcall TfInspect::HIndDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{  TDateTime reg_date;
   TDateTime date_end;


 TDBGrid* t=(TDBGrid*)Sender;
 reg_date =t->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
 date_end =t->DataSource->DataSet->FieldByName("Date_End")->AsDateTime;

  if ( (reg_date<date_end)  )
   {        { t->Canvas->Brush->Color=0x00caffff;
        t->Canvas->Font->Size=8;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
       };
   };

}

// *********************************************

void __fastcall TfInspect::DataSetBeforeUpdate(TDataSet *DataSet)
{
  old_fider=DataSet->FieldByName("id_fider")->AsInteger;
}
//------------------------------------------------------------------------------

void __fastcall TfInspect::DataSetBeforeInsert(TDataSet *DataSet)
{
  old_fider=-1;
}
//------------------------------------------------------------------------------

void _fastcall  TfInspect::OnChangeFider(TWTField *Sender)
{
  TWTTable *Table = (TWTTable *)Sender->Field->DataSet;

  if(!(Sender->Field->IsNull))
  {
    if (Sender->Field->AsString !="0" )
    {
      if (Table->FieldByName("id_fider")->AsInteger!=old_fider)
      {
        old_fider = Table->FieldByName("id_fider")->AsInteger;
        if(!(QuerFid->FieldByName("id_position")->IsNull))
        {
          Table->FieldByName("id_position")->AsInteger=QuerFid->FieldByName("id_position")->AsInteger;
        }
      }
    }
  }

}
//------------------------------------------------------------------------------

void _fastcall TfInspect::ClientPowerIndic(TObject *Sender)
{    TWTPanel *TDoc;
    // Определяем владельца
  TWTQuery *QueryInd;
  QueryInd = new  TWTQuery(this);
//  QueryInd->Options << doQuickOpen;
  QueryInd->Sql->Clear();
  QueryInd->Sql->Add("select c.id as id_cl,c.short_name from clm_client_tbl c where " );
  QueryInd->Sql->Add("c.id=:pid_client " );
  QueryInd->ParamByName("pid_client")->AsInteger=fid_cl;
  QueryInd->Open();

  TfPowerInd *WGridPI;
  WGridPI = new TfPowerInd(Application->MainForm, QueryInd,fid_cl);

};
//----------------------------------------------------------------------------


void __fastcall TMainForm::ShowInspect(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild("Журнал счетов", Owner)) {
    return;
  }
  TfInspect * fInspect=new TfInspect(this);

  fInspect->ShowAs("Контрольные обходы");

 fInspect->ID="Контрольные обходы";

 // fInspect->->ShowData();
}
//-----------------------------------------------------------------------------
