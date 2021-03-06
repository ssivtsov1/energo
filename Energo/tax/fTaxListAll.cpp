//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "fTaxListAll.h"
#include "ParamsForm.h"
//#include "fTaxPrint.h"
//#include "fTaxCorPrint.h"
#include "ftaxprintpar.h"
#include "fPeriodSel.h"
#include "fTaxDeleteAll.h"
#include "IcXMLParser.hpp"
#include "SysUser.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
#pragma link "IcXMLParser"

AnsiString sqlstr;
TWTDBGrid* WAbonGrid;
TWTWinDBGrid *WPrefGrid;

__fastcall TfTaxListFull::~TfTaxListFull(void)
{
 delete fRepTaxNLocal;
 delete fRepTaxCorLocal;
};
//------------------------------------------------------------
__fastcall TfTaxListFull::TfTaxListFull(TComponent* AOwner) : TWTDoc(AOwner)
{
  // ������� ��������� ������
/*
  ZDocQuery = new TWTQuery(Application);
  ZDocQuery->MacroCheck=true;
  ZDocQuery->Options<< doQuickOpen;
  ZDocQuery->RequestLive=false;
  ZDocQuery->CachedUpdates=false;
*/
/*
  TWTPanel* PName=MainPanel->InsertPanel(30,true,25); // (X,bool,Y) X,Y min size panel
  TFont* F=new TFont();
  F->Size=16;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PName->Params->AddText("������ ����������",100,F,Classes::taCenter,true)->ID="NameGrp";
  */
 // MainTabSheet->Caption="��������� ���������";
//  PageControl->TabHeight=10;
 // PageControl->TabWidth=10;
  bool read_only =true;
  Name = "TaxListFull";

  if(CheckLevelStrong("������ ��������� ���������-��������������")!=0)
  {
    read_only=false;
  }


 // ������� ������� ������� ������
  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);

  try
  {
   ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTax->Close();
   delete ZQTax;
   return;
  }
  ZQTax->First();
  mmgg = ZQTax->FieldByName("mmgg")->AsDateTime;

  ZQTax->Close();

  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
  BtnPrint->OnClick=ClientTaxPrint;
  BtnPrint->Width=80;
  BtnPrint->Top=2;
  BtnPrint->Left=2;

  BtnPrintAll=new TButton(this);
  BtnPrintAll->Caption="������ ���";
  BtnPrintAll->OnClick=AllTaxPrint;
  BtnPrintAll->Width=80;
  BtnPrintAll->Top=2;
  BtnPrintAll->Left=200;

  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption=" ��������������� ";
  BtnRebuild->OnClick=TaxRebuild;
  BtnRebuild->Width=100;
  BtnRebuild->Top=2;
  BtnRebuild->Left=400;
  BtnRebuild->Enabled= !read_only;

  TButton *BtnDel=new TButton(this);
  BtnDel->Caption=" ������� ";
  BtnDel->OnClick=TaxDelete;
  BtnDel->Width=100;
  BtnDel->Top=2;
  BtnDel->Left=600;
  BtnDel->Enabled= !read_only;

  TButton *BtnDelAll=new TButton(this);
  BtnDelAll->Caption=" ������� ������ ";
  BtnDelAll->OnClick=TaxDeleteAll;
  BtnDelAll->Width=100;
  BtnDelAll->Top=2;
  BtnDelAll->Left=800;
  BtnDelAll->Enabled= !read_only;

  TButton *BtnRebuildFiz=new TButton(this);
  BtnRebuildFiz->Caption=" ��������. ���������";
  BtnRebuildFiz->OnClick=TaxFizRebuild;
  BtnRebuildFiz->Width=130;
  BtnRebuildFiz->Top=2;
  BtnRebuildFiz->Left=1000;
  BtnRebuildFiz->Enabled= !read_only;

  TButton *BtnRebuildLgt=new TButton(this);
  BtnRebuildLgt->Caption=" ��������. ������";
  BtnRebuildLgt->OnClick=TaxLgtRebuild;
  BtnRebuildLgt->Width=130;
  BtnRebuildLgt->Top=2;
  BtnRebuildLgt->Left=1200;
  BtnRebuildLgt->Enabled= !read_only;

  TButton *BtnXML=new TButton(this);
  BtnXML->Caption=" � XML";
  BtnXML->OnClick=TaxToXML;
  BtnXML->Width=80;
  BtnXML->Top=2;
  BtnXML->Left=1400;
  BtnXML->Enabled=true;

  TButton *BtnXMLAll=new TButton(this);
  BtnXMLAll->Caption=" � XML ���";
  BtnXMLAll->OnClick=TaxToXMLAll;
  BtnXMLAll->Width=80;
  BtnXMLAll->Top=2;
  BtnXMLAll->Left=1600;
  BtnXMLAll->Enabled=true;

  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1400;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;
  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
  PBtn->Params->AddButton(BtnPrintAll,false)->ID="BtnPrnAll";
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
  PBtn->Params->AddButton(BtnDel,false)->ID="BtnDel";
  PBtn->Params->AddButton(BtnDelAll,false)->ID="BtnDelAll";
  PBtn->Params->AddButton(BtnRebuildFiz,false)->ID="BtnRebuildFiz";
  PBtn->Params->AddButton(BtnRebuildLgt,false)->ID="BtnRebuildLgt";
  PBtn->Params->AddButton(BtnXML,false)->ID="BtnXML";
  PBtn->Params->AddButton(BtnXMLAll,false)->ID="BtnXMLAll";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";


  /*
  TDateTimePicker *DtPeriod=new TDateTimePicker(this);
 // BtnDel->Caption=" ������� ";
 // BtnDel->OnClick=TaxDelete;
 // BtnDel->Width=100;
  DtPeriod->Parent = PBtn;
  DtPeriod->Top=3;
  DtPeriod->Left=800;
*/


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

 //  ((TZPgSqlQuery*)Query2)->Options << doQuickOpen;
//   Query2->MacroCheck=true;

   Query2->Sql->Clear();
   Query2->Sql->Add("select t.*, t.value+t.value_tax as value_sum, c.code, c.short_name, round(t.value/5,2) as calc_tax, round(t.value/5,2) - t.value_tax as delta_tax, " );
   Query2->Sql->Add(" p.name as name_pref, abonpar.flag_taxpay, CASE WHEN abonpar.flag_taxpay = 1 THEN '��' ELSE '���' END::::varchar as taxpay_str " );
   Query2->Sql->Add(" from acm_tax_tbl as t " );
   Query2->Sql->Add("join clm_client_tbl as c on (c.id= t.id_client) ");
   Query2->Sql->Add("join clm_statecl_tbl as abonpar on (abonpar.id_client = c.id) ");
   Query2->Sql->Add("join aci_pref_tbl as p on (p.id= t.id_pref) ");
   Query2->Sql->Add("order by mmgg, int_num ; " );

                                //  u.name||' '||coalesce(trim(p.represent_name),'')::::varchar as name,


   DBGrTax=new TWTDBGrid(PTax, Query2);
   TWTQuery *pers=new TWTQuery(this);

   pers->Sql->Add("select p.id as id_person,u.id , \
     p.represent_name from syi_user as u left join clm_position_tbl as p on (p.id = u.id_person) \
     where flag_type = 0 and u.id_person is not null order by u.name;");
   pers->Open();

   DBGrTax->Query->AddLookupField("represent1_name","id_person",pers,"represent_name","id_person");
   qTaxList = DBGrTax->Query;
   qTaxList->Options<< doQuickOpen;

//  qTaxList->ParamByName("all")->AsInteger=1;

//  qTaxList->AddLookupField("Name_pref","id_pref","aci_pref_tbl","name","id");

  if(read_only)
  {
     DBGrTax->SetReadOnly(true);
  }

  qTaxList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and int_num<>0 ";
  qTaxList->Filtered=true;
  listMode = 0;

  qTaxList->Open();

   DBGrTax->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrTax, true)->ID="Tax";



  TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
  NList->Add("value_sum");
  NList->Add("code");
  NList->Add("short_name");
  NList->Add("id_client");
  NList->Add("mmgg");
  NList->Add("auto");
  NList->Add("name_pref");
  NList->Add("flag_taxpay");
  NList->Add("taxpay_str");
  NList->Add("calc_tax");
  NList->Add("delta_tax");

  qTaxList->SetSQLModify("acm_tax_tbl",WList,NList,true,false,false);

  qTaxList->AfterInsert=CancelInsert;
  qTaxList->AfterCancel=AfterCancelRefresh;
  qTaxList->OnPostError = PostError;
  qTaxList->OnEditError = PostError;
  qTaxList->OnDeleteError = PostError;
  qTaxList->OnApplyUpdateError = PostError;
  DBGrTax->OnDrawColumnCell=DrawColumnCell;

  TWTField *Fieldh;

  Fieldh = DBGrTax->AddColumn("code", " ", "������� ����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("short_name", "������� ", "�������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("int_num", "�����", "����� ��������� ���������");
  Fieldh->SetWidth(40);

  Fieldh = DBGrTax->AddColumn("reg_num", "������ �����", "����� ��������� ���������");
  Fieldh->SetWidth(80);
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("reg_date", "����", "���� �������");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("represent1_name", "�����������", "�����������");
  Fieldh->SetWidth(120);

  Fieldh = DBGrTax->AddColumn("Name_pref", "���", "���");
  Fieldh->SetWidth(20);
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("kind_calc", "���", "��������� �� ����� ��� �� �����");
  Fieldh->AddFixedVariable("1", "�� �����");
  Fieldh->AddFixedVariable("2", "�����");
  Fieldh->AddFixedVariable("3", "������");
  Fieldh->AddFixedVariable("4", "���������");
  Fieldh->AddFixedVariable("5", "�������������");
  Fieldh->AddFixedVariable("7", "������ �� ������");
  Fieldh->AddFixedVariable("8", "������ 2016");
  Fieldh->AddFixedVariable("9", "������ ����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value", "����� ��� ���", "����� ��� ���");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value_tax", "���", "����� ���");
  Fieldh->Precision=2;
 // Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value_sum", "����� � ���", "����� � ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("delta_tax", "������� ���", "������� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("taxpay_str", "����.���", "���������� ���");
  Fieldh->SetReadOnly();
  Fieldh->SetWidth(30);

  Fieldh = DBGrTax->AddColumn("flag_transmis", "������", "������");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "������");

  Fieldh = DBGrTax->AddColumn("flag_reg", "�����.�� ����", "�������� �� ����");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "�����.");
  Fieldh->SetWidth(85);

  Fieldh = DBGrTax->AddColumn("xml_num", "� xml �����", "����� xml �����");
  Fieldh->SetWidth(85);

  Fieldh = DBGrTax->AddColumn("disabled", "���������", "���������");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "����.");

  Fieldh = DBGrTax->AddColumn("id_doc", "���", "���");
  Fieldh->SetWidth(85);
  Fieldh->SetReadOnly();

  DBGrTax->Visible=true;

//----------------------------------------------------------------------------

  TWTPanel* PTaxLines=MainPanel->InsertPanel(200,true,200);
//  TWTPanel* PTax=MainPanel->InsertPanel(200,200);
 /*
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PTax->Params->AddText("��������� ���������",18,F,Classes::taCenter,false);
   */

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options << doQuickOpen;

   Query3->Sql->Clear();
   Query3->Sql->Add("select * from acd_tax_tbl  " );

   DBGrTaxLines=new TWTDBGrid(PTaxLines, Query3);

   qTaxLines = DBGrTaxLines->Query;
   qTaxLines->Options<< doQuickOpen;

   DBGrTaxLines->SetReadOnly(false);
   PTaxLines->Params->AddGrid(DBGrTaxLines, true)->ID="TaxLines";

   if(read_only)
   {
     DBGrTaxLines->SetReadOnly(true);
   }

  qTaxLines->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
  qTaxLines->Filtered=true;

  qTaxLines->Open();

  WList=new TStringList();
  WList->Add("id");

  NList=new TStringList();
  NList->Add("mmgg");

  qTaxLines->SetSQLModify("acd_tax_tbl",WList,NList,true,false,true);
  qTaxLines->AfterInsert=CancelInsert;



  qTaxLines->IndexFieldNames = "id_doc";
  qTaxLines->LinkFields = "id_doc=id_doc";
  qTaxLines->MasterSource = DBGrTax->DataSource;


 // TWTField *Fieldh;
   Fieldh = DBGrTaxLines->AddColumn("dt_bill", "����", "");

  Fieldh = DBGrTaxLines->AddColumn("text", "�����", "");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTaxLines->AddColumn("unit", "�������", "");
  Fieldh->AddFixedVariable("������", "������");
  Fieldh->AddFixedVariable("���", "���");

  Fieldh = DBGrTaxLines->AddColumn("unit_kod", "��� ��.���.", "");
  Fieldh->AddFixedVariable("0415", "0415");
  Fieldh->AddFixedVariable("2454", "2454");

  Fieldh = DBGrTaxLines->AddColumn("uktzed", "��� ��� ���", "");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTaxLines->AddColumn("demand_val", "����������", "  ");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTaxLines->AddColumn("tariff", "����", " ");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTaxLines->AddColumn("sum_val7", "����� (20%)", "");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTaxLines->AddColumn("sum_val8", "����� (0%)", "");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();


  DBGrTaxLines->Visible=true;


//----------------------------------------------------------------------------
 // SetCaption("��������� ��������� ");
//  DocTax->ShowAs("CliTax");
//  MainPanel->ParamByID("Tax")->Control->SetFocus();


  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrTax->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
//    if ( btn->ID=="Full")
//       tb->Buttons[i]->OnClick=EqpAccept;
    if ( btn->ID=="NewRecord")
       {
//       if (IsInsert)
//         tb->Buttons[i]->OnClick=NewEqp;
//       else
         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
     {
//        OldDelEqp=tb->Buttons[i]->OnClick;
        tb->Buttons[i]->OnClick=TaxDelete;
//       tb->Buttons[i]->OnClick=NULL;
     }
   }
  //TWTToolButton* btAll=tb->AddButton("equal", "����� �������", PeriodSel);
  TWTToolButton* btPeriod=tb->AddButton("dateinterval", "����� �������", PeriodSel);

  TWTToolButton* btAll = tb->AddButton("AddCond", "������ ������", TaxAllList);
  TWTToolButton* btReal = tb->AddButton("RemCond", "����������� ���", TaxRealList);


  tb=DBGrTaxLines->ToolBar;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
       {
//        tb->Buttons[i]->OnClick=TaxDelete;
         tb->Buttons[i]->OnClick=NULL;
       }
   }
/*
   qTaxList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qTaxList->Filtered=true;
   qTaxList->Refresh();
*/
   SetCaption("��������� ��������� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

  if (mmgg < TDateTime(2014,3,1))
  {
    Application->CreateForm(__classid(TfRepTaxN), &fRepTaxNLocal);
    Application->CreateForm(__classid(TfRepTaxCor), &fRepTaxCorLocal);
  }
  else
  {
    if (mmgg < TDateTime(2014,12,1))
    {
     Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxNLocal);
     Application->CreateForm(__classid(TfRepTaxCor2014), &fRepTaxCorLocal);
    }
    else
    {

      if (mmgg < TDateTime(2015,1,1))
      {
       Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxNLocal);
       Application->CreateForm(__classid(TfRepTaxCor2014_12), &fRepTaxCorLocal);
      }
      else
      {

         if (mmgg < TDateTime(2016,3,1))
         {
          Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxNLocal);
          Application->CreateForm(__classid(TfRepTaxCor2015), &fRepTaxCorLocal);
         }
         else
         {
          Application->CreateForm(__classid(TfRepTaxN2016), &fRepTaxNLocal);
          Application->CreateForm(__classid(TfRepTaxCor2016), &fRepTaxCorLocal);

         }

      }

    }

  }

 };

//---------------------------------------------------------------------------

void __fastcall TfTaxListFull::ClientTaxPrint(TObject *Sender)
{
  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;
//  Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
  fRepTaxNLocal->ShowTaxNal(id_tax);

};

//--------------------------------------------------

