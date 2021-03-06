//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "fTaxPrint.h"
#include "fTaxListAll.h"
#include "fTaxCorPrint.h"
#include "Main.h"
#include "fEdTaxParam.h"
#include "SysUser.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------
#define WinName  "��������� ��������� "

void _fastcall TMainForm::ClientTaxList(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
    AnsiString NameCl=" ";
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  if (((TMainForm*)(Application->MainForm))->InterTaxCliTable!=NULL)
   { AnsiString ee=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsString;
     int ii=StrToInt(ee);
     NameCl=NameCl+GetNameFromBase("clm_client_tbl","name",ii);

   };

  bool read_only =true;

  if(CheckLevelStrong("������ ��������� ���������-��������������")!=0)
  {
    read_only=false;
  }


  TWTDoc *DocTax=new TWTDoc(this,"");

  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
  BtnPrint->OnClick=ClientTaxPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;

  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption=" ��������������� ";
  BtnRebuild->OnClick=TaxRebuild;
  BtnRebuild->Width=100;
  BtnRebuild->Top=2;
  BtnRebuild->Left=200;
  BtnRebuild->Enabled= !read_only;
/*
  TButton *BtnRebuild1=new TButton(this);
  BtnRebuild1->Caption=" �������� 1 ������";
  BtnRebuild1->OnClick=TaxRebuild1;
  BtnRebuild1->Width=120;
  BtnRebuild1->Top=2;
  BtnRebuild1->Left=200;
//  BtnRebuild1->Enabled= !read_only;
  BtnRebuild1->Enabled= false;

  TButton *BtnRebuild2=new TButton(this);
  BtnRebuild2->Caption=" �������� 2 ������";
  BtnRebuild2->OnClick=TaxRebuild2;
  BtnRebuild2->Width=120;
  BtnRebuild2->Top=2;
  BtnRebuild2->Left=200;
//  BtnRebuild2->Enabled= !read_only;
  BtnRebuild2->Enabled= false;
*/
  TButton *BtnRebuild3=new TButton(this);
  BtnRebuild3->Caption=" �������� �����";
  BtnRebuild3->OnClick=TaxRebuild3;
  BtnRebuild3->Width=150;
  BtnRebuild3->Top=2;
  BtnRebuild3->Left=200;
  BtnRebuild3->Enabled= !read_only;


  TButton *BtnDel=new TButton(this);
  BtnDel->Caption=" ������� ";
  BtnDel->OnClick=TaxDelete;
  BtnDel->Width=100;
  BtnDel->Top=2;
  BtnDel->Left=600;
  BtnDel->Enabled= !read_only;

  TButton *BtnCopy=new TButton(this);
  BtnCopy->Caption="����� �������������";
  BtnCopy->OnClick=TaxCopyToNoPay;
  BtnCopy->Width=120;
  BtnCopy->Top=2;
  BtnCopy->Left=800;
  BtnCopy->Enabled= !read_only;


  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=120;
  BtnEmp->Top=2;
  BtnEmp->Left=714;


  TWTPanel* PBtn=DocTax->MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;
  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
//  PBtn->Params->AddButton(BtnAvans,false)->ID="BtnAvans";
//  PBtn->Params->AddButton(BtnRebuild1,false)->ID="BtnRebuild1";
//  PBtn->Params->AddButton(BtnRebuild2,false)->ID="BtnRebuild2";
  PBtn->Params->AddButton(BtnRebuild3,false)->ID="BtnRebuild3";
  PBtn->Params->AddButton(BtnDel,false)->ID="BtnDel";
  PBtn->Params->AddButton(BtnCopy,false)->ID="BtnCopy";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";

  TWTPanel* PTax=DocTax->MainPanel->InsertPanel(200,true,200);
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PTax->Params->AddText("��������� ��������� �� �������� "+ NameCl,18,F,Classes::taCenter,false);


   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;

   Query2->Sql->Clear();
   Query2->Sql->Add("select t.*, t.value+t.value_tax as value_sum from acm_tax_tbl as t where id_client =  :client order by mmgg desc; " );

  // BasicGrid = new TWTDBGrid(P2, Query2);
   TWTDBGrid* DBGrTax=new TWTDBGrid(DocTax, Query2);


   TWTQuery *Query = DBGrTax->Query;


   DBGrTax->SetReadOnly(false);
   PTax->Params->AddGrid(DBGrTax, true)->ID="Tax";
//   TWTTable* Table = DBGrTax->Table;

   Query->AddLookupField("Name_pref","id_pref","aci_pref_tbl","name","id");

  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
 /*
   if (Sender!=NULL)
   {   AnsiString Proba;
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);
       Table->Filtered=true;
      };
    };
*/
  if (((TMainForm*)(Application->MainForm))->InterTaxCliTable!=NULL)
   {
   //AnsiString ee=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsString;
     int client=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsInteger;
//    Table->SetFilter("id_client="+ee);
//    Table->Filtered=true;
     Query->ParamByName("client")->AsInteger=client;
   };


  //DBGrTax->SetReadOnly(true);
  if(read_only)
  {
     DBGrTax->SetReadOnly(true);
  }
  
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id_doc");

  TStringList *NList=new TStringList();
  NList->Add("value_sum");


  Query->SetSQLModify("acm_tax_tbl",WList,NList,true,false,false);
  Query->AfterInsert=CancelInsert;


  TWTField *Fieldh;

  Fieldh = DBGrTax->AddColumn("int_num", "�����", "����� ��������� ���������");
  Fieldh->SetWidth(40);

  Fieldh = DBGrTax->AddColumn("reg_num", "������ �����", "����� ��������� ���������");
  Fieldh->SetWidth(80);
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("reg_date", "����", "���� �������");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("Name_pref", "���", "���");
  Fieldh->SetWidth(30);
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("kind_calc", "���", "��������� �� ����� ��� �� �����");
  Fieldh->AddFixedVariable("1", "�� �����");
  Fieldh->AddFixedVariable("2", "�����");
  Fieldh->AddFixedVariable("3", "������");
  Fieldh->AddFixedVariable("4", "���������");
  Fieldh->AddFixedVariable("5", "�������������");
  Fieldh->AddFixedVariable("7", "������ �� ������");
  Fieldh->AddFixedVariable("8", "������ 2016");   
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value", "����� ��� ���", "����� ��� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value_tax", "���", "����� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("value_sum", "����� � ���", "����� � ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("flock", "����.", "���� �������� ������");
  Fieldh->AddFixedVariable("0", "     ");
  Fieldh->AddFixedVariable("1", "����.");
  Fieldh->SetReadOnly();

  Fieldh = DBGrTax->AddColumn("flag_transmis", "������", "������");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "������");

  Fieldh = DBGrTax->AddColumn("disabled", "���������", "���������");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "����.");
  

  TWTToolBar* tb=DBGrTax->ToolBar;
  TWTToolButton* btn;
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


