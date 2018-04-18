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
        case 2:  //��������������
               Grid=MainForm->EqiCompSpr("�������������������");
               break;
        case 5:  //��������������
               Grid=MainForm->EqiFuseSpr("�������������������");
               break;
        case 10: //�������������� �������������
               Grid=MainForm->EqiCompISpr("������������������������");
               break;
        case 3: //�������������
               Grid=MainForm->EqiSwitchSpr("������������������");
               break;
        case 4: //������������
               Grid=MainForm->EqiJackSpr("�����������������");
               break;
        case 6: //��������� �����
               Grid=MainForm->EqiCableSpr("�����������");
               break;
        case 16: //���
               Grid=MainForm->EqiDESSpr("����� ���");
               break;

        default:
         {
          ShowMessage("������ ��� ������������ �� ��������������!");
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
// ��������� �����

 switch (eqp_type){
        case 2:  //��������������
        case 5:  //��������������
//        case 10: //�������������� ����
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
        case 10: //�������������� ����
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddData->Caption="���� �������";
               AddDataName="date_check";
               AddDataType=3;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 3: //�������������
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddData->Caption="����������� ���, �";
               AddDataName="amperage_nom";
               AddDataType=2;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 4: //������������
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddData->Caption="����������";
               AddDataName="quantity";
               AddDataType=2;

               lVoltage->Visible=false;
               edClassId->Visible=false;
               lClassVal->Visible=false;
               lVEeq->Visible=false;
               sbClassSel->Visible=false;

               break;
        case 6: //��������� �����
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddReq->Visible=true;
               lVoltage->Visible=true;
               edClassId->Visible=true;
               lClassVal->Visible=true;
               lVEeq->Visible=true;
               sbClassSel->Visible=true;

               lAddData->Caption="�������������, �";
               AddDataName="length";
               AddDataType=2;
               break;
        case 16: //���
               edAddData->Visible=true;
               lAddData->Visible=true;
               lAddReq->Visible=true;
               lAddData->Caption="��������, ���";
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
          ShowMessage("������ ��� ������������ �� ��������������!");
          return;
         } ;
 };

 if (AddDataType==3)
 {
    edAddData->EditMask = "!99/99/0000;1;_";
    edAddData->Text = "  .  .    ";
 };


 switch (eqp_type){
        case 2:  //��������������
               edit_enable = CheckLevel("����� 2 - ��������� ��������������")!=0 ;
               break;
        case 5:  //��������������
               edit_enable = CheckLevel("����� 2 - ��������� ��������������")!=0 ;
               break;
        case 10: //�������������� ����
               edit_enable = CheckLevel("����� 2 - ��������� �������������� ����")!=0 ;
               break;
        case 3: //�������������
               edit_enable = CheckLevel("����� 2 - ��������� �������������")!=0 ;
               break;
        case 4: //������������
               edit_enable = CheckLevel("����� 2 - ��������� ������������")!=0 ;
               break;
        case 6: //��������� �����
               edit_enable = CheckLevel("����� 2 - ��������� �����")!=0 ;
               break;
        case 16: //���
               edit_enable = CheckLevel("����� 2 - ��������� ���")!=0 ;
               break;

 };

   // �������� ����� ������
   GetTableNames(Sender);
   // ������� �� ���������� ������� ������

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
    ShowMessage("������ SQL :"+sqlstr);
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
        lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" ��";
       }
       else
       {
        lClassVal->Caption=ZEqpQuery->FieldByName("voltage_min")->AsString+" - "+
        ZEqpQuery->FieldByName("voltage_max")->AsString +" ��";
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
    ShowMessage("������ ��� ������� ��������� ����� ������������.");
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
    ShowMessage("������ : "+e.Message.SubString(8,200));
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
     ShowMessage("�� ������� "+lAddData->Caption);
     return false;
   }

  if (TypeId==0)
   {
     ShowMessage("�� ������ ���.");
     return false;
   }

  if(edClassId->Visible)
  {
   if (edClassId->Text=="")
    {
      ShowMessage("�� ������ ������� ����������");
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
#define WinName "������ ����������"
void _fastcall TfSimpleEqpDet::ShowVoltage(AnsiString retvalue) {

  // ���������� ���������
  TWTQuery *QueryAdr;

  TWinControl *Owner = this;
  // ���� ����� ���� ���� - ������������ � �������
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

  Field = WVoltageGrid->AddColumn("id", "�����", "����� ����������");
  Field = WVoltageGrid->AddColumn("voltage_min", "U min", "����������� ����������");
  Field = WVoltageGrid->AddColumn("voltage_max", "U max", "������������ ����������");

  WVoltageGrid->DBGrid->FieldSource = WVoltageGrid->DBGrid->Query->GetTField("id");

  WVoltageGrid->DBGrid->StringDest = retvalue!="0"?retvalue:AnsiString("-1");
  WVoltageGrid->DBGrid->OnAccept=VoltageAccept;
  WVoltageGrid->DBGrid->Visible = true;
 // WVoltageGrid->DBGrid->ReadOnly=true;
  WVoltageGrid->ShowAs("�����������");
};
#undef WinName
//---------------------------------------------------------------------------
void __fastcall TfSimpleEqpDet::VoltageAccept (TObject* Sender)
{
//   ShowMessage("������� :"+MeterGrid->DBGrid->StringDest);
   edClassId->Text=StrToInt(WVoltageGrid->DBGrid->StringDest);

   if (WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsInteger==WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsInteger)
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" ��";
   }
   else
   {
    lClassVal->Caption=WVoltageGrid->DBGrid->Query->FieldByName("voltage_min")->AsString+" - "+
    WVoltageGrid->DBGrid->Query->FieldByName("voltage_max")->AsString +" ��";
   }
   IsModified=true;
}

