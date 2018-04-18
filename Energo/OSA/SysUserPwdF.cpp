//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "SysUserPwdF.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFUserPwd *FUserPwd;
//---------------------------------------------------------------------------
__fastcall TFUserPwd::TFUserPwd(TComponent* Owner)
        : TForm(Owner)
{
}
__fastcall TFUserPwd::~TFUserPwd()
{
  Close();
};
//--------------------------------------------------------------------------
void __fastcall TFUserPwd::EdPwd2Exit(TObject *Sender)
{
if ((( TEdit*)Sender)->Text!=EdPwd1->Text)
 { ShowMessage("Введенный пароль и подтверждение пароля не совпадают!");
   BitBtnOK->Enabled=false;
   return;
 };
   BitBtnOK->Enabled=true;
}
//---------------------------------------------------------------------------
void __fastcall TFUserPwd::EdOldPwdExit(TObject *Sender)
{     int hash_codeu;
      int hash_codea;
      int hash_codee;
      int hash_codec;
        int hash_codeedit;

   TWTQuery *QUpdPwd=new TWTQuery(this);
   QUpdPwd->Sql->Clear();
   QUpdPwd->Sql->Add("select * from syi_user where id=:pid_user");
   QUpdPwd->ParamByName("pid_user")->AsInteger=fid_user;
   QUpdPwd->Open();
   hash_codec=QUpdPwd->FieldByName("pwd_code")->AsInteger;

   QUpdPwd->Sql->Clear();
   QUpdPwd->Sql->Add("select * from syi_user where id=0");
   QUpdPwd->Open();

   hash_codee=QUpdPwd->FieldByName("pwd_code")->AsInteger;
   QUpdPwd->Sql->Clear();
   QUpdPwd->Sql->Add("select * from syi_user where id=10");
   QUpdPwd->Open();
   hash_codea=QUpdPwd->FieldByName("pwd_code")->AsInteger;
   QUpdPwd->Sql->Clear();
           QUpdPwd->Sql->Add("select hashname(:ppwd)::::int as cod");
   QUpdPwd->ParamByName("ppwd")->AsString=(( TEdit*)Sender)->Text;
   QUpdPwd->Open();
   hash_codeedit=QUpdPwd->FieldByName("cod")->AsInteger;
 /*
 if ( ((hash_codeedit==hash_codee )||(hash_codeedit==hash_codec)||(hash_codeedit==hash_codea ) ))
 {  */
  EdPwd1->Enabled=true;
  EdPwd2->Enabled=true;
  BitBtnOK->Enabled=true;
 /*
 }
 else
 {ShowMessage("Неверно введен пароль!");
   EdPwd1->Enabled=false;
   EdPwd2->Enabled=false;
   BitBtnOK->Enabled=false;
   return;}  ;  */
 }

 void __fastcall TFUserPwd::EdOldPwdChange(TObject *Sender)
{
  int hash_codeu;
      int hash_codea;
      int hash_codee;
      int hash_codec;
        int hash_codeedit;

   TWTQuery *QUpdPwd=new TWTQuery(this);
   QUpdPwd->Sql->Clear();
   QUpdPwd->Sql->Add("select * from syi_user where id=:pid_user");
   QUpdPwd->ParamByName("pid_user")->AsInteger=fid_user;
   QUpdPwd->Open();
   hash_codec=QUpdPwd->FieldByName("pwd_code")->AsInteger;

   QUpdPwd->Sql->Clear();
   QUpdPwd->Sql->Add("select * from syi_user where id=0");
   QUpdPwd->Open();

   hash_codee=QUpdPwd->FieldByName("pwd_code")->AsInteger;
   QUpdPwd->Sql->Clear();
   QUpdPwd->Sql->Add("select * from syi_user where id=10");
   QUpdPwd->Open();
   hash_codea=QUpdPwd->FieldByName("pwd_code")->AsInteger;
   QUpdPwd->Sql->Clear();
           QUpdPwd->Sql->Add("select hashname(:ppwd)::::int as cod");
   QUpdPwd->ParamByName("ppwd")->AsString=(( TEdit*)Sender)->Text;
   QUpdPwd->Open();
   hash_codeedit=QUpdPwd->FieldByName("cod")->AsInteger;

 //if ( ((hash_codeedit==hash_codee )||(hash_codeedit==hash_codec)||(hash_codeedit==hash_codea ) ))
 //{
  EdPwd1->Enabled=true;
  EdPwd2->Enabled=true;
   BitBtnOK->Enabled=true;
 /*}
 else
 {   EdPwd1->Enabled=false;
   EdPwd2->Enabled=false;
   BitBtnOK->Enabled=false;
   return;}
    ; */
}
//---------------------------------------------------------------------------
void __fastcall TFUserPwd::Show(TObject *Sender,int id_user)
{  int pwd;
QUser=new TWTQuery(this);
      fid_user=id_user;
      QUser->Sql->Clear();
      QUser->Sql->Add("select u.*,p.represent_name from syi_user u \
        left join clm_position_tbl p on u.id_person=p.id \
      where u.id=:pid_user");
      QUser->ParamByName("pid_user")->AsInteger=fid_user;
     QUser->Open();
     if (!QUser->Eof)
      {AnsiString name_user=QUser->FieldByName("name")->AsString+" "+QUser->FieldByName("represent_name")->AsString;
       LabName->Caption=name_user;
       pwd= QUser->FieldByName("pwd_code")->AsInteger;
       if (pwd!=0 )
        {   BitBtnOK->Enabled=false;
            EdOldPwd->Enabled=true;
            EdOldPwd->Visible=true;
            LabOldPwd->Visible=true;
            EdPwd1->Enabled=false;
            EdPwd2->Enabled=false;
        };
      };

}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------


void __fastcall TFUserPwd::EdPwd2Change(TObject *Sender)
{
 if ((( TEdit*)Sender)->Text==EdPwd1->Text)
   BitBtnOK->Enabled=true;
 else
  BitBtnOK->Enabled=false;;

}
//---------------------------------------------------------------------------

void __fastcall TFUserPwd::BitBtnOKClick(TObject *Sender)
{
   TWTQuery *QUpdPwd=new TWTQuery(this);
       if  ((EdPwd1->Text.IsEmpty()))
       {ShowMessage("Все таки введите пароль!");
        return;
       };
          if  ((EdPwd2->Text.IsEmpty()))
       {ShowMessage("Введите подтверждение пароля!");
        return;
       };
        if  ((EdPwd1->Text!=EdPwd2->Text))
       {ShowMessage("Пароль и подтверждение пароля не совпадают!");
        return;
       };
      QUpdPwd->Sql->Clear();
      QUpdPwd->Sql->Add("select sys_upd_pwd(:pid_user,:ppwd,:ppwdo)");
      QUpdPwd->ParamByName("pid_user")->AsInteger=fid_user;
       QUpdPwd->ParamByName("ppwd")->AsString=EdPwd1->Text;
        QUpdPwd->ParamByName("ppwdo")->AsString=EdOldPwd->Text;
      QUpdPwd->ExecSql();
     // Action=caFree;
    Close();
}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

void __fastcall TFUserPwd::FormClose(TObject *Sender, TCloseAction &Action)
{
 Action = caFree;        
}
//---------------------------------------------------------------------------

