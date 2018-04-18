//---------------------------------------------------------------------------

#include <vcl.h>

#pragma hdrstop
#include "Main.h"
#include "fHist.h"
#include "SysUser.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
//TfCableSpr *fCableSpr;
AnsiString sqlstr;
//---------------------------------------------------------------------------
__fastcall TfHistoryEdit::TfHistoryEdit(TComponent* AOwner,int object, int cl,
                AnsiString table, AnsiString table_ind ) : TWTDoc(AOwner)

{
  id_object = object;
  id_class = cl;
  name_table_ind  = table_ind;
  name_table  = table;

  edit_enable = CheckLevel("Схема 2 - История")==3 ;
  //-------------------------------------
 /*
  ZEqpQuery = new TWTQuery(Application);
  ZEqpQuery->MacroCheck=true;
  TZDatasetOptions Options;
  Options.Clear();
  Options << doQuickOpen;
  ZEqpQuery->Options=Options;
  ZEqpQuery->RequestLive=false;
  ZEqpQuery->CachedUpdates=false;
*/
  //-----------------------------
  MainTabSheet->Caption="";
  PageControl->TabHeight=1;
  PageControl->TabWidth=1;

  //
  // Таблица 2 (eqm_obj_basic)
  //
  TWTPanel* P2=MainPanel->InsertPanel(300,true,100);

  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;

  Query2->Sql->Clear();
  Query2->Sql->Add("select id,name_eqp,num_eqp,loss_power,id_addres,dt_install,dt_change,dt_b,dt_e,mmgg,dt  from eqm_equipment_h where id = :obj order by dt; " );

  BasicGrid = new TWTDBGrid(P2, Query2);

  if(!edit_enable) BasicGrid->SetReadOnly();

  BasicQuery = BasicGrid->Query;
  P2->Params->AddGrid(BasicGrid, true)->ID="Basic";

  //BasicQuery->BeforeDelete= CheckDelete;

  //
  // Таблица 3 (eqm_....)
  //
  if (id_class !=13)
  {
   TWTPanel* P3=MainPanel->InsertPanel(300,true,100);

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options << doQuickOpen;

   Query3->Sql->Clear();
   // Построить запрос для каждого вида
   //----------------------------------------------------------------------------
   Query3->Sql->Add("select dt.* ");
   if (name_table_ind!="")
       Query3->Sql->Add(" ,it.type  " );

   Query3->Sql->Add(" from  %name_h as dt " );

   if (name_table_ind!="")
       Query3->Sql->Add(" JOIN %name_table_id AS it ON(dt.id_type_eqp=it.id)  " );
   Query3->Sql->Add(" where dt.code_eqp = :obj order by dt ;" );
   //----------------------------------------------------------------------------

   DetalGrid = new TWTDBGrid(P3, Query3);
   if(!edit_enable) DetalGrid->SetReadOnly();
   DetalQuery = DetalGrid->Query;
   P3->Params->AddGrid(DetalGrid, true)->ID="Detal";
  }
  //DetalQuery->BeforeDelete= CheckDelete;

  if (id_class ==1)
  {
   TWTPanel* P41=MainPanel->InsertPanel(470,true,15);
   P41->Caption ="Виды энергии";

   TWTPanel* P51=MainPanel->InsertPanel(15,false,15);
   P51->Caption ="Зоны";


   TWTPanel* P4=MainPanel->InsertPanel(470,true,80);

   TWTQuery *Query4 = new  TWTQuery(this);
   Query4->Options << doQuickOpen;

   Query4->Sql->Clear();
   Query4->Sql->Add("select * from eqd_meter_energy_h where code_eqp = :obj order by dt; " );

   EnergyGrid = new TWTDBGrid(P4, Query4);
   EnergyQuery = EnergyGrid->Query;
   if(!edit_enable) EnergyGrid->SetReadOnly();
   P4->Params->AddGrid(EnergyGrid, true)->ID="Energy";

//   TWTPanel* P51=MainPanel->InsertPanel(15,true,15);
//   P51->Caption ="Зоны";

   TWTPanel* P5=MainPanel->InsertPanel(120,false,80);

   TWTQuery *Query5 = new  TWTQuery(this);
   Query5->Options << doQuickOpen;

   Query5->Sql->Clear();
   Query5->Sql->Add("select * from eqd_meter_zone_h where code_eqp = :obj order by dt; " );

   ZoneGrid = new TWTDBGrid(P5, Query5);
   if(!edit_enable) ZoneGrid->SetReadOnly();
   ZoneQuery = ZoneGrid->Query;
   P5->Params->AddGrid(ZoneGrid, true)->ID="Zone";

  }

  if (id_class ==12)
  {
   TWTPanel* P41=MainPanel->InsertPanel(15,true,15);
   P41->Caption ="Виды энергии";

   TWTPanel* P4=MainPanel->InsertPanel(120,true,80);

   TWTQuery *Query4 = new  TWTQuery(this);
   Query4->Options << doQuickOpen;

   Query4->Sql->Clear();
   Query4->Sql->Add("select * from eqd_point_energy_h where code_eqp = :obj order by dt; " );

   EnergyGrid = new TWTDBGrid(P4, Query4);
   if(!edit_enable) EnergyGrid->SetReadOnly();
   EnergyQuery = EnergyGrid->Query;
   P4->Params->AddGrid(EnergyGrid, true)->ID="Energy";

  }

//  P61=MainPanel->InsertPanel(15,true,15);
//  P61->Caption ="Принадлежность";


  TWTPanel* P6=MainPanel->InsertPanel(100,true,120);

  PageControl1 = new TPageControl(P6);
  PageControl1->Parent = P6;
  PageControl1->Align = alClient;

  TTabSheet* ts = new TTabSheet(PageControl1);
  ts->Visible = true;
  ts->Caption = "Принадлежность";
  ts->PageControl = PageControl1;

  ts = new TTabSheet(PageControl1);
  ts->Visible = true;
  ts->Caption = "Площадки/подстанции";
  ts->PageControl = PageControl1;


  TWTQuery *Query6 = new  TWTQuery(this);
  Query6->Options << doQuickOpen;

  Query6->Sql->Clear();
  Query6->Sql->Add("select u.code_eqp,u.dt_install, u.dt_b,u.dt_e,u.mmgg, u.dt,c.short_name from eqm_eqp_use_h as u join clm_client_tbl as c on (c.id=u.id_client) where code_eqp = :obj order by dt; " );

  UseGrid = new TWTDBGrid(P6, Query6);
  if(!edit_enable) UseGrid->SetReadOnly();
  UseQuery = UseGrid->Query;
 /////////// P6->Params->AddGrid(UseGrid, true)->ID="Use";

  UseGrid->Parent =PageControl1->Pages[0];
  UseGrid->Align = alClient;

/*
  P81=MainPanel->InsertPanel(15,true,15);
  P81->Caption ="Площадки/подстанции";
  P8=MainPanel->InsertPanel(100,true,70);
*/

  TWTQuery *Query8 = new  TWTQuery(this);
  Query8->Options << doQuickOpen;

  Query8->Sql->Clear();
  Query8->Sql->Add("select csi.code_eqp, csi.code_eqp_inst, csi.dt_b,csi.dt_e,csi.mmgg, csi.dt,eq.name_eqp,dk.name as type_name from eqm_compens_station_inst_h as csi \
     left join eqm_equipment_tbl as eq on (eq.id=csi.code_eqp_inst) left join eqi_device_kinds_tbl as dk on (dk.id = eq.type_eqp) where code_eqp = :obj order by dt; " );

  AreaGrid = new TWTDBGrid(P6, Query8);
  if(!edit_enable) AreaGrid->SetReadOnly();
  AreaQuery = AreaGrid->Query;

 // P8->Params->AddGrid(AreaGrid, true)->ID="Area";
  AreaGrid->Parent =PageControl1->Pages[1];
  AreaGrid->Align = alClient;

  PageControl1->OnChange = PageControl1Change;

  TWTPanel* P71=MainPanel->InsertPanel(15,true,15);
  P71->Caption ="Дерево";

  TWTPanel* P7=MainPanel->InsertPanel(100,true,80);

  TWTQuery *Query7 = new  TWTQuery(this);
  Query7->Options << doQuickOpen;

  Query7->Sql->Clear();
  Query7->Sql->Add("select tt.*, ep.name_eqp from eqm_eqp_tree_h as tt left join \
  eqm_equipment_h as ep on (tt.code_eqp_e = ep.id ) where tt.code_eqp = :obj \
  and ( ep.dt_b = (select max(dt_b) from eqm_equipment_h as e2 \
   where e2.id = ep.id ) or ep.dt_b is null) \
   order by tt.dt; " );

  TreeGrid = new TWTDBGrid(P7, Query7);
  if(!edit_enable) TreeGrid->SetReadOnly();
  TreeQuery = TreeGrid->Query;
  P7->Params->AddGrid(TreeGrid, true)->ID="Tree";

//  DetalQuery->BeforePost=  !!!!;

//  OnCloseQuery=FormClose;

  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();
  SP->Width=350;

//  refresh=0;
}
//---------------------------------------------------------------------------
//void __fastcall TfHistoryEdit::FormClose(TObject *Sender, bool &CanClose)
//{
// delete ZEqpQuery;

