//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "SysUser.h"
#include "SysUserPwdF.h"

//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------

 // ------------------------------------------------------------------------------
#define WinName "������������ � ������ "
_fastcall TfUser::TfUser(TWinControl *owner)  : TWTDoc(owner)
{ TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  if  (CheckLevelStrong("������������ � ������")==0) {
  //if  (CheckLevel("1111")==0) {
   return;
  };
  TWTQuery *Querfill;
  Querfill=new TWTQuery(this);
  Querfill->Sql->Add("select sys_fill_full_lvl()" );
  Querfill->ExecSql();

  QuerA=new TWTQuery(this);
  QuerA->Sql->Add("select id,name,flag_type from syi_user where flag_type=1" );
  TWTDBGrid* DBGrA=new TWTDBGrid(this, QuerA);
  QuerA->Open();

  TWTPanel* PGroup=this->MainPanel->InsertPanel(450,false,100);
  PGroup->Params->AddText("������ �������������",10,F,Classes::taCenter,false)->ID="NameGr";
  PGroup->Params->AddGrid(DBGrA,true)->ID="Group";

  QuerA->IndexFieldNames="NAME";
  TDataSource *DataSource=DBGrA->DataSource;

  TWTField *Field;
  Field = DBGrA->AddColumn("NAME", "������ �������������", "������������ ������");
  Field->SetWidth(300);

   TStringList *WListA=new TStringList();
   WListA->Add("id");
   TStringList *NListA=new TStringList();
   QuerA->SetSQLModify("syi_user",WListA,NListA,true,true,true);
   DBGrA->AfterInsert=AfterInsGroup;
  TWTPanel* PButton=this->MainPanel->InsertPanel(40,false,300);
  TSpeedButton* SBPasswd=new TSpeedButton(PButton);
  SBPasswd->Flat=true;
  SBPasswd->Glyph->LoadFromResourceName(0,"Lock");
  SBPasswd->Width=24;
  SBPasswd->Height=24;
  SBPasswd->Top=20;
  SBPasswd->Left=10;
  SBPasswd->ShowHint=true;
  SBPasswd->Hint="������";
  SBPasswd->OnClick=ClPassWD;
  SBPasswd->Parent=PButton;
 // PUser->Params->AddButton(SBPasswd,false)->ID="Btn1";
  SBLockU=new TSpeedButton(PButton);
  SBLockU->Flat=true;
  SBLockU->Glyph->LoadFromResourceName(0,"PassCheck");
  SBLockU->Width=24;
  SBLockU->Height=24;
  SBLockU->Top=60;
  SBLockU->Left=10;
  SBLockU->ShowHint=true;
  SBLockU->Hint="����� ������� ������������";
  SBLockU->OnClick=ClUserAccess;
  SBLockU->Parent=PButton;

    SBLockUG=new TSpeedButton(PButton);
  SBLockUG->Flat=true;
  SBLockUG->Glyph->LoadFromResourceName(0,"FILLING");
  SBLockUG->Width=24;
  SBLockUG->Height=24;
  SBLockUG->Top=100;
  SBLockUG->Left=10;
  SBLockUG->ShowHint=true;
  SBLockUG->Hint="����������  ������� ������������ ����� ������";
  SBLockUG->OnClick=ClUserAddGoupAccess;
  SBLockUG->Parent=PButton;

   // PUser->Params->AddButton(SBPasswd,false)->ID="Btn1";
  SBLockG=new TSpeedButton(PButton);
  SBLockG->Flat=true;
  SBLockG->Glyph->LoadFromResourceName(0,"Passlock");
  SBLockG->Width=24;
  SBLockG->Height=24;
  SBLockG->Top=140;
  SBLockG->Left=10;
  SBLockG->ShowHint=true;
  SBLockG->Hint="����� ������� ������";
  SBLockG->OnClick=ClGroupAccess;
  SBLockG->Parent=PButton;

   TWTPanel* PAll=this->MainPanel->InsertPanel(350,false,100);

  TWTPanel* PUser=PAll->InsertPanel(350,false,100);
   PUser->Params->AddText("����������",18,F,Classes::taCenter,false);

 // PUser->Params->AddButton(SBLock,false)->ID="Btn2";
  QuerU=new TWTQuery(this);
  QuerU->Sql->Add("select * from syi_user where flag_type!=1 or flag_type is null order by id_parent,name" );
  DBGrU = new TWTDBGrid(this, QuerU);
  PUser->Params->AddGrid(DBGrU, true)->ID="User";

  TWTQuery *QuerP=new TWTQuery(this);
  QuerP->Sql->Add("select id,represent_name  from clm_position_tbl \
                where represent_name is not null and id_client=syi_resid_fun();" );
  QuerP->Open();
  TWTQuery* QuerG=new TWTQuery(this);
  QuerG->Sql->Add("select id,name from syi_user where flag_type=1 order by name" );
    QuerG->Open();
  QuerU->AddLookupField("Person","id_person",QuerP,"represent_name","id");
  QuerU->AddLookupField("grp","id_parent",QuerG,"name","id");
  QuerU->IndexFieldNames = "name";
  QuerU->LinkFields = "id=id_parent";
  QuerU->MasterSource = DataSource;

  QuerU->Open();

  TWTField *FieldsU;

  FieldsU = DBGrU->AddColumn("grp", "������", "");
  FieldsU = DBGrU->AddColumn("Name", "������������", "");
  FieldsU = DBGrU->AddColumn("Person", "����������� ����", "");
  FieldsU = DBGrU->AddColumn("login_name", "�����", "");

   TStringList *WListI=new TStringList();
   WListI->Add("id");
   TStringList *NListI=new TStringList();
   QuerU->SetSQLModify("syi_user",WListI,NListI,true,true,true);

  DBGrU->AfterInsert=AfterInsGrParam;
  ShowAs(WinName);
  MainPanel->ParamByID("Group")->Control->SetFocus();
  MainPanel->ParamByID("User")->Control->SetFocus();
  MainPanel->ParamByID("Group")->Control->SetFocus();

};
__fastcall TfUser::~TfUser()
{
  Close();
};

