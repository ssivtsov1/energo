//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------

 // ------------------------------------------------------------------------------
#define WinName "���������� ������������ "
void _fastcall TMainForm::SysRelatBtn(TObject *Sender)
 {
  SysRelat(NULL);
}

void _fastcall TMainForm::SysRelat(TWTField *Sender)
{
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  save_pos=0;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return ;
  }

  TWTQuery *QuerRel;
  QuerRel = new  TWTQuery(this);
  QuerRel->Options << doQuickOpen;

  QuerRel->Sql->Clear();
  QuerRel->Sql->Add("select distinct grp " );
  QuerRel->Sql->Add("from sys_relat_tbl ;");
  QuerRel->Open();
//  WCompGrid = new TWTWinDBGrid(this, QueryAdr,false);
  TWTWinDBGrid *WRelGrid = new TWTWinDBGrid(this, QuerRel,false);

//  TWTWinDBGrid *WRelGrid = new TWTWinDBGrid(this, QuerRel,false,true);
  WRelGrid->SetCaption(WinName);

  TStringList *WList=new TStringList();
  WList->Add("grp");
  //WList->Add("kod");
  TStringList *NList=new TStringList();
  NList->Add("grp");
  //NList->Add("kod");

  WRelGrid->DBGrid->Query->SetSQLModify("sys_relat_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WRelGrid->AddColumn("grp", "����������", "����������");
  Field->AddFixedVariable("metu",  "�������� �� �����������");
  Field->AddFixedVariable("taru",  "������ �� �����������  ");
  Field->AddFixedVariable("met",  "�������� �� ���������� ");
  Field->AddFixedVariable("tar",  "������ �� ����������  ");

  Field->AddFixedVariable("lgot", " ������                 ");
  Field->AddFixedVariable("town",  "������                 ");
  Field->AddFixedVariable("street","�����                  ");
  Field->AddFixedVariable("kur",   "�������                ");
  Field->AddFixedVariable("grptark","�� ������� ��� ������.");
  Field->AddFixedVariable("tarifk","������ ��� ���������� ");
  Field->AddFixedVariable("line","����� ��� �������� ����������");
  Field->AddFixedVariable("ktp","��� ��� �������� ����������");
  Field->SetReadOnly();
   WRelGrid->DBGrid->ToolBar->AddButton("RunScript", "��������� ������������� ������", RunSkriptRel);

  WRelGrid->DBGrid->OnAccept=RelAcsept;
  //WRelGrid->DBGrid->ReadOnly=true;
  WRelGrid->DBGrid->Visible = true;
  WRelGrid->DBGrid->Options>>dgEditing;

  WRelGrid->ShowAs(WinName);
//  WCompGrid->OnCloseQuery=CompGridClose;
  //return WCompGrid;
};
#define WinName "���������� ������������ 1"
void _fastcall TMainForm::RelAcsept(TObject *Sender)
{

  AnsiString strgrp;
  strgrp=((TWTDBGrid *)Sender)->DataSource->DataSet->FieldByName("grp")->AsString;
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)((TWTDBGrid *)Sender)->DataSource->DataSet->Owner)->Parent;

