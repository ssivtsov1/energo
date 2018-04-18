#include "DelEqpList.h"
//---------------------------------------------------------------------------

#include <vcl.h>
#include "fHist.h"
#pragma hdrstop

#include "EqpList.h"
#include "ftree.h"
#include "Main.h"
//#include "fEqpBase.h"

TfHistoryEdit *WHistoryEdit;

__fastcall TfDelEqpList::TfDelEqpList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int id_client, AnsiString ClientName):TWTWinDBGrid(owner,query,IsMDI)
{


  DBGrid->ReadOnly=true;
  TWTQuery* Query = DBGrid->Query;
  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");
//  if (IsInsert)
//    Query->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = AddColumn("name", "Тип", "Тип");
  Field->SetReadOnly();
  Field = AddColumn("id", "Код", "Код");
  Field->SetReadOnly();
  Field = AddColumn("name_eqp", "Наименование", "Наименование");
  Field->SetReadOnly();
  Field = AddColumn("num_eqp", "Номер", "Заводской номер");
  Field->SetReadOnly();
  Field = AddColumn("dt_install", "Дата установки", "Дата установки");
  Field->SetReadOnly();
  Field = AddColumn("dt_e", "Дата удаления", "Дата удаления");
  Field->SetReadOnly();

  DBGrid->OnAccept=EqpAccept;
  DBGrid->Visible = true;
  DBGrid->ReadOnly=true;
/*
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
   */
}
//---------------------------------------------------------------------------
/*
void _fastcall TfDelEqpList::NewEqpGr(TWTDBGrid *Sender) {

  if (!ReadOnly) NewEqp(Sender);
  DBGrid->Query->Refresh();
};
*/

//---------------------------------------------------------------------------
/*
void __fastcall TfDelEqpList::NewEqp(TObject* Sender)
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
*/
//---------------------------------------------------------------------------
void __fastcall TfDelEqpList::EqpAccept (TObject* Sender)
{
  if (DBGrid->Query->FieldByName("id")->AsInteger ==0) return;


  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (((TWTMainForm*)MainForm)->ShowMDIChild("История", Owner)) {
    return;
  }
  WHistoryEdit=new TfHistoryEdit(this,DBGrid->Query->FieldByName("id")->AsInteger,
  DBGrid->Query->FieldByName("type_eqp")->AsInteger,
  DBGrid->Query->FieldByName("name_table")->AsString,
  DBGrid->Query->FieldByName("name_table_ind")->AsString);

  WHistoryEdit->ShowAs("История изменений");
  WHistoryEdit->SetCaption("История изменений");

  WHistoryEdit->ID="История";

  WHistoryEdit->ShowData();
}
//--------------------------------------------------------------------
/*
void __fastcall TfDelEqpList::DelEqp(TObject* Sender)
{
 try
 {
  OldDelEqp(Sender);
 }
 catch(...)
 {
  ShowMessage("Ошибка удаления. Возможно данный объект используется.");
 }
}
*/
//--------------------------------------------------------------------
#pragma package(smart_init)