void _fastcall TfUser::ClPassWD(TObject *Sender) {

Application->CreateForm(__classid(TFUserPwd), &FUserPwd);
FUserPwd->Show(this,QuerU->FieldByName("id")->AsInteger);

};

void _fastcall TfUser::ClUserAccess(TObject *Sender) {
TWTQuery *QUpdEnv=new TWTQuery(this);
QUpdEnv->Sql->Add("select sys_fill_full_lvl(  )");
QUpdEnv->ExecSql();
TfUserAccess *UsAccess=new TfUserAccess(this);

UsAccess->Show(this,QuerU->FieldByName("id")->AsInteger);

};
void _fastcall TfUser::ClGroupAccess(TObject *Sender) {
TWTQuery *QUpdEnv=new TWTQuery(this);
QUpdEnv->Sql->Add("select sys_fill_full_lvl(  )");
QUpdEnv->ExecSql();
TfUserAccess *UsAccess=new TfUserAccess(this);

UsAccess->Show(this,QuerA->FieldByName("id")->AsInteger);

};

void _fastcall TfUser:: ClUserAddGoupAccess (TObject *Sender) {
int id_usr;

 id_usr=DBGrU->DataSource->DataSet->FieldByName("id")->AsInteger;
TWTQuery *QUpdEnv=new TWTQuery(this);
QUpdEnv->Sql->Add("select sys_fill_lvl_group( :pid_usr  )");
QUpdEnv->ParamByName("pid_usr")->AsInteger=id_usr;
if (Ask("���������� ������������ ����� ������?") )
{QUpdEnv->ExecSql(); };
TfUserAccess *UsAccess=new TfUserAccess(this);
UsAccess->Show(this,QuerU->FieldByName("id")->AsInteger);

};