//--------------�������������----------------
  TButton *BtnPrnCor=new TButton(this);
  BtnPrnCor->Caption="������";
  BtnPrnCor->OnClick=ClientTaxCorPrint;
  //BtnCalc->Enabled=false;
  BtnPrnCor->Width=100;
  BtnPrnCor->Top=2;
  BtnPrnCor->Left=184;


  TButton *BtnNull=new TButton(this);
  BtnNull->Caption="";
  BtnNull->Width=100;
  BtnNull->Top=2;
  BtnNull->Left=464;
  //BtnCalc->Enabled=false;

  TWTPanel* PBtnP=DocTax->MainPanel->InsertPanel(25,25);
  PBtnP->RealHeight=25;

  PBtnP->Params->AddButton(BtnPrnCor,false)->ID="BtnPrnCor";
  PBtnP->Params->AddButton(BtnNull,false)->ID="BtnNull";

  TWTPanel* PTaxCorGr=DocTax->MainPanel->InsertPanel(200,true,200);

  TWTQuery *Query3 = new  TWTQuery(this);
  Query3->Options << doQuickOpen;
  Query3->Sql->Clear();
  Query3->Sql->Add("select t.*  from acm_taxcorrection_tbl as t where id_client =  :client order by mmgg desc; " );

  TWTDBGrid* DBGrCor=new TWTDBGrid(DocTax, Query3);

  PTaxCorGr->Params->AddText("������������� ",18,F,Classes::taCenter,false);
  PTaxCorGr->Params->AddGrid(DBGrCor, true)->ID="CorTax";
  TWTQuery *QueryI = DBGrCor->Query;
//  TWTTable* TableI = DBGrCor->Table;
  QueryI->AddLookupField("Name_pref","id_pref","aci_pref_tbl","name","id");

  if (((TMainForm*)(Application->MainForm))->InterTaxCliTable!=NULL)
   {
     int client=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsInteger;
     QueryI->ParamByName("client")->AsInteger=client;
   };

  QueryI->Open();

  WList=new TStringList();
  WList->Add("id_doc");
  NList=new TStringList();

  QueryI->SetSQLModify("acm_taxcorrection_tbl",WList,NList,true,false,true);
  QueryI->AfterInsert=CancelInsert;
  /*!!!!!!!!!!!!!!!!!!!!!*/
//  QueryI->IndexFieldNames = "id_doc";
//  QueryI->LinkFields = "id_doc=id_tax";
//  QueryI->MasterSource = DBGrTax->DataSource;
  /**/
//  DBGrCor->SetReadOnly(true);
  Fieldh = DBGrCor->AddColumn("reg_num", "�����", "����� ��������� ���������");
  Fieldh->SetWidth(80);
//  Fieldh->SetReadOnly();

  Fieldh = DBGrCor->AddColumn("reg_date", "����", "���� �������");
