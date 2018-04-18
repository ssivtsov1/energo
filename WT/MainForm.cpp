//---------------------------------------------------------------------
#include <vcl.h>
#include "Message.h"
//#include "Fields.h"
#include "Query.h"
#include "DBGrid.h"
#include "SprGrid.h"
#include "Func.h"
#include "Table.h"

#pragma hdrstop

#include "MainForm.h"

//---------------------------------------------------------------------
// функции класса TWTMainForm
//---------------------------------------------------------------------
//---------------------------------------------------------------------
void _fastcall TWTMainForm::OnToolButton1Click(TObject* Sender) {
  Close();
}

void _fastcall TWTMainForm::ReportWizardClick(TObject* Sender){
 /* Enabled=false;
  TWTReportWizard *RW=new TWTReportWizard(Application);
  RW->DreamDesigner->Active=true;*/
//  RW->ToolsForm=new TWTToolsForm(Application);
}


//class TWTFunc;
//---------------------------------------------------------------------
_fastcall TWTMainForm::TWTMainForm(TComponent *owner) : TWTForm(owner) {

//  TPComp=new TWTTPC();
  IniFile=NULL;
  GlobalIniFile=NULL;
  StartupIniFile=new TMemIniFile("startup.ini");
  Registry=new TWTRegistry();
 /* TPComp->Analizer->Generator->OnMultiVars=FindRegValue;
  TPComp->Analizer->Generator->OnSetMultiVars=SetRegValue;
  TPComp->Analizer->Generator->OnDoFunction=MakeFunction;
  TPComp->Analizer->Generator->OnDoMultiFunction=MakeRegFunction;
  TPComp->Analizer->Generator->OnCheckParams=CheckParams;*/


  PreviewForm=NULL;

//  TField *Field;

  Width = 640;
  Height = 480;
  Caption = Application->Title;
  FormStyle = fsMDIForm;
  Menu = MainMenu;
  Position = poScreenCenter;
  //WindowState=wsNormal;
  WindowState=wsMaximized;

  StatusBar = new TStatusBar(owner);
  StatusBar->Parent = this;
  Screen->OnActiveFormChange = FOnActiveFormChange;

  DialogCount=0;

  // Создаем главное меню
  TMenuItem * aMenuItem[9];

  aMenuItem[0] = QuitMenuItem    = CreateMenuItem("В&ыход", true, Close, "ExitMenu");
  //aMenuItem[1] = ClientMenuItem  = CreateMenuItem("&Клиенты", true, NULL, "ClientMenu");
  aMenuItem[1] = InDocMenuItem   = CreateMenuItem("&Картотека", true, NULL, "InDocMenu");
  aMenuItem[2] = CalcMenuItem  = CreateMenuItem("&Расчеты", true, NULL, "CalcMenu");
  //aMenuItem[2] = TableMenuItem   = CreateMenuItem("&Работа с таблицами",true,TableMenuClick,"");
  aMenuItem[3] = ServiseMenuItem = CreateMenuItem("&Справочники", true, NULL, "ServiseMenu");
  aMenuItem[4] = OutDocMenuItem  = CreateMenuItem("&Отчеты", true, NULL, "OutDocMenu");
  aMenuItem[5] = ToolsMenuItem  = CreateMenuItem("&Настройки", true, NULL, "ToolsMenu");
  aMenuItem[6] = TableMenuItem   = CreateMenuItem("&Работа с таблицами",true,TableMenuClick,"");
  aMenuItem[7] = WindowMenuItem  = CreateMenuItem("&Окна", false, NULL, "WindowMenu");
  aMenuItem[8] = HelpMenuItem    = CreateMenuItem("По&мощь", true, NULL, "HelpMenu");

  TMenuItem* EditMenuItem;                  
  TableMenuItem->Add(ReportMenuItem = CreateMenuItem("От&четы",true,ReportClick,""));
  TableMenuItem->Add(FilterMenuItem = CreateMenuItem("&Фильтры",true,FilterClick,""));
  TableMenuItem->Add(CreateMenuItem("Поиск записи",true,NULL,""));
  TableMenuItem->Add(CreateMenuItem("-",true,NULL,""));
  TableMenuItem->Add(EditMenuItem = CreateMenuItem("Редактирование &отчетов",true,FOnEditMenuItemClick,""));
  EditMenuItem->Checked=false;
  TableMenuItem->Add(EditMenuItem = CreateMenuItem("Редактирование &фильтров",true,FOnEditMenuItemClick,""));
  EditMenuItem->Checked=false;
//  TableMenuItem->Add(CreateMenuItem("-",true,NULL,""));

  TMenuItem* MI;
  ReportMenuItem->Add(MI=CreateMenuItem("Нет отчетов",false,NULL,""));
  MI->Visible=false;

  FilterMenuItem->Add(MI=CreateMenuItem("Нет фильтров",false,NULL,""));
  MI->Visible=false;

  MainMenuCount = ARRAYSIZE(aMenuItem);
  QuitMenuItem->ShortCut = TextToShortCut("F12");

  // Создаем меню
  MainMenu = NewMenu(this, "MainMenu", aMenuItem, MainMenuCount - 1);

  // Создаем описание подпунктов меню
  // Пункты меню сервис
  ServiseMenuItem->Add(UserMenuItem = CreateMenuItem("Меню", false, ShowPopup, "MenuMenu"));
  UserMenuItem->ShortCut = TextToShortCut("F10");
  ServiseMenuItem->Add(CreateSeparator());
//  ServiseMenuItem->Add(CreateMenuItem("Настройка пакета", true));

  // Пункты меню окна
  WindowMenuItem->Add(CreateMenuItem("Каскадом", true, CascadeMenu));
  WindowMenuItem->Add(CreateMenuItem("Равномерно", true, TileMenu));
  WindowMenuItem->Add(CreateMenuItem("Минимизировать", true, MinimizeCurrMenu));
  WindowMenuItem->Add(CreateMenuItem("Минимизировать все", true, MinimizeAllMenu));
  WindowMenuItem->Add(CreateMenuItem("Развернуть все", true, NormalAllMenu));
  WindowMenuItem->Add(CreateMenuItem("Закрыть", true, CloseCurrMenu));
  WindowMenuItem->Add(CreateMenuItem("Закрыть все", true, CloseAllMenu));

  // Пункты меню помощь
  HelpMenuItem->Add(HelpItem = CreateMenuItem("Помощь", true, HelpMenu));
  HelpItem->ShortCut = TextToShortCut("F1");
  HelpMenuItem->Add(CreateSeparator());
  HelpMenuItem->Add(AboutItem = CreateMenuItem("О программе", true, AboutMenu));

  TZPgSqlDatabase *Database;
  TZPgSqlTransact *Transaction;
//  TMemIniFile *IniStart=new TMemIniFile("startup.ini");

  AnsiString Path=StartupIniFile->ReadString("IniFiles","Path","WT.ini");
  GlobalIniFile=new TMemIniFile(Path);
  int Pos=Path.Length();
  while (Pos!=1 && Path[Pos]!='\\') Pos--;

  if (Pos==1) Pos--;
  Path=Path.SubString(Pos+1,Path.Length()-Pos+1);

  AnsiString FullPath=GetCurrentDir()+"\\"+Path;
  AnsiString rr= GlobalIniFile->FileName.LowerCase();
   AnsiString dd= FullPath.LowerCase();
  if (GlobalIniFile->FileName.LowerCase()==FullPath.LowerCase())
    IniFile=GlobalIniFile;
  else
    IniFile=new TMemIniFile(Path);

  AnsiString Alias=StartupIniFile->ReadString("Base","Alias","Base");
  AnsiString Host=StartupIniFile->ReadString("Base","Host","10.71.1.10");
  AnsiString Port=StartupIniFile->ReadString("Base","Port","5432");
  AnsiString Login=StartupIniFile->ReadString("Base","Login","");
  AnsiString Encoding=StartupIniFile->ReadString("Base","Encoding","osa");

  // ModalWindow=StartupIniFile->ReadString("ModalWindow","ModalWind",0);
  RestorePropertyFromIni();

//  delete IniStart;

  // Подключаемся к базе данных (TXO_SYS)
  try {
    Database = new TZPgSqlDatabase(Application);
   // Database->AliasName = Alias;
    Database->Database = Alias;
    Database->Name = "energo";
    if (Login.IsEmpty())
     Database->LoginPrompt = true;
    else
     Database->LoginPrompt = false;
    Database->Host = Host; //"10.71.1.10";  // Потом из ini
    Database->Port = Port;
    Database->Login=Login;
   // Database->Password="";
   if (Encoding=="etKoi8u")     Database->Encoding = etKoi8u;
   if (Encoding=="etKoi8r")     Database->Encoding = etKoi8r;
   if (Encoding=="etCp1250")    Database->Encoding = etCp1250;
   if (Encoding=="etCp1251")    Database->Encoding = etCp1251;
   if (Encoding=="win")    Database->Encoding = etCp1251;
   if (Encoding=="et866")    Database->Encoding = et866;
   if (Encoding=="etIso88592")    Database->Encoding = etIso88592;
     //    Database->Params->Add("USER NAME=txo");
//    Database->Params->Add("PASSWORD=loginTXO");
    //Database->SessionName = "Default";
    //Database->TransIsolation = tiDirtyRead;
       Database->Connect();
     //Transaction->Connect();
     Transaction = new TZPgSqlTransact(Application);
     Transaction->AutoCommit=false;
     Transaction->Database= Database;
     Transaction->AutoRecovery= false;
     Transaction->TransactSafe= false;
     Transaction->TransIsolation = ptRepeatableRead;
     Transaction->NewStyleTransactions =true;

    bool ii=Transaction->Connected;
     Transaction->Connect();
      ii=Transaction->Connected;
    //TWTQuery::Database = Database;
    TWTQuery::Transaction= Transaction;
    TWTQuery::Database = Database;
    //TWTTable::Database = Database;
    TWTTable::Transaction=Transaction;
    TWTTable::Database = Database;
    InterDatabase=Database;
    InterTransaction=Transaction;
  }
  catch (Exception &exception) {
    ShowMessage("Ошибка открытия базы " + Alias+".\nПрограмма завершает свое выполнение");
    exit(0);
//    throw(exception);
  }

  // Вот теперь мы уже существуем
  TWTForm::MainForm = this;

  //Создаем стандартную панель батонов
  TWTForm::MainCoolBar=new TWTCoolBar(this);
  MainCoolBar->Height=31;
  InsertControl(MainCoolBar);
  MainCoolBar->AutoSize=True;
  MainCoolBar->EdgeBorders=MainCoolBar->EdgeBorders >> ebBottom;
     /*
  MainToolBar=new TToolBar(this);
  MainToolBar->Flat=true;
  MainToolBar->BorderWidth=1;
  MainToolBar->Width=0;
  MainToolBar->Tag=0;

  WindowToolBar=new TWTToolBar(this);
  WindowToolBar->Flat=true;
  WindowToolBar->BorderWidth=1;
  WindowToolBar->Width=0;
  WindowToolBar->Tag=1;

  MainCoolBar->InsertControl(MainToolBar);
  MainCoolBar->Bands->Items[0]->Width = 0;
  MainCoolBar->Bands->Items[0]->MinWidth = 0;
  MainCoolBar->Bands->Items[0]->Break = false;

  MainCoolBar->InsertControl(WindowToolBar);
  MainCoolBar->Bands->Items[1]->Width = 0;
  MainCoolBar->Bands->Items[1]->MinWidth = 0;
  MainCoolBar->Bands->Items[1]->Break = false;
  MainCoolBar->Bands->Items[1]->Visible = false;

  ImageList1=new TCustomImageList(owner); */
//  Graphics::TBitmap *Bitmap1=new Graphics::TBitmap();
/*  Bitmap1->LoadFromResourceName(0,"Exit");
  ImageList1->Add(Bitmap1,NULL);*/

//  MainToolBar->Images=ImageList1;
//  WindowToolBar->Images=ImageList1;

  MainToolBar=new TWTToolBar(this);
  MainToolBar->Parent=MainCoolBar;
  MainToolBar->ID="Системные функции";

  ExitButton=MainToolBar->AddButton("Exit", "Выход", OnToolButton1Click);
  HelpButton=MainToolBar->AddButton("Help", "Помощь", HelpMenu);
  ScriptButton=MainToolBar->AddButton("ScriptEditor", "ScriptEditor", RunScriptEditor);

  ExitButton->ID="Exit";
  HelpButton->ID="Help";
  ScriptButton->ID="Script";

  MainCoolBar->AddToolBar(MainToolBar);

/*  //Добавляем батоны в стандартную панель
  ExitButton=AddButton("Exit", "Выход", OnToolButton1Click,0);
  HelpButton=AddButton("Help", "Помощь", HelpMenu,0);
  ScriptButton=AddButton("ScriptEditor", "ScriptEditor", RunScriptEditor,0);*/
//  AddButton("RWizard", "ReportWizard", ReportWizardClick,0);
//  AddButton("|", NULL, NULL,0);

  WindowToolBar=new TWTToolBar(this);
  WindowToolBar->Parent=MainCoolBar;
  WindowToolBar->ID="Работа с окнами";

  //Добавляем батоны для работы с окнами
  WindowToolBar->AddButton("CloseAll", "Закрыть все", CloseAllMenu);
  WindowToolBar->AddButton("Close", "Закрыть", CloseCurrMenu);
  WindowToolBar->AddButton("NormalAll", "Развернуть все", NormalAllMenu);
  WindowToolBar->AddButton("MiniAll", "Минимизировать все", MinimizeAllMenu);
  WindowToolBar->AddButton("Mini", "Минимизировать", MinimizeCurrMenu);
  WindowToolBar->AddButton("Tile", "Равномерно", TileMenu);
  WindowToolBar->AddButton("Cascade", "Каскадом", CascadeMenu);

  WindowToolBar->Parent=NULL;

/*  FilterTable=new TTable(this);
  FilterTable->DatabaseName = "DatabaseName";
  FilterTable->TableName = "Filter.db";
  FilterTable->Active = true;
  FilterTable->First();

  FilterSource=new TDataSource(this);
  FilterSource->DataSet=FilterTable;*/

  Options = Options << foHelp >> foScriptEditor << foExit;

  OnShowActiveWindows=NULL;
  TForm::OnShow=OnShowMainForm;

}
//---------------------------------------------------------------------
_fastcall TWTMainForm::~TWTMainForm() {
  StartupIniFile->EraseSection("ActiveWindows");
  for (int x=0;x<MDIChildCount;x++) {
    if (CheckParent(MDIChildren[x],"TWTMDIWindow")) {
      StartupIniFile->WriteString("ActiveWindows",((TWTMDIWindow*)MDIChildren[x])->ID,"");
    }
  }
  if (Screen->ActiveForm!=NULL)
  {
   if (CheckParent(Screen->ActiveForm,"TWTMDIWindow")) {
     StartupIniFile->WriteString("Data","ActiveWindow",((TWTMDIWindow*)Screen->ActiveForm)->ID);
     StartupIniFile->WriteString("Data","WindowState",((TWTMDIWindow*)Screen->ActiveForm)->WindowState);
   }
  }
// Перед удалением родительской формы удаляем все дочерние
//  delete TPComp;
  for (int i=MDIChildCount-1; i >= 0; i--) {
    delete MDIChildren[i];
  }
  delete Registry;
  if (IniFile==GlobalIniFile) delete IniFile;
  else {
    if (IniFile) delete IniFile;
    if (GlobalIniFile) {
      delete GlobalIniFile;
    }
  }
  SavePropertyToIni();
}

