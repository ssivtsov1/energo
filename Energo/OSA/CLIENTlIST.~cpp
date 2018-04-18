//---------------------------------------------------------------------------
// сложный справочник (предназначалось для рисования сложной формы документа) класс TWTDoc:TWTParamsForm
#include <vcl.h>
#pragma hdrstop

#include "Main.h"

//#include "client_main.h"
#include "CliState.h"
#include "CliDemL.h"
#include "ResDemL.h"
#include "CliSald.h"
#include "ClientBill.h"
#include "SysUser.h"
#include "WorkList.h"
#include "PlombList.h"
#include "fAbonAction.h"
//---------------------------------------------------------------------
// функции класса TMainForm
//---------------------------------------------------------------------
#define WinName "Список клиентов"
void _fastcall TMainForm::CliClientMBtn(TObject *Sender)
 {
   CliClientMSpr(NULL);
 }
void _fastcall TMainForm::CliClientMSpr(TWTField *Sender) {
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTDoc *DocClient=new TWTDoc(this,"");
  DocClient->Name = "DocClient";
  int ChLevel =CheckLevel("Список клиентов");
  if  (ChLevel==0) {
     return;
   };



  // };
  // создание панели, располагающейся на форме документа (размер, выриант располажения след панели, миним. размер панели) подложка
  //TWTPanel* PBtn=DocClient->MainPanel->InsertPanel(100,true,25); // (X,bool,Y) X,Y min size panel

  TButton *BtnCard=new TButton(this);
  BtnCard->Caption="Новый Л.С.";
  BtnCard->OnClick=ClientAccept;
  BtnCard->Width=100;
  BtnCard->Top=2;
  BtnCard->Left=2;
  if (CheckLevel("Список клиентов - Карточка клиента (кнопка)")==0)
     BtnCard->Enabled=false;

  TButton *BtnAcc=new TButton(this);
  BtnAcc->Caption="Банков.рекв.";
  BtnAcc->OnClick=AccClient;
  BtnAcc->Width=100;
  BtnAcc->Top=2;
  BtnAcc->Left=104;
    if (CheckLevel("Список клиентов - Банков.рекв.(кнопка)")==0)
     BtnAcc->Enabled=false;


  TButton *BtnPres=new TButton(this);
  BtnPres->Caption="Представители";
  BtnPres->OnClick=RepresentClient;
  BtnPres->Width=100;
  BtnPres->Top=2;
  BtnPres->Left=206;
   if (CheckLevel("Список клиентов - Представители (кнопка)")==0)
     BtnPres->Enabled=false;

  TButton *BtnSchem=new TButton(this);
  BtnSchem->Caption="Схема";
  BtnSchem->OnClick=ShowEqpTree;
  BtnSchem->Width=100;
  BtnSchem->Top=2;
  BtnSchem->Left=308;
   if (CheckLevel("Список клиентов - Схема (кнопка)")==0)
     BtnSchem->Enabled=false;

  TButton *BtnInd=new TButton(this);
  BtnInd->Caption="Потребление";
  BtnInd->OnClick=IndicationClient;
  BtnInd->Width=100;
  BtnInd->Top=2;
  BtnInd->Left=410;
   if (CheckLevel("Список клиентов - Потребление (кнопка)")==0)
     BtnInd->Enabled=false;


  TButton *BtnFin=new TButton(this);
  BtnFin->Caption="Счета/Оплата";
  BtnFin->OnClick=BillClient;
  BtnFin->Width=100;
  BtnFin->Top=2;
  BtnFin->Left=512;
    if (CheckLevel("Список клиентов - Счета/Оплата(кнопка)")==0)
      BtnFin->Enabled=false;

  TButton *BtnSal=new TButton(this);
  BtnSal->Caption="Сальдо";
  BtnSal->OnClick=SaldoClient;
  BtnSal->Width=100;
  BtnSal->Top=2;
  BtnSal->Left=614;
   if (CheckLevel("Список клиентов - Сальдо(кнопка)")==0)
      BtnSal->Enabled=false;

  TButton *BtnTax=new TButton(this);
  BtnTax->Caption="Нал.накладные";
  BtnTax->OnClick=TaxClient;
  BtnTax->Width=120;
  BtnTax->Top=2;
  BtnTax->Left=714;
  if (CheckLevel("Список клиентов - Нал.накладные(кнопка)")==0)
      BtnTax->Enabled=false;
  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=120;
  BtnEmp->Top=2;
  BtnEmp->Left=714;

 TWTPanel* PBtn=DocClient->MainPanel->InsertPanel(550,25);
 PBtn->RealHeight=25;
 PBtn->Params->AddButton(BtnCard,false)->ID="BtnCard";
  PBtn->Params->AddButton(BtnAcc,false)->ID="BtnAcc";;
  PBtn->Params->AddButton(BtnPres,false)->ID="BtnPres";
  PBtn->Params->AddButton(BtnSchem,false)->ID="BtnSchem";
   PBtn->Params->AddButton(BtnInd,false)->ID="BtnInd";
  PBtn->Params->AddButton(BtnFin,false)->ID="BtnFin";
    PBtn->Params->AddButton(BtnSal,false)->ID="BtnSal";
  PBtn->Params->AddButton(BtnTax,false)->ID="BtnTax";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";


  TButton *BtnLim=new TButton(this);
  BtnLim->Caption="Лимиты клиента";
  BtnLim->OnClick=ShowLimitList;
  BtnLim->Width=100;
  BtnLim->Top=2;
  BtnLim->Left=2;
   if (CheckLevel("Список клиентов - Лимиты клиента(кнопка)")==0)
      BtnLim->Enabled=false;

  TButton *BtnStat=new TButton(this);
  BtnStat->Caption="Состояние клиента";
  BtnStat->OnClick=ShowAbonAction;
  BtnStat->Width=100;
  BtnStat->Top=2;
  BtnStat->Left=2;
    if (CheckLevel("Список клиентов - Состояние клиента(кнопка)")==0)
      BtnStat->Enabled=false;

   TButton *BtnCDoc=new TButton(this);
  BtnCDoc->Caption="Документы подключения";
  BtnCDoc->OnClick=ShowConnectDocs;
  BtnCDoc->Width=220;
  BtnCDoc->Top=2;
  BtnCDoc->Left=2;
   if (CheckLevel("Список клиентов - Документы подключения(кнопка)")==0)
      BtnStat->Enabled=false;


  TButton *BtnWork=new TButton(this);
  BtnWork->Caption="Журнал работ";
  BtnWork->OnClick=ShowWorks;
  BtnWork->Width=120;
  BtnWork->Top=2;
  BtnWork->Left=2;

  TButton *BtnPlomb=new TButton(this);
  BtnPlomb->Caption="Журнал пломб";
  BtnPlomb->OnClick=ShowPlombs;
  BtnPlomb->Width=120;
  BtnPlomb->Top=2;
  BtnPlomb->Left=2;

    TButton *BtnStatOld=new TButton(this);
  BtnStatOld->Caption="Старое состояние";
  BtnStatOld->OnClick=ShowAbonSwitch;
  BtnStatOld->Width=100;
  BtnStatOld->Top=2;
  BtnStatOld->Left=2;
    if (CheckLevel("Список клиентов - Состояние клиента(кнопка)")==0)
      BtnStatOld->Enabled=false;
  /*
    TButton *BtnPlomb=new TButton(this);
  BtnPlomb->Caption="Удаленные";
  BtnPlomb->OnClick=ShowDelBill;
  BtnPlomb->Width=120;
  BtnPlomb->Top=2;
  BtnPlomb->Left=2;
   */
   TButton *BtnEmp1=new TButton(this);
  BtnEmp1->Caption="";
  BtnEmp1->Width=120;
  BtnEmp1->Top=2;
  BtnEmp1->Left=102;
   
     TWTPanel* PBtn1=DocClient->MainPanel->InsertPanel(550,25);
     PBtn1->RealHeight=25;
    TWTPanel* PClient=DocClient->MainPanel->InsertPanel(100,true,100);

   TWTQuery *QueryCliCheck=new TWTQuery(this);
    TWTQuery *QueryCli=new TWTQuery(this);

   QueryCliCheck->Sql->Clear();
    QueryCliCheck->Sql->Add("select * from sys_user_client where id_user=getsysvar('last_user')");
   QueryCliCheck->Open();
   if (QueryCliCheck->RecordCount<=0)
   {
      QueryCli->Sql->Clear();
      QueryCli->Sql->Add("select s.doc_num, s.okpo_num,c.*,s.doc_dat,s.phone,s.inspector, s.operator, \
       s.tax_num,s.flag_taxpay,s.flag_budjet,s.licens_num,s.flag_ed,s.flag_jur, s.fl_cabinet \
      from clm_client_tbl c \
      left join (select s.id,s.id_client,s.okpo_num,s.doc_num,s.doc_dat,s.id_position,s.phone, s.fl_cabinet , \
       tax_num,flag_taxpay,flag_budjet,licens_num,\
      p.represent_name as inspector, pp.represent_name as operator, s.flag_ed,s.flag_jur \
      from clm_statecl_tbl s \
      left join clm_position_tbl p  on (s.id_position=p.id) \
      left join clm_position_tbl pp  on (s.id_kur=pp.id) \
      ) s on (s.id_client=c.id)  \
      where book<0 order by book,code" );

    QueryCli->DefaultFilter="id_state<>50 and c.id_state<>99 and idk_work<>0 or (c.id=getsysvarn('id_res') or c.id=999999999 or c.id=getsysvarn('id_chnoe'))";
    QueryCli->Filtered=true;

     PBtn1->Params->AddButton(BtnLim,false)->ID="BtnLim";
     PBtn1->Params->AddButton(BtnStat,false)->ID="BtnStat";
     PBtn1->Params->AddButton(BtnCDoc,false)->ID="BtnCDoc";
     PBtn1->Params->AddButton(BtnWork,false)->ID="BtnWork";
     PBtn1->Params->AddButton(BtnPlomb,false)->ID="BtnPlomb";
      PBtn1->Params->AddButton(BtnStatOld,false)->ID="BtnStatOld";

     PBtn1->Params->AddButton(BtnEmp1,false)->ID="BtnEmp1";


    }
    else
    {
    QueryCli->Sql->Clear();
      QueryCli->Sql->Add("select s.doc_num, s.okpo_num,c.*,s.doc_dat,s.phone,s.inspector, s.operator ,\
       s.tax_num,s.flag_taxpay,s.flag_budjet,s.licens_num,s.flag_ed, s.flag_jur, s.fl_cabinet \
      from clm_client_tbl c \
      left join (select s.id,s.id_client,s.okpo_num,s.doc_num,s.doc_dat,s.id_position,s.phone, \
       tax_num,flag_taxpay,flag_budjet,licens_num,\
      p.represent_name as inspector, pp.represent_name as operator, s.flag_ed,s.flag_jur, s.fl_cabinet \
         from clm_statecl_tbl as s \
         left join clm_position_tbl p  on (s.id_position=p.id) \
         left join clm_position_tbl pp  on (s.id_kur=pp.id) \
          ) s on (s.id_client=c.id)  \
       join    sys_user_client cu \
        on cu.id_user=getsysvar('last_user') and cu.id_client=c.id    \
      where book<0      order by book,code" );

    };

     // QueryCli->Open();
 
   TWTDBGrid* DBGrClient=new TWTDBGrid(DocClient, QueryCli);

   DocClient->Tag = int(DBGrClient);            //Для того чтобы можно было получить указатель на грид из других окон

   DBGrClient->Query->AddLookupField("NAME_STATE", "ID_STATE", "cli_state_tbl", "name","id");
   AnsiString fres=GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='id_res'");

   TWTQuery *QueryAdr;
   QueryAdr=new  TWTQuery(this);
   QueryAdr->Sql->Add("select a.id,a.adr::::varchar,a.dom_reg from adv_address_tbl a, \
   clm_client_tbl c where c.book<0 and c.id_addres=a.id ");
   QueryAdr->Open();

    DBGrClient->Query->AddLookupField("name_adr", "ID_ADDRES", QueryAdr, "adr","id");

   DBGrClient->Query->Open();

 // TWTDBGrid* DBGrClient=new TWTDBGrid(DocClient, "clm_client_tbl");
  /*DBGrClient->IncrField="id";
  DBGrClient->IncrExpr="SELECT currval('clm_client_seq') as GEN_ID";
    */


  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PClient->Params->AddText("Клиенты ",18,F,Classes::taCenter,false);

  PClient->Params->AddGrid(DBGrClient, true)->ID="Client";


  TStringList *WListI=new TStringList();
  WListI->Add("id");

  TStringList *NListI=new TStringList();
  NListI->Add("doc_num");
  NListI->Add("doc_dat");
  NListI->Add("inspector");
  NListI->Add("phone");
  NListI->Add("tax_num");
  NListI->Add("flag_taxpay");
  NListI->Add("flag_budjet");
  NListI->Add("flag_ed");
  NListI->Add("flag_jur");
  NListI->Add("licens_num");
  NListI->Add("okpo_num");
  NListI->Add("fl_cabinet");
  NListI->Add("operator");

  DBGrClient->Query->SetSQLModify("clm_client_tbl",WListI,NListI,true,true,true);

  TWTField *Fields;

  Fields = DBGrClient->AddColumn("code", "Лицевой", "");
    Fields->SetRequired("Код должен быть заполнен");
      Fields->SetReadOnly();
  Fields->OnChange=OnChangeCode;
   //Fields->SetRequired("Лицевой клиента должен быть заполнен !");

  Fields = DBGrClient->AddColumn("Short_name", "Сокр. наименование", "Сокр.наименование организации, ФИО абонента");
  Fields->OnChange=OnChNameClient;
    Fields->SetReadOnly();
  Fields->SetWidth(300);
  Fields = DBGrClient->AddColumn("name", "Наименование организации, ФИО абонента", "Наименование организации, ФИО абонента");
  Fields->OnChange=OnChNameClient;
    Fields->SetReadOnly();
  Fields->SetWidth(300);
  Fields = DBGrClient->AddColumn("idk_work", "Признак", "Признак");
   Fields->AddFixedVariable("1",  "станд.   ");
   Fields->AddFixedVariable("0",  "--исключ.");
    Fields->AddFixedVariable("10","Н.до 2001");
    Fields->AddFixedVariable("99","Хоз.нужды");
   Fields->SetDefValue("1");
    Fields->SetWidth(90);
    Fields = DBGrClient->AddColumn("order_pay", "опл.", "");
   Fields->AddFixedVariable("1", "фикс.");
   Fields->AddFixedVariable("0","  ");
   Fields->SetDefValue("0");
    Fields->SetWidth(40);

   Fields = DBGrClient->AddColumn("Name_state", "Состояние", "Состояние");
    Fields->SetWidth(100);

   Fields = DBGrClient->AddColumn("doc_num", "№ договора", "№ договора");
   Fields->SetReadOnly();
   Fields->SetWidth(100);

    Fields = DBGrClient->AddColumn("doc_dat", "Дата дог.", "№ договора");
    Fields->SetReadOnly();
    Fields->SetWidth(80);
  
    Fields = DBGrClient->AddColumn("dt_close", "Дата закр.", "Дата закр.");
   // Fields->SetReadOnly();
    Fields->SetWidth(80);

   Fields = DBGrClient->AddColumn("fl_cabinet", "Каб.", "Каб.");
   Fields->AddFixedVariable("1", "Каб.");
   Fields->AddFixedVariable("0", "");
   Fields->SetReadOnly();
   Fields->SetWidth(50);

   Fields = DBGrClient->AddColumn("flag_ed", "Ед.налог", "Ед.налог");
   Fields->AddFixedVariable("1", "Ед.нал.");
   Fields->AddFixedVariable("0", "       ");
   Fields->SetReadOnly();
   Fields->SetWidth(50);

   Fields = DBGrClient->AddColumn("flag_jur", "Юр/Физ", "Юр/Физ");
   Fields->AddFixedVariable("1", "Юр. ");
   Fields->AddFixedVariable("0", "Физ.");
   Fields->SetReadOnly();
   Fields->SetWidth(50);


   Fields = DBGrClient->AddColumn("add_name", "ФИО для додатка", "ФИО для додатка");
  // Fields->SetWidth(80);



   Fields = DBGrClient->AddColumn("flag_taxpay", "Плат.НДС", "№ договора");
   Fields->AddFixedVariable("1", "Пл.НДС");
   Fields->AddFixedVariable("0",   "      ");
   Fields->SetReadOnly();
   Fields->SetWidth(80);

    Fields = DBGrClient->AddColumn("tax_num", "№ налоговый", "№ договора");
  Fields->SetReadOnly();
  Fields->SetWidth(120);




  Fields = DBGrClient->AddColumn("flag_budjet", "Бюджет", "№ договора");
      Fields->AddFixedVariable("1", "Бюджет");
   Fields->AddFixedVariable("0",    "      ");

  Fields->SetReadOnly();
  Fields->SetWidth(120);

  Fields = DBGrClient->AddColumn("Licens_num", "№ лицензии", "№ договора");
  Fields->SetReadOnly();
  Fields->SetWidth(120);

  Fields = DBGrClient->AddColumn("okpo_num", "ЕДРПОУ", "ЕДРПОУ");
  Fields->SetReadOnly();
  Fields->SetWidth(120);

  Fields = DBGrClient->AddColumn("inspector", "Инспектор", "Инспектор");
  Fields->SetReadOnly();
  Fields->SetWidth(120);

  Fields = DBGrClient->AddColumn("operator", "Техник", "Техник");
  Fields->SetReadOnly();
  Fields->SetWidth(120);


  Fields = DBGrClient->AddColumn("phone", "Телефон", "Телефон");
    Fields->SetReadOnly();
  Fields->SetWidth(120);

   TWTQuery *QDep=new TWTQuery(this);
   QDep->Sql->Clear();
   QDep->Sql->Add( " select int4(value_ident)  as a from syi_sysvars_tbl \
     where ident='kod_res' and (value_ident='240' or value_ident='210')"  );
   QDep->Open();
   if (!(QDep->Eof))
     Fields = DBGrClient->AddColumn("kind_dep", "гор/рай", "");

       QDep->Sql->Clear();
   QDep->Sql->Add( " select int4(value_ident)  as cod_res from syi_sysvars_tbl \
     where ident='kod_res' "  );
   QDep->Open();
   if (!(QDep->Eof))
    {
    int res = QDep->FieldByName("cod_res")->AsInteger;
    if (res==310)
    {
     Fields = DBGrClient->AddColumn("sdoc_num", "№ ", "№ ");
        Fields = DBGrClient->AddColumn("old_code", "теперешний", "теперешний");
      Fields = DBGrClient->AddColumn("new_code", "нужный", "нужный");
    };
   };
  Fields = DBGrClient->AddColumn("Name_adr", "Адрес", "Адрес");
  Fields->SetReadOnly();
  // Fields->SetOnHelp(AdmAddressMineSpr);


    DBGrClient->Query->IndexFieldNames="book;code";
   TWTToolBar* tb=DBGrClient->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=ClientAccept;
    if ( btn->ID=="NewRecord")
            tb->Buttons[i]->OnClick=ClientNew;
      if ( btn->ID=="DelRecord")
         btn->Enabled=false;
       //ShowMessage("Абоненты подлежат занесению в архив!");
    };
    DBGrClient->ToolBar->AddButton("AddCond", "Полный список", ClientAllList);
    DBGrClient->ToolBar->AddButton("RemCond", "Действующие", ClientRealList);

  //      btAll=DBGrid->ToolBar->AddButton("AddCond", "Полный список", ShowAll);
  //  btDef=DBGrid->ToolBar->AddButton("RemCond", "Часто используемые", ShowDef);
   DBGrClient->Query->OnNewRecord=ClientNewRec;
   DBGrClient->Query->IndexFieldNames="code";
  DBGrClient->FieldSource = DBGrClient->Query->GetTField("id");
  DBGrClient->FieldDest = Sender;
  DBGrClient->OnEnter=SetBtnO;
  DBGrClient->AfterScroll=SetBtn;


   DBGrClient->BeforeInsert=BeforeInsertClient;
   DBGrClient->AfterInsert=BeforeInsertClient;

  if  (ChLevel==1) {
     DBGrClient->ReadOnly;
   };
   if (Sender==NULL)
   { DBGrClient->OnAccept=ClientAccept;
   }
   DocClient->MainPanel->SetVResize(100);
   DocClient->ShowAs(WinName);

  DocClient->SetCaption(" Клиенты"); //не должно содержать "["
  //DocClient->LoadFromFile(DocClient->DocFile);
  DocClient->Constructor=true;
  DocClient->MainPanel->ParamByID("Client")->Control->SetFocus();
