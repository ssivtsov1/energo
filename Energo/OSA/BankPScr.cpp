//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "BankPScr.h"
#include "func.h"
#include "main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"


#define WinName  "Пачки квитанций"


__fastcall TFBankPScribe::~TFBankPScribe()
{
  Close();
};

_fastcall TFBankPScribe::TFBankPScribe(TWinControl *owner,int pid_head)  : TWTDoc(owner)
{ fid_head=pid_head;
nom=0;
 TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  nds=QuerTax->Fields->Fields[0]->AsFloat;


  TWTPanel* PHead=MainPanel->InsertPanel(500,false,200);
  TWTQuery *QuerHead=new TWTQuery(this);

  QuerHead->Sql->Clear();
  QuerHead->Sql->Add("select * from acm_headpay_tbl where id=:pid_head ");
  QuerHead->ParamByName("pid_head")->AsInteger=fid_head;
  QuerHead->Open();

  dat=QuerHead->FieldByName("reg_date")->AsDateTime;
  dat_mmggpay=BOM(dat);
   dat_mmgg=QuerHead->FieldByName("mmgg")->AsDateTime;
  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;



  QuerHPay= new TWTQuery(this);
  QuerHPay->Close();

  QuerHPay->Sql->Clear();
  QuerHPay->Sql->Add("  select h.*,pp.plus \
    from acm_headpayp_tbl h left join  \
    ( select p.id_headpay,p.plus  from  \
           ( select id_headpay,    sum(ptpl.value_pay) as plus \
                    from acm_payp_tbl ptpl \
                   group by id_headpay \
            )  as p          \
      ) as pp                                                                 \
     on ( h.id=pp.id_headpay) where h.reg_date=:dat_head \
   ");

     QuerHPay->ParamByName("dat_head")->AsDateTime=dat;
   DBGrHPay=new TWTDBGrid(this, QuerHPay);
  PHead->Params->AddText("Список пачек квитанций ",18,F,Classes::taCenter,false);
  PHead->Params->AddGrid(DBGrHPay, true)->ID="HeadPay";
  TWTQuery* QuerCli=new TWTQuery(this);

  QuerCli->Sql->Add(" select id,name,short_name from clm_client_tbl where book<0 ");
  QuerCli->Open();

  DBGrHPay->Query->AddLookupField("name_client","id_client",QuerCli,"short_name","id"); // Потом Name
  DBGrHPay->Query->AddLookupField("name_bank", "MFO_bank", "cmi_bank_tbl", "NAME","id");
 // DBGrHPay->Query->IndexDefs->Add("reg_date","reg_date" , TIndexOptions() << ixDescending	);
  DBGrHPay->Query->Open();

  TWTField *Field;


  Field = DBGrHPay->AddColumn("name_client", "Абонент", "Абонент");
   Field->SetOnHelp(((TMainForm*)MainForm)->CliClientMSpr);
   Field->SetWidth(80);


  Field = DBGrHPay->AddColumn("plus", "Поступило", "Поступление");
  Field->Precision=2;
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("mfo_bank", "МФО", "МФО");
  Field->SetOnHelp(((TMainForm*)MainForm)->CmiBankSpr);
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("name_bank", "Банк", "Банк");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrHPay->AddColumn("mmgg", "Месяц", "Месяц");
  Field->SetReadOnly();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("plus");

  DBGrHPay->Query->SetSQLModify("acm_headpayp_tbl",WList,NList,true,true,true);
  DBGrHPay->BeforePost=BeforePostHead;
    DBGrHPay->AfterInsert=BeforeInsertHead;
    DBGrHPay->OnExit=ExitParamsGrid;
    TWTPanel* PSHead=MainPanel->InsertPanel(100,false,200);
     QuerHSPay= new TWTQuery(this);
  QuerHSPay->Close();

  QuerHSPay->Sql->Clear();
  QuerHSPay->Sql->Add("  select h.*,pp.mmgg_pay, \
      pp.value_pay,pp.value,pp.value_tax,pp.mmgg \
    from acm_headpayp_tbl h right join  \
    ( select p.id_headpay,p.mmgg_pay,p.value,value_pay,value_tax,p.mmgg  from  \
           ( select id_headpay, mmgg_pay, mmgg,  sum(ptpl.value_pay) as value_pay , \
                   sum(ptpl.value) as value,sum(ptpl.value_tax) as value_tax  \
                    from acm_payp_tbl ptpl \
                   group by id_headpay,mmgg_pay,mmgg \
            )  as p          \
      ) as pp                                                                 \
     on ( h.id=pp.id_headpay) where h.reg_date=:dat_head \
   ");

   QuerHSPay->ParamByName("dat_head")->AsDateTime=dat;
    DBGrHSPay=new TWTDBGrid(this, QuerHSPay);
  PSHead->Params->AddText("Суммы ",18,F,Classes::taCenter,false);
  PSHead->Params->AddGrid(DBGrHSPay, true)->ID="HeadSPay";

DBGrHSPay->Query->Open();

  TWTField *FieldS;

  FieldS = DBGrHSPay->AddColumn("mmgg_pay", "Период оплаты", "Период оплаты");

  FieldS->SetWidth(100);
    FieldS->SetReadOnly();

  FieldS = DBGrHSPay->AddColumn("Value", "Сумма без НДС", "");
  FieldS->Precision=2;
  FieldS->SetWidth(100);
    FieldS->SetReadOnly();

  FieldS = DBGrHSPay->AddColumn("Value_tax", "НДС", "");
  FieldS->Precision=2;
  FieldS->SetWidth(100);
    FieldS->SetReadOnly();

  FieldS = DBGrHSPay->AddColumn("Value_pay", "Всего", "");
  FieldS->Precision=2;
  FieldS->SetWidth(100);
  FieldS->SetReadOnly();

  FieldS = DBGrHSPay->AddColumn("mmgg", "Месяц", "Месяц");
  FieldS->SetReadOnly();

  TStringList *WListS=new TStringList();
  TStringList *NListS=new TStringList();
  DBGrHSPay->Query->SetSQLModify("acm_headpayp_tbl",WListS,NListS,false,false,false);



  // *******************************
  TWTPanel* PPayGr=MainPanel->InsertPanel(800,true,500);

   QuerPay= new TWTQuery(this);
   QuerPay->Close();
   QuerPay->Sql->Clear();

  QuerPay->Sql->Add(" select p.* from acm_headpayp_tbl h, acm_payp_tbl p  \
     where h.id=p.id_headpay and h.reg_date=:pdat order by p.nom");
        QuerPay->ParamByName("pdat")->AsDateTime=dat;


   DBGrPay=new TWTDBGrid(this, QuerPay);

  PPayGr->Params->AddText("Платежки ",18,F,Classes::taCenter,true);
  PPayGr->Params->AddGrid(DBGrPay, true)->ID="Pay";
   DBGrPay->OnEnter=EnterPay;
   QuerPay->Open();
    TStringList *WListP=new TStringList();
     WListP->Add("id");
     TStringList *NListP=new TStringList();


   DBGrPay->Query->SetSQLModify("acm_payp_tbl",WListP,NListP,true,true,true);


  QuerPay->IndexFieldNames = "nom";
  QuerPay->LinkFields = "id=id_headpay";
  QuerPay->MasterSource = DBGrHPay->DataSource;

  TWTField *FieldP;


  FieldP = DBGrPay->AddColumn("value_pay", "Сумма оплаты", "Сумма");
  FieldP->OnChange=OnChangePay;
  FieldP->Precision=2;
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("mmgg_pay", "Пер.оплаты", "Пер.оплаты");
  FieldP->OnChange=ChMMGG;
  FieldP->SetWidth(100);

  // FieldP->SetReadOnly();
  FieldP = DBGrPay->AddColumn("comment", "примечание", "Номер отчета");
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("value_tax", "НДС", "НДС");
    FieldP->OnChange=OnChangeTax;
  FieldP->Precision=2;
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("value", "Без НДС", "Сумма");
  FieldP->Precision=2;
  FieldP->SetWidth(80);


  DBGrHPay->ToolBar->AddButton("CONSTRMODE", "Расчет", Calculate);
   DBGrHPay->ToolBar->AddButton("insp_ind", "Перенос платежей", Migration);
  TWTToolBar* tb=DBGrHPay->ToolBar;
  TWTToolButton* btn;

  FieldP = DBGrPay->AddColumn("nom", "№ ", "№");
   FieldP->OnChange=Chnom;
  FieldP->SetWidth(50);
 /*
 DBGrPay->AfterInsert=BeforeInsertPay;
  DBGrPay->AfterPost=AfterPostPay;
   */
   DBGrPay->BeforePost=PostPay;
   DBGrPay->OnExit=ExitParamsGrid;
   DBGrPay->OnDrawColumnCell=PayDrawColumnCell;
      DBGrPay->AfterInsert=BeforeInsertPay;
            DBGrPay->AfterPost=AfterPostPay;
  DBGrHPay->Visible = true;
   
 SetCaption("Ввод платежей по физ лицам");
 ShowAs(WinName);
 MainPanel->ParamByID("HeadPay")->Control->SetFocus();
  MainPanel->ParamByID("HeadSPay")->Control->SetFocus();
 MainPanel->ParamByID("Pay")->Control->SetFocus();
 MainPanel->ParamByID("HeadPay")->Control->SetFocus();
};