//  Fieldh->SetReadOnly();

  Fieldh = DBGrCor->AddColumn("Name_pref", "���", "���");
  Fieldh->SetWidth(30);
  Fieldh->SetReadOnly();

  Fieldh = DBGrCor->AddColumn("tax_num", "����� �� ������", "����� �� �����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrCor->AddColumn("tax_date", "���� ��", "���� ������� ��");
  Fieldh->SetReadOnly();

//  Fieldh = DBGrCor->AddColumn("pay_date", "���� ���.", "���� ������");
/*
  Fieldh = DBGrCor->AddColumn("value", "����� ��� ���", "����� ��� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();
*/
/*
  Fieldh = DBGrCor->AddColumn("value_tax", "���", "����� ���");
  Fieldh->Precision=2;
  Fieldh->SetReadOnly();
*/
  Fieldh = DBGrCor->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrCor->AddColumn("flock", "����.", "���� �������� ������");
  Fieldh->AddFixedVariable("0", "     ");
  Fieldh->AddFixedVariable("1", "����.");
  Fieldh->SetReadOnly();

  Fieldh = DBGrCor->AddColumn("flag_transmis", "������", "������");
  Fieldh->AddFixedVariable("0", "");
  Fieldh->AddFixedVariable("1", "������");


  DBGrTax->Visible=true;
  DBGrCor->Visible=true;
  DocTax->SetCaption("��������� ��������� "+NameCl);
  DocTax->ShowAs("CliTax");
  DocTax->MainPanel->ParamByID("Tax")->Control->SetFocus();
  DocTax->MainPanel->ParamByID("CorTax")->Control->SetFocus();
  DocTax->MainPanel->ParamByID("Tax")->Control->SetFocus();

};
//--------------------------------------------------
void __fastcall TMainForm::ClientTaxPrint(TObject *Sender)
{ TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrTax= ((TWTDBGrid *)MPanel->ParamByID("Tax")->Control);
  int id_tax=GrTax->Query->FieldByName("id_doc")->AsInteger;
  TDateTime mmgg = GrTax->Query->FieldByName("mmgg")->AsDateTime;

  if (mmgg < TDateTime(2014,3,1))
     Application->CreateForm(__classid(TfRepTaxN), &fRepTaxN);
  else
  {
     if (mmgg < TDateTime(2014,12,1))
       Application->CreateForm(__classid(TfRepTaxN2014), &fRepTaxN);
     else
     {
       if (mmgg < TDateTime(2015,1,1))
         Application->CreateForm(__classid(TfRepTaxN2014_12), &fRepTaxN);
       else
       {
         if (mmgg < TDateTime(2016,3,1))
            Application->CreateForm(__classid(TfRepTaxN2015), &fRepTaxN);
         else
            Application->CreateForm(__classid(TfRepTaxN2016), &fRepTaxN);
       }

     }

  }
  fRepTaxN->ShowTaxNal(id_tax);
  delete fRepTaxN;

};

//--------------------------------------------------

void __fastcall TMainForm::ClientTaxCorPrint(TObject *Sender)
{ TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrTaxCor= ((TWTDBGrid *)MPanel->ParamByID("CorTax")->Control);
  int id_taxcor=GrTaxCor->Query->FieldByName("id_doc")->AsInteger;
  TDateTime mmgg = GrTaxCor->Query->FieldByName("mmgg")->AsDateTime;

  if (mmgg < TDateTime(2014,3,1))
      Application->CreateForm(__classid(TfRepTaxCor), &fRepTaxCor);
  else
      Application->CreateForm(__classid(TfRepTaxCor2014), &fRepTaxCor);

  fRepTaxCor->ShowTaxCor(id_taxcor);
  delete fRepTaxCor;
};
//--------------------------------------------------
void __fastcall TMainForm::TaxRebuild(TObject *Sender)
{ TWTPanel *TDoc;
  AnsiString sqlstr;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrTax= ((TWTDBGrid *)MPanel->ParamByID("Tax")->Control);
  TWTDBGrid *GrTaxCor= ((TWTDBGrid *)MPanel->ParamByID("CorTax")->Control);
  int id_tax=GrTax->Query->FieldByName("id_doc")->AsInteger;
  int id_bill=GrTax->Query->FieldByName("id_bill")->AsInteger;
  int int_num_old=GrTax->Query->FieldByName("int_num")->AsInteger;
  int kind_calc=GrTax->Query->FieldByName("kind_calc")->AsInteger;
  int id_client=GrTax->Query->FieldByName("id_client")->AsInteger;
  int id_pref = GrTax->Query->FieldByName("id_pref")->AsInteger;
  TDateTime mmgg =GrTax->Query->FieldByName("mmgg")->AsDateTime;
  TDateTime reg_date =GrTax->Query->FieldByName("reg_date")->AsDateTime;


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

   GrTax->Query->Refresh();
   GrTaxCor->Query->Refresh();

   return;
  }
  /*
  //-- ������ �������� �� 2015 ����
  if ((kind_calc !=1 )&&(kind_calc !=2 )&&(kind_calc !=3 )&&(kind_calc !=5 )) return;

  ZQTax->Transaction->NewStyleTransactions=false;
  ZQTax->Transaction->TransactSafe=true;
  ZQTax->Transaction->AutoCommit=false;
  ZQTax->Transaction->Commit();
  ZQTax->Transaction->StartTransaction();

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

  if (kind_calc ==1)
  {
   sqlstr="select acm_createTaxBill( :bill );";
   ZQTax->Sql->Clear();
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

   GrTax->Query->Refresh();
   GrTaxCor->Query->Refresh();
   */
};
//--------------------------------------------------