//  DocClient->AddGridToDoc(DBGrClient);

};

void _fastcall  TMainForm::OnChangeCode(TWTField  *Sender)
{  int pid_book,pid_code,pid_id;
   bool dublecod=false;
   pid_id=Sender->Field->DataSet->FieldByName("ID")->AsInteger;
   TWTQuery *QCheck=new TWTQuery(this);
   if (Sender->Field->Name == "CODE")
   {  pid_book=-1;//Sender->Field->DataSet->FieldByName("BOOK")->AsInteger;
      pid_code=Sender->Field->AsInteger;
   } else
   {
      pid_code=Sender->Field->DataSet->FieldByName("CODE")->AsInteger;
      pid_book=-1;//Sender->Field->AsInteger;
   };
      QCheck->Sql->Clear();
      QCheck->Sql->Add("select id,book,code from clm_client_tbl where ");
      QCheck->Sql->Add(" book=:pbook and code=:pcode");
      QCheck->ParamByName("pbook")->AsInteger=pid_book;
      QCheck->ParamByName("pcode")->AsInteger=pid_code;
      QCheck->Open();
    if (!(QCheck->Eof))
    { if (pid_id!=QCheck->FieldByName("id")->AsInteger)
      dublecod=true;
    };
  if (dublecod)
    {     ShowMessage("Дублирование лицевых счетов!");
         Sender->Field->DataSet->Cancel();
    };

};

  void __fastcall  TMainForm::ClientAllList(TObject *Sender)
 {
  if (CheckParent(Sender,"TToolButton"))
   {
    TWTDBGrid *dbgr=((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner));
    if (((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner))->Query->FieldByName("id")->IsNull) return;
    ((TWTDBGrid *)dbgr)->Query->DefaultFilter="";
     ((TWTDBGrid *)dbgr)->Query->Filtered=true;
   }
};


 /*
void __fastcall TfEqpSpr::ShowAll(TObject* Sender)
{
//
 btDef->Visible=true;
 btAll->Visible=false;
 DBGrid->Query->Filtered=false;
 DBGrid->Query->Refresh();
}  */
//---------------------------------------------------------------------------

