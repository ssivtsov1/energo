//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fMeter.h"
#include "ParamsForm.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;

__fastcall TfMeterSpr::TfMeterSpr(TComponent* AOwner,AnsiString FName) : TWTDoc(AOwner,FName)
{
  // Создать локальный запрос
  ZEqpQuery = new TWTQuery(Application);
  ZEqpQuery->MacroCheck=true;
  TZDatasetOptions Options;
  Options.Clear();
  Options << doQuickOpen;
  ZEqpQuery->Options=Options;
  ZEqpQuery->RequestLive=false;
  ZEqpQuery->CachedUpdates=false;

/*
  TWTPanel* PName=MainPanel->InsertPanel(30,true,25); // (X,bool,Y) X,Y min size panel
  TFont* F=new TFont();
  F->Size=16;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PName->Params->AddText("Группы документов",100,F,Classes::taCenter,true)->ID="NameGrp";
  */
  MainTabSheet->Caption="";
  PageControl->TabHeight=1;
  PageControl->TabWidth=1;

  CoolBar->RemoveToolBar((TWTToolBar*)(CoolBar->Bands->Items[0]->Control));

  TWTToolBar* MyBar=new TWTToolBar(this);
  MyBar->Parent=CoolBar;
  MyBar->ID="Главная панель";
//  MyBar->AutoSize=true;
  MyBar->AddButton("Save", "Сохранить", tbSaveClick)->ID="Save";
  MyBar->AddButton("Cancel", "Отмена", tbCancelClick)->ID="Cancel";
  CoolBar->AddToolBar(MyBar);

  TWTPanel* PEdits=MainPanel->InsertPanel(300,true,80); // (X,bool,Y) X,Y min size panel

  edType=(TEdit*)(PEdits->Params->AddSimple("Тип",150,"")->Control);
  edNormative=(TEdit*)(PEdits->Params->AddSimple("ГОСТ ",150,"",false)->Control);
  edVoltage_nom=(TEdit*)(PEdits->Params->AddSimple("Номинальное напряжение (первичное), В ",90,"")->Control);
  edAmperage_nom=(TEdit*)(PEdits->Params->AddSimple("Номинальный ток (первичный), А  ",90,"",false)->Control);
  edVoltage_max=(TEdit*)(PEdits->Params->AddSimple("Максимальное напряжение (первичное), В",90,"")->Control);
  edAmperage_max=(TEdit*)(PEdits->Params->AddSimple("Максимальный ток (первичный), А",90,"",false)->Control);

  TWTPanel* PCombos=MainPanel->InsertPanel(300,true,90); // (X,bool,Y) X,Y min size panel

  cbPhase= new TComboBox(PCombos);
  cbPhase->Parent=PCombos;
  cbPhase->Style=Stdctrls::csDropDownList;
  cbPhase->Top=20;
  cbPhase->Left=10;
  cbPhase->OnChange=cbPhaseChange;

  TLabel *lPhase=new TLabel(PCombos);
  lPhase->Parent=PCombos;
  lPhase->Caption="Фазность";
  lPhase->Top=7;
  lPhase->Left=10;

  cbKind_count= new TComboBox(PCombos);
  cbKind_count->Parent=PCombos;
  cbKind_count->Style=Stdctrls::csDropDownList;
  cbKind_count->Top=20;
  cbKind_count->Left=210;
  cbKind_count->OnChange=cbKind_countChange;

  TLabel *lKind_count=new TLabel(PCombos);
  lKind_count->Parent=PCombos;
  lKind_count->Caption="Вид учета энергии";
  lKind_count->Top=7;
  lKind_count->Left=210;

  cbKind_meter= new TComboBox(PCombos);
  cbKind_meter->Parent=PCombos;
  cbKind_meter->Style=Stdctrls::csDropDownList;
  cbKind_meter->Top=20;
  cbKind_meter->Left=410;
  cbKind_meter->OnChange=cbKind_meterChange;

  TLabel *lKind_meter=new TLabel(PCombos);
  lKind_meter->Parent=PCombos;
  lKind_meter->Caption="Вид";
  lKind_meter->Top=7;
  lKind_meter->Left=410;

  cbSchema_inst= new TComboBox(PCombos);
  cbSchema_inst->Parent=PCombos;
  cbSchema_inst->Style=Stdctrls::csDropDownList;
  cbSchema_inst->Top=60;
  cbSchema_inst->Left=10;
  cbSchema_inst->OnChange=cbSchema_instChange;

  TLabel *lSchema_inst=new TLabel(PCombos);
  lSchema_inst->Parent=PCombos;
  lSchema_inst->Caption="Схема подключения";
  lSchema_inst->Top=47;
  lSchema_inst->Left=10;

  cbHook_up= new TComboBox(PCombos);
  cbHook_up->Parent=PCombos;
  cbHook_up->Style=Stdctrls::csDropDownList;
  cbHook_up->Top=60;
  cbHook_up->Left=210;
  cbHook_up->OnChange=cbHook_upChange;

  TLabel *lHook_up=new TLabel(PCombos);
  lHook_up->Parent=PCombos;
  lHook_up->Caption="Cпособ включения";
  lHook_up->Top=47;
  lHook_up->Left=210;

  //Другие свойства
  TWTPanel* POther=MainPanel->InsertPanel(300,true,120); // (X,bool,Y) X,Y min size panel

  edCarry=(TEdit*)(POther->Params->AddSimple("Разрядность",70,"",false)->Control);
  edVoltage_nom_s=(TEdit*)(POther->Params->AddSimple("Номинальное напряжения вторичное, В",100,"")->Control);
  edAmperage_nom_s=(TEdit*)(POther->Params->AddSimple("Номинальный ток вторичный, А",100,"",false)->Control);
  edZones=(TEdit*)(POther->Params->AddSimple("Количество зон  ",100,"")->Control);
  edZone_time_min=(TEdit*)(POther->Params->AddSimple("Миним. длительность зоны, ч   ",100,"",false)->Control);
  edTerm_control=(TEdit*)(POther->Params->AddSimple("Периодичность поверки, лет",100,"")->Control);
  edBuffle=(TEdit*)(POther->Params->AddSimple("Порог чувствительности, %        ",100,"",false)->Control);
  /*
  TFont* F=new TFont();
  F->Size=7;
//  F->Style=F->Style << fsBold;
  F->Color=clBlack;

  TWTPanel* PPrecHead=MainPanel->InsertPanel(300,true,40);
  PPrecHead->Params->AddText("Классы точности счетчика",100,F,Classes::taCenter,true);
  PPrecHead->Height=20;
  MainPanel->InsertPanel(20,false,40);
  TWTPanel* PEnergyHead=MainPanel->InsertPanel(100,false,40);
  PEnergyHead->Params->AddText("Виды учитываемой энергии",100,F,Classes::taCenter,true);
  */

  //Таблица классов точности
  TWTPanel* PPrec=MainPanel->InsertPanel(300,true,100);
//  PPrec->Params->AddText("1",100,F,Classes::taCenter,true);
  TWTQuery *Query = new  TWTQuery(this);
  Query->Options << doQuickOpen;

  Query->Sql->Clear();
  Query->Sql->Add("select id_type_eqp,cl,kind_load,amperage_load,error " );
  Query->Sql->Add("from eqi_meter_prec_tbl where id_type_eqp= :id;");
  ////Query->ParamByName("id")->AsInteger=eqid;

  WTPrecGrid = new TWTDBGrid(PPrec,Query );
  qPrec = WTPrecGrid->Query;
  WTPrecGrid->Options>>dgAlwaysShowSelection;
  PPrec->Params->AddGrid(WTPrecGrid, true)->ID="Prec";

  MainPanel->InsertPanel(20,false,100);

  //Таблица видов энергии
  TWTPanel* PEnergy=MainPanel->InsertPanel(100,false,100);

  Query = new  TWTQuery(this);
  Query->Options << doQuickOpen;

  Query->Sql->Clear();
  Query->Sql->Add("select id_type_eqp, kind_energy " );
  Query->Sql->Add("from eqi_meter_energy_tbl where id_type_eqp= :id;");
  ////Query->ParamByName("id")->AsInteger=eqid;

  WTEnergyGrid = new TWTDBGrid(PEnergy,Query );
  qEnergy = WTEnergyGrid->Query;
  WTEnergyGrid->Options>>dgAlwaysShowSelection;
  qEnergy->AddLookupField("ENERGY", "kind_energy", "eqk_energy_tbl", "name","id");

  PEnergy->Params->AddGrid(WTEnergyGrid, true)->ID="Energy";

  //PEnergy->Params->AddText("2",100,F,Classes::taCenter,true);

 // Constructor=true;
//  OnShow=ShowForm;
  OnCreate=FormCreate;
  OnCloseQuery=FormClose;

  TStaticText *lPrecHead=new TStaticText(POther);
  lPrecHead->Parent=POther;
  lPrecHead->Caption="Классы точности счетчика";
  lPrecHead->Top=107;
  lPrecHead->Left=1;
//  lPrecHead->Height=20;
  lPrecHead->Width=PPrec->Width;
  lPrecHead->Alignment=Classes::taCenter;
  lPrecHead->BorderStyle=sbsSunken;

  TStaticText *lEnergyHead=new TStaticText(POther);
  lEnergyHead->Parent=POther;
  lEnergyHead->Caption="Виды учитываемой энергии";
  lEnergyHead->Top=107;
  lEnergyHead->Width=250;
//  lEnergyHead->Align=alRight;
  lEnergyHead->Left=lPrecHead->Left+lPrecHead->Width+22;
  lEnergyHead->Alignment=Classes::taCenter;
  lEnergyHead->BorderStyle=sbsSunken;

  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();
  SP->Width=350;

 };

