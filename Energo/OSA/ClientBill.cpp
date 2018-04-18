//---------------------------------------------------------------------------
// сложный справочник (предназначалось для рисования сложной формы документа) класс TWTDoc:TWTParamsForm
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
#include "func.h"
#include "ClientBill.h"
#include "fBillPrint.h"
#include "fTaxPrint.h"
#include "fTaxCorPrint.h"
#include "f2kAct.h"
#include "fPenInf.h"
#include "fEdTaxParam.h"
#include "SysUser.h"

#include "fBillAct.h"
#define WinName "Счета клиента"
TfPenaInflPrint *fPenaInflPrint;
TDateTime WorkDate;



_fastcall TfCliBill::TfCliBill(TWinControl *owner, TWTQuery *Client, int fid_clien): TWTDoc(owner)
{
  AnsiString NameCl=" ";
  fid_client=fid_clien;
  NameCl=Client->DataSource->DataSet->FieldByName("short_name")->AsString;


   QuerBill=new TWTQuery(this);
   QuerBill->Sql->Add("select b.*,b.value+b.value_tax as valtax  \
   from acm_bill_tbl as  b where id_client=:pid_client order by mmgg desc, mmgg_bill");
    QuerBill->ParamByName("pid_client")->AsInteger=fid_client;
      TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  nds=QuerTax->Fields->Fields[0]->AsFloat;

  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="Печать ";
  BtnPrint->OnClick=ClientBillPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=30;
   if (CheckLevel("Счета/Оплата - Печать (кнопка)")==0)
      BtnPrint->Enabled=false;


  TButton *BtnTax=new TButton(this);
  BtnTax->Caption="Налоговая ";
  BtnTax->OnClick=ClientBillTax;
  BtnTax->Width=100;
  BtnTax->Top=2;
  BtnTax->Left=130;
  int ChLevel =CheckLevel("Счета/Оплата");
  if  (ChLevel==0) {
     return;
   };


  if (CheckLevel("Счета/Оплата - Налоговая (кнопка)")==0)
      BtnTax->Enabled=false;

  TButton *BtnPred=new TButton(this);
  BtnPred->Caption="Детализация";
  BtnPred->OnClick=ClientBillDet;
  BtnPred->Width=100;
  BtnPred->Top=2;
  BtnPred->Left=180;
   if (CheckLevel("Счета/Оплата - Детализация (кнопка)")==0)
      BtnPred->Enabled=false;

   TButton *BtnClc=new TButton(this);
  BtnClc->Caption="Погашение счетов";
  BtnClc->OnClick=ClientClc;
  BtnClc->Width=100;
  BtnClc->Top=2;
  BtnClc->Left=300;
   if (CheckLevel("Счета/Оплата - Погашение счетов (кнопка)")==0)
       BtnClc->Enabled=false;

  TButton *BtnLimit=new TButton(this);
  BtnLimit->Caption="Превышение лимита";
  BtnLimit->OnClick=ClientBill2kr;
  BtnLimit->Width=120;
  BtnLimit->Top=2;
  BtnLimit->Left=300;
   if (CheckLevel("Счета/Оплата - Превышение лимита (кнопка)")==0)
       BtnLimit->Enabled=false;

  TButton *BtnInfl=new TButton(this);
  BtnInfl->Caption="Расчет инфляции";
  BtnInfl->OnClick=ClientBillInfl;
  BtnInfl->Width=120;
  BtnInfl->Top=2;
  BtnInfl->Left=300;
   if (CheckLevel("Счета/Оплата - Расчет инфляции (кнопка)")==0)
       BtnInfl->Enabled=false;


  TButton *BtnPen=new TButton(this);
  BtnPen->Caption="Расчет пени";
  BtnPen->OnClick=ClientBillPen;
  BtnPen->Width=120;
  BtnPen->Top=2;
  BtnPen->Left=300;
   if (CheckLevel("Счета/Оплата - Расчет пени (кнопка)")==0)
       BtnPen->Enabled=false;


  TButton *BtnPret=new TButton(this);
  BtnPret->Caption="Печать претензий";
  BtnPret->OnClick=ClientPret;
  BtnPret->Width=120;
  BtnPret->Top=2;
  BtnPret->Left=300;
   if (CheckLevel("Счета/Оплата - Печать претензий (кнопка)")==0)
       BtnPret->Enabled=false;

         TButton *BtnDelBill=new TButton(this);
  BtnDelBill->Caption="Удаленные";
  BtnDelBill->OnClick=ClientDelBill;
  BtnDelBill->Width=120;
  BtnDelBill->Top=2;
  BtnDelBill->Left=300;
   if (CheckLevel("Счета/Оплата - Удаленные счета (кнопка)")==0)
       BtnDelBill->Enabled=false;

  TWTPanel* PBill=MainPanel->InsertPanel(800,true,300);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PBill->Params->AddText("Cчета клиентов"+NameCl,10,F,Classes::taCenter,true)->ID="NameBill";
  PBill->Params->AddButton(BtnPrint,true)->ID="BtnPrint";
  PBill->Params->AddButton(BtnTax,false)->ID="BtnTax";
  PBill->Params->AddButton(BtnPred,false)->ID="BtnPred";
  PBill->Params->AddButton(BtnInfl,false)->ID="BtnInfl";
  PBill->Params->AddButton(BtnPen,false)->ID="BtnPen";
   PBill->Params->AddButton(BtnPret,false)->ID="BtnPret";
  PBill->Params->AddButton(BtnClc,false)->ID="BtnClc";
  PBill->Params->AddButton(BtnLimit,false)->ID="BtnLimit";
  PBill->Params->AddButton(BtnDelBill,false)->ID="BtnDelBill";

  TButton *BtnSaveD=new TButton(this);
  BtnSaveD->Caption="";
  BtnSaveD->Width=100;
  BtnSaveD->Top=2;
  BtnSaveD->Left=330;
  PBill->Params->AddButton(BtnSaveD,false)->ID="BtnSaveD";
     DBGrBill=new TWTDBGrid(this, QuerBill);
  PBill->Params->AddGrid(DBGrBill,true)->ID="Bill";
  //DBGrBill->SetReadOnly();
     TWTQuery* QuerRep=new TWTQuery(this);
  QuerRep->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
  QuerRep->Sql->Add(" where  di.idk_document=dk.id and dk.ident='bill' " );
  QuerRep->Open();

  DBGrBill->Query->AddLookupField("NAME_BANK", "MFO_self", "cmi_bank_tbl", "NAME","id");
  DBGrBill->Query->AddLookupField("name_pref", "id_pref", "aci_pref_tbl", "NAME","id");
  DBGrBill->Query->AddLookupField("kind_doc", "idk_doc", QuerRep, "NAME","id");
  DBGrBill->Query->Open();
  //DBGrBill->Table->IndexFieldNames="short_name";
  TDataSource *DataSource=DBGrBill->DataSource;
   //DBGrBill->OnExit=ExitParamsGrid;
 // DBGrBill->ReadOnly=true;
  TWTField *Field;

  Field = DBGrBill->AddColumn("name_pref", "Вид счета", "Вид счета");
   Field->SetRequired("Вид счета");
  Field->SetWidth(90);

  Field = DBGrBill->AddColumn("reg_num", "Номер", "Номер счета");
  Field->SetRequired("Номер  должен быть заполнен");
  Field->SetWidth(100);

  Field = DBGrBill->AddColumn("reg_date", "Дата", "Дата");
  Field->SetRequired("Дата должна быть заполнена");
  Field->SetWidth(90);

  Field = DBGrBill->AddColumn("demand_val", "КВТ" , "КВТ");
  Field->SetReadOnly(true);
  Field = DBGrBill->AddColumn("Value", "Сумма" , "Сумма");
  Field->SetReadOnly(true);
  Field = DBGrBill->AddColumn("Value_tax", "НДС" , "НДС");
  Field->SetReadOnly(true);
  Field = DBGrBill->AddColumn("valtax", "С НДС" , "С НДС  ");
  Field->SetReadOnly(true);

    Field = DBGrBill->AddColumn("flag_transmis", "Выдан", "Выдан");
  Field->AddFixedVariable("0", "");
  Field->AddFixedVariable("1", "Выдан");

  Field = DBGrBill->AddColumn("kind_doc", "Вид документа", "Вид документа");
 //  Field->SetOnHelp(DckDocumentSpr);
  Field->SetWidth(100);

  Field = DBGrBill->AddColumn("name_bank", "Банк", "Банк");
  Field->SetRequired("Банк  должен быть заполнен");
  Field->SetWidth(250);

  Field = DBGrBill->AddColumn("account_self", "Расч.счет", "Расчетный счет");
  Field->SetRequired("Счет должен быть заполнен");
  Field->SetWidth(150);



  Field = DBGrBill->AddColumn("date_transmis", "Дата вруч." , "Дата вручения");
  Field->SetWidth(90);

  /* Field = DBGrBill->AddColumn("name_transmis", "Передан" , "Способ передачи");
  Field = DBGrBill->AddColumn("name_perconput", "Передал" , "Кто вручил счет");
  Field = DBGrBill->AddColumn("name_perconget", "Получил" , "Кто получил счет");
  */
  Field = DBGrBill->AddColumn("mmgg_bill", "Период" , "Месяц");
  Field->SetWidth(90);

  Field = DBGrBill->AddColumn("mmgg", "Месяц" , "Месяц");
  Field->SetReadOnly(true);
  Field->SetWidth(90);

      Field = DBGrBill->AddColumn("flock", "Зак.", "Закрыт");
  Field->AddFixedVariable("1", "^");
  Field->AddFixedVariable("0"," ");
  Field->SetReadOnly();
  Field->SetWidth(20);

  Field = DBGrBill->AddColumn("id_doc", "№№" , "№№");
    Field->SetReadOnly(true);
  Field->SetWidth(90);

   Field = DBGrBill->AddColumn("id_bill", "№ ref" , "№ реф");
    Field->SetReadOnly(true);
  Field->SetWidth(90);




  //
  TStringList *WList=new TStringList();
  WList->Add("id_doc");
  TStringList *NList=new TStringList();
   NList->Add("valtax");
  QuerBill->SetSQLModify("acm_bill_tbl",WList,NList,true,true,true);
   DBGrBill->OnDrawColumnCell=BillDrawColumnCell;
     if  (ChLevel==1) {
     DBGrBill->ReadOnly=true;
   };

  TWTToolBar* tb=DBGrBill->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="DelRecord")
     {
       OldDelBill=tb->Buttons[i]->OnClick;
       tb->Buttons[i]->OnClick=DelBill;
     }
   }


  //-=----------------------------------------платежи-------------------------------------
  TWTPanel* PPay=MainPanel->InsertPanel(300,true,200);
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PPay->Params->AddText("Платежки",18,F,Classes::taCenter,false);
   QuerPay=new TWTQuery(this);

    TWTQuery* QuerRepP=new TWTQuery(this);
  QuerRepP->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
  QuerRepP->Sql->Add(" where  di.idk_document=dk.id and dk.ident='pay' " );
  QuerRepP->Open();

  QuerPay->Sql->Add("select * from acm_pay_tbl where id_client=:pid_client order by mmgg desc, mmgg_pay ");
  QuerPay->ParamByName("pid_client")->AsInteger=fid_client;


  TWTDBGrid* DBGrPay = new TWTDBGrid(this, QuerPay);
  PPay->Params->AddGrid(DBGrPay, true)->ID="Pay";