void __fastcall  TFBankPScribe::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

 void _fastcall TFBankPScribe::ExitParamsGrid(TObject *Sender){

 TWTDBGrid * GridEx;
 GridEx= ((TWTDBGrid *)Sender);
 if (GridEx->Query->isInserted() || GridEx->Query->isModified())
{    GridEx->Query->ApplyUpdates();
    if (GridEx->DataSource->DataSet->State==dsEdit || GridEx->DataSource->DataSet->State==dsInsert)
    {
     GridEx->DataSource->DataSet->Post();
  };
};
DBGrHSPay->DataSource->DataSet->Refresh();
};

void __fastcall TFBankPScribe::PayDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   float pay;
    float tax;
    float all;
 TDBGrid* t=(TDBGrid*)Sender;
 pay =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 tax =t->DataSource->DataSet->FieldByName("value_tax")->AsFloat;
 all =t->DataSource->DataSet->FieldByName("value_pay")->AsFloat;
    if ( Round(Round(pay+tax,2)-Round(all,2),0 )!=0 )
     {    t->Canvas->Brush->Color=0x00caffff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };

   if ( (Round(Round(all/((100+nds)/nds),2)-Round(tax,2),2)!=0  && Round(tax,2)!=0))
     {    t->Canvas->Brush->Color=0x000affff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };
    if (!CheckSum(pay,tax))
   {    t->Canvas->Brush->Color=0x00800080;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };

}