void __fastcall TfTaxListFull::TaxRebuild(TObject *Sender)
{
  AnsiString sqlstr ;
  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;
  int id_bill=qTaxList->FieldByName("id_bill")->AsInteger;
  int int_num_old=qTaxList->FieldByName("int_num")->AsInteger;
  int kind_calc=qTaxList->FieldByName("kind_calc")->AsInteger;
  int id_client = qTaxList->FieldByName("id_client")->AsInteger;
  int id_pref = qTaxList->FieldByName("id_pref")->AsInteger;
  TDateTime mmgg =qTaxList->FieldByName("mmgg")->AsDateTime;
  TDateTime reg_date =qTaxList->FieldByName("reg_date")->AsDateTime;

  if (MessageDlg(" ��������������� ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;


  if (mmgg >= TDateTime(2016,1,1))
  {
   sqlstr="select acm_rebuildTax2016( :id_tax );";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("id_tax")->AsInteger=id_tax;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    return;
   }

   ShowMessage("��������� ��������� ������� ���������������");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();

   return;
  }
  //-- ������ �������� �� 2015 ����

  //���� ������ ��� �� �� ���� � �����
  if ((kind_calc!=1)&&(kind_calc!=2)&&(kind_calc!=3)&&(kind_calc!=5) ) return;

  ZQTax->Transaction->NewStyleTransactions=false;
  ZQTax->Transaction->TransactSafe=true;
  ZQTax->Transaction->AutoCommit=false;
  ZQTax->Transaction->Commit();
  ZQTax->Transaction->StartTransaction();

  int split_mode =0;
  /*
  // �������� ������ "�������" (���� 2013)
  sqlstr="select getsysvar('tax_split') as var; ";

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
    ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTax->Transaction->Rollback();
   ZQTax->Close();
   ZQTax->Transaction->AutoCommit=true;
   ZQTax->Transaction->TransactSafe=false;
   delete ZQTax;
   return;
  }
  int split_mode = ZQTax->FieldByName("var")->AsInteger;
  ZQTax->Close();


   if (((kind_calc ==2)||(kind_calc ==3))&&(split_mode==1))
   {
    if (MessageDlg("����������� ��������� ��������� ���������,���� ���������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    {
      split_mode=0;
    }
   }
   */

   if (kind_calc ==3)
   {
     sqlstr="delete from acm_tax_tbl where id_client = :id_client and mmgg = :mmgg and kind_calc = 3 and id_pref = :id_pref; ";

     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);

     ZQTax->ParamByName("id_pref")->AsInteger=id_pref;
     ZQTax->ParamByName("id_client")->AsInteger=id_client;
     ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;
   }
   else
   {
     sqlstr="delete from acm_tax_tbl where id_doc = :doc ;";
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);

     ZQTax->ParamByName("doc")->AsInteger=id_tax;
   }
   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

  ZQTax->Sql->Clear();

  if (kind_calc ==1)
  {
   sqlstr="select acm_createTaxBill( :bill );";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("bill")->AsInteger=id_bill;
  }

  if (kind_calc ==2)
  {
   sqlstr="select acm_createTaxAdvance( :client, :pref, :mmgg, :dt ,0, :mode);";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("client")->AsInteger=id_client;
   ZQTax->ParamByName("pref")->AsInteger=id_pref;
   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;
   ZQTax->ParamByName("dt")->AsDateTime=reg_date;
   ZQTax->ParamByName("mode")->AsInteger=split_mode;
  }

  if (kind_calc ==3)
  {
   sqlstr="select acm_createTaxPay( :client, :pref, :mmgg, :dt ,1, :mode);";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("client")->AsInteger=id_client;
   ZQTax->ParamByName("pref")->AsInteger=id_pref;
   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;
   ZQTax->ParamByName("dt")->AsDateTime=reg_date;
   ZQTax->ParamByName("mode")->AsInteger=split_mode;
  }

  if (kind_calc ==5)
  {
   sqlstr="select acm_createTaxNotPayer(:mmgg, :pref,  :dt );";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("pref")->AsInteger=id_pref;
   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;
   ZQTax->ParamByName("dt")->AsDateTime=reg_date;
  }

  try
   {
   ZQTax->ExecSql();

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

   AnsiString NewTaxNum=InputBox("����� ��������� ���������", "������� ��������� ��������� � �������", IntToStr(int_num_old));

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
    ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

   ZQTax->Transaction->Commit();
   ZQTax->Transaction->AutoCommit=true;
   ZQTax->Transaction->TransactSafe=false;

   ShowMessage("��������� ��������� ������� ���������������");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();
};
//--------------------------------------------------
void __fastcall TfTaxListFull::TaxFizRebuild(TObject *Sender)
{
  AnsiString sqlstr ;
  TDateTime mmgg =qTaxList->FieldByName("mmgg")->AsDateTime;

  if (MessageDlg(" ��������������� ��������� ��������� �� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;


  ZQTax->Transaction->NewStyleTransactions=false;
  ZQTax->Transaction->TransactSafe=true;
  ZQTax->Transaction->AutoCommit=false;
  ZQTax->Transaction->Commit();
  ZQTax->Transaction->StartTransaction();


   sqlstr="delete from acm_tax_tbl where  mmgg = :mmgg and kind_calc = 4; ";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

   sqlstr=" select seb_all( 0, :mmgg)";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

//   sqlstr="; select c_date  from calendar where  (date_trunc('month', c_date::::date) =  date_trunc('month', :mmgg::::date))  and holiday is NULL \
//    order by c_date desc limit 1; ";

   sqlstr="; select c_date  from calendar where  (date_trunc('month', c_date::::date) =  date_trunc('month', :mmgg::::date))  \
    order by c_date desc limit 1; ";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

  TDateTime reg_date =ZQTax->FieldByName("c_date")->AsDateTime;

  ZQTax->Close();
  ZQTax->Sql->Clear();

  sqlstr="select acm_createTaxFiz2016( :mmgg, :dt );";
  ZQTax->Sql->Add(sqlstr);

  ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQTax->ParamByName("dt")->AsDateTime=reg_date;

  try
   {
   ZQTax->ExecSql();

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

   ZQTax->Transaction->Commit();
   ZQTax->Transaction->AutoCommit=true;
   ZQTax->Transaction->TransactSafe=false;
   ShowMessage("��������� ��������� ������� ���������������");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();
};
//--------------------------------------------------
void __fastcall TfTaxListFull::TaxLgtRebuild(TObject *Sender)
{
  AnsiString sqlstr ;
  TDateTime mmgg =qTaxList->FieldByName("mmgg")->AsDateTime;

  if (MessageDlg(" ��������������� ��������� ��������� �� ����� ������ ����� � ��������  ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  ZQTax->Transaction->NewStyleTransactions=false;
  ZQTax->Transaction->TransactSafe=true;
  ZQTax->Transaction->AutoCommit=false;
  ZQTax->Transaction->Commit();
  ZQTax->Transaction->StartTransaction();



   sqlstr="delete from acm_tax_tbl where  mmgg = :mmgg and kind_calc = 3 and id_client in \
   ( select cm.id from clm_client_tbl as cm \
     join clm_statecl_tbl as cp on (cm.id=cp.id_client) \
     where cm.book = -1 and cp.flag_budjet = 1  and cp.id_section in (206,207)  )  ; ";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

   sqlstr=" select seb_all( 0, :mmgg)";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }


   sqlstr="; select c_date  from calendar where  (date_trunc('month', c_date::::date) =  date_trunc('month', :mmgg::::date))  \
    order by c_date desc limit 1; ";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;

   try
   {
    ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

  TDateTime reg_date =ZQTax->FieldByName("c_date")->AsDateTime;

  ZQTax->Close();
  ZQTax->Sql->Clear();

  sqlstr="select acm_createTaxLgt2016( :mmgg, :dt );";
  ZQTax->Sql->Add(sqlstr);

  ZQTax->ParamByName("mmgg")->AsDateTime=mmgg;
  ZQTax->ParamByName("dt")->AsDateTime=reg_date;

  try
   {
   ZQTax->ExecSql();

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    ZQTax->Transaction->TransactSafe=false;
    delete ZQTax;
    return;
   }

   ZQTax->Transaction->Commit();
   ZQTax->Transaction->AutoCommit=true;
   ZQTax->Transaction->TransactSafe=false;
   ShowMessage("��������� ��������� ������� ���������������");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();
};
//--------------------------------------------------



void __fastcall TfTaxListFull::TaxDelete(TObject *Sender)
{
  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;

  if (MessageDlg(" ������� ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
//  ZQTax->Transaction->AutoCommit=false;


   AnsiString sqlstr="delete from acm_tax_tbl where id_doc = :doc ;";
   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("doc")->AsInteger=id_tax;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
//    ZQTax->Transaction->Rollback();
    ZQTax->Close();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

//   ZQTax->Transaction->Commit();
//   ZQTax->Transaction->AutoCommit=true;
   ShowMessage("��������� ��������� �������");
   delete ZQTax;

   qTaxList->Refresh();
};
//--------------------------------------------------
void __fastcall TfTaxListFull::AllTaxPrint(TObject *Sender)
{
//  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;
//  Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
//  fRepTaxN->ShowTaxNal(id_tax);

    TfTaxPrintParams* fTaxPrintParams;
    Application->CreateForm(__classid(TfTaxPrintParams), &fTaxPrintParams);

    fTaxPrintParams->dtPeriod->Date =qTaxList->FieldByName("mmgg")->AsDateTime;
    fTaxPrintParams->edStart->Text =qTaxList->FieldByName("int_num")->AsString;

    if (fTaxPrintParams->ShowModal()!= mrOk)
     {
      delete fTaxPrintParams;
      return ;
     };

   Word year;
   Word month;
   Word day;

   DecodeDate(fTaxPrintParams->dtPeriod->Date,year,month,day);

   if (fTaxPrintParams->cbPrintAll->Checked)
   {

    TWTQuery * ZQPrint = new TWTQuery(Application);
    ZQPrint->Options<< doQuickOpen;
    ZQPrint->RequestLive=false;
    ZQPrint->CachedUpdates=false;

    sqlstr="select * from ( \
    select t.id_doc,t.int_num,0::::int as tax_type, t.reg_num,t.reg_date \
    from acm_tax_tbl as t \
    where date_trunc('month',  :mmgg::::date) = date_trunc('month', t.reg_date) \
    union all \
    select t.id_doc,t.int_num,1::::int as tax_type, t.reg_num,t.reg_date \
    from acm_taxcorrection_tbl as t \
    where date_trunc('month',  :mmgg::::date) = date_trunc('month', t.reg_date) \
    ) as s  where int_num >= :num1 and int_num <= :num2 order by int_num; ";

    ZQPrint->Sql->Clear();
    ZQPrint->Sql->Add(sqlstr);

    ZQPrint->ParamByName("mmgg")->AsDateTime=fTaxPrintParams->dtPeriod->Date;
    ZQPrint->ParamByName("num1")->AsInteger = StrToInt(fTaxPrintParams->edStart->Text);
    ZQPrint->ParamByName("num2")->AsInteger = StrToInt(fTaxPrintParams->edStop->Text);

    try
    {
     ZQPrint->Open();
    }
    catch(EDatabaseError &e)
    {
     ShowMessage("������ "+e.Message.SubString(8,200));
     ZQPrint->Close();
     delete ZQPrint;
     return;
    }
    ZQPrint->First();
    BtnPrintAll->Caption="���� ������...";
    DBGrTax->Enabled = false;

    for (int i=0; i<ZQPrint->RecordCount;i++)
    {
     if (ZQPrint->FieldByName("tax_type")->AsInteger==0)
        fRepTaxNLocal->ShowTaxNal(ZQPrint->FieldByName("id_doc")->AsInteger, 1);

     if (ZQPrint->FieldByName("tax_type")->AsInteger==1)
        fRepTaxCorLocal->ShowTaxCor(ZQPrint->FieldByName("id_doc")->AsInteger, 1);

     ZQPrint->Next();
    }

    ZQPrint->Close();
    delete ZQPrint;
   }
   else
   {

    int oldfiltered = qTaxList->Filtered;
    AnsiString OldFilter = qTaxList->DefaultFilter;

    qTaxList->Filtered=false;
    qTaxList->DefaultFilter="int_num >= "+fTaxPrintParams->edStart->Text+
    " and int_num <= "+fTaxPrintParams->edStop->Text+" and mmgg = '"+ FormatDateTime("yyyy-mm-dd",EncodeDate(year,month,1))+"' ";
    qTaxList->Filtered=true;
   // qTaxList->IndexFieldNames = "int_num";
    qTaxList->Refresh();


    qTaxList->FindFirst();
    DBGrTax->Enabled = false;
    BtnPrintAll->Caption="���� ������...";
 //   Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
    for (int i=0; i<qTaxList->RecordCount;i++)
    {
     fRepTaxNLocal->ShowTaxNal(qTaxList->FieldByName("id_doc")->AsInteger, 1);
     qTaxList->FindNext();
    }

//   qTaxList->Close();
//   qTaxList->ParamByName("all")->AsInteger=1;
//   qTaxList->Open();

    qTaxList->DefaultFilter = OldFilter;
    qTaxList->Filtered=oldfiltered;

   }
   DBGrTax->Enabled = true;
   BtnPrintAll->Caption="������ ���";
   qTaxList->Refresh();
   delete fTaxPrintParams;
};

//---------------------------------------------------------------------------

void __fastcall TfTaxListFull::ShowData(void)
{
 MainPanel->ParamByID("Tax")->Control->SetFocus();
 MainPanel->ParamByID("TaxLines")->Control->SetFocus();
 MainPanel->ParamByID("Tax")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfTaxListFull::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfTaxListFull::AfterCancelRefresh(TDataSet* DataSet)
{
 DataSet->Refresh();
}
//---------------------------------------------------------------------------
void __fastcall TfTaxListFull::TaxAllList(TObject *Sender)
{
 AnsiString filter = qTaxList->DefaultFilter;

 if (listMode==0)
 {
   TReplaceFlags flags ;
   flags <<rfReplaceAll;
   filter = StringReplace(filter, "and int_num<>0", "", flags );
   qTaxList->DefaultFilter=filter;
   qTaxList->Filtered=true;

 }

 listMode = 1;
}
//---------------------------------------------------------------------------
void __fastcall TfTaxListFull::TaxRealList(TObject *Sender)
{
 AnsiString filter = qTaxList->DefaultFilter;

 if (listMode==1)
 {
     filter+=" and int_num<>0 ";
     qTaxList->DefaultFilter=filter;
     qTaxList->Filtered=true;
 }

 listMode = 0;
}
//---------------------------------------------------------------------------
void __fastcall TfTaxListFull::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;

    if (qTaxList->FieldByName("mmgg")->AsDateTime != ZeroTime)
        fPeriodSelect->FormShow(qTaxList->FieldByName("mmgg")->AsDateTime,qTaxList->FieldByName("mmgg")->AsDateTime);
    else
        fPeriodSelect->FormShow(mmgg,mmgg);


    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };

//   delete DBGrTax;
//   qTaxList->Close();
//   qTaxList->Open();
/*
   if (rez == mrOk)
   {
     qTaxList->ParamByName("startdt")->AsDateTime=fPeriodSelect->DateFrom;
     qTaxList->ParamByName("stopdt")->AsDateTime=fPeriodSelect->DateTo;
     qTaxList->ParamByName("all")->AsInteger=0;

     SetCaption("��������� ��������� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {
     qTaxList->ParamByName("all")->AsInteger=1;
     SetCaption("��������� ��������� ");
   }


   try
   {
    qTaxList->Open();
   }
   catch(...)
   {
    delete fPeriodSelect;
    return;
   }
*/

   if (rez == mrOk)
   {
   //  qTaxLines->Close();
   //  qTaxList->Close();

     AnsiString filter = "mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and mmgg <= '"
       + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     if (listMode==0)
     {
      filter+=" and int_num<>0 ";
     }

     qTaxList->DefaultFilter= filter;
     qTaxList->Filtered=true;

     qTaxLines->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and mmgg <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     qTaxLines->Filtered=true;

//     qTaxList->Refresh();
//     qTaxLines->Refresh();

     SetCaption("��������� ��������� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");

     delete fRepTaxNLocal;
     delete fRepTaxCorLocal;

     if (fPeriodSelect->DateFrom < TDateTime(2014,3,1))
     {
       Application->CreateForm(__classid(TfRepTaxN), &fRepTaxNLocal);
       Application->CreateForm(__classid(TfRepTaxCor), &fRepTaxCorLocal);
     }
     else
     {

      if (fPeriodSelect->DateFrom < TDateTime(2014,12,1))
      {
       Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxNLocal);
       Application->CreateForm(__classid(TfRepTaxCor2014), &fRepTaxCorLocal);
      }
      else
      {

        if (fPeriodSelect->DateFrom < TDateTime(2015,1,1))
        {
         Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxNLocal);
         Application->CreateForm(__classid(TfRepTaxCor2014_12), &fRepTaxCorLocal);
        }
        else
        {

         if (fPeriodSelect->DateFrom < TDateTime(2016,3,1))
         {
          Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxNLocal);
          Application->CreateForm(__classid(TfRepTaxCor2015), &fRepTaxCorLocal);
         }
         else
         {
          Application->CreateForm(__classid(TfRepTaxN2016), &fRepTaxNLocal);
          Application->CreateForm(__classid(TfRepTaxCor2016), &fRepTaxCorLocal);

         }
        }

      }

     }

   }
/*
   else
   {
     //qTaxList->Filtered=false;
     qTaxList->DefaultFilter="";
     qTaxList->Refresh();
     qTaxLines->DefaultFilter="";
     qTaxLines->Refresh();
     SetCaption("��������� ��������� ");
   }
*/
//    delete fPeriodSelect;
//    ReBuildGrid();
};

//--------------------------------------------------
void __fastcall TfTaxListFull::TaxDeleteAll(TObject *Sender)
{

   TfDelTaxAll* fDelTaxAll;
   Application->CreateForm(__classid(TfDelTaxAll), &fDelTaxAll);

   fDelTaxAll->dtPeriod->Date =qTaxList->FieldByName("mmgg")->AsDateTime;

   if (fDelTaxAll->ShowModal()!= mrOk)
    {
     delete fDelTaxAll;
     return ;
    };

   Word year;
   Word month;
   Word day;

   DecodeDate(fDelTaxAll->dtPeriod->Date,year,month,day);

   if (MessageDlg(" �� ������������� ������ ������� ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
   {
    return;
   }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;


   AnsiString sqlstr="delete from acm_tax_tbl where mmgg = :mmgg and auto = 1 and coalesce(flag_transmis,0) = 0 and ((decade = :decade)  or ( :decade = 0 ));";
   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("mmgg")->AsDateTime=EncodeDate(year,month,1);
   ZQTax->ParamByName("decade")->AsInteger=fDelTaxAll->cbDecade->ItemIndex;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    return;
   }

//   sqlstr="delete from acm_taxcorrection_tbl where mmgg = :mmgg and kind_calc = 0 and coalesce(flag_transmis,0) = 0 \
//    and ( id_bill is null or not exists (select id_doc from acm_tax_tbl as t where t.mmgg = :mmgg and t.id_bill = acm_taxcorrection_tbl.id_bill) ) ;";

   if ((fDelTaxAll->cbDecade->ItemIndex==0)||(fDelTaxAll->cbDecade->ItemIndex==3)||(fDelTaxAll->cbDecade->ItemIndex==-1))
   {
    sqlstr="delete from acm_taxcorrection_tbl where mmgg = :mmgg and kind_calc = 0 and coalesce(flag_transmis,0) = 0 ;";

    ZQTax->Sql->Clear();
    ZQTax->Sql->Add(sqlstr);

    ZQTax->ParamByName("mmgg")->AsDateTime=EncodeDate(year,month,1);


    try
    {
     ZQTax->ExecSql();
    }
    catch(EDatabaseError &e)
    {
     ShowMessage("������ "+e.Message.SubString(8,200));
     ZQTax->Close();
     delete ZQTax;
     return;
    }

    sqlstr="delete from acm_taxadvcor_tbl where mmgg = :mmgg and id_correction is null ;";

    ZQTax->Sql->Clear();
    ZQTax->Sql->Add(sqlstr);

    ZQTax->ParamByName("mmgg")->AsDateTime=EncodeDate(year,month,1);


    try
    {
     ZQTax->ExecSql();
    }
    catch(EDatabaseError &e)
    {
     ShowMessage("������ "+e.Message.SubString(8,200));
     ZQTax->Close();
     delete ZQTax;
     return;
    }

   }
   ShowMessage("���������� ��������� �������, ����� ���������� ��� ��������!");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();
   delete fDelTaxAll;
};
//--------------------------------------------------------------
void __fastcall TfTaxListFull::TaxToXML(TObject *Sender)
{
  if (qTaxList->FieldByName("flag_reg")->AsInteger !=1)
  {
   qTaxList->Edit();
   qTaxList->FieldByName("flag_reg")->AsInteger =1;
   qTaxList->FieldByName("flag_transmis")->AsInteger =1;
   qTaxList->Post();
  }

  int xml_num =  BuildXML( qTaxList->FieldByName("id_doc")->AsInteger);

  if ((xml_num!=0)&&(qTaxList->FieldByName("xml_num")->AsInteger !=xml_num))
  {
   qTaxList->Edit();
   qTaxList->FieldByName("xml_num")->AsInteger =xml_num;
   qTaxList->Post();

   ShowMessage("��������� ��������� ��������� � ����� "+xmlfilename);
  }

};
//----------------------------------------------------------------------
void __fastcall TfTaxListFull::TaxToXMLAll(TObject *Sender)
{
  int xml_num;

  if (MessageDlg(" ������������ XML ����� ��� ���� ��������� ���������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  qTaxList->First();
  for (int i=0;i<qTaxList->RecordCount;i++)
  {

//   if ((qTaxList->FieldByName("value_tax")->AsFloat >=10000 )&&(qTaxList->FieldByName("flag_taxpay")->AsInteger==1))
   if ((qTaxList->FieldByName("flag_reg")->AsInteger == 0 )&&(qTaxList->FieldByName("int_num")->AsInteger!=0))
   {

//    if (qTaxList->FieldByName("flag_reg")->AsInteger !=1)
//    {
     qTaxList->Edit();
     qTaxList->FieldByName("flag_reg")->AsInteger =1;
     qTaxList->FieldByName("flag_transmis")->AsInteger =1;
     qTaxList->Post();
//    }

    xml_num  =  BuildXML( qTaxList->FieldByName("id_doc")->AsInteger);

    if ((xml_num!=0)&&(qTaxList->FieldByName("xml_num")->AsInteger !=xml_num))
    {
     qTaxList->Edit();
     qTaxList->FieldByName("xml_num")->AsInteger =xml_num;
     qTaxList->Post();
    }
   }

   qTaxList->Next();
  }

  ShowMessage("��������� ��������� ��������� � ����� "+ExtractFilePath(Application->ExeName)+"xml\\");

};
//----------------------------------------------------------------------

int TfTaxListFull::BuildXML(int id_tax)
{
  TIcXMLDocument* doc;
  TIcXMLParser* parser;
  TIcXMLElement* root;
  TIcXMLElement* head;
  TIcXMLElement* body;
  TIcXMLElement* item;
  AnsiString sqlstr;

  TWTQuery *ZQTaxHeader = new  TWTQuery(this);

  // ^(.+) - ����� �-�� �������� � ������ ������
  // \\\\s - ������
  // (.) - ���� ����� ������
  // \\\\. - �����                  (���� ������������ )

   sqlstr="select t.reg_num,t.reg_date, t.int_num,t.xml_num,t.mmgg, abon.id as abonid, t.id_pref, \
   CASE WHEN users.represent_name ~ '^(.+)\\\\s(.)\\\\.(.)\\\\.$' THEN \
     substr(trim(users.represent_name),length(users.represent_name)-3,4)||' '||substr(trim(users.represent_name),0,length(users.represent_name)-4) ELSE represent_name END as represent_name, \
   CASE WHEN (abonpar.flag_taxpay = 0) and (position('���������' in (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END) )=0) \
       THEN  (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END)||' ���������' \
       WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END::::varchar as abonname, \
   res.name as resname, \
   CASE WHEN abonpar.addr_main is NULL THEN abonpar.addr_tax ELSE CASE WHEN trim(coalesce(abonpar.addr_main,''))='' THEN abonpar.addr_tax ELSE  abonpar.addr_main||' / \n'||abonpar.addr_tax END END::::varchar as abonaddr, \
   abon.name as abonnamesh,t.text as taxtext, \
   chpar.addr_tax||' / \n'||respar.addr_tax as resaddr, \
   abonpar.doc_num, abonpar.doc_dat, \
   CASE WHEN (abonpar.flag_taxpay = 1) THEN abonpar.tax_num ELSE '100000000000' END::::varchar as taxnum_abon, \
   abonpar.licens_num as SvidNum_abon, \
   abonpar.flag_taxpay,abon.code, abonpar.id_section, \
   respar.tax_num as taxnum_res,respar.licens_num as SvidNum_res, \
   abonpar.phone as abonphone,respar.phone as resphone, \
   t.value_tax,t.value, t.sum_val7,t.sum_val8, t.flag_reg \
   from (select t1.*, td.sum_val7,td.sum_val8,td.text from acm_tax_tbl as t1 left join acd_tax_tbl as td on (t1.id_doc = td.id_doc) \
   where (t1.id_doc = :doc) limit 1) as t \
   left join clm_position_tbl as users on (users.id = t.id_person), \
   clm_client_tbl as res left join clm_statecl_tbl as respar on (respar.id_client = res.id), \
   clm_client_tbl as abon left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id), \
   clm_client_tbl as chnoe left join clm_statecl_tbl as chpar on (chpar.id_client = chnoe.id) \
   where t.id_client = abon.id \
   and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <=t.mmgg  ) \
   and (res.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_res' limit 1) ) \
   and (chnoe.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_chnoe' limit 1) ); ";

  ZQTaxHeader->Sql->Clear();
  ZQTaxHeader->Sql->Add(sqlstr);
  ZQTaxHeader->ParamByName("doc")->AsInteger = id_tax;


  TWTQuery *ZQTaxLines = new  TWTQuery(this);

  sqlstr=" select ts.dt_bill,ts.text, t.id_pref, ts.demand_val, ts.unit, uktzed, unit_kod, \
   ts.tariff,ts.sum_val7,ts.sum_val8, \
   ts.sum_val9,ts.sum_val10,ts.sum_val7+ts.sum_val8+ts.sum_val9+ts.sum_val10 as sum_val \
   from acd_tax_tbl as ts join acm_tax_tbl as t on (t.id_doc = ts.id_doc) \
   where (ts.id_doc = :doc); ";

  ZQTaxLines->Sql->Clear();
  ZQTaxLines->Sql->Add(sqlstr);
  ZQTaxLines->ParamByName("doc")->AsInteger = id_tax;

  try
  {
   ZQTaxHeader->Open();
   ZQTaxLines->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTaxHeader->Close();
   ZQTaxLines->Close();
   delete ZQTaxHeader;
   delete ZQTaxLines;
   return 0;
  }
  ZQTaxHeader->First();

  Word mmgg_year;
  Word mmgg_month;
  Word mmgg_day;

  TDateTime tax_mmgg = ZQTaxHeader->FieldByName("mmgg")->AsDateTime;
  DecodeDate(tax_mmgg,mmgg_year,mmgg_month,mmgg_day);

  AnsiString doc_version;

  if ((mmgg_year>2016)||(mmgg_year==2016)&&(mmgg_month>=3))
  {
    return BuildXML2016( id_tax);
  };


  if (mmgg_year>=2015)
     doc_version="7";
  else
     doc_version="6";

  int xml_num=0;
  if (ZQTaxHeader->FieldByName("xml_num")->AsInteger==0)
  {
   TWTQuery * ZQTax = new TWTQuery(Application);

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add("select max(xml_num) as lastnum from acm_tax_tbl where mmgg = :mmgg;");
   ZQTax->ParamByName("mmgg")->AsDateTime=ZQTaxHeader->FieldByName("mmgg")->AsDateTime;

   try
   {
    ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    delete ZQTaxHeader;
    delete ZQTaxLines;

    return 0;
   }
   xml_num= ZQTax->FieldByName("lastnum")->AsInteger+1;
   delete ZQTax;

//   qTaxList->Edit();
//   qTaxList->FieldByName("xml_num")->AsInteger =xml_num;
//   qTaxList->Post();

  }
  else
  {
    xml_num =ZQTaxHeader->FieldByName("xml_num")->AsInteger;
  }

  char oldDecimalSeparator = DecimalSeparator;
  DecimalSeparator='.';

  parser = new TIcXMLParser(this);
  doc = new TIcXMLDocument();
  doc->AssignParser(parser);
  doc->SetEncoding("windows-1251");

  root = doc->CreateElement("DECLAR");
  doc->SetDocumentElement(root);

  root->SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
  root->SetAttribute("xsi:noNamespaceSchemaLocation","J120100"+doc_version+".xsd");

  head = doc->CreateElement("DECLARHEAD");
  root->AppendChild(head);

  item = doc->CreateElement("TIN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("22815333"));

  item = doc->CreateElement("C_DOC");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("J12"));

  item = doc->CreateElement("C_DOC_SUB");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("010"));

  item = doc->CreateElement("C_DOC_VER");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(doc_version));

  item = doc->CreateElement("C_DOC_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0"));

  item = doc->CreateElement("C_DOC_CNT");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(xml_num));

  item = doc->CreateElement("C_REG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("25"));
  item->SetCharData(doc->CreateTextNode("28"));

  item = doc->CreateElement("C_RAJ");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("26"));
  item->SetCharData(doc->CreateTextNode("10"));

  item = doc->CreateElement("PERIOD_MONTH");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_month));

  item = doc->CreateElement("PERIOD_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("PERIOD_YEAR");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_year));

  item = doc->CreateElement("C_STI_ORIG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("2526"));
  item->SetCharData(doc->CreateTextNode("2810"));

  item = doc->CreateElement("C_DOC_STAN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("LINKED_DOCS");
  head->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("D_FILL");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatDateTime ("ddmmyyyy",Now())));

  item = doc->CreateElement("SOFTWARE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("Energo"));

//		<TIN>22815333</TIN>
//		<C_DOC>J12</C_DOC>
//		<C_DOC_SUB>010</C_DOC_SUB>
//		<C_DOC_VER>3</C_DOC_VER>
//		<C_DOC_TYPE>0</C_DOC_TYPE>
//		<C_DOC_CNT>13</C_DOC_CNT>
//		<C_REG>25</C_REG>
//		<C_RAJ>26</C_RAJ>
//		<PERIOD_MONTH>11</PERIOD_MONTH>
//		<PERIOD_TYPE>1</PERIOD_TYPE>
//		<PERIOD_YEAR>2011</PERIOD_YEAR>
//		<C_STI_ORIG>2526</C_STI_ORIG>
//		<C_DOC_STAN>1</C_DOC_STAN>
//		<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>
//		<D_FILL>05122011</D_FILL>
//		<SOFTWARE>OPZ 1.29.19</SOFTWARE>

  body = doc->CreateElement("DECLARBODY");
  root->AppendChild(body);

  if (doc_version=="6")
  {
   item = doc->CreateElement("HORIG");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode("1"));

   item = doc->CreateElement("HERPN");
   body->AppendChild(item);

   if (ZQTaxHeader->FieldByName("flag_reg")->AsInteger==1)
     item->SetCharData(doc->CreateTextNode("1"));
   else
     item->SetAttribute("xsi:nil","true");
  }

  if (doc_version=="7")
  {
   item = doc->CreateElement("H01");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  item = doc->CreateElement("HORIG1");
  body->AppendChild(item);

   if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
    item->SetAttribute("xsi:nil","true");
  else
      item->SetCharData(doc->CreateTextNode("1"));

 // item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("HTYPR");
  body->AppendChild(item);
    if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
   item->SetAttribute("xsi:nil","true");
   else
     item->SetCharData(doc->CreateTextNode("02"));

  //item->SetAttribute("xsi:nil","true");

  AnsiString StaxDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("reg_date")->AsDateTime);
  item = doc->CreateElement("HFILL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxDate));

  AnsiString StaxNum =ZQTaxHeader->FieldByName("int_num")->AsString;
  item = doc->CreateElement("HNUM");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum));

  item = doc->CreateElement("HNUM1");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  AnsiString StaxNum2=(ZQTaxHeader->FieldByName("reg_num")->AsString).SubString(AnsiPos("/",ZQTaxHeader->FieldByName("reg_num")->AsString)+1,3);
  int len =StaxNum2.Length();
  for(int i = 0; i< (3-len); i++  ) {StaxNum2 = ""+StaxNum2;}

  item = doc->CreateElement("HNUM2");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum2));

  item = doc->CreateElement("HNAMESEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resname")->AsString));

  item = doc->CreateElement("HNAMEBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonname")->AsString));

  item = doc->CreateElement("HKSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_res")->AsString.Trim()));

  item = doc->CreateElement("HKBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_abon")->AsString.Trim()));

  item = doc->CreateElement("HLOCSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resaddr")->AsString));

  item = doc->CreateElement("HLOCBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonaddr")->AsString));


   AnsiString resPhone =ZQTaxHeader->FieldByName("resphone")->AsString.Trim();

   TReplaceFlags flags ;
   flags <<rfReplaceAll;

   resPhone = StringReplace(resPhone,"-","",flags);
   resPhone = StringReplace(resPhone,"(","",flags);
   resPhone = StringReplace(resPhone,")","",flags);

   if (AnsiPos("/",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos("/",resPhone )-1);
   if (AnsiPos(",",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(",",resPhone )-1);
   if (AnsiPos(";",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(";",resPhone )-1);
   if (AnsiPos(".",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(".",resPhone )-1);
   if (AnsiPos(" ",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(" ",resPhone )-1);

   resPhone = resPhone.SubString(1, 10).Trim();

  item = doc->CreateElement("HTELSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(resPhone));

   AnsiString abonPhone =ZQTaxHeader->FieldByName("abonphone")->AsString.Trim();

   abonPhone = StringReplace(abonPhone,"-","",flags);
   abonPhone = StringReplace(abonPhone,"(","",flags);
   abonPhone = StringReplace(abonPhone,")","",flags);

   if (AnsiPos("/",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos("/",abonPhone)-1);
   if (AnsiPos(",",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(",",abonPhone)-1);
   if (AnsiPos(";",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(";",abonPhone)-1);
   if (AnsiPos(".",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(".",abonPhone)-1);
   if (AnsiPos(" ",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(" ",abonPhone)-1);

   abonPhone = abonPhone.SubString(1, 10).Trim();
   if (abonPhone=="0") abonPhone = "";

  item = doc->CreateElement("HTELBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(abonPhone));
/*
  item = doc->CreateElement("HNSPDVSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("SvidNum_res")->AsString.Trim()));

  item = doc->CreateElement("HNSPDVBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("SvidNum_abon")->AsString.Trim()));
*/
  AnsiString contract;
  AnsiString taxtext;

     if ((ZQTaxHeader->FieldByName("id_section")->AsInteger  ==206)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==207)||
         (ZQTaxHeader->FieldByName("id_section")->AsInteger  ==205)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==208))
     {
       contract="������ ��� ������������ ����������� ����㳺�";

       item = doc->CreateElement("H01G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));

       item = doc->CreateElement("H01G2D");
       body->AppendChild(item);
       if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString=="100000000000")
        item->SetAttribute("xsi:nil","true");
       else
       item->SetAttribute("xsi:nil","true");

       item = doc->CreateElement("H01G3S");
       body->AppendChild(item);
       item->SetAttribute("xsi:nil","true");

       if ((ZQTaxHeader->FieldByName("id_section")->AsInteger  ==206)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==207))
       {
         taxtext = ZQTaxHeader->FieldByName("taxtext")->AsString;
       }
       else
       {
         taxtext = "������ � ��������� �������";
       }

     }
     else
     {
       contract="������ ��� ���������� ���������� ����㳿";
       taxtext = "������ � ��������� �������";

       item = doc->CreateElement("H01G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));

       AnsiString SdocDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("doc_dat")->AsDateTime);
       item = doc->CreateElement("H01G2D");
       body->AppendChild(item);
      if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString=="100000000000")
       item->SetAttribute("xsi:nil","true");
       else
       item->SetCharData(doc->CreateTextNode(SdocDate));

       item = doc->CreateElement("H01G3S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("doc_num")->AsString.Trim()));

     }

  item = doc->CreateElement("H02G1S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(taxtext));

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG2D");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(FormatDateTime ("ddmmyyyy",ZQTaxLines->FieldByName("dt_bill")->AsDateTime)));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG3S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("text")->AsString));

   ZQTaxLines->Next();
  }

   ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("uktzed")->AsString));

   ZQTaxLines->Next();
  }


  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit")->AsString));

   ZQTaxLines->Next();
  }

  if (doc_version=="7")
  {
   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG105_2S");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit_kod")->AsString));

    ZQTaxLines->Next();
   }
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG5");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("demand_val")->AsString));
/*
   if (ZQTaxLines->FieldByName("id_pref")->AsInteger == 20)
   {
    item = doc->CreateElement("RXXXXG5S");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("demand_txt")->AsString));
   }
*/
   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG6");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("tariff")->AsString));

   ZQTaxLines->Next();
  }

  double total_sum7=0;

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("sum_val7")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG7");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("sum_val7")->AsString));

    total_sum7 = total_sum7+ZQTaxLines->FieldByName("sum_val7")->AsFloat;
   }
   ZQTaxLines->Next();
  }

  double total_sum8=0;
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("sum_val8")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG8");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("sum_val8")->AsString));
    total_sum8 = total_sum8+ZQTaxLines->FieldByName("sum_val8")->AsFloat;
   }
   ZQTaxLines->Next();
  }

  if(total_sum7!=0)
  {
   item = doc->CreateElement("R01G7");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum7)));
  }
  else
  {
   item = doc->CreateElement("R01G7");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  if(total_sum8!=0)
  {
   item = doc->CreateElement("R01G8");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum8)));
  }
  else
  {
   item = doc->CreateElement("R01G8");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  item = doc->CreateElement("R01G9");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G10");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum7+total_sum8)));

  item = doc->CreateElement("R02G11");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G7");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  item = doc->CreateElement("R03G8");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G9");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  item = doc->CreateElement("R04G7");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum7+ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  if(total_sum8!=0)
  {
   item = doc->CreateElement("R04G8");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum8)));
  }
  else
  {
   item = doc->CreateElement("R04G8");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  item = doc->CreateElement("R04G9");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R04G10");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R04G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxHeader->FieldByName("value")->AsFloat+ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  item = doc->CreateElement("R003G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("H10G1S");
  body->AppendChild(item);
  AnsiString Repname= ZQTaxHeader->FieldByName("represent_name")->AsString;
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("represent_name")->AsString));