//  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)((TWTDBGrid *)Sender->Field->DataSet->Owner))->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "sys_relat_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Filter="grp='"+strgrp+"'";
  Table->Filtered=true;
  AnsiString tabl,retnam,retfield;
  retnam="name";
  retfield="id";
  if (strgrp=="metu")
  {   tabl="eqi_meter_tbl";
     retnam="type"; };

  if (strgrp=="taru")
  {   tabl="aci_tarif_tbl";
   };
    if (strgrp=="met")
  {   tabl="eqi_meter_tbl";
      retnam="type"; };
  if (strgrp=="tar")
  {   tabl="aci_tarif_tbl";
   };

  if (strgrp=="town")
  {   tabl="adi_town_tbl";
   };
  if (strgrp=="street")
  {  tabl="adi_street_tbl";

   };
   if (strgrp=="lgot")
  {  tabl="cla_kateg_tbl";

   };
   if (strgrp=="grptark")
  {   tabl="eqi_grouptarif_tbl";
   };
   if (strgrp=="tarifk")
  {   tabl="aci_tarif_tbl";

   };

  if (strgrp=="ktp")
  {   tabl="rel_ktp_v";
      retnam="name";
      retfield="code_eqp";
       };
 if (strgrp=="line")
  {   tabl="rel_line_v";
      retnam="name";
      retfield="code_eqp";
       };


  if (!(tabl.IsEmpty()))
     if (strgrp=="street")
  {  TWTQuery *QuerStreet= new TWTQuery(this);
     QuerStreet->Close();
     QuerStreet->Sql->Clear();
     QuerStreet->Sql->Add("select s.id,s.name||' ('||t.name||')' as name");
     QuerStreet->Sql->Add(" from adi_street_tbl s ,adi_town_tbl t ");
     QuerStreet->Sql->Add(" where s.id_town=t.id");
     QuerStreet->Open();
     WGrid->DBGrid->Table->AddLookupField("nm", "ID", QuerStreet,retnam ,retfield);
   }
   else
   {
      WGrid->DBGrid->Table->AddLookupField("nm", "ID", tabl,retnam ,retfield);
   }
  else
  {   ShowMessage("�� ��������� ��� �������-�����������!");
      return;
  };
  Table->Open();

  TWTField *Field;
  Field = WGrid->AddColumn("kod", "��� ���", "��� ���");
  Field->SetWidth(60) ;
  Field = WGrid->AddColumn("our_kod", "��� ���������", "��� ���������");
  Field->SetWidth(60) ;
  Field = WGrid->AddColumn("name", "������������ ���", "������������ ���");
  Field->SetWidth(200) ;
  Field = WGrid->AddColumn("id", "��� Energo", "��� Energo");
  Field->SetWidth(60) ;
   if (strgrp=="metu")
  {     Field->SetOnHelp(EqiTMeterSpr);
   };
  if (strgrp=="met")
  {     Field->SetOnHelp(EqiTMeterSpr);
   };
  if (strgrp=="town")
  {     Field->SetOnHelp(AdiTownSpr);
   };
  if (strgrp=="street")
  {     Field->SetOnHelp(AdiStreetSpr);
   };
  if (strgrp=="taru")
  {     Field->SetOnHelp(AciTarifSpr);
   };
  if (strgrp=="tar")
  {     Field->SetOnHelp(AciTarifSpr);
   };
  if (strgrp=="lgot")
  {     Field->SetOnHelp(CmiKategSpr);
   };

   if (strgrp=="grptark")
  {   Field->SetOnHelp(EqiGroupTarifSpr);
   };
   if (strgrp=="tarifk")
  {   Field->SetOnHelp(AciTarifSpr);
   };
  if (strgrp=="ktp")
  {     Field->SetOnHelp(RelKtpSpr);
  };

  if (strgrp=="line")
  {     Field->SetOnHelp(RelLineSpr);
  };

    Field = WGrid->AddColumn("nm", "������������ Energo", "������������ Energo");
  Field->SetWidth(200);
   if (strgrp=="metu")
  {     Field->SetOnHelp(EqiTMeterSpr);
   };
  if (strgrp=="town")
  {     Field->SetOnHelp(AdiTownSpr);
   };
  if (strgrp=="street")
  {     Field->SetOnHelp(AdiStreetSpr);
     Field = WGrid->AddColumn("add_name", "���.�����", "���������� �����");
     Field->SetWidth(200);
   };

    if (strgrp=="line")
  {     Field->SetOnHelp(AdiStreetSpr);
     Field = WGrid->AddColumn("add_name", "���", "���");
     Field->SetWidth(200);
   };
  if (strgrp=="taru")
  {     Field->SetOnHelp(AciTarifSpr);
   };
    if (strgrp=="grptark")
  {   Field->SetOnHelp(EqiGroupTarifSpr);
   };
   if (strgrp=="tarifk")
  {   Field->SetOnHelp(AciTarifSpr);
   };
  if (strgrp=="lgot")
  {     Field->SetOnHelp(CmiKategSpr);
   };
  if (strgrp=="ktp")
  {     Field->SetOnHelp(RelKtpSpr);
  };

  if (strgrp=="line")
  {     Field->SetOnHelp(RelLineSpr);
  };

  
  Field = WGrid->AddColumn("Checks", "���������", "");
  Field->AddFixedVariable("1", "��������");
  Field->AddFixedVariable("2","�� ��������");
  Field->AddFixedVariable("3","��������");
  Field->SetDefValue("2");


  WGrid->DBGrid->Table->BeforePost=NonJumpSave;
  WGrid->DBGrid->Table->AfterPost=NonJump;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
};

