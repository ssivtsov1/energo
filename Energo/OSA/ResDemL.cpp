//---------------------------------------------------------------------------

//#include <vcl.h>
#include <vcl.h>
#pragma hdrstop

#include "ResDemL.h"
#include "Main.h"
#include "fDemandPrint.h"
#include "fBillPrint.h"
#include "fTaxPrint.h"
#include "fTaxCorPrint.h"
#include "CliPowerIndic.h"
#include "fBillAct.h"
#include "fEdTaxParam.h"
#include "SysUser.h"
#define WinName "Отчеты по потреблению РЕС"

_fastcall TfResDem::TfResDem(TWinControl *owner, TWTQuery *Client, int fid_clien)  : TWTDoc(owner)
{
    //TWinControl *Owner = Owner;
/* if ( TMainForm->ShowMDIChild(WinName, Owner)) {
    return ;
  } */
   fid_cl=fid_clien;
    int lost=0;
    name_cl=Client->DataSource->DataSet->FieldByName("short_name")->AsString;

    TWTQuery* QuerC=new TWTQuery(this);

//    QuerC->Sql->Add("select c.*,s.flag_hlosts from clm_client_tbl c \
//     left join clm_statecl_tbl  s on (c.id=s.id_client ) where c.id=:pid_client");

    QuerC->Sql->Add("select c.* from clm_client_tbl as c where c.id=:pid_client");

    QuerC->ParamByName("pid_client")->AsInteger=fid_cl;
    QuerC->Open();
//    lost=QuerC->DataSource->DataSet->FieldByName("flag_hlosts")->AsInteger;
    name_cl=QuerC->DataSource->DataSet->FieldByName("short_name")->AsString;
    TWTPanel* PHIndic=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PHIndic->Params->AddText("Список отчетов "+ name_cl,18,F,Classes::taCenter,false);
    QuerH=new TWTQuery(this);

    QuerH->Sql->Add("select distinct h.*  from acm_headindication_tbl h where  h.id_client=:pid_client");
    QuerH->Sql->Add(" order by h.date_end desc");
    QuerH->ParamByName("pid_client")->AsInteger=fid_cl;

    DBGrHInd=new TWTDBGrid(this, QuerH);
    PHIndic->Params->AddGrid(DBGrHInd, true)->ID="HIndic";
    TWTQuery* Query = DBGrHInd->Query;
    TWTQuery* QuerRep=new TWTQuery(this);
    TWTQuery* QuerGrp=new TWTQuery(this);

    QuerRep->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
    QuerRep->Sql->Add(" where  di.idk_document=dk.id and dk.ident='rep_dem' order by di.id " );
    QuerRep->Open();
    Query->AddLookupField("Namek_doc","idk_document",QuerRep,"name","id");

    QuerGrp->Sql->Add("select * from eqm_equipment_tbl where type_eqp=15 or type_eqp=8 order by type_eqp, name_eqp");
    QuerGrp->Open();
    Query->AddLookupField("fider","id_grp",QuerGrp,"name_eqp","id");

    Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id_doc");

//   DBGrHInd->ToolBar->AddButton("INSPECT", "Детализация ошибок", ClientKontr);

  TStringList *NList=new TStringList();
//   NList->Add("nam_bill");
//   NList->Add("dt_bill");

  Query->SetSQLModify("acm_headindication_tbl",WList,NList,true,true,true);
  TWTField *Fieldh;
  Fieldh = DBGrHInd->AddColumn("Namek_doc", "Тип отчета", "Код");
  //Field->OnChange=OnChangeKindRep;
  Fieldh->SetWidth(120);

  Fieldh = DBGrHInd->AddColumn("reg_num", "Номер отчета", "Номер отчета");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("fider", "Фидер/КТП", "Фидер/КТП");
   Fieldh->SetWidth(120);


  Fieldh = DBGrHInd->AddColumn("reg_date", "Дата отчета", "Дата отчета");
   Fieldh->SetWidth(100);

  Fieldh = DBGrHInd->AddColumn("date_end", "Дт снятия показ.", "Дата по ");
  //Field->OnChange=OnChangeDateRep;
  Fieldh->SetWidth(100);

//  Fieldh = DBGrHInd->AddColumn("nam_bill", "Счет", "Счет");
//  Fieldh->SetWidth(180);

//  Fieldh = DBGrHInd->AddColumn("dt_bill", "Дата формирования", "Дата формирования");
//  Fieldh->SetWidth(120);

  Fieldh = DBGrHInd->AddColumn("mmgg", "Месяц", "Месяц");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);

  Fieldh = DBGrHInd->AddColumn("flock", "Зак.", "Закрыт");
  Fieldh->AddFixedVariable("1", "^");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(20);

  Fieldh = DBGrHInd->AddColumn("id_doc", "№ ", "№");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(80);


   DBGrHInd->BeforePost=CheckIndic;
  DBGrHInd->AfterPost=IndicAddNew;
  DBGrHInd->AfterInsert=IndicAddCl;

  TButton *BtnPrnDem=new TButton(this);
  BtnPrnDem->Caption="Печать показ.";
  BtnPrnDem->OnClick=ClientDemandPrintP;
  BtnPrnDem->Width=100;
  BtnPrnDem->Top=2;
  BtnPrnDem->Left=614;
  if (CheckLevel("Потребление - Печать показ. (кнопка)")==0)
      BtnPrnDem->Enabled=false;

  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=700;
  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  //TWTPanel* PBtnP=DocHInd->MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnPrnDem,false)->ID="BtnPrnDem";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";

  //TWTPanel* PIndicGr=DocHInd->MainPanel->InsertPanel(200,true,200);
  TWTPanel* PIndicGr=MainPanel->InsertPanel(200,true,200);

  QuerI=new TWTQuery(this);

  QuerI->Sql->Add(" \
  select distinct i.*,e.name_eqp as name_met,p.value as before_value \
     from (select  i.* from            \
           (select * from acm_headindication_tbl where id_client=:pid_client) as h  \
            join ( select  i.* from  acd_indication_tbl i where i.id_client=:pid_client order by id_doc) \
                  as i on (h.id_doc=i.id_doc)   \
           ) as i          \
           left join ( select  i.* from  acd_indication_tbl i where i.id_client=:pid_client order by id) as p \
                   on (p.id=i.id_previndic )    \
           left join eqm_equipment_h  e \
                  on (i.id_meter=e.id and i.num_eqp=e.num_eqp and i.dat_ind>=e.dt_b \
                         and (i.dat_ind<=e.dt_e or e.dt_e is null ) )      \
   order by i.id_doc,i.num_eqp,i.kind_energy,i.id_zone;");


  QuerI->ParamByName("pid_client")->AsInteger=fid_cl;

  DBGrInd=new TWTDBGrid(this, QuerI);

  PIndicGr->Params->AddText("Показания оборудования ",18,F,Classes::taCenter,false);
  PIndicGr->Params->AddGrid(DBGrInd, true)->ID="Indic";


  TWTQuery* QueryI = DBGrInd->Query;
  //QueryI->AddLookupField("name_met","id_meter","eqm_equipment_tbl","name_eqp","id");
  QueryI->AddLookupField("type_met","id_typemet","eqi_meter_tbl","type","id");
  QueryI->AddLookupField("name_energy","KIND_ENERGY","eqk_energy_tbl","name","id");
  QueryI->AddLookupField("Zone","ID_ZONE","eqk_zone_tbl","name","id"); // Потом Name
   QueryI->Open();

  TStringList *WListI=new TStringList();

  WListI->Add("id");

  TStringList *NListI=new TStringList();
  NListI->Add("before_value");
  NListI->Add("name_met");
