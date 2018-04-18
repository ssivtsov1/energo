//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"

#define WinName "Виды документов"

void _fastcall TMainForm::DciMDocBtn(TObject *Sender)
{
  DciMDocSpr(NULL);
}

void  _fastcall TMainForm::DciMDocSpr(TWTField *Sender) {

 DciMDocSel(Sender,NULL);

 }

TWTDBGrid *_fastcall TMainForm::DciMDocSel(TWTField *Sender,int id_sel)
{

  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return NULL ;
  }
  TWTDoc *DocK=new TWTDoc(this,"");
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  TWTDBGrid* DBGrKind=new TWTDBGrid(DocK, "dck_document_tbl");
  TWTPanel* PGrKind=DocK->MainPanel->InsertPanel(350,false,150);

  PGrKind->Params->AddText("Виды документов",10,F,Classes::taCenter,true)->ID="NKind";
  PGrKind->Params->AddGrid(DBGrKind,true)->ID="DocKind";
  DBGrKind->Table->Open();

  DBGrKind->Table->IndexFieldNames="name";
  TDataSource *DataSource=DBGrKind->DataSource;
  DBGrKind->OnExit=ExitParamsGrid;

  TWTTable* TableKind = DBGrKind->Table;
  TableKind->Open();
  TWTField *Field;
  Field = DBGrKind->AddColumn("Name", "Наименование", "Наименование");
  Field->SetRequired("Наименование  должно быть заполнено");

  Field = DBGrKind->AddColumn("ident", "Тип", "Тип");
  Field->AddFixedVariable("bill", "Счета ");
  Field->AddFixedVariable("pay","Платежи ");
  Field->AddFixedVariable("rep_dem","Отч.потр.");
  Field->AddFixedVariable("saldo", "Сальдо");
  Field->SetDefValue("pay");


  TWTDBGrid* DBGrDci=new TWTDBGrid(DocK, "dci_document_tbl");
  TWTPanel* PDci=DocK->MainPanel->InsertPanel(300,false,150);
  PDci->Params->AddText("Документы",10,F,Classes::taCenter,true)->ID="NameDci";
  PDci->Params->AddGrid(DBGrDci,true)->ID="DocDci";

  TWTTable* Table = DBGrDci->Table;

  //Table->AddLookupField("NAME_GRP", "ID_grp", "dci_group_tbl", "name","id");
  //Table->AddLookupField("NAME_KIND", "idk_document", "dck_document_tbl","name" ,"id");
  Table->Open();
  Table->IndexFieldNames = "id";
  Table->LinkFields = "id=idk_document";
  Table->MasterSource = DataSource;

  TWTField *Fieldd;

  Fieldd = DBGrDci->AddColumn("Name", "Наименование", "Наименование");
  Fieldd->SetRequired("Наименование  должно быть заполнено");
  Fieldd->SetWidth(200);
 // Field = WGrid->AddColumn("Name_grp", "Группа документов", "Группа документов");
 // Field->SetOnHelp(DciGroupSprG);

  Fieldd = DBGrDci->AddColumn("ident", "Тип", "Тип");
  Fieldd->AddFixedVariable("chn_cnt", "замена счетчика            ");
  Fieldd->AddFixedVariable("set_cnt", "установка счетчика         ");
  Fieldd->AddFixedVariable("act_start","акт осмотра,после отсутствия отчетов о потреблении ");
  Fieldd->AddFixedVariable("beg_ind", "ввод начальных показаний (начало работы с базой");
  Fieldd->AddFixedVariable("rep_pwr","отчет о потреблении         ");
  Fieldd->AddFixedVariable("kor_ind","корректирующие показания ");
  Fieldd->AddFixedVariable("act_chn", "акт осмотра (неисправность не по вине потребителя)");
  Fieldd->AddFixedVariable("act_pwr","акт осмотра оборудования, акт нарушения правил");
  Fieldd->AddFixedVariable("act_check","акт проверки оборудования без нарушений");
  Fieldd->AddFixedVariable("rep_avg","выставление по среднему потреблению");
  Fieldd->AddFixedVariable("saldo","сальдо");
  Fieldd->AddFixedVariable("kord_sal","корр.сальдо дебет");
  Fieldd->AddFixedVariable("pay","платежка");
  Fieldd->AddFixedVariable("aquit","квитанция");
  Fieldd->AddFixedVariable("avizo","авизо");
  Fieldd->AddFixedVariable("trush","зачет");
  Fieldd->AddFixedVariable("comp_categ","льгота");
  Fieldd->AddFixedVariable("kork_sal","корр.сальдо кредит");
  Fieldd->AddFixedVariable("subsid","субсидия");
  Fieldd->AddFixedVariable("bill","счет");
  Fieldd->AddFixedVariable("accord","договор");
  Fieldd->SetDefValue("                               ");
   DBGrDci->AfterPost=AftBefPostDci;
   DBGrDci->BeforePost=AftBefPostDci;

   DocK->ShowAs(WinName);
   DocK->SetCaption("Виды документов "); //не должно содержать "["
  // обязательно для загрузки отчета из файла. должно идти после SetCaption
  //DocAdr->ID="AdmAdrM";
  DocK->LoadFromFile(DocK->DocFile);
  DocK->Constructor=true;

  DBGrDci->FieldSource = DBGrDci->Table->GetTField("id");
  DBGrDci->FieldDest = Sender;

  DocK->MainPanel->ParamByID("DocDci")->Control->SetFocus();
  DocK->MainPanel->ParamByID("DocKind")->Control->SetFocus();
  return DBGrDci;

};

