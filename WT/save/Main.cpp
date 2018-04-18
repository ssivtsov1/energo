//---------------------------------------------------------------------
// Приложение пользователя
//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
#include "Message.h"
#include "Query.h"
#include "DBGrid.h"
#include "SprGrid.h"
#include "Func.h"
#include "Form.h"
#include <math.h>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Db.hpp>
#include <DBTables.hpp>
#include <ExtCtrls.hpp>
#include <Qrctrls.hpp>
#include <Quickrpt.hpp>
#include <quickrpt.hpp>
//---------------------------------------------------------------------
// функции класса TMainForm (разработчик)
//---------------------------------------------------------------------

bool __fastcall TMainForm::OnParameters(TWTMDIWindow *Sender,TStringList *CaptionsList,bool *CheckedList){
  AnsiString A="";
  for (int x=0;x<CaptionsList->Count;x++)
     if (CheckedList[x]) A+=CaptionsList->Strings[x]+" ; ";
  ShowMessage(A);
  return 0;
}

//#define WinName "Справочник артикулов"
_fastcall TMainForm::TMainForm(TComponent *owner) : TWTMainForm(owner) {

  CountWindow = 0;

  // Добавляем пункты меню
  // первичные документы
  InDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("Транзакции", true, SprTranTable));
  InDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("Накопление транзакций", true, AccTran));
  InDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("Архив транзакций", true, ArhTranTable));

  // выходные документы
  OutDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("Проданные артикулы", true, SalesArtP));
  OutDocMenuItem->Add(NewWinDBGrid = CreateMenuItem("Проданные артикулы за период", true, SalesArtP));

  // справочники
  ServiseMenuItem->Add(CreateMenuItem("Справочник артикулов", true, SprArtTable));
  ServiseMenuItem->Add(CreateMenuItem("Справочник касс", true, SprKassTable));
  ServiseMenuItem->Add(CreateMenuItem("Справочник подразделений", true, SprPodrTable));

  // Временный запрос (нужен для обновления полей и другое)
  QueryTmp = new  TWTQuery(this);


  TWTToolBar* TB=new TWTToolBar(this);
  TB->Parent=MainCoolBar;
  TB->ID="Главная панель";

  // добавляем кнопки в главную панель
  TB->AddButton("Tranz", "Транзакции", SprTranTable);
  TB->AddButton("SaveTranz", "Накопление транзакций", AccTran);
  TB->AddButton("PerTranz", "Архив транзакций", ArhTranTable);
  TB->AddButton("|", NULL, NULL);
  TB->AddButton("Articul", "Проданные артикулы", SalesArtP);
  TB->AddButton("PerArticul", "Проданные артикулы за период", SalesArtP);
  TB->AddButton("|", NULL, NULL);
  TB->AddButton("SprArt", "Справочник артикулов", SprArtTable);
  TB->AddButton("SprKass", "Справочник касс", SprKassTable);
  TB->AddButton("SprPodr", "Справочник подразделений", SprPodrTable);
  TB->AddButton("Filter", "Тестовый документ", ShowDoc);

  MainCoolBar->AddToolBar(TB);

/* */ // добавляем кнопки в главную панель
  /*AddButton("|", NULL, NULL,0);
  AddButton("Filter", "Тестовый документ", ShowDoc,0);
  AddButton("SprPodr", "Справочник подразделений", SprPodrTable,0);
  AddButton("SprKass", "Справочник касс", SprKassTable,0);
  AddButton("SprArt", "Справочник артикулов", SprArtTable,0);
  AddButton("|", NULL, NULL,0);
  Button2=AddButton("PerArticul", "Проданные артикулы за период", SalesArtP,0);
  Button1=AddButton("Articul", "Проданные артикулы", SalesArtP,0);
  AddButton("|", NULL, NULL,0);
  AddButton("PerTranz", "Архив транзакций", ArhTranTable,0);
  AddButton("SaveTranz", "Накопление транзакций", AccTran,0);
  AddButton("Tranz", "Транзакции", SprTranTable,0);*/
    
  //регистрируем броуз в программном реестре
      /*
  TWTBrowseRegItem *BRI=new TWTBrowseRegItem("SprArt","articles");

  BRI->AddLookupField("namegrp","plu_grp","sp_grtov","name");
  BRI->AddLookupField("nameizm","kod_izm","sp_izm","name");

  TWTRegCol *RC;

  RC=BRI->AddColumn("plu_cod","Код арт.","Код артикула");
  RC->SetUnique("Очень неправильный код", "articles");
  RC->SetRequired("Код артикула должен быть заполнен");
  RC->SetFill(0,'0');

  BRI->AddColumn("plu_bar","Штрих-код арт.","Штрих-код артикула");
  RC=BRI->AddColumn("plu_ime","Наимен. арт.","Наименование артикула");
  RC->SetRequired("Наименование артикула должно быть заполнено");

  RC=BRI->AddColumn("plu_cen","Цена","Цена");
  RC->SetRequired("Цена артикула должна быть заполнена");

  BRI->AddColumn("plu_qty","Количество","Количество");
  RC = BRI->AddColumn("plu_stn","Отдел","Отдел");
  RC->SetRange(1,9,"Нарушение дозволенного интервала");
  RC->SetRequired("Отдел должен быть заполнен");

  RC = BRI->AddColumn("plu_grp","Группа. арт.","Группа артикулов");
  RC->SetOnHelp(GuideGrpTable);
  RC->SetRequired("Группа артикулов должна быть заполнена");

  RC=BRI->AddColumn("namegrp","Наимен. группы","Наименование группы артикулов");
  RC->SetOnHelp(GuideGrpTable);

  RC = BRI->AddColumn("plu_vat","Налог. группа.","Налоговая группа");
  RC->SetRange(1,8);
  RC->SetRequired("Налоговая группа должна быть заполнена");

  RC = BRI->AddColumn("plu_edp","Арт. группа.","Артикульная группа");
  RC->AddFixedVariable("1","Да");
  RC->AddFixedVariable("0","Нет");
  RC->SetDefValue(0);

  RC = BRI->AddColumn("point","Штучный/Весовой","Штучный/Весовой");
  RC->AddFixedVariable("True","Штучный");
  RC->AddFixedVariable("False","Весовой");
  RC->SetDefValue("False");

  RC = BRI->AddColumn("plu_nul","Запр. продаж","Запрет продаж при отрицательном количестве");
  RC->AddFixedVariable("1","Да");
  RC->AddFixedVariable("0","Нет");
  RC->SetDefValue(0);

  RC = BRI->AddColumn("kod_izm","Ед. изм.","Единицa измерения");
  RC->SetOnHelp(GuideIzmTable);
  RC->SetRequired("Единица измерения должна быть заполнена");

  RC=BRI->AddColumn("nameizm","Наимен. ед.изм.","Наименование единицы измерения");
  RC->SetOnHelp(GuideIzmTable);

  BRI->AddColumn("name","Полное наимен. тов.","Полное наименование товара");
  BRI->AddColumn("kas_list","Список касс","Список касс");
  RC=BRI->AddColumn("unlocked","Разр. продаж","Разрешение продаж");
  RC->AddFixedVariable("True","Да");
  RC->AddFixedVariable("False","Нет");
  RC->SetDefValue("True");

  BRI->Caption="WinName";
  Registry->AddItem(BRI);
  OnShowActiveWindows=ShowActiveWindows;*/

}

