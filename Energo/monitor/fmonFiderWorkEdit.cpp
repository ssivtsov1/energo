//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "fmonFiderWorkEdit.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZUpdateSql"
#pragma link "CurrEdit"
#pragma link "ToolEdit"
#pragma resource "*.dfm"
TfMonitorFiderWorkEdit *fMonitorFiderWorkEdit;
TWTWinDBGrid *WFiderGrid;
TWTDBGrid* WAbonGrid;
TWTDBGrid* WPosGrid;
//---------------------------------------------------------------------------
__fastcall TfMonitorFiderWorkEdit::TfMonitorFiderWorkEdit(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  ZQBalans = new TWTQuery(this);
 // ZQBalans->MacroCheck=true;
  ZQBalans->Options<< doQuickOpen;
  ZQBalans->RequestLive=false;
  ZQBalans->CachedUpdates=false;
//  ZQBalans->Transaction->AutoCommit=true;

  ZQWorkType->Database=TWTTable::Database;

}
//---------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorkEdit::sbFiderClick(TObject *Sender)
{
  TWTQuery *QueryAdr;
  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp from eqm_equipment_tbl as eq where eq.type_eqp = 15  order by eq.name_eqp; ");


  WFiderGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WFiderGrid->SetCaption("������");

  TWTQuery* Query = WFiderGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  QueryAdr->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

//  Field = WFiderGrid->AddColumn("kindname", "���", "���");
  Field = WFiderGrid->AddColumn("name_eqp", "������������", "������������");

  WFiderGrid->DBGrid->FieldSource = WFiderGrid->DBGrid->Query->GetTField("id");

  WFiderGrid->DBGrid->StringDest = "-1";

  if(Sender == sbFider)
     WFiderGrid->DBGrid->OnAccept=PlaceAccept;

  WFiderGrid->DBGrid->Visible = true;
  WFiderGrid->DBGrid->ReadOnly=true;
  WFiderGrid->ShowAs("����� ������");

}
//------------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorkEdit::PlaceAccept (TObject* Sender)
{
   FiderId =WFiderGrid->DBGrid->Query->FieldByName("id")->AsInteger;
   edFiderName->Text =WFiderGrid->DBGrid->Query->FieldByName("name_eqp")->AsString;
}
//------------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorkEdit::FormClose(TObject *Sender,
      TCloseAction &Action)
{
 TfTWTCompForm::FormClose(Sender,Action);
 ZQWorkType->Close();


 try{
  qParent->Refresh();
 }
 catch(...){};

 Action = caFree;
}
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorkEdit::btCancelClick(TObject *Sender)
{
 Close();
}
//---------------------------------------------------------------------------
void TfMonitorFiderWorkEdit::ShowNew(void)
{
  Id =0;
  mode=0;
  ActiveControl = edData;
  ZQWorkType->Open();

  if( FiderId !=0)
  {
    ZQBalans->Sql->Clear();

    AnsiString sqlstr="select name_eqp from  eqm_equipment_tbl where id = :id ; ";
    ZQBalans->Sql->Add(sqlstr);
    ZQBalans->ParamByName("id")->AsInteger=FiderId;
    try
     {
      ZQBalans->Open();
     }
    catch(...)
    {
     ShowMessage("������ SQL :"+sqlstr);
     ZQBalans->Close();
     return;
    }

    edFiderName->Text =ZQBalans->FieldByName("name_eqp")->AsString;

    ZQBalans->Close();
  }
}
//---------------------------------------------------------------------------
void TfMonitorFiderWorkEdit::ShowData( int sw_id)
{
  Id =sw_id;
  mode=1;
  ActiveControl = edData;
  ZQWorkType->Open();

  ZQBalans->Sql->Clear();

  AnsiString sqlstr="select sw.*, eq.name_eqp , pos.represent_name, c.short_name, c.code \
  from mnm_fider_works_tbl as sw \
  left join eqm_equipment_tbl as eq on (sw.id_fider = eq.id) \
  left join clm_position_tbl as pos on (pos.id = sw.id_position) \
  left join clm_client_tbl as c on (c.id=sw.id_client) \
  where sw.id = :id ; ";

  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("id")->AsInteger=Id;
  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  FiderId = ZQBalans->FieldByName("id_fider")->AsInteger;

  InspectorId=ZQBalans->FieldByName("id_position")->AsInteger;
  edInspector->Text=ZQBalans->FieldByName("represent_name")->AsString;

  AbonId=ZQBalans->FieldByName("id_client")->AsInteger;
  edAbonName->Text=ZQBalans->FieldByName("short_name")->AsString;
  edAbonCode->Text=ZQBalans->FieldByName("code")->AsString;

  if (!ZQBalans->FieldByName("dt_work")->IsNull)
     edData->Text = FormatDateTime("dd.mm.yyyy",ZQBalans->FieldByName("dt_work")->AsDateTime);

  mComment->Text =ZQBalans->FieldByName("comment")->AsString;
  edFiderName->Text =ZQBalans->FieldByName("name_eqp")->AsString;
  lcWork->LookupValue = ZQBalans->FieldByName("id_type")->AsInteger;
  edObject->Text =ZQBalans->FieldByName("object_name")->AsString;
  edCnt->Value = ZQBalans->FieldByName("cnt")->AsFloat;

  ZQBalans->Close();

}
//---------------------------------------------------------------------------


