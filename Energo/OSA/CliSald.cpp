//---------------------------------------------------------------------------
// сложный справочник (предназначалось для рисования сложной формы документа) класс TWTDoc:TWTParamsForm
#include <vcl.h>
#pragma hdrstop


#include "Main.h"
#include "func.h"
#include "ClientBill.h"
#include "CliSald.h"
#include "RepSaldo.h"

int glid_client;
//---------------------------------------------------------------------
// функции класса TMainForm
//---------------------------------------------------------------------
#define WinName  "Сальдо "

_fastcall TfCliSald::TfCliSald(TWinControl* Owner, TWTQuery *query,int fid_cl)
     : TWTDoc(Owner) {
 fid_client=fid_cl;
 glid_client =fid_cl;
    AnsiString NameCl=" ";
     NameCl=query->DataSource->DataSet->FieldByName("short_name")->AsString;
     TWTQuery *QuerSal= new TWTQuery(this);

    QuerSal->Sql->Clear();
    QuerSal->Sql->Add("select *,b_val+b_valtax as b_sum ,dt_val+dt_valtax as dt_sum, \
       kt_val+kt_valtax as kt_sum ,e_val+e_valtax as e_sum \
         from acm_saldo_tbl where id_client=:pid_client");
    QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
    TWTPanel* PSaldo=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
     TButton *BtnPred=new TButton(this);
    BtnPred->Caption="Документы сальдо";
    BtnPred->OnClick=ClientSalDoc;
    BtnPred->Width=150;
    BtnPred->Top=2;
    BtnPred->Left=2;
       TButton *BtnNull=new TButton(this);
    BtnNull->Caption="";
  //  BtnPred->OnClick=ClientSalDoc;
    BtnNull->Width=150;
    BtnNull->Top=2;
    BtnNull->Left=153;
    PSaldo->Params->AddButton(BtnPred,false)->ID="BtnCard";
    PSaldo->Params->AddButton(BtnNull,false)->ID="BtnNull";
    PSaldo->Params->AddText("Cальдо по абоненту "+ NameCl,18,F,Classes::taCenter,true);


     DBGrSald=new TWTDBGrid(this, QuerSal);
    DBGrSald->SetReadOnly(false);
    PSaldo->Params->AddGrid(DBGrSald, true)->ID="Saldo";
    TWTQuery* Table = DBGrSald->Query;

    Table->AddLookupField("Name_pref","id_pref","aci_pref_tbl","name","id");

   Table->Open();
   DBGrSald->SetReadOnly(true);
   TStringList *WListP=new TStringList();
   WListP->Add("id");
   TStringList *NListP=new TStringList();
   WListP->Add("b_sum");
   WListP->Add("dt_sum");
   WListP->Add("kt_sum");
   WListP->Add("e_sum");

   QuerSal->SetSQLModify("acm_saldo_tbl",WListP,NListP,true,true,true);

   TWTField *Fieldh;

  // Fieldh = DBGrSaldo->AddColumn("id_pref", "Тип", "Тип");
  // Fieldh->SetOnHelp(DckDocumentSpr);
  // Fieldh->SetRequired("Код документа должен быть заполнен");

  Fieldh = DBGrSald->AddColumn("Name_pref", "Тип", "Код");
  //Fieldh->SetOnHelp(DckDocumentSpr);
  //Fieldh->SetRequired("Код документа должен быть заполнен");

  Fieldh = DBGrSald->AddColumn("mmgg", "Месяц", "Месяц");

  Fieldh = DBGrSald->AddColumn("b_val", "Нач.сальдо", "Нач.сальдо");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("b_valtax", "Нач.НДС", "Нач.НДС");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("b_sum", "C НДС", "C НДС");
  Fieldh->Precision=2;


  Fieldh = DBGrSald->AddColumn("dt_val", "Дебет", "Дебет");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("dt_valtax", "Дебет НДС", "Дебет НДС");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("dt_sum", "C НДС", "C НДС");
  Fieldh->Precision=2;


  Fieldh = DBGrSald->AddColumn("kt_val", "Кредит", "Кредит");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

   Fieldh = DBGrSald->AddColumn("kt_valtax", "Кредит НДС", "Кредит НДС");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("kt_sum", "C НДС", "C НДС");
  Fieldh->Precision=2;

  Fieldh = DBGrSald->AddColumn("e_val", "Кон.сальдо", "Кон.сальдо");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("e_valtax", "Кон.НДС", "Кон.НДС");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("e_sum", "C НДС", "C НДС");
  Fieldh->Precision=2;

  Fieldh = DBGrSald->AddColumn("flock", "Закр.", "Флаг закрытия месяца");
  Fieldh->AddFixedVariable("0", "     ");
  Fieldh->AddFixedVariable("1", "Закр.");
  Fieldh->SetReadOnly();

    DBGrSald->Visible=true;
  SetCaption("Сальдо по абоненту "+NameCl);
  ShowAs(WinName);
  MainPanel->ParamByID("Saldo")->Control->SetFocus();

};


