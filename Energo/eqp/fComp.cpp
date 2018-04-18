//---------------------------------------------------------------------------

#include <vcl.h>

#pragma hdrstop
#include "Main.h"
#include "fComp.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfCompSpr *fCompSpr;
AnsiString sqlstr;
//---------------------------------------------------------------------------
__fastcall TfCompSpr::TfCompSpr(TComponent* Owner) : TfTWTCompForm(Owner,false)
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
void __fastcall TfCompSpr::FormClose(TObject *Sender, TCloseAction &Action)
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
 if (WCompGrid!=NULL) ParentDataSet->Refresh();

 TfTWTCompForm::FormClose(Sender,Action);
/////////////////////
//Action = caFree;
}
//---------------------------------------------------------------------------

//void _fastcall TfCompSpr::ActivateMenu(TObject *Sender) {
//  if (Enabled) Show();
//}
//---------------------------------------------------------------------------
void __fastcall TfCompSpr::ShowData(int compid)
{
   eqid=compid;
   //--------------------------------------

   if (mode==0)
   {
    MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("Новый тип трансформатора тока", true, ActivateMenu));
    Caption="Новый тип трансформатора";
    return;
   }
  //--------------------------------------

/*   sqlstr=" select id,type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,\
   phase,swathe,power_nom,voltage_max,amperage_max,hook_up,amperage_no_load\
   from eqi_compensator_tbl where id = :id;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("id")->AsInteger=id;

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
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
   }
   ZEqpQuery->Close();
*/
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

     phaseid=ParentDataSet->FieldByName("phase")->AsInteger;
     edSwatheChange(this);
     hook_upid=ParentDataSet->FieldByName("Hook_up")->AsInteger;

     for (int i = 0; i<=phase_no-1;i++)
       {
         if (phaseid==phaseid_arr[i]) {cbPhase->ItemIndex=i;break;}
       }
     for (int i = 0; i<=hook_up_no-1;i++)
       {
         if (hook_upid==hook_upid_arr[i]) {cbHook_up->ItemIndex=i;break;}
       }
   //-------------------
   if (refresh==0)
     MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem(edType->Text.c_str(), true, ActivateMenu));
     Caption=edType->Text;
   //-------------------

   if (ParentDataSet->FieldByName("Swathe")->AsInteger==2)
     sqlstr=" select voltage_short_circuit,iron,copper \
     from eqi_compensator_2_tbl where id_type_eqp = :id;";
   else
   {
   if (ParentDataSet->FieldByName("Swathe")->AsInteger==3)
     sqlstr=" select id_type_eqp,power_h,power_m,power_l,iron,copper_hl,copper_hm,copper_ml,\
     voltage_short_hl,voltage_short_ml,voltage_short_hm, voltage3_nom,amperage3_nom \
     from eqi_compensator_3_tbl where id_type_eqp = :id;";
   else return;
   }

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("id")->AsInteger=eqid;

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
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();
     if (ParentDataSet->FieldByName("Swathe")->AsInteger==2)
     {
        edVoltage_short_circuit->Text=ZEqpQuery->FieldByName("Voltage_short_circuit")->AsString;
        edIron->Text=ZEqpQuery->FieldByName("Iron")->AsString;
        edCopper->Text=ZEqpQuery->FieldByName("Copper")->AsString;
     }
     if (ParentDataSet->FieldByName("Swathe")->AsInteger==3)
     {
       edVoltage3_nom->Text=ZEqpQuery->FieldByName("voltage3_nom")->AsString;
       edAmperage3_nom->Text=ZEqpQuery->FieldByName("amperage3_nom")->AsString;

       edPower_h->Text=ZEqpQuery->FieldByName("Power_h")->AsString;
       edPower_m->Text=ZEqpQuery->FieldByName("Power_m")->AsString;
       edPower_l->Text=ZEqpQuery->FieldByName("Power_l")->AsString;

       edCopper_hl->Text=ZEqpQuery->FieldByName("Copper_hl")->AsString;
       edCopper_ml->Text=ZEqpQuery->FieldByName("Copper_ml")->AsString;
       edCopper_hm->Text=ZEqpQuery->FieldByName("Copper_hm")->AsString;

       edVoltage_short_hl->Text=ZEqpQuery->FieldByName("Voltage_short_hl")->AsString;
       edVoltage_short_ml->Text=ZEqpQuery->FieldByName("Voltage_short_ml")->AsString;
       edVoltage_short_hm->Text=ZEqpQuery->FieldByName("Voltage_short_hm")->AsString;

       edIron3->Text=ZEqpQuery->FieldByName("Iron")->AsString;
     }
   }
   ZEqpQuery->Close();


}
//---------------------------------------------------------------------------
 bool TfCompSpr::SaveData(void)
{
   ZEqpQuery->Close();

   sqlstr="update eqi_compensator_tbl set type= :type,normative= :normative,voltage_nom= :voltage_nom,voltage2_nom= :voltage2_nom,\
   amperage_nom= :amperage_nom,amperage2_nom= :amperage2_nom,voltage_max= :voltage_max,amperage_max= :amperage_max,phase= :phase,\
   swathe= :swathe, hook_up= :hook_up,power_nom= :power_nom,amperage_no_load= :amperage_no_load \
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
   // Дополнительные таблици
   ZEqpQuery->Close();
   ZEqpQuery->Sql->Clear();

   if (edSwathe->Text=="2")
   {
   sqlstr="update eqi_compensator_2_tbl set voltage_short_circuit= :voltage_short_circuit ,iron= :iron,\
   copper= :copper  where id_type_eqp= :id;";
   ZEqpQuery->Sql->Add(sqlstr);
   if (edVoltage_short_circuit->Text!="")
    ZEqpQuery->ParamByName("voltage_short_circuit")->AsFloat=StrToFloat(edVoltage_short_circuit->Text);
   if (edIron->Text!="")
    ZEqpQuery->ParamByName("iron")->AsFloat=StrToFloat(edIron->Text);
   if (edCopper->Text!="")
    ZEqpQuery->ParamByName("copper")->AsFloat=StrToFloat(edCopper->Text);
   }

   if (edSwathe->Text=="3")
   {
   sqlstr="update eqi_compensator_3_tbl set power_h= :power_h,power_m= :power_m,power_l= :power_l,\
   iron= :iron,copper_hl= :copper_hl,copper_hm= :copper_hm,copper_ml= :copper_ml,voltage_short_hl= :voltage_short_hl,voltage_short_ml= :voltage_short_ml,\
   voltage_short_hm= :voltage_short_hm, voltage3_nom= :voltage3_nom, amperage3_nom= :amperage3_nom where id_type_eqp= :id;";
   ZEqpQuery->Sql->Add(sqlstr);
   if (edPower_h->Text!="")
    ZEqpQuery->ParamByName("Power_h")->AsFloat=StrToFloat(edPower_h->Text);
   if (edPower_m->Text!="")
    ZEqpQuery->ParamByName("Power_m")->AsFloat=StrToFloat(edPower_m->Text);
   if (edPower_l->Text!="")
    ZEqpQuery->ParamByName("Power_l")->AsFloat=StrToFloat(edPower_l->Text);

   if (edCopper_hl->Text!="")
    ZEqpQuery->ParamByName("Copper_hl")->AsFloat=StrToFloat(edCopper_hl->Text);
   if (edCopper_hm->Text!="")
    ZEqpQuery->ParamByName("Copper_hm")->AsFloat=StrToFloat(edCopper_hm->Text);
   if (edCopper_ml->Text!="")
    ZEqpQuery->ParamByName("Copper_ml")->AsFloat=StrToFloat(edCopper_ml->Text);
   if (edIron3->Text!="")
    ZEqpQuery->ParamByName("iron")->AsFloat=StrToFloat(edIron3->Text);

   if (edVoltage_short_hm->Text!="")
    ZEqpQuery->ParamByName("Voltage_short_hm")->AsFloat=StrToFloat(edVoltage_short_hm->Text);
   if (edVoltage_short_ml->Text!="")
    ZEqpQuery->ParamByName("Voltage_short_ml")->AsFloat=StrToFloat(edVoltage_short_ml->Text);
   if (edVoltage_short_hl->Text!="")
    ZEqpQuery->ParamByName("Voltage_short_hl")->AsFloat=StrToFloat(edVoltage_short_hl->Text);

   if (edVoltage3_nom->Text!="")
    ZEqpQuery->ParamByName("voltage3_nom")->AsInteger=StrToInt(edVoltage3_nom->Text);
   if (edAmperage3_nom->Text!="")
    ZEqpQuery->ParamByName("amperage3_nom")->AsInteger=StrToInt(edAmperage3_nom->Text);
   }
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

  bool TfCompSpr::SaveNewData(void)
{
   ZEqpQuery->Close();

   sqlstr="select eqi_newcomp_fun( :type, :normative, :voltage_nom, :amperage_nom, :voltage_max, :amperage_max, :voltage2_nom, :amperage2_nom,:phase, :swathe, :hook_up, :power_nom, :amperage_no_load );";
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

   // Дополнительные таблици
   ZEqpQuery->Sql->Clear();

   if (edSwathe->Text=="2")
   {
   sqlstr="insert into eqi_compensator_2_tbl values ( :id, :voltage_short_circuit, :iron, :copper);";
   ZEqpQuery->Sql->Add(sqlstr);
   if (edVoltage_short_circuit->Text!="")
    ZEqpQuery->ParamByName("voltage_short_circuit")->AsFloat=StrToFloat(edVoltage_short_circuit->Text);
   if (edIron->Text!="")
    ZEqpQuery->ParamByName("iron")->AsFloat=StrToFloat(edIron->Text);
   if (edCopper->Text!="")
    ZEqpQuery->ParamByName("copper")->AsFloat=StrToFloat(edCopper->Text);
   }

   if (edSwathe->Text=="3")
   {
   sqlstr="insert into eqi_compensator_3_tbl values ( :id, :voltage3_nom, :amperage3_nom, :power_h, :power_m, :power_l,\
   :iron, :copper_hl, :copper_hm, :copper_ml, :voltage_short_hl, :voltage_short_hm, :voltage_short_ml);";
   ZEqpQuery->Sql->Add(sqlstr);

   if (edPower_h->Text!="")
    ZEqpQuery->ParamByName("Power_h")->AsFloat=StrToFloat(edPower_h->Text);
   if (edPower_m->Text!="")
    ZEqpQuery->ParamByName("Power_m")->AsFloat=StrToFloat(edPower_m->Text);
   if (edPower_l->Text!="")
    ZEqpQuery->ParamByName("Power_l")->AsFloat=StrToFloat(edPower_l->Text);

   if (edCopper_hl->Text!="")
    ZEqpQuery->ParamByName("Copper_hl")->AsFloat=StrToFloat(edCopper_hl->Text);
   if (edCopper_hm->Text!="")
    ZEqpQuery->ParamByName("Copper_hm")->AsFloat=StrToFloat(edCopper_hm->Text);
   if (edCopper_ml->Text!="")
    ZEqpQuery->ParamByName("Copper_ml")->AsFloat=StrToFloat(edCopper_ml->Text);
   if (edIron3->Text!="")
    ZEqpQuery->ParamByName("iron")->AsFloat=StrToFloat(edIron3->Text);

   if (edVoltage_short_hm->Text!="")
    ZEqpQuery->ParamByName("Voltage_short_hm")->AsFloat=StrToFloat(edVoltage_short_hm->Text);
   if (edVoltage_short_ml->Text!="")
    ZEqpQuery->ParamByName("Voltage_short_ml")->AsFloat=StrToFloat(edVoltage_short_ml->Text);
   if (edVoltage_short_hl->Text!="")
    ZEqpQuery->ParamByName("Voltage_short_hl")->AsFloat=StrToFloat(edVoltage_short_hl->Text);

   if (edVoltage3_nom->Text!="")
    ZEqpQuery->ParamByName("voltage3_nom")->AsInteger=StrToInt(edVoltage3_nom->Text);
   if (edAmperage3_nom->Text!="")
    ZEqpQuery->ParamByName("amperage3_nom")->AsInteger=StrToInt(edAmperage3_nom->Text);

   }
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
//   ZEqpQuery->Transaction->Commit();
   return 1;
}
//---------------------------------------------------------------------------
void __fastcall TfCompSpr::cbPhaseChange(TObject *Sender)
{
  phaseid=phaseid_arr[cbPhase->ItemIndex];
}
//---------------------------------------------------------------------------

void __fastcall TfCompSpr::cbHook_upChange(TObject *Sender)
{
  hook_upid=hook_upid_arr[cbHook_up->ItemIndex];
}
//---------------------------------------------------------------------------

void __fastcall TfCompSpr::edSwatheChange(TObject *Sender)
{
int Swathe;
try{
   Swathe=StrToInt(edSwathe->Text);
   }
 catch(...) {
  p2swathe->Visible=false;
  p3swathe->Visible=false;
  return;
 }

if (Swathe==3)
 {
  p2swathe->Visible=false;
  p3swathe->Visible=true;
  return;
 }
if (Swathe==2)
 {
  p2swathe->Visible=true;
  p3swathe->Visible=false;
  return;
 }
 p2swathe->Visible=false;
 p3swathe->Visible=false;

}
//---------------------------------------------------------------------------

void __fastcall TfCompSpr::tbSaveClick(TObject *Sender)
{
 if ((edSwathe->Text!="2")&&(edSwathe->Text!="3"))
  {
   ShowMessage("Количество обмоток должно быть 2 или 3.");
   return;
  }

 if (mode==0)
  {
   SaveNewData();
//   edSwathe->Enabled=false;
   mode=1;
  }
 else SaveData();
 if (WCompGrid==NULL) return; //Таблицу уже закрыли
 ParentDataSet->Refresh();

 TLocateOptions SearchOptions;
 SearchOptions.Clear();
 ParentDataSet->Locate("id",eqid ,SearchOptions);

}
//---------------------------------------------------------------------------

void __fastcall TfCompSpr::tbCancelClick(TObject *Sender)
{
 if (mode==0)
  {
    Close();
  }
 else
  {
    refresh=1;
    if (WCompGrid==NULL) {Close(); return; } //Таблицу уже закрыли
    ShowData(eqid);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfCompSpr::FormCreate(TObject *Sender)
{
   // Заполнить комбо
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

void __fastcall TfCompSpr::FormShow(TObject *Sender)
{
/* if (mode==0)
  {
    edSwathe->Enabled=true;
  }
 else
   edSwathe->Enabled=false;
 */  
}
//---------------------------------------------------------------------------



