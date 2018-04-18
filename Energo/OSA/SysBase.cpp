//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "SysBase.h"
#include "Main.h"
#include "fLogin.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfBaseLogin *fBaseLogin;
AnsiString Alias_;
AnsiString Host_;
//---------------------------------------------------------------------------
__fastcall TfBaseLogin::TfBaseLogin(TComponent* Owner)
        : TForm(Owner)

{ EdAlias->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","Alias",AliasE);
  EdHost->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","Host",HostE);
  TWTQuery *QBas=new TWTQuery(this);
  QBas->Sql->Clear();
  Check=0;
  QBas->Sql->Add("select * from sys_basa_tbl where alias_="+ToStrSQL(EdAlias->Text) +" and host_="+ToStrSQL(EdHost->Text));
  try
    { QBas->Open();
      LabAlias->Caption=QBas->FieldByName("name")->AsString;
     if (QBas->FieldByName("encod")->AsString.Length()>1)
      EdEncod->Text= QBas->FieldByName("encod")->AsString;
      else
      EdEncod->Text="win";
     ZQuery = new TWTQuery(Application);
    ZQuery->Options<< doQuickOpen;

    AnsiString sqlencod="set client_encoding="+EdEncod->Text;
           ZQuery->Sql->Clear();
    ZQuery->Sql->Add(sqlencod);
     ZQuery->ExecSql();
   }
  catch (Exception &exception)
   {
   };
}
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::FormCreate(TObject *Sender)
{
  ZQuery = new TWTQuery(Application);
  ZQuery->Options<< doQuickOpen;

  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

}
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::btOkClick(TObject *Sender)
{ Check=1;
 AliasE=EdAlias->Text;
 HostE=EdHost->Text;
 EncodE=EdEncod->Text;
 if (EncodE=="")
 { ShowMessage("��������� ���������");
  return;
  }
 try {
    TWTTable::Database->Disconnect();
    TWTTable::Database->Database = AliasE;
    TWTTable::Database->Host= HostE;
    TWTTable::Database->Connect();
      /*
    ((TWTMainForm*)Application->MainForm)->Database->DisConnect();
    ((TWTMainForm*)Application->MainForm)->Database->DataBase = AliasE;
    ((TWTMainForm*)Application->MainForm)->Database->Host = HostE;
    ((TWTMainForm*)Application->MainForm)->Database->Connect();
    */
   ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","Alias",AliasE);
  ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","Host",HostE);
   // if (EncodE=="win")
    ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","Encoding","win");
   // else
   // ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","Encoding","etKoi8u");


            ((TMainForm*)Application->MainForm)->On_Start_Programm();

        ZQuery = new TWTQuery(Application);
   // ZQuery->Options<< doQuickOpen;
   AnsiString sqlencod="set client_encoding="+EdEncod->Text+";";
  //AnsiString sqlencod="select 10-8";
    ZQuery->Sql->Clear();
    ZQuery->Sql->Add(sqlencod);
    try
   {    ZQuery->ExecSql();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlencod);

    return;
   }
  TWTQuery *QBas=new TWTQuery(this);
  QBas->Sql->Clear();

  QBas->Sql->Add("select * from sys_basa_tbl where alias_="+ToStrSQL(EdAlias->Text) +" and host_="+ToStrSQL(EdHost->Text));
  try
    { QBas->Open();
      LabAlias->Caption=QBas->FieldByName("name")->AsString;
      ((TMainForm*)Application->MainForm)->MFname_base=QBas->FieldByName("name")->AsString;
      ((TMainForm*)Application->MainForm)->MFid_base=QBas->FieldByName("id")->AsInteger;
   }
      catch (Exception &exception)
   {
   };



   Application->MainForm->Caption = "������� --- ����������� ����         "+((TMainForm*)Application->MainForm)->MFPeriod  +"          "  +((TMainForm*)Application->MainForm)->MFname_base;
        Application->CreateForm(__classid(TfUserLogin), &fUserLogin);
        fUserLogin->ShowModal();
    ((TWTMainForm*)Application->MainForm)->CloseAllMenu(Sender);


    }
  catch (Exception &exception) {
    ShowMessage("������ �������� ���� " + AliasE+".\n��������� ��������� ���� ����������");
    
       Application->ShowException(&exception);
    exit(0);
//    throw(exception);
  }
  Close();
  ZQuery->ExecSql();
}


 void _fastcall TMainForm::ReBasa(TObject *Sender)
{  // CloseAllMenu(Sender);
    AnsiString Prompt=StartupIniFile->ReadString("Base","PromptLogin","0");
    if (Prompt=="1")
    {
     Application->CreateForm(__classid(TfBaseLogin), &fBaseLogin);
       fBaseLogin->Show();
      //  fBaseLogin->ShowModal();
 /*     if(fBaseLogin->Check==1) {
      try {
        On_Start_Programm();
          }
         catch (...) {};
        Application->CreateForm(__classid(TfUserLogin), &fUserLogin);
        fUserLogin->ShowModal();
      };      */
      };
}
#define WinName "������ ���"
//---------------------------------------------------------------------------
void __fastcall TfBaseLogin::SbAliasClick(TObject *Sender)
{
  GrBas=SbAliasSel(Sender);

   GrBas->FieldSource = GrBas->Table->GetTField("id");
  GrBas->StringDest = "1";
 GrBas->OnAccept=BazaAccept;
      /*
  LabAlias->Caption=GrBas->DataSource->DataSet->FieldByName("name")->AsString;
  EdAlias->Text=GrBas->DataSource->DataSet->FieldByName("Alias_")->AsString;
  EdHost->Text=GrBas->DataSource->DataSet->FieldByName("Host_")->AsString;*/
};