//}
//---------------------------------------------------------------------------

void __fastcall TfHistoryEdit::ShowData()
{


  BasicGrid->SetFocus();
  if (id_class!=13) DetalGrid->SetFocus();
  if(id_class==1)
  {  EnergyGrid->SetFocus();
     ZoneGrid->SetFocus();
  }
  if(id_class==12)
  {  EnergyGrid->SetFocus(); }

  PageControl1->ActivePageIndex = 0;
  UseGrid->SetFocus();
  PageControl1->ActivePageIndex = 1;
  AreaGrid->SetFocus();
  PageControl1->ActivePageIndex = 0;
  UseGrid->SetFocus();
  TreeGrid->SetFocus();
//  ShowLifeGrid();
  ShowBasicGrid();
  if (id_class!=13) ShowDetalGrid();
  ShowEnZnGrid();
  ShowUseGrid();
  ShowAreaGrid();
}
//---------------------------------------------------------------------------

void __fastcall TfHistoryEdit::ShowAreaGrid()
{

  AreaQuery->AfterInsert=CancelInsert;
  AreaQuery->AfterDelete=CheckDelete;

  AreaQuery->ParamByName("obj")->AsInteger=id_object;

  AreaQuery->Open();

  TStringList *WList=new TStringList();
  WList->Add("code_eqp");
  WList->Add("code_eqp_inst");
  WList->Add("dt_b");

  TStringList *NList=new TStringList();
  NList->Add("name_eqp");
  NList->Add("type_name");

  AreaQuery->SetSQLModify("eqm_compens_station_inst_h",WList,NList,true,false,true);
  TWTField *Field;

  Field = AreaGrid->AddColumn("name_eqp", "Площадка/ТП/фидер", "Наименование");
  Field->SetReadOnly();
  Field = AreaGrid->AddColumn("type_name", "Тип", "Тип");
  Field->SetReadOnly();

  Field = AreaGrid->AddColumn("dt_b", "Дата нач.", "Дата");
  Field = AreaGrid->AddColumn("dt_e", "Дата кон.", "Дата");
  Field = AreaGrid->AddColumn("mmgg", "mmgg", "mmgg");
  Field->SetReadOnly();
  Field = AreaGrid->AddColumn("dt", "dt", "dt");
  Field->SetReadOnly();
 }

