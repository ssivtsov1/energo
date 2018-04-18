//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
//#include "fTaxListAll.h"
#include "ParamsForm.h"
//#include "fTaxPrint.h"
//#include "fTaxCorPrint.h"
//#include "ftaxprintpar.h"
#include "fPeriodSel.h"
#include "fAbonAction.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;
//TWTDBGrid* WAbonGrid;
//TWTWinDBGrid *WPrefGrid;

//----------------------------------------------------------------------
//--------------------------- ����������/����������� ���������----------
//----------------------------------------------------------------------
__fastcall TfAbonAction::TfAbonAction(TComponent* AOwner,TDataSet* ZQAbonList) : TWTDoc(AOwner)
{


  id_client = ZQAbonList->FieldByName("id")->AsInteger;

 // ������� ������� ������� ������
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
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQuery->Close();
   delete ZQuery;
   return;
  }
  ZQuery->First();
  mmgg = ZQuery->FieldByName("mmgg")->AsDateTime;

  ZQuery->Close();


  TWTPanel* PCaption=MainPanel->InsertPanel(10,true,10);

  TWTPanel* PTax=MainPanel->InsertPanel(200,true,200);

    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PCaption->Params->AddText("���������� "+ ZQAbonList->FieldByName("short_name")->AsString,10,F,Classes::taCenter,false);

  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;


   Query2->Sql->Clear();
   Query2->Sql->Add("select sw.*, \
    (case when  sw.dt_off is not null then '����.' else '    ' end)::::varchar as off, \
        (case when  sw.dt_pay is not null then '���.' else '   ' end)::::varchar  as pay, \
               (case when  sw.dt_on is not null then '�����.' else '     ' end)::::varchar  as onn \
     from clm_action_tbl sw  \
    where  sw.id_client = :client order by sw.dt_warning desc,dt_off desc,dt_pay desc; " );

   Query2->ParamByName("client")->AsInteger = id_client;

   DBGrDoc=new TWTDBGrid(PTax, Query2);

   qDocList = DBGrDoc->Query;

   DBGrDoc->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrDoc, true)->ID="A1Grid";

    TWTQuery *QuerPos=new TWTQuery(this);
    QuerPos->Sql->Add(" \
    select p.id,p.id_position,(pn.name||'  '|| p.represent_name)::::varchar(200) as represent_name from clm_position_tbl p, cli_position_tbl pn\
       where p.id_position=pn.id and p.id_client= (select value_ident from syi_sysvars_tbl where ident='id_res')::::int");
    QuerPos->Open();


    qDocList->AddLookupField("fio_person_off","id_person_off",QuerPos,"represent_name","id");
    qDocList->AddLookupField("fio_person_on","id_person_on",QuerPos,"represent_name","id");
    qDocList->AddLookupField("energy","id_pref","aci_pref_tbl","name","id");
    qDocList->AddLookupField("trans_mode","id_trans_mode","cmi_transmiss_tbl","name","id");
//    left join cmi_transmiss_tbl trans on sw.id_trans_mode=trans.id
     qDocList->Open();
  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  //NList->Add("dt");
 // NList->Add("id_person");
    NList->Add("off");
  NList->Add("pay");
    NList->Add("onn");


  qDocList->SetSQLModify("clm_action_tbl",WList,NList,true,true,true);
 // TDataSetNotifyEvent OldInsert =
  /////////////////////////qDocList->AfterInsert=  NewDocInsert;
  qDocList->OnNewRecord =  NewDocInsert;



  TWTField *Fieldh;

  Fieldh = DBGrDoc->AddColumn("off", "*", "*");
  Fieldh->SetWidth(20);
  Fieldh = DBGrDoc->AddColumn("pay", "*", "*");
  Fieldh->SetWidth(20);
  Fieldh = DBGrDoc->AddColumn("onn", "*", "*");
  Fieldh->SetWidth(20);

  Fieldh = DBGrDoc->AddColumn("energy", "��� �������", "��� �������");
  Fieldh->SetDefValue(10);
  Fieldh->SetWidth(40);
  Fieldh = DBGrDoc->AddColumn("flag_avans", "��.�����", "��.�����");
  Fieldh->AddFixedVariable("0", "���� ");
  Fieldh->AddFixedVariable("1", "�����");
  Fieldh->SetDefValue("0");
  Fieldh->SetWidth(50);
  Fieldh = DBGrDoc->AddColumn("dt_warning", "�� ���������.", "�� ���������.");
  Fieldh->SetWidth(80);


  Fieldh = DBGrDoc->AddColumn("dt_warning_to", "�� ����", "�� ����");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("dt_trans_warning", "��.����.", "��.����.");
  Fieldh->Field->OnSetText = ValidateDate;
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("trans_mode", "��� ��������", "��� ��������");
  Fieldh->SetWidth(120);

  Fieldh = DBGrDoc->AddColumn("summ_warning", "����� �������.", "����� �������.");
  Fieldh->SetWidth(80);

 Fieldh = DBGrDoc->AddColumn("comment_warning", "�����������", "�����������");
  Fieldh->SetWidth(120);


  Fieldh = DBGrDoc->AddColumn("dt_off", "��.������.", "��.������.");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("reason_off", "������� ����.", "������� ����.");
  Fieldh->SetWidth(120);

    Fieldh = DBGrDoc->AddColumn("order_off", "� ������ ����.", "� ������ ����.");
  Fieldh->SetWidth(150);

  Fieldh = DBGrDoc->AddColumn("place_off", "����� ����������", "����� ����������");
  Fieldh->SetWidth(150);

  Fieldh = DBGrDoc->AddColumn("fio_person_off", "��� ��������", "��� ��������");
  Fieldh->SetWidth(150);
    Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClientPositionResSpr);


  Fieldh = DBGrDoc->AddColumn("dt_pay", "���� ������", "���� ������");
  Fieldh->SetWidth(80);


  Fieldh = DBGrDoc->AddColumn("Summ_pay", "����� ������", "����� ������");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("dt_on", "�� �������.", "�� �������.");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("order_on", "� ������ �����.", "� ������ �����.");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("fio_person_on", "��� ���������", "��� ���������");
  Fieldh->SetWidth(120);
    Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClientPositionResSpr);