TWTDBGrid* __fastcall TfBaseLogin::SbAliasSel(TObject *Sender)
{  int id_a;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();
  TWTQuery *QBas=new TWTQuery(this);
  QBas->Sql->Clear();
  QBas->Sql->Add("select * from sys_basa_tbl where alias_="+ToStrSQL(EdAlias->Text) +" and host_="+ToStrSQL(EdHost->Text));
  try
    { QBas->Open();
      id_a=QBas->FieldByName("id")->AsInteger;

   TWinControl *Owner =  (TWinControl *)( (TControl *) (TSpeedButton*)Sender)->Owner;
                        //(TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent
  // ���� ����� ���� ���� - ������������ � �������
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner)) {
   // return null;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "sys_basa_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;


  Table->Open();
    bool t1=WGrid->DBGrid->DataSource->DataSet->Locate("id",id_a ,SearchOptions);
  TWTField *Field;
  Field = WGrid->AddColumn("Alias_", "����", "����");
  Field = WGrid->AddColumn("name", "��������", "�������� ���");
  Field = WGrid->AddColumn("Host_", "������", "IP ����� �������");

 /* WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = WGrid->DBGrid->Table->GetTField("id");
 */// WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("name");
  //
  WGrid->DBGrid->Visible = true;
  Table->IndexFieldNames="name";
  WGrid->ShowAs("rrr");
   return WGrid->DBGrid;
    }
  catch (Exception &exception)
   {
   };
//return null;
}

#undef WinName
//---------------------------------------------------------------------------

void __fastcall TfBaseLogin::EdAliasExit(TObject *Sender)
{
 TWTQuery *QBas=new TWTQuery(this);
  QBas->Sql->Clear();
  QBas->Sql->Add("select * from sys_basa_tbl where alias_="+ToStrSQL(((TEdit *)Sender)->Text) +" and host_="+ToStrSQL(EdHost->Text));
  try
    { QBas->Open();
      LabAlias->Caption=QBas->FieldByName("name")->AsString;
          if (QBas->FieldByName("encod")->AsString.Length()>1)
      EdEncod->Text= QBas->FieldByName("encod")->AsString;
      else
      EdEncod->Text="win";

     // EdEncod->Text= QBas->FieldByName("encod")->AsString;

       ZQuery = new TWTQuery(Application);
    ZQuery->Options<< doQuickOpen;
    AnsiString sqlencod="set client_encoding="+EdEncod->Text;
          ZQuery->Sql->Clear();
    ZQuery->Sql->Add(sqlencod);
     ZQuery->ExecSql();
      sqlencod="SET client_min_messages TO WARNING";
          ZQuery->Sql->Clear();
    ZQuery->Sql->Add(sqlencod);
     ZQuery->ExecSql();

    }
  catch (Exception &exception)
   {
   };
}
void __fastcall TfBaseLogin::BazaAccept(TObject *Sender)
{
  LabAlias->Caption=GrBas->DataSource->DataSet->FieldByName("name")->AsString;
  EdAlias->Text=GrBas->DataSource->DataSet->FieldByName("Alias_")->AsString;
  EdHost->Text=GrBas->DataSource->DataSet->FieldByName("Host_")->AsString;
   EdEncod->Text=GrBas->DataSource->DataSet->FieldByName("encod")->AsString;
    ZQuery = new TWTQuery(Application);
    ZQuery->Options<< doQuickOpen;
    AnsiString sqlencod="set client_encoding="+EdEncod->Text;
      ZQuery->Sql->Clear();
    ZQuery->Sql->Add(sqlencod);
     ZQuery->ExecSql();

};