//		<HORIG>1</HORIG><HERPN xsi:nil="true"></HERPN>
//		<HORIG1 xsi:nil="true"></HORIG1>
//		<HTYPR xsi:nil="true"></HTYPR>
//		<HFILL>30112011</HFILL>
//		<HNUM>1027</HNUM>
//		<HNUM1 xsi:nil="true"></HNUM1>
//		<HNUM2>009</HNUM2>
//		<HNAMESEL>����_��� ���_������ ���������� "����_�_����������"/�� ���������� ����� ����������� �����</HNAMESEL>
//		<HNAMEBUY>����_��� ���_������ ���������� "��������" ������������������ ������_��� "����_�_���������"</HNAMEBUY>
//		<HKSEL>228153325261</HKSEL>
//		<HKBUY>001353926654</HKBUY>
//		<HLOCSEL>������, 14000, ����_�_����� ���., �.����_�_�, ���.��������, ���.40/17500 ����_�_����� ���., �.�������, ���. �����������, ���.109</HLOCSEL>
//		<HLOCBUY>04053 �.��� ����.������_������ , ���.3-5</HLOCBUY>
//		<HTELSEL>0463732023</HTELSEL>
//		<HTELBUY>0463731303</HTELBUY>
//		<HNSPDVSEL>100335442</HNSPDVSEL>
//		<HNSPDVBUY>100332806</HNSPDVBUY>
//		<H01G1S>�����_� ��� ���������� ���������� �����_�</H01G1S>
//		<H01G2D>05112007</H01G2D>
//		<H01G3S>10115</H01G3S>
//		<H02G1S>������ � ��������� �������</H02G1S>