void _fastcall TfUser::AfterInsGrParam(TWTDBGrid *Sender)
{
Sender->DataSource->DataSet->FieldByName("flag_type")->AsInteger=0;
};

void _fastcall TfUser::AfterInsGroup(TWTDBGrid *Sender)
{
Sender->DataSource->DataSet->FieldByName("flag_type")->AsInteger=1;
};

void __fastcall  TfUser::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

#undef WinName

#define WinName "������ ������� "
_fastcall TfUserAccess::TfUserAccess(TWinControl *owner)  : TWTDoc(owner)
{
}

void __fastcall TfUserAccess::Show(TObject *Sender,int id_user)
{   QEnv=new TWTQuery(this);
    fid_user=id_user;
    QEnv->Sql->Clear();
    QEnv->Sql->Add("select u.*,e.name as envir from syi_user_lvl u ,syi_enviroment  e  \
          where u.id_usr=:pid_user and e.id=u.id_env  order by envir");
    QEnv->ParamByName("pid_user")->AsInteger=fid_user;
   // QEnv->Open();
    TFont* F=new TFont();
    F->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;

    TWTDBGrid* DBGrEnv=new TWTDBGrid(this, QEnv);

   TWTPanel* PEnv=this->MainPanel->InsertPanel(300,false,100);
   PEnv->Params->AddText("����� ��������",10,F,Classes::taCenter,false)->ID="NameGr";
   PEnv->Params->AddGrid(DBGrEnv,true)->ID="Group";

  // DBGrEnv->Query->AddLookupField("ENVIR","id_env","syi_enviroment","name","id");


     TStringList *WListL=new TStringList();
   WListL->Add("id_usr");
   WListL->Add("id_env");
   TStringList *NListL=new TStringList();
   NListL->Add("envir");
    DBGrEnv->Query->Open();
     QEnv->SetSQLModify("syi_user_lvl",WListL,NListL,true,true,true);


  TWTField *Field;
  Field = DBGrEnv->AddColumn("ENVIR", "�������������", "�������������");
  Field->SetWidth(300);
  Field = DBGrEnv->AddColumn("lvl", "���", "���");
  Field->AddFixedVariable("0","�������");
  Field->AddFixedVariable("1","������");
  Field->AddFixedVariable("3","������");
  Field->SetDefValue("0");
  DBGrEnv->Query->IndexFieldNames="ENVIR";
  ShowAs(WinName);
  MainPanel->ParamByID("Group")->Control->SetFocus();

};
__fastcall TfUserAccess::~TfUserAccess()
{
  Close();
};

void __fastcall  TfUserAccess::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

#define WinName "������ ������� "
_fastcall TfEnviroment::TfEnviroment(TWinControl *owner)  : TWTDoc(owner)
{ TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;

  TWTDBGrid* DBGrEnv=new TWTDBGrid(this, "syi_enviroment");

  TWTPanel* PEnv=this->MainPanel->InsertPanel(300,false,100);
  PEnv->Params->AddText("����� ��������",10,F,Classes::taCenter,false)->ID="NameGr";
  PEnv->Params->AddGrid(DBGrEnv,true)->ID="Group";
  DBGrEnv->Table->Open();

  TWTField *Field;
  Field = DBGrEnv->AddColumn("name", "�������������", "�������������");
  Field->SetWidth(300);
  Field = DBGrEnv->AddColumn("type_env", "���", "���");
  Field->AddFixedVariable("0","����");
  Field->AddFixedVariable("1","����");
  Field->SetDefValue("0");

  Field = DBGrEnv->AddColumn("default_rule", "������ �� ���������", "������ �� ���������");
  Field->AddFixedVariable("0","�������");
  Field->AddFixedVariable("1","������");
  Field->AddFixedVariable("3","������");

  ShowAs(WinName);
  MainPanel->ParamByID("Group")->Control->SetFocus();

};
__fastcall TfEnviroment::~TfEnviroment()
{
  Close();
};