//---------------------------------------------------------------------------

void __fastcall TfBaseLogin::btCancelClick(TObject *Sender)
{
Close();
}
//---------------------------------------------------------------------------

void __fastcall TfBaseLogin::EdAliasChange(TObject *Sender)
{
Check=1;}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
#define WinName "������ ������ ���������"
__fastcall TfBaseTable::TfBaseTable(TComponent* Owner)
        : TWTForm(Owner)
{  int id_a;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();

  // TWinControl *Owner =  (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent
  // ���� ����� ���� ���� - ������������ � �������
 /* if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner))
   {
    return;
  }
   */
  QTabl=new TWTQuery(this);
  QTabl->Sql->Add("select * from syi_table_tbl order by act,id_task,name");
  //QTabl->Open();
  WGrid = new TWTWinDBGrid(this, QTabl,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Table = WGrid->DBGrid->Query;
  TWTQuery *QTask=new TWTQuery(this);
  QTask->Sql->Add("select id,name from syi_task_tbl order by id");
  QTask->Open();
  Table->AddLookupField("name_task","id_task",QTask,"name","id");

  Table->Open();
   TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
 // NList->Add("name_task");

   Table->SetSQLModify("syi_table_tbl",WList,NList,true,true,true);

 // Table->IndexFieldNames="name_task,name";
 //Table->IndexFieldNames="name";
  TWTField *Field;
  Field = WGrid->AddColumn("name", "�������", "�������");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("note", "����������", "����������");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("tbl_owner", "��������", "��������");
  Field->SetWidth(100);
  Field = WGrid->AddColumn("id_task", "������", "������");
  Field->SetWidth(50);
  Field = WGrid->AddColumn("name_task", "������", "������");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("act", "���������", "���������");
  Field->AddFixedVariable("1", "�������");
  Field->AddFixedVariable("0","       ");
  Field->AddFixedVariable("2","�� ���������");
  Field->SetDefValue("0");
  Field->SetWidth(80);

  Field = WGrid->AddColumn("flag_repl", "�������������", "�������������");
  Field->AddFixedVariable("True", " �� ");
  Field->AddFixedVariable("False","    ");
  Field->SetDefValue("False");
  Field->SetWidth(80);

    Field = WGrid->AddColumn("flag_ins", "���������", "���������");
  Field->AddFixedVariable("True", " �� ");
  Field->AddFixedVariable("False","    ");
  Field->SetDefValue("False");
  Field->SetWidth(80);

      Field = WGrid->AddColumn("flag_upd", "��������", "��������");
  Field->AddFixedVariable("True", " �� ");
  Field->AddFixedVariable("False","    ");
  Field->SetDefValue("False");
  Field->SetWidth(80);


  Field = WGrid->AddColumn("ord", "�������", "�������");
   Field->SetWidth(25);


  WGrid->DBGrid->ToolBar->AddButton("Deletesh", "�������� <<��������>> ������", DelTable);
  
  WGrid->DBGrid->ToolBar->AddButton("Cascade", "�������� ��� ", AllTable);

  WGrid->DBGrid->Visible = true;
  WGrid->DBGrid->OnAccept = OnAcceptTable;
  WGrid->ShowAs(WinName);

}
#undef WinName

 void _fastcall TMainForm::BasaTable(TObject *Sender)
{   AnsiString Prompt=StartupIniFile->ReadString("Base","PromptLogin","0");
    if (Prompt=="1")
    {
       TfBaseTable *fBaseTable=new TfBaseTable (this);
      };
}


 void _fastcall TfBaseTable::OnAcceptTable(TObject *Sender)
{
   TfBaseField *fBaseField=new TfBaseField (this);
   fBaseField->BaseFieldShow(WGrid->DBGrid);

}
void __fastcall TfBaseTable::DelTable(TObject *Sender)
{
 if (Ask("�� ��� ��������� ��������� ������ ����! \N ���� ��� �� ����� �����.... "))
  if (Ask("�� �������, ��� ������� �������� ����� ���������� ���������! "))
  {
       TWTQuery *QuerDel=new TWTQuery(this);
       QuerDel->Sql->Add("select t_del()");
       QuerDel->ExecSql();
  };

}

void __fastcall TfBaseTable::AllTable(TObject *Sender)
{
 TfBaseTableA *fBaseTableA=new TfBaseTableA (this);

}



#define WinName "������ ����� ������� ... "
//---------------------------------------------------------------------------

__fastcall TfBaseField::TfBaseField(TComponent* Owner)
        : TWTForm(Owner)
{  int id_a;
   int id_tabl;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();

  // TWinControl *Owner =  (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent
  // ���� ����� ���� ���� - ������������ � �������
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner)) {
   // return null;
  }

  QTabl=new TWTQuery(this);
 };

