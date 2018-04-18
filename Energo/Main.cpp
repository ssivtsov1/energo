//----------------------------------------l-----------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"
//#include "docu.h"
//#include "docu_mod.h"
//#include "move.h"
#include "SysVarM.h"
#include "CliSald.h"
#include "SysVers.h"
#include "FOpenMonthM.h"
#include "fLogin.h"
#include "fCalendar.h"
#include "SysUser.h"
#include "SysUserPwdF.h"
#include "SysBase.h"
#include "FormFtp.h"
#include <string.h>
#include <stdio.h>
#include <stdio.h>

int Version=304;

//#define Lite
//---------------------------------------------------------------------
// функции класса TMainForm
//---------------------------------------------------------------------
_fastcall TMainForm::TMainForm(TComponent *owner) : TWTMainForm(owner) {

  // Читаем имя пользователя
  //fLog=new TfLog(this);
  IDUser = IniFile->ReadString("IDUser", "Name", "User");

  int only_one = StartupIniFile->ReadInteger("Base","OneInstance",1);
  hInstanceMutex = NULL;

    hInstanceMutex = ::CreateMutex(NULL,TRUE, "ENERGO.MUTEX");
    if(GetLastError() == ERROR_ALREADY_EXISTS)
    {
      if (only_one)
      {

        if(hInstanceMutex)
        {
            CloseHandle(hInstanceMutex);
            hInstanceMutex = NULL;
        }

     //   ShowMessage("Программа Енерго уже запущена!");
   /*     Application->Terminate();
        return;  */
      }

    }


  On_Start_Programm();
    Screen->Cursors[crSQLWait]   = Screen->Cursors[crDefault]; 
  OnShowActiveWindows= ShowActiveWindows;
   TMenuItem* OPL;
   OPL=new TMenuItem(this);
   OPL->Caption="111";
  AnsiString  Period=GetValueFromBase("select value_ident from syi_sysvars_tmp where ident='mmgg'");

}