_fastcall TMainForm::~TMainForm(){
}

void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs){
  if (WindowsIDs->IndexOf("SprArt")!=-1) SprArtTable(NULL);
  if (WindowsIDs->IndexOf("SprKass")!=-1) SprKassTable(NULL);
  if (WindowsIDs->IndexOf("SprPodr")!=-1) SprPodrTable(NULL);
  AnsiString aa=StartupIniFile->ReadString("Data","ActiveWindow","");
  ShowMDIChild(aa);
}

void __fastcall TMainForm::ShowDoc(TObject *Sender){


/*  TStringList* SL=new TStringList();
  SL->Add("select plu_cod,plu_cen from articles");
  TWTWinDBGrid* DD=new TWTWinDBGrid(this,SL);
  DD->DBGrid->Query->Open();
  DD->DBGrid->Visible=true;

  SL->Clear();
  SL->Add("select plu_ime,plu_cen,plu_bar from articles");
  DD->DBGrid->Query->SetSQLSelect(SL);
  DD->DBGrid->Query->Open();

  return;*/
  TWTDoc *Doc=new TWTDoc(Application,"Reports\\TestDoc.dof");

  TWTDBGrid* Grid=new TWTDBGrid(Doc,"articles.db");
  Grid->Table->Open();

  TWTPanel* P=Doc->MainPanel->InsertPanel(100,true,20);
  TWTPanel* PP;
  TFont* F=new TFont();
  F->Size=16;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  P->Params->AddText("EXAMPLE",100,F,Classes::taCenter,true)->ID="NAME";

  PP=Doc->MainPanel->InsertPanel(100,true,0.5);
  PP->Params->AddGrid(Grid,true)->ID="GRID";

  Grid=new TWTDBGrid(Doc,"articles.db");
  Grid->Table->Open();
  PP=Doc->MainPanel->InsertPanel(100,true,0.5);
  PP->Params->AddText("EXAMPLE2",100,NULL,Classes::taCenter,true)->ID="NAME";
  PP->Params->AddGrid(Grid,true)->ID="GRID2";

  delete F;

  P=Doc->MainPanel->InsertPanel(100,true,10);
  P->Params->AddSimple("Код 1",40,"")->ID="KOD1";
  P->Params->AddSimple("Наименование 1",150,"")->ID="NAME1";
  P=Doc->MainPanel->InsertPanel(100);
  P->Params->AddSimple("Код 2",40,"")->ID="KOD2";
  P->Params->AddSimple("Наименование 2",150,"")->ID="NAME2";
  P=Doc->MainPanel->InsertPanel(100,true,10);
  P->Params->AddSimple("Код 3",40,"")->ID="KOD3";
  P->Params->AddSimple("Наименование 3",150,"")->ID="NAME3";
  P=Doc->MainPanel->InsertPanel(100);
  P->Params->AddSimple("Код 4",40,"")->ID="KOD4";
  P->Params->AddSimple("Наименование 4",150,"")->ID="NAME4";
  Doc->ShowAs("TestDoc");
//  Doc->FormStyle=fsMDIChild;
  Doc->SetCaption("Тестовый документ"); //не должно содержать "["
  // обязательно для загрузки отчета из файла. должно идти после SetCaption
  Doc->LoadFromFile(Doc->DocFile);
  Doc->Constructor=true;

//  PP->AlignByClient=true;
}


void _fastcall TMainForm::OnGetText123(TField* Sender, AnsiString
 &Text, bool DisplayText) {

 TStringList *SL=new TStringList();
 SL->Add("ProcessValue('It is true','It is false')");

 Value = Sender->AsString;

// TWTTPC *TP=new TWTTPC(this);
// TPComp->Process(SL);

 Text = Result;
 delete SL;
// delete TP;
}
//---------------------------------------------------------------------
#define WinName "Справочник артикулов"
void _fastcall TMainForm::SprArtTable(TObject *Sender) {
  SprArtTableF(NULL);
}