//  item->SetAttribute("attribute","value");
//  item->SetCharData(doc->CreateTextNode("sample text"));
//  item->SetCharData(doc->CreateTextNode("������� �����"));

  ZQTaxHeader->Close();
  ZQTaxLines->Close();

  AnsiString Sxml_num=IntToStr(xml_num);
  len =Sxml_num.Length();
  for(int i = 0; i< (7-len); i++  ) {Sxml_num = "0"+Sxml_num;}

  AnsiString Smonth = IntToStr(mmgg_month);
  if (mmgg_month <10) Smonth = "0"+Smonth;
  AnsiString Syear = IntToStr(mmgg_year);

  xmlfilename =ExtractFilePath(Application->ExeName)+"xml\\";

//  xmlfilename=xmlfilename+"2526"+"0022815333"+"J120100"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2526"+".xml";
  xmlfilename=xmlfilename+"2810"+"0022815333"+"J120100"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2810"+".xml";

  doc->Write(xmlfilename);

  //ShowMessage("��������� ��������� ��������� � ����� "+xmlfilename);

  delete doc;
  delete parser;
  DecimalSeparator = oldDecimalSeparator;

  delete ZQTaxHeader;
  delete ZQTaxLines;

  return xml_num;
}

//----------------------------------------------------------------------
int TfTaxListFull::BuildXML2016(int id_tax)
{ //� ����� 2016
  TIcXMLDocument* doc;
  TIcXMLParser* parser;
  TIcXMLElement* root;
  TIcXMLElement* head;
  TIcXMLElement* body;
  TIcXMLElement* item;
  AnsiString sqlstr;

  TWTQuery *ZQTaxHeader = new  TWTQuery(this);

   sqlstr="select t.reg_num,t.reg_date, t.int_num,t.xml_num,t.mmgg, abon.id as abonid, t.id_pref, \
   CASE WHEN users.represent_name ~ '^(.+)\\\\s(.)\\\\.(.)\\\\.$' THEN \
     substr(trim(users.represent_name),length(users.represent_name)-3,4)||' '||substr(trim(users.represent_name),0,length(users.represent_name)-4) ELSE represent_name END as represent_name, \
   CASE WHEN (abonpar.flag_taxpay = 0) and (position('���������' in (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END) )=0) \
       THEN  (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END)||' ���������' \
       WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END::::varchar as abonname, \
   res.name as resname, \
   CASE WHEN abonpar.addr_main is NULL THEN abonpar.addr_tax ELSE CASE WHEN trim(coalesce(abonpar.addr_main,''))='' THEN abonpar.addr_tax ELSE  abonpar.addr_main||' / \n'||abonpar.addr_tax END END::::varchar as abonaddr, \
   abon.name as abonnamesh,t.text as taxtext, \
   chpar.addr_tax||' / \n'||respar.addr_tax as resaddr, \
   abonpar.doc_num, abonpar.doc_dat, abonpar.filial_num, users.inn, \
   CASE WHEN (abonpar.flag_taxpay = 1) THEN abonpar.tax_num ELSE '100000000000' END::::varchar as taxnum_abon, \
   abonpar.licens_num as SvidNum_abon, \
   abonpar.flag_taxpay,abon.code, abonpar.id_section, \
   respar.tax_num as taxnum_res,respar.licens_num as SvidNum_res, \
   abonpar.phone as abonphone,respar.phone as resphone, \
   t.value_tax,t.value, t.sum_val7,t.sum_val8, t.flag_reg \
   from (select t1.*, td.sum_val7,td.sum_val8,td.text from acm_tax_tbl as t1 left join acd_tax_tbl as td on (t1.id_doc = td.id_doc) \
   where (t1.id_doc = :doc) limit 1) as t \
   left join clm_position_tbl as users on (users.id = t.id_person), \
   clm_client_tbl as res left join clm_statecl_tbl as respar on (respar.id_client = res.id), \
   clm_client_tbl as abon left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id), \
   clm_client_tbl as chnoe left join clm_statecl_tbl as chpar on (chpar.id_client = chnoe.id) \
   where t.id_client = abon.id \
   and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <=t.mmgg  ) \
   and (res.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_res' limit 1) ) \
   and (chnoe.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_chnoe' limit 1) ); ";

  ZQTaxHeader->Sql->Clear();
  ZQTaxHeader->Sql->Add(sqlstr);
  ZQTaxHeader->ParamByName("doc")->AsInteger = id_tax;


  TWTQuery *ZQTaxLines = new  TWTQuery(this);

  sqlstr=" select ts.dt_bill,ts.text, t.id_pref, ts.demand_val, ts.unit, uktzed, unit_kod, ts.tariff, \
   ts.sum_val7+ts.sum_val8+ts.sum_val9+ts.sum_val10 as sum_val \
   from acd_tax_tbl as ts join acm_tax_tbl as t on (t.id_doc = ts.id_doc) \
   where (ts.id_doc = :doc); ";

  ZQTaxLines->Sql->Clear();
  ZQTaxLines->Sql->Add(sqlstr);
  ZQTaxLines->ParamByName("doc")->AsInteger = id_tax;

  try
  {
   ZQTaxHeader->Open();
   ZQTaxLines->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTaxHeader->Close();
   ZQTaxLines->Close();
   delete ZQTaxHeader;
   delete ZQTaxLines;
   return 0;
  }
  ZQTaxHeader->First();

  Word mmgg_year;
  Word mmgg_month;
  Word mmgg_day;

  TDateTime tax_mmgg = ZQTaxHeader->FieldByName("mmgg")->AsDateTime;
  DecodeDate(tax_mmgg,mmgg_year,mmgg_month,mmgg_day);

  AnsiString doc_version;

  if (((mmgg_year==2017)&&(mmgg_month>=3))||(mmgg_year>2017))
     doc_version="9";
  else
     doc_version="8";

  int xml_num=0;
  if (ZQTaxHeader->FieldByName("xml_num")->AsInteger==0)
  {
   TWTQuery * ZQTax = new TWTQuery(Application);

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add("select max(xml_num) as lastnum from acm_tax_tbl where mmgg = :mmgg;");
   ZQTax->ParamByName("mmgg")->AsDateTime=ZQTaxHeader->FieldByName("mmgg")->AsDateTime;

   try
   {
    ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    delete ZQTaxHeader;
    delete ZQTaxLines;

    return 0;
   }
   xml_num= ZQTax->FieldByName("lastnum")->AsInteger+1;
   delete ZQTax;


  }
  else
  {
    xml_num =ZQTaxHeader->FieldByName("xml_num")->AsInteger;
  }

  char oldDecimalSeparator = DecimalSeparator;
  DecimalSeparator='.';

  parser = new TIcXMLParser(this);
  doc = new TIcXMLDocument();
  doc->AssignParser(parser);
  doc->SetEncoding("windows-1251");

  root = doc->CreateElement("DECLAR");
  doc->SetDocumentElement(root);

  root->SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
  root->SetAttribute("xsi:noNamespaceSchemaLocation","J120100"+doc_version+".xsd");

  head = doc->CreateElement("DECLARHEAD");
  root->AppendChild(head);

  item = doc->CreateElement("TIN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("22815333"));

  item = doc->CreateElement("C_DOC");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("J12"));

  item = doc->CreateElement("C_DOC_SUB");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("010"));

  item = doc->CreateElement("C_DOC_VER");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(doc_version));

  item = doc->CreateElement("C_DOC_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0"));

  item = doc->CreateElement("C_DOC_CNT");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(xml_num));

  item = doc->CreateElement("C_REG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("25"));
  item->SetCharData(doc->CreateTextNode("28"));

  item = doc->CreateElement("C_RAJ");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("26"));
  item->SetCharData(doc->CreateTextNode("10"));

  item = doc->CreateElement("PERIOD_MONTH");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_month));

  item = doc->CreateElement("PERIOD_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("PERIOD_YEAR");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_year));

  item = doc->CreateElement("C_STI_ORIG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("2526"));
  item->SetCharData(doc->CreateTextNode("2810"));

  item = doc->CreateElement("C_DOC_STAN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("LINKED_DOCS");
  head->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("D_FILL");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatDateTime ("ddmmyyyy",Now())));

  item = doc->CreateElement("SOFTWARE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("Energo"));


  body = doc->CreateElement("DECLARBODY");
  root->AppendChild(body);


  item = doc->CreateElement("H03");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("R03G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");


  item = doc->CreateElement("HORIG1");
  body->AppendChild(item);

   if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
    item->SetAttribute("xsi:nil","true");
  else
      item->SetCharData(doc->CreateTextNode("1"));

 // item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("HTYPR");
  body->AppendChild(item);
    if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
   item->SetAttribute("xsi:nil","true");
   else
     item->SetCharData(doc->CreateTextNode("02"));

  //item->SetAttribute("xsi:nil","true");

  AnsiString StaxDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("reg_date")->AsDateTime);
  item = doc->CreateElement("HFILL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxDate));

  AnsiString StaxNum =ZQTaxHeader->FieldByName("int_num")->AsString;
  item = doc->CreateElement("HNUM");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum));

  item = doc->CreateElement("HNUM1");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  AnsiString StaxNum2=(ZQTaxHeader->FieldByName("reg_num")->AsString).SubString(AnsiPos("/",ZQTaxHeader->FieldByName("reg_num")->AsString)+1,3);
  int len =StaxNum2.Length();
  for(int i = 0; i< (3-len); i++  ) {StaxNum2 = ""+StaxNum2;}

  item = doc->CreateElement("HNUM2");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum2));

  item = doc->CreateElement("HNAMESEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resname")->AsString));

  item = doc->CreateElement("HNAMEBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonname")->AsString));

  item = doc->CreateElement("HKSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_res")->AsString.Trim()));

  item = doc->CreateElement("HKBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_abon")->AsString.Trim()));

  item = doc->CreateElement("HFBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("filial_num")->AsString.Trim()));

/*
  item = doc->CreateElement("HLOCSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resaddr")->AsString));

  item = doc->CreateElement("HLOCBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonaddr")->AsString));


   AnsiString resPhone =ZQTaxHeader->FieldByName("resphone")->AsString.Trim();

   TReplaceFlags flags ;
   flags <<rfReplaceAll;

   resPhone = StringReplace(resPhone,"-","",flags);
   resPhone = StringReplace(resPhone,"(","",flags);
   resPhone = StringReplace(resPhone,")","",flags);

   if (AnsiPos("/",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos("/",resPhone )-1);
   if (AnsiPos(",",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(",",resPhone )-1);
   if (AnsiPos(";",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(";",resPhone )-1);
   if (AnsiPos(".",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(".",resPhone )-1);
   if (AnsiPos(" ",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(" ",resPhone )-1);

   resPhone = resPhone.SubString(1, 10).Trim();

  item = doc->CreateElement("HTELSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(resPhone));

   AnsiString abonPhone =ZQTaxHeader->FieldByName("abonphone")->AsString.Trim();

   abonPhone = StringReplace(abonPhone,"-","",flags);
   abonPhone = StringReplace(abonPhone,"(","",flags);
   abonPhone = StringReplace(abonPhone,")","",flags);

   if (AnsiPos("/",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos("/",abonPhone)-1);
   if (AnsiPos(",",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(",",abonPhone)-1);
   if (AnsiPos(";",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(";",abonPhone)-1);
   if (AnsiPos(".",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(".",abonPhone)-1);
   if (AnsiPos(" ",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(" ",abonPhone)-1);

   abonPhone = abonPhone.SubString(1, 10).Trim();
   if (abonPhone=="0") abonPhone = "";

  item = doc->CreateElement("HTELBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(abonPhone));
  */
/*
  item = doc->CreateElement("HNSPDVSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("SvidNum_res")->AsString.Trim()));

  item = doc->CreateElement("HNSPDVBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("SvidNum_abon")->AsString.Trim()));
*/

  AnsiString contract;
  AnsiString taxtext;
      /*
     if ((ZQTaxHeader->FieldByName("id_section")->AsInteger  ==206)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==207)||
         (ZQTaxHeader->FieldByName("id_section")->AsInteger  ==205)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==208))
     {
       contract="������ ��� ������������ ����������� ����㳺�";

       item = doc->CreateElement("H01G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));

       item = doc->CreateElement("H01G2D");
       body->AppendChild(item);
       if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString=="100000000000")
        item->SetAttribute("xsi:nil","true");
       else
       item->SetAttribute("xsi:nil","true");

       item = doc->CreateElement("H01G3S");
       body->AppendChild(item);
       item->SetAttribute("xsi:nil","true");

       if ((ZQTaxHeader->FieldByName("id_section")->AsInteger  ==206)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==207))
       {
         taxtext = ZQTaxHeader->FieldByName("taxtext")->AsString;
       }
       else
       {
         taxtext = "������ � ��������� �������";
       }

     }
     else
     {
       contract="������ ��� ���������� ���������� ����㳿";
       taxtext = "������ � ��������� �������";

       item = doc->CreateElement("H01G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));

       AnsiString SdocDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("doc_dat")->AsDateTime);
       item = doc->CreateElement("H01G2D");
       body->AppendChild(item);
      if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString=="100000000000")
       item->SetAttribute("xsi:nil","true");
       else
       item->SetCharData(doc->CreateTextNode(SdocDate));

       item = doc->CreateElement("H01G3S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("doc_num")->AsString.Trim()));

     }

  item = doc->CreateElement("H02G1S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(taxtext));
    */
    /*
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG2D");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(FormatDateTime ("ddmmyyyy",ZQTaxLines->FieldByName("dt_bill")->AsDateTime)));

   ZQTaxLines->Next();
  }
*/
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG3S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("text")->AsString));

   ZQTaxLines->Next();
  }

   ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);

   if (((ZQTaxHeader->FieldByName("id_pref")->AsInteger !=20)&&(doc_version=="9"))||(doc_version=="8"))
     item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("uktzed")->AsString));
   else
    item->SetAttribute("xsi:nil","true");

   ZQTaxLines->Next();
  }

  if (doc_version=="9")
  {
   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG32");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetAttribute("xsi:nil","true");

    ZQTaxLines->Next();
   }

   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG33");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);

    if ((ZQTaxHeader->FieldByName("id_pref")->AsInteger ==20)&&(doc_version=="9"))
      item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("uktzed")->AsString));
    else
     item->SetAttribute("xsi:nil","true");

    ZQTaxLines->Next();
   }

  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit")->AsString));

   ZQTaxLines->Next();
  }


   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG105_2S");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit_kod")->AsString));

    ZQTaxLines->Next();
   }


  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG5");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("demand_val")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG6");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("tariff")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG008");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode("20"));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG009");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetAttribute("xsi:nil","true");

   ZQTaxLines->Next();
  }


  double total_sum=0;

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("sum_val")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG010");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("sum_val")->AsString));

    total_sum = total_sum+ZQTaxLines->FieldByName("sum_val")->AsFloat;
   }
   ZQTaxLines->Next();
  }

  if (doc_version=="9")
  {
   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG011");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetAttribute("xsi:nil","true");

    ZQTaxLines->Next();
   }
  }
