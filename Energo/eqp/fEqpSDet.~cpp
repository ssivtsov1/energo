//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fEqpSDet.h"
#include "fEqpBase.h"
#include "ftree.h"
#include "Main.h"
#include "SysUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
//TfSimpleEqpDet *fSimpleEqpDet;
AnsiString AddDataName;
AnsiString retvalue;
TWTWinDBGrid *WGrid;
TWTWinDBGrid *WVoltageGrid;
//=============================================================
void _fastcall TfSimpleEqpDet::ShowDict(AnsiString retvalue) {

  TWTWinDBGrid* Grid;

  switch (eqp_type){
        case 2:  //Трансформаторы
               Grid=MainForm->EqiCompSpr("ВыборТрансформаторы");
               break;
        case 5:  //Предохранители
               Grid=MainForm->EqiFuseSpr("ВыборПредохранителя");
               break;
        case 10: //Трансформаторы измерительные
               Grid=MainForm->EqiCompISpr("ВыборТрансформаторыИзмер");
               break;
        case 3: //Переключатели
               Grid=MainForm->EqiSwitchSpr("ВыборПереключателя");
               break;
        case 4: //Компенсаторы
               Grid=MainForm->EqiJackSpr("ВыборКомпенсатора");
               break;
        case 6: //Кабельная линия
               Grid=MainForm->EqiCableSpr("ВыборКабеля");
               break;
        case 16: //ДЭС
               Grid=MainForm->EqiDESSpr("Выбор ДЭС");
               break;

        default:
         {
          ShowMessage("Данный тип оборудования не поддерживается!");
          return;
         };
  };
  if(Grid==NULL) return;
  else WGrid=Grid;

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Query->GetTField("id");
  WGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WGrid->DBGrid->OnAccept=Accept;

};


//---------------------------------------------------------------------------
__fastcall TfSimpleEqpDet::TfSimpleEqpDet(TComponent* Owner)
        : TfEqpDet(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfSimpleEqpDet::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TfSimpleEqpDet::FormShow(TObject *Sender)
{
// Настройка формы

 switch (eqp_type){
        case 2:  //Трансформаторы
        case 5:  //Предохранители
//        case 10: //Трансформаторы тока
               edAddData->Visible=false;
               lAddData->Visible=false;
               AddDataName="";
               AddDataType=0;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 10: //Трансформаторы тока
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddData->Caption="Дата поверки";
               AddDataName="date_check";
               AddDataType=3;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 3: //Переключатели
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddData->Caption="Номинальный ток, А";
               AddDataName="amperage_nom";
               AddDataType=2;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 4: //Компенсаторы
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddData->Caption="Количество";
               AddDataName="quantity";
               AddDataType=2;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 6: //Кабельная линия
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddReq->Visible=true;
               lVoltage->Visible=true;
               edClassId->Visible=true;
               lClassVal->Visible=true;
               lVEeq->Visible=true;
               sbClassSel->Visible=true;

               lAddData->Caption="Протяженность, м";
               AddDataName="length";
               AddDataType=2;
               break;
        case 16: //ДЕС
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddReq->Visible=true;
               lAddData->Caption="Мощность, кВт";
               AddDataName="power";
               AddDataType=2;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;

        default:
         {
          ShowMessage("Данный тип оборудования не поддерживается!");
          return;
         } ;
 };

 if (AddDataType==3)
 {
    edAddData->EditMask = "!99/99/0000;1;_";
    edAddData->Text = "  .  .    ";
 };


 switch (eqp_type){
        case 2:  //Трансформаторы
               edit_enable = CheckLevel("Схема 2 - Параметры трансформатора")!=0 ;
               break;
        case 5:  //Предохранители
               edit_enable = CheckLevel("Схема 2 - Параметры предохранителя")!=0 ;
               break;
        case 10: //Трансформаторы тока
               edit_enable = CheckLevel("Схема 2 - Параметры трансформатора тока")!=0 ;
               break;
        case 3: //Переключатели
               edit_enable = CheckLevel("Схема 2 - Параметры переключателя")!=0 ;
               break;
        case 4: //Компенсаторы
               edit_enable = CheckLevel("Схема 2 - Параметры компенсатора")!=0 ;
               break;
        case 6: //Кабельная линия
               edit_enable = CheckLevel("Схема 2 - Параметры линий")!=0 ;
               break;
        case 16: //ДЕС
               edit_enable = CheckLevel("Схема 2 - Параметры ДЕС")!=0 ;
               break;

 };

   // Получить имена таблиц
   GetTableNames(Sender);
   // Выбрать из полученной таблици данные

   if (mode==0) return;
   else
   {
     edTypeName->ReadOnly =!edit_enable;
     edAddData->ReadOnly =!edit_enable;
     edClassId->ReadOnly =!edit_enable;
     bEqpTypeSel->Enabled =edit_enable;
     sbClassSel->Enabled =edit_enable;
   }


   sqlstr=" select dt.id_type_eqp, it.type %addfield %voltagefield from %name_table AS dt JOIN %name_table_id AS it ON(dt.id_type_eqp=it.id) ";

   if(edClassId->Visible)
    sqlstr=sqlstr+"left join  eqk_voltage_tbl AS v on (dt.id_voltage=v.id) ";
   sqlstr=sqlstr+" where (dt.code_eqp= :code_eqp);";

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add(sqlstr);
//   ZEqpQuery->ParamByName("code_eqp")->AsInteger=fTreeForm->EqpEdit->eqp_id;
   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;
   ZEqpQuery->MacroByName("name_table_id")->AsString=name_table_ind;

   if (AddDataName!="")
        ZEqpQuery->MacroByName("addfield")->AsString=",dt."+AddDataName;
   else
        ZEqpQuery->MacroByName("addfield")->AsString="";

   if(edClassId->Visible)
       ZEqpQuery->MacroByName("voltagefield")->AsString=",dt.id_voltage,v.voltage_min, v.voltage_max ";
   else
        ZEqpQuery->MacroByName("voltagefield")->AsString="";

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
     edTypeName->Text=ZEqpQuery->FieldByName("type")->AsString;
     TypeId=ZEqpQuery->FieldByName("id_type_eqp")->AsInteger;

     if (edAddData->Visible==true)
     {
       if(AddDataType==3)
       {
         if (!ZEqpQuery->FieldByName(AddDataName)->IsNull)
           edAddData->Text=FormatDateTime("dd.mm.yyyy",ZEqpQuery->FieldByName(AddDataName)->AsDateTime);
         else
          edAddData->Text="  .  .    ";
       }
       else
         edAddData->Text=ZEqpQuery->FieldByName(AddDataName)->AsString;
     }

     if(edClassId->Visible)
     {
       edClassId->Text=ZEqpQuery->FieldByName("id_voltage")->AsString;
       if (ZEqpQuery->FieldByName("voltage_min")->AsInteger==ZEqpQuery->FieldByName("voltage_max")->AsInteger)
       {
        lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" кВ";
       }
       else
       {
        lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" - "+
        ZEqpQuery->FieldByName("voltage_max")->AsString +" кВ";
       }
     }

   };
   IsModified=false;
   ZEqpQuery->Close();

}
//---------------------------------------------------------------------------