void _fastcall TMainForm::SprArtTableF(TWTField *Sender) {
  // Определяем владельца
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

   // TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;
  // Если такое окно есть - активизируем и выходим

  if (ShowMDIChild(WinName)) {
    return;
  }
   TWTWinDBGrid *DBGrid = new TWTWinDBGrid(this, CreateFullTableName("ARTICLES"),false);

   //DBGrid=ShowBrowse("SprArt");
 // TWTWinDBGrid *DBGrid = new TWTWinDBGrid(this, CreateFullTableName("ARTICLES"),false);

  //DBGrid->SetCaption(WinName);

  //TWTTable* Table = DBGrid->DBGrid->Table;
  // Добавляем поля для просмотра и для ограничения на наличие поля в справочнике

  DBGrid->DBGrid->Table->Open();

  TWTField *Field;



  Field = DBGrid->AddColumn("PLU_COD", "Код", "Код артикула");
  Field->SetUnique("Такой код присутствует в справочнике", FullTableName("ARTICLES"));
  Field->SetRequired("Код должен быть заполнен");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "099999";

  Field = DBGrid->AddColumn("PLU_BAR", "Штрих-код", "Штрих-код артикула");
  Field->Field->EditMask = "9999999999999";

  Field = DBGrid->AddColumn("PLU_IME", "Артикул", "Наименование артикула");
  Field->SetRequired("Наименование артикула должно быть заполнено");

  Field = DBGrid->AddColumn("PLU_CEN", "Цена", "Цена");
  Field->SetRequired("Цена артикула должна быть заполнена");
  Field->Precision = 2;

  Field = DBGrid->AddColumn("PLU_QTY", "Количество", "Количество лимита товара для продажи");
  Field->Precision = 3;

  Field = DBGrid->AddColumn("PLU_STN", "Отдел", "Отдел");
  Field->SetRange(1,9, "Значение должно быть в интервале от 1 до 9");
  Field->SetRequired("Отдел должен быть заполнен");
  Field->Field->EditMask = "0";

  Field = DBGrid->AddColumn("PLU_GRP", "Код", "Код группы артикулов");
  //Field->SetOnHelp(SprGrpArt);
  Field->SetRequired("Группа артикулов должна быть заполнена");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "09";
    /*
  Field = DBGrid->AddColumn("NAME_GRTOV", "Группа артикулов", "Наименование группы артикулов");
  //Field->SetOnHelp(SprGrpArt);

  Field = DBGrid->AddColumn("PLU_VAT", "Налог", "Налоговая группа");
  Field->SetRange(1,8, "Значение должно быть в интервале от 1 до 8");
  Field->SetRequired("Налоговая группа должна быть заполнена");
  Field->SetDefValue(1);
  Field->Field->EditMask = "0";

  Field = DBGrid->AddColumn("PLU_EDP", "Арт. группа", "Артикульная группа");
  Field->AddFixedVariable("0", "Нет");
  Field->AddFixedVariable("1", "Да");
  Field->SetDefValue("0");

  Field = DBGrid->AddColumn("POINT", "Товар", "Штучный/Весовой");
  Field->AddFixedVariable("False", "Весовой");
  Field->AddFixedVariable("True", "Штучный");
  Field->SetDefValue(false);

  Field = DBGrid->AddColumn("PLU_NUL", "Контроль", "Запрет продаж при отрицательном количестве");
  Field->AddFixedVariable("0", "Выкл");
  Field->AddFixedVariable("1", "Вкл");
  Field->SetDefValue("0");

  Field = DBGrid->AddColumn("KOD_GRP", "Учетн.гр", "Учетная группа товара");
  //Field->SetOnHelp(SprGrpCalc);
  Field->SetRequired("Учетная группа должна быть заполнена");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "09";

  Field = DBGrid->AddColumn("NAME_GRP_R", "Группа", "Наименование учетной группы товара");
  //Field->SetOnHelp(SprGrpCalc);

  Field = DBGrid->AddColumn("KOD_IZM", "Код", "Код единицы измерения");
// Field ->SetOnHelp(SprIzm);
  Field->SetRequired("Единица измерения должна быть заполнена");
  Field->SetFill(0,'0');
  Field->Field->EditMask = "09";

  Field = DBGrid->AddColumn("NAME_IZM", "Ед.изм", "Наименование единицы измерения");
  //Field->SetOnHelp(SprIzm);
   */
  DBGrid->AddColumn("NAME", "Наименование товара", "Полное наименование товара");
  DBGrid->AddColumn("KAS_LIST", "Список касс", "Список кассовых аппаратов");
     /*
  Field = DBGrid->AddColumn("UNLOCKED", "Продажа", "Разрешение продажи кассовым аппаратом");
  Field->AddFixedVariable("True", "Разрешена");
  Field->AddFixedVariable("False", "Запрещена");
  Field->SetDefValue(true);
       */
  DBGrid->DBGrid->FieldSource = DBGrid->DBGrid->Table->GetTField("PLU_COD");
  DBGrid->DBGrid->FieldDest = Sender;
  /*DBGrid->DBGrid->Visible = true;
  //DBGrid->FormStyle = fsMDIChild;
   DBGrid->ShowAs("SPR_ART");      */
     DBGrid->SetCaption(WinName);
//  DBGridMission2->StatusBar->SimplePanel= true;
//  DBGridMission2->StatusBar->Panels->Items[0]->Text= DBGridMission2->List->Items->Strings[0];
  DBGrid->DBGrid->Visible = true;
  //ShowBrowse("SprArt");
  //DBGrid->DBGrid->Visible = true;
  DBGrid->DBGrid->SetFocus();


};

