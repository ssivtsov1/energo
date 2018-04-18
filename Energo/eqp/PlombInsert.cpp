//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "PlombInsert.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "RxLookup"
#pragma link "ToolEdit"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPlombNew *fPlombNew;
//---------------------------------------------------------------------------
__fastcall TfPlombNew::TfPlombNew(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  ZQuery = new TWTQuery(Application);
  ZQuery->MacroCheck=true;
  ZQuery->Options<< doQuickOpen;
  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;

  ZMeterQuery = new TWTQuery(Application);
  ZMeterQuery->Options<< doQuickOpen;

//  ZQBalans->Transaction->AutoCommit=true;

  ZQPoint->Database=TWTTable::Database;
  ZQType->Database=TWTTable::Database;
  ZQPosition->Database=TWTTable::Database;
  ZQPosition_off->Database=TWTTable::Database;

  id_client=0;
  id_point=0;

}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);

 try{
  qParent->Refresh();
 }
 catch(...){};

 Action = caFree;
        
}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::btCancelClick(TObject *Sender)
{
 Close();        
}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::btOkClick(TObject *Sender)
{
 int operation;
 int id_meter;

 if(edDateB->Text=="  .  .    ")
 {
    ShowMessage("Не указана дата установки!");
    return;
 }

 if(id_point==0)
 {
    ShowMessage("Не указана точка учета!");
    return;
 }

 int id_type = StrToInt(lcType->LookupValue);

  ZQuery->Sql->Clear();

  AnsiString sqlstr="insert into clm_plomb_tbl (id_client, id_point, id_type, id_position, id_position_off, \
            plomb_num, plomb_owner, object_name, dt_b, dt_e, comment) values ( :id_client,  :id_point,  :id_type,  :id_position,  :id_position_off, \
             :plomb_num,  :plomb_owner,  :object_name,  :dt_b,  :dt_e,  :comment) ; ";
  ZQuery->Sql->Add(sqlstr);

  ZQuery->ParamByName("id_client")->AsInteger=id_client;
  ZQuery->ParamByName("id_point")->AsInteger=id_point;

  if ((lcType->LookupValue!="")&&(lcType->LookupValue!="0"))
     ZQuery->ParamByName("id_type")->AsInteger =id_type;

  if ((lcPosition->LookupValue!="")&&(lcPosition->LookupValue!="0"))
     ZQuery->ParamByName("id_position")->AsInteger =StrToInt(lcPosition->LookupValue);

  if ((lcPosition_off->LookupValue!="")&&(lcPosition_off->LookupValue!="0"))
     ZQuery->ParamByName("id_position_off")->AsInteger =StrToInt(lcPosition_off->LookupValue);

   if (edDateB->Text!="  .  .    ")
       ZQuery->ParamByName("dt_b")->AsDateTime=StrToDateTime(edDateB->Text);
   else
       ZQuery->ParamByName("dt_b")->Clear();

   if (edDateE->Text!="  .  .    ")
       ZQuery->ParamByName("dt_e")->AsDateTime=StrToDateTime(edDateE->Text);
   else
       ZQuery->ParamByName("dt_e")->Clear();

   if (edComment->Text!="")
     ZQuery->ParamByName("comment")->AsString=edComment->Text;

   if (edNumber->Text!="")
     ZQuery->ParamByName("plomb_num")->AsString=edNumber->Text;

   if (edLocation->Text!="")
     ZQuery->ParamByName("object_name")->AsString=edLocation->Text;

   if (edPlombOwner->Text!="")
     ZQuery->ParamByName("plomb_owner")->AsString=edPlombOwner->Text;

  try
   {
    ZQuery->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }

   // ----- на счетчиках ставим отметку, если устанавливается магнитная пломба
   if ((id_type ==10)||(id_type ==11)||(id_type ==16))
   {

    if(MessageDlg("Встановлена магнітна пломба. Встановити відповідну позначку на лічильниках?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes)
    {
     AnsiString sqlstr2=" select id_meter from eqm_meter_point_h where id_point = :id_point and dt_e is null and dt_b <= :dt; ";
     ZMeterQuery->Sql->Clear();
     ZMeterQuery->Sql->Add(sqlstr2);
     ZMeterQuery->ParamByName("id_point")->AsInteger=id_point;
     ZMeterQuery->ParamByName("dt")->AsDateTime=StrToDateTime(edDateB->Text);

     try
     {
       ZMeterQuery->Open();
     }
     catch(...)
     {
       ShowMessage("Ошибка SQL :"+sqlstr2);
       ZMeterQuery->Close();
       return;
     }


     for(int i=1;i<=ZMeterQuery->RecordCount;i++)
     {
      id_meter =  ZMeterQuery->FieldByName("id_meter")->AsInteger;

      operation=MainForm->PrepareChange(ZQuery,1,0,id_meter,0,1,StrToDateTime(edDateB->Text));
      if (operation ==-1)  return;

      sqlstr="update eqm_meter_tbl set magnet = 1 where code_eqp = :id_meter; ";
      ZQuery->Sql->Clear();
      ZQuery->Sql->Add(sqlstr);

      ZQuery->ParamByName("id_meter")->AsInteger=id_meter;

      try
      {
        ZQuery->ExecSql();
      }
      catch(...)
      {
        ShowMessage("Ошибка SQL :"+sqlstr);
        ZQuery->Close();
        return;
      }

      ZMeterQuery->Next();
     }

     ZMeterQuery->Close();


    }
   }

 Close();
}
//---------------------------------------------------------------------------
void TfPlombNew::ShowNew(void)
{
  Id =0;
  mode=0;
  ActiveControl = lcPoint;
  ZQuery->Sql->Clear();

  ZQPoint->ParamByName("client")->AsInteger = id_client;
  ZQPoint->Open();
  ZQType->Open();
  ZQPosition->Open();
  ZQPosition_off->Open();

  if(id_point!=0)
  {
    lcPoint->LookupValue=id_point;
    lAddr->Caption=ZQPoint->FieldByName("adr")->AsString;
  }

}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::sbDateClearClick(TObject *Sender)
{
 edDateE->Text = "  .  .    ";        
}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::bEqpTypeSelClick(TObject *Sender)
{
  Application->CreateForm(__classid(TfTreeForm), &fSelectTree);
  fSelectTree->tTreeEdit->OnDblClick=tTreeEditDblClick;
  //fSelectTree->OnCloseQuery=FormCloseQuery;
  //BorderParent=0;

  fSelectTree->ShowTrees(id_client,true);

}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::tTreeEditDblClick(TObject *Sender)
{
if ((fSelectTree->CurrNode!=NULL)&&(fSelectTree->CurrNode->ImageIndex!=0))
 {
  if((PTreeNodeData(fSelectTree->CurrNode->Data))->type_eqp!=12)
  {
    ShowMessage("Выберите точку учета");
  }
  else
  {
   lcPoint->LookupValue=fSelectTree->CurrNode->StateIndex;
   id_point =fSelectTree->CurrNode->StateIndex;
   lAddr->Caption=ZQPoint->FieldByName("adr")->AsString;
   fSelectTree->Close();
  }
 }
}
//---------------------------------------------------------------------------
void __fastcall TfPlombNew::lcPointCloseUp(TObject *Sender)
{
  lAddr->Caption=ZQPoint->FieldByName("adr")->AsString;
  id_point =StrToInt(lcPoint->LookupValue);
}
//---------------------------------------------------------------------------

void __fastcall TfPlombNew::edDateBClick(TObject *Sender)
{
if (edDateB->Text=="  .  .    ") edDateB->SelStart=0;
}
//---------------------------------------------------------------------------

void __fastcall TfPlombNew::edDateEClick(TObject *Sender)
{
if (edDateE->Text=="  .  .    ") edDateE->SelStart=0;        
}
//---------------------------------------------------------------------------



