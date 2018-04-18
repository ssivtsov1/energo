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
#include "fAbonSw.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;
//TWTDBGrid* WAbonGrid;
//TWTWinDBGrid *WPrefGrid;

//----------------------------------------------------------------------
//--------------------------- ����������/����������� ���������----------
//----------------------------------------------------------------------
__fastcall TfAbonSwitch::TfAbonSwitch(TComponent* AOwner,TDataSet* ZQAbonList) : TWTDoc(AOwner)
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

/*
  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
  BtnPrint->OnClick=ClientTaxPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;

  TButton *BtnPrintAll=new TButton(this);
  BtnPrintAll->Caption="������ ���";
  BtnPrintAll->OnClick=AllTaxPrint;
  BtnPrintAll->Width=100;
  BtnPrintAll->Top=2;
  BtnPrintAll->Left=200;

  TButton *BtnNewCor=new TButton(this);
  BtnNewCor->Caption="������ �������";
  BtnNewCor->OnClick=TaxCorManual;
  BtnNewCor->Width=100;
  BtnNewCor->Top=2;
  BtnNewCor->Left=400;

  TButton *BtnDel=new TButton(this);
  BtnDel->Caption=" ������� ";
  BtnDel->OnClick=TaxDelete;
  BtnDel->Width=100;
  BtnDel->Top=2;
  BtnDel->Left=600;

  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=600;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;
  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
  PBtn->Params->AddButton(BtnPrintAll,false)->ID="BtnPrnAll";
  PBtn->Params->AddButton(BtnNewCor,false)->ID="BtnNewCor";
  PBtn->Params->AddButton(BtnDel,false)->ID="BtnDel";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";

*/

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
   Query2->Sql->Add("select sw.*  from clm_switching_tbl as sw " );
   Query2->Sql->Add("where sw.id_client = :client order by sw.dt_action desc ; " );

   Query2->ParamByName("client")->AsInteger = id_client;

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
  qDocList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("dt");
  NList->Add("id_person");
//  NList->Add("mmgg");
//  NList->Add("flock");


  qDocList->SetSQLModify("clm_switching_tbl",WList,NList,true,true,true);
 // TDataSetNotifyEvent OldInsert =
  /////////////////////////qDocList->AfterInsert=  NewDocInsert;
  qDocList->OnNewRecord =  NewDocInsert;

  TWTField *Fieldh;

  Fieldh = DBGrDoc->AddColumn("dt_action", "���� �������", "���� �������");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("action", "�������", "�������");
  Fieldh->AddFixedVariable("1", "��������");
  Fieldh->AddFixedVariable("2", "������������");
  Fieldh->AddFixedVariable("5", "������������(�����)");
  Fieldh->AddFixedVariable("3", "���������");
  Fieldh->AddFixedVariable("4", "��������");
  Fieldh->SetDefValue("2");
  Fieldh->SetWidth(130);

  Fieldh = DBGrDoc->AddColumn("dt_warning", "������������ �� ", "��");
  Fieldh->Field->OnSetText = ValidateDate;
  Fieldh->SetWidth(120);

  Fieldh = DBGrDoc->AddColumn("reason_off", "������� ��������������", "������� ��������������");
  Fieldh->SetWidth(200);

  Fieldh = DBGrDoc->AddColumn("place_off", "����� ����������", "����� ����������");
  Fieldh->SetWidth(200);

  Fieldh = DBGrDoc->AddColumn("percent", "�������", "�������");
  Fieldh->SetWidth(100);
  Fieldh->SetDefValue(100);

  Fieldh = DBGrDoc->AddColumn("Sum_warning", "����� (�����)", "����� ��� ������");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("sum_ae", "��,���", "����� ��");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("sum_re", "��,���", "����� ��");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("sum_2kr", "2��,���", "����� �� ��������� ������");
  Fieldh->SetWidth(80);

 // Fieldh->SetDefValue();

  Fieldh = DBGrDoc->AddColumn("dt_transmiss", "���� ��������", "���� ��������");
  Fieldh->Field->OnSetText = ValidateDate;
  Fieldh->SetWidth(120);

  Fieldh = DBGrDoc->AddColumn("mode_transmiss", "������ ��������", "������ ��������");
  Fieldh->SetWidth(200);

  Fieldh = DBGrDoc->AddColumn("comment", "�����������", "�����������");
  Fieldh->SetWidth(200);