//---------------------------------------------------------------------------
#define WinName "Справочник единиц измерения" //для справочника артикулов
void __fastcall TMainForm::GuideIzmTable(TWTField* Sender) {
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName)) {
    return;
  }
  // Создаем броуз
  DBGridGuide1 = new TWTWinDBGrid(this,"sp_izm");

  DBGridGuide1->DBGrid->Visible= false;
  DBGridGuide1->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridGuide1->AddColumn("kod","Код ед. изм.","");
  Field->SetUnique("Данная ед. измерения уже присутствует в справочнике", "sp_izm");
  Field->SetRequired("Код единицы измерения должен быть заполнен");
  Field=DBGridGuide1->AddColumn("name","Наименование","");

  DBGridGuide1->DBGrid->FieldSource = DBGridGuide1->DBGrid->Table->GetTField("kod");
  DBGridGuide1->DBGrid->FieldDest = DBGridMission1->DBGrid->Table->GetTField("kod_izm");
  DBGridGuide1->SetCaption(WinName);
//  DBGridGuide1->DBGridd= DBGridMission1->DBGrid;
  DBGridGuide1->DBGrid->Visible = true;
  DBGridGuide1->DBGrid->SetFocus();
}

//---------------------------------------------------------------------------
#define WinName "Справочник групп артикулов" //для справочника артикулов
void __fastcall TMainForm::GuideGrpTable(TWTField* Sender) {
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName)) {
    return;
  }
  // Создаем броуз
  DBGridGuide2 = new TWTSprDBGrid(DBGridMission1, "sp_grtov");

  DBGridGuide2->DBGrid->Visible= false;
  DBGridGuide2->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridGuide2->AddColumn("kod","Код группы","");
  Field->SetUnique("Данная группа уже присутствует в справочнике", "sp_izm");
  Field->SetRequired("Код группы должен быть заполнен");
  DBGridGuide2->AddColumn("name","Наименование","");

  DBGridGuide2->FieldSource = DBGridGuide2->DBGrid->Table->GetTField("kod");
  DBGridGuide2->FieldDest = DBGridMission1->DBGrid->Table->GetTField("plu_grp");

  DBGridGuide2->DBGridd= DBGridMission1->DBGrid;
  DBGridGuide2->DBGrid->Visible = true;
  DBGridGuide2->SetCaption(WinName);
  DBGridGuide2->DBGrid->SetFocus();
}