//-----------------------------------------------------------------------
void __fastcall TfHistoryEdit::ShowBasicGrid(){

  BasicQuery->AfterInsert=CancelInsert;
  BasicQuery->BeforeDelete= CheckDelete;

  BasicQuery->ParamByName("obj")->AsInteger=id_object;

  BasicQuery->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");
  WList->Add("dt_b");

  TStringList *NList=new TStringList();
  NList->Add("num_eqp");
  NList->Add("name_eqp");
  NList->Add("id_addres");
  NList->Add("loss_power");
  NList->Add("mmgg");
  NList->Add("dt");

  BasicQuery->SetSQLModify("eqm_equipment_h",WList,NList,true,false,true);
  TWTField *Field;

  Field = BasicGrid->AddColumn("name_eqp", "Наименование", "Наименование");
  Field->SetReadOnly();
  Field = BasicGrid->AddColumn("num_eqp", "Номер", "Заводской номер счетчика");
  Field->SetReadOnly();
  Field = BasicGrid->AddColumn("loss_power", "Учитывать потери", "Учитывать потери");
  Field->SetReadOnly();
  Field = BasicGrid->AddColumn("dt_install", "Дата установки", "Дата");
  Field = BasicGrid->AddColumn("dt_change", "Дата замены", "Дата");
  Field = BasicGrid->AddColumn("dt_b", "Дата нач.", "Дата");
  Field->Field->OnSetText = ValidateDate;
  Field = BasicGrid->AddColumn("dt_e", "Дата кон.", "Дата");
  Field->Field->OnSetText = ValidateDate;
  Field = BasicGrid->AddColumn("mmgg", "mmgg", "mmgg");
  Field->SetReadOnly();
  Field = BasicGrid->AddColumn("dt", "dt", "dt");
  Field->SetReadOnly();

//-------------------------------------------------------
  TreeQuery->AfterInsert=CancelInsert;
  TreeQuery->BeforeDelete= CheckDelete;

  TreeQuery->ParamByName("obj")->AsInteger=id_object;

  TreeQuery->Open();

  WList=new TStringList();
  WList->Add("code_eqp");
  WList->Add("id_tree");
  WList->Add("line_no");
  WList->Add("dt_b");

  NList=new TStringList();
  NList->Add("code_eqp_e");
  NList->Add("name_eqp");
  NList->Add("id_department");
  NList->Add("name");
  NList->Add("mmgg");
  NList->Add("dt");

  TreeQuery->SetSQLModify("eqm_eqp_tree_h",WList,NList,true,false,true);

  Field = TreeGrid->AddColumn("name", "Наименование", "Наименование");
  Field->SetReadOnly();
  Field->SetWidth(100);
  Field = TreeGrid->AddColumn("name_eqp", "Наименование пред.", "Наименование пред.");
  Field->SetReadOnly();
  Field = TreeGrid->AddColumn("code_eqp_e", "Код пред.", "код пред.");
  Field->SetReadOnly();
  Field = TreeGrid->AddColumn("id_tree", "Код ветки.", "код ветки.");
  Field->SetReadOnly();
  Field = TreeGrid->AddColumn("line_no", "Номер", "Номер");
  Field->SetReadOnly();

  Field = TreeGrid->AddColumn("dt_b", "Дата нач.", "Дата");
  Field->Field->OnSetText = ValidateDate;
  Field = TreeGrid->AddColumn("dt_e", "Дата кон.", "Дата");
  Field->Field->OnSetText = ValidateDate;
  Field = TreeGrid->AddColumn("mmgg", "mmgg", "mmgg");
  Field->SetReadOnly();
  Field = TreeGrid->AddColumn("dt", "dt", "dt");
  Field->SetReadOnly();

 }