_fastcall TMainForm::~TMainForm(){
    if (hInstanceMutex)
    {
     ReleaseMutex(hInstanceMutex);
     CloseHandle(hInstanceMutex);
    } 
}

 void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs){
     TWTQuery *QCh=new TWTQuery (this);
    QCh->Sql->Clear();
   QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='mmgg'");
   QCh->Open();
     AnsiString  Period=QCh->FieldByName("value_ident")->AsString;
     ((TMainForm*)Application->MainForm)->MFPeriod=Period;
   Application->MainForm->Caption = "Енергия --- Юридические лица         "+((TMainForm*)Application->MainForm)->MFPeriod  +"          "  +((TMainForm*)Application->MainForm)->MFname_base;

    AnsiString Prompt=StartupIniFile->ReadString("Base","PromptLogin","0");

    if (Prompt=="1")
    {
     Application->CreateForm(__classid(TfBaseLogin), &fBaseLogin);
       fBaseLogin->Show();
       /*Application->CreateForm(__classid(TfUserLogin), &fUserLogin);
       fUserLogin->ShowModal();
       On_Start_Programm(); */
     }
     else
      {

       Application->CreateForm(__classid(TfUserLogin), &fUserLogin);
        fUserLogin->ShowModal();

      };
   // Инициализацию меню перенес после окна логина, чтобы учесть права текущего юзера
 // Добавляем пункты меню
 // Клиент
       TWTQuery *QueryT = new  TWTQuery(this);
    QueryT->Sql->Clear();
      QueryT->Sql->Add("select sys_fill_full_lvl()");
    QueryT->ExecSql();
    QueryT->Sql->Clear();
    QueryT->Sql->Add("select value_ident from syi_sysvars_tbl where ident='flag_main'");
    QueryT->Open();
    int flag_main;
    if (QueryT->Eof)
     flag_main=-1;
    else
     if (QueryT->Fields->Fields[0]->AsInteger==1)
        flag_main=1;
     else
        flag_main=0;

    InDocMenuItem->Add(CreateMenuItem("Список клиентов", CheckLevel("Меню -1 Список клиентов")!=0, CliClientMBtn));
     InDocMenuItem->Add(CreateSeparator());
     InDocMenuItem->Add(CreateMenuItem("Банковские документы", CheckLevel("Меню - 1 Банковские документы")!=0, AciHeadPayBtn));
     InDocMenuItem->Add(CreateMenuItem("Журнал налоговых накладных", CheckLevel("Меню - 1 Журнал налоговых накладных")!=0, ShowTaxList));
    InDocMenuItem->Add(CreateMenuItem("Корректировки налоговых накладных", CheckLevel("Меню -1 Корректировки налоговых накладных")!=0, ShowTaxCors));
    InDocMenuItem->Add(CreateMenuItem("Журнал счетов", CheckLevel("Меню - 1 Журнал счетов")!=0, ShowBillList));
    InDocMenuItem->Add(CreateMenuItem("Контрольные обходы",CheckLevel("Меню - 1 Контрольные обходы")!=0, ShowInspect));
    InDocMenuItem->Add(CreateMenuItem("Планирование СЕБ", CheckLevel("Меню - 1 Планирование СЕБ")!=0));
     InDocMenuItem->Items[7]->Add(CreateMenuItem("Даные о полезном отпуске",CheckLevel("Меню - 1 Даные о полезном отпуске")!=0, ShowSebList));
     InDocMenuItem->Items[7]->Add(CreateMenuItem("Дополнение для 4 НКРЕ", CheckLevel("Меню - 1 Дополнение для 4 НКРЕ")!=0, ShowNKRE4));
     InDocMenuItem->Items[7]->Add(CreateMenuItem("Дополнение о отключениях", CheckLevel("Меню - 1 Дополнение о отключениях")!=0, ShowSwitch));
     InDocMenuItem->Add(CreateMenuItem("Журнал оборотов по актам", CheckLevel("Меню - 1 Журнал оборотов по актам")!=0, ShowSaldoAkt));
     InDocMenuItem->Add(CreateMenuItem("Списки физ.лиц по книгам", CheckLevel("Меню - 1 Списки физ.лиц по книгам")!=0, SelBookAbon));
     InDocMenuItem->Add(CreateMenuItem("Журнал технических работ", CheckLevel("Меню - 1 Журнал технических работ")!=0, ShowFiderWorksList));
     InDocMenuItem->Add(CreateMenuItem("Планирование технических работ", CheckLevel("Меню - 1 Планирование технических работ")!=0, ShowWorkPlan));
     InDocMenuItem->Add(CreateMenuItem("Счетчики для установки", true, ShowSSMet));
      InDocMenuItem->Add(CreateMenuItem("Журнал отключений", CheckLevel("Меню - 1 Журнал отключений")!=0, ShowAbonActionAll));

     InDocMenuItem->Add(CreateMenuItem("Отключения (старые)", CheckLevel("Меню - 1 Журнал отключений")!=0, ShowAbonSwitchAll));
     InDocMenuItem->Add(CreateMenuItem("Показания Аскуе на 0 часов ", CheckLevel("Меню - 1 Показания Аскуе на 0 часов")!=0,SelAskueDay ));
     InDocMenuItem->Add(CreateMenuItem("Потребление Аскуе ", CheckLevel("Меню - 1 Потребление Аскуе")!=0,SelAskueHour ));
     InDocMenuItem->Add(CreateMenuItem("Лимиты по Аскуе ", CheckLevel("Меню - 1 Лимиты по Аскуе")!=0,SelAskueLimit ));

  //Расчеты
//     CalcMenuItem->Add(CreateMenuItem("Налоговые накладные на аванс и оплату", CheckLevel("Меню - 2 Налоговые накладные на аванс и оплату")!=0,TaxAvansNumNotify));

   /*  CalcMenuItem->Add(CreateMenuItem("Налоговые накладные - 1 декада", CheckLevel("Меню - 2 Налоговые накладные на аванс и оплату")!=0,TaxDecade1));
     CalcMenuItem->Add(CreateMenuItem("Налоговые накладные - 2 декада", CheckLevel("Меню - 2 Налоговые накладные на аванс и оплату")!=0,TaxDecade2));
     */
   //  CalcMenuItem->Add(CreateMenuItem("Налоговые накладные - 1 декада", false,TaxDecade1));
    // CalcMenuItem->Add(CreateMenuItem("Налоговые накладные - 2 декада", false,TaxDecade2));

     CalcMenuItem->Add(CreateMenuItem("Налоговые накладные", CheckLevel("Меню - 2 Налоговые накладные на аванс и оплату")!=0,TaxDecade3));
     CalcMenuItem->Add(CreateSeparator());
     CalcMenuItem->Add(CreateMenuItem("Расчет пени и инфляции", CheckLevel("Меню - 2 Расчет пени и инфляции")!=0,CalcStrafAll));
     CalcMenuItem->Add(CreateMenuItem("Погашения счетов в ситуации дебет-кредит", CheckLevel("Меню - 2 Погашения счетов в ситуации дебет-кредит")!=0,CalcBillAll));
     CalcMenuItem->Add(CreateMenuItem("Плановые показатели", CheckLevel("Меню - 2 Плановые показатели")!=0,EqmPrognozBasiks));
     CalcMenuItem->Add(CreateMenuItem("Население для Формы 1", CheckLevel("Меню - 2 Население для Формы 1")!=0,RepNDSFizManual));
     CalcMenuItem->Add(CreateMenuItem("Загрузка потребления физлиц", CheckLevel("Меню - 2 Загрузка потребления физлиц")!=0,LoadFiz));
      UpdLevelStrong("Меню - 2 Загрузка АСКУЕ");
      CalcMenuItem->Add(CreateMenuItem("Загрузка из АСКУЕ", CheckLevel("Меню - 2 Загрузка АСКУЕ")!=0,AskueIn));
     UpdLevelStrong("Меню - 2 Выгрузка справочников");
    // UpdLevelStrong("Меню - 2 Загрузка справочников");

     CalcMenuItem->Add(CreateSeparator());
     if (flag_main==1)
     CalcMenuItem->Add(CreateMenuItem("Выгрузка справочников", CheckLevelStrong("Меню - 2 Выгрузка справочников")!=0,SprOut));
     if (flag_main==0)
     CalcMenuItem->Add(CreateMenuItem("Загрузка справочников", CheckLevel("Меню - 2 Загрузка справочников")!=0,SprIn));
   //  CalcMenuItem->Add(CreateSeparator());
     CalcMenuItem->Add(CreateMenuItem("Закрытие периода", CheckLevel("Меню - 2 Закрытие периода")!=0,CloseMonth));
     CalcMenuItem->Add(CreateMenuItem("Открытие периода", CheckLevel("Меню - 2 Открытие периода")!=0,OpenMonth));
  // справочники
    ServiseMenuItem->Add(CreateMenuItem("Оборудование ...", CheckLevel("Меню - 3 Оборудование ...")!=0));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Счетчики ...", CheckLevel("Меню - 3 Счетчики ...")!=0));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Счетчики", CheckLevel("Меню - 3. 1 Счетчики")!=0, EqmMeterBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Виды счетчиков", CheckLevel("Меню - 3. 1. 1 Виды счетчиков")!=0, EqiAMeterBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Классы напряжений", CheckLevel("Меню - 3. 1. 2 Классы напряжений")!=0, EqiVoltageBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Временные зоны", CheckLevel("Меню - 3. 1. 3 Временные зоны")!=0, EqkZoneBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Виды энергии", CheckLevel("Меню - 3. 1. 4 Виды энергии")!=0, EqiEnergyBtn));