/*
  DBGrDTar->Table->AddLookupField("currency", "IDk_currency", "cmi_currency_tbl", "short_name","id");
  DBGrDTar->Table->AddLookupField("Doc","id_doc","dcm_doc_tbl","reg_num","id");
*/

  DBGrPay->Query->AddLookupField("name_bank","mfo_client","cmi_bank_tbl","name","id");
  DBGrPay->Query->AddLookupField("name_client","id_client","clm_client_tbl","name","id"); // Потом Name
  DBGrPay->Query->AddLookupField("pref","id_pref","aci_pref_tbl","name","id"); // Потом Name
  DBGrPay->Query->AddLookupField("kind_doc","idk_doc",QuerRepP,"name","id"); // Потом Name


  DBGrPay->Query->Open();

  DBGrPay->Query->IndexFieldNames = "";
  //DBGrPay->Table->LinkFields = "id=id_tarif";
  //DBGrPay->Table->MasterSource = DataSource;
 // DBGrPay->OnExit=ExitParamsGrid;

  TStringList *WListP=new TStringList();
  WListP->Add("id_doc");
  TStringList *NListP=new TStringList();
  QuerPay->SetSQLModify("acm_pay_tbl",WListP,NListP,true,true,true);

  TWTField *FieldP;
  FieldP = DBGrPay->AddColumn("reg_num", "Номер ", "Номер отчета");
 // FieldP->SetRequired("Номер  должен быть заполнен");
  FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("reg_date", "Дата ", "Дата отчета");
//  FieldP->SetRequired("Дата должна быть заполнена");
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("pay_date", "Дата платежа", "Дата платежа");
 // FieldP->SetRequired("Дата должна быть заполнена");
    FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("pref", "Вид енергии", "Дата платежа");
 // FieldP->SetRequired("Дата должна быть заполнена");
    FieldP->SetWidth(100);


  FieldP = DBGrPay->AddColumn("value", "Сумма", "Сумма");
  FieldP->Precision=2;
  FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("value_tax", "Ндс", "Ндс");
  FieldP->Precision=2;
  FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("value_pay", "С НДС", "Сумма");
  FieldP->Precision=2;
  FieldP->SetWidth(100);


  FieldP = DBGrPay->AddColumn("mmgg_pay", "Период оплат", "");
   FieldP->SetWidth(100);

     FieldP = DBGrPay->AddColumn("mmgg", "Месяц", "");
       FieldP->SetReadOnly(true);
   FieldP->SetWidth(100);

   FieldP = DBGrPay->AddColumn("kind_doc", "Тип", "Тип");
  FieldP->SetWidth(60);

   FieldP = DBGrPay->AddColumn("sign_pay", "Знак", "Знак");
  FieldP->AddFixedVariable("-1", '-');
  FieldP->AddFixedVariable("1",'+');
  FieldP->SetDefValue("1");
  FieldP->SetWidth(26);


  FieldP = DBGrPay->AddColumn("comment", "Примечание", "Примечание");
  FieldP->SetWidth(100);

    FieldP = DBGrPay->AddColumn("MFO_client", "MFO", "MFO");
 // FieldP->SetRequired("Банк должен быть заполнен");
  FieldP->SetOnHelp(((TMainForm*)MainForm)->CmiBankSpr);
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("Name_bank", "Банк", "Банк");
 // FieldP->SetRequired("Банк должен быть заполнен");
  FieldP->SetOnHelp(((TMainForm*)MainForm)->CmiBankSpr);
  FieldP->SetWidth(120);

  FieldP = DBGrPay->AddColumn("account_client", "Расчетный счет", "Расчетный счет");
 // FieldP->SetRequired("Расчетный счет должен быть заполнен");
  FieldP->SetWidth(100);
  FieldP->OnChange=ChangePayAccount;

  DBGrPay->OnDrawColumnCell=PayDrawColumnCell;


  FieldP = DBGrPay->AddColumn("Name_client", "Клиент", "Банк");
 // FieldP->SetRequired("Клиент должен быть заполнен");
  FieldP = DBGrPay->AddColumn("id_doc", "№№" , "№№");
   FieldP->SetReadOnly(true);

  FieldP->SetOnHelp(((TMainForm*)MainForm)->CliClientMSpr);
  FieldP->SetWidth(200);
   if  (ChLevel==1) {
     DBGrPay->ReadOnly=true;
   };
  //DBGrPay->SetReadOnly();


   ShowAs(WinName);
   this->SetCaption("Счета "+ NameCl); //не должно содержать "["
   //LoadFromFile(DocBill->DocFile);
  MainPanel->ParamByID("Bill")->Control->SetFocus();
  MainPanel->ParamByID("Pay")->Control->SetFocus();
  MainPanel->ParamByID("Bill")->Control->SetFocus();

  MainPanel->ParamByID("Bill")->Control->SetFocus();
};

