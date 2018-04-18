//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "BaseLogin.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfBaseLogin *fBaseLogin;
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
__fastcall TfBaseLogin::TfBaseLogin(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::FormCreate(TObject *Sender)
{
  ZQuery = new TWTQuery(Application);
  ZQuery->Options<< doQuickOpen;

  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

  AnsiString sqlstr="select id, represent_name from clm_position_tbl where id_client = syi_resid_fun() and represent_name is not null order by represent_name;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);

  try
   {
    ZQuery->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }
   ZQuery->First();

   for(int i=1;i<=ZQuery->RecordCount;i++)
    {
     cbUser->Items->Add(ZQuery->FieldByName("represent_name")->AsString);
     UserMap[ZQuery->FieldByName("represent_name")->AsString]=ZQuery->FieldByName("id")->AsInteger;

     ZQuery->Next();
    }
   ZQuery->Close();

   cbUser->Text = GlobalUsrName;
}
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::btOkClick(TObject *Sender)
{  try {
    ((TWTMainForm*)Application->MainForm)->Database->DisConnect();
    ((TWTMainForm*)Application->MainForm)->Database->DataBase = AliasE;
    ((TWTMainForm*)Application->MainForm)->Database->Host = HostE;
    ((TWTMainForm*)Application->MainForm)->Database->Connect();
    ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","Alias",AliasE);
  ((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","Host",HostE);

    }
  catch (Exception &exception) {
    ShowMessage("Ошибка открытия базы " + AliasE+".\nПрограмма завершает свое выполнение");
    exit(0);
//    throw(exception);
  }

}

//---------------------------------------------------------------------------
 