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
}
//---------------------------------------------------------------------------
void __fastcall TFShowSys::ChNextClick(TObject *Sender)
{    TWTQuery *QMMGG=new TWTQuery (this);
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
{    TWTQuery *QMMGG=new TWTQuery (this);
     QMMGG->Sql->Add("update syi_sysvars_tmp set value_ident="+ToStrSQL(EdMMGGN->Text)+" where ident='mmgg'");
     QMMGG->ExecSql();

}
//---------------------------------------------------------------------------

