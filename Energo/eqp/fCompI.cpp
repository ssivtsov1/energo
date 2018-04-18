//---------------------------------------------------------------------------

#include <vcl.h>

#pragma hdrstop
#include "Main.h"
#include "fCompI.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfCompISpr *fCompSpr;
AnsiString sqlstr;
//---------------------------------------------------------------------------
__fastcall TfCompISpr::TfCompISpr(TComponent* Owner)
        : TfTWTCompForm(Owner,false)
{
  ZEqpQuery = new TWTQuery(Application);
  ZEqpQuery->MacroCheck=true;
  TZDatasetOptions Options;
  Options.Clear();
  Options << doQuickOpen;
  ZEqpQuery->Options=Options;
  ZEqpQuery->RequestLive=false;
  ZEqpQuery->CachedUpdates=false;

  ///----------------------------------------------------
/*  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
  }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("Схема подключения", true, ActivateMenu));
 */
  refresh=0;
}
//---------------------------------------------------------------------------
void __fastcall TfCompISpr::FormClose(TObject *Sender, TCloseAction &Action)
{
/*  int i = 7;
  while (i < MainForm->WindowMenuItem->Count &&
    MainForm->WindowMenuItem->Items[i] != WindowMenu) {
    i++;
  }
  if (MainForm->WindowMenuItem->Count && MainForm->WindowMenuItem->Items[i] == WindowMenu)
    MainForm->WindowMenuItem->Delete(i);
  // Если окон больше нет - удаляем разделитель
  if (MainForm->WindowMenuItem->Count == 8){
    MainForm->WindowMenuItem->Delete(7);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->RemoveToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
  };
  */
delete ZEqpQuery;
if (WCompIGrid!=NULL) ParentDataSet->Refresh();

TfTWTCompForm::FormClose(Sender,Action);
/////////////////////
//Action = caFree;
}
//---------------------------------------------------------------------------

//void _fastcall TfCompISpr::ActivateMenu(TObject *Sender) {
//  if (Enabled) Show();
//}
//---------------------------------------------------------------------------
void __fastcall TfCompISpr::ShowData(int compid)
{
   eqid=compid;
   //--------------------------------------

   if (mode==0)
   {
    MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("Новый тип трансформатора", true, ActivateMenu));
    Caption="Новый тип трансформатора";
    return;
   }
  //--------------------------------------

     edType->Text=ParentDataSet->FieldByName("Type")->AsString;
     edNormative->Text=ParentDataSet->FieldByName("Normative")->AsString;
     edVoltage_nom->Text=ParentDataSet->FieldByName("Voltage_nom")->AsString;
     edAmperage_nom->Text=ParentDataSet->FieldByName("amperage_nom")->AsString;

     edVoltage2_nom->Text=ParentDataSet->FieldByName("Voltage2_nom")->AsString;
     edAmperage2_nom->Text=ParentDataSet->FieldByName("amperage2_nom")->AsString;

     edVoltage_max->Text=ParentDataSet->FieldByName("Voltage_max")->AsString;
     edAmperage_max->Text=ParentDataSet->FieldByName("Amperage_max")->AsString;
     edSwathe->Text=ParentDataSet->FieldByName("Swathe")->AsString;
     edPower_nom->Text=ParentDataSet->FieldByName("Power_nom")->AsString;
     edAmperage_no_load->Text=ParentDataSet->FieldByName("Amperage_no_load")->AsString;
     edAccuracy->Text=ParentDataSet->FieldByName("Accuracy")->AsString;

     phaseid=ParentDataSet->FieldByName("phase")->AsInteger;
     conversionid=ParentDataSet->FieldByName("conversion")->AsInteger;
     hook_upid=ParentDataSet->FieldByName("Hook_up")->AsInteger;

     for (int i = 0; i<=phase_no-1;i++)
       {
         if (phaseid==phaseid_arr[i]) {cbPhase->ItemIndex=i;break;}
       }
     for (int i = 0; i<=hook_up_no-1;i++)
       {
         if (hook_upid==hook_upid_arr[i]) {cbHook_up->ItemIndex=i;break;}
       }
     for (int i = 0; i<=conversion_no-1;i++)
       {
         if (conversionid==conversionid_arr[i]) {cbConversion->ItemIndex=i;break;}
       }
   //-------------------
   if (refresh==0)
     MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem(edType->Text.c_str(), true, ActivateMenu));
     Caption=edType->Text;
   //-------------------

}
//---------------------------------------------------------------------------
 bool TfCompISpr::SaveData(void)
{
   ZEqpQuery->Close();

   sqlstr="update eqi_compensator_i_tbl set type= :type,normative= :normative,voltage_nom= :voltage_nom,voltage2_nom= :voltage2_nom,\
   amperage_nom= :amperage_nom,amperage2_nom= :amperage2_nom,voltage_max= :voltage_max,amperage_max= :amperage_max,phase= :phase,\
   swathe= :swathe, hook_up= :hook_up,power_nom= :power_nom,amperage_no_load= :amperage_no_load, Accuracy= :Accuracy,conversion= :conversion \
   where id= :id;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   if (edType->Text!="")
    ZEqpQuery->ParamByName("type")->AsString=edType->Text;
   if (edNormative->Text!="")
    ZEqpQuery->ParamByName("normative")->AsString=edNormative->Text;
   if (edVoltage_nom->Text!="")
    ZEqpQuery->ParamByName("voltage_nom")->AsInteger=StrToInt(edVoltage_nom->Text);
   if (edAmperage_nom->Text!="")
    ZEqpQuery->ParamByName("amperage_nom")->AsInteger=StrToInt(edAmperage_nom->Text);

   if (edVoltage2_nom->Text!="")
    ZEqpQuery->ParamByName("voltage2_nom")->AsInteger=StrToInt(edVoltage2_nom->Text);
   if (edAmperage2_nom->Text!="")
    ZEqpQuery->ParamByName("amperage2_nom")->AsInteger=StrToInt(edAmperage2_nom->Text);

   if (edVoltage_max->Text!="")
    ZEqpQuery->ParamByName("voltage_max")->AsInteger=StrToInt(edVoltage_max->Text);
   if (edAmperage_max->Text!="")
    ZEqpQuery->ParamByName("amperage_max")->AsInteger=StrToInt(edAmperage_max->Text);
   if (phaseid!=0)
    ZEqpQuery->ParamByName("phase")->AsInteger=phaseid;
   if (edSwathe->Text!="")
    ZEqpQuery->ParamByName("swathe")->AsInteger=StrToInt(edSwathe->Text);
   if (hook_upid!=0)
    ZEqpQuery->ParamByName("hook_up")->AsInteger=hook_upid;
   if (edPower_nom->Text!="")
    ZEqpQuery->ParamByName("power_nom")->AsInteger=StrToInt(edPower_nom->Text);
   if (edAmperage_no_load->Text!="")
    ZEqpQuery->ParamByName("amperage_no_load")->AsFloat=StrToFloat(edAmperage_no_load->Text);
   if (edAccuracy->Text!="")
    ZEqpQuery->ParamByName("Accuracy")->AsFloat=StrToFloat(edAccuracy->Text);
   if (conversionid!=0)
    ZEqpQuery->ParamByName("conversion")->AsInteger=conversionid;


   ZEqpQuery->ParamByName("id")->AsInteger=eqid;

   try
     {
      ZEqpQuery->ExecSql();
     }
   catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return 0;
     }