/*
  double total_sum8=0;
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("sum_val8")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG8");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("sum_val8")->AsString));
    total_sum8 = total_sum8+ZQTaxLines->FieldByName("sum_val8")->AsFloat;
   }
   ZQTaxLines->Next();
  }
*/
  if(total_sum!=0)
  {
   item = doc->CreateElement("R01G7");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum)));
  }
  else
  {
   item = doc->CreateElement("R01G7");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }
 /*
  if(total_sum8!=0)
  {
   item = doc->CreateElement("R01G8");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum8)));
  }
  else
  {
   item = doc->CreateElement("R01G8");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }
 */
  item = doc->CreateElement("R01G8");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G9");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G10");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  item = doc->CreateElement("R03G7");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  item = doc->CreateElement("R03G109");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G109");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R02G11");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R04G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum+ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

    /*
  item = doc->CreateElement("R01G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum7+total_sum8)));

  item = doc->CreateElement("R02G11");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");


  item = doc->CreateElement("R03G8");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G9");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R03G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");


  item = doc->CreateElement("R04G7");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum7+ZQTaxHeader->FieldByName("value_tax")->AsFloat)));

  if(total_sum8!=0)
  {
   item = doc->CreateElement("R04G8");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum8)));
  }
  else
  {
   item = doc->CreateElement("R04G8");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  item = doc->CreateElement("R04G9");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R04G10");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R04G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxHeader->FieldByName("value")->AsFloat+ZQTaxHeader->FieldByName("value_tax")->AsFloat)));
*/
  item = doc->CreateElement("R003G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("HBOS");
  body->AppendChild(item);
  AnsiString Repname= ZQTaxHeader->FieldByName("represent_name")->AsString;
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("represent_name")->AsString));

  item = doc->CreateElement("HKBOS");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("inn")->AsString));


//  item->SetAttribute("attribute","value");
//  item->SetCharData(doc->CreateTextNode("sample text"));
//  item->SetCharData(doc->CreateTextNode("������� �����"));

  ZQTaxHeader->Close();
  ZQTaxLines->Close();

  AnsiString Sxml_num=IntToStr(xml_num);
  len =Sxml_num.Length();
  for(int i = 0; i< (7-len); i++  ) {Sxml_num = "0"+Sxml_num;}

  AnsiString Smonth = IntToStr(mmgg_month);
  if (mmgg_month <10) Smonth = "0"+Smonth;
  AnsiString Syear = IntToStr(mmgg_year);

  xmlfilename =ExtractFilePath(Application->ExeName)+"xml\\";

//  xmlfilename=xmlfilename+"2526"+"0022815333"+"J120100"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2526"+".xml";
  xmlfilename=xmlfilename+"2810"+"0022815333"+"J120100"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2810"+".xml";

  doc->Write(xmlfilename);

  //ShowMessage("��������� ��������� ��������� � ����� "+xmlfilename);

  delete doc;
  delete parser;
  DecimalSeparator = oldDecimalSeparator;

  delete ZQTaxHeader;
  delete ZQTaxLines;

  return xml_num;
}



void __fastcall TfTaxListFull::DrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{

 TDBGrid* t=(TDBGrid*)Sender;

 float delta_tax =t->DataSource->DataSet->FieldByName("delta_tax")->AsFloat;
 int disabled =t->DataSource->DataSet->FieldByName("disabled")->AsInteger;

    if ( delta_tax!=0 )
     {    //t->Canvas->Brush->Color=0x00caffff;
//        t->Canvas->Font->Size=8;
        t->Canvas->Font->Color=clRed;
//        t->Canvas->FillRect(Rect);
//        t->Canvas->Font->Color=clBlack;
//        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
    };
    if (disabled)
    {
        t->Canvas->Font->Color=clGray;
    }
    t->DefaultDrawColumnCell(Rect,DataCol,Column, State);
}

//----------------------------------------------------------------------
//--------------------------- ������������� ----------------
//----------------------------------------------------------------------
__fastcall TfTaxCorListFull::~TfTaxCorListFull(void)
{
 delete fRepTaxCorLocal;
};
//------------------------------------------------------------

__fastcall TfTaxCorListFull::TfTaxCorListFull(TComponent* AOwner) : TWTDoc(AOwner)
{

 // ������� ������� ������� ������
  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  bool read_only =true;

  if(CheckLevelStrong("������ ��������� ���������-��������������")!=0)
  {
    read_only=false;
  }


  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);

  try
  {
   ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTax->Close();
   delete ZQTax;
   return;
  }
  ZQTax->First();
  mmgg = ZQTax->FieldByName("mmgg")->AsDateTime;

  ZQTax->Close();

  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
  BtnPrint->OnClick=ClientTaxPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;

  BtnPrintAll=new TButton(this);
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
  BtnNewCor->Enabled= !read_only;

  TButton *BtnDel=new TButton(this);
  BtnDel->Caption=" ������� ";
  BtnDel->OnClick=TaxDelete;
  BtnDel->Width=100;
  BtnDel->Top=2;
  BtnDel->Left=600;
  BtnDel->Enabled= !read_only;

  TButton *BtnXML=new TButton(this);
  BtnXML->Caption=" � XML";
  BtnXML->OnClick=TaxCorToXML;
  BtnXML->Width=100;
  BtnXML->Top=2;
  BtnXML->Left=1400;
  BtnXML->Enabled=true;

  TButton *BtnXMLAll=new TButton(this);
  BtnXMLAll->Caption=" � XML ���";
  BtnXMLAll->OnClick=TaxCorToXMLAll;
  BtnXMLAll->Width=100;
  BtnXMLAll->Top=2;
  BtnXMLAll->Left=1600;
  BtnXMLAll->Enabled=true;

  TButton *BtnXMLTax=new TButton(this);
  BtnXMLTax->Caption=" � XML �������� ��";
  BtnXMLTax->OnClick=TaxToXML;
  BtnXMLTax->Width=120;
  BtnXMLTax->Top=2;
  BtnXMLTax->Left=1400;
  BtnXMLTax->Enabled=true;


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
  PBtn->Params->AddButton(BtnXML,false)->ID="BtnXML";
  PBtn->Params->AddButton(BtnXMLAll,false)->ID="BtnXMLAll";
  PBtn->Params->AddButton(BtnXMLTax,false)->ID="BtnXMLTax";  
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";



  TWTPanel* PTax=MainPanel->InsertPanel(200,true,MainForm->Height/2);

  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;


   Query2->Sql->Clear();
   Query2->Sql->Add("select t.*, t.value+t.value_tax as value_sum, c.code, c.short_name , p.name as name_pref, tt.xml_num as tax_xml_num, tt.flag_reg as tax_flag_reg \
       from acm_taxcorrection_tbl as t " );
   Query2->Sql->Add("join clm_client_tbl as c on (c.id= t.id_client) ");
   Query2->Sql->Add("join aci_pref_tbl as p on (p.id= t.id_pref) ");
   Query2->Sql->Add("left join acm_tax_tbl as tt on (tt.id_doc = t.id_tax) ");
   Query2->Sql->Add("order by t.mmgg, t.int_num " );

   DBGrTax=new TWTDBGrid(PTax, Query2);

   TWTQuery *pers=new TWTQuery(this);

   pers->Sql->Add("select p.id as id_person,u.id , \
     p.represent_name from syi_user as u left join clm_position_tbl as p on (p.id = u.id_person) \
     where flag_type = 0 and u.id_person is not null order by u.name;");
   pers->Open();

   DBGrTax->Query->AddLookupField("represent1_name","id_person",pers,"represent_name","id_person");


   qTaxList = DBGrTax->Query;

//   DBGrTax->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrTax, true)->ID="Tax";

   if(read_only)
   {
      DBGrTax->SetReadOnly(true);
   }
   else
   {
      DBGrTax->SetReadOnly(false);
   }

   qTaxList->DefaultFilter="t.mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and t.int_num<>0 ";
   qTaxList->Filtered=true;
   qTaxList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
  NList->Add("value_sum");
  NList->Add("code");
  NList->Add("short_name");
  NList->Add("id_client");
  NList->Add("id_tax");
  NList->Add("id_bill");
  NList->Add("tax_xml_num");
  NList->Add("tax_flag_reg");
  NList->Add("name_pref");

  qTaxList->SetSQLModify("acm_taxcorrection_tbl",WList,NList,true,false,false);
  qTaxList->AfterInsert=CancelInsert;
  qTaxList->OnApplyUpdateError = PostError;


  TWTField *Fieldh;

  Fieldh = DBGrTax->AddColumn("code", " ", "������� ����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("short_name", "������� ", "�������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("int_num", "�����", "�����");
  Fieldh->SetWidth(40);

  Fieldh = DBGrTax->AddColumn("reg_num", "������ �����", "����� ��������� ���������");
  Fieldh->SetWidth(80);
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("reg_date", "����", "���� �������");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("represent1_name", "�����������", "�����������");
  Fieldh->SetWidth(120);

  Fieldh = DBGrTax->AddColumn("Name_pref", "���", "���");
  Fieldh->SetWidth(20);
  Fieldh->SetReadOnly();
/*
  Fieldh = DBGrTax->AddColumn("kind_calc", "���", "��������� �� ����� ��� �� �����");
  Fieldh->AddFixedVariable("1", "�� �����");
  Fieldh->AddFixedVariable("2", "�����");
  Fieldh->AddFixedVariable("3", "������");
  Fieldh->SetReadOnly();
*/
  Fieldh = DBGrTax->AddColumn("value", "����� ��� ���", "����� ��� ���");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value_tax", "���", "����� ���");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value_sum", "����� � ���", "����� � ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("tax_num", "����� ��", "����� ��������� ���������");
  Fieldh->SetWidth(80);

  Fieldh = DBGrTax->AddColumn("tax_date", "���� ��", "���� �������");
  Fieldh->Field->OnSetText = ValidateDate;  

  Fieldh = DBGrTax->AddColumn("reason", "�������", "������� �������������");
  Fieldh->SetWidth(100);

  Fieldh = DBGrTax->AddColumn("pay_date", "���� ���.", "���� ������");
  Fieldh->Field->OnSetText = ValidateDate;

  Fieldh = DBGrTax->AddColumn("mmgg", "�����", "�����");

  Fieldh = DBGrTax->AddColumn("flag_transmis", "������", "������");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "������");

  Fieldh = DBGrTax->AddColumn("flag_reg", "�����.�� ����", "�������� �� ����");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "�����.");
  Fieldh->SetWidth(85);

  Fieldh = DBGrTax->AddColumn("xml_num", "� xml �����", "����� xml �����");
  Fieldh->SetWidth(85);

  Fieldh = DBGrTax->AddColumn("tax_flag_reg", " �� ���.�� ����", "�������� �� ����");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "�����.");
  Fieldh->SetWidth(85);

  Fieldh = DBGrTax->AddColumn("tax_xml_num", "� xml ��", "����� xml �����");
  Fieldh->SetWidth(85);

  Fieldh = DBGrTax->AddColumn("id_doc", "���", "���");
  Fieldh->SetWidth(85);
  Fieldh->SetReadOnly();

  DBGrTax->Visible=true;


//----------------------------------------------------------------------------

  TWTPanel* PTaxLines=MainPanel->InsertPanel(200,true,200);

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options << doQuickOpen;

   Query3->Sql->Clear();
   Query3->Sql->Add("select t.* from acd_taxcorrection_tbl as t " );

   DBGrTaxLines=new TWTDBGrid(PTaxLines, Query3);

   qTaxLines = DBGrTaxLines->Query;

   DBGrTaxLines->SetReadOnly(false);
   PTaxLines->Params->AddGrid(DBGrTaxLines, true)->ID="TaxLines";


//   DBGrTaxLines->SetReadOnly(true);
   if(read_only)
   {
      DBGrTaxLines->SetReadOnly(true);
   }
   else
   {
      DBGrTaxLines->SetReadOnly(false);
   }

  qTaxLines->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
  qTaxLines->Filtered=true;

  qTaxLines->Open();

  WList=new TStringList();
  WList->Add("id");

  NList=new TStringList();
  NList->Add("mmgg");

  qTaxLines->SetSQLModify("acd_taxcorrection_tbl",WList,NList,true,true,true);
  qTaxLines->OnNewRecord=NewCorStrInsert;



  qTaxLines->IndexFieldNames = "id_doc";
  qTaxLines->LinkFields = "id_doc=id_doc";
  qTaxLines->MasterSource = DBGrTax->DataSource;


 // TWTField *Fieldh;
//   Fieldh = DBGrTaxLines->AddColumn("dt_bill", "����", "");

//  Fieldh = DBGrTaxLines->AddColumn("text", "�����", "");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTaxLines->AddColumn("line_no", "� �����", "� �����");

  Fieldh = DBGrTaxLines->AddColumn("unit", "�������", "");
  Fieldh->AddFixedVariable("������", "������");
  Fieldh->AddFixedVariable("���", "���");

  Fieldh = DBGrTaxLines->AddColumn("unit_kod", "��� ��.���.", "");
  Fieldh->AddFixedVariable("0415", "0415");
  Fieldh->AddFixedVariable("2454", "2454");

  Fieldh = DBGrTaxLines->AddColumn("uktzed", "��� ��� ���", "");


  Fieldh = DBGrTaxLines->AddColumn("cor_demand", "���.����������", "  ");
  Fieldh->Precision=0;
  Fieldh = DBGrTaxLines->AddColumn("tariff", "����", " ");


  Fieldh = DBGrTaxLines->AddColumn("cor_tariff", "���.����", " ");
  Fieldh = DBGrTaxLines->AddColumn("demand", "����������", "  ");
  Fieldh->Precision=0;

  Fieldh = DBGrTaxLines->AddColumn("cor_sum_20", "�����", "");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();

//  Fieldh = DBGrTaxLines->AddColumn("cor_sum_0", "����� (0%)", "");
//  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();


  Fieldh = DBGrTaxLines->AddColumn("cor_tax", "���", "���");
  Fieldh->Precision=2;
//  Fieldh->SetReadOnly();


  DBGrTaxLines->Visible=true;


//----------------------------------------------------------------------------
//  SetCaption("������������� ��������� ��������� ");
//  DocTax->ShowAs("CliTax");
//  MainPanel->ParamByID("Tax")->Control->SetFocus();


  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();


  TWTToolBar* tb=DBGrTax->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
//    if ( btn->ID=="Full")
//       tb->Buttons[i]->OnClick=EqpAccept;
    if ( btn->ID=="NewRecord")
       {
//       if (IsInsert)
//         tb->Buttons[i]->OnClick=NewEqp;
//       else
         tb->Buttons[i]->OnClick=NULL;
       }

    if ( btn->ID=="DelRecord")
     {
//        OldDelEqp=tb->Buttons[i]->OnClick;
        tb->Buttons[i]->OnClick=TaxDelete;
//       tb->Buttons[i]->OnClick=NULL;
     }
   }


  TWTToolButton* btPeriod=tb->AddButton("dateinterval", "����� �������", PeriodSel);
  TWTToolButton* btAll = tb->AddButton("AddCond", "������ ������", TaxAllList);
  TWTToolButton* btReal = tb->AddButton("RemCond", "����������� ���", TaxRealList);
  listMode = 0;

/*
  tb=DBGrTaxLines->ToolBar;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }

    if ( btn->ID=="DelRecord")
       {
//        tb->Buttons[i]->OnClick=TaxDelete;
         tb->Buttons[i]->OnClick=NULL;
       }
   }
*/
   //qTaxList->Refresh();

   SetCaption("������������� ��������� ��������� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");