//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::ShowData(int meterid)
{
  eqid = meterid;

  WTPrecGrid->SetFocus();
  WTEnergyGrid->SetFocus();

  if (mode==0)
   {
    WTPrecGrid->Enabled=false;
    WTEnergyGrid->Enabled=false;
    return;
   }
 //--------------------------------------

// WTPrecGrid->ToolBar->Enabled=false;

  //Поля заполняем данными
  edType->Text=ParentDataSet->FieldByName("Type")->AsString;
  edNormative->Text=ParentDataSet->FieldByName("Normative")->AsString;
  edVoltage_nom->Text=ParentDataSet->FieldByName("Voltage_nom")->AsString;
  edAmperage_nom->Text=ParentDataSet->FieldByName("amperage_nom")->AsString;
  edVoltage_max->Text=ParentDataSet->FieldByName("Voltage_max")->AsString;
  edAmperage_max->Text=ParentDataSet->FieldByName("Amperage_max")->AsString;

  edCarry->Text=ParentDataSet->FieldByName("Carry")->AsString;
  edAmperage_nom_s->Text=ParentDataSet->FieldByName("Amperage_nom_s")->AsString;
  edVoltage_nom_s->Text=ParentDataSet->FieldByName("Voltage_nom_s")->AsString;
  edZones->Text=ParentDataSet->FieldByName("Zones")->AsString;
  edZone_time_min->Text=ParentDataSet->FieldByName("Zone_time_min")->AsString;
  edTerm_control->Text=ParentDataSet->FieldByName("Term_control")->AsString;
  edBuffle->Text=ParentDataSet->FieldByName("buffle")->AsString;

  phaseid=ParentDataSet->FieldByName("phase")->AsInteger;
  hook_upid=ParentDataSet->FieldByName("Hook_up")->AsInteger;
  kind_countid=ParentDataSet->FieldByName("kind_count")->AsInteger;
  kind_meterid=ParentDataSet->FieldByName("kind_meter")->AsInteger;
  schema_instid=ParentDataSet->FieldByName("schema_inst")->AsInteger;



  for (int i = 0; i<=phase_no-1;i++)
    {
      if (phaseid==phaseid_arr[i]) {cbPhase->ItemIndex=i;break;}
    }
  for (int i = 0; i<=hook_up_no-1;i++)
    {
      if (hook_upid==hook_upid_arr[i]) {cbHook_up->ItemIndex=i;break;}
    }
  for (int i = 0; i<=kind_count_no-1;i++)
    {
      if (kind_countid==kind_countid_arr[i]) {cbKind_count->ItemIndex=i;break;}
    }
  for (int i = 0; i<=kind_meter_no-1;i++)
    {
      if (kind_meterid==kind_meterid_arr[i]) {cbKind_meter->ItemIndex=i;break;}
    }
  for (int i = 0; i<=schema_inst_no-1;i++)
    {
      if (schema_instid==schema_instid_arr[i]) {cbSchema_inst->ItemIndex=i;break;}
    }

  if (refresh==1) return;

  ShowGrids();
}
//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::NewPrecClass(TDataSet* DataSet)
{
 qPrec->FieldByName("id_type_eqp")->AsInteger=eqid;
}
//-----------------------------------------------------------------------
void __fastcall TfMeterSpr::NewEnergyKind(TDataSet* DataSet)
{
 qEnergy->FieldByName("id_type_eqp")->AsInteger=eqid;
}
//-----------------------------------------------------------------------