void __fastcall TfCliBill::PayDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   float pay;
    float tax;
    float all;


 TDBGrid* t=(TDBGrid*)Sender;
 pay =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 tax =t->DataSource->DataSet->FieldByName("value_tax")->AsFloat;
 all =t->DataSource->DataSet->FieldByName("value_pay")->AsFloat;
    if ( Round( Round(pay,2)+Round(tax,2)-Round(all,2),0)!=0  )
     {    t->Canvas->Brush->Color=0x00caffff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };
    // FValPay=Round(StrToFloat(SValPay),2);
 // FValTax=Round(FValPay/((100+nds)/nds),2);
    if ( (Round(Round(all/((100+nds)/nds),2)-Round(tax,2),0)!=0 && Round(tax,2)!=0))
     {    t->Canvas->Brush->Color=0x00faffff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };


}
void __fastcall TfCliBill::BillDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   float val;
    float tax;

 TDBGrid* t=(TDBGrid*)Sender;
 val =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 tax =t->DataSource->DataSet->FieldByName("value_tax")->AsFloat;

    if ( (Round( val/(1/nds*100)- tax,0)!=0  && Round(tax,2)!=0) )
     {    t->Canvas->Brush->Color=0x00caffff;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };

}

void __fastcall TfCliBill::CalcExpr(TDataSet* Sender)
{ TDataSet *CalcDS=Sender;
 float v=CalcDS->FieldByName("value")->AsFloat;
 float vt=CalcDS->FieldByName("value_tax")->AsFloat;
  CalcDS->FieldByName("all")->AsFloat=v+vt;

};
__fastcall TfCliBill::~TfCliBill()
{
  Close();
};

void __fastcall  TfCliBill::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}


void __fastcall TfCliBill::ClientBillDet(TObject *Sender)

{ int fid_bill=DBGrBill->DataSource->DataSet->FieldByName("id_doc")->AsInteger;
   TWTDoc *WGrid = new TfCliBillDetal(this, fid_bill);
};