void __fastcall TWTMainForm::OnShowMainForm(TObject *Sender){
  TStringList *SL=new TStringList();
  StartupIniFile->ReadSection("ActiveWindows",SL);
  if (OnShowActiveWindows) OnShowActiveWindows(SL);
  delete SL;
}

void __fastcall TWTMainForm::SavePropertyToIni(){
//  TMemIniFile *IniStart=new TMemIniFile("startup.ini");
  if (StartupIniFile->ReadBool("Data","SaveEnvironment",0)) {
    StartupIniFile->WriteBool("Data","EditReport",TableMenuItem->Items[4]->Checked);
    StartupIniFile->WriteBool("Data","EditFilter",TableMenuItem->Items[5]->Checked);
  }
  StartupIniFile->UpdateFile();
//  delete IniStart;
}

void __fastcall TWTMainForm::RestorePropertyFromIni(){
//  TMemIniFile *IniStart=new TMemIniFile("startup.ini");
  if (StartupIniFile->ReadBool("Data","SaveEnvironment",0)) {
    TableMenuItem->Items[4]->Checked=StartupIniFile->ReadBool("Data","EditReport",false);
    TableMenuItem->Items[5]->Checked=StartupIniFile->ReadBool("Data","EditFilter",false);
  }
//  delete IniStart;
}