//---------------------------------------------------------------------------
#define WinName "Справочник касс"
void _fastcall TMainForm::SprKassTable(TObject *Sender) {
  // Если такое окно есть - активизируем и выходим
/*  if (ShowMDIChild(WinName)) {
    return;
  }*/

/*  TWTParamsForm *PF=new TWTParamsForm(Application,"sfghfgh");
  PF->Params->AutoBreak=true;
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"")->SetButton(NULL);
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",500,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->Params->AddSimple("sfghjfghj",100,"");
  PF->ShowModal();
  return;

/*  TWTCheckingForm *CF=new TWTCheckingForm(Application,"Parameters");
  CF->AddItem("aaaaaaaaaaaaaaaaaa",true);
  CF->AddItem("bbbbbbbbbbb",false);
  CF->AddItem("ccccccccccccc",false);
  CF->AddItem("ddddddddddddddddd",true);
  CF->AddItem("eeeeeeeeeeeee",false);
  CF->AddItem("ffffffffffffffffffff",true);
  CF->FormStyle=fsMDIChild;
  CF->OnAccept=OnParameters;
//  CF->TForm::ShowMod();*/

/*  TStringList *SL=new TStringList();
  SL->Add("Select plu_cod,plu_grp from articles");

  DBGridMission2=new TWTWinDBGrid(this,SL);
  DBGridMission2->DBGrid->Query->AddLookupField("namegrp","plu_grp","sp_grtov","name");

  DBGridMission2->DBGrid->Query->Open();

  DBGridMission2->AddColumn("plu_cod","Kod art");
  DBGridMission2->AddColumn("plu_grp","Gruppa");
  TWTField *Field;
  Field=DBGridMission2->AddColumn("namegrp","Imya gruppi");*/


//  return;
//################################################################################
/*  TStringList *SS=new TStringList();
  SS->Add("select plu_cod,plu_ime from articles");*/
/*  DBGridMission2=new TWTWinDBGrid(this,"articles");
  DBGridMission2->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridMission2->AddColumn("plu_cod","Kod","Kod articula");
  Field->AddFixedVariable("001001","ffffff");
  Field->AddFixedVariable("001002","aaaaaa");
  Field=DBGridMission2->AddColumn("plu_ime","Name","Name articula");
  Field=DBGridMission2->AddColumn("unlocked","Разр. продаж","Разрешение продаж");
  Field->AddFixedVariable("True","Да");
  Field->AddFixedVariable("False","Нет");
  Field->SetReadOnly();
  DBGridMission2->AlignWidth();*/
//################################################################################


  DBGridMission2 = new TWTWinDBGrid(this, "sp_cash",false);
  DBGridMission2->DBGrid->Visible= false;

  TWTTable* Table=DBGridMission2->DBGrid->Table;
  Table->AddLookupField("NameKodPodr","kod_podr","sp_podr","name");

  DBGridMission2->DBGrid->Table->Open();

//  TWTField *Field;
  TWTField* Field=DBGridMission2->AddColumn("s_num","Номер","Заводской номер кассы");
  Field->SetRequired("Заводской номер кассы должен быть заполнен");
  Field=DBGridMission2->AddColumn("num","Касса","Номер кассы");
  Field->SetUnique("Данный номер кассы уже присутствует в справочнике", "sp_cash");
  Field->SetRequired("Номер кассы должен быть заполнен");

  Field=DBGridMission2->AddColumn("port","Порт","");
  Field->SetRequired("Порт должен быть заполнен");
  Field=DBGridMission2->AddColumn("kod_podr","Код","Код отдела");
  Field->SetOnHelp(GuidePodrKasTable);
  Field->SetRequired("Код отдела должен быть заполнен");

  DBGridMission2->AddColumn("NameKodPodr","Наимен. отдела","Наименование отдела");

  Field=DBGridMission2->AddColumn("cash_type","Тип","Тип кассы");
  Field->SetRequired("Тип кассы должен быть заполнен");
  Field->AddFixedVariable("0", "Samsung On-Line");
  Field->AddFixedVariable("1", "Samsung с аналитикой");
  Field->AddFixedVariable("2", "Samsung On-Line");
  Field->AddFixedVariable("3", "Datesc On-Line");
  Field->AddFixedVariable("4", "Samsung фискальный принтер");
  Field->AddFixedVariable("5", "Samsung с CashDrive");
  Field->AddFixedVariable("6", "Datecs с CashDrive");
  Field->AddFixedVariable("7", "Datesc On-Line с аналитикой");
  Field->AddFixedVariable("8", "Datesc фискальный принтер");
  Field->AddFixedVariable("A", "ЭРА 101.10 On-Line");
  Field->AddFixedVariable("B", "ЭРА 101.10 On-Line терминал");
  Field->AddFixedVariable("C", "ЭРА 101.10 фискальный принтер");
  Field->AddFixedVariable("D", "ЭРА 101.10 с CashDrive");
  Field->AddFixedVariable("E", "ЭРА 101.10 с аналитикой");
  Field->AddFixedVariable("S", "Silex On-Line");
  Field->AddFixedVariable("T", "Silex фискальный принтер");
  Field->AddFixedVariable("M", "Mini");
  Field->AddFixedVariable("N", "Mini с CashDrive");

  DBGridMission2->AddColumn("anal_table","Имя таблицы","Имя таблицы аналитики");
  DBGridMission2->AddColumn("anal_name","Наимен. аналитики","Наименование аналитики");
  DBGridMission2->AddColumn("key_field","Поле кода аналитики","");
  DBGridMission2->AddColumn("info_field","Наимен. аналитики","Наименование аналитики");
  DBGridMission2->AddColumn("init_text","Инициал. аналитики","Инициализация аналитики");
  DBGridMission2->AddColumn("final_text","Конец аналитики","");
  DBGridMission2->AddColumn("key_len","Длина ключ. поля","Длина ключевого поля");

  DBGridMission2->SetCaption(WinName);
//  DBGridMission2->StatusBar->SimplePanel= true;
//  DBGridMission2->StatusBar->Panels->Items[0]->Text= DBGridMission2->List->Items->Strings[0];
  DBGridMission2->ShowAs("SprKass");
  DBGridMission2->DBGrid->Visible = true;
  DBGridMission2->DBGrid->SetFocus();
}

#define WinName "Справочник подразделений (для справочника касс)" //для справочника касс
void __fastcall TMainForm::GuidePodrKasTable(TWTField* Sender) {
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName)) {
    return;
  }
  // Создаем броуз
  DBGridGuide6 = new TWTSprDBGrid(DBGridMission2, "sp_podr");
  DBGridGuide6->DBGrid->Visible= false;
  DBGridGuide6->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridGuide6->AddColumn("kod","Код подразделения","");
  Field->SetUnique("Подразделение уже присутствует в справочнике", "sp_podr");
  Field->SetRequired("Код подразделения  должен быть заполнен");
  DBGridGuide6->AddColumn("name","Наименование","");

  AnsiString Value;
  DBGridGuide6->SetCaption(WinName);
  DBGridGuide6->DBGrid->FieldSource = DBGridGuide6->DBGrid->Table->GetTField("kod");
  DBGridGuide6->DBGrid->FieldDest = DBGridMission2->DBGrid->Table->GetTField("kod_podr");
  Value=DBGridMission2->DBGrid->Table->GetField("kod_podr")->AsString;
//  DBGridGuide6->DBGridd= DBGridMission2->DBGrid;
  DBGridGuide6->DBGrid->Visible = true;
  DBGridGuide6->DBGrid->SetFocus();
}

//---------------------------------------------------------------------
#define WinName "Справочник подразделений"
void _fastcall TMainForm::SprPodrTable(TObject *Sender) {
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName)) {
    return;
  }
  // Создаем броуз
  DBGridMission3 = new TWTWinDBGrid(this, "sp_podr",false);
  DBGridMission3->DBGrid->Visible= false;
  DBGridMission3->DBGrid->Table->Open();

  TWTField *Field;
  Field=DBGridMission3->AddColumn("kod","Код","Код подразделения");
  Field->SetUnique("Подразделение уже присутствует в справочнике", "sp_podr");
  Field->SetRequired("Код подразделения  должен быть заполнен");
  DBGridMission3->AddColumn("name","Наименование","Наименование подразделения");

  Field=DBGridMission3->AddColumn("priz","Тип отдела","Признак отдела/ подотдела");
  Field->AddFixedVariable("0","Внешний");
  Field->AddFixedVariable("1","Магазин");
  Field->AddFixedVariable("2","Отдел");
  Field->AddFixedVariable("3","Группа отделов");

  DBGridMission3->ShowAs("SprPodr");
  DBGridMission3->SetCaption(WinName);
  DBGridMission3->DBGrid->Visible = true;