void __fastcall  TfEnviroment::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

#undef WinName
int CheckLevel(AnsiString ClassName,int silent){
int lll;
TWTQuery *Check=new TWTQuery(Application);
Check->Sql->Add("select sys_check_lvl(:name)::::int as lvl; ");
Check->ParamByName("name")->AsString=ClassName;
 Check->Options<< doQuickOpen;
 Check->RequestLive=false;
 Check->CachedUpdates=false;
//  Check->Transaction->AutoCommit=false;
try {
 Check->Open();
 lll=Check->FieldByName("lvl")->AsInteger;
}
 catch(...) {lll=3;};
 delete Check;
if ((lll==0) && (silent!=1))
 ShowMessage( "                 ��� ���� �������.  \n ���������� � ���������� ��������������. ");
return  lll ; //C
}
int CheckLevelStrong(AnsiString ClassName,int silent){
int lll;
TWTQuery *Check=new TWTQuery(Application);
Check->Sql->Add("select sys_check_lvl_strong(:name)::::int as lvl; ");
Check->ParamByName("name")->AsString=ClassName;
 Check->Options<< doQuickOpen;
 Check->RequestLive=false;
 Check->CachedUpdates=false;
//  Check->Transaction->AutoCommit=false;
try {
Check->Open();
lll=Check->FieldByName("lvl")->AsInteger;
}
 catch(...) {lll=0;};
delete Check;
if ((lll==0) && (silent!=1))
 ShowMessage( "                 ��� ���� �������.  \n ���������� � ���������� ��������������. ");
return  lll ; //C
}

void UpdLevelStrong(AnsiString ClassName){
bool lll;
   lll=CheckLevelStrong(ClassName);
TWTQuery *Check=new TWTQuery(Application);
Check->Sql->Add("update syi_user_lvl  set lvl=3 \
                 from syi_enviroment e where id_usr in (0,1,10) and id_env=e.id  \
                 and e.name =:pname");
Check->ParamByName("pname")->AsString=ClassName;
 Check->Options<< doQuickOpen;
 Check->RequestLive=false;
 Check->CachedUpdates=false;
//  Check->Transaction->AutoCommit=false;
try {
Check->ExecSql();
}
 catch (...) {lll=true;};
delete Check;

}

