//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fBal.h"
#include "Main.h"
#include "fBalRep.h"
#include "fCheckFider.h"                              
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma link "ZUpdateSql"
#pragma resource "*.dfm"
TfFiderCheck *fFiderCheck;
//---------------------------------------------------------------------------
__fastcall TfFiderCheck::TfFiderCheck(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  ZQBalans = new TWTQuery(Application);
  ZQBalans->MacroCheck=true;
  ZQBalans->Options<< doQuickOpen;
  ZQBalans->RequestLive=false;
  ZQBalans->CachedUpdates=false;
  ZQBalans->Transaction->AutoCommit=true;

  ZQSelect->Database=TWTTable::Database;
  cbAll->Checked = true;
  cbSelected->Checked = false;
}
//---------------------------------------------------------------------------
void __fastcall TfFiderCheck::FormShow(TObject *Sender)
{
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="delete from bal_selfider_tmp ; ";
  ZQBalans->Sql->Add(sqlstr);

  sqlstr="insert into bal_selfider_tmp (id_fider) select id from eqm_equipment_tbl where type_eqp = 15; ";
  ZQBalans->Sql->Add(sqlstr);

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQSelect->Open();
}
//---------------------------------------------------------------------------
void __fastcall TfFiderCheck::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);

 Action = caFree;

}
//---------------------------------------------------------------------------
void __fastcall TfFiderCheck::DBGrid1DrawColumnCell(TObject *Sender,
      const TRect &Rect, int DataCol, TColumn *Column,
      TGridDrawState State)
{
if(Column->FieldName=="selected")
  {
  DBGrid1->Canvas->Brush->Color=clWhite;
  DBGrid1->Canvas->FillRect(Rect);
  DBGrid1->Canvas->Font->Name="Webdings";
  DBGrid1->Canvas->Font->Size=-14;
  if (ZQSelect->FieldByName("selected")->AsInteger==1)
   {
    DBGrid1->Canvas->Font->Color=clBlue;
    DBGrid1->Canvas->TextOut(Rect.Right-2-DBGrid1->Canvas->TextWidth("J"),
        Rect.Top+1, "~");
   }
//  else
//   {
//    DBGrid1->Canvas->Font->Color=clBlack;
//    DBGrid1->Canvas->TextOut(Rect.Right-2-DBGrid1->Canvas->TextWidth(" "),
//       Rect.Top+1, " ");
//   }
  }

}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::DBGrid1DblClick(TObject *Sender)
{
 ZQSelect->Edit();
 if(ZQSelect->FieldByName("selected")->AsInteger==1)
   ZQSelect->FieldByName("selected")->AsInteger=0;
 else
   ZQSelect->FieldByName("selected")->AsInteger=1;

 ZQSelect->Post();

 cbSelected->Checked =true;
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::btOkClick(TObject *Sender)
{
//  ZQSelect->Transaction->Commit();
 if(cbAll->Checked)
   BalansReports->FidersToXL(0,mmgg);
 else
   BalansReports->FidersToXL(1,mmgg);
// else
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::cbAllClick(TObject *Sender)
{
 if (cbAll->Checked) cbSelected->Checked = false;        
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::cbSelectedClick(TObject *Sender)
{
 if (cbSelected->Checked) cbAll->Checked = false;        
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::nAllClick(TObject *Sender)
{
  ZQBalans->Sql->Clear();

  AnsiString sqlstr=" update bal_selfider_tmp set selected = 1 ; ";
  ZQBalans->Sql->Add(sqlstr);

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQSelect->Refresh();

}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::nNoClick(TObject *Sender)
{
  ZQBalans->Sql->Clear();

  AnsiString sqlstr=" update bal_selfider_tmp set selected = 0 ; ";
  ZQBalans->Sql->Add(sqlstr);

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQSelect->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::btCancelClick(TObject *Sender)
{
 Close();        
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::BitBtn1Click(TObject *Sender)
{
 if(cbAll->Checked)
   BalansReports->FidersToXLYear(0,mmgg);
 else
   BalansReports->FidersToXLYear(1,mmgg);
}
//---------------------------------------------------------------------------

void __fastcall TfFiderCheck::btKeyClick(TObject *Sender)
{
 if(cbAll->Checked)
   BalansReports->FidersToXL_key(0,mmgg);
 else
   BalansReports->FidersToXL_key(1,mmgg);

}
//---------------------------------------------------------------------------