void __fastcall TMainForm::ClientRealList(TObject* Sender)
{
//
/* btDef->Visible=false;
 btAll->Visible=true;
  */

  if (CheckParent(Sender,"TToolButton"))
   {
    TWTDBGrid *dbgr=((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner));
    if (((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner))->Query->FieldByName("id")->IsNull) return;
    ((TWTDBGrid *)dbgr)->Query->DefaultFilter="id_state<>50 and c.id_state<>99 and idk_work<>0";
     ((TWTDBGrid *)dbgr)->Query->Filtered=true;

  ((TWTDBGrid *)dbgr)->Refresh();
   }
/* if (DBGrid->Query->FindField("show_def")!=NULL)
     {
      DBGrid->Query->Filter="show_def=1";
      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     } */
}
void _fastcall TMainForm::BeforeInsertClient(TWTDBGrid *Sender)
{
    AnsiString fres=GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='id_res'");
     if (!(fres.IsEmpty()))
   {


    Sender->DataSource->DataSet->FieldByName("id_department")->AsInteger=StrToInt(fres);
    };
   fres=GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='kod_res'");
     if (!(fres.IsEmpty()))
   {
    Sender->DataSource->DataSet->FieldByName("kind_dep")->AsInteger=StrToInt(fres);
    };
};