void __fastcall TfCliBill::ClientDelBill(TObject *Sender)
{      TWTDoc *WGrid = new TfCliBillDel(this, fid_client);
}
#undef WinName
//---------------------------------------------------------------------------
void _fastcall TfCliBill::ChangePayAccount(TWTField* Sender){

  TWTTable *Table = (TWTTable *)Sender->Field->DataSet;
  TWTQuery *QuerAcc=new TWTQuery(this);
  QuerAcc->Sql->Clear();
  QuerAcc->Sql->Add("select id_client from cli_account_tbl where MFO="+ToStrSQL(Table->GetField("mfo_client")->AsInteger));
  QuerAcc->Sql->Add(" and account="+ToStrSQL(Table->GetField("account_client")->AsFloat));
  QuerAcc->Open();
  if (!QuerAcc->Eof)
       Table->GetField("id_client")->AsInteger = QuerAcc->FieldByName("id_client")->Value;
};
//----------------------------------------------------------------------------
void __fastcall TfCliBill::ClientBillPrint(TObject *Sender)
{    TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrBill= ((TWTDBGrid *)MPanel->ParamByID("Bill")->Control);
  //int id_bill=GrBill->Table->FieldByName("id_doc")->AsInteger;
  int id_bill=GrBill->Query->FieldByName("id_doc")->AsInteger;
//  Application->CreateForm(__classid(TfPrintBill), &fPrintBill);
  fPrintBill->ShowBill(id_bill);


//  if(GrBill->Query->FieldByName("mmgg")->AsDateTime < TDateTime(2010,5,1) )
  { // с мая 2010 акты вроде бы отменили

   if((GrBill->Query->FieldByName("id_pref")->AsInteger == 520)||
      (GrBill->Query->FieldByName("id_pref")->AsInteger == 524)) // счет на 2кр - спросим про акты
   {
      TfPrint2krAct* fPrint2krAct;
      Application->CreateForm(__classid(TfPrint2krAct), &fPrint2krAct);
      fPrint2krAct->mmgg =  GrBill->Query->FieldByName("mmgg")->AsDateTime;
      fPrint2krAct->id_client = GrBill->Query->FieldByName("id_client")->AsInteger;
      fPrint2krAct->id_pref = GrBill->Query->FieldByName("id_pref")->AsInteger;
      fPrint2krAct->id_doc = id_bill;
      fPrint2krAct->ShowModal();
      delete fPrint2krAct;

   };
  }

 if (((GrBill->Query->FieldByName("id_pref")->AsInteger == 10)&&(GrBill->Query->FieldByName("idk_doc")->AsInteger != 209))||
     (GrBill->Query->FieldByName("id_pref")->AsInteger == 20)) // спросим про акт
   {
      Application->CreateForm(__classid(TfPrintBillAkt), &fPrintBillAkt);
      fPrintBillAkt->id_bill = id_bill;
      fPrintBillAkt->ShowModal();
      delete fPrintBillAkt;
   }

 if ((GrBill->Query->FieldByName("id_pref")->AsInteger == 110)||(GrBill->Query->FieldByName("id_pref")->AsInteger == 120)) // спросим про акт
   {
      Application->CreateForm(__classid(TfPrintBillAkt), &fPrintBillAkt);
      fPrintBillAkt->id_bill = id_bill;
      fPrintBillAkt->ShowModal();
      delete fPrintBillAkt;
   }

 //Application->CreateForm(__classid(TRepKontrolGr), &RepKontrolGr);
 //RepKontrolGr->RepDoc->Preview();

  if ((QuerBill->FieldByName("flag_transmis")->AsInteger ==0)&&(QuerBill->FieldByName("flock")->AsInteger ==0))
  {
   if (MessageDlg(" Отметить счет как выданный ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
   {
    QuerBill->Edit();
    QuerBill->FieldByName("flag_transmis")->AsInteger=1;
    QuerBill->Post();
   }
  }


};
//-----------------------------------------------------------------------------
void __fastcall TfCliBill::ClientClc(TObject *Sender)
{
  TWTQuery * Calc = new TWTQuery(Application);
  Calc->Options<< doQuickOpen;

  Calc->RequestLive=false;
  Calc->CachedUpdates=false;
//  Calc->Transaction->AutoCommit=false;

  AnsiString sqlstr="select err_pay_bill( :client );";
  Calc->Sql->Clear();
  Calc->Sql->Add(sqlstr);
  Calc->ParamByName("client")->AsInteger=fid_client;

  TWTQuery * QSys = new TWTQuery(Application);
  QSys->Options<< doQuickOpen;
  QSys->RequestLive=false;
  QSys->CachedUpdates=false;
//  QSys->Transaction->AutoCommit=false;
  AnsiString sqlmmgg=" select value_ident from syi_sysvars_tbl where ident='mmgg'";
  QSys->Sql->Add(sqlmmgg);
  QSys->Open();
  AnsiString mg=QSys->FieldByName("value_ident")->AsString;

  AnsiString sqlstrs=" update syi_sysvars_tmp set value_ident=:mg \
   where ident='mmgg'";
  QSys->Sql->Clear();
  QSys->Sql->Add(sqlstrs);
  QSys->ParamByName("mg")->AsString=mg;

  try
   {
   Calc->ExecSql();
   QSys->ExecSql();
   ShowMessage("Расчет завершен! ");
   }
   catch(EDatabaseError &e)
//  catch(Exception &e)
   {
    ShowMessage("Ошибка перерасчета "+e.Message.SubString(8,200));
//    Calc->Transaction->Rollback();
    Calc->Close();
//    Calc->Transaction->AutoCommit=true;
    delete Calc;
    return;
   }


};

void __fastcall TfCliBill::ClientBillTax(TObject *Sender)
{    TWTPanel *TDoc;
  int id_tax;

  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrBill= ((TWTDBGrid *)MPanel->ParamByID("Bill")->Control);
  //int id_bill=GrBill->Table->FieldByName("id_doc")->AsInteger;
  int id_bill=GrBill->Query->FieldByName("id_doc")->AsInteger;
  TDateTime mmgg_bill=GrBill->Query->FieldByName("mmgg")->AsDateTime;
  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;
//  ZQTax->MacroCheck=true;
//  TZDatasetOptions Options;
//  Options.Clear();
//  Options << doQuickOpen;
//  ZQTax->Options=Options;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add("select t.id_doc from acm_tax_tbl  as t where t.id_bill="+ToStrSQL(id_bill));
  ZQTax->Open();
  if (ZQTax->RecordCount!=0)
  {
  if (mmgg_bill < TDateTime(2014,3,1))
      Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
   else
   {
      if (mmgg_bill < TDateTime(2014,12,1))
        Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxN);
      else
      {
        if (mmgg_bill < TDateTime(2015,1,1))
          Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxN);
        else
          Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxN);

      }
   }


   fRepTaxN->ShowTaxNal(ZQTax->Fields->Fields[0]->AsInteger);
   ZQTax->Close();
   delete ZQTax;
   delete fRepTaxN;
   return;

  }
  ZQTax->Close();


  ShowMessage("До введения в действие нового порядка выписки налоговых накладных в январе 2015 года выписка налоговых накладных недоступна!");
   return;


  if (MessageDlg(" Сформировать налоговую накладную ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   delete ZQTax;
   return;
  }

  ZQTax->Transaction->NewStyleTransactions=false;
  ZQTax->Transaction->TransactSafe=true;
  ZQTax->Transaction->AutoCommit=false;
  ZQTax->Transaction->Commit();
  ZQTax->Transaction->StartTransaction();


  AnsiString sqlstr="select acm_createTaxBill( :bill );";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  ZQTax->ParamByName("bill")->AsInteger=id_bill;

  try
   {
   ZQTax->ExecSql();
//   ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка формирования НН. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

    // если счет погашен кредитом, то ошибки не вылетело и НН не сформирована
    // сообщим об этом

    ZQTax->Sql->Clear();
    ZQTax->Sql->Add("select id_error from sys_error_tbl where  ident ='tax'");
    ZQTax->Open();
    int tax_ok = true;
    while(!(ZQTax->Eof))
    {   AnsiString err=" ";
        int id_err=ZQTax->Fields->Fields[0]->AsInteger;
        err=((TMainForm*)(Application->MainForm))->GetValueFromBase("select name from syi_error_tbl where id="+ToStrSQL(id_err));
        ShowMessage("Сообщение: "+err);

        if (id_err == 20) tax_ok = false;
        ZQTax->Next();
    };
    ZQTax->Close();

    if (!tax_ok)
     {
      ZQTax->Transaction->Commit();
      ZQTax->Transaction->AutoCommit=true;
      ZQTax->Transaction->TransactSafe=false;
      delete ZQTax;
      return;
     }


  sqlstr="select int_num, reg_date,id_doc,value_tax from acm_tax_tbl where id_doc=currval('dcm_doc_seq')";


  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
   ZQTax->Open();
  }
  catch(...)
  {
    ShowMessage("Ошибка.");
    ZQTax->Close();
    ZQTax->Transaction->Rollback();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;

  }

  int TaxNum =ZQTax->FieldByName("int_num")->AsInteger;
  TDateTime TaxDate =ZQTax->FieldByName("reg_date")->AsDateTime;
  id_tax = ZQTax->FieldByName("id_doc")->AsInteger;
  float value_tax = ZQTax->FieldByName("value_tax")->AsFloat;

  ZQTax->Close();

  if (TaxNum > 0)
  {

   Application->CreateForm(__classid(TfTaxParam), &fTaxParam);
   fTaxParam->edNum->Text =IntToStr(TaxNum);
   fTaxParam->edDt->Text  = FormatDateTime("dd.mm.yyyy",TaxDate);
   fTaxParam->CheckSum(value_tax);

   if (fTaxParam->ShowModal()!= mrOk)
    {
     delete fTaxParam;
     ZQTax->Transaction->Rollback();
     ZQTax->Transaction->AutoCommit=true;
     ZQTax->Transaction->TransactSafe=false;
     delete ZQTax;
     return ;
    };
   AnsiString NewTaxNum = fTaxParam->edNum->Text;
   TDateTime NewTaxDate = StrToDate(fTaxParam->edDt->Text);
   delete fTaxParam;

   if (NewTaxDate > Date())
   {
    if (MessageDlg(" Дата налоговой больше текущей даты. Продолжтиь ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    {
     ZQTax->Close();
     ZQTax->Transaction->Rollback();
     ZQTax->Transaction->AutoCommit=true;
     ZQTax->Transaction->TransactSafe=false;
     delete ZQTax;
     return;
    }
   }

  //   AnsiString NewTaxNum=InputBox("Номер налоговой накладной", "Создана Налоговая накладная с номером", IntToStr(TaxNum));
   if (StrToInt(NewTaxNum)!=TaxNum)
   {
     sqlstr="select acm_SetTaxNum(:num , currval('dcm_doc_seq')::::int );";
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);

    ZQTax->ParamByName("num")->AsInteger=StrToInt(NewTaxNum);

    try
    {
     ZQTax->ExecSql();
    }
    catch(EDatabaseError &e)
    {
     ShowMessage("Ошибка при установке номера НН. "+e.Message.SubString(8,200));
     ZQTax->Transaction->Rollback();
     ZQTax->Transaction->AutoCommit=true;
     ZQTax->Transaction->TransactSafe=false;
     delete ZQTax;
     return;
    }
   }

   if (NewTaxDate!=TaxDate)
    { sqlstr="update acm_tax_tbl set reg_date = :rdate where id_doc=currval('dcm_doc_seq');";
      ZQTax->Sql->Clear();
      ZQTax->Sql->Add(sqlstr);
      ZQTax->ParamByName("rdate")->AsDateTime=NewTaxDate;
      try
      {     ZQTax->ExecSql();
      }
      catch(EDatabaseError &e)
      {  ShowMessage("Ошибка при установке номера НН. "+e.Message.SubString(8,200));
         ZQTax->Transaction->Rollback();
         ZQTax->Transaction->AutoCommit=true;
         ZQTax->Transaction->TransactSafe=false;
         delete ZQTax;
         return;
      }
    }

   ZQTax->Transaction->Commit();
   ZQTax->Transaction->AutoCommit=true;
   ZQTax->Transaction->TransactSafe=false;

   // сразу печать

   if (id_tax!=0)
   {
    if (mmgg_bill < TDateTime(2014,3,1))
        Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
    else
    {
      if (mmgg_bill < TDateTime(2014,12,1))
        Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxN);
      else
      {
        if (mmgg_bill < TDateTime(2015,1,1))
          Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxN);
        else
          Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxN);

      }
    }

    fRepTaxN->ShowTaxNal(id_tax);
    delete fRepTaxN;
   }

   ZQTax->Close();
   ZQTax->Sql->Clear();
   ZQTax->Sql->Add("select id_doc from acm_taxcorrection_tbl where  id_bill = :bill");
   ZQTax->ParamByName("bill")->AsInteger=id_bill;
   ZQTax->Open();

   if (mmgg_bill < TDateTime(2014,3,1))
       Application->CreateForm(__classid(TfRepTaxCor), &fRepTaxCor);
   else
   {
     if (mmgg_bill < TDateTime(2014,12,1))
       Application->CreateForm(__classid(TfRepTaxCor2014), &fRepTaxCor);
     else
     {
      if (mmgg_bill < TDateTime(2015,1,1))
        Application->CreateForm(__classid(TfRepTaxCor2014_12), &fRepTaxCor);
      else
        Application->CreateForm(__classid(TfRepTaxCor2015), &fRepTaxCor);
     }
   }

   while(!(ZQTax->Eof))
   {
    fRepTaxCor->ShowTaxCor(ZQTax->Fields->Fields[0]->AsInteger,0);

    ZQTax->Next();
   };

   ZQTax->Close();
   delete fRepTaxCor;
  }