void __fastcall TMainForm::TaxBuildAvans(TObject *Sender)
{
/*
  TWTPanel *TDoc;
  AnsiString sqlstr;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  ShowMessage("�� �������� � �������� ������ ������� ������� ��������� ��������� � ������ 2015 ���� ������� ��������� ��������� ����������!");
   return;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrTax= ((TWTDBGrid *)MPanel->ParamByID("Tax")->Control);
  TWTDBGrid *GrTaxCor= ((TWTDBGrid *)MPanel->ParamByID("CorTax")->Control);
  int id_client=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsInteger;


  TZPgSqlQuery* ZQTax = new TWTQuery(Application);
  ZQTax->Options.Clear();
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  int EnergyKinds[3];
  EnergyKinds[0]=10;
  EnergyKinds[1]=20;
  EnergyKinds[2]=520;

  AnsiString EnergyNames[3];
  EnergyNames[0]=" �������� ������� ";
  EnergyNames[1]=" ���������� ������� ";
  EnergyNames[2]=" ����������� ���� (2�� ����������) ";


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
   delete ZQTax;
   return;
  }
  int split_mode = ZQTax->FieldByName("var")->AsInteger;
  ZQTax->Close();

  if (split_mode==1)
  {
    if (MessageDlg("����������� ��������� ��������� ���������,���� ���������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
    {
      split_mode=0;
    }
  }


  //---------------------------------
  for(int en =0; en<=2; en++)
  {

  if (MessageDlg(" ������������ ��������� ��������� �� ����� �� "+EnergyNames[en]+" ?" , mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   continue;
  }

  ZQTax->Transaction->NewStyleTransactions=false;
  ZQTax->Transaction->TransactSafe=true;
  ZQTax->Transaction->AutoCommit=false;
  ZQTax->Transaction->Commit();
  ZQTax->Transaction->StartTransaction();


  sqlstr="select acm_createTaxAdvance( :client, :pref, fun_mmgg() ,now()::::date ,0, :mode)::::boolean as res;";
  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  ZQTax->ParamByName("client")->AsInteger=id_client;
  ZQTax->ParamByName("pref")->AsInteger=EnergyKinds[en];
  ZQTax->ParamByName("mode")->AsInteger=split_mode;

  try
   {
   ZQTax->Open();
   }
  catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ �� ["+EnergyNames[en]+" ]"+e.Message.SubString(8,200));
    ZQTax->Transaction->Rollback();
    ZQTax->Close();
    //ZQTax->Transaction->AutoCommit=true;
    //ZQTax->Transaction->TransactSafe=false;
    //delete ZQTax;
    continue;
   }

  if(ZQTax->Fields->Fields[0]->AsBoolean==false)
  {
   ZQTax->Close();
   //ZQTax->Transaction->Commit();
   //ZQTax->Transaction->AutoCommit=true;
   //ZQTax->Transaction->TransactSafe=false;
   //ShowMessage("��������� ��������� �� ������������!");
   //delete ZQTax;
   continue;
  }

  ZQTax->Close();

  sqlstr="select int_num, reg_date,id_doc from acm_tax_tbl where id_doc=currval('dcm_doc_seq')";

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
   ZQTax->Open();
  }
  catch(...)
  {
    ShowMessage("������.");
    ZQTax->Close();
    ZQTax->Transaction->Rollback();
    //ZQTax->Transaction->AutoCommit=true;
    //ZQTax->Transaction->TransactSafe=false;
    //delete ZQTax;
    continue;

  }

  int TaxNum =ZQTax->FieldByName("int_num")->AsInteger;
  TDateTime TaxDate =ZQTax->FieldByName("reg_date")->AsDateTime;
  int id_tax = ZQTax->FieldByName("id_doc")->AsInteger;


  ZQTax->Close();

  if (TaxNum > 0)
  {

   Application->CreateForm(__classid(TfTaxParam), &fTaxParam);
   fTaxParam->edNum->Text =IntToStr(TaxNum);
   fTaxParam->edDt->Text  = FormatDateTime("dd.mm.yyyy",TaxDate);
   if (fTaxParam->ShowModal()!= mrOk)
    {
     delete fTaxParam;
     ZQTax->Transaction->Rollback();
     //ZQTax->Transaction->AutoCommit=true;
     //ZQTax->Transaction->TransactSafe=false;
     //delete ZQTax;
     continue;
    };
   AnsiString NewTaxNum = fTaxParam->edNum->Text;
   TDateTime NewTaxDate = StrToDate(fTaxParam->edDt->Text);
   delete fTaxParam;

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
     ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
     ZQTax->Transaction->Rollback();
     //ZQTax->Transaction->AutoCommit=true;
     //ZQTax->Transaction->TransactSafe=false;
     //delete ZQTax;
     continue;
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
      {  ShowMessage("������ ��� ��������� ������ ��. "+e.Message.SubString(8,200));
         ZQTax->Transaction->Rollback();
         //ZQTax->Transaction->AutoCommit=true;
         //ZQTax->Transaction->TransactSafe=false;
         //delete ZQTax;
         continue;
      }
    }
   }
   ZQTax->Transaction->Commit();
  }
//   ----------------------------------------

   ZQTax->Transaction->Commit();
   ZQTax->Transaction->AutoCommit=true;
   ZQTax->Transaction->TransactSafe=false;
  // ShowMessage("��������� ��������� ������� ���������������");
   delete ZQTax;

   GrTax->Query->Refresh();
   GrTaxCor->Query->Refresh();
   */
};
//--------------------------------------------------