//  Fieldh = DBGrDoc->AddColumn("mmgg", "�����", "�����");
//  Fieldh->SetReadOnly();
//  Fieldh->SetWidth(80);

  DBGrDoc->Visible=true;

//----------------------------------------------------------------------------
  SetCaption("���������� "+ ZQAbonList->FieldByName("short_name")->AsString);
//  DocTax->ShowAs("CliTax");
//  MainPanel->ParamByID("Tax")->Control->SetFocus();

/*
  TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);

   qDocList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qDocList->Filtered=true;
   qDocList->Refresh();

   SetCaption("������������� ��������� ��������� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");
*/


 };

//---------------------------------------------------------------------------

/*
void __fastcall TfTaxCorListFull::ClientTaxPrint(TObject *Sender)
{
  int id_tax=qDocList->FieldByName("id_doc")->AsInteger;
//  Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
  fRepTaxCor->ShowTaxCor(id_tax);

};
*/
//--------------------------------------------------

void __fastcall TfAbonSwitch::NewDocInsert(TDataSet* DataSet)
{
 DataSet->FieldByName("dt_action")->AsDateTime=Date();
// DataSet->FieldByName("mmgg")->AsDateTime = mmgg;
 DataSet->FieldByName("action")->AsInteger=2;
 DataSet->FieldByName("percent")->AsInteger=100;
 DataSet->FieldByName("id_client")->AsInteger=id_client;
// DataSet->FieldByName("idk_document")->AsInteger=600;

}
//----------------------------------------------------------------------

void __fastcall TfAbonSwitch::ShowData(void)
{
 MainPanel->ParamByID("SwGrid")->Control->SetFocus();
// MainPanel->ParamByID("DocLines")->Control->SetFocus();
// MainPanel->ParamByID("DemLimitH")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfAbonSwitch::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};

//----------------------------------------------------------------------

void __fastcall TMainForm::ShowAbonSwitch(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("���������", Owner)) {
    return;
  }

  TWTPanel *TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);

  TfAbonSwitch* fAbonSwitch=new TfAbonSwitch(this,GrClient->DataSource->DataSet);

  fAbonSwitch->ShowAs("����������");
 // fTaxListFull->SetCaption("������ ��������� ���������");

  fAbonSwitch->ID="����������";

  fAbonSwitch->ShowData();

}
//----------------------------------------------------------------------------
//----------- ������ ������ --------------
//----------------------------------------------------------------------------
__fastcall TfAbonSwitchAll::TfAbonSwitchAll(TComponent* AOwner) : TWTDoc(AOwner)
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

  TWTPanel* PCaption=MainPanel->InsertPanel(10,true,10);

  TWTPanel* PTax=MainPanel->InsertPanel(200,true,200);

    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PCaption->Params->AddText("����������",10,F,Classes::taCenter,false);

  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;


   Query2->Sql->Clear();
   Query2->Sql->Add("select sw.*, c.code, c.short_name  from clm_switching_tbl as sw " );
   Query2->Sql->Add("join clm_client_tbl as c on (c.id = sw.id_client)");
   Query2->Sql->Add("order by sw.dt_action, code ; " );