//  NListI->Add("nm");
//  NListI->Add("kontrol_ind");
//  NListI->Add("dt_insp");
  QueryI->SetSQLModify("acd_indication_tbl",WListI,NListI,true,true,true);
  //QueryI->IndexFieldNames = "id_doc;num_eqp";
  QueryI->IndexFieldNames = "id_doc;num_eqp;kind_energy;id_zone";
  QueryI->LinkFields = "id_doc=id_doc";
  QueryI->MasterSource = DBGrHInd->DataSource;

  TWTField *Field;


  Field = DBGrInd->AddColumn("name_met", "Счетчик", "Счетчик");
  Field->SetReadOnly();
  Field->SetWidth(120);

   Field = DBGrInd->AddColumn("type_met", "Тип", "Тип");
   Field->SetReadOnly();
   Field->SetWidth(120);

   Field = DBGrInd->AddColumn("carry", "Разр.", "Разрядность");
   Field->SetWidth(50);
   Field->SetReadOnly();

   Field = DBGrInd->AddColumn("num_eqp", "Номер", "Номер");
   Field->SetWidth(80);


  Field = DBGrInd->AddColumn("name_energy", "Енергия", "Вид енергии");
  Field->SetWidth(50);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("Zone", "Зона", "Зона");
    Field->SetWidth(50);
  Field->SetReadOnly();


  Field = DBGrInd->AddColumn("coef_comp", "К-ф.тр.", "Коеффициент трансформации");
  Field->SetWidth(50);
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("before_value", "Предыдущие", "Предыдущие показания");
  Field->Column->ButtonStyle=cbsNone;
  //Field->Precision=4;
   Field->SetReadOnly();
 //
  Field = DBGrInd->AddColumn("value", "Текущие", "Текущие показания");
  Field->OnChange=OnChangeIndic;
