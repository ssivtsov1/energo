//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "BankScr.h"
#include "BankPScr.h"
#include "SysUser.h"
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

#pragma resource "*.dfm"
TFBankScr *FBankScr;
TFBankPScribe *FBankPScribe;
TFBankCheck *FBankCheck;
TWTDBGrid *WAbonGrid;
TWTDBGrid *WAbonAccount;

#include "FBankPrint.h"
#define WinName  "Банковская выписка"
void __fastcall TMainForm::AciHeadPayBtn(TObject *Sender)
{    TFBankScribe *WGrid;
     WGrid = new TFBankScribe(Application->MainForm);
};

__fastcall TFBankScribe::~TFBankScribe()
{
  Close();
};
_fastcall TFBankScribe::TFBankScribe(TWinControl *owner)  : TWTDoc(owner)
{ TWTPanel* PHead=MainPanel->InsertPanel(100,true,200);
int ChLevel =CheckLevel("Список банковских выписок");
  if  (ChLevel==0) {
     return;
   };
  MAIN_RES=((TMainForm*)MainForm)->GetIdFromBase("select value_ident from syi_sysvars_tbl where ident='id_res'","value_ident");
  TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  nds=QuerTax->Fields->Fields[0]->AsFloat;

  TButton *BtnPrnScr=new TButton(this);
     BtnPrnScr->Caption="Печать выписки";
     BtnPrnScr->OnClick=BankPrintP ;
     BtnPrnScr->Width=180;
     BtnPrnScr->Top=2;
     BtnPrnScr->Left=2;
  TButton *BtnCheck=new TButton(this);
     BtnCheck->Caption="Проверка выписки";
     BtnCheck->OnClick=BankCheck ;
     BtnCheck->Width=180;
     BtnCheck->Top=2;

   TButton *BtnBank=new TButton(this);
     BtnBank->Caption="Загрузка";
     BtnBank->OnClick=BankLoad ;
     BtnBank->Width=180;
     BtnBank->Top=2;

  TButton *BtnNull=new TButton(this);
    BtnNull->Caption="";
     BtnNull->Width=100;
     BtnNull->Top=2;
     BtnNull->Left=646;

  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;
  PBtnP->Params->AddButton(BtnPrnScr,false)->ID="BtnPrnScr";
    PBtnP->Params->AddButton(BtnCheck,false)->ID="BtnCheck";
        PBtnP->Params->AddButton(BtnBank,false)->ID="BtnBank";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";

  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;



  QuerHPay= new TWTQuery(this);
  QuerHPay->Close();

  QuerHPay->Sql->Clear();
  QuerHPay->Sql->Add(" \
   select h.*,pp.plus,pp.minus \
    from acm_headpay_tbl h left join  \
    ( select p.id_headpay,p.plus,m.minus  from  \
           ( select id_headpay,    sum(ptpl.value_pay) as plus \
                    from acm_pay_tbl ptpl \
                     where   ptpl.sign_pay=1                 \
                     group by id_headpay    )  as p          \
              left join \
                ( select  id_headpay,   sum(ptpl1.value_pay) as minus \
                        from  acm_pay_tbl ptpl1        \
                          where  ptpl1.sign_pay=-1      \
                    group by id_headpay    ) as m    \
          on (p.id_headpay=m.id_headpay)              \
     ) as pp                                                                 \
     on ( h.id=pp.id_headpay) where (reg_num<>'saldo_kred' or reg_num is null) \
     order by h.reg_date Desc");               \

 DBGrHPay=new TWTDBGrid(this, QuerHPay);

  PHead->Params->AddText("Список банковских выписок ",18,F,Classes::taCenter,false);
  PHead->Params->AddGrid(DBGrHPay, true)->ID="HeadPay";

  DBGrHPay->Query->AddLookupField("name_bank", "MFO_self", "cmi_bank_tbl", "NAME","id");
  DBGrHPay->Query->IndexDefs->Add("reg_date","reg_date" , TIndexOptions() << ixDescending	);
  DBGrHPay->Query->Open();

  TWTField *Field;
  Field = DBGrHPay->AddColumn("reg_num", "Номер ", "Номер отчета");
  Field->SetRequired("Номер  должен быть заполнен");
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("reg_date", "Дата ", "Дата отчета");
  Field->OnChange=OnChDate;
  Field->SetWidth(80);

  AnsiString ffself=((TMainForm*)MainForm)->GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='id_res'");
  TWTQuery *QuerRes= new TWTQuery(this);
  QuerRes->Sql->Clear();
  QuerRes->Sql->Add("select id from  clm_client_tbl where id="+ffself);
  QuerRes->Open();
  TField *fieldfself=new TField(this);
  fieldfself=QuerRes->FieldByName("id");
  Field = DBGrHPay->AddColumn("account_self", "Расчетный счет", "Расчетный счет");
  Field->SetRequired("Расчетный счет должен быть заполнен");
  Field->FieldLookUpFilter="id_client";
  Field->ExpFieldLookUpFilter=(TWTField*)fieldfself;
  Field->SetOnHelp(((TMainForm*)MainForm)->AccClientSpr);
  Field->SetWidth(100);
  Field->OnChange=OnChAccountSelf;
 // Field->SetOnValidate(OnChange);

  Field = DBGrHPay->AddColumn("mfo_self", "МФО", "МФО");
  Field->SetOnHelp(((TMainForm*)MainForm)->CmiBankSpr);
 // Field->OnChange=OnChMFOself;
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("plus", "Поступило", "Поступление");
  Field->Precision=2;
  Field->SetWidth(100);
  Field = DBGrHPay->AddColumn("minus", "Отправлено", "Отправлено");
  Field->Precision=2;
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("name_bank", "Банк", "Банк");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrHPay->AddColumn("name_file", "Номер файла", "Номер Файла");
  Field->SetWidth(150);

  Field = DBGrHPay->AddColumn("mmgg", "Месяц", "Месяц");
  Field->SetReadOnly();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
 // NList->Add("begs");
  NList->Add("plus");
  NList->Add("minus");
 // NList->Add("ends");
  DBGrHPay->Query->SetSQLModify("acm_headpay_tbl",WList,NList,true,true,true);
  if  (ChLevel==1) {
     DBGrHPay->ReadOnly=true;
   };

  DBGrHPay->BeforePost=BeforePostHead;
  TWTPanel* PPayGr=MainPanel->InsertPanel(800,true,500);
  DBGrHPay->ToolBar->AddButton("insp_ind", "Платежи физ абонентов", ShowPrivatePay);
   QuerPay= new TWTQuery(this);
   QuerPay->Close();
   QuerPay->Sql->Clear();

  QuerPay->Sql->Add(" \
   select p.* from acm_headpay_tbl h, acm_pay_tbl p  \
     where h.id=p.id_headpay and (h.flag_priv is null or h.flag_priv=false) \
     order by p.reg_num");


   DBGrPay=new TWTDBGrid(this, QuerPay);

  PPayGr->Params->AddText("Платежки ",18,F,Classes::taCenter,true);
  PPayGr->Params->AddGrid(DBGrPay, true)->ID="Pay";


  TWTQuery* QuerRep=new TWTQuery(this);
  QuerRep->Sql->Add("select di.id,di.name from dci_document_tbl di,dck_document_tbl dk " );
  QuerRep->Sql->Add(" where  di.idk_document=dk.id and dk.ident='pay' " );
  QuerRep->Open();

  TWTQuery* QuerCli=new TWTQuery(this);

  QuerCli->Sql->Add(" select id,name,short_name from clm_client_tbl where book<0 ");
  QuerCli->Open();

  QuerPay->AddLookupField("name_client","id_client",QuerCli,"short_name","id"); // Потом Name
  QuerPay->AddLookupField("name_pref","id_pref","aci_pref_tbl","name","id"); // Потом Name
  QuerPay->AddLookupField("kind_doc","idk_doc",QuerRep,"name","id"); // Потом Name
  QuerPay->AddLookupField("name_bank","mfo_client","cmi_bank_tbl","name","id");
  //QuerPay->AddLookupField("mmgg_p","mmgg_pay",QuerBill,"mmgg","mmgg"); // Потом Name
    QuerPay->Open();
    TStringList *WListP=new TStringList();
  WListP->Add("id_doc");

  TStringList *NListP=new TStringList();


   DBGrPay->Query->SetSQLModify("acm_pay_tbl",WListP,NListP,true,true,true);


  QuerPay->IndexFieldNames = "id_headpay";
  QuerPay->LinkFields = "id=id_headpay";
  QuerPay->MasterSource = DBGrHPay->DataSource;

  TWTField *FieldP;
  FieldP = DBGrPay->AddColumn("reg_num", "Номер ", "Номер отчета");
  FieldP->SetRequired("Номер  должен быть заполнен");
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("reg_date", "Дата ", "Дата отчета");
  FieldP->SetRequired("Дата должна быть заполнена");
  FieldP->OnChange=OnChDate;
  FieldP->SetWidth(60);

  FieldP = DBGrPay->AddColumn("account_client", "Расчетный счет", "Расчетный счет");
  FieldP->SetWidth(100);
  FieldP->OnChange=ChClientAccount;

  FieldP = DBGrPay->AddColumn("MFO_client", "MFO", "MFO");
  FieldP->SetWidth(50);
  FieldP->SetReadOnly();

  FieldP = DBGrPay->AddColumn("Name_client", "Клиент", "Банк");
  FieldP->SetOnHelp(((TMainForm*)MainForm)->CliClientMSpr);
  FieldP->SetWidth(150);

   FieldP = DBGrPay->AddColumn("mmgg_pay", "Пер.оплаты", "Пер.оплаты");
   FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("value_pay", "Сумма", "Сумма");
  FieldP->OnChange=OnChangePay;
  FieldP->Precision=2;
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("value_tax", "НДС", "НДС");
    FieldP->OnChange=OnChangeTax;
  FieldP->Precision=2;
  FieldP->SetWidth(80);

  FieldP = DBGrPay->AddColumn("value", "Без НДС", "Сумма");
  FieldP->Precision=2;
  FieldP->SetWidth(80);
 // FieldP->SetReadOnly();

  FieldP = DBGrPay->AddColumn("sign_pay", "Знак", "Знак");
  FieldP->AddFixedVariable("-1", '-');
  FieldP->AddFixedVariable("1",'+');
  FieldP->SetDefValue("1");
  FieldP->SetWidth(26);

  FieldP = DBGrPay->AddColumn("pay_date", "Дата платежа", "Дата платежа");
    FieldP->SetWidth(100);

  FieldP = DBGrPay->AddColumn("name_pref", "Назн", "Назначение");
  FieldP->SetWidth(60);

  FieldP = DBGrPay->AddColumn("kind_doc", "Тип", "Тип");
  FieldP->SetWidth(60);

  FieldP = DBGrPay->AddColumn("comment", "Примечание", "Примечание");
  FieldP->SetWidth(100);
  FieldP = DBGrPay->AddColumn("Name_bank", "Банк", "Банк");
  FieldP->SetOnHelp(((TMainForm*)MainForm)->CmiBankSpr);
  FieldP->SetWidth(100);
  if  ( (ChLevel==3) || (ChLevel==-1) ) {
     DBGrPay->ToolBar->AddButton("InsForm", "Ввод данных", ClientPayIns);
   };


  TWTToolBar* tb=DBGrPay->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
      if ( btn->ID=="NewRecord")
            tb->Buttons[i]->OnClick=ClientPayIns;
     };

 /* DBGrPay->AfterInsert=BeforeInsertPay;
  DBGrPay->AfterPost=AfterPostPay;
   */
   DBGrPay->OnAccept=PayAccept;
   DBGrPay->BeforePost=PostPay;
   DBGrPay->OnDrawColumnCell=PayDrawColumnCell;

     if  (ChLevel==1) {
     DBGrPay->ReadOnly=true;
   };
  DBGrHPay->Visible = true;

 SetCaption("Банковская выписка ");
 ShowAs(WinName);
 MainPanel->ParamByID("HeadPay")->Control->SetFocus();
 MainPanel->ParamByID("Pay")->Control->SetFocus();
 MainPanel->ParamByID("HeadPay")->Control->SetFocus();
};

