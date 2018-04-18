//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fEqpBase.h"
#include "Main.h"
#include "fEqpSDet.h"
#include "fEqpAirLineDet.h"
#include "fEqpTheMeterDet.h"
#include "fEqpBorderDet.h"
#include "fStationDet.h"
#include "fEqpThePointDet.h"
#include "fFiderDet.h"
#include "fChange.h"
#include "fHist.h"
#include "SysUser.h"
#include "fGroundDet.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
//TfEqpEdit *fEqpEdit;
TWTWinDBGrid *WGrid;
TWTDBGrid * WAddrGrid;
TWTDBGrid* WAbonGrid;
TfHistoryEdit *WHistoryEdit;
TWTWinDBGrid *WParamGrid;
TWTWinDBGrid *WParamHistGrid;

TDateTime UpdDate;
//---------------------------------------------------------------------------
__fastcall TfEqpEdit::TfEqpEdit(TComponent* Owner)
        : TfTWTCompForm(Owner,false)
{
  ZEqpQuery = new TWTQuery(Application);
  ZEqpQuery->MacroCheck=true;
  TZDatasetOptions Options;
  Options.Clear();
  Options << doQuickOpen;
  ZEqpQuery->Options=Options;
//  ZEqpQuery->ObjectView=true;
  ZEqpQuery->RequestLive=false;
  ZEqpQuery->CachedUpdates=false;
//  ZEqpQuery->Transaction->AutoCommit=false;
  ParentDataSet=NULL;
  DetEditForm=NULL;
  CangeLogEnabled=false;
  IsModified=false;

//  tsAddAdr->Enabled=false;
  tsAddAdr->TabVisible=false;

  //==============================================================
  bt_save_enable=CheckLevel("Схема 2 - Сохранение")!=0 ;
  if (bt_save_enable)
  {
    ed_name_enable=CheckLevel("Схема 2 - Имя")!=0 ;
    ed_num_enable =CheckLevel("Схема 2 - Номер")!=0 ;
    ed_addr_enable =CheckLevel("Схема 2 - Адрес")!=0 ;
    ed_lost_enable =CheckLevel("Схема 2 - Расчет потерь")!=0 ;
  }
  else
  {
    ed_name_enable=true;
    ed_num_enable=true;
    ed_addr_enable=true;
    ed_lost_enable=true;
  }

  bt_area_enable=CheckLevel("Схема 2 - Включение в подстанцию")!=0 ;
  bt_abon_enable=CheckLevel("Схема 2 - Добавление в схему абоненту")!=0 ;
  bt_hist_enable=CheckLevel("Схема 2 - История")!=0;

  tbSave->Enabled =bt_save_enable;
  tbNewInst->Enabled =bt_area_enable;
  tbAddAbon->Enabled =bt_abon_enable;
  tbHistory->Enabled =bt_hist_enable;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::FormClose(TObject *Sender, TCloseAction &Action)
{
bool is_saved = SaveOnExit();
/*
if ((ParentDataSet!=NULL)&&is_saved)
 {
  ParentDataSet->Refresh();
 };
*/
//Если нет Paren, форма открывалась не из дерева
delete ZEqpQuery;

if (Parent==NULL)
{
 TfTWTCompForm::FormClose(Sender,Action);
}
else
 Action = caFree;
}
//---------------------------------------------------------------------------
#define WinName "Подстанции и площадки"
void _fastcall TfEqpEdit::ShowPlaces(void) {

  // Определяем владельца
  TWTQuery *QueryAdr;
  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();
/*
  QueryAdr->Sql->Add("select eq.id, eq.name_eqp,eq.num_eqp,eq.dt_install,dk.name AS kindname,eq.type_eqp, c.short_name, c.code ");
  QueryAdr->Sql->Add("from eqm_equipment_tbl AS eq JOIN eqi_device_kinds_tbl AS dk  ON (eq.type_eqp=dk.id), ");
  QueryAdr->Sql->Add(" clm_client_tbl as c ,eqm_area_tbl as eqa ");
  QueryAdr->Sql->Add("where eqa.code_eqp=eq.id and ( eqa.id_client= :abon or  or dk.id=17 ");
  QueryAdr->Sql->Add(" or eqa.id_client in (select id_client from eqm_eqp_use_tbl where code_eqp = :eqp )) ");
  QueryAdr->Sql->Add(" and c.id = eqa.id_client ");
  QueryAdr->Sql->Add(" and dk.inst_station = 1 order by c.code, eq.type_eqp, eq.name_eqp;");
*/
/*
QueryAdr->Sql->Add(" \
select eq.id, eq.name_eqp,eq.num_eqp,eq.dt_install,dk.name AS kindname,eq.type_eqp, c.short_name, c.code \
  from (select coalesce(a.name,eq.name_eqp) as name_eqp,eq.num_eqp,eq.dt_install,eq.id,eq.type_eqp     \
           from eqm_equipment_tbl eq left join adi_build_tbl a on eq.id=a.id                          \
        ) AS eq JOIN eqi_device_kinds_tbl AS dk  ON (eq.type_eqp=dk.id),                             \
   clm_client_tbl as c ,eqm_area_tbl as eqa                                                          \
  where ((eqa.code_eqp=eq.id and dk.id<>17) or  (dk.id=17 )) and                                      \
( eqa.id_client= :abon or eqa.id_client in (select id_client from eqm_eqp_use_tbl where code_eqp = :eqp)  ) \
   and c.id = eqa.id_client                                                                                \
   and dk.inst_station = 1 order by c.code, eq.type_eqp, eq.name_eqp;  ");
*/

QueryAdr->Sql->Add(" \
select eq.id, eq.name_eqp,eq.num_eqp,eq.dt_install,dk.name AS kindname,eq.type_eqp, c.short_name, c.code \
from \
(select coalesce(a.name,eq.name_eqp) as name_eqp,eq.num_eqp,eq.dt_install,eq.id,eq.type_eqp \
  from eqm_equipment_tbl eq left join adi_build_tbl a on eq.id=a.id \
) AS eq \
JOIN eqi_device_kinds_tbl AS dk  ON (eq.type_eqp=dk.id) \
left join eqm_area_tbl as eqa  on (eqa.code_eqp=eq.id ) \
left join clm_client_tbl as c on (c.id = eqa.id_client) \
where dk.inst_station = 1 \
 and ( eqa.id_client= :abon or eqa.id_client in (select id_client from eqm_eqp_use_tbl where code_eqp = :eqp)  or (dk.id=17 )) \
 order by c.code, eq.type_eqp, eq.name_eqp; ");

  QueryAdr->ParamByName("abon")->AsInteger=abonent_id;
  QueryAdr->ParamByName("eqp")->AsInteger=eqp_id;

  WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  QueryAdr->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WGrid->AddColumn("short_name", "Абонент", "Абонент");
  Field->SetWidth(100);
  Field = WGrid->AddColumn("kindname", "Тип", "Тип");
  Field = WGrid->AddColumn("name_eqp", "Наименование", "Наименование");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");

  WGrid->DBGrid->StringDest = "-1";
  WGrid->DBGrid->OnAccept=PlaceAccept;
  WGrid->DBGrid->Visible = true;
  WGrid->DBGrid->ReadOnly=true;
  WGrid->ShowAs("Выбор площадки");

};
#undef WinName
//---------------------------------------------------------------------------
#define WinName "Тип нового оборудования"
void _fastcall TfEqpEdit::ShowKinds(void) {


  TWTQuery *QueryAdr;

  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select id,name,id_table_ind,id_table,calc_lost,inst_station ");
  QueryAdr->Sql->Add("from eqi_device_kinds_tbl ");
  QueryAdr->Sql->Add("where inst_station = 0 and id<>9 order by name;");

  WGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WGrid->SetCaption(WinName);

  TWTQuery* Query = WGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  QueryAdr->SetSQLModify("eqi_device_kinds_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WGrid->AddColumn("name", "Тип", "Тип");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");

  WGrid->DBGrid->StringDest = "-1";
  WGrid->DBGrid->Visible = true;
  WGrid->DBGrid->ReadOnly=true;

  WGrid->OnCloseQuery=KindClose;
  WGrid->DBGrid->OnAccept=KindAccept;

  WGrid->ShowAs("Выбор типа");

};
#undef WinName


//bool DoQuery(TZPgSqlQuery *Query,AnsiString str)
//{

//}
//---------------------------------------------------------------------------
void TfEqpEdit::ShowEqpInst(void)
{
     sqlstr="select eq.id, eq.name_eqp , dk.name, c.short_name as client \
      from eqm_equipment_tbl AS eq JOIN eqm_compens_station_inst_tbl AS cs ON (eq.id=cs.code_eqp_inst) \
      join eqi_device_kinds_tbl as dk on (eq.type_eqp = dk.id) \
      left join eqm_area_tbl as a on (a.code_eqp = eq.id) \
      left join clm_client_tbl as c on (c.id = a.id_client) \
      where cs.code_eqp = :eqp_id;";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
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
     grStations->ColWidths[0]=300;     
     grStations->ColWidths[1]=0;
     grStations->ColWidths[2]=200;

     grStations->RowCount=ZEqpQuery->RecordCount;
     grStations->Cells[0][0]="";
     grStations->Cells[1][0]="";
     grStations->Cells[2][0]="";

     for(int i=0;i<=ZEqpQuery->RecordCount-1;i++)
      {
       grStations->Cells[0][i]=ZEqpQuery->FieldByName("name_eqp")->AsString +"   ("+ ZEqpQuery->FieldByName("name")->AsString+")";
       grStations->Cells[1][i]=ZEqpQuery->FieldByName("id")->AsString;
       grStations->Cells[2][i]=ZEqpQuery->FieldByName("client")->AsString;
       ZEqpQuery->Next();
      }
     ZEqpQuery->Close();
}
//---------------------------------------------------------------------------
void TfEqpEdit::ShowEqpDet(int m)
{
  if (DetEditForm!=NULL) DetEditForm->Close();
  DetEditForm=NULL;
  if (DetEditName=="")
  {
   Height=PageControl->Height+CoolBar1->Height+30;
   return;
  }
  try
  {
   Application->CreateForm(FindClass(DetEditName), &DetEditForm);
  }
   catch(...)
   {
    ShowMessage("Ошибка при создании формы "+DetEditName);
    return;

   };
//  ZEqpQuery->Sql->Clear();
  DetEditForm->HostDockSite=pEqpDet;
  DetEditForm->eqp_id=eqp_id;
  DetEditForm->usr_id=usr_id;
  DetEditForm->eqp_type=EqpType;
 // DetEditForm->is_res=is_res;

  DetEditForm->mode=m;
  DetEditForm->fReadOnly=fReadOnly;
  DetEditForm->CangeLogEnabled=CangeLogEnabled;
  DetEditForm->abonent_id = abonent_id;
 // DetEditForm->is_res=(abonent_id==ResId);
  DetEditForm->ZEqpQuery=ZEqpQuery;
  DetEditForm->Show();
}
//---------------------------------------------------------------------------

bool  TfEqpEdit::ShowData(int eqp,bool readonly)
{
   SaveOnExit();

   edName_eqp->ReadOnly=!ed_name_enable;
   edNum_eqp->ReadOnly=!ed_num_enable;
   edAddress->ReadOnly=!ed_addr_enable;
   chLoss_power->Enabled=ed_lost_enable;
   sbSelAddr->Enabled=ed_addr_enable;


   fReadOnly=readonly;
   IsModified=false;

   if (!is_res)
   {
//-   tbAddAbon->Visible=false;
//-   tbDelAbon->Visible=false;
//    tsUse->TabVisible=false;
   }

   if (fReadOnly)
   {
    EqpToolBar->Enabled=false;
    sbSelAddr->Enabled=false;
   }
//   tbDelInst->Enabled=true;
   tbSave->Enabled=bt_save_enable;
   tbCancel->Enabled=true;
   edDt_install->Enabled=false;
   edAddress->Text="";

// Получим начальные данные
   eqp_id=eqp;
   mode=1;

   sqlstr="select eq.type_eqp,eq.name_eqp,eq.num_eqp,eq.id_addres,eq.dt_install,eq.dt_change,eq.loss_power,eq.is_owner,dk.name AS kindname, dk.inst_station,dk.calc_lost, dkp.form_name \
   from eqm_equipment_tbl AS eq JOIN (eqi_device_kinds_tbl AS dk LEFT JOIN eqi_device_kinds_prop_tbl AS dkp ON (dkp.type_eqp=dk.id)) ON (eq.type_eqp=dk.id) \
   where (eq.id = :eqp_id);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
   try
   {
    ZEqpQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
    return false;
   }
   if (ZEqpQuery->RecordCount!=0)
   {
     ZEqpQuery->First();

     //Тип оборудования и таблици
     EqpType=ZEqpQuery->FieldByName("type_eqp")->AsInteger;
     inst_station=ZEqpQuery->FieldByName("inst_station")->AsInteger;
     if (EqpType==1) lNumReq->Visible=true;
     else lNumReq->Visible=false;
 //Для фидеров/площадок/подстанций спрятать вкладки принадлежности
     if (inst_station==1)
     {
      tsUse->TabVisible=false;
      tsPlaces->TabVisible=false;
      btAdditionalParams->Visible= true;

      if (EqpType==11)
      {
        CangeLogEnabled = true;
      }
     }
    else
     {
      tsUse->TabVisible=true;
      tsPlaces->TabVisible=true;
      if (EqpType==12)
        btAdditionalParams->Visible= true;
      else
        btAdditionalParams->Visible= false;      
     }

    tbNewInst->Enabled=tsPlaces->TabVisible&&bt_area_enable;
    tbAddAbon->Enabled=tsUse->TabVisible&&bt_abon_enable;

//     if ((EqpType==1)||(EqpType==12)) // СЧЕТЧИКИ И ТОЧКИ УЧЕТА
//       tsUse->TabVisible=true;
//     else
//       tsUse->TabVisible=false;

     //////////id_table=ZEqpQuery->FieldByName("id_table")->AsInteger;
     //////////id_table_ind=ZEqpQuery->FieldByName("id_table_ind")->AsInteger;
     DetEditName=ZEqpQuery->FieldByName("form_name")->AsString;

     lType_eqp->Caption=ZEqpQuery->FieldByName("kindname")->AsString;
     edName_eqp->Text=ZEqpQuery->FieldByName("name_eqp")->AsString;
     edNum_eqp->Text=ZEqpQuery->FieldByName("Num_eqp")->AsString;
     id_address=ZEqpQuery->FieldByName("id_addres")->AsInteger;
///////     edAddress->Text=ZEqpQuery->FieldByName("full_adr")->AsString;
     lCode_eqp->Text=IntToStr(eqp_id);

     if (!ZEqpQuery->FieldByName("Dt_install")->IsNull)
        edDt_install->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("Dt_install")->AsDateTime);
     else edDt_install->Text="  .  .    ";

     if (!ZEqpQuery->FieldByName("Dt_change")->IsNull)
        edDt_change->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("Dt_change")->AsDateTime);
     else edDt_change->Text="  .  .    ";

     if (ZEqpQuery->FieldByName("calc_lost")->AsInteger==1)
       chLoss_power->Enabled=ed_lost_enable;
     else
       chLoss_power->Enabled=false;

     if (ZEqpQuery->FieldByName("Loss_power")->AsInteger==1)
       chLoss_power->Checked=true;
     else
       chLoss_power->Checked=false;

     if (ZEqpQuery->FieldByName("is_owner")->AsInteger==1)
       chOwner->Checked=true;
     else
       chOwner->Checked=false;

     ZEqpQuery->Close();
     IsModified=false; // После того, как chLoss_power->Checked сделал его true
     ShowEqpInst();
//     ShowEqpAddress();
     ShowEqpUse();
     ShowEqpDet(1);
    }
   else return false;

