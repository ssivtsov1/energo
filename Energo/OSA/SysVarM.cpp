//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "main.h"
#include "SysVarM.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFShowSys *FShowSys;
//---------------------------------------------------------------------------
__fastcall TFShowSys::TFShowSys(TComponent* Owner)
        : TfTWTCompForm(Owner)
{    TWTQuery *QMMGG=new TWTQuery (this);
     TWTQuery *QMMGGN=new TWTQuery (this);
     QMMGG->Sql->Add("select value_ident from syi_sysvars_tbl where ident='mmgg'");
     QMMGG->Open();
     EdMMGG->Text=QMMGG->FieldByName("value_ident")->AsString;
     QMMGGN->Sql->Add("select value_ident from syi_sysvars_tmp where ident='mmgg'");
     QMMGGN->Open();
     EdMMGGN->Text=QMMGGN->FieldByName("value_ident")->AsString;
     if  (QMMGG->FieldByName("value_ident")->AsDateTime!=QMMGGN->FieldByName("value_ident")->AsDateTime)
      ChNext->Checked=true;
      else
     ChNext->Checked=false;
     TWTQuery *QCh=new TWTQuery (this);
     ChChangeName->Checked=false;
     QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='eqpnamecopy'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(21,'eqpnamecopy','int',0) ");
       QCh->ExecSql();
     }
     else
     {
     if  (QCh->FieldByName("value_ident")->AsInteger==1)
      ChChangeName->Checked=true;
      else
      ChChangeName->Checked=false;
     };


     TWTQuery *QCh1=new TWTQuery (this);
     ChTaxList->Checked=false;
     QCh1->Sql->Add("select value_ident from syi_sysvars_tmp where ident='tax_1copy'");
     QCh1->Open();
     if (QCh1->Eof)
     {  QCh1->Sql->Clear();
       QCh1->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(24,'tax_1copy','int',0) ");
       QCh1->ExecSql();
     }
     else
     {
     if  (QCh1->FieldByName("value_ident")->AsInteger==1)
      ChTaxList->Checked=true;
      else
      ChTaxList->Checked=false;
     };


      ChFider->Checked=false;
     QCh->Sql->Clear();
     QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='fidercontrol'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(22,'fidercontrol','int',0) ");
       QCh->ExecSql();
     }
     else
     {
     if  (QCh->FieldByName("value_ident")->AsInteger==1)
      ChFider->Checked=true;
      else
      ChFider->Checked=false;
     };
     ChHistory->Checked=false;
     QCh->Sql->Clear();
     QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='eqp_log'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(9,'eqp_log','int',0) ");
       QCh->ExecSql();
     }
     else
     {
     if  (QCh->FieldByName("value_ident")->AsInteger==1)
      ChHistory->Checked=true;
      else
      ChHistory->Checked=false;
     };
     QCh->Sql->Clear();
      QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='kod_res'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(23,'kod_res','int',0) ");
       QCh->ExecSql();
     }
     else
     {
         EdKodRes->Text=QCh->Fields->Fields[0]->AsString;
     };

 QCh->Sql->Clear();
     QCh->Sql->Add("select id,short_name from clm_client_tbl \
       where id=syi_resid_fun()");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(1,'id_res','int',0) ");
       QCh->ExecSql();
     }
     else
     {    LabRes->Caption=QCh->FieldByName("short_name")->AsString;
          LabIdRes->Caption=QCh->FieldByName("id")->AsString;
     };

   QCh->Sql->Clear();
      QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='tax_num_ending'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(15,'tax_num_ending','int',' -') ");
       QCh->ExecSql();
     }
     else
     {
         EdPrefTax->Text=QCh->Fields->Fields[0]->AsString;
     };

  QCh->Sql->Clear();
      QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='last_tax_num'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(16,'last_tax_num','int',0) ");
       QCh->ExecSql();
     }
     else
     {
         EdLastTax->Text=QCh->Fields->Fields[0]->AsString;
     };

      QCh->Sql->Clear();
      QCh->Sql->Add("select value_ident from syi_sysvars_tbl where ident='path_bank'");
     QCh->Open();
     if (QCh->Eof)
     {  QCh->Sql->Clear();
       QCh->Sql->Add("insert into syi_sysvars_tbl(id,ident,type_ident,value_ident) values(300,'path_bank','varchar',200) ");
       QCh->ExecSql();
     }
     else
     {
         EdPathBank->Text=QCh->Fields->Fields[0]->AsString;
     };

}
//---------------------------------------------------------------------------
void __fastcall TFShowSys::ChNextClick(TObject *Sender)
{   ShortDateFormat="dd.mm.yyyy";
     TWTQuery *QMMGG=new TWTQuery (this);
     QMMGG->Sql->Add("select to_date(value_ident,'DD.MM.YYYY')+interval '1 month' as value_ident from syi_sysvars_tbl where ident='mmgg'");
     QMMGG->Open();

     TDateTime TDat=QMMGG->FieldByName("value_ident")->AsDateTime;

     //EdMMGG->Text=QMMGG->FieldByName("value_ident")->AsString;

 if(ChNext->Checked==false) EdMMGGN->Text=EdMMGG->Text;
 else
  EdMMGGN->Text=TDat;

}
//---------------------------------------------------------------------------