/*
  if (TaxNum == -1)
   ShowMessage("Налоговая накладная не нужна.");
  if (TaxNum == 0)
   ShowMessage("Ошибка формирования НН.");
*/

//  ShowMessage("Налоговая накладная успешно сформирована");
  delete ZQTax;
};



//ClientBillPred;
void __fastcall TfCliBill::ClientBillPred(TObject *Sender)
{    TWTPanel *TDoc;

  if (MessageDlg(" Сформировать счет на предоплату ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }


  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;
  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
//  ZQTax->Transaction->AutoCommit=false;

  AnsiString sqlstr="select crt_avans_bill( :cl,:dt );";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  ZQTax->ParamByName("cl")->AsInteger=fid_client;
  ZQTax->ParamByName("dt")->AsDateTime=Date();
  try
   {
   ZQTax->ExecSql();

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка формирования. "+e.Message.SubString(8,200));
//    ZQTax->Transaction->Rollback();
    ZQTax->Close();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
 };
 DBGrBill->Refresh();
}


void __fastcall TfCliBill::ClientBillInfl(TObject *Sender)
{    TWTPanel *TDoc;

  if (MessageDlg(" Сформировать счет на инфляцию ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;
  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
//  ZQTax->Transaction->AutoCommit=false;

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add("select value_ident from syi_sysvars_tbl where ident='mmgg'");
  ZQTax->Open();
  TDateTime dt=ZQTax->FieldByName("value_ident")->AsDateTime;
  AnsiString sqlstr="select calc_infl( :cl,:dt );";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  ZQTax->ParamByName("cl")->AsInteger=fid_client;
  ZQTax->ParamByName("dt")->AsDateTime=dt;
  try
   {
   ZQTax->ExecSql();
    TWTQuery *QuerBill=new TWTQuery(this);
    QuerBill->Sql->Clear();
    QuerBill->Sql->Add("select * from act_res_notice");
    QuerBill->Open();
   if (QuerBill->RecordCount>0)
   {    ClientKontrPotr(Sender);
   };

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка формирования. "+e.Message.SubString(8,200));
//    ZQTax->Transaction->Rollback();
    ZQTax->Close();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
 };
 //DBGrBill->Refresh();
 DBGrBill->DataSource->DataSet->Refresh();
}



void __fastcall TfCliBill::ClientBillPen(TObject *Sender)
{    TWTPanel *TDoc;

  if (MessageDlg(" Сформировать счет на пеню ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;
  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
//  ZQTax->Transaction->AutoCommit=false;

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add("select value_ident from syi_sysvars_tbl where ident='mmgg'");
  ZQTax->Open();
  TDateTime dt=ZQTax->FieldByName("value_ident")->AsDateTime;
  AnsiString sqlstr="select calc_pena( :cl,:dt );";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  ZQTax->ParamByName("cl")->AsInteger=fid_client;
  ZQTax->ParamByName("dt")->AsDateTime=dt;
  try
   {
   ZQTax->ExecSql();
   
    TWTQuery *QuerBill=new TWTQuery(this);
  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select * from act_res_notice");
   QuerBill->Open();
   if (QuerBill->RecordCount>0)
   {    ClientKontrPotr(Sender);
   };

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка формирования. "+e.Message.SubString(8,200));
//    ZQTax->Transaction->Rollback();
    ZQTax->Close();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
 };
 //DBGrBill->Refresh();
 DBGrBill->DataSource->DataSet->Refresh();
}
#define WinName "Список проблемного оборудования"
void _fastcall  TfCliBill::ClientKontrPotr(TObject *Sender)
{
try {
  TWTPanel *TDoc;
   int id_clientp=0;
   
  
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;

  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)(MPanel->Parent);
  // Если такое окно есть - активизируем и выходим
  if (((TMainForm*)(Application->MainForm))->ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTDoc *DocEqp=new TWTDoc(this,"");
  TWTPanel* PEqp=DocEqp->MainPanel->InsertPanel(100,true,200);
  TWTDBGrid* DBGrEqp=new TWTDBGrid(DocEqp, "act_res_notice");
  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PEqp->Params->AddText("Список проблемного оборудования",18,F,Classes::taCenter,false);
  PEqp->Params->AddGrid(DBGrEqp, true)->ID="Eqp";

   // TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,"act_res_eqp_err",false);
 // WGrid->SetCaption(Win ame);
  TWTTable* TableI = DBGrEqp->Table;
  // Добавляем поля для просмотра и для ограничения на наличие поля в справочнике
   DBGrEqp->SetReadOnly();
  TableI->Open();
  TableI->ReadOnly=true;
  TWTField *Field;
 // Field = WGrid->AddColumn("code_eqp", "№ обор"," ");
 // Field->SetWidth(200);
  //Field->SetRequired("Наименование  должно быть заполнено");
  Field = DBGrEqp->AddColumn("res", "Комментарии", "Комментарии");
  Field->SetWidth(500);
     DBGrEqp->Visible = true;

 DocEqp->SetCaption("Описание проблем");
 DocEqp->ShowAs(WinName);

 DocEqp->MainPanel->ParamByID("Eqp")->Control->SetFocus();
}
catch ( ... ){
ShowMessage("Установите обновление !!!");
}
};

#undef WinName


#define WinName "Сальдо клиента"
 __fastcall TfCliSaldDoc::TfCliSaldDoc(TWinControl *owner,  int fid_clien, TWTDBGrid *GrRefresh ):TWTDoc(Owner,"")
 {//TForm::OnClose=FormClose;
  fid_client=fid_clien;
  GrRef= GrRefresh;
   TWTQuery *QuerHead=new TWTQuery(this);
  QuerHead->Sql->Clear();
  QuerHead->Sql->Add("select * from acm_headpay_tbl where reg_num='saldo_kred'");
  QuerHead->Open();
  if (QuerHead->Eof)
  {  TWTQuery *QuerInsHead=new TWTQuery(this);
     QuerHead->Sql->Clear();
     QuerHead->Sql->Add("insert into acm_headpay_tbl \
     ( dt,reg_num,reg_date,mmgg_hpay,mmgg ) \
     values (now(),'saldo_kred',now(),fun_mmgg(),fun_mmgg() ) ");
    QuerHead->ExecSql();


    TWTQuery *QuerSeqHead=new TWTQuery(this);
    QuerSeqHead->Sql->Clear();
    QuerSeqHead->Sql->Add("select currval('acm_headpay_seq') ");
    QuerSeqHead->Open();
    fid_headpay =QuerSeqHead->FieldByName("currval")->AsInteger;
    DEL(QuerSeqHead);

  }
  else{
     fid_headpay =QuerHead->FieldByName("id")->AsInteger;
  };

  QuerHead->Sql->Clear();
  QuerHead->Sql->Add("select * from dci_document_tbl where ident='saldo'");
  QuerHead->Open();
   fid_saldo =QuerHead->FieldByName("id")->AsInteger;

  DEL(QuerHead);
 AnsiString NameCl=" ";
 TWTQuery * QuerBill=new TWTQuery(this);
 QuerBill->Sql->Add("select b.*,b.value+b.value_tax as all_value from acm_bill_tbl b ,\
        dci_document_tbl d where b.idk_doc=d.id and d.ident='saldo' \
        and id_client="+IntToStr(fid_clien));

  TWTQuery *NCli=new TWTQuery(this);
  NCli->Sql->Add("select * from clm_client_tbl where id=:pid");
  NCli->ParamByName("pid")->AsInteger=fid_client;
  NCli->Open();
  NameCl=NCli->Fields->Fields[0]->AsString;
  DEL(NCli);

  TWTDBGrid* DBGrBill=new TWTDBGrid(this, QuerBill);

  TWTPanel* PBill=MainPanel->InsertPanel(800,true,300);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;

  PBill->Params->AddText("Дебетовое сальдо"+NameCl,10,F,Classes::taCenter,true)->ID="NameBill";

  PBill->Params->AddGrid(DBGrBill,true)->ID="Bill";

  DBGrBill->Query->AddLookupField("name_pref", "id_pref", "aci_pref_tbl", "NAME","id");
  DBGrBill->Query->AddLookupField("kind_doc", "idk_doc", "dci_document_tbl", "NAME","id");
  DBGrBill->Query->Open();
  TDataSource *DataSource=DBGrBill->DataSource;
  TWTField *Field;

  Field = DBGrBill->AddColumn("name_pref", "Вид", "Вид");
  Field->SetRequired("Вид счета");
  Field->SetWidth(120);

  Field = DBGrBill->AddColumn("mmgg_bill", "Период" , "Месяц");
  Field->SetWidth(90);
  /*  Field = DBGrBill->AddColumn("reg_num", "Номер", "Номер счета");
  Field->SetRequired("Номер  должен быть заполнен");
  Field->SetWidth(120);

  Field = DBGrBill->AddColumn("reg_date", "Дата", "Дата");
  Field->SetRequired("Дата должна быть заполнена");
  Field->SetWidth(90);
 */
  Field = DBGrBill->AddColumn("Value", "Сумма" , "Сумма");
   Field->Precision=2;
  Field->OnChange=OnChange;
  Field = DBGrBill->AddColumn("Value_tax", "НДС" , "НДС");
   Field->Precision=2;
  Field->OnChange=OnChange;
  Field = DBGrBill->AddColumn("all_value", "Итого" , "Итого  ");
  Field = DBGrBill->AddColumn("mmgg", "Месяц" , "Месяц");
  Field->SetWidth(90);
 // Field->SetReadOnly();
  TStringList *WList=new TStringList();
  WList->Add("id_doc");
  TStringList *NList=new TStringList();
  NList->Add("all_value");

  QuerBill->SetSQLModify("acm_bill_tbl",WList,NList,true,true,true);
  DBGrBill->AfterInsert=InsBill;

  TWTPanel* PPay=MainPanel->InsertPanel(300,true,200);
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PPay->Params->AddText("Кредитовое сальдо",18,F,Classes::taCenter,false);
   TWTQuery * QuerPay=new TWTQuery(this);
     QuerPay->Sql->Add("select p.* from acm_pay_tbl p,\
     dci_document_tbl d where p.idk_doc=d.id and d.ident='saldo' \
      and id_client="+IntToStr(fid_clien));

  TWTDBGrid* DBGrPay = new TWTDBGrid(this, QuerPay);
  PPay->Params->AddGrid(DBGrPay, true)->ID="Pay";
  DBGrPay->Query->AddLookupField("name_pref", "id_pref", "aci_pref_tbl", "NAME","id");
  DBGrPay->Query->AddLookupField("kind_doc", "idk_doc", "dci_document_tbl", "NAME","id");
 //  DBGrPay->Query->Close=FormClose;
  DBGrPay->Query->Open();
  DBGrPay->Query->IndexFieldNames = "";

  TStringList *WListP=new TStringList();
  WListP->Add("id_doc");
  TStringList *NListP=new TStringList();
  QuerPay->SetSQLModify("acm_pay_tbl",WListP,NListP,true,true,true);
  DBGrPay->AfterInsert=InsPay;
 // DBGrPay->BeforePost=BefPostPay;

 TWTField *FieldP;
/*  FieldP = DBGrPay->AddColumn("reg_num", "Номер ", "Номер отчета");
  FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("reg_date", "Дата ", "Дата отчета");
  FieldP->SetWidth(80);
*/
  FieldP = DBGrPay->AddColumn("name_pref", "Вид", "Вид");
  FieldP->SetRequired("Вид счета");
  FieldP->SetWidth(120);

  FieldP = DBGrPay->AddColumn("mmgg_hpay", "Период возникновения" , "Месяц");
  FieldP->OnChange=OnChangeHPay;
  FieldP->SetWidth(90);

  FieldP = DBGrPay->AddColumn("mmgg_pay", "Период для погашения" , "Месяц");
  //FieldP->OnChange=OnChangeHPay;
  FieldP->SetWidth(90);

  FieldP = DBGrPay->AddColumn("value", "Сумма", "Сумма");
  FieldP->Precision=2;
  FieldP->OnChange=OnChangeP;
  FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("value_tax", "Ндс", "Ндс");
  FieldP->Precision=2;
  FieldP->OnChange=OnChangeP;
  FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("value_pay", "С НДС", "Сумма");
  FieldP->Precision=2;
  FieldP->SetWidth(100);


  FieldP = DBGrPay->AddColumn("mmgg", "Месяц" , "Месяц");
  FieldP->SetWidth(90);

  MainPanel->SetVResize(100);
  ShowAs(WinName);
  SetCaption("Счета "+ NameCl); //не должно содержать "["
  // обязательно для загрузки отчета из файла. должно идти после SetCaption
  //DocAdr->ID="AdmAdrM";
  //LoadFromFile(DocBill->DocFile);
  MainPanel->ParamByID("Bill")->Control->SetFocus();
  MainPanel->ParamByID("Pay")->Control->SetFocus();
  MainPanel->ParamByID("Bill")->Control->SetFocus();

};

__fastcall TfCliSaldDoc::~TfCliSaldDoc()
{      GrRef->DataSource->DataSet->Refresh();
        GrRef->Refresh();
  Close();


};

void _fastcall TfCliSaldDoc::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

};



void _fastcall  TfCliSaldDoc::OnChange(TWTField *Sender)
{
  TWTQuery *Query = (TWTQuery *)Sender->Field->DataSet;

  TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  float nds=Round(QuerTax->Fields->Fields[0]->AsFloat,2);
  DEL(QuerTax);
   if (Sender->Field->Name=="value") {
    Query->FieldByName("value_tax")->AsFloat= Round(Sender->Field->AsFloat*nds/100,2);
    Query->FieldByName("all_value")->AsFloat= Sender->Field->AsFloat+Query->FieldByName("value_tax")->AsFloat;
   } else
   { if (Sender->Field->Name=="value_tax") {
         Query->FieldByName("all_value")->AsFloat= Query->FieldByName("value")->AsFloat+Sender->Field->AsFloat;
     };
   };
 return;
};

void _fastcall  TfCliSaldDoc::OnChangeP(TWTField *Sender)
{
  TWTQuery *Query = (TWTQuery *)Sender->Field->DataSet;

  TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  float nds=Round(QuerTax->Fields->Fields[0]->AsFloat,2);
  DEL(QuerTax);
   if (Sender->Field->Name=="value") {
    Query->FieldByName("value_tax")->AsFloat= Round(Sender->Field->AsFloat*nds/100,2);
    Query->FieldByName("value_pay")->AsFloat= Sender->Field->AsFloat+Query->FieldByName("value_tax")->AsFloat;
   } else
   { if (Sender->Field->Name=="value_tax") {
         Query->FieldByName("value_pay")->AsFloat= Query->FieldByName("value")->AsFloat+Sender->Field->AsFloat;
     };
   };
 return;
};


void _fastcall  TfCliSaldDoc::OnChangeHPay(TWTField *Sender)
{
  TWTQuery *Query = (TWTQuery *)Sender->Field->DataSet;

    Query->FieldByName("mmgg_pay")->AsDateTime= Sender->Field->AsDateTime;
 return;
};

void _fastcall TfCliSaldDoc::InsBill(TWTDBGrid *Sender) {
  TWTDBGrid *GrBill= Sender;
  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=fid_client;
  Sender->DataSource->DataSet->FieldByName("reg_num")->AsString="saldo_deb";
  Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime=Date();
  Sender->DataSource->DataSet->FieldByName("idk_doc")->AsInteger=fid_saldo;
}

void _fastcall TfCliSaldDoc::InsPay(TWTDBGrid *Sender) {
  TWTDBGrid *GrBill= Sender;


   Sender->DataSource->DataSet->FieldByName("id_headpay")->AsInteger=fid_headpay;
  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=fid_client;
  Sender->DataSource->DataSet->FieldByName("reg_num")->AsString="saldo_kred";
    Sender->DataSource->DataSet->FieldByName("sign_pay")->AsInteger=1;
  Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime=Date();
  Sender->DataSource->DataSet->FieldByName("idk_doc")->AsInteger=fid_saldo;
//  Sender->DataSource->DataSet->FieldByName("idk_doc")->AsInteger=fid_saldo;

}


//----------------------------------------------------------------------------

void __fastcall TfCliBill::ClientBill2kr(TObject *Sender)
{

  if (MessageDlg(" Проверить превышение лимитов ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTPanel *TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrBill= ((TWTDBGrid *)MPanel->ParamByID("Bill")->Control);
  int id_bill=GrBill->Query->FieldByName("id_doc")->AsInteger;
//  TDateTime mmgg =GrBill->Query->FieldByName("mmgg")->AsDateTime;

  TWTQuery * ZQDoc = new TWTQuery(Application);
  ZQDoc->Options<< doQuickOpen;
  ZQDoc->RequestLive=false;
  ZQDoc->CachedUpdates=false;
//  ZQDoc->Transaction->AutoCommit=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQDoc->Sql->Clear();
  ZQDoc->Sql->Add(sqlstr);

  try
  {
   ZQDoc->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка "+e.Message.SubString(8,200));
   ZQDoc->Close();
   delete ZQDoc;
   return;
  }
  ZQDoc->First();
  TDateTime mmgg = ZQDoc->FieldByName("mmgg")->AsDateTime;

  ZQDoc->Close();


   sqlstr="select crt_dem2krbill( :cl, :doc, :mmgg );";
  ZQDoc->Sql->Clear();
  ZQDoc->Sql->Add(sqlstr);
  ZQDoc->ParamByName("cl")->AsInteger=fid_client;
  ZQDoc->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQDoc->ParamByName("doc")->Clear();

  try
   {
   ZQDoc->ExecSql();

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка формирования. "+e.Message.SubString(8,200));
    ZQDoc->Close();
    delete ZQDoc;
    return;
   };

 // ShortDateFormat="dd.mm.yyyy";
  ZQDoc->Sql->Clear();
    ZQDoc->Sql->Add("select id_error from sys_error_tbl where  nam ='2kr'");
    ZQDoc->Open();
    if(!(ZQDoc->Eof))
    {   AnsiString err=" ";
        int id_err=ZQDoc->Fields->Fields[0]->AsInteger;
        err=((TMainForm*)(Application->MainForm))->GetValueFromBase("select name from syi_error_tbl where id="+ToStrSQL(id_err));
        ShowMessage("Сообщение: "+err);
 //       ShortDateFormat="dd.mm.yyyy";

    };
    ZQDoc->Close();

 //   ShortDateFormat="dd.mm.yyyy";


// DBGrBill->Refresh();
}

#define WinName "Детализация счета"
 __fastcall TfCliBillDetal::TfCliBillDetal(TWinControl *owner,  int id_doc ):TWTDoc(Owner,"")
 {//TForm::OnClose=FormClose;
  fid_doc=id_doc;

   TWTQuery *QuerHead=new TWTQuery(this);
  QuerHead->Sql->Clear();
  QuerHead->Sql->Add("select c.*,date_mi(c.dat_e,c.dat_b)::::int+1::::int as period \
      from acd_clc_inf c where id_doc=:pid_doc and  date_mi(c.dat_e,c.dat_b)::::int>0 ");
  QuerHead->ParamByName("pid_doc")->AsInteger=fid_doc;
  QuerHead->Open();

   TWTQuery *QuerDet=new TWTQuery(this);
  QuerDet->Sql->Clear();
  QuerDet->Sql->Add("select id_doc,dat,ident, \
   case when ident='pay' then pay_num else bill_num  end as num_doc, \
   case when ident='pay' then pay_date else bill_date  end as date_doc, \
   summ,ident1 \
   from (select b.*,p.reg_num as pay_num,p.reg_date as pay_date  \
          from  (select c.*,b.reg_num as bill_num,b.reg_date as bill_date  \
                  from acd_summ_val c  \
                         left join acm_bill_tbl b on b.id_doc=c.id_p_doc  \
                 ) as b \
             left join    acm_pay_tbl p on p.id_doc=b.id_p_doc \
          ) as r \
    where id_doc=:pid_doc and ident <>'se' \
        order by id_doc,ident1,dat ");
  QuerDet->ParamByName("pid_doc")->AsInteger=fid_doc;
  QuerDet->ReadOnly=true;
  QuerDet->Open();

   TWTDBGrid* DBGrHead=new TWTDBGrid(this, QuerHead);

  TWTPanel* PHead=MainPanel->InsertPanel(800,true,300);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;

  PHead->Params->AddText("Расчитанные суммы",10,F,Classes::taCenter,true)->ID="NameBill";

  PHead->Params->AddGrid(DBGrHead,true)->ID="Head";

  DBGrHead->Query->Open();
  TDataSource *DataSource=DBGrHead->DataSource;
  TWTField *Field;

  Field = DBGrHead->AddColumn("dat_b", "C даты", "По дату");
  Field->SetWidth(120);

  Field = DBGrHead->AddColumn("dat_e", "По дату" , "По дату");
  Field->SetWidth(120);

  Field = DBGrHead->AddColumn("period", "дней" , "дней");
  Field->SetWidth(90);

  Field = DBGrHead->AddColumn("summ", "Сумма основания" , "Сумма");
  Field->SetWidth(120);

  Field = DBGrHead->AddColumn("k_inf", "коеф" , "коеф");
  Field->SetWidth(90);

  Field = DBGrHead->AddColumn("sum_inf", "Сумма штрафа" , "Сумма");
  Field->SetWidth(120);

  Field = DBGrHead->AddColumn("mmgg", "Месяц" , "Месяц");
  Field->SetWidth(90);

 // Field->SetReadOnly();
  TStringList *WList=new TStringList();
  WList->Add("id_doc");
  TStringList *NList=new TStringList();


  QuerHead->SetSQLModify("acd_clc_inf",WList,NList,false,false,false);

  TWTPanel* PDet=MainPanel->InsertPanel(300,true,200);
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PDet->Params->AddText("Документы",18,F,Classes::taCenter,false);
   TWTDBGrid* DBGrDet = new TWTDBGrid(this, QuerDet);
  PDet->Params->AddGrid(DBGrDet, true)->ID="Det";
  DBGrDet->Query->Open();

  TStringList *WListP=new TStringList();
  WListP->Add("id_doc");
  TStringList *NListP=new TStringList();
  QuerDet->SetSQLModify("acd_summ_val",WListP,NListP,false,false,false);

 TWTField *FieldP;

  FieldP = DBGrDet->AddColumn("ident1", "Раздел", "Вид");
   FieldP->AddFixedVariable("act_ee", "активная");
   FieldP->AddFixedVariable("react_ee","реактивняя ");
   FieldP->AddFixedVariable("inf","инфляция ");

  FieldP = DBGrDet->AddColumn("dat","Дата ", "Дата");
   FieldP->SetWidth(120);

  FieldP = DBGrDet->AddColumn("ident", "Вид", "Вид");
   FieldP->AddFixedVariable("sb", "Сальдо");
   FieldP->AddFixedVariable("bil","Счет ");
   FieldP->AddFixedVariable("pay","Платеж ");
   FieldP->SetWidth(120);

  FieldP = DBGrDet->AddColumn("num_doc", "Номер документа" , "Месяц");
  FieldP->SetWidth(90);

  FieldP = DBGrDet->AddColumn("date_doc", "Дата документа" , "Месяц");
  FieldP->SetWidth(90);

  FieldP = DBGrDet->AddColumn("summ", "Сумма", "Сумма");
  FieldP->Precision=2;
 FieldP->SetWidth(100);


  MainPanel->SetVResize(100);
  ShowAs(WinName);
  SetCaption(WinName); //не должно содержать "["
  // обязательно для загрузки отчета из файла. должно идти после SetCaption
  //DocAdr->ID="AdmAdrM";
  //LoadFromFile(DocBill->DocFile);
  MainPanel->ParamByID("Head")->Control->SetFocus();
  MainPanel->ParamByID("Det")->Control->SetFocus();
  MainPanel->ParamByID("Head")->Control->SetFocus();

};

__fastcall TfCliBillDetal::~TfCliBillDetal()
{       Close();


};

void _fastcall TfCliBillDetal::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

};

void __fastcall TfCliBill::ClientPret(TObject *Sender)
{    TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrBill= ((TWTDBGrid *)MPanel->ParamByID("Bill")->Control);

  TfPenaInflPrint *fPenaInflPrint;
  Application->CreateForm(__classid(TfPenaInflPrint), &fPenaInflPrint);
  fPenaInflPrint->mmgg =  GrBill->Query->FieldByName("mmgg")->AsDateTime;
  fPenaInflPrint->id_client = GrBill->Query->FieldByName("id_client")->AsInteger;
  fPenaInflPrint->ShowModal();
  delete fPenaInflPrint;
}





//------------------------------------------------------------------------------
void __fastcall TfCliBill::DelBill(TObject* Sender)
{
 try
 {
  if (QuerBill->FieldByName("flag_transmis")->AsInteger ==1)
  {
   ShowMessage("Счет выдан. Невозможно удалить! ");
   return;
  }

  if (QuerBill->FieldByName("flock")->AsInteger ==1)
  {
   ShowMessage("Закрытый период. Невозможно удалить! ");
   return;
  }

  if (MessageDlg(" Удалить счет ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * QDelBill = new TWTQuery(this);
  QDelBill->Options<< doQuickOpen;
  QDelBill->Sql->Add("delete from acm_bill_tbl where id_doc = :id_doc; ");

  if (QuerBill->FieldByName("idk_doc")->AsInteger ==210)
  {

   TWTQuery * qStCl = new TWTQuery(this);
   qStCl->Sql->Clear();
   qStCl->Sql->Add("Select * from clm_statecl_h where id_client=:pid_client \
       and mmgg_b<=:reg_datep and coalesce(mmgg_e,:reg_datep)>=:reg_datep ");

   qStCl->ParamByName("pid_client")->AsInteger=fid_client;
   qStCl->ParamByName("reg_datep")->AsDateTime=QuerBill->FieldByName("reg_date")->AsDateTime;

   qStCl->Open();

   if ((qStCl->Eof))
   { ShowMessage ("Нет действующего договора клиента на дату:"+DateToStr(QuerBill->FieldByName("reg_date")->AsDateTime));
     return;
   }
   else
   {
    if (qStCl->FieldByName("flag_del2kr")->AsInteger ==1 )
    {
      //OldDelBill(Sender);
      QDelBill->ParamByName("id_doc")->AsInteger=QuerBill->FieldByName("id_doc")->AsInteger;
      QDelBill->ExecSql();

      QuerBill->Refresh();
      return;
    }
    else
     ShowMessage("Для данного абонента запрещено удаление счетов за превышение договорных величин потребления! ");
   };
  }
  else
  {
//   OldDelBill(Sender);
   QDelBill->ParamByName("id_doc")->AsInteger=QuerBill->FieldByName("id_doc")->AsInteger;
   QDelBill->ExecSql();

   QuerBill->Refresh();
  }

 }
 catch(EDatabaseError &e)
 {
  ShowMessage("Ошибка удаления счета"+e.Message.SubString(8,200));
 }
}
//------------------------------------------------------------------------------

#define WinName "Удаленные счета"
 __fastcall TfCliBillDel::TfCliBillDel(TWinControl *owner,  int id_client ):TWTDoc(Owner,"")
 {//TForm::OnClose=FormClose;
  fid_client=id_client;

   TWTQuery *QuerHead=new TWTQuery(this);
  QuerHead->Sql->Clear();
  QuerHead->Sql->Add("select b.*,b.value+b.value_tax as valtax  \
   from acm_bill_del as  b where id_client=:pid_client order by id_doc desc");
  QuerHead->ParamByName("pid_client")->AsInteger=fid_client;
  //QuerHead->Open();


   TWTDBGrid* DBGrBill=new TWTDBGrid(this, QuerHead);

  TWTQuery* QuerRep=new TWTQuery(this);
  QuerRep->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
  QuerRep->Sql->Add(" where  di.idk_document=dk.id and dk.ident='bill' " );
  QuerRep->Open();

     TWTQuery *pers=new TWTQuery(this);

   pers->Sql->Add("select p.id as id_person,u.id , \
     p.represent_name from syi_user as u left join clm_position_tbl as p on (p.id = u.id_person) \
     where flag_type = 0 and u.id_person is not null order by u.name;");
   pers->Open();

  DBGrBill->Query->AddLookupField("person","id_person",pers,"represent_name","id_person");
  DBGrBill->Query->AddLookupField("name_pref", "id_pref", "aci_pref_tbl", "NAME","id");
  DBGrBill->Query->AddLookupField("kind_doc", "idk_doc", QuerRep, "NAME","id");



  TWTPanel* PHead=MainPanel->InsertPanel(800,true,300);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;

  PHead->Params->AddText("Удаленные счета",10,F,Classes::taCenter,true)->ID="NameBill";

  PHead->Params->AddGrid(DBGrBill,true)->ID="Head";

  DBGrBill->Query->Open();
  TDataSource *DataSource=DBGrBill->DataSource;
  TWTField *Field;

     DBGrBill->SetReadOnly(true);
   Field = DBGrBill->AddColumn("name_pref", "Вид счета", "Вид счета");
   Field->SetRequired("Вид счета");
  Field->SetWidth(90);

  Field = DBGrBill->AddColumn("reg_num", "Номер", "Номер счета");
  Field->SetRequired("Номер  должен быть заполнен");
  Field->SetWidth(100);

  Field = DBGrBill->AddColumn("reg_date", "Дата", "Дата");
  Field->SetRequired("Дата должна быть заполнена");
  Field->SetWidth(90);

  Field = DBGrBill->AddColumn("demand_val", "КВТ" , "КВТ");
  Field->SetReadOnly(true);
  Field = DBGrBill->AddColumn("Value", "Сумма" , "Сумма");
  Field->SetReadOnly(true);
  Field = DBGrBill->AddColumn("Value_tax", "НДС" , "НДС");
  Field->SetReadOnly(true);
  Field = DBGrBill->AddColumn("valtax", "С НДС" , "С НДС  ");
  Field->SetReadOnly(true);

  Field = DBGrBill->AddColumn("kind_doc", "Вид документа", "Вид документа");
 //  Field->SetOnHelp(DckDocumentSpr);
  Field->SetWidth(100);

  Field = DBGrBill->AddColumn("mmgg_bill", "Период" , "Месяц");
  Field->SetWidth(90);

  Field = DBGrBill->AddColumn("mmgg", "Месяц" , "Месяц");
  Field->SetReadOnly(true);
  Field->SetWidth(90);


  Field = DBGrBill->AddColumn("id_doc", "№№" , "№№");
    Field->SetReadOnly(true);
  Field->SetWidth(90);

   Field = DBGrBill->AddColumn("dt", "изм" , "Изм");
    Field->SetReadOnly(true);
  Field->SetWidth(90);
    Field = DBGrBill->AddColumn("person", "сотрудник" , "сотрудник");
  Field->SetWidth(90);



 // Field->SetReadOnly();
  TStringList *WList=new TStringList();
  WList->Add("id_doc");
  TStringList *NList=new TStringList();
     NList->Add("valtax");

  QuerHead->SetSQLModify("acd_clc_inf",WList,NList,false,false,false);

   MainPanel->SetVResize(100);
  ShowAs(WinName);
  SetCaption(WinName); //не должно содержать "["
  // обязательно для загрузки отчета из файла. должно идти после SetCaption
  //DocAdr->ID="AdmAdrM";
  //LoadFromFile(DocBill->DocFile);
  MainPanel->ParamByID("Head")->Control->SetFocus();

};

__fastcall TfCliBillDel::~TfCliBillDel()
{       Close();


};

void _fastcall TfCliBillDel::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

};


