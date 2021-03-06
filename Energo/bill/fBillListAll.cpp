//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "fBillListAll.h"
#include "ParamsForm.h"
#include "fBillPrint.h"
#include "fPeriodSel.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;
TWTDBGrid* WAbonGrid;
TWTWinDBGrid *WPrefGrid;

__fastcall TfBillListFull::TfBillListFull(TComponent* AOwner) : TWTDoc(AOwner)
{

 // ������� ������� ������� ������
  TWTQuery * ZQBill = new TWTQuery(Application);
  ZQBill->Options<< doQuickOpen;

  ZQBill->RequestLive=false;
  ZQBill->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQBill->Sql->Clear();
  ZQBill->Sql->Add(sqlstr);

  try
  {
   ZQBill->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQBill->Close();
   delete ZQBill;
   return;
  }
  ZQBill->First();
  mmgg = ZQBill->FieldByName("mmgg")->AsDateTime;

  ZQBill->Close();

  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
  BtnPrint->OnClick=ClientBillPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;
/*
  TButton *BtnPrintAll=new TButton(this);
  BtnPrintAll->Caption="������ ���";
  BtnPrintAll->OnClick=AllTaxPrint;
  BtnPrintAll->Width=100;
  BtnPrintAll->Top=2;
  BtnPrintAll->Left=200;
*/
/*
  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption=" ��������������� ";
  BtnRebuild->OnClick=TaxRebuild;
  BtnRebuild->Width=100;
  BtnRebuild->Top=2;
  BtnRebuild->Left=400;

  TButton *BtnDel=new TButton(this);
  BtnDel->Caption=" ������� ";
  BtnDel->OnClick=TaxDelete;
  BtnDel->Width=100;
  BtnDel->Top=2;
  BtnDel->Left=600;

  TButton *BtnDelAll=new TButton(this);
  BtnDelAll->Caption=" ������� ����� ";
  BtnDelAll->OnClick=TaxDeleteAll;
  BtnDelAll->Width=100;
  BtnDelAll->Top=2;
  BtnDelAll->Left=800;
*/
  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;

  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
/*
  PBtn->Params->AddButton(BtnPrintAll,false)->ID="BtnPrnAll";
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
  PBtn->Params->AddButton(BtnDel,false)->ID="BtnDel";
  PBtn->Params->AddButton(BtnDelAll,false)->ID="BtnDelAll";
*/
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";


    TWTPanel* PTax=MainPanel->InsertPanel(200,true,MainForm->Height/2);
//  TWTPanel* PTax=MainPanel->InsertPanel(200,200);
 /*
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PTax->Params->AddText("��������� ���������",18,F,Classes::taCenter,false);
   */

   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;
//   Query2->MacroCheck=true;

   Query2->Sql->Clear();
   Query2->Sql->Add("select b.*, b.value+b.value_tax as value_sum, c.code, c.short_name, p.name as name_pref,d.name as kind_doc from acm_bill_tbl as b " );
 //  Query2->Sql->Add("join clm_client_tbl as c on (c.id= t.id_client) %cond order by int_num; " );
   Query2->Sql->Add("join clm_client_tbl as c on (c.id= b.id_client) ");
   Query2->Sql->Add("join aci_pref_tbl as p on (p.id= b.id_pref) ");
   Query2->Sql->Add("join dci_document_tbl as d on (d.id= b.idk_doc) ");
   Query2->Sql->Add("where c.book = -1 ");   
//   Query2->Sql->Add("where (int_num >= :start and int_num <= :stop and mmgg = :mmgg) or ( :all = 1 ) ");
//   Query2->Sql->Add("or (mmgg >= :startdt and mmgg <= :stopdt ) ");
   Query2->Sql->Add("order by code,mmgg; " );

   DBGrBill=new TWTDBGrid(PTax, Query2);

   qBillList = DBGrBill->Query;
   qBillList->Options<< doQuickOpen;

   DBGrBill->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrBill, true)->ID="Bill";

//  qBillList->ParamByName("all")->AsInteger=1;

//  qBillList->AddLookupField("Name_pref","id_pref","aci_pref_tbl","name","id");


  //DBGrBill->SetReadOnly(true);

   qBillList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qBillList->Filtered=true;

  qBillList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
  NList->Add("value_sum");
  NList->Add("code");
  NList->Add("short_name");
  NList->Add("id_client");
  NList->Add("mmgg");
  NList->Add("name_pref");
  NList->Add("kind_doc");

  qBillList->SetSQLModify("acm_bill_tbl",WList,NList,false,false,true);
  qBillList->AfterInsert=CancelInsert;


  TWTField *Fieldh;

  Fieldh = DBGrBill->AddColumn("code", " ", "������� ����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("short_name", "������� ", "�������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("reg_num", "�����", "����� �����");
  Fieldh->SetWidth(90);
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("reg_date", "����", "���� �������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("Name_pref", "���", "���");
  Fieldh->SetWidth(20);
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("kind_doc", "��� ���������", "��� ���������");
  Fieldh->SetWidth(100);  
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("demand_val", "�����������", "�����������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("value", "����� ��� ���", "����� ��� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("value_tax", "���", "����� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("value_sum", "����� � ���", "����� � ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrBill->AddColumn("mmgg_bill", "������", "������");
  Fieldh->SetReadOnly();

  DBGrBill->Visible=true;




  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrBill->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }
   }

  TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);  

/*
   qBillList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qBillList->Filtered=true;
   qBillList->Refresh();
*/
   SetCaption(" ����� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

//  Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
   //Application->CreateForm(__classid(TfPrintBill), &fPrintBill);
 };

//---------------------------------------------------------------------------

void __fastcall TfBillListFull::ClientBillPrint(TObject *Sender)
{
  int id_doc=qBillList->FieldByName("id_doc")->AsInteger;
//   Application->CreateForm(__classid(TfPrintBill), &fPrintBill);
   fPrintBill->ShowBill(id_doc);
};


//---------------------------------------------------------------------------

void __fastcall TfBillListFull::ShowData(void)
{
 MainPanel->ParamByID("Bill")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfBillListFull::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfBillListFull::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;
  //  ZeroTime.TDateTime(0);

    if (qBillList->FieldByName("mmgg")->AsDateTime != ZeroTime)
       fPeriodSelect->FormShow(qBillList->FieldByName("mmgg")->AsDateTime,qBillList->FieldByName("mmgg")->AsDateTime);
    else
       fPeriodSelect->FormShow(mmgg,mmgg);
       

    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };

   if (rez == mrOk)
   {
     qBillList->Filtered=false;
     qBillList->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and mmgg <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     qBillList->Filtered=true;
     qBillList->Refresh();

     SetCaption(" ����� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {

   //     qBillList->Filtered=false;
     qBillList->DefaultFilter="";
     qBillList->Refresh();
     SetCaption(" ����� ");
   }

//    delete fPeriodSelect;
//    ReBuildGrid();
};

//--------------------------------------------------

void __fastcall TMainForm::ShowBillList(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������ ������", Owner)) {
    return;
  }
  TfBillListFull * fBillListFull=new TfBillListFull(this);

  fBillListFull->ShowAs("������ ������");

  fBillListFull->ID="������ ������";

  fBillListFull->ShowData();
}

//----------------------------------------------------------