void _fastcall TMainForm::OnChNameClient(TWTField *Sender){
   TField *FieldCh;
  if (Sender->Field->Name == "short_name")
    FieldCh=Sender->Field->DataSet->FieldByName("name");
   else
   FieldCh=Sender->Field->DataSet->FieldByName("short_name");
   if (FieldCh->AsString.IsEmpty())
    FieldCh->AsString=Sender->Field->AsString;

}

void __fastcall  TMainForm::ClientNew(TObject* Sender)
{
TWTQuery *TablSet;
int id_client=0;
if (CheckParent(Sender,"TWTDBGrid"))
{
 TablSet=((TWTDBGrid *)Sender)->Query;
 if (((TWTDBGrid *)Sender)->Query->FieldByName("id")->IsNull) return;
 //id_client=((TWTDBGrid *)Sender)->Table->FieldByName("id")->AsInteger;
}
 else
 {
   if (CheckParent(Sender,"TToolButton"))
   {
   TWTDBGrid *dbgr=((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner));
     if (((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner))->Query->FieldByName("id")->IsNull) return;
     //id_client=dbgr->Table->FieldByName("id")->AsInteger;
     TablSet=((TWTDBGrid *)dbgr)->Query;
   }

 };
 Application->CreateForm(__classid(TFCliState), &FCliState);
 FCliState->Align=alNone;
 FCliState->DragKind=dkDrag;
 FCliState->ParentDataSet=TablSet;
 FCliState->ShowData(id_client);

}