//   edDt_install->Enabled=false;
// отдельно адресс
   if (id_address>0)
   {
     sqlstr="select full_adr from adv_address_tbl where id = :addr ;";
     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("addr")->AsInteger=id_address;
     try
     {
      ZEqpQuery->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
      return false;
     }
     if (ZEqpQuery->RecordCount!=0)
     {
       ZEqpQuery->First();
       edAddress->Text=ZEqpQuery->FieldByName("full_adr")->AsString;
     }
   ZEqpQuery->Close();
   }
  Visible=true;
  lLastIndDate->Caption ="";
  lDt_indicat->Caption ="";
   ////////////Если форма без предка, то надо зарегистрироваться
  if (Parent==NULL)
  {
  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
  }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem(edName_eqp->Text.c_str(), true, ActivateMenu));
  Caption=edName_eqp->Text;
  }
  else
  {
   if (ParentTreeForm!=NULL)
   {
    if (ParentTreeForm->last_indic_date!=TDateTime(0))
       lLastIndDate->Caption =  "Дата последнего отчета о потр. "+FormatDateTime("dd.mm.yyyy",ParentTreeForm->last_indic_date);

    lDt_indicat->Caption =  "Расчетный день : "+ IntToStr(ParentTreeForm->dt_indicat);
   }
  }
 return true;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::tbNewInstClick(TObject *Sender)
{
 ShowPlaces();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::tbDelInstClick(TObject *Sender)
{
   ZEqpQuery->Close();

   if (MessageDlg("Удалить информацию о размещении ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;
   int operation;

   if (is_res)
      operation =MainForm->PrepareChange(ZEqpQuery,1,0,eqp_id,usr_id,CangeLogEnabled,Now());
   else
      operation =MainForm->PrepareChange(ZEqpQuery,1,0,eqp_id,usr_id,CangeLogEnabled);

   if (operation ==-1)
    {
     return;
    };

   sqlstr="delete from eqm_compens_station_inst_tbl \
      where (( code_eqp= :eqp_id)and(code_eqp_inst= :inst_id ));";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;

     ZEqpQuery->ParamByName("inst_id")->AsInteger=
        StrToInt(grStations->Cells[1][grStations->Row]);

     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return;
     }
     ZEqpQuery->Close();
     MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled&&(!is_res));
//     ZEqpQuery->Transaction->Commit();
     ShowEqpInst();

}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::FormCreate(TObject *Sender)
{
DetEditForm=NULL;

TMetaClass *MetaClass = __classid(TfSimpleEqpDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfALineDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfEqpMeterDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfBorderDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfStationDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfEqpPointDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfFiderDet);
RegisterClasses(&MetaClass, 0);

MetaClass = __classid(TfGroundDet);
RegisterClasses(&MetaClass, 0);

}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::tbSaveClick(TObject *Sender)
{
   if(!CheckData()) return;

   int operation=MainForm->PrepareChange(ZEqpQuery,1,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)
    {
     return;
    };

   ZEqpQuery->Close();
   ZEqpQuery->Transaction->NewStyleTransactions=false;
   ZEqpQuery->Transaction->TransactSafe=true;
   ZEqpQuery->Transaction->AutoCommit=false;
   ZEqpQuery->Transaction->Commit();
   ZEqpQuery->Transaction->StartTransaction();


   sqlstr="update eqm_equipment_tbl set name_eqp = :name_eqp, num_eqp = :num_eqp , \
      loss_power = :loss_power, id_addres= :id_addres ,dt_install = :dt_install, is_owner = :is_owner  where id = :eqp_id;";

     ShortDateFormat="dd/mm/yyyy";
     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);

     if (edName_eqp->Text!="")
       ZEqpQuery->ParamByName("name_eqp")->AsString=edName_eqp->Text;
     if (edNum_eqp->Text!="")
       ZEqpQuery->ParamByName("num_eqp")->AsString=edNum_eqp->Text;

     if (edDt_install->Text!="  .  .    ")
       ZEqpQuery->ParamByName("dt_install")->AsDateTime=StrToDate(edDt_install->Text);
     else
       ZEqpQuery->ParamByName("dt_install")->Clear();
/*
     if (edDt_change->Text!="  .  .    ")
       ZEqpQuery->ParamByName("dt_change")->AsDateTime=StrToDate(edDt_change->Text);
     else
       ZEqpQuery->ParamByName("dt_change")->Clear();
*/
     ZEqpQuery->ParamByName("loss_power")->AsInteger=chLoss_power->Checked?1:0;
     ZEqpQuery->ParamByName("is_owner")->AsInteger=chOwner->Checked?1:0;
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
     ZEqpQuery->ParamByName("id_addres")->AsInteger=id_address;

     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(EDatabaseError &e)
     {
      ShowMessage("Ошибка : "+e.Message.SubString(8,200));
      ZEqpQuery->Close();
      ZEqpQuery->Transaction->Rollback();
      return;
     }
     ZEqpQuery->Close();
     IsModified=false;
     if (DetEditForm!=NULL)
     {
      if (!DetEditForm->SaveData())
      {
      //обработка ошибки
       ZEqpQuery->Transaction->Rollback();
       return;
      }
     }
     MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
     edDt_install->Enabled=false;

    if ((ParentTreeForm!=NULL)&&(ParentTreeForm->CurrNode!=NULL))
    {
     if (ParentTreeForm->eqpnamecopy) ParentTreeForm->CurrNode->Text=edName_eqp->Text;
    }

    ZEqpQuery->Transaction->Commit();
    ZEqpQuery->Transaction->AutoCommit=true;
    ZEqpQuery->Transaction->TransactSafe=false;

    if (ParentDataSet!=NULL)
    {
     ParentDataSet->Refresh();
    };

}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::CreateNewEquipment(int eqpid)
{
 if (Visible)
 {
  SaveOnExit();
  Hide();
 }
 ShowKinds();
 mode=0;
 eqp_id=eqpid;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::CreateNewByType(int type,AnsiString type_name)
{
 if (!Visible) Show();
 else  SaveOnExit();

 EqpType=type;
 eqp_id=0;
 id_address=0;
 lType_eqp->Caption=type_name;
 mode=0;
 ShowNewEqp();

 ////////////Если форма без предка, то надо зарегистрироваться
  if (Parent==NULL)
  {
  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
    }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("Новое оборудование", true, ActivateMenu));
  Caption="Новое оборудование";
  //А также разрешить сохранение нового

  tbSave->OnClick=tbSaveClickAlt;
  tbCancel->OnClick=tbCancelClickAlt;
  tbSave->Enabled=bt_save_enable;
  tbCancel->Enabled=true;
  }
}
//---------------------------------------------------------------------------