//  Application->CreateForm(__classid(TfRepTaxCor), &fRepTaxCorLocal);
  if (mmgg < TDateTime(2014,3,1))
  {
   fRepTaxCorLocal = new TfRepTaxCor(this);
  }
  else
  {
   if (mmgg < TDateTime(2014,12,1))
     fRepTaxCorLocal = new TfRepTaxCor2014(this);
   else
   {
     if (mmgg < TDateTime(2015,1,1))
       fRepTaxCorLocal = new TfRepTaxCor2014_12(this);
     else
     {
         if (mmgg < TDateTime(2016,3,1))
            fRepTaxCorLocal = new TfRepTaxCor2015(this);
         else
            fRepTaxCorLocal = new TfRepTaxCor2016(this);

     }

   }
  }


 };

//---------------------------------------------------------------------------
void __fastcall TfTaxCorListFull::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};
//--------------------------------------------------

void __fastcall TfTaxCorListFull::ClientTaxPrint(TObject *Sender)
{
  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;
//  Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
  fRepTaxCorLocal->ShowTaxCor(id_tax);

};

//--------------------------------------------------
 /*
void __fastcall TfTaxCorListFull::TaxRebuild(TObject *Sender)
{
  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;
  int id_bill=qTaxList->FieldByName("id_bill")->AsInteger;
  int int_num_old=qTaxList->FieldByName("int_num")->AsInteger;
  int kind_calc=qTaxList->FieldByName("kind_calc")->AsInteger;
  //���� ������ ��� �� �� ����
  if (kind_calc !=1 ) return;

  if (MessageDlg(" ��������������� ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }


  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
  ZQTax->Transaction->AutoCommit=false;


   AnsiString sqlstr="delete from acm_tax_tbl where id_doc = :doc ;";
   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("doc")->AsInteger=id_tax;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

  sqlstr="select acm_createTaxBill( :bill );";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  ZQTax->ParamByName("bill")->AsInteger=id_bill;

  try
   {
   ZQTax->ExecSql();

   }
  catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

   AnsiString NewTaxNum=InputBox("����� ��������� ���������", "������� ��������� ��������� � �������", IntToStr(int_num_old));

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
    ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

   ZQTax->Transaction->Commit();
   ZQTax->Transaction->AutoCommit=true;
   ShowMessage("��������� ��������� ������� ���������������");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();
};
*/
//--------------------------------------------------

void __fastcall TfTaxCorListFull::TaxDelete(TObject *Sender)
{
  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;

  if (MessageDlg(" ������� �������������  ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
 // ZQTax->Transaction->AutoCommit=false;


   AnsiString sqlstr="delete from acm_taxcorrection_tbl where id_doc = :doc ;";
   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   ZQTax->ParamByName("doc")->AsInteger=id_tax;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
//    ZQTax->Transaction->Rollback();
    ZQTax->Close();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

//   ZQTax->Transaction->Commit();
//   ZQTax->Transaction->AutoCommit=true;
   ShowMessage("������������� �������");
   delete ZQTax;

   qTaxList->Refresh();
};
//--------------------------------------------------
void __fastcall TfTaxCorListFull::AllTaxPrint(TObject *Sender)
{
//  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;
//  Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
//  fRepTaxN->ShowTaxNal(id_tax);

    TfTaxPrintParams* fTaxPrintParams;
    Application->CreateForm(__classid(TfTaxPrintParams), &fTaxPrintParams);

    fTaxPrintParams->dtPeriod->Date =qTaxList->FieldByName("mmgg")->AsDateTime;
    fTaxPrintParams->edStart->Text =qTaxList->FieldByName("int_num")->AsString;

    if (fTaxPrintParams->ShowModal()!= mrOk)
     {
      delete fTaxPrintParams;
      return ;
     };

   Word year;
   Word month;
   Word day;

   DecodeDate(fTaxPrintParams->dtPeriod->Date,year,month,day);

    int oldfiltered = qTaxList->Filtered;
    AnsiString OldFilter = qTaxList->DefaultFilter;

    qTaxList->Filtered=false;
    qTaxList->DefaultFilter="int_num >= '"+fTaxPrintParams->edStart->Text+
    "' and int_num <= '"+fTaxPrintParams->edStop->Text+"' and mmgg = '"+ FormatDateTime("yyyy-mm-dd",EncodeDate(year,month,1))+"' ";
    qTaxList->Filtered=true;
    qTaxList->Refresh();


/*
   qTaxList->Close();

//   AnsiString Macro = " where int_num >= "+fTaxPrintParams->edStart->Text+
//   " and int_num <= "+fTaxPrintParams->edStop->Text+" and mmgg = '"+ FormatDateTime("yyyy-mm-dd",EncodeDate(year,month,1))+"' ";

   qTaxList->ParamByName("start")->AsString=fTaxPrintParams->edStart->Text;
   qTaxList->ParamByName("stop")->AsString=fTaxPrintParams->edStop->Text;
   qTaxList->ParamByName("mmgg")->AsDateTime=EncodeDate(year,month,1);
   qTaxList->ParamByName("all")->AsInteger=0;
   try
   {
    qTaxList->Open();
   }
   catch(...)
   {
    delete fTaxPrintParams;
    return;
   }
*/

    qTaxList->FindFirst();

    DBGrTax->Enabled = false;
    BtnPrintAll->Caption="���� ������...";

 //   Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
    for (int i=0; i<qTaxList->RecordCount;i++)
    {
     fRepTaxCorLocal->ShowTaxCor(qTaxList->FieldByName("id_doc")->AsInteger, 1);
     qTaxList->FindNext();
    }

//   qTaxList->Close();
//   qTaxList->ParamByName("all")->AsInteger=1;
//   qTaxList->Open();

    qTaxList->DefaultFilter = OldFilter;
    qTaxList->Filtered=oldfiltered;
    DBGrTax->Enabled = true;


   qTaxList->Refresh();
   BtnPrintAll->Caption="������ ���";

   delete fTaxPrintParams;
};

//---------------------------------------------------------------------------

void __fastcall TfTaxCorListFull::ShowData(void)
{
 MainPanel->ParamByID("Tax")->Control->SetFocus();
 MainPanel->ParamByID("TaxLines")->Control->SetFocus();
 MainPanel->ParamByID("Tax")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfTaxCorListFull::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfTaxCorListFull::TaxAllList(TObject *Sender)
{
 AnsiString filter = qTaxList->DefaultFilter;

 if (listMode==0)
 {
   TReplaceFlags flags ;
   flags <<rfReplaceAll;
   filter = StringReplace(filter, "and t.int_num<>0", "", flags );
   qTaxList->DefaultFilter=filter;
   qTaxList->Filtered=true;

 }

 listMode = 1;
}
//---------------------------------------------------------------------------
void __fastcall TfTaxCorListFull::TaxRealList(TObject *Sender)
{
 AnsiString filter = qTaxList->DefaultFilter;

 if (listMode==1)
 {
     filter+=" and t.int_num<>0 ";
     qTaxList->DefaultFilter=filter;
     qTaxList->Filtered=true;
 }

 listMode = 0;
}
//---------------------------------------------------------------------------


void __fastcall TfTaxCorListFull::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;

    if (qTaxList->FieldByName("mmgg")->AsDateTime != ZeroTime)
        fPeriodSelect->FormShow(qTaxList->FieldByName("mmgg")->AsDateTime,qTaxList->FieldByName("mmgg")->AsDateTime);
    else
        fPeriodSelect->FormShow(mmgg,mmgg);

    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };

//   delete DBGrTax;
//   qTaxList->Close();
//   qTaxList->Open();
/*
   if (rez == mrOk)
   {
     qTaxList->ParamByName("startdt")->AsDateTime=fPeriodSelect->DateFrom;
     qTaxList->ParamByName("stopdt")->AsDateTime=fPeriodSelect->DateTo;
     qTaxList->ParamByName("all")->AsInteger=0;

     SetCaption("��������� ��������� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {
     qTaxList->ParamByName("all")->AsInteger=1;
     SetCaption("��������� ��������� ");
   }


   try
   {
    qTaxList->Open();
   }
   catch(...)
   {
    delete fPeriodSelect;
    return;
   }
*/

   if (rez == mrOk)
   {
//     qTaxList->Filtered=false;
     AnsiString filter = "t.mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and t.mmgg <= '"
       + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     if (listMode==0)
     {
      filter+=" and t.int_num<>0 ";
     }

     qTaxList->DefaultFilter=filter;
     qTaxList->Filtered=true;


     qTaxLines->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and mmgg <= '"
       + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     qTaxLines->Filtered=true;

//     qTaxList->Refresh();

     SetCaption("������������� ��������� ��������� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");

     delete fRepTaxCorLocal;

     if (fPeriodSelect->DateFrom < TDateTime(2014,3,1))
     {
       fRepTaxCorLocal = new TfRepTaxCor(this);
     }
     else
     {
       if (fPeriodSelect->DateFrom < TDateTime(2014,12,1))
         fRepTaxCorLocal = new TfRepTaxCor2014(this);
       else
       {
         if (fPeriodSelect->DateFrom < TDateTime(2015,1,1))
           fRepTaxCorLocal = new TfRepTaxCor2014_12(this);
         else
         {
           if (fPeriodSelect->DateFrom < TDateTime(2016,3,1))
              fRepTaxCorLocal = new TfRepTaxCor2015(this);
           else
              fRepTaxCorLocal = new TfRepTaxCor2016(this);
         }

       }
     }

    }
//   else
//   {
//     //qTaxList->Filtered=false;
//     qTaxList->DefaultFilter="";
//     qTaxList->Refresh();
//     SetCaption("������������� ��������� ��������� ");
//   }

//    delete fPeriodSelect;
//    ReBuildGrid();
};
//------------------------------------------------------------------------------
void __fastcall TfTaxCorListFull::TaxCorManual(TObject *Sender)
{
//  int id_tax=qTaxList->FieldByName("id_doc")->AsInteger;

  if (MessageDlg(" ������� �������������  ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TaxAllList(Sender);

  TWTDBGrid* Grid;
  Grid=((TMainForm*)MainForm)->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

  WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;
  ((TWTDoc *)(WAbonGrid->Owner))-> OnCloseQuery=AbonClose;

};
//--------------------------------------------------

void __fastcall TfTaxCorListFull::AbonAccept (TObject* Sender)
{
  abonent=WAbonGrid->Query->FieldByName("id")->AsInteger;

/*
  WPrefGrid = new TWTWinDBGrid(this, "aci_pref_tbl",false);
  WPrefGrid->SetCaption("��������");

  TWTTable* Table = WPrefGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WPrefGrid->AddColumn("id", "���", "��� ���� ��������");
  Field = WPrefGrid->AddColumn("Name", "��� ��������", "��� ��������");
  Field = WPrefGrid->AddColumn("Comment", "��������", "��������");

  WPrefGrid->DBGrid->FieldSource = WPrefGrid->DBGrid->Table->GetTField("id");
  WPrefGrid->DBGrid->StringDest = "1";
  WPrefGrid->DBGrid->Visible = true;
  WPrefGrid->DBGrid->OnAccept=PrefAccept;
  WPrefGrid->ShowAs("���� ��������");
  */
}
//---------------------------------------------------------------------
void __fastcall TfTaxCorListFull::AbonClose(System::TObject* Sender, bool &CanClose)
{
  WPrefGrid = new TWTWinDBGrid(this, "aci_pref_tbl",false);
  WPrefGrid->SetCaption("��������");

  TWTTable* Table = WPrefGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WPrefGrid->AddColumn("id", "���", "��� ���� ��������");
  Field = WPrefGrid->AddColumn("Name", "��� ��������", "��� ��������");
  Field = WPrefGrid->AddColumn("Comment", "��������", "��������");

  WPrefGrid->DBGrid->FieldSource = WPrefGrid->DBGrid->Table->GetTField("id");
  WPrefGrid->DBGrid->StringDest = "1";
  WPrefGrid->DBGrid->Visible = true;
  WPrefGrid->DBGrid->OnAccept=PrefAccept;
  WPrefGrid->ShowAs("���� ��������");
}
//---------------------------------------------------------------------


void __fastcall TfTaxCorListFull::PrefAccept (TObject* Sender)
{
  int pref=WPrefGrid->DBGrid->Table->FieldByName("id")->AsInteger;

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
//  ZQTax->Transaction->AutoCommit=false;



  ZQTax->Sql->Clear();
  ZQTax->Sql->Add("insert into acm_taxcorrection_tbl(id_client,id_pref,int_num) values ( :client, :pref ,0 );");
  ZQTax->Sql->Add("insert into acd_taxcorrection_tbl(id_doc) values ( currval('dcm_doc_seq') );");

   ZQTax->ParamByName("client")->AsInteger=abonent;
   ZQTax->ParamByName("pref")->AsInteger=pref;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

//   ZQTax->Transaction->Commit();
//   ZQTax->Transaction->AutoCommit=true;
//   ShowMessage("������������� �������");
   delete ZQTax;

   qTaxList->Refresh();
   qTaxLines->Refresh();

}
//----------------------------------------------------------------------
void __fastcall TfTaxCorListFull::NewCorStrInsert(TDataSet* DataSet)
{
 DataSet->FieldByName("id_doc")->AsInteger = qTaxList->FieldByName("id_doc")->AsInteger;
 DataSet->FieldByName("mmgg")->AsDateTime = qTaxList->FieldByName("mmgg")->AsDateTime;
}
//----------------------------------------------------------------------

void __fastcall TfTaxListFull::PostError(TDataSet *DataSet,
      EDatabaseError *E, TDataAction &Action)
{
    ShowMessage("������ "+E->Message.SubString(8,200));
    Action = daAbort;
}

//----------------------------------------------------------------------
void __fastcall TfTaxCorListFull::PostError(TDataSet *DataSet,
      EDatabaseError *E, TDataAction &Action)
{
    ShowMessage("������ "+E->Message.SubString(8,200));
    Action = daAbort;
}

//----------------------------------------------------------------------

void __fastcall TfTaxCorListFull::TaxCorToXML(TObject *Sender)
{
  if ( qTaxList->FieldByName("flag_reg")->AsInteger !=1 )
  {
   qTaxList->Edit();
   qTaxList->FieldByName("flag_reg")->AsInteger =1;
   qTaxList->Post();
  }

  int xml_num =  BuildXML( qTaxList->FieldByName("id_doc")->AsInteger);

  if ((xml_num!=0)&&(qTaxList->FieldByName("xml_num")->AsInteger !=xml_num))
  {
   qTaxList->Edit();
   qTaxList->FieldByName("xml_num")->AsInteger =xml_num;
   qTaxList->Post();

   ShowMessage("������������� ��������� ��������� � ����� "+xmlfilename);
  }

};
//------------------------------------------------------------------------------

int TfTaxCorListFull::BuildXML(int id_tax)
{
  TIcXMLDocument* doc;
  TIcXMLParser* parser;
  TIcXMLElement* root;
  TIcXMLElement* head;
  TIcXMLElement* body;
  TIcXMLElement* item;
  AnsiString sqlstr;

  TWTQuery *ZQTaxHeader = new  TWTQuery(this);

  // ^(.+) - ����� �-�� �������� � ������ ������
  // \\\\s - ������
  // (.) - ���� ����� ������
  // \\\\. - �����                  (���� ������������ )

   sqlstr="select t.reg_num,t.reg_date, t.int_num,t.xml_num,t.mmgg, t.tax_num,t.tax_date, \
   abon.id as abonid, t.id_pref, \
   CASE WHEN users.represent_name ~ '^(.+)\\\\s(.)\\\\.(.)\\\\.$' THEN \
     substr(trim(users.represent_name),length(users.represent_name)-3,4)||' '||substr(trim(users.represent_name),0,length(users.represent_name)-4) ELSE represent_name END as represent_name, \
   CASE WHEN (abonpar.flag_taxpay = 0) and (position('���������' in (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END) )=0) \
       THEN  (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END)||' ���������' \
       WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END::::varchar as abonname, \
   res.name as resname, \
   CASE WHEN abonpar.addr_main is NULL THEN abonpar.addr_tax ELSE CASE WHEN trim(coalesce(abonpar.addr_main,''))='' THEN abonpar.addr_tax ELSE  abonpar.addr_main||' / \n'||abonpar.addr_tax END END::::varchar as abonaddr, \
   abon.name as abonnamesh, \
   chpar.addr_tax||' / \n'||respar.addr_tax as resaddr, \
   abonpar.doc_num, abonpar.doc_dat, \
   CASE WHEN (abonpar.flag_taxpay = 1) THEN abonpar.tax_num ELSE '100000000000' END::::varchar as taxnum_abon, \
   abonpar.licens_num as SvidNum_abon, \
   abonpar.flag_taxpay,abon.code, abonpar.id_section, \
   respar.tax_num as taxnum_res,respar.licens_num as SvidNum_res, \
   abonpar.phone as abonphone,respar.phone as resphone, \
   t.value_tax,t.value, t.flag_reg, t.pay_date \
   from (select t1.*, td.cor_demand,td.cor_sum_20 from acm_taxcorrection_tbl as t1 left join acd_taxcorrection_tbl as td on (t1.id_doc = td.id_doc) \
   where (t1.id_doc = :doc) limit 1) as t \
   left join clm_position_tbl as users on (users.id = t.id_person), \
   clm_client_tbl as res left join clm_statecl_tbl as respar on (respar.id_client = res.id), \
   clm_client_tbl as abon left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id), \
   clm_client_tbl as chnoe left join clm_statecl_tbl as chpar on (chpar.id_client = chnoe.id) \
   where t.id_client = abon.id \
   and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <=t.mmgg  ) \
   and (res.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_res' limit 1) ) \
   and (chnoe.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_chnoe' limit 1) ); ";

  ZQTaxHeader->Sql->Clear();
  ZQTaxHeader->Sql->Add(sqlstr);
  ZQTaxHeader->ParamByName("doc")->AsInteger = id_tax;


  TWTQuery *ZQTaxLines = new  TWTQuery(this);

  sqlstr=" select t.id_pref, t.reason, ts.cor_demand,ts.cor_sum_20, ts.cor_sum_0, ts.cor_sum_free, \
   ts.cor_tax, ts.cor_tax_credit, ts.demand, ts.cor_tariff, ts.tariff, ts.unit, unit_kod, uktzed  \
   from acd_taxcorrection_tbl as ts join acm_taxcorrection_tbl as t on (t.id_doc = ts.id_doc) \
   where (ts.id_doc = :doc); ";

  ZQTaxLines->Sql->Clear();
  ZQTaxLines->Sql->Add(sqlstr);
  ZQTaxLines->ParamByName("doc")->AsInteger = id_tax;

  try
  {
   ZQTaxHeader->Open();
   ZQTaxLines->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTaxHeader->Close();
   ZQTaxLines->Close();
   delete ZQTaxHeader;
   delete ZQTaxLines;
   return 0;
  }
  ZQTaxHeader->First();


  Word mmgg_year;
  Word mmgg_month;
  Word mmgg_day;

  TDateTime tax_mmgg = ZQTaxHeader->FieldByName("mmgg")->AsDateTime;
  DecodeDate(tax_mmgg,mmgg_year,mmgg_month,mmgg_day);

  AnsiString doc_version;

  if ((mmgg_year>2016)||(mmgg_year=2016)&&(mmgg_month>=3))
  {
    return BuildXML2016( id_tax);
  };

  if (mmgg_year>=2015)
     doc_version="7";
  else
     doc_version="6";


  int xml_num=0;
  if (ZQTaxHeader->FieldByName("xml_num")->AsInteger==0)
  {
   TWTQuery * ZQTax = new TWTQuery(Application);


   ZQTax->Sql->Clear();
   ZQTax->Sql->Add("select max(xml_num) as lastnum from acm_taxcorrection_tbl where mmgg = :mmgg;");
   ZQTax->ParamByName("mmgg")->AsDateTime=ZQTaxHeader->FieldByName("mmgg")->AsDateTime;

   try
   {
    ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    delete ZQTaxHeader;
    delete ZQTaxLines;

    return 0;
   }
   xml_num= ZQTax->FieldByName("lastnum")->AsInteger+1;
   delete ZQTax;

  }
  else
  {
    xml_num =ZQTaxHeader->FieldByName("xml_num")->AsInteger;
  }
  char oldDecimalSeparator = DecimalSeparator;
  DecimalSeparator='.';


  parser = new TIcXMLParser(this);
  doc = new TIcXMLDocument();
  doc->AssignParser(parser);
  doc->SetEncoding("windows-1251");

  root = doc->CreateElement("DECLAR");
  doc->SetDocumentElement(root);

  root->SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
  root->SetAttribute("xsi:noNamespaceSchemaLocation","J120120"+doc_version+".xsd");

  head = doc->CreateElement("DECLARHEAD");
  root->AppendChild(head);

  item = doc->CreateElement("TIN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("22815333"));

  item = doc->CreateElement("C_DOC");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("J12"));

  item = doc->CreateElement("C_DOC_SUB");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("012"));

  item = doc->CreateElement("C_DOC_VER");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(doc_version));

  item = doc->CreateElement("C_DOC_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0"));

  item = doc->CreateElement("C_DOC_CNT");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(xml_num));

  item = doc->CreateElement("C_REG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("25"));
  item->SetCharData(doc->CreateTextNode("28"));

  item = doc->CreateElement("C_RAJ");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("26"));
  item->SetCharData(doc->CreateTextNode("10"));

  item = doc->CreateElement("PERIOD_MONTH");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_month));

  item = doc->CreateElement("PERIOD_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("PERIOD_YEAR");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_year));

  item = doc->CreateElement("C_STI_ORIG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("2526"));
  item->SetCharData(doc->CreateTextNode("2810"));

  item = doc->CreateElement("C_DOC_STAN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("LINKED_DOCS");
  head->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("D_FILL");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatDateTime ("ddmmyyyy",Now())));

  item = doc->CreateElement("SOFTWARE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("Energo"));

  body = doc->CreateElement("DECLARBODY");
  root->AppendChild(body);

  if (doc_version =="6")
  {
   item = doc->CreateElement("HORIG");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode("1"));

   item = doc->CreateElement("HEL");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  item = doc->CreateElement("HERPN");
  body->AppendChild(item);

  if (ZQTaxHeader->FieldByName("value")->AsFloat < 0 )
     item->SetCharData(doc->CreateTextNode("1"));
  else
     item->SetAttribute("xsi:nil","true");

  if (doc_version =="7")
  {
   item = doc->CreateElement("H01");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  item = doc->CreateElement("HORIG1");
  body->AppendChild(item);
    if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
    item->SetAttribute("xsi:nil","true");
  else
      item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("HTYPR");
  body->AppendChild(item);
   if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
   item->SetAttribute("xsi:nil","true");
   else
     item->SetCharData(doc->CreateTextNode("02"));

  AnsiString StaxNum =ZQTaxHeader->FieldByName("int_num")->AsString;
  item = doc->CreateElement("HNUM");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum));

  item = doc->CreateElement("HNUM1");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  AnsiString StaxNum2=(ZQTaxHeader->FieldByName("reg_num")->AsString).SubString(AnsiPos("/",ZQTaxHeader->FieldByName("reg_num")->AsString)+1,3);
  int len =StaxNum2.Length();
  for(int i = 0; i< (3-len); i++  ) {StaxNum2 = ""+StaxNum2;}

  item = doc->CreateElement("HNUM2");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum2));

  AnsiString StaxDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("reg_date")->AsDateTime);
  item = doc->CreateElement("HFILL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxDate));

  AnsiString SNNDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("tax_date")->AsDateTime);
  item = doc->CreateElement("HPODFILL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SNNDate));

  AnsiString SNNNum =(ZQTaxHeader->FieldByName("tax_num")->AsString).SubString(1,AnsiPos("/",ZQTaxHeader->FieldByName("tax_num")->AsString)-1);
  item = doc->CreateElement("HPODNUM");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SNNNum));

  item = doc->CreateElement("HPODNUM1");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  AnsiString SNNNum2=(ZQTaxHeader->FieldByName("tax_num")->AsString).SubString(AnsiPos("/",ZQTaxHeader->FieldByName("tax_num")->AsString)+1,3);

  item = doc->CreateElement("HPODNUM2");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SNNNum2));

  AnsiString SdocDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("doc_dat")->AsDateTime);
  item = doc->CreateElement("H01G1D");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SdocDate));

  item = doc->CreateElement("H01G2S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("doc_num")->AsString.Trim()));

  item = doc->CreateElement("HNAMESEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resname")->AsString));

  item = doc->CreateElement("HNAMEBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonname")->AsString));

  item = doc->CreateElement("HKSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_res")->AsString.Trim()));

  item = doc->CreateElement("HKBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_abon")->AsString.Trim()));

  item = doc->CreateElement("HLOCSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resaddr")->AsString));

  item = doc->CreateElement("HLOCBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonaddr")->AsString));


   AnsiString resPhone =ZQTaxHeader->FieldByName("resphone")->AsString.Trim();

   TReplaceFlags flags ;
   flags <<rfReplaceAll;

   resPhone = StringReplace(resPhone,"-","",flags);
   resPhone = StringReplace(resPhone,"(","",flags);
   resPhone = StringReplace(resPhone,")","",flags);

   if (AnsiPos("/",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos("/",resPhone )-1);
   if (AnsiPos(",",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(",",resPhone )-1);
   if (AnsiPos(";",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(";",resPhone )-1);
   if (AnsiPos(".",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(".",resPhone )-1);
   if (AnsiPos(" ",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(" ",resPhone )-1);

   resPhone = resPhone.SubString(1, 10).Trim();

  item = doc->CreateElement("HTELSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(resPhone));

   AnsiString abonPhone =ZQTaxHeader->FieldByName("abonphone")->AsString.Trim();

   abonPhone = StringReplace(abonPhone,"-","",flags);
   abonPhone = StringReplace(abonPhone,"(","",flags);
   abonPhone = StringReplace(abonPhone,")","",flags);

   if (AnsiPos("/",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos("/",abonPhone)-1);
   if (AnsiPos(",",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(",",abonPhone)-1);
   if (AnsiPos(";",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(";",abonPhone)-1);
   if (AnsiPos(".",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(".",abonPhone)-1);
   if (AnsiPos(" ",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(" ",abonPhone)-1);

   abonPhone = abonPhone.SubString(1, 10).Trim();

  item = doc->CreateElement("HTELBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(abonPhone));

  AnsiString contract;
  AnsiString taxtext;
       /*
     if ((ZQTaxHeader->FieldByName("id_section")->AsInteger  ==206)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==207)||
         (ZQTaxHeader->FieldByName("id_section")->AsInteger  ==205)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==208))
     {
       contract="������ ��� ������������ ����������� ����㳺�";

       item = doc->CreateElement("H01G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));

       item = doc->CreateElement("H01G2D");
       body->AppendChild(item);
       item->SetAttribute("xsi:nil","true");

       item = doc->CreateElement("H01G3S");
       body->AppendChild(item);
       item->SetAttribute("xsi:nil","true");

       if ((ZQTaxHeader->FieldByName("id_section")->AsInteger  ==206)||(ZQTaxHeader->FieldByName("id_section")->AsInteger  ==207))
       {
         taxtext = ZQTaxHeader->FieldByName("taxtext")->AsString;
       }
       else
       {
         taxtext = "������ � ��������� �������";
       }

     }
     else
     {
     */
       contract="������ ��� ���������� ���������� ����㳿";
       taxtext = "������ � ��������� �������";

       item = doc->CreateElement("H02G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));


       item = doc->CreateElement("H02G2D");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(SdocDate));

       item = doc->CreateElement("H02G3S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("doc_num")->AsString.Trim()));

    // }
/*
  if (ZQTaxHeader->FieldByName("pay_date")->IsNull)
  {
   item = doc->CreateElement("H04G1D");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }
  else
  {
   AnsiString SPayDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("pay_date")->AsDateTime);
   item = doc->CreateElement("H04G1D");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(SPayDate));
  }

  item = doc->CreateElement("H03G1S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(taxtext));
*/
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG1D");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(StaxDate));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG2S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("reason")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG3S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode("�/��."));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("uktzed")->AsString));

   ZQTaxLines->Next();
  }


  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit")->AsString));

   ZQTaxLines->Next();
  }

  if (doc_version=="7")
  {
   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG105_2S");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit_kod")->AsString));

    ZQTaxLines->Next();
   }
  }


  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG5");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("cor_demand")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG6");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("tariff")->AsString));

   ZQTaxLines->Next();
  }

  double total_cor_sum_20=0;
  double total_cor_tax=0;

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("cor_sum_20")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG9");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxLines->FieldByName("cor_sum_20")->AsFloat) ));

    total_cor_sum_20 = total_cor_sum_20+ZQTaxLines->FieldByName("cor_sum_20")->AsFloat;
   }
   total_cor_tax = total_cor_tax+ZQTaxLines->FieldByName("cor_tax")->AsFloat;
   ZQTaxLines->Next();
  }

/*
  double total_sum8=0;
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("sum_val8")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG8");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("sum_val8")->AsString));
    total_sum8 = total_sum8+ZQTaxLines->FieldByName("sum_val8")->AsFloat;
   }
   ZQTaxLines->Next();
  }
*/
  if(total_cor_sum_20!=0)
  {
   item = doc->CreateElement("R01G9");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_cor_sum_20)));
  }
  else
  {
   item = doc->CreateElement("R01G9");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }
/*
  if(total_sum8!=0)
  {
   item = doc->CreateElement("R01G8");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_sum8)));
  }
  else
  {
   item = doc->CreateElement("R01G8");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }
*/
  item = doc->CreateElement("R01G10");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G11");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R01G111");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("R02G9");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_cor_tax)));

  item = doc->CreateElement("R02G111");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0.00"));

/*
  item = doc->CreateElement("H10G1S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxDate));
*/
  item = doc->CreateElement("H10G2S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("represent_name")->AsString));

  ZQTaxHeader->Close();
  ZQTaxLines->Close();

  AnsiString Sxml_num=IntToStr(xml_num);
  len =Sxml_num.Length();
  for(int i = 0; i< (7-len); i++  ) {Sxml_num = "0"+Sxml_num;}

  AnsiString Smonth = IntToStr(mmgg_month);
  if (mmgg_month <10) Smonth = "0"+Smonth;
  AnsiString Syear = IntToStr(mmgg_year);

  xmlfilename =ExtractFilePath(Application->ExeName)+"xml\\";

//  xmlfilename=xmlfilename+"2526"+"0022815333"+"J120120"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2526"+".xml";
  xmlfilename=xmlfilename+"2810"+"0022815333"+"J120120"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2810"+".xml";

  doc->Write(xmlfilename);

  //ShowMessage("��������� ��������� ��������� � ����� "+xmlfilename);

  delete doc;
  delete parser;
  DecimalSeparator = oldDecimalSeparator;

  delete ZQTaxHeader;
  delete ZQTaxLines;

  return xml_num;
}
//------------------------------------------------------------------------------
int TfTaxCorListFull::BuildXML2016(int id_tax)
{
  TIcXMLDocument* doc;
  TIcXMLParser* parser;
  TIcXMLElement* root;
  TIcXMLElement* head;
  TIcXMLElement* body;
  TIcXMLElement* item;
  AnsiString sqlstr;

  TWTQuery *ZQTaxHeader = new  TWTQuery(this);

  // ^(.+) - ����� �-�� �������� � ������ ������
  // \\\\s - ������
  // (.) - ���� ����� ������
  // \\\\. - �����                  (���� ������������ )

   sqlstr="select t.reg_num,t.reg_date, t.int_num,t.xml_num,t.mmgg, t.tax_num,t.tax_date, \
   abon.id as abonid, t.id_pref, \
   CASE WHEN users.represent_name ~ '^(.+)\\\\s(.)\\\\.(.)\\\\.$' THEN \
     substr(trim(users.represent_name),length(users.represent_name)-3,4)||' '||substr(trim(users.represent_name),0,length(users.represent_name)-4) ELSE represent_name END as represent_name, \
   CASE WHEN (abonpar.flag_taxpay = 0) and (position('���������' in (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END) )=0) \
       THEN  (CASE WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END)||' ���������' \
       WHEN coalesce(abon.add_name,'')<>'' THEN abon.add_name  ELSE abon.name END::::varchar as abonname, \
   res.name as resname, \
   CASE WHEN abonpar.addr_main is NULL THEN abonpar.addr_tax ELSE CASE WHEN trim(coalesce(abonpar.addr_main,''))='' THEN abonpar.addr_tax ELSE  abonpar.addr_main||' / \n'||abonpar.addr_tax END END::::varchar as abonaddr, \
   abon.name as abonnamesh, \
   chpar.addr_tax||' / \n'||respar.addr_tax as resaddr, \
   abonpar.doc_num, abonpar.doc_dat, abonpar.filial_num, users.inn, \
   CASE WHEN (abonpar.flag_taxpay = 1) THEN abonpar.tax_num ELSE '100000000000' END::::varchar as taxnum_abon, \
   abonpar.licens_num as SvidNum_abon, \
   abonpar.flag_taxpay,abon.code, abonpar.id_section, \
   respar.tax_num as taxnum_res,respar.licens_num as SvidNum_res, \
   abonpar.phone as abonphone,respar.phone as resphone, \
   t.value_tax,t.value, t.flag_reg, t.pay_date \
   from (select t1.*, td.cor_demand,td.cor_sum_20 from acm_taxcorrection_tbl as t1 left join acd_taxcorrection_tbl as td on (t1.id_doc = td.id_doc) \
   where (t1.id_doc = :doc) limit 1) as t \
   left join clm_position_tbl as users on (users.id = t.id_person), \
   clm_client_tbl as res left join clm_statecl_tbl as respar on (respar.id_client = res.id), \
   clm_client_tbl as abon left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id), \
   clm_client_tbl as chnoe left join clm_statecl_tbl as chpar on (chpar.id_client = chnoe.id) \
   where t.id_client = abon.id \
   and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <=t.mmgg  ) \
   and (res.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_res' limit 1) ) \
   and (chnoe.id = (select value_ident::::int from syi_sysvars_tbl where ident='id_chnoe' limit 1) ); ";

  ZQTaxHeader->Sql->Clear();
  ZQTaxHeader->Sql->Add(sqlstr);
  ZQTaxHeader->ParamByName("doc")->AsInteger = id_tax;


  TWTQuery *ZQTaxLines = new  TWTQuery(this);

  sqlstr=" select t.id_pref, t.reason, ts.cor_demand,ts.cor_sum_20, ts.cor_sum_0, ts.cor_sum_free, ts.line_no, \
   ts.cor_tax, ts.cor_tax_credit, ts.demand, ts.cor_tariff, ts.tariff, ts.unit, unit_kod, uktzed  \
   from acd_taxcorrection_tbl as ts join acm_taxcorrection_tbl as t on (t.id_doc = ts.id_doc) \
   where (ts.id_doc = :doc); ";

  ZQTaxLines->Sql->Clear();
  ZQTaxLines->Sql->Add(sqlstr);
  ZQTaxLines->ParamByName("doc")->AsInteger = id_tax;

  try
  {
   ZQTaxHeader->Open();
   ZQTaxLines->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQTaxHeader->Close();
   ZQTaxLines->Close();
   delete ZQTaxHeader;
   delete ZQTaxLines;
   return 0;
  }
  ZQTaxHeader->First();


  Word mmgg_year;
  Word mmgg_month;
  Word mmgg_day;

  TDateTime tax_mmgg = ZQTaxHeader->FieldByName("mmgg")->AsDateTime;
  DecodeDate(tax_mmgg,mmgg_year,mmgg_month,mmgg_day);

  AnsiString doc_version;

  if (((mmgg_year==2017)&&(mmgg_month>=3))||(mmgg_year>2017))
     doc_version="9";
  else
     doc_version="8";


  int xml_num=0;
  if (ZQTaxHeader->FieldByName("xml_num")->AsInteger==0)
  {
   TWTQuery * ZQTax = new TWTQuery(Application);


   ZQTax->Sql->Clear();
   ZQTax->Sql->Add("select max(xml_num) as lastnum from acm_taxcorrection_tbl where mmgg = :mmgg;");
   ZQTax->ParamByName("mmgg")->AsDateTime=ZQTaxHeader->FieldByName("mmgg")->AsDateTime;

   try
   {
    ZQTax->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    delete ZQTaxHeader;
    delete ZQTaxLines;

    return 0;
   }
   xml_num= ZQTax->FieldByName("lastnum")->AsInteger+1;
   delete ZQTax;

  }
  else
  {
    xml_num =ZQTaxHeader->FieldByName("xml_num")->AsInteger;
  }
  char oldDecimalSeparator = DecimalSeparator;
  DecimalSeparator='.';


  parser = new TIcXMLParser(this);
  doc = new TIcXMLDocument();
  doc->AssignParser(parser);
  doc->SetEncoding("windows-1251");

  root = doc->CreateElement("DECLAR");
  doc->SetDocumentElement(root);

  root->SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
  root->SetAttribute("xsi:noNamespaceSchemaLocation","J120120"+doc_version+".xsd");

  head = doc->CreateElement("DECLARHEAD");
  root->AppendChild(head);

  item = doc->CreateElement("TIN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("22815333"));

  item = doc->CreateElement("C_DOC");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("J12"));

  item = doc->CreateElement("C_DOC_SUB");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("012"));

  item = doc->CreateElement("C_DOC_VER");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(doc_version));

  item = doc->CreateElement("C_DOC_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0"));

  item = doc->CreateElement("C_DOC_CNT");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(xml_num));

  item = doc->CreateElement("C_REG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("25"));
  item->SetCharData(doc->CreateTextNode("28"));

  item = doc->CreateElement("C_RAJ");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("26"));
  item->SetCharData(doc->CreateTextNode("10"));

  item = doc->CreateElement("PERIOD_MONTH");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_month));

  item = doc->CreateElement("PERIOD_TYPE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("PERIOD_YEAR");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(mmgg_year));

  item = doc->CreateElement("C_STI_ORIG");
  head->AppendChild(item);
//  item->SetCharData(doc->CreateTextNode("2526"));
  item->SetCharData(doc->CreateTextNode("2810"));

  item = doc->CreateElement("C_DOC_STAN");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("LINKED_DOCS");
  head->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("D_FILL");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(FormatDateTime ("ddmmyyyy",Now())));

  item = doc->CreateElement("SOFTWARE");
  head->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("Energo"));

  body = doc->CreateElement("DECLARBODY");
  root->AppendChild(body);

  item = doc->CreateElement("HERPN");
  body->AppendChild(item);

  if (ZQTaxHeader->FieldByName("value")->AsFloat < 0 )
     item->SetCharData(doc->CreateTextNode("1"));
  else
     item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("HERPN0");
  body->AppendChild(item);

  if (ZQTaxHeader->FieldByName("value")->AsFloat >= 0 )
     item->SetCharData(doc->CreateTextNode("1"));
  else
     item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("HORIG1");
  body->AppendChild(item);
    if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
    item->SetAttribute("xsi:nil","true");
  else
      item->SetCharData(doc->CreateTextNode("1"));

  item = doc->CreateElement("HTYPR");
  body->AppendChild(item);
   if  (ZQTaxHeader->FieldByName("taxNum_abon")->AsString!="100000000000")
   item->SetAttribute("xsi:nil","true");
   else
     item->SetCharData(doc->CreateTextNode("02"));

  item = doc->CreateElement("R03G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  item = doc->CreateElement("H03");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("1"));

  //------------------------------------------------
  AnsiString StaxNum =ZQTaxHeader->FieldByName("int_num")->AsString;
  item = doc->CreateElement("HNUM");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum));

  item = doc->CreateElement("HNUM1");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  AnsiString StaxNum2=(ZQTaxHeader->FieldByName("reg_num")->AsString).SubString(AnsiPos("/",ZQTaxHeader->FieldByName("reg_num")->AsString)+1,3);
  int len =StaxNum2.Length();
  for(int i = 0; i< (3-len); i++  ) {StaxNum2 = ""+StaxNum2;}

  item = doc->CreateElement("HNUM2");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxNum2));

  AnsiString StaxDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("reg_date")->AsDateTime);
  item = doc->CreateElement("HFILL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxDate));

  AnsiString SNNDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("tax_date")->AsDateTime);
  item = doc->CreateElement("HPODFILL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SNNDate));

  AnsiString SNNNum =(ZQTaxHeader->FieldByName("tax_num")->AsString).SubString(1,AnsiPos("/",ZQTaxHeader->FieldByName("tax_num")->AsString)-1);
  item = doc->CreateElement("HPODNUM");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SNNNum));

  item = doc->CreateElement("HPODNUM1");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");

  AnsiString SNNNum2=(ZQTaxHeader->FieldByName("tax_num")->AsString).SubString(AnsiPos("/",ZQTaxHeader->FieldByName("tax_num")->AsString)+1,3);

  item = doc->CreateElement("HPODNUM2");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SNNNum2));



  /*
  AnsiString SdocDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("doc_dat")->AsDateTime);
  item = doc->CreateElement("H01G1D");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(SdocDate));

  item = doc->CreateElement("H01G2S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("doc_num")->AsString.Trim()));
*/
  item = doc->CreateElement("HNAMESEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resname")->AsString));

  item = doc->CreateElement("HNAMEBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonname")->AsString));

  item = doc->CreateElement("HKSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_res")->AsString.Trim()));

  item = doc->CreateElement("HKBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("taxNum_abon")->AsString.Trim()));

  item = doc->CreateElement("HFBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("filial_num")->AsString.Trim()));

/*
  item = doc->CreateElement("HLOCSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("resaddr")->AsString));

  item = doc->CreateElement("HLOCBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("abonaddr")->AsString));


   AnsiString resPhone =ZQTaxHeader->FieldByName("resphone")->AsString.Trim();

   TReplaceFlags flags ;
   flags <<rfReplaceAll;

   resPhone = StringReplace(resPhone,"-","",flags);
   resPhone = StringReplace(resPhone,"(","",flags);
   resPhone = StringReplace(resPhone,")","",flags);

   if (AnsiPos("/",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos("/",resPhone )-1);
   if (AnsiPos(",",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(",",resPhone )-1);
   if (AnsiPos(";",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(";",resPhone )-1);
   if (AnsiPos(".",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(".",resPhone )-1);
   if (AnsiPos(" ",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(" ",resPhone )-1);

   resPhone = resPhone.SubString(1, 10).Trim();

  item = doc->CreateElement("HTELSEL");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(resPhone));

   AnsiString abonPhone =ZQTaxHeader->FieldByName("abonphone")->AsString.Trim();

   abonPhone = StringReplace(abonPhone,"-","",flags);
   abonPhone = StringReplace(abonPhone,"(","",flags);
   abonPhone = StringReplace(abonPhone,")","",flags);

   if (AnsiPos("/",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos("/",abonPhone)-1);
   if (AnsiPos(",",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(",",abonPhone)-1);
   if (AnsiPos(";",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(";",abonPhone)-1);
   if (AnsiPos(".",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(".",abonPhone)-1);
   if (AnsiPos(" ",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(" ",abonPhone)-1);

   abonPhone = abonPhone.SubString(1, 10).Trim();

  item = doc->CreateElement("HTELBUY");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(abonPhone));
  */
  AnsiString contract;
  AnsiString taxtext;
       /*
       contract="������ ��� ���������� ���������� ����㳿";
       taxtext = "������ � ��������� �������";

       item = doc->CreateElement("H02G1S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(contract));


       item = doc->CreateElement("H02G2D");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(SdocDate));

       item = doc->CreateElement("H02G3S");
       body->AppendChild(item);
       item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("doc_num")->AsString.Trim()));
       */
    // }
/*
  if (ZQTaxHeader->FieldByName("pay_date")->IsNull)
  {
   item = doc->CreateElement("H04G1D");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }
  else
  {
   AnsiString SPayDate =FormatDateTime ("ddmmyyyy",ZQTaxHeader->FieldByName("pay_date")->AsDateTime);
   item = doc->CreateElement("H04G1D");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(SPayDate));
  }

  item = doc->CreateElement("H03G1S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(taxtext));
*/
  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG001");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("line_no")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG2S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("reason")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG3S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode("�/��."));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);

   if (((ZQTaxHeader->FieldByName("id_pref")->AsInteger !=20)&&(doc_version=="9"))||(doc_version=="8"))
     item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("uktzed")->AsString));
   else
    item->SetAttribute("xsi:nil","true");

   ZQTaxLines->Next();
  }

  if (doc_version=="9")
  {
   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG32");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetAttribute("xsi:nil","true");

    ZQTaxLines->Next();
   }

   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG33");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);

    if ((ZQTaxHeader->FieldByName("id_pref")->AsInteger ==20)&&(doc_version=="9"))
      item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("uktzed")->AsString));
    else
     item->SetAttribute("xsi:nil","true");

    ZQTaxLines->Next();
   }

  }



  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG4S");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit")->AsString));

   ZQTaxLines->Next();
  }

   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG105_2S");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("unit_kod")->AsString));

    ZQTaxLines->Next();
   }



  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG5");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("cor_demand")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG6");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("tariff")->AsString));

   ZQTaxLines->Next();
  }


  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG7");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("cor_tariff")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG8");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode(ZQTaxLines->FieldByName("demand")->AsString));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG008");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetCharData(doc->CreateTextNode("20"));

   ZQTaxLines->Next();
  }

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   item = doc->CreateElement("RXXXXG009");
   body->AppendChild(item);
   item->SetAttribute("ROWNUM",i);
   item->SetAttribute("xsi:nil","true");

   ZQTaxLines->Next();
  }



  double total_cor_sum_20=0;
  double total_cor_tax=0;

  ZQTaxLines->First();
  for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
  {
   if (ZQTaxLines->FieldByName("cor_sum_20")->AsFloat !=0)
   {
    item = doc->CreateElement("RXXXXG010");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",ZQTaxLines->FieldByName("cor_sum_20")->AsFloat) ));

    total_cor_sum_20 = total_cor_sum_20+ZQTaxLines->FieldByName("cor_sum_20")->AsFloat;
   }
   total_cor_tax = total_cor_tax+ZQTaxLines->FieldByName("cor_tax")->AsFloat;
   ZQTaxLines->Next();
  }

  if (doc_version=="9")
  {
   ZQTaxLines->First();
   for(int i = 1; i<= ZQTaxLines->RecordCount;i++)
   {
    item = doc->CreateElement("RXXXXG011");
    body->AppendChild(item);
    item->SetAttribute("ROWNUM",i);
    item->SetAttribute("xsi:nil","true");

    ZQTaxLines->Next();
   }
  }  

  if(total_cor_sum_20!=0)
  {
   item = doc->CreateElement("R01G9");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_cor_sum_20)));
  }
  else
  {
   item = doc->CreateElement("R01G9");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");
  }

  if(total_cor_tax!=0)
  {
   item = doc->CreateElement("R001G03");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_cor_tax)));

   item = doc->CreateElement("R02G9");
   body->AppendChild(item);
   item->SetCharData(doc->CreateTextNode(FormatFloat("0.00",total_cor_tax)));

  }
  else
  {
   item = doc->CreateElement("R001G03");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");

   item = doc->CreateElement("R02G9");
   body->AppendChild(item);
   item->SetAttribute("xsi:nil","true");

  }




  item = doc->CreateElement("R02G111");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0.00"));

  item = doc->CreateElement("R01G111");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0.00"));

  item = doc->CreateElement("R006G03");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0.00"));

  item = doc->CreateElement("R007G03");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0.00"));

  item = doc->CreateElement("R01G11");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode("0.00"));

