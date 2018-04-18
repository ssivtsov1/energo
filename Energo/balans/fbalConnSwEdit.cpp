//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "fbalConnSwEdit.h"                                 
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZUpdateSql"
#pragma resource "*.dfm"
TfbalConnSwitchEdit *fbalConnSwitchEdit;                              
TWTWinDBGrid *WFiderGrid;
//---------------------------------------------------------------------------
__fastcall TfbalConnSwitchEdit::TfbalConnSwitchEdit(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
  ZQBalans = new TWTQuery(Application);
  ZQBalans->MacroCheck=true;
  ZQBalans->Options<< doQuickOpen;
  ZQBalans->RequestLive=false;
  ZQBalans->CachedUpdates=false;
//  ZQBalans->Transaction->AutoCommit=true;

  ZQSelect->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------
void __fastcall TfbalConnSwitchEdit::sbFiderClick(TObject *Sender)
{
  TWTQuery *QueryAdr;
  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp from eqm_equipment_tbl as eq join eqm_fider_tbl as f on (f.code_eqp = eq.id) \
   where eq.type_eqp = 15 and f.id_voltage not in (4,42) order by eq.name_eqp; ");


  WFiderGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WFiderGrid->SetCaption("Фидера");

  TWTQuery* Query = WFiderGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  QueryAdr->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

//  Field = WFiderGrid->AddColumn("kindname", "Тип", "Тип");
  Field = WFiderGrid->AddColumn("name_eqp", "Наименование", "Наименование");

  WFiderGrid->DBGrid->FieldSource = WFiderGrid->DBGrid->Query->GetTField("id");

  WFiderGrid->DBGrid->StringDest = "-1";

  if(Sender == sbFider)
     WFiderGrid->DBGrid->OnAccept=PlaceAccept;

  if(Sender == sbFider2)
     WFiderGrid->DBGrid->OnAccept=FiderFilterAccept;

  WFiderGrid->DBGrid->Visible = true;
  WFiderGrid->DBGrid->ReadOnly=true;
  WFiderGrid->ShowAs("Выбор фидера");

}
//------------------------------------------------------------------------------
void __fastcall TfbalConnSwitchEdit::PlaceAccept (TObject* Sender)
{
   FiderId =WFiderGrid->DBGrid->Query->FieldByName("id")->AsInteger;
   edFiderName->Text =WFiderGrid->DBGrid->Query->FieldByName("name_eqp")->AsString;

}
//------------------------------------------------------------------------------
void __fastcall TfbalConnSwitchEdit::FiderFilterAccept (TObject* Sender)
{
   FiderFilterId =WFiderGrid->DBGrid->Query->FieldByName("id")->AsInteger;
   edFiderName2->Text =WFiderGrid->DBGrid->Query->FieldByName("name_eqp")->AsString;

   ZQSelect->Filter = "id_p_eqp = "+IntToStr(FiderFilterId);
   ZQSelect->Filtered = true;
}
//------------------------------------------------------------------------------
void __fastcall TfbalConnSwitchEdit::FormClose(TObject *Sender,
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

void __fastcall TfbalConnSwitchEdit::btCancelClick(TObject *Sender)
{
 Close();
}
//---------------------------------------------------------------------------

void __fastcall TfbalConnSwitchEdit::sbFider2ClClick(TObject *Sender)
{
   FiderFilterId =0;
   edFiderName2->Text ="";
   ZQSelect->Filtered = false;
}
//---------------------------------------------------------------------------
void TfbalConnSwitchEdit::ShowNew(void)
{
  Id =0;
  mode=0;
  ActiveControl = edDataB;
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="delete from bal_selstation_tmp ; ";
  ZQBalans->Sql->Add(sqlstr);

  sqlstr="insert into bal_selstation_tmp (id_st) \
  select code_eqp from eqm_compens_station_tbl as s \
  join (select code_eqp_inst, count(*)::::integer as eqp_cnt from eqm_compens_station_inst_tbl group by code_eqp_inst order by code_eqp_inst) as u on (s.code_eqp=u.code_eqp_inst) \
   where id_voltage in (3,31,32) and eqp_cnt > 0 ; ";
  ZQBalans->Sql->Add(sqlstr);

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQSelect->Open();

}
//---------------------------------------------------------------------------
void TfbalConnSwitchEdit::ShowData( int sw_id)
{
  Id =sw_id;
  mode=1;
  ActiveControl = edDataB;
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="select sw.*, eq.name_eqp  from bal_switching_tbl as sw left join eqm_equipment_tbl as eq on (sw.id_fider = eq.id) where sw.id = :id ; ";
  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("id")->AsInteger=Id;
  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  FiderId = ZQBalans->FieldByName("id_fider")->AsInteger;

  if (!ZQBalans->FieldByName("dt_on")->IsNull)
     edDataB->Text = FormatDateTime("dd.mm.yyyy hh:nn",ZQBalans->FieldByName("dt_on")->AsDateTime);

  if (!ZQBalans->FieldByName("dt_off")->IsNull)
     edDataE->Text = FormatDateTime("dd.mm.yyyy hh:nn",ZQBalans->FieldByName("dt_off")->AsDateTime);

  mComment->Text =ZQBalans->FieldByName("comment")->AsString;
  edFiderName->Text =ZQBalans->FieldByName("name_eqp")->AsString;


  ZQBalans->Close();

  ZQBalans->Sql->Clear();

  sqlstr="delete from bal_selstation_tmp ; ";
  ZQBalans->Sql->Add(sqlstr);

  sqlstr="insert into bal_selstation_tmp (id_st,selected, correct) \
   select code_eqp, CASE WHEN co.id_st is null THEN 0 ELSE 1 END, \
   CASE WHEN coalesce(eqp_cnt,0) = 0 THEN 0 ELSE 1 END \
   from eqm_compens_station_tbl as eq \
   left join bal_connector_oper_tbl as co on (eq.code_eqp = co.id_st and co.id_con = :id ) \
   left join (select code_eqp_inst, count(*)::::integer as eqp_cnt from eqm_compens_station_inst_tbl group by code_eqp_inst order by code_eqp_inst) as u on (eq.code_eqp=u.code_eqp_inst) \
    where (eq.id_voltage in (3,31,32) ) and (( coalesce(eqp_cnt,0) > 0) or (co.id_st is not null)) ; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id")->AsInteger=Id;

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQSelect->Open();

}
//---------------------------------------------------------------------------
void __fastcall TfbalConnSwitchEdit::DBGrid1DrawColumnCell(TObject *Sender,
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

    if (ZQSelect->FieldByName("correct")->AsInteger==1)
       DBGrid1->Canvas->Font->Color=clBlue;
    else
       DBGrid1->Canvas->Font->Color=clRed;

    DBGrid1->Canvas->TextOut(Rect.Right-2-DBGrid1->Canvas->TextWidth("J"),
        Rect.Top+1, "~");
   }
  }

}
//---------------------------------------------------------------------------

