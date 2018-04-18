//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------
// функции класса TMainForm
//---------------------------------------------------------------------
#define WinName "Справочник адресов для выбора"
void _fastcall TMainForm::AdmAddressMBtn(TObject *Sender)
 {
  AdmAddressMSpr(NULL);
}

void _fastcall TMainForm::AdmAddressMSpr(TWTField *Sender) {
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTDoc *DocAdr=new TWTDoc(this,"Reports\\AdmAddr.dof");
     TButton *Btn=new TButton(this);
  Btn->Caption="Проба";
  Btn->OnClick=PR1;
   /*Panel->Width= Button->Width+1;
  Panel->Height= Button->Height+1;
     */
  TWTPanel* PBtn=DocAdr->MainPanel->InsertPanel(Btn->Width+1,false,Btn->Height+1);
  /* TButton *Btn=new TButton(PBtn);
  Btn->Caption="Проба";
  Btn->OnClick=PR1;   */
  //PBtn->Params->AddButton(PBtn,Btn,true);

   TButton *Btn1=new TButton(this);
  Btn1->Caption="Проба1";
  Btn1->OnClick=PR1;



  TWTDBGrid* DBGrDomain=new TWTDBGrid(DocAdr, CreateFullTableName("adi_domain_tbl"));
  TWTPanel* PDomain=DocAdr->MainPanel->InsertPanel(100,true,100);
  TFont* F=new TFont();
  F->Size=16;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PDomain->Params->AddText("Области",10,F,Classes::taCenter,true)->ID="NameDom";
  PDomain->Params->AddGrid(DBGrDomain,true)->ID="Domain";

  DBGrDomain->Table->Open();
  TDataSource *DataSource=DBGrDomain->DataSource;

  TWTField *Field;
  Field = DBGrDomain->AddColumn("NAME", "Область", "Наименование области");
  Field->SetRequired("Наименование  должно быть заполнено");

  TWTPanel* PRegion=DocAdr->MainPanel->InsertPanel(100,true,100);
  TWTDBGrid* DBGrRegion = new TWTDBGrid(DocAdr, CreateFullTableName("adi_region_tbl"));


  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PRegion->Params->AddText("Районы",18,F,Classes::taCenter,false);
  PRegion->Params->AddGrid(DBGrRegion, true)->ID="Region";


 DBGrRegion->Table->IndexFieldNames = "id";
 DBGrRegion->Table->LinkFields = "id=id_domain";
 DBGrRegion->Table->MasterSource = DataSource;



  DBGrRegion->Table->Open();

  TWTField *Fields;
  Fields = DBGrRegion->AddColumn("Name", "Наименование", "Наименование");

  /// Населенніе пункты
  TWTPanel* PTown=DocAdr->MainPanel->InsertPanel(100,true,100);
  TWTDBGrid* DBGrTown = new TWTDBGrid(DocAdr, CreateFullTableName("adi_town_tbl"));


  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PTown->Params->AddText("Населенные пункты",18,F,Classes::taCenter,false);
  PTown->Params->AddGrid(DBGrTown, true)->ID="Town";


 DBGrTown->Table->IndexFieldNames = "id";
 DBGrTown->Table->LinkFields = "id=id_region";
 DBGrTown->Table->MasterSource = DBGrRegion->DataSource;



  DBGrTown->Table->Open();

  TWTField *Fieldt;
  Fieldt = DBGrTown->AddColumn("Name", "Наименование", "Наименование");

    /// Собственно адреса
  TWTPanel* PAdr=DocAdr->MainPanel->InsertPanel(100,true,100);
     TWTQuery *QueryAdr;
     QueryAdr = new  TWTQuery(PAdr);
    QueryAdr->Sql->Clear();
    QueryAdr->Sql->Add("select adi_domain_tbl.id as id_domain,adi_region_tbl.id as id_region," );
    QueryAdr->Sql->Add("adi_town_tbl.id as id_town,adm_address_tbl.id_street,adm_address_tbl.building,");
    QueryAdr->Sql->Add("adm_address_tbl.idk_building,adm_address_tbl.building_add,adm_address_tbl.post_index,");
    QueryAdr->Sql->Add("adm_address_tbl.idk_office,adm_address_tbl.office,adm_address_tbl.id  ");
    QueryAdr->Sql->Add("  from "+ FullTableName("adi_domain_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_region_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_town_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adi_street_tbl"));
    QueryAdr->Sql->Add(", "+FullTableName("adm_address_tbl"));
    QueryAdr->Sql->Add(" where adm_address_tbl.id_street=adi_street_tbl.id and ");
    QueryAdr->Sql->Add(" adi_street_tbl.id_town=adi_town_tbl.id and adi_town_tbl.id_region=adi_region_tbl.id ");
    QueryAdr->Sql->Add( " and  adi_region_tbl.id_domain=adi_domain_tbl.id");

  TWTDBGrid* DBGrAdr = new TWTDBGrid(DocAdr, QueryAdr);

  F=new TFont();
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PAdr->Params->AddText("Адреса",18,F,Classes::taCenter,false);
  PAdr->Params->AddGrid(DBGrAdr, true)->ID="Adr";


  DBGrAdr->FieldSource = DBGrAdr->Query->GetTField("id");
  DBGrAdr->FieldDest = Sender;

  DBGrAdr->Query->IndexFieldNames = "id";
  DBGrAdr->Query->LinkFields = "id=id_town";
  DBGrAdr->Query->MasterSource = DBGrTown->DataSource;

  DBGrAdr->Query->AddLookupField("NAME_STREET", "ID_STREET", CreateFullTableName("adi_street_tbl"), "NAME","id", "id_town="+DBGrTown->Table->FieldByName("id")->AsString);
  DBGrAdr->Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");
  TStringList *NList=new TStringList();
  //NList->Add("NAME_STREET");
  NList->Add("id_domain");
  NList->Add("id_region");
  NList->Add("id_town");

  DBGrAdr->Query->SetSQLModify("adm_address_tbl",WList,NList,true,true,true);

  TWTField *Fieldq;
  Fieldq =  DBGrAdr->AddColumn("NAME_STREET", "Улица", "Улица");
  Fieldq->FieldLookUpFilter="id_town";
  Fieldq->ExpFieldLookUpFilter=(TWTField*)DBGrTown->Table->FieldByName("id");
  Fieldq->SetOnHelp(AdiStreetSpr);

  Fieldq->SetRequired("Улица должна быть заполнена");
  Fieldq =  DBGrAdr->AddColumn("BUILDING", "Дом", "Дом");
  Fieldq =  DBGrAdr->AddColumn("BUILDING_ADD", "Корпус", "Корпус");
  Fieldq = DBGrAdr->AddColumn("Office", "Офис", "Офис");


   DocAdr->MainPanel->SetVResize(100);


    //TSplitter* Spp=PP->SetVResize(50);

   DocAdr->ShowAs("Test1");
   DocAdr->SetCaption("Справочник адресов Для выбора"); //не должно содержать "["
  // обязательно для загрузки отчета из файла. должно идти после SetCaption
  //DocAdr->ID="AdmAdrM";
  DocAdr->LoadFromFile(DocAdr->DocFile);
  DocAdr->Constructor=true;
  DocAdr->MainPanel->ParamByID("Region")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Town")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Adr")->Control->SetFocus();
  DocAdr->MainPanel->ParamByID("Domain")->Control->SetFocus();

};


void __fastcall TMainForm::PR1(TObject *Sender)
{
  ShowMessage("QQQ");
};
#undef WinName