void __fastcall  TMainForm::ClientNewRec(TDataSet* Sender)
{
TWTQuery *TablSet;
int id_client=0;
if (CheckParent(Sender,"TWTDBGrid"))
{
 TablSet=((TWTDBGrid *)Sender)->Query;
 if (((TWTDBGrid *)Sender)->Query->FieldByName("id")->IsNull) return;
 //id_client=((TWTDBGrid *)Sender)->Table->FieldByName("id")->AsInteger;
}
 else
 {
   if (CheckParent(Sender,"TToolButton"))
   {
   TWTDBGrid *dbgr=((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner));
     if (((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner))->Query->FieldByName("id")->IsNull) return;
     //id_client=dbgr->Table->FieldByName("id")->AsInteger;
     TablSet=((TWTDBGrid *)dbgr)->Query;
   }

 };
 Application->CreateForm(__classid(TFCliState), &FCliState);
 FCliState->Align=alNone;
 FCliState->DragKind=dkDrag;
 FCliState->ParentDataSet=TablSet;
 FCliState->ShowData(id_client);
 Sender->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall  TMainForm::ClientAccept (TObject* Sender)
{
TWTQuery *TablSet;
int id_client=0;
if (CheckParent(Sender,"TWTDBGrid"))
{
 TablSet=((TWTDBGrid *)Sender)->Query;
 if (((TWTDBGrid *)Sender)->Query->FieldByName("id")->IsNull) return;
 id_client=((TWTDBGrid *)Sender)->Query->FieldByName("id")->AsInteger;
}
 else
 {
   if (CheckParent(Sender,"TToolButton"))
   {
   TWTDBGrid *dbgr=((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner));
     if (((TWTDBGrid *)(((TToolButton *)Sender)->Parent->Owner))->Query->FieldByName("id")->IsNull) return;
     id_client=dbgr->Query->FieldByName("id")->AsInteger;
     TablSet=((TWTDBGrid *)dbgr)->Query;
   }

 };
 Application->CreateForm(__classid(TFCliState), &FCliState);
 FCliState->Align=alNone;
 FCliState->DragKind=dkDrag;
 FCliState->ParentDataSet=TablSet;
// Client->ParentDataSet=DBGrid->Query;
 //rmClient->ShowAs("AccsClient");
 FCliState->ShowData(id_client);

}


void _fastcall TMainForm::EnabledButton(TDataSet *DatSet,TWTPanel * MainPan){
  if( ( DatSet->Eof ) ||(DatSet->State!=dsBrowse) )
{   TButton *BtnCard= (TButton *)(MainPan->ParamByID("BtnCard")->Control);
    BtnCard->Enabled=false;
    TButton *BtnAcc= (TButton *)(MainPan->ParamByID("BtnAcc")->Control);
    BtnAcc->Enabled=false;
    TButton *BtnPres= (TButton *)(MainPan->ParamByID("BtnPres")->Control);
    BtnPres->Enabled=false;
    TButton *BtnSchem= (TButton *)(MainPan->ParamByID("BtnSchem")->Control);
    BtnSchem->Enabled=false;
    TButton *BtnFin= (TButton *)(MainPan->ParamByID("BtnFin")->Control);
    BtnFin->Enabled=false;
    TButton *BtnInd= (TButton *)(MainPan->ParamByID("BtnInd")->Control);
    BtnInd->Enabled=false;
    TButton *BtnSal= (TButton *)(MainPan->ParamByID("BtnSal")->Control);
    BtnSal->Enabled=false;

    return;
 };
  if (DatSet->State==dsBrowse)
  { TButton *BtnCard= (TButton *)(MainPan->ParamByID("BtnCard")->Control);
    BtnCard->Enabled=true;
    TButton *BtnAcc= (TButton *)(MainPan->ParamByID("BtnAcc")->Control);
    BtnAcc->Enabled=true;
    TButton *BtnPres= (TButton *)(MainPan->ParamByID("BtnPres")->Control);
    BtnPres->Enabled=true;
    TButton *BtnSchem= (TButton *)(MainPan->ParamByID("BtnSchem")->Control);
    BtnSchem->Enabled=true;
    TButton *BtnFin= (TButton *)(MainPan->ParamByID("BtnFin")->Control);
    BtnFin->Enabled=true;
    TButton *BtnInd= (TButton *)(MainPan->ParamByID("BtnInd")->Control);
    BtnInd->Enabled=true;
    TButton *BtnSal= (TButton *)(MainPan->ParamByID("BtnSal")->Control);
    BtnSal->Enabled=true;

    return;
  };
};

void __fastcall TMainForm::SetBtn(TWTDBGrid *Sender)
{ TWTDoc *TDoc;
  TDoc=(( TWTDoc *)(((TWinControl *)Sender)->Owner));
  TWTPanel *MPanel= ( TWTPanel *)TDoc->MainPanel;
  //TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
  EnabledButton(Sender->DataSource->DataSet,MPanel);
};

void __fastcall TMainForm::SetBtnO(TObject *Sender)
{ TWTDoc *TDoc;
  TDoc=(( TWTDoc *)(((TWinControl *)Sender)->Owner));
  TWTPanel *MPanel= ( TWTPanel *)TDoc->MainPanel;
  //TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
  EnabledButton(((TWTDBGrid*)Sender)->DataSource->DataSet,MPanel);
};

#undef WinName
#define WinName "Состояние абонентов"
void _fastcall TMainForm::CliStateSpr(TWTField *Sender) {
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cli_state_tbl",false);
  WGrid->SetCaption(WinName);

 // WGrid->DBGrid->IncrField="id";
  //WGrid->DBGrid->IncrExpr="SELECT currval('clm_state_seq') as GEN_ID";

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "Состояние", "Состояние");
 // Field->SetRequired("Состояние должно быть заполнено");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};

#undef WinName


void __fastcall TMainForm::AccClient(TObject *Sender)
{    TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
  ((TMainForm*)(Application->MainForm))->InterAccCliDataSet=GrClient->DataSource->DataSet;
  ((TMainForm*)(Application->MainForm))->InterAccCliTable=GrClient->Query;

   AccClientSpr(NULL);
};

void __fastcall TMainForm::RepresentClient(TObject *Sender)
{    TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
  ((TMainForm*)(Application->MainForm))->InterReprCliDataSet=GrClient->DataSource->DataSet;
  ((TMainForm*)(Application->MainForm))->InterReprCliTable=GrClient->Query;
    ClientPositionSpr(NULL);
};

#define WinName "Показания"
void __fastcall TMainForm::IndicationClient(TObject *Sender)
{    TWTPanel *TDoc;
   int fid_client;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
  fid_client=GrClient->DataSource->DataSet->FieldByName("id")->AsInteger;

  // Определяем владельца
  TWTQuery *QueryInd;


  TWinControl *Owner = this;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    //return NULL;
  }
  QueryInd = new  TWTQuery(this);
  QueryInd->Options << doQuickOpen;
  QueryInd->Sql->Clear();
  QueryInd->Sql->Add("select a.*,c.id as id_cl,c.short_name from acm_headindication_tbl a,clm_client_tbl c where " );
  QueryInd->Sql->Add("c.id=a.id_client and a.id_client=:pid_client order by id_doc" );
  QueryInd->ParamByName("pid_client")->AsInteger=fid_client;
  QueryInd->Open();

  if (GetIdFromBase("select syi_resid_fun()::::int as res","res")==fid_client)
  {
   TfResDem *WGrid;
   WGrid = new TfResDem(Application->MainForm, QueryInd,fid_client);
  }
  else
  {
   TfCliDem *WGrid;
   WGrid = new TfCliDem(Application->MainForm, QueryInd,fid_client);
  }

};

void __fastcall TMainForm::BillClient(TObject *Sender)
{    TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
   int fid_client=GrClient->DataSource->DataSet->FieldByName("id")->AsInteger;
  TfCliBill *WGrid;
  WGrid = new TfCliBill(Application->MainForm, GrClient->Query,fid_client);

};

void __fastcall TMainForm::ShowConnectDocs(TObject *Sender)
{    TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
   int fid_client=GrClient->DataSource->DataSet->FieldByName("id")->AsInteger;
  TfCliCDocs *WGrid;
  WGrid = new TfCliCDocs(Application->MainForm, GrClient->Query,fid_client);

};

void __fastcall TMainForm::ShowWorks(TObject *Sender)
{    TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
   int fid_client=GrClient->DataSource->DataSet->FieldByName("id")->AsInteger;


  TWTQuery *ZQWorksList;

  TWinControl *Owner = this ;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild("Журнал работ", Owner)) {
    return;
  }
/*
  ZQWorksList = new  TWTQuery(this);
  ZQWorksList->Options << doQuickOpen;

  ZQWorksList->Sql->Clear();
  ZQWorksList->Sql->Add(" select * from clm_works_tbl where id_client = :client order by dt_work,id_point; ");
  ZQWorksList->ParamByName("client")->AsInteger=fid_client;

  TfWorkList *fWorkList = new TfWorkList(this, ZQWorksList,false, fid_client,0);
  fWorkList->Abon_name = GrClient->DataSource->DataSet->FieldByName("short_name")->AsString;
  fWorkList->SetCaption("Журнал работ");
  fWorkList->ShowAs("Журнал работ");
*/
  TfWorkList *fWorkList = new TfWorkList(this, fid_client,0);
  fWorkList->Abon_name = GrClient->DataSource->DataSet->FieldByName("short_name")->AsString;
  fWorkList->SetCaption("Журнал работ");
  fWorkList->ShowAs("Журнал работ");

  fWorkList->MainPanel->ParamByID("Indications")->Control->SetFocus();
  fWorkList->MainPanel->ParamByID("Works")->Control->SetFocus();

};


void __fastcall TMainForm::ShowPlombs(TObject *Sender)
{    TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
   int fid_client=GrClient->DataSource->DataSet->FieldByName("id")->AsInteger;


  TWTQuery *ZQPlombList;

  TWinControl *Owner = this ;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild("Журнал пломб", Owner)) {
    return;
  }

  ZQPlombList = new  TWTQuery(this);
  //ZQPlombList->Options << doQuickOpen;

  ZQPlombList->Sql->Clear();
  ZQPlombList->Sql->Add(" select * from clm_plomb_tbl where id_client = :client order by CASE WHEN dt_e is null then 0 else 1 end, id_point,object_name, dt_b ; ");

  ZQPlombList->ParamByName("client")->AsInteger=fid_client;

  TfPlombList *fPlombList = new TfPlombList(this, ZQPlombList,false, fid_client,0);
  fPlombList->Abon_name = GrClient->DataSource->DataSet->FieldByName("short_name")->AsString;
  fPlombList->SetCaption("Журнал пломб");
  fPlombList->ShowAs("Журнал пломб");

};

void __fastcall TMainForm::TaxClient(TObject *Sender)
{    TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
  ((TMainForm*)(Application->MainForm))->InterTaxCliDataSet=GrClient->DataSource->DataSet;
  ((TMainForm*)(Application->MainForm))->InterTaxCliTable=GrClient->Query;

   ClientTaxList(NULL);
};