void __fastcall TFShowSys::BtnSaveClick(TObject *Sender)
{  ShortDateFormat="dd.mm.yyyy";
   TWTQuery *QMMGG=new TWTQuery (this);
     QMMGG->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(EdMMGGN->Text)+" where ident='mmgg'");
     QMMGG->ExecSql();
   TWTQuery *QCh=new TWTQuery (this);

   int CheckChName=0;
   if  (ChChangeName->Checked)        CheckChName=1;
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(CheckChName)+" where ident='eqpnamecopy'");
   QCh->ExecSql();
    QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(CheckChName)+" where ident='eqpnamecopy'");
   QCh->ExecSql();

    int CheckChTax=0;
    QCh->Sql->Clear();
   if  (ChTaxList->Checked)        CheckChTax=1;
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(CheckChTax)+" where ident='tax_1copy'");
   QCh->ExecSql();
    QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(CheckChTax)+" where ident='tax_1copy'");
   QCh->ExecSql();


   int CheckChHistory=0;
   if  (ChHistory->Checked)        CheckChHistory=1;
   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(CheckChHistory)+" where ident='eqp_log'");
   QCh->ExecSql();
   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(CheckChHistory)+" where ident='eqp_log'");
   QCh->ExecSql();

    int CheckChFider=0;
   if  (ChFider->Checked)        CheckChFider=1;
   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(CheckChFider)+" where ident='fidercontrol'");
   QCh->ExecSql();
   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(CheckChFider)+" where ident='fidercontrol'");
   QCh->ExecSql();


   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(EdKodRes->Text)+" where ident='kod_res'");
   QCh->ExecSql();

   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(EdKodRes->Text)+" where ident='kod_res'");
   QCh->ExecSql();

    QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(EdPrefTax->Text)+" where ident='tax_num_ending'");
   QCh->ExecSql();

   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(EdPrefTax->Text)+" where ident='tax_num_ending'");
   QCh->ExecSql();

   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(EdLastTax->Text)+" where ident='last_tax_num'");
   QCh->ExecSql();

   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident="+ToStrSQL(EdLastTax->Text)+" where ident='last_tax_num'");
   QCh->ExecSql();

   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tbl set value_ident=:upd_p where ident='path_bank'");
   QCh->ParamByName("upd_p")->AsString=EdPathBank->Text;
   QCh->ExecSql();
   QCh->Params->Clear();

   QCh->Sql->Clear();
   QCh->Sql->Add("update syi_sysvars_tmp set value_ident=:upd_p where ident='path_bank'");
   QCh->ParamByName("upd_p")->AsString=EdPathBank->Text;
   QCh->ExecSql();
   QCh->Params->Clear();
   QCh->Sql->Clear();
   QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='mmgg'");
   QCh->Open();

  AnsiString  Period=QCh->FieldByName("value_ident")->AsString;
 ((TMainForm*)Application->MainForm)->MFPeriod=Period;
  //Application->Title =Application->Title+"         ������  _______ "+Period ;
   Application->MainForm->Caption = "������� --- ����������� ����         "+((TMainForm*)Application->MainForm)->MFPeriod  +"          "  +((TMainForm*)Application->MainForm)->MFname_base;
}

//---------------------------------------------------------------------------

void __fastcall TFShowSys::BitBtn1Click(TObject *Sender)
{
   TWTQuery *QMMGG=new TWTQuery (this);
     QMMGG->Sql->Add("delete from eqt_tree");
     QMMGG->ExecSql();
    delete QMMGG;
}
//---------------------------------------------------------------------------

void __fastcall TFShowSys::SpeedButton1Click(TObject *Sender)
{ AnsiString FileName;
  //OpenDBF->FileName=EdPathBank->Text;
  AnsiString CurrDir=GetCurrentDir();
  OpenDBF->InitialDir=FileName;
  OpenDBF->Title = "�������� �������";
  if (OpenDBF->Execute())
  { AnsiString PathToDbf=(ExtractFilePath(OpenDBF->FileName));
     EdPathBank->Text=PathToDbf;
   }
  SetCurrentDir(CurrDir);
}
//---------------------------------------------------------------------------