TWTWinDBGrid* __fastcall TWTMainForm::ShowBrowse(AnsiString ID){
  if (Registry->ItemByID(ID)==NULL) return NULL; //Unknown ID;
  if (Registry->ItemByID(ID)->ItemType!=riBrowse) return NULL; //Not allowed type
  TWTBrowseRegItem *BI=(TWTBrowseRegItem*)Registry->ItemByID(ID);
  if (BI->Browses->Count)
    if (((TForm*)BI->Browses->Items[0])->Enabled) {
       ((TForm*)BI->Browses->Items[0])->Show();
       return (TWTWinDBGrid*)BI->Browses->Items[0];
    }

  TWTWinDBGrid *WDB;
  TWTTable *Table;
  if (BI->TableName!="") {
    WDB = new TWTWinDBGrid(this, BI->TableName);
    Table=WDB->DBGrid->Table;
  }

  for (int x=0;x<BI->FieldsInfo->Count;x++) {
    Table->AddLookupField(BI->FieldsInfo->Get(x)->FName,BI->FieldsInfo->Get(x)->KeyField,BI->FieldsInfo->Get(x)->LookupTableName,BI->FieldsInfo->Get(x)->LookupFName);//,BI->FieldsInfo->Get(x)->LookupKeyFields);
  }
  Table->Open();
  WDB->SetCaption(BI->Caption);
  TWTRegCol* RC;
  TWTField *Field;
  for (int x=0;x<BI->ColsInfo->Count;x++) {
    RC=BI->ColsInfo->Get(x);
    Field=WDB->AddColumn(RC->Name, RC->Label, RC->FullLabel);
    if (RC->IsUnique) Field->SetUnique(RC->TableName,RC->UniqueError);
    if (RC->IsRange) Field->SetRange(RC->MinValue,RC->MaxValue,RC->RangeError);
    if (RC->IsFixedVariables) {
      for (int y=0;y<RC->FixedVariables->Count;y++) {
        Field->AddFixedVariable(RC->FixedVariables->GetVariable(y)->DBValue,RC->FixedVariables->GetVariable(y)->RealValue);
      }
    }
    if (RC->IsValue) Field->SetDefValue(RC->Value);
    if (RC->IsRequired) Field->SetRequired(RC->RequiredError);
    if (RC->IsFill) Field->SetFill(RC->FillSize,RC->FillChar);
    Field->SetOnHelp(RC->OnHelp);
  }
  WDB->StatusBar->SimplePanel= true;
  WDB->StatusBar->SimpleText= WDB->List->Items->Strings[0];
  WDB->DBGrid->SetFocus();
  WDB->RegItem=BI;
  BI->Browses->Add(WDB);
  return WDB;
}

