//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "AreaList.h"
#include "fEqpBase.h"
#include "Main.h"

__fastcall TfAreaList::TfAreaList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int kind,int client,AnsiString WinName, bool IsInsert)
           :TWTWinDBGrid(owner,query,IsMDI)
{
  kindid=kind;
  ReadOnly=!IsInsert;
  abonent_id=client;
  if (ReadOnly) DBGrid->ReadOnly=true;
  TWTQuery* Query = DBGrid->Query;
//  Query->AddLookupField("NAME_ADR", "id_addres", "adv_address_tbl", "adr","id");

  if (client==0)
   Query->AddLookupField("NAME_CL", "id_client", "clm_client_tbl", "short_name","id");

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");
  if (IsInsert)
    Query->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,true);
  TWTField *Field;

  Field = AddColumn("name_eqp", "������������", "������������");
  Field->SetReadOnly();
  Field->SetWidth(150);

  Field = AddColumn("dt_install", "���� ���������", "���� ���������");
  Field->SetReadOnly();
  Field = AddColumn("adr", "������", "������");
  Field->SetWidth(200);  
  Field->SetReadOnly();

  if (client==0)
    {
     Field = AddColumn("NAME_CL", "�������", "�������");
     Field->SetReadOnly();
    }

  Field = AddColumn("eqp_cnt", "���.������", "���.������.");
  Field->SetReadOnly();

  if (kind==11)
  {
   Field = AddColumn("power", "��������", "��������");
   Field->SetReadOnly();

   Field = AddColumn("wtm", "����� ������", "����� ������");
   Field->SetReadOnly();
  }

  if (kind==15)
  {
   Field = AddColumn("voltage_min", "����������", "����������");
   Field->SetReadOnly();
  }

  if (kind==8)
  {
   Field = AddColumn("power", "��������", "��������");
   Field->SetReadOnly();

   Field = AddColumn("comp_cnt", "���.��", "���������� ���������������");
   Field->SetReadOnly();

   Field = AddColumn("p_regday", "P���.����", "P���. ����, ���");
   Field->SetReadOnly();

   Field = AddColumn("date_regday", "���� P���.����", "���� ������ P���. ����");
   Field->SetReadOnly();

  }


  DBGrid->BeforeInsert=NewEqpGr;
  DBGrid->OnAccept=EqpAccept;
  DBGrid->Visible = true;
//  DBGrid->ReadOnly=true;

  TWTToolBar* tb=DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="Full")
       tb->Buttons[i]->OnClick=EqpAccept;
    if ( btn->ID=="NewRecord")
       {
       if (IsInsert)
         tb->Buttons[i]->OnClick=NewEqp;
       else
         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
     {
     if (IsInsert)
       {
        OldDelEqp=tb->Buttons[i]->OnClick;
        tb->Buttons[i]->OnClick=DelEqp;
       }
     else
       tb->Buttons[i]->OnClick=NULL;
     }
   }
}
//---------------------------------------------------------------------------
void _fastcall TfAreaList::NewEqpGr(TWTDBGrid *Sender) {

  if (!ReadOnly) NewEqp(Sender);
  DBGrid->Query->Refresh();
};
//---------------------------------------------------------------------------

void __fastcall TfAreaList::NewEqp(TObject* Sender)
{
//
 TfEqpEdit *EqpEdit;

 Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
 EqpEdit->Align=alNone;

 EqpEdit->DragKind=dkDrag;
 EqpEdit->ParentDataSet=DBGrid->Query;
 EqpEdit->abonent_id=abonent_id;
 EqpEdit->ShowAs("TheNewEquip");

 EqpEdit->CreateNewByType(kindid,Caption);

}
//---------------------------------------------------------------------------
void __fastcall TfAreaList::EqpAccept (TObject* Sender)
{
 TfEqpEdit *EqpEdit;
 if (DBGrid->Query->FieldByName("id")->IsNull) return;

 Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
 EqpEdit->Align=alNone;
 EqpEdit->abonent_id=abonent_id;
 //EqpEdit->is_res=is_res;
 EqpEdit->DragKind=dkDrag;
 EqpEdit->ParentDataSet=DBGrid->Query;
 EqpEdit->ShowAs("TheEquip");

 EqpEdit->ShowData(DBGrid->Query->FieldByName("id")->AsInteger);

}
//--------------------------------------------------------------------
void __fastcall TfAreaList::DelEqp(TObject* Sender)
{
  TZPgSqlQuery *ZQHist;
  ZQHist = new TWTQuery(Application);
  ZQHist->Options<< doQuickOpen;
  ZQHist->RequestLive=false;
  ZQHist->CachedUpdates=false;
//  ZQTree->Transaction->AutoCommit=false;

 try
 {
  int operation=((TMainForm*)(Application->MainForm))->PrepareChange(ZQHist,4,0,DBGrid->Query->FieldByName("id")->AsInteger,0,true);

 if (operation ==-1)
 {
  //           tbCancelClick(Sender);
   return;
 };

  OldDelEqp(Sender);
  ((TMainForm*)(Application->MainForm))->AfterChange(ZQHist,operation,true);
 }
 catch(...)
 {
  ShowMessage("������ ��������. �������� ������ ������ ������������.");
 }
}
//--------------------------------------------------------------------
#pragma package(smart_init)