//  DBGridMission3->StatusBar->SimplePanel= true;
//  DBGridMission3->StatusBar->Panels->Items[0]->Text= DBGridMission3->List->Items->Strings[0];
  DBGridMission3->DBGrid->SetFocus();
}

//---------------------------------------------------------------------
#define WinName "Tранзакции"
void _fastcall TMainForm::SprTranTable(TObject *Sender) {

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName)) {
    return;
  }

  // Создаем броуз
  DBGridMission4 = new TWTWinDBGrid(this, "trans");
  DBGridMission4->DBGrid->Visible= false;

  TWTTable* Table=DBGridMission4->DBGrid->Table;
  Table->AddLookupField("nkod","kod_podr","sp_podr","name");
  Table->AddLookupField("namek","kod","sp_tran","name");
  TField* FField=Table->AddLookupField("ncod","article","articles","name")->Field;
  FField->LookupKeyFields = "plu_cod";
  Table->AddLookupField("nerror","error_code","sp_error","name");

  DBGridMission4->DBGrid->SetReadOnly();
  DBGridMission4->DBGrid->TimerOn= false;
  DBGridMission4->DBGrid->Timer->Enabled= false;
  DBGridMission4->DBGrid->Table->Open();

  TWTField* Field;
  DBGridMission4->AddColumn("kassa","Касса","Номер кассы");
  DBGridMission4->AddColumn("kasa_sn","Номер","Заводской номер кассы");
  DBGridMission4->AddColumn("kod_podr","Код","Код отдела");
  DBGridMission4->AddColumn("nkod","Наимен. отдела","Наименование отдела");
  DBGridMission4->AddColumn("counter","Счетчик","");
  DBGridMission4->AddColumn("kod","Код","Код транзакции");
  DBGridMission4->AddColumn("namek","Наимен. транз.","Наименование транзакции");
  DBGridMission4->AddColumn("article","Код","Код товара");
  DBGridMission4->AddColumn("ncod","Наимен. товара","Наименование товара");
  DBGridMission4->AddColumn("plu_cen","Цена","Цена товара");
  DBGridMission4->AddColumn("plu_qty","Кол-во","Проданное количество");
  DBGridMission4->AddColumn("d_otchet","Дата","Дата продажи");
  DBGridMission4->AddColumn("t_otchet","Время","Время продажи");
  Field=DBGridMission4->AddColumn("valid","Корректность","Условие корректности");
  Field->AddFixedVariable("True","Да");
  Field->AddFixedVariable("False","Нет");

  Field=DBGridMission4->AddColumn("error_code","Код","Код ошибки");
  Field->SetReadOnly();

  DBGridMission4->AddColumn("nerror","Наимен. ошибки","Наименование ошибки");
  DBGridMission4->AddColumn("analit","Код аналитики","");
  DBGridMission4->AddColumn("count_acc","Счетчик","Счетчик накоплений");

  DBGridMission4->SetCaption(WinName);
  DBGridMission4->DBGrid->Visible = true;
//  DBGridMission4->StatusBar->SimplePanel= true;
//  DBGridMission4->StatusBar->Panels->Items[0]->Text= DBGridMission4->List->Items->Strings[0];
  DBGridMission4->DBGrid->SetFocus();
}

//---------------------------------------------------------------------------
// Накопление транзакций
void _fastcall TMainForm::AccTran(TObject *Sender) {

  TForm * MF = new TForm(this);
  MF->Width= 300;
  MF->Height = 100;
  MF->Position= poScreenCenter;
  MF->Visible= true;
  TLabel *Label = new TLabel(this);
  Label->Left = 20;
  Label->Top= 30;
  Label->Font->Size= -13;
  Label->Caption= "Идет процесс накопления транзакций";
  Label->Parent= MF;
  Application->ProcessMessages();

  Screen->Cursor= crSQLWait;
  TStringList *SQL= new TStringList();
  SQL->Add("UPDATE TRANS SET COUNT_ACC=0 WHERE COUNT_ACC is Null");
  TWTQuery *QueryAcc = new TWTQuery(this, SQL);
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add("UPDATE TRANS SET COUNT_ACC= COUNT_ACC + 1");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" INSERT INTO 'DE_TRANS.DB' (KASSA, KOD_PODR, KASA_SN, COUNTER, KOD, ");
  QueryAcc->SQL->Add(" ARTICLE, PLU_CEN, PLU_QTY, SUMMA, ");
  QueryAcc->SQL->Add(" D_OTCHET, T_OTCHET, VALID, ERROR_CODE, ANALIT, COUNT_ACC) ");
  QueryAcc->SQL->Add("  SELECT  KASSA, KOD_PODR, KASA_SN, COUNTER, KOD, ");
  QueryAcc->SQL->Add("  ARTICLE, PLU_CEN, PLU_QTY, SUMMA, ");
  QueryAcc->SQL->Add("  D_OTCHET, T_OTCHET, VALID, ERROR_CODE, ANALIT, COUNT_ACC ");
  QueryAcc->SQL->Add("  FROM 'TRANS.DB' Tr WHERE Tr.COUNT_ACC > 0");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" DELETE FROM ART_OTC WHERE ART_OTC.'DATE' IN ");
  QueryAcc->SQL->Add(" (SELECT DISTINCT D_OTCHET FROM TRANS)");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" INSERT INTO 'ART_OTC.DB' ('ART_OTC.DB'.'DATE', KOD_PODR, KASSA, ");
  QueryAcc->SQL->Add(" ART_COD, SUMMA, KOLVO, PRICE) ");
  QueryAcc->SQL->Add(" SELECT D_OTCHET, KOD_PODR, KASSA, ARTICLE, ");
  QueryAcc->SQL->Add(" SUM(SUMMA) as SUM1 , SUM(PLU_QTY) as SUM2, PLU_CEN ");
  QueryAcc->SQL->Add(" FROM 'DE_TRANS.DB' ");
  QueryAcc->SQL->Add(" WHERE (KOD=1 OR KOD= 7) AND VALID= True ");
  QueryAcc->SQL->Add(" GROUP BY D_OTCHET, KOD_PODR, KASSA, ARTICLE, PLU_CEN ");
  QueryAcc->ExecSQL();

  QueryAcc->SQL->Clear();
  QueryAcc->SQL->Add(" DELETE FROM TRANS WHERE TRANS.COUNT_ACC > 0");
  QueryAcc->ExecSQL();

  Screen->Cursor= crArrow;
  MF->Close();
  DEL(SQL);
  ShowMessage("Накопление транзакций выполнено");
}