//  Fieldh = DBGrDoc->AddColumn("mmgg", "�����", "�����");
//  Fieldh->SetReadOnly();
//  Fieldh->SetWidth(80);

  DBGrDoc->Visible=true;

//----------------------------------------------------------------------------
  SetCaption("���������� "+ ZQAbonList->FieldByName("short_name")->AsString);



 };

//---------------------------------------------------------------------------


//--------------------------------------------------

void __fastcall TfAbonAction::NewDocInsert(TDataSet* DataSet)
{
 DataSet->FieldByName("dt_warning")->AsDateTime=Date();
// DataSet->FieldByName("mmgg")->AsDateTime = mmgg;
 DataSet->FieldByName("id_client")->AsInteger=id_client;
// DataSet->FieldByName("idk_document")->AsInteger=600;

}
//----------------------------------------------------------------------

void __fastcall TfAbonAction::ShowData(void)
{
 MainPanel->ParamByID("A1Grid")->Control->SetFocus();

};

//----------------------------------------------------------------------
void __fastcall TfAbonAction::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};

//----------------------------------------------------------------------




void __fastcall TMainForm::ShowAbonAction(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("��������� 2", Owner)) {
    return;
  }

  TWTPanel *TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);

  TfAbonAction* fAbonAction=new TfAbonAction(this,GrClient->DataSource->DataSet);

  fAbonAction->ShowAs("���������� 2");
 // fTaxListFull->SetCaption("������ ��������� ���������");

  fAbonAction->ID="����������2";

  fAbonAction->ShowData();

}
//----------------------------------------------------------------------------
//----------- ������ ������ --------------
//----------------------------------------------------------------------------
__fastcall TfAbonActionAll::TfAbonActionAll(TComponent* AOwner) : TWTDoc(AOwner)
{

 // ������� ������� ������� ������
  ZQuery = new TWTQuery(Application);
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
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQuery->Close();
   delete ZQuery;
   return;
  }
  ZQuery->First();
  mmgg = ZQuery->FieldByName("mmgg")->AsDateTime;

  ZQuery->Close();
     TFont *F;
  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  TWTPanel* PCaption=MainPanel->InsertPanel(10,true,10);
               TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Font=F;
  BtnRebuild->Caption=" ���������� ����������� ������ ";
  BtnRebuild->OnClick=RebuildOpl;
  BtnRebuild->Width=280;
  BtnRebuild->Top=2;
  BtnRebuild->Left=400;


  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);

  PBtn->RealHeight=25;
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";
  TWTPanel* PTax=MainPanel->InsertPanel(200,true,200);


    PCaption->Params->AddText("����������",10,F,Classes::taCenter,false);

  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;


   Query2->Sql->Clear();
   Query2->Sql->Add("select sw.*, c.code, c.short_name, \
    (case when  sw.dt_off is not null then '����.' else '    ' end)::::varchar as off, \
        (case when  sw.dt_pay is not null then '���.' else '   ' end)::::varchar  as pay, \
               (case when  sw.dt_on is not null then '�����.' else '     ' end)::::varchar  as onn \
                from clm_action_tbl as sw " );
   Query2->Sql->Add("join clm_client_tbl as c on (c.id = sw.id_client)");
   Query2->Sql->Add("order by sw.dt_warning, code ; " );



   DBGrDoc=new TWTDBGrid(PTax, Query2);

   qDocList = DBGrDoc->Query;

   DBGrDoc->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrDoc, true)->ID="AGrid";

 // qDocList->Open();



  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("dt");
  NList->Add("id_person");
  NList->Add("code");
  NList->Add("short_name");
      NList->Add("off");
  NList->Add("pay");
    NList->Add("onn");

   TWTQuery *QuerPos=new TWTQuery(this);
    QuerPos->Sql->Add(" \
    select p.id,p.id_position,(pn.name||'  '|| p.represent_name)::::varchar as represent_name from clm_position_tbl p, cli_position_tbl pn\
       where p.id_position=pn.id and p.id_client= (select value_ident from syi_sysvars_tbl where ident='id_res')::::int");
    QuerPos->Open();


    qDocList->AddLookupField("fio_person_off","id_person_off",QuerPos,"represent_name","id");
    qDocList->AddLookupField("fio_person_on","id_person_on",QuerPos,"represent_name","id");
    qDocList->AddLookupField("energy","id_pref","aci_pref_tbl","name","id");
    qDocList->AddLookupField("trans_mode","id_trans_mode","cmi_transmiss_tbl","name","id");