//---------------------------------------------------------------------
void __fastcall TWTMainForm::InitMenu() {
}
//---------------------------------------------------------------------
int __fastcall TWTMainForm::ShowMDIChild(AnsiString Name,TComponent *Owner) {
int i = 0;

  while (i < MDIChildCount && (Owner!=NULL && MDIChildren[i]->Owner != Owner || MDIChildren[i]->Caption != Name)) i++;
  if (i == MDIChildCount) {
    i=0;
//    while (i < MDIChildCount && (Owner!=NULL && MDIChildren[i]->Owner != Owner || ((TWTMDIWindow*)MDIChildren[i])->ID != Name)) i++;
    while (i < MDIChildCount )
    {
     if (CheckParent(MDIChildren[i],"TWTMDIWindow"))
     {
      if (Owner!=NULL && MDIChildren[i]->Owner != Owner || ((TWTMDIWindow*)MDIChildren[i])->ID != Name)
       i++;
      else break;
     }
     else i++;
    }
  }

  if (i < MDIChildCount) {
    if (MDIChildren[i]->Enabled)
      MDIChildren[i]->Show();
    return 1;
  }
  else {
    return 0;
  }
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::FOnActiveFormChange(TObject *Sender) {
  // Пункт "Окна" активизируем если есть окна
  if (DialogCount) WindowMenuItem->Enabled=false;
  else WindowMenuItem->Enabled = MDIChildCount > 0;
  OnActiveMainFormChange();
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::ShowHint(TObject *Sender) {
//  StatusBar->SimpleText = Application->Hint;
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::CascadeMenu(TObject *Sender) {
  Cascade();
}
//---------------------------------------------------------------------
void __fastcall TWTMainForm::OnClose(TObject *Sender) {
  // Перед выходом закрываем все окна
//  for (int i=MDIChildCount-1; i >= 0; i--) {
//    MDIChildren[i]->Close();
//  }
}
//---------------------------------------------------------------------
void __fastcall TWTMainForm::OnClose(TObject *Sender, TCloseAction &Action){
  if (DialogCount) {
    ShowMessage("Для выхода закройте все диалоговые окна.");
    Action=caNone;
  }
  else
    if (Application->MessageBox("Вы хотите выйти из программы?","Выход из программы",MB_YESNO)==IDYES) {
     for (int i=MDIChildCount-1; i >= 0; i--) {
      MDIChildren[i]->Close();
      }
      Action=caFree;
      TSearchRec SR;
      //ShowMessage("L");
      int Flag=FindFirst("Del*.MB",faAnyFile,SR);
      for (int x=0;x<4;x++) {
        while (!Flag) {
          DeleteFile(SR.Name);
          Flag=FindNext(SR);
        }
        if (x==0) Flag=FindFirst("_qsq*.db",faAnyFile,SR);
        if (x==1) Flag=FindFirst("Del*.DB",faAnyFile,SR);
        if (x==1) Flag=FindFirst("_qsq*.mb",faAnyFile,SR);
      }
      //ShowMessage("L1");
    }
    else Action=caNone;
}


//---------------------------------------------------------------------
void _fastcall TWTMainForm::TileMenu(TObject *Sender) {
  Tile();
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::MinimizeCurrMenu(TObject *Sender) {
  if (ActiveMDIChild)
    ActiveMDIChild->WindowState = wsMinimized;
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::MinimizeAllMenu(TObject *Sender) {
  for (int i=MDIChildCount-1; i >= 0; i--) {
    MDIChildren[i]->WindowState = wsMinimized;
  }
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::NormalAllMenu(TObject *Sender) {
  for (int i = 0; i<MDIChildCount; i++) {
    MDIChildren[i]->WindowState = wsNormal;
  }
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::CloseCurrMenu(TObject *Sender) {
  if (ActiveMDIChild)
    ActiveMDIChild->Close();
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::CloseAllMenu(TObject *Sender) {
  for (int i=MDIChildCount-1; i >= 0; i--) {
    MDIChildren[i]->Close();
  }
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::HelpMenu(TObject *Sender) {
  ShowMessage("Помощь еще не написана");
};

//---------------------------------------------------------------------
void _fastcall TWTMainForm::AboutMenu(TObject *Sender) {
  TWTAboutBox * AboutBox = new TWTAboutBox(this);
  AboutBox->ShowModal();
  AboutBox->Close();
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::CloseMainForm(TObject *Sender) {
  // Пока только закрываем
  Close();
}

void _fastcall TWTMainForm::LoadReport(TObject* Sender){
  if (CheckParent(Screen->ActiveControl,"TWTDBGrid")) {
    ((TWTDBGrid*)Screen->ActiveControl)->ReportPrint(((TMenuItem*)Sender)->Caption+IntToStr(((TMenuItem*)Sender)->Tag));
  }
}

void _fastcall TWTMainForm::LoadFilter(TObject* Sender){
  if (CheckParent(Screen->ActiveControl,"TWTDBGrid")) {
    //((TWTWinDBGrid*)Screen->ActiveControl)->FilterPrint(((TMenuItem*)Sender)->Caption);

      ((TWTDBGrid*)Screen->ActiveControl)->FilterPrint(((TMenuItem*)Sender)->Caption);

  }
}


void _fastcall TWTMainForm::TableMenuClick(TObject* Sender){
  TWTDBGrid* DBGrid;
  if (Screen->ActiveControl) {
    if (CheckParent(Screen->ActiveControl,"TWTDBGrid")) {
      DBGrid=(TWTDBGrid*)Screen->ActiveControl;
      for (int x=0;x<TableMenuItem->Count;x++) {
        if (TableMenuItem->Items[x]->Caption=="Поиск записи") {
          TableMenuItem->Items[x]->Enabled=true;
          TableMenuItem->Items[x]->OnClick=DBGrid->SearchMenu;
          return;
        }
      }
    }
  }
  for (int x=0;x<TableMenuItem->Count;x++) {
    if (TableMenuItem->Items[x]->Caption=="Поиск записи") {
      TableMenuItem->Items[x]->Enabled=false;
      TableMenuItem->Items[x]->OnClick=NULL;
      break;
    }
  }
}


void _fastcall TWTMainForm::ReportClick(TObject* Sender){

  TMenuItem *MI;
  TWTDBGrid* DBGrid;
  TStringList *Names=new TStringList();
  while (ReportMenuItem->Count!=1) {
    ReportMenuItem->Delete(0);
  }
  if (ActiveMDIChild) {
    if (CheckParent(Screen->ActiveControl,"TWTDBGrid")) {
      DBGrid=(TWTDBGrid*)Screen->ActiveControl;
      DBGrid->GetGlobalReportsNames(Names);

      //Graphics::TBitmap* BM;

      for (int x=0;x<Names->Count;x++) {
        MI=CreateMenuItem(Names->Strings[x].c_str(),true,LoadReport,"");
        MI->Bitmap->LoadFromResourceName(0,"GReport");
        MI->Tag=0;
        ReportMenuItem->Insert(ReportMenuItem->Count-1,MI);
      }
      int CC=Names->Count;
      Names->Clear();

      if (IniFile!=GlobalIniFile) DBGrid->GetReportsNames(Names);
      if (Names->Count && CC) {
        MI=CreateMenuItem("-",true,NULL,"");
        ReportMenuItem->Insert(ReportMenuItem->Count-1,MI);
      }
      for ( int x=0;x<Names->Count;x++) {
        MI=CreateMenuItem(Names->Strings[x].c_str(),true,LoadReport,"");
        MI->Bitmap->LoadFromResourceName(0,"Report");
        MI->Tag=1;
        ReportMenuItem->Insert(ReportMenuItem->Count-1,MI);
      }
      if (Names->Count || CC) {
        ReportMenuItem->Items[ReportMenuItem->Count-1]->Visible=false;
        delete Names;
        return;
      }
    }
  }
  ReportMenuItem->Items[ReportMenuItem->Count-1]->Visible=true;
  delete Names;
}
//---------------------------------------------------------------------
void _fastcall TWTMainForm::FilterClick(TObject* Sender){

  TMenuItem *MI;
  TWTDBGrid* DBGrid;
  TStringList *Names=new TStringList();
  for (int x=0;x<FilterMenuItem->Count-1;x++) {
    FilterMenuItem->Delete(0);
  }
  if (ActiveMDIChild) {
    if (CheckParent(Screen->ActiveControl,"TWTDBGrid")) {
      DBGrid=(TWTDBGrid*)Screen->ActiveControl;
      DBGrid->GetFiltersNames(Names);

      // Graphics::TBitmap* BM;

      for (int x=0;x<Names->Count;x++) {

        MI=CreateMenuItem(Names->Strings[x].c_str(),true,LoadFilter,"");
        MI->Bitmap->LoadFromResourceName(0,"Filter");
        FilterMenuItem->Insert(FilterMenuItem->Count-1,MI);
      }
      if (Names->Count) {
        FilterMenuItem->Items[FilterMenuItem->Count-1]->Visible=false;
        delete Names;
        return;
      }
    }
  }
  FilterMenuItem->Items[FilterMenuItem->Count-1]->Visible=true;
  delete Names;

}



void __fastcall TWTMainForm::FOnEditMenuItemClick(TObject* Sender) {
  ((TMenuItem*)Sender)->Checked=!((TMenuItem*)Sender)->Checked;
}

void __fastcall TWTMainForm::RunScriptEditor(TObject* Sender) {
//  ScriptForm=new TWTScriptForm(this);
//  ScriptForm->FormStyle=fsMDIChild;
//  ScriptForm->TPComp=TPComp;
}

/*TWTFunc* __fastcall TWTMainForm::RegisterFunc(AnsiString Name,TWTFuncEvent Event){
TWTFunc *Func=TPComp->Analizer->Generator->FuncList->AddFunc(Name,0);
  if (Func) Func->EventOnCall=Event;
  return Func;

}*/

void __fastcall TWTMainForm::SayCompError(int ErrorNum){
//  TPComp->Analizer->Generator->ErrorCode=ErrorNum;
}

/*TWTValue* __fastcall TWTMainForm::MakeRegFunction(TStringList *MultiVars,int ParamCount,TWTValue *Param[100]){
  TWTRegItem *RI=Registry->ItemByID(MultiVars->Strings[0]);
  if (!RI) {
    SayCompError(320);
    return SimpleVal(0);
  }
  if (MultiVars->Count==2) {
    if ((MultiVars->Strings[1]=="Show") && (RI->ItemType==riBrowse)) {
      ShowBrowse(MultiVars->Strings[0]);
      return SimpleVal(0);
    }
  }
  MultiVars->Delete(0);
  TWTValue *Value=NULL;
  int Error=RI->MakeRegFunction(MultiVars,ParamCount,Param,Value);
  if (Error) {
    SayCompError(322);
    return SimpleVal(0);
  }
  else return Value;
  SayCompError(322);
  return SimpleVal(0);
} */

/*TWTValue* __fastcall TWTMainForm::FindRegValue(TStringList *MultiVars){
  TWTRegItem *RI=Registry->ItemByID(MultiVars->Strings[0]);
  if (!RI) return NULL;
  MultiVars->Delete(0);
  return RI->FindParamValue(MultiVars);
} */

/*int __fastcall TWTMainForm::SetRegValue(TStringList *MultiVars,TWTValue *Value){
  TWTRegItem *RI=Registry->ItemByID(MultiVars->Strings[0]);
  if (!RI) return 320;  //неверный идентификатор
  MultiVars->Delete(0);
  return RI->SetParamValue(MultiVars,Value);
} */

/*int __fastcall TWTMainForm::CheckParams(TStringList *MultiVars,int ParamCount,TWTValueStack *Params){
  TWTRegItem* RI=Registry->ItemByID(MultiVars->Strings[0]);
  AnsiString MultiName="";
  if (MultiVars->Count!=1) MultiName=IntToStr(RI->ItemType)+".";
  for (int x=1;x<MultiVars->Count-1;x++) MultiName=MultiName+MultiVars->Strings[x]+".";
    MultiName+=MultiVars->Strings[MultiVars->Count-1];
  TWTFunc *Func=TPComp->Analizer->Generator->FuncList->FuncByName(MultiName);
  if (Func==NULL) return 304;
  int Cnt=Func->ParamCount;
  if (Func->ParamCount!=255) {
     if (Func->ParamCount!=ParamCount) {return 306;} //несоответствие количества параметров
     for (int x=Cnt-1;x>=0;x--) {
       int TT=Params->GetItem(x)->Value[0].Type();
       switch (Func->ParamType[Cnt-1-x]) {
       case 0: {
         break;
       }
       case 1: {
         if ((TT<1) || ((TT>6) && (TT!=11))) return 302; //несоответствие типов
         break;
       }
       case 2: {
         if (TT!=varString) return 302; //несоответствие типов
         break;
       }
       }
     }
  }
  return 0;
} */

void __fastcall TWTMainForm::SetOptions(TWTMainFormOptions Value){
  FOptions=Value;
  if (Value.Contains(foExit)) {
    MainToolBar->ShowButton("Exit");
    QuitMenuItem->Visible=true;
  }
  else {
    MainToolBar->HideButton("Exit");
    QuitMenuItem->Visible=false;
  }

  if (Value.Contains(foHelp)) {
    MainToolBar->ShowButton("Help");
    HelpMenuItem->Visible=true;
  }
  else {
    MainToolBar->HideButton("Help");
    HelpMenuItem->Visible=false;
  }

  if (Value.Contains(foScriptEditor)) {
    MainToolBar->ShowButton("Script");
  }
  else {
    MainToolBar->HideButton("Script");
  }

}
    /*
void __fastcall TWTMainForm::SetMainIniFile(AnsiString Value){
  FMainIniFile=Value;
  IniFile=new TMemIniFile(Value);
  TStringList* Sections=new TStringList();

  Graphics::TBitmap *BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Report");

  TMenuItem* MI;
  if (ReportMenuItem->Count>1){
    for (int x=0;x<ReportMenuItem->Count-1;x++) ReportMenuItem->Delete(0);
  }
  IniFile->ReadSection("ReportsID",Sections);
  for (int x=0;x<Sections->Count;x++) {
    ReportMenuItem->Insert(0,MI=CreateMenuItem(Sections->Strings[x].c_str(),true,LoadReport,""));
    MI->Bitmap=BM;
  }

  BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"FilterM");

  if (FilterMenuItem->Count>1){
    for (int x=0;x<FilterMenuItem->Count-1;x++) FilterMenuItem->Delete(0);
  }
  IniFile->ReadSection("FiltersID",Sections);
  for (int x=0;x<Sections->Count;x++) {
    FilterMenuItem->Insert(0,MI=CreateMenuItem(Sections->Strings[x].c_str(),true,LoadFilter,""));
    MI->Bitmap=BM;
  }
}

      */
void __fastcall TWTMainForm::Status(AnsiString Text) {
  if (Text != NULL) {
    StatusBar->SimplePanel = true;
    StatusBar->SimpleText = Text;
  }
  else {
    StatusBar->SimplePanel = false;
  }
}

//---------------------------------------------------------------------
// AbsentAct
//   0 - Сформировать строку, проверить наличие таблицы, если отсутствует создать
//   1 - Сформировать строку и проверить наличие таблицы
//   2 - Сформировать строку
// При возникновении ошибки возвращает ""
//---------------------------------------------------------------------
AnsiString __fastcall TWTMainForm::CreateFullTableName(AnsiString Name, TDateTime *DatePar,
      AnsiString Str1, AnsiString Str2, AnsiString Str3, int AbsentAct) {
AnsiString FullName = Name;
// char Buf[1000];
int Pos;
static TWTQuery *QueryTmp = NULL, *QueryIndex;
static TWTTable *TableTmp;
//static TDateTime *DatePath;

  if (!QueryTmp) {
    QueryTmp = new TWTQuery(Application);
    QueryIndex = new TWTQuery(Application);
    TableTmp = new TWTTable(Application, "");
   // DatePath = new TDateTime();
  }
  // Параметры по умолчанию
  /*if (DatePar)
   *DatePath = *DatePar;
  else
    *DatePath = Date();
    */
  QueryIndex->Sql->Clear();
  QueryIndex->Sql->Add("SELECT id,tbl_name,path,sql_create,name FROM adi_table_tbl WHERE tbl_name = " + ToStrSQL(Name));
 // QueryIndex->Sql->Add("  ORDER BY INDEX_NUM");
//  QueryIndex->Database=MainForm->Database;
 // QueryIndex->Transaction=MainForm->Transaction;
  QueryIndex->Open();
  Application->ProcessMessages();

  QueryIndex->First();
  // Вычисляем полное имя
  if (!QueryIndex->FieldByName("PATH")->AsString.IsEmpty()) {
    FullName = QueryIndex->FieldByName("PATH")->AsString;
    // Преобразуем дату
    /*while ((Pos = FullName.Pos("%yyyy")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + FormatDateTime("yyyy", *DatePath) + FullName.SubString(Pos + 5, 1000);
    while ((Pos = FullName.Pos("%yy")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + FormatDateTime("yy", *DatePath) + FullName.SubString(Pos + 3, 1000);
    while ((Pos = FullName.Pos("%mm")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + FormatDateTime("mm", *DatePath) + FullName.SubString(Pos + 3, 1000);
    while ((Pos = FullName.Pos("%m")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + FormatDateTime("m", *DatePath) + FullName.SubString(Pos + 2, 1000);
    while ((Pos = FullName.Pos("%dd")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + FormatDateTime("dd", *DatePath) + FullName.SubString(Pos + 3, 1000);
    while ((Pos = FullName.Pos("%d")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + FormatDateTime("d", *DatePath) + FullName.SubString(Pos + 2, 1000);
*/    // Проверяем наличие строковых параметров в имени
    if ((Pos = FullName.Pos("%1")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + Str1 + FullName.SubString(Pos + 2, 1000);
    if ((Pos = FullName.Pos("%2")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + Str2 + FullName.SubString(Pos + 2, 1000);
    if ((Pos = FullName.Pos("%3")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + Str3 + FullName.SubString(Pos + 2, 1000);
    if ((Pos = FullName.Pos("%s")) != 0)
      FullName = FullName.SubString(0, Pos - 1) + Name + FullName.SubString(Pos + 2, 1000);
  }
  else {
    FullName = Name;
  }

  if (AbsentAct == 2)
    return FullName;

  // Проверим наличие таблицы
  try {
    TableTmp->TableName = FullName;
    TableTmp->Active = true;
    TableTmp->Close();
  }
  catch (Exception &e) {
    // Проверить тип ошибки !!!

    if (AbsentAct == 1)
      return "";

    // Таблица отсутствует - создаем
    if ((Pos = FullName.Pos("\\")) != 0) {
      // Таблица находится в подкаталоге
      AnsiString Path = FullName;
      Pos = Path.Length() - 1;
      while (Path[Pos] != '\\' && Pos > 0) Pos--;
      Path.SetLength(Pos);
      DBDesc pdbDesc;
      DbiGetDatabaseDesc(TWTQuery::Database->Name.c_str(), &pdbDesc);
      Path = AnsiString(pdbDesc.szPhyName) + "\\" + Path;
      MkDirPath(Path.c_str());
    }

    QueryTmp->Sql->Clear();
    QueryTmp->Sql->Add("CREATE TABLE " + ToStrSQL(FullName) + " (");
    QueryTmp->Sql->Add(QueryIndex->FieldByName("SQL_CREATE")->AsString);
    QueryTmp->Sql->Add(")");
//    SaveMessage("Создаем таблицу", QueryTmp->SQL->Text.c_str());
    QueryTmp->ExecSql();
    Application->ProcessMessages();

    while (!QueryIndex->Eof) {
      if (!QueryIndex->FieldByName("INDEX_NAME")->AsString.IsEmpty()) {
        QueryTmp->Sql->Clear();
        QueryTmp->Sql->Add(" CREATE INDEX " + QueryIndex->FieldByName("INDEX_NAME")->AsString);
        QueryTmp->Sql->Add(" ON " + ToStrSQL(FullName));
        QueryTmp->Sql->Add(QueryIndex->FieldByName("INDEX_FIELD")->AsString);
        QueryTmp->ExecSql();
      }
      QueryIndex->Next();
      Application->ProcessMessages();
    }
    QueryIndex->Close();
  }
  return FullName;
}



//программный реестр

TWTValue* __fastcall TWTRegItem::FindParamValue(TStringList *MultiVars){
  if (MultiVars->Count!=1) return NULL;
//  if (MultiVars->Strings[0]=="ID") return SimpleVal(ID);
  return NULL;
}

int __fastcall TWTRegItem::SetParamValue(TStringList *MultiVars,TWTValue *Value){
  if (MultiVars->Count!=1) return 322; //неверная ссылка
//  if ((Value->XDim!=1) && (Value->YDim!=1)) return 302;  //несоответствие типов
  try {
    if (MultiVars->Strings[0]=="ID") return 321; //параметр ReadOnly
  } catch (...) {
    return 302;
  }
  return 314;
}

int __fastcall TWTRegItem::MakeRegFunction(TStringList *MultiVars,int ParamCount,TWTValue *Param[100],TWTValue *ReturnValue){
  return 322;
}


__fastcall TWTRegCol::~TWTRegCol() {
  if (FixedVariables) delete FixedVariables;
}

__fastcall TWTRegColsList::~TWTRegColsList(){
  for (int x=0;x<Count;x++) delete (TWTRegCol*)Items[x];
}

int TWTRegCol::SetUnique(AnsiString TableName,AnsiString ErrorString){
  IsUnique=true;
  TWTRegCol::TableName=TableName;
  UniqueError=ErrorString;
  return 0;
}

int TWTRegCol::SetRange(Variant& Min,Variant& Max,AnsiString ErrorString){
  RangeError=ErrorString;
  IsRange=true;
  MinValue=Min;
  MaxValue=Max;
  return 0;
}

int TWTRegCol::AddFixedVariable(AnsiString DBValue,AnsiString RealValue){
  if (FixedVariables==NULL) FixedVariables=new TWTFixedVariables();
  IsFixedVariables=true;
  return FixedVariables->Add(DBValue,RealValue);
}

int TWTRegCol::SetDefValue(Variant& Value){
  TWTRegCol::Value=Value;
  IsValue=true;
  return 0;
}

int TWTRegCol::SetRequired(AnsiString ErrorString){
  IsRequired=true;
  RequiredError=ErrorString;
  return 0;
}

int TWTRegCol::SetFill(int FillSize,char FillChar){
  IsFill=true;
  TWTRegCol::FillSize=FillSize;
  TWTRegCol::FillChar=FillChar;
  return 0;
}

void TWTRegCol::SetOnHelp(TTEventField FOnHelp){
  OnHelp=FOnHelp;
}

__fastcall TWTBrowseRegItem::TWTBrowseRegItem(AnsiString ItemID) : TWTRegItem() {
  Browses=new TList();
  ItemType=riBrowse;
  ID=ItemID;
  Caption="";
  TableName="";
  SQL=new TStringList();
  ColsInfo=new TWTRegColsList();
}

__fastcall TWTBrowseRegItem::TWTBrowseRegItem(AnsiString ItemID,AnsiString TableName) : TWTRegItem() {
  Browses=new TList();
  ItemType=riBrowse;
  ID=ItemID;
  Caption="";
  TWTBrowseRegItem::TableName=TableName;
  SQL=new TStringList();
  ColsInfo=new TWTRegColsList();
  FieldsInfo=new TWTRegFieldsList();
}

__fastcall TWTBrowseRegItem::~TWTBrowseRegItem(){
  delete Browses;
  delete SQL;
  delete ColsInfo;
  delete FieldsInfo;
}

TWTValue* __fastcall TWTBrowseRegItem::FindParamValue(TStringList *MultiVars){
  TWTValue *Val=TWTRegItem::FindParamValue(MultiVars);
  if (Val!=NULL) return Val;
  switch (MultiVars->Count) {
    case 1: {
//      if (MultiVars->Strings[0]=="Caption") return SimpleVal(Caption);
//      if (MultiVars->Strings[0]=="TableName") return SimpleVal(TableName);
    }
    case 2: {
      if (MultiVars->Strings[0]=="Fields") {
//        if (Browses->Count<1) return SimpleVal(0);
        TWTWinDBGrid* WDB=(TWTWinDBGrid*)Browses->Items[0];
        if (WDB->DBGrid->Table) {
//          return SimpleVal(WDB->DBGrid->Table->FieldByName(MultiVars->Strings[1])->AsVariant);
        } else {
//          return SimpleVal(WDB->DBGrid->Table->FieldByName(MultiVars->Strings[1])->AsVariant);
        }
      }
    }
  }
  return NULL;
}

int __fastcall TWTBrowseRegItem::SetParamValue(TStringList *MultiVars,TWTValue *Value){
  int Error=TWTRegItem::SetParamValue(MultiVars,Value);
  if ((Error==321) || (!Error)) return Error;
//  if ((Value->XDim!=1) && (Value->YDim!=1)) return 302;  //несоответствие типов

  try {
    switch (MultiVars->Count) {
      case 1: {
        if (MultiVars->Strings[0]=="Caption") {
//          Caption=Value->Value[0];
          return 0;
        }
        if (MultiVars->Strings[0]=="TableName") {
//          TableName=Value->Value[0];
          return 0;
        }
      }
      case 2: {
        if (MultiVars->Strings[0]=="Fields") {
          if (Browses->Count<1) return 0;
          TWTWinDBGrid* WDB=(TWTWinDBGrid*)Browses->Items[0];
          if (WDB->DBGrid->Table) {
            WDB->DBGrid->Table->Edit();
//            WDB->DBGrid->Table->FieldByName(MultiVars->Strings[1])->AsVariant=Value->Value[0];
            WDB->DBGrid->Table->Post();
          } else {
            WDB->DBGrid->Query->Edit();
//            WDB->DBGrid->Query->FieldByName(MultiVars->Strings[1])->AsVariant=Value->Value[0];
            WDB->DBGrid->Query->Post();
          }
          return 0;
        }
      }
    }
  } catch (...) {
    return 302;
  }

  return 314;
}

int __fastcall TWTBrowseRegItem::MakeRegFunction(TStringList *MultiVars,int ParamCount,TWTValue *Param[100],TWTValue *ReturnValue){
  switch (MultiVars->Count) {
    case 0:{

      break;
    }
    case 1:{

      break;
    }
  };
  return 0;
}

TWTRegCol* TWTBrowseRegItem::AddColumn(AnsiString Name, AnsiString Label, AnsiString FullLabel){
  TWTRegCol *RC=new TWTRegCol();
  RC->Name=Name;
  RC->Label=Label;
  RC->FullLabel=FullLabel;

  ColsInfo->Add(RC);

  return RC;
}

TWTRegField *TWTBrowseRegItem::AddLookupField(AnsiString FName,AnsiString KeyField,AnsiString LookupTableName,AnsiString LookupFName){
  TWTRegField *RF=new TWTRegField();
  RF->FName=FName;
  RF->KeyField=KeyField;
  RF->LookupTableName=LookupTableName;
  RF->LookupFName=LookupFName;
  FieldsInfo->AddField(RF);
  return RF;
}

__fastcall TWTRegistry::~TWTRegistry(){
  for (int x=0;x<Count;x++) delete (TWTRegItem*)Items[x];
}

TWTRegItem* TWTRegistry::ItemByID(AnsiString ID){
  for (int x=0;x<Count;x++)
    if (Get(x)->ID==ID)
      return Get(x);
  return NULL;
}

int TWTRegistry::AddItem(TWTRegItem* RI) {
  if (ItemByID(RI->ID)) {
    ShowMessage("Дублирование уникальных идентификаторов реестра");
    return -1;
  }
  Add(RI);
  return Count-1;
}