void _fastcall TMainForm::AftBefPostDci(TWTDBGrid *Sender)
{
 int id_k;
 id_k= Sender->DataSource->DataSet->FieldByName("idk_document")->AsInteger;
 Sender->DataSource->DataSet->FieldByName("id_grp")->AsInteger=id_k;
};


void _fastcall TMainForm::DciDocumentBtn(TObject *Sender)
 {
  DciDocumentSpr(NULL);
}


#define WinName "Виды документов"
void _fastcall TMainForm::DciDocumentSpr(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dci_document_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  Table->AddLookupField("NAME_GRP", "ID_grp", "dci_group_tbl", "name","id");
  Table->AddLookupField("NAME_KIND", "idk_document", "dck_document_tbl","name" ,"id");
  Table->Open();
  TWTField *Field;

  Field = WGrid->AddColumn("Name", "Наименование", "Наименование");
  Field->SetRequired("Наименование  должно быть заполнено");

  Field = WGrid->AddColumn("Name_grp", "Группа документов", "Группа документов");
  Field->SetOnHelp(DciGroupSprG);
  //Field->SetRequired("Группа  должна быть заполнена");
  //Field->SetWidth(150);

  Field = WGrid->AddColumn("NAME_KIND", "Типы групп", "Типы групп документов");
  Field->SetOnHelp(DckDocumentSpr);
  //Field->SetRequired("Тип  должен быть заполнен");
  //Field->SetWidth(150);

  Field = WGrid->AddColumn("ident", "Тип", "Тип");
  Field->AddFixedVariable("CHN_CNT", "замена счетчика            ");
  Field->AddFixedVariable("SET_CNT","установка счетчика           ");
  Field->AddFixedVariable("ACT_START","акт осмотра,после отсутствия отчетов о потреблении ");

  Field->AddFixedVariable("BEG_IND", "ввод начальных показаний (начало работы с базой");
  Field->AddFixedVariable("REP_PWR","отчет о потреблении         ");
  Field->AddFixedVariable("KOR_IND","корректирующие показания ");

  Field->AddFixedVariable("ACT_CHN", "акт осмотра (неисправность не по вине потребителя)");
  Field->AddFixedVariable("ACT_PWR","акт осмотра оборудования, акт нарушения правил");
  Field->AddFixedVariable("ACT_CHECK","акт проверки оборудования без нарушений");
  Field->AddFixedVariable("REP_AVG","выставление по среднему потреблению");


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DciDocument",1);

};

void _fastcall TMainForm::DckDocumentBtn(TObject *Sender)
 {
  DckDocumentSpr(NULL);
}
#define WinName "Типы групп документов"
void _fastcall TMainForm::DckDocumentSpr(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dck_document_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;


  Field = WGrid->AddColumn("Name", "Наименование", "Наименование");
  Field->SetRequired("Наименование  должно быть заполнено");

  Field = WGrid->AddColumn("ident", "Тип", "Тип");
  Field->AddFixedVariable("bill", "Счета ");
  Field->AddFixedVariable("pay","Платежи ");
  Field->AddFixedVariable("rep_dem","Отч.потр.");
  Field->SetDefValue("pay");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DckDocument",1);

};

#define WinName "Группы документов"
void _fastcall TMainForm::DciGroupSprT(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dci_group_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->AddLookupField("NAME_par", "ID_parent", "dci_group_tbl", "name","id");
  Table->SetFilter("level=0");
  Table->Filtered=true;
  Table->Open();

  TWTField *Field;


  Field = WGrid->AddColumn("Name", "Наименование", "Наименование");
  Field->SetRequired("Наименование  должно быть заполнено");

  Field = WGrid->AddColumn("Name_par", "Принадлежность", "Принадлежность");
  Field->SetOnHelp(DciGroupSprG);



  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DciGroup",1);

};
#undef WinName
#define WinName "Принадлежности групп документов"
void _fastcall TMainForm::DciGroupSprG(TWTField *Sender)
{
 TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "dci_group_tbl",false);
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->AddLookupField("NAME_par", "ID_parent", "dci_group_tbl", "name","id");
  Table->SetFilter("level>0");
  Table->Filtered=true;
  Table->Open();

  TWTField *Field;


  Field = WGrid->AddColumn("Name", "Наименование", "Наименование");
  Field->SetRequired("Наименование  должно быть заполнено");
                           /*
  Field = WGrid->AddColumn("Name_par", "Принадлежность", "Принадлежность");
  Field->SetOnHelp(DciGroupSprG);

                             */

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
 // WGrid->TForm::ShowModal();
  WGrid->ShowAs("DciGroup",1);

};
#undef WinName



