//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "EqpSpr.h"
#include "SysUser.h"
#include "DBGrid.h"
//#include "ftree.h"
//#include "fEqpBase.h"

__fastcall TfEqpSpr::TfEqpSpr(TWinControl *owner, TWTQuery *query,bool IsMDI,
           bool def_list=false):TWTWinDBGrid(owner,query,IsMDI)
{
   def_mode=def_list;
   if (def_mode)
   {
    btAll=DBGrid->ToolBar->AddButton("AddCond", "������ ������", ShowAll);
    btDef=DBGrid->ToolBar->AddButton("RemCond", "����� ������������", ShowDef);
    btDef->Visible=false;

    
  int ChLevel =CheckLevelRead("���������� ������������");
  if  (ChLevel==0) {
      return;
   };
   if (ChLevel==1)
           DBGrid->SetReadOnly();

          //TWTDBGrid::DBGrid->ReadOnly=true;
         //TWTDBGrid::InitButtons();
    DBGrid->Query->AfterOpen=AfterOpen;

   }
}
//---------------------------------------------------------------------------

void __fastcall TfEqpSpr::ShowAll(TObject* Sender)
{
//
 btDef->Visible=true;
 btAll->Visible=false;
 DBGrid->Query->Filtered=false;
 DBGrid->Query->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpSpr::ShowDef(TObject* Sender)
{
//
 btDef->Visible=false;
 btAll->Visible=true;

 if (DBGrid->Query->FindField("show_def")!=NULL)
     {
      DBGrid->Query->Filter="show_def=1";
      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     }
}
//---------------------------------------------------------------------------
void __fastcall TfEqpSpr::AfterOpen(TDataSet* DataSet)
{
if ((DBGrid->Query->FindField("show_def")!=NULL)&&def_mode)
     {
      DBGrid->Query->Filter="show_def=1";
      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     }
}
//---------------------------------------------------------------------------