//      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("?Классы точности", true, DoNot));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Методы подключения", CheckLevel("Меню - 3. 1. 5 Методы подключения")!=0, EqiHookupBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Фазность", CheckLevel("Меню - 3. 1. 6 Фазность")!=0, EqiPhaseBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Способы учета", CheckLevel("Меню - 3. 1. 7 Способы учета")!=0, EqiKindCountBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Схемы подключения", CheckLevel("Меню - 3. 1. 8 Схемы подключения")!=0, EqiSchemainsBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Типы счетчиков",  CheckLevel("Меню - 3. 1. 9 Типы счетчиков")!=0, EqiMeterBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Линии ...", CheckLevel("Меню - 3. 2 Линии ...")!=0));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Линии воздушные", CheckLevel("Меню - 3. 2. 1 Линии воздушные")!=0, EqmLineABtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Линии кабельные", CheckLevel("Меню - 3. 2. 2 Линии кабельные")!=0, EqmLineCBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
   //   ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("?Виды линий", true, DoNot));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Кабеля силовые", CheckLevel("Меню - 3. 2. 3 Кабеля силовые")!=0, EqiCableBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Провода", CheckLevel("Меню - 3. 2. 4 Провода")!=0, EqiCordeBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Опоры", CheckLevel("Меню - 3. 2. 5 Опоры")!=0, EqiPillarBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Подвески", CheckLevel("Меню - 3. 2. 6 Подвески")!=0, EqiPendantBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Петли заземления", CheckLevel("Меню - 3. 2. 7 Петли заземления")!=0, EqiEarthBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Материалы", CheckLevel("Меню - 3. 2. 8 Материалы")!=0, EqiMatBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Трансформаторы ...", CheckLevel("Меню - 3. 3. 1 Трансформаторы ...")!=0));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Трансформаторы силовые", CheckLevel("Меню - 3. 3. 2 Трансформаторы силовые")!=0, EqmCompBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Виды трансформаторов силовых",CheckLevel("Меню - 3. 3. 3 Виды трансформаторов силовых")!=0, EqiCompBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Трансформаторы измерительные", CheckLevel("Меню - 3. 3. 4 Трансформаторы измерительные")!=0, EqmCompIBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Виды трансформатов измерительных", CheckLevel("Меню - 3. 3. 5 Виды трансформатов измерительных")!=0, EqiCompIBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Компенсаторы ...", CheckLevel("Меню - 3. 4 Виды трансформатов измерительных")!=0));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("Компенсаторы", CheckLevel("Меню - 3. 4.1 Компенсаторы")!=0, EqmJackBtn));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("Виды компенсаторов", CheckLevel("Меню - 3. 4. 2 Виды компенсаторов")!=0, EqiJackBtn));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("Синхронность", CheckLevel("Меню - 3. 4. 3 Синхронность")!=0, EqiSyncBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Предохранители ...", CheckLevel("Меню - 3. 5. Предохранители ...")!=0));
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateMenuItem("Предохранители", CheckLevel("Меню - 3. 5. 1 Предохранители ")!=0, EqmFuseBtn));
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateMenuItem("Виды предохранителей", CheckLevel("Меню - 3. 5. 2 Виды предохранителей ")!=0, EqiFuseBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Коммутационное оборудование ...", CheckLevel("Меню - 3. 6.  Коммутационное оборудование ... ")!=0));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("Коммутационное оборудование", CheckLevel("Меню - 3. 6. 1 Коммутационное оборудование")!=0, EqmSwitchBtn));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("Виды коммутационного оборудования", CheckLevel("Меню - 3. 6. 2  Виды коммутационного оборудования")!=0, EqiSwitchBtn));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("Группы коммутационного оборудования", CheckLevel("Меню - 3. 6. 3  Группы коммутационного оборудования")!=0, EqiSwitchsGrBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Дизельные электростанции ...", CheckLevel("Меню - 3. 7  Дизельные электростанции ...")!=0));
    ServiseMenuItem->Items[2]->Items[6]->Add(CreateMenuItem("Дизельные электростанции", CheckLevel("Меню - 3. 7. 1  Дизельные электростанции")!=0, EqmDESBtn));
    ServiseMenuItem->Items[2]->Items[6]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[6]->Add(CreateMenuItem("Виды дизельных электростанций", CheckLevel("Меню - 3. 7. 2  Виды дизельных электростанций")!=0, EqiDESBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Точки учета", CheckLevel("Меню - 3. 8  Точки учета")!=0, EqmPointBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Трансформаторные подстанции", CheckLevel("Меню - 3. 9  Трансформаторные подстанции")!=0, EqmCompStBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Площадки", CheckLevel("Меню - 3.10  Площадки")!=0, EqmLandingBtn));

   ServiseMenuItem->Add(CreateMenuItem("Адрес ...", CheckLevel("Меню - 3.11  Адрес ...")!=0));
      ServiseMenuItem->Items[3]->Add(CreateMenuItem("Адреса ", CheckLevel("Меню - 3.11. 1  Адреса ")!=0, AdmAddressMineBtn));
      ServiseMenuItem->Items[3]->Add(CreateMenuItem("Списки населенных пунктов", CheckLevel("Меню - 3.11. 2  Списки населенных пунктов ")!=0, AdmCommAdrBtn));
      ServiseMenuItem->Items[3]->Add(CreateSeparator());
      ServiseMenuItem->Items[3]->Add(CreateMenuItem("Области", CheckLevel("Меню - 3.11. 3  Области")!=0, AdiDomainBtn));
      ServiseMenuItem->Items[3]->Add(CreateMenuItem("Районы", CheckLevel("Меню - 3.11. 4  Районы")!=0, AdiRegionBtn));
      ServiseMenuItem->Items[3]->Add(CreateMenuItem("Нас.Пункты", CheckLevel("Меню - 3.11. 5  Нас.Пункты")!=0, AdiTownBtn));
      ServiseMenuItem->Items[3]->Add(CreateMenuItem("Улицы", CheckLevel("Меню - 3.11. 6  Улицы")!=0, AdiStreetBtn));
   ServiseMenuItem->Add(CreateSeparator());
   ServiseMenuItem->Add(CreateMenuItem("Банки", CheckLevel("Меню - 3.12   Банки")!=0, CmiBankBtn));
   ServiseMenuItem->Add(CreateMenuItem("Валюты", CheckLevel("Меню - 3.13  Валюты")!=0, CmmCurrencyBtn));
   // ServiseMenuItem->Add(CreateMenuItem("Прейскурант услуг", true, DoNot));
   ServiseMenuItem->Add(CreateMenuItem("Тарифы ", CheckLevel("Меню - 3.14  Тарифы ")!=0,AciTarifBtn));
   ServiseMenuItem->Add(CreateMenuItem("Виды документов", CheckLevel("Меню - 3.15  Виды документов")!=0,DciMDocBtn));
   ServiseMenuItem->Add(CreateMenuItem("Параметры клиентов", CheckLevel("Меню - 3.16  Параметры клиентов")!=0, ClmSprParMBtn));
   ServiseMenuItem->Add(CreateMenuItem("Налоги и учетные ставки", CheckLevel("Меню - 3.17  Налоги и учетные ставки")!=0, CmiTaxBtn));
   ServiseMenuItem->Add(CreateMenuItem("Справочник строк для 4 НКРЕ", CheckLevel("Меню - 3.18  Справочник строк для 4 НКРЕ")!=0,ShowiNKRE4 ));
   ServiseMenuItem->Add(CreateMenuItem("Справочник Домов жеков", CheckLevel("Меню - 3.19  Справочник домов ЖЕКов")!=0,CmiGekBtn ));
    ServiseMenuItem->Add(CreateMenuItem("Справочник часов Аскуе", CheckLevel("Меню - 3.20  Справочник часов Аскуе")!=0,SelAskueMG ));

   ServiseMenuItem->Add(CreateSeparator());
// выходные документы
   OutDocMenuItem->Add(CreateSeparator());
   OutDocMenuItem->Add(CreateMenuItem("Стандартные", CheckLevel("Меню - 4. 1  Стандартные")!=0,ShowRepsForm));
   OutDocMenuItem->Add(CreateMenuItem("Пофидерный анализ", CheckLevel("Меню - 4. 2  Пофидерный анализ")!=0,ShowBalansForm));
   OutDocMenuItem->Add(CreateMenuItem("Выгрузка даных ...", CheckLevel("Меню - 4. 3   Формирование для СЕБ ...")!=0));
   OutDocMenuItem->Items[3]->Add(CreateMenuItem("Ежедневная СЕБ", CheckLevel("Меню - 4. 3. 1  Ежедневная ")!=0, SebRepDay));
   OutDocMenuItem->Items[3]->Add(CreateMenuItem("Ежемесячная СЕБ", CheckLevel("Меню - 4. 3. 1  Ежемесячная ")!=0, SebRepMonth));
   OutDocMenuItem->Items[3]->Add(CreateMenuItem("Выгрузка CALL-центра", CheckLevel("Меню - 4. 3. 2  Выгрузка CALL-центра")!=0, ExportCall));

   //OutDocMenuItem->Items[3]->Add(CreateMenuItem("Ввод даных для  4 НКРЕ", true, SebRepMonth));
  // OutDocMenuItem->Add(CreateMenuItem("Настройка отчетов", true,RepSprBtn));

  // Настройки !!!!!!!
    /*
    TWTQuery *QueryT = new  TWTQuery(this);
    QueryT->Sql->Clear();
      QueryT->Sql->Add("select sys_fill_full_lvl()");
    QueryT->ExecSql();
      */
     UpdLevelStrong("Меню - 5. 4   Администрирование ...");
     UpdLevelStrong("Меню - 5. 4. 1  Пользователи и пароли");

    ToolsMenuItem->Add(CreateMenuItem("Включить протокол SQL", true, ShowLog));
    ToolsMenuItem->Add(CreateMenuItem("Настройка системных переменных", CheckLevel("Меню - 5. 2   Настройка системных переменных ")!=0, ShowSys));
      AnsiString Prompt1=StartupIniFile->ReadString("Base","PromptLogin","0");
         ToolsMenuItem->Add(CreateMenuItem("Календарь", CheckLevel("Меню - 5. 3   Календарь ")!=0, Calendar));
    ToolsMenuItem->Add(CreateMenuItem("Администрирование ...", CheckLevelRead("Меню - 5. 4   Администрирование ...")!=0));
    ToolsMenuItem->Items[3]->Add(CreateMenuItem("Пользователи и пароли", CheckLevelStrong("Меню - 5. 4. 1  Пользователи и пароли")!=0, Users));
    ToolsMenuItem->Items[3]->Add(CreateMenuItem("Смена пароля пользователем", CheckLevelStrong("Меню - 5. 4. 2  Смена пароля пользователем")!=0,ChangePwd ));
    ToolsMenuItem->Items[3]->Add(CreateMenuItem("Среда доступа", CheckLevel("Меню - 5. 4. 3  Среда доступа")!=0, Enviroment));
  //  ToolsMenuItem->Items[3]->Add(CreateMenuItem("Права доступа", true, CheckEnv));
    ToolsMenuItem->Items[3]->Add(CreateMenuItem("Монитор", CheckLevelStrong("Меню - 5. 4. 4  Таблицы программы")!=0, Monitor));

     //  ToolsMenuItem->Items[3]->Add(CreateMenuItem("Права доступа", true, DoNot));
     //  ToolsMenuItem->Items[3]->Add(CreateMenuItem("Список", true, DoNot));
     //  ToolsMenuItem->Items[3]->Add(CreateMenuItem("Мониторинг ...", true));
     //  ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("Текущая работа ", true, DoNot));
     //  ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("Журнал", true, DoNot));

   ToolsMenuItem->Add(CreateSeparator());
   ToolsMenuItem->Add(CreateMenuItem("О программе", true, ShowVers));
    if (Prompt1=="1")
        ToolsMenuItem->Add(CreateMenuItem("Настройка подключения", CheckLevel("Меню - 5. 4. 5  Настройка подключения")!=0,ReBasa ));
        ToolsMenuItem->Add(CreateMenuItem("Таблицы программы", CheckLevel("Меню - 5. 4. 6  Таблицы программы")!=0,BasaTable ));

  // Временный запрос (нужен для обновления полей и другое)
  QueryTmp = new  TWTQuery(this);
  QueryInterZap = new  TWTQuery(this);
  Options = Options<<foExit>>foHelp;


  TWTToolBar *ToolBar = new TWTToolBar(this);
  ToolBar->Parent = this;
  ToolBar->ID = "Главная панель";

  // добавляем кнопки в главную панель
  if (CheckLevel("Меню - Новый Л.С. (кнопка)")!=0)
  ToolBar->AddButton("CardClient", "Новый Л.С.", CliClientMBtn);
  ToolBar->AddButton("|", NULL, NULL);
  if (CheckLevel("Меню - Справочники адресов (кнопка)")!=0)
  ToolBar->AddButton("AdiAddress", "Справочники адресов", AdmAddressMineBtn);
  if (CheckLevel("Меню - Банковские документы (кнопка)")!=0)
  ToolBar->AddButton("Baxs", "Банковские документы", AciHeadPayBtn);
  ToolBar->AddButton("|", NULL, NULL);
   if (CheckLevel("Меню - Пофидерный анализ (кнопка)")!=0)
  ToolBar->AddButton("Analiz", "Пофидерный анализ", ShowBalansForm);
  ToolBar->AddButton("AUTO", "", ShowLog);
  ToolBar->AddButton("foots", "Пользователь", ReLogin);

    if (Prompt1=="1")
    ToolBar->AddButton("loadBasa", "Смена базы", ReBasa);
  MainCoolBar->AddToolBar(ToolBar);
  // ---------------------------------------------
  Application->OnMessage = OnApplicationMessage;      ///////
 };

 void _fastcall TMainForm::ExitParamsGrid(TObject *Sender){

 TWTDBGrid * GridEx;
 GridEx= ((TWTDBGrid *)Sender);
 if (GridEx->Table->isInserted() || GridEx->Table->isModified())
{    GridEx->Table->ApplyUpdates();
    if (GridEx->DataSource->DataSet->State==dsEdit || GridEx->DataSource->DataSet->State==dsInsert)
    {
     GridEx->DataSource->DataSet->Post();
  };
};
};


void _fastcall TMainForm::EnterParamsGrid(TObject *Sender){
 TWTDBGrid * GridEx;
 GridEx= ((TWTDBGrid *)Sender);
 GridEx->DataSource->DataSet->Refresh();
};


void __fastcall TMainForm::OnApplicationMessage(TMsg & Msg, bool & Handled)
{
   if (Msg.message == WM_MOUSEWHEEL)
     {
       if (dynamic_cast<TDBGrid*>(Screen->ActiveControl))
        {
         short zDelta = HIWORD(Msg.wParam);
           if (zDelta !=0)
            {
              Msg.lParam = 0;
              Msg.message = WM_KEYDOWN;
               if (zDelta >0 )
                 {Msg.wParam = VK_UP;}
                 else
                 {Msg.wParam = VK_DOWN;}
 
       }
 
   }
  }
}


void _fastcall TMainForm::DoNot(TObject *Sender){
ShowMessage(" Режим пока не работает! ");
}


void _fastcall TMainForm::CallDoc(TObject *Sender){
// Application->CreateForm(__classid(TModule2DB), &Module2DB);
 //Application->CreateForm(__classid(TMain_doc), &Main_doc);


// Main_doc->Visible=true;

}

AnsiString  _fastcall TMainForm::GetNameFromBase(AnsiString Tablez,AnsiString Fieldz,int idz,AnsiString Wherez)
{  AnsiString  Zapr="Select "+Fieldz+ " from "+ Tablez;
   if (idz!=NULL)
    Zapr=Zapr+ " where id="+idz;
   else
    if (Wherez!=NULL)
     Zapr=Zapr+ "where "+Wherez;
   return GetValueFromBase(Zapr);
}

AnsiString _fastcall TMainForm::GetValueFromBase(AnsiString QueryBas)
{ AnsiString Val="";
   TWTQuery *QuerBas=new TWTQuery(this);
 QuerBas->Sql->Clear();
 QuerBas->Sql->Add(QueryBas);
 QuerBas->Open();
 if (QuerBas->RecordCount>0)
  for(int i = 0; i < QuerBas->FieldCount; i++)
    Val = Val + QuerBas->Fields->Fields[i]->Value + " ";
    Val=ALLTRIM(Val);
 QuerBas->Close();
 delete QuerBas;
 //Val.SetLength(Val.Length()-1);
 return Val;
}

int _fastcall TMainForm::GetIdFromBase(AnsiString QueryBas,AnsiString Nfield)
{ int Val=0;
 TWTQuery *QuerBas=new TWTQuery(this);
 QuerBas->Sql->Clear();
 QuerBas->Sql->Add(QueryBas);
 QuerBas->Open();
 if (QuerBas->RecordCount>0)
  for(int i = 0; i < QuerBas->FieldCount; i++)
   if (QuerBas->Fields->Fields[i]->FieldName==Nfield)
    Val = QuerBas->Fields->Fields[i]->AsInteger;
 QuerBas->Close();
 delete QuerBas;
 return Val;
}

TDateTime _fastcall ValidDate(TDateTime Date) {
unsigned short year, month, day;
bool err = true;
  Date.DecodeDate(&year, &month, &day);
  // Дней не может быть больше 31
   while (err) {
    err = false;
    try {
      Date = EncodeDate(year, month, day);
    }
    catch(...) {
      err = true;
      if (day>0)   day--; else day++;
    }
  }
  return Date;
}


TDateTime _fastcall CalcDate(TDateTime Date,int dayp,int count,int ident) {
unsigned short year, month, day;
bool err = true;
  Date.DecodeDate(&year, &month, &day);
  day=dayp;
  // Дней не может быть больше 31
if (ident==1)
   while (err) {
      err = false;
      try {
         Date = EncodeDate(year, month, day+count);
      }
      catch(...) {
        err = true;
       if (day>0)   day--; else day++;
       }
};
if (ident==30)
{   int mmonth=0;
    int myear=0;
    mmonth=month+count;
     if (mmonth>12) {
        myear=mmonth%12;
         mmonth=mmonth-(mmonth%12)*12;
           }
      if (mmonth<0) {
        myear=-mmonth%12;
         mmonth=mmonth+(mmonth%12)*12;
           }
      if (mmonth==0) {
        myear=-1;
         mmonth=12;
           }


 while (err) {
   err = false;
   try {
         Date = EncodeDate(year+myear, mmonth, day);
      }
   catch(...) {
     err = true;
     if (day>0)    day--; else day++;
   }
}
}
  return Date;
}

TDateTime _fastcall TMainForm::PeriodDate(int id_client,int flag) {
unsigned short year, month, day;
unsigned short yearb, monthb, dayb;
unsigned short yeare, monthe, daye;
bool err = true;
AnsiString perd=GetValueFromBase("select dt_indicat from clm_statecl_tbl where id_client="+ToStrSQL(id_client));
AnsiString perp=GetValueFromBase("select period_indicat from clm_statecl_tbl where  id_client="+ToStrSQL(id_client));
 if (perd.IsEmpty()) perd="0";
 if (perp.IsEmpty()) perp="0";

  int periodday=StrToInt(perd);
  int periodper=StrToInt(perp);
  TWTQuery *QMMGG=new TWTQuery (this);
  QMMGG->Sql->Add("select fun_mmgg() as dat");
  QMMGG->Open();
  TDateTime present_mmgg=QMMGG->FieldByName("dat")->AsDateTime;

//  TDateTime present_mmgg=StrToDate(GetValueFromBase("select value_ident from syi_sysvars_tmp where ident='mmgg'"));
  present_mmgg.DecodeDate(&year,&month,&day);
  TDateTime begin_mmgg;
  if (periodper==1)
    {
      begin_mmgg=ValidDate(CalcDate(present_mmgg,periodday,-periodper,30));
    };

  TDateTime end_mmgg=ValidDate(CalcDate(present_mmgg,periodday,0,1));


  if (flag==0)
   return begin_mmgg;
  else return end_mmgg;

}


void __fastcall TMainForm::CloseMonth(TObject *Sender)
{
 if (Ask("Вы уверены, что хотите закрыть месяц ? "))
 {
  TWTQuery *QueryCl=new TWTQuery(this);

  try {
  QueryCl->Sql->Clear();
  QueryCl->Params->Clear();
   QueryCl->Sql->Add("select  clm();");
   QueryCl->ExecSql();


  } catch (EDatabaseError &e)
   {
     ShowMessage("Ошибка "+e.Message.SubString(8,200));
      return;
    };
  ShowMessage("Месяц закрыт");
  }
  else
   ShowMessage("Закрытие месяца отменено пользователем!");
   TWTQuery *QCh= new TWTQuery(this);
   QCh->Sql->Clear();
   QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='mmgg'");
   QCh->Open();

  AnsiString  Period=QCh->FieldByName("value_ident")->AsString;
  //Application->Title =Application->Title+"         Период  _______ "+Period ;
   Application->MainForm->Caption = "Енергия  Период  _______"+Period ;

}


void __fastcall TMainForm::CalcStrafAll(TObject *Sender)
{
   TWTQuery *QCh= new TWTQuery(this);
   QCh->Sql->Clear();
   QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='mmgg'");
   QCh->Open();

  AnsiString  Period=QCh->FieldByName("value_ident")->AsString;

 if (Ask("Период   --- "+Period + " ---  Продолжить  ? "))
 {
  TWTQuery *QueryCl=new TWTQuery(this);

  try {
  QueryCl->Sql->Clear();
  QueryCl->Params->Clear();
   QueryCl->Sql->Add("select  all_calc_peninfl()");
   QueryCl->ExecSql();


   
  } catch (...)
   {
     ShowMessage("Ошибка ");
      return;
    };
  ShowMessage("Счета выписаны! ");
  }
  else
   ShowMessage("Отменено пользователем!");

}

void __fastcall TMainForm::OpenMonth(TObject *Sender)
{
 Application->CreateForm(__classid(TFOpenMonth), &FOpenMonth);
 FOpenMonth->ShowModal();
}

void __fastcall TMainForm::Calendar(TObject *Sender)
{
 Application->CreateForm(__classid(TfCalend), &fCalend);
 fCalend->ShowModal();
}


void __fastcall TMainForm::Users(TObject *Sender)
{ TfUser *TUser=new TfUser (this);

}

void __fastcall TMainForm::ShowSaldoAkt(TObject *Sender)
{ TfSaldAkt *fSaldAkt=new TfSaldAkt (this);
}

void __fastcall TMainForm::Enviroment(TObject *Sender)
{ TfEnviroment *fEnviroment=new TfEnviroment (this);
}

void __fastcall TMainForm::ChangePwd(TObject *Sender)
{ Application->CreateForm(__classid(TFUserPwd), &FUserPwd);
   TWTQuery *QUser=new TWTQuery(this);
   QUser->Sql->Clear();
   QUser->Sql->Add("select value_ident from syi_sysvars_tmp where ident='last_user'");
   QUser->Open();
   if (!(QUser->Eof))
         FUserPwd->Show(this,QUser->FieldByName("value_ident")->AsInteger);

};
void __fastcall TMainForm::CheckEnv(TObject *Sender)
{

};


void __fastcall TMainForm::Monitor(TObject *Sender)
{

};
void __fastcall TMainForm::CalcBillAll(TObject *Sender)
{
 if (Ask("Перед данной обработкой необходимо сделать дамп базы! \nВыполнили? "))
 {

  TWTQuery *QueryCl=new TWTQuery(this);
    TWTQuery * QSys = new TWTQuery(Application);
  QSys->Options<< doQuickOpen;
  QSys->RequestLive=false;
  QSys->CachedUpdates=false;
//  QSys->Transaction->AutoCommit=false;
  AnsiString sqlmmgg=" select value_ident from syi_sysvars_tbl where ident='mmgg'";
  QSys->Sql->Add(sqlmmgg);
  QSys->Open();
  AnsiString mg=QSys->FieldByName("value_ident")->AsString;

  AnsiString sqlstrs=" update syi_sysvars_tmp set value_ident=:mg \
   where ident='mmgg'";
  QSys->Sql->Clear();
  QSys->Sql->Add(sqlstrs);
  QSys->ParamByName("mg")->AsString=mg;


  try {
  QueryCl->Sql->Clear();
  QueryCl->Params->Clear();
   QueryCl->Sql->Add("select  err_pay_bill_all();");
   if (Ask("Вы еще уверены, что желаете продолжить выполнение?"))
  {  QueryCl->ExecSql();
  QSys->ExecSql();
     QueryCl->Sql->Clear();
     QueryCl->Params->Clear();
      QueryCl->Sql->Add("select  close();");
      QueryCl->ExecSql();
   }
   else   ShowMessage("Отменено пользователем!");
         } catch (...)
   {
     ShowMessage("Ошибка ");
      return;
    };
  ShowMessage("Выполнено! Теперь смотрите оборотную ведомость.");
  }
  else
   ShowMessage("Сделайте дамп базы! ");

}



void __fastcall TMainForm::On_Start_Programm()
{
   TWTQuery *QueryCl=new TWTQuery(this);
     QueryCl->Transaction->TransIsolation = ptDefault;
  try {
  QueryCl->Sql->Clear();
  QueryCl->Params->Clear();
  QueryCl->Sql->Add("select crt_ttbl()");
  QueryCl->ExecSql();


  // QueryCl->Sql->Add("select  clmd();");
  // QueryCl->ExecSql();
    // crt_ttbl()

  } catch (...)
   {
     ShowMessage("Ошибка ");
      return;
    };

      TWTQuery *QueryV=new TWTQuery(this);
     QueryV->Transaction->TransIsolation = ptDefault;
  try {
  QueryV->Sql->Clear();
  QueryV->Params->Clear();
  QueryV->Sql->Add("select * from syi_version where id=(select max(id) from syi_version)");
  QueryV->Open();
  if (QueryV->FieldByName("vers_prg")->AsInteger!=Version)
   { ShowMessage(" Текущая версия программы " + IntToStr(Version) +" База обновлена до " +IntToStr(QueryV->FieldByName("vers_prg")->AsInteger)+  " Приведите в соответствие!!");
             return;
   }
  }    catch (...)
   {
     ShowMessage("Не установлено последнее обновление скриптов! Сообщите вашему программисту! ");
      return;
    };



}
void __fastcall TMainForm::ShowSys(TObject *Sender)
{
Application->CreateForm(__classid(TFShowSys), &FShowSys);
FShowSys->ShowModal();
};

void __fastcall TMainForm::ShowVers(TObject *Sender)
{
Application->CreateForm(__classid(TFShowVers), &FShowVers);
FShowVers->Show(Version);
};

void _fastcall TMainForm::SebRepDay(TObject *Sender)
{ if (Ask("Сформировать ?"))
 {
  TDateTime Dat;
  TWTQuery * QueryZapD=new TWTQuery(this);
  ShortDateFormat="yyyy-mm-dd";
  QueryZapD->Sql->Clear();
    QueryZapD->Sql->Add("select max(p.mmgg,b.mmgg) as mmgg from \
      (select max(mmgg) as mmgg from acm_pay_tbl ) as p ,\
       (select max(mmgg) as mmgg from acm_bill_tbl ) as b  ");
    QueryZapD->Open();
 if (!(QueryZapD->Eof))
 { Dat=QueryZapD->FieldByName("mmgg")->AsDateTime;
    //QueryZap->Params->Clear();

   ShortDateFormat="yyyy-mm-dd";
  //TDateTime DatOtc = SetCentury(Dat);

  TWTQuery * QueryZap=new TWTQuery(this);

    QueryZap->Sql->Clear();
    QueryZap->Params->Clear();
    QueryZap->Sql->Add("select seb_all(1,"+ToStrSQL(DateToStr(Dat))+")");
    QueryZap->ExecSql();
   ShortDateFormat="dd.mm.yyyy";
 };
 };
};

void _fastcall TMainForm::SebRepMonth(TObject *Sender)
{
  Form = new TWTParamsForm(this, "Отчеты для СЕБ");
  Form->OnAccept = SebReport;
  TStringList *SQL = new TStringList();

  Form->Params->AddDate("Месяц",90,true);
  Form->Params->Get(0)->Value = BOM(Date());

  Form->TForm::ShowModal();
  Form->Close();
};


void _fastcall TMainForm::SebReport(TWTParamsForm *Sender, bool &flag)
{
  Form->Hide();

  TDateTime Dat = Form->Params->Get(0)->Value;
   ShortDateFormat="yyyy-mm-dd";
  //TDateTime DatOtc = SetCentury(Dat);

  TWTQuery * QueryZap=new TWTQuery(this);

    QueryZap->Sql->Clear();
    QueryZap->Params->Clear();
    QueryZap->Sql->Add("select seb_all(2,"+ToStrSQL(DateToStr(Dat))+")");
    QueryZap->ExecSql();
   ShortDateFormat="dd.mm.yyyy";
  };


void _fastcall TMainForm::ExportCall(TObject *Sender)
{
  TWTQuery * QueryZap=new TWTQuery(this);
    QueryZap->Sql->Clear();
    QueryZap->Params->Clear();
    QueryZap->Sql->Add("select export_callcentr()");
    QueryZap->ExecSql();
    ShowMessage("Выгрузка завершена!");
  };


void _fastcall TMainForm::LoadFiz(TObject *Sender)
{ char* str_f;
char* str_f1;
  char* str_s;
   AnsiString tsql;
   AnsiString tstr;
   AnsiString tsql1;
  TOpenDialog  *OpenDBF= new  TOpenDialog(NULL);
  TWTQuery *QuerIns1;
  AnsiString CurrDir=GetCurrentDir();
     TReplaceFlags flags;
   flags<<rfReplaceAll;
   flags<<rfIgnoreCase;
   TDateTime t1=Now();
  char *fn;
  QuerIns1 = new  TWTQuery(this);
  OpenDBF->Title = "Выберите файл";
  if (OpenDBF->Execute())
  {  if (FileExists(OpenDBF->FileName))
     { FILE * fin;
        //*fn=OpenDBF->FileName.c_str();
       fin=fopen(OpenDBF->FileName.c_str(),"rb");
       int i=1;
       if ((str_f = (char *) malloc(500)) == NULL)
    {
       printf("Not enough memory to allocate buffer\n");
       exit(1);  /* terminate program if out of memory */
    }
       if ((str_f1 = (char *) malloc(500)) == NULL)
    {
       printf("Not enough memory to allocate buffer\n");
       exit(1);  /* terminate program if out of memory */
    }

           if ((str_s = (char *) malloc(500)) == NULL)
    {
       printf("Not enough memory to allocate buffer\n");
       exit(1);  /* terminate program if out of memory */
    }
       QuerIns1->Sql->Clear();
         QuerIns1->Sql->Add("delete from tmp_load");
         QuerIns1->ExecSql();
//         ShowMessage("");
         if (!(Ask("Вставка 20 000 строк длится 15 минут. Соответственно, вы можете оценить время, которое будет продолжаться загрузка.      Продолжить загрузку?")))
           return;

        while (!feof(fin))
        {
             Application->ProcessMessages();
             fgets(str_f,500,fin);
             OemToChar(str_f,str_s);
             //str_f1=strncpy(str_f1,str_s,strlen(str_s)-2);
             tstr=str_s;
             tstr=StringReplace( tstr,"'","''",flags);
             tsql="insert into tmp_load (str_sql) values ("+ToStrSQL(tstr)+")";


                          QuerIns1->Sql->Clear();
               QuerIns1->Sql->Add(tsql);
               //QuerIns1->Sql->
             //  QuerIns1->ParamByName("pstr_sql")->AsString=str_f;
               QuerIns1->ExecSql();
         }
        fclose(fin);
        //ShowMessage("Копирование завершено.");
               QuerIns1->Sql->Clear();
        // QuerIns1->Sql->Add("delete from adi_build_tbl");
        /* try
           {
         QuerIns1->ExecSql();
          }
           catch ()     //Exception &exception
           {

           } */
        QuerIns1->Sql->Clear();
        QuerIns1->Sql->Add("select * from tmp_load where str_sql like 'insert%'");
         QuerIns1->Open();
        TWTQuery * QuerLoad=new TWTQuery(this);
        while (!(QuerIns1->Eof))
        {  QuerLoad->Sql->Clear();
           QuerLoad->Sql->Add(QuerIns1->FieldByName("str_sql")->AsString);
           try
           {        QuerLoad->ExecSql();
           }
           catch (Exception &exception)
           {

           }
          QuerIns1->Next();
        };
        QuerIns1->Sql->Clear();
        QuerIns1->Sql->Add("select load_demand_all(1)");
        try
        {        QuerIns1->ExecSql();
         }
        catch (Exception &exception)
        {
         Application->ShowException(&exception);
        }

         QuerIns1->Sql->Clear();
        QuerIns1->Sql->Add("select load_demand_all(0)");
        try
        {        QuerIns1->ExecSql();
         }
        catch (Exception &exception)
        {
         Application->ShowException(&exception);
        }


        QuerIns1->Sql->Clear();
        QuerIns1->Sql->Add("select sum(value)::::int as val,count(*)::::int as cnt from acm_privdem_tbl,(   select max(mmgg) as maxmg  \
           from acm_privdem_tbl) as maxm where mmgg=maxmg");
        QuerIns1->Open();
        int kvt;
        kvt= QuerIns1->FieldByName("val")->AsInteger;
         int cnt;
        cnt= QuerIns1->FieldByName("cnt")->AsInteger;

         TDateTime t2=Now();
         AnsiString mess= " Вставлено --- "+ToStrSQL(cnt)+ " строк " + " ---"+ToStrSQL(kvt)+ "квт." +"             "+  "C "+TimeToStr(t1)+ "  по " +TimeToStr(t2);
         ShowMessage("Копирование завершено."+ mess);

      };
  };
  SetCurrentDir(CurrDir);
};


void _fastcall TMainForm::SprOut(TObject *Sender)
{ char* str_f;
char* str_f1;
  char* str_s;

  Application->CreateForm(__classid(TftpForm), &ftpForm);
  ftpForm->Show(1);

};
void _fastcall TMainForm::SprIn(TObject *Sender)
{ char* str_f;
char* str_f1;
  char* str_s;

  Application->CreateForm(__classid(TftpForm), &ftpForm);
  ftpForm->Show(0);

};

void _fastcall TMainForm::AskueIn(TObject *Sender)
{ char* str_f;
char* str_f1;
  char* str_s;

  Application->CreateForm(__classid(TftpForm), &ftpForm);
  ftpForm->Show(3);

};