//  ZEqpQuery->Transaction->Commit();
  return 1;
}
//---------------------------------------------------------------------------

  bool TfCompISpr::SaveNewData(void)
{
   ZEqpQuery->Close();

//   sqlstr="select eqi_newcomp_i_fun( :type, :normative, :voltage_nom, :amperage_nom, :voltage_max, :amperage_max, :voltage2_nom, :amperage2_nom, :conversion, :phase, :swathe, :hook_up, :power_nom, :amperage_no_load, :accuracy);";
   sqlstr="insert into eqi_compensator_i_tbl (type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,voltage2_nom,amperage2_nom,conversion,phase,swathe,hook_up,power_nom,amperage_no_load,accuracy) \
   values ( :type, :normative, :voltage_nom, :amperage_nom, :voltage_max, :amperage_max, :voltage2_nom, :amperage2_nom, :conversion, :phase, :swathe, :hook_up, :power_nom, :amperage_no_load, :accuracy);";
   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   if (edType->Text!="")
    ZEqpQuery->ParamByName("type")->AsString=edType->Text;
   if (edNormative->Text!="")
    ZEqpQuery->ParamByName("normative")->AsString=edNormative->Text;
   if (edVoltage_nom->Text!="")
    ZEqpQuery->ParamByName("voltage_nom")->AsInteger=StrToInt(edVoltage_nom->Text);
   if (edAmperage_nom->Text!="")
    ZEqpQuery->ParamByName("amperage_nom")->AsInteger=StrToInt(edAmperage_nom->Text);

   if (edVoltage2_nom->Text!="")
    ZEqpQuery->ParamByName("voltage2_nom")->AsInteger=StrToInt(edVoltage2_nom->Text);
   if (edAmperage2_nom->Text!="")
    ZEqpQuery->ParamByName("amperage2_nom")->AsInteger=StrToInt(edAmperage2_nom->Text);

   if (edVoltage_max->Text!="")
    ZEqpQuery->ParamByName("voltage_max")->AsInteger=StrToInt(edVoltage_max->Text);
   if (edAmperage_max->Text!="")
    ZEqpQuery->ParamByName("amperage_max")->AsInteger=StrToInt(edAmperage_max->Text);
   if (phaseid!=0)
    ZEqpQuery->ParamByName("phase")->AsInteger=phaseid;
   if (edSwathe->Text!="")
    ZEqpQuery->ParamByName("swathe")->AsInteger=StrToInt(edSwathe->Text);
   if (hook_upid!=0)
    ZEqpQuery->ParamByName("hook_up")->AsInteger=hook_upid;
   if (edPower_nom->Text!="")
    ZEqpQuery->ParamByName("power_nom")->AsInteger=StrToInt(edPower_nom->Text);
   if (edAmperage_no_load->Text!="")
    ZEqpQuery->ParamByName("amperage_no_load")->AsFloat=StrToFloat(edAmperage_no_load->Text);
//   if (edK_compens->Text!="")
//    ZEqpQuery->ParamByName("k_compens")->AsInteger=StrToInt(edK_compens->Text);
   if (edAccuracy->Text!="")
    ZEqpQuery->ParamByName("Accuracy")->AsFloat=StrToFloat(edAccuracy->Text);
   if (conversionid!=0)
    ZEqpQuery->ParamByName("conversion")->AsInteger=conversionid;

   try
     {
      ZEqpQuery->ExecSql();
     }
   catch(...)
     {
      ShowMessage("Ошибка SQL :");
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return 0;
     }
   ZEqpQuery->Close();

   // получим id
   sqlstr="select currval('""eqi_devices_seq""');";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   try
     {
      ZEqpQuery->Open();
     }
   catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return 0;
     }

   if (ZEqpQuery->RecordCount!=0)
     {
      ZEqpQuery->First();
      eqid=ZEqpQuery->Fields->Fields[0]->AsInteger;
     }
   else
     {
     ZEqpQuery->Close();
//     ZEqpQuery->Transaction->Rollback();
     return 0;
     }

   ZEqpQuery->Close();