void __fastcall TfMonitorFiderWorkEdit::btOkClick(TObject *Sender)
{
 if(edData->Text=="  .  .       :  ")
 {
    ShowMessage("�� ������� ���� ������!");
    return;
 }

 if(FiderId==0)
 {
    ShowMessage("�� ������� �����!");
    return;
 }

 if ((lcWork->LookupValue=="")||(lcWork->LookupValue=="0"))
 {
    ShowMessage("�� ������� ��� ������!");
    return;
 }


 if (mode==0)
 {
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="insert into mnm_fider_works_tbl (id_fider, id_type, object_name, dt_work,cnt,comment, id_position, id_client ) values (:id_fider, :id_type, :object_name, :dt_work, :cnt, :comment, :id_position, :id_client) ; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id_fider")->AsInteger=FiderId;
  ZQBalans->ParamByName("id_client")->AsInteger=AbonId;
  ZQBalans->ParamByName("id_position")->AsInteger=InspectorId;

  ZQBalans->ParamByName("dt_work")->AsDateTime=StrToDateTime(edData->Text);

  if (mComment->Text!="")
     ZQBalans->ParamByName("comment")->AsString=mComment->Text;

  if (edObject->Text!="")
     ZQBalans->ParamByName("object_name")->AsString=edObject->Text;

  if ((lcWork->LookupValue!="")&&(lcWork->LookupValue!="0"))
     ZQBalans->ParamByName("id_type")->AsInteger =StrToInt(lcWork->LookupValue);

  ZQBalans->ParamByName("cnt")->AsFloat=edCnt->Value;

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
 }
 //-========================== ��������� =====================================
 if (mode==1)
 {
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="update  mnm_fider_works_tbl set id_fider = :id_fider, dt_work = :dt_work, id_type = :id_type, object_name = :object_name, cnt = :cnt, comment = :comment, id_position = :id_position, id_client = :id_client where id = :id  ; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id")->AsInteger=Id;
  ZQBalans->ParamByName("id_fider")->AsInteger=FiderId;
  ZQBalans->ParamByName("id_client")->AsInteger=AbonId;
  ZQBalans->ParamByName("id_position")->AsInteger=InspectorId;


  ZQBalans->ParamByName("dt_work")->AsDateTime=StrToDateTime(edData->Text);

  if (mComment->Text!="")
     ZQBalans->ParamByName("comment")->AsString=mComment->Text;

  if (edObject->Text!="")
     ZQBalans->ParamByName("object_name")->AsString=edObject->Text;

  if ((lcWork->LookupValue!="")&&(lcWork->LookupValue!="0"))
     ZQBalans->ParamByName("id_type")->AsInteger =StrToInt(lcWork->LookupValue);

  ZQBalans->ParamByName("cnt")->AsFloat=edCnt->Value;

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
 }
 Close();
}
//---------------------------------------------------------------------------



void __fastcall TfMonitorFiderWorkEdit::SpeedButton1Click(TObject *Sender)
{
 AbonId=0;
 edAbonName->Text="";
 edAbonCode->Text="";

 ZQWorkType->Filtered = false;
}
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorkEdit::sbAbonClick(TObject *Sender)
{
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

  WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorkEdit::AbonAccept (TObject* Sender)
{
  AbonId=WAbonGrid->Query->FieldByName("id")->AsInteger;
  edAbonName->Text=WAbonGrid->Query->FieldByName("short_name")->AsString;
  edAbonCode->Text=WAbonGrid->Query->FieldByName("code")->AsString;

  ZQWorkType->Filter  = "id_grp = 3";
  ZQWorkType->Filtered = true;

}
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorkEdit::edAbonCodeKeyPress(TObject *Sender,
      char &Key)
{
 if ((Key==VK_RETURN)&&(edAbonCode->Text!=""))
 {

  AnsiString sqlstr= "select id, short_name, name from clm_client_tbl where code = :code and book =-1 limit 1;";
  ZQBalans->Sql->Clear();
  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("code")->AsString =edAbonCode->Text ;
  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }
   if (ZQBalans->RecordCount>0)
   {
    AbonId=ZQBalans->FieldByName("id")->AsInteger;
    edAbonName->Text=ZQBalans->FieldByName("short_name")->AsString;

    ZQWorkType->Filter  = "id_grp = 3";
    ZQWorkType->Filtered = true;

   }
  ZQBalans->Close();

 }

}
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorkEdit::sbInspectorClClick(TObject *Sender)
{
 InspectorId = 0;
 edInspector->Text ="";
}
//---------------------------------------------------------------------------

void __fastcall TfMonitorFiderWorkEdit::sbInspectorClick(TObject *Sender)
{
  AnsiString EmpS="  ";
  TWTDBGrid* Grid;

  AnsiString filt="";

  TWTQuery *QuerRes=new TWTQuery(this);
  QuerRes->Sql->Add("select syi_resid_fun() as idres");
  QuerRes->Open();

  int id_res=QuerRes->FieldByName("idres")->AsInteger;
  filt="id_client="+ToStrSQL(id_res);

  Grid=MainForm->CliPositionSel(NULL,filt);
  if(Grid==NULL) return;
  else WPosGrid=Grid;

  WPosGrid->FieldSource= WPosGrid->Table->GetTField("id");

  WPosGrid->StringDest = EmpS;
  WPosGrid->OnAccept=PosAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfMonitorFiderWorkEdit::PosAccept (TObject* Sender)
{
  InspectorId=WPosGrid->Table->FieldByName("id")->AsInteger;
  edInspector->Text=WPosGrid->Table->FieldByName("represent_name")->AsString;
};
//---------------------------------------------------------------------------