__fastcall TfBaseField::BaseFieldShow(TWTDBGrid *TablGrid)
 { id_tabl= TablGrid->Query->FieldByName("id")->AsInteger;

   QTabl->Sql->Add("select * from syi_field_tbl where id_table=:id_tabl order by id");
   QTabl->ParamByName("id_tabl")->AsInteger=id_tabl;
  //QTabl->Open();
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QTabl,false);
 // WinName = "������ ����� �������  - ";
  WGrid->SetCaption(WinName +TablGrid->Query->FieldByName("name")->AsString );

  TWTQuery* Table = WGrid->DBGrid->Query;
  TWTQuery *QTask=new TWTQuery(this);
  QTask->Sql->Add("select * from syi_type_tbl order by id");
  QTask->Open();

  Table->AddLookupField("TNAME","id_type",QTask,"sql_type","id");

  Table->Open();
   TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
 // NList->Add("TNAME");

   Table->SetSQLModify("syi_field_tbl",WList,NList,true,false,false);

 // Table->IndexFieldNames="name_task,name";
 //Table->IndexFieldNames="name";

  TWTField *Field;
  Field = WGrid->AddColumn("name", "��������", "��������");
  Field->SetWidth(150);
   Field = WGrid->AddColumn("tname", "���", "���");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("note", "����������", "����������");
   Field->SetWidth(150);
  Field = WGrid->AddColumn("def", "��������", "��������");
   Field->SetWidth(100);
     Field = WGrid->AddColumn("act", "���������", "���������");
  Field->AddFixedVariable("1", "�������");
  Field->AddFixedVariable("0","       ");
  Field->AddFixedVariable("2","�� ���������");
  Field->SetDefValue("0");
  Field->SetWidth(80);

    Field = WGrid->AddColumn("ord", "�������", "�������");
  Field->SetWidth(15);

   Field = WGrid->AddColumn("flag_repl", "�������������", "�������������");
  Field->AddFixedVariable("True", " �� ");
  Field->AddFixedVariable("False","    ");
  Field->SetDefValue("False");
  Field->SetWidth(80);

  Field = WGrid->AddColumn("key", "��������", "��������");
  Field->AddFixedVariable("True", " �� ");
  Field->AddFixedVariable("False","    ");
  Field->SetDefValue("False");
  Field->SetWidth(80);
   /*
    Field = WGrid->AddColumn("id_task", "������", "������");
     Field->SetWidth(50);
  Field = WGrid->AddColumn("name_task", "������", "������");
     Field->SetWidth(150);
  Field = WGrid->AddColumn("act", "���������", "���������");
  Field->AddFixedVariable("1", "�������");
  Field->AddFixedVariable("0","       ");
  Field->AddFixedVariable("2","�� ���������");
  Field->SetDefValue("0");
  Field->SetWidth(80);
    */
  //WGrid->DBGrid->ToolBar->AddButton("Deletesh", "�������� <<��������>> ������", DelTable);

  WGrid->DBGrid->Visible = true;
  //WGrid->DBGrid->OnAccept = OnAcceptTable;
  WGrid->ShowAs(WinName);

}
#undef WinName