//---------------------------------------------------------------------
#define WinName "Архив транзакций"
void _fastcall TMainForm::ArhTranTable(TObject *Sender) {

  TDateTime DateTime;
  DateTime = StrToDate(DateToStr(Date()), NULL);
  if (!GetDate("Введите дату", &DateTime)) {
    return;
  }

  AnsiString S= "Архив транзакций по таблице за " +DateTime;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(S)) {
    return;
  }

  // Создаем броуз
  DBGridMission4 = new TWTWinDBGrid(this, "de_trans");
  DBGridMission4->DBGrid->Visible= false;

  TWTTable* Table=DBGridMission4->DBGrid->Table;
  Table->AddLookupField("nkod","kod_podr","sp_podr","name");
  Table->AddLookupField("namek","kod","sp_tran","name");
  TField* FField=Table->AddLookupField("ncod","article","articles","name")->Field;
  FField->LookupKeyFields = "plu_cod";
  Table->AddLookupField("nerror","error_code","sp_error","name");

  DBGridMission4->DBGrid->SetReadOnly();
  DBGridMission4->DBGrid->TimerOn= false;
  DBGridMission4->DBGrid->Timer->Enabled= false;
  DBGridMission4->DBGrid->Table->Filter= "d_otchet= " + DateToStr(DateTime);
  DBGridMission4->DBGrid->Table->Filtered= true;
  DBGridMission4->DBGrid->Table->Open();

  TWTField* Field;
  DBGridMission4->AddColumn("kassa","Касса","Номер кассы");
  DBGridMission4->AddColumn("kasa_sn","Номер","Заводской номер кассы");
  DBGridMission4->AddColumn("kod_podr","Код","Код отдела");
  DBGridMission4->AddColumn("nkod","Наимен. отдела","Наименование отдела");
  DBGridMission4->AddColumn("counter","Счетчик","Счетчик");
  DBGridMission4->AddColumn("kod","Код","Код транзакции");
  DBGridMission4->AddColumn("namek","Наимен. транз.","Наименование транзакции");
  DBGridMission4->AddColumn("article","Код","Код товара");
  DBGridMission4->AddColumn("ncod","Наимен. товара","Наименование товара");
  DBGridMission4->AddColumn("plu_cen","Цена","Цена товара");
  DBGridMission4->AddColumn("plu_qty","Кол-во","Проданное количество");
  DBGridMission4->AddColumn("summa","Сумма","");
  DBGridMission4->AddColumn("d_otchet","Дата","Дата продажи");
  DBGridMission4->AddColumn("t_otchet","Время","Время продажи");
  Field=DBGridMission4->AddColumn("valid","Корректность","Условие корректности");
  Field->AddFixedVariable("True","Да");
  Field->AddFixedVariable("False","Нет");

  Field=DBGridMission4->AddColumn("error_code","Код","Код ошибки");
  Field->SetReadOnly();

  DBGridMission4->AddColumn("nerror","Наимен. ошибки","Наименование ошибки");
  DBGridMission4->AddColumn("analit","Код аналитики","Код аналитики");
  DBGridMission4->AddColumn("count_acc","Счетчик","Счетчик накоплений");

  DBGridMission4->SetCaption(S);
  DBGridMission4->DBGrid->Visible = true;
//  DBGridMission4->StatusBar->SimplePanel= true;
//  if (DBGridMission4->List) DBGridMission4->StatusBar->Panels->Items[0]->Text= DBGridMission4->List->Items->Strings[0];
  DBGridMission4->DBGrid->SetFocus();

}

//---------------------------------------------------------------------
void __fastcall TMainForm::Sales(AnsiString S) {

  DBGridMissionS->AddColumn("KOD_PODR","Код","Код подразделения");
  DBGridMissionS->AddColumn("NKOD","Наимен. подр.","Наименование подразделения");
  DBGridMissionS->AddColumn("KASSA","Касса","Номер кассы");
  DBGridMissionS->AddColumn("ART_COD","Код","Код артикула");
  DBGridMissionS->AddColumn("NCOD","Наимен. арт.","Наименование артикула");
  DBGridMissionS->AddColumn("PRICE","Цена","Цена артикула");
  DBGridMissionS->AddColumn("KOLVO","Кол-во","Проданное количество");
  DBGridMissionS->AddColumn("SUMMA","Сумма","");
  DBGridMissionS->SetCaption(S);
  DBGridMissionS->DBGrid->Visible = true;
//  DBGridMissionS->StatusBar->SimplePanel= true;
//  DBGridMissionS->StatusBar->Panels->Items[0]->Text= DBGridMissionS->List->Items->Strings[0];
  DBGridMissionS->DBGrid->SetFocus();
}

