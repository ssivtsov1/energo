//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "main.h"
#include "SysVers.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFShowVers *FShowVers;
//---------------------------------------------------------------------------
__fastcall TFShowVers::TFShowVers(TComponent* Owner)
        : TfTWTCompForm(Owner)
{    QVers=new TWTQuery (this);

}
//---------------------------------------------------------------------------
void _fastcall TFShowVers::Show(int Ver)
{       TWTQuery *QCh=new TWTQuery (this);
      QVers->Sql->Add("select *  from syi_version where id= \
      (select max(id) from syi_version )");
     QVers->Open();
     LVersExe->Caption=IntToStr(Ver);
     LVersScr->Caption=QVers->FieldByName("vers_scr")->AsString;
     LVersExeB->Caption=QVers->FieldByName("vers_prg")->AsString;
     LCreateScr->Caption=QVers->FieldByName("dt_creat")->AsString;
     LSetScr->Caption=QVers->FieldByName("dt_set")->AsString;

     try {
     QVers->Sql->Clear();
     QVers->Sql->Add("select * from syi_sysvars_tbl where ident='dt_last'") ;
     QVers->Open();
     if (!(QVers->Eof))
        LActDump->Caption=QVers->FieldByName("value_ident")->AsString;
        QVers->Sql->Clear();
     QVers->Sql->Add("select * from syi_sysvars_tbl where ident='dt_restore'") ;
     QVers->Open();
     if (!(QVers->Eof))
        LDump->Caption=QVers->FieldByName("value_ident")->AsString;

     }
     catch(...) {};

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
     };

     ShowModal();
}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