int CheckLevelRead(AnsiString ClassName,int silent){
int lll;
TWTQuery *Check=new TWTQuery(Application);
Check->Sql->Add("select sys_check_lvl_read(:name)::::int as lvl; ");
Check->ParamByName("name")->AsString=ClassName;
 Check->Options<< doQuickOpen;
 Check->RequestLive=false;
 Check->CachedUpdates=false;
//  Check->Transaction->AutoCommit=false;
try {
Check->Open();
lll=Check->FieldByName("lvl")->AsInteger;
delete Check;
}
catch(...) {lll=1;};
if ((lll==0) && (silent!=1))
 ShowMessage( "                 ��� ���� �������.  \n ���������� � ���������� ��������������. ");
  return  lll ; //C
}
   /*
#define WinName "����� ������� "
_fastcall TfUserAccess::TfUserAccess(TWinControl *owner)  : TWTDoc(owner)
{ TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  QuerA=new TWTQuery(this);
  QuerA->Sql->Add("select id,id_parent,name from syi_user where id<>0 order by id_parent,id" );
  TWTDBGrid* DBGrA=new TWTDBGrid(this, QuerA);
  QuerA->Open();

  TWTPanel* PGroup=this->MainPanel->InsertPanel(300,false,100);
  PGroup->Params->AddText("������������",10,F,Classes::taCenter,false)->ID="NameGr";
  PGroup->Params->AddGrid(DBGrA,true)->ID="Group";

  QuerA->IndexFieldNames="NAME";
  TDataSource *DataSource=DBGrA->DataSource;

  TWTField *Field;
  Field = DBGrA->AddColumn("NAME", "������������", "");
  Field->SetWidth(300);

  TWTPanel* PButton=this->MainPanel->InsertPanel(40,false,300);
  TSpeedButton* SBPasswd=new TSpeedButton(PButton);
  SBPasswd->Flat=true;
  SBPasswd->Glyph->LoadFromResourceName(0,"Lock");
  SBPasswd->Width=24;
  SBPasswd->Height=24;
  SBPasswd->Top=20;
  SBPasswd->Left=10;
  SBPasswd->ShowHint=true;
  SBPasswd->Hint="������";
  SBPasswd->OnClick=ClPassWD;
  SBPasswd->Parent=PButton;
 // PUser->Params->AddButton(SBPasswd,false)->ID="Btn1";
  SBLock=new TSpeedButton(PButton);
  SBLock->Flat=true;
  SBLock->Glyph->LoadFromResourceName(0,"unLOCK");
  SBLock->Width=24;
  SBLock->Height=24;
  SBLock->Top=60;
  SBLock->Left=10;
  SBLock->ShowHint=true;
  SBLock->Hint="����� �������";
 // SBPrev->OnClick=PrevLevel;
  SBLock->Parent=PButton;


  TWTPanel* PUser=this->MainPanel->InsertPanel(350,false,100);
   PUser->Params->AddText("����������",18,F,Classes::taCenter,false);

 // PUser->Params->AddButton(SBLock,false)->ID="Btn2";
  QuerU=new TWTQuery(this);
  QuerU->Sql->Add("select * from syi_user where flag_type!=1 or flag_type is null order by id_parent,name" );
  DBGrU = new TWTDBGrid(this, QuerU);
   PUser->Params->AddGrid(DBGrU, true)->ID="User";

  TWTQuery *QuerP=new TWTQuery(this);
  QuerP->Sql->Add("select id,represent_name  from clm_position_tbl \
                where represent_name is not null and id_client=syi_resid_fun();" );
  QuerP->Open();
  QuerU->AddLookupField("Person","id_person",QuerP,"represent_name","id");
   QuerU->IndexFieldNames = "name";
  QuerU->LinkFields = "id=id_parent";
  QuerU->MasterSource = DataSource;

  QuerU->Open();

 // DBGrU->OnExit=ExitParamsGrid;
  TWTField *FieldsU;

  FieldsU = DBGrU->AddColumn("Name", "������������", "");
  FieldsU = DBGrU->AddColumn("Person", "����������� ����", "");
  FieldsU = DBGrU->AddColumn("login_name", "�����", "");

   TStringList *WListI=new TStringList();
   WListI->Add("id");
   TStringList *NListI=new TStringList();
  // NListI->Add("Person");
     QuerU->SetSQLModify("syi_user",WListI,NListI,true,true,true);


  //DBGrU->AfterInsert=AfterInsGrParam;
  //DBGrU->BeforePost=PostParam;
  TDataSource *DataSourceU=DBGrU->DataSource;
    ShowAs(WinName);
  MainPanel->ParamByID("Group")->Control->SetFocus();
  MainPanel->ParamByID("User")->Control->SetFocus();
  MainPanel->ParamByID("Group")->Control->SetFocus();

};
__fastcall TfUserAccess::~TfUserAccess()
{
  Close();
};

void _fastcall TfUserAccess::ClPassWD(TObject *Sender) {

Application->CreateForm(__classid(TFUserPwd), &FUserPwd);
FUserPwd->Show(this,QuerU->FieldByName("id")->AsInteger);

};


void _fastcall TfUserAccess::AfterInsGrParam(TWTDBGrid *Sender)
{

};

void __fastcall  TfUserAccess::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 Action = caFree;
 TWTDoc::OnClose(Sender,Action);

}

#undef WinName

     */