// ��������� ������
void _fastcall TMainForm::RunSkriptRel(TObject *Sender)
{ AnsiString func;
    TWTWinDBGrid *TGr;

 if (CheckParent(Sender,"TToolButton"))
 { TGr=((TWTWinDBGrid *)(((TWinControl *)Sender)->Parent->Parent->Parent));
   func=TGr->DBGrid->DataSource->DataSet->FieldByName("grp")->AsString;
   TWTQuery *QueryFun=new TWTQuery(this);
   QueryFun->Sql->Clear();
   QueryFun->Sql->Add("select sys_relat_fun("+ToStrSQL(func)+")");
   QueryFun->ExecSql();
 };

};
# define WinName "���������� ��������������� �� ��� "
void _fastcall TMainForm::RelKtpSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  "rel_ktp_v",false);
  WGrid->SetCaption(WinName);
  AnsiString Proba;


  TWTTable* Table = WGrid->DBGrid->Table;
  if (Sender!=NULL)
   {
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);
       WGrid->DBGrid->AfterInsert=InsStreet;
       Table->Filtered=true;
      };
    };
  Table->Open();

  TWTField *Field;
  Field = WGrid->AddColumn("code_eqp", "��� ������", "��� ������������");

  Field = WGrid->AddColumn("Name_eqp", "������������", "������������");
  Field->SetWidth(200);

  Field = WGrid->AddColumn("NAME_CLIENT", "��������������", "��������������");
  Field->SetWidth(200);



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("code_eqp");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);

};
#undef WinName

# define WinName "���������� ����� �� ��� "
void _fastcall TMainForm::RelLineSpr(TWTField *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  "rel_line_v",false);
  WGrid->SetCaption(WinName);
  AnsiString Proba;


  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  if (Sender!=NULL)
   {
   if (Sender->ExpFieldLookUpFilter!=NULL )
      { Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       Table->SetFilter(Sender->FieldLookUpFilter+"="+Proba);
       WGrid->DBGrid->AfterInsert=InsStreet;
       Table->Filtered=true;
      };
    };

  Table->Open();
  TWTField *Field;
  Field = WGrid->AddColumn("code_eqp", "��� ������", "��� ������������");


  Field = WGrid->AddColumn("Name_eqp", "������������", "������������");
  Field->SetWidth(200);

  Field = WGrid->AddColumn("NAME_CLIENT", "��������������", "��������������");
  Field->SetWidth(200);




  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  /*DBGrid->FormStyle = fsMDIChild;*/
   WGrid->ShowAs(WinName);

};
#undef WinName


void __fastcall TMainForm::NonJumpSave(TDataSet* DataSet)
{  this->save_pos=DataSet->FieldByName("id_d")->AsInteger;
  int ii=this->save_pos;
};

void __fastcall TMainForm::NonJump(TDataSet* DataSet)
{ int ii=this->save_pos;
 DataSet->First();
 TLocateOptions SearchOptions;
  SearchOptions.Clear();
   DataSet->Locate("id_d",ii,SearchOptions);

};