void __fastcall TMainForm::TaxNumNotify(TObject *Sender)
{
//
};
//--------------------------------------------------
void __fastcall TMainForm::TaxCorNumNotify(TObject *Sender)
{
//
};
//--------------------------------------------------
void __fastcall TMainForm::TaxAvansNumNotify(TObject *Sender)
{
  /*
  if (MessageDlg(" ������������ ��������� ��������� �� ����� � ������ ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TDateTime mmgg;
  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;
//  ZQTax->Transaction->AutoCommit=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg;";

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
   ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQTax->Close();
//    ZQTax->Transaction->Rollback();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
  }
  mmgg =ZQTax->Fields->Fields[0]->AsDateTime;

  ZQTax->Close();


  sqlstr="select to_number(trim(value_ident),'0000000000') from syi_sysvars_tbl where ident='last_tax_num';";

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
   ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQTax->Close();
//    ZQTax->Transaction->Rollback();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
  }

  int TaxNum =StrToInt(ZQTax->Fields->Fields[0]->AsString);

  ZQTax->Close();

///  if (TaxNum > 0)
//  {
   AnsiString NewTaxNum=InputBox("������ ��������� ���������", "��������� ��������� ��������� � �������� ������� � ", IntToStr(TaxNum));
   if (StrToInt(NewTaxNum)!=TaxNum)
   {
     sqlstr="update syi_sysvars_tbl set value_ident= :num where ident='last_tax_num';";

     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);

     ZQTax->ParamByName("num")->AsString=NewTaxNum;

     try
     {
      ZQTax->ExecSql();
     }
     catch(...)
     {
      ShowMessage("������ ��� ��������� ������ ��.");
//      ZQTax->Transaction->Rollback();
//      ZQTax->Transaction->AutoCommit=true;
      delete ZQTax;
      return;
    }
   }
//  }

   sqlstr="select acm_CloseTaxMonth();";
   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
//    ZQTax->Transaction->Rollback();
    ZQTax->Close();
//    ZQTax->Transaction->AutoCommit=true;
    delete ZQTax;
    return;
   }

   //-------------------------------------------------------------------

    sqlstr=" select reg_num,reg_date, value, value_tax, \
     round(value/5,2) as calc_tax \
     from \
   ( select * from \
     (select t.reg_num,t.reg_date, t.value, t.value_tax \
      from acm_tax_tbl as t \
      where t.mmgg = :mmgg \
      and t.int_num <>0 \
      and kind_calc = 2 \
     ) as t \
   ) as t2 \
    where (round(value/5,2)-value_tax <>0); ";

     ZQTax->Close();
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);
     ZQTax->ParamByName("mmgg")->AsDateTime = mmgg;

     try
     {
      ZQTax->Open();
     }
     catch(...)
     {
      ShowMessage("������ SQL.");
      ZQTax->Close();
      delete ZQTax;
      return;
    }
   ZQTax->First();

   if (ZQTax->RecordCount >0 )
   {
     ShowMessage("���������� ��������� ��������� �� �����, � ������� ����������� ����� ��� \n ���������� �� ���������! \n � ����� � ��������� � ������� ����������� ����������� ���� ��������� ��������� \n ������������ ������� ��������� ������ ���������!");
   }
    ZQTax->Close();

   //-------------------------------------------------------------------
    sqlstr=" select reg_num,reg_date, value, value_tax, \
     round(value/5,2) as calc_tax \
     from \
   ( select * from \
     (select t.reg_num,t.reg_date, t.value, t.value_tax \
      from acm_tax_tbl as t \
      where t.mmgg  = :mmgg \
      and t.int_num <>0 \
      and kind_calc not in (4,5) \
     ) as t \
     union all \
     ( select t.reg_num,t.reg_date, t.value, t.value_tax \
       from acm_taxcorrection_tbl as t \
       where t.mmgg = :mmgg  \
       and t.int_num <>0 \
     ) \
   ) as t2 \
    where ((round(value/5,2)-value_tax >0.03) or (round(value/5,2)- value_tax <-0.03)); ";

     ZQTax->Close();
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);
     ZQTax->ParamByName("mmgg")->AsDateTime = mmgg;

     try
     {
      ZQTax->Open();
     }
     catch(...)
     {
      ShowMessage("������ SQL.");
      ZQTax->Close();
      delete ZQTax;
      return;
    }
   ZQTax->First();

   if (ZQTax->RecordCount >0 )
   {
     ShowMessage("���������� ��������� ���������, � ������� ����������� ����� ��� \n ���������� �� ��������� ������ ��� �� 3 �������!");
   }
    ZQTax->Close();
   //-------------------------------------------------------------------


   TfTaxListFull* fTaxListFull;
   // ���� ������ ������ ���������, �������� ���
   for(int i = MainForm->MDIChildCount-1; i >= 0; i--)
   {
     if ( MainForm->MDIChildren[i]->Name == "TaxListFull")
     {
     try{
       fTaxListFull =(TfTaxListFull*)(MainForm->MDIChildren[i]);
       fTaxListFull->qTaxList->Refresh();
       fTaxListFull->qTaxLines->Refresh();

     } catch(...) {};
     }
   }
   //--------------------------------------------------------


//   ZQTax->Transaction->Commit();
//   ZQTax->Transaction->AutoCommit=true;

   // ��������� ���� �� ������
 //   sqlstr="select count(*)::::int as cnt from acm_taxpayerr_tbl;";
    sqlstr="select count(*)::::int as cnt from acm_tax_ndserr_tbl where mmgg = :mmgg ;";

     ZQTax->Close();
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);
     ZQTax->ParamByName("mmgg")->AsDateTime = mmgg;

     try
     {
      ZQTax->Open();
     }
     catch(...)
     {
      ShowMessage("������ SQL.");
      ZQTax->Close();
      delete ZQTax;
      return;
    }
   ZQTax->First();

   if (ZQTax->FieldByName("cnt")->AsInteger >0 )
   {
   ShowMessage("��������� ��������� ������������. ���������� ������.");

    TWTQuery *QueryErr=new TWTQuery(this);

    QueryErr->Sql->Clear();

    QueryErr->Sql->Add("select err.*, t.reg_num, t.int_num,t.reg_date, t.kind_calc, \
      CASE WHEN t.kind_calc =1 THEN '�������' WHEN t.kind_calc =2 THEN '�����' \
       WHEN t.kind_calc =3 THEN '������' WHEN t.kind_calc =4 THEN '���������' END::::varchar as kind, \
     c.code, c.short_name , p.name as name_pref , tax_nn - tax_real as tax_dif \
    from acm_tax_ndserr_tbl as err \
    join acm_tax_tbl as t on (t.id_doc = err.id_doc) \
    join clm_client_tbl as c on (c.id = t.id_client) \
    join aci_pref_tbl as p on (p.id= err.id_pref) \
    where err.mmgg = :mmgg \
    order by t.int_num; ");

    QueryErr->ParamByName("mmgg")->AsDateTime = mmgg;
    QueryErr->Open();

    TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryErr);

    WGrid->SetCaption("������������ ���� ��� � ���������� ��.");

    TWTField *Field;

    Field = WGrid->AddColumn("reg_num", "� ��", "� ��");
    Field->SetWidth(90);
    Field = WGrid->AddColumn("reg_date", "���� ��", "���� ��");
    Field->SetWidth(90);
    Field = WGrid->AddColumn("kind", "���", "���");
    Field = WGrid->AddColumn("code", "���. ����", "������� ����");
    Field->SetWidth(70);
    Field = WGrid->AddColumn("short_name", "�������", "�������");
    Field->SetWidth(200);
    Field = WGrid->AddColumn("name_pref", "��� �������", "��� �������");
    Field->SetWidth(90);
    Field = WGrid->AddColumn("sum_nn", "����� ��", "����� ��������� ���������");
    Field->Precision=2;
    Field = WGrid->AddColumn("tax_nn", "��� ��(20%)", "����� ��� ��������� ���������");
    Field->Precision=2;
    Field = WGrid->AddColumn("tax_real", "��� ����", "����� ��� �����������");
    Field->Precision=2;
    Field = WGrid->AddColumn("tax_dif", "������� ���", "������� ���");
    Field->Precision=2;

    WGrid->DBGrid->Visible = true;
    WGrid->ShowAs("������������ ���� ��� � ���������� ��.");
   }
   else
   {
   ShowMessage("��������� ��������� ������������");
   }

   ZQTax->Close();
   delete ZQTax;
   */
};