void _fastcall TFBankPScribe::BeforePostHead(TWTDBGrid *Sender)
{  bool dublecod=false;
   TWTQuery *QCheck=new TWTQuery(this);
    QCheck->Sql->Clear();
    QCheck->Sql->Add("select id_client,mfo_bank,reg_date \
      from acm_headpayp_tbl  where mfo_bank=:pmfo and \
          reg_date=:pdate and id_client=:pid_client ");
        QCheck->ParamByName("pmfo")->AsInteger=Sender->DataSource->DataSet->FieldByName("mfo_bank")->AsInteger;
        QCheck->ParamByName("pdate")->AsDateTime=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
       QCheck->ParamByName("pid_client")->AsInteger=Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger;
      QCheck->Open();
    if (!(QCheck->Eof))
    {    if (QCheck->FieldByName("id")->AsInteger!=Sender->DataSource->DataSet->FieldByName("id")->AsInteger)
        {
         ShowMessage("Дублирование !");
         Sender->DataSource->DataSet->Cancel();
         };
     };
DEL(QCheck);
};

void _fastcall TFBankPScribe::BeforeInsertHead(TWTDBGrid *Sender)
{  Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime=dat;
   Sender->DataSource->DataSet->FieldByName("mmgg")->AsDateTime=dat_mmgg;

};

void _fastcall TFBankPScribe::BeforeInsertPay(TWTDBGrid *Sender)
{  Sender->DataSource->DataSet->FieldByName("mmgg_pay")->AsDateTime=dat_mmggpay;
  Sender->DataSource->DataSet->FieldByName("mmgg")->AsDateTime=dat_mmgg;

    nom=nom+1;
   Sender->DataSource->DataSet->FieldByName("nom")->AsInteger=nom;
   Sender->DataSource->DataSet->FieldByName("id_headpay")->AsInteger=DBGrHPay->DataSource->DataSet->FieldByName("id")->AsInteger;

};
void _fastcall TFBankPScribe::AfterPostPay(TWTDBGrid *Sender)
{   TLocateOptions SearchOptions;
 SearchOptions.Clear();

 Sender->DataSource->DataSet->Locate("nom",nom ,SearchOptions);
};