void __fastcall TfMeterSpr::FormCreate(TObject *Sender)
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
   //---------------------------
   sqlstr=" select id,name from eqk_meter_tbl;";

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
   kind_meter_no=ZEqpQuery->RecordCount;
   for (int i = 0; i<=ZEqpQuery->RecordCount-1;i++)
   {
     cbKind_meter->Items->Add(ZEqpQuery->FieldByName("name")->AsString);
     kind_meterid_arr[i]=ZEqpQuery->FieldByName("id")->AsInteger;
     ZEqpQuery->Next();
   }
   ZEqpQuery->Close();
   //---------------------------
   sqlstr=" select id,name from eqk_kind_count_tbl;";

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
   kind_count_no=ZEqpQuery->RecordCount;
   for (int i = 0; i<=ZEqpQuery->RecordCount-1;i++)
   {
     cbKind_count->Items->Add(ZEqpQuery->FieldByName("name")->AsString);
     kind_countid_arr[i]=ZEqpQuery->FieldByName("id")->AsInteger;
     ZEqpQuery->Next();
   }
   ZEqpQuery->Close();
   //---------------------------
   sqlstr=" select id,name from eqk_schemains_tbl;";

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
   schema_inst_no=ZEqpQuery->RecordCount;
   for (int i = 0; i<=ZEqpQuery->RecordCount-1;i++)
   {
     cbSchema_inst->Items->Add(ZEqpQuery->FieldByName("name")->AsString);
     schema_instid_arr[i]=ZEqpQuery->FieldByName("id")->AsInteger;
     ZEqpQuery->Next();
   }
   ZEqpQuery->Close();

}
//-------------------------
  bool TfMeterSpr::SaveNewData(void)
{
   ZEqpQuery->Close();


//   sqlstr="select eqi_newmeter_fun( :type, :normative ,:voltage_nom, :amperage_nom, :voltage_max, :amperage_max, \
//   :kind_meter, :kind_count, :phase, :carry, :schema_inst, :hook_up, :amperage_nom_s, :voltage_nom_s, :zones, :zone_time_min, :term_control );";

   sqlstr="insert into eqi_meter_tbl (type,normative,voltage_nom,amperage_nom,voltage_max,amperage_max,\
   kind_meter, kind_count, phase, carry, schema_inst, hook_up, amperage_nom_s, voltage_nom_s,\
   zones, zone_time_min, term_control, buffle) values ( :type, :normative,:voltage_nom, :amperage_nom, :voltage_max, :amperage_max, \
   :kind_meter, :kind_count, :phase, :carry, :schema_inst, :hook_up, :amperage_nom_s, :voltage_nom_s, :zones, :zone_time_min, :term_control, :buffle);";

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
   if (edVoltage_max->Text!="")
    ZEqpQuery->ParamByName("voltage_max")->AsInteger=StrToInt(edVoltage_max->Text);
   if (edAmperage_max->Text!="")
    ZEqpQuery->ParamByName("amperage_max")->AsInteger=StrToInt(edAmperage_max->Text);
   if (edBuffle->Text!="")
    ZEqpQuery->ParamByName("buffle")->AsFloat=StrToFloat(edBuffle->Text);



   if (phaseid!=0)
    ZEqpQuery->ParamByName("phase")->AsInteger=phaseid;
   if (hook_upid!=0)
    ZEqpQuery->ParamByName("hook_up")->AsInteger=hook_upid;
   if (kind_countid!=0)
    ZEqpQuery->ParamByName("kind_count")->AsInteger=kind_countid;
   if (kind_meterid!=0)
    ZEqpQuery->ParamByName("kind_meter")->AsInteger=kind_meterid;
   if (schema_instid!=0)
    ZEqpQuery->ParamByName("schema_inst")->AsInteger=schema_instid;

   if (edCarry->Text!="")
    ZEqpQuery->ParamByName("carry")->AsInteger=StrToInt(edCarry->Text);
   if (edAmperage_nom_s->Text!="")
    ZEqpQuery->ParamByName("Amperage_nom_s")->AsInteger=StrToInt(edAmperage_nom_s->Text);
   if (edVoltage_nom_s->Text!="")
    ZEqpQuery->ParamByName("Voltage_nom_s")->AsInteger=StrToInt(edVoltage_nom_s->Text);
   if (edZones->Text!="")
    ZEqpQuery->ParamByName("zones")->AsInteger=StrToInt(edZones->Text);
   if (edZone_time_min->Text!="")
    ZEqpQuery->ParamByName("Zone_time_min")->AsFloat=StrToFloat(edZone_time_min->Text);
   if (edTerm_control->Text!="")
    ZEqpQuery->ParamByName("Term_control")->AsInteger=StrToInt(edTerm_control->Text);

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
//----------------------------------------------------------------------
 bool TfMeterSpr::SaveData(void)
{
   ZEqpQuery->Close();

   sqlstr="update eqi_meter_tbl set type= :type,normative= :normative,voltage_nom= :voltage_nom,\
   amperage_nom= :amperage_nom,voltage_max= :voltage_max,amperage_max= :amperage_max,\
   kind_meter= :kind_meter, kind_count= :kind_count, phase= :phase, carry= :carry, \
   schema_inst= :schema_inst,hook_up= :hook_up,amperage_nom_s= :amperage_nom_s,voltage_nom_s= :voltage_nom_s,\
   zones= :zones,zone_time_min= :zone_time_min,term_control= :term_control, buffle= :buffle \
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
   if (edVoltage_max->Text!="")
    ZEqpQuery->ParamByName("voltage_max")->AsInteger=StrToInt(edVoltage_max->Text);
   if (edAmperage_max->Text!="")
    ZEqpQuery->ParamByName("amperage_max")->AsInteger=StrToInt(edAmperage_max->Text);
   if (edBuffle->Text!="")
    ZEqpQuery->ParamByName("buffle")->AsFloat=StrToFloat(edBuffle->Text);


   if (phaseid!=0)
    ZEqpQuery->ParamByName("phase")->AsInteger=phaseid;
   if (hook_upid!=0)
    ZEqpQuery->ParamByName("hook_up")->AsInteger=hook_upid;
   if (kind_countid!=0)
    ZEqpQuery->ParamByName("kind_count")->AsInteger=kind_countid;
   if (kind_meterid!=0)
    ZEqpQuery->ParamByName("kind_meter")->AsInteger=kind_meterid;
   if (schema_instid!=0)
    ZEqpQuery->ParamByName("schema_inst")->AsInteger=schema_instid;

   if (edCarry->Text!="")
    ZEqpQuery->ParamByName("carry")->AsInteger=StrToInt(edCarry->Text);
   if (edAmperage_nom_s->Text!="")
    ZEqpQuery->ParamByName("Amperage_nom_s")->AsInteger=StrToInt(edAmperage_nom_s->Text);
   if (edVoltage_nom_s->Text!="")
    ZEqpQuery->ParamByName("Voltage_nom_s")->AsInteger=StrToInt(edVoltage_nom_s->Text);
   if (edZones->Text!="")
    ZEqpQuery->ParamByName("zones")->AsInteger=StrToInt(edZones->Text);
   if (edZone_time_min->Text!="")
    ZEqpQuery->ParamByName("Zone_time_min")->AsFloat=StrToFloat(edZone_time_min->Text);
   if (edTerm_control->Text!="")
    ZEqpQuery->ParamByName("Term_control")->AsInteger=StrToInt(edTerm_control->Text);


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
   ZEqpQuery->Close();
//   ZEqpQuery->Transaction->Commit();
   return 1;
}
//--------------------------------------------------------------------
void __fastcall TfMeterSpr::FormClose(TObject *Sender, bool &CanClose)
{
 delete ZEqpQuery;
 if (WMeterGrid!=NULL) ParentDataSet->Refresh();

}
//--------------------------------------------------------------------
void __fastcall TfMeterSpr::tbSaveClick(TObject *Sender)
{
/* if ()
  {
   ShowMessage("");
   return;
  }
  */
 if (mode==0)
  {
   if (SaveNewData())
   {
   WTPrecGrid->Enabled=true;
   WTEnergyGrid->Enabled=true;
   ShowGrids();
   mode=1;
   }
  }
 else
  {
  SaveData();
  WTPrecGrid->ApplyUpdatesMenu(Sender);
  WTEnergyGrid->ApplyUpdatesMenu(Sender);
  }
 if (WMeterGrid==NULL) return; //Таблицу уже закрыли
 ParentDataSet->Refresh();

 TLocateOptions SearchOptions;
 SearchOptions.Clear();
 ParentDataSet->Locate("id",eqid ,SearchOptions);

}
//---------------------------------------------------------------------------

void __fastcall TfMeterSpr::tbCancelClick(TObject *Sender)
{
 if (mode==0)
  {
    Close();
  }
 else
  {
    refresh=1;
    if (WMeterGrid==NULL) {Close(); return; } //Таблицу уже закрыли
    ShowData(eqid);
  }
}
//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::ShowGrids(void)
{
  //Таблица классов точности
  qPrec->ParamByName("id")->AsInteger=eqid;
  qPrec->Open();

  TStringList *WList=new TStringList();
  WList->Add("id_type_eqp");
  WList->Add("kind_load");
  WList->Add("amperage_load");

  TStringList *NList=new TStringList();

  qPrec->SetSQLModify("eqi_meter_prec_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WTPrecGrid->AddColumn("cl", "Класс точн.", "Класс точности");
  Field = WTPrecGrid->AddColumn("kind_load", "cosFi", "Условие нагрузки cosFi");
  Field = WTPrecGrid->AddColumn("amperage_load", "Ток, %", "Условие нагрузки ток (% от номинального)");
  Field = WTPrecGrid->AddColumn("error", "Погрешность, %", "Относительная погрешность");

  qPrec->BeforePost=NewPrecClass;

  //Таблица видов энергии

  qEnergy->ParamByName("id")->AsInteger=eqid;
  qEnergy->Open();

  WList=new TStringList();
  WList->Add("id_type_eqp");
  NList=new TStringList();

  qEnergy->SetSQLModify("eqi_meter_energy_tbl",WList,NList,true,true,true);

  Field = WTEnergyGrid->AddColumn("ENERGY", "Вид энергии", "Вид энергии");

  qEnergy->BeforePost=NewEnergyKind;
}
//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::cbPhaseChange(TObject *Sender)
{
  phaseid=phaseid_arr[cbPhase->ItemIndex];
}
//---------------------------------------------------------------------------

void __fastcall TfMeterSpr::cbHook_upChange(TObject *Sender)
{
  hook_upid=hook_upid_arr[cbHook_up->ItemIndex];
}
//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::cbKind_countChange(TObject *Sender)
{
  kind_countid=kind_countid_arr[cbKind_count->ItemIndex];
}
//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::cbKind_meterChange(TObject *Sender)
{
  kind_meterid=kind_meterid_arr[cbKind_meter->ItemIndex];
}
//---------------------------------------------------------------------------
void __fastcall TfMeterSpr::cbSchema_instChange(TObject *Sender)
{
  schema_instid=schema_instid_arr[cbSchema_inst->ItemIndex];
}
//---------------------------------------------------------------------------