void __fastcall TfSimpleEqpDet::bEqpTypeSelClick(TObject *Sender)
{
if (fReadOnly) return;
ShowDict(TypeId);
}
//---------------------------------------------------------------------------

void __fastcall TfSimpleEqpDet::Accept (TObject* Sender)
{
   TypeId=StrToInt(WGrid->DBGrid->StringDest);
   edTypeName->Text=WGrid->DBGrid->Query->FieldByName("type")->AsString;
   IsModified=true;
}
//---------------------------------------------------------------------------
 bool TfSimpleEqpDet::SaveNewData(int id)
 {
   eqp_id=id;

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("insert into  %name_table (code_eqp,id_type_eqp ");
   if (AddDataName!="")
     ZEqpQuery->Sql->Add(","+AddDataName);
   if(edClassId->Visible)
     ZEqpQuery->Sql->Add(",id_voltage ");
   ZEqpQuery->Sql->Add(")");

   ZEqpQuery->Sql->Add("values ( :code_eqp, :id_type_eqp ");

   if (AddDataName!="")
     ZEqpQuery->Sql->Add(", :adddata ");
   if(edClassId->Visible)
     ZEqpQuery->Sql->Add(", :id_voltage ");
   ZEqpQuery->Sql->Add(");");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_type_eqp")->AsInteger=TypeId;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

   if ((AddDataName!="")&&(edAddData->Text!=""))
   {
     if(AddDataType==3)
     {
        if (edAddData->Text!="  .  .    ")
          ZEqpQuery->ParamByName("adddata")->AsDateTime=StrToDate(edAddData->Text);
        else
          ZEqpQuery->ParamByName("adddata")->Clear();

     }
     else
        ZEqpQuery->ParamByName("adddata")->AsString=edAddData->Text;
   }

   if(edClassId->Visible)
   {
    if (edClassId->Text!="")
     ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);
   }

   try
   {
    ZEqpQuery->ExecSql();
   }
   catch(...)
   {
    ShowMessage("Ошибка при попытке сохранить новое облрудование.");
    ZEqpQuery->Close();
    return false;
   }
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
 bool TfSimpleEqpDet::SaveData(void)
 {

   ZEqpQuery->Sql->Clear();
   ZEqpQuery->Sql->Add("update %name_table set id_type_eqp = :id_type_eqp ");
   if (AddDataName!="")
     ZEqpQuery->Sql->Add(","+AddDataName+" = :adddata ");
   if(edClassId->Visible)
     ZEqpQuery->Sql->Add(", id_voltage = :id_voltage ");

   ZEqpQuery->Sql->Add("where  code_eqp= :code_eqp");

   ZEqpQuery->ParamByName("code_eqp")->AsInteger=eqp_id;
   ZEqpQuery->ParamByName("id_type_eqp")->AsInteger=TypeId;
   ZEqpQuery->MacroByName("name_table")->AsString=name_table;

//   if ((AddDataName!="")&&(edAddData->Text!=""))
//     ZEqpQuery->ParamByName("adddata")->AsString=edAddData->Text;

   if ((AddDataName!="")&&(edAddData->Text!=""))
   {
     if(AddDataType==3)
     {
        if (edAddData->Text!="  .  .    ")
          ZEqpQuery->ParamByName("adddata")->AsDateTime=StrToDate(edAddData->Text);
        else
          ZEqpQuery->ParamByName("adddata")->Clear();

     }
     else
        ZEqpQuery->ParamByName("adddata")->AsString=edAddData->Text;
   }


   if(edClassId->Visible)
   {
    if (edClassId->Text!="")
     ZEqpQuery->ParamByName("id_voltage")->AsInteger=StrToInt(edClassId->Text);
   }

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
  IsModified=false;
  return true;
 }