void __fastcall TMainForm::SaldoClient(TObject *Sender)
{      TWTPanel *TDoc;
 TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);
   int fid_client=GrClient->DataSource->DataSet->FieldByName("id")->AsInteger;
  TfCliSald *WGrid;
  WGrid = new TfCliSald(Application->MainForm, GrClient->Query,fid_client);
};



#define WinName "Расчетные счета"
void _fastcall TMainForm::AccClientBtn(TObject *Sender) {
  AccClientSpr(NULL);
}

void _fastcall TMainForm::AccClientSpr(TWTField *Sender) {
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cli_account_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  // Добавляем поля для просмотра и для ограничения на наличие поля в справочнике
  Table->AddLookupField("NAME_ident", "ident", "aci_pref_tbl", "NAME","ident");
  Table->AddLookupField("NAME_BANK", "MFO", "cmi_bank_tbl", "NAME","id");
   if (Sender!=NULL)
   {   AnsiString Proba;
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);

       Table->Filtered=true;
      };
    };

  if (((TMainForm*)(Application->MainForm))->InterAccCliTable!=NULL)
   { AnsiString ee=((TMainForm*)(Application->MainForm))->InterAccCliTable->FieldByName("id")->AsString;
     int ii=StrToInt(ee);
     AnsiString NameCl=" ";
     NameCl=NameCl+GetNameFromBase("clm_client_tbl","name",ii);
     WGrid->SetCaption(WinName+NameCl);
    Table->SetFilter("id_client="+ee);
    Table->Filtered=true;
   };
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("ACCOUNT", "Счет", "Расчетный счет");
//  Field->SetRequired("Расчетный счет должен быть заполнен");

  Field = WGrid->AddColumn("MFO", "MFO", "MFO");
  Field->SetOnHelp(CmiBankSpr);
//  Field->SetRequired("MFO должен быть заполнен");

  Field = WGrid->AddColumn("NAME_BANK", "Банк", "Банк");
  Field->SetOnHelp(CmiBankSpr);
  //Field->SetRequired("Банк должен быть заполнен");

   Field = WGrid->AddColumn("Main", "Главный", "Признак главного счета");
  Field->AddFixedVariable("True", "Основной");
  Field->AddFixedVariable("False","       ");
  Field->SetDefValue("false");

  Field = WGrid->AddColumn("name_ident", "Расчет", "Расчеты ");

  /* Field->AddFixedVariable("act_ee", "За активную ее");
  Field->AddFixedVariable("react_ee", "За реактивную ее");
  Field->AddFixedVariable("pena", "За пеню      ");
  Field->AddFixedVariable("infl", "За инфляцию     ");
  Field->AddFixedVariable(" ","       ");
  Field->SetDefValue(" ");
     */


  Field->OnChange=OnChangeAccount;

   WGrid->DBGrid->AfterInsert=AfterInsAccount;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("account");
  WGrid->DBGrid->FieldDest = Sender;
   WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("account");
  WGrid->DBGrid->Visible = true;

   WGrid->ShowAs(WinName);

};

void _fastcall TMainForm::AfterInsAccount(TWTDBGrid *Sender)
{
  if (((TMainForm*)(Application->MainForm))->InterAccCliTable!=NULL)
   { int ee=((TMainForm*)(Application->MainForm))->InterAccCliTable->FieldByName("id")->AsInteger;
    Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=ee;
   }
   else{
    if (Sender->DataSource->DataSet->Filter!=NULL)
    { AnsiString filt=Sender->DataSource->DataSet->Filter;
      int p=filt.Pos("=");
      if (p>0)
       { AnsiString cli=filt.SubString(p+1,filt.Length());
         int ee=StrToInt(cli);
        Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=ee;
       }
    };
  };

};

void _fastcall TMainForm::OnChangeAccount(TWTField *Sender)
{ int ee;
 TBookmark SavePlace;
    SavePlace= new TBookmark();
if (((TMainForm*)(Application->MainForm))->InterAccCliTable!=NULL)
   {  ee=((TMainForm*)(Application->MainForm))->InterAccCliTable->FieldByName("id")->AsInteger;
     AnsiString cli=IntToStr(ee);


   if (Sender->Field->AsBoolean==true)
  {  TWTQuery *QuerUpd=new TWTQuery(this);
     QuerUpd->Sql->Clear();
     QuerUpd->Sql->Add(" Update cli_account_tbl set main=false where id_client="+cli );
     QuerUpd->ExecSql();
     SavePlace=Sender->Field->DataSet->GetBookmark();
       SavePlace=Sender->Field->DataSet->GetBookmark();
       if (Sender->Field->DataSet->BookmarkValid(SavePlace))
         int rr=0;

       Sender->Field->DataSet->Refresh();
      if (Sender->Field->DataSet->BookmarkValid(SavePlace))
       try {
       // FieldDest->Field->DataSet->Bookmark="SavePlace";
          Sender->Field->DataSet->GotoBookmark(SavePlace);
                Sender->Field->DataSet->FreeBookmark(SavePlace);
           }
       catch (...) {
       ;
       };
  };
};
};
#undef WinName



#define WinName "Справочник наименований должностей клиентов"
void _fastcall TMainForm::CliPositionBtn(TObject *Sender){   // sti_position_tbl
  CliPositionSpr(NULL);                                      //!!!
};

//void _fastcall TMainForm::CliPosSpr(TWTField  *Sender){