//-----------------------------------------------------------------------
void __fastcall TfHistoryEdit::ShowDetalGrid()
{

  AnsiString name_table_h =name_table.SubString(1,name_table.Length()-3)+"h";

  DetalQuery->AfterInsert=CancelInsert;
  DetalQuery->BeforeDelete= CheckDelete;

  DetalQuery->MacroByName("name_h")->AsString = name_table_h;

  if (name_table_ind!="")
     DetalQuery->MacroByName("name_table_id")->AsString=name_table_ind;

  DetalQuery->ParamByName("obj")->AsInteger=id_object;

  switch (id_class){
        case 12:
          DetalQuery->AddLookupField("tarif", "id_tarif", "aci_tarif_tbl", "short_name","id");
          DetalQuery->AddLookupField("tg", "id_tg", "eqk_tg_tbl", "value","id");
        case 6:
        case 7:
          DetalQuery->AddLookupField("voltage", "id_voltage", "eqk_voltage_tbl", "voltage_min","id");
        break;
  }

  DetalQuery->Open();

  TStringList *WList=new TStringList();
  WList->Add("code_eqp");
  WList->Add("dt_b");

  TStringList *NList=new TStringList();
  NList->Add("id_department");
  NList->Add("mmgg");
  NList->Add("dt");

  TWTField *Field;

  if (name_table_ind!="")
  {
    Field = DetalGrid->AddColumn("type", "Тип", "Тип");
    Field->SetReadOnly();
    Field = DetalGrid->AddColumn("id_type_eqp", "Код типа", "Код типа");
    Field->SetReadOnly();

    NList->Add("type");
    NList->Add("id_type_eqp");
  }


  switch (id_class){
        case 3: //Коммут.оборудование

            Field = DetalGrid->AddColumn("amperage_nom", "Номин.ток", "Номин.ток");
            Field->SetReadOnly();
            NList->Add("amperage_nom");
            break;

        case 4: //Компенсаторы

            Field = DetalGrid->AddColumn("quantity", "Количество", "Количество");
            Field->SetReadOnly();
            NList->Add("quantity");
            break;
        case 6: //Кабельная линия
        case 7: //Воздушная линия

            Field = DetalGrid->AddColumn("length", "Длина", "Длина");
            Field->SetReadOnly();
            NList->Add("length");
            Field = DetalGrid->AddColumn("voltage", "Напряж.", "Напряж.");
            Field->SetReadOnly();
            NList->Add("id_voltage");
            break;
        case 10: //Изм. тр.
            Field = DetalGrid->AddColumn("date_check", "Дата поверки", "Дата поверки");
            Field->SetReadOnly();
            NList->Add("date_check");
            break;
        case 11: //Площадка
            Field = DetalGrid->AddColumn("power", "Мощность", "Мощность");
            Field->SetReadOnly();
            NList->Add("power");

            Field = DetalGrid->AddColumn("wtm", "Время работы", "Время работы");
            Field->SetReadOnly();
            NList->Add("wtm");
            break;

        case 16: //ДЕС
            Field = DetalGrid->AddColumn("power", "Мощность", "Мощность");
            Field->SetReadOnly();
            NList->Add("power");
            break;
        case 12: //ТУ
            Field = DetalGrid->AddColumn("power", "Мощность", "Мощность");
            Field->SetReadOnly();
            NList->Add("power");
            Field = DetalGrid->AddColumn("connect_power", "Присоед.мощность", "Присоединенная ощность");
            Field->SetReadOnly();
            NList->Add("connect_power");
            Field = DetalGrid->AddColumn("d", "ЄЄРП", "ЄЄРП");
            Field->SetReadOnly();
            NList->Add("d");
            Field = DetalGrid->AddColumn("wtm", "Раб.время", "Раб.время");
            Field->SetReadOnly();
            NList->Add("wtm");
            Field = DetalGrid->AddColumn("tarif", "Тариф", "Тариф");
            Field->SetReadOnly();
            NList->Add("id_tarif");
            Field = DetalGrid->AddColumn("tg", "Tg.f", "Tg.f");
            Field->SetReadOnly();
            NList->Add("id_tg");
            Field = DetalGrid->AddColumn("voltage", "Напряж.", "Напряж.");
            Field->SetReadOnly();
            NList->Add("id_voltage");
            Field = DetalGrid->AddColumn("count_lost", "Расчет потерь", "Расчет потерь");
            Field->SetReadOnly();
            NList->Add("count_lost");
            Field = DetalGrid->AddColumn("in_lost", "Т.продажи осн.", "");
            Field->SetReadOnly();
            NList->Add("in_lost");

            Field = DetalGrid->AddColumn("share", "Процент", "Процент");
            Field->SetReadOnly();
            NList->Add("share");
            Field = DetalGrid->AddColumn("ldemand", "Потр. пред.п. акт", "Потр. пред.п. акт");
            Field->SetReadOnly();
            NList->Add("ldemand");
            Field = DetalGrid->AddColumn("ldemandr", "Потр. пред.п. реакт", "Потр. пред.п. реакт");
            Field->SetReadOnly();
            NList->Add("ldemandr");
            Field = DetalGrid->AddColumn("ldemandg", "Потр. пред.п. ген.", "Потр. пред.п. ген.");
            Field->SetReadOnly();
            NList->Add("ldemandg");

            Field = DetalGrid->AddColumn("pdays", "дней пред.п.", "дней пред.п.");
            Field->SetReadOnly();
            NList->Add("pdays");
            Field = DetalGrid->AddColumn("count_itr", "Недогруз", "Недогруз");
            Field->SetReadOnly();
            NList->Add("count_itr");
            Field = DetalGrid->AddColumn("id_un", "Un", "Un");
            Field->SetReadOnly();
            NList->Add("id_un");
            Field = DetalGrid->AddColumn("zone", "Зона", "Зона");
            Field->SetReadOnly();
            NList->Add("zone");
            Field = DetalGrid->AddColumn("cmp", "Коменс. уст.", "Коменс. уст.");
            Field->SetReadOnly();
            NList->Add("cmp");
            Field = DetalGrid->AddColumn("main_losts", "Не делить потери", "Не делить потери");
            Field->SetReadOnly();
            NList->Add("main_losts");
            Field = DetalGrid->AddColumn("id_depart", "Министерство", "Министерство");
            Field->SetReadOnly();
            NList->Add("id_depart");
            Field = DetalGrid->AddColumn("flag_hlosts", "Ручной ввод потерь", "Ручной ввод потерь");
            Field->SetReadOnly();
            NList->Add("flag_hlosts");

            NList->Add("industry");
            NList->Add("itr_comment");
            NList->Add("lost_nolost");
            Field = DetalGrid->AddColumn("lost_nolost", "Потерьный", "Потерьный");
            Field->SetReadOnly();
            NList->Add("id_extra");
            NList->Add("day_control");
            Field = DetalGrid->AddColumn("day_control", "День проверки", "День проверки");
            Field->SetReadOnly();
            Field = DetalGrid->AddColumn("disabled", "Отключен", "Отключен");
            Field->SetReadOnly();
            NList->Add("disabled");

            break;
        case 1: //Счетчик
            Field = DetalGrid->AddColumn("warm", "Неотапл.", "Неотапл.");
            Field->SetReadOnly();
            NList->Add("warm");
            Field = DetalGrid->AddColumn("dt_control", "Дата поверки", "Дата поверки");
            Field->SetReadOnly();
            NList->Add("dt_control");
            Field = DetalGrid->AddColumn("count_met", "Порог", "Порог");
            Field->SetReadOnly();
            NList->Add("count_met");
/*
            Field = DetalGrid->AddColumn("buffle", "Предел чувств.%", "Предел чувствительности %");
            Field->SetReadOnly();
            NList->Add("buffle");
*/
            break;
  };

  Field = DetalGrid->AddColumn("dt_b", "Дата нач.", "Дата");
  Field->Field->OnSetText = ValidateDate;
  Field = DetalGrid->AddColumn("dt_e", "Дата кон.", "Дата");
  Field->Field->OnSetText = ValidateDate;
  Field = DetalGrid->AddColumn("mmgg", "mmgg", "mmgg");
  Field->SetReadOnly();
  Field = DetalGrid->AddColumn("dt", "dt", "dt");
  Field->SetReadOnly();


  DetalQuery->SetSQLModify(name_table_h,WList,NList,true,false,true);

 }
