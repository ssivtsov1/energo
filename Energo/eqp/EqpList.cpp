//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "EqpList.h"
#include "ftree.h"
//#include "fEqpBase.h"

__fastcall TfEqpList::TfEqpList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int kind,AnsiString AddFilds[],AnsiString AddFildsName[],int FildsCount,
           AnsiString WinName, bool IsInsert):TWTWinDBGrid(owner,query,IsMDI)
{
  kindid=kind;
  ReadOnly=!IsInsert;
  if (ReadOnly) DBGrid->ReadOnly=true;
  TWTQuery* Query = DBGrid->Query;
 // Query->AddLookupField("NAME_ADR", "id_addres", "adv_address_tbl", "full_adr","id");
//  Query->AddLookupField("NAME_CL", "id_client", "clm_client_tbl", "short_name","id");
//  Query->AddLookupField("NAME_USE", "useclient", "clm_client_tbl", "short_name","id");
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
  if (kindid==1)
  {
   Field = AddColumn("num_eqp", "�����", "��������� �����");
   Field->SetReadOnly();
  };

  //if (kindid==12)
  {
   Field = AddColumn("id", "���", "��� ������������");
   Field->SetReadOnly();
  };

// if (name_table_ind!="")
 if (Query->FindField("type")!=NULL)
     {
       Field = AddColumn("type", "���", "���");
       Field->SetReadOnly();
     }

  for (int k=0;k<=FildsCount-1;k++)
     {
       Field = AddColumn(AddFilds[k], AddFildsName[k],AddFildsName[k]);
       Field->SetReadOnly();
     }
  Field = AddColumn("dt_install", "���� ���������", "���� ���������");
  Field->SetReadOnly();
  Field = AddColumn("CODE_CL", "����. ", "����������� ��������");
  Field->SetReadOnly();
  Field = AddColumn("NAME_CL", "����������� ��������", "����������� ��������");
  Field->SetReadOnly();
  Field = AddColumn("CODE_USE", "���. ", "���������� �������");
  Field->SetReadOnly();
  Field = AddColumn("NAME_USE", "���������� �������", "���������� �������");
  Field->SetReadOnly();

  if ((kindid==12)||(kindid==1)||(kindid==10))
  {
   Field = AddColumn("NAME_ADR", "������", "������");
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
void _fastcall TfEqpList::NewEqpGr(TWTDBGrid *Sender) {

  if (!ReadOnly) NewEqp(Sender);
  DBGrid->Query->Refresh();
};
//---------------------------------------------------------------------------

void __fastcall TfEqpList::NewEqp(TObject* Sender)
{
//
 TfEqpEdit *EqpEdit;
// if (WEqpGrid->DBGrid->Query->FieldByName("id")->IsNull) return;

 Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
 EqpEdit->Align=alNone;
 //EqpEdit->FormStyle=fsMDIChild;
 EqpEdit->DragKind=dkDrag;
 EqpEdit->ParentDataSet=DBGrid->Query;
 EqpEdit->ShowAs("TheNewEquip");
// EqpEdit->Visible=;
 EqpEdit->CreateNewByType(kindid,Caption);

}
//---------------------------------------------------------------------------
void __fastcall TfEqpList::EqpAccept (TObject* Sender)
{
 TfEqpEdit *EqpEdit;
 if (DBGrid->Query->FieldByName("id")->IsNull) return;


 Application->CreateForm(__classid(TfTreeForm), &fTreeForm);

 int abon_id=DBGrid->Query->FieldByName("id_client")->AsInteger;
 fTreeForm->ShowAs("treeform");
 //fTreeForm->Caption=GrClient->Table->FieldByName("name")->AsString;
 fTreeForm->ShowTrees(abon_id,false,DBGrid->Query->FieldByName("id")->AsInteger);

/*
 Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
 EqpEdit->Align=alNone;
// EqpEdit->FormStyle=fsMDIChild;
 EqpEdit->DragKind=dkDrag;
 EqpEdit->ParentDataSet=DBGrid->Query;
 EqpEdit->ShowAs("TheEquip");
// EqpEdit->Visible=;
 EqpEdit->ShowData(DBGrid->Query->FieldByName("id")->AsInteger);
// WEqpGrid->DBGrid->Query->FieldByName("id")->AsString;
*/

}
//--------------------------------------------------------------------
void __fastcall TfEqpList::DelEqp(TObject* Sender)
{
 try
 {
  OldDelEqp(Sender);
 }
 catch(...)
 {
  ShowMessage("������ ��������. �������� ������ ������ ������������.");
 }
}
//--------------------------------------------------------------------
#pragma package(smart_init)