//    left join cmi_transmiss_tbl trans on sw.id_trans_mode=trans.id
     qDocList->Open();

  qDocList->SetSQLModify("clm_action_tbl",WList,NList,true,true,true);
 // TDataSetNotifyEvent OldInsert =
  /////////////////////////qDocList->AfterInsert=  NewDocInsert;
  qDocList->OnNewRecord =  NewDocInsert;






  qDocList->SetSQLModify("clm_action_tbl",WList,NList,true,true,true);
 // TDataSetNotifyEvent OldInsert =
  /////////////////////////qDocList->AfterInsert=  NewDocInsert;
  qDocList->OnNewRecord =  NewDocInsert;

  TWTField *Fieldh;

  Fieldh = DBGrDoc->AddColumn("code", " ", "������� ����");
  Fieldh->Field->OnValidate = ValidateAbonCode;
  Fieldh->SetWidth(50);
//  Fieldh->SetReadOnly();

  Fieldh = DBGrDoc->AddColumn("short_name", "������� ", "�������");
  Fieldh->SetReadOnly();
 

  Fieldh = DBGrDoc->AddColumn("energy", "��� �������", "��� �������");
  Fieldh->SetWidth(20);
  Fieldh = DBGrDoc->AddColumn("flag_avans", "��.�����", "��.�����");
  Fieldh->AddFixedVariable("0", "���� ");
  Fieldh->AddFixedVariable("1", "�����");

    Fieldh = DBGrDoc->AddColumn("off", "*", "*");
  Fieldh->SetWidth(20);
  Fieldh = DBGrDoc->AddColumn("pay", "*", "*");
  Fieldh->SetWidth(20);
  Fieldh = DBGrDoc->AddColumn("onn", "*", "*");
  Fieldh->SetWidth(20);

  Fieldh->SetWidth(50);
  Fieldh = DBGrDoc->AddColumn("dt_warning", "�� ���������.", "�� ���������.");
  Fieldh->SetWidth(80);


  Fieldh = DBGrDoc->AddColumn("dt_warning_to", "�� ����", "�� ����");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("dt_trans_warning", "��.����.", "��.����.");
  Fieldh->Field->OnSetText = ValidateDate;
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("trans_mode", "��� ��������", "��� ��������");
  Fieldh->SetWidth(120);

  Fieldh = DBGrDoc->AddColumn("summ_warning", "����� �������.", "����� �������.");
  Fieldh->SetWidth(80);

 Fieldh = DBGrDoc->AddColumn("comment_warning", "�����������", "�����������");
  Fieldh->SetWidth(120);


  Fieldh = DBGrDoc->AddColumn("dt_off", "��.������.", "��.������.");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("reason_off", "������� ����.", "������� ����.");
  Fieldh->SetWidth(120);

    Fieldh = DBGrDoc->AddColumn("order_off", "� ������ ����.", "� ������ ����.");
  Fieldh->SetWidth(150);

  Fieldh = DBGrDoc->AddColumn("place_off", "����� ����������", "����� ����������");
  Fieldh->SetWidth(150);

  Fieldh = DBGrDoc->AddColumn("fio_person_off", "��� ��������", "��� ��������");
  Fieldh->SetWidth(150);
    Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClientPositionResSpr);


  Fieldh = DBGrDoc->AddColumn("dt_pay", "���� ������", "���� ������");
  Fieldh->SetWidth(80);


  Fieldh = DBGrDoc->AddColumn("Summ_pay", "����� ������", "����� ������");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("dt_on", "�� �������.", "�� �������.");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("order_on", "� ������ �����.", "� ������ �����.");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("fio_person_on", "��� ���������", "��� ���������");
  Fieldh->SetWidth(120);
    Fieldh->SetOnHelp(((TMainForm*)MainForm)->ClientPositionResSpr);




  DBGrDoc->Visible=true;