//---------------------------------------------------------------------------
bool TfSimpleEqpDet::CheckData(void)
{
  if (lAddData->Visible && lAddReq->Visible &&(edAddData->Text==""))
   {
     ShowMessage("Не указано "+lAddData->Caption);
     return false;
   }

  if (TypeId==0)
   {
     ShowMessage("Не указан тип.");
     return false;
   }

  if(edClassId->Visible)
  {
   if (edClassId->Text=="")
    {
      ShowMessage("Не указан уровень напряжения");
      return false;
    }
  }

  return true;
}
//---------------------------------------------------------------------------

void __fastcall TfSimpleEqpDet::edDataChange(TObject *Sender)
{
  if (((TCustomEdit*)Sender)->Modified) IsModified=true;
}
//---------------------------------------------------------------------------

void __fastcall TfSimpleEqpDet::sbClassSelClick(TObject *Sender)
{
 if (fReadOnly) return;
 if (edClassId->Text=="")
  ShowVoltage("0");
 else
  ShowVoltage(edClassId->Text);
}
//---------------------------------------------------------------------------
#define WinName "Классы напряжения"
void _fastcall TfSimpleEqpDet::ShowVoltage(AnsiString retvalue) {

  // Определяем владельца
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // Если такое окно есть - активизируем и выходим
  if (MainForm->ShowMDIChild(WinName, Owner)) {
    return;
  }

  QueryAdr = new  TWTQuery(this);
  QueryAdr->Options << doQuickOpen;

  QueryAdr->Sql->Clear();
  QueryAdr->Sql->Add("select id,voltage_min ,voltage_max from eqk_voltage_tbl;" );

  WVoltageGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WVoltageGrid->SetCaption(WinName);

  TWTQuery* Query = WVoltageGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
//  NList->Add("id");

  Query->SetSQLModify("eqk_voltage_tbl",WList,NList,true,true,true);
  TWTField *Field;

  Field = WVoltageGrid->AddColumn("id", "Класс", "Класс напражения");
  Field = WVoltageGrid->AddColumn("voltage_min", "U min", "Минимальное напряжение");
  Field = WVoltageGrid->AddColumn("voltage_max", "U max", "Максимальное напряжение");

  WVoltageGrid->DBGrid->FieldSource = WVoltageGrid->DBGrid->Query->GetTField("id");

  WVoltageGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WVoltageGrid->DBGrid->OnAccept=VoltageAccept;
  WVoltageGrid->DBGrid->Visible = true;
 // WVoltageGrid->DBGrid->ReadOnly=true;
  WVoltageGrid->ShowAs("ВыборКласса");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfSimpleEqpDet::VoltageAccept (TObject* Sender)
{
//   ShowMessage("Выбрано :"+MeterGrid->DBGrid->StringDest);
   edClassId->Text=StrToInt(WVoltageGrid->DBGrid->StringDest);

   if (WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsInteger==WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsInteger)
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" кВ";
   }
   else
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" - "+
    WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsString +" кВ";
   }
   IsModified=true;
}