//#define WinName "Документы сальдо"
void __fastcall TfCliSald::ClientSalDoc(TObject *Sender)
{    TWTPanel *TDoc;
    TWTDoc *WGrid = new TfCliSaldDoc(this, fid_client,DBGrSald);
};

# undef WinName

__fastcall TfCliSald::~TfCliSald()
{
  Close();
};
void __fastcall  TfCliSald::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

};

       /*
void __fastcall TfCliSald::ClientSalDoc(TObject *Sender)
{
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Saldo")->Control);


  TWTDoc *WGrid = new TfCliSald(this, fid_client,GrClient);


};

         */

         // Запрос параметров просмотра за период
void _fastcall TMainForm::CliSaldRep(TObject *Sender)
{  int id_client=0;
  Form = new TWTParamsForm(this, "Сальдировка");
  Form->OnAccept = CliSaldFRep;
  TStringList *SQL = new TStringList();

  SQL->Add("SELECT id, NAME FROM clm_client_tbl");
  TWTQuery* QueryCli = new TWTQuery(Form,SQL);
  QueryCli->Open();
  SQL->Clear();


  TWTParamItem* PID = Form->Params->AddSimple("Клиент: ",220, "");
  PID->ID="Client";
  PID->SetButton(SprClientClick);
  //PI->SetReadOnly(true);

    Form->Params->Get(0)->Value="";

  Form->Params->AddDate("Дата с",70,true);
  Form->Params->Get(1)->Value = BOM(Date()-30);
   Form->Params->AddDate(" по ",70,false);
    Form->Params->Get(2)->Value = EOM(Date()+30);
  Form->TForm::ShowModal();
  Form->Close();
};

AnsiString _fastcall TMainForm::SprClientClick(TWTParamItem *Sender) {
  AnsiString OldValue = Sender->Value;


  // Формируем выборку из базы
  TStringList *SQL = new TStringList();
  SQL->Add("SELECT id,code, NAME FROM clm_client_tbl order by code");
  // Создаем справочник
  TWTWinDBGrid *WinGrid = new TWTWinDBGrid(this,SQL,false);
  WinGrid->SetCaption("Справочник клиентов");
  WinGrid->DBGrid->Query->Open();
  WinGrid->DBGrid->SetReadOnly();

  WinGrid->AddColumn("CODE", "Лицевой", "");
  WinGrid->AddColumn("NAME", "Наименование", "");


  WinGrid->DBGrid->FieldSource = WinGrid->DBGrid->Query->GetTField("name");
  WinGrid->DBGrid->StringDest = OldValue;

  WinGrid->DBGrid->Visible = true;
  WinGrid->Position = poScreenCenter;
  WinGrid->TForm::ShowModal();
  Sender->Value=OldValue;
  return OldValue;
};