#undef WinName



void __fastcall  TFBankScribe::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

void __fastcall TFBankScribe::PayDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   float pay;
    float tax;
    float all;
 TDBGrid* t=(TDBGrid*)Sender;
 pay =t->DataSource->DataSet->FieldByName("value")->AsFloat;
 tax =t->DataSource->DataSet->FieldByName("value_tax")->AsFloat;
 all =t->DataSource->DataSet->FieldByName("value_pay")->AsFloat;

 
 //int ipay=(Round(pay,2)*100);
 //int itax=(Round(tax,2)*100);
 //int iall=(Round(all,2)*100);
 // long  iii= ipay+itax-iall;
 float  iii= pay+tax-all;
 
    if (Round(iii,2)!=0.00 )
     {    t->Canvas->Brush->Color=0x00F26D0B;
        t->Canvas->Font->Size=8;
       // t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };

    
    
   if ( (Round(Round(all/((100+nds)/nds),2)-Round(tax,2),2)!=0  && Round(tax,2)!=0))
     {    t->Canvas->Brush->Color=0x00caffff;
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
void _fastcall TFBankScribe::BeforePostHead(TWTDBGrid *Sender)
{  bool dublecod=false;
   TWTQuery *QCheck=new TWTQuery(this);
    QCheck->Sql->Clear();
    QCheck->Sql->Add("select id,mfo_self,account_self,reg_date \
      from acm_headpay_tbl  where mfo_self=:pmfo and \
      account_self=:paccount and reg_date=:pdate");
        QCheck->ParamByName("pmfo")->AsInteger=Sender->DataSource->DataSet->FieldByName("mfo_self")->AsInteger;
        QCheck->ParamByName("pdate")->AsDateTime=Sender->DataSource->DataSet->FieldByName("reg_date")->AsDateTime;
         QCheck->ParamByName("paccount")->AsString=Sender->DataSource->DataSet->FieldByName("account_self")->AsString;

       // QCheck->ParamByName("pid")->AsInteger=Sender->DataSource->DataSet->FieldByName("id")->AsInteger;
      QCheck->Open();
    if (!(QCheck->Eof))
    {    if (QCheck->FieldByName("id")->AsInteger!=Sender->DataSource->DataSet->FieldByName("id")->AsInteger)
        {
         ShowMessage("Дублирование банковских выписок!");
         Sender->DataSource->DataSet->Cancel();
         };
     };
DEL(QCheck);
};

void _fastcall TFBankScribe::PostPay(TWTDBGrid *Sender)
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

void _fastcall  TFBankScribe::OnChAccountSelf(TWTField  *Sender)
{  TWTQuery *Quer=new TWTQuery(this);
   Quer->Sql->Clear();
    Quer->Sql->Add("select * from cli_account_tbl where account=:acc  \
     and id_client=:res");
     Quer->ParamByName("acc")->AsString=Sender->Field->AsString;
     Quer->ParamByName("res")->AsInteger=MAIN_RES;
     Quer->Open();
     if (Quer->Eof) {
           throw Exception("Нет такого расчетного счета! Откройте справочник");
        //ShowMessage("Нет такого расчетного счета! Откройте справочник");
        //DEL(Quer);
        //return;
        };
      Sender->Field->DataSet->FieldByName("mfo_self")->AsString=Quer->FieldByName("mfo")->AsString;
      DEL(Quer);
return;
};


void _fastcall  TFBankScribe::OnChMFOself(TWTField  *Sender)
{  TWTQuery *Quer=new TWTQuery(this);
   Quer->Sql->Clear();
    Quer->Sql->Add("select * from cli_account_tbl where mfo=:acc  \
     and id_client=:res");
     Quer->ParamByName("acc")->AsString=Sender->Field->AsString;
     Quer->ParamByName("res")->AsInteger=MAIN_RES;
     Quer->Open();
     if (Quer->Eof) {
        ShowMessage("Нет такого расчетного счета! Откройте справочник");
         DEL(Quer);
        return;
        };
      Sender->Field->DataSet->FieldByName("account_self")->AsString=Quer->FieldByName("account")->AsString;
      DEL(Quer);
return;
};

void _fastcall  TFBankScribe::OnChDate(TWTField  *Sender)
{  TWTQuery *Quer=new TWTQuery(this);
   Quer->Sql->Clear();
   TDateTime mg=Sender->Field->DataSet->FieldByName("mmgg")->AsDateTime;
   TDateTime bmg=BOM(Sender->Field->AsDateTime);
   if ( bmg!=mg)
    {  ShowMessage("Дата банковской выписки не принадлежит периоду!");
       return;
    };
};

void _fastcall  TFBankScribe::BankPrintP(TObject *Sender)
{
  TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrHPay= ((TWTDBGrid *)MPanel->ParamByID("HeadPay")->Control);
 // TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;

  int id_head=GrHPay->DataSource->DataSet->FieldByName("id")->AsInteger;
  //TfPrintDemand::ShowBill(int id_doc)
    Application->CreateForm(__classid(TfPrintBank), &fPrintBank);
    fPrintBank->ShowBill(id_head);


};

void _fastcall TFBankScribe::ChClientAccount(TWTField* Sender){
TWTQuery *Quer=new TWTQuery(this);
   Quer->Sql->Clear();
    Quer->Sql->Add("select * from cli_account_tbl where account=:acc  ");
     Quer->ParamByName("acc")->AsString=Sender->Field->AsString;
     Quer->Open();
     if (Quer->Eof) {
        ShowMessage("Нет такого расчетного счета! Откройте справочник");
         DEL(Quer);
        return;
        };
      Sender->Field->DataSet->FieldByName("mfo_client")->AsString=Quer->FieldByName("mfo")->AsString;
      Sender->Field->DataSet->FieldByName("id_client")->AsInteger=Quer->FieldByName("id_client")->AsInteger;

      DEL(Quer);
return;
};


void __fastcall TFBankScribe::ClientPayIns(TObject *Sender)
{    TWTDoc *TDoc;
  TDoc=(( TWTDoc *)(((TWinControl *)Sender)->Parent->Parent->Parent));
  TWTPanel *MPanel= ( TWTPanel *)TDoc->MainPanel;
  TWTDBGrid *GrPay= ((TWTDBGrid *)MPanel->ParamByID("Pay")->Control);
  TWTDBGrid *GrHeadPay= ((TWTDBGrid *)MPanel->ParamByID("HeadPay")->Control);
  int id_headpay=GrHeadPay->Query->FieldByName("id")->AsVariant;
  if (GrHeadPay->Query->FieldByName("flock")->AsInteger==1)
  {    ShowMessage("Запрещено добавлять платежи в закрытый период!");
       return;
  };
   Application->CreateForm(__classid(TFBankScr), &FBankScr);
    FBankScr->ShowFBank(id_headpay,0);

};


void __fastcall TFBankScribe::PayAccept(TObject *Sender)
{
  TWTDBGrid *GrPay= (TWTDBGrid *)Sender;
  int id_headpay=GrPay->Query->FieldByName("id_headpay")->AsVariant;
  int id_pay=GrPay->Query->FieldByName("id_doc")->AsVariant;
  Application->CreateForm(__classid(TFBankScr), &FBankScr);
  FBankScr->ShowFBankPay(id_headpay,id_pay);

};

void __fastcall TFBankScribe::BankCheck(TObject *Sender)
{
      TFBankCheck *WGrid;
     WGrid = new TFBankCheck(Application->MainForm);
  // Application->CreateForm(__classid(TFBankCheck), &FBankCheck);
  // FBankScr->ShowFBankPay(id_headpay,id_pay);

};
void __fastcall TFBankScribe::BankLoad(TObject *Sender)
{    TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrHPay= ((TWTDBGrid *)MPanel->ParamByID("HeadPay")->Control);
 // TDateTime mmgg_bill=GrHIndic->DataSource->DataSet->FieldByName("mmgg")->AsDateTime;

  int id_hpay=GrHPay->Query->FieldByName("name_file")->AsInteger;

  if (id_hpay==0)
  { ShowMessage("Не указан номер файла банковской выписки!!!");
     return;
  };
  TFBankLoad *WGrid;
   int pid_doc=id_hpay;
   WGrid = new TFBankLoad(Application->MainForm,pid_doc);
  // Application->CreateForm(__classid(TFBankCheck), &FBankCheck);
  // FBankScr->ShowFBankPay(id_headpay,id_pay);

};

void __fastcall TFBankScribe::OnChangePay(TWTField *Sender)
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

bool __fastcall TFBankScribe::CheckSum(float s1,float s2)
{ if ((Round(s1,0)<=0)&& (Round(s2,0)<=0) ) return true;
  if ((Round(s1,0)>=0)&& (Round(s2,0)>=0) ) return true;
    ShowMessage("Нельзя ввести в одном платеже положительную и отрицательную сумму!");
  return false;
};


void __fastcall TFBankScribe::OnChangeTax(TWTField *Sender)
{ AnsiString NField;
 NField=Sender->Field->Name;
 if  (NField=="value_tax")
  {
  Sender->Field->DataSet->FieldByName("value")->AsFloat=Sender->Field->DataSet->FieldByName("value_pay")->AsFloat- \
   Round(Sender->Field->AsFloat,2);
  };
};
#undef WinName
void __fastcall TFBankScribe::ShowPrivatePay(TObject *Sender)
{
      TFBankPScribe *WGrid;
      WGrid = new TFBankPScribe(Application->MainForm,QuerHPay->FieldByName("id")->AsInteger);
  // Application->CreateForm(__classid(TFBankCheck), &FBankCheck);
  // FBankScr->ShowFBankPay(id_headpay,id_pay);

};


//-  ************************************************************

//---------------------------------------------------------------------------
__fastcall TFBankScr::TFBankScr(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
QuerHeadPay->Database=TWTQuery::Database;
QuerPay->Database=TWTQuery::Database;
QuerHead=new TWTQuery(this);
QuerBill= new TWTQuery(this);
QuerRest= new TWTQuery(this);
}
//---------------------------------------------------------------------------

void __fastcall TFBankScr::ShowFBankPay(int id_hpay,int id_pay)
{
  fid_headpay=id_hpay;
  if (id_pay!=0) fid_pay=id_pay;
  else fid_pay=0;


   QuerHead->Sql->Clear();
   QuerHead->Sql->Add("select * from acm_headpay_tbl where id="+ToStrSQL(fid_headpay));
   QuerHead->Open();

   TWTQuery *QuerPay=new TWTQuery(this);
   QuerPay->Sql->Clear();
   QuerPay->Sql->Add("select p.*,c.code,c.book,c.name,s.* from acm_pay_tbl as p, clm_client_tbl as c, clm_statecl_tbl s");
   QuerPay->Sql->Add(" where p.id_doc="+ToStrSQL(fid_pay)+" and c.id=p.id_client and s.id_client=p.id_client");
   QuerPay->Open();
   if (QuerPay->Eof)
       ShowFBank(fid_headpay,0);
   else {
   fid_client=QuerPay->FieldByName("id_client")->AsInteger;
   EdRegNum->Text=QuerPay->FieldByName("reg_num")->AsString;
   EdRegDate->Text=FormatDateTime("dd.mm.yyyy",QuerPay->FieldByName("reg_date")->AsDateTime);
   EdCodeClient->Text=QuerPay->FieldByName("code")->AsString;;
   LabNClient->Caption=QuerPay->FieldByName("name")->AsString;;
   LabEdrpou->Caption=QuerPay->FieldByName("okpo_num")->AsString;;
//    LabNClient->Caption=QuerPay->FieldByName("name")->AsString;;
   EdBank->Text=QuerPay->FieldByName("mfo_client")->AsString;;
   EdAccount->Text=QuerPay->FieldByName("account_client")->AsString;
   EdPayDate->Text=FormatDateTime("dd.mm.yyyy",QuerPay->FieldByName("pay_date")->AsDateTime);
   EdValuePay->Text=QuerPay->FieldByName("value_pay")->AsString;
   EdValueTax->Text=QuerPay->FieldByName("value_tax")->AsString;
   EdValue->Text=QuerPay->FieldByName("value")->AsString;
   TWTQuery *QuerPref=new TWTQuery(this);
   QuerPref->Sql->Clear();
   fid_pref=QuerPay->FieldByName("id_pref")->AsInteger;
    QuerPref->Sql->Add("select id,name from aci_pref_tbl where id= "+ToStrSQL(fid_pref));
   QuerPref->Open();

   CBoxPay->Text=QuerPref->FieldByName("name")->AsString;
    TWTQuery *QuerType=new TWTQuery(this);
   QuerType->Sql->Clear();

   fid_tdoc=QuerPay->FieldByName("idk_doc")->AsInteger;
   QuerType->Sql->Add("select id,name from dci_document_tbl where id= "+ToStrSQL(fid_tdoc));
   QuerType->Open();
   CBoxType->Text=QuerType->FieldByName("name")->AsString;

   EdBillPay->Text=QuerPay->FieldByName("mmgg_pay")->AsString;
   EdComment->Text=QuerPay->FieldByName("comment")->AsString;
  };
  fid_sign=QuerPay->FieldByName("sign_pay")->AsInteger;
  if(fid_sign==1)
   RadGrPay->ItemIndex=1;
   else RadGrPay->ItemIndex=0;


   TWTQuery *QuerPref=new TWTQuery(this);
   QuerPref->Sql->Clear();
   QuerPref->Sql->Add("select id,name from aci_pref_tbl");
   QuerPref->ExecSql();
   QuerPref->Active=true;
 for (int i=0;i<QuerPref->RecordCount;i++)
 {
  CBoxPay->Items->Add(QuerPref->FieldByName("name")->AsString);
  QuerPref->Next();
 }


  TWTQuery *QuerType=new TWTQuery(this);
   QuerType->Sql->Clear();
   QuerType->Sql->Add("select id,name from dci_document_tbl where idk_document  \
       in (select id from dck_document_tbl where ident='pay')");
   QuerType->ExecSql();
   QuerType->Active=true;
 for (int i=0;i<QuerType->RecordCount;i++)
 {
  CBoxType->Items->Add(QuerType->FieldByName("name")->AsString);
  QuerType->Next();
 }

 ShowBill1(this);
}


  void __fastcall TFBankScr::ShowFBank(int id_hpay,int id_pay)
{
  fid_headpay=id_hpay;
  if (id_pay!=0) fid_pay=id_pay;

   QuerHead->Sql->Clear();
   QuerHead->Sql->Add("select * from acm_headpay_tbl where id="+ToStrSQL(fid_headpay));
   QuerHead->Open();
   EdRegNum->Text="";
   EdRegDate->Text=FormatDateTime("dd.mm.yyyy",QuerHead->FieldByName("reg_date")->AsDateTime);
   EdCodeClient->Text="";
   LabNClient->Caption="";
   LabEdrpou->Caption="";
   EdBank->Text="";
   EdAccount->Text="";
   EdPayDate->Text=FormatDateTime("dd.mm.yyyy",QuerHead->FieldByName("reg_date")->AsDateTime);
   EdValuePay->Text="0";
   EdValueTax->Text="0";
   EdValue->Text="0";
   CBoxPay->Text="";
   CBoxType->Text="";
   EdValue->Text="";
   EdBillPay->Text=FormatDateTime("dd.mm.yyyy",BOM(QuerHead->FieldByName("reg_date")->AsDateTime));

   EdComment->Text="";
   TWTQuery *QuerPay=new TWTQuery(this);
   QuerPay->Sql->Clear();
   QuerPay->Sql->Add("select * from aci_pref_tbl");
   QuerPay->ExecSql();
   QuerPay->Active=true;
 for (int i=0;i<QuerPay->RecordCount;i++)
 { if(QuerPay->FieldByName("ident")->AsString=="act_ee")
      CBoxPay->Text=QuerPay->FieldByName("name")->AsString;
  CBoxPay->Items->Add(QuerPay->FieldByName("name")->AsString);
  QuerPay->Next();
 }

 TWTQuery *QuerType=new TWTQuery(this);
   QuerType->Sql->Clear();
   QuerType->Sql->Add("select * from dci_document_tbl where idk_document  \
       in (select id from dck_document_tbl where ident='pay')");
   QuerType->ExecSql();
   QuerType->Active=true;
 for (int i=0;i<QuerType->RecordCount;i++)
 {
 if(QuerType->FieldByName("ident")->AsString=="pay")
      CBoxType->Text=QuerType->FieldByName("name")->AsString;
  CBoxType->Items->Add(QuerType->FieldByName("name")->AsString);
  QuerType->Next();
 }


  }
//---------------------------------------------------------------------------

void __fastcall TFBankScr::FormClose(TObject *Sender, TCloseAction &Action)
{
        TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

void __fastcall TFBankScr::EdIntKeyPress(TObject *Sender, char &Key)
{
  if (( Key==VK_BACK)||( Key==VK_TAB)||( Key==VK_ESCAPE)||( Key==VK_END)
  ||( Key==VK_HOME)||( Key==VK_LEFT)||  ( Key==VK_RIGHT)||( Key==VK_DELETE))
   {    return;
   };

   if ((Key > '9') || (Key < '0')) Key=NULL;
}

void __fastcall TFBankScr::EdFloatKeyPress(TObject *Sender, char &Key)
{    if (DecimalSeparator=='.')
      { if (Key==',')
         { Key='.';
          return;
         };
        if (Key=='.')
          return;
      }
       else
       { if (Key=='.')
         { Key=',';
         return;
         };
        if (Key==',')
             return;
        };

    if (Key=='-')
      { Key='-';
        return;
      }
     if (( Key==VK_SEPARATOR)||( Key==VK_BACK)||( Key==VK_TAB)||( Key==VK_ESCAPE)||( Key==VK_END)
  ||( Key==VK_HOME)||( Key==VK_LEFT)||  ( Key==VK_RIGHT)||( Key==VK_DELETE))
   {  Key=Key;
      return;
   };

     if ((Key > '9') || (Key < '0')) Key=NULL;

}
//---------------------------------------------------------------------------

void __fastcall TFBankScr::EdCodeClientChange(TObject *Sender)
{
    TWTQuery *QuerC=new TWTQuery(this);
  if (ALLTRIM(((TEdit*)Sender)->Text).IsEmpty()) return;
    QuerC->Sql->Add(" select c.id,c.code,c.name as namecl,c.id_state,c.dt_close,b.mfo,bn.name as namebn,b.account,s.* ");
    QuerC->Sql->Add(" from clm_client_tbl c left join cli_account_tbl b on (b.main=true and c.id=b.id_client) ");
    QuerC->Sql->Add(" left join cmi_bank_tbl bn on (b.mfo=bn.id),");
        QuerC->Sql->Add(" clm_statecl_tbl s");
    QuerC->Sql->Add(" where s.id_client=c.id and c.book=-1 and c.code="+ ToStrSQL(StrToInt(ALLTRIM(((TEdit*)Sender)->Text)))+"  ");
    //QuerC->ParamByName("pid_client")->AsInteger=StrToInt(ToStrSQL(((TEdit*)Sender)->Text));
    QuerC->Open();
    if (!(QuerC->Eof))
     {
         if   (QuerC->FieldByName("id_state")->AsInteger==50)
         {    ShowMessage("Абонент в АРХИВЕ!");
              fid_client=0;
              LabNClient->Caption="";
              LabEdrpou->Caption="";
              LabNBank->Caption="";
              EdBank->Text="";
              EdAccount->Text="";
             return;
         };

        if   (QuerC->FieldByName("id_state")->AsInteger==49)
         {    ShowMessage("Абонент закрыт!");

         };
      fid_client=QuerC->FieldByName("id")->AsInteger;
      LabNClient->Caption=QuerC->FieldByName("nameCl")->AsString;
      LabEdrpou->Caption=QuerC->FieldByName("okpo_num")->AsString;;
      LabNBank->Caption=QuerC->FieldByName("namebn")->AsString;
      EdBank->Text=QuerC->FieldByName("mfo")->AsString;
      EdAccount->Text=QuerC->FieldByName("account")->AsString;
      // QuerC->FieldByName("account")->Asinteger;
     }
     else
     { fid_client=0;
      LabNClient->Caption="";
      LabEdrpou->Caption="";
      LabNBank->Caption="";
      EdBank->Text="";
      EdAccount->Text="";

      };
       ShowBill1(this);
}



//---------------------------------------------------------------------------//---------------------------------------------------------------------------

void __fastcall TFBankScr::EdValuePayExit(TObject *Sender)
{ if (ALLTRIM(((TEdit*)Sender)->Text).IsEmpty()) return;
  AnsiString SValPay=ALLTRIM(((TEdit*)Sender)->Text);

  TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  float nds=QuerTax->Fields->Fields[0]->AsFloat;

 // EdValue->Text=FloatToStr(Round(((float)FValue)/100,2));

  float FValPay=Round(StrToFloat(SValPay),2);
  float FValTax=Round(FValPay/((100+nds)/nds),2);

  float FValue=Round(Round(FValPay,2)-Round(FValTax,2),2);

  
  int IValPay=Round(FValPay*100,2);
  int IValTax=Round(FValTax*100,2);
  int IValue=IValPay-IValTax;


  EdValueTax->Text=FloatToStr(Round(((float)IValTax)/100,2));
  EdValue->Text=FloatToStr(Round(((float)IValue)/100,2));
   float provtax=Round(FValue*(nds/100),2);
          if (Round(provtax,2)!=Round(FValTax,2))
                  ShowMessage("НДС не составляет 5 часть от суммы без НДС! Подкорректируйте пожалуйста!");

 };

//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

void __fastcall TFBankScr::EdValueTaxExit(TObject *Sender)
{
if (ALLTRIM(((TEdit*)Sender)->Text).IsEmpty()) return;
if (ALLTRIM(((TEdit*)EdValuePay)->Text).IsEmpty())
 { ShowMessage("Не заполнена сумма платежа!");
   return;
 };
   TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  float nds=QuerTax->Fields->Fields[0]->AsFloat;

  AnsiString SValTax=ALLTRIM(((TEdit*)Sender)->Text);
  AnsiString SValPay=ALLTRIM(((TEdit*)EdValuePay)->Text);
 // float FValPay=Round(StrToFloat(SValPay),2);
 // float FValTax=Round(StrToFloat(SValTax),2);
  int FValPay=Round(StrToFloat(SValPay)*100,2);
  int FValTax=Round(StrToFloat(SValTax)*100,2);
  int FValue=FValPay-FValTax;

  //EdValueTax->Text=FloatToStr(FValTax);
  EdValue->Text=FloatToStr(Round(((float)FValue)/100,2));
/*   int provtax=Round(FValue*(nds/100),2);
  if (Round(provtax,2)!=Round(FValTax,2))
         ShowMessage("НДС не составляет 5 часть от суммы без НДС! Подкорректируйте пожалуйста!");
  */
 };

//---------------------------------------------------------------------------



//---------------------------------------------------------------------------

bool  __fastcall TFBankScr::BtnOkClick(TObject *Sender)
{ AnsiString SRegNum="";
  TDateTime  SRegDate;
  int SIdClient;
  TDateTime  SDateMG;
  TDateTime  SDateMG0=0;
  int SMFOBank;
  AnsiString SAccount;
  TDateTime SPayDate;
  TDateTime SMgDate;
  AnsiString SValuePay="";
  float SValPay;
  AnsiString SValueTax;
  float SValTax;
   AnsiString SValue;
  float SVal;
  int SPref;
    int SType;
  AnsiString SBillPay;
  int SIdBillPay;
  AnsiString SComment;
  TWTQuery *QuerIns=new TWTQuery(this);
  TWTQuery *QuerCl=new TWTQuery(this);
  TWTQuery *QuerPref=new TWTQuery(this);
  TWTQuery *QuerMfo=new TWTQuery(this);
  TWTQuery *QuerAcc=new TWTQuery(this);
  TWTQuery *QuerBill=new TWTQuery(this);
  TWTQuery *QuerKind=new TWTQuery(this);
  int pkdoc;
  if (EdRegNum->Text.IsEmpty())
  { ShowMessage("Заполните номер платежки!");
     return false;
  };
  SRegNum=EdRegNum->Text;
   try {
   SRegDate=StrToDate(EdRegDate->Text);
   }
  catch (...)
  { ShowMessage("Проверте дату платежки!");
    return false;
   };
  try {
   SDateMG=StrToDate(EdBillPay->Text,"");
   }
  catch (...)
  { SDateMG=0;
   };
  if (EdAccount->Text.IsEmpty())
    {
    ShowMessage("Проверте расчетный счет!");
    return false;
    }
   else
  {  SAccount=EdAccount->Text;
   };
   try {
   SRegDate=StrToDate(EdRegDate->Text,"");
   }
  catch (...)
  { ShowMessage("Проверте дату платежки!");
    return false;
   };
    try {
   SMgDate=StrToDate(EdBillPay->Text,"");
   }
  catch (...)
  {
   };
  try {
   SPayDate=StrToDate(EdPayDate->Text,"");
   }
  catch (...)
  { ShowMessage("Проверте дату платежа!");
    return false;
   };
   if (EdCodeClient->Text.IsEmpty())
   { ShowMessage("Не заполнен лицевой клиента!");
      return false;
   };

   QuerCl->Sql->Add("select id from clm_client_tbl ");
   QuerCl->Sql->Add(" where id="+ToStrSQL(fid_client));
   QuerCl->Open();
   if (QuerCl->Eof)
   { ShowMessage("Нет такого лицевого счета! Вызовите справочник!");
      return false;
   };
    SIdClient=QuerCl->FieldByName("id")->AsInteger;

   if (!(EdBank->Text.IsEmpty()))
   {    QuerMfo->Sql->Add("select id from cmi_bank_tbl ");
    QuerMfo->Sql->Add(" where id="+ToStrSQL(StrToInt(EdBank->Text)));
    QuerMfo->Open();
    if (QuerMfo->Eof)
    { ShowMessage("Нет такого банка! Вызовите справочник!");
      return false;
    };
     SMFOBank=QuerMfo->FieldByName("id")->AsInteger;
    };

   if ((CBoxPay->Text.IsEmpty()))
      { ShowMessage("Не заполнено назначение платежа!");
         return false;
      };

    QuerPref->Sql->Add("select id from aci_pref_tbl  ");
    QuerPref->Sql->Add(" where name="+ToStrSQL(CBoxPay->Text));
    QuerPref->Open();
    if (QuerPref->Eof)
    { ShowMessage("Нет такого типа расчетов! Вызовите справочник!");
      return false;
    };
     SPref=QuerPref->FieldByName("id")->AsInteger;

    if ((CBoxType->Text.IsEmpty()))
      { ShowMessage("Не заполнен тип платежа!");
         return false;
      };

    TWTQuery *QuerType=new TWTQuery(this);
    QuerType->Sql->Clear();
     QuerType->Sql->Add("select id  from dci_document_tbl  ");
    QuerType->Sql->Add(" where name="+ToStrSQL(CBoxType->Text));
    QuerType->Open();
    if (QuerType->Eof)
    { ShowMessage("Нет такого типа расчетов! Вызовите справочник!");
      return false;
    };
     SType=QuerType->FieldByName("id")->AsInteger;



    if ( !CheckSum(Round(StrToFloat(EdValue->Text),2),Round(StrToFloat(EdValueTax->Text),2) ))
          return false;
 ShortDateFormat="yyyy-mm-dd";
   TWTQuery * QPay=new TWTQuery(this);
   QPay->Sql->Clear();
   QPay->Sql->Add("select * from acm_pay_tbl where id_doc="+ToStrSQL(fid_pay));
   QPay->Open();
   int fl_ins=0;
   if (QPay->Eof)
   {  fl_ins=1;
      QuerIns->Sql->Add("insert into acm_pay_tbl (id_headpay,idk_doc,sign_pay,reg_num,reg_date,id_client,mfo_client,account_client, ");
      QuerIns->Sql->Add(" pay_date,value_pay,value_tax,value,id_pref,comment,mmgg ");
    if (SDateMG!=SDateMG0)
     QuerIns->Sql->Add(" , mmgg_pay ");
     QuerIns->Sql->Add(" )");
     QuerIns->Sql->Add(" values (:pid_headpay,:pidk_doc,:psign_pay,:preg_num,:preg_date,");
     QuerIns->Sql->Add(":pid_client,:pmfo_client,:paccount_client, ");
     QuerIns->Sql->Add(" :ppay_date,:pvalue_pay,:pvalue_tax,:pvalue,:pid_pref,:pcomment,:pmmgg ");
     if (SDateMG!=SDateMG0)
      QuerIns->Sql->Add(" ,:pmmgg_pay ");
      QuerIns->Sql->Add(" )");
   }
   else
   {
      QuerIns->Sql->Add("update acm_pay_tbl set id_headpay=:pid_headpay,idk_doc=:pidk_doc,sign_pay=:psign_pay,reg_num=:preg_num,reg_date=:preg_date,");
      QuerIns->Sql->Add(" id_client=:pid_client,mfo_client=:pmfo_client,account_client=:paccount_client,  ");
      QuerIns->Sql->Add(" pay_date=:ppay_date,value_pay=:pvalue_pay,value_tax=:pvalue_tax,value=:pvalue, \
          id_pref=:pid_pref,comment=:pcomment,mmgg=:pmmgg ");
    if (SDateMG!=SDateMG0)
     QuerIns->Sql->Add(" , mmgg_pay=:pmmgg_pay ");
     QuerIns->Sql->Add(" where id_doc="+ToStrSQL(fid_pay));

   };
/*  QuerKind->Sql->Add("select id from dci_document_tbl where ident='pay'");
    QuerKind->Open();
   pkdoc=0;
   if (!(QuerKind->Eof))
   { pkdoc=QuerKind->FieldByName("id")->AsInteger;
   };
   */
   pkdoc=SType;
 int psign=0;
 if (RadGrPay->Items->Strings[RadGrPay->ItemIndex] == "Исходящие")
    psign=-1;
  else if (RadGrPay->Items->Strings[RadGrPay->ItemIndex] == "Входящие")
    psign=1;
  QuerIns->ParamByName("pid_headpay")->AsInteger=fid_headpay;
    QuerIns->ParamByName("pmmgg")->AsDateTime=QuerHead->FieldByName("mmgg")->AsDateTime;
  QuerIns->ParamByName("pidk_doc")->AsInteger=pkdoc;
  QuerIns->ParamByName("psign_pay")->AsInteger=psign;
  QuerIns->ParamByName("preg_num")->AsString=SRegNum;
  QuerIns->ParamByName("preg_date")->AsDateTime=SRegDate;
  QuerIns->ParamByName("pid_client")->AsInteger=SIdClient;
  QuerIns->ParamByName("pmfo_client")->AsInteger=SMFOBank;
  QuerIns->ParamByName("paccount_client")->AsString=SAccount;
  QuerIns->ParamByName("ppay_date")->AsDateTime=SPayDate;
  QuerIns->ParamByName("pvalue_pay")->AsFloat=Round(StrToFloat(EdValuePay->Text),2);
  QuerIns->ParamByName("pcomment")->AsString=EdComment->Text;
  QuerIns->ParamByName("pvalue_tax")->AsFloat=Round(StrToFloat(EdValueTax->Text),2);
  QuerIns->ParamByName("pvalue")->AsFloat=Round(StrToFloat(EdValue->Text),2);
  QuerIns->ParamByName("pid_pref")->AsInteger=SPref;
   if (SDateMG!=SDateMG0)
   QuerIns->ParamByName("pmmgg_pay")->AsDateTime=SMgDate;

  QuerIns->ExecSql();
  if (fl_ins==1)
   { TWTQuery *QuerIns=new TWTQuery(this);
    QuerIns->Sql->Add("select currval('dcm_doc_seq')::::int");
    QuerIns->Open();
    fid_pay=QuerIns->FieldByName("currval")->AsInteger;
    };
  ShortDateFormat="dd.mm.yyyy";
return true;
}
//---------------------------------------------------------------------------

void __fastcall TFBankScr::SBtnClientClick(TObject *Sender)
{
   // Выбрать абонента
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

  //WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
  WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;

}
//---------------------------------------------------------------------------

void __fastcall TFBankScr::AbonAccept (TObject* Sender)
{
   if(fid_client!=WAbonGrid->Query->FieldByName("id")->AsInteger)
   {

   };

   fid_client=WAbonGrid->Query->FieldByName("id")->AsInteger;
   EdCodeClient->Text=WAbonGrid->Query->FieldByName("code")->AsString;

};
void __fastcall TFBankScr::SBtnBankClick(TObject *Sender)
{
 TWTDBGrid* Grid;
  Grid=MainForm->AccClientSel(fid_client,NULL);
  if(Grid==NULL) return;
  else WAbonAccount=Grid;

  WAbonAccount->FieldSource = WAbonAccount->Table->GetTField("account");
  WAbonAccount->StringDest = "1";
  WAbonAccount->OnAccept=AbonAcceptAcc;
}

void __fastcall TFBankScr::AbonAcceptAcc (TObject* Sender)
{
   fid_account=WAbonAccount->Table->FieldByName("account")->AsString;
   fid_mfobank=WAbonAccount->Table->FieldByName("mfo")->AsString;
   EdBank->Text=fid_mfobank;
   EdAccount->Text=fid_account;
}

//---------------------------------------------------------------------------


bool __fastcall TFBankScr::CheckSum(float s1,float s2)
{ if ((Round(s1,0)<=0)&& (Round(s2,0)<=0) ) return true;
  if ((Round(s1,0)>=0)&& (Round(s2)>=0) ) return true;

  ShowMessage("Нельзя ввести в одном платеже положительную и отрицательную сумму!");
  return true;
};


void __fastcall TFBankScr::EdBillPayExit(TObject *Sender)
{    TMaskEdit *Send;
   Send=(TMaskEdit *)Sender;
       if (Send->Text=="__.__.____")
       { Send->Clear();
       }
}
//---------------------------------------------------------------------------




void __fastcall TFBankScr::RadGrPayExit(TObject *Sender)
{
 if(fid_sign==1) fid_sign=-1; else fid_sign=1;
}
//---------------------------------------------------------------------------

void __fastcall TFBankScr::BtnSavClick(TObject *Sender)
{    int newnum=1000;
     try {
      newnum=StrToInt(EdRegNum->Text)+1;
      }
     catch (...)
     { newnum=1000;};

     if (BtnOkClick(Sender))
     {     EdCodeClient->Text="";
       LabNClient->Caption="";
       LabEdrpou->Caption="";
       EdValuePay->Text="0";
       EdValueTax->Text="0";
       EdValue->Text="0";
       EdBank->Text="";
       LabNBank->Caption="";
       EdAccount->Text="";
       EdComment->Text="";
       EdRegNum->Text=IntToStr(newnum);
       EdCodeClient->SetFocus();
       fid_pay=0;
     };
}
//---------------------------------------------------------------------------
void __fastcall TFBankScr::ShowBill1(TObject *Sender)
{  QuerBill->Sql->Clear();

    int i=0;
      QuerBill->Sql->Add("select b.*,b.value+b.value_tax as value_all, \
      bv.pay,bv.pay_tax,bv.pay+bv.pay_tax as pay_all,bv.rest,bv.rest_tax,bv.rest+bv.rest_tax as rest_all\
               from ( select s.*,p.name as pref from acm_bill_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id \
                          )   b left join  \
                          (select bv.*  from acv_billpay bv \
                           where id_client= :pid_client ) as bv \
                        on (b.id_doc=bv.id_doc) \
                      order by b.mmgg desc");
   QuerBill->ParamByName("pid_client")->AsInteger=fid_client;
   DBGrBill->DataSource=QuerBill->DataSource;
   QuerBill->Open();

   QuerRest->Sql->Clear();
    QuerRest->Sql->Add("select sum(rest) as rest,sum(rest_tax) \
             as rest_tax  from  acv_billpay bv \
                           where id_client= :pid_client ");
   QuerRest->ParamByName("pid_client")->AsInteger=fid_client;
  // DBGrRest->DataSource=QuerBill->DataSource;
   QuerRest->Open();
LabRest->Caption=FloatToStr(QuerRest->FieldByName("rest")->AsFloat);
LabRestTax->Caption=FloatToStr(QuerRest->FieldByName("rest_tax")->AsFloat);
};
/*
#define WinName "Список счетов к погашению "
void _fastcall TMainForm::SelBillPay(TWTField *Sender) {
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTQuery * QuerBill=new TWTQuery(this);
  AnsiString Filt=" ";
      if (Sender!=NULL)
   {   AnsiString Proba;
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Filt=Sender->FieldLookUpFilter+"="+Proba;
      };
    };

  QuerBill->Sql->Clear();
  QuerBill->Sql->Add("select b.id_doc,b.id_client,c.name as name_client,b.reg_num ,");
  QuerBill->Sql->Add("b.reg_date as reg_date,b.value,v.pay,v.pay_tax,b.value_tax,v.rest,v.rest_tax,b.mmgg");
  QuerBill->Sql->Add(" from  clm_client_tbl c,acm_bill_tbl b left outer join acv_billpay v on b.id_doc=v.id_doc");
  QuerBill->Sql->Add(" where  c.id=b.id_client and (v.rest>0 or v.rest=NULL) ");

  if (Filt!=" ")
      QuerBill->Sql->Add(" and   b."+Filt);
    QuerBill->Sql->Add(" order by id_client,reg_date ");

   QuerBill->Open();
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QuerBill,false);
  WGrid->SetCaption(WinName);
  TWTQuery* Table = WGrid->DBGrid->Query;
  WGrid->DBGrid->SetReadOnly();
  Table->Open();

  TWTField *Field;
  Field = WGrid->AddColumn("name_client", "Клиент", "Клиент");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("Reg_num", "Номер счета", "Номер счета");
  Field->SetWidth(80);
  Field = WGrid->AddColumn("Reg_date", "Дата", "Дата счета");
  Field->SetWidth(80);
  Field = WGrid->AddColumn("Value", "Сумма счета", "Сумма счета");
  Field->SetWidth(80);
  Field->Precision=2;
  Field = WGrid->AddColumn("Value_tax", "Налог счета", "Налог счета");
  Field->SetWidth(80);
  Field->Precision=2;
  Field = WGrid->AddColumn("Pay", "Оплачено", "Оплачено счета");
  Field->SetWidth(80);
  Field->Precision=2;
  Field = WGrid->AddColumn("Pay_tax", "Оплачено налог", "Оплачено налог");
  Field->SetWidth(80);
  Field->Precision=2;
  Field = WGrid->AddColumn("Rest", "Остаток \\n счета", "Остаток счета");
  Field->SetWidth(80);
  Field->Precision=2;
  Field = WGrid->AddColumn("Rest_tax", "Налог остатка", " счета");
  Field->SetWidth(80);
  Field->Precision=2;
  Field = WGrid->AddColumn("mmgg", "Период", " Период");
  Field->SetWidth(80);



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("mmgg");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;

   WGrid->ShowAs(WinName);

};

*/




void __fastcall TFBankScr::EdValuePayChange(TObject *Sender)
{
    // if (Key=='.') Key=',';
}
#define WinName " Банковские выписки"
__fastcall TFBankCheck::~TFBankCheck()
{
  Close();
};
_fastcall TFBankCheck::TFBankCheck(TWinControl *owner)  : TWTDoc(owner)
{    TWTPanel* PHead=MainPanel->InsertPanel(100,true,200);

  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;



  QuerHPay= new TWTQuery(this);
  QuerHPay->Close();

  QuerHPay->Sql->Clear();
  QuerHPay->Sql->Add(" \
   select h.*,v.begs,v.plus,v.minus,v.ends \
    from acm_headpay_tbl h left join cmv_bank v  \
     on ( h.mfo_self=v.mfo and h.reg_date=v.dat \
     and h.account_self=v.acc) where (reg_num<>'saldo_kred' or reg_num is null) \
     order by h.reg_date Desc");

 DBGrHPay=new TWTDBGrid(this, QuerHPay);

  PHead->Params->AddText("Список банковских выписок ",18,F,Classes::taCenter,false);
  PHead->Params->AddGrid(DBGrHPay, true)->ID="HeadPay";

  DBGrHPay->Query->AddLookupField("name_bank", "MFO_self", "cmi_bank_tbl", "NAME","id");
  DBGrHPay->Query->IndexDefs->Add("reg_date","reg_date" , TIndexOptions() << ixDescending	);
  DBGrHPay->Query->Open();

  TWTField *Field;
  Field = DBGrHPay->AddColumn("reg_num", "Номер ", "Номер отчета");
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("reg_date", "Дата ", "Дата отчета");
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("account_self", "Расчетный счет", "Расчетный счет");
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("mfo_self", "МФО", "МФО");
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("begs", "Сальдо нач.", "Сальдо на начало дня");
  Field->Precision=2;
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("plus", "Поступило", "Поступление");
  Field->Precision=2;
  Field->SetWidth(100);
  Field = DBGrHPay->AddColumn("minus", "Отправлено", "Отправлено");
  Field->Precision=2;
  Field->SetWidth(100);
  Field = DBGrHPay->AddColumn("ends", "Сальдо конечное", "Сальдо конечное");
  Field->Precision=2;
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("name_bank", "Банк", "Банк");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrHPay->AddColumn("mmgg", "Месяц", "Месяц");
  Field->SetReadOnly();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("begs");
  NList->Add("plus");
  NList->Add("minus");
  NList->Add("ends");
  DBGrHPay->Query->SetSQLModify("acm_headpay_tbl",WList,NList,false,false,false);

  DBGrHPay->Visible = true;

 SetCaption("Банковская выписка ");
 ShowAs(WinName);
 MainPanel->ParamByID("HeadPay")->Control->SetFocus();
};

#undef WinName
void __fastcall  TFBankCheck::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

//---------------------------------------------------------------------------




_fastcall TFBankLoad::TFBankLoad(TWinControl *owner,int pid_doc)  : TWTDoc(owner)

{  PBar=MainPanel->InsertPanel(20,true,20);
  TWTPanel* PHead=MainPanel->InsertPanel(100,true,200);
     pnum_file=pid_doc;
     TButton *BtnBank=new TButton(this);
     BtnBank->Caption="Перезагрузка";
     BtnBank->OnClick=BankLoad ;
     BtnBank->Width=180;
     BtnBank->Top=2;

     TButton *BtnLoad=new TButton(this);
     BtnLoad->Caption="Формирование платежек";
     BtnLoad->OnClick=BankLoadScr ;
     BtnLoad->Width=180;
     BtnLoad->Top=2;
          TButton *BtnNull=new TButton(this);
     BtnNull->Caption=" ";
    // BtnLoad->OnClick=BankLoadScr ;
     BtnNull->Width=180;
     BtnNull->Top=2;


  PBar->Params->AddButton(BtnBank,false)->ID="BtnBank";
    PBar->Params->AddButton(BtnLoad,false)->ID="BtnLoad";
       PBar->Params->AddButton(BtnNull,false)->ID="BtnNull";
  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  pnum_file=pid_doc;

  QuerHPay= new TWTQuery(this);
  QuerHPay->Close();

  QuerHPay->Sql->Clear();
  QuerHPay->Sql->Add("  select *  from acm_loadpay_tbl  where  id_doc=:pid_doc");
  QuerHPay->ParamByName("pid_doc")->AsInteger=pid_doc;
   //DBGrHPay->Query->IndexDefs->Add("reg_date","reg_date" , TIndexOptions() << ixDescending	);

  DBGrHPay=new TWTDBGrid(this, QuerHPay);
   QuerHPay->AddLookupField("client", "id_client", "clm_client_tbl", "short_NAME","id");
  QuerHPay->AddLookupField("pref", "id_pref", "aci_pref_tbl", "NAME","id");

  DBGrHPay->Query->Open();

   PHead->Params->AddText("Платежи ",18,F,Classes::taCenter,false);
  PHead->Params->AddGrid(DBGrHPay, true)->ID="HeadPay";


  TWTField *Field;

  Field = DBGrHPay->AddColumn("okpo_client", "Код ЕДРПОУ", "Код ЕДРПОУ");
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("name_client", "Наименование клиента по банку", "Наименование клиента");
  Field->SetWidth(180);

  Field = DBGrHPay->AddColumn("client", "Наименование клиента", "Наименование клиента");
  Field->SetWidth(140);
  Field->SetOnHelp(((TMainForm*)MainForm)->CliClientMSpr);

  Field = DBGrHPay->AddColumn("value_pay", "Сумма", "Сумма");
   Field->Precision=2;
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("value", "Без НДС", "Без НДС");
  Field->Precision=2;
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("value_tax", "НДС", "НДС");
   Field->Precision=2;
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("sign_pay", "Знак", "Знак");
  Field->AddFixedVariable("1","+");
  Field->AddFixedVariable("-1","-");
  Field->SetDefValue("0");
  Field->SetWidth(20);

  Field = DBGrHPay->AddColumn("pref", "Вид начисления", "Вид начисления");
    DBGrHPay->Columns->Items[7]->Color=0x00aaffff;
  Field->SetWidth(30);

  Field = DBGrHPay->AddColumn("mmgg_pay", "Период оплаты", "Период оплаты");
  DBGrHPay->Columns->Items[8]->Color=0x00aaffff;
  Field->SetWidth(80);

    Field = DBGrHPay->AddColumn("flag_add", "Принять", "Принять");
    DBGrHPay->Columns->Items[9]->Color=0x00aaffff;
  Field->AddFixedVariable("1","#");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("0");
   Field->SetWidth(20);

  Field = DBGrHPay->AddColumn("comment", "Примечание", "Примечание");
  Field->SetWidth(180);



  Field = DBGrHPay->AddColumn("account_client", "Расчетный счет", "Расчетный счет");
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("mfo_client", "МФО", "МФО");
  Field->SetWidth(80);

  Field = DBGrHPay->AddColumn("pay_date", "Дата оплаты", "Дата оплаты");
  Field->SetWidth(80);

   Field = DBGrHPay->AddColumn("reg_num", "Номер ", "Номер отчета");
  Field->SetWidth(100);

  Field = DBGrHPay->AddColumn("reg_date", "Дата ", "Дата отчета");
  Field->SetWidth(80);


  Field = DBGrHPay->AddColumn("mmgg", "Месяц", "Месяц");
  Field->SetReadOnly();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  DBGrHPay->Query->SetSQLModify("acm_loadpay_tbl",WList,NList,true,false,false);
  QuerHPay->IndexFieldNames="sign_pay;value_pay";
  DBGrHPay->Visible = true;
  SetCaption("Загрузка банковской выписки");
  ShowAs("Загрузка банковской выписки");
  MainPanel->ParamByID("HeadPay")->Control->SetFocus();
  if (QuerHPay->Eof)
  {   LoadFromFile(pnum_file);
  };

};

void __fastcall  TFBankLoad::LoadFromFile(int num_file)
{
 TADOTable *ADOTableDBF;
 ADOTableDBF=new TADOTable(Owner);
 TADOConnection *ADOConnectionDBF;
 ADOConnectionDBF=new TADOConnection(Owner);
 TWTQuery *QuerIns1;
 AnsiString CurrDir=GetCurrentDir();
 QuerIns1 = new  TWTQuery(this);
 QuerIns1->Sql->Clear();
 QuerIns1->Sql->Add("select value_ident from syi_sysvars_tbl where ident='path_bank'");
 QuerIns1->Open();
 if (QuerIns1->Eof)
 {  ShowMessage("Не заполнена системная переменная Путь к файлам банковской выписки!");
    return;
 }

  TWTQuery *QuerZ=new TWTQuery(this);
 QuerZ->Sql->Clear();
 QuerZ->Sql->Add("delete from acm_loadpay_tbl where id_doc="+IntToStr(num_file));
 QuerZ->ExecSql();
 AnsiString FileName=ALLTRIM(QuerIns1->FieldByName("value_ident")->AsString)+IntToStr(num_file)+".dbf";

 QuerZ->Sql->Clear();
 QuerZ->Sql->Add("select fun_tax('tax',NULL)");
 QuerZ->Open();
 float nds=QuerZ->Fields->Fields[0]->AsFloat;
 // OpenDBF->Title = "Выберите файл";
//  if (OpenDBF->Execute())    {
   if (FileExists(FileName))
     { if (ADOTableDBF->Active)
        ADOTableDBF->Close();
       AnsiString Provider="Microsoft.Jet.OLEDB.4.0";        //ExcludeTrailingPathDelimiter
       AnsiString PathToDbf=(ExtractFilePath(FileName));
       AnsiString ConnectionString="Data Source="+PathToDbf+";Extended Properties=dBASE IV;User ID=;Password=";
      // ADOConnectionDBF->Provider=WideString(Provider);
       ADOConnectionDBF->Provider=(Provider);
       ADOConnectionDBF->ConnectionString=(ConnectionString);
       ADOConnectionDBF->LoginPrompt=false;
       static_cast<TCustomConnection*>(ADOConnectionDBF)->Open();
       if(ADOConnectionDBF->Connected)
       { ADOTableDBF->Connection=ADOConnectionDBF;
         ADOTableDBF->TableName=(FileName);
         ADOTableDBF->Open();
           ADOTableDBF->First();
           TWTQuery *QuerRes=new TWTQuery(this);
           QuerRes->Sql->Clear();
           QuerRes->Sql->Add("select value_ident from syi_sysvars_tbl where ident='id_res'");
           QuerRes->Open();
           int  id_res=QuerRes->FieldByName("value_ident")->AsInteger;

           QuerRes->Sql->Clear();
           QuerRes->Sql->Add("select c.*,s.* from  clm_client_tbl  c,  clm_statecl_tbl s  \
                            where s.id_client=c.id  and c.id=:pid_res");
           QuerRes->ParamByName("pid_res")->AsInteger=id_res;
           QuerRes->Open();
           AnsiString  OKPORes=QuerRes->FieldByName("okpo_num")->AsString;

            QuerRes->Sql->Clear();
             QuerRes->Params->Clear();
           QuerRes->Sql->Add("select * from acm_headpay_tbl where name_file=:num_file");

           QuerRes->ParamByName("num_file")->AsInteger=num_file;
           QuerRes->Open();
           TDateTime mmgg =QuerRes->FieldByName("mmgg")->AsDateTime;


            TProgressBar *PrBar;
  int x;


    PrBar=new TProgressBar(MainPanel);
    PrBar->Align=alClient;
    PrBar->Visible=false;
    PrBar->Parent=PBar;
    PrBar->Position=0;
    PrBar->Visible=true;

    ADOTableDBF->Last();
    int RN= ADOTableDBF->RecNo;
    PrBar->Max= RN;

    ADOTableDBF->First();

          while (!(ADOTableDBF->Eof))
          {
               QuerIns1->Sql->Clear();
               QuerIns1->Sql->Add("insert into acm_loadpay_tbl (id_doc,mfo_res,account_res, \
                                     reg_num,reg_date,pay_date, \
                                     okpo_client,mfo_client,account_client,name_client,\
                                     comment,value_pay,value,value_tax,sign_pay,mmgg)");
               QuerIns1->Sql->Add(" values (:pid_doc,:pmfo_res,:paccount_res,\
                                             :preg_num,:preg_date,:ppay_date,\
                                             :pokpo_client,:pmfo_client,:paccount_client,:pname_client, \
                                             :pcomment,:pvalue_pay,:pvalue,:pvalue_tax,:psign_pay,:pmmgg)");
               QuerIns1->ParamByName("pid_doc")->AsInteger=num_file;
               if (OKPORes!=ADOTableDBF->FieldByName("kod_a")->AsString)
                {  QuerIns1->ParamByName("psign_pay")->AsInteger=1;
                   QuerIns1->ParamByName("pmfo_res")->AsInteger=ADOTableDBF->FieldByName("kb_b")->AsInteger;
                   QuerIns1->ParamByName("paccount_res")->AsString=ADOTableDBF->FieldByName("kk_b")->AsString;
                   QuerIns1->ParamByName("pokpo_client")->AsString=ADOTableDBF->FieldByName("kod_a")->AsString;
                   QuerIns1->ParamByName("pmfo_client")->AsInteger=ADOTableDBF->FieldByName("kb_a")->AsInteger;
                   QuerIns1->ParamByName("paccount_client")->AsString=ADOTableDBF->FieldByName("kk_a")->AsString;
                 }
               else
                {  QuerIns1->ParamByName("psign_pay")->AsInteger=-1;
                   QuerIns1->ParamByName("pmfo_res")->AsInteger=ADOTableDBF->FieldByName("kb_a")->AsInteger;
                   QuerIns1->ParamByName("paccount_res")->AsString=ADOTableDBF->FieldByName("kk_a")->AsString;
                   QuerIns1->ParamByName("pokpo_client")->AsString=ADOTableDBF->FieldByName("kod_b")->AsString;
                   QuerIns1->ParamByName("pmfo_client")->AsInteger=ADOTableDBF->FieldByName("kb_b")->AsInteger;
                   QuerIns1->ParamByName("paccount_client")->AsString=ADOTableDBF->FieldByName("kk_b")->AsString;
                };
               QuerIns1->ParamByName("preg_num")->AsString=ADOTableDBF->FieldByName("nd")->AsString;
               QuerIns1->ParamByName("preg_date")->AsDateTime=ADOTableDBF->FieldByName("da")->AsDateTime;
               QuerIns1->ParamByName("ppay_date")->AsDateTime=ADOTableDBF->FieldByName("da_doc")->AsDateTime;
               QuerIns1->ParamByName("pname_client")->AsString=ADOTableDBF->FieldByName("nk_a")->AsString;
               QuerIns1->ParamByName("pcomment")->AsString=ADOTableDBF->FieldByName("np")->AsString;
               QuerIns1->ParamByName("pvalue_pay")->AsFloat=Round(ADOTableDBF->FieldByName("summa")->AsFloat/100.00,2);
               QuerIns1->ParamByName("pvalue")->AsFloat=Round(ADOTableDBF->FieldByName("summa")->AsInteger/100.00,2)-Round(Round(ADOTableDBF->FieldByName("summa")->AsInteger/100.00,2)/((100+nds)/nds),2);
               QuerIns1->ParamByName("pvalue_tax")->AsFloat=Round(Round(ADOTableDBF->FieldByName("summa")->AsInteger/100.00,2)/((100+nds)/nds),2);
               QuerIns1->ParamByName("pmmgg")->AsDateTime=mmgg;

               QuerIns1->ExecSql();
               ADOTableDBF->Next();
               PrBar->StepBy(1);
          };
            delete PrBar;
      };
  };

  QuerZ->Sql->Clear();
  QuerZ->Sql->Add("  update acm_loadpay_tbl set id_client=s.id_client from clm_statecl_tbl s \
                    where ltrim(rtrim(acm_loadpay_tbl.okpo_client))=ltrim(rtrim(s.okpo_num)) ");
  QuerZ->ExecSql();
// QuerHPay->Close();
// QuerHPay->Open();
 // SetCurrentDir(CurrDir);
  DBGrHPay->Refresh();
   DBGrHPay->Query->Refresh();
   QuerHPay->IndexFieldNames="sign_pay;value_pay";

}

void __fastcall TFBankLoad::BankLoad(TObject *Sender)
{
 LoadFromFile(pnum_file);
};





void __fastcall TFBankLoad::BankLoadScr(TObject *Sender)
{ TWTQuery* QuerZ=new TWTQuery(this);
  QuerZ->Sql->Clear();
  QuerZ->Sql->Add("select LoadBankScr(:pnum_file)::::varchar as ret");
  QuerZ->ParamByName("pnum_file")->AsInteger=pnum_file;
  QuerZ->Open();
   AnsiString  ret=QuerZ->Fields->Fields[0]->AsString;
   ShowMessage(ret);
};

#undef WinName
void __fastcall  TFBankLoad::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}


__fastcall TFBankLoad::~TFBankLoad()
{
  Close();
};