//--------------------------------------------------
void __fastcall TMainForm::TaxDecade1(TObject *Sender)
{
  TaxDecadeAll(1);
};
//--------------------------------------------------
void __fastcall TMainForm::TaxDecade2(TObject *Sender)
{
  TaxDecadeAll(2);
};
//--------------------------------------------------
void __fastcall TMainForm::TaxDecade3(TObject *Sender)
{
  TaxDecadeAll(3);
};
//--------------------------------------------------
void TMainForm::TaxDecadeAll(int decade)
{

  TDateTime mmgg;
  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options.Clear();
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg;";

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
   ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    return;
  }
  mmgg =ZQTax->Fields->Fields[0]->AsDateTime;

  ZQTax->Close();


  if (MessageDlg(" ������������ ��������� ��������� �� "+FormatDateTime("dd.mm.yyyy",mmgg)+"?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }


  sqlstr="select to_number(trim(value_ident),'0000000000') from syi_sysvars_tbl where ident='last_tax_num';";

  ZQTax->Sql->Clear();
  ZQTax->Sql->Add(sqlstr);
  try
  {
   ZQTax->Open();
  }
  catch(EDatabaseError &e)
  {
    ShowMessage("������ : "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    return;
  }

  int TaxNum =StrToInt(ZQTax->Fields->Fields[0]->AsString);

  ZQTax->Close();

   AnsiString NewTaxNum=InputBox("������ ��������� ���������", "��������� ��������� ��������� � �������� ������� � ", IntToStr(TaxNum));
   if (StrToInt(NewTaxNum)!=TaxNum)
   {
     sqlstr="update syi_sysvars_tbl set value_ident= :num where ident='last_tax_num';";

     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);

     ZQTax->ParamByName("num")->AsString=NewTaxNum;

     try
     {
      ZQTax->ExecSql();
     }
     catch(...)
     {
      ShowMessage("������ ��� ��������� ������ ��.");
      delete ZQTax;
      return;
    }
   }


   //sqlstr="select acm_CloseTaxDecade2015( :decade);";
   sqlstr="select acm_CloseTaxMonth2016();";

   ZQTax->Sql->Clear();
   ZQTax->Sql->Add(sqlstr);
   //   ZQTax->ParamByName("decade")->AsInteger=decade;

   try
   {
    ZQTax->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ ������������ ��. "+e.Message.SubString(8,200));
    ZQTax->Close();
    delete ZQTax;
    return;
   }

   //-------------------------------------------------------------------

    sqlstr=" select reg_num,reg_date, value, value_tax, \
     round(value/5,2) as calc_tax \
     from \
   ( select * from \
     (select t.reg_num,t.reg_date, t.value, t.value_tax \
      from acm_tax_tbl as t \
      where t.mmgg = :mmgg \
      and t.int_num <>0 \
      and t.decade = :decade \
     ) as t \
   ) as t2 \
    where (round(value/5,2)-value_tax <>0); ";

     ZQTax->Close();
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);
     ZQTax->ParamByName("mmgg")->AsDateTime = mmgg;
     ZQTax->ParamByName("decade")->AsInteger = decade;

     try
     {
      ZQTax->Open();
     }
     catch(...)
     {
      ShowMessage("������ SQL.");
      ZQTax->Close();
      delete ZQTax;
      return;
    }
   ZQTax->First();

   if (ZQTax->RecordCount >0 )
   {
     ShowMessage("���������� ��������� ��������� �� �����, � ������� ����������� ����� ��� \n ���������� �� ���������! ");
   }
   else
   {
     ShowMessage("��������� ��������� ������������.");
   }
   ZQTax->Close();


   //-------------------------------------------------------------------
/*
    sqlstr=" select reg_num,reg_date, value, value_tax, \
     round(value/5,2) as calc_tax \
     from \
   ( select * from \
     (select t.reg_num,t.reg_date, t.value, t.value_tax \
      from acm_tax_tbl as t \
      where t.mmgg  = :mmgg \
      and t.int_num <>0 \
      and kind_calc not in (4,5) \
     ) as t \
     union all \
     ( select t.reg_num,t.reg_date, t.value, t.value_tax \
       from acm_taxcorrection_tbl as t \
       where t.mmgg = :mmgg  \
       and t.int_num <>0 \
     ) \
   ) as t2 \
    where ((round(value/5,2)-value_tax >0.03) or (round(value/5,2)- value_tax <-0.03)); ";

     ZQTax->Close();
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);
     ZQTax->ParamByName("mmgg")->AsDateTime = mmgg;

     try
     {
      ZQTax->Open();
     }
     catch(...)
     {
      ShowMessage("������ SQL.");
      ZQTax->Close();
      delete ZQTax;
      return;
    }
   ZQTax->First();

   if (ZQTax->RecordCount >0 )
   {
     ShowMessage("���������� ��������� ���������, � ������� ����������� ����� ��� \n ���������� �� ��������� ������ ��� �� 3 �������!");
   }
    ZQTax->Close();
    */
   //-------------------------------------------------------------------


   TfTaxListFull* fTaxListFull;
   // ���� ������ ������ ���������, �������� ���
   for(int i = MainForm->MDIChildCount-1; i >= 0; i--)
   {
     if ( MainForm->MDIChildren[i]->Name == "TaxListFull")
     {
     try{
       fTaxListFull =(TfTaxListFull*)(MainForm->MDIChildren[i]);
       fTaxListFull->qTaxList->Refresh();
       fTaxListFull->qTaxLines->Refresh();

     } catch(...) {};
     }
   }
   //--------------------------------------------------------
 /*
   // ��������� ���� �� ������
    sqlstr="select count(*)::::int as cnt from acm_tax_ndserr_tbl where mmgg = :mmgg ;";

     ZQTax->Close();
     ZQTax->Sql->Clear();
     ZQTax->Sql->Add(sqlstr);
     ZQTax->ParamByName("mmgg")->AsDateTime = mmgg;

     try
     {
      ZQTax->Open();
     }
     catch(...)
     {
      ShowMessage("������ SQL.");
      ZQTax->Close();
      delete ZQTax;
      return;
    }
   ZQTax->First();

   if (ZQTax->FieldByName("cnt")->AsInteger >0 )
   {
   ShowMessage("��������� ��������� ������������. ���������� ������.");

    TWTQuery *QueryErr=new TWTQuery(this);

    QueryErr->Sql->Clear();

--    QueryErr->Sql->Add("select err.*, c.code, c.name , p.name as name_pref \
--    from acm_taxpayerr_tbl as err join clm_client_tbl as c on (c.id = err.id_client) \
--    join aci_pref_tbl as p on (p.id= err.id_pref); ");

    QueryErr->Sql->Add("select err.*, t.reg_num, t.int_num,t.reg_date, t.kind_calc, \
      CASE WHEN t.kind_calc =1 THEN '�������' WHEN t.kind_calc =2 THEN '�����' \
       WHEN t.kind_calc =3 THEN '������' WHEN t.kind_calc =4 THEN '���������' END::::varchar as kind, \
     c.code, c.short_name , p.name as name_pref , tax_nn - tax_real as tax_dif \
    from acm_tax_ndserr_tbl as err \
    join acm_tax_tbl as t on (t.id_doc = err.id_doc) \
    join clm_client_tbl as c on (c.id = t.id_client) \
    join aci_pref_tbl as p on (p.id= err.id_pref) \
    where err.mmgg = :mmgg \
    order by t.int_num; ");

    QueryErr->ParamByName("mmgg")->AsDateTime = mmgg;
    QueryErr->Open();

    TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QueryErr);

    WGrid->SetCaption("������������ ���� ��� � ���������� ��.");

    TWTField *Field;

    Field = WGrid->AddColumn("reg_num", "� ��", "� ��");
    Field->SetWidth(90);
    Field = WGrid->AddColumn("reg_date", "���� ��", "���� ��");
    Field->SetWidth(90);
    Field = WGrid->AddColumn("kind", "���", "���");
    Field = WGrid->AddColumn("code", "���. ����", "������� ����");
    Field->SetWidth(70);
    Field = WGrid->AddColumn("short_name", "�������", "�������");
    Field->SetWidth(200);
    Field = WGrid->AddColumn("name_pref", "��� �������", "��� �������");
    Field->SetWidth(90);
    Field = WGrid->AddColumn("sum_nn", "����� ��", "����� ��������� ���������");
    Field->Precision=2;
    Field = WGrid->AddColumn("tax_nn", "��� ��(20%)", "����� ��� ��������� ���������");
    Field->Precision=2;
    Field = WGrid->AddColumn("tax_real", "��� ����", "����� ��� �����������");
    Field->Precision=2;
    Field = WGrid->AddColumn("tax_dif", "������� ���", "������� ���");
    Field->Precision=2;

    WGrid->DBGrid->Visible = true;
    WGrid->ShowAs("������������ ���� ��� � ���������� ��.");
   }
   else
   {
   ShowMessage("��������� ��������� ������������");
   }

   ZQTax->Close();
*/
   delete ZQTax;
}
//--------------------------------------------------
void __fastcall TMainForm::TaxRebuild1(TObject *Sender)
{
 // int id_client=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsInteger;

 // TaxRebuildAbon(id_client,1,Sender);
};
//--------------------------------------------------
void __fastcall TMainForm::TaxRebuild2(TObject *Sender)
{
 // int id_client=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsInteger;

 // TaxRebuildAbon(id_client,2,Sender);

};
//--------------------------------------------------
void __fastcall TMainForm::TaxRebuild3(TObject *Sender)
{
  int id_client=((TMainForm*)(Application->MainForm))->InterTaxCliTable->FieldByName("id")->AsInteger;

  TaxRebuildAbon(id_client,3,Sender);

};
//--------------------------------------------------
void __fastcall TMainForm::TaxRebuildAbon(int client, int decade,TObject *Sender)
{

  if (MessageDlg(" ��������������� ��������� ��������� �� ��������? \n ��������� ���������, ���������� ��� ��������, ��������������� �� �����.", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

   AnsiString sqlstr="select acm_RebuildTaxMonth2016( :client);";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("client")->AsInteger=client;
   //ZQTax->ParamByName("decade")->AsInteger=decade;

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


   TWTPanel *TDoc;
   TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
   TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
   TWTDBGrid *GrTax= ((TWTDBGrid *)MPanel->ParamByID("Tax")->Control);
   TWTDBGrid *GrTaxCor= ((TWTDBGrid *)MPanel->ParamByID("CorTax")->Control);

   GrTax->Query->Refresh();
   GrTaxCor->Query->Refresh();

   return;

};
//------------------------------------------------------------------

void __fastcall TMainForm::TaxDelete(TObject *Sender)
{ TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrTax= ((TWTDBGrid *)MPanel->ParamByID("Tax")->Control);
  int id_tax=GrTax->Query->FieldByName("id_doc")->AsInteger;
//  int id_bill=GrTax->Table->FieldByName("id_bill")->AsInteger;
//  int int_num_old=GrTax->Table->FieldByName("int_num")->AsInteger;

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

   GrTax->Query->Refresh();
};
//--------------------------------------------------

void __fastcall TMainForm::ShowTaxList(TObject *Sender)
{
  TWinControl *Owner = NULL;

  // ���� ����� ���� ���� - ������������ � �������
  if (((TMainForm*)(Application->MainForm))->ShowMDIChild("������ ��������� ���������", Owner)) {
    return;
  }

  TfTaxListFull * fTaxListFull=new TfTaxListFull(Application);

  fTaxListFull->ShowAs("������ ��������� ���������");
 // fTaxListFull->SetCaption("������ ��������� ���������");

  fTaxListFull->ID="������ ��������� ���������";

  fTaxListFull->ShowData();

}
//----------------------------------------------------------
void __fastcall TMainForm::ShowTaxCors(TObject *Sender)
{
  TWinControl *Owner = NULL;

  // ���� ����� ���� ���� - ������������ � �������
  if (((TMainForm*)(Application->MainForm))->ShowMDIChild("������ ������������� ��������� ���������", Owner)) {
    return;
  }

  TfTaxCorListFull * fTaxCorListFull=new TfTaxCorListFull(Application);

  fTaxCorListFull->ShowAs("������ ������������� ��������� ���������");
//  fTaxCorListFull->SetCaption("������ ������������� ��������� ���������");

  fTaxCorListFull->ID="������ ������������� ��������� ���������";

  fTaxCorListFull->ShowData();

}
//----------------------------------------------------------
void __fastcall TMainForm::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//----------------------------------------------------------
void __fastcall TMainForm::TaxCopyToNoPay(TObject *Sender)
{

  TWTPanel *TDoc;
  AnsiString sqlstr;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;

  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent->Parent->Parent;
  TWTDBGrid *GrTax= ((TWTDBGrid *)MPanel->ParamByID("Tax")->Control);

  int id_tax=GrTax->Query->FieldByName("id_doc")->AsInteger;
  int int_num=GrTax->Query->FieldByName("int_num")->AsInteger;

  if (int_num!=0)
  {
     ShowMessage("���������� ��������� �������� ��� ��������� ��������� ����������� ���");
     return;
  }

  if (MessageDlg(" ������������ ��������� ��������� ��� �������������� ��� �� ��������� ������ ��������� ��������� ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }

  TWTQuery * ZQTax = new TWTQuery(Application);
  ZQTax->Options<< doQuickOpen;

  ZQTax->RequestLive=false;
  ZQTax->CachedUpdates=false;

   sqlstr="select acm_CopyToNotPayer( :id_doc );";
   ZQTax->Sql->Add(sqlstr);
   ZQTax->ParamByName("id_doc")->AsInteger=id_tax;

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

   ShowMessage("��������� ��������� ������� ������������");
   delete ZQTax;

   GrTax->Query->Refresh();

   return;

};
//----------------------------------------------------------