int __fastcall TfEqpEdit::SaveNewEquipment(void)
{
 //

   mode=1;
   btAdditionalParams->Enabled= true;

   if ((ParentTreeForm!=NULL)&&(ParentTreeForm->NewNode!=NULL))
   ((PTreeNodeData)(ParentTreeForm->NewNode->Data))->type_eqp=EqpType;

//   tbDelInst->Enabled=true;

   tbNewInst->Enabled=tsPlaces->TabVisible&&bt_area_enable;
   tbAddAbon->Enabled=tsUse->TabVisible&&bt_abon_enable;

   tbSave->Enabled=bt_save_enable;
   tbCancel->Enabled=true;
   tbSave->OnClick=tbSaveClick;
   tbCancel->OnClick=tbCancelClick;

   ZEqpQuery->Close();

   if (Parent==NULL)
   {
    ZEqpQuery->Transaction->NewStyleTransactions=false;
    ZEqpQuery->Transaction->TransactSafe=true;
    ZEqpQuery->Transaction->AutoCommit=false;
    ZEqpQuery->Transaction->Commit();
    ZEqpQuery->Transaction->StartTransaction();
   }

   sqlstr="select eqm_neweqp_fun( :type_eqp, :name_eqp, :num_eqp, :id_addres, :dt_install, :dt_change, :loss_power, :is_owner);";
     //Пока без адреса
     ShortDateFormat="dd/mm/yyyy";
     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("type_eqp")->AsInteger=EqpType;
     if (edName_eqp->Text!="")
       ZEqpQuery->ParamByName("name_eqp")->AsString=edName_eqp->Text;
     if (edNum_eqp->Text!="")
       ZEqpQuery->ParamByName("num_eqp")->AsString=edNum_eqp->Text;

     ZEqpQuery->ParamByName("dt_install")->AsDateTime=StrToDate(edDt_install->Text);
     LastDate=StrToDate(edDt_install->Text);
     ZEqpQuery->ParamByName("dt_change")->AsDateTime=StrToDate(edDt_install->Text);
     ZEqpQuery->ParamByName("id_addres")->AsInteger=id_address;

     ZEqpQuery->ParamByName("loss_power")->AsInteger=chLoss_power->Checked?1:0;
     ZEqpQuery->ParamByName("is_owner")->AsInteger=chOwner->Checked?1:0;

     try
     {
      ZEqpQuery->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
      if (Parent==NULL) ZEqpQuery->Transaction->Rollback();
      return 0;
     }
     IsModified=false;
     if (ZEqpQuery->RecordCount!=0)
      {
      ZEqpQuery->First();
      eqp_id=ZEqpQuery->Fields->Fields[0]->AsInteger;
      };
     ZEqpQuery->Close();

     //----------------------------------------
     if (inst_station==1) //для площадок /подстанций записать принадлежность ее к абоненту
     {
      ZEqpQuery->Close();

      sqlstr="insert into eqm_area_tbl (code_eqp,id_client) values ( :eqp_id, :client_id);";

      ZEqpQuery->Sql->Clear();
      ZEqpQuery->Sql->Add(sqlstr);

      ZEqpQuery->ParamByName("client_id")->AsInteger=abonent_id;
      ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;

      try
      {
       ZEqpQuery->ExecSql();
      }
      catch(...)
      {
       ShowMessage("Ошибка SQL :"+sqlstr);
       ZEqpQuery->Close();
       ZEqpQuery->Transaction->Rollback();
       return 0;
      }
      ZEqpQuery->Close();
     //----------------------------------------
     }

     if (DetEditForm!=NULL)
     {
      if( DetEditForm->SaveNewData(eqp_id))
         {
         if (Parent==NULL)
         {
          ZEqpQuery->Transaction->Commit();
          ZEqpQuery->Transaction->AutoCommit=true;
          ZEqpQuery->Transaction->TransactSafe=false;
         }
         if (ParentDataSet!=NULL)
         {
            ParentDataSet->Refresh();
         };

         return eqp_id;
         }
      else
         {
         if (Parent==NULL)
         {
          ZEqpQuery->Transaction->Rollback();
          ZEqpQuery->Transaction->AutoCommit=true;
          ZEqpQuery->Transaction->TransactSafe=false;
         }
         if (ParentDataSet!=NULL)
         {
            ParentDataSet->Refresh();
         };

         return 0;
         }
     }


     if (Parent==NULL)
     {
      ZEqpQuery->Transaction->Commit();
      ZEqpQuery->Transaction->AutoCommit=true;
      ZEqpQuery->Transaction->TransactSafe=false;
     }

    if (ParentDataSet!=NULL)
    {
      ParentDataSet->Refresh();
    };

     edDt_install->Enabled=false;

     return eqp_id;
}
//---------------------------------------------------------------------------
bool __fastcall TfEqpEdit::DelEquipment(int id)
{
 //
   ZEqpQuery->Close();

   sqlstr="delete from eqm_equipment_tbl where id = :id;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   ZEqpQuery->ParamByName("id")->AsInteger=id;

   try
     {
      ZEqpQuery->ExecSql();
     }
     catch(EDatabaseError &e)
     {
      ShowMessage("Ошибка : "+e.Message.SubString(8,200));
      ZEqpQuery->Close();
      return false;
     }

     ZEqpQuery->Close();
     return true;

}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::PlaceAccept (TObject* Sender)
{
   int NewInst=StrToInt(WGrid->DBGrid->StringDest);
   int NewInstTupe=WGrid->DBGrid->Query->FieldByName("type_eqp")->AsInteger;


   int operation=MainForm->PrepareChange(ZEqpQuery,1,0,eqp_id,usr_id,CangeLogEnabled&&(!is_res));
   if (operation ==-1)
    {
     return;
    };

   ZEqpQuery->Close();
   ZEqpQuery->Sql->Clear();
   
   int refresh=0;
   // !!!Должна быть проверка на уникальность
   for (int i =0; i<=grStations->RowCount-1;i++)
    {
      if (grStations->Cells[1][i]!="")
        if (StrToInt(grStations->Cells[1][i])==NewInst) refresh = 1;
    }

    if(refresh == 0)
    {
      sqlstr="INSERT into eqm_compens_station_inst_tbl(code_eqp,code_eqp_inst) \
        VALUES( :eqp_id, :inst_id );";

      ZEqpQuery->Sql->Add(sqlstr);
    }

    if (NewInstTupe==15) //фидер - расставим принадлежность вниз по дереву
    {
     sqlstr=" select eqm_set_inst_fun( :eqp_id, :inst_id, :id_owner);";
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("id_owner")->AsInteger=abonent_id;
    }

    if((refresh == 0)||(NewInstTupe==15))
    {
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
     ZEqpQuery->ParamByName("inst_id")->AsInteger=NewInst;
     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return;
     }
     ZEqpQuery->Close();
//     ZEqpQuery->Transaction->Commit();
    }

    MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled&&(!is_res));
    ShowEqpInst();
};
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::KindAccept (TObject* Sender)
{
//
 if (!Visible) Show();
 EqpType=StrToInt(WGrid->DBGrid->StringDest);
 lType_eqp->Caption=WGrid->DBGrid->Query->FieldByName("name")->AsString;

 ShowNewEqp();
};
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::tbCancelClick(TObject *Sender)
{
// IsModified=false;
 ShowData(eqp_id);
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::KindClose(TObject* Sender, bool &CanClose)
{
 if (!Visible) ParentTreeForm->tbCancelClick(Sender);
// else  ParentTreeForm->NewNode->EditText();
}
//---------------------------------------------------------------------------
//void _fastcall TfEqpEdit::ActivateMenu(TObject *Sender) {
//  if (Enabled) Show();
//}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::ShowNewEqp(void)
{

  edName_eqp->ReadOnly=false;
  edNum_eqp->ReadOnly=false;
  edAddress->ReadOnly=false;
  chLoss_power->Enabled=true;
  sbSelAddr->Enabled=true;

 if (!is_res)
  {
//  tbAddAbon->Visible=false;
//  tbDelAbon->Visible=false;
//  tsUse->TabVisible=false;
  }

  if (EqpType==1) lNumReq->Visible=true;
  else lNumReq->Visible=false;

// IsModified=true;
 if (eqp_id!=0) //Если так, то это замена - надо оставить старую дату и т.д.
 {
   sqlstr="select eq.type_eqp,eq.id_addres,eq.dt_install,eq.dt_change,eq.loss_power , is_owner \
   from eqm_equipment_tbl AS eq where eq.id = :eqp_id;";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
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

     id_address=ZEqpQuery->FieldByName("id_addres")->AsInteger;

     if (!ZEqpQuery->FieldByName("Dt_install")->IsNull)
        edDt_install->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("Dt_install")->AsDateTime);
     else edDt_install->Text="  .  .    ";

     if (!ZEqpQuery->FieldByName("Dt_change")->IsNull)
        edDt_change->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName("Dt_change")->AsDateTime);
     else edDt_change->Text="  .  .    ";

     if (ZEqpQuery->FieldByName("Loss_power")->AsInteger==1)
       chLoss_power->Checked=true;
     else
       chLoss_power->Checked=false;

     if (ZEqpQuery->FieldByName("is_owner")->AsInteger==1)
       chOwner->Checked=true;
     else
       chOwner->Checked=false;

     ZEqpQuery->Close();
  }
  edDt_install->Enabled=false;
 }
 else
 {
  edDt_install->Enabled=true;
  edDt_change->Text="  .  .    ";

  if (CangeLogEnabled)
    edDt_install->Text="  .  .    ";
  else
   {
    if (LastDate!=TDate(0))
      edDt_install->Text=FormatDateTime("dd.mm.yyyy",LastDate);
    else
      edDt_install->Text="  .  .    ";
   }
  id_address=0;
 }

 edName_eqp->Text="";
 edNum_eqp->Text="";
 chLoss_power->Checked=false;
 chOwner->Checked=true; 

 grStations->ColWidths[1]=0;
 grStations->RowCount=1;
 grStations->Cells[0][0]="";
 grStations->Cells[1][0]="";
 grStations->Cells[2][0]="";

 tbDelInst->Enabled=false;
 tbNewInst->Enabled=false;
 tbAddAbon->Enabled=false;
 tbSave->Enabled=false;
 tbCancel->Enabled=false;

 //Получить признак расчета потерь для данного вида
 sqlstr="select calc_lost,inst_station from eqi_device_kinds_tbl where (id= :EqpType);";
 ZEqpQuery->Sql->Clear();
 ZEqpQuery->Sql->Add(sqlstr);
 ZEqpQuery->ParamByName("EqpType")->AsInteger=EqpType;
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
     if (ZEqpQuery->FieldByName("calc_lost")->AsInteger==1)
       chLoss_power->Enabled=true;
     else
       chLoss_power->Enabled=false;

     inst_station=ZEqpQuery->FieldByName("inst_station")->AsInteger;
     ZEqpQuery->Close();
   };

 //Для фидеров/площадок/подстанций спрятать вкладки принадлежности
 if (inst_station==1)
 {
  tsUse->TabVisible=false;
  tsPlaces->TabVisible=false;
 }
 else
 {
  tsUse->TabVisible=true;
  tsPlaces->TabVisible=true;
 }

 // Получим имя формы детализации
 sqlstr="select form_name, id_icon from eqi_device_kinds_prop_tbl where (type_eqp= :EqpType);";
 ZEqpQuery->Sql->Clear();
 ZEqpQuery->Sql->Add(sqlstr);
 ZEqpQuery->ParamByName("EqpType")->AsInteger=EqpType;
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
     DetEditName=ZEqpQuery->FieldByName("form_name")->AsString;
     if ((ParentTreeForm!=NULL)&&(ParentTreeForm->NewNode!=NULL))
        ParentTreeForm->NewNode->ImageIndex=ZEqpQuery->FieldByName("id_icon")->AsInteger;