void _fastcall TFBankPScribe::Calculate(TObject *Sender)
{  bool dublecod=false;
   TWTQuery *QCheck=new TWTQuery(this);
    QCheck->Sql->Clear();
    QCheck->Sql->Add("select  calc_pay_priv(:head,0 )");
      QCheck->ParamByName("head")->AsInteger=QuerHPay->FieldByName("id")->AsInteger;
      QCheck->ExecSql();

DEL(QCheck);
};

void __fastcall TFBankPScribe::EnterPay(TObject *Sender)
{  int head=DBGrHPay->DataSource->DataSet->FieldByName("id")->AsInteger;
   TWTQuery *Qnom=new TWTQuery(this);
   Qnom->Sql->Clear();
   Qnom->Sql->Add("select coalesce(max(nom),0)::::integer as nomd from acm_payp_tbl \
       where id_headpay=:phead group by id_headpay    ");
   Qnom->ParamByName("phead")->AsInteger=head;
   Qnom->Open();
   if (!(Qnom->Eof))
      nom=Qnom->FieldByName("nomd")->AsInteger;
   else nom=0;
 DEL(Qnom);
}

void _fastcall TFBankPScribe::Migration(TObject *Sender)
{   TWTQuery *QCheck=new TWTQuery(this);
    QCheck->Sql->Clear();
    QCheck->Sql->Add("select  calc_pay_priv(:head,0 )");
      QCheck->ParamByName("head")->AsInteger=QuerHPay->FieldByName("id")->AsInteger;
      QCheck->ExecSql();

DEL(QCheck);
};

void _fastcall TFBankPScribe::PostPay(TWTDBGrid *Sender)
{ float s=Round(Sender->DataSource->DataSet->FieldByName("value_pay")->AsFloat,2);
  float s1=Round(Sender->DataSource->DataSet->FieldByName("value")->AsFloat,2);
  float s2=Round(Sender->DataSource->DataSet->FieldByName("value_tax")->AsFloat,2);
   if ((Round(s,2)!=Round((s1+s2),2)))  {
     ShowMessage("Итоговая сумма не равна сумме без НДС + НДС. Проверьте!");
    Sender->DataSource->DataSet->Cancel();
   };
   if (!CheckSum(Sender->DataSource->DataSet->FieldByName("value")->AsFloat,Sender->DataSource->DataSet->FieldByName("value_tax")->AsFloat))
    Sender->DataSource->DataSet->Cancel();

};



void _fastcall  TFBankPScribe::OnChDate(TWTField  *Sender)
{  TWTQuery *Quer=new TWTQuery(this);
   Quer->Sql->Clear();
   TDateTime mg=Sender->Field->DataSet->FieldByName("mmgg")->AsDateTime;
   TDateTime bmg=BOM(Sender->Field->AsDateTime);
   if ( bmg!=mg)
    {  ShowMessage("Дата банковской выписки не принадлежит периоду!");
       return;
    };
};



void _fastcall  TFBankPScribe::Chnom(TWTField  *Sender)
{ if (nom<=Sender->Field->AsInteger)
  nom=Sender->Field->AsInteger;
};

void __fastcall TFBankPScribe::ChMMGG(TWTField *Sender)
{  dat_mmggpay=Sender->Field->AsDateTime;
};




void __fastcall TFBankPScribe::OnChangePay(TWTField *Sender)
{ TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  float nds=QuerTax->Fields->Fields[0]->AsFloat;
 AnsiString NField;
 NField=Sender->Field->Name;
 if  (NField=="value_pay")
 {
   Sender->Field->DataSet->FieldByName("value_tax")->AsFloat=Round(Sender->Field->AsFloat/((100+nds)/nds),2);
 };
};

bool __fastcall TFBankPScribe::CheckSum(float s1,float s2)
{ if ((s1<=0)&& (s2<=0) ) return true;
  if ((s1>=0)&& (s2>=0) ) return true;
    ShowMessage("Нельзя ввести в одном платеже положительную и отрицательную сумму!");
  return false;
};


void __fastcall TFBankPScribe::OnChangeTax(TWTField *Sender)
{ AnsiString NField;
 NField=Sender->Field->Name;
 if  (NField=="value_tax")
  {
  Sender->Field->DataSet->FieldByName("value")->AsFloat=Sender->Field->DataSet->FieldByName("value_pay")->AsFloat- \
   Round(Sender->Field->AsFloat,2);
  };
};
#undef WinName



//---------------------------------------------------------------------------