void _fastcall TMainForm::CliPositionSpr(TWTField  *Sender){
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this :
          (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cli_position_tbl",false); //!!! основная таблица
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // !!! здесь можно определить LookUp
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("NAME", "Должность", "Наименование должности");  //!!!
 // Field->SetRequired("Наименование должности должно быть заполнена"); // если обязательно для заполнения раскоментировать
  Field = WGrid->AddColumn("ident", "Прим.", "Примечание");
  Field->AddFixedVariable("  ",   "              ");
  Field->AddFixedVariable("boss", "Директор      ");
  Field->AddFixedVariable("boss2","Зам.директора ");
  Field->AddFixedVariable("buh",  "Гл.бухгалтер  ");
  Field->AddFixedVariable("ingen","Инженер       ");
  Field->AddFixedVariable("sbut", "Работник сбыта");
  Field->AddFixedVariable("kuryer","Курьер       ");
  Field->AddFixedVariable("kontr", "Контроллер   ");
  Field->SetDefValue("  ");

 // WGrid->DBGrid->AfterInsert= AfterInsertStiPosition;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
#undef WinName

//------------------------------------------- End Part2 - StiPositionXXX

//---------------------------------------------------  Part3 - StiPersonXXX
#define WinName "Справочник данных работников клиентов"
void _fastcall TMainForm::CliPersonBtn(TObject *Sender){     // sti_person_tbl
  CliPersonSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::CliPersonSpr(TWTField  *Sender){
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cli_person_tbl",false); //!!! основная таблица
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // !!! здесь можно определить LookUp
   if (((TMainForm*)(Application->MainForm))->InterReprCliTable!=NULL)
   { AnsiString ee=((TMainForm*)(Application->MainForm))->InterReprCliTable->FieldByName("id")->AsString;
    Table->SetFilter("id_client="+ee);
    Table->Filtered=true;
     int ii=StrToInt(ee);
     AnsiString NameCl=" ";
     NameCl=NameCl+GetNameFromBase("clm_client_tbl","name",ii);
     WGrid->SetCaption(WinName+NameCl);
   };

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("REPRESENT_NAME", "Представитель", "Представитель");  //!!!
  Field = WGrid->AddColumn("LAST_NAME", "Фамилия", "Фамилия");  //!!!
  //Field->SetRequired("Наименование должности должно быть заполнена"); // если обязательно для заполнения раскоментировать
  Field = WGrid->AddColumn("First_name", "Имя", "Имя");  //!!!
  Field = WGrid->AddColumn("Father_name", "Отчество", "Отчество");  //!!!
  Field = WGrid->AddColumn("Phone", "Дом.телефон", "Домашний телефон");  //!!!
  Field = WGrid->AddColumn("Information", "Доп. информация", "Дополнительная информация");  //!!!
  Field->SetWidth(500);
  WGrid->DBGrid->AfterInsert=AfterInsRepresent;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};
  /*
void _fastcall TMainForm::AfterInsPerson(TWTDBGrid *Sender)
{
  if (((TMainForm*)(Application->MainForm))->InterReprCliTable!=NULL)
   { int ee=((TMainForm*)(Application->MainForm))->InterReprCliTable->FieldByName("id")->AsInteger;
    Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=ee;
   };
};
    */
#undef WinName

//------------------------------------------- End Part3 - StiPersonXXX


//---------------------------------------------------  Part4 - StPositionXXX  complicated
#define WinName "Список должностей клиентов"
void _fastcall TMainForm::ClientPositionBtn(TObject *Sender){    // st_position_tbl
  ClientPositionSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::ClientPositionSpr(TWTField  *Sender) {
  CliPositionSel(Sender,"");
};

void _fastcall TMainForm::ClientPositionResSpr(TWTField  *Sender) {
  int id_res=0;
  AnsiString filt="";
  TWTDBGrid *Grid;
  TWTQuery *QuerRes=new TWTQuery(this);
  QuerRes->Sql->Add("select syi_resid_fun() as idres");
  QuerRes->Open();

  id_res=QuerRes->FieldByName("idres")->AsInteger;
  filt="id_client="+ToStrSQL(id_res);
  Grid=CliPositionSel(Sender,filt);

};

TWTDBGrid* _fastcall TMainForm::CliPositionSel(TWTField  *Sender,AnsiString Filt)
{   AnsiString res;
    AnsiString grid_res;
   TWinControl *Owner = Sender == NULL ?
      this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
   TWTQuery *QueryZ=new TWTQuery(this);
   QueryZ->Sql->Add("select trim(getsysvarc('id_res'))::::varchar as res");
   try
  {
   QueryZ->Open();
  }
  catch(...)
  {
   ShowMessage(" Ошибка select trim(getsysvarc('id_res'))::::varchar as res");
   return 0;
  }
   QueryZ->First();
    if ( QueryZ->RecordCount>0)
      res = QueryZ->FieldByName("res")->AsString;
      else
         { res ="0";
         ShowMessage(" Ошибка Не заполнен id_res в syi_sysvars_tbl");
          };

     QueryZ->Close();

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  "clm_position_tbl",false); //!!! основная таблица
  WGrid->SetCaption(WinName);
  TWTQuery *QuerCli=new TWTQuery(this);
  QuerCli->Sql->Clear();
  QuerCli->Sql->Add("select id,short_name,name from clm_client_tbl where book<0");
  QuerCli->Open();
  TWTTable* Table = WGrid->DBGrid->Table;
  // Добавляем поля для просмотра и для ограничения на наличие поля в справочнике
 if (Sender==NULL)
  Table->AddLookupField("NAME_FIRM", "ID_Client",QuerCli, "NAME","id"); //!!! имя lookup таблицы, поля
   Table->AddLookupField("NAME_POSITION", "ID_POSITION",    "cli_position_tbl", "NAME","id"); //!!! имя lookup таблицы, поля
  //Table->AddLookupField("NAME_PERSON", "ID_PERSON",    "cli_person_tbl", "Represent_NAME","id"); //!!! имя lookup таблицы, поля
  //Table->AddLookupField("NAME_ADR", "ID_ADDRES", "adv_address_tbl", "Full_adr","id");
  //Table->AddLookupField("NAME_ADR_HOME", "ID_ADDRES_HOME", "adv_address_tbl", "Full_adr","id");
  if (((TMainForm*)(Application->MainForm))->InterReprCliTable!=NULL)
   {  grid_res=((TMainForm*)(Application->MainForm))->InterReprCliTable->FieldByName("id")->AsString;
    Table->SetFilter("id_client="+grid_res);
    Table->Filtered=true;
     int ii=StrToInt(grid_res);
     AnsiString NameCl=" ";
     NameCl=NameCl+QuerCli->FieldByName("short_name")->AsString;
     WGrid->SetCaption(WinName+NameCl);
   };
   if  (!Filt.IsEmpty())
   {  Table->SetFilter(Filt);
      Table->Filtered=true;
    }

  Table->Open();
 Table->IndexFieldNames="represent_name";

  TWTField *Field;

 // Field = WGrid->AddColumn("id_POSITION", "Долж.", "Должность"); // из NAME_KIND Table->AddLookupField
 // Field->SetOnHelp(CliPositionSpr); //!!! имя обекта функции вызываемого справочника
 // Field->SetOnValidate(OnRefr);

   Field = WGrid->AddColumn("represent_name", "Должностное лицо", "Должностное лицо"); // из NAME_KIND Table->AddLookupField
   Field->SetRequired("Должностное лицо должно быть заполнено");
  Field->SetWidth(200);

  Field = WGrid->AddColumn("NAME_POSITION", "Должность", "Должность"); // из NAME_KIND Table->AddLookupField
  Field->SetOnHelp(CliPositionSpr); //!!! имя обекта функции вызываемого справочника
  Field->SetWidth(100);
   if (res==grid_res)
  {Field = WGrid->AddColumn("Num_tab", "Табельный №", "Таб №"); // из NAME_KIND Table->AddLookupField
   Field->SetWidth(100);
  };

  Field = WGrid->AddColumn("Phone", "Телефон (раб.)", "Телефон(раб.)");
  Field = WGrid->AddColumn("Phone_home", "Телефон (дом.)", "Телефон(дом.)");

  Field = WGrid->AddColumn("last_name", "Фамилия", "Фамилия");
  Field->SetWidth(180);
  Field = WGrid->AddColumn("first_name", "Имя", "Имя");
  Field->SetWidth(180);
  Field = WGrid->AddColumn("father_name", "Отчество", "Отчество");
  Field->SetWidth(180);
 /* Field = WGrid->AddColumn("Name_adr_home", "Адрес(дом.)", "Адрес(дом.)");
  Field->SetOnHelp(AdmAddressMineSpr);
  Field = WGrid->AddColumn("Name_adr", "Адрес(раб.)", "Адрес(раб.)");
  Field->SetOnHelp(AdmAddressMineSpr);   */
  Field = WGrid->AddColumn("Information", "Доп.информация", "Доп.информация");
   Field = WGrid->AddColumn("inn", "ИНН", "ИНН");
if ((Sender==NULL) )
  {  Field = WGrid->AddColumn("NAME_FIRM", "Фирма", "Наименование фирмы");  //!!!
     Field->SetOnHelp(CliClientMSpr);
  };

  if ( (Sender==NULL)&& (!Filt.IsEmpty()))
  {
   WGrid->DBGrid->AfterInsert=AfterInsRepRes;
  };

if ((Sender!=NULL))
  WGrid->DBGrid->AfterInsert=AfterInsRepresent;

if (Filt.IsEmpty() && (Sender==NULL))
  WGrid->DBGrid->AfterInsert=AfterInsRepresent;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
  return WGrid->DBGrid;

};

void _fastcall TMainForm::AfterInsRepresent(TWTDBGrid *Sender)
{
  if (((TMainForm*)(Application->MainForm))->InterReprCliTable!=NULL)
   { int ee=((TMainForm*)(Application->MainForm))->InterReprCliTable->FieldByName("id")->AsInteger;
    Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=ee;
   };
};

void _fastcall TMainForm::AfterInsRepRes(TWTDBGrid *Sender)
{ int id_res=GetIdFromBase("select value_ident as val from syi_sysvars_tbl where ident='id_res'","val");
    Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_res;

};
       /*
TWTDBGrid* _fastcall TMainForm::CliPositionResSel(TWTField  *Sender,AnsiString Filt)
{
   TWinControl *Owner = Sender == NULL ?
      this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  "clm_position_tbl",false); //!!! основная таблица
  WGrid->SetCaption(WinName);
  TWTQuery *QuerCli=new TWTQuery(this);
  QuerCli->Sql->Clear();
  QuerCli->Sql->Add("select id,short_name,name from clm_client_tbl where book<0");
  QuerCli->Open();
  TWTTable* Table = WGrid->DBGrid->Table;
  // Добавляем поля для просмотра и для ограничения на наличие поля в справочнике
 if (Sender==NULL)
  Table->AddLookupField("NAME_FIRM", "ID_Client",QuerCli, "NAME","id"); //!!! имя lookup таблицы, поля
   Table->AddLookupField("NAME_POSITION", "ID_POSITION",    "cli_position_tbl", "NAME","id"); //!!! имя lookup таблицы, поля
  //Table->AddLookupField("NAME_PERSON", "ID_PERSON",    "cli_person_tbl", "Represent_NAME","id"); //!!! имя lookup таблицы, поля
  //Table->AddLookupField("NAME_ADR", "ID_ADDRES", "adv_address_tbl", "Full_adr","id");
  //Table->AddLookupField("NAME_ADR_HOME", "ID_ADDRES_HOME", "adv_address_tbl", "Full_adr","id");
  if (((TMainForm*)(Application->MainForm))->InterReprCliTable!=NULL)
   { AnsiString ee=((TMainForm*)(Application->MainForm))->InterReprCliTable->FieldByName("id")->AsString;
    Table->SetFilter("id_client="+ee);
    Table->Filtered=true;
     int ii=StrToInt(ee);
     AnsiString NameCl=" ";
     NameCl=NameCl+QuerCli->FieldByName("short_name")->AsString;
     WGrid->SetCaption(WinName+NameCl);
   };
   if  (!Filt.IsEmpty())
   {  Table->SetFilter(Filt);
      Table->Filtered=true;
    }

  Table->Open();

  TWTField *Field;

 // Field = WGrid->AddColumn("id_POSITION", "Долж.", "Должность"); // из NAME_KIND Table->AddLookupField
 // Field->SetOnHelp(CliPositionSpr); //!!! имя обекта функции вызываемого справочника
 // Field->SetOnValidate(OnRefr);

  Field = WGrid->AddColumn("NAME_POSITION", "Должность", "Должность"); // из NAME_KIND Table->AddLookupField
  Field->SetOnHelp(CliPositionSpr); //!!! имя обекта функции вызываемого справочника
  Field->SetWidth(100);
  Field = WGrid->AddColumn("represent_name", "Должностное лицо", "Должностное лицо"); // из NAME_KIND Table->AddLookupField
  Field->SetWidth(200);
  Field = WGrid->AddColumn("Phone", "Телефон (раб.)", "Телефон(раб.)");
  Field = WGrid->AddColumn("Phone_home", "Телефон (дом.)", "Телефон(дом.)");

  Field = WGrid->AddColumn("last_name", "Фамилия", "Фамилия");
  Field->SetWidth(180);
  Field = WGrid->AddColumn("first_name", "Имя", "Имя");
  Field->SetWidth(180);
  Field = WGrid->AddColumn("father_name", "Отчество", "Отчество");
  Field->SetWidth(180);
  Field = WGrid->AddColumn("Information", "Доп.информация", "Доп.информация");
if ((Sender==NULL) )
  {  Field = WGrid->AddColumn("NAME_FIRM", "Фирма", "Наименование фирмы");  //!!!
     Field->SetOnHelp(CliClientMSpr);
  };

  if ( (Sender==NULL)&& (!Filt.IsEmpty()))
  {
   WGrid->DBGrid->AfterInsert=AfterInsRepRes;
  };

if ((Sender!=NULL))
  WGrid->DBGrid->AfterInsert=AfterInsRepresent;

if (Filt.IsEmpty() && (Sender==NULL))
  WGrid->DBGrid->AfterInsert=AfterInsRepresent;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
  return WGrid->DBGrid;

};
         */
#undef WinName
//------------------------------------------- End Part4 - StPositionXXX

#define WinName "Список клиентов (выбор)"
TWTDBGrid* _fastcall TMainForm::CliClientMSel(void) {
  // Определяем владельца
  TWinControl *Owner = NULL ;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTDoc *DocClient=new TWTDoc(this);
  TWTPanel* PClient=DocClient->MainPanel->InsertPanel(100,true,100);
  TWTQuery* QuerCli=new TWTQuery(this);
  QuerCli->Sql->Clear();
 /* QuerCli->Sql->Add(" select c.id,c.book,c.code,c.short_name,a.full_adr ");
  QuerCli->Sql->Add(" from clm_client_tbl c left outer join adv_address_tbl a on (c.id_addres=a.id) ");
  QuerCli->Sql->Add(" where c.book<0 ");
   */
   QuerCli->Sql->Add(" select c.id,c.book,c.code,c.short_name,c.name,flag_balance ");
  QuerCli->Sql->Add(" from clm_client_tbl c  ");
  QuerCli->Sql->Add(" where c.book<0 ");
   AnsiString fres=GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='id_res'");
   if (!(fres.IsEmpty()))
        QuerCli->Sql->Add(" and c.id_department="+fres);
   QuerCli->Sql->Add(" order by c.code ");
  QuerCli->Open();
  TWTDBGrid* DBGrClient=new TWTDBGrid(DocClient, QuerCli);
  DBGrClient->ReadOnly=true;
  TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PClient->Params->AddText("Клиенты ",18,F,Classes::taCenter,false);
  PClient->Params->AddGrid(DBGrClient, true)->ID="Client";

  //DBGrClient->Query->Open();
  TWTField *Fields;
  Fields = DBGrClient->AddColumn("code", "Лицевой", "");
  Fields = DBGrClient->AddColumn("Short_name", "Сокр. наименование", "Сокр.наименование организации, ФИО абонента");
  Fields = DBGrClient->AddColumn("name", "Наименование", "Наименование организации, ФИО абонента");

 // Fields = DBGrClient->AddColumn("full_adr", "Адрес", "Адрес");
  DBGrClient->Query->IndexFieldNames="code";

  DocClient->MainPanel->SetVResize(100);

  DocClient->ShowAs(WinName);
  DocClient->SetCaption(" Клиенты (выбор)"); //не должно содержать "["
  DocClient->MainPanel->ParamByID("Client")->Control->SetFocus();
  return DBGrClient;
};

#undef WinName

#define WinName  "Список отчетов о потреблении"