//  Field->Precision=4;

  Field = DBGrInd->AddColumn("value_dev", "Разность", "Разность");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("value_dem", "Потребление", "Потребление");
  Field->SetReadOnly();

  Field = DBGrInd->AddColumn("id_meter", "eqp", " ");
  Field->SetReadOnly();
  Field->SetWidth(80);
  DBGrInd->Visible = true;
  //QueryI->IndexFieldNames = "id_doc;num_eqp;kind_energy;id_zone";
  DBGrInd->Visible = true;
//  DBGrInd->OnAccept=IndicAccept;
  DBGrHInd->OnDrawColumnCell=HIndDrawColumnCell;
  DBGrInd->OnDrawColumnCell= HeadDrawColumnCell;
  SetCaption("Отчеты по потреблению "+name_cl);
  ShowAs(WinName);
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
  MainPanel->ParamByID("Indic")->Control->SetFocus();
  MainPanel->ParamByID("HIndic")->Control->SetFocus();
 }
#undef WinName
//------------------------------------------------------------------------------------------
__fastcall TfResDem::~TfResDem()
{
  Close();
};
//------------------------------------------------------------------------------------------
void _fastcall TfResDem::IndicAddNew(TWTDBGrid *Sender) {
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
  id_clientp =fid_cl;
   Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
  /// вставляем заголовок
   int id_docp=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int idk_documentp=Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger;
   TDateTime reg_datep=Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime;
   TDateTime reg_date=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
  if (reg_date<reg_datep)
  { ShowMessage("Дата отчета меньше даты съема показаний! Проверьте!");
     return;
  };
  DecodeDate(reg_date,yearr,monthr,dayr);
  DecodeDate(reg_datep,yearp,monthp,dayp);
  if (reg_date<reg_datep)
  { ShowMessage("Дата отчета меньше даты съема показаний! Проверьте!");
     return;
  };

   if ((yearr>2099)||(yearr<2006))
  { ShowMessage("Некорректный год в дате отчета! Проверьте!");
     return;
  };
   if ((yearp>2099)||(yearp<2006))
  { ShowMessage("Некорректный год в дате съема показаний! Проверьте!");
     return;
  };
   int fid_doc=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int pid_client=Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger;
   reg_datep=Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime;

   /*
   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from clm_statecl_h where id_client=:pid_client \
   and mmgg_b<=:reg_datep and coalesce(mmgg_e,:reg_datep)>=:reg_datep ");
   QueryMet->ParamByName("pid_client")->AsInteger=pid_client;
   QueryMet->ParamByName("reg_datep")->AsDateTime=reg_datep;
   QueryMet->Open();
   if ((QueryMet->Eof))
   { ShowMessage ("Нет действующего договора клиента на дату:"+DateToStr(reg_datep));
     return;
    }
    else
    { if (QueryMet->FieldByName("doc_dat")->AsDateTime>reg_datep)
     {  ShowMessage (" Дата договора больше даты отчета:"+DateToStr(reg_datep));
     return;
     }
    };
*/


   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select res_inp_ind("+ToStrSQL(id_docp)+") ");
   QueryMet->ExecSql();
   //GrDetIndic->DataSource->DataSet->FieldByName("before_value")->LookupDataSet->Refresh();
   GrDetIndic->DataSource->DataSet->Refresh();
   GrDetIndic->Refresh();

};