//---------------------------------------------------------------------
#define WinName= Проданные артикулы за период.
void _fastcall TMainForm::SalesArtP(TObject *Sender) {
  Form=new TWTParamsForm(this,"Выбор параметров");
  Form->OnAccept=OnOkClick;

  TStringList *SQL = new TStringList();
  SQL->Add("SELECT KOD, NAME FROM SP_PODR ORDER BY KOD");
  SprQuery=new TWTQuery(Form,SQL);
  SprQuery->Open();

  TWTParamItem* PI=Form->Params->AddSimple("Код магазина",50,"",true);
  PI->SetRequired(SprQuery,"kod");
  PI->SetButton(FOnClick);
  Form->Params->AddDb("Магазин",SprQuery,"name",200,true)->SetReadOnly(true);
  Form->Params->AddDate("Дата с",50,true);
  if (Sender==Button2) Form->Params->AddDate("по",50,false);
  if (Form->TForm::ShowModal()!=5) {
    delete Form;
    return;
  }
}

void _fastcall TMainForm::OnOkClick(TWTParamsForm* Sender,bool &CloseFlag){
  AnsiString S1= Form->Params->Get(0)->Value;
  AnsiString S2= Form->Params->Get(2)->Value;
  AnsiString S3;
  if (Form->Params->Count==4) S3= Form->Params->Get(3)->Value;
  else S3=S2;

  TStringList *SQL = new TStringList();
  SQL->Add("SELECT * FROM  SP_PODR ");
  SQL->Add("WHERE KOD = " + ToStrSQL(S1));
  QueryTmp->SetSQLSelect(SQL);
  QueryTmp->Open();

  AnsiString S;
  if (Form->Params->Count==4) S= "Проданные артикулы c " +S2+ " по " +S3+ " по магазину "+ QueryTmp->Fields->Fields[1]->AsString;
  else S= "Проданные артикулы за " +S2+ " по магазину "+ QueryTmp->Fields->Fields[1]->AsString;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(S)) {
    return;
  }

  // Создаем броуз
  DBGridMissionS = new TWTWinDBGrid(this);

  // Формируем выборку из базы
  SQL->Clear();
  SQL->Add(" SELECT ART_OTC.KOD_PODR, SP_PODR.NAME as NKOD, KASSA, ");
  SQL->Add(" ART_COD, ARTICLES.NAME as NCOD, PRICE,");
  SQL->Add(" KOLVO, SUMMA ");
  SQL->Add(" FROM (ART_OTC LEFT JOIN  SP_PODR ");
  SQL->Add(" ON ART_OTC.KOD_PODR = SP_PODR.KOD) ");
  SQL->Add(" LEFT JOIN ARTICLES ON ART_OTC.ART_COD = ARTICLES.PLU_COD ");
  SQL->Add(" WHERE ART_OTC.'DATE' >= :dates  AND ART_OTC.'DATE' <= :datepo ");
  SQL->Add(" AND KOD_PODR LIKE :Ch ");

  DBGridMissionS->DBGrid->Query->SetSQLSelect(SQL);
  DBGridMissionS->DBGrid->Timer->Enabled= false;
  DBGridMissionS->DBGrid->TimerOn= false;
  DBGridMissionS->DBGrid->SetReadOnly();
  DBGridMissionS->DBGrid->Query->ParamByName("dates")->AsDate= SetCentury(StrToDate(S2));
  DBGridMissionS->DBGrid->Query->ParamByName("datepo")->AsDate= SetCentury(StrToDate(S3));
  S1.Delete(2,2);
  S1.Insert("__",2);
  DBGridMissionS->DBGrid->Query->ParamByName("Ch")->AsString= S1;
  DBGridMissionS->DBGrid->Query->Open();
  DBGridMissionS->DBGrid->Visible = false;

  Sales(S);
  DEL(SQL);
}
//----------------------------------------------------------------------------
AnsiString _fastcall TMainForm::FOnClick(TWTParamItem *Sender) {
  // Создаем справочник подразделений
  // Формируем выборку из базы
  TStringList *SQL = new TStringList();
  SQL->Add("SELECT KOD, NAME FROM SP_PODR ORDER BY KOD");
//  DBGridGuide6->DBGrid->Query->SetSQLSelect(SQL);

  DBGridGuide6 = new TWTWinDBGrid(this,SQL,false);
//  DBGridGuide6->FEnter=NULL;

  // Формируем выборку из базы
  DBGridGuide6->DBGrid->SetReadOnly();
  DBGridGuide6->DBGrid->Query->Open();
//  DBGridGuide6->DBGrid->Visible = false;

  DBGridGuide6->DBGrid->FieldSource=DBGridGuide6->AddColumn("kod","Код подразделения","");
  DBGridGuide6->AddColumn("name","Наименование","");
  DBGridGuide6->SetCaption("Справочник подразделений");
//  DBGridGuide6->DBGrid->Visible = true;
//  DBGridGuide6->DBGrid->SetFocus();
//  DBGridGuide6->FormStyle=wsNormal;
//  DBGridGuide6->Visible=false;
//  MainForm->MainMenuEnabled(true);
  AnsiString DDD="rrr";
  DBGridGuide6->DBGrid->StringDest=&DDD;
//  DBGridGuide6->DBGrid->FieldSource=DBGridGuide6->DBGrid->Query->GetTField("kod");

  DBGridGuide6->TForm::ShowModal();

  return DBGridGuide6->DBGrid->Query->Fields->Fields[0]->AsString;
}