//   ZEqpQuery->Transaction->Commit();
   return 1;

}
//---------------------------------------------------------------------------
void __fastcall TfCompISpr::cbPhaseChange(TObject *Sender)
{
  phaseid=phaseid_arr[cbPhase->ItemIndex];
}
//---------------------------------------------------------------------------

void __fastcall TfCompISpr::cbHook_upChange(TObject *Sender)
{
  hook_upid=hook_upid_arr[cbHook_up->ItemIndex];
}
//---------------------------------------------------------------------------
void __fastcall TfCompISpr::cbConversionChange(TObject *Sender)
{
  conversionid=conversionid_arr[cbConversion->ItemIndex];
}
//---------------------------------------------------------------------------


void __fastcall TfCompISpr::tbSaveClick(TObject *Sender)
{
/* if ((edSwathe->Text!="2")&&(edSwathe->Text!="3"))
  {
   ShowMessage("Количество обмоток должно быть 2 или 3.");
   return;
  }
  */
 if (mode==0)
  {
   SaveNewData();
//   edSwathe->Enabled=false;
   mode=1;
  }
 else SaveData();
 if (WCompIGrid==NULL) return; //Таблицу уже закрыли
 ParentDataSet->Refresh();

 TLocateOptions SearchOptions;
 SearchOptions.Clear();
 ParentDataSet->Locate("id",eqid ,SearchOptions);

}
//---------------------------------------------------------------------------

void __fastcall TfCompISpr::tbCancelClick(TObject *Sender)
{
 if (mode==0)
  {
    Close();
  }
 else
  {
    refresh=1;
    if (WCompIGrid==NULL) {Close(); return; } //Таблицу уже закрыли
    ShowData(eqid);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfCompISpr::FormCreate(TObject *Sender)
{
   // Заполнить комбо
   sqlstr=" select id,name from eqk_conversion_tbl;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return;
   }
   ZEqpQuery->First();
   conversion_no=ZEqpQuery->RecordCount;
   for (int i = 0; i<=ZEqpQuery->RecordCount-1;i++)
   {
     cbConversion->Items->Add(ZEqpQuery->FieldByName("name")->AsString);
     conversionid_arr[i]=ZEqpQuery->FieldByName("id")->AsInteger;
     ZEqpQuery->Next();
   }
   ZEqpQuery->Close();
   //---------------------------
   sqlstr=" select id,name from eqk_phase_tbl;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return;
   }
   ZEqpQuery->First();
   phase_no=ZEqpQuery->RecordCount;
   for (int i = 0; i<=ZEqpQuery->RecordCount-1;i++)
   {
     cbPhase->Items->Add(ZEqpQuery->FieldByName("name")->AsString);
     phaseid_arr[i]=ZEqpQuery->FieldByName("id")->AsInteger;
     ZEqpQuery->Next();
   }
   ZEqpQuery->Close();
   //---------------------------
   sqlstr=" select id,name from eqk_hookup_tbl;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return;
   }
   ZEqpQuery->First();
   hook_up_no=ZEqpQuery->RecordCount;
   for (int i = 0; i<=ZEqpQuery->RecordCount-1;i++)
   {
     cbHook_up->Items->Add(ZEqpQuery->FieldByName("name")->AsString);
     hook_upid_arr[i]=ZEqpQuery->FieldByName("id")->AsInteger;
     ZEqpQuery->Next();
   }
   ZEqpQuery->Close();
}
//---------------------------------------------------------------------------