//-------------------------------------------------------------------
void _fastcall TfResDem::CheckIndic(TWTDBGrid *Sender)
{
  int i=0;
  int fid_doc=0;
  TWTQuery *QueryMet=new TWTQuery(this);
  TWTDBGrid *GrIndic= Sender;
  /// вставляем заголовок
   fid_doc=Sender->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   int idk_documentp=Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger;
   int pid_client=Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger;
   TDateTime reg_datep=Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime;
 /*
   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from clm_statecl_h where id_client=:pid_client \
   and mmgg_b<=:reg_datep and coalesce(mmgg_e,:reg_datep)>=:reg_datep ");
   QueryMet->ParamByName("pid_client")->AsInteger=pid_client;
   QueryMet->ParamByName("reg_datep")->AsDateTime=reg_datep;
   QueryMet->Open();
   if ((QueryMet->Eof))
   { ShowMessage ("Нет действующего договора клиента на дату:"+DateToStr(reg_datep));
     return;
    };
 */
   QueryMet->Sql->Clear();
   QueryMet->Sql->Add("Select * from acm_headindication_tbl where id_main_ind=:pid_doc ");
   QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
   QueryMet->Open();
   if ( Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger!=370
       && Sender->DataSource->DataSet->FieldByName("id_main_ind")->AsInteger!=0
       ) Sender->DataSource->DataSet->FieldByName("id_main_ind")->Clear();

   if (!(QueryMet->Eof))
   {
      QueryMet->Sql->Clear();
      QueryMet->Sql->Add("Select * from acm_headindication_tbl where \
          id_doc=:pid_doc ");
      QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
      QueryMet->Open();
       if (!(QueryMet->Eof))
       {   if  (Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime!=
         QueryMet->FieldByName("date_end")->AsDateTime)
           { if (!Ask("Вы изменили дату съема показаний. Все Связанные отчеты будут удалены. Продолжить ?"))
                   Sender->DataSource->DataSet->Cancel();
             else
              QueryMet->Sql->Clear();
              QueryMet->Sql->Add("delete  from acm_headindication_tbl where \
                   id_main_ind=:pid_doc ");
               QueryMet->ParamByName("pid_doc")->AsInteger=fid_doc;
               QueryMet->ExecSql();

           };
       };

   };
};

//-------------------------------------------------------------------
void _fastcall TfResDem::IndicAddCl(TWTDBGrid *Sender) {
int i=0;
int id_clientp=0;
  TWTDBGrid *GrIndic= Sender;
  id_clientp =fid_cl;
  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
  Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime=Date();

    TDateTime db=((TMainForm*)(Application->MainForm))->PeriodDate(id_clientp,0);
    TDateTime de=((TMainForm*)(Application->MainForm))->PeriodDate(id_clientp,1);
    if(db==de)
      { db=BOM(db);
        de=EOM(de);
      }
     Sender->DataSource->DataSet->FieldByName("date_end")->AsDateTime=de;
}
//-------------------------------------------------------------------
void _fastcall  TfResDem::OnChangeIndic(TWTField *Sender)
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
   QuerDat->Sql->Add("select carry,coef_comp from acd_indication_tbl where id="+ToStrSQL(Table->FieldByName("id")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=QuerDat->Fields->Fields[1]->AsFloat;
   if (car==0){
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("id_typemet")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   };
     }
  catch (...) {
   QuerDat->Sql->Clear();
   QuerDat->Sql->Add("select carry from eqi_meter_tbl where id="+ToStrSQL(Table->FieldByName("id_typemet")->AsInteger));
   QuerDat->Open();
   car=QuerDat->Fields->Fields[0]->AsFloat;
   c_comp=1;
  };

  if (c_ind){
   TWTQuery *QuerDev=new TWTQuery(this);
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
  { Table->FieldByName("value_dem")->AsFloat=0;
    Table->FieldByName("value_dev")->AsFloat=0;
  };

   return;

}
//-------------------------------------------------------------------
void _fastcall  TfResDem::ClientDemandPrintP(TObject *Sender)
{
  TWTDBGrid *GrHIndic= DBGrHInd;
  TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;

  int id_head=GrHIndic->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
  //TfPrintDemand::ShowBill(int id_doc)
    Application->CreateForm(__classid(TfPrintDemand), &fPrintDemand);
    fPrintDemand->ShowBill(id_head);

};
//-------------------------------------------------------------------
void __fastcall  TfResDem::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

//-------------------------------------------------------------------
void __fastcall TfResDem::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
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

//-------------------------------------------------------------------
void __fastcall TfResDem::HIndDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
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
//-------------------------------------------------------------------

void _fastcall TfResDem::NewIndication( int id_fider, TDateTime dt_ind)
{
 DBGrHInd->Query->Insert();
 DBGrHInd->Query->FieldByName("id_grp")->AsInteger = id_fider;
 DBGrHInd->Query->FieldByName("reg_date")->AsDateTime =dt_ind;
 DBGrHInd->Query->FieldByName("date_end")->AsDateTime =dt_ind;
 DBGrHInd->Query->FieldByName("idk_document")->AsInteger = 311;
}
//-------------------------------------------------------------------