//        ((PTreeNodeData)(ParentTreeForm->NewNode->Data))->type_eqp=EqpType;
     ZEqpQuery->Close();

     ShowEqpDet(0);
    }
   else
    Height=PageControl->Height+CoolBar1->Height+30;

   btAdditionalParams->Enabled= false; 

}
//---------------------------------------------------------
void __fastcall TfEqpEdit::grStationsEnter(TObject *Sender)
{
if ((mode!=0)&&!((grStations->RowCount==1)&&(grStations->Cells[1][0]=="")))
tbDelInst->Enabled=bt_area_enable;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::grStationsExit(TObject *Sender)
{
 tbDelInst->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::sbSelAddrClick(TObject *Sender)
{
//
   TWTDBGrid* Grid;
   Grid=MainForm->AdmAddressMSel(NULL);
   if(Grid==NULL) return;
   else WAddrGrid=Grid;

   WAddrGrid->StringDest = "1";
   WAddrGrid->OnAccept=MainAddrAccept;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::grAddressClick(TObject *Sender)
{
//
}
//---------------------------------------------------------------------------
void TfEqpEdit::ShowEqpAddress(void)
{
     sqlstr="select p.id_addres,adr.full_adr from eqm_line_path_tbl as p, \
     adv_address_tbl as adr where p.code_eqp = :eqp_id and p.id_addres=adr.id \
     order by pathorder;";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
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
     grAddress->ColWidths[1]=0;
     grAddress->RowCount=ZEqpQuery->RecordCount;
     grAddress->Cells[0][0]="";
     grAddress->Cells[1][0]="";

     for(int i=0;i<=ZEqpQuery->RecordCount-1;i++)
      {
       grAddress->Cells[0][i]=ZEqpQuery->FieldByName("full_adr")->AsString;
       grAddress->Cells[1][i]=ZEqpQuery->FieldByName("id_addres")->AsString;
       ZEqpQuery->Next();
      }
     ZEqpQuery->Close();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::tbDelAddressClick(TObject *Sender)
{
   ZEqpQuery->Close();

   if (MessageDlg("Удалить адрес ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;

   sqlstr="delete from eqm_line_path_tbl \
      where (( code_eqp= :eqp_id)and(id_addres = :id_addres));";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;

     ZEqpQuery->ParamByName("id_addres")->AsInteger=
        StrToInt(grAddress->Cells[1][grAddress->Row]);

     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return;
     }
     ZEqpQuery->Close();
//     ZEqpQuery->Transaction->Commit();
     ShowEqpAddress();

}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::tbAddAddressClick(TObject *Sender)
{
   TWTDBGrid* Grid;
   Grid=MainForm->AdmAddressMSel(NULL);
   if(Grid==NULL) return;
   else WAddrGrid=Grid;

   WAddrGrid->StringDest = "1";
   WAddrGrid->OnAccept=AddrAccept;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::sbAddrUpClick(TObject *Sender)
{
   if (fReadOnly) return;
  //Перемещение адреса вверх - вниз

   ZEqpQuery->Close();

   if (((TButton*)Sender)->Name=="sbAddrUp")
     sqlstr="select eqm_adr_up_fun( :eqp_id, :id_addres);";
   if (((TButton*)Sender)->Name=="sbAddrDown")
     sqlstr="select eqm_adr_down_fun( :eqp_id, :id_addres);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
   ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;

   ZEqpQuery->ParamByName("id_addres")->AsInteger=
       StrToInt(grAddress->Cells[1][grAddress->Row]);

   try
     {
      ZEqpQuery->ExecSql();
     }
   catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return;
     }
   ZEqpQuery->Close();
//   ZEqpQuery->Transaction->Commit();
   ShowEqpAddress();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::grAddressEnter(TObject *Sender)
{
if (mode==1)
 {
 tbAddAddress->Enabled=true;
 if ((grAddress->RowCount==1)&&(grAddress->Cells[1][0]==""))
    return;
 tbDelAddress->Enabled=true;
 sbAddrUp->Enabled=true;
 sbAddrDown->Enabled=true;
 }
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::grAddressExit(TObject *Sender)
{
tbAddAddress->Enabled=false;
tbDelAddress->Enabled=false;
sbAddrUp->Enabled=false;
sbAddrDown->Enabled=false;
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::tbSaveClickAlt(TObject *Sender)
{
// Режим создания нового не из дерева (подстанции и площадки)
 if(!CheckData()) return;
 SaveNewEquipment();
 Close();
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::tbCancelClickAlt(TObject *Sender)
{
// Режим создания нового не из дерева (подстанции и площадки)
 Close();
}
//---------------------------------------------------------------------------
bool __fastcall TfEqpEdit::ChangeEquipment(void)
{
 //  SaveOnExit();

   int operation=MainForm->PrepareChange(ZEqpQuery,1,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)
    {
     return false;
    };

   ZEqpQuery->Close();

   sqlstr="update eqm_equipment_tbl \
      set type_eqp=  :type_eqp, name_eqp = :name_eqp, num_eqp = :num_eqp , \
      loss_power = :loss_power, is_owner = :is_owner where id = :eqp_id;";
     //Пока без адреса
     ShortDateFormat="dd/mm/yyyy";
     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("type_eqp")->AsInteger=EqpType;
     if (edName_eqp->Text!="")
       ZEqpQuery->ParamByName("name_eqp")->AsString=edName_eqp->Text;
     if (edNum_eqp->Text!="")
       ZEqpQuery->ParamByName("num_eqp")->AsString=edNum_eqp->Text;

//     if (edDt_install->Text!="  .  .    ")
//       ZEqpQuery->ParamByName("dt_install")->AsDateTime=StrToDate(edDt_install->Text);
//     else
//       ZEqpQuery->ParamByName("dt_install")->Clear();

//     if (edDt_change->Text!="  .  .    ")
//       ZEqpQuery->ParamByName("dt_change")->AsDateTime=StrToDate(edDt_change->Text);
//     else
//       ZEqpQuery->ParamByName("dt_change")->Clear();

     ZEqpQuery->ParamByName("loss_power")->AsInteger=chLoss_power->Checked?1:0;
     ZEqpQuery->ParamByName("is_owner")->AsInteger=chOwner->Checked?1:0;     
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;

     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return false;
     }
     ZEqpQuery->Close();
     bool rez;
     if (DetEditForm!=NULL)
     {
      if((PTreeNodeData(ParentTreeForm->NewNode->Data))->type_eqp==EqpType)
          rez=DetEditForm->SaveData();
      else
          {
           (PTreeNodeData(ParentTreeForm->CurrNode->Data))->type_eqp=EqpType;
           rez=DetEditForm->SaveNewData(eqp_id);
          }
     }
     else  rez= true;

     edDt_install->Enabled=true;
     MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
     return rez;
}
//-----------------------------------------------------------------------
bool TfEqpEdit::CheckData(void)
{
   if (edDt_install->Text=="  .  .    ")
   {
     ShowMessage("Не заполнена дата установки.");
     return false;
   }
   if (edName_eqp->Text=="")
   {
     ShowMessage("Не заполнено наименование.");
     return false;
   }

   if ((lNumReq->Visible)&&(edNum_eqp->Text==""))
   {
     ShowMessage("Не заполнен заводской номер.");
     return false;
   }

   if (DetEditForm!=NULL)
       return DetEditForm->CheckData();

   return true;
}
//------------------------------------------------------------------
void __fastcall TfEqpEdit::AddrAccept (TObject* Sender)
{
 //
   int NewAddr=WAddrGrid->Table->FieldByName("id")->AsInteger;

   ZEqpQuery->Close();
   // !!!Должна быть проверка на уникальность
   for (int i =0; i<=grAddress->RowCount-1;i++)
    {
      if (grAddress->Cells[1][i]!="")
       if (StrToInt(grAddress->Cells[1][i])==NewAddr) return;
    }

   sqlstr="INSERT into eqm_line_path_tbl(code_eqp,id_addres)  VALUES( :eqp_id, :id_addres );";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
     ZEqpQuery->ParamByName("id_addres")->AsInteger=NewAddr;
     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      return;
     }
     ZEqpQuery->Close();
//     ZEqpQuery->Transaction->Commit();
     ShowEqpAddress();

};
//------------------------------------------------------------------
void __fastcall TfEqpEdit::MainAddrAccept (TObject* Sender)
{
    id_address=WAddrGrid->Table->FieldByName("id")->AsInteger;

     sqlstr="select full_adr from adv_address_tbl where id = :adr_id;";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("adr_id")->AsInteger=id_address;
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

     edAddress->Text=ZEqpQuery->Fields->Fields[0]->AsString;
     ZEqpQuery->Close();
     IsModified=true;
};
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::edDataChange(TObject *Sender)
{
if (((TEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------
bool __fastcall TfEqpEdit::SaveOnExit(void)
{
if(!bt_save_enable)
   {
     IsModified=false;
     return false;
   }

if (!fReadOnly&&(IsModified||((DetEditForm!=NULL)&&(DetEditForm->IsModified))))
 {
   if (MessageDlg("Сохранить изменения ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
   {
     IsModified=false;
     return false;
   }
    IsModified=false;
    tbSaveClick(NULL);
    return true;

   /*   if(IsModified)
    {
    IsModified=false;
    tbSaveClick(NULL);
    }
   else
    {
     if((DetEditForm!=NULL)&&(DetEditForm->IsModified))
      {
      if (DetEditForm->CheckData())
       {
       DetEditForm->IsModified=false;
       if (!DetEditForm->SaveData())
        {
        //обработка ошибки
       //  ZEqpQuery->Transaction->Rollback();
         return;
        }
      // ZEqpQuery->Transaction->Commit();
       }
      }
    } */
 }
 else
 {
   return false;
 }
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::FormHide(TObject *Sender)
{
// SaveOnExit();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::chLoss_powerClick(TObject *Sender)
{
//if (this->ActiveControl->Name==((TCheckBox*)Sender)->Name)
IsModified=true;
}
//---------------------------------------------------------------------------
void TfEqpEdit::ShowEqpUse(void)
{
     sqlstr="select cl.id, cl.short_name,use.dt_install \
      from eqm_eqp_use_tbl AS use JOIN clm_client_tbl AS cl ON (cl.id=use.id_client)\
      where use.code_eqp = :eqp_id;";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
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
     grAbons->ColWidths[2]=0;
     grAbons->ColWidths[1]=200;
     grAbons->RowCount=ZEqpQuery->RecordCount;
     grAbons->Cells[0][0]="";
     grAbons->Cells[1][0]="";
     grAbons->Cells[2][0]="";

     tbDelAbon->Enabled=false;
     for(int i=0;i<=ZEqpQuery->RecordCount-1;i++)
      {
       // Если оборудование к кому-то принадлежит, пишем историю
       CangeLogEnabled=true;
       grAbons->Cells[0][i]=ZEqpQuery->FieldByName("short_name")->AsString;
       grAbons->Cells[1][i]=ZEqpQuery->FieldByName("dt_install")->AsString;
       grAbons->Cells[2][i]=ZEqpQuery->FieldByName("id")->AsString;
       ZEqpQuery->Next();
       tbDelAbon->Enabled=bt_abon_enable;
      }
     ZEqpQuery->Close();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::tbDelAbonClick(TObject *Sender)
{
   ZEqpQuery->Close();

   if (MessageDlg("Удалить вхождение в схему абонента ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;

   int operation=MainForm->PrepareChange(ZEqpQuery,5,0,eqp_id,usr_id,CangeLogEnabled);
   if (operation ==-1)  return;


   sqlstr="delete from eqm_eqp_use_tbl \
      where (( code_eqp= :eqp_id)and(id_client = :id_client));";

     ZEqpQuery->Sql->Clear();
     ZEqpQuery->Sql->Add(sqlstr);
     ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;

     ZEqpQuery->ParamByName("id_client")->AsInteger=
        StrToInt(grAbons->Cells[2][grAbons->Row]);

     try
     {
      ZEqpQuery->ExecSql();
     }
     catch(EDatabaseError &e)
     {
      ShowMessage("Ошибка : "+e.Message.SubString(8,200));
      ZEqpQuery->Close();
//      ZEqpQuery->Transaction->Rollback();
      //При ошибке отменяется транзакция и удалаются данные временной
      // таблици, занесенные пред. транзакцией
      MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
      operation=0;
//      ZEqpQuery->Transaction->Commit();

      return;
     }
     ZEqpQuery->Close();
     MainForm->AfterChange(ZEqpQuery,operation,CangeLogEnabled);
     operation=0;

//     ZEqpQuery->Transaction->Commit();
     ShowEqpUse();
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::tbAddAbonClick(TObject *Sender)
{
    TWTDBGrid* Grid;
    Grid=MainForm->CliClientMSel();
    if(Grid==NULL) return;
    else WAbonGrid=Grid;

//    WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
    WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
    WAbonGrid->StringDest = "1";
    WAbonGrid->OnAccept=AbonAccept;
//    ((TWTDoc *)(WAbonGrid->Owner))-> OnCloseQuery=AbonClose;

}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::AbonAccept (TObject* Sender)
{
  //int abonent=WAbonGrid->Table->FieldByName("id")->AsInteger;
  int abonent = WAbonGrid->Query->FieldByName("id")->AsInteger;
  //Нельзя подключится к самому себе
  if (abonent==abonent_id)
  {
   ShowMessage("Нельзя выбриать РЕС.");
   return;
  }

  for (int i =0; i<=grAbons->RowCount-1;i++)
    {
      if (grAbons->Cells[1][i]!="")
       if (StrToInt(grAbons->Cells[1][i])==abonent) return;
    }

   //Спросим дату
   TDate EnergyDate;

   if (CangeLogEnabled)
    {
     TfChangeDate* fChangeDate;
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     fChangeDate->Label1->Caption="Дата установки";

     if (fChangeDate->ShowModal()!= mrOk)
     {
        delete fChangeDate;
//        ZEqpQuery->Transaction->Rollback();
        return ; // Отменить
     };
//     EnergyDate=fChangeDate->DateTime->Date;
     try
     {
      EnergyDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("Неверная дата");
      delete fChangeDate;
      return ;
     }

     delete fChangeDate;
    }
   else
    {
     ShortDateFormat="dd/mm/yyyy";
     EnergyDate=StrToDate(edDt_install->Text);
    }

   sqlstr="INSERT into eqm_eqp_use_tbl(code_eqp,id_client,dt_install) VALUES( :eqp_id, :id_client, :dt_install);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);

   sqlstr=" select eqm_set_use_fun( :eqp_id, :id_client, :id_owner, :dt_install);";
   ZEqpQuery->Sql->Add(sqlstr);

   ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_client")->AsInteger=abonent;
   ZEqpQuery->ParamByName("id_owner")->AsInteger=abonent_id;
   ZEqpQuery->ParamByName("dt_install")->AsDateTime=EnergyDate;
   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    ZEqpQuery->Close();
//    ZEqpQuery->Transaction->Rollback();
    return;
   }
   ZEqpQuery->Close();
//   ZEqpQuery->Transaction->Commit();
   ShowEqpUse();
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::PageControlEnter(TObject *Sender)
{
 if ((mode!=0)&&!((grAbons->RowCount==1)&&(grAbons->Cells[1][0]=="")))
 tbDelAbon->Enabled=bt_abon_enable;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::PageControlExit(TObject *Sender)
{
 tbDelAbon->Enabled=false;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::FormActivate(TObject *Sender)
{
/*if (is_res)
 {
 tbAddAbon->Visible=false;
 tbDelAbon->Visible=false;
 tsUse->Visible=false;
 }*/
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::edDt_installEnter(TObject *Sender)
{
if (edDt_install->Text=="  .  .    ") edDt_install->SelStart=0;
}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::tbHistoryClick(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (MainForm->ShowMDIChild("История", Owner)) {
    return;
  }
  if (DetEditForm)
   WHistoryEdit=new TfHistoryEdit(this,eqp_id,EqpType,DetEditForm->name_table,DetEditForm->name_table_ind);
  else
   WHistoryEdit=new TfHistoryEdit(this,eqp_id,EqpType,"","");

  WHistoryEdit->ShowAs("История изменений");
  WHistoryEdit->SetCaption("История изменений");

  WHistoryEdit->ID="История";

  WHistoryEdit->ShowData();

}
//---------------------------------------------------------------------------

void __fastcall TfEqpEdit::btAdditionalParamsClick(TObject *Sender)
{
  TWTQuery *QueryPar;

  TWinControl *Owner = this;
  // Если такое окно есть - активизируем и выходим
  if (MainForm->ShowMDIChild("Доп. параметры "+edName_eqp->Text, Owner)) {
    return;
  }

  QueryPar = new  TWTQuery(this);
  QueryPar->Options << doQuickOpen;

  QueryPar->Sql->Clear();
  QueryPar->Sql->Add("select p.*, i.name from mnm_eqp_params_tbl as p join mni_eqp_params_tbl as i on (i.id = p.id_param) where p.code_eqp = :code_eqp order by p.id_param;" );
  QueryPar->ParamByName("code_eqp")->AsInteger = eqp_id;

  WParamGrid = new TWTWinDBGrid(this, QueryPar,false);
  WParamGrid->SetCaption("Доп. параметры "+edName_eqp->Text);

  TWTQuery* Query = WParamGrid->DBGrid->Query;

  Query->AfterInsert=CancelInsert;
  Query->AfterDelete=CancelInsert;
  Query->BeforePost=AfterPost;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("name");

  Query->SetSQLModify("mnm_eqp_params_tbl",WList,NList,true,false,false);

  TWTField *Field;

  Field = WParamGrid->AddColumn("name", "Параметр", "Параметр");
  Field->SetReadOnly();
  Field = WParamGrid->AddColumn("value", "Значение", "Значение");

//  WParamGrid->DBGrid->FieldSource = WParamGrid->DBGrid->Query->GetTField("id");

//  WParamGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WParamGrid->DBGrid->OnAccept=ParamAccept;
  WParamGrid->DBGrid->Visible = true;

//  WParamGrid->DBGrid->ReadOnly=true;

  TWTToolBar* tb=WParamGrid->DBGrid->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);

    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
         tb->Buttons[i]->Visible = false;
       }
    if ( btn->ID=="DelRecord")
     {
         tb->Buttons[i]->OnClick=NULL;
         tb->Buttons[i]->Visible = false;
     }
   }

  dtAddParamDate = new TDateTimePicker(WParamGrid);
//  dtAddParamDate->Parent = WParamGrid->DBGrid->ToolBar->Buttons[1]->Parent;
  dtAddParamDate->Parent = WParamGrid->DBGrid->ToolBar;
//  dtAddParamDate->Left = 200;
//  dtAddParamDate->Top = 2;
  dtAddParamDate->Show();
  dtAddParamDate->Date = Now();

  WParamGrid->OnCloseQuery=AdditionalParamsGridClose;
  WParamGrid->ShowAs("Доп. параметры "+edName_eqp->Text);

};

//-----------------------------------------------------------------------------
void __fastcall TfEqpEdit::CancelInsert(TDataSet* DataSet)
{
  DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::AdditionalParamsGridClose(TObject *Sender, bool &CanClose)
{
 delete dtAddParamDate;
 CanClose =true;
}
//--------------------------------------------------------------------

void __fastcall TfEqpEdit::AfterPost(TDataSet* DataSet)
{

ShortDateFormat="dd/mm/yyyy";

if ((DataSet->State!=Db::dsInsert)||(DataSet->State==Db::dsEdit))
 {
/*
 TfChangeDate* fChangeDate;
 Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
 fChangeDate->Label1->Caption="Дата внесения изменений";

 if (UpdDate!=TDateTime(0))
    fChangeDate->edDt_change->Text = DateToStr(UpdDate);

  if (fChangeDate->ShowModal()!= mrOk)
  {
    delete fChangeDate;
    Abort(); // Отменить
    return;
  }

  try
  {
   UpdDate=StrToDate(fChangeDate->edDt_change->Text);
  }
  catch(...)
  {
   ShowMessage("Неверная дата");
   delete fChangeDate;
   Abort(); // Отменить
   return ;
  }
  delete fChangeDate;
*/
  UpdDate = dtAddParamDate->Date;

  ZEqpQuery->Close();

  sqlstr="select mnm_eqp_params_ed_fun(:eqp_id, :id_param, :val, :dat);";

  ZEqpQuery->Sql->Clear();
  ZEqpQuery->Sql->Add(sqlstr);
  ZEqpQuery->ParamByName("eqp_id")->AsInteger=eqp_id;
  ZEqpQuery->ParamByName("id_param")->AsInteger= WParamGrid->DBGrid->Query->FieldByName("id_param")->AsInteger;
  ZEqpQuery->ParamByName("val")->AsFloat= WParamGrid->DBGrid->Query->FieldByName("value")->AsFloat;
  ZEqpQuery->ParamByName("dat")->AsDateTime= UpdDate;

  try
  {
   ZEqpQuery->ExecSql();
  }
  catch(...)
  {
   ShowMessage("Ошибка записи истории");
   Abort();
  }
 }
}
//---------------------------------------------------------------------------
void __fastcall TfEqpEdit::ParamAccept (TObject* Sender)
{
  TWTQuery *QueryParHist;

  TWinControl *Owner = this;
  // Если такое окно есть - активизируем и выходим
  if (MainForm->ShowMDIChild("История изменения "+WParamGrid->DBGrid->Query->FieldByName("name")->AsString, Owner)) {
    return;
  }

  QueryParHist = new  TWTQuery(this);
  QueryParHist->Options << doQuickOpen;

  QueryParHist->Sql->Clear();
  QueryParHist->Sql->Add("select * from mnm_eqp_params_h where code_eqp = :code_eqp and id_param = :param order by dt_b;" );
  QueryParHist->ParamByName("code_eqp")->AsInteger = eqp_id;
  QueryParHist->ParamByName("param")->AsInteger = WParamGrid->DBGrid->Query->FieldByName("id_param")->AsInteger;

  WParamHistGrid = new TWTWinDBGrid(this, QueryParHist,false);
  WParamHistGrid->SetCaption("История изменения "+WParamGrid->DBGrid->Query->FieldByName("name")->AsString);

  TWTQuery* Query = WParamHistGrid->DBGrid->Query;

  Query->AfterInsert=CancelInsert;
//  Query->AfterDelete=CancelInsert;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();

  Query->SetSQLModify("mnm_eqp_params_h",WList,NList,true,false,false);

  TWTField *Field;

  Field = WParamHistGrid->AddColumn("dt_b", "Дата нач.", "Дата нач.");
  Field = WParamHistGrid->AddColumn("dt_e", "Дата кон.", "Дата кон.");

  Field = WParamHistGrid->AddColumn("value", "Значение", "Значение");
  Field->SetReadOnly();

  Field = WParamHistGrid->AddColumn("dt", "Дата внесения", "Дата внесения");
  Field->SetReadOnly();

//  WParamGrid->DBGrid->FieldSource = WParamGrid->DBGrid->Query->GetTField("id");

//  WParamGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
//  WParamGrid->DBGrid->OnAccept=ParamAccept;
  WParamHistGrid->DBGrid->Visible = true;

//  WParamGrid->DBGrid->ReadOnly=true;
  WParamHistGrid->ShowAs("История изменения "+WParamGrid->DBGrid->Query->FieldByName("name")->AsString);

}
//---------------------------------------------------------------------------


void __fastcall TfEqpEdit::grStationsDblClick(TObject *Sender)
{
 int id_st = 0;
 try{
  id_st = StrToInt(grStations->Cells[1][grStations->Row]);
 }
 catch(...){};

 if (id_st==0) return;

 TfEqpEdit *EqpEdit;
 Application->CreateForm(__classid(TfEqpEdit), &EqpEdit);
 EqpEdit->Align=alNone;

 EqpEdit->DragKind=dkDrag;
 EqpEdit->ParentDataSet=NULL;
 EqpEdit->ShowAs("TheEquip");

 EqpEdit->ShowData(id_st);
}
//---------------------------------------------------------------------------