void __fastcall TfbalConnSwitchEdit::DBGrid1DblClick(TObject *Sender)
{
 ZQSelect->Edit();
 if(ZQSelect->FieldByName("selected")->AsInteger==1)
   ZQSelect->FieldByName("selected")->AsInteger=0;
 else
   ZQSelect->FieldByName("selected")->AsInteger=1;

 ZQSelect->Post();

}
//---------------------------------------------------------------------------

void __fastcall TfbalConnSwitchEdit::btOkClick(TObject *Sender)
{
 if(edDataB->Text=="  .  .       :  ")
 {
    ShowMessage("Не указана дата переключения!");
    return;
 }

 if(FiderId==0)
 {
    ShowMessage("Не указана фидер!");
    return;
 }

 if ((edDataB->Text!="  .  .       :  ")&&(edDataE->Text!="  .  .       :  "))
 {
    if (StrToDateTime(edDataB->Text)> StrToDateTime(edDataE->Text) )
    {
      ShowMessage("Дата начала больше даты окончания!");
      return;

    }
 }

 if (mode==0)
 {
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="insert into bal_switching_tbl (id_fider, dt_on,dt_off,comment) values (:id_fider, :dt_on, :dt_off, :comment) ; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id_fider")->AsInteger=FiderId;

   if (edDataB->Text!="  .  .       :  ")
       ZQBalans->ParamByName("dt_on")->AsDateTime=StrToDateTime(edDataB->Text);
   else
       ZQBalans->ParamByName("dt_on")->Clear();

   if (edDataE->Text!="  .  .       :  ")
       ZQBalans->ParamByName("dt_off")->AsDateTime=StrToDateTime(edDataE->Text);
   else
       ZQBalans->ParamByName("dt_off")->Clear();

   if (mComment->Text!="")
     ZQBalans->ParamByName("comment")->AsString=mComment->Text;

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQBalans->Sql->Clear();

  sqlstr="select currval('bal_switching_seq') as newid;";
  ZQBalans->Sql->Add(sqlstr);

  try
   {
    ZQBalans->Open();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

   Id = ZQBalans->FieldByName("newid")->AsInteger;
   ZQBalans->Close();

  ZQBalans->Sql->Clear();

  sqlstr="insert into bal_connector_oper_tbl (id_con,id_fider, id_st) select :id, :id_fider, id_st from bal_selstation_tmp where selected =1; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id")->AsInteger=Id;
  ZQBalans->ParamByName("id_fider")->AsInteger=FiderId;

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }
 }
 //-========================== Изменение ===================================== 
 if (mode==1)
 {
  ZQBalans->Sql->Clear();

  AnsiString sqlstr="update  bal_switching_tbl set id_fider = :id_fider, dt_on = :dt_on, dt_off = :dt_off, comment = :comment where id = :id  ; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id")->AsInteger=Id;
  ZQBalans->ParamByName("id_fider")->AsInteger=FiderId;

   if (edDataB->Text!="  .  .       :  ")
       ZQBalans->ParamByName("dt_on")->AsDateTime=StrToDateTime(edDataB->Text);
   else
       ZQBalans->ParamByName("dt_on")->Clear();

   if (edDataE->Text!="  .  .       :  ")
       ZQBalans->ParamByName("dt_off")->AsDateTime=StrToDateTime(edDataE->Text);
   else
       ZQBalans->ParamByName("dt_off")->Clear();

   if (mComment->Text!="")
     ZQBalans->ParamByName("comment")->AsString=mComment->Text;

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

  ZQBalans->Sql->Clear();

  sqlstr="delete from bal_connector_oper_tbl where id_con = :id; ";
  ZQBalans->Sql->Add(sqlstr);
  ZQBalans->ParamByName("id")->AsInteger=Id;

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }


  ZQBalans->Sql->Clear();
  sqlstr="insert into bal_connector_oper_tbl (id_con,id_fider, id_st) select :id, :id_fider, id_st from bal_selstation_tmp where selected =1; ";
  ZQBalans->Sql->Add(sqlstr);

  ZQBalans->ParamByName("id")->AsInteger=Id;
  ZQBalans->ParamByName("id_fider")->AsInteger=FiderId;

  try
   {
    ZQBalans->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZQBalans->Close();
    return;
   }

 }
 Close();
}
//---------------------------------------------------------------------------

void __fastcall TfbalConnSwitchEdit::edDataEClearClick(TObject *Sender)
{
 edDataE->Text = "  .  .       :  ";       
}
//---------------------------------------------------------------------------