//-----------------------------------------------------------------------
void __fastcall TfHistoryEdit::ShowEnZnGrid(){

  if(id_class==1)
  {
   EnergyQuery->AfterInsert=CancelInsert;

   EnergyQuery->ParamByName("obj")->AsInteger=id_object;

   EnergyQuery->AddLookupField("energy", "kind_energy", "eqk_energy_tbl", "name","id");
   EnergyQuery->Open();

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("dt_b");
   WList->Add("dt_e");

   TStringList *NList=new TStringList();
   NList->Add("id_department");
   NList->Add("kind_energy");
   NList->Add("date_inst");
   NList->Add("mmgg");
   NList->Add("dt");


   EnergyQuery->SetSQLModify("eqd_meter_energy_h",WList,NList,true,false,true);
   TWTField *Field;

   Field = EnergyGrid->AddColumn("energy", "Вид энергии", "Вид энергии");
   Field->SetReadOnly();
   Field = EnergyGrid->AddColumn("dt_b", "Дата нач.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = EnergyGrid->AddColumn("dt_e", "Дата кон.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = EnergyGrid->AddColumn("mmgg", "mmgg", "mmgg");
   Field->SetReadOnly();
   Field = EnergyGrid->AddColumn("dt", "dt", "dt");
   Field->SetReadOnly();
//---------

   ZoneQuery->AfterInsert=CancelInsert;

   ZoneQuery->ParamByName("obj")->AsInteger=id_object;

   ZoneQuery->AddLookupField("energy", "kind_energy", "eqk_energy_tbl", "name","id");
   ZoneQuery->AddLookupField("zonename", "zone", "eqk_zone_tbl", "name","id");

   ZoneQuery->Open();

   WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("dt_b");
   WList->Add("dt_e");

   NList=new TStringList();
   NList->Add("id_department");
   NList->Add("kind_energy");
   NList->Add("zone");
   NList->Add("dt_zone_install");
   NList->Add("mmgg");
   NList->Add("dt");

   ZoneQuery->SetSQLModify("eqd_meter_zone_h",WList,NList,true,false,true);
  // TWTField *Field;

   Field = ZoneGrid->AddColumn("energy", "Вид энергии", "Вид энергии");
   Field->SetReadOnly();
   Field = ZoneGrid->AddColumn("zonename", "Зона", "Вид энергии");
   Field->SetReadOnly();

   Field = ZoneGrid->AddColumn("dt_b", "Дата нач.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = ZoneGrid->AddColumn("dt_e", "Дата кон.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = ZoneGrid->AddColumn("mmgg", "mmgg", "mmgg");
   Field->SetReadOnly();
   Field = ZoneGrid->AddColumn("dt", "dt", "dt");
   Field->SetReadOnly();

 }

  if(id_class==12)
  {
   EnergyQuery->AfterInsert=CancelInsert;

   EnergyQuery->ParamByName("obj")->AsInteger=id_object;

   EnergyQuery->AddLookupField("energy", "kind_energy", "eqk_energy_tbl", "name","id");
   EnergyQuery->Open();

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("dt_b");
   WList->Add("dt_e");

   TStringList *NList=new TStringList();
   NList->Add("id_department");
   NList->Add("kind_energy");
   NList->Add("dt_instal");
   NList->Add("mmgg");
   NList->Add("dt");

   EnergyQuery->SetSQLModify("eqd_point_energy_h",WList,NList,true,false,true);
   TWTField *Field;

   Field = EnergyGrid->AddColumn("energy", "Вид энергии", "Вид энергии");
   Field->SetReadOnly();
   Field = EnergyGrid->AddColumn("dt_b", "Дата нач.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = EnergyGrid->AddColumn("dt_e", "Дата кон.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = EnergyGrid->AddColumn("mmgg", "mmgg", "mmgg");
   Field->SetReadOnly();
   Field = EnergyGrid->AddColumn("dt", "dt", "dt");
   Field->SetReadOnly();
 }

 }
//-----------------------------------------------------
 void __fastcall TfHistoryEdit::ShowUseGrid(){

   UseQuery->AfterInsert=CancelInsert;

   UseQuery->ParamByName("obj")->AsInteger=id_object;
   UseQuery->Open();

   TStringList *WList=new TStringList();
   WList->Add("code_eqp");
   WList->Add("dt_b");
   WList->Add("dt_e");

   TStringList *NList=new TStringList();

   NList->Add("short_name");
   NList->Add("dt_install");
   NList->Add("mmgg");
   NList->Add("dt");


   UseQuery->SetSQLModify("eqm_eqp_use_h",WList,NList,true,false,true);
   TWTField *Field;

   Field = UseGrid->AddColumn("short_name", "Абонент", "Абонент");
   Field->SetReadOnly();
   Field = UseGrid->AddColumn("dt_b", "Дата нач.", "Дата");
   Field->Field->OnSetText = ValidateDate;
   Field = UseGrid->AddColumn("dt_e", "Дата кон.", "Дата");
   Field->Field->OnSetText = ValidateDate;   
   Field = UseGrid->AddColumn("mmgg", "mmgg", "mmgg");
   Field->SetReadOnly();
   Field = UseGrid->AddColumn("dt", "dt", "dt");
   Field->SetReadOnly();

 }

//----------------------------------------------------------------------
void __fastcall TfHistoryEdit::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfHistoryEdit::CheckDelete(TDataSet* DataSet)
{
 class Out{};

 if ((DataSet->RecordCount == 1)||(DataSet->FieldByName("dt_e")->IsNull))
 throw Out();
 //    DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfHistoryEdit::PageControl1Change(TObject *Sender)

{
   if(PageControl1->ActivePage ==PageControl1->Pages[0])
   {
     UseGrid->SetFocus();
   }

   if(PageControl1->ActivePage ==PageControl1->Pages[1])
   {
     AreaGrid->SetFocus();
   }
}
//---------------------------------------------------------------------------
void __fastcall TfHistoryEdit::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};
//---------------------------------------------------------------------------