void _fastcall TMainForm::CliSaldFRep(TWTParamsForm *Sender, bool &flag){
  TStringList *SQL;
  Form->Hide();
  int id_client=0;
  AnsiString DateBeg = Form->Params->Get(1)->Value;
  AnsiString DateEnd = Form->Params->Get(2)->Value;
  bool Ispr=true;
  bool IsprD=true;
  bool Nispr=true;
  bool Loc=false;
  AnsiString StrClient= Form->Params->Get(0)->Value;

  TQuery * QueryZap=new TQuery(this);
  if  (!StrClient.IsEmpty())
  {  QueryZap->SQL->Clear();
     QueryZap->SQL->Add("select id from clm_client_tbl where name="+ToStrSQL(StrClient));
     QueryZap->Open();
     id_client=QueryZap->FieldByName("id")->AsVariant;
  };
  TDateTime DateOtcBeg = SetCentury(DateBeg);
  TDateTime DateOtcEnd = SetCentury(DateEnd);
  TDateTime DateOtc = DateOtcBeg;
 CliSaldRRep(id_client, DateOtcBeg,DateOtcEnd);

}

void _fastcall TMainForm::CliSaldRRep(int pid_client, TDateTime DBeg,TDateTime DEnd){
  int id_client=pid_client;
  TDateTime DateOtcBeg = DBeg;
  TDateTime DateOtcEnd = DEnd;
  TDateTime DateOtc = DateOtcBeg;
  AnsiString Head;
   Head = "Зв_т по сальда абонент_в " + DateToStr(DBeg) + " по " + DateToStr(DEnd) ;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(Head, this)) {
    return;
  }
  Application->ProcessMessages();

 TWTQuery *QueryInter=new TWTQuery(this);
      QueryInter->Sql->Clear();
      QueryInter->Sql->Add("select "+ToStrSQL(DBeg)+" as datebeg,"+ToStrSQL(DEnd)+" as dateend,");
      QueryInter->Sql->Add("cl.id,cl.code,cl.short_name as name,");
      QueryInter->Sql->Add("st.flag_taxpay as flag_taxpay,st.flag_budjet as flag_bujet,st.flag_reactive as flag_reactive,");
      QueryInter->Sql->Add(" sal.id_pref,pref.name as prefix,sal.mmgg, ");
      QueryInter->Sql->Add(" sal.b_val,sal.b_valtax,sal.b_val+sal.b_valtax as b_sum, ");
      QueryInter->Sql->Add(" sal.dt_val,sal.dt_valtax,sal.dt_val+sal.dt_valtax as dt_sum, ");
      QueryInter->Sql->Add(" sal.kt_val,sal.kt_valtax,sal.kt_val+sal.kt_valtax as kt_sum, ");
      QueryInter->Sql->Add(" sal.e_val,sal.e_valtax,sal.e_val+sal.e_valtax as e_sum ");
      QueryInter->Sql->Add(" into temp sal_rep ");
      QueryInter->Sql->Add(" from clm_client_tbl cl, clm_statecl_tbl st ,aci_pref_tbl pref,acm_saldo_tbl sal ");
      QueryInter->Sql->Add(" where cl.id=st.id_client and sal.id_client=cl.id and pref.id=sal.id_pref  ");
      QueryInter->Sql->Add(" and sal.mmgg>= " + ToStrSQL(DBeg)+" and");
      QueryInter->Sql->Add(" sal.mmgg<= " + ToStrSQL(DEnd));
      if (id_client!=0)
         QueryInter->Sql->Add(" and cl.id="+ToStrSQL(id_client));
       else
        QueryInter->Sql->Add(" order by cl.id,sal.id_pref,sal.mmgg" );
      QueryInter->ExecSql();
      Application->ProcessMessages();
      Status();
      TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,"sal_rep",false);
      WGrid->SetCaption(Head);

      WGrid->DBGrid->Timer->Enabled = false;
      WGrid->DBGrid->TimerOn = false;
      WGrid->DBGrid->SetReadOnly();
      //WGrid->DBGrid->Table->AddLookupField("pre")
      WGrid->DBGrid->Table->Open();

  TWTField *Fieldh;
   Fieldh = WGrid->DBGrid->AddColumn("code", "Лицевой", "Лицевой");
   Fieldh = WGrid->DBGrid->AddColumn("name", "Фирма", "Фирма");
   Fieldh = WGrid->DBGrid->AddColumn("mmgg", "Период", "Период");
   Fieldh = WGrid->DBGrid->AddColumn("prefix", "Вид", "Вид");
   TWTDBGrid *DBGrSaldo=WGrid->DBGrid;
   Fieldh = DBGrSaldo->AddColumn("b_val", "Нач.сальдо", "Нач.сальдо");
   Fieldh->Precision=2;
   Fieldh->SetReadOnly();
   Fieldh = DBGrSaldo->AddColumn("b_valtax", "Нач.НДС", "Нач.НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("b_sum", "C НДС", "C НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("dt_val", "Дебет", "Дебет");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("dt_valtax", "Дебет НДС", "Дебет НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("dt_sum", "C НДС", "C НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("kt_val", "Кредит", "Кредит");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("kt_valtax", "Кредит НДС", "Кредит НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("kt_sum", "C НДС", "C НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("e_val", "Кон.сальдо", "Кон.сальдо");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("e_valtax", "Кон.НДС", "Кон.НДС");
   Fieldh->Precision=2;
   Fieldh = DBGrSaldo->AddColumn("e_sum", "C НДС", "C НДС");
   Fieldh->Precision=2;

  //delete SQL;
  TWTToolBar *ToolBar = new TWTToolBar(this);
  ToolBar->Parent = this;
  ToolBar->ID = "Главная панель";
  ToolBar->AddButton("Print", "Печать ", PrintSaldo);
  //WGrid->CoolBar->AddToolBar(ToolBar);


  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("WinRep");
  //WGrid->BeforeClose=CloseRep;
  WGrid->DBGrid->BeforeClose=CloseRep;

  // ShowMessage("Продолжение следует");

}

void _fastcall TMainForm::CloseRep (TWTDBGrid *Sender){

}
void _fastcall TMainForm::PrintSaldo(TObject *Sender)
{
 Application->CreateForm(__classid(TPrintSald), &PrintSald);

 };

 #define WinName "Журнал оборотов по актам ППЕЕ"
_fastcall TfSaldAkt::TfSaldAkt(TWinControl *owner)  : TWTDoc(owner)
{
           TWTQuery *QuerTax=new TWTQuery(this);
  QuerTax->Sql->Clear();
  QuerTax->Sql->Add("select fun_tax('tax',NULL)");
  QuerTax->Open();
  nds=QuerTax->Fields->Fields[0]->AsFloat;
   TButton *BtnPower=new TButton(this);

  BtnPower->Caption="Переформировать.";
  BtnPower->OnClick=Calc_Saldoakt;
  BtnPower->Width=140;
  BtnPower->Top=2;
  BtnPower->Left=614;

  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=700;
  TWTPanel* PBtnP=MainPanel->InsertPanel(25,25);
  //TWTPanel* PBtnP=DocHInd->MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnPower,false)->ID="BtnCalc";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnDemL";


    TWTPanel* PHSald=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;

    PHSald->Params->AddText("Список клиентов ",18,F,Classes::taCenter,false);

    QuerH=new TWTQuery(this);
    QuerH->Sql->Add("select sn.id_group as group_id,sn.name as group_name,  \
     c.id as id_client,c.code ,c.name from clm_client_tbl c \
  left join clm_statecl_tbl s on c.id=s.id_client \
  join ( select s.id_client,s.id_section as id_group,s1.name,s1.sort \
           from clm_statecl_tbl  s        \
             left join  cla_param_tbl s1 \
              on (s.id_section=s1.id)      \
         ) as sn on sn.id_client=c.id \
order by sn.sort,c.code ");

    DBGrH=new TWTDBGrid(this, QuerH);
    PHSald->Params->AddGrid(DBGrH, true)->ID="HSaldo";
    DBGrH->SetReadOnly(true);
    QuerH->Open();

  TWTField *Fieldh;

  Fieldh = DBGrH->AddColumn("code", "лицевой", "");
  Fieldh->SetWidth(100);

  Fieldh = DBGrH->AddColumn("name", "название", "");
   Fieldh = DBGrH->AddColumn("group_name", "Группа","" );

  TWTPanel* PSaldo=MainPanel->InsertPanel(200,true,200);

  QuerSal=new TWTQuery(this);
  QuerSal->Sql->Clear();
  QuerSal->Sql->Add("select *,b_val+b_valtax as b_sum ,dt_val+dt_valtax as dt_sum, \
       kt_val+kt_valtax as kt_sum ,e_val+e_valtax as e_sum \
         from acm_saldoakt_tbl order by id_client,mmgg,mmgg_p desc ");

  DBGrSald=new TWTDBGrid(this, QuerSal);
  DBGrSald->SetReadOnly(false);
  PSaldo->Params->AddGrid(DBGrSald, true)->ID="Saldo";

  QuerSal->IndexFieldNames = "id_client";
  QuerSal->LinkFields = "id_client=id_client";
  QuerSal->MasterSource = DBGrH->DataSource;

   QuerSal->Open();
   TStringList *WListP=new TStringList();
   WListP->Add("id");

   TStringList *NListP=new TStringList();

   NListP->Add("b_sum");
   NListP->Add("dt_sum");
   NListP->Add("kt_sum");
   NListP->Add("e_sum");

   QuerSal->SetSQLModify("acm_saldoakt_tbl",WListP,NListP,true,true,true);

  TWTField *Fields;
  Fields = DBGrSald->AddColumn("mmgg", "Месяц", "Месяц");
      Fields->OnChange=OnChangeMG;
  Fields = DBGrSald->AddColumn("mmgg_p", "Период", "Период");
        Fields->OnChange=OnChangeMG;
  Fields = DBGrSald->AddColumn("b_val", "Нач.сальдо", "Нач.сальдо");
  Fields->Precision=2;
    Fields->OnChange=OnChangeVal;
  if ( (Date())>StrToDate("31.08.2006"))
      { Fields->SetReadOnly();

       };
  Fields = DBGrSald->AddColumn("b_valtax", "Нач.НДС", "Нач.НДС");
  Fields->Precision=2;
 if ( (Date())>StrToDate("31.08.2006"))
   Fields->SetReadOnly();
     Fields->OnChange=OnChangeValTax;

  Fields = DBGrSald->AddColumn("b_sum", "C НДС", "C НДС");
  Fieldh->Precision=2;
  if ( (Date())>StrToDate("31.08.2006"))
  Fields->SetReadOnly();

  Fields = DBGrSald->AddColumn("kvt", "кВт.ч", "Начислено");
  Fields->Precision=0;
   //Fields->OnChange=OnChangeValTax;

  Fields = DBGrSald->AddColumn("dt_val", "Дебет", "Дебет");
  Fields->Precision=2;
  Fields->OnChange=OnChangeVal;



  Fields = DBGrSald->AddColumn("dt_valtax", "Дебет НДС", "Дебет НДС");
  Fields->Precision=2;
   Fields->OnChange=OnChangeValTax;

  Fields = DBGrSald->AddColumn("dt_sum", "C НДС", "C НДС");
  Fields->Precision=2;
  Fields->SetReadOnly();

  Fields = DBGrSald->AddColumn("kt_val", "Кредит", "Кредит");
  Fields->Precision=2;
  Fields->OnChange=OnChangeVal;
  Fields = DBGrSald->AddColumn("kt_valtax", "Кредит НДС", "Кредит НДС");
  Fields->Precision=2;
  Fields->OnChange=OnChangeValTax;

  Fields = DBGrSald->AddColumn("kt_sum", "C НДС", "C НДС");
  Fields->Precision=2;
    Fields->SetReadOnly();

  Fields = DBGrSald->AddColumn("e_val", "Кон.сальдо", "Кон.сальдо");
  Fields->Precision=2;
    Fields->SetReadOnly();

  Fields = DBGrSald->AddColumn("e_valtax", "Кон.НДС", "Кон.НДС");
  Fields->Precision=2;
    Fields->SetReadOnly();
  Fields = DBGrSald->AddColumn("e_sum", "C НДС", "C НДС");
  Fields->Precision=2;
  Fields->SetReadOnly();
  Fields = DBGrSald->AddColumn("flock", "Закр.", "Флаг закрытия месяца");
  Fields->AddFixedVariable("0", "     ");
  Fields->AddFixedVariable("1", "Закр.");
  Fields->SetReadOnly();


  DBGrSald->Visible=true;
  DBGrSald->OnDrawColumnCell=DrawColumnCell;

  SetCaption("Сальдировка по актам");
  ShowAs(WinName);
  MainPanel->ParamByID("HSaldo")->Control->SetFocus();
  MainPanel->ParamByID("Saldo")->Control->SetFocus();
  MainPanel->ParamByID("HSaldo")->Control->SetFocus();
 }


 void __fastcall TfSaldAkt::DrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{  float dt_val;
    float dt_valtax;
   float kt_val;
    float kt_valtax;

  TDBGrid* t=(TDBGrid*)Sender;
 dt_val =t->DataSource->DataSet->FieldByName("dt_val")->AsFloat;
 dt_valtax =t->DataSource->DataSet->FieldByName("dt_valtax")->AsFloat;

 kt_val =t->DataSource->DataSet->FieldByName("kt_val")->AsFloat;
 kt_valtax =t->DataSource->DataSet->FieldByName("kt_valtax")->AsFloat;

    if ( (Round( dt_val/(1/nds*100)- dt_valtax,0)!=0)||(Round( kt_val/(1/nds*100)- kt_valtax,0)!=0)   )
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

__fastcall TfSaldAkt::~TfSaldAkt()
{
  Close();
};


 void __fastcall TfSaldAkt::OnChangeVal(TWTField *Sender)
{
 AnsiString NField;
 NField=Sender->Field->Name;

 if  (NField=="b_val")
 {
  Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat=Round(Sender->Field->AsFloat/((100)/nds),2);
  Sender->Field->DataSet->FieldByName("b_sum")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_val")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("dt_val")->AsFloat-Sender->Field->DataSet->FieldByName("kt_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat=Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat+Sender->Field->DataSet->FieldByName("dt_valtax")->AsFloat -Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_sum")->AsFloat=Sender->Field->DataSet->FieldByName("e_val")->AsFloat+Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat;

 };

 if  (NField=="dt_val")
 {
  Sender->Field->DataSet->FieldByName("dt_valtax")->AsFloat=Round(Sender->Field->AsFloat/((100)/nds),2);
  Sender->Field->DataSet->FieldByName("dt_sum")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("dt_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_val")->AsFloat=Sender->Field->DataSet->FieldByName("b_val")->AsFloat+Sender->Field->AsFloat -Sender->Field->DataSet->FieldByName("kt_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat=Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat+Sender->Field->DataSet->FieldByName("dt_valtax")->AsFloat -Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_sum")->AsFloat=Sender->Field->DataSet->FieldByName("e_val")->AsFloat+Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat;

 };
 if  (NField=="kt_val")
 {
   Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat=Round(Sender->Field->AsFloat/((100)/nds),2);
   Sender->Field->DataSet->FieldByName("kt_sum")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat;

  Sender->Field->DataSet->FieldByName("e_val")->AsFloat=Sender->Field->DataSet->FieldByName("b_val")->AsFloat-Sender->Field->AsFloat +Sender->Field->DataSet->FieldByName("dt_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat=Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat-Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat +Sender->Field->DataSet->FieldByName("dt_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_sum")->AsFloat=Sender->Field->DataSet->FieldByName("e_val")->AsFloat+Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat;

 };

};

 void __fastcall TfSaldAkt::OnChangeValTax(TWTField *Sender)
{
 AnsiString NField;
 NField=Sender->Field->Name;

 if  (NField=="b_valtax")
 {
  Sender->Field->DataSet->FieldByName("b_sum")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("b_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("dt_valtax")->AsFloat -Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_sum")->AsFloat=Sender->Field->DataSet->FieldByName("e_val")->AsFloat+Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat;

 };

 if  (NField=="dt_valtax")
 {
  Sender->Field->DataSet->FieldByName("dt_sum")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("dt_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat=Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat+Sender->Field->AsFloat -Sender->Field->DataSet->FieldByName("kt_valtax")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_sum")->AsFloat=Sender->Field->DataSet->FieldByName("e_val")->AsFloat+Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat;

 };
 if  (NField=="kt_val")
 {
   Sender->Field->DataSet->FieldByName("kt_sum")->AsFloat=Sender->Field->AsFloat+Sender->Field->DataSet->FieldByName("kt_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat=Sender->Field->DataSet->FieldByName("b_valtax")->AsFloat-Sender->Field->AsFloat +Sender->Field->DataSet->FieldByName("dt_val")->AsFloat;
  Sender->Field->DataSet->FieldByName("e_sum")->AsFloat=Sender->Field->DataSet->FieldByName("e_val")->AsFloat+Sender->Field->DataSet->FieldByName("e_valtax")->AsFloat;
 };

};

 void __fastcall TfSaldAkt::OnChangeMG(TWTField *Sender)
{
 AnsiString NField;
 NField=Sender->Field->Name;

  if (  Sender->Field->AsDateTime !=BOM(Sender->Field->AsDateTime))
  ShowMessage("Дата должна соответствовать началу месяца!")
  ;


};

void __fastcall TfSaldAkt::Calc_Saldoakt(TObject *Sender)
{ if (MessageDlg(" Разнести обороты по актам ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }
   TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;
  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;
  //ZQSeb->Transaction->AutoCommit=false;

   AnsiString sqlstr="select seb_saldakt(fun_mmgg(),0) ;";
   ZQSeb->Sql->Clear();
   ZQSeb->Sql->Add(sqlstr);
  // ZQSeb->ParamByName("dat")->AsDateTime=BOM()

   try
   {
    ZQSeb->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка "+e.Message.SubString(8,200));
//    ZQSeb->Transaction->Rollback();
    ZQSeb->Close();
//    ZQSeb->Transaction->AutoCommit=true;
    delete ZQSeb;
    return;
   }
   DBGrSald->Refresh();
}
#undef WinName

              //////////////////////////////////

#define WinName  "Документы на подключение "
_fastcall TfCliCDocs::TfCliCDocs(TWinControl* Owner, TWTQuery *query,int fid_cl)
     : TWTDoc(Owner) {
 fid_client=fid_cl;
 glid_client =fid_cl;
    AnsiString NameCl=" ";
     NameCl=query->DataSource->DataSet->FieldByName("short_name")->AsString;
     TWTQuery *QuerSal= new TWTQuery(this);
    QuerSal->Sql->Clear();
    QuerSal->Sql->Add("select * from  clm_docconnect_tbl where id_client=:pid_client \
      ");
    QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
    QuerSal->AddLookupField("name_tu", "id_org_tu", "clm_org_tbl", "short_name","id");
    QuerSal->AddLookupField("name_proect", "id_org_proect", "clm_org_tbl", "short_name","id");

    TWTPanel* PSaldo=MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PSaldo->Params->AddText("Документы на подключение по абоненту "+ NameCl,18,F,Classes::taCenter,true);
    DBGrSald=new TWTDBGrid(this, QuerSal);
    PSaldo->Params->AddGrid(DBGrSald, true)->ID="Saldo";
    TWTQuery* Table = DBGrSald->Query;


   Table->Open();

   TStringList *WListP=new TStringList();
   WListP->Add("id");
   TStringList *NListP=new TStringList();
  // WListP->Add("name_tu");
  // WListP->Add("name_proect");

   QuerSal->SetSQLModify("clm_docconnect_tbl",WListP,NListP,true,true,true);

   TWTField *Fieldh;

  Fieldh = DBGrSald->AddColumn("name", "Номер и описание техусловий", "");
  Fieldh = DBGrSald->AddColumn("dt_tu", "Дата техусловий", "Дата выдачи техусловий");
  Fieldh = DBGrSald->AddColumn("name_tu", "Орг.выдавшая техусловия", "");
  Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClmOrgSpr);
  Fieldh = DBGrSald->AddColumn("n_pay_tu", "№ оплаты ТУ", "");
  Fieldh = DBGrSald->AddColumn("dt_pay_tu", "Дата опл.ТУ", "");
  Fieldh = DBGrSald->AddColumn("set_power_tu", "Мощьность по ТУ", "");
  Fieldh->Precision=4;

  Fieldh = DBGrSald->AddColumn("n_connect", "№ дог.присоединения", "");
  Fieldh = DBGrSald->AddColumn("dt_connect", "Дата дог.присоединения", "");
  Fieldh = DBGrSald->AddColumn("n_pay_connect", "№ опл.присоединения", "");
  Fieldh = DBGrSald->AddColumn("dt_pay_connect", "Дата опл. присоединения","");

 Fieldh = DBGrSald->AddColumn("name_proect", "Орг.проектной документации", "");
 Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClmOrgSpr);
 Fieldh = DBGrSald->AddColumn("n_pay_proect", "№ оплаты проекта", "");
 Fieldh = DBGrSald->AddColumn("dt_pay_proect", "Дата опл.проекта", "");

 Fieldh = DBGrSald->AddColumn("n_act_net", "№ допуску подключения", "");
 Fieldh = DBGrSald->AddColumn("dt_act_net", "Дата допуску подключения", "");

 Fieldh = DBGrSald->AddColumn("n_common_use", "№ дог.совм.использования", "");
 Fieldh = DBGrSald->AddColumn("dt_common_use", "Дата дог.совм.использования", "");

// Fieldh = DBGrSald->AddColumn("dt_real_connect", "", "C НДС");


  Fieldh = DBGrSald->AddColumn("mmgg", "Месяц", "Месяц");
   Fieldh->SetReadOnly();

  Fieldh = DBGrSald->AddColumn("flock", "Закр.", "Флаг закрытия месяца");
  Fieldh->AddFixedVariable("0", "     ");
  Fieldh->AddFixedVariable("1", "Закр.");
  Fieldh->SetReadOnly();

//   DBGrHInd->BeforePost=CheckIndic;
//  DBGrHInd->AfterPost=IndicAddNew;
  DBGrSald->AfterInsert=AddCl;
    DBGrSald->Visible=true;
  SetCaption("Документы подключения по абоненту "+NameCl);
  ShowAs(WinName);
  MainPanel->ParamByID("Saldo")->Control->SetFocus();
  //return DBGrSald;
};



# undef WinName

__fastcall TfCliCDocs::~TfCliCDocs()
{
  Close();
};
void __fastcall  TfCliCDocs::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

};

void _fastcall TfCliCDocs::AddCl(TWTDBGrid *Sender) {
int i=0;
int id_clientp=0;
  TWTDBGrid *GrIndic= Sender;
  id_clientp =fid_client;
  Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=id_clientp;
  Sender->DataSource->DataSet->FieldByName("dt_tu")->AsDateTime=Date();

}