//   Query2->ParamByName("client")->AsInteger = id_client;

   DBGrDoc=new TWTDBGrid(PTax, Query2);

   qDocList = DBGrDoc->Query;

   DBGrDoc->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrDoc, true)->ID="SwGrid";

  qDocList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("dt");
  NList->Add("id_person");
  NList->Add("code");
  NList->Add("short_name");


  qDocList->SetSQLModify("clm_switching_tbl",WList,NList,true,true,true);
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


  Fieldh = DBGrDoc->AddColumn("dt_action", "���� �������", "���� �������");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("action", "�������", "�������");
  Fieldh->AddFixedVariable("1", "��������");
  Fieldh->AddFixedVariable("2", "������������");
  Fieldh->AddFixedVariable("5", "������������(�����)");
  Fieldh->AddFixedVariable("3", "���������");
  Fieldh->AddFixedVariable("4", "��������");
  Fieldh->SetDefValue("2");
  Fieldh->SetWidth(130);

  Fieldh = DBGrDoc->AddColumn("dt_warning", "������������ �� ", "��");
  Fieldh->SetWidth(100);

  Fieldh = DBGrDoc->AddColumn("reason_off", "������� ��������������", "������� ��������������");
  Fieldh->SetWidth(150);

  Fieldh = DBGrDoc->AddColumn("place_off", "����� ����������", "����� ����������");
  Fieldh->SetWidth(150);

  Fieldh = DBGrDoc->AddColumn("percent", "�������", "�������");
  Fieldh->SetWidth(60);
  Fieldh->SetDefValue(100);

  Fieldh = DBGrDoc->AddColumn("Sum_warning", "����� (�����)", "����� ��� ������");
  Fieldh->SetWidth(100);
 // Fieldh->SetDefValue();

  Fieldh = DBGrDoc->AddColumn("dt_transmiss", "���� ��������", "���� ��������");
  Fieldh->SetWidth(80);

  Fieldh = DBGrDoc->AddColumn("mode_transmiss", "������ ��������", "������ ��������");
  Fieldh->SetWidth(200);

  Fieldh = DBGrDoc->AddColumn("comment", "�����������", "�����������");
  Fieldh->SetWidth(200);


  DBGrDoc->Visible=true;

//----------------------------------------------------------------------------
//  SetCaption("���������� "+ ZQAbonList->FieldByName("short_name")->AsString);
//  DocTax->ShowAs("CliTax");
//  MainPanel->ParamByID("Tax")->Control->SetFocus();

  TWTToolBar* tb=DBGrDoc->ToolBar;
  TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);

   qDocList->DefaultFilter="dt_action >= '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and dt_action < '"+
     FormatDateTime("yyyy-mm-dd",IncMonth(mmgg,1))+ "'";
   qDocList->Filtered=true;
   qDocList->Refresh();

   SetCaption("���������� � �������������� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

 };

//---------------------------------------------------------------------------
void __fastcall TfAbonSwitchAll::PeriodSel(TObject *Sender)
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
     qDocList->DefaultFilter="dt_action >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and dt_action <= '"
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

void __fastcall TfAbonSwitchAll::NewDocInsert(TDataSet* DataSet)
{
 DataSet->FieldByName("dt_action")->AsDateTime=Date();
// DataSet->FieldByName("mmgg")->AsDateTime = mmgg;
 DataSet->FieldByName("action")->AsInteger=2;
 DataSet->FieldByName("percent")->AsInteger=100;
// DataSet->FieldByName("id_client")->AsInteger=id_client;
// DataSet->FieldByName("idk_document")->AsInteger=600;

}
//----------------------------------------------------------------------

void __fastcall TfAbonSwitchAll::ShowData(void)
{
 MainPanel->ParamByID("SwGrid")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfAbonSwitchAll::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};
//----------------------------------------------------------------------
void __fastcall TfAbonSwitchAll::ValidateAbonCode(TField* Sender)
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

void __fastcall TMainForm::ShowAbonSwitchAll(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("���������-������", Owner)) {
    return;
  }

//  TWTPanel *TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
//  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
//  TWTDBGrid *GrClient= ((TWTDBGrid *)MPanel->ParamByID("Client")->Control);

  TfAbonSwitchAll* fAbonSwitchAll=new TfAbonSwitchAll(this);

  fAbonSwitchAll->ShowAs("����������-������");
 // fTaxListFull->SetCaption("������ ��������� ���������");

  fAbonSwitchAll->ID="����������-������";

  fAbonSwitchAll->ShowData();

}
//----------------------------------------------------------