//----------------------------------------------------------------------------
//  SetCaption("���������� "+ ZQAbonList->FieldByName("short_name")->AsString);
//  DocTax->ShowAs("CliTax");
//  MainPanel->ParamByID("Tax")->Control->SetFocus();

  TWTToolBar* tb=DBGrDoc->ToolBar;
  TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);

   qDocList->DefaultFilter="dt_warning >= '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and dt_warning < '"+
     FormatDateTime("yyyy-mm-dd",IncMonth(mmgg,1))+ "'";
   qDocList->Filtered=true;
   qDocList->Refresh();

   SetCaption("���������� � �������������� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

 };

//---------------------------------------------------------------------------
void __fastcall TfAbonActionAll::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;
  //  ZeroTime.TDateTime(0);

//    if (qDocList->FieldByName("mmgg")->AsDateTime != ZeroTime)
//       fPeriodSelect->FormShow(qDocList->FieldByName("mmgg")->AsDateTime,qDocList->FieldByName("mmgg")->AsDateTime);
//    else

    fPeriodSelect->FormShow(mmgg,mmgg);

    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };

   if (rez == mrOk)
   {
     qDocList->Filtered=false;
     qDocList->DefaultFilter="sw.dt >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and sw.dt <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     qDocList->Filtered=true;
     qDocList->Refresh();

     SetCaption(" ���������� � �������������� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {
     qDocList->DefaultFilter="";
     qDocList->Refresh();
     SetCaption(" ���������� � �������������� ");
   }

//    delete fPeriodSelect;

};

//--------------------------------------------------

//--------------------------------------------------

void __fastcall TfAbonActionAll::NewDocInsert(TDataSet* DataSet)
{
 DataSet->FieldByName("dt_warning")->AsDateTime=Date();
// DataSet->FieldByName("mmgg")->AsDateTime = mmgg;
 DataSet->FieldByName("percent")->AsInteger=100;
// DataSet->FieldByName("id_client")->AsInteger=id_client;
// DataSet->FieldByName("idk_document")->AsInteger=600;

}
//----------------------------------------------------------------------

void __fastcall TfAbonActionAll::ShowData(void)
{
 MainPanel->ParamByID("AGrid")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfAbonActionAll::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};
//----------------------------------------------------------------------
void __fastcall TfAbonActionAll::ValidateAbonCode(TField* Sender)
{
  int code = Sender->AsInteger;
  AnsiString name;
  int id_client;


  AnsiString sqlstr="select id, short_name from clm_client_tbl where code = :code and book = -1 ;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("code")->AsInteger = code;

  try
  {
   ZQuery->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQuery->Close();
   return;
  }
  if (ZQuery->RecordCount >0 )
  {
    ZQuery->First();
    name = ZQuery->FieldByName("short_name")->AsString;
    id_client = ZQuery->FieldByName("id")->AsInteger;

    qDocList->FieldByName("id_client")->AsInteger=id_client;
    qDocList->FieldByName("short_name")->AsString=name;
  }
  else
  {
//   ShowMessage("��� �������� � ��������� �����!");
   throw Exception("��� �������� � ��������� �����!");
  }
  ZQuery->Close();

};
//----------------------------------------------------------------------

void __fastcall TfAbonActionAll::RebuildOpl(TObject *Sender)
{

  if (MessageDlg(" �������� ����������� ������ ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }
  TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;
  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;
//  ZQSeb->Transaction->AutoCommit=false;
   AnsiString sqlstr="select calc_action() ;";
   ZQSeb->Sql->Clear();
   ZQSeb->Sql->Add(sqlstr);

   try
   {
    ZQSeb->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));

    ZQSeb->Close();

    delete ZQSeb;
    return;
   }


     qDocList->Refresh();
  // qSebLines->Refresh();
};



void __fastcall TMainForm::ShowAbonActionAll(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("���������-������", Owner)) {
    return;
  }

//  TWTPanel *TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
//  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
//  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);

  TfAbonActionAll* fAbonActionAll=new TfAbonActionAll(this);

  fAbonActionAll->ShowAs("����������-������");
 // fTaxListFull->SetCaption("������ ��������� ���������");

  fAbonActionAll->ID="����������-������";

  fAbonActionAll->ShowData();

}
//----------------------------------------------------------