/*
  item = doc->CreateElement("H10G1S");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(StaxDate));
*/
  item = doc->CreateElement("HBOS");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("represent_name")->AsString));

  item = doc->CreateElement("HKBOS");
  body->AppendChild(item);
  item->SetCharData(doc->CreateTextNode(ZQTaxHeader->FieldByName("inn")->AsString));

  item = doc->CreateElement("R003G10S");
  body->AppendChild(item);
  item->SetAttribute("xsi:nil","true");


  ZQTaxHeader->Close();
  ZQTaxLines->Close();

  AnsiString Sxml_num=IntToStr(xml_num);
  len =Sxml_num.Length();
  for(int i = 0; i< (7-len); i++  ) {Sxml_num = "0"+Sxml_num;}

  AnsiString Smonth = IntToStr(mmgg_month);
  if (mmgg_month <10) Smonth = "0"+Smonth;
  AnsiString Syear = IntToStr(mmgg_year);

  xmlfilename =ExtractFilePath(Application->ExeName)+"xml\\";

//  xmlfilename=xmlfilename+"2526"+"0022815333"+"J120120"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2526"+".xml";
  xmlfilename=xmlfilename+"2810"+"0022815333"+"J120120"+doc_version+"1"+"00"+Sxml_num+"1"+Smonth+Syear+"2810"+".xml";

  doc->Write(xmlfilename);

  //ShowMessage("��������� ��������� ��������� � ����� "+xmlfilename);

  delete doc;
  delete parser;
  DecimalSeparator = oldDecimalSeparator;

  delete ZQTaxHeader;
  delete ZQTaxLines;

  return xml_num;
}
//------------------------------------------------------------------------------

void __fastcall TfTaxCorListFull::TaxCorToXMLAll(TObject *Sender)
{
  int xml_num;

  if (MessageDlg(" ������������ XML ����� ��� ���� ������������� ��������� ���������?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  qTaxList->First();
  for (int i=0;i<qTaxList->RecordCount;i++)
  {

//   if ((qTaxList->FieldByName("value_tax")->AsFloat >=10000 )&&(qTaxList->FieldByName("flag_taxpay")->AsInteger==1))
   if ((qTaxList->FieldByName("flag_reg")->AsInteger == 0 )&&(qTaxList->FieldByName("int_num")->AsInteger!=0))
   {

//    if (qTaxList->FieldByName("flag_reg")->AsInteger !=1)
//    {
     qTaxList->Edit();
     qTaxList->FieldByName("flag_reg")->AsInteger =1;
//     qTaxList->FieldByName("flag_transmis")->AsInteger =1;
     qTaxList->Post();
//    }

    xml_num  =  BuildXML( qTaxList->FieldByName("id_doc")->AsInteger);

    if ((xml_num!=0)&&(qTaxList->FieldByName("xml_num")->AsInteger !=xml_num))
    {
     qTaxList->Edit();
     qTaxList->FieldByName("xml_num")->AsInteger =xml_num;
     qTaxList->Post();
    }
   }

   qTaxList->Next();
  }

  ShowMessage("��������� ��������� ��������� � ����� "+ExtractFilePath(Application->ExeName)+"xml\\");

};
//----------------------------------------------------------------------
void __fastcall TfTaxCorListFull::TaxToXML(TObject *Sender)
{

  int f =0;
  TfTaxListFull * fTaxListFull;

  for(int i = ((TMainForm*)(Application->MainForm))->MDIChildCount-1; i >= 0; i--)
  {
   if (((TMainForm*)(Application->MainForm))->MDIChildren[i]->Name == "TaxListFull")
   {
     f=1;
     fTaxListFull =(TfTaxListFull *)(((TMainForm*)(Application->MainForm))->MDIChildren[i]);
   }
  }

  if (f==0)
  {
   fTaxListFull=new TfTaxListFull(Application);

   fTaxListFull->ShowAs("������ ��������� ���������");
   fTaxListFull->ID="������ ��������� ���������";
   fTaxListFull->ShowData();
  }
  //-----------------------------------------------------------

  int xml_num =  fTaxListFull->BuildXML( qTaxList->FieldByName("id_tax")->AsInteger);


  if (xml_num!=0)
  {

   TWTQuery * ZQTax = new TWTQuery(Application);

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add("update acm_tax_tbl set flag_reg = 1, xml_num = :num where id_doc = :doc;");

   ZQTax->ParamByName("num")->AsInteger = xml_num;
   ZQTax->ParamByName("doc")->AsInteger = qTaxList->FieldByName("id_tax")->AsInteger;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
   }

   qTaxList->Refresh();
   delete ZQTax;

   ShowMessage("��������� ��������� ��������� � ����� "+fTaxListFull->xmlfilename);
  }

};
//----------------------------------------------------------------------