#define WinName "������ ������"
//---------------------------------------------------------------------------

__fastcall TfBaseTableA::TfBaseTableA(TComponent* Owner)
        : TWTForm(Owner)
{  int id_a;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();

  // TWinControl *Owner =  (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent
  // ���� ����� ���� ���� - ������������ � �������
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner)) {
   // return null;
  }

  QTabl=new TWTQuery(this);
  QTabl->Sql->Add("select t.*,f.id_type,f.name as field,  \
f.length,f.key,f.def,f.note as note_field       \
from syi_table_tbl t,syi_field_tbl f     \
where f.id_table=t.id                  \
order by t.act,t.id_task,t.name,f.id");
  //QTabl->Open();
  WGrid = new TWTWinDBGrid(this, QTabl,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Table = WGrid->DBGrid->Query;
  TWTQuery *QTask=new TWTQuery(this);
  QTask->Sql->Add("select id,name from syi_task_tbl order by id");
  QTask->Open();
  Table->AddLookupField("name_task","id_task",QTask,"name","id");

   TWTQuery *QType=new TWTQuery(this);
  QType->Sql->Add("select id,name from syi_type_tbl order by id");
  QType->Open();
  Table->AddLookupField("name_type","id_type",QType,"name","id");

  Table->Open();
   TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
 // NList->Add("name_task");

   Table->SetSQLModify("syi_table_tbl",WList,NList,true,true,true);

 // Table->IndexFieldNames="name_task,name";
 //Table->IndexFieldNames="name";
  TWTField *Field;
  Field = WGrid->AddColumn("name", "�������", "�������");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("note", "����������", "����������");
  Field->SetWidth(150);
  Field = WGrid->AddColumn("tbl_owner", "��������", "��������");
  Field->SetWidth(100);
  Field = WGrid->AddColumn("id_task", "������", "������");
  Field->SetWidth(50);
  Field = WGrid->AddColumn("name_task", "������", "������");
   Field->SetWidth(150);
  Field = WGrid->AddColumn("act", "���������", "���������");
  Field->AddFixedVariable("1", "�������");
  Field->AddFixedVariable("0","       ");
  Field->AddFixedVariable("2","�� ���������");
  Field->SetDefValue("0");

   Field = WGrid->AddColumn("Field", "����", "����");
  Field->SetWidth(150);
   Field = WGrid->AddColumn("name_type", "���", "���");
  Field->SetWidth(80);

   Field = WGrid->AddColumn("length", " �����", "����� ����");
  Field->SetWidth(80);

   Field = WGrid->AddColumn("key", " ����", "�������� ����");
  Field->SetWidth(150);
  Field->AddFixedVariable("1", "*");
  Field->AddFixedVariable("0"," ");
  Field->SetDefValue("0");

  Field = WGrid->AddColumn("note_field", "���������� ����", "���������� ����");
   Field->SetWidth(150);

  Field = WGrid->AddColumn("def", "��������", "��������");
   Field->SetWidth(100);
                    /*
     Field = WGrid->AddColumn("act", "���������", "���������");
  Field->AddFixedVariable("1", "�������");
  Field->AddFixedVariable("0","       ");
  Field->AddFixedVariable("2","�� ���������");
  Field->SetDefValue("0");
  Field->SetWidth(80);
  */


  Field->SetWidth(80);
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
}
        /*
 void _fastcall TfBaseTable::BasaTableA(TObject *Sender)
{   TfBaseTableA *fBaseTableA=new TfBaseTableA (this);
}
          */

#undef WinName          